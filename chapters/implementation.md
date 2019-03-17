# Changes to 3DF

## Indexing

In order to make use of the worst-case optimal dataflow-join framework
described in [[@TODO]] we could no longer maintain attributes as just
an arranged collection of `(e, v)` pairs. The implementation of the
`PrefixExtender` trait for attributes requires two additional traces,
one to keep track of the number of extensions the attribute would
propose for a given prefix and a trace indexed in a way suitable to
efficiently validate proposals made by other extenders.

Additionally, attributes might be placed at a stage in the delta query
pipeline, at which prefixes already bind the value symbol. In that
case, reversed versions of all three of the above arrangements must be
at hand.

We therefore introduced a `CollectionIndex` structure which holds all
three arrangements for a given direction and a given attribute. 3DF
workers maintain separate mappings from attribute names to their
forward and reverse collection indices. This simplifies the types and
ownership involved.

Although not client-configurable at the time of this writing, it makes
sense to skip the reverse indices for certain attributes. An example
would be one-way mappings used for string interning, or unary
attributes indicating categorical features.

## Lazy Synthesis

In the [[Eager Synthesis]] scenario we have seen that demand-driven
synthesis of query plans is a pre-requisite to needlessly
materializing rules, which materialize large numbers of tuples, but
would never even be used without other constraints of higher
selectivity.

As explained in [[Background/3DF]], 3DF used to synthesize all rules
eagerly. Over the course of this work, we extended 3DF workers with a
rule store. Upon receiving a `Register` command, workers now merely
store the provided plan (assuming it doesn't clash with a known rule
of the same name). Synthesis of a rule `q` will only happen, once the
first `Interest` command for `q` is received.

A few more changes were required. In particular, a mechanism to gather
query dependencies had to be added. Queries can depend on attributes
and on other rules (that were registered in advance). This captured by
a simple struct:

``` clojure
/// Description of everything a plan needs prior to synthesis.
pub struct Dependencies {
    /// NameExpr's used by this plan.
    pub names: HashSet<String>,
    /// Attributes queries in Match* expressions.
    pub attributes: HashSet<Aid>,
}
```

Like all other aspects of synthesis, `Dependency` structs are
collected recursively starting at the leafs of the query plan (data
patterns such as `MatchA` and references via `NameExpr`). The
resulting set of rules requiring synthesis is brought into a canonical
order, to ensure that the same exact dataflow graph is created on all
workers.

@TODO Talk about deciding between depending on NameExpr by name or resolving into dependencies?
@TODO Talk about resulting unification of NameExpr and RuleExpr

## Logging and Instrumentation

A fair bit of instrumentation is necessary in order to monitor the
dataflow graph as it evolves over time, the number of tuples held in
arrangements, and many other metrics.

To that end, Timely Dataflow provides an extensible set of internal
dataflow streams, onto which internal events are published. Logged
events include among others the creation, shutdown, and scheduling of
operators, activity on communication channels, and progress tracking.

Differential Dataflow uses the same subsystem to provide additional
information about the creation and merging of trace batches. These are
sufficient to infer, for any relevant time, the number of arranged
tuples maintained at each arrangement in the dataflow.

Deriving relevant signals from the stream of logging events
dynamically via 3DF's reactive query engine seemed like a natural
fit. We created two new 3DF sources, `TimelyLogging` and
`DifferentialLogging`.

The `TimelyLogging` source allows clients to source only the subset of
logging attributes that they are interested in (see [[LISTING
BELOW]]). It also performs some pre-processing on the raw logging
streams, converting hierarchical scope addresses into the
corresponding edges of the dataflow graph.

``` clojure
(register-source
  {:TimelyLogging
   {:attributes [:timely.event.operates/name
                 :timely.event.operates/shutdown?]}})
```

Similarly, the `DifferentialLogging` source will not expose batching
and merging events directly, but rather derive from them changes to
the number of tuples held by each arrangement. Batch events imply an
increase in the number of tuples held (by the size of the batch),
merge events imply a decrease (the difference between the compacted
size of the merge result and the sum of the size of the input
batches).

Taken together, this makes it easy to write queries such as the
following, asking for the total number of tuples arranged at operators
that haven't been shut down.

``` clojure
;; total number of tuples arranged at alive operators

[:find (sum ?size)
 :where
 [?x :differential.event/size ?size]
 (not [?x :timely.event.operates/shutdown? true])]
```

## Bindings

Over the course of this work it became evident that a few extensions
to the query plan representation would be necessary to (a) better
utilize the new primitive offered by worst-case optimal, n-way join
processing and (b) canonicalize plan representation in order to expose
more opportunities for sharing dataflows between multiple clients, as
described in [[@TODO]].

From the discussion in Veldhuizen[0] we learn that the Leapfrog
Triejoin worst-case optimal join algorithm can be utilized to
implement many common features of relational query engines:
conjunctions (joins), disjunctions (unions), negations (antijoins),
and filtering by various predicates. This is achieved by additional
implementations of the core trie iterator interface. Similar
extensions exist within the worst-case optimal dataflow-join framework
due to Ammar et al.[1], which we have integrated into 3DF as part of
this work.

[@TODO Recall] that any participant in a worst-case optimal dataflow
join must implement the `PrefixExtender` trait described in
[[@TODO]].

For the purposes of the query language, we will refer to such
implementations as *bindings*, for their property of binding possible
values to variables. We've provided `PrefixExtender` implementations
for attribute bindings, constants, binary predicates, and negation.

Some bindings, such as for predicates and negation, are exclusively
constraining (shrinking the space of possible values for a given
variable), others, such as attributes and constants, can also provide
values.

Converting between the existing clause language described in [[@TODO]]
and this new language of bindings is straightforward. The basic data
pattern `[?e :a ?v]` is expressed as `MatchA(?e, :a, ?v)` and as
`attribute(?e, :a, ?v)` respectively. `MatchEA` and `MatchAV` can be
broken down into a `attribute(?e, :a, ?v)` combined with a
`constant(?e, x)` or `constant(?v, x)` respectively.

The existing two-way join operator `Join(left, right)` is resolved as
the union of resolving both child plans into their bindings.

@TODO antijoin

`Filter` plan stages map directly onto the corresponding
`binary_predicate` binding.

Projections, aggregations, disjunctions, and functional transforms
remain unchanged.

Splitting off constant bindings, transforms, aggregations, and
projections from the heavy-lifting required to resolve conjunctions
has the added benefit of exposing additional opportunities for sharing
dataflows between clients. Consider the following two queries.

``` clojure
[:find ?person
 :where
 (rule ?person)
 [?person :person/name "Alice"]]
 
[:find ?person
 :where
 (rule ?person)
 [?person :person/name "Bob"]]
```

We've described the various trade-offs to factor-in when considering
to share the evaluation of `rule` between the two clients in chapter
[[@TODO]]. Here we merely want to call attention to the resulting
representation in the language of bindings.

``` rust
[into_bindings("rule"),
 attribute(?person, :person/name, ?name)
 constant(?name, "Alice")]
 
[into_bindings("rule"),
 attribute(?person, :person/name, ?name)
 constant(?name, "Bob")] 
```

## Source

[0] [Veldhuizen, Leapfrog Triejoin: A Simple, Worst-Case Optimal Join Algorithm](../sources/leapfrog-triejoin.pdf)
[1] [Ammar, McSherry et al., Distributed Evaluation of Subgraph Queries Using Worst-case Optimal Low-Memory Dataflows](../sources/wco-differential.pdf)

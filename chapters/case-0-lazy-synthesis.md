# Case 0: Eager Synthesis

## Problem

Working with a declarative query language such as 3DF, users are
encouraged to think of their domain in terms of attributes, entities,
and the relations that govern their interaction. 3DF, borrowing from
Datalog, provides the *rule* — fundamentally a named disjunction of
conjunctions — as its core abstraction. Rules may refer to each other
or recursively to themselves.

Domain logic, constraints, and higher-level relationships are all
expressed as rules.

It is often the case, that a developer identifies a new rule that is
completely sensible as an abstraction in their domain, but when
evaluated on its own, materializes enormous amounts of tuples. 

This is a prime example of violating the robustness property
identified in [[Problem Description]]: The user is merely following
the declarative interaction model we are actively encouraging, and
gets punished for doing so!

## Example

An example of this problematic scenario in the context of the social
graph domain is any transitive relation between persons, such as
`:person/knows` or `:person/friends-with`. A common rule for
recursively capturing such transitive closures might be:

``` clojure
[(knows ?a ?b) [?a :person/knows ?b]]
[(knows ?a b) [?a :person/knows ?x] (knows ?x ?b)]
```

From the developers perspective, this rule is tremendously useful,
because it abstracts away a complex (in the distributed setting),
iterative graph exploration problem for an arbitrary number of hops.

For 3DF on the other hand, immediately materializing this rule into a
Differential arrangement has disastrous consequences, as it will
materialize and index(!) the full transitive closure of the social
graph.

## Remedy



## Big Picture

The problem of eager materialization, explored in this scenario, hints
at a much more general trade-off: Abstractions such as the `knows`
rule increase our potential for re-use of computations across many
clients, but might dramatically increase the magnitude of the result
set.

As is established practice in query planning, pushing more selective
downstream operations back up into these generic rules can greatly
improve performance, at the cost of increased *specialization* of the
dataflow (and thus reduced potential for sharing it between
clients). This problem is compounded by the fact that a single bad
decision, when implementing a dataflow that many other flows depend
on, means we are stuck with the potentially horrific plan until all
downstream computations are shut down.

We will explore this trade-off in much greater detail in the following
scenarios.

For now, we observe that eager materialization is problematic in any
case, because we lose the ability to even reason about what the best
evaluation strategy is.

[@TODO first user interested in a query has to wait longer, is that a
problem?]

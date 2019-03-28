# Known Techniques

## Rule Engines

Rule-based systems allow for the expression of business rules, often
in a high-level language. Registered rules will then be continuously
evaluated against an input stream of business events. 

It quickly becomes infeasible to re-evaluate all rules on every
input. Specialized algorithms are employed to efficiently determine
the subset of rules that might possibly be affected by a new
input. Those rules are then re-evaluated. The RETE algorithm due to
Forgy[[@TODO]] is the archetypical pattern-matching algorithm powering
rule engines. PHREAK [[@TODO source]] is a collection-oriented
alternative to the tuple-by-tuple RETE.

## Traditional Query Optimization

The field of query optimization is vast. For the purposes of this work
we will be focusing mostly on relational query planning. Query
planning is the task of, given a tree structure of relational
operators, determining the most efficient order in which to execute
these operators without affecting the result set.

Selinger et al.[0] give the canonical query planner, split into three
components: cardinality estimation, plan space enumeration, and a cost
model. This seminal work, done for the System R DBMS, first
established the practicality of declarative query languages and — to
this day — serves as the reference architecture for many modern
databases in productive use.

Selinger et al. introduce the concept of an *access path*. Access
paths represent the different ways of accessing the tuples in a
relation. The simplest access path is a full scan of the relation, but
various indices might be available as well.

For queries that don't involve joins the System R planner employs a
cost model incorporating statistics gathered on the expected
selectivity of each access path available to service each of the
requested selection predicates. Additionally, the planner will check
whether the desired output ordering matches the order provided by any
suitable access path.

The complete cost model is somewhat more complex, because it allows
for a weighting between I/O and CPU cost and must deal with the fact
that memory segments will contain tuples from different
relations. Therefore the cost of scanning through a seemingly small
relation might be much higher in reality. Given this cost model, the
planner can pick the cheapest access path to service the query.

Of course, the more interesting case is that involving multiple
relations, which must be joined together. Given the cost model for
queries on individual relations, the planner now has to enumerate join
order permutations, compute overall cost, and pick the cheapest
overall plan. Simple heuristics are used to reduce the number of
permutations under consideration.

Many variants and improvements on this architecture have been proposed
over the years, most notably so in a long line of research by Graefe
et al.[1,2]. These architectures vary in their plan enumeration
strategies (bottom-up vs top-down) and improve the extensibility of
the planning architecture. The basic approach of heuristics-based cost
estimation combined with plan enumeration stays the same.

It is well established[3,4], that cardinality estimation is both the
most important part of traditional query optimization, as well as the
hardest to get right. Leis et al.[3] show that estimation errors grow
exponentially with the number of joins for a representative selection
of modern relational DBMS. They also show that correct cardinality
estimates are much more important for plan performance than more
accurate cost models. Due to 3DFs highly normalized data model, a
large class of relevant queries require multi-way joins across many
base relations. This implies that 3DF would be exceedingly sensitive
to these kinds of ballooning errors.

Neither the importance of cardinality estimation, nor the difficulty
of doing it correctly are surprising. Until recently, most strategies
for planning multi-way joins consisted of breaking down an n-way join
into a (hopefully optimal) sequence of two-way joins. In such a
setting, accurate cardinality estimation of the result of joining two
relations (also known as the join's *selectivity*) is crucial, in
order to pick a plan that materializes as few tuples as possible.

As Lohman notes in [4], many modern systems still compute their
estimates following assumptions originally proposed for System R:

**Uniformity** @TODO

**Principle of inclusion** Join-key domains are assumed to
overlap. This is a valid assumption for joins on base relations with
referential integrity constraints. 

For the kinds of queries 3DF is interested in, this assumption breaks
down. Consider for example the query `[?u1 :name ?n] [?u2 :name ?n]`
describing all pairs of users sharing a name. Surely we can not
enforce referential integrity on usernames. Similarly a query such as
`[?u1 :name ?n] [?u1 :salary ?s] [(> ?s 1000)]` can easily violate
this assumption, if we filter the `:salary` relation before joining.

**Independent predicates** Multiple conjunctive predicates on the same
relation are assumed to be independent, allowing for their combined
selectivity to be computed as the product of their individual
selectivities. 

This assumption is especially dangerous, because it can lead to
situations in which additional predicates (provided by the user) lead
to a significantly worse-performing plan being picked. Such an
experience is irreconcilable with our maxime of predictable, robust
performance and our desire to provide a declarative interaction model.

**Global information** Traditional optimizers assume that they have
access to up-to-date, accurate statistics on all query inputs (for
some definition of up-to-date and accurate). 

This is less and less true in today's architectures. 3DF derives a big
part of its value from the ability to provide a unified query
interface over heterogenous data sources. Inputs often come from files
or arrive over the network from external systems.

## Adaptive Query Processing

We have seen in the previous chapter, that all traditional approaches
to cardinality estimation (and thus to join ordering and query
planning at large) are susceptible to exponentially compounding
estimation errors due to the use of heuristics.

A more recent field of research explored the idea, that if disastrous
plans would have to be expected from time to time, systems might be
able to detect them and adapt on the fly.

Avnur and Hellerstein [[@TODO]] introduced a new query processing
architecture, called *eddies*, which continuously reorders operators
as it runs.

Such an architecture has additional benefits for long-running queries,
as we might not want to spend a lot of time on fine-grained planning
at registration time, but rather amortize the planning cost and adapt
as we gather more statistics about runtime behaviour.

## Stream Optimization


## Conclusions

We reiterate our desire for a practical system serving diverse data
needs in real-world organizations. Consequently, we care less about
picking optimal queries for every individual query and are more
interested in minimizing the number of disastrous plans chosen. Such
plans not only affect individual query performance, but negatively
impact all users of the system.

At a first glance, translating the System R approach to 3DF seems
straightforward. Materialized sub-computations (*arrangements*)
provide additional access-paths to tuples, for which a reasonable cost
model could be established. 

Arguably, the suitability of Differential to on-line analytical
computations would ease some of the challenges of maintaining
up-to-date metrics on relations, without incurring a significant
oeprational overhead. Yet, we do not see a promising avenue to tackle
the fundamental fragility of cardinality estimation on complex queries
invoving many joins using these heuristics-based techniques.

Even worse, subgraph queries will often not have [[@TODO]]

The novel execution model of differential dataflows and the highly
dynamic environments 3DF is designed for do not bear much resemblance
to the operational realities 40 years ago. Traditional planners are
not built with incremental, streaming evaluation in mind.

[[@TODO show how the planner assumptions aren't valid anymore]]

In a streaming context, a query, once registered, will continue taking
up memory for all of its materialized arrangements and CPU time for
all of its dataflow elements. This implies that we will eventually
have to share arrangements and dataflow elements between users to
achieve the desired scale.

## Sources

[0] [Selinger et al., Access Path Selection in a RDMS](../sources/access-path-selection.pdf)
[1] [Graefe, McKenna, The Volcano Optimizer Generator](../sources/volcano.pdf)
[2] [Graefe, The Cascades Framework For Query Optimization](../sources/the-cascades-framework-for-query-optimization.pdf)
[3] [Leis et al., How Good Are Query Optimizers, Really?](../sources/how-good-are-optimizers-really.pdf)
[4] [Lohman, Is Query Optimization A Solved Problem?](../sources/is-query-optimization-a-solved-problem.pdf)
[5] [Hellerstein, Query Optimization (Red Book, 5th ed.)](http://www.redbook.io/ch7-queryoptimization.html)

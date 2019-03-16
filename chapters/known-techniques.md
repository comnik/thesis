# Known Techniques

## Rule Engines

@TODO

## Traditional Query Optimization

Selinger et al.[0] give the canonical query planner, split into three
components: cardinality estimation, plan space enumeration, and a cost
model. This seminal work, done for the System R DBMS, first
established the practicality of declarative query languages and — to
this day — serves as the reference architecture for many modern
databases in productive use.

@TODO describe SystemR planner

Many variants and improvements on this architecture have been proposed
over the years, most notably so in a long line of research by Graefe
et al.[1,2].

@TODO summary Volcano vs. SystemR

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

## Methods For Gathering Metrics On Relations

@TODO

## Suitability to 3DF

We reiterate our desire for a practical system serving diverse data
needs in real-world organizations. Consequently, we care less about
picking optimal queries for every individual query and are more
interested in minimizing the number of worst-case plans chosen. Such
plans not only affect individual query performance, but negatively
impact all users of the system.

At a first glance, translating the System R approach to 3DF seems
straightforward. Materialized sub-computations (*arrangements*)
provide access-paths to tuples, for which a reasonable cost model
could be established.

The novel execution model of differential dataflows and the highly
dynamic environments 3DF is designed for do not bear much resemblance
to the operational realities 40 years ago. Traditional planners are
not built with incremental, streaming evaluation in mind.

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

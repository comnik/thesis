# Data Model

It is well established that data processing systems with data models
optimized for a specific domain can outperform general-purpose systems
by one or more orders of magnitude. Today, users can (in addition to
traditional RDBMS) choose from column-stores designed for analytical
queries, databases for time-series, graphs, or geographical data,
search engines, and many more @TODO. In this section we describe and
provide motivation for 3DF's data model.

## Design Considerations

We strongly believe that the next generation of query processors must
take into account the needs of the emerging data-science community, as
those will make up most of our users in the future. Motivating this
further and investigating all of the broad implications this will have
on database design is beyond the scope of this work, but we will point
out two important, exemplary concerns.

**Heterogeneous Sources**  

We can no longer assume that all inputs to a computation come from the
same source (e.g. a traditional RDBMS). This is especially the case
for systems like 3DF, which are not concerned with data storage at
all. Inputs come from external systems, are stored in distributed
filesystems, or are provided interactively by users. Inputs can have
vastly different characteristics w.r.t volume, rate, and data type.

The popularity of microservice-based architectures also imply, that
modern query processors must integrate data from diverse sources in
order to even arrive at a consistent, global view of any single domain
entity.

This new reality is elegantly captured by a column-oriented approach,
where sourcing information, data schema, and other semantics can be
configured separately for each individual attribute.

**Categorical Data**  

An important computational characteristic of modern statistical
learning is the prevalence of categorical features, typically
represented via one-hot encodings. In a relational setting, one-hot
encodings correspond to distinct unary relations for each distinct
category a given record may fall into.

In a traditional, row-oriented data model, modeling such data will
lead to very wide, sparse tuples. Colum-oriented data models can
represent such data much more efficiently and materialize only
neccessary attributes, but incur frequent multi-way joins across
relations of potentially highly varying selectivities.

## The 3DF Data Model

@TODO

## One Size Fits All?

We share the view of Aref et al.[0] towards specialized
databases. Their use is warranted in scenarios where they can provide
at least an order of magnitude in efficiency gains. Below that, the
cost of developing, maintaining, and integrating a specialized system
dominates. We suspect that this threshold is even higher for many
industrial users with no in-house competence in designing
data-processing systems. 

We therefore think it worthwile to investigate whether novel
approaches allows us to make general-purpose query engines that can
offer competitive performance across a wider class of use cases.

## Sources

[0] [Aref et al., Design and Implementation of the LogicBlox System](../sources/logicblox.pdf)
[1] [Datomic](https://www.datomic.com/)

# Design and Implementation of 3DF

## Data Model

We adopt a unified, attribute-oriented data model. The fundamental
unit of modeling are *facts*, which are represented by `[e a
v]`-tuples (short for *entity*, *attribute*, *value*). Each triplet is
to be read as "Entity e has associated with it the attribute a, with a
value v". 3DF currently supports the following value types:

``` rust
enum Value {
    /// An entity identifier
    Eid(u64),
    /// An attribute identifier
    Aid(String),
    /// A string
    String(String),
    /// A boolean
    Bool(bool),
    /// A 64 bit signed integer
    Number(i64),
    /// A 32 bit rational
    Rational32(Rational32),
    /// Milliseconds since midnight, January 1, 1970 UTC
    Instant(u64),
    /// A 16 byte unique identifier.
    Uuid([u8; 16]),
}
```

We use 64bit unsigned integers to identify entities and string names
to identify attributes. While the exact choice of types doesn't
matter, it is this unification which frees us from having to compile
dataflows individually.

This flexible approach of breaking schemas down into individual
attributes corresponds to a fully normalized relational model, and is
heavily inspired by RDF, research on triple stores, or database
systems like Datomic and LogicBlox. [[@TODO sources: rdf, triple
stores, Datomic, LogicBlox]]. It allows to configure important
semantics, such as data validation, access and privacy policies,
compaction, and indexing strategy at a much more fine-grained level
than a traditional database schema could accomodate. Other
organizational aspects such as documentation and namespacing are also
most naturally expressed at the level of the individual attribute.

It is well established that data processing systems with data models
optimized for a specific domain can outperform general-purpose systems
by one or more orders of magnitude. Today, users can (in addition to
traditional RDBMS) choose from column-stores designed for analytical
queries, databases for time-series, graphs, or geographical data,
search engines, and many more @TODO.

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

Motivated by these considerations and with further inspiration from
the LogicBlox and Datomic systems[0, 1], we model all data in sixth
normal form, meaning that every attribute is represented as a separate
relation. This comes with a number of trade-offs, whose detailed
investigation is not the focus of this work. In addition to the
treatment in Aref et al.[0], we find that this model is well suited to
dealing with many heterogeneous sources and maps naturally to Datalog
expressions.

### Implementation

Although conceptually we are modelling a single space of facts as it
evolves through logical time, we keep track of individual attributes
in their own Differential collections. Attribute collections hold `(e,
v)` pairs.

### One Size Fits All?

We share the view of Aref et al.[0] towards specialized
databases. Their use is warranted in scenarios where they can provide
at least an order of magnitude in efficiency gains. Below that, the
cost of developing, maintaining, and integrating a specialized system
dominates. We suspect that this threshold is even higher for many
industrial users with no in-house competence in designing
data-processing systems.

A similar approach has been taken by the Datomic database[1] and the
EVE project[2]. We witnessed the former's outsized, positive impact on
developer productivity and system evolvability first-hand.

We therefore think it worthwile to investigate whether novel
approaches allows us to make general-purpose query engines that can
offer competitive performance across a wider class of use cases.

## Query Language

@TODO

## Sources

[0] [Aref et al., Design and Implementation of the LogicBlox System](../sources/logicblox.pdf)
[1] [Datomic](www.datomic.com)
[2] [EVE](incidentalcomplexity.com)


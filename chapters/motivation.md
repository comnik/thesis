# Introduction and Motivation

As more and more industries adopt data-driven decision-making and
companies are increasingly looking to provide digital services, the
capability to extract actionable insights from many continuous data
streams in a timely manner is becoming a critical competitive
advantage.

From an end user perspective, any results derived from the data
flowing through an organization should above all be correct,
incorporate the most recent data available, and reflect a consistent
view of the organization as of some point in time. Additionally, it is
not acceptable any longer to hold information in mutable cells. Rather
information must be recorded in such a way, that historical states can
be recovered for analytical and auditing purposes.

To that end, many companies are starting to adapt event-driven
architectures, in which data producers and consumers are uncoupled via
a shared, append-only log of records. Services coordinate reactively,
via the arrival of new data. While this approach makes for
understandable, flexible systems, it puts a larger burden on data
consumers to construct and maintain consistent, up-to-date views on
the subset of information that is relevant to them.

Recent, purpose-built stream processing systems can meet very high
throughputs and near real-time latencies, but lack support for
expressive programming models and strong consistency
guarantees. Specialized graph-, OLAP-, and time-series databases on
the other hand support much more complex algorithms, but their ad-hoc
interaction model does not fit well into tomorrows reactive, near
real-time environments.

Only recently have dataflow systems emerged, that support strongly
consistent, incremental maintenance of complex computations over
high-throughput data streams. The resulting systems respond
efficiently to unbounded, arbitrarily changing inputs, support
distributed execution out-of-the-box, and allow data consumers to
off-load view maintenance.

In this work we are interested in cataloging the performance
challenges that arise at this intersection of databases and
stream-processing and remedies to them, that are necessary to support
real-world use-cases. 

Thus it is not the primary goal of this work to produce optimal
execution strategies for individual computations, but rather to gain
insight and understanding into how a modern dataflow system can
support a wide range of non-trivial queries in demanding interactive
environments while retaining its overall performance characteristics.

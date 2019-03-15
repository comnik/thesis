# Background

## Dataflow Programming

@TODO

## Timely Dataflow

Timely Dataflow[0] is an implementation of the cyclical dataflow model
introduced by Murray, McSherry, and Isaacs in [1]. It is written in
the Rust language. Timely Dataflow follows a data-parallel approach,
meaning each worker in a Timely cluster runs the same dataflow
computation with inputs partitioned between them.

Dataflow computations over unbounded, potentially out-of-order inputs
must reason about times at which it is safe to produce
results. Producing results over-eagerly will keep latencies low, but
causes downstream inconsistencies, because forwarded results do not
include all relevant inputs. Likewise, holding results back for too
long will ensure correctness but might increase latencies
unneccesarily (taken to the extreme, this end of the spectrum
corresponds to batch processing). We will refer to this problem as
*progress tracking*.

Timely is a run-time for data-parallel dataflow computations that
coordinate via fine-grained progress tracking. 

This is achieved by attaching logical timestamps to each datum and
imposing a partial ordering on them. The ordering controls visibility
(and thus detaches physical availability of a datum from logical
visibility) and allows the system to infer for which logical times it
might still receive more data.

@TODO

## Differential Dataflow

As the complexity of our computation grows and data volumes increase,
we will want to avoid re-computing results from scratch whenever an
input changes. Rather, we would like to incrementally update previous
results with (hopefully) small changes. In particular we would like to
do so even for iterative computations which often arise in graph
processing.

Differential Dataflow[2] is a programming framework implementing
differential dataflow[3] on top of Timely. It allows to express
dataflow programs as functional transformations over *collections* of
data, using well-known functional operators such as `map`, `filter`,
and `reduce`, and relational operators like `join`. Differential also
allows to express iterative computations via operators such as
`iterate`.

Computations expressed in this model will be compiled down to Timely
dataflows that will update efficently (i.e. incrementally) in response
to arbitrary input changes.

Differential Dataflow introduces the, to our knowledge novel, concept
of *Arrangements*. Arrangements maintain indexed batches of updates to
a collection. The resulting indexed state can be shared between
operators and allows for the dynamic creation of dataflows that can
feed off of them.

## 3DF

3DF (short for *Declarative Differential Dataflow*).

## Sources

[0] [Timely Dataflow](https://github.com/TimelyDataflow/timely-dataflow)
[1] [Murray et al., Naiad: A Timely Dataflow System](../sources/naiad.pdf)
[2] [Differential Dataflow](https://github.com/TimelyDataflow/differential-dataflow)
[3] [McSherry et al., Differential dataflow](../sources/differentialdataflow.pdf)

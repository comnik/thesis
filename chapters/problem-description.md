# Problem Description And Scope

We are tackling the problem of multi-query optimization, which is
distinct from single-query optimization inasmuch as we do not concern
ourselves with achieving the optimal plan for any single query, but
rather convergence to more optimal global execution as queries come
and go. In particular we are more interested in limiting the number of
"disastrous" plans picked, because those have an outsized negative
effect on *all* users of the system.

Our priorities in this work are therefore as follows:

(1) **Robustness**. Above all, we would like for the resulting system
to match user expecations, perform consistently well, and in a
predictable manner.

(2) **Multi-user**. In order to be useful as a general-purpose system,
we must support many concurrent use cases and clients, be they
analysts on interactive sessions or developers implementing
distributed backend processes.

(3) **Low-latency and high-throughput**. The attractiveness of
stream-processing derives from its performance characteristics, and
the possibility to obtain results in a timely manner. While aiming for
(1) and (2), we must take care to maintain these properties as much as
possible.

Motivated by promising results such as Aref et al.[0] we look first at
algorithmic improvements promising asymptotic savings in materialized
state and query execution, before turning to more system-level
improvements such as more efficient data representations, compression,
and parallelization.

Even though we're focusing on the multi-query case we must be careful
not to make ourselves incompatible with potential orders-of-magnitude
improvements to individual queries promised by novel evaluation
techniques such as [1].

## Approach

We will start from the *Declarative Dataflow* codebase, a reactive,
distributed query engine built on *Differential Dataflow*, an
incremental, data-parallel stream processing system. Throughout this
work, we will refer to the resulting system as *3DF* (short for
*Declarative Differential Dataflows*).

Using 3DF, we will explore a number of scenarios in which the
properties identified in the previous section might be violated, what
remedies are available, and which ones we implemented. Finally we will
evaluate the resulting system w.r.t. the baseline implementation to
verify or disprove the hypothesized improvements.

This approach is chosen to be reminiscent of Hirzel et al. in [2], but
adapted for the higher-level computations that are the intended domain
of 3DF (and Differential Dataflow in general).

## Sources

[0] [Design and Implementation of the LogicBlox System](../sources/logicblox.pdf)
[1] [Tekle, Liu, Subsumptive Tabling Beats Magic Sets](../sources/subsumptive-tabling.pdf)
[2] [Hirzel et al., A Catalog of Stream Processing Optimizations](../sources/a-catalog-of-stream-processing-optimisations.pdf)

# Problem Description

We are tackling the problem of multi-query optimization, which is
distinct from single-query optimization inasmuch as we do not concern
ourselves with achieving the optimal plan for any single query, but
rather convergence to more optimal global execution as queries come
and go. In particular we are more interested in limiting the number of
"disastrous" plans picked, because those have an outsized negative
effect on *all* users of the system.

Motivated by promising results such as Aref et al.[0] we look first at
algorithmic improvements promising asymptotic savings in materialized
state and query execution, before turning to more system-level
improvements such as more efficient data representations, compression,
and parallelization.

Even though we're focusing on the multi-query case we must be careful
not to make ourselves incompatible with potential orders-of-magnitude
improvements to individual queries promised by novel evaluation
techniques such as [1].

## Sources

[0] [Design and Implementation of the LogicBlox System](../sources/logicblox.pdf)
[1] [Tekle, Liu, Subsumptive Tabling Beats Magic Sets](../sources/subsumptive-tabling.pdf)

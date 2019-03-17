# Case 6: Skew

## Problem

Throughout this work we have seen the many challenges of implementing
complex, high-arity joins. At the same time, we have also seen their
tremendous power as enablers for flexible data modeling, as well as
foundation on which the entire expressive range of a language like
Datalog can be implemented efficently.

We have also touched on [@TODO] features such as user-controlled query
parameters and queries across a specific range of time, which treat
control inputs and configuration parameters as data and which are then
in turn efficently implemented via the join primitives.

In this scenario we will focus on a critical property of distributed
joins in general, and of the latter "control joins" in particular:
skew.

Skew problems arise in distributed, data-parallel processing, whenever
inputs are either not distributed evenly across homogeneous workers,
or not distributed according to the varying capacities of
heterogeneous workers.

For stateless operators such as `map` or `filter`, we can always
randomly shuffle the data amongst workers, to ensure a uniform
distribution. This is not possible for operators that depend on state
for each key. In particular, an operator such as `join` must be
certain it will see all inputs for a key `k` on a specific worker, if
it has seen any input for `k` on that worker. Otherwise we might miss
results.

## Examples

@TODO MatchAV, MatchEA, Filter vs Lookup vs Join

@TODO control collection

@TODO reverse index on categorical feature

@TODO general trade-off with arrangements

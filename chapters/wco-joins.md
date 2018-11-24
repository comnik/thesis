# Worst-Case Optimal Joins

We have treated the established practice of implementing multi-way
joins via sequences of two-way joins in detail, and considered its
extension to the interactive differential dataflow setting. In this
section we will do the same for recent advances in multi-way join
algorithms.

## Drawbacks of Nested Two-Way Joins

Consider a three-way join `(⨝ A B C)`, implemented as a nested
dataflow with a fixed order `(⨝ (⨝ A B) C)`. 

For such a plan, Differential dataflow will by default maintain
arrangements of every intermediate result (`(⨝ A B)` in this case),
incurring additional memory overhead and some time spent managing the
shared trace.

Additionally, fixing the join order can cause unnecessary
materialization of tuples, not just for the initial result, but also
in the incremental case. Intuitively this is because the optimal join
order (in the incremental case) depends in which relation a change
occurred.

@TODO concrete examples

# Case 2: Join Order

## Problem

As has been widely documented within the database community [@TODO
citations], many complex queries are highly sensitive to join
ordering. [@TODO] We have dedicated a chapter to discuss the
metrics-based approach to picking good join orders automatically and
to the field of worst-case optimal n-way joins.

This scenario will focus on a case where the optimal join order is
highly dependent on the individual tuple, such that no traditional
join ordering approach can hope to find an order that is optimal for
the entire computation.

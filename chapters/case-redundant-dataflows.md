# Case 4: Redundant Dataflows

## Problem

Throughout the previous chapters we have seen how delta queries and
worst-case optimal join algorithms make much of 3DF's design
possible. We have arrived at a system that provides robust,
predictable performance within a multi-user environment, at high
throughputs, with low latencies, and with bounded memory use. In doing
so, we have overcorrected a bit, at the expense of redundancies in the
overall dataflow. Apart from the attribute indices, we have foregone
almost all opportunities for sharing state between dataflows.

Naturally, this limits the number of clients we can support
concurrently.

## Example

## Remedy

Here we are meeting again a trade-off identified in the very first
scenario we analysed, [[Case 0]].

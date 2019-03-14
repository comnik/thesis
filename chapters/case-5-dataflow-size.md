# Case 5: Dataflow Size

## Problem

Query dataflows consume a number of ressources over their entire
lifetime, which might be measured in minutes or hours for interactive
sessions, but in days, weeks, months, or even years for dataflows
between backend services.

[@TODO overheads of dataflow elements]

We've discussed in various chapters the many benefical properties of
delta-queries and worst-case optimal streaming joins. We've also seen
how in combination they can lead to a significant increase in the size
of the resulting dataflows, quadratic in the number of relations
involved in a join.

[@TODO find dataflow size limit]

## Example

[@TODO]

## Remedy

In a multi-user environment, a natural approach for reducing the
overall number of dataflow elements is sharing dataflows between
clients. We've explored this approach in chapter [@TODO]. Here we want
to focus instead on ways to increase the opportunities for sharing
dataflows, by moving multi-tenancy into the data plane.



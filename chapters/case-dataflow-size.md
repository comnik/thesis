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

@TODO
If we want to re-use delta query pipelines we might have to generalize
~AltNeu~ to be an integer, specifying the position in the
chain. Otherwise the likelihood of compatible re-use across pipelines
is negligible.

@TODO iterated hector
There is a remaining redundancy in Hector, in that whenever multiple
Attribute bindings refer to the same attribute, we would be
constructing more than one delta pipeline. In a way, a single change
to the supporting attribute leads to multiple changes in the bindings.

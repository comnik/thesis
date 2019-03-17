# Efficient Representations

Abadi et al.[0] note that data stored in columns is more compressible
than data stored in rows, because the former generally have lower
information entropy and better value locality. Having established the
column-inspired data model of 3DF in @TODO, we are now interested to
what extent efficient, column-oriented representations can be
exploited in differential collections.

Again Abadi et al. list several common compression schemes employed in
modern column-stores:

1. Run length encoding
2. Bit-vector encoding
3. Dictionary encodings
4. Frame-of-reference encoding

Differential collections already employ a kind of run length encoding
scheme, by virtue of their multi-set semantics.

## Late Materialization

@TODO
Another technique from the world of column-stores. It seems like a
generalization of predicate-pushdown. E.g. for certain simple
aggregates it should be possible to push-down the aggregation and do
it directly on a (potentially compressed) single column.

## Interning

@TODO

## Sources

[0] [Abadi et al., The Design and Implementation of Modern Column-Oriented Database Systems](../sources/abadi-column-stores.pdf)

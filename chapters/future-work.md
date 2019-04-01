# Future Work

- @TODO hybrid planners
- @TODO eddies like constructs
- @TODO monoid aggregations

A hybrid cost-based approach Mhedhbi and Salihoglu [[@TODO]] shows
promising results.

### Datalog Evaluation Strategies

At its heart (and mostly thanks to Differential's incremental
computation model), 3DF uses a semi-naive, bottom-up evaluation
strategy [@TODO really?]. Over the past decades, many more
sophisticated Datalog evaluation strategies have been developed [@TODO
cite]. More work is needed to understand how strategies such as the
magic-set transform or subsumptive tabling translate into the
incremental dataflow model, and to what extent they overlap with
worst-case optimal join evaluation.

### String Interning

### Static Optimizations

The finer-grained language of bindings described in [[@TODO]], and in
particular the use of the `constant` binding surfaced interesting
opportunities for static optimizations. For example, by moving
conjunctive clauses into disjunctions (using DeMorgan's law), we at
times identified entire branches that couldn't possibly produce
results, due to conflicting constant bindings.

## Sources

- [0] Semih's paper on Hybrid Plans https://arxiv.org/pdf/1903.02076.pdf
- [1] [String interning in DD](https://github.com/frankmcsherry/blog/blob/master/posts/2018-11-20.md)
- [2] Subsumptive Tabling paper

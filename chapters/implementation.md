# Changes to 3DF

## Indexing

@TODO

## Lazy Synthesis

@TODO

## Logging and Instrumentation

A fair bit of instrumentation is necessary in order to monitor the
dataflow graph as it evolves over time, the number of tuples held in
arrangements, and many other metrics.

To that end, Timely Dataflow provides an extensible set of internal
dataflow streams, onto which internal events are published. Logged
events include among others the creation, shutdown, and scheduling of
operators, activity on communication channels, and progress tracking.

Differential Dataflow uses the same subsystem to provide additional
information about the creation and merging of trace batches. These are
sufficient to infer, for any relevant time, the number of arranged
tuples maintained at each arrangement in the dataflow.

Deriving relevant signals from the stream of logging events
dynamically via 3DF's reactive query engine seemed like a natural
fit. We created two new 3DF sources, `TimelyLogging` and
`DifferentialLogging`.

The `TimelyLogging` source allows clients to source only the subset of
logging attributes that they are interested in (see [[LISTING
BELOW]]). It also performs some pre-processing on the raw logging
streams, converting hierarchical scope addresses into the
corresponding edges of the dataflow graph.

``` clojure
(register-source
  {:TimelyLogging
   {:attributes [:timely.event.operates/name
                 :timely.event.operates/shutdown?]}})
```

Similarly, the `DifferentialLogging` source will not expose batching
and merging events directly, but rather derive from them changes to
the number of tuples held by each arrangement. Batch events imply an
increase in the number of tuples held (by the size of the batch),
merge events imply a decrease (the difference between the compacted
size of the merge result and the sum of the size of the input
batches).

Taken together, this makes it easy to write queries such as the
following, asking for the total number of tuples arranged at operators
that haven't been shut down.

``` clojure
;; total number of tuples arranged at alive operators

[:find (sum ?size)
 :where
 [?x :differential.event/size ?size]
 (not [?x :timely.event.operates/shutdown? true])]
```

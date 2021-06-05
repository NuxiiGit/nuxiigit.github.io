An educational graph theory application for computing common relation operations and graph traversals. A monadic recursive descent parser was written so that graphs encoded in the Graphviz DOT script to be imported and exported using the application.

Consider the following graph in a file named `graph.dot`
```text
graph {
  a -- { b c d };
  b -- { c e };
  c -- f;
}
```
Using the command `dot-edit graph.dot depthf:a`, the Depth-First Traversal of `graph.dot` is computed:
```text
digraph {
  a -> b;
  b -> c;
  c -> f;
  b -> e;
  a -> d;
}
```

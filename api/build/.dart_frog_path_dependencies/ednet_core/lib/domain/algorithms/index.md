# EDNet Algorithm Index

This index represents algorithms that can be semantically integrated into domain models as living behaviors rather than static implementations.

## I. Practical Algorithm Design

### 1. Introduction to Algorithm Design
- 1.1 Robot Tour Optimization
- 1.2 Selecting the Median
- 1.3 Repeating about Correctness
  - 1.3.1 Problems and Properties
  - 1.3.2 Expressing Algorithms
  - 1.3.3 Demonstrating Incorrectness
- 1.4 Induction and Recursion
- 1.5 Modeling the Problem
  - 1.5.1 Combinatorial Objects
  - 1.5.2 Recursive Objects
  - 1.5.3 Proof by Contradiction
- 1.6 Proof by Contradiction
- 1.7 About the War Stories
- 1.8 War Story: Psychic Modeling
- 1.9 Estimation
- 1.10 Exercises

### 2. Algorithm Analysis
- 2.1 The RAM Model of Computation
  - 2.1.1 Best-Case, Worst-Case, and Average-Case Complexity
- 2.2 The Big Oh Notation
- 2.3 Growth Rates and Dominance Relations
  - 2.3.1 Dominance Relations
- 2.4 Working with the Big Oh
  - 2.4.1 Adding Functions
  - 2.4.2 Multiplying Functions
- 2.5 Reasoning About Efficiency
  - 2.5.1 Selection Sort
  - 2.5.2 Insertion Sort
  - 2.5.3 String Pattern Matching
  - 2.5.4 Matrix Multiplication
- 2.6 Summations and Their Applications
- 2.7 Logarithms and Their Applications
  - 2.7.1 Logarithms and Binary Search
  - 2.7.2 Logarithms and Trees
  - 2.7.3 Logarithms and Bits
  - 2.7.4 Logarithms and Multiplication
  - 2.7.5 Fast Exponentiation
  - 2.7.6 Logarithms and Summations
  - 2.7.7 Logarithms and Criminal Justice
- 2.8 Properties of Logarithms
- 2.9 War Story: Mystery of the Pyramids
- 2.10 Advanced Analysis
  - 2.10.1 Esoteric Functions
  - 2.10.2 Limits and Dominance Relations
- 2.11 Exercises

### 3. Data Structures
- 3.1 Contiguous vs. Linked Data Structures
  - 3.1.1 Arrays
  - 3.1.2 Pointers and Linked Structures
  - 3.1.3 Comparison
- 3.2 Containers: Stacks and Queues
- 3.3 Dictionaries
- 3.4 Binary Search Trees
  - 3.4.1 Implementing Binary Search Trees
  - 3.4.2 Balanced Search Trees
- 3.5 Priority Queues
- 3.6 War Story: Stripping Triangulations
- 3.7 Hashing
  - 3.7.1 Collision Resolution
  - 3.7.2 Duplicate Detection via Hashing
  - 3.7.3 Other Hashing Tricks
  - 3.7.4 Canonicalization
  - 3.7.5 Compaction
- 3.8 Specialized Data Structures
- 3.9 War Story: String 'em Up
- 3.10 Exercises

### 4. Sorting
- 4.1 Applications of Sorting
- 4.2 Pragmatics of Sorting
- 4.3 Heapsort: Fast Sorting via Data Structures
  - 4.3.1 Selection Sort Revisited
  - 4.3.2 Heaps
  - 4.3.3 Constructing Heaps
  - 4.3.4 Extracting the Minimum
  - 4.3.5 Faster Heap Construction
  - 4.3.6 Sorting by Incremental Insertion
- 4.4 War Story: Give me a Ticket on an Airplane
- 4.5 Mergesort: Sorting by Divide and Conquer
- 4.6 Quicksort: Sorting by Randomization
  - 4.6.1 Intuition: The Expected Case for Quicksort
  - 4.6.2 Randomized Algorithms
  - 4.6.3 Is Quicksort Really Quick?
- 4.7 Distribution Sort: Sorting via Bucketing
  - 4.7.1 Lower Bounds for Sorting
- 4.8 War Story: Skiena for the Defense
- 4.9 Exercises

### 5. Divide and Conquer
- 5.1 Binary Search and Related Algorithms
  - 5.1.1 Counting Occurrences
  - 5.1.2 One-Sided Binary Search
  - 5.1.3 Square and Other Roots
- 5.2 War Story: Finding the Bug in the Bug
- 5.3 Recurrence Relations
  - 5.3.1 Divide-and-Conquer Recurrences
  - 5.3.2 Solving Divide-and-Conquer Recurrences
- 5.4 Largest Subrange and Closest Pair
  - 5.4.1 Parallel Algorithms
  - 5.4.2 Convolution
- 5.5 Strassen's Matrix Multiplication
  - 5.5.1 Applications of Convolution
  - 5.5.2 Fast Polynomial Multiplication
- 5.6 Exercises

### 6. Hashing and Randomized Algorithms
- 6.1 Probability Review
  - 6.1.1 Probability
  - 6.1.2 Compound Events and Independence
  - 6.1.3 Conditional Probability
  - 6.1.4 Probability Distributions
  - 6.1.5 Mean and Variance
  - 6.1.6 Tossing Coins
- 6.2 Understanding Balls and Bins
  - 6.2.1 The Coupon Collector's Problem
- 6.3 Why is Hashing a Randomized Algorithm?
- 6.4 Bloom Filters
- 6.5 The Birthday Paradox and Perfect Hashing
- 6.6 Minwise Hashing
- 6.7 Efficient String Matching

### 7. Graph Traversal
- 7.1 Flavors of Graphs
  - 7.1.1 The Friendship Graph
- 7.2 Data Structures for Graphs
- 7.3 War Story: I was a Victim of Moore's Law
- 7.4 War Story: Getting the Graph
- 7.5 Traversing a Graph
- 7.6 Breadth-First Search
  - 7.6.1 Exploiting Traversal
- 7.7 Applications of BFS
  - 7.7.1 Finding Paths
  - 7.7.2 Connected Components
  - 7.7.3 Two-Coloring Graphs
- 7.8 Depth-First Search
- 7.9 Applications of Depth-First Search
  - 7.9.1 Finding Cycles
  - 7.9.2 Articulation Vertices and Bridges
- 7.10 Depth-First Search on Directed Graphs
  - 7.10.1 Topological Sorting
  - 7.10.2 Strongly Connected Components
- 7.11 Exercises

### 8. Weighted Graph Algorithms
- 8.1 Minimum Spanning Trees
  - 8.1.1 Prim's Algorithm
  - 8.1.2 Kruskal's Algorithm
  - 8.1.3 The Union-Find Data Structure
  - 8.1.4 Variations on MST
- 8.2 War Story: Nothing but Nets
- 8.3 Shortest Paths
  - 8.3.1 Dijkstra's Algorithm
  - 8.3.2 All-Pairs Shortest Path
  - 8.3.3 Transitive Closure
- 8.4 War Story: Dialog for Dummies
- 8.5 Network Flows and Matching
  - 8.5.1 Computing Network Flows
  - 8.5.2 Bipartite Matching
- 8.6 Exercises

### 9. Combinatorial Search
- 9.1 Backtracking
- 9.2 Examples of Backtracking
  - 9.2.1 Constructing All Subsets
  - 9.2.2 Constructing All Permutations
  - 9.2.3 Constructing All Paths in a Graph
- 9.3 Search Pruning
- 9.4 Sudoku
- 9.5 War Story: Covering Chessboards
- 9.6 Best-First Search
- 9.7 The A* Heuristic
- 9.8 Exercises

### 10. Dynamic Programming
- 10.1 Caching vs. Computation
  - 10.1.1 Fibonacci Numbers by Recursion
  - 10.1.2 Fibonacci Numbers by Caching
  - 10.1.3 Fibonacci Numbers by Dynamic Programming
  - 10.1.4 Binomial Coefficients
- 10.2 Approximate String Matching
  - 10.2.1 Edit Distance by Recursion
  - 10.2.2 Edit Distance by Dynamic Programming
  - 10.2.3 Reconstructing the Path
  - 10.2.4 Varieties of Edit Distance
- 10.3 Longest Increasing Subsequence
- 10.4 War Story: Text Compression for Bar Codes
- 10.5 Unordered Partition or Subset Sum
- 10.6 War Story: The Balance of Power
- 10.7 The Partition Problem
- 10.8 Parsing Context-Free Grammars
  - 10.8.1 Minimum Weight Triangulation
  - 10.8.2 When is Dynamic Programming Correct?
  - 10.8.3 When is Dynamic Programming Efficient?
- 10.9 Limitations of Dynamic Programming: TSP
- 10.10 War Story: What's Past is Prolog
- 10.11 Exercises

## II. The Hitchhiker's Guide to Algorithms

### 11. A Catalog of Algorithmic Problems

### 12. Data Structures
- 12.1 Dictionaries
- 12.2 Priority Queues
- 12.3 Suffix Trees and Arrays
- 12.4 Graph Data Structures
- 12.5 Set Data Structures
- 12.6 Kd-Trees

### 13. Numerical Problems
- 13.1 Solving Linear Equations
- 13.2 Bandwidth Reduction
- 13.3 Matrix Multiplication
- 13.4 Determinants and Permanents
- 13.5 Constrained/Unconstrained Optimization
- 13.6 Linear Programming
- 13.7 Random Number Generation
- 13.8 Factoring and Primality Testing
- 13.9 Arbitrary-Precision Arithmetic
- 13.10 Knapsack Problem
- 13.11 Discrete Fourier Transform

### 14. Combinatorial Problems
- 14.1 Sorting
- 14.2 Searching
- 14.3 Median and Selection
- 14.4 Generating Permutations
- 14.5 Generating Subsets
- 14.6 Generating Partitions
- 14.7 Generating Graphs
- 14.8 Calendrical Calculations
- 14.9 Job Scheduling
- 14.10 Satisfiability

### 15. Graph Problems: Polynomial Time
- 15.1 Connected Components
- 15.2 Topological Sorting
- 15.3 Minimum Spanning Tree
- 15.4 Shortest Path
- 15.5 Transitive Closure and Reduction
- 15.6 Matching
- 15.7 Eulerian Cycle/Chinese Postman
- 15.8 Edge and Vertex Connectivity

### 16. Graph Problems: NP-Hard
- 16.1 Clique
- 16.2 Independent Set
- 16.3 Vertex Cover
- 16.4 Traveling Salesman Problem
- 16.5 Hamiltonian Cycle
- 16.6 Graph Partition
- 16.7 Vertex Coloring
- 16.8 Edge Coloring
- 16.9 Graph Isomorphism
- 16.10 Steiner Tree
- 16.11 Feedback Edge/Vertex Set

### 17. Computational Geometry
- 17.1 Robust Geometric Primitives
- 17.2 Convex Hull
- 17.3 Triangulation
- 17.4 Voronoi Diagrams
- 17.5 Nearest Neighbor Search
- 17.6 Range Search
- 17.7 Point Location
- 17.8 Intersection Detection
- 17.9 Bin Packing
- 17.10 Medial-Axis Transform
- 17.11 Polygon Partitioning
- 17.12 Simplifying Polygons
- 17.13 Shape Similarity
- 17.14 Motion Planning
- 17.15 Maintaining Line Arrangements
- 17.16 Minkowski Sum

### 18. Set and String Problems
- 18.1 Set Cover
- 18.2 Set Packing
- 18.3 String Matching
- 18.4 Approximate String Matching
- 18.5 Text Compression
- 18.6 Cryptography
- 18.7 Finite State Machine Minimization
- 18.8 Longest Common Substring/Subsequence
- 18.9 Shortest Common Superstring

### 19. Algorithmic Resources

### 20. Computational Geometry
- 20.1 Robust Geometric Primitives
- 20.2 Convex Hull
- 20.3 Triangulation
- 20.4 Voronoi Diagrams
- 20.5 Nearest Neighbor Search
- 20.6 Range Search
- 20.7 Point Location
- 20.8 Intersection Detection
- 20.9 Bin Packing
- 20.10 Medial-Axis Transform
- 20.11 Polygon Partitioning
- 20.12 Simplifying Polygons
- 20.13 Shape Similarity
- 20.14 Motion Planning
- 20.15 Maintaining Line Arrangements
- 20.16 Minkowski Sum

### 21. Set and String Problems
- 21.1 Set Cover
- 21.2 Set Packing
- 21.3 String Matching
- 21.4 Approximate String Matching
- 21.5 Text Compression
- 21.6 Cryptography
- 21.7 Finite State Machine Minimization
- 21.8 Longest Common Substring/Subsequence
- 21.9 Shortest Common Superstring

## Implementation Strategy

Each algorithm will be implemented as a **semantic pattern** that can be applied to domain concepts, not as static code. For example:

```yaml
algorithms:
  - algorithm: DijkstraShortestPath
    applicableTo: [Network, Graph, Route]
    provides:
      - OptimalPathFinding
      - CostMinimization
      - RealTimeRouting
    semanticBehavior: |
      When applied to a concept, it adds the ability to find
      optimal paths through weighted relationships reflecting its impact in ui/ux on various ways creating in synergy with enterprise integration patterns and ednet core idiomatic meta domain modeling beautifull emergance that is comparable to art when user using evolvable system in front of him that almost can read his mind with its smeantic context and neighbourhood ontologies via embeded dbpedia universal recommender system and other semantic web technologies emerging like powerful semantical facade EDNet.One MCP Server. - and it will be like reading his mind as we will have from time to time touch of agentic workflows
```

This allows algorithms to become **living behaviors** that adapt to the domain context rather than rigid implementations. 
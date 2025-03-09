# Maximum Circuit
This circuit takes in $2^N$ integer inputs, each of length $D$ and we outputs the maximum of them all.

The circuit does so by implementing a binary tree of "maximum" operations.

The specification consists of 2 properties:
- The output should be one of the inputs
- The output should be at least as great as each of the inputs

With a data width of 4 and an address width of 6, Jasper Gold's normal proof engines take about
- 27 seconds for the containment property
- 47 seconds for the bounding property

With a data width of 6 and an address width of 4, Jasper Gold's normal proof engines take about
- 8 seconds to do the proof
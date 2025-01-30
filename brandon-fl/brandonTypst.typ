#import "@preview/codelst:2.0.1": sourcecode
#let title = "Abstraction Project"
#let author ="Brandon Tang"
#set document(title: title, author: author)
#set par(justify: true)
#set page(numbering: "1/1", number-align: right,)
#let tut(x) = [#block(x, stroke: blue, radius: 1em, inset: 1.5em, width: 100%)]
#let pblock(x) = [#block(x, stroke: rgb("#e6c5fc") + 0.03em, fill: rgb("#fbf5ff"), radius: 0.3em, inset: 1.5em, width: 100%)]
#let gblock(x) = [#block(x, stroke: rgb("#5eb575") + 0.03em, fill: rgb("#e3fae9"), radius: 0.3em, inset: 1.5em, width: 100%)]
#align(center)[
  #block(text(weight: 700, 1.75em, title))
  #v(1em, weak: true)
  #text(weight: 550, 1.1em, author)
]

== Proving Output Constraints with Symbolic Simulation
We only need to focus on proving positive output constraints, i.e. that under a certain condition, a signal will be high.

In fact, with the formulation of relational properties, we don't even need to deal with specific conditions, but our proof will deal with the general case.

=== Symbolic Simulation Invariant
Consider some residual $Q[X, C]$ (the `highexpr` in a symbolic simulation evaluation sequence) in a signal $s(C, T)$ at a fixed time step. We always have the fact that

$ Q[X, C] and R[X, C, T] -> s(C, T) $

(For all $X, C, T$)

This can be proved via induction on the fan-in of $S$. 

The basecase is where $s$ is an input or state variable corresponding to a certain time step, with `highexpr` $P$. In this case 
$ Q = P^R = P_R and forall T (R[X, C, T] -> P[C, T]) $

This directly gives us that for all $X, C, T$ where $Q[X, C] and R[X, C, T]$, we have $P[C, T]$. But $s(C, T) = P[C, T]$ so we are done.#footnote([Note that we don't use the weak preimage part. Indeed, the analysis will still work, but the weak preimage serves to remove useless/inconsistent indexing cases. This will help in avoiding false counter examples.])

An inductive case example: 

Suppose $s = s_1 and s_2$. We have $Q_1$ and $Q_2$ as the residuals of $s_1$ and $s_2$ respectively.

- $Q_1[X, C] and R[X, C, T] -> s_1(C, T)$
- $Q_2[X, C] and R[X, C, T] -> s_2(C, T)$
- So $Q_1[X, C] and Q_2[X, C] and R[X, C, T] -> s_1 and s_2$ 
- But is equivalent to $Q[X, C] and R[X, C, T] -> s$ since $Q = Q_1 and Q_2$ via the symbolic simulator


=== Proof of Correctness for Output Constraint Checking

Output constraints that we wish to prove are of the form:
$ forall C forall T (P[T, C] -> s(C, T)) $

If we have that $P_R [X, C] -> Q[X, C]$ and the coverage condition $forall T forall C exists X R[X, C, T]$ holds, then this will be true.

First remember that $P_R = exists T (R[X, C, T] and P[C, T])$.

Fix some $C, T$ such that $P[C, T]$ is true.
- Since $P[C, T]$ is true, then $forall X (R[X, C, T] -> P_R [X, C])$ by the definition of $P_R$.
- Consider some $X\*$ such that $R[X\*, C, T]$ is true, this must exist by the coverage condition
- Since $P[T, C]$ and $R[X\*, C, T]$ are true, then we must have $P_R [X\*, C]$
- But now since  $P_R [X, C] -> Q[X, C]$, we have $Q[X\*, C]$ as well
- Using the symbolic simulation invariant, since $Q[X\*, C]$ and $R[X\*, C, T]$ are true, then $s(C, T)$ is true
- Since this did not rely on the values of $C, T$, then we have that $forall C forall T (P[T, C] -> s(C, T))$ is true

=== Lowexpr Values
We can set up an analagous invariant for the `lowexpr` values in the symbolic simulation. We will then be able to prove that if $L$ is the lowexpr of $s(C, T)$, then $(L[X, C] and R[X, C, T] -> not s(C, T))$.

We can then prove output constraints of the form $forall C forall T (P[T, C] -> not s(C, T))$ in a similar manner to the highexpr case.

For our purposes where we use just need to prove that a certain wire is always high, we don't need this component. That being said, analysis of $L[X, C]$ is important for finding unproven cases and counter examples.
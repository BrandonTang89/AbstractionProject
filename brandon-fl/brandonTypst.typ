#import "@preview/codelst:2.0.1": sourcecode
#let title = "Abstraction Project Notes"
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

#let dom ="dom"
#let True = "True"
#let False = "False"

== Symbolic Simulation for Functional Properties
The input to symbolic trajectory evaluation consists of an antecedent and a list of output constraints.
  - The antecedent maps BDD variables to input wires in the circuit
  - The output constraints map BDD expressions to signals in the circuit
    - These allow us to assert if a certain wires should be high/low/either at a certain time step for given conditions based on the antecedent
    
These were traditionally written in the form of LTL formulae, but have been rewritten into a 4 tuple form in VOSSII as follows:
$ [("signal", "tickStart":"tickEnd", "highExpr", "lowExpr")] $

This is equivalent to the LTL formula `N^tick ((highExpr -> (signal is 1) and lowExpr -> (signal is 0))) for each tick in the range`.

For an antecedent, this means that we will set the signal to be true if the `highExpr` is true and set the signal to be false if the `lowExpr` is true. Otherwise the signal is `X`.

For output constraints this means that when the assignment of BDD variables make `highExpr` true, we need the signal to be high from `tickStart` to `tickEnd`. Similarly for `lowExpr`. Thus each output constraint tuple can be split into 2 parts: the positive constraint where we need the signal to be true under a certain condition, and the negative constraint where we need the signal to be false under a certain condition. We let the `highExpr` and `lowExpr` be termed as the guards of the constraint.

Jaspergold fully implements symbolic simulation without support for abstraction with an indexing relation. Here, antecedents are not dual rail but rather just singular expressions, this means that we have no symbolic indexing and abstraction beyond the inital Xs present in the circuit. The output constraints here also do not have guards. To conditionally check properties, we would adjust the input constraint `cin`.

For the purposes of doing symbolic indexing, we settled on using the 4-tuple form of antecedents and output. This makes it easier to port over the existing theory on indexing transformations from the STE papers. Furthermore, Jasper's symbolic simulation engine accepts stimuli in the form of the 4-tuple antecedent.


== Indexing Relations
Indexing relations are used to represent abstractions of circuit inputs. This means that they merge sets of circuit inputs into cases.

Indexing relations $R[X, C, T]$ are boolean formulae over BDD variables where
- $X$ are the indexing BDD variables that perform the symbolic indexing
- $T$ are the target BDD variables that are indexed. These correspond to input wires in the circuit
- $C$ are the symbolic constants that correspond to target wires that should not be indexed

The indexing relation can be interpreted as follows:
- For each $X, C$, we cover the cases where $exists T R[X, C, T]$. 
- Since the indexing relation can be a many to many relation, we can have multiple $T, C$ cases covered by a single $X, C$ case indexing.

=== Preimage Operations
We define some operations involving the indexing relation here:

Suppose 
- $P[C, T]$ represents some set of input cases (e.g. (C, T) is in the set iff P[C, T] is true)
- $R[X, C, T]$ is an indexing relation

The *weak preimage* of $P$ under $R$, 
$ P_R [X, C] = exists T (R[X, C, T] and P[C, T]) $
 is the set of $(X, C)$ that cover at least one $(T, C)$ case in $P$

The *strong preimage* of $P$ under $R$, 
$ P^R [X, C] = P_R and not exists T (R[X, C, T] and not P[C, T]) 
$ is the set of $(X, C)$ that cover at least one case in $P$ and don't cover any cases not in $P$.

=== Image Operation
Taking the image of $H[X, C]$ returns the cases that are indexed by $H[X, C]$ under $R$.
$ im(H, R)[C, T] = exists X (R[X, C, T] and H[X, C]) $

While this is not directly used for finding proofs, it is useful for extracting counter examples for disproven properties.

=== Relationship between Preimages
For any fixed $R$ and any given $P$ and $(X, C)$ we have one of the following cases:
- $X, C$ indexes cases only in $P$
- $X, C$ indexes cases only in $not P$
- $X, C$ indexes cases in both $P$ and $not P$
- $X, C$ indexes cases in neither $P$ nor $not P$

Any $X, C$ that fall into the 4th category must correspond to empty indexing cases, i.e. don't map onto any $(C, T)$ at all. Notice that this is independent of $P$, thus, we term the union of the first 3 cases as the domain of $R$.

$ dom(R)[X, C] = exists T (R[X, C, T]) $

Observe that
- The weak preimage is the set of $X, C$ that fall into the 1st and 3rd categories.
- The strong preimage is the set of $X, C$ that fall into the 1st category.

We can note that the following are then also equivalent definitions of the strong preimage operation:
$ P^R [X, C] &= dom(R) and overline(overline(P)^R) \
      &= dom(R) and (forall T (R[X, C, T] -> P[C, T])) $

=== Indexing Coverage Condition
For each property that we wish to check, we let the high and low expressions be $P_i$ and $Q_i$ respectively. The total space of inputs we need to check is then $B[C, T] = or.big_(i) (P_i or Q_i)$. In order for our abstraction to properly cover the space of required inputs, we require that

$ forall T forall C (B[T, C] -> exists X (R[X, C, T])) $

Generally we will be having guards that are equivalent to true, i.e. should hold for all inputs. In this case, $B[C, T] equiv True$ so we coverage condition takes the simpler form:

$ forall T forall C exists X (R[X, C, T]) $

== Indexing Transformation and Symbolic Simulation Procedure
Suppose we are given an indexing relation, `idx_rel`, an antecedent list and an output constraint list. We will describe the procedure to prove that the output constraints hold.

We first apply the strong preimge operations on the high and low expressions of the antecedent tuples as follows:

`antv = [(signal, tickStart:tickEnd, strongPreimage idx_rel highExpr, strongPreimage idx_rel lowExpr)]`

Next we run the symbolic simulator with the transformed antecedent. This produces an evaluation sequence which will contain `sigHighExpr` and `sigLowExpr` BDD expressions for when a signal at a certain time step will definitely be high or low. If for a given assignment, neither of these expressions are true, then the signal is unknown. For a given signal and time step $s$, we let the high expression be $H_s$ and the low expression be $L_s$.#footnote([We will sometimes drop the subscript when there is only 1 relevant signal and time step being considered.])

From this evaluation sequence, we can then check the output constraints. Suppose want to check a output constraint of the form `(signal, tickStart:tickEnd, P, Q)` where $P[C, T]$ and $Q[C, T]$ are the BDD expressions that correspond to inputs on which a signal should be high and low respectively. We will transform the output constraint to `(signal, tickStart:tickEnd, P_R, Q_R)` where $P_R$ and $Q_R$ are the weak preimages of $P$ and $Q$ under the indexing relation.

Then we analyse the `highexpr` and `lowexpr` BDD expressions from the evaluation sequence for the signal at each of the ticks in the tick range. Suppose that at a given tick $t$, for the property wire we have some the high expression as $H[X, C]$ and the low expression as $L[X, C]$. We term the high expression of the signal as the "residual".

We will check if $(P_R -> H)[X, C] equiv True$ and whether $(Q_R -> L)[X, C] equiv True$. If both of these hold, then the output constraint is satisfied.

If we have $(P^R and L) != False$ it means that some indexing cases that only index into $P$ actually cause $s$ to be low, this is a counter example to the positive part of property so the positive part of property is disproven. We can inspect the cases indexed by $(P^R and L)$ to get the actual counter example in terms of the original circuit inputs. 

Similarly, if we have $(Q^R and H) != False$, we have disproven the negative part of the property.

It is possible to not prove the property but also have no counter examples. This can happen in cases where the antecedent does not provide enough information to prove or disprove the property. This is called a weak disagreement and requires changing the indexing relation to obtain a proof/counter example.

== Correctness of Indexing Transformation and Output Constraint Checking
We prove that the above procedure for indexing transformation and output constraint checking is correct.

Here we only need to focus on proving the correctness of positive output constraint checking, i.e. that under a certain condition, a signal will be high. The proof for the negative output constraint checking is analagous.

With our formulation of relational properties later on, we don't even need to deal with guards, but our proof of correctness will deal with the general case since guards can help with environmental constraints (discussed later).

=== Symbolic Simulation Invariant
Consider some residual $H_s [X, C]$ in a signal $s(C, T)$ at a fixed time step. We always have the fact that

$ H_s [X, C] and R[X, C, T] -> s(C, T) $

(For all $X, C, T$)

This can be proved via induction on the fan-in of $S$. 

The basecase is where $s$ is an input or state variable corresponding to a certain time step, with `highexpr` $P$. In this case, since we apply the strong preimage to the antecedents, we have that
$ H = P^R = dom(R) and forall T (R[X, C, T] -> P[C, T]) $

This directly gives us that for all $X, C, T$ where $H[X, C] and R[X, C, T]$, we have $P[C, T]$. But $s(C, T) = P[C, T]$ so we are done.#footnote([Note that we don't use the domain part for this. Indeed, the analysis will still work, but this serves to remove useless/inconsistent indexing cases. This is useful for counterexample analysis later on.])

An inductive case example: 

Suppose $s = s_1 and s_2$. We have $Q_1$ and $Q_2$ as the residuals of $s_1$ and $s_2$ respectively.

- $Q_1[X, C] and R[X, C, T] -> s_1(C, T)$
- $Q_2[X, C] and R[X, C, T] -> s_2(C, T)$
- So $Q_1[X, C] and Q_2[X, C] and R[X, C, T] -> s_1 and s_2$ 
- But is equivalent to $H[X, C] and R[X, C, T] -> s$ since $Q = Q_1 and Q_2$ via the symbolic simulator


=== Output Constraint Checking

Output constraints that we wish to prove are of the form:
$ forall C forall T (P[T, C] -> s(C, T)) $

If we have that $P_R [X, C] -> H[X, C]$ and the coverage condition $forall T forall C (B[C, T] -> exists X (R[X, C, T]))$ holds, then this will be true.

First remember that $P_R = exists T (R[X, C, T] and P[C, T])$.

Fix some $C, T$ such that $P[C, T]$ is true.
- Since $P[C, T]$ is true, then $forall X (R[X, C, T] -> P_R [X, C])$ by the definition of $P_R$.
- Since $P[C, T]$ is true, so is $B[C, T]$
- Consider some $X\*$ such that $R[X\*, C, T]$ is true, this must exist by the coverage condition 
- Since $P[T, C]$ and $R[X\*, C, T]$ are true, then we must have $P_R [X\*, C]$
- But now since  $P_R [X, C] -> H[X, C]$, we have $H[X\*, C]$ as well
- Using the symbolic simulation invariant, since $H[X\*, C]$ and $R[X\*, C, T]$ are true, then $s(C, T)$ is true
- Since this did not rely on the values of $C, T$, then we have that $forall C forall T (P[T, C] -> s(C, T))$ is true

=== Negative Output Constraints
We can set up an analagous invariant for the `lowexpr` values in the symbolic simulation. We will then be able to prove that if $L$ is the lowexpr of $s(C, T)$, then $(L[X, C] and R[X, C, T] -> not s(C, T))$.

We can then prove output constraints of the form $forall C forall T (P[T, C] -> not s(C, T))$ in a similar manner to the highexpr case.

For our purposes where we use just need to prove that a certain wire is always high, we don't need this component. That being said, analysis of $L[X, C]$ is important for finding weak disagreements and counter examples.

=== Counter Example Analysis
Suppose that we have $P^R and L != False$. Let $(X, C)$ be such that $(P^R and L)[X, C]$ is true. We show that $(X, C)$ is a counter example to the property $forall C forall T (P(C, T) -> s(C, T))$.

We select some $T\*$ such that $R[X, C, T\*]$ is true. This must exist since $P^R = dom(R) and forall T (R[X, C, T] -> P[C, T])$ so $(X, C)$ is in the domain of $R$, meaning that $exists T R[X,C,T]$. 

Now since $forall T (R[X, C, T] -> P[C, T])$, we must also have that $P[C, T\*]$ is true. 

The symbolic simulation invariant for negative properties says that $L[X, C] and R[X, C, T] -> not s(C, T)$. Since $L[X, C]$ and $R[X, C, T\*]$ are true, then $not s(C, T\*)$ is true. 

By considering the example $(C, T\*)$, we have $exists C exists T (P(C, T) and not s(C, T)) equiv not forall C forall T (P(C, T) -> s(C, T))$ being true, so the property is disproven.

It is practical to note that that the set of counter examples we find is ${(C, T) | exists X(R[X, C, T] and L[X, C] and P^R [X, C])}$ which is described by the image operation on $P^R and L$, $im(P^R and L, R)$.

We can prove that the counter example analysis for negative properties is correct in a similar manner.


== Converting Relational Constraints to Functional Constraints
Traditionally STE only deals with functional properties. However, we can employ a trick to also check relational properties. 

Our relational properties are initially written as SytemVerilog assertions. We observe that each SV assertion can have its logic be shifted out of the property and into the surrounding specification circuit. 

This means that we only need to check properties that are of the form `##k signal_name` where $k$ is the number of clock cycles required to establish a certain property and `signal_name` is the name of the signal that corresponds to the property being true. We will call this signal, the "*property wire*" as its truth value reflects the truth value of the property.

Properties of this form are actually functional properties and thus can be written in the above 4 tupe form easily as `cout = [(signal_name, k:k, TRUE, FALSE)]`. We can prove this for $k$ and then use the time shift to prove the rest of of the ticks > $k$.

=== Indexing Transformations for Relational Properties
An additional benefit from this encoding method is that the property guards are extremely simple and thus have some nice properties related to the indexing transformation.

To check the properties, we would usually apply the weak preimage image operation on the guards. However, we have the following:
- $True_R = True^R = dom(R)[X, C]$
- $False_R = False^R = False$

This means that we only need to take 1 single preimage operation to get the domain and use that for checking all the various properties written in this form. In fact, computing the domain of an indexing relation generated from our automatic abstraction algorithm is a very simple operation that will be described later.

Furthermore, analysis of counter examples is also simplified. 
 $ True^R and L =  dom(R)[X, C] and L = L $ 
 
The 2nd equality comes from the fact that we take the strong preimage of the antecedents, so for any signal and time step $s$, $H_s$ and $L_s$ do not include any cases that are not in the domain of $R$. I.e. $H_s or L_s -> dom(R)$. This can be proven with induction over the circuit in the same manner as the symbolic simulation invariants.

So any time $L$ is not false, we have found a counter example.
Specifically, any $T, C$ in $im(L, R)$ is a counter example. 

== Automatic Abstraction
The original automatic abstraction algorithm from 2007 performed a recursive back propagation from the functional output of the specification to automatically create an indexing relation. By calling `bp(C, specOutput, x_0, not x_0, name)`, we would produce an abstraction that considered all the cases that caused the `specOutput` to be `true` or `false`, while keeping all the signals in `C` as symbolic constants.

The cost savings of the indexing relation came from only using 1 BDD variable on `XNOR` gates and doing a binary encoding on AND gates with $>= 3$ inputs.
  - For the XNOR gate, we only needed to consider if it was true or false, and it was true by having both inputs equal and false by having both inputs different.
  - For the AND gate with $n$ inputs, we have $n+1$ cases. Either any of the inputs are false, i.e. the first $n$ cases, or all of them are true, the last case. This would be constrasted with the $2^n$ cases that would be required if we did not use the indexing relation.

This has been reimplemented and improved.

Since we are looking specifically at properties of the form "the property wire is true", we don't need to be concerned with considering any indexing case where the property wire is false (because there shouldn't be any). This means that we should run 

#align(center)[
  `bp(C, property_wire, TRUE, FALSE, name)`
]

To generate the required indexing relation.

=== Partitioned Abstraction Preimage
The automatic abstraction algorithm used here produces a partitioned abstraction of the form 

#align(center)[`[(expr = targVar / Cexpr, hexpr, lexpr)]`]

#let hexpr = "hexpr"
#let lexpr = "lexpr"
This is a representation of the indexing relation $and.big ("hexpr" -> "expr" and "lexpr" -> overline("expr"))$ where `expr` is either some *target variable* or an *expression of symbolic constants* while `hexpr` and `lexpr` are in terms of only the indexing variables.

This representation allows more efficient computation of preimages. We first normalise $R$ into 

$ R = S[X, C] and U[X, T] $
where $U[X, T] = and.big_(t_i in "TargVars") (h_i -> t_i and l_i -> overline(t_i)) $  

We can then make several observations. 

Firstly, $ dom(R)[X, C] = S and and.big_(i) overline(h_i and l_i) $

Proof:
$ dom(R)[X, C] &= exists T R[X, C, T]\
               &= S[X, C] and exists T U[X, T]\
               &= S[X, C] and and.big_i (exists t_i (h_i -> t_i and l_i -> overline(t_i))) \
               &= S[X, C] and and.big_i (((h_i -> 1) and (l_i -> 0)) or ((h_i -> 0 and l_i -> 1)))\
               &= S[X, C] and and.big_I (not l_i or not h_i)\
               &= S and and.big_(i) overline(h_i and l_i) $

Thus we are able to compute the domain of the indexing relation easily.

Secondly, to compute the preimage of some guard $P[C, T]$, we let $R arrow.b P$ denote that the part of the indexing relation that mentions target variables present in $P$. Specifically, if $cal(F) = "FreeTargVars"(P)$ then 

$ R arrow.b P = S[X, C] and and.big_(t_i in cal(F)) (h_i -> t_i and l_i -> overline(t_i)) $

We have that $P_R = dom(R) and P_(R arrow.b P)$

Proof:
$ P_R[X, C] &= exists T (R[X, C, T] and P[C, T])\
      &= exists T (S[X, C] and and.big_(t_i in.not cal(F)) (h_i -> t_i and l_i -> overline(t_i)) and and.big_(t_i in cal(F)) (h_i -> t_i and l_i -> overline(t_i)) and P[C, T])  \

      &= S[X, C] and exists T_(not cal(F)) (and.big_(t_i in.not cal(F)) (h_i -> t_i and l_i -> overline(t_i)))\ 
       &space space and exists T_(cal(F)) (and.big_(t_i in cal(F)) (h_i -> t_i and l_i -> overline(t_i)) and P[C, T])\  

      &= S[X, C] and exists T_(not cal(F)) (and.big_(t_i in.not cal(F)) (h_i -> t_i and l_i -> overline(t_i))) and exists T_(cal(F)) (and.big_(t_i in cal(F)) (h_i -> t_i and l_i -> overline(t_i)))\ 
       &space space and S[X, C] and exists T_(cal(F)) (and.big_(t_i in cal(F)) (h_i -> t_i and l_i -> overline(t_i)) and P[C, T]) \

      &= S[X, C] and exists T (and.big_(t_i in "targVars") (h_i -> t_i and l_i -> overline(t_i)))\ 
       &space space and exists T_(cal(F)) (S[X, C] and and.big_(t_i in cal(F)) (h_i -> t_i and l_i -> overline(t_i)) and P[C, T])\

      &= S[X, C] and and.big_i (overline(h_i and l_i)) and P_(R arrow.b P)\

      &= dom(R) and P_(R arrow.b P)
$

Now, we can even further consider common cases of $P$ that we will be constructing preimages for.

$
  P_R = cases(
    dom(R) and P "if " cal(F) sect "TargVars" = emptyset, 
    dom(R) and overline(l_i) "if " P = t_i,
    dom(R) and overline(h_i) "if " P = overline(t_i),
    dom(R) and P_(R arrow.b P) "otherwise"
  )
$

Proof:

If $cal(F) sect "TargVars" = emptyset$, $P_(R arrow.b P) = True$ so $ P_R = dom(R) and exists T (P[C, T]) = dom(R) and P $

If $P = t_i$, $P_(R arrow.b P) = (h_i -> t_i) and (l_i -> overline(t_i))$, so 
$ P_R = dom(R) and exists t_i ((h_i -> t_i) and (l_i -> overline(t_i) and t_i) and t_i) = dom(R) and overline(l_i) $

The $P = overline(t_i)$ case is analagous to the above.

== Checking Properties under Environmental Constraints
Environmental constraints are constraints on the inputs to the circuit. They are of the form $P[C, T]$ to denote that we only need a constraint to hold if $P[C, T]$ is true.

Notice that one easy way to include environmental constraints is to simply add them to the guards of the output constraint. This means that we don't need to deal with them up until checking the output constraint, and we can do so by taking the preimage of the environmental constraint under the indexing relation and checking if it implies the residual of the signal.

However, this can lead to issues where 
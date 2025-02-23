#import "@preview/derive-it:0.1.2": *

// Page Setup
#set page(
  margin: (
    x: 3cm,
    y: 3cm
  )
)
#set text(
  font: "Libertinus Serif",
  size: 11pt,
)

#set heading(
  numbering: "1."

)

// Title Page
#let author ="(Brandon Tang)"
#let title = "Indexing Transformations for
Relational Symbolic Trajectory Evaluation"

#align(center)[
  #block(text(weight: 600, 1.75em, title))
  #v(1em, weak: true)
  #text(weight: 500, 1.4em, author)
  #v(1em, weak: true)
  #text(weight: 500, 1.1em, "Computer Science (Part B)")

  #v(1em, weak: true)
  #text(weight: 500, 1.1em, "Trinity 2025")

  #v(1em, weak: true)
  #text(weight: 500, 1.1em, "Word Count: ?")

]



#pagebreak()

// Abstract
#set par(
  justify: true,
  leading: 1em,
  spacing: 2.0em,
)
#set page(
  numbering: "1"
)
#counter(page).update(1)

= Abstract

#pagebreak()

// Content Page

#outline(
  indent: auto
)

#pagebreak()


// Definitions
#let dom ="dom"
#let True = "True"
#let False = "False"
#let hexpr = "hexpr"
#let lexpr = "lexpr"
#let ent = $tack.double$
#let nent = $tack.double.not$
= Introduction
== Background
Formal verification is the process of proving that a system satisfies a given specification or set of properties. Symbolic Trajectory Evaluation (STE) @originalSTE@modelCheckingHandbook is a method to perform hardware formal verification on circuits that allows one to verify that circuits satisfied functional properties while incorporating abstraction via symbolic indexing.

The core idea of STE is doing circuit simulation over a 3-valued domain of "true", "false" and "don't know" (X) that is ordered based on information content. On any concrete set of inputs over the 3-valued domain, a simulator would propogate these values along the circuit, processing each logical gate based on a modification of its truth table to account for the "don't know" value. For example, an logical AND gate would have a truth table as in @and_three_valued_truth_table 

#figure(
  caption: "3-valued excitation function for AND gate"
)[#table(
  columns: (auto, auto, auto, auto),
  inset: 10pt,
  align: horizon,
  table.header(
    [AND], [0], [1], [X],
  ),
    [0], [0], [0], [0],
    [1], [0], [1], [X],
    [X], [0], [X], [X],

)] <and_three_valued_truth_table>

We can use this 3-valued simulation to observe behaviours of circuits on groups of related inputs. For example, by simulating the above AND gate on the inputs $0$ and $X$, we can observe that the output is $0$ and thus conclude that $0 and 0 = 1 and 0 = 0$. This has allowed us to merge the analysis of 2 cases that we would have to simulate separately in a traditional 2-valued boolean simulation.

Furthermore, rather than doing simulation of only 1 concrete instance of 3-valued inputs at once, we can make the simulator work symbolically to do multiple 3-valued simulations at once. In the case of basic boolean simulation, we could start by assigning a variable to each input and then propagate these values through the circuit, building up a propositional formula at each node that represents the truth value of the circuit node. 

For our 3-valued simulation, we do this symbolic simulation using a pair of boolean formulae over "indexing variables" on each circuit node. For each node, these are called the "high" and "low" expressions and have the following semantics.#footnote([This implementation strategy is the modern one implemented in JasperGold. The  legacy literature had different interpretations for the two expressions.])
- If high expression is true, node will be high
- If low expression is true, node will be low
- If neither are true, then the node is X
- If both are true, the node's value is inconsistent

The symbolic simulator propogates these high and low expressions through the circuit. For example, for an AND gate, on inputs with expressions $(h_A, l_A)$ and $(h_B, l_B)$, the output produced would be $(h_A and h_B, l_A or l_B)$.

Symbolic simulators generally represent these expressions as reduced, ordered binary decision diagrams (BDDs) @bddSurvey that allow for efficient manipulation and thus simulation of the circuit. We term these pairs of BDDs as dual rail BDDs.

As an example, consider verification of a 3-input AND gate. We would like to prove that $o = a and b and c$ for the inputs $a, b, c$. To use STE to verify the AND gate, we observe that rather than simulating all $2^3$ different boolean input assignments to the circuit, it is sufficient to simulate 4 cases under the 3-valued domain:
- $p and q : a = b = c = 1 $
- $overline(p) and overline(q): a = 0, b = c = X$
- $overline(p) and q: b = 0, a = c = X$
- $p and overline(q): c = 0, a = b = X$

We can enumerate these cases symbolically by assigning them propositional formulae in terms of indexing variables $p$ and $q$. Using propositonal formulae to do case splitting this way is termed as symbolic indexing.

To apply this symbolic indexing scheme, we will set the dual rail inputs as follows:
- $h_a:= p and q, l_a := overline(p) and overline(q)$
- $h_b:= p and q, l_b := overline(p) and q$
- $h_c:= p and q, l_c := p and overline(q)$

We then run the symbolic simulator, getting output $(h_o, l_o) = (p and q, overline(p) or overline(q))$. We can then conclude that the AND gate outputs true if and only if $a = b = c = 1$ and false otherwise, which is the desired property.

Legacy literature on STE @originalSTE provided theory on writing stimuli (the antecedent) to combinational circuits using a linear temporal logic, specifying an intended functional output (consequence) and then using the symbolic simulator to verify that the circuit would satisfy the output under the given stimuli. However, it was difficult to write stimuli in a manner that covered all relevant input cases and to interpret the results of the symbolic simulation to check properties. As such, the theory of indexing relation transformations @indexingTransformations was later developed to simplify usage of STE. 

To use STE with indexing transformations, we would first set up an antecedent and consequent without any abstraction from Xs, i.e. the for each input $h_i = not l_i$. We then apply a transformation on the antecedent and consequence based on an indexing relation that mapped groups of target assignments to corresponding indexing variable assignments. This would provide us with symbolic indexing in a systematic way that covered all relevant input cases, assuming a technical coverage condition on the indexing relation was met. We could then check that the transformed antecedent would lead to the transformed consequence holding on the circuit.

Further work was later done to automate the process of generating this indexing relation via an automatic abstraction algorithm @automaticAbstraction.

However, STE never quite caught on and the tools that supported it such as Intel's Forte @forte and VOSS @voss were eventually deprecated. This was mainly due to the limitation in writing functional specifications and difficulties in applying the technique to cases with environmental constraints on the inputs.

Since then, a variant of STE known as relational STE (rSTE) @rSTE that allows for specifications with arbitary relational properties has been described but not formalized. Furthermore, a dual-rail BDD symbolic simulator has been developed within the industry standard formal verification tool JasperGold @jasperGold.

This project thus reinvents theory for rSTE and brings it to the modern day in JasperGold.


== Contribution
We reinvent the theory of rSTE, providing a procedure for incorporating symbolic indexing into the rSTE workflow via indexing transformations. We provide proofs of soundness for the procedure of indexing transformations and interpretations of the simulation outputs to derive proofs and counterexamples.

We provide new proofs and formal descriptions for efficient preimage computations on a subclass of indexing relations known as partitioned indexing relations that extends the existing technique by incorporates symbolic constants @automaticAbstraction.

We formulate theory for dealing with environmental constraints in rSTE using ideas from @indexingTransformations but updated to consider partitioned indexing relations with symbolic constants.

We implement the theoretical procedures to perform rSTE with symbolic indexing in JasperGold, including procedures for efficient indexing transformations of partitioned indexing relations, calling of symbolic simulator with transformed antecedent, and checking of transformed output.

We evaluate the efficiency of rSTE on two scalable example circuits: a Content-Addressable Memory (CAM) and a multi-input maximum circuit. For each of these, we evaluate the technique with the use of a manually constructed indexing relation and an automatically generated one when compared to symbolic simulation without symbolic indexing. We used a manual indexing of the CAM based on @camIndexing and crafted an original one for the maximum circuit.

== Relation to Companion Project
While this project focuses on the process of using indexing relations to do rSTE with symbolic indexing, the companion project focuses on the automatic generation of indexing relations for rSTE. The two projects are complementary and can be used together to perform rSTE with minimal user input. 

= Theory for Relational STE
== Design Under Test, Specifications and Relational Properties
We make use of JasperGold to process a circuit design under test (DUT) written in SystemVerilog at Register Transfer Level (RTL). 

=== Relational Properties with SVA
Traditionally STE properties were functional properties that were written in a linear temporal logic that allowed you to assert that specific signals would be high or low depending on the specific stimulus on the input of the circuit. 

However, rSTE allows for more general properties through the use of a binded specification circuit that implements properties written as SystemVerilog Assertions (SVA). The specification circuit would be binded in the sense that when the DUT was elaborated, the specification circuit would be instantiated together with it and take as input, both the inputs to the DUT, as well as any internal/output signals from the DUT that the properties desired would depend on.

The key to checking relational properties is then the insight that SVA properties can be expressed as a circuit that produces a signal that is high if the property holds in that clock cycle and low otherwise. This is done as part of JasperGold's internal symbolic simulation model construction. We call the signal that represents the property being held as the "property wire".

When using the symbolic simulator without symbolic indexing, all we need to do is to do a symbolic simulation and check that the property wire is high under any assignment of inputs. 

=== Output Constraints <output_constraints>
To incorporate symbolic indexing via indexing transformations, we build an additional layer of output constraints on top of the SVA properties that we want to check. These output constraints will mirror the LTL properties from STE but are written in a 5-tuple form as implemented in VOSSII @vossII:

#align(center)[
  `Output Constraint: [(signal, tickStart, tickEnd, highExpr, lowExpr)]`
]

This output constraint means that on cases where `highExpr` is true, `signal` should be high. When `lowExpr` is true, `signal` should be low. If neither are true, then we don't assert anything about the signal. The `tickStart` and `tickEnd` are the clock cycles that the output constraint should hold for. These expressions are known as the guards of the output constraint.

Observe that each output constraint thus consists of two parts: the positive output constraint, which enforces that signal must be high under some condtions, and the negative output constraint, which enforces that signal must be low under some conditions.

Before doing the symbolic indexing, for each SVA property we wish to check, we will build a corresponding output constraint of the form: 

#align(center)[
  `Output Constraint: [(propertyWire, tickStart, tickEnd, True, False)]`
]

Which indicates that the SVA property should always hold. Such output constraints are termed as "unrestricted output constraints" since they are always expected to hold and never expected to be false. 

=== Antecedents <antecedents>
The 5-tuple form is also the form that the antecedent (stimulus) of the circuit will be written in. When a tuple `(signal, tickStart, tickEnd, highExpr, lowExpr)` is written in the stimulus, it means that the signal should be high when `highExpr` is true, low when `lowExpr` is true and X or inconsistent otherwise. 

When we do symbolic simulation without symbolic indexing, for each input signal $s$ and clock cycle $t$ that we wish to provide a unique stimulus to $s$ for, we will include a tuple `(s, t, t, z_(s,t), NOT z_(s,t))` in the antecedent. This tuple ensures a new unique BDD variable `z_(s, t)` is created, ensuring that we cover all possible input cases. We would then run the symbolic simulator with this antecedent and check that high expression of the property wire is true for all relevant clock cycles.

== Indexing Relations and Transformations
Indexing relations are used to symbolic represent input case splitting to perform symbolic indexing and are the basis of the indexing transformation procedure.

Indexing relations $R[X, C, T]$ are boolean formulae over BDD variables where
- $X$ are the indexing BDD variables that perform the symbolic indexing.
- $T$ are the target BDD variables that are indexed. These correspond to input wires in the circuit.
- $C$ are the symbolic constants that correspond to input wires that should not be indexed.

The indexing relation $R[X, C, T]$ can be interpreted as follows:
- For each $X, C$, we cover the cases $T, C$ where $exists T R[X, C, T]$. 
- Since the indexing relation can be a many to many relation, we can have multiple $T, C$ cases covered by a single $X, C$ case indexing and vice versa.

Note that the indexing relation $R'[(X, C'), emptyset, (C, T)] = R[X, C, T] and and.big (C = C')$ that doesn't use symbolic constants is equivalent to $R[X, C, T]$ from the perspective of doing symbolic simulation and its associated operations (@preimage_operations). The use of symbolic constants does not improve the expressive power of indexing relations, but rathers simplifies them to achieve higher efficiency.

=== Preimage Operations <preimage_operations>
We define operations involving the indexing relation here:

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
$ P^R [X, C] &= dom(R) and overline(overline(P)_R) \
      &= dom(R) and (forall T (R[X, C, T] -> P[C, T])) $

=== Indexing Coverage Condition
For each output constraint (@output_constraints) $i$ that we wish to check, we let the high and low expressions be $P_i$ and $Q_i$ respectively. The total space of inputs we need to check is then $B[C, T] = or.big_(i) (P_i or Q_i)$. In order for our abstraction to properly cover the space of required inputs, we require that

$ forall T forall C (B[T, C] -> exists X (R[X, C, T])) $

For unrestricted output constraints, we will have $P_i = True, Q = False$. In this case, $B[C, T] equiv True$ so the coverage condition takes the simpler form:

$ forall T forall C exists X (R[X, C, T]) $

Intuitively, the coverage condition states that each input assignment of target variables must be covered by some indexing case and thus considered by the model checker.

=== Constructing Indexing Relations
To formulate the indexing relation, we will need to encode the case splitting for the different input cases that elicit different outputs from the circuit. This is done manually for specific circuits in the examples of @CAM_example and @maxCircuit_example.

The companion project reinvents the automatic abstraction algorithm from @automaticAbstraction and implements it within JasperGold. It produces a partitioned indexing relation (@partitionedIndexingRelation) that satisfies the coverage condition by construction. 

== rSTE Model Checking Procedure <modelCheckingProcedure>
Suppose we are given an indexing relation $R$, an antecedent list `antv` and an output constraint list `cout`. We will describe the procedure to prove that the output constraints hold.

We first apply the strong preimge operations on the high and low expressions of the antecedent tuples as follows:

#align(center)[
  `antv = [(signal, tickStart, tickEnd, highExpr^R, lowExpr^R)]`
]

Next we run the symbolic simulator with the transformed antecedent. This produces an evaluation sequence which will contain `highExpr` and `lowexpr` BDD expressions for when a signal at a certain time step will definitely be high or low. If for a given assignment, neither of these expressions are true, then the signal is unknown. For a given signal and time step, we let the high expression be $H$ and $L$.

From this evaluation sequence, we can then check the output constraints. Suppose want to check a output constraint of the form `(signal, tickStart, tickEnd, P, Q)` where $P[C, T]$ and $Q[C, T]$ are the BDD expressions that correspond to inputs on which a signal should be high and low respectively. We will transform the output constraint to 
#align(center)[
`(signal, tickStart, tickEnd, P_R, Q_R)`
 ]
where $P_R$ and $Q_R$ are the weak preimages of $P$ and $Q$ under the indexing relation.

Then we analyse the `highexpr` and `lowexpr` BDD expressions from the evaluation sequence for the signal at each of the ticks in the tick range. Suppose that at a given tick $t$, for the property wire we have some the high expression as $H[X, C]$ and the low expression as $L[X, C]$. We term the high expression of the signal as the "residual" @modelCheckingHandbook.

We will check if $(P_R -> H)[X, C] equiv True$ and whether $(Q_R -> L)[X, C] equiv True$. If both of these hold, then the output constraint is satisfied.

If we have $(P^R and L) != False$ it means that some indexing cases that only index into $P$ actually cause $s$ to be low, this is a counter example to the positive part of property so the positive part of property is disproven. We can inspect the cases indexed as $im(P^R and L, R)$ to get the actual counter example in terms of the original circuit inputs. 

Similarly, if we have $(Q^R and H) != False$, we have disproven the negative part of the property.

It is possible to not prove the property but also have no counter examples. This can happen in cases where the antecedent does not provide enough information to prove or disprove the property. This is called a weak disagreement  @modelCheckingHandbook and requires refining the indexing relation to obtain a proof/counter example.

== Simplified Checking for Unrestricted Output Constraints
A benefit of the unrestricted output constraint form is that the property guards are extremely simple and thus have some nice properties related to the indexing transformation.

To check the properties, we need to know the weak/strong preimage images of the guards. However, we have the following:
- $True_R = True^R = dom(R)[X, C]$
- $False_R = False^R = False$

This means that we only need to take 1 single preimage operation to get the domain and use that for checking all the various properties written in this form. In fact, computing the domain of a partitioned indexing relation (@partitionedIndexingRelation) is a very simple operation that will be described later.

Furthermore, analysis of counter examples is also simplified. 
 $ True^R and L =  dom(R)[X, C] and L = L $ 
 
The 2nd equality comes from the fact that we use strong preimages of target variables and their negations to transform the antecedents, so for any signal and time step, $H$ and $L$ do not include any cases that are not in the domain of $R$. I.e. $H or L -> dom(R)$. This can be proven with induction over the circuit in a similar manner as the symbolic simulation invariants in @modelCheckingSoundness.

So any time $L$ is not false, we have found a counter example.
Specifically, any $T, C$ in $im(L, R)$ is a counter example. 

== Soundness of Model Checking Procedure <modelCheckingSoundness>
We prove that the model checking procedure described in @modelCheckingProcedure is sound.

=== Symbolic Simulation Invariants 
#let st = "st"
Let $st(C, T)$ be true iff the signal and time pair $st$ is high under the untransformed antecedent under some assignment of the variables in $C, T$.

Consider the low and high expressions in any signal timestep pair. We always have that

$ H_st [X, C] and R[X, C, T] -> st(C, T) \
  L_st [X, C] and R[X, C, T] -> overline(st(C, T)) $

(For all $X, C, T$)

This can be proved via induction on the fan-in of $st$. 

The main basecase is where $s$ is an input variable corresponding to a certain time step, with `highexpr` $P$ and lowexpr $overline(P)$. In this case, since we apply the strong preimage to the antecedents, we have that
$ H = P^R = dom(R) and forall T (R[X, C, T] -> P[C, T])\
  L = overline(P)^R = dom(R) and forall T (R[X, C, T] -> overline(P[C, T]))
$

This directly gives us that for all $X, C, T$ where $H[X, C] and R[X, C, T]$, we have $P[C, T]$. But $st(C, T) = P[C, T]$ since $P$ will be a target variable / symbolic constant corresponding to the stimulus to the signal at the time step in the untransformed antecedent (@antecedents), so we are done. #footnote([Note that we don't use the domain part for this. Indeed, the analysis will still work, but this serves to remove useless/inconsistent indexing cases. This is useful for counterexample analysis later on.]) The proof for $L[X, C] and R[X, C, T] -> overline(P[C, T])$ is analagous.

A more subtle basecase is when we consider a circuit node with state, such as a latch, before any stimulus from the antecedent reaches it. In this case, the high and low expressions will be false so the invariants hold trivially.

An inductive case example: 

Suppose $s = s_1 and s_2$. Since the AND gate is combinational, we fix any time step. Let $(H_(s_1), L_(s_1))$ and $(H_(s_2), L_(s_2))$ be the high and low expressions for $s_1$ and $s_2$ respectively. The symbolic simulator will give us $(H_s, L_s) = (H_(s_1) and H_(s_2), L_(s_1) or L_(s_2))$. Under any fixed $X, C, T$, @inductiveCaseAnd gives us a proof that $H_s [X, C] and R[X, C, T] -> s(C, T)$ and $L_s [X, C] and R[X, C, T] -> not s(C, T)$.

Other elementary circuit components can be proven in a similar manner.


#figure(caption: "Inductive Case on AND Gate")[ 

#ded-nat-boxed(stcolor: black, premises-and-conclusion: false, arr: (
  ("", 0, $H_s [X, C]$, "Assume"),
  ("", 0, $R[X, C, T]$, "Assume"),
  ("1", 0, $H_(s_1)[X, C] and H_(s_2)[X, C]$, [$H_s = H_(s_1) and H_(s_2)$]),
  ("", 0, $H_(s_1)[X, C] and R[X, C, T] -> s_1(C, T)$, "Inductive Hypothesis"),
  ("", 0, $H_(s_2)[X, C] and R[X, C, T] -> s_2(C, T)$, "Inductive Hypothesis"),
  ("2, 3, 4", 0, $s_1$, ""),
  ("2, 3, 5", 0, $s_2$, ""),
  ("6, 7", 0, $s$, [$s = s_1 and s_2$]),
  ("1, 2, 8", 0, $H_s [X, C] and R[X, C, T] -> s(C, T)$, "Conclusion")
))


#ded-nat-boxed(stcolor: black, premises-and-conclusion: false, arr: (
  ("", 0, $L_s [X, C]$, "Assume"),
  ("", 0, $R[X, C, T]$, "Assume"),
  ("1", 0, $L_(s_1)[X, C] or L_(s_2)[X, C]$, [$L_s = L_(s_1) or L_(s_2)$]),
  ("", 0, $L_(s_1)[X, C] and R[X, C, T] -> not s_1(C, T)$, "Inductive Hypothesis"),
    ("", 1, $L_(s_1)[X, C]$, "Assume"),
    ("2, 6, 4", 1, $not s_1(C, T)$, ""),
    ("7",  1, $not s$, $s = s_1 and s_2$),
  ("", 0, $L_(s_2)[X, C] and R[X, C, T] -> not s_2(C, T)$, "Inductive Hypothesis"),
    ("", 1, $L_(s_2)[X, C]$, "Assume"),
    ("3, 6, 5", 1, $not s_2(C, T)$, ""),
    ("7",  1, $not s$, ""),
  ("3, 5-7, 9-11", 0, $not s$, ""),
  ("1, 2, 8", 0, $L_s [X, C] and R[X, C, T] -> not s(C, T)$, "Conclusion")
))
] <inductiveCaseAnd>
 


=== Output Constraint Checking
Positive output constraints are of the form:
$ forall C forall T (P[T, C] -> s(C, T)) $

If we have that $P_R [X, C] -> H[X, C] equiv True$ and the coverage condition $forall T forall C (B[C, T] -> exists X (R[X, C, T]))$ holds, then we know the output constraint will hold as shown in @positiveOutputConstraintProof. 

#figure(caption:"Proof of Positive Output Constraint Check")[
  #ded-nat-boxed(stcolor: black, premises-and-conclusion: false, arr: (
  ("", 0, [Fresh X, C, T], ""),
  ("", 0, $P[C, T]$, "Assume"),
  ("", 0, $R[X, C, T]$, "Assume"),
  ("2, 3", 0, $P[C, T] and R[X, C, T]$, ""),
  ("4", 0, $exists T (P[C, T] and R[X, C, T])$, ""),
  ("5", 0, $P_R [X, C]$, [Definition of $P_R$]),
  ("1, 6", 0,  $forall X, C, T space (P[C, T] and R[X, C, T] -> P_R [X, C])$, [\ Since $X, C, T$ were\ arbitrary, lemma])
))

#ded-nat-boxed(stcolor: black, premises-and-conclusion: false, arr: (
  ("", 0, [Fresh $C, T$], ""),
  ("", 0, $forall X (P_R [X, C] -> H[X, C])$, "Premise"),
  ("", 0, $B[C, T] -> exists X (R[X, C, T])$, "Premise"),
  ("", 0, $P[C, T]$, "Assume"),
  ("",0, $forall X, C, T space (P[C, T] and R[X, C, T] -> P_R [X, C])$, [Lemma above]),
  ("4", 0, $B[C, T]$, [Definition of $B[C, T]$]),
  ("3, 6", 0, [Fresh $X\*$ s.t. $R[X\*, C, T]$], []),
  ("4, 5, 7", 0, [$P_R [X\*, C]$],""),
  ("2, 8", 0, $H[X\*, C]$, ""),
  ("9", 0, $s(C, T)$, [Symbolic Simulation \ Invariants]),
  ("4, 10", 0, $P[C, T] -> s(C, T)$,""),
  ("1, 11", 0, $forall C forall T (P[T, C] -> s(C, T))$, [Since $C, T$ were\ arbitrary])  
))

] <positiveOutputConstraintProof>

We can prove the check for negative output constraints of the form 
$ forall C forall T (P[T, C] -> not s(C, T)) $ 
in a similar manner.

=== Alternative Checking by Reversing the Indexing
Another way to do the check is to take the image of the residual under the indexing relation, i.e. $im(H, R)[C,T]$. This will symbolically represent all the cases for which we know the property will hold. 

$ C, T in im(H, R) &=> exists X (H[X, C] and R[X, C, T]) \
                   &=> H[X\*, C] and R[X\*, C, T] "for some" X\* \
                   &=> s(C, T) "by symbolic simulation invariant" $

We can then check that $P -> im(H,R) equiv True$. If so then the property is true. On some circuits and indexing relations, this method can avoid weak disagreements compared to the preimage method. This is particularly true if some cases in $P$ are indexed by multiple $X, C$. However, if the number of indexing variables is much less than the number of target variables, this method can be result in large BDDs that may be infeasible to compute.

=== Counter Example Analysis
Suppose that we have $P^R and L != False$. Let $(X, C)$ be such that $(P^R and L)[X, C]$ is true. We show that $(X, C)$ is a counter example to the property $forall C forall T (P[C, T] -> s(C, T))$.


#figure(caption:"Proof for Positive Property Counter Example Check")[
  #ded-nat-boxed(stcolor: black, premises-and-conclusion: false, arr: (
  ("", 0, $P^R [X, C] and L[X, C]$, "Premise"),
  ("1", 0, $dom(R)[X, C] and forall T (R[X, C, T] -> P[C, T])$, [Definition of $P^R$]),
  ("2", 0, $exists T (R[X, C, T])$, [Definition of $dom(R)$]),
  ("3", 0, [Fresh $T\*$ s.t. $R[X, C, T\*]$], []),
  ("2, 4", 0, $P[C, T\*]$, ""),
  ("", 0, $L[X, C] and R[X, C, T\*] -> not s(C, T\*)$, [Symbolic Simulation \ Invariants]),
  ("1, 3, 6", 0, $not s(C, T\*)$, ""),
  ("4, 7", 0, $P[C, T\*] -> not s(C, T\*)$, ""),
  ("8", 0,  $exists C, T (P[C, T] -> not s(C, T))$, ""),
  ("9", 0, $not forall C forall T (P[C, T] -> s(C, T))$, "Property disproven")
))
] 

It is practical to note that that the set of counter examples we find is 
$ {(C, T) | exists X(R[X, C, T] and L[X, C] and P^R [X, C])} $
which is described by the image operation on $P^R and L$, $im(P^R and L, R)$.

We can prove that the counter example analysis for negative properties is correct in a similar manner.


= Partitioned Abstraction Relations <partitionedIndexingRelation>
An important subclass of indexing relations that we consider is the partitioned indexing relation. A partitioned indexing relation is one that can be expressed in the following form: 

$ R = and.big ("hexpr" -> "expr" and "lexpr" -> overline("expr")) $

Where `expr` is either some *target variable* or an *expression of symbolic constants* while `hexpr` and `lexpr` are in terms of only the indexing variables.

In the implementation, a partitioned abstraction relation is represented as a list of tuples of the form:

#align(center)[`[(expr = targVar / Cexpr, hexpr, lexpr)]`]

The automatic abstraction algorithm produces partitioned abstraction indexing relations. The manually constructed indexing relations that we use in our examples are also partitioned abstractions.

This representation allows more efficient computation of preimages which are critical for allowing us to perform indexing transformations at scale.

== Efficient Weak Preimage Computation
We first normalise $R$ into 

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
$ P_R [X, C] &= exists T (R[X, C, T] and P[C, T])\
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

We can further consider common cases of $P$ that we will be constructing preimages for.

$
  P_R = cases(
    dom(R) and P "if " cal(F) sect "TargVars" = emptyset, 
    dom(R) and overline(l_i) "if " P = t_i,
    dom(R) and overline(h_i) "if " P = overline(t_i),
    dom(R) and P_(R arrow.b P) "otherwise"
  )
$

Proof:

If $cal(F) sect "TargVars" = emptyset$, $R arrow.b P = True$ so $ P_R = dom(R) and exists T (True and P[C]) = dom(R) and P[C] $

If $P = t_i$, $R arrow.b P = (h_i -> t_i) and (l_i -> overline(t_i))$, so 
$ P_R = dom(R) and exists t_i ((h_i -> t_i) and (l_i -> overline(t_i)) and t_i) = dom(R) and overline(l_i) $

The $P = overline(t_i)$ case is analagous to the above.

== Efficient Strong Preimage Computation
Observe that 

$ P^R &= dom(R) and overline(overline(P)_R)\
      &= dom(R) and not (dom(R) and P_(R arrow.b overline(P)))\
      &= dom(R) and not P_(R arrow.b overline(P)) 
$

This means that we don't need to do the final conjuction with $dom(R)$ when we compute a preimage if we are going to immediately be using the preimage to compute a strong preimage. 

This represents an imporant speedup since we will be doing many strong preimage computations where computing $P_(R arrow.b overline(P))$ is easy (such as when $P = t_i$) but conjucting it with $dom(R)$ takes some time since $dom(R)$ can be complex.

= Verification Under Environmental constraints <environmentalConstraints>
Environmental constraints are constraints on the inputs to the circuit. They are of the form $J[C, T]$ to denote that we only need a constraint to hold if $J[C, T]$ is true. We call such a constraint a "care predicate".

== Index Over Care Predicate Cases via Indexing Relation Restriction <indexRelationRestriction>
Notice that one easy way to include environmental constraints is to simply add them to the guards of the output constraint. We can then check for the property holding under the enviromental constraint as described above. 

However, this can lead to weak disagreements for abstractions#footnote([Notably, if we don't use abstraction then this should always work]) that merge cases covering $(C_1, T_1), (C_2, T_2)$ where $C_1, T_1 ent J$ but $C_2, T_2 nent J$, since we cannot assume that $J$ holds the $X, C$ indexing these cases. 

This is referenced in @indexingTransformations where it is recommended to find indexing relations that exactly index cases in $J$ and not any in $not J$.

To get such an indexing relation, one idea is to have a new indexing relation that is the conjuction of the original indexing relation and the input constraint. This will ensure that the indexing relation only ever indexes target variable assignments satisfying the care predicate. However, this can still lead to weak disagreements from the indexing relation being too coarse. 

An additional way to mitigate the weak disagreements is to use the alternative checking method involving reversing the indexing, described earlier. This can avoid weak disagreements in some cases but can be more computationally expensive. 

=== Preserve Partitioned Indexing Relation by Conditioning Antecedent
Using the above procedure together with a the partitioned abstraction relation unfortunately destroyes the partitioned structure, meaning we cannot directly apply the efficient preimage computations from @partitionedIndexingRelation. 

However, we can employ an equivalent strategy where we first modify each BDD expression $E$ in the antecedent to the form $E' := (E and J) or overline(J) equiv J -> E$. We can then do the strong preimage computations, allowing us to only consider the indexing cases we know $E$ to be true when the care predicate is true (corresponding to those cases that map exclusively to the bottom left 3 quadrants in @paramedIndexingRelFigure). We modify the guard of the output constraint to include $J$ and do the checking as described above. 

Compared to restriction of the indexing relation, this approach will potentially cause some signals to be $top$, but only on indexing variable assignments that exclusively index $overline(J)$. This is fine since $P_R$ and $P^R$ not will contain such cases, thus not affecting our output checking procedure for either correctness or counter example analysis. Since the only indexing cases that we consider during analysis are those that index at least one case in $P$, this is equivalent to to restriction method described above.

Since we are not modify the indexing relation, we can still use the efficient partitioned abstraction preimage operations.

== Parametric Encoding
#let al = $angle.l$
#let ar = $angle.r$
#let bp = $bold(p)$
An alternative approach would be to use a parametric encoding @paramPaper of the input constraints. A parametric encoding using the `param` function to compute a substition of the input signals with new parameterisation variables.

`param` takes a list of input constraints and a list of signals $s_1, s_2, ..., s_n$ and computes a vector of boolean functions $f_1, f_2, ..., f_n$ from new parameterisation variables $bp = {p_1, ..., p_k}$ where $k <= n$ for the purpose of substituting $s_i := f_i (bp)$. These functions satisfy the following two conditions:
- (Soundness): $forall bp, al s_i := f_i (bp) | i in 1..n ar$ satifies the input constraints 
- (Completeness): $forall al s_1, s_2, ..., s_n ar$  that satisfy the input constraints, there exists some $bp$ such that $s_i = f_i (bp)$ 

There are two ways to apply this to deal with environmental constraints.

=== Parametric Encoding of Indexing Relations
The first stategy is to apply the parametric encoding to transform an independently computed indexing relation. This was suggested in @indexingTransformations but not proven sound. Given a circuit, antecedent, input and output constraints, we will
- Compute `param` on the input constraints
- Substitute each BDD variable in the antecedent with the corresponding function from the parametric encoding
- Compute an indexing relation, possibly via the automatic abstraction algorithm
- Substitute each BDD variable in the automatic abstraction result with the corresponding function from the parametric encoding
- Do the indexing transformation on the parameterised antecedent, and output constraints
- Do the symbolic simulation and check whether the output constraint holds

We prove this to be sound. 

First we note that after we parameterise the antecedent, we still test all the cases $C, T$ such that $P[C, T]$ holds by the completeness of `param`. 

We also note that the main base case for the symbolic simulation invariants still holds even though our input signals are now functions of the parameterisation variables. In this case, we can imagine that we are doing symbolic simulation on a bigger circuit with the param functions bolted onto the front, feeding the inputs of the regular circuit. The input signals $s$ are now replaced with the param functions $f_s$ and our base case argument will still hold.

Furthermore, we also have the parameterised indexing relation satisfying the coverage condition:

Assuming that the indexing relation $R[X, C, T]$ used satisfies the coverage condition $forall T forall C (P[C, T] -> exists X R[X, C, T])$ then the parameterised indexing relation $R'[X, C, T']$ will also satisfy the coverage condition, in terms of the new parameterisation variables, i.e. $forall T' forall C exists X R'[X, C, T']$ where $T'$ is the new parameterised input signals.

#figure(caption:"Proof of Coverage Condition Satisfaction")[
  #ded-nat-boxed(stcolor: black, premises-and-conclusion: false, arr: (
  ("", 0, [Fresh $C, T'$], ""),
  ("1", 0, [Let $T = f(T')$], [Where $f$ is the \ parametric encoding]),
  ("2", 0, $P[C, T]$, [Soundness of param]),
  ("", 0, $forall T forall C (P[C, T] -> exists X R[X, C, T])$, "Premise "),
  ("3, 4", 0, $exists X R[X, C, T]$, ""),
  ("5", 0, [Fresh $X\*$ s.t. $R[X\*, C, T]$], ""), 
  ("", 0, [$R' = R[T\/f(T)]$], [Definition of $R'$]), 
  ("2, 6, 7", 0, $R'[X\*, C, T']$, ""),
  ("1, 8", 0, $forall T' forall C exists X R'[X, C, T']$, [Since $C, T'$ were \ arbitrary])
))
] 

We further show that this approach is equivalent to the indexing relation restriction method described in @indexRelationRestriction.

==== Equivalence to Indexing Relation Restriction
#figure()[
  #image("paramed_indexing_rel.jpg")
] <paramedIndexingRelFigure>
=== Parameterise Before Abstraction
== Conditioned Properties

= Experiments and Evaluation
== Content-Addressable Memory <CAM_example>
== Multi-Input Maximum Circuit <maxCircuit_example>

= Conclusion
== Future Work
#pagebreak()
#bibliography(("works.bib", "works2.yml"))
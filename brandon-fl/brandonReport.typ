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

This output constraint means that on cases where `highExpr` is true, `signal` should be high. When `lowExpr` is true, `signal` should be low. If neither are true, then we don't assert anything about the signal. The `tickStart` and `tickEnd` are the clock cycles that the output constraint should hold for.

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

==== Alternative Checking by Reversing the Indexing
Another way to do the check is to take the image of the residual under the indexing relation, i.e. $im(H, R)[C,T]$. This will symbolically represent all the cases for which we know the property will hold. 

$ C, T in im(H, R) &=> exists X (H[X, C] and R[X, C, T]) \
                   &=> H[X\*, C] and R[X\*, C, T] "for some" X\* \
                   &=> s(C, T) "by symbolic simulation invariant" $

We can then check that $P -> im(H,R) equiv True$. If so then the property is true. On some circuits and indexing relations, this method can avoid weak disagreements compared to the preimage method. This is particularly true if some cases in $P$ are indexed by multiple $X, C$. However, if the number of indexing variables is much less than the number of target variables, this method can be result in large BDDs that may be infeasible to compute.

=== Counter Example Analysis
Suppose that we have $P^R and L != False$. Let $(X, C)$ be such that $(P^R and L)[X, C]$ is true. We show that $(X, C)$ is a counter example to the property $forall C forall T (P(C, T) -> s(C, T))$.

We select some $T\*$ such that $R[X, C, T\*]$ is true. This must exist since $P^R = dom(R) and forall T (R[X, C, T] -> P[C, T])$ so $(X, C)$ is in the domain of $R$, meaning that $exists T R[X,C,T]$. 

Now since $forall T (R[X, C, T] -> P[C, T])$, we must also have that $P[C, T\*]$ is true. 

The symbolic simulation invariant for negative properties says that $L[X, C] and R[X, C, T] -> not s(C, T)$. Since $L[X, C]$ and $R[X, C, T\*]$ are true, then $not s(C, T\*)$ is true. 

By considering the example $(C, T\*)$, we have $exists C exists T (P(C, T) and not s(C, T)) equiv not forall C forall T (P(C, T) -> s(C, T))$ being true, so the property is disproven.

It is practical to note that that the set of counter examples we find is ${(C, T) | exists X(R[X, C, T] and L[X, C] and P^R [X, C])}$ which is described by the image operation on $P^R and L$, $im(P^R and L, R)$.

We can prove that the counter example analysis for negative properties is correct in a similar manner.



= Partitioned Abstraction Relations <partitionedIndexingRelation>
== Efficient Preimage Computation
== Efficient Strong Preimage Computation

= Verification Under Environmental constraints <environmentalConstraints>
== Index Over Care Predicate Cases via Indexing Relation Restriction
=== Preserve Partitioned Indexing Relation by Conditioning Antecedent
== Parametric Encoding
=== Parametric Encoding of Indexing Relations
==== Equivalence to Indexing Relation Restriction
=== Parameterise Before Abstraction
== Conditioned Properties

= Experiments and Evaluation
== Content-Addressable Memory
== Multi-Input Maximum Circuit

= Conclusion
#pagebreak()
#bibliography(("works.bib", "works2.yml"))
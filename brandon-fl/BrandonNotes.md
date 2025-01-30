# Brandon's Notes

## Symbolic Constants
- In both the 2007 paper and the current implementation, we support symbolic constants, which are some physical signals that we wish to directly map to a corresponding BDD variable and not do abstraction over.
- Suppose these signals are $s_1, s_2, ..., s_n$, we could create new bdd variables $c_1, c_2, ..., c_n$ and add $s_i = c_i$ to the indexing relation. However, this is actually unnecessary and we can directly "use $c_i$ as $s_i$ interchangably".
- This means that the relation we create will be of the form `R[X, C, T]` where
    - `X` is the indexing variables, `C` is the symbolic constants and `T` is the target variables to be abstracted.
    - The coverage condition is then `∀T∀C ∃X R[X, C, T]`
    - A (weak) preimage $P_R$ is then in terms of both symbolic constants and indexing variables, i.e. $P_R[X, C] = ∃T (R[X, C, T] \land P[T, C])$
        - Todo: proof
        - Idea: consider the indexing relation with the $c_i = s_i$ conjuncts and show that the expressions computed for the preimage computation and coverage condition are effectively the same.

## Indexing Transformation of Functional Output/Input Constraints in rSTE Form
- The 2002 Paper describes weak and strong preimage computations on consequences and antecedents written in linear temporal logic (LTL) form. However, this has be scrapped in favor of a 4 tuple form in the 2007 paper, in VOSS and in JasperGold.
- LTL formulae are rewritten into equivalent lists of tuples of the following form:
    - `cout = [(signal, tickStart:tickEnd, highExpr, lowExpr)]`
    - Equivalent to `N^tick ((highExpr -> (signal is 1) and lowExpr -> (signal is 0))) for each tick in the range`.
    - This means that when the assignment of BDD variables make `highExpr` true, we need the signal to be high from `tickStart` to `tickEnd`. Similarly for `lowExpr`
    - This is the canonical form of output constraints for rSTE in the 2007 paper and in JasperGold.
- When we apply an indexing transformation to the consequence, the recursive algorithm in the paper is equivalent to transformation of the above `cout` into
    - `cout = [(signal, tickStart:tickEnd, weakPreimage idx_rel highExpr, weakPreimage idx_rel lowExpr)]`
    - `(N^tick (highExpr -> (signal is 1) and lowExpr -> (signal is 0))))_R = (N^tick ((highExpr_R -> (signal is 1) and lowExpr_R -> (signal is 0)))`
    
- TODO: Write a constructive proof that all LTL formulae can be rewritten in the 4 tuple form.

## Converting Relational Constraints to Functional Constraints for rSTE
- To deal with relational constraints, we observe that each SV assertion can have its logic be shifted out of the property and into the surrounding specification circuit. This means that we only need to check properties that are of the form `##k signal_name` where $k$ is the number of clock cycles required to establish a certain property and `signal_name` is the name of the signal that corresponds to the property being true. 
    - We will call this signal, the "property wire" as its truth value reflects the truth value of the property.

- Properties of this form are actually functional properties and thus can be written in the above 4 tupe form easily as `cout = [(signal_name, k:k, TRUE, FALSE)]`
    - and use the time shift to prove the rest of of the ticks > $k$
- From this, we can apply the weak preimage image operation on `TRUE` and `FALSE` as described in the section of how to check functional properties in rSTE form.
    - In fact, even if we have multiple properties to check, we will always be taking weak preimages of `TRUE` and `FALSE` so do not need to repeatedly perform the preimage operation.
    - Furthermore, the preimage of `FALSE` is always `FALSE`
    - The preimage of `TRUE` can be thought of as any assigments to XS that have any mapping to the targets TS. I.e. the useful and consistent   cases of the abstraction.
        - This is described as $dom(R)[X] = ∃T\  R[X,T]$ in the 2007 paper.

    - Note that this even works when we do parameterisation since when we substitute the functions for the original variables, we won't be doing any substitution in the `TRUE` and `FALSE` expressions.

## Checking rSTE Form Constraints
- When we do the symbolic simulation in terms of the indexing variables and symbolic constants, we will end up with an evaluation sequence. This evaluation sequence will contain `sigHighExpr` and `sigLowExpr` BDD expressions for when a signal at a certain time step will defintely be high or low. If for a given assignment, neither of these expressions are true, then the signal is unknown.
    - We are interested in the property wire. Lets focus on a specific time and property. Suppose that at a given tick $t$, for the property wire we have some `sigHighExpr` and `sigLowExpr` expressions. 
    - The `sigHighExpr` is the expression for which the property will be true, in terms of the indexing variables and the symbolic constants. In regular STE terms, this would be referred to as the "residual".
- Our rewritten and index transformed properties are of the form `(signal, tickStart:tickEnd, dom(R)[X, C], False)`
- We need to show that in assignments where the property is required to be true, the property wire is high and in assignments where the property is required to be false, the property wire is low.
    - This corresponds to checking if `dom(R)[X, C] -> sigHighExpr and False -> sigLowExpr` is true. 
    - Since `False` always implies everything, we just need to show that `dom(R)[X, C] -> sigHighExpr` is true.
    - Intuitively, this means that for any valid indexing case, the residual expression is true.

### Correctness
- We do a strong preimage on the guards in the antecent:
    - Suppose we do a strong preimage on the `highexpr` of some `antv` expr `e`. This corresponds to only setting `e` to be true for indexing cases that don't abstract over real cases with `e` sometimes being true and `e` sometimes being false. This is a weakening of the antecedent.
- We do a weak preimage on the guards of the output constraints:
    - Suppose we do a weak preimage on the `highexpr` of some `cout` expr `e`. This corresponds to requiring the constraint to hold for every indexing case that causes `e` to be true, i.e. all cases where the constraint is required to be true. This is a strengthening of the constraint.

### Counter Examples and Unproven Cases
- For each assignment of indexing input $(X, C)$, we can end up with the property in 1 of 3 cases:
    - Proven: $highexpr(X, C) \land \lnot lowexpr(X, C) \equiv true$
    - Unproven: $\lnot highexpr(X, C) \land \lnot lowexpr(X, C) \equiv true$
    - Counterexample: $\lnot highexpr(X, C) \land lowexpr(X, C) \equiv true$
- We can do analysis on unproven cases and counter examples by inspecting the residual $Q[X, C]$
    - Specifically, we need to check which cases are not indexed by $Q \land Dom(R)$
    - $Cex[T, C] = \forall X (R[X, C, T] \land Dom(R)[X, C] \rightarrow \lnot Q[X, C])$
    - $Cex[T, C] = \lnot I_{(Dom(R) \land Q), R}[T, C]$ 
    - Where $I_{P, R}[T, C] = \exists X (R[T, C, X] \land P[X, C])$ 

## Automatic Abstraction for rSTE Properties
- The original automatic abstraction algorithm from 2007 performed a recursive back propagation from the functional output of the specification.  By calling `bp(C, specOutput, x_0, not x_0, name)`, we would produce an abstraction that considered all the cases that caused the specOutput to be `true` or `false`
    - The cost savings of the indexing relation came from only using 1 BDD variable on `XNOR` gates and doing a binary encoding on AND gates with $>= 3$ inputs.
    - For the XNOR gate, we only needed to consider if it was true or false, and it was true by having both inputs equal and false by having both inputs different.
    - For the AND gate with $n$ inputs, we have $n+1$ cases. Either any of the inputs are false, i.e. the first $n$ cases, or all of them are true, the last case. This would be constrasted with the $2^n$ cases that would be required if we did not use the indexing relation.

- In the current implementation, we are looking specifically at properties of the form "the property wire is true". This means we don't need to be concerned with considering any indexing case where the property wire is false (because there shouldn't be any). 
    - This means that we should run `bp(C, property_wire, TRUE, FALSE, name)`

- This is done in simple brandon, `verify_dfv.tcl`



## Preimage Computations of Partitioned Abstractions
- The automatic abstraction algorithm used here produces a partitioned abstraction of the form `[(targVar / Cexpr, hexpr, lexpr)]`
    - This is a representation of the indexing relation $\bigwedge (hexpr \rightarrow expr \land lexpr \rightarrow \overline{expr})$ 
    - `expr` is either some *target variable* or an *expression of symbolic constants*
    - `hexpr` and `lexpr` are in terms of only the indexing variables.

- This means that we can split the indexing relation into $R = S[X, C] \land T[X, T]$ where $T = \bigwedge_{t_i} (hexpr \rightarrow t_i \land lexpr \rightarrow \overline{t_i})$  

- Note that this analysis only applies when we don't do a parameterisation of the the circuit which would entail a substitution of the target variables with functions over target variables and symbolic constants within the indexing relation.

- To do the indexing transformation, we only need to look the components of $T[X, T]$ that are relevant, i.e. have target variables that are present in any predicate $P$ that we take preimages of.
    - Details in 2007 paper

## Environmental Constraints
To deal with environmental constraints, i.e. input constraints `cin` = $P[T, C]$, we can take one of the following approaches:

*Expand Circuit with Param*
- We can perform `param` on the constraints and then do the automatic abstraction on an enlarged circuit that includes the parameterised constraints.
- But now there is an issue regarding symbolic constants. If the symbolic constants are not present in the  $P[T, C]$, we can probably do the parameterisation avoiding substituting those constants. Otherwise maybe we need to make all the `param` variables that they depend on into symbolic constants.

*Encode Constraint into Indexing Relation*
- This is the first method in the 2002 paper.
- Has the issue where we cannot use the efficient preimage computatations described above the partitioned abstraction structure is broken.

*Symbolic Simulation without Constraint followed by Residual Analysis*
- We can do the indexing transformation and simulation while first ignoring the constraint. We will then get a residual that is in terms of the indexing variables and the symbolic constants.
    - We can now take the image of the indexed residual under the indexing relation to get the relevant cases of the inputs where the residual is true. This gets us the non-indexed residue. We can then check that the $P$ implies this residual. I.e. when $P[T, C]$ is true, the residual is true.
        - This (weak) image operation corresponds to $I_{(Q, R)}[T, C] = \exists X (R[T, C, X] \land Q[X, C])$ where $Q$ is the indexed residual.
        - The check that is done is if $(P \rightarrow I_{(Q, R)})[T, C] \equiv true$
        - Doing this image computation may not be straightforward.

    -  The alternative strategy is to consider $M_{(P, R)}[X, C]$ as the minimal preimage of $P$.
        - This minimal preimage must cover $P$, i.e. $\forall T, C (P[T, C] \rightarrow \exists X (R[X, C, T]))$
        - We then check that $(M_{(P, R)} \rightarrow Q)[X,C] \equiv true$ where $Q$ is the indexed residual.
        - The weak preimage $P_R$ is a superset of the minimal preimage, so we have $M_{(P, R)} \rightarrow P_R$
            - This can be used as a sound but incomplete check of the property since if we have $P_R \rightarrow Q$ then we have $M_{(P, R)} \rightarrow Q$.
        - Note that this method can introduce false negatives (false counterexamples) from indexing assignments that also correspond to $\lnot P$
            - If the indexing relation also happens to satisfy $P^R = P_R$, i.e. there are no indexing assignments that index cases in $P$ and $\lnot P$, then there is no risk of false negatives.

        - This is similar to the 2nd method discussed in the 2002 paper.

- With these strategies, we can try for a smaller indexing relation since we just need a reduced coverage condition:
    - $\forall T, C (P[T, C] \rightarrow \exists X (R[X, C, T]))$

- Optimally we could get an indexing relation that only indexes exactly the cases in $P$, i.e. with the condition that
    - $\forall X, C, T (R[X, C, T] \leftrightarrow P[T, C])$
    - This would satisfy both the coverage and no mixed indexing conditions.
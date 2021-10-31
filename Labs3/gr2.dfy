/*
BNF
 Id ::= [a-zA-Z][a-zA-Z0-9]*
 Int ::= [+- ][0-9]+
 Bool ::= “True” | “False”
 Undef ::= “Undef” 
 Val :: = Int | Bool | Undef
 Var ::= Id
 Exp ::= Val | Var | Exp “+” Exp | Id “=” Exp | ...
 Stmt ::= Exp; | if ... | ...

AST
 Id ::= Id(string)
 Int ::= Int(int)
 Bool ::= Bool(bool)
 Var(Id(String))   ---> Var(String)
 Val ::= Int | Bool | Undef
 Exp ::= Val | Var | Id | Plus(Exp, Exp) | ...

Stmt ::= Assgn(Id, Exp) | ...

 b = a + 5;

 b ≡ Var("b")
 a ≡ Var("a")
 5 ≡ Int(5)

 a + 5
 Plus(Var("a"), Val(Int(5))) 

 b = a + 5
 Assgn("b", Plus(Var("a"), Val(Int(5)))
 */

datatype Val = Int(i: int) | Bool(b: bool) | Undef

datatype Exp =
   Val(val: Val)
 | Var(name: string)
 | Plus(lhs: Exp, rhs: Exp)
 | Assg(vn: string, exp: Exp)

// state = map<string, Val>
predicate BigStepExp(exp: Exp, ini: map<string, Val>, val: Val, fin: map<string, Val>)
{
    match exp
        case Val(v) => val == v && fin == ini
        case Var(vn) => if vn in ini then val == ini[vn] && fin == ini else false
        case Plus(e1, e2) => 
            exists v1: Val, v2: Val, sigma1: map<string, Val> ::
            BigStepExp(e1, ini, v1, sigma1) && 
            BigStepExp(e2, sigma1, v2, fin) &&
            v1.Int? && v2.Int? && val.Int? && v1.i + v2.i == val.i
        case Assg(x, e) =>
            exists v: Val, sigma': map<string, Val> ::
            BigStepExp(e, ini, v, sigma') &&
            fin == sigma'[x := v] && val == v
}

lemma Test1()
{
    // init(x |-> 4, y |-> true)
    var init := map["x" := Int(4), "y" := Bool(true)];
    var final := map["x" := Int(4), "y" := Int(11)];
    assert BigStepExp(Val(Int(7)), init, Int(7), init);
    //assert BigStepExp(Var("x"), init, Int(4), init);
    var e1 := Plus(Var("x"), Val(Int(7)));
    assert BigStepExp(e1, init, Int(11), init);
    var e2 := Assg("y", e1);
    assert BigStepExp(e2, init, Int(11), final);
}

datatype Stmt =
   Exp(exp: Exp)  // Exp;
 | While(tst: Exp, bdy: Stmt) // while (tst) bdy

predicate BigStepStmt(stmt: Stmt, ini: map<string, Val>, fin: map<string, Val>, gas: nat)
decreases stmt, gas
{
    match stmt
        case Exp(e) => 
            exists v: Val :: BigStepExp(e, ini, v, fin)
        case While(test, body) =>
            exists v: Val, sigma': map<string, Val> ::
            BigStepExp(test, ini, v, sigma') && v.Bool? &&
            if (v.b) 
            then
                exists sigma1: map<string, Val>, gas': nat ::
                BigStepStmt(body, sigma', sigma1, gas') &&
                0 < gas' < gas &&
                BigStepStmt(stmt, sigma1, fin, gas-gas') &&
                0 < gas' < gas
            else fin == sigma'

}

lemma Test2()
{
    // init(x |-> 4, y |-> true)
    var init := map["x" := Int(4), "y" := Bool(true)];
    var final := map["x" := Int(4), "y" := Int(11)];
    assert BigStepExp(Val(Int(7)), init, Int(7), init);
    //assert BigStepExp(Var("x"), init, Int(4), init);
    var e1 := Plus(Var("x"), Val(Int(7)));
    assert BigStepExp(e1, init, Int(11), init);
    var e2 := Assg("y", e1);
    assert BigStepExp(e2, init, Int(11), final);
    // e2;
    assert BigStepStmt(Exp(e2), init, final, 0);
}

lemma expIsDeterminstic(exp: Exp, ini: map<string, Val>,
                        v1: Val, fin1: map<string, Val>,
                        v2: Val, fin2: map<string, Val>)
requires BigStepExp(exp, ini, v1, fin1) &&
         BigStepExp(exp, ini, v2, fin2)
ensures v1 == v2 && fin1 == fin2
{
    //?
}

lemma stmtIsDeterminstic(stmt: Stmt, ini: map<string, Val>,
                        fin1: map<string, Val>,
                        fin2: map<string, Val>)
requires exists gas: nat :: BigStepStmt(stmt, ini, fin1, gas) &&
         exists gas: nat :: BigStepStmt(stmt, ini, fin2, gas)
ensures fin1 == fin2
{
    //?
}

/*
  HW: 
  1. Prove stmtIsDeterministic().
  2. Add semantics for if, sequential composition, and block.
  Deadline: November 2, 14:00
*/
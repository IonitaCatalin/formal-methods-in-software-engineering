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
   Exp(exp: Exp)  
 | If(cond: Exp, bdy: Stmt, els: Stmt)
 | Seq(seq': Stmt, seq'': Stmt)
 | While(tst: Exp, bdy: Stmt) 

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
        case If(test,body,els) => 
            exists v: Val, sigma': map<string, Val> ::
            BigStepExp(test, ini, v, sigma') && v.Bool? &&
            if(v.b)
            then
                exists sigma1: map<string, Val>,gas':nat ::
                BigStepStmt(body, sigma', sigma1, gas') &&
                0 < gas' < gas
            else fin == sigma'
        case Seq(seq',seq'') =>
            exists sigma': map<string, Val>, gas':nat ::
            BigStepStmt(seq',ini, sigma', gas') &&
            0 < gas' < gas &&
            BigStepStmt(seq'', sigma', fin, gas - gas')


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

/*
  HW: 
  1. Prove stmtIsDeterministic().
  2. Add semantics for if, sequential composition, and block.
  Deadline: November 2, 14:00
*/

lemma stmtIsDeterminstic(stmt: Stmt, ini: map<string, Val>,
                        fin1: map<string, Val>,
                        fin2: map<string, Val>)
requires exists gas1: nat :: BigStepStmt(stmt, ini, fin1, gas1) &&
         exists gas2: nat :: BigStepStmt(stmt, ini, fin2, gas2)
ensures fin1 == fin2
{
    match stmt
        case Exp(e) =>
            var v1: Val :| BigStepExp(e, ini, v1, fin1);
            var v2: Val :| BigStepExp(e, ini, v2, fin2);
            expIsDeterminstic(e, ini, v1, fin1, v2, fin2);
        case While(exp , stm) =>
            var  v: Val, sigma': map<string, Val> :|
            BigStepExp(exp, ini, v, sigma') && v.Bool?;
            if(v.b){
                var gas1: nat :| BigStepStmt(stmt, ini, fin1, gas1);
                var gas2: nat :|  BigStepStmt(stmt, ini, fin2, gas2);

                var sigma1, gas1' :| 0 < gas1' < gas1 && BigStepStmt(stm, ini, sigma1, gas1') && BigStepStmt(stmt, sigma1, fin1, gas1 - gas1');
                var sigma2, gas2' :| 0 < gas2' < gas2 && BigStepStmt(stm, ini, sigma2, gas2') && BigStepStmt(stmt, sigma2, fin2, gas2 - gas2');                
                
                stmtIsDeterminstic(stm, ini, sigma1, sigma2);
                assert sigma1 == sigma2;
                stmtIsDeterminstic(stmt, sigma1, fin1, fin2);
                assert fin1 == fin2;
            }
            else{
                
            }
        case If(exp, stm1, stm2) =>
            var  v: Val, sigma': map<string, Val> :|
            BigStepExp(exp, ini, v, sigma') && v.Bool?;

            if(v.b){
                stmtIsDeterminstic(stm1, ini, fin1, fin2);
                assert fin1 == fin2;
            }else{
                stmtIsDeterminstic(stm2, ini, fin1, fin2);
                assert fin1 == fin2;
            }
        case Seq(stm1, stm2) => 
            var gas1: nat :| BigStepStmt(stmt, ini, fin1, gas1);
            var gas2: nat :|  BigStepStmt(stmt, ini, fin2, gas2);

            var sigma', gas1' :| 0 < gas1' < gas1 && BigStepStmt(stm1, ini, sigma', gas1') && BigStepStmt(stm2, sigma', fin1, gas1 - gas1');
            var sigma'', gas2' :| 0 < gas2' < gas1 && BigStepStmt(stm1, ini, sigma'', gas2') && BigStepStmt(stm2, sigma'', fin2, gas2 - gas2');
            
            stmtIsDeterminstic(stm1, ini, sigma', sigma'');
            assert sigma' == sigma'';
            stmtIsDeterminstic(stm2, sigma', fin1, fin2);
            assert fin1 == fin2;
}


predicate isNatural(x: int)
{
    x >= 0
}

lemma L1()
    ensures isNatural(8);
    {
        //
    }

newtype natural = x: int | isNatural(x)

lemma NatSum(x: int, y: int)
    ensures isNatural(x) && isNatural(y) ==> isNatural(x+y)
    {
        //
    }

function min32(): int
{
    -214783648
}

function max32(): int
{
    214783647
}

predicate isInt32(x: int)
{
    min32() <= x <= max32()
}

newtype int32 = x: int | isInt32(x)

function add32(x: int32, y:int32) : int32
{
    var res := x as int + y as int;

    if (isInt32(res)) then res as int32
    else if (res < min32()) then (max32() + 1 - min32() + res) as int32
    else (res - max32()) as int32
}

lemma MinusInt32(x: int)
requires isInt32(x)
ensures x > min32() ==> isInt32(-x)
{
    //
}

function minus32(x: int32) : int32
{
    if(x == min32() as int32) then x else -x
}

lemma Minus()
ensures forall x: int32 :: add32(x, minus32(x)) == 0 as int32
{
    //
}

lemma CommAdd32(x: int32, y: int32)
    ensures add32(x, y) == add32(y, x)
    {
        //
    }

predicate IsPrime(x: natural)
{
    x >= 2 && forall y: natural :: 2 <= y < x ==> x % y != 0
}

// lemma InfinitePrimeNumbers()
// ensures forall x: natural :: exists y: natural :: IsPrime(y) && y > x 
// {
//     //
// }

lemma TwoIsPrime(x: natural)
requires IsPrime(x) && x > 2
ensures x % 2 != 0
{
    //
}

lemma EveryPrimeNumberNotTwoIsOdd(x: natural)
requires IsPrime(x) && x > 2
ensures !IsPrime(x + 1)
{
    TwoIsPrime(x);
    assert (x + 1) % 2 == 0;
}

predicate SixK1(x: natural) 
{
    IsPrime(x) && x >= 5 ==> exists k: int :: x as int == 6*k + 1 || x as int == 6*k + 5
}


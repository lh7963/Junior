G52AFP Coursework 2 - Monadic Compiler

Han Lin
psyhl4@nottingham.ac.uk

--------------------------------------------------------------------------------

Imperative language:

> data Prog = Assign Name Expr
>           | If Expr Prog Prog
>           | While Expr Prog
>           | Seq [Prog]
>             deriving Show
>
> data Expr = Val Int | Var Name | App Op Expr Expr
>             deriving Show
>
> type Name = Char
>
> data Op = Add | Sub | Mul | Div 
>                              deriving (Show,Eq) 

Factorial example:

> fac :: Int -> Prog
> fac n = Seq [Assign 'A' (Val 1),
>              Assign 'B' (Val n),
>              While (Var 'B') (Seq
>                 [Assign 'A' (App Mul (Var 'A') (Var 'B')),
>                  Assign 'B' (App Sub (Var 'B') (Val (1)))])]

Virtual machine:

> type Stack = [Int]
>
> type Mem   = [(Name,Int)]
>
> type Code  = [Inst]
> 
> data Inst  = PUSH Int
>            | PUSHV Name
>            | POP Name
>            | DO Op
>            | JUMP Label
>            | JUMPZ Label
>            | LABEL Label
>              deriving (Show,Eq)
> 
> type Label = Int

State monad:

> type State = Label
>
> newtype ST a = S (State -> (a, State))
>
> app :: ST a -> State -> (a,State)
> app (S st) x 	=  st x
>
> instance Functor ST where
>    -- fmap :: (a -> b) -> ST a -> ST b
>    fmap g st = S (\s -> let (x,s') = app st s in (g x, s'))
>
> instance Applicative ST where
>    -- pure :: a -> ST a
>    pure x = S (\s -> (x,s))
>
>    -- (<*>) :: ST (a -> b) -> ST a -> ST b
>    stf <*> stx = S (\s ->
>       let (f,s')  = app stf s
>           (x,s'') = app stx s' in (f x, s''))
>
> instance Monad ST where
>    -- return :: a -> ST a
>    return x = S (\s -> (x,s))
>
>    -- (>>=) :: ST a -> (a -> ST b) -> ST b
>    st >>= f = S (\s -> let (x,s') = app st s in app (f x) s')

---------------------------------------------------------------------------------
                            
comp
goal        : translates a program into machine code
explanation : for using state monad, it need a heler function called mcompprog to deal side effect which is changing the state when it need while transfering the code
arguments   : just the program code
outcome     : the machine code
                             
> comp :: Prog -> Code
> comp p = fst( app ( mcompprog p ) 0 )

mcompprog   : helper function of comp
explanation : implementing state monad, 
arguments   : 

> mcompprog :: Prog -> ST Code
> mcompprog (Seq []) = return []
> mcompprog (Assign n e) = return (compExpr e ++ [POP n])
> mcompprog (While e p) = do code <- mcompprog p
>                            l <- getLabel_and_changeState
>                            return ([LABEL l] ++ compExpr e ++ [JUMPZ (l+1)] ++ code ++ [JUMP l, LABEL (l+1)])

> mcompprog (If e p1 p2) = do code1 <- mcompprog p1
>                             code2 <- mcompprog p2
>                             l1 <- getLabel_and_changeState
>                             l2 <- getLabel_and_changeState
>                             return (compExpr e ++ [JUMPZ l1] ++ code1 ++ [JUMP (l1 + 1), LABEL l1] ++ code2 ++ [LABEL (l1+1)])

> mcompprog (Seq (p:ps)) = do code_ahead <- mcompprog p
>                             code_later <- mcompprog (Seq ps)
>                             return (code_ahead ++ code_later)
                            
                            
--helper function---------------------------------------------------------------------------------------------------------------------------------------                            

                           
> getLabel_and_changeState :: ST Label
> getLabel_and_changeState = S(\s -> (s,s+1))               
  
> compExpr :: Expr -> Code
> compExpr (Val v) = [PUSH v]
> compExpr (Var n) = [PUSHV n]
> compExpr (App o e1 e2) = compExpr e1 ++ compExpr e2 ++ [DO o]

-----------------------------------------------------------------------------------------------------------

> exec :: Code -> Mem
> exec is = exechelper is ([],[],[])

[
label 6
instruction 1 

instruction 2
instruction 3
instruction 4
label2


Label 1
instruction 5
instruction 6
jump 2
jump 1
Jump 2
Jump 2]

dropWhile f 
Int -> Code -> Code 





> type Label_code = [(Int,Code)]
> type Machinestate = (Label_code, Stack, Mem)

> exechelper :: Code -> Machinestate -> Mem
> exechelper [] (_,_,m) = m
> exechelper (x:xs) (lc,s,m) = case x of
>                                            PUSH n -> exechelper xs ( lc, n:s, m)
>                                            PUSHV c -> exechelper xs ( lc, (getfromname m c) : s ,m)
>                                            POP c -> exechelper xs ( lc, drop 1 s, assignwithvalue (c,s!!0) m )
>                                            DO op -> exechelper xs (lc , (doop op s):(drop 2 s), m)
>                                                     
>                                            LABEL l -> exechelper xs ((l,xs):lc, s , m) --xs is the remain code after the Label l
>                                            JUMP l -> exechelper (get_remain_code lc l (x:xs)) (lc, s, m)
>                                            JUMPZ l -> case s!!0 of
>                                                            0 -> exechelper (get_remain_code lc l (x:xs)) (lc, drop 1 s, m)  -- jump
>                                                            _ -> exechelper xs (lc,drop 1 s,m) -- just continue
 
 
> interp :: Integral a => Op -> a -> a -> a
> interp Add = (+)
> interp Sub = (-)
> interp Mul = (*)
> interp Div = (div)

> doop :: Integral a => Op -> [a] -> a
> doop o (a:b:s) = (interp o) b a


 
> getfromname:: Mem-> Name -> Int
> getfromname ((c_inMem,v):xs) c  | c_inMem == c = v
>                                 | otherwise = getfromname xs c

> assignwithvalue:: (Name, Int) -> Mem -> Mem
> assignwithvalue (c,v) [] = [(c,v)]
> assignwithvalue (c,v)((c',v'):ms) | c == c' = (c',v): ms
>                                   | otherwise = (c',v'): (assignwithvalue (c,v) ms)

-- go throught the [(label , code0], if not found, go through the remain code                    

> get_remain_code :: [(Int,Code)] -> Label -> Code -> Code
> get_remain_code [] l [] = []
> get_remain_code [] l ( i : is ) | (LABEL l) == i = is
>                                 | otherwise = get_remain_code [] l is
> get_remain_code ((l',afterl'):lc) l is | l' == l = afterl'
>                                        | otherwise = get_remain_code lc l is
               
--test-----------------------------------------------------------------------------------------------------------
                                                
> firsttest2 :: Prog
> firsttest2 = Seq [Assign 'A' (App Mul (Var 'A') (Var 'B')), Assign 'B' (App Sub (Var 'B') (Val (1)))]

> testExpr :: Expr
> testExpr =  App Sub (Var 'B') (Val (1))                                       
> tett = [PUSH 1, POP 'A', PUSH 10, POP 'B']
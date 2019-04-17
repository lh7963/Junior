--G52AFP Coursework 2 - Monadic Compiler

--Han Lin
--psyhl4@nottingham.ac.uk

--------------------------------------------------------------------------------

--Imperative language:

data Prog = Assign Name Expr
          | If Expr Prog Prog
          | While Expr Prog
          | Seq [Prog]
            deriving Show
data Expr = Val Int | Var Name | App Op Expr Expr
            deriving Show
type Name = Char
data Op   = Add | Sub | Mul | Div
            deriving (Eq,Show)

--Factorial example:

fac :: Int -> Prog
fac n = Seq [Assign 'A' (Val 1),
             Assign 'B' (Val n),
             While (Var 'B') (Seq
                [Assign 'A' (App Mul (Var 'A') (Var 'B')),
                 Assign 'B' (App Sub (Var 'B') (Val (1)))])]

--Virtual machine:

type Stack = [Int]

type Mem   = [(Name,Int)]

type Code  = [Inst]
 
data Inst  = PUSH Int
           | PUSHV Name
           | POP Name
           | DO Op
           | JUMP Label
           | JUMPZ Label
           | LABEL Label
             deriving (Eq,Show)
 
type Label = Int


--State monad:

type State = Label

newtype ST a = S (State -> (a, State))

    

app :: ST a -> State -> (a,State)
app (S st) x =  st x

instance Functor ST where
   -- fmap :: (a -> b) -> ST a -> ST b
   fmap g st = S (\s -> let (x,s') = app st s in (g x, s'))
instance Applicative ST where
   -- pure :: a -> ST a
   pure x = S (\s -> (x,s))
   -- (<*>) :: ST (a -> b) -> ST a -> ST b
   stf <*> stx = S (\s ->
      let (f,s')  = app stf s
          (x,s'') = app stx s' in (f x, s''))

instance Monad ST where
   -- return :: a -> ST a
   return x = S (\s -> (x,s))
   -- (>>=) :: ST a -> (a -> ST b) -> ST b
   st >>= f = S (\s -> let (x,s') = app st s in app (f x) s')

--------------------------------------------------------------------------------

mcomp :: Prog -> Code
mcomp p = fst( app ( mmcompprog p ) 0 )
compprog :: Prog -> Label -> (Code , Label)
compprog (Seq []) l = ([],l)
compprog (Seq (x:xs)) l = (  atfirst_cod_sequence ++ atother_cod_sequence, nl''  )
                            where (atfirst_cod_sequence, nl') = compprog x l
                                  (atother_cod_sequence, nl'') = compprog (Seq xs) nl'
compprog (Assign n e) l = (  compExpr e ++ [POP n]  ,  l  )
compprog (While e p) l = (  [LABEL l] ++ compExpr e ++ [JUMPZ (1+1)] ++ inside ++ [JUMP l, LABEL (l+1)], nl'  )
                                            where (inside, nl') = compprog p (l+2)
compprog (If e p1 p2) l = (  compExpr e ++ [JUMPZ l] ++ inside1 ++ [JUMP (l+1),  LABEL l] ++ inside2 ++ [LABEL (l+1)] , nl'')
                                            where (inside1, nl') = compprog p1 (l+2)
                                                  (inside2, nl'') = compprog p1 (nl')

mcompprog :: Prog -> ST Code
mcompprog (Seq []) = do n <- ( S ( \x -> (x, x) ) ) 
                        return ([])  -- = S(\x -> ([], x))
mcompprog (Assign n e) = S (  \s -> ( compExpr e ++ [POP n]  ,  s )  )
{-
mcompprog (While e p) =  mcompprog p >>= \code ->
                         (
                            S(\s' -> ([LABEL l] ++ compExpr e ++ [JUMPZ (1+1)] ++ code ++ [JUMP l, LABEL (l+1)], s'+2 )
                         )
-}
mcompprog (While e p) = do  code  <- mcompprog p
                            S ( \s' -> ([LABEL s'] ++ compExpr e ++ [JUMPZ (s'+1)] ++ code ++ [JUMP s', LABEL (s'+1)], s'+2 ) )
mcompprog (If e p1 p2) = do code1 <- mcompprog p1
                            code2 <- mcompprog p2
                            S ( \s' -> (compExpr e ++ [JUMPZ s'] ++ code1 ++ [JUMP (s'+1),  LABEL s'] ++ code2 ++ [LABEL (s'+1)], s'+2))
mcompprog (Seq (p:ps)) = do code_ahead <- mcompprog p
                            code_later <- mcompprog (Seq ps)    
                            S ( \s' -> (code_ahead ++ code_later, s') )
                            
                            
-----------------------------------------------------------------------------------------------------------------------------------------
getValue_and_changeState :: ST Label
getValue_and_changeState = S(\s -> (s,s+1))               
                             
comp :: Prog -> Code
comp p = fst( app ( mmcompprog p ) 0 )
mmcompprog :: Prog -> ST Code
mmcompprog (Seq []) = return []
mmcompprog (Assign n e) = return (compExpr e ++ [POP n])
mmcompprog (While e p) = do code <- mmcompprog p
                            l <- getValue_and_changeState
                            return ([LABEL l] ++ compExpr e ++ [JUMPZ (l+1)] ++ code ++ [JUMP l, LABEL (l+1)])
mmcompprog (If e p1 p2) = do code1 <- mmcompprog p1
                             code2 <- mmcompprog p2
                             l1 <- getValue_and_changeState
                             l2 <- getValue_and_changeState
                             return (compExpr e ++ [JUMPZ l1] ++ code1 ++ [JUMP (l1 + 1), LABEL l1] ++ code2 ++ [LABEL (l1+1)])
mmcompprog (Seq (p:ps)) = do code_ahead <- mmcompprog p
                             code_later <- mmcompprog (Seq ps)
                             return (code_ahead ++ code_later)
                            
                            
                            
                            
                            
                            
-----------------------------------------------------------------------------------------------------------------------------------------                            
                            
--mcompprog (Seq (p:ps)) = do  <- mcompprog p

getLabel :: ST Label
getLabel = S(\n -> (n,n+1))
                                                  
firsttest2 :: Prog
firsttest2 = Seq [Assign 'A' (App Mul (Var 'A') (Var 'B')), Assign 'B' (App Sub (Var 'B') (Val (1)))]


compExpr :: Expr -> Code
compExpr (Val v) = [PUSH v]
compExpr (Var n) = [PUSHV n]
compExpr (App o e1 e2) = compExpr e1 ++ compExpr e2 ++ [DO o]


------------------------------------------------------------------------------------------------------------
testExpr :: Expr
testExpr =  App Sub (Var 'B') (Val (1))

data Tree a = Leaf a | Node ( Tree a ) (Tree a)
                                    deriving Show
                                    
rlabel :: Tree a -> Int -> (Tree Int, Int)
rlabel (Leaf _) n = (Leaf n , n+1)
rlabel (Node l r) n = (Node l' r', n'')
                        where (l',n') = rlabel l n
                              (r',n'') = rlabel r n'
                              
tree :: Tree Int
tree = Node (Node (Leaf 30) (Leaf 40)) (Leaf 50)

{-
fresh :: ST Int
fresh = S (\n -> (n, n+1))


mlabel :: Tree a -> ST (Tree Int)
mlabel (Leaf _) = do n <- fresh
                     return (Leaf n)
mlabel (Node l r) = do l' <- mlabel l
                       r' <- mlabel r
                       return (Node l' r')
-}


exec :: Code -> Mem
exec is = exechelper is ([],[],[])



type Label_code = [(Int,Code)]
type Machinestate = (Label_code, Stack, Mem)

exechelper :: Code -> Machinestate -> Mem
-- exechelper [] (_,_,m) = m
exechelper [] (_,_,m) = m
exechelper (x:xs) (lc,s,m) = case x of
                                            PUSH n -> exechelper xs ( lc, n:s, m)
                                            PUSHV c -> exechelper xs ( lc, (getfromname m c) : s ,m)
                                            POP c -> exechelper xs ( lc, drop 1 s, assignwithvalue (c,s!!0) m )
                                            DO op ->  case op of
                                                        Add -> exechelper xs (lc, ((s!!1) + (s!!0)):(drop 2 s), m )
                                                        Sub -> exechelper xs (lc, ((s!!1) - (s!!0)) : (drop 2 s), m )
                                                        Mul -> exechelper xs (lc, ((s!!1) * (s!!0)) : (drop 2 s), m )
                                                        Div -> exechelper xs (lc, ((div (s!!1) (s!!0))) : (drop 2 s), m )
                                            LABEL l -> exechelper xs ((l,xs):lc, s , m) --xs is the remain code after the Label l
                                            JUMP l -> exechelper (get_remain_code lc l (x:xs)) (lc, s, m)
                                            JUMPZ l -> case s!!0 of
                                                            0 -> exechelper (get_remain_code lc l (x:xs)) (lc, drop 1 s, m)  -- jump
                                                            _ -> exechelper xs (lc,drop 1 s,m) -- just continue
                                                            
                                                        
-- 
getfromname:: Mem-> Name -> Int
getfromname ((c_inMem,v):xs) c  | c_inMem == c = v
                                | otherwise = getfromname xs c

assignwithvalue:: (Name, Int) -> Mem -> Mem
assignwithvalue (c,v) [] = [(c,v)]
assignwithvalue (c,v)((c',v'):ms) | c == c' = (c',v): ms
                                  | otherwise = (c',v'): (assignwithvalue (c,v) ms)
-- go throught the [(label , code0], if not found, go through the remain code                    
get_remain_code :: [(Int,Code)] -> Label -> Code -> Code
get_remain_code [] l [] = []
get_remain_code [] l ( i : is ) | (LABEL l) == i = is
                                | otherwise = get_remain_code [] l is
get_remain_code ((l',afterl'):lc) l is | l' == l = afterl'
                                       | otherwise = get_remain_code lc l is

                                       
                                       
tett = [PUSH 1, POP 'A', PUSH 10, POP 'B']
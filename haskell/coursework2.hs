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
            deriving Show

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
             deriving Show
 
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

comp :: Prog -> Code
comp p = fst( app ( mcompprog p ) 0 )
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
mcompprog (Seq []) = do n <- ( S ( \x -> (x, x) ) ) -- = S(\x -> ([], x))
                        return ([])
mcompprog (Assign n e) = S (  \x -> ( compExpr e ++ [POP n]  ,  x )  )
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
                            
                            
--mcompprog (Seq (p:ps)) = do  <- mcompprog p
                                                  
                                                  
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




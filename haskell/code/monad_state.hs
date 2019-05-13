
data Tree a = Leaf a | Node ( Tree a ) (Tree a)
                                    deriving Show
                                    
rlabel :: Tree a -> Int -> (Tree Int, Int)
rlabel (Leaf _) n = (Leaf n , n+1)
rlabel (Node l r) n = (Node l' r', n'')
                        where (l',n') = rlabel l n
                              (r',n'') = rlabel r n'
                              
tree :: Tree Int
tree = Node (Node (Leaf 30) (Leaf 40)) (Leaf 50)

class Functor f => Myapplicative f where
    mypure :: a -> f a
    mytransfer :: f(a->b) -> f a -> f b

instance Myapplicative Maybe where
    mypure g = Just g
    mytransfer Nothing _ = Nothing
    mytransfer (Just g) (Just x) = Just (g x)    
    
instance Functor Tree where
    --fmap :: (a->b) -> f a -> f b
    fmap g (Leaf x) = Leaf (g x)
    fmap g (Node lt rt) = Node (fmap g lt) (fmap g rt)
    
instance Myapplicative [] where
    --mypure :: a -> f a
    --mytransfer :: f(a->b) -> f a -> f b
    mypure x = [x]
    mytransfer (fx) (xs) = [f x| f <- fx, x <- xs ]  

{-
instance Myapplicate Tree where
    --mypure :: a -> f a
    --mytransfer :: f(a->b) -> f a -> f b
    mypure v = Leaf v
    mytransfer (Leaf g) (Leaf x) = Leaf (g x)
    mytransfer (Leaf g) (Node l r) = 
    mytransfer ()
-}


ins :: (Functor f, Num a) => f a -> a -> f a
ins m x = fmap (+x) m

ins2 :: (Myapplicative f, Num a) => f a -> a -> f a
ins2 m x = mytransfer (mypure (+x)) m

ins3 :: (Myapplicative f, Num a) => f a -> f a -> f a
ins3 m n = mytransfer ( mytransfer ( mypure (+) ) m ) n


------------------------------------------------------------Monad Maybe

eval:: Int -> Maybe Int
eval 0 = Nothing
eval x = Just x

noo :: Int -> Maybe Int
noo x = eval x >>= \v -> Just v

noo2 :: Int -> Int -> Maybe Int
noo2 x y = eval x >>= \v1 ->
           eval y >>= \v2 ->
           Just (v1+v2)
           
noo3 :: Int -> Int -> Maybe Int
noo3 x y =  eval x >>= \v1 ->
            ( 
                eval y >>=  \v2 ->
                (
                    Just (v1+v2) 
                )  
            )   
           
noo4 :: Int -> Int -> Maybe Int
noo4 x y = do v1 <- eval x     --eval x get "Just n1"; the later function's first argument is n1!!!
              v2 <- eval y  
              Just (v1+v2)
------------------------------------------------------------
{-
class Monad m where
    return :: a -> m a
    (>>=) :: m a -> (a -> m b) -> m b
instance Monad Maybe where
    return v = Just v
    Nothing (>>=) _ = Nothing
    (Just x) (>>=) g = g x 
    
instance Monad [] where
    return v = [v]
    xs (>>=) g = [ y | x<-xs, y<-g x]
-}
--------------------------------------------------------------------Monad []
pairs :: [a]->[b]-> [(a,b)]
pairs xs ys = do x <- xs
                 y <- ys
                 return (x,y)
                 
                 

pairs2 :: [a]->[b]-> [(a,b)]
pairs2 xs ys =  xs >>= \x  ->
                (
                    ys >>= \y ->
                    (
                        return (x,y)
                    )
                )
                
                
test :: [a] -> [a]
test xs = xs >>= \x ->
          return x
          
-------------------------------------Monad ST         
type State = Int

newtype ST a = S (State -> (a,State))
app:: ST a -> State -> (a, State)
--app:: (S (State -> (a,State)) -> State -> (a, State)
app (S g) s'= g s'

instance Functor ST where
    --fmap :: (a->b) -> ST a -> ST b
    fmap g st= S (\os -> let (x,s') = app st os in (g x,s'))
    
instance Applicative ST where
    --pure:: a -> ST a
    -- <*> :: ST (a->b) -> ST a -> ST b
    pure x = S(\s -> (x,s))
    staf <*> sta = S(\ox -> let (f,s') = app staf ox 
                                (x, s'') = app sta s' in (f x,s'')  )
    
instance Monad ST where--just give you do notation, nothing else

--(>>=):: ST a -> (a -> ST b) -> ST b
    sta >>= f = let(x,df) 
{-
instance Functor ST where
--fmap :: (a->b) -> ST a -> ST b
fmap g (S t) = S ()
                where fts -> 
-}

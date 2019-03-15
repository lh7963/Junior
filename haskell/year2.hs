import Data.Char
mydouble x =x+x
quaruple x = mydouble (mydouble x)

factorial n = product [1..n]

average ns = div (sum ns) (length ns)
--fadsf
{-
dfa
-}

fd xs = take (length xs -1) xs



addtuple :: (Int,Int)->Int
addtuple (x,y) = x+y

zeroto :: Int -> [Int]
zeroto n = [0..n]
--chapter3 exercise
--swap :: (a,b)->(b,a)
swap (x,y) = (y,x)

--double :: Num a => a -> a
double x = x * 2

--prlindrome :: Eq a => [a] -> Bool
palindrome xs = reverse xs == xs 

--twice :: (a->a) -> a -> a
twice f x = f (f x)

--chapter4 exercise
halve :: [a] -> ([a],[a])
halve xs = (take half xs,drop half xs)
            where half = length xs `div` 2

thirda :: [a]->a
thirda xs = head (tail (tail xs))

thirdc :: [a]->a
thirdc (_:_:x:_) = x

--safetail :: [a]-> [a]
safetaila xs = if xs == [] then [] else
                    tail xs

safetailb xs | xs == [] = []
             | True = tail xs

safetailc [] = []
safetailc xs = tail xs

--(|||) :: Bool->Bool->Bool
True ||| _ = True
_ ||| b = b

mult :: Int -> Int -> Int -> Int
mult = \x->(\y->(\z->x+y+z))

luhnDouble :: Int -> Int
luhnDouble x = if d>9 then d-9 else d
                where d = 2*x
                
luhn :: Int -> Int -> Int -> Int -> Bool
luhn x y m b = if value `mod` 10 == 0 then True else False
                where value = luhnDouble x + y +  luhnDouble m + b
                
conccat :: [[a]] -> [a]
--conccat :: [[1],[2]]->[1,2]
conccat xss = [ x | xs <- xss, x <- xs]

firsts :: [(a,b)] -> [a]
firsts xs = [ f | (f,_)<-xs]

lengthh ::[a]->Integer
lengthh xs = sum [ 1 | _ <- xs ] :: Integer

mything :: Integral a => [a]-> [a]
mything xs = [ y | x<-xs, x `mod` 2 == 0, y<-[1..x]]

factors :: Integral a => a->[a]
factors x =[ v | v <- [1..x], x `mod` v==0 ]

count ::Eq a => a -> [a] -> Int
count v xs = length [1 | x<-xs, v == x ]
--exercise chapter5
type Pairf = (Int,Int)
grid :: Int -> Int -> [Pairf]
grid x y = [ (m,n) | m<-[0..x],n<-[0..y]]

perfects :: Int -> [Int]
factorss :: Int -> [Int]
factorss x= [ v | v<-[1..x-1], x `mod` v == 0]

perfects x = [ v | v <-[1..x], sum(factorss v)==v]

scalarproduct :: [Int] -> [Int] -> Int
scalarproduct xs ys = sum [ xs !! i * ys!! i | (_,i)<-zip xs [0..]]

(+++) :: [a] -> [a] -> [a]
[] +++ xs = xs
(x:xs) +++ ys = x: (xs +++ ys)

type Map = [Pair]
type Pair = (Key, Value)
type Key = Int
type Value = String

--instance
map1 :: Map
map1 = [(1,"I"),(3,"don't"),(5,"give"),(7,"a"),(8,"fuck")]
--method
--insert
insert :: Pair -> Map -> Map
insert p [] = [p]
insert (k,v) ((ik,iv):map) = if k<ik then 
                                    (k,v):((ik,iv):map)
                             else if k==ik then
                                    (k,v):map
                             else
                                    (ik,iv) : (insert (k,v) map)
 
--remove
removes :: Int -> Map -> Map
removes _ [] = []
removes k ((ik,iv):map) = if k == ik then
                             map
                          else
                             (ik,iv):(removes k map)


fibs :: Integer -> [Integer]
fibs 0 = []
fibs 1 = [1]
fibs 2 = [1,1,2]
fibs n | sumoflasttwo>n = flast
       | True = flast ++ [sumoflasttwo]
                  where flast = fibs (n-1)
                        lenlast = length (fibs (n-1))
                        sumoflasttwo = flast !! (lenlast-1) + flast !! (lenlast -2) 

fibsgetfisrt :: Integer -> [Integer]
fibsgetfisrt 0 = []
fibsgetfisrt 1 = [1]
fibsgetfisrt 2 = [1,1]
fibsgetfisrt n = flast ++ [sumoflasttwo]
                    where 
                        flast = fibsgetfisrt (n-1)
                        lenlast = length (flast)
                        sumoflasttwo = flast !! (lenlast-1) + flast !! (lenlast -2)

fib :: Integer -> Integer
fib 1 = 1
fib 2 = 1
fib n = fib(n-1)+ fib(n-2)
fibsgetfisrt2 n = [ fib v | v<-[1..n]]


mylast :: [a] -> a
mylast (x:[]) = x
mylast (x:xs) = mylast xs
--exercise chapter6
sumdown :: Int -> Int
sumdown 0 = 0
sumdown n = n + sumdown (n-1)

(^^&) :: Int -> Int -> Int
_ ^^& 0 = 1
x ^^& n = x * x^(n-1)

euclid :: Int -> Int -> Int
euclid n m  | n == m = n 
            | n < m = euclid n (m-n)
            | True = euclid (n-m) m 
{-
mylength [] = 0
mylength x:xs = 1+ mylength xs

drop 0 xs = xs
drop _ [] = []
drop n (x:xs) = drop (n-1) xs
-}
--myconcat :: [[a]]-> [a]
myconcat [] = []
myconcat (x:xs) = x ++ (myconcat xs) 

myreplicate :: Int -> a -> [a]
myreplicate 0 _ = []
myreplicate x v = v: (myreplicate (x-1) v)

fmerge :: Ord a => [a] -> [a] -> [a]
fmerge xs [] = xs
fmerge [] ys = ys
fmerge (x:xs) (y:ys) | x<=y = x : (fmerge xs (y:ys))
                    | x>y = y : (fmerge (x:xs) ys )

msort ::Ord a => [a] -> [a]
msort [] = []
msort (x:[]) = [x]
msort xs = fmerge (msort firsthalf) (msort secondhalf)
            where (firsthalf,secondhalf) = halve xs --variable

mmap :: (a->b) -> [a] -> [b]
mmap f [] = []
mmap f (x:xs) = f x : mmap f xs

--flodr (function) (output when deal with empty)
myreverse (xs)= foldr (\x1 vs->vs++[x1]) [] xs

mylengths :: [a]-> Int
mylengths = foldr (\_ x -> 1+x ) 0

myreverses :: [a] -> [a]
myreverses = foldr (\l xs -> xs ++ [l]) []

ffoldl :: (a->b->a)->a->[b]->a
ffoldl f v [] = v 
ffoldl f v (x:xs) = ffoldl f (f v x) xs

transpose :: [[a]]->[[a]]
transpose xss= [ [ xss!!i!!j | i<-[0..m-1] ] | j<-[0..n-1] ]
                where m = length xss
                      n = length (xss!!0)
                      


                      
--chaper 10

mygetLine :: IO String
mygetLine = do x <- getChar
               if x=='\n' then
                   return []
               else
                   do y <- mygetLine
                      return (x:y)
                      
myputStr :: String -> IO()
myputStr [] = return ()
myputStr (x:xs) = do putChar x
                     myputStr xs
                     
myputStrLn :: String -> IO()
myputStrLn [] = do putChar '\n'
                   return () 
myputStrLn (x:xs) = do putChar x
                       myputStrLn xs
                       
strlen :: IO()
strlen = do myputStrLn "Enter the String:"
            xs <- mygetLine
            myputStr "Your String is "
            myputStr (show (length xs))
            myputStrLn " charactors"
            
--exercise chapter 10
putStrversion2 :: String -> IO()
putStrversion2 cs = sequence_ [ return c | c <- cs]

--haha :: IO()
haha = do cs <- mygetLine
          putStrversion2 cs
          
addr :: IO()
addr = do putStr "How many number?"
          x <- mygetValue_until_n
          sum <- addtotal x 0  
          putStrLn ("The total is " ++ show sum)
          return ()
          
addtotal :: Int -> Int -> IO Int
addtotal 0 cur = return cur
addtotal tot cur = do vs <- getLine
                      let v = read vs :: Int
                      l <- addtotal (tot-1) (cur+v)
                      return l
                      
mygetValue_until_n :: IO Int
mygetValue_until_n = do c <- getChar
                        getLine
                        return (ord c - ord '0')
                      
mygetChar_until_n :: IO Char
mygetChar_until_n = do c <- getChar
                       getLine
                       return c

--chapter 8 declaring types and classes
data List a = Nil | Cons a (List a)
len :: List a -> Int
len Nil = 0
len (Cons _ l) = 1 + len l

data Tree a = Leaf a | Node (Tree a) a (Tree a)
occurs :: Eq a => a -> Tree a -> Bool
occurs x (Leaf v) = x == v
occurs x (Node l v r) = x == v || occurs x l || occurs x r

inorder :: Tree a -> [a]
inorder (Leaf a) = [a]
inorder (Node l v r) = inorder l ++ [v] ++ inorder r
data Treee a = Leaff a | Nodee (Treee a) (Treee a)

instance Functor Treee where
    --fmap :: (a->b)->f a->f b
    fmap g (Leaff v) = Leaff (g v)
    fmap g (Nodee l r) = Nodee (fmap g l) (fmap g r)
    
    
mytestt :: Char  -> IO [Char] -> IO [Char]
mytestt a m = do
              {
                  xs<-m;
                  return (a:xs); 
              }
              
              
              

class MyFunctor f where
    myfmap :: (a->b)->f a->f b
    
instance MyFunctor [] where
    --myfmap :: (a->b)->f a->f b
    myfmap g m = map g m
    
data MyMaybe a = MyNothing | MyJust a
instance MyFunctor MyMaybe where
    --myfmap :: (a->b)->f a->f b
    myfmap _ MyNothing  = MyNothing
    myfmap g (MyJust m) = MyJust (g m)

a::Int
a=3

safediv :: Int -> Int -> Maybe Int
safediv _ 0 = Nothing
safediv m n = Just (m `div` n)

data Expr = Val Int | Div Expr Expr
eval :: Expr -> Maybe Int
eval (Val n) = Just n
eval (Div x y) = do  m <- eval x
                     n <- eval y
                     safediv m n
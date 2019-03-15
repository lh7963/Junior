import Data.Char
import Data.List
import System.IO
--G52AFP Coursework 1 - Connect Four Game
--Han Lin
--psyhl4@nottingham.ac.uk
import Data.List
rows :: Int
rows = 6
cols :: Int
cols = 7
win :: Int
win = 4
depth :: Int
depth = 6

type Board = [Row]
type Row = [Player]
type Col = [Player]   ------self-defined
type Dia = [Row]        ---------self-define

data Player = O | B | X
                    deriving (Ord, Eq, Show)
                    
emptyBoard :: Board
emptyBoard = replicate rows (replicate cols B)                 
                    
test :: Board
test = [[B,B,B,B,B,B,B],
        [B,B,B,B,B,B,B],
        [B,B,X,B,B,B,B],
        [B,B,B,X,X,B,B],
        [B,B,O,O,X,O,B],
        [B,O,O,X,X,O,O]]

tests = [[B,B,B,B,B,B,B],
        [B,B,B,B,B,B,B],
        [B,B,B,B,B,B,B],
        [B,B,B,B,B,B,B],
        [B,B,B,B,B,B,B],
        [B,O,B,B,B,B,B]]
        
anotest = [[X,B,B,B,B,B,B],
        [O,B,B,B,B,B,B],
        [X,B,B,B,B,B,B],
        [O,B,B,B,B,B,B],
        [X,B,B,B,B,B,B],
        [O,B,B,B,B,B,B]]
        
test1= [[B,B,B,B,B,B,B],
        [B,X,B,B,B,B,B],
        [O,O,O,O,B,B,B],
        [B,B,B,X,X,B,B],
        [B,B,O,O,X,O,B],
        [B,O,O,X,X,O,O]]

test2= [[B,X,O,B,B,B,B], 
        [B,O,O,X,O,B,B],
        [B,O,X,O,X,B,B],
        [B,X,X,O,X,B,B],
        [B,X,X,O,X,B,B],
        [B,X,O,X,O,X,B]]  

test3= [[B,B,X,B,B,B,B],
        [B,O,X,B,B,B,B],
        [B,X,O,O,X,B,B],
        [B,O,X,X,X,B,B],
        [X,X,O,O,O,O,B],
        [O,O,X,X,X,O,O]]
        
test4= [[X,B,X,O,O,B,B],
        [O,O,X,X,X,B,B],
        [X,X,O,O,X,B,B],
        [O,O,X,X,X,B,B],
        [X,X,O,O,O,O,B],
        [O,O,X,X,X,O,O]]
        
test6 = [[B,B,B,B,B],
         [B,B,B,B,B],  
         [B,B,B,B,B],
         [B,B,O,X,B],
         [B,O,X,O,X]]
        
        
showBoard :: Board -> IO ()
showBoard b =
    putStrLn (unlines (map showRow b ++ [line] ++ [nums]))
    where
        showRow = map showPlayer
        line = replicate cols '-'
        nums = take cols ['0'..]
        
showPlayer :: Player -> Char
showPlayer O = 'O'
showPlayer B = '.'
showPlayer X = 'X'

--haha = unlines ["fasdf","adsf"]

turn :: Board -> Player
turn b | even numberOfO = O
       | otherwise = X 
        where numberOfO = sum ( map countO  b )
       
countO :: Row -> Int
countO [] = 0
countO (x:xs) | x == O || x == X = 1 + countO xs
              | otherwise = countO xs
       
hasRow :: Player -> Row -> Bool
hasRow p (x:xs) | length (x:xs)< win = False 
                | otherwise = all (\x-> x==p ) (take win (x:xs)) || hasRow p xs        

issame :: Player -> [Player] -> Bool
issame m xs = all (\x-> x==m ) xs 

hasCol :: Player -> Col -> Bool
hasCol = hasRow

hasDia :: Player -> Dia -> Bool
hasDia p b = issame p [   b!!v!!v |  v<- [0..(win-1)]] || issame p [   b!!v!!(win-1-v) |  v <- [0..(win-1)]]
            
boardToDias :: Board -> [Dia]
boardToRows :: Board -> [Row]
boardToCols :: Board -> [Col]
boardToRows = id
boardToCols = transpose

boardToDias b = [ [ take win (drop c (b!!rv)) | rv <-[r..(r+win)] ]  |  r <- [0..(rows-win)], c <- [0..(cols-win)] ]

hasWon :: Player -> Board -> Bool
hasWon p b = or (map (hasRow p) (boardToRows b)) ||
             or (map (hasCol p) (boardToCols b)) ||
             or (map (hasDia p) (boardToDias b))
             
--hasn't handle 1. colIndex<0 or colIndex>6 : when getting the user input value, make sure 0 < colIndex < 6
--              2. bigger than col : when getting the user input value, check board!!0!!colIndex == B
move :: Board -> Int -> Player -> Board
move b colIndex p = take rowIndex b ++ [(take colIndex target_row) ++ [p] ++ drop (colIndex+1) target_row] ++ drop (rowIndex+1) b
             where target_col_reversed = reverse  (transpose b !! colIndex) --reversed version of target column, only used for finding the "rowIndex"
                   rowIndex = movehelper_findRow target_col_reversed (rows - 1) -- get the "rowIndex" of the target row in Board
                   target_row = b !! rowIndex
                   
                     
--this function finds which row (index) should I put the new X or new O, the first input is a reversed column, the second input is the max index of the board
movehelper_findRow :: [Player] -> Int -> Int
movehelper_findRow [] _ = -1
movehelper_findRow (x:xs) n | x == B = n
                            | otherwise = movehelper_findRow xs (n-1)

data Tree a = Node a [Tree a]
                             deriving (Show,Ord,Eq)
{-
maketree :: Board -> Tree (Player, Board)--implement minimax inside
maketree b | hasWon X b = Node (X,b) [] -- leaf is treated as empty list
           | hasWon O b = Node (O,b) []
           | elem B (b!!0)== False = Node (B,b) [] --if board is full
           | turn b == X = Node (px,b) childs
           | otherwise = Node (po,b) childs
                    where Node (px,_) _ = maximum childs
                          Node (po,_) _ = minimum childs
                          childs = [  maketree (move b c (turn b)) | c <- [0..cols-1], (b!!0!!c) == B ]
-}

moves :: Board -> [Board]

moves b | elem B (b!!0)== False = [b]
        | otherwise = [ move b c (turn b) | c <- [0..cols-1], b!!0!!c == B ]

growTree :: Board -> Tree Board
--growTree Node
growTree b | elem B (b!!0) == False = Node b []
           | otherwise = Node b ( map growTree (moves b) )

prune :: Int -> Tree Board -> Tree (Player, Board)
prune d (Node b cs)
           | hasWon X b = Node (X,b) [] -- leaf is treated as empty list
           | hasWon O b = Node (O,b) []
           | elem B (b!!0)== False = Node (B,b) [] --if board is full
           | d == 0 = Node (B,b) []
           | turn b == X = Node (px,b) childs
           | otherwise = Node (po,b) childs
                    where Node (px,_) _ = maximum childs
                          Node (po,_) _ = minimum childs
                          childs = map (prune (d-1)) cs
                          
reasonableMove_version2 :: Board -> Board
reasonableMove_version2 b
                    | turn b == X =  nbx
                    | otherwise = nbo
                        where Node (_,nbx) _ = maximum list
                              Node (_,nbo) _ = minimum list
                              Node (_,_) list = prune depth (growTree b)             
{-             
maketreeDepth6 :: Board -> Int -> Tree (Player, Board)
maketreeDepth6 b d
           | hasWon X b = Node (X,b) [] -- leaf is treated as empty list
           | hasWon O b = Node (O,b) []
           | elem B (b!!0)== False = Node (B,b) [] --if board is full
           | d == 0 = Node (B,b) []
           | turn b == X = Node (px,b) childs
           | otherwise = Node (po,b) childs
                    where Node (px,_) _ = maximum childs
                          Node (po,_) _ = minimum childs
                          childs = [  maketreeDepth6 (move b c (turn b)) (d-1) | c <- [0..cols-1], (b!!0!!c) == B ]
                         
                          

takeResonableMove :: Board -> Board
takeResonableMove b | turn b == X =  nbx
                    | otherwise = nbo
                        where Node (_,nbx) _ = maximum list
                              Node (_,nbo) _ = minimum list
                              Node (_,_) list = maketreeDepth6 b depth
-} 

play :: Board -> IO()
play b = do   putStr "Player O enter your move: "
              v <- handleInput b
              let pb = move b v O
              showBoard pb
              if hasWon O pb then
                do putStr "You are amazing,bro!"
                   return ()
              else if isfull pb then
                do putStrLn "draw! :) haha,you can't beat me."
                   return ()
              else     
                  do  putStrLn "Player X is thinking..."
                      let nb = reasonableMove_version2 pb
                      showBoard nb
                      if hasWon X nb then
                        do putStrLn "You lose :("
                           return ()
                      else if isfull nb then
                        do putStrLn "draw"
                           return ()
                      else
                        do play nb
              
isfull :: Board -> Bool
isfull b = elem B (b!!0)== False            
                    
handleInput :: Board -> IO Int
handleInput b = do    xs <- getLine
                      if xs == "" || length xs > 1 then
                        do putStrLn "Please enter one and only one digit between 0 and 6(included):"
                           handleInput b
                      else 
                        do let x = ord (xs!!0) - ord '0' 
                           if  x<0 || x >6  then
                               do putStrLn "Your input is invalid, try again:"
                                  handleInput b
                           else 
                               if (b!!0!!x) /= B then
                                 do putStrLn "It is full in this cols, try again"
                                    handleInput b
                               else
                                 return x

--main1 = showBoard (takeResonableMove test2)
main:: IO()
main = do showBoard b
          play b
           where b = emptyBoard
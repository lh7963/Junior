import Data.Char
import Data.List
import System.IO
--G52AFP Coursework 1 - Connect Four Game
--Han Lin
--psyhl4@nottingham.ac.uk

--question I need to ask:
{-
why my compile version and non-conpile version act act differently 
how to transfer the .hs to .lhs format
I think the invalid move is easliy be handle, do I have to use maybe or valid_move funtion? It well well even I don't have it
do I have to write a function called minimax, cuz it can be presented by purn
-}


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
type Col = [Player]   ---------self-defined, represent the column of board in a list
type Dia = [Player]   ---------self-defined, represent the diagonal of board in a list

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


--turn 
--MEANING :judge who's turn right now in the specified board 
--principle:in premise, player 'O' go first. so just count the number of O and X in the board, if it's even, O's turn, otherwise X's turn
--argument: just board
turn :: Board -> Player
turn b | even numberOf_OX = O
        | otherwise = X 
             where numberOf_OX = ( length . concat . map ( filter (\u -> u /= B) ) ) b
              
              
--hasRow function MEANING: examine whether there are continuous "win" number (which is "4" in this game) of sepecified players in a row
--hasRow function PRINCIPLE: to take the first 4 player and check whether all equal to the specified player, if yes,just True, otherwise ignore the first player and take 4 players repeatly until number of player less than 4
--hasRow function semantically takes two argument: 1.the player to be compared 2. the row to be examined              
hasRow :: Player -> Row -> Bool
hasRow p (x:xs) | length (x:xs)< win = False 
                | otherwise = all (\x-> x==p ) (take win (x:xs)) || hasRow p xs        

--hasCol function examine whether there are continuous "win" number (which is "4" in this game) of sepecified players in a column
--hasRow function PRINCIPLE:same with hasRow
--hasCol function semantically takes two argument: 1.the player to be compared 2. the column to be examined 
hasCol :: Player -> Col -> Bool
hasCol = hasRow

--hasDia function examine whether there are continuous "win" number (which is "4" in this game) of sepecified players in a diagonal
--hasDia function PRINCIPLE:same with hasRow
--hasCol function semantically takes two argument: 1.the player to be compared 2. the column to be examined 
hasDia :: Player -> Dia -> Bool
hasDia = hasRow

--boardToRows function MEANING     : like its name, transfer the board to a list of row. ie. a list of list of players
--boardToRows function PRINCIPLE    : the board itself can be used to represented a list of row
--boardToRows ARGUMENTS            : semantically just board
boardToRows :: Board -> [Row]
boardToRows = id

--boardToCols function MEANING     : like its name, transfer the board to a list of column. ie. a list of list of players
--boardToCols function PRINCIPLE    : the board itself can be used to represented a list of column
--boardToCols ARGUMENTS            : semantically just board
boardToCols :: Board -> [Col]
boardToCols = transpose

--boardToDias function MEANING              : like its name, transfer the board to a list of diagonal. ie. a list of list of players
--boardToDias function PRINCIPLE            : the board itself can be used to represented a list of diagnoal
--boardToDias ARGUMENTS                     : semantically just board
boardToDias :: Board -> [Dia]
boardToDias b = dia_UpperReft_to_LowerRight b ++ dia_LowerLeft_to_UpperRight b

--dia_UpperReft_to_LowerRight
--MEANING   : intend to act as a helper-function for boardToDias; extract the all the dia_UpperReft_to_LowerRight diagonals with more than 4 players
--PRINCIPLE : get the indexs of the first player in the diagonal lines and for each index pair, increase the row_index and col_index at the same time to get the whole line
--ARGUMENTS : just board
dia_UpperReft_to_LowerRight :: Board -> [Dia]
dia_UpperReft_to_LowerRight b = [  [  b!!rv!!cv | (rv,cv) <- zip [r..rows-1] [c..cols-1]]   | r <- [0..rows-win], c <- [0..cols-win], r == 0 || c==0 ]

--dia_LowerLeft_to_UpperRight
--MEANING   : intend to act as a helper-function for boardToDias; extract the all the dia_LowerLeft_to_UpperRight diagonals with more than 4 players
--PRINCIPLE : equal to "reverse the rows of board and get the diagonal from the UpperLeft to LowerRight"
--ARGUMENTS : just board
dia_LowerLeft_to_UpperRight :: Board -> [Dia]
dia_LowerLeft_to_UpperRight b = dia_UpperReft_to_LowerRight ( (reverse.boardToRows) b)

--hasWon
--MEANING   : check whether the specified player has won in the board
--PRINCIPLE : for the map, detect if there are continus 4 in each row, column and diagonal
--ARGUMENT  : the specified player and the board
hasWon :: Player -> Board -> Bool
hasWon p b = or (map (hasRow p) (boardToRows b)) ||
             or (map (hasCol p) (boardToCols b)) ||
             or (map (hasDia p) (boardToDias b))
            
--move 
--goal: for the specified board and player, take one move and output the outcome of the board
--explanation: 
                --the move function will be use for "moves" function(specified below) and "IO" part(specified below), I deleted the "valid_move" function cause the invalid move can easily be prevanted in above two situation.
               --so I write the "move" function, I just assuse the next move column is valid, and it works well
               --the main idea is to devide the original board into three part:  part1:columns before part2  
                                                                               --part2:the column need to be changed 
                                                                               --part3:columns after part2
                --and modify the part2 contact them together 
                --for part1 and part3 just use transpose the board and use "take" and "drop" function
                --for part2 just need to find the taget's row index and modify it. 
                        --the way to find the target row index, for the target column, is to count the number of "Blank" in the target colum and then minus 1  
--arguments  : current board, the target colum index, the turn for the board
--output : modified board
move :: Board -> Int -> Player -> Board 
move b c p = transpose ( take c tb ++ [ take rowIndex target_row ++ [p] ++ drop ( rowIndex + 1 ) target_row ] ++ drop (c+1) tb )
                    where tb = transpose b
                          target_row = tb!!c
                          rowIndex = length ( filter ( == B ) target_row ) - 1
                          
 
--defined the Tree data struction, the "leaves" are the Nodes with the empty list                            
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
--moves 
--goal : for the specified board, create the list of board that it could possiblly generate after taking one further move
--explanation: the board if full, just output the list with only one full board in it, otherwise just take valid leagel move and put them in the list
--argument : just board
--output : the list of board ( notice that the output will never be the empty list )
moves :: Board -> [Board]
moves b | elem B (b!!0)== False = [b]
        | otherwise = [ move b c (turn b) | c <- [0..cols-1], b!!0!!c == B ]

--growTree
--goal        :  grow the specified board and fit them in the Tree data structure
--explanation : "grow" the specifed board by taking every potentially possible moved board as the root of substree, ie. by using moves, and continuously using "moves" it for the substree roots
            --until there is no possible move, ie, the board is full, take the full board as Leaf (with empty substree)
--argument    : just board
--output: the whole possible board tree generated from the specified tree
growTree :: Board -> Tree Board
growTree b | elem B (b!!0) == False = Node b []
           | otherwise = Node b ( map growTree (moves b) )

--prune    
--goal : the outcame of the growTree is too big, we want to be prune it down to depth 6
--explanation: the node is Board for the given board, the reason I use the maximum(minimum) is that to

prune :: Int -> Tree Board -> Tree Board
prune d (Node b cs) | d == 0 = Node b []
                    | otherwise = Node b ( map (prune (d-1)) cs )
           
                          
minimax :: Tree Board -> Tree (Player, Board)
minimax (Node b cs)
           | hasWon X b = Node (X,b) [] -- leaf is treated as empty list
           | hasWon O b = Node (O,b) []
           | cs == [] = Node (B,b) []
           | elem B (b!!0)== False = Node (B,b) [] --if board is full
           | turn b == X = Node (px,b) childs
           | otherwise = Node (po,b) childs
                    where Node (px,_) _ = maximum childs
                          Node (po,_) _ = minimum childs
                          childs = map minimax cs
                          
                          
                          
reasonableMove_version2 :: Board -> Board
reasonableMove_version2 b
                    | turn b == X =  nbx
                    | otherwise = nbo
                        where Node (_,nbx) _ = maximum list
                              Node (_,nbo) _ = minimum list
                              Node (_,_) list = minimax ( prune depth ( growTree b ) )

                              
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
main = do hSetBuffering stdout NoBuffering
          showBoard b
          play b
           where b = emptyBoard
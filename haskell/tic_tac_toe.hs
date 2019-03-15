import Data.Char
import Data.List
import System.IO
--basic declarations
size :: Int
size = 3
type Grid = [[Player]]
data Player = O | B | X
                deriving (Eq, Ord, Show)
--Displaying a grid
putGrid :: Grid -> IO()
putGrid = putStrLn . unlines . concat . interleave bar . map showRow
            where bar = [replicate ((size*4)-1) '-']
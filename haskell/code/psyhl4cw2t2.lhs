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
explanation : using state monad, it need a heler function called mcompprog to deal side effect which is changing the state when it need while transfering the code;
              call app the outcome of "mcompprog p" (ST Code) to the initial state(0) and take the first element(compiled Code, list of Inst) of the tuple
arguments   : just the program code
outcome     : the machine code
                             
> comp :: Prog -> Code
> comp p = fst( app ( mcompprog p ) 0 )

mcompprog
goal        : implementing state monad to deal with the side effect, make the compiling process more tu
explanation : mcompprog use pattern matching and monad state, It simple need to deal with all the cases of Prog type
              for Seq[] and Assign, the state will not change, just return the compiled version of the program
              for If and While i.  the state need to be change base on While/If statement, use the "getLabel_and_changeState" to get new label and change state
                               ii. the state may need to be change by inner program, use the mcopprog recursively to change state(s) and get Code
              for Seq (x:xs) the state may need to be change by inner program, use the mcopprog recursively to change state(s) and get Code
argument    : program
outcome     : state transfer with type ST Code

> mcompprog :: Prog -> ST Code
> mcompprog (Seq []) = return []
> mcompprog (Assign n e) = return (compExpr e ++ [POP n])
> mcompprog (While e p) = do l1 <- getLabel_and_changeState
>                            l2 <- getLabel_and_changeState
>                            code <- mcompprog p                            
>                            return ([LABEL l1] ++ compExpr e ++ [JUMPZ (l2)] ++ code ++ [JUMP l1, LABEL (l2)])
> mcompprog (If e p1 p2) = do l1 <- getLabel_and_changeState
>                             l2 <- getLabel_and_changeState
>                             code1 <- mcompprog p1
>                             code2 <- mcompprog p2                            
>                             return (compExpr e ++ [JUMPZ l1] ++ code1 ++ [JUMP (l2), LABEL l1] ++ code2 ++ [LABEL (l2)])
> mcompprog (Seq (p:ps)) = do code_ahead <- mcompprog p
>                             code_later <- mcompprog (Seq ps)
>                             return (code_ahead ++ code_later)
                            
getLabel_and_changeState
goal        : refresh the state, it can be use to attain the current state(Label) by using "l<-getLabel_and_changeState"
explanation : the state transfer take a state, return the current label and a  new state
             and because the state stands for label and we want the current label, we just output the inputed state
             because we increase the label one at a time, the ouput state should just "s+1"
argument    : none
outcome     : the state transfer with type ST Label

> getLabel_and_changeState :: ST Label
> getLabel_and_changeState = S(\s -> (s,s+1))               

compExpr
goal        : tranfer the Expression to the compiled code
explanation : tranfering the expression will not result in state change
argument    : expression
outcome     : compiled code in a list

> compExpr :: Expr -> Code
> compExpr (Val v) = [PUSH v]
> compExpr (Var n) = [PUSHV n]
> compExpr (App o e1 e2) = compExpr e1 ++ compExpr e2 ++ [DO o]

-----------------------------------------------------------------------------------------------------------
exec
goal        : executes code produced by compiler and gets the final contents of the memory
explanation : call the helperfunction "exechelper" to generate contents of the memory
argument    : the compiled code
outcome     : the contents of the memory after executing the compiled code

> exec :: Code -> Mem
> exec is = exechelper is (is,[],[])

Machinestate
explanation : self-defined a type called Machestate, it is a triple including tree elements 
                        first element: the entire compiled code (want to maintain it in the machinestate instead of a paramater to make the code more intuitive)
                        second element: simulated stack(push and pop from the head)
                        third element : simulated memory
                        
> type Machinestate = (Code, Stack, Mem)

exechelper
goal        : act as a helper function for exec to generate the contents of memory by using Machinestate
explanation : do it recursively. 
                base case: because we only want the contents of the memory, we only need the third element of the machinestate when we finish all instruction
                recursive step: behave differently with different instruction, but for whatever instruction, just refresh the Machinestate
                                    for PUSH  : simply push the value the stack at head
                                    for PUSHV : call helper function "getValuebyName" to get the value of variable, push it to the stack
                                    for POP   : associate the first value in stack with the name, call helper function "putVariable_toMemory" the add/refresh element to memory; pop the stack, use tail to get rid of first element of stack
                                    for Do    : only modify the stack, call doop to compbine the first two element of the stack in a way specified by op
                                    for LABEL : just fetch the next instruction, the Machiestate stays the same
                                    for JUMP  : modify the remaining code by calling heler function "getCodebyLabel", the Machiestate stays the same
                                    for JUMPZ : consider to jump base on the first element of the stack.
                                                    if it is 0, then act as JUMP but get rid of the first element of statck
                                                    else (not 0) just fetch the next instruction
                                                    
> exechelper :: Code -> Machinestate -> Mem
> exechelper [] (_,_,m) = m
> exechelper (x:xs) (ac,s,m) = case x of
>                                 PUSH v -> exechelper xs ( ac, v:s, m)
>                                 PUSHV c -> exechelper xs ( ac, (getValuebyName m c) : s ,m)
>                                 POP c -> exechelper xs ( ac, tail s, putVariable_toMemory (c,head s) m )
>                                 DO op -> exechelper xs (ac , doop op s, m)
>                                 LABEL l -> exechelper xs (ac, s , m)
>                                 JUMP l -> exechelper (getCodebyLabel l ac) (ac, s, m) -- jump 
>                                 JUMPZ l -> case (head s) of
>                                                 0 -> exechelper (getCodebyLabel l ac) (ac, tail s, m)  -- jump
>                                                 _ -> exechelper xs (ac, tail s, m)

getCodebyLabel
goal        :get the instructions blow the given label(included)
explanation : call dropWhile to match each elements in the Code list
              the condition is not equal to LABEL l, so the output will be a list of the LABEL l itself and all the element behind the LABEL l 
              we can gurantee the instructions list must contains LABEL l if the compiler is correct and without infinite loop in the code
arguments   : the label value and the Code(list of instruction)
outcome     : a list of instruction

> getCodebyLabel :: Int -> Code -> Code
> getCodebyLabel l ac = dropWhile (/= LABEL l) ac 
 
doop
goal        : simulate "Do" operation to combine the first two elements in the stack into one value
explanation ：doop mainly serves for "Do" instruction,
              instead of using "> doop :: Integral a => Op -> [a] -> a", use "doop :: Op -> [Int] -> Int" because we only have Int type for value of variable
              we use pattern matching: when applying interpreted function, we put the second element of stack at first place, and second element of stack at second place. It makes a different when we encounter Sub or Div
              after getting the value, we also need to put push it back to stack
arguments   : the operation and the original stack
outcome     : resulting stack

> doop :: Op -> [Int] -> [Int]
> doop o (x:y:s) = (interp o) y x : s

interp
goal        : interprete the Op type to the actual curry function
explanation : instead of using "interp :: Integral a => Op -> a -> a -> a", use "Op -> Int -> Int -> Int" because the we only have Int type for value of variable
argument    : Operation(Op type)
outcome     : a function which takes the two Int value and return an Int value
 
> interp :: Op -> Int -> Int -> Int
> interp Add = (+)
> interp Sub = (-)
> interp Mul = (*)
> interp Div = (div)
 
getValuebyName
goal        : get the value of the variable by its name
expanation  : this function is mainly used for PUSHV instruction
              loop through the memory to match the name of variable
              the reason I do not include the base case is that we can gurantee the (name,value) tuple in memory contain the specified name if the compiler is correct and without infinited loop in the code
arguments   : the memory and the name of variable we are searching for
outcome     : the value of variable(it should always found)

> getValuebyName:: Mem-> Name -> Int
> getValuebyName ((n,v):xs) c  | n == c = v
>                              | otherwise = getValuebyName xs c

putVariable_toMemory
goal        : put the variable into the memory, if it is there, refresh the value
explanation : this function is mainly used for POP instruction
              do it recursively. base case: if the memory is empty, it means either the variable name is not found, put it into memory
                                 recursive step: if it is a match of variable's name, refresh the value of variable, concate the remaining elements and return
                                                 else keep the unrelative elment and recursively apply the function to the tail list
arguments   : variable (name, value) pair and memory
outcome     : resulting memory 
                                                                        
> putVariable_toMemory :: (Name, Int) -> Mem -> Mem
> putVariable_toMemory (c,v) [] = [(c,v)]
> putVariable_toMemory (c,v)((c',v'):m) | c == c' = (c',v): m
>                                       | otherwise = (c',v'): (putVariable_toMemory (c,v) m)
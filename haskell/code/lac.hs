parseA :: [Token] -> Maybe [Token]
parseA ('a' : ts) = parseA ts
parseA ts = Just ts

parseB :: [Token] -> Maybe [Token]
parseB ('b' : ts) = parseB ts
parseB ts = Just ts

type Token = Char

{-
S → aA | bBA
A → aA | ǫ
B → bB | ǫ
-}

parseS :: [Token] -> Maybe [Token]
parseS ('a': ts) = parseA ts
parseS ('b': ts) = 
        case parseB ts of
            Nothing -> Nothing
            Just ts' -> parseA ts'
parseS _ = Nothing

{-
S → aA | aBA
A → aA | ǫ
B → bB | ǫ
-}

parseS2 ::  [Token] -> Maybe [Token]
parseS2 ('a':ts) = 
    case parseA ts of
        Just ts' -> Just ts'
        Nothing -> case parseB ts of
                       Just ts'' ->  parseA ts''
                       Nothing -> Nothing

parseA' :: [Token] -> Maybe [Token]
parseA' ts =
    case parseA ts of
        Just ('a' : ts') -> Just ts'
        _ -> Just ts
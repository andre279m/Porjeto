maximum' :: Ord float => [float] -> float
maximum' (x:xs) = maximum'' xs x -- tendo em conta que não é uma lista não vazia

maximum'' :: Ord float => [float] -> float -> float
maximum'' [] y = y
maximum'' (x:xs) y
    | x > y = maximum'' xs x
    | otherwise = maximum'' xs y
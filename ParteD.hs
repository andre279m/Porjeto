maximum' :: Ord float => [float] -> float
maximum' (x:xs) = maximum'' xs x -- m1 -> tendo em conta que não é uma lista não vazia

maximum'' :: Ord float => [float] -> float -> float
maximum'' [] y = y -- m2 
maximum'' (x:xs) y = maximum'' xs (max' x y)-- m3

max' :: Ord float => float -> float -> float
max' x y
    |x > y = x
    |otherwise = y

reverse' :: [a] -> [a]
reverse' [] = [] --r1
reverse' (x:xs) = reverse' xs ++ [x] --r2

-- maximum' (x:xs)
-- maximum' [x] ++ xs
-- maximum [x] `max` maximum xs
-- x `max` maximum xs

-- maximum ' (reverse' (x:xs))
-- maximum' (reverse' xs ++ [x])
-- maximum' reverse' xs `max` maximum [x]
-- maximum' reverse' xs `max` x
-- x `max` maximum' xs 
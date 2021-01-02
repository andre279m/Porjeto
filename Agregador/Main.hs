import System.IO

main :: IO ()
main = do
    hSetBuffering stdin NoBuffering
    hSetBuffering stdout NoBuffering
    args <- getArgs
    if args == ["-t"]
        then
        putStr "TODO"
        --tests
        else do
            metric <- getLine 
            if not(null(words metric)) && even(length(words metric)) && (verifyMetric (words metric) /= "") 
                then if head (words metric) == "sum" then sumFunction [(createParameter (words metric),0)] 
                        else (if head (words metric) == "average" then averageFunction [(createParameter(words metric), 0, 0)] else maximumFunction [(createParameter (words metric),0)])
                else do 
                    putStr "Parâmetros da métrica incorretos."
                    -- meter este else num ciclo while enquanto estiver mal formado?



--verificar se a métrica está be construida
verifyMetric :: [String] -> String
verifyMetric [] = ""
verifyMetric lista@(x:xs) = if (even (length lista) && x `elem` ["sum", "average", "maximum", "groupby"]) || (odd (length lista) && read x `elem` [0..])
                                then verifyMetric xs else ""


--organizar só com os numeros das colunas para depois dar como parametro nas funcoes sum etc
createParameter :: [String] -> [Int]
createParameter xs = [read x - 1 | x <- xs, y <- [0..length xs - 1], odd y]



sumFunction :: [([Int], Int)] -> IO()
sumFunction [] = return()
sumFunction lista@(x:xs) = do
    input <- getLine
    --lista <- parseInput input    -- isto era suposto ser usado mas não funciona pk a função não é IO

    -- fst(last lista) corresponde aos numeros das colunas de comparação - metrica
 
    
    -- garantir que o input tem colunas suficientes
    Control.Monad.when (length (parseInput input) < last (fst(last lista))) $ putStr "erro"

    -- aplicação da soma: se já existe o grupo vai substituir se nao cria novo par
    if verifyIfPatternExists (parseInput input) (map fst (init lista)) (fst (last lista)) then do 

                                                                                            else do print $ parseInput input !! head (fst (last lista))
                                                                                                    sumFunction $ (parseInput input, parseInput input !! head (fst (last lista))) : lista  
                                                                                                    



--averageFunction :: [([Int], Int, Int)] -> IO()
--averageFunction list = 


--maximumFunction :: [([Int], Int)] -> IO()
--maximumFunction list = 




parseInput :: String -> [Int]
parseInput input = map read $ words input


verifyIfPatternExists :: [Int] -> [[Int]] -> [Int] -> Bool
verifyIfPatternExists currentInput [] base = False
verifyIfPatternExists currentInput (x:xs) base = (foldl (\y acc -> (currentInput !! y == x !! y) && acc) True base) || verifyIfPatternExists currentInput xs base

            

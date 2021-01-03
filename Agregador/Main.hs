import System.IO
import System.Environment
import Data.Map as M

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
            if not(Prelude.null(words metric)) && even(length(words metric)) && (verifyMetric $ words metric)
                then if head (words metric) == "sum" 
                    then sumFunction (createParameter (words metric)) M.empty
                    else if head (words metric) == "average"
                            then averageFunction (createParameter (words metric)) M.empty
                            else maximumFunction (createParameter (words metric)) M.empty
                else putStr "Parâmetros da métrica incorretos."
                    -- meter este else num ciclo while enquanto estiver mal formado?



--verificar se a métrica está be construida
verifyMetric :: [String] -> Bool
verifyMetric [] = True
verifyMetric lista@(x:xs) = if (even (length lista) && x `elem` ["sum", "average", "maximum", "groupby"]) || (odd (length lista) && read x `elem` [0..])
                                then verifyMetric xs 
                                else False


--organizar só com os numeros das colunas para depois dar como parametro nas funcoes sum etc
createParameter :: [String] -> [Int]
createParameter xs = [read (xs !! y)| y <- [0..length xs], odd y]


sumFunction :: [Int] -> M.Map [Int] Int -> IO() --por o result em float
sumFunction metric mapa = do
    input <- getLine
    if (input == "exit")
    then return ()
    else do
        let groups = parseInput input
            value = groups !! head metric
            key = getKey metric groups
            updatedMap = M.insertWith (+) key value mapa
            result = M.findWithDefault 0 key updatedMap
        putStrLn $ show result
        sumFunction metric updatedMap


averageFunction :: [Int] -> M.Map [Int] (Int,Int) -> IO() --por o result em float
averageFunction metric mapa = do
    input <- getLine
    if (input == "exit")
    then return ()
    else do
        let groups = parseInput input
            value =(1, groups !! head metric)
            key = getKey metric groups
            updatedMap = M.insertWith (plusPair) key value mapa
            (count,soma) = M.findWithDefault (0,0) key updatedMap
            result = soma `div` count
        putStrLn $ show result
        averageFunction metric updatedMap


maximumFunction :: [Int] -> M.Map [Int] Int -> IO() --por o result em float
maximumFunction metric mapa = do
    input <- getLine
    if (input == "exit")
    then return ()
    else do
        let groups = parseInput input
            value = groups !! head metric
            key = getKey metric groups
            updatedMap = M.insertWith (max) key value mapa
            result = M.findWithDefault 0 key updatedMap
        putStrLn $ show result
        maximumFunction metric updatedMap


parseInput :: String -> [Int]
parseInput input = Prelude.map read $ words input


getKey :: [Int] -> [Int] -> [Int]
getKey metric xs = [xs !! y | y <- tail metric]


plusPair :: (Int,Int) -> (Int,Int) -> (Int,Int)
plusPair (x,y) (w,z) = (x + w, y + z)
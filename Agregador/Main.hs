module Main(
main
)where

import Test.QuickCheck
import System.IO
import System.Environment
import Data.Map as M

main :: IO ()
main = do
    hSetBuffering stdin NoBuffering
    hSetBuffering stdout NoBuffering
    args <- getArgs
    if args == ["-t"]
        then do
        testParameter
        testParseInput
        testPlusPair
        else do
            metric <- getLine 
            if head (words metric) == "sum" 
                then sumFunction (createParameter (words metric)) M.empty
                else if head (words metric) == "average"
                        then averageFunction (createParameter (words metric)) M.empty
                        else maximumFunction (createParameter (words metric)) M.empty

--organizar só com os numeros das colunas para depois dar como parametro nas funcoes sum etc
createParameter :: [String] -> [Int]
createParameter xs = [read (xs !! y)| y <- [0..length xs], odd y]


sumFunction :: [Int] -> M.Map [Int] Float -> IO()
sumFunction metric mapa = do
    input <- getLine
    if input == "exit"
    then return ()
    else do
        let groups = parseInput input
            value = fromIntegral (groups !! head metric) :: Float
            key = getKey metric groups
            updatedMap = M.insertWith (+) key value mapa
            result = M.findWithDefault 0 key updatedMap
        print result
        sumFunction metric updatedMap


averageFunction :: [Int] -> M.Map [Int] (Float,Float) -> IO()
averageFunction metric mapa = do
    input <- getLine
    if input == "exit"
    then return ()
    else do
        let groups = parseInput input
            value =(1.0,fromIntegral (groups !! head metric) :: Float)
            key = getKey metric groups
            updatedMap = M.insertWith plusPair key value mapa
            (count,soma) = M.findWithDefault (0,0) key updatedMap
            result = soma / count
        print result
        averageFunction metric updatedMap


maximumFunction :: [Int] -> M.Map [Int] Float -> IO()
maximumFunction metric mapa = do
    input <- getLine
    if input == "exit"
    then return ()
    else do
        let groups = parseInput input
            value = fromIntegral (groups !! head metric) :: Float
            key = getKey metric groups
            updatedMap = M.insertWith max key value mapa
            result = M.findWithDefault 0 key updatedMap
        print result
        maximumFunction metric updatedMap


parseInput :: String -> [Int]
parseInput input = Prelude.map read $ words input


getKey :: [Int] -> [Int] -> [Int]
getKey metric xs = [xs !! y | y <- tail metric]


plusPair :: (Float,Float) -> (Float,Float) -> (Float,Float)
plusPair (x,y) (w,z) = (x + w, y + z)


testParameter :: IO()
testParameter = quickCheck prop_parameter

prop_parameter :: [String] -> Property
prop_parameter xs = not (Prelude.null xs) && even (length xs) ==> length (createParameter xs) == length xs `div` 2


testParseInput :: IO()
testParseInput = quickCheck prop_parseInput

prop_parseInput :: String -> Property
prop_parseInput xs = not (Prelude.null xs) ==> length xs >= length (parseInput xs)


testPlusPair :: IO()
testPlusPair = quickCheck aux_plusPair

aux_plusPair ::  (Float,Float) -> (Float,Float) -> Bool
aux_plusPair (x1,x2) (y1,y2) = fst (plusPair (x1,x2) (y1,y2)) == x1 + y1 && snd (plusPair (x1,x2) (y1,y2)) == x2 + y2
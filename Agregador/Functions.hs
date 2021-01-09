module Functions
  ( createParameter,
    sumFunction,
    averageFunction,
    maximumFunction,
    parseInput,
    plusPair,
  )
where

import Data.Map as M

createParameter :: [String] -> [Int]
createParameter xs = [read (xs !! y) | y <- [0 .. length xs], odd y]

sumFunction :: [Int] -> M.Map [Int] Float -> IO ()
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

averageFunction :: [Int] -> M.Map [Int] (Float, Float) -> IO ()
averageFunction metric mapa = do
  input <- getLine
  if input == "exit"
    then return ()
    else do
      let groups = parseInput input
          value = (1.0, fromIntegral (groups !! head metric) :: Float)
          key = getKey metric groups
          updatedMap = M.insertWith plusPair key value mapa
          (count, soma) = M.findWithDefault (0, 0) key updatedMap
          result = soma / count
      print result
      averageFunction metric updatedMap

maximumFunction :: [Int] -> M.Map [Int] Float -> IO ()
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

plusPair :: (Float, Float) -> (Float, Float) -> (Float, Float)
plusPair (x, y) (w, z) = (x + w, y + z)
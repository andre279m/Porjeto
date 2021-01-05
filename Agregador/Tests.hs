module Tests (
    testParameter,
    testParseInput,
    testPlusPair
    ) where

import Test.QuickCheck
import Functions

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
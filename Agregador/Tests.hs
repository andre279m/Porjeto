module Tests (testParameter) where

import Test.QuickCheck
import Functions

testParameter = quickCheck propParameter

propParameter :: [String] -> Bool
propParameter xs = length (createParameter xs) == (length xs) `div` 2

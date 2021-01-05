module Tests
(testParameter
) where

import Test.QuickCheck
import Functions

testParameter = quickCheck propParameter

propParameter :: [String] -> Property
propParameter xs = not (null xs) ==> length (createParameter xs) == (length xs) `div` 2

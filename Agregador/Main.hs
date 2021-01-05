module Main(
main
)where

import Test.QuickCheck
import System.IO
import System.Environment
import Data.Map as M
import Tests
import Functions

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

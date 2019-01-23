module Main where

import Data.Text

x = 5
y = 8

main :: IO ()
main = do
  putStrLn $ show (x + y)
  putStrLn $ show $ x
  where foo x = x + 1

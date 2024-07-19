module ENSICO (module ENSICO,
               module Prelude,
               module Data.Char,
               module Data.List) where

----------------------------------
--- Import 3rd-party libraries ---

import Prelude hiding ((>>))
import Data.Char
import Data.List

done = putStrLn "Feito!"

-------------------
--- Operator |> ---

(|>) = flip ($)

------------------
--- Operator # ---

a # b = a `zip` b

------------------
--- Function get ---

get :: Int -> [a] -> a
get i list = list !! i

------------------
--- Function pp (Pretty-Printing) ---

pp = putStr

-------------------
--- Operator >> ---

(>>) = flip (.)



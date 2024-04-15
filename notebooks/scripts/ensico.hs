module ENSICO (module ENSICO,
               module Data.Char,
               module Data.List) where

----------------------------------
--- Import 3rd-party libraries ---

import Data.Char
import Data.List


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



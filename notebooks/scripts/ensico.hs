module ENSICO where

--- composition ---

(|>) = flip ($)

------------------
--- Operator # ---

a # b = a `zip` b

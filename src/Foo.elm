module Foo exposing (..)

twice : number -> number
twice = (*) 2

square : number -> number
square x = x * x

typeOfList : List Int -> String
typeOfList xs =
  case xs of
    [] -> "empty list"
    [_] -> "1 item"
    [_, _] -> "2 items"
    [_, _, _] -> "3 items"
    _ -> "more than 3 items"
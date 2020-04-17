module Tests exposing (..)

import Test exposing (..)
import Expect

all : Test
all =
    describe "A Test Suite"
        [ test "Addition" <|
            \_ ->
                Expect.equal 10 (3 + 7)
        , test "String.left" <|
            \_ ->
                Expect.equal "a" (String.left 1 "abcdefg")
        , test "String.left 2" <|
            \_ ->
                Expect.equal "ab" (String.left 2 "abcdefg")
        , test "This test should fail" <|
            \_ ->
                Expect.fail "failed as expected!"
        ]

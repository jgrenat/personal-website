-- Do not manually edit this file, it was auto-generated by dillonkearns/elm-graphql
-- https://github.com/dillonkearns/elm-graphql


module Datocms.Enum.ImgixParamsTxtAlign exposing (..)

import Json.Decode as Decode exposing (Decoder)


type ImgixParamsTxtAlign
    = Top
    | Middle
    | Bottom
    | Left
    | Center
    | Right


list : List ImgixParamsTxtAlign
list =
    [ Top, Middle, Bottom, Left, Center, Right ]


decoder : Decoder ImgixParamsTxtAlign
decoder =
    Decode.string
        |> Decode.andThen
            (\string ->
                case string of
                    "top" ->
                        Decode.succeed Top

                    "middle" ->
                        Decode.succeed Middle

                    "bottom" ->
                        Decode.succeed Bottom

                    "left" ->
                        Decode.succeed Left

                    "center" ->
                        Decode.succeed Center

                    "right" ->
                        Decode.succeed Right

                    _ ->
                        Decode.fail ("Invalid ImgixParamsTxtAlign type, " ++ string ++ " try re-running the @dillonkearns/elm-graphql CLI ")
            )


{-| Convert from the union type representing the Enum to a string that the GraphQL server will recognize.
-}
toString : ImgixParamsTxtAlign -> String
toString enum____ =
    case enum____ of
        Top ->
            "top"

        Middle ->
            "middle"

        Bottom ->
            "bottom"

        Left ->
            "left"

        Center ->
            "center"

        Right ->
            "right"


{-| Convert from a String representation to an elm representation enum.
This is the inverse of the Enum `toString` function. So you can call `toString` and then convert back `fromString` safely.

    Swapi.Enum.Episode.NewHope
        |> Swapi.Enum.Episode.toString
        |> Swapi.Enum.Episode.fromString
        == Just NewHope

This can be useful for generating Strings to use for <select> menus to check which item was selected.

-}
fromString : String -> Maybe ImgixParamsTxtAlign
fromString enumString____ =
    case enumString____ of
        "top" ->
            Just Top

        "middle" ->
            Just Middle

        "bottom" ->
            Just Bottom

        "left" ->
            Just Left

        "center" ->
            Just Center

        "right" ->
            Just Right

        _ ->
            Nothing
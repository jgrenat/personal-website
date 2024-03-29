-- Do not manually edit this file, it was auto-generated by dillonkearns/elm-graphql
-- https://github.com/dillonkearns/elm-graphql


module Datocms.Enum.ImgixParamsBlendAlign exposing (..)

import Json.Decode as Decode exposing (Decoder)


type ImgixParamsBlendAlign
    = Top
    | Bottom
    | Middle
    | Left
    | Right
    | Center


list : List ImgixParamsBlendAlign
list =
    [ Top, Bottom, Middle, Left, Right, Center ]


decoder : Decoder ImgixParamsBlendAlign
decoder =
    Decode.string
        |> Decode.andThen
            (\string ->
                case string of
                    "top" ->
                        Decode.succeed Top

                    "bottom" ->
                        Decode.succeed Bottom

                    "middle" ->
                        Decode.succeed Middle

                    "left" ->
                        Decode.succeed Left

                    "right" ->
                        Decode.succeed Right

                    "center" ->
                        Decode.succeed Center

                    _ ->
                        Decode.fail ("Invalid ImgixParamsBlendAlign type, " ++ string ++ " try re-running the @dillonkearns/elm-graphql CLI ")
            )


{-| Convert from the union type representing the Enum to a string that the GraphQL server will recognize.
-}
toString : ImgixParamsBlendAlign -> String
toString enum____ =
    case enum____ of
        Top ->
            "top"

        Bottom ->
            "bottom"

        Middle ->
            "middle"

        Left ->
            "left"

        Right ->
            "right"

        Center ->
            "center"


{-| Convert from a String representation to an elm representation enum.
This is the inverse of the Enum `toString` function. So you can call `toString` and then convert back `fromString` safely.

    Swapi.Enum.Episode.NewHope
        |> Swapi.Enum.Episode.toString
        |> Swapi.Enum.Episode.fromString
        == Just NewHope

This can be useful for generating Strings to use for <select> menus to check which item was selected.

-}
fromString : String -> Maybe ImgixParamsBlendAlign
fromString enumString____ =
    case enumString____ of
        "top" ->
            Just Top

        "bottom" ->
            Just Bottom

        "middle" ->
            Just Middle

        "left" ->
            Just Left

        "right" ->
            Just Right

        "center" ->
            Just Center

        _ ->
            Nothing

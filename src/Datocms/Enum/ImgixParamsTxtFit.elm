-- Do not manually edit this file, it was auto-generated by dillonkearns/elm-graphql
-- https://github.com/dillonkearns/elm-graphql


module Datocms.Enum.ImgixParamsTxtFit exposing (..)

import Json.Decode as Decode exposing (Decoder)


type ImgixParamsTxtFit
    = Max


list : List ImgixParamsTxtFit
list =
    [ Max ]


decoder : Decoder ImgixParamsTxtFit
decoder =
    Decode.string
        |> Decode.andThen
            (\string ->
                case string of
                    "max" ->
                        Decode.succeed Max

                    _ ->
                        Decode.fail ("Invalid ImgixParamsTxtFit type, " ++ string ++ " try re-running the @dillonkearns/elm-graphql CLI ")
            )


{-| Convert from the union type representing the Enum to a string that the GraphQL server will recognize.
-}
toString : ImgixParamsTxtFit -> String
toString enum____ =
    case enum____ of
        Max ->
            "max"


{-| Convert from a String representation to an elm representation enum.
This is the inverse of the Enum `toString` function. So you can call `toString` and then convert back `fromString` safely.

    Swapi.Enum.Episode.NewHope
        |> Swapi.Enum.Episode.toString
        |> Swapi.Enum.Episode.fromString
        == Just NewHope

This can be useful for generating Strings to use for <select> menus to check which item was selected.

-}
fromString : String -> Maybe ImgixParamsTxtFit
fromString enumString____ =
    case enumString____ of
        "max" ->
            Just Max

        _ ->
            Nothing

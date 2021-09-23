-- Do not manually edit this file, it was auto-generated by dillonkearns/elm-graphql
-- https://github.com/dillonkearns/elm-graphql


module Datocms.Enum.ImgixParamsTransparency exposing (..)

import Json.Decode as Decode exposing (Decoder)


type ImgixParamsTransparency
    = Grid


list : List ImgixParamsTransparency
list =
    [ Grid ]


decoder : Decoder ImgixParamsTransparency
decoder =
    Decode.string
        |> Decode.andThen
            (\string ->
                case string of
                    "grid" ->
                        Decode.succeed Grid

                    _ ->
                        Decode.fail ("Invalid ImgixParamsTransparency type, " ++ string ++ " try re-running the @dillonkearns/elm-graphql CLI ")
            )


{-| Convert from the union type representing the Enum to a string that the GraphQL server will recognize.
-}
toString : ImgixParamsTransparency -> String
toString enum____ =
    case enum____ of
        Grid ->
            "grid"


{-| Convert from a String representation to an elm representation enum.
This is the inverse of the Enum `toString` function. So you can call `toString` and then convert back `fromString` safely.

    Swapi.Enum.Episode.NewHope
        |> Swapi.Enum.Episode.toString
        |> Swapi.Enum.Episode.fromString
        == Just NewHope

This can be useful for generating Strings to use for <select> menus to check which item was selected.

-}
fromString : String -> Maybe ImgixParamsTransparency
fromString enumString____ =
    case enumString____ of
        "grid" ->
            Just Grid

        _ ->
            Nothing

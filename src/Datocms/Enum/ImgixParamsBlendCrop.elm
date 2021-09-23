-- Do not manually edit this file, it was auto-generated by dillonkearns/elm-graphql
-- https://github.com/dillonkearns/elm-graphql


module Datocms.Enum.ImgixParamsBlendCrop exposing (..)

import Json.Decode as Decode exposing (Decoder)


type ImgixParamsBlendCrop
    = Top
    | Bottom
    | Left
    | Right
    | Faces


list : List ImgixParamsBlendCrop
list =
    [ Top, Bottom, Left, Right, Faces ]


decoder : Decoder ImgixParamsBlendCrop
decoder =
    Decode.string
        |> Decode.andThen
            (\string ->
                case string of
                    "top" ->
                        Decode.succeed Top

                    "bottom" ->
                        Decode.succeed Bottom

                    "left" ->
                        Decode.succeed Left

                    "right" ->
                        Decode.succeed Right

                    "faces" ->
                        Decode.succeed Faces

                    _ ->
                        Decode.fail ("Invalid ImgixParamsBlendCrop type, " ++ string ++ " try re-running the @dillonkearns/elm-graphql CLI ")
            )


{-| Convert from the union type representing the Enum to a string that the GraphQL server will recognize.
-}
toString : ImgixParamsBlendCrop -> String
toString enum____ =
    case enum____ of
        Top ->
            "top"

        Bottom ->
            "bottom"

        Left ->
            "left"

        Right ->
            "right"

        Faces ->
            "faces"


{-| Convert from a String representation to an elm representation enum.
This is the inverse of the Enum `toString` function. So you can call `toString` and then convert back `fromString` safely.

    Swapi.Enum.Episode.NewHope
        |> Swapi.Enum.Episode.toString
        |> Swapi.Enum.Episode.fromString
        == Just NewHope

This can be useful for generating Strings to use for <select> menus to check which item was selected.

-}
fromString : String -> Maybe ImgixParamsBlendCrop
fromString enumString____ =
    case enumString____ of
        "top" ->
            Just Top

        "bottom" ->
            Just Bottom

        "left" ->
            Just Left

        "right" ->
            Just Right

        "faces" ->
            Just Faces

        _ ->
            Nothing
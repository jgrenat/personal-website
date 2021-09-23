-- Do not manually edit this file, it was auto-generated by dillonkearns/elm-graphql
-- https://github.com/dillonkearns/elm-graphql


module Datocms.Enum.ImgixParamsBlendFit exposing (..)

import Json.Decode as Decode exposing (Decoder)


type ImgixParamsBlendFit
    = Clamp
    | Clip
    | Crop
    | Scale
    | Max


list : List ImgixParamsBlendFit
list =
    [ Clamp, Clip, Crop, Scale, Max ]


decoder : Decoder ImgixParamsBlendFit
decoder =
    Decode.string
        |> Decode.andThen
            (\string ->
                case string of
                    "clamp" ->
                        Decode.succeed Clamp

                    "clip" ->
                        Decode.succeed Clip

                    "crop" ->
                        Decode.succeed Crop

                    "scale" ->
                        Decode.succeed Scale

                    "max" ->
                        Decode.succeed Max

                    _ ->
                        Decode.fail ("Invalid ImgixParamsBlendFit type, " ++ string ++ " try re-running the @dillonkearns/elm-graphql CLI ")
            )


{-| Convert from the union type representing the Enum to a string that the GraphQL server will recognize.
-}
toString : ImgixParamsBlendFit -> String
toString enum____ =
    case enum____ of
        Clamp ->
            "clamp"

        Clip ->
            "clip"

        Crop ->
            "crop"

        Scale ->
            "scale"

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
fromString : String -> Maybe ImgixParamsBlendFit
fromString enumString____ =
    case enumString____ of
        "clamp" ->
            Just Clamp

        "clip" ->
            Just Clip

        "crop" ->
            Just Crop

        "scale" ->
            Just Scale

        "max" ->
            Just Max

        _ ->
            Nothing

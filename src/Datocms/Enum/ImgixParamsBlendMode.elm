-- Do not manually edit this file, it was auto-generated by dillonkearns/elm-graphql
-- https://github.com/dillonkearns/elm-graphql


module Datocms.Enum.ImgixParamsBlendMode exposing (..)

import Json.Decode as Decode exposing (Decoder)


type ImgixParamsBlendMode
    = Color
    | Burn
    | Dodge
    | Darken
    | Difference
    | Exclusion
    | Hardlight
    | Hue
    | Lighten
    | Luminosity
    | Multiply
    | Overlay
    | Saturation
    | Screen
    | Softlight
    | Normal


list : List ImgixParamsBlendMode
list =
    [ Color, Burn, Dodge, Darken, Difference, Exclusion, Hardlight, Hue, Lighten, Luminosity, Multiply, Overlay, Saturation, Screen, Softlight, Normal ]


decoder : Decoder ImgixParamsBlendMode
decoder =
    Decode.string
        |> Decode.andThen
            (\string ->
                case string of
                    "color" ->
                        Decode.succeed Color

                    "burn" ->
                        Decode.succeed Burn

                    "dodge" ->
                        Decode.succeed Dodge

                    "darken" ->
                        Decode.succeed Darken

                    "difference" ->
                        Decode.succeed Difference

                    "exclusion" ->
                        Decode.succeed Exclusion

                    "hardlight" ->
                        Decode.succeed Hardlight

                    "hue" ->
                        Decode.succeed Hue

                    "lighten" ->
                        Decode.succeed Lighten

                    "luminosity" ->
                        Decode.succeed Luminosity

                    "multiply" ->
                        Decode.succeed Multiply

                    "overlay" ->
                        Decode.succeed Overlay

                    "saturation" ->
                        Decode.succeed Saturation

                    "screen" ->
                        Decode.succeed Screen

                    "softlight" ->
                        Decode.succeed Softlight

                    "normal" ->
                        Decode.succeed Normal

                    _ ->
                        Decode.fail ("Invalid ImgixParamsBlendMode type, " ++ string ++ " try re-running the @dillonkearns/elm-graphql CLI ")
            )


{-| Convert from the union type representing the Enum to a string that the GraphQL server will recognize.
-}
toString : ImgixParamsBlendMode -> String
toString enum____ =
    case enum____ of
        Color ->
            "color"

        Burn ->
            "burn"

        Dodge ->
            "dodge"

        Darken ->
            "darken"

        Difference ->
            "difference"

        Exclusion ->
            "exclusion"

        Hardlight ->
            "hardlight"

        Hue ->
            "hue"

        Lighten ->
            "lighten"

        Luminosity ->
            "luminosity"

        Multiply ->
            "multiply"

        Overlay ->
            "overlay"

        Saturation ->
            "saturation"

        Screen ->
            "screen"

        Softlight ->
            "softlight"

        Normal ->
            "normal"


{-| Convert from a String representation to an elm representation enum.
This is the inverse of the Enum `toString` function. So you can call `toString` and then convert back `fromString` safely.

    Swapi.Enum.Episode.NewHope
        |> Swapi.Enum.Episode.toString
        |> Swapi.Enum.Episode.fromString
        == Just NewHope

This can be useful for generating Strings to use for <select> menus to check which item was selected.

-}
fromString : String -> Maybe ImgixParamsBlendMode
fromString enumString____ =
    case enumString____ of
        "color" ->
            Just Color

        "burn" ->
            Just Burn

        "dodge" ->
            Just Dodge

        "darken" ->
            Just Darken

        "difference" ->
            Just Difference

        "exclusion" ->
            Just Exclusion

        "hardlight" ->
            Just Hardlight

        "hue" ->
            Just Hue

        "lighten" ->
            Just Lighten

        "luminosity" ->
            Just Luminosity

        "multiply" ->
            Just Multiply

        "overlay" ->
            Just Overlay

        "saturation" ->
            Just Saturation

        "screen" ->
            Just Screen

        "softlight" ->
            Just Softlight

        "normal" ->
            Just Normal

        _ ->
            Nothing
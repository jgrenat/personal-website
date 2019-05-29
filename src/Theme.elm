module Theme exposing (primaryBackgroundColor, primaryColor, secondaryColor, shadowColor, spaceScale, standardFonts, textScale, titleFonts)

import Element exposing (modular)
import Element.Font as Font exposing (Font)


primaryColor : Element.Color
primaryColor =
    Element.fromRgb255
        { red = 0
        , green = 200
        , blue = 50
        , alpha = 1
        }


secondaryColor : Element.Color
secondaryColor =
    Element.fromRgb255
        { red = 0
        , green = 50
        , blue = 200
        , alpha = 1
        }


primaryBackgroundColor : Element.Color
primaryBackgroundColor =
    Element.fromRgb255
        { red = 255
        , green = 255
        , blue = 255
        , alpha = 1
        }


shadowColor : Element.Color
shadowColor =
    Element.fromRgb255
        { red = 0
        , green = 0
        , blue = 0
        , alpha = 0.4
        }


textScale : Int -> Int
textScale scaleToApply =
    modular 16 1.25 scaleToApply
        |> ceiling


spaceScale : Int -> Int
spaceScale scaleToApply =
    modular 16 1.25 scaleToApply
        |> ceiling


titleFonts : List Font
titleFonts =
    [ Font.typeface "Rubik", Font.serif ]


standardFonts : List Font
standardFonts =
    [ Font.typeface "Noto Sans", Font.serif ]

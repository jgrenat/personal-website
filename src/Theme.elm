module Theme exposing (activeLinkColor, primaryBackgroundColor, primaryColor, secondaryColor, shadowColor, spaceScale, standardFonts, textScale, titleFonts)

import Element exposing (Color, modular)
import Element.Font as Font exposing (Font)


primaryColor : Color
primaryColor =
    Element.fromRgb255
        { red = 0
        , green = 200
        , blue = 50
        , alpha = 1
        }


secondaryColor : Color
secondaryColor =
    Element.fromRgb255
        { red = 0
        , green = 50
        , blue = 200
        , alpha = 1
        }


activeLinkColor : Color
activeLinkColor =
    primaryColor


primaryBackgroundColor : Color
primaryBackgroundColor =
    Element.fromRgb255
        { red = 255
        , green = 255
        , blue = 255
        , alpha = 0.9
        }


shadowColor : Color
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
    [ rubikFont, Font.serif ]


standardFonts : List Font
standardFonts =
    [ notoSansFont, Font.serif ]


rubikFont : Font
rubikFont =
    Font.external
        { url = "https://fonts.googleapis.com/css?family=Rubik&display=swap"
        , name = "Rubik"
        }


notoSansFont : Font
notoSansFont =
    Font.external
        { url = "https://fonts.googleapis.com/css?family=Noto+Sans&display=swap"
        , name = "Noto Sans"
        }

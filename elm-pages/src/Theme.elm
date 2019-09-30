module Theme exposing (activeLinkColor, opaquePanelBackgroundColor, primaryBackgroundColor, primaryColor, secondaryColor, shadowColor, spaceScale, standardFonts, textScale, titleFonts)

import Element exposing (Color, modular)
import Element.Font as Font exposing (Font)


primaryColor : Color
primaryColor =
    Element.fromRgb255
        { red = 245
        , green = 245
        , blue = 245
        , alpha = 1
        }


secondaryColor : Color
secondaryColor =
    Element.fromRgb255
        { red = 100
        , green = 180
        , blue = 250
        , alpha = 1
        }


activeLinkColor : Color
activeLinkColor =
    secondaryColor


primaryBackgroundColor : Color
primaryBackgroundColor =
    Element.fromRgb255
        { red = 255
        , green = 255
        , blue = 255
        , alpha = 0.95
        }


opaquePanelBackgroundColor : Color
opaquePanelBackgroundColor =
    Element.fromRgb255 { red = 255, green = 255, blue = 255, alpha = 1 }


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

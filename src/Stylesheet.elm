module Stylesheet exposing (onMobile, stylesheet)

import Css exposing (Style, auto, backgroundColor, block, boxShadow5, calc, center, display, fontFamilies, fontSize, fontWeight, height, int, margin2, marginBottom, marginTop, maxWidth, padding2, pct, plus, px, rem, rgba, textAlign, vh, vw, width, zero)
import Css.Global as Css exposing (Snippet, global)
import Css.Media exposing (only, screen)
import Html.Styled exposing (Html)


stylesheet : Html msg
stylesheet =
    global styles


styles : List Snippet
styles =
    [ Css.html
        [ height (pct 100)
        ]
    , Css.body
        [ height (pct 100)
        , fontSize (calc (px 16) plus (vw 0.2))
        , fontFamilies [ "Noto Sans", "sans-serif" ]
        ]
    , Css.h1
        [ fontFamilies [ "Rubik", "serif" ]
        , fontSize (calc (rem 1.6) plus (vw 2))
        , textAlign center
        , marginBottom (vh 5)
        , marginTop (vw 1)
        ]
    , Css.h2
        [ fontSize (calc (rem 1.2) plus (vw 1))
        , textAlign center
        , marginBottom (vh 3)
        , fontWeight (int 900)
        ]
    , Css.class "opaquePanel"
        [ display block
        , backgroundColor (rgba 255 255 255 0.99)
        , padding2 (vh 5) (vw 3)
        , maxWidth (px 900)
        , width (pct 95)
        , onMobile [ width (pct 100) ]
        , margin2 (vh 3) auto
        , boxShadow5 zero (px 1) (px 5) (px 1) (rgba 0 0 0 0.4)
        ]
    ]


onMobile : List Style -> Style
onMobile stylesList =
    Css.Media.withMedia
        [ only screen [ Css.Media.maxWidth (px 500) ]
        ]
        stylesList

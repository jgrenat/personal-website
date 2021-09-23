module CssHelper exposing (onMobile)

import Css exposing (Style, px)
import Css.Media exposing (only, screen)


onMobile : List Style -> Style
onMobile stylesList =
    Css.Media.withMedia
        [ only screen [ Css.Media.maxWidth (px 600) ]
        ]
        stylesList

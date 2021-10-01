module View exposing (View, map, placeholder, userContentStyles)

import Css exposing (Style, absolute, alignItems, auto, backgroundColor, borderLeft, borderLeft3, borderTop3, center, color, disc, displayFlex, em, fontSize, fontStyle, fontWeight, height, int, italic, justify, justifyContent, left, lineHeight, listStyleType, margin, margin2, margin3, marginBottom, marginLeft, marginRight, marginTop, maxWidth, none, overflowY, padding2, paddingLeft, paddingTop, pct, position, preWrap, px, relative, rem, rgb, rgba, right, scale, scroll, solid, spaceBetween, textAlign, textDecoration, top, transform, underline, vh, vw, whiteSpace, width, zero)
import Css.Global as Global exposing (Snippet)
import CssHelper exposing (onMobile)
import Html.Styled as Html exposing (Html)


type alias View msg =
    { title : String
    , body : List (Html msg)
    }


map : (msg1 -> msg2) -> View msg1 -> View msg2
map fn doc =
    { title = doc.title
    , body = List.map (Html.map fn) doc.body
    }


placeholder : String -> View msg
placeholder moduleName =
    { title = "Placeholder - " ++ moduleName
    , body = [ Html.text moduleName ]
    }


{-| Used to style content from DatoCMS
-}
userContentStyles : List Style
userContentStyles =
    [ Global.descendants
        [ Global.h2
            [ fontSize (rem 2.2)
            , fontWeight (int 900)
            , textAlign left
            , margin3 (rem 3.5) zero (rem 1)
            ]
        , Global.h3
            [ fontSize (rem 1.8)
            , fontWeight (int 600)
            , textAlign left
            , margin3 (vh 3) zero (vh 1)
            , color (rgba 0 0 0 0.8)
            ]
        , Global.h4
            [ fontSize (rem 1.2)
            , fontWeight (int 200)
            , textAlign left
            , margin3 (vh 2) zero (vh 1)
            , color (rgba 0 0 0 0.6)
            ]
        , Global.p
            [ margin2 (rem 2.5) zero
            , lineHeight (rem 2)
            , whiteSpace preWrap
            , textAlign justify
            , color (rgba 0 0 0 0.8)
            , Global.children
                [ Global.code
                    [ backgroundColor (rgba 225 225 255 0.7)
                    , padding2 (px 1) (px 3)
                    , fontSize (em 0.7)
                    ]
                ]
            ]
        , Global.blockquote
            [ borderLeft3 (px 5) solid (rgba 5 117 230 0.8)
            , backgroundColor (rgba 5 117 230 0.1)
            , padding2 (vh 0.01) (vw 1)
            , maxWidth (px 650)
            , margin2 (rem 2.5) auto
            , Global.children
                [ Global.p
                    [ Css.firstChild [ marginTop (rem 1) ]
                    , Css.lastChild [ marginBottom (rem 1) ]
                    ]
                ]
            , onMobile
                [ borderLeft zero
                , borderTop3 (px 5) solid (rgba 5 117 230 0.8)
                , padding2 (vh 0.01) (vw 3)
                ]
            ]
        , Global.strong
            [ fontWeight (int 900)
            , color (rgb 0 0 0)
            ]
        , Global.em
            [ fontStyle italic
            ]
        , Global.a
            [ textDecoration underline
            , Css.hover [ textDecoration none ]
            ]
        , Global.class "thanks"
            [ marginTop (vw 2)
            , fontStyle italic
            , fontSize (em 0.8)
            , textAlign right
            ]
        , Global.ul
            [ listStyleType disc
            , paddingLeft (rem 1)
            , marginLeft (vh 2)
            , Global.children
                [ Global.li
                    [ Global.adjacentSiblings
                        [ Global.li
                            [ marginTop (vh 2)
                            ]
                        ]
                    ]
                ]
            ]
        , Global.pre
            [ maxWidth (pct 100)
            , overflowY scroll
            ]
        , Global.code
            [ lineHeight (rem 1.7)
            , fontSize (em 0.85)
            ]
        ]
    ]

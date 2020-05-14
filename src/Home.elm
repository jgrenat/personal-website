module Home exposing (view)

import Css exposing (Style, alignItems, auto, backgroundColor, borderRadius, boxShadow5, center, column, displayFlex, flexDirection, flexGrow, flexWrap, fontSize, height, hex, int, justifyContent, margin, margin3, marginBottom, marginTop, maxWidth, minWidth, padding2, padding4, pct, px, rem, rgba, vh, vw, width, wrap, zero)
import Css.Global as Css exposing (Snippet, global)
import Html.Styled exposing (Html, a, div, fromUnstyled, h1, img, main_, p, text, ul)
import Html.Styled.Attributes exposing (alt, attribute, class, classList, href, rel, src)
import Octicons


view : Html msg
view =
    div [ class "home" ]
        [ global [ styles ]
        , mainPanel [ picturePart, biographyPart ]
        ]


picturePart : Html msg
picturePart =
    div [ class "picturePart" ]
        [ img [ src "./images/author/jordane.jpeg", alt "Picture of Jordane Grenat" ] []
        ]


biographyPart : Html msg
biographyPart =
    div [ class "biographyPart" ]
        [ h1 [] [ text "Jordane Grenat" ]
        , p [] [ text "Jordane is a developer at Viseo and loves discoveries and everything that seems unusual, which is often in conflict with the pragmatism required for clients' projects." ]
        , p [] [ text "He then satisfies his passion with never-finished personal projects and by going to conferences to meet other novelty lovers. For example: Elm, F#, new-JS-hyped-framework, ..." ]
        , p [] [ text "He spends the rest of his spare time declining cookies on the websites he visits." ]
        , ul [ class "categories", attribute "role" "navigation" ]
            [ iconLink Internal "Articles" "/blog" (Octicons.file octiconOptions |> fromUnstyled)
            , iconLink External "Twitter" "https://twitter.com/JoGrenat" (Octicons.markTwitter octiconOptions |> fromUnstyled)
            , iconLink External "Github" "https://github.com/jgrenat" (Octicons.markGithub octiconOptions |> fromUnstyled)
            , iconLink External "Videos" "https://www.youtube.com/channel/UCROJRWWGrrTmgGF1Wo9OX5w" (Octicons.deviceCameraVideo octiconOptions |> fromUnstyled)
            ]
        ]


type LinkType
    = Internal
    | External


iconLink : LinkType -> String -> String -> Html msg -> Html msg
iconLink linkType label url icon =
    let
        relAttribute =
            if linkType == Internal then
                classList []

            else
                rel "noopener"
    in
    a [ class "iconLink", href url, relAttribute ] [ icon, text label ]


mainPanel : List (Html msg) -> Html msg
mainPanel content =
    main_ [ class "mainPanel" ] content


octiconOptions =
    Octicons.defaultOptions |> Octicons.width 60 |> Octicons.height 60 |> Octicons.margin "auto"


styles : Snippet
styles =
    Css.class "home"
        [ displayFlex
        , alignItems center
        , height (pct 100)
        , Css.descendants
            [ Css.class "mainPanel"
                [ backgroundColor (rgba 255 255 255 0.95)
                , maxWidth (px 1200)
                , minWidth (px 250)
                , width (pct 100)
                , margin auto
                , displayFlex
                , flexWrap wrap
                , boxShadow5 zero (px 1) (px 5) (px 1) (rgba 0 0 0 0.4)
                , alignItems center
                ]
            , Css.class "picturePart"
                [ width (pct 50)
                , minWidth (px 200)
                , margin auto
                , Css.children [ Css.img [ width (pct 100), borderRadius (pct 50) ] ]
                , padding2 (vh 2) (vw 1)
                ]
            , Css.class "biographyPart"
                [ width (pct 50)
                , minWidth (px 250)
                , flexGrow (int 1)
                , padding4 (vh 4) (vw 2) (vh 4) (vw 2)
                , Css.children [ Css.img [ width (pct 100) ] ]
                , Css.children
                    [ Css.p
                        [ fontSize (rem 1.4)
                        , Css.adjacentSiblings
                            [ Css.p
                                [ marginTop (vh 1.5) ]
                            ]
                        ]
                    , Css.class "categories"
                        [ displayFlex
                        , flexWrap wrap
                        , marginTop (vh 3)
                        , marginBottom (vh 1)
                        , justifyContent center
                        , Css.descendants
                            [ Css.class "iconLink"
                                [ displayFlex
                                , flexDirection column
                                , alignItems center
                                , margin3 (px 20) (px 15) zero
                                , padding2 (px 5) (px 5)
                                , borderRadius (px 5)
                                , Css.hover
                                    [ backgroundColor (hex "64b4fa")
                                    ]
                                ]
                            ]
                        ]
                    ]
                ]
            ]
        ]

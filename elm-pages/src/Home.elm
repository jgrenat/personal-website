module Home exposing (..)

import Element exposing (..)
import Element.Background as Background
import Element.Border as Border exposing (shadow)
import Element.Font as Font exposing (center, justify)
import Element.Region as Region
import Html exposing (Html)
import Octicons
import Theme


view : Html msg
view =
    layout [ Font.family Theme.standardFonts, height fill ] <|
        el
            [ width fill, height fill, center ]
            (mainPanel <|
                wrappedRow [ width fill ]
                    [ picturePart, biographyPart ]
            )


picturePart : Element msg
picturePart =
    el
        [ height fill
        , width (fillPortion 2 |> minimum 200 |> maximum 500)
        , paddingXY (Theme.spaceScale 3) (Theme.spaceScale 1)
        ]
    <|
        image
            [ width fill
            , Border.rounded 10000
            , clip
            , centerY
            ]
            { src = "./images/author/jordane.jpeg", description = "Portrait of Jordane Grenat" }


biographyPart : Element msg
biographyPart =
    el
        [ height fill
        , paddingXY 20 20
        , width fill
        , justify
        ]
    <|
        column
            [ spacing (Theme.spaceScale 4)
            , centerY
            , width fill
            , Region.mainContent
            ]
            [ el [ Font.size (Theme.textScale 5), Font.family Theme.titleFonts, center, width fill, Region.heading 1 ] (text "Jordane Grenat")
            , paragraph [] [ text "Jordane is a developer at Viseo and loves discoveries and everything that seems unusual, which is often in conflict with the pragmatism required for clients' projects." ]
            , paragraph [] [ text "He then satisfies his passion with never-finished personal projects and by going to conferences to meet other novelty lovers. For example: Elm, F#, new-JS-hyped-framework, ..." ]
            , paragraph [] [ text "He spends the rest of his spare time declining cookies on the websites he visits." ]
            , row [ centerX, spacing (Theme.spaceScale 5), Region.navigation ]
                [ iconLink "Articles" "/blog" (Octicons.file octiconOptions)
                , iconLink "Twitter" "https://twitter.com/JoGrenat" (Octicons.markTwitter octiconOptions)
                , iconLink "Github" "https://github.com/jgrenat" (Octicons.markGithub octiconOptions)
                ]
            ]


iconLink : String -> String -> Html msg -> Element msg
iconLink label url icon =
    el [] <|
        link [ mouseOver [ Background.color Theme.activeLinkColor ], focused [ Border.glow Theme.activeLinkColor 2 ] ]
            { url = url
            , label =
                column [ centerX, spacing (Theme.spaceScale 1), paddingXY (Theme.spaceScale 1) (Theme.spaceScale 1) ]
                    [ el [ centerX ] <| html icon
                    , text label
                    ]
            }


mainPanel : Element msg -> Element msg
mainPanel element =
    el
        [ centerX
        , centerY
        , width (maximum 1000 fill)
        , Background.color Theme.primaryBackgroundColor
        , shadow { offset = ( 0, 1 ), size = 1, blur = 5, color = Theme.shadowColor }
        ]
        element


octiconOptions =
    Octicons.defaultOptions |> Octicons.width 50 |> Octicons.height 50 |> Octicons.margin "auto"

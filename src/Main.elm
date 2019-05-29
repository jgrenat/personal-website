module Main exposing (main)

import Browser exposing (Document, UrlRequest)
import Browser.Navigation as Navigation
import Element exposing (Element, behindContent, centerX, centerY, column, el, fill, fillPortion, height, image, layout, maximum, minimum, modular, none, paddingXY, paragraph, row, spacing, text, textColumn, width)
import Element.Background as Background
import Element.Border exposing (shadow)
import Element.Font as Font exposing (center)
import Json.Decode exposing (Value)
import Platform exposing (Program)
import Theme
import Url exposing (Url)


type alias Model =
    { navigationKey : Navigation.Key }


type Msg
    = OnUrlRequest UrlRequest
    | OnUrlChange Url


main : Program Value Model Msg
main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = always Sub.none
        , onUrlRequest = OnUrlRequest
        , onUrlChange = OnUrlChange
        }


init : Value -> Url -> Navigation.Key -> ( Model, Cmd Msg )
init _ _ key =
    ( Model key, Cmd.none )


view : model -> Document Msg
view model =
    { title = "Jordane Grenat"
    , body =
        [ layout [ Font.family Theme.standardFonts ] <|
            el
                [ Background.gradient
                    { angle = 2.5
                    , steps =
                        [ Theme.primaryColor
                        , Theme.secondaryColor
                        ]
                    }
                , width fill
                , height fill
                ]
            <|
                el
                    [ centerX
                    , centerY
                    , width (maximum 1000 fill)
                    , Background.color Theme.primaryBackgroundColor
                    , shadow { offset = ( 0, 1 ), size = 1, blur = 5, color = Theme.shadowColor }
                    ]
                <|
                    row [ width fill ]
                        [ picturePart, biographyPart ]
        ]
    }


picturePart : Element Msg
picturePart =
    el
        [ height (minimum 200 fill)
        , width (minimum 200 fill)
        ]
    <|
        image
            [ width fill
            , height fill
            ]
            { src = "../images/profile.jpeg", description = "Portrait of Jordane Grenat" }


biographyPart : Element Msg
biographyPart =
    el
        [ height fill
        , paddingXY 20 20
        ]
    <|
        textColumn
            [ spacing (Theme.spaceScale 4)
            , centerY
            ]
            [ el [ Font.size (Theme.textScale 6), Font.family Theme.titleFonts, center, width fill ] (text "Jordane Grenat")
            , paragraph [] [ text "Jordane is a developer at Viseo and loves discoveries and everything that seems unusual, which is often in conflict with the pragmatism required for clients' projects." ]
            , paragraph [] [ text "He then satisfies his passion with never-finished personal projects and by going to conferences to meet other novelty lovers. For example: Elm, F#, new-JS-hyped-framework, ..." ]
            , paragraph [] [ text "He spends the rest of his spare time declining cookies on the websites he visits." ]
            ]


update : msg -> model -> ( model, Cmd Msg )
update msg model =
    ( model, Cmd.none )

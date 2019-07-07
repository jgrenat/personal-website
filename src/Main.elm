module Main exposing (main)

import Browser exposing (Document, UrlRequest(..))
import Browser.Navigation as Navigation
import Element exposing (Element, centerX, centerY, clip, column, el, fill, fillPortion, focused, height, html, image, layout, link, maximum, minimum, mouseOver, paddingXY, paragraph, row, spacing, text, textColumn, width, wrappedRow)
import Element.Background as Background
import Element.Border as Border exposing (shadow)
import Element.Font as Font exposing (center, justify)
import Element.Region as Region
import Html exposing (Html)
import Json.Decode exposing (Value)
import Octicons
import Platform exposing (Program)
import Theme exposing (spaceScale)
import Time exposing (Posix)
import Url exposing (Url)


type alias Model =
    { navigationKey : Navigation.Key
    , page : Page
    }


type Page
    = Home
    | Talks


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
init _ url key =
    ( Model key (pageFromUrl url), Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        OnUrlRequest (External url) ->
            ( model, Navigation.load url )

        OnUrlRequest (Internal url) ->
            ( model, Navigation.pushUrl model.navigationKey (Url.toString url) )

        OnUrlChange url ->
            ( { model | page = pageFromUrl url }, Cmd.none )


pageFromUrl : Url -> Page
pageFromUrl url =
    case url.path of
        "/talks" ->
            Talks

        _ ->
            Home


view : Model -> Document Msg
view model =
    { title = "Jordane Grenat"
    , body =
        [ layout [ Font.family Theme.standardFonts ] <|
            el
                [ width fill, height fill ]
                (case model.page of
                    Home ->
                        homePage

                    Talks ->
                        talksPage
                )
        ]
    }


homePage : Element Msg
homePage =
    mainPanel <|
        wrappedRow [ width fill ]
            [ picturePart, biographyPart ]


talksPage : Element Msg
talksPage =
    wrappedRow [ spacing (Theme.spaceScale 2) ]
        (List.map viewTalk talks)


viewTalk : TalkData -> Element Msg
viewTalk talk =
    el [ paddingXY 5 5, width (fillPortion 1 |> minimum 250 |> maximum 400) ] <|
        mainPanel <|
            paragraph [] [ text <| "[" ++ typeToString talk.talkType ++ "] " ++ talk.title ]


type alias TalkData =
    { title : String
    , year : String
    , talkType : TalkType
    , imagePath : String
    , abstract : List String
    }


type TalkType
    = University
    | Workshop
    | Conference


typeToString : TalkType -> String
typeToString talkType =
    case talkType of
        University ->
            "University"

        Workshop ->
            "Workshop"

        Conference ->
            "Conference"


talks : List TalkData
talks =
    [ { title = "Highway to Elm!"
      , year = "2017"
      , talkType = Conference
      , imagePath = "unknown.jpg"
      , abstract = [ "Ahaha!" ]
      }
    , { title = "You still ship bugs in 2019? 😱"
      , year = "2019"
      , talkType = University
      , imagePath = "unknown.jpg"
      , abstract = [ "Ahaha!" ]
      }
    , { title = "Highway to Elm!"
      , year = "2019"
      , talkType = University
      , imagePath = "unknown.jpg"
      , abstract = [ "Ahaha!" ]
      }
    , { title = "Highway to Elm!"
      , year = "2018"
      , talkType = Workshop
      , imagePath = "unknown.jpg"
      , abstract = [ "Ahaha!" ]
      }
    ]


picturePart : Element Msg
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
            { src = "./images/profile.jpeg", description = "Portrait of Jordane Grenat" }


biographyPart : Element Msg
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
                [ iconLink "Twitter" "https://twitter.com/JoGrenat" (Octicons.markTwitter octiconOptions)
                , iconLink "Github" "https://github.com/jgrenat" (Octicons.markGithub octiconOptions)

                --                , iconLink "Talks" "/talks" (Octicons.comment octiconOptions)
                ]
            ]


iconLink : String -> String -> Html Msg -> Element Msg
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


mainPanel : Element Msg -> Element Msg
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

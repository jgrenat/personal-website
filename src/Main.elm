module Main exposing (main)

import Articles exposing (Article, Lang(..))
import Articles.WhatILoveInElm as WhatILoveInElm
import Browser exposing (Document, UrlRequest(..))
import Browser.Navigation as Navigation
import Element exposing (Element, centerX, centerY, clip, column, el, fill, fillPortion, focused, height, html, image, layout, link, maximum, minimum, mouseOver, none, onLeft, padding, paddingXY, paragraph, row, spacing, text, width, wrappedRow)
import Element.Background as Background
import Element.Border as Border exposing (shadow)
import Element.Font as Font exposing (center, justify)
import Element.Region as Region
import Html exposing (Html)
import Json.Decode exposing (Value)
import Json.Encode as Encode
import Octicons
import Platform exposing (Program)
import Ports exposing (highlightAll)
import Task
import Theme exposing (spaceScale)
import Time exposing (Posix)
import Url exposing (Url)
import Url.Parser as Parser exposing ((</>), Parser, string)


articles : List (Article msg)
articles =
    [ WhatILoveInElm.article ]


type AppModel
    = NotReady Navigation.Key Page
    | Ready Model


type alias Model =
    { navigationKey : Navigation.Key
    , zone : Time.Zone
    , page : Page
    }


type Page
    = HomePage
    | TalksPage
    | ArticlesListPage
    | ArticlePage (Article Msg)


type Msg
    = OnUrlRequest UrlRequest
    | OnUrlChange Url
    | TimeZoneRetrieved Time.Zone


main : Program Value AppModel Msg
main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = always Sub.none
        , onUrlRequest = OnUrlRequest
        , onUrlChange = OnUrlChange
        }


init : Value -> Url -> Navigation.Key -> ( AppModel, Cmd Msg )
init _ url key =
    let
        ( page, command ) =
            pageAndCommandFromUrl url
    in
    ( NotReady key page
    , Cmd.batch [ Time.here |> Task.perform TimeZoneRetrieved, command ]
    )


update : Msg -> AppModel -> ( AppModel, Cmd Msg )
update msg appModel =
    case ( appModel, msg ) of
        ( NotReady key page, TimeZoneRetrieved zone ) ->
            ( Ready (Model key zone page), Cmd.none )

        ( NotReady key page, _ ) ->
            ( NotReady key page, Cmd.none )

        ( Ready model, _ ) ->
            updateModel msg model |> Tuple.mapFirst Ready


updateModel : Msg -> Model -> ( Model, Cmd Msg )
updateModel msg model =
    case msg of
        OnUrlRequest (External url) ->
            ( model, Navigation.load url )

        OnUrlRequest (Internal url) ->
            ( model, Navigation.pushUrl model.navigationKey (Url.toString url) )

        OnUrlChange url ->
            let
                ( page, command ) =
                    pageAndCommandFromUrl url
            in
            ( { model | page = page }, command )

        TimeZoneRetrieved zone ->
            ( { model | zone = zone }, Cmd.none )


pageParser : Parser (( Page, Cmd Msg ) -> a) a
pageParser =
    Parser.oneOf
        [ Parser.map ( HomePage, Cmd.none ) Parser.top
        , Parser.map ( TalksPage, Cmd.none ) (Parser.s "talks")
        , Parser.map ( ArticlesListPage, Cmd.none ) (Parser.s "articles")
        , Parser.map articlePageFromSlug (Parser.s "articles" </> string)
        ]


articlePageFromSlug : String -> ( Page, Cmd Msg )
articlePageFromSlug slug =
    ( List.filter (.slug >> (==) slug) articles
        |> List.head
        |> Maybe.map ArticlePage
        |> Maybe.withDefault ArticlesListPage
    , highlightAll Encode.null
    )


pageAndCommandFromUrl : Url -> ( Page, Cmd Msg )
pageAndCommandFromUrl url =
    Parser.parse pageParser url
        |> Maybe.withDefault ( HomePage, Cmd.none )


view : AppModel -> Document Msg
view appModel =
    { title = "Jordane Grenat"
    , body =
        case appModel of
            NotReady _ _ ->
                [ Html.text "" ]

            Ready model ->
                [ layout [ Font.family Theme.standardFonts ] <|
                    el
                        [ width fill, height fill ]
                        (case model.page of
                            HomePage ->
                                homePage

                            TalksPage ->
                                talksPage

                            ArticlesListPage ->
                                articlesPage model.zone

                            ArticlePage article ->
                                articlePage model.zone article
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


articlesPage : Time.Zone -> Element Msg
articlesPage zone =
    mainPanel <|
        column [ width fill, spacing (spaceScale 3), padding (spaceScale 2), onLeft (backArrow "/" "Home") ]
            [ el [ Font.size (Theme.textScale 5), Font.family Theme.titleFonts ] (text "Articles")
            , column [ spacing (spaceScale 1) ] (List.map (viewArticleListItem zone) articles)
            ]


articlePage : Time.Zone -> Article Msg -> Element Msg
articlePage zone article =
    el [ center, width fill, paddingXY 0 (spaceScale 4) ] <|
        opaquePanel <|
            column [ width fill, spacing (spaceScale 4), padding (spaceScale 2), justify, onLeft (backArrow "/articles" "List") ]
                [ el [ Font.size (Theme.textScale 5), Font.family Theme.titleFonts ]
                    (row [ spacing (spaceScale 2), center ]
                        [ text article.title
                        , el [ Font.size (Theme.textScale 2), Font.color Theme.secondaryColor ] (text <| getStringDate zone article.publicationDate)
                        ]
                    )
                , article.content
                ]


backArrow : String -> String -> Element msg
backArrow url label =
    el [ paddingXY (spaceScale 4) (spaceScale 2) ] (link [] { url = url, label = row [] [ html <| Octicons.arrowLeft octiconOptions, text label ] })


viewTalk : TalkData -> Element Msg
viewTalk talk =
    el [ paddingXY 5 5, width (fillPortion 1 |> minimum 250 |> maximum 400) ] <|
        mainPanel <|
            paragraph [] [ text <| "[" ++ typeToString talk.talkType ++ "] " ++ talk.title ]


viewArticleListItem : Time.Zone -> Article msg -> Element Msg
viewArticleListItem zone article =
    link
        [ paddingXY (spaceScale 2) (spaceScale 3)
        , Border.color Theme.secondaryColor
        , Border.solid
        , Border.width 1
        , Border.rounded 5
        , mouseOver [ Background.color Theme.activeLinkColor ]
        ]
        { url = "/articles/" ++ article.slug
        , label = el [ center ] (text <| getFlag article.lang ++ " " ++ article.title ++ " " ++ getStringDate zone article.publicationDate)
        }


getFlag : Lang -> String
getFlag lang =
    case lang of
        Fr ->
            "🇫🇷"

        En ->
            "🇬🇧"


getStringDate : Time.Zone -> Posix -> String
getStringDate zone posix =
    let
        day =
            String.padLeft 2 '0' <| String.fromInt (Time.toDay zone posix)

        month =
            case Time.toMonth zone posix of
                Time.Jan ->
                    "01"

                Time.Feb ->
                    "02"

                Time.Mar ->
                    "03"

                Time.Apr ->
                    "04"

                Time.May ->
                    "05"

                Time.Jun ->
                    "06"

                Time.Jul ->
                    "07"

                Time.Aug ->
                    "08"

                Time.Sep ->
                    "09"

                Time.Oct ->
                    "10"

                Time.Nov ->
                    "11"

                Time.Dec ->
                    "12"

        year =
            String.fromInt (Time.toYear zone posix)
    in
    "(" ++ day ++ "/" ++ month ++ "/" ++ year ++ ")"


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
                [ if
                    List.isEmpty
                        articles
                  then
                    none

                  else
                    iconLink "Articles" "/articles" (Octicons.file octiconOptions)
                , iconLink "Twitter" "https://twitter.com/JoGrenat" (Octicons.markTwitter octiconOptions)
                , iconLink "Github" "https://github.com/jgrenat" (Octicons.markGithub octiconOptions)
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


opaquePanel : Element Msg -> Element Msg
opaquePanel element =
    el
        [ centerX
        , centerY
        , width (maximum 1000 fill)
        , Background.color Theme.opaquePanelBackgroundColor
        , shadow { offset = ( 0, 1 ), size = 1, blur = 5, color = Theme.shadowColor }
        ]
        element


octiconOptions =
    Octicons.defaultOptions |> Octicons.width 50 |> Octicons.height 50 |> Octicons.margin "auto"

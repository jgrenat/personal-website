module Shared exposing (Data, Model, Msg(..), SharedMsg(..), template)

import Browser.Navigation
import Css exposing (margin2, paddingBottom, paddingTop, rem, right, textAlign, zero)
import Css.Global as Global exposing (Snippet, global)
import DataSource
import Datocms.Enum.ImgixParamsFit exposing (ImgixParamsFit(..))
import Datocms.InputObject exposing (ImgixParams, buildImgixParams)
import Datocms.Object exposing (Site(..), WebsiteConfigurationRecord)
import Datocms.Object.FileField as FileField
import Datocms.Object.GlobalSeoField as GlobalSeoField
import Datocms.Object.SeoField as SeoField
import Datocms.Object.Site as Site
import Datocms.Object.WebsiteConfigurationRecord as WebsiteConfigurationRecord
import Datocms.Query as Query
import Datocms.Scalar exposing (FloatType(..), IntType(..))
import Graphql.Operation exposing (RootQuery)
import Graphql.OptionalArgument exposing (OptionalArgument(..))
import Graphql.SelectionSet as SelectionSet exposing (SelectionSet)
import GraphqlRequest as YoutubeRequest exposing (staticGraphqlRequest)
import Html exposing (Html)
import Html.Styled exposing (div, footer, fromUnstyled, main_, text, toUnstyled)
import Html.Styled.Attributes exposing (class)
import Markdown.Block as Markdown
import Markdown.Parser as Markdown
import Markdown.Renderer as Markdown
import Pages.Flags
import Pages.PageUrl exposing (PageUrl)
import Path exposing (Path)
import Route exposing (Route)
import SharedTemplate exposing (SharedTemplate)
import View exposing (View, userContentStyles)
import YoutubeRequest exposing (Video)


template : SharedTemplate Msg Model Data msg
template =
    { init = init
    , update = update
    , view = view
    , data = data
    , subscriptions = subscriptions
    , onPageChange = Just OnPageChange
    }


type Msg
    = OnPageChange
        { path : Path
        , query : Maybe String
        , fragment : Maybe String
        }
    | SharedMsg SharedMsg


type alias ConfigurationData =
    { websiteName : String
    , youtubeChannelId : String
    , twitterIconLink : String
    , footerContent : List Markdown.Block
    }


type alias Data =
    { websiteName : String
    , youtubeChannelId : String
    , lastYoutubeVideos : List Video
    , twitterIconLink : String
    , sitePreviewUrl : String
    , footerContent : List Markdown.Block
    }


type SharedMsg
    = NoOp


type Locale
    = French
    | English


type alias Model =
    { locale : Locale
    }


init :
    Maybe Browser.Navigation.Key
    -> Pages.Flags.Flags
    ->
        Maybe
            { path :
                { path : Path
                , query : Maybe String
                , fragment : Maybe String
                }
            , metadata : route
            , pageUrl : Maybe PageUrl
            }
    -> ( Model, Cmd Msg )
init navigationKey flags maybePagePath =
    ( { locale = French }
    , Cmd.none
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        OnPageChange _ ->
            ( model, Cmd.none )

        SharedMsg _ ->
            ( model, Cmd.none )


subscriptions : Path -> Model -> Sub Msg
subscriptions _ _ =
    Sub.none


data : DataSource.DataSource Data
data =
    DataSource.map2
        (\( { websiteName, youtubeChannelId, twitterIconLink, footerContent }, sitePreviewUrl ) lastYoutubeVideos ->
            Data websiteName youtubeChannelId lastYoutubeVideos twitterIconLink sitePreviewUrl footerContent
        )
        (SelectionSet.map2 Tuple.pair
            (Query.websiteConfiguration identity configurationSelection
                |> SelectionSet.nonNullOrFail
            )
            siteImageQuery
            |> staticGraphqlRequest
        )
        YoutubeRequest.getLastVideos


siteImageQuery : SelectionSet String RootQuery
siteImageQuery =
    FileField.url (\params -> { params | imgixParams = Present siteImageImgixParams })
        |> SeoField.image
        |> SelectionSet.nonNullOrFail
        |> GlobalSeoField.fallbackSeo
        |> SelectionSet.nonNullOrFail
        |> Site.globalSeo identity
        |> SelectionSet.nonNullOrFail
        |> Query.site_ identity


siteImageImgixParams : ImgixParams
siteImageImgixParams =
    buildImgixParams
        (\params ->
            { params
                | maxW = Present (IntType "300")
                , maxH = Present (IntType "150")
                , fit = Present Fill
            }
        )


configurationSelection : SelectionSet ConfigurationData WebsiteConfigurationRecord
configurationSelection =
    SelectionSet.map4 ConfigurationData
        (WebsiteConfigurationRecord.name |> SelectionSet.nonNullOrFail)
        (WebsiteConfigurationRecord.youtubeChannelId |> SelectionSet.nonNullOrFail)
        (WebsiteConfigurationRecord.twitterIcon (FileField.url identity) |> SelectionSet.nonNullOrFail)
        (WebsiteConfigurationRecord.footerText identity
            |> SelectionSet.nonNullOrFail
            |> SelectionSet.mapOrFail
                (\footerContent ->
                    Markdown.parse footerContent
                        |> Result.mapError (\_ -> "Unable to parse footer content markdown")
                )
        )


view :
    Data
    ->
        { path : Path
        , route : Maybe Route
        }
    -> Model
    -> (Msg -> msg)
    -> View msg
    -> { body : Html msg, title : String }
view sharedData page model toMsg pageView =
    { body =
        div []
            [ global styles
            , main_ [ class "container" ] pageView.body
            , footer [ class "container" ]
                [ div [ class "footerContent" ]
                    [ Markdown.render Markdown.defaultHtmlRenderer sharedData.footerContent
                        |> Result.map (Html.div [])
                        |> Result.map fromUnstyled
                        |> Result.withDefault (text "")
                    ]
                ]
            ]
            |> toUnstyled
    , title = pageView.title
    }


styles : List Snippet
styles =
    [ Global.class "footer"
        [ paddingTop zero
        , paddingBottom zero
        ]
    , Global.class "footerContent"
        ([ Global.descendants
            [ Global.p [ textAlign right ]
            ]
         , margin2 (rem 1) zero
         ]
            ++ userContentStyles
        )
    ]

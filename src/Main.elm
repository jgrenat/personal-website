module Main exposing (main)

import Article
import Color
import Css exposing (height, pct)
import Date
import Head
import Head.Seo as Seo
import Home
import Html as Unstyled
import Html.Styled exposing (Html, div, fromUnstyled, toUnstyled)
import Html.Styled.Attributes exposing (css)
import Index
import Markdown exposing (defaultOptions)
import Metadata exposing (Metadata)
import Pages exposing (images, pages)
import Pages.Document
import Pages.Manifest as Manifest
import Pages.Manifest.Category
import Pages.PagePath exposing (PagePath)
import Pages.Platform exposing (Page)
import Pages.StaticHttp
import Stylesheet exposing (stylesheet)


manifest : Manifest.Config Pages.PathKey
manifest =
    { backgroundColor = Just Color.white
    , categories = [ Pages.Manifest.Category.education ]
    , displayMode = Manifest.Standalone
    , orientation = Manifest.Portrait
    , description = "Jordane Grenat | Personal Website"
    , iarcRatingId = Nothing
    , name = "Jordane Grenat | Personal Website"
    , themeColor = Just Color.white
    , startUrl = pages.index
    , shortName = Just "Jordane Grenat"
    , sourceIcon = images.favicon
    }


main =
    Pages.Platform.application
        { init = always init
        , view = view
        , update = update
        , subscriptions = subscriptions
        , documents = [ markdownDocument ]
        , manifest = manifest
        , canonicalSiteUrl = canonicalSiteUrl
        , onPageChange = always ()
        , internals = Pages.internals
        , generateFiles = always []
        }


markdownToHtml : String -> Html msg
markdownToHtml markdown =
    Markdown.toHtmlWith { defaultOptions | sanitize = False, githubFlavored = Just { tables = True, breaks = True } } [] markdown
        |> fromUnstyled


markdownDocument : ( String, Pages.Document.DocumentHandler Metadata (Html Msg) )
markdownDocument =
    Pages.Document.parser
        { extension = "md"
        , metadata = Metadata.decoder
        , body =
            \markdownBody ->
                markdownToHtml markdownBody
                    |> List.singleton
                    |> div []
                    |> Ok
        }


type alias Model =
    {}


init : ( Model, Cmd Msg )
init =
    ( Model, Cmd.none )


type alias Msg =
    ()


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        () ->
            ( model, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none


view :
    List ( PagePath Pages.PathKey, Metadata )
    -> { frontmatter : Metadata, path : PagePath Pages.PathKey }
    ->
        Pages.StaticHttp.Request
            { head : List (Head.Tag Pages.PathKey)
            , view : Model -> Html Msg -> { title : String, body : Unstyled.Html Msg }
            }
view siteMetadata page =
    Pages.StaticHttp.succeed
        { head = head page.frontmatter
        , view =
            \_ viewForPage ->
                let
                    { title, body } =
                        pageView siteMetadata page viewForPage
                in
                { title = title
                , body =
                    div [ css [ height (pct 100) ] ] [ stylesheet, body ]
                        |> toUnstyled
                }
        }


pageView : List ( PagePath Pages.PathKey, Metadata ) -> { frontmatter : Metadata, path : PagePath Pages.PathKey } -> Html Msg -> { title : String, body : Html Msg }
pageView siteMetadata page viewForPage =
    case page.frontmatter of
        Metadata.Home metadata ->
            { title = metadata.title
            , body = Home.view
            }

        Metadata.Page metadata ->
            { title = metadata.title
            , body = viewForPage
            }

        Metadata.Article metadata ->
            { title = metadata.title
            , body = Article.view metadata viewForPage
            }

        Metadata.BlogIndex ->
            { title = "Blog | Jordane Grenat"
            , body = Index.view siteMetadata
            }


siteName : String
siteName =
    "Jordane Grenat | Personal Website"


{-| <https://developer.twitter.com/en/docs/tweets/optimize-with-cards/overview/abouts-cards>
<https://htmlhead.dev>
<https://html.spec.whatwg.org/multipage/semantics.html#standard-metadata-names>
<https://ogp.me/>
-}
head : Metadata -> List (Head.Tag Pages.PathKey)
head metadata =
    case metadata of
        Metadata.Page meta ->
            Seo.summaryLarge
                { canonicalUrlOverride = Nothing
                , siteName = siteName
                , image =
                    { url = images.favicon
                    , alt = "logo"
                    , dimensions = Nothing
                    , mimeType = Nothing
                    }
                , description = siteTagline
                , locale = Nothing
                , title = meta.title
                }
                |> Seo.website

        Metadata.Article meta ->
            Seo.summaryLarge
                { canonicalUrlOverride = Nothing
                , siteName = siteName
                , image =
                    { url = meta.image
                    , alt = meta.description
                    , dimensions = Nothing
                    , mimeType = Nothing
                    }
                , description = meta.description
                , locale = Nothing
                , title = meta.title
                }
                |> Seo.article
                    { tags = []
                    , section = Nothing
                    , publishedTime = Just (Date.toIsoString meta.published)
                    , modifiedTime = Nothing
                    , expirationTime = Nothing
                    }

        Metadata.BlogIndex ->
            Seo.summaryLarge
                { canonicalUrlOverride = Nothing
                , siteName = siteName
                , image =
                    { url = images.previewHomePage
                    , alt = "Jordane Grenat – Personal website"
                    , dimensions = Nothing
                    , mimeType = Nothing
                    }
                , description = siteTagline
                , locale = Nothing
                , title = "Blog | Jordane Grenat"
                }
                |> Seo.website

        Metadata.Home meta ->
            Seo.summaryLarge
                { canonicalUrlOverride = Nothing
                , siteName = siteName
                , image =
                    { url = images.favicon
                    , alt = "logo"
                    , dimensions = Nothing
                    , mimeType = Nothing
                    }
                , description = siteTagline
                , locale = Nothing
                , title = meta.title
                }
                |> Seo.website


canonicalSiteUrl : String
canonicalSiteUrl =
    "https://www.grenat.eu/"


siteTagline : String
siteTagline =
    "Personal website of Jordane Grenat, web developer and software craftsman"

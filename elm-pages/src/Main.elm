module Main exposing (main)

import Color
import Data.Author as Author
import Date
import Element exposing (Element, html)
import Element.Background
import Element.Border
import Element.Font as Font
import Element.Region
import Head
import Head.Seo as Seo
import Home
import Html exposing (Html)
import Index
import Markdown exposing (defaultOptions)
import Metadata exposing (Metadata)
import Pages exposing (images, pages)
import Pages.Document
import Pages.ImagePath as ImagePath exposing (ImagePath)
import Pages.Manifest as Manifest
import Pages.Manifest.Category
import Pages.PagePath exposing (PagePath)
import Pages.Platform exposing (Page)
import Palette
import Theme


manifest : Manifest.Config Pages.PathKey
manifest =
    { backgroundColor = Just Color.white
    , categories = [ Pages.Manifest.Category.education ]
    , displayMode = Manifest.Standalone
    , orientation = Manifest.Portrait
    , description = "Jordane Grenat | Personal Website"
    , iarcRatingId = Nothing
    , name = "jordane-grenat-website"
    , themeColor = Just Color.white
    , startUrl = pages.index
    , shortName = Just "jordane-grenat-website"
    , sourceIcon = images.favicon
    }


type alias Rendered =
    Element Msg



-- the intellij-elm plugin doesn't support type aliases for Programs so we need to use this line
-- main : Platform.Program Pages.Platform.Flags (Pages.Platform.Model Model Msg Metadata Rendered) (Pages.Platform.Msg Msg Metadata Rendered)


main : Pages.Platform.Program Model Msg Metadata Rendered
main =
    Pages.application
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        , documents = [ markdownDocument ]
        , head = head
        , manifest = manifest
        , canonicalSiteUrl = canonicalSiteUrl
        }


markdownToHtml : String -> Html msg
markdownToHtml =
    Markdown.toHtmlWith { defaultOptions | sanitize = False, githubFlavored = Just { tables = True, breaks = True } } []


markdownDocument : ( String, Pages.Document.DocumentHandler Metadata Rendered )
markdownDocument =
    Pages.Document.parser
        { extension = "md"
        , metadata = Metadata.decoder
        , body =
            \markdownBody ->
                markdownToHtml markdownBody
                    |> Element.html
                    |> List.singleton
                    |> Element.paragraph [ Element.width Element.fill ]
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


view : Model -> List ( PagePath Pages.PathKey, Metadata ) -> Page Metadata Rendered Pages.PathKey -> { title : String, body : Html Msg }
view model siteMetadata page =
    let
        { title, body } =
            pageView model siteMetadata page
    in
    { title = title
    , body =
        body
            |> Element.layout
                [ Element.width Element.fill
                , Element.height Element.fill
                , Font.size 20
                , Font.family [ Font.typeface "Roboto" ]
                , Font.color (Element.rgba255 0 0 0 0.8)
                ]
    }


pageView : Model -> List ( PagePath Pages.PathKey, Metadata ) -> Page Metadata Rendered Pages.PathKey -> { title : String, body : Element Msg }
pageView model siteMetadata page =
    case page.metadata of
        Metadata.Home metadata ->
            { title = metadata.title
            , body = html Home.view
            }

        Metadata.Page metadata ->
            { title = metadata.title
            , body =
                [ Element.column
                    [ Element.padding 50
                    , Element.spacing 60
                    , Element.Region.mainContent
                    ]
                    [ page.view
                    ]
                ]
                    |> Element.textColumn
                        [ Element.width Element.fill
                        ]
            }

        Metadata.Article metadata ->
            { title = metadata.title
            , body =
                Element.column
                    [ Element.width Element.fill
                    , Element.paddingXY 0 20
                    ]
                    [ opaquePanel <|
                        Element.column
                            [ Element.paddingXY 20 50
                            , Element.spacing 40
                            , Element.Region.mainContent
                            , Element.width (Element.fill |> Element.maximum 800)
                            , Element.centerX
                            ]
                            (Element.link [] { url = "/blog", label = Element.text "< Other articles" }
                                :: Element.column [ Element.spacing 10 ]
                                    [ Element.row [ Element.spacing 10 ]
                                        [ Author.view [] metadata.author
                                        , Element.column [ Element.spacing 10, Element.width Element.fill ]
                                            [ Element.paragraph [ Font.bold, Font.size 24 ]
                                                [ Element.text metadata.author.name
                                                ]
                                            , Element.paragraph [ Font.size 16 ]
                                                [ Element.text metadata.author.bio ]
                                            ]
                                        ]
                                    ]
                                :: (publishedDateView metadata |> Element.el [ Font.size 16, Font.color (Element.rgba255 0 0 0 0.6) ])
                                :: Palette.blogHeading metadata.title
                                :: articleImageView metadata.image
                                :: [ page.view, Element.link [] { url = "/blog", label = Element.text "< Other articles" } ]
                            )
                    ]
            }

        Metadata.Author author ->
            { title = author.name
            , body =
                Element.column
                    [ Element.width Element.fill
                    ]
                    [ Element.column
                        [ Element.padding 30
                        , Element.spacing 20
                        , Element.Region.mainContent
                        , Element.width (Element.fill |> Element.maximum 800)
                        , Element.centerX
                        ]
                        [ Palette.blogHeading author.name
                        , Author.view [] author
                        , Element.paragraph [ Element.centerX, Font.center ] [ page.view ]
                        ]
                    ]
            }

        Metadata.BlogIndex ->
            { title = "Blog | Jordane Grenat"
            , body =
                Element.column [ Element.width Element.fill, Element.padding 20, Element.centerX ]
                    [ Index.view siteMetadata ]
            }


articleImageView : ImagePath Pages.PathKey -> Element msg
articleImageView articleImage =
    Element.image [ Element.width Element.fill ]
        { src = ImagePath.toString articleImage
        , description = "Article cover photo"
        }


opaquePanel : Element Msg -> Element Msg
opaquePanel element =
    Element.el
        [ Element.centerX
        , Element.centerY
        , Element.width (Element.maximum 1000 Element.fill)
        , Element.Background.color Theme.opaquePanelBackgroundColor
        , Element.Border.shadow { offset = ( 0, 1 ), size = 1, blur = 5, color = Theme.shadowColor }
        ]
        element


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

        Metadata.Author meta ->
            let
                ( firstName, lastName ) =
                    case meta.name |> String.split " " of
                        [ first, last ] ->
                            ( first, last )

                        [ first, middle, last ] ->
                            ( first ++ " " ++ middle, last )

                        [] ->
                            ( "", "" )

                        _ ->
                            ( meta.name, "" )
            in
            Seo.summary
                { canonicalUrlOverride = Nothing
                , siteName = siteName
                , image =
                    { url = meta.avatar
                    , alt = meta.name ++ "'s articles."
                    , dimensions = Nothing
                    , mimeType = Nothing
                    }
                , description = meta.bio
                , locale = Nothing
                , title = meta.name ++ "'s articles."
                }
                |> Seo.profile
                    { firstName = firstName
                    , lastName = lastName
                    , username = Nothing
                    }

        Metadata.BlogIndex ->
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
    "Personal website of Jordane Grenat, developer and software craftsman"


publishedDateView metadata =
    Element.text
        (metadata.published
            |> Date.format "MMMM ddd, yyyy"
        )

module Page.Index exposing (Data, Model, Msg, page)

import Css exposing (alignItems, block, center, color, content, display, displayFlex, flex, float, fontSize, height, inlineBlock, int, justify, justifyContent, lineHeight, marginBottom, marginLeft, marginRight, marginTop, maxWidth, none, num, opacity, paddingBottom, pct, position, property, px, relative, rem, rgb, scale, spaceBetween, textAlign, textDecoration, transform, width, zero)
import Css.Global as Global exposing (Snippet, global)
import Css.Transitions as Transition exposing (transition)
import CssHelper exposing (onMobile)
import DataSource exposing (DataSource)
import Datocms.Enum.ArticleModelOrderBy exposing (ArticleModelOrderBy(..))
import Datocms.Enum.ImgixParamsFit exposing (ImgixParamsFit(..))
import Datocms.InputObject exposing (buildImgixParams)
import Datocms.Object exposing (ArticleRecord, FileField, HomePageRecord, Site)
import Datocms.Object.ArticleRecord as ArticleRecord
import Datocms.Object.FileField as FileField
import Datocms.Object.GlobalSeoField as GlobalSeoField
import Datocms.Object.HomePageRecord as HomePageRecord
import Datocms.Object.Site as Site
import Datocms.Query as Query exposing (AllArticlesOptionalArguments)
import Datocms.Scalar exposing (FloatType(..))
import Datocms.ScalarCodecs exposing (DateTime)
import Graphql.OptionalArgument exposing (OptionalArgument(..))
import Graphql.SelectionSet as SelectionSet exposing (SelectionSet)
import GraphqlRequest exposing (staticGraphqlRequest)
import Head
import Head.Seo as Seo
import Html.Styled exposing (Html, a, aside, div, h1, h2, img, li, p, text, ul)
import Html.Styled.Attributes exposing (alt, class, href, src, target)
import HtmlHelper exposing (link)
import Page exposing (Page, StaticPayload)
import Pages.PageUrl exposing (PageUrl)
import Pages.Url
import Route exposing (Route(..))
import Shared
import View exposing (View)
import YoutubeRequest exposing (Video)


type alias Model =
    ()


type alias Msg =
    Never


type alias RouteParams =
    {}


page : Page RouteParams Data
page =
    Page.single
        { head = head
        , data = data
        }
        |> Page.buildNoState { view = view }


data : DataSource Data
data =
    SelectionSet.map3
        (\{ title, picture, introduction, lastArticlesTitle, lastVideosTitle } content data_ ->
            Data title picture introduction lastArticlesTitle lastVideosTitle content
        )
        (Query.homePage identity homePageSelection
            |> SelectionSet.nonNullOrFail
        )
        (Query.allArticles
            (\options -> { options | orderBy = Present [ Just FirstPublishedAt_DESC_ ] })
            articleRoutesSelection
        )
        data2
        |> staticGraphqlRequest


articleRoutesSelection : SelectionSet ArticleLink ArticleRecord
articleRoutesSelection =
    SelectionSet.map4 ArticleLink
        (ArticleRecord.name identity |> SelectionSet.nonNullOrFail)
        (ArticleRecord.slug identity |> SelectionSet.nonNullOrFail)
        (ArticleRecord.firstPublishedAt_ |> SelectionSet.nonNullOrFail)
        (ArticleRecord.description identity |> SelectionSet.nonNullOrFail)


homePageSelection : SelectionSet { title : String, picture : Picture, introduction : String, lastArticlesTitle : String, lastVideosTitle : String } HomePageRecord
homePageSelection =
    SelectionSet.map5
        (\title picture introduction lastArticlesTitle lastVideosTitle ->
            { title = title
            , picture = picture
            , introduction = introduction
            , lastArticlesTitle = lastArticlesTitle
            , lastVideosTitle = lastVideosTitle
            }
        )
        (HomePageRecord.title identity |> SelectionSet.nonNullOrFail)
        (HomePageRecord.picture pictureSelection |> SelectionSet.nonNullOrFail)
        (HomePageRecord.introductionText identity |> SelectionSet.nonNullOrFail)
        (HomePageRecord.lastArticlesTitle identity |> SelectionSet.nonNullOrFail)
        (HomePageRecord.lastVideosTitle identity |> SelectionSet.nonNullOrFail)


data2 =
    Query.site_ identity siteSelection


siteSelection : SelectionSet String Site
siteSelection =
    Site.globalSeo identity (GlobalSeoField.siteName |> SelectionSet.nonNullOrFail) |> SelectionSet.nonNullOrFail


type alias Picture =
    { url : String }


pictureSelection : SelectionSet Picture FileField
pictureSelection =
    SelectionSet.map Picture
        (FileField.url
            (\params -> { params | imgixParams = Present imgixParams })
        )


imgixParams : Datocms.InputObject.ImgixParams
imgixParams =
    buildImgixParams
        (\params ->
            { params
                | w = Present (FloatType "80")
                , h = Present (FloatType "80")
                , mask = Present "ellipse"
                , fit = Present Crop
            }
        )


head :
    StaticPayload Data RouteParams
    -> List Head.Tag
head static =
    Seo.summary
        { canonicalUrlOverride = Nothing
        , siteName = static.sharedData.websiteName
        , image =
            { url = Pages.Url.external static.sharedData.sitePreviewUrl
            , alt = static.sharedData.websiteName
            , dimensions = Nothing
            , mimeType = Nothing
            }
        , description = static.data.introduction
        , locale = Nothing
        , title = static.sharedData.websiteName
        }
        |> Seo.website


type alias ArticleLink =
    { name : String, slug : String, publishDate : DateTime, description : String }


type alias Data =
    { name : String
    , picture : Picture
    , introduction : String
    , lastArticlesTitle : String
    , lastVideosTitle : String
    , articles : List ArticleLink
    }


view :
    Maybe PageUrl
    -> Shared.Model
    -> StaticPayload Data RouteParams
    -> View Msg
view maybeUrl sharedModel static =
    { title = static.sharedData.websiteName
    , body =
        [ global styles
        , div [ class "site-title" ]
            [ h1 [] [ link Index [] [ text static.data.name ] ]
            , a [ href "https://twitter.com/JoGrenat" ]
                [ img [ src static.sharedData.twitterIconLink ] []
                ]
            ]
        , aside [ class "author-card" ]
            [ img [ class "author-picture", src static.data.picture.url ] []
            , p [ class "author-description" ] [ text static.data.introduction ]
            ]
        , h2 [ class "section-title" ] [ text static.data.lastVideosTitle ]
        , ul [ class "last-videos" ]
            (List.map viewVideo static.sharedData.lastYoutubeVideos)
        , h2 [ class "section-title" ] [ text static.data.lastArticlesTitle ]
        , List.map viewArticleLink static.data.articles |> ul []
        ]
    }


viewArticleLink : ArticleLink -> Html msg
viewArticleLink articleLink =
    li [ class "article-item" ]
        [ h2 [] [ link (Blog__Slug_ { slug = articleLink.slug }) [ class "article-link" ] [ text articleLink.name ] ]
        , div [ class "article-description" ] [ text articleLink.description ]
        ]


viewVideo : Video -> Html msg
viewVideo video =
    li [ class "video" ]
        [ a [ href ("https://www.youtube.com/watch/?v=" ++ video.code), target "_blank" ]
            [ img [ src video.url, alt "" ] []
            , p [] [ text video.title ]
            ]
        ]


styles : List Snippet
styles =
    [ Global.main_
        [ position relative
        ]
    , Global.class "site-title"
        [ displayFlex
        , justifyContent spaceBetween
        , alignItems center
        , fontSize (rem 2.5)
        , Global.descendants
            [ Global.a [ textDecoration none ]
            , Global.img
                [ width (rem 2)
                , transition [ Transition.transform 100 ]
                , Css.hover
                    [ transform (scale 1.5)
                    ]
                ]
            , Global.h1
                [ transition [ Transition.transform 100 ]
                , Css.property "transform-origin" "center left"
                , Css.hover
                    [ transform (scale 1.05)
                    ]
                ]
            ]
        ]
    , Global.class "section-title"
        [ fontSize (rem 2)
        , marginTop (rem 3)
        , marginBottom (rem 0.5)
        ]
    , Global.class "author-card"
        [ displayFlex
        , alignItems center
        , marginTop (rem 2.5)
        , Global.children
            [ Global.class "author-picture"
                [ marginRight (rem 1)
                ]
            , Global.class "author-description"
                [ textAlign justify
                , fontSize (rem 1)
                , lineHeight (rem 1.5)
                ]
            ]
        ]
    , Global.class "article-item"
        [ Css.margin2 (rem 3) zero
        , Global.descendants
            [ Global.class "article-link"
                [ fontSize (rem 1.5)
                , color (rgb 40 161 78)
                , paddingBottom (rem 0.5)
                , display block
                , Css.visited
                    [ opacity (num 0.9)
                    ]
                ]
            , Global.class "article-description"
                [ lineHeight (rem 1.7)
                , textAlign justify
                ]
            ]
        ]
    , Global.class "last-videos"
        [ displayFlex
        , marginTop (rem 2)
        , Global.descendants
            [ Global.class "video"
                [ textAlign center
                , flex (int 1)
                , fontSize (rem 1)
                , Global.adjacentSiblings
                    [ Global.class "video"
                        [ marginLeft (rem 1)
                        ]
                    ]
                , onMobile
                    [ Css.lastChild
                        [ display none
                        ]
                    ]
                , Global.descendants
                    [ Global.a
                        [ display block
                        , transition [ Transition.transform 100 ]
                        , Css.hover [ transform (scale 1.1) ]
                        ]
                    ]
                ]
            , Global.img
                [ transition [ Transition.transform 100 ]
                , maxWidth (pct 100)
                , height (px 100)
                , marginBottom (rem 0.5)
                ]
            ]
        ]
    ]

module Page.Blog.Slug_ exposing (Data, Model, Msg, page)

import Article exposing (Article, Content)
import Css exposing (absolute, alignItems, auto, backgroundColor, borderLeft, borderLeft3, borderTop3, center, color, disc, displayFlex, em, fontSize, fontStyle, fontWeight, height, int, italic, justify, justifyContent, left, lineHeight, listStyleType, margin, margin2, margin3, marginBottom, marginLeft, marginTop, maxWidth, none, overflowY, padding2, paddingLeft, paddingTop, pct, position, preWrap, px, relative, rem, rgb, rgba, right, scale, scroll, solid, spaceBetween, textAlign, textDecoration, top, transform, underline, vh, vw, whiteSpace, width, zero)
import Css.Global as Global exposing (Snippet, global)
import Css.Transitions as Transition exposing (transition)
import CssHelper exposing (onMobile)
import DataSource exposing (DataSource)
import Datocms.Enum.ImgixParamsFit exposing (ImgixParamsFit(..))
import Datocms.Enum.SiteLocale as SiteLocale
import Datocms.InputObject exposing (ArticleModelFilter, buildArticleModelFilter, buildImgixParams, buildSlugFilter)
import Datocms.Object exposing (ArticleModelContentField, ArticleRecord)
import Datocms.Object.ArticleModelContentField as ArticleModelContentField
import Datocms.Object.ArticleRecord as ArticleRecord
import Datocms.Object.FileField as FileField
import Datocms.Query as Query
import Datocms.Scalar exposing (IntType(..))
import Graphql.OptionalArgument exposing (OptionalArgument(..))
import Graphql.SelectionSet as SelectionSet exposing (SelectionSet)
import GraphqlRequest exposing (staticGraphqlRequest)
import Head
import Head.Seo as Seo
import Html.Styled exposing (a, div, h1, img, section, text)
import Html.Styled.Attributes exposing (class, href, src)
import HtmlHelper exposing (link)
import Page exposing (Page, StaticPayload)
import Pages.PageUrl exposing (PageUrl)
import Pages.Url
import Route exposing (Route(..))
import Shared
import StructuredText exposing (structuredText)
import View exposing (View)


type alias Model =
    ()


type alias Msg =
    Never


type alias RouteParams =
    { slug : String }


page : Page RouteParams Data
page =
    Page.prerender
        { head = head
        , routes = routes
        , data = data
        }
        |> Page.buildNoState { view = view }


articleRoutesSelection : SelectionSet String ArticleRecord
articleRoutesSelection =
    ArticleRecord.slug (\params -> { params | locale = Present SiteLocale.Fr })
        |> SelectionSet.nonNullOrFail


routes : DataSource (List RouteParams)
routes =
    Query.allArticles identity articleRoutesSelection
        |> staticGraphqlRequest
        |> DataSource.map (List.map RouteParams)


data : RouteParams -> DataSource Article
data routeParams =
    Query.article (\args -> { args | filter = Present (articleFilters routeParams.slug) })
        articleSelection
        |> SelectionSet.nonNullOrFail
        |> staticGraphqlRequest


articleFilters : String -> ArticleModelFilter
articleFilters slug =
    buildArticleModelFilter
        (\params ->
            { params
                | slug = Present (buildSlugFilter (\slugFilter -> { slugFilter | eq = Present slug }))
            }
        )


articleSelection : SelectionSet Article ArticleRecord
articleSelection =
    SelectionSet.map3 Article
        (ArticleRecord.name (\args -> { args | locale = Present SiteLocale.Fr }) |> SelectionSet.nonNullOrFail)
        (ArticleRecord.banner bannerSelection
            |> SelectionSet.nonNullOrFail
        )
        (ArticleRecord.content
            (\args ->
                { args | locale = Present SiteLocale.Fr }
            )
            contentSelection
            |> SelectionSet.nonNullOrFail
        )


bannerSelection : SelectionSet Article.Banner Datocms.Object.FileField
bannerSelection =
    SelectionSet.map Article.Banner (FileField.url (\params -> { params | imgixParams = Present imgixParams }))


imgixParams : Datocms.InputObject.ImgixParams
imgixParams =
    buildImgixParams
        (\params ->
            { params
                | maxW = Present (IntType "800")
                , maxH = Present (IntType "200")
                , fit = Present Fill
            }
        )


contentSelection : SelectionSet Content ArticleModelContentField
contentSelection =
    SelectionSet.map (\value -> Content value []) ArticleModelContentField.value


head :
    StaticPayload Data RouteParams
    -> List Head.Tag
head static =
    Seo.summary
        { canonicalUrlOverride = Nothing
        , siteName = static.sharedData.websiteName
        , image =
            { url = Pages.Url.external "TODO"
            , alt = "elm-pages logo"
            , dimensions = Nothing
            , mimeType = Nothing
            }
        , description = "TODO"
        , locale = Nothing
        , title = "TODO title" -- metadata.title -- TODO
        }
        |> Seo.website


type alias Data =
    Article


view :
    Maybe PageUrl
    -> Shared.Model
    -> StaticPayload Data RouteParams
    -> View Msg
view maybeUrl sharedModel static =
    { title = static.data.name ++ " - " ++ static.sharedData.websiteName
    , body =
        [ global styles
        , div [ class "site-title" ]
            [ link Index [ class "site-name" ] [ text static.sharedData.websiteName ]
            , a [ href "https://twitter.com/JoGrenat" ]
                [ img [ src static.sharedData.twitterIconLink ] []
                ]
            ]
        , section [ class "article" ]
            [ h1 [ class "article-title" ] [ text static.data.name ]
            , div [ class "article-banner" ] [ img [ src static.data.banner.src ] [] ]
            , structuredText [ class "article-content" ] static.data.content.content static.data.content.blocks
            ]
        ]
    }


styles : List Snippet
styles =
    [ Global.class "site-title"
        [ displayFlex
        , justifyContent spaceBetween
        , alignItems center
        , fontSize (rem 1.5)
        , margin3 (rem 0.5) zero (rem 2)
        , Global.descendants
            [ Global.a [ textDecoration none ]
            , Global.img
                [ width (rem 2)
                , transition [ Transition.transform 100 ]
                , Css.hover
                    [ transform (scale 1.5)
                    ]
                ]
            , Global.class "site-name"
                [ transition [ Transition.transform 100 ]
                , Css.property "transform-origin" "center left"
                , Css.hover
                    [ transform (scale 1.1)
                    ]
                ]
            ]
        ]
    , Global.class "article"
        [ marginTop (px 20)
        , Global.descendants
            [ Global.class "article-title"
                [ fontSize (rem 3)
                , textAlign center
                , marginBottom (rem 3)
                , fontWeight (int 900)
                ]
            , Global.class "article-banner"
                [ width (pct 100)
                , paddingTop (pct (200 / 800 * 100))
                , position relative
                , Global.descendants
                    [ Global.img
                        [ position absolute, top zero, left zero, width (pct 100), height (pct 100) ]
                    ]
                ]
            , Global.class "article-banner-legend"
                [ fontSize (rem 0.9)
                , color (rgba 0 0 0 0.7)
                , textAlign center
                , Global.children
                    [ Global.a
                        [ textDecoration underline
                        , Css.hover [ color (rgb 0 0 0) ]
                        ]
                    ]
                ]
            , Global.class "article-content"
                [ marginBottom (vh 5)
                , Global.descendants
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
                        , margin auto
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
            ]
        ]
    ]

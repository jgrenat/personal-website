module Index exposing (view)

import Css exposing (absolute, alignItems, backgroundColor, block, borderRadius, bottom, center, color, display, displayFlex, fontSize, hex, justifyContent, left, marginBottom, marginRight, marginTop, padding, pct, position, px, relative, rem, rgba, right, textAlign, textDecoration, top, underline, vh, vw, width)
import Css.Global as Css exposing (Snippet, global)
import Data.Author as Author exposing (jordane)
import Date
import Html.Styled exposing (Html, a, div, fromUnstyled, h1, h2, main_, p, text, time)
import Html.Styled.Attributes exposing (class, classList, datetime, href)
import Metadata exposing (Metadata)
import Octicons
import Pages
import Pages.PagePath as PagePath exposing (PagePath)


view : List ( PagePath Pages.PathKey, Metadata ) -> Html msg
view articles =
    main_ [ class "blog" ]
        [ global [ styles ]
        , backLink BackLinkTop
        , h1 [ class "blog-title" ] [ Author.view [ class "author-portrait" ] jordane, text "Blog" ]
        , getPublishedArticles articles
            |> List.sortWith (\( _, metadata1 ) ( _, metadata2 ) -> Date.compare metadata2.published metadata1.published)
            |> List.map viewArticleSummary
            |> div [ class "articlesList" ]
        , backLink BackLinkBottom
        ]


octiconOptions =
    Octicons.defaultOptions |> Octicons.width 30 |> Octicons.height 30


type BackLinkType
    = BackLinkTop
    | BackLinkBottom


backLink : BackLinkType -> Html msg
backLink type_ =
    a
        [ class "backLink"
        , classList [ ( "backLink--top", type_ == BackLinkTop ), ( "backLink--bottom", type_ == BackLinkBottom ) ]
        , href "/"
        ]
        [ Octicons.arrowLeft octiconOptions |> fromUnstyled
        , text "Home"
        ]


getPublishedArticles : List ( PagePath Pages.PathKey, Metadata ) -> List ( PagePath Pages.PathKey, Metadata.ArticleMetadata )
getPublishedArticles posts =
    List.filterMap
        (\( path, metadata ) ->
            case metadata of
                Metadata.Home _ ->
                    Nothing

                Metadata.Page _ ->
                    Nothing

                Metadata.Article meta ->
                    if meta.draft then
                        Nothing

                    else
                        Just ( path, meta )

                Metadata.BlogIndex ->
                    Nothing
        )
        posts


viewArticleSummary : ( PagePath Pages.PathKey, Metadata.ArticleMetadata ) -> Html msg
viewArticleSummary ( articlePath, article ) =
    a [ href (PagePath.toString articlePath), class "article opaquePanel" ]
        [ h2 [ class "article-title" ] [ text article.title ]
        , time [ class "article-publicationDate", datetime (Date.toIsoString article.published) ]
            [ text (article.published |> Date.format "MMMM ddd, yyyy")
            ]
        , p [] [ text article.description ]
        , div [ class "article-fakeLink" ] [ text "Continue reading >>" ]
        ]


styles : Snippet
styles =
    Css.class "blog"
        [ marginTop (px 20)
        , position relative
        , Css.descendants
            [ Css.class "backLink"
                [ displayFlex
                , alignItems center
                , position absolute
                , left (vw 2)
                , padding (px 5)
                , Css.hover
                    [ backgroundColor (hex "64b4fa")
                    ]
                , Css.withClass "backLink--top"
                    [ top (vh 1.5)
                    ]
                , Css.withClass "backLink--bottom"
                    [ bottom (vh 1.5)
                    ]
                ]
            , Css.class "blog-title"
                [ displayFlex
                , alignItems center
                , justifyContent center
                ]
            , Css.class "author-portrait"
                [ width (rem 3)
                , borderRadius (pct 50)
                , marginRight (vw 1)
                ]
            , Css.class "article"
                [ Css.hover
                    [ backgroundColor (rgba 240 240 250 0.7)
                    , Css.descendants
                        [ Css.class "article-fakeLink"
                            [ textDecoration underline ]
                        ]
                    ]
                ]
            , Css.class "article-publicationDate"
                [ display block
                , fontSize (rem 0.95)
                , color (rgba 0 0 0 0.8)
                , textAlign center
                , marginBottom (vh 5)
                ]
            , Css.class "article-fakeLink"
                [ marginTop (vh 4)
                , textAlign right
                ]
            ]
        ]

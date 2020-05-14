module Article exposing (..)

import Css exposing (alignItems, backgroundColor, block, borderLeft3, borderRadius, calc, center, color, disc, display, displayFlex, em, flexEnd, flexGrow, flexWrap, fontSize, fontStyle, fontWeight, hex, inlineFlex, int, italic, justify, justifyContent, left, lineHeight, listStyleType, margin2, margin3, margin4, marginBottom, marginLeft, marginRight, marginTop, padding, padding2, paddingLeft, pct, plus, preWrap, px, rem, rgb, rgba, right, solid, spaceBetween, textAlign, vh, vw, whiteSpace, width, wrap, zero)
import Css.Global as Css exposing (Snippet, global)
import Data.Author as Author exposing (Author)
import Date
import Html.Styled exposing (Html, a, aside, div, fromUnstyled, h1, h2, img, p, text, time)
import Html.Styled.Attributes exposing (alt, class, datetime, href, src)
import Metadata exposing (ArticleMetadata)
import Octicons
import Pages
import Pages.ImagePath as ImagePath exposing (ImagePath)


view : ArticleMetadata -> Html msg -> Html msg
view article articleView =
    div [ class "article" ]
        [ global [ styles ]
        , div [ class "opaquePanel" ]
            [ div [ class "article-header" ]
                [ backLink
                , authorCard article.author
                ]
            , h1 [ class "article-title" ] [ text article.title ]
            , publishedDateView article
            , articleImageView article.image
            , div [ class "markdown" ] [ articleView ]
            , backLink
            ]
        ]


authorCard : Author -> Html msg
authorCard author =
    aside [ class "authorCard" ]
        [ div []
            [ div [ class "authorCard-name" ] [ text author.name ]
            , p [ class "authorCard-biography" ] [ text author.bio ]
            ]
        , Author.view [ class "authorCard-picture" ] author
        ]


publishedDateView : ArticleMetadata -> Html msg
publishedDateView article =
    time [ class "article-publicationDate", datetime (Date.toIsoString article.published) ]
        [ text (article.published |> Date.format "MMMM ddd, yyyy")
        ]


articleImageView : ImagePath Pages.PathKey -> Html msg
articleImageView articleImage =
    img [ src (ImagePath.toString articleImage), alt "Article cover photo", class "article-coverPhoto" ] []


octiconOptions =
    Octicons.defaultOptions |> Octicons.width 30 |> Octicons.height 30


backLink : Html msg
backLink =
    a [ class "backLink", href "/blog" ]
        [ Octicons.arrowLeft octiconOptions |> fromUnstyled
        , text "Other articles"
        ]


styles : Snippet
styles =
    Css.class "article"
        [ marginTop (px 20)
        , Css.descendants
            [ Css.class "article-header"
                [ displayFlex
                , flexWrap wrap
                , justifyContent spaceBetween
                , alignItems center
                , marginBottom (vh 2)
                ]
            , Css.class "authorCard"
                [ displayFlex
                , alignItems center
                , flexGrow (int 1)
                , justifyContent flexEnd
                ]
            , Css.class "authorCard-name"
                [ textAlign right
                , fontSize (rem 1.5)
                , marginBottom (vh 1)
                ]
            , Css.class "authorCard-biography"
                [ textAlign right
                , fontSize (rem 1)
                , color (rgba 0 0 0 0.7)
                ]
            , Css.class "authorCard-picture"
                [ width (rem 5)
                , borderRadius (pct 50)
                , marginLeft (vw 0.9)
                ]
            , Css.class "backLink"
                [ display inlineFlex
                , alignItems center
                , padding (px 5)
                , Css.hover
                    [ backgroundColor (hex "64b4fa")
                    ]
                ]
            , Css.class "article-title"
                [ marginBottom (vh 2) ]
            , Css.class "article-publicationDate"
                [ display block
                , fontSize (rem 0.95)
                , color (rgba 0 0 0 0.8)
                , textAlign center
                , marginBottom (vh 3)
                ]
            , Css.class "article-coverPhoto"
                [ width (calc (pct 100) plus (vw 6))
                , margin3 zero (vw -3) (vh 2)
                ]
            , Css.class "markdown"
                [ marginBottom (vh 5)
                , Css.descendants
                    [ Css.h2
                        [ fontSize (rem 2.5)
                        , fontWeight (int 900)
                        , textAlign left
                        , margin3 (vh 4) zero (vh 2)
                        ]
                    , Css.h3
                        [ fontSize (rem 1.8)
                        , fontWeight (int 600)
                        , textAlign left
                        , margin3 (vh 3) zero (vh 1)
                        , color (rgba 0 0 0 0.8)
                        ]
                    , Css.p
                        [ margin2 (vh 2.5) zero
                        , lineHeight (rem 1.7)
                        , whiteSpace preWrap
                        , textAlign justify
                        , Css.children
                            [ Css.code
                                [ backgroundColor (rgba 225 225 255 0.7)
                                , padding2 (px 1) (px 3)
                                , fontSize (em 0.7)
                                ]
                            ]
                        ]
                    , Css.blockquote
                        [ borderLeft3 (px 5) solid (rgba 5 117 230 0.8)
                        , backgroundColor (rgba 5 117 230 0.1)
                        , padding2 (vh 0.01) (vw 1)
                        , marginLeft (vw 0.5)
                        , marginRight (vw 0.5)
                        ]
                    , Css.ul
                        [ listStyleType disc
                        , paddingLeft (rem 1)
                        , marginLeft (vh 2)
                        , Css.children
                            [ Css.li
                                [ Css.adjacentSiblings
                                    [ Css.li
                                        [ marginTop (vh 2)
                                        ]
                                    ]
                                ]
                            ]
                        ]
                    ]
                ]
            ]
        ]

module StructuredTextHelper exposing (ArticleLinkRaw, ImageContentRaw, ImageSize(..), StructuredTextBlock(..), structuredText)

import Html as Html2 exposing (a, div, img, span, text)
import Html.Attributes exposing (alt, href, src)
import Html.Styled as Html exposing (Attribute, Html, fromUnstyled, toUnstyled)
import HtmlHelper exposing (link)
import Route exposing (Route(..))
import StructuredText exposing (StructuredText)
import StructuredText.Html as Html


type StructuredTextBlock
    = ImageContent ImageContentRaw
    | ArticleLink ArticleLinkRaw


type alias ImageContentRaw =
    { url : String
    , alt : Maybe String
    , size : ImageSize
    }


type ImageSize
    = Normal
    | FullWidth


type alias ArticleLinkRaw =
    { name : String
    , slug : String
    }


structuredText : List (Attribute msg) -> StructuredText StructuredTextBlock -> Html msg
structuredText attributes structuredTextValue =
    Html.div attributes
        [ div []
            (Html.render
                { renderBlock =
                    \item ->
                        case item of
                            ImageContent content ->
                                img [ src content.url, alt (content.alt |> Maybe.withDefault "") ] []

                            _ ->
                                text ""
                , renderInlineItem =
                    \item ->
                        case item of
                            ArticleLink articleLink ->
                                link (Blog__Slug_ { slug = articleLink.slug }) [] [ Html.text articleLink.name ] |> toUnstyled

                            _ ->
                                text ""
                , renderItemLink =
                    \itemData children ->
                        case itemData.item of
                            ArticleLink articleLink ->
                                link (Blog__Slug_ { slug = articleLink.slug }) [] [ span [] children |> fromUnstyled ] |> toUnstyled

                            _ ->
                                span [] children
                }
                structuredTextValue
            )
            |> fromUnstyled
        ]

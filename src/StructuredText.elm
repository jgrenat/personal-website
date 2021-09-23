module StructuredText exposing (structuredText)

import Article exposing (ArticleBlock(..), ImageSize(..))
import Html.Styled as Html exposing (Attribute, Html)
import Html.Styled.Attributes as Html
import Json.Encode as Encode exposing (Value)
import ScalarCodecs exposing (StructuredTextField(..))


structuredText : List (Attribute msg) -> StructuredTextField -> List ArticleBlock -> Html msg
structuredText attributes (StructuredTextField structuredTextValue) blocks =
    let
        contentAttribute : Attribute msg
        contentAttribute =
            Encode.encode 0 structuredTextValue
                |> Html.attribute "content"

        blocksAttribute : Attribute msg
        blocksAttribute =
            encodeArticleBlocks blocks
                |> Encode.encode 0
                |> Html.attribute "blocks"
    in
    Html.node "structured-text" (contentAttribute :: blocksAttribute :: attributes) []


encodeArticleBlocks : List ArticleBlock -> Value
encodeArticleBlocks articleBlocks =
    Encode.list (\(ImageContent imageContentRaw) -> encodeImage imageContentRaw) articleBlocks


encodeImageSize : Article.ImageSize -> Value
encodeImageSize imageSize =
    case imageSize of
        Normal ->
            Encode.string "NORMAL"

        FullWidth ->
            Encode.string "FULL_WIDTH"


encodeImage : Article.ImageContentRaw -> Value
encodeImage imageContentRaw =
    Encode.object <|
        [ ( "id", Encode.string imageContentRaw.id )
        , ( "url", Encode.string imageContentRaw.url )
        , ( "alt", (Maybe.map Encode.string >> Maybe.withDefault Encode.null) imageContentRaw.alt )
        , ( "size", encodeImageSize imageContentRaw.size )
        ]

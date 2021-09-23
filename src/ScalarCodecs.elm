module ScalarCodecs exposing
    ( BooleanType
    , CustomData
    , DateTime
    , FloatType
    , IntType
    , ItemId
    , JsonField
    , MetaTagAttributes(..)
    , MetaTagAttributesContent
    , StructuredTextField(..)
    , UploadId
    , codecs
    )

import Datocms.Scalar exposing (defaultCodecs)
import Json.Decode as Decode exposing (Decoder, Value)
import Json.Encode as Encode


type alias BooleanType =
    Datocms.Scalar.BooleanType


type alias CustomData =
    Datocms.Scalar.CustomData


type alias DateTime =
    Datocms.Scalar.DateTime


type alias FloatType =
    Datocms.Scalar.FloatType


type alias IntType =
    Datocms.Scalar.IntType


type alias ItemId =
    Datocms.Scalar.ItemId


type alias JsonField =
    StructuredTextField


type StructuredTextField
    = StructuredTextField Value


type MetaTagAttributes
    = MetaTagAttributes MetaTagAttributesContent


type alias UploadId =
    Datocms.Scalar.UploadId


type alias MetaTagAttributesContent =
    { sizes : ( Int, Int )
    , type_ : String
    , rel : String
    , href : String
    }


codecs : Datocms.Scalar.Codecs BooleanType CustomData DateTime FloatType IntType ItemId JsonField MetaTagAttributes UploadId
codecs =
    Datocms.Scalar.defineCodecs
        { codecBooleanType = defaultCodecs.codecBooleanType
        , codecCustomData = defaultCodecs.codecCustomData
        , codecDateTime = defaultCodecs.codecDateTime
        , codecFloatType = defaultCodecs.codecFloatType
        , codecIntType = defaultCodecs.codecIntType
        , codecItemId = defaultCodecs.codecItemId
        , codecJsonField =
            { encoder = \(StructuredTextField rawValue) -> rawValue
            , decoder = Decode.value |> Decode.map StructuredTextField
            }
        , codecMetaTagAttributes =
            { encoder = encodeMetaTagAttributes
            , decoder = metaTagAttributesDecoder
            }
        , codecUploadId = defaultCodecs.codecUploadId
        }


encodeMetaTagAttributes : MetaTagAttributes -> Encode.Value
encodeMetaTagAttributes (MetaTagAttributes metaTagAttributesContent) =
    Encode.object <|
        [ ( "sizes", Encode.string ((Tuple.first metaTagAttributesContent.sizes |> String.fromInt) ++ "x" ++ (Tuple.second metaTagAttributesContent.sizes |> String.fromInt)) )
        , ( "type_", Encode.string metaTagAttributesContent.type_ )
        , ( "rel", Encode.string metaTagAttributesContent.rel )
        , ( "href", Encode.string metaTagAttributesContent.href )
        ]


metaTagAttributesDecoder : Decoder MetaTagAttributes
metaTagAttributesDecoder =
    Decode.map4 MetaTagAttributesContent
        (Decode.field "sizes" sizesDecoder)
        (Decode.field "type" Decode.string)
        (Decode.field "rel" Decode.string)
        (Decode.field "href" Decode.string)
        |> Decode.map MetaTagAttributes


sizesDecoder : Decoder ( Int, Int )
sizesDecoder =
    Decode.map2 Tuple.pair (Decode.index 0 Decode.int) (Decode.index 1 Decode.int)

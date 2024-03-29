-- Do not manually edit this file, it was auto-generated by dillonkearns/elm-graphql
-- https://github.com/dillonkearns/elm-graphql


module Datocms.Object.ResponsiveImage exposing (..)

import Datocms.InputObject
import Datocms.Interface
import Datocms.Object
import Datocms.Scalar
import Datocms.Union
import Graphql.Internal.Builder.Argument as Argument exposing (Argument)
import Graphql.Internal.Builder.Object as Object
import Graphql.Internal.Encode as Encode exposing (Value)
import Graphql.Operation exposing (RootMutation, RootQuery, RootSubscription)
import Graphql.OptionalArgument exposing (OptionalArgument(..))
import Graphql.SelectionSet exposing (SelectionSet)
import Json.Decode as Decode
import ScalarCodecs


alt : SelectionSet (Maybe String) Datocms.Object.ResponsiveImage
alt =
    Object.selectionForField "(Maybe String)" "alt" [] (Decode.string |> Decode.nullable)


aspectRatio : SelectionSet ScalarCodecs.FloatType Datocms.Object.ResponsiveImage
aspectRatio =
    Object.selectionForField "ScalarCodecs.FloatType" "aspectRatio" [] (ScalarCodecs.codecs |> Datocms.Scalar.unwrapCodecs |> .codecFloatType |> .decoder)


base64 : SelectionSet (Maybe String) Datocms.Object.ResponsiveImage
base64 =
    Object.selectionForField "(Maybe String)" "base64" [] (Decode.string |> Decode.nullable)


bgColor : SelectionSet (Maybe String) Datocms.Object.ResponsiveImage
bgColor =
    Object.selectionForField "(Maybe String)" "bgColor" [] (Decode.string |> Decode.nullable)


height : SelectionSet ScalarCodecs.IntType Datocms.Object.ResponsiveImage
height =
    Object.selectionForField "ScalarCodecs.IntType" "height" [] (ScalarCodecs.codecs |> Datocms.Scalar.unwrapCodecs |> .codecIntType |> .decoder)


sizes : SelectionSet String Datocms.Object.ResponsiveImage
sizes =
    Object.selectionForField "String" "sizes" [] Decode.string


src : SelectionSet String Datocms.Object.ResponsiveImage
src =
    Object.selectionForField "String" "src" [] Decode.string


srcSet : SelectionSet String Datocms.Object.ResponsiveImage
srcSet =
    Object.selectionForField "String" "srcSet" [] Decode.string


title : SelectionSet (Maybe String) Datocms.Object.ResponsiveImage
title =
    Object.selectionForField "(Maybe String)" "title" [] (Decode.string |> Decode.nullable)


webpSrcSet : SelectionSet String Datocms.Object.ResponsiveImage
webpSrcSet =
    Object.selectionForField "String" "webpSrcSet" [] Decode.string


width : SelectionSet ScalarCodecs.IntType Datocms.Object.ResponsiveImage
width =
    Object.selectionForField "ScalarCodecs.IntType" "width" [] (ScalarCodecs.codecs |> Datocms.Scalar.unwrapCodecs |> .codecIntType |> .decoder)

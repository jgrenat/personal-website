-- Do not manually edit this file, it was auto-generated by dillonkearns/elm-graphql
-- https://github.com/dillonkearns/elm-graphql


module Datocms.Object.WebsiteConfigurationRecord exposing (..)

import Datocms.Enum.ItemStatus
import Datocms.Enum.SiteLocale
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


type alias AllFooterTextLocalesOptionalArguments =
    { markdown : OptionalArgument Bool
    , locale : OptionalArgument Datocms.Enum.SiteLocale.SiteLocale
    }


{-|

  - markdown - Process content as markdown
  - locale - The locale to use to fetch the field's content

-}
allFooterTextLocales_ :
    (AllFooterTextLocalesOptionalArguments -> AllFooterTextLocalesOptionalArguments)
    -> SelectionSet decodesTo Datocms.Object.StringMultiLocaleField
    -> SelectionSet (Maybe (List (Maybe decodesTo))) Datocms.Object.WebsiteConfigurationRecord
allFooterTextLocales_ fillInOptionals____ object____ =
    let
        filledInOptionals____ =
            fillInOptionals____ { markdown = Absent, locale = Absent }

        optionalArgs____ =
            [ Argument.optional "markdown" filledInOptionals____.markdown Encode.bool, Argument.optional "locale" filledInOptionals____.locale (Encode.enum Datocms.Enum.SiteLocale.toString) ]
                |> List.filterMap Basics.identity
    in
    Object.selectionForCompositeField "_allFooterTextLocales" optionalArgs____ object____ (Basics.identity >> Decode.nullable >> Decode.list >> Decode.nullable)


createdAt_ : SelectionSet ScalarCodecs.DateTime Datocms.Object.WebsiteConfigurationRecord
createdAt_ =
    Object.selectionForField "ScalarCodecs.DateTime" "_createdAt" [] (ScalarCodecs.codecs |> Datocms.Scalar.unwrapCodecs |> .codecDateTime |> .decoder)


firstPublishedAt_ : SelectionSet (Maybe ScalarCodecs.DateTime) Datocms.Object.WebsiteConfigurationRecord
firstPublishedAt_ =
    Object.selectionForField "(Maybe ScalarCodecs.DateTime)" "_firstPublishedAt" [] (ScalarCodecs.codecs |> Datocms.Scalar.unwrapCodecs |> .codecDateTime |> .decoder |> Decode.nullable)


isValid_ : SelectionSet ScalarCodecs.BooleanType Datocms.Object.WebsiteConfigurationRecord
isValid_ =
    Object.selectionForField "ScalarCodecs.BooleanType" "_isValid" [] (ScalarCodecs.codecs |> Datocms.Scalar.unwrapCodecs |> .codecBooleanType |> .decoder)


modelApiKey_ : SelectionSet String Datocms.Object.WebsiteConfigurationRecord
modelApiKey_ =
    Object.selectionForField "String" "_modelApiKey" [] Decode.string


publicationScheduledAt_ : SelectionSet (Maybe ScalarCodecs.DateTime) Datocms.Object.WebsiteConfigurationRecord
publicationScheduledAt_ =
    Object.selectionForField "(Maybe ScalarCodecs.DateTime)" "_publicationScheduledAt" [] (ScalarCodecs.codecs |> Datocms.Scalar.unwrapCodecs |> .codecDateTime |> .decoder |> Decode.nullable)


publishedAt_ : SelectionSet (Maybe ScalarCodecs.DateTime) Datocms.Object.WebsiteConfigurationRecord
publishedAt_ =
    Object.selectionForField "(Maybe ScalarCodecs.DateTime)" "_publishedAt" [] (ScalarCodecs.codecs |> Datocms.Scalar.unwrapCodecs |> .codecDateTime |> .decoder |> Decode.nullable)


type alias SeoMetaTagsOptionalArguments =
    { locale : OptionalArgument Datocms.Enum.SiteLocale.SiteLocale }


{-| SEO meta tags

  - locale - The locale to use to fetch the field's content

-}
seoMetaTags_ :
    (SeoMetaTagsOptionalArguments -> SeoMetaTagsOptionalArguments)
    -> SelectionSet decodesTo Datocms.Object.Tag
    -> SelectionSet (List decodesTo) Datocms.Object.WebsiteConfigurationRecord
seoMetaTags_ fillInOptionals____ object____ =
    let
        filledInOptionals____ =
            fillInOptionals____ { locale = Absent }

        optionalArgs____ =
            [ Argument.optional "locale" filledInOptionals____.locale (Encode.enum Datocms.Enum.SiteLocale.toString) ]
                |> List.filterMap Basics.identity
    in
    Object.selectionForCompositeField "_seoMetaTags" optionalArgs____ object____ (Basics.identity >> Decode.list)


status_ : SelectionSet Datocms.Enum.ItemStatus.ItemStatus Datocms.Object.WebsiteConfigurationRecord
status_ =
    Object.selectionForField "Enum.ItemStatus.ItemStatus" "_status" [] Datocms.Enum.ItemStatus.decoder


unpublishingScheduledAt_ : SelectionSet (Maybe ScalarCodecs.DateTime) Datocms.Object.WebsiteConfigurationRecord
unpublishingScheduledAt_ =
    Object.selectionForField "(Maybe ScalarCodecs.DateTime)" "_unpublishingScheduledAt" [] (ScalarCodecs.codecs |> Datocms.Scalar.unwrapCodecs |> .codecDateTime |> .decoder |> Decode.nullable)


updatedAt_ : SelectionSet ScalarCodecs.DateTime Datocms.Object.WebsiteConfigurationRecord
updatedAt_ =
    Object.selectionForField "ScalarCodecs.DateTime" "_updatedAt" [] (ScalarCodecs.codecs |> Datocms.Scalar.unwrapCodecs |> .codecDateTime |> .decoder)


createdAt : SelectionSet ScalarCodecs.DateTime Datocms.Object.WebsiteConfigurationRecord
createdAt =
    Object.selectionForField "ScalarCodecs.DateTime" "createdAt" [] (ScalarCodecs.codecs |> Datocms.Scalar.unwrapCodecs |> .codecDateTime |> .decoder)


type alias FooterTextOptionalArguments =
    { markdown : OptionalArgument Bool
    , locale : OptionalArgument Datocms.Enum.SiteLocale.SiteLocale
    }


{-|

  - markdown - Process content as markdown
  - locale - The locale to use to fetch the field's content

-}
footerText :
    (FooterTextOptionalArguments -> FooterTextOptionalArguments)
    -> SelectionSet (Maybe String) Datocms.Object.WebsiteConfigurationRecord
footerText fillInOptionals____ =
    let
        filledInOptionals____ =
            fillInOptionals____ { markdown = Absent, locale = Absent }

        optionalArgs____ =
            [ Argument.optional "markdown" filledInOptionals____.markdown Encode.bool, Argument.optional "locale" filledInOptionals____.locale (Encode.enum Datocms.Enum.SiteLocale.toString) ]
                |> List.filterMap Basics.identity
    in
    Object.selectionForField "(Maybe String)" "footerText" optionalArgs____ (Decode.string |> Decode.nullable)


id : SelectionSet ScalarCodecs.ItemId Datocms.Object.WebsiteConfigurationRecord
id =
    Object.selectionForField "ScalarCodecs.ItemId" "id" [] (ScalarCodecs.codecs |> Datocms.Scalar.unwrapCodecs |> .codecItemId |> .decoder)


name : SelectionSet (Maybe String) Datocms.Object.WebsiteConfigurationRecord
name =
    Object.selectionForField "(Maybe String)" "name" [] (Decode.string |> Decode.nullable)


twitterIcon :
    SelectionSet decodesTo Datocms.Object.FileField
    -> SelectionSet (Maybe decodesTo) Datocms.Object.WebsiteConfigurationRecord
twitterIcon object____ =
    Object.selectionForCompositeField "twitterIcon" [] object____ (Basics.identity >> Decode.nullable)


updatedAt : SelectionSet ScalarCodecs.DateTime Datocms.Object.WebsiteConfigurationRecord
updatedAt =
    Object.selectionForField "ScalarCodecs.DateTime" "updatedAt" [] (ScalarCodecs.codecs |> Datocms.Scalar.unwrapCodecs |> .codecDateTime |> .decoder)


youtubeChannelId : SelectionSet (Maybe String) Datocms.Object.WebsiteConfigurationRecord
youtubeChannelId =
    Object.selectionForField "(Maybe String)" "youtubeChannelId" [] (Decode.string |> Decode.nullable)

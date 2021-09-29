module Site exposing (config)

import DataSource
import DataSource.Http
import Datocms.Object
import Datocms.Object.GlobalSeoField as GlobalSeoField
import Datocms.Object.Site as Site
import Datocms.Query as Query
import Graphql.SelectionSet as SelectionSet
import GraphqlRequest
import Head
import Json.Decode as Decode
import MimeType exposing (MimeImage, MimeType(..), parseMimeType)
import OptimizedDecoder
import Pages.Manifest as Manifest exposing (Icon)
import Pages.Url exposing (external)
import Route
import ScalarCodecs exposing (MetaTagAttributes(..), MetaTagAttributesContent)
import SiteConfig exposing (SiteConfig)


type alias Data =
    { siteName : String
    , description : String
    , twitterAccount : String
    , favicons : List MetaTagAttributes
    }


config : SiteConfig Data
config =
    { data = data
    , canonicalUrl = "https://www.grenat.eu"
    , manifest = manifest
    , head = head
    }


data : DataSource.DataSource Data
data =
    [ MetaTagAttributesContent ( 16, 16 ) "image/png" "icon" "https://www.datocms-assets.com/53557/1629202623-favicon.png?h=16&w=16"
    , MetaTagAttributesContent ( 32, 32 ) "image/png" "icon" "https://www.datocms-assets.com/53557/1629202623-favicon.png?h=32&w=32"
    , MetaTagAttributesContent ( 96, 96 ) "image/png" "icon" "https://www.datocms-assets.com/53557/1629202623-favicon.png?h=96&w=96"
    , MetaTagAttributesContent ( 192, 192 ) "image/png" "icon" "https://www.datocms-assets.com/53557/1629202623-favicon.png?h=192&w=192"
    ]
        |> List.map MetaTagAttributes
        |> Data "Le Blog de JoGrenat" "Développeur web passionné, sensible à la qualité du code. Je partage dans ce blog mes découvertes et mes réflexions." "@JoGrenat"
        |> DataSource.succeed



-- Query.site_ identity siteSelection
-- |> staticGraphqlRequest
--siteSelection : SelectionSet Data Site
--siteSelection =
--    SelectionSet.map (\siteName -> Data siteName [])
--        (Site.globalSeo identity (GlobalSeoField.siteName |> SelectionSet.nonNullOrFail) |> SelectionSet.nonNullOrFail)
--(Site.faviconMetaTags identity (Tag.attributes |> SelectionSet.nonNullOrFail))


head : Data -> List Head.Tag
head static =
    Head.sitemapLink "/sitemap.xml"
        :: List.filterMap toHeadIcon static.favicons


manifest : Data -> Manifest.Config
manifest static =
    Manifest.init
        { name = static.siteName
        , description = static.description
        , startUrl = Route.Index |> Route.toPath
        , icons = List.map toManifestIcon static.favicons
        }


toManifestIcon : MetaTagAttributes -> Icon
toManifestIcon (MetaTagAttributes metaTagAttributes) =
    { src = external metaTagAttributes.href
    , sizes = [ metaTagAttributes.sizes ]
    , mimeType = toMimeType metaTagAttributes.type_
    , purposes = []
    }


toHeadIcon : MetaTagAttributes -> Maybe Head.Tag
toHeadIcon (MetaTagAttributes metaTagAttributes) =
    toMimeType metaTagAttributes.type_
        |> Maybe.map
            (\mimeType ->
                Head.icon [ metaTagAttributes.sizes ] mimeType (external metaTagAttributes.href)
            )


toMimeType : String -> Maybe MimeImage
toMimeType mimeType =
    case parseMimeType mimeType of
        Just (Image imageMimeType) ->
            Just imageMimeType

        _ ->
            Nothing

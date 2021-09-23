module RssFeed exposing (build)

import Pages
import Rss


build :
    { siteUrl : String }
    ->
        List
            { path : String
            , frontmatter : String
            , body : String
            }
    ->
        { path : List String
        , content : String
        }
build config siteMetadata =
    { path = [ "rss.xml" ]
    , content =
        Rss.generate
            { title = "JoGrenat's Bazaar"
            , description = "Description"
            , url = "https://www.grenat.eu"
            , lastBuildTime = Pages.builtAt
            , generator = Just "elm-pages"
            , items = [] --siteMetadata |> List.filterMap metadataToRssItem
            , siteUrl = "https://www.grenat.eu"
            }
    }

port module Pages exposing (PathKey, allPages, allImages, application, images, isValidRoute, pages)

import Color exposing (Color)
import Head
import Html exposing (Html)
import Json.Decode
import Json.Encode
import Mark
import Pages.Platform
import Pages.ContentCache exposing (Page)
import Pages.Manifest exposing (DisplayMode, Orientation)
import Pages.Manifest.Category as Category exposing (Category)
import Url.Parser as Url exposing ((</>), s)
import Pages.Document as Document
import Pages.ImagePath as ImagePath exposing (ImagePath)
import Pages.PagePath as PagePath exposing (PagePath)
import Pages.Directory as Directory exposing (Directory)


type PathKey
    = PathKey


buildImage : List String -> ImagePath PathKey
buildImage path =
    ImagePath.build PathKey ("images" :: path)



buildPage : List String -> PagePath PathKey
buildPage path =
    PagePath.build PathKey path


directoryWithIndex : List String -> Directory PathKey Directory.WithIndex
directoryWithIndex path =
    Directory.withIndex PathKey allPages path


directoryWithoutIndex : List String -> Directory PathKey Directory.WithoutIndex
directoryWithoutIndex path =
    Directory.withoutIndex PathKey allPages path


port toJsPort : Json.Encode.Value -> Cmd msg


application :
    { init : ( userModel, Cmd userMsg )
    , update : userMsg -> userModel -> ( userModel, Cmd userMsg )
    , subscriptions : userModel -> Sub userMsg
    , view : userModel -> List ( PagePath PathKey, metadata ) -> Page metadata view PathKey -> { title : String, body : Html userMsg }
    , head : metadata -> List (Head.Tag PathKey)
    , documents : List ( String, Document.DocumentHandler metadata view )
    , manifest : Pages.Manifest.Config PathKey
    , canonicalSiteUrl : String
    }
    -> Pages.Platform.Program userModel userMsg metadata view
application config =
    Pages.Platform.application
        { init = config.init
        , view = config.view
        , update = config.update
        , subscriptions = config.subscriptions
        , document = Document.fromList config.documents
        , content = content
        , toJsPort = toJsPort
        , head = config.head
        , manifest = config.manifest
        , canonicalSiteUrl = config.canonicalSiteUrl
        , pathKey = PathKey
        }



allPages : List (PagePath PathKey)
allPages =
    [ (buildPage [ "blog", "ce-que-jaime-en-elm" ])
    , (buildPage [ "blog" ])
    , (buildPage [  ])
    ]

pages =
    { blog =
        { ceQueJaimeEnElm = (buildPage [ "blog", "ce-que-jaime-en-elm" ])
        , index = (buildPage [ "blog" ])
        , directory = directoryWithIndex ["blog"]
        }
    , index = (buildPage [  ])
    , directory = directoryWithIndex []
    }

images =
    { articleCovers =
        { elmTree = (buildImage [ "article-covers", "elm-tree.jpg" ])
        , directory = directoryWithoutIndex ["articleCovers"]
        }
    , author =
        { jordane = (buildImage [ "author", "jordane.jpeg" ])
        , directory = directoryWithoutIndex ["author"]
        }
    , elmLogo = (buildImage [ "elm-logo.svg" ])
    , favicon = (buildImage [ "favicon.png" ])
    , github = (buildImage [ "github.svg" ])
    , iconPng = (buildImage [ "icon-png.png" ])
    , icon = (buildImage [ "icon.svg" ])
    , noredinkJsElmErrors = (buildImage [ "noredink-js-elm-errors.png" ])
    , directory = directoryWithoutIndex []
    }

allImages : List (ImagePath PathKey)
allImages =
    [(buildImage [ "article-covers", "elm-tree.jpg" ])
    , (buildImage [ "author", "jordane.jpeg" ])
    , (buildImage [ "elm-logo.svg" ])
    , (buildImage [ "favicon.png" ])
    , (buildImage [ "github.svg" ])
    , (buildImage [ "icon-png.png" ])
    , (buildImage [ "icon.svg" ])
    , (buildImage [ "noredink-js-elm-errors.png" ])
    ]


isValidRoute : String -> Result String ()
isValidRoute route =
    let
        validRoutes =
            List.map PagePath.toString allPages
    in
    if
        (route |> String.startsWith "http://")
            || (route |> String.startsWith "https://")
            || (route |> String.startsWith "#")
            || (validRoutes |> List.member route)
    then
        Ok ()

    else
        ("Valid routes:\n"
            ++ String.join "\n\n" validRoutes
        )
            |> Err


content : List ( List String, { extension: String, frontMatter : String, body : Maybe String } )
content =
    [ 
  ( ["blog", "ce-que-jaime-en-elm"]
    , { frontMatter = """{"type":"blog","author":"Jordane Grenat","title":"Ce que j'aime en Elm","description":"Elm est un langage de programmation front-end compilant en JavaScript permettant de réaliser des interfaces et des applications web. Dans cet article, j'expose les forces qui rendent ce langage addictif et surtout très productif.","image":"/images/article-covers/elm-tree.jpg","published":"2019-09-26"}
""" , body = Nothing
    , extension = "md"
    } )
  ,
  ( ["blog"]
    , { frontMatter = """{"title":"Articles | Jordane Grenat","type":"blog-index"}
""" , body = Nothing
    , extension = "md"
    } )
  ,
  ( []
    , { frontMatter = """{"title":"Jordane Grenat","type":"home"}
""" , body = Nothing
    , extension = "md"
    } )
  
    ]

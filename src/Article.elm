module Article exposing (Article, ArticleBlock(..), Banner, Content, ImageContentRaw, ImageSize(..))

import ScalarCodecs exposing (StructuredTextField)


type alias Article =
    { name : String, banner : Banner, content : Content }


type alias Content =
    { content : StructuredTextField
    , blocks : List ArticleBlock
    }


type alias Banner =
    { src : String }


type ArticleBlock
    = ImageContent ImageContentRaw


type alias ImageContentRaw =
    { id : String
    , url : String
    , alt : Maybe String
    , size : ImageSize
    }


type ImageSize
    = Normal
    | FullWidth

module Article exposing (Article, Attribution, Banner)

import StructuredText exposing (StructuredText)
import StructuredTextHelper exposing (StructuredTextBlock)


type alias Article =
    { name : String
    , banner : Banner
    , content : StructuredText StructuredTextBlock
    , description : String
    , bannerAttribution : Maybe Attribution
    }


type alias Attribution =
    { author : String
    , licenseName : Maybe String
    , licenseLink : Maybe String
    }


type alias Banner =
    { src : String }

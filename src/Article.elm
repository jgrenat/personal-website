module Article exposing (Article, Banner)

import StructuredText exposing (StructuredText)
import StructuredTextHelper exposing (StructuredTextBlock)


type alias Article =
    { name : String, banner : Banner, content : StructuredText StructuredTextBlock }


type alias Banner =
    { src : String }

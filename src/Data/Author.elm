module Data.Author exposing (Author, all, decoder, jordane, view)

import Html.Styled exposing (Attribute, Html, img)
import Html.Styled.Attributes exposing (alt, src)
import Json.Decode as Decode exposing (Decoder)
import List.Extra
import Pages
import Pages.ImagePath as ImagePath exposing (ImagePath)


type alias Author =
    { name : String
    , avatar : ImagePath Pages.PathKey
    , bio : String
    }


jordane : Author
jordane =
    { name = "Jordane Grenat"
    , avatar = Pages.images.author.jordane
    , bio = "Web developer and software craftsman"
    }


all : List Author
all =
    [ { name = "Jordane Grenat"
      , avatar = Pages.images.author.jordane
      , bio = "Web developer and software craftsman"
      }
    ]


decoder : Decoder Author
decoder =
    Decode.string
        |> Decode.andThen
            (\lookupName ->
                case List.Extra.find (\currentAuthor -> currentAuthor.name == lookupName) all of
                    Just author ->
                        Decode.succeed author

                    Nothing ->
                        Decode.fail ("Couldn't find author with name " ++ lookupName ++ ". Options are " ++ String.join ", " (List.map .name all))
            )


view : List (Attribute msg) -> Author -> Html msg
view attributes author =
    img ([ src (ImagePath.toString author.avatar), alt author.name ] ++ attributes) []

module HtmlHelper exposing (link)

import Html.Styled exposing (Attribute, Html, a)
import Html.Styled.Attributes exposing (attribute, href)
import Path
import Route exposing (Route)


link : Route -> List (Attribute msg) -> List (Html msg) -> Html msg
link route attributes children =
    let
        routeString : String
        routeString =
            Route.toPath route |> Path.toAbsolute
    in
    a
        ([ href routeString, attribute "elm-pages:prefetch" "" ] ++ attributes)
        children

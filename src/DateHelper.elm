module DateHelper exposing (toHtml)

import Html.Styled exposing (Attribute, Html, text, time)
import Html.Styled.Attributes exposing (datetime)
import Iso8601
import Time
import Time.Format
import Time.Format.Config.Config_en_us exposing (config)


toHtml : List (Attribute msg) -> Time.Zone -> Time.Posix -> Html msg
toHtml attributes zone posix =
    time (datetime (Iso8601.fromTime posix) :: attributes)
        [ Time.Format.format config "%d.%m.%Y at %-I:%M %p" zone posix
            |> text
        ]

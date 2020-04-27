module Analytics exposing (Event(..), trackEvent)

import Ports


type Event
    = PageView


trackEvent : Event -> Cmd msg
trackEvent event =
    case event of
        PageView ->
            Ports.trackEvent "pageView"

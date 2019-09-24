port module Ports exposing (highlightAll)

import Json.Encode exposing (Value)


port highlightAll : Value -> Cmd msg

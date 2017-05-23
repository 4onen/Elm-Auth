import Html exposing (..)

import App exposing (Model, Msg)


main : Program Never Model Msg
main =
    Html.program
        { init = App.init
        , view = App.view
        , update = App.update
        , subscriptions = always Sub.none
        }

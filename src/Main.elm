import Browser

import App exposing (Model, Msg)


main : Program () Model Msg
main =
    Browser.element
        { init = App.init
        , view = App.view
        , update = App.update
        , subscriptions = always Sub.none
        }

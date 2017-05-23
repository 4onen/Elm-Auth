module RequiresLogin exposing (Model, Msg(..), update, view)


import Html exposing (Html, text, div, hr, h3)


type alias Jwt = String


type alias Model = ()


type Msg
    = NoOp


update : Jwt -> Msg -> Model -> (Model, Cmd Msg)
update token msg model =
    case msg of
        NoOp ->
            model ! []


view : Jwt -> Model -> Html Msg
view token model =
    div
        []
        [ h3 [] [ text "This is the login required view!" ]
        , hr [] []
        , h3 [] [ text <| "This is the token: " ++ token ]
        ]

module Login exposing (Model, Msg(..), init, update, view, encode)

{-| I made this a single page module to make it simpler to see all the code here.
   Remember that this pattern is only when a module will inevitably affect global state.
-}

import Html exposing (Html, div, label, input, text)
import Html.Attributes exposing (type_)
import Html.Events as Events
import Json.Encode exposing (Value, object, string)


type alias Model =
    { username : String
    , password : String
    }


type Msg
    = Username String
    | Password String


init : Model
init =
    { username = ""
    , password = ""
    }



-- Please note that I never use the tuple (Model, Cmd Msg), I prefer using a different abstraction.


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Username s ->
            ({ model | username = s },Cmd.none)

        Password s ->
            ({ model | password = s },Cmd.none)


view : Model -> Html Msg
view model =
    div
        []
        [ label [] [ text "Username" ]
        , input [ Events.onInput Username, type_ "text" ] []
        , label [] [ text "Password" ]
        , input [ Events.onInput Password, type_ "password" ] []
        ]


encode : Model -> Value
encode model =
    object
        [ ( "username", string model.username )
        , ( "password", string model.password )
        ]

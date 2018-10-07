module App exposing (Model, Msg(..), init, update, view)

import Task
import Json.Decode as Json
import Html.Events as Events
import Html exposing (Html, text, div, form, h3, button)
import Html.Attributes exposing (type_)
import Login
import RequiresLogin


{- Normally place this in a shared global folder or use a module specific to JWTs, type aliases are also a
   very bad idea when it comes to ideas like JWTs, there's no way to denote the difference between a string
   and the token, so you generally want to use the newtype pattern in Elm which is:
   type Jwt = Jwt String
   getJwt : Jwt -> String
   getJwt (Jwt s) = s

-}


type alias Jwt =
    String



{- Instead of placing the JWT as a field of the login or sometimes Auth model, we place it in the parent, in this case, globally.
   I prefer abstracting this further into routes so that we don't keep the Login/Registration information after logging in.

   Any questions about how this is done, let me know by opening an issue.
-}


type alias Model =
    { jwt : Maybe Jwt
    , login : Login.Model
    , error : String
    , loginRequiredModel : RequiresLogin.Model
    }



{-
   Now I personally don't like cluttering my toplevel messages too much, this is for the sake of speed here, the pattern gets
   a bit more abstract when you add in routes, I'll show something like that later if desired.
-}


type Msg
    = LoginMsg Login.Msg
    | RequiresLoginMsg RequiresLogin.Msg
    | SubmitLogin
    | LoginResponse (Result String String)


init : () -> ( Model, Cmd Msg )
init () =
    ({ jwt = Nothing
    , login = Login.init
    , error = ""
    , loginRequiredModel = ()
    }, Cmd.none)



{- Keep in mind that I hate the tuple type update function here, I generally abstract it pretty heavily with
   a map both function, and leave the Cmd.batch command to the main module
-}


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        LoginMsg msg_ ->
            Login.update msg_ model.login
                |> Tuple.mapFirst (\x -> { model | login = x })
                |> Tuple.mapSecond (Cmd.map LoginMsg)

        {- This is also a whole lot more verbose than necessary
           We could easily abstract this away, but for now I just want
           to show what's going on.
        -}
        RequiresLoginMsg msg_ ->
            case model.jwt of
                Just token ->
                    RequiresLogin.update token msg_ model.loginRequiredModel
                        |> Tuple.mapFirst
                            (\x -> { model | loginRequiredModel = x })
                        |> Tuple.mapSecond (Cmd.map RequiresLoginMsg)

                Nothing ->
                    ({ model | error = "You are not logged in!" }, Cmd.none)

        SubmitLogin ->
            (model, submitLogin model.login)

        LoginResponse result ->
            case result of
                Ok jwt ->
                    ({ model | jwt = Just jwt },Cmd.none)

                Err e ->
                    ({ model | error = e },Cmd.none)



{- This view also doesn't reflect best practices, generally we want to add a selector pattern as things get more complex,
   but for our purposes this is perfect. Also keep in mind, in an SPA we have urls, the view should reflect the current route.
-}


view : Model -> Html Msg
view model =
    case model.jwt of
        Just token ->
            RequiresLogin.view token model.loginRequiredModel
                |> Html.map RequiresLoginMsg

        _ ->
            form
                [ Events.onSubmit SubmitLogin ]
                [ text model.error
                , Html.map LoginMsg <| Login.view model.login
                , button [ type_ "submit" ] [ text "Submit" ]
                ]



{- This would be code you'd use to actually talk to a server
   import HttpBuilder exposing (..)
   import Http exposing (expectJson)


   submitLogin : Login.Model -> Cmd Msg
   submitLogin loginModel =
       HttpBuilder.post "/login"
           |> withJsonBody (Login.encode loginModel)
           |> withExpect (expectJson Json.string)
           |> send LoginResponse
-}


submitLogin : Login.Model -> Cmd Msg
submitLogin { username, password } =
    Task.attempt LoginResponse <|
        if username == "test" && password == "password" then
            Task.succeed "This is a JWT!"
        else
            Task.fail "Incorrect username or password"

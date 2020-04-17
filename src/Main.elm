module Main exposing (..)

import Browser
import Browser.Navigation as Nav
import Html exposing (..)
import Html.Attributes exposing (..)
import Url
import Bootstrap.CDN as CDN
import Bootstrap.Grid as Grid
import Bootstrap.Navbar as Navbar

main : Program () Model Msg
main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        , onUrlChange = UrlChanged
        , onUrlRequest = LinkClicked
        }

type alias Model =
    { navbarState : Navbar.State 
    , url : Url.Url
    , key : Nav.Key
    }

 
init : () -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init toMsg url key =
    let
        (navbarState, navbarCmd)
            = Navbar.initialState NavbarMsg
    in
        (Model navbarState url key, navbarCmd )

type Msg
    = NavbarMsg Navbar.State
    | LinkClicked Browser.UrlRequest
    | UrlChanged Url.Url

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NavbarMsg state ->
            ( { model | navbarState = state }, Cmd.none)
        LinkClicked urlRequest ->
            case urlRequest of
                Browser.Internal url ->
                    ( model, Nav.pushUrl model.key (Url.toString url) )
                Browser.External href ->
                    ( model, Nav.load href )
        UrlChanged url ->
            ( { model | url = url }
            , Cmd.none
            )

subscriptions : Model -> Sub Msg
subscriptions model =
    Navbar.subscriptions model.navbarState NavbarMsg

view : Model -> Browser.Document Msg
view model =
    { title = "Nicholas Gilbert Elm Homepage"
    , body =
        [ Grid.container []
            [ CDN.stylesheet
            , menu model
            , Grid.row []
                [ Grid.col []
                    [ b [] [ text (Url.toString model.url) ] ]
                ]
            ]
        ]
    }

menu : Model -> Html Msg
menu model =
    Navbar.config NavbarMsg
        |> Navbar.withAnimation
        |> Navbar.brand [ href "/" ] [ text "Home" ]
        |> Navbar.items
            [ Navbar.itemLink [ href "/foo" ] [text "foo" ]
            , Navbar.itemLink [ href "/bar" ] [text "bar" ]
            ]
        |> Navbar.view model.navbarState

viewLink : String -> Html msg
viewLink path =
    li [] [ a [ href path ] [ text path ] ]
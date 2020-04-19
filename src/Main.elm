module Main exposing (..)

import Browser
import Browser.Navigation as Nav
import Html exposing (..)
import Html.Attributes exposing (..)
import Url
import Url.Parser exposing (Parser, (</>), int, map, oneOf, s, string)
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
            , viewHandler model
            ]
        ]
    }

menu : Model -> Html Msg
menu model =
    Navbar.config NavbarMsg
        |> Navbar.withAnimation
        |> Navbar.primary
        |> Navbar.brand [ href "/" ] [ text "Home" ]
        |> Navbar.items
            --[ Navbar.itemLink [ href "/projects" ] [text "Projects" ]
            --, Navbar.itemLink [ href "/resume" ] [text "Resume" ]
            --]
            [ menuHighlight model "/projects" [ href "/projects" ] [text "Projects" ]
            , menuHighlight model "/resume" [ href "/resume" ] [text "Resume" ]
            ]
        |> Navbar.view model.navbarState

menuHighlight : Model -> String -> (List (Attribute msg) -> List (Html msg) -> Navbar.Item msg)
menuHighlight model path =
    case Url.Parser.parse routeParser model.url of
        Just Project ->
            case path of
                "/projects" ->
                    Navbar.itemLinkActive
                _ ->
                    Navbar.itemLink
        Just Resume ->
            case path of 
                "/resume" ->
                    Navbar.itemLinkActive
                _ ->
                    Navbar.itemLink
        Nothing ->
            Navbar.itemLink
                


viewLink : String -> Html msg
viewLink path =
    li [] [ a [ href path ] [ text path ] ]

type Route 
    = Project
    | Resume

routeParser : Parser (Route -> a) a
routeParser =
    oneOf
        [ Url.Parser.map Project (Url.Parser.s "projects")
        , Url.Parser.map Resume (Url.Parser.s "resume")
        ]

viewHandler : Model -> Html Msg
viewHandler model =
    case Url.Parser.parse routeParser model.url of
        Just Project ->
            viewProject model
        Just Resume ->
            viewResume model
        Nothing ->
            viewHome model


viewProject : Model -> Html Msg
viewProject model =
    Grid.row []
        [ Grid.col []
            [ b [] [ text "This is a project list!" ] ]
        ]

viewResume : Model -> Html Msg
viewResume model =
    Grid.row []
        [ Grid.col []
            [ b [] [ text "This is a virtual resume!" ] ]
        ]

viewHome : Model -> Html Msg
viewHome model =
    Grid.row []
        [ Grid.col []
            [ b [] [ text "Welcome to my homepage!" ]
            , div []
                [ text "This is very much work in progress!" ]
            ]
        ]
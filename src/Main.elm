module Main exposing (..)

import Browser
import Browser.Navigation as Nav
import Html exposing (..)
import Html.Attributes exposing (..)
import Url
import Url.Parser exposing (Parser, (</>), int, map, oneOf, s, string)
import Bootstrap.CDN as CDN
import Bootstrap.Grid as Grid
import Bootstrap.Grid.Row as Row 
import Bootstrap.Grid.Col as Col
import Bootstrap.Utilities.Spacing as Spacing
import Bootstrap.Text as Text
import Bootstrap.Navbar as Navbar
import Bootstrap.Accordion as Accordion
import Bootstrap.Card.Block as Block 

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
    , accordionState : Accordion.State
    , url : Url.Url
    , key : Nav.Key
    }

 
init : () -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init toMsg url key =
    let
        (navbarState, navbarCmd)
            = Navbar.initialState NavbarMsg
    in
        --(Model navbarState url key, navbarCmd )
        ({ navbarState = navbarState
         , accordionState = Accordion.initialState
         , url = url
         , key = key
        }, navbarCmd)

type Msg
    = NavbarMsg Navbar.State
    | AccordionMsg Accordion.State
    | LinkClicked Browser.UrlRequest
    | UrlChanged Url.Url

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NavbarMsg state ->
            ( { model | navbarState = state }, Cmd.none)
        AccordionMsg state ->
            ( { model | accordionState = state } , Cmd.none )

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
    Sub.batch [ Navbar.subscriptions model.navbarState NavbarMsg
              , Accordion.subscriptions model.accordionState AccordionMsg
              ]

view : Model -> Browser.Document Msg
view model =
    { title = "Nicholas Gilbert Elm Homepage"
    , body =
        [ Grid.containerFluid []
            (viewHandler model)
        ]
    }

menu : Model -> Html Msg
menu model =
    Navbar.config NavbarMsg
        |> Navbar.withAnimation
        |> Navbar.primary
        |> Navbar.brand [ href "/" ] 
            [ img [ src "https://image.flaticon.com/icons/svg/25/25694.svg", width 40, height 40 ] [] ]
        |> Navbar.items
            [ menuItem model "/projects" [ href "/projects" ] [text "Projects" ]
            , menuItem model "/resume" [ href "/resume" ] [text "Resume" ]
            ]
        |> Navbar.view model.navbarState

menuItem : Model -> String -> (List (Attribute msg) -> List (Html msg) -> Navbar.Item msg)
menuItem model path =
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

type Route 
    = Project
    | Resume

routeParser : Parser (Route -> a) a
routeParser =
    oneOf
        [ Url.Parser.map Project (Url.Parser.s "projects")
        , Url.Parser.map Resume (Url.Parser.s "resume")
        ]

viewHandler : Model -> List (Html Msg)
viewHandler model =
    [ CDN.stylesheet
    , menu model
    ] ++ 
    case Url.Parser.parse routeParser model.url of
        Just Project ->
            viewProject model 
        Just Resume ->
            viewResume model 
        Nothing ->
            viewHome model

defaultRowAlignment : List (Row.Option msg)
defaultRowAlignment =
    [Row.middleXs]

defaultColAlignment : List (Col.Option msg)
defaultColAlignment =
    --[Col.middleXs, Col.xs6, Col.textAlign Text.alignXsCenter]
    [Col.textAlign Text.alignXsCenter]

type alias ProjectCard = 
    { id : String
    , title : String
    , desc : String
    , img : String
    , mainLink : String
    , mainLinkText : String
    , srcLink : String
    , srcLinkText : String
    }

viewProject : Model -> List (Html Msg)
viewProject model =
    [ Grid.row defaultRowAlignment
        [ Grid.col defaultColAlignment
            [ b [] [ text "This is a project list!" ] 
            , br [] []
            , text "This is very much work in progress!"
            ]
        , Grid.col defaultColAlignment
            [ b [] [ text "WIP!" ] ]
        ]
    , Grid.row [Row.topXs]
        [ Grid.col [Col.xs2] []
        , Grid.col defaultColAlignment
            [ projectCard model 
                { id = "rbtbounce"
                , title = "Robot Bounce"
                , desc = "Robot puzzle game inspired by Ricohet Robots"
                , img = ""
                , mainLink = "https://gilben1.github.io/robot-bounce/"
                , mainLinkText = "Play now!"
                , srcLink = "https://github.com/gilben1/robot-bounce"
                , srcLinkText = "Github Repository"
                }
            ]
        , Grid.col defaultColAlignment
            [ projectCard model
                { id = "elmsite"
                , title = "gilben1.github.io"
                , desc = "This website! Written in Elm using Elm Bootstrap 4"
                , img = ""
                , mainLink = "https://gilben1.github.io"
                , mainLinkText = "Link here!"
                , srcLink = "https://github.com/gilben1/gilben1.github.io"
                , srcLinkText = "Github Repository"
                }
            ]
        , Grid.col defaultColAlignment
            [ projectCard model
                { id = "shtab"
                , title = "shTab"
                , desc = "Shell new tab page extension for Firefox"
                , img = ""
                , mainLink = "https://addons.mozilla.org/en-US/firefox/addon/shtab/"
                , mainLinkText = "Install now! (Temporarily disabled)"
                , srcLink = "https://gitlab.com/gilben/shTab"
                , srcLinkText = "Gitlab Repository"
                }
            ]
        , Grid.col [Col.xs2] []
        ]
    ]

projectCard : Model -> ProjectCard -> Html Msg
projectCard model prj =
    Accordion.config AccordionMsg
        |> Accordion.withAnimation
        |> Accordion.cards
            [ Accordion.card
                { id = prj.id
                , options = []
                , header =
                    Accordion.header [] <| Accordion.toggle [] [ text prj.title ]
                , blocks =
                    [ Accordion.block [ Block.align Text.alignXsLeft]
                        [ Block.text [] [ text prj.desc ] 
                        , Block.link [ href prj.mainLink, target "_blank" ] [ text prj.mainLinkText ]
                        , Block.link [ href prj.srcLink, target "_blank" ] [ text prj.srcLinkText ]
                        ]
                    ]
                }
            ]
        |> Accordion.onlyOneOpen
        |> Accordion.view model.accordionState

viewResume : Model -> List (Html Msg)
viewResume model =
    [ Grid.row defaultRowAlignment
        [ Grid.col defaultColAlignment
            [ b [] [ text "This is a virtual resume!" ] 
            , br [] []
            , text "This is very much work in progress!"
            ]
        , Grid.col defaultColAlignment
            [ b [] [ text "WIP!" ] ]
        ]
    ]

viewHome : Model -> List (Html Msg)
viewHome model =
    [ Grid.row defaultRowAlignment
        [ Grid.col defaultColAlignment
            [ b [ Spacing.p5 ] [ text "Welcome to my homepage!" ]
            , br [] []
            , text "This is very much work in progress!"
            ]
        , Grid.col defaultColAlignment
            [ b [] [ text "WIP!" ] ]
        ]
    ]


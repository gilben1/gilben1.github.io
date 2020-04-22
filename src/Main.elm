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
import Bootstrap.Tab as Tab
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
    { tabState : Tab.State
    , accordionState : Accordion.State
    , url : Url.Url
    , key : Nav.Key
    }

 
init : () -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init toMsg url key =
        ({ tabState = Tab.initialState
         , accordionState = Accordion.initialState
         , url = url
         , key = key
        }, Cmd.none)

type Msg
    = TabMsg Tab.State
    | AccordionMsg Accordion.State
    | LinkClicked Browser.UrlRequest
    | UrlChanged Url.Url

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        TabMsg state ->
            ( { model | tabState = state }, Cmd.none)
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
    Sub.batch [ Tab.subscriptions model.tabState TabMsg
              , Accordion.subscriptions model.accordionState AccordionMsg
              ]

view : Model -> Browser.Document Msg
view model =
    { title = "Nicholas Gilbert Elm Homepage"
    , body =
        [ Grid.containerFluid []
            [ CDN.stylesheet
            , menu model
            ] 
        ]
    }

menu : Model -> Html Msg
menu model =
    Tab.config TabMsg
        |> Tab.withAnimation
        |> Tab.center
        |> Tab.items
            [ Tab.item
                { id = "tabHome"
                , link = Tab.link [ class "tab-link" ] [ text "Home" ]
                , pane =
                    Tab.pane [ Spacing.mt3 ]
                       (viewHome model)
                }
            , Tab.item
                { id = "tabProject"
                , link = Tab.link [ class "tab-link" ] [ text "Projects" ]
                , pane =
                    Tab.pane [ Spacing.mt3 ]
                       (viewProject model)
                }
            , Tab.item
                { id = "tabResumes"
                , link = Tab.link [ class "tab-link" ] [ text "Resume" ]
                , pane =
                    Tab.pane [ Spacing.mt3 ]
                       (viewResume model)
                }
            ]
        |> Tab.attrs [ class "tab" ]
        |> Tab.view model.tabState

defaultRowAlignment : List (Row.Option msg)
defaultRowAlignment =
    [Row.middleXs]

defaultColAlignment : List (Col.Option msg)
defaultColAlignment =
    --[Col.middleXs, Col.xs6, Col.textAlign Text.alignXsCenter]
    [Col.textAlign Text.alignXsCenter]

type ProjectSource
    = GitHub
    | GitLab
    | Other

type alias ProjectCard = 
    { id : String
    , title : String
    , desc : String
    , img : String
    , mainLink : String
    , mainLinkText : String
    , srcLink : String
    , srcLinkText : String
    , srcType : ProjectSource
    }

viewProject : Model -> List (Html Msg)
viewProject model =
    [ Grid.row [Row.middleXs]
        [ Grid.col [Col.xs2] []
        , Grid.col defaultColAlignment
            [ projectCard model 
                { id = "rbtbounce"
                , title = "Robot Bounce"
                , desc = "Robot puzzle game inspired by Ricohet Robots"
                , img = "src/assets/robot_bounce.png"
                , mainLink = "https://gilben1.github.io/robot-bounce/"
                , mainLinkText = "Play now!"
                , srcLink = "https://github.com/gilben1/robot-bounce"
                , srcLinkText = "Github Repository"
                , srcType = GitHub
                }
            ]
        , Grid.col defaultColAlignment
            [ projectCard model
                { id = "elmsite"
                , title = "gilben1.github.io"
                , desc = "This website! Written in Elm using Elm Bootstrap 4"
                , img = "https://upload.wikimedia.org/wikipedia/commons/f/f3/Elm_logo.svg"
                , mainLink = "https://gilben1.github.io"
                , mainLinkText = "Link here!"
                , srcLink = "https://github.com/gilben1/gilben1.github.io"
                , srcLinkText = "Github Repository"
                , srcType = GitHub
                }
            ]
        , Grid.col defaultColAlignment
            [ projectCard model
                { id = "shtab"
                , title = "shTab"
                , desc = "Shell new tab page extension for Firefox"
                , img = "https://image.flaticon.com/icons/svg/2535/2535381.svg"
                , mainLink = "https://addons.mozilla.org/en-US/firefox/addon/shtab/"
                , mainLinkText = "Install now! (Temporarily disabled)"
                , srcLink = "https://gitlab.com/gilben/shTab"
                , srcLinkText = "Gitlab Repository"
                , srcType = GitLab
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
                    Accordion.header [] <| Accordion.toggle [] 
                        [ Grid.container []
                            [ Grid.row [Row.middleXs] 
                                [ Grid.col []
                                    [ case prj.img of 
                                        "" -> 
                                            text ""
                                        _ ->
                                            img [src prj.img, width 64, height 64] [] 
                                    ]
                                , Grid.col [Col.xs1] []
                                , Grid.col []
                                    [ text prj.title ]
                                ]
                            ]
                        ]
                , blocks =
                    [ Accordion.block [ Block.align Text.alignXsLeft ]
                        [ Block.text [] [ text prj.desc ] 
                        ]
                    , Accordion.block [ Block.align Text.alignXsLeft ]
                        [ Block.link [ href prj.mainLink, target "_blank" ] [ text prj.mainLinkText ]
                        ]
                    , Accordion.block [ Block.align Text.alignXsLeft ]
                        [ case prj.srcType of
                            GitHub ->
                                Block.custom (img [src "src/assets/GitHub-Mark-32px.png", width 24, height 24] [])
                            GitLab ->
                                Block.custom (img [src "src/assets/gitlab-icon-rgb.svg", width 24, height 24] [])
                            Other ->
                                Block.text [] [text ""]
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


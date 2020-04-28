module Main exposing (..)

import Browser
import Browser.Navigation as Nav
import Html exposing (..)
import Html.Attributes exposing (..)
import Url
import Bootstrap.CDN as CDN
import Bootstrap.Grid as Grid
import Bootstrap.Grid.Row as Row 
import Bootstrap.Grid.Col as Col
import Bootstrap.Utilities.Spacing as Spacing
import Bootstrap.Text as Text
import Bootstrap.Tab as Tab
import Bootstrap.Accordion as Accordion
import Bootstrap.Card.Block as Block 
import Bootstrap.Carousel as Carousel
import Bootstrap.Carousel.Slide as Slide

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
    , carouselState : Carousel.State
    , url : Url.Url
    , key : Nav.Key
    }

 
init : () -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init toMsg url key =
        ({ tabState = Tab.initialState
         , accordionState = Accordion.initialState
         , carouselState = Carousel.initialState
         , url = url
         , key = key
        }, Cmd.none)

type Msg
    = TabMsg Tab.State
    | AccordionMsg Accordion.State
    | CarouselMsg Carousel.Msg
    | LinkClicked Browser.UrlRequest
    | UrlChanged Url.Url

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        TabMsg state ->
            ( { model | tabState = state }, Cmd.none)
        AccordionMsg state ->
            ( { model | accordionState = state }, Cmd.none )
        CarouselMsg subMsg ->
            ( { model | carouselState = Carousel.update subMsg model.carouselState }, Cmd.none )

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
              , Carousel.subscriptions model.carouselState CarouselMsg
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
        [ Grid.col [Col.xl2] []
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
                , mainLinkText = "Link"
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
                , img = "src/assets/system.png"
                , mainLink = "https://gitlab.com/gilben/shTab/-/releases/0.6.4"
                , mainLinkText = "Latest Release"
                , srcLink = "https://gitlab.com/gilben/shTab"
                , srcLinkText = "Gitlab Repository"
                , srcType = GitLab
                }
            ]
        , Grid.col [Col.xl2] []
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
                , header = projectCardHeader model prj
                , blocks = projectCardContent model prj
                }
            ]
        |> Accordion.onlyOneOpen
        |> Accordion.view model.accordionState

projectCardHeader : Model -> ProjectCard -> Accordion.Header msg
projectCardHeader model prj =
    Accordion.toggle [] 
        [ Grid.containerFluid []
            [ Grid.row [Row.middleXs] 
                [ Grid.col [Col.xs, Col.textAlign Text.alignXsCenter ]
                    [ text prj.title ]
                ]
            ]
        ]
    |> Accordion.header []
    |> Accordion.prependHeader [ img [src prj.img, class "img-responsive img-thumbnail" ] [] ]

projectCardContent : Model -> ProjectCard -> List (Accordion.CardBlock msg)
projectCardContent model prj =
    [ Accordion.block [ Block.align Text.alignXsLeft ]
        [ Block.text [] [ text prj.desc ] 
        ]
    , Accordion.block [ Block.align Text.alignXsLeft ]
        [ Block.text [] <| [ Grid.row [Row.middleXs]
                                    [ Grid.col [Col.xs5, Col.textAlign Text.alignXsLeft]
                                        [ a [ href prj.mainLink, target "_blank" ] [ text prj.mainLinkText ]
                                        ]
                                    , Grid.col [Col.xs1] []
                                    , Grid.col [Col.xs6, Col.textAlign Text.alignXsRight]
                                        [ case prj.srcType of
                                            GitHub ->
                                                img [src "src/assets/GitHub-Mark-32px.png", class "img-icon" ] []
                                            GitLab ->
                                                img [src "src/assets/gitlab-icon-rgb.svg", class "img-icon" ] []
                                            Other ->
                                                text ""
                                        , a [ href prj.srcLink, target "_blank" ] [ text prj.srcLinkText ]
                                        ]
                                    ]
                            ]
        ]
    ]


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
    [ Grid.row [Row.topXs]
        [ Grid.col [Col.xs4] []
        , Grid.col [Col.xs]
            [Carousel.config CarouselMsg []
                |> Carousel.slides
                    [ Slide.config [] (Slide.image [ class "img-fluid" ] "src/assets/slide1.jpg")
                        |> Slide.caption []
                            [ h4 [] [ text "Placeholder photo 1" ]
                            , a [href "https://unsplash.com/@marcushjelm_?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText"] [ text "Source: Marcus Hjelm on Unsplash" ] 
                            ]
                    , Slide.config [] (Slide.image [ class "img-fluid" ] "src/assets/slide2.jpg")
                        |> Slide.caption []
                            [ h4 [] [ text "Placeholder photo 2" ]
                            , a [href "https://unsplash.com/@rezphotography?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText"] [ text "Source: REZ on Unsplash" ] 
                            ]
                    ]
                |> Carousel.withIndicators
                |> Carousel.withControls
                |> Carousel.view model.carouselState
            ]
        , Grid.col [Col.xs4] []
        ]
    , Grid.row [] []
    , Grid.row [Row.bottomXs]
        [ Grid.col defaultColAlignment
            [ b [ Spacing.p5 ] [ text "Welcome to my homepage!" ]
            , br [] []
            , text "This is very much work in progress!"
            ]
        , Grid.col defaultColAlignment
            [ b [] [ text "WIP!" ] ]
        ]
    ]


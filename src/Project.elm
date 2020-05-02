module Project exposing (..)

import Common as C

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

viewProject : C.Model -> List (Html C.Msg)
viewProject model =
    [ Grid.row [Row.middleXs]
        [ Grid.col [Col.xl2] []
        , Grid.col C.defaultColAlignment
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
        , Grid.col C.defaultColAlignment
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
        , Grid.col C.defaultColAlignment
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

projectCard : C.Model -> ProjectCard -> Html C.Msg
projectCard model prj =
    Accordion.config C.AccordionMsg
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

projectCardHeader : C.Model -> ProjectCard -> Accordion.Header msg
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

projectCardContent : C.Model -> ProjectCard -> List (Accordion.CardBlock msg)
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
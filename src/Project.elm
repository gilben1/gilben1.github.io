module Project exposing (..)

import Common exposing (Msg(..), Model, defaultColAlignment, defaultRowAlignment)

import Html exposing (..)
import Html.Attributes exposing (..)

import Bootstrap.Grid as Grid
import Bootstrap.Grid.Row as Row 
import Bootstrap.Grid.Col as Col
import Bootstrap.Text as Text
import Bootstrap.Accordion as Accordion
import Bootstrap.Card.Block as Block 

type ProjectSource
    = GitHub
    | GitLab
    | Other

type RepoLink
    = RepoSingle String
    | RepoMulti (List String)

type ProjectSourceType
    = SourceSingle ProjectSource 
    | SourceMulti (List ProjectSource)

type alias ProjectCard = 
    { id : String
    , title : String
    , desc : String
    , img : String
    , mainLink : String
    , mainLinkText : String
    , srcLink : RepoLink
    , srcLinkText : RepoLink
    , srcType : ProjectSourceType
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
                , srcLink = RepoSingle "https://github.com/gilben1/robot-bounce"
                , srcLinkText = RepoSingle "Github Repository"
                , srcType = SourceSingle GitHub
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
                , srcLink = RepoSingle "https://github.com/gilben1/gilben1.github.io"
                , srcLinkText = RepoSingle "Github Repository"
                , srcType = SourceSingle GitHub
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
                , srcLink = RepoSingle "https://gitlab.com/gilben/shTab"
                , srcLinkText = RepoSingle "Gitlab Repository"
                , srcType = SourceSingle GitLab
                }
            ]
        , Grid.col [Col.xl2] []
        ]
    , Grid.row [Row.middleXs]
        [ Grid.col [Col.xl4] []
        , Grid.col defaultColAlignment
            [ projectCard model
                { id = "robotis"
                , title = "Capstone: ROBOTIS-OP3"
                , desc = "Capstone project from Portland State University for improving the vision detection algorithm for detecting soccer balls for a humanoid robot called ROBOTIS-OP3"
                , img = "src/assets/robot_bounce.png"
                , mainLink = "https://capstoneteamd.wixsite.com/home"
                , mainLinkText = "Project Site"
                , srcLink = RepoMulti ["https://github.com/Sappytomb796/ROBOTIS-OP3-Demo", "https://github.com/Sappytomb796/ROBOTIS-OP3-Tools", "https://github.com/Sappytomb796/ROBOTIS-OP3"]
                , srcLinkText = RepoMulti ["OP3-Demo", "OP3-Tools", "OP3-Main"]
                , srcType = SourceMulti [GitHub, GitHub, GitHub]
                }
            ]
        , Grid.col [Col.xl4] []
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
                                       ( case prj.srcLink of
                                            RepoSingle srcLink ->
                                                case prj.srcLinkText of
                                                    RepoSingle srcLinkText ->
                                                        case prj.srcType of
                                                            SourceSingle srcType ->
                                                                [ case srcType of 
                                                                    GitHub ->
                                                                        img [src "src/assets/GitHub-Mark-32px.png", class "img-icon" ] []
                                                                    GitLab ->
                                                                        img [src "src/assets/gitlab-icon-rgb.svg", class "img-icon" ] []
                                                                    Other ->
                                                                        text ""
                                                                , a [ href srcLink, target "_blank" ] [ text srcLinkText ] 
                                                                ]
                                                            SourceMulti _ -> []
                                                    RepoMulti _ -> []

                                            RepoMulti srcList ->
                                                case prj.srcLinkText of
                                                    RepoSingle _ -> []
                                                    RepoMulti srcLinkList ->
                                                        case prj.srcType of
                                                            SourceSingle _ -> []
                                                            SourceMulti srcTypeList ->
                                                                List.map3 (
                                                                    \x y z -> 
                                                                        div [] 
                                                                            [ case z of 
                                                                                GitHub ->
                                                                                    img [src "src/assets/GitHub-Mark-32px.png", class "img-icon" ] []
                                                                                GitLab ->
                                                                                    img [src "src/assets/gitlab-icon-rgb.svg", class "img-icon" ] []
                                                                                Other ->
                                                                                    text ""
                                                                            , a [href x, target "_blank" ] [ text y ] 
                                                                            ] ) srcLinkList srcList srcTypeList
                                       )
                                    ]
                            ]
        ]
    ]
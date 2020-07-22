module Project exposing (..)

import Common exposing (Msg(..), Model, defaultColAlignment, defaultRowAlignment, colClass, rowClass)

import Html exposing (..)
import Html.Attributes exposing (..)

import Bootstrap.Grid as Grid
import Bootstrap.Grid.Row as Row 
import Bootstrap.Grid.Col as Col
import Bootstrap.Text as Text
import Bootstrap.Accordion as Accordion
import Bootstrap.Card.Block as Block 
import Bootstrap.Card as Card

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
        [ Grid.col defaultColAlignment
            [ h1 [] [ text "Projects" ] ]
        ]
    , Grid.row [Row.topXs]
        [ Grid.col [Col.xl1] []
        , Grid.col defaultColAlignment
            [ projectGroup model 
                [ { id = "elmsite"
                    , title = "gilben1.github.io"
                    , desc = "This website! Written in Elm using Elm Bootstrap 4"
                    , img = "src/assets/elm_logo.png"
                    , mainLink = "https://gilben1.github.io"
                    , mainLinkText = "Link"
                    , srcLink = RepoSingle "https://github.com/gilben1/gilben1.github.io"
                    , srcLinkText = RepoSingle "Github Repository"
                    , srcType = SourceSingle GitHub
                  }
                , { id = "rbtbounce"
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
            ]
        , Grid.col defaultColAlignment 
            [ projectGroup model 
                [ { id = "shtab"
                    , title = "shTab"
                    , desc = "Shell-like new tab page extension for Firefox, programmable with a Bash-like commandline system"
                    , img = "src/assets/system.png"
                    , mainLink = "https://gitlab.com/gilben/shTab/-/releases/0.6.4"
                    , mainLinkText = "Latest Release"
                    , srcLink = RepoSingle "https://gitlab.com/gilben/shTab"
                    , srcLinkText = RepoSingle "Gitlab Repository"
                    , srcType = SourceSingle GitLab
                  }
                , { id = "robotis"
                    , title = "Capstone: ROBOTIS-OP3"
                    , desc = "Capstone project from Portland State University for improving the vision detection algorithm for detecting soccer balls for a humanoid robot called ROBOTIS-OP3"
                    , img = "http://emanual.robotis.com/assets/images/platform/op3/op3_product_rev2.png"
                    , mainLink = "https://capstoneteamd.wixsite.com/home"
                    , mainLinkText = "Project Site"
                    , srcLinkText = RepoMulti ["OP3-Demo", "OP3-Tools", "OP3-Main"]
                    , srcLink = RepoMulti ["https://github.com/Sappytomb796/ROBOTIS-OP3-Demo", "https://github.com/Sappytomb796/ROBOTIS-OP3-Tools", "https://github.com/Sappytomb796/ROBOTIS-OP3"]
                    , srcType = SourceMulti [GitHub, GitHub, GitHub]
                  }
               ]
            ]
        , Grid.col defaultColAlignment
            [ projectGroup model
                [ { id = "haspall"
                    , title = "Haspall Discord Bots"
                    , desc = "Discord bots for querying information from haskell's hoogle interface. Version one was written in python, while redux was rewritten in haskell itself for more advanced operation."
                    , img = "src/assets/hoogle_logo.png"
                    , mainLink = ""
                    , mainLinkText = ""
                    , srcLinkText = RepoMulti ["Haskell Version (Redux)", "Python Version"]
                    , srcLink = RepoMulti ["https://gitlab.com/gilben/haspall-redux", "https://gitlab.com/gilben/haspall"]
                    , srcType = SourceMulti [GitLab, GitLab]
                  }
                , { id = "irc"
                    , title = "Various IRC Bots"
                    , desc = "Some (mostly useless) IRC bots that perform various functions. Dicebot let you roll dice in various fun ways, dad bot told dad jokes, ythaikubot pulled data from the subreddit YoutubeHaiku, and parens-bot fixes those pesky loose parentheses."
                    , img = "src/assets/coding_icon.png"
                    , mainLink = ""
                    , mainLinkText = ""
                    , srcLinkText = RepoMulti ["Dicebot", "Dadbot", "YTHaikubot", "Parens-bot"]
                    , srcLink = RepoMulti ["https://gitlab.com/gilben/dicebot", "https://gitlab.com/gilben/dadbot", "https://gitlab.com/gilben/ythaikubot", "https://gitlab.com/gilben/parens-bot"]
                    , srcType = SourceMulti [GitLab, GitLab, GitLab, GitLab]
                  }
                ]

            ]
        , Grid.col [Col.xl1] []
        ]
    ]
projectGroup : Model -> List (ProjectCard) -> Html Msg
projectGroup model prjs =
    Accordion.config AccordionMsg
        |> Accordion.withAnimation
        |> Accordion.cards
            (List.map buildProjectCards prjs)
        |> Accordion.view model.accordionState

buildProjectCards : ProjectCard -> Accordion.Card msg
buildProjectCards prj =
    Accordion.card
        { id = prj.id
        , options = [Card.outlineInfo]
        , header = projectCardHeader prj
        , blocks = projectCardContent prj
        }


projectCardHeader : ProjectCard -> Accordion.Header msg
projectCardHeader prj =
    Accordion.toggle [] 
        [ Grid.container []
            [ Grid.row [Row.middleXs, rowClass "" ] 
                [ Grid.col [Col.xs, Col.textAlign Text.alignXsRight ]
                    [ text prj.title ]
                ]
            ]
        ]
    |> Accordion.header []
    |> Accordion.prependHeader [ img [src prj.img, class "img-responsive img-thumbnail" ] [] ]

projectCardContent : ProjectCard -> List (Accordion.CardBlock msg)
projectCardContent prj =
    [ Accordion.block [ Block.align Text.alignXsLeft]
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
                                                                            , a [href y, target "_blank" ] [ text x ] 
                                                                            ] ) srcLinkList srcList srcTypeList
                                       )
                                    ]
                            ]
        ]
    ]
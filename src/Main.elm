module Main exposing (..)

-- Custom imports from local modules
import Common exposing (..)
import Github.Profile exposing (Msg(..), State(..))
import Github.RepoStats exposing (Msg(..))
import Commands exposing (..)
import Tabs.Project exposing (viewProject)
import Tabs.Home exposing (viewHome)
import Tabs.Resume exposing (viewResume)
import Tabs.References exposing (viewReferences)
import Tabs.Stats exposing (viewStats)

import Browser
import Browser.Navigation as Nav
import Html exposing (..)
import Html.Attributes exposing (..)
import Url

-- Bootstrap imports
import Bootstrap.Utilities.Spacing as Spacing
import Bootstrap.Tab as Tab
import Bootstrap.Accordion as Accordion

import Time

main : Program () Model Common.Msg
main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        , onUrlChange = UrlChanged
        , onUrlRequest = LinkClicked
        }

 
init : () -> Url.Url -> Nav.Key -> ( Model, Cmd Common.Msg )
init toMsg url key =
    let 
        model = 
            { tabState = Tab.initialState
            , accordionState = Accordion.initialState
            , url = url
            , key = key
            , profileState = Github.Profile.Loading
            , repoInfoState = Github.RepoStats.Loading
            , timeZone = Time.utc
            }

        cmds = 
            Cmd.batch
                [ Cmd.map ProfileMsg loadGithubProfile
                , Cmd.map RepoInfoMsg loadGithubRepoInfo 
                , getTimeZone
                ]
    in
        (model, cmds)
        


update : Common.Msg -> Model -> ( Model, Cmd Common.Msg )
update msg model =
    case msg of
        TabMsg state ->
            ( { model | tabState = state }, Cmd.none)
        AccordionMsg state ->
            ( { model | accordionState = state }, Cmd.none )

        ProfileMsg pMsg ->
            case pMsg of 
                ProfileLoaded result ->
                    case result of
                        Ok userProfile ->
                            ( {model | profileState = Github.Profile.Success userProfile}, Cmd.none)
                        Err _ ->
                            ( {model | profileState = Github.Profile.Failure}, Cmd.none)

        RepoInfoMsg rMsg ->
            case rMsg of
                RepoLoaded result ->
                    case result of
                        Ok repoInfo ->
                            ( {model | repoInfoState = Github.RepoStats.Success repoInfo}, Cmd.none)
                        Err _ ->
                            ( {model | repoInfoState = Github.RepoStats.Failure}, Cmd.none)

        GetTimeZone state ->
            ( {model | timeZone = state}, Cmd.none)

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

subscriptions : Model -> Sub Common.Msg
subscriptions model =
    Sub.batch [ Tab.subscriptions model.tabState TabMsg
              , Accordion.subscriptions model.accordionState AccordionMsg
              ]

view : Model -> Browser.Document Common.Msg
view model =
    { title = "Nicholas Gilbert Elm Homepage"
    , body =
        [ menu model
        ]
    }

menu : Model -> Html Common.Msg
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
            , Tab.item
                { id = "tabStats"
                , link = Tab.link [ class "tab-link" ] [ text "Stats" ]
                , pane =
                    Tab.pane [ Spacing.mt3 ]
                        (viewStats model)
                }
            , Tab.item
                { id = "tabRefs"
                , link = Tab.link [ class "tab-link" ] [ text "References" ]
                , pane = 
                    Tab.pane [ Spacing.mt3 ]
                        (viewReferences model)    
                }
            ]
        |> Tab.attrs [ class "tab" ]
        |> Tab.view model.tabState


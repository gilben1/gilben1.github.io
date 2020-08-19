module Main exposing (..)

-- Custom imports from local modules
import Common exposing (..)
import Profile exposing (..)
import Commands exposing (..)
import Project exposing (viewProject)
import Home exposing (viewHome)
import Resume exposing (viewResume)
import References exposing (viewReferences)

import Browser
import Browser.Navigation as Nav
import Html exposing (..)
import Html.Attributes exposing (..)
import Url
import Common exposing (Msg(..))
import RepoStats exposing (Msg(..))
import Commands

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
            , profileState = Profile.Loading
            , repoInfoState = RepoStats.Loading
            , timeZone = Time.utc
            }

        cmds = 
            Cmd.batch
                [ Cmd.map ProfileMsg Commands.loadGithubProfile
                , Cmd.map RepoInfoMsg Commands.loadGithubRepoInfo 
                , Commands.getTimeZone
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
                            ( {model | profileState = Profile.Success userProfile}, Cmd.none)
                        Err _ ->
                            ( {model | profileState = Profile.Failure}, Cmd.none)

        RepoInfoMsg rMsg ->
            case rMsg of
                RepoLoaded result ->
                    case result of
                        Ok repoInfo ->
                            ( {model | repoInfoState = RepoStats.Success repoInfo}, Cmd.none)
                        Err _ ->
                            ( {model | repoInfoState = RepoStats.Failure}, Cmd.none)

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
                { id = "tabRefs"
                , link = Tab.link [ class "tab-link" ] [ text "References" ]
                , pane = 
                    Tab.pane [ Spacing.mt3 ]
                        (viewReferences model)    
                }
            ]
        |> Tab.attrs [ class "tab" ]
        |> Tab.view model.tabState


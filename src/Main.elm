module Main exposing (..)
import Html exposing (br)
import Common exposing (defaultRowAlignment)
import Common exposing (defaultColAlignment)

-- Custom imports from local modules
import Common exposing (Msg(..), Model, defaultColAlignment, defaultRowAlignment, colClass, rowClass)
import Project exposing (viewProject)
import Home exposing (viewHome)
import Resume exposing (viewResume)
import References exposing (viewReferences)

import Browser
import Browser.Navigation as Nav
import Html exposing (..)
import Html.Attributes exposing (..)
import Url
import Common exposing (ProfileState)
import Common exposing (Msg)

-- Bootstrap imports
import Bootstrap.Utilities.Spacing as Spacing
import Bootstrap.Tab as Tab
import Bootstrap.Accordion as Accordion

import Http
import Json.Decode exposing (Decoder, field, string)



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

 
init : () -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init toMsg url key =
        ({ tabState = Tab.initialState
         , accordionState = Accordion.initialState
         , url = url
         , key = key
         , profileState = Common.Loading
        }, loadGithubProfile)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        TabMsg state ->
            ( { model | tabState = state }, Cmd.none)
        AccordionMsg state ->
            ( { model | accordionState = state }, Cmd.none )

        Common.ProfileLoaded result ->
            case result of
                Ok url ->
                    ( {model | profileState = Common.Success url}, Cmd.none)
                Err _ ->
                    ( {model | profileState = Common.Failure}, Cmd.none)

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
        [ menu model
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


loadGithubProfile : Cmd Msg
loadGithubProfile = 
    Http.get
        { url = "https://api.github.com/users/gilben1"
        , expect = Http.expectJson Common.ProfileLoaded githubDecoder
        }

githubDecoder : Decoder String
githubDecoder =
    field "avatar_url" string
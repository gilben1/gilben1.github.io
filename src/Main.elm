module Main exposing (..)
import Html exposing (br)
import Common exposing (defaultRowAlignment)
import Common exposing (defaultColAlignment)

-- Custom imports from local modules
import Common exposing (Msg(..), Model, defaultColAlignment, defaultRowAlignment, colClass, rowClass)
import Project exposing (viewProject)
import Home exposing (viewHome)

import Browser
import Browser.Navigation as Nav
import Html exposing (..)
import Html.Attributes exposing (..)
import Url

-- Bootstrap imports
import Bootstrap.CDN as CDN
import Bootstrap.Grid as Grid
import Bootstrap.Grid.Row as Row 
import Bootstrap.Grid.Col as Col
import Bootstrap.Text as Text
import Bootstrap.Utilities.Spacing as Spacing
import Bootstrap.Tab as Tab
import Bootstrap.Accordion as Accordion
import Bootstrap.Carousel as Carousel


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
         , carouselState = Carousel.initialState
         , url = url
         , key = key
        }, Cmd.none)


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
        [ menu model
        , Grid.containerFluid []
            [ Grid.row [rowClass "bottomdiv-root" ]
                    [ Grid.col [Col.xs, Col.textAlign Text.alignXsLeft, colClass "bottomdiv-text"]
                        (licenseIcon "src/assets/coding_icon.png" "Freepik" "Freepik"
                        ++ licenseIcon "src/assets/system.png" "Kirill Kazachek" "Kirill-Kazachek")
                    , Grid.col [Col.xs9, colClass "bottomdiv-spacer" ] [ ]
                    ]
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

viewResume : Model -> List (Html Msg)
viewResume model =
    [ Grid.row [Row.middleXs]
        [ Grid.col defaultColAlignment
            [ h1 [] [ text "Online Resume" ] ]
        ]
    , Grid.row [Row.middleXs]
        [ Grid.col defaultColAlignment
            [ a [href "src/assets/resume.pdf", target "_blank" ] [text "(PDF Link)" ] ]
        ]
    , Grid.row [Row.middleXs]
        [ Grid.col defaultColAlignment 
            [ canvas [id "pdf-canvas" ] [] ]
        ]
    ]
   

licenseIcon : String -> String -> String -> List (Html Msg)
licenseIcon srcPath author authorLink =
    [ img [src srcPath, class "img-icon"] []
    , text "icon made by "
    , a [href ("https://www.flaticon.com/authors/" ++ authorLink), title author] [text author] 
    , text " from "
    , a [href "https://www.flaticon.com/", title "Flaticon"] [text "www.flaticon.com"]
    , br [] []
    ]
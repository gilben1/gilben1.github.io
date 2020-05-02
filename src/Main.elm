module Main exposing (..)

import Common as C
import Project as Prj

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


main : Program () C.Model C.Msg
main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        , onUrlChange = C.UrlChanged
        , onUrlRequest = C.LinkClicked
        }

 
init : () -> Url.Url -> Nav.Key -> ( C.Model, Cmd C.Msg )
init toMsg url key =
        ({ tabState = Tab.initialState
         , accordionState = Accordion.initialState
         , carouselState = Carousel.initialState
         , url = url
         , key = key
        }, Cmd.none)


update : C.Msg -> C.Model -> ( C.Model, Cmd C.Msg )
update msg model =
    case msg of
        C.TabMsg state ->
            ( { model | tabState = state }, Cmd.none)
        C.AccordionMsg state ->
            ( { model | accordionState = state }, Cmd.none )
        C.CarouselMsg subMsg ->
            ( { model | carouselState = Carousel.update subMsg model.carouselState }, Cmd.none )

        C.LinkClicked urlRequest ->
            case urlRequest of
                Browser.Internal url ->
                    ( model, Nav.pushUrl model.key (Url.toString url) )
                Browser.External href ->
                    ( model, Nav.load href )
        C.UrlChanged url ->
            ( { model | url = url }
            , Cmd.none
            )

subscriptions : C.Model -> Sub C.Msg
subscriptions model =
    Sub.batch [ Tab.subscriptions model.tabState C.TabMsg
              , Accordion.subscriptions model.accordionState C.AccordionMsg
              , Carousel.subscriptions model.carouselState C.CarouselMsg
              ]

view : C.Model -> Browser.Document C.Msg
view model =
    { title = "Nicholas Gilbert Elm Homepage"
    , body =
        [ Grid.containerFluid []
            [ CDN.stylesheet
            , menu model
            ] 
        ]
    }

menu : C.Model -> Html C.Msg
menu model =
    Tab.config C.TabMsg
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
                       (Prj.viewProject model)
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

viewResume : C.Model -> List (Html C.Msg)
viewResume model =
    [ Grid.row C.defaultRowAlignment
        [ Grid.col C.defaultColAlignment
            [ b [] [ text "This is a virtual resume!" ] 
            , br [] []
            , text "This is very much work in progress!"
            ]
        , Grid.col C.defaultColAlignment
            [ b [] [ text "WIP!" ] ]
        ]
    ]

type alias HomeSlide =
    { slideRef : String
    , caption1 : String
    , caption2 : String
    , caption2Ref : String
    }


viewHome : C.Model -> List (Html C.Msg)
viewHome model =
    [ Grid.row [Row.topXs] (homeSlideShow model)
    , Grid.row [Row.bottomXs]
        [ Grid.col C.defaultColAlignment
            [ b [ Spacing.p5 ] [ text "Welcome to my homepage!" ]
            , br [] []
            , text "This is very much work in progress!"
            ]
        , Grid.col C.defaultColAlignment
            [ b [] [ text "WIP!" ] ]
        ]
    ]

homeSlideShow : C.Model -> List (Grid.Column C.Msg)
homeSlideShow model =
    [ Grid.col [Col.xs] []
    , Grid.col [ Col.xs ]
        [ Carousel.config C.CarouselMsg []
            |> Carousel.slides
                [ homeSlide
                    { slideRef = "src/assets/slide1.jpg"
                    , caption1 = "Placeholder photo 1" 
                    , caption2 = "Source: Marcus Hjelm on Unsplash"
                    , caption2Ref = "https://unsplash.com/@marcushjelm_?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText"
                    }
                , homeSlide
                    { slideRef = "src/assets/slide2.jpg"
                    , caption1 = "Placeholder photo 2" 
                    , caption2 = "Source: REZ on Unsplash"
                    , caption2Ref = "https://unsplash.com/@rezphotography?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText"
                    }
                ]
            |> Carousel.withControls
            |> Carousel.view model.carouselState
        ]
    , Grid.col [ Col.xs ] []
    ]

homeSlide : HomeSlide -> Slide.Config msg
homeSlide sld =
    Slide.config [] (Slide.image [ class "img-fluid img-slideshow" ] sld.slideRef)
        |> Slide.caption []
            [ div [class "slideshow-caption-background"]
                [ h3 [class "slideshow-caption"] [ text sld.caption1 ]
                , a [ href sld.caption2Ref 
                    , class "slideshow-caption"
                    ] 
                    [ h6 [] [ text sld.caption2 ] ]
                ]
            ]
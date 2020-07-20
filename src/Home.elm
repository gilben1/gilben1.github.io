module Home exposing (..)
import Common exposing (defaultColAlignment)

-- Custom imports from local modules
import Common exposing (Msg(..), Model, defaultColAlignment, defaultRowAlignment)

import Html exposing (..)
import Html.Attributes exposing (..)

-- Bootstrap imports
import Bootstrap.Grid as Grid
import Bootstrap.Grid.Row as Row 
import Bootstrap.Grid.Col as Col
import Bootstrap.Utilities.Spacing as Spacing
import Bootstrap.Carousel as Carousel
import Bootstrap.Carousel.Slide as Slide

type alias HomeSlide =
    { slideRef : String
    , caption1 : String
    , caption2 : String
    , caption2Ref : String
    }


viewHome : Model -> List (Html Msg)
viewHome model =
    [ --Grid.row [Row.topXs] (homeSlideShow model)
    --, 
     Grid.row [Row.bottomXs]
        [ Grid.col defaultColAlignment
            [ b [ Spacing.p5 ] [ text "Welcome to my homepage!" ]
            , br [] []
            , text "This is very much work in progress!"
            ]
        , Grid.col defaultColAlignment
            [ b [] [ text "WIP!" ] ]
        ]
    ]

homeSlideShow : Model -> List (Grid.Column Msg)
homeSlideShow model =
    [ Grid.col [Col.xs] []
    , Grid.col [ Col.xs ]
        [ Carousel.config CarouselMsg []
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
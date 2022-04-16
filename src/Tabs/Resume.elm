module Tabs.Resume exposing (viewResume)

-- Common module import, holds models common definitions
import Common exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)

import Bootstrap.Grid as Grid
import Bootstrap.Grid.Row as Row 
import Bootstrap.Grid.Col as Col

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
        [ Grid.col [Col.sm1] []
        , Grid.col defaultColAlignment 
            [ canvas [id "pdf-canvas", class "pdf-canvas" ] [] ]
        , Grid.col [Col.sm1] []
        ]
    , Grid.row [Row.middleXs]
        [ Grid.col [Col.sm1] []
        , Grid.col defaultColAlignment 
            [ canvas [id "pdf-canvas-2", class "pdf-canvas" ] [] ]
        , Grid.col [Col.sm1] []
        ]
    ]
   
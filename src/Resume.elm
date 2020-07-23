module Resume exposing (..)

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
import Bootstrap.Alert exposing (secondary)

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
   
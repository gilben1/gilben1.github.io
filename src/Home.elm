module Home exposing (..)
import Common exposing (defaultColAlignment)
import Html.Attributes exposing (default)
import Common exposing (rowClass)

-- Custom imports from local modules
import Common exposing (Msg(..), Model, defaultColAlignment, defaultRowAlignment)

import Html exposing (..)
import Html.Attributes exposing (..)

-- Bootstrap imports
import Bootstrap.Grid as Grid
import Bootstrap.Grid.Row as Row 
import Bootstrap.Grid.Col as Col
import Bootstrap.Utilities.Spacing as Spacing


viewHome : Model -> List (Html Msg)
viewHome model =
    [ Grid.row [Row.middleXs]
        [ Grid.col defaultColAlignment
            [ img [src "https://media-exp1.licdn.com/dms/image/C5603AQEZgrIefm1ehg/profile-displayphoto-shrink_200_200/0?e=1600905600&v=beta&t=K__b63zq6AQPTXpY8MKFYRtS9ceru2CME-4aQRY9G0c", class "img-thumbnail"] []
            ]
        ]
    , Grid.row [Row.bottomXs, rowClass ""]
        [ Grid.col defaultColAlignment
            [ b [ Spacing.p5 ] [ text "Homepage for Nicholas Gilbert (pictured above)" ] ]
        ]
    , Grid.row [Row.bottomXs, rowClass ""]
        [ Grid.col defaultColAlignment
            [text "This is very much work in progress!"]
        ]
    , Grid.row [Row.bottomXs, rowClass ""]
        [ Grid.col defaultColAlignment
            [ b [ Spacing.p5 ] [ text "Check out my projects in the tab above! That's the most complete section of this site!"] ]
        ]
    , Grid.row [Row.bottomXs, rowClass ""]
        [ Grid.col defaultColAlignment
            [ b [ Spacing.p5 ] [ text "Also check out my resume! Embedded and everything!" ] ]
        ]
    ]

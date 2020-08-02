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
import Bootstrap.Text as Text
import Bootstrap.Accordion as Accordion
import Bootstrap.Card.Block as Block 
import Bootstrap.Card as Card
import Bootstrap.Alert exposing (secondary)


viewHome : Model -> List (Html Msg)
viewHome model =
    [ Grid.row [Row.middleXs]
        [ Grid.col defaultColAlignment
            [ img [src "https://media-exp1.licdn.com/dms/image/C5603AQEZgrIefm1ehg/profile-displayphoto-shrink_200_200/0?e=1600905600&v=beta&t=K__b63zq6AQPTXpY8MKFYRtS9ceru2CME-4aQRY9G0c", class "img-thumbnail"] []
            ]
        ]
    , Grid.row [Row.bottomXs, rowClass ""]
        [ Grid.col [Col.xl3, Col.lg3, Col.md2, Col.sm1] []
        , Grid.col defaultColAlignment
            --[ homeCard "About" "Homepage for Nicholas Gilbert (pictured above)"]
            [ Card.group homeCardList ]
        , Grid.col [Col.xl3, Col.lg3, Col.md2, Col.sm1] []
        ]
    ]

homeCardList : List (Card.Config msg)
homeCardList = 
    [ homeCard "About" 
        [ "Homepage for Nicholas Gilbert (pictured above)"
        , "Written in Elm and utilizing Elm Bootstrap 4 for a responsive web experience."
        ]
    , homeCard "Progress" [ "This site is very much a work in progress" ]
    , homeCard "Thank You!" [ "Thank you for checking out this web page." ]
    ]


homeCard : String -> List (String) -> Card.Config msg
homeCard title body =
    Card.config [Card.outlinePrimary]
        |> Card.headerH5 [] [ text title ]
        |> Card.block []
            (List.map (\x -> Block.text [] [text x]) body)

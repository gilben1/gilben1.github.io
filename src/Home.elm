module Home exposing (..)
import Html.Attributes exposing (default)

-- Common module import, holds models common definitions
import Common exposing (..)
import Profile exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)

-- Bootstrap imports
import Bootstrap.Grid as Grid
import Bootstrap.Grid.Row as Row 
import Bootstrap.Grid.Col as Col
import Bootstrap.Card.Block as Block 
import Bootstrap.Card as Card
import Bootstrap.Alert exposing (secondary)

viewHome : Model -> List (Html Common.Msg)
viewHome model =
    [ Grid.row [Row.middleXs]
        [ Grid.col defaultColAlignment
            (viewProfilePic model)
        ]
    , Grid.row [Row.bottomXs, rowClass ""]
        [ Grid.col [Col.xl3, Col.lg3, Col.md2, Col.sm1] []
        , Grid.col defaultColAlignment
            [ Card.group homeCardList ]
        , Grid.col [Col.xl3, Col.lg3, Col.md2, Col.sm1] []
        ]
    ]

viewProfilePic : Model -> List (Html Common.Msg)
viewProfilePic model =
    case model.profileState of
        Profile.Failure ->
            [ text "Unable to load profile pic :("
            ]
        Profile.Loading ->
            [ text  "Loading profile pic..." 
            ]
        Profile.Success url ->
            [ img [src url, class "img-thumbnail"] []
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

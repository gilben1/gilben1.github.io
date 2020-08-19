module Tabs.Home exposing (viewHome)

-- Common module import, holds models common definitions
import Common exposing (..)
import Github.Profile exposing (..)
import Github.RepoStats exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)

-- Bootstrap imports
import Bootstrap.Grid as Grid
import Bootstrap.Grid.Row as Row 
import Bootstrap.Grid.Col as Col
import Bootstrap.Card.Block as Block 
import Bootstrap.Card as Card
import Bootstrap.Alert exposing (secondary)

--import Time exposing (..)

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
        Github.Profile.Failure ->
            [ text "Unable to load profile pic :("
            ]
        Github.Profile.Loading ->
            [ text  "Loading profile pic..." 
            ]
        Github.Profile.Success userProfile ->
            [ img [src userProfile.url, class "img-thumbnail"] []
            ]


homeCardList : List (Card.Config msg)
homeCardList = 
    [ homeCard "About" 
        [ "Homepage for Nicholas Gilbert (pictured above)"
        , "Written in Elm and utilizing Elm Bootstrap 4 for a responsive web experience."
        ]
    , homeCard "Progress" [ "This site is very much a work in progress" ]
    , homeCard "REST API Calls" [ "Pulls some GitHub profile data directly from Github via REST API calls!" ]
    ]


homeCard : String -> List (String) -> Card.Config msg
homeCard title body =
    Card.config [Card.outlinePrimary]
        |> Card.headerH5 [] [ text title ]
        |> Card.block []
            (List.map (\x -> Block.text [] [text x]) body)

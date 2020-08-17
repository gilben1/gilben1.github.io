module References exposing (..)

-- Common module import, holds models common definitions
import Common exposing(..)

import Html exposing (..)
import Html.Attributes exposing (..)

import Bootstrap.Grid as Grid
import Bootstrap.Grid.Row as Row 
import Bootstrap.Grid.Col as Col
import Bootstrap.Text as Text

viewReferences : Model -> List (Html Msg)
viewReferences model =
    [ Grid.row [Row.middleXs]
        [ Grid.col defaultColAlignment
            [ h1 [] [ text "References" ] ]
        ]
    , Grid.row [Row.middleXs]
        [ Grid.col defaultColAlignment
            [ i [] [text "References for icons and any attributions I need to make for the free resources I'm using in this site"]]
        ]
    , Grid.row [rowClass "" ]
        [ Grid.col [Col.textAlign Text.alignXsCenter, colClass ""]
            (licenseIcon "src/assets/coding_icon.png" "Freepik" "Freepik"
            ++ licenseIcon "src/assets/system.png" "Kirill Kazachek" "Kirill-Kazachek")
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
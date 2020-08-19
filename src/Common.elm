module Common exposing (Model, Msg(..), defaultRowAlignment, defaultColAlignment, colClass, rowClass, timeString)

--Pre-common module loads
import Github.Profile exposing (..)
import Github.RepoStats exposing (..)

import Browser
import Browser.Navigation as Nav
import Html exposing (..)
import Html.Attributes exposing (..)
import Url

import Bootstrap.Grid.Row as Row 
import Bootstrap.Grid.Col as Col
import Bootstrap.Text as Text
import Bootstrap.Tab as Tab
import Bootstrap.Accordion as Accordion
import Html.Events exposing (..)
import Time exposing (..)
import String exposing (fromInt)

type alias Model =
    { tabState : Tab.State
    , accordionState : Accordion.State
    , url : Url.Url
    , key : Nav.Key
    , profileState : Github.Profile.State
    , repoInfoState : Github.RepoStats.State
    , repoIssuesState : Github.RepoStats.State
    , timeZone : Time.Zone
    }



type Msg
    = TabMsg Tab.State
    | AccordionMsg Accordion.State
    | LinkClicked Browser.UrlRequest
    | UrlChanged Url.Url
    | GetTimeZone Time.Zone
    | ProfileMsg Github.Profile.Msg
    | RepoInfoMsg Github.RepoStats.Msg


defaultRowAlignment : List (Row.Option msg)
defaultRowAlignment =
    [Row.middleXs]

defaultColAlignment : List (Col.Option msg)
defaultColAlignment =
    [Col.textAlign Text.alignXsCenter]

colClass : String -> Col.Option msg
colClass className =
    Col.attrs [ class className ]

rowClass : String -> Row.Option msg
rowClass className = 
    Row.attrs [ class className ]

timeString : Model -> Time.Posix -> String
timeString model timeToConvert =
    let
        year = toYear model.timeZone timeToConvert 
                |> fromInt
        month = case toMonth model.timeZone timeToConvert of
                    Jan -> "January"
                    Feb -> "February"
                    Mar -> "March"
                    Apr -> "April"
                    May -> "May"
                    Jun -> "June"
                    Jul -> "July"
                    Aug -> "August"
                    Sep -> "September"
                    Oct -> "October"
                    Nov -> "November"
                    Dec -> "December"
        day = toDay model.timeZone timeToConvert
                |> fromInt
        hour = toHour model.timeZone timeToConvert
                |> fromInt
        minute = toMinute model.timeZone timeToConvert
                |> fromInt
    in
        month ++ " " ++ day ++ ", " ++ year ++ " at " ++ hour ++ ":" ++ minute
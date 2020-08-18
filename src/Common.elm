module Common exposing (Model, Msg(..), defaultRowAlignment, defaultColAlignment, colClass, rowClass)

--Pre-common module loads
import Profile exposing (..)
import RepoStats exposing (..)

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
import Http

type alias Model =
    { tabState : Tab.State
    , accordionState : Accordion.State
    , url : Url.Url
    , key : Nav.Key
    , profileState : Profile.State
    , repoInfoState : RepoStats.State
    }

type Msg
    = TabMsg Tab.State
    | AccordionMsg Accordion.State
    | LinkClicked Browser.UrlRequest
    | UrlChanged Url.Url
    | ProfileMsg Profile.Msg
    | RepoInfoMsg RepoStats.Msg


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
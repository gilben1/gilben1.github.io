module Common exposing (Model, Msg(..), defaultRowAlignment, defaultColAlignment)

import Browser
import Browser.Navigation as Nav
import Html exposing (..)
import Html.Attributes exposing (..)
import Url

import Bootstrap.Grid.Row as Row 
import Bootstrap.Grid.Col as Col
import Bootstrap.Grid as Grid
import Bootstrap.Text as Text
import Bootstrap.Tab as Tab
import Bootstrap.Accordion as Accordion
import Bootstrap.Carousel as Carousel

type alias Model =
    { tabState : Tab.State
    , accordionState : Accordion.State
    , carouselState : Carousel.State
    , url : Url.Url
    , key : Nav.Key
    }

type Msg
    = TabMsg Tab.State
    | AccordionMsg Accordion.State
    | CarouselMsg Carousel.Msg
    | LinkClicked Browser.UrlRequest
    | UrlChanged Url.Url

defaultRowAlignment : List (Row.Option msg)
defaultRowAlignment =
    [Row.middleXs]

defaultColAlignment : List (Col.Option msg)
defaultColAlignment =
    [Col.textAlign Text.alignXsCenter]
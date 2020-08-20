module Tabs.Stats exposing (viewStats)

import Common exposing (..)
import Github.RepoStats exposing (State(..))

import Html exposing (..)
import Html.Attributes exposing (..)

import Bootstrap.Grid as Grid
import Bootstrap.Grid.Row as Row 
import Bootstrap.Grid.Col as Col
import Bootstrap.Text as Text
import Bootstrap.Card.Block as Block 
import Bootstrap.Card as Card
import String exposing (fromInt)


viewStats : Model -> List (Html Msg)
viewStats model =
    [ Grid.row [Row.middleXs]
        [ Grid.col defaultColAlignment
            [ h1 [] [ text "Site and Repository Statistics" ] ]
        ]
    , Grid.row [Row.bottomXs, rowClass ""]
        [ Grid.col [Col.xl4, Col.lg3, Col.md2, Col.sm1] []
        , Grid.col defaultColAlignment
            [ Card.group (viewRepoStatsCards model) ]
        , Grid.col [Col.xl4, Col.lg3, Col.md2, Col.sm1] []
        ]
    , Grid.row [Row.bottomXs, rowClass ""]
        [ Grid.col [Col.xl4, Col.lg3, Col.md2, Col.sm1] []
        , Grid.col defaultColAlignment
            [ Card.group (viewRepoIssues model) ]
        , Grid.col [Col.xl4, Col.lg3, Col.md2, Col.sm1] []
        ]
    ]

viewRepoStatsCards : Model -> List (Card.Config msg)
viewRepoStatsCards model =
    case model.repoInfoState of
        Github.RepoStats.Failure ->
            [ statCard "Repo Stats"
                [ "Failed to load repository stats :(" ]
            ]
        Github.RepoStats.Loading ->
            [ statCard "Repo Stats"
                [ "Loading repository stats..." ]
            ]
        Github.RepoStats.InfoSuccess repoInfo ->
            [ statCard "Repo Stats"
                [ "Repo Name: " ++ repoInfo.name
                , "Repo initially created on " ++ Common.timeString model repoInfo.created_at
                , "Last push: " ++ Common.timeString model repoInfo.pushed_at
                , "Primary repo language: " ++ repoInfo.language
                , "Stats pulled via Github's native REST API"
                ]
            ]
        Github.RepoStats.IssueSuccess _ -> []


viewRepoIssues : Model -> List (Card.Config msg)
viewRepoIssues model =
    case model.repoIssuesState of
        Github.RepoStats.Failure ->
            [ statCard "Issues" 
                [ "Failed to load repository issues :(" ]
            ]
        Github.RepoStats.Loading ->
            [ statCard "Issues"
                [ "Loading repository issues..." ]
            ]
        Github.RepoStats.IssueSuccess issueList ->
            (List.map 
                (\x -> statCard ("Issue #" ++ fromInt x.number ++ ": " ++ x.title)
                    [ "\"" ++ x.body ++ "\""
                    , "State: " ++ x.state
                    , "Issue created: " ++ Common.timeString model x.created_at
                    , "Issue updated: " ++ Common.timeString model x.updated_at
                    , "Url (make this a link eventually): " ++ x.url 
                    ]
                ) issueList)
        Github.RepoStats.InfoSuccess _ -> []
            


statCard : String -> List (String) -> Card.Config msg
statCard title body =
    Card.config [Card.outlinePrimary]
        |> Card.headerH5 [] [ text title ]
        |> Card.block []
            (List.map (\x -> Block.text [] [text x]) body)

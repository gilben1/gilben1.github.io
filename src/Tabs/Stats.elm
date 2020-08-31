module Tabs.Stats exposing (viewStats)

import Common exposing (..)
import Github.RepoStats exposing (State(..), Issue)

import Html exposing (..)
import Html.Attributes exposing (..)

import Bootstrap.Grid as Grid
import Bootstrap.Grid.Row as Row 
import Bootstrap.Grid.Col as Col
import Bootstrap.Text as Text
import Bootstrap.Card.Block as Block 
import Bootstrap.Card as Card
import Bootstrap.Badge as Badge
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
    , Grid.row [Row.middleXs]
        [ Grid.col defaultColAlignment
            [ h2 [] [ text "Issues and Pull Requests" ] ]
        ]
    , repoIssues model
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
                , "Repo initially created on " ++ Common.timeString model repoInfo.created_at ++ " " ++ Common.timeAgo model repoInfo.created_at
                , "Last push: " ++ Common.timeString model repoInfo.pushed_at ++ " " ++ Common.timeAgo model repoInfo.pushed_at
                , "Primary repo language: " ++ repoInfo.language
                , "Stats pulled via Github's native REST API"
                ]
            ]
        Github.RepoStats.IssueSuccess _ -> []

            
repoIssues : Model -> Html msg
repoIssues model =
    case model.repoIssuesState of
        Github.RepoStats.Failure ->
            Grid.row [Row.topXs] 
                [ Grid.col [Col.textAlign Text.alignXsCenter]
                    [ text "Failed to load repository issues :(" ]
                ]
        Github.RepoStats.Loading ->
            Grid.row [Row.topXs]
                [ Grid.col [Col.textAlign Text.alignXsCenter]
                    [ text "Loading repository issues..." ]
                ]
        Github.RepoStats.IssueSuccess issueList ->
            Grid.row [Row.topXs]
                ( List.map (\x ->
                    Grid.col []
                        [ issueCard model x ]
                ) issueList ++ [ Grid.col [Col.xs, Col.sm, Col.md6, Col.lg, Col.xl9] []])
        Github.RepoStats.InfoSuccess _ ->
            Grid.row []
                [ Grid.col []
                    [ text "You shouldn't see this..." ]
                ]

statCard : String -> List (String) -> Card.Config msg
statCard title body =
    Card.config [Card.outlinePrimary]
        |> Card.headerH5 [] [ text title ]
        |> Card.block []
            (List.map (\x -> Block.text [] [text x]) body)

issueCard : Model -> Issue -> Html msg
issueCard model issue = 
    Card.config [Card.outlinePrimary]
        |> Card.headerH5 [] ([ text ("Issue #" ++ fromInt issue.number ++ " ") ] ++ isPR issue)
        |> Card.block []
            [ Block.titleH6 [] [ text issue.title ]
            , Block.quote [] [ text issue.body ]
            , Block.text [] 
                [ Grid.row [Row.middleXs]
                    [ Grid.col [Col.xs12, Col.sm, Col.textAlign Text.alignSmCenter, Col.textAlign Text.alignMdLeft]
                        [ text ("State: " ++ issue.state) ]
                    , Grid.col [Col.xs12, Col.sm, Col.textAlign Text.alignSmCenter, Col.textAlign Text.alignMdRight]
                         [ text ("Opened by " ++ issue.creator) ]
                    ]  
                ]
            , Block.link [ href issue.url ] [ text "Link" ]
            ]
        |> Card.footer [] 
            [ small [class "text-muted" ] 
                [ Grid.row [Row.middleXs]
                    [ Grid.col [Col.xs12, Col.sm, Col.textAlign Text.alignSmCenter, Col.textAlign Text.alignMdLeft]
                        [ text ("Created: " ++ Common.timeString model issue.created_at)]
                    , Grid.col [Col.xs12, Col.sm, Col.textAlign Text.alignSmCenter, Col.textAlign Text.alignMdRight]
                        [ text ("Last Updated: " ++ Common.timeString model issue.updated_at) ]
                    ]
                , Grid.row [Row.middleXs]
                    [ Grid.col [Col.xs12, Col.sm, Col.textAlign Text.alignSmCenter, Col.textAlign Text.alignMdLeft]
                        [ text (Common.timeAgo model issue.created_at)]
                    , Grid.col [Col.xs12, Col.sm, Col.textAlign Text.alignSmCenter, Col.textAlign Text.alignMdRight]
                        [ text (Common.timeAgo model issue.updated_at) ]
                    ]
                ]
            ] 
        |> Card.view



isPR : Issue -> List (Html msg)
isPR issue =
    case issue.pr_url of
       "NULL" -> []
       _ -> [Badge.badgeSecondary [] [ text "PR" ] ]
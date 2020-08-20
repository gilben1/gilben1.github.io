module Github.RepoStats exposing (State(..), RepoInfo, Issue, Msg(..), githubRepoDecoder, githubIssuesDecoder)

import Http

import Json.Decode as Decode exposing (Decoder, string, int, succeed)
import Json.Decode.Pipeline exposing (required, requiredAt, optionalAt)
import Json.Decode.Extra exposing (datetime)

import Time


type State
    = Failure
    | Loading
    | InfoSuccess RepoInfo
    | IssueSuccess (List Issue)

type alias RepoInfo =
    { created_at : Time.Posix
    , pushed_at : Time.Posix
    , language : String
    , name : String 
    , url : String
    }

type alias Issue =
    { url : String
    , number : Int
    , title : String
    , body : String
    , creator : String
    , created_at : Time.Posix
    , updated_at : Time.Posix
    , state : String
    , pr_url : String
    }

type Msg
    = RepoLoaded (Result Http.Error RepoInfo)
    | IssuesLoaded (Result Http.Error (List Issue))

githubRepoDecoder : Decoder RepoInfo
githubRepoDecoder =
    Decode.succeed RepoInfo
        |> required "created_at" datetime
        |> required "pushed_at" datetime
        |> required "language" string
        |> required "name" string
        |> required "html_url" string

singleIssueDecoder : Decoder Issue
singleIssueDecoder = 
    Decode.succeed Issue
        |> required "html_url" string
        |> required "number" int
        |> required "title" string
        |> required "body" string
        |> requiredAt ["user", "login"] string
        |> required "created_at" datetime
        |> required "updated_at" datetime
        |> required "state" string
        |> optionalAt ["pull_request", "html_url" ] string "NULL"

githubIssuesDecoder : Decoder (List Issue)
githubIssuesDecoder =
    Decode.list singleIssueDecoder
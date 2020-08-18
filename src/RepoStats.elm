module RepoStats exposing (State(..), RepoInfo, Msg(..), githubRepoDecoder)

import Http

import Json.Decode as Decode exposing (Decoder, int, string, float)
import Json.Decode.Pipeline exposing (required, optional, hardcoded)

type State
    = Failure
    | Loading
    | Success RepoInfo

type alias RepoInfo =
    { created_at : String
    , pushed_at : String
    , language : String
    , name : String 
    , url : String
    }

type Msg
    = RepoLoaded (Result Http.Error RepoInfo)

githubRepoDecoder : Decoder RepoInfo
githubRepoDecoder =
    Decode.succeed RepoInfo
        |> required "created_at" string
        |> required "pushed_at" string
        |> required "language" string
        |> required "name" string
        |> required "html_url" string
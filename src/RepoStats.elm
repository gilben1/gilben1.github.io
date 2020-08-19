module RepoStats exposing (State(..), RepoInfo, Msg(..), githubRepoDecoder)

import Http

import Json.Decode as Decode exposing (Decoder, string,  succeed)
import Json.Decode.Pipeline exposing (required)
import Json.Decode.Extra exposing (datetime)

import Time


type State
    = Failure
    | Loading
    | Success RepoInfo

type alias RepoInfo =
    { created_at : Time.Posix
    , pushed_at : Time.Posix
    , language : String
    , name : String 
    , url : String
    }

type Msg
    = RepoLoaded (Result Http.Error RepoInfo)

githubRepoDecoder : Decoder RepoInfo
githubRepoDecoder =
    Decode.succeed RepoInfo
        |> required "created_at" datetime
        |> required "pushed_at" datetime
        |> required "language" string
        |> required "name" string
        |> required "html_url" string

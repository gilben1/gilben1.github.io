module Profile exposing (State(..), Msg(..), githubProfileDecoder, UserProfile)

import Http

import Json.Decode as Decode exposing (Decoder, int, string, float)
import Json.Decode.Pipeline exposing (required, optional, hardcoded)

type State
    = Failure
    | Loading
    | Success UserProfile

type Msg
    = ProfileLoaded (Result Http.Error UserProfile)

type alias UserProfile =
    { url : String
    , bio : String
    }

githubProfileDecoder : Decoder UserProfile
githubProfileDecoder =
    Decode.succeed UserProfile
        |> required "avatar_url" string
        |> required "bio" string
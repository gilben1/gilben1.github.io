module Commands exposing (loadGithubProfile, githubDecoder)

import Common exposing(Msg(..))
import Profile exposing(State(..))

import Http
import Json.Decode exposing (Decoder, field, string)

loadGithubProfile : Cmd Profile.Msg
loadGithubProfile = 
    Http.get
        { url = "https://api.github.com/users/gilben1"
        , expect = Http.expectJson Profile.ProfileLoaded githubDecoder
        }

githubDecoder : Decoder String
githubDecoder =
    field "avatar_url" string
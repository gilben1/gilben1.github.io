module Commands exposing (loadGithubProfile)

import Common exposing(Msg(..))
import Profile exposing(State(..))

import Http

loadGithubProfile : Cmd Profile.Msg
loadGithubProfile = 
    Http.get
        { url = "https://api.github.com/users/gilben1"
        , expect = Http.expectJson Profile.ProfileLoaded Profile.githubProfileDecoder
        }

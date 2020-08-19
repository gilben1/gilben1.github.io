module Commands exposing (loadGithubProfile, loadGithubRepoInfo, getTimeZone)

import Common exposing(Msg(..),Model)
import Profile exposing(State(..))
import RepoStats exposing (State(..))

import Http
import Task
import Time exposing (..)
import Iso8601 exposing(..)

import Project exposing (RepoLink(..))

loadGithubProfile : Cmd Profile.Msg
loadGithubProfile = 
    Http.get
        { url = "https://api.github.com/users/gilben1"
        , expect = Http.expectJson Profile.ProfileLoaded Profile.githubProfileDecoder
        }

loadGithubRepoInfo : Cmd RepoStats.Msg
loadGithubRepoInfo =
    Http.get
        { url = "https://api.github.com/repos/gilben1/gilben1.github.io"
        , expect = Http.expectJson RepoStats.RepoLoaded RepoStats.githubRepoDecoder
        }

getTimeZone : Cmd Common.Msg
getTimeZone =
    Task.perform Common.GetTimeZone Time.here


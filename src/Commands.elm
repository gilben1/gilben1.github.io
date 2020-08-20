module Commands exposing (loadGithubProfile, loadGithubRepoInfo, loadGithubIssues, getTimeZone)

import Common exposing(Msg(..))
import Github.Profile exposing(State(..))
import Github.RepoStats exposing (State(..))

import Http
import Task
import Time exposing (here)


loadGithubProfile : Cmd Github.Profile.Msg
loadGithubProfile = 
    Http.get
        { url = "https://api.github.com/users/gilben1"
        , expect = Http.expectJson Github.Profile.ProfileLoaded Github.Profile.githubProfileDecoder
        }

loadGithubRepoInfo : Cmd Github.RepoStats.Msg
loadGithubRepoInfo =
    Http.get
        { url = "https://api.github.com/repos/gilben1/gilben1.github.io"
        , expect = Http.expectJson Github.RepoStats.RepoLoaded Github.RepoStats.githubRepoDecoder
        }

loadGithubIssues : Cmd Github.RepoStats.Msg
loadGithubIssues =
    Http.get
        { url = "https://api.github.com/repos/gilben1/gilben1.github.io/issues"
        , expect = Http.expectJson Github.RepoStats.IssuesLoaded Github.RepoStats.githubIssuesDecoder
        }

getTimeZone : Cmd Common.Msg
getTimeZone =
    Task.perform Common.GetTimeZone Time.here


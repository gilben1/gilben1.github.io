module Profile exposing (State(..), Msg(..))

import Http

type State
    = Failure
    | Loading
    | Success String

type Msg
    = ProfileLoaded (Result Http.Error String)
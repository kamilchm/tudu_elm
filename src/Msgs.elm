module Msgs exposing (..)

import Models exposing (Project)


type Msg 
    = LoadProjects ProjectsResponse


type alias ProjectsResponse =
    { projects : Maybe (List Project)
    , error : Maybe String
    }

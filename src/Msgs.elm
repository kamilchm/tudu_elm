module Msgs exposing (..)

import Models exposing (Task)


type Msg 
    = LoadTasks TasksResponse


type alias TasksResponse =
    { projects : Maybe (List Task)
    , error : Maybe String
    }

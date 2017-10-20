module Msgs exposing (..)

import Time exposing (Time)
import Models exposing (Task)


type Msg
    = LoadTasks TasksResponse
    | TimerTick Time
    | TimerStartNow
    | TimerStart Time
    | TimerStop


type alias TasksResponse =
    { projects : Maybe (List Task)
    , error : Maybe String
    }

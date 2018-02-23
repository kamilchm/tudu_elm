module Pomodoro exposing (Pomodoro, Started, Ended, Completed, start, complete, cancel)

import Date exposing (Date)


type alias Tags = List String

type alias Pomodoro = Started {}

type alias Started p = { p | start : Date }

type alias Ended p = Started { p | end : Date }

type alias Completed = 
   Ended
   { details : String
   , tags : Tags
   }


type alias Cancelled =
    Ended
    { details : Maybe String
    , tags : Tags
    }


start : Date -> Pomodoro
start date =
    { start = date }


complete : Date -> String -> Tags -> Pomodoro -> Completed
complete date details tags p =
    { start = p.start, end = date, details = details, tags = tags }


cancel : Date -> Maybe String -> Tags -> Pomodoro -> Cancelled
cancel date details tags p =
    { start = p.start, end = date, details = details, tags = tags }

module Pomodoro exposing (Pomodoro, start, complete, cancel)

import Date exposing (Date)


type Tags = List String

type alias Pomodoro = Started {}

type alias Started p = { p | start : Date }


type alias Completed = 
   Started
   { end : Date
   , details : String
   , tags : Tags
   }


type alias Cancelled =
    Started
    { end : Date
    , details : Maybe String
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

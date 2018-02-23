port module PortsStorage exposing (add, loading, Msg(..))

import Json.Encode as Encode exposing (object, string)
import Json.Decode as Decode exposing (Decoder, field, map3, string, float, list)
import Date exposing (toTime, Date)
import Time exposing (inMilliseconds)

import Pomodoro exposing (..)

port storePomodoro : Encode.Value -> Cmd msg

port loadPomodoros : (Encode.Value -> msg) -> Sub msg

type Msg
  = Loaded (List Completed)
  | LoadError String
  

add : Completed -> Cmd msg
add pomo =
    storePomodoro (Encode.object
        [ ("details", Encode.string pomo.details)
        , ("start", Encode.float (inMilliseconds (toTime pomo.start)))
        , ("end", Encode.float (inMilliseconds (toTime pomo.end)))
        ])

loading : Sub Msg
loading =
    loadPomodoros decodePomodoros


decodePomodoros : Decode.Value -> Msg
decodePomodoros json =
  case Decode.decodeValue pomodorosDecoder json of
    Ok pomodoros ->
      Loaded pomodoros
    Err err ->
      LoadError err

createCompleted : Date -> Date -> String -> List String -> Completed
createCompleted start end details tags =
    { start = start
    , end = end
    , details = details
    , tags = tags
    }

pomodorosDecoder : Decoder (List Completed)
pomodorosDecoder =
    Decode.list
    ( Decode.map4 createCompleted
        (Decode.field "start" (Decode.map Date.fromTime Decode.float))
        (Decode.field "end" (Decode.map Date.fromTime Decode.float))
        (Decode.field "details" Decode.string)
        (Decode.succeed [])
    )

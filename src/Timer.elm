module Timer exposing (Config, Context, view, isRunning, willEnd)

import Time exposing (Time)
import Date exposing (fromTime, minute)
import Html exposing (Html, div, h1, text, a, p, header, footer)
import Html.Attributes exposing (class, style)
import Html.Events exposing (onClick)


--- CONFIG


type alias Config msg =
    { startMsg : msg
    , stopMsg : msg
    }



--- CONTEXT


type alias Context =
    { now : Time
    , stop : Maybe Time
    }


isRunning : Context -> Bool
isRunning context =
    case context.stop of
        Nothing ->
            False

        Just stopTime ->
            if context.now < stopTime then
                True
            else
                False


willEnd : Context -> Time -> Bool
willEnd context newTime =
    isRunning context && not (isRunning { context | now = newTime} )


--- VIEW


view : Config msg -> Context -> Html msg
view config context =
    div [ class "card has-text-centered", style [ ( "margin", "1em" ) ] ]
        [ header [ class "header" ]
            [ p [ class "header-title" ] [ text "Time left" ]
            ]
        , div [ class "card-content" ]
            [ h1 [ class "title is-1" ]
                [ text (format (timeLeft context))
                ]
            ]
        , footer [ class "card-footer" ]
            [ if isRunning context then
                a [ class "card-footer-item", onClick config.stopMsg ] [ text "Stop" ]
              else
                a [ class "card-footer-item", onClick config.startMsg ] [ text "Start" ]
            ]
        ]


timeLeft : Context -> Time
timeLeft context =
    if isRunning context then
        (Maybe.withDefault context.now context.stop) - context.now
    else
        0


format : Time -> String
format time =
    (extract Date.minute time) ++ ":" ++ (extract Date.second time)


extract : (Date.Date -> Int) -> Time -> String
extract part time =
    time
        |> fromTime
        |> part
        |> toString
        |> String.padLeft 2 '0'

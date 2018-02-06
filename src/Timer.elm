module Timer exposing (Config, Context, view, isRunning)

import Time exposing (Time)
import Date exposing (fromTime, minute)
import Html exposing (Html, div, h1, text, a, p, header, footer)
import Html.Attributes exposing (class, style)
import Html.Events exposing (onClick)


--- CONFIG


type alias Config msg =
    { startMsg : msg
    , cancelMsg : msg
    }



--- CONTEXT


type alias Context =
    { now : Time
    , stop : Time
    }


isRunning : Context -> Bool
isRunning context =
    if context.now < context.stop then
        True
    else
        False


--- VIEW


view : Config msg -> Maybe Context -> Html msg
view config context =
    div [ class "card has-text-centered", style [ ( "margin", "1em" ) ] ]
        [ header [ class "header" ]
            [ p [ class "header-title" ] [ text "Time left" ]
            ]
        , div [ class "card-content" ]
            [ h1 [ class "title is-1" ]
                [ text (format (
                    case context of
                        Nothing -> 0
                        Just context -> timeLeft context
                    ))
                ]
            ]
        , footer [ class "card-footer" ]
            [ case context of
                Just _ -> a [ class "card-footer-item", onClick config.cancelMsg ] [ text "Cancel" ]
                Nothing -> a [ class "card-footer-item", onClick config.startMsg ] [ text "Start" ]
            ]
        ]


timeLeft : Context -> Time
timeLeft context =
    context.stop - context.now


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

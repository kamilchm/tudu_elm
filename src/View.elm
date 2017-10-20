module View exposing (..)

import Html exposing (Html, map, div, text, a, node)
import Html.Attributes exposing (class, href, attribute)
import Msgs exposing (Msg)
import Models exposing (Model)
import Tasks.List
import Timer


timerConfig : Timer.Config Msg
timerConfig =
    { startMsg = Msgs.TimerStartNow
    , stopMsg = Msgs.TimerStop
    }


view : Model -> Html Msg
view model =
    div []
        [ node "nav"
            [ attribute "aria-label" "main navigation", class "navbar container is-fluid is-info", attribute "role" "navigation" ]
            [ div [ class "navbar-brand" ]
                [ a [ class "navbar-item", href "#" ] [ text "tudu" ]
                , a [ class "navbar-item", href "#" ] [ text "Tasks" ]
                , a [ class "navbar-item", href "#" ] [ text "Pomodoros" ]
                ]
            ]
        , div [ class "columns is-centered" ]
            [ div [ class "column is-one-third" ]
                [ Timer.view timerConfig model.timer
                ]
            ]
        , div [ class "columns is-centered" ]
            [ div [ class "column is-11" ]
                [ content model
                ]
            ]
        ]


content : Model -> Html Msg
content model =
    Tasks.List.view model.tasks

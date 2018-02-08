module Bulma.View exposing (view)

import Date exposing (Date)

import Html exposing (Html, map, div, text, a, node, label, input, p, button, article)
import Html.Attributes exposing (class, href, attribute, placeholder, type_, value)
import Html.Events exposing (onClick, onInput)

import Pomodoro exposing (..)
import App exposing (Model(..), Msg(..))
import Bulma.Timer as Timer exposing (..)


timerConfig : Timer.Config Msg
timerConfig =
    { startMsg = TimerStartNow 
    , cancelMsg = TimerCancel
    }


view : Model -> Html Msg
view model =
    div []
        ([ node "nav"
            [ attribute "aria-label" "main navigation", class "navbar container is-fluid is-info", attribute "role" "navigation" ]
            [ div [ class "navbar-brand" ]
                [ a [ class "navbar-item", href "#" ] [ text "tudu" ]
                , a [ class "navbar-item", href "#" ] [ text "Tasks" ]
                , a [ class "navbar-item", href "#" ] [ text "Pomodoros" ]
                ]
            ]
        , div [ class "columns is-centered" ]
            [ div [ class "column is-one-third" ]
                [ Timer.view timerConfig (case model of
                        Running _ _ timerEnd now -> Just { stop = timerEnd, now = now }
                        _ -> Nothing
                    )
                ]
            ]
        ]
        ++ case model of
            Waiting state ->
                [ div [ class "box" ]
                    [ article [ class "media" ]
                        [ div [ class "media-content" ]
                            [ div [ class "content" ] ( List.map viewPomodoro state.pomodoros ) ]
                        ]
                    ]
                ]
            _ -> []
        ++ case model of
            Submitting state pomodoro date description ->
                [ div [ class "modal is-active" ]
                    [ div [ class "modal-background" ]
                        []
                    , div [ class "modal-content" ]
                        [ submitForm date description ]
                    ]
                ]
            _ -> []
        )


viewPomodoro : Completed -> Html Msg
viewPomodoro pomodoro =
    p [] [ text pomodoro.details ]


submitForm : Date -> String -> Html Msg
submitForm date description =
    div [ class "box" ]
        [ div [ class "field" ]
            [ label [ class "label" ]
                [ text "What did you do?" ]
            , div [ class "control" ]
                [ input [ class "input"
                        , placeholder "something interesting..."
                        , type_ "text"
                        , value description
                        , onInput (SubmitChange date)
                        ]
                    []
                ]
            , p [ class "help" ]
                [ text "Describe your work" ]
            , div [ class "control" ]
                [ button [ class "button is-primary", onClick Submit ]
                    [ text "Submit" ]
                ]
            ]
         ]

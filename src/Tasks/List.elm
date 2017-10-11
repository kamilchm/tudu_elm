module Tasks.List exposing (..)

import Html exposing (Html, section, nav, a, div, text, span, i)
import Html.Attributes exposing (class, attribute)
import Msgs exposing (Msg)
import Models exposing (Task)


view : List Task -> Html Msg
view tasks =
    section [ class "section" ]
        [ nav [ class "panel column" ] (List.map taskRow tasks)
        ]


taskRow : Task -> Html Msg
taskRow task =
    a [ class "panel-block" ]
        [ div [ class "column is-two-thirds" ]
            [ span [ class "icon" ] [ i [ class "fa fa-circle-o" ] [] ]
            , text task.title
            ]
        , div [ class "column" ]
            [ span [ class "tag is-primary" ] [ text task.project ]
            ]
        , div [ class "column has-text-right" ]
            [ span [ class "icon" ] [ i [ class "fa fa-edit" ] [] ]
            ]
        ]

module View exposing (..)

import Html exposing (Html, div, text, a, node)
import Html.Attributes exposing (class, href, attribute)
import Msgs exposing (Msg)
import Models exposing (Model)
import Tasks.List


view : Model -> Html Msg
view model =
    div []
        [ node "nav"
            [ attribute "aria-label" "main navigation", class "navbar container is-fluid is-info", attribute "role" "navigation" ]
            [ div [ class "navbar-brand" ]
                [ a [ class "navbar-item", href "#" ] [ text "tudu" ]
                , a [ class "navbar-item", href "#" ] [ text "Tasks" ]
                ]
            ]
        , content model
        ]


content : Model -> Html Msg
content model =
    Tasks.List.view model.tasks

module View exposing (..)


import Html exposing (Html, div, text)
import Html.Attributes exposing (class)

import Msgs exposing (Msg)
import Models exposing (Model)
import Projects.List



view : Model -> Html Msg
view model =
    div []
        [ div [ class "error" ] [ text ( Maybe.withDefault "" model.error ) ]
        , page model
        ]


page : Model -> Html Msg
page model =
    Projects.List.view model.projects

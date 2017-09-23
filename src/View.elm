module View exposing (..)


import Html exposing (Html, div, text)
import Html.Attributes exposing (class)

import GraphQL.Client.Http as GraphQLClient

import Update exposing (Msg)
import Models exposing (Model)
import Projects.List



view : Model -> Html Msg
view model =
    div []
        [ error model.error
        , page model
        ]


page : Model -> Html Msg
page model =
    Projects.List.view model.projects


error : Maybe GraphQLClient.Error -> Html Msg
error error =
    case error of
        Just error ->
            case error of
                GraphQLClient.HttpError _ ->
                    div [ class "error" ] [ text "http error" ]

                GraphQLClient.GraphQLError _ ->
                    div [ class "error" ] [ text "graphql error" ]

        Nothing ->
            div [ class "error" ] []

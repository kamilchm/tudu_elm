module Commands exposing (loadProjects)

import GraphQL.Request.Builder exposing (..)
import GraphQL.Client.Http as GraphQLClient

import Task exposing (Task)

import Models exposing (Model, Project)
import Msgs exposing (Msg)


loadProjects : Cmd Msg
loadProjects =
    let
        project =
            object Project
                |> with (field "id" [] string)
                |> with (field "name" [] string)

        queryRoot =
            extract
                (field "allProjects" [] (list project))
    in
        queryDocument queryRoot
            |> request {}
            |> GraphQLClient.sendQuery "http://localhost:4000/"
            |> Task.attempt processProjectsResponse


processProjectsResponse : Result GraphQLClient.Error (List Project) -> Msg
processProjectsResponse result =
    case result of
        (Ok projects) ->
            Msgs.LoadProjects { projects = Just projects, error = Nothing }

        (Err error) ->
            Msgs.LoadProjects { error = Just (toText error), projects = Nothing }


toText : GraphQLClient.Error -> String
toText error =
    case error of
        GraphQLClient.HttpError error ->
            toString error

        GraphQLClient.GraphQLError errors ->
            List.map .message errors
                |> String.join "\n"

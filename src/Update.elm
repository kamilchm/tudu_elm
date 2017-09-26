module Update exposing (..)

import GraphQL.Request.Builder exposing (..)
import GraphQL.Client.Http as GraphQLClient

import Task exposing (Task)

import Models exposing (Model, Project)


type alias ProjectsResponse =
    { projects : Maybe (List Project)
    , error : Maybe String
    }


type Msg 
    = LoadProjects ProjectsResponse


update : Msg -> Model -> ( Model, Cmd Msg)
update msg model =
    case msg of
        LoadProjects pr ->
            case pr.error of
                Nothing ->
                    ( { model | projects = (Maybe.withDefault [] pr.projects) }, Cmd.none )

                Just error ->
                    ( { model | error = Just error }, Cmd.none )


projectsQuery : Document Query (List Project) {}
projectsQuery =
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


projectsQueryRequest : Request Query (List Project)
projectsQueryRequest =
    projectsQuery
        |> request {}


sendProjectsQuery : Cmd Msg
sendProjectsQuery =
    sendProjectsRequest projectsQueryRequest
        |> Task.attempt processProjectsResponse


sendProjectsRequest : Request Query a -> Task GraphQLClient.Error a
sendProjectsRequest request =
    GraphQLClient.sendQuery "http://localhost:4000/" request


processProjectsResponse : Result GraphQLClient.Error (List Project) -> Msg
processProjectsResponse result =
    case result of
        (Ok projects) ->
            LoadProjects { projects = Just projects, error = Nothing }

        (Err error) ->
            LoadProjects { error = Just (toText error), projects = Nothing }


toText : GraphQLClient.Error -> String
toText error =
    case error of
        GraphQLClient.HttpError error ->
            toString error

        GraphQLClient.GraphQLError errors ->
            List.map .message errors
                |> String.join "\n"

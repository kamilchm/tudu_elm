module Update exposing (..)

import GraphQL.Request.Builder exposing (..)
import GraphQL.Client.Http as GraphQLClient

import Task exposing (Task)

import Models exposing (Model, Project)


type alias ProjectsResponse =
    { projects : (List Project)
    , error : Maybe String
    }


type Msg 
    = LoadProjects (Result GraphQLClient.Error (List Project))

update : Msg -> Model -> ( Model, Cmd Msg)
update msg model =
    case msg of
        LoadProjects (Ok projects) ->
            ( { model | projects = projects }, Cmd.none )

        LoadProjects (Err err) ->
            ( { model | error = Just err }, Cmd.none )


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
        |> Task.attempt LoadProjects


sendProjectsRequest : Request Query a -> Task GraphQLClient.Error a
sendProjectsRequest request =
    GraphQLClient.sendQuery "http://localhost:4000/" request

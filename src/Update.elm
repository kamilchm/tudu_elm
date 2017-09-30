module Update exposing (..)

import Models exposing (Model, Project)
import Msgs exposing (Msg, ProjectsResponse)


update : Msg -> Model -> ( Model, Cmd Msg)
update msg model =
    case msg of
        Msgs.LoadProjects pr ->
            case pr.error of
                Nothing ->
                    ( { model | projects = (Maybe.withDefault [] pr.projects) }, Cmd.none )

                Just error ->
                    ( { model | error = Just error }, Cmd.none )

module Update exposing (..)

import Models exposing (Model)
import Msgs exposing (..)
import Time exposing (every, second, minute)
import Task exposing (perform)
import Timer exposing (isRunning)


-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    if Timer.isRunning model.timer then
        every second TimerTick
    else
        Sub.none



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        TimerTick newTime ->
            let
                oldTimer =
                    model.timer
            in
                ( { model | timer = { oldTimer | now = newTime } }, Cmd.none )

        TimerStart time ->
            let
                oldTimer =
                    model.timer
            in
                ( { model | timer = { oldTimer | now = time, stop = Just (time + 25 * minute) } }, Cmd.none )

        TimerStartNow ->
            ( model, Task.perform TimerStart Time.now )

        TimerStop ->
            ( { model | timer = { stop = Nothing, now = 0 } }, Cmd.none )

        _ ->
            ( model, Cmd.none )

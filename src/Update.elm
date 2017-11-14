module Update exposing (..)

import Models exposing (Model)
import Msgs exposing (..)
import Time exposing (every, second, minute)
import Task exposing (perform)
import Timer exposing (isRunning, willEnd)
import Ports exposing (pomoEnd)


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
                oldTimer = model.timer
            in
                ( { model | timer = { oldTimer | now = newTime } }
                , if Timer.willEnd oldTimer newTime then
                    pomoEnd "Have a break!"
                  else
                    Cmd.none
                )

        TimerStart now ->
            let
                oldTimer =
                    model.timer
            in
                ( { model | timer = { oldTimer | now = now, stop = Just (now + model.config.pomoTime + (0.5 * second)) } }, Cmd.none )

        TimerStartNow ->
            ( model, Task.perform TimerStart Time.now )

        TimerStop ->
            ( { model | timer = { stop = Nothing, now = 0 } }, Cmd.none )

        _ ->
            ( model, Cmd.none )

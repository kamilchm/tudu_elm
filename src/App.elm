module App exposing (..)

import Date exposing (Date, fromTime)
import Time exposing (Time, every, second, minute)
import Task exposing (perform)
import Ports exposing (pomoEnd, logError)

import Pomodoro exposing (..)

-- MODEL


type alias Config =
    { pomoTime : Time
    }


type alias State =
    { pomodoros : List Completed
    , error : Maybe String
    , config : Config
    }


type alias TimerEnd = Time
type alias Now = Time
type Model 
    = Waiting State
    | Running State Pomodoro TimerEnd Now
    | Submitting State Pomodoro Date String


initialModel : Model
initialModel = Waiting
    { pomodoros = []
    , error = Nothing
    , config = { pomoTime = 25 * 60 * second }
    --, config = { pomoTime = 5 * second }
    }


-- MSGS


type Msg
    = TimerTick Time
    | TimerStart
    | TimerStartAt Time
    | TimerCancel
    | TimerStop
    | SubmitChange Date String
    | Submit


-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    case model of
        Running _ _ _ _ -> every second TimerTick
        _ -> Sub.none


-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model = case model of
    Waiting state -> case msg of
        TimerStart ->
            ( model, Task.perform TimerStartAt Time.now )
        TimerStartAt now ->
            ( Running state ( start ( fromTime now ) )
                      ( now + state.config.pomoTime + (0.5 * second ) ) now
            , Cmd.none )
        _ -> incorrectMsg msg model

    Running state pomodoro timerEnd now -> case msg of
        TimerTick newTime ->
            if timerEnd <= newTime then
                update TimerStop model
            else
                ( Running state pomodoro timerEnd newTime, Cmd.none )
        TimerCancel -> ( Waiting state, Cmd.none )
        TimerStop -> ( (Submitting state pomodoro ( fromTime now ) "")
                     , pomoEnd "Have a break!" )
        _ -> incorrectMsg msg model

    Submitting state pomodoro date description -> case msg of
        SubmitChange date description ->
            ( Submitting state pomodoro date description, Cmd.none )
        Submit ->
            let
                pomodoros = ( pomodoro |> complete date description [] ) :: state.pomodoros
            in
                ( Waiting { state | pomodoros = pomodoros }
                , Cmd.none
                )
        _ -> incorrectMsg msg model


incorrectMsg : Msg -> Model -> ( Model, Cmd Msg )
incorrectMsg msg model =
    ( model, logError
        ("Incorrect messgage " ++ (toString msg) ++ " in state " ++ toString(model)) )

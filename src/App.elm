module App exposing (..)

import Date exposing (Date, fromTime)
import Time exposing (Time, every, second, minute)
import Task exposing (perform)

import Ports exposing (pomoEnd, logError)

import PortsStorage as Store exposing (add, loading, Msg(..))

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
    = Loading State
    | Waiting State
    | Running State Pomodoro TimerEnd Now
    | Submitting State Pomodoro Date String


initialModel : Model
initialModel = Loading
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
    | Loaded (List Completed)
    | LoadError String


-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    case model of
        Loading _ -> Sub.map (\msg -> case msg of
                                    Store.Loaded pomos -> Loaded pomos
                                    Store.LoadError err -> LoadError err) Store.loading
        Running _ _ _ _ -> every second TimerTick
        _ -> Sub.none


-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model = case model of
    Loading state -> case msg of
        Loaded pomodoros ->
            ( Waiting { state | pomodoros = pomodoros }, Cmd.none)
        _ -> incorrectMsg msg model
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
                newPomo = pomodoro |> complete date description []
                pomodoros = newPomo :: state.pomodoros
            in
                ( Waiting { state | pomodoros = pomodoros }
                , Store.add newPomo
                )
        _ -> incorrectMsg msg model


incorrectMsg : Msg -> Model -> ( Model, Cmd Msg )
incorrectMsg msg model =
    ( model, logError
        ("Incorrect messgage " ++ (toString msg) ++ " in state " ++ toString(model)) )

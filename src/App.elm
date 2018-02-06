module App exposing (..)

import Time exposing (Time, every, second, minute)
import Task exposing (perform)
import Timer exposing (Context, isRunning)
import Ports exposing (pomoEnd)

import Html exposing (Html, map, div, text, a, node)
import Html.Attributes exposing (class, href, attribute)

import Pomodoro exposing (..)

-- MODEL


type alias Config =
    { pomoTime : Time
    }


type alias State =
    { pomodoros : List Pomodoro
    , error : Maybe String
    , config : Config
    }


type Model 
    = Waiting State
    | Running State Timer.Context


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
    | TimerStartNow
    | TimerStart Time
    | TimerCancel
    | TimerStop


-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    case model of
        Running _ _ -> every second TimerTick
        _ -> Sub.none


-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        TimerTick newTime ->
            case model of
                Running state timer ->
                    if timer.stop <= newTime then
                        update TimerStop model
                    else
                        ( Running state { timer | now = newTime }, Cmd.none )
                _ -> ( model, Cmd.none )

        TimerStart now ->
            case model of
                Waiting state ->
                    ( Running state { now = now, stop = now + state.config.pomoTime + (0.5 * second) }, Cmd.none )
                _ -> ( model, Cmd.none )

        TimerStartNow ->
            ( model, Task.perform TimerStart Time.now )

        TimerCancel ->
            case model of
                Running state _ -> ( Waiting state, Cmd.none )
                _ -> ( model, Cmd.none )

        TimerStop ->
            case model of
                Running state _ -> ( Waiting state, pomoEnd "Have a break!" )
                _ -> ( model, Cmd.none )


timerConfig : Timer.Config Msg
timerConfig =
    { startMsg = TimerStartNow 
    , cancelMsg = TimerCancel
    }


view : Model -> Html Msg
view model =
    div []
        [ node "nav"
            [ attribute "aria-label" "main navigation", class "navbar container is-fluid is-info", attribute "role" "navigation" ]
            [ div [ class "navbar-brand" ]
                [ a [ class "navbar-item", href "#" ] [ text "tudu" ]
                , a [ class "navbar-item", href "#" ] [ text "Tasks" ]
                , a [ class "navbar-item", href "#" ] [ text "Pomodoros" ]
                ]
            ]
        , div [ class "columns is-centered" ]
            [ div [ class "column is-one-third" ]
                [ Timer.view timerConfig (case model of
                        Running _ timer -> Just timer
                        _ -> Nothing
                    )
                ]
            ]
        ]

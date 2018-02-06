module Main exposing (..)

import Html exposing (program)
import App exposing (Model, initialModel, Msg, update, subscriptions, view)


init : ( Model, Cmd Msg )
init =
    ( initialModel, Cmd.none )



-- MAIN


main : Program Never Model Msg
main =
    program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }

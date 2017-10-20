module Main exposing (..)

import Html exposing (program)
import Models exposing (Model, initialModel)
import Msgs exposing (Msg)
import Update exposing (update, subscriptions)
import View exposing (view)


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

module Main exposing (..)


import Html exposing (program)
import Models exposing (Model, initialModel)
import Update exposing (update, Msg, sendProjectsQuery)
import View exposing (view)



init : ( Model, Cmd Msg )
init =
    ( initialModel, sendProjectsQuery )



subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- MAIN


main : Program Never Model Msg
main =
    program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }

module Projects.List exposing (..)


import Html exposing (..)
import Html.Attributes exposing (class)
import Update exposing (Msg)
import Models exposing (Project)


view : List Project -> Html Msg
view projects =
    div []
        [ nav
        , list projects
        ]


nav : Html Msg
nav =
    div [ class "clearfix mb2 white bg-black" ]
        [ div [ class "left p2" ] [ text "Projects" ]
        ]
        

list : List Project -> Html Msg
list projects =
    div [ class "p2" ]
        [ ul [] ( List.map projectRow projects ) ]


projectRow : Project -> Html Msg
projectRow project =
    li []
        [ text project.name ]

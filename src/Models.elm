module Models exposing (..)

import GraphQL.Client.Http as GraphQLClient


type alias Model =
    { projects : List Project
    , error : Maybe GraphQLClient.Error
    }


initialModel : Model
initialModel =
    { projects = []
    , error = Nothing
    }


type alias ProjectId =
    String


type alias Project =
    { id : ProjectId
    , name : String
    }


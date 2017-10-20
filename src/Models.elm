module Models exposing (..)

import Timer exposing (Context)


type alias Task =
    { id : Int
    , title : String
    , project : String
    , completed : Bool
    }


type alias Pomodoro =
    { id : Int
    , start : String
    , end : String
    , completed : Bool
    , taskId : Int
    }


type alias Model =
    { tasks : List Task
    , pomodoros : List Pomodoro
    , error : Maybe String
    , timer : Timer.Context
    }


initialModel : Model
initialModel =
    { tasks = initialTasks
    , pomodoros = initialPomodoros
    , error = Nothing
    , timer = { now = 0, stop = Nothing }
    }


initialTasks : List Task
initialTasks =
    [ { id = 1, title = "Build rocket", project = "Go to the Moon", completed = False }
    , { id = 2, title = "Make space rocket fuel", project = "Go to the Moon", completed = False }
    , { id = 3, title = "Bananas", project = "Shopping list", completed = False }
    , { id = 4, title = "Carrots", project = "Shopping list", completed = False }
    , { id = 5, title = "Buy tickets", project = "Marathon", completed = False }
    ]


initialPomodoros : List Pomodoro
initialPomodoros =
    [ { id = 1, start = "2017-09-10 09:00", end = "2017-09-10 09:25", completed = True, taskId = 3 }
    , { id = 2, start = "2017-09-10 09:30", end = "2017-09-10 09:55", completed = True, taskId = 2 }
    , { id = 3, start = "2017-09-10 10:15", end = "2017-09-10 10:30", completed = False, taskId = 1 }
    ]

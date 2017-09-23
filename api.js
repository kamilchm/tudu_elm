var express = require('express')
var cors = require('cors')
var jsonGraphqlServer = require('json-graphql-server')

const PORT = 4000;
const app = express()
app.use(cors())

const data = {
    projects: [
        {id: 1, name: 'Go to the Moon'},
        {id: 2, name: 'Shopping list'},
        {id: 3, name: 'Marathon'},
    ],
    tasks: [
        {id: 1, title: 'Build rocket', project_id: 1},
        {id: 2, title: 'Make space rocket fuel', project_id: 1},
        {id: 3, title: 'Bananas', project_id: 2},
        {id: 4, title: 'Carrots', project_id: 2},
        {id: 5, title: 'Buy tickets', project_id: 3},
    ],
    pomodoros: [
        {id: 1, start: new Date(2017,9,10,9,0), end: new Date(2017,9,10,9,25), completed: true, task_id: 3},
        {id: 2, start: new Date(2017,9,10,9,30), end: new Date(2017,9,10,9,55), completed: true, task_id: 2},
        {id: 3, start: new Date(2017,9,10,10,15), end: new Date(2017,9,10,10,30), completed: false, task_id: 1},
    ],
};

app.use('/', jsonGraphqlServer.jsonGraphqlExpress(data))

console.log(`Listening at ${PORT}`)
app.listen(PORT)

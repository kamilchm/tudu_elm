import Dexie from 'dexie';

var db = new Dexie('tudu');

db.version(1).stores({
    pomodoros: '++start,end,details'
});

export function add(pomodoro) {
    db.pomodoros.add(pomodoro).catch(function(error) {
        console.error(error)
    })
}

export function load(callback) {
    db.pomodoros.orderBy('start').reverse().toArray(callback)
}

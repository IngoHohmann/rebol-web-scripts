Rebol [
    title: "jsPanel Test"
    author: "Ingo Hohmann"
    type: module
    date: 2019-11-06
    file: https://raw.githubusercontent.com/IngoHohmann/rebol-web-scripts/master/jspanel-test.r
    note: "Basic test of jspanel usage"
    link: https://jspanel.de/getstarted.html
    usage: --[
        jspanel
        openPanel
    ]--
]

export jspanel: js-awaiter [
    "load the jspanel library"
    return: []
] --[
    let promise1 = new Promise( function(resolve, reject) {
        var script = document.createElement( 'script')
        script.src = "https://cdn.jsdelivr.net/npm/jspanel4@4.6.0/dist/jspanel.js"
        document.head.appendChild( script)
        script.onload = function() {
            resolve()
        }
        script.onerror = function(event) {
            reject(new Error("Failed to load: " + script.src))
        }
    })
    let promise2 = new Promise( function(resolve, reject) {
        var style = document.createElement( 'link')
        style.rel = "stylesheet"
        style.href = "https://cdn.jsdelivr.net/npm/jspanel4@4.6.0/dist/jspanel.css"
        document.head.appendChild( style)
        style.onload = function() {
            resolve()
        }
        style.onerror = function(event) {
            reject(new Error("Failed to load: " + style.href))
        }
    })
    return new Promise(function(resolve, reject) {
        Promise.all([promise1, promise2])  // default resolve is an array
            .then(() => resolve())  // need to resolve with at most one value
            .catch(reject)
    })
]--

export openPanel: js-native [
    "open a jspanel testwindow"
] --[
    jsPanel.create()
]--

Rebol [
    title: "JSFrame Test"
    author: "Ingo Hohmann"
    date: 2019-11-06
    file: https://raw.githubusercontent.com/IngoHohmann/rebol-web-scripts/master/jsframe-test.r
    note: "Test to open a jsframe window"
    link: https://github.com/riversun/JSFrame.js
]

jsframe: js-awaiter [
    "load the jsframe library"
    return: []
] --[
    return new Promise( function(resolve, reject) {
        var script = document.createElement( 'script')
        script.src = "https://riversun.github.io/jsframe/jsframe.js"
        document.head.appendChild( script)
        script.onload = function() {
            var jsFrame = new JSFrame()
            resolve()
        }
        script.onerror = function(event) {
            reject(new Error("Failed to load: " + script.src))
        }
    })
]--

openFrame: js-native [
  "Open a jsframe testwindow"
] --[
    if (!jsFrame) {
        var jsFrame = new JSFrame()
    }
    frame = jsFrame.create({
        title: 'Window',
        left: 20, top: 20, width: 320, height: 220,
        movable: true,//Enable to be moved by mouse
        resizable: true,//Enable to be resized by mouse
        html: '<div id="my_element" style="padding:10px;font-size:12px;color:darkgray;">Contents of window</div>'
    });
]--

Rebol [
   title: "Web Top"
   author: "Ingo Hohmann"
   note: "Uses jspanel to create app windows"
]

jspanel: js-awaiter [
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

openPanel: js-native [
    "open a jspanel testwindow"
    json [text!]
] --[
    console.log( reb.Spell( "json"))
    jsPanel.create( JSON.parse( reb.Spell( "json")))
]--

testPanel: js-native [
    "open a jspanel testwindow"
] --[
    jsPanel.create({
      headerTitle: "Test",
      content: "<div id=\"test\">testing ...</div>"
   })
]--


rebPanel: js-native [
   "Move Rebol console into jsPanel"
] --[
   jsPanel.create({
      headerTitle: "Rebol Console",
      content: "<div id=\"newConsole\"></div>"
   })
   cons = document.getElementById( "replcontainer")
   document.getElementById( "newConsole").appendChild( cons)
]--

app: make object! [
   init: method [][
      jspanel
      rebPanel
   ]
   add: method [
      "Add a new App Panel"
      definition [block!]
   ][
      json: reword --[{
         "headerTitle": "$title",
         "content": "$content"
      }]-- definition
      openPanel json
   ]
]

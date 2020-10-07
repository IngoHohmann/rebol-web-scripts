REBOL [
  Title: "Web Top"
  Author: "Ingo Hohmann"
  Note: {Uses jspanel to create app windows}
]

jspanel: js-native [
    "load the jspanel library"
]{
   var script = document.createElement( 'script')
   script.src = "https://cdn.jsdelivr.net/npm/jspanel4@4.6.0/dist/jspanel.js"
   document.head.appendChild( script)
   var style = document.createElement( 'link')
   style.rel = "stylesheet"
   style.tyoe = "text/css"
   style.href = "https://cdn.jsdelivr.net/npm/jspanel4@4.6.0/dist/jspanel.css"
   document.head.appendChild( style)
}

openPanel: js-native [
    "open a jspanel testwindow"
    json [text!]
]{
    console.log( reb.Spell( reb.ArgR( "json")))
    jsPanel.create(JSON.parse( reb.Spell( reb.ArgR( "json"))))
}

testPanel: js-native [
    "open a jspanel testwindow"
]{
    jsPanel.create({
      headerTitle: "Test",
      content: "<div id=\"test\">testing ...</div>"
   })
}


rebPanel: js-native [
   "Move Rebol console into jsPanel"
]{
   jsPanel.create({
      headerTitle: "Rebol Console",
      content: "<div id=\"newConsole\"></div>"
   })
   cons = document.getElementById( "replcontainer")
   document.getElementById( "newConsole").appendChild( cons)
}

app: make object! [
   init: method [][
      jspanel
      rebPanel
   ]
   add: method [
      "Add a new App Panel"
      definition [block!]
   ][
      json: reword {{
         "headerTitle": "$title",
         "content": "$content"
      }} definition
      -- json
      openPanel json
   ]
]

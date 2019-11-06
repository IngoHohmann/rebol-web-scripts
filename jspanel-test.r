REBOL [
  Title: "jsPanel Test"
  Author: "Ingo Hohmann"
  Date: 2019-11-06
  Note: "Basic test of jspanel usage"
  link: https://jspanel.de/getstarted.html
]

jspanel: js-native[]{
   var script = document.createElement( 'script')
   script.src = "https://cdn.jsdelivr.net/npm/jspanel4@4.6.0/dist/jspanel.js"
   document.head.appendChild( script)
   var style = document.createElement( 'link')
   style.rel = "stylesheet"
   style.tyoe = "text/css"
   style.href = "https://cdn.jsdelivr.net/npm/jspanel4@4.6.0/dist/jspanel.css"
   document.head.appendChild( style)
   script.onload = function() {var jsPanel = new JSFrame();}
}

openPanel: js-native[]{
    jsPanel.create()
}

REBOL [
  Title: "jsPanel Test"
  Author: "Ingo Hohmann"
  Date: 2019-11-06
  File: https://raw.githubusercontent.com/IngoHohmann/rebol-web-scripts/master/jspanel-test.r
  Note: "Basic test of jspanel usage"
  Link: https://jspanel.de/getstarted.html
]

jspanel: js-native[
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

openPanel: js-native[
    "open a jspanel testwindow"
]{
    jsPanel.create()
}

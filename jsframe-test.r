REBOL [
  Title: "JSFrame Test"
  Author: "Ingo Hohmann"
  Date: 2019-11-06
  Note: "Test to open a jsframe window"
]

jsframe: js-native[]{
   var script = document.createElement( 'script')
   script.src = "https://riversun.github.io/jsframe/jsframe.js"
   document.head.appendChild( script)
   script.onload = function() {var jsFrame = new JSFrame();}
}

openwindow: js-native[]{
    frame = jsFrame.create({
    title: 'Window',
    left: 20, top: 20, width: 320, height: 220,
    movable: true,//Enable to be moved by mouse
    resizable: true,//Enable to be resized by mouse
    html: '<div id="my_element" style="padding:10px;font-size:12px;color:darkgray;">Contents of window</div>'
});
}

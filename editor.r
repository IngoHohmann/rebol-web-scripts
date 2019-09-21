REBOL [
   Title: "Web Console Editor"
   Author: "Ingo Hohmann"
   Todo: {
      - race conditions on startup
      - better return values
      - Rebol highlighting
      - Styling
      - store editor data
        - localstorage
        - download?
        - direct access to github?
   }
]


remove-editor: js-native []{
   var editorPane = document.getElementById( "editorPane")
   if (editorPane) {
      editorPane.parentNode.removeChild( editorPane)
   }
}

add-editor: js-native[]{
   var body = document.getElementsByTagName("body")[0]

   var style = document.createElement( 'style')
   style.innerHTML = `
      body {
         display: flex;
      }
      .container {
         flex: 50%;
      }
      #editorPane {
         flex: 50%;
      }
      #editor {
         width: 100%;
         height: 90%;
         display: block;
      }
      #buttonrow {
         text-align: center;
         background-color: gray;
         height: 10%;
      }
      button {
         width: 32%;
         height: 20px;
      }
   `

   var editorPane = document.createElement('div')
   editorPane.id = "editorPane"

   editorPane.onkeydown = function( e) {
      e.stopPropagation()
   }
   editorPane.addEventListener( 'keypress', function( e) {
      e.stopPropagation()
   })

   editorPane.innerHTML = `
   <div contenteditable="true" id="editor">Edit me</div>
   <!--<textarea id="editor">Edit me</textarea>-->
   <div id="buttonrow">
   <button type="button" id="buttondo">DO</button>
   </div>
   `

   body.appendChild( editorPane);
   document.head.appendChild( style)

   var buttondo = document.getElementById( "buttondo")
   buttondo.onclick = function( e) {
      var replPad = document.getElementById( "replpad")
      var line = document.createElement( "div")
      line.class = "line"
      try {
         //reb.Value( "do", reb.T(document.getElementById( 'editor').innerHTML))
         //var val = reb.Spell( reb.V( "append copy/part mold (err: trap [_value: do", reb.T(aceEditor.getValue()),"]) then [err] else [_value]", "20", "{ ...}" ))
         var val = reb.Spell( reb.V( "append copy/part mold do", reb.T(aceEditor.getValue()), "20", "{ ...}" ))
         line.innerText = "== (Editor) " + val
      } catch {
         console.log( "Error")
         line.innerHTML = "&zwnj;== ; Editor error"
      }
      replPad.insertBefore( line, replPad.lastChild)
   }

   // load the ace editor
   var script = document.createElement( 'script')
   script.src = "https://pagecdn.io/lib/ace/1.4.5/ace.js"
   document.head.appendChild( script)

   script.onload = function() {aceEditor = ace.edit( "editor")}
}

; Test function

t: js-native [x]{
    alert( reb.Spell( reb.V( "mold do", reb.ArgR( "x"))))
}


jsedit: js-native [
   "Set the editor text"
   src [text!]
]{
   //var e = document.getElementById( "editor")
   // using a div
   //e.innerText = reb.Spell(reb.ArgR("src"))
   // using a textarea
   // e.value = reb.Spell(reb.ArgR("src"))

   // using ace
   aceEditor.setValue( reb.Spell(reb.ArgR("src")))
}

edit: function [
   "Convert to text / read data, and open the editor on it"
   src [text! binary! url!]
   /only "take input as is (better names? as-is / mold"
][
   if only [
      mold src
   ]
   if url? src [
      ; for CORS you need to access https sites
      if parse src ["http://" to end] [insert at src 5 "s"]
      trap [src: to text! read src]
   ]
   if binary? src [
      src: to text! src
   ]
   if text? src [
      jsedit src
   ] else [
      fail "unable to get text from source"
   ]
]


; For testing
remove-editor
add-editor
edit https://raw.githubusercontent.com/IngoHohmann/rebol-web-scripts/master/editor-README.md


Rebol [
   title: "Web Console Editor"
   author: "Ingo Hohmann"
   todo: --[
      - race conditions on startup
      - better return values
      - Rebol highlighting
      - Styling
      - store editor data
        - localstorage
        - download?
        - direct access to github?
   ]--
]

do %db.r

remove-editor: js-native [] --[
   var editorPane = document.getElementById( "editorPane")
   if (editorPane) {
      editorPane.parentNode.removeChild( editorPane)
   }
]--

add-editor: js-native[] --[
   var body = document.getElementsByTagName("body")[0]

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
   <button type="button" id="buttondosel">DO Selection</button>
   <!--<button type="button" id="buttondoline">DO Line</button>-->
   </div>`

   body.appendChild( editorPane);

   // load the ace editor
   var script = document.createElement( 'script')
   script.src = "https://pagecdn.io/lib/ace/1.4.5/ace.js"
   document.head.appendChild( script)

   script.onload = function() {aceEditor = ace.edit( "editor")}

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

   document.head.appendChild( style)

   var buttondo = document.getElementById( "buttondo")
   buttondo.onclick = function( e) {
      var replPad = document.getElementById( "replpad")
      var line = document.createElement( "div")
      line.class = "line"
      try {
         //reb.Value( "do", reb.T(document.getElementById( 'editor').innerHTML))
         //var val = reb.Spell( reb.V( "append copy:part mold (err: trap [_value: do", reb.T(aceEditor.getValue()),"]) then [err] else [_value]", "20", "--[ ...]--" ))
         var val = reb.Spell( reb.V( "append copy:part mold do", reb.T(aceEditor.getValue()), "60", "--[ ...]--" ))
         line.innerText = "(Editor)\n== " + val
      } catch {
         console.log( "Error")
         line.innerHTML = "&zwnj;== ; Editor error"
      }
      replPad.insertBefore( line, replPad.lastChild)
   }

   var buttondosel = document.getElementById( "buttondosel")
   buttondosel.onclick = function( e) {
      var replPad = document.getElementById( "replpad")
      var line = document.createElement( "div")
      line.class = "line"
      try {
         var val = reb.Spell( reb.V( "append copy:part mold do", reb.T(aceEditor.getSelectedText()), "60", "--[ ...]--" ))
         line.innerText = "(Editor)\n== " + val
      } catch {
         console.log( "Error")
         line.innerHTML = "&zwnj;== ; Editor error"
      }
      replPad.insertBefore( line, replPad.lastChild)
   }

//   var buttondoline = document.getElementById( "buttondoline")
//   buttondoline.onclick = function( e) {
//      var replPad = document.getElementById( "replpad")
//      var line = document.createElement( "div")
//      line.class = "line"
//      try {
//         var val = reb.Spell( reb.V( "append copy:part mold do", reb.T(aceEditor.getValue()), "60", "--[ ...]--" ))
//         line.innerText = "(Editor)\n== " + val
//      } catch {
//         console.log( "Error")
//         line.innerHTML = "&zwnj;== ; Editor error"
//      }
//      replPad.insertBefore( line, replPad.lastChild)
//   }

]--

; Test function

t: js-native [x] --[
    alert( reb.Spell( reb.V( "mold do", reb.ArgR( "x"))))
]--


jsedit: js-native [
   "Set the editor text"
   src [text!]
] --[
   //var e = document.getElementById( "editor")
   // using a div
   //e.innerText = reb.Spell(reb.ArgR("src"))
   // using a textarea
   // e.value = reb.Spell(reb.ArgR("src"))

   // using ace
   aceEditor.setValue( reb.Spell(reb.ArgR("src")))
]--

edit: function [
   "Convert to text / read data, and open the editor on it"
   src [text! binary! url!]
   :only "take input as is (better names? as-is / mold)"
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
      panic "unable to get text from source"
   ]
]

editor: make object! [
    current-file: ""

    get-text: js-native [] --[
        return reb.Text( aceEditor.getValue())
    ]--

    set-text: js-native [text] --[
        aceEditor.setValue( reb.Spell(reb.ArgR("src")))
    ]--

    save: func [
        "Save current text"
    ][
        save-as current-file
    ]

    save-as: func [
        name
    ][
        current-file: name
        db/set unspaced ["editor-file-" name "-curr"] get-text
    ]

    load: func [
        name
        :version [integer!]
    ][
        v: either version [rejoin ["-v" version]["-curr"]]
        jsedit db/get unspaced ["editor-file-" name v]
    ]
]

; For testing
remove-editor
add-editor
edit https://raw.githubusercontent.com/IngoHohmann/rebol-web-scripts/master/editor-README.md

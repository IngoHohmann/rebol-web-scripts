Rebol [
   title: "Web Console Editor"
   author: "Ingo Hohmann"
   type: module
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

import <db.r>  ; angle brackets means look in same directory as this file

export remove-editor: js-native [] --[
   var editorPane = document.getElementById( "editorPane")
   if (editorPane) {
      editorPane.parentNode.removeChild( editorPane)
   }
]--

; This function is a JS-AWAITER that uses resolve() and reject() instead of
; `return` to give back its value.  That's because it can't return until the
; ACE editor is loaded.
;
export add-editor: js-awaiter [
   return: []
] --[
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
   <button type="button" id="buttoneval">EVAL</button>
   <button type="button" id="buttonevalsel">EVAL Selection</button>
   <!--<button type="button" id="buttonevalline">EVAL Line</button>-->
   </div>`

   body.appendChild( editorPane);

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

   let Eval_Helper = function(e, code) {
      var replPad = document.getElementById( "replpad")
      var line = document.createElement( "div")
      line.class = "line"
      try {
         let opt_antiform = ""
         let value = reb.Value( code)
         if (reb.UnboxLogic( "antiform? @", value)) {
            value = reb.Lift( reb.Q( reb.R( value)))
            opt_antiform = " ; antiform"
         }
         let molded = reb.Spell( "mold:limit", value, "60")
         reb.Release( value)
         line.innerText = "(Editor)\n== " + molded + opt_antiform
      } catch (err) {
         console.log( err)
         line.innerHTML = "&zwnj;== ; Editor error"
      }
      replPad.insertBefore( line, replPad.lastChild)
   }

   var buttoneval = document.getElementById( "buttoneval")
   buttoneval.onclick = function( e) {
      Eval_Helper(e, aceEditor.getValue())
   }

   var buttonevalsel = document.getElementById( "buttonevalsel")
   buttonevalsel.onclick = function( e) {
      Eval_Helper(e, aceEditor.getSelectedText())
   }

   /* var buttonevalline = document.getElementById( "buttonevalline") */

    // JS-AWAITER returns control to the JavaScript event loop here.  The
    // Rebol caller doesn't get resumed until something from the event loop
    // triggers and calls the resolve() or reject() functions (in this case,
    // those callbacks are attached to the ACE editor script onload event).

   return new Promise( function( resolve, reject) {
      var script = document.createElement( 'script')
      script.src = "https://cdnjs.cloudflare.com/ajax/libs/ace/1.4.14/ace.js"
      script.onload = function() {
         if (window.ace) {
            aceEditor = ace.edit("editor")
            resolve()
         } else {
            reject(new Error("Ace loaded, but didn't initialize window.ace"))
         }
      }
      script.onerror = function(event) {
         reject(new Error("Failed to load: " + script.src))
      }

      document.head.appendChild( script)
   })
]--

; Test function

export t: js-native [x] --[
    alert( reb.Spell( reb.V( "mold eval x")))
]--


jsedit: js-native [
   "Set the editor text"
   src [text!]
] --[
   //var e = document.getElementById( "editor")
   // using a div
   //e.innerText = reb.Spell( "src")
   // using a textarea
   // e.value = reb.Spell( "src")

   // using ace
   aceEditor.setValue( reb.Spell( "src"))
]--

export edit: function [
   "Convert to text / read data, and open the editor on it"
   src [text! blob! url!]
   :only "take input as is (better names? as-is / mold)"
][
   if only [
      mold src
   ]
   if url? src [
      src: as text! trap read src  ; aliasing fabricated BLOB! as TEXT! legal
   ]
   if blob? src [
      src: decode 'UTF-8 text! src  ; TO TEXT! of BLOB! not legal at present
   ]
   if text? src [
      jsedit src
   ] else [
      panic "unable to get text from source"
   ]
]

export editor: make object! [
    current-file: ""

    get-text: js-native [] --[
        return reb.Text( aceEditor.getValue())
    ]--

    set-text: js-native [text] --[
        aceEditor.setValue( reb.Spell( "src"))
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

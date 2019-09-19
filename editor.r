REBOL [
   Title: "WASM Console Editor"
   Author: "Ingo Hohmann"
]

remove-editor: js-native []{
   var rightPane = document.getElementById( "right")
   if (rightPane) {
      rightPane.parentNode.removeChild( rightPane)
   }
}

add-editor: js-native[]{
   var body = document.getElementsByTagName("body")[0]

   var style = document.createElement( 'style')
   style.innerHTML = `
      body {
         display: flex;
      }
      #right {
         flex: 50%;
      }
      .container {
         flex: 50%;
      }
      #editinput {
         width: 100%;
         height: 90%;
         display: block;
      }
      button {
         width: 32%;
         height: 20px;
      }
   `

   var s2 = document.createElement('div')
   s2.id = "right"
   s2.type

   var form = document.createElement( 'form')
   form.id = "editor"
   
   var input = document.createElement( 'textarea')
   input.id = "input"
   
   var editdiv = document.createElement( 'div')
   editdiv.contenteditable = "true"
   editdiv.innerHTML = "editme"
   editdiv.id = "editfield"

   var button = document.createElement( 'button')
   button.id = "do"
   button.name = "do"
   button.text = "DO"
   button.type = "button"
   button.innerText = "DO"

   //form.appendChild( input)
   //s2.appendChild( editdiv)
   //s2.appendChild( button)

   s2.innerHTML = `
   <!--<div contenteditable="true" id="editinput">Edit me</div>-->
   <textarea id="editinput">Edit me</textarea>
   <button type="button" id="buttonedit">Edit</button>
   <button type="button" id="buttonleave">Leave</button>
   <button type="button" id="buttondo">DO</button>
   `

   body.appendChild( s2);
   document.head.appendChild( style)
}



jsDeactivateInput: js-native[] {
    var inputDivs = document.getElementsByClassName( "input")
    var el = inputDivs[inputDivs.length -1]
    document.input = null
    el.onkeydown = null
    el.contentEditable = false

    // shrinks the previous input down to a
    // minimum size that will fit its contents
    el.style.width = 'auto'
    el.style.height = 'auto'
}

jsedit: js-native [src [text!]]{
   // set element text
   var e = document.getElementById( "editinput")
   // using a div
   // e.innerText = reb.Spell(reb.Arg("src"))
   // using a textarea
   e.value = reb.Spell(reb.Arg("src"))

   // trying to get the input handler to accept the editor as input field
   // Deactivate Input Element
   var inputDivs = document.getElementsByClassName( "input")
   var el = inputDivs[inputDivs.length -1]
   document.input = null
   el.onkeydown = null
   el.contentEditable = false

   // shrinks the previous input down to a
   // minimum size that will fit its contents
   el.style.width = 'auto'
   el.style.height = 'auto'

   //DeactivateInput()
   ActivateInput( e)

}

edit: function [src [text! binary! url!]][
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
edit http://0pt.pw/db.r

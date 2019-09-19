REBOL [
   Title: "Web Console Editor"
   Author: "Ingo Hohmann"
]

remove-editor: js-native []{
   var rightPane = document.getElementById( "rightPane")
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
      .container {
         flex: 50%;
      }
      #rightPane {
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

   var rightPane = document.createElement('div')
   rightPane.id = "rightPane"

   rightPane.onkeydown = function( e) {
      e.stopPropagation()
   }
   rightPane.addEventListener( 'keypress', function( e) {
      e.stopPropagation()
   })

   rightPane.innerHTML = `
   <!--<div contenteditable="true" id="editinput">Edit me</div>-->
   <textarea id="editinput">Edit me</textarea>
   <button type="button" id="buttonedit">Edit</button>
   <button type="button" id="buttonleave">Leave</button>
   <button type="button" id="buttondo">DO</button>
   `

   body.appendChild( rightPane);
   document.head.appendChild( style)

   var buttondo = document.getElementById( "buttondo")
   buttondo.onclick = function( e) {
      try {
         reb.Value( document.getElementById( 'editinput').value)
      } catch {
         console.log( "Error")
      }
   }
}

jsedit: js-native [
   "Set the editor text"
   src [text!]
]{
   var e = document.getElementById( "editinput")
   // using a div
   // e.innerText = reb.Spell(reb.Arg("src"))
   // using a textarea
   e.value = reb.Spell(reb.Arg("src"))

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
edit http://0pt.pw/db.r

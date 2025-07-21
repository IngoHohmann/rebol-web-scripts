Rebol [
   title: "localStorage Access for Rebol"
   author: "Ingo Hohmann"
   todo: --[
      - should there be an automatic conversion to/from text! for other types?
      - indexeddb
   ]--
]

db: make object! [
   set: js-native [
      "Save to localstorage"
      key [text!]
      value [text!]
   ] --[
      localStorage.setItem(reb.Spell("key"), reb.Spell("value"))
   ]--

   get: js-native [
      "Get data back from localStorage"
      key [text!]
   ] --[
      var v
      if (v = localStorage.getItem(reb.Spell("key"))) {
         return reb.Text( v)
      } else {
         return null
      }
   ]--

   get-db: js-native [
      "Get complete localStorage db"
   ] --[
      return reb.Text( JSON.stringify( localStorage))
   ]--

   get-keys: js-native [
      "Get list of localStorage keys"
   ] --[
      return reb.Text( JSON.stringify( Object.keys(localStorage)))
   ]--
]

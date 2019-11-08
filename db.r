REBOL [
   Title: "localStorage Access for Rebol"
   Author: "Ingo Hohmann"
   Todo: {
      - should there be an automatic conversion to/from text! for other types?
      - indexeddb
   }
]

db: make object! [
   set: js-native [
      "Save to localstorage"
      key [text!]
      value [text!]
   ]{
      localStorage.setItem(reb.Spell(reb.Arg("key")), reb.Spell(reb.Arg("value")))
   }

   get: js-native [
      "Get data back from localStorage"
      key [text!]
   ]{
      var v
      if (v = localStorage.getItem(reb.Spell(reb.ArgR("key")))) {
         return reb.Text( v)
      } else {
         return reb.Void()
      }
  }
]

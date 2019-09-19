REBOL [
   Title: "localStorage Access for Rebol"
   Author: "Ingo Hohmann"
]

db: make object! [
   set: js-native [
      "Save to localstorage"
      key [string!]
      value [string!]
   ]{
      localStorage.setItem(reb.Spell(reb.Arg("key")), reb.Spell(reb.Arg("value")))
   }

   get: js-native [
      "Get data back from localStorage"
      key [string!]
   ]{
      var v
      if (v = localStorage.getItem(reb.Spell(reb.ArgR("k")))) {
         return reb.Text( v)
      } else {
         return reb.Void()
      }
  }
]

Rebol [
   title: "Todo"
   author: "Ingo Hohmann"
   note: "A Web Todo App in Rebol"
]

; load the webtop
do https://raw.githubusercontent.com/IngoHohmann/rebol-web-scripts/master/webtop.r

;
; Database
;

db: make object! [
   set: js-native [
      "Save to localstorage"
      key [text!]
      value [text!]
   ] --[
      localStorage.setItem( reb.Spell( "key"), reb.Spell( "value"))
   ]--

   get: js-native [
      "Get data back from localStorage"
      key [text!]
   ] --[
      var v
      if (v = localStorage.getItem( reb.Spell( "key"))) {
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
      return reb.Text( JSON.stringify( Object.keys( localStorage)))
   ]--
]

;
; Todos
;

open-todo-win: function [][
   open-win "TodoWin" "Todos" --[
      <div id="todoPane">
      <h3>Open Todos</h3><div id="todosOpen"></div>
      <h3>Closed Todos</h3><div id="todosClosed"></div>
      </div>
   ]--
]

add-todoPane: js-native[] --[
   var todoPane = document.getElementById( "todoPane")
   if (!todoPane) {
      var appPane = document.getElementById( "appPane")
      if (!appPane) {
         reb.Elide( "add-appPane")
         appPane = document.getElementById( "appPane")
      }
      //var side = document.getElementsByTagName("body")[0]
      todoPane = document.createElement('div')
      todoPane.id = "todoPane"
      todoPane.onkeydown = function( e) {
         e.stopPropagation()
      }
      todoPane.addEventListener( 'keypress', function( e) {
         e.stopPropagation()
      })
      todoPane.innerHTML = `
         <h3>Open Todos</h3><div id="todosOpen"></div>
         <h3>Closed Todos</h3><div id="todosClosed"></div>
      `
      appPane.appendChild( todoPane);
      var style = document.createElement( 'style')
      style.innerHTML = `
         body {
            display: flex;
         }
         .container {
            flex: 50%;
         }
         #appPane {
            flex: 50%;
         }
      `
      document.head.appendChild( style)
      document.todosOpen =  document.getElementById( "todosOpen")
      document.todosClosed =  document.getElementById( "todosClosed")
   }
]--

template: [
   title _
   id _
   created
   due_at _
   due_until _
   onclose _
]

todos: [
   open: []
   closed: []
]

initialize-todos: function [][
   if text? opt t: db/get "todos_open" [
      todos.open: load t
   ]
   if text? opt t: db/get "todos_closed" [
      todos.closed: load t
   ]
   for-each 't todos.open [
      add-jstodo t.1 form t.2
   ]
   for-each 't todos.closed [
      add-jsclosed-todo t.1 form t.2
   ]
]


add-todo: function [title [text!]][
   id: now:precise
   todo: reduce [title id false _ _]
   append todos.open todo
   db/set "todos_open" mold todos.open
   add-jstodo todo.1 form todo.2
   todo
]

add-jstodo: js-native [todo [text!] id [text!]] --[
   var div = document.createElement('div')
   div.id = reb.Spell("id")
   div.innerHTML = reb.Spell("todo")
   document.getElementById( "todosOpen").appendChild( div);
]--

add-jsclosed-todo: js-native [todo [text!] id [text!]] --[
   var div = document.createElement('div')
   div.id = reb.Spell("id")
   div.innerHTML = reb.Spell("todo")
   document.getElementById( "todosClosed").appendChild( div);
]--

update-todo: function [ todo [text! integer! tag! block!]][
   case [
      integer? todo
   ]
]

update-jstodo: js-native [ id [text!] title [text!]] --[
   var div = document.getElementById(reb.Spell("id"))
   div.innerHTML = reb.Spell("title")
]--

close-todo: function [id [text! integer!]][
   if integer? todo [
   ]
   if text? todo [
      for-next 't todos.open [
         if t.1.2 = id [
            insert todos.closed first t
            remove t
         ]
      ]
   ]
   db/set "todos_open" mold todos.open
   db/set "todos_closed" mold todos.closed
   close-jstodo form id
]

close-jstodo: js-native [ id [text!]] --[
   var div = document.getElementById(reb.Spell("id"))
   document.getElementById( "todosOpen").removeChild( div);
   document.getElementById( "todosClosed").appendChild( div);
]--

;
; Setup
;

app/init
app/add [
   title "Todos"
   content --[<div id=todoPane><h3>Open Todos</h3><div id=todosOpen></div><h3>Closed Todos</h3><div id=todosClosed></div></div>]--
]
initialize-todos

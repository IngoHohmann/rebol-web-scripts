text: {
# How to use the editor

* Write in the editor
* click the "DO" Button
* The content of the editor will be DOne in the Rebol console, Feedback is very limited at the moment.

# Getting text into the editor

* you can use EDIT in the console, with text!, binary or url! where binary is converted to text!n and url!s are read, if they are cors-enabled.

# Example

Now press "DO" and then enter text<RETURN> in the Ren-C Console.

# Known problems

* there seem to be some race conditions on startup
* it would be nice to get a better return value on DO

# to see this editors source code
    >> edit https://raw.githubusercontent.com/IngoHohmann/rebol-web-scripts/master/editor.r

# Other experiments
## Open a draggable window, using two different libraries
### jsframe

    >> do https://raw.githubusercontent.com/IngoHohmann/rebol-web-scripts/master/jsframe-test.r
    >> jsframe
    >> openframe

or 

    >> edit https://raw.githubusercontent.com/IngoHohmann/rebol-web-scripts/master/jsframe-test.r
    
### jspanel

    >> do https://raw.githubusercontent.com/IngoHohmann/rebol-web-scripts/master/jspanel-test.r
    >> jspanel
    >> openpanel

or

    >> edit do https://raw.githubusercontent.com/IngoHohmann/rebol-web-scripts/master/jspanel-test.r
}

do https://raw.githubusercontent.com/IngoHohmann/rebol-web-scripts/master/jsframe-test.r
do https://raw.githubusercontent.com/IngoHohmann/rebol-web-scripts/master/jspanel-test.r

#include %A_ScriptDir%\..\..\lib\Windy
#include WindLy.ahk
#include Windy.ahk

OutputDebug % "******** Start Situation ****************************************"
x := new WindLy()
ww := x.byMonitorId(1)
for key, data in ww {
	OutputDebug % data.hwnd ": " data.title " (" key ")" 
}
OutputDebug % "############## Inserting WINDY-Object into WindLy-Instance: WindLy.insert() ########################"
; Generate a random Windy object (Notepad)
a := new Windy(0)
OutputDebug % "******** Random Windy To Insert *****************************************"
OutputDebug % a.hwnd ": " a.title 

; Insert the Windy object into WindLy-Instance
x.insert(a)
OutputDebug % "******** After Insert *****************************************"
ww := x.list
for key, data in ww {
	OutputDebug % data.hwnd ": " data.title " (" key ")" 
}

OutputDebug % "############## Removing WINDY-Object from WindLy-Instance: WindLy.remove() ########################"
OutputDebug % "******** Windy To Remove *****************************************"
OutputDebug % a.hwnd ": " a.title

; Remove the previously added randow Windy object again from WindLy instance
x.remove(a)
OutputDebug % "******** After Remove *****************************************"
ww := x.list
for key, data in ww {
	OutputDebug % data.hwnd ": " data.title " (" key ")" 
}

OutputDebug % "############## SET-Operation UNION: WindLy.union() ########################"
; Generate a second empty WindLy instance 
y := new Windly()
; ... and add a Windy-object
y.insert(a)
OutputDebug % "******** WindLy To Union *****************************************"
ww := y.list
for key, data in ww {
	OutputDebug % data.hwnd ": " data.title " (" key ")" 
}
; Determine Union between orignal WindLy instance x and newly generated WindLy instance y
x.union(y)

OutputDebug % "******** WindLy After Union *****************************************"
ww := x.list
for key, data in ww {
	OutputDebug % data.hwnd ": " data.title " (" key ")" 
}

a.kill()

ExitApp

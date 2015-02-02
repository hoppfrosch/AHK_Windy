#include %A_ScriptDir%\..\..\lib\Windy
#include WindLy.ahk
#include Windy.ahk

tList.= "******** Before ****************************************`n"
x := new WindLy()
ww := x.byMonitorId(1)
for key, data in ww {
	tList.= data.hwnd ": " data.title " (" key ")`n" 
}

a := new Windy(0)
y := new Windly()
y.insert(a)
tList.= "******** New *****************************************`n"
ww := y.list
for key, data in ww {
	tList.= data.hwnd ": " data.title " (" key ")`n" 
}
x.union(y)

tList.= "******** After *****************************************`n"
ww := x.list
for key, data in ww {
	tList.= data.hwnd ": " data.title " (" key ")`n" 
}

a.kill()
MsgBox % tList

ExitApp

#include %A_ScriptDir%\..\..\lib\Windy\Windy.ahk
#include %A_ScriptDir%\..\..\lib\Windy\WindInfy.ahk
#include %A_ScriptDir%\..\..\lib\SerDes.ahk

OutputDebug DBGVIEWCLEAR

WinGet, hWnd, ID, A
oWindy := new Windy(hWnd)

o := WindInfy.fromWindy(oWindy)
str := o.toJson()
OutputDebug % "[IMPORTANT]" str
o1 := WindInfy.fromJSON(str)
OutputDebug % "[IMPORTANT]" o1.toJson()
; oWindy.kill()

ExitApp

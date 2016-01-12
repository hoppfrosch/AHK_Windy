#include %A_ScriptDir%\..\..\lib\Windy\Windy.ahk
#include %A_ScriptDir%\..\..\lib\Windy\WindInfy.ahk

OutputDebug % "******** Generating ***************************************************************************"
WinGet, hWnd, ID, A
oWindy := new Windy(hWnd)

o := WindInfy.fromWindy(oWindy)

MsgBox % o.toJson()

oWindy.kill()

ExitApp

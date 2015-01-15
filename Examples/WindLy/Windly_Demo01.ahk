#include <Windy\WindLy>
#include <Windy\Const_WinUser>

WinGet, Wins, List

Loop %Wins%
{
	Id:=Wins%A_Index%
	WinGetTitle, TVar , % "ahk_id " Id
	tList.= Id ": " TVar "`n" ;use this if you just want the list
}

tList.= "********All Windows****************************************`n"
x := new WindLy()
ww := x.Snapshot()
for key, data in ww {
	tList.= data.hwnd ": " data.title "`n" 
}

tList.= "********On Monitor 2#*************************************`n"
ww := x.byMonitorId(2)
for key, data in ww {
	tList.= data.hwnd ": " data.title "`n" 
}

tList.= "********Minimized*****************************************`n"
ww := x.byStyle(WS.MINIMIZE)
for key, data in ww {
	tList.= data.hwnd ": " data.title "`n" 
}

MsgBox % tList

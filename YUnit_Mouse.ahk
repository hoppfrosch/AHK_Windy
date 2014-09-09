#NoEnv
#SingleInstance force

#Include %A_ScriptDir%\Yunit\Yunit.ahk
#Include %A_ScriptDir%\Yunit\Window.ahk
#Include %A_ScriptDir%\Yunit\StdOut.ahk
#include <EDE\Mouse>

#Warn All
#Warn LocalSameAsGlobal, Off

ReferenceVersion := "0.1.1"

Yunit.Use(YunitStdOut, YunitWindow).Test(MiscTestSuite)
Return

class MiscTestSuite
{
	Begin()  {
		debug := 1
		this.r := new Mouse(debug)
    }
	
	Version() {
		Global ReferenceVersion
		Yunit.assert(this.r._version == ReferenceVersion)
    }
		
	Locate() {
		this.r.locate()
	}

	Pos() {
		MsgBox % this.r.pos.dump() " - " this.r.x "," this.r.y
		
	}

	End() {
        this.remove("r")
		this.r := 
    }

}
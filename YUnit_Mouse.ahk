#NoEnv
#SingleInstance force

#Include %A_ScriptDir%\Yunit\Yunit.ahk
#Include %A_ScriptDir%\Yunit\Window.ahk
#Include %A_ScriptDir%\Yunit\StdOut.ahk
#include <EDE\Mouse>

#Warn All
#Warn LocalSameAsGlobal, Off

ReferenceVersion := "0.1.3"

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
		this.r.monitorID := 1
		Yunit.assert(this.r.monitorID == 1)
		this.r.monitorID := 2
		Yunit.assert(this.r.monitorID == 2)
	}

	End() {
        this.remove("r")
		this.r := 
    }

}
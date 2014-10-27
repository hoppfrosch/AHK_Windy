#NoEnv
#SingleInstance force

#Include %A_ScriptDir%\Yunit\Yunit.ahk
#Include %A_ScriptDir%\Yunit\Window.ahk
#Include %A_ScriptDir%\Yunit\StdOut.ahk
#include <Windy\Mousy>

#Warn All
#Warn LocalSameAsGlobal, Off

ReferenceVersion := "0.2.0"

Yunit.Use(YunitStdOut, YunitWindow).Test(MiscTestSuite)
Return

class MiscTestSuite
{
	Begin()  {
		debug := 1
		this.r := new Mousy(debug)
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
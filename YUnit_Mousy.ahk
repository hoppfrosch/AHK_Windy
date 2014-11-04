#NoEnv
#SingleInstance force

#Include %A_ScriptDir%\Yunit\Yunit.ahk
#Include %A_ScriptDir%\Yunit\Window.ahk
#Include %A_ScriptDir%\Yunit\StdOut.ahk
#include <Windy\Mousy>

#Warn All
#Warn LocalSameAsGlobal, Off


debug := 1
ReferenceVersion := "1.0.0"

;Yunit.Use(YunitStdOut, YunitWindow).Test(TempTestSuite)
Yunit.Use(YunitStdOut, YunitWindow).Test(_BaseTestSuite, MiscTestSuite)
Return

class TempTestSuite
{
	Begin()  {
		Global debug
		this.r := new Mousy(debug)
    }
		
	
	End() {
        this.remove("r")
		this.r := 
    }

}


class MiscTestSuite
{
	Begin()  {
		Global debug
		this.r := new Mousy(debug)
    }
		
	Locate() {
		Global debug
		OutputDebug % ">>>>>[" A_ThisFunc "]>>>>>"
		this.r.locate()
		OutputDebug % "<<<<<[" A_ThisFunc "]<<<<<"
	}

	Pos() {
		Global debug
		OutputDebug % ">>>>>[" A_ThisFunc "]>>>>>"
		this.r.monitorID := 1
		Yunit.assert(this.r.monitorID == 1)
		this.r.monitorID := 2
		Yunit.assert(this.r.monitorID == 2)
		OutputDebug % "<<<<<[" A_ThisFunc "]<<<<<"
	}

	End() {
        this.remove("r")
		this.r := 
    }
}

class _BaseTestSuite {
    Begin() {
	}
	
	Version() {
		Global debug
		OutputDebug % ">>>>>[" A_ThisFunc "]>>>>>"
		Global ReferenceVersion
		obj := new Mousy(debug)
		OutputDebug % "Mousy Version <" obj.version "> <-> Required <" ReferenceVersion ">"
		Yunit.assert(obj.version == ReferenceVersion)
		OutputDebug % ">>>>[" A_ThisFunc "]>>>>"
	}

	End() {
	}
}

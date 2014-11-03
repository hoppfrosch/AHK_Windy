#NoEnv

#Include %A_ScriptDir%\Yunit\Yunit.ahk
#Include %A_ScriptDir%\Yunit\Window.ahk
#Include %A_ScriptDir%\Yunit\StdOut.ahk
#include lib\Windy\Dispy.ahk
#include lib\Windy\Recty.ahk

#Warn All
;#Warn LocalSameAsGlobal, Off
#SingleInstance force


ReferenceVersion := "0.1.0"
debug := 1

Yunit.Use(YunitStdOut, YunitWindow).Test(_BaseTestSuite, DispyTestSuite)
Return

ExitApp


class DispyTestSuite
{
	Begin() {
		Global debug
;		this.obj := new Dispy(1, debug)
		this.monCount := 2
		this.mon1Width := 1920
		this.mon1Height := 1080
  		this.mon2Width := 1600
		this.mon2Height := 1200		
    }

	constructor() {
		Global debug
		OutputDebug % ">>>>>[" A_ThisFunc "]>>>>>"
    	mon1 := new Dispy(1, debug)
    	Yunit.assert(mon1 != false)
    	mon99 := new Dispy(99, debug)
    	Yunit.assert(mon99 = false)
    	OutputDebug % "<<<<<[" A_ThisFunc "]<<<<<"
    }

	End()  {
;        this.remove("obj")
;		this.obj := 
    }

}

class _BaseTestSuite {
    Begin() {
	}
	
	Version() {
		Global debug
		OutputDebug % ">>>>>[" A_ThisFunc "]>>>>>"
		Global ReferenceVersion
		idispy := new Dispy(1, debug)
		OutputDebug % "Dispy Version <" idispy.version "> <-> Required <" ReferenceVersion ">"
		Yunit.assert(idispy.version == ReferenceVersion)
		OutputDebug % ">>>>[" A_ThisFunc "]>>>>"
	}

	End() {
	}
}

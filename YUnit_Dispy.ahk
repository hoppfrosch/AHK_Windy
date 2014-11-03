#NoEnv

#Include %A_ScriptDir%\Yunit\Yunit.ahk
#Include %A_ScriptDir%\Yunit\Window.ahk
#Include %A_ScriptDir%\Yunit\StdOut.ahk
#include lib\Windy\Dispy.ahk
#include lib\Windy\Recty.ahk

#Warn All
;#Warn LocalSameAsGlobal, Off
#SingleInstance force


ReferenceVersion := "0.1.5"
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

	_constructor() {
		Global debug
		OutputDebug % ">>>>>[" A_ThisFunc "]>>>>>"
    	mon1 := new Dispy(1, debug)
    	Yunit.assert(mon1 != false)
    	mon99 := new Dispy(99, debug)
    	Yunit.assert(mon99 = false)
    	OutputDebug % "<<<<<[" A_ThisFunc "]<<<<<"
    }

    boundary() {
    	Global debug
		OutputDebug % ">>>>>[" A_ThisFunc "]>>>>>"
    	mon1 := new Dispy(1, debug)
		rect1 := mon1.boundary
		Yunit.assert(rect1.w == this.mon1Width)
		Yunit.assert(rect1.h == this.mon1Height)	
		mon2 := new Dispy(2, debug)
		rect2 := mon2.boundary(2)
		Yunit.assert(rect2.x == rect1.w)
		Yunit.assert(rect2.y == rect2.y)
		Yunit.assert(rect2.w == rect1.w + this.mon2Width)
		Yunit.assert(rect2.h == this.mon2Height)
		OutputDebug % "<<<<<[" A_ThisFunc "]<<<<<"
	}


	identify() {
    	Global debug
		OutputDebug % ">>>>>[" A_ThisFunc "]>>>>>"
    	mon1 := new Dispy(1, debug)
		mon1.identify(250)
		mon2 := new Dispy(2, debug)
		mon2.identify(250)
		OutputDebug % "<<<<<[" A_ThisFunc "]<<<<<"
	}
		
    size() {
    	Global debug
		OutputDebug % ">>>>>[" A_ThisFunc "]>>>>>"
    	mon1 := new Dispy(1, debug)
		rect := mon1.size
		Yunit.assert(rect.w == this.mon1Width)
		Yunit.assert(rect.h == this.mon1Height)	
		mon2 := new Dispy(2, debug)
		rect := mon2.size
		Yunit.assert(rect.w == this.mon2Width)
		Yunit.assert(rect.h == this.mon2Height)
		OutputDebug % "<<<<<[" A_ThisFunc "]<<<<<"
	}

	virtualScreenSize() {
		Global debug
		OutputDebug % ">>>>>[" A_ThisFunc "]>>>>>"
		mon1 := new Dispy(1, debug)
		rect := mon1.virtualScreenSize()
		Yunit.assert(rect.x == 0)
		Yunit.assert(rect.y == 0)
		Yunit.assert(rect.w == (this.mon1Width + this.mon2Width))
		Yunit.assert(rect.h == this.mon2Height)
		OutputDebug % "<<<<<[" A_ThisFunc "]<<<<<"
	}

	workingArea() {
    	Global debug
		OutputDebug % ">>>>>[" A_ThisFunc "]>>>>>"
    	mon1 := new Dispy(1, debug)
		rect := mon1.workingArea
		Yunit.assert(rect.w <= this.mon1Width)
		Yunit.assert(rect.h <= this.mon1Height)	
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

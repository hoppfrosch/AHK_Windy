#NoEnv
#SingleInstance force

#Include %A_ScriptDir%\Yunit\Yunit.ahk
#Include %A_ScriptDir%\Yunit\Window.ahk
#Include %A_ScriptDir%\Yunit\StdOut.ahk
#include <Rectangle>

#Warn All
#Warn LocalSameAsGlobal, Off

ReferenceVersion := "0.1.0"

Yunit.Use(YunitStdOut, YunitWindow).Test(RectangleTestSuite)
Return

class RectangleTestSuite
{
	Begin()
    {
		debug := 1
		this.r := new Rectangle(100,100,100,100,debug)
    }
	
	Version()
    {
		Global ReferenceVersion
		Yunit.assert(this.r.Version() == ReferenceVersion)
    }
		
	Constructor() {
		Yunit.assert(this.r.x == 100)
		Yunit.assert(this.r.y == 100)
		Yunit.assert(this.r.w == 100)
		Yunit.assert(this.r.h == 100)
	}
	
	Getter() {
		Yunit.assert(this.r.xul == this.r.x)
		Yunit.assert(this.r.yul == this.r.y)
		Yunit.assert(this.r.xlr == this.r.x + this.r.w)
		Yunit.assert(this.r.ylr == this.r.y + this.r.h)
	}
	
	Setter() {
		this.r.xul := 90
		this.r.yul := 90
		this.r.xlr := 210
		this.r.ylr := 210		
		Yunit.assert(this.r.x == 90)
		Yunit.assert(this.r.y == 90)
		Yunit.assert(this.r.w == 120)
		Yunit.assert(this.r.h == 120)
	}
	
	
	End()
    {
        this.remove("r")
		this.r := 
    }

}

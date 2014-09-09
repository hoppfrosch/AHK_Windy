#NoEnv
#SingleInstance force

#Include %A_ScriptDir%\Yunit\Yunit.ahk
#Include %A_ScriptDir%\Yunit\Window.ahk
#Include %A_ScriptDir%\Yunit\StdOut.ahk
#include <EDE\Point>

#Warn All
#Warn LocalSameAsGlobal, Off

ReferenceVersion := "0.1.1"

Yunit.Use(YunitStdOut, YunitWindow).Test(CompareTestSuite, MiscTestSuite)
Return

class MiscTestSuite
{
	Begin()
    {
		debug := 1
		this.r := new Point(100,100,debug)
    }
	
	Version()
    {
		Global ReferenceVersion
		Yunit.assert(this.r._version == ReferenceVersion)
    }
		
	Constructor() {
		Yunit.assert(this.r.x == 100)
		Yunit.assert(this.r.y == 100)
	}
			
	Pos() {
		MsgBox % this.r.dump()
		a := this.r.fromMouse()
		MsgBox % a.dump()
	}
	
	End()
    {
        this.remove("r")
		this.r := 
    }

}


class CompareTestSuite
{
	Begin()
    {
		debug := 1
		this.r := new Point(100,100,debug)
    }
	
	
	Equal() {
		comp := new Point(this.r.x, this.r.y, 0)
		Yunit.assert(this.r.equal(comp) == true)
		return
	}
	
	NonEqual() {
		comp := new Point(this.r.x + 10, this.r.y, 0)
		Yunit.assert(this.r.equal(comp) == false)
		return
	}
		
	End()
    {
        this.remove("r")
		this.r := 
    }

}

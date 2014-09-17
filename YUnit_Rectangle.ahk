#NoEnv
#SingleInstance force

#Include %A_ScriptDir%\Yunit\Yunit.ahk
#Include %A_ScriptDir%\Yunit\Window.ahk
#Include %A_ScriptDir%\Yunit\StdOut.ahk
#include <EDE\Rectangle>

#Warn All
#Warn LocalSameAsGlobal, Off

ReferenceVersion := "0.2.0"

Yunit.Use(YunitStdOut, YunitWindow).Test(CompareTestSuite, MiscTestSuite)
Return

class MiscTestSuite
{
	Begin()
    {
		debug := 1
		this.r := new Rectangle(100,100,100,100,debug)
    }
	
	Version()
    {
		Global ReferenceVersion
		Yunit.assert(this.r._version == ReferenceVersion)
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


class CompareTestSuite
{
	Begin()
    {
		debug := 1
		this.r := new Rectangle(100,100,100,100,debug)
    }
	
	
	Equal() {
		comp := new Rectangle(this.r.x, this.r.y, this.r.w, this.r.h, 0)
		Yunit.assert(this.r.equal(comp) == true)
		Yunit.assert(this.r.equalPos(comp) == true)
		Yunit.assert(this.r.equalSize(comp) == true)
		return
	}
	
	NonEqualPos() {
		comp := new Rectangle(this.r.x + 10, this.r.y, this.r.w, this.r.h, 0)
		Yunit.assert(this.r.equal(comp) == false)
		Yunit.assert(this.r.equalPos(comp) == false)
		Yunit.assert(this.r.equalSize(comp) == true)
		comp :=
		comp := new Rectangle(this.r.x, this.r.y + 10, this.r.w, this.r.h, 0)
		Yunit.assert(this.r.equal(comp) == false)
		Yunit.assert(this.r.equalPos(comp) == false)
		Yunit.assert(this.r.equalSize(comp) == true)
		comp :=
		comp := new Rectangle(this.r.x + 10, this.r.y + 10, this.r.w, this.r.h, 0)
		Yunit.assert(this.r.equal(comp) == false)
		Yunit.assert(this.r.equalPos(comp) == false)
		Yunit.assert(this.r.equalSize(comp) == true)
		return
	}
	
	NonEqualSize() {
		comp := new Rectangle(this.r.x , this.r.y, this.r.w+10, this.r.h, 0)
		Yunit.assert(this.r.equal(comp) == false)
		Yunit.assert(this.r.equalPos(comp) == true)
		Yunit.assert(this.r.equalSize(comp) == false)
		comp :=
		comp := new Rectangle(this.r.x , this.r.y, this.r.w, this.r.h+10, 0)
		Yunit.assert(this.r.equal(comp) == false)
		Yunit.assert(this.r.equalPos(comp) == true)
		Yunit.assert(this.r.equalSize(comp) == false)
		comp :=
		comp := new Rectangle(this.r.x , this.r.y, this.r.w+10, this.r.h+10, 0)
		Yunit.assert(this.r.equal(comp) == false)
		Yunit.assert(this.r.equalPos(comp) == true)
		Yunit.assert(this.r.equalSize(comp) == false)
		return
	}
	
	NonEqual() {
		comp := new Rectangle(this.r.x+1, this.r.y, this.r.w-1, this.r.h, 0)
		Yunit.assert(this.r.equal(comp) == false)
		Yunit.assert(this.r.equalPos(comp) == false)
		Yunit.assert(this.r.equalSize(comp) == false)
		return
	}
	
	End()
    {
        this.remove("r")
		this.r := 
    }

}

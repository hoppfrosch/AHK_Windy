#NoEnv
#SingleInstance force

#Include %A_ScriptDir%\Yunit\Yunit.ahk
#Include %A_ScriptDir%\Yunit\Window.ahk
#Include %A_ScriptDir%\Yunit\StdOut.ahk
#include <Windy\Mousy>
#include <Windy\Pointy>
#include <DbgOut>

#Warn All
#Warn LocalSameAsGlobal, Off

OutputDebug DBGVIEWCLEAR

debug := 1
ReferenceVersion := "1.1.5"

;Yunit.Use(YunitStdOut, YunitWindow).Test(ProblematicTestSuite)
Yunit.Use(YunitStdOut, YunitWindow).Test(_BaseTestSuite, MiscTestSuite)
Return

class TempTestSuite
{
	Begin()	{
		Global debug
		this.r := new Mousy(debug)
	}

	move() {
		Global debug
		dbgOut(">[" A_ThisFunc "]", debug)
		this.r.x := 100
		this.r.y := 100
		this.r.movespeed := 25
		this.r.movemode := 1
		this.r.x :=1000
		this.r.movemode := 3
		this.r.pos := new Pointy(500,500)
		this.r.movemode := 2
		this.r.pos := new Pointy(100,100)
		dbgOut("<[" A_ThisFunc "]", debug)
	}

	End() {
		this.remove("r")
		this.r := 
	}
}


class MiscTestSuite
{
	Begin()	{
		Global debug
		this.r := new Mousy(debug)
		dbgOut("=[" A_ThisFunc "]: moveable=" this.r.moveable, debug)
		this.r.moveable := 0
		}

	Locate() {
		Global debug
		dbgOut(">[" A_ThisFunc "]", debug)
		this.r.locate()
		dbgOut("<[" A_ThisFunc "]", debug)
	}

	monitorID() {
		Global debug
		dbgOut(">[" A_ThisFunc "]", debug)
		this.r.monitorID := 1
		Yunit.assert(this.r.monitorID == 1)
		this.r.monitorID := 2
		Yunit.assert(this.r.monitorID == 2)

		this.r.x := 100
		this.r.y := 100
		Yunit.assert(this.r.monitorID == 2)
		this.r.x := 2500
		Yunit.assert(this.r.monitorID == 1)
		dbgOut("<[" A_ThisFunc "]", debug)
	}

	speed() {
		Global debug
		dbgOut(">[" A_ThisFunc "]", debug)
		this.r.speed := 10
		saveSpeed := this.r.speed
		Yunit.assert(this.r.speed == 10)
		this.r.speed := 1
		Yunit.assert(this.r.speed == 1)
		this.r.speed := 20
		Yunit.assert(this.r.speed == 20)
		this.r.speed := saveSpeed
		Yunit.assert(this.r.speed == saveSpeed)
		dbgOut("<[" A_ThisFunc "]", debug)
	}

	move() {
		Global debug
		dbgOut(">[" A_ThisFunc "]", debug)
		this.r.x := 100
		this.r.y := 100
		this.r.movespeed := 25
		this.r.movemode := 1
		this.r.x :=1000
		this.r.movemode := 3
		this.r.pos := new Pointy(500,500)
		this.r.movemode := 2
		this.r.pos := new Pointy(100,100)
		dbgOut("<[" A_ThisFunc "]", debug)
	}

	End() {
		this.r.moveable := 1
		this.remove("r")
		this.r := 
	}
}

; Does not work within YUnit-TestSuite :-(
class ProblematicTestSuite
{
	Begin()	{
	Global debug
	this.r.moveable := 0
	this.r := new Mousy(debug)
	}

	confine() {
		Global debug
		; This UnitTest fails due to failure with YUnit
		dbgOut(">[" A_ThisFunc "]", debug)
		this.r.confine := false
		this.r.pos(1,1)
		pos := this.r.pos 
		this.r.confineRect := new Recty(100,100,100,100)
		this.r.confine := true
		this.r.pos(1,1)
		pos := this.r.pos 
		OutputDebug % pos.Dump()
		this.r.confine := false
		dbgOut("<[" A_ThisFunc "]", debug)
	}

	 trail() {
		Global debug
		CoordMode,Mouse,Screen
		dbgOut(">[" A_ThisFunc "]", debug)
		MouseMove, 1,1,10
		savetrail := this.r.trail
		this.r.trail := 7
		MouseMove, 1000, 1000,10
		Yunit.assert(this.r.trail == 7)
		this.r.trail := 1
		MouseMove, 1,1,10
		Yunit.assert(this.r.trail == 1)
		this.r.trail := savetrail
		dbgOut("<[" A_ThisFunc "]", debug)
	}

	End() {
		this.r.moveable := 1
		this.remove("r")
		this.r := 
	}

}


class _BaseTestSuite {
	Begin() {
		Global debug
	}
	
	Version() {
		Global debug
		dbgOut(">[" A_ThisFunc "]", debug)
		Global ReferenceVersion
		obj := new Mousy(debug)
		OutputDebug % "Mousy Version <" obj.version "> <-> Required <" ReferenceVersion ">"
		Yunit.assert(obj.version == ReferenceVersion)
		dbgOut("<[" A_ThisFunc "]", debug)
	}

	End() {
	}
}

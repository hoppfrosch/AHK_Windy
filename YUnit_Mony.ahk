#NoEnv

#Include %A_ScriptDir%\Yunit\Yunit.ahk
#Include %A_ScriptDir%\Yunit\Window.ahk
#Include %A_ScriptDir%\Yunit\StdOut.ahk
#include <Windy\Mony>
#include <Windy\Recty>
#include <DbgOut>

#Warn All
;#Warn LocalSameAsGlobal, Off
#SingleInstance force

OutputDebug DBGVIEWCLEAR

ReferenceVersion := "1.0.2"
debug := 1

;Yunit.Use(YunitStdOut, YunitWindow).Test(ExpMonyTestSuite)
Yunit.Use(YunitStdOut, YunitWindow).Test(_BaseTestSuite, MonyTestSuite)
Return

ExitApp


class ExpMonyTestSuite {
	Begin() {
		Global debug
;		this.obj := new Mony(1, debug)
		this.monCount := 2
		this.mon1Width := 1920
		this.mon1Height := 1080
  		this.mon2Width := 1920
		this.mon2Height := 1200		
	}

	rectToPercent() {
		Global debug
		dbgOut(">[" A_ThisFunc "]", debug)
		mon1 := new Mony(1, debug)
		rect := new Recty(this.mon1Width/10,this.mon1Height/10,this.mon1Width/5,this.mon1Height/4)
		per := mon1.rectToPercent(rect)
		Yunit.assert(per.x == 100/10)
		Yunit.assert(per.y == 100/10)
		Yunit.assert(per.w == 100/5)
		Yunit.assert(per.h == 100/4)
		dbgOut("<[" A_ThisFunc "]", debug)
	}
	
	End()  {
		this.remove("obj")
		this.obj := 
	}
}

class MonyTestSuite {
	Begin() {
		Global debug
;		this.obj := new Mony(1, debug)
		this.monCount := 2
		this.mon1Width := 1920
		this.mon1Height := 1080
  		this.mon2Width := 1920
		this.mon2Height := 1200		
	}

	_constructor() {
		Global debug
		dbgOut(">[" A_ThisFunc "]", debug)
		mon1 := new Mony(1, debug)
		Yunit.assert(mon1 != false)
		mon99 := new Mony(99, debug)
		Yunit.assert(mon99 = false)
		dbgOut("<[" A_ThisFunc "]", debug)
	}

	boundary() {
		Global debug
		dbgOut(">[" A_ThisFunc "]", debug)
		mon1 := new Mony(1, debug)
		rect1 := mon1.boundary
		Yunit.assert((rect1.w - rect1.x) == this.mon1Width)
		Yunit.assert((rect1.h - rect1.y) == this.mon1Height)	
		mon2 := new Mony(2, debug)
		rect2 := mon2.boundary(2)
		Yunit.assert((rect2.w - rect2.x) == this.mon2Width)
		Yunit.assert((rect2.h - rect2.y) == this.mon2Height)
		Yunit.assert(rect1.x == rect2.w)
		Yunit.assert(rect1.y == rect2.y)
		Yunit.assert(rect1.w == rect2.w + this.mon1Width)
		Yunit.assert(rect1.h == this.mon1Height)
		dbgOut("<[" A_ThisFunc "]", debug)
	}

	center() {
		Global debug
		dbgOut(">[" A_ThisFunc "]", debug)
		mon1 := new Mony(1, debug)
		pt1 := mon1.center
		mon2 := new Mony(2, debug)
		pt2 := mon2.center
		Yunit.assert(pt2.x == this.mon2Width/2)
		Yunit.assert(pt2.y == this.mon2Height/2)
		Yunit.assert(pt1.x == (this.mon2Width+(this.mon1Width/2)))
		Yunit.assert(pt1.y == this.mon1Height/2)
		dbgOut("<[" A_ThisFunc "]", debug)
	}

	coordDisplayToVirtualScreen() {
		Global debug
		dbgOut(">[" A_ThisFunc "]", debug)
		mon1 := new Mony(1, debug)
		mon2 := new Mony(2, debug)
		pt := mon2.coordDisplayToVirtualScreen(10, 10)
		Yunit.assert(pt.x == 10)
		Yunit.assert(pt.y == 10)
		pt := mon1.coordDisplayToVirtualScreen(10, 10)
		Yunit.assert(pt.x == this.mon1Width + 10)
		Yunit.assert(pt.y == 10)
		dbgOut("<[" A_ThisFunc "]", debug)
		return
	}

	hmon() {
		Global debug
		dbgOut(">[" A_ThisFunc "]", debug)
		mon1 := new Mony(1, debug)
		Yunit.assert(mon1.hmon > 0)
		mon2 := new Mony(2, debug)
		Yunit.assert(mon2.hmon > 0)
		Yunit.assert(mon2.hmon != mon1.hmon)
		dbgOut("<[" A_ThisFunc "]", debug)
		return
	}
	
	identify() {
		Global debug
		dbgOut(">[" A_ThisFunc "]", debug)
		mon1 := new Mony(1, debug)
		mon1.identify(250)
		mon2 := new Mony(2, debug)
		mon2.identify(250)
		dbgOut("<[" A_ThisFunc "]", debug)
	}
	
	idNextPrev() {
		Global debug
		dbgOut(">[" A_ThisFunc "]", debug)
		
		; Monitor 1
			mon1 := new Mony(1, debug)
		monNxt := mon1.idNext
		Yunit.assert(monNxt == 2)
		monNxt := mon1.idNext(0)
		Yunit.assert(monNxt == 2)
		monNxt := mon1.idNext(1)
		Yunit.assert(monNxt == 2)
		
		monPrv := mon1.idPrev
		Yunit.assert(monPrv == 2)
		monPrv := mon1.idPrev(0)
		Yunit.assert(monPrv == 1)
		monPrv := mon1.idPrev(1)
		Yunit.assert(monPrv == 2)

		; Monitor 2 ....
		mon2 := new Mony(2, debug)
		monNxt := mon2.idNext
		Yunit.assert(monNxt == 1)
		monNxt := mon2.idNext(0)
		Yunit.assert(monNxt == 2)
		monNxt := mon2.idNext(1)
		Yunit.assert(monNxt == 1)
		
		monPrv := mon2.idPrev
		Yunit.assert(monPrv == 1)
		monPrv := mon2.idPrev(0)
		Yunit.assert(monPrv == 1)
		monPrv := mon2.idPrev(1)
		Yunit.assert(monPrv == 1)
		
		dbgOut("<[" A_ThisFunc "]", debug)
	}

	info() {
		Global debug
		dbgOut(">[" A_ThisFunc "]", debug)
		mon1 := new Mony(1, debug)
		info := mon1.info
		bound := mon1.boundary
		Yunit.assert(info.boundary.x = bound.x)
		Yunit.assert(info.boundary.y = bound.y)
		Yunit.assert(info.boundary.w = bound.w)
		Yunit.assert(info.boundary.h = bound.h)
		mon2 := new Mony(2, debug)
		info := mon2.info
		bound := mon2.boundary
		Yunit.assert(info.boundary.x = bound.x)
		Yunit.assert(info.boundary.y = bound.y)
		Yunit.assert(info.boundary.w = bound.w)
		Yunit.assert(info.boundary.h = bound.h)
		dbgOut("<[" A_ThisFunc "]", debug)
	}

	monitorsCount() {
		Global debug
		dbgOut(">[" A_ThisFunc "]", debug)
		mon1 := new Mony(1, debug)
		cnt := mon1.monitorsCount
		Yunit.assert(cnt == this.monCount)
		dbgOut("<[" A_ThisFunc "]", debug)
	}

	primary() {
		Global debug
		dbgOut(">[" A_ThisFunc "]", debug)
		mon1 := new Mony(1, debug)
		Yunit.assert(mon1.primary = false)
		mon2 := new Mony(2, debug)
		Yunit.assert(mon2.primary = true)
		dbgOut("<[" A_ThisFunc "]", debug)
	}

	rectToPercent() {
		Global debug
		dbgOut(">[" A_ThisFunc "]", debug)
		mon2 := new Mony(2, debug)
		rect := new Recty(this.mon2Width/10,this.mon2Height/10,this.mon2Width/5,this.mon2Height/4)
		per := mon2.rectToPercent(rect)
		Yunit.assert(per.x == 100/10)
		Yunit.assert(per.y == 100/10)
		Yunit.assert(per.w == 100/5)
		Yunit.assert(per.h == 100/4)
		dbgOut("<[" A_ThisFunc "]", debug)
	}
		
	size() {
		Global debug
		dbgOut(">[" A_ThisFunc "]", debug)
		mon1 := new Mony(1, debug)
		sx := mon1.scaleX(1)
		Yunit.assert(sx == 1)
		sy := mon1.scaleY(1)
		Yunit.assert(sy == 1)
		sc := mon1.scale(1)
		Yunit.assert(sc.x == 1)
		Yunit.assert(sc.y == 1)

		sx := mon1.scaleX(2)
		sx := Round(sx*1000)/1000
		dx := this.mon2Width/this.mon1Width
		dx := Round(dx*1000)/1000
		Yunit.assert(Round(sx*1000)/1000 == Round(dx*1000)/1000)
		sy := mon1.scaleY(2)
		dy := this.mon2Height/this.mon1Height
		Yunit.assert(Round(sy*1000)/1000 == Round(dy*1000)/1000)
		sc := mon1.scale(2)
		Yunit.assert(Round(sx*1000)/1000 == Round(dx*1000)/1000)
		Yunit.assert(Round(sy*1000)/1000 == Round(dy*1000)/1000)
		dbgOut("<[" A_ThisFunc "]", debug)
	}

	virtualScreenSize() {
		Global debug
		dbgOut(">[" A_ThisFunc "]", debug)
		mon1 := new Mony(1, debug)
		rect := mon1.virtualScreenSize()
		Yunit.assert(rect.x == 0)
		Yunit.assert(rect.y == 0)
		Yunit.assert(rect.w == (this.mon1Width + this.mon2Width))
		Yunit.assert(rect.h == this.mon2Height)
		dbgOut("<[" A_ThisFunc "]", debug)
	}

	workingArea() {
		Global debug
		dbgOut(">[" A_ThisFunc "]", debug)
		mon1 := new Mony(1, debug)
		rect := mon1.workingArea
		Yunit.assert(rect.w <= this.mon1Width)
		Yunit.assert(rect.h <= this.mon1Height)	
		dbgOut("<[" A_ThisFunc "]", debug)
	}

	End()  {
;		this.remove("obj")
;		this.obj := 
	}

}

class _BaseTestSuite {
	Begin() {
	}
	
	Version() {
		Global debug
		dbgOut(">[" A_ThisFunc "]", debug)
		Global ReferenceVersion
		iMony := new Mony(1, debug)
		dbgOut("= Mony Version <" iMony.version "> <-> Required <" ReferenceVersion ">")
		Yunit.assert(iMony.version == ReferenceVersion)
		dbgOut("<[" A_ThisFunc "]", debug)
	}

	End() {
	}
}

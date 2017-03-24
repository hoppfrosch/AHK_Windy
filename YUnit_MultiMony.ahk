#NoEnv

#Include %A_ScriptDir%\Yunit\Yunit.ahk
#Include %A_ScriptDir%\Yunit\Window.ahk
#Include %A_ScriptDir%\Yunit\StdOut.ahk
#include <Windy\MultiMony>
#include <Windy\Mony>
#include <Windy\Recty>
#include <Windy\Windy>
#include <DbgOut>

#Warn All
;#Warn LocalSameAsGlobal, Off
#SingleInstance force

OutputDebug DBGVIEWCLEAR

ReferenceVersion := "1.0.3"
debug := 1

;Yunit.use(YunitStdOut, YunitWindow).Test(ExpMultiMonyTestSuite)
Yunit.Use(YunitStdOut, YunitWindow).Test(_BaseTestSuite, MultiMonyTestSuite)
Return

class ExpMultiMonyTestSuite {
	Begin() {
		Global debug
		this.obj := new MultiMony(debug)
		this.monCount := 2
		this.mon1Width := 1920
		this.mon1Height := 1200
		this.mon2Width := 1920
		this.mon2Height := 1080
	
		this.monvirtWidth := this.mon1Width + this.mon2Width
		this.monvirtHeight := this.mon1Height
    }
	
	monitors() {
		Global debug
		dbgOut(">[" A_ThisFunc "]", debug)
		mcRef := this.obj.monitorsCount
		mons := this.obj.monitors()
		mc := mons.MaxIndex()
		Yunit.assert( mcRef == mc)
		dbgOut("<[" A_ThisFunc "]", debug)
	}
	
   	End()  {
        this.remove("obj")
		this.obj := 
    }
}

class MultiMonyTestSuite
{
	Begin() {
		Global debug
		this.obj := new MultiMony(debug)
		this.monCount := 2
		this.mon1Width := 1920
		this.mon1Height := 1200
		this.mon2Width := 1920
		this.mon2Height := 1080
	
		this.monvirtWidth := this.mon1Width + this.mon2Width
		this.monvirtHeight := this.mon1Height
    }

    idPrimary() {
    	Global debug
		dbgOut(">[" A_ThisFunc "]", debug)
		prim := this.obj.idPrimary
		Yunit.assert(prim == 2)
		tb := this.obj.idTaskbar
		Yunit.assert(tb == prim)
		Yunit.assert(tb == 2)
		dbgOut("<[" A_ThisFunc "]", debug)
    }

	coordDisplayToVirtualScreen() {
		Global debug
		dbgOut(">[" A_ThisFunc "]", debug)
		pt := this.obj.coordDisplayToVirtualScreen(2, 10, 10)
		Yunit.assert(pt.x == 10)
		Yunit.assert(pt.y == 10)
		pt := this.obj.coordDisplayToVirtualScreen(1, 10, 10)
		Yunit.assert(pt.x == this.mon2Width + 10)
		Yunit.assert(pt.y == 10)
		dbgOut("<[" A_ThisFunc "]", debug)
	}
    coordVirtualScreenToDisplay() {
    	Global debug
		dbgOut(">[" A_ThisFunc "]", debug)
		x := this.obj.coordVirtualScreenToDisplay(10,10)
		Yunit.assert(x.monID == 2)
		Yunit.assert(x.pt.x == 10)
		Yunit.assert(x.pt.y == 10)
    	x := this.obj.coordVirtualScreenToDisplay(1930,10)
		Yunit.assert(x.monID == 1)
		Yunit.assert(x.pt.x == 10)
		Yunit.assert(x.pt.y == 10)
		dbgOut("<[" A_ThisFunc "]", debug)
    }
	hmonFromCoord() {
		Global debug
		dbgOut(">[" A_ThisFunc "]", debug)
		monId := this.obj.idFromCoord(10,10)
		hmonRef := this.obj.hmonFromId(monId)
		hmon := this.obj.hmonFromCoord(10,10)
		Yunit.assert(hmon == hmonRef)
		dbgOut("<[" A_ThisFunc "]", debug)
	}
	hmonFromId() {
		Global debug
		dbgOut(">[" A_ThisFunc "]", debug)
		hmonRef := this.obj.hmonFromCoord(10,10)
		monId := this.obj.idFromCoord(10,10)
		hmon := this.obj.hmonFromId(monId)
		Yunit.assert(hmon == hmonRef)
		dbgOut("<[" A_ThisFunc "]", debug)
	}
	hmonFromRect() {
		Global debug
		dbgOut(">[" A_ThisFunc "]", debug)
		hmonRef := this.obj.hmonFromId(2)
		win := new Windy(0, debug)
		win.move(10,10)
		rect := win.possize
		hmon := this.obj.hmonFromRect(rect.x, rect.y, rect.w, rect.h)
		Yunit.assert(hmon == hmonRef)
		win.kill()
		dbgOut("<[" A_ThisFunc "]", debug)
	}
	hmonFromHwnd() {
		Global debug
		dbgOut(">[" A_ThisFunc "]", debug)
		hmonRef := this.obj.hmonFromId(2)
		win := new Windy(0, debug)
		win.move(10,10)
		hwnd := win.hwnd
		hmon := this.obj.hmonFromHwnd(hwnd)
		Yunit.assert(hmon == hmonRef)
		win.kill()
		dbgOut("<[" A_ThisFunc "]", debug)
	}	
	identify() {
		Global debug
		dbgOut(">[" A_ThisFunc "]", debug)
		this.obj.identify(250, "00FF00")
		dbgOut("<[" A_ThisFunc "]", debug)
	}
	idFromCoord() {
		Global debug
		dbgOut(">[" A_ThisFunc "]", debug)
		mon := this.obj.idFromCoord(10,10)
		Yunit.assert(mon == 2)
		mon2 := new Mony(2, debug)
		rect := mon2.size
		mon := this.obj.idFromCoord(rect.w+10,10)
		Yunit.assert(mon == 1)
		dbgOut("<[" A_ThisFunc "]", debug)
	}
	idFromHmon() {
		Global debug
		dbgOut(">[" A_ThisFunc "]", debug)
		monId := this.obj.idFromCoord(10,10)
		monH := this.obj.hmonFromCoord(10,10)
		monID2 := this.obj.idFromHmon(monH)
		Yunit.assert(monId == monId2)
		dbgOut("<[" A_ThisFunc "]", debug)
	}
	idFromRect() {
		Global debug
		dbgOut(">[" A_ThisFunc "]", debug)
		win := new Windy(0, debug)
		idRef := 2
		win.move(10,10)
		rect := win.possize
		id := this.obj.idFromRect(rect.x, rect.y, rect.w, rect.h)
		Yunit.assert(id == idRef)
		win.kill()
		dbgOut("<[" A_ThisFunc "]", debug)
	}
	idFromHwnd() {
		Global debug
		dbgOut(">[" A_ThisFunc "]", debug)
		win := new Windy(0, debug)
		win.move(10,10)
		hwnd := win.hwnd
		id := this.obj.idFromHwnd(hwnd)
		Yunit.assert(id == 2)
		win.kill()
		dbgOut("<[" A_ThisFunc "]", debug)
	}
	idFromMouse() {	
		Global debug
		dbgOut(">[" A_ThisFunc "]", debug)
		MouseGetPos,x_back,y_back 
		MouseMove,10,10
		mon := this.obj.idFromMouse()
		Yunit.assert(mon == 2)
		mon2 := new Mony(2, debug)
		rect := mon2.size
		MouseMove,rect.w+10,10
		mon := this.obj.idFromMouse()
		Yunit.assert(mon == 1)
		MouseMove,x_back, y_back
		dbgOut("<[" A_ThisFunc "]", debug)
	}
	idNextPrev() {
		Global debug
		dbgOut(">[" A_ThisFunc "]", debug)

		; Monitor 1
		monNxt := this.obj.idNext(1)
		Yunit.assert(monNxt == 2)
		monNxt := this.obj.idNext(1,0)
		Yunit.assert(monNxt == 2)
		monNxt := this.obj.idNext(1,1)
		Yunit.assert(monNxt == 2)
		
		monPrv := this.obj.idPrev(1)
		Yunit.assert(monPrv == 2)
		monPrv := this.obj.idPrev(1,0)
		Yunit.assert(monPrv == 1)
		monPrv := this.obj.idPrev(1, 1)
		Yunit.assert(monPrv == 2)

		; Monitor 2 ....
		monNxt :=this.obj.idNext(2)
		Yunit.assert(monNxt == 1)
		monNxt := this.obj.idNext(2,0)
		Yunit.assert(monNxt == 2)
		monNxt := this.obj.idNext(2,1)
		Yunit.assert(monNxt == 1)
		
		monPrv := this.obj.idPrev(2)
		Yunit.assert(monPrv == 1)
		monPrv := this.obj.idPrev(2,0)
		Yunit.assert(monPrv == 1)
		monPrv := this.obj.idPrev(2,1)
		Yunit.assert(monPrv == 1)
		
		dbgOut("<[" A_ThisFunc "]", debug)
	}
	monitors() {
		Global debug
		dbgOut(">[" A_ThisFunc "]", debug)
		mcRef := this.obj.monitorsCount
		mons := this.obj.monitors()
		mc := mons.MaxIndex()
		Yunit.assert( mcRef == mc)
		dbgOut("<[" A_ThisFunc "]", debug)
	}
   	monitorsCount() {
    	Global debug
		dbgOut(">[" A_ThisFunc "]", debug)
		cnt := this.obj.monitorsCount
		Yunit.assert(cnt == this.monCount)
		dbgOut("<[" A_ThisFunc "]", debug)
	}
	size() {
		Global debug
		dbgOut(">[" A_ThisFunc "]", debug)
		rect :=  this.obj.virtualScreenSize
		Yunit.assert(rect.x == 0)
		Yunit.assert(rect.y == 0)
		Yunit.assert(rect.w == this.monvirtWidth)
		Yunit.assert(rect.h == this.monvirtHeight)
		dbgOut("<[" A_ThisFunc "]", debug)
	}
	virtualScreenSize() {
		Global debug
		dbgOut(">[" A_ThisFunc "]", debug)
		rect :=  this.obj.size
		Yunit.assert(rect.x == 0)
		Yunit.assert(rect.y == 0)
		Yunit.assert(rect.w == this.monvirtWidth)
		Yunit.assert(rect.h == this.monvirtHeight)
		dbgOut("<[" A_ThisFunc "]", debug)
	}

	End()  {
        this.remove("obj")
		this.obj := 
    }
}

class _BaseTestSuite {
    Begin() {
	}
	
	Version() {
		Global debug
		dbgOut(">[" A_ThisFunc "]", debug)
		Global ReferenceVersion
		md := new MultiMony(debug)
		Yunit.assert(md.version == ReferenceVersion)
		dbgOut("= " A_ThisFunc " <" md.version "> <-> Required <" ReferenceVersion ">", debug)
		dbgOut("<[" A_ThisFunc "]", debug)
	}

	End() {
	}
}
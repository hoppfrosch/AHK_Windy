#NoEnv

#Include %A_ScriptDir%\Yunit\Yunit.ahk
#Include %A_ScriptDir%\Yunit\Window.ahk
#Include %A_ScriptDir%\Yunit\StdOut.ahk
#include lib\Windy\MultiDispy.ahk
#include lib\Windy\Dispy.ahk
#include lib\Windy\Recty.ahk
#include lib\Windy\Windy.ahk
#Warn All
;#Warn LocalSameAsGlobal, Off
#SingleInstance force

ReferenceVersion := "0.2.3"
debug := 1

;Yunit.use(YunitStdOut, YunitWindow).Test(ExpMultiDispyTestSuite)
Yunit.Use(YunitStdOut, YunitWindow).Test(_BaseTestSuite, MultiDispyTestSuite)
ExitApp

class ExpMultiDispyTestSuite {
	Begin() {
		Global debug
		this.obj := new MultiDispy(debug)
		this.monCount := 2
		this.mon1Width := 1920
		this.mon1Height := 1080
		this.mon2Width := 1600
		this.mon2Height := 1200
		
		this.monvirtWidth := this.mon1Width + this.mon2Width
		this.monvirtHeight := this.mon2Height
    }

	monitors() {
		Global debug
		OutputDebug % ">>>>>[" A_ThisFunc "]>>>>>"
		mcRef := this.obj.monitorsCount
		; HINT: Test is valid - but makes YUnit to terminate. Therefore it's disabled
		mons := this.obj.monitors()
		mc := mons.MaxIndex()
		Yunit.assert( mcRef == mc)
		OutputDebug % "<<<<<[" A_ThisFunc "]<<<<<"
	}
	
   	End()  {
        this.remove("obj")
		this.obj := 
    }
}

class MultiDispyTestSuite
{
	Begin() {
		Global debug
		this.obj := new MultiDispy(debug)
		this.monCount := 2
		this.mon1Width := 1920
		this.mon1Height := 1080
		this.mon2Width := 1600
		this.mon2Height := 1200
		
		this.monvirtWidth := this.mon1Width + this.mon2Width
		this.monvirtHeight := this.mon2Height
    }

	coordDisplayToVirtualScreen() {
		Global debug
		OutputDebug % ">>>>>[" A_ThisFunc "]>>>>>"
		pt := this.obj.coordDisplayToVirtualScreen(1, 10, 10)
		Yunit.assert(pt.x == 10)
		Yunit.assert(pt.y == 10)
		pt := this.obj.coordDisplayToVirtualScreen(2, 10, 10)
		Yunit.assert(pt.x == this.mon1Width + 10)
		Yunit.assert(pt.y == 10)
		OutputDebug % "<<<<<[" A_ThisFunc "]<<<<<"
	}
    coordVirtualScreenToDisplay() {
    	Global debug
		OutputDebug % ">>>>>[" A_ThisFunc "]>>>>>"
		x := this.obj.coordVirtualScreenToDisplay(10,10)
		Yunit.assert(x.monID == 1)
		Yunit.assert(x.pt.x == 10)
		Yunit.assert(x.pt.y == 10)
    	x := this.obj.coordVirtualScreenToDisplay(1930,10)
		Yunit.assert(x.monID == 2)
		Yunit.assert(x.pt.x == 10)
		Yunit.assert(x.pt.y == 10)
		OutputDebug % "<<<<<[" A_ThisFunc "]<<<<<"
    }
	hmonFromCoord() {
		Global debug
		OutputDebug % ">>>>>[" A_ThisFunc "]>>>>>"
		monId := this.obj.idFromCoord(10,10)
		hmonRef := this.obj.hmonFromId(monId)
		hmon := this.obj.hmonFromCoord(10,10)
		Yunit.assert(hmon == hmonRef)
		OutputDebug % "<<<<<[" A_ThisFunc "]<<<<<"
	}
	hmonFromId() {
		Global debug
		OutputDebug % ">>>>>[" A_ThisFunc "]>>>>>"
		hmonRef := this.obj.hmonFromCoord(10,10)
		monId := this.obj.idFromCoord(10,10)
		hmon := this.obj.hmonFromId(monId)
		Yunit.assert(hmon == hmonRef)
		OutputDebug % "<<<<<[" A_ThisFunc "]<<<<<"
	}
	hmonFromRect() {
		Global debug
		OutputDebug % ">>>>>[" A_ThisFunc "]>>>>>"
		hmonRef := this.obj.hmonFromId(1)
		win := new Windy(0, debug)
		win.move(10,10)
		rect := win.possize
		hmon := this.obj.hmonFromRect(rect.x, rect.y, rect.w, rect.h)
		Yunit.assert(hmon == hmonRef)
		win.kill()
		OutputDebug % "<<<<<[" A_ThisFunc "]<<<<<"
	}
	hmonFromHwnd() {
		Global debug
		OutputDebug % ">>>>>[" A_ThisFunc "]>>>>>"
		hmonRef := this.obj.hmonFromId(1)
		win := new Windy(0, debug)
		win.move(10,10)
		hwnd := win.hwnd
		hmon := this.obj.hmonFromHwnd(hwnd)
		Yunit.assert(hmon == hmonRef)
		win.kill()
		OutputDebug % "<<<<<[" A_ThisFunc "]<<<<<"
	}	
	identify() {
    	Global debug
		OutputDebug % ">>>>>[" A_ThisFunc "]>>>>>"
    	this.obj.identify(250, "00FF00")
		OutputDebug % "<<<<<[" A_ThisFunc "]<<<<<"
	}
	idFromCoord() {
		Global debug
		OutputDebug % ">>>>>[" A_ThisFunc "]>>>>>"
		mon := this.obj.idFromCoord(10,10)
		Yunit.assert(mon == 1)
		mon1 := new Dispy(1, debug)
		rect := mon1.size
		mon := this.obj.idFromCoord(rect.w+10,10)
		Yunit.assert(mon == 2)
		OutputDebug % "<<<<<[" A_ThisFunc "]<<<<<"
	}
	idFromHmon() {
		Global debug
		OutputDebug % ">>>>>[" A_ThisFunc "]>>>>>"
		monId := this.obj.idFromCoord(10,10)
		monH := this.obj.hmonFromCoord(10,10)
		monID2 := this.obj.idFromHmon(monH)
		Yunit.assert(monId == monId2)
		OutputDebug % "<<<<<[" A_ThisFunc "]<<<<<"
	}
	idFromRect() {
		Global debug
		OutputDebug % ">>>>>[" A_ThisFunc "]>>>>>"
		win := new Windy(0, debug)
		idRef := 1
		win.move(10,10)
		rect := win.possize
		id := this.obj.idFromRect(rect.x, rect.y, rect.w, rect.h)
		Yunit.assert(id == idRef)
		win.kill()
		OutputDebug % "<<<<<[" A_ThisFunc "]<<<<<"
	}
	idFromHwnd() {
		Global debug
		OutputDebug % ">>>>>[" A_ThisFunc "]>>>>>"
		win := new Windy(0, debug)
		win.move(10,10)
		hwnd := win.hwnd
		id := this.obj.idFromHwnd(hwnd)
		Yunit.assert(id == 1)
		win.kill()
		OutputDebug % "<<<<<[" A_ThisFunc "]<<<<<"
	}
	idFromMouse() {	
		Global debug
		OutputDebug % ">>>>>[" A_ThisFunc "]>>>>>"
		MouseGetPos,x_back,y_back 
		MouseMove,10,10
		mon := this.obj.idFromMouse()
		Yunit.assert(mon == 1)
		mon1 := new Dispy(1, debug)
		rect := mon1.size
		MouseMove,rect.w+10,10
		mon := this.obj.idFromMouse()
		Yunit.assert(mon == 2)
		MouseMove,x_back, y_back
		OutputDebug % "<<<<<[" A_ThisFunc "]<<<<<"
	}
	idNextPrev() {
		Global debug
		OutputDebug % ">>>>>[" A_ThisFunc "]>>>>>"

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
		
		OutputDebug % "<<<<<[" A_ThisFunc "]<<<<<"
	}
	monitors() {
		Global debug
		OutputDebug % ">>>>>[" A_ThisFunc "]>>>>>"
		mcRef := this.obj.monitorsCount
		mons := this.obj.monitors()
		mc := mons.MaxIndex()
		Yunit.assert( mcRef == mc)
		OutputDebug % "<<<<<[" A_ThisFunc "]<<<<<"
	}
   	monitorsCount() {
    	Global debug
		OutputDebug % ">>>>>[" A_ThisFunc "]>>>>>"
		cnt := this.obj.monitorsCount
		Yunit.assert(cnt == this.monCount)
		OutputDebug % "<<<<<[" A_ThisFunc "]<<<<<"
	}
	size() {
		Global debug
		OutputDebug % ">>>>>[" A_ThisFunc "]>>>>>"
		rect :=  this.obj.virtualScreenSize
		Yunit.assert(rect.x == 0)
		Yunit.assert(rect.y == 0)
		Yunit.assert(rect.w == this.monvirtWidth)
		Yunit.assert(rect.h == this.monvirtHeight)
		OutputDebug % "<<<<<[" A_ThisFunc "]<<<<<"
	}
	virtualScreenSize() {
		Global debug
		OutputDebug % ">>>>>[" A_ThisFunc "]>>>>>"
		rect :=  this.obj.size
		Yunit.assert(rect.x == 0)
		Yunit.assert(rect.y == 0)
		Yunit.assert(rect.w == this.monvirtWidth)
		Yunit.assert(rect.h == this.monvirtHeight)
		OutputDebug % "<<<<<[" A_ThisFunc "]<<<<<"
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
		OutputDebug % ">>>>>[" A_ThisFunc "]>>>>>"
		Global ReferenceVersion
		md := new MultiDispy(debug)
		Yunit.assert(md.version == ReferenceVersion)
		OutputDebug % A_ThisFunc " <" md.version "> <-> Required <" ReferenceVersion ">"
		OutputDebug % ">>>>[" A_ThisFunc "]>>>>"
	}

	End() {
	}
}
;#NoEnv
#Warn

#Include %A_ScriptDir%\Yunit\Yunit.ahk
#Include %A_ScriptDir%\Yunit\Window.ahk
#Include %A_ScriptDir%\Yunit\StdOut.ahk
#include <Rectangle>
#include <WindowHandler>

; #Warn All
;#Warn LocalSameAsGlobal, Off
#SingleInstance force


ReferenceVersion := "0.5.0"
debug := 1


;Yunit.Use(YunitStdOut, YunitWindow).Test(RollupTestSuite)
Yunit.Use(YunitStdOut, YunitWindow).Test(MiscTestSuite, NotRealWindowTestSuite, HideShowTestSuite, ExistTestSuite, RollupTestSuite, MoveResizeTestSuite, TileTestSuite)
Return

; ###################################################################
class TempTestSuite
{
    Begin()
    {
		Global debug
		this.obj := new WindowHandler(0, debug)
    }
 
	End()
    {
		this.obj.kill()
        this.remove("obj")
		this.obj := 
    }
}

class TileTestSuite 
{
	Begin()
    {
		Global debug
		this.obj := new WindowHandler(0, debug)
    }
	
	movePercental() {
		Global debug

		OutputDebug % "<<<<<<<<<<<<<<<<<<<[" A_ThisFunc "]>>>>>>>>>>>>>>>>>>>>>>>>>>"
		this.obj.movePercental(25, 25, 50, 50)
		MsgBox % A_ThisFunc " - To be done ..."
		OutputDebug % ">>>>>>>>>>>>>>>>>>>[" A_ThisFunc "]<<<<<<<<<<<<<<<<<<<<<<<<<<"
	}
	
	End()
    {
		this.obj.kill()
        this.remove("obj")
		this.obj := 
    }
}


class RollupTestSuite 
{
	Begin()
    {
		Global debug
		this.obj := new WindowHandler(0, debug)
    }
	
	RollupToggle() {
		Global debug

		OutputDebug % "<<<<<<<<<<<<<<<<<<<[" A_ThisFunc "]>>>>>>>>>>>>>>>>>>>>>>>>>>"
		OutputDebug % "******************************* " A_ThisFunc " 1 ****************************"
		val := this.obj.rolledUp
		Yunit.assert(val == false)
		
		OutputDebug % "******************************* " A_ThisFunc " 2 ****************************"
		this.obj.rollup(false)
		val := this.obj.rolledUp
		Yunit.assert(val == false)
		
		OutputDebug % "******************************* " A_ThisFunc " 3 ****************************"
		this.obj.rollup(true)
		val := this.obj.rolledUp
		Yunit.assert(val == true)
		
		OutputDebug % "******************************* " A_ThisFunc " 4 ****************************"
		this.obj.rollup(false)
		val := this.obj.rolledUp
		Yunit.assert(val == false)
		
		OutputDebug % "******************************* " A_ThisFunc " 5 ****************************"
		this.obj.rollup("toggle") ; as the window wasn't rolled up, it should be rolled up now
		val := this.obj.rolledUp
		Yunit.assert(val == true)
		
		OutputDebug % "******************************* " A_ThisFunc " 6 ****************************"
		this.obj.rollup("toggle") ; as the window was rolled up, it shouldn't be rolled up now
		val := this.obj.rolledUp
		Yunit.assert(val == false)

		OutputDebug % "******************************* " A_ThisFunc " 7 ****************************"
		this.End()
		val := this.obj.rolledUp
		Yunit.assert(val == )
		OutputDebug % ">>>>>>>>>>>>>>>>>>>[" A_ThisFunc "]<<<<<<<<<<<<<<<<<<<<<<<<<<"
	}
	
	End()
    {
		this.obj.kill()
        this.remove("obj")
		this.obj := 
    }
}


; ###################################################################
class MoveResizeTestSuite
{
    Begin()
    {
		Global debug
		this.obj := new WindowHandler(0, debug)
    }
 
	Maximize() 
	{
		OutputDebug % "<<<<<<<<<<<<<<<<<<<[" A_ThisFunc "]>>>>>>>>>>>>>>>>>>>>>>>>>>"
		Yunit.assert(this.obj.maximized == false)
		Yunit.assert(this.obj.minimized == false)
		this.obj.maximize(true)
		Yunit.assert(this.obj.maximized == true)
		Yunit.assert(this.obj.minimized == false)
		this.obj.maximize(false)
		Yunit.assert(this.obj.maximized == false)
		Yunit.assert(this.obj.minimized == false)
		this.obj.maximize("toggle")
		Yunit.assert(this.obj.maximized == true)
		Yunit.assert(this.obj.minimized == false)
		this.obj.maximize("toggle")
		Yunit.assert(this.obj.maximized == false)
		Yunit.assert(this.obj.minimized == false)
		OutputDebug % ">>>>>>>>>>>>>>>>>>>[" A_ThisFunc "]<<<<<<<<<<<<<<<<<<<<<<<<<<"
		
	}
	
	Minimize() 
	{
		OutputDebug % "<<<<<<<<<<<<<<<<<<<[" A_ThisFunc "]>>>>>>>>>>>>>>>>>>>>>>>>>>"
		Yunit.assert(this.obj.maximized == false)
		Yunit.assert(this.obj.minimized == false)
		this.obj.minimize(true)
		Yunit.assert(this.obj.maximized == false)
		Yunit.assert(this.obj.minimized == true)
		this.obj.minimize(false)
		Yunit.assert(this.obj.maximized == false)
		Yunit.assert(this.obj.minimized == false)
		this.obj.minimize("toggle")
		Yunit.assert(this.obj.maximized == false)
		Yunit.assert(this.obj.minimized == true)
		this.obj.minimize("toggle")
		Yunit.assert(this.obj.maximized == false)
		Yunit.assert(this.obj.minimized == false)
		OutputDebug % ">>>>>>>>>>>>>>>>>>>[" A_ThisFunc "]<<<<<<<<<<<<<<<<<<<<<<<<<<"
		
	}
	
    MoveViaWinMove()
    {
		OutputDebug % "<<<<<<<<<<<<<<<<<<<[" A_ThisFunc "]>>>>>>>>>>>>>>>>>>>>>>>>>>"
		oldPos := this.obj.pos
		OutputDebug % "Initial Position: " oldPos.Dump()
		
        xnew := oldPos.x+200
		ynew := oldPos.y+200
		
		OutputDebug % "BEFORE - Moving from " oldPos.Dump() " to (" xnew "," ynew "," oldPos.w "," oldPos.h ")"
		WinMove % "ahk_id" this.obj._hWnd, ,xnew, ynew
		newPos := this.obj.pos
        OutputDebug % "AFTER - Moving from " oldPos.Dump() " to " newPos.Dump()
		Yunit.assert(newPos.x == xnew)
		Yunit.assert(newPos.y == ynew)
		Yunit.assert(newPos.w == oldPos.w)
		Yunit.assert(newPos.h == oldPos.h)
        OutputDebug % ">>>>>>>>>>>>>>>>>>>[" A_ThisFunc "]<<<<<<<<<<<<<<<<<<<<<<<<<<"
    }
	
	MoveViaMoveMethod()
    {
		OutputDebug % "<<<<<<<<<<<<<<<<<<<[" A_ThisFunc "]>>>>>>>>>>>>>>>>>>>>>>>>>>"
		oldPos := this.obj.pos
		OutputDebug % "Initial Position: " oldPos.Dump()
		
        xnew := oldPos.x+200
		ynew := oldPos.y+200
		
		OutputDebug % "BEFORE - Moving from " oldPos.Dump() " to (" xnew "," ynew "," oldPos.w "," oldPos.h ")"
		this.obj.move(xnew, ynew, oldPos.w, oldPos.h)
		newPos := this.obj.pos
        OutputDebug % "AFTER - Moving from " oldPos.Dump() " to " newPos.Dump()
		Yunit.assert(newPos.x == xnew)
		Yunit.assert(newPos.y == ynew)
		Yunit.assert(newPos.w == oldPos.w)
		Yunit.assert(newPos.h == oldPos.h)
        OutputDebug % ">>>>>>>>>>>>>>>>>>>[" A_ThisFunc "]<<<<<<<<<<<<<<<<<<<<<<<<<<"
    }
	
    MoveResizeViaWinMove()
    {
        OutputDebug % "<<<<<<<<<<<<<<<<<<<[" A_ThisFunc "]>>>>>>>>>>>>>>>>>>>>>>>>>>"
        oldPos := this.obj.pos
		OutputDebug % "Initial Position: " oldPos.Dump()
        
		xnew := oldPos.x+10
		ynew := oldPos.y+20
        wnew := oldPos.w+10
		hnew := oldPos.h+20
		OutputDebug % "BEFORE - Moving from " oldPos.Dump() " to (" xnew "," ynew "," wnew "," hnew ")"
        WinMove % "ahk_id" this.obj._hWnd, , xnew, ynew, wnew, hnew
		newPos := this.obj.pos
        OutputDebug % "AFTER - Moving from " oldPos.Dump() " to " newPos.Dump()
        Yunit.assert(newPos.x == xnew)
		Yunit.assert(newPos.y == ynew)
		Yunit.assert(newPos.w == wnew)
		Yunit.assert(newPos.h == hnew)
		
        OutputDebug % ">>>>>>>>>>>>>>>>>>>[" A_ThisFunc "]<<<<<<<<<<<<<<<<<<<<<<<<<<"
    }

	MoveResizeViaMoveMehod()
    {
        OutputDebug % "<<<<<<<<<<<<<<<<<<<[" A_ThisFunc "]>>>>>>>>>>>>>>>>>>>>>>>>>>"
        oldPos := this.obj.pos
		OutputDebug % "Initial Position: " oldPos.Dump()
        
		xnew := oldPos.x+10
		ynew := oldPos.y+20
        wnew := oldPos.w+10
		hnew := oldPos.h+20
		OutputDebug % "BEFORE - Moving from " oldPos.Dump() " to (" xnew "," ynew "," wnew "," hnew ")"
        this.obj.move(xnew, ynew, wnew, hnew)
		newPos := this.obj.pos
        OutputDebug % "AFTER - Moving from " oldPos.Dump() " to " newPos.Dump()
        Yunit.assert(newPos.x == xnew)
		Yunit.assert(newPos.y == ynew)
		Yunit.assert(newPos.w == wnew)
		Yunit.assert(newPos.h == hnew)
		
        OutputDebug % ">>>>>>>>>>>>>>>>>>>[" A_ThisFunc "]<<<<<<<<<<<<<<<<<<<<<<<<<<"
    }
	
    ResizeViaWinMove()
    {
		OutputDebug % "<<<<<<<<<<<<<<<<<<<[" A_ThisFunc "]>>>>>>>>>>>>>>>>>>>>>>>>>>"
        oldPos := this.obj.pos
		OutputDebug % "Initial Position: " oldPos.Dump()
        
        wnew := oldPos.w+100
		hnew := oldPos.h+200
		
		OutputDebug % "BEFORE - Moving from " oldPos.Dump() " to (" oldPos.x "," oldPos.y "," wnew "," hnew ")"
        WinMove % "ahk_id" this.obj._hWnd, , oldPos.x, oldPos.y, wnew, hnew
		newPos := this.obj.pos
        OutputDebug % "AFTER - Moving from " oldPos.Dump() " to " newPos.Dump()
        Yunit.assert(newPos.x == oldPos.x)
		Yunit.assert(newPos.y == oldPos.y)
		Yunit.assert(newPos.w == wnew)
		Yunit.assert(newPos.h == hnew)
		
        OutputDebug % ">>>>>>>>>>>>>>>>>>>[" A_ThisFunc "]<<<<<<<<<<<<<<<<<<<<<<<<<<"
    }
	
	
	ResizeViaMoveMethod()
    {
		OutputDebug % "<<<<<<<<<<<<<<<<<<<[" A_ThisFunc "]>>>>>>>>>>>>>>>>>>>>>>>>>>"
        oldPos := this.obj.pos
		OutputDebug % "Initial Position: " oldPos.Dump()
        
        wnew := oldPos.w+100
		hnew := oldPos.h+200
		
		OutputDebug % "BEFORE - Moving from " oldPos.Dump() " to (" oldPos.x "," oldPos.y "," wnew "," hnew ")"
        this.obj.move(oldPos.x, oldPos.y, wnew, hnew)
		newPos := this.obj.pos
        OutputDebug % "AFTER - Moving from " oldPos.Dump() " to " newPos.Dump()
        Yunit.assert(newPos.x == oldPos.x)
		Yunit.assert(newPos.y == oldPos.y)
		Yunit.assert(newPos.w == wnew)
		Yunit.assert(newPos.h == hnew)
		
        OutputDebug % ">>>>>>>>>>>>>>>>>>>[" A_ThisFunc "]<<<<<<<<<<<<<<<<<<<<<<<<<<"
    }
	

	NoMoveResizeViaWinMove() {
		OutputDebug % "<<<<<<<<<<<<<<<<<<<[" A_ThisFunc "]>>>>>>>>>>>>>>>>>>>>>>>>>>"
        oldPos := this.obj.pos
		OutputDebug % "Initial Position: " oldPos.Dump()
		WinMove % "ahk_id" this.obj._hWnd, , oldPos.x, oldPos.y, oldPos.w, oldPos.h
		newPos := this.obj.pos
        OutputDebug % "AFTER - Moving from " oldPos.Dump() " to " newPos.Dump()
        Yunit.assert(newPos.x == oldPos.x)
		Yunit.assert(newPos.y == oldPos.y)
		Yunit.assert(newPos.w == oldPos.w)
		Yunit.assert(newPos.h == oldPos.h)		
	}		
	
	NoMoveResizeViaMoveMehod() {
		OutputDebug % "<<<<<<<<<<<<<<<<<<<[" A_ThisFunc "]>>>>>>>>>>>>>>>>>>>>>>>>>>"
        oldPos := this.obj.pos
		OutputDebug % "Initial Position: " oldPos.Dump()
		this.obj.move(oldPos.x, oldPos.y, oldPos.w, oldPos.h)
		newPos := this.obj.pos
        OutputDebug % "AFTER - Moving from " oldPos.Dump() " to " newPos.Dump()
        Yunit.assert(newPos.x == oldPos.x)
		Yunit.assert(newPos.y == oldPos.y)
		Yunit.assert(newPos.w == oldPos.w)
		Yunit.assert(newPos.h == oldPos.h)		
	}		

	End()
    {
		this.obj.kill()
        this.remove("obj")
		this.obj := 
    }
}

class HideShowTestSuite
{
    Begin()
    {
		Global debug
		this.obj := new WindowHandler(0, debug)
    }

	HideShowToggle() 
	{
		OutputDebug % "<<<<<<<<<<<<<<<<<<<[" A_ThisFunc "]>>>>>>>>>>>>>>>>>>>>>>>>>>"
		Yunit.assert(this.obj.hidden == false)
		this.obj.show()
		Yunit.assert(this.obj.hidden == false)
		this.obj.hide()
		Yunit.assert(this.obj.hidden == true)
		this.obj.hidden(false)
		Yunit.assert(this.obj.hidden == false)
		this.obj.hidden(true)
		Yunit.assert(this.obj.hidden == true)
		this.obj.hidden("toggle") ; as the window was hidden, it shouldn't be hidden now
		Yunit.assert(this.obj.hidden == false)
		this.obj.hidden("toggle") ; as the window wasn't hidden, it should be hidden now
		Yunit.assert(this.obj.hidden == true)
		OutputDebug % ">>>>>>>>>>>>>>>>>>>[" A_ThisFunc "]<<<<<<<<<<<<<<<<<<<<<<<<<<"
	}
        
    HiddenFalse() 
    {
		OutputDebug % "<<<<<<<<<<<<<<<<<<<[" A_ThisFunc "]>>>>>>>>>>>>>>>>>>>>>>>>>>"
        Yunit.assert(this.obj.hidden==false)
		OutputDebug % ">>>>>>>>>>>>>>>>>>>[" A_ThisFunc "]<<<<<<<<<<<<<<<<<<<<<<<<<<"
    }
        
    HiddenTrue() 
    {
		OutputDebug % "<<<<<<<<<<<<<<<<<<<[" A_ThisFunc "]>>>>>>>>>>>>>>>>>>>>>>>>>>"
        this.obj.hide()
        Yunit.assert(this.obj.hidden==true)
		OutputDebug % ">>>>>>>>>>>>>>>>>>>[" A_ThisFunc "]<<<<<<<<<<<<<<<<<<<<<<<<<<"
    }
        
    HiddenDoesNotExist() 
    {
		OutputDebug % "<<<<<<<<<<<<<<<<<<<[" A_ThisFunc "]>>>>>>>>>>>>>>>>>>>>>>>>>>"
        this.obj.kill()
        Yunit.assert(this.obj.hidden==-1)
		OutputDebug % ">>>>>>>>>>>>>>>>>>>[" A_ThisFunc "]<<<<<<<<<<<<<<<<<<<<<<<<<<"
    }
       
    End()
    {
		this.obj.kill()
        this.remove("obj")
		this.obj := 
    }
}

class NotRealWindowTestSuite {
	Test()
	{
		Global debug
		HDesktop := DllCall("User32.dll\GetDesktopWindow", "UPtr")
		this.obj := new WindowHandler(HDesktop, debug)
		Yunit.assert(this.obj==)
	}
}

class MiscTestSuite
{
	Begin()
    {
		Global debug
		; Create a Testwindow ...
		Run, notepad.exe
		WinWait, ahk_class Notepad, , 2
		WinMove, ahk_class Notepad,, 10, 10, 300, 300
		_hWnd := WinExist("ahk_class Notepad")
		this.obj := new WindowHandler(_hWnd, debug)
    }
        
    Version()
    {
		OutputDebug % "<<<<<<<<<<<<<<<<<<<[" A_ThisFunc "]>>>>>>>>>>>>>>>>>>>>>>>>>>"
		Global ReferenceVersion
        Yunit.assert(this.obj._version == ReferenceVersion)
		OutputDebug % ">>>>>>>>>>>>>>>>>>>[" A_ThisFunc "]<<<<<<<<<<<<<<<<<<<<<<<<<<"
    }
	

    Classname()
    {
		OutputDebug % "<<<<<<<<<<<<<<<<<<<[" A_ThisFunc "]>>>>>>>>>>>>>>>>>>>>>>>>>>"
        Yunit.assert(this.obj.classname =="Notepad")
		OutputDebug % ">>>>>>>>>>>>>>>>>>>[" A_ThisFunc "]<<<<<<<<<<<<<<<<<<<<<<<<<<"
    }
        
    Title()
    {
		OutputDebug % "<<<<<<<<<<<<<<<<<<<[" A_ThisFunc "]>>>>>>>>>>>>>>>>>>>>>>>>>>"
        Yunit.assert(this.obj.title =="Unbenannt - Editor")
		OutputDebug % ">>>>>>>>>>>>>>>>>>>[" A_ThisFunc "]<<<<<<<<<<<<<<<<<<<<<<<<<<"
    }
	
	AlwaysOnTop() {
		OutputDebug % "<<<<<<<<<<<<<<<<<<<[" A_ThisFunc "]>>>>>>>>>>>>>>>>>>>>>>>>>>"
		Yunit.assert(this.obj.alwaysontop == false)
		this.obj.alwaysOnTop := true
		Yunit.assert(this.obj.alwaysontop == true)
		this.obj.alwaysOnTop := false
		Yunit.assert(this.obj.alwaysontop == false)
		this.obj.alwaysOnTop := false
		Yunit.assert(this.obj.alwaysontop == false)
		this.obj.alwaysOnTop := !this.obj.alwaysOnTop
		Yunit.assert(this.obj.alwaysontop == true)
		this.obj.alwaysOnTop := !this.obj.alwaysOnTop
		Yunit.assert(this.obj.alwaysontop == false)
		OutputDebug % ">>>>>>>>>>>>>>>>>>>[" A_ThisFunc "]<<<<<<<<<<<<<<<<<<<<<<<<<<"
	}
	
	Center() {
		OutputDebug % "<<<<<<<<<<<<<<<<<<<[" A_ThisFunc "]>>>>>>>>>>>>>>>>>>>>>>>>>>"
		hwnd := this.obj._hwnd
		WinGetPos  x, y, w, h, ahk_id %hwnd%
		centerx := round(x+(w)/2)
		centery := round(y+(h)/2)
		center := this.obj.centercoords
		Yunit.assert(center.x == centerx)
		Yunit.assert(center.y == centery)
		Yunit.assert(center.w == 0)
		Yunit.assert(center.h == 0)
		OutputDebug % ">>>>>>>>>>>>>>>>>>>[" A_ThisFunc "]<<<<<<<<<<<<<<<<<<<<<<<<<<"
	}
    
	Getter() {
		OutputDebug % "<<<<<<<<<<<<<<<<<<<[" A_ThisFunc "]>>>>>>>>>>>>>>>>>>>>>>>>>>"
		hwnd := this.obj._hwnd
		WinGetPos  x, y, w, h, ahk_id %hwnd%
		Yunit.assert(1 == ((this.obj.pos.x == x) && (this.obj.pos.y == y) && (this.obj.pos.w == w) && (this.obj.pos.h == h)))
		OutputDebug % ">>>>>>>>>>>>>>>>>>>[" A_ThisFunc "]<<<<<<<<<<<<<<<<<<<<<<<<<<"
	}
	
    End()
    {
		this.obj.kill()
        this.remove("obj")
		this.obj := 
    }
	
}

class ExistTestSuite
{
    Begin()
    {
		Global debug
		this.obj := new WindowHandler(0, debug)
    }
        
    ExistNonExistingWindow() {
        this.obj.kill()
        Yunit.assert(this.obj.exist == false)
    }
        
    ExistExistingWindow() {
        OutputDebug % "<<<<<<<<<<<<<<<<<<<[" A_ThisFunc "]>>>>>>>>>>>>>>>>>>>>>>>>>>"
        Yunit.assert(this.obj.exist ==true)
        OutputDebug % ">>>>>>>>>>>>>>>>>>>[" A_ThisFunc "]<<<<<<<<<<<<<<<<<<<<<<<<<<"
    }
    
    End()
    {
		this.obj.kill()
        this.remove("obj")
		this.obj := 
    }
}



/*
class MiscTestSuite
{
	Begin()
    {
		Global debug
		this.obj := new WindowHandler(0, debug)
    }
        
	MonitorID() {
		this.obj.Move(2,2,300,300)
		monID := this.obj.monitorID
		Yunit.assert(monId == 1)
		obj := new MultiMonitorEnv(debug)
		rect2 := obj.monBoundary(2)
		this.obj.Move(rect2.x+10,rect2.y+10,300,300)
		monID := this.obj.monitorID()
		Yunit.assert(monId == 2)
	}

	IsResizeable() {
		val := this.obj.isResizable()
		Yunit.assert( val == 1)
		sleep, 500
	}
    
    End()
    {
		this.obj.kill()
        this.remove("obj")
		this.obj := 
    }
}

; ###################################################################
class MoveResizeTestSuite
{
    Begin()
    {
		Global debug
		this.obj := new WindowHandler(0, debug)
		sleep 1000
    }
    
    MoveViaWinMove()
    {
		OutputDebug % "<<<<<<<<<<<<<<<<<<<[" A_ThisFunc "]>>>>>>>>>>>>>>>>>>>>>>>>>>"
		OutputDebug % "Initial Position: " this.obj._lastPos.Dump() " - Restore: " this.obj._restorePos.Dump()
		hwnd := this.obj._hWnd
        xold := this.obj._lastPos.x
		yold := this.obj._lastPos.y
		xnew := xold+10
		ynew := yold+10
		
		OutputDebug % "BEFORE - Moving from x,y(" xold "," yold ") to (" xnew "," ynew ")"
		WinMove % "ahk_id" this.obj._hWnd, ,xnew, ynew
        OutputDebug % "AFTER - Moving from x,y(" xold "," yold ") to (" xnew "," ynew ")"
        Yunit.assert(this.obj.isMoved()==1)
        Yunit.assert(this.obj.isResized()==0)
        OutputDebug % ">>>>>>>>>>>>>>>>>>>[" A_ThisFunc "]<<<<<<<<<<<<<<<<<<<<<<<<<<"
    }
        
    MoveResizeViaWinMove()
    {
        OutputDebug % "<<<<<<<<<<<<<<<<<<<[" A_ThisFunc "]>>>>>>>>>>>>>>>>>>>>>>>>>>"
        OutputDebug % "Initial Position: " this.obj._lastPos.Dump() " - Restore: " this.obj._restorePos.Dump()
        hwnd := this.obj._hWnd
        xold := this.obj._lastPos.x
		yold := this.obj._lastPos.y
        wold := this.obj._lastPos.w
		hold := this.obj._lastPos.h
		xnew := xold+10
		ynew := yold+20
        wnew := wold+10
		hnew := hold+20
        OutputDebug % "BEFORE- Moving/Resizing from x,y,w,h(" xold "," yold "," wold "," hold ") to (" xnew "," ynew "," wnew "," hnew ")"
        WinMove % "ahk_id" this.obj._hWnd, , xnew, ynew, wnew, hnew
        OutputDebug % "AFTER - Moving/Resizing from x,y,w,h(" xold "," yold "," wold "," hold ") to (" xnew "," ynew "," wnew "," hnew ")"
        Yunit.assert(this.obj.isMoved()==1)
        Yunit.assert(this.obj.isResized()==1)
        OutputDebug % ">>>>>>>>>>>>>>>>>>>[" A_ThisFunc "]<<<<<<<<<<<<<<<<<<<<<<<<<<"
    }
        
    ResizeViaWinMove()
    {
        OutputDebug % "<<<<<<<<<<<<<<<<<<<[" A_ThisFunc "]>>>>>>>>>>>>>>>>>>>>>>>>>>"
        OutputDebug % "Initial Position: " this.obj._lastPos.Dump() " - Restore: " this.obj._restorePos.Dump()
        hwnd := this.obj._hWnd
        hwnd := this.obj._hWnd
        xold := this.obj._lastPos.x
		yold := this.obj._lastPos.y
        wold := this.obj._lastPos.w
		hold := this.obj._lastPos.h
        wnew := wold+10
		hnew := hold+20
        OutputDebug % "BEFORE- Resizing from w,h(" wold "," hold ") to (" wnew "," hnew ")"
        WinMove % "ahk_id" this.obj._hWnd, , xold, yold, wnew, hnew
        OutputDebug % "AFTER- Resizing from w,h(" wold "," hold ") to (" wnew "," hnew ")"
        Yunit.assert(this.obj.isMoved()==0)
        Yunit.assert(this.obj.isResized()==1)
        OutputDebug % ">>>>>>>>>>>>>>>>>>>[" A_ThisFunc "]<<<<<<<<<<<<<<<<<<<<<<<<<<"
    }
	
	NoMoveResize() {
		Global debug
		success := 1
		l := new WindowHandler(0, debug)
		WinMove % "ahk_id" l._hWnd, , l._lastPos.x, l._lastPos.y, l._lastPos.w, l._lastPos.h
		isMoved := l.isMoved()
		isResized := l.isResized()
		success := success && !(isMoved) && !(isResized)
		l.kill()
		if !success
			throw ""
	}		
    
	End()
    {
		sleep,2000
		this.obj.kill()
        this.remove("obj")
		this.obj := 
    }
}

*/

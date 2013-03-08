;#NoEnv

#Include %A_ScriptDir%\Yunit\Yunit.ahk
#Include %A_ScriptDir%\Yunit\Window.ahk
#Include %A_ScriptDir%\Yunit\StdOut.ahk
#include <Rectangle>
#include <WindowHandler>

#Warn All
#Warn LocalSameAsGlobal, Off
#SingleInstance force


ReferenceVersion := "0.1.0"
debug := 0

Yunit.Use(YunitStdOut, YunitWindow).Test(MiscTestSuite, HideShowTestSuite, ExistTestSuite)
Return

class HideShowTestSuite
{
    Begin()
    {
		Global debug
		this.obj := new WindowHandler(0, debug)
    }

	HideShowToggle() 
	{
		Yunit.assert(this.obj.hidden == false)
		this.obj.show()
		Yunit.assert(this.obj.hidden == false)
		this.obj.hide()
		Yunit.assert(this.obj.hidden == true)
		this.obj.hidden("off")
		Yunit.assert(this.obj.hidden == false)
		this.obj.hidden("on")
		Yunit.assert(this.obj.hidden == true)
		this.obj.hidden("toggle") ; as the window was hidden, it shouldn't be hidden now
		Yunit.assert(this.obj.hidden == false)
		this.obj.hidden("toggle") ; as the window wasn't hidden, it should be hidden now
		Yunit.assert(this.obj.hidden == true)
	}
        
    HiddenFalse() 
    {
        Yunit.assert(this.obj.hidden==false)
    }
        
    HiddenTrue() 
    {
        this.obj.hide()
        Yunit.assert(this.obj.hidden==true)
    }
        
    HiddenDoesNotExist() 
    {
        this.obj.kill()
        Yunit.assert(this.obj.hidden==-1)
    }
       
    End()
    {
		this.obj.kill()
        this.remove("obj")
		this.obj := 
    }
}

class MiscTestSuite
{
	Begin()
    {
		Global debug
		this.obj := new WindowHandler(0, debug)
    }
        
    Version()
    {
		Global ReferenceVersion
        Yunit.assert(this.obj._version == ReferenceVersion)
    }

    Classname()
    {
        Yunit.assert(this.obj.classname =="Notepad")
    }
        
    Title()
    {
        Yunit.assert(this.obj.title =="Unbenannt - Editor")
    }
	
	AlwaysOnTop() {
		Yunit.assert(this.obj.alwaysontop == false)
		this.obj.alwaysOnTop("on")
		Yunit.assert(this.obj.alwaysontop == true)
		this.obj.alwaysOnTop("off")
		Yunit.assert(this.obj.alwaysontop == false)
		this.obj.alwaysOnTop("off")
		Yunit.assert(this.obj.alwaysontop == false)
		this.obj.alwaysOnTop("toggle")
		Yunit.assert(this.obj.alwaysontop == true)
		this.obj.alwaysOnTop("toggle")
		Yunit.assert(this.obj.alwaysontop == false)
		this.obj.alwaysOnTop()
		Yunit.assert(this.obj.alwaysontop == true)
		this.obj.alwaysOnTop()
		Yunit.assert(this.obj.alwaysontop == false)
	}
	
	Center() {
		hwnd := this.obj._hwnd
		WinGetPos  x, y, w, h, ahk_id %hwnd%
		centerx := round(x+(w)/2)
		centery := round(y+(h)/2)
		center := this.obj.centercoords
		Yunit.assert(center.x == centerx)
		Yunit.assert(center.y == centery)
		Yunit.assert(center.w == 0)
		Yunit.assert(center.h == 0)
	}
    
	Getter() {
		hwnd := this.obj._hwnd
		WinGetPos  x, y, w, h, ahk_id %hwnd%
		Yunit.assert(1 == ((this.obj.pos.x == x) && (this.obj.pos.y == y) && (this.obj.pos.w == w) && (this.obj.pos.h == h)))
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
		monID := this.obj.monitorID()
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

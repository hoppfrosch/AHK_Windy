﻿;#NoEnv
#Warn

#Include %A_ScriptDir%\Yunit\Yunit.ahk
#Include %A_ScriptDir%\Yunit\Window.ahk
#Include %A_ScriptDir%\Yunit\StdOut.ahk
#include <Windy\Windy>
#include  %A_ScriptDir%\lib\\DbgOut.ahk

; #Warn All
;#Warn LocalSameAsGlobal, Off
#SingleInstance force

ReferenceVersion := "0.10.2"
debug := 1

OutputDebug DBGVIEWCLEAR

Yunit.Use(YunitStdOut, YunitWindow).Test(_BaseTestSuite, TransparencyTestSuite)
;Yunit.Use(YunitStdOut, YunitWindow).Test(_BaseTestSuite, MiscTestSuite, NotRealWindowTestSuite, HideShowTestSuite, ExistTestSuite, RollupTestSuite, MoveResizeTestSuite, TransparencyTestSuite)
Return


; ###################################################################
class TempTestSuite {
    Begin() {
		Global debug
		this.obj := new Windy(0, debug)
	}    

	activated() {
		Global debug

		dbgOut(">[" A_ThisFunc "]")
		this.obj.activated := true
		sleep 1000
		val := (this.obj.activated == true)
		Yunit.assert(val == true)
		this.obj.activated := false
		Yunit.assert(this.obj.activated == false)
		this.obj.activated := true
		newObj := new Windy(0, debug)
		Yunit.assert(this.obj.activated == false)
		dbgOut("<[" A_ThisFunc "]")
	}
		
	End() {
		this.obj.kill()
		this.remove("obj")
		this.obj := 
	}
}

class _BaseTestSuite {
    Begin() {
		Global debug
		this.obj := new Windy(0, debug)
	}
	
	Version() {
		dbgOut(">[" A_ThisFunc "]")
		Global ReferenceVersion
		Yunit.assert(this.obj._version == ReferenceVersion)
		dbgOut("<[" A_ThisFunc "]")
	}

	End() {
		this.obj.kill()
		this.remove("obj")
		this.obj := 
	}
}


; ###################################################################
class TileTestSuite {
	Begin() {
		Global debug
		this.obj := new Windy(0, debug)
	}
	
	movePercental() {
		Global debug

		dbgOut(">[" A_ThisFunc "]")
		this.obj.movePercental(25, 25, 50, 50)
		MsgBox % A_ThisFunc " - To be done ..."
		dbgOut("<[" A_ThisFunc "]")
	}
	
	End() {
		this.obj.kill()
		this.remove("obj")
		this.obj := 
	}
}

; ###################################################################
class TransparencyTestSuite {
	Begin() {
		Global debug
		this.obj := new Windy(0, debug)
	}
 
	Transparency() {
		dbgOut(">[" A_ThisFunc "]")
;		OutputDebug % "**** " A_ThisFunc " 1 ****"
;		t := this.obj.transparency
;		Yunit.assert(t == 255)
;		OutputDebug % "**** " A_ThisFunc " 3 ****"
;		this.obj.transparency(1,5) := 100
;		t := this.obj.transparency
;		Yunit.assert(t == 100)
;		OutputDebug % "**** " A_ThisFunc " 3 ****"
;		this.obj.transparency(1,5) := "OFF"
;		t := this.obj.transparency
;		Yunit.assert(t == 255)
		step := 20
		delay := 3
		this.obj.transparency(step,delay) := 100
		this.obj.transparency(step,delay) := "OFF"
		this.obj.transparency(step,delay) := 100
		this.obj.transparency(step,delay) := "OFF"

    dbgOut("<[" A_ThisFunc "]")
	}

	
	End() {
		this.obj.kill()
		this.remove("obj")
		this.obj := 
	}
}

; ###################################################################
class RollupTestSuite {
	Begin() {
		Global debug
		this.obj := new Windy(0, debug)
	}
	
	RollupToggle() {
		Global debug

		OutputDebug % ">>>>>[" A_ThisFunc "]>>>>>"
		OutputDebug % "**** " A_ThisFunc " 1 ****"
		val := this.obj.rolledUp
		Yunit.assert(val == false)
		
		OutputDebug % "**** " A_ThisFunc " 2 ****"
		this.obj.rolledUp := false
		val := this.obj.rolledUp
		Yunit.assert(val == false)
		
		OutputDebug % "**** " A_ThisFunc " 3 ****"
		this.obj.rolledUp := true
		val := this.obj.rolledUp
		Yunit.assert(val == true)
		
		OutputDebug % "**** " A_ThisFunc " 4 ****"
		this.obj.rolledUp := false
		val := this.obj.rolledUp
		Yunit.assert(val == false)
		
		OutputDebug % "**** " A_ThisFunc " 5 ****"
		this.obj.rolledUp := !this.obj.rolledUp ; as the window wasn't rolled up, it should be rolled up now
		val := this.obj.rolledUp
		Yunit.assert(val == true)
		
		OutputDebug % "**** " A_ThisFunc " 6 ****"
		this.obj.rolledUp := !this.obj.rolledUp ; as the window was rolled up, it shouldn't be rolled up now
		val := this.obj.rolledUp
		Yunit.assert(val == false)

		OutputDebug % "**** " A_ThisFunc " 7 ****"
		this.End()
		val := this.obj.rolledUp
		Yunit.assert(val == )
		OutputDebug % "<<<<[" A_ThisFunc "]<<<<<"
	}
	
	End() {
		this.obj.kill()
		this.remove("obj")
		this.obj := 
	}
}

; ###################################################################
class MoveResizeTestSuite {
	Begin() {
		Global debug
		this.obj := new Windy(0, debug)
	}
 
	Maximize() {
		OutputDebug % ">>>>>[" A_ThisFunc "]>>>>>"
		Yunit.assert(this.obj.maximized == false)
		Yunit.assert(this.obj.minimized == false)
		this.obj.maximized := true
		Yunit.assert(this.obj.maximized == true)
		Yunit.assert(this.obj.minimized == false)
		this.obj.maximized := false
		Yunit.assert(this.obj.maximized == false)
		Yunit.assert(this.obj.minimized == false)
		this.obj.maximized := !this.obj.maximized
		Yunit.assert(this.obj.maximized == true)
		Yunit.assert(this.obj.minimized == false)
		this.obj.maximized := !this.obj.maximized
		Yunit.assert(this.obj.maximized == false)
		Yunit.assert(this.obj.minimized == false)
		OutputDebug % "<<<<[" A_ThisFunc "]<<<<<"
		
	}
	
	Minimize() {
		OutputDebug % ">>>>>[" A_ThisFunc "]>>>>>"
		Yunit.assert(this.obj.maximized == false)
		Yunit.assert(this.obj.minimized == false)
		this.obj.minimized := true
		Yunit.assert(this.obj.maximized == false)
		Yunit.assert(this.obj.minimized == true)
		this.obj.minimized := false
		Yunit.assert(this.obj.maximized == false)
		Yunit.assert(this.obj.minimized == false)
		this.obj.minimized := !this.obj.minimized
		Yunit.assert(this.obj.maximized == false)
		Yunit.assert(this.obj.minimized == true)
		this.obj.minimized := !this.obj.minimized
		Yunit.assert(this.obj.maximized == false)
		Yunit.assert(this.obj.minimized == false)
		OutputDebug % "<<<<[" A_ThisFunc "]<<<<<"
		
	}
	
	MoveViaWinMove()  {
		OutputDebug % ">>>>>[" A_ThisFunc "]>>>>>"
		oldPos := this.obj.posSize
		OutputDebug % "Initial Position: " oldPos.Dump()
		
		xnew := oldPos.x+200
		ynew := oldPos.y+200
		
		OutputDebug % "BEFORE - Moving from " oldPos.Dump() " to (" xnew "," ynew "," oldPos.w "," oldPos.h ")"
		WinMove % "ahk_id" this.obj.hwnd, ,xnew, ynew
		newPos := this.obj.posSize
		OutputDebug % "AFTER - Moving from " oldPos.Dump() " to " newPos.Dump()
		Yunit.assert(newPos.x == xnew)
		Yunit.assert(newPos.y == ynew)
		Yunit.assert(newPos.w == oldPos.w)
		Yunit.assert(newPos.h == oldPos.h)
		OutputDebug % "<<<<[" A_ThisFunc "]<<<<<"
	}
	
	MoveViaMoveMethod() {
		OutputDebug % ">>>>>[" A_ThisFunc "]>>>>>"
		oldPos := this.obj.posSize
		OutputDebug % "Initial Position: " oldPos.Dump()
		
		xnew := oldPos.x+200
		ynew := oldPos.y+200
		
		OutputDebug % "BEFORE - Moving from " oldPos.Dump() " to (" xnew "," ynew "," oldPos.w "," oldPos.h ")"
		this.obj.move(xnew, ynew, oldPos.w, oldPos.h)
		newPos := this.obj.posSize
		OutputDebug % "AFTER - Moving from " oldPos.Dump() " to " newPos.Dump()
		Yunit.assert(newPos.x == xnew)
		Yunit.assert(newPos.y == ynew)
		Yunit.assert(newPos.w == oldPos.w)
		Yunit.assert(newPos.h == oldPos.h)
		OutputDebug % "<<<<[" A_ThisFunc "]<<<<<"
	}
	
	MoveViaPosSizeProperty() {
		OutputDebug % ">>>>>[" A_ThisFunc "]>>>>>"
		oldPos := this.obj.posSize
		OutputDebug % "Initial Position: " oldPos.Dump()
		
		xnew := oldPos.x+200
		ynew := oldPos.y+200
		
		OutputDebug % "BEFORE - Moving from " oldPos.Dump() " to (" xnew "," ynew "," oldPos.w "," oldPos.h ")"
		this.obj.posSize := new Recty(xnew,ynew,oldPos.w,oldPos.h)
		newPos := this.obj.posSize
		OutputDebug % "AFTER - Moving from " oldPos.Dump() " to " newPos.Dump()
		Yunit.assert(newPos.x == xnew)
		Yunit.assert(newPos.y == ynew)
		Yunit.assert(newPos.w == oldPos.w)
		Yunit.assert(newPos.h == oldPos.h)
		OutputDebug % "<<<<[" A_ThisFunc "]<<<<<"
	}

	MoveViaPosProperty() {
		OutputDebug % ">>>>>[" A_ThisFunc "]>>>>>"
		oldPos := this.obj.pos
		OutputDebug % "Initial Position: " oldPos.Dump()
		
		xnew := oldPos.x+200
		ynew := oldPos.y+200
		
		OutputDebug % "BEFORE - Moving from " oldPos.Dump() " to (" xnew "," ynew  ")"
		this.obj.pos := new Pointy(xnew,ynew)
		newPos := this.obj.pos
		OutputDebug % "AFTER - Moving from " oldPos.Dump() " to " newPos.Dump()
		Yunit.assert(newPos.x == xnew)
		Yunit.assert(newPos.y == ynew)
		OutputDebug % "<<<<[" A_ThisFunc "]<<<<<"
	}
	
	MoveResizeViaWinMove() {
		OutputDebug % ">>>>>[" A_ThisFunc "]>>>>>"
		oldPos := this.obj.posSize
		OutputDebug % "Initial Position: " oldPos.Dump()
        
		xnew := oldPos.x+10
		ynew := oldPos.y+20
		wnew := oldPos.w+10
		hnew := oldPos.h+20
		OutputDebug % "BEFORE - Moving from " oldPos.Dump() " to (" xnew "," ynew "," wnew "," hnew ")"
		WinMove % "ahk_id" this.obj.hwnd, , xnew, ynew, wnew, hnew
		newPos := this.obj.posSize
		OutputDebug % "AFTER - Moving from " oldPos.Dump() " to " newPos.Dump()
		Yunit.assert(newPos.x == xnew)
		Yunit.assert(newPos.y == ynew)
		Yunit.assert(newPos.w == wnew)
		Yunit.assert(newPos.h == hnew)
		
		OutputDebug % "<<<<[" A_ThisFunc "]<<<<<"
	}

	MoveResizeViaMoveMehod() {
		OutputDebug % ">>>>>[" A_ThisFunc "]>>>>>"
		oldPos := this.obj.posSize
		OutputDebug % "Initial Position: " oldPos.Dump()
        
		xnew := oldPos.x+10
		ynew := oldPos.y+20
		wnew := oldPos.w+10
		hnew := oldPos.h+20
		OutputDebug % "BEFORE - Moving from " oldPos.Dump() " to (" xnew "," ynew "," wnew "," hnew ")"
		this.obj.move(xnew, ynew, wnew, hnew)
		newPos := this.obj.posSize
		OutputDebug % "AFTER - Moving from " oldPos.Dump() " to " newPos.Dump()
		Yunit.assert(newPos.x == xnew)
		Yunit.assert(newPos.y == ynew)
		Yunit.assert(newPos.w == wnew)
		Yunit.assert(newPos.h == hnew)
		
		OutputDebug % "<<<<[" A_ThisFunc "]<<<<<"
	}
	
	MoveResizeViaPosSizeProperty() {
		OutputDebug % ">>>>>[" A_ThisFunc "]>>>>>"
		oldPos := this.obj.posSize
		OutputDebug % "Initial Position: " oldPos.Dump()
        
		xnew := oldPos.x+10
		ynew := oldPos.y+20
		wnew := oldPos.w+10
		hnew := oldPos.h+20
		OutputDebug % "BEFORE - Moving from " oldPos.Dump() " to (" xnew "," ynew "," wnew "," hnew ")"
		this.obj.posSize := new Recty(xnew, ynew, wnew, hnew)
		newPos := this.obj.posSize
		OutputDebug % "AFTER - Moving from " oldPos.Dump() " to " newPos.Dump()
		Yunit.assert(newPos.x == xnew)
		Yunit.assert(newPos.y == ynew)
		Yunit.assert(newPos.w == wnew)
		Yunit.assert(newPos.h == hnew)
		
		OutputDebug % "<<<<[" A_ThisFunc "]<<<<<"
	}
	
	ResizeViaWinMove() {
		OutputDebug % ">>>>>[" A_ThisFunc "]>>>>>"
		oldPos := this.obj.posSize
		OutputDebug % "Initial Position: " oldPos.Dump()
        
		wnew := oldPos.w+100
		hnew := oldPos.h+200
		
		OutputDebug % "BEFORE - Moving from " oldPos.Dump() " to (" oldPos.x "," oldPos.y "," wnew "," hnew ")"
		WinMove % "ahk_id" this.obj.hwnd, , oldPos.x, oldPos.y, wnew, hnew
		newPos := this.obj.posSize
		OutputDebug % "AFTER - Moving from " oldPos.Dump() " to " newPos.Dump()
		Yunit.assert(newPos.x == oldPos.x)
		Yunit.assert(newPos.y == oldPos.y)
		Yunit.assert(newPos.w == wnew)
		Yunit.assert(newPos.h == hnew)
		
		OutputDebug % "<<<<[" A_ThisFunc "]<<<<<"
	}
	
	ResizeViaMoveMethod() {
		OutputDebug % ">>>>>[" A_ThisFunc "]>>>>>"
		oldPos := this.obj.posSize
		OutputDebug % "Initial Position: " oldPos.Dump()
        
		wnew := oldPos.w+100
		hnew := oldPos.h+200
		
		OutputDebug % "BEFORE - Moving from " oldPos.Dump() " to (" oldPos.x "," oldPos.y "," wnew "," hnew ")"
		this.obj.move(oldPos.x, oldPos.y, wnew, hnew)
		newPos := this.obj.posSize
		OutputDebug % "AFTER - Moving from " oldPos.Dump() " to " newPos.Dump()
		Yunit.assert(newPos.x == oldPos.x)
		Yunit.assert(newPos.y == oldPos.y)
		Yunit.assert(newPos.w == wnew)
		Yunit.assert(newPos.h == hnew)
		
		OutputDebug % "<<<<[" A_ThisFunc "]<<<<<"
	}
	
	ResizeViaPosSizeProperty() {
		OutputDebug % ">>>>>[" A_ThisFunc "]>>>>>"
		oldPos := this.obj.posSize
		OutputDebug % "Initial Position: " oldPos.Dump()
        
		wnew := oldPos.w+100
		hnew := oldPos.h+200
		
		OutputDebug % "BEFORE - Moving from " oldPos.Dump() " to (" oldPos.x "," oldPos.y "," wnew "," hnew ")"
		this.obj.posSize := new Recty(oldPos.x, oldPos.y, wnew, hnew)
		newPos := this.obj.posSize
		OutputDebug % "AFTER - Moving from " oldPos.Dump() " to " newPos.Dump()
		Yunit.assert(newPos.x == oldPos.x)
		Yunit.assert(newPos.y == oldPos.y)
		Yunit.assert(newPos.w == wnew)
		Yunit.assert(newPos.h == hnew)	
		OutputDebug % "<<<<[" A_ThisFunc "]<<<<<"
	}

	ResizeViaSizeProperty() {
		OutputDebug % ">>>>>[" A_ThisFunc "]>>>>>"
		oldSize:= this.obj.size
		OutputDebug % "Initial Size: " oldSize.Dump()
        
		wnew := oldSize.x+100
		hnew := oldSize.y+200
		
		OutputDebug % "BEFORE - Resizing from " oldSize.Dump() " to (" wnew "," hnew ")"
		this.obj.size := new Pointy(wnew, hnew)
		newSize := this.obj.size
		OutputDebug % "AFTER - Resizing from " oldSize.Dump() " to " newSize.Dump()
		Yunit.assert(newSize.x == wnew)
		Yunit.assert(newSize.y == hnew)	
		OutputDebug % "<<<<[" A_ThisFunc "]<<<<<"
	}

	NoMoveResizeViaWinMove() {
		OutputDebug % ">>>>>[" A_ThisFunc "]>>>>>"
        oldPos := this.obj.posSize
		OutputDebug % "Initial Position: " oldPos.Dump()
		WinMove % "ahk_id" this.obj.hwnd, , oldPos.x, oldPos.y, oldPos.w, oldPos.h
		newPos := this.obj.posSize
        OutputDebug % "AFTER - Moving from " oldPos.Dump() " to " newPos.Dump()
        Yunit.assert(newPos.x == oldPos.x)
		Yunit.assert(newPos.y == oldPos.y)
		Yunit.assert(newPos.w == oldPos.w)
		Yunit.assert(newPos.h == oldPos.h)		
		OutputDebug % "<<<<[" A_ThisFunc "]<<<<<"
	}		
	
	NoMoveResizeViaMoveMehod() {
		OutputDebug % ">>>>>[" A_ThisFunc "]>>>>>"
		oldPos := this.obj.posSize
		OutputDebug % "Initial Position: " oldPos.Dump()
		this.obj.move(oldPos.x, oldPos.y, oldPos.w, oldPos.h)
		newPos := this.obj.posSize
		OutputDebug % "AFTER - Moving from " oldPos.Dump() " to " newPos.Dump()
		Yunit.assert(newPos.x == oldPos.x)
		Yunit.assert(newPos.y == oldPos.y)
		Yunit.assert(newPos.w == oldPos.w)
		Yunit.assert(newPos.h == oldPos.h)		
		OutputDebug % "<<<<[" A_ThisFunc "]<<<<<"
	}		

	NoMoveResizeViaPosSizeProperty() {
		OutputDebug % ">>>>>[" A_ThisFunc "]>>>>>"
		oldPos := this.obj.posSize
		OutputDebug % "Initial Position: " oldPos.Dump()
		this.obj.posSize := new Recty(oldPos.x, oldPos.y, oldPos.w, oldPos.h)
		newPos := this.obj.posSize
		OutputDebug % "AFTER - Moving from " oldPos.Dump() " to " newPos.Dump()
		Yunit.assert(newPos.x == oldPos.x)
		Yunit.assert(newPos.y == oldPos.y)
		Yunit.assert(newPos.w == oldPos.w)
		Yunit.assert(newPos.h == oldPos.h)		
		OutputDebug % "<<<<[" A_ThisFunc "]<<<<<"
	}

	NoMoveViaPosProperty() {
		OutputDebug % ">>>>>[" A_ThisFunc "]>>>>>"
		oldPos := this.obj.pos
		OutputDebug % "Initial Position: " oldPos.Dump()
		this.obj.pos := new Pointy(oldPos.x, oldPos.y)
		newPos := this.obj.pos
		OutputDebug % "AFTER - Moving from " oldPos.Dump() " to " newPos.Dump()
		Yunit.assert(newPos.x == oldPos.x)
		Yunit.assert(newPos.y == oldPos.y)
		OutputDebug % "<<<<[" A_ThisFunc "]<<<<<"
	}

	NoResizeViaSizeProperty() {
		OutputDebug % ">>>>>[" A_ThisFunc "]>>>>>"
		oldSize := this.obj.size
		OutputDebug % "Initial Size: " oldSize.Dump()
		this.obj.size := new Pointy(oldSize.x, oldSize.y)
		newSize := this.obj.size
		OutputDebug % "AFTER - Resizing from " oldSize.Dump() " to " newSize.Dump()
		Yunit.assert(newSize.x == oldSize.x)
		Yunit.assert(newSize.y == oldSize.y)	
		OutputDebug % "<<<<[" A_ThisFunc "]<<<<<"	
	}
	
	scale() {
		OutputDebug % ">>>>>[" A_ThisFunc "]>>>>>"
		this.obj.maximized := true
		this.obj.scale(2)
		OutputDebug % "<<<<[" A_ThisFunc "]<<<<<"
	}
	
	End() {
		this.obj.kill()
        this.remove("obj")
		this.obj := 
	}
}

; ###################################################################
class HideShowTestSuite {
	Begin() {
		Global debug
		this.obj := new Windy(0, debug)
	}

	HideShowToggle() {
		OutputDebug % ">>>>>[" A_ThisFunc "]>>>>>"
		Yunit.assert(this.obj.hidden == false)
		this.obj.hidden := false
		Yunit.assert(this.obj.hidden == false)
		this.obj.hidden := true
		Yunit.assert(this.obj.hidden == true)
		this.obj.hidden := false
		Yunit.assert(this.obj.hidden == false)
		this.obj.hidden := true
		Yunit.assert(this.obj.hidden == true)
		this.obj.hidden := !this.obj.hidden ; as the window was hidden, it shouldn't be hidden now
		Yunit.assert(this.obj.hidden == false)
		this.obj.hidden := !this.obj.hidden  ; as the window wasn't hidden, it should be hidden now
		Yunit.assert(this.obj.hidden == true)
		OutputDebug % "<<<<[" A_ThisFunc "]<<<<<"
	}
        
	HiddenFalse() {
		OutputDebug % ">>>>>[" A_ThisFunc "]>>>>>"
        Yunit.assert(this.obj.hidden==false)
		OutputDebug % "<<<<[" A_ThisFunc "]<<<<<"
	}
      
	HiddenTrue() {
		OutputDebug % ">>>>>[" A_ThisFunc "]>>>>>"
        this.obj.hidden := true
        Yunit.assert(this.obj.hidden == true)
		OutputDebug % "<<<<[" A_ThisFunc "]<<<<<"
	}

	HiddenDoesNotExist() {
		OutputDebug % ">>>>>[" A_ThisFunc "]>>>>>"
        this.obj.kill()
        Yunit.assert(this.obj.hidden==-1)
		OutputDebug % "<<<<[" A_ThisFunc "]<<<<<"
	}
     
	End() {
		this.obj.kill()
        this.remove("obj")
		this.obj := 
	}
}

; ###################################################################
class NotRealWindowTestSuite {
	Test() {
		OutputDebug % ">>>>>[" A_ThisFunc "]>>>>>"
		Global debug
		HDesktop := DllCall("User32.dll\GetDesktopWindow", "UPtr")
		this.obj := new Windy(HDesktop, debug)
		Yunit.assert(this.obj==)
		OutputDebug % "<<<<[" A_ThisFunc "]<<<<<"
	}
}

; ###################################################################
class MiscTestSuite {
	Begin() {
		Global debug
		; Create a Testwindow ...
		Run, notepad.exe
		WinWait, ahk_class Notepad, , 2
		WinMove, ahk_class Notepad,, 10, 10, 300, 300
		_hWnd := WinExist("ahk_class Notepad")
		this.obj := new Windy(_hWnd, debug)
	}

	activated() {
		Global debug

		OutputDebug % ">>>>>[" A_ThisFunc "]>>>>>"
		this.obj.activated := true
		sleep 1000
		val := (this.obj.activated == true)
		Yunit.assert(val == true)
		this.obj.activated := false
		Yunit.assert(this.obj.activated == false)
		this.obj.activated := true
		newObj := new Windy(0, debug)
		Yunit.assert(this.obj.activated == false)
		OutputDebug % "<<<<[" A_ThisFunc "]<<<<<"
	}

	Caption() {
		OutputDebug % ">>>>>[" A_ThisFunc "]>>>>>"
		OutputDebug % "....[" A_ThisFunc "] > 1"
		Yunit.assert(this.obj.caption == 1)
		OutputDebug % "....[" A_ThisFunc "] > 0"
		this.obj.caption := 0
		Yunit.assert(this.obj.caption == 0)
		OutputDebug % "....[" A_ThisFunc "] > 1"
		this.obj.caption := 1
		Yunit.assert(this.obj.caption == 1)
		OutputDebug % "<<<<<[" A_ThisFunc "]<<<<<"
	}
	
	Center() {
		Global debug
		
		OutputDebug % ">>>>>[" A_ThisFunc "]>>>>>"
		hwnd := this.obj.hwnd
		WinGetPos  x, y, w, h, ahk_id %hwnd%
		centerx := round(x+(w)/2)
		centery := round(y+(h)/2)
		OutputDebug % "**** " A_ThisFunc " 1 ****"
		center := this.obj.centercoords
		Yunit.assert(center.x == centerx)
		Yunit.assert(center.y == centery)
		
		OutputDebug % "**** " A_ThisFunc " 2 ****"
		newCenter := new Pointy(205,205,debug)
		this.obj.centercoords := newCenter
		center := this.obj.centercoords
		Yunit.assert(center.x == 205)
		Yunit.assert(center.y == 205)
		OutputDebug % "<<<<[" A_ThisFunc "]<<<<<"
	}
	
	Classname() {
		OutputDebug % ">>>>>[" A_ThisFunc "]>>>>>"
        Yunit.assert(this.obj.classname =="Notepad")
		OutputDebug % "<<<<[" A_ThisFunc "]<<<<<"
	}

    hscrollable() {
		OutputDebug % ">>>>>[" A_ThisFunc "]>>>>>"
		OutputDebug % "....[" A_ThisFunc "] > Initial"
		Yunit.assert(this.obj.hscrollable == 0)
		OutputDebug % "....[" A_ThisFunc "] > 1"
		this.obj.hscrollable := 1
		Yunit.assert(this.obj.hscrollable == 1)
		OutputDebug % "....[" A_ThisFunc "] > 0"
		this.obj.hscrollable := 0
		Yunit.assert(this.obj.hscrollable == 0)
		OutputDebug % "....[" A_ThisFunc "] > 1"
		this.obj.hscrollable := !this.obj.hscrollable
		Yunit.assert(this.obj.hscrollable == 1)
		OutputDebug % "<<<<<[" A_ThisFunc "]<<<<<"
	}
	
	maximizebox() {
		OutputDebug % ">>>>>[" A_ThisFunc "]>>>>>"
		OutputDebug % "....[" A_ThisFunc "] > Initial"
		Yunit.assert(this.obj.maximizebox == 1)
		OutputDebug % "....[" A_ThisFunc "] > 0"
		this.obj.maximizebox := 0
		Yunit.assert(this.obj.maximizebox == 0)
		OutputDebug % "....[" A_ThisFunc "] > 1"
		this.obj.maximizebox := !this.obj.maximizebox
		Yunit.assert(this.obj.caption == 1)
		OutputDebug % "<<<<<[" A_ThisFunc "]<<<<<"
	}

	minimizebox() {
		OutputDebug % ">>>>>[" A_ThisFunc "]>>>>>"
		OutputDebug % "....[" A_ThisFunc "] > Initial"
		Yunit.assert(this.obj.minimizebox == 1)
		OutputDebug % "....[" A_ThisFunc "] > 0"
		this.obj.minimizebox := 0
		Yunit.assert(this.obj.minimizebox == 0)
		OutputDebug % "....[" A_ThisFunc "] > 1"
		this.obj.minimizebox := !this.obj.minimizebox
		Yunit.assert(this.obj.caption == 1)
		OutputDebug % "<<<<<[" A_ThisFunc "]<<<<<"
	}
	
	Title() {
		OutputDebug % ">>>>>[" A_ThisFunc "]>>>>>"
		Yunit.assert(this.obj.title =="Unbenannt - Editor")
		this.obj.title := "Halllloo"
		Yunit.assert(this.obj.title =="Halllloo")
		OutputDebug % "<<<<[" A_ThisFunc "]<<<<<"
	}

	Parent() {
		OutputDebug % ">>>>>[" A_ThisFunc "]>>>>>"
		parent := this.parent
		Yunit.assert(parent == )	
		OutputDebug % "<<<<[" A_ThisFunc "]<<<<<"
	}
	
	Processname() {
		OutputDebug % ">>>>>[" A_ThisFunc "]>>>>>"
		val := this.obj.processname
		Yunit.assert( val == "notepad.exe")
		OutputDebug % "<<<<[" A_ThisFunc "]<<<<<"
	}

	ProcessID() {
			OutputDebug % ">>>>>[" A_ThisFunc "]>>>>>"
		val := this.obj.processID
		Yunit.assert( val > 0)
		OutputDebug % "<<<<[" A_ThisFunc "]<<<<<"
	}

	Resizable() {
		OutputDebug % ">>>>>[" A_ThisFunc "]>>>>>"
		OutputDebug % "...[" A_ThisFunc "]> 1"
		Yunit.assert( this.obj.resizable == 1)
		OutputDebug % "...[" A_ThisFunc "]> 0"
		this.obj.resizable := 0
		Yunit.assert( this.obj.resizable == 0)
		OutputDebug % "...[" A_ThisFunc "]> toggle"
		this.obj.resizable := !this.obj.resizable
		Yunit.assert( this.obj.resizable == 1)
		OutputDebug % "<<<<[" A_ThisFunc "]<<<<<"
		sleep, 500
	}

	vscrollable() {
		OutputDebug % ">>>>>[" A_ThisFunc "]>>>>>"
		OutputDebug % "....[" A_ThisFunc "] > Initial"
		Yunit.assert(this.obj.vscrollable == 0)
		OutputDebug % "....[" A_ThisFunc "] > 1"
		this.obj.vscrollable := 1
		Yunit.assert(this.obj.vscrollable == 1)
		OutputDebug % "....[" A_ThisFunc "] > 0"
		this.obj.vscrollable := 0
		Yunit.assert(this.obj.vscrollable == 0)
		OutputDebug % "....[" A_ThisFunc "] > 1"
		this.obj.vscrollable := !this.obj.vscrollable
		Yunit.assert(this.obj.vscrollable == 1)
		OutputDebug % "<<<<<[" A_ThisFunc "]<<<<<"
	}
	
	AlwaysOnTop() {
		OutputDebug % ">>>>>[" A_ThisFunc "]>>>>>"
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
		OutputDebug % "<<<<[" A_ThisFunc "]<<<<<"
	}
	
	MonitorID() {
		Global debug
		OutputDebug % ">>>>>[" A_ThisFunc "]>>>>>"
		OutputDebug % "**** " A_ThisFunc " 1 ****"
		this.obj.Move(2,2,300,300)
		monID := this.obj.monitorID
		Yunit.assert(monId == 1)
		OutputDebug % "**** " A_ThisFunc " 2 - via Move ****"
		obj := new Mony(2, debug)
		rect2 := obj.boundary
		this.obj.Move(rect2.x+10,rect2.y+10,300,300)
		monID := this.obj.monitorID
		Yunit.assert(monId == 2)
		OutputDebug % "**** " A_ThisFunc " 3 - via MonitorID ****"
		this.obj.monitorID := 1
		monID := this.obj.monitorID
		Yunit.assert(monId == 1)
		OutputDebug % "<<<<[" A_ThisFunc "]<<<<<"
	}
	
	Hangs() {
		OutputDebug % ">>>>>[" A_ThisFunc "]>>>>>"
		val := this.obj.hangs
		Yunit.assert(val == false)
		OutputDebug % "<<<<[" A_ThisFunc "]<<<<<"
		
	}
    
	Getter() {
		OutputDebug % ">>>>>[" A_ThisFunc "]>>>>>"
		hwnd := this.obj.hwnd
		WinGetPos  x, y, w, h, ahk_id %hwnd%
		Yunit.assert(1 == ((this.obj.posSize.x == x) && (this.obj.posSize.y == y) && (this.obj.posSize.w == w) && (this.obj.posSize.h == h)))
		OutputDebug % "<<<<[" A_ThisFunc "]<<<<<"
	}

	owner() {
		OutputDebug % ">>>>>[" A_ThisFunc "]>>>>>"
		own:= this.obj.owner
		Yunit.assert(own == 0)
		OutputDebug % "<<<<[" A_ThisFunc "]<<<<<"
	}	 
	
	End() {
		this.obj.kill()
        this.remove("obj")
		this.obj := 
	}
	
}

; ###################################################################
class ExistTestSuite {
	Begin() {
		Global debug
		this.obj := new Windy(0, debug)
	}
        
	ExistNonExistingWindow() {
        this.obj.kill()
        Yunit.assert(this.obj.exist == false)
	}
        
	ExistExistingWindow() {
        OutputDebug % ">>>>>[" A_ThisFunc "]>>>>>"
        Yunit.assert(this.obj.exist ==true)
        OutputDebug % "<<<<[" A_ThisFunc "]<<<<<"
	}
    
	End() {
		this.obj.kill()
        this.remove("obj")
		this.obj := 
	}
}


/*
; ###################################################################
class MoveResizeTestSuite
{
    Begin()
    {
		Global debug
		this.obj := new Windy(0, debug)
		sleep 1000
    }
    
    MoveViaWinMove()
    {
		OutputDebug % ">>>>>[" A_ThisFunc "]>>>>>"
		OutputDebug % "Initial Position: " this.obj._lastPos.Dump() " - Restore: " this.obj._restorePos.Dump()
		hwnd := this.obj.hwnd
        xold := this.obj._lastPos.x
		yold := this.obj._lastPos.y
		xnew := xold+10
		ynew := yold+10
		
		OutputDebug % "BEFORE - Moving from x,y(" xold "," yold ") to (" xnew "," ynew ")"
		WinMove % "ahk_id" this.obj.hwnd, ,xnew, ynew
        OutputDebug % "AFTER - Moving from x,y(" xold "," yold ") to (" xnew "," ynew ")"
        Yunit.assert(this.obj.isMoved()==1)
        Yunit.assert(this.obj.isResized()==0)
        OutputDebug % "<<<<[" A_ThisFunc "]<<<<<"
    }
        
    MoveResizeViaWinMove()
    {
        OutputDebug % ">>>>>[" A_ThisFunc "]>>>>>"
        OutputDebug % "Initial Position: " this.obj._lastPos.Dump() " - Restore: " this.obj._restorePos.Dump()
        hwnd := this.obj.hwnd
        xold := this.obj._lastPos.x
		yold := this.obj._lastPos.y
        wold := this.obj._lastPos.w
		hold := this.obj._lastPos.h
		xnew := xold+10
		ynew := yold+20
        wnew := wold+10
		hnew := hold+20
        OutputDebug % "BEFORE- Moving/Resizing from x,y,w,h(" xold "," yold "," wold "," hold ") to (" xnew "," ynew "," wnew "," hnew ")"
        WinMove % "ahk_id" this.obj.hwnd, , xnew, ynew, wnew, hnew
        OutputDebug % "AFTER - Moving/Resizing from x,y,w,h(" xold "," yold "," wold "," hold ") to (" xnew "," ynew "," wnew "," hnew ")"
        Yunit.assert(this.obj.isMoved()==1)
        Yunit.assert(this.obj.isResized()==1)
        OutputDebug % "<<<<[" A_ThisFunc "]<<<<<"
    }
        
    ResizeViaWinMove()
    {
        OutputDebug % ">>>>>[" A_ThisFunc "]>>>>>"
        OutputDebug % "Initial Position: " this.obj._lastPos.Dump() " - Restore: " this.obj._restorePos.Dump()
        hwnd := this.obj.hwnd
        hwnd := this.obj.hwnd
        xold := this.obj._lastPos.x
		yold := this.obj._lastPos.y
        wold := this.obj._lastPos.w
		hold := this.obj._lastPos.h
        wnew := wold+10
		hnew := hold+20
        OutputDebug % "BEFORE- Resizing from w,h(" wold "," hold ") to (" wnew "," hnew ")"
        WinMove % "ahk_id" this.obj.hwnd, , xold, yold, wnew, hnew
        OutputDebug % "AFTER- Resizing from w,h(" wold "," hold ") to (" wnew "," hnew ")"
        Yunit.assert(this.obj.isMoved()==0)
        Yunit.assert(this.obj.isResized()==1)
        OutputDebug % "<<<<[" A_ThisFunc "]<<<<<"
    }
	
	NoMoveResize() {
		Global debug
		success := 1
		l := new Windy(0, debug)
		WinMove % "ahk_id" l._hWnd, , l._lastPos.x, l._lastPos.y, l._lastPos.w, l._lastPos.h
		isMoved := l.isMoved()
		isResized := l.isResized()
		success := success && !(isMoved) && !(isResized)
		l.kill()
		if !success
			throw "
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
;#NoEnv
#Warn

#Include %A_ScriptDir%\Yunit\Yunit.ahk
#Include %A_ScriptDir%\Yunit\Window.ahk
#Include %A_ScriptDir%\Yunit\StdOut.ahk
#include <Windy\Windy>
#include <DbgOut>

; #Warn All
;#Warn LocalSameAsGlobal, Off
#SingleInstance force

ReferenceVersion := "0.10.4"
debug := 1

OutputDebug DBGVIEWCLEAR

;Yunit.Use(YunitStdOut, YunitWindow).Test(_BaseTestSuite, TempTestSuite)
Yunit.Use(YunitStdOut, YunitWindow).Test(_BaseTestSuite, GeometryTestSuite, MiscTestSuite, NotRealWindowTestSuite, HideShowTestSuite, ExistTestSuite, RollupTestSuite, MoveResizeTestSuite, TransparencyTestSuite)
Return


; ###################################################################
class TempTestSuite {
	Begin() {
		Global debug
		this.obj := new Windy(0, debug)
	}    

	border() {
		Global debug
		dbgOut(">[" A_ThisFunc "]", this.debug)
		OutputDebug % "[IMPORTANT]....[" A_ThisFunc "] > 1"
		Yunit.assert(this.obj.border == 1)
		OutputDebug % "[IMPORTANT]....[" A_ThisFunc "] > 0"
		this.obj.border := 0
		Yunit.assert(this.obj.border == 0)
		OutputDebug % "[IMPORTANT]....[" A_ThisFunc "] > 1"
		this.obj.border := 1
		Yunit.assert(this.obj.border == 1)
		dbgOut("<[" A_ThisFunc "]")
	}

	End() {
		this.obj.kill()
		this.remove("obj")
		this.obj := 
	}
}

; ###################################################################
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
class GeometryTestSuite {
	Begin() {
		Global debug
		this.obj := new Windy(0, debug)
	}    

	captionheight() {
		Global debug
		dbgOut(">[" A_ThisFunc "]")
		x := this.obj.captionheight
		Yunit.assert(x == 22)
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
		OutputDebug % "[IMPORTANT]**** " A_ThisFunc " 1 ****"
		t := this.obj.transparency
		Yunit.assert(t == 255)
		OutputDebug % "[IMPORTANT]**** " A_ThisFunc " 3 ****"
		this.obj.transparency(10) := 100
		t := this.obj.transparency
		Yunit.assert(t == 100)
		OutputDebug % "[IMPORTANT]**** " A_ThisFunc " 3 ****"
		this.obj.transparency(1) := "OFF"
		t := this.obj.transparency
		Yunit.assert(t == 255)
		dbgOut("<[" A_ThisFunc "]")
	}

	TransparencyNoCaption() {
		dbgOut(">[" A_ThisFunc "]")
		this.obj.caption := false
		OutputDebug % "[IMPORTANT]**** " A_ThisFunc " 1 ****"
		t := this.obj.transparency
		Yunit.assert(t == 255)
		OutputDebug % "[IMPORTANT]**** " A_ThisFunc " 3 ****"
		this.obj.transparency(10) := 100
		t := this.obj.transparency
		Yunit.assert(t == 100)
		OutputDebug % "[IMPORTANT]**** " A_ThisFunc " 3 ****"
		this.obj.transparency(1) := "OFF"
		t := this.obj.transparency
		Yunit.assert(t == 255)
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

		dbgOut(">[" A_ThisFunc "]")
		OutputDebug % "[IMPORTANT]**** " A_ThisFunc " 1 ****"
		val := this.obj.rolledUp
		Yunit.assert(val == false)
		
		OutputDebug % "[IMPORTANT]**** " A_ThisFunc " 2 ****"
		this.obj.rolledUp := false
		val := this.obj.rolledUp
		Yunit.assert(val == false)
		
		OutputDebug % "[IMPORTANT]**** " A_ThisFunc " 3 ****"
		this.obj.rolledUp := true
		val := this.obj.rolledUp
		Yunit.assert(val == true)
		
		OutputDebug % "[IMPORTANT]**** " A_ThisFunc " 4 ****"
		this.obj.rolledUp := false
		val := this.obj.rolledUp
		Yunit.assert(val == false)
		
		OutputDebug % "[IMPORTANT]**** " A_ThisFunc " 5 ****"
		this.obj.rolledUp := !this.obj.rolledUp ; as the window wasn't rolled up, it should be rolled up now
		val := this.obj.rolledUp
		Yunit.assert(val == true)
		
		OutputDebug % "[IMPORTANT]**** " A_ThisFunc " 6 ****"
		this.obj.rolledUp := !this.obj.rolledUp ; as the window was rolled up, it shouldn't be rolled up now
		val := this.obj.rolledUp
		Yunit.assert(val == false)

		OutputDebug % "[IMPORTANT]**** " A_ThisFunc " 7 ****"
		this.End()
		val := this.obj.rolledUp
		Yunit.assert(val == )
		dbgOut("<[" A_ThisFunc "]")
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
		dbgOut(">[" A_ThisFunc "]")
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
		dbgOut("<[" A_ThisFunc "]")
		
	}
	
	Minimize() {
		dbgOut(">[" A_ThisFunc "]")
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
		dbgOut("<[" A_ThisFunc "]")
		
	}
	
	MoveViaWinMove()  {
		dbgOut(">[" A_ThisFunc "]")
		oldPos := this.obj.posSize
		OutputDebug % "[IMPORTANT]Initial Position: " oldPos.Dump()
		
		xnew := oldPos.x+200
		ynew := oldPos.y+200
		
		OutputDebug % "[IMPORTANT]BEFORE - Moving from " oldPos.Dump() " to (" xnew "," ynew "," oldPos.w "," oldPos.h ")"
		WinMove % "ahk_id" this.obj.hwnd, ,xnew, ynew
		newPos := this.obj.posSize
		OutputDebug % "[IMPORTANT]AFTER - Moving from " oldPos.Dump() " to " newPos.Dump()
		Yunit.assert(newPos.x == xnew)
		Yunit.assert(newPos.y == ynew)
		Yunit.assert(newPos.w == oldPos.w)
		Yunit.assert(newPos.h == oldPos.h)
		dbgOut("<[" A_ThisFunc "]")
	}
	
	MoveViaMoveMethod() {
		dbgOut(">[" A_ThisFunc "]")
		oldPos := this.obj.posSize
		OutputDebug % "[IMPORTANT]Initial Position: " oldPos.Dump()
		
		xnew := oldPos.x+200
		ynew := oldPos.y+200
		
		OutputDebug % "[IMPORTANT]BEFORE - Moving from " oldPos.Dump() " to (" xnew "," ynew "," oldPos.w "," oldPos.h ")"
		this.obj.move(xnew, ynew, oldPos.w, oldPos.h)
		newPos := this.obj.posSize
		OutputDebug % "[IMPORTANT]AFTER - Moving from " oldPos.Dump() " to " newPos.Dump()
		Yunit.assert(newPos.x == xnew)
		Yunit.assert(newPos.y == ynew)
		Yunit.assert(newPos.w == oldPos.w)
		Yunit.assert(newPos.h == oldPos.h)
		dbgOut("<[" A_ThisFunc "]")
	}
	
	MoveViaPosSizeProperty() {
		dbgOut(">[" A_ThisFunc "]")
		oldPos := this.obj.posSize
		OutputDebug % "[IMPORTANT]Initial Position: " oldPos.Dump()
		
		xnew := oldPos.x+200
		ynew := oldPos.y+200
		
		OutputDebug % "[IMPORTANT]BEFORE - Moving from " oldPos.Dump() " to (" xnew "," ynew "," oldPos.w "," oldPos.h ")"
		this.obj.posSize := new Recty(xnew,ynew,oldPos.w,oldPos.h)
		newPos := this.obj.posSize
		OutputDebug % "[IMPORTANT]AFTER - Moving from " oldPos.Dump() " to " newPos.Dump()
		Yunit.assert(newPos.x == xnew)
		Yunit.assert(newPos.y == ynew)
		Yunit.assert(newPos.w == oldPos.w)
		Yunit.assert(newPos.h == oldPos.h)
		dbgOut("<[" A_ThisFunc "]")
	}

	MoveViaPosProperty() {
		dbgOut(">[" A_ThisFunc "]")
		oldPos := this.obj.pos
		OutputDebug % "[IMPORTANT]Initial Position: " oldPos.Dump()
		
		xnew := oldPos.x+200
		ynew := oldPos.y+200
		
		OutputDebug % "[IMPORTANT]BEFORE - Moving from " oldPos.Dump() " to (" xnew "," ynew  ")"
		this.obj.pos := new Pointy(xnew,ynew)
		newPos := this.obj.pos
		OutputDebug % "[IMPORTANT]AFTER - Moving from " oldPos.Dump() " to " newPos.Dump()
		Yunit.assert(newPos.x == xnew)
		Yunit.assert(newPos.y == ynew)
		dbgOut("<[" A_ThisFunc "]")
	}
	
	MoveResizeViaWinMove() {
		dbgOut(">[" A_ThisFunc "]")
		oldPos := this.obj.posSize
		OutputDebug % "[IMPORTANT]Initial Position: " oldPos.Dump()
        
		xnew := oldPos.x+10
		ynew := oldPos.y+20
		wnew := oldPos.w+10
		hnew := oldPos.h+20
		OutputDebug % "[IMPORTANT]BEFORE - Moving from " oldPos.Dump() " to (" xnew "," ynew "," wnew "," hnew ")"
		WinMove % "ahk_id" this.obj.hwnd, , xnew, ynew, wnew, hnew
		newPos := this.obj.posSize
		OutputDebug % "[IMPORTANT]AFTER - Moving from " oldPos.Dump() " to " newPos.Dump()
		Yunit.assert(newPos.x == xnew)
		Yunit.assert(newPos.y == ynew)
		Yunit.assert(newPos.w == wnew)
		Yunit.assert(newPos.h == hnew)
		
		dbgOut("<[" A_ThisFunc "]")
	}

	MoveResizeViaMoveMehod() {
		dbgOut(">[" A_ThisFunc "]")
		oldPos := this.obj.posSize
		OutputDebug % "[IMPORTANT]Initial Position: " oldPos.Dump()
        
		xnew := oldPos.x+10
		ynew := oldPos.y+20
		wnew := oldPos.w+10
		hnew := oldPos.h+20
		OutputDebug % "[IMPORTANT]BEFORE - Moving from " oldPos.Dump() " to (" xnew "," ynew "," wnew "," hnew ")"
		this.obj.move(xnew, ynew, wnew, hnew)
		newPos := this.obj.posSize
		OutputDebug % "[IMPORTANT]AFTER - Moving from " oldPos.Dump() " to " newPos.Dump()
		Yunit.assert(newPos.x == xnew)
		Yunit.assert(newPos.y == ynew)
		Yunit.assert(newPos.w == wnew)
		Yunit.assert(newPos.h == hnew)
		
		dbgOut("<[" A_ThisFunc "]")
	}
	
	MoveResizeViaPosSizeProperty() {
		dbgOut(">[" A_ThisFunc "]")
		oldPos := this.obj.posSize
		OutputDebug % "[IMPORTANT]Initial Position: " oldPos.Dump()
        
		xnew := oldPos.x+10
		ynew := oldPos.y+20
		wnew := oldPos.w+10
		hnew := oldPos.h+20
		OutputDebug % "[IMPORTANT]BEFORE - Moving from " oldPos.Dump() " to (" xnew "," ynew "," wnew "," hnew ")"
		this.obj.posSize := new Recty(xnew, ynew, wnew, hnew)
		newPos := this.obj.posSize
		OutputDebug % "[IMPORTANT]AFTER - Moving from " oldPos.Dump() " to " newPos.Dump()
		Yunit.assert(newPos.x == xnew)
		Yunit.assert(newPos.y == ynew)
		Yunit.assert(newPos.w == wnew)
		Yunit.assert(newPos.h == hnew)
		
		dbgOut("<[" A_ThisFunc "]")
	}
	
	ResizeViaWinMove() {
		dbgOut(">[" A_ThisFunc "]")
		oldPos := this.obj.posSize
		OutputDebug % "[IMPORTANT]Initial Position: " oldPos.Dump()
        
		wnew := oldPos.w+100
		hnew := oldPos.h+200
		
		OutputDebug % "[IMPORTANT]BEFORE - Moving from " oldPos.Dump() " to (" oldPos.x "," oldPos.y "," wnew "," hnew ")"
		WinMove % "ahk_id" this.obj.hwnd, , oldPos.x, oldPos.y, wnew, hnew
		newPos := this.obj.posSize
		OutputDebug % "[IMPORTANT]AFTER - Moving from " oldPos.Dump() " to " newPos.Dump()
		Yunit.assert(newPos.x == oldPos.x)
		Yunit.assert(newPos.y == oldPos.y)
		Yunit.assert(newPos.w == wnew)
		Yunit.assert(newPos.h == hnew)
		
		dbgOut("<[" A_ThisFunc "]")
	}
	
	ResizeViaMoveMethod() {
		dbgOut(">[" A_ThisFunc "]")
		oldPos := this.obj.posSize
		OutputDebug % "[IMPORTANT]Initial Position: " oldPos.Dump()
        
		wnew := oldPos.w+100
		hnew := oldPos.h+200
		
		OutputDebug % "[IMPORTANT]BEFORE - Moving from " oldPos.Dump() " to (" oldPos.x "," oldPos.y "," wnew "," hnew ")"
		this.obj.move(oldPos.x, oldPos.y, wnew, hnew)
		newPos := this.obj.posSize
		OutputDebug % "[IMPORTANT]AFTER - Moving from " oldPos.Dump() " to " newPos.Dump()
		Yunit.assert(newPos.x == oldPos.x)
		Yunit.assert(newPos.y == oldPos.y)
		Yunit.assert(newPos.w == wnew)
		Yunit.assert(newPos.h == hnew)
		
		dbgOut("<[" A_ThisFunc "]")
	}
	
	ResizeViaPosSizeProperty() {
		dbgOut(">[" A_ThisFunc "]")
		oldPos := this.obj.posSize
		OutputDebug % "[IMPORTANT]Initial Position: " oldPos.Dump()
        
		wnew := oldPos.w+100
		hnew := oldPos.h+200
		
		OutputDebug % "[IMPORTANT]BEFORE - Moving from " oldPos.Dump() " to (" oldPos.x "," oldPos.y "," wnew "," hnew ")"
		this.obj.posSize := new Recty(oldPos.x, oldPos.y, wnew, hnew)
		newPos := this.obj.posSize
		OutputDebug % "[IMPORTANT]AFTER - Moving from " oldPos.Dump() " to " newPos.Dump()
		Yunit.assert(newPos.x == oldPos.x)
		Yunit.assert(newPos.y == oldPos.y)
		Yunit.assert(newPos.w == wnew)
		Yunit.assert(newPos.h == hnew)	
		dbgOut("<[" A_ThisFunc "]")
	}

	ResizeViaSizeProperty() {
		dbgOut(">[" A_ThisFunc "]")
		oldSize:= this.obj.size
		OutputDebug % "[IMPORTANT]Initial Size: " oldSize.Dump()
        
		wnew := oldSize.x+100
		hnew := oldSize.y+200
		
		OutputDebug % "[IMPORTANT]BEFORE - Resizing from " oldSize.Dump() " to (" wnew "," hnew ")"
		this.obj.size := new Pointy(wnew, hnew)
		newSize := this.obj.size
		OutputDebug % "[IMPORTANT]AFTER - Resizing from " oldSize.Dump() " to " newSize.Dump()
		Yunit.assert(newSize.x == wnew)
		Yunit.assert(newSize.y == hnew)	
		dbgOut("<[" A_ThisFunc "]")
	}

	NoMoveResizeViaWinMove() {
		dbgOut(">[" A_ThisFunc "]")
		oldPos := this.obj.posSize
		OutputDebug % "[IMPORTANT]Initial Position: " oldPos.Dump()
		WinMove % "ahk_id" this.obj.hwnd, , oldPos.x, oldPos.y, oldPos.w, oldPos.h
		newPos := this.obj.posSize
		OutputDebug % "[IMPORTANT]AFTER - Moving from " oldPos.Dump() " to " newPos.Dump()
		Yunit.assert(newPos.x == oldPos.x)
		Yunit.assert(newPos.y == oldPos.y)
		Yunit.assert(newPos.w == oldPos.w)
		Yunit.assert(newPos.h == oldPos.h)		
		dbgOut("<[" A_ThisFunc "]")
	}		
	
	NoMoveResizeViaMoveMehod() {
		dbgOut(">[" A_ThisFunc "]")
		oldPos := this.obj.posSize
		OutputDebug % "[IMPORTANT]Initial Position: " oldPos.Dump()
		this.obj.move(oldPos.x, oldPos.y, oldPos.w, oldPos.h)
		newPos := this.obj.posSize
		OutputDebug % "[IMPORTANT]AFTER - Moving from " oldPos.Dump() " to " newPos.Dump()
		Yunit.assert(newPos.x == oldPos.x)
		Yunit.assert(newPos.y == oldPos.y)
		Yunit.assert(newPos.w == oldPos.w)
		Yunit.assert(newPos.h == oldPos.h)		
		dbgOut("<[" A_ThisFunc "]")
	}		

	NoMoveResizeViaPosSizeProperty() {
		dbgOut(">[" A_ThisFunc "]")
		oldPos := this.obj.posSize
		OutputDebug % "[IMPORTANT]Initial Position: " oldPos.Dump()
		this.obj.posSize := new Recty(oldPos.x, oldPos.y, oldPos.w, oldPos.h)
		newPos := this.obj.posSize
		OutputDebug % "[IMPORTANT]AFTER - Moving from " oldPos.Dump() " to " newPos.Dump()
		Yunit.assert(newPos.x == oldPos.x)
		Yunit.assert(newPos.y == oldPos.y)
		Yunit.assert(newPos.w == oldPos.w)
		Yunit.assert(newPos.h == oldPos.h)		
		dbgOut("<[" A_ThisFunc "]")
	}

	NoMoveViaPosProperty() {
		dbgOut(">[" A_ThisFunc "]")
		oldPos := this.obj.pos
		OutputDebug % "[IMPORTANT]Initial Position: " oldPos.Dump()
		this.obj.pos := new Pointy(oldPos.x, oldPos.y)
		newPos := this.obj.pos
		OutputDebug % "[IMPORTANT]AFTER - Moving from " oldPos.Dump() " to " newPos.Dump()
		Yunit.assert(newPos.x == oldPos.x)
		Yunit.assert(newPos.y == oldPos.y)
		dbgOut("<[" A_ThisFunc "]")
	}

	NoResizeViaSizeProperty() {
		dbgOut(">[" A_ThisFunc "]")
		oldSize := this.obj.size
		OutputDebug % "[IMPORTANT]Initial Size: " oldSize.Dump()
		this.obj.size := new Pointy(oldSize.x, oldSize.y)
		newSize := this.obj.size
		OutputDebug % "[IMPORTANT]AFTER - Resizing from " oldSize.Dump() " to " newSize.Dump()
		Yunit.assert(newSize.x == oldSize.x)
		Yunit.assert(newSize.y == oldSize.y)	
		dbgOut("<[" A_ThisFunc "]")	
	}
	
	scale() {
		dbgOut(">[" A_ThisFunc "]")
		this.obj.maximized := true
		this.obj.scale(2)
		dbgOut("<[" A_ThisFunc "]")
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
		dbgOut(">[" A_ThisFunc "]")
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
		dbgOut("<[" A_ThisFunc "]")
	}
        
	HiddenFalse() {
		dbgOut(">[" A_ThisFunc "]")
		Yunit.assert(this.obj.hidden==false)
		dbgOut("<[" A_ThisFunc "]")
	}
      
	HiddenTrue() {
		dbgOut(">[" A_ThisFunc "]")
		this.obj.hidden := true
		Yunit.assert(this.obj.hidden == true)
		dbgOut("<[" A_ThisFunc "]")
	}

	HiddenDoesNotExist() {
		dbgOut(">[" A_ThisFunc "]")
		this.obj.kill()
		Yunit.assert(this.obj.hidden==-1)
		dbgOut("<[" A_ThisFunc "]")
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
		dbgOut(">[" A_ThisFunc "]")
		Global debug
		HDesktop := DllCall("User32.dll\GetDesktopWindow", "UPtr")
		this.obj := new Windy(HDesktop, debug)
		Yunit.assert(this.obj==)
		dbgOut("<[" A_ThisFunc "]")
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

	border() {
		Global debug
		dbgOut(">[" A_ThisFunc "]")
		OutputDebug % "[IMPORTANT]....[" A_ThisFunc "] > 1"
		Yunit.assert(this.obj.border == 1)
		OutputDebug % "[IMPORTANT]....[" A_ThisFunc "] > 0"
		this.obj.border := 0
		Yunit.assert(this.obj.border == 0)
		OutputDebug % "[IMPORTANT]....[" A_ThisFunc "] > 1"
		this.obj.border := 1
		Yunit.assert(this.obj.border == 1)
		dbgOut("<[" A_ThisFunc "]")
	}

	Caption() {
		dbgOut(">[" A_ThisFunc "]")
		OutputDebug % "[IMPORTANT]....[" A_ThisFunc "] > 1"
		Yunit.assert(this.obj.caption == 1)
		OutputDebug % "[IMPORTANT]....[" A_ThisFunc "] > 0"
		this.obj.caption := 0
		Yunit.assert(this.obj.caption == 0)
		OutputDebug % "[IMPORTANT]....[" A_ThisFunc "] > 1"
		this.obj.caption := 1
		Yunit.assert(this.obj.caption == 1)
		dbgOut("<[" A_ThisFunc "]")
	}

	Center() {
		Global debug
		dbgOut(">[" A_ThisFunc "]")
		hwnd := this.obj.hwnd
		WinGetPos  x, y, w, h, ahk_id %hwnd%
		centerx := round(x+(w)/2)
		centery := round(y+(h)/2)
		OutputDebug % "[IMPORTANT]**** " A_ThisFunc " 1 ****"
		center := this.obj.centercoords
		Yunit.assert(center.x == centerx)
		Yunit.assert(center.y == centery)
		
		OutputDebug % "[IMPORTANT]**** " A_ThisFunc " 2 ****"
		newCenter := new Pointy(205,205,debug)
		this.obj.centercoords := newCenter
		center := this.obj.centercoords
		Yunit.assert(center.x == 205)
		Yunit.assert(center.y == 205)
		dbgOut("<[" A_ThisFunc "]")
	}

	Classname() {
		dbgOut(">[" A_ThisFunc "]")
		Yunit.assert(this.obj.classname =="Notepad")
		dbgOut("<[" A_ThisFunc "]")
	}

	hscrollable() {
		dbgOut(">[" A_ThisFunc "]")
		OutputDebug % "[IMPORTANT]....[" A_ThisFunc "] > Initial"
		Yunit.assert(this.obj.hscrollable == 0)
		OutputDebug % "[IMPORTANT]....[" A_ThisFunc "] > 1"
		this.obj.hscrollable := 1
		Yunit.assert(this.obj.hscrollable == 1)
		OutputDebug % "[IMPORTANT]....[" A_ThisFunc "] > 0"
		this.obj.hscrollable := 0
		Yunit.assert(this.obj.hscrollable == 0)
		OutputDebug % "[IMPORTANT]....[" A_ThisFunc "] > 1"
		this.obj.hscrollable := !this.obj.hscrollable
		Yunit.assert(this.obj.hscrollable == 1)
		dbgOut("<[" A_ThisFunc "]")
	}

	maximizebox() {
		dbgOut(">[" A_ThisFunc "]")
		OutputDebug % "[IMPORTANT]....[" A_ThisFunc "] > Initial"
		Yunit.assert(this.obj.maximizebox == 1)
		OutputDebug % "[IMPORTANT]....[" A_ThisFunc "] > 0"
		this.obj.maximizebox := 0
		Yunit.assert(this.obj.maximizebox == 0)
		OutputDebug % "[IMPORTANT]....[" A_ThisFunc "] > 1"
		this.obj.maximizebox := !this.obj.maximizebox
		Yunit.assert(this.obj.caption == 1)
		dbgOut("<[" A_ThisFunc "]")
	}

	minimizebox() {
		dbgOut(">[" A_ThisFunc "]")
		OutputDebug % "[IMPORTANT]....[" A_ThisFunc "] > Initial"
		Yunit.assert(this.obj.minimizebox == 1)
		OutputDebug % "[IMPORTANT]....[" A_ThisFunc "] > 0"
		this.obj.minimizebox := 0
		Yunit.assert(this.obj.minimizebox == 0)
		OutputDebug % "[IMPORTANT]....[" A_ThisFunc "] > 1"
		this.obj.minimizebox := !this.obj.minimizebox
		Yunit.assert(this.obj.caption == 1)
		dbgOut("<[" A_ThisFunc "]")
		
	}

	nextprevious() {
		Global debug

		dbgOut(">[" A_ThisFunc "]")
		hwndNext := this.obj.next
		nextObj := new Windy(hwndNext, 0)
		OutputDebug % "[IMPORTANT] NEXT OF [" this.obj.hwnd "-<" this.obj.title ">]: [" hwndNext "-<" nextObj.title ">]"
		hwndPrev := this.obj.previous
		prevObj := new Windy(hwndPrev, 0)
		OutputDebug % "[IMPORTANT] PREVIOUS OF [" this.obj.hwnd "-<" this.obj.title ">]: [" hwndPrev "-" prevObj.title "]"   
		Yunit.assert(this.obj.hwnd == prevObj.next)
		Yunit.assert(this.obj.hwnd == nextObj.previous)
		dbgOut("<[" A_ThisFunc "]")
	}

	Title() {
		dbgOut(">[" A_ThisFunc "]")
		Yunit.assert(this.obj.title =="Unbenannt - Editor")
		this.obj.title := "Halllloo"
		Yunit.assert(this.obj.title =="Halllloo")
		dbgOut("<[" A_ThisFunc "]")
	}

	Parent() {
		dbgOut(">[" A_ThisFunc "]")
		parent := this.parent
		Yunit.assert(parent == )	
		dbgOut("<[" A_ThisFunc "]")
	}

	Processname() {
		dbgOut(">[" A_ThisFunc "]")
		val := this.obj.processname
		Yunit.assert( val == "notepad.exe")
		dbgOut("<[" A_ThisFunc "]")
	}

	ProcessID() {
		dbgOut(">[" A_ThisFunc "]")
		val := this.obj.processID
		Yunit.assert( val > 0)
		dbgOut("<[" A_ThisFunc "]")
	}

	Resizable() {
		dbgOut(">[" A_ThisFunc "]")
		OutputDebug % "[IMPORTANT]...[" A_ThisFunc "]> 1"
		Yunit.assert( this.obj.resizable == 1)
		OutputDebug % "[IMPORTANT]...[" A_ThisFunc "]> 0"
		this.obj.resizable := 0
		Yunit.assert( this.obj.resizable == 0)
		OutputDebug % "[IMPORTANT]...[" A_ThisFunc "]> toggle"
		this.obj.resizable := !this.obj.resizable
		Yunit.assert( this.obj.resizable == 1)
		dbgOut("<[" A_ThisFunc "]")
		sleep, 500
	}

	vscrollable() {
		dbgOut(">[" A_ThisFunc "]")
		OutputDebug % "[IMPORTANT]....[" A_ThisFunc "] > Initial"
		Yunit.assert(this.obj.vscrollable == 0)
		OutputDebug % "[IMPORTANT]....[" A_ThisFunc "] > 1"
		this.obj.vscrollable := 1
		Yunit.assert(this.obj.vscrollable == 1)
		OutputDebug % "[IMPORTANT]....[" A_ThisFunc "] > 0"
		this.obj.vscrollable := 0
		Yunit.assert(this.obj.vscrollable == 0)
		OutputDebug % "[IMPORTANT]....[" A_ThisFunc "] > 1"
		this.obj.vscrollable := !this.obj.vscrollable
		Yunit.assert(this.obj.vscrollable == 1)
		dbgOut("<[" A_ThisFunc "]")
	}

	AlwaysOnTop() {
		dbgOut(">[" A_ThisFunc "]")
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
		dbgOut("<[" A_ThisFunc "]")
	}

	MonitorID() {
		Global debug
		dbgOut(">[" A_ThisFunc "]")
		OutputDebug % "[IMPORTANT]**** " A_ThisFunc " 1 ****"
		this.obj.Move(2,2,300,300)
		monID := this.obj.monitorID
		Yunit.assert(monId == 2)
		OutputDebug % "[IMPORTANT]**** " A_ThisFunc " 2 - via Move ****"
		obj := new Mony(2, debug)
		rect2 := obj.boundary
		this.obj.Move(rect2.x+10,rect2.y+10,300,300)
		monID := this.obj.monitorID
		Yunit.assert(monId == 2)
		OutputDebug % "[IMPORTANT]**** " A_ThisFunc " 3 - via MonitorID ****"
		this.obj.monitorID := 2
		monID := this.obj.monitorID
		Yunit.assert(monId == 2)
		dbgOut("<[" A_ThisFunc "]")
	}

	Hangs() {
		dbgOut(">[" A_ThisFunc "]")
		val := this.obj.hangs
		Yunit.assert(val == false)
		dbgOut("<[" A_ThisFunc "]")
		
	}
    
	Getter() {
		dbgOut(">[" A_ThisFunc "]")
		hwnd := this.obj.hwnd
		WinGetPos  x, y, w, h, ahk_id %hwnd%
		Yunit.assert(1 == ((this.obj.posSize.x == x) && (this.obj.posSize.y == y) && (this.obj.posSize.w == w) && (this.obj.posSize.h == h)))
		dbgOut("<[" A_ThisFunc "]")
	}

	owner() {
		dbgOut(">[" A_ThisFunc "]")
		own:= this.obj.owner
		Yunit.assert(own == 0)
		dbgOut("<[" A_ThisFunc "]")
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
		dbgOut(">[" A_ThisFunc "]")
		Yunit.assert(this.obj.exist ==true)
		dbgOut("<[" A_ThisFunc "]")
	}

	End() {
		this.obj.kill()
		this.remove("obj")
		this.obj := 
	}
}

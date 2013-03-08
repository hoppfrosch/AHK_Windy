/*
	Title: WindowHandling class
		Class to handle single window

	Author: 
		hoppfrosch@ahk4.me
		
	License: 
		WTFPL (http://sam.zoy.org/wtfpl/)
		
	Changelog:

		0.1.0 - [+] Initial
*/
	
; ****** HINT: Documentation can be extracted to HTML using NaturalDocs ************** */

#include <Rectangle>
#include <MultiMonitorEnv>


; ******************************************************************************************************************************************
class WindowHandler {
	
	_version := "0.1.0"
	debug := 0
	_hWnd := 0

	_hUnrolled := 0
/*
===============================================================================
Function: alwaysOnTop
	Toogles "Always On Top" for window

Parameters:
	mode - "on", "off", "toggle" (Default)

See also:  
	<__isAlwaysOnTop>, <__Get>

Author(s):
	20130308 - hoppfrosch@ahk4.me - Initial
===============================================================================
*/
	alwaysOnTop(mode="toggle") {
		if (this.debug) ; _DBG_
			OutputDebug % ">[" A_ThisFunc "([" this._hWnd "], mode=" mode ")] -> CurrentState:" this.alwaysontop ; _DBG_
		foundpos := RegExMatch(mode, "i)on|off|toggle")
		if (foundpos = 0)
			mode := "toggle"

		StringLower mode,mode	
		val := this._hWnd
		WinSet, AlwaysOnTop, %mode%,  ahk_id %val%
			
		if (this.debug) ; _DBG_
			OutputDebug % "<[" A_ThisFunc "([" this._hWnd "], mode=" mode ")] -> NewState:" this.alwaysontop ; _DBG_
	}

/*
===============================================================================
Function: hidden
	Toogles "Hidden" for window

Parameters:
	mode - "on", "off", "toggle" (Default)

See also:  
	<show>, <hide>, <__isHidden>

Author(s):
	20130308 - hoppfrosch@ahk4.me - Initial
===============================================================================
*/
	hidden(mode="toggle") {
		if (this.debug) ; _DBG_
			OutputDebug % ">[" A_ThisFunc "([" this._hWnd "], mode=" mode ")] -> CurrentState:" this.__isHidden() ; _DBG_
		foundpos := RegExMatch(mode, "i)on|off|toggle")
		if (foundpos = 0)
			mode := "toggle"

		StringLower mode,mode

		if (mode = "on")
			this.Hide()
		else if (mode = "off")
			this.Show()
		else {
			if (this.__isHidden())
				this.show()
			else
				this.hide()
		}
		if (this.debug) ; _DBG_
			OutputDebug % "<[" A_ThisFunc "([" this._hWnd "], mode=" mode ")] -> NewState:" this.__isHidden() ; _DBG_
	}
	
/*
===============================================================================
Function: hide
	Hides the Window. Use <show> to unhide a hidden window

See also:
	<show>, <__isHidden>, <hidden>

Author(s):
	20130308 - hoppfrosch@ahk4.me - Original
===============================================================================
*/
	hide() {
		val := this._hWnd
		if (this.debug) ; _DBG_
			OutputDebug % "|[" A_ThisFunc "([" this._hWnd "])]" ; _DBG_		
		WinHide ahk_id %val%
	}

/*
===============================================================================
Function:   kill
	Kills the Window

Author(s):
	20130308 - hoppfrosch@ahk4.me - Original
===============================================================================
*/
	kill() {
		if (this.debug) ; _DBG_
			OutputDebug % "|[" A_ThisFunc "([" this._hWnd "])]" ; _DBG_		

		prevState := A_DetectHiddenWindows
		DetectHiddenWindows, On
		WinKill % "ahk_id" this._hWnd
		DetectHiddenWindows, %prevState%
	}

/*
===============================================================================
Function: move
	Moves the window

Parameters:
	X,Y,W,H - Position and Width/Height the window has to be moved/resized to

Author(s):
	20130308 - hoppfrosch@ahk4.me - Original
===============================================================================
*/
	move(X,Y,W="",H="") {
		if (this.debug) ; _DBG_
			OutputDebug % ">[" A_ThisFunc "([" this._hWnd "])(X=" X " ,Y=" Y " ,W=" W " ,H=" H ")]" ; _DBG_		
		if (X = 99999 || Y = 99999 || W = 99999 || H = 9999)
			currPos := this.pos
		
		if (X = 99999)
			X := currPos.X
		
		if (Y = 99999)
			Y := currPos.Y
		
		if (W = 99999)
			W := currPos.W
		
		if (H = 99999)
			H := currPos.H
		
		if (this.debug) ; _DBG_
			OutputDebug % "<[" A_ThisFunc "([" this._hWnd "])(X=" X " ,Y=" Y " ,W=" W " ,H=" H ")]" ; _DBG_		
		WinMove % "ahk_id" this._hWnd, , X, Y, W, H
	}

/*
===============================================================================
Function:   show
	Shows the Window. Used to show a hidden window (see <hide>)
	
See also:
	<hide>, <__isHidden>

Author(s):
	20130308 - hoppfrosch@ahk4.me - Original
===============================================================================
*/
	show() {
		val := this._hWnd
		if (this.debug) ; _DBG_
			OutputDebug % "|[" A_ThisFunc "([" this._hWnd "])]" ; _DBG_		
		WinShow ahk_id %val%
	}


/*
===============================================================================
Function: __centercoords
	Determine center of the window (*INTERNAL*)

Returns:
	<Rectangle> - Rectangle containing the current center and size (0) of the window

Author(s):
	20130308 - hoppfrosch@ahk4.me - Original
===============================================================================
*/
	__centercoords() {
		pos := this.Pos
		x := Round((pos.w)/2 + pos.x)
		y := Round((pos.h)/2 + pos.y)
		centerPos := new Rectangle(x,y,0,0,this.debug)
		if (this.debug) ; _DBG_
			OutputDebug % "<[" A_ThisFunc "(pos="pos.dump() " [" this._hWnd "])] -> " centerPos.dump() ; _DBG_
		return centerPos
	}

/*
===============================================================================
Function:   __classname 
	Determines the Window class (*INTERNAL*)

Returns:
	WindowClass

Author(s):
	20130308 - hoppfrosch@ahk4.me - Original
=============================================================================== 
*/
	__classname() {
		val := this._hWnd
		WinGetClass, __classname, ahk_id %val%
		if (this.debug) ; _DBG_
			OutputDebug % "|[" A_ThisFunc "([" this._hWnd "]) -> (" __classname ")]" ; _DBG_		
		return __classname
	}

/*
===============================================================================
Function:   __exist
	Checks if the specified window exists (*INTERNAL*)

Returns:
	true or false

Author(s):
	20130308 - hoppfrosch@ahk4.me - Original
===============================================================================
*/
	__exist() {
		val := this._hWnd
		_hWnd := WinExist("ahk_id " val)
		ret := true
		if (_hWnd = 0)
			ret := false
		if (this.debug) ; _DBG_
			OutputDebug % "|[" A_ThisFunc "([" this._hWnd "])] -> " ret ; _DBG_		
		return ret
	}

/*
===============================================================================
Function:   __isAlwaysOnTop
	Determine whether window is set to "always on top" (*INTERNAL*)

Returns:
	True or False

See also:  
	<alwaysOnTop>, <__Get>

Author(s):
	20130308 - hoppfrosch@ahk4.me - Initial
===============================================================================
*/
	__isAlwaysOnTop() {
		val := this._hWnd
		ret := (this.styleEx & 0x08) ; WS_EX_TOPMOST
		ret := ret>0?1:0
		
		if (this.debug) ; _DBG_
			OutputDebug % "|[" A_ThisFunc "([" this._hWnd "])] -> " ret ; _DBG_
		return ret
	}

/*
===============================================================================
Function:   __isHidden
	Checks whether the window is hidden (*INTERNAL*)

Returns:
	true (window is hidden), false (window is visible) or -1 (window does not exist at all)

Author(s):
	20130308 - hoppfrosch@ahk4.me - Original
	
See also:
	<hide>, <show>, <hidden>
===============================================================================
*/
	__isHidden() {
		prevState := A_DetectHiddenWindows
		ret := false
		DetectHiddenWindows, Off
		if this.exist {
			; As HiddenWindows are not detected, the window is not hidden in this case ...
			ret := false
		} 
		else {
			DetectHiddenWindows, On 
			if this.exist {
				; As HiddenWindows are detected, the window is hidden in this case ...
				ret := true
			} 
			else {
				; the window does not exist at all ...
				ret := -1
			}
		}
		
		DetectHiddenWindows, %prevState%
		if (this.debug) ; _DBG_
			OutputDebug % "|[" A_ThisFunc "([" this._hWnd "])] -> " ret ; _DBG_		
		return ret
	}


/*
===============================================================================
Function:   __isResizable
    Determine whether window can be resized by user (*INTERNAL*)

Returns:
    True or False
     
Author(s):
    20130308 - hoppfrosch@ahk4.me - Original
===============================================================================
*/
	__isResizable() {
		ret := true
		if this.__classname in Chrome_XPFrame,MozillaUIWindowClass
			ret := true
		else 
		    ret := (this.style & 0x40000) ; WS_SIZEBOX
		
		if (this.debug) ; _DBG_
			OutputDebug % "|[" A_ThisFunc "([" this._hWnd "])] -> " ret ; _DBG_		
		
		return ret
}

/*
===============================================================================
Function:  __ monitorID
    Determines ID of monitor the window currently is on (i.e center of window) (*INTERNAL*)

Returns:
    MonitorID
     
Author(s):
	20130308 - hoppfrosch@ahk4.me - Original
===============================================================================
*/
	__monitorID(default=1) {
		mon := default
		c := this.centercoords
		mme := new MultiMonitorEnv(this.debug)
		mon := mme.monGetFromCoord(c.x,c.y,default)
		if (this.debug) ; _DBG_
			OutputDebug % "|[" A_ThisFunc "([" this._hWnd "])] -> " mon ; _DBG_		
		return mon
}
	
/*
===============================================================================
Function: __pos
	Determine current position of the window (*INTERNAL*)

Returns:
	<Rectangle> - Rectangle containing the current position and size of the window

Author(s):
	20130308 - hoppfrosch@ahk4.me - Original
===============================================================================
*/
	__pos() {
		currPos := new Rectangle(0,0,0,0,this.debug)
		currPos.fromHWnd(this._hWnd)
		if (this.debug) ; _DBG_
			OutputDebug % "<[" A_ThisFunc "(" aName ", [" this._hWnd "])] -> (" currPos.dump() ")" ; _DBG_
		return currPos
	}
			

/*
===============================================================================
Function:   __style
	Determines the current style of the window (*INTERNAL*)
	
Returns:
	Current Style

Author(s):
	20130308 - hoppfrosch@ahk4.me - Original
===============================================================================
*/
	__style() {
		val := this._hWnd
		WinGet, currStyle, Style, ahk_id %val%
		if (this.debug) ; _DBG_
			OutputDebug % "|[" A_ThisFunc "([" this._hWnd "])] -> (" currStyle ")" ; _DBG_		
		return currStyle
	}

/*
===============================================================================
Function:   __styleEx
	Determines the current extended style of the window (*INTERNAL*)
	
Returns:
	Current Extended Style

Author(s):
	20130308 - hoppfrosch@ahk4.me - Original
===============================================================================
*/
	__styleEx() {
		val := this._hWnd
		WinGet, currExStyle, ExStyle, ahk_id %val%
		if (this.debug) ; _DBG_
			OutputDebug % "|[" A_ThisFunc "([" this._hWnd "])] -> (" currExStyle ")" ; _DBG_		
		return currExStyle
	}

/*
===============================================================================
Function:   __title
	Determines the Window title (*INTERNAL*)
	
Returns:
	WindowTitle

Author(s):
	20130308 - hoppfrosch@ahk4.me - Original
===============================================================================
*/
	__title()	{
		val := this._hWnd
		WinGetTitle, title, ahk_id %val%
		if (this.debug) ; _DBG_
			OutputDebug % "|[" A_ThisFunc "([" this._hWnd "]) -> (" title ")]" ; _DBG_		
		return title
	}

/*
===============================================================================
Function: __debug
	Set or get the debug flag (*INTERNAL*)

Parameters:
	value - Value to set the debug flag to (OPTIONAL)

Returns:
	true or false, depending on current value

Author(s):
	20130308 - hoppfrosch@ahk4.me - Original
===============================================================================
*/  
	__debug(value="") { ; _DBG_
		if % (value="") ; _DBG_
			return this.debug ; _DBG_
		value := value<1?0:1 ; _DBG_
		this.debug := value ; _DBG_
		return this.debug ; _DBG_
	} ; _DBG_
 
/*
===============================================================================
Function: __Delete
	Destructor (*INTERNAL*)

Author(s):
	20130308 - hoppfrosch@ahk4.me - Original
===============================================================================
*/     
	__Delete() {
		; Reset all "dangerous" settings 
		if (this.alwaysontop == true) {
			this.alwaysOnTop("off")
		}
		if (this.__isHidden() == 1) {
			this.show()
		}
		if (this.debug) ; _DBG_
			OutputDebug % "|[" A_ThisFunc "([" this._hWnd "])"  ; _DBG_
	}

/*
===============================================================================
Function: __Get
	Custom Getter (*INTERNAL*)

	Supports following attributes:
	* *alwaysontop* - is windows fixed on top of all other windows?
			Returns a bool containing the AlwaysOnTop-state of the window (see <__isAlwaysOnTop>)
	* *centercoords* - current coordinates of the center of the window
			Returns current coordinates of the center of the window as an object of class <Rectangle> (see <__centercoords>)
	* *classname* - classename of window
			Returns a string containing classname (see <__classname>)
	* *exist* - does window exist?
			Returns a bool indicating whether the window still exists (see <__exist>)
	* *hidden* - is window hidden?
			Returns a bool indicating whether the window is hidden (see <__hidden>)
	* *monitorID* - ID of monitor the window currently is on (i.e center of window)
			Returns ID of monitor the window currently is on (i.e center of window) (see <__monitorID>)
	* *pos* - current position of window
			Returns an object of class <Rectangle> (see <__pos>)
	* resizable - is the window resizeable?
			Returns a bool containig the Resizeble-state of the window (see <_isResizable>)
	* style - Style of the window
			Returns a number describing the style (see <__style>)
	* styleEx - extended style of window
			Returns a number describing the extended style (see <__styleEx>)
	* title - title of window
			Returns a string containing title (see <__title>)
	
Author(s):
	20121030 - hoppfrosch - Original
===============================================================================
*/     
	__Get(aName) {
		if (this.debug) ; _DBG_
				OutputDebug % ">[" A_ThisFunc "(" aName ", [" this._hWnd "])]" ; _DBG_
        if (aName = "alwaysontop") {
			return this.__isAlwaysOnTop()
		}
        if (aName = "classname") {
			return this.__classname()
		}
		if (aName = "exist") {
			return this.__exist()
		}
		if (aName = "hidden") {
			return this.__isHidden()
		}
		if (aName = "monitorID") {
			return this.__monitorID()
		}
		if (aName = "pos") { ; current position
			return this.__pos()
		}
		if (aName = "centercoords") { ; center coordinate of the current window
			return this.__centercoords()
		}
		if (aName = "resizeable") { 
			return this.__isResizable()
		}
		if (aName = "style") {
			return this.__style()
		}
		if (aName = "styleEx") {
			return this.__styleEx()
		}
		if (aName = "title") {
			return this.__title()
		}
		return
	}

/*
===============================================================================
Function: __New
	Constructor (*INTERNAL*)

Parameters:
	hWnd - Window handle (*Obligatory*). If hWnd=0 a test window is created ...
	debug - Flag to enable debugging (Optional - Default: 0)

Returns:
	true or false, depending on current value

Author(s):
	20130308 - hoppfrosch@ahk4.me - Original
===============================================================================
*/     
	__New(_hWnd=-1, debug=0, _test=0) {
		this.debug := debug
		if (this.debug) ; _DBG_
			OutputDebug % ">[" A_ThisFunc "(hWnd=(" _hWnd ")] (version: " this._version ")" ; _DBG_

		if % (A_AhkVersion < "1.1.08.00" && A_AhkVersion >= "2.0") {
			MsgBox 16, Error, %A_ThisFunc% :`n This class is only tested with AHK_L later than 1.1.08.00 (and before 2.0)`nAborting...
			if (this.debug) ; _DBG_
				OutputDebug % "<[" A_ThisFunc "(...) -> ()]: *ERROR* : This class is only tested with AHK_L later than 1.1.08.00 (and before 2.0). Aborting..." ; _DBG_
			return
		}

		if  % (_hWnd = 0) {
			; Create a Testwindow ...
			Run, notepad.exe
			WinWait, ahk_class Notepad, , 2
			WinMove, ahk_class Notepad,, 10, 10, 300, 300
			_hWnd := WinExist("ahk_class Notepad")
		} else if % (_hWnd = -1) {
			; hWnd is missing
			MsgBox  16, Error, %A_ThisFunc% :`n Required parameter is missing`nAborting...
			if (this.debug) ; _DBG_
				OutputDebug % "<[" A_ThisFunc "(...) -> ()] *ERROR*: Required parameter is missing. Aborting..." ; _DBG_
			return
		}
		this._hWnd := _hWnd

		; initially store the position to detect movement of window and allow window restoring
		WinGetPos, x, y, w, h, ahk_id %_hWnd%
		
		return this
	}
	
}

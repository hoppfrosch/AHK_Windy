; ****** HINT: Documentation can be extracted to HTML using GenDocs (https://github.com/fincs/GenDocs) by fincs************** */
#include <Rectangle>
#include <MultiMonitorEnv>
#include <_WindowHandlerEvent>

; ******************************************************************************************************************************************
/*!
	Class: WindowHandler
	Remarks:
		### License
			This program is free software. It comes without any warranty, to the extent permitted by applicable law. You can redistribute it and/or modify it under the terms of the Do What The Fuck You Want To Public License, Version 2, as published by Sam Hocevar. See [WTFPL](http://www.wtfpl.net/) for more details.
		### Author
			[hoppfrosch](hoppfrosch@ahk4.me)
		### History
		    - 0.5.0
				- [*] Added setter for property `alwaysOnTop`
					- [*] Renamed `alwaysOnTop()` to `_alwaysOnTop()`
		    - 0.4.0 
				- [+] New: Maximize Window `maximize()`
				- [+] New: Minimize Window `minimize()`
				- [+] New: Property `maximized` to check maximized-state of window  
				- [+] New: Property `minimized` to check minimized-state of window  
				- [*] Simplified `__Get()` (centralized debugging)  
				- [*] Incompatible Change: Unified parameternames "on"/"on" to true/false (`alwaysOnTop()`, `hidden()`, `rollup()`, ...)
			- 0.3.2 
				- [+] Check whether window is a real window `__isWindow`
			- 0.3.1 
				- [*] Renamed `tile()` to `movePercental()`
				- [*] Use of `monWorkingArea` instead of `monSize` within `movePercental()`
			- 0.3.0 
				- [+] Tiling-Functionality `tile()`
			- 0.2.0 
				- [+] Event-Handling
				- [+] New: Rollup Window `rollup()`
			- 0.1.0 
				- [+] Initial
		## To Be Done
			- Replace existing functions with properties:
				-
			
	@UseShortForm
*/
class WindowHandler {
	
	_version := "0.5.0"
	_debug := 0
	_hWnd := 0
	
	_hWinEventHook1 := 0
	_hWinEventHook2 := 0
	_HookProcAdr := 0
		
	_bManualMovement := false

	_posStack := 0


__Set(aName, aValue) {
		ret :=
		
		 if (aName = "alwaysOnTop") {
	/*! ---------------------------------------------------------------------------------------
		Property: alwaysOnTop [set]
			Sets the *Always-On-Top*-State
		Remarks:
			### Valid values			
				* `true` or `1` - activates  *Always-On-Top*-State
				* `false` or `0` - deactivates  *Always-On-Top*-State
			To toogle current *Always-On-Top*-State, simply use `obj.alwaysOnTop := !obj.alwaysOnTop`	
				
			### Author(s)
				* 20130426 - [hoppfrosch](hoppfrosch@ahk4.me) - Original
	*/
			this.__alwaysOnTop(aValue)
		}
	}

/*
===============================================================================
Function: __Get
	Custom Getter (*INTERNAL*)

	Supports following attributes:
	* *rolledUpHeight* - Height of a rolled-up window		
	* *style* - Style of the window (see <__style>)
	* *styleEx* - extended style of window (see <__styleEx>)
	* *title* - title of window (see <__title>)
	
Author(s):
	20121030 - hoppfrosch - Original
===============================================================================
*/     
	__Get(aName) {
		ret := 
		written := 0 ; _DBG_

	
        if (aName = "alwaysOnTop") {
	/*! ---------------------------------------------------------------------------------------
		Property: alwaysOnTop [get]
			Returns the current *Always-On-Top*-State
	*/
			ret := this.__isAlwaysOnTop()
		}
		else if (aName = "centercoords") { ; center coordinate of the current window
	/*! ---------------------------------------------------------------------------------------
		Property: centercoords [get]
			Returns the coordinates of the center of the window as a [Rectangle](Rectangle.html)-object
	*/
			ret := this.__centercoords()
		}
        else if (aName = "classname") {
	/*! ---------------------------------------------------------------------------------------
		Property: classname [get]
			Returns the name of the window class
	*/
			ret := this.__classname()
		}
		else if (aName = "exist") {
	/*! ---------------------------------------------------------------------------------------
		Property: exist [get]
			Checks whether the window still exists
	*/
			ret := this.__exist()
		}
		else if (aName = "hidden") {
	/*! ---------------------------------------------------------------------------------------
		Property: hidden [get]
			Returns the current *Hidden*-State (see [hidden()](#hidden))
	*/
			ret := this.__isHidden()
		}
		else if (aName = "maximized") {
	/*! ---------------------------------------------------------------------------------------
		Property: maximized [get]
			Returns the current *Maximized*-State (see [maximize()](#maximize))
	*/
			ret := this.__isMaximized()
		}
		else if (aName = "minimized") {
	/*! ---------------------------------------------------------------------------------------
		Property: minimized [get]
			Returns the current *Maximized*-State (see [minimize()](#minimize))
	*/
			ret := this.__isMinimized()
		}
		else if (aName = "monitorID") {
	/*! ---------------------------------------------------------------------------------------
		Property: monitorID [get]
			Returns the ID of monitor on which the window is on
	*/
			ret := this.__monitorID()
		}
		else if (aName = "pos") { ; current position
	/*! ---------------------------------------------------------------------------------------
		Property: pos [get]
			Returns the position and size of the window as a [Rectangle](Rectangle.html)-object
	*/
			ret := this.__pos()
			written := 1 ; _DBG_
			if (this._debug) ; _DBG_
				OutputDebug % "<[" A_ThisFunc "(" aName ", [" this._hWnd "])] -> " ret.dump() ; _DBG_
		}
		else if (aName = "resizeable") { 
	/*! ---------------------------------------------------------------------------------------
		Property: resizeable [get]
			Checks whether window is resizeable
	*/
			ret := this.__isResizable()
		}
		else if (aName = "rolledUp") {
			ret := this.__isRolledUp()
		}
		else if (aName = "rolledUpHeight") {
			SysGet, ret, 29
		}
		else if (aName = "style") {
			ret := this.__style()
		}
		else if (aName = "styleEx") {
			ret := this.__styleEx()
		}
		else if (aName = "title") {
			ret :=  this.__title()
		}
		
		if (this._debug) ; _DBG_
			if (!written) ; _DBG_
			OutputDebug % "<[" A_ThisFunc "(" aName ", [" this._hWnd "])] -> " ret ; _DBG_

		return ret
	}

	/*! ===============================================================================
		Method: __alwaysOnTop(mode:="toggle")
			Sets *Always-On-Top*-Mode for window
			
			**Better use property-set functionality for this: `[alwaysOnTop](#alwaysOnTop)`**
			
			*Always-On-Top* can be explicitly switched on or off using the given parameter. If the parameter is missing the *Always-On-Top* state is toggled
			
			The current *Always-On-Top* state can be retrieved via property [alwaysOnTop](#alwaysOnTop).
		Parameters:
			mode - *(Optional)* true (1),  false (0), "toggle"
		Remarks:
			### See also: 
				[alwaysOnTop](#alwaysOnTop)
			
			### Author(s)
				* 20130308 - [hoppfrosch](hoppfrosch@ahk4.me) - Original
	*/
	__alwaysOnTop(mode:="toggle") 
	{
		if (this._debug) ; _DBG_
			OutputDebug % ">[" A_ThisFunc "([" this._hWnd "], mode=" mode ")] -> CurrentState:" this.alwaysontop ; _DBG_
		foundpos := RegExMatch(mode, "i)1|0|toggle")
		if (foundpos = 0)
			mode := "toggle"

		StringLower mode,mode	
		val := this._hWnd
		mode_bak := mode
		if (mode == true)
			mode := "on"
		else if (mode == false)
			mode := "off"
		WinSet, AlwaysOnTop, %mode%,  ahk_id %val%
			
		if (this._debug) ; _DBG_
			OutputDebug % "<[" A_ThisFunc "([" this._hWnd "], mode=" mode_bak ")] -> NewState:" this.alwaysontop ; _DBG_
	}

	/*! ===============================================================================
		Method: hidden(mode="toggle")
			Sets *Hidden*-State for window
			
			*Hidden* can be explicitly switched on or off using the given parameter. If the parameter is missing the *Hidden* state is toggled.
			
			`obj.hidden(false)` is equivalent to `[obj.show()](#show)` - `obj.hidden(true)` is equivalent to `[obj.hide()](#hide)`
			
			The current *Hidden* state can be retrieved via property [hidden](#Hidden).
		Parameters:
			mode - *(Optional)* true (1),  false (0), "toggle"
		Returns:
			-
		Remarks:
			### See also: 
			[show()](#show), [hide()](#hide), [__isHidden](#__isHidden)
			
			### Author(s)
				* 20130308 - [hoppfrosch](hoppfrosch@ahk4.me) - Original
	*/
	hidden(mode="toggle") {
		if (this._debug) ; _DBG_
			OutputDebug % ">[" A_ThisFunc "([" this._hWnd "], mode=" mode ")] -> CurrentState:" this.__isHidden() ; _DBG_
		foundpos := RegExMatch(mode, "i)1|0|toggle")
		if (foundpos = 0)
			mode := "toggle"

		StringLower mode,mode

		if (mode == 1)
			this.Hide()
		else if (mode == 0)
			this.Show()
		else {
			if (this.__isHidden())
				this.show()
			else
				this.hide()
		}
		if (this._debug) ; _DBG_
			OutputDebug % "<[" A_ThisFunc "([" this._hWnd "], mode=" mode ")] -> NewState:" this.__isHidden() ; _DBG_
	}

	/*! ===============================================================================
		Method: hide()
			Hides the Window.
			
			`obj.hide()` is equivalent to `[obj.hidden(true)](#hidden)`. 
			
			Use `[obj.show()](#show)`, `[obj.hidden(false)](#hidden)` or `[obj.hidden("toggle")](#hidden)` to unhide a hidden window.

			The current *Hidden* state can be retrieved via property [hidden](#Hidden).
		Remarks:
			### See also: 
			[show()](#show), [hidden()](#hidden), [__isHidden()](#__isHidden)
			
			### Author(s)
				* 20130308 - [hoppfrosch](hoppfrosch@ahk4.me) - Original
	*/
	hide() {
		val := this._hWnd
		if (this._debug) ; _DBG_
			OutputDebug % "|[" A_ThisFunc "([" this._hWnd "])]" ; _DBG_		
		WinHide ahk_id %val%
	}

	/*! ===============================================================================
		Method: kill()
			Kills the Window (Forces the window to close)
			
			Performs the AHK command `[WinKill](http://www.autohotkey.com/docs/commands/WinKill.htm)`
			
		Remarks:
			### See also: 
			[close()](#close)
			
			### Author(s)
				* 20130308 - [hoppfrosch](hoppfrosch@ahk4.me) - Original
	*/
	kill() {
		if (this._debug) ; _DBG_
			OutputDebug % "|[" A_ThisFunc "([" this._hWnd "])]" ; _DBG_		

		prevState := A_DetectHiddenWindows
		DetectHiddenWindows, On
		WinKill % "ahk_id" this._hWnd
		DetectHiddenWindows, %prevState%
	}

	/*! ===============================================================================
		Method: maximize(mode="toggle")
			Toggles *Maximize* state of the window
			
			*Maximize* can be explicitly switched on or off using the given parameter. If the parameter is missing the *Maximize* state is toggled.
		Parameters:
			mode - *(Optional)* true (1),  false (0), "toggle"
		Remarks:
			### See also: 
			[minimize()](#minimize)
			
			### Author(s)
				* 20130415 - [hoppfrosch](hoppfrosch@ahk4.me) - Original
	*/
	maximize(mode="toggle") {
		if (this._debug) ; _DBG_
			OutputDebug % ">[" A_ThisFunc "([" this._hWnd "], mode=" mode ")] -> CurrentState:" this.maximized ; _DBG_
		foundpos := RegExMatch(mode, "i)0|1|toggle")
		if (foundpos = 0)
			mode := "toggle"
		StringLower mode,mode	
		newState := 1
		if (mode == "toggle") {
			newState := !(this.maximized)
		}
		else if (mode == 0) {
			newState := 0
		}
		
		prevState := A_DetectHiddenWindows
		DetectHiddenWindows, On
		if (newState == 1 )
			WinMaximize % "ahk_id" this._hWnd
		else 
			WinRestore % "ahk_id" this._hWnd
		DetectHiddenWindows, %prevState%
	}
	
	/*! ===============================================================================
		Method: minimize(mode="toggle")
			Toggles *Minimize* state of the window
			
			*Minimize* can be explicitly switched on or off using the given parameter. If the parameter is missing the *Minimize* state is toggled.
		Parameters:
			mode - *(Optional)* true (1),  false (0), "toggle"
		Remarks:
			### See also: 
			[maximize()](#maximize)
			
			### Author(s)
				* 20130416 - [hoppfrosch](hoppfrosch@ahk4.me) - Original
	*/
	minimize(mode="toggle") {
		if (this._debug) ; _DBG_
			OutputDebug % ">[" A_ThisFunc "([" this._hWnd "], mode=" mode ")] -> CurrentState:" this.minimized ; _DBG_
		foundpos := RegExMatch(mode, "i)1|0|toggle")
		if (foundpos = 0)
			mode := "toggle"
		StringLower mode,mode	
		newState := 1
		if (mode == "toggle") {
			newState := !(this.minimized)
		}
		else if (mode == 0) {
			newState := 0
		}
		
		prevState := A_DetectHiddenWindows
		DetectHiddenWindows, On
		if (newState == 1 )
			WinMinimize % "ahk_id" this._hWnd
		else 
			WinRestore % "ahk_id" this._hWnd
		DetectHiddenWindows, %prevState%
	}
	
	/*! ===============================================================================
		Method: move(X,Y,W=99999,H=99999)
			Moves and/or resizes the window
			
			The given coordinates/sizes are absolute coordinates/sizes. If the value of any coordinate is equal *99999* the current value keeps unchanged. For example: Resize-only can be performed by `obj.move(99999,99999,width,height)`
		Parameters:
			x - x-Coordinate (absolute) the window has to be moved to - use *99999* to preserve actual value
			y - y-Coordinate (absolute) the window has to be moved to - use *99999* to preserve actual value
			w - *(Optional)* width (absolute) the window has to be resized to - use *99999* to preserve actual value
			h - *(Optional)* height (absolute) the window has to be resized to - use *99999* to preserve actual value
		Remarks:
			### See also: 
			[movePercental()](movePercental)
			
			### Author(s)
				* 20130308 - [hoppfrosch](hoppfrosch@ahk4.me) - Original
	*/
	move(X,Y,W="99999",H="99999") {
		if (this._debug) ; _DBG_
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
		
		if (this._debug) ; _DBG_
			OutputDebug % "<[" A_ThisFunc "([" this._hWnd "])(X=" X " ,Y=" Y " ,W=" W " ,H=" H ")]" ; _DBG_		
		WinMove % "ahk_id" this._hWnd, , X, Y, W, H
	}


	/*! ===============================================================================
		Method: movePercental(xFactor=0, yFactor=0, wFactor=100, hFactor=100)
			move and resize window relative to the size of the current.
			
			For example: 
			 * `obj.movePercental(0,0,100,100)` creates a window with origin 0,0 and a *width=100% of screen width* and *height=100% of screen height*
			 * `obj.movePercental(25,25,50,50)` creates a window at *x=25% of screen width*, *y =25% of screen height*, and with *width=50% of screen width*, *height=50% of screen height*. The resulting window is a screen centered window with the described width and height
		Parameters:
			xFactor - x-position factor (percents of current screen width) the window has to be moved to (Range: 0.0 to 100.0)
			yFactor - y-position factor (percents of current screen height) the window has to be moved to (Range: 0.0 to 100.0)
			wFactor - *(Optional)* width-size factor (percents of current screen width) the window has to be resized to (Range: 0.0 to 100.0)
			hFactor - *(Optional)* height-size factor (percents of current screen height) the window has to be resized to (Range: 0.0 to 100.0)
		Remarks:
			### See also: 
			[move()](move)
			
			### Author(s)
			    * xxxxxxxx - Lexikos - [Original on AHK-Forum](http://www.autohotkey.com/forum/topic21703.html)
				* 20130402 - [hoppfrosch](hoppfrosch@ahk4.me) - Rewritten
				
			### Caveats / Known issues
			    * The range of the method parameters is **NOT** checked - so be carefull using any values <0 or >100
	*/
	movePercental(xFactor=0, yFactor=0, wFactor=100, hFactor=100) {
		
		if (this._debug) ; _DBG_
			OutputDebug % ">[" A_ThisFunc "([" this._hWnd "], xFactor=" xFactor ", yFactor=" yFactor ", wFactor=" wFactor ", hFactor=" hFactor ")]" ; _DBG_
			
		monID := this.monitorID
		mmv := new MultiMonitorEnv(_debug)
		monWorkArea := mmv.monWorkArea(monID)
		monBound := mmv.monBoundary(monID)
		xrel := monWorkArea.w * xFactor/100
		yrel := monWorkArea.h * yFactor/100
		w := monWorkArea.w * wFactor/100
		h := monWorkArea.h * hFactor/100
		
		x := monBound.x + xrel
		y := monBound.y + yrel
		
		this.move(x,y,w,h)
		
		if (this._debug) ; _DBG_
			OutputDebug % "<[" A_ThisFunc "([" this._hWnd "], xFactor=" xFactor ", yFactor=" yFactor ", wFactor=" wFactor ", hFactor=" hFactor ")] -> padded to (" this.pos.Dump() ") on Monitor (" monId ")" ; _DBG_
	}
	
	/*! ===============================================================================
		Method: rollup(mode="toggle") {
			Toggles *Rollup* state of the window. The window cann be rolled up (minimized) to its titlebar and unrolled again.
			
			*Rollup* can be explicitly switched on or off using the given parameter. If the parameter is missing the *Rollup* state is toggled.
		Parameters:
			mode - *(Optional)* true (1),  false (0), "toggle"
		Remarks:
			### Author(s)
				* 20130312 - [hoppfrosch](hoppfrosch@ahk4.me) - Original
	*/
	rollup(mode="toggle") {
		if (this._debug) ; _DBG_
			OutputDebug % ">[" A_ThisFunc "([" this._hWnd "], mode=" mode ")] -> CurrentState:" this.rolledUp ; _DBG_
		foundpos := RegExMatch(mode, "i)0|1|toggle")
		if (foundpos = 0)
			mode := "toggle"

		StringLower mode,mode

		roll := 1
		if (mode == 1) 		
			roll := 1
		else if (mode == 0) 
			if (this.rolledUp == true)
				roll := 0 ; Only rolled window can be unrolled
			else
				roll := -1 ; As window is not rolled up, you cannot unroll it as requested ....
		else {
			if (this.rolledUp == true)
				roll := 0
			else
				roll := 1
		}
		
		; Determine the minmal height of a window
		MinWinHeight := this.rolledUpHeight
		; Get size of current window
		hwnd := this._hWnd
		currPos := this.pos
	
		if (roll == 1) { ; Roll
            this.move(currPos.x, currPos.y, currPos.w, MinWinHeight)
		}
		else if (roll = 0) { ; Unroll
			this.__posRestore()			
		}
		
		if (this._debug) ; _DBG_
			OutputDebug % "<[" A_ThisFunc "([" this._hWnd "], mode=" mode ")] -> NewState:" this.rolledUp ; _DBG_

	}

	/*! ===============================================================================
		Method: show()
			Hides the Window. Used to show a hidden window.
			
			`obj.show()` is equivalent to `[obj.hidden(false)](#hidden)`. 
			
			Use `[obj.hide()](#hide)`, `[obj.hidden(true)](#hidden)` or `[obj.hidden("toggle")](#hidden)` to hide a currently shown window.
			
			The current *Hidden* state can be retrieved via property [hidden](#Hidden).
		Remarks:
			### See also: 
			[hide()](#hide), [hidden()](#hidden), [__isHidden()](#__isHidden)
			
			### Author(s)
				* 20130308 - [hoppfrosch](hoppfrosch@ahk4.me) - Original
	*/
	show() {
		val := this._hWnd
		if (this._debug) ; _DBG_
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
		centerPos := new Rectangle(x,y,0,0,this._debug)
		if (this._debug) ; _DBG_
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
		if (this._debug) ; _DBG_
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
		if (this._debug) ; _DBG_
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
		
		if (this._debug) ; _DBG_
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
		if (this._debug) ; _DBG_
			OutputDebug % "|[" A_ThisFunc "([" this._hWnd "])] -> " ret ; _DBG_		
		return ret
	}

/*
===============================================================================
Function:   __isMaximized
	Checks whether the given hWnd refers to a maximized window (*INTERNAL*)

Returns:
	true (window is a maximized window), false (window is not a maximized window)

Author(s):
	20130415 - hoppfrosch@ahk4.me - Original
===============================================================================
*/
	__isMaximized() {
		val := this._hWnd
		WinGet, s, MinMax, ahk_id %val% 
		ret := 0
		if (s == 1)
			ret := 1
			
		if (this._debug) ; _DBG_
			OutputDebug % "|[" A_ThisFunc "([" val "])] -> " ret ; _DBG_		
	
		return ret
	}

/*
===============================================================================
Function:   __isMinimized
	Checks whether the given hWnd refers to a Minimized window (*INTERNAL*)

Returns:
	true (window is a Minimized window), false (window is not a Minimized window)

Author(s):
	20130415 - hoppfrosch@ahk4.me - Original
===============================================================================
*/
	__isMinimized() {
		val := this._hWnd
		WinGet, s, MinMax, ahk_id %val% 
		ret := 0
		if (s == -1)
			ret := 1
			
		if (this._debug) ; _DBG_
			OutputDebug % "|[" A_ThisFunc "([" val "])] -> " ret ; _DBG_		
	
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
		
		if (this._debug) ; _DBG_
			OutputDebug % "|[" A_ThisFunc "([" this._hWnd "])] -> " ret ; _DBG_		
		
		return ret
}

/*
===============================================================================
Function:   __isRolledUp
	Checks whether the window is rolled up (*INTERNAL*)

Returns:
	true (window is rolled up), false (window is not rolled up) or -1 (window does not exist at all)

Author(s):
	20130312 - hoppfrosch@ahk4.me - Original
	
See also:
	<rollup>
===============================================================================
*/
	__isRolledUp() {
		ret := 0
		if !this.exist {
			; the window does not exist at all ...
			ret := -1
		}
		else {
			currPos := this.pos
			if (currPos.h <= this.rolledUpHeight) {
				ret := 1
			}
		}
		if (this._debug) ; _DBG_
			OutputDebug % "|[" A_ThisFunc "([" this._hWnd "])] -> " ret ; _DBG_		
		return ret
	}


/*
===============================================================================
Function:   __isWindow
	Checks whether the given hWnd refers to a TRUE window (As opposed to the desktop or a menu, etc.) (*INTERNAL*)

Returns:
	true (window is a true window), false (window is not a true window)

Author(s):
	20080121 - ManaUser - Original (http://www.autohotkey.com/board/topic/25393-appskeys-a-suite-of-simple-utility-hotkeys/)
===============================================================================
*/
	__isWindow(hWnd) {
		WinGet, s, Style, ahk_id %hWnd% 
		ret := s & 0xC00000 ? (s & 0x80000000 ? 0 : 1) : 0  ;WS_CAPTION AND !WS_POPUP(for tooltips etc) 
			
		if (this._debug) ; _DBG_
			OutputDebug % "|[" A_ThisFunc "([" hWnd "])] -> " ret ; _DBG_		
	
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
		mme := new MultiMonitorEnv(this._debug)
		mon := mme.monGetFromCoord(c.x,c.y,default)
		if (this._debug) ; _DBG_
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
		currPos := new Rectangle(0,0,0,0,this._debug)
		currPos.fromHWnd(this._hWnd)
		if (this._debug) ; _DBG_
			OutputDebug % "<[" A_ThisFunc "([" this._hWnd "])] -> (" currPos.dump() ")" ; _DBG_
		return currPos
	}

/*
===============================================================================
Function: __posPush
	Pushes current position of the window on position stack (*INTERNAL*)

Author(s):
	20130311 - hoppfrosch@ahk4.me - Original
===============================================================================
*/
	__posPush() {
		this._posStack.Insert(1, this.pos)
		if (this._debug) { ; _DBG_ 
			this.__posStackDump() ; _DBG_ 
			OutputDebug % "<[" A_ThisFunc "([" this._hWnd "])] -> (" this._posStack[1].dump() ")" ; _DBG_
		}
	}

/*
===============================================================================
Function: __posStackDump
	Dumps the current position stack via OutputDebug (*INTERNAL*)

Author(s):
	20130312 - hoppfrosch@ahk4.me - Original
===============================================================================
*/	
	__posStackDump() {
		For key,value in this._posStack	; loops through all elements in Stack
		
			OutputDebug % "|[" A_ThisFunc "()] -> (" key "): (" Value.dump() ")" ; _DBG_
		return
	}
	
/*
===============================================================================
Function: __posRestore
	Restores position of the window  from Stack(*INTERNAL*)

Parameters:
	index - Index of position to restore (Default = 2) (1 is the current position)

Author(s):
	20130308 - hoppfrosch@ahk4.me - Original
===============================================================================
*/
	__posRestore(index="2") {
		if (this._debug) ; _DBG_
			OutputDebug % ">[" A_ThisFunc "([" this._hWnd "], index=" index ")]" ; _DBG_
		restorePos := this._posStack[index]
		currPos := this.pos
		
		this.__posStackDump()
		
		this.move(restorePos.x, restorePos.y, restorePos.w, restorePos.h)
		if (this._debug) ; _DBG_
			OutputDebug % "<[" A_ThisFunc "([" this._hWnd "])] LastPos: " currPos.Dump() " - RestoredPos: " restorePos.Dump() ; _DBG_
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
		if (this._debug) ; _DBG_
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
		if (this._debug) ; _DBG_
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
		if (this._debug) ; _DBG_
			OutputDebug % "|[" A_ThisFunc "([" this._hWnd "]) -> (" title ")]" ; _DBG_		
		return title
	}

/*
===============================================================================
Function: __debug
	Set or get the _debug flag (*INTERNAL*)

Parameters:
	value - Value to set the _debug flag to (OPTIONAL)

Returns:
	true or false, depending on current value

Author(s):
	20130308 - hoppfrosch@ahk4.me - Original
===============================================================================
*/  
	__debug(value="") { ; _DBG_
		if % (value="") ; _DBG_
			return this._debug ; _DBG_
		value := value<1?0:1 ; _DBG_
		this._debug := value ; _DBG_
		return this._debug ; _DBG_
	} ; _DBG_

/*
===============================================================================
Function: __SetWinEventHook
	Set the hook for certain win-events (*INTERNAL*)

Parameters:
	see siehe http://msdn.microsoft.com/en-us/library/windows/desktop/dd373885(v=vs.85).aspx

Returns:
	true or false, depending on result of dllcall

Author(s):
	20130311 - hoppfrosch@ahk4.me - Original
===============================================================================
*/  
	__SetWinEventHook(eventMin, eventMax, hmodWinEventProc, lpfnWinEventProc, idProcess, idThread, dwFlags) {
		if (this._debug) ; _DBG_ 
			OutputDebug % "|[" A_ThisFunc "([" this._hWnd "])(eventMin=" eventMin ", eventMax=" eventMax ", hmodWinEventProc=" hmodWinEventProc ", lpfnWinEventProc=" lpfnWinEventProc ", idProcess=" idProcess ", idThread=" idThread ", dwFlags=" dwFlags ")"  ; _DBG_
		
		ret := DllCall("ole32\CoInitialize", Uint, 0)
		; This is a WinEventProc (siehe http://msdn.microsoft.com/en-us/library/windows/desktop/dd373885(v=vs.85).aspx) - this determines parameters which can be handled by "HookProc"
		ret := DllCall("user32\SetWinEventHook"
			, Uint,eventMin   
			, Uint,eventMax   
			, Uint,hmodWinEventProc
			, Uint,lpfnWinEventProc
			, Uint,idProcess
			, Uint,idThread
			, Uint,dwFlags)   
		return ret
	}
	
	/*
===============================================================================
Function:   __onLocationChange
	Callback on Object-Event <CONST_EVENT.OBJECT.LOCATIONCHANGE> or on <CONST_EVENT.SYSTEM.MOVESIZEEND>
	
	Store windows size/pos on each change

Author(s):
	20130312 - hoppfrosch@ahk4.me - AutoHotkey-Implementation
===============================================================================
*/
	__onLocationChange() {
		if this._hWnd = 0
			return
		
		if (this._debug) ; _DBG_
			OutputDebug % ">[" A_ThisFunc "([" this._hWnd "])" ; _DBG_
		
		currPos := this.pos
		lastPos := this._posStack[1]
		
		; current size/position is identical with previous Size/position
		if (currPos.equal(lastPos)) {
			OutputDebug % "<[" A_ThisFunc "([" this._hWnd "])] Position has NOT changed!" ; _DBG_
			return
		}
		
		; size/position has been changed -> store it!
		this.__posPush()
				
		if (this._debug) ; _DBG_
			OutputDebug % "<[" A_ThisFunc "([" this._hWnd "])] LastPos: " lastPos.Dump() " - NewPos: " currPos.Dump() ; _DBG_
		return
	}

 
/*
===============================================================================
Function: __Delete
	Destructor (*INTERNAL*)

Author(s):
	20130308 - hoppfrosch@ahk4.me - Original
===============================================================================
*/     
	__Delete() {
		if (this._hwnd <= 0) {
			return
		}
		
		if (this._debug) ; _DBG_
				OutputDebug % "|[" A_ThisFunc "([" this._hWnd "])"  ; _DBG_
			
		
		if (this.__hWinEventHook1)
			DllCall( "user32\UnhookWinEvent", Uint,this._hWinEventHook1 )
		if (this.__hWinEventHook2)
			DllCall( "user32\UnhookWinEvent", Uint,this._hWinEventHook2 )
		if (this._HookProcAdr)
			DllCall( "kernel32\GlobalFree", UInt,&this._HookProcAdr ) ; free up allocated memory for RegisterCallback
		if (this._debug) ; _DBG_
			OutputDebug % "|[" A_ThisFunc "([" this._hWnd "])"  ; _DBG_
			
		; Reset all "dangerous" settings (all windows should be left in a user accessable state)
		if (this.alwaysontop == true) {
			this.alwaysOnTop(false)
		}
		if (this.__isHidden() == 1) {
			this.show()
		}
			
		ObjRelease(&this)
	}

/*
===============================================================================
Function: __New
	Constructor (*INTERNAL*)

Parameters:
	hWnd - Window handle (*Obligatory*). If hWnd=0 a test window is created ...
	_debug - Flag to enable debugging (Optional - Default: 0)

Returns:
	true or false, depending on current value

Author(s):
	20130308 - hoppfrosch@ahk4.me - Original
===============================================================================
*/     
	__New(_hWnd=-1, _debug=0, _test=0) {
		this._debug := _debug
		if (this._debug) ; _DBG_
			OutputDebug % ">[" A_ThisFunc "(hWnd=(" _hWnd "))] (version: " this._version ")" ; _DBG_

		if % (A_AhkVersion < "1.1.08.00" || A_AhkVersion >= "2.0") {
			MsgBox 16, Error, %A_ThisFunc% :`n This class is only tested with AHK_L later than 1.1.08.00 (and before 2.0)`nAborting...
			if (this._debug) ; _DBG_
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
			if (this._debug) ; _DBG_
				OutputDebug % "<[" A_ThisFunc "(...) -> ()] *ERROR*: Required parameter is missing. Aborting..." ; _DBG_
			this._hWnd := -1
			return
		}
		
		if (!this.__isWindow(_hWnd)) {
			if (this._debug) ; _DBG_
				OutputDebug % ">[" A_ThisFunc "(hWnd=(" _hWnd "))] is NOT a true window. Aborting..." ; _DBG_
			this._hWnd := -1
			return
		}
		
		this._hWnd := _hWnd
		if (this._debug) ; _DBG_
			OutputDebug % ">[" A_ThisFunc "(hWnd=(" _hWnd "))] (WinTitle: " this.title ")" ; _DBG_
				
		this._posStack := Object() ; creates initially empty stack
		
		; initially store the position to detect movement of window and allow window restoring
		this.__posPush()
		
		; Registering global callback and storing adress (&this) within A_EventInfo
		ObjAddRef(&this)
		this._HookProcAdr := RegisterCallback("ClassWindowHandler_EventHook", "", "", &this)
		; Setting Callback on Adress <_HookProcAdr> on appearance of any event out of certain range
		this._hWinEventHook1 := this.__SetWinEventHook( CONST_EVENT.SYSTEM.SOUND, CONST_EVENT.SYSTEM.DESKTOPSWITCH, 0, this._HookProcAdr, 0, 0, 0 )	
		this._hWinEventHook2 := this.__SetWinEventHook( CONST_EVENT.OBJECT.SHOW, CONST_EVENT.OBJECT.CONTENTSCROLLED, 0, this._HookProcAdr, 0, 0, 0 )	
		
		if (this._debug) ; _DBG_
			OutputDebug % "<[" A_ThisFunc "(hWnd=(" _hWnd "))]" ; _DBG_
		
		
		return this
	}
	
}

/*!
	End of class
*/

/*
===============================================================================
Function:   ClassWindowHandler_EventHook
	Callback on System Events. Used as dispatcher to detect window manipulation and calling the appropriate member-function within class <WindowHandler>
	
Author(s):
	20120629 - hoppfrosch - Original

See also:
	http://www.autohotkey.com/community/viewtopic.php?t=35659
	http://www.autohotkey.com/community/viewtopic.php?f=1&t=88156
===============================================================================
*/
ClassWindowHandler_EventHook(hWinEventHook, Event, hWnd, idObject, idChild, dwEventThread, dwmsEventTime ) {
	; ClassWindowHandler_EventHook is used as WindowsEventHook - it's registered as callback within <__SetWinEventHook> of class <WindowHandler>.
	; ClassWindowHandler_EventHook is a WinEventProc (see http://msdn.microsoft.com/en-us/library/windows/desktop/dd373885(v=vs.85).aspx) and has those Parameter ...	

	; This function is called on the registered event(s) on every window - regardless whether it's an object instance or not
	; We have to check whether the current call refers to the current instance of the class WindowHandler
	; HINT: A_EventInfo currently holds the address of the current WindowsHandler object instance (set during RegisterCallback ... see <__New>)
	
	; Don't handle any windows, that are not class instances ...
	if (hWnd != Object(A_EventInfo)._hWnd)
		return
	self := Object(A_EventInfo)

	if (Object(A_EventInfo)._debug) ; _DBG_
		OutputDebug % ">[" A_ThisFunc "([" Object(A_EventInfo)._hWnd "])(hWinEventHook=" hWinEventHook ", Event=" Event2Str(Event) ", hWnd=" hWnd ", idObject=" idObject ", idChild=" idChild ", dwEventThread=" dwEventThread ", dwmsEventTime=" dwmsEventTime ") -> A_EventInfo: " A_EventInfo ; _DBG_
	
	; ########## START: Handling window movement ##################################################
	; We want to detect when the window movement has finished finally, as onLocationChanged() has only to be called at the END of the movement
	;
	; It has to be detected whether the location change was initiated by user dragging/rezizing ("manual movement") or any other window event ("non-manual movement").
	; * Manual movement triggers the following sequence: CONST_EVENT.SYSTEM.MOVESIZESTART - N times CONST_EVENT.OBJECT.LOCATIONCHANGE - CONST_EVENT.SYSTEM.MOVESIZEEND
	; * Non-manual movement by for example AHK WinMove only triggers: 1 time CONST_EVENT.OBJECT.LOCATIONCHANGE
	
	; +++ MANUAL MOVEMENT
	; The window is moved manually - as the movement isn't finished, don't call callback. Just store that we are in middle of manual movement
	if (Event == CONST_EVENT.SYSTEM.MOVESIZESTART) {
		Object(A_EventInfo)._bManualMovement := true
		return
	}
	; Manual movement has finished - trigger onLocationChange callback now
	if (Event == CONST_EVENT.SYSTEM.MOVESIZEEND) {
		Object(A_EventInfo)._bManualMovement := false
		Object(A_EventInfo).__onLocationChange()
		return
	}
	
	; +++ NON-MANUAL MOVEMENT
	; OutputDebug % "|[" A_ThisFunc "([" Object(A_EventInfo)._hWnd "])] -> Manual Movement " Object(A_EventInfo)._bManualMovement
	
	if (Event == CONST_EVENT.OBJECT.LOCATIONCHANGE) {
		if (Object(A_EventInfo)._bManualMovement == false) {
			; As its no manual movement, trigger onLocationChange callback now
			Object(A_EventInfo).__onLocationChange()
			return
		}
	}
	; ########## END: Handling window movement ####################################################
	return
}
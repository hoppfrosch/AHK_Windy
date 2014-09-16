; ****** HINT: Documentation can be extracted to HTML using GenDocs (https://github.com/fincs/GenDocs) by fincs
; ****** HINT: Debug-lines should contain "; _DBG_" at the end of lines - using this, the debug lines could be automatically removed through scripts before releasing the sourcecode


#include <EDE\Rectangle>
#include <EDE\Point>
#include <EDE\MultiMonitorEnv>
#include <EDE\_WindowHandlerEvent>

; ******************************************************************************************************************************************
/*!
	Class: WindowHandler
		Perform actions on windows using an unified class based interface
		
	Extra:
		### License
			This program is free software. It comes without any warranty, to the extent permitted by applicable law. You can redistribute it and/or modify it under the terms of the Do What The Fuck You Want To Public License, Version 2, as published by Sam Hocevar. See [WTFPL](http://www.wtfpl.net/) for more details.

	Remarks:
		### Author
			[hoppfrosch](hoppfrosch@gmx.de)
*/
class WindowHandler {
	
	_version := "0.6.0"
	_debug := 0
	_hWnd := 0

	__useEventHook := 1
	_hWinEventHook1 := 0
	_hWinEventHook2 := 0
	_HookProcAdr := 0
		
	_bManualMovement := false

	_posStack := 0

	; ##################### Start of Properties (AHK >1.1.16.x) ############################################################
	alwaysOnTop {
		/*! ---------------------------------------------------------------------------------------
			Property: alwaysOnTop [get/set]
			Get or Set the *alwaysontop*-Property.  Set/Unset alwaysontop flag of the current window or get the current state
			
			Value:
			flag - `true` or `false` (activates/deactivates *alwaysontop*-Property)
	
			Remarks:		
			* To toogle current *alwaysontop*-Property, simply use `obj.alwaysontop := !obj.alwaysontop`
		*/
		get {
			ret := (this.styleEx & 0x08) ; WS_EX_TOPMOST
			ret := ret>0?1:0
		
			if (this._debug) ; _DBG_
				OutputDebug % "|[" A_ThisFunc "([" this._hWnd "])] -> " ret ; _DBG_
			return ret
		}
		
		set {
			if (this._debug) ; _DBG_
				OutputDebug % ">[" A_ThisFunc "([" this._hWnd "], value=" value ")] -> Current Value:" this.alwaysontop ; _DBG_
		
			hwnd := this._hWnd
			if (value == true)
				value := "on"
			else if (value == false) 
				value := "off"

			WinSet, AlwaysOnTop, %value%,  ahk_id %hwnd%
				
			if (this._debug) ; _DBG_
				OutputDebug % "<[" A_ThisFunc "([" this._hWnd "], value=" value ")] -> New Value:" this.alwaysontop ; _DBG_
		
			return this.alwaysOnTop
		}
	}

	centercoords {
		/*! ---------------------------------------------------------------------------------------
			Property: centercoords [get7SET]
			Coordinates of the center of the window as a [Point](Point.html)-object
		*/

		get {
			pos := this.Pos
			x := Round((pos.w)/2 + pos.x)
			y := Round((pos.h)/2 + pos.y)
			centerPos := new Point(x,y,this._debug)
			if (this._debug) ; _DBG_
				OutputDebug % "<[" A_ThisFunc "(pos="pos.dump() " [" this._hWnd "])] -> " centerPos.dump() ; _DBG_
			return centerPos
		}

		set {
			currCenter := this.centercoords
			currPos := this.pos
		
			xoffset := value.x - currCenter.x
			yoffset := value.y - currCenter.y
		
			x := currPos.x + xoffset
			y := currPos.y + yoffset
		
			this.move(x,y,99999,99999)
			centerPos := this.centercoords
			if (this._debug) ; _DBG_
				OutputDebug % "|[" A_ThisFunc "(pos=" value.dump() " [" this._hWnd "])] -> " centerPos.dump() ; _DBG_
			return centerPos
		}
	}

	classname {
	/*! ---------------------------------------------------------------------------------------
		Property: classname [get]
		name of the window class. 

		Remarks:
		There is no setter available, since this is a constant window property
	*/
		get {
			val := this._hWnd
			WinGetClass, __classname, ahk_id %val%
			if (this._debug) ; _DBG_
				OutputDebug % "|[" A_ThisFunc "([" this._hWnd "]) -> (" __classname ")]" ; _DBG_		
			return __classname
		}
	}
	
	debug {
	/*! ---------------------------------------------------------------------------------------
		Property: debug [get/set]
			Debug flag
	*/
		get {
			return this._debug                                                         ; _DBG_
		}
		set {
			mode := value<1?0:1                                                        ; _DBG_
			this._debug := mode                                                        ; _DBG_
			return this._debug                                                         ; _DBG_
		}
	}

	exist {
	/*! ---------------------------------------------------------------------------------------
	Property: exist [get]
	Checks whether the window still exists. 

	Remarks:
	There is no setter available, since this is a constant window property
	*/
		get {
			val := this._hWnd
			_hWnd := WinExist("ahk_id " val)
			ret := true
			if (_hWnd = 0)
				ret := false
			if (this._debug) ; _DBG_
				OutputDebug % "|[" A_ThisFunc "([" this._hWnd "])] -> " ret ; _DBG_		
			return ret
		}
	}

	; ##################### End of Properties (AHK >1.1.16.x) ##############################################################
	
    ; ###################### Helper functions for properties (Getter/Setter implementation) ############################
	__Set(aName, aValue) {
/* ===============================================================================
	Method: __Set(aName, aValue)
		Custom Setter (*INTERNAL*)
*/   
		if (aName == "hidden") {
			return this.__setHidden(aValue)
		}
		else if (aName == "maximized") {
			return this.__setMaximized(aValue)
		}
		else if (aName == "minimized") {
			return this.__setMinimized(aValue)
		}
		else if (aName == "monitorID") {
			return this.__setMonitorID(aValue)
		}
		else if (aName == "rolledUp") {
			return this.__setRolledUp(aValue)
		}
		else if (aName == "pos") {
			return this.__setPos(aValue)
		}
		else if (aName == "title") {
			return this.__setTitle(aValue)
		}
		else if (aName == "transparency") {
			return this.__setTransparency(aValue)
		}
	}
	__Get(aName) {
/* ===============================================================================
	Method: __Get(aName)
		Custom Getter (*INTERNAL*)
*/   
		written := 0 ; _DBG_
	
    	if (aName = "hidden") {
/*! ---------------------------------------------------------------------------------------
	Property: hidden [get/set]
		Get or Set the *hidden*-Property. Hides/Unhide the current window or get the current state of hiding
	Value:
		flag - `true` or `false` (activates/deactivates *hidden*-Property)
	Remarks:		
		* To toogle current *hidden*-Property, simply use `obj.hidden := !obj.hidden`	
*/
			return this.__getHidden()
		}
		else if (aName = "maximized") {
/*! ---------------------------------------------------------------------------------------
	Property: maximized [get/set]
		Get or Set the *maximized*-Property. Maximizes/Demaximizes the current window or get the current state of maximization
	Value:
		flag - `true` or `false` (activates/deactivates *maximized*-Property)
	Remarks:		
		* To toogle current *maximized*-Property, simply use `obj.maximized := !obj.maximized`	
*/
			return this.__getMaximized()
		}
		else if (aName = "minimized") {
/*! ---------------------------------------------------------------------------------------
	Property: minimized [get/set]
		Get or Set the *minimized*-Property. Minimizes/Deminimizes the current window or get the current state of minimization
	Value:
		flag - `true` or `false` (activates/deactivates *minimized*-Property)
	Remarks:		
		* To toogle current *minimized*-Property, simply use `obj.minimized := !obj.minimized`	
*/
			return this.__getMinimized()
		}
		else if (aName = "monitorID") {
/*! ---------------------------------------------------------------------------------------
	Property: monitorID [get/set]
		Get or Set the ID of monitor on which the window is on. Setting the property moves the window to the corresponding monitor, trying to place the window at the same (scaled) position
	Value:
		ID - Monitor-ID (if ID > max(ID) then ID = max(ID) will be used)
	Remarks
		* Setting the property moves the window to the corresponding monitor, retaining the (relative) position and size of the window
*/
			return this.__getMonitorID()
		}
		else if (aName = "pos") { ; current position
/*! ---------------------------------------------------------------------------------------
	Property: pos [get/set]
		Get or Set the position and size of the window (To set the position use class [Rectangle](rectangle.html))	
	Example:
		`obj.pos := new [Rectangle](rectangle.html)(xnew, ynew, wnew, hnew)`	
	Extra:
		### Author(s)
			* 20130429 - [hoppfrosch](hoppfrosch@gmx.de) - Original
*/
			return this.__getPos()
		}
		else if (aName = "processID") {
/*! ---------------------------------------------------------------------------------------
	Property: processID [get]
		Get the ID of the process the window belongs to
	Remarks:		
		There is no setter available, since this cannot be modified
*/
			if (this._debug) ; _DBG_
				OutputDebug % "|[" A_ThisFunc "([" this._hWnd "])]" ; _DBG_
			return this.__getProcessID()
		}
		else if (aName = "processname") {
/*! ---------------------------------------------------------------------------------------
	Property: processname [get]
		Get the Name of the process the window belongs to
	Remarks:		
		There is no setter available, since this cannot be modified
*/
			if (this._debug) ; _DBG_
				OutputDebug % "|[" A_ThisFunc "([" this._hWnd "])]" ; _DBG_
			return this.__getProcessname()
		}
		else if (aName = "resizeable") { 
/*! ---------------------------------------------------------------------------------------
	Property: resizeable [get]
		Checks whether window is resizeable
	
		**ToBeDone: Implementation of Setter-functionality**
*/
			return this.__isResizable()
		}
		else if (aName = "rolledUp") {
/*! ---------------------------------------------------------------------------------------
	Property: rolledUp [get/set]
		Get or Set the *RolledUp*-Property (window is rolled up to its title bar).  Rolls/De-Rolls the current window or get the current state of RollUp
	Value:
		flag - `true` or `false` (activates/deactivates *rolledUp*-Property)
	Remarks:		
		* To toogle current *rolledUp*-Property, simply use `objrolledUp := !obj.rolledUp`
*/
			return this.__getRolledUp()
		}
		else if (aName = "rolledUpHeight") {
/*! ---------------------------------------------------------------------------------------
	Property: rolledUpHeight [get]
		Returns the height of the caption bar of windows
	Remarks:
    	There is no setter available, since this is a system constant
*/
			SysGet, ret, 29
			return ret
		}
		else if (aName = "style") {
/*! ---------------------------------------------------------------------------------------
	Property: style [get]
		Returns current window style
	
    	**ToBeDone: Implementation of Setter-functionality**
*/
			return this.__style()
		}
		else if (aName = "styleEx") {
/*! ---------------------------------------------------------------------------------------
	Property: styleEx [get]
		Returns current window extended style
		
		**ToBeDone: Implementation of Setter-functionality**
*/
			return this.__styleEx()
		}
		else if (aName = "transparency") {
/*! ---------------------------------------------------------------------------------------
	Property: transparency [get/set]
		Get or Set the transparency of the window
			
		**ToBeDone: Implementation of Setter-functionality**
*/
			return this.__getTransparency()
		}
		else if (aName = "title") {
/*! ---------------------------------------------------------------------------------------
	Property: title [get/set]
		Get/Set current window title. 
	Value:
		title - Window Title to be set
	Remarks:		
		* A change to a window's title might be merely temporary if the application that owns the window frequently changes the title.
*/
			return this.__getTitle()
		}
		/*
		if (this._debug) ; _DBG_
			if (!written) ; _DBG_
			OutputDebug % "<[" A_ThisFunc "(" aName ", [" this._hWnd "])] -> " ret ; _DBG_
        */
	}
	
	__getHidden() {
/* ===============================================================================
	Method:   __getHidden
		Get the hidden-attribute of window (*INTERNAL*)
	Returns:
		true (window is hidden), false (window is visible) or -1 (window does not exist at all)
*/
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
	__setHidden(mode) {
/* ===============================================================================
	Method: __setHidden(mode="1")
		Sets *Hidden*-Property for window
	Parameters:
		mode - * true (1),  false (0)
*/
		if (this._debug) ; _DBG_
			OutputDebug % ">[" A_ThisFunc "([" this._hWnd "], mode=" mode ")] -> Current Value:" this.hidden ; _DBG_

		val := this._hWnd
		ret := 0
		if (mode == true) {
			WinHide ahk_id %val%
			ret := 1
		}
		else if (mode == false) {
			WinShow ahk_id %val%
			ret := 0
		}
		
		isHidden := this.hidden
		if (this._debug) ; _DBG_
			OutputDebug % "<[" A_ThisFunc "([" this._hWnd "], mode=" mode ")] -> New Value:" isHidden ; _DBG_
		
		return isHidden
	}
	__getMaximized() { 
/* ===============================================================================
	Method:  __getMaximized
		Checks whether the given hWnd refers to a maximized window (*INTERNAL*)
	Returns:
		true (window is a maximized window), false (window is not a maximized window)
*/
		val := this._hWnd
		WinGet, s, MinMax, ahk_id %val% 
		ret := 0
		if (s == 1)
			ret := 1	
		return ret
	}
	
	__setMaximized(mode) {
/* ===============================================================================
	Method: __setMaximized(mode)
		Sets *maximized* Property of the window (*INTERNAL *)
	Parameters:
		mode - *(Optional)* true (1),  false (0)
*/
		newState := 1
		if (mode == 0) {
			newState := 0
		}
		
		prevState := A_DetectHiddenWindows
		DetectHiddenWindows, On
		if (newState == 1 )
			WinMaximize % "ahk_id" this._hWnd
		else 
			WinRestore % "ahk_id" this._hWnd
		DetectHiddenWindows, %prevState%
		
		isMax := this.maximized
		if (this._debug) ; _DBG_
			OutputDebug % "|[" A_ThisFunc "([" this._hWnd "], mode=" mode ")] -> New Value:" isMax ; _DBG_
		
		return isMax
	}
	__getMinimized() {
/* ===============================================================================
	Method:   __getMinimized
		Checks whether the given hWnd refers to a Minimized window (*INTERNAL*)
	Returns:
		true (window is a Minimized window), false (window is not a Minimized window)
*/
		val := this._hWnd
		WinGet, s, MinMax, ahk_id %val% 
		ret := 0
		if (s == -1)
			ret := 1	
		return ret
	}
	__setMinimized(mode) {
/* ===============================================================================
	Method: __setMinimized(mode)
		Sets *Minimized* Property of the window (*INTERNAL*)
	Parameters:
		mode - true (1),  false (0)
*/
		newState := 1
		if (mode == 0) {
			newState := 0
		}
		
		prevState := A_DetectHiddenWindows
		DetectHiddenWindows, On
		if (newState == 1 )
			WinMinimize % "ahk_id" this._hWnd
		else 
			WinRestore % "ahk_id" this._hWnd
		DetectHiddenWindows, %prevState%

		isMin := this.minimized
		if (this._debug) ; _DBG_
			OutputDebug % "<[" A_ThisFunc "([" this._hWnd "], mode=" mode ")] -> New Value:" isMin ; _DBG_

		return isMin
	}
	__getMonitorID() {
/* ===============================================================================
	Method:  __getMonitorID
		Determines ID of monitor the window currently is on (i.e center of window) (*INTERNAL*)
	Returns:
		MonitorID
*/
		mon := 1
		c := this.centercoords
		mme := new MultiMonitorEnv(this._debug)
		mon := mme.monGetFromCoord(c.x,c.y,mon)
		if (this._debug) ; _DBG_
			OutputDebug % "|[" A_ThisFunc "([" this._hWnd "])] -> " mon ; _DBG_		
		return mon
	}
	__setMonitorID(newID) {
/* ===============================================================================
	Method: __setMonitorID(newID)
		Moves the window to the given Monitor (*INTERNAL)
	Parameters:
		newID - Monitor-ID
*/
		obj := new MultiMonitorEnv(this._debug)
		
		realID := newID
		if (realID > obj.monCount()) {
			realID := obj.monCount()
		}
		if (realID < 1) {
			realID := 1
		}
		newMon := obj.monBoundary(realID)
		
		oldID := this.monitorID
		oldMon := obj.monBoundary(oldID)
		
		oldPos := this.pos
		xnew := newMon.x+(oldPos.x - oldMon.x)
		ynew := newMon.y+(oldPos.y - oldMon.y)
		this.Move(xnew,ynew)
		monID := this.monitorID
		if (this._debug) ; _DBG_
			OutputDebug % "<[" A_ThisFunc "([" this._hWnd "], ID=" newID ")] -> New Value:" monID " (from: " oldID ")" ; _DBG_

		return monID
	}
	__getPos() {
/* ===============================================================================
	Method: __getPos
		Determine current position of the window (*INTERNAL*)
	Returns:
		<Rectangle> - Rectangle containing the current position and size of the window
*/
		currPos := new Rectangle(0,0,0,0,this._debug)
		currPos.fromHWnd(this._hWnd)
		if (this._debug) ; _DBG_
			OutputDebug % "<[" A_ThisFunc "([" this._hWnd "])] -> (" currPos.dump() ")" ; _DBG_
		return currPos
	}
	__setPos(rect) {
/* ===============================================================================
	Method: __setPos(rect) {
		Sets *position* (x,y,w,h) the window. (*INTERNAL*)
	Parameters:
		<Rectangle> - Rectangle containing the new position and size of the window
*/
		this.move(rect.x, rect.y, rect.w, rect.h)
		newPos := this.pos
		
		if (this._debug) ; _DBG_
			OutputDebug % "<[" A_ThisFunc "([" this._hWnd "], pos=" newPos.Dump()")] -> New Value:" newPos.Dump() ; _DBG_

		return newPos
	}
	__getProcessID() {
/* ===============================================================================
	Method:   __getProcessID
		Gets the process-ID of the process the window belongs to (*INTERNAL*)
	Returns:
		processID or empty string (if window does not exist)
*/
		ret := ""
		if this.exist {
			WinGet, PID, PID, % "ahk_id " this._hWnd
			ret := PID
		}
		if (this._debug) ; _DBG_
			OutputDebug % "|[" A_ThisFunc "([" this._hWnd "])] -> " ret ; _DBG_		
		return ret
	}
	__getProcessname() {
/* ===============================================================================
	Method:   __getProcessname
		Gets the processname of the process the window belongs to (*INTERNAL*)
	Returns:
		processname or empty string (if window does not exist)
*/
		ret := ""
		if this.exist {
			WinGet, PName, ProcessName, % "ahk_id " this._hWnd
			ret := PName
		}
		if (this._debug) ; _DBG_
			OutputDebug % "|[" A_ThisFunc "([" this._hWnd "])] -> " ret ; _DBG_		
		return ret
	}
	__getRolledUp() {
/* ===============================================================================
	Method:   __getRolledUp
		Checks whether the window is rolled up (*INTERNAL*)
	Returns:
		true (window is rolled up), false (window is not rolled up) or -1 (window does not exist at all)
*/
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
	__setRolledUp(mode) {
/* ===============================================================================
	Method: __setRolledUp(mode) {
		Sets *rollup* Property of the window. The window cann be rolled up (minimized) to its titlebar and unrolled again.
	Parameters:
		mode - true (1),  false (0)
*/
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
		
		isRolled := this.rolledUp
		if (this._debug) ; _DBG_
			OutputDebug % "<[" A_ThisFunc "([" this._hWnd "], mode=" mode ")] -> New Value:" isRolled ; _DBG_

		return isRolled
	}
	__getTitle()	{
/* ===============================================================================
	Method:   __getTitle
		Determines the Window title (*INTERNAL*)
	Returns:
		WindowTitle
*/
		val := this._hWnd
		WinGetTitle, title, ahk_id %val%
		if (this._debug) ; _DBG_
			OutputDebug % "|[" A_ThisFunc "([" this._hWnd "]) -> (" title ")]" ; _DBG_		
		return title
	}
	__setTitle(title) {
/* ===============================================================================
	Method: __setTitle(title)
		Sets the title of the window (*INTERNAL*)
	Parameters:
		title - title to be set
*/	
		val := this._hWnd
		prevState := A_DetectHiddenWindows
		DetectHiddenWindows, On
		WinSetTitle, ahk_id %val%,, %title%
		DetectHiddenWindows, %prevState%
		newTitle := this.title
		if (this._debug) ; _DBG_
			OutputDebug % "|[" A_ThisFunc "([" this._hWnd "], title=" title ")] -> " newTitle ; _DBG_		
		return newTitle
	}
	__getTransparency() {
/* ===============================================================================
	Method:   __getTransparency
		Gets the transparency setting of the given hWnd 
	Returns:
		transparency
*/
		val := this._hWnd
		WinGet, s, Transparent, ahk_id %val% 
		ret := 255
		if (s != "")
			ret := s
		
		if (this._debug) ; _DBG_
			OutputDebug % "|[" A_ThisFunc "([" this._hWnd "])] -> " ret ; _DBG_
		return ret
	}	
	__setTransparency(transparency) {
/* ===============================================================================
	Method: __setTransparency(transparency)
		Sets the transparency of the window (*INTERNAL*)
	Parameters:
		transparency - transparency to be set (0 (Full Tranyparency) - 255 (No Transparency) OR "OFF")
*/		
		val := this._hWnd

		transOrig := transparency
		if (transparency == "OFF")
			transparency := 255
	
		WinSet, Transparent, %transparency%, ahk_id %val% 
		
		trans := this.transparency
		if (this._debug) ; _DBG_
			OutputDebug % "<[" A_ThisFunc "([" this._hWnd "], transparency=" transOrig "(" transparency "))] -> New Value:" trans ; _DBG_
		
		return trans
	}
	
	; ######################## Methods to be called directly ########################################################### 
	kill() {
/*! ===============================================================================
	Method: kill()
		Kills the Window (Forces the window to close)
			
		Performs the AHK command `[WinKill](http://www.autohotkey.com/docs/commands/WinKill.htm)`
			
	Remarks:
		### See also: 
			[close()](#close)
*/
		if (this._debug) ; _DBG_
			OutputDebug % "|[" A_ThisFunc "([" this._hWnd "])]" ; _DBG_		

		prevState := A_DetectHiddenWindows
		DetectHiddenWindows, On
		WinKill % "ahk_id" this._hWnd
		DetectHiddenWindows, %prevState%
	}	
	move(X,Y,W="99999",H="99999") {
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
*/
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
	movePercental(xFactor=0, yFactor=0, wFactor=100, hFactor=100) {
/*! ===============================================================================
	Method: movePercental(xFactor=0, yFactor=0, wFactor=100, hFactor=100)
		move and resize window relative to the size of the current screen.
			
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
			* 20130402 - [hoppfrosch](hoppfrosch@gmx.de) - Rewritten
			
		### Caveats / Known issues
		    * The range of the method parameters is **NOT** checked - so be carefull using any values <0 or >100
*/	
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
	
	; ######################## Internal Methods - not to be called directly ############################################
	__isResizable() {
/* ===============================================================================
Method:   __isResizable
    Determine whether window can be resized by user (*INTERNAL*)

Returns:
    True or False
     
Author(s):
    20130308 - hoppfrosch@gmx.de - Original
*/
		ret := true
		if this.__classname in Chrome_XPFrame,MozillaUIWindowClass
			ret := true
		else 
		    ret := (this.style & 0x40000) ; WS_SIZEBOX
		
		if (this._debug) ; _DBG_
			OutputDebug % "|[" A_ThisFunc "([" this._hWnd "])] -> " ret ; _DBG_		
		
		return ret
}
	__isWindow(hWnd) {
/* ===============================================================================
Method:   __isWindow
	Checks whether the given hWnd refers to a TRUE window (As opposed to the desktop or a menu, etc.) (*INTERNAL*)

Returns:
	true (window is a true window), false (window is not a true window)

Author(s):
	20080121 - ManaUser - Original (http://www.autohotkey.com/board/topic/25393-appskeys-a-suite-of-simple-utility-hotkeys/)
*/
		WinGet, s, Style, ahk_id %hWnd% 
		ret := s & 0xC00000 ? (s & 0x80000000 ? 0 : 1) : 0  ;WS_CAPTION AND !WS_POPUP(for tooltips etc) 
			
		if (this._debug) ; _DBG_
			OutputDebug % "|[" A_ThisFunc "([" hWnd "])] -> " ret ; _DBG_		
	
		return ret
	}	
	__posPush() {
/* ===============================================================================
Method: __posPush
	Pushes current position of the window on position stack (*INTERNAL*)

Author(s):
	20130311 - hoppfrosch@gmx.de - Original
*/
		this._posStack.Insert(1, this.pos)
		if (this._debug) { ; _DBG_ 
			this.__posStackDump() ; _DBG_ 
			OutputDebug % "<[" A_ThisFunc "([" this._hWnd "])] -> (" this._posStack[1].dump() ")" ; _DBG_
		}
	}
	__posStackDump() {
/* ===============================================================================
Method: __posStackDump
	Dumps the current position stack via OutputDebug (*INTERNAL*)

Author(s):
	20130312 - hoppfrosch@gmx.de - Original
*/	
		For key,value in this._posStack	; loops through all elements in Stack
		
			OutputDebug % "|[" A_ThisFunc "()] -> (" key "): (" Value.dump() ")" ; _DBG_
		return
	}
	__posRestore(index="2") {
/* ===============================================================================
Method: __posRestore
	Restores position of the window  from Stack(*INTERNAL*)

Parameters:
	index - Index of position to restore (Default = 2) (1 is the current position)

Author(s):
	20130308 - hoppfrosch@gmx.de - Original
*/
		if (this._debug) ; _DBG_
			OutputDebug % ">[" A_ThisFunc "([" this._hWnd "], index=" index ")]" ; _DBG_
		restorePos := this._posStack[index]
		currPos := this.pos
		
		this.__posStackDump()
		
		this.move(restorePos.x, restorePos.y, restorePos.w, restorePos.h)
		if (this._debug) ; _DBG_
			OutputDebug % "<[" A_ThisFunc "([" this._hWnd "])] LastPos: " currPos.Dump() " - RestoredPos: " restorePos.Dump() ; _DBG_
	}
	__style() {
/* ===============================================================================
Method:   __style
	Determines the current style of the window (*INTERNAL*)
	
Returns:
	Current Style

Author(s):
	20130308 - hoppfrosch@gmx.de - Original
*/
		val := this._hWnd
		WinGet, currStyle, Style, ahk_id %val%
		if (this._debug) ; _DBG_
			OutputDebug % "|[" A_ThisFunc "([" this._hWnd "])] -> (" currStyle ")" ; _DBG_		
		return currStyle
	}
	__styleEx() {
/* ===============================================================================
Method:   __styleEx
	Determines the current extended style of the window (*INTERNAL*)
	
Returns:
	Current Extended Style

Author(s):
	20130308 - hoppfrosch@gmx.de - Original
*/
		val := this._hWnd
		WinGet, currExStyle, ExStyle, ahk_id %val%
		if (this._debug) ; _DBG_
			OutputDebug % "|[" A_ThisFunc "([" this._hWnd "])] -> (" currExStyle ")" ; _DBG_		
		return currExStyle
	}
	__SetWinEventHook(eventMin, eventMax, hmodWinEventProc, lpfnWinEventProc, idProcess, idThread, dwFlags) {
/* ===============================================================================
Method: __SetWinEventHook
	Set the hook for certain win-events (*INTERNAL*)

Parameters:
	see siehe http://msdn.microsoft.com/en-us/library/windows/desktop/dd373885(v=vs.85).aspx

Returns:
	true or false, depending on result of dllcall

Author(s):
	20130311 - hoppfrosch@gmx.de - Original
*/ 
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
	__onLocationChange() {
/* ===============================================================================
Method:   __onLocationChange
	Callback on Object-Event <CONST_EVENT.OBJECT.LOCATIONCHANGE> or on <CONST_EVENT.SYSTEM.MOVESIZEEND>
	
	Store windows size/pos on each change

Author(s):
	20130312 - hoppfrosch@gmx.de - AutoHotkey-Implementation
*/
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
	__Delete() {
/* ===============================================================================
Method: __Delete
	Destructor (*INTERNAL*)
*/ 
		if (this._hwnd <= 0) {
			return
		}
		
		if (this._debug) ; _DBG_
				OutputDebug % "|[" A_ThisFunc "([" this._hWnd "])"  ; _DBG_
			
		if (this.__useEventHook == 1) {
			if (this.__hWinEventHook1)
				DllCall( "user32\UnhookWinEvent", Uint,this._hWinEventHook1 )
			if (this.__hWinEventHook2)
				DllCall( "user32\UnhookWinEvent", Uint,this._hWinEventHook2 )
			if (this._HookProcAdr)
				DllCall( "kernel32\GlobalFree", UInt,&this._HookProcAdr ) ; free up allocated memory for RegisterCallback
		}
		
		if (this._debug) ; _DBG_
			OutputDebug % "|[" A_ThisFunc "([" this._hWnd "])"  ; _DBG_
			
		; Reset all "dangerous" settings (all windows should be left in a user accessable state)
		if (this.alwaysontop == true) {
			this.alwaysOnTop(false)
		}
		if (this.__isHidden() == 1) {
			this.show()
		}
		
		if (this.__useEventHook == 1) {		
			ObjRelease(&this)
		}
	}
	__New(_hWnd=-1, _debug=0, _test=0) {
/* ===============================================================================
Method: __New
	Constructor (*INTERNAL*)

Parameters:
	hWnd - Window handle (*Obligatory*). If hWnd=0 a test window is created ...
	_debug - Flag to enable debugging (Optional - Default: 0)

Returns:
	true or false, depending on current value

Author(s):
	20130308 - hoppfrosch@gmx.de - Original
*/   
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
		if (this.__useEventHook == 1) {
			ObjAddRef(&this)
			this._HookProcAdr := RegisterCallback("ClassWindowHandler_EventHook", "", "", &this)
			; Setting Callback on Adress <_HookProcAdr> on appearance of any event out of certain range
			this._hWinEventHook1 := this.__SetWinEventHook( CONST_EVENT.SYSTEM.SOUND, CONST_EVENT.SYSTEM.DESKTOPSWITCH, 0, this._HookProcAdr, 0, 0, 0 )	
			this._hWinEventHook2 := this.__SetWinEventHook( CONST_EVENT.OBJECT.SHOW, CONST_EVENT.OBJECT.CONTENTSCROLLED, 0, this._HookProcAdr, 0, 0, 0 )	
		}
		
		if (this._debug) ; _DBG_
			OutputDebug % "<[" A_ThisFunc "(hWnd=(" _hWnd "))]" ; _DBG_
		
		
		return this
	}
	
}

/*!
	End of class
*/

/*! ===============================================================================
Function:   ClassWindowHandler_EventHook
	Callback on System Events. Used as dispatcher to detect window manipulation and calling the appropriate member-function within class <WindowHandler>
	
Author(s):
	20120629 - hoppfrosch - Original

See also:
	http://www.autohotkey.com/community/viewtopic.php?t=35659
	http://www.autohotkey.com/community/viewtopic.php?f=1&t=88156
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

/*!
	End of class
*/
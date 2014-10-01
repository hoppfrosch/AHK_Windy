; ****** HINT: Documentation can be extracted to HTML using GenDocs (https://github.com/fincs/GenDocs) by fincs
; ****** HINT: Debug-lines should contain "; _DBG_" at the end of lines - using this, the debug lines could be automatically removed through scripts before releasing the sourcecode


#include <EDE\Rectangle>
#include <EDE\Point>
#include <EDE\MultiMonitorEnv>
#include <EDE\Const_WinUser>
#include <EDE\_WindowHandlerEvent>
#include <SerDes>

class WindowHandler {
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
	_version := "0.6.19"
	_debug := 0
	_hWnd := 0

	__useEventHook := 1
	_hWinEventHook1 := 0
	_hWinEventHook2 := 0
	_HookProcAdr := 0
		
	_bManualMovement := false

	_posStack := 0

	; ##################### Start of Properties (AHK >1.1.16.x) ############################################################
	alwaysOnTop[] {
	/*! ---------------------------------------------------------------------------------------
	Property: alwaysOnTop [get/set]
	Set/Unset alwaysontop flag of the current window or get the current state
			
	Value:
	flag - `true` or `false` (activates/deactivates *alwaysontop*-Property)
	
	Remarks:		
	* To toogle current *alwaysontop*-Property, simply use `obj.alwaysontop := !obj.alwaysontop`
	*/
		get {
			ret := (this.styleEx & WS.EX.TOPMOST) > 0 ? 1 : 0
			if (this._debug) ; _DBG_
				OutputDebug % "|[" A_ThisFunc "([" this.hwnd "])] -> " ret ; _DBG_
			return ret
		}
		set {
			hwnd := this.hwnd
			if (value == true)
				value := "on"
			else if (value == false) 
				value := "off"
			WinSet, AlwaysOnTop, %value%,  ahk_id %hwnd%
			if (this._debug) ; _DBG_
				OutputDebug % "[" A_ThisFunc "([" this.hwnd "], value=" value ")] -> New Value:" this.alwaysontop ; _DBG_
		
			return this.alwaysOnTop
		}
	}
	caption[] {
	/*! ---------------------------------------------------------------------------------------
	Property: caption [get/set]
	Set/Unset visibility of the window caption
			
	Value:
	flag - `true` or `false` (activates/deactivates *caption*-Property)
	
	Remarks:		
	* To toogle, simply use `obj.caption := !obj.caption`
	*/
		get {
			ret := (this.style & WS.CAPTION) > 0 ? 1 : 0
			if (this._debug) ; _DBG_
				OutputDebug % "|[" A_ThisFunc "([" this.hwnd "])] -> " ret ; _DBG_
			return ret
		}

		set {
		; Idea taken from majkinetors Forms Framework (https://github.com/maul-esel/FormsFramework), win.ahk
			style := "-" this.__hexStr(WS.CAPTION)
			if (value) {
					style := "+" this.__hexStr(WS.CAPTION)
			}
		 	prevState := A_DetectHiddenWindows
			DetectHiddenWindows, on
			this.style := style
			this.redraw()
			DetectHiddenWindows, %prevState%
			if (this._debug) ; _DBG_
					OutputDebug % "|[" A_ThisFunc "([" this.hwnd "], value=" value ")] -> " this.caption ; _DBG_
			return value
		}
	}
	centercoords[] {
	/*! ---------------------------------------------------------------------------------------
	Property: centercoords [get/set]
	Coordinates of the center of the window as a [Point](Point.html)-object
	*/

		get {
			pos := this.posSize
			x := Round((pos.w)/2 + pos.x)
			y := Round((pos.h)/2 + pos.y)
			centerPos := new Point(x,y,this._debug)
			if (this._debug) ; _DBG_
				OutputDebug % "<[" A_ThisFunc "(pos="pos.dump() " [" this.hwnd "])] -> " centerPos.dump() ; _DBG_
			return centerPos
		}

		set {
			currCenter := this.centercoords
			currPos := this.posSize
		
			xoffset := value.x - currCenter.x
			yoffset := value.y - currCenter.y
		
			x := currPos.x + xoffset
			y := currPos.y + yoffset
		
			this.move(x,y,99999,99999)
			centerPos := this.centercoords
			if (this._debug) ; _DBG_
				OutputDebug % "|[" A_ThisFunc "(pos=" value.dump() " [" this.hwnd "])] -> " centerPos.dump() ; _DBG_
			return centerPos
		}
	}
	classname[] {
	/*! ---------------------------------------------------------------------------------------
		Property: classname [get]
		name of the window class. 

		Remarks:
		There is no setter available, since this is a constant window property
	*/
		get {
			val := this.hwnd
			WinGetClass, __classname, ahk_id %val%
			if (this._debug) ; _DBG_
				OutputDebug % "|[" A_ThisFunc "([" this.hwnd "]) -> (" __classname ")]" ; _DBG_		
			return __classname
		}
	}
	debug[] { ; _DBG_
	/*! ------------------------------------------------------------------------------ ; _DBG_
	Property: debug [get/set]                                                          ; _DBG_
	Debug flag                                                                         ; _DBG_
	*/                                                                                 ; _DBG_
		get {                                                                          ; _DBG_ 
			return this._debug                                                         ; _DBG_
		}                                                                              ; _DBG_
		set {                                                                          ; _DBG_
			mode := value<1?0:1                                                        ; _DBG_
			this._debug := mode                                                        ; _DBG_
			return this._debug                                                         ; _DBG_
		}                                                                              ; _DBG_
	}                                                                                  ; _DBG_
	exist[] {
	/*! ---------------------------------------------------------------------------------------
	Property: exist [get]
	Checks whether the window still exists. 

	Remarks:
	There is no setter available, since this is a constant window property
	*/
		get {
			val := this.hwnd
			_hWnd := WinExist("ahk_id " val)
			ret := true
			if (_hWnd = 0)
				ret := false
			if (this._debug) ; _DBG_
				OutputDebug % "|[" A_ThisFunc "([" this.hwnd "])] -> " ret ; _DBG_		
			return ret
		}
	}
	hidden[] {
	/*! ---------------------------------------------------------------------------------------
		Property: hidden [get/set]
		Get or Set the *hidden*-Property. Hides/Unhide the current window or get the current state of hiding

		Value:
		flag - `true` or `false` (activates/deactivates *hidden*-Property)

		Remarks:		
		* To toogle current *hidden*-Property, simply use `obj.hidden := !obj.hidden`	
*/
		get {
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
				OutputDebug % "|[" A_ThisFunc "([" this.hwnd "])] -> " ret ; _DBG_		
			return ret
		}

		set{
			mode := value
			if (this._debug) ; _DBG_
				OutputDebug % ">[" A_ThisFunc "([" this.hwnd "], mode=" mode ")] -> Current Value:" this.hidden ; _DBG_

			val := this.hwnd
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
				OutputDebug % "<[" A_ThisFunc "([" this.hwnd "], mode=" mode ")] -> New Value:" isHidden ; _DBG_
			
			return isHidden
		}
	}
	hwnd[] {
	/*! ---------------------------------------------------------------------------------------
	Property: hwnd [get]
	Get the window handle of the current window
	*/
		get {
			return this._hwnd
		}
	}
	hangs[] {
	/*! ---------------------------------------------------------------------------------------
	Property: hangs [get]
	Determines whether the system considers that a specified application is not responding. 
	*/
		get {
			ret := DllCall("user32\IsHungAppWindow", "Ptr", this.hwnd)
			if (this._debug) ; _DBG_
				OutputDebug % "|[" A_ThisFunc "([" this.hwnd "])] -> " ret ; _DBG_		
			return ret
		}
	}
	hscrollable[] {
	/*! ---------------------------------------------------------------------------------------
	Property: hscrollable [get/set]
	Get or Set the *hscrollable*-Property (Is vertical scrollbar available?)

	Value:
	flag - `true` or `false` (activates/deactivates *hscrollable*-Property)

	Remarks:		
	* To toogle current *hscrollable*-Property, simply use `obj.hscrollable := !obj.hscrollable`
	*/
		get {
			ret := (this.style & WS.HSCROLL) > 0 ? 1 : 0
			if (this._debug) ; _DBG_
				OutputDebug % "|[" A_ThisFunc "([" this.hwnd "])] -> " ret ; _DBG_
			return ret
		}

		set {
			style := "-" this.__hexStr(WS.HSCROLL)
			if (value) {
				style := "+" this.__hexStr(WS.HSCROLL)
			}
		 	prevState := A_DetectHiddenWindows
			DetectHiddenWindows, on
			this.style := style
			this.redraw()
			DetectHiddenWindows, %prevState%
			if (this._debug) ; _DBG_
				OutputDebug % "|[" A_ThisFunc "([" this.hwnd "], value=" value ")] -> " this.hscrollable ; _DBG_
			return value
		}
	}
	maximizebox[] {
	/*! ---------------------------------------------------------------------------------------
	Property: maximizebox [get/set]
	Get or Set the *maximizebox*-Property (Is maximizebox available?)

	Value:
	flag - `true` or `false` (activates/deactivates *maximizebox*-Property)

	Remarks:		
	* To toogle current *maximizebox*-Property, simply use `obj.maximizebox := !obj.maximizebox`
	*/
		get {
			ret := (this.style & WS.MAXIMIZEBOX) > 0 ? 1 : 0
			if (this._debug) ; _DBG_
				OutputDebug % "|[" A_ThisFunc "([" this.hwnd "])] -> " ret ; _DBG_
			return ret
		}

		set {
			style := "-" this.__hexStr(WS.MAXIMIZEBOX)
			if (value) {
				style := "+" this.__hexStr(WS.MAXIMIZEBOX)
			}
		 	prevState := A_DetectHiddenWindows
			DetectHiddenWindows, on
			this.style := style
			this.redraw()
			DetectHiddenWindows, %prevState%
			if (this._debug) ; _DBG_
				OutputDebug % "|[" A_ThisFunc "([" this.hwnd "], value=" value ")] -> " this.maximizebox ; _DBG_
			return value
		}
	}
	maximized[] {
	/*! ---------------------------------------------------------------------------------------
	Property: maximized [get/set]
	Get or Set the *maximized*-Property. Maximizes/Demaximizes the current window or get the current state of maximization
	
	Value:
	flag - `true` or `false` (activates/deactivates *maximized*-Property)
	
	Remarks:		
	* To toogle current *maximized*-Property, simply use `obj.maximized := !obj.maximized`	
*/
		get {
			val := this.hwnd
			WinGet, s, MinMax, ahk_id %val% 
			ret := 0
			if (s == 1)
				ret := 1	
			return ret
		}

		set {
			mode := value
			newState := 1
			if (mode == 0) {
				newState := 0
			}
			
			prevState := A_DetectHiddenWindows
			DetectHiddenWindows, On
			if (newState == 1 )
				WinMaximize % "ahk_id" this.hwnd
			else 
				WinRestore % "ahk_id" this.hwnd
			DetectHiddenWindows, %prevState%
			
			isMax := this.maximized
			if (this._debug) ; _DBG_
				OutputDebug % "|[" A_ThisFunc "([" this.hwnd "], mode=" mode ")] -> New Value:" isMax ; _DBG_
			
			return isMax
		}
	}
	minimized[] {
	/*! ---------------------------------------------------------------------------------------
	Property: minimized [get/set]
	Get or Set the *minimized*-Property. Minimizes/Deminimizes the current window or get the current state of minimization

	Value:
	flag - `true` or `false` (activates/deactivates *minimized*-Property)

	Remarks:		
	* To toogle current *minimized*-Property, simply use `obj.minimized := !obj.minimized`	
	*/
		get {
			val := this.hwnd
			WinGet, s, MinMax, ahk_id %val% 
			ret := 0
			if (s == -1)
				ret := 1	
			return ret
		}

		set {
			mode := value
			newState := 1
			if (mode == 0) {
				newState := 0
			}
		
			prevState := A_DetectHiddenWindows
			DetectHiddenWindows, On
			if (newState == 1 )
				WinMinimize % "ahk_id" this.hwnd
			else 
				WinRestore % "ahk_id" this.hwnd
			DetectHiddenWindows, %prevState%
	
			isMin := this.minimized
			if (this._debug) ; _DBG_
				OutputDebug % "<[" A_ThisFunc "([" this.hwnd "], mode=" mode ")] -> New Value:" isMin ; _DBG_

			return isMin
			}
	}
	monitorID[] {
	/*! ---------------------------------------------------------------------------------------
	Property: monitorID [get/set]
	Get or Set the ID of monitor on which the window is on. Setting the property moves the window to the corresponding monitor, trying to place the window at the same (scaled) position

	Value:
	ID - Monitor-ID (if ID > max(ID) then ID = max(ID) will be used)
		
	Remarks
	* Setting the property moves the window to the corresponding monitor, retaining the (relative) position and size of the window
	*/
		get {
			mon := 1
			c := this.centercoords
			mme := new MultiMonitorEnv(this._debug)
			mon := mme.monGetFromCoord(c.x,c.y,mon)
			if (this._debug) ; _DBG_
				OutputDebug % "|[" A_ThisFunc "([" this.hwnd "])] -> " mon ; _DBG_		
			return mon
		}

		set {
			obj := new MultiMonitorEnv(this._debug)
		
			realID := value
			if (realID > obj.monCount()) {
				realID := obj.monCount()
			}	
			if (realID < 1) {
				realID := 1
			}
			newMon := obj.monBoundary(realID)
		
			oldID := this.monitorID
			oldMon := obj.monBoundary(oldID)
		
			oldPos := this.posSize
			xnew := newMon.x+(oldPos.x - oldMon.x)
			ynew := newMon.y+(oldPos.y - oldMon.y)
			this.Move(xnew,ynew)
			monID := this.monitorID
			if (this._debug) ; _DBG_
				OutputDebug % "|[" A_ThisFunc "([" this.hwnd "], ID=" value ")] -> New Value:" monID " (from: " oldID ")" ; _DBG_
	
			return monID
		}
	}
	parent[bFixStyle=false]{
	/*! ---------------------------------------------------------------------------------------
	Property: parent [get/set]
	Get or Set the parent of the window.
	
	Value:
	hwndPar	- Handle to the parent window. If this parameter is 0, the desktop window becomes the new parent window.
	bFixStyle - Set to TRUE to fix WS_CHILD & WS_POPUP styles. SetParent does not modify the WS_CHILD or WS_POPUP window styles of the window whose parent is being changed.

	If hwndPar is 0, you should also clear the WS_CHILD bit and set the WS_POPUP style after calling SetParent (and vice-versa).	

	Returns:
	If the function succeeds, the return value is a handle to the previous parent window. Otherwise, its 0.

 	Remarks:
	If the current window identified by the hwnd parameter is visible, the system performs the appropriate redrawing and repainting.
	The function sends WM_CHANGEUISTATE to the parent after succesifull operation uncoditionally.
	See <http://msdn.microsoft.com/en-us/library/ms633541(VS.85).aspx> for more information.
	*/
		get {
			hwndPar := DllCall("GetParent", "uint", hwndPar, "UInt")
			if (this._debug) ; _DBG_
				OutputDebug % "|[" A_ThisFunc "([" this.hwnd "])] -> " hwndPar ; _DBG_		
			return hwndPar
		}


		set {
		; Idea taken from majkinetors Forms Framework (https://github.com/maul-esel/FormsFramework), win.ahk
			hwndPar := value
			hwnd := this.hwnd
			if (bFixStyle) {
				s1 := hwndPar ? "+" : "-", s2 := hwndPar ? "-" : "+"
				ws_child := WS.CHILD
				ws_popup := WS.POPUP
				WinSet, Style, %s1%%ws_child%, ahk_id %hwnd%
				WinSet, Style, %s2%%ws_popup%, ahk_id %hwnd%
			}
			ret := DllCall("SetParent", "uint", Hwnd, "uint", hwndPar, "Uint")
			if  ret == 0				
				hwndPar := 0
			else
				SendMessage, WM.CHANGEUISTATE, UIS.NITIALIZE,,,ahk_id %hwndPar%	
			
			if (this._debug) ; _DBG_
				OutputDebug % "|[" A_ThisFunc "([" this.hwnd "], hwndPar= " hwndPar ", bfixStyle=" bFixStyle ")] -> hwnd:" hwndPar ")" ; _DBG_
			return hwndPar
		}
	}
	pos[] {
	/*! ---------------------------------------------------------------------------------------
	Property: pos [get/set]
	Position of the window as [Point](point.html) object
	*/
		get {
			ps := this.posSize
			pt := new Point()
			pt.x := ps.x
			pt.y := ps.y
			return pt
		}
		set {
			pt := value
			ps := this.posSize
			ps.x := pt.x
			ps.y := pt.y
			this.posSize := ps
			return pt
		}
	}
	posSize[] {
	/*! ---------------------------------------------------------------------------------------
	Property: posSize [get/set]
	Get or Set the position and size of the window (To set the position use class [Rectangle](rectangle.html))	
	*/
		get {
			info := this.windowinfo
			currPos := new Rectangle(info.window.xul,info.window.yul,info.window.xlr-info.window.xul,info.window.ylr-info.window.yul,this._debug)
			if (this._debug) ; _DBG_
				OutputDebug % "|[" A_ThisFunc "([" this.hwnd "])] -> (" currPos.dump() ")" ; _DBG_
			return currPos
		}

		set {
			rect := value
			this.move(rect.x, rect.y, rect.w, rect.h)
			newPos := this.posSize
			if (this._debug) ; _DBG_
				OutputDebug % "|[" A_ThisFunc "([" this.hwnd "], pos=" newPos.Dump()")] -> New Value:" newPos.Dump() ; _DBG_
			return newPos
		}
	}
	processID[] {
	/*! ---------------------------------------------------------------------------------------
	Property: processID [get]
	Get the ID of the process the window belongs to
	
	Remarks:		
	There is no setter available, since this cannot be modified
	*/
		get {
			ret := ""
			if this.exist {
				WinGet, PID, PID, % "ahk_id " this.hwnd
				ret := PID
			}
			if (this._debug) ; _DBG_
				OutputDebug % "|[" A_ThisFunc "([" this.hwnd "])] -> " ret ; _DBG_		
			return ret
		}
	}
	processname[] {
	/*! ---------------------------------------------------------------------------------------
	Property: processname [get]
	Get the Name of the process the window belongs to

	Remarks:		
	There is no setter available, since this cannot be modified
	*/
		get {
			ret := ""
			if this.exist {
				WinGet, PName, ProcessName, % "ahk_id " this.hwnd
				ret := PName
			}
			if (this._debug) ; _DBG_
				OutputDebug % "|[" A_ThisFunc "([" this.hwnd "])] -> " ret ; _DBG_		
			return ret
		}
	}
	resizeable[] {
	/*! ---------------------------------------------------------------------------------------
	Property: resizeable [get/set]
	Get or Set the *resizeable*-Property (Is window resizing possible?)

	Value:
	flag - `true` or `false` (activates/deactivates *resizeable*-Property)

	Remarks:		
	* To toogle current *resizeable*-Property, simply use `obj.resizeable := !obj.resizeable`
	* Same as property *sizebox*

	*/
		get {
			return this.sizebox
		}
		set {
			this.sizebox := value
			return value
		}
	}
	rolledUp[] {
	/*! ---------------------------------------------------------------------------------------
	Property: rolledUp [get/set]
	Get or Set the *RolledUp*-Property (window is rolled up to its title bar).  Rolls/De-Rolls the current window or get the current state of RollUp

	Value:
	flag - `true` or `false` (activates/deactivates *rolledUp*-Property)

	Remarks:		
	* To toogle current *rolledUp*-Property, simply use `obj.rolledUp := !obj.rolledUp`
	*/
		get {
			ret := 0
			if !this.exist {
				; the window does not exist at all ...
				ret := -1
			}
			else {
				currPos := this.posSize
				if (currPos.h <= this.rolledUpHeight) {
					ret := 1
				}
			}
			if (this._debug) ; _DBG_
				OutputDebug % "|[" A_ThisFunc "([" this.hwnd "])] -> " ret ; _DBG_		
			return ret
		}

		set {
			mode := value
			roll := 1
			if (mode == 1) 		
				roll := 1
			else if (mode = 0) 
				if (this.rolledUp = true)
					roll := 0 ; Only rolled window can be unrolled
				else
					roll := -1 ; As window is not rolled up, you cannot unroll it as requested ....
			else {
				if (this.rolledUp = true)
					roll := 0
				else
					roll := 1
			}
			
			; Determine the minmal height of a window
			MinWinHeight := this.rolledUpHeight
			; Get size of current window
			hwnd := this.hwnd
			currPos := this.posSize
		
			if (roll = 1) { ; Roll
	            this.move(currPos.x, currPos.y, currPos.w, MinWinHeight)
			}
			else if (roll = 0) { ; Unroll
				this.__posRestore()			
			}
			
			isRolled := this.rolledUp
			if (this._debug) ; _DBG_
				OutputDebug % "<[" A_ThisFunc "([" this.hwnd "], mode=" mode ")] -> New Value:" isRolled ; _DBG_

			return isRolled
		}
	}
	rolledUpHeight[] {
	/*! ---------------------------------------------------------------------------------------
	Property:rolledUpHeight [get]
		Returns the height of the caption bar of windows
		
	Remarks:
	There is no setter available, since this is a constant window property
	*/
		get {
			SysGet, ret, 29
			return ret
		}

	}
	size[] {
	/*! ---------------------------------------------------------------------------------------
	Property: size [get/set]
	Dimensions (Width/Height) of the window as [Point](point.html) object
	*/
		get {
			ps := this.posSize
			pt := new Point()
			pt.x := ps.w
			pt.y := ps.h
			return pt
		}
		set {
			pt := Value
			ps := this.posSize
			ps.w := pt.x
			ps.h := pt.y
			this.posSize := ps
			return pt
		}
	}
	sizebox[] {
	/*! ---------------------------------------------------------------------------------------
	Property: sizebox [get/set]
	Get or Set the *sizebox*-Property (Is window resizing possible?)

	Value:
	flag - `true` or `false` (activates/deactivates *sizebox*-Property)

	Remarks:		
	* To toogle current *sizebox*-Property, simply use `obj.sizebox := !obj.sizebox`
	* Same as property *resizeable*
	*/
		get {
			ret := (this.style & WS.SIZEBOX) > 0 ? 1 : 0
			if (this._debug) ; _DBG_
				OutputDebug % "|[" A_ThisFunc "([" this.hwnd "])] -> " ret ; _DBG_
			return ret
		}

		set {
			style := "-" this.__hexStr(WS.SIZEBOX)
			if (value) {
				style := "+" this.__hexStr(WS.SIZEBOX)
			}
		 	prevState := A_DetectHiddenWindows
			DetectHiddenWindows, on
			this.style := style
			this.redraw()
			DetectHiddenWindows, %prevState%
			if (this._debug) ; _DBG_
				OutputDebug % "|[" A_ThisFunc "([" this.hwnd "], value=" value ")] -> " this.sizebox ; _DBG_
			return value
		}
	}
	style[] {
	/*! ---------------------------------------------------------------------------------------
	Property: style [get]
	Returns current window style
	*/
		get {
			hWnd := this._hwnd
			WinGet, currStyle, Style, ahk_id %hwnd%
			if (this._debug) ; _DBG_
				OutputDebug % "|[" A_ThisFunc "([" this._hwnd "])] -> (" this.__hexStr(currStyle) ")"
			return currStyle
		}
		set {
			hwnd := this.hwnd
			WinSet, Style, %value%, ahk_id %hwnd%
			this.redraw()
			WinGet, currStyle, Style, ahk_id %hwnd%
			if (this._debug) ; _DBG_
				OutputDebug % "|[" A_ThisFunc "([" this.hwnd "], style=" this.__hexStr(value) ")] -> (" this.__hexStr(value) "/" this.__hexStr(currStyle) ")" ; _DBG_		
			return value
		}		
	}
	styleEx[] {
	/*! ---------------------------------------------------------------------------------------
	Property: styleEx [get]
	Returns current window extended style
	*/

		get {
			hWnd := this._hwnd
			WinGet, currStyle, ExStyle, ahk_id %hwnd%
			if (this._debug) ; _DBG_
				OutputDebug % "|[" A_ThisFunc "([" this._hwnd "])] -> (" this.__hexStr(currStyle) ")"
			return currStyle
		}
		set {
			hwnd := this.hwnd
			WinSet, ExStyle, %value%, ahk_id %hwnd%
			this.redraw()
			WinGet, currStyle, ExStyle, ahk_id %hwnd%
			if (this._debug) ; _DBG_
				OutputDebug % "|[" A_ThisFunc "([" this.hwnd "], styleEx=" this.__hexStr(value) ")] -> (" this.__hexStr(value) "/" this.__hexStr(currStyle) ")" ; _DBG_		
			return value
		}
	}
	title[] {
	/*! ---------------------------------------------------------------------------------------
	Property: title [get/set]
	Current window title. 

	Remarks:		
	A change to a window's title might be merely temporary if the application that owns the window frequently changes the title.
	*/
		get {
			val := this.hwnd
			WinGetTitle, title, ahk_id %val%
			if (this._debug) ; _DBG_
				OutputDebug % "|[" A_ThisFunc "([" this.hwnd "]) -> (" title ")]" ; _DBG_		
			return title
		}

		set {
			title := value
			val := this.hwnd
			prevState := A_DetectHiddenWindows
			DetectHiddenWindows, On
			WinSetTitle, ahk_id %val%,, %title%
			DetectHiddenWindows, %prevState%
			newTitle := this.title
			if (this._debug) ; _DBG_
				OutputDebug % "|[" A_ThisFunc "([" this.hwnd "], title=" title ")] -> " newTitle ; _DBG_		
			return newTitle
		}
	}
	transparency[increment := 1,delay := 10] {
	/*! ---------------------------------------------------------------------------------------
	Property: transparency [get/set]
	Current window transparency. 

	Parameters: [Setter]
	transparency - transparency to be set
	increment - transparency-incrementation while fading
	delay - delay between each increment (Unit: ms)

	Remarks:
	* if : transparency > current, increases current transparency [increment+]
	* if : transparency < current, decreases current transparency [increment-]
	* if : increment = 0, transparency isset immediately without any fading
	*/
		get {
			hwnd := this.hwnd
			WinGet, s, Transparent, ahk_id %hwnd% 
			ret := 255
			if (s != "")
				ret := s
			if (this._debug) ; _DBG_
				OutputDebug % "|[" A_ThisFunc "([" this.hwnd "])] -> " ret ; _DBG_
			return ret
		}

		set {
		/* ### Author(s)
			* xxxxxxxx - [joedf](http://ahkscript.org/boards/viewtopic.php?f=6&t=512)
			* 20140922 - [hoppfrosch](hoppfrosch@gmx.de) - Rewritten
		*/
			hwnd := this.hwnd
			transFinal := value
			transOrig := value
			if (transFinal == "OFF")
				transFinal := 255
			transFinal:=(transFinal>255)?255:(transFinal<0)?0:transFinal

			transStart:= this.transparency
	    	transStart :=(transStart="")?255:transStart ;prevent trans unset bug
			WinSet,Transparent,%transStart%,ahk_id %hwnd%

			if (increment != 0) {
				; do the fading animation
				increment:=(transStart<transFinal)?abs(increment):-1*abs(increment)
				transCurr := transStart
	    		while(k:=(increment<0)?(transCurr>transFinal):(transCurr<transFinal)&&this.exist) {
	        		transCurr:= this.transparency
	        		transCurr+=increment
	        		WinSet,Transparent,%transCurr%,ahk_id %hwnd%
	        		sleep %delay%
	    		}
    		}
    		; Set final transparency
	    	WinSet,Transparent,%transFinal%,ahk_id %hwnd%
			transEnd := this.transparency
			if (this._debug) ; _DBG_
				OutputDebug % "<[" A_ThisFunc "([" this.hwnd "], transparency=" transOrig "(" transStart "), increment=" increment ", delay=" delay ")] -> New Value:" transEnd ; _DBG_
			return transEnd
		}
	}
	vscrollable[] {
	/*! ---------------------------------------------------------------------------------------
	Property: vscrollable [get/set]
	Get or Set the *vscrollable*-Property (Is vertical scrollbar available?)

	Value:
	flag - `true` or `false` (activates/deactivates *vscrollable*-Property)

	Remarks:		
	* To toogle current *vscrollable*-Property, simply use `obj.vscrollable := !obj.vscrollable`
	*/
		get {
			ret := (this.style & WS.VSCROLL) > 0 ? 1 : 0
			if (this._debug) ; _DBG_
				OutputDebug % "|[" A_ThisFunc "([" this.hwnd "])] -> " ret ; _DBG_
			return ret
		}

		set {
			style := "-" this.__hexStr(WS.VSCROLL)
			if (value) {
				style := "+" this.__hexStr(WS.VSCROLL)
			}
		 	prevState := A_DetectHiddenWindows
			DetectHiddenWindows, on
			this.style := style
			this.redraw()
			DetectHiddenWindows, %prevState%
			if (this._debug) ; _DBG_
				OutputDebug % "|[" A_ThisFunc "([" this.hwnd "], value=" value ")] -> " this.vscrollable ; _DBG_
			return value
		}
	}
	windowinfo {
	/*! ---------------------------------------------------------------------------------------
	Property: windowinfo [get]
	Current window info. 

	 Return values:    
	 * On success  - Object containing structure's values (see Remarks)
     * On failure  - False, ErrorLevel = 1 -> Invalid HWN, ErrorLevel = 2 -> DllCall("GetWindowInfo") caused an error

    Remarks:          
    * The returned object contains all keys defined in WINDOWINFO except "Size".
    * The keys "Window" and "Client" contain objects with keynames defined in [5]
    * For more details see http://msdn.microsoft.com/en-us/library/ms633516%28VS.85%29.aspx and http://msdn.microsoft.com/en-us/library/ms632610%28VS.85%29.aspx 

    ### Author(s)
     	* just me (http://www.autohotkey.com/board/topic/69254-func-api-getwindowinfo-ahk-l/)
	*/
		get {
		   ; [1] = Offset, [2] = Length, [3] = Occurrences, [4] = Type, [5] = Key array
   			Static WINDOWINFO := { Size: [0, 4, 1, "UInt", ""]
			                        , Window: [4, 4, 4, "Int", ["xul", "yul", "xlr", "ylr"]]
			                        , Client: [20, 4, 4, "Int", ["xul", "yul", "xlr", "ylr"]]
			                        , Styles: [36, 4, 1, "UInt", ""]
			                        , ExStyles: [40, 4, 1, "UInt", ""]
			                        , Status: [44, 4, 1, "UInt", ""]
			                        , XBorders: [48, 4, 1, "UInt", ""]
			                        , YBorders: [52, 4, 1, "UInt", ""]
			                        , Type: [56, 2, 1, "UShort", ""]
			                        , Version: [58, 2, 1, "UShort", ""] }
   			Static WI_Size := 0
   			If (WI_Size = 0) {
      			For Key, Value In WINDOWINFO
         			WI_Size += (Value[2] * Value[3])
   			}
   			If !DllCall("User32.dll\IsWindow", "Ptr", this.hwnd) {
      			ErrorLevel := 1
      			OutputDebug % "|[" A_ThisFunc "([" this.hwnd "]) -> false (is not a window)]" ; _DBG_
      			Return False
   			}
   			struct_WI := ""
   			NumPut(VarSetCapacity(struct_WI, WI_Size, 0), struct_WI, 0, "UInt")
   			If !(DllCall("User32.dll\GetWindowInfo", "Ptr", this.hwnd, "Ptr", &struct_WI)) {
   		   		ErrorLevel := 2
   		   		OutputDebug % "|[" A_ThisFunc "([" this.hwnd "]) -> false]" ; _DBG_
      		 	Return False
  			}
   			obj_WI := {}
   			For Key, Value In WINDOWINFO {
	      		If (Key = "Size")
	         		Continue
			    Offset := Value[1]
	      		If (Value[3] > 1) { ; more than one occurrence
	         		If IsObject(Value[5]) { ; use keys defined in Value[5] to store the values in
	            		obj_ := {}
	            		Loop, % Value[3] {
	               			obj_.Insert(Value[5][A_Index], NumGet(struct_WI, Offset, Value[4]))
	               			Offset += Value[2]
	            		}
	            		obj_WI[Key] := obj_
	         		} Else { ; use simple array to store the values in
	            		arr_ := []
	            		Loop, % Value[3] {
	               			arr_[A_Index] := NumGet(struct_WI, Offset, Value[4])
	               			Offset += Value[2]
	            		}
	            		obj_WI[Key] := arr_
	         		}		
	      		} Else { ; just one item
	         		obj_WI[Key] := NumGet(struct_WI, Offset, Value[4])
	      		}
   			}
			if (this._debug) ; _DBG_
   				OutputDebug % "|[" A_ThisFunc "([" this.hwnd "])] => (" SerDes(Obj_WI) ")" ; _DBG_
   			Return obj_WI
		}	
	}
	; ##################### End of Properties (AHK >1.1.16.x) ##############################################################
	
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
			OutputDebug % "|[" A_ThisFunc "([" this.hwnd "])]" ; _DBG_		

		prevState := A_DetectHiddenWindows
		DetectHiddenWindows, On
		WinKill % "ahk_id" this.hwnd
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
			OutputDebug % ">[" A_ThisFunc "([" this.hwnd "])(X=" X " ,Y=" Y " ,W=" W " ,H=" H ")]" ; _DBG_		
		if (X = 99999 || Y = 99999 || W = 99999 || H = 9999)
			currPos := this.posSize
		
		if (X = 99999)
			X := currPos.X
		
		if (Y = 99999)
			Y := currPos.Y
		
		if (W = 99999)
			W := currPos.W
		
		if (H = 99999)
			H := currPos.H
		
		if (this._debug) ; _DBG_
			OutputDebug % "<[" A_ThisFunc "([" this.hwnd "])(X=" X " ,Y=" Y " ,W=" W " ,H=" H ")]" ; _DBG_		
		WinMove % "ahk_id" this.hwnd, , X, Y, W, H
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
			OutputDebug % ">[" A_ThisFunc "([" this.hwnd "], xFactor=" xFactor ", yFactor=" yFactor ", wFactor=" wFactor ", hFactor=" hFactor ")]" ; _DBG_
			
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
			OutputDebug % "<[" A_ThisFunc "([" this.hwnd "], xFactor=" xFactor ", yFactor=" yFactor ", wFactor=" wFactor ", hFactor=" hFactor ")] -> padded to (" this.posSize.Dump() ") on Monitor (" monId ")" ; _DBG_
	}
    redraw(Option="" ) {
/*! ===============================================================================
 	Function:	Redraw
 	Redraws the window.

 	Parameters:
	Option  - "-" to disable redrawing for the window. "+" to enable it and redraw it. By default empty.
 
 	Returns:
	A nonzero value indicates success. Zero indicates failure.

 	Remarks:
	### Hint
		This function will update the window for sure, unlike WinSet or InvalidateRect.

	### Author(s)
		* xxxxxxxx - majkinetor
		* 20140922 - [hoppfrosch](hoppfrosch@gmx.de) - Rewritten
 */
		return
		hwnd := this.hwnd
		if (Option != "") {
			old := A_DetectHiddenWindows
			DetectHiddenWindows, on
			bEnable := Option="+"
			SendMessage, WM.SETREDRAW, bEnable,,,ahk_id %hwnd%
			DetectHiddenWindows, %old%
			ifEqual, bEnable, 0, return		
		}
		ret := DllCall("RedrawWindow", "uint", hwnd, "uint", 0, "uint", 0, "uint" ,RDW.INVALIDATE | RDW.ERASE | RDW.FRAME | RDW.ERASENOW | RDW.UPDATENOW | RDW.ALLCHILDREN)
		if (this._debug) ; _DBG_
			OutputDebug % "|[" A_ThisFunc "([" this.hwnd "], Option=" Option ")] -> ret=" ret ; _DBG_
		return ret
	}
	; ######################## Internal Methods - not to be called directly ############################################
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
		ret := s & WS.CAPTION ? (s & WS.POPUP ? 0 : 1) : 0  ;WS_CAPTION AND !WS_POPUP(for tooltips etc) 
			
		if (this._debug) ; _DBG_
			OutputDebug % "|[" A_ThisFunc "([" hWnd "])] -> " ret ; _DBG_		
	
		return ret
	}	
	__hexStr(i) {
/* ===============================================================================
Method:   ____hexStr
	Converts number to hex representation (*INTERNAL*)

Returns:
	HEX
*/
		OldFormat := A_FormatInteger ; save the current format as a string
		SetFormat, Integer, Hex
		i += 0 ;forces number into current fomatinteger
		SetFormat, Integer, %OldFormat% ;if oldformat was either "hex" or "dec" it will restore it to it's previous setting
		return i
	}
	__posPush() {
/* ===============================================================================
Method: __posPush
	Pushes current position of the window on position stack (*INTERNAL*)

Author(s):
	20130311 - hoppfrosch@gmx.de - Original
*/
		this._posStack.Insert(1, this.posSize)
		if (this._debug) { ; _DBG_ 
			OutputDebug % "|[" A_ThisFunc "([" this.hwnd "])] -> (" this._posStack[1].dump() ")" ; _DBG_
			this.__posStackDump() ; _DBG_ 
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
			OutputDebug % ">[" A_ThisFunc "([" this.hwnd "], index=" index ")]" ; _DBG_
		restorePos := this._posStack[index]
		currPos := this.posSize
		
		this.__posStackDump()
		
		this.move(restorePos.x, restorePos.y, restorePos.w, restorePos.h)
		if (this._debug) { ; _DBG_
			OutputDebug % "<[" A_ThisFunc "([" this.hwnd "])] LastPos: " currPos.Dump() " - RestoredPos: " restorePos.Dump() ; _DBG_
			this.__posStackDump() ; _DBG_ 
		}
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
			OutputDebug % "|[" A_ThisFunc "([" this.hwnd "])(eventMin=" eventMin ", eventMax=" eventMax ", hmodWinEventProc=" hmodWinEventProc ", lpfnWinEventProc=" lpfnWinEventProc ", idProcess=" idProcess ", idThread=" idThread ", dwFlags=" dwFlags ")"  ; _DBG_
		
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
		if this.hwnd = 0
			return
		
		if (this._debug) ; _DBG_
			OutputDebug % ">[" A_ThisFunc "([" this.hwnd "])" ; _DBG_
		
		currPos := this.posSize
		lastPos := this._posStack[1]
		
		; current size/position is identical with previous Size/position
		if (currPos.equal(lastPos)) {
			if (this._debug) ; _DBG_
				OutputDebug % "<[" A_ThisFunc "([" this.hwnd "])] Position has NOT changed!" ; _DBG_
			return
		}
		
		; size/position has been changed -> store it!
		this.__posPush()
				
		if (this._debug) ; _DBG_
			OutputDebug % "<[" A_ThisFunc "([" this.hwnd "])] LastPos: " lastPos.Dump() " - NewPos: " currPos.Dump() ; _DBG_
		return
	}  
	__Delete() {
/* ===============================================================================
Method: __Delete
	Destructor (*INTERNAL*)
*/ 
		if (this.hwnd <= 0) {
			return
		}
		
		if (this._debug) ; _DBG_
				OutputDebug % "|[" A_ThisFunc "([" this.hwnd "])"  ; _DBG_
			
		if (this.__useEventHook == 1) {
			if (this.__hWinEventHook1)
				DllCall( "user32\UnhookWinEvent", Uint,this._hWinEventHook1 )
			if (this.__hWinEventHook2)
				DllCall( "user32\UnhookWinEvent", Uint,this._hWinEventHook2 )
			if (this._HookProcAdr)
				DllCall( "kernel32\GlobalFree", UInt,&this._HookProcAdr ) ; free up allocated memory for RegisterCallback
		}
		
		if (this._debug) ; _DBG_
			OutputDebug % "|[" A_ThisFunc "([" this.hwnd "])"  ; _DBG_
			
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
			this.hwnd := -1
			return
		}
		
		if (!this.__isWindow(_hWnd)) {
			if (this._debug) ; _DBG_
				OutputDebug % ">[" A_ThisFunc "(hWnd=(" _hWnd "))] is NOT a true window. Aborting..." ; _DBG_
			this.hwnd := -1
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
		OutputDebug % "|[" A_ThisFunc "([" Object(A_EventInfo)._hWnd "])(hWinEventHook=" hWinEventHook ", Event=" Event2Str(Event) ", hWnd=" hWnd ", idObject=" idObject ", idChild=" idChild ", dwEventThread=" dwEventThread ", dwmsEventTime=" dwmsEventTime ") -> A_EventInfo: " A_EventInfo ; _DBG_
	
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
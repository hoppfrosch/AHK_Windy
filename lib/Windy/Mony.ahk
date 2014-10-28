; ****** HINT: Documentation can be extracted to HTML using NaturalDocs (http://www.naturaldocs.org/) ************** 

; ****** HINT: Debug-lines should contain "; _DBG_" at the end of lines - using this, the debug lines could be automatically removed through scripts before releasing the sourcecode

/*
	Title: Mony
	Helper Class to handle Multi-Monitor Environments
	
	Author(s):
	<hoppfrosch at hoppfrosch@gmx.de>		

	About: License
	This program is free software. It comes without any warranty, to the extent permitted by applicable law. You can redistribute it and/or modify it under the terms of the Do What The Fuck You Want To Public License, Version 2, as published by Sam Hocevar. See <WTFPL at http://www.wtfpl.net/> for more details.

*/
#include <Windy\Recty>
#include <Windy\Pointy>

; ******************************************************************************************************************************************
class Mony {
	_debug := 0
	_version := "0.2.4"

	; ===== Methods ==================================================================
	identify(disptime := 1500, txtcolor := "000000", txtsize := 300) {
	/*! ===============================================================================
	function: 	identify
	Identify monitors by displaying the monitor id on each monitor
	
	Parameters:
	disptime - time to display the monitor id (*Optional*, Default: 1500[ms])
	txtcolor - color of the displayed monitor id(*Optional*, Default: "000000")
	txtsize - size of the displayed monitor id(*Optional*, Default: 300[px])
	
	Author(s)
    Original - <Bkid at http://ahkscript.org/boards/viewtopic.php?f=6&t=3761&p=19836&hilit=Monitor#p19836>
	*/
		monCnt := this.monCount

		TPColor = AABBCC
		GuiNum = 50
		Loop %monCnt%
		{
    		SysGet, Mon%A_Index%, Monitor, %A_Index%
    		x := Mon%A_Index%Left
    		Gui, %GuiNum%:+LastFound +AlwaysOnTop -Caption +ToolWindow
    		Gui, %GuiNum%:Color, %TPColor%
    		WinSet, TransColor, %TPColor%
    		Gui, %GuiNum%:Font, s%txtsize% w700
    		Gui, %GuiNum%:Add, Text, x0 y0 c%txtcolor%, %A_Index%
    		Gui, %GuiNum%:Show, x%x% y0 NoActivate
    		GuiNum++
		}
		Sleep, %disptime%
		GuiNum = 50
		Loop %monCnt% {
    		Gui, %GuiNum%:Destroy
    		GuiNum++
		}
		return
	}
	monCoordAbsToRel(x,y) {
	/*! ===============================================================================
	function: 	monCoordAbsToRel
	Transforms absolute coordinates into coordinates relative to screen. 
			
	Parameters:
	x,y - absolute coordinates
	
	Returns:
	Object containing relative coordinates and monitorID
	*/
		ret := Object()
		ret.monID := this.monGetFromCoord(x,y)
		
		r := this.monBoundary(ret.monID)
		ret.x := x - r.x
		ret.y := y - r.y
		return ret
	}
	monCoordRelToAbs(monID=1,x=0,y=0) {
	/*! ===============================================================================
	function: 	monCoordRelToAbs
	Transforms coordinates relative to given monitor into absolute (virtual) coordinates
	
	Parameters:
	x,y - relative coordinates on given monitor
	monID - MonitorID
	
	Returns:
	Object containing absolute coordinates
	*/
		ret := Object()
		r := this.monBoundary(monID)
		ret.x := x + r.x
		ret.y := y + r.y
		return ret
	}
	monGetFromCoord(x, y, default=1) {
	/* ===============================================================================
	Function:  monGetFromCoord
	Get the index of the monitor containing the specified x and y coordinates.
	
	Parameters:
	x,y - Coordinates
	default - Default monitor

	Returns:
	Index of the monitor at specified coordinates
	*/
		m := this.monCount
		mon := default
		; Iterate through all monitors.
		Loop, %m%
		{  
			rect := this.monBoundary(A_Index)
			if (x >= rect.x && x <= rect.w && y >= rect.y && y <= rect.h)
				mon := A_Index
		}
		if (this._debug) ; _DBG_
			OutputDebug % "|[" A_ThisFunc "(x=" x ",y= " y ")] -> " mon ; _DBG_
		return mon
	}
	monGetFromMouse(default=1) {
	/* ===============================================================================
	Function:   monGetFromMouse
	Get the index of the monitor where the mouse is
			
	Parameters:
	default - Default monitor
			
	Returns:
	Index of the monitor where the mouse is
	*/
		MouseGetPos,x,y 
		mon := this.monGetFromCoord(x,y,default)
		
		if (this._debug) ; _DBG_
			OutputDebug % "|[" A_ThisFunc "()] -> " mon ; _DBG_
		return mon
	}
	monScaleX(mon1=1, mon2=1) {
	/* ===============================================================================
	Function:  monScaleX
	Determines the scaling factor in x-direction for coordinates when moving from mon1 to mon2
			
	Parameters:
	mon1 - Monitor number of first monitor (*Optonal*, Default:1)
	mon2 - Monitor number of second monitor (*Optonal*, Default:1)
			
	Returns:
	Scaling factor
	*/
		size1 := this.monSize(mon1)
		size2 := this.monSize(mon2)
		scaleX := size2.w / size1.w
		return scaleX
	}
	monScaleY(mon1=1, mon2=1) {
	/* ===============================================================================
	Function:  monScaleY
	Determines the scaling factor in y-direction for coordinates when moving from mon1 to mon2
			
	Parameters:
	mon1 - Monitor number of first monitor (*Optonal*, Default:1)
	mon2 - Monitor number of second monitor (*Optonal*, Default:1)
			
	Returns:
	Scaling factor
	*/
		size1 := this.monSize(mon1)
		size2 := this.monSize(mon2)
		scaleY := size2.h / size1.h
		return scaleY
	}


    ; ===== Properties ==============================================================
    debug[] { ; _DBG_
	/* ------------------------------------------------------------------------------- ; _DBG_
	Property: debug [get/set]                                                          ; _DBG_
	Debug flag for debugging the object                                                ; _DBG_
                                                                                       ; _DBG_
	Value:                                                                             ; _DBG_
	flag - *true* or *false*                                                           ; _DBG_
	*/                                                                                 ; _DBG_
		get {                                                                          ; _DBG_ 
			return this._debug                                                         ; _DBG_
		}                                                                              ; _DBG_
		set {                                                                          ; _DBG_
			mode := value<1?0:1                                                        ; _DBG_
			this._debug := mode                                                        ; _DBG_
			return this._debug                                                         ; _DBG_
		}                                                                              ; _DBG_
	}
	monCenter[ mon:= 1 ] {
	/*! ===============================================================================
	Property: monCenter [get]
	Get the center coordinates of a monitor in Pixel, related to virtual screen as a <point at http://hoppfrosch.github.io/AHK_Windy/files/Pointy-ahk.html>.

	Parameters:
	mon - Monitor number (*Optional*, Default: 1)

	Remarks:
	* There is no setter available, since this is a constant system property
	*/	
		get {
			boundary := this.monBoundary(mon)
			xcenter := floor(boundary.x+(boundary.w-boundary.x)/2)
			ycenter := floor(boundary.y+(boundary.h-boundary.y)/2)
			pt := new Pointy(xcenter, ycenter, this._debug)
			if (this._debug) ; _DBG_
				OutputDebug % "<[" A_ThisFunc "(" mon ")] -> (" pt.dump() ")" ; _DBG_
			return pt
		}
	}
	monBoundary[mon :=1 ] {
	/* ---------------------------------------------------------------------------------------
	Property: monBoundary [get]
	Get the boundaries of a monitor in Pixel (related to virtual screen) as a <rectangle at http://hoppfrosch.github.io/AHK_Windy/files/Recty-ahk.html>.

	Parameters:
	mon - Monitor number (*Optional*, Default: 1)

	Remarks:
	* There is no setter available, since this is a constant system property
	*/
		get {
			SysGet, size, Monitor, %mon%
			rect := new Recty(sizeLeft, sizeTop, sizeRight, sizeBottom, this._debug)
			if (this._debug) ; _DBG_
				OutputDebug % "<[" A_ThisFunc "(" mon ")] -> (" rect.dump() ")" ; _DBG_
			return rect
		}
	}
	monCount[] {
	/* ---------------------------------------------------------------------------------------
	Property: monCount [get]
	Number of available monitors. 

	Remarks:
	* There is no setter available, since this is a constant system property
	*/
		get {
			CoordMode, Mouse, Screen
			SysGet, mCnt, MonitorCount
			if (this._debug) ; _DBG_
				OutputDebug % "|[" A_ThisFunc "() -> (" mCnt ")]" ; _DBG_		
					return mCnt
		}
	}
	monNext[mon := 0, cycle := 1] {
	/* ===============================================================================
	Property:	monNext [get]
	Gets the next monitor starting from given monitor. As default the starting monitor will be taken from current mousepos.
			
	Parameters:
	mon - Monitor number, (*Optional*, Default 0 (= monitor where mouse is on))
	cycle - == 1 cycle through monitors; == 0 stop at last monitor (*Optional*, Default: 1)
			
	Remarks:
	* There is no setter available, since this is a constant system property

	See also: 
	<monPrev [get]>
	*/
		get {
			currMon := mon
			if (mon == 0)
				currMon = this.monGetFromMouse()
			
			nextMon := currMon + 1
			
			if (cycle == 0) {
				if (nextMon > this.monCount) {
					nextMon := this.monCount
				}
			}
			else {
				if (nextMon >  this.monCount) {
					nextMon := Mod(nextMon, this.monCount)
				}
			}
			
			if (this._debug) ; _DBG_
				OutputDebug % "|[" A_ThisFunc "(mon=" mon ",cycle=" cycle ")] -> " nextMon ; _DBG_
			
			return nextMon
		}
	}
	monPrev[mon=0, cycle=1] {
	/* ===============================================================================
	Property:	monPrev [get]
	Gets the previous monitor starting from given monitor. As default the starting monitor will be taken from current mousepos.
			
	Parameters:
	mon - Monitor number, (*Optional*, Default 0 (= monitor where mouse is on))
	cycle - == 1 cycle through monitors; == 0 stop at last monitor (*Optional*, Default: 1)
			
	Remarks:
	* There is no setter available, since this is a constant system property

	See also: 
	<monNext [get]>
	*/
		get {
			currMon := mon
			if (mon == 0)
				currMon = this.monGetFromMouse()
			
			prevMon := currMon - 1
			
			if (cycle == 0) {
				if (prevMon < 1) {
					prevMon := 1
				}
			}
			else {
				if (prevMon < 1) {
					prevMon := this.monCount
				}
			}
			
			if (this._debug) ; _DBG_
				OutputDebug % "|[" A_ThisFunc "(mon=" mon ",cycle=" cycle ")] -> " prevMon ; _DBG_
			
			return prevMon
		}
	}
	monSize[ mon :=1 ] {
	/* ---------------------------------------------------------------------------------------
	Property:  monSize [get]
	Get the size of a monitor in Pixel as a <rectangle at http://hoppfrosch.github.io/AHK_Windy/files/Recty-ahk.html>.
			
	Parameters:
	mon - Monitor number (*Optional*, Default: 1)

	Remarks:
	* There is no setter available, since this is a constant system property

	See also: 
	<monWorkArea [get]>
	*/

		get {
			SysGet, size, Monitor, %mon%
			rect := new Recty(0,0, sizeRight-sizeLeft, sizeBottom-sizeTop, this._debug)
			if (this._debug) ; _DBG_
				OutputDebug % "<[" A_ThisFunc "(" mon ")] -> (" rect.dump() ")" ; _DBG_
			return rect
		}
	}
	monWorkArea[ mon := 1 ] {
	/* ===============================================================================
	Property:  monWorkArea [get]
	Get the working area of a monitor in Pixel as a <rectangle at http://hoppfrosch.github.io/AHK_Windy/files/Recty-ahk.html>.
	
	Same as <monSize [get]>, except the area is reduced to exclude the area occupied by the taskbar and other registered desktop toolbars.
	The working area is given as a <rectangle at http://hoppfrosch.github.io/AHK_Windy/files/Recty-ahk.html>.
	
	Parameters:
	mon - Monitor number  (*Optional*, Default: 1)
	
	Remarks:
	* There is no setter available, since this is a constant system property

	See also: 
	<monSize [get]>
	*/
		get {
			SysGet, size, MonitorWorkArea , %mon%
			rect := new Recty(0,0, sizeRight-sizeLeft, sizeBottom-sizeTop, this._debug)
			if (this._debug) ; _DBG_
				OutputDebug % "<[" A_ThisFunc "(" mon ")] -> (" rect.dump() ")" ; _DBG_
			return rect
		}
	}
	virtualScreenSize[] {
	/* ---------------------------------------------------------------------------------------
	Property: virtualScreenSize [get]
	Get the size of virtual screen in Pixel as a <rectangle at http://hoppfrosch.github.io/AHK_Windy/files/Recty-ahk.html>.
	
	The virtual screen is the bounding rectangle of all display monitors
	
	Remarks:
	* There is no setter available, since this is a constant system property
	*/
		get {
			SysGet, x, 76
			SysGet, y, 77
			SysGet, w, 78
			SysGet, h, 79
			rect := new Recty(x,y,w,h, this._debug)
			if (this._debug) ; _DBG_
				OutputDebug % "<[" A_ThisFunc "()] -> (" rect.dump() ")" ; _DBG_
			return rect
		}
	}

	; ===== Internal Methods =========================================================
	__New(_debug=false) {
	/* ===============================================================================
	Function: __New
	Constructor (*INTERNAL*)
		
	Parameters:
	_debug - Flag to enable debugging (Optional - Default: 0)
	*/  
		this._debug := _debug ; _DBG_
		if (this._debug) ; _DBG_
			OutputDebug % "|[" A_ThisFunc "(_debug=" _debug ")] (version: " this._version ")" ; _DBG_
	}

}
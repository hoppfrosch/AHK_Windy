/*
	Title: MultiMonitorEnv
	Singleton Class to handle Multimonitor-Environments
	
	Author:
	hoppfrosch (hoppfrosch@ahk4.me)
	
	License: 
	This program is free software. It comes without any warranty, to the extent permitted by applicable law. You can redistribute it and/or modify it under the terms of the Do What The Fuck You Want To Public License, Version 2, as published by Sam Hocevar. See http://www.wtfpl.net/ for more details.
	
	Changelog:
	0.1.1 - [-] removed method <Version>()
	0.1.0 - [+] Initial
*/

#include <EDE\Rectangle>
#include <EDE\Point>

; ****** HINT: Documentation can be extracted to HTML using NaturalDocs ************** */

; Global Varibles

; ******************************************************************************************************************************************
; ******************************************************************************************************************************************
class MultiMonitorEnv {
	
	_debug := 0
	_version := "0.1.5"
	
	
	monCoordAbsToRel(x,y) {
		/*! ===============================================================================
			function: 	monCoordAbsToRel
			Transforms absolute coordinates into coordinates relative to screen. 
			
			Parameters:
			x,y - absolute coordinates
			
			Returns:
			Object containing relative coordinates and monitorID
			
			Author(s):
			20140910 - hoppfrosch - Original
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
			Transforms coordinates relative to screen into absolute coordinates
			
			Parameters:
			x,y - relative coordinates
			monID - MonitorID
			
			Returns:
			Object containing absolute coordinates
			
			Author(s):
			20140910 - hoppfrosch - Original
		*/
		ret := Object()
		r := this.monBoundary(monID)
		ret.x := x + r.x
		ret.y := y + r.y
		return ret
	}
	
	monBoundary(mon=1) {
		/*! ===============================================================================
			function: 	monBoundary
			Get the boundaries of a monitor in Pixel, related to virtual screen. 
			
			The virtual screen is the bounding rectangle of all display monitors
			
			Parameters:
			mon - Monitor number
			
			Returns:
			Rectangle containing monitor boundaries
			
			Author(s):
			20121101 - hoppfrosch - Original
		*/
		SysGet, size, Monitor, %mon%
		rect := new Rectangle(sizeLeft, sizeTop, sizeRight, sizeBottom, this._debug)
		if (this._debug) ; _DBG_
			OutputDebug % "<[" A_ThisFunc "(" mon ")] -> (" rect.dump() ")" ; _DBG_
		return rect
	}
	
	monCenter(mon=1) {
		/*! ===============================================================================
			function:	monCenter
			Get the center coordinates of a monitor in Pixel, related to virtual screen. 
			The virtual screen is the bounding rectangle of all display monitors
			
			Parameters:
			mon - Monitor number
			
			Returns:
			Centrer coordinates of monitor
			
			Author(s):
			20121101 - hoppfrosch - Original
		*/
		boundary := this.monBoundary(mon)
		xcenter := floor(boundary.x+(boundary.w-boundary.x)/2)
		ycenter := floor(boundary.y+(boundary.h-boundary.y)/2)
		rect := new Rectangle(xcenter, ycenter, 0, 0, this._debug)
		if (this._debug) ; _DBG_
			OutputDebug % "<[" A_ThisFunc "(" mon ")] -> (" rect.dump() ")" ; _DBG_
		return rect
	}
	
	monCount() {
		/* ===============================================================================
			function:   monCount
			Determines the number of monitors currently attached
			
			Returns:
			Number of monitors
			
			Author(s):
			20121101 - hoppfrosch - Original
		*/
		CoordMode, Mouse, Screen
		SysGet, mCnt, MonitorCount
		if (this._debug) ; _DBG_
			OutputDebug % "|[" A_ThisFunc "()] -> " mCnt ; _DBG_
		return mCnt
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
			
			Author(s):
			Original - Lexikos - http://www.autohotkey.com/forum/topic21703.html
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
			
			Author(s):
			20120322- hoppfrosch: Initial
		*/
		MouseGetPos,x,y 
		mon := this.monGetFromCoord(x,y,default)
		
		if (this._debug) ; _DBG_
			OutputDebug % "|[" A_ThisFunc "()] -> " mon ; _DBG_
		return mon
	}
	
	
	monNext(mon=0, cycle=1) {
		/* ===============================================================================
			function:	monNext
			Gets the next monitor starting from given monitor. As default the starting monitor will be taken from current mousepos.
			
			Parameters:
			mon - Monitor number, Default 0 (= monitor where mouse is on)
			cycle - == 1 cycle through monitors; == 0 stop at last monitor (default 1)
			
			Returns:
			ID of the next monitor
			
			Author(s):
			20121101 - hoppfrosch - Original
		*/
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
	
	
	monPrev(mon=0, cycle=1) {
		/* ===============================================================================
			function:	monPrev
			Gets the previous monitor starting from given monitor. As default the starting monitor will be taken from current mousepos.
			
			Parameters:
			mon - Monitor number, Default 0 (= monitor where mouse is on)
			cycle - = 1 cycle through monitors; = 0 stop at first monitor (default 1)
			
			Returns:
			ID of the next monitor
			
			Author(s):
			20121101 - hoppfrosch - Original
		*/
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
	
	monScaleX(mon1=1, mon2=1) {
		/* ===============================================================================
			Function:  monSize
			Determines the scaling factor in y-direction for coordinates when moving from mon1 to mon2
			
			Parameters:
			mon1 - Monitor number of first monitor
			mon2 - Monitor number of second monitor
			
			Returns:
			Scaling factor
			
			Author(s):
			20140909 - hoppfrosch - Original
		*/
		size1 := this.monSize(mon1)
		size2 := this.monSize(mon2)
		scaleX := size2.w / size1.w
		return scaleX
	}
	
	monScaleY(mon1=1, mon2=1) {
		/* ===============================================================================
			Function:  monSize
			Determines the scaling factor in y-direction for coordinates when moving from mon1 to mon2
			
			Parameters:
			mon1 - Monitor number of first monitor
			mon2 - Monitor number of second monitor
			
			Returns:
			Scaling factor
			
			Author(s):
			20140909 - hoppfrosch - Original
		*/
		size1 := this.monSize(mon1)
		size2 := this.monSize(mon2)
		scaleY := size2.h / size1.h
		return scaleY
	}
	
	
	monSize(mon=1) {
		/* ===============================================================================
			Function:  monSize
			Get the size of a monitor in Pixel
			
			Parameters:
			mon - Monitor number
			
			Returns:
			Rectangle containing monitor size
			
			Author(s):
			20121101 - hoppfrosch - Original
		*/
		
		SysGet, size, Monitor, %mon%
		rect := new Rectangle(0,0, sizeRight-sizeLeft, sizeBottom-sizeTop, this._debug)
		if (this._debug) ; _DBG_
			OutputDebug % "<[" A_ThisFunc "(" mon ")] -> (" rect.dump() ")" ; _DBG_
		return rect
	}
	
	monWorkArea(mon=1) {
		/* ===============================================================================
			Function:  monWorkArea
			Same as <monSize>, except the area is reduced to exclude the area occupied by the taskbar and other registered desktop toolbars.
			
			Parameters:
			mon - Monitor number
			
			Returns:
			Rectangle containing monitor working area
			
			Author(s):
			20130322 - hoppfrosch - Original
		*/
		
		SysGet, size, MonitorWorkArea , %mon%
		rect := new Rectangle(0,0, sizeRight-sizeLeft, sizeBottom-sizeTop, this._debug)
		if (this._debug) ; _DBG_
			OutputDebug % "<[" A_ThisFunc "(" mon ")] -> (" rect.dump() ")" ; _DBG_
		return rect
	}
	
	virtualScreenSize() {
		/* ===============================================================================
			Function:  virtualScreenSize
			Get the size of virtual screen in Pixel
			
			The virtual screen is the bounding rectangle of all display monitors
			
			Parameters:
			mon - Monitor number
			
			Returns:
			Rectangle containing monitor size
			
			Author(s):
			20121101 - hoppfrosch - Original
		*/
		
		; Get position and size of virtual screen.
		SysGet, x, 76
		SysGet, y, 77
		SysGet, w, 78
		SysGet, h, 79
		rect := new Rectangle(x,y,w,h, this._debug)
		if (this._debug) ; _DBG_
			OutputDebug % "<[" A_ThisFunc "()] -> (" rect.dump() ")" ; _DBG_
		return rect
	}
	
	/*
		===============================================================================
		Function: __Get
		Custom Getter for attributes
		
		Author(s):
		20121030 - hoppfrosch - Original
		===============================================================================
	*/    
	__Get(aName) {
		if (this._debug) ; _DBG_
			OutputDebug % ">[" A_ThisFunc "(" aName ")]" ; _DBG_
		if (aName = "monCount") { ; current position
			return this.monCount()
		}
		return
	}
	
	/*
		===============================================================================
		Function: __New
		Constructor
		
		Parameters:
		_debug - Flag to enable debugging (Optional - Default: 0)
		
		Author(s):
		20121031 - hoppfrosch - Original
		===============================================================================
	*/     
	__New(_debug=false) {
		this._debug := _debug ; _DBG_
		if (this._debug) ; _DBG_
			OutputDebug % "|[" A_ThisFunc "(_debug=" _debug ")] (version: " this._version ")" ; _DBG_
	}
}
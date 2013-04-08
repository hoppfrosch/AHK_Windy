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

#include <Rectangle>

; ****** HINT: Documentation can be extracted to HTML using NaturalDocs ************** */

; Global Varibles

; ******************************************************************************************************************************************
; ******************************************************************************************************************************************
class MultiMonitorEnv {
	
	_debug := 0
	_version := "0.1.2"
	

/*
===============================================================================
function: 	monBoundary
	Get the boundaries of a monitor in Pixel, related to virtual screen. 
	
	The virtual screen is the bounding rectangle of all display monitors
	
Parameters:
    mon - Monitor number
  
Returns:
   Rectangle containing monitor boundaries

Author(s):
    20121101 - hoppfrosch - Original
===============================================================================
*/
	monBoundary(mon=1) {
		SysGet, size, Monitor, %mon%
		rect := new Rectangle(sizeLeft, sizeTop, sizeRight, sizeBottom, this._debug)
		if (this._debug) ; _DBG_
			OutputDebug % "<[" A_ThisFunc "(" mon ")] -> (" rect.dump() ")" ; _DBG_
		return rect
	}
	
/*
===============================================================================
function:	monCenter
    Get the center coordinates of a monitor in Pixel, related to virtual screen. 
	The virtual screen is the bounding rectangle of all display monitors
	
Parameters:
    mon - Monitor number
  
Returns:
   Centrer coordinates of monitor

Author(s):
    20121101 - hoppfrosch - Original
===============================================================================
*/
	monCenter(mon=1) {
		boundary := this.monBoundary(mon)
		xcenter := floor(boundary.x+(boundary.w-boundary.x)/2)
		ycenter := floor(boundary.y+(boundary.h-boundary.y)/2)
		rect := new Rectangle(xcenter, ycenter, 0, 0, this._debug)
		if (this._debug) ; _DBG_
			OutputDebug % "<[" A_ThisFunc "(" mon ")] -> (" rect.dump() ")" ; _DBG_
		return rect
	}
	
/*
===============================================================================
function:   monCount
	Determines the number of monitors currently attached
  
Returns:
   Number of monitors

Author(s):
	20121101 - hoppfrosch - Original
===============================================================================
*/
	monCount() {
		SysGet, mCnt, MonitorCount
		if (this._debug) ; _DBG_
			OutputDebug % "|[" A_ThisFunc "()] -> " mCnt ; _DBG_
		return mCnt
	}

/*
===============================================================================
Function:  monGetFromCoord
    Get the index of the monitor containing the specified x and y coordinates.

Parameters:
    x,y - Coordinates
    default - Default monitor
  
Returns:
   Index of the monitor at specified coordinates

Author(s):
    Original - Lexikos - http://www.autohotkey.com/forum/topic21703.html
===============================================================================
*/
	monGetFromCoord(x, y, default=1) {
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
	
/*
===============================================================================
Function:   monGetFromMouse
    Get the index of the monitor where the mouse is

Parameters:
    default - Default monitor
  
Returns:
    Index of the monitor where the mouse is

Author(s):
    20120322- hoppfrosch: Initial
===============================================================================
*/
	monGetFromMouse(default=1) {
		MouseGetPos,x,y 
		mon := this.monGetFromCoord(x,y,default)
		
		if (this._debug) ; _DBG_
			OutputDebug % "|[" A_ThisFunc "()] -> " mon ; _DBG_
		return mon
	}
	
/*
===============================================================================
Function:  monSize
    Get the size of a monitor in Pixel

Parameters:
    mon - Monitor number
  
Returns:
   Rectangle containing monitor size

Author(s):
    20121101 - hoppfrosch - Original
===============================================================================
*/
	monSize(mon=1) {
		SysGet, size, Monitor, %mon%
		rect := new Rectangle(0,0, sizeRight-sizeLeft, sizeBottom-sizeTop, this._debug)
		if (this._debug) ; _DBG_
			OutputDebug % "<[" A_ThisFunc "(" mon ")] -> (" rect.dump() ")" ; _DBG_
		return rect
	}

/*
===============================================================================
Function:  monWorkArea
    Same as <monSize>, except the area is reduced to exclude the area occupied by the taskbar and other registered desktop toolbars.

Parameters:
    mon - Monitor number
  
Returns:
   Rectangle containing monitor working area

Author(s):
    20130322 - hoppfrosch - Original
===============================================================================
*/
	monWorkArea(mon=1) {
		SysGet, size, MonitorWorkArea , %mon%
		rect := new Rectangle(0,0, sizeRight-sizeLeft, sizeBottom-sizeTop, this._debug)
		if (this._debug) ; _DBG_
			OutputDebug % "<[" A_ThisFunc "(" mon ")] -> (" rect.dump() ")" ; _DBG_
		return rect
	}
/*
===============================================================================
Function:  virtualScreenSize
    Get the size of virtual screen in Pixel
	
	The virtual screen is the bounding rectangle of all display monitors

Parameters:
    mon - Monitor number
  
Returns:
   Rectangle containing monitor size

Author(s):
    20121101 - hoppfrosch - Original
===============================================================================
*/
	virtualScreenSize() {
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
/*
	Title: Rectangle
		Class to handle Rectangles

	Author: 
		hoppfrosch (hoppfrosch@ahk4.me)
		
	License: 
		This program is free software. It comes without any warranty, to the extent permitted by applicable law. You can redistribute it and/or modify it under the terms of the Do What The Fuck You Want To Public License, Version 2, as published by Sam Hocevar. See http://www.wtfpl.net/ for more details.
		
	Changelog:
		0.2.0 - [+] Compare functionality <equal>, <equalPos>, <equalSize>
		0.1.0 - [+] Initial
*/
	
; ****** HINT: Documentation can be extracted to HTML using NaturalDocs ************** */

; Global Varibles

; ******************************************************************************************************************************************
class Rectangle {
	
	_version := "0.2.0"
	_debug := 0 ; _DBG_	
	x := 0
	y := 0
	w := 0
	h := 0


/*
===============================================================================
Function: Dump
	Dumps coordinates to a string

Parameters:
	new - Rectangle

Returns:
	printable string

Author(s):
	20130311 - hoppfrosch@ahk4.me - Original
===============================================================================
*/  
	Dump() {
		return "(" this.x "," this.y "," this.w "," this.h ")"
	}

/*
===============================================================================
Function: equal
	Compares currrent rectangle to given rectangle

Parameters:
	comp - Rectangle to compare with

Returns:
	true or false

See also: <equalPos>, <equalSize>

Author(s):
	20130311 - hoppfrosch@ahk4.me - Original
===============================================================================
*/  
	equal(comp) {
		return this.equalPos(comp) AND this.equalSize(comp)
	}

/*
===============================================================================
Function: equalPos
	Compares currrent rectangle position to given rectangle

Parameters:
	comp - Rectangle to compare with

Returns:
	true or false

See also: <equal>, <equalSize>

Author(s):
	20130311 - hoppfrosch@ahk4.me - Original
===============================================================================
*/  
	equalPos(comp) {
		return (this.x == comp.x) AND (this.y == comp.y)
	}
	
/*
===============================================================================
Function: equalSize
	Compares currrent rectangle size to given rectangle

Parameters:
	comp - Rectangle to compare with

Returns:
	true or false
	
See also: <equalPos>, <equal>


Author(s):
	20130311 - hoppfrosch@ahk4.me - Original
===============================================================================
*/  
	equalSize(comp) {
		ret := (this.w == comp.w)  AND (this.h == comp.h)
		return ret
	}

/*
===============================================================================
Function: fromHWnd
	Fills values from given Window (given by Handle)

Parameters:
	hWnd - Window handle, whose geometry has to be determined

See also: <fromWinPos>

Author(s):
	20130311 - hoppfrosch@ahk4.me - Original
===============================================================================
*/  
	fromHWnd(hwnd) {
		WinGetPos, x, y, w, h, ahk_id %hwnd%
		this.x := x
		this.y := y
		this.w := w
		this.h := h
		if (this._debug) ; _DBG_
			OutputDebug % "|[" A_ThisFunc "([" hwnd "])] -> x,y,w,h: (" x "," y "," w "," h ")" ; _DBG_
	}

/*
===============================================================================
Function: fromRectangle
	Fills values from <Rectangle>

Parameters:
	new - Rectangle

See also: <fromHWnd>

Author(s):
	20130311 - hoppfrosch@ahk4.me - Original
===============================================================================
*/  
	fromRectangle(new) {
		this.x := new.x 
		this.y := new.y
		this.w := new.w
		this.h := new.h
		if (this._debug) ; _DBG_
			OutputDebug % "|[" A_ThisFunc "] -> x,y,w,h: " this.Dump() ; _DBG_
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
			return this._debug ; _DBG_
		value := value<1?0:1 ; _DBG_
		this._debug := value ; _DBG_
		return this._debug ; _DBG_
	} ; _DBG_

/*
===============================================================================
Function: __Get
	Custom Getter Function (*INTERNAL*)
	
	Currently the following attributes can be retrieved
	* **x,y,w,h** - native attributes
	* **xul, yul, xlr, ylr** - derived attributes (Upper left/Lower Right corner)
	
Author(s):
	20121030 - hoppfrosch - Original
===============================================================================
*/    
	__Get(aName) {
        if (aName = "xul") ; x - upper left corner
			return this.x
		if (aName = "yul") ; y - upper left corner
			return this.y
		if (aName = "xlr") ; x - lower right corner
			return this.x+this.w
		if (aName = "ylr") ; y - lower right left corner
			return this.y+this.h
			
		return
	}

/*
===============================================================================
Function: __New
	Constructor (*INTERNAL*)

Parameters:
	x,y,w,h - X,Y (upper left corner coordinates) and Width, Height of the rectangle
	debug - Flag to enable debugging (Optional - Default: 0)

Author(s):
	20120621 - hoppfrosch - Original
===============================================================================
*/     
	__New(x=0, y=0, w=0, h=0, debug=false) {
		this._debug := debug ; _DBG_
		if (this._debug) ; _DBG_
			OutputDebug % "|[" A_ThisFunc "(x=" x ", y=" y ", w=" w ", h=" h ", _debug=" debug ")] (version: " this._version ")" ; _DBG_
		this.x := x
		this.y := y
		this.w := w
		this.h := h
	}

/*
===============================================================================
Function: __Set
	Custom Setter Function (*INTERNAL*)
	
	Currently the following attributes can be set
	* x,y,w,h - native attributes
	* xul, yul, xlr, ylr - derived attributes (Upper left/Lower Right corner)
	
Author(s):
	20121030 - hoppfrosch - Original
===============================================================================
*/    
	__Set(aName, aValue) {
        if aName in xul,yul,xlr,ylr
		{
            if (aName = "xul")
				this.x := aValue
			else if (aName = "yul")
				this.y := aValue
			else if (aName = "xlr")
				this.w := aValue - this.x
			else if (aName = "ylr")
				this.h := aValue - this.y
				
			return aValue
		}
	}
}


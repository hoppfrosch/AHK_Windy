/*
	Title: Rectangle
		Class to handle Rectangles

	Author: 
		hoppfrosch (hoppfrosch@ahk4.me)
		
	License: 
		WTFPL (http://sam.zoy.org/wtfpl/)
		
	Changelog:
		0.1.0 - [+] Initial
*/
	
; ****** HINT: Documentation can be extracted to HTML using NaturalDocs ************** */

; Global Varibles

; ******************************************************************************************************************************************
class Rectangle {
	
	_version := "0.1.1"
	_debug := 0 ; _DBG_	
	x := 0
	y := 0
	w := 0
	h := 0

	Dump() {
		return "(" this.x "," this.y "," this.w "," this.h ")"
	}
		
	fromHWnd(hwnd) {
		WinGetPos, x, y, w, h, ahk_id %hwnd%
		this.x := x
		this.y := y
		this.w := w
		this.h := h
		if (this._debug) ; _DBG_
			OutputDebug % "|[" A_ThisFunc "([" hwnd "])] -> x,y,w,h: (" x "," y "," w "," h ")" ; _DBG_
	}

	fromWinPos(new) {
		this.x := new.x 
		this.y := new.y
		this.w := new.w
		this.h := new.h
		if (this._debug) ; _DBG_
			OutputDebug % "|[" A_ThisFunc "] -> x,y,w,h: " this.Dump() ; _DBG_
	}

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
	Custom Getter Function
	
	Currently the following attributes can be retrieved
	* x,y,w,h - native attributes
	* xul, yul, xlr, ylr - derived attributes (Upper left/Lower Right corner)

	This function is not to be called directly - it's called automagically when accessing an attribute
	
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
	Constructor

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
			OutputDebug % "|[" A_ThisFunc "(x=(" x ", y=" y ", w=" w ", h=" h ", _debug=" debug ")] (version: " this._version ")" ; _DBG_
		this.x := x
		this.y := y
		this.w := w
		this.h := h
	}

/*
===============================================================================
Function: __Set
	Custom Setter Function
	
	Currently the following attributes can be set
	* x,y,w,h - native attributes
	* xul, yul, xlr, ylr - derived attributes (Upper left/Lower Right corner)

	This function is not to be called directly - it's called automagically when assigning a value to an attribute
	
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


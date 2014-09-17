; ****** HINT: Documentation can be extracted to HTML using GenDocs (https://github.com/fincs/GenDocs) by fincs************** */

class Rectangle {
; ******************************************************************************************************************************************
/*!
	Class: Rectangle
		Handling rectangles (given through [x, y (upper-left corner), w, h] or [x, y (upper-left corner), x, y (lower-right corner)])
		
	Remarks:
		### License
			This program is free software. It comes without any warranty, to the extent permitted by applicable law. You can redistribute it and/or modify it under the terms of the Do What The Fuck You Want To Public License, Version 2, as published by Sam Hocevar. See [WTFPL](http://www.wtfpl.net/) for more details.
		### Author
			[hoppfrosch](hoppfrosch@ahk4.me)		
	@UseShortForm
*/	
	_version := "0.2.0"
	_debug := 0 ; _DBG_	
	x := 0
	y := 0
	w := 0
	h := 0

	Dump() {
	/*! ===============================================================================
		Method: Dump()
			Dumps coordinates to a string
		Returns:
			printable string containing coordinates
		Remarks:
			### Author(s)
				* 20130311 - [hoppfrosch](hoppfrosch@ahk4.me) - Original
	*/

		return "(" this.x "," this.y "," this.w "," this.h ")"
	}

	equal(comp) {
	/*! ===============================================================================
		Method: equal(comp)
			Compares currrent rectangle to given rectangle
		Parameters:
			comp - [Rectangle](Rectangle.html) to compare with
		Returns:
			true or false
		Remarks:
			### See also: 
				[equalPos()](#equalPos), [equalSize()](#equalSize)
				
			### Author(s)
				* 20130311 - [hoppfrosch](hoppfrosch@ahk4.me) - Original
	*/

		return this.equalPos(comp) AND this.equalSize(comp)
	}

	equalPos(comp) {
	/*! ===============================================================================
		Method: equalPos(comp)
			Compares currrent rectangle position to given rectangle position
		Parameters:
			comp - [Rectangle](Rectangle.html) to compare with
		Returns:
			true or false
		Remarks:
			### See also: 
				[equal()](#equal), [equalSize()](#equalSize)
				
			### Author(s)
				* 20130311 - [hoppfrosch](hoppfrosch@ahk4.me) - Original
	*/

		return (this.x == comp.x) AND (this.y == comp.y)
	}

	equalSize(comp) {
	/*! ===============================================================================
		Method: equalSize(comp)
			Compares currrent rectangle size to given rectangle size
		Parameters:
			comp - [Rectangle](Rectangle.html) to compare with
		Returns:
			true or false
		Remarks:
			### See also: 
				[equal()](#equal), [equalPos()](#equalPos)
				
			### Author(s)
				* 20130311 - [hoppfrosch](hoppfrosch@ahk4.me) - Original
	*/
		ret := (this.w == comp.w)  AND (this.h == comp.h)
		return ret
	}

	fromHWnd(hwnd) {
	/*! ===============================================================================
		Method: fromHWnd(hwnd)
			Fills values from given Window (given by Handle)
		Parameters:
			hWnd - Window handle, whose geometry has to be determined
		Remarks:
			### See also: 
				[fromWinPos()](#fromWinPos)
				
			### Author(s)
				* 20130311 - [hoppfrosch](hoppfrosch@ahk4.me) - Original
	*/
		WinGetPos, x, y, w, h, ahk_id %hwnd%
		this.x := x
		this.y := y
		this.w := w
		this.h := h
		if (this._debug) ; _DBG_
			OutputDebug % "|[" A_ThisFunc "([" hwnd "])] -> x,y,w,h: (" x "," y "," w "," h ")" ; _DBG_
	}

	fromRectangle(new) {
	/*! ===============================================================================
		Method: fromRectangle(new)
			Fills values from given [Rectangle](Rectangle.html)
		Parameters:
			new - Rectangle
		Remarks:
			### Author(s)
				* 20130311 - [hoppfrosch](hoppfrosch@ahk4.me) - Original
	*/
		this.x := new.x 
		this.y := new.y
		this.w := new.w
		this.h := new.h
		if (this._debug) ; _DBG_
			OutputDebug % "|[" A_ThisFunc "] -> x,y,w,h: " this.Dump() ; _DBG_
	}

	__debug(value="") { ; _DBG_
/* ===============================================================================
	Method: __debug
		Set or get the debug flag (*INTERNAL*)

	Parameters:
		value - Value to set the debug flag to (OPTIONAL)

	Returns:
		true or false, depending on current value

	Remarks:
			### Author(s)
				* 20130311 - [hoppfrosch](hoppfrosch@ahk4.me) - Original
*/  
		if % (value="") ; _DBG_
			return this._debug ; _DBG_
		value := value<1?0:1 ; _DBG_
		this._debug := value ; _DBG_
		return this._debug ; _DBG_
	} ; _DBG_

	__Get(aName) {
	/* ===============================================================================
		Method: __Get
			Custom Getter Function (*INTERNAL*)
		
		
		Remarks:
			### Author(s)
				* 20130311 - [hoppfrosch](hoppfrosch@ahk4.me) - Original
	*/    
		/*! ---------------------------------------------------------------------------------------
			Property: x [get/set]
				Get or Set x-coordinate of the upper left corner of the rectangle
				
				This is identical to property [xul](#xul)
		*/
		
		/*! ---------------------------------------------------------------------------------------
			Property: y [get/set]
				Get or Set y-coordinate of the upper left corner of the rectangle
				
				This is identical to property [yul](#yul)
		*/
		
		/*! ---------------------------------------------------------------------------------------
			Property: w [get/set]
				Get or Set the width of the rectangle
		*/
		
		/*! ---------------------------------------------------------------------------------------
			Property: h [get/set]
				Get or Set the height of the rectangle
		*/

        if (aName = "xul") ; x - upper left corner
		/*! ---------------------------------------------------------------------------------------
			Property: xul [get/set]
				Get or Set x-coordinate of the upper left corner of the rectangle			
				
				This is identical to property [x](#x)
		*/
			return this.x
		if (aName = "yul") ; y - upper left corner
		/*! ---------------------------------------------------------------------------------------
			Property: yul [get/set]
				Get or Set y-coordinate of the upper left corner of the rectangle			
				
				This is identical to property [y](#y)
		*/
			return this.y
		if (aName = "xlr") ; x - lower right corner
		/*! ---------------------------------------------------------------------------------------
			Property: xlr [get/set]
				Get or Set x-coordinate of the lower right corner of the rectangle			
		*/
			return this.x+this.w
		if (aName = "ylr") ; y - lower right left corner
		/*! ---------------------------------------------------------------------------------------
			Property: ylr [get/set]
				Get or Set y-coordinate of the lower right corner of the rectangle			
		*/
			return this.y+this.h
			
		return
	}

	__New(x=0, y=0, w=0, h=0, debug=false) {
	/* ===============================================================================
	Method: __New
		Constructor (*INTERNAL*)

	Parameters:
		x,y,w,h - X,Y (upper left corner coordinates) and Width, Height of the rectangle
		debug - Flag to enable debugging (Optional - Default: 0)

	Remarks:
			### Author(s)
				* 20130311 - [hoppfrosch](hoppfrosch@ahk4.me) - Original
	*/     

		this._debug := debug ; _DBG_
		if (this._debug) ; _DBG_
			OutputDebug % "|[" A_ThisFunc "(x=" x ", y=" y ", w=" w ", h=" h ", _debug=" debug ")] (version: " this._version ")" ; _DBG_
		this.x := x
		this.y := y
		this.w := w
		this.h := h
	}

	__Set(aName, aValue) {
	/* ===============================================================================
	Method: __Set
		Custom Setter Function (*INTERNAL*)
		
	Remarks:
			### Author(s)
				* 20130310 - [hoppfrosch](hoppfrosch@ahk4.me) - Original
	*/    
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

/*!
	End of class
*/

; ****** HINT: Documentation can be extracted to HTML using GenDocs (https://github.com/fincs/GenDocs) by fincs************** */

#include <EDE\Point>

class Mouse {
; ******************************************************************************************************************************************
/*!
Class: Mouse
	toolset to handle mousecursor within a MultiMonitorEnvironment
	
Remarks:
	### License
		This program is free software. It comes without any warranty, to the extent permitted by applicable law. You can redistribute it and/or modify it under the terms of the Do What The Fuck You Want To Public License, Version 2, as published by Sam Hocevar. See [WTFPL](http://www.wtfpl.net/) for more details.
	### Author
		[hoppfrosch](hoppfrosch@gmx.de)		
@UseShortForm
*/
	
	_version := "0.1.1"
	_debug := 0 ; _DBG_	


	Dump() {
/*! ===============================================================================
Method: Dump()
	Dumps coordinates to a string
Returns:
	printable string containing coordinates
Remarks:
	### Author(s)
		* 20140909 - [hoppfrosch](hoppfrosch@gmx.de) - Original
*/
		return "(" this.x "," this.y ")"
	}

	locate() {
/*! ===============================================================================
Method: locate()
	Easy find the mouse
Remarks:
	### Author(s)
		* 20110127 - [hoppfrosch](hoppfrosch@gmx.de) - Original
*/
	    applicationname := A_ScriptName
	    
	    SetWinDelay,0 
	    DetectHiddenWindows,On
	    CoordMode,Mouse,Screen
	    
	    delay := 100
	    size1 := 250
	    size2 := 200
	    size3 := 150
	    size4 := 100
	    size5 := 50
	    col1 := "Red"
	    col2 := "Blue"
	    col3 := "Yellow"
	    col4 := "Lime"
	    col5 := "Green"
	    boldness1 := 700
	    boldness2 := 600
	    boldness3 := 500
	    boldness4 := 400
	    boldness5 := 300
	    
	    Transform, OutputVar, Chr, 177
	    
	    Loop,5
	    { 
	      MouseGetPos,x,y 
	      size:=size%A_Index%
	      width:=Round(size%A_Index%*1.4)
	      height:=Round(size%A_Index%*1.4)
	      colX:=col%A_Index%
	      boldness:=boldness%A_Index%
	      Gui,%A_Index%:Destroy
	      Gui,%A_Index%:+Owner +AlwaysOnTop -Resize -SysMenu -MinimizeBox -MaximizeBox -Disabled -Caption -Border -ToolWindow 
	      Gui,%A_Index%:Margin,0,0 
	      Gui,%A_Index%:Color,123456
	      
	      Gui,%A_Index%:Font,c%colX% S%size% W%boldness%,Wingdings
	      Gui,%A_Index%:Add,Text,,%OutputVar%
	      
	      Gui,%A_Index%:Show,X-%width% Y-%height% W%width% H%height% NoActivate,%applicationname%%A_Index%
	      WinSet,TransColor,123456,%applicationname%%A_Index%
	    }
	    Loop,5
	    {
	        MouseGetPos,x,y 
	        WinMove,%applicationname%%A_Index%,,% x-size%A_Index%/1.7,% y-size%A_Index%/1.4
	        WinShow,%applicationname%%A_Index%
	        Sleep,%delay%
	        WinHide,%applicationname%%A_Index%
	        ;Sleep,%delay% 
	    }

	    Loop,5
	    { 
	        Gui,%A_Index%:Destroy
	    }
	}
	
	__debug(value="") { ; _DBG_
/*! ===============================================================================
Method:  __debug
	Set or get the debug flag (*INTERNAL*)

Parameters:
	value - Value to set the debug flag to (OPTIONAL)

Returns:
	true or false, depending on current value

Remarks:
	### Author(s)
		* 20140908 - [hoppfrosch](hoppfrosch@gmx.de) - Original
*/  
		if % (value="") ; _DBG_
			return this._debug ; _DBG_
		value := value<1?0:1 ; _DBG_
		this._debug := value ; _DBG_
		return this._debug ; _DBG_
	} ; _DBG_

	__Get(aName) {
/*! ===============================================================================
Method: __Get
	Custom Getter Function (*INTERNAL*)
	
Remarks:
	### Author(s)
		* 20140908 - [hoppfrosch](hoppfrosch@gmx.de) - Original
*/    
		if (aName = "x")  { 
		/*! ---------------------------------------------------------------------------------------
			Property: x [get/set]
				Get or Set x-coordinate of the upper left corner of the rectangle
				
				This is identical to property [xul](#xul)
		*/
			return this.pos.x
		}

		 if (aName = "y")  { 
		/*! ---------------------------------------------------------------------------------------
			Property: y [get/set]
				Get or Set y-coordinate of the mouse position
				
				This is identical to property [yul](#yul)
		*/
			return this.pos.x
		}

        if (aName = "pos")  { ; x,y - coordinates as Point
		/*! ---------------------------------------------------------------------------------------
			Property: pos [get/set]
				Get or Set the mouse position
		*/
			pt := new Point()
			return pt.fromMouse()
		}
			
		return
	}

	__New(debug=false) {
/*! ===============================================================================
Method: __New
	Constructor (*INTERNAL*)

Parameters:
	debug - Flag to enable debugging (Optional - Default: 0)

Remarks:
	### Author(s)
		* 20140908 - [hoppfrosch](hoppfrosch@gmx.de) - Original
*/     
		this._debug := debug ; _DBG_
		if (this._debug) ; _DBG_
			OutputDebug % "|[" A_ThisFunc ")] (version: " this._version ")" ; _DBG_
	}
}

/*!
	End of class
*/
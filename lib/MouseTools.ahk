; ****** HINT: Documentation can be extracted to HTML using GenDocs (https://github.com/fincs/GenDocs) by fincs************** */

#include <Rectangle>

; ******************************************************************************************************************************************
/*!
Class: MouseTools
	toolset to handle mousecursor within a MultiMonitorEnvironment
	
Remarks:
	### License
		This program is free software. It comes without any warranty, to the extent permitted by applicable law. You can redistribute it and/or modify it under the terms of the Do What The Fuck You Want To Public License, Version 2, as published by Sam Hocevar. See [WTFPL](http://www.wtfpl.net/) for more details.
	### Author
		[hoppfrosch](hoppfrosch@gmx.de)		
@UseShortForm
*/
class MouseTools {
	
	_version := "0.1.0"
	_debug := 0 ; _DBG_	


/*! ===============================================================================
Method: Dump()
	Dumps coordinates to a string
Returns:
	printable string containing coordinates
Remarks:
	### Author(s)
		* 20130311 - [hoppfrosch](hoppfrosch@gmx.de) - Original
*/
	Dump() {
		return "(" ")"
	}

/*! ===============================================================================
Method: locate(comp)
	Easy find the mouse
Remarks:
	### Author(s)
		* 20110127 - [hoppfrosch](hoppfrosch@gmx.de) - Original
*/
	locate() {
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
	__debug(value="") { ; _DBG_
		if % (value="") ; _DBG_
			return this._debug ; _DBG_
		value := value<1?0:1 ; _DBG_
		this._debug := value ; _DBG_
		return this._debug ; _DBG_
	} ; _DBG_

/*! ===============================================================================
Method: __New
	Constructor (*INTERNAL*)

Parameters:
	debug - Flag to enable debugging (Optional - Default: 0)

Remarks:
	### Author(s)
		* 20140908 - [hoppfrosch](hoppfrosch@gmx.de) - Original
*/     
	__New(debug=false) {
		this._debug := debug ; _DBG_
		if (this._debug) ; _DBG_
			OutputDebug % "|[" A_ThisFunc ")] (version: " this._version ")" ; _DBG_
	}
}

/*!
	End of class
*/
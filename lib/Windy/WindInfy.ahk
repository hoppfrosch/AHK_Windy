; ****** HINT: Documentation can be extracted to HTML using NaturalDocs (http://www.naturaldocs.org/) ************** 

; ****** HINT: Debug-lines should contain "; _DBG_" at the end of lines - using this, the debug lines could be automatically deleted through scripts before releasing the sourcecode
#include %A_LineFile%\..
#include Windy.ahk
#include Const_WinUser.ahk
#include JSON.ahk
#include ..\DbgOut.ahk

/* ******************************************************************************************************************************************
	Class: WindLy
	Class to serialize configuration of a window and to restore it

	Author(s):
	<hoppfrosch at hoppfrosch@gmx.de>		

	About: License
	This program is free software. It comes without any warranty, to the extent permitted by applicable law. You can redistribute it and/or modify it under the terms of the Do What The Fuck You Want To Public License, Version 2, as published by Sam Hocevar. See <WTFPL at http://www.wtfpl.net/> for more details.
*/
class WindInfy {
	_debug := 0
	_version := "0.0.1"

	; ##################### Properties (AHK >1.1.16.x) #################################################################

	; ######################## Methods to be called directly ########################################################### 
	/* -------------------------------------------------------------------------------
	Method:	fromWindy
	Constructor - extracts info from <Windy at http://hoppfrosch.github.io/AHK_Windy/files/Windy-ahk.html>-Object into a new instance
	
	Parameters:
	oWindy - <Windy at http://hoppfrosch.github.io/AHK_Windy/files/Windy-ahk.html>-Object

	Returns:
	new instance of this class
	*/
	fromWindy(oWindy) {
  	dbgOut(">[" A_ThisFunc "(" oWindy.hwnd ")]")
		oWindInfy := new WindInfy()
		oWindInfy.classname := oWindy.classname
		oWindInfy.processname := oWindy.processname
		oWindInfy.pid := oWindy.processID
		oWindInfy.processfullpath := WindInfy._GetModuleFileNameEx(oWindy.processID)
		oWindInfy.style := oWindy.style
		oWindInfy.styleEx := oWindy.styleEx
		oWindInfy.rolledUp := oWindy.rolledUp
		oWindInfy.x := oWindy.posSize.x
		oWindInfy.y := oWindy.posSize.y
		oWindInfy.width := oWindy.posSize.w
		oWindInfy.height := oWindy.posSize.h
    dbgOut("<[" A_ThisFunc "(" oWindy.hwnd ")] -> ...")
		return oWindInfy
	}
  /* -------------------------------------------------------------------------------
	Method:	fromJSON
	Constructor - extracts info from a JSON string into a new instance
	
	Parameters:
	stry - JSON-string

	Returns:
	new instance of this class
	*/
	fromJSON(str) {
  	dbgOut("=[" A_ThisFunc "(str=" str ")]")
    obj := JSON.Load(str)
  	oWindInfy := new WindInfy()
  	for key, value in obj {
    	if (SubStr(key, 1, 1) == "_") { ; Klasseninterne Variable werden ja automatisch gesetzt - und nicht von extern!
      	if (key == "_version") { ; Hier koennen evtl. Versionunterschiede angepasst werden
      	  continue
    	  }
    	  else
      	  continue
    	}
    	oWindInfy[key] := value
  	}
  	return oWindInfy
	}
	

	/* -------------------------------------------------------------------------------
	Method:	toJSON
	Dumps the class content into JSON String
	
	Parameters:
	indent - amount of  spaces used for indentification

	Returns:
	JSON-String
	*/
	toJSON(indent=0) {
  	dbgOut(">[" A_ThisFunc "(indent: " indent ")]")
		str := JSON.Dump(this,indent)
		dbgOut("<[" A_ThisFunc "()] -> " str)
		return str
	}
	
	; ######################## Internal Methods - not to be called directly ############################################
	; ===== Internal Methods =========================================================	
	/* ---------------------------------------------------------------------------------------
	Method: __New
		Constructor (*INTERNAL*)

	Parameters:
		_debug - Flag to enable debugging (Optional - Default: 0)
	*/   
	__New(_debug=0) {
		this._debug := _debug
	  dbgOut(">[" A_ThisFunc "()] (version: " this._version ")")

		if % (A_AhkVersion < "1.1.21.0" || A_AhkVersion >= "2.0") {
			MsgBox 16, Error, %A_ThisFunc% :`n This class only needs AHK later than 1.1.20.01 (and before 2.0)`nAborting...
			if (this._debug) ; _DBG_
				dbgOut("<[" A_ThisFunc "(...) -> ()]: *ERROR* : This class needs AHK later than 1.1.21 (and before 2.0). Aborting...")
			return
		}
				
		dbgOut("<[" A_ThisFunc "()]")
		
		return this
	}

	_GetModuleFileNameEx(PID)
	{
		hProcess := DllCall("Kernel32.dll\OpenProcess", "UInt", 0x001F0FFF, "UInt", 0, "UInt", PID)
		if (ErrorLevel || hProcess = 0)
			return
		static lpFilename, nSize := 260, int := VarSetCapacity(lpFilename, nSize, 0)
		DllCall("Psapi.dll\GetModuleFileNameEx", "Ptr", hProcess, "Ptr", 0, "Str", lpFilename, "UInt", nSize)
		DllCall("Kernel32.dll\CloseHandle", "Ptr", hProcess)
		return lpFilename
	}
}

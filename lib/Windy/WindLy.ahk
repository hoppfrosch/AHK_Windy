; ****** HINT: Documentation can be extracted to HTML using NaturalDocs (http://www.naturaldocs.org/) ************** 

; ****** HINT: Debug-lines should contain "; _DBG_" at the end of lines - using this, the debug lines could be automatically removed through scripts before releasing the sourcecode
#include <Windy\Windy>


/* ******************************************************************************************************************************************
	Class: WindLy
	Class holding lists of <Windy at http://hoppfrosch.github.io/AHK_Windy/files/Windy-ahk.html>-Objects

	Author(s):
	<hoppfrosch at hoppfrosch@gmx.de>		

	About: License
	This program is free software. It comes without any warranty, to the extent permitted by applicable law. You can redistribute it and/or modify it under the terms of the Do What The Fuck You Want To Public License, Version 2, as published by Sam Hocevar. See <WTFPL at http://www.wtfpl.net/> for more details.
*/
class WindLy {
	_debug := 0
	_version := "0.0.1"
	_wl := {}

	list[] {
	/* ---------------------------------------------------------------------------------------
	Property: list [get]
	Set/Unset alwaysontop flag of the current window or get the current state
	*/
		get {
			return this._wl
		}
	}

	; ===== Methods ==================================================================
	/* -------------------------------------------------------------------------------
	Method:	fromAll
	Initializes the window list from all currently openend windows
	
	Returns:
	List of <Windy at http://hoppfrosch.github.io/AHK_Windy/files/Windy-ahk.html>-Objects.
	*/
	fromAll() {
		this.__reset()
		WinGet, _Wins, List
		
		Loop %_Wins%
		{
			hWnd:=_Wins%A_Index%
			_w := new Windy(hWnd)
			if (_w.__isWindow(hWnd)) {
				this._wl[hwnd] := _w
			}
		}
		return this._wl
	}

	/* -------------------------------------------------------------------------------
	Method:	byMonitorId
	Initializes the window list from a given monitor
	
	Parameters:
		id - Monitor-Id
			Returns:
	List of <Windy at http://hoppfrosch.github.io/AHK_Windy/files/Windy-ahk.html>-Objects on the given monitor
	*/
	byMonitorId(id=1) {
		this.fromAll()
		_tmp := this._wl
		this._wl := {}
		for hwnd, win in _tmp {
			MsgBox % hwnd " - " win.monitorID
			if (win.monitorID = id ) {
			   this._wl[hwnd] := win
			}
		}
		_tmp := {}
		return this._wl
	}
	
	; ===== Internal Methods =========================================================
	/* -------------------------------------------------------------------------------
	method: __reset
	Initializes all the data
	*/
	__reset() {
		this._wl := {}
	}

	/* ---------------------------------------------------------------------------------------
	Method: __New
		Constructor (*INTERNAL*)

	Parameters:
		_debug - Flag to enable debugging (Optional - Default: 0)
	*/   
	__New(_debug=0) {
		this._debug := _debug
		if (this._debug) ; _DBG_
			OutputDebug % ">[" A_ThisFunc "(hWnd=(" _hWnd "))] (version: " this._version ")" ; _DBG_

		if % (A_AhkVersion < "1.1.08.00" || A_AhkVersion >= "2.0") {
			MsgBox 16, Error, %A_ThisFunc% :`n This class is only tested with AHK_L later than 1.1.08.00 (and before 2.0)`nAborting...
			if (this._debug) ; _DBG_
				OutputDebug % "<[" A_ThisFunc "(...) -> ()]: *ERROR* : This class is only tested with AHK_L later than 1.1.08.00 (and before 2.0). Aborting..." ; _DBG_
			return
		}
				
		if (this._debug) ; _DBG_
			OutputDebug % "<[" A_ThisFunc "(hWnd=(" _hWnd "))]" ; _DBG_
		
		return this
	}
}

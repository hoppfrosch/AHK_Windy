; ****** HINT: Documentation can be extracted to HTML using NaturalDocs (http://www.naturaldocs.org/) ************** 

; ****** HINT: Debug-lines should contain "; _DBG_" at the end of lines - using this, the debug lines could be automatically removed through scripts before releasing the sourcecode
#include %A_LineFile%\..
#include Windy.ahk
#include Const_WinUser.ahk


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
	_version := "0.0.2"
	_wl := {}

	; ##################### Properties (AHK >1.1.16.x) #################################################################
	list[] {
	/* ---------------------------------------------------------------------------------------
	Property: list [get]
	Get the currently stored list (may be determined anytime)
	*/
		get {
			return this._wl
		}
	}
	
	; ######################## Methods to be called directly ########################################################### 
	/* -------------------------------------------------------------------------------
	Method:	byMonitorId
	Initializes the window list from a given monitor
	
	Parameters:
	id - Monitor-Id

	Returns:
	List of <Windy at http://hoppfrosch.github.io/AHK_Windy/files/Windy-ahk.html>-Objects on the given monitor
	*/
	byMonitorId(id=1) {
		this.__reset()
		_tmp := this.__all()
		for hwnd, win in _tmp {
			MsgBox % hwnd " - " win.monitorID
			if (win.monitorID = id ) {
			   this._wl[hwnd] := win
			}
		}
		_tmp := {}
		return this._wl
	}
	/* -------------------------------------------------------------------------------
	Method:	byStyle
	Initializes the window list by given window style
	
	Parameters:
	myStyle - Windows-Style (<Class WS at http://hoppfrosch.github.io/AHK_Windy/files/Const_WinUser.ahk>)

	Returns:
	List of <Windy at http://hoppfrosch.github.io/AHK_Windy/files/Windy-ahk.html>-Objects matching the given style
	*/
	byStyle(myStyle) {
		this.__reset()
		_tmp := this.__all()

		for hwnd, win in _tmp {
			WinGet, l_tmp, Style, ahk_id %hWnd%
			if (l_tmp & myStyle) {
			   this._wl[hwnd] := win
			}
		}
		_tmp := {}
		return this._wl
	}
	/* -------------------------------------------------------------------------------
	Method:	snapshot
	Initializes the window list from all currently openend windows
	
	Returns:
	List of <Windy at http://hoppfrosch.github.io/AHK_Windy/files/Windy-ahk.html>-Objects.
	*/
	snapshot() {
		this.__reset()
		this._wl := this.__all()
		return this._wl
	}

	; ######################## Internal Methods - not to be called directly ############################################
	; ===== Internal Methods =========================================================
	/* -------------------------------------------------------------------------------
	method: __all
	Gets all currently openend windows and returns as a List of Objects (*INTERNAL*)

	Returns:
	List of <Windy at http://hoppfrosch.github.io/AHK_Windy/files/Windy-ahk.html>-Objects
	*/
	__all() {
		hwnds := this.__hwnds(true)
		ret := {}

		Loop % hwnds.MaxIndex() {
			hwnd := hwnds[A_Index]
			_w := new Windy(hWnd)
			ret[hwnd] := _w
		}
		
		return ret
	}
	/* ---------------------------------------------------------------------------------------
	Method:   __hwnds
	Determines handles of all current windows(*INTERNAL*)

	Parameters:
		windowsonly  - Flag to filter on "real windows" (Default: *true*)

	Returns:
		Array with determined window handles
	*/
	__hwnds(windowsOnly = true) {
		ret := Object()
		WinGet, _Wins, List

		Loop %_Wins%
		{
			hWnd:=_Wins%A_Index%
			bAdd := true
			if (windowsOnly = true) {
				bAdd := this.__isRealWindow(hWnd)
			}
			if (bAdd = true) {
				ret.Insert(hWnd)
			}
		}
		return ret
		
	
	}
	/* ---------------------------------------------------------------------------------------
	Method:   __isRealWindow
	Checks whether the given hWnd refers to a TRUE window (As opposed to the desktop or a menu, etc.) (*INTERNAL*)

	Parameters:
		hwnd  - Handle of window to check (*Obligatory*)

	Returns:
		true (window is a true window), false (window is not a true window)

	Author(s):
		Original - <ManaUser at http://www.autohotkey.com/board/topic/25393-appskeys-a-suite-of-simple-utility-hotkeys/>
	*/
	__isRealWindow(hWnd) {
		WinGet, s, Style, ahk_id %hWnd% 
		ret := s & WS.CAPTION ? (s & WS.POPUP ? 0 : 1) : 0
		return ret
	}
	/* -------------------------------------------------------------------------------
	method: __reset
	Initializes all the data (*INTERNAL*)
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

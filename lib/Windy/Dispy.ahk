; ****** HINT: Documentation can be extracted to HTML using NaturalDocs (http://www.naturaldocs.org/) ************** 

; ****** HINT: Debug-lines should contain "; _DBG_" at the end of lines - using this, the debug lines could be automatically removed through scripts before releasing the sourcecode

#include <Windy\Recty>
#include <Windy\Pointy>

/* ******************************************************************************************************************************************
	Class: Dispy
	Handling a single Monitor, identified via its monitor ID

		Author(s):
	<hoppfrosch at hoppfrosch@gmx.de>		

	About: License
	This program is free software. It comes without any warranty, to the extent permitted by applicable law. You can redistribute it and/or modify it under the terms of the Do What The Fuck You Want To Public License, Version 2, as published by Sam Hocevar. See <WTFPL at http://www.wtfpl.net/> for more details.
*/
class Dispy {
	_debug := 0
	_version := "0.1.1"
	_id := 0

    ; ===== Properties ==============================================================0	
    /* ------------------------------------------------------------------------------- ; _DBG_
	Property: debug [get/set]                                                          ; _DBG_
	Debug flag for debugging the object                                                ; _DBG_
                                                                                       ; _DBG_
	Value:                                                                             ; _DBG_
	flag - *true* or *false*                                                           ; _DBG_
	*/                                                                                 ; _DBG_
    debug[] { ; _DBG_
		get {                                                                          ; _DBG_ 
			return this._debug                                                         ; _DBG_
		}                                                                              ; _DBG_
		set {                                                                          ; _DBG_
			mode := value<1?0:1                                                        ; _DBG_
			this._debug := mode                                                        ; _DBG_
			return this._debug                                                         ; _DBG_
		}                                                                              ; _DBG_
	}
	
	/* -------------------------------------------------------------------------------
	Property: id [get/set]
	ID of the monitor

	Remarks:
	* There is no setter available, since this is a constant system property
	*/
    id[] {
		get {
			return this._id
		}
		set {
			if (this._debug) ; _DBG_
				OutputDebug % ">[" A_ThisFunc "(value:=" value ")]" ; _DBG_
			ret := 0
			; Existiert der Monitor mit der uebergebenen ID?
			CoordMode, Mouse, Screen
			SysGet, mCnt, MonitorCount
			if (value > 0) {
				if (value <= mCnt) {
					this._id := value
					ret := value
				}
			}
			if (this._debug) ; _DBG_
				OutputDebug % "<[" A_ThisFunc "(value:=" value ")] -> (" ret ")" ; _DBG_
			return ret
		}
	}

	/* ---------------------------------------------------------------------------------------
	Property:  size [get]
	Get the size of a monitor in Pixel as a <rectangle at http://hoppfrosch.github.io/AHK_Windy/files/Recty-ahk.html>.
			
	Remarks:
	* There is no setter available, since this is a constant system property

	See also: 
	<workArea [get]>
	*/
	size[ ] {
		get {
			mon := this.id
			SysGet, size, Monitor, %mon%
			rect := new Recty(0,0, sizeRight-sizeLeft, sizeBottom-sizeTop, this.debug)
			if (this._debug) ; _DBG_
				OutputDebug % "|[" A_ThisFunc "()] -> (" rect.dump() ")" ; _DBG_
			return rect
		}
	}
	
	/* -------------------------------------------------------------------------------
	Property: version [get]
	Version of the class
	*/
    version[] {
		get {
			OutputDebug % "<[" A_ThisFunc "] -> (" this._version ")" ; _DBG_
			return this._version
		}
	}


	; ===== Methods ==================================================================
	
	; ===== Internal Methods =========================================================
	/* -------------------------------------------------------------------------------
	Function: __New
	Constructor (*INTERNAL*)
		
	Parameters:
	_id - Monitor ID
	_debug - Flag to enable debugging (Optional - Default: 0)
	*/  
	__New(_id := 1, _debug := false) {
		ret := true
		CoordMode, Mouse, Screen
		SysGet, mCnt, MonitorCount
		if (_id > 0) {
			if (_id <= mCnt) {
				this.id := _id
			}
			else {
				if (this.debug) ; _DBG_
					OutputDebug % "|[" A_ThisFunc "(_id:=" _id ", _debug:=" _debug ")] (version: " this.version ") -> " false ; _DBG_
				return false
			}
		}
		else {
			if (this.debug) ; _DBG_
					OutputDebug % "|[" A_ThisFunc "(_id:=" _id ", _debug:=" _debug ")] (version: " this.version ") -> " false ; _DBG_
			return false
		}
		this.debug := _debug ; _DBG_
		if (this.debug) ; _DBG_
			OutputDebug % "|[" A_ThisFunc "(_id:=" _id ", _debug:=" _debug ")] (version: " this.version ") -> " this.id ; _DBG_

		return this
	}
}

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
	_version := "0.1.4"
	_id := 0

    ; ===== Properties ===============================================================
    debug[] { ; _DBG_
	/* ------------------------------------------------------------------------------- ; _DBG_
	Property: debug [get/set]                                                          ; _DBG_
	Debug flag for debugging the object                                                ; _DBG_
                                                                                       ; _DBG_
	Value:                                                                             ; _DBG_
	flag - *true* or *false*                                                           ; _DBG_
	*/                                                                                 ; _DBG_
		get {                                                                          ; _DBG_ 
			return this._debug                                                         ; _DBG_
		}                                                                              ; _DBG_
		set {                                                                          ; _DBG_
			mode := value<1?0:1                                                        ; _DBG_
			this._debug := mode                                                        ; _DBG_
			return this._debug                                                         ; _DBG_
		}                                                                              ; _DBG_
	}	
	id[] {
	/* -------------------------------------------------------------------------------
	Property: id [get/set]
	ID of the monitor
	*/
    
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
	size[ ] {
	/* ---------------------------------------------------------------------------------------
	Property:  size [get]
	Get the size of a monitor in Pixel as a <rectangle at http://hoppfrosch.github.io/AHK_Windy/files/Recty-ahk.html>.
			
	Remarks:
	* There is no setter available, since this is a constant system property

	See also: 
	<virtualScreenSize [get]>, <workingArea [get]>
	*/
		get {
			mon := this.id
			SysGet, size, Monitor, %mon%
			rect := new Recty(0,0, sizeRight-sizeLeft, sizeBottom-sizeTop, this.debug)
			if (this._debug) ; _DBG_
				OutputDebug % "|[" A_ThisFunc "()] -> (" rect.dump() ")" ; _DBG_
			return rect
		}
	}	
    version[] {
    /* -------------------------------------------------------------------------------
	Property: version [get]
	Version of the class
	*/
		get {
			OutputDebug % "|[]" A_ThisFunc "] -> (" this._version ")" ; _DBG_
			return this._version
		}
	}
	virtualScreenSize[] {
	/* ---------------------------------------------------------------------------------------
	Property: virtualScreenSize [get]
	Get the size of virtual screen in Pixel as a <rectangle at http://hoppfrosch.github.io/AHK_Windy/files/Recty-ahk.html>.
	
	The virtual screen is the bounding rectangle of all display monitors
	
	Remarks:
	* There is no setter available, since this is a constant system property

	See also: 
	<size [get]>
	*/
		get {
			SysGet, x, 76
			SysGet, y, 77
			SysGet, w, 78
			SysGet, h, 79
			rect := new Recty(x,y,w,h, this._debug)
			if (this._debug) ; _DBG_
				OutputDebug % "<[" A_ThisFunc "()] -> (" rect.dump() ")" ; _DBG_
			return rect
		}
	}
	workingArea[] {
/* -------------------------------------------------------------------------------
	Property:  workingArea [get]
	Get the working area of a monitor in Pixel as a <rectangle at http://hoppfrosch.github.io/AHK_Windy/files/Recty-ahk.html>.
	
	Same as <size [get]>, except the area is reduced to exclude the area occupied by the taskbar and other registered desktop toolbars.
	The working area is given as a <rectangle at http://hoppfrosch.github.io/AHK_Windy/files/Recty-ahk.html>.
		
	Remarks:
	* There is no setter available, since this is a constant system property

	See also: 
	<size [get]>
	*/
		get {
			mon := this.id
			SysGet, size, MonitorWorkArea , %mon%
			rect := new Recty(0,0, sizeRight-sizeLeft, sizeBottom-sizeTop, this._debug)
			if (this._debug) ; _DBG_
				OutputDebug % "|[" A_ThisFunc "()] -> (" rect.dump() ")" ; _DBG_
			return rect
		}
	}

	; ===== Methods ==================================================================
	/* -------------------------------------------------------------------------------
	method: identify
	Identify monitor by displaying the monitor id
	
	Parameters:
	disptime - time to display the monitor id (*Optional*, Default: 1500[ms])
	txtcolor - color of the displayed monitor id (*Optional*, Default: "000000")
	txtsize - size of the displayed monitor id (*Optional*, Default: 300[px])
	*/
	identify( disptime := 1500, txtcolor := "000000", txtsize := 300 ) {
		if (this._debug) ; _DBG_
				OutputDebug % ">[" A_ThisFunc "(txtcolor := " txtcolor ", txtsize := " txtsize ")]" ; _DBG_
		this.__idShow(txtcolor, txtsize)
    	Sleep, %disptime%
    	this.__idHide()
    	if (this._debug) ; _DBG_
				OutputDebug % "<[" A_ThisFunc "(disptime := " disptime ", txtcolor := " txtcolor ", txtsize := " txtsize ")]" ; _DBG_
		return
	}
	
	; ===== Internal Methods =========================================================
	/* -------------------------------------------------------------------------------
	method: __idHide
	Helper function for <identify>: Hides the Id, shown with <__idShow> (*INTERNAL*)
		
    See also: 
	<identify>, <__idShow>
	*/
	__idHide() {
		mon := this.id
		GuiNum := 80 + mon
    	Gui, %GuiNum%:Destroy

    	if (this._debug) ; _DBG_
				OutputDebug % "|[" A_ThisFunc "()]" ; _DBG_
		
		return
	}
	
	/* -------------------------------------------------------------------------------
	method: __idShow
	Helper function for <identify>: Identify monitor by displaying the monitor id. The id can be gidden again via <__idHide> (*INTERNAL*)
	
	Parameters:
	txtcolor - color of the displayed monitor id (*Optional*, Default: "000000")
	txtsize - size of the displayed monitor id (*Optional*, Default: 300[px])
	
	Author(s):
    Original - <Bkid at http://ahkscript.org/boards/viewtopic.php?f=6&t=3761&p=19836&hilit=Monitor#p19836>

    See also: 
	<identify>, <__idHide>
	*/
	__idShow( txtcolor := "000000", txtsize := 300 ) {
		mon := this.id
		TPColor = AABBCC
		GuiNum := 80 + mon
   		SysGet, out, Monitor, %mon%
    	x := outLeft
    	Gui, %GuiNum%:+LastFound +AlwaysOnTop -Caption +ToolWindow
    	Gui, %GuiNum%:Color, %TPColor%
    	WinSet, TransColor, %TPColor%
    	Gui, %GuiNum%:Font, s%txtsize% w700
    	Gui, %GuiNum%:Add, Text, x0 y0 c%txtcolor%, %mon%
    	Gui, %GuiNum%:Show, x%x% y0 NoActivate
    	if (this._debug) ; _DBG_
				OutputDebug % "|[" A_ThisFunc "(txtcolor := " txtcolor ", txtsize := " txtsize ")]" ; _DBG_
		return
	}
	
	/* -------------------------------------------------------------------------------
	Constructor: __New
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

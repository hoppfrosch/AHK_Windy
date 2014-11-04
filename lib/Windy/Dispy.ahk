; ****** HINT: Documentation can be extracted to HTML using NaturalDocs (http://www.naturaldocs.org/) ************** 

; ****** HINT: Debug-lines should contain "; _DBG_" at the end of lines - using this, the debug lines could be automatically removed through scripts before releasing the sourcecode

#include <Windy\Recty>
#include <Windy\Pointy>
#include <Windy\MultiDispy>

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
	_version := "0.1.13"
	_id := 0

    ; ===== Properties ===============================================================
    boundary[] {
    /* -------------------------------------------------------------------------------
	Property: boundary [get]
	Get the boundaries of a monitor in Pixel (related to Virtual Screen) as a <rectangle at http://hoppfrosch.github.io/AHK_Windy/files/Recty-ahk.html>.

	Remarks:
	* There is no setter available, since this is a constant system property

	See also: 
	<virtualScreenSize [get]>
	*/
		get {
			mon := this.id
			SysGet, size, Monitor, %mon%
			rect := new Recty(sizeLeft, sizeTop, sizeRight, sizeBottom, this._debug)
			if (this._debug) ; _DBG_
				OutputDebug % "<[" A_ThisFunc "([" this.id "])] -> (" rect.dump() ")" ; _DBG_
			return rect
		}
	}
	center[] {
	/* -------------------------------------------------------------------------------
	Property: center [get]
	Get the center coordinates of a monitor in Pixel (related to Virtual Screen)  as a <point at http://hoppfrosch.github.io/AHK_Windy/files/Pointy-ahk.html>.

	Remarks:
	* There is no setter available, since this is a constant system property
	*/	
		get {
			boundary := this.boundary
			xcenter := floor(boundary.x+(boundary.w-boundary.x)/2)
			ycenter := floor(boundary.y+(boundary.h-boundary.y)/2)
			pt := new Pointy(xcenter, ycenter, this._debug)
			if (this._debug) ; _DBG_
				OutputDebug % "|[" A_ThisFunc "([" this.id "])] -> (" pt.dump() ")" ; _DBG_
			return pt
		}
	}
    debug[] { ; _DBG_
   	/* -------------------------------------------------------------------------------
	Property: debug [get/set]
	Debug flag for debugging the object

	Value:
	flag - *true* or *false*
	*/
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
				OutputDebug % ">[" A_ThisFunc "([" this.id "],value:=" value ")]" ; _DBG_
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
				OutputDebug % "<[" A_ThisFunc "([" this.id "],value:=" value ")] -> (" ret ")" ; _DBG_
			return ret
		}
	}
	idNext[ cycle := true ] {
	/* -------------------------------------------------------------------------------
	Property:	idNext [get]
	Gets the id of the next monitor.
			
	Parameters:
	cycle - == 1 cycle through monitors; == 0 stop at last monitor (*Optional*, Default: 1)
			
	Remarks:
	* There is no setter available, since this is a constant system property

	See also: 
	<idPrev [get]>
	*/
		get {
			md := new MultiDispy(this._debug)
			nextMon := md.idNext(this.id, cycle)
			if (this._debug) ; _DBG_
				OutputDebug % "|[" A_ThisFunc "([" this.id "],cycle=" cycle ")] -> " nextMon ; _DBG_
			
			return nextMon
		}
	}
	idPrev[ cycle := true ] {
	/* -------------------------------------------------------------------------------
	Property:	idPrev [get]
	Gets the id of the previous monitor
			
	Parameters:
	cycle - == true cycle through monitors; == false stop at last monitor (*Optional*, Default: true)
			
	Remarks:
	* There is no setter available, since this is a constant system property

	See also: 
	<idNext [get]>
	*/
		get {
			md := new MultiDispy(this._debug)
			prevMon := md.idPrev(this.id, cycle)
			if (this._debug) ; _DBG_
				OutputDebug % "|[" A_ThisFunc "([" this.id "],cycle=" cycle ")] -> " prevMon ; _DBG_
			
			return prevMon
		}
	}
	monitorsCount[] {
	/* ---------------------------------------------------------------------------------------
	Property: monitorsCount [get]
	Number of available monitors. 

	Remarks:
	* There is no setter available, since this is a constant system property
	*/
		get {
			md := new MultiDispy(this._debug)
			mcnt := md.monitorsCount
			if (this._debug) ; _DBG_
				OutputDebug % "|[" A_ThisFunc "([" this.id "]) -> (" mCnt ")]" ; _DBG_		
			return mCnt
		}
	}
	scale[ monDest := 1 ] {
	/* -------------------------------------------------------------------------------
	Property:  scale [get]
	Determines the scaling factors in x/y-direction for coordinates when moving to monDest as a <point at http://hoppfrosch.github.io/AHK_Windy/files/Pointy-ahk.html>.
			
	Parameters:
	monDest - Destination Monitor number (*Required*, Default := 1)
			
	Returns:
	Scaling factor for x/y -coordinates as a <point at http://hoppfrosch.github.io/AHK_Windy/files/Pointy-ahk.html>.

	Remarks:
	* There is no setter available, since this is a constant system property

	See also: 
	<scaleX [get]>, <scaleY [get]>
	*/
		get {
			scaleX := this.scaleX(monDest)
			scaleY := this.scaleY(monDest)
			pt := new Pointy(scaleX,scaleY,this._debug)
			if (this._debug) ; _DBG_
				OutputDebug % "|[" A_ThisFunc "([" this.id "],monDest:= " monDest "] -> (" pt.dump() ")" ; _DBG_
			return pt
		}
	}
	scaleX[ monDest := 1 ] {
	/* -------------------------------------------------------------------------------
	Property:  scaleX [get]
	Determines the scaling factor in x and -direction for coordinates when moving to monDest
			
	Parameters:
	monDest - Destination Monitor number (*Required*, Default := 1)
			
	Returns:
	Scaling factor for x-coordinates as a <point at http://hoppfrosch.github.io/AHK_Windy/files/Pointy-ahk.html>.

	Remarks:
	* There is no setter available, since this is a constant system property

	See also: 
	<scale [get]>, <scaleY [get]>
	*/
		get {
			size1 := this.size
			md := new Dispy(monDest, this.debug)
			size2 := md.size
			scaleX := size2.w / size1.w
			if (this._debug) ; _DBG_
				OutputDebug % "|[" A_ThisFunc "([" this.id "],monDest:=" monDest ") -> (" scaleX ")]" ; _DBG_		
			return scaleX
		}
	}
	scaleY[ monDest := 1 ] {
	/* -------------------------------------------------------------------------------
	Property:  scaleY [get]
	Determines the scaling factor in y-direction for coordinates when moving to monDest
			
	Parameters:
	
	monDest - Destination Monitor number (*Required*, Default := 1)
			
	Returns:
	Scaling factor for y-coordinates

	Remarks:
	* There is no setter available, since this is a constant system property

	See also: 
	<scale [get]>, <scaleX [get]>
	*/
		get {
			size1 := this.size
			md := new Dispy(monDest, this.debug)
			size2 := md.size
			scaleY := size2.h / size1.h
			if (this._debug) ; _DBG_
				OutputDebug % "|[" A_ThisFunc "([" this.id "],monDest:=" monDest ") -> (" scaleY ")]" ; _DBG_		
			return scaleY
		}
	}
	size[] {
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
				OutputDebug % "|[" A_ThisFunc "([" this.id "])] -> (" rect.dump() ")" ; _DBG_
			return rect
		}
	}	
    version[] {
    /* -------------------------------------------------------------------------------
	Property: version [get]
	Version of the class

	Remarks:
	* There is no setter available, since this is a constant system property
	*/
		get {
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
	<size [get]>, <boundary [get]>
	*/
		get {
			md := new MultiDispy(this._debug)
			rect := md.virtualScreenSize
			if (this._debug) ; _DBG_
				OutputDebug % "<[" A_ThisFunc "([" this.id "])] -> (" rect.dump() ")" ; _DBG_
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
				OutputDebug % "|[" A_ThisFunc "([" this.id "])] -> (" rect.dump() ")" ; _DBG_
			return rect
		}
	}

	; ===== Methods ==================================================================
	/* -------------------------------------------------------------------------------
	Method:	coordDisplayToVirtualScreen
	Transforms coordinates relative to given monitor into absolute (virtual) coordinates. Returns object of type <point at http://hoppfrosch.github.io/AHK_Windy/files/Pointy-ahk.html>.
	
	Parameters:
	x,y - relative coordinates on given monitor
	
	Returns:
	<point at http://hoppfrosch.github.io/AHK_Windy/files/Pointy-ahk.html>.
	*/
	coordDisplayToVirtualScreen( x := 0, y := 0) {
		md := new MultiDispy(this._debug)
		pt := md.coordDisplayToVirtualScreen(this.id, x, y)
		if (this._debug) ; _DBG_
			OutputDebug % "|[" A_ThisFunc "()] -> (" pt.dump() ")" ; _DBG_
		return pt
	}
	
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
			OutputDebug % ">[" A_ThisFunc "([" this.id "], disptime := " disptime ", txtcolor := " txtcolor ", txtsize := " txtsize ")]" ; _DBG_
		this.__idShow(txtcolor, txtsize)
    	Sleep, %disptime%
    	this.__idHide()
    	if (this._debug) ; _DBG_
			OutputDebug % "<[" A_ThisFunc "([" this.id "], disptime := " disptime ", txtcolor := " txtcolor ", txtsize := " txtsize ")]" ; _DBG_
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
				OutputDebug % "|[" A_ThisFunc "([" this.id "])]" ; _DBG_
		
		return
	}
	/* -------------------------------------------------------------------------------
	method: __idShow
	Helper function for <identify>: Identify monitor by displaying the monitor id, hidden via <__idHide> (*INTERNAL*)
	
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
				OutputDebug % "|[" A_ThisFunc "([" this.id "], txtcolor := " txtcolor ", txtsize := " txtsize ")]" ; _DBG_
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

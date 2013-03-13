/**
 * @synopsis    The stdLib compliant function list of tabfunctions allows easily to modify tabs
 *              and add or change icons in a given tabControl
 *              Originally this functions based upon posts from chris, lexikos and serenity and
 *              may be found here: http://www.autohotkey.com/forum/viewtopic.php?t=6060
 *
 * @name        tab.ahk
 * @version     1.1
 *
 * @author      derRaphael - based on the works of serenity, chris, Lexikos and Drugwash
 *              hoppfrosch - unicode version
 *
 * @licence     released under the EUPL 1.1 or later
 *              see http://ec.europa.eu/idabc/en/document/7774 for a translated version in your
 *              language
 *
 * @ahkversion  Tested with AHK 1.1.00.01 (AHK_L) and AHK 1.0.48.05 (AHK Classic)
 *
 * @see         http://www.autohotkey.com/forum/viewtopic.php?p=323173#323173
 */


/* For Info on TabControl see: http://msdn.microsoft.com/en-us/library/ff486047%28v=VS.85%29.aspx
   
   Constants are determined using 'List of Win32 CONSTANTS' by SKAN - Suresh Kumar A N, arian.suresh@gmail.com  (see: www.autohotkey.com/forum/viewtopic.php?t=19766)
   
CCM_FIRST                                    := 0x2000
CCM_GETUNICODEFORMAT : = (CCM_FIRST + 6)     := 0x2006
CCM_SETUNICODEFORMAT := (CCM_FIRST + 5)      := 0x2005

TCM_FIRST                                    := 0x1300
TCM_ADJUSTRECT       := (TCM_FIRST + 40)     := 0x1328
TCM_DELETEALLITEMS   := (TCM_FIRST + 9)      := 0x1309
TCM_DELETEITEM       := (TCM_FIRST + 8)      := 0x1308  -> Tab_Delete()
TCM_DESELECTALL      := (TCM_FIRST + 50)     := 0x1332
TCM_GETCURFOCUS      := (TCM_FIRST + 47)     := 0x132F  -> Tab_GetFocus()
TCM_GETCURSEL        := (TCM_FIRST + 11)     := 0x130B
TCM_GETEXTENDEDSTYLE := (TCM_FIRST + 53)     := 0x1335
TCM_GETIMAGELIST     := (TCM_FIRST + 2)      := 0x1302
TCM_GETITEMA         := (TCM_FIRST + 5)      := 0x1305  -> Tab_GetName()
TCM_GETITEMCOUNT     := (TCM_FIRST + 4)      := 0x1304  -> Tab_Count()
TCM_GETITEMRECT      := (TCM_FIRST + 10)     := 0x130A
TCM_GETITEMW         := (TCM_FIRST + 60)     := 0x133C  -> Tab_GetName()
TCM_GETROWCOUNT      := (TCM_FIRST + 44)     := 0x132C
TCM_GETTOOLTIPS      := (TCM_FIRST + 45)     := 0x132D
TCM_GETUNICODEFORMAT := CCM_GETUNICODEFORMAT := 0x2006
TCM_HIGHLIGHTITEM    := (TCM_FIRST + 51)     := 0x1333
TCM_HITTEST          := (TCM_FIRST + 13)     := 0x130D
TCM_INSERTITEMA      := (TCM_FIRST + 7)      := 0x1307  -> Tab_AppendWithIcon()
TCM_INSERTITEMW      := (TCM_FIRST + 62)     := 0x133E  -> Tab_AppendWithIcon()
TCM_REMOVEIMAGE      := (TCM_FIRST + 42)     := 0x132A
TCM_SETCURFOCUS      := (TCM_FIRST + 48)     := 0x1330
TCM_SETCURSEL        := (TCM_FIRST + 12)     := 0x130C
TCM_SETEXTENDEDSTYLE := (TCM_FIRST + 52)     := 0x1334
TCM_SETIMAGELIST     := (TCM_FIRST + 3)      := 0x1303  -> Tab_AttachImageList()
TCM_SETITEMA         := (TCM_FIRST + 6)      := 0x1306  -> Tab_Modify()
TCM_SETITEMEXTRA     := (TCM_FIRST + 14)     := 0x130E
TCM_SETITEMSIZE      := (TCM_FIRST + 41)     := 0x1329
TCM_SETITEMW         := (TCM_FIRST + 61)     := 0x133D  -> Tab_Modify()
TCM_SETMINTABWIDTH   := (TCM_FIRST + 49)     := 0x1331
TCM_SETPADDING       := (TCM_FIRST + 43)     := 0x132B
TCM_SETTOOLTIPS      := (TCM_FIRST + 46)     := 0x132E
TCM_SETUNICODEFORMAT := CCM_SETUNICODEFORMAT := 0x2005
*/

/**
 * Attaches a previously defined imagelist to a tabcontrol
 *
 * @author derRaphael
 * @version 1.0
 *
 * @param ImageListId
 *            The ID of the previously created imagelist
 * @param TabControl
 *            Either the associated variablename, its classname with the index or
 *            the TabControl's windowHandle
 *            May be blank - in this case the 1st found control will be used as default
 * @return ErrorLevel of the sendMessage call
*/
Tab_AttachImageList( ImageListId, TabControl = "SysTabControl321" )
{
   ; TCM_SETIMAGELIST     := (TCM_FIRST + 3)      := 0x1303
   Return % Tab_Send( Msg := 0x1303, wParam := 0, lParam := ImageListId, TabControl ) ; TCM_SETIMAGELIST
}

/**
 * Attaches a tab with a custom icon to a tabcontrol
 *
 * @author derRaphael, hoppfrosch
 * @version 1.1
 *
 * @param TabText
 *            The text to display at the tab
 * @param IconNumber
 *            The ID of a chosen icon - usually the index 'd start
 *            with zero but ahk usually uses a "1" based index
 * @param TabControl
 *            Either the associated variablename, its classname with the index or
 *            the TabControl's windowHandle
 *            May be blank - in this case the 1st found control will be used as default
 * @return ErrorLevel of the sendMessage call
 */
Tab_AppendWithIcon( TabText, IconNumber, TabControl = "SysTabControl321" )
{
   ; TCM_INSERTITEMA      := (TCM_FIRST + 7)      := 0x1307
   ; TCM_INSERTITEMW      := (TCM_FIRST + 62)     := 0x133E
   VarSetCapacity(TCITEM, 28, 0)
   NumPut(3, TCITEM, 0, "UInt")
   NumPut(&TabText, TCITEM, 12, "UInt")
   NumPut(IconNumber - 1, TCITEM, 20, "UInt")
   
   Return % Tab_Send( Msg := (A_IsUnicode ? 0x133E : 0x1307), wParam := 999, lParam := &TCITEM, TabControl )
}

/**
 * returns the index of the current selected tab
 *
 * @author chris, Drugwash, derRaphael
 * @version 1.0
 *
 * @param TabControl
 *            Either the associated variablename, its classname with the index or
 *            the TabControl's windowHandle
 *            May be blank - in this case the 1st found control will be used as default
 * @return ErrorLevel of the SendMessage call
 */
Tab_GetActiveIdx( TabControl = "SysTabControl321" )
{
   ControlGet, ActiveTab, Tab,,, % "ahk_id " Tab_GetHwnd( TabControl )
   Return, % ActiveTab
}

/**
 * Modifies the icon and the name of the givenb TabIndex in the selected TabControl
 *
 * @author chris, Drugwash, derRaphael, hoppfrosch
 * @version 1.1
 *
 * @param TabName
 *            The text to display at the tab
 * @param IconIdx
 *            The ID of a chosen icon - usually the index 'd start
 *            with zero but ahk usually uses a "1" based index
 * @param TabIdx
 *            The index of the chosen tab
 * @param TabControl
 *            Either the associated variablename, its classname with the index or
 *            the TabControl's windowHandle
 *            May be blank - in this case the 1st found control will be used as default
 * @return ErrorLevel of the SendMessage call
 */
Tab_Modify( TabName, IconIdx, TabIdx, TabControl = "SysTabControl321" )
{ 
  ; TCM_SETITEMA         := (TCM_FIRST + 6)      := 0x1306
  ; TCM_SETITEMW         := (TCM_FIRST + 61)     := 0x133D
   VarSetCapacity(TCITEM, 28, 0)
   NumPut(3, TCITEM, 0, "UInt")
   NumPut(&TabName, TCITEM, 12, "UInt")
   NumPut(IconIdx - 1, TCITEM, 20, "UInt")
   return % Tab_Send( Msg := (A_IsUnicode ? 0x133D : 0x1306), wParam := TabIdx, lParam := &TCITEM, TabControl )
}

/**
 * Removes a tab by a given index
 *
 * @author chris, Drugwash, derRaphael
 * @version 1.0
 *
 * @param TabIdx
 *            The index of the chosen tab
 * @param TabControl
 *            Either the associated variablename, its classname with the index or
 *            the TabControl's windowHandle
 *            May be blank - in this case the 1st found control will be used as default
 * @return ErrorLevel of the SendMessage call
 */
Tab_Delete( TabIdx = 0, TabControl = "SysTabControl321")
{ 
   ; TCM_DELETEITEM       := (TCM_FIRST + 8)      := 0x1308
   return % Tab_Send( Msg := 0x1308, wParam := TabIdx, lParam := 0, TabControl )
}

/**
 * Counts the total of all tabs in the given control
 *
 * @author chris, Drugwash, derRaphael
 * @version 1.0
 *
 * @param TabControl
 *            Either the associated variablename, its classname with the index or
 *            the TabControl's windowHandle
 *            May be blank - in this case the 1st found control will be used as default
 * @return ErrorLevel of the SendMessage call
 */
Tab_Count( TabControl = "SysTabControl321" )
{ 
  ; TCM_GETITEMCOUNT     := (TCM_FIRST + 4)      := 0x1304
   return % Tab_Send( Msg := 0x1304, wParam := 0, lParam := 0, TabControl )
}

/**
 * Returns the index of the currently focused tab
 *
 * @author chris, Drugwash, derRaphael
 * @version 1.0
 *
 * @param TabControl
 *            Either the associated variablename, its classname with the index or
 *            the TabControl's windowHandle
 *            May be blank - in this case the 1st found control will be used as default
 * @return ErrorLevel of the SendMessage call
 */
Tab_GetFocus( TabControl = "SysTabControl321" )
{ 
   ; TCM_GETCURFOCUS      := (TCM_FIRST + 47)     := 0x132F
   return % Tab_Send( Msg := 0x132f, wParam := 0, lParam := 0, TabControl ) + 1
}

/**
 * Returns the text of the given tabIndex
 *
 * @author chris, Drugwash, derRaphael, hoppfrosch
 * @version 1.1
 *
 * @param TabIdx
 *            The index of the chosen tab
 * @param TabControl
 *            Either the associated variablename, its classname with the index or
 *            the TabControl's windowHandle
 *            May be blank - in this case the 1st found control will be used as default
 * @return ErrorLevel of the SendMessage call
 */
Tab_GetName( TabIdx, TabControl = "SysTabControl321")                     
{ 
   ; TCM_GETITEMA         := (TCM_FIRST + 5)      := 0x1305
   ; TCM_GETITEMW         := (TCM_FIRST + 60)     := 0x133C
   szBuf :=254 * (A_IsUnicode ? 2 : 1)
   VarSetCapacity(TCITEM, 28, 0)
   VarSetCapacity(Buffer, szBuf, 0)
   NumPut(1, TCITEM, 0, "UInt")
   NumPut(&Buffer, TCITEM, 12, "UInt")
   NumPut(szBuf, TCITEM, 16, "Int")
   Tab_Send( Msg := (A_IsUnicode ? 0x133C : 0x1305), wParam := TabIdx, lParam := &TCITEM, TabControl )
   loopsize := szBuf / (A_IsUnicode ? 2 : 1)
   Loop, %loopsize%
   {
      OutputDebug % "Loopindex:" A_Index
      if (!A_IsUnicode) 
      {
        getchr := NumGet(Buffer, A_Index - 1, "UChar")
        
        OutputDebug % getchr
      }
      else 
      {
       LowByte := NumGet(Buffer, ((A_Index -1) * 2 ), "UChar")
       HiByte := NumGet(Buffer, ((A_Index -1)* 2 )+ 1, "UChar")
       
       getchr := (HiByte << 8) + LowByte
       ; OutputDebug % "Hi:" HiByte " - Low:" LowByte " -> " getchr
      }
      
      if !getchr
         break
      
      ; ToDo: Get the unicode character for  variable "getchr"
      newbuf := newbuf . (A_IsUnicode ? Chr(getchr) : Chr(getchr))
   }
   return newbuf
}

/**
 * An alias for SendMessage to the tabControl
 *
 * @author derRaphael
 * @version 1.0
 *
 * @param msg
 *           The message for the call
 * @param wParam
 *           The wParam
 * @param lParam
 *           The lParam
 * @param TabControl
 *            Either the associated variablename, its classname with the index or
 *            the TabControl's windowHandle
 *            May be blank - in this case the 1st found control will be used as default
 * @return ErrorLevel of the SendMessage call
 */
Tab_Send( ByRef msg, ByRef wParam, ByRef lParam, TabControl = "SysTabControl321" )
{
   SendMessage, %msg%, %wParam%, %lParam%,, % "ahk_id " Tab_GetHwnd( TabControl )
   Return ErrorLevel
}

/**
 * returns the windows handle (hWnd) of the given tabControl
 *
 * @author derRaphael
 * @version 1.1
 *
 * @param TabControl
 *            Either the associated variablename, its classname with the index or
 *            the TabControl's windowHandle
 *            May be blank - in this case the 1st found control will be used as default
 * @return the handle to the given control
 */
Tab_GetHwnd( TabControl = "SysTabControl321" )
{
   If ( TabControl != "" )
   {
      WinGetClass, TestClass, ahk_id %TabControl%
      If ( RegExMatch( TestClass, "^SysTabControl32" ) )
      {
         return % TabControl
      }
   }
   if ( TabControl = "" )
   {
      TabControl := "SysTabControl321"
   }
   GuiControlGet, TabHwnd, Hwnd, %TabControl%
   Return % TabHwnd
}
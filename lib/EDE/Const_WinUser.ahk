; ======================================================================================================================
; Function:         Several Constants from Windows_API (winuser.h)
; AHK version:      1.1.05+
; Language:         English
; Version:          1.0.00.00/2014-09-19/hoppfrosch

; Window field offsets for GetWindowLong() === (winuser.h) =============================================================
class GWL {
	; http://msdn.microsoft.com/en-us/library/windows/desktop/ms633584%28v=vs.85%29.aspx
	static WNDPROC                 := -4
	static HINSTANCE               := -6
	static HWNDPARENT              := -8
	static ID                      := -12
	static STYLE                   := -16
	static EXSTYLE                 := -20
	static USERDATA                := -21
}

; LOWORD(wParam) values in WM_*UISTATE* === (winuser.h=) ===============================================================
class UIS {
	; http://msdn.microsoft.com/en-us/library/windows/desktop/ms646342%28v=vs.85%29.aspx
	static SET                     := 1
	static CLEAR                   := 2
	static INITIALIZE              := 4
}

; LOWORD(wParam) values in WM_*UISTATE* === (winuser.h=) ===============================================================
class UISF {
	; http://msdn.microsoft.com/en-us/library/windows/desktop/ms646342%28v=vs.85%29.aspx
	static ACTIVE                  := 0x4
	static HIDEACCEL               := 0x2
	static HIDEFOCUS               := 0x1
}

; RedrawWindow() flags === (winuser.h) =================================================================================
class RDW {
	; http://msdn.microsoft.com/en-us/library/windows/desktop/dd162911%28v=vs.85%29.aspx
	static INVALIDATE              := 0x0001
	static INTERNALPAINT           := 0x0002
	static ERASE                   := 0x0004
	static VALIDATE                := 0x0008
	static NOINTERNALPAINT         := 0x0010
	static NOERASE                 := 0x0020
	static NOCHILDREN              := 0x0040
	static ALLCHILDREN             := 0x0080
	static UPDATENOW               := 0x0100
	static ERASENOW                := 0x0200
	static FRAME                   := 0x0400
	static NOFRAME                 := 0x0800
}

; Messages / notifications === (winuser.h) =============================================================================
class MN {
	;http://msdn.microsoft.com/en-us/library/windows/desktop/ms632613%28v=vs.85%29.aspx
	static GETHMENU                := 0x01E1
}

class WM {
	static ACTIVATE                := 0x0006
	static ACTIVATEAPP             := 0x001C
	static AFXFIRST                := 0x0360
	static AFXLAST                 := 0x037F
	static APP                     := 0x8000
	static APPCOMMAND              := 0x0319
	static ASKCBFORMATNAME         := 0x030C
	static CANCELMODE              := 0x001F
	static CAPTURECHANGED          := 0x0215
	static CHANGECBCHAIN           := 0x030D
	static CHANGEUISTATE           := 0x0127
	static CHAR                    := 0x0102
	static CHARTOITEM              := 0x002F
	static CHILDACTIVATE           := 0x0022
	static CLEAR                   := 0x0303
	static CLIPBOARDUPDATE         := 0x031D
	static CLOSE                   := 0x0010
	static COMMAND                 := 0x0111
	static COMMNOTIFY              := 0x0044 ; no longer suported
	static COMPACTING              := 0x0041
	static COMPAREITEM             := 0x0039
	static CONTEXTMENU             := 0x007B
	static COPY                    := 0x0301
	static CREATE                  := 0x0001
	static CTLCOLORBTN             := 0x0135
	static CTLCOLORDLG             := 0x0136
	static CTLCOLOREDIT            := 0x0133
	static CTLCOLORLISTBOX         := 0x0134
	static CTLCOLORMSGBOX          := 0x0132
	static CTLCOLORSCROLLBAR       := 0x0137
	static CTLCOLORSTATIC          := 0x0138
	static CUT                     := 0x0300
	static DEADCHAR                := 0x0103
	static DELETEITEM              := 0x002D
	static DESTROY                 := 0x0002
	static DESTROYCLIPBOARD        := 0x0307
	static DEVICECHANGE            := 0x0219
	static DEVMODECHANGE           := 0x001B
	static DISPLAYCHANGE           := 0x007E
	static DRAWCLIPBOARD           := 0x0308
	static DRAWITEM                := 0x002B
	static DROPFILES               := 0x0233
	static DWMCOLORIZATIONCOLORCHANGED    := 0x0320 ; >= Vista
	static DWMCOMPOSITIONCHANGED          := 0x031E ; >= Vista
	static DWMNCRENDERINGCHANGED          := 0x031F ; >= Vista
	static DWMSENDICONICLIVEPREVIEWBITMAP := 0x0326 ; >= Win 7
	static DWMSENDICONICTHUMBNAIL         := 0x0323 ; >= Win 7
	static DWMWINDOWMAXIMIZEDCHANGE       := 0x0321 ; >= Vista
	static ENABLE                  := 0x000A
	static ENDSESSION              := 0x0016
	static ENTERIDLE               := 0x0121
	static ENTERMENULOOP           := 0x0211
	static ENTERSIZEMOVE           := 0x0231
	static ERASEBKGND              := 0x0014
	static EXITMENULOOP            := 0x0212
	static EXITSIZEMOVE            := 0x0232
	static FONTCHANGE              := 0x001D
	static GESTURE                 := 0x0119 ; >= Win 7
	static GESTURENOTIFY           := 0x011A ; >= Win 7
	static GETDLGCODE              := 0x0087
	static GETFONT                 := 0x0031
	static GETHOTKEY               := 0x0033
	static GETICON                 := 0x007F
	static GETMINMAXINFO           := 0x0024
	static GETOBJECT               := 0x003D
	static GETTEXT                 := 0x000D
	static GETTEXTLENGTH           := 0x000E
	static GETTITLEBARINFOEX       := 0x033F ; >= Vista
	static HANDHELDFIRST           := 0x0358
	static HANDHELDLAST            := 0x035F
	static HELP                    := 0x0053
	static HOTKEY                  := 0x0312
	static HSCROLL                 := 0x0114
	static HSCROLLCLIPBOARD        := 0x030E
	static ICONERASEBKGND          := 0x0027
	static IME_CHAR                := 0x0286
	static IME_COMPOSITION         := 0x010F
	static IME_COMPOSITIONFULL     := 0x0284
	static IME_CONTROL             := 0x0283
	static IME_ENDCOMPOSITION      := 0x010E
	static IME_KEYDOWN             := 0x0290
	static IME_KEYLAST             := 0x010F
	static IME_KEYUP               := 0x0291
	static IME_NOTIFY              := 0x0282
	static IME_REQUEST             := 0x0288
	static IME_SELECT              := 0x0285
	static IME_SETCONTEXT          := 0x0281
	static IME_STARTCOMPOSITION    := 0x010D
	static INITDIALOG              := 0x0110
	static INITMENU                := 0x0116
	static INITMENUPOPUP           := 0x0117
	static INPUT                   := 0x00FF
	static INPUT_DEVICE_CHANGE     := 0x00FE
	static INPUTLANGCHANGE         := 0x0051
	static INPUTLANGCHANGEREQUEST  := 0x0050
	static KEYDOWN                 := 0x0100
	static KEYLAST                 := 0x0109
	static KEYUP                   := 0x0101
	static KILLFOCUS               := 0x0008
	static LBUTTONDBLCLK           := 0x0203
	static LBUTTONDOWN             := 0x0201
	static LBUTTONUP               := 0x0202
	static MBUTTONDBLCLK           := 0x0209
	static MBUTTONDOWN             := 0x0207
	static MBUTTONUP               := 0x0208
	static MDIACTIVATE             := 0x0222
	static MDICASCADE              := 0x0227
	static MDICREATE               := 0x0220
	static MDIDESTROY              := 0x0221
	static MDIGETACTIVE            := 0x0229
	static MDIICONARRANGE          := 0x0228
	static MDIMAXIMIZE             := 0x0225
	static MDINEXT                 := 0x0224
	static MDIREFRESHMENU          := 0x0234
	static MDIRESTORE              := 0x0223
	static MDISETMENU              := 0x0230
	static MDITILE                 := 0x0226
	static MEASUREITEM             := 0x002C
	static MENUCHAR                := 0x0120
	static MENUCOMMAND             := 0x0126
	static MENUDRAG                := 0x0123
	static MENUGETOBJECT           := 0x0124
	static MENURBUTTONUP           := 0x0122
	static MENUSELECT              := 0x011F
	static MOUSEACTIVATE           := 0x0021
	static MOUSEHOVER              := 0x02A1
	static MOUSEHWHEEL             := 0x020E ; >= Vista
	static MOUSELEAVE              := 0x02A3
	static MOUSEMOVE               := 0x0200
	static MOUSEWHEEL              := 0x020A
	static MOVE                    := 0x0003
	static MOVING                  := 0x0216
	static NCACTIVATE              := 0x0086
	static NCCALCSIZE              := 0x0083
	static NCCREATE                := 0x0081
	static NCDESTROY               := 0x0082
	static NCHITTEST               := 0x0084
	static NCLBUTTONDBLCLK         := 0x00A3
	static NCLBUTTONDOWN           := 0x00A1
	static NCLBUTTONUP             := 0x00A2
	static NCMBUTTONDBLCLK         := 0x00A9
	static NCMBUTTONDOWN           := 0x00A7
	static NCMBUTTONUP             := 0x00A8
	static NCMOUSEHOVER            := 0x02A0
	static NCMOUSELEAVE            := 0x02A2
	static NCMOUSEMOVE             := 0x00A0
	static NCPAINT                 := 0x0085
	static NCRBUTTONDBLCLK         := 0x00A6
	static NCRBUTTONDOWN           := 0x00A4
	static NCRBUTTONUP             := 0x00A5
	static NCXBUTTONDBLCLK         := 0x00AD
	static NCXBUTTONDOWN           := 0x00AB
	static NCXBUTTONUP             := 0x00AC
	static NEXTDLGCTL              := 0x0028
	static NEXTMENU                := 0x0213
	static NOTIFY                  := 0x004E
	static NOTIFYFORMAT            := 0x0055
	static NULL                    := 0x0000
	static PAINT                   := 0x000F
	static PAINTCLIPBOARD          := 0x0309
	static PAINTICON               := 0x0026
	static PALETTECHANGED          := 0x0311
	static PALETTEISCHANGING       := 0x0310
	static PARENTNOTIFY            := 0x0210
	static PASTE                   := 0x0302
	static PENWINFIRST             := 0x0380
	static PENWINLAST              := 0x038F
	static POWER                   := 0x0048
	static POWERBROADCAST          := 0x0218
	static PRINT                   := 0x0317
	static PRINTCLIENT             := 0x0318
	static QUERYDRAGICON           := 0x0037
	static QUERYENDSESSION         := 0x0011
	static QUERYNEWPALETTE         := 0x030F
	static QUERYOPEN               := 0x0013
	static QUERYUISTATE            := 0x0129
	static QUEUESYNC               := 0x0023
	static QUIT                    := 0x0012
	static RBUTTONDBLCLK           := 0x0206
	static RBUTTONDOWN             := 0x0204
	static RBUTTONUP               := 0x0205
	static RENDERALLFORMATS        := 0x0306
	static RENDERFORMAT            := 0x0305
	static SETCURSOR               := 0x0020
	static SETFOCUS                := 0x0007
	static SETFONT                 := 0x0030
	static SETHOTKEY               := 0x0032
	static SETICON                 := 0x0080
	static SETREDRAW               := 0x000B
	static SETTEXT                 := 0x000C
	static SETTINGCHANGE           := 0x001A ; WM_WININICHANGE
	static SHOWWINDOW              := 0x0018
	static SIZE                    := 0x0005
	static SIZECLIPBOARD           := 0x030B
	static SIZING                  := 0x0214
	static SPOOLERSTATUS           := 0x002A
	static STYLECHANGED            := 0x007D
	static STYLECHANGING           := 0x007C
	static SYNCPAINT               := 0x0088
	static SYSCHAR                 := 0x0106
	static SYSCOLORCHANGE          := 0x0015
	static SYSCOMMAND              := 0x0112
	static SYSDEADCHAR             := 0x0107
	static SYSKEYDOWN              := 0x0104
	static SYSKEYUP                := 0x0105
	static TABLET_FIRST            := 0x02C0
	static TABLET_LAST             := 0x02DF
	static TCARD                   := 0x0052
	static THEMECHANGED            := 0x031A
	static TIMECHANGE              := 0x001E
	static TIMER                   := 0x0113
	static TOUCH                   := 0x0240 ; >= Win 7
	static UNDO                    := 0x0304
	static UNICHAR                 := 0x0109
	static UNINITMENUPOPUP         := 0x0125
	static UPDATEUISTATE           := 0x0128
	static USER                    := 0x0400
	static USERCHANGED             := 0x0054
	static VKEYTOITEM              := 0x002E
	static VSCROLL                 := 0x0115
	static VSCROLLCLIPBOARD        := 0x030A
	static WINDOWPOSCHANGED        := 0x0047
	static WINDOWPOSCHANGING       := 0x0046
	static WININICHANGE            := 0x001A
	static WTSSESSION_CHANGE       := 0x02B1
	static XBUTTONDBLCLK           := 0x020D
	static XBUTTONDOWN             := 0x020B
	static XBUTTONUP               := 0x020C
}

; Styles === (winuser.h) =================================================================================================
class WS {
	static BORDER                  := 0x00800000
	static CAPTION                 := 0x00C00000 ; WS_BORDER|WS_DLGFRAME
	static CHILD                   := 0x40000000
	static CLIPCHILDREN            := 0x02000000
	static CLIPSIBLINGS            := 0x04000000
	static DISABLED                := 0x08000000
	static DLGFRAME                := 0x00400000
	static GROUP                   := 0x00020000
	static HSCROLL                 := 0x00100000
	static ICONIC                  := 0x20000000 ; WS_MINIMIZE
	static MAXIMIZE                := 0x01000000
	static MAXIMIZEBOX             := 0x00010000
	static MINIMIZE                := 0x20000000
	static MINIMIZEBOX             := 0x00020000
	static OVERLAPPED              := 0x00000000
	static POPUP                   := 0x80000000
	static SIZEBOX                 := 0x00040000 ; WS_THICKFRAME
	static SYSMENU                 := 0x00080000
	static TABSTOP                 := 0x00010000
	static THICKFRAME              := 0x00040000
	static TILED                   := 0x00000000 ; WS_OVERLAPPED
	static VISIBLE                 := 0x10000000
	static VSCROLL                 := 0x00200000
; Common Window Styles
	static CHILDWINDOW             := 0x40000000 ; WS_CHILD
	static OVERLAPPEDWINDOW        := 0x00CF0000 ; WS_OVERLAPPED|CAPTION|SYSMENU|THICKFRAME|MINIMIZEBOX|MAXIMIZEBOX
	static POPUPWINDOW             := 0x80880000 ; WS_POPUP|BORDER|SYSMENU
	static TILEDWINDOW             := 0x00CF0000 ; WS_OVERLAPPEDWINDOW

	class EX {
	; ExStyles =============================================================================================================
		static ACCEPTFILES          := 0x00000010
		static APPWINDOW            := 0x00040000
		static CLIENTEDGE           := 0x00000200
		static COMPOSITED           := 0x02000000
		static CONTEXTHELP          := 0x00000400
		static CONTROLPARENT        := 0x00010000
		static DLGMODALFRAME        := 0x00000001
		static LAYERED              := 0x00080000
		static LAYOUTRTL            := 0x00400000  ; Right to left mirroring
		static LEFT                 := 0x00000000
		static LEFTSCROLLBAR        := 0x00004000
		static LTRREADING           := 0x00000000
		static MDICHILD             := 0x00000040
		static NOACTIVATE           := 0x08000000
		static NOINHERITLAYOUT      := 0x00100000  ; Disable inheritence of mirroring by children
		static NOPARENTNOTIFY       := 0x00000004
		static RIGHT                := 0x00001000
		static RIGHTSCROLLBAR       := 0x00000000
		static RTLREADING           := 0x00002000
		static STATICEDGE           := 0x00020000
		static TOOLWINDOW           := 0x00000080
		static TOPMOST              := 0x00000008
		static TRANSPARENT          := 0x00000020
		static WINDOWEDGE           := 0x00000100
		static OVERLAPPEDWINDOW     := 0x00000300 ; WS_EX_WINDOWEDGE|EX_CLIENTEDGE
		static PALETTEWINDOW        := 0x00000188 ; WS_EX_WINDOWEDGE|EX_TOOLWINDOW|EX_TOPMOST
	}
}
; ======================================================================================================================
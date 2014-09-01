; Mit diesem Skript werden
; - die eigenen Quellcodedateien von DebugAusgaben bereinigt
; - die Doku auf den Bereinigten Dateien erzeugt
; - die benötigten Includes hinzukopiert
; - Das Verzeichnis gepackt

#include _inc\BuildTools.ahk
#include ..\cGist.ahk

user := "AHKUser"
pw := "AHKUser2012"
oGist := new Gist(user, pw)
version := oGist.version()

MsgBox % version

srcBaseDir := A_ScriptDir "\.."
zipBaseDir := A_ScriptDir "\Release"
dstBaseDir := zipBaseDir "\cGist"

/*
line :=  TF_Find(srcBaseDir "\cTable.ahk","","","Version")
version := Trim(TF_ReadLines(srcBaseDir "\cTable.ahk", line,line))
xnewversion := RegExMatch(version,"${newVersion}(\d+\.\d+\.\d+)")
*/

FileRemoveDir, %zipBaseDir%, 1
FileCreateDir, %zipBaseDir%
; Bereinige die eigenen Quellcode-Dateien
CleanCode(makeCopy(srcBaseDir "\cGist.ahk", dstBaseDir))

; Erzeuge die Doku nur fuer die eigenen Dateien
; MakeDoc(dstBaseDir)
; MakeDoc(dstBaseDir "\_inc")

;-----------------------------------------------------------------------
; Kopieren mit/ohne Bereinigen der sonstigen zu packenden Dateien

CleanCode(makeCopy(srcBaseDir "\_Test.ahk", dstBaseDir))
; Kopiere die UnitTest-Dateien 
;MakeCopy(srcBaseDir "\UTest\UTest.ahk", dstBaseDir "\UTest")
;MakeCopy(srcBaseDir "\UTest\cTable_UTest.ahk", dstBaseDir "\UTest")
;MakeCopy(srcBaseDir "\UTest\Attach.ahk", dstBaseDir "\UTest")
;MakeCopy(srcBaseDir "\UTest\util.ahk", dstBaseDir "\UTest")
;MakeCopy(srcBaseDir "\UTest\tostring.ahk", dstBaseDir "\UTest")

; Generiere die Zip-Files
SetWorkingDir %zipBaseDir%
ZipFile := A_ScriptDir "\cGist.zip"
FileDelete, %ZipFile%
Zip(zipBaseDir, ZipFile)
ZipFile := A_ScriptDir "\cGist." version ".zip"
FileDelete, %ZipFile%
Zip(zipBaseDir, ZipFile)
SetWorkingDir A_ScriptDir
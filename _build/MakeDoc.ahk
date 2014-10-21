; Mit dem Skript wird die Dokumentation im Ordner gh_pages erzeugt

#include _inc\BuildTools.ahk
#NoEnv

srcBaseDir := A_ScriptDir "\..\lib\EDE"
dstBaseDir := A_ScriptDir "\..\..\gh_pages"

makeCopy(srcBaseDir "\..\..\Ede.ahk", dstBaseDir)
makeCopy(srcBaseDir "\WindowHandler.ahk", dstBaseDir)
makeCopy(srcBaseDir "\Rectangle.ahk", dstBaseDir)
;makeCopy(srcBaseDir "\_inc\cJeeBooConfig.ahk", dstBaseDir "\_inc") 

; Erzeuge die Doku nur fuer die eigenen Dateien
MakeDoc(dstBaseDir)
;MakeDoc(dstBaseDir "\inc")

FileDelete, %dstBaseDir%\Ede.ahk
FileDelete, %dstBaseDir%\WindowHandler.ahk
FileDelete, %dstBaseDir%\Rectangle.ahk
;FileDelete, %dstBaseDir%\_inc\cJeeBooConfig.ahk

;FileCopy, %dstBaseDir%\Ede.html, %dstBaseDir%\index.html

; Erzeugung der Dokumnetation für alle Dateien im Ordner
MakeDoc(srcDir) 
{
   SendMode Input
   SetWorkingDir %srcDir%
   EnvGet, PATH, PATH
   EnvSet, PATH, d:\portable\PortableApps\AutoHotkey\App\Tools\NaturalDocs\mkDoc\;d:\portable\PortableApps\AutoHotkey\App\Tools\NaturalDocs\NaturalDocs;%PATH%
   Run, %comspec% /c mkdoc.bat s
   Sleep, 2500
   SetWorkingDir A_ScriptDir
}

/* 
	Copies file from src to dest
	
	Returns new filename
*/
MakeCopy(src,destDir="")
{
	src := R2A_Path(src)
	dest := R2A_Path(destDir)
	
	IfNotExist, %dest%
		FileCreateDir, %dest%
	
	FileCopy, %src%, %dest%
	SetWorkingDir %dest%
	SplitPath, src, name, dir, ext, name_no_ext, drive
	name := R2A_Path(".\" name)
	SetWorkingDir A_ScriptDir
	return, name
}


/*
  Cleans up the code 
    * Removes all debug output relevant code ...
*/
CleanCode(name)
{
	TF_RemoveRegExLines("!" name, "i)_DBG_|_\.ahk|\s+m\s*\(|^m\s*\(|\s+_\s*\(|^_\s*\(")	

	return
}


/*
	Converts a relative path to and absolute path
	Author	: R3gX
	Link	: http://www.autohotkey.com/forum/viewtopic.php?t=71966
*/
R2A_Path(Path){
	If !InStr(FileExist(Path), "D")		; If the path is a for a file,
		SplitPath, Path, FileName, Path	;	Path = file's folder
	LastWorkingDir := A_WorkingDir
	SetWorkingDir, % Path
	Error	:= ErrorLevel	; If there is a problem, the function will returns an empty string
	Path	:= A_WorkingDir
	SetWorkingDir, % LastWorkingDir
	Return, Error ? "" : RegExReplace(Path "\" FileName, "\\*$")
}

/*
  Removes text-lines specified by RegEx from File
*/
TF_RemoveRegExLines(Text, NeedleRegEx = "", StartLine = 1, EndLine = 0)
{
   TF_GetData(OW, Text, FileName)
   If (RegExMatch(Text, NeedleRegEx) < 1)
      Return Text ; No lines matching RegEx so return and do nothing, we have to return Text in case of a variable otherwise it would empty the variable contents bug fix 3.3
   TF_MatchList:=_MakeMatchList(Text, StartLine, EndLine) ; create MatchList
   Loop, Parse, Text, `n, `r
   { 
      If A_Index in %TF_MatchList%
         OutPut .= (RegExMatch(A_LoopField,NeedleRegEx)) ? : A_LoopField "`n"
      Else
      	OutPut .= A_LoopField "`n"
      }
   Return TF_ReturnOutPut(OW, OutPut, FileName)
}

;; -----------    THE FUNCTIONS   -------------------------------------
Zip(FilesToZip,sZip)
{
If Not FileExist(sZip)
   CreateZipFile(sZip)
psh := ComObjCreate( "Shell.Application" )
pzip := psh.Namespace( sZip )
if InStr(FileExist(FilesToZip), "D")
   FilesToZip .= SubStr(FilesToZip,0)="\" ? "*.*" : "\*.*"
loop,%FilesToZip%,1
{
   ToolTip Zipping %A_LoopFileName% ..
   pzip.CopyHere( A_LoopFileLongPath, 4|16 ) ;see options below
   sleep 400
}
ToolTip
}

CreateZipFile(sZip)
{
   Header1 := "PK" . Chr(5) . Chr(6)
   VarSetCapacity(Header2, 18, 0)
   file := FileOpen(sZip,"w")
   file.Write(Header1)
   file.RawWrite(Header2,18)
   file.close()
}

Unz(sZip, sUnz)
{
    fso := ComObjCreate("Scripting.FileSystemObject")
    If Not fso.FolderExists(sUnz)  ;http://www.autohotkey.com/forum/viewtopic.php?p=402574
       fso.CreateFolder(sUnz)
    psh  := ComObjCreate("Shell.Application")
    zippedItems := psh.Namespace( sZip ).items().count
    psh.Namespace( sUnz ).CopyHere( psh.Namespace( sZip ).items, 4|16 )
    Loop {
        sleep 100
        unzippedItems := psh.Namespace( sUnz ).items().count
        ToolTip Unzipping in progress..
        IfEqual,zippedItems,%unzippedItems%
            break
    }
    ToolTip
}

;; -----------    END FUNCTIONS   -------------------------------------
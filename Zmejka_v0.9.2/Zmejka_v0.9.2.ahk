#Include GetSelectedFile.ahk
#Include GetSelectedExe.ahk
#Include CheckFDSInstallation.ahk
#Include Parse_FDS.ahk
#Include AddRestartToMiscLine.ahk
#Include RemoveRestartFromMiscLine.ahk
#Include CheckRestartFile.ahk
#SingleInstance Off
#Persistent
#NoEnv
SetTitleMatchMode, 2

If FileExist(A_ScriptDir "\FDSpath.ini")
	IniRead, FDSpath, %A_ScriptDir%\FDSpath.ini, FDSpath, FDSpath
Else
	FDSpath := ""
If FileExist(A_ScriptDir "\MPIpath.ini")
	IniRead, MPIpath, %A_ScriptDir%\MPIpath.ini, MPIpath, MPIpath
Else
	MPIpath := ""

;Gui +Resize
;Gui, Add, Edit, vFilePath, % "Enter .fds file path here"
Gui, Add, Tab3,, General|View|Settings
Gui, Add, Edit, x15 y35 vFolderPath w240 h20 r1, % "Enter fds file folder path here"
Gui, Add, Edit, x15 y60 vFileName w240 h20 r1, % "File name is stored here"
Gui, Add, Button, x260 y45 gBrowseFileButton, Browse .fds
Gui, Add, Button, x15 y100 gStartButton, Start
Gui, Add, Button, x15 y130 gPauseButton, Pause
Gui, Add, Button, x65 y100 gStopButton, Stop
Gui, Add, Button, x65 y130 gKillButton, Kill
Gui, Add, Button, x15 y160 gCheckFDS, Check FDS
Gui, Add, Button, x112 y99 w80 h20 gBrowseFDSButton, Browse fds.exe
Gui, Add, Edit, x202 y99 w130 h20 vFDSpath, %FDSpath%
Gui, Add, Button, x112 y129 w80 h20 gBrowseMPIButton, Browse mpi
Gui, Add, Edit, x202 y129 w130 h20 vMPIpath, %MPIpath%
Gui, Show
Return

BrowseFileButton:
	GetSelectedFile(folderPath, fileName, filePath)
	IniWrite, %filePath%, %A_ScriptDir%\filePath.ini, filePath, filePath
	;MsgBox % "the file path is " filePath "and the file name is " fileName
	;FileSelectFile, filePath, 3, , Select .fds file
	GuiControl,, folderPath, % folderPath
	GuiControl,, fileName, % fileName
	IniRead, filePath, %A_ScriptDir%\filePath.ini, filePath, filePath
	;MsgBox, folderPath is writen as %folderPath%
Return

;BrowseFolderButton:
;	FileSelectFolder, folderPath, 3, , Select .fds file folder
;	GuiControl,, folderPath, % FolderPath
;Return

StartButton:
	IniRead, filePath, %A_ScriptDir%\filePath.ini, filePath, filePath
;	removeRTag := removeRestartFromMiscLine(filePath)
;	If (removeRTag) {
;		ToolTip, "RESTART=T" successfully removed from the "&MISC" line.
;		SetTimer, RemoveToolTip, -1000
;	} Else {
;		ToolTip, Failed to remove "RESTART=T" from the "&MISC" line.
;		SetTimer, RemoveToolTip, -1000
;	}
;	CheckFDSInstallation()
	GuiControlGet, folderPath, , folderPath
	GuiControlGet, fileName, , fileName
	If (FDSpath != "")
	{
		GuiControlGet, FDSpath, , FDSpath
	}
	Else
	{
		ToolTip, No fds.exe specified
			Sleep, 1000
		SetTimer, RemoveToolTip, -1000
	}
	If (MPIpath != "")
	{
		GuiControlGet, MPIpath, , MPIpath
	}
	Else
	{
		ToolTip, No mpiexec.exe specified
			Sleep, 1000
		SetTimer, RemoveToolTip, -1000
	}
	If FileExist(filePath)
	{
		FileMove, %folderPath%\%fileName%.fds, %A_ScriptDir%\%fileName%\*, 1
		FileMove, %folderPath%\%fileName%*.*, %A_ScriptDir%\%fileName%\*, 1
	}
	Else
	{
		MsgBox, No %filePath% file in %A_ScriptDir% folder
	}
	; Check if fdsscenario.restart file exists
	FileExistsRestart := FileExist(folderPath "\" fileName "*.restart")
	If (FileExistsRestart) {
		checkRTag := CheckRestartTag(filePath)
		ToolTip, Restart file(s) found. Trying to resume FDS instance.
			Sleep, 1000
		SetTimer, RemoveToolTip, -1000
	}
	Else
	{
		ToolTip, Restart file not found!
			Sleep, 1000
		SetTimer, RemoveToolTip, -1000
		removeRTag := removeRestartFromMiscLine(filePath)
		If (removeRTag)
		{
			ToolTip, "RESTART=T" successfully removed from the "&MISC" line.
				Sleep, 1000
			SetTimer, RemoveToolTip, -1000
		}
		Else
		{
			ToolTip, Failed to remove "RESTART=T" from the "&MISC" line.
				Sleep, 1000
			SetTimer, RemoveToolTip, -1000
		}
	}
	FileDelete, %folderPath%\%filename%*.stop
	FileMove, %folderPath%\%fileName%*.*, %A_ScriptDir%\, 1
	FileMove, %folderPath%\%fileName%.fds, %A_ScriptDir%\, 1
	filePath := A_ScriptDir "\" filename ".fds"
	If (FileExist(A_ScriptDir "\FDSpath.ini") && (FDSpath != "") && FileExist(A_ScriptDir "\MPIpath.ini") && (MPIpath != ""))
	{
		MPI_PROCESS_NUM := Parse_FDS(filePath)
		ToolTip, % "Number of MPI processes detected: " MPI_PROCESS_NUM
			Sleep, 1000
		ToolTip, "%MPIpath%" -n %MPI_PROCESS_NUM% "%FDSpath%" "%folderPath%\%fileName%.fds"
			Sleep, 1000
		SetTimer, RemoveToolTip, -1000
		RunWait, "%MPIpath%" -n %MPI_PROCESS_NUM% "%FDSpath%" "%filePath%"
	}
	Else If (FileExist(A_ScriptDir "\FDSpath.ini") && (FDSpath != ""))
	{
		ToolTip, FDSpath.ini exists and "%FDSpath%" is not empty
			Sleep, 1000
		ToolTip, mpiexec.exe will be omitted upon running %fileName%.fds
			Sleep, 1000
		SetTimer, RemoveToolTip, -1000
		RunWait, "%FDSpath%" "%filePath%"
	}
	Else
	{
		CheckFDSExe := FileExist(A_ProgramFiles "\firemodels\FDS6\bin\fds.exe")
		;	MsgBox, % CheckFDSExe
		If (CheckFDSExe = "A") 
		{
			ToolTip, Path to fds.exe was not specified. Using the latest version of FDS, installed on this PC
				Sleep, 1000
			ToolTip, mpiexec.exe will be omitted upon running %fileName%.fds
				Sleep, 1000
			SetTimer, RemoveToolTip, -1000
			RunWait, fds "%filePath%"
		}
		Else
		{
			MsgBox, Please specify the path to fds.exe within which %fileName%.fds was created.
		}
	}
	;	Get the list of simulation results files with %fileName% prefix
	ResultsList := ""
	Loop, Files, %A_ScriptDir%\%fileName%*.*
	{
		ResultsList .= A_LoopFileFullPath "`n"
	}
	;	Move the files to the %fileName%.fds folder
	FileMove, %A_ScriptDir%\%fileName%*.*, %folderPath%\, 1
	FileMove, %A_ScriptDir%\%fileName%*.restart, %folderPath%\, 1
Return

PauseButton:
	GuiControlGet, folderPath, , folderPath
	GuiControlGet, fileName, , fileName
	IfWinExist, fds
	{
		FileAppend, , %A_ScriptDir%\%filename%.stop
		ToolTip, stopping FDS
			Sleep, 1000
		WinWaitClose
	}
	FileMove, %A_ScriptDir%\%fileName%*.*, %folderPath%\, 1
	ToolTip, files moved to %folderPath%
		Sleep, 1000
	SetTimer, RemoveToolTip, -1000
	IniRead, filePath, %A_ScriptDir%\filePath.ini, filePath, filePath
	;	MsgBox, 4096, DEBUG, filePath is %filePath%
	;	FileMove, %folderPath%\%fileName%.stop, %A_ScriptDir%\, 1
	;	Check if RESTART tag already exists
	checkRTag := CheckRestartTag(filePath)
	If (checkRTag = 0)
	{
		ToolTip, Restart tag was not found in the &MISC line.
			Sleep, 1000
		AddRestartToMiscLine(filePath)
		ToolTip, Restart tag is now added to the &MISC line.
			Sleep, 1000
		SetTimer, RemoveToolTip, -1000
	}
	Else
	{
		ToolTip, Restart tag is in the &MISC line.
			Sleep, 1000
		SetTimer, RemoveToolTip, -1000
	}
	;	MsgBox, 4096, DEBUG, checkRTag is %checkRTag%
	;	Add RESTART=T into .fds record
Return

StopButton:
	GuiControlGet, folderPath, , folderPath
	GuiControlGet, fileName, , fileName
	IfWinExist, fds
	{
		FileAppend, , %A_ScriptDir%\%filename%.stop
		ToolTip, stopping FDS
			Sleep, 1000
		WinWaitClose
	}
		ToolTip, fds.exe is closed
			Sleep, 1000
	FileMove, %A_ScriptDir%\%fileName%*.*, %folderPath%\, 1
		ToolTip, files moved to %folderPath%
			Sleep, 1000
	IniRead, filePath, %A_ScriptDir%\filePath.ini, filePath, filePath
	checkRTag := CheckRestartTag(filePath)
	If (checkRTag = 1)
	{
		removeRTag := removeRestartFromMiscLine(filePath)
		ToolTip, Restart tag is removed from the &MISC line.
			Sleep, 1000
		SetTimer, RemoveToolTip, -1000
	}
	Else
	{
		ToolTip, Restart tag is not in the &MISC line.
			Sleep, 1000
		SetTimer, RemoveToolTip, -1000
	}
Return

KillButton:
	GuiControlGet, folderPath, , folderPath
	GuiControlGet, fileName, , fileName
	;	Close CMD with FDS ro MPI job instance
	If (WinExist(AHK_exe fds.exe) || WinExist(AHK_exe mpiexec.exe))
	{
		WinKill, ahk_class ConsoleWindowClass
	}
	Else
	{
		MsgBox, There is no active FDS or MPI job running
	}
	FileMove, %A_ScriptDir%\%fileName%*.*, %folderPath%\, 1
	FileDelete, %folderPath%\%filename%.stop
	IniRead, filePath, %A_ScriptDir%\filePath.ini, filePath, filePath
	removeRTag := removeRestartFromMiscLine(filePath)
	If (removeRTag)
	{
		ToolTip, "RESTART=T" successfully removed from the "&MISC" line.
			Sleep, 1000
		SetTimer, RemoveToolTip, -1000
	}
	Else
	{
		ToolTip, Failed to remove "RESTART=T" from the "&MISC" line.
			Sleep, 1000
		SetTimer, RemoveToolTip, -1000
	}
Return

CheckFDS:
	GuiControlGet, checkFDS, , checkFDS
	CheckFDSInstallation()
Return

BrowseFDSButton:
	GetSelectedExe(FDSpath)
	IniWrite, %FDSpath%, %A_ScriptDir%\FDSpath.ini, FDSpath, FDSpath
	GuiControl, , FDSpath, % FDSpath
	If !(FileExist(A_ScriptDir "\FDSpath.ini"))
	{
		IniWrite, %FDSpath%, %A_ScriptDir%\FDSpath.ini, FDSpath, FDSpath
	}
	Else
	{
		IniRead, FDSpath, %A_ScriptDir%\FDSpath.ini, FDSpath, FDSpath
	}
Return

BrowseMPIButton:
	GetSelectedExe(MPIpath)
	GuiControl, , MPIpath, % MPIpath
	If !(FileExist(A_ScriptDir "\MPIpath.ini"))
	{
		IniWrite, %MPIpath%, %A_ScriptDir%\MPIpath.ini, MPIpath, MPIpath
	}
	Else
	{
		IniRead, MPIpath, %A_ScriptDir%\MPIpath.ini, MPIpath, MPIpath
	}
Return

RemoveToolTip:
	ToolTip
Return

GuiClose:
	ExitApp
Return

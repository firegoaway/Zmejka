#Include GetSelectedFile.ahk
#Include GetSelectedExe.ahk
#Include CheckFDSInstallation.ahk
#Include Parse_FDS.ahk
#Include AddRestartToMiscLine.ahk
#Include RemoveRestartFromMiscLine.ahk
#Include CheckRestartFile.ahk
#Include ExtractLastTotalTime.ahk
#Include SearchForTEND.ahk
#Include CheckCHID.ahk
#Include CheckDUMP.ahk
#Include UnCheckDUMP.ahk
#SingleInstance Off
#Persistent
#NoEnv
SetTitleMatchMode, 2

If FileExist(A_ScriptDir "\FDSpath.ini")
{
	IniRead, FDSpath, %A_ScriptDir%\FDSpath.ini, FDSpath, FDSpath
}
Else
{
	FDSpath := ""
}

If FileExist(A_ScriptDir "\MPIpath.ini")
{
	IniRead, MPIpath, %A_ScriptDir%\MPIpath.ini, MPIpath, MPIpath
}
Else
{
	MPIpath := ""
}

If FileExist(A_ScriptDir "\filePath.ini")
{
	IniRead, filePath, %A_ScriptDir%\filePath.ini, filePath, filePath
}
Else
{
	filePath := ""
}

Gui, Add, Tab3, x2 y-1 w390 h310 +BackgroundTrans, Главный экран|Параметры|Построение графиков
Gui, Tab, Главный экран
Gui, Add, Edit, x12 y39 vFolderPath w240 h20, % "Укажите путь к папке с файлом сценария (.fds)"
Gui, Add, Edit, x12 y69 vFileName w240 h20, % "Укажите имя файла сценария (.fds)"
Gui, Add, Button, x262 y49 gBrowseFileButton w100 h30, Выбрать .fds
Gui, Add, Button, x12 y109 w80 h30 gStartButton, Старт
Gui, Add, Button, x102 y109 w80 h30 gPauseButton, Пауза
Gui, Add, Button, x192 y109 w80 h30 gStopButton, Стоп
Gui, Add, Button, x282 y109 w80 h30 gKillButton, Прервать
Gui, Add, Button, x12 y149 w80 h30 gBrowseFDSButton, Найти fds.exe
Gui, Add, Edit, x102 y149 w260 h30 vFDSpath, %FDSpath%
Gui, Add, Button, x12 y189 w80 h30 gBrowseMPIButton, Найти mpi.exe
Gui, Add, Edit, x102 y189 w260 h30 vMPIpath, %MPIpath%
Gui, Add, Button, x12 y229 w80 h30 gCheckFDS, Проверить наличие FDS
Gui, Add, Text, x295 y285 w160 h20 , Zmejka_v0.12.4
Gui, Tab, Параметры
Gui, Add, Checkbox, x22 y29 w150 h20 gChckAlwDTR vChckAlw, Добавить DT_RESTART
Gui, Add, Edit, x192 y29 w60 h20 vChckDTR Number, 100
Gui, Add, Text, x262 y29 w30 h20 , сек
Gui, Add, Text, x22 y69 w120 h40 , Подготовить FDS к расчёту F (dэфф) для нахождения tпор
Gui, Add, Button, x152 y69 w100 h40 gRunInsertDEVC, Insert_DEVC
Gui, Add, Text, x22 y119 w120 h40 , Привести параметры моделирования пожара к требуемым
Gui, Add, Button, x152 y119 w100 h40 gRunSURF, SURF_FIX
Gui, Add, Text, x22 y169 w120 h40 , Разбить расчётную область
Gui, Add, Button, x152 y169 w100 h40 gRunPartitioner, Partition
Gui, Add, Text, x22 y219 w120 h40 , Уменьшить/увеличить размер ячейки
Gui, Add, Button, x152 y219 w100 h40 gRunRefiner, Refine/Coarsen
Gui, Add, Text, x295 y285 w160 h20 , Zmejka_v0.12.4
Gui, Tab, Построение графиков
Gui, Add, Text, x22 y69 w120 h40 , Построить график F (dэфф) для нахождения tпор
Gui, Add, Button, x152 y69 w100 h40 gRunPCTT, PCTT
Gui, Add, Text, x22 y119 w110 h40 , Построить график плотности людских потоков
Gui, Add, Button, x152 y119 w100 h40 gRunPFED, PFED
Gui, Add, Text, x22 y169 w120 h40 , Построить график мощности пожара (HRR)
Gui, Add, Button, x152 y169 w100 h40 gRunHRRP, HRRP
Gui, Add, Text, x295 y285 w160 h20 , Zmejka_v0.12.4

Gui, Show, h310 w395, ZmejkaFDS
Return

BrowseFileButton:
	Gui, Submit, NoHide
	GetSelectedFile(folderPath, fileName, filePath)
	IniWrite, %filePath%, %A_ScriptDir%\filePath.ini, filePath, filePath
	GuiControl,, folderPath, % folderPath
	GuiControl,, fileName, % fileName
	IniRead, filePath, %A_ScriptDir%\filePath.ini, filePath, filePath
	sleep, 50
	CheckCHID(filePath)
	sleep, 50
	Return
	
ChckAlwDTR:
	Gui, Submit, NoHide
	If (ChckAlw = 1)
	{
		CheckDUMP(filePath, ChckDTR)
	}
	else if (ChckAlw = 0)
	{
		UnCheckDUMP(filePath)
	}
	Return

StartButton:
	IniRead, filePath, %A_ScriptDir%\filePath.ini, filePath, filePath
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
		filePath := A_ScriptDir "\" fileName ".fds"
		OutfilePath := A_ScriptDir "\" fileName ".out"
	}
	Else
	{
		MsgBox, No %filePath% file in %A_ScriptDir% folder
	}
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
	FileDelete, %folderPath%\%fileName%*.stop
	if InStr(fileName, "_tout")
	{
		FileMove, %folderPath%\%fileName%*.*, %A_ScriptDir%\, 1
		FileMove, %folderPath%\%fileName%.fds, %A_ScriptDir%\, 1
		filePath := A_ScriptDir "\" fileName ".fds"
		OutfilePath := A_ScriptDir "\" fileName ".out"
	}
	else
	{
		FileMove, %folderPath%\%fileName%*.*, %A_ScriptDir%\, 1
		FileMove, %folderPath%\%fileName%.fds, %A_ScriptDir%\, 1
		filePath := A_ScriptDir "\" fileName ".fds"
		OutfilePath := A_ScriptDir "\" fileName ".out"
	}
	
	
	If (FileExist(A_ScriptDir "\FDSpath.ini") && (FDSpath != "")) && (FileExist(A_ScriptDir "\MPIpath.ini") && (MPIpath != ""))
	{
		MPI_PROCESS_NUM := Parse_FDS(filePath)
		ToolTip, % "Number of MPI processes detected: " MPI_PROCESS_NUM
		Sleep, 1000
		ToolTip, "%MPIpath%" -n %MPI_PROCESS_NUM% "%FDSpath%" "%filePath%"
		Sleep, 1000
		ToolTip
		Run, "%MPIpath%" -n %MPI_PROCESS_NUM% "%FDSpath%" "%filePath%"
	}
	Else If (!FileExist(A_ScriptDir "\FDSpath.ini") || (FDSpath = "")) && (FileExist(A_ScriptDir "\MPIpath.ini") && (MPIpath != ""))
	{
		FDSpath := A_ProgramFiles "\firemodels\FDS6\bin\fds.exe"
		MPI_PROCESS_NUM := Parse_FDS(filePath)
		ToolTip, % "Number of MPI processes detected: " MPI_PROCESS_NUM
		Sleep, 1000
		ToolTip, "%MPIpath%" -n %MPI_PROCESS_NUM% "%FDSpath%" "%filePath%"
		Sleep, 1000
		ToolTip
		Run, "%MPIpath%" -n %MPI_PROCESS_NUM% "%FDSpath%" "%filePath%"
	}
	Else If (FileExist(A_ScriptDir "\FDSpath.ini") && (FDSpath != "")) && (!FileExist(A_ScriptDir "\MPIpath.ini") && (MPIpath = ""))
	{
		IniRead, FDSpath, %A_ScriptDir%\FDSpath.ini, FDSpath, FDSpath
		ToolTip, FDSpath.ini exists and "%FDSpath%" is not empty
		Sleep, 1000
		ToolTip, mpiexec.exe will be omitted upon running %fileName%.fds
		Sleep, 1000
		ToolTip
		Run, "%FDSpath%" "%filePath%"
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
			Run, fds "%filePath%"
		}
		Else
		{
			MsgBox, Please specify the path to fds.exe within which %fileName%.fds was created.
		}
	}
	
	Loop
	{
		LastTotalTime := ExtractLastTotalTime(OutfilePath)
		Sleep, 1000
		If FileExist(OutfilePath)
		{
			Break
		}
		Else If !(FileExist(OutfilePath)) || (LastTotalTime < LastTotalTime + 10)
		{
			Continue
		}
		Else
		{
			Continue
		}
	}
	Progress, M2 x500 y500 w250
	Loop
	{
		If FileExist(OutfilePath)
		{
			TEND := SearchForTEND(filePath)
			TotalTime := Ceil(ExtractLastTotalTime(OutfilePath))
			ProgressPercentage := Ceil((TotalTime / TEND) * 100)
			Progress, %ProgressPercentage%
			Sleep, 250
			Continue
		}
		Else If (TotalTime = TEND) || !FileExist(OutfilePath)
		{
			Break
		}
		Else
		{
			Continue
		}
	}
	Until (TotalTime >= TEND) || OutFileExists
	{
		Progress Off
	}
	
	;	Get the list of simulation results files with %fileName% prefix
	ResultsList := ""
	Loop, Files, %A_ScriptDir%\%fileName%*.*
	{
		ResultsList .= A_LoopFileFullPath "`n"
	}
	;	Move the files to the %fileName%.fds folder
	file_Exist := A_ScriptDir "\" fileName "*" "." "*"
	if FileExist(file_Exist)
	{
		Loop,
		{
			FileMove, %A_ScriptDir%\%fileName%*.*, %folderPath%\, 1
		}
		Until !FileExist(file_Exist)
	}
	else
	{
		ToolTip, % fileName " not found dude"
		Sleep, 250
	}
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
	
	ResultsList := ""
	Loop, Files, %A_ScriptDir%\%fileName%*.*
	{
		ResultsList .= A_LoopFileFullPath "`n"
	}
	;	Move the files to the %fileName%.fds folder
	file_Exist := A_ScriptDir "\" fileName "*" "." "*"
	if FileExist(file_Exist)
	{
		Loop,
		{
			FileMove, %A_ScriptDir%\%fileName%*.*, %folderPath%\, 1
		}
		Until !FileExist(file_Exist)
	}
	else
	{
		ToolTip, % fileName " not found dude"
		Sleep, 250
	}
	
	ToolTip, files moved to %folderPath%
	Sleep, 1000
	SetTimer, RemoveToolTip, -1000
	IniRead, filePath, %A_ScriptDir%\filePath.ini, filePath, filePath
	; Check if RESTART tag already exists
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
	; MsgBox, 4096, DEBUG, checkRTag is %checkRTag%
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
	
	ResultsList := ""
	Loop, Files, %A_ScriptDir%\%fileName%*.*
	{
		ResultsList .= A_LoopFileFullPath "`n"
	}
	;	Move the files to the %fileName%.fds folder
	file_Exist := A_ScriptDir "\" fileName "*" "." "*"
	if FileExist(file_Exist)
	{
		Loop,
		{
			FileMove, %A_ScriptDir%\%fileName%*.*, %folderPath%\, 1
		}
		Until !FileExist(file_Exist)
	}
	else
	{
		ToolTip, % fileName " not found dude"
		Sleep, 250
	}
	
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
	; Close CMD with FDS ro MPI job instance
	If (WinExist(AHK_exe fds.exe) || WinExist(AHK_exe mpiexec.exe))
	{
		WinKill, ahk_class ConsoleWindowClass
	}
	Else
	{
		MsgBox, There is no active FDS or MPI job running
	}
	
	ResultsList := ""
	Loop, Files, %A_ScriptDir%\%fileName%*.*
	{
		ResultsList .= A_LoopFileFullPath "`n"
	}
	;	Move the files to the %fileName%.fds folder
	file_Exist := A_ScriptDir "\" fileName "*" "." "*"
	if FileExist(file_Exist)
	{
		Loop,
		{
			FileMove, %A_ScriptDir%\%fileName%*.*, %folderPath%\, 1
		}
		Until !FileExist(file_Exist)
	}
	else
	{
		ToolTip, % fileName " not found dude"
		Sleep, 250
	}
	
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

RunInsertDEVC:
	Run, Insert_DEVC.exe
	Return

RunPCTT:
	Run, PCTT.exe
	Return

RunPFED:
	Run, PFED.exe
	Return

RunSURF:
	Run, Расчёт_tmax.exe
		Sleep, 50
	Run, SURF_FIX.exe
	Return

RunHRRP:
	Run, HRRP.exe
	Return
	
RunPartitioner:
	Run, FMT Partitioner.exe
	Return

RunRefiner:
	Run, FMT Refiner-Coarsener.exe
	Return

RemoveToolTip:
	ToolTip
	Return

GuiClose:
	ExitApp
	Return

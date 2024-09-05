/*
	ZmejkaFDS версии 0.12.7 и выше разработана экслюзивно для сообщества FIREGOAWAY
*/

#Include %A_ScriptDir%\a_libs\GetSelectedFile.ahk
#Include %A_ScriptDir%\a_libs\GetSelectedExe.ahk
#Include %A_ScriptDir%\a_libs\CheckFDSInstallation.ahk
#Include %A_ScriptDir%\a_libs\Parse_FDS.ahk
#Include %A_ScriptDir%\a_libs\AddRestartToMiscLine.ahk
#Include %A_ScriptDir%\a_libs\RemoveRestartFromMiscLine.ahk
#Include %A_ScriptDir%\a_libs\CheckRestartFile.ahk
#Include %A_ScriptDir%\a_libs\ExtractLastTotalTime.ahk
#Include %A_ScriptDir%\a_libs\SearchForTEND.ahk
#Include %A_ScriptDir%\a_libs\CheckCHID.ahk
#Include %A_ScriptDir%\a_libs\CheckDUMP.ahk
#Include %A_ScriptDir%\a_libs\UnCheckDUMP.ahk
#Include %A_ScriptDir%\a_libs\Process_MISC_Line_to_FDS5.ahk
#Include %A_ScriptDir%\a_libs\Process_REAC_Line_to_FDS5.ahk
#Include %A_ScriptDir%\a_libs\Remove_HCL_Lines.ahk
#Include %A_ScriptDir%\a_libs\Remove_SPEC_COMB_WIND_Lines.ahk
#Include %A_ScriptDir%\a_libs\RunSimulationFDS5.ahk

#SingleInstance Off
#Persistent
#NoEnv
SetTitleMatchMode, 2

/*
	Инициализация среды embed (начало)
*/

AHKU64EXE := A_ScriptDir "\a_embed\AutoHotkeyU64.exe"
PyExe := A_ScriptDir "\p_embed\pythonw.exe"
PyExeConsole := A_ScriptDir "\p_embed\python.exe"
FDS5EXE := A_ScriptDir "\FDS5\fds5_mpi_win_64.exe"
FDS5EXEnoMPI := A_ScriptDir "\FDS5\fds5.exe"

;	Динамические библиотеки (начало)

; 	Модули (начало)

Insert_DEVC := A_ScriptDir "\a_libs\Insert_DEVC_v0.4.1.ahk"
PCTT := A_ScriptDir "\p_libs\Plot_CSV_Time_Threshhold_v0.5.1.cpython-311.pyc"
Refine := A_ScriptDir "\p_libs\Refine_v0.1.1.cpython-311.pyc"
Partition := A_ScriptDir "\p_libs\Partition_v0.1.1.cpython-311.pyc"
HRRP := A_ScriptDir "\p_libs\HRRP_v0.2.1.cpython-311.pyc"
MBDL := A_ScriptDir "\p_libs\MDBL_v0.1.0.cpython-311.pyc"
PFED := A_ScriptDir "\p_libs\plot_density_v0.6.0.cpython-311.pyc"
FSF := A_ScriptDir "\p_libs\FSF_v0.1.7.cpython-311.pyc"
FSF_FDS5 := A_ScriptDir "\p_libs\FSF_v0.1.7_FDS5.cpython-311.pyc"

;	Модули (конец)

Proceed_FDS5_DEVC_CSV := A_ScriptDir "\p_libs\Proceed_FDS5_DEVC_CSV.cpython-311.pyc"
Proceed_FDS5_HRR_CSV := A_ScriptDir "\p_libs\Proceed_FDS5_HRR_CSV.cpython-311.pyc"
HashLib := A_ScriptDir "\p_libs\HashLib.cpython-311.pyc"

;	Динамические библиотеки (конец)

/*
	Инициализация среды embed (конец)
*/

If FileExist(A_ScriptDir "\inis\FDSpath.ini")
{
	IniRead, FDSpath, %A_ScriptDir%\inis\FDSpath.ini, FDSpath, FDSpath
}
Else
{
	FDSpath := ""
}

If FileExist(A_ScriptDir "\inis\MPIpath.ini")
{
	IniRead, MPIpath, %A_ScriptDir%\inis\MPIpath.ini, MPIpath, MPIpath
}
Else
{
	MPIpath := ""
}

If FileExist(A_ScriptDir "\inis\filePath.ini")
{
	IniRead, filePath, %A_ScriptDir%\inis\filePath.ini, filePath, filePath
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
Gui, Add, Button, x102 y229 w80 h30 gHashLib, Обновить ZmejkaFDS
Gui, Add, Text, x265 y285 w160 h20 , Zmejka_v0.12.7_hotfix2
Gui, Tab, Параметры
Gui, Add, Checkbox, x22 y29 w150 h20 gChckAlwDTR vChckAlw, Добавить DT_RESTART
Gui, Add, Edit, x172 y29 w50 h20 vChckDTR Number, 100
Gui, Add, Text, x225 y29 w30 h20 , сек
Gui, Add, Button, x292 y29 w45 h25 gRunMDBL, MDBL
Gui, Add, Radio, x262 y119 w80 h40 gFDS5 vFDS5, Ускорить расчет
Gui, Add, Radio, x262 y69 w110 h40 gFDS6 vFDS6 Checked, Расчет по умолчанию
Gui, Add, Text, x22 y69 w120 h40 , Подготовить FDS к расчёту F (dэфф) для нахождения tпор
Gui, Add, Button, x152 y69 w100 h40 gRunInsertDEVC, Insert_DEVC
Gui, Add, Text, x22 y119 w120 h40 , Привести параметры моделирования пожара к требуемым
Gui, Add, Button, x152 y119 w100 h40 gRunSURF, SURF_FIX
Gui, Add, Text, x22 y169 w120 h40 , Разбить расчётную область
Gui, Add, Button, x152 y169 w100 h40 gRunPartitioner, Partition
Gui, Add, Text, x22 y219 w120 h40 , Уменьшить/увеличить размер ячейки
Gui, Add, Button, x152 y219 w100 h40 gRunRefiner, Refine/Coarsen
Gui, Add, Text, x265 y285 w160 h20 , Zmejka_v0.12.7_hotfix2
Gui, Tab, Построение графиков
Gui, Add, Text, x22 y69 w120 h40 , Построить график F (dэфф) для нахождения tпор
Gui, Add, Button, x152 y69 w100 h40 gRunPCTT, PCTT
Gui, Add, Text, x22 y119 w110 h40 , Построить график плотности людских потоков
Gui, Add, Button, x152 y119 w100 h40 gRunPFED, PFED
Gui, Add, Text, x22 y169 w120 h40 , Построить график мощности пожара (HRR)
Gui, Add, Button, x152 y169 w100 h40 gRunHRRP, HRRP
Gui, Add, Text, x265 y285 w160 h20 , Zmejka_v0.12.7_hotfix2

Gui, Show, h310 w395, ZmejkaFDS
Return

BrowseFileButton:
	Gui, Submit, NoHide
	GetSelectedFile(folderPath, fileName, filePath)
	IniWrite, %filePath%, %A_ScriptDir%\inis\filePath.ini, filePath, filePath
	GuiControl,, folderPath, % folderPath
	GuiControl,, fileName, % fileName
	IniRead, filePath, %A_ScriptDir%\inis\filePath.ini, filePath, filePath
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
	If (FDS6 = 1)
	{
		CheckCHID(filePath)
		sleep, 50
		CheckDUMP(filePath, ChckDTR)
		sleep, 50
		
		IniRead, filePath, %A_ScriptDir%\inis\filePath.ini, filePath, filePath
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
			If InStr(fileName, "_nfs")
			{
				filePath := A_ScriptDir "\" fileName "_nfs.fds"
				OutfilePath := A_ScriptDir "\" fileName ".out"
			}
			Else
			{
				filePath := A_ScriptDir "\" fileName ".fds"
				OutfilePath := A_ScriptDir "\" fileName ".out"
			}
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
			FileMove, %folderPath%\%fileName%_tout*.*, %A_ScriptDir%\, 1
			FileMove, %folderPath%\%fileName%_tout.fds, %A_ScriptDir%\, 1
			filePath := A_ScriptDir "\" fileName "_tout.fds"
			OutfilePath := A_ScriptDir "\" fileName "_tout.out"
		}
		else
		{
			FileMove, %folderPath%\%fileName%*.*, %A_ScriptDir%\, 1
			FileMove, %folderPath%\%fileName%.fds, %A_ScriptDir%\, 1
			filePath := A_ScriptDir "\" fileName ".fds"
			OutfilePath := A_ScriptDir "\" fileName ".out"
		}
		
		If (FileExist(A_ScriptDir "\inis\FDSpath.ini") && (FDSpath != "")) && (FileExist(A_ScriptDir "\inis\MPIpath.ini") && (MPIpath != ""))
		{
			MPI_PROCESS_NUM := Parse_FDS(filePath)
			ToolTip, % "Найдено потенциальных параллелей: " MPI_PROCESS_NUM
			Sleep, 1000
			ToolTip, "%MPIpath%" -n %MPI_PROCESS_NUM% "%FDSpath%" "%filePath%"
			Sleep, 1000
			ToolTip
			Run, "%MPIpath%" -n %MPI_PROCESS_NUM% "%FDSpath%" "%filePath%"
		}
		
		Else If (!FileExist(A_ScriptDir "\inis\FDSpath.ini") || (FDSpath = "")) && (FileExist(A_ScriptDir "\inis\MPIpath.ini") && (MPIpath != ""))
		{
			FDSpath := A_ProgramFiles "\firemodels\FDS6\bin\fds.exe"
			MPI_PROCESS_NUM := Parse_FDS(filePath)
			ToolTip, % "Найдено потенциальных параллелей: " MPI_PROCESS_NUM
			Sleep, 1000
			ToolTip, "%MPIpath%" -n %MPI_PROCESS_NUM% "%FDSpath%" "%filePath%"
			Sleep, 1000
			ToolTip
			Run, "%MPIpath%" -n %MPI_PROCESS_NUM% "%FDSpath%" "%filePath%"
		}
		
		Else If (FileExist(A_ScriptDir "\inis\FDSpath.ini") && (FDSpath != "")) && (!FileExist(A_ScriptDir "\inis\MPIpath.ini") && (MPIpath = ""))
		{
			IniRead, FDSpath, %A_ScriptDir%\inis\FDSpath.ini, FDSpath, FDSpath
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
				ToolTip, Путь к fds.exe не был указан. Использую последнюю версию FDS, установленную на данном компьютере
				Sleep, 1000
				ToolTip, mpiexec.exe будет опущен при запуске %fileName%.fds
				Sleep, 1000
				SetTimer, RemoveToolTip, -1000
				Run, fds "%filePath%"
			}
			Else
			{
				MsgBox, Пожалуйста, укажите путь fds.exe, для которого был создан файл %fileName%.fds
			}
		}
		
		Loop
		{
			Sleep, 1000
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
		
		;	Получаем список с результатами моделирования с префиксом %fileName%
		ResultsList := ""
		
		Loop, Files, %A_ScriptDir%\%fileName%*.*
		{
			ResultsList .= A_LoopFileFullPath "`n"
		}
		
		;	Перемещаем все файлы в родную папку %fileName%.fds
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
			ToolTip, % fileName " не найден"
			Sleep, 250
		}
	}
	
	If (FDS5 = 1)
	{
		ToolTip, % "FDS5 is " FDS5
		Sleep, 300
		
		CheckDUMP(filePath, ChckDTR)
		sleep, 50
		
		IniRead, filePath, %A_ScriptDir%\inis\filePath.ini, filePath, filePath
		
		folderPath := RegExReplace(filePath, "(.*\\).*", "$1")
		folderPath := SubStr(folderPath, 1, StrLen(folderPath) - 1)
        fileName := RegExReplace(filePath, ".+\\(.+)$", "$1")
		fileName := SubStr(fileName, 1, StrLen(fileName) - 4)
		
		if InStr(fileName, "_tout")
		{
			StringSplit, part, fileName, _
			if (part0 > 0)
			{
				part1 = %part1%
			}
			if (part0 > 1)
			{
				part2 = %part2%
			}
			if (part0 > 2)
			{
				part3 = %part3%
			}
			ToolTip, Part 1: %part1%`nPart 2: %part2%`nPart 3: %part3%
			Sleep, 500
			ToolTip
			OutfilePath := folderPath "\" part1 "_" part3 ".out"
			FileExistsRestart := FileExist(folderPath "\" part1 "_" part3 "*.restart")
			RestartToCheck := folderPath "\" part1 "_" part2 "_" part3 ".fds"
			ToolTip, % OutfilePath
			Sleep, 500
			ToolTip
			IniWrite, %OutfilePath%, %A_ScriptDir%\inis\OutfilePath.ini, OutfilePath, OutfilePath
		}
		else
		{
			StringSplit, part, fileName, _
			if (part0 > 0)
			{
				part1 = %part1%
			}
			if (part0 > 1)
			{
				part2 = %part2%
			}
			if (part0 > 2)
			{
				part3 = %part3%
			}
			ToolTip, Part 1: %part1%`nPart 2: %part2%`nPart 3: %part3%
			Sleep, 500
			ToolTip
			
			OutfilePath := folderPath "\" part1 ".out"
			FileExistsRestart := FileExist(folderPath "\" part1 "*.restart")
			RestartToCheck := folderPath "\" part1 "_" part2 ".fds"
			
			ToolTip, % OutfilePath
			Sleep, 500
			ToolTip
			
			IniWrite, %OutfilePath%, %A_ScriptDir%\inis\OutfilePath.ini, OutfilePath, OutfilePath
		}
		
		If (FileExistsRestart)
		{
			checkRTagFDS5 := CheckRestartTagFDS5(filePath)
			ToolTip, Restart file(s) found. Trying to resume FDS instance.
			Sleep, 1000
			SetTimer, RemoveToolTip, -1000
		}
		Else
		{
			ToolTip, Restart file not found!
			Sleep, 1000
			SetTimer, RemoveToolTip, -1000
			removeRTagFDS5 := removeRestartFromMiscLineFDS5(filePath)
			If (removeRTagFDS5)
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
		
		FileDelete, %folderPath%\%part1%*.stop
		
		If FileExist(A_ScriptDir "\FDS5\fds5.exe") && FileExist(A_ScriptDir "\FDS5\fds5_mpi_win_64.exe") && FileExist(A_ScriptDir "\FDS5\fds5_win_64.exe")
		{
			MPI_PROCESS_NUM := Parse_FDS(filePath)
			
			ToolTip, % "Найдено потенциальных параллелей: " MPI_PROCESS_NUM
			Sleep, 1000
			ToolTip, Ускорение моделирования пожара путём перемещения среды выполнения FDS6 в среду FDS5
			Sleep, 1000
			ToolTip
			
			if MPI_PROCESS_NUM < 2
			{
				SetWorkingDir, %folderPath%
				Run, "%FDS5EXEnoMPI%" "%filePath%", "%folderPath%", , PID
			}
			
			if MPI_PROCESS_NUM >= 2
			{
				SetWorkingDir, %folderPath%
				Run, "%FDS5EXE%" "%filePath%", "%folderPath%", , PID
			}
		}
		
		Loop
		{
			Sleep, 1000
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
		Until (TotalTime >= TEND) || OutFileExists || FileExist(StopFile)
		{
			Progress Off
		}
		
		Sleep, 1000
		Run, "%PyExe%" "%Proceed_FDS5_DEVC_CSV%"
		Sleep, 1000
		Run, "%PyExe%" "%Proceed_FDS5_HRR_CSV%"
	}
	Return

PauseButton:
	If (FDS6 = 1)
	{
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
			ToolTip, % fileName " не найден"
			Sleep, 250
		}
		
		ToolTip, files moved to %folderPath%
		Sleep, 1000
		SetTimer, RemoveToolTip, -1000
		IniRead, filePath, %A_ScriptDir%\inis\filePath.ini, filePath, filePath
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
	}
	
	If (FDS5 = 1)
	{
		ToolTip, % "FDS5 is " FDS5
		Sleep, 300
		
		IniRead, filePath, %A_ScriptDir%\inis\filePath.ini, filePath, filePath
		
		folderPath := RegExReplace(filePath, "(.*\\).*", "$1")
		folderPath := SubStr(folderPath, 1, StrLen(folderPath) - 1)
        fileName := RegExReplace(filePath, ".+\\(.+)$", "$1")
		fileName := SubStr(fileName, 1, StrLen(fileName) - 4)
		
		if InStr(fileName, "_nfs") && !InStr(fileName, "_tout")
		{
			StringSplit, part, fileName, _
			
			if (part0 > 0)
			{
				part1 = %part1%
			}
			if (part0 > 1)
			{
				part2 = %part2%
			}
			if (part0 > 2)
			{
				part3 = %part3%
			}
			
			ToolTip, Part 1: %part1%`nPart 2: %part2%`nPart 3: %part3%
			Sleep, 500
			ToolTip
			
			fileName := part1
			
			ToolTip, % fileName
			Sleep, 500
			ToolTip
			
			IfWinExist, ahk_pid %PID%
			{
				StopFile := folderPath "\" part1 ".stop"
				FileAppend, , %StopFile%
				
				ToolTip, stopping FDS...
				Sleep, 1000
				WinWaitClose
			}
		}
		
		else if InStr(fileName, "_nfs") && InStr(fileName, "_tout")
		{
			StringSplit, part, fileName, _
			
			if (part0 > 0)
			{
				part1 = %part1%
			}
			if (part0 > 1)
			{
				part2 = %part2%
			}
			if (part0 > 2)
			{
				part3 = %part3%
			}
			
			ToolTip, Part 1: %part1%`nPart 2: %part2%`nPart 3: %part3%
			Sleep, 500
			ToolTip
			
			fileName := part1
			
			ToolTip, % fileName
			Sleep, 500
			ToolTip
			
			IfWinExist, ahk_pid %PID%
			{
				StopFile := folderPath "\" part1 "_" part3 ".stop"
				FileAppend, , %StopFile%
				
				ToolTip, stopping FDS...
				Sleep, 1000
				WinWaitClose
			}
		}
		
		else
		{
			StringSplit, part, fileName, _
			
			if (part0 > 0)
			{
				part1 = %part1%
			}
			if (part0 > 1)
			{
				part2 = %part2%
			}
			if (part0 > 2)
			{
				part3 = %part3%
			}
			
			ToolTip, Part 1: %part1%`nPart 2: %part2%`nPart 3: %part3%
			Sleep, 500
			ToolTip
			
			fileName := part1
			
			ToolTip, % fileName
			Sleep, 500
			ToolTip
			
			IfWinExist, ahk_pid %PID%
			{
				StopFile := folderPath "\" part1 ".stop"
				FileAppend, , %StopFile%
				
				ToolTip, stopping FDS...
				Sleep, 1000
				WinWaitClose
			}
		}
		
		checkRTagFDS5 := CheckRestartTagFDS5(filePath)
		If (checkRTagFDS5 = 0)
		{
			ToolTip, Restart tag was not found in the &MISC line.
			Sleep, 1000
			AddRestartToMiscLineFDS5(filePath)
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
	}
	Return

StopButton:
	if (FDS6 = 1)
	{
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
		IniRead, filePath, %A_ScriptDir%\inis\filePath.ini, filePath, filePath
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
	}
	
	If (FDS5 = 1)
	{
		ToolTip, % "FDS5 is " FDS5
		Sleep, 300
		
		IniRead, filePath, %A_ScriptDir%\inis\filePath.ini, filePath, filePath
		
		folderPath := RegExReplace(filePath, "(.*\\).*", "$1")
		folderPath := SubStr(folderPath, 1, StrLen(folderPath) - 1)
        fileName := RegExReplace(filePath, ".+\\(.+)$", "$1")
		fileName := SubStr(fileName, 1, StrLen(fileName) - 4)
		
		if InStr(fileName, "_nfs") && !InStr(fileName, "_tout")
		{
			StringSplit, part, fileName, _
			
			if (part0 > 0)
			{
				part1 = %part1%
			}
			if (part0 > 1)
			{
				part2 = %part2%
			}
			if (part0 > 2)
			{
				part3 = %part3%
			}
			
			ToolTip, Part 1: %part1%`nPart 2: %part2%`nPart 3: %part3%
			Sleep, 500
			ToolTip
			
			fileName := part1
			
			ToolTip, % fileName
			Sleep, 500
			ToolTip
			
			IfWinExist, ahk_pid %PID%
			{
				StopFile := folderPath "\" part1 ".stop"
				FileAppend, , %StopFile%
				
				ToolTip, stopping FDS...
				Sleep, 1000
				WinWaitClose
			}
		}
		
		else if InStr(fileName, "_nfs") && InStr(fileName, "_tout")
		{
			StringSplit, part, fileName, _
			
			if (part0 > 0)
			{
				part1 = %part1%
			}
			if (part0 > 1)
			{
				part2 = %part2%
			}
			if (part0 > 2)
			{
				part3 = %part3%
			}
			
			ToolTip, Part 1: %part1%`nPart 2: %part2%`nPart 3: %part3%
			Sleep, 500
			ToolTip
			
			fileName := part1
			
			ToolTip, % fileName
			Sleep, 500
			ToolTip
			
			IfWinExist, ahk_pid %PID%
			{
				StopFile := folderPath "\" part1 "_" part3 ".stop"
				FileAppend, , %StopFile%
				
				ToolTip, stopping FDS...
				Sleep, 1000
				WinWaitClose
			}
		}
		
		else
		{
			StringSplit, part, fileName, _
			
			if (part0 > 0)
			{
				part1 = %part1%
			}
			if (part0 > 1)
			{
				part2 = %part2%
			}
			if (part0 > 2)
			{
				part3 = %part3%
			}
			
			ToolTip, Part 1: %part1%`nPart 2: %part2%`nPart 3: %part3%
			Sleep, 500
			ToolTip
			
			fileName := part1
			
			ToolTip, % fileName
			Sleep, 500
			ToolTip
			
			IfWinExist, ahk_pid %PID%
			{
				StopFile := folderPath "\" part1 ".stop"
				FileAppend, , %StopFile%
				
				ToolTip, stopping FDS...
				Sleep, 1000
				WinWaitClose
			}
		}
		
		checkRTagFDS5 := CheckRestartTagFDS5(filePath)
		If (checkRTagFDS5 = 0)
		{
			ToolTip, Restart tag was not found in the &MISC line.
			Sleep, 1000
			AddRestartToMiscLineFDS5(filePath)
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
	}
	Return

KillButton:
	if (FDS6 = 1)
	{
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
		IniRead, filePath, %A_ScriptDir%\inis\filePath.ini, filePath, filePath
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
	
	if (FDS5 = 1)
	{
		ToolTip, % "FDS5 is " FDS5
		Sleep, 300
		
		IniRead, filePath, %A_ScriptDir%\inis\filePath.ini, filePath, filePath
		
		folderPath := RegExReplace(filePath, "(.*\\).*", "$1")
		folderPath := SubStr(folderPath, 1, StrLen(folderPath) - 1)
        fileName := RegExReplace(filePath, ".+\\(.+)$", "$1")
		fileName := SubStr(fileName, 1, StrLen(fileName) - 4)

		If WinExist(ahk_pid %PID%)
		{
			WinKill, ahk_pid %PID%
		}
		Else
		{
			MsgBox, There is no active FDS or MPI job running
		}
		
		FileDelete, %folderPath%\%filename%.stop
		IniRead, filePath, %A_ScriptDir%\inis\filePath.ini, filePath, filePath
		removeRTagFDS5 := removeRestartFromMiscLineFDS5(filePath)
		If (removeRTagFDS5)
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
	Return

CheckFDS:
	GuiControlGet, checkFDS, , checkFDS
	CheckFDSInstallation()
	Return
	
HashLib:
	Run, "%PyExeConsole%" "%HashLib%"
	Return

BrowseFDSButton:
	GetSelectedExe(FDSpath)
	IniWrite, %FDSpath%, %A_ScriptDir%\inis\FDSpath.ini, FDSpath, FDSpath
	GuiControl, , FDSpath, % FDSpath
	If !(FileExist(A_ScriptDir "\inis\FDSpath.ini"))
	{
		IniWrite, %FDSpath%, %A_ScriptDir%\inis\FDSpath.ini, FDSpath, FDSpath
	}
	Else
	{
		IniRead, FDSpath, %A_ScriptDir%\inis\FDSpath.ini, FDSpath, FDSpath
	}
	Return

BrowseMPIButton:
	GetSelectedExe(MPIpath)
	GuiControl, , MPIpath, % MPIpath
	If !(FileExist(A_ScriptDir "\inis\MPIpath.ini"))
	{
		IniWrite, %MPIpath%, %A_ScriptDir%\inis\MPIpath.ini, MPIpath, MPIpath
	}
	Else
	{
		IniRead, MPIpath, %A_ScriptDir%\inis\MPIpath.ini, MPIpath, MPIpath
	}
	Return

RunInsertDEVC:
	Run, "%AHKU64EXE%" "%Insert_DEVC%"
	Return

RunPCTT:
	Run, "%PyExe%" "%PCTT%"
	Return

RunPFED:
	Run, "%PyExe%" "%PFED%"
	Return

RunSURF:
	if (FDS5 = 1)
		Run, "%PyExe%" "%FSF_FDS5%"
	if (FDS6 = 1)
		Run, "%PyExe%" "%FSF%"
	Return

RunHRRP:
	Run, "%PyExe%" "%HRRP%"
	Return
	
RunPartitioner:
	Run, "%PyExe%" "%Partition%"
	Return

RunRefiner:
	Run, "%PyExe%" "%Refine%"
	Return
	
RunMDBL:
	Run, "%PyExe%" "%MBDL%"
	Return
	
/*

Поддержка ускорения расчета с помощью FDS5

*/

FDS5:
	FDS6 := 0
	FDS5 := 1
	
	FDSpath := ""
	GuiControl, , FDSpath
	MPIpath := ""
	GuiControl, , MPIpath
	
	If (FileExist(A_ScriptDir "\inis\filePath.ini")) && (filePath != "")
	{
		IniRead, filePath, %A_ScriptDir%\inis\filePath.ini, filePath, filePath
		
		folderPath := RegExReplace(filePath, "(.*\\).*", "$1")
		folderPath := SubStr(folderPath, 1, StrLen(folderPath) - 1)
        fileName := RegExReplace(filePath, ".+\\(.+)$", "$1")
		fileName := SubStr(fileName, 1, StrLen(fileName) - 4)
		
		;MsgBox, % fileName
		
		If (FDS5 = 1)
		{
			;MsgBox, % FDS5 " is checked"
			If !InStr(fileName, "_nfs")
			{
				;MsgBox, % fileName " does contain _nfs.fds"
				nfsfile := folderPath . "\" . fileName . "_nfs.fds"
				
				FileCopy, %filePath%, %nfsfile%
				
				;fileName := fileName "_nfs"
				filePath := nfsfile
				
				ToolTip, % "Создан " filePath
				Sleep, 400
				ToolTip
				
				Process_REAC_Line_to_FDS5(filePath)
				ToolTip, Подготовка реакции &REAC
				Sleep, 400
				ToolTip
				
				Process_MISC_Line_to_FDS5(filePath)
				ToolTip, Подготовка строки &MISC
				Sleep, 400
				ToolTip
				
				Remove_HCL_Lines(filePath)
				ToolTip, Подготовка слайсов &SLCF и измерителей &DEVC
				Sleep, 400
				ToolTip
				
				Remove_SPEC_COMB_WIND_Lines(filePath)
				ToolTip, Очистка входного сценария от лишних &SPEC, &COMB, &WIND
				Sleep, 400
				ToolTip
				
				ToolTip, % "Сценарий " fileName ".fds готов к запуску"
				Sleep, 800
				ToolTip
			}
			Else
			{
				ToolTip, % "Уже есть " fileName ".fds"
				Sleep, 800
				ToolTip
			}
		}
		Else
		{
			MsgBox, % FDS5 " is not checked"
		}
	}
	Else
	{
		MsgBox, 4160, Ошибка, Укажите путь к файлу сценария .fds
	}	
	Return
	
FDS6:
	FDS6 := 1
	FDS5 := 0
	
	If (FDS6 = 1)
	{
		ToolTip, Ускоритель отключен
		Sleep, 350
		ToolTip
	}
	Return

/*

Поддержка ускорения расчета с помощью FDS5

*/

RemoveToolTip:
	ToolTip
	Return

GuiClose:
	ExitApp
	Return

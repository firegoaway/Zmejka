/*
	ZmejkaFDS разработана экслюзивно для сообщества FIREGOAWAY
*/

#SingleInstance Off
#Persistent
#NoEnv
SetTitleMatchMode, 2

/*
	AHK Functions
*/

#Include %A_ScriptDir%\a_libs\GetSelectedFile.ahk
#Include %A_ScriptDir%\a_libs\GetSelectedExe.ahk
#Include %A_ScriptDir%\a_libs\CheckFDSInstallation.ahk
#Include %A_ScriptDir%\a_libs\Parse_FDS.ahk
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
#Include %A_ScriptDir%\a_libs\WatchFolderForOutFiles.ahk
#Include %A_ScriptDir%\a_libs\ShowToolTip.ahk

/*
	Инициализация среды embed (начало)
*/

AHKU64EXE := A_ScriptDir "\a_embed\AutoHotkeyU64.exe"
PyExe := A_ScriptDir "\p_embed\pythonw.exe"
PyExeConsole := A_ScriptDir "\p_embed\python.exe"
FDS5EXE := A_ScriptDir "\FDS5\fds5_mpi_win_64.exe"
FDS5EXEnoMPI := A_ScriptDir "\FDS5\fds5.exe"
FDS5MPIEXE := A_ScriptDir "\FDS5\mpiexec.exe"
SMPDEXE := A_ScriptDir "\FDS5\smpd.exe"
HYDRAEXE := A_ScriptDir "\FDS5\hydra_service.exe"
install_services_run := A_ScriptDir "\FDS5\install_services_run.bat"

;	Динамические библиотеки (начало)

; 	Модули (начало)

Insert_DEVC := A_ScriptDir "\a_libs\Insert_DEVC_v0.4.2.ahk"
PCTT := A_ScriptDir "\p_libs\Plot_CSV_Time_Threshhold_v0.6.1.cpython-311.pyc"
Refine := A_ScriptDir "\p_libs\Refine_v0.1.2.cpython-311.pyc"
Partition := A_ScriptDir "\p_libs\Partition_v0.1.2.cpython-311.pyc"
HRRP := A_ScriptDir "\p_libs\HRRP_v0.3.0.cpython-311.pyc"
MBDL := A_ScriptDir "\p_libs\MDBL_v0.1.0.cpython-311.pyc"
PFED := A_ScriptDir "\p_libs\plot_density_v0.6.2.cpython-311.pyc"
FSF := A_ScriptDir "\p_libs\FSF_v0.1.9.cpython-311.pyc"
FSF_FDS5 := A_ScriptDir "\p_libs\FSF_v0.1.9_FDS5.cpython-311.pyc"

;	Модули (конец)

Proceed_FDS5_DEVC_CSV := A_ScriptDir "\p_libs\Proceed_FDS5_DEVC_CSV.cpython-311.pyc"
Proceed_FDS5_HRR_CSV := A_ScriptDir "\p_libs\Proceed_FDS5_HRR_CSV.cpython-311.pyc"
HashLib_AutoUpdate_ZmejkaFDS := A_ScriptDir "\p_libs\HashLib_AutoUpdate_ZmejkaFDS.cpython-311.pyc"
HashLib_AutoUpdate_Libs := A_ScriptDir "\p_libs\HashLib_AutoUpdate_Libs.cpython-311.pyc"
Delete_FDS5_DEVC_CLOCK := A_ScriptDir "\p_libs\Delete_FDS5_DEVC_CLOCK.cpython-311.pyc"

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
	IniRead, folderPath, %A_ScriptDir%\inis\filePath.ini, folderPath, folderPath
	IniRead, fileName, %A_ScriptDir%\inis\filePath.ini, fileName, fileName
	GuiControl, , folderPath
	GuiControl, , fileName
}
Else
{
	filePath := ""
	folderPath := "Укажите путь к папке с файлом сценария (.fds)"
	fileName := "Укажите имя файла сценария (.fds)"
}

ChckDTR := 100
FDS6 := 1
FDS5 := 0
ProgressPercentage := 0

Gui, Add, Tab3, x2 y-1 w390 h310 +BackgroundTrans, Главный экран|Параметры|Построение графиков|Дополнительно|
Gui, Tab, Главный экран
Gui, Add, Edit, x12 y39 vFolderPath w240 h20, % folderPath
Gui, Add, Edit, x12 y69 vFileName w240 h20, % fileName
Gui, Add, Button, x262 y49 gBrowseFileButton w100 h30, Выбрать .fds
Gui, Add, Button, x12 y109 w80 h30 gStartButton, Старт
Gui, Add, Button, x102 y109 w80 h30 gPauseButton, Пауза
Gui, Add, Button, x192 y109 w80 h30 gStopButton, Стоп
Gui, Add, Button, x282 y109 w80 h30 gKillButton, Прервать
Gui, Add, Button, x12 y149 w80 h30 gBrowseFDSButton, Найти fds.exe
Gui, Add, Edit, x102 y149 w260 h30 vFDSpath, %FDSpath%
Gui, Add, Button, x12 y189 w80 h30 gBrowseMPIButton, Найти mpi.exe
Gui, Add, Edit, x102 y189 w260 h30 vMPIpath, %MPIpath%
Gui, Add, Progress, x13 y229 w350 h30 vProgressPercentage c0077BB, %ProgressPercentage%
Gui, Add, Text, x295 y285 w160 h20 , Zmejka_v0.12.12
Gui, Tab, Параметры
Gui, Add, Text, x22 y29 w160 h40 , Добавить поверхностные измерители
Gui, Add, Button, x172 y34 w80 h30 gRunMDBL, MDBL
Gui, Add, Text, x22 y79 w120 h40 , Подготовить FDS к расчёту F (dэфф) для нахождения tпор
Gui, Add, Button, x172 y79 w100 h40 gRunInsertDEVC, Insert_DEVC
Gui, Add, Text, x22 y129 w120 h40 , Привести параметры моделирования пожара к требуемым
Gui, Add, Button, x172 y129 w100 h40 gRunSURF, SURF_FIX
Gui, Add, Text, x22 y179 w120 h40 , Разбить расчётную область
Gui, Add, Button, x172 y179 w100 h40 gRunPartitioner, Partition
Gui, Add, Text, x22 y229 w120 h40 , Уменьшить/увеличить размер ячейки
Gui, Add, Button, x172 y229 w100 h40 gRunRefiner, Refine/Coarsen
Gui, Add, Text, x295 y285 w160 h20 , Zmejka_v0.12.12
Gui, Tab, Построение графиков
Gui, Add, Text, x22 y69 w120 h40 , Построить график F (dэфф) для нахождения tпор
Gui, Add, Button, x152 y69 w100 h40 gRunPCTT, PCTT
Gui, Add, Text, x22 y119 w110 h40 , Построить график плотности людских потоков
Gui, Add, Button, x152 y119 w100 h40 gRunPFED, PFED
Gui, Add, Text, x22 y169 w120 h40 , Построить график мощности пожара (HRR)
Gui, Add, Button, x152 y169 w100 h40 gRunHRRP, HRRP
Gui, Add, Text, x295 y285 w160 h20 , Zmejka_v0.12.12
Gui, Tab, Дополнительно
Gui, Add, Checkbox, x22 y29 w270 h20 gChckAlwDTR vChckAlw, Сохранять результаты моделирования каждые ;бывш. Добавить DT_RESTART
Gui, Add, Edit, x292 y29 w50 h20 vChckDTR Number, %ChckDTR%
Gui, Add, Text, x345 y29 w30 h20 , сек
Gui, Add, Radio, x22 y59 w280 h30 gFDS5 vFDS5, Ускорить моделирование пожара 
Gui, Add, Radio, x22 y89 w280 h30 gFDS6 vFDS6 Checked, Моделирование пожара по умолчанию
Gui, Add, Button, x12 y269 w80 h30 gCheckFDS, Проверить наличие FDS
Gui, Add, Button, x102 y269 w80 h30 gAutoUpdateZ, Обновить ZmejkaFDS
Gui, Add, Button, x12 y229 w170 h30 gEmpit, Стравить службы MPI
Gui, Add, Text, x295 y285 w160 h20 , Zmejka_v0.12.12

Gui, Show, h310 w395, ZmejkaFDS

Return

BrowseFileButton:
	Gui, Submit, NoHide
	GetSelectedFile(folderPath, fileName, filePath)
	IniWrite, %filePath%, %A_ScriptDir%\inis\filePath.ini, filePath, filePath
	IniWrite, %folderPath%, %A_ScriptDir%\inis\filePath.ini, folderPath, folderPath
	IniWrite, %fileName%, %A_ScriptDir%\inis\filePath.ini, fileName, fileName
	GuiControl,, folderPath, %folderPath%
	GuiControl,, fileName, %fileName%
	
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
	GuiControlGet, folderPath, , folderPath
	GuiControlGet, fileName, , fileName
	GuiControlGet, FDSpath, , FDSpath
	GuiControlGet, MPIpath, , MPIpath
	
	IniWrite, %folderPath%, %A_ScriptDir%\inis\filePath.ini, folderPath, folderPath
	IniWrite, %fileName%, %A_ScriptDir%\inis\filePath.ini, fileName, fileName

	If !FileExist(filePath)
	{
		MsgBox, Файл: %filePath% `nв папке: %A_ScriptDir% `n`nне найден
	}
	
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
	
	StopFiles := []
	StopFiles.Push(folderPath "\" part1 ".stop")
	StopFiles.Push(folderPath "\" part1 "_" part2 ".stop")
	StopFiles.Push(folderPath "\" part1 "_" part3 ".stop")
	StopFiles.Push(folderPath "\" part1 "_" part2 "_" part3 ".stop")
	StopFiles.Push(folderPath "\" part1 "_" part3 "_" part2 ".stop")

	for index, StopFile in StopFiles
	{
		FileDelete, %StopFile%
	}
	
	/*
		FDS6
	*/

	If (FDS6 = 1)
	{
		CheckCHID(filePath)
		sleep, 50
		CheckDUMP(filePath, ChckDTR)
		sleep, 50
		
		IniRead, filePath, %A_ScriptDir%\inis\filePath.ini, filePath, filePath
		
		fileList := CheckRestartFile(filePath)
		checkRTag := CheckRestartTag(filePath)
		If InStr(fileList, ".restart") && checkRTag
		{
			ToolTip, OK
			sleep 1000
			ToolTip
		}
		Else If !InStr(fileList, ".restart") && checkRTag
		{
			RemoveRestartFromMiscLine(filePath)
			ToolTip, Restart tag removed
			sleep 1000
			ToolTip
		}
		Else If InStr(fileList, ".restart") && !checkRTag
		{
			AddRestartToMiscLine(filePath)
			ToolTip, Restart tag added
			sleep 1000
			ToolTip
		}
		Else
		{
			ToolTip no bashes
		}
		
		If (FileExist(A_ScriptDir "\inis\FDSpath.ini") && (FDSpath != "")) && (FileExist(A_ScriptDir "\inis\MPIpath.ini") && (MPIpath != ""))
		{
			MPI_PROCESS_NUM := Parse_FDS(filePath)
			
			ToolTip, % "Найдено потенциальных параллелей: " MPI_PROCESS_NUM
			Sleep, 1000
			ToolTip
			
			ToolTip, "%MPIpath%" -n %MPI_PROCESS_NUM% "%FDSpath%" "%filePath%"
			Sleep, 1000
			ToolTip
			
			RunCmd := "powershell -command " . Chr(34) . "& { Set-Location -Path " . Chr(39) . folderPath . Chr(39) . " " . Chr(59) . " & " . Chr(39) . MPIpath . Chr(39) . " -n " . MPI_PROCESS_NUM . " " . Chr(39) . FDSpath . Chr(39) . " " . Chr(39) . filePath . Chr(39) . " > " . Chr(39) . "output_log.txt" . Chr(39) . " }" . Chr(34)

			Run, %RunCmd%,,, PID
			WinWait, ahk_exe powershell.exe
			WinGet, ID, ID, ahk_exe powershell.exe
		}
		
		Else If (!FileExist(A_ScriptDir "\inis\FDSpath.ini") || (FDSpath = "")) && (FileExist(A_ScriptDir "\inis\MPIpath.ini") && (MPIpath != ""))
		{
			FDSpath := A_ProgramFiles "\firemodels\FDS6\bin\fds.exe"
			MPI_PROCESS_NUM := Parse_FDS(filePath)
			
			ToolTip, % "Найдено потенциальных параллелей: " MPI_PROCESS_NUM
			Sleep, 1000
			ToolTip
			
			ToolTip, "%MPIpath%" -n %MPI_PROCESS_NUM% "%FDSpath%" "%filePath%"
			Sleep, 1000
			ToolTip
			
			RunCmd := "powershell -command " . Chr(34) . "& { Set-Location -Path " . Chr(39) . folderPath . Chr(39) . " " . Chr(59) . " & " . Chr(39) . MPIpath . Chr(39) . " -n " . MPI_PROCESS_NUM . " " . Chr(39) . FDSpath . Chr(39) . " " . Chr(39) . filePath . Chr(39) . " > " . Chr(39) . "output_log.txt" . Chr(39) . " }" . Chr(34)

			Run, %RunCmd%,,, PID
			WinWait, ahk_exe powershell.exe
			WinGet, ID, ID, ahk_exe powershell.exe
		}
		
		Else If (FileExist(A_ScriptDir "\inis\FDSpath.ini") && (FDSpath != "")) && (!FileExist(A_ScriptDir "\inis\MPIpath.ini") && (MPIpath = ""))
		{
			IniRead, FDSpath, %A_ScriptDir%\inis\FDSpath.ini, FDSpath, FDSpath
			
			ToolTip, FDSpath.ini exists and "%FDSpath%" is not empty
			Sleep, 1000
			ToolTip
			
			ToolTip, mpiexec.exe will be omitted upon running %fileName%.fds
			Sleep, 1000
			ToolTip
			
			RunCmd := "powershell -command " . Chr(34) . "& { Set-Location -Path " . Chr(39) . folderPath . Chr(39) . " " . Chr(59) . " & " . Chr(39) . FDSpath . Chr(39) . " " . Chr(39) . filePath . Chr(39) . " > " . Chr(39) . "output_log.txt" . Chr(39) . " }" . Chr(34)

			Run, %RunCmd%,,, PID
			WinWait, ahk_exe powershell.exe
			WinGet, ID, ID, ahk_exe powershell.exe
		}
		
		Else
		{
			CheckFDSExe := FileExist(A_ProgramFiles "\firemodels\FDS6\bin\fds.exe")
			
			If (CheckFDSExe = "A") 
			{
				FDSpath := A_ProgramFiles "\firemodels\FDS6\bin\fds.exe"
				
				ToolTip, Путь к fds.exe не был указан. Использую последнюю версию FDS, установленную на данном компьютере
				Sleep, 1000
				ToolTip
				
				ToolTip, mpiexec.exe будет опущен при запуске %fileName%.fds
				Sleep, 1000
				ToolTip
				
				RunCmd := "powershell -command " . Chr(34) . "& { Set-Location -Path " . Chr(39) . folderPath . Chr(39) . " " . Chr(59) . " & " . Chr(39) . FDSpath . Chr(39) . " " . Chr(39) . filePath . Chr(39) . " > " . Chr(39) . "output_log.txt" . Chr(39) . " }" . Chr(34)

				Run, %RunCmd%,,, PID
				WinWait, ahk_exe powershell.exe
				WinGet, ID, ID, ahk_exe powershell.exe
			}
			Else
			{
				MsgBox, Пожалуйста, укажите путь fds.exe, для которого был создан файл %fileName%.fds
			}
		}
		
		OutfilePath := ""
		OutfilePattern := folderpath "\" part1 "*.out"
		
		ToolTip % OutfilePattern
		sleep 500
		ToolTip
		
		Loop
		{
			Loop, Files, %OutfilePattern%, F
			{
				OutfilePath := A_LoopFileFullPath
				if OutfilePath
				{
					sleep 1000
					LastTotalTime := ExtractLastTotalTime(OutfilePath)
					sleep 1000
					ToolTip % OutfilePath
					sleep 1000
					ToolTip
				}
				Else
				{
					Continue
				}
				if !OutfilePath
				{
					ToolTip No output files found!
					sleep 1000
					ToolTip
					return
				}
			}
			if !FileExist(OutfilePath)
			{
				ToolTip Ждём %OutfilePath%
				sleep 1000
				ToolTip
			}
			Else
			{
				Break
			}
		}
		
		Loop
		{
			If FileExist(OutfilePath) && !FileExist(StopFile)
			{
				TEND := SearchForTEND(filePath)
				TotalTime := Ceil(ExtractLastTotalTime(OutfilePath))
				ProgressPercentage := Ceil((TotalTime / TEND) * 100)
				GuiControl,, ProgressPercentage, %ProgressPercentage%
				Sleep, 250
				Continue
			}
			Else
			{
				Continue
			}
		} Until (TotalTime >= TEND) || !FileExist(OutfilePath) || FileExist(StopFile) || !WinExist("ahk_id " . ID)
		
		ProgressPercentage := 100
		GuiControl,, ProgressPercentage, %ProgressPercentage%
		Sleep, 200
		ProgressPercentage := 0
		GuiControl,, ProgressPercentage, %ProgressPercentage%
		
		ToolTip, Моделирование завершено!
		Sleep, 1000
		ToolTip
	}
	
	/*
		FDS5
	*/
	
	If (FDS5 = 1)
	{
		ToolTip, % "FDS5 is " FDS5
		Sleep, 300
		ToolTip
		
		CheckDUMP(filePath, ChckDTR)
		sleep, 50
		
		fileList := CheckRestartFile(filePath)
		checkRTagFDS5 := CheckRestartTagFDS5(filePath)
		If InStr(fileList, ".restart") && checkRTagFDS5
		{
			ToolTip, OK
			sleep 1000
			ToolTip
		}
		Else If !InStr(fileList, ".restart") && checkRTagFDS5
		{
			RemoveRestartFromMiscLineFDS5(filePath)
			ToolTip, Restart tag removed
			sleep 1000
			ToolTip
		}
		Else If InStr(fileList, ".restart") && !checkRTagFDS5
		{
			AddRestartToMiscLineFDS5(filePath)
			ToolTip, Restart tag added
			sleep 1000
			ToolTip
		}
		Else
		{
			ToolTip no bashes
		}
		
		If FileExist(A_ScriptDir "\FDS5\fds5_mpi_win_64.exe") && FileExist(A_ScriptDir "\FDS5\mpiexec.exe")
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
				
				RunCmd := "powershell -command " . Chr(34) . "& { Set-Location -Path " . Chr(39) . folderPath . Chr(39) . " " . Chr(59) . " & " . Chr(39) . FDS5EXEnoMPI . Chr(39) . " " . Chr(39) . filePath . Chr(39) . " > " . Chr(39) . "output_log.txt" . Chr(39) . " }" . Chr(34)
			
				;MsgBox, % RunCmd

				Run, %RunCmd%,,, PID
				WinWait, ahk_exe powershell.exe
				WinGet, ID, ID, ahk_exe powershell.exe
			}
			
			if MPI_PROCESS_NUM >= 2
			{
				SetWorkingDir, %folderPath%
				
				RunCmd := "powershell -command " . Chr(34) . "& { Set-Location -Path " . Chr(39) . folderPath . Chr(39) . " " . Chr(59) . " & " . Chr(39) . FDS5MPIEXE . Chr(39) . " -n " . MPI_PROCESS_NUM . " -localonly " . Chr(39) . FDS5EXE . Chr(39) . " " . Chr(39) . filePath . Chr(39) . " > " . Chr(39) . "output_log.txt" . Chr(39) . " }" . Chr(34)

				Run, %RunCmd%,,, PID
				WinWait, ahk_exe powershell.exe
				WinGet, ID, ID, ahk_exe powershell.exe
			}
		}
		
		OutfilePath := ""
		OutfilePattern := folderpath "\" part1 "*.out"
		
		ToolTip % OutfilePattern
		sleep 500
		ToolTip
		
		Loop
		{
			Loop, Files, %OutfilePattern%, F
			{
				OutfilePath := A_LoopFileFullPath
				if OutfilePath
				{
					sleep 1000
					LastTotalTime := ExtractLastTotalTime(OutfilePath)
					sleep 1000
					ToolTip % OutfilePath
					sleep 1000
					ToolTip
				}
				Else
				{
					Continue
				}
				if !OutfilePath
				{
					ToolTip No output files found!
					sleep 1000
					ToolTip
					
					return
				}
			}
			if !FileExist(OutfilePath)
			{
				ToolTip Ждём %OutfilePath%
				sleep 1000
				ToolTip
			}
			Else
			{
				Break
			}
		}
		
		Loop
		{
			If FileExist(OutfilePath) && !FileExist(StopFile)
			{
				TEND := SearchForTEND(filePath)
				TotalTime := Ceil(ExtractLastTotalTime(OutfilePath))
				ProgressPercentage := Ceil((TotalTime / TEND) * 100)
				GuiControl,, ProgressPercentage, %ProgressPercentage%
				Sleep, 250
				Continue
			}
			Else
			{
				Continue
			}
		} Until (TotalTime >= TEND) || !FileExist(OutfilePath) || FileExist(StopFile) || !WinExist("ahk_id " . ID)
		
		ProgressPercentage := 100
		GuiControl,, ProgressPercentage, %ProgressPercentage%
		Sleep, 200
		ProgressPercentage := 0
		GuiControl,, ProgressPercentage, %ProgressPercentage%
		
		ToolTip, Моделирование завершено!
		Sleep, 1000
		ToolTip
		
		;Sleep, 1000
		;RunWait, "%PyExeConsole%" "%Delete_FDS5_DEVC_CLOCK%"
		Sleep, 1000
		Run, "%PyExeConsole%" "%Proceed_FDS5_DEVC_CSV%"
		Sleep, 1000
		Run, "%PyExeConsole%" "%Proceed_FDS5_HRR_CSV%"
	}
	Return

PauseButton:
	If (FDS6 = 1)
	{
		GuiControlGet, folderPath, , folderPath
		GuiControlGet, fileName, , fileName
		
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
		
		If WinExist("ahk_id " . ID)
		{
			StopFiles := []
			StopFiles.Push(folderPath "\" part1 ".stop")
			StopFiles.Push(folderPath "\" part1 "_" part2 ".stop")
			StopFiles.Push(folderPath "\" part1 "_" part2 "_" part3 ".stop")
			StopFiles.Push(folderPath "\" part1 "_" part3 "_" part2 ".stop")

			for index, StopFile in StopFiles
			{
				FileAppend, , %StopFile%
			}
			
			ToolTip, stopping FDS
			Sleep, 1000
			
			WinWaitClose
		}
		
		IniRead, filePath, %A_ScriptDir%\inis\filePath.ini, filePath, filePath
		checkRTag := CheckRestartTag(filePath)
		
		If (checkRTag = 0)
		{
			ToolTip, Restart tag was not found in the &MISC line.
			Sleep, 1000
			ToolTip
			
			AddRestartToMiscLine(filePath)
			
			ToolTip, Restart tag is now added to the &MISC line.
			Sleep, 1000
			ToolTip
		}
		Else
		{
			ToolTip, Restart tag is in the &MISC line.
			Sleep, 1000
			ToolTip
		}
		; MsgBox, 4096, DEBUG, checkRTag is %checkRTag%
	}
	
	If (FDS5 = 1)
	{
		ToolTip, % "FDS5 is " FDS5
		Sleep, 300
		ToolTip
		
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
			
			If WinExist("ahk_id " . ID)
			{
				StopFiles := []
				StopFiles.Push(folderPath "\" part1 ".stop")
				StopFiles.Push(folderPath "\" part1 "_" part2 ".stop")

				for index, StopFile in StopFiles
				{
					FileAppend, , %StopFile%
				}
				
				ToolTip, stopping FDS...
				Sleep, 1000
				ToolTip
				
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
			
			If WinExist("ahk_id " . ID)
			{
				StopFiles := []
				StopFiles.Push(folderPath "\" part1 "_" part2 "_" part3 ".stop")
				StopFiles.Push(folderPath "\" part1 "_" part3 "_" part2 ".stop")
				StopFiles.Push(folderPath "\" part1 "_" part2 ".stop")
				StopFiles.Push(folderPath "\" part1 "_" part3 ".stop")
				StopFiles.Push(folderPath "\" part1 ".stop")

				for index, StopFile in StopFiles
				{
					FileAppend, , %StopFile%
				}
				
				ToolTip, stopping FDS...
				Sleep, 1000
				ToolTip
				
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
			
			If WinExist("ahk_id " . ID)
			{
				StopFiles := []
				StopFiles.Push(folderPath "\" part1 ".stop")

				for index, StopFile in StopFiles
				{
					FileAppend, , %StopFile%
				}
				
				ToolTip, stopping FDS...
				Sleep, 1000
				ToolTip
				
				WinWaitClose
			}
		}
		
		checkRTagFDS5 := CheckRestartTagFDS5(filePath)
		
		If (checkRTagFDS5 = 0)
		{
			ToolTip, Restart tag was not found in the &MISC line.
			Sleep, 1000
			ToolTip
			
			AddRestartToMiscLineFDS5(filePath)
			
			ToolTip, Restart tag is now added to the &MISC line.
			Sleep, 1000
			ToolTip
		}
		Else
		{
			ToolTip, Restart tag is in the &MISC line.
			Sleep, 1000
			ToolTip
		}
		; MsgBox, 4096, DEBUG, checkRTag is %checkRTag%
	}
	
	Return

StopButton:
	if (FDS6 = 1)
	{
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
			
			If WinExist("ahk_id " . ID)
			{
				StopFiles := []
				StopFiles.Push(folderPath "\" part1 ".stop")
				StopFiles.Push(folderPath "\" part1 "_" part3 ".stop")

				for index, StopFile in StopFiles
				{
					FileAppend, , %StopFile%
				}
				
				ToolTip, stopping FDS...
				Sleep, 1000
				ToolTip
				
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
			
			If WinExist("ahk_id " . ID)
			{
				StopFiles := []
				StopFiles.Push(folderPath "\" part1 ".stop")
				StopFiles.Push(folderPath "\" part1 "_" part3 ".stop")

				for index, StopFile in StopFiles
				{
					FileAppend, , %StopFile%
				}
				
				ToolTip, stopping FDS...
				Sleep, 1000
				ToolTip
				
				WinWaitClose
			}
		}
		
		else if !InStr(fileName, "_nfs") && InStr(fileName, "_tout")
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
			
			If WinExist("ahk_id " . ID)
			{
				StopFiles := []
				StopFiles.Push(folderPath "\" part1 ".stop")
				StopFiles.Push(folderPath "\" part1 "_" part2 ".stop")
				StopFiles.Push(folderPath "\" part1 "_" part3 ".stop")

				for index, StopFile in StopFiles
				{
					FileAppend, , %StopFile%
				}
				
				ToolTip, stopping FDS...
				Sleep, 1000
				ToolTip
				
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
			
			If WinExist("ahk_id " . ID)
			{
				StopFiles := []
				StopFiles.Push(folderPath "\" part1 ".stop")

				for index, StopFile in StopFiles
				{
					FileAppend, , %StopFile%
				}
				
				ToolTip, stopping FDS...
				Sleep, 1000
				WinWaitClose
			}
		}
		
		ToolTip, fds.exe is closed
		Sleep, 1000
		ToolTip
		
		/*
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
		ToolTip
		*/
		
		IniRead, filePath, %A_ScriptDir%\inis\filePath.ini, filePath, filePath
		
		checkRTag := CheckRestartTag(filePath)
		
		If (checkRTag = 1)
		{
			removeRTag := RemoveRestartFromMiscLine(filePath)
			ToolTip, Restart tag is removed from the &MISC line.
			Sleep, 1000
			ToolTip
		}
		Else
		{
			ToolTip, Restart tag is not in the &MISC line.
			Sleep, 1000
			ToolTip
		}
	}
	
	If (FDS5 = 1)
	{
		ToolTip, % "FDS5 is " FDS5
		Sleep, 300
		ToolTip
		
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
			
			If WinExist("ahk_id " . ID)
			{
				StopFiles := []
				StopFiles.Push(folderPath "\" part1 ".stop")
				StopFiles.Push(folderPath "\" part1 "_" part2 ".stop")

				for index, StopFile in StopFiles
				{
					FileAppend, , %StopFile%
				}
				
				ToolTip, stopping FDS...
				Sleep, 1000
				ToolTip
				
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
			
			If WinExist("ahk_id " . ID)
			{
				StopFiles := []
				StopFiles.Push(folderPath "\" part1 ".stop")
				StopFiles.Push(folderPath "\" part1 "_" part2 ".stop")
				StopFiles.Push(folderPath "\" part1 "_" part2 "_" part3 ".stop")
				StopFiles.Push(folderPath "\" part1 "_" part3 "_" part2 ".stop")
				StopFiles.Push(folderPath "\" part1 "_" part3 ".stop")

				for index, StopFile in StopFiles
				{
					FileAppend, , %StopFile%
				}
				
				ToolTip, stopping FDS...
				Sleep, 1000
				ToolTip
				
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
			
			If WinExist("ahk_id " . ID)
			{
				StopFiles := []
				StopFiles.Push(folderPath "\" part1 ".stop")
				StopFiles.Push(folderPath "\" part1 "_" part2 ".stop")
				StopFiles.Push(folderPath "\" part1 "_" part2 "_" part3 ".stop")
				StopFiles.Push(folderPath "\" part1 "_" part3 "_" part2 ".stop")

				for index, StopFile in StopFiles
				{
					FileAppend, , %StopFile%
				}
				
				ToolTip, stopping FDS...
				Sleep, 1000
				WinWaitClose
			}
		}
		
		checkRTagFDS5 := CheckRestartTagFDS5(filePath)
		If (checkRTagFDS5 = 1)
		{
			ToolTip, Restart tag found in the &MISC line.
			Sleep, 1000
			
			RemoveRestartFromMiscLineFDS5(filePath)
			
			ToolTip, Restart tag is removed &MISC line.
			Sleep, 1000
			
			ToolTip
		}
		Else
		{
			ToolTip, Restart tag not found in the &MISC line.
			Sleep, 1000
			ToolTip
		}
		; MsgBox, 4096, DEBUG, checkRTag is %checkRTag%
	}
	
	Return

KillButton:
	if (FDS6 = 1)
	{
		GuiControlGet, folderPath, , folderPath
		GuiControlGet, fileName, , fileName
		
		; Close CMD with FDS or MPI job instance
		If WinExist("ahk_id " . ID)
		{
			;MsgBox, WinExist %ID%
			WinKill, ahk_id %ID%
		}
		Else
		{
			MsgBox, There is no active FDS or MPI job running
		}
		
		/*
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
			ToolTip
		}
		*/
		
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
		
		If WinExist("ahk_id " . ID)
		{
			StopFiles := []
			StopFiles.Push(folderPath "\" part1 ".stop")
			StopFiles.Push(folderPath "\" part1 "_" part2 ".stop")
			StopFiles.Push(folderPath "\" part1 "_" part2 "_" part3 ".stop")
			StopFiles.Push(folderPath "\" part1 "_" part3 "_" part2 ".stop")

			for index, StopFile in StopFiles
			{
				FileAppend, , %StopFile%
			}
			
			ToolTip, stopping FDS
			Sleep, 2000
			
			WinWaitClose
		}
		
		FileDelete, %StopFile%
		IniRead, filePath, %A_ScriptDir%\inis\filePath.ini, filePath, filePath
		removeRTag := RemoveRestartFromMiscLine(filePath)
		
		If (removeRTag)
		{
			ToolTip, "RESTART=T" successfully removed from the "&MISC" line.
			Sleep, 1000
			ToolTip
		}
		Else
		{
			ToolTip, Failed to remove "RESTART=T" from the "&MISC" line.
			Sleep, 1000
			ToolTip
		}
	}
	
	if (FDS5 = 1)
	{
	
		GuiControlGet, folderPath, , folderPath
		GuiControlGet, fileName, , fileName
		
		ToolTip, % "FDS5 is " FDS5
		Sleep, 300
		ToolTip
		
		IniRead, filePath, %A_ScriptDir%\inis\filePath.ini, filePath, filePath
		
		folderPath := RegExReplace(filePath, "(.*\\).*", "$1")
		folderPath := SubStr(folderPath, 1, StrLen(folderPath) - 1)
        fileName := RegExReplace(filePath, ".+\\(.+)$", "$1")
		fileName := SubStr(fileName, 1, StrLen(fileName) - 4)

		If WinExist("ahk_id " . ID)
		{
			;MsgBox, WinExist %ID%
			WinKill, ahk_id %ID%
		}
		Else
		{
			MsgBox, There is no active FDS or MPI job running
		}
		
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
		
		If WinExist("ahk_id " . ID)
		{
			StopFiles := []
			StopFiles.Push(folderPath "\" part1 ".stop")
			StopFiles.Push(folderPath "\" part1 "_" part2 ".stop")
			StopFiles.Push(folderPath "\" part1 "_" part2 "_" part3 ".stop")
			StopFiles.Push(folderPath "\" part1 "_" part3 "_" part2 ".stop")

			for index, StopFile in StopFiles
			{
				FileAppend, , %StopFile%
			}
			
			ToolTip, stopping FDS
			Sleep, 2000
			
			WinWaitClose
		}
		
		FileDelete, %StopFile%
		IniRead, filePath, %A_ScriptDir%\inis\filePath.ini, filePath, filePath
		removeRTagFDS5 := RemoveRestartFromMiscLineFDS5(filePath)
		
		If (removeRTagFDS5)
		{
			ToolTip, "RESTART=.TRUE." successfully removed from the "&MISC" line.
			Sleep, 1000
			ToolTip
		}
		Else
		{
			ToolTip, Failed to remove "RESTART=.TRUE." from the "&MISC" line.
			Sleep, 1000
			ToolTip
		}
	}
	
	Return

CheckFDS:
	GuiControlGet, checkFDS, , checkFDS
	CheckFDSInstallation()
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
	If FDS6 = 1
	{
		Run, "%PyExe%" "%FSF%"
	}
	
	If FDS5 = 1
	{
		Run, "%PyExe%" "%FSF_FDS5%"
	}
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

Empit:
	If FileExist(SMPDEXE) && FileExist(HYDRAEXE)
	{
		ToolTip, Стравливаем SMPD и HYDRA_SERVICE
		sleep, 1000
		
		Run, "%install_services_run%"
		sleep, 1000
		
		;ToolTip, Стравливаем SMPD
		;sleep, 1000
		
		;Run, "%SMPDEXE%" " -install"
		;sleep, 1000
		
		;ToolTip, Стравливаем HYDRA_SERVICE
		;sleep, 1000
		
		;Run, "%HYDRAEXE%" " -install"
		;sleep, 1000
		
		ToolTip
	}
	Else
	{
		MsgBox, 4160, SMPD и HYDRA_SERVICE не обнаружены, Скачайте полный дистрибутив ZmejkaFDS
	}
	Return

;Поддержка ускорения расчета с помощью FDS5
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
				ToolTip, % "Пожалуйста, подождите"
				sleep, 2000
				
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
	
	GuiControl, , MPIpath, %MPIpath%
	GuiControl, , FDSpath, %FDSpath%
	
	ToolTip, Ускоритель отключен
	Sleep, 350
	ToolTip
	
	Return

AutoUpdateZ:
	/*
	If !FileExist(A_ScriptDir "\FDS5") || !FileExist(A_ScriptDir "\a_embed") || !FileExist(A_ScriptDir "\p_embed")
	{
		;Обновляем FDS5, a_embed и p_embed
		
		FileCopy, %HashLib_AutoUpdate_Libs%, %A_ScriptDir%
		Sleep, 1500
		
		Run, "%PyExeConsole%" "%A_ScriptDir%\HashLib_AutoUpdate_Libs.cpython-311.pyc", , , HashLibsPID
		WinWait, ahk_pid %HashLibsPID%
		Sleep, 1500
	}
	*/
	
	FileCopy, %HashLib_AutoUpdate_ZmejkaFDS%, %A_ScriptDir%
	sleep, 1500
	
	Run, "%PyExeConsole%" "%A_ScriptDir%\HashLib_AutoUpdate_ZmejkaFDS.cpython-311.pyc", , , HashZmejkaPID
	WinWait, ahk_pid %HashZmejkaPID%
	Sleep, 1500
	
	Return

GuiClose:
	ExitApp
	Return

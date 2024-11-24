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
#Include %A_ScriptDir%\a_libs\Clear_FDS5_SMV.ahk
#Include %A_ScriptDir%\a_libs\CheckFDSCompletedSuccessfully.ahk
#Include %A_ScriptDir%\a_libs\ReplaceQuotesInCSV.ahk
#Include %A_ScriptDir%\a_libs\GetHeatOfCombustion.ahk
#Include %A_ScriptDir%\a_libs\CheckSURFFIX.ahk
#Include %A_ScriptDir%\a_libs\RemoveExternalFilenameParameter.ahk

/*
	Инициализация среды embed (начало)
*/

AHKU64EXE := A_ScriptDir "\a_embed\AutoHotkeyU64.exe"
PyExe := A_ScriptDir "\p_embed\pythonw.exe"
PyExeConsole := A_ScriptDir "\p_embed\python.exe"
FDS5EXE := A_ScriptDir "\FDS5\fds5_mpi_win_64.exe"
FDS5EXEnoMPI := A_ScriptDir "\FDS5\fds5_win_64.exe"
FDS5MPIEXE := A_ScriptDir "\FDS5\mpiexec.exe"
SMPDEXE := A_ScriptDir "\FDS5\smpd.exe"
HYDRAEXE := A_ScriptDir "\FDS5\hydra_service.exe"
install_services_run := A_ScriptDir "\FDS5\install_services_run.bat"

;	Динамические библиотеки (начало)

; 	Модули (начало)

Insert_DEVC := A_ScriptDir "\a_libs\Insert_DEVC_v0.7.1.ahk"
PCTT := A_ScriptDir "\p_libs\Plot_CSV_Time_Threshhold_v0.7.1.cpython-311.pyc"
Refine := A_ScriptDir "\p_libs\Refine_v0.1.2.cpython-311.pyc"
Partition := A_ScriptDir "\p_libs\Partition_v0.1.2.cpython-311.pyc"
HRRP := A_ScriptDir "\p_libs\HRRP_v0.3.0.cpython-311.pyc"
MBDL := A_ScriptDir "\p_libs\MDBL_v0.1.0.cpython-311.pyc"
PFED := A_ScriptDir "\p_libs\plot_density_v0.6.2.cpython-311.pyc"
FSF := A_ScriptDir "\p_libs\FSF_v0.2.1a.cpython-311.pyc"
FSF_FDS5 := A_ScriptDir "\p_libs\FSF_v0.2.1a_FDS5.cpython-311.pyc"
RIbatulin := A_ScriptDir "\p_libs\update_num_pic.cpython-311.pyc"

;	Модули (конец)

Proceed_FDS5_DEVC_CSV_ALONE := A_ScriptDir "\p_libs\Proceed_FDS5_DEVC_CSV_ALONE.cpython-311.pyc"
Proceed_FDS5_DEVC_CSV := A_ScriptDir "\p_libs\Proceed_FDS5_DEVC_CSV.cpython-311.pyc"
Proceed_FDS5_HRR_CSV := A_ScriptDir "\p_libs\Proceed_FDS5_HRR_CSV.cpython-311.pyc"
HashLib_AutoUpdate_ZmejkaFDS := A_ScriptDir "\p_libs\HashLib_AutoUpdate_ZmejkaFDS.cpython-311.pyc"
HashLib_AutoUpdate_Libs := A_ScriptDir "\p_libs\HashLib_AutoUpdate_Libs.cpython-311.pyc"
Delete_FDS5_DEVC_CLOCK := A_ScriptDir "\p_libs\Delete_FDS5_DEVC_CLOCK.cpython-311.pyc"
Delete_DEVC_XnYn_MESHn := A_ScriptDir "\p_libs\Delete_DEVC_XnYn_MESHn.cpython-311.pyc"

;	Динамические библиотеки (конец)

/*
	Инициализация среды embed (конец)
*/

If FileExist(A_ScriptDir "\inis\FDSpath.ini")
{
	IniRead, FDSpath, %A_ScriptDir%\inis\FDSpath.ini, FDSpath, FDSpath
}
Else If FileExist(A_ScriptDir "\FDS6\fds.exe")
{
	FDSPath := A_ScriptDir "\FDS6\fds.exe"
	IniWrite, %FDSpath%, %A_ScriptDir%\inis\FDSpath.ini, FDSpath, FDSpath
}
Else
{
	FDSpath := ""
}

If FileExist(A_ScriptDir "\inis\MPIpath.ini")
{
	IniRead, MPIpath, %A_ScriptDir%\inis\MPIpath.ini, MPIpath, MPIpath
}
Else If FileExist(A_ScriptDir "\FDS6\mpiexec.exe")
{
	MPIpath := A_ScriptDir "\FDS6\mpiexec.exe"
	IniWrite, %MPIpath%, %A_ScriptDir%\inis\MPIpath.ini, MPIpath, MPIpath
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
chunksize := 50000
batchsize := 20

Gui, Add, Tab3, x2 y-1 w390 h310 +BackgroundTrans, Главный экран|Параметры|Построение графиков|Дополнительно|
Gui, Tab, Главный экран
Gui, Add, Edit, x12 y39 vFolderPath w240 h20, % folderPath
Gui, Add, Edit, x12 y69 vFileName w240 h20, % fileName
Gui, Add, Button, x262 y49 gBrowseFileButton w100 h30, Выбрать .fds
Gui, Add, Button, x12 y109 w80 h30 gStartButton vStartButton, Старт
Gui, Add, Button, x102 y109 w80 h30 gPauseButton vPauseButton, Пауза
Gui, Add, Button, x192 y109 w80 h30 gStopButton vStopButton, Стоп
Gui, Add, Button, x282 y109 w80 h30 gKillButton vKillButton, Прервать
Gui, Add, Button, x12 y149 w80 h30 gBrowseFDSButton, Найти fds.exe
Gui, Add, Edit, x102 y149 w260 h30 vFDSpath, %FDSpath%
Gui, Add, Button, x12 y189 w80 h30 gBrowseMPIButton, Найти mpiexec
Gui, Add, Edit, x102 y189 w260 h30 vMPIpath, %MPIpath%
Gui, Add, Progress, x13 y229 w350 h30 vProgressPercentage c0077BB, %ProgressPercentage%
Gui, Add, Text, x295 y285 w160 h20 , Zmejka_v0.12.29
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
Gui, Add, Text, x295 y285 w160 h20 , Zmejka_v0.12.29
Gui, Tab, Построение графиков
Gui, Add, Text, x22 y69 w120 h40 , Построить график F (dэфф) для нахождения tпор
Gui, Add, Button, x152 y69 w100 h40 gRunPCTT, PCTT
Gui, Add, Text, x22 y119 w110 h40 , Построить график плотности людских потоков
Gui, Add, Button, x152 y119 w100 h40 gRunPFED, PFED
Gui, Add, Text, x22 y169 w120 h40 , Построить график мощности пожара (HRR)
Gui, Add, Button, x152 y169 w100 h40 gRunHRRP, HRRP
Gui, Add, Text, x295 y285 w160 h20 , Zmejka_v0.12.29
Gui, Tab, Дополнительно
Gui, Add, Checkbox, x22 y29 w270 h20 gChckAlwDTR vChckAlw, Сохранять результаты моделирования каждые ;бывш. Добавить DT_RESTART
Gui, Add, Edit, x292 y29 w50 h20 vChckDTR Number, %ChckDTR%
Gui, Add, Text, x345 y29 w30 h20 , сек
Gui, Add, Radio, x22 y59 w280 h30 gFDS5 vFDS5, Ускорить моделирование пожара 
Gui, Add, Radio, x22 y89 w280 h30 gFDS6 vFDS6 Checked, Моделирование пожара по умолчанию
Gui, Add, Button, x345 y152 w15 h15 gRIbatulin vRIbatulin, N
Gui, Add, Button, x12 y269 w80 h30 gCheckFDS, Проверить наличие FDS
Gui, Add, Button, x102 y269 w80 h30 gAutoUpdateZ, Обновить ZmejkaFDS
Gui, Add, Button, x12 y229 w170 h30 gEmpit, Стравить службы MPI
Gui, Add, Text, x295 y285 w160 h20 , Zmejka_v0.12.29

Gui, Show, h310 w395, ZmejkaFDS

Return

BrowseFileButton:
	Gui, Submit, NoHide
	GetSelectedFile(folderPath, fileName, filePath)
	
	heatOfCombustionValue := GetHeatOfCombustion(filePath)
	
	for index, value in heatOfCombustionValue
	{
		;ShowToolTip("HEAT_OF_COMBUSTION в " index " = " value, 100)
		IniWrite, %value%, %A_ScriptDir%\inis\HOC.ini, HEAT_OF_COMBUSTION, HEAT_OF_COMBUSTION
	}
	
	IniWrite, %filePath%, %A_ScriptDir%\inis\filePath.ini, filePath, filePath
	IniWrite, %folderPath%, %A_ScriptDir%\inis\filePath.ini, folderPath, folderPath
	IniWrite, %fileName%, %A_ScriptDir%\inis\filePath.ini, fileName, fileName
	IniWrite, %chunksize%, %A_ScriptDir%\inis\filePath.ini, chunksize, chunksize
	IniWrite, %batchsize%, %A_ScriptDir%\inis\filePath.ini, batchsize, batchsize
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
	StartButton := 1
	PauseButton := 0
	StopButton := 0
	KillButton := 0
	
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
		
		ShowToolTip("Моделирование завершено!", 1000)
	}
	
	/*
		FDS5
	*/
	
	If (FDS5 = 1)
	{
		ToolTip, % "FDS5 is " FDS5
		Sleep, 300
		ToolTip
		
		;Функция проверки, что пользователь прогнал _nfs через SURF_FIX
		If InStr(filename, "_nfs")
		{
			check := CheckSURFFIX(filePath)
			
			if check = 0
			{
				GuiControl, Enable, StartButton
				ShowToolTip("SURF_FIX checked", 1000)
			}
			else
			{
				GuiControl, Disable, StartButton
				return
			}
		}
		
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
				TotalTime := ExtractLastTotalTime(OutfilePath)
				ProgressPercentage := (TotalTime / TEND) * 100
				GuiControl,, ProgressPercentage, %ProgressPercentage%
				Sleep, 250
				Continue
			}
			Else
			{
				Continue
			}
		} Until (TotalTime >= TEND && ProgressPercentage >= 100) || !FileExist(OutfilePath) || FileExist(StopFile) || !WinExist("ahk_id " . ID)
		
		WinWaitClose, ahk_id %ID%
		
		ShowToolTip("Моделирование завершено!", 1000)
		
		OutfilePath := folderPath "\" part1 ".out"
		
		IniRead, CheckfileName, %A_ScriptDir%\inis\filePath.ini, fileName, fileName
		csvALONE := folderPath "\" part1 "_devc.csv"
		smvfolder := folderPath "\smvfolder"
		
		If (StartButton = 1) && (ProgressPercentage >= 100) && CheckFDSCompletedSuccessfully(OutfilePath) && !WinExist("ahk_id " . ID)
		{
			ShowToolTip("Файл OUT содержит строчку 'STOP: FDS completed successfully'", 1000)
			ShowToolTip("AHK_ID " ID " не существует", 1000)
			
			RunWait, "%PyExeConsole%" "%Proceed_FDS5_HRR_CSV%"
			Sleep, 1000
			
			SetTitleMatchMode, RegEx
			
			If FileExist(csvALONE)
			{
				RunWait, "%PyExeConsole%" "%Proceed_FDS5_DEVC_CSV_ALONE%"
				Sleep, 1000
				RunWait, "%PyExeConsole%" "%Delete_DEVC_XnYn_MESHn%"
				Sleep, 1000
				
				ReplaceQuotesInCSV(csvALONE)
				ShowToolTip("Из ALONE CSV удалены лишние двойные кавычки", 1000)
				
				fds5smv := folderPath "\" part1 "_tout.smv"
				FileCreateDir, smvfolder
				FileCopy, fds5smv, smvfolder "\" part1 "_tout.smv"	
				
				Sleep, 1000
				Clear_FDS5_SMV(fds5smv)
				
				ShowToolTip("Результаты отгружены в программу по расчёту пожарного риска", 1000)
			}
			
			If !FileExist(csvALONE)
			{
				RunWait, "%PyExeConsole%" "%Proceed_FDS5_DEVC_CSV%"
				Sleep, 1000
				RunWait, "%PyExeConsole%" "%Delete_DEVC_XnYn_MESHn%"
				Sleep, 1000
				
				fds5smv := folderPath "\" part1 ".smv"
				FileCreateDir, smvfolder
				FileCopy, fds5smv, smvfolder "\" part1 ".smv"
				
				Sleep, 1000
				Clear_FDS5_SMV(fds5smv)
				
				ShowToolTip("Результаты отгружены в программу по расчёту пожарного риска", 1000)
			}
		}
		Else If CheckFDSStoppedByUser(OutfilePath)
		{
			ShowToolTip("Файл OUT содержиит строчку 'STOP: FDS stopped by user'", 1000)
		}
		Else
		{
			MsgBox, 4160, ZmejkaFDS, По какой-то причине FDS плохо кончил.`n`nЭта проблема ещё исследуется.`n`nПожалуйста, обратитесь к Нисе.`n`nОна поможет выявить проблему в вашем сценарии и оперативно решить её.`n`nЕсли вы нажали 'Прервать', то проигнорируйте это собщение
		}
		
		SetTitleMatchMode, 2
		
		ShowToolTip("Преобразование результатов моделирования завершено!", 1000)

		ProgressPercentage := 0
		GuiControl,, ProgressPercentage, %ProgressPercentage%
	}
	
	Return

PauseButton:
	StartButton := 0
	PauseButton := 1
	StopButton := 0
	KillButton := 0
	
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
			StopFiles.Push(folderPath "\" part1 "_" part3 ".stop")
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
				StopFiles.Push(folderPath "\" part1 "_" part3 ".stop")
				StopFiles.Push(folderPath "\" part1 "_" part2 "_" part3 ".stop")
				StopFiles.Push(folderPath "\" part1 "_" part3 "_" part2 ".stop")

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
				StopFiles.Push(folderPath "\" part1 "_" part3 ".stop")
				StopFiles.Push(folderPath "\" part1 "_" part2 "_" part3 ".stop")
				StopFiles.Push(folderPath "\" part1 "_" part3 "_" part2 ".stop")

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
				StopFiles.Push(folderPath "\" part1 "_" part3 ".stop")
				StopFiles.Push(folderPath "\" part1 "_" part2 "_" part3 ".stop")
				StopFiles.Push(folderPath "\" part1 "_" part3 "_" part2 ".stop")

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
	StartButton := 0
	PauseButton := 0
	StopButton := 1
	KillButton := 0
	
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
				StopFiles.Push(folderPath "\" part1 "_" part2 ".stop")
				StopFiles.Push(folderPath "\" part1 "_" part3 ".stop")
				StopFiles.Push(folderPath "\" part1 "_" part2 "_" part3 ".stop")
				StopFiles.Push(folderPath "\" part1 "_" part3 "_" part2 ".stop")

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
				StopFiles.Push(folderPath "\" part1 "_" part3 ".stop")
				StopFiles.Push(folderPath "\" part1 "_" part2 "_" part3 ".stop")
				StopFiles.Push(folderPath "\" part1 "_" part3 "_" part2 ".stop")

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
				StopFiles.Push(folderPath "\" part1 "_" part2 "_" part3 ".stop")
				StopFiles.Push(folderPath "\" part1 "_" part3 "_" part2 ".stop")

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
				StopFiles.Push(folderPath "\" part1 "_" part3 ".stop")
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
		
		ToolTip, fds.exe is closed
		Sleep, 1000
		ToolTip

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
				StopFiles.Push(folderPath "\" part1 "_" part3 ".stop")
				StopFiles.Push(folderPath "\" part1 "_" part2 "_" part3 ".stop")
				StopFiles.Push(folderPath "\" part1 "_" part3 "_" part2 ".stop")

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
				StopFiles.Push(folderPath "\" part1 "_" part3 ".stop")
				StopFiles.Push(folderPath "\" part1 "_" part2 "_" part3 ".stop")
				StopFiles.Push(folderPath "\" part1 "_" part3 "_" part2 ".stop")

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
				StopFiles.Push(folderPath "\" part1 "_" part3 ".stop")
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
		
		WinWaitClose, ahk_id %ID%
		
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
		
		IniRead, CheckfileName, %A_ScriptDir%\inis\filePath.ini, fileName, fileName
		csvALONE := folderPath "\" part1 "_devc.csv"
		
		SetTitleMatchMode, RegEx
		
		If (StopButton = 1) && (ProgressPercentage < 100) && CheckFDSStoppedByUser(OutfilePath) && !WinExist("ahk_id " . ID)
		{
			ShowToolTip("Файл OUT содержит строчку 'STOP: FDS stopped by user'", 1000)
			ShowToolTip("AHK_ID " ID " не существует", 1000)
			
			RunWait, "%PyExeConsole%" "%Proceed_FDS5_HRR_CSV%"
			Sleep, 1000
			
			If FileExist(csvALONE)
			{
				
				RunWait, "%PyExeConsole%" "%Proceed_FDS5_DEVC_CSV_ALONE%"
				Sleep, 1000
				RunWait, "%PyExeConsole%" "%Delete_DEVC_XnYn_MESHn%"
				Sleep, 1000
				
				ReplaceQuotesInCSV(csvALONE)
				ShowToolTip("Из ALONE CSV удалены лишние двойные кавычки", 1000)
				
				fds5smv := folderPath "\" part1 ".smv"
				smvfolder := folderPath "\smvfolder"
				
				FileCreateDir, smvfolder
				FileCopy, fds5smv, smvfolder "\" part1 ".smv"			
				
				Sleep, 2000
				Clear_FDS5_SMV(fds5smv)
								
				ShowToolTip("Результаты отгружены в программу по расчёту пожарного риска", 1000)
			}
			
			If !FileExist(csvALONE)
			{
				RunWait, "%PyExeConsole%" "%Proceed_FDS5_DEVC_CSV%"
				Sleep, 1000
				RunWait, "%PyExeConsole%" "%Delete_DEVC_XnYn_MESHn%"
				Sleep, 1000
				
				fds5smv := folderPath "\" part1 ".smv"
				smvfolder := folderPath "\smvfolder"
				
				FileCreateDir, smvfolder
				FileCopy, fds5smv, smvfolder "\" part1 ".smv"
				
				Sleep, 2000
				Clear_FDS5_SMV(fds5smv)
								
				ShowToolTip("Результаты отгружены в программу по расчёту пожарного риска", 1000)
			}
		}
		Else
		{
			MsgBox, Specified line was not found in the OUT file
		}
		
		SetTitleMatchMode, 2
		
		ShowToolTip("Преобразование результатов моделирования завершено!", 1000)
		
		ProgressPercentage := 0
		GuiControl,, ProgressPercentage, %ProgressPercentage%
	}
	
	Return

KillButton:
	StartButton := 0
	PauseButton := 0
	StopButton := 0
	KillButton := 1
	
	if (FDS6 = 1)
	{
		GuiControlGet, folderPath, , folderPath
		GuiControlGet, fileName, , fileName
		
		If WinExist("ahk_id " . ID)
		{
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
			StopFiles.Push(folderPath "\" part1 "_" part3 ".stop")
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
			StopFiles.Push(folderPath "\" part1 "_" part3 ".stop")
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
	RunWait, "%AHKU64EXE%" "%Insert_DEVC%"
	
	toutfileFound := 0
	Loop, %folderPath%\*_tout*
	{
		if FileExist(A_LoopFileFullPath)
		{
			toutfileFound := 1
			
			fileName := fileName "_tout"
			filePath := folderpath "\" fileName ".fds"
			
			IniWrite, %filePath%, %A_ScriptDir%\inis\filePath.ini, filePath, filePath
			IniWrite, %fileName%, %A_ScriptDir%\inis\filePath.ini, fileName, fileName
			
			GuiControl,, folderPath, %folderPath%
			GuiControl,, fileName, %fileName%
			
			break
		}
	}
	
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
		RunWait, "%PyExe%" "%FSF_FDS5%"
		
		check := CheckSURFFIX(filepath)
		
		if check = 0
			GuiControl, Enable, StartButton
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
		
		ToolTip
	}
	Else
	{
		MsgBox, 4160,, SMPD и HYDRA_SERVICE не обнаружены, Скачайте полный дистрибутив ZmejkaFDS
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
		
		fileFound := 0
		Loop, %folderPath%\*_nfs*
		{
			if FileExist(A_LoopFileFullPath)
			{
				fileFound := 1
				break
			}
		}
		
		If (FDS5 = 1)
		{
			;MsgBox, % FDS5 " is checked and " fileFound 
			If !InStr(fileName, "_nfs") && fileFound = 0
			{
				;MsgBox, % fileName " does contain _nfs.fds"
				nfsfile := folderPath . "\" . fileName . "_nfs.fds"
				
				FileCopy, %filePath%, %nfsfile%
				ShowToolTip("Пожалуйста, подождите .", 400)
				ShowToolTip("Пожалуйста, подождите . .", 400)
				ShowToolTip("Пожалуйста, подождите . . .", 400)
				ShowToolTip("Пожалуйста, подождите . . . .", 400)
				ShowToolTip("Пожалуйста, подождите . . . . .", 400)
				
				;fileName := fileName "_nfs"
				filePath := nfsfile
				
				ShowToolTip("Создан " filePath, 400)
				
				Process_REAC_Line_to_FDS5(filePath)
				ShowToolTip("Подготовка реакции &REAC", 400)
				
				Process_MISC_Line_to_FDS5(filePath)
				ShowToolTip("Подготовка строки &MISC", 400)
				
				RemoveExternalFilenameParameter(filePath)
				ShowToolTip("Удаление  параметра EXTERNAL_FILENAME", 400)
				
				Remove_HCL_Lines(filePath)
				ShowToolTip("Подготовка слайсов &SLCF и измерителей &DEVC", 400)
				
				Remove_SPEC_COMB_WIND_Lines(filePath)
				ShowToolTip("Очистка входного сценария от лишних &SPEC, &COMB, &WIND", 400)
				
				ShowToolTip("Сценарий " fileName ".fds готов к запуску", 400)
				
				fileName := fileName "_nfs"
				filePath := folderpath "\" fileName ".fds"
				
				IniWrite, %filePath%, %A_ScriptDir%\inis\filePath.ini, filePath, filePath
				IniWrite, %fileName%, %A_ScriptDir%\inis\filePath.ini, fileName, fileName
				GuiControl,, folderPath, %folderPath%
				GuiControl,, fileName, %fileName%
				
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
		FDSpath := FDSpath
	}

	If FileExist(A_ScriptDir "\inis\MPIpath.ini")
	{
		IniRead, MPIpath, %A_ScriptDir%\inis\MPIpath.ini, MPIpath, MPIpath
	}
	Else
	{
		MPIpath := MPIpath
	}
	
	fileName := RTrim(fileName, "_nfs")
	filePath := folderpath "\" fileName ".fds"
	
	IniWrite, %filePath%, %A_ScriptDir%\inis\filePath.ini, filePath, filePath
	IniWrite, %fileName%, %A_ScriptDir%\inis\filePath.ini, fileName, fileName
	GuiControl,, folderPath, %folderPath%
	GuiControl,, fileName, %fileName%
	
	GuiControl, , MPIpath, %MPIpath%
	GuiControl, , FDSpath, %FDSpath%
	
	ToolTip, Ускоритель отключен
	Sleep, 350
	ToolTip
	
	Return

AutoUpdateZ:
	FileCopy, %HashLib_AutoUpdate_ZmejkaFDS%, %A_ScriptDir%
	sleep, 1500
	
	Run, "%PyExeConsole%" "%A_ScriptDir%\HashLib_AutoUpdate_ZmejkaFDS.cpython-311.pyc", , , HashZmejkaPID
	WinWait, ahk_pid %HashZmejkaPID%
	Sleep, 1500
	
	Return

RIbatulin:
	Run, "%PyExeConsole%" "%RIbatulin%"
	Return

GuiClose:
	ExitApp
	Return

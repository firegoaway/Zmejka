/*
	ZmejkaFDS разработана экслюзивно для сообщества FIREGOAWAY
*/

#SingleInstance Off
#Persistent
#NoEnv
SetTitleMatchMode, 2

;	Генерируем УИН для каждого нового инстанса
ProcessID := DllCall("GetCurrentProcessId")
UniqueID := ProcessID

UniqueIDinipath := A_ScriptDir "\inis\UniqueID_" UniqueID ".ini"
IniWrite, %UniqueID%, %UniqueIDinipath%, UniqueID, UniqueID

/*
	AHK Функции
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
#Include %A_ScriptDir%\a_libs\RecycleInis.ahk
#Include %A_ScriptDir%\a_libs\HSEmpit.ahk

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
global install_services_run := A_ScriptDir "\FDS5\install_services_run.bat"

;	Динамические библиотеки (начало)

; 	Модули (начало)
Insert_DEVC := A_ScriptDir "\a_libs\Insert_DEVC_v0.8.2.ahk"
PCTT := A_ScriptDir "\p_libs\Plot_CSV_Time_Threshhold_v0.8.0.cpython-311.pyc"
Refine := A_ScriptDir "\p_libs\Refine_v0.2.2.cpython-311.pyc"
Partition := A_ScriptDir "\p_libs\Partition_v0.2.2.cpython-311.pyc"
SPDZ := A_ScriptDir "\p_libs\INIT_md_v0.2.0.cpython-311.pyc"
HRRP := A_ScriptDir "\p_libs\HRRP_v0.5.0.cpython-311.pyc"
MBDL := A_ScriptDir "\p_libs\MDBL_v0.1.0.cpython-311.pyc"
PFED := A_ScriptDir "\p_libs\plot_density_v0.6.2.cpython-311.pyc"
FSF := A_ScriptDir "\p_libs\FSF_v0.5.3.cpython-311.pyc"
FSF_FDS5 := A_ScriptDir "\p_libs\FSF_v0.5.3_FDS5.cpython-311.pyc"
FRP := A_ScriptDir "\p_libs\FDS_REAC_Prooner.cpython-311.pyc"
RIbatulin := A_ScriptDir "\p_libs\update_num_pic.cpython-311.pyc"

;	Модули (конец)
Proceed_DUMP := A_ScriptDir "\p_libs\Proceed_DUMP.cpython-311.pyc"
Proceed_FDS5_CSV := A_ScriptDir "\p_libs\Proceed_FDS5_CSV.cpython-311.pyc"
Proceed_FDS6_CSV := A_ScriptDir "\p_libs\Proceed_FDS6_CSV.cpython-311.pyc"
renaming_utils := A_ScriptDir "\p_libs\renaming_utils.cpython-311.pyc"
HashLib_AutoUpdate_ZmejkaFDS := A_ScriptDir "\p_libs\HashLib_AutoUpdate_ZmejkaFDS.cpython-311.pyc"
HashLib_AutoUpdate_Libs := A_ScriptDir "\p_libs\HashLib_AutoUpdate_Libs.cpython-311.pyc"
Delete_FDS5_DEVC_CLOCK := A_ScriptDir "\p_libs\Delete_FDS5_DEVC_CLOCK.cpython-311.pyc"
Delete_DEVC_XnYn_MESHn := A_ScriptDir "\p_libs\Delete_DEVC_XnYn_MESHn.cpython-311.pyc"

;	Динамические библиотеки (конец)

/*
	Инициализация среды embed (конец)
*/

;	Идентифицируем пути к INI-файлам по УИН
FDSpathIni := A_ScriptDir "\inis\FDSpath_" UniqueID ".ini"
MPIpathIni := A_ScriptDir "\inis\MPIpath_" UniqueID ".ini"
filePathIni := A_ScriptDir "\inis\filePath_" UniqueID ".ini"
HOCpathIni := A_ScriptDir "\inis\HOC_" UniqueID ".ini"

;	Проверяем наличие папки "Inis"
IfNotExist, %A_ScriptDir%\inis
    FileCreateDir, %A_ScriptDir%\inis

If FileExist(FDSpathIni)
{
	IniRead, FDSpath, %FDSpathIni%, FDSpath, FDSpath
}
Else If FileExist(A_ScriptDir "\FDS6\fds.exe")
{
	FDSPath := A_ScriptDir "\FDS6\fds.exe"
	IniWrite, %FDSpath%, %FDSpathIni%, FDSpath, FDSpath
}
Else
{
	FDSpath := ""
}

If FileExist(MPIpathIni)
{
	IniRead, MPIpath, %MPIpathIni%, MPIpath, MPIpath
}
Else If FileExist(A_ScriptDir "\FDS6\mpiexec.exe")
{
	MPIpath := A_ScriptDir "\FDS6\mpiexec.exe"
	IniWrite, %MPIpath%, %MPIpathIni%, MPIpath, MPIpath
}
Else
{
	MPIpath := ""
}

If FileExist(filePathIni)
{
	IniRead, filePath, %filePathIni%, filePath, filePath
	IniRead, folderPath, %filePathIni%, folderPath, folderPath
	IniRead, fileName, %filePathIni%, fileName, fileName
	GuiControl, , folderPath%UniqueID%
	GuiControl, , fileName%UniqueID%
}
Else
{
	filePath := ""
	folderPath := "Укажите путь к папке с файлом сценария (.fds)"
	fileName := "Укажите имя файла сценария (.fds)"
}

ChckDTR := 50
FDS6 := 1
FDS5 := 0
ProgressPercentage := 0
chunksize := 50000
batchsize := 20

CheckServices(HYDRAEXE, SMPDEXE)

Gui, Add, Tab3, x2 y-1 w390 h310 +BackgroundTrans, Главный экран|Параметры|Построение графиков|Дополнительно|
Gui, Tab, Главный экран
Gui, Add, Edit, x12 y39 vFolderPath%UniqueID% w240 h20, % folderPath
Gui, Add, Edit, x12 y69 vFileName%UniqueID% w240 h20, % fileName
Gui, Add, Button, x262 y49 gBrowseFileButton w100 h30, Выбрать .fds
Gui, Add, Button, x12 y109 w80 h30 gStartButton vStartButton%UniqueID%, Старт
Gui, Add, Button, x102 y109 w80 h30 gPauseButton vPauseButton%UniqueID%, Пауза
Gui, Add, Button, x192 y109 w80 h30 gStopButton vStopButton%UniqueID%, Стоп
Gui, Add, Button, x282 y109 w80 h30 gKillButton vKillButton%UniqueID%, Прервать
Gui, Add, Button, x12 y149 w80 h30 gBrowseFDSButton vBrowseFDSButton%UniqueID%, Найти fds.exe
Gui, Add, Edit, x102 y149 w260 h30 vFDSpath%UniqueID%, %FDSpath%
Gui, Add, Button, x12 y189 w80 h30 gBrowseMPIButton vBrowseMPIButton%UniqueID%, Найти mpiexec
Gui, Add, Edit, x102 y189 w260 h30 vMPIpath%UniqueID%, %MPIpath%
Gui, Add, Progress, x13 y229 w350 h30 vProgressPercentage%UniqueID% c0077BB, %ProgressPercentage%
Gui, Add, Text, x325 y285 w160 h20 , ID:%UniqueID%
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
Gui, Add, Text, x325 y285 w160 h20 , ID:%UniqueID%
Gui, Tab, Построение графиков
Gui, Add, Text, x22 y69 w120 h40 , Построить график F (dэфф) для нахождения tпор
Gui, Add, Button, x152 y69 w100 h40 gRunPCTT, PCTT
Gui, Add, Text, x22 y119 w110 h40 , Построить график плотности людских потоков
Gui, Add, Button, x152 y119 w100 h40 gRunPFED, PFED
Gui, Add, Text, x22 y169 w120 h40 , Построить график мощности пожара (HRR)
Gui, Add, Button, x152 y169 w100 h40 gRunHRRP, HRRP
Gui, Add, Text, x22 y219 w120 h40 , Расчитать параметры СПДЗ
Gui, Add, Button, x152 y219 w100 h40 gRunSPDZ, SPDZ
Gui, Add, Text, x325 y285 w160 h20 , ID:%UniqueID%
Gui, Tab, Дополнительно
Gui, Add, Checkbox, x22 y29 w270 h20 gChckAlwDTR vChckAlw, Выгружать результаты моделирования из RAM
;Gui, Add, Edit, x292 y29 w50 h20 vChckDTR Number, %ChckDTR%
;Gui, Add, Text, x345 y29 w30 h20 , сек
Gui, Add, Radio, x22 y59 w280 h30 gFDS5 vFDS5, Ускорить моделирование пожара 
Gui, Add, Radio, x22 y89 w280 h30 gFDS6 vFDS6 Checked, Моделирование пожара по умолчанию
Gui, Add, Button, x22 y129 w200 h25 gRunFRP, Калькулятор реакции FDS 6
Gui, Add, Button, x22 y159 w50 h20 gRunArise, Arise
Gui, Add, Button, x345 y152 w18 h15 gRIbatulin vRIbatulin, RI
Gui, Add, Button, x12 y269 w80 h30 gCheckFDS, Проверить наличие FDS
Gui, Add, Button, x102 y269 w80 h30 gAutoUpdateZ, Обновить ZmejkaFDS
Gui, Add, Button, x12 y229 w170 h30 gEmpit, Стравить службы MPI
Gui, Add, Text, x325 y285 w160 h20 , ID:%UniqueID%

Gui, Show, h310 w395, ZmejkaFDS v0.13.7

Return

BrowseFileButton:
	Gui, Submit, NoHide
	GetSelectedFile(folderPath, fileName, filePath)
	
	heatOfCombustionValue := GetHeatOfCombustion(filePath)
	
	for index, value in heatOfCombustionValue
	{
		;ShowToolTip("HEAT_OF_COMBUSTION в " index " = " value, 100)
		IniWrite, %value%, %HOCpathIni%, HEAT_OF_COMBUSTION, HEAT_OF_COMBUSTION
	}
	
	IniWrite, %filePath%, %filePathIni%, filePath, filePath
	IniWrite, %folderPath%, %filePathIni%, folderPath, folderPath
	IniWrite, %fileName%, %filePathIni%, fileName, fileName
	IniWrite, %chunksize%, %filePathIni%, chunksize, chunksize
	IniWrite, %batchsize%, %filePathIni%, batchsize, batchsize
	
	GuiControl,, folderPath%UniqueID%, %folderPath%
	GuiControl,, fileName%UniqueID%, %fileName%
	Return
	
ChckAlwDTR:
	Gui, Submit, NoHide
	If (ChckAlw = 1)
	{
		;CheckDUMP(filePath, ChckDTR)
		CheckFFB(filePath, ".TRUE.")
		MsgBox, Внимание!`nВключение данного параметра поможет избежать переполнения буфера памяти для сценариев с числом ячеек более 10 млн.`nОднако, если в процессе моделирования вы включите просмотр результатов через SmokeView или PyrosimView, то моделирование прекратится с ошибкой.`nЭто не баг, а ограничение самого FDS.
	}
	else if (ChckAlw = 0)
	{
		;UnCheckDUMP(filePath)
		CheckFFB(filePath, ".FALSE.")
	}
	Return

StartButton:
	StartButton := 1
	GuiControl, Disable, StartButton%UniqueID%
	PauseButton := 0
	StopButton := 0
	KillButton := 0

	IniRead, filePath, %filePathIni%, filePath, filePath
	IniRead, folderPath, %filePathIni%, folderPath, folderPath
	IniRead, fileName, %filePathIni%, fileName, fileName
	
	GuiControlGet, folderPath, , folderPath%UniqueID%
    GuiControlGet, fileName, , fileName%UniqueID%
    GuiControlGet, FDSpath, , FDSpath%UniqueID%
    GuiControlGet, MPIpath, , MPIpath%UniqueID%
	
	IniWrite, %folderPath%, %filePathIni%, folderPath, folderPath
	IniWrite, %fileName%, %filePathIni%, fileName, fileName

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
		
		IniRead, filePath, %filePathIni%, filePath, filePath
		
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
		
		If (FileExist(FDSpathIni) && (FDSpath != "")) && (FileExist(FDSpathIni) && (MPIpath != ""))
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
		
		Else If (!FileExist(FDSpathIni) || (FDSpath = "")) && (FileExist(FDSpathIni) && (MPIpath != ""))
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
		
		Else If (FileExist(FDSpathIni) && (FDSpath != "")) && (!FileExist(FDSpathIni) && (MPIpath = ""))
		{
			IniRead, FDSpath, %FDSpathIni%, FDSpath, FDSpath
			
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
				GuiControl,, ProgressPercentage%UniqueID%, %ProgressPercentage%
				Sleep, 250
				Continue
			}
			Else
			{
				Continue
			}
		} Until (TotalTime >= TEND) || !FileExist(OutfilePath) || FileExist(StopFile) || !WinExist("ahk_id " . ID)
		
		ProgressPercentage := 100
		GuiControl,, ProgressPercentage%UniqueID%, %ProgressPercentage%
		Sleep, 200
		
		ShowToolTip("Моделирование завершено!", 1000)
		
		GuiControl, Disable, StartButton%UniqueID%
		
		IniRead, filePath, %filePathIni%, fileName, fileName
		csvALONE := folderPath "\" part1 "_devc.csv"
		
		If (StartButton = 1) && (ProgressPercentage >= 100) && CheckFDSCompletedSuccessfully(OutfilePath) && !WinExist("ahk_id " . ID)
		{	
			ShowToolTip("Файл OUT содержит строчку 'STOP: FDS completed successfully'", 1000)
			ShowToolTip("AHK_ID " ID " не существует", 1000)
			
			SetTitleMatchMode, RegEx

			if InStr(filename, "_tout")
			{
				RunWait, "%PyExe%" "%Proceed_FDS6_CSV%" %ProcessID%, , , PID
				ShowToolTip("Результаты успешно обработаны", 1000)

				if FileExist(csvALONE)
				{
					ReplaceQuotesInCSV(csvALONE)
					ShowToolTip("Из ALONE CSV удалены лишние двойные кавычки", 1000)
				}
				
				ShowToolTip("Результаты отгружены в программу по расчёту пожарного риска", 1000)
			}
			Else
			{
				ShowToolTip("Расчет tout не выполнялся", 1000)
			}
		}
		Else If CheckFDSStoppedByUser(OutfilePath)
		{
			ShowToolTip("Файл OUT содержиит строчку 'STOP: FDS stopped by user'", 1000)
		}
		Else
		{
			ShowToolTip(CheckFDSStoppedByUser(OutfilePath) " строчка 'STOP: FDS stopped by user' не найдена.", 1000)
		}
		
		SetTitleMatchMode, 2
		
		ShowToolTip("Преобразование результатов моделирования завершено!", 1000)
		
		GuiControl, Enable, StartButton%UniqueID%

		ProgressPercentage := 0
		GuiControl,, ProgressPercentage%UniqueID%, %ProgressPercentage%
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
				GuiControl, Enable, StartButton%UniqueID%
				ShowToolTip("SURF_FIX checked", 1000)
			}
			else
			{
				GuiControl, Disable, StartButton%UniqueID%
				return
			}
		}
		
		GuiControl, Disable, StartButton%UniqueID%
		
		CheckDUMP(filePath, ChckDTR)
		sleep, 75
		RunWait, "%PyExe%" "%Proceed_DUMP%" %ProcessID%, , , PID
		sleep, 150
		
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
				GuiControl,, ProgressPercentage%UniqueID%, %ProgressPercentage%
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
		
		GuiControl, Disable, StartButton%UniqueID%
		
		IniRead, CheckfileName, %filePathIni%, fileName, fileName
		csvALONE := folderPath "\" part1 "_devc.csv"
		smvfolder := folderPath "\smvfolder"
		
		If (StartButton = 1) && (ProgressPercentage >= 100) && CheckFDSCompletedSuccessfully(OutfilePath) && !WinExist("ahk_id " . ID)
		{
			ShowToolTip("Файл OUT содержит строчку 'STOP: FDS completed successfully'", 1000)
			ShowToolTip("AHK_ID " ID " не существует", 1000)
			
			SetTitleMatchMode, RegEx

			RunWait, "%PyExe%" "%Proceed_FDS5_CSV%" %ProcessID%, , , PID
			ShowToolTip("Результаты успешно обработаны", 1000)
			
			if FileExist(csvALONE)
			{
				ReplaceQuotesInCSV(csvALONE)
				ShowToolTip("Из ALONE CSV удалены лишние двойные кавычки", 1000)
			}
						
			fds5smv := folderPath "\" part1 ".smv"
			FileCreateDir, smvfolder
			FileCopy, fds5smv, smvfolder "\" part1 ".smv"	
			
			Sleep, 1000
			Clear_FDS5_SMV(fds5smv)
			
			ShowToolTip("Результаты отгружены в программу по расчёту пожарного риска", 1000)
		}
		Else If CheckFDSStoppedByUser(OutfilePath)
		{
			ShowToolTip("Файл OUT содержиит строчку 'STOP: FDS stopped by user'", 1000)
		}
		Else
		{
			ShowToolTip(CheckFDSStoppedByUser(OutfilePath) " строчка 'STOP: FDS stopped by user' не найдена.", 1000)
		}
		
		SetTitleMatchMode, 2
		
		ShowToolTip("Преобразование результатов моделирования завершено!", 1000)
		
		GuiControl, Disable, StartButton%UniqueID%

		ProgressPercentage := 0
		GuiControl,, ProgressPercentage%UniqueID%, %ProgressPercentage%
	}
	GuiControl, Enable, StartButton%UniqueID%
	Return

PauseButton:
	StartButton := 0
	PauseButton := 1
	StopButton := 0
	KillButton := 0
	
	If (FDS6 = 1)
	{
		GuiControlGet, folderPath, , folderPath%UniqueID%
		GuiControlGet, fileName, , fileName%UniqueID%
		
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
		
		IniRead, filePath, %filePathIni%, filePath, filePath
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
		
		IniRead, filePath, %filePathIni%, filePath, filePath
		
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
	GuiControl, Enable, StartButton%UniqueID%
	Return

StopButton:
	StartButton := 0
	PauseButton := 0
	StopButton := 1
	KillButton := 0
	
	if (FDS6 = 1)
	{
		IniRead, filePath, %filePathIni%, filePath, filePath
		
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

		IniRead, filePath, %filePathIni%, filePath, filePath
		
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
		
		IniRead, filePath, %filePathIni%, filePath, filePath
		
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
		
		IniRead, CheckfileName, %filePathIni%, fileName, fileName
		csvALONE := folderPath "\" part1 "_devc.csv"
		SetTitleMatchMode, RegEx
		
		If (StopButton = 1) && (ProgressPercentage < 100) && CheckFDSStoppedByUser(OutfilePath) && !WinExist("ahk_id " . ID)
		{
			ShowToolTip("Файл OUT содержит строчку 'STOP: FDS stopped by user'", 1000)
			ShowToolTip("AHK_ID " ID " не существует", 1000)

			RunWait, "%PyExe%" "%Proceed_FDS5_CSV%" %ProcessID%, , , PID
			ShowToolTip("Результаты успешно обработаны", 1000)
			
			if FileExist(csvALONE)
			{
				ReplaceQuotesInCSV(csvALONE)
				ShowToolTip("Из ALONE CSV удалены лишние двойные кавычки", 1000)
			}
			
			fds5smv := folderPath "\" part1 ".smv"
			smvfolder := folderPath "\smvfolder"
			
			FileCreateDir, smvfolder
			FileCopy, fds5smv, smvfolder "\" part1 ".smv"			
			
			Sleep, 2000
			Clear_FDS5_SMV(fds5smv)
							
			ShowToolTip("Результаты отгружены в программу по расчёту пожарного риска", 1000)
		}
		Else
		{
			MsgBox, Specified line was not found in the OUT file
		}
		
		SetTitleMatchMode, 2
		
		ShowToolTip("Преобразование результатов моделирования завершено!", 1000)
		
		GuiControl, Disable, StartButton%UniqueID%
		
		ProgressPercentage := 0
		GuiControl,, ProgressPercentage%UniqueID%, %ProgressPercentage%
	}
	Return

KillButton:
	StartButton := 0
	PauseButton := 0
	StopButton := 0
	KillButton := 1
	
	if (FDS6 = 1)
	{
		GuiControlGet, folderPath, , folderPath%UniqueID%
		GuiControlGet, fileName, , fileName%UniqueID%
		
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
		IniRead, filePath, %filePathIni%, filePath, filePath
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
	
		GuiControlGet, folderPath, , folderPath%UniqueID%
		GuiControlGet, fileName, , fileName%UniqueID%
		
		ToolTip, % "FDS5 is " FDS5
		Sleep, 300
		ToolTip
		
		IniRead, filePath, %filePathIni%, filePath, filePath
		
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
		IniRead, filePath, %filePathIni%, filePath, filePath
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
	GuiControlGet, checkFDS, , checkFDS%UniqueID%
	CheckFDSInstallation()
	Return
	
BrowseFDSButton:
	GetSelectedExe(FDSpath)
	IniWrite, %FDSpath%, %FDSpathIni%, FDSpath, FDSpath
	GuiControl, , FDSpath%UniqueID%, % FDSpath
	If !FileExist(FDSpathIni)
	{
		IniWrite, %FDSpath%, %FDSpathIni%, FDSpath, FDSpath
	}
	Else
	{
		IniRead, FDSpath, %FDSpathIni%, FDSpath, FDSpath
	}
	Return

BrowseMPIButton:
	GetSelectedExe(MPIpath)
	GuiControl, , MPIpath%UniqueID%, % MPIpath
	If !FileExist(MPIpathIni)
	{
		IniWrite, %MPIpath%, %MPIpathIni%, MPIpath, MPIpath
	}
	Else
	{
		IniRead, MPIpath, %MPIpathIni%, MPIpath, MPIpath
	}
	Return

RunInsertDEVC:
	flagPath := A_ScriptDir "\inis\flag_" UniqueID ".txt"
	
	FileAppend, 1, %flagPath%
	
	RunWait, "%AHKU64EXE%" "%Insert_DEVC%" %ProcessID%, , , PID
	
	FileDelete, %flagPath%
	
	toutfileFound := 0
	
	Loop, %folderPath%\*_tout*
	{
		if FileExist(A_LoopFileFullPath) && FileExist(folderPath "\" fileName "_tout.fds")
		{
			toutfileFound := 1
			
			If !InStr(fileName, "_tout")
				fileName := fileName "_tout"
			filePath := folderpath "\" fileName ".fds"
			
			IniWrite, %filePath%, %filePathIni%, filePath, filePath
			IniWrite, %fileName%, %filePathIni%, fileName, fileName
			
			GuiControl,, folderPath%UniqueID%, %folderPath%
			GuiControl,, fileName%UniqueID%, %fileName%
			
			break
		}
	}
	Return

RunPCTT:
	Run, "%PyExe%" "%PCTT%" %ProcessID%, , , PID
	Return

RunPFED:
	Run, "%PyExe%" "%PFED%"
	Return

RunSURF:
	If FDS6 = 1
	{
		Run, "%PyExe%" "%FSF%" %ProcessID%, , , PID
	}
	
	If FDS5 = 1
	{
		RunWait, "%PyExe%" "%FSF_FDS5%" %ProcessID%, , , PID
		
		check := CheckSURFFIX(filepath)
		
		if check = 0
			GuiControl, Enable, StartButton
	}
	Return
	
RunFRP:
	If FDS6 = 1
	{
		Run, "%PyExe%" "%FRP%" %ProcessID%, , , PID
	}
	
	If FDS5 = 1
	{
		MsgBox, Данная функция не предназначена для ускоренных расчетов.
	}
	Return

RunArise:
	If FDS6 = 1
	{
		MsgBox, 4, , Выполнить преобразование результатов моделировая FDS 6.8.0 ещё раз?`n`nНа случай, если преобразование не было выполнено корректно, в папке с результатами остались файоы с постфикосом '_tout'(или) программа по расчету риска не видит результаты моделирования.
		IfMsgBox Yes
		{
			RunWait, "%PyExe%" "%Proceed_FDS6_CSV%" %ProcessID%, , , PID
			ShowToolTip("Преобразование результатов моделирования завершено!", 1000)
		}
	}
	
	If FDS5 = 1
	{
		MsgBox, Данная функция не предназначена для ускоренных расчетов.
	}
	Return

RunSPDZ:
	Run, "%PyExe%" "%SPDZ%" %ProcessID%, , , PID
	Return

RunHRRP:
	Run, "%PyExe%" "%HRRP%" %ProcessID%, , , PID
	Return
	
RunPartitioner:
	Run, "%PyExe%" "%Partition%" %ProcessID%, , , PID
	Return

RunRefiner:
	Run, "%PyExe%" "%Refine%" %ProcessID%, , , PID
	Return
	
RunMDBL:
	Run, "%PyExe%" "%MBDL%"
	Return

Empit:
	If !ProcessExist("hydra_service.exe") || !ProcessExist("smpd.exe")
		CheckServices(HYDRAEXE, SMPDEXE)
	Else
		MsgBox % "Службы HYDRA_SERVICE и SMPD уже запущены."
	Return

;Поддержка ускорения расчета с помощью FDS5
FDS5:
	GuiControl, Disable, BrowseFDSButton%UniqueID%
	GuiControl, Disable, BrowseMPIButton%UniqueID%
	
	FDS6 := 0
	FDS5 := 1
	
	FDSpath := ""
	GuiControl, , FDSpath%UniqueID%
	MPIpath := ""
	GuiControl, , MPIpath%UniqueID%
	
	If FileExist(filePathIni) && (filePath != "")
	{
		IniRead, filePath, %filePathIni%, filePath, filePath
		
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
				
				IniWrite, %filePath%, %filePathIni%, filePath, filePath
				IniWrite, %fileName%, %filePathIni%, fileName, fileName
				GuiControl,, folderPath%UniqueID%, %folderPath%
				GuiControl,, fileName%UniqueID%, %fileName%
				
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
	GuiControl, Enable, BrowseFDSButton%UniqueID%
	GuiControl, Enable, BrowseMPIButton%UniqueID%
	
	FDS6 := 1
	FDS5 := 0
	
	If FileExist(FDSpathIni)
	{
		IniRead, FDSpath, %FDSpathIni%, FDSpath, FDSpath
	}
	Else
	{
		FDSpath := FDSpath
	}

	If FileExist(FDSpathIni)
	{
		IniRead, MPIpath, %MPIpathIni%, MPIpath, MPIpath
	}
	Else
	{
		MPIpath := MPIpath
	}
	
	fileName := RTrim(fileName, "_nfs")
	filePath := folderpath "\" fileName ".fds"
	
	IniWrite, %filePath%, %filePathIni%, filePath, filePath
	IniWrite, %fileName%, %filePathIni%, fileName, fileName
	GuiControl,, folderPath%UniqueID%, %folderPath%
	GuiControl,, fileName%UniqueID%, %fileName%
	
	GuiControl, , MPIpath%UniqueID%, %MPIpath%
	GuiControl, , FDSpath%UniqueID%, %FDSpath%
	
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
	;	Очищаем кэш конфигурации
	IfExist, %A_ScriptDir%\inis
		DeleteIniFiles()
	;	Закругляемся
	ExitApp
	Return

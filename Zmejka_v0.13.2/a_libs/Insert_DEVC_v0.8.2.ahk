#SingleInstance Off
#Persistent
#NoEnv
SetTitleMatchMode, 2
#MaxMem 4095

/*
	Инициализация среды embed (начало)
*/

PyExe := A_ScriptDir "\..\p_embed\pythonw.exe"
PyExeConsole := A_ScriptDir "\..\p_embed\python.exe"

; 	Модули (начало)

Tu_on_u := A_ScriptDir "\..\p_libs\Tu_v0.5.1.cpython-311.pyc"

;	Модули (конец)

;	Проверяем, если передался ли UniqueID в качестве аргумента командной строки
if (A_Args.Length() > 0)
    UniqueID := A_Args[1]
else
{
    MsgBox, UniqueID not provided as an argument.
    ExitApp
}

;	Ждём, пока Флаг поднимется и подтвердит, что UniqueID прочитан
flagPath := A_ScriptDir "\..\inis\flag_" UniqueID ".txt"
Loop
{
    if FileExist(flagPath)
        break
    Sleep, 150 ; Шу-шуть ждём-с
}

;	Теперь считываем UniqueID из INI-файла
UniqueIDinipath := A_ScriptDir "\..\inis\UniqueID_" UniqueID ".ini"
IniRead, UniqueID, %UniqueIDinipath%, UniqueID, UniqueID

if (UniqueID = "ERROR" || UniqueID = "")
{
    MsgBox, Failed to read UniqueID from the INI file.
    ExitApp
}

filePathIni := A_ScriptDir "\..\inis\filePath_" UniqueID ".ini"

Gui, Add, Tab3, x2 y-1 h468 w184 +BackgroundTrans, Главная|АУПТ|
Gui, Tab, Главная
Gui, Add, Text, x12 y19 w160 h30 +Center, Выберите параметр`, воздействующий на ИП ДОТ:
Gui, Add, DropDownList, x12 y59 w160 h120 gQuantity vQuantity, VISIBILITY|EXTINCTION COEFFICIENT|OPTICAL DENSITY|TEMPERATURE
Gui, Add, Text, x12 y109 w160 h40 +Center, Введите высоту помещения`, в котором требуется определить tпор:
Gui, Add, Edit, x62 y159 w80 h20 vHZ, 
Gui, Add, Button, x12 y409 w160 h30 gOkButton, Применить
Gui, Add, Text, x12 y159 w40 h20 , Hпом =
Gui, Add, Text, x152 y159 w20 h20 +Left, м
Gui, Add, Text, x12 y209 w160 h40 +Center, Введите абсолютную отметку пола помещения:
Gui, Add, Edit, x62 y259 w80 h20 vZh, 
Gui, Add, Text, x152 y259 w20 h20 , м
Gui, Add, Text, x12 y259 w40 h20 , Zпом =
Gui, Add, Progress, x12 y89 w160 h10 vQuantityProgressBar cb0077BB, 0
Gui, Add, Progress, x12 y189 w160 h10 vHZProgressBar cbCBCBCB, 100
Gui, Add, Progress, x12 y289 w160 h10 vZhProgressBar cbCBCBCB, 100
Gui, Add, Checkbox, x12 y309 w200 h60 gChckOnlyOne vOnlyOne, Помещение подлежит оборудованию 1 пожарным извещателем
Gui, Add, Edit, x12 y369 w80 h20 vFpom
Gui, Add, Text, x102 y370 , м2
Gui, Tab, АУПТ
Gui, Add, Button, x12 y59 w160 h30 gRunTuonu, Расчёт tобн_инерц

Gui, Show, x130 y134 h468 w184, Insert_DEVC_v0.8.2
Return

ChckOnlyOne:
	Gui, Submit, NoHide
	Return

Quantity:
    GuiControl, , QuantityProgressBar, 100
	Return

OkButton:
    Gui, Submit, NoHide
	
	If (OnlyOne = 1)
	{
		If (Fpom = "")
		{
			MsgBox, % "Введите значение площади помещения"
			Return
		}
		IniWrite, %Fpom%, %A_ScriptDir%\..\inis\IniFpom.ini, IniFpom, Fpom
	}
	IniWrite, %Fpom%, %A_ScriptDir%\..\inis\IniFpom.ini, IniFpom, Fpom
	
    if (Quantity = "")
    {
        MsgBox, % "Выберите значение параметра, воздействующего на ИП ДОТ!"
        Return
    }
    IniWrite, %Quantity%, %A_ScriptDir%\..\inis\IniQuantity.ini, IniQuantity, Quantity
	
    if (HZ = "") || (HZ <= 0)
    {
        MsgBox, % "Введите достоверное значение высоты!"
        Return
    }
    IniWrite, %HZ%, %A_ScriptDir%\..\inis\IniHZ.ini, IniHZ, HZ
    ; MsgBox, % "Параметр: " . Quantity . "`nВысота: " . HZ
	
	if (Zh = "")
    {
        MsgBox, % "Введите достоверное значение высотной отметки!"
        Return
    }
    IniWrite, %Zh%, %A_ScriptDir%\..\inis\IniZh.ini, IniZh, Zh
    ; MsgBox, % "Высота: " . HZ . "`nВысотная отметка: " . Zh
	
    Gui, Hide

    ; Назначаем файлы ввода и вывода
    IniRead, filePath, %filePathIni%, filePath, filePath

    folderPath := RegExReplace(filePath, "(.*\\).*", "$1")
	folderPath := SubStr(folderPath, 1, StrLen(folderPath) - 1)
    fileName := RegExReplace(filePath, ".+\\(.+)$", "$1")
	fileName := SubStr(fileName, 1, StrLen(fileName) - 4)

    inputFile := filePath
	dirName := "_tout"
	newDirPath := folderPath "\" dirName
	;FileCreateDir, %newDirPath%
    ;outputFile := newDirPath "\" fileName "_tout.fds"
	outputFile := folderPath "\" fileName "_tout.fds"
	
    Tooltip, % "inputFile is " inputFile "`noutputFile is " outputFile
	Sleep, 300
	Tooltip

    ; Читаем .fds
    FileRead, fdsContents, %inputFile%

    ; Делим .fds построчно
    StringSplit, lines, fdsContents, `n

    newContents := ""
    meshIndex := 0
    inMeshSection := false

    if (Quantity = "VISIBILITY")
    {
        setpoint := 28.5709
        trip_direction := -1
        IniWrite, %setpoint%, %A_ScriptDir%\..\inis\IniSetpoint.ini, IniSetpoint, setpoint
		
    }
    else if (Quantity = "EXTINCTION COEFFICIENT")
    {
        setpoint := 0.2
        trip_direction := 1
        IniWrite, %setpoint%, %A_ScriptDir%\..\inis\IniSetpoint.ini, IniSetpoint, setpoint
    }
    else if (Quantity = "OPTICAL DENSITY")
    {
        setpoint := 0.023
        trip_direction := 1
        IniWrite, %setpoint%, %A_ScriptDir%\..\inis\IniSetpoint.ini, IniSetpoint, setpoint
    }
	else if (Quantity = "TEMPERATURE")
    {
        setpoint := 58
        trip_direction := 1
        IniWrite, %setpoint%, %A_ScriptDir%\..\inis\IniSetpoint.ini, IniSetpoint, setpoint
    }

    loop, %lines0%
    {
        line := Trim(lines%A_Index%)
        
		if InStr(line, "&HEAD") && InStr(line, "CHID=")
        {
            line := RegExReplace(line, "CHID='([^']*)'", "CHID='`$1_tout'")
        }

        if InStr(line, "&MESH")
        {
            meshIndex++
            inMeshSection := true
            
            if RegExMatch(line, "IJK=(\d+),(\d+),(\d+).*?XB=([-\d\.]+),([-\d\.]+),([-\d\.]+),([-\d\.]+),([-\d\.]+),([-\d\.]+)", match)
            {
                I := match1
                J := match2
                K := match3
                X1 := match4, X2 := match5
                Y1 := match6, Y2 := match7
                Z1 := match8, Z2 := match9
                
                deltaX := (X2 - X1) / I
                deltaY := (Y2 - Y1) / J
                deltaZ := (Z2 - Z1) / K
                
                Z := Round((Round((Zh + HZ - deltaZ), 2)) - (deltaZ / 3) - 0.01, 2)
				IniWrite, %Z%, %A_ScriptDir%\..\inis\IniZ.ini, IniZ, Z
                
                Loop, % I
                {
                    xIndex := A_Index - 1
                    X := X1 + xIndex * deltaX
                    Loop, % J
                    {
                        yIndex := A_Index
                        Y := Y1 + (yIndex - 2) * deltaY
                        
                        actualX := Round(X + deltaX, 2)
                        actualY := Round(Y + deltaY, 2)
                        
                        devcline := "&DEVC ID='DEVC_X" (xIndex + 1) "Y" yIndex "_MESH_" meshIndex "' QUANTITY='" Quantity "' XYZ=" actualX "," actualY "," Z ", " "SETPOINT=" setpoint ", " "TRIP_DIRECTION=" trip_direction "/`n"
                        
                        newContents .= devcline
                    }
                }
            }
        }
        newContents .= line . "`n"
    }
    IniWrite, %deltaZ%, %A_ScriptDir%\..\inis\InideltaZ.ini, InideltaZ, deltaZ
    
    FileAppend, %newContents%, %outputFile%
	
    Tooltip, Успешно! Новый файл создан: %outputFile%
	Sleep, 300
	Tooltip
	
    ExitApp
Return

RunTuonu:
	Run, "%PyExe%" "%Tu_on_u%"
	Return

GuiClose:
    ExitApp
Return

CheckFDSInstallation()
{
    if (FileExist(A_ProgramFiles "\firemodels\FDS6\bin\fds.exe"))
        MsgBox, FDS уже установлен в системе.
    else
	{
		If !(FileExist(A_ScriptDir "\FDS-6.8.0_SMV-6.8.0_win.exe"))
		{
			URLDownloadToFile, https://github.com/firemodels/fds/releases/download/FDS-6.8.0/FDS-6.8.0_SMV-6.8.0_win.exe, FDS-6.8.0_SMV-6.8.0_win.exe
			ToolTip, Downloading FDS...
			Return
		}
		If (FileExist(A_ScriptDir "\FDS-6.8.0_SMV-6.8.0_win.exe"))
		{
			ToolTip, Installing FDS...
			Run, FDS-6.8.0_SMV-6.8.0_win.exe /S
			WinWait, ahk_exe cmd.exe
			Loop,
			{
				IfWinExist, ahk_exe cmd.exe
				{
					WinActivate, ahk_exe cmd.exe
					sleep, 2000
					ControlSend, , yes
					sleep, 50
					ControlSend, , {ENTER 1}
					loop
					{
						Process, Wait, hydra_service.exe
						if ErrorLevel <> 0
						{
							sleep, 2000
							ControlSend, , {ENTER 1}
							Process, Exist, hydra_service.exe
							if ErrorLevel <> 0
								Process, Close, hydra_service.exe
						}
						else
							Continue
					}
					WinWaitClose, ahk_exe cmd.exe
				}
				Break
			}
			Process, WaitClose, ahk_exe FDS-6.8.0_SMV-6.8.0_win.exe

			if (FileExist(A_ProgramFiles "\firemodels\FDS6\bin\fds.exe"))
				MsgBox, FDS has been successfully installed.
			else
				MsgBox, Installation failed.
		}
	}
}


@echo off
setlocal enabledelayedexpansion

:: Get the current PATH
set "currentPath=%PATH%"
set "systemDrive=%SystemDrive%"

:: Directories to add
set "dir1=%systemDrive%\Program Files\Zmejka_v0.12.7"
set "dir2=%systemDrive%\Program Files\Zmejka_v0.12.7\FDS5"
set "dir3=%systemDrive%\Program Files\Zmejka_v0.12.7\FDS5\dll"

set "dir4=%systemDrive%\Program Files\Zmejka"
set "dir5=%systemDrive%\Program Files\Zmejka\FDS5"
set "dir6=%systemDrive%\Program Files\Zmejka\FDS5\dll"

set "dir7=%systemDrive%\Program Files\ZmejkaFDS"
set "dir8=%systemDrive%\Program Files\ZmejkaFDS\FDS5"
set "dir9=%systemDrive%\Program Files\ZmejkaFDS\FDS5\dll"

:: Check if the directory is already in PATH
echo !currentPath! | find /i "%dir1%" >nul || set "newPath=!dir1!;!currentPath!"
echo !currentPath! | find /i "%dir2%" >nul || set "newPath=!dir2!;!newPath!"
echo !currentPath! | find /i "%dir3%" >nul || set "newPath=!dir3!;!newPath!"

echo !currentPath! | find /i "%dir4%" >nul || set "newPath=!dir1!;!currentPath!"
echo !currentPath! | find /i "%dir5%" >nul || set "newPath=!dir2!;!newPath!"
echo !currentPath! | find /i "%dir6%" >nul || set "newPath=!dir3!;!newPath!"

echo !currentPath! | find /i "%dir7%" >nul || set "newPath=!dir1!;!currentPath!"
echo !currentPath! | find /i "%dir8%" >nul || set "newPath=!dir2!;!newPath!"
echo !currentPath! | find /i "%dir9%" >nul || set "newPath=!dir3!;!newPath!"

:: Set the new PATH value
if defined newPath (
    echo Updating PATH...
    setx PATH "!newPath!"
    echo PATH updated successfully.
    echo Restart you computer for changes to be applied.
) else (
    echo Directories are already in the PATH.
)

endlocal
pause

@echo off
setlocal EnableDelayedExpansion


REM Check if the script was placed correctly.

if not exist "%~dp0SquareEnix\FINAL FANTASY XI\FFXi.dll" (goto wrongLocation) else (goto correctLocation)

:wrongLocation
    echo An FFXI installation was not detected here.
    echo NOTE: Make sure this .bat file is located just outside the \SquareEnix\ directory for the install you wish to play on.
    echo Example:
    echo C:\Games\PlayOnline\
    echo ÃÄÄ C:\Games\PlayOnline\SquareEnix\
    echo ³   ÃÄÄ C:\Games\PlayOnline\SquareEnix\FINAL FANTASY XI\
    echo ³   ÀÄÄ C:\Games\PlayOnline\SquareEnix\PlayOnlineViewer\
    echo ÀÄÄ C:\Games\PlayOnline\Switch.bat
    pause
    exit

:correctLocation

REM Admin script copied from Bed Gripka and dbenham from stackoverflow.com

:: BatchGotAdmin
:-------------------------------------
REM  --> Check for permissions
if "%PROCESSOR_ARCHITECTURE%" EQU "amd64" (
>nul 2>&1 "%SYSTEMROOT%\SysWOW64\cacls.exe" "%SYSTEMROOT%\SysWOW64\config\system"
) else (
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
)

REM --> If error flag set, we do not have admin.
if '%errorlevel%' NEQ '0' (
    echo Requesting administrative privileges...
    goto UACPrompt
) else ( goto haveAdmin )

:UACPrompt

echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
set params= %*
echo UAC.ShellExecute "cmd.exe", "/c ""%~f0"" %params:"=""%", "", "runas", 1 >> "%temp%\getadmin.vbs"

"%temp%\getadmin.vbs"
del "%temp%\getadmin.vbs"
exit /B

:haveAdmin

pushd "%CD%"
cd /D "%~dp0"

REM reg and regsvr32 updates based on Eden's Switch.bat

echo Administrative permissions confirmed and FFXI installation detected.
echo. 
echo This .bat will now update Windows registry settings and libraries to this installation.

if "%PROCESSOR_ARCHITECTURE%"=="x86" (set architecture=) else (set architecture=\WOW6432Node)

@echo on

reg add "HKLM\SOFTWARE%architecture%\PlayOnlineUS\InstallFolder" /v 0001 /d "%~dp0SquareEnix\FINAL FANTASY XI" /f
reg add "HKLM\SOFTWARE%architecture%\PlayOnlineUS\InstallFolder" /v 0002 /d "%~dp0SquareEnix\TetraMaster" /f
reg add "HKLM\SOFTWARE%architecture%\PlayOnlineUS\InstallFolder" /v 1000 /d "%~dp0SquareEnix\PlayOnlineViewer" /f

regsvr32 /s "%~dp0SquareEnix\FINAL FANTASY XI\FFXi.dll"
regsvr32 /s "%~dp0SquareEnix\FINAL FANTASY XI\FFXiMain.dll"
regsvr32 /s "%~dp0SquareEnix\FINAL FANTASY XI\FFXiVersions.dll"
regsvr32 /s "%~dp0SquareEnix\PlayOnlineViewer\viewer\com\app.dll"
regsvr32 /s "%~dp0SquareEnix\PlayOnlineViewer\viewer\com\polcore.dll"
regsvr32 /s "%~dp0SquareEnix\PlayOnlineViewer\viewer\contents\polcontentsINT.dll"
regsvr32 /s "%~dp0SquareEnix\PlayOnlineViewer\viewer\contents\PolContents.dll"
regsvr32 /s "%~dp0SquareEnix\PlayOnlineViewer\viewer\ax\polmvfINT.dll"
regsvr32 /s "%~dp0SquareEnix\PlayOnlineViewer\viewer\ax\polmvf.dll"

@echo off

pause
rem ----------------------------------------------------------
rem Dieses File löscht den bestehenden Output-Ordner,
rem generiert den Output-Ordner neu und packt das Altium-Projekt
rem in ein Zip-File.
rem
rem Benno Zemp, Komax AG, 24.11.2015
rem Jonas Müller, Komax AG, 06.12.2016
rem -----------------------------------------------------------

ECHO ON

%=speichere Start-Pfad (Programm-Pfad von Altium)=%
set ORIGINAL_PATH=%CD%
%=speichere Projekt-Pfad = Ort dieses Batch-Files=%
set PROJ_PATH=%~dp0..\

rem save batch-parameters
set FILES_PATH=%1
set ARCHIVE_PROJ=%2
set ARCHIVE_NAME=%3

rem remove '"'
set FILES_PATH=%FILES_PATH:~1,-1%
set ARCHIVE_PROJ=%ARCHIVE_PROJ:~1,-1%
set ARCHIVE_NAME=%ARCHIVE_NAME:~1,-1%

echo.%PROJ_PATH%
echo.%FILES_PATH%
echo.%ARCHIVE_PROJ%
echo.%ARCHIVE_NAME%

cd /D "%PROJ_PATH%"			%=springe in den Projekt-Pfad=%

%=Delete all subfolder=%
rmdir /S /Q "%FILES_PATH%"

set OutputFolder=%ARCHIVE_NAME%

%=Collect altium project data=%
md "%FILES_PATH%\%ARCHIVE_PROJ%\%ARCHIVE_NAME%"
copy "%PROJ_PATH%" "%FILES_PATH%\%ARCHIVE_PROJ%\%ARCHIVE_NAME%"								%=Copy files without subfolders=%

md "%FILES_PATH%\%ARCHIVE_PROJ%\%ARCHIVE_NAME%\3D\"
copy "%PROJ_PATH%\3D\" "%FILES_PATH%\%ARCHIVE_PROJ%\%ARCHIVE_NAME%\3D\"
md "%PROJ_PATH%\AdditionalData\"
md "%FILES_PATH%\%ARCHIVE_PROJ%\%ARCHIVE_NAME%\AdditionalData\"
copy "%PROJ_PATH%\AdditionalData\" "%FILES_PATH%\%ARCHIVE_PROJ%\%ARCHIVE_NAME%\AdditionalData\"
md "%FILES_PATH%\%ARCHIVE_PROJ%\%ARCHIVE_NAME%\Documents\"
copy "%PROJ_PATH%\Documents\" "%FILES_PATH%\%ARCHIVE_PROJ%\%ARCHIVE_NAME%\Documents\"
md "%FILES_PATH%\%ARCHIVE_PROJ%\%ARCHIVE_NAME%\Libraries\"
copy "%PROJ_PATH%\Libraries\" "%FILES_PATH%\%ARCHIVE_PROJ%\%ARCHIVE_NAME%\Libraries\"
md "%FILES_PATH%\%ARCHIVE_PROJ%\%ARCHIVE_NAME%\Templates\"
copy "%PROJ_PATH%\Templates\" "%FILES_PATH%\%ARCHIVE_PROJ%\%ARCHIVE_NAME%\Templates\"
md "%FILES_PATH%\%ARCHIVE_PROJ%\%ARCHIVE_NAME%\Tools\"
copy "%PROJ_PATH%\Tools\" "%FILES_PATH%\%ARCHIVE_PROJ%\%ARCHIVE_NAME%\Tools\"
md "%FILES_PATH%\%ARCHIVE_PROJ%\%ARCHIVE_NAME%\Tools\7-Zip\"
copy "%PROJ_PATH%\Tools\7-Zip\" "%FILES_PATH%\%ARCHIVE_PROJ%\%ARCHIVE_NAME%\Tools\7-Zip\"
md "%FILES_PATH%\%ARCHIVE_PROJ%\%ARCHIVE_NAME%\Tools\7-Zip\Lang\"
copy "%PROJ_PATH%\Tools\7-Zip\Lang\" "%FILES_PATH%\%ARCHIVE_PROJ%\%ARCHIVE_NAME%\Tools\7-Zip\Lang\"

rem -----------------------------------------------------------
rem  Altium Project
rem -----------------------------------------------------------

cd /D "%PROJ_PATH%"         %=springe in den Projekt-Pfad=%

del "%OutputFolder%.zip"
rem Cleanup
del "%FILES_PATH%\%ARCHIVE_PROJ%\%ARCHIVE_NAME%\Status Report.Txt"

ECHO ON
IF EXIST "%FILES_PATH%\%ARCHIVE_PROJ%\" (
	%PROJ_PATH%Tools\7-Zip\7z.exe a "%FILES_PATH%\%OutputFolder%.zip" "%FILES_PATH%\%ARCHIVE_PROJ%\*" -xr!*Preview* -xr!*viewstate* -xr!*.htm -xr!History -xr!*.TLT -xr!*.scc
)
ECHO OFF

rem -----------------------------------------------------------

rmdir /S /Q "%FILES_PATH%\%ARCHIVE_PROJ%"

cd /D "%ORIGINAL_PATH%"     %=springe zurück Start-Pfad (Programm-Pfad von Altium)=%

rem pause

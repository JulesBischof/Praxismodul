rem ----------------------------------------------------------
rem Dieses File sammelt alle generierten Altium-Files zusammen
rem und fügt sie in ein Assembly- und ein PCB-ZIP-File ein
rem 
rem Benno Zemp, Komax AG, 24.11.2015
rem Jonas Müller, Komax AG, 06.12.2016
rem -----------------------------------------------------------

ECHO ON

rem speichere Start-Pfad (Programm-Pfad von Altium)
set ORIGINAL_PATH=%CD%
rem speichere Projekt-Pfad = Ort dieses Batch-Files
set PROJ_PATH=%~dp0..\

rem save batch-parameters
set FILES_PATH=%1
set ARCHIVE_ASSY=%2
set ARCHIVE_PCB=%3

rem remove '"'
set FILES_PATH=%FILES_PATH:~1,-1%
set ARCHIVE_ASSY=%ARCHIVE_ASSY:~1,-1%

rem -----------------------------------------------------------
rem  Assembly
rem -----------------------------------------------------------

cd /D "%PROJ_PATH%"		%=springe in den Projekt-Pfad=%
cd "%FILES_PATH%"		%=springe in den Pfad der generierten Files%

rem Ordner, welcher dem ZIP-File zugefügt werden soll
set OutputFolder=%ARCHIVE_ASSY%
for /F "delims=" %%a in ('dir "%ARCHIVE_ASSY%" /b /o:n /a:d') do (
   set OutputFolder=%%a
)

rem Copy additional data
md "%FILES_PATH%\%ARCHIVE_ASSY%"
for /F "delims=" %%a in ('dir "%ARCHIVE_ASSY%\%OutputFolder%" /b /o:n /a:d') do (
   set OutputSubFolder=%%a
)
md "%FILES_PATH%\%ARCHIVE_ASSY%\%OutputFolder%\%OutputSubFolder%\AdditionalData\"
copy "..\AdditionalData\" "%FILES_PATH%\%ARCHIVE_ASSY%\%OutputFolder%\%OutputSubFolder%\AdditionalData\"

del "%OutputFolder%.zip"

IF EXIST ".\%ARCHIVE_ASSY%\%OutputFolder%\" (
	%PROJ_PATH%Tools\7-Zip\7z.exe a "%OutputFolder%.zip" ".\%ARCHIVE_ASSY%\%OutputFolder%\*"
)

rem -----------------------------------------------------------

rmdir /S /Q "%ARCHIVE_ASSY%"

cd /D "%ORIGINAL_PATH%"	%=springe zurück Start-Pfad (Programm-Pfad von Altium)=%

rem pause

@echo off
rem 2021-02-13 Sukri Created.

rem script name.
set "script_name=Install-Application.ps1"

rem script directory.
set "script_directory=%~dp0\Scripts\"

rem execute PS1 script.
powershell -executionpolicy bypass -file "%script_directory%%script_name%"

rem pause, press any key to exit.
pause
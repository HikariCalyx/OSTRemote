@echo off
setlocal enabledelayedexpansion
set errorparse=0
cd /d "%fwfilepath%"
if exist qlzout rd /s /q qlzout
mkdir qlzout
cd qlzout
SET fwfile="%fwfile%"
SET fwfile=%fwfile:"=%
echo %fwfile%| sed "s/ /\" \"/g" > %temp%\spacepath.txt
set /p quotefwfile=<%temp%\spacepath.txt
echo.
echo %t0076%
echo.
if "%verbose_mode%"=="0" (
exdupe -R %quotefwfile% . 2>nul
) else (
exdupe -R %quotefwfile% .
)
dir /b *.mlf > %temp%\mlffile.txt
goto eof

:eof
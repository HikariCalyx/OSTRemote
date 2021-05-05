@echo off
setlocal enabledelayedexpansion
set errorparse=0
python --version | findstr 3. > nul
if not %errorlevel%==0 goto error_python_not_installed
cd /d "%fwfilepath%"
if exist nb0out rd /s /q nb0out
mkdir nb0out
cd nb0out
SET fwfile="%fwfile%"
SET fwfile=%fwfile:"=%
echo %fwfile%| sed "s/ /\" \"/g" > %temp%\spacepath.txt
set /p quotefwfile=<%temp%\spacepath.txt
echo.
echo %t0075%
echo.
if "%verbose_mode%"=="0" (
nb0-unpack.py %quotefwfile% > nul
) else (
nb0-unpack.py %quotefwfile%
)
dir /b *.mlf > %temp%\mlffile.txt
goto eof

:error_python_not_installed
echo no > %temp%\nopython
echo.
goto eof

:eof
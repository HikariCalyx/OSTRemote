:retry_sec8v
echo %z0001%
echo %t0007%%secver%
echo %t0004%%sn%

:Defining Project Code
fb2 oem getProjectCode 2>&1 | findstr getProjectCode > %temp%\prjcode.txt
For /f "tokens=1* delims= " %%A in ( %temp%\prjcode.txt ) Do set prjcode=%%B
del %temp%\prjcode.txt
echo %t0006%%prjcode%

:Defining Brand Code
fb2 oem getBrandCode 2>&1 | findstr getBrandCode > %temp%\brandcode.txt
For /f "tokens=1* delims= " %%A in ( %temp%\brandcode.txt ) Do set brandcode=%%B
del %temp%\brandcode.txt
echo %t0026%%brandcode%

:Defining Veracity Challenge Code
fb2 oem dm-veracity 2>&1 | findstr veracity > %temp%\veracity.txt
For /f "tokens=1* delims= " %%A in ( %temp%\veracity.txt ) Do set veracity=%%B
del %temp%\veracity.txt
echo %t0041% %veracity%
echo %z0002%
echo.

:Input_Encoding_MSG
set challenge=
set /p challenge=%z0003%
if not defined challenge goto Input_Encoding_MSG
echo %challenge% > %temp%\rawbase64.txt
set challenge=pass
>nul certutil -f -decode %temp%\rawbase64.txt %temp%\veracity_sec8-%brandcode%-%prjcode%-%sn%-%veracity%.bin
del rawbase64.txt
fb2 flash veracity %temp%\veracity_sec8-%brandcode%-%prjcode%-%sn%-%veracity%.bin 2>&1 | findstr FAILED > nul
if %errorlevel%==0 (
echo %t0043%
pause>nul
goto retry_sec8v
)
del %temp%\veracity_sec8-%brandcode%-%prjcode%-%sn%-%veracity%.bin
echo %t0053%
goto EOF

:EOF
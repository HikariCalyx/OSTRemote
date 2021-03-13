:Defining Project Code
fb2 oem getProjectCode 2>&1 | findstr getProjectCode > prjcode.txt
For /f "tokens=1* delims= " %%A in ( prjcode.txt ) Do set prjcode=%%B
del prjcode.txt
echo %t0021% %prjcode%

:Defining Veracity Challenge Code
fb2 oem dm-veracity 2>&1 | findstr veracity > veracity.txt
For /f "tokens=1* delims= " %%A in ( veracity.txt ) Do set veracity=%%B
del veracity.txt
echo %t0022% %veracity%
echo %t0036%
echo.

:Input_Encoding_MSG
set /p challenge=%t0003%
echo %challenge% > rawbase64.txt
set challenge=pass
>nul certutil -f -decode rawbase64.txt veracity.bin
fb2 flash veracity veracity.bin 2>&1 | findstr FAILED > nul
if %errorlevel%==0 set challenge=fail
del veracity.bin
goto EOF

:EOF
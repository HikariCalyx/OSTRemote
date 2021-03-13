:Defining Project Code
fb2 oem getProjectCode 2>&1 | findstr getProjectCode > prjcode.txt
For /f "tokens=1* delims= " %%A in ( prjcode.txt ) Do set prjcode=%%B
del prjcode.txt
echo %t0021% %prjcode%

:Defining UID
fb2 oem getUID 2>&1 | findstr getUID > uid.txt
For /f "tokens=1* delims= " %%A in ( uid.txt ) Do set uid=%%B
del uid.txt
echo %t0025% %uid%
echo %t0036%
echo.

:Input_Encoding_MSG
set /p challenge=%t0003%
echo %challenge% > rawbase64.txt
set challenge=pass
>nul certutil -f -decode rawbase64.txt encuid.bin
del rawbase64.txt
fb2 flash encUID encuid.bin 2>&1 | findstr FAILED > nul
if %errorlevel%==0 set challenge=fail
fb2 oem selectKey service %no_verbose:~1,-1%
fb2 oem doKeyVerify %no_verbose:~1,-1%
fb2 oem allport %no_verbose:~1,-1%
goto EOF

:EOF

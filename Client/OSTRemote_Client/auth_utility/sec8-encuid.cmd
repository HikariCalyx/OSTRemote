:retry_sec8u
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

:Defining UID
fb2 oem getUID 2>&1 | findstr getUID > %temp%\uid.txt
For /f "tokens=1* delims= " %%A in ( %temp%\uid.txt ) Do set uid=%%B
del %temp%\uid.txt
echo %t0042% %uid%
echo %z0002%
echo.

:Input_Encoding_MSG
if exist %temp%\encuid_sec8-%brandcode%-%prjcode%-%sn%-%uid%.bin (
echo %t0054%
goto reuse
)
set challenge=
set /p challenge=%z0003%
if not defined challenge goto Input_Encoding_MSG
echo %challenge% > %temp%\rawbase64.txt
set challenge=pass
>nul certutil -f -decode %temp%\rawbase64.txt %temp%\encuid_sec8-%brandcode%-%prjcode%-%sn%-%uid%.bin
del %temp%\rawbase64.txt
:reuse
fb2 flash encUID %temp%\encuid_sec8-%brandcode%-%prjcode%-%sn%-%uid%.bin 2>&1 | findstr FAILED > nul
fb2 oem selectKey service 2>nul
fb2 oem doKeyVerify 2>&1 | findstr FAILED > nul
if %errorlevel%==0 (
echo %t0043%
pause>nul
del %temp%\encuid_sec8-%brandcode%-%prjcode%-%sn%-%uid%.bin
goto retry_sec8u
)
fb2 oem allport 2>nul
echo %t0053%
goto EOF

:EOF
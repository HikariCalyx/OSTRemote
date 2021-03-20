for /f "tokens=1* delims=," %%a in ( %temp%\servicebootloader.txt ) do (
echo Executing "Fastboot %%b"...
fastboot %%b 2>tmpout.txt
if %verbose_mode%==1 type tmpout.txt
)
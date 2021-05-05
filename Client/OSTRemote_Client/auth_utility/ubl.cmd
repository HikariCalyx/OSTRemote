setlocal enabledelayedexpansion
set normallock=1
set criticallock=1
set lockcnt=9
set dtype=unknown
::BootloaderUnlockJudgement
findstr "lk" %temp%\servicebootloader.txt > nul
if %errorlevel%==0 set dtype=mtk
findstr "xbl" %temp%\servicebootloader.txt > nul
if %errorlevel%==0 set dtype=sdm660
findstr "xbl gpt_both1" %temp%\regular.txt > nul
if %errorlevel%==0 set dtype=sdm835
findstr "aboot" %temp%\servicebootloader.txt > nul
if %errorlevel%==0 set dtype=msm8937
findstr "aboot_a" %temp%\servicebootloader.txt > nul
if %errorlevel%==0 set dtype=msm8937us
findstr "xbl_config" %temp%\servicebootloader.txt > nul
if %errorlevel%==0 set dtype=sdm845

if "%dtype%"=="unknown" goto error_unknown
if "%dtype%"=="sdm845" goto error_unsupported_pnx
if "%dtype%"=="mtk" goto unlockscheme_mtk
if "%dtype%"=="sdm660" goto unlockscheme_sdm660-835
if "%dtype%"=="sdm835" goto unlockscheme_sdm660-835
if "%dtype%"=="msm8937" goto unlockscheme_msm8937
if "%dtype%"=="msm8937us" goto unlockscheme_msm8937us

if not "%dtype%"=="mtk" (
fastboot oem device-info 2>%temp%\unlockstate.txt
findstr /C:"Device unlocked" %temp%\unlockstate.txt|>nul findstr false
if %errorlevel%==1 set normallock=0
findstr /C:"Device critical unlocked" %temp%\unlockstate.txt|>nul findstr false
if %errorlevel%==1 set criticallock=0
>nul set /a lockcnt=!normallock!+!criticallock!
)

:unlockscheme_mtk
if "%verbose_mode%"=="1" (
call :MTKFlashingUnlock_Verbose
) else (
call :MTKFlashingUnlock
)
goto eof

:unlockscheme_sdm660-835
if "%verbose_mode%"=="1" (
call :MTKFlashingUnlock_Verbose
) else (
call :MTKFlashingUnlock
)
goto eof



:CriticalUnlock_Verbose
fastboot oem fih on
fastboot oem devlock allow_unlock
fastboot flashing unlock_critical
if not %errorlevel%==0 goto unlock-go
if not "%dtype%"=="msm8937" echo %t0009%
if not "%dtype%"=="msm8937" echo %t0010%
:loop1_fcuv
devcon_%osarch% find USB* | findstr %sn% > nul
if %errorlevel%==0 goto loop1_fcuv
echo %t0011%
goto :eof

:UnlockGo_Verbose
fastboot oem fih on
fastboot oem devlock allow_unlock
fastboot oem unlock-go
if not %errorlevel%==0 goto unlocked
if not "%dtype%"=="msm8937" echo %t0009%
if not "%dtype%"=="msm8937" echo %t0010%
:loop2_ugov
devcon_%osarch% find USB* | findstr %sn% > nul
if %errorlevel%==0 goto loop2_ugov
echo %t0012%
pause>nul
goto :eof

:FlashingUnlock_Verbose
fastboot oem fih on
fastboot oem devlock allow_unlock
fastboot flashing unlock
if not %errorlevel%==0 goto unlocked
if not "%dtype%"=="msm8937" echo %t0009%
if not "%dtype%"=="msm8937" echo %t0010%
:loop2_funv
devcon_%osarch% find USB* | findstr %sn% > nul
if %errorlevel%==0 goto loop2_funv
echo %t0012%
pause>nul
goto :eof

:MTKFlashingUnlock_Verbose
fastboot oem fih on
fastboot oem devlock allow_unlock
echo %t0009%
echo %t0010%
fastboot flashing unlock
if not %errorlevel%==0 goto unlocked
:loop2_funv
devcon_%osarch% find USB* | findstr %sn% > nul
if %errorlevel%==0 goto loop2_funv
echo %t0012%
pause>nul
goto :eof

:CriticalUnlock
fastboot oem fih on 2>nul
fastboot oem devlock allow_unlock 2>nul
fastboot flashing unlock_critical 2>nul
if not %errorlevel%==0 goto unlock-go
if not "%dtype%"=="msm8937" echo %t0009%
if not "%dtype%"=="msm8937" echo %t0010%
:loop1_fcuv
devcon_%osarch% find USB* | findstr %sn% > nul
if %errorlevel%==0 goto loop1_fcuv
echo %t0011%
goto :eof

:UnlockGo
fastboot oem fih on 2>nul
fastboot oem devlock allow_unlock 2>nul
fastboot oem unlock-go 2>nul
if not %errorlevel%==0 goto unlocked
if not "%dtype%"=="msm8937" echo %t0009%
if not "%dtype%"=="msm8937" echo %t0010%
:loop2_ugov
devcon_%osarch% find USB* | findstr %sn% > nul
if %errorlevel%==0 goto loop2_ugov
echo %t0012%
pause>nul
goto :eof

:FlashingUnlock
fastboot oem fih on 2>nul
fastboot oem devlock allow_unlock 2>nul
fastboot flashing unlock 2>nul
if not %errorlevel%==0 goto unlocked
if not "%dtype%"=="msm8937" echo %t0009%
if not "%dtype%"=="msm8937" echo %t0010%
:loop2_funv
devcon_%osarch% find USB* | findstr %sn% > nul
if %errorlevel%==0 goto loop2_funv
echo %t0012%
pause>nul
goto :eof

:MTKFlashingUnlock
fastboot oem fih on 2>nul
fastboot oem devlock allow_unlock 2>nul
echo %t0009%
echo %t0010%
fastboot flashing unlock 2>nul
if not %errorlevel%==0 goto unlocked
:loop2_funv
devcon_%osarch% find USB* | findstr %sn% > nul
if %errorlevel%==0 goto loop2_funv
echo %t0012%
pause>nul
goto :eof

:eof
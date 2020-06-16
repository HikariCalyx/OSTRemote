@echo off
title Bootloader 解锁工具
cls
echo.
echo.
echo 你好！本工具用于诺基亚 HMD 安卓 / 夏普 AQUOS 部分机型
echo 的 Bootloader 解锁。
echo.
echo 本脚本由 Hikari Calyx 编写，并适用于以下机型：
echo Nokia 2, Nokia 5, Nokia 6, Nokia 6.1,
echo Nokia 6.1 Plus X6, Nokia 7, Nokia 7 Plus, Nokia 8,
echo Sharp Aquos S2 C10, Sharp Aquos S3mini, Sharp Aquos S3
echo.
echo.解锁后数据将被清空。
echo.
echo 请按任意键开始操作。
pause>nul
if not exist fastboot.exe goto errorx
if not exist adbwinapi.dll goto errorx
if not exist adbwinusbapi.dll goto errorx
echo.
echo 请将手机关机接入电脑，或是将手机置入 Download mode 后接入电脑
fastboot oem alive>nul
fastboot devices > tmp.txt
set /p devsn=<tmp.txt
echo %devsn:~0,16% > tmp.txt
set /p devsn=<tmp.txt
fb2 oem getProjectCode 2>&1|findstr getProjectCode>tmp.txt
For /f "tokens=2* delims= " %%A in ( tmp.txt ) Do set actprojectcode=%%A
fb2 oem getSecurityVersion 2>&1|findstr getSecurityVersion>tmp.txt
For /f "tokens=2* delims= " %%A in ( tmp.txt ) Do set secver=%%A
del tmp.txt
:selection
set normallock=0
set criticallock=0
set sel=
set econfirm=
cls
echo.
echo 您手机的序列号是 %devsn:~0,16%。
if "%actprojectcode:~0,3%"=="FRT" echo 机型是 Nokia 1。
if "%actprojectcode:~0,3%"=="ANT" echo 机型是 Nokia 1 Plus。
if "%actprojectcode:~0,3%"=="E1M" echo 机型是 Nokia 2。
if "%actprojectcode:~0,3%"=="E2M" echo 机型是 Nokia 2.1。
if "%actprojectcode:~0,3%"=="EVW" echo 机型是 Nokia 2.1 V。
if "%actprojectcode:~0,3%"=="NE1" echo 机型是 Nokia 3。
if "%actprojectcode:~0,3%"=="ES2" echo 机型是 Nokia 3.1。
if "%actprojectcode:~0,3%"=="EAG" echo 机型是 Nokia 3.1 A & C。
if "%actprojectcode:~0,3%"=="ROO" echo 机型是 Nokia 3.1 Plus。
if "%actprojectcode:~0,3%"=="RHD" echo 机型是 Nokia 3.1 Plus C。
if "%actprojectcode:~0,3%"=="ND1" echo 机型是 Nokia 5。
if "%actprojectcode:~0,3%"=="CO2" echo 机型是 Nokia 5.1。
if "%actprojectcode:~0,3%"=="PDA" echo 机型是 Nokia 5.1 Plus X5。
if "%actprojectcode:~0,3%"=="D1C" echo 机型是 Nokia 6。
if "%actprojectcode:~0,3%"=="PLE" echo 机型是 Nokia 6。
if "%actprojectcode:~0,3%"=="PL2" echo 机型是 Nokia 6.1。
if "%actprojectcode:~0,3%"=="DRG" echo 机型是 Nokia 6.1 Plus X6。
if "%actprojectcode:~0,3%"=="C1N" echo 机型是 Nokia 7。
if "%actprojectcode:~0,3%"=="B2N" echo 机型是 Nokia 7 Plus。
if "%actprojectcode:~0,3%"=="CTL" echo 机型是 Nokia 7.1。
if "%actprojectcode:~0,3%"=="TAS" echo 机型是 Nokia X71。
if "%actprojectcode:~0,3%"=="NB1" echo 机型是 Nokia 8。
if "%actprojectcode:~0,3%"=="A1N" echo 机型是 Nokia 8 Sirocco。
if "%actprojectcode:~0,3%"=="PNX" echo 机型是 Nokia 8.1 X7。
if "%actprojectcode:~0,3%"=="AOP" echo 机型是 Nokia 9 PureView。
if "%actprojectcode:~0,3%"=="SS2" echo 机型是 Sharp Aquos S2 C10。
if "%actprojectcode:~0,3%"=="SAT" echo 机型是 Sharp Aquos S2 SDM660。
if "%actprojectcode:~0,3%"=="SG1" echo 机型是 Sharp Aquos S3 mini。
if "%actprojectcode:~0,3%"=="HH1" echo 机型是 Sharp Aquos S3 D10。
if "%actprojectcode:~0,3%"=="SD1" echo 机型是 Sharp Aquos S3 SDM660。
echo 开发代号是 %actprojectcode:~0,3%。
if "%actprojectcode:~3,1%"=="1" (
echo.
echo.警告：检测到已安装后续更新。可能需要申请降级服务。
)
if "%secver%"=="0008" (
echo.
echo.警告：检测到0x8新版安全机制。需要使用远程解锁服务。
)
echo.
echo.请选择您需要的模式：
echo. 1. 解锁
echo  2. 切换槽位
echo  3. 回锁
echo  4. 将手机重启到正常模式并关闭此工具
echo  5. 将手机关机并关闭此工具
echo.
set /p sel=请输入序号后，按回车键确定：
if "%sel%"=="1" goto no1
if "%sel%"=="2" goto no2
if "%sel%"=="3" goto no3
if "%sel%"=="4" goto no4
if "%sel%"=="5" goto no5
goto selection

:no1
cls
cls
echo.
echo.您手机的序列号是 %devsn:~0,16%。
echo 请将解锁码文件放置在和该解锁脚本同一目录下，支持的解锁码文件名为：
echo %devsn:~0,16%.bin 或 unlock.bin 或 unlock.key
echo.
echo 放置完成之后请按任意键继续。
pause>nul
if exist %devsn:~0,16%.bin set unlockkey=%devsn:~0,16%.bin
if exist unlock.bin set unlockkey=unlock.bin
if exist unlock.key set unlockkey=unlock.key
if "%unlockkey%"=="" goto errornokey
echo.
echo 已发现解锁码文件 %unlockkey%。
echo.您确定要解锁吗？如果确定，请输入小写 yes 后按 Enter 键确定。
echo.
echo 输入其它内容或不输入后，按 Enter 键确定将回到主菜单。
echo.
echo.
set /p econfirm=
if "%econfirm%"=="yes" goto next1
goto selection

:next1
cls
echo.
if "%errorlevel%"=="1" goto errorunexpect
:UBLK2
fastboot oem alive
echo.
echo 正在检查当前解锁状态……
echo.
fastboot oem device-info 2>&1|>nul findstr /C:"Too many links"
if %errorlevel%==0 goto usbthrottling
fastboot oem device-info 2>&1|findstr unlocked>unlockstate.txt
findstr /C:"Device unlocked" unlockstate.txt|>nul findstr false
if %errorlevel%==1 set normallock=0
findstr /C:"Device critical unlocked" unlockstate.txt|>nul findstr false
if %errorlevel%==1 set criticallock=0
>nul set /a lockcnt=%normallock%+%criticallock%
if %lockcnt%==0 goto next4
if exist unlock.key set unlockkey=unlock.key
echo.
echo 正在解锁，请稍等...
fastboot flash unlock %unlockkey% 2>stdout.txt
if %errorlevel%==1 goto errorunlock
if %normallock%==1 fastboot oem unlock-go
if %criticallock%==1 fastboot flashing unlock_critical
if "%actprojectcode:~0,3%"=="E1M" goto next2
if "%actprojectcode:~0,3%"=="D1A" goto next2
if "%actprojectcode:~0,3%"=="D1L" goto next2
if "%actprojectcode:~0,3%"=="ND1" goto next2
if "%actprojectcode:~0,3%"=="D1C" goto next2
if "%actprojectcode:~0,3%"=="D1T" goto next2
if "%actprojectcode:~0,3%"=="PLE" goto next2
echo 请注意看手机屏幕的提示。使用音量键选择 UNLOCK THE BOOTLOADER (或 Yes) 后，
echo 电源键确定。
echo.
echo 操作完成之后，请按任意键继续。
pause>nul
goto next3
:next2
ping 127.0.0.1>nul
:next3
echo 等待手机重启中...
goto UBLK2
:next4
echo.
echo 恭喜！至此解锁完成。请按任意键退出。
pause>nul
goto EOF

:no2
cls
echo.
fastboot getvar current-slot 2>%temp%\cslot.txt
set /p cslot=<%temp%\cslot.txt
del %temp%\cslot.txt
if "%cslot%"=="current-slot: " (
echo 错误：此机型不支持切换槽位。
echo 请按任意键返回菜单。
pause>nul
goto selection
)
if "%cslot%"=="current-slot: a" (
fastboot --set-active=b
) else (
fastboot --set-active=a
)
echo 请检查槽位是否切换正确后，按 Enter 键返回到主菜单。
pause>nul
goto selection

:no3
cls
echo.
echo.注意！
echo 除非保修需要，否则我们强烈不推荐回锁！
echo.
echo 如果您一定要回锁，请务必刷回原厂系统后回锁。
echo.
if "%actprojectcode%%secver%"=="NB110004" goto next6
if "%actprojectcode:~3,1%"=="1" (
echo 回锁后将无法重新解锁。
)
:next6
echo.
echo.您确定要回锁吗？如果确定，请输入小写 yes 后按 Enter 键确定。
echo.
echo 输入其它内容或不输入后 Enter 键确定将回到主菜单。
echo.
echo.
set /p econfirm=
if "%econfirm%"=="yes" goto RBLK2
goto selection

:RBLK2
echo.
echo 正在检查解锁状态...
echo.
fastboot oem device-info 2>&1|>nul findstr /C:"Too many links"
if %errorlevel%==0 goto usbthrottling
fastboot oem device-info 2>&1|findstr unlocked>unlockstate.txt
findstr /C:"Device unlocked" unlockstate.txt|>nul findstr true
if %errorlevel%==1 set normallock=1
findstr /C:"Device critical unlocked" unlockstate.txt|>nul findstr true
if %errorlevel%==1 set criticallock=1
>nul set /a lockcnt=%normallock%+%criticallock%
if %lockcnt%==2 goto next10
echo.
echo 正在回锁，请稍等...
if %normallock%==0 fastboot flashing lock
if %criticallock%==0 fastboot flashing lock_critical
if "%actprojectcode:~0,3%"=="E1M" goto next8
if "%actprojectcode:~0,3%"=="D1A" goto next8
if "%actprojectcode:~0,3%"=="D1L" goto next8
if "%actprojectcode:~0,3%"=="ND1" goto next8
if "%actprojectcode:~0,3%"=="D1C" goto next8
if "%actprojectcode:~0,3%"=="D1T" goto next8
if "%actprojectcode:~0,3%"=="PLE" goto next8
echo 请注意看手机屏幕的提示。使用音量键选择 LOCK THE BOOTLOADER (或 Yes) 后，
echo 电源键确定。
echo.
echo 操作完成之后，请按任意键继续。
pause>nul
goto next9
:next8
ping 127.0.0.1>nul
:next9
echo 等待手机重启中...
goto RBLK2
:next10
echo.
echo 手机已经回锁。请按任意键退出。
pause>nul
goto EOF

:no4
fastboot reboot 2>nul
echo.
echo 重启完成，请按任意键退出。
pause>nul
goto EOF

:no5
fastboot oem HALT 2>nul
echo.
echo 将手机拔掉后即可关机。请按任意键退出。
pause>nul
goto EOF

:errorx
echo.
echo 错误：你没有将 Google Platform Tools 相关程序放置在这里。
echo.
echo 请从以下网站下载：
echo.
echo https://developer.android.google.cn/studio/releases/platform-tools
pause>nul
goto EOF

:errornokey
echo 错误：您没有将解锁码文件放置在指定位置。请按任意键返回主菜单。
echo.
pause>nul
goto selection

:errorunlock
findstr /C:"Too many links" goto usbthrottling
if %errorlevel%==0 goto usbthrottling
echo.
echo 错误：解锁码校验失败。
if "%actprojectcode%%secver%"=="SS210004" echo Bootloader 被您意外破坏了。必须拆机短接修复。
if "%actprojectcode%%secver%"=="HH110004" echo Bootloader 被您意外破坏了。必须拆机短接修复。
if "%actprojectcode%%secver%"=="HH610004" echo 不支持韩版夏普 AQUOS S3。
if "%actprojectcode%%secver%"=="SD110004" echo Bootloader 被您意外破坏了。必须拆机短接修复。
if "%actprojectcode%%secver%"=="SG110004" echo Bootloader 被您意外破坏了。必须拆机短接修复。
if "%actprojectcode%%secver%"=="SAT10004" echo Bootloader 被您意外破坏了。必须拆机短接修复。
if "%actprojectcode%%secver%"=="SS20001" echo 请将手机升级到 Android 8 后再来进行解锁操作。
if "%actprojectcode%%secver%"=="SAT0001" echo 请将手机升级到 Android 8 后再来进行解锁操作。
if "%actprojectcode%%secver%"=="PLE10004" echo 您也可以使用旧版本 OTA 更新包来降级 Bootloader，再来尝试解锁。
if "%actprojectcode%%secver%"=="D1C10004" echo 您也可以使用旧版本 OTA 更新包来降级 Bootloader，再来尝试解锁。
if "%actprojectcode%%secver%"=="ND110004" echo 您也可以使用旧版本 OTA 更新包来降级 Bootloader，再来尝试解锁。
if "%actprojectcode%%secver%"=="E1M10004" echo 您也可以使用旧版本 OTA 更新包来降级 Bootloader，再来尝试解锁。
if "%actprojectcode%%secver%"=="PL210004" echo 请从 Hikari Calyx Tech 直接申请远程解锁服务。
if "%actprojectcode%%secver%"=="DRG10004" echo 请从 Hikari Calyx Tech 直接申请远程解锁服务。
if "%actprojectcode%%secver%"=="C1N10004" echo 请从 Hikari Calyx Tech 直接申请远程解锁服务。
if "%actprojectcode%%secver%"=="B2N10004" echo 请从 Hikari Calyx Tech 直接申请远程解锁服务。
if "%actprojectcode%%secver%"=="NB110004" echo 您可以尝试从官方申请解锁：
if "%actprojectcode%%secver%"=="NB110004" echo https://www.nokia.com/en_int/phones/bootloader
if "%actprojectcode%%secver%"=="NB110004" echo.
echo 否则请检查您是否用错了解锁码文件。请按任意键返回主菜单。
fb2 oem getProjectCode
pause>nul
goto selection

:errorusbthrottling
echo.
echo 错误：USB 接口遇到拥塞。
echo.
echo 这意味着您的电脑的 USB 控制器和您的手机不兼容。
echo.
echo.这是夏普手机的已知问题，但我们并不知道具体哪些 USB 控制器
echo 与您的手机不兼容。
echo.
echo.您可以尝试使用其它电脑进行解锁，但更换驱动无法解决问题。
echo.
echo.请按任意键返回主菜单。
pause>nul
goto selection

:aunlocked
if "%critlock%"=="1" goto next4
echo.
echo 错误：手机已经是 Bootloader 解锁状态。
echo.
fastboot oem device-info
echo.
echo 请按任意键返回主菜单。
echo.
pause>nul
goto selection

:errorlock
if "%critlock%"=="1" goto next10
echo.
echo 错误：手机已经是 Bootloader 回锁状态。
echo.
fastboot oem device-info
echo.
echo 请按任意键返回主菜单。
echo.
pause>nul
goto selection

:mediatek
echo.
echo 错误：您正试图对联发科机型操作。
echo.
echo 请按任意键返回主菜单。
echo.
pause>nul
goto selection

:EOF

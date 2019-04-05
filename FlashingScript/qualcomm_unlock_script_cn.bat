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
set /p actprojectcode=<tmp.txt
del tmp.txt
:selection
set sel=
set econfirm=
cls
echo.
echo 您手机的序列号是 %devsn:~0,16%。
if "%actprojectcode:~0,3%"=="E1M" echo 机型是 Nokia 2。
if "%actprojectcode:~0,3%"=="D1A" echo 机型是 Nokia 5。
if "%actprojectcode:~0,3%"=="D1L" echo 机型是 Nokia 5。
if "%actprojectcode:~0,3%"=="ND1" echo 机型是 Nokia 5。
if "%actprojectcode:~0,3%"=="D1C" echo 机型是 Nokia 6。
if "%actprojectcode:~0,3%"=="D1T" echo 机型是 Nokia 6。
if "%actprojectcode:~0,3%"=="PLE" echo 机型是 Nokia 6。
if "%actprojectcode:~0,3%"=="PL2" echo 机型是 Nokia 6.1。
if "%actprojectcode:~0,3%"=="DRG" echo 机型是 Nokia 6.1 Plus X6。
if "%actprojectcode:~0,3%"=="C1N" echo 机型是 Nokia 7。
if "%actprojectcode:~0,3%"=="B2N" echo 机型是 Nokia 7 Plus。
if "%actprojectcode:~0,3%"=="NB1" echo 机型是 Nokia 8。
if "%actprojectcode:~0,3%"=="SS2" echo 机型是 Sharp Aquos S2 标配。
if "%actprojectcode:~0,3%"=="SAT" echo 机型是 Sharp Aquos S2 高配。
if "%actprojectcode:~0,3%"=="SG1" echo 机型是 Sharp Aquos S3 mini。
if "%actprojectcode:~0,3%"=="HH1" echo 机型是 Sharp Aquos S3 标配。
if "%actprojectcode:~0,3%"=="SD1" echo 机型是 Sharp Aquos S3 高配。
echo 开发代号是 %actprojectcode:~0,3%。
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
fastboot oem device-info
echo.
if %errorlevel%==1 goto mediatek
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
echo 正在解锁，请稍等...
fastboot flash unlock %unlockkey%
if "%errorlevel%"=="1" goto errorunlock
fastboot flashing unlock_critical
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
fastboot oem alive
fastboot flash unlock %unlockkey%
fastboot oem unlock-go
if "%actprojectcode:~0,3%"=="E1M" goto next4
if "%actprojectcode:~0,3%"=="D1A" goto next4
if "%actprojectcode:~0,3%"=="D1L" goto next4
if "%actprojectcode:~0,3%"=="ND1" goto next4
if "%actprojectcode:~0,3%"=="D1C" goto next4
if "%actprojectcode:~0,3%"=="D1T" goto next4
if "%actprojectcode:~0,3%"=="PLE" goto next4
echo 请注意看手机屏幕的提示。使用音量键选择 UNLOCK THE BOOTLOADER (或 Yes) 后，
echo 电源键确定。
echo.
echo 操作完成之后，请按任意键继续。
pause>nul
:next4
echo.
echo 恭喜！至此解锁完成。请按任意键退出。
goto EOF

:no2
cls
echo.
fastboot getvar current-slot
echo.
echo 您的手机当前的槽位如上所示。请输入您要切换的槽位后，
echo 按 Enter 键确定。( a / b )
echo.
echo 输入其它内容或不输入后 Enter 键确定将回到主菜单。
set /p econfirm=
if %econfirm%==A goto next5a
if %econfirm%==B goto next5b
if %econfirm%==a goto next5a
if %econfirm%==b goto next5b
goto selection

:next5a
fastboot oem set_active _a
fastboot --set-active=a
fastboot reboot-bootloader
fastboot getvar current-slot
goto next5c

:next5b
fastboot oem set_active _b
fastboot --set-active=b
fastboot reboot-bootloader
fastboot getvar current-slot
goto next5c

:next5c
echo 请检查槽位是否切换正确后，按 Enter 键返回到主菜单。
pause>nul
goto selection

:no3
cls
fastboot oem device-info
echo.
if %errorlevel%==1 goto mediatek
cls
echo.
echo.注意！
echo 除非保修需要，否则我们强烈不推荐回锁！
echo.
echo 如果您一定要回锁，请务必刷回原厂系统后回锁。
echo.
if "%actprojectcode:~0,3%"=="NB1" goto next6
if "%actprojectcode:~0,3%"=="SS2" goto next6
if "%actprojectcode:~0,3%"=="SAT" goto next6
echo 如果下面的 getProjectCode 为 %actprojectcode:~0,3%1，回锁后将无法正常重新解锁。
fb2 oem getProjectCode
:next6
echo.
echo.您确定要回锁吗？如果确定，请输入小写 yes 后按 Enter 键确定。
echo.
echo 输入其它内容或不输入后 Enter 键确定将回到主菜单。
echo.
echo.
set /p econfirm=
if "%econfirm%"=="yes" goto next7
goto selection

:next7
cls
echo.
echo 正在回锁，请稍等...
fastboot flashing lock_critical
if "%errorlevel%"=="1" goto next9a
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
fastboot oem alive
:next9a
fastboot oem lock-go
if "%errorlevel%"=="1" goto errorlock
if "%actprojectcode:~0,3%"=="E1M" goto next10
if "%actprojectcode:~0,3%"=="D1A" goto next10
if "%actprojectcode:~0,3%"=="D1L" goto next10
if "%actprojectcode:~0,3%"=="ND1" goto next10
if "%actprojectcode:~0,3%"=="D1C" goto next10
if "%actprojectcode:~0,3%"=="D1T" goto next10
if "%actprojectcode:~0,3%"=="PLE" goto next10
echo 请注意看手机屏幕的提示。使用音量键选择 LOCK THE BOOTLOADER (或 Yes) 后，
echo 电源键确定。
echo.
echo 操作完成之后，请按任意键继续。
pause>nul
:next10
echo.
echo 至此回锁完成。请按任意键退出。
goto EOF

:no4
fastboot reboot
echo.
echo 重启完成，请按任意键退出。
pause>nul
goto EOF

:no5
fastboot oem HALT
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
echo.
echo 错误：解锁码校验失败。
echo 如果下面显示的 getProjectCode 是 %actprojectcode:~0,3%1，您将需要联系远程降级服务。
if "%actprojectcode:~0,3%"=="E1M" echo 您也可以使用旧版本 OTA 更新包来降级 Bootloader，再来尝试解锁。
if "%actprojectcode:~0,3%"=="D1A" echo 您也可以使用旧版本 OTA 更新包来降级 Bootloader，再来尝试解锁。
if "%actprojectcode:~0,3%"=="D1L" echo 您也可以使用旧版本 OTA 更新包来降级 Bootloader，再来尝试解锁。
if "%actprojectcode:~0,3%"=="ND1" echo 您也可以使用旧版本 OTA 更新包来降级 Bootloader，再来尝试解锁。
if "%actprojectcode:~0,3%"=="D1C" echo 您也可以使用旧版本 OTA 更新包来降级 Bootloader，再来尝试解锁。
if "%actprojectcode:~0,3%"=="D1T" echo 您也可以使用旧版本 OTA 更新包来降级 Bootloader，再来尝试解锁。
if "%actprojectcode:~0,3%"=="PLE" echo 您也可以使用旧版本 OTA 更新包来降级 Bootloader，再来尝试解锁。
if "%actprojectcode:~0,3%"=="PL2" echo 您也许还可以尝试切换到另一个槽位后再来解锁。
if "%actprojectcode:~0,3%"=="DRG" echo 您也许还可以尝试切换到另一个槽位后再来解锁。
if "%actprojectcode:~0,3%"=="C1N" echo 您也许还可以尝试切换到另一个槽位后再来解锁。
if "%actprojectcode:~0,3%"=="B2N" echo 您也许还可以尝试切换到另一个槽位后再来解锁。
if "%actprojectcode:~0,3%"=="NB1" echo 或者，您可以尝试从官方申请解锁：
if "%actprojectcode:~0,3%"=="NB1" echo https://www.nokia.com/en_int/phones/bootloader
if "%actprojectcode:~0,3%"=="NB1" echo.
echo 否则请检查您是否用错了解锁码文件。请按任意键返回主菜单。
fb2 oem getProjectCode
pause>nul
goto selection

:errorlock
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

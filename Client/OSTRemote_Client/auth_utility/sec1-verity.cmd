md5 -l -d%psn%>%temp%\md5.txt
set /p md5=<%temp%\md5.txt
del %temp%\md5.txt
fb2 oem dm-verity %md5% 2>nul
echo %t0053%
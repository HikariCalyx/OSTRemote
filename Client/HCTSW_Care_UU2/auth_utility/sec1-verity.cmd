fb2 devices>tmp1.txt
set /p sn=<tmp1.txt
set sn=%sn:~0,16%
md5 -l -d%sn%>md5.txt
set /p md5=<md5.txt
fb2 oem dm-verity %md5% 2>nul
echo %t0023%
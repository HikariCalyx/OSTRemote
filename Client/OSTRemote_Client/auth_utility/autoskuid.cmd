@echo off

::Rules

::Brand0
set sku_brand=0

::Brand3
if "%fver:~0,3%"=="VN3" set sku_brand=3
if "%fver:~0,3%"=="SS2" set sku_brand=3
if "%fver:~0,3%"=="SAT" set sku_brand=3
if "%fver:~0,3%"=="SG1" set sku_brand=3
if "%fver:~0,3%"=="HH1" set sku_brand=3
if "%fver:~0,3%"=="HH6" set sku_brand=3
if "%fver:~0,3%"=="SD1" set sku_brand=3

::Brand6
if "%fver:~0,3%"=="FRT" set sku_brand=6
if "%fver:~0,3%"=="ANT" set sku_brand=6
if "%fver:~0,3%"=="E1M" set sku_brand=6
if "%fver:~0,3%"=="E2M" set sku_brand=6
if "%fver:~0,3%"=="EVW" set sku_brand=6
if "%fver:~0,3%"=="NE1" set sku_brand=6
if "%fver:~0,3%"=="ES2" set sku_brand=6
if "%fver:~0,3%"=="EAG" set sku_brand=6
if "%fver:~0,3%"=="ROO" set sku_brand=6
if "%fver:~0,3%"=="RHD" set sku_brand=6
if "%fver:~0,3%"=="ND1" set sku_brand=6
if "%fver:~0,3%"=="CO2" set sku_brand=6
if "%fver:~0,3%"=="PDA" set sku_brand=6
if "%fver:~0,3%"=="D1C" set sku_brand=6
if "%fver:~0,3%"=="PLE" set sku_brand=6
if "%fver:~0,3%"=="PL2" set sku_brand=6
if "%fver:~0,3%"=="DRG" set sku_brand=6
if "%fver:~0,3%"=="C1N" set sku_brand=6
if "%fver:~0,3%"=="B2N" set sku_brand=6
if "%fver:~0,3%"=="CTL" set sku_brand=6
if "%fver:~0,3%"=="TAS" set sku_brand=6
if "%fver:~0,3%"=="NB1" set sku_brand=6
if "%fver:~0,3%"=="A1N" set sku_brand=6
if "%fver:~0,3%"=="AOP" set sku_brand=6

::Carrier
set sku_carrier=00
if "%fver:~0,3%"=="HH6" set sku_carrier=1L
if "%fver:~0,3%"=="EAG" if "%fver:~11,4%"=="00N0" set sku_carrier=0C
if "%fver:~0,3%"=="EAG" if "%fver:~11,4%"=="01N0" set sku_carrier=01
if "%fver:~0,3%"=="RHD" set sku_carrier=0C
if "%fver:~0,3%"=="EVW" set sku_carrier=1K
if "%fver:~0,3%"=="PLE" if "%fver:~11,4%"=="00A0" set sku_carrier=1Y
if "%fver:~0,3%"=="PLE" if "%fver:~11,4%"=="00S0" set sku_carrier=1Y

::Locales
set locales=00
if "%fver:~11,4%"=="00CN" set sku_locales=CN
if "%fver:~11,4%"=="00WW" set sku_locales=WW
if "%fver:~11,4%"=="00E0" set sku_locales=E0
if "%fver:~11,4%"=="00JP" set sku_locales=JP
if "%fver:~11,4%"=="00RU" set sku_locales=RU
if "%fver:~11,4%"=="00TW" set sku_locales=TW
if "%fver:~0,3%"=="PNX" if "%fver:~4,1%"=="3" set sku_locales=RU
if "%fver:~0,3%"=="PNX" if "%fver:~4,1%"=="5" set sku_locales=RU
if "%fver:~0,3%"=="PNX" if "%fver:~4,1%"=="7" set sku_locales=RU
if "%fver:~0,3%"=="HH1" if "%fver:~11,4%"=="00WW" set sku_locales=TW
if "%fver:~0,3%"=="TAS" if "%fver:~11,4%"=="00WW" set sku_locales=TW
if "%fver:~0,3%"=="PLE" if "%fver:~11,4%"=="00A0" set sku_locales=IN
if "%fver:~0,3%"=="PLE" if "%fver:~11,4%"=="00S0" set sku_locales=US
if "%fver:~0,3%"=="EAG" set sku_locales=US
if "%fver:~0,3%"=="RHD" set sku_locales=US
if "%fver:~0,3%"=="HH6" set sku_locales=KR

set targetskuid=%sku_brand%%sku_carrier%%sku_locales%
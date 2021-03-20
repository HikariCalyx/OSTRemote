# OSTRemote Client

OSTRemote Client is a replacement of OST LA and probably NTool.

## Dependencies
### Windows

* [Universal C Runtime (KB2999226)](http://catalog.update.microsoft.com/v7/site/Search.aspx?q=KB2999226)

#### Following dependencies should be placed at bin directory.
* ADB and Fastboot (Minimal acceptable version is R28.0.1, R29.0.5 is recommended): adb.exe, AdbWinApi.dll, AdbWinUsbApi.dll, fastboot.exe, libwinpthread-1.dll, make_f2fs.exe, mke2fs.conf, mke2fs.exe
* OST LA exclusive Fastboot: fastboot.exe in OST LA directory, should be named as fb2.exe, SHA256: ```0390D31EE037990B31AE0965255F539D16CD9043FB458161A95E32B18897E3A6```
* GnuWin32 executables, including: awk.exe, sed.exe, unzip.exe, zipinfo.exe and their dependencies
* [md5.exe by John Walker](http://www.fourmilab.ch/md5/)

### macOS and Linux
TBD

## Usage
```
ostremote [parameter]
```

## Parameters
```
 -?, -h, --help                       : Show this help.
 -v, --verbose                        : Enter verbose mode.
 -m [mlf_file], --mlffile=[mlf_file]  : Specify the path of mlf format firmware file.
                                        Mandatory for firmware flashing.
 -e, --erase-user-data                : Erase user data during flashing procedure.
 -s [skuid], --skuid=[skuid]          : Change SKUID to desired value. Leave empty in
                                        SKUID value for automatic SKUID definition.
 -f, --erase-frp                      : Erase FRP and bbox during flashing procedure.
 -o, --override                       : Skip flashing security check. NOT RECOMMENDED
                                        for inexperienced end-users.
 -p, --pretest                        : List detailed information of the phone.
 -S, --skip-authentication            : Skip authentication procedure. Can be only used on
                                        supported devices with unlocked bootloader, -s and -f
                                        parameters will become invalid with it provided.
 -a, --authentication-only            : Grant service permission only. If not using under
                                        service bootloader, -e, -s and -f parameters are invalid.
 -D, --disable-fac-mode               : Disable Factory Bar Code mode.
 -H, --halt                           : Power off the phone. if specified with firmware
                                        flashing, it will power off the phone after procedure.

```

## Examples

Flash DRG-415C-0-00WW-B01.mlf into the phone:
```ostremote -m C:\path\to\FIHSW_DRG-415C-0-00WW-B01\DRG-415C-0-00WW-B01.mlf -e -s 600WW```

Flash HH6-350D-0-00A0-B01.mlf into the phone and power it off:
```ostremote -m C:\path\to\FIHSW_HH6-350D-0-00A0-B01\HH6-350D-0-00A0-B01.mlf -e -H```

## License
GPLv3

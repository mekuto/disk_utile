@rem Disk utility bat file
@echo on

@set firstArg=%1
@set secondArg=%2
@set thirdArg=%3
@set diskpartFile=diskpart.txt

@if "%firstArg%"=="" goto lab_help
@if "%firstArg%"=="help" goto lab_help

@if "%firstArg%"=="efi" goto lab_efi
@if "%firstArg%"=="efi4k" goto lab_efi4K
@if "%firstArg%"=="efi4K" goto lab_efi4K
@if "%firstArg%"=="disks" goto lab_disks
@if "%firstArg%"=="3part" goto lab_3part

@goto :EOF

:lab_efi
@if "%secondArg%"=="" goto lab_help
@if exist "%diskpartFile%" del "%diskpartFile%"
@echo select disk %secondArg% > %diskpartFile%
@echo create partition efi size=100 >> %diskpartFile%
@echo format quick fs=fat32 label="System" >> %diskpartFile%
@echo assign letter="S" >> %diskpartFile%
@rem @echo set id="c12a7328-f81f-11d2-ba4b-00a0c93ec93b" >> %diskpartFile%
@echo create partition msr size=16 >> %diskpartFile%
@echo format quick fs=ntfs >> %diskpartFile%
@rem @echo set id="e3c9e316-0b5c-4db8-817d-f92df00215ae" >> %diskpartFile%
@echo exit >> %diskpartFile%

diskpart /s %diskpartFile%

@goto :EOF

:lab_efi4K
@if "%secondArg%"=="" goto lab_help
@if exist "%diskpartFile%" del "%diskpartFile%"
@echo select disk %secondArg% > %diskpartFile%
@echo create partition efi size=260 >> %diskpartFile%
@echo format quick fs=fat32 label="System" >> %diskpartFile%
@echo assign letter="S" >> %diskpartFile%
@rem @echo set id="c12a7328-f81f-11d2-ba4b-00a0c93ec93b" >> %diskpartFile%
@echo create partition msr size=16 >> %diskpartFile%
@echo format quick fs=ntfs >> %diskpartFile%
@rem @echo set id="e3c9e316-0b5c-4db8-817d-f92df00215ae" >> %diskpartFile%
@echo exit >> %diskpartFile%

diskpart /s %diskpartFile%

@goto :EOF

:lab_disks
@if exist "%diskpartFile%" del "%diskpartFile%"
@echo list disk > %diskpartFile%
@rem @echo exit >> %diskpartFile%

diskpart /s %diskpartFile%

@goto :EOF 

:lab_3part
@if exist "%diskpartFile%" del "%diskpartFile%"
@if "%secondArg%"=="" goto lab_help
@echo select disk %secondArg% > %diskpartFile%
@echo create partition primary size=350000 >> %diskpartFile%
@echo format quick fs=ntfs label="User's" >> %diskpartFile%
@echo create partition primary size=300000 >> %diskpartFile%
@echo format quick fs=ntfs label="Windows" >> %diskpartFile%
@echo assign letter="W" >> %diskpartFile%
@echo create partition primary >> %diskpartFile%
@echo shrink minimum=7168 >> %diskpartFile%
@echo format quick fs=ntfs label="User's" >> %diskpartFile%
@echo create partition primary >> %diskpartFile%
@echo format quick fs=ntfs label="Recovery" >> %diskpartFile%
@echo assign letter="R" >> %diskpartFile%
@echo set id="de94bba4-06d1-4d40-a16a-bfd50179d6ac" >> %diskpartFile%
@echo gpt attributes=0x8000000000000001 >> %diskpartFile%
@echo list volume >> %diskpartFile%
@echo exit >> %diskpartFile%

diskpart /s %diskpartFile%

@goto :EOF

:lab_fsutil
@if "%secondArg%"=="" goto lab_help
fsutil fsingo ntfsinfo %secondArg%

@goto :EOF

@:lab_help
@echo Disk utility bat file
@echo Example of run disk_util.bat with param
@echo     disk_util.bat param1 param2
@echo         list of param1:
@echo             help - print this help message.
@echo             disks - print output from diskpart.
@echo             efi - create efi partition in 100 MB size and format to fat32,
@echo                   in param2 set number disk from diskpart otput. Also
@echo                   create MSR partition size 16 MB for Windows installation.
@echo             efi4K - create efi partition in 260 MB size and format to fat32,
@echo                   in param2 set number disk from diskpart output. Also
@echo                   creat MSR partition size 16 MB for Windows installation.
@echo             3part - create and run script for diskpart to create 3 primary
@echo                   GPT partition on disk. Size of partition: for 1 partition 
@echo                   350000 MB, for 2 partition 300000 MB, for 3 partition all
@echo                   remaining free space -(minus) 7168 MB for partition for
@echo                   recovery. Required param2 to set number diks for work.
@echo             fsutil - run "fsutil fsinfo ntfsinfo c:", where c: - letter of
@echo                   disk to get info about 4K clasters in HDD. In param2
@echo                   specify letter disk.
@echo
@echo In Windows 10 setup mode Shift+F10 to run command line tool.
@echo
@pause
@goto :EOF


@rem bcdboot W:\Windows
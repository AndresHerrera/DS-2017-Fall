rem =====================================================
rem =====================================================
rem Author:  Andres Herrera
rem Mail: fabio.herrera@correounivalle.edu.co
rem Course: Fundamentals of Distributed Systems (DS-2017-Fall)
rem Teacher: John Sanabria - john.sanabria@correounivalle.edu.co
rem Homework 1: 4.2. Item in Logfile (Bash Script)
rem This version was developed for MSDOS 
rem Tested in : Microsoft Windows [Version 10.0.10240]
rem Notes: 
rem This script is just for academic propouses
rem =====================================================
rem Sources:
rem https://www.perkin.org.uk/posts/create-virtualbox-vm-from-the-command-line.html
rem https://stackoverflow.com/questions/15484646/with-vboxmanage-how-to-list-all-snapshots-of-vm
rem https://www.virtualbox.org/manual/ch08.html
rem https://www.enmimaquinafunciona.com/pregunta/1612/como-ejecutar-vboxmanageexe
rem https://forums.virtualbox.org/viewtopic.php?f=1&t=74101

cls
@echo OFF
set PATH=%PATH%;C:\Program Files\Oracle\VirtualBox
COLOR 1F
echo #---------------------------------------------------
echo #    DS-Homework (1) for MS-DOS Version     
echo #    By: Andres Herrera								 
echo #    fabio.herrera@correounivalle.edu.co            
echo #---------------------------------------------------
echo 
timeout 2 > NUL
COLOR 0F 
echo 
timeout 2 > NUL
COLOR 1F
echo 
timeout 2 > NUL
COLOR 0F

rem default values
set VM="Ubuntu Server VM"
set otype="Ubuntu_64"
set isopath="ubuntu-16.04.3-server-amd64.iso"
rem dynamic disk size  32768 -> 32GB 
set ddisksize=32768
set memorysize=1024 
set vramsize=128

:options
cls
echo #---------------------------------------------------
echo #   What do what to do ?
echo #       1. Create a new virtual machine
echo #       2. Start a existent Virtual Machine
echo #       3. List running Virtual Machines
echo #       4. Stop running Virtual Machine
echo #       5. Take snapshot
echo #       6. Restore snapshot
echo #       7. Exit 
echo #---------------------------------------------------
set /p op= Pick an option:
echo.
if '%op%' == '0' goto options
if '%op%' == '1' goto choosename
if '%op%' == '2' goto startmachine
if '%op%' == '3' goto listrunning
if '%op%' == '4' goto stoprunning
if '%op%' == '5' goto takesnapshot
if '%op%' == '6' goto restoresnapshot
if '%op%' == '7' goto close


:choosename
cls
set /p VM=New name for V.M :
echo.
if '%VM%' == '' goto choosename
cls

echo [o]Creating VM %VM%!
VBoxManage createhd --filename %VM%.vdi --size %ddisksize%
echo [*]VM %VM%! Created !
pause
VBoxManage list ostypes
echo -----------------------------------------------------

:chooseostype
set /p otype=Chose OS Type (ID) :
echo.
if '%otype%' == '' goto chooseostype
cls
echo %otype% chosen
VBoxManage createvm --name %VM% --ostype "%otype%" --register
echo [*]Created and Registered OS type : %otype% ! 
pause

set /p yno=Attach a SATA Controller [y/n]?
echo.
if '%yno%' == 'y' (
echo [o]Add a SATA controller with the dynamic disk attached.!
VBoxManage storagectl %VM% --name "SATA Controller" --add sata --controller IntelAHCI
VBoxManage storageattach %VM% --storagectl "SATA Controller" --port 0 --device 0 --type hdd --medium %VM%.vdi
echo [*]Done!
)
pause 


set /p yno=Attach a IDE Controller [y/n]?
echo.
if '%yno%' == 'y' (
echo [o] Add an IDE controller with a DVD drive attached, and the install ISO %isopath% inserted into the drive
VBoxManage storagectl %VM% --name "IDE Controller" --add ide
VBoxManage storageattach %VM% --storagectl "IDE Controller" --port 0 --device 0 --type dvddrive --medium %isopath%
echo [*]Done!
)
pause 


set /p yno=Add misc system settings [y/n]?
echo.
if '%yno%' == 'y' (
echo [o] Misc system settings
VBoxManage modifyvm %VM% --ioapic on
echo [*]Ioapic ON Done!
VBoxManage modifyvm %VM% --boot1 dvd --boot2 disk --boot3 none --boot4 none
echo [*]Boot secuence Done!
VBoxManage modifyvm %VM% --memory 1024 --vram 128
echo [*]Memory size: %memorysize%  and vram size: %vramsize%

)
pause 
cls
goto options



:startmachine
VBoxManage list vms
set /p VM=Chose VM (ID) :
echo.
if '%VM%' == '' goto startmachine
cls
echo %VM% chosen
echo [*]Starting VM : %VM% ! 
rem VBoxHeadless -s %VM%
VBoxManage startvm "%VM%" 
pause


:listrunning
echo -----------------------------------------------------
echo [*] Running VM List
VBoxManage list runningvms 
pause
goto options


:stoprunning
echo -----------------------------------------------------
echo [*] Running VM List
VBoxManage list runningvms 
set /p VM=Chose VM to Stop(ID) :
echo.
if '%VM%' == '' goto options
cls
echo %VM% chosen
echo [*]Stoping VM : %VM% ! 
vboxmanage controlvm "%VM%"  poweroff 
pause
goto options


:takesnapshot
echo -----------------------------------------------------
echo [*] Running VM List
VBoxManage list runningvms 
set /p VM=Chose VM to Stop(ID) :
echo.
if '%VM%' == '' goto options
cls
echo %VM% chosen
echo [*]Say whisky VM : %VM% !
 
set HH=%TIME: =0%
set TFIX=%HH:~0,2%%TIME:~3,2%%TIME:~6,2%%TIME:~9,2%
set v_timestamp=%date:~-10,2%%date:~-7,2%%date:~-4,4%_%TFIX%

VBoxManage snapshot %VM% take %VM%_%v_timestamp%
echo [*]Snapshot stored as %VM%_%v_timestamp%
pause
goto options



:restoresnapshot
echo -----------------------------------------------------
echo [*] Running VM List
VBoxManage list runningvms 
set /p VM=Chose VM to get snapshots stored(ID) :
echo.
if '%VM%' == '' goto options
cls
echo %VM% chosen
echo [*]Stored snapshots for: %VM% 
VBoxManage snapshot %VM% list
echo -----------------------------------------------------
set /p SNAPID=Chose stored snapshot (ID) :
echo.
if '%SNAPID%' == '' goto restoresnapshot
cls
echo [*]Restoring snapshot %SNAPID% for %VM% 
 
pause
goto options



:close
set VM=""
set yno=""
exit





rem VBoxManage createhd --filename %VM%.vdi --size 32768
rem VBoxManage createvm --name %VM% --ostype "Ubuntu_64" --register
rem VBoxManage storagectl %VM% --name "SATA Controller" --add sata --controller IntelAHCI
rem VBoxManage storageattach %VM% --storagectl "SATA Controller" --port 0 --device 0 --type hdd --medium %VM%.vdi
rem VBoxManage storagectl %VM% --name "IDE Controller" --add ide
rem VBoxManage storageattach %VM% --storagectl "IDE Controller" --port 0 --device 0 --type dvddrive --medium ubuntu-16.04.3-server-amd64.iso
rem VBoxManage modifyvm %VM% --ioapic on
rem VBoxManage modifyvm %VM% --boot1 dvd --boot2 disk --boot3 none --boot4 none
rem VBoxManage modifyvm %VM% --memory 1024 --vram 128

rem create Ethernetnet Adapter
rem VBoxManage hostonlyif create
rem VBoxManage hostonlyif ipconfig "VirtualBox Host-Only Ethernet Adapter" –ip 192.168.0.1 –netmask 255.255.255.0
rem VBoxManage modifyvm %VM% --nic1 bridged --bridgeadapter1 NAT

rem VBoxManage natnetwork modify --netname natnet1 --dhcp on
rem VBoxManage natnetwork start --netname natnet1
rem VBoxManage modifyvm %VM% --nic1 bridged --bridgeadapter1 "VirtualBox Host-Only Ethernet Adapter #4"
rem VBoxManage list -l hostonlyifs

rem VBoxHeadless -s %VM%
rem Take a snapshot
rem VBoxManage snapshot %VM% take <name of snapshot>
#!/bin/sh

clear

print_error()
{
 echo "Error: This option needs --name=NAME parammeter"
 exit 1
}

print_help()
{
   echo $"Usage: $0 \n\t-o={run|cvm|dvm|svm|rvms|lvms|snapvm|lsnap} " 
   echo "\t\trun: Run an existent VM"
   echo "\t\tcvm: Create a new VM (needs -n -ds -c -m -vr params)"
   echo "\t\tdvm: Delete an existent VM (needs -n param)"
   echo "\t\tsvm: Stop a running VM (needs -n param)"
   echo "\t\trvms: List running VM(s)"
   echo "\t\tlvms: List VM(s)"
   echo "\t\tsnapvm: VM Snapshot (needs -n param)"
   echo "\t\tlsnap: List VM Snapshots (needs -n param)" 
   echo "\t-n={namevm}"
   echo "\t\tvmname: VM name" 
   echo "\t-ds={32738}"
   echo "\t\tdisksize: Disk Size (ex. 32738)"
   echo "\t-c={cpus}"
   echo "\t\tcpus: Cpus Number (ex. 1)"
   echo "\t-m={memory}"
   echo "\t\tmemory: Memory ( ex. 1024)"
   echo "\t-vr={ram}"
   echo "\t\tram: RAM (ex. 124)"
   exit 1
}



for i in "$@"
do
   case $i in 
     -o=*|--option=*)
         OPTION="${i#*=}"
     ;;
     
     -n=*|--name=*)
      	  NAMEVM="${i#*=}"
      ;;

     -ds=*|--disksize=*)
  	DISKSIZE="${i#*=}"
      ;;

     -c=*|--cpu=*)
        CPUNUMBER="${i#*=}"
      ;;

      -m=*|--memory=*)
        MEMORY="${i#*=}"
      ;;

      -vr=*|--vram=*)
        VRAM="${i#*=}"
      ;;

	
     -h|--help)print_help;;

      *)print_help;;	

esac 
done 

print_error()
{
 echo "Error: This option needs --name=NAME parameter"
 exit 1
}


case $OPTION in 
    "cvm")   
        VM="$NAMEVM"
        echo $VM
        if [ "$VM" = "" ]; then 
           print_error
        fi
        echo "[*]Creating VM"
	
	#32768
	DS=$DISKSIZE
        #2
	CPUN=$CPUNUMBER
        #1024
        MEM=$MEMORY
        #128
        RAM=$VRAM
	
        vboxmanage createhd --filename $VM.vdi --size $DS
	vboxmanage createvm --name $VM --ostype "Linux26_64" --register
	vboxmanage storagectl $VM --name "SATA Controller" --add sata --controller IntelAHCI
	vboxmanage storageattach $VM --storagectl "SATA Controller" --port 0 --device 0 --type hdd --medium $VM.vdi
	vboxmanage storagectl $VM --name "IDE Controller" --add ide
	vboxmanage storageattach $VM --storagectl "IDE Controller" --port 0 --device 0 --type dvddrive --medium mini.iso
	vboxmanage modifyvm $VM --ioapic on
	vboxmanage modifyvm $VM --boot1 dvd --boot2 disk --boot3 none --boot4 none
	vboxmanage modifyvm $VM --cpus $CPUN
        
	vboxmanage modifyvm $VM --memory $MEM  --vram $RAM
	#vboxmanage modifyvm $VM --nic1 bridged --bridgeadapter1 e100g0
        echo "[*] VM Created"
     ;;

  "run")
        VM="$NAMEVM"
        echo $VM
        if [ "$VM" = "" ]; then
           print_error
        fi
        echo "[*]Run VM"
        vboxmanage startvm "$VM" --type headless
        echo "[*] VM Running"
     ;;

    "dvm")
        VM="$NAMEVM"
        echo $VM
        if [ "$VM" = "" ]; then
           print_error
        fi
	echo "[*]Deleting VM"
	vboxmanage unregistervm --delete $VM
	echo "[*] VM Deleted"
     ;;

    "rvms")
        echo "[*]Running VMS"
        vboxmanage list runningvms
     ;; 

     "lvms")
        echo "[*]Listing VMS"
        vboxmanage list vms
     ;;


   "svm")
        VM="$NAMEVM"
        echo $VM
        if [ "$VM" = "" ]; then
           print_error
        fi
        echo "[*]Stoping VM"
        vboxmanage controlvm $VM poweroff
        echo "[*] VM Stopped"
     ;; 

  "lsnap")
        VM="$NAMEVM"
        echo $VM
        if [ "$VM" = "" ]; then
           print_error
        fi
        echo "[*]Snapshots list for $VM"
        vboxmanage snapshot $VM list
     ;;


   "snapvm")
   	VM="$NAMEVM"
        echo $VM
        if [ "$VM" = "" ]; then
           print_error
        fi
        echo "[*]Snapshot $VM"
        dt=$(date '+%d-%m-%y-%H-%M-%S')
        vboxmanage snapshot $VM take "$VM"_"$dt"
        echo "[*] Snapshot for $VM stored as: "$VM"_"$dt""
     ;;

esac


exit 1

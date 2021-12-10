#!/bin/bash
echo "#Architecture: $(uname -a)"
echo "#CPU physical: $(grep -c processor /proc/cpuinfo)"
echo "#vCPU: $(nproc)"
TRAM=$(free -m | awk '$1 == "Mem:" {print $2}')
URAM=$(free -m | awk '$1 == "Mem:" {print $3}')
RAMper=$(free | awk '$1 == "Mem:" {printf("%.2f"), $3/$2*100}')
echo "#Memory Usage: $URAM/${TRAM}MB ($RAMper%)"
Tdisk=$(df -Bg | grep '^/dev/' | grep -v '/boot$' | awk '{ft += $2} END {print ft}')
Udisk=$(df -Bm | grep '^/dev/' | grep -v '/boot$' | awk '{ut += $3} END {print ut}')
diskper=$(df -Bm | grep '^/dev/' | grep -v '/boot$' | awk '{ut += $3} {ft+= $2} END {printf("%d"), ut/ft*100}')
echo "#Disk Usage: $Udisk/${Tdisk}Gb ($diskper%)"
echo "#CPU load: $(mpstat | grep all | awk '{printf "%.2f%%\n", 100-$13}')"
LBOOT=$(uptime -s)
echo "#Last boot: ${LBOOT::-3}"
LVMC=$(lsblk | grep lvm | wc -l)
LVMA="no"
if [ "$LVMC" > 0 ]
then
        LVMA="yes"
fi
echo "#lvm use: $LVMA"
echo "#Connexions TCP : $(netstat -ant | grep ESTABLISHED | wc -l) ESTABLISHED"
echo "#User log: $(users | wc -w)"
IP_MAC=$(ip a | grep ether | cut -d " " -f6)
echo "#Network: IP $(hostname -I) (${IP_MAC})"
echo "#Sudo : $(journalctl _COMM=sudo | grep COMMAND | wc -l) cmd"
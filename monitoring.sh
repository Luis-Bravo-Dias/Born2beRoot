echo "Architecture: $(uname -a)"
echo "CPU physical: $(grep -c processor /proc/cpuinfo)"
echo "vCPU: $(nproc)"
TRAM=$(free -m | awk '$1 == "Mem:" {print $2}')
URAM=$(free -m | awk '$1 == "Mem:" {print $3}')
RAMper=$(free | awk '$1 == "Mem:" {printf("%.2f"), $3/$2*100}')
echo "Memory Usage: $URAM/${TRAM}MB ($RAMper%)"

LBOOT=$(uptime -s)
echo "Last boot: ${LBOOT::-3}"
LVMC=$(lsblk | grep lvm | wc -l)
LVMA="no"
if [ "$LVMC" > 0 ]
then
        LVMA="yes"
fi
echo "lvm use: $LVMA"
echo "Connexions TCP : $(netstat -ant | grep ESTABLISHED | wc -l) ESTABLISHED"
echo "User log: $(users | wc -w)"
IP_MAC=$(ip a | grep ether | cut -d " " -f6)
echo "Network: IP $(hostname -I) (${IP_MAC})"
echo "Sudo : $(sudo journalctl _COMM=sudo | grep COMMAND | wc -l) cmd"
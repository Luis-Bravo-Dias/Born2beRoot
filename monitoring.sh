#echo "Architecture: $(uname -a)" -> The architecture of your operating system and its kernel version
#(echo funciona como printf e o $ como o %) 
#echo "CPU physical: $(grep -c processor /proc/cpuinfo)" -> The number of physical processors
#(grep procura a palavra processor no /proc/cpuinfo e -c conta quantas vezes aparece)
#echo "vCPU: $(nproc)" --> The number of virtual processors.
#(nproc dá o número de processadores virtuais)


#echo "Last boot: $(uptime -s)" --> The date and time of the last reboot
#(uptime mostra há quanto tempo a maquina está ligada e -s mostra a data do último reboot)
#lsblk -o TYPE | grep lvm | wc -l
#(lsblk lista as partições, -o TYPE mostra-as por tipos, grep lvm vai buscar apaenas as de tipo lvm e wc -l conta quantas linhas de lvm são)
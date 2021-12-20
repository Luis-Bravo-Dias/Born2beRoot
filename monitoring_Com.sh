#!/bin/bash
echo "Architecture: $(uname -a)"#-> The architecture of your operating system and its kernel version
#echo funciona como printf e o $ como o %

echo "CPU physical: $(grep -c processor /proc/cpuinfo)"#-> The number of physical processors
#grep procura a palavra processor no /proc/cpuinfo e -c conta quantas vezes aparece

echo "vCPU: $(nproc)"#-> The number of virtual processors
#nproc dá o número de processadores virtuais

TRAM=$(free -m | awk '$1 == "Mem:" {print $2}')
#TRAM é a memória total de RAM
#Com free -m acedemos aos dados de memória em mebibytes (como está no exemplo do subject)
#awk permite usar funções, com $1 == "Mem:" selecionamos a linha do Mem e com {print $2} escrevemos o que está na segunda coluna
URAM=$(free -m | awk '$1 == "Mem:" {print $3}')
#URAM é a memória RAM usada
RAMper=$(free | awk '$1 == "Mem:" {printf("%.2f"), $3/$2*100}')
#RAMper é o raio de utelização da memória em percentagem
# {printf("%.2f"), $3/$2*100} escreve o resultado da divisão da terceira coluna (memória usada) pela segunda coluna (memória total) multiplicado por 100 para conseguir a percentagem
echo "Memory Usage: $URAM/${TRAM}MB ($RAMper%)"#->The current available RAM on your server and its utilization rate as a percentage

Tdisk=$(df -Bg | grep '^/dev/' | grep -v '/boot$' | awk '{ft += $2} END {print ft}')
#Tdisk ė a memória total do disco
#com df temos os dados de memória do disco e com -Bg temos esses dados em G
#com grep '^/dev/' agarramos apenas as linhas que começam por /dev/ e com o grep -v '/boot' exclui a linha de boot
#com awk '{ft += $2}' criamos uma variavel que vai ter no seu interior a soma do valor da segunda coluna (valor total) de cada linha que agarramos
#com END {print ft}') sendo um comando END só será lido no fim de todas as operações, imprimindo o valor da variável que criamos
Udisk=$(df -Bm | grep '^/dev/' | grep -v '/boot$' | awk '{ut += $3} END {print ut}')
#Udisk é a memória usada no disco
#com df temos os dados de memória do disco e com -Bm temos esses dados em M
#com awk '{ft += $3} criamos uma variavel que vai ter no seu interior a soma do valor da terceira coluna (valor usado) de cada linha que agarramos
diskper=$(df -Bm | grep '^/dev/' | grep -v '/boot$' | awk '{ut += $3} {ft+= $2} END {printf("%d"), ut/ft*100}')
#diskper é o raio de utelização da memória do disco em percentagem
#awk '{ut += $3} {ft+= $2} END {printf("%d"), ut/ft*100}') escreve o resultado da divisão da terceira coluna (memória usada) pela segunda coluna (memória total) multiplicado por 100 para conseguir a percentagem
echo "Disk Usage: $Udisk/${Tdisk}Gb ($diskper%)"#->The current available memory on your server and its utilization rate as a percentage

echo "CPU load: $(mpstat | grep all | awk '{printf "%.2f%%\n", 100-$13}')"#->The current utilization rate of your processors as a percentage
#para usar mpstat é necessário instalar o sysstat (apt install sysstat)
#Com mpstat obtemos os dados de utelização do CPU
#Com grep all conseguimos a linha onde estão os valores
#awk '{printf "%.2f%%\n", 100-$13}' vai imprimir o valor da 13 coluna (idle) que é a percentagem de CPU que não está a ser usada subtraido por 100, o que vai dar a percentagem que está a ser usada

LBOOT=$(uptime -s)
#uptime mostra há quanto tempo a maquina está ligada e -s mostra a data do último reboot
echo "Last boot: ${LBOOT::-3}"#-> The date and time of the last reboot
#com o comando ::-3 removemos os últimos 3 caracteres da string que correspondem aos segundos e o ponto de separação

LVMC=$(lsblk | grep lvm | wc -l)
#lsblk lista as partições, grep lvm vai buscar apenas as de tipo lvm e wc -l conta quantas linhas de lvm são
#LVMC é a contagem de lvm
LVMA="no"
#LVMA diz se está ativo ou não baseando-se se o número de lvm é maior que 0
if [ "$LVMC" > 0 ]
then
        LVMA="yes"
fi
#condição if em bash scripting
echo "lvm use: $LVMA"#-> Whether LVM is active or not

echo "Connexions TCP : $(netstat -ant | grep ESTABLISHED | wc -l) ESTABLISHED"#->The number of active connections
#netstat -ant lista as conexões tcp, o grep vai buscar as que têm ESTABLISHED e com wc -l conta quantas são

echo "User log: $(users | wc -w)"#->The number of users using the server
#users mostra os utelizadores ligados ao servidor e com wc -w contamos as palavras (utelizadores)

IP_MAC=$(ip a | grep ether | cut -d " " -f6)
#com ip a em conjunto com o grep ether conseguimos a linha onde está o endereço MAC
#com cut -d " " -f6 selecionamos a parte da string que queremos
echo "Network: IP $(hostname -I) (${IP_MAC})"#->The IPv4 address of your server and its MAC (Media Access Control) address
#hostname dá o nome do host e com -I obtemos o IP do server

echo "Sudo : $(journalctl _COMM=sudo | grep COMMAND | wc -l) cmd"#->The number of commands executed with the sudo program
#journalctl precisa de sudo antes, mas não é necessário se estiver no Root
#jornalctl _COMM=sudo | grep COMMAND lista todos os comandos sudo realizados pelos utilizadores
#wc -l conta quantos comandos estão listados
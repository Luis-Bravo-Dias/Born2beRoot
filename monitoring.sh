echo "Architecture: $(uname -a)"#-> The architecture of your operating system and its kernel version
#echo funciona como printf e o $ como o %
echo "CPU physical: $(grep -c processor /proc/cpuinfo)"#-> The number of physical processors
#grep procura a palavra processor no /proc/cpuinfo e -c conta quantas vezes aparece
echo "vCPU: $(nproc)"#-> The number of virtual processors
#nproc dá o número de processadores virtuais

LBOOT=$(uptime -s)
#uptime mostra há quanto tempo a maquina está ligada e -s mostra a data do último reboot
echo "Last boot: $(LBOOT::-3)"#-> The date and time of the last reboot
#com o comando ::-3 removemos os últimos 3 caracteres da string que correspondem aos segundos e o ponto de separação
LVMC=$(lsblk | grep lvm | wc -l)
#lsblk lista as partições, grep lvm vai buscar apenas as de tipo lvm e wc -l conta quantas linhas de lvm são
#LVMC é a contagem de lvm
LVMA="no"
#LVMA diz se está ativo ou não baseando-se se o número de lvm é maior que 0
if [ $LVMC > 0 ]
then
        $LVMA="yes"
fi
#condição if em bash scripting
echo "lvm use: $(LVMA)"#-> Whether LVM is active or not
echo "Connexions TCP : $(netstat -ant | grep ESTABLISHED | wc -l) ESTABLISHED"#->The number of active connections
#netstat -ant lista as conexões tcp, o grep vai buscar as que têm ESTABLISHED e com wc -l conta quantas são
echo "User log: $(users | wc -w)"#->The number of users using the server
#users mostra os utelizadores ligados ao servidor e com wc -w contamos as palavras (utelizadores)
echo "Network: IP $(hostname -I) ($(ip a | grep ether | cut -d " " -f6))"#->The IPv4 address of your server and its MAC (Media Access Control) address
#hostname dá o nome do host e com -I obtemos o IP do server
#com ip a em conjunto com o grep ether conseguimos a linha onde está o endereço MAC
#com cut -d " " -f6 selecionamos a parte da string que queremos
echo "Sudo : $(journalctl _COMM=sudo | grep COMMAND | wc -l) cmd"#->The number of commands executed with the sudo program
#journalctl precisa de sudo antes, mas não é necessário se estiver no Root
#jornalct _COMM=sudo | grep COMMAND lista todos os comandos sudo realizados pelos utilizadores
#wc -l conta quantos comandos estão listados
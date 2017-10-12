#SLAVE 2
#su - hduser
#ssh-keygen -t rsa -P ""
#cat $HOME/.ssh/id_rsa.pub >> $HOME/.ssh/authorized_keys
 
#probar conexiones
# 	ssh localhost
# 	exit

#CONFIGURAR n NODOS
echo "======== Autorizando conecciones SSH ========"
#				slave 1 (192.168.8.81)
#ssh-copy-id -i $HOME/.ssh/id_rsa.pub hduser@192.168.8.80
#ssh-copy-id -i $HOME/.ssh/id_rsa.pub hduser@192.168.8.82
#ssh-copy-id -i $HOME/.ssh/id_rsa.pub hduser@192.168.8.83
#				slave 2 (192.168.8.82)
ssh-copy-id -i $HOME/.ssh/id_rsa.pub hduser@192.168.8.80
ssh-copy-id -i $HOME/.ssh/id_rsa.pub hduser@192.168.8.81
ssh-copy-id -i $HOME/.ssh/id_rsa.pub hduser@192.168.8.83
#				slave 3 (192.168.8.83)
#ssh-copy-id -i $HOME/.ssh/id_rsa.pub hduser@192.168.8.80
#ssh-copy-id -i $HOME/.ssh/id_rsa.pub hduser@192.168.8.81
#ssh-copy-id -i $HOME/.ssh/id_rsa.pub hduser@192.168.8.82


#Probar conecciones SSH a cada nodo
# 	ssh hduser@192.168.8.X
# 	exit

#CONFIGURAR n NODOS
echo "======== Configurando el hostname ========"
#	slave 1 (192.168.8.81)
#sudo echo "slave1" > /etc/hostname
#sudo hostname slave1

#	slave 2 (192.168.8.82)
sudo echo "slave2" >> /etc/hostname
sudo hostname slave2

#	slave 3 (192.168.8.83)
#sudo echo "slave3" >> /etc/hostname
#sudo hostname slave3


#CONFIGURAR n NODOS
echo "======== Configurando los hosts a C/VM ========"
sed '/master/,$d' /etc/hosts  > temp  
mv temp /etc/hosts 
sudo echo "192.168.8.80 master" >> /etc/hosts 
sudo echo "192.168.8.81 slave1" >> /etc/hosts 
sudo echo "192.168.8.82 slave2" >> /etc/hosts 
sudo echo "192.168.8.83 slave3" >> /etc/hosts 

#=============================IPV6============================
if grep -q 'teamtux' '/etc/sysctl.conf';
 	then echo "OK >>> IPV6 ya fue Desactivando  ";
else
	echo "======== Desactivando IPV6 C/VM ========"
	sudo echo "#teamtux" >> /etc/sysctl.conf;
	sudo echo "net.ipv6.conf.all.disable_ipv6 = 1" >> /etc/sysctl.conf;
	sudo echo "net.ipv6.conf.default.disable_ipv6 = 1" >> /etc/sysctl.conf; 
	sudo echo "net.ipv6.conf.lo.disable_ipv6 = 1" >> /etc/sysctl.conf;
fi
#reiniciamos C/VM
echo "=========		REINICIAR		========="
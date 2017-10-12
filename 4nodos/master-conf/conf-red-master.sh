#su - hduser
echo "======== acceso SSH ========"
#ssh-keygen -t rsa -P ""
#cat $HOME/.ssh/id_rsa.pub >> $HOME/.ssh/authorized_keys
#probar conexiones
# 	ssh localhost
# 	exit

#CONFIGURAR n NODOS
echo "======== Autorizando conecciones SSH ========"
ssh-copy-id -i $HOME/.ssh/id_rsa.pub hduser@192.168.8.81
ssh-copy-id -i $HOME/.ssh/id_rsa.pub hduser@192.168.8.82
ssh-copy-id -i $HOME/.ssh/id_rsa.pub hduser@192.168.8.83

#Probar conecciones SSH a cada nodo
# 	ssh hduser@192.168.8.X
# 	exit

echo "======== Configurando el hostname ========"
sudo echo "master" > /etc/hostname #chancar contenido con "master"
sudo hostname master


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
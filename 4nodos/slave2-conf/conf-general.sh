#se tiene encuenta que java y ssh estan instalados

#    Maquina Master: 192.168.8.80
#    Maquina Slave1: 192.168.8.81
#    Maquina Slave2: 192.168.8.82
#    Maquina Slave3: 192.168.8.83
#
#sudo add-apt-repository ppa:openjdk-r/ppa
#sudo apt-get update
#sudo apt-get install openjdk-8-jdk

echo "==============Version de java=============="
#java -version
javac -version
echo "==============    NUEVO USUARIO   =============="
sudo addgroup hadoop
sudo adduser --ingroup hadoop hduser --gecos "" --disabled-password   #--gecos "name,room,phone,.."
echo "hduser:tux" | sudo chpasswd #asignar pass
sudo adduser hduser sudo #permisos
echo "==============="
echo "USER: hduser"
echo "PASS: tux"
echo "==============="
echo "========PERMISOS TOTALES /opt/======="
sudo chmod 777 -R /opt/
#su - hduser
#exit
#sudo apt-get install ssh

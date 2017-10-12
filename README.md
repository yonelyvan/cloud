## PREREQUISITOS
##### Primero se debe instalar JAVA , SSH	y copiar hadoop en  /opt/hadoop-2.7.3/
```shell
sudo apt-get update
sudo add-apt-repository ppa:openjdk-r/ppa
sudo apt-get install openjdk-8-jdk
sudo apt-get install ssh
```
### archivos de configuración:
- **conf-general.sh** (master y slaves): 
Copiar al directorio home del usuario con q se inicio secion

- **conf-red-master.sh** y **conf-hadoop-master.sh** (master): 
Copiar al directorio home de hduser

- **conf-red-slave.sh**  y **conf-hadoop-slave.sh** (slaves) :
Copiar al directorio home de hduser segun corresponda el nodo(slave1,slave2,slave3)
## MASTER Y SLAVES
- para cada nodo sin importar si es master o slave
```shell
sudo sh conf-general.sh
```
- se obtiene: **usuario**: hduser **contraseña**:	tux
```shell
$ su - hduser
$ ssh-keygen -t rsa -P ""
$ cat $HOME/.ssh/id_rsa.pub >> $HOME/.ssh/authorized_keys
```
### CONFIGURACION RED
##### Red master
```shell
$ su - hduser
$ sudo sh conf-red-master.sh
```
-reiniciar
##### Red slave
-para cada slave
```shell
su - hduser
sudo sh conf-red-slave.sh
```
> probar conexiones ssh para cada nodo <br>
> $ ssh hduser@slaveX  (X={1,2,3}) <br>
> **REINICIAR** <br>
### CONFIGURACION HADOOP
##### hadoop master
```shell
su - hduser
sudo conf-hadoop-master.sh
```
#### hadoop slave
```shell
su - hduser
sudo conf-hadoop-slave.sh
```
### ejecucion master
```shell
$ hdfs namenode -format
$ start-dfs.sh
$ jps
$ start-yarn.sh
--ver: 	192.168.8.80:50070
$ stop-dfs.sh && stop yarn.sh
```

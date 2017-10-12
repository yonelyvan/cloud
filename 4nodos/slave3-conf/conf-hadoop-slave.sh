#$ su - hduser
echo "=========Configurando Hadoop=========";
if grep -q 'teamtux' '~/.bashrc';
 	sudo source ~/.bashrc;
  then echo "OK >>>";
else
 	sudo echo 	'#teamtux
				#HADOOP VARIABLES START
				export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
				export HADOOP_INSTALL=/opt/hadoop-2.7.3
				export PATH=$PATH:$HADOOP_INSTALL/bin
				export PATH=$PATH:$HADOOP_INSTALL/sbin
				export HADOOP_MAPRED_HOME=$HADOOP_INSTALL
				export HADOOP_COMMON_HOME=$HADOOP_INSTALL
				export HADOOP_HDFS_HOME=$HADOOP_INSTALL
				export YARN_HOME=$HADOOP_INSTALL
				export HADOOP_COMMON_LIB_NATIVE_DIR=$HADOOP_INSTALL/lib/native
				export HADOOP_OPTS="-Djava.library.path=$HADOOP_INSTALL/lib"
				#HADOOP VARIABLES END' >>  ~/.bashrc;
	sudo source ~/.bashrc;
fi
#===============================
if grep -q 'teamtux' '/opt/hadoop-2.7.3/etc/hadoop/hadoop-env.sh';
 	then echo "OK >>>";
else
 	sudo echo '#teamtux' >>  /opt/hadoop-2.7.3/etc/hadoop/hadoop-env.sh;
	sudo echo 'export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64' >>  /opt/hadoop-2.7.3/etc/hadoop/hadoop-env.sh;
	sudo echo 'export HADOOP_OPTS=-Djava.net.preferIPv4Stack=true' >>  /opt/hadoop-2.7.3/etc/hadoop/hadoop-env.sh;
fi
#==============================================================
#Generamos una carpeta para datos temporales
echo "========= carpetas tmp ========="
if [ -d '/app/hadoop/tmp' ]; #existe directorio?
  then sudo rm -R -f '/app/hadoop/tmp';
  sudo mkdir -p /app/hadoop/tmp;
  sudo chown hduser:hadoop /app/hadoop/tmp;
  echo "carpetas ELIMINADAS y CREADAS";
else
  sudo mkdir -p /app/hadoop/tmp;
  sudo chown hduser:hadoop /app/hadoop/tmp;
  echo "carpetas creadas";
fi
#==============================================================
echo "CONFIGURANDO core-site.xml";
#/opt/hadoop-2.7.3/etc/hadoop/core-site.xml
cd /opt/hadoop-2.7.3/etc/hadoop/
sed '/<configuration>/,$d' core-site.xml > temp.xml
mv temp.xml core-site.xml

echo '<configuration>
 <property>
  <name>hadoop.tmp.dir</name>
  <value>/app/hadoop/tmp</value>
  <description>A base for other temporary directories.</description>
 </property>
 <property>
  <name>fs.default.name</name>
  <value>hdfs://master:54310</value>
  <description>The name of the default file system.</description>
 </property>
 <property>
  <name>dfs.permissions</name>
  <value>false</value>
 </property>
</configuration>' >> core-site.xml;
cd
#==============================================================
echo "========= carpetas para namenode y datanode ========="
if [ -d '/opt/hadoop-2.7.3/hadoop_store/hdfs/namenode' ]; #existe directorio?
	then rm -R -f '/opt/hadoop-2.7.3/hadoop_store/hdfs/namenode';
	rm -R -f '/opt/hadoop-2.7.3/hadoop_store/hdfs/datanode';
  sudo mkdir -p /opt/hadoop-2.7.3/hadoop_store/hdfs/namenode
  sudo mkdir -p /opt/hadoop-2.7.3/hadoop_store/hdfs/datanode
  sudo chown -R hduser:hadoop /opt/hadoop-2.7.3/hadoop_store
  echo "namenode y datanode ELIMINADOS y CREADOS"
else
	sudo mkdir -p /opt/hadoop-2.7.3/hadoop_store/hdfs/namenode
	sudo mkdir -p /opt/hadoop-2.7.3/hadoop_store/hdfs/datanode
	sudo chown -R hduser:hadoop /opt/hadoop-2.7.3/hadoop_store
  echo "namenode y datanode CREADOS"
fi
#==============================================================
echo "CONFIGURANDO hdfs-site.xml";
#/opt/hadoop-2.7.3/etc/hadoop/hdfs-site.xml
cd /opt/hadoop-2.7.3/etc/hadoop/
sed '/<configuration>/,$d' hdfs-site.xml > temp.xml
mv temp.xml hdfs-site.xml

echo '<configuration>
 <property>
  <name>dfs.replication</name>
  <value>3</value>
  <description>Default block replication.</description>
 </property>
 <property>
  <name>dfs.permissions</name>
  <value>false</value>
 </property>
 <property>
   <name>dfs.namenode.name.dir</name>
   <value>file:/opt/hadoop-2.7.3/hadoop_store/hdfs/namenode</value>
 </property>
 <property>
   <name>dfs.datanode.data.dir</name>
   <value>file:/opt/hadoop-2.7.3/hadoop_store/hdfs/datanode</value>
 </property>
</configuration>' >> hdfs-site.xml
cd
#==============================================================
#sudo?
if [ -f '/opt/hadoop-2.7.3/etc/hadoop/mapred-site.xml' ]; #existe?
	then echo "OK mapred-site.xml >>> " 
else
	cp /opt/hadoop-2.7.3/etc/hadoop/mapred-site.xml.template /opt/hadoop-2.7.3/etc/hadoop/mapred-site.xml
fi
#==============================================================
echo "CONFIGURANDO mapred-site.xml"
#/opt/hadoop-2.7.3/etc/hadoop/mapred-site.xml
cd /opt/hadoop-2.7.3/etc/hadoop/
sed '/<configuration>/,$d' mapred-site.xml > temp.xml
mv temp.xml mapred-site.xml

echo '<configuration>
 <property>
  <name>mapred.job.tracker</name>
  <value>master:54311</value>
  <description>The host and port that the MapReduce job tracker runs
  at</description>
 </property>
 <property>
  <name>mapreduce.framework.name</name>
  <value>yarn</value>
 </property>
</configuration>' >> mapred-site.xml
cd
#==============================================================
echo "CONFIGURANDO yarn-site.xml"
#/opt/hadoop-2.7.3/etc/hadoop/yarn-site.xml
cd /opt/hadoop-2.7.3/etc/hadoop/
sed '/<configuration>/,$d' yarn-site.xml > temp.xml
mv temp.xml yarn-site.xml

echo '<configuration>
 <property>
  <name>yarn.nodemanager.aux-services</name>
  <value>mapreduce_shuffle</value>
 </property>
 <property>
  <name>yarn.nodemanager.aux-services.mapreduce_shuffle.class</name>
  <value>org.apache.hadoop.mapred.ShuffleHandler</value>
 </property>
 <property>
  <name>yarn.resourcemanager.resource-tracker.address</name>
  <value>master:8025</value>
 </property>
 <property>
  <name>yarn.resourcemanager.scheduler.address</name>
  <value>master:8030</value>
 </property>
 <property>
  <name>yarn.resourcemanager.address</name>
  <value>master:8050</value>
 </property>
</configuration>' >> yarn-site.xml
cd
#==============================================================
#CONFIGURAR n NODOS ---- (DESCOMENTAR el que corresponde)
#sudo echo "slave1" > /opt/hadoop-2.7.3/etc/hadoop/slaves
#sudo echo "slave2" >> /opt/hadoop-2.7.3/etc/hadoop/slaves
sudo echo "slave3" >> /opt/hadoop-2.7.3/etc/hadoop/slaves
#==============================================================
echo "========PERMISOS TOTALES /opt/======="
sudo chmod 777 -R /opt/
echo "============================================"
echo "MASTER: configuracion terminada"
echo "Iniciar Hadoop MultiNode"
echo "hdfs namenode -format , start-dfs" 
echo "============================================"

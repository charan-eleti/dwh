: set ff=unix
#!/bin/bash -e
hive2server=jdbc:hive2://headnodehost:10001/yetitest?hive.server2.transport.mode=http
blobpath=wasb://yetidatalake01@yetidatalake01.blob.core.windows.net/spark05/hive_backup/default
mkdir -p /home/yeti/Spark05_archive/hive_backup/logs/export/default
logpath=/home/yeti/Spark05_archive/hive_backup/logs/export/default
mkdir -p /home/yeti/Spark05_archive/hive_backup/hivetables
filepath=/home/yeti/Spark05_archive/hive_backup/hivetables

<<COMMENT1
echo "Spark04:Default:finding tables on default database `date` ";
hive -S -e "use default;show tables;" > $filepath/default
COMMENT1

while read line
do
i=`echo $line | awk '{print $1}'`
(
beeline -u $hive2server -e "export table default.$i to '$blobpath/$i';" >$logpath/$i 2>&1 && 
	(cat $logpath/$i && echo -e "Spark05:hive table $i exported to $blobpath/$i") ||
	((cat $logpath/$i && echo -e "Spark05:$i:Failed to export Hive table $i to $blobpath/$i") | mail -s "Spark05:Failed to export Hive table $i" areddy@yeticoolers.com)
)
done<$filepath/default

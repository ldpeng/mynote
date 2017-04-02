CURRENT=`/bin/date +%y%m%d`

#/itcast/hadoop-2.4.1/bin/hadoop jar /home/hadoop/cleaner.jar /flume/$CURRENT /cleaned/$CURRENT

#/itcast/apache-hive-0.13.0-bin/bin/hive -e "alter table hmbbs add partition (logdate=$CURRENT) location '/cleaned/$CURRENT'"

#/itcast/apache-hive-0.13.0-bin/bin/hive -e "select count(*) from hmbbs where logdate = $CURRENT"

#/itcast/apache-hive-0.13.0-bin/bin/hive -e "select count(distinct ip) from hmbbs where logdate = $CURRENT"

#/itcast/apache-hive-0.13.0-bin/bin/hive -e "select count(*) from hmbbs where logdate = $CURRENT and instr(url, 'member.php?mod=register')>0;"

#/itcast/apache-hive-0.13.0-bin/bin/hive -e "create table vip_$CURRENT row format delimited fields terminated by '\t' as select ip, count(*) as vtimes from hmbbs where logdate = $CURRENT  group by ip having vtimes >= 50 order by vtimes desc limit 20"

/itcast/sqoop-1.4.4/bin/sqoop export --connect jdbc:mysql://192.168.1.100:3306/itcast --username root --password 123 --export-dir "/user/hive/warehouse/vip_$CURRENT" --table vip --fields-terminated-by '\t'








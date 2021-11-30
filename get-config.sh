#!/usr/bin/env bash

hosts=(10.10.0.1_mik0.host_22 \
       10.10.1.1_mik1.host_22 \
       10.10.2.1_mik2.host_22 \
       10.10.3.1_mik3.host_22 \
       10.10.4.1_mik4.host_22 \
       10.10.5.1_mik5.host_22 \
       10.10.6.1_mik6.host_22 \
       10.10.7.1_mik7.host_22 \
       10.10.8.1_mik8.host_22 \
       10.10.9.1_mik9.host_22 )
# bash array of values. All values are arrays too, after remove splitter "_".# Sub array content IP_ZABBIX-HOSTNAME_SSH-DAEMON-PORT
cdate=`date +%d-%m-%Y` # System date
dir="/mik_backup/"# Storage for backups
cmd="/system backup save name=backup; export file=backup.rsc hide-sensitive"# command that do the preparation of backup
username="user"# SSH user
zabbix_hp=(10.151.48.126 10051) # IP then PORT
age="30"# remove all backups older then 30 days
itemname="backup"# zabbix item
error_value="1"# error value for trigger
value="0"# good value =)for host in${hosts[*]}# Get values from main listdo
hostname=($(echo${host} | tr "_"" ")) # Get values from sub list
ssh ${username}@${hostname[0]} -o "StrictHostKeyChecking no" -p${hostname[2]}"${cmd}"
new_dir="${HOME}${dir}${hostname[1]}/${cdate}"
mkdir -p ${new_dir}
scp -P${hostname[2]}${username}@${hostname[0]}:backup.backup  ${new_dir}
scp -P${hostname[2]}${username}@${hostname[0]}:backup.rsc ${new_dir}
check=`find ${new_dir} -type f -name backup.*`
if [ "${check}" == "" ]
then
zabbix_sender -z ${zabbix_hp[0]} -p ${zabbix_hp[1]} -s ${hostname[1]} -k ${itemname} -o ${error_value}else
zabbix_sender -z ${zabbix_hp[0]} -p ${zabbix_hp[1]} -s ${hostname[1]} -k ${itemname} -o ${value}fidone
find ${HOME}${dir} -mindepth 2 -mtime ${age} -type d -exec rm -rf {} \; #clear dirs

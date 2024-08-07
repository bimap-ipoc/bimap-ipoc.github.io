#!/bin/bash
export LC_ALL=C
#################################################
########             set env             ########
#################################################
# crontab -e
Host=`hostname`
Yesterday=$(perl -MPOSIX -le 'print strftime "%Y%m%d", localtime(time()-86400)')
HourAgo=$(perl -MPOSIX -le 'print strftime "%Y%m%d%H", localtime(time()-3600)')
LogDir="/home/awr_to_local"
BackupDir=$LogDir/BACKUP
RetentionDays=7
#################################################
########         collect command         ########
#################################################
cd $LogDir
$ORACLE_HOME/bin/sqlplus 'sys/oracle@pdb1 as sysdba'<<EOF # 需修改
set serveroutput on
spool $LogDir/master_awr_control.sql
@$LogDir/custom.sql $HourAgo
spool off;
set heading off
set pages 50000
set linesize 1500
set trimspool on
set trimout on
set term off
set verify off;
set feedback off;
@$LogDir/master_awr_control.sql
EXIT;
EOF
rm $LogDir/master_awr_control.sql
#################################################
########    put awr file to ftpserver    ########
#################################################
mv $LogDir/*.html $BackupDir

if [ ! -d $BackupDir ]; then mkdir $BackupDir; fi

#################################################
########          zip and backup         ########
#################################################
# 1. 將昨日24個檔案壓縮為一個tar.gz
cd $BackupDir
if ls *$Yesterday*.html 1> /dev/null 2>&1; then
    # 如果存在，將該檔案壓縮起來
    tar -czvf `hostname`"-"$Yesterday.tar.gz *$Yesterday*.html && rm -rf *$Yesterday*.html
fi

# 2. 根據RetentionDays定期將檔案清除
# find $BackupDir/*.tar.gz -maxdepth 1 -mtime +$RetentionDays -type f -delete
exit




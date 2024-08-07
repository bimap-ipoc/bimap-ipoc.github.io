#!/bin/bash
set -x
export LC_ALL=C
export ORACLE_HOME=/u01/app/oracle/product/19.3.0/dbhome_1
#################################################
########             set env             ########
#################################################
# crontab -e
# 10 * * * * sh /home/colt/awr_hourly.sh
Host=`hostname`
Today=`date +%y%m%d`
Yesterday=$(perl -MPOSIX -le 'print strftime "%Y%m%d", localtime(time()-86400)')
HourAgo=$(perl -MPOSIX -le 'print strftime "%Y%m%d%H%S", localtime(time()-7500)')
LogDir="/home/oracle/awrrpt"
SentDir=$LogDir/SENT
BackupDir=$LogDir/BACKUP
FTPURL='51.15.225.188'
FTPUSER='bimap_test'
FTPPASS='#EDC4rfv'
RetentionDays=7
#################################################
########         collect command         ########
#################################################
cd $LogDir
$ORACLE_HOME/bin/sqlplus 'sys/oracle@pdb1 as sysdba'<<EOF
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

# 重新命名 pdb1 且移動到 SENT 資料夾
rename orcl orcl-pdb1 orcl*.html && mv $LogDir/*.html $SentDir

$ORACLE_HOME/bin/sqlplus 'sys/oracle@pdb2 as sysdba'<<EOF
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

# 重新命名 pdb2 且移動到 SENT 資料夾
rename orcl orcl-pdb2 orcl*.html && mv $LogDir/*.html $SentDir

rm $LogDir/master_awr_control.sql
#################################################
########    put awr file to ftpserver    ########
#################################################

if [ ! -d $SentDir ] ; then
    mkdir $SentDir
fi
if [ ! -d $BackupDir ] ; then
    mkdir $BackupDir
fi

cd $SentDir
ftp -inv $FTPURL << EOF > $LogDir/ftplog.txt
user $FTPUSER $FTPPASS
cd oracle_bimaplnx06
binary
pwd
mput *
bye
EOF

# 如果FTP上傳成功，就移動至BACPUP檔案夾
msg=`grep "complete" $LogDir/ftplog.txt`
if [ -n "$msg" ]
    then
    mv $SentDir/*.html $BackupDir
    echo "ftp upload complete"
else
    echo "ftp upload failed"
fi
rm -rf $LogDir/ftplog.txt
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
find $BackupDir/*.tar.gz -maxdepth 1 -mtime +$RetentionDays -type f -delete
exit


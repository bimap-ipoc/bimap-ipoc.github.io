#!/bin/sh
#set env
#. /ub02/XXX/work/.profile
# /usr/bin/su/ - su oraedv -c /home/colt_dev/ipoc_conn_curl.sh

#!/bin/ksh
ORACLE_HOME=/oracle/EDV/112_64
COLT_HOME=/home/colt_dev
AUTH_FILE='/home/colt_dev/account.csv'
Host=`hostname`
API='http://172.19.11.135:8700/api/v1/set-alert'

#################################################
########        connected database       ########
#################################################
declare -a failed_dbs=()
#failed_dbs+=("bbbb")
#echo $failed_dbs[@]}
#failed_dbs=()

cd $COLT_HOME
while IFS=',' read -r username password sid
do
    echo "exit" | $ORACLE_HOME/bin/sqlplus -L $username/$password@$sid | grep Connected > /dev/null
    if [ $? -eq 0 ] 
    then
        echo "OK"
    else
        echo "NOT OK"
        failed_dbs+=('"'$sid'"')
    fi
done < $AUTH_FILE

echo "failed_dbs ===>"
echo ${failed_dbs[@]}

data=$(IFS=','; echo "${failed_dbs[*]}")

# curl api
curl --location --request POST $API \
--header 'Content-Type: application/json' \
--data-raw '{ "source": "oracle_connection","name": ['$data']}'

exit


#!/bin/sh

current_date=$(date +"%F %T")
logname=/logs/$(date +"%F-%H%M").log
generalsummary=/logs/history.log
lastfilerun=/logs/lastfilescopied.log
lastsuccrun=/logs/lastsuccessrun.log


POSTFIX_SERVER=${POSTFIX_SERVER:-"postfix"}
FROM_ADDRESS=${FROM_ADDRESS:-"noreply@eea.europa.eu"}

set -o pipefail

flag=-v
if [ -n "$DEBUG" ]; then
   flag=-vv
fi

#configure email

sed -i "s/.*mailhub=.*/mailhub=$POSTFIX_SERVER/" /etc/ssmtp/ssmtp.conf
sed -i "s/.*rewriteDomain=.*/rewriteDomain=eea.europa.eu/" /etc/ssmtp/ssmtp.conf
if [ $(grep ^FromLineOverride /etc/ssmtp/ssmtp.conf | wc -l ) -eq 0 ]; then
      echo "FromLineOverride=YES" >> /etc/ssmtp/ssmtp.conf
fi


rclone sync $flag remote:$SOURCE_DIRECTORY $TARGET_DIRECTORY 2>&1 | tee -a $logname

if [ $? -ne 0 ]; then
        echo "Sync command executed with ERROR, sending email"
	sendmail -f ${FROM_ADDRESS} ${TO_ADDRESS}  <<EOF
From: ${FROM_ADDRESS}
Subject: ERROR copernicus landfiles sync on $(hostname)

$(cat $logname)
EOF
        exit 1
else
        echo "Command finished with success" >> $logname
        echo "Last sync with transferred files on - $current_date" > $lastsuccrun
        grep -E '^Transferred:|^Errors:|^Checks:|^Elapsed time:' $logname >> $lastsuccrun

fi

echo "=====================================" >> $generalsummary
echo "$current_date" >> $generalsummary

grep -E '^Transferred:|^Errors:|^Checks:|^Elapsed time:' $logname >> $generalsummary

echo "Added general summary"

if [ $(grep '^Transferred' $logname | grep ETA | grep -v 'ETA -' | wc -l) -eq 1 ]; then
	echo "Sync transferred files"
	echo "Last sync with transferred files on - $current_date" > $lastfilerun
	grep -E '^Transferred:|^Errors:|^Checks:|^Elapsed time:' $logname >> $lastfilerun
else
	echo "Sync finished without transferring any new files"
fi

if [ -n "$ALLWAYS_SEND_EMAIL" ]; then
               sendmail -f ${FROM_ADDRESS} ${TO_ADDRESS}  <<EOF
From: ${FROM_ADDRESS}
Subject: INFO copernicus landfiles sync summary on $(hostname)

Last run summary:
$(cat $lastsuccrun)
=========================================
$(cat $lastfilerun)
=========================================
EOF
fi


duration=$(grep -E '^Elapsed time:' $logname | awk '{print $3}')

HOURS_MAX_DURATION=${HOURS_MAX_DURATION:-6}

var=$(echo $duration | grep -o -E '[0-9.]+')
nr=$(echo $duration | grep -o -E '[0-9.]+' | wc -l)
sum=0
for i in $var; do
  if [ $nr -eq 4 ]; then 
	  let sum=$sum+24*$i;
  fi 
  if [ $nr -eq 3 ]; then
	  let sum=$sum+$i;
  fi
  let nr=$nr-1
done

if [ $sum -gt $HOURS_MAX_DURATION ];then
	echo "Sync duration is more than $HOURS_MAX_DURATION hours, will send email"
        sendmail -f ${FROM_ADDRESS} ${TO_ADDRESS}  <<EOF
From: ${FROM_ADDRESS}
Subject: WARNING copernicus-land landfiles sync takes too long on $(hostname)

$(cat $logname)
EOF

fi


HOURS_WITHOUT_RUN=${HOURS_WITHOUT_RUN:-24}
let mins=60*$HOURS_WITHOUT_RUN

if [ $(grep "Command finished with success" $(find /logs -type f -mmin -$mins) | wc -l) -eq 0 ]; then
          echo "No succesfull runs in the last $HOURS_WITHOUT_RUN hours, will send email"
          sendmail -f ${FROM_ADDRESS} ${TO_ADDRESS}  <<EOF
From: ${FROM_ADDRESS}
Subject: ERROR No copernicus landfiles syncs in $HOURS_WITHOUT_RUN h on $(hostname)

$(cat $logname)
EOF

fi



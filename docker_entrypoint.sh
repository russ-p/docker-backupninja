#!/bin/bash

# apply conf
conf()
{
  BN_WHEN=${WHEN:-"everyday at 01:00"}
  BN_REPORT_EMAIL=${REPORT_EMAIL:-"root"}

  echo "Apply configuration:"
  echo "  when = $BN_WHEN"
  echo "  reportemail = $BN_REPORT_EMAIL"
  sed -i "s|when =.*|when = $BN_WHEN|i" /etc/backupninja.conf
  sed -i "s|reportemail =.*|reportemail = $BN_REPORT_EMAIL|i" /etc/backupninja.conf

  if [ ! -z "${SMTP_SERVER:-}" ]; then
    echo "  smtp = ${SMTP_SERVER}:${SMTP_PORT}"
    echo "  user = ${SMTP_USER_NAME}"
    echo "
root=${SMTP_USER_NAME}
mailhub=${SMTP_SERVER}:${SMTP_PORT}
hostname=${SMTP_SERVER}:${SMTP_PORT}
UseSTARTTLS=${SMTP_ENABLE_STARTTLS}
AuthUser=${SMTP_USER_NAME}
AuthPass=${SMTP_PASSWORD}
FromLineOverride=YES" > /etc/ssmtp/ssmtp.conf
  fi
}

fix_perm()
{
  chown root    /etc/ssmtp/ssmtp.conf 
	chmod 600     /etc/ssmtp/ssmtp.conf
  chown root    /etc/backupninja.conf 
	chmod 600     /etc/backupninja.conf 
  chown root -R /etc/backup.d/
	chmod 600  -R /etc/backup.d/  
	chmod 700     /etc/backup.d 
}

# run once
run_now()
{
    /usr/sbin/backupninja --now --debug
}

# run once
run_test()
{
    /usr/sbin/backupninja --now --test --debug
}

# run, sleep and run again
run_and_sleep()
{
  while :
  do
    sleep_until_00
    /usr/sbin/backupninja
  done
}

sleep_until_00()
{
  local seconds=$(( (60 - `date +%M`) * 60))
  echo "[$(date)] I'm sleeping for $seconds seconds"
  sleep $seconds
}

# run cron
# https://stackoverflow.com/questions/37458287/how-to-run-a-cron-job-inside-a-docker-container
run_cron()
{
  crontab /etc/cron.d/backupninja
  touch /var/log/cron.log
  cron && tail -f /var/log/cron.log 
}

# help message
print_help()
{
    echo "now  - run now"
    echo "test - test run"
    echo "run  - run and wait - as daemon"
    echo "Backupninja help:"
    /usr/sbin/backupninja --help
}

conf
fix_perm

case $1 in
  now)   run_now       ;;
  run)   run_and_sleep ;;
  cron)  run_cron      ;;
  test)  run_test      ;;
  *)     print_help    ;;
esac

echo $1
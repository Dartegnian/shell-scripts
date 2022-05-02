#! /bin/sh

date_today=$(date +'%Y-%m-%d')
death_date='2034-01-19'

days_remaining=$(( ($(date -d $death_date +%s) - $(date -d $date_today +%s)) / 86400 ))
formatted_days=$(echo $days_remaining | sed ':a;s/\B[0-9]\{3\}\>/,&/;ta')

echo $formatted_days 'days'
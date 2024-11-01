#! /bin/bash


raw_data=raw_data_$(date -u +%Y%m%d)

curl wttr.in/casablanca -o /home/kali/Documents/project/$raw_data

grep °C $raw_data > temperatures.txt

obs_tmp=$(head -n 1 temperatures.txt | xargs | rev | cut -d ' ' -f 2 | rev)

fc_tmp=$(head -n 3 temperatures.txt | tail -n 1 | cut -d 'C' -f 2 | xargs | rev | cut -d ' ' -f 2 | rev)

rm temperatures.txt

day=$(TZ='Morocco/Casablanca' date -u +%d)
month=$(TZ='Morocco/Casablanca' date -u +%m)
year=$(TZ='Morocco/Casablanca' date -u +%Y)

echo -e "$year\t$month\t$day\t$obs_tmp\t$fc_tmp" >> rx_poc.log 

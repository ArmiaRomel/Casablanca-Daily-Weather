# Casablanca Daily Weather ETL Process

This project automates the extraction, transformation, and loading (ETL) of daily weather data for Casablanca, Morocco. Each day at noon (local time), the script gathers both the actual temperature and the temperature forecasted for the following day at noon, using the open-source weather service [wttr.in](https://github.com/chubin/wttr.in).

## Project Overview

1. **Objective**: Automate daily retrieval of current and forecasted weather data for Casablanca, Morocco, and log it for further analysis and reporting.

2. **Data Source**: Weather data is sourced from [wttr.in](https://github.com/chubin/wttr.in), a simple text-based weather information provider.

3. **Shell Script Breakdown**:
   - The script performs the ETL process in four main steps: data extraction, data filtering, transformation, and logging. Below is the detailed process:

## Process

1. **Data Extraction**  
   The script retrieves Casablanca’s daily weather data at noon UTC using the following `curl` command:
   ```bash
   curl wttr.in/casablanca -o /home/kali/Documents/project/raw_data_$(date -u +%Y%m%d)
   ```
   This command saves the raw weather data in a file named with the date format YYYYMMDD to ensure unique and organized daily files.

2. **Data Filtering**
   After downloading, the script uses grep to isolate temperature values, filtering out unnecessary data:
   ```bash
   grep °C $raw_data > temperatures.txt
   ```
   This command extracts lines containing temperature information and stores them in a temporary temperatures.txt file.

3. **Data Transformation**
- **Observed Temperature**: The script extracts the current temperature at noon and formats it for logging:
   ```bash
   obs_tmp=$(head -n 1 temperatures.txt | xargs | rev | cut -d ' ' -f 2 | rev)
   ```
- **Forecasted Temperature**: The script then extracts the forecasted temperature for the following noon using:
  ```bash
  fc_tmp=$(head -n 3 temperatures.txt | tail -n 1 | cut -d 'C' -f 2 | xargs | rev | cut -d ' ' -f 2 | rev)
  ```
- Temporary files are removed after transformation:
  ```bash
  rm temperatures.txt
  ```

4. **Date Formatting and Logging**
   Casablanca’s local date format (day, month, and year) is retrieved, and the formatted data (year, month, day, observed, and forecasted temperatures) is appended to a log file:
   ```bash
   day=$(TZ='Morocco/Casablanca' date -u +%d)
   month=$(TZ='Morocco/Casablanca' date -u +%m)
   year=$(TZ='Morocco/Casablanca' date -u +%Y)

   echo -e "$year\t$month\t$day\t$obs_tmp\t$fc_tmp" >> rx_poc.log
   ```

5. **Scheduling**
   To ensure data is logged daily at Casablanca’s noon, the script uses a cron job. With Casablanca’s local time zone being UTC+1 and the machine’s default time zone in EDT (UTC-5), a 5-hour difference is accounted for by setting the cron job to execute at 7:00 AM EDT:
   ```bash
   0 7 * * * /path/to/script.sh
   ```

6. **Output**
   The final output is stored in a log file (`rx_poc.log`), with each entry in the format:
   ```sql
   year   month   day   observed_temperature   forecasted_temperature
   ```

## Example Log File Entry
```yaml
2024    11      01      18      21
```

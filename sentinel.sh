#!/bin/zsh

echo "--- STARTING SENTINEL... --"

echo "--- Starting basic system health checks ---"
diskUsage=$(df -h | awk 'NR > 1 && $5 ~ /%$/ && $5 > "50%" {print $0}')
echo "${diskUsage}"

cpuLoad=$(uptime | awkf "load averages:")

availableMemory=$()

echo "--- basic system health checks are finished ---"

echo "--- Starting advanced services checks "




echo "--- Compiling the ---"








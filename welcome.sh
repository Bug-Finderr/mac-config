#!/bin/bash

# Define colors from Catppuccin Mocha theme
blue="\033[38;5;110m"
lavender="\033[38;5;147m"
pink="\033[38;5;176m"
reset="\033[0m"

# Gather system stats
active_memory=$(vm_stat | grep 'Pages active' | awk '{print int($3*4096/1024/1024 + 0.5)}')
total_memory=$(sysctl -n hw.memsize | awk '{print int($1/1024/1024)}')
memory_load=$((active_memory * 100 / total_memory))
cpu_usage=$(top -l 1 | grep -E "^CPU" | awk '{print $3+$5"%"}')
battery_status=$(pmset -g batt | grep -o 'charging\|discharging\|charged')
battery_percentage=$(pmset -g batt | grep -o '[0-9]\+%')
remaining_time=$(pmset -g batt | grep -o '[0-9:]\+ remaining' | cut -d' ' -f1)

# Format battery time remaining
if [[ "$battery_status" == "discharging" && -n "$remaining_time" && "$remaining_time" != "0:00" ]]; then
  battery_time="($remaining_time remaining)"
else
  battery_time=""
fi

# Display the welcome message
echo ""
echo -e "${blue}Memory:${reset} ${active_memory}MB (${memory_load}%)   ${lavender}CPU Usage:${reset} ${cpu_usage}   ${pink}Battery:${reset} ${battery_percentage} ${battery_status} ${battery_time}"
echo ""
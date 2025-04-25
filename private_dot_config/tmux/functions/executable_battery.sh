#!/bin/bash

FULL_HEART='󰣐 '
HALF_HEART='󰛞 '
EMPTY_HEART='󱢠 '

os=$(uname)

# Check if argument is provided for testing
if [[ $# -eq 1 && "$1" =~ ^[0-9]+$ ]]; then
  percentage=$1
elif [[ $(uname) == 'Linux' ]]; then
  percentage=$(acpi | cut -d ' ' -f 4 | sed 's/[^0-9].*//')
else
  battery_info=$(ioreg -rc AppleSmartBattery)
  current_charge=$(echo $battery_info | grep -o '"CurrentCapacity" = [0-9]\+' | awk '{print $3}')
  total_charge=$(echo $battery_info | grep -o '"MaxCapacity" = [0-9]\+' | awk '{print $3}')
  percentage=$((current_charge * 100 / total_charge))
fi

# naively checks if this is desktop or laptop
if [[ "${os}" == 'Darwin' || "$(ls -A /sys/class/power_supply/ 2>/dev/null)" ]]; then
  
  if [[ $percentage -lt 10 ]]; then
    # 0-9%: Show 5 red empty hearts
    output="#[fg=colour9]$EMPTY_HEART$EMPTY_HEART$EMPTY_HEART$EMPTY_HEART$EMPTY_HEART"
  elif [[ $percentage -lt 20 ]]; then
    # 10-19%: Show a half heart
    output="#[fg=colour9]$HALF_HEART#[fg=white]$EMPTY_HEART$EMPTY_HEART$EMPTY_HEART$EMPTY_HEART"
  elif [[ $percentage -lt 30 ]]; then
    # 20-29%: Show one full heart 
    output="#[fg=colour9]$FULL_HEART#[fg=white]$EMPTY_HEART$EMPTY_HEART$EMPTY_HEART$EMPTY_HEART"
  elif [[ $percentage -lt 40 ]]; then
    # 30-39%: Show one full heart and one half heart
    output="#[fg=colour9]$FULL_HEART$HALF_HEART#[fg=white]$EMPTY_HEART$EMPTY_HEART$EMPTY_HEART"
  elif [[ $percentage -lt 50 ]]; then
    # 40-49%: Show two full hearts
    output="#[fg=colour9]$FULL_HEART$FULL_HEART#[fg=white]$EMPTY_HEART$EMPTY_HEART$EMPTY_HEART"
  elif [[ $percentage -lt 60 ]]; then
    # 50-59%: Show two full hearts and one half heart
    output="#[fg=colour9]$FULL_HEART$FULL_HEART$HALF_HEART#[fg=white]$EMPTY_HEART$EMPTY_HEART"
  elif [[ $percentage -lt 70 ]]; then
    # 60-69%: Show three full hearts
    output="#[fg=colour9]$FULL_HEART$FULL_HEART$FULL_HEART#[fg=white]$EMPTY_HEART$EMPTY_HEART"
  elif [[ $percentage -lt 80 ]]; then
    # 70-79%: Show three full hearts and one half heart
    output="#[fg=colour9]$FULL_HEART$FULL_HEART$FULL_HEART$HALF_HEART#[fg=white]$EMPTY_HEART"
  elif [[ $percentage -lt 90 ]]; then
    # 80-89%: Show four full hearts
    output="#[fg=colour9]$FULL_HEART$FULL_HEART$FULL_HEART$FULL_HEART#[fg=white]$EMPTY_HEART"
  elif [[ $percentage -lt 95 ]]; then
    # 90-95%: Show four full hearts and one half heart
    output="#[fg=colour9]$FULL_HEART$FULL_HEART$FULL_HEART$FULL_HEART$HALF_HEART#[fg=white]"
  else
    # 95-100%: Show five full hearts
    output="#[fg=colour9]$FULL_HEART$FULL_HEART$FULL_HEART$FULL_HEART$FULL_HEART"
  fi
else
  # We're on a desktop, show 5 full hearts
  output="#[fg=colour9]$FULL_HEART$FULL_HEART$FULL_HEART$FULL_HEART$FULL_HEART"
fi

printf "%s" "$output"

#!/bin/bash
set -x

FULL_HEART='󰣐 '
HALF_HEART='󰛞 '
EMPTY_HEART='󱢠 '

os=$(uname)

# Check if argument is provided for testing
if [[ $# -eq 1 && "$1" =~ ^[0-9]+$ ]]; then
	percentage=$1
elif [[ $(uname) == 'Linux' ]]; then
	percentage=$(acpi | grep -oP ',\s*\K\d+(?=%)')
else
	battery_info=$(ioreg -rc AppleSmartBattery)
	current_charge=$(echo $battery_info | grep -o '"CurrentCapacity" = [0-9]\+' | awk '{print $3}')
	total_charge=$(echo $battery_info | grep -o '"MaxCapacity" = [0-9]\+' | awk '{print $3}')
	percentage=$((current_charge * 100 / total_charge))
fi

# naively checks if this is desktop or laptop
if [[ "${os}" == 'Darwin' || "$(ls -A /sys/class/power_supply/ 2>/dev/null)" ]]; then
	# Fix special cases first
	if [[ $percentage -lt 6 ]]; then
		# 0-5%: Show 5 red empty hearts
		output="#[fg=colour9]$EMPTY_HEART$EMPTY_HEART$EMPTY_HEART$EMPTY_HEART$EMPTY_HEART"
	elif [[ $percentage -ge 95 ]]; then
		# 95-100%: Show five full hearts
		output="#[fg=colour9]$FULL_HEART$FULL_HEART$FULL_HEART$FULL_HEART$FULL_HEART"
	else
		# Calculate number of full hearts (integer division by 20)
		full_hearts=$((percentage / 20))

		# Check if we need a half heart (remainder between 10-19)
		remainder=$((percentage % 20))
		has_half_heart=0
		if [[ $remainder -ge 10 ]]; then
			has_half_heart=1
		fi

		# Calculate empty hearts
		empty_hearts=$((5 - full_hearts - has_half_heart))

		# Build output string
		output="#[fg=colour9]"

		# Add full hearts
		for ((i = 0; i < full_hearts; i++)); do
			output+="$FULL_HEART"
		done

		# Add half heart if needed
		if [[ $has_half_heart -eq 1 ]]; then
			output+="$HALF_HEART"
		fi

		# Add empty hearts if needed
		if [[ $empty_hearts -gt 0 ]]; then
			output+="#[fg=white]"
			for ((i = 0; i < empty_hearts; i++)); do
				output+="$EMPTY_HEART"
			done
		fi
	fi
else
	# We're on a desktop, show 5 full hearts
	output="#[fg=colour9]$FULL_HEART$FULL_HEART$FULL_HEART$FULL_HEART$FULL_HEART"
fi

printf "%s" "$output"

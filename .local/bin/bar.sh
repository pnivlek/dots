#!/usr/bin/env bash
set -euo pipefail

# Battery
BATTERY=0
BATTERY_INFO=$(acpi -b | grep "Battery ${BATTERY}")
BATTERY_POWER=$(echo "${BATTERY_INFO}" | grep -o '[0-9]\+%' | tr -d '%')
BATTERY_STATE=$(echo "${BATTERY_INFO}" | grep -wo "Full\|Charging\|Discharging")

if [[ "${BATTERY_STATE}" = "Charging" ]]; then
  bat0="B0: ${BATTERY_POWER}%+"
elif [[ "${BATTERY_STATE}" = "Discharging" ]]; then
  bat0="B0: ${BATTERY_POWER}%- B1: ${BATTERY_1_POWER}%-"
else
  bat0="B0: ${BATTERY_POWER}%"
fi

BATTERY=1
BATTERY_INFO=$(acpi -b | grep "Battery ${BATTERY}")
BATTERY_POWER=$(echo "${BATTERY_INFO}" | grep -o '[0-9]\+%' | tr -d '%')
BATTERY_STATE=$(echo "${BATTERY_INFO}" | grep -wo "Full\|Charging\|Discharging")
if [[ "${BATTERY_STATE}" = "Charging" ]]; then
  bat1="B1: ${BATTERY_POWER}%+"
elif [[ "${BATTERY_STATE}" = "Discharging" ]]; then
  bat1="B1: ${BATTERY_POWER}%-"
else
  bat1="B1: ${BATTERY_POWER}%"
fi

echo $bat0
notify-send -t 3 -a barbat " ${bat0} ${bat1}"

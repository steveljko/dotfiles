#!/bin/sh
TASK=$(timew | awk -F'"' '/Tracking/ {print $2}')
TIME=$(timew | awk '/Total/ {print $2}')

# output=$(jq -n \
#   --arg task "$task" \
#   --arg time "$time" \
#   '{task: $task, time: $time}' | jq -c .)

if [[ -n "$TASK" ]]; then
  printf "{\"text\": \"%s [%s]\", \"tooltip\": \"%s\", \"alt\": \"%s\"}" \ "$TASK" "$TIME" "Currently tracking: $TASK\nFrom start: $TIME" "tracking"
else
  printf "{\"text\": \"\", \"tooltip\": \"%s\", \"alt\": \"%s\"}" \ "No active tracking at the moment." "idle"
fi

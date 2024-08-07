#!/bin/sh
TASK=$(timew | awk '/Tracking/ {print $2}')
TIME=$(timew | awk '/Total/ {print $2}')

if [[ -n "$TASK" ]]; then
  printf "{\"text\": \"%s\", \"tooltip\": \"%s\", \"alt\": \"%s\"}" \ "$TIME" "Task: $TASK\nFrom start: $TIME" "tracking"
else
  printf "{\"text\": \"\", \"tooltip\": \"%s\", \"alt\": \"%s\"}" \ "No active tracking at the moment." "idle"
fi

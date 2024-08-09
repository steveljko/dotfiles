#!/bin/sh
TASK=$(timew | awk -F'Tracking ' '/Tracking/ {gsub(/"/, "", $2); print $2}')

if [[ -n "$TASK" ]]; then
  TIME=$(timew | awk '/Total/ {print $2}')
  printf "{\"text\": \"%s\", \"tooltip\": \"%s\", \"alt\": \"%s\"}" \ "$TIME" "Task: $TASK\nFrom start: $TIME" "tracking"
else
  PENDING_TASKS=$(task status:pending count)
  FINISHED_TASKS=$(task end:today status:completed count)
  TOTAL_TASKS=$(( $FINISHED_TASKS + $PENDING_TASKS )) 
  printf "{\"text\": \"%s/%s\", \"tooltip\": \"%s\", \"alt\": \"%s\"}" \ "$FINISHED_TASKS" "$TOTAL_TASKS" "Tasks for today: $TOTAL_TASKS\nFinished tasks: $FINISHED_TASKS\nUnfinished tasks: $PENDING_TASKS" "idle"
fi

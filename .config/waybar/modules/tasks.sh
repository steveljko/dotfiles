#!/bin/sh
TASK=$(timew | awk '/Tracking/ {print $2}')

if [[ -n "$TASK" ]]; then
  TIME=$(timew | awk '/Total/ {print $2}')
  printf "{\"text\": \"%s\", \"tooltip\": \"%s\", \"alt\": \"%s\"}" \ "$TIME" "Task: $TASK\nFrom start: $TIME" "tracking"
else
  TASKS_COUNT=$(task status:pending count)
  TASKS_COMPLETED_COUNT=$(task end.after:today count)
  printf "{\"text\": \"%s/%s\", \"tooltip\": \"%s\", \"alt\": \"%s\"}" \ "$TASKS_COUNT" "$TASKS_COMPLETED_COUNT" "Completed tasks: $TASKS_COMPLETED_COUNT\nUnfinished tasks: $TASKS_COUNT" "idle"
fi

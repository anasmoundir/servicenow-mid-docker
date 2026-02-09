#!/bin/bash

LOG_FILE="/opt/servicenow/mid/agent/logs/agent.log"

if [ ! -f "$LOG_FILE" ]; then
  exit 1
fi

grep -q "MID Server ready" "$LOG_FILE"


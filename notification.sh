#!/bin/bash

# Check for required dependencies
if ! command -v jq &> /dev/null; then
    echo "Error: jq is required but not installed" >&2
    exit 1
fi

# Detect TTS command
if command -v say &> /dev/null; then
    TTS_CMD="say"
elif command -v mac &> /dev/null && mac say --version &> /dev/null; then
    TTS_CMD="mac say"
elif command -v espeak &> /dev/null; then
    TTS_CMD="espeak"
elif command -v spd-say &> /dev/null; then
    TTS_CMD="spd-say"
else
    echo "Error: No TTS command found (say, mac say, espeak, or spd-say)" >&2
    exit 1
fi

# Read JSON from stdin
json_input=$(cat)

# Extract the message
message=$(echo "$json_input" | jq -r '.message')

# Speak the message
if [[ -n "$message" ]]; then
    echo "$message" | $TTS_CMD
fi
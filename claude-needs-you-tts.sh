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

# Read the JSON from stdin
json=$(cat)

# Extract the transcript path
transcript_path=$(echo "$json" | jq -r '.transcript_path')

# Read the transcript and get the last summary
if [ -f "$transcript_path" ]; then
    summary=$(cat "$transcript_path" | jq -R -s 'split("\n") | map(fromjson? | select(.type == "summary")) | sort_by(.timestamp // 0) | last | .summary // empty' 2>/dev/null)
    
    # If no summary found, search other JSONL files in the same directory
    if [ -z "$summary" ]; then
        transcript_dir=$(dirname "$transcript_path")
        # Find JSONL files, sort by modification time (newest first), and search for summaries
        for file in $(ls -t "$transcript_dir"/*.jsonl 2>/dev/null | head -10); do
            if [ "$file" != "$transcript_path" ]; then
                summary=$(cat "$file" | jq -R -s 'split("\n") | map(fromjson? | select(.type == "summary")) | sort_by(.timestamp // 0) | last | .summary // empty' 2>/dev/null)
                if [ -n "$summary" ]; then
                    break
                fi
            fi
        done
        
        # Still no summary? Use fallback
        if [ -z "$summary" ]; then
            summary="UNKNOWN CLAUDENING"
        fi
    fi
else
    summary="UNKNOWN CLAUDENING"
fi

# Say the summary
echo "Finished $summary" | $TTS_CMD
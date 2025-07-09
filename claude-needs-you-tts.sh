#!/bin/bash

# Read the JSON from stdin
json=$(cat)

# Extract the transcript path
transcript_path=$(echo "$json" | jq -r '.transcript_path')

# Read the transcript and get the last summary
if [ -f "$transcript_path" ]; then
    summary=$(cat "$transcript_path" | jq -R -r 'fromjson? | select(.type == "summary") | .summary' 2>/dev/null | tail -1)
    
    # If no summary found, search other JSONL files in the same directory
    if [ -z "$summary" ]; then
        transcript_dir=$(dirname "$transcript_path")
        # Find JSONL files, sort by modification time (newest first), and search for summaries
        for file in $(ls -t "$transcript_dir"/*.jsonl 2>/dev/null | head -10); do
            if [ "$file" != "$transcript_path" ]; then
                summary=$(cat "$file" | jq -R -r 'fromjson? | select(.type == "summary") | .summary' 2>/dev/null | tail -1)
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
echo "Finished $summary" | say
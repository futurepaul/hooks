# Claude Hooks Collection

This repository contains hooks for Claude that provide TTS notifications across platforms.

## Scripts

### claude-needs-you-tts.sh
Reads the last summary from the transcript and announces completion.

### notification.sh
Speaks notification messages out loud using cross-platform TTS.

## Requirements

- jq
- One of the following TTS commands:
  - `say` (macOS)
  - `mac say` (OrbStack Linux containers)
  - `espeak` (Linux)
  - `spd-say` (Linux with speech-dispatcher)

The script automatically detects which TTS command is available.

## Installation

```bash
chmod +x claude-needs-you-tts.sh
chmod +x notification.sh
```

## Usage

### claude-needs-you-tts.sh
In `claude` CLI, do `/hooks` and add a Stop hook:

```json
~/full/path/to/claude-needs-you-tts.sh
```

Or add this to settings.json in ~/.claude/settings.json

```json
{
  "hooks": {
    "Stop": [
      {
        "matcher": "",
        "hooks": [
          {
            "type": "command",
            "command": "~/dev/tools/hooks/claude-needs-you-tts.sh"
          }
        ]
      }
    ]
  }
}
```

### notification.sh
In `claude` CLI, do `/hooks` and add a Notification hook:

```json
~/full/path/to/notification.sh
```

Or add this to settings.json in ~/.claude/settings.json

```json
{
  "hooks": {
    "Notification": [
      {
        "matcher": "",
        "hooks": [
          {
            "type": "command",
            "command": "~/dev/tools/hooks/notification.sh"
          }
        ]
      }
    ]
  }
}
```

## Debugging

Add this hook to the Stop hook to log all commands to a file. (Shows you what arguments are being passed to the script)

```bash
jq '.' >> ~/.claude/bash-command-log.txt
```

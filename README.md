# Claude Needs You TTS

This is a hook for Claude that will read the last summary from the transcript and use it to generate a TTS notification on macOS.

## Requirements

- macOS
- jq

(If you're using orb u gotta change the script to use `mac say` instead of `say`)

## Installation

```bash
chmod +x claude-needs-you-tts.sh
```

## Usage

In `claude` CLI, do `/hooks` and and add a Stop hook:

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

## Debugging

Add this hook to the Stop hook to log all commands to a file. (Shows you what arguments are being passed to the script)

```bash
jq '.' >> ~/.claude/bash-command-log.txt
```

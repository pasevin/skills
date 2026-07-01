---
name: cluely
description: Query and manage Cluely meeting sessions, transcripts, and tags from the terminal. Use when listing or filtering sessions, reading transcripts, scripting against session data with JSON output, tagging sessions, watching for session start/end events, or managing the background session watcher daemon.
---

# Cluely CLI

The core data model is a **session** — a meeting recording with a transcript, summary, attendees, state, and tags.

## Auth

Check auth before running sessions commands in a script:

```bash
cluely auth status && cluely sessions list
cluely auth login    # Opens browser to sign in
cluely auth logout   # Clears stored credentials (OS keyring)
```

`cluely auth status` exits `1` when not authenticated, making it safe for scripting.

## Sessions

### List

```bash
cluely sessions list                         # Recent sessions
cluely sessions list -n 5                    # Limit results
cluely sessions list --state finished        # Filter by state
cluely sessions list --since 24h             # Time window (also: 7d, 30d)
cluely sessions list --tag <tag-id>          # Filter by tag
cluely sessions list --fields id,title,tags  # Only these columns
cluely sessions list --no-fields tags,state  # Hide these columns
```

Columns: `id`, `state`, `title`, `tags`, `created`.

### Get

```bash
cluely sessions get <session-id>                              # Full details + transcript
cluely sessions get <session-id> --fields summary,transcript  # Only these sections
cluely sessions get <session-id> --no-fields transcript       # Hide transcript
```

Sections: `id`, `title`, `state`, `created`, `ended`, `tags`, `attendees`, `summary`, `transcript`.

### Update & delete

```bash
cluely sessions update <session-id> --title "Q2 Planning"
cluely sessions update <session-id> --summary "Discussed roadmap priorities"
cluely sessions update <session-id> --title "Standup" --summary "Quick sync"
cluely sessions delete <session-id>
```

### Tag

```bash
cluely sessions tag   <session-id> <tag-id>   # Add tag to session
cluely sessions untag <session-id> <tag-id>   # Remove tag from session
```

## JSON output

Any sessions or tags command accepts `--json` for raw JSON — use for scripting and piping:

```bash
cluely sessions list --json | jq '.items[].title'
cluely sessions get <session-id> --json > ~/transcripts/<session-id>.json
```

## Watch

Watches for session starts and ends in real time. Runs in the foreground until Ctrl+C.

```bash
cluely sessions watch                                            # Print all events
cluely sessions watch --on end --exec "./on-complete.sh"        # Run on session end
cluely sessions watch --on start --exec "notify-send 'Started'" # Run on session start
```

`--exec` receives:

| Variable | Value |
|---|---|
| `CLUELY_EVENT` | `start` or `end` |
| `CLUELY_SESSION_ID` | Session ID |
| `CLUELY_SESSION_TITLE` | Session title (if available) |

Auto-export transcripts on completion:

```bash
cluely sessions watch --on end --exec \
  "cluely sessions get \$CLUELY_SESSION_ID --json > ~/transcripts/\$CLUELY_SESSION_ID.json"
```

## Tags

```bash
cluely tags list
cluely tags create "Sales Call" --color "#4f46e5"
cluely tags delete <tag-id>
cluely tags list --json
```

## Daemon

Runs the session watcher as a persistent background service (launchd on macOS, systemd on Linux). Auto-restarts on failure and runs on login.

```bash
cluely daemon start --exec "./on-complete.sh"  # Install and start service
cluely daemon status                            # Check if running
cluely daemon logs                              # View logs
cluely daemon logs -f                           # Follow logs
cluely daemon stop                              # Stop and remove service
```

Logs: `~/.config/cluely/logs/watch.log`

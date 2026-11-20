---
name: agent-quota
description: Check plan usage for Claude Code (5-hour and weekly) and Cursor, the same numbers as Maestri's usage rings. Use when asked about quota or limits, before deciding to move agents to Cursor, and before asking for a Brain handover.
user-invocable: true
---

# Agent quota

Run `~/dev/repos/skills/skills/productivity/agent-quota/quota.sh`. It prints:

```
Claude five hour: 39% (resets Sat 21 Nov 01:40)
Claude seven day: 87% (resets Thu 26 Nov 10:00)
Cursor plan: 17%
```

It reads Claude through `claude -p` with a `get_usage` control request (no model call, no tokens) and Cursor through its dashboard API with the token in `~/.cursor/auth.json`. Both are what Maestri's providers in `~/.maestri/usage/providers/` do. If a vendor changes its API, compare with those files.

## Alerts
`quota.sh --alert 90,93,96` prints and exits 0 only the first time the Claude weekly use crosses one of the marks in the current week; otherwise it exits 1 silently. Use it as a Maestri routine `--pre-run` with `--reminder`, so the routine notifies only when a mark is crossed and costs nothing otherwise.

## What to do with the numbers
- Weekly past 90%: new recruits on Cursor only; long work on Cursor.
- Weekly past 93%: tell Aleksandr it's time to ask for the Brain handover (`brain-handover`), while there's room to write it.
- The 5-hour window resets fast; only the weekly one decides a handover.

#!/bin/sh
# Print plan usage for Claude Code and Cursor, the same way Maestri's usage rings read it.
# Usage: quota.sh            -> one line per meter
#        quota.sh --alert 90,93,96 -> exit 0 (and print) only the first time Claude's weekly use crosses
#                               one of these marks in the current week, else exit 1 silently.
#                               Built for a Maestri routine --pre-run, so the routine fires only when it matters.
#                               State: ~/.cache/agent-quota/alerted (mark + week reset time).
ALERT=""
[ "$1" = "--alert" ] && ALERT="$2"
tmp=$(mktemp -d); cd "$tmp" || exit 2
claude_json=$(echo '{"type":"control_request","request_id":"q","request":{"subtype":"get_usage","skip_behaviors":true}}' \
  | timeout 40 claude -p --input-format stream-json --output-format stream-json --verbose --no-session-persistence 2>/dev/null \
  | grep '"control_response"' | head -1)
token=$(python3 -c 'import json,os;d=json.load(open(os.path.expanduser("~/.cursor/auth.json")));print("" if d.get("signedOut") else d.get("accessToken",""))' 2>/dev/null)
cursor_json=""
[ -n "$token" ] && cursor_json=$(printf 'Authorization: Bearer %s\n' "$token" | curl -sS --max-time 20 -H @- -H 'Content-Type: application/json' -H 'Connect-Protocol-Version: 1' --data '{}' https://api2.cursor.sh/aiserver.v1.DashboardService/GetCurrentPeriodUsage 2>/dev/null)
cd / && rm -rf "$tmp"
CLAUDE_JSON="$claude_json" CURSOR_JSON="$cursor_json" ALERT="$ALERT" python3 - <<'PY'
import json, os, sys
from datetime import datetime
out, weekly = [], None
try:
    r = json.loads(os.environ["CLAUDE_JSON"])["response"]["response"]
    for k, v in (r.get("rate_limits") or {}).items():
        if isinstance(v, dict) and v.get("utilization") is not None:
            when = v.get("resets_at", "")
            try: when = datetime.fromisoformat(when).astimezone().strftime("%a %d %b %H:%M")
            except Exception: pass
            out.append(f"Claude {k.replace('_',' ')}: {v['utilization']:.0f}% (resets {when})")
            if k == "seven_day": weekly = v["utilization"]
except Exception:
    out.append("Claude: unreadable")
try:
    c = json.loads(os.environ["CURSOR_JSON"]).get("planUsage", {})
    if "totalPercentUsed" in c: out.append(f"Cursor plan: {c['totalPercentUsed']:.0f}%")
except Exception:
    out.append("Cursor: unreadable")
a = os.environ.get("ALERT")
if a:
    if weekly is None: sys.exit(1)
    marks = sorted(float(x) for x in a.split(",") if x.strip())
    hit = [m for m in marks if weekly >= m]
    if not hit: sys.exit(1)
    try: reset = r["rate_limits"]["seven_day"].get("resets_at", "")
    except Exception: reset = ""
    sp = os.path.expanduser("~/.cache/agent-quota/alerted")
    os.makedirs(os.path.dirname(sp), exist_ok=True)
    last_mark, last_reset = 0.0, ""
    try:
        last_mark, last_reset = open(sp).read().split("|", 1); last_mark = float(last_mark)
    except Exception: pass
    if last_reset == reset and last_mark >= hit[-1]: sys.exit(1)
    open(sp, "w").write(f"{hit[-1]}|{reset}")
print("\n".join(out))
PY

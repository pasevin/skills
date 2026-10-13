---
name: brain-catch-up
description: Project Brain sweep — read Slack, meetings, Notion and GitHub since a date for the current project, summarise what changed, and propose canvas note updates. Use for "catch me up", after PTO, and the daily sync routine.
user-invocable: true
---

# Brain catch-up

Input: a start date. Default is the "Last full sync" date in `<Project> — Brain Index`.

## 1. Load context
`maestri list` → read Brain Index, Context Sources (channels, repos, Notion DBs, people), Open Loops.

## 2. Sweep (fan out to subagents if wide; keep only conclusions)
- **Slack:** each project channel + DMs with the user since the date. Threads with replies: read the thread.
- **Meetings:** transcripts since the date (meeting tool). Prefer transcript over auto-summary.
- **Notion:** Decisions, Open Questions, Meeting Logs, Document Hub — rows created or edited since the date. Read new design docs fully.
- **GitHub:** issues/PRs opened, merged, commented since the date in project repos; review requests to the user.
- **Calendar:** next 7 days of project meetings.

## 3. Check before claiming
Every "decided" needs a quote or a Decisions row. Otherwise it's "leaning" or "open". Verify code claims against code. Convert all times to the user's local zone.

## 4. Output
- **Manual run:** answer in chat. Sections, only if non-empty: Needs you (what · by when · link) · Decisions · Open questions · What changed · Team · Stuck. Short lines, real links.
- **Routine run:** write proposals into `<Project> — Pending Sync` as a list. Mark each line with its target: `[Open Loops +]`, `[Open Loops −]`, `[Top 3]`, `[Timeline]`, `[Context Sources]`, `[Notion]`, `[GitHub]`. Then `maestri notify "Brain sync: N proposals waiting"`. If there's nothing, notify nothing and leave the note as it is.

## 5. On approval
Apply only what the user approves. Then: update the Brain Index "Last full sync", refresh Top 3, add Timeline lines, and clear Pending Sync.

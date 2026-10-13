---
name: brain-meeting-intake
description: Project Brain meeting intake — read a meeting transcript, draft the Notion meeting log entry in the project's house format, and propose canvas note updates. Use after a project meeting or when asked to "log the weekly".
user-invocable: true
---

# Brain meeting intake

## 1. Find the meeting
Use the meeting transcript tool (MCP): `search_meetings` by title and date → `get_meeting` with `view_transcript`. Page through the whole transcript. The summary is lossy; the transcript is the source.

## 2. Find the house format
In Context Sources, find the project's meeting log database. Fetch the most recent entry and copy its shape:
- **Properties:** Meeting ("<Title> — D Mon YYYY"), Date, Type, Attendees (person property, so look up Notion user IDs), Follow-ups (" · "-separated, owner in brackets).
- **Body:** who was absent, then one `##` per topic. Each topic covers what was said, what's leaning vs decided, and links to issues and pages. End with Progress and Team.

## 3. Write
- Plain English, product facts only, no meta.
- Mark decided only when stated. Otherwise write "leaning" or "open".
- Link existing Notion pages as mentions, and GitHub issues.
- Never link or cite the transcript tool.
- Anything unclear in the transcript: list it for the user. Don't guess.

## 4. Approval
- Show the user the draft summary and the unclear points, then create the row on their go.
- If it runs from a routine, put the draft in `<Project> — Pending Sync` and notify.

## 5. Knock-ons (propose, don't apply)
- New decisions → Decisions log rows.
- New questions → Open Questions rows, with an owner.
- Follow-ups → Open Loops.
- Top 3 refresh.
- Timeline line.

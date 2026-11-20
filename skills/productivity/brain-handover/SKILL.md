---
name: brain-handover
description: Hand a project from the Project Brain to a temporary Substitute Project Brain and back. Covers writing the handover fichário, spawning and onboarding the substitute, retargeting routines and orchestrators, the handback log, the return exchange and dismissal. Use only when Aleksandr explicitly asks for a handover or a handback.
user-invocable: true
---

# Brain handover

The Project Brain (Brain) and the Substitute Project Brain (Sub) never run on the canvas at the same time. Handover and handback happen only when Aleksandr asks, never on an agent's initiative, and never on a schedule.

## The handover fichário

One fichário per project, `<Project> — Brain Handover`, separate from the project fichário. Five notes:

1. `Handover 1 — Start here`: date stamps, who the Sub is, the read order, first actions, the manual spawn path.
2. `Handover 2 — Snapshot`: the state of the work at handover time.
3. `Handover 3 — Rules`: how Aleksandr works, distilled from the Brain's memory, with the path to the full files.
4. `Handover 4 — Routines`: each routine, when it fires, what it does, where it is targeted.
5. `Handover 5 — Handback log`: written by the Sub.

**Frozen between handovers.** Once the handback is accepted, nobody edits the fichário. It stays as the last record of how things were communicated. The next handover archives the old text, then rewrites every note whole (`maestri note write`), never patches it, so no garbage builds up.

**Date stamps.** Line 1 of Start here is always `Handed over: <YYYY-MM-DD HH:MM local> by <Brain terminal> · Handed back: <date or "not yet">`.

**Keep it wired to the Brain.** The fichário and the project notes stay connected to the Brain's terminal too. Dismissing the Sub must never orphan a note.

## Handover (Brain → Sub)

Run when Aleksandr asks. Writing the handover costs quota, so it should be asked for with room to spare.

1. **Archive.** If the fichário exists, append each note's current text under a dated heading to the project's Obsidian canvas archive (named in the Brain Index), then rewrite.
2. **Rewrite all five notes whole.**
   - *Start here:* the stamp line; "you are the Substitute Project Brain for <Project>, temporary, until Aleksandr asks for the handback"; the read order (this fichário 1→4, then the Brain Index, Top 3, Open Loops, Pending Sync, then the Brain role file and the voice skill file by path); the first three things to do; contact rules (Aleksandr only through Maestri Chat; orchestrators through `maestri ask`); and the **Manual path**, below.
   - *Snapshot:* per floor or orchestrator: what it builds, its state, what it waits on, and its exact standing orders. PRs in flight with head SHAs and who reviews. **Pending gos with their exact scope**, and gos not yet given. Slack drafts left unsent. Who is waiting on whom. The dates ahead. Anything the Brain promised Aleksandr ("I'll have X draft Y"). Links on every item.
   - *Rules:* the approval rules, the voice, the project conventions (issue fields, branches, tooling), the people and their pronouns, the known tool traps. One line each, with the path to the full memory directory (read-only for the Sub).
   - *Routines:* `maestri routine list` output with each routine's purpose and current target.
   - *Handback log:* a template with headings only (see Handback), dated with the handover date.
3. **Spawn it in the Brain's band**, next to the Brain in the same window: `maestri recruit "<Project> Substitute Brain" --preset "<non-Claude preset>" --role "Substitute Project Brain" --band "<Brain's band>"` (default Cursor: `--preset "Cursor" --command "agent --trust --force"`). As a band member it reaches every note and agent the band is connected to. If the Brain is in no band, create one first (`maestri band create`). Ask Aleksandr to switch Maestro on for that terminal if the preset lacks it. Then `maestri connect` whatever `maestri list` shows it still can't reach, typically the orchestrators (agent ropes cross floors and workspaces).
4. **Onboard.** `maestri ask` the Sub to read Start here and follow it, then answer with its understanding: the top 3, the pending gos with scope, who is waiting on what, and what it will do first. Correct anything wrong until its summary matches the Snapshot.
5. **Retarget.** `maestri routine edit "<name>" --terminal "<Sub terminal>"` for every routine on the Brain. Tell each orchestrator: "from now on report to `<Sub terminal> @ <workspace>`, same rules."
6. **Hand the wheel over.** Tell Aleksandr it's ready and where to chat with it. From then on the Brain does nothing on the canvas.

### Manual path (for Aleksandr, when the Brain is already out)

Written into Start here, with the project's real names filled in:
1. Recruit a terminal named `<Project> Substitute Brain` with role "Substitute Project Brain" on a non-Claude CLI, as a member of the Brain's band (next to the Brain), and switch Maestro on.
2. Check it reaches the handover fichário, the project fichário, the loose project notes and the orchestrators; rope whatever is missing.
3. Paste: "You are the Substitute Project Brain for <Project>. Read `Handover 1 — Start here` and follow it. Then tell me your understanding." Then check its summary against the Snapshot.
4. Retarget the routines to it in the canvas (or ask it to, once it's on).

## Handback (Sub → Brain)

Run when Aleksandr asks.

**Sub:**
1. Start nothing new. Finish or park the current step and say which.
2. Rewrite `Handover 5 — Handback log` whole, terse, links on everything:
   - `Handback: <date time>` · period covered.
   - **Done:** what moved, with links.
   - **Gos:** each go Aleksandr gave, its scope, and whether it was carried out.
   - **Decisions and new rules** Aleksandr stated (quote him), and learnings about tools or people. These are candidates for the Brain's memory; the Sub never writes that memory.
   - **Notes changed:** which canvas notes it edited and why.
   - **Still open:** what's mid-flight, who waits on whom, Slack drafts left unsent, promises made.
   - **Questions for the Brain.**
3. Stamp "Handed back" in line 1 of Start here.
4. Tell Aleksandr it's ready. From then on it only answers the Brain's questions and acts on nothing.

**Brain:**
1. Re-read your own start notes, then the handback log, Start here, and the project Timeline since the handover date.
2. Ask the Sub what is unclear (`maestri ask`). Check claims against the source (GitHub, Slack, notes).
3. Present your understanding to Aleksandr: what changed, what's pending, what you'd add to memory. Wait for his OK.
4. On his OK: retarget routines back to the Brain, tell every orchestrator to report to the Brain again, save the approved learnings to memory, then `maestri dismiss` the Sub. Leave the fichário as it is: it is frozen until the next handover.

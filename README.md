# Zone Quest Guide

**Version:** 0.2.5  
**WoW:** Retail 12.1 (`Interface: 120100`)

Zone Quest Guide is a lightweight World of Warcraft addon that shows unfinished quests for the current zone and points the player toward the next useful target.

## Current features

- Detects the current Retail WoW zone/map and refreshes automatically.
- Shows **AVAILABLE**, **TURN IN**, and **IN PROGRESS** quest states.
- Keeps normal **ZONE QUESTS** separate from repeatable **DAILY QUESTS**.
- Prioritizes normal zone quests ahead of dailies, then **AVAILABLE**, **TURN IN**, and **IN PROGRESS** within each section.
- Uses Blizzard super-tracking for accepted quests and temporary user waypoints for available quest starters.
- Replaces old available-quest waypoints when the selected quest changes.
- Adds a floating navigation HUD with a smoothly rotating drawn arrow, quest name, status, and distance when available.
- Keeps the navigation target stable while a flight path briefly crosses another zone.
- Supports optional **Auto Accept** and **Auto Turn-in** quest automation.
- Supports location hints such as **UPPER LEVEL** for confusing vertical quest locations.
- Supports historical/time-phase zones controlled by NPCs such as Zidormi.
- Automatically infers a timeline when WoW exposes a currently active or available quest that the curated database already knows is phase-exclusive.
- Shows the detected timeline on its own line directly below the current zone name in the main Zone Quest Guide window.
- Warns the player to talk to the configured timeline-switch NPC before questing when a phased zone is known but the active timeline is still unknown.
- Updates the timeline after the player selects Zidormi's switch option instead of waiting for a second Zidormi conversation.
- Can redirect the navigation arrow to a timeline-switch NPC when the selected quest belongs to another historical version of the zone.
- Learns phase/quest evidence locally while Horde and Alliance characters play in known historical phases.
- Exports anonymous phase-learning data for community contributions.

## Navigation HUD

The floating navigation HUD remains visible independently of the main quest list.

- Smoothly rotates toward the current destination.
- Shows the selected target and status.
- Shows distance in yards when WoW exposes usable world-position data.
- Includes supplemental location hints when present.
- **Shift-drag** moves the HUD and saves its position.
- `/zq arrow` toggles it.
- `/zq arrow reset` restores its default position.

### Retail secret-value compatibility

Zone Quest Guide does not currently calculate a movement-speed ETA. On current Retail clients, Blizzard can return `GetUnitSpeed("player")` as a secret value. Comparing or doing arithmetic with that protected value from addon code can taint execution and produce a Lua error.

Version 0.2.2 removed the movement-speed ETA calculation and keeps the safe navigation information: direction, target, status, and distance when available.

### Timeline-switch arrow

For phase-aware quests, Zone Quest Guide can recognize that the selected quest belongs to another historical version of the current zone. When the current phase is known and a configured switch NPC exists, the normal navigation HUD temporarily changes to:

`SWITCH TIMELINE`

and points to the timeline-switch NPC instead of an objective that is unavailable in the current phase.

Initial Blasted Lands Horde coverage includes:

- **Attack of the Iron Horde** — requires the present/Iron Horde-incursion version.
- **Under Siege** — requires the present/Iron Horde-incursion version.
- **Zidormi** near the northern Blasted Lands border is the configured phase switch target.

After the player changes to the required timeline and the guide refreshes, navigation returns to the real quest target.

## Phase learning

Version 0.2.3 added an account-wide local learning database inside `ZoneQuestGuideDB`.

When Zone Quest Guide has a reliable historical-phase signal for the current map, it records live quest evidence supplied by WoW. Reliable phase signals include Zidormi detection, a configured detector, a manual `/zq phase` override, and starting in v0.2.4 a curated phase-exclusive quest that WoW currently exposes as active or available on the map.

The learner can record:

- quests WoW reports as available on the current map;
- quests offered by an NPC;
- accepted quests on the current map;
- active quests shown by an NPC;
- quests accepted while the phase is known;
- quests turned in while the phase is known;
- whether a recorded quest has been completed on a character that observed it.

Data is separated by **map**, **faction**, **quest ID**, and **phase**. Because `ZoneQuestGuideDB` is an account-wide SavedVariable, Horde and Alliance alts on the same WoW account can contribute to the same local dataset while still being kept in separate faction buckets.

The learner deliberately does **not** infer a timeline from a completed quest alone. A character may have completed that quest in another historical version earlier, so completion is stored as supporting information rather than proof that the quest belongs to the phase currently being viewed.

The learner also does not automatically promote observations into official `QuestPhaseRequirements`. A quest seen in one phase may still exist in another phase under different prerequisites. Learned observations are evidence that can be reviewed and then added to the curated database once the phase requirement is trustworthy.

Commands:

- `/zq learn` — show the current map's learning status and how many quests are stored for the current faction.
- `/zq export` — open a copyable anonymous phase-learning report.

The export contains zone IDs, faction, phase, quest IDs/names, completion state, observation counts, and the type of phase signal used. It intentionally does not include character names, realm names, or character GUIDs.

### Community reporting

A normal WoW addon does not have a general-purpose web uploader built into its Lua environment, so Zone Quest Guide does not silently transmit learned data to GitHub or another server.

For now, community testers can run `/zq export`, copy the report, and send it with a GitHub issue or other contribution. A future Wago/community or external uploader workflow can automate collection without changing the local learning format.

## Quest sections

### ZONE QUESTS

Normal one-time zone quests stay in the main progression section and remain the first automatic navigation priority.

### DAILY QUESTS

Repeatable daily quests are shown separately below normal zone quests. Dailies can still show **AVAILABLE**, **TURN IN**, or **IN PROGRESS**.

## Historical/time phases

Some zones can exist in older and newer versions. Zone Quest Guide treats these as filters rather than showing both versions together.

### Automatic quest-based detection

Version 0.2.4 can infer the current timeline from live quest data when a quest has already been curated as phase-exclusive. For example, **Under Siege** and **Attack of the Iron Horde** are known PRESENT/Iron Horde Blasted Lands quests. If WoW reports one of those quests as currently active or available on the Blasted Lands map, Zone Quest Guide can identify the timeline as PRESENT without requiring a fresh Zidormi conversation.

If contradictory curated quest evidence ever appears at the same time, the addon does not guess from that evidence. Manual and Zidormi signals remain higher-priority sources.

The main panel shows a dedicated line such as:

`Timeline: PRESENT / Iron Horde (quest detected)`

or:

`Timeline: PAST / Before invasion (Zidormi)`

If Zone Quest Guide knows the zone supports historical versions but cannot determine the current one, v0.2.5 shows an explicit warning such as:

`Timeline: UNKNOWN - talk to Zidormi before questing.`

This warning is intended to keep phase-learning data clean and to prevent the guide from pretending it knows which historical version is active.

### Zidormi detection

When the player talks to **Zidormi**, the addon examines her gossip option as a strong phase clue. On the English client:

- If Zidormi offers **"Take me back to the present."**, the character is currently in the **PAST** version.
- If she offers to show the zone **before** an invasion/event or otherwise travel to the past, the character is currently in the **PRESENT** version.

Version 0.2.5 also watches which Zidormi timeline option the player actually selects. After that switch option is chosen, Zone Quest Guide updates its session timeline to the destination phase and refreshes again shortly afterward so the label, phase filtering, phase learning, and navigation can follow the new world state without requiring the player to reopen Zidormi.

Manual per-zone overrides remain available when automatic identification is not reliable:

- `/zq phase` — show the current phase mode and, when applicable, the quest used as automatic evidence.
- `/zq phase auto` — clear the current-zone override.
- `/zq phase past` — force past-phase supplemental data.
- `/zq phase present` — force present-phase supplemental data.

## Quest automation

Quest automation is optional and defaults to OFF.

Open `/zq options` or click **Options** in the Zone Quest Guide window:

- **Auto accept quests** — selects and accepts available quests automatically.
- **Auto turn in completed quests** — advances completed quests and claims the reward when no meaningful reward choice is present.

Quests with multiple reward choices remain open for manual selection. Holding **Shift** while interacting with an NPC temporarily bypasses automation.

## Location hints

WoW's map is primarily 2D, so nearby pins can be misleading when one NPC is above or below another. Supplemental hints can identify locations such as **UPPER LEVEL**, **LOWER LEVEL**, **INSIDE CAVE**, or similar terrain notes.

For **Horn of the Traitor**, the guide marks the destination **UPPER LEVEL** at Freewind Post.

## Minimap button

- **Left-click** — show or hide Zone Quest Guide.
- **Right-click** — refresh the current zone quest list.
- **Shift-drag** — move the button around the minimap.
- `/zq minimap` — hide or show the minimap button.

## Commands

- `/zq` — toggle the main panel
- `/zq show`
- `/zq hide`
- `/zq refresh`
- `/zq auto` — toggle automatic quest selection
- `/zq minimap`
- `/zq arrow`
- `/zq arrow reset`
- `/zq options`
- `/zq autoaccept`
- `/zq autoturnin`
- `/zq autocomplete` — alias for auto turn-in
- `/zq phase`
- `/zq phase auto`
- `/zq phase past`
- `/zq phase present`
- `/zq learn` — show phase-learning status
- `/zq export` — open the anonymous phase-data export

## Install

1. Exit World of Warcraft.
2. Copy the `ZoneQuestGuide` folder into `World of Warcraft/_retail_/Interface/AddOns/`.
3. Start WoW.
4. Enable **Zone Quest Guide** at character select.
5. Enter the world and use `/zq` if the panel is hidden.

## Important limitations

WoW's live addon APIs do not reliably expose every historical unaccepted side quest. `QuestData.lua` supplements missing quest and navigation information zone-by-zone.

There is no universal API that gives every Zidormi-style zone a simple human-readable past/present identity. Quest-based timeline detection only works when the selected/live quest ID is already known to be phase-exclusive in the curated database. Zidormi, configured detectors, and manual overrides remain important fallbacks.

Timeline-switch arrow guidance only activates when Zone Quest Guide knows both the active timeline and the required timeline for the selected quest. Unknown quests continue using normal WoW navigation rather than guessing.

Phase learning only records a phase association when the current historical phase is known from a reliable signal. It does not treat quest completion alone as timeline proof and does not automatically turn observations into official phase requirements.

Distance depends on map/world-position information supplied by WoW, so some targets may show tracking information without a numeric distance.

## In-game test plan for v0.2.5

1. Enter or reload in Blasted Lands without talking to Zidormi and without a currently visible curated phase-exclusive quest. Verify the line directly below **Blasted Lands** says `Timeline: UNKNOWN - talk to Zidormi before questing.`
2. Talk to Zidormi and verify the warning changes to the correct **PRESENT / Iron Horde (Zidormi)** or **PAST / Before invasion (Zidormi)** label.
3. Select Zidormi's timeline-switch option and close the gossip. Verify the Zone Quest Guide timeline changes to the destination phase without talking to Zidormi a second time.
4. Run `/zq phase` immediately after switching and verify it reports the new phase.
5. Run `/zq learn` and `/zq export` after switching and verify newly observed quests are being recorded under the new phase rather than the previous one.
6. Repeat the switch in the opposite direction and verify both directions update correctly.
7. Close Zidormi without choosing the timeline option and verify the addon does **not** flip the phase just because the gossip window closed.
8. Verify the compact main-window arrow and floating navigation HUD remain positioned and functioning normally.
9. Continue verifying the v0.2.2 secret-number fix, navigation distance, timeline-switch arrow, Auto Accept, Auto Turn-in, dailies, and flight-path target hold.

## Roadmap

- Expand the curated phase-exclusive quest list so automatic timeline detection works across more Blasted Lands quests and other historical zones.
- Review exported phase-learning evidence and expand the curated quest-phase map.
- Add import/merge tooling for trusted community phase-data contributions.
- Add Wago/community reporting or an optional external companion uploader for easier community contributions.
- Add additional Zidormi zones and phase-switch NPC locations as they are encountered in-game.
- Expand supplemental quest-chain and prerequisite coverage.
- Improve multi-zone route selection.
- Add weekly/other recurring quest sections if useful.
- Add per-character/account-wide completion options.
- Add automatic GitHub release ZIP packaging.

## Release notes

See [`CHANGELOG.md`](CHANGELOG.md).

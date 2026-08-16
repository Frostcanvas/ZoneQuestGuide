# Zone Quest Guide

**Version:** 0.2.12  
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
- Recognizes known Retail Zidormi/Rhonormu historical timeline zones, including alternate Retail map IDs and live map/subzone names.
- Shows the detected timeline on its own line directly below the current zone name.
- Warns the player to talk to the configured timeline NPC before questing when a known phased zone's active timeline is still unknown.
- Updates the timeline after the player selects the switch option instead of requiring a second NPC conversation.
- Can infer a timeline when WoW exposes a curated phase-exclusive quest.
- Learns phase/quest evidence locally while Horde and Alliance characters play in known historical phases.
- Exports anonymous phase-learning data for community contributions.
- Reminds players when useful phase data is ready to contribute and provides the ZoneQuestGuide Google Form URL.
- Includes an optional Wago Analytics bridge for stronger anonymous phase evidence using Wago's documented shim integration.

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

Zone Quest Guide does not currently calculate a movement-speed ETA. On current Retail clients Blizzard can return `GetUnitSpeed("player")` as a secret value. Version 0.2.2 removed the movement-speed ETA calculation and keeps the safe navigation information: direction, target, status, and distance when available.

### Timeline-switch arrow

For phase-aware quests, Zone Quest Guide can recognize that the selected quest belongs to another historical version of the current zone. When the current phase is known and a configured local switch NPC has usable coordinates, the navigation HUD can temporarily show:

`SWITCH TIMELINE`

and point to the timeline NPC instead of an objective that is unavailable in the current phase.

The switcher registry intentionally avoids creating a same-map waypoint when the relevant NPC is somewhere else. For example, the current Quel'Thalas switch is performed by Zidormi at **Thalassian Pass**, so Eversong Woods/Ghostlands can show the timeline warning without pretending Zidormi is standing inside those maps.

## Historical/time phases

Some outdoor zones can exist in older and newer versions. Zone Quest Guide treats these as timeline filters rather than mixing both versions together.

Version 0.2.12 adds a central `TimelineZones.lua` registry for the known Retail world-state switches exposed through Zidormi or Rhonormu. The registry uses known UiMapIDs where available and also checks the live map/subzone name, because Retail can expose multiple map IDs for the same named zone.

### Registered timeline locations

- **Dustwallow Marsh / Theramore** — before Theramore's Fall vs. the ruined present.
- **Blasted Lands** — before the Iron Horde invasion vs. the Iron Horde-incursion present.
- **Peak of Serenity** — the pre-Legion monastery vs. the post-Legion state. Detection is scoped to the Peak of Serenity subzone rather than all of Kun-Lai Summit.
- **Silithus** — before the Wound vs. the Wound-era present. **Rhonormu** is also recognized as a valid timeline NPC there.
- **Darkshore** — before the War of the Thorns/Burning of Teldrassil vs. the current-era Darkshore state.
- **Teldrassil / Darnassus** — share the Darkshore timeline state where WoW exposes those related maps.
- **Tirisfal Glades** — before the Battle for Lordaeron vs. the later present state.
- **Undercity** — can share the Tirisfal timeline state where appropriate.
- **Arathi Highlands** — before the Battle for Stromgarde vs. the warfront-era state.
- **Uldum** — Cataclysm-era Uldum vs. the N'Zoth-assault-era state.
- **Vale of Eternal Blossoms** — before the N'Zoth assaults vs. the assault-era state.
- **Eversong Woods / Ghostlands** — Burning Crusade-era Quel'Thalas vs. the current Midnight-era state, switched through Zidormi at Thalassian Pass in Eastern Plaguelands.

The registry models the old/current Zidormi-style pair for these locations. It does **not** claim to identify every internal scenario, campaign, faction-control, or warfront phase that can exist inside a current-era zone.

### Why Darkshore needed another fix

Darkshore can be represented by more than one Retail UiMapID. Version 0.2.11 initially registered only the ordinary Darkshore map ID, so a character on another Darkshore map variant could see no Timeline line until speaking to Zidormi created session phase information.

Version 0.2.12 registers known Darkshore aliases and also falls back to the live map name. The intended behavior is therefore:

`Timeline: UNKNOWN - talk to Zidormi before questing.`

as soon as the player is in a recognized Darkshore variant, before the first Zidormi conversation unless another reliable phase signal already exists.

### Zidormi/Rhonormu detection

On a recognized timeline NPC, Zone Quest Guide reads the offered gossip option as a phase clue.

- A **return/back to the present** option means the character is currently in the older **PAST** state.
- An option offering to show/revisit an earlier version means the character is currently in the **PRESENT** state before switching.

Version 0.2.12 broadens the historical wording recognized on known timeline NPCs. Besides `before` and `past`, it can recognize wording containing phrases such as **show me**, **relive**, **during**, and **age of**. This is needed for timeline options whose exact text is not the Blasted Lands-style "before the invasion" wording.

When the player selects the recognized switch option, Zone Quest Guide records the destination phase immediately and refreshes again after the world state has had a short moment to settle. The phase is keyed to the logical timeline zone rather than only one UiMapID, so it can survive WoW moving the character between alternate map representations of the same historical area.

### Automatic quest-based detection

A curated phase-exclusive quest can also identify the active timeline when WoW reports that quest as active or available. Initial Blasted Lands examples are:

- **Attack of the Iron Horde** — PRESENT / Iron Horde.
- **Under Siege** — PRESENT / Iron Horde.

If contradictory curated evidence appears at the same time, Zone Quest Guide does not guess from that evidence. Manual and NPC-derived signals remain stronger.

Manual overrides remain available as a fallback:

- `/zq phase` — show the current phase mode and, when applicable, the quest used as automatic evidence.
- `/zq phase auto` — clear the current-zone override.
- `/zq phase past` — force past-phase supplemental data.
- `/zq phase present` — force present-phase supplemental data.

## Phase learning

Version 0.2.3 added an account-wide local learning database inside `ZoneQuestGuideDB`.

When Zone Quest Guide has a reliable historical-phase signal for the current map, it records live quest evidence supplied by WoW. The learner can record:

- quests WoW reports as available on the current map;
- quests offered by an NPC;
- accepted quests on the current map;
- active quests shown by an NPC;
- quests accepted while the phase is known;
- quests turned in while the phase is known;
- whether a recorded quest has been completed on a character that observed it.

Data is separated by **map**, **faction**, **quest ID**, and **phase**. Because `ZoneQuestGuideDB` is account-wide, Horde and Alliance alts on the same WoW account can contribute to the same local dataset while still being kept in separate faction buckets.

Accepted-only observations are useful context but are weak phase evidence because an accepted quest can remain in the quest log after a timeline switch. Completion alone is also not treated as proof of the current phase. Learned observations are evidence for review and are not automatically promoted into official `QuestPhaseRequirements`.

Commands:

- `/zq learn` — show the current map's learning status and stored quest count for the current faction.
- `/zq export` — open a copyable anonymous phase-learning report.
- `/zq contribute` — show contribution instructions and the Google Form URL.

The export contains map IDs, faction, phase, quest IDs/names, completion state, observation counts, and phase-source information. It intentionally does not include character names, realm names, or character GUIDs.

## Community reporting

A normal WoW addon cannot perform a general-purpose web upload from Lua, so the manual contribution path still requires the player to copy and submit the learned data.

Once useful data has been learned, the addon can show **Help improve Zone Quest Guide**:

1. Run `/zq export` or click **Open Export**.
2. Copy the anonymous phase report.
3. Open the ZoneQuestGuide Google Form, paste the report, and submit it.

Current form:

`https://forms.gle/Gnqf8kN44kDZxMs86`

The reminder does not upload anything by itself.

### Wago Analytics

Zone Quest Guide also has an optional Wago Analytics telemetry bridge for stronger anonymous phase evidence. It can report:

- a quest WoW reports as available in the current phase;
- a quest actually offered by an NPC;
- an active quest shown by an NPC;
- a quest turned in while the phase is known.

Accepted-only map scans are intentionally excluded from Wago telemetry. Metric keys are limited to map ID, faction, phase, quest ID, evidence type, and the reliable phase source. Character names, realms, guild names, GUIDs, and manual phase overrides are excluded.

The configured Wago project ID is `EGPeM3N1`. Version 0.2.10 bundles the official Wago Analytics shim, loads it through the TOC with `WagoAnalytics` as an optional dependency, includes LibStub, and registers the project during addon loading.

`/zq wago` or `/zq telemetry` reports whether the project is configured, whether the shim registered, and whether the real `WagoAnalytics` addon is loaded on the current client. WoW Lua cannot directly verify the Wago App's Analytics-sharing preference.

The Wago project exists, but no Wago release has been published yet. Until the first release is actually published there, GitHub remains the only distribution platform listed as available.

## Quest automation

Quest automation is optional and defaults to OFF. Open `/zq options` or click **Options**:

- **Auto accept quests** — selects and accepts available quests automatically.
- **Auto turn in completed quests** — advances completed quests and claims the reward when no meaningful reward choice is present.

Quests with multiple reward choices remain open for manual selection. Holding **Shift** while interacting with an NPC temporarily bypasses automation.

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
- `/zq autocomplete`
- `/zq phase`
- `/zq phase auto`
- `/zq phase past`
- `/zq phase present`
- `/zq learn`
- `/zq export`
- `/zq contribute`
- `/zq wago`
- `/zq telemetry`

## Install

1. Exit World of Warcraft.
2. Copy the `ZoneQuestGuide` folder into `World of Warcraft/_retail_/Interface/AddOns/`.
3. Start WoW.
4. Enable **Zone Quest Guide** at character select.
5. Enter the world and use `/zq` if the panel is hidden.

## Important limitations

WoW's live addon APIs do not reliably expose every historical unaccepted side quest. `QuestData.lua` supplements missing quest and navigation information zone-by-zone.

There is no universal API that gives every historical world state a simple human-readable identifier. Zone Quest Guide's registry covers known Zidormi/Rhonormu old/current switches, while quest-based timeline detection only works when a live quest ID is already curated as phase-exclusive.

Some affected zones share a timeline switch NPC located in a different map. In those cases the addon can show the correct warning/phase label but intentionally avoids creating an incorrect same-map waypoint.

Timeline-switch arrow guidance only activates when Zone Quest Guide knows both the active timeline and required quest timeline and has a usable local switcher coordinate.

Phase learning only records a phase association when the historical phase is known from a reliable signal. It does not automatically turn observations into official phase requirements.

## In-game test plan for v0.2.12

1. `/reload` in Darkshore **before talking to Zidormi** and verify the Timeline warning is already visible on the map variant WoW gives the character.
2. Talk to Zidormi and verify the label becomes the correct **PAST** or **PRESENT** Darkshore state.
3. Select the timeline switch once and verify the label follows the destination without requiring a second conversation. WoW may fade the screen while it applies the world phase.
4. Run `/zq learn` after the switch and verify observations are recorded under the displayed timeline.
5. Test at least one additional registered zone such as Arathi Highlands, Uldum, Silithus, Tirisfal Glades, Dustwallow Marsh, or Vale of Eternal Blossoms and verify the pre-conversation warning and gossip detection.
6. In Silithus, verify Rhonormu is recognized if that NPC is the available timeline switcher.
7. If testing Eversong Woods/Ghostlands, verify the warning refers to Zidormi at Thalassian Pass and that the historical **during/age of** wording is recognized without creating a fake local waypoint.
8. With Wago Analytics data sharing enabled, generate a strong phase quest observation and check the development dashboard for the first metric.
9. Verify `/zq contribute` and the Google Form/manual export route still work.

## Roadmap

- Validate the v0.2.12 timeline registry across Retail's Zidormi/Rhonormu locations and correct any additional live map aliases encountered in game.
- Validate Wago Analytics data delivery, then publish the first Zone Quest Guide Wago release when the telemetry path is ready.
- Automate review/import of trusted Google Form phase-data submissions.
- Expand curated phase-exclusive quest mappings from reviewed local/community evidence.
- Add import/merge tooling for trusted community contributions.
- Expand supplemental quest-chain and prerequisite coverage.
- Improve multi-zone route selection.
- Add weekly/other recurring quest sections if useful.
- Add per-character/account-wide completion options.
- Add automatic GitHub release ZIP packaging.

## Release notes

See [`CHANGELOG.md`](CHANGELOG.md).

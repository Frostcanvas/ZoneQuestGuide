# Zone Quest Guide

**Version:** 0.2.13  
**WoW:** Retail 12.1 (`Interface: 120100`)

Zone Quest Guide is a lightweight World of Warcraft addon that shows unfinished quests for the current zone and points the player toward the next useful target.

## Current features

- Detects the current Retail WoW zone/map and refreshes automatically.
- Shows **AVAILABLE**, **TURN IN**, and **IN PROGRESS** quest states.
- Keeps normal **ZONE QUESTS** separate from repeatable **DAILY QUESTS**.
- Prioritizes normal zone quests ahead of dailies, then **AVAILABLE**, **TURN IN**, and **IN PROGRESS** within each section.
- Uses Blizzard super-tracking for accepted quests and temporary user waypoints for available quest starters.
- Replaces old available-quest waypoints when the selected quest changes.
- Adds a floating navigation HUD with a rotating drawn arrow, target name, status, and distance when available.
- Keeps the navigation target stable while a flight path briefly crosses another zone.
- Supports optional **Auto Accept** and **Auto Turn-in** quest automation.
- Supports location hints such as **UPPER LEVEL** for confusing vertical quest locations.
- Recognizes known Retail Zidormi/Rhonormu historical timeline zones, including alternate map IDs and live map/subzone names.
- Shows the detected timeline directly below the current zone name.
- Warns the player to talk to the configured timeline NPC when a known phased zone is still unknown.
- Updates timeline state after Zidormi/Rhonormu switches and, where possible, directly from the old/current map identity.
- Learns phase/quest evidence locally across Horde and Alliance characters.
- Exports anonymous phase-learning data for community contributions.
- Provides a manual Google Form contribution path and an optional Wago Analytics bridge for stronger anonymous phase evidence.

## Navigation HUD

The floating navigation HUD remains visible independently of the main quest list.

- Shows the selected target and status.
- Smoothly rotates toward the destination when WoW exposes usable position/facing data.
- Shows distance in yards when map/world-position data is available.
- Includes supplemental location hints when present.
- **Shift-drag** moves the HUD and saves its position.
- `/zq arrow` toggles it.
- `/zq arrow reset` restores its default position.

### Retail secret-value compatibility

Zone Quest Guide does not calculate a movement-speed ETA. Current Retail clients can return `GetUnitSpeed("player")` as a protected/secret value, so version 0.2.2 removed movement-speed arithmetic and keeps the safe navigation information instead.

## Historical/time phases

Some outdoor zones can exist in older and newer world states. Zone Quest Guide treats these as timeline filters rather than mixing both versions together.

`TimelineZones.lua` contains the central known timeline registry. It uses known UiMapIDs when available and can also match the live map/subzone name because Retail sometimes exposes multiple maps for one named zone.

### Registered timeline locations

- **Dustwallow Marsh / Theramore** — before Theramore's Fall vs. ruined present.
- **Blasted Lands** — before the Iron Horde invasion vs. Iron Horde-incursion present.
- **Peak of Serenity** — pre-Legion monastery vs. post-Legion state; scoped to the Peak of Serenity subzone rather than all of Kun-Lai Summit.
- **Silithus** — before the Wound vs. Wound-era present; **Rhonormu** is also recognized.
- **Darkshore** — before the War of the Thorns/Burning of Teldrassil vs. current-era Darkshore.
- **Teldrassil / Darnassus** — share the Darkshore timeline state where appropriate.
- **Tirisfal Glades** — before the Battle for Lordaeron vs. later present.
- **Undercity** — can share the Tirisfal timeline state where appropriate.
- **Arathi Highlands** — before the Battle for Stromgarde vs. warfront-era state.
- **Uldum** — Cataclysm-era Uldum vs. N'Zoth-assault-era state.
- **Vale of Eternal Blossoms** — before the N'Zoth assaults vs. assault-era state.
- **Eversong Woods / Ghostlands / Silvermoon City** — Burning Crusade-era Quel'Thalas vs. Midnight-era Quel'Thalas, with Zidormi at Thalassian Pass.

The registry models the old/current Zidormi-style pair. It does not claim to identify every internal scenario, campaign, faction-control, or warfront phase inside a current-era zone.

### Zidormi/Rhonormu detection

On a recognized timeline NPC, Zone Quest Guide reads the offered gossip option as a phase clue.

- A **return/back to the present** option means the character is currently in the older **PAST** state.
- An option offering to show/revisit an earlier version means the character is currently in the **PRESENT** state before switching.

Known historical wording can include phrases such as **before**, **past**, **show me**, **relive**, **during**, and **age of**.

When a recognized switch is selected, the addon records the destination phase and refreshes again after the world state has had time to settle.

### Midnight Quel'Thalas / Burning Crusade portal

Version 0.2.13 handles the newer Quel'Thalas layout as a map-separated timeline instead of relying only on Zidormi session state.

- Midnight **Silvermoon City**: UiMapID `2393` -> **PRESENT / Midnight Quel'Thalas**.
- Midnight **Eversong Woods**: UiMapID `2395` -> **PRESENT / Midnight Quel'Thalas**.
- Legacy Burning Crusade Eversong/Ghostlands/Silvermoon map IDs are treated as **PAST / Burning Crusade Quel'Thalas**.
- Name fallbacks recognize `Ghostlands`, `Ghostlands (Burning Crusade)`, `Eversong Woods (Burning Crusade)`, and equivalent legacy Silvermoon naming if WoW exposes them.

This matters because the Thalassian Pass portal can move the character into the legacy area without a Zidormi gossip click. Zidormi's historical option can also transport the character there. Zone Quest Guide therefore trusts the actual old/current map identity over a cached session phase when the map itself is decisive.

Portal/world/zone transitions trigger a full timeline refresh so quest filtering, phase learning, the Timeline line, and Wago phase telemetry can follow the map change.

### Automatic quest-based detection

A curated phase-exclusive quest can also identify the active timeline when WoW reports that quest as active or available. Initial Blasted Lands examples are:

- **Attack of the Iron Horde** — PRESENT / Iron Horde.
- **Under Siege** — PRESENT / Iron Horde.

If contradictory curated evidence appears at the same time, Zone Quest Guide does not guess from that evidence. Manual and stronger timeline signals remain preferred.

Manual overrides remain available as a fallback:

- `/zq phase` — show current phase/source.
- `/zq phase auto` — clear the current-zone override.
- `/zq phase past` — force past-phase supplemental data.
- `/zq phase present` — force present-phase supplemental data.

## Phase learning

The account-wide `ZoneQuestGuideDB` learning store records live quest evidence when the current historical phase is known from a reliable signal.

It can record:

- quests WoW reports as available on the current map;
- quests offered by an NPC;
- accepted quests on the current map;
- active quests shown by an NPC;
- quests accepted while the phase is known;
- quests turned in while the phase is known;
- supporting completion state.

Data is separated by **map**, **faction**, **quest ID**, and **phase**.

Accepted-only observations are weak phase evidence because an accepted quest can remain in the quest log after a timeline switch. Completion alone is also not proof of the current phase. Learned observations are evidence for review and are not automatically promoted into official `QuestPhaseRequirements`.

Commands:

- `/zq learn` — show phase-learning status.
- `/zq export` — open a copyable anonymous phase-learning report.
- `/zq contribute` — show contribution instructions and Google Form URL.

The export intentionally excludes character names, realm names, and character GUIDs.

## Community reporting

### Manual Google Form

Current contribution form:

`https://forms.gle/Gnqf8kN44kDZxMs86`

The addon can remind the player when useful data exists, but it does not upload the export automatically. The player chooses whether to copy and submit it.

### Wago Analytics

Zone Quest Guide includes an optional Wago Analytics bridge for stronger anonymous phase evidence. It can report:

- a quest WoW reports as available in the current phase;
- a quest actually offered by an NPC;
- an active quest shown by an NPC;
- a quest turned in while the phase is known.

Accepted-only map scans are intentionally excluded. Metric keys are limited to map ID, faction, phase, quest ID, evidence type, and reliable phase source. Character names, realms, guild names, GUIDs, and manual phase overrides are excluded.

Configured Wago project ID: `EGPeM3N1`.

The addon bundles the official Wago Analytics shim and LibStub, keeps `WagoAnalytics` optional, and registers the project during addon loading.

- `/zq wago` — show Wago bridge status.
- `/zq telemetry` — alias for `/zq wago`.

WoW Lua cannot directly verify the Wago App's Analytics-sharing preference.

The Wago project exists, but no Wago release has been published yet. GitHub remains the only listed distribution platform until a Wago release is actually available.

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

- `/zq`
- `/zq show`
- `/zq hide`
- `/zq refresh`
- `/zq auto`
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

There is no universal API that gives every historical world state a simple human-readable identifier. Zone Quest Guide's registry covers known old/current switches, while quest-based timeline detection only works when a live quest ID is already curated as phase-exclusive.

Some affected zones share a switch NPC located on a different map. In those cases the addon can show the warning/phase label but intentionally avoids creating a false same-map waypoint.

Phase learning only records a phase association when the historical phase is known from a reliable signal. It does not automatically turn observations into official phase requirements.

## In-game test plan for v0.2.13

1. `/reload` in current Midnight **Silvermoon City** and verify the timeline identifies **PRESENT / Midnight Quel'Thalas** without talking to Zidormi.
2. Move into current Midnight **Eversong Woods** and verify it remains PRESENT.
3. At Thalassian Pass, use the portal into the legacy Burning Crusade area without selecting Zidormi's gossip option. Verify the Timeline line changes to **PAST / Burning Crusade Quel'Thalas** from the map transition alone.
4. Confirm the old zone/map name WoW reports (for example Ghostlands or a `(Burning Crusade)` name) and verify `/zq phase` agrees with the displayed timeline.
5. Use the return path/portal back to Midnight and verify the Timeline line returns to PRESENT without requiring a second Zidormi conversation.
6. Separately test Zidormi's historical gossip teleport and make sure the map-derived PAST state agrees after arrival.
7. Run `/zq learn` on both sides and verify observations are stored under the correct timeline/map.
8. With Wago Analytics data sharing enabled, generate a strong quest observation on a known phase and check the development dashboard for data.
9. Continue checking Darkshore and at least one additional registered Zidormi/Rhonormu location.

## Roadmap

- Validate v0.2.13 Quel'Thalas portal/map detection in both directions and capture any additional live map aliases.
- Validate the v0.2.12 registry across the remaining Retail Zidormi/Rhonormu locations.
- Validate Wago Analytics data delivery, then publish the first Zone Quest Guide Wago release when ready.
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

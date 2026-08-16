# Zone Quest Guide

**Version:** 0.2.14  
**WoW:** Retail 12.1 (`Interface: 120100`)

Zone Quest Guide is a lightweight World of Warcraft addon that shows unfinished quests for the current zone and points the player toward the next useful target.

## Current features

- Detects the current Retail WoW zone/map and refreshes automatically.
- Shows **AVAILABLE**, **TURN IN**, and **IN PROGRESS** quest states.
- Keeps normal **ZONE QUESTS** separate from repeatable **DAILY QUESTS**.
- Prioritizes normal zone quests ahead of dailies, then **AVAILABLE**, **TURN IN**, and **IN PROGRESS**.
- Uses Blizzard super-tracking for accepted quests and temporary user waypoints for available quest starters.
- Adds a floating navigation HUD with a rotating arrow, target name, status, and distance when available.
- Supports optional **Auto Accept** and **Auto Turn-in** quest automation.
- Supports location hints such as **UPPER LEVEL** for confusing vertical quest locations.
- Recognizes known Retail Zidormi/Rhonormu historical timeline zones.
- Learns phase/quest evidence locally when the current historical phase is known.
- Learns **map ID + map name + quest associations even when no historical phase is known**.
- Exports anonymous learning data for community review.
- Provides a manual Google Form contribution path and an optional Wago Analytics bridge for stronger anonymous phase evidence.

## Map and quest learning

Version 0.2.14 adds a separate account-wide map/quest learning store in `ZoneQuestGuideDB.mapQuestLearning`.

Whenever WoW exposes a quest through the current map, an available quest line, an NPC gossip list, a quest-detail window, quest acceptance, or quest turn-in, Zone Quest Guide can record:

- the current `UiMapID`;
- the map name returned by WoW;
- faction;
- quest ID and quest name;
- whether the quest was seen as available, offered, accepted, active, or turned in;
- supporting completion state.

This map collector does **not** require Zidormi or any known timeline. That makes it useful for discovering live Retail map aliases and replacement maps such as the new Midnight Quel'Thalas map.

Commands:

- `/zq maps` — show the current map ID/name and how many quests have been recorded for the current faction.
- `/zq mapexport` — open only the map/quest learning export.
- `/zq export` — now opens the normal phase-learning export followed by the map/quest learning block.

The map export format starts with:

`ZQGMAPQUESTDATA|1`

and contains `mapID`, `mapName`, faction, quest ID/name, and observation counts. It intentionally does not include character names, realm names, GUIDs, guild names, or account identifiers.

## Historical/time phases

Some outdoor zones can exist in older and newer world states. Zone Quest Guide treats these as timeline filters rather than mixing both versions together.

Known timeline locations currently include:

- **Dustwallow Marsh / Theramore**
- **Blasted Lands**
- **Peak of Serenity**
- **Silithus**
- **Darkshore**
- **Teldrassil / Darnassus** where tied to the Darkshore state
- **Tirisfal Glades / Undercity**
- **Arathi Highlands**
- **Uldum**
- **Vale of Eternal Blossoms**
- **Quel'Thalas / Eversong Woods / Ghostlands / Silvermoon City**

The registry models the old/current Zidormi-style pair. It does not claim to identify every scenario, campaign, faction-control, or warfront state inside a current-era zone.

### Live-confirmed Midnight Quel'Thalas maps

During Retail testing, WoW returned:

- **UiMapID `2537` / `Quel'Thalas`** while standing in the current Midnight world.
- **UiMapID `95` / `Ghostlands`** after entering the old Burning Crusade Ghostlands.

Version 0.2.14 treats `2537` as a reliable **PRESENT / Midnight Quel'Thalas** signal. The existing timeline registry already treats map `95` as **PAST / Burning Crusade Quel'Thalas**.

The Thalassian Pass portal can move the player into the old Burning Crusade area without selecting Zidormi gossip, while Zidormi can also teleport the player there. For this layout, the actual map identity is therefore a stronger signal than a cached conversation state.

### Zidormi/Rhonormu detection

On a recognized timeline NPC, Zone Quest Guide reads the offered gossip option as a phase clue.

- A **return/back to the present** option means the character is currently in the older **PAST** state.
- An option offering to show/revisit an earlier version means the character is currently in the **PRESENT** state before switching.

Known historical wording can include phrases such as **before**, **past**, **show me**, **relive**, **during**, and **age of**.

Manual overrides remain available as a fallback:

- `/zq phase`
- `/zq phase auto`
- `/zq phase past`
- `/zq phase present`

## Phase learning

The account-wide `ZoneQuestGuideDB.phaseLearning` store records quest evidence when Zone Quest Guide has a reliable historical-phase signal.

It can record quests WoW reports as available, offered by an NPC, accepted, active at an NPC, or turned in in that phase. Accepted-only observations are treated as weak phase evidence because an accepted quest can remain in the quest log after switching timelines.

Commands:

- `/zq learn` — show phase-learning status.
- `/zq export` — open the combined phase + map/quest learning export.
- `/zq contribute` — show contribution instructions and the Google Form URL.

## Community reporting

### Manual Google Form

Current contribution form:

`https://forms.gle/Gnqf8kN44kDZxMs86`

The addon can remind the player when useful data exists, but it does not silently upload the manual export. The player chooses whether to copy and submit it.

### Wago Analytics

Zone Quest Guide includes an optional Wago Analytics bridge for stronger anonymous phase evidence. The configured project ID is `EGPeM3N1`.

The bridge reports only stronger phase observations such as available, offered, active, and turned-in quest evidence. Metric keys include the map ID, faction, phase, quest ID, evidence type, and reliable phase source. Character names, realms, guild names, GUIDs, and manual phase overrides are excluded.

- `/zq wago` — show Wago bridge status.
- `/zq telemetry` — alias for `/zq wago`.

The Wago project and Analytics dashboard exist, but no downloadable Wago release has been published yet. **GitHub remains the only listed distribution platform until a Wago release is actually available.**

## Navigation HUD

The floating navigation HUD remains visible independently of the main quest list.

- Shows the selected target and status.
- Rotates toward the destination when WoW exposes usable position/facing data.
- Shows distance in yards when map/world-position data is available.
- Includes supplemental location hints when present.
- **Shift-drag** moves the HUD and saves its position.
- `/zq arrow` toggles it.
- `/zq arrow reset` restores its default position.

Zone Quest Guide does not calculate a movement-speed ETA because current Retail clients can expose movement speed as a protected/secret value.

## Quest automation

Quest automation is optional and defaults to OFF. Open `/zq options` or click **Options**:

- **Auto accept quests** — selects and accepts available quests automatically.
- **Auto turn in completed quests** — advances completed quests and claims the reward when no meaningful reward choice is present.

Quests with multiple reward choices remain open for manual selection. Holding **Shift** while interacting with an NPC temporarily bypasses automation.

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
- `/zq maps`
- `/zq export`
- `/zq mapexport`
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

WoW's live addon APIs do not reliably expose every historical unaccepted side quest. Supplemental data still has to be reviewed and expanded over time.

Map/quest learning records what WoW exposes on the player's current map; it is evidence, not automatic proof that a quest belongs exclusively to that map or timeline.

Phase learning only records a phase association when the historical phase is known from a reliable signal. Learned observations are not automatically promoted into official quest-phase requirements.

## In-game test plan for v0.2.14

1. In current Midnight Quel'Thalas, run `/zq maps` and verify it reports map `2537 / Quel'Thalas`.
2. Let the addon see one or more quests, then run `/zq mapexport` and confirm rows are stored under map `2537`.
3. Use the Thalassian Pass portal into old Ghostlands and verify `/zq maps` reports map `95 / Ghostlands`.
4. Let the addon see quests there and confirm `/zq mapexport` stores those quests separately under map `95`.
5. Verify the Timeline line shows **PRESENT / Midnight Quel'Thalas** on map `2537` and **PAST / Burning Crusade Quel'Thalas** on map `95`.
6. Run `/zq export` and verify both the phase block and the `ZQGMAPQUESTDATA|1` block appear.
7. Confirm the normal quest list, navigation, Auto Accept/Turn-in, Google Form contribution flow, and Wago telemetry still behave normally.

## Roadmap

- Use collected map/quest associations to discover more live Retail map aliases automatically.
- Validate remaining Zidormi/Rhonormu timeline zones in-game.
- Continue validating Wago Analytics quest counters before the first Wago release.
- Automate review/import of trusted Google Form submissions.
- Expand curated phase-exclusive quest mappings from reviewed evidence.
- Expand supplemental quest-chain and prerequisite coverage.
- Add automatic GitHub release ZIP packaging.

## Release notes

See [`CHANGELOG.md`](CHANGELOG.md).

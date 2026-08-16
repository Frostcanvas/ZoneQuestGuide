# Zone Quest Guide

**Version:** 0.2.21  
**WoW:** Retail 12.1 (`Interface: 120100`)

Zone Quest Guide is a lightweight World of Warcraft addon that shows unfinished quests for the current zone, points the player toward the next useful target, and learns anonymous map/quest and timeline evidence while the player quests.

## Current features

- Detects the current Retail WoW zone/map and refreshes automatically.
- Shows **AVAILABLE**, **TURN IN**, and **IN PROGRESS** quest states.
- Keeps normal **ZONE QUESTS** separate from repeatable **DAILY QUESTS**.
- Prioritizes normal zone quests ahead of dailies, then AVAILABLE, TURN IN, and IN PROGRESS.
- Uses Blizzard super-tracking for accepted quests and temporary user waypoints for available quest starters.
- Adds a floating navigation HUD with a rotating arrow, target name, status, and distance when available.
- Supports optional Auto Accept and Auto Turn-in.
- Recognizes known Zidormi/Rhonormu historical timeline zones.
- Learns phase/quest evidence locally when a historical phase is known.
- Learns **map ID + map name + quest associations** even when no historical phase is known.
- Exports anonymous learning data with WoW-safe tab-separated fields.
- Can forward stronger anonymous phase and map/quest evidence through Wago Analytics when the player has Wago Analytics sharing enabled.
- Builds a clean GitHub package named **ZoneQuestGuide.zip** through GitHub Actions.
- Includes stable `/zq phase`, `/zq maps`, `/zq mapid`, and `/zq check` diagnostics.

## Map and quest learning

Zone Quest Guide keeps an account-wide `ZoneQuestGuideDB.mapQuestLearning` store. When WoW exposes a quest through the current map, an available quest line, NPC gossip, a quest-detail screen, quest acceptance, or quest turn-in, the addon can record:

- live `UiMapID` and map name;
- faction;
- quest ID and quest name;
- whether the quest was seen as available, offered, accepted, active, or turned in;
- supporting completion state.

The map collector does not require Zidormi or a known timeline. This is useful for discovering live Retail replacement/alias maps such as Midnight Quel'Thalas.

Map scans are skipped while the player is on a taxi flight path so transient parent/flyover maps are not learned simply because the flight crossed them.

Commands:

- `/zq maps` — show current map ID/name and locally learned quest count.
- `/zq mapid` — show only WoW's current live map ID/name.
- `/zq mapexport` — open only the map/quest learning export.
- `/zq export` — open the phase-learning export followed by the map/quest block.

### Export format

Current exports use tab-separated schema version 2:

- `ZQGPHASEDATA|2`
- `ZQGMAPQUESTDATA|2`

Tabs avoid WoW interpreting normal pipe-delimited field boundaries as text-formatting escape sequences. Exports intentionally omit character names, realm names, GUIDs, guild names, and account identifiers.

## Historical/time phases

Known timeline locations currently include Dustwallow Marsh/Theramore, Blasted Lands, Peak of Serenity, Silithus, Darkshore, Teldrassil/Darnassus where tied to Darkshore, Tirisfal Glades/Undercity, Arathi Highlands, Uldum, Vale of Eternal Blossoms, and Quel'Thalas/Eversong/Ghostlands/Silvermoon.

Most locations use a two-state old/current model. **Arathi Highlands is handled separately because current Retail exposes three useful Zidormi states: before the Fourth War, the Fourth War/Warfront era, and the current-present state.**

### Live-confirmed Midnight Quel'Thalas maps

Retail testing returned:

- `2537 / Quel'Thalas` in the current Midnight world.
- `95 / Ghostlands` in the old Burning Crusade version.

Zone Quest Guide treats `2537` as **PRESENT / Midnight Quel'Thalas** and `95` as **PAST / Burning Crusade Quel'Thalas**.

### Live-confirmed Blasted Lands behavior

Retail testing confirmed both **PRESENT / Iron Horde** and **PAST / Before invasion** can return `17 / Blasted Lands`. Map ID alone therefore cannot classify the Blasted Lands timeline; Zidormi or reliable phase-exclusive quest evidence is still required.

### Live-confirmed Tirisfal Glades maps

Retail testing confirmed Tirisfal uses separate live maps across the Zidormi switch:

- `2070 / Tirisfal Glades` was observed in **PRESENT / After Battle for Lordaeron** while Zidormi offered to show the zone before the Battle for Lordaeron.
- After selecting that historical option, `/zq check` returned `18 / Tirisfal Glades` and the addon showed **PAST / Before Battle for Lordaeron**; Zidormi then offered to return the player to the present time.

Version 0.2.20 adds direct map-derived Tirisfal detection so map `2070` can identify PRESENT and map `18` can identify PAST without requiring a new Zidormi conversation first. Map `1247` remains registered as an alternate Tirisfal context but is not assigned a phase until its live role is observed.

### Live-confirmed Uldum maps

Retail testing confirmed Uldum also uses separate live maps across its Zidormi switch:

- `1527 / Uldum` was observed in **PRESENT / N'Zoth assaults** while Zidormi offered **"Can you show me what Uldum was like during the time of the Cataclysm?"**.
- After selecting that historical option, the live map changed to `249 / Uldum`. The main timeline line showed **PAST / Cataclysm Uldum** after Zidormi was reopened, and Zidormi offered **"Can you return me to the present time?"**.

The recording also caught a stale diagnostic moment where `/zq check` reported map `249` as PRESENT before the new map's gossip state had refreshed. Version 0.2.21 fixes that by treating `1527` as direct PRESENT evidence and `249` as direct PAST evidence. Uldum-related maps `1330` and `1571` remain registered but unclassified until their live role is observed.

### Live-confirmed Arathi Highlands behavior

Current Retail testing has now covered all three useful Arathi states:

- `2372 / Arathi Highlands` = **PRESENT / Current Arathi Highlands**.
- `14 / Arathi Highlands` can be the **FOURTH WAR / Warfront era** state when Zidormi offers both the before-war and present-time destinations.
- `14 / Arathi Highlands` is also reused for **PAST / Before Fourth War**; in that state Zidormi offers a return to the Highlands during the Fourth War.

The addon therefore does not treat map `14` alone as enough to distinguish the two older Arathi states. It uses Zidormi's available destinations and the selected destination to distinguish PAST from FOURTH WAR, while map `2372` is a direct current-present signal.

Arathi timeline labels are:

- `PAST / Before Fourth War`
- `FOURTH WAR / Warfront era`
- `PRESENT / Current Arathi Highlands`

## Zidormi/Rhonormu detection

For normal two-state locations, Zone Quest Guide reads the offered timeline gossip option as a phase clue. A return/back-to-present option means the player is in the older state; wording such as before, past, show me, relive, during, or age of can indicate an older destination.

Arathi uses its dedicated three-state handler rather than forcing those options into a two-state present/past model.

Manual overrides remain available as a fallback:

- `/zq phase auto`
- `/zq phase past`
- `/zq phase present`

## Stable diagnostics

`SlashDiagnostics.lua` loads last so timeline/map testing commands cannot accidentally fall through to Core.lua's default show/hide behavior.

- `/zq phase` — current timeline, source, map ID, and map name.
- `/zq maps` — current map plus local learned quest count.
- `/zq mapid` — live map ID/name.
- `/zq check` — map ID/name, timeline/source, learned quest count, and current-session Wago phase/map-quest counts.
- `/zq debug` — alias for `/zq check`.

## Phase learning

`ZoneQuestGuideDB.phaseLearning` stores quest evidence when Zone Quest Guide has a reliable historical-phase signal. Available, offered, accepted, active, and turned-in observations can be stored locally; accepted-only evidence is considered weak because a quest can remain accepted after changing maps or timelines.

Learned observations are evidence only and are not automatically promoted into curated quest-phase requirements.

## Community reporting

### Manual Google Form

Current contribution form:

`https://forms.gle/Gnqf8kN44kDZxMs86`

The addon can remind the player when useful data exists, but the player chooses whether to copy and submit the manual export.

### Wago Analytics

Configured project ID: `EGPeM3N1`.

When WagoAnalytics is available, Zone Quest Guide can contribute two anonymous streams while the player quests normally:

- **Phase evidence:** map ID, faction, reliable phase, quest ID, evidence type, and phase source.
- **Map/quest evidence:** map ID, faction, quest ID, and evidence type even when no historical phase is known.

Only stronger **available**, **offered**, **active**, and **turned-in** observations are automatically reported. Accepted-only and generic seen observations remain local. Taxi-flight scans are suppressed.

Character names, realms, guild names, GUIDs, account identifiers, quest names, and manual phase overrides are not included in Wago metric keys.

- `/zq wago` — show Wago bridge status and this UI session's phase/map-quest queued counts.
- `/zq telemetry` — alias for `/zq wago`.

The Uldum test recording confirmed in-game that WagoAnalytics was loaded and that the session counters increased while the character generated quest/timeline evidence: phase observations rose from `3` to `9`, and map/quest observations rose from `29` to `32`. That confirms the addon is queuing evidence through the loaded Wago client. It does **not** by itself confirm server/dashboard receipt of the new counters.

Wago upload still depends on the player's Wago App Analytics-sharing setting. No downloadable Wago release has been published yet, so **GitHub remains the only listed distribution platform**.

## Navigation HUD

The floating navigation HUD stays visible independently of the main quest list. It shows the selected target/status, rotates toward the destination when WoW exposes usable position/facing data, and shows distance when usable map/world-position data is available.

- Shift-drag to move it.
- `/zq arrow` toggles it.
- `/zq arrow reset` restores the default position.

Zone Quest Guide does not calculate movement-speed ETA because current Retail clients can expose movement speed as a protected/secret value.

## Quest automation

Quest automation defaults to OFF. Open `/zq options` to control:

- **Auto accept quests**
- **Auto turn in completed quests**

Quests with meaningful reward choices remain open for manual selection. Holding Shift while interacting with an NPC temporarily bypasses automation.

## Commands

- `/zq`, `/zq show`, `/zq hide`, `/zq refresh`, `/zq auto`
- `/zq minimap`
- `/zq arrow`, `/zq arrow reset`
- `/zq options`, `/zq autoaccept`, `/zq autoturnin`, `/zq autocomplete`
- `/zq phase`, `/zq phase auto`, `/zq phase past`, `/zq phase present`
- `/zq learn`, `/zq maps`, `/zq mapid`, `/zq check`, `/zq debug`
- `/zq export`, `/zq mapexport`, `/zq contribute`
- `/zq wago`, `/zq telemetry`

## GitHub ZIP packages

GitHub's built-in **Code -> Download ZIP** is a source archive and will still use a branch suffix such as `ZoneQuestGuide-main.zip`. The repository's GitHub Actions packaging workflow produces a clean artifact named **ZoneQuestGuide.zip** containing a top-level `ZoneQuestGuide/` addon folder. GitHub Releases can also receive a versioned package such as `ZoneQuestGuide-0.2.21.zip`.

## Install

1. Exit World of Warcraft.
2. Download the packaged `ZoneQuestGuide.zip` or a versioned GitHub Release ZIP.
3. Place the top-level `ZoneQuestGuide` folder into `World of Warcraft/_retail_/Interface/AddOns/`.
4. Start WoW and enable **Zone Quest Guide**.
5. Use `/zq` if the panel is hidden.

## Important limitations

WoW's live addon APIs do not reliably expose every historical unaccepted side quest. Map/quest learning records evidence, not automatic proof that a quest belongs exclusively to one map or timeline. Wago counters are aggregated evidence and do not replace review of local/manual exports.

## In-game/test plan for v0.2.21

1. Update to v0.2.21 and `/reload` in Uldum.
2. In the N'Zoth/current state, run `/zq check` **before** talking to Zidormi. Map `1527` should report **PRESENT / N'Zoth assaults (detected)**.
3. Switch to Cataclysm Uldum and run `/zq check` **before** reopening Zidormi. Map `249` should report **PAST / Cataclysm Uldum (detected)** instead of briefly showing PRESENT.
4. Return to the present and confirm map `1527` flips back to PRESENT without retaining stale session state.
5. Continue the v0.2.20 Tirisfal check: `2070` should be PRESENT and `18` should be PAST before talking to Zidormi.
6. Continue verifying Arathi's three-state handler: `2372` should show PRESENT, while map `14` should switch between FOURTH WAR and PAST based on Zidormi's destination set/selection.
7. With WagoAnalytics loaded, continue generating strong quest evidence and confirm the session counters increase; then separately check the Wago development dashboard for the new `mapquest_m...` and `map_quest_evidence_total` counters.
8. Continue checking `/zq mapexport` and `/zq export` for intact tab-separated headers and quest names.

## Roadmap

- Use collected map/quest associations to discover more Retail map aliases automatically.
- Validate remaining Zidormi/Rhonormu timeline zones in-game, especially Silithus and Darkshore.
- Identify the live role of alternate timeline-related map IDs such as Tirisfal `1247` and Uldum `1330`/`1571`.
- Review Wago map/quest telemetry volume/cardinality before the first public Wago release.
- Automate review/import of trusted Google Form submissions.
- Expand curated phase-exclusive quest mappings and supplemental quest-chain coverage.

## Release notes

See [`CHANGELOG.md`](CHANGELOG.md).

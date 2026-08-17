# Zone Quest Guide

**Version:** 0.2.25  
**WoW:** Retail 12.1 (`Interface: 120100`)

Zone Quest Guide is a lightweight World of Warcraft addon that shows unfinished quests for the current zone, points the player toward the next useful target, and learns anonymous map/quest, timeline, and instance evidence while the player quests.

## Current features

- Detects the current Retail WoW zone/map and refreshes automatically.
- Shows **AVAILABLE**, **TURN IN**, and **IN PROGRESS** quest states.
- Keeps normal **ZONE QUESTS** separate from repeatable **DAILY QUESTS**.
- Prioritizes normal zone quests ahead of dailies, then AVAILABLE, TURN IN, and IN PROGRESS.
- Uses Blizzard super-tracking for accepted quests and temporary user waypoints for available quest starters.
- Adds a floating navigation HUD with a rotating arrow, target name, status, and distance when available.
- Supports optional Auto Accept and Auto Turn-in.
- Supports supplemental quest prerequisites, later-progression blockers, and mutually exclusive quest routes.
- Recognizes known Zidormi/Rhonormu historical timeline zones.
- Learns phase/quest evidence locally when a historical phase is known.
- Learns **map ID + map name + quest associations** even when no historical phase is known.
- Learns anonymous instance/scenario fingerprints such as map ID, instance ID, difficulty ID, LFG ID, instance type, and group-size metadata.
- Exports anonymous learning data with WoW-safe tab-separated fields.
- Can forward stronger anonymous phase, map/quest, map-visit, phase-visit, and instance-fingerprint evidence through Wago Analytics when the player has Wago Analytics sharing enabled.
- Mirrors privacy-safe map, reliable-phase, and instance discoveries into Wago **Switches** so useful crowd observations remain visible while Wago's Counters dashboard is unavailable.
- Builds a clean GitHub package named **ZoneQuestGuide.zip** through GitHub Actions.
- Includes stable `/zq phase`, `/zq maps`, `/zq mapid`, `/zq inspect`, and `/zq check` diagnostics.

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
- `/zq export` — open the combined phase, map/quest, and instance-learning export.

### Export format

Current combined exports use tab-separated schemas:

- `ZQGPHASEDATA|2`
- `ZQGMAPQUESTDATA|2`
- `ZQGINSTANCEDATA|1`

Tabs avoid WoW interpreting normal pipe-delimited field boundaries as text-formatting escape sequences. Exports intentionally omit character names, realm names, GUIDs, guild names, account identifiers, chat, coordinates, and party/raid member names.

## Instance and scenario learning

Version 0.2.24 adds an account-wide `ZoneQuestGuideDB.instanceLearning` store for unusual instanced content such as Warfronts, scenarios, raids, dungeons, and other queueable maps. When the player actually loads into an instance, Zone Quest Guide can record a coarse fingerprint containing:

- live `UiMapID` and map name;
- parent map ID/name when WoW provides one;
- instance ID/name and instance type;
- difficulty ID/name;
- maximum-player and instance-group-size values exposed by WoW;
- LFG dungeon ID when available;
- scenario name/type/area metadata when available;
- faction and the current Zone Quest Guide timeline/source if one is known.

`/zq inspect` (also `/zq instance`) prints the current fingerprint directly in chat. This is intended for tests such as comparing **Normal vs Heroic Battle for Stromgarde** or identifying which of Blizzard's alternate Arathi/Darkshore map IDs is actually used by a Warfront instance.

`/zq instanceexport` opens just the instance-learning block. `/zq export` includes the instance block after the existing phase and map/quest blocks.

The local export can contain Blizzard's localized instance/scenario names because the player explicitly chooses whether to copy it. Automatic Wago instance telemetry is stricter: it sends only coarse IDs/type/faction/group-size fields and does not include instance names, scenario names, coordinates, timestamps, character/account identity, chat, or group-member information.

### Live-confirmed Heroic Battle for Stromgarde fingerprint

Retail testing on an Alliance character inside Heroic Battle for Stromgarde returned:

- `1044 / Arathi Highlands` as the live `UiMapID`;
- parent map `13 / Eastern Kingdoms`;
- instance `1943 / Warfronts Arathi - Alliance`;
- instance type `scenario`;
- difficulty `149 / Heroic`;
- `maxPlayers=30` and `groupSize=10`;
- `LFG=2007`;
- scenario `The Battle for Stromgarde`;
- faction `Alliance`;
- timeline `UNKNOWN (auto)` inside the Warfront.

The same in-game `/zq check` showed Wago loaded with `instancevisit=1`, confirming the v0.2.24 instance fingerprint was queued locally through WagoAnalytics. Normal Stromgarde still needs to be compared against this fingerprint.

## Supplemental quest availability

WoW does not expose every older unaccepted quest through the live map APIs, so Zone Quest Guide can supplement missing quests in `QuestData.lua`. Version 0.2.22 expands those records with three availability rules:

```lua
prereqs = { 11111 }        -- every listed quest must be completed first
blockedBy = { 22222 }       -- hide this quest if any listed quest was completed
exclusiveWith = { 33333 }   -- hide if any listed quest is active or completed
```

`prereqs` models the normal quest-chain order. `blockedBy` is intended for breadcrumbs or older quests that become permanently unavailable after later progression. `exclusiveWith` is intended for route choices where accepting another quest commits the character to the other path; if that other quest is merely abandoned before completion, the supplemental quest can become eligible again on the next refresh.

These rules are applied to supplemental database records. Live quests supplied directly by Blizzard's APIs are still trusted as currently obtainable/active and are not hidden by supplemental-only rules. No guessed blocker/exclusive relationships are added automatically; quest IDs should be added only when the relationship is known or observed.

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

### Live-confirmed Silithus behavior

Retail testing confirmed both **PAST / Before the Wound** and **PRESENT / The Wound** return `81 / Silithus`. Silithus therefore cannot be classified from the best-map ID alone. In the recorded switch, Zidormi's **return to the present** wording correctly identified the old state, and after switching her **before the Wound** option correctly identified the present state. The existing same-map Zidormi detection followed the switch in-game.

Related Silithus map IDs `1321` and `2354` remain registered as alternate contexts but are not assumed to represent a specific timeline until their live role is observed.

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
- `/zq inspect` — current map/parent map plus instance, difficulty, LFG, scenario, faction, and timeline context.
- `/zq check` — map ID/name, timeline/source, learned quest count, current-session Wago phase/map/visit/instance counts, and dashboard discovery-switch count.
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

When WagoAnalytics is available, Zone Quest Guide can contribute anonymous evidence while the player uses the addon normally:

- **Phase quest evidence:** map ID, faction, reliable phase, quest ID, evidence type, and phase source.
- **Map/quest evidence:** map ID, faction, quest ID, and evidence type even when no historical phase is known.
- **Map visits:** map ID + faction, once per map/faction during the UI session.
- **Phase visits:** map ID + faction + reliable Zidormi/detected phase/source.
- **Instance visits:** map ID, instance ID, difficulty ID, LFG ID, maximum/group-size values, instance type, and faction.
- **Dashboard discovery switches:** privacy-safe mirrors of map, reliable-phase, and instance visits using `seen_map_...`, `seen_phase_...`, and `seen_instance_...` names.

Version 0.2.25 adds the switch mirrors because Wago's Analytics **Counters** page currently reports that its dashboard will be released later, while the **Switches** dashboard is already available. The existing counters remain enabled; the switches are a visibility layer rather than a replacement for aggregate counters.

Only stronger **available**, **offered**, **active**, and **turned-in** quest observations are automatically reported. Accepted-only and generic seen observations remain local. Taxi-flight map scans are suppressed. Reliable phase mirrors require a `zidormi` or `detected` source; manual phase overrides are not promoted into community telemetry.

Character names, realms, guild names, GUIDs, account identifiers, quest names, instance names, scenario names, coordinates, timestamps, chat, party/raid member names, and manual phase overrides are not included in Wago metric or discovery-switch names.

Dynamic discovery switches are deduplicated for the current UI session and capped at 200 per session so unusually long exploration sessions leave headroom for Zone Quest Guide's normal Wago feature switches.

- `/zq wago` — show Wago bridge status and this UI session's queued counters/discovery switches.
- `/zq telemetry` — alias for `/zq wago`.

The Wago App was observed with **Support Addon Developers** enabled and its Developers page reporting a transmitted analytics timestamp. The Wago website then displayed ZoneQuestGuide's existing custom feature switches, confirming that switch data reached the Analytics dashboard. The new v0.2.25 dynamic discovery-switch names still require their own post-update in-game test.

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
- `/zq learn`, `/zq maps`, `/zq mapid`, `/zq inspect`, `/zq check`, `/zq debug`
- `/zq export`, `/zq mapexport`, `/zq instanceexport`, `/zq contribute`
- `/zq wago`, `/zq telemetry`

## GitHub ZIP packages

GitHub's built-in **Code -> Download ZIP** is a source archive and will still use a branch suffix such as `ZoneQuestGuide-main.zip`. The repository's GitHub Actions packaging workflow produces a clean artifact named **ZoneQuestGuide.zip** containing a top-level `ZoneQuestGuide/` addon folder. GitHub Releases can also receive a versioned package such as `ZoneQuestGuide-0.2.25.zip`.

## Install

1. Exit World of Warcraft.
2. Download the packaged `ZoneQuestGuide.zip` or a versioned GitHub Release ZIP.
3. Place the top-level `ZoneQuestGuide` folder into `World of Warcraft/_retail_/Interface/AddOns/`.
4. Start WoW and enable **Zone Quest Guide**.
5. Use `/zq` if the panel is hidden.

## Important limitations

WoW's live addon APIs do not reliably expose every historical unaccepted side quest. Map/quest and instance learning record evidence, not automatic proof that a quest or instance belongs exclusively to one map/timeline/difficulty. Wago counters and discovery switches are aggregated evidence and do not replace review of local/manual exports.

Supplemental `blockedBy` and `exclusiveWith` rules are curated relationships, not relationships inferred automatically from completion history. Incorrect quest IDs could hide a valid supplemental quest, so they should be added only from reliable evidence.

## In-game/test plan for v0.2.25

1. Update to v0.2.25 and `/reload`.
2. In the outdoor world, run `/zq check`. After the normal map-visit scan, confirm `discoveries` is at least `1` and does not keep increasing while moving around on the same `UiMapID`.
3. `/reload` again after generating the observation, leave the Wago App running with **Support Addon Developers** enabled, and verify Wago Analytics -> Switches eventually shows `discovery_switch_mirroring_enabled` plus a `seen_map_m<map>_<faction>` switch for the visited map.
4. Enter an instance or Warfront and run `/zq inspect` plus `/zq check`. Confirm a new instance fingerprint increases `instancevisit` and `discoveries` once.
5. For the already confirmed Alliance Heroic Stromgarde fingerprint, verify the Switches page can receive `seen_instance_m1044_i1943_d149_lfg2007_max30_grp10_scenario_alliance` after the session is saved/uploaded.
6. In a timeline zone with a reliable `zidormi` or `detected` phase, verify a `seen_phase_m...` switch is generated; verify UNKNOWN/manual phases do not create phase discovery switches.
7. Confirm taxi flights still do not create flyover `seen_map_...` switches and that no discovery-switch name contains character, realm, guild, account, chat, coordinate, instance-name, scenario-name, or group-member data.
8. Continue the Normal Battle for Stromgarde comparison and record whether it reuses map `1044`/instance `1943` with a different difficulty/LFG fingerprint or uses another map/instance context.
9. Open `/zq instanceexport` and `/zq export`; verify `ZQGINSTANCEDATA|1` remains intact after the telemetry change.
10. Continue testing the known Arathi three-state edge case where map `14` requires reliable Zidormi context to distinguish PAST from FOURTH WAR.

## Roadmap

- Use dashboard-visible discovery switches and collected instance fingerprints to identify Warfront/scenario map IDs and Normal/Heroic differences without requiring one developer character to visit every variant.
- Use collected map/quest associations to discover more Retail map aliases automatically.
- Validate remaining Zidormi/Rhonormu timeline zones in-game, especially Darkshore, Dustwallow Marsh, Vale of Eternal Blossoms, and Peak of Serenity.
- Identify the live role of alternate timeline-related map IDs such as Tirisfal `1247`, Uldum `1330`/`1571`, and Silithus `1321`/`2354`.
- Add curated `blockedBy` and `exclusiveWith` relationships as real breadcrumb and mutually exclusive quest cases are identified.
- Review Wago map/quest, visit, instance, and discovery-switch telemetry volume/cardinality before the first public Wago release.
- Automate review/import of trusted Google Form submissions.
- Expand curated phase-exclusive quest mappings and supplemental quest-chain coverage.

## Release notes

See [`CHANGELOG.md`](CHANGELOG.md).

# Zone Quest Guide

**Version:** 0.2.17  
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
- Exports anonymous learning data for community review using a WoW-safe tab-separated format.
- Provides a manual Google Form contribution path and an optional Wago Analytics bridge for stronger anonymous phase and map/quest evidence.
- Builds a clean GitHub package named **ZoneQuestGuide.zip** for development downloads and versioned release ZIPs with an internal **ZoneQuestGuide** addon folder.

## Map and quest learning

Version 0.2.14 added a separate account-wide map/quest learning store in `ZoneQuestGuideDB.mapQuestLearning`.

Whenever WoW exposes a quest through the current map, an available quest line, an NPC gossip list, a quest-detail window, quest acceptance, or quest turn-in, Zone Quest Guide can record:

- the current `UiMapID`;
- the map name returned by WoW;
- faction;
- quest ID and quest name;
- whether the quest was seen as available, offered, accepted, active, or turned in;
- supporting completion state.

This map collector does **not** require Zidormi or any known timeline. That makes it useful for discovering live Retail map aliases and replacement maps such as the new Midnight Quel'Thalas map.

Version 0.2.17 also forwards stronger map/quest observations to Wago Analytics when the player has the WagoAnalytics addon and Wago App Analytics sharing enabled. The automatic Wago map/quest path reports only **available**, **offered**, **active**, and **turned-in** evidence; accepted-only and generic seen evidence stay local because accepted quests can persist while the player moves between zones or timelines.

Map scans are skipped while the player is on a taxi flight path so transient parent/flyover maps are not learned or transmitted as quest locations merely because the flight crossed them.

Commands:

- `/zq maps` — show the current map ID/name and how many quests have been recorded for the current faction.
- `/zq mapexport` — open only the map/quest learning export.
- `/zq export` — open the normal phase-learning export followed by the map/quest learning block.

### Export format

Version 0.2.16 changes both learning exports to **tab-separated** fields:

- `ZQGPHASEDATA|2`
- `ZQGMAPQUESTDATA|2`

The earlier v1 format used the pipe character (`|`) between fields. WoW text controls also use pipe-prefixed sequences for text formatting, so combinations produced by normal field boundaries could be interpreted instead of copied literally. For example, a separator immediately before a field beginning with `n`, `t`, or `R` could damage the displayed/copied text. The v2 format keeps the same data but uses tabs between fields so quest names and headers remain intact when copied from the in-game export box.

The exports intentionally do not include character names, realm names, GUIDs, guild names, or account identifiers.

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

Zone Quest Guide treats `2537` as a reliable **PRESENT / Midnight Quel'Thalas** signal. The timeline registry treats map `95` as **PAST / Burning Crusade Quel'Thalas**.

The Thalassian Pass portal can move the player into the old Burning Crusade area without selecting Zidormi gossip, while Zidormi can also teleport the player there. For this layout, the actual map identity is therefore a stronger signal than a cached conversation state.

### Live-confirmed Blasted Lands behavior

Retail testing confirmed both **PRESENT / Iron Horde** and **PAST / Before invasion** return **UiMapID `17` / `Blasted Lands`**. Blasted Lands therefore cannot be classified from map ID alone; Zidormi or reliable phase-exclusive quest evidence is still required. Alternate Blasted Lands-related UiMapIDs remain unclassified until their live role is observed in-game.

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

Zone Quest Guide includes an optional Wago Analytics bridge. The configured project ID is `EGPeM3N1`.

When WagoAnalytics is available, Zone Quest Guide can automatically contribute two anonymous evidence streams while the player quests normally:

- **Phase evidence** — map ID, faction, reliable phase, quest ID, evidence type, and phase source for available/offered/active/turned-in observations.
- **Map/quest evidence** — map ID, faction, quest ID, and evidence type for available/offered/active/turned-in observations even when no historical phase is known.

Each unique observation is sent at most once per UI session to reduce duplicate counters. Accepted-only and generic seen observations are deliberately not sent. Taxi-flight scans are suppressed so temporary flyover maps are not treated as quest locations.

Character names, realm names, guild names, GUIDs, account identifiers, quest names, and manual phase overrides are not included in these Wago metric keys.

- `/zq wago` — show Wago bridge status and the number of phase/map-quest observations queued during the current UI session.
- `/zq telemetry` — alias for `/zq wago`.

Wago Analytics only uploads for players using the Wago App with Analytics data sharing enabled. The Wago project and Analytics dashboard exist, but no downloadable Wago release has been published yet. **GitHub remains the only listed distribution platform until a Wago release is actually available.**

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

## GitHub ZIP packages

GitHub's built-in **Code -> Download ZIP** button is a source-code archive. GitHub automatically names that archive after the repository and branch, so the `main` branch downloads as `ZoneQuestGuide-main.zip` and extracts to `ZoneQuestGuide-main`.

Version 0.2.15 added a packaging workflow so normal addon packages do not use that source-archive name:

- Every push to `main` produces a GitHub Actions artifact named **ZoneQuestGuide**, which downloads as `ZoneQuestGuide.zip` and contains the addon under a top-level `ZoneQuestGuide/` folder.
- When a GitHub Release is published, the workflow also attaches a versioned package such as `ZoneQuestGuide-0.2.17.zip`.
- The packaged addon excludes repository-only `.git`/`.github` metadata and preserves the folder name WoW expects.

The GitHub Actions packaging job has completed and the generated artifact structure has been inspected. The packaged addon still needs to be launched in World of Warcraft before the packaging path is considered fully in-game verified.

For normal installs, use the packaged artifact/release ZIP rather than GitHub's automatic branch source archive.

## Install

1. Exit World of Warcraft.
2. Download a packaged **ZoneQuestGuide.zip** or versioned GitHub Release ZIP. If using GitHub's **Code -> Download ZIP** source archive instead, rename the extracted `ZoneQuestGuide-main` folder to `ZoneQuestGuide` first.
3. Place the `ZoneQuestGuide` folder into `World of Warcraft/_retail_/Interface/AddOns/`.
4. Start WoW.
5. Enable **Zone Quest Guide** at character select.
6. Enter the world and use `/zq` if the panel is hidden.

## Important limitations

WoW's live addon APIs do not reliably expose every historical unaccepted side quest. Supplemental data still has to be reviewed and expanded over time.

Map/quest learning records what WoW exposes on the player's current map; it is evidence, not automatic proof that a quest belongs exclusively to that map or timeline.

Phase learning only records a phase association when the historical phase is known from a reliable signal. Learned observations are not automatically promoted into official quest-phase requirements.

Wago Analytics counters are aggregated evidence, not a replacement for reviewing the local/manual exports. Zone Quest Guide deliberately keeps weaker accepted/seen map observations local instead of transmitting them automatically.

## In-game/test plan for v0.2.17

1. Update to v0.2.17 with WagoAnalytics loaded and Wago App Analytics sharing enabled, then run `/zq wago` and note the initial phase/map-quest observation counts.
2. Interact with an NPC offering a quest, view a quest-detail screen, or turn in a quest while standing in a stable zone. Run `/zq wago` again and confirm the **map/quest** queued count increases.
3. Refresh the Wago Analytics development dashboard and look for `map_quest_learning_enabled`, `map_quest_evidence_total`, and `mapquest_m..._q..._...` counters corresponding to the observed map/quest IDs.
4. In a known timeline, generate available/offered/active/turned-in evidence and confirm the existing `phase_evidence_total` and `phase_m...` metrics still arrive alongside the new map/quest stream.
5. Take a taxi flight across multiple zones and confirm the local map learner does not add new flyover-map associations simply from crossing those zones; after landing, normal map learning should resume.
6. Continue the v0.2.16 export check: `/zq mapexport` and `/zq export` should preserve complete tab-separated headers and quest names.
7. Continue timeline research by comparing `/zq maps` before and after Zidormi in Arathi Highlands, Tirisfal Glades, Silithus, Darkshore, and other supported zones.

## Roadmap

- Use collected map/quest associations to discover more live Retail map aliases automatically.
- Validate remaining Zidormi/Rhonormu timeline zones in-game.
- Review Wago Analytics map/quest counters and refine telemetry volume/cardinality if needed before the first public Wago release.
- Automate review/import of trusted Google Form submissions.
- Expand curated phase-exclusive quest mappings from reviewed evidence.
- Expand supplemental quest-chain and prerequisite coverage.

## Release notes

See [`CHANGELOG.md`](CHANGELOG.md).

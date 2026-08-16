# Zone Quest Guide

**Version:** 0.2.1  
**WoW:** Retail 12.1 (`Interface: 120100`)

Zone Quest Guide is a lightweight World of Warcraft addon that shows unfinished quests for the current zone and points the player toward the next useful target.

## Current features

- Detects the current Retail WoW zone/map and refreshes automatically.
- Shows **AVAILABLE**, **TURN IN**, and **IN PROGRESS** quest states.
- Keeps normal **ZONE QUESTS** separate from repeatable **DAILY QUESTS**.
- Prioritizes normal zone quests ahead of dailies, then **AVAILABLE**, **TURN IN**, and **IN PROGRESS** within each section.
- Uses Blizzard super-tracking for accepted quests and temporary user waypoints for available quest starters.
- Replaces old available-quest waypoints when the selected quest changes.
- Adds a floating navigation HUD with a smoothly rotating drawn arrow, quest name, status, distance when available, and ETA while moving.
- Keeps the navigation target stable while a flight path briefly crosses another zone.
- Supports optional **Auto Accept** and **Auto Turn-in** quest automation.
- Supports location hints such as **UPPER LEVEL** for confusing vertical quest locations.
- Supports historical/time-phase zones controlled by NPCs such as Zidormi.
- Can redirect the navigation arrow to a timeline-switch NPC when the selected quest belongs to another historical version of the zone.

## Navigation HUD

The floating navigation HUD remains visible independently of the main quest list.

- Smoothly rotates toward the current destination.
- Shows the selected target and status.
- Shows distance in yards when WoW exposes usable world-position data.
- Shows an ETA while moving when a usable movement speed is available.
- Includes supplemental location hints when present.
- **Shift-drag** moves the HUD and saves its position.
- `/zq arrow` toggles it.
- `/zq arrow reset` restores its default position.

### Timeline-switch arrow

For phase-aware quests, Zone Quest Guide can recognize that the selected quest belongs to another historical version of the current zone. When the current phase is known and a configured switch NPC exists, the normal navigation HUD temporarily changes to:

`SWITCH TIMELINE`

and points to the timeline-switch NPC instead of an objective that is unavailable in the current phase.

Initial Blasted Lands Horde coverage includes:

- **Attack of the Iron Horde** — requires the present/Iron Horde-incursion version.
- **Under Siege** — requires the present/Iron Horde-incursion version.
- **Zidormi** near the northern Blasted Lands border is the configured phase switch target.

After the player changes to the required timeline and the guide refreshes, navigation returns to the real quest target.

## Quest sections

### ZONE QUESTS

Normal one-time zone quests stay in the main progression section and remain the first automatic navigation priority.

### DAILY QUESTS

Repeatable daily quests are shown separately below normal zone quests. Dailies can still show **AVAILABLE**, **TURN IN**, or **IN PROGRESS**.

## Historical/time phases

Some zones can exist in older and newer versions. Zone Quest Guide treats these as filters rather than showing both versions together.

When the player talks to **Zidormi**, the addon examines her gossip option as a phase clue. On the English client:

- If Zidormi offers **"Take me back to the present."**, the character is currently in the **PAST** version.
- If she offers to show the zone **before** an invasion/event or otherwise travel to the past, the character is currently in the **PRESENT** version.

Manual per-zone overrides remain available when automatic identification is not reliable:

- `/zq phase` — show the current phase mode.
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

## Install

1. Exit World of Warcraft.
2. Copy the `ZoneQuestGuide` folder into `World of Warcraft/_retail_/Interface/AddOns/`.
3. Start WoW.
4. Enable **Zone Quest Guide** at character select.
5. Enter the world and use `/zq` if the panel is hidden.

## Important limitations

WoW's live addon APIs do not reliably expose every historical unaccepted side quest. `QuestData.lua` supplements missing quest and navigation information zone-by-zone.

There is no universal API that gives every Zidormi-style zone a simple human-readable past/present identity. Zidormi gossip detection helps in supported zones, while other zones may still need supplemental phase data or a manual override.

Timeline-switch arrow guidance only activates when Zone Quest Guide knows both the active timeline and the required timeline for the selected quest. Unknown quests continue using normal WoW navigation rather than guessing.

Distance and ETA depend on map/world-position and movement information supplied by WoW, so some targets may show tracking information without a numeric distance.

## In-game test plan for v0.2.1

1. In Blasted Lands, talk to Zidormi so Zone Quest Guide can identify the current phase.
2. While in **PAST**, select **Under Siege** or **Attack of the Iron Horde**.
3. Verify the floating HUD changes to **SWITCH TIMELINE** and points toward Zidormi rather than the unavailable quest objective.
4. Verify the target text tells you to switch to **PRESENT**.
5. Use Zidormi to return to the present/Iron Horde version.
6. Verify Zone Quest Guide refreshes and the arrow returns to the actual quest target.
7. Verify normal non-phase quests continue using the standard navigation arrow.
8. Verify the flight-path target hold, distance/ETA, Auto Accept, Auto Turn-in, daily sections, and location hints continue to behave normally.

## Roadmap

- Expand phase requirements across the rest of the Blasted Lands Iron Horde quest chain.
- Add additional Zidormi zones and phase-switch NPC locations as they are encountered in-game.
- Expand supplemental quest-chain and prerequisite coverage.
- Improve multi-zone route selection.
- Add weekly/other recurring quest sections if useful.
- Add per-character/account-wide completion options.
- Add automatic GitHub release ZIP packaging.

## Release notes

See [`CHANGELOG.md`](CHANGELOG.md).

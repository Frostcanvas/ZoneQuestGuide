# Zone Quest Guide

**Version:** 0.1.9  
**WoW:** Retail 12.1 (`Interface: 120100`)

Zone Quest Guide is a lightweight World of Warcraft addon that focuses on one job: when you enter a zone, show unfinished quests the client can identify and point you toward the selected quest.

## What v0.1.9 does

- Detects the current Retail WoW zone/map.
- Lists unfinished accepted quests and available quest starters the client exposes.
- Requests Blizzard quest-line data for the current map and refreshes when quest information changes.
- Shows three clear quest states: **AVAILABLE**, **TURN IN**, and **IN PROGRESS**.
- Separates normal **ZONE QUESTS** from repeatable **DAILY QUESTS**.
- Keeps permanent zone-completion quests ahead of dailies for automatic navigation.
- Within each section, prioritizes **AVAILABLE**, then **TURN IN**, then **IN PROGRESS**.
- Refreshes the addon-owned minimap/world-map destination whenever the selected available quest changes.
- Uses Blizzard super-tracking for accepted quests and a temporary user waypoint for unaccepted quest starters.
- Supports optional **Auto Accept** and **Auto Turn-in** quest automation.
- Supports location hints for vertical or otherwise confusing quest locations.
- Adds time-phase awareness for zones that have older/newer historical versions.
- Refreshes phase-sensitive data on zone, quest, gossip, and phase-change signals.
- Supports per-zone phase overrides for supplemental quest data when automatic identification is not reliable.

## Quest sections

### ZONE QUESTS

Normal one-time zone quests stay in the main progression section. These are the quests Zone Quest Guide prioritizes when automatic navigation is enabled.

### DAILY QUESTS

Repeatable daily quests appear in their own section below the normal zone quests. A daily can still show as **AVAILABLE**, **TURN IN**, or **IN PROGRESS**, but it does not take priority over a normal zone quest.

## Quest status labels

- **AVAILABLE** — the quest has not been accepted yet and can currently be picked up.
- **TURN IN** — the quest is accepted and its objectives are complete.
- **IN PROGRESS** — the quest is accepted but still has unfinished objectives.

## Time phases / historical versions

Some WoW zones can exist in more than one historical or phased version. Zone Quest Guide treats this as a filter, not as another quest section: only quests valid for the active version of the zone should be shown.

Blizzard's live quest sources normally reflect the world phase the character is currently in. The main risk is supplemental database data, because a static quest record could otherwise point toward an NPC that only exists in a different historical version of the same zone.

Supplemental quest entries can now include a `phase` key such as:

```lua
{
    id = 12345,
    name = "Example Quest",
    x = 0.50,
    y = 0.50,
    phase = "past",
}
```

For phase-aware zones, Zone Quest Guide can use a configured detector. If the client does not expose enough information for a reliable detector, use a per-zone manual override:

- `/zq phase` — show the current phase mode.
- `/zq phase auto` — return the current zone to automatic phase handling.
- `/zq phase past` — force supplemental phase-tagged quests for the past version.
- `/zq phase present` — force supplemental phase-tagged quests for the present version.

A phase override is saved per map. Phase-tagged supplemental quests are hidden when the phase is unknown rather than risking a waypoint to an NPC in the wrong version of the zone.

## Quest automation

Quest automation is optional and defaults to OFF.

Open `/zq options` or click **Options** in the Zone Quest Guide window to configure:

- **Auto accept quests** — automatically selects and accepts available quests from an NPC.
- **Auto turn in completed quests** — automatically progresses completed quests and claims the reward when there is no meaningful reward choice.

If a quest has multiple reward choices, Zone Quest Guide leaves the reward window open for you. Hold **Shift** while interacting with an NPC to temporarily bypass both automation options.

## Location hints

WoW's world and minimap are primarily 2D. Two NPCs can look close together even when one is above or below the other. Zone Quest Guide can attach supplemental location hints such as **UPPER LEVEL**, **LOWER LEVEL**, **INSIDE CAVE**, or similar notes.

For **Horn of the Traitor**, the addon marks the quest **UPPER LEVEL** and explains that Montarr is on top of Freewind Post.

## Minimap button

- **Left-click** — show or hide Zone Quest Guide.
- **Right-click** — refresh the current zone quest list.
- **Shift-drag** — move the button around the minimap.
- `/zq minimap` — hide or show the minimap button.

## Important limitations

WoW's live addon APIs do not reliably expose every historical, unaccepted side quest in every zone. `QuestData.lua` is the supplemental database layer for quests the live API does not provide.

There is also no universal phase name that an addon can rely on for every historical-version zone, so phase-aware supplemental data may need a zone-specific detector or a manual override until that zone is fully mapped.

Quest automation depends on Blizzard's quest and gossip UI flow. Some special quests, confirmation dialogs, protected interactions, or unusual NPC behavior may still require manual input.

## Install

1. Exit World of Warcraft.
2. Copy the `ZoneQuestGuide` folder into:

   `World of Warcraft/_retail_/Interface/AddOns/`

3. Start WoW.
4. At character select, enable **Zone Quest Guide** under AddOns.
5. Enter the world and type `/zq` if the panel is hidden.

## Commands

- `/zq` — toggle the panel
- `/zq show` — show the panel
- `/zq hide` — hide the panel
- `/zq refresh` — force a current-zone refresh
- `/zq auto` — toggle automatic quest selection
- `/zq minimap` — toggle the minimap button
- `/zq options` — open quest automation options
- `/zq autoaccept` — toggle automatic quest acceptance
- `/zq autoturnin` — toggle automatic quest turn-in
- `/zq autocomplete` — alias for `/zq autoturnin`
- `/zq phase` — show current time-phase mode
- `/zq phase auto` — clear the current-zone phase override
- `/zq phase past` — force the past historical phase for supplemental data
- `/zq phase present` — force the present historical phase for supplemental data

## Test plan

1. Verify normal quests appear under **ZONE QUESTS** and dailies under **DAILY QUESTS**.
2. Verify **AVAILABLE**, **TURN IN**, and **IN PROGRESS** update correctly.
3. Verify zone quests stay ahead of dailies for automatic navigation.
4. Verify map/minimap destinations change when the selected available quest changes.
5. Verify Auto Accept and Auto Turn-in behavior, including reward-choice handling.
6. Verify location hints remain visible on known vertical quest locations.
7. In a zone with multiple historical phases, change the zone's phase and confirm Zone Quest Guide refreshes instead of keeping stale phase-sensitive data.
8. For a phase-tagged supplemental test quest, verify `/zq phase past` and `/zq phase present` only expose the matching record.
9. Verify `/zq phase auto` clears the saved override for that map.
10. Take a portal/loading screen and confirm the addon continues refreshing normally.

## Roadmap

- Add zone-specific automatic phase detectors and phase-tagged quest data as phased zones are mapped.
- Full quest-chain and prerequisite awareness.
- Expanded supplemental quest database for old side quests.
- Weekly/other recurring quest sections if needed.
- Multi-step route hints for cliffs, caves, towers, and hard-to-reach quest givers.
- Better distance/route selection.
- Per-character and account-wide completion options.
- Automatic GitHub release ZIP packaging.

## Release notes

See [`CHANGELOG.md`](CHANGELOG.md).

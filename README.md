# Zone Quest Guide

**Version:** 0.2.0  
**WoW:** Retail 12.1 (`Interface: 120100`)

Zone Quest Guide is a lightweight World of Warcraft addon that focuses on one job: when you enter a zone, show unfinished quests the client can identify and point you toward the selected quest.

## What v0.2.0 does

- Detects the current Retail WoW zone/map.
- Lists unfinished accepted quests and available quest starters the client exposes.
- Requests Blizzard quest-line data for the current map and refreshes when quest information changes.
- Shows three clear quest states: **AVAILABLE**, **TURN IN**, and **IN PROGRESS**.
- Separates normal **ZONE QUESTS** from repeatable **DAILY QUESTS**.
- Keeps permanent zone-completion quests ahead of dailies for automatic navigation.
- Within each section, prioritizes **AVAILABLE**, then **TURN IN**, then **IN PROGRESS**.
- Refreshes the addon-owned minimap/world-map destination whenever the selected available quest changes.
- Uses Blizzard super-tracking for accepted quests and a temporary user waypoint for unaccepted quest starters.
- Adds a floating, Zygor-style navigation HUD with a smoothly rotating drawn arrow, quest name, quest status, distance when WoW can convert the map position to world distance, and an ETA while moving.
- Keeps the floating navigation target and addon-owned waypoint on the last stable quest while a flight path briefly crosses another zone.
- Supports optional **Auto Accept** and **Auto Turn-in** quest automation.
- Supports location hints for vertical or otherwise confusing quest locations.
- Adds time-phase awareness for zones that have older/newer historical versions.
- Detects a zone's current **past/present** state from Zidormi's gossip option when the player talks to her.
- Supports per-zone phase overrides for supplemental quest data when automatic identification is not reliable.

## Navigation HUD

Zone Quest Guide now has a separate floating navigation display inspired by the type of arrow used by full quest-guide addons.

The navigation HUD:

- Draws its arrow from WoW line regions instead of Unicode arrow characters, avoiding missing-glyph/square boxes.
- Rotates smoothly as the player turns.
- Shows the selected quest name and current **AVAILABLE**, **TURN IN**, or **IN PROGRESS** state.
- Includes location hints such as **UPPER LEVEL** when supplemental terrain information exists.
- Shows an estimated distance in yards when WoW can translate the map coordinates into world coordinates.
- Shows an estimated travel time while the player is moving and a usable speed value is available.
- Remains visible even when the main Zone Quest Guide quest window is hidden.
- Can be moved with **Shift-drag** and remembers its position.

Commands:

- `/zq arrow` — show or hide the floating navigation HUD.
- `/zq arrow reset` — return the navigation HUD to its default position and show it.

### Flight-path target hold

WoW can report several zone changes while a taxi/flight path crosses intermediate maps. That could make the go-to marker briefly jump to a quest in a zone the player was only flying over.

While the player is on a taxi, Zone Quest Guide now keeps the floating navigation HUD and its addon-owned destination on the last stable quest when the taxi crosses into a different map. When the flight ends, the guide refreshes again for the zone where the character actually landed.

The main quest list can still refresh while flying because that behavior belongs to the older Core quest collector; v0.2.0 specifically stabilizes the navigation target and waypoint so a short flyover does not steal the destination marker.

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

### Zidormi detection

When the player talks to **Zidormi**, Zone Quest Guide reads her visible gossip options for a strong phase signal.

For example, if Zidormi offers **"Take me back to the present."**, the player must currently be in the older/past version of that zone, so Zone Quest Guide records the current session as **PAST** for that map.

If Zidormi instead offers an option to show the zone **before** an invasion/event or otherwise travel to the past, Zone Quest Guide records the current version as **PRESENT**.

When WoW reports a phase transition shortly after that Zidormi interaction, the addon treats it as confirmation that the offered switch occurred and updates the remembered phase for the session. Simply closing Zidormi's window does not flip the phase.

The phase badge can appear as:

`[PHASE: PAST (Zidormi)]`

or:

`[PHASE: PRESENT (Zidormi)]`

Supplemental quest entries can include a `phase` key such as:

```lua
{
    id = 12345,
    name = "Example Quest",
    x = 0.50,
    y = 0.50,
    phase = "past",
}
```

For phase-aware zones, Zone Quest Guide can also use a configured detector. If the client does not expose enough information for a reliable detector, use a per-zone manual override:

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

There is no universal phase name that an addon can rely on for every historical-version zone. Zidormi gossip detection helps considerably in Zidormi-controlled zones, but zones with different mechanics may still need a zone-specific detector or a manual override.

The Zidormi option text is localized by WoW. The current automatic text matching is designed around the English client and still needs broader in-game testing before it can be considered reliable across every Zidormi zone and language.

Distance and ETA in the floating navigation HUD depend on the map/world-position data and movement speed WoW exposes for the current target. Some quests may therefore show only the quest name and tracking state.

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
- `/zq arrow` — toggle the floating navigation HUD
- `/zq arrow reset` — reset the floating navigation HUD position
- `/zq options` — open quest automation options
- `/zq autoaccept` — toggle automatic quest acceptance
- `/zq autoturnin` — toggle automatic quest turn-in
- `/zq autocomplete` — alias for `/zq autoturnin`
- `/zq phase` — show current time-phase mode
- `/zq phase auto` — clear the current-zone phase override
- `/zq phase past` — force the past historical phase for supplemental data
- `/zq phase present` — force the present historical phase for supplemental data

## Test plan

1. Select or auto-select a quest and verify the floating navigation HUD appears near the top of the screen.
2. Turn the character and verify the drawn arrow rotates smoothly toward the quest destination.
3. Verify the HUD shows the quest name and correct **AVAILABLE**, **TURN IN**, or **IN PROGRESS** status.
4. For a quest with usable coordinates, verify the distance looks reasonable and an ETA appears while moving.
5. Shift-drag the navigation HUD, reload the UI, and verify the position is remembered.
6. Use `/zq arrow` to hide/show it and `/zq arrow reset` to restore its default position.
7. Take a flight path that briefly crosses another zone and verify the floating arrow/go-to destination stays on the pre-flight quest instead of jumping to a flyover-zone quest.
8. When the taxi ends, verify Zone Quest Guide refreshes for the zone where the character landed and chooses the appropriate target there.
9. Verify normal quests appear under **ZONE QUESTS** and dailies under **DAILY QUESTS**.
10. Verify **AVAILABLE**, **TURN IN**, and **IN PROGRESS** update correctly.
11. Verify zone quests stay ahead of dailies for automatic navigation.
12. Verify Auto Accept and Auto Turn-in behavior, including reward-choice handling.
13. Verify location hints remain visible on known vertical quest locations.
14. In a Zidormi-controlled phased zone, talk to Zidormi while she offers **"Take me back to the present."** and verify Zone Quest Guide shows **PAST (Zidormi)**.
15. In the present version of that zone, talk to Zidormi while she offers the older/before version and verify Zone Quest Guide shows **PRESENT (Zidormi)**.
16. Select Zidormi's phase-switch option and verify the guide refreshes to the opposite phase after WoW reports the phase transition.
17. Verify `/zq phase auto`, `/zq phase past`, and `/zq phase present` continue to work.

## Roadmap

- Add phase-tagged quest data for Blasted Lands and other Zidormi zones as they are mapped in-game.
- Add zone-specific automatic phase detectors where Zidormi gossip is not available.
- Full quest-chain and prerequisite awareness.
- Expanded supplemental quest database for old side quests.
- Weekly/other recurring quest sections if needed.
- Multi-step route hints for cliffs, caves, towers, and hard-to-reach quest givers.
- Better route selection across multi-zone travel.
- Per-character and account-wide completion options.
- Automatic GitHub release ZIP packaging.

## Release notes

See [`CHANGELOG.md`](CHANGELOG.md).

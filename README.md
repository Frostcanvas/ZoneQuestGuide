# Zone Quest Guide

**Version:** 0.1.7  
**WoW:** Retail 12.1 (`Interface: 120100`)

Zone Quest Guide is a lightweight World of Warcraft addon that focuses on one job: when you enter a zone, show unfinished quests the client can identify and point you toward the selected quest.

## What v0.1.7 does

- Detects the current Retail WoW zone/map.
- Lists unfinished accepted quests that WoW reports on that map.
- Requests Blizzard quest-line data for the current map before reading available quest lines.
- Refreshes when Blizzard reports updated quest-line information.
- Detects available quests shown by an NPC while the gossip or quest-detail window is open and remembers them for the current session.
- Filters completed/turned-in quests.
- Shows three clear quest states: **AVAILABLE**, **TURN IN**, and **IN PROGRESS**.
- Prioritizes **AVAILABLE** quests first, then completed **TURN IN** quests, then **IN PROGRESS** quests.
- Auto-points to the nearest available quest first; if none are available, it falls back to a quest ready to turn in and then an in-progress quest.
- Refreshes the addon-owned minimap/world-map destination whenever the selected available quest changes, so an old quest-giver marker is not left behind.
- Lets you click a quest row to change the target.
- Uses Blizzard super-tracking for accepted quests.
- Uses a Blizzard user waypoint for unaccepted quest starters with coordinates.
- Removes the matching temporary quest-starter waypoint after that quest is accepted so Blizzard quest tracking can take over.
- Displays a textured directional indicator instead of relying on Unicode arrow glyphs.
- Adds a minimap button for fast access to Zone Quest Guide.
- Remembers the minimap button position between sessions.
- Adds a normal addon-list icon instead of the red question-mark placeholder.
- Supports optional **Auto Accept** and **Auto Turn-in** quest automation. Both settings are OFF by default.
- Leaves quests with multiple reward choices open so the player can select the reward manually.
- Allows holding **Shift** while interacting with an NPC to temporarily bypass quest automation.
- Supports location hints for quests where a flat 2D map can be misleading because the quest is on another vertical level, inside a cave, on an upper floor, or otherwise requires a terrain note.
- Includes an **UPPER LEVEL** warning for both Horde and Alliance versions of **Horn of the Traitor** at Freewind Post.
- Includes initial Horde and Alliance quest-chain coverage for the Splithoof Heights/Speedbarge/Freewind Post section of Thousand Needles.

## Quest status labels

Zone Quest Guide uses three player-facing quest states:

- **AVAILABLE** — the quest has not been accepted yet and can currently be picked up.
- **TURN IN** — the quest is accepted and its objectives are complete, so it is ready to be handed in.
- **IN PROGRESS** — the quest is accepted but still has unfinished objectives.

Available quests remain the first priority because Zone Quest Guide is intended to help you pick up missing quests as you move through a zone. If no available quest is shown, a completed **TURN IN** quest is preferred before a normal **IN PROGRESS** quest.

## Quest automation

Quest automation is optional and defaults to OFF.

Open `/zq options` or click **Options** in the Zone Quest Guide window to configure:

- **Auto accept quests** — automatically selects available quests from an NPC and accepts the quest when its quest-detail page opens.
- **Auto turn in completed quests** — automatically selects completed quests from an NPC, advances the completion page, and claims the reward when there is no meaningful reward choice.

If a quest has multiple reward choices, Zone Quest Guide stops and leaves the reward window open for you.

Hold **Shift** while interacting with an NPC to temporarily bypass both automation options without changing the saved settings.

`Auto turn in` means turning in a quest whose objectives are already complete. Zone Quest Guide does not automatically perform quest objectives for you.

## Location hints

WoW's world and minimap are primarily 2D. Two NPCs can look close together on the map even when one is far above or below the other.

Zone Quest Guide can attach a supplemental location hint to quests where terrain matters. The hint appears beside the quest in the list and on the current target. Hovering the quest row shows a longer explanation.

For **Horn of the Traitor**, the addon marks the quest **UPPER LEVEL** and explains that Montarr is on top of Freewind Post and that the player should follow the path uphill.

## Minimap button

- **Left-click** — show or hide Zone Quest Guide.
- **Right-click** — refresh the current zone quest list.
- **Shift-drag** — move the button around the minimap.
- `/zq minimap` — hide or show the minimap button.

## Important limitation

WoW's live addon APIs do not reliably expose every historical, unaccepted side quest in every zone. `QuestData.lua` is the supplemental database layer for quests the live API does not provide. We will continue expanding that database zone-by-zone while adding prerequisite, route, and quest-chain logic.

Opening an NPC's gossip or quest-detail window can expose additional available quests to the addon for the current session, but Zone Quest Guide still cannot automatically discover every unseen old quest from the live API alone.

The normal map pin does not contain reliable height/elevation information. Location hints are therefore supplemental data that we can add for known cliffs, caves, towers, upper floors, and similar cases.

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
- `/zq refresh` — force a current-zone refresh and re-request quest-line data
- `/zq auto` — toggle automatic quest selection
- `/zq minimap` — toggle the minimap button
- `/zq options` — open quest automation options
- `/zq autoaccept` — toggle automatic quest acceptance
- `/zq autoturnin` — toggle automatic quest turn-in
- `/zq autocomplete` — alias for `/zq autoturnin`

## Test plan

1. Enter a zone where you have unfinished quests.
2. Verify unaccepted quests show as **AVAILABLE**.
3. Verify accepted quests with unfinished objectives show as **IN PROGRESS**.
4. Finish all objectives for an accepted quest and verify its status changes to **TURN IN** before you hand it in.
5. When all three statuses are present, verify they are ordered **AVAILABLE**, **TURN IN**, then **IN PROGRESS**.
6. With auto-point enabled, verify the addon targets the nearest **AVAILABLE** quest first; if none are available, verify it can fall back to a **TURN IN** quest.
7. Move between two available quest targets and verify the minimap/world-map destination moves to the newly selected quest instead of remaining on the old quest giver.
8. Accept the selected available quest and verify it changes to **IN PROGRESS**, its temporary starter waypoint disappears, and the next available quest becomes the automatic target if one exists.
9. Open `/zq options`, enable **Auto accept quests**, talk to an NPC with an available quest, and verify the quest is selected and accepted automatically.
10. Enable **Auto turn in completed quests**, talk to an NPC with a completed quest that has no reward choice, and verify the quest turns in automatically.
11. Test a completed quest with multiple reward choices and verify the addon leaves the reward window open for manual selection.
12. Hold Shift while interacting with an NPC and verify the enabled automation is temporarily bypassed.
13. At Freewind Post, verify **Horn of the Traitor** shows **[UPPER LEVEL]** in the list and on the current target.
14. Hover **Horn of the Traitor** and verify the tooltip explains that Montarr is on top of Freewind Post and the path goes uphill.
15. Verify the navigation indicator renders as an arrow graphic instead of a square/missing-glyph box.
16. Verify the minimap button appears and left-clicking it shows/hides the addon.
17. Right-click the minimap button and verify the quest list refreshes.
18. Shift-drag the minimap button, reload the UI, and verify its position is remembered.
19. Cross into another zone and confirm the list updates.
20. Take a portal/loading screen and confirm the addon continues refreshing normally.

## Roadmap

- Full quest-chain and prerequisite awareness.
- Expanded supplemental quest database for old side quests.
- Multi-step route hints for cliffs, caves, towers, and hard-to-reach quest givers.
- Better distance/route selection.
- Further navigation-arrow polish after in-game testing.
- Per-character and account-wide completion options.
- Automatic GitHub release ZIP packaging.

## Release notes

See [`CHANGELOG.md`](CHANGELOG.md).

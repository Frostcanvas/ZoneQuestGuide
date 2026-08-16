# Zone Quest Guide

**Version:** 0.1.5  
**WoW:** Retail 12.1 (`Interface: 120100`)

Zone Quest Guide is a lightweight World of Warcraft addon that focuses on one job: when you enter a zone, show unfinished quests the client can identify and point you toward the selected quest.

## What v0.1.5 does

- Detects the current Retail WoW zone/map.
- Lists unfinished accepted quests that WoW reports on that map.
- Requests Blizzard quest-line data for the current map before reading available quest lines.
- Refreshes when Blizzard reports updated quest-line information.
- Detects available quests shown by an NPC while the gossip or quest-detail window is open and remembers them for the current session.
- Filters completed quests.
- Prioritizes **AVAILABLE** quests above **IN PROGRESS** quests in the Zone Quest Guide list.
- Auto-points to the nearest available quest first; if none are available, it falls back to an in-progress quest.
- Lets you click a quest row to change the target.
- Uses Blizzard super-tracking for accepted quests.
- Uses a Blizzard user waypoint for unaccepted quest starters with coordinates.
- Removes the matching temporary quest-starter waypoint after that quest is accepted so Blizzard quest tracking can take over.
- Displays a textured directional indicator instead of relying on Unicode arrow glyphs.
- Adds a minimap button for fast access to Zone Quest Guide.
- Remembers the minimap button position between sessions.
- Adds a normal addon-list icon instead of the red question-mark placeholder.
- Supports location hints for quests where a flat 2D map can be misleading because the quest is on another vertical level, inside a cave, on an upper floor, or otherwise requires a terrain note.
- Includes an **UPPER LEVEL** warning for both Horde and Alliance versions of **Horn of the Traitor** at Freewind Post.
- Includes initial Horde and Alliance quest-chain coverage for the Splithoof Heights/Speedbarge/Freewind Post section of Thousand Needles.

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

## Test plan

1. Enter a zone where you have unfinished quests.
2. Verify accepted quests show as **IN PROGRESS**.
3. Verify available quest-line starters show as **AVAILABLE**.
4. When both statuses are present, verify **AVAILABLE** quests are listed above **IN PROGRESS** quests.
5. With auto-point enabled, verify the addon targets the nearest **AVAILABLE** quest before any accepted quest.
6. Accept the selected available quest and verify it changes to **IN PROGRESS** and the next available quest becomes the automatic target if one exists.
7. At Freewind Post, verify **Horn of the Traitor** shows **[UPPER LEVEL]** in the list and on the current target.
8. Hover **Horn of the Traitor** and verify the tooltip explains that Montarr is on top of Freewind Post and the path goes uphill.
9. Verify the navigation indicator renders as an arrow graphic instead of a square/missing-glyph box.
10. Verify the minimap button appears and left-clicking it shows/hides the addon.
11. Right-click the minimap button and verify the quest list refreshes.
12. Shift-drag the minimap button, reload the UI, and verify its position is remembered.
13. Open an NPC with an available quest and verify the quest appears immediately in Zone Quest Guide.
14. Accept an available quest and verify the temporary quest-starter map waypoint disappears while the quest becomes **IN PROGRESS**.
15. Turn in a quest and confirm it disappears.
16. Cross into another zone and confirm the list updates.
17. Take a portal/loading screen and confirm the addon continues refreshing normally.

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

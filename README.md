# Zone Quest Guide

**Version:** 0.1.8  
**WoW:** Retail 12.1 (`Interface: 120100`)

Zone Quest Guide is a lightweight World of Warcraft addon that focuses on one job: when you enter a zone, show unfinished quests the client can identify and point you toward the selected quest.

## What v0.1.8 does

- Detects the current Retail WoW zone/map.
- Lists unfinished accepted quests that WoW reports on that map.
- Requests Blizzard quest-line data for the current map before reading available quest lines.
- Refreshes when Blizzard reports updated quest-line information.
- Detects available quests shown by an NPC while the gossip or quest-detail window is open and remembers them for the current session.
- Filters completed/turned-in quests.
- Shows three clear quest states: **AVAILABLE**, **TURN IN**, and **IN PROGRESS**.
- Separates normal **ZONE QUESTS** from repeatable **DAILY QUESTS** in the main window.
- Keeps permanent zone-completion quests ahead of dailies for automatic navigation.
- Within each section, prioritizes **AVAILABLE**, then **TURN IN**, then **IN PROGRESS**.
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

## Quest sections

Zone Quest Guide separates quests into two sections:

### ZONE QUESTS

Normal one-time zone quests stay in the main progression section. These are the quests Zone Quest Guide prioritizes when automatic navigation is enabled because completing them permanently advances zone completion and quest chains.

### DAILY QUESTS

Repeatable daily quests appear in their own section below the normal zone quests. A daily can still show as **AVAILABLE**, **TURN IN**, or **IN PROGRESS**, but it does not take priority over a normal zone quest.

Daily completion is treated as a daily-reset state rather than permanent zone completion, so a daily that has been completed for the current reset can disappear and become eligible to appear again after a later daily reset when WoW reports it as available again.

## Quest status labels

Zone Quest Guide uses three player-facing quest states:

- **AVAILABLE** — the quest has not been accepted yet and can currently be picked up.
- **TURN IN** — the quest is accepted and its objectives are complete, so it is ready to be handed in.
- **IN PROGRESS** — the quest is accepted but still has unfinished objectives.

Within each quest section, available quests remain the first priority. If no available quest is shown in that section, a completed **TURN IN** quest is preferred before a normal **IN PROGRESS** quest.

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

Daily detection depends on the daily/frequency information WoW exposes for map quests, quest-line starters, the quest log, and gossip quests. If Blizzard does not identify a particular repeatable quest as daily through those sources, it may temporarily appear with normal zone quests until we add supplemental data for it.

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

1. Enter a zone where you have unfinished normal quests and at least one daily quest.
2. Verify normal quests appear under **ZONE QUESTS**.
3. Verify daily quests appear under **DAILY QUESTS** instead of being mixed with normal zone progression.
4. Verify unaccepted quests show as **AVAILABLE**.
5. Verify accepted quests with unfinished objectives show as **IN PROGRESS**.
6. Finish all objectives for an accepted quest and verify its status changes to **TURN IN** before you hand it in.
7. Within each section, verify the ordering is **AVAILABLE**, **TURN IN**, then **IN PROGRESS**.
8. With auto-point enabled, verify a normal zone quest is preferred over a daily quest while normal zone quests remain.
9. After normal zone quests are exhausted, verify a daily quest can still be selected and navigated to.
10. Complete and turn in a daily and verify it disappears for the current reset when WoW reports it completed.
11. Move between two available quest targets and verify the minimap/world-map destination moves to the newly selected quest instead of remaining on the old quest giver.
12. Accept the selected available quest and verify it changes to **IN PROGRESS**, its temporary starter waypoint disappears, and the next appropriate quest becomes the automatic target.
13. Open `/zq options`, enable **Auto accept quests**, talk to an NPC with an available quest, and verify the quest is selected and accepted automatically.
14. Enable **Auto turn in completed quests**, talk to an NPC with a completed quest that has no reward choice, and verify the quest turns in automatically.
15. Test a completed quest with multiple reward choices and verify the addon leaves the reward window open for manual selection.
16. Hold Shift while interacting with an NPC and verify the enabled automation is temporarily bypassed.
17. At Freewind Post, verify **Horn of the Traitor** shows **[UPPER LEVEL]** in the list and on the current target.
18. Hover **Horn of the Traitor** and verify the tooltip explains that Montarr is on top of Freewind Post and the path goes uphill.
19. Verify the navigation indicator renders as an arrow graphic instead of a square/missing-glyph box.
20. Verify the minimap button appears and left-clicking it shows/hides the addon.
21. Right-click the minimap button and verify the quest list refreshes.
22. Shift-drag the minimap button, reload the UI, and verify its position is remembered.
23. Cross into another zone and confirm the list updates.
24. Take a portal/loading screen and confirm the addon continues refreshing normally.

## Roadmap

- Full quest-chain and prerequisite awareness.
- Expanded supplemental quest database for old side quests.
- Weekly/other recurring quest sections if needed.
- Multi-step route hints for cliffs, caves, towers, and hard-to-reach quest givers.
- Better distance/route selection.
- Further navigation-arrow polish after in-game testing.
- Per-character and account-wide completion options.
- Automatic GitHub release ZIP packaging.

## Release notes

See [`CHANGELOG.md`](CHANGELOG.md).

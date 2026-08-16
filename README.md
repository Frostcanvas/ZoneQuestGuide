# Zone Quest Guide

**Version:** 0.1.1  
**WoW:** Retail 12.1 (`Interface: 120100`)

Zone Quest Guide is a lightweight World of Warcraft addon that focuses on one job: when you enter a zone, show unfinished quests the client can identify and point you toward the selected quest.

## What v0.1.1 does

- Detects the current Retail WoW zone/map.
- Lists unfinished accepted quests that WoW reports on that map.
- Requests Blizzard quest-line data for the current map before reading available quest lines.
- Refreshes when Blizzard reports updated quest-line information.
- Detects available quests shown by an NPC while the gossip or quest-detail window is open and remembers them for the current session.
- Filters completed quests.
- Sorts accepted quests first, then nearby quest starters.
- Auto-points toward the first unfinished quest.
- Lets you click a quest row to change the target.
- Uses Blizzard super-tracking for accepted quests.
- Uses a Blizzard user waypoint for unaccepted quest starters with coordinates.
- Displays a lightweight 8-direction arrow for quest-starter coordinates.
- Includes initial Horde and Alliance quest-chain coverage for the Splithoof Heights/Speedbarge section of Thousand Needles.

## Important limitation

WoW's live addon APIs do not reliably expose every historical, unaccepted side quest in every zone. `QuestData.lua` is the supplemental database layer for quests the live API does not provide. We will continue expanding that database zone-by-zone while adding prerequisite and quest-chain logic.

Opening an NPC's gossip or quest-detail window can expose additional available quests to the addon for the current session, but Zone Quest Guide still cannot automatically discover every unseen old quest from the live API alone.

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

## Test plan

1. Enter a zone where you have unfinished quests.
2. Verify accepted quests show as **IN PROGRESS**.
3. Verify available quest-line starters show as **AVAILABLE**.
4. In Thousand Needles on Horde, verify **Go Blow that Horn** appears after completing **Eminent Domain** and **Defend the Drill**.
5. Open an NPC with an available quest and verify the quest appears immediately in Zone Quest Guide.
6. Click a row and confirm WoW creates or super-tracks a waypoint.
7. Turn in a quest and confirm it disappears.
8. Cross into another zone and confirm the list updates.
9. Take a portal/loading screen and confirm the addon continues refreshing normally.

## Roadmap

- Full quest-chain and prerequisite awareness.
- Expanded supplemental quest database for old side quests.
- Better distance/route selection.
- Improved center-screen navigation arrow.
- Per-character and account-wide completion options.
- Automatic GitHub release ZIP packaging.

## Release notes

See [`CHANGELOG.md`](CHANGELOG.md).

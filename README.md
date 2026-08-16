# Zone Quest Guide

**Version:** 0.1.0  
**WoW:** Retail 12.1 (`Interface: 120100`)

Zone Quest Guide is a lightweight World of Warcraft addon that focuses on one job: when you enter a zone, show unfinished quests the client can identify and point you toward the selected quest.

## What v0.1.0 does

- Detects the current Retail WoW zone/map.
- Lists unfinished accepted quests that WoW reports on that map.
- Lists many available quest-line starters exposed by the in-game quest-line API.
- Filters completed quests.
- Sorts accepted quests first, then nearby quest starters.
- Auto-points toward the first unfinished quest.
- Lets you click a quest row to change the target.
- Uses Blizzard super-tracking for accepted quests.
- Uses a Blizzard user waypoint for unaccepted quest starters with coordinates.
- Displays a lightweight 8-direction arrow for quest-starter coordinates.

## Important limitation

WoW's live addon APIs do not reliably expose every historical, unaccepted side quest in every zone. `QuestData.lua` is the supplemental database layer for quests the live API does not provide. We can populate that database zone-by-zone and add prerequisite/quest-chain logic as the addon grows.

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
- `/zq refresh` — refresh the current zone
- `/zq auto` — toggle automatic quest selection

## Test plan

1. Enter a zone where you have unfinished quests.
2. Verify accepted quests show as **IN PROGRESS**.
3. Verify available quest-line starters show as **AVAILABLE**.
4. Click a row and confirm WoW creates or super-tracks a waypoint.
5. Turn in a quest and confirm it disappears.
6. Cross into another zone and confirm the list updates.

## Roadmap

- Full quest-chain and prerequisite awareness.
- Expanded supplemental quest database for old side quests.
- Better distance/route selection.
- Improved center-screen navigation arrow.
- Per-character and account-wide completion options.
- Optional integration with the broader Azeroth Companion quest-zone tracker.

# ZoneQuestGuide Changelog

**VERSION 0.1.1 - August 16, 2026 - Available on GitHub**

* **Fixed** an issue where available quests could be missing from the Zone Quest Guide window even though the character could accept them from an NPC.

  Zone Quest Guide was reading `C_QuestLine.GetAvailableQuestLines()` immediately, but it was not first asking WoW to download the current map's quest-line information. Blizzard provides `C_QuestLine.RequestQuestLinesForMap()` for that purpose and reports updated information through `QUESTLINE_UPDATE`. The addon now requests the current zone's quest-line data and refreshes when WoW reports that updated information is available. Players should see more available quest starters without having to manually refresh the addon.

* **Added** live quest-offer detection. When you open an NPC's gossip window or quest-detail page, Zone Quest Guide now records quests WoW says are currently available and adds them to the current session's zone list. This helps with older quests that Blizzard does not expose through the normal map quest-line API.

* **Added** initial supplemental quest-chain coverage for both Horde and Alliance in Thousand Needles, including **Go Blow that Horn**, **Deliver the Goods**, and **Free Freewind Post**, with faction and prerequisite checks so the addon does not point the wrong faction toward those quests or show later quests before their prerequisites are complete.

* **Improved** `/zq refresh` so it also forces a new quest-line data request for the current map.

*In-game testing is still required for this release.*

---

**VERSION 0.1.0 - August 16, 2026 - Available on GitHub**

* **Added** the first public version of Zone Quest Guide with automatic zone detection, unfinished accepted-quest tracking, available quest-line discovery, Blizzard super-tracking, user waypoints, a lightweight directional arrow, and a supplemental quest database framework.

*In-game testing was required for this release.*

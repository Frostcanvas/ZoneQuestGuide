# ZoneQuestGuide Changelog

**VERSION 0.1.5 - August 16, 2026 - Available on GitHub**

* **Added** location and elevation hints for quests where WoW's flat map can make an NPC look like it is on the same level as nearby quests even when it is actually above, below, inside a cave, or on another floor.

* **Improved** **Horn of the Traitor** navigation at Freewind Post. The quest is now marked **[UPPER LEVEL]** in the Zone Quest Guide list and on the current target, and hovering the quest explains that Montarr is on top of Freewind Post and that the player should follow the path uphill.

  The normal WoW map waypoint only gives Zone Quest Guide a 2D map position, so it cannot reliably communicate terrain height by itself. This could make the Horn of the Traitor marker look like it belonged with the quest givers on the lower level even though Montarr is farther up the mountain. The new location-hint framework lets the addon add player-facing terrain guidance for known vertical or otherwise confusing locations without changing Blizzard's waypoint behavior.

* **Added** supplemental Horde and Alliance data for **Horn of the Traitor** at Freewind Post, including the quest-giver coordinates and prerequisite from the preceding Free Freewind Post quest.

*In-game testing is still required to confirm the new location badge and tooltip remain visible correctly while quest priority and auto-pointing refresh the list.*

---

**VERSION 0.1.4 - August 16, 2026 - Available on GitHub**

* **Changed** quest priority so **AVAILABLE** quests are shown before **IN PROGRESS** quests in the Zone Quest Guide window.

* **Improved** automatic navigation. Previously, accepted quests were sorted first, so the addon could keep pointing at an in-progress quest even when there was another quest nearby that the player had not picked up yet. Zone Quest Guide now prefers the nearest **AVAILABLE** quest and only falls back to an **IN PROGRESS** quest when there are no available quests in the displayed list.

* **Improved** the auto-track label to better describe the new behavior: the addon now focuses on the next available quest rather than simply the nearest unfinished quest.

*In-game testing is still required to confirm available-quest priority behaves correctly when several available and in-progress quests are present at the same time.*

---

**VERSION 0.1.3 - August 16, 2026 - Available on GitHub**

* **Fixed** the temporary quest-starter map waypoint remaining on the world map after the player accepts that quest.

  Zone Quest Guide uses a normal Blizzard user waypoint to mark the NPC for an available, unaccepted quest. Once that quest is accepted, Blizzard's normal quest tracking becomes the better source for objectives, but the old starter waypoint could remain behind and make the map look like the player still needed to return to the quest giver. Zone Quest Guide now listens for the quest acceptance event and removes the matching temporary waypoint when the accepted quest is the one the addon had pointed to. When the client exposes the waypoint coordinates, the addon also compares them before clearing so it is less likely to remove an unrelated waypoint the player placed manually.

* **Improved** the transition from **AVAILABLE** to **IN PROGRESS**. After accepting a quest, the quest-starter marker should disappear while the quest remains available to Blizzard's normal quest super-tracking.

*In-game testing is still required to confirm the temporary waypoint is removed immediately after quest acceptance without affecting unrelated player waypoints.*

---

**VERSION 0.1.2 - August 16, 2026 - Available on GitHub**

* **Fixed** the navigation arrow rendering as a small square or missing-glyph box on some WoW clients. The first version used Unicode arrow characters, but the game font being used by the addon does not reliably contain those glyphs. Zone Quest Guide now keeps the directional calculation but draws the result with a normal WoW texture instead, so the navigation indicator should display consistently.

* **Added** a minimap button for faster access to Zone Quest Guide. Left-clicking the button shows or hides the main window, right-clicking refreshes the current zone's quest list, and Shift-dragging moves the button around the minimap. Its position is saved between sessions.

* **Added** `/zq minimap` to hide or show the minimap button.

* **Added** an addon-list icon so Zone Quest Guide uses a normal map icon instead of WoW's red question-mark placeholder in the AddOn List.

*In-game testing is still required for the new arrow texture, minimap positioning, and minimap controls in this release.*

---

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

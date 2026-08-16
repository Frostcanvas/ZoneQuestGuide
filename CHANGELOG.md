# ZoneQuestGuide Changelog

**VERSION 0.1.9 - August 16, 2026 - Available on GitHub**

* **Added** time-phase awareness for zones that can exist in more than one historical version.

  Zone Quest Guide now treats historical phases as a quest filter rather than another quest category. Live quests supplied by WoW continue to come from the character's active world state, while supplemental database records can be tagged with a phase such as `past` or `present`. Phase-tagged supplemental quests that do not match the selected phase are excluded so the addon does not direct the player toward an NPC that only exists in another version of the zone.

* **Added** per-zone phase overrides with `/zq phase`, `/zq phase auto`, `/zq phase past`, and `/zq phase present`. These overrides are intended as a fallback for phased zones where the client does not expose enough information for Zone Quest Guide to identify the historical version reliably on its own.

* **Improved** phase-sensitive refreshing. Zone Quest Guide now treats zone changes, quest-log changes, gossip closing, and WoW phase-change events as signals to rebuild phase-sensitive supplemental quest data and refresh the guide.

* **Changed** unknown phase handling to be conservative. If a supplemental quest is explicitly tagged for a historical phase and Zone Quest Guide cannot determine which phase is active, that static quest is hidden instead of risking a waypoint into the wrong version of the zone.

*In-game testing is still required in zones with historical/time phases. Zone-specific automatic phase detectors and phase-tagged quest data still need to be added as those zones are mapped.*

---

**VERSION 0.1.8 - August 16, 2026 - Available on GitHub**

* **Added** a separate **DAILY QUESTS** section so repeatable daily quests no longer appear mixed together with normal one-time zone progression quests.

  WoW exposes daily information through several quest sources, including current-map quest data, available quest-line information, the quest log, and NPC gossip quest data. Zone Quest Guide now combines those signals to identify daily quests and place them in their own section. This should make it much clearer which quests advance permanent zone completion and which quests are repeatable daily content.

* **Changed** automatic quest priority so normal **ZONE QUESTS** remain ahead of **DAILY QUESTS**. Within each section, the existing order is preserved: **AVAILABLE** first, then **TURN IN**, then **IN PROGRESS**. This prevents a nearby repeatable daily from pulling the navigation target away from unfinished one-time zone quests.

* **Improved** the main Zone Quest Guide window with visible **ZONE QUESTS** and **DAILY QUESTS** section headings and additional vertical space for the separated layout.

* **Improved** daily completion handling by relying on WoW's reset-aware completion state. A daily completed during the current reset can disappear from the unfinished list and become eligible to appear again after a later daily reset when WoW reports it as available again.

*In-game testing is still required to confirm daily quests are classified into the correct section across accepted, available, completed, and NPC-gossip states, and that normal zone quests remain the preferred automatic navigation target.*

---

**VERSION 0.1.7 - August 16, 2026 - Available on GitHub**

* **Added** a new **TURN IN** quest status. Accepted quests whose objectives are complete now change from **IN PROGRESS** to **TURN IN**, making it much easier to see which quests are ready to hand back to an NPC.

* **Improved** quest-status priority. **AVAILABLE** quests remain first as requested, completed **TURN IN** quests are shown next, and normal **IN PROGRESS** quests follow after them. If there are no available quests, automatic quest selection can therefore fall back to a completed quest before choosing one that still has unfinished objectives.

* **Improved** status consistency across the quest-priority and location-hint systems so a completed quest does not get changed back to **IN PROGRESS** when another part of the Zone Quest Guide window refreshes.

*In-game testing is still required to confirm quests switch to **TURN IN** immediately when their objectives become complete and return to the normal list flow after being handed in.*

---

**VERSION 0.1.6 - August 16, 2026 - Available on GitHub**

* **Fixed** the minimap/world-map destination not always changing cleanly when Zone Quest Guide switched from one available quest to another.

  Zone Quest Guide uses Blizzard user waypoints for quests that have not been accepted yet. The addon could select a new quest internally while the previous user waypoint was still the active destination, which made the minimap appear to keep pointing at the old quest giver. Zone Quest Guide now tracks the waypoint it created, removes that old destination when the selected available quest changes, and creates a fresh waypoint for the new target. If the next target does not have usable coordinates, the old marker is removed instead of being left behind and pointing to the wrong place.

* **Added** optional **Auto Accept** quest handling. When enabled, Zone Quest Guide can select available quests from an NPC and accept them automatically when the quest-detail page opens.

* **Added** optional **Auto Turn-in** handling for completed quests. When enabled, Zone Quest Guide can select completed quests from an NPC, advance the completion screen, and claim the reward automatically when there is no meaningful reward choice.

* **Added** a Zone Quest Guide options window with separate checkboxes for **Auto accept quests** and **Auto turn in completed quests**. Both options are disabled by default.

* **Added** `/zq options`, `/zq autoaccept`, and `/zq autoturnin`. `/zq autocomplete` is also accepted as an alias for auto turn-in.

* **Improved** quest automation safety. Holding **Shift** while interacting with an NPC temporarily bypasses automatic acceptance and turn-in without changing the saved settings. Quests with multiple reward choices are left open so the player can choose the reward manually.

*In-game testing is still required for waypoint switching, automatic quest acceptance, automatic turn-in, reward-choice handling, and special quest interactions in this release.*

---

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

# ZoneQuestGuide Changelog

**VERSION 0.2.8 - August 16, 2026 - Available on GitHub**

* **Changed** the phase-data contribution destination from the temporary GitHub issue page to the dedicated ZoneQuestGuide Google Form supplied for community submissions.

* **Improved** the contribution popup wording so players are told to open the Google Form, paste the anonymous `/zq export` report, and submit it. The URL field is now labeled **Google Form URL** while keeping the existing **Open Export**, **Select URL**, and **Later** controls.

* **Changed** `/zq contribute` and automatic contribution reminders to show `https://forms.gle/Gnqf8kN44kDZxMs86` as the current manual submission destination.

*The Google Form link has been wired into the addon but the full in-game contribution flow has not yet been tested. Verify `/zq contribute` shows the correct form URL, **Select URL** highlights it for copying, **Open Export** still opens the phase report, and a test submission can be pasted into the form successfully. The Wago telemetry bridge from v0.2.7 is still awaiting a Wago project ID and in-game testing; Wago is not yet listed as an available distribution platform.*

---

**VERSION 0.2.7 - August 16, 2026 - Available on GitHub**

* **Added** a Wago Analytics telemetry bridge for anonymous community phase evidence. When Zone Quest Guide is later assigned a Wago project ID and the player's Wago App has Analytics data sharing enabled, the addon can report phase-aware quest observations through the optional WagoAnalytics addon.

* **Added** `/zq wago` (also `/zq telemetry`) to show whether the Wago project ID is configured and whether the WagoAnalytics bridge is active on the current client.

* **Changed** automatic Wago reporting to use only stronger timeline evidence: quests WoW reports as available in the current phase, quests actually offered by an NPC, active quests shown by an NPC, and quests turned in in that phase. Accepted-quest map scans are deliberately excluded because an accepted quest can remain in the quest log after the player changes timelines and therefore is not reliable proof that the quest exists in both versions.

* **Improved** community-data privacy by limiting Wago metric keys to map ID, faction, phase, quest ID, evidence type, and whether the phase came from Zidormi or curated automatic detection. Character names, realm names, guild names, GUIDs, and manual phase overrides are not sent by this bridge.

* **Changed** the addon metadata to treat WagoAnalytics as an optional dependency. Zone Quest Guide continues to work normally without the Wago App or WagoAnalytics installed.

*The Wago telemetry bridge is prepared but is not active yet because Zone Quest Guide has not been published on Wago and therefore does not yet have an `X-Wago-ID`. In-game testing is still required after a Wago project is created, Analytics is enabled for that project, the project ID is added to the TOC, and the Wago App is configured for Analytics data sharing. Wago is not yet listed as an available distribution platform.*

---

**VERSION 0.2.6 - August 16, 2026 - Available on GitHub**

* **Added** a contribution reminder for phase-learning data. After Zone Quest Guide has collected useful quest observations in a known historical timeline, it can now show a small **Help improve Zone Quest Guide** window reminding the player to run `/zq export`, copy the anonymous phase report, and submit it through the listed contribution page.

* **Added** `/zq contribute` so the contribution instructions can be reopened at any time without waiting for the automatic reminder.

* **Added** a copyable contribution URL field and **Open Export** button. The initial contribution page points to the ZoneQuestGuide GitHub issue form/page, and the URL is kept in one configurable addon value so it can be changed later to a Google Form/Drive-backed submission page or another community endpoint.

* **Improved** reminder behavior so it does not pop up after every quest. The reminder is limited to once per zone/faction/timeline during a login session, appears after a turn-in once useful phase data exists, and can also appear after several quest pickups have already built a useful observation set.

* **Changed** community contribution prompting to remain manual and privacy-conscious. The addon still does not upload anything automatically; the player chooses whether to export and submit the already-anonymous phase-learning report.

*In-game testing is still required to confirm the contribution window appears after useful phased quest data is recorded, does not repeatedly interrupt the player, `/zq contribute` reopens it, **Open Export** opens the phase export correctly, and the copyable URL field behaves normally in the WoW UI.*

---

**VERSION 0.2.5 - August 16, 2026 - Available on GitHub**

* **Fixed** timeline switching that could remain on the previous Blasted Lands phase until the player talked to Zidormi again. The earlier implementation primarily waited for WoW to report a phase-transition event after the Zidormi interaction; the player's in-game screenshots and recordings showed that this was not reliably updating the addon immediately after the switch.

* **Added** an explicit phased-zone warning directly below the current zone name when Zone Quest Guide knows the zone has historical versions but cannot yet identify the active one: **Timeline: UNKNOWN - talk to Zidormi before questing.** This is intended to make the phase-learning requirement clear before the player starts collecting quest observations in that zone.

* **Improved** Zidormi synchronization by watching the actual timeline gossip option selected by the player. When the configured Zidormi switch option is chosen, Zone Quest Guide now updates its session timeline to the destination phase and refreshes the timeline label, phase filters, learning state, and navigation again after the world state has had a short moment to settle.

* **Changed** closing Zidormi without selecting the timeline-switch option to remain non-destructive. A plain gossip close does not flip the recorded timeline; only the recognized switch selection does.

* **Improved** compatibility with the existing v0.2.4 Timeline line by reusing that line directly below the zone name rather than adding a second phase label.

*The behavior that motivated this release was observed in-game: the timeline label appeared after talking to Zidormi, and after changing phases the addon could require another Zidormi conversation before its displayed timeline caught up. v0.2.5 still needs in-game testing to confirm both switch directions update immediately, the UNKNOWN warning appears before phase confirmation, closing Zidormi without switching does not change phase, and phase-learning data begins recording under the new phase after a switch.*

---

**VERSION 0.2.4 - August 16, 2026 - Available on GitHub**

* **Added** automatic timeline detection from curated phase-exclusive quests. When WoW reports a known phase-specific quest as active on the current map or as an available quest-line starter, Zone Quest Guide can use that live quest evidence to identify the historical version without requiring a new Zidormi conversation every session.

* **Improved** Blasted Lands detection for the currently mapped Iron Horde quests. **Under Siege** and **Attack of the Iron Horde** are known PRESENT/Iron Horde quests, so either quest can now establish the Blasted Lands timeline as PRESENT when WoW exposes it on the current map.

* **Added** a dedicated **Timeline** line directly below the current zone name in the main Zone Quest Guide window. Supported zones can now show player-facing text such as **PRESENT / Iron Horde (quest detected)**, **PAST / Before invasion (Zidormi)**, or **UNKNOWN (auto)** instead of hiding the phase state inside the zone subtitle.

* **Improved** phase learning so a curated quest-based detector can provide the reliable phase signal needed to record other live quest evidence. This lets the account-wide Horde/Alliance learning database continue gathering useful data even when the player has not spoken to Zidormi during the current login session.

* **Changed** quest-based timeline inference to stay conservative. Manual overrides and Zidormi remain stronger signals, and if curated live quest evidence points to conflicting phases at the same time, Zone QuestGuide does not guess from that quest evidence.

*In-game testing is still required for the new automatic quest-based detector and Timeline line. In PRESENT Blasted Lands, reload with **Under Siege** or **Attack of the Iron Horde** active without first talking to Zidormi and verify the panel reports **PRESENT / Iron Horde (quest detected)**, `/zq phase` identifies the evidence quest, phase learning records under PRESENT, and the existing navigation UI remains positioned correctly.*

---

**VERSION 0.2.3 - August 16, 2026 - Available on GitHub**

* **Added** account-wide local phase learning. When Zone Quest Guide already knows the current historical version of a map from Zidormi, a configured detector, or a manual phase override, it now records live WoW quest evidence for that map and phase.

* **Added** Horde/Alliance-separated learning data so multiple unquested alts can help map the same phased zone without mixing faction-specific quest observations together. The data is stored in the existing account-wide `ZoneQuestGuideDB` SavedVariable.

* **Added** evidence tracking for quests reported as available, offered by an NPC, accepted on the map, active at an NPC, accepted while the phase is known, and turned in while the phase is known. Completion is stored as supporting information but is not treated as proof that a quest belongs to the phase currently being viewed.

* **Added** `/zq learn` to show the current map's phase-learning status and `/zq export` to open a copyable phase-data report for testing/community contributions.

* **Improved** privacy of community data collection. The export intentionally contains zone IDs, faction, phase, quest IDs/names, observation counts, and phase-source information without character names, realm names, or character GUIDs.

* **Changed** phase learning to be evidence-only rather than automatically rewriting the official quest-phase database. A quest observed in one timeline may still be available in another timeline under different prerequisites, so learned data should be reviewed before it becomes a curated `QuestPhaseRequirements` entry.

* **Changed** community reporting to an explicit export workflow. The WoW addon itself does not silently upload data to GitHub or another server; automatic reporting would require a separate optional companion uploader outside the addon.

*In-game testing is still required to confirm phase observations accumulate correctly across Horde and Alliance alts, `/zq export` produces copyable data, quest acceptance/turn-in evidence is recorded under the correct timeline, and no character-identifying information appears in the export.*

---

**VERSION 0.2.2 - August 16, 2026 - Available on GitHub**

* **Fixed** a repeated Lua error from the floating navigation HUD when Retail WoW returned `GetUnitSpeed("player")` as a secret number. The HUD was comparing that protected value to a normal number while calculating ETA, which tainted execution and produced `attempt to compare local 'speed' (a secret number value...)` from `NavigationHUD.lua`.

* **Changed** the navigation HUD to stop reading player movement speed for ETA calculations. The HUD continues to show the selected quest, quest status, rotating direction arrow, and distance in yards when usable map/world-position data is available.

* **Improved** compatibility with Retail's protected/secret-value behavior by avoiding arithmetic and comparisons involving the movement-speed return value instead of trying to work around a protected value.

* **Confirmed** from the player's in-game Zidormi dialog that **"Show me the Blasted Lands before the invasion."** corresponds to the character currently being in the **PRESENT / Iron Horde** version of Blasted Lands. The player also reported visible objectives for **Under Siege** in that phase, matching the phase requirement currently assigned to that quest.

*In-game testing is still required after updating to confirm the secret-number error no longer occurs, the distance display continues updating normally, and the timeline-switch arrow still behaves correctly after switching between Blasted Lands phases.*

---

**VERSION 0.2.1 - August 16, 2026 - Available on GitHub**

* **Added** timeline-switch navigation guidance. When Zone Quest Guide knows the selected quest belongs to a different historical version of the current zone, the existing floating navigation HUD can now switch from the quest objective to the zone's timeline-switch NPC and display **SWITCH TIMELINE** instead of directing the player toward an unavailable objective.

* **Added** initial Blasted Lands Horde phase requirements for **Attack of the Iron Horde** and **Under Siege**. These quests are marked as requiring the present/Iron-Horde-incursion version of Blasted Lands. If Zidormi detection says the character is in the past version, the navigation HUD points to Zidormi and tells the player to switch to **PRESENT**.

* **Added** Blasted Lands Zidormi navigation data at the northern border so the timeline warning can be an actual directional arrow rather than only a text message.

* **Improved** phase-aware navigation so, after the player changes to the required timeline and Zone Quest Guide refreshes, the same HUD can return to the real quest target automatically.

*In-game testing is still required to confirm the HUD changes to **SWITCH TIMELINE**, points accurately to Zidormi in Blasted Lands, and returns to the quest target after changing phases. The Zidormi location and the Horde quest phase requirements are based on known game data, but the new v0.2.1 behavior has not yet been verified in-game.*

---

**VERSION 0.2.0 - August 16, 2026 - Available on GitHub**

* **Added** a new floating navigation HUD inspired by the large directional arrows used by full quest-guide addons. The HUD stays on screen independently of the main quest list and shows the selected quest, its current status, and a large directional arrow.

* **Improved** directional navigation with a smoothly rotating drawn arrow instead of relying on Unicode arrow characters. The new HUD builds the arrow from WoW line regions, so it should avoid the missing-glyph/square problem seen with the original font-based indicator while also giving the player a much easier direction to follow at a glance.

* **Added** distance and travel-time information to the floating navigation HUD. When WoW exposes enough map/world-position information for the selected quest, Zone Quest Guide estimates the remaining distance in yards. While the character is moving, it also estimates travel time from the current movement speed. Quests without usable world-position data continue to show normal tracking information instead.

* **Added** **Shift-drag** positioning for the floating arrow. Its position is saved between sessions. `/zq arrow` toggles the HUD and `/zq arrow reset` restores its default position.

* **Improved** navigation while using flight paths. WoW can report intermediate zone changes while a taxi flies across several maps, which could make a quest guide briefly replace the go-to destination with a quest from a zone the player was only passing over. Zone Quest Guide now keeps its floating HUD and addon-owned destination on the last stable quest while a taxi crosses into another map, then refreshes for the zone where the character actually lands.

  The main quest list still uses the older Core zone-refresh behavior and may visibly change while flying. This release specifically stabilizes the navigation target and go-to waypoint so a short flyover does not steal the destination marker.

*In-game testing is still required for the new floating arrow, smooth rotation, yard-distance conversion, ETA display, saved HUD position, and flight-path target hold. The existing automatic zone refresh was observed working in-game, but the new v0.2.0 navigation behavior has not yet been verified in-game.*

---

**VERSION 0.1.10 - August 16, 2026 - Available on GitHub**

* **Added** automatic Zidormi phase detection for historical-version zones. When the player talks to Zidormi, Zone Quest Guide now reads the gossip option she is offering and uses that as a strong clue for which version of the zone the character is currently standing in.

* **Improved** Blasted Lands phase handling based on the in-game Zidormi wording observed during testing. If Zidormi offers **"Take me back to the present."**, Zone Quest Guide treats the current version as **PAST**. If Zidormi instead offers to show the zone **before** an invasion/event or otherwise travel to the past, the character is currently in the **PRESENT** version.

  Previously, the phase framework could refresh when WoW reported phase-related changes, but it still needed a zone-specific detector or a manual `/zq phase` override to know what those phases actually meant. Zidormi's own gossip option provides a much more useful player-facing signal because the destination she offers is the opposite of the version the character is currently in.

* **Improved** phase switching after a Zidormi interaction. Zone Quest Guide remembers the phase Zidormi is offering to switch to for a short period. If WoW then reports a phase transition, the addon updates its session's detected phase to that destination. Merely closing Zidormi's gossip window does not change the detected phase.

* **Added** a **(Zidormi)** source label to the phase badge so the player can tell when the current **PAST** or **PRESENT** phase was identified from a Zidormi conversation rather than a manual override.

*In-game testing is still required to confirm the addon receives the expected Zidormi gossip text through WoW's gossip API and that the phase badge flips correctly after selecting the phase-switch option. The visible Blasted Lands Zidormi wording was confirmed in-game, but the new addon detection code has not yet been verified in-game.*

---

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

* **Added** location and elevation hints for quests where WoW's flat 2D map can make an NPC look like it is on the same level as nearby quests even when it is actually above, below, inside a cave, or on another floor.

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
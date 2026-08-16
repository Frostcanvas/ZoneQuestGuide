local ADDON_NAME, ZQG = ...

-- Optional supplemental quest database.
--
-- The live WoW APIs can expose accepted quests on the current map and many
-- available quest-line starters. They do not reliably expose every historical
-- side quest in every zone. Records added here fill those gaps.
--
-- Format:
-- ZQG.StaticQuests[uiMapID] = {
--   {
--     id = 12345,
--     name = "Example Quest",
--     x = 0.5123, -- normalized map coordinate (0.0 to 1.0)
--     y = 0.4388,
--     prereqs = { 12344 }, -- optional; all must be completed
--   },
-- }

ZQG.StaticQuests = ZQG.StaticQuests or {}

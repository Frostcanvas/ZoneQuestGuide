local ADDON_NAME, ZQG = ...

-- Supplemental quest database.
--
-- The live WoW APIs can expose accepted quests on the current map and many
-- available quest-line starters, but they do not reliably expose every older
-- unaccepted side/story quest. Records here fill those gaps.
--
-- Format:
-- ZQG.StaticQuests[uiMapID] = {
--   {
--     id = 12345,
--     name = "Example Quest",
--     x = 0.5123, -- normalized map coordinate (0.0 to 1.0)
--     y = 0.4388,
--     prereqs = { 12344 }, -- optional; all must be completed
--     faction = "Horde",   -- optional: "Horde" or "Alliance"
--   },
-- }

ZQG.StaticQuests = ZQG.StaticQuests or {}
ZQG.LocationHints = ZQG.LocationHints or {}

-- Thousand Needles (UiMapID 64)
-- Initial coverage for the Splithoof Heights -> Speedbarge -> Freewind Post
-- section that exposed the first missing-quest reports during testing.
ZQG.StaticQuests[64] = {
    -- Horde
    {
        id = 25814,
        name = "Go Blow that Horn",
        x = 0.8861,
        y = 0.5492,
        prereqs = { 25797, 25799 },
        faction = "Horde",
    },
    {
        id = 25826,
        name = "Deliver the Goods",
        x = 0.8858,
        y = 0.5494,
        prereqs = { 25814 },
        faction = "Horde",
    },
    {
        id = 25836,
        name = "Free Freewind Post",
        x = 0.7594,
        y = 0.7469,
        prereqs = { 25826 },
        faction = "Horde",
    },
    {
        id = 25874,
        name = "Horn of the Traitor",
        x = 0.4459,
        y = 0.4995,
        prereqs = { 25836 },
        faction = "Horde",
    },

    -- Alliance
    {
        id = 25813,
        name = "Go Blow that Horn",
        x = 0.9135,
        y = 0.5770,
        prereqs = { 25796, 25798 },
        faction = "Alliance",
    },
    {
        id = 25825,
        name = "Deliver the Goods",
        x = 0.9136,
        y = 0.5777,
        prereqs = { 25813 },
        faction = "Alliance",
    },
    {
        id = 25835,
        name = "Free Freewind Post",
        x = 0.7597,
        y = 0.7465,
        prereqs = { 25825 },
        faction = "Alliance",
    },
    {
        id = 25873,
        name = "Horn of the Traitor",
        x = 0.4458,
        y = 0.4996,
        prereqs = { 25835 },
        faction = "Alliance",
    },
}

-- Some quest locations are misleading on WoW's flat 2D map because the NPC or
-- objective is on a different vertical level. These notes let the UI warn the
-- player instead of making a nearby map pin look like it is on the same level.
ZQG.LocationHints[25874] = {
    short = "UPPER LEVEL",
    text = "Upper level of Freewind Post - Montarr is on top of the mountain. Follow the path uphill.",
}

ZQG.LocationHints[25873] = {
    short = "UPPER LEVEL",
    text = "Upper level of Freewind Post - Montarr is on top of the mountain. Follow the path uphill.",
}

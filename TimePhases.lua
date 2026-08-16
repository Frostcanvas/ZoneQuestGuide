local ADDON_NAME, ZQG = ...

ZoneQuestGuideDB = ZoneQuestGuideDB or {}
ZQG.TimePhaseZones = ZQG.TimePhaseZones or {}

-- Keep an untouched copy of supplemental quest records. The active
-- ZQG.StaticQuests table can then be rebuilt whenever the player's historical
-- phase changes without losing quests from the other phase.
local phaseMaster = {}
for mapID, quests in pairs(ZQG.StaticQuests or {}) do
    phaseMaster[mapID] = {}
    for index, quest in ipairs(quests) do
        phaseMaster[mapID][index] = quest
    end
end

local function Print(msg)
    DEFAULT_CHAT_FRAME:AddMessage("|cff66ccffZoneQuestGuide:|r " .. tostring(msg))
end

local function CurrentMapID()
    if not C_Map or not C_Map.GetBestMapForUnit then
        return nil
    end
    return C_Map.GetBestMapForUnit("player")
end

local function GetDB()
    ZoneQuestGuideDB = ZoneQuestGuideDB or {}
    ZoneQuestGuideDB.phaseOverrides = ZoneQuestGuideDB.phaseOverrides or {}
    return ZoneQuestGuideDB
end

local function ZoneHasPhaseData(mapID)
    if not mapID then
        return false
    end

    local DB = GetDB()
    if DB.phaseOverrides[mapID] then
        return true
    end

    if ZQG.TimePhaseZones[mapID] then
        return true
    end

    local quests = phaseMaster[mapID]
    if not quests then
        return false
    end

    for _, quest in ipairs(quests) do
        if quest.phase then
            return true
        end
    end

    return false
end

local function DetectConfiguredPhase(mapID)
    local config = mapID and ZQG.TimePhaseZones[mapID] or nil
    if not config or type(config.detect) ~= "function" then
        return nil
    end

    local ok, phaseKey = pcall(config.detect)
    if ok and phaseKey and phaseKey ~= "" then
        return tostring(phaseKey):lower()
    end

    return nil
end

function ZQG.GetTimePhaseKey(mapID)
    mapID = mapID or CurrentMapID()
    if not mapID then
        return nil, "unknown"
    end

    local DB = GetDB()
    local override = DB.phaseOverrides[mapID]
    if override and override ~= "auto" then
        return tostring(override):lower(), "manual"
    end

    local detected = DetectConfiguredPhase(mapID)
    if detected then
        return detected, "detected"
    end

    return nil, "auto"
end

local function PhaseMatches(questPhase, activePhase)
    if not questPhase then
        return true
    end

    -- Phase-tagged supplemental quests are intentionally hidden when the phase
    -- cannot be identified. Showing no static record is safer than pointing the
    -- player toward an NPC that only exists in another historical version.
    if not activePhase then
        return false
    end

    if type(questPhase) == "table" then
        for _, phaseKey in ipairs(questPhase) do
            if tostring(phaseKey):lower() == activePhase then
                return true
            end
        end
        return false
    end

    return tostring(questPhase):lower() == activePhase
end

function ZQG.ApplyTimePhaseFilter(mapID)
    mapID = mapID or CurrentMapID()
    if not mapID then
        return
    end

    local master = phaseMaster[mapID]
    if not master then
        return
    end

    local activePhase = ZQG.GetTimePhaseKey(mapID)
    local filtered = {}

    for _, quest in ipairs(master) do
        if PhaseMatches(quest.phase, activePhase) then
            filtered[#filtered + 1] = quest
        end
    end

    ZQG.StaticQuests[mapID] = filtered
end

local function GetPhaseDisplay(mapID)
    if not ZoneHasPhaseData(mapID) then
        return nil
    end

    local phaseKey, source = ZQG.GetTimePhaseKey(mapID)
    local config = ZQG.TimePhaseZones[mapID]
    local label

    if phaseKey and config and config.phases and config.phases[phaseKey] then
        label = config.phases[phaseKey]
    elseif phaseKey then
        label = phaseKey:upper()
    else
        label = "AUTO"
    end

    if source == "manual" then
        return label .. " (manual)"
    elseif source == "detected" then
        return label
    end

    return label
end

local function UpdateZonePhaseBadge()
    local mapID = CurrentMapID()
    local display = GetPhaseDisplay(mapID)
    if not display then
        return
    end

    local mainFrame = _G.ZoneQuestGuideFrame
    if not mainFrame then
        return
    end

    for _, region in ipairs({ mainFrame:GetRegions() }) do
        if region.GetObjectType and region:GetObjectType() == "FontString" then
            local text = region:GetText()
            if text and text:find("unfinished quests", 1, true) then
                if not text:find("[PHASE:", 1, true) then
                    region:SetText(text .. "  |cff66ccff[PHASE: " .. display .. "]|r")
                end
                return
            end
        end
    end
end

local function RefreshForPhaseChange()
    local mapID = CurrentMapID()
    if not mapID then
        return
    end

    ZQG.ApplyTimePhaseFilter(mapID)

    if ZQG.Refresh then
        ZQG.Refresh()
    end

    C_Timer.After(0.05, UpdateZonePhaseBadge)
end

local phaseRefreshScheduled = false
local function SchedulePhaseRefresh(delay)
    if phaseRefreshScheduled then
        return
    end

    phaseRefreshScheduled = true
    C_Timer.After(delay or 0.15, function()
        phaseRefreshScheduled = false
        RefreshForPhaseChange()
    end)
end

local events = CreateFrame("Frame")
events:RegisterEvent("PLAYER_ENTERING_WORLD")
events:RegisterEvent("ZONE_CHANGED_NEW_AREA")
events:RegisterEvent("ZONE_CHANGED")
events:RegisterEvent("QUEST_LOG_UPDATE")
events:RegisterEvent("GOSSIP_CLOSED")
events:RegisterEvent("UNIT_PHASE")
events:SetScript("OnEvent", function()
    -- UNIT_PHASE does not provide a universal historical-phase identifier, and
    -- some phase switches are accompanied by quest/gossip/zone changes instead.
    -- Treat these events as refresh hints and let the configured detector or
    -- per-zone manual override decide which supplemental records are valid.
    SchedulePhaseRefresh(0.15)
end)

-- Keep the phase badge in sync with normal manual/minimap refreshes.
local originalRefresh = ZQG.Refresh
if originalRefresh then
    ZQG.Refresh = function(...)
        local results = { originalRefresh(...) }
        C_Timer.After(0.05, UpdateZonePhaseBadge)
        return unpack(results)
    end
end

-- Extend the slash command chain. "auto" clears the per-zone override. Past
-- and present are provided as common historical-phase names, while registered
-- zones can use any additional phase key through the same command.
local originalSlashHandler = SlashCmdList.ZONEQUESTGUIDE
SlashCmdList.ZONEQUESTGUIDE = function(msg)
    local command = (msg or ""):lower():match("^%s*(.-)%s*$")
    local phaseArg = command:match("^phase%s+(.+)$")

    if command == "phase" then
        local mapID = CurrentMapID()
        local phaseKey, source = ZQG.GetTimePhaseKey(mapID)
        local shown = phaseKey and phaseKey:upper() or "AUTO"
        Print("Current time-phase mode: " .. shown .. " (" .. source .. "). Use /zq phase auto, /zq phase past, or /zq phase present.")
        return
    elseif phaseArg then
        local mapID = CurrentMapID()
        if not mapID then
            Print("Current zone is unavailable.")
            return
        end

        local DB = GetDB()
        phaseArg = phaseArg:lower()

        if phaseArg == "auto" then
            DB.phaseOverrides[mapID] = nil
            Print("Time phase for this zone is now AUTO.")
        else
            DB.phaseOverrides[mapID] = phaseArg
            Print("Time phase for this zone is now " .. phaseArg:upper() .. " (manual).")
        end

        RefreshForPhaseChange()
        return
    end

    if originalSlashHandler then
        originalSlashHandler(msg)
    end
end

ZQG.RefreshForTimePhase = RefreshForPhaseChange

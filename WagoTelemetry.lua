local ADDON_NAME, ZQG = ...

local GetAddOnMetadata = C_AddOns and C_AddOns.GetAddOnMetadata or GetAddOnMetadata
local projectID = GetAddOnMetadata and GetAddOnMetadata(ADDON_NAME, "X-Wago-ID") or nil
local analytics
local registrationAttempted = false
local analyticsReadyAnnounced = false
local sentThisSession = {}

local STRONG_EVIDENCE = {
    available = true,
    offered = true,
    active = true,
    turnedIn = true,
}

local function Print(msg)
    DEFAULT_CHAT_FRAME:AddMessage("|cff66ccffZoneQuestGuide:|r " .. tostring(msg))
end

local function CurrentMapID()
    if C_Map and C_Map.GetBestMapForUnit then
        return C_Map.GetBestMapForUnit("player")
    end
    return nil
end

local function PlayerFaction()
    if UnitFactionGroup then
        return (UnitFactionGroup("player") or "Neutral"):lower()
    end
    return "neutral"
end

local function GetReportablePhase(mapID)
    if not mapID or not ZQG.GetTimePhaseKey then
        return nil, nil
    end

    local phase, source = ZQG.GetTimePhaseKey(mapID)
    if not phase then
        return nil, source
    end

    -- Manual phase overrides are useful for the local learning database, but
    -- they are intentionally excluded from community telemetry because a typo or
    -- mistaken override should not become crowdsourced phase evidence.
    if source ~= "zidormi" and source ~= "detected" then
        return nil, source
    end

    return tostring(phase):lower(), source
end

local function RegisterAnalytics()
    if analytics then
        return analytics
    end

    if registrationAttempted then
        return nil
    end
    registrationAttempted = true

    if not projectID or projectID == "" then
        return nil
    end

    local provider = _G.WagoAnalytics
    if not provider or type(provider.Register) ~= "function" then
        return nil
    end

    local ok, registered = pcall(provider.Register, provider, projectID)
    if not ok or not registered then
        return nil
    end

    analytics = registered

    if type(analytics.Switch) == "function" then
        pcall(analytics.Switch, analytics, "phase_learning_enabled", true)
    end

    return analytics
end

local function SafeToken(value)
    value = tostring(value or "unknown"):lower()
    value = value:gsub("[^%w]+", "_")
    value = value:gsub("^_+", "")
    value = value:gsub("_+$", "")
    if value == "" then
        return "unknown"
    end
    return value
end

local function MetricName(mapID, faction, phase, questID, evidence, source)
    return table.concat({
        "phase",
        "m" .. SafeToken(mapID),
        SafeToken(faction),
        SafeToken(phase),
        "q" .. SafeToken(questID),
        SafeToken(evidence),
        "src",
        SafeToken(source),
    }, "_")
end

local function ReportEvidence(questID, evidence, mapID)
    if type(questID) ~= "number" or questID <= 0 or not STRONG_EVIDENCE[evidence] then
        return false
    end

    mapID = mapID or CurrentMapID()
    local phase, source = GetReportablePhase(mapID)
    if not mapID or not phase then
        return false
    end

    local faction = PlayerFaction()
    local key = table.concat({
        tostring(mapID),
        faction,
        phase,
        tostring(questID),
        evidence,
        tostring(source),
    }, ":")

    if sentThisSession[key] then
        return true
    end

    local api = RegisterAnalytics()
    if not api or type(api.IncrementCounter) ~= "function" then
        return false
    end

    local metric = MetricName(mapID, faction, phase, questID, evidence, source)
    local ok = pcall(api.IncrementCounter, api, metric, 1)
    if not ok then
        return false
    end

    sentThisSession[key] = true

    -- A fixed counter makes it easy to confirm that the bridge is receiving
    -- useful observations without needing to inspect every quest-specific key.
    pcall(api.IncrementCounter, api, "phase_evidence_total", 1)
    return true
end

local function ScanAvailableQuestLines()
    local mapID = CurrentMapID()
    local phase = GetReportablePhase(mapID)
    if not mapID or not phase or not C_QuestLine or not C_QuestLine.GetAvailableQuestLines then
        return
    end

    local ok, lines = pcall(C_QuestLine.GetAvailableQuestLines, mapID)
    if not ok or type(lines) ~= "table" then
        return
    end

    for _, info in ipairs(lines) do
        if info and info.questID then
            ReportEvidence(info.questID, "available", mapID)
        end
    end
end

local function ScanGossipEvidence()
    local mapID = CurrentMapID()
    local phase = GetReportablePhase(mapID)
    if not mapID or not phase or not C_GossipInfo then
        return
    end

    if C_GossipInfo.GetAvailableQuests then
        local ok, quests = pcall(C_GossipInfo.GetAvailableQuests)
        if ok and type(quests) == "table" then
            for _, info in ipairs(quests) do
                if info and info.questID then
                    ReportEvidence(info.questID, "offered", mapID)
                end
            end
        end
    end

    if C_GossipInfo.GetActiveQuests then
        local ok, quests = pcall(C_GossipInfo.GetActiveQuests)
        if ok and type(quests) == "table" then
            for _, info in ipairs(quests) do
                if info and info.questID then
                    ReportEvidence(info.questID, "active", mapID)
                end
            end
        end
    end
end

local function CaptureQuestDetail()
    if not GetQuestID then
        return
    end

    local questID = GetQuestID()
    if questID and questID > 0 then
        ReportEvidence(questID, "offered")
    end
end

local scanScheduled = false
local function ScheduleAvailableScan(delay)
    if scanScheduled then
        return
    end

    scanScheduled = true
    C_Timer.After(delay or 0.3, function()
        scanScheduled = false
        ScanAvailableQuestLines()
    end)
end

local events = CreateFrame("Frame")
events:RegisterEvent("PLAYER_ENTERING_WORLD")
events:RegisterEvent("ZONE_CHANGED_NEW_AREA")
events:RegisterEvent("ZONE_CHANGED")
events:RegisterEvent("QUEST_LOG_UPDATE")
events:RegisterEvent("QUESTLINE_UPDATE")
events:RegisterEvent("QUEST_TURNED_IN")
events:RegisterEvent("QUEST_DETAIL")
events:RegisterEvent("GOSSIP_SHOW")
pcall(events.RegisterEvent, events, "UNIT_PHASE")

events:SetScript("OnEvent", function(_, event, arg1)
    if event == "QUEST_TURNED_IN" then
        if type(arg1) == "number" and arg1 > 0 then
            ReportEvidence(arg1, "turnedIn")
        end
        ScheduleAvailableScan(0.3)
        return
    end

    if event == "QUEST_DETAIL" then
        C_Timer.After(0.05, CaptureQuestDetail)
        return
    end

    if event == "GOSSIP_SHOW" then
        -- TimelineSync/TimePhases may need a moment to establish the Zidormi
        -- phase before community evidence is sent.
        C_Timer.After(0.15, function()
            ScanGossipEvidence()
            ScanAvailableQuestLines()
        end)
        return
    end

    if event == "PLAYER_ENTERING_WORLD" then
        C_Timer.After(1.0, function()
            RegisterAnalytics()
            ScanAvailableQuestLines()
        end)
    elseif event == "ZONE_CHANGED_NEW_AREA" or event == "UNIT_PHASE" then
        ScheduleAvailableScan(0.6)
    else
        ScheduleAvailableScan(0.3)
    end
end)

local function WagoStatus()
    if not projectID or projectID == "" then
        Print("Wago telemetry is prepared but not active yet: the Wago project ID still needs to be added to ZoneQuestGuide.toc.")
        return
    end

    local api = RegisterAnalytics()
    if api then
        if not analyticsReadyAnnounced then
            analyticsReadyAnnounced = true
        end
        Print("Wago telemetry is active. It sends anonymous strong phase evidence only: map ID, faction, phase, quest ID, evidence type, and phase source.")
        return
    end

    Print("Wago project ID is configured, but WagoAnalytics is not available on this client or data sharing is not active.")
end

local originalSlashHandler = SlashCmdList.ZONEQUESTGUIDE
SlashCmdList.ZONEQUESTGUIDE = function(msg)
    local command = (msg or ""):lower():match("^%s*(.-)%s*$")

    if command == "wago" or command == "telemetry" then
        WagoStatus()
        return
    end

    if originalSlashHandler then
        originalSlashHandler(msg)
    end
end

ZQG.ReportPhaseEvidenceToWago = ReportEvidence
ZQG.GetWagoTelemetryStatus = function()
    return {
        projectID = projectID,
        active = analytics ~= nil,
    }
end

local ADDON_NAME, ZQG = ...

local DB = ZoneQuestGuideDB
local mainFrame = _G.ZoneQuestGuideFrame

if not mainFrame then
    return
end

-- ---------------------------------------------------------------------------
-- Reliable navigation arrow
-- ---------------------------------------------------------------------------
-- Core.lua keeps the current direction in a FontString. Some WoW fonts do not
-- contain the Unicode arrow glyphs, which makes them render as a square box.
-- Keep that FontString as the direction source, hide its glyph, and draw the
-- direction with a normal WoW texture instead.

local directionText
for _, region in ipairs({ mainFrame:GetRegions() }) do
    if region.GetObjectType and region:GetObjectType() == "FontString" then
        local text = region:GetText()
        if text == "↑" then
            directionText = region
            break
        end
    end
end

if directionText then
    local directionTexture = mainFrame:CreateTexture(nil, "OVERLAY")
    directionTexture:SetSize(34, 34)
    directionTexture:SetPoint("CENTER", directionText, "CENTER", 0, 0)
    directionTexture:SetTexture("Interface\\Buttons\\UI-SpellbookIcon-NextPage-Up")

    -- The source texture points to the right. Rotate it to match Core.lua's
    -- eight direction states.
    local rotations = {
        ["↑"] = -math.pi / 2,
        ["↗"] = -math.pi / 4,
        ["→"] = 0,
        ["↘"] = math.pi / 4,
        ["↓"] = math.pi / 2,
        ["↙"] = 3 * math.pi / 4,
        ["←"] = math.pi,
        ["↖"] = -3 * math.pi / 4,
    }

    directionText:SetAlpha(0)

    local function UpdateDirectionTexture()
        local text = directionText:GetText()
        local rotation = rotations[text]

        if rotation then
            directionTexture:SetRotation(rotation)
            directionTexture:Show()
        else
            directionTexture:Hide()
        end
    end

    UpdateDirectionTexture()
    mainFrame:HookScript("OnUpdate", UpdateDirectionTexture)
end

-- ---------------------------------------------------------------------------
-- Minimap button
-- ---------------------------------------------------------------------------

if DB.showMinimapIcon == nil then
    DB.showMinimapIcon = true
end
if DB.minimapAngle == nil then
    DB.minimapAngle = 225
end

local minimapButton = CreateFrame("Button", "ZoneQuestGuideMinimapButton", Minimap)
minimapButton:SetSize(31, 31)
minimapButton:SetFrameStrata("MEDIUM")
minimapButton:SetFrameLevel(8)
minimapButton:RegisterForClicks("LeftButtonUp", "RightButtonUp")
minimapButton:RegisterForDrag("LeftButton")
minimapButton:SetHighlightTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight")

local icon = minimapButton:CreateTexture(nil, "BACKGROUND")
icon:SetSize(20, 20)
icon:SetPoint("CENTER", 0, 1)
icon:SetTexture("Interface\\Icons\\INV_Misc_Map_01")

local background = minimapButton:CreateTexture(nil, "ARTWORK")
background:SetSize(20, 20)
background:SetPoint("CENTER", 0, 1)
background:SetTexture("Interface\\Minimap\\UI-Minimap-Background")
background:SetVertexColor(0.1, 0.1, 0.1, 0.65)
background:SetDrawLayer("ARTWORK", -1)

local border = minimapButton:CreateTexture(nil, "OVERLAY")
border:SetSize(53, 53)
border:SetPoint("TOPLEFT")
border:SetTexture("Interface\\Minimap\\MiniMap-TrackingBorder")

local function UpdateMinimapPosition()
    if not Minimap then
        return
    end

    local radius = (math.max(Minimap:GetWidth(), Minimap:GetHeight()) / 2) + 8
    local angle = math.rad(DB.minimapAngle or 225)

    minimapButton:ClearAllPoints()
    minimapButton:SetPoint(
        "CENTER",
        Minimap,
        "CENTER",
        math.cos(angle) * radius,
        math.sin(angle) * radius
    )
end

local function UpdateMinimapVisibility()
    if DB.showMinimapIcon == false then
        minimapButton:Hide()
    else
        UpdateMinimapPosition()
        minimapButton:Show()
    end
end

minimapButton:SetScript("OnClick", function(_, button)
    if button == "RightButton" then
        if ZQG.Refresh then
            ZQG.Refresh()
        end
        return
    end

    if mainFrame:IsShown() then
        mainFrame:Hide()
        DB.hidden = true
    else
        mainFrame:Show()
        DB.hidden = false
        if ZQG.Refresh then
            ZQG.Refresh()
        end
    end
end)

minimapButton:SetScript("OnDragStart", function(self)
    if not IsShiftKeyDown() then
        return
    end

    self:SetScript("OnUpdate", function()
        local mx, my = Minimap:GetCenter()
        if not mx or not my then
            return
        end

        local cursorX, cursorY = GetCursorPosition()
        local scale = UIParent:GetEffectiveScale()
        cursorX = cursorX / scale
        cursorY = cursorY / scale

        DB.minimapAngle = math.deg(math.atan2(cursorY - my, cursorX - mx))
        UpdateMinimapPosition()
    end)
end)

minimapButton:SetScript("OnDragStop", function(self)
    self:SetScript("OnUpdate", nil)
end)

minimapButton:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_LEFT")
    GameTooltip:AddLine("Zone Quest Guide")
    GameTooltip:AddLine("Left-click: Show or hide", 1, 1, 1)
    GameTooltip:AddLine("Right-click: Refresh quests", 1, 1, 1)
    GameTooltip:AddLine("Shift-drag: Move around the minimap", 1, 1, 1)
    GameTooltip:Show()
end)

minimapButton:SetScript("OnLeave", function()
    GameTooltip:Hide()
end)

UpdateMinimapVisibility()

-- Extend the existing /zq command without replacing any of Core.lua's normal
-- commands.
local originalSlashHandler = SlashCmdList.ZONEQUESTGUIDE
SlashCmdList.ZONEQUESTGUIDE = function(msg)
    local command = (msg or ""):lower():match("^%s*(.-)%s*$")

    if command == "minimap" then
        DB.showMinimapIcon = not DB.showMinimapIcon
        UpdateMinimapVisibility()
        DEFAULT_CHAT_FRAME:AddMessage(
            "|cff66ccffZoneQuestGuide:|r Minimap icon is "
                .. (DB.showMinimapIcon and "ON" or "OFF")
                .. "."
        )
        return
    end

    if originalSlashHandler then
        originalSlashHandler(msg)
    end
end

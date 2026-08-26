local _G = tDFUI.GetGlobalEnv()
local T = tDFUI.T

local module = tDFUI:register({
  title = T["Movable Unit Frames Extended"],
  description = T["mufe_desc"],
  expansions = { ["vanilla"] = true, ["tbc"] = true },
  category = T["Unit Frames"],
  enabled = true,
})

local movables = {
  -- Unit Frames
  "PlayerFrame",
  "TargetFrame",
  "TargetFrameToT",
  "PetFrame",
  "PartyMemberFrame1",
  "PartyMemberFrame2",
  "PartyMemberFrame3",
  "PartyMemberFrame4",

  -- Castbars
  "tDFImprovedCastbar",
  "CastingBarFrame",
  "TargetCastbar",

  -- Action Bars
  "MainMenuBar",
  "MultiBarBottomLeft",
  "MultiBarBottomRight",
  "MultiBarRight",
  "MultiBarLeft",
  "PetActionBarFrame",
  "ShapeshiftBarFrame",

  -- Minimap & UI Widgets
  "MyCustomMinimap",
  "tDFmicrobutton",
  "tDFbagMain",
  "xpbar",
  "CustomReputationBar",
  "tDFquestwatchframe",
  "QuestWatchFrame",
  "tDFDurability",
  "DurabilityFrame",
  "MiniMapMailFrame",

  -- Buff & Debuff Anchors
  "tDF_Buffs1",
  "tDF_Buffs2",
  "tDF_WeaponBuffs",
  "tDF_Debuffs",
}

local default_anchors = {
  ["PlayerFrame"] = { "TOPLEFT", "UIParent", "TOPLEFT", -19, -4 },
  ["TargetFrame"] = { "TOPLEFT", "UIParent", "TOPLEFT", 250, -4 },
  ["TargetFrameToT"] = { "BOTTOMRIGHT", "TargetFrame", "BOTTOMRIGHT", -35, -10 },
  ["PetFrame"] = { "TOPLEFT", "PlayerFrame", "TOPLEFT", 80, -60 },
  ["PartyMemberFrame1"] = { "TOPLEFT", "UIParent", "TOPLEFT", 10, -160 },
  ["PartyMemberFrame2"] = { "TOPLEFT", "PartyMemberFrame1", "BOTTOMLEFT", 0, -10 },
  ["PartyMemberFrame3"] = { "TOPLEFT", "PartyMemberFrame2", "BOTTOMLEFT", 0, -10 },
  ["PartyMemberFrame4"] = { "TOPLEFT", "PartyMemberFrame3", "BOTTOMLEFT", 0, -10 },
  ["MyCustomMinimap"] = { "TOPRIGHT", "UIParent", "TOPRIGHT", 0, -20 },
  ["tDFmicrobutton"] = { "BOTTOMRIGHT", "UIParent", "BOTTOMRIGHT", -10, 8 },
  ["tDFbagMain"] = { "BOTTOMRIGHT", "UIParent", "BOTTOMRIGHT", -24, 45 },
  ["xpbar"] = { "CENTER", "MainMenuExpBar", "CENTER", 0, 2 },
  ["CustomReputationBar"] = { "CENTER", "ReputationWatchBar", "CENTER", 0, -60 },
  ["tDFImprovedCastbar"] = { "BOTTOM", "UIParent", "BOTTOM", 0, 225 },
  ["CastingBarFrame"] = { "BOTTOM", "UIParent", "BOTTOM", 0, 60 },
  ["TargetCastbar"] = { "BOTTOM", "TargetFrame", "BOTTOM", 0, -15 },
  ["MainMenuBar"] = { "BOTTOM", "UIParent", "BOTTOM", 0, 0 },
  ["MultiBarBottomLeft"] = { "BOTTOMLEFT", "MainMenuBar", "TOPLEFT", 0, 17 },
  ["MultiBarBottomRight"] = { "BOTTOMLEFT", "MultiBarBottomLeft", "TOPLEFT", 0, 4 },
  ["MultiBarRight"] = { "TOPRIGHT", "UIParent", "TOPRIGHT", -7, -200 },
  ["MultiBarLeft"] = { "TOPRIGHT", "MultiBarRight", "TOPLEFT", -5, 0 },
  ["PetActionBarFrame"] = { "BOTTOMLEFT", "MainMenuBar", "TOPLEFT", 36, 2 },
  ["ShapeshiftBarFrame"] = { "BOTTOMLEFT", "MainMenuBar", "TOPLEFT", 30, 0 },
  ["tDFquestwatchframe"] = { "TOPRIGHT", "MyCustomMinimap", "BOTTOMRIGHT", -20, -50 },
  ["QuestWatchFrame"] = { "TOPRIGHT", "UIParent", "TOPRIGHT", -10, -200 },
  ["tDFDurability"] = { "TOPRIGHT", "MyCustomMinimap", "BOTTOMLEFT", -20, 0 },
  ["DurabilityFrame"] = { "TOPRIGHT", "UIParent", "TOPRIGHT", -150, -200 },
  ["MiniMapMailFrame"] = { "TOPRIGHT", "MyCustomMinimap", "BOTTOMRIGHT", 20, 0 },
  ["tDF_Buffs1"] = { "TOPRIGHT", "UIParent", "TOPRIGHT", -210, -20 },
  ["tDF_Buffs2"] = { "TOPRIGHT", "UIParent", "TOPRIGHT", -210, -60 },
  ["tDF_WeaponBuffs"] = { "TOPRIGHT", "UIParent", "TOPRIGHT", -210, -100 },
  ["tDF_Debuffs"] = { "TOPRIGHT", "UIParent", "TOPRIGHT", -210, -145 },
}

local buff_definitions = {
  ["tDF_Buffs1"] = { label = "Buffs 1", r = 0, g = 0.6, b = 1 },
  ["tDF_Buffs2"] = { label = "Buffs 2", r = 0, g = 0.6, b = 1 },
  ["tDF_WeaponBuffs"] = { label = "Item Buffs", r = 1, g = 0.75, b = 0 },
  ["tDF_Debuffs"] = { label = "Debuffs", r = 1, g = 0.2, b = 0.2 },
}

local movedb = nil

local function UpdateBuffAnchors()
  if BuffButton0 and _G["tDF_Buffs1"] then
    BuffButton0:ClearAllPoints()
    BuffButton0:SetPoint("TOPRIGHT", _G["tDF_Buffs1"], "TOPRIGHT", 0, 0)
  end
  if BuffButton8 and _G["tDF_Buffs2"] then
    BuffButton8:ClearAllPoints()
    BuffButton8:SetPoint("TOPRIGHT", _G["tDF_Buffs2"], "TOPRIGHT", 0, 0)
  end
  if TempEnchant1 and _G["tDF_WeaponBuffs"] then
    TempEnchant1:ClearAllPoints()
    TempEnchant1:SetPoint("TOPRIGHT", _G["tDF_WeaponBuffs"], "TOPRIGHT", 0, 0)
  end
  if BuffButton16 and _G["tDF_Debuffs"] then
    BuffButton16:ClearAllPoints()
    BuffButton16:SetPoint("TOPRIGHT", _G["tDF_Debuffs"], "TOPRIGHT", 0, 0)
  end
end

local function ResetFramePosition(frameName)
  local f = _G[frameName]
  if not f then return end

  if movedb then
    movedb[frameName] = nil
  end

  f:SetMovable(true)
  f:SetUserPlaced(false)
  f:ClearAllPoints()

  local def = default_anchors[frameName]
  if def then
    local relTo = _G[def[2]] or UIParent
    f:SetPoint(def[1], relTo, def[3], def[4], def[5])
  else
    f:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
  end

  UpdateBuffAnchors()
  DEFAULT_CHAT_FRAME:AddMessage("|cff008000[tDF]|r " .. frameName .. " reset to default position.", 1, 1, 0)
end

local function CreateBuffAnchors()
  for name, info in pairs(buff_definitions) do
    if not _G[name] then
      local anchor = CreateFrame("Button", name, UIParent)
      anchor:SetWidth(32)
      anchor:SetHeight(32)
      anchor:SetFrameStrata("MEDIUM")
      anchor:SetMovable(true)
      anchor:EnableMouse(false)

      local def = default_anchors[name]
      if def then
        anchor:SetPoint(def[1], UIParent, def[3], def[4], def[5])
      end

      -- Background box when editing
      anchor.bg = anchor:CreateTexture(nil, "BACKGROUND")
      anchor.bg:SetAllPoints(anchor)
      anchor.bg:SetTexture(info.r, info.g, info.b, 0.45)
      anchor.bg:Hide()

      -- Border when editing
      anchor.border = anchor:CreateTexture(nil, "BORDER")
      anchor.border:SetPoint("TOPLEFT", anchor, "TOPLEFT", -1, 1)
      anchor.border:SetPoint("BOTTOMRIGHT", anchor, "BOTTOMRIGHT", 1, -1)
      anchor.border:SetTexture(info.r, info.g, info.b, 0.9)
      anchor.border:Hide()

      -- Label when editing
      anchor.text = anchor:CreateFontString(nil, "OVERLAY")
      anchor.text:SetFont(STANDARD_TEXT_FONT, 9, "OUTLINE")
      anchor.text:SetPoint("CENTER", anchor, "CENTER", 0, 0)
      anchor.text:SetText(info.label)
      anchor.text:SetTextColor(1, 1, 1, 1)
      anchor.text:Hide()
    end
  end
end

local function SetupChildDrags(enable)
  -- Buff anchor boxes visual mode
  for name, _ in pairs(buff_definitions) do
    local anchor = _G[name]
    if anchor then
      if enable then
        anchor:EnableMouse(true)
        anchor:SetMovable(true)
        anchor:RegisterForDrag("LeftButton")
        anchor:SetScript("OnDragStart", function() this:StartMoving() end)
        anchor:SetScript("OnDragStop", function()
          this:StopMovingOrSizing()
          UpdateBuffAnchors()
        end)
        anchor:SetScript("OnMouseUp", function()
          if IsShiftKeyDown() and IsControlKeyDown() and arg1 == "RightButton" then
            ResetFramePosition(this:GetName())
          end
        end)
        if anchor.bg then anchor.bg:Show() end
        if anchor.border then anchor.border:Show() end
        if anchor.text then anchor.text:Show() end
      else
        anchor:EnableMouse(false)
        anchor:SetScript("OnDragStart", nil)
        anchor:SetScript("OnDragStop", nil)
        anchor:SetScript("OnMouseUp", nil)
        if anchor.bg then anchor.bg:Hide() end
        if anchor.border then anchor.border:Hide() end
        if anchor.text then anchor.text:Hide() end
      end
    end
  end

  -- Active Buff / Debuff buttons forwarding
  for i = 0, 7 do
    local bb = _G["BuffButton" .. i]
    if bb then
      local anchor = _G["tDF_Buffs1"]
      if enable and anchor then
        bb:RegisterForDrag("LeftButton")
        bb:SetScript("OnDragStart", function() anchor:StartMoving() end)
        bb:SetScript("OnDragStop", function()
          anchor:StopMovingOrSizing()
          UpdateBuffAnchors()
        end)
        bb:SetScript("OnMouseUp", function()
          if IsShiftKeyDown() and IsControlKeyDown() and arg1 == "RightButton" then
            ResetFramePosition("tDF_Buffs1")
          end
        end)
      else
        bb:SetScript("OnDragStart", nil)
        bb:SetScript("OnDragStop", nil)
        bb:SetScript("OnMouseUp", nil)
      end
    end
  end

  for i = 8, 15 do
    local bb = _G["BuffButton" .. i]
    if bb then
      local anchor = _G["tDF_Buffs2"]
      if enable and anchor then
        bb:RegisterForDrag("LeftButton")
        bb:SetScript("OnDragStart", function() anchor:StartMoving() end)
        bb:SetScript("OnDragStop", function()
          anchor:StopMovingOrSizing()
          UpdateBuffAnchors()
        end)
        bb:SetScript("OnMouseUp", function()
          if IsShiftKeyDown() and IsControlKeyDown() and arg1 == "RightButton" then
            ResetFramePosition("tDF_Buffs2")
          end
        end)
      else
        bb:SetScript("OnDragStart", nil)
        bb:SetScript("OnDragStop", nil)
        bb:SetScript("OnMouseUp", nil)
      end
    end
  end

  for i = 16, 23 do
    local bb = _G["BuffButton" .. i]
    if bb then
      local anchor = _G["tDF_Debuffs"]
      if enable and anchor then
        bb:RegisterForDrag("LeftButton")
        bb:SetScript("OnDragStart", function() anchor:StartMoving() end)
        bb:SetScript("OnDragStop", function()
          anchor:StopMovingOrSizing()
          UpdateBuffAnchors()
        end)
        bb:SetScript("OnMouseUp", function()
          if IsShiftKeyDown() and IsControlKeyDown() and arg1 == "RightButton" then
            ResetFramePosition("tDF_Debuffs")
          end
        end)
      else
        bb:SetScript("OnDragStart", nil)
        bb:SetScript("OnDragStop", nil)
        bb:SetScript("OnMouseUp", nil)
      end
    end
  end

  for i = 1, 2 do
    local te = _G["TempEnchant" .. i]
    if te then
      local anchor = _G["tDF_WeaponBuffs"]
      if enable and anchor then
        te:RegisterForDrag("LeftButton")
        te:SetScript("OnDragStart", function() anchor:StartMoving() end)
        te:SetScript("OnDragStop", function()
          anchor:StopMovingOrSizing()
          UpdateBuffAnchors()
        end)
        te:SetScript("OnMouseUp", function()
          if IsShiftKeyDown() and IsControlKeyDown() and arg1 == "RightButton" then
            ResetFramePosition("tDF_WeaponBuffs")
          end
        end)
      else
        te:SetScript("OnDragStart", nil)
        te:SetScript("OnDragStop", nil)
        te:SetScript("OnMouseUp", nil)
      end
    end
  end

  -- Minimap child forwarding
  local minimapParent = _G["MyCustomMinimap"]
  if minimapParent and tMinimap then
    if enable then
      tMinimap:EnableMouse(true)
      tMinimap:RegisterForDrag("LeftButton")
      tMinimap:SetScript("OnDragStart", function() minimapParent:StartMoving() end)
      tMinimap:SetScript("OnDragStop", function() minimapParent:StopMovingOrSizing() end)
      tMinimap:SetScript("OnMouseUp", function()
        if IsShiftKeyDown() and IsControlKeyDown() and arg1 == "RightButton" then
          ResetFramePosition("MyCustomMinimap")
        end
      end)
    else
      tMinimap:SetScript("OnDragStart", nil)
      tMinimap:SetScript("OnDragStop", nil)
      tMinimap:SetScript("OnMouseUp", nil)
    end
  end

  -- Micro Menu Buttons forwarding
  local microFrame = _G["tDFmicrobutton"]
  if microFrame then
    local microButtons = {
      "CharacterMicroButton", "SpellbookMicroButton", "TalentMicroButton",
      "QuestLogMicroButton", "SocialsMicroButton", "WorldMapMicroButton",
      "MainMenuMicroButton", "HelpMicroButton", "LFTMicroButton", "LFTMinimapButton"
    }
    for _, btnName in pairs(microButtons) do
      local btn = _G[btnName]
      if btn then
        if enable then
          btn:RegisterForDrag("LeftButton")
          btn:SetScript("OnDragStart", function() microFrame:StartMoving() end)
          btn:SetScript("OnDragStop", function() microFrame:StopMovingOrSizing() end)
          btn:SetScript("OnMouseUp", function()
            if IsShiftKeyDown() and IsControlKeyDown() and arg1 == "RightButton" then
              ResetFramePosition("tDFmicrobutton")
            end
          end)
        else
          btn:SetScript("OnDragStart", nil)
          btn:SetScript("OnDragStop", nil)
          btn:SetScript("OnMouseUp", nil)
        end
      end
    end
  end

  -- Bag Bar forwarding
  local bagFrame = _G["tDFbagMain"]
  if bagFrame then
    local bagButtons = {
      "tDFbagMain", "tDFbagKeys", "tDFbagArrow", "tDFbagFreeSlots",
      "MainMenuBarBackpackButton", "CharacterBag0Slot", "CharacterBag1Slot",
      "CharacterBag2Slot", "CharacterBag3Slot", "KeyRingButton"
    }
    for _, bName in pairs(bagButtons) do
      local b = _G[bName]
      if b then
        if enable then
          b:RegisterForDrag("LeftButton")
          b:SetScript("OnDragStart", function() bagFrame:StartMoving() end)
          b:SetScript("OnDragStop", function() bagFrame:StopMovingOrSizing() end)
          b:SetScript("OnMouseUp", function()
            if IsShiftKeyDown() and IsControlKeyDown() and arg1 == "RightButton" then
              ResetFramePosition("tDFbagMain")
            end
          end)
        else
          b:SetScript("OnDragStart", nil)
          b:SetScript("OnDragStop", nil)
          b:SetScript("OnMouseUp", nil)
        end
      end
    end
  end

  -- Main Action Bar Buttons forwarding
  local mainBar = _G["MainMenuBar"]
  if mainBar then
    for i = 1, 12 do
      local ab = _G["ActionButton" .. i]
      local bab = _G["BonusActionButton" .. i]
      if ab then
        if enable then
          ab:RegisterForDrag("LeftButton")
          ab:SetScript("OnDragStart", function() mainBar:StartMoving() end)
          ab:SetScript("OnDragStop", function() mainBar:StopMovingOrSizing() end)
          ab:SetScript("OnMouseUp", function()
            if IsShiftKeyDown() and IsControlKeyDown() and arg1 == "RightButton" then
              ResetFramePosition("MainMenuBar")
            end
          end)
        else
          ab:SetScript("OnDragStart", nil)
          ab:SetScript("OnDragStop", nil)
          ab:SetScript("OnMouseUp", nil)
        end
      end
      if bab then
        if enable then
          bab:RegisterForDrag("LeftButton")
          bab:SetScript("OnDragStart", function() mainBar:StartMoving() end)
          bab:SetScript("OnDragStop", function() mainBar:StopMovingOrSizing() end)
          bab:SetScript("OnMouseUp", function()
            if IsShiftKeyDown() and IsControlKeyDown() and arg1 == "RightButton" then
              ResetFramePosition("MainMenuBar")
            end
          end)
        else
          bab:SetScript("OnDragStart", nil)
          bab:SetScript("OnDragStop", nil)
          bab:SetScript("OnMouseUp", nil)
        end
      end
    end
  end

  -- XP Bar forwarding
  local xp = _G["xpbar"]
  if xp then
    local xpChildren = { xp, xp.leftFrame, xp.rightFrame, xp.status, xp.restedbar }
    for _, c in pairs(xpChildren) do
      if c and c.EnableMouse then
        if enable then
          c:EnableMouse(true)
          c:RegisterForDrag("LeftButton")
          c:SetScript("OnDragStart", function() xp:StartMoving() end)
          c:SetScript("OnDragStop", function() xp:StopMovingOrSizing() end)
          c:SetScript("OnMouseUp", function()
            if IsShiftKeyDown() and IsControlKeyDown() and arg1 == "RightButton" then
              ResetFramePosition("xpbar")
            end
          end)
        else
          c:SetScript("OnDragStart", nil)
          c:SetScript("OnDragStop", nil)
          c:SetScript("OnMouseUp", nil)
        end
      end
    end
  end

  -- Reputation Bar forwarding
  local rep = _G["CustomReputationBar"] or _G["repbar"]
  if rep then
    local repChildren = { rep, rep.leftFrame, rep.rightFrame, rep.repStatusBar }
    for _, c in pairs(repChildren) do
      if c and c.EnableMouse then
        if enable then
          c:EnableMouse(true)
          c:RegisterForDrag("LeftButton")
          c:SetScript("OnDragStart", function() rep:StartMoving() end)
          c:SetScript("OnDragStop", function() rep:StopMovingOrSizing() end)
          c:SetScript("OnMouseUp", function()
            if IsShiftKeyDown() and IsControlKeyDown() and arg1 == "RightButton" then
              ResetFramePosition("CustomReputationBar")
            end
          end)
        else
          c:SetScript("OnDragStart", nil)
          c:SetScript("OnDragStop", nil)
          c:SetScript("OnMouseUp", nil)
        end
      end
    end
  end
end

module.enable = function(self)
  CreateBuffAnchors()

  -- Hook WoW's Buff Update functions to follow our anchors
  local orig_BuffFrame_Update = BuffFrame_Update
  BuffFrame_Update = function()
    if orig_BuffFrame_Update then orig_BuffFrame_Update() end
    UpdateBuffAnchors()
  end

  local orig_BuffButton_Update = BuffButton_Update
  BuffButton_Update = function(buttonName, index, filter)
    if orig_BuffButton_Update then orig_BuffButton_Update(buttonName, index, filter) end
    UpdateBuffAnchors()
  end

  tDFUI_config = tDFUI_config or {}
  tDFUI_config["MoveUnitframesExtended"] = tDFUI_config["MoveUnitframesExtended"] or {}
  movedb = tDFUI_config["MoveUnitframesExtended"]

  local function RestorePositions()
    for frameName, pos in pairs(movedb) do
      local f = _G[frameName]
      if f and pos and pos[1] and pos[2] then
        f:SetMovable(true)
        f:SetUserPlaced(true)
        f:ClearAllPoints()
        f:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", pos[1], pos[2])
      end
    end
    UpdateBuffAnchors()
  end

  local unlocker = CreateFrame("Frame", nil, UIParent)
  unlocker:SetAllPoints(UIParent)

  unlocker.movable = nil
  unlocker:SetScript("OnUpdate", function()
    if IsShiftKeyDown() and IsControlKeyDown() then
      if not unlocker.movable then
        unlocker.movable = true

        for _, frameName in pairs(movables) do
          local f = _G[frameName]
          if f then
            f:SetMovable(true)
            f:SetUserPlaced(true)
            f:EnableMouse(true)
            f:RegisterForDrag("LeftButton")
            f:SetScript("OnDragStart", function() this:StartMoving() end)
            f:SetScript("OnDragStop", function()
              this:StopMovingOrSizing()
              UpdateBuffAnchors()
            end)
            f:SetScript("OnMouseUp", function()
              if IsShiftKeyDown() and IsControlKeyDown() and arg1 == "RightButton" then
                ResetFramePosition(frameName)
              end
            end)
          end
        end

        SetupChildDrags(true)
        UpdateBuffAnchors()
        unlocker.grid:Show()
      end
    elseif unlocker.movable then
      unlocker.movable = nil

      for _, frameName in pairs(movables) do
        local f = _G[frameName]
        if f then
          f:SetScript("OnDragStart", nil)
          f:SetScript("OnDragStop", nil)
          f:SetScript("OnMouseUp", nil)
          f:StopMovingOrSizing()

          if f.GetLeft and f.GetTop and f:GetLeft() and f:GetTop() then
            movedb[frameName] = { f:GetLeft(), f:GetTop() }
          end
        end
      end

      SetupChildDrags(false)
      UpdateBuffAnchors()
      unlocker.grid:Hide()
    end
  end)

  unlocker.grid = CreateFrame("Frame", nil, WorldFrame)
  unlocker.grid:SetAllPoints(WorldFrame)
  unlocker.grid:Hide()

  local size = 1
  local width = GetScreenWidth()
  local height = GetScreenHeight()

  local ratio = width / height
  local rheight = height * ratio

  local wStep = width / 64
  local hStep = rheight / 64

  -- vertical lines
  for i = 0, 64 do
    local line
    if i == 32 then
      line = unlocker.grid:CreateTexture(nil, 'BORDER')
      line:SetTexture(.8, .6, 0)
    else
      line = unlocker.grid:CreateTexture(nil, 'BACKGROUND')
      line:SetTexture(0, 0, 0, .2)
    end
    line:SetPoint("TOPLEFT", unlocker.grid, "TOPLEFT", i*wStep - (size/2), 0)
    line:SetPoint('BOTTOMRIGHT', unlocker.grid, 'BOTTOMLEFT', i*wStep + (size/2), 0)
  end

  -- horizontal lines
  for i = 1, floor(height/hStep) do
    local line
    if i == floor(height/hStep / 2) then
      line = unlocker.grid:CreateTexture(nil, 'BORDER')
      line:SetTexture(.8, .6, 0)
    else
      line = unlocker.grid:CreateTexture(nil, 'BACKGROUND')
      line:SetTexture(0, 0, 0, .2)
    end
    line:SetPoint("TOPLEFT", unlocker.grid, "TOPLEFT", 0, -(i*hStep) + (size/2))
    line:SetPoint('BOTTOMRIGHT', unlocker.grid, 'TOPRIGHT', 0, -(i*hStep + size/2))
  end

  -- Slash commands to reset
  _G.SLASH_TDFRESET1 = "/tdfreset"
  _G.SlashCmdList = _G.SlashCmdList or {}
  _G.SlashCmdList["TDFRESET"] = function(msg)
    if msg and msg ~= "" then
      msg = string.lower(msg)
      for frameName, _ in pairs(default_anchors) do
        if string.find(string.lower(frameName), msg) then
          ResetFramePosition(frameName)
          return
        end
      end
    else
      for frameName, _ in pairs(default_anchors) do
        ResetFramePosition(frameName)
      end
      DEFAULT_CHAT_FRAME:AddMessage("|cff008000[tDF]|r All frame positions have been reset to default.", 1, 1, 0)
    end
  end

  -- Restore saved positions after frames are initialized
  local loader = CreateFrame("Frame")
  loader:RegisterEvent("PLAYER_ENTERING_WORLD")
  loader:SetScript("OnEvent", function()
    RestorePositions()
  end)
  RestorePositions()
end

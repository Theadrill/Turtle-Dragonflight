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
  "BuffFrame",
  "MiniMapMailFrame",
}

local function SetupChildDrags(enable)
  -- Minimap child forwarding
  local minimapParent = _G["MyCustomMinimap"]
  if minimapParent and tMinimap then
    if enable then
      tMinimap:EnableMouse(true)
      tMinimap:RegisterForDrag("LeftButton")
      tMinimap:SetScript("OnDragStart", function() minimapParent:StartMoving() end)
      tMinimap:SetScript("OnDragStop", function() minimapParent:StopMovingOrSizing() end)
    else
      tMinimap:SetScript("OnDragStart", nil)
      tMinimap:SetScript("OnDragStop", nil)
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
        else
          btn:SetScript("OnDragStart", nil)
          btn:SetScript("OnDragStop", nil)
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
        else
          b:SetScript("OnDragStart", nil)
          b:SetScript("OnDragStop", nil)
        end
      end
    end
  end

  -- Buffs forwarding
  local buffFrame = _G["BuffFrame"]
  if buffFrame then
    for i = 0, 23 do
      local bb = _G["BuffButton" .. i]
      if bb then
        if enable then
          bb:RegisterForDrag("LeftButton")
          bb:SetScript("OnDragStart", function() buffFrame:StartMoving() end)
          bb:SetScript("OnDragStop", function() buffFrame:StopMovingOrSizing() end)
        else
          bb:SetScript("OnDragStart", nil)
          bb:SetScript("OnDragStop", nil)
        end
      end
    end
    for i = 1, 2 do
      local te = _G["TempEnchant" .. i]
      if te then
        if enable then
          te:RegisterForDrag("LeftButton")
          te:SetScript("OnDragStart", function() buffFrame:StartMoving() end)
          te:SetScript("OnDragStop", function() buffFrame:StopMovingOrSizing() end)
        else
          te:SetScript("OnDragStart", nil)
          te:SetScript("OnDragStop", nil)
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
        else
          ab:SetScript("OnDragStart", nil)
          ab:SetScript("OnDragStop", nil)
        end
      end
      if bab then
        if enable then
          bab:RegisterForDrag("LeftButton")
          bab:SetScript("OnDragStart", function() mainBar:StartMoving() end)
          bab:SetScript("OnDragStop", function() mainBar:StopMovingOrSizing() end)
        else
          bab:SetScript("OnDragStart", nil)
          bab:SetScript("OnDragStop", nil)
        end
      end
    end
  end
end

module.enable = function(self)
  tDFUI_config = tDFUI_config or {}
  tDFUI_config["MoveUnitframesExtended"] = tDFUI_config["MoveUnitframesExtended"] or {}
  local movedb = tDFUI_config["MoveUnitframesExtended"]

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
            f:SetScript("OnDragStop", function() this:StopMovingOrSizing() end)
          end
        end

        SetupChildDrags(true)
        unlocker.grid:Show()
      end
    elseif unlocker.movable then
      unlocker.movable = nil

      for _, frameName in pairs(movables) do
        local f = _G[frameName]
        if f then
          f:SetScript("OnDragStart", nil)
          f:SetScript("OnDragStop", nil)
          f:StopMovingOrSizing()

          if f.GetLeft and f.GetTop and f:GetLeft() and f:GetTop() then
            movedb[frameName] = { f:GetLeft(), f:GetTop() }
          end
        end
      end

      SetupChildDrags(false)
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

  -- Restore saved positions after frames are initialized
  local loader = CreateFrame("Frame")
  loader:RegisterEvent("PLAYER_ENTERING_WORLD")
  loader:SetScript("OnEvent", function()
    RestorePositions()
  end)
  RestorePositions()
end

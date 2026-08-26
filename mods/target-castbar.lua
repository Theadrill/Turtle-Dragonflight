local _G = tDFUI.GetGlobalEnv()
local T = tDFUI.T
local GetExpansion = tDFUI.GetExpansion
local create_castbar = tDF.utils.create_castbar

local module = tDFUI:register({
    title = T["Enemy Castbars"],
    description = T["Shows an enemy castbar on target unit frame."],
    expansions = { ["vanilla"] = true, ["tbc"] = nil },
    category = T["Unit Frames"],
    enabled = true,
})

local function DisableShaguTargetCastbar()
    if ShaguTargetCastbar then
        ShaguTargetCastbar:UnregisterAllEvents()
        ShaguTargetCastbar:SetScript("OnUpdate", nil)
        ShaguTargetCastbar:Hide()
        ShaguTargetCastbar:SetAlpha(0)
        ShaguTargetCastbar.Show = function() end
    end
end

module.enable = function(self)
    DisableShaguTargetCastbar()

    local castbar = create_castbar("target", "tDFTargetCastbar", TargetFrame, "BOTTOM", -12, -10, 140, 10, 2)
    castbar:SetFrameStrata("HIGH")

    local watcher = CreateFrame("Frame")
    watcher:RegisterEvent("PLAYER_ENTERING_WORLD")
    watcher:SetScript("OnEvent", function()
        DisableShaguTargetCastbar()
    end)
end

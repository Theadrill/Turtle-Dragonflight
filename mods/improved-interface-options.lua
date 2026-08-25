-- Based on zUI skinning (https://github.com/Ko0z/zUI)
-- Credit to Ko0z (https://github.com/Ko0z/)

local T = tDFUI.T
local HookScript = tDFUI.HookScript

local module = tDFUI:register({
    title = T["Improved Interface Options"],
    description = T["Rescales the interface options menu and removes the background."],
    expansions = { ["vanilla"] = true, ["tbc"] = nil },
    enabled = true,
})

module.enable = function(self)
    if UIOptionsFrame then
        HookScript(UIOptionsFrame, "OnShow", function()
            if UIOptionsBlackground then UIOptionsBlackground:Hide() end
            UIOptionsFrame:SetScale(.8)
        end)
    end
end

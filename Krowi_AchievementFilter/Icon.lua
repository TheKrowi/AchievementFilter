local _, addon = ...; -- Global addon namespace

-- Extra options needed for default LibDBIcon behaviour
Krowi_AchievementFilterOptions.Minimap = {
    hide = not Krowi_AchievementFilterOptions.ShowMinimapIcon,
};

 -- Using LibDBIcon instead of creating the icon from scratch is the automatic integration with other addons that also use LibDataBroker
addon.Icon = LibStub("LibDBIcon-1.0"); -- Global icon object
local icon = addon.Icon; -- Local icon object

icon.AchievementFilterLDB = LibStub("LibDataBroker-1.1"):NewDataObject("Krowi_AchievementFilterLDB", {
    type = "launcher",
    label = AF_NAME,
    icon = "Interface\\Icons\\achievement_dungeon_heroic_gloryoftheraider",
    OnClick = function(self, button)
        addon.Diagnostics.Debug("Icon clicked with " .. button);
        if button == "RightButton" then
            addon.Diagnostics.Trace("icon.AchievementFilterLDB.OnClick with RightButton");
            InterfaceAddOnsList_Update(); -- This way the correct category will be shown when calling InterfaceOptionsFrame_OpenToCategory
		    InterfaceOptionsFrame_OpenToCategory(AF_NAME);
	    end
    end,
    OnTooltipShow = function(tt)
        tt:ClearLines();
        tt:AddDoubleLine(AF_NAME, AF_VERSION_BUILD);
        tt:AddLine(" "); -- Empty line
        tt:AddLine(AF_ICON_TOOLTIP_RIGHT_CLICK);
    end,
});

-- Load the icon
function icon.Load()
    Krowi_AchievementFilterOptions.Minimap.hide = not Krowi_AchievementFilterOptions.ShowMinimapIcon;
    icon:Register("Krowi_AchievementFilterLDB", icon.AchievementFilterLDB, Krowi_AchievementFilterOptions.Minimap);
    addon.Diagnostics.Debug("- Icon loaded");
    addon.Diagnostics.Debug("     - " .. AF_OPTIONS_MINIMAP_ICON_TOGGLE .. ": " .. tostring(not Krowi_AchievementFilterOptions.Minimap.hide));
end
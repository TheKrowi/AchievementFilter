-- [[ Namespaces ]] --
local addonName, addon = ...;

-- [[ Ace ]] --
addon.L = LibStub("AceLocale-3.0"):GetLocale(addonName);
addon.Event = {};
LibStub("AceEvent-3.0"):Embed(addon.Event);

-- [[ Binding names ]] --
BINDING_HEADER_AF_NAME = AF_NAME;
BINDING_NAME_AF_OPEN_TAB1 = addon.L["BINDING_NAME_AF_OPEN_TAB1"];

-- [[ Faction data ]] --
addon.Faction = {};
addon.Faction.IsAlliance = UnitFactionGroup("player") == "Alliance";
addon.Faction.IsHorde = UnitFactionGroup("player") == "Horde";
addon.Faction.IsNeutral = UnitFactionGroup("player") == "Neutral";

local loadHelper = CreateFrame("Frame");
loadHelper:RegisterEvent("ADDON_LOADED");

function loadHelper:OnEvent(event, arg1)
    if event == "ADDON_LOADED" then
        if arg1 == "Krowi_AchievementFilter" then -- This always needs to load
            addon.Diagnostics.Load();
            addon.Options.Load();
            addon.Icon.Load();
            addon.Tutorials.Load();

        elseif arg1 == "Blizzard_AchievementUI" then -- This needs the Blizzard_AchievementUI addon available to load
            addon.Data.Load();
            addon.Diagnostics.Debug("- Expansion data loaded");

            local gui = addon.GUI;
            local tutorials = addon.Tutorials;

            gui.SetAchievementFrameHeight(addon.Options.db.AchievementFrameHeightOffset); -- Do this in order to create the correct amount of buttons based on our settings

            gui.AddFrame("AchievementsFrame", gui.AchievementsFrame:New());
            gui.AddFrame("CategoriesFrame", gui.CategoriesFrame:New(addon.Categories, gui.GetFrame("AchievementsFrame")));
            gui.AddFrame("FilterButton", gui.FilterButton:New(gui.GetFrames("CategoriesFrame", "AchievementsFrame")));
            gui.AddFrame("FullSearchResultsFrame", gui.FullSearchResultsFrame:New(gui.GetFrame("AchievementsFrame")));
            gui.AddFrame("SearchPreviewFrame", gui.SearchPreviewFrame:New(gui.GetFrames("FullSearchResultsFrame", "AchievementsFrame")));
            gui.AddFrame("SearchBoxFrame", gui.SearchBoxFrame:New(gui.GetFrames("SearchPreviewFrame", "FullSearchResultsFrame", "AchievementsFrame")));
            gui.AddFrame("TabButton1", gui.AchievementFrameTabButton:New(addon.L["T_TAB_TEXT"], gui.GetFrames("CategoriesFrame", "AchievementsFrame", "FilterButton", "SearchBoxFrame")));

            gui.ResetAchievementFrameHeight();

            tutorials.SetFrames(gui.GetFrames("TabButton1", "CategoriesFrame", "AchievementsFrame", "FilterButton", "SearchBoxFrame", "SearchPreviewFrame", "FullSearchResultsFrame"));
            tutorials.HookTrigger(gui.GetFrame("TabButton1"));
            
            gui.ElvUISkin.Apply(gui.GetFrames("TabButton1", "CategoriesFrame", "AchievementsFrame", "FilterButton", "SearchBoxFrame", "SearchPreviewFrame", "FullSearchResultsFrame"));

            addon.Diagnostics.Debug("- GUI loaded");

        elseif arg1 == "ElvUI" then -- Just in case this addon loads before ElvUI
            addon.GUI.ElvUISkin.Apply(addon.GUI.GetFrames("TabButton1", "CategoriesFrame", "AchievementsFrame", "FilterButton", "SearchBoxFrame", "SearchPreviewFrame", "FullSearchResultsFrame"));
        end
    end
end
loadHelper:SetScript("OnEvent", loadHelper.OnEvent);

function addon.GetAchievement(id)
    addon.Diagnostics.Trace("addon.GetAchievement");

	for _, achievement in next, addon.Achievements do
		if achievement.ID == id then
			return achievement;
		end
	end
end

function addon.InjectMetatable(tbl, meta)
    return setmetatable(tbl, setmetatable(meta, getmetatable(tbl)));
end
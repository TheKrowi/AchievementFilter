local achievementFunctions;

function KrowiAF.AchievementFrameTab_OnClick(id) -- Mimick Blizzard_AchievementUI AchievementFrameBaseTab_OnClick for our own buttons
    KrowiAF.Debug("AchievementFrameTab_OnClick - Tab " .. tostring(id) .. " of " .. tostring(AchievementFrame.numTabs) .. " clicked.");
	AchievementFrame_UpdateTabs(id);

    if IN_GUILD_VIEW then
        AchievementFrame_ToggleView();
    end
    KrowiAF.AchievementFunctions = achievementFunctions;
    KrowiAF.AchievementFunctions.getCategoryList(ACHIEVEMENTUI_CATEGORIES); -- This needs to happen before AchievementFrame_ShowSubFrame (fix for bug 157885)
    AchievementFrame_ShowSubFrame(AchievementFrameAchievements);
    AchievementFrameWaterMark:SetTexture("Interface\\AchievementFrame\\UI-Achievement-AchievementWatermark");
    AchievementFrameCategoriesBG:SetTexCoord(0, 0.5, 0, 1);
    AchievementFrameGuildEmblemLeft:Hide();
    AchievementFrameGuildEmblemRight:Hide();

	KrowiAF.AchievementFrameCategories_Update();
	KrowiAF.AchievementFunctions.updateFunc();

	-- SwitchAchievementSearchTab(tab:GetID()); -- Does not work yet
end

local achievementFrameTab_OnClick = KrowiAF.AchievementFrameTab_OnClick;

function KrowiAF.AchievementFrameComparisonTab_OnClick(id)
	if ( IN_GUILD_VIEW ) then
		AchievementFrame_ToggleView();
		AchievementFrameGuildEmblemLeft:Hide();
		AchievementFrameGuildEmblemRight:Hide();
	end
    -- We don't have support for comparison yet.  Just open up the non-comparison achievement tab.
	AchievementFrameTab_OnClick = AchievementFrameBaseTab_OnClick; -- Also set the other tabs back to their default OnClick
    achievementFrameTab_OnClick = KrowiAF.AchievementFrameTab_OnClick;
    achievementFrameTab_OnClick(id);
	AchievementFrameCategoriesBG:SetTexCoord(0, 0.5, 0, 1);
	AchievementFrameCategories_GetCategoryList(ACHIEVEMENTUI_CATEGORIES);
	AchievementFrameCategories_Update();
	AchievementFrame_UpdateTabs(id);

	KrowiAF.AchievementFunctions.updateFunc();
	-- SwitchAchievementSearchTab(id); -- Does not work yet
end

-- Do this in code instead of an xml template since we're not sure if other addons will also add tabs to the AchievementFrame
-- or if we want to add more ourselves
function KrowiAF.AddNewTab(text, functions)
    local tabID = AchievementFrame.numTabs + 1;
    PanelTemplates_SetNumTabs(AchievementFrame, tabID);
    local tab = CreateFrame("Button", "AchievementFrameTab" .. tabID, AchievementFrame, "AchievementFrameTabButtonTemplate");
    tab:SetID(tabID);
    tab:SetText(text);
    tab:SetScript("OnClick", function(self)
        achievementFrameTab_OnClick(self:GetID());
        PlaySound(SOUNDKIT.IG_CHARACTER_INFO_TAB);
    end);
    achievementFunctions = functions;

    hooksecurefunc("AchievementFrame_UpdateTabs", function(clickedTab)
        if clickedTab == tabID then
            tab.text:SetPoint("CENTER", 0, -5);
        else
            tab.text:SetPoint("CENTER", 0, -3);
        end
    end);
    hooksecurefunc("AchievementFrame_SetTabs", function ()
        tab:SetPoint("LEFT", "AchievementFrameTab" .. tabID - 1, "RIGHT", -5, 0); -- Can break if other addon adds tab with "bad" name
    end);

    hooksecurefunc("AchievementFrame_DisplayComparison", function ()
        achievementFrameTab_OnClick = KrowiAF.AchievementFrameComparisonTab_OnClick;
    end);
end
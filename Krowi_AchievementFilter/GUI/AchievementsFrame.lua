-- [[ Namespaces ]] --
local _, addon = ...;
local diagnostics = addon.Diagnostics;
local gui = addon.GUI;
gui.AchievementsFrame = {};
local achievementsFrame = gui.AchievementsFrame;

local numFrames = 0; -- Local ID for naming, starts at 0 and will increment if a new frame is added

-- [[ Constructors ]] --
achievementsFrame.__index = achievementsFrame; -- Used to support OOP like code
function achievementsFrame:New()
    diagnostics.Trace("achievementsFrame:New");

	-- Increment ID
	numFrames = numFrames + 1;

	-- Create frame
	local frame = CreateFrame("Frame", "KrowiAF_AchievementFrameAchievements" .. numFrames, AchievementFrame, "KrowiAF_AchievementsFrame_Template");
	frame:SetWidth(504);
	addon.InjectMetatable(frame, achievementsFrame);

	-- Set properties
	frame.ID = numFrames;
	frame.SelectedAchievement = nil; -- Issue #6: Fix
	frame.UIFontHeight = nil;

	-- Set parents
	frame.Container.ParentFrame = frame;
	frame.Container.ScrollBar.ParentContainer = frame.Container;

	frame:RegisterEvent("ADDON_LOADED");

	tinsert(ACHIEVEMENTFRAME_SUBFRAMES, frame:GetName());
	frame:Hide();

	frame.Container.ScrollBar.Show = function()
		self.Show_Hide(frame, frame.Container.ScrollBar, getmetatable(frame.Container.ScrollBar).__index.Show, 504, 8);
	end;
	frame.Container.ScrollBar.Hide = function()
		self.Show_Hide(frame, frame.Container.ScrollBar, getmetatable(frame.Container.ScrollBar).__index.Hide, 530, 8);
	end;

	frame.Container.ScrollBar.trackBG:Show();
	frame.Container.update = function(container)
		container.ParentFrame:Update();
	end

	HybridScrollFrame_CreateButtons(frame.Container, "KrowiAF_AchievementButton_Template", 0, -2);
	gui.AchievementButton.PostLoadButtons(frame);

	hooksecurefunc("AchievementFrameAchievements_ForceUpdate", function()
		frame:ForceUpdate();
	end); -- Issue #3: Fix

	if Overachiever then
		Overachiever.UI_HookAchButtons(frame.Container.buttons, frame.Container.ScrollBar); -- Issue #4: Fix - loaded before our addon
	end

	return frame;
end

function KrowiAF_AchievementsFrame_OnEvent(self, event, ...) -- Used in Templates - KrowiAF_AchievementsFrame_Template
	local addonName = ...;
	diagnostics.Trace("KrowiAF_AchievementsFrame_OnEvent - " .. event .. " - " .. addonName);

	if event == "ADDON_LOADED" then
		if addonName and addonName == "Overachiever" then
			Overachiever.UI_HookAchButtons(self.Container.buttons, self.Container.ScrollBar); -- Issue #4: Fix - loaded after our addon
            diagnostics.Debug("Overachiever compatibility enabled");
		end
	end
end

function KrowiAF_AchievementsFrame_OnShow(self) -- Used in Templates - KrowiAF_AchievementsFrame_Template
	diagnostics.Trace("KrowiAF_AchievementsFrame_OnShow");

	self:Update();
end

function achievementsFrame.Show_Hide(frame, self, func, achievementsWidth, achievementsButtonOffset)
	diagnostics.Trace("achievementsFrame.Show_Hide");

	frame:SetWidth(achievementsWidth);
	for _, button in next, frame.Container.buttons do
		button:SetWidth(achievementsWidth - achievementsButtonOffset);
	end
	func(self);
end

local function GetFilteredAchievements(self, category)
	diagnostics.Trace("GetFilteredAchievements");

	local achievements = {};
	if category.Achievements ~= nil then
		-- Filter achievements
		for _, achievement in next, category.Achievements do
			if self.FilterButton and self.FilterButton:Validate(achievement) > 0 then
				tinsert(achievements, achievement);
			end
		end

		-- Sort achievements
		if addon.Options.db.Filters.SortBy.Criteria == addon.L["Default"] then
			diagnostics.Debug("Sort By " .. addon.L["Default"]);
			if addon.Options.db.Filters.SortBy.ReverseSort then
				local tmpTbl = {};
				for i = #achievements, 1, -1 do
					tinsert(tmpTbl, achievements[i]);
				end
				achievements = tmpTbl;
			end
		elseif addon.Options.db.Filters.SortBy.Criteria == addon.L["Name"] then
			diagnostics.Debug("Sort By " .. addon.L["Name"]);
			table.sort(achievements, function(a, b)
				local _, nameA = GetAchievementInfo(a.ID);
				local _, nameB = GetAchievementInfo(b.ID);
				local compare = nameA:lower() < nameB:lower();
				if addon.Options.db.Filters.SortBy.ReverseSort then
					compare = not compare;
				end
				return compare;
			end);
		end
	end

	return achievements;
end

function achievementsFrame:Update()
	diagnostics.Trace("achievementsFrame:Update");

	local category = self.CategoriesFrame.SelectedCategory;
	local scrollFrame = self.Container;

	local offset = HybridScrollFrame_GetOffset(scrollFrame);
	local buttons = scrollFrame.buttons;
	local achievements = GetFilteredAchievements(self, category);
	local numButtons = #buttons;

	local selection = self.SelectedAchievement;
	if selection then
		AchievementFrameAchievementsObjectives:Hide();
	end

	local extraHeight = scrollFrame.largeButtonHeight or ACHIEVEMENTBUTTON_COLLAPSEDHEIGHT

	local achievementIndex;
	local displayedHeight = 0;
	for i = 1, numButtons do
		achievementIndex = i + offset;
		if achievementIndex > #achievements then
			buttons[i]:Hide();
		else
			self:DisplayAchievement(buttons[i], achievements[achievementIndex], achievementIndex, selection);
			displayedHeight = displayedHeight + buttons[i]:GetHeight();
		end
	end

	local totalHeight = #achievements * ACHIEVEMENTBUTTON_COLLAPSEDHEIGHT;
	totalHeight = totalHeight + extraHeight - ACHIEVEMENTBUTTON_COLLAPSEDHEIGHT;

	HybridScrollFrame_Update(scrollFrame, totalHeight, displayedHeight);

	if selection then
		self.SelectedAchievement = selection;
	else
		HybridScrollFrame_CollapseButton(scrollFrame);
	end
end

function achievementsFrame:ForceUpdate(toTop) -- Issue #3: Fix
	diagnostics.Trace("achievementsFrame:ForceUpdate");

	if not self:IsShown() then -- Issue #8: Fix, Issue #10 : Broken
		return;
	end

	if toTop then -- Issue #27: Fix
		self.Container.ScrollBar:SetValue(0);
	end

	-- Issue #8: Broken
	if self.SelectedAchievement then
		local nextID = GetNextAchievement(self.SelectedAchievement.ID);
		local id, _, _, completed = GetAchievementInfo(self.SelectedAchievement.ID);
		if nextID and completed then
			self.SelectedAchievement = nil;
		end
	end
	AchievementFrameAchievementsObjectives:Hide();
	AchievementFrameAchievementsObjectives.id = nil;

	local buttons = self.Container.buttons;
	for _, button in next, buttons do
		button.id = nil;
	end

	self:Update();
end

function achievementsFrame:ClearSelection()
	diagnostics.Trace("achievementsFrame:ClearSelection");

	AchievementFrameAchievementsObjectives:Hide();
	for _, button in next, self.Container.buttons do
		button:Collapse();
		if not button:IsMouseOver() then
			button.highlight:Hide();
		end
		button.selected = nil;
		if not button.tracked:GetChecked() then
			button.tracked:Hide();
		end
		button.description:Show();
		button.hiddenDescription:Hide();
	end

	self.SelectedAchievement = nil;
end

function achievementsFrame:SelectButton(button)
	diagnostics.Trace("achievementsFrame:SelectButton");

	self.SelectedAchievement = button.Achievement;
	button.selected = true;

	SetFocusedAchievement(button.Achievement.ID);
end

function achievementsFrame:FindSelection()
	diagnostics.Trace("achievementsFrame:FindSelection");

	local _, maxVal = self.Container.ScrollBar:GetMinMaxValues();
	local scrollHeight = self.Container:GetHeight();
	local newHeight = 0;
	self.Container.ScrollBar:SetValue(0);
	while true do
		for _, button in next, self.Container.buttons do
			if button.selected then
				newHeight = self.Container.ScrollBar:GetValue() + self.Container:GetTop() - button:GetTop();
				newHeight = min(newHeight, maxVal);
				self.Container.ScrollBar:SetValue(newHeight);
				return;
			end
		end
		if not self.Container.ScrollBar:IsVisible() or self.Container.ScrollBar:GetValue() == maxVal then
			return;
		else
			newHeight = newHeight + scrollHeight;
			newHeight = min(newHeight, maxVal);
			self.Container.ScrollBar:SetValue(newHeight);
		end
	end
end

function achievementsFrame:AdjustSelection()
	diagnostics.Trace("achievementsFrame:AdjustSelection");

	local selectedButton;
	-- check if selection is visible
	for _, button in next, self.Container.buttons do
		if button.selected then
			selectedButton = button;
			break;
		end
	end

	if not selectedButton then
		AchievementFrameAchievements_FindSelection();
	else
		local newHeight;
		if ( selectedButton:GetTop() > self.Container:GetTop() ) then
			newHeight = self.Container.ScrollBar:GetValue() + self.Container:GetTop() - selectedButton:GetTop();
		elseif ( selectedButton:GetBottom() < self.Container:GetBottom() ) then
			if ( selectedButton:GetHeight() > self.Container:GetHeight() ) then
				newHeight = self.Container.ScrollBar:GetValue() + self.Container:GetTop() - selectedButton:GetTop();
			else
				newHeight = self.Container.ScrollBar:GetValue() + self.Container:GetBottom() - selectedButton:GetBottom();
			end
		end
		if newHeight then
			local _, maxVal = self.Container.ScrollBar:GetMinMaxValues();
			newHeight = min(newHeight, maxVal);
			self.Container.ScrollBar:SetValue(newHeight);
		end
	end
end

function achievementsFrame:DisplayAchievement(button, achievement, index, selection, renderOffScreen)
	local id, name, points, completed, month, day, year, description, flags, icon, rewardText, isGuild, wasEarnedByMe, earnedBy = GetAchievementInfo(achievement.ID);
	-- diagnostics.Trace("achievementsFrame.DisplayAchievement for achievement " .. tostring(id));

	if not id then
		button:Hide();
		return;
	else
		button:Show();
	end

	button.index = index;
	button.Achievement = achievement;

	if button.id ~= id then
		local saturatedStyle;
		if bit.band(flags, ACHIEVEMENT_FLAGS_ACCOUNT) == ACHIEVEMENT_FLAGS_ACCOUNT then
			button.accountWide = true;
			saturatedStyle = "account";
		else
			button.accountWide = nil;
			saturatedStyle = "normal";
		end
		button.id = id;
		button.label:SetWidth(ACHIEVEMENTBUTTON_LABELWIDTH);
		button.label:SetText(name);

		if GetPreviousAchievement(id) then
			-- If this is a progressive achievement, show the total score.
			AchievementShield_SetPoints(AchievementButton_GetProgressivePoints(id), button.shield.points, AchievementPointsFont, AchievementPointsFontSmall);
		else
			AchievementShield_SetPoints(points, button.shield.points, AchievementPointsFont, AchievementPointsFontSmall);
		end

		if points > 0 then
			button.shield.icon:SetTexture([[Interface\AchievementFrame\UI-Achievement-Shields]]);
		else
			button.shield.icon:SetTexture([[Interface\AchievementFrame\UI-Achievement-Shields-NoPoints]]);
		end

		if isGuild then
			button.shield.points:Show();
			button.shield.wasEarnedByMe = nil;
			button.shield.earnedBy = nil;
		else
			button.shield.wasEarnedByMe = not (completed and not wasEarnedByMe);
			button.shield.earnedBy = earnedBy;
		end

		button.shield.id = id;
		button.description:SetText(description);
		button.hiddenDescription:SetText(description);
		button.numLines = ceil(button.hiddenDescription:GetHeight() / self.UIFontHeight);
		button.icon.texture:SetTexture(icon);
		if completed or wasEarnedByMe then
			button.completed = true;
			button.dateCompleted:SetText(FormatShortDate(day, month, year));
			button.dateCompleted:Show();
			if button.saturatedStyle ~= saturatedStyle then
				button:Saturate();
			end
		else
			button.completed = nil;
			button.dateCompleted:Hide();
			button:Desaturate();
		end

		if rewardText == "" then
			button.reward:Hide();
			button.rewardBackground:Hide();
		else
			button.reward:SetText(rewardText);
			button.reward:Show();
			button.rewardBackground:Show();
			if button.completed then
				button.rewardBackground:SetVertexColor(1, 1, 1);
			else
				button.rewardBackground:SetVertexColor(0.35, 0.35, 0.35);
			end
		end
	end

	if IsTrackedAchievement(id) then -- Issue #10 : Fix
		button.check:Show();
		button.label:SetWidth(button.label:GetStringWidth() + 4); -- This +4 here is to fudge around any string width issues that arize from resizing a string set to its string width. See bug 144418 for an example.
		button.tracked:SetChecked(true);
		button.tracked:Show();
	else
		button.check:Hide();
		button.tracked:SetChecked(false);
		button.tracked:Hide();
	end

	AchievementButton_UpdatePlusMinusTexture(button);

	if selection and id == selection.ID then
		self.SelectedAchievement = achievement;
		button.selected = true;
		button.highlight:Show();
		local height = AchievementButton_DisplayObjectives(button, button.id, button.completed, renderOffScreen);
		if height == ACHIEVEMENTBUTTON_COLLAPSEDHEIGHT then
			button:Collapse();
		else
			button:Expand(height);
		end
		if not completed or (not wasEarnedByMe and not isGuild) then
			button.tracked:Show();
		end
	elseif button.selected then
		button.selected = nil;
		if not button:IsMouseOver() then
			button.highlight:Hide();
		end
		button:Collapse();
		button.description:Show();
		button.hiddenDescription:Hide();
	end

	return id;
end

-- [[ API ]] --
function achievementsFrame:SelectAchievement(achievement, mouseButton, ignoreModifiers, anchor, offsetX, offsetY)
	diagnostics.Trace("achievementsFrame:SelectAchievement");

	if mouseButton == nil then
		mouseButton = "LeftButton";
	end

	if self.FilterButton then
		self.FilterButton:SetFilters(achievement);
	end

	local category = achievement:GetCategory();

	self.CategoriesFrame:SelectCategory(category);

	local shown = false;
	local previousScrollValue;
	local container = self.Container;
	local child = container.ScrollChild;
	local scrollBar = container.ScrollBar;

	while not shown do
		for _, button in next, container.buttons do
			if button.id == achievement.ID and math.ceil(button:GetTop()) >= math.ceil(gui.GetSafeScrollChildBottom(child)) then
				button:Click(mouseButton, nil, ignoreModifiers, anchor, offsetX, offsetY);
				shown = button;
				break;
			end
		end

		local _, maxVal = scrollBar:GetMinMaxValues();
		if shown then
			local newHeight = scrollBar:GetValue() + container:GetTop() - shown:GetTop();
			newHeight = min(newHeight, maxVal);
			scrollBar:SetValue(newHeight);
		else
			local scrollValue = scrollBar:GetValue();
			if scrollValue == maxVal or scrollValue == previousScrollValue then
				return;
			else
				previousScrollValue = scrollValue;
				HybridScrollFrame_OnMouseWheel(container, -1);
			end
		end
	end
end

function achievementsFrame:SelectAchievementFromID(id, mouseButton, ignoreModifiers, anchor, offsetX, offsetY)
	diagnostics.Trace("achievementsFrame:SelectAchievementFromID");

	local achievement = addon.GetAchievement(id);
	diagnostics.Debug(achievement.ID);
	self:SelectAchievement(achievement, mouseButton, ignoreModifiers, anchor, offsetX, offsetY);
end
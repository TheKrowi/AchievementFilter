local _, addon = ...; -- Global addon namespace
local gui = addon.GUI; -- Local GUI namespace
local diagnostics = addon.Diagnostics; -- Local diagnostics namespace

gui.CategoriesFrame = {}; -- Global categories frame class
local categoriesFrame = gui.CategoriesFrame; -- Local categories frame class

categoriesFrame.__index = categoriesFrame; -- Used to support OOP like code

function categoriesFrame:New(categories, achievementsFrame)
    diagnostics.Trace("categoriesFrame:New");

	local self = {};
    setmetatable(self, categoriesFrame);

	local frame = CreateFrame("Frame", "KrowiAF_AchievementFrameCategories", AchievementFrame, "AchivementGoldBorderBackdrop");
	frame:SetPoint("TOPLEFT", AchievementFrameCategories, "TOPLEFT", 0, 0);
	frame:SetPoint("BOTTOMLEFT", AchievementFrameCategories, "BOTTOMLEFT", 0, 0);
	self.Frame = frame;
	frame.Parent = self;

	local container = CreateFrame("ScrollFrame", "$parentContainer", frame, "HybridScrollFrameTemplate");
	container:SetHeight(AchievementFrameCategoriesContainer:GetHeight());
	container:SetWidth(AchievementFrameCategoriesContainer:GetWidth());
	container:SetPoint("TOPLEFT", 0, -5);
	container:SetPoint("BOTTOMRIGHT", 0, 5);
	frame.Container = container;
	container.ParentFrame = frame;

	local scrollBar = CreateFrame("Slider", "$parentScrollBar", container, "HybridScrollBarTemplate");
	-- scrollBar:SetHeight(AchievementFrameCategoriesContainerScrollBar:GetHeight());
	-- scrollBar:SetWidth(AchievementFrameCategoriesContainerScrollBar:GetWidth());
	scrollBar:SetPoint("TOPLEFT", container, "TOPRIGHT", 1, -14);
	scrollBar:SetPoint("BOTTOMLEFT", container, "BOTTOMRIGHT", 1, 12);
	container.ScrollBar = scrollBar;
	scrollBar.ParentContainer = container;

	-- frame:RegisterEvent("ADDON_LOADED");
	-- frame:SetScript("OnEvent", addon.GUI.CategoriesFrame.OnEvent);
	frame:SetScript("OnShow", self.OnShow);
	frame:SetScript("OnHide", self.OnHide);


	-- diagnostics.Debug(self);
	-- diagnostics.Debug(frame);
	-- diagnostics.Debug(container);
	-- diagnostics.Debug(AchievementFrameCategories:GetHeight());
	-- diagnostics.Debug(frame:GetHeight());
	-- diagnostics.Debug(container:GetHeight());
	-- diagnostics.Debug(scrollBar:GetHeight());

	-- [[ AchievementFrameCategories_OnLoad ]] --
	tinsert(ACHIEVEMENTFRAME_SUBFRAMES, frame:GetName());
	frame:Hide();

	-- [[ AchievementFrameCategories_OnEvent ]] --
	self.Categories = categories;
	self.SelectedCategory = self.Categories[1];
	self.AchievementsFrame = achievementsFrame;
	self.AchievementsFrame.Parent.SelectedCategory = self.SelectedCategory;

	scrollBar.Show = function()
		self.Show_Hide(frame, scrollBar, getmetatable(scrollBar).__index.Show, 175, 22, 30);
	end;
	scrollBar.Hide = function()
		self.Show_Hide(frame, scrollBar, getmetatable(scrollBar).__index.Hide, 197, 0, 30);
	end;

	scrollBar.trackBG:Show();
	container.update = function(container)
		container.ParentFrame.Parent:Update();
	end

	HybridScrollFrame_CreateButtons(container, "KrowiAF_AchievementCategoryTemplate", -4, 0, "TOPRIGHT", "TOPRIGHT", 0, 0, "TOPRIGHT", "BOTTOMRIGHT");
	for _, button in next, container.buttons do
		button.ParentContainer = container;
	end

	-- diagnostics.DebugTable(container.buttons);

	self:Update();

	return self;
end

-- KrowiAF.Categories = {};
-- KrowiAF.SelectedCategory = {};

local UI_CategoriesWidth = 175;

-- addon.GUI.CategoriesFrame:RegisterEvent("ADDON_LOADED");

-- [[ Blizzard_AchievementUI.lua derived OnEvent, OnShow and OnHide functions + Show and Hide the ScrollBar ]] --

	function addon.GUI.CategoriesFrame.OnEvent(self, event, ...) -- OK -- AchievementFrameCategories_OnLoad + AchievementFrameCategories_OnEvent
		if event == "ADDON_LOADED" then
			local addonName = ...;
			addon.Diagnostics.Trace("addon.GUI.CategoriesFrame.OnEvent - " .. event .. " - " .. addonName);

			if addonName and addonName == "Blizzard_AchievementUI" then
				-- [[ OnLoad ]] --
					-- tinsert(ACHIEVEMENTFRAME_SUBFRAMES, self.Frame:GetName());
					-- self:Hide();

				-- [[ OnEvent ]] --
					-- addon.GUI.CategoriesFrame.GetCategoryList(addon.Data, KrowiAF.Categories);
					-- KrowiAF.SelectedCategory = KrowiAF.Categories[1];
					-- KrowiAF.DebugTable(KrowiAF.Categories);

					-- print(self.Frame);

					-- self.Frame.Container.ScrollBar.Show = function(self)
					-- 	self.Show_Hide(self, getmetatable(self).__index.Show, 175, 22, 30);
					-- end;
					-- self.Frame.Container.ScrollBar.Hide = function(self)
					-- 	self.Show_Hide(self, getmetatable(self).__index.Hide, 197, 0, 30);
					-- end;

					-- self.Frame.Container.ScrollBar.trackBG:Show();
					-- self.Frame.Container.update = categoriesFrame.Update;
					-- HybridScrollFrame_CreateButtons(self.Frame.Container, "KrowiAF_AchievementCategoryTemplate", -4, 0, "TOPRIGHT", "TOPRIGHT", 0, 0, "TOPRIGHT", "BOTTOMRIGHT");

					-- self:Update();
			elseif addonName and addonName == "Overachiever_Tabs" then
				for i, subFrameName in next, ACHIEVEMENTFRAME_SUBFRAMES do -- Issue #2: Fix
					if subFrameName == self.Frame:GetName() then
						table.remove(ACHIEVEMENTFRAME_SUBFRAMES, i);
						tinsert(ACHIEVEMENTFRAME_SUBFRAMES, self.Frame:GetName());
					end
				end
			end
		end
	end
	-- addon.GUI.CategoriesFrame:SetScript("OnEvent", addon.GUI.CategoriesFrame.OnEvent);

	function categoriesFrame.OnShow(self) -- OK -- AchievementFrameCategories_OnShow
		addon.Diagnostics.Trace("addon.GUI.CategoriesFrame.OnShow");

		-- First handle the visibility of certain frames
		AchievementFrameCategories:Hide();
		AchievementFrameCategoriesContainer:Hide(); -- Issue #2: Broken
		AchievementFrameCategoriesContainerScrollBar:Hide(); -- Issue #2: Broken
		AchievementFrameFilterDropDown:Hide();
		AchievementFrameHeaderLeftDDLInset:Hide();
		AchievementFrame.searchBox:Hide();
		AchievementFrameHeaderRightDDLInset:Hide();

		AchievementFrameCategoriesBG:SetTexCoord(0, 0.5, 0, 1); -- Set this texture global texture for player achievements

		-- self.Parent:Update();
	end
	-- addon.GUI.CategoriesFrame:SetScript("OnShow", addon.GUI.CategoriesFrame.OnShow);

	function categoriesFrame.OnHide(self) -- OK
		addon.Diagnostics.Trace("addon.GUI.CategoriesFrame.OnHide");

		-- First handle the visibility of certain frames
		AchievementFrameCategories:Show();
		AchievementFrameCategoriesContainer:Show();
		if AchievementFrameAchievements:IsShown() then
			AchievementFrameFilterDropDown:Show();
			AchievementFrameHeaderLeftDDLInset:Show();
		else
			AchievementFrameFilterDropDown:Hide();
			AchievementFrameHeaderLeftDDLInset:Hide();
		end
		AchievementFrame.searchBox:Show();
		AchievementFrameHeaderRightDDLInset:Show();
	end
	-- addon.GUI.CategoriesFrame:SetScript("OnHide", addon.GUI.CategoriesFrame.OnHide);

	function categoriesFrame.Show_Hide(frame, self, func, categoriesWidth, achievementsOffsetX, watermarkWidthOffset) -- OK
		addon.Diagnostics.Trace("addon.GUI.CategoriesFrame.Container.ScrollBar.Show_Hide");

		UI_CategoriesWidth = categoriesWidth;
		-- addon.Diagnostics.Debug(frame:GetName());
		-- addon.Diagnostics.Debug(categoriesWidth);
		frame:SetWidth(categoriesWidth);
		frame.Container:GetScrollChild():SetWidth(categoriesWidth);
		frame.Parent.AchievementsFrame:SetPoint("TOPLEFT", frame, "TOPRIGHT", achievementsOffsetX, 0);
		AchievementFrameWaterMark:SetWidth(categoriesWidth - watermarkWidthOffset);
		AchievementFrameWaterMark:SetTexCoord(0, (categoriesWidth - watermarkWidthOffset)/256, 0, 1);
		for _, button in next, frame.Container.buttons do
			frame.Parent.DisplayButton(button, button.Category);
		end
		func(self);
	end

-- [[ Helper functions ]] --


	
	local function GetAchievementNumbers(category) -- OK -- AchievementFrame_GetCategoryTotalNumAchievements
		-- addon.Diagnostics.Trace("GetAchievementNumbers"); -- Generates a lot of messages

		local numOfAch, numOfCompAch, numOfIncompAch = 0, 0, 0;

		if category.Achievements ~= nil then
			for _, achievement in next, category.Achievements do
				numOfAch = numOfAch + 1;
				local _, _, _, completed = GetAchievementInfo(achievement.ID);
				if completed then
					numOfCompAch = numOfCompAch + 1;
				else
					numOfIncompAch = numOfIncompAch + 1;
				end
			end
		end

		if category.Children ~= nil then
			for _, child in next, category.Children do
				local childNumOfAch, childNumOfCompAch, childNumOfIncompAch = GetAchievementNumbers(child);
				numOfAch = numOfAch + childNumOfAch;
				numOfCompAch = numOfCompAch + childNumOfCompAch;
				numOfIncompAch = numOfIncompAch + childNumOfIncompAch;
			end
		end

		return numOfAch, numOfCompAch, numOfIncompAch;
	end

-- [[ Blizzard_AchievementUI.lua derived ]] --

	function categoriesFrame:Update() -- OK -- AchievementFrameCategories_Update
		addon.Diagnostics.Trace("addon.GUI.CategoriesFrame.Update");

		-- diagnostics.Debug(self);

		local scrollFrame = self.Frame.Container;
		local offset = HybridScrollFrame_GetOffset(scrollFrame);
		local buttons = scrollFrame.buttons;

		local displayCategories = {};
		for i, category in next, self.Categories do
			if not category.Hidden then -- If already visible, keep visible
				tinsert(displayCategories, category);
			end
		end

		local totalHeight = #displayCategories * buttons[1]:GetHeight();
		local displayedHeight = 0;

		local category;
		-- addon.Diagnostics.Debug(#buttons);
		for i = 1, #buttons do
			category = displayCategories[i + offset];
			displayedHeight = displayedHeight + buttons[i]:GetHeight();
			if category then
				self.DisplayButton(buttons[i], category);
				if category == self.SelectedCategory then
					buttons[i]:LockHighlight();
				else
					buttons[i]:UnlockHighlight();
				end
				buttons[i]:Show();
			else
				buttons[i].Category = nil;
				buttons[i]:Hide();
			end
		end

		-- addon.Diagnostics.Trace("HybridScrollFrame_Update");
		-- addon.Diagnostics.Debug(totalHeight);
		-- addon.Diagnostics.Debug(displayedHeight);
		HybridScrollFrame_Update(scrollFrame, totalHeight, displayedHeight);
	end

	function categoriesFrame.DisplayButton(button, category) -- OK -- AchievementFrameCategories_DisplayButton
		-- local catname = "";
		-- if category and category.Name then
		-- 	catname = category.Name;
		-- end
		-- addon.Diagnostics.Trace("addon.GUI.CategoriesFrame.DisplayButton " .. catname); -- Generates a lot of messages

		if not category then
			button.Category = nil;
			button:Hide();
			return;
		end

		button:Show();
		if category.Parent then -- Not top level category has parent
			button:SetWidth(UI_CategoriesWidth - 15 - (category.Level - 1) * 5);
			button.label:SetFontObject("GameFontHighlight");
			button.background:SetVertexColor(0.6, 0.6, 0.6);
		else -- Top level category has no parent
			button:SetWidth(UI_CategoriesWidth - 10);
			button.label:SetFontObject("GameFontNormal");
			button.background:SetVertexColor(1, 1, 1);
		end

		-- if type(category.Name) == "number" then -- Little addition to be able to enter Achievement ID's as names for tabs - no localization needed for these as the game does it (I assume)
		-- 	local _, name = GetAchievementInfo(category.Name);
		-- 	button.label:SetText(name);
		-- else
		button.label:SetText(category.Name);
		-- KrowiAF.Debug(category.Name .. " - " .. tostring(category.Collapsed));
		if category.Children ~= nil and #category.Children ~= 0 then
			if category.Collapsed then
				button.label:SetText("+ " .. category.Name);
			else
				button.label:SetText("- " .. category.Name);
			end
		end
		-- end
		button.Category = category;

		-- For the tooltip
		local numOfAch, numOfCompAch = GetAchievementNumbers(category);
		button.name = category.Name;
		button.text = nil;
		button.numAchievements = numOfAch;
		button.numCompleted = numOfCompAch;
		button.numCompletedText = numOfCompAch.."/"..numOfAch;
		button.showTooltipFunc = AchievementFrameCategory_StatusBarTooltip;
	end

	-- This one is called when you earn an achievement so when you're hovering over a category, the tooltip is updated
	function categoriesFrame.UpdateTooltip() -- OK -- AchievementFrameCategories_UpdateTooltip
		addon.Diagnostics.Trace("addon.GUI.CategoriesFrame.UpdateTooltip");

		local container = addon.GUI.CategoriesFrame.Container;
		if not container:IsVisible() or not container.buttons then
			return;
		end

		for _, button in next, addon.GUI.CategoriesFrame.Container.buttons do
			if button:IsMouseOver() and button.showTooltipFunc then
				button:showTooltipFunc();
				break;
			end
		end
	end

	function categoriesFrame:SelectButton(button) -- OK -- AchievementFrameCategories_SelectButton
		addon.Diagnostics.Trace("addon.GUI.CategoriesFrame.SelectButton");

		if button.IsSelected and not button.Category.Collapsed then -- Collapse selected categories
			button.Category.Collapsed = true;
			for _, category in next, self.Categories do
				if category.Level ~= 0 then -- If 0 = highest level = ignore
					local levels = category.Level - button.Category.Level;
					if levels ~= 0 then -- If 0 = same level = ignore
						local parent = category.Parent;
						while levels > 1 do
							parent = parent.Parent;
							levels = levels - 1;
						end
						if parent == button.Category then
							category.Hidden = true;
						end
					end
				end
			end
		else -- Open selected category, close other highest level categories
			for i, category in next, self.Categories do
				if category.Level == button.Category.Level and category.Parent == button.Category.Parent then -- Category on same level and same parent
					category.Collapsed = true;
				end
				if category.Level > button.Category.Level then -- Category on lower level
					category.Hidden = category.Parent ~= button.Category;
					category.Collapsed = true;
					-- if category.Parent == button.Category then -- Child of
					-- 	category.Hidden = false;
					-- 	category.Collapsed = true;
					-- else -- Not a child of
					-- 	category.Hidden = true;
					-- 	category.Collapsed = true;
					-- end
				end
			end
			button.Category.Collapsed = false;
		end

		local buttons = self.Frame.Container.buttons;
		for _, button in next, buttons do
			button.IsSelected = nil;
		end

		button.IsSelected = true;

		if button.Category == self.SelectedCategory then
			-- If this category was selected already, bail after changing collapsed states
			return
		end

		AchievementFrame_ShowSubFrame(self.Frame, self.AchievementsFrame);
		self.SelectedCategory = button.Category;
		self.AchievementsFrame.Parent.SelectedCategory = self.SelectedCategory; -- should be solved in a better way

		self.AchievementsFrame.Parent:ClearSelection();
		self.AchievementsFrame.Container.ScrollBar:SetValue(0);
		self.AchievementsFrame.Parent:Update();
	end
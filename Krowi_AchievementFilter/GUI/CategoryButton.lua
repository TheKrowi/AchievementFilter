local _, addon = ...;

-- [[ Blizzard_AchievementUI.lua derived ]] --

    -- Used in Templates - KrowiAF_AchievementCategoryTemplate
    function KrowiAF_AchievementCategoryButton_OnClick(button) -- OK -- line 746
        addon.Diagnostics.Trace("KrowiAF_AchievementCategoryButton_OnClick");
        
        addon.GUI.CategoriesFrame.SelectButton(button);
        addon.GUI.CategoriesFrame.Update();
    end
-- [[ Namespaces ]] --
local addonName, addon = ...;
local L = LibStub("AceLocale-3.0"):NewLocale(addonName, "enUS", true, true);

-- Load strings into the localization that are already localized by Blizzard
addon.GlobalStrings.Load(L);

-- Misc.
L["Wowhead"] = "Wowhead";
L["Xu-Fu's Pet Guides"] = "Xu-Fu's Pet Guides";
L["Instance Achievement Tracker"] = "Instance Achievement Tracker";
L["Installed"] = "Installed";
L["Not installed"] = "Not installed";

-- Tab
L["T_TAB_TEXT"] = "Achievement Filter";

-- Categories
L["Zones"] = "Zones";
L["Class Hall"] = "Class Hall";

-- Filters
L["Obtainable"] = "Obtainable";
L["Not Obtainable"] = "Not Obtainable";
L["Covenant"] = "Covenant";
L["Select all"] = "Select all";
L["Reverse Sort"] = "Reverse Sort";

-- Options
L["O_REQUIRES_RELOAD"] = AF_COLOR_ORANGE .. "Requires a reload to take full effect." .. AF_COLOR_END;
L["Build"] = "Build";
L["Author"] = "Author";
L["O_SHOW_MINIMAP_ICON"] = "Show minimap icon";
L["O_SHOW_MINIMAP_ICON_DESC"] = "Show / hide the minimap icon";
L["O_LAYOUT"] = "Layout";
L["O_CATEGORIESFRAME_WIDTH_OFFSET"] = "Categories width offset";
L["O_CATEGORIESFRAME_WIDTH_OFFSET_DESC"] = "The width that will be added to or subtracted from the default categories width.\n\n" ..
                                            "This value can be changed while the achievement window is open while having the {tabName} tab selected. This will however lag your game.\n\n{reloadRequired}";
L["O_ACHIEVEMENTFRAME_HEIGHT_OFFSET"] = "Achievement window height offset";
L["O_ACHIEVEMENTFRAME_HEIGHT_OFFSET_DESC"] = "The height that will be added to or subtracted from the default achievement window height.\n\n" ..
                                                "This value can be changed while the achievement window is open while having the {tabName} tab selected. This will however lag your game.\n\n{reloadRequired}";
L["O_SEARCH"] = "Search";
L["O_CLEAR_SEARCH_ON_RIGHT_CLICK"] = "Clear search field on Right Click";
L["O_CLEAR_SEARCH_ON_RIGHT_CLICK_DESC"] = "Enable / disable the option to clear the search field when Right Clicking in it";
L["O_MIN_CHAR_TO_SEARCH"] = "Minimum characters to search";
L["O_MIN_CHAR_TO_SEARCH_DESC"] = "The number of characters needed in order to start searching for achievements matching the query.\n" ..
                                    "The smaller the number, the greater the impact on the game.";
L["O_NUM_OF_SEARCH_PREVIEWS"] = "Number of search previews";
L["O_NUM_OF_SEARCH_PREVIEWS_DESC"] = "The numbers of achievements shown as a preview of the full list of found achievements.\n\n{reloadRequired}";
L["O_STYLE"] = "ElvUI Skins";
L["O_STYLE_DESC"] = "Each of the options below are controlled by ElvUI and are just informational.\n" ..
                    "To change these, go to Game Menu -> ElvUI -> Skins and check the desired options. See each option below for what to check.";
L["O_SKIN_ACHIEVEMENT"] = "Skin Achievements";
L["O_SKIN_ACHIEVEMENT_DESC"] = "Applies the ElvUI skin to the Achievements Window.\n" ..
                                "-> Blizzard + Achievements";
L["O_SKIN_MISC_FRAMES"] = "Skin Misc Frames";
L["O_SKIN_MISC_FRAMES_DESC"] = "Applies the ElvUI skin to the Filter Menu, Right Click Menu and Popup Dialog.\n" ..
                                "-> Blizzard + Misc Frames";
L["O_SKIN_OPTIONS"] = "Skin Ace3";
L["O_SKIN_OPTIONS_DESC"] = "Applies the ElvUI skin to the Options.\n" ..
                                "-> Ace3";
L["O_SKIN_TUTORIALS"] = "Skin Tutorials";
L["O_SKIN_TUTORIALS_DESC"] = "Applies the ElvUI skin to the Tutorials.\n" ..
                                "-> Blizzard + Tutorials";
L["O_DEBUG"] = "Debug";
L["O_ENABLE_DEBUG_INFO"] = "Enable debug info";
L["O_ENABLE_DEBUG_INFO_DESC"] = "Enable / disable debug info";
L["O_ENABLE_TRACE_INFO"] = "Enable trace info";
L["O_ENABLE_TRACE_INFO_DESC"] = "Enable / disable trace info";

-- Keybindings
L["BINDING_NAME_AF_OPEN_TAB1"] = "Toggle Achievement Window";

-- Icon
L["I_LEFT_CLICK"] = "Left-click " .. AF_COLOR_ADDON .. "to open the Achievement window." .. AF_COLOR_END;
L["I_RIGHT_CLICK"] = "Right-click " .. AF_COLOR_ADDON .. "for Options." .. AF_COLOR_END;

-- Tutorials
-- Features tutorial
L["FT_TABBUTTON_TITLE"] = "New achievements tab";
L["FT_TABBUTTON_DESC"] = "A new achievements tab is added to the achievement window to offer a new way of displaying achievements but in a familiar fashion.";
L["FT_GROUPING_TITLE"] = "New but familiar";
L["FT_GROUPING_DESC"] = "Instead of grouping achievements by type and then by expansion like the default tabs do, " ..
                        "here achievements are first grouped by expansion, then by region like different zones, dungeons, raids, ... " ..
                        "and then by type.";
L["FT_RIGHTCLICKMENU_TITLE"] = "Right-click menu";
L["FT_RIGHTCLICKMENU_DESC"] = "Each achievement in the new tab has a right click menu.\n\n" ..
                                "Features:\n" ..
                                AF_TAB .. "- Link to {wowhead}\n" ..
                                AF_TAB .. "- Link to {xuFuPetGuides} if the achievement is related to Pet Battles and {xuFuPetGuides} has relevant information about it\n" ..
                                AF_TAB .. "- Shortcut to {IAT} if tactics for the achievement are available ({IAT} is {installed})";
L["FT_SEARCHPREVIEW_TITLE"] = "Searching";
L["FT_SEARCHPREVIEW_DESC"] = "Like the default UI, searching achievements is possible in a similar way but it will only search achievements in this tab.\n\n" ..
                                "Additionally, there are a couple of new options:\n" ..
                                AF_TAB .. "- {clearOnRightClick}\n" ..
                                AF_TAB .. "- {minCharToSearch}\n" ..
                                AF_TAB .. "- {numSearchPreviews}\n\n" ..
                                "All options can be found under Game Menu -> Interface -> AddOns -> {addonName}";
L["FT_FULLSEARCH_TITLE"] = "Viewing all search results";
L["FT_FULLSEARCH_DESC"] = "By selecting \"Show All X Results\" (see image previous page) you're able to view all search results.";
L["FT_FILTER_TITLE"] = "Enhanced filtering and sorting";
L["FT_FILTER_DESC"] = "The default filtering of achievements is quite basic with only the option to select All, Earned or Incomplete achievements. Here it's enhanced with\n\n" ..
                        "Filtering (multiple filters can be selected at the same time):\n" ..
                        AF_TAB .. "- {completed}: Show completed achievements\n" ..
                        AF_TAB .. "- {notCompleted}: Show not completed achievements\n" ..
                        AF_TAB .. "- {obtainable}: Show obtainable achievements\n" ..
                        AF_TAB .. "- {notObtainable}: Show not obtainable achievements\n" ..
                        AF_TAB .. "- {faction}\n" ..
                        AF_TAB .. AF_TAB .. "- {neutral}: Show achievements that both Alliance and Horde can earn\n" ..
                        AF_TAB .. AF_TAB .. "- {alliance}: Show achievements only Alliance can earn\n" ..
                        AF_TAB .. AF_TAB .. "- {horde}: Show achievements only Horde can earn\n\n" ..
                        "Sorting:\n" ..
                        AF_TAB .. "- {noSorting}: No sorting applied\n" ..
                        AF_TAB .. "- {sortByName}: Sort achievements based on their names\n" ..
                        AF_TAB .. "- {reverseSort}: When this is selected, invert the order of the sorted achievements\n\n" ..
                        "More filter and sorting options will be added in later versions. Requests possible.";

-- NPC Names
L["Andurs"] = "Andurs"; -- Wowhead npc=105387
L["Rydyr"] = "Rydyr"; -- Wowhead npc=105386
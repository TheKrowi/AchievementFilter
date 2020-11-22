local expansion, raids, raid, dungeons, dungeon;

-- Expansion
expansion = KrowiAF.AchievementCategory:New(GetCategoryInfo(14864)); -- Classic
-- expansion:AddAchievementIDs({}); -- Overarching achievements
tinsert(KrowiAF.Data, expansion);

    -- Raids
        raids = expansion:AddChild(KrowiAF.AchievementCategory:NewRaids());
        raids:AddAchievementIDs({1285}); -- Overarching achievements

        -- 1.1
            raid = raids:AddChild(KrowiAF.AchievementCategory:NewEJ(741)); -- Molten Core
            raid:AddAchievementIDs({686}); -- Defeat the bosses in X

            raid = raids:AddChild(KrowiAF.AchievementCategory:New(EJ_GetInstanceInfo(760) .. " (" .. GetCategoryInfo(15234) .. ")")); -- Onyxia's Lair - revamped in Wrath of the Lish King 3.2
            raid:AddAchievementFOSIDs({684}); -- Defeat the bosses in X

        -- 1.6
            raid = raids:AddChild(KrowiAF.AchievementCategory:NewEJ(742)); -- Blackwing Lair
            raid:AddAchievementIDs({685}); -- Defeat the bosses in X

        -- 1.7
            raid = raids:AddChild(KrowiAF.AchievementCategory:New(EJ_GetInstanceInfo(76) .. " (" .. GetCategoryInfo(15234) .. ")")); -- Zul'Gurub - revamped in Cataclysm 4.1
            raid:AddAchievementFOSIDs({560, 688}); -- Defeat the bosses in X
            raid:AddAchievementFOSIDs({880, 881}); -- Mounts (Unobtainable)

        -- 1.9
            raid = raids:AddChild(KrowiAF.AchievementCategory:NewEJ(743)); -- Ruins of Ahn'Qiraj
            raid:AddAchievementIDs({689}); -- Defeat the bosses in X

            raid = raids:AddChild(KrowiAF.AchievementCategory:NewEJ(744)); -- Temple of Ahn'Qiraj
            raid:AddAchievementIDs({687}); -- Defeat the bosses in X
            raid:AddAchievement(424, KrowiAF.AchievementType.FoS, true); -- Mounts (Obtainable)

    -- Dungeons
        dungeons = expansion:AddChild(KrowiAF.AchievementCategory:NewDungeons());
        dungeons:AddAchievementIDs({1283}); -- Overarching achievements

        -- 1.0
            dungeon = dungeons:AddChild(KrowiAF.AchievementCategory:NewEJ(63)); -- Deadmines - revamped in Cataclysm 4.0
            dungeon:AddAchievementIDs({5366, 5367, 5368, 5369, 5370, 5371}); -- Glory of the Cataclysm Hero
            dungeon:AddAchievementIDs({628, 5083}); -- Defeat the bosses in X

            dungeon = dungeons:AddChild(KrowiAF.AchievementCategory:NewEJ(226)); -- Ragefire Chasm
            dungeon:AddAchievementIDs({629}); -- Defeat the bosses in X

            dungeon = dungeons:AddChild(KrowiAF.AchievementCategory:NewEJ(240)); -- Wailing Caverns
            dungeon:AddAchievementIDs({630}); -- Defeat the bosses in X

            dungeon = dungeons:AddChild(KrowiAF.AchievementCategory:NewEJ(64)); -- Shadowfang Keep - revamped in Cataclysm 4.0
            dungeon:AddAchievementIDs({5503, 5504, 5505}); -- Glory of the Cataclysm Hero
            dungeon:AddAchievementIDs({631, 5093}); -- Defeat the bosses in X

            dungeon = dungeons:AddChild(KrowiAF.AchievementCategory:NewEJ(227)); -- Blackfathom Deeps
            dungeon:AddAchievementIDs({632}); -- Defeat the bosses in X

            dungeon = dungeons:AddChild(KrowiAF.AchievementCategory:NewEJ(238)); -- The Stockade
            dungeon:AddAchievementIDs({633}); -- Defeat the bosses in X

            dungeon = dungeons:AddChild(KrowiAF.AchievementCategory:NewEJ(231)); -- Gnomeregan
            dungeon:AddAchievementIDs({634}); -- Defeat the bosses in X

            dungeon = dungeons:AddChild(KrowiAF.AchievementCategory:NewEJ(233)); -- Razorfen Kraul
            dungeon:AddAchievementIDs({635}); -- Defeat the bosses in X

            dungeon = dungeons:AddChild(KrowiAF.AchievementCategory:NewEJ(234)); -- Razorfen Downs
            dungeon:AddAchievementIDs({636}); -- Defeat the bosses in X

            dungeon = dungeons:AddChild(KrowiAF.AchievementCategory:NewEJ(311)); -- Scarlet Halls - revamped in Mists of Pandaria 5.0
            dungeon:AddAchievementIDs({6684, 6427}); -- Glory of the Pandaria Hero
            dungeon:AddAchievementIDs({7413, 6760}); -- Defeat the bosses in X
            dungeon:AddAchievementFOSIDs({6895, 6908, 6909, 6910, 8436}); -- Challenge mode

            dungeon = dungeons:AddChild(KrowiAF.AchievementCategory:NewEJ(316)); -- Scarlet Monastery - revamped in Mists of Pandaria 5.0
            dungeon:AddAchievementIDs({6946, 6928, 6929}); -- Glory of the Pandaria Hero
            dungeon:AddAchievementIDs({637, 6761}); -- Defeat the bosses in X
            dungeon:AddAchievementFOSIDs({6896, 6911, 6912, 6913, 8437}); -- Challenge mode

            dungeon = dungeons:AddChild(KrowiAF.AchievementCategory:NewEJ(239)); -- Uldaman
            dungeon:AddAchievementIDs({638}); -- Defeat the bosses in X

            dungeon = dungeons:AddChild(KrowiAF.AchievementCategory:NewEJ(241)); -- Zul'Farrak
            dungeon:AddAchievementIDs({639}); -- Defeat the bosses in X

            dungeon = dungeons:AddChild(KrowiAF.AchievementCategory:NewEJ(232)); -- Maraudon
            dungeon:AddAchievementIDs({640}); -- Defeat the bosses in X

            dungeon = dungeons:AddChild(KrowiAF.AchievementCategory:NewEJ(237)); -- The Temple of Atal'hakkar
            dungeon:AddAchievementIDs({641}); -- Defeat the bosses in X

            dungeon = dungeons:AddChild(KrowiAF.AchievementCategory:NewEJ(228)); -- Blackrock Depths
            dungeon:AddAchievementIDs({642}); -- Defeat the bosses in X

            dungeon = dungeons:AddChild(KrowiAF.AchievementCategory:NewEJ(229)); -- Lower Blackrock Spire
            dungeon:AddAchievementIDs({643}); -- Defeat the bosses in X

            dungeon = dungeons:AddChild(KrowiAF.AchievementCategory:NewEJ(230)); -- Dire Maul
            dungeon:AddAchievementIDs({644}); -- Defeat the bosses in X

            dungeon = dungeons:AddChild(KrowiAF.AchievementCategory:NewEJ(246)); -- Scholomance - revamped in Mists of Pandaria 5.0
            dungeon:AddAchievementIDs({6531, 6394, 6396, 6715, 6821}); -- Glory of the Pandaria Hero
            dungeon:AddAchievementIDs({645, 6762}); -- Defeat the bosses in X
            dungeon:AddAchievementFOSIDs({6897, 6914, 6915, 6916, 8438}); -- Challenge mode

            dungeon = dungeons:AddChild(KrowiAF.AchievementCategory:NewEJ(236)); -- Stratholme
            dungeon:AddAchievementIDs({646}); -- Defeat the bosses in X
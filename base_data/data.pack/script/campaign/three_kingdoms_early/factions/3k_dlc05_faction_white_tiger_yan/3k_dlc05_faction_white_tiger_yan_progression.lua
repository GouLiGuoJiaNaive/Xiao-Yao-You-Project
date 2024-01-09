-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
------------------------ White Tiger Yan Progression Missions -----------------
-------------------------------------------------------------------------------
------------------------ Created by Craig: 27/08/2019 -------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

output("Progression mission script loaded for " .. cm:get_local_faction());

-- OWN_N_REGIONS_INCLUDING
-- CAPTURE_REGIONS
-- CONTROL_N_PROVINCES_INCLUDING
-- CONTROL_N_REGIONS_INCLUDING
-- BE_AT_WAR_WITH_N_FACTIONS       -- db, total, faction_record, religion_record
-- BE_AT_WAR_WITH_FACTION          -- db, faction_record
-- CONFEDERATE_FACTIONS             -- db, total, faction_record

-- start the progression missions
core:add_listener(
    "start_progression_missions",
    "ScriptEventYanBaihuIntroductionMission05Complete",
    true,
    function()
        core:trigger_event("ScriptEventYanBaihuProgressionMission01Trigger")
    end,
    false
)

-- white tiger yan progression mission 1
start_progression_mission_listener(
    "3k_dlc05_faction_white_tiger_yan",                          -- faction key
    "3k_main_victory_objective_chain_1_yan_baihu",                     -- mission key
    "ATTAIN_FACTION_PROGRESSION_LEVEL",                                  -- objective type
    {
        "total 3"
    },                                                  -- conditions (single string or table of strings)
    {
        "money 2000"
    },                                                  -- mission rewards (table of strings)
    "ScriptEventYanBaihuProgressionMission01Trigger",      -- trigger event 
    "ScriptEventYanBaihuProgressionMission01Complete"     -- completion event
)

-- white tiger yan progression mission 02
start_progression_mission_listener(
    "3k_dlc05_faction_white_tiger_yan",                          -- faction key
    "3k_main_victory_objective_chain_2_outlaws",                    -- mission key
    "BECOME_WORLD_LEADER",                                  -- objective type
    nil,                                                    -- conditions (single string or table of strings)
    {
        "money 5000"
    },                                                  -- mission rewards (table of strings)
    "ScriptEventYanBaihuProgressionMission01Complete",      -- trigger event 
    "ScriptEventYanBaihuProgressionMission02Complete"      -- completion event
)

-- white tiger yan progression mission 03
start_progression_mission_listener(
    "3k_dlc05_faction_white_tiger_yan",                          -- faction key
    "3k_main_victory_objective_chain_3_outlaws",                     -- mission key
    "DESTROY_ALL_WORLD_LEADERS",                                  -- objective type
    nil,                                                -- conditions (single string or table of strings)
    {
        "money 10000"
    },                                                  -- mission rewards (table of strings)
    "ScriptEventYanBaihuProgressionMission02Complete",      -- trigger event 
    "ScriptEventYanBaihuProgressionMission03Complete"     -- completion event
)

-- white tiger yan progression mission 04
start_progression_mission_listener(
    "3k_dlc05_faction_white_tiger_yan",                          -- faction key
    "3k_main_victory_objective_chain_4",                     -- mission key
    "CONTROL_N_REGIONS_INCLUDING",                                  -- objective type
    {
        "total 95"
    }, 
    {
        "money 15000"
    },                                                  -- mission rewards (table of strings)
    "ScriptEventYanBaihuProgressionMission03Complete",      -- trigger event 
    ""
)
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
------------------------ Tao Qian Progression Missions ------------------------
-------------------------------------------------------------------------------
------------------------ Created by Jakob: 23/08/2019 -------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

output("Progression mission script loaded for " .. cm:get_local_faction());

core:add_listener(
    "start_progression_missions",
    "ScriptEventTaoQianIntroductionMission06Complete",
    true,
    function()
        core:trigger_event("ScriptEventTaoQianProgressionMission01Trigger")
    end,
    false
)

-- liu bei progression mission 1
start_progression_mission_listener(
    "3k_main_faction_tao_qian",                          -- faction key
    "3k_main_victory_objective_chain_1_tao_qian",                     -- mission key
    "ATTAIN_FACTION_PROGRESSION_LEVEL",                                  -- objective type
    {
        "rank_duke"
    },                                                  -- conditions (single string or table of strings)
    {
        "money 2000"
    },                                                  -- mission rewards (table of strings)
    "ScriptEventTaoQianProgressionMission01Trigger",      -- trigger event 
    "ScriptEventTaoQianProgressionMission01Complete"     -- completion event
)

-- liu bei progression mission 02
start_progression_mission_listener(
    "3k_main_faction_tao_qian",                          -- faction key
    "3k_main_victory_objective_chain_2_han_warlords",                    -- mission key
    "BECOME_WORLD_LEADER",                                  -- objective type
    nil,                                                    -- conditions (single string or table of strings)
    {
        "money 5000"
    },                                                  -- mission rewards (table of strings)
    "ScriptEventTaoQianProgressionMission01Complete",      -- trigger event 
    "ScriptEventTaoQianProgressionMission02Complete"      -- completion event
)

-- liu bei progression mission 03
start_progression_mission_listener(
    "3k_main_faction_tao_qian",                          -- faction key
    "3k_main_victory_objective_chain_3_han",                     -- mission key
    "DESTROY_ALL_WORLD_LEADERS",                                  -- objective type
    nil,                                                -- conditions (single string or table of strings)
    {
        "money 10000"
    },                                                  -- mission rewards (table of strings)
    "ScriptEventTaoQianProgressionMission02Complete",      -- trigger event 
    "ScriptEventTaoQianProgressionMission03Complete"     -- completion event
)

-- liu bei progression mission 04
start_progression_mission_listener(
    "3k_main_faction_tao_qian",                          -- faction key
    "3k_main_victory_objective_chain_4",                     -- mission key
    "CONTROL_N_REGIONS_INCLUDING",                                  -- objective type
    {
        "total 95"
    }, 
    {
        "money 10000"
    },                                                  -- mission rewards (table of strings)
    "ScriptEventTaoQianProgressionMission03Complete",      -- trigger event 
    "ScriptEventTaoQianProgressionMissionsCompleted"
)

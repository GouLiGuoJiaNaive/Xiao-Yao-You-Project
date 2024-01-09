-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
------------------------- yuan shu Historical Missions -------------------------
-------------------------------------------------------------------------------
------------------------- Created by Nic: 04/09/2018 --------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

output("Historical mission script loaded for " .. cm:get_local_faction());

-- start the historical missions
if not cm:get_saved_value("historical_mission_launched") then
    core:add_listener(
        "start_historical_missions",
        "ScriptEventLocalPlayerFactionTurnStart",
        function(context)
            return context:faction():region_list():num_items() >= 3
        end,
        function()
            core:trigger_event("ScriptEventYuanShuHistoricalMission01Trigger")
            core:remove_listener("start_historical_missions");
            cm:set_saved_value("historical_mission_launched", true);
        end,
        false
    )
end


-- yuan shu historical mission 01a
start_historical_mission_listener(
    "3k_main_faction_yuan_shu",                          -- faction key
    "3k_dlc05_objective_yuan_shu_01a",                     -- mission key
    "CONSTRUCT_ANY_BUILDING",                                  -- objective type
    {
        "region 3k_main_yangzhou_capital"                  -- conditions (single string or table of strings)
    },                                                  
    {
        "effect_bundle{bundle_key 3k_main_introduction_mission_payload_capture_regions;turns 3;}"
    },                                                  -- mission rewards (table of strings)
    "ScriptEventStartTutorialMissions",      -- trigger event 
	"ScriptEventYuanShuHistoricalMission01aComplete",     -- completion event
	nil,
	"ScriptEventYuanShuHistoricalMission01aComplete",
	nil,
	25
)
--[[
-- yuan shu historical mission 01
start_historical_mission_listener(
    "3k_main_faction_yuan_shu",                          -- faction key
    "3k_dlc05_objective_yuan_shu_01",                     -- mission key
    "OWN_N_UNITS",                                  -- objective type
    {
        2       -- special case, just supply the number of units we want the player to recruit
    },                                                  -- conditions (single string or table of strings)
    {
        "effect_bundle{bundle_key 3k_main_introduction_mission_payload_recruit_units;turns 3;}"
    },                                                  -- mission rewards (table of strings)
    "ScriptEventStartTutorialMissions",      -- trigger event 
    "ScriptEventYuanShuHistoricalMission01Complete"     -- completion event
)
]]--

-- yuan shu historical mission 01
start_historical_mission_listener(
    "3k_main_faction_yuan_shu",                          -- faction key
    "3k_dlc05_objective_yuan_shu_01",                     -- mission key
    "DESTROY_FACTION",                                  -- objective type
    {
        "faction 3k_dlc04_faction_prince_liu_chong"
    },                                                  -- conditions (single string or table of strings)
    {
        "effect_bundle{bundle_key 3k_main_historical_mission_payload_02;turns 5;}"
    },                                                  -- mission rewards (table of strings)
    "ScriptEventYuanShuHistoricalMission01aComplete",      -- trigger event 
    "ScriptEventYuanShuHistoricalMission01Complete",     -- completion event
    function()
        if not cm:query_faction("3k_dlc04_faction_prince_liu_chong"):is_dead() then
            return true
        end
    end,--    -- precondition (nil, or a function that returns a boolean)                                               
	"ScriptEventYuanShuHistoricalMission01Complete",       -- failure event
	nil,
	25
)

-- yuan shu historical mission 02
start_historical_mission_listener(
    "3k_main_faction_yuan_shu",                          -- faction key
    "3k_dlc05_objective_yuan_shu_02",                    -- mission key
    "CONTROL_N_REGIONS_INCLUDING",                                  -- objective type
    {
        "total 5",
        "region 3k_main_donghai_capital",
        "region 3k_main_donghai_resource_1"
    },                                                  -- conditions (single string or table of strings)
    {
        "effect_bundle{bundle_key 3k_main_historical_mission_payload_02;turns 5;}"
    },                                                  -- mission rewards (table of strings)
    "ScriptEventYuanShuHistoricalMission01Complete",      -- trigger event 
	"ScriptEventYuanShuHistoricalMission02Complete",      -- completion event
	nil,
	"ScriptEventYuanShuHistoricalMission02Complete",
	nil,
	25
)

-- yuan shu historical mission 03
start_historical_mission_listener(
    "3k_main_faction_yuan_shu",                          -- faction key
    "3k_dlc05_objective_yuan_shu_03",                    -- mission key
    "MAKE_ALLIANCE",                                  -- objective type
    {
        "faction 3k_main_faction_lu_bu"
    },                                                  -- conditions (single string or table of strings)
    {
        "effect_bundle{bundle_key 3k_main_historical_mission_payload_04;turns 5;}"
    },                                                  -- mission rewards (table of strings)
    "ScriptEventYuanShuHistoricalMission02Complete",      -- trigger event 
    "ScriptEventYuanShuHistoricalMission03Complete",     -- completion event
    function()
        if not cm:query_faction("3k_main_faction_lu_bu"):is_dead() then
            return true
        end
    end,                                                -- precondition (nil, or a function that returns a boolean)
	"ScriptEventYuanShuHistoricalMission03Complete",       -- failure event
	nil,
	25
)

-- yuan shu historical mission 04
start_historical_mission_listener(
    "3k_main_faction_yuan_shu",                          -- faction key
    "3k_dlc05_objective_yuan_shu_04",                     -- mission key
    "DESTROY_FACTION",                                  -- objective type
    {
        "faction 3k_main_faction_cao_cao"
    },                                                  -- conditions (single string or table of strings)
    {
        "effect_bundle{bundle_key 3k_main_historical_mission_payload_04;turns 5;}"
    },                                                  -- mission rewards (table of strings)
    "ScriptEventYuanShuHistoricalMission03Complete",      -- trigger event 
    "ScriptEventYuanShuHistoricalMission04Complete",     -- completion event
    function()
        if not cm:query_faction("3k_main_faction_cao_cao"):is_dead() then
            return true
        end
    end,                                                -- precondition (nil, or a function that returns a boolean)
	"ScriptEventYuanShuHistoricalMission04Complete",       -- failure event
	nil,
	25
)
-- yuan shu historical mission 05
start_historical_mission_listener(
    "3k_main_faction_yuan_shu",                          -- faction key
    "3k_dlc05_objective_yuan_shu_05",                     -- mission key
    "DESTROY_FACTION",                                  -- objective type
    {
        "faction 3k_main_faction_yuan_shao"
    },                                                  -- conditions (single string or table of strings)
    {
        "effect_bundle{bundle_key 3k_main_historical_mission_payload_04;turns 5;}"
    },                                                  -- mission rewards (table of strings)
    "ScriptEventYuanShuHistoricalMission04Complete",      -- trigger event 
    "ScriptEventYuanShuHistoricalMission05Complete",     -- completion event
    function()
        if not cm:query_faction("3k_main_faction_yuan_shao"):is_dead() then
            return true
        end
    end,                                                -- precondition (nil, or a function that returns a boolean)
	"ScriptEventYuanShuHistoricalMission05Complete",       -- failure event
	nil,
	25
)
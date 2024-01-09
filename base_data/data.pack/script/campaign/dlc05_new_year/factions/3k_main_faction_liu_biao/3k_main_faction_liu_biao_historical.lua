-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
------------------------- Liu Biao Historical Missions -------------------------
-------------------------------------------------------------------------------
------------------------- Created by Matt: 29/08/2019 --------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

output("Historical mission script loaded for " .. cm:get_local_faction());

-- start the historical missions

--[[if not cm:get_saved_value("historical_mission_launched") then  
    core:add_listener(
        "start_historical_missions",
        "ScriptEventLocalPlayerFactionTurnStart",
        function(context)
            return context:faction():region_list():num_items() >= 8
        end,
        function()
            core:trigger_event("ScriptEventLiuBiaoHistoricalMission01Trigger")
            core:remove_listener("start_historical_missions");
            cm:set_saved_value("historical_mission_launched", true);
        end,
        false
    )
end]]


-- Changed the trigger event for the first mission to play off of Liu Biao's second tutorial mission. This is as he doesn't take territory in the early campaign.


-- liu biao historical mission 01
start_historical_mission_listener(
    "3k_main_faction_liu_biao",                          -- faction key
    "3k_dlc05_objective_liu_biao_01",                     -- mission key
    "DESTROY_FACTION",                                  -- objective type
    {
        "faction 3k_main_faction_yellow_turban_rebels"
    },                                                  -- conditions (single string or table of strings)
    {
        "effect_bundle{bundle_key 3k_main_historical_mission_payload_01;turns 5;}"
    },                                                  -- mission rewards (table of strings)
    "ScriptEventLiuBiaoIntroductionMission02Complete",      -- trigger event 
    "ScriptEventLiuBiaoHistoricalMission01Complete",     -- completion event
    function()
        if not cm:query_faction("3k_main_faction_yellow_turban_rebels"):is_dead() then
            return true
        end
    end,                                                -- precondition (nil, or a function that returns a boolean)
	"ScriptEventLiuBiaoHistoricalMission01Failure",       -- failure event
	nil,
	25
)

-- liu biao historical mission 01a
start_historical_mission_listener(
    "3k_main_faction_liu_biao",                          -- faction key
    "3k_dlc05_objective_liu_biao_01a",                    -- mission key
    "CONTROL_N_REGIONS_INCLUDING",                                  -- objective type
    {
        "total 1",
        "region 3k_main_runan_capital"
    },                                                  -- conditions (single string or table of strings)
    {
        "effect_bundle{bundle_key 3k_main_historical_mission_payload_01;turns 5;}"
    },                                                  -- mission rewards (table of strings)
    "ScriptEventLiuBiaoHistoricalMission01Failure",      -- trigger event 
	"ScriptEventLiuBiaoHistoricalMission01Complete",      -- completion event
	nil,
	"ScriptEventLiuBiaoHistoricalMission01Complete",
	nil,
	25
)

-- liu biao historical mission 02
start_historical_mission_listener(
    "3k_main_faction_liu_biao",                          -- faction key
    "3k_dlc05_objective_liu_biao_02",                     -- mission key
    "DESTROY_FACTION",                                  -- objective type
    {
        "faction 3k_main_faction_yuan_shu"
    },                                                  -- conditions (single string or table of strings)
    {
        "effect_bundle{bundle_key 3k_main_historical_mission_payload_02;turns 5;}"
    },                                                  -- mission rewards (table of strings)
    "ScriptEventLiuBiaoHistoricalMission01Complete",      -- trigger event 
    "ScriptEventLiuBiaoHistoricalMission02Complete",     -- completion event
    function()
        if not cm:query_faction("3k_main_faction_yuan_shu"):is_dead() then
            return true
        end
    end,                                                -- precondition (nil, or a function that returns a boolean)
	"ScriptEventLiuBiaoHistoricalMission02Failure",       -- failure event
	nil,
	25
)

-- liu biao historical mission 02a
start_historical_mission_listener(
    "3k_main_faction_liu_biao",                          -- faction key
    "3k_dlc05_objective_liu_biao_02a",                    -- mission key
    "CONTROL_N_REGIONS_INCLUDING",                                  -- objective type
    {
        "total 1",
        "region 3k_main_yangzhou_capital"
    },                                                  -- conditions (single string or table of strings)
    {
        "effect_bundle{bundle_key 3k_main_historical_mission_payload_02;turns 5;}"
    },                                                  -- mission rewards (table of strings)
    "ScriptEventLiuBiaoHistoricalMission02Failure",      -- trigger event 
	"ScriptEventLiuBiaoHistoricalMission02Complete",      -- completion event
	nil,
	"ScriptEventLiuBiaoHistoricalMission02Complete",
	nil,
	25
)

-- liu biao historical mission 03
start_historical_mission_listener(
    "3k_main_faction_liu_biao",                          -- faction key
    "3k_main_objective_liu_biao_03",                     -- mission key
    "MAKE_ALLIANCE",                                  -- objective type
    {
        "faction 3k_main_faction_liu_bei"
    },                                                  -- conditions (single string or table of strings)
    {
        "effect_bundle{bundle_key 3k_main_historical_mission_payload_03;turns 5;}"
    },                                                  -- mission rewards (table of strings)
    "ScriptEventLiuBiaoHistoricalMission02Complete",      -- trigger event 
    "ScriptEventLiuBiaoHistoricalMission03Complete",     -- completion event
    function()
        if not cm:query_faction("3k_main_faction_liu_bei"):is_dead() then
            return true
        end
    end,                                                -- precondition (nil, or a function that returns a boolean)
	"ScriptEventLiuBiaoHistoricalMission03Failure",       -- failure event
	nil,
	25
)

-- liu biao historical mission 03a
start_historical_mission_listener(
    "3k_main_faction_liu_biao",                          -- faction key
    "3k_main_objective_liu_biao_03a",                    -- mission key
    "MAKE_ALLIANCE",                                  -- objective type
    {
        "any_faction true"
    },                                                  -- conditions (single string or table of strings)
    {
        "effect_bundle{bundle_key 3k_main_historical_mission_payload_03;turns 5;}"
    },                                                  -- mission rewards (table of strings)
    "ScriptEventLiuBiaoHistoricalMission03Failure",      -- trigger event 
	"ScriptEventLiuBiaoHistoricalMission03Complete",      -- completion event
	nil,
	"ScriptEventLiuBiaoHistoricalMission03Complete",
	nil,
	25
)

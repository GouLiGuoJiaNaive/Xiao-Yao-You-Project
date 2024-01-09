-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
------------------------- Gongsun Zan Historical Missions -------------------------
-------------------------------------------------------------------------------
------------------------- Created by Nic: 04/09/2018 --------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

output("Historical mission script loaded for " .. cm:get_local_faction());

-- start the historical missions
if not cm:get_saved_value("historical_mission_launched") then
    core:add_listener(
        "start_historical_missions",
        "ScriptEventGongsunZanIntroductionMission01Complete",
        true,
        function()
            core:trigger_event("ScriptEventGongsunZanHistoricalMission01Trigger")
            core:remove_listener("start_historical_missions");
            cm:set_saved_value("historical_mission_launched", true);
        end,
        false
    )
end


-- gongsun zan historical mission 01
start_historical_mission_listener(
    "3k_main_faction_gongsun_zan",                          -- faction key
    "3k_dlc05_objective_gongsun_zan_02",                     -- mission key
    "DESTROY_FACTION",                                  -- objective type
    {
        "faction 3k_main_faction_youzhou"
    },                                                  -- conditions (single string or table of strings)
    {
        "effect_bundle{bundle_key 3k_main_historical_mission_payload_01;turns 5;}"
    },                                                  -- mission rewards (table of strings)
    "ScriptEventGongsunZanHistoricalMission01Trigger",      -- trigger event 
    "ScriptEventGongsunZanHistoricalMission01Complete",     -- completion event
    function()
        if not cm:query_faction("3k_main_faction_youzhou"):is_dead() then
            return true
        end
    end,                                                -- precondition (nil, or a function that returns a boolean)
	"ScriptEventGongsunZanHistoricalMission01Complete",       -- failure event
	nil,
	25
)


-- gongsun zan historical mission 02
start_historical_mission_listener(
    "3k_main_faction_gongsun_zan",                          -- faction key
    "3k_dlc05_objective_gongsun_zan_01",                    -- mission key
    "MAKE_ALLIANCE",                                  -- objective type
    {
        "faction 3k_main_faction_zhang_yan"
    },                                                  -- conditions (single string or table of strings)
    {
        "effect_bundle{bundle_key 3k_main_historical_mission_payload_01;turns 5;}"
    },                                                  -- mission rewards (table of strings)
    "ScriptEventGongsunZanHistoricalMission01Complete",      -- trigger event 
	"ScriptEventGongsunZanHistoricalMission02Complete",      -- completion event
	nil,
	"ScriptEventGongsunZanHistoricalMission02Complete",
	nil,
	25
)

-- gongsun zan historical mission 03
start_historical_mission_listener(
    "3k_main_faction_gongsun_zan",                          -- faction key
    "3k_main_objective_gongsun_zan_02",                     -- mission key
    "DESTROY_FACTION",                                  -- objective type
    {
        "faction 3k_main_faction_yuan_shao"
    },                                                  -- conditions (single string or table of strings)
    {
        "effect_bundle{bundle_key 3k_main_historical_mission_payload_02;turns 5;}"
    },                                                  -- mission rewards (table of strings)
    "ScriptEventGongsunZanHistoricalMission02Complete",      -- trigger event 
    "ScriptEventGongsunZanHistoricalMission03Complete",     -- completion event
    function()
        if not cm:query_faction("3k_main_faction_yuan_shao"):is_dead() then
            return true
        end
    end,
	"ScriptEventGongsunZanHistoricalMission02Failure",
	nil,
	25
)

-- gongsun zan historical mission 03a
start_historical_mission_listener(
    "3k_main_faction_gongsun_zan",                          -- faction key
    "3k_main_objective_gongsun_zan_02a",                    -- mission key
    "CONTROL_N_REGIONS_INCLUDING",                                  -- objective type
    {
        "total 1",
        "region 3k_main_weijun_capital"
    },                                                  -- conditions (single string or table of strings)
    {
        "effect_bundle{bundle_key 3k_main_historical_mission_payload_02;turns 5;}"
    },                                                  -- mission rewards (table of strings)
    "ScriptEventGongsunZanHistoricalMission02Failure",      -- trigger event 
	"ScriptEventGongsunZanHistoricalMission03Complete",      -- completion event
	nil,
	"ScriptEventGongsunZanHistoricalMission03Complete",
	nil,
	25
)

-- gongsun zan historical mission 04
start_historical_mission_listener(
    "3k_main_faction_gongsun_zan",                          -- faction key
    "3k_main_objective_gongsun_zan_03",                     -- mission key
    "DESTROY_FACTION",                                  -- objective type
    {
        "faction 3k_main_faction_cao_cao"
    },                                                  -- conditions (single string or table of strings)
    {
        "effect_bundle{bundle_key 3k_main_historical_mission_payload_03;turns 5;}"
    },                                                  -- mission rewards (table of strings)
    "ScriptEventGongsunZanHistoricalMission03Complete",      -- trigger event 
    "ScriptEventGongsunZanHistoricalMission04Complete",     -- completion event
    function()
        if not cm:query_faction("3k_main_faction_cao_cao"):is_dead() then
            return true
        end
    end,                                                -- precondition (nil, or a function that returns a boolean)
	"ScriptEventGongsunZanHistoricalMission04Failure",       -- failure event
	nil,
	25
)

-- gongsun zan historical mission 04a
start_historical_mission_listener(
    "3k_main_faction_gongsun_zan",                          -- faction key
    "3k_main_objective_gongsun_zan_03a",                    -- mission key
    "CONTROL_N_REGIONS_INCLUDING",                                  -- objective type
    {
        "total 2",
        "region 3k_main_chenjun_capital"
    },                                                  -- conditions (single string or table of strings)
    {
        "effect_bundle{bundle_key 3k_main_historical_mission_payload_03;turns 5;}"
    },                                                  -- mission rewards (table of strings)
    "ScriptEventGongsunZanHistoricalMission04Failure",      -- trigger event 
	"ScriptEventGongsunZanHistoricalMission04Complete",      -- completion event
	nil,
	"ScriptEventGongsunZanHistoricalMission04Complete",
	nil,
	25
)

-- gongsun zan historical mission 05
start_historical_mission_listener(
    "3k_main_faction_gongsun_zan",                          -- faction key
    "3k_main_objective_gongsun_zan_04",                     -- mission key
    "MAKE_ALLIANCE",                                  -- objective type
    {
        "faction 3k_main_faction_liu_bei",
        "faction 3k_dlc05_faction_sun_ce"
    },                                                  -- conditions (single string or table of strings)
    {
        "effect_bundle{bundle_key 3k_main_historical_mission_payload_04;turns 5;}"
    },                                                  -- mission rewards (table of strings)
    "ScriptEventGongsunZanHistoricalMission04Complete",      -- trigger event 
    "ScriptEventGongsunZanHistoricalMission05Complete",     -- completion event
    function()
        if not cm:query_faction("3k_main_faction_liu_bei"):is_dead() and not cm:query_faction("3k_dlc05_faction_sun_ce"):is_dead() then
            return true
        end
    end,                                                -- precondition (nil, or a function that returns a boolean)
	"ScriptEventGongsunZanHistoricalMission05Failure",       -- failure event
	nil,
	25
)

-- gongsun zan historical mission 04a
start_historical_mission_listener(
    "3k_main_faction_gongsun_zan",                          -- faction key
    "3k_main_objective_gongsun_zan_04a",                    -- mission key
    "CONTROL_N_REGIONS_INCLUDING",                                  -- objective type
    {
        "total 6",
        "region 3k_main_luoyang_capital",
        "region 3k_main_chengdu_capital",
        "region 3k_main_weijun_capital",
        "region 3k_main_changsha_capital",
        "region 3k_main_youbeiping_capital",
        "region 3k_main_jianye_capital"
    },                                                   -- conditions (single string or table of strings)
    {
        "effect_bundle{bundle_key 3k_main_historical_mission_payload_04;turns 5;}"
    },                                                  -- mission rewards (table of strings)
    "ScriptEventGongsunZanHistoricalMission05Failure",      -- trigger event 
	"ScriptEventGongsunZanHistoricalMission05Complete",      -- completion event
	nil,
	"ScriptEventGongsunZanHistoricalMission05Complete",
	nil,
	25
)
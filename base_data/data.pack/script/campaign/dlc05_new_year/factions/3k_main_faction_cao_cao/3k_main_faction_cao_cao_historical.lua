-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
------------------------- Cao CaoHistorical Missions -------------------------
-------------------------------------------------------------------------------
------------ Adapted by Will from Nic's original script: 29/09/2019 -----------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------


output("Historical mission script loaded for " .. cm:get_local_faction());

-- OWN_N_REGIONS_INCLUDING
-- CAPTURE_REGIONS
-- CONTROL_N_PROVINCES_INCLUDING
-- CONTROL_N_REGIONS_INCLUDING
-- BE_AT_WAR_WITH_N_FACTIONS       -- db, total, faction_record, religion_record
-- BE_AT_WAR_WITH_FACTION          -- db, faction_record
-- CONFEDERATE_FACTIONS             -- db, total, faction_record



-- start the historical missions
if not cm:get_saved_value("historical_mission_launched") then
    core:add_listener(
        "start_historical_missions",
        "ScriptEventCaoCaoTutorialMission01Complete",
        true,
        function()
            core:trigger_event("ScriptEventCaoCaoHistoricalMission01Trigger")
            core:remove_listener("start_historical_missions");
            cm:set_saved_value("historical_mission_launched", true);
        end,
        false
    )
end


-- cao cao historical mission 02
start_historical_mission_listener(
    "3k_main_faction_cao_cao",                          -- faction key
    "3k_dlc05_objective_cao_cao_02",                     -- mission key
    "INCOME_AT_LEAST_X",                                  -- objective type
    {
      "income 200"
    },                                                  -- conditions (single string or table of strings)
    {
        "effect_bundle{bundle_key 3k_main_historical_mission_payload_02;turns 5;}"
    },                                                  -- mission rewards (table of strings)
    "ScriptEventCaoCaoHistoricalMission01Trigger",      -- trigger event 
    "ScriptEventCaoCaoHistoricalMission02Complete",     -- completion event
	nil,    
	"ScriptEventCaoCaoHistoricalMission02Complete",       -- failure event
	nil,												-- mission issuer
	25													--turn limit
)

-- cao cao historical mission 03
start_historical_mission_listener(
    "3k_main_faction_cao_cao",                          -- faction key
    "3k_dlc05_objective_cao_cao_03",                     -- mission key
    "DESTROY_FACTION",                                  -- objective type
    {
       "faction 3k_main_faction_lu_bu"
    },                                                  -- conditions (single string or table of strings)
    {
        "effect_bundle{bundle_key 3k_main_historical_mission_payload_02;turns 5;}"
    },                                                  -- mission rewards (table of strings)
    "ScriptEventCaoCaoHistoricalMission02Complete",      -- trigger event 
	"ScriptEventCaoCaoHistoricalMission03Complete",     -- completion event
	function()											-- precondition (nil, or a function that returns a boolean)
        if not cm:query_faction("3k_main_faction_lu_bu"):is_dead() then
            return true
        end
	end,
	"ScriptEventCaoCaoHistoricalMission02Failure",
	nil,
	25
)

-- cao cao historical mission 03a
start_historical_mission_listener(
    "3k_main_faction_cao_cao",                          -- faction key
    "3k_dlc05_objective_cao_cao_02",                    -- mission key
    "CONTROL_N_REGIONS_INCLUDING",                                  -- objective type
    {
        "total 3",
        "region 3k_main_luoyang_capital",
        "region 3k_main_yingchuan_capital",
        "region 3k_main_dongjun_capital"
    },                                                  -- conditions (single string or table of strings)
    {
        "effect_bundle{bundle_key 3k_main_historical_mission_payload_02;turns 5;}"
    },                                                  -- mission rewards (table of strings)
    "ScriptEventCaoCaoHistoricalMission02Failure",      -- trigger event 
	"ScriptEventCaoCaoHistoricalMission03Complete",      -- completion event
	nil,
	"ScriptEventCaoCaoHistoricalMission03Complete",
	nil,
	25
)

-- cao cao historical mission 04
start_historical_mission_listener(
    "3k_main_faction_cao_cao",                          -- faction key
    "3k_main_objective_cao_cao_03",                     -- mission key
    "DESTROY_FACTION",                                  -- objective type
    {
        "faction 3k_main_faction_yuan_shao"
    },                                                  -- conditions (single string or table of strings)
    {
        "effect_bundle{bundle_key 3k_main_historical_mission_payload_03;turns 5;}"
    },                                                  -- mission rewards (table of strings)
    "ScriptEventCaoCaoHistoricalMission03Complete",      -- trigger event 
    "ScriptEventCaoCaoHistoricalMission04Complete",     -- completion event
    function()
        if not cm:query_faction("3k_main_faction_yuan_shao"):is_dead() then
            return true
        end
    end,                                                -- precondition (nil, or a function that returns a boolean)
	"ScriptEventCaoCaoHistoricalMission03Failure",       -- failure event
	nil,
	25
)

-- cao cao historical mission 04a
start_historical_mission_listener(
    "3k_main_faction_cao_cao",                          -- faction key
    "3k_main_objective_cao_cao_03a",                    -- mission key
    "CONTROL_N_REGIONS_INCLUDING",                                  -- objective type
    {
        "total 2",
        "region 3k_main_weijun_capital",
        "region 3k_main_youbeiping_capital"
    },                                                  -- conditions (single string or table of strings)
    {
        "effect_bundle{bundle_key 3k_main_historical_mission_payload_03;turns 5;}"
    },                                                  -- mission rewards (table of strings)
    "ScriptEventCaoCaoHistoricalMission03Failure",      -- trigger event 
	"ScriptEventCaoCaoHistoricalMission04Complete",      -- completion event
	nil,
	"ScriptEventCaoCaoHistoricalMission04Complete",
	nil,
	25
)

-- cao cao historical mission 05
start_historical_mission_listener(
    "3k_main_faction_cao_cao",                          -- faction key
    "3k_main_objective_cao_cao_04",                     -- mission key
    "DESTROY_FACTION",                                  -- objective type
    {
        "faction 3k_main_faction_liu_bei",
        "faction 3k_dlc05_faction_sun_ce"
    },                                                  -- conditions (single string or table of strings)
    {
        "effect_bundle{bundle_key 3k_main_historical_mission_payload_04;turns 5;}"
    },                                                  -- mission rewards (table of strings)
    "ScriptEventCaoCaoHistoricalMission04Complete",      -- trigger event 
    "ScriptEventCaoCaoHistoricalMission05Complete",     -- completion event
    function()
        return not cm:query_faction("3k_main_faction_liu_bei"):is_dead() and not cm:query_faction("3k_dlc05_faction_sun_ce"):is_dead();
    end,                                                -- precondition (nil, or a function that returns a boolean)
	"ScriptEventCaoCaoHistoricalMission04Failure",       -- failure event
	nil,
	25
)

-- cao cao historical mission 05a
start_historical_mission_listener(
    "3k_main_faction_cao_cao",                          -- faction key
    "3k_main_objective_cao_cao_04a",                    -- mission key
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
    "ScriptEventCaoCaoHistoricalMission04Failure",      -- trigger event 
	"ScriptEventCaoCaoHistoricalMission05Complete",      -- completion event
	nil,
	"ScriptEventCaoCaoHistoricalMission05Complete",
	nil,
	25
)
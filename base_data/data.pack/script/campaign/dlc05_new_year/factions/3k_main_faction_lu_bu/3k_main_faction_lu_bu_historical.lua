-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
------------------------- lu bu Historical Missions -------------------------
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
        "ScriptEventLuBuTutorialMission02Complete",
        true,
        function()
            core:trigger_event("ScriptEventLuBuHistoricalMission01Trigger")
            core:remove_listener("start_historical_missions");
            cm:set_saved_value("historical_mission_launched", true);
        end,
        false
    )
end


-- lu bu historical mission 01
start_historical_mission_listener(
    "3k_main_faction_lu_bu",                          -- faction key
    "3k_dlc05_objective_lu_bu_03",                     -- mission key
    "DESTROY_FACTION",                                  -- objective type
    {
        "faction 3k_main_faction_cao_cao"
    },                                                  -- conditions (single string or table of strings)
    {
        "effect_bundle{bundle_key 3k_main_historical_mission_payload_03;turns 5;}"
    },                                                  -- mission rewards (table of strings)
    "ScriptEventLuBuHistoricalMission01Trigger",      -- trigger event 
    "ScriptEventLuBuHistoricalMission01Complete",     -- completion event
   function()
        if not cm:query_faction("3k_main_faction_cao_cao"):is_dead() then
            return true
        end
    end,        -- precondition (nil, or a function that returns a boolean)
	"ScriptEventLuBuHistoricalMission01Failure",       -- failure event  
	nil,												--mission issuer
	25												--turn limit
)

-- lu bu historical mission IF WITH LIU BEI
start_historical_mission_listener(
    "3k_main_faction_lu_bu",                          -- faction key
    "3k_dlc05_mission_lu_bu_destroy_bandits",                     -- mission key
    "DESTROY_FACTION",                                  -- objective type
    {
        "faction 3k_main_faction_zheng_jiang", "faction 3k_dlc05_faction_zang_ba"
    },                                                  -- conditions (single string or table of strings)
    {
        "effect_bundle{bundle_key 3k_main_historical_mission_payload_03;turns 5;}"
    },                                                  -- mission rewards (table of strings)
    "3k_dlc05_lu_bu_liu_bei_mission",      -- trigger event 
    "ScriptEventLuBuHistoricalMissionLiuBeiComplete",     -- completion event
   function()
        if not cm:query_faction("3k_main_faction_cao_cao"):is_dead() then
            return true
        end
    end,        -- precondition (nil, or a function that returns a boolean)
	"ScriptEventLuBuHistoricalMission01Failure",       -- failure event  
	nil,												--issuer
	25															--turn limit
)

-- lu bu historical mission 01a
start_historical_mission_listener(
    "3k_main_faction_lu_bu",                          -- faction key
    "3k_dlc05_objective_lu_bu_03a",                    -- mission key
    "CONTROL_N_REGIONS_INCLUDING",                                  -- objective type
    {
        "total 3",
        "region 3k_main_chenjun_capital",
        "region 3k_main_chenjun_resource_2",
        "region 3k_main_chenjun_resource_1"
    },                                                  -- conditions (single string or table of strings)
    {
        "effect_bundle{bundle_key 3k_main_historical_mission_payload_03;turns 5;}"
    },                                                  -- mission rewards (table of strings)
    "ScriptEventLuBuHistoricalMission01Failure",      -- trigger event 
	"ScriptEventLuBuHistoricalMission01Complete",     -- completion event
	nil,											
	"ScriptEventLuBuHistoricalMission01Complete",
	nil,
	25
)



-- lu bu historical mission 02
start_historical_mission_listener(
    "3k_main_faction_lu_bu",                          -- faction key
    "3k_dlc05_objective_lu_bu_04",                     -- mission key
    "DESTROY_FACTION",                                  -- objective type
    {
        "faction 3k_main_faction_dong_zhuo"
    },                                                  -- conditions (single string or table of strings)
    {
        "effect_bundle{bundle_key 3k_main_historical_mission_payload_04;turns 5;}"
    },                                                  -- mission rewards (table of strings)
    "ScriptEventLuBuHistoricalMission01Complete",      -- trigger event 
    "ScriptEventLuBuHistoricalMission02Complete",     -- completion event
    function()
        if not cm:query_faction("3k_main_faction_dong_zhuo"):is_dead() then
            return true
        end
    end,                                                -- precondition (nil, or a function that returns a boolean)
	"ScriptEventLuBuHistoricalMission02Failure",       -- failure event
	nil,
	25
)

-- lu bu historical mission 02a
start_historical_mission_listener(
    "3k_main_faction_lu_bu",                          -- faction key
    "3k_dlc05_objective_lu_bu_04a",                    -- mission key
    "CONTROL_N_REGIONS_INCLUDING",                                  -- objective type
    {
        "total 3",
        "region 3k_main_luoyang_capital",
        "region 3k_main_changan_capital",
        "region 3k_main_shangyong_capital"
    },                                                   -- conditions (single string or table of strings)
    {
        "effect_bundle{bundle_key 3k_main_historical_mission_payload_04;turns 5;}"
    },                                                  -- mission rewards (table of strings)
    "ScriptEventLuBuHistoricalMission02Failure",      -- trigger event 
	"ScriptEventLuBuHistoricalMission02Complete",      -- completion event
	nil,
	"ScriptEventLuBuHistoricalMission02Complete",
	nil,
	25
)



-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
------------------------- Tao Qian Historical Missions ------------------------
-------------------------------------------------------------------------------
------------------------ Created by Jakob: 23/08/2019 -------------------------
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
            core:trigger_event("ScriptEventTaoQianHistoricalMission01Trigger")
            core:remove_listener("start_historical_missions");
            cm:set_saved_value("historical_mission_launched", true);
        end,
        false
    )
end
-- tao qian historical mission 01
start_historical_mission_listener(
    "3k_main_faction_tao_qian",                          -- faction key
    "3k_main_objective_tao_qian_01",                    -- mission key
    "CONTROL_N_REGIONS_INCLUDING",                                  -- objective type
    {
        "total 4",
        "region 3k_main_penchang_resource_1"
    },                                                  -- conditions (single string or table of strings)
    {
        "effect_bundle{bundle_key 3k_main_historical_mission_payload_01;turns 5;}",
        "money 2000"
    },                                                  -- mission rewards (table of strings)
    "ScriptEventTaoQianHistoricalMission01Trigger",      -- trigger event 
    "ScriptEventTaoQianHistoricalMission01Complete"      -- completion event
)

-- tao qian historical mission 02
start_historical_mission_listener(
    "3k_main_faction_tao_qian",                          -- faction key
    "3k_main_objective_tao_qian_02",                    -- mission key
    "CONTROL_N_REGIONS_INCLUDING",                                  -- objective type
    {
        "total 8",
        "region 3k_main_langye_capital", 
        "region 3k_main_guangling_capital",        
        "region 3k_main_guangling_resource_1",        
        "region 3k_main_guangling_resource_2"
    },                                                  -- conditions (single string or table of strings)
    {
        "effect_bundle{bundle_key 3k_main_historical_mission_payload_01;turns 8;}",
        "money 4000"
    },                                                  -- mission rewards (table of strings)
    "ScriptEventTaoQianHistoricalMission01Complete",      -- trigger event 
    "ScriptEventTaoQianHistoricalMission02Complete"      -- completion event
)

-- tao qian historical mission 03
start_historical_mission_listener(
    "3k_main_faction_tao_qian",                         -- faction key
    "3k_main_objective_tao_qian_03",                    -- mission key
    "CONTROL_N_REGIONS_INCLUDING",                      -- objective type
    {
        "total 20",
        "region 3k_main_jianye_capital",        
        "region 3k_main_jianye_resource_1",        
        "region 3k_main_jianye_resource_2",
        "region 3k_main_xindu_capital",        
        "region 3k_main_xindu_resource_1",
        "region 3k_main_kuaiji_capital"  
    },                                                  -- conditions (single string or table of strings)
    {
        "effect_bundle{bundle_key 3k_main_historical_mission_payload_01;turns 8;}",
        "money 5000"
    },                                                  -- mission rewards (table of strings)
    "ScriptEventTaoQianHistoricalMission02Complete",      -- trigger event 
    "ScriptEventTaoQianHistoricalMission03Complete"      -- completion event
)
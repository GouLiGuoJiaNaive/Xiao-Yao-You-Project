-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
------------------------- Liu Bei Historical Missions -------------------------
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
            core:trigger_event("ScriptEventLiuChongHistoricalMission01Trigger")
            cm:set_saved_value("historical_mission_launched", true);
        end,
        false
    )
end

-- Liu Chong historical mission 01 -- Kill Yuan Shu
start_historical_mission_listener(
    "3k_dlc04_faction_prince_liu_chong",                          -- faction key
    "3k_dlc04_main_objective_liu_chong_01",                    -- mission key
    "DESTROY_FACTION",                                  -- objective type
    {
        "faction 3k_main_faction_yuan_shu",
    },                                                  -- conditions (single string or table of strings)
    {
        "effect_bundle{bundle_key 3k_main_historical_mission_payload_01;turns 5;}",
        "money 2000"
    },                                                  -- mission rewards (table of strings)
    "ScriptEventLiuChongHistoricalMission01Trigger",      -- trigger event 
	"ScriptEventLiuChongHistoricalMission01Complete",      -- completion event
	function() -- precondition
        if not cm:query_faction("3k_main_faction_yuan_shu"):is_dead() then
            return true
        end
	end,
	"ScriptEventLiuChongHistoricalMission01Failure"       -- failure event
)

start_historical_mission_listener(
    "3k_dlc04_faction_prince_liu_chong",                          -- faction key
    "3k_dlc04_main_objective_liu_chong_01a",                    -- mission key
    "CAPTURE_REGIONS",                                  -- objective type
    {
        "total 4",
        "region 3k_main_nanyang_capital"
    },                                                  -- conditions (single string or table of strings)
    {
        "effect_bundle{bundle_key 3k_main_historical_mission_payload_01;turns 5;}",
        "money 2000"
    },                                                  -- mission rewards (table of strings)
    "ScriptEventLiuChongHistoricalMission01Failure",      -- trigger event 
    "ScriptEventLiuChongHistoricalMission01Complete"      -- completion event
)

-- Liu Chong historical mission 02  -- Claim Chen
start_historical_mission_listener(
    "3k_dlc04_faction_prince_liu_chong",                          -- faction key
    "3k_dlc04_main_objective_liu_chong_02",                    -- mission key
    "CONTROL_N_REGIONS_INCLUDING",                                  -- objective type
    {
        "total 8",
        "region 3k_main_chenjun_capital", 
        "region 3k_main_chenjun_resource_1",        
        "region 3k_main_chenjun_resource_2",        
        "region 3k_main_chenjun_resource_3"
    },                                                  -- conditions (single string or table of strings)
    {
        "effect_bundle{bundle_key 3k_main_historical_mission_payload_02;turns 8;}",
        "money 4000"
    },                                                  -- mission rewards (table of strings)
    "ScriptEventLiuChongHistoricalMission01Complete",      -- trigger event 
    "ScriptEventLiuChongHistoricalMission02Complete",      -- completion event
	function() -- precondition
		local faction_region_list = cm:query_faction("3k_dlc04_faction_prince_liu_chong"):region_list();
		local num_found = 0;
		for i = 0, faction_region_list:num_items() - 1 do
			local region = faction_region_list:item_at(i);
			if region:name() == "3k_main_chenjun_capital" or region:name() == "3k_main_chenjun_resource_1" or region:name() == "3k_main_chenjun_resource_2" or region:name() == "3k_main_chenjun_resource_3" then
				num_found = num_found + 1;
			end;
		end;

        if num_found < 4 then-- If we don't own them all.
            return true
		end
		
		return false;
	end,
	"ScriptEventLiuChongHistoricalMission02Failure"       -- failure event
)

start_historical_mission_listener(
    "3k_dlc04_faction_prince_liu_chong",                          -- faction key
    "3k_dlc04_main_objective_liu_chong_02a",                    -- mission key
    "CONTROL_N_REGIONS_INCLUDING",                                  -- objective type
    {
        "total 8"
    },                                                  -- conditions (single string or table of strings)
    {
        "effect_bundle{bundle_key 3k_main_historical_mission_payload_02;turns 8;}",
        "money 4000"
    },                                                  -- mission rewards (table of strings)
    "ScriptEventLiuChongHistoricalMission02Failure",      -- trigger event 
    "ScriptEventLiuChongHistoricalMission02Complete"      -- completion event
)

-- Liu Chong historical mission 03 -- Capture ancient capitals
start_historical_mission_listener(
    "3k_dlc04_faction_prince_liu_chong",                         -- faction key
    "3k_dlc04_main_objective_liu_chong_03",                    -- mission key
    "CONTROL_N_REGIONS_INCLUDING",                      -- objective type
    {
        "total 20",
        "region 3k_main_luoyang_capital",        
        "region 3k_main_changan_capital",        
        "region 3k_main_penchang_capital",
        "region 3k_main_weijun_capital",        
        "region 3k_main_yingchuan_capital"
    },                                                  -- conditions (single string or table of strings)
    {
        "effect_bundle{bundle_key 3k_main_historical_mission_payload_03;turns 8;}",
        "money 5000"
    },                                                  -- mission rewards (table of strings)
    "ScriptEventLiuChongHistoricalMission02Complete",      -- trigger event 
    "ScriptEventLiuChongHistoricalMission03Complete"      -- completion event
)


-- Liu Chong historical mission 04 -- Liberate the Emperor
start_historical_mission_listener(
    "3k_dlc04_faction_prince_liu_chong",                         -- faction key
    "3k_dlc04_main_objective_liu_chong_04",                    -- mission key
    "SCRIPTED",                      -- objective type
    {
		"script_key liu_chong_captured_emperor",
		"override_text mission_text_text_3k_scripted_save_the_emperor"
    },                                                  -- conditions (single string or table of strings)
    {
        "effect_bundle{bundle_key 3k_main_historical_mission_payload_04;turns 8;}",
        "money 5000"
    },                                                  -- mission rewards (table of strings)
    "ScriptEventLiuChongHistoricalMission02Complete",      -- trigger event 
    "ScriptEventLiuChongHistoricalMission03Complete"      -- completion event
);

-- Scripted mission listener
core:add_listener(
	"liu_chong_dlc04_emperor_listener",
	"WorldPowerTokenCapturedEvent",
	function(context)
		return cm:is_world_power_token_owned_by("emperor", "3k_dlc04_faction_prince_liu_chong");
	end,
	function(context)
		local mod_faction = cm:modify_faction("3k_dlc04_faction_prince_liu_chong");
		
		mod_faction:complete_custom_mission("3k_dlc04_main_objective_liu_chong_04");
	end,
	false
);

core:add_listener(
	"liu_chong_dlc04_emperor_listener",
	"WorldPowerTokenRemovedEvent",
	function(context)
		return context:token() == "emperor";
	end,
	function(context)
		local mod_faction = cm:modify_faction("3k_dlc04_faction_prince_liu_chong");
		
		mod_faction:cancel_custom_mission("3k_dlc04_main_objective_liu_chong_04");
	end,
	false
);


 
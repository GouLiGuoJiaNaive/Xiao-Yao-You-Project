--[[
***************************************************
***************************************************
** VARIABLES
***************************************************
***************************************************
]]--
local local_faction_key = "3k_main_faction_yuan_shao";
local listener_key = "dlc07_" .. local_faction_key .. "_";
local success_key = "dlc07_" .. local_faction_key .. "_success_";
local failure_key = "dlc07_" .. local_faction_key .. "_failure_";

output("Events script loaded for " .. local_faction_key);

-- Handles REACH_FACTION_RANK and VICTORY CONDITION missions for factions.
dlc07_shared_progression_missions:setup_han_progression_missions(local_faction_key);
dlc07_shared_progression_missions:setup_han_victory_missions(local_faction_key);

local function initial_set_up()

end;




-- #region Intro
--[[
***************************************************
***************************************************
** Intro
***************************************************
***************************************************
]]--
-- Intro Event.
cdir_mission_manager:start_incident_db_listener(
	local_faction_key, -- faction_key 
	"3k_dlc07_introduction_yuan_shao_incident", -- event_key 
	"FactionTurnStart", -- trigger event 
	function(context)
		return cdir_mission_manager:get_turn_number() == 1 and context:faction():name() == local_faction_key and context:faction():is_human();
	end, --listener condition
	false, -- fire_once.
	success_key.."intro_fired", -- completion event 
	nil -- failure event
);


-- #endregion

-- #region Progression

--[[
***************************************************
***************************************************
** PROGRESSION MISSIONS
***************************************************
***************************************************
]]--

--------------------OLD MISSIONS THAT WEREN'T CUT------------------------------
cdir_mission_manager:start_mission_listener(local_faction_key,
	"3k_dlc07_guandu_begins_01_yuan_shao_mission",
	"DESTROY_FACTION",                                  -- objective type
    {
		"faction 3k_main_faction_zhang_yan",
    },    
    {
        "effect_bundle{bundle_key 3k_main_historical_mission_payload_02;turns 5;}"
    },                                                  -- mission rewards (table of strings)
	"FactionTurnStart", -- trigger event 
	function(context)
		return cdir_mission_manager:get_turn_number() == 3 and context:faction():name() == local_faction_key
		 and context:faction():is_human() and not cm:query_faction("3k_main_faction_zhang_yan"):is_dead();
	end,
	false,												-- Fire once
	"ScriptEventFactionEventsYuanShao_M01Complete",		-- completion event
	nil,		-- failure event
	"CLAN_ELDERS"							--mission_issuer
);

-- Hold three key regions, capture another
cdir_mission_manager:start_mission_listener(
    local_faction_key,                          -- faction key
    "3k_dlc07_guandu_begins_02_yuan_shao_mission",                     -- mission key
    "CONTROL_N_REGIONS_INCLUDING",                                  -- objective type
    {
        "total 4",
		"region 3k_main_weijun_capital",
		"region 3k_main_weijun_resource_1",
		"region 3k_main_henei_resource_1",
		"region 3k_dlc06_shangdang_resource_2"
    },    
    {
        "effect_bundle{bundle_key 3k_main_historical_mission_payload_01;turns 5;}"
    },                                                  -- mission rewards (table of strings)
	"FactionTurnStart", -- trigger event 
	function(context)
		return cdir_mission_manager:get_turn_number() == 3 and context:faction():name() == local_faction_key and context:faction():is_human();
	end,
	false,												-- Fire once
	"ScriptEventFactionEventsYuanShao_M02Complete",		-- completion event
	nil,		-- failure event
	"CLAN_ELDERS"							--mission_issuer
);


-----------------------MAIN GUANDU CONFLICT------------------

cdir_mission_manager:start_mission_listener(
	local_faction_key,
	"3k_dlc07_mission_yuan_shao_guandu_main_mission_opener",
	"CONTROL_N_REGIONS_INCLUDING",                                  -- objective type
    {
        "total 2",
		"region 3k_main_henei_resource_1",
		"region 3k_main_dongjun_capital",
    },    
    {
        "effect_bundle{bundle_key 3k_dlc07_mission_payload_guandu_opening_move;turns 6;}"
    },                                                  -- mission rewards (table of strings)
	success_key.."intro_fired",      -- trigger event 
	function(context) return true end,	-- Listener condition
	false,												-- Fire once
	success_key.."guandu_conflict_1_complete",		-- completion event
	success_key.."guandu_conflict_1_complete",		-- failure event
	"3k_main_victory_objective_issuer"							--mission_issuer
);

cdir_mission_manager:start_mission_listener(
	local_faction_key,
	"3k_dlc07_mission_yuan_shao_guandu_main_mission_foothold",
	"CONTROL_N_REGIONS_INCLUDING",                                  -- objective type
    {
        "total 2",
		"region 3k_main_yingchuan_capital",
		"region 3k_main_yingchuan_resource_1",
    },    
    {
        "money 2000"
    },                                                  -- mission rewards (table of strings)
	success_key.."guandu_conflict_1_complete",      -- trigger event 
	function(context) return true end,	-- Listener condition
	false,												-- Fire once
	success_key.."guandu_conflict_2_complete",		-- completion event
	success_key.."guandu_conflict_2_complete",		-- failure event
	"3k_main_victory_objective_issuer"							--mission_issuer
);

cdir_mission_manager:start_mission_listener(
	local_faction_key,
	"3k_dlc07_mission_yuan_shao_guandu_main_mission_capital",
	"CONTROL_N_REGIONS_INCLUDING",                                  -- objective type
    {
        "total 1",
		"region 3k_main_chenjun_capital",
    },    
    {
        "money 3500"
    },                                                  -- mission rewards (table of strings)
	success_key.."guandu_conflict_2_complete",      -- trigger event 
	function(context) return true end,	-- Listener condition
	false,												-- Fire once
	success_key.."guandu_conflict_3_complete",		-- completion event
	success_key.."guandu_conflict_3_complete",		-- failure event
	"3k_main_victory_objective_issuer"							--mission_issuer
);

cdir_mission_manager:start_mission_listener(
	local_faction_key,
	"3k_dlc07_mission_yuan_shao_guandu_main_mission_final",
	"DESTROY_FACTION",                                  -- objective type
    {
		"faction 3k_main_faction_cao_cao",
    },
    {
		"effect_bundle{bundle_key 3k_dlc07_mission_payload_guandu_victor;turns 8;}",
		"money 5000"
    },                                                  -- mission rewards (table of strings)
	success_key.."guandu_conflict_3_complete",      -- trigger event 
	function(context) return true end,	-- Listener condition
	false,												-- Fire once
	success_key.."guandu_conflict_4_complete",		-- completion event
	success_key.."guandu_conflict_4_complete",		-- failure event
	"3k_main_victory_objective_issuer"							--mission_issuer
);

-----------------------SIDE GUANDU CONFLICT------------------

cdir_mission_manager:start_mission_listener(
	local_faction_key,
	"3k_dlc07_mission_yuan_shao_guandu_side_mission_strategic_region_1",
	"CONTROL_N_REGIONS_INCLUDING",                                  -- objective type
    {
        "total 3",
		"region 3k_main_langye_capital",
		"region 3k_main_langye_resource_1",
		"region 3k_main_langye_resource_2"
    },    
    {
        "effect_bundle{bundle_key 3k_dlc07_mission_payload_guandu_langya_conquest;turns 6;}"
    },                                                  -- mission rewards (table of strings)
	"FactionTurnStart", -- trigger event 
	function(context)
		return cdir_mission_manager:get_turn_number() == 10 and context:faction():name() == local_faction_key and context:faction():is_human();
	end,
	false,												-- Fire once
	success_key.."side_conflict_1_started",		-- completion event
	success_key.."side_conflict_1_started",		-- failure event
	"CLAN_ELDERS"							--mission_issuer
);

cdir_mission_manager:start_mission_listener(
	local_faction_key,
	"3k_dlc07_mission_yuan_shao_guandu_side_mission_strategic_region_2",
	"CONTROL_N_REGIONS_INCLUDING",                                  -- objective type
    {
        "total 5",
		"region 3k_main_dongjun_resource_1",
		"region 3k_dlc06_xiapi_resource_1",
		"region 3k_main_chenjun_resource_1",
		"region 3k_main_penchang_capital",
		"region 3k_main_yangzhou_resource_1"
    },    
    {
        "money 4000"
    },                                                  -- mission rewards (table of strings)
	success_key.."side_conflict_1_started",      -- trigger event 
	function(context) return true end,	-- Listener condition
	false,												-- Fire once
	success_key.."side_conflict_1_completed",		-- completion event
	success_key.."side_conflict_1_completed",		-- failure event
	"SHOGUN"							--mission_issuer
);


cdir_mission_manager:start_mission_listener(
	local_faction_key,
	"3k_dlc07_mission_yuan_shao_guandu_side_mission_gate_passes_1",
	"CONTROL_N_REGIONS_INCLUDING",                                  -- objective type
    {
        "total 2",
		"region 3k_dlc06_gu_pass",
		"region 3k_dlc06_qi_pass",
    },    
    {
        "effect_bundle{bundle_key 3k_dlc07_mission_payload_guandu_conquered_gates;turns 6;}"
    },                                                  -- mission rewards (table of strings)
	"FactionTurnStart", -- trigger event 
	function(context)
		return cdir_mission_manager:get_turn_number() == 7 and context:faction():name() == local_faction_key and context:faction():is_human();
	end,
	false,												-- Fire once
	success_key.."side_conflict_2_started",		-- completion event
	success_key.."side_conflict_2_started",		-- failure event
	"CLAN_ELDERS"							--mission_issuer
);


cdir_mission_manager:start_mission_listener(
	local_faction_key,
	"3k_dlc07_mission_yuan_shao_guandu_side_mission_gate_passes_2",
	"CONTROL_N_REGIONS_INCLUDING",                                  -- objective type
    {
        "total 4",
		"region 3k_main_hedong_capital",
		"region 3k_main_hedong_resource_1",
		"region 3k_dlc06_hedong_resource_2",
		"region 3k_dlc06_hangu_pass"
    },    
    {
        "money 4000"
    },                                                  -- mission rewards (table of strings)
	success_key.."side_conflict_2_started",      -- trigger event 
	function(context) return true end,	-- Listener condition
	false,												-- Fire once
	success_key.."side_conflict_2_complete",		-- completion event
	success_key.."side_conflict_2_complete",		-- failure event
	"CLAN_ELDERS"							--mission_issuer
);


cdir_mission_manager:start_mission_listener(
	local_faction_key,
	"3k_dlc07_mission_yuan_shao_guandu_side_mission_defeat_armies",
	"DEFEAT_N_ARMIES_OF_FACTION",                                  -- objective type
    {
        
		"faction 3k_main_faction_cao_cao",
		"total 5"
    },    
    {
        "money 3000"
    },                                                  -- mission rewards (table of strings)
	success_key.."intro_fired",      -- trigger event 
	function(context) return true end,	-- Listener condition
	false,												-- Fire once
	success_key.."side_conflict_3_complete",		-- completion event
	success_key.."side_conflict_3_complete",		-- failure event
	"CLAN_ELDERS"							--mission_issuer
);


-----------------------POST GUANDU CONFLICT------------------

cdir_mission_manager:start_mission_listener(
	local_faction_key,
	"3k_dlc07_mission_yuan_shao_guandu_after_mission_defeat_allies",
	"DESTROY_FACTION",                                  -- objective type
    {
		"faction 3k_dlc07_faction_chen_deng",
		"faction 3k_dlc07_faction_zhang_xiu",
		"faction 3k_main_faction_gongsun_du",
		"total 3"
    },   
    {
        "money 4000"
    },                                                  -- mission rewards (table of strings)
	success_key.."guandu_conflict_4_complete",      -- trigger event 
	function(context)
		return not cm:query_faction("3k_dlc07_faction_chen_deng"):is_dead()
		 or not cm:query_faction("3k_dlc07_faction_zhang_xiu"):is_dead()
		 or not cm:query_faction("3k_dlc07_faction_gongsun_du"):is_dead()
	end,	-- Listener condition
	false,												-- Fire once
	success_key.."post_conflict_1_complete",		-- completion event
	success_key.."post_conflict_1_complete",		-- failure event
	"CLAN_ELDERS"							--mission_issuer
);

cdir_mission_manager:start_mission_listener(
	local_faction_key,
	"3k_dlc07_mission_yuan_shao_guandu_after_mission_defeat_bandits",
	"DESTROY_FACTION",                                  -- objective type
    {
		"faction 3k_main_faction_zhang_yan",
		"faction 3k_main_faction_zheng_jiang",
		"faction 3k_dlc05_faction_xu_zhao",
		"total 3"
    }, 
    {
		"effect_bundle{bundle_key 3k_dlc07_mission_payload_guandu_pacified_bandits;turns 5;}",
		"money 3500"
    },                                                  -- mission rewards (table of strings)
	success_key.."guandu_conflict_4_complete",      -- trigger event 
	function(context)
		return not cm:query_faction("3k_main_faction_zheng_jiang"):is_dead() or
		not cm:query_faction("3k_main_faction_zhang_yan"):is_dead() or
		not cm:query_faction("3k_dlc05_faction_xu_zhao"):is_dead()
	end,	-- Listener condition
	false,												-- Fire once
	success_key.."post_conflict_2_complete",		-- completion event
	success_key.."post_conflict_2_complete",		-- failure event
	"CLAN_ELDERS"							--mission_issuer
);

cdir_mission_manager:start_mission_listener(
	local_faction_key,
	"3k_dlc07_mission_yuan_shao_guandu_after_mission_attack_sun_clan",
	"CONTROL_N_REGIONS_INCLUDING",                                  -- objective type
    {
        "total 1",
		"region 3k_main_jianye_capital",
    },    
    {
        "effect_bundle{bundle_key 3k_dlc07_mission_payload_guandu_opening_move;turns 6;}"
    },                                                  -- mission rewards (table of strings)
	success_key.."guandu_conflict_4_complete",      -- trigger event 
	function(context) return not cm:query_faction("3k_dlc05_faction_sun_ce"):is_dead()
		and cm:query_region("3k_main_jianye_capital"):owning_faction():name() == "3k_dlc05_faction_sun_ce" end,	-- Listener condition
	false,												-- Fire once
	success_key.."post_conflict_3_complete",		-- completion event
	success_key.."post_conflict_3_complete",		-- failure event
	"CLAN_ELDERS"							--mission_issuer
);

-- sun clan post conquest incident
cdir_mission_manager:start_incident_db_listener(
	local_faction_key, -- faction_key 
	"3k_dlc07_incident_guandu_victor_sun_clan_incident", -- event_key 
	success_key.."post_conflict_3_complete", -- trigger event 
	function(context)
		return not cm:query_faction("3k_dlc05_faction_sun_ce"):is_dead()
	end, --listener condition
	false, -- fire_once.
	success_key.."post_conflict_3_complete_incident", -- completion event 
	nil -- failure event
);


-- #endregion


------------------------EVENT HELPER LISTENERS--------------------
core:add_listener(
	listener_key.."liu_bei_betrayal_incident_helper",
	"DilemmaChoiceMadeEvent",
	function(context)
		return context:faction():name() == local_faction_key and context:faction():is_human()
		 and string.find(context:dilemma(),"3k_dlc07_dilemma_yuan_shao_diminish_liu_bei_") and context:choice()==0
	end,
	function(context)
		local liu_bei_faction = cm:modify_faction("3k_main_faction_liu_bei")

		--if this is the first incident in the chain
		if string.match(context:dilemma(), "3k_dlc07_dilemma_yuan_shao_diminish_liu_bei_1") then
			liu_bei_faction:apply_effect_bundle("3k_dlc07_dilemma_bundle_resources_siphoned", 8)
		--only other option is that its the second incident in the chain
		else
			liu_bei_faction:apply_effect_bundle("3k_dlc07_dilemma_bundle_resources_siphoned", 15)
		end
	end,
	true
)


cm:add_first_tick_callback_new(initial_set_up);
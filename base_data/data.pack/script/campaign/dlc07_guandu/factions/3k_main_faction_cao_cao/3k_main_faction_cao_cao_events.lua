--[[
***************************************************
***************************************************
** VARIABLES
***************************************************
***************************************************
]]--
local local_faction_key = "3k_main_faction_cao_cao";
output("Events script loaded for " .. local_faction_key);
local listener_key = "dlc07_" .. local_faction_key .. "_";
local success_key = "dlc07_" .. local_faction_key .. "_success_";
local failure_key = "dlc07_" .. local_faction_key .. "_failure_";
local yuan_shao_faction_key = "3k_main_faction_yuan_shao"


-- Handles REACH_FACTION_RANK and VICTORY CONDITION missions for factions.
dlc07_shared_progression_missions:setup_han_progression_missions(local_faction_key);
dlc07_shared_progression_missions:setup_han_victory_missions(local_faction_key);

--[[
***************************************************
***************************************************
** Intro
***************************************************
***************************************************
]]--

cdir_mission_manager:start_incident_db_listener(
	local_faction_key, -- faction_key 
	"3k_dlc07_introduction_cao_cao_incident", -- event_key 
	"FactionTurnStart", -- trigger event 
	function(context)
		return cdir_mission_manager:get_turn_number() == 1 and context:faction():name() == local_faction_key and context:faction():is_human();
	end, --listener condition
	false, -- fire_once.
	success_key.."incident_set", -- completion event 
	nil -- failure event
);

-- Apply an effect bundle (a hidden character captive % increase) to Cao Cao's army for a single turn for his fight with Guan Yu
core:add_listener(
		"FactionTurnStartEarlyCapture", -- Unique handle
		"FactionTurnStart", -- Campaign Event to listen for
		function(context) -- Listener condition
			return cdir_mission_manager:get_turn_number() == 1 and context:faction():name() == local_faction_key and context:faction():is_human();
		end,
		function(context)	
			cm:modify_character("3k_main_template_historical_cao_cao_hero_earth"):apply_effect_bundle("3k_dlc07_cao_cao_early_character_captive_bundle", 2);
		end,
		true
	); 

--[[
***************************************************
***************************************************
** PROGRESSION MISSIONS
***************************************************
***************************************************
]]--

--***********************MISSIONS: Main Conflict Arc****************************

--  Progression Mission 1a: 
cdir_mission_manager:start_mission_listener(
    local_faction_key,                          -- faction key
    "3k_dlc07_mission_guandu_cao_cao_opening",                     -- mission key
    "CONTROL_N_REGIONS_INCLUDING",                                  -- objective type
    {
        "total 2",
		"region 3k_main_dongjun_capital",
		"region 3k_main_henei_resource_1",
    },
    {
        "effect_bundle{bundle_key 3k_dlc07_mission_payload_guandu_opening_move;turns 6;}"
    },                                                  -- mission rewards (table of strings)
	success_key.."incident_set",      -- trigger event
	nil,												-- Listener condition
	false,												-- Fire once
  	success_key.."hold_henei_dong",     -- completion event
	success_key.."hold_henei_dong",		-- failure event
	"3k_main_victory_objective_issuer"		-- mission_issuer
);

-- Progression Mission 1b
cdir_mission_manager:start_mission_db_listener(
	local_faction_key, -- faction_key
	"3k_dlc07_tutorial_cao_cao_defeat_army_mission", -- event_key
	success_key.."incident_set", -- trigger event
	nil,
	false, -- fire_once.
	success_key.."army_engaged", -- completion event
	failure_key.."army_engaged", -- failure event
	false -- delay start
	-- 3k_main_victory_objective_issuer
);

-- Progression Mission 1c:
cdir_mission_manager:start_mission_listener(
    local_faction_key,                          -- faction key
    "3k_dlc07_guandu_begins_02_cao_cao_mission",                     -- mission key
    "CONTROL_N_REGIONS_INCLUDING",                                  -- objective type
	{
		        "total 4",
				"region 3k_main_luoyang_capital",
				"region 3k_main_yingchuan_capital",
				"region 3k_main_yingchuan_resource_1",
				"region 3k_main_runan_capital"
		    },    
    {
        "effect_bundle{bundle_key 3k_main_historical_mission_payload_01;turns 5;}"
    },                                                  -- mission rewards (table of strings)
	"FactionTurnStart", -- trigger event 
	function(context)
		return cdir_mission_manager:get_turn_number() == 3 and context:faction():name() == local_faction_key and context:faction():is_human();
	end,												-- Listener condition
	false,												-- Fire once
  	success_key.."hold_four_regions",     -- completion event
	success_key.."hold_four_regions",		-- failure event
	"3k_main_victory_objective_issuer"		-- mission_issuer
);

-- Progression Mission 1d:
cdir_mission_manager:start_mission_listener(
    local_faction_key,                          -- faction key
    "3k_dlc07_guandu_begins_01_cao_cao_mission",                     -- mission key
    "DESTROY_FACTION",                                  -- objective type
    {
		"faction 3k_main_faction_liu_bei",
		"faction 3k_main_faction_yellow_turban_anding",
		"total 1"
    },
    {
		"effect_bundle{bundle_key 3k_main_historical_mission_payload_02;turns 5;}"
    },                                                     -- mission rewards (table of strings)
	"FactionTurnStart", -- trigger event 
	function(context)
		return cdir_mission_manager:get_turn_number() == 3 and context:faction():name() == local_faction_key
		 and context:faction():is_human() and not cm:query_faction("3k_main_faction_yellow_turban_anding"):is_dead() ; 
	end,												-- Listener condition
	false,												-- Fire once
	success_key.."one_ally_destroyed",		-- completion event
	success_key.."one_ally_destroyed",		-- failure event
	"3k_main_victory_objective_issuer"							--mission_issuer
);

--  Progression Mission 2a: 
cdir_mission_manager:start_mission_listener(
    local_faction_key,                          -- faction key
    "3k_dlc07_mission_guandu_cao_cao_occupy_wei",                     -- mission key
    "CONTROL_N_REGIONS_INCLUDING",                                  -- objective type
    {
        "total 2",
		"region 3k_main_weijun_capital",
		"region 3k_main_weijun_resource_1",
    },
    {
        "money 2000"
    },                                                  -- mission rewards (table of strings)
	success_key.."hold_henei_dong",      -- trigger event
	nil,												-- Listener condition
	false,												-- Fire once
  	success_key.."hold_wei",     -- completion event
	success_key.."hold_wei",		-- failure event
	"3k_main_victory_objective_issuer"		-- mission_issuer
);

--  Progression Mission 2b: 
cdir_mission_manager:start_mission_listener(
    local_faction_key,                          -- faction key
    "3k_dlc07_mission_guandu_cao_cao_anping",                     -- mission key
    "CONTROL_N_REGIONS_INCLUDING",                                  -- objective type
    {
        "total 1",
		"region 3k_main_anping_capital",
    },
    {
        "money 3500"
    },                                                  -- mission rewards (table of strings)
	success_key.."hold_wei",      -- trigger event
	nil,												-- Listener condition
	false,												-- Fire once
  	success_key.."hold_anping_capital",     -- completion event
	success_key.."hold_anping_capital",		-- failure event
	"3k_main_victory_objective_issuer"		-- mission_issuer
);

-- Progression Mission 3:
cdir_mission_manager:start_mission_listener(
    local_faction_key,                          -- faction key
    "3k_dlc07_mission_guandu_cao_cao_destroy_yuan_shao",                     -- mission key
    "DESTROY_FACTION",                                  -- objective type
    {
        "faction 3k_main_faction_yuan_shao"
    },
    {
		"effect_bundle{bundle_key 3k_dlc07_mission_payload_guandu_victor;turns 8;}",
		"money 5000"
    },                                                     -- mission rewards (table of strings)
	success_key.."hold_anping_capital",      -- trigger event
	nil,												-- Listener condition
	false,												-- Fire once
	success_key.."yuanshao_destroyed",		-- completion event
	success_key.."yuanshao_destroyed",		-- failure event
	"3k_main_victory_objective_issuer"							--mission_issuer
);

-- Ongoing Mission: Beat X of Yuan Shao's forces
cdir_mission_manager:start_mission_listener(
	local_faction_key,
	"3k_dlc07_mission_guandu_cao_cao_defeat_yuan_shao_armies",
	"DEFEAT_N_ARMIES_OF_FACTION",                                  -- objective type
    {
        
		"faction 3k_main_faction_yuan_shao",
		"total 5"
    },    
    {
        "money 3000"
    },                                                  -- mission rewards (table of strings)
	success_key.."incident_set",      -- trigger event 
	function(context) return true end,	-- Listener condition
	false,												-- Fire once
	success_key.."yuanshao_armies_beaten",		-- completion event
	success_key.."yuanshao_armies_beaten",		-- failure event
	"CLAN_ELDERS"							--mission_issuer
);


-------------------

--After  to see if Yuan Shao is alive and an AI, if true, kill him 10 turns after capture Anping mission completed and trigger incident, if not keep him alive for MP
core:add_listener("event_name", "MissionSucceeded",
    function(context)
        return context:mission():mission_record_key() == "3k_dlc07_mission_guandu_cao_cao_anping"
    end,
    function(context)
        if not cm:saved_value_exists("cao_cao_takes_yuan_shao_capital_turn", "dlc07_cao_cao_events") then
            cm:set_saved_value("cao_cao_takes_yuan_shao_capital_turn", cm:turn_number(), "dlc07_cao_cao_events")
        end
    end,
    true
)
core:add_listener(
    listener_key .. "the_death_of_yuan_shao", -- Unique handle
    "ScriptEventHumanFactionTurnStart", -- Campaign Event to listen for
    function(context) -- Criteria
        return cm:saved_value_exists("cao_cao_takes_yuan_shao_capital_turn", "dlc07_cao_cao_events")
            and cdir_mission_manager:get_turn_number() >= cm:get_saved_value("cao_cao_takes_yuan_shao_capital_turn", "dlc07_cao_cao_events") + 10
            and context:faction():name() == local_faction_key
            and not cm:query_model():character_for_template("3k_main_template_historical_yuan_shao_hero_earth"):is_dead()
        end,
    function() -- What to do if listener fires.
        if not cm:query_model():character_for_template("3k_main_template_historical_yuan_shao_hero_earth"):faction():is_human() then
            local q_char = cm:query_model():character_for_template("3k_main_template_historical_yuan_shao_hero_earth");
            cm:modify_character(q_char):kill_character(false);
            cm:trigger_incident(local_faction_key, "3k_dlc07_incident_cao_cao_yuan_shao_illness");
        else
            core:trigger_event(failure_key.."yuan_shao_lives");
            output("3k_main_faction_cao_cao_events.lua: Yuan Shao is Human, the '3k_dlc07_incident_cao_cao_yuan_shao_illness' death event will not be triggered");
        end
    end,
    false --Is persistent
);

------------------------

-- check to see if yuan shao is dead, if so trigger mourning Yuan Shao Incident 
core:add_listener(
	listener_key .. "mourning_yuan_shao", -- Unique handle
	"ScriptEventHumanFactionTurnStart", -- Campaign Event to listen for
	function(context) -- Criteria
		return cdir_mission_manager:get_turn_number() == 23 and
		context:faction():name() == local_faction_key and 
		cm:query_model():character_for_template("3k_main_template_historical_yuan_shao_hero_earth"):is_dead() and
		not cm:query_model():character_for_template("3k_main_template_historical_cao_cao_hero_earth"):is_dead()
	end,
	function() -- What to do if listener fires.
		cm:trigger_incident(local_faction_key, "3k_dlc07_incident_cao_cao_mourns_yuan_shao")
	end,
	false --Is persistent
);

-- Check to see if yuan shaos faction is dead and if Gongsun Du's is alive
core:add_listener(
	local_faction_key, -- Unique handle
	"ScriptEventHumanFactionTurnStart", -- Campaign Event to listen for
	function(context) -- Criteria
		return cdir_mission_manager:get_turn_number() == 40 and context:faction():name() == local_faction_key and
	    not cm:query_faction("3k_main_faction_gongsun_du"):is_dead() and
		cm:query_faction("3k_main_faction_yuan_shao"):is_dead()  
	end,
	function(context) -- What to do if listener fires.
		cm:trigger_incident(local_faction_key, "3k_dlc07_incident_cao_cao_gongsun_du");
	end,
	false --Is persistent
);

--  Side Mission 1a: 
cdir_mission_manager:start_mission_listener(
    local_faction_key,                          -- faction key
    "3k_dlc07_mission_guandu_cao_cao_occupy_gates",                     -- mission key
    "CONTROL_N_REGIONS_INCLUDING",                                  -- objective type
    {
        "total 2",
		"region 3k_dlc06_qi_pass",
		"region 3k_dlc06_gu_pass",
    },
    {
        "effect_bundle{bundle_key 3k_dlc07_mission_payload_guandu_conquered_gates;turns 6;}"
    },                                                  -- mission rewards (table of strings)
	"FactionTurnStart", -- trigger event 
	function(context)
		return cdir_mission_manager:get_turn_number() == 7 and context:faction():name() == local_faction_key
		 and context:faction():is_human();
	end,												-- Listener condition
	false,												-- Fire once
  	success_key.."gates_held",     -- completion event
	success_key.."gates_held",		-- failure event
	"3k_main_victory_objective_issuer"		-- mission_issuer
);

-- Does Gao Gan still exist?
core:add_listener(
	listener_key.."is_gao_gan_alive_check", -- Unique handle
	success_key.."gates_held", -- Campaign Event to listen for
	function() -- Criteria
		return 
		not cm:query_faction("3k_main_faction_gao_gan"):is_dead() 
		and not cm:query_faction("3k_main_faction_gao_gan"):has_specified_diplomatic_deal_with("treaty_components_alliance", cm:query_faction(local_faction_key))
		and not cm:query_faction("3k_main_faction_gao_gan"):has_specified_diplomatic_deal_with("treaty_components_coalition", cm:query_faction(local_faction_key))
		and not cm:query_faction("3k_main_faction_gao_gan"):has_specified_diplomatic_deal_with("treaty_components_vassalage", cm:query_faction(local_faction_key))
	end,
	function() -- What to do if listener fires.
		core:trigger_event(success_key .. "gao_gan_alive");
	end,
	false --Is persistent
);

--  Side Mission 1b: 
cdir_mission_manager:start_mission_listener(
    local_faction_key,                          -- faction key
    "3k_dlc07_mission_guandu_cao_cao_destroy_gao_gan",                     -- mission key
    "DESTROY_FACTION",                                  -- objective type
    {
        "faction 3k_main_faction_gao_gan"
    },
    {
        "money 4000"
    },                                                     -- mission rewards (table of strings)
	success_key.."gao_gan_alive",      -- trigger event
	nil,												-- Listener condition
	false,												-- Fire once
	success_key.."gaogan_destroyed",		-- completion event
	success_key.."gaogan_destroyed",		-- failure event
	"3k_main_victory_objective_issuer"							--mission_issuer
);

--  Side Mission 2a: 
cdir_mission_manager:start_mission_listener(
    local_faction_key,                          -- faction key
    "3k_dlc07_mission_guandu_cao_cao_occupy_langye",                     -- mission key
    "CONTROL_N_REGIONS_INCLUDING",                                  -- objective type
    {
        "total 3",
		"region 3k_main_langye_capital",
		"region 3k_main_langye_resource_1",
		"region 3k_main_langye_resource_2",
    },
    {
        "effect_bundle{bundle_key 3k_dlc07_mission_payload_guandu_langya_conquest;turns 6;}"
    },                                                  -- mission rewards (table of strings)
	"FactionTurnStart", -- trigger event 
	function(context)
		return cdir_mission_manager:get_turn_number() == 10 and context:faction():name() == local_faction_key
		 and context:faction():is_human();
	end,												-- Listener condition
	false,												-- Fire once
  	success_key.."langye_held",     -- completion event
	success_key.."langye_held",		-- failure event
	"3k_main_victory_objective_issuer"		-- mission_issuer
);

--  Side Mission 2b: 
cdir_mission_manager:start_mission_listener(
    local_faction_key,                          -- faction key
    "3k_dlc07_mission_guandu_cao_cao_destroy_yuan_tan",                     -- mission key
    "DESTROY_FACTION",                                  -- objective type
    {
        "faction 3k_dlc05_faction_yuan_tan"
    },
    {
        "money 4000"
    },                                                     -- mission rewards (table of strings)
	success_key.."langye_held",      -- trigger event
	function()
		return not cm:query_faction("3k_dlc05_faction_yuan_tan"):is_dead()
	end,												-- Listener condition
	false,												-- Fire once
	success_key.."yuanTan_destroyed",		-- completion event
	success_key.."yuanTan_destroyed",		-- failure event
	"3k_main_victory_objective_issuer"							--mission_issuer
);

--  Side Mission 3: 
cdir_mission_manager:start_mission_listener(
    local_faction_key,                          -- faction key
    "3k_dlc07_mission_guandu_cao_cao_occupy_jing_and_xiang",                     -- mission key
    "CONTROL_N_REGIONS_INCLUDING",                                  -- objective type
    {
        "total 4",
		"region 3k_main_xiangyang_capital",
		"region 3k_main_xiangyang_resource_1",
		"region 3k_main_jingzhou_resource_1",
		"region 3k_main_jingzhou_capital",
		
    },
    {
        "money 5000"
    },                                                  -- mission rewards (table of strings)
	"ScriptEventHumanFactionTurnStart",      -- trigger event
	function(context) -- Criteria
		return cdir_mission_manager:get_turn_number() == 42 and context:faction():name() == local_faction_key;
	end,												-- Listener condition
	false,												-- Fire once
  	success_key.."jing_taken",     -- completion event
	success_key.."jing_taken",		-- failure event
	--true 
	"3k_main_victory_objective_issuer"		-- mission_issuer
	
	
);

--***********************Post-Yuan Shao's Death Arc****************************

-- Post War Optional Mission 1:
cdir_mission_manager:start_mission_listener(
    local_faction_key,                          -- faction key
    "3k_dlc07_mission_guandu_cao_cao_destroy_remaining_allies",                     -- mission key
    "DESTROY_FACTION",                                  -- objective type
    {
		"faction 3k_dlc07_faction_yuan_xi",
		"faction 3k_main_faction_liu_bei",

    },
    {
        "money 4000"
    },                                                     -- mission rewards (table of strings)
	success_key.."yuanshao_destroyed",      -- trigger event
	function() -- Criteria
		return not cm:query_faction("3k_dlc07_faction_yuan_xi"):is_dead() or
		not cm:query_faction("3k_main_faction_liu_bei"):is_dead()
	end,												-- Listener condition
	false,												-- Fire once
	success_key.."stragglers_destroyed",		-- completion event
	success_key.."stragglers_destroyed",		-- failure event
	"3k_main_victory_objective_issuer"							--mission_issuer
);

-- Post War Optional Mission 2:
cdir_mission_manager:start_mission_listener(
    local_faction_key,                          -- faction key
    "3k_dlc07_mission_guandu_cao_cao_destroy_bandits",                     -- mission key
    "DESTROY_FACTION",                                  -- objective type
    {
		"faction 3k_main_faction_zheng_jiang",
		"faction 3k_main_faction_zhang_yan",
		"faction 3k_dlc05_faction_xu_zhao",
    },
    {
		"effect_bundle{bundle_key 3k_dlc07_mission_payload_guandu_pacified_bandits;turns 5;}",
		"money 3500"
    },                                                     -- mission rewards (table of strings)
	success_key.."yuanshao_destroyed",      -- trigger event
	function() -- Criteria
		return not cm:query_faction("3k_main_faction_zheng_jiang"):is_dead() or
		not cm:query_faction("3k_main_faction_zhang_yan"):is_dead() or
		not cm:query_faction("3k_dlc05_faction_xu_zhao"):is_dead()
	end,												-- Listener condition
	false,												-- Fire once
	success_key.."bandits_destroyed",		-- completion event
	success_key.."bandits_destroyed",		-- failure event
	"3k_main_victory_objective_issuer"							--mission_issuer
);

-- Post War Optional Mission 3: 
cdir_mission_manager:start_mission_listener(
    local_faction_key,                          -- faction key
    "3k_dlc07_mission_guandu_cao_cao_occupy_danyang",                     -- mission key
    "CONTROL_N_REGIONS_INCLUDING",                                  -- objective type
    {
        "total 1",
		"region 3k_main_jianye_capital",
    },
    {
        "effect_bundle{bundle_key 3k_dlc07_mission_payload_guandu_opening_move;turns 6;}"
    },                                                  -- mission rewards (table of strings)
	success_key.."yuanshao_destroyed",      -- trigger event
	function() return not cm:query_faction("3k_dlc05_faction_sun_ce"):is_dead()
		and cm:query_region("3k_main_jianye_capital"):owning_faction():name() == "3k_dlc05_faction_sun_ce" 
	end,	-- Listener condition
	false,												-- Fire once
  	success_key.."hold_jianye",     -- completion event
	success_key.."hold_jianye",		-- failure event
	"3k_main_victory_objective_issuer"		-- mission_issuer
);

-- Fire final incident
cdir_mission_manager:start_incident_db_listener(
	local_faction_key, -- faction_key 
	"3k_dlc07_incident_guandu_victor_sun_clan_incident", -- event_key 
	success_key.."hold_jianye", -- trigger event 
	function()
		return not cm:query_faction("3k_dlc05_faction_sun_ce"):is_dead()
	end, --listener condition
	false, -- fire_once.
	success_key.."post_conflict_3_complete_incident", -- completion event 
	nil -- failure event
);
--#endregion

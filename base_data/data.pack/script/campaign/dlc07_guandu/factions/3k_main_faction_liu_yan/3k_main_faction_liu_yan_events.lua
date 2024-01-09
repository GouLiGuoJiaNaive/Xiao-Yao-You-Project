--[[
***************************************************
***************************************************
** VARIABLES
***************************************************
***************************************************
]]--
local local_faction_key = "3k_main_faction_liu_yan";
local listener_key = "dlc07_" .. local_faction_key .. "_";
local success_key = "dlc07_" .. local_faction_key .. "_success_";
local failure_key = "dlc07_" .. local_faction_key .. "_failure_";

output("Events script loaded for " .. local_faction_key);

-- Handles REACH_FACTION_RANK and VICTORY CONDITION missions for factions.
dlc07_shared_progression_missions:setup_han_progression_missions(local_faction_key);
dlc07_shared_progression_missions:setup_han_victory_missions(local_faction_key);

local function initial_set_up()

end;

cm:add_first_tick_callback_new(initial_set_up);


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
	"3k_dlc07_introduction_liu_yan_incident_200", -- event_key 
	"FactionTurnStart", -- trigger event 
	function(context)
		return cdir_mission_manager:get_turn_number() == 1 and context:faction():name() == local_faction_key;
	end, --listener condition
	false, -- fire_once.
	success_key.."intro_fired", -- completion event 
	nil -- failure event
);

-- #endregion

-- sons died 190 event
cdir_mission_manager:start_incident_db_listener(
	local_faction_key, -- faction_key 
	"3k_dlc07_incident_liu_yan_death_of_sons_didnt_save_them", -- event_key 
	"FactionTurnStart", -- trigger event 
	function(context)
		local event_gen = cm:query_model():event_generator_interface()
		local q_faction = cm:query_faction(local_faction_key)

		local q_liu_fan = cm:query_model():character_for_template("3k_dlc07_template_historical_liu_fan_hero_earth")
		local q_liu_dan = cm:query_model():character_for_template("3k_dlc07_template_historical_liu_dan_hero_wood")

		if q_liu_fan:is_null_interface() or q_liu_dan:is_null_interface() then
			return false
		end

		return event_gen:have_any_of_incidents_been_generated(q_faction, "3k_main_historical_dong_chain_plot_npc_02_incident")
		 and event_gen:have_any_of_dilemmas_been_generated(q_faction, "3k_dlc07_dilemma_liu_yan_save_sons")
		 and event_gen:dilemma_choice_made(q_faction, "3k_dlc07_dilemma_liu_yan_save_sons") == 1
		 and not q_liu_fan:is_dead() and not q_liu_fan:faction():is_human()
		 and not q_liu_dan:is_dead() and not q_liu_dan:faction():is_human()

	end, --listener condition
	false, -- fire_once.
	success_key.."tragedy_in_capital_fired", -- completion event 
	nil -- failure event
);

-- #region Progression

--[[
***************************************************
***************************************************
** PROGRESSION MISSIONS
***************************************************
***************************************************
]]--

start_tutorial_mission_listener(
    local_faction_key,                          -- faction key
    "3k_dlc07_progression_liu_yan_200_attack_force",                     -- mission key
    "ENGAGE_FORCE",                                  -- objective type
    {
        "faction 3k_dlc07_faction_zhang_lu",
        "armies_only"
    },                                                  -- conditions (single string or table of strings)
    {
        "effect_bundle{bundle_key 3k_main_introduction_mission_payload_defeat_force;turns 3;}"
    },                                                  -- mission rewards (table of strings)
    success_key.."intro_fired",      -- trigger event 
    success_key.."army_attacked"     -- completion event
)



cdir_mission_manager:start_mission_db_listener(
	local_faction_key, -- faction_key 
	"3k_dlc07_progression_liu_yan_200_attack_settlement", -- event_key 
	success_key.."army_attacked", -- trigger event 
	function(context)
		return true;
	end, --listener condition
	false, -- fire_once.
	success_key.."settlement_attacked", -- completion event 
	failure_key.."settlement_attacked", -- failure event
	false -- delay start
);

start_tutorial_mission_listener(
    local_faction_key,                          -- faction key
    "3k_dlc07_progression_liu_yan_200_raise_army",                     -- mission key
    "OWN_N_UNITS",                                  -- objective type
    {
        2
    },                                                  -- conditions (single string or table of strings)
    {
        "effect_bundle{bundle_key 3k_main_introduction_mission_payload_recruit_units;turns 3;}"
    },                                                  -- mission rewards (table of strings)
    success_key.."settlement_attacked",      -- trigger event 
    success_key.."army_raised"     -- completion event
)

-- Destroy Zhang Lu
cdir_mission_manager:start_mission_listener(
    local_faction_key,                          -- faction key
    "3k_dlc07_mission_liu_zhang_zhang_lu",                     -- mission key
    "DESTROY_FACTION",                                  -- objective type
    {
        "faction 3k_dlc07_faction_zhang_lu"
    },   
    {
        "money 5000"
    },                                                    -- mission rewards (table of strings)
	success_key.."army_raised",      -- trigger event 
	nil,												-- Listener condition
	false,												-- Fire once
	success_key.."zhang_lu",		-- completion event
	success_key.."zhang_lu",		-- failure event
	"3k_main_victory_objective_issuer"							--mission_issuer
);

--Check to see if Cao Cao is still alive, and if so trigger the Cao Cao dilemma
core:add_listener(
	listener_key.."cao_cao_alive_check", -- Unique handle
	success_key.."zhang_lu", -- Campaign Event to listen for
	function()
		return not cm:query_faction("3k_main_faction_cao_cao"):is_dead()
			and not cm:query_faction("3k_main_faction_cao_cao"):has_specified_diplomatic_deal_with("treaty_components_vassalage", cm:query_faction(local_faction_key))
			and not cm:query_faction("3k_main_faction_cao_cao"):has_specified_diplomatic_deal_with("treaty_components_alliance", cm:query_faction(local_faction_key))
			and not cm:query_faction("3k_main_faction_cao_cao"):has_specified_diplomatic_deal_with("treaty_components_coalition", cm:query_faction(local_faction_key))
	end, --listener condition
	function() -- What to do if listener fires.

		core:trigger_event(success_key .. "cao_cao_dilemma");

	end,
	false --Is persistent
);

--Cao Cao dilemma to be vassalised or go to war
cdir_mission_manager:start_dilemma_db_listener(
	local_faction_key, --faction_key
	"3k_dlc07_dilemma_liu_zhang_cao_cao", --event_key
	success_key.."cao_cao_dilemma", --trigger_event
	function(context)
		return true
	end, --listener condition
	false, -- fire_once.
	nil, -- completion event 
	nil, -- failure event
	false, -- delay start
	nil, -- on trigger event
	success_key.."no_fight_cao_cao", -- Don't fight Cao Cao
	success_key.."yes_fight_cao_cao" -- Fight Cao Cao
);

--Trigger war with cao cao and mission to fight him
core:add_listener(
	listener_key .. "cao_cao_war", -- Unique handle
	success_key.."yes_fight_cao_cao", -- Campaign Event to listen for
	function()
		return true
	end, --listener condition
	function() -- What to do if listener fires.

		core:trigger_event(success_key .. "cao_cao_war");

	end,
	false --Is persistent
);

--Cao Cao vassalises Liu Zhang. Trigger a mission to build up and declare war on him
core:add_listener(
	listener_key .. "cao_cao_no_war", -- Unique handle
	success_key.."no_fight_cao_cao", -- Campaign Event to listen for
	function()
		return true
	end, --listener condition
	function() -- What to do if listener fires.

		core:trigger_event(success_key .. "cao_cao_no_war");

	end,
	false --Is persistent
);

-- Build up to oppose Cao Cao
cdir_mission_manager:start_mission_db_listener(
	local_faction_key, -- faction_key 
	"3k_dlc07_mission_liu_zhang_build_forces", -- event_key 
	success_key .. "cao_cao_no_war", -- trigger event 
	function()
		return true;
	end, --listener condition
	false, -- fire_once.
	success_key.."cao_cao_war", -- completion event 
	nil,
	false -- delay start
);


-- Destroy Cao Cao
cdir_mission_manager:start_mission_listener(
    local_faction_key,                          -- faction key
    "3k_dlc07_mission_liu_zhang_cao_cao",                     -- mission key
    "HAVE_DIPLOMATIC_RELATIONSHIP",                                  -- objective type
	{
		"faction 3k_main_faction_cao_cao",
		"treaty_component_set 3k_dlc06_objective_treaties_vassal_or_dead",
		"succeed_on_faction_death"
	},     	
    {
        "money 5000"
    },                                                    -- mission rewards (table of strings)
	success_key.."cao_cao_war",      -- trigger event 
	nil,												-- Listener condition
	false,												-- Fire once
	success_key.."cao_cao_defeated",		-- completion event
	success_key.."cao_cao_defeated",		-- failure event
	"3k_main_victory_objective_issuer"							--mission_issuer
);

--Zhao Wei rebels!
core:add_listener(
	listener_key .. "zhao_wei_rebels", -- Unique handle
	"ScriptEventHumanFactionTurnStart", -- Campaign Event to listen for
	function(context) -- Criteria
		return context:faction():name() == local_faction_key
		and cm:has_incident_fired_for_faction(local_faction_key, "3k_dlc07_incident_liu_zhang_zhao_wei_rebellion")
		and not cm:has_mission_fired_for_faction(local_faction_key, "3k_dlc07_mission_liu_zhang_zhao_wei")
	end,
	function() -- What to do if listener fires.

		local zhao_wei = campaign_invasions:create_invasion("3k_main_faction_liu_yan_separatists", "3k_main_chengdu_capital", 3, true, local_faction_key);
		zhao_wei:create_general(true, "3k_general_water", "3k_main_template_historical_zhao_wei_hero_water"); -- override the given general with our own one.
		zhao_wei:set_target("NONE", nil, local_faction_key);
		zhao_wei:start_invasion();

		core:trigger_event(success_key .. "zhao_wei_incident");

	end,
	false --Is persistent
);

-- Zhao Wei rebellion incident
cdir_mission_manager:start_incident_db_listener(
	local_faction_key, -- faction_key 
	"3k_dlc07_incident_liu_zhang_zhao_wei_rebellion", -- event_key 
	"ScriptEventHumanFactionTurnStart", -- trigger event 
	function(context)
		return context:faction():name() == local_faction_key
		and cdir_mission_manager:get_turn_number() == 5;
	end, --listener condition
	false, -- fire_once.
	success_key .. "zhao_wei_mission", -- completion event 
	success_key .. "zhao_wei_mission", -- failure event
	false -- delay start
);

-- Zhao Wei rebellion mission
cdir_mission_manager:start_mission_listener(
    local_faction_key,                          -- faction key
    "3k_dlc07_mission_liu_zhang_zhao_wei",                     -- mission key
    "DESTROY_FACTION",                                  -- objective type
    {
		"faction 3k_main_faction_liu_yan_separatists"
    },   
    {
        "money 5000"
    },                                                    -- mission rewards (table of strings)
	success_key.."zhao_wei_incident",      -- trigger event 
	nil,												-- Listener condition
	false,												-- Fire once
	success_key.."zhao_wei_defeated",		-- completion event
	success_key.."zhao_wei_defeated",		-- failure event
	"3k_main_victory_objective_issuer"							--mission_issuer
);

-- Destroy the Nanman
cdir_mission_manager:start_mission_listener(
    local_faction_key,                          -- faction key
    "3k_dlc07_mission_liu_zhang_nanman",                     -- mission key
    "DESTROY_FACTION",                                  -- objective type
    {
		"faction 3k_dlc06_faction_nanman_king_meng_huo",
		"faction 3k_dlc06_faction_nanman_king_mulu",
		"faction 3k_dlc06_faction_nanman_king_shamoke"
    },   
    {
        "money 5000"
    },                                                    -- mission rewards (table of strings)
	success_key.."zhao_wei_defeated",      -- trigger event 
	nil,												-- Listener condition
	false,												-- Fire once
	success_key.."nanman_defeated",		-- completion event
	success_key.."nanman_defeated",		-- failure event
	"3k_main_victory_objective_issuer"							--mission_issuer
);

-- Destroy Liu Biao
cdir_mission_manager:start_mission_listener(
    local_faction_key,                          -- faction key
    "3k_dlc07_mission_liu_zhang_liu_biao",                     -- mission key
    "DESTROY_FACTION",                                  -- objective type
    {
		"faction 3k_main_faction_liu_biao"
    },   
    {
        "money 5000"
    },                                                    -- mission rewards (table of strings)
	success_key.."army_raised",      -- trigger event 
	nil,												-- Listener condition
	false,												-- Fire once
	success_key.."liu_biao_defeated",		-- completion event
	success_key.."liu_biao_defeated",		-- failure event
	"3k_main_victory_objective_issuer"							--mission_issuer
);

-- #endregion
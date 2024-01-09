--[[
***************************************************
***************************************************
** VARIABLES
***************************************************
***************************************************
]]--
local local_faction_key = "3k_main_faction_liu_bei";
local listener_key = "dlc07_" .. local_faction_key .. "_";
local success_key = "dlc07_" .. local_faction_key .. "_success_";
local failure_key = "dlc07_" .. local_faction_key .. "_failure_";

output("Events script loaded for " .. local_faction_key);

-- Handles REACH_FACTION_RANK and VICTORY CONDITION missions for factions.
dlc07_shared_progression_missions:setup_han_progression_missions(local_faction_key);
dlc07_shared_progression_missions:setup_han_victory_missions(local_faction_key);

local function initial_set_up()
	-- Fire starting incident + trigger opening mission
	cm:trigger_incident(local_faction_key, "3k_dlc07_introduction_liu_bei_incident")
	core:trigger_event(success_key.."incident_set")

end;
cm:add_first_tick_callback_new(initial_set_up);

-- Mission & Dilemma Turns:
-- 1 - Cao Cao War Arc Trigger
-- 19 - Unity Mission Trigger
-- 25 - Jing Province Arc Trigger
-- 34 - Wu Dilemma Trigger
-- 41 - Western China Arc Trigger

-- #region Intro
--[[
***************************************************
***************************************************
** 1 - GAUNDU & CONFLICT WITH CAO CAO Arc
***************************************************
***************************************************
]]--

--  Progression Mission 1: Take Xiapi
cdir_mission_manager:start_mission_listener(
    local_faction_key,                          -- faction key
    "3k_dlc07_mission_liu_bei_opening_xiapi",                     -- mission key
    "CONTROL_N_REGIONS_INCLUDING",                                  -- objective type
    {
        "total 1",
		"region 3k_dlc06_xiapi_resource_1",
    },
    {
        "money 2000"
    },                                                  -- mission rewards (table of strings)
	success_key.."incident_set",      -- trigger event
	nil,												-- Listener condition
	false,												-- Fire once
  	success_key.."startposarmy_beaten",     -- completion event
	success_key.."startposarmy_beaten",		-- failure event
	"3k_main_victory_objective_issuer"		-- mission_issuer
);

-- Progression Mission 2: Recruit X units
cdir_mission_manager:start_mission_listener(
	local_faction_key, -- faction_key                        -- faction key
    "3k_dlc07_mission_liu_bei_recruit_units", -- event_key
    "OWN_N_UNITS",                                  -- objective type
    {
        4       -- no of units
    },
    {
		"effect_bundle{bundle_key 3k_main_introduction_mission_payload_recruit_units;turns 3;}",
		"effect_bundle{bundle_key 3k_main_effect_bundle_action_increase_replenishment;turns 3;}"

    },                                                  -- mission rewards (table of strings)
	success_key.."startposarmy_beaten",      -- trigger event
	nil,
	false,
	success_key.."units_recruited",     -- completion event
	success_key.."units_recruited"     -- completion event

)

-- Progression Mission 3a: Control X Regions from Cao Cao
cdir_mission_manager:start_mission_listener(
    local_faction_key,                          -- faction key
    "3k_dlc07_mission_liu_bei_north",                     -- mission key
    "CONTROL_N_REGIONS_INCLUDING",                                  -- objective type
    {
        "total 2",
		"region 3k_main_langye_resource_1",
		"region 3k_main_dongjun_resource_1",
    },
    {
        "money 3000"
    },                                                  -- mission rewards (table of strings)
	success_key.."units_recruited",      -- trigger event
	nil,												-- Listener condition
	false,												-- Fire once
  	success_key.."north_secured",     -- completion event
	success_key.."north_secured",														-- failure event
	"3k_main_victory_objective_issuer"							--mission_issuer
);

-- Progression Mission 3b: Control Temple Region
cdir_mission_manager:start_mission_listener(
    local_faction_key,                          -- faction key
    "3k_dlc07_mission_liu_bei_zheng_jiang",                     -- mission key
    "CONTROL_N_REGIONS_INCLUDING",                                  -- objective type
    {
        "total 1",
		"region 3k_main_penchang_resource_1",
    },
    {
        "money 1200"
    },                                                  -- mission rewards (table of strings)
	success_key.."units_recruited",      -- trigger event
	nil,												-- Listener condition
	false,												-- Fire once
  	success_key.."north_secured",     -- completion event
	success_key.."north_secured",														-- failure event
	"3k_main_victory_objective_issuer"							--mission_issuer
);

-- Progression Mission 4: Control Chen
cdir_mission_manager:start_mission_listener(
    local_faction_key,                          -- faction key
    "3k_dlc07_mission_liu_bei_chen",                     -- mission key
    "CONTROL_N_REGIONS_INCLUDING",                                  -- objective type
    {
        "total 1",
		"region 3k_main_chenjun_capital",
    },
    {
        "money 1500"
    },                                                  -- mission rewards (table of strings)
	success_key.."north_secured",      -- trigger event
	nil,												-- Listener condition
	false,												-- Fire once
  	success_key.."chen_secured",     -- completion event
	success_key.."chen_secured",														-- failure event
	"3k_main_victory_objective_issuer"							--mission_issuer
);

-- Progression Mission 5: Destroy Cao Cao
cdir_mission_manager:start_mission_listener(
    local_faction_key,                          -- faction key
    "3k_dlc07_mission_liu_bei_destroy_cao_cao",                     -- mission key
    "DESTROY_FACTION",                                  -- objective type
    {
        "faction 3k_main_faction_cao_cao"
    },
    {
        "money 5000"
    },                                                     -- mission rewards (table of strings)
	success_key.."chen_secured",      -- trigger event
	nil,												-- Listener condition
	false,												-- Fire once
	success_key.."caocao_destroyed",		-- completion event
	success_key.."caocao_destroyed",		-- failure event
	"3k_main_victory_objective_issuer"							--mission_issuer
);

cdir_mission_manager:start_incident_db_listener(
	local_faction_key, -- faction_key
	"3k_dlc07_progression_liu_bei_end_incident", -- event_key
	success_key .. "caocao_destroyed", -- trigger event
	function(context)
		return true;
	end, --listener condition
	false, -- fire_once.
	success_key.."future", -- completion event
	nil, -- failure event
	true -- delay start
);


-- ##### Setup Optional Mission: Destroy Chen Deng ##### --
--Is Chen Deng: alive, not a vassal or at war? trigger dilemma if yes.
core:add_listener(
	listener_key.."chen_dengcheck", -- Unique handle
	success_key.."north_secured", -- Campaign Event to listen for
	function()
		return not cm:query_faction("3k_dlc07_faction_chen_deng"):is_dead() 
		and not diplomacy_manager:is_at_war_with("3k_dlc07_faction_chen_deng", local_faction_key)
		and not cm:query_faction("3k_dlc07_faction_chen_deng"):has_specified_diplomatic_deal_with("treaty_components_vassalage", cm:query_faction(local_faction_key))
		end, --listener condition
	function() -- What to do if listener fires.

		core:trigger_event(success_key .. "verified_chendeng");

	end,
	false --Is persistent
);

-- Dilemma: fight chen deng or not
cdir_mission_manager:start_dilemma_db_listener(
	local_faction_key, --faction_key
	"3k_dlc07_dilemma_liu_bei_chen_deng", --event_key
	success_key.."verified_chendeng", --trigger_event
	function(context)
		return true
	end, --listener condition
	false, -- fire_once.
	nil, -- completion event 
	nil, -- failure event
	false, -- delay start
	nil, -- on trigger event
	success_key.."no_war_chen_deng", -- No War
	success_key.."war_chen_deng" -- War
);

--War with Chen Deng activates + mission to destroy him fires
core:add_listener(
	listener_key .. "fight_chendeng", -- Unique handle
	success_key.."war_chen_deng", -- Campaign Event to listen for
	function()
		return true
	end, --listener condition
	function() -- What to do if listener fires.

		if not diplomacy_manager:is_at_war_with("3k_dlc07_faction_chen_deng", local_faction_key) then
			diplomacy_manager:force_declare_war(local_faction_key, "3k_dlc07_faction_chen_deng", false);
		end

		core:trigger_event(success_key .. "chendeng_war_activate");

	end,
	false --Is persistent
);

-- Optional Mission 1: Destroy Chen Deng
cdir_mission_manager:start_mission_listener(
    local_faction_key,                          -- faction key
    "3k_dlc07_mission_liu_bei_destroy_chen_deng",                     -- mission key
    "DESTROY_FACTION",                                  -- objective type
    {
        "faction 3k_dlc07_faction_chen_deng"
    },
    {
        "money 3000"
    },                                                     -- mission rewards (table of strings)
	success_key.."chendeng_war_activate",      -- trigger event
	nil,												-- Listener condition
	false,												-- Fire once
	success_key.."chendeng_destroyed",		-- completion event
	success_key.."chendeng_destroyed",		-- failure event
	"3k_main_victory_objective_issuer"							--mission_issuer
);


-- Setup Dilemma: Is Cao Cao and Wu still alive by turn X? if yes fire dilemma
core:add_listener(
	listener_key .. "intro_start", -- Unique handle
	"FactionTurnStart", -- Campaign Event to listen for
	function(context) -- Criteria
		return cdir_mission_manager:get_turn_number() == 34 
		and context:faction():name() == local_faction_key
		and not cm:query_faction("3k_main_faction_cao_cao"):is_dead();
	end,
	function(context) -- What to do if listener fires.
		core:trigger_event(success_key .. "wu_aid");
	end,
	false --Is persistent
);

-- Dilemma: Sun Quan CEO Dilemma
cdir_mission_manager:start_dilemma_db_listener(
	local_faction_key, --faction_key
	"3k_dlc07_dilemma_liu_bei_aided_by_sun_quan", --event_key
	success_key.."wu_aid", --trigger_event
	function(context)
		return true
	end, --listener condition
	false, -- fire_once.
	nil, -- completion event 
	nil, -- failure event
	false, -- delay start
	nil, -- on trigger event
	success_key.."gift_1", -- Follower
	success_key.."gift_2", -- Mount
	success_key.."gift_3", -- Follower + Mount, lose diplomatic standing
	success_key.."gift_4" -- Gain diplomatic standing
);

core:add_listener(
	listener_key .. "intro_start", -- Unique handle
	"FactionTurnStart", -- Campaign Event to listen for
	function(context) -- Criteria
		return cdir_mission_manager:get_turn_number() == 19 and context:faction():name() == local_faction_key;
	end,
	function(context) -- What to do if listener fires.
		core:trigger_event(success_key .. "unity_gain");
	end,
	false --Is persistent
);

cdir_mission_manager:start_mission_listener(
    local_faction_key,                          -- faction key
	"3k_dlc07_mission_liu_bei_unity_gain",      -- mission key
	"POOLED_RESOURCE_TOTAL_AT_LEAST_X",						-- objective type
    {
		"pooled_resource 3k_main_pooled_resource_unity",
        "total 250"
    }, 
    {
        "money 3500"
    },				             
	success_key.."unity_gain",      -- trigger event
	nil,											-- Listener condition
	false,												-- Fire once
  	success_key.."unity_achieved",     -- completion event
	nil,
	"3k_main_victory_objective_issuer"							--mission_issuer
);

--[[
***************************************************
***************************************************
** 2 - JING PROVINCE Arc
***************************************************
***************************************************
]]--

core:add_listener(
	listener_key .. "intro_start", -- Unique handle
	"FactionTurnStart", -- Campaign Event to listen for
	function(context) -- Criteria
		return cdir_mission_manager:get_turn_number() == 25 and context:faction():name() == local_faction_key;
	end,
	function(context) -- What to do if listener fires.
		core:trigger_event(success_key .. "jing_arc");
	end,
	false --Is persistent
);

-- Xiapi originally, TEST SCRIPT for success_keys and followups
cdir_mission_manager:start_mission_db_listener(
	local_faction_key, -- faction_key
	"3k_dlc07_mission_liu_bei_goto_jing", -- event_key
	success_key.."jing_arc", -- trigger event
	nil,
	false, -- fire_once.
	success_key.."xiapi", -- completion event
	failure_key.."xiapi", -- failure event
	false -- delay start
	-- "3k_main_victory_objective_issuer"
);

-- Zhuge Liang main game Dilemmas.
cdir_mission_manager:start_dilemma_db_listener(
	local_faction_key, --faction_key
	"3k_dlc07_dilemma_liu_zhuge_liang_pc_01_no_xu_shu_early_dilemma", --event_key
	success_key.."xiapi", --trigger_event
	function()
		return true
	end, --listener condition
	false, -- fire_once.
	nil, -- completion event
	nil, -- failure event
	false, -- delay start
	nil, -- on trigger event
	success_key.."come_back_pt1", -- return at a later date
	success_key.."leave" -- end the dilemma chain option
);

cdir_mission_manager:start_dilemma_db_listener(
	local_faction_key, --faction_key
	"3k_main_historical_liu_zhuge_liang_pc_02_dilemma", --event_key
	success_key.."come_back_pt1", --trigger_event
	function()
		return true
	end, --listener condition
	false, -- fire_once.
	nil, -- completion event
	nil, -- failure event
	true, -- delay start
	nil, -- on trigger event
	success_key.."come_back_pt2", -- return at a later date
	success_key.."leave" -- end the dilemma chain option
);

cdir_mission_manager:start_dilemma_db_listener(
	local_faction_key, --faction_key
	"3k_main_historical_liu_zhuge_liang_pc_03_dilemma", --event_key
	success_key.."come_back_pt2", --trigger_event
	function()
		return true
	end, --listener condition
	false, -- fire_once.
	nil, -- completion event
	nil, -- failure event
	true, -- delay start
	nil, -- on trigger event
	success_key.."come_back_pt3", -- return at a later date
	success_key.."leave" -- end the dilemma chain option
);

-- Give faction Zhuge Liang
cdir_mission_manager:start_incident_db_listener(
	local_faction_key, -- faction_key
	"3k_main_historical_liu_zhuge_liang_pc_04_incident", -- event_key
	"come_back_pt3", -- trigger event
	function(context)
		return true;
	end, --listener condition
	false, -- fire_once.
	nil, -- completion event
	nil -- failure event
);

--[[
***************************************************
***************************************************
** 3 - WESTERN CHINA Arc
***************************************************
***************************************************
]]--

-- Initialise the chain.
core:add_listener(
	local_faction_key, -- Unique handle
	"ScriptEventHumanFactionTurnStart", -- Campaign Event to listen for
	function(context) -- Criteria
		return cdir_mission_manager:get_turn_number() == 41 and context:faction():name() == local_faction_key
		and not cm:query_faction("3k_main_faction_liu_yan"):is_dead()
		and not cm:query_region("3k_main_chengdu_capital"):is_abandoned()
		and cm:query_region("3k_main_chengdu_capital"):owning_faction():name() == "3k_main_faction_liu_yan";
	end,
	function(context) -- What to do if listener fires.
		core:trigger_event(success_key .. "liuzhang_wary");
	end,
	false --Is persistent
);

-- Liu Zhang shows trust in Liu Bei Incident 
cdir_mission_manager:start_incident_db_listener(
	local_faction_key, -- faction_key
	"3k_dlc07_progression_liu_bei_liu_zhang_wary_incident", -- event_key
	success_key .. "liuzhang_wary", -- trigger event
	function(context)
		return true;
	end, --listener condition
	false, -- fire_once.
	success_key.."goto_yi", -- completion event
	nil, -- failure event
	false -- delay start
);

-- Mission 1: Travel to Region (on next round)
cdir_mission_manager:start_mission_db_listener(
    local_faction_key,                          -- faction key
	"3k_dlc07_mission_liu_bei_goto_yi",                     -- mission key        
	success_key.."goto_yi",      -- trigger event
	function()
		return true;
	end,												-- Listener condition
	false,												-- Fire once
  	success_key.."yi_arrival",     -- completion event
	failure_key.."yi_arrival",	-- failure event
	true -- delay start
	-- "3k_main_victory_objective_issuer"							--mission_issuer
);

-- Dilemma: war or vassalise Liu Zhang
cdir_mission_manager:start_dilemma_db_listener(
	local_faction_key, --faction_key
	"3k_dlc07_dilemma_liu_bei_liu_zhang", --event_key
	success_key.."yi_arrival", --trigger_event
	function(context)
		return true
	end, --listener condition
	false, -- fire_once.
	nil, -- completion event 
	nil, -- failure event
	false, -- delay start
	nil, -- on trigger event
	success_key.."war_liuzhang", -- War
	success_key.."vassalise_liuzhang" -- Vassalise
);


--War with Liu Zhang activates + mission to destroy him fires
core:add_listener(
	listener_key .. "fight_liuzhang", -- Unique handle
	success_key.."war_liuzhang", -- Campaign Event to listen for
	function()
		return true
	end, --listener condition
	function() -- What to do if listener fires.

		if not diplomacy_manager:is_at_war_with("3k_main_faction_liu_yan", local_faction_key) then
			diplomacy_manager:force_declare_war(local_faction_key, "3k_main_faction_liu_yan", false);
		end

		core:trigger_event(success_key .. "liuzhang_war_activate");

	end,
	false --Is persistent
);

-- trigger mission to annex liu zhang after a delay. Liu Bei vassalises liu zhang. 
core:add_listener(
	listener_key .. "liuzhang_becomes_vassal", -- Unique handle
	success_key.."vassalise_liuzhang", -- Campaign Event to listen for
	function()
		return true
	end, --listener condition
	function() -- What to do if listener fires.

		if not cm:query_faction("3k_main_faction_liu_yan"):has_specified_diplomatic_deal_with("treaty_components_vassalage", cm:query_faction(local_faction_key))	 then
			cm:modify_faction(local_faction_key):apply_automatic_diplomatic_deal("treaty_components_vassalage", cm:query_faction("3k_main_faction_liu_yan"), local_faction_key);
		end

		core:trigger_event(success_key .. "liuzhang_becomes_vassal");

	end,
	false --Is persistent
);

-- Mission 2b: Destroy Liu Zhang's faction
cdir_mission_manager:start_mission_listener(
    local_faction_key,                          -- faction key
    "3k_dlc07_mission_liu_bei_destroy_liu_zhang",                     -- mission key
    "DESTROY_FACTION",                                  -- objective type
    {
        "faction 3k_main_faction_liu_yan"
    },
    {
        "money 3000"
    },                                                     -- mission rewards (table of strings)
	success_key.."liuzhang_war_activate",      -- trigger event
	nil,												-- Listener condition
	false,												-- Fire once
	success_key.."liuzhang_destroyed",		-- completion event
	success_key.."liuzhang_destroyed",		-- failure event
	"3k_main_victory_objective_issuer"							--mission_issuer
);
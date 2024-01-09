--[[
***************************************************
***************************************************
** VARIABLES
***************************************************
***************************************************
]]--
local local_faction_key = "3k_main_faction_zheng_jiang";
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

--Triggers the intro event, which starts off all progression missions
core:add_listener(
	listener_key .. "intro_start", -- Unique handle
	"FactionTurnStart", -- Campaign Event to listen for
	function(context) -- Criteria
		return cdir_mission_manager:get_turn_number() == 1 and context:faction():name() == local_faction_key;
	end,
	function(context) -- What to do if listener fires.
		core:trigger_event(success_key .. "fire_intro");
	end,
	false --Is persistent
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

-- Control Penchang
cdir_mission_manager:start_mission_listener(
    local_faction_key,                          -- faction key
    "3k_dlc07_mission_zheng_jiang_penchang",                     -- mission key
    "CONTROL_N_REGIONS_INCLUDING",                                  -- objective type
    {
        "total 1",
		"region 3k_main_penchang_capital"
    }, 
    {
        "money 5000"
    },                                                  -- mission rewards (table of strings)
	success_key.."fire_intro",      -- trigger event 
	nil,												-- Listener condition
	false,												-- Fire once
  	success_key.."penchang",     -- completion event
	success_key.."penchang",														-- failure event
	"3k_main_victory_objective_issuer"							--mission_issuer
);

-- Defeat 10 Cao Cao armies
cdir_mission_manager:start_mission_db_listener(
	local_faction_key, -- faction_key 
	"3k_dlc07_mission_zheng_jiang_fight_cao_cao", -- event_key 
	success_key.."penchang", -- trigger event 
	function(context)
		return true;
	end, --listener condition
	false, -- fire_once.
	success_key.."defeat_cao_cao_armies", -- completion event 
	nil,
	false -- delay start
);

-- Move to Region mission (delayed start by 1 turn)
cdir_mission_manager:start_mission_db_listener(
    local_faction_key,                          -- faction key
	"3k_dlc07_mission_zheng_jiang_goto_wei",                     -- mission key        
	success_key.."defeat_cao_cao_armies",      -- trigger event
	function()
		return true;
	end,												-- Listener condition
	false,												-- Fire once
  	success_key.."wei_arrival",     -- completion event
	failure_key.."wei_arrival",	-- failure event
	true -- delay start
	-- "3k_main_victory_objective_issuer"							--mission_issuer
);

-- Dilemma: Upon arriving in Wei, dilemma fires
cdir_mission_manager:start_dilemma_db_listener(
	local_faction_key, --faction_key
	"3k_dlc07_dilemma_zheng_jiang_banditry_wei", --event_key
	success_key.."wei_arrival", --trigger_event
	function(context)
		return true
	end, --listener condition
	false, -- fire_once.
	nil, -- completion event 
	nil, -- failure event
	false, -- delay start
	nil, -- on trigger event
	success_key.."steal_traders", -- Pillage everything
	success_key.."help_traders", -- Help them and accept payment
	success_key.."leave_traders" -- Leave them
);

-- Control Zhang Yan's lands
cdir_mission_manager:start_mission_listener(
    local_faction_key,                          -- faction key
    "3k_dlc07_mission_zheng_jiang_zhang_yan",                     -- mission key
    "CONTROL_N_REGIONS_INCLUDING",                                  -- objective type
    {
        "total 2",
		"region 3k_main_yanmen_capital",
		"region 3k_main_anping_resource_1"
    }, 
    {
        "money 5000"
    },                                                  -- mission rewards (table of strings)
	success_key.."defeat_cao_cao_armies",      -- trigger event 
	nil,												-- Listener condition
	false,												-- Fire once
  	success_key.."zhang_yan",     -- completion event
	success_key.."zhang_yan",														-- failure event
	"3k_main_victory_objective_issuer"							--mission_issuer
);

-- Control Xiapi
cdir_mission_manager:start_mission_listener(
    local_faction_key,                          -- faction key
    "3k_dlc07_mission_zheng_jiang_xiapi",                     -- mission key
    "CONTROL_N_REGIONS_INCLUDING",                                  -- objective type
    {
        "total 1",
		"region 3k_dlc06_xiapi_resource_1"
    }, 
    {
        "money 5000"
    },                                                  -- mission rewards (table of strings)
	success_key.."fire_intro",      -- trigger event 
	nil,												-- Listener condition
	false,												-- Fire once
  	success_key.."xiapi",     -- completion event
	success_key.."xiapi",														-- failure event
	"3k_main_victory_objective_issuer"							--mission_issuer
);

-- Control Liu Bei's lands
cdir_mission_manager:start_mission_listener(
    local_faction_key,                          -- faction key
    "3k_dlc07_mission_zheng_jiang_liu_bei",                     -- mission key
    "CONTROL_N_REGIONS_INCLUDING",                                  -- objective type
    {
        "total 3",
		"region 3k_dlc06_xiapi_capital",
		"region 3k_main_donghai_capital",
		"region 3k_main_donghai_resource_1"
    }, 
    {
        "money 5000"
    },                                                  -- mission rewards (table of strings)
	success_key.."xiapi",      -- trigger event 
	nil,												-- Listener condition
	false,												-- Fire once
  	success_key.."liu_bei",     -- completion event
	success_key.."liu_bei",														-- failure event
	"3k_main_victory_objective_issuer"							--mission_issuer
);


-- Control White Tiger Yan's lands
cdir_mission_manager:start_mission_listener(
    local_faction_key,                          -- faction key
    "3k_dlc07_mission_zheng_jiang_white_tiger",                     -- mission key
    "CONTROL_N_REGIONS_INCLUDING",                                  -- objective type
    {
        "total 2",
		"region 3k_main_xindu_capital",
		"region 3k_main_jianye_resource_1"
    }, 
    {
        "money 5000"
    },                                                  -- mission rewards (table of strings)
	success_key.."liu_bei",      -- trigger event 
	nil,												-- Listener condition
	false,												-- Fire once
  	success_key.."white_tiger",     -- completion event
	success_key.."white_tiger",									-- failure event
	"3k_main_victory_objective_issuer"							--mission_issuer
);

--Triggers the expansion mission event
core:add_listener(
	listener_key .. "intro_start", -- Unique handle
	"FactionTurnStart", -- Campaign Event to listen for
	function(context) -- Criteria
		return cdir_mission_manager:get_turn_number() == 20 and context:faction():name() == local_faction_key;
	end,
	function(context) -- What to do if listener fires.
		core:trigger_event(success_key .. "expand");
	end,
	false --Is persistent
);

-- Control 5 provinces
cdir_mission_manager:start_mission_listener(
    local_faction_key,                          -- faction key
    "3k_dlc07_mission_zheng_jiang_expand",                     -- mission key
    "OWN_N_PROVINCES",                                  -- objective type
    {
        "total 5"
    }, 
    {
        "money 5000"
    },                                                  -- mission rewards (table of strings)
	success_key.."expand",      -- trigger event 
	nil,												-- Listener condition
	false,												-- Fire once
  	success_key.."provinces",     -- completion event
	success_key.."provinces",									-- failure event
	"3k_main_victory_objective_issuer"							--mission_issuer
);
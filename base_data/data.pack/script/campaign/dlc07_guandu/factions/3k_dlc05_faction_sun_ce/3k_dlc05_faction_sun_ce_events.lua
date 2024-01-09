--[[
***************************************************
***************************************************
** VARIABLES
***************************************************
***************************************************
]]--
local local_faction_key = "3k_dlc05_faction_sun_ce";
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
	"ScriptEventHumanFactionTurnStart", -- Campaign Event to listen for
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

--  Recruit X units
cdir_mission_manager:start_mission_listener(
	local_faction_key, -- faction_key                        -- faction key
    "3k_dlc07_mission_sun_ce_recruit_units", -- event_key
    "OWN_N_UNITS",                                  -- objective type
    {
        8       -- no of units
    },
    {
		"money 1000"

    },                                                  -- mission rewards (table of strings)
	success_key.."fire_intro",      -- trigger event
	nil,
	false,
	success_key.."recruited_success",     -- completion event
	success_key.."recruited_success"     -- completion event
)

-- Beat 3 of Hua Xin's forces
cdir_mission_manager:start_mission_db_listener(
	local_faction_key, -- faction_key 
	"3k_dlc07_mission_sun_ce_defeat_hua_xin_armies", -- event_key 
	success_key.."fire_intro", -- trigger event 
	function(context)
		return true;
	end, --listener condition
	false, -- fire_once.
	success_key.."armies_beaten", -- completion event 
	nil,
	false -- delay start
);

-- Destroy Hua Xin
cdir_mission_manager:start_mission_listener(
    local_faction_key,                          -- faction key
    "3k_dlc07_mission_sun_ce_hua_xin",                     -- mission key
    "DESTROY_FACTION",                                  -- objective type
    {
        "faction 3k_dlc05_faction_hua_xin"
    },   
    {
        "money 5000"
    },                                                    -- mission rewards (table of strings)
	success_key.."armies_beaten",      -- trigger event 
	nil,												-- Listener condition
	false,												-- Fire once
	success_key.."hua_xin",		-- completion event
	success_key.."hua_xin",		-- failure event
	"3k_main_victory_objective_issuer"							--mission_issuer
);

-- Control Changsha
cdir_mission_manager:start_mission_listener(
    local_faction_key,                          -- faction key
    "3k_dlc07_mission_sun_ce_changsha",                     -- mission key
    "CONTROL_N_REGIONS_INCLUDING",                                  -- objective type
    {
        "total 3",
		"region 3k_main_changsha_resource_3",
		"region 3k_main_changsha_resource_2",
		"region 3k_main_changsha_capital"
    }, 
    {
        "money 5000"
    },                                                  -- mission rewards (table of strings)
	success_key.."hua_xin",      -- trigger event 
	nil,												-- Listener condition
	false,												-- Fire once
  	success_key.."changsha_taken",     -- completion event
	success_key.."changsha_taken",														-- failure event
	"3k_main_victory_objective_issuer"							--mission_issuer
);

-- Destroy Liu Biao
cdir_mission_manager:start_mission_listener(
    local_faction_key,                          -- faction key
    "3k_dlc07_mission_sun_ce_liu_biao",                     -- mission key
    "DESTROY_FACTION",                                  -- objective type
    {
        "faction 3k_main_faction_liu_biao"
    },   
    {
        "money 5000"
    },                                                    -- mission rewards (table of strings)
	success_key.."changsha_taken",      -- trigger event 
	nil,												-- Listener condition
	false,												-- Fire once
	success_key.."liu_biao",		-- completion event
	success_key.."liu_biao",		-- failure event
	"3k_main_victory_objective_issuer"							--mission_issuer
);


--Xu Zhao and the White Tiger attack
core:add_listener(
	listener_key .. "xu_zhao", -- Unique handle
	"ScriptEventHumanFactionTurnStart", -- Campaign Event to listen for
	function(context) -- Criteria
		return context:faction():name() == local_faction_key and 
		not cm:query_faction("3k_dlc05_faction_xu_zhao"):is_dead() and
		cdir_mission_manager:get_turn_number() == 10;
	end,
	function(context) -- What to do if listener fires.
		if not diplomacy_manager:is_at_war_with("3k_dlc05_faction_xu_zhao", local_faction_key) then
			diplomacy_manager:force_declare_war("3k_dlc05_faction_xu_zhao", local_faction_key, false);
		end

		core:trigger_event(success_key .. "xu_zhao_attacks");
	end,
	false --Is persistent
);

-- Destroy Xu Zhao
cdir_mission_manager:start_mission_listener(
    local_faction_key,                          -- faction key
    "3k_dlc07_mission_sun_ce_xu_zhao",                     -- mission key
    "DESTROY_FACTION",                                  -- objective type
    {
        "faction 3k_dlc05_faction_xu_zhao"
    },   
    {
        "money 5000"
    },                                                    -- mission rewards (table of strings)
	success_key.."xu_zhao_attacks",      -- trigger event 
	nil,												-- Listener condition
	false,												-- Fire once
	success_key.."xu_zhao",		-- completion event
	success_key.."xu_zhao",		-- failure event
	"3k_main_victory_objective_issuer"							--mission_issuer
);

-- Incident warning the player of impending raids, 5 turns before they begin (if chen dengs faction is alive)
core:add_listener(
	listener_key .. "chen_deng_0", -- Unique handle
	"ScriptEventHumanFactionTurnStart", -- Campaign Event to listen for
	function(context) -- Criteria
		return cdir_mission_manager:get_turn_number() == 25 and context:faction():name() == local_faction_key
		and not cm:query_faction("3k_dlc07_faction_chen_deng"):is_dead();
	end,
	function(context) -- What to do if listener fires.
		if diplomacy_manager:is_vassal_of(local_faction_key, "3k_dlc07_faction_chen_deng") then
			diplomacy_manager:apply_automatic_deal_between_factions("3k_dlc07_faction_chen_deng", local_faction_key, "data_defined_situation_vassal_declares_independence", false);
		end;
		cm:trigger_incident(local_faction_key, "3k_dlc07_incident_sun_ce_chen_deng_0");
	end,
	false --Is persistent
);

--Chen Deng sends a raiding party
core:add_listener(
	listener_key .. "chen_deng_1", -- Unique handle
	"ScriptEventHumanFactionTurnStart", -- Campaign Event to listen for
	function(context) -- Criteria
		return context:faction():name() == local_faction_key and not cm:query_faction("3k_dlc07_faction_chen_deng"):is_dead()
		and cdir_mission_manager:get_turn_number() == 30;
	end,
	function() -- What to do if listener fires.
		local chen_deng_raid_target = get_chen_deng_target_against_sun_ce()

		if chen_deng_raid_target == false then
			output("3k_dlc05_faction_sun_ce_events.lua: Sun Ce has somehow lost the whole coastline so cancel the chen deng event chain")
			return
		end
		if diplomacy_manager:is_vassal_of(local_faction_key, "3k_dlc07_faction_chen_deng") then
			diplomacy_manager:apply_automatic_deal_between_factions("3k_dlc07_faction_chen_deng", local_faction_key, "data_defined_situation_vassal_declares_independence", false);
		elseif not diplomacy_manager:is_at_war_with("3k_dlc07_faction_chen_deng", local_faction_key) then
			diplomacy_manager:force_declare_war("3k_dlc07_faction_chen_deng", local_faction_key, false);
		end;
		campaign_invasions:create_invasion_attack_faction("3k_dlc07_faction_chen_deng", chen_deng_raid_target, 3, local_faction_key);
		
		core:trigger_event(success_key .. "chen_deng_1_incident");

	end,
	false --Is persistent
);

-- Chen Deng raiding party 1 incident
cdir_mission_manager:start_incident_db_listener(
	local_faction_key, -- faction_key 
	"3k_dlc07_incident_sun_ce_chen_deng_1", -- event_key 
	success_key .. "chen_deng_1_incident", -- trigger event 
	function()
		return true
	end, --listener condition
	false, -- fire_once.
	nil, -- completion event 
	nil, -- failure event
	false -- delay start
);

--Chen Deng sends a raiding party... again
core:add_listener(
	listener_key .. "chen_deng_2", -- Unique handle
	"ScriptEventHumanFactionTurnStart", -- Campaign Event to listen for
	function(context) -- Criteria
		return context:faction():name() == local_faction_key 
		and not cm:query_faction("3k_dlc07_faction_chen_deng"):is_dead()
		and cdir_mission_manager:get_turn_number() == 50;
	end,
	function() -- What to do if listener fires.

		local chen_deng_raid_target = get_chen_deng_target_against_sun_ce()

		if chen_deng_raid_target == false then
			output("3k_dlc05_faction_sun_ce_events.lua: Sun Ce has somehow lost the whole coastline so cancel the chen deng event chain")
			return
		end

		campaign_invasions:create_invasion_attack_faction("3k_dlc07_faction_chen_deng", chen_deng_raid_target, 3, local_faction_key);
		
		core:trigger_event(success_key .. "chen_deng_2_incident");

	end,
	false --Is persistent
);

-- Chen Deng raiding party 2 incident
cdir_mission_manager:start_incident_db_listener(
	local_faction_key, -- faction_key 
	"3k_dlc07_incident_sun_ce_chen_deng_2", -- event_key 
	success_key .. "chen_deng_2_incident", -- trigger event 
	function()
		return true
	end, --listener condition
	false, -- fire_once.
	nil, -- completion event 
	nil, -- failure event
	false -- delay start
);

-- Calculate the target for Chen Deng's raiding based on coastal proximity
function get_chen_deng_target_against_sun_ce()

	local chen_deng_target = ""
	if cm:query_region("3k_main_jianye_capital"):owning_faction():name() == local_faction_key then
		chen_deng_target = "3k_main_jianye_capital"
	elseif cm:query_region("3k_main_jianye_resource_2"):owning_faction():name() == local_faction_key then
		chen_deng_target = "3k_main_jianye_resource_2"
	elseif cm:query_region("3k_main_kuaji_capital"):owning_faction():name() == local_faction_key then
		chen_deng_target = "3k_main_kuaji_capital"
	elseif cm:query_region("3k_main_kuaji_resource_1"):owning_faction():name() == local_faction_key then
		chen_deng_target = "3k_main_kuaji_resource_1"
	else
		return false
	end

	return chen_deng_target

end

--The vassal Li Shu rebels
core:add_listener(
	listener_key .. "li_shu_rebels", -- Unique handle
	"ScriptEventHumanFactionTurnStart", -- Campaign Event to listen for
	function(context) -- Criteria
		return context:faction():name() == local_faction_key 
		and not cm:query_faction("3k_dlc07_faction_li_shu"):is_dead()
		and cdir_mission_manager:get_turn_number() >= 20;
	end,
	function(context) -- What to do if listener fires.

		if not diplomacy_manager:is_at_war_with("3k_dlc07_faction_li_shu", local_faction_key) then
			if diplomacy_manager:get_vassal_master("3k_dlc07_faction_li_shu"):name() == local_faction_key then
				if cm:query_faction("3k_dlc07_faction_li_shu"):can_apply_automatic_diplomatic_deal("data_defined_situation_vassal_declares_independence", cm:query_faction(local_faction_key), "") then
					diplomacy_manager:apply_automatic_deal_between_factions("3k_dlc07_faction_li_shu", local_faction_key, "data_defined_situation_vassal_declares_independence")
				else
					script_error("Error in dlc07 sun ce faction events! Trying to force vassal independence of Li Shu, but unable to do so! ")
				end
			else
				diplomacy_manager:force_declare_war("3k_dlc07_faction_li_shu", local_faction_key, false);
			end
		end

		core:trigger_event(success_key.."li_shu_rebels");
	end,
	false --Is persistent
);

-- Destroy Li Shu
cdir_mission_manager:start_mission_listener(
    local_faction_key,                          -- faction key
	"3k_dlc07_mission_sun_ce_li_shu",                     -- mission key
    "DESTROY_FACTION",                                  -- objective type
    {
        "faction 3k_dlc07_faction_li_shu"
    },   
    {
        "money 5000"
    },                                                    -- mission rewards (table of strings)
	success_key.."li_shu_rebels",      -- trigger event 
	nil,												-- Listener condition
	false,												-- Fire once
	success_key.."li_shu_destroyed",		-- completion event
	failure_key.."li_shu_destroyed",		-- failure event
	"3k_main_victory_objective_issuer"							--mission_issuer
);

--Wu Jing faction leader dies
core:add_listener(
	listener_key .. "chen_deng_1", -- Unique handle
	"ScriptEventHumanFactionTurnStart", -- Campaign Event to listen for
	function(context) -- Criteria
		return context:faction():name() == local_faction_key 
		and not cm:query_faction("3k_dlc05_faction_wu_jing"):is_dead()
		and cm:query_faction("3k_dlc05_faction_wu_jing"):has_faction_leader()
		and cm:query_faction("3k_dlc05_faction_wu_jing"):has_specified_diplomatic_deal_with("treaty_components_vassalage", cm:query_faction(local_faction_key))
		and cdir_mission_manager:get_turn_number() >= 30
		and cm:random_number(0, 99) < 15 ;
	end,
	function() -- What to do if listener fires.

		--Kill Wu Jing's faction leader
		local wu_jing_faction_leader_cqi = cm:query_faction("3k_dlc05_faction_wu_jing"):faction_leader():cqi()
		cm:modify_character(wu_jing_faction_leader_cqi):kill_character(false)

		-- Trigger the dilemma
		cm:modify_faction(local_faction_key):trigger_dilemma("3k_dlc07_dilemma_sun_ce_wu_jing_dies", true);
		core:trigger_event(success_key .. "wu_jing_dilemma");

	end,
	false --Is persistent
);




-- #endregion
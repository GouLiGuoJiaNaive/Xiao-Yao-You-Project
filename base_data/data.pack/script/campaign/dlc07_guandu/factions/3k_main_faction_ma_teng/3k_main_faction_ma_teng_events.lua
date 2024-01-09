--[[
***************************************************
***************************************************
** VARIABLES
***************************************************
***************************************************
]]--
local local_faction_key = "3k_main_faction_ma_teng";
local listener_key = "dlc07_" .. local_faction_key .. "_";
local success_key = "dlc07_" .. local_faction_key .. "_success_";
local failure_key = "dlc07_" .. local_faction_key .. "_failure_";

output("Events script loaded for " .. local_faction_key);

-- Handles REACH_FACTION_RANK and VICTORY CONDITION missions for factions.
dlc07_shared_progression_missions:setup_han_progression_missions(local_faction_key);
dlc07_shared_progression_missions:setup_han_victory_missions(local_faction_key);

-- Find appropriate spawn location for Zhang Meng's strongest main invasion force
local function get_zhang_meng_target_vs_ma_teng()

	local zhang_meng_target = ""
	if cm:query_region("3k_main_jincheng_capital"):owning_faction():name() == local_faction_key then
		zhang_meng_target = "3k_main_jincheng_capital"
	elseif cm:query_region("3k_main_jincheng_resource_1"):owning_faction():name() == local_faction_key then
		zhang_meng_target = "3k_main_jincheng_resource_1"
	elseif cm:query_region("3k_main_anding_capital"):owning_faction():name() == local_faction_key then
		zhang_meng_target = "3k_main_anding_capital"
	elseif cm:query_region("3k_main_anding_resource_2"):owning_faction():name() == local_faction_key then
		zhang_meng_target = "3k_main_anding_resource_2"
	else
		return false
	end

	return zhang_meng_target
end

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

-- Engage first force
cdir_mission_manager:start_mission_listener(
    local_faction_key,                          -- faction key
    "3k_dlc07_mission_ma_teng_first_battle",                     -- mission key
    "CONTROL_N_REGIONS_INCLUDING",                                  -- objective type
    {
        "total 1",
		"region 3k_main_wudu_resource_1",
    }, 
    {
        "money 5000"
    },                                                  -- mission rewards (table of strings)
	success_key.."fire_intro",      -- trigger event 
	nil,												-- Listener condition
	false,												-- Fire once
  	success_key.."engaged_force",     -- completion event
	success_key.."engaged_force",														-- failure event
	"3k_main_victory_objective_issuer"							--mission_issuer
);

-- Destroy Han Sui
cdir_mission_manager:start_mission_listener(
    local_faction_key,                          -- faction key
    "3k_dlc07_mission_ma_teng_han_sui",                     -- mission key
    "DESTROY_FACTION",                                  -- objective type
    {
        "faction 3k_main_faction_han_sui"
    },   
    {
		"money 5000",
		"effect_bundle{bundle_key 3k_dlc06_historical_mission_payload_campaign_movement_range;turns 5;}"
    },                                                    -- mission rewards (table of strings)
	success_key.."engaged_force",      -- trigger event 
	nil,												-- Listener condition
	false,												-- Fire once
	success_key.."han_sui",		-- completion event
	success_key.."han_sui",		-- failure event
	"3k_main_victory_objective_issuer"							--mission_issuer
);


--Check to see if Zang Meng is dead, if not, spawn invasion forces if player owns any of the required regions and trigger incident success key
core:add_listener(
	listener_key .. "zhang_meng_invasion", -- Unique handle
	"ScriptEventHumanFactionTurnStart", -- Campaign Event to listen for
	function(context) -- Criteria
		return context:faction():name() == local_faction_key and not cm:query_faction("3k_dlc07_faction_zhang_meng"):is_dead()
		and (cm:query_region("3k_main_jincheng_capital"):owning_faction():name() == local_faction_key or
		cm:query_region("3k_main_jincheng_resource_1"):owning_faction():name() == local_faction_key or
		cm:query_region("3k_main_anding_capital"):owning_faction():name() == local_faction_key or
	    cm:query_region("3k_main_anding_resource_2"):owning_faction():name() == local_faction_key)
	end,
	function() -- What to do if listener fires.

		local zhang_meng_raid_target = get_zhang_meng_target_vs_ma_teng ()

		if zhang_meng_raid_target == false then
			output("3k_main_faction_ma_teng_events.lua: Ma Teng does not control any of the required regions, so invasion force spawn is cancelled.")
			return
		end

		-- Spawn one force in a target region the player owns.
		campaign_invasions:create_invasion_attack_region("3k_dlc07_faction_zhang_meng", zhang_meng_raid_target, 1, zhang_meng_raid_target);

		-- Spawn a second in shoufang.
		campaign_invasions:create_invasion_attack_force("3k_dlc07_faction_zhang_meng", "3k_main_shoufang_resource_3", 3, "3k_main_template_historical_ma_teng_hero_fire", true);

		core:trigger_event(success_key .. "zhang_meng_strikes");

	end,
	false --Is persistent
);

-- Zhang Meng raiding parties incident
cdir_mission_manager:start_incident_db_listener(
	local_faction_key, -- faction_key 
	"3k_dlc07_incident_ma_teng_zhang_meng", -- event_key 
	success_key .. "zhang_meng_strikes", -- trigger event 
	function()
		return true
	end, --listener condition
	false, -- fire_once.
	success_key.."invasion_incident", -- completion event
	nil, -- completion event 
	nil, -- failure event
	false -- delay start
);

-- Destroy Zhang Meng
cdir_mission_manager:start_mission_listener(
    local_faction_key,                          -- faction key
    "3k_dlc07_mission_ma_teng_zhang_meng",                     -- mission key
    "DESTROY_FACTION",                                  -- objective type
    {
        "faction 3k_dlc07_faction_zhang_meng"
    },   
    {
		"money 5000"
    },                                                     -- mission rewards (table of strings)
	success_key.."han_sui",      -- trigger event 
	nil,												-- Listener condition
	false,												-- Fire once
	success_key.."zhang_meng",		-- completion event
	success_key.."zhang_meng",		-- failure event
	"3k_main_victory_objective_issuer"							--mission_issuer
);

-- Control Anding
cdir_mission_manager:start_mission_listener(
    local_faction_key,                          -- faction key
    "3k_dlc07_mission_ma_teng_anding",                     -- mission key
    "CONTROL_N_REGIONS_INCLUDING",                                  -- objective type
    {
        "total 4",
		"region 3k_main_anding_capital",
		"region 3k_main_anding_resource_3",
		"region 3k_main_anding_resource_1",
		"region 3k_main_anding_resource_2"
    }, 
    {
        "money 5000"
    },                                                  -- mission rewards (table of strings)
	success_key.."han_sui",      -- trigger event 
	nil,												-- Listener condition
	false,												-- Fire once
  	success_key.."anding",     -- completion event
	success_key.."anding",														-- failure event
	"3k_main_victory_objective_issuer"							--mission_issuer
);

--See if Ma Chao leaves to fight Cao Cao after a few in-game years pass
core:add_listener(
	listener_key .. "intro_start", -- Unique handle
	"ScriptEventHumanFactionTurnStart", -- Campaign Event to listen for
	function(context) -- Criteria
		return cdir_mission_manager:get_turn_number() == 40 and context:faction():name() == local_faction_key;
	end,
	function(context) -- What to do if listener fires.

		core:trigger_event(success_key .. "ma_chao_check");
	end,
	false --Is persistent
);

--Ma Chao dilemma for him leaving to fight, or not
cdir_mission_manager:start_dilemma_db_listener(
	local_faction_key, --faction_key
	"3k_dlc07_dilemma_ma_teng_ma_chao", --event_key
	success_key.."ma_chao_dilemma", --trigger_event
	function()
		return true
	end, --listener condition
	false, -- fire_once.
	nil, -- completion event 
	nil, -- failure event
	false, -- delay start
	nil, -- on trigger event
	success_key.."yes_fight_cao_cao", -- Fight Cao Cao
	success_key.."no_fight_cao_cao" -- Don't fight Cao Cao
);


core:add_listener(
	listener_key .. "ma_chao_check", -- Unique handle
	success_key.."ma_chao_check", -- Campaign Event to listen for
	function()
		return true
	end, --listener condition
	function() -- What to do if listener fires.

		-- Check if Ma Teng is our faction leader, we own Ma Chao, Zhang Lu is alive, and Cao Cao is alive
		local l_ma_teng = cm:query_model():character_for_template("3k_main_template_historical_ma_teng_hero_fire")
		local l_ma_chao = cm:query_model():character_for_template("3k_main_template_historical_ma_chao_hero_fire")
		if l_ma_chao and l_ma_teng 
		and not l_ma_chao:is_null_interface() and not l_ma_teng:is_null_interface()
		and l_ma_chao:faction():name() == local_faction_key and l_ma_teng:faction():name() == local_faction_key 
		and l_ma_teng:is_faction_leader()
		and not cm:query_faction("3k_dlc07_faction_zhang_lu"):is_dead() 
		and not cm:query_faction("3k_main_faction_cao_cao"):is_dead() then

			--Ma Chao dilemma conditions are valid, so we'll trigger the dilemma
			core:trigger_event(success_key .. "ma_chao_dilemma");

		else

			--Ma Chao dilemma conditions invalid, so we'll skip to Conquer Cao Cao
			core:trigger_event(success_key .. "conquer_cao_cao");	

		end

		

	end,
	false --Is persistent
);

--Trigger war with cao cao and mission to fight him
core:add_listener(
	listener_key .. "conquer_cao_cao", -- Unique handle
	success_key.."yes_fight_cao_cao", -- Campaign Event to listen for
	function()
		return true
	end, --listener condition
	function() -- What to do if listener fires.

		if not diplomacy_manager:is_at_war_with(local_faction_key, "3k_main_faction_cao_cao") then
			diplomacy_manager:force_declare_war(local_faction_key, "3k_main_faction_cao_cao", false);
		end

		core:trigger_event(success_key .. "conquer_cao_cao");

	end,
	false --Is persistent
);

--Ma Chao leaves because the player didn't go to war with Cao Cao. 
core:add_listener(
	listener_key .. "ma_chao_leaves", -- Unique handle
	success_key.."no_fight_cao_cao", -- Campaign Event to listen for
	function()
		return true
	end, --listener condition
	function() -- What to do if listener fires.

		local ma_chao = cm:query_model():character_for_template("3k_main_template_historical_ma_chao_hero_fire")
		cm:modify_character(ma_chao):move_to_faction_and_make_recruited("3k_dlc07_faction_zhang_lu")

		cm:modify_faction(cm:query_faction(local_faction_key)):trigger_mission("3k_dlc07_mission_ma_teng_zhang_lu", true)

	end,
	false --Is persistent
);

core:add_listener(
	listener_key.."capture_tong_pass_ma_chao_returns",
	"MissionSucceeded",
	function(context)
		return context:mission():mission_record_key() == "3k_dlc07_mission_ma_teng_zhang_lu"
	end,
	function(context)
		local ma_chao = cm:query_model():character_for_template("3k_main_template_historical_ma_chao_hero_fire")
		if ma_chao and not ma_chao:is_null_interface() and ma_chao:faction():name() ~= local_faction_key then
			cm:modify_character(ma_chao):move_to_faction_and_make_recruited(local_faction_key)
		end

		core:trigger_event(success_key .. "conquer_cao_cao");

		core:remove_listener(listener_key.."capture_tong_pass_ma_chao_returns")
	end,
	true
)

-- Player has achieved the requirements to restore Ma Chao's faith in them. 
-- If he's alive, send him back to the faction and then trigger the war with Cao Cao mission
core:add_listener(
	listener_key .. "capture_tong_pass_conquer_cao_cao", -- Unique handle
	success_key.."capture_tong_pass", -- Campaign Event to listen for
	function()
		return true
	end, --listener condition
	function() -- What to do if listener fires.

		-- Check for Ma Chao and return him to the player faction
		local ma_chao = cm:query_model():character_for_template("3k_main_template_historical_ma_chao_hero_fire")
		if ma_chao 
		and not ma_chao:is_null_interface() 
		and ma_chao:faction():name() ~= local_faction_key then
			cm:modify_character(ma_chao):move_to_faction_and_make_recruited(local_faction_key)
		end

		--Go fight Cao Cao
		core:trigger_event(success_key .. "conquer_cao_cao");

	end,
	false --Is persistent
);

-- Destroy Cao Cao
cdir_mission_manager:start_mission_listener(
    local_faction_key,                          -- faction key
    "3k_dlc07_mission_ma_teng_cao_cao",                     -- mission key
    "DESTROY_FACTION",                                  -- objective type
    {
        "faction 3k_main_faction_cao_cao"
    },   
    {
        "money 5000"
    },                                                    -- mission rewards (table of strings)
	success_key.."conquer_cao_cao",      -- trigger event 
	nil,												-- Listener condition
	false,												-- Fire once
	success_key.."cao_cao_destroyed",		-- completion event
	success_key.."cao_cao_destroyed",		-- failure event
	"3k_main_victory_objective_issuer"							--mission_issuer
);

-- #endregion
--[[
***************************************************
***************************************************
** VARIABLES
***************************************************
***************************************************
]]--
local local_faction_key = "3k_dlc04_faction_zhang_jue";
local listener_key = "dlc04_" .. local_faction_key;
local success_key = "dlc04_" .. local_faction_key .. "_success";
local failure_key = "dlc04_" .. local_faction_key .. "_failure";

output("Events script loaded for " .. local_faction_key);
setup_shared_faction_events_yellow_turbans(local_faction_key, success_key, failure_key);

local zhang_jue_cqi;

if not cm:query_model():character_for_startpos_id("2123526617"):is_null_interface() then
	cdir_mission_manager:print("Found Zhang jue.");
	zhang_jue_cqi = cm:query_model():character_for_startpos_id("2123526617"):command_queue_index();
else
	script_error("Cannot find Zhang jue");
end;

local function initial_set_up()
	local invasion = campaign_invasions:create_invasion("3k_dlc04_faction_rebels", "3k_main_henei_capital", 1, true, local_faction_key, true, 476, 565);
	invasion:set_force_retreated();
	invasion:start_invasion();
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
core:add_listener(
	listener_key .. "intro_start", -- Unique handle
	"FactionTurnStart", -- Campaign Event to listen for
	function(context) -- Criteria
		return cdir_mission_manager:get_turn_number() == 1 and context:faction():name() == local_faction_key;
	end,
	function(context) -- What to do if listener fires.

		-- Remove the special items to give back later.
		cm:modify_faction(local_faction_key):ceo_management():remove_ceos("3k_dlc04_ancillary_weapon_staff_zhang_jue_unique");

		core:trigger_event(success_key .. "_fire_intro");
	end,
	false --Is persistent
);

-- Intro Event.
cdir_mission_manager:start_incident_db_listener(
	local_faction_key, -- faction_key 
	"3k_dlc04_introduction_zhang_jue_incident", -- event_key 
	success_key .. "_fire_intro", -- trigger event 
	function(context)
		return true;
	end, --listener condition
	false, -- fire_once.
	success_key.."_Intro_Fired", -- completion event 
	nil, -- failure event
	false -- delay start
);

-- Engage first force
cdir_mission_manager:start_mission_db_listener(
	local_faction_key, -- faction_key 
	"3k_dlc04_mission_progression_zhang_jue_intro_engage_first_force", -- event_key 
	success_key.."_Intro_Fired", -- trigger event 
	function(context)
		return true;
	end, --listener condition
	false, -- fire_once.
	success_key.."engaged_force", -- completion event 
	success_key.."engaged_force", -- failure event
	false -- delay start
);

-- Capture settlement.
cdir_mission_manager:start_mission_db_listener(
	local_faction_key, -- faction_key 
	"3k_dlc04_mission_progression_zhang_jue_intro_capture_settlement", -- event_key 
	success_key.."engaged_force", -- trigger event 
	function(context)
		return true;
	end, --listener condition
	false, -- fire_once.
	success_key.."captured_settlement", -- completion event 
	success_key.."captured_settlement", -- failure event
	false -- delay start
);

cdir_mission_manager:start_dilemma_db_listener(
	local_faction_key, --faction_key
	"3k_dlc04_dilemma_yellow_turban_prewar_intro", --event_key
	success_key.."captured_settlement", --trigger_event
	function(context)
		return true
	end, --listener condition
	false, -- fire_once.
	nil, -- completion event 
	nil, -- failure event
	false, -- delay start
	nil, -- on trigger event
	"zhang_jue_prewar_dilemma_complete" -- Choice A
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

-- Capture Taiyuan
cdir_mission_manager:start_mission_listener(
    local_faction_key,                          -- faction key
    "3k_dlc04_mission_progression_yellow_turbans_capture_taiyuan",                     -- mission key
    "CONTROL_N_REGIONS_INCLUDING",                                  -- objective type
    {
        "total 3",
		"region 3k_main_taiyuan_capital",
		"region 3k_main_taiyuan_resource_1",
		"region 3k_main_taiyuan_resource_2"
    },    
    {
        "effect_bundle{bundle_key 3k_dlc04_mission_progression_yellow_turban_ceo_reward_dummy;}"
    },                                                  -- mission rewards (table of strings)
	"zhang_jue_prewar_dilemma_complete",      -- trigger event 
	nil,												-- Listener condition
	false,												-- Fire once
	success_key.."_yt_taiyuan_captured",		-- completion event
	nil,		-- failure event
	"3k_main_victory_objective_issuer"							--mission_issuer
);

-- Remove the dummy bundle and give ancillaries to the other Zhang brothers
core:add_listener(
	local_faction_key, --faction_key
	success_key .. "_yt_taiyuan_captured", -- Campaign Event to listen for
	true,
	function() -- What to do if listener fires.
		cm:modify_faction(local_faction_key):remove_effect_bundle("3k_dlc04_mission_progression_yellow_turban_ceo_reward_dummy")
		
		--[[if not cm:query_model():character_for_startpos_id("2123526617"):is_null_interface() then
			zhang_jue_faction = cm:query_model():character_for_startpos_id("2123526617"):faction():name();
			cm:modify_faction(zhang_jue_faction):ceo_management():add_ceo("3k_dlc04_ancillary_weapon_staff_zhang_jue_unique");
		end;]]
		if not cm:query_model():character_for_startpos_id("2031903271"):is_null_interface() then
			zhang_liang_faction = cm:query_model():character_for_startpos_id("2031903271"):faction():name();
			cm:modify_faction(zhang_liang_faction):ceo_management():add_ceo("3k_dlc04_ancillary_accessory_zhang_liang_unique");
		end;
		if not cm:query_model():character_for_startpos_id("451213364"):is_null_interface() then
			zhang_bao_faction = cm:query_model():character_for_startpos_id("451213364"):faction():name();
			cm:modify_faction(zhang_bao_faction):ceo_management():add_ceo("3k_dlc04_ancillary_accessory_religious_bell_unique");
		end;

	end,
	false --Is persistent
);

-- Ancillary reward for the Taiyuan mission
cdir_mission_manager:start_incident_db_listener(
	local_faction_key, -- faction_key 
	"3k_dlc04_incident_progression_zhang_jue_ceo_reward", -- event_key 
	success_key .. "_yt_taiyuan_captured", -- trigger event 
	function(context)
		return true;
	end, --listener condition
	false, -- fire_once.
	nil, -- completion event 
	nil, -- failure event
	false -- delay start
);

-- Defeat 20 armies
cdir_mission_manager:start_mission_db_listener(
	local_faction_key, -- faction_key 
	"3k_dlc04_mission_progression_zhang_jue_defeat_armies", -- event_key 
	"zhang_jue_prewar_dilemma_complete", -- trigger event 
	function(context)
		return true;
	end, --listener condition
	false, -- fire_once.
	success_key.."_zhang_jue_defeat_armies", -- completion event 
	nil,
	false -- delay start
);

-- Defeat armies payload
core:add_listener(
	local_faction_key, --faction_key
	success_key .. "_zhang_jue_defeat_armies", -- Campaign Event to listen for
	true,
	function() -- What to do if listener fires.
		local all_factions = cm:query_model():world():faction_list();
		for i = 0, all_factions:num_items() - 1 do
			local faction = all_factions:item_at(i);
			if not faction:is_dead() then
				if faction:subculture() == "3k_main_chinese" then
					if faction:name() ~= local_faction_key then
						cm:modify_faction(faction:name()):apply_effect_bundle("3k_dlc04_mission_progression_zhang_jue_defeat_armies", 20)
					end
				end;
			end
		end;			
	end,
	false --Is persistent
);

-- Destroy Liu Yu
cdir_mission_manager:start_mission_listener(
    local_faction_key,                          -- faction key
    "3k_dlc04_mission_progression_zhang_jue_destroy_liu_yu",                     -- mission key
    "DESTROY_FACTION",                                  -- objective type
    {
        "faction 3k_main_faction_liu_yu"
    },   
    {
        "effect_bundle{bundle_key 3k_dlc04_mission_payload_zhang_jue_he_yi_dummy;}"
    },                                                  -- mission rewards (table of strings)
	"zhang_jue_prewar_dilemma_complete",      -- trigger event 
	nil,												-- Listener condition
	false,												-- Fire once
	success_key.."_he_yi_dilemma",		-- completion event
	success_key.."_he_yi_dilemma",		-- failure event
	"3k_main_victory_objective_issuer"							--mission_issuer
);

-- Dilemma about the fate of He Yi
cdir_mission_manager:start_dilemma_db_listener(
	local_faction_key, --faction_key
	"3k_dlc04_dilemma_zhang_jue_he_yi", --event_key
	success_key .. "_he_yi_dilemma", --trigger_event
	function(context)
		return true
	end, --listener condition
	false, -- fire_once.
	nil, -- completion event 
	nil, -- failure event
	false, -- delay start
	nil, -- on trigger event
	success_key.."_he_yi_joins", -- Choice A
	success_key.."_he_yi_new_faction" -- Choice B
);

-- If the player chooses for He Yi to join them
core:add_listener(
	local_faction_key, --faction_key
	success_key .. "_he_yi_joins", -- Campaign Event to listen for
	true,
	function() -- What to do if listener fires.
		cm:modify_faction(local_faction_key):remove_effect_bundle("3k_dlc04_mission_payload_zhang_jue_he_yi_dummy")
		cm:modify_faction(local_faction_key):create_character_from_template("general", "3k_general_water", "3k_ytr_template_historical_he_yi_hero_water", true);
	end,
	false --Is persistent
);

-- If the player chooses for He Yi to become an independent faction
core:add_listener(
	local_faction_key, --faction_key
	success_key .. "_he_yi_new_faction", -- Campaign Event to listen for
	true,
	function() -- What to do if listener fires.
		cm:modify_faction(local_faction_key):remove_effect_bundle("3k_dlc04_mission_payload_zhang_liang_huang_shao_dummy")
		local he_yi = campaign_invasions:create_invasion("3k_main_faction_yellow_turban_rebels", "3k_main_runan_resource_1", 3, true);
		he_yi:create_general(true, "3k_general_water", "3k_ytr_template_historical_he_yi_hero_water"); -- override the given general with our own one.
		he_yi:start_invasion();
		-- Gift He Yi the nearby settlement if it isn't owned by a player
		if cm:query_region("3k_main_runan_resource_1"):owning_faction():is_human() == false then
			cm:modify_region("3k_main_runan_resource_1"):settlement_gifted_as_if_by_payload(cm:modify_faction("3k_main_faction_yellow_turban_rebels"));
		end
		-- Add He Yi to the YT Alliance
		diplomacy_manager:apply_automatic_deal_between_factions(mandate_war_manager.yt_leader_faction_key, "3k_main_faction_yellow_turban_rebels", "data_defined_situation_join_alliance_proposer", false);
		-- Add visibility to the region for the player
		cm:modify_faction(local_faction_key):make_region_seen_in_shroud("3k_main_runan_resource_1");
	end,
	false --Is persistent
);

-- Capture farmlands
cdir_mission_manager:start_mission_listener(
    local_faction_key,                          -- faction key
    "3k_dlc04_mission_progression_yellow_turbans_farmlands",                     -- mission key
    "CONTROL_N_REGIONS_INCLUDING",                                  -- objective type
    {
        "total 3",
		"region 3k_main_zhongshan_resource_1",
		"region 3k_main_anping_resource_1",
		"region 3k_main_weijun_resource_1"
    }, 
    {
        "money 5000"
    },                                                  -- mission rewards (table of strings)
	"zhang_jue_prewar_dilemma_complete",      -- trigger event 
	nil,												-- Listener condition
	false,												-- Fire once
   success_key.."_yt_farms_captured",     -- completion event
	nil,														-- failure event
	"3k_main_victory_objective_issuer"							--mission_issuer
);

-- Give the 3 farmlands payload to the other yellow turban factions as well
core:add_listener(
	local_faction_key, --faction_key
	success_key.."_yt_farms_captured", -- Campaign Event to listen for
	true,
	function() -- What to do if listener fires.
		local all_factions = cm:query_model():world():faction_list();
		for i = 0, all_factions:num_items() - 1 do
			local faction = all_factions:item_at(i);
			if not faction:is_dead() then
				if faction:subculture() == "3k_main_subculture_yellow_turban" then
					if faction:is_human() == false then
						cm:modify_faction(faction:name()):increase_treasury(5000)
					end
				end;
			end
		end;
	end,
	false --Is persistent
);

-- Yellow Turbans own 20 settlements
cdir_mission_manager:start_mission_listener(
    local_faction_key,                          -- faction key
    "3k_dlc04_mission_progression_yellow_turbans_settlements",                     -- mission key
    "CONTROL_N_REGIONS_INCLUDING",                                  -- objective type
    {
        "total 20"
    }, 
    {
        "money 10000"
    },                                                  -- mission rewards (table of strings)
	success_key.."_yt_farms_captured",      -- trigger event 
	nil,												-- Listener condition
	false,												-- Fire once
    nil,     -- completion event
	nil,														-- failure event
	"3k_main_victory_objective_issuer"							--mission_issuer
);

-- #endregion
--[[
***************************************************
***************************************************
** VARIABLES
***************************************************
***************************************************
]]--
local local_faction_key = "3k_main_faction_liu_bei";
local success_key = "dlc04_" .. local_faction_key .. "_success";
local failure_key = "dlc04_" .. local_faction_key .. "_failure";

output("Events script loaded for " .. local_faction_key);
setup_shared_faction_events_han_empire(local_faction_key, success_key, failure_key);

local template_liu_bei = "3k_main_template_historical_liu_bei_hero_earth";
local template_zhang_fei = "3k_main_template_historical_zhang_fei_hero_fire";
local template_guan_yu = "3k_main_template_historical_guan_yu_hero_wood";

-- Spawn initial armies.
local function initial_set_up()
	local invasion = campaign_invasions:create_invasion("3k_dlc04_faction_rebels", "3k_main_henei_capital", 1, true, local_faction_key, true, 511, 528); 
	invasion:set_force_retreated();
	invasion:start_invasion();

	diplomacy_manager:force_declare_war("3k_dlc04_faction_rebels", "3k_main_faction_han_empire", true);
	diplomacy_manager:grant_military_access(local_faction_key, "3k_dlc04_faction_lu_zhi", true);
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
	"3k_main_faction_liu_bei_start", -- Unique handle
	"FactionTurnStart", -- Campaign Event to listen for
	function(context) -- Criteria
		return cdir_mission_manager:get_turn_number() == 1 and context:faction():name() == local_faction_key;
	end,
	function(context) -- What to do if listener fires.

		-- Remove the special weapons from liu bei
		cm:modify_faction("3k_main_faction_liu_bei"):ceo_management():remove_ceos("3k_main_ancillary_weapon_shuang_gu_jian_faction");

		-- Remove liu Bei's traits!
		local query_character = cm:query_model():character_for_template(template_liu_bei);

		if not query_character or query_character:is_null_interface() then
			cdir_mission_manager:print("********* ERROR: Cannot find Liu Bei's startpos key!!!! *********");
			return;
		end;

		local modify_character = cm:modify_character(query_character); -- Liu Bei spId.

		modify_character:ceo_management():remove_ceos("3k_main_ceo_trait_personality_kind");
		modify_character:ceo_management():remove_ceos("3k_main_ceo_trait_personality_humble");
		modify_character:ceo_management():remove_ceos("3k_main_ceo_trait_personality_fraternal");

		core:trigger_event(success_key .. "fire_intro");
	end,
	false --Is persistent
);

-- Intro Event.
cdir_mission_manager:start_incident_db_listener(
	local_faction_key, -- faction_key 
	"3k_dlc04_introduction_liu_bei_incident", -- event_key 
	success_key .. "fire_intro", -- trigger event 
	function(context)
		return true;
	end, --listener condition
	false, -- fire_once.
	success_key.."intro_fired", -- completion event 
	nil, -- failure event
	false -- delay start
);

cdir_mission_manager:start_mission_db_listener(
	local_faction_key, -- faction_key 
	"3k_dlc04_tutorial_liu_bei_defeat_army_mission", -- event_key 
	success_key.."intro_fired", -- trigger event 
	function(context)
		return true;
	end, --listener condition
	false, -- fire_once.
	success_key.."fought_bandits", -- completion event 
	failure_key.."fought_bandits", -- failure event
	false -- delay start
);

cdir_mission_manager:start_mission_db_listener(
	local_faction_key, -- faction_key 
	"3k_dlc04_tutorial_liu_bei_recruit_units_mission", -- event_key 
	success_key.."fought_bandits", -- trigger event 
	function(context)
		return true;
	end, --listener condition
	false, -- fire_once.
	success_key.."recruited_units", -- completion event 
	failure_key.."recruited_units", -- failure event
	false -- delay start
);
-- #endregion


-- #region Travelling the lands
--[[
***************************************************
***************************************************
** Travelling the lands
***************************************************
***************************************************
]]--

-- Visit Lu Zhi
cdir_mission_manager:start_mission_db_listener(
	local_faction_key, -- faction_key 
	"3k_dlc04_tutorial_liu_bei_goto_lu_zhi_mission", -- event_key 
	success_key.."fought_bandits", -- trigger event 
	function(context)
		return true;
	end, --listener condition
	false, -- fire_once.
	success_key.."visited_lu_zhi", -- completion event 
	failure_key.."visited_lu_zhi", -- failure event
	false -- delay start
);

-- Fight rebels 1
cdir_mission_manager:start_mission_db_listener(
	local_faction_key, -- faction_key 
	"3k_dlc04_tutorial_liu_bei_defeat_army_1_mission", -- event_key 
	success_key.."visited_lu_zhi", -- trigger event 
	function(context)
		local query_character = cm:query_model():character_for_template(template_liu_bei);
		if query_character and not query_character:is_null_interface() then
			campaign_invasions:create_invasion_attack_force("3k_dlc04_faction_rebels", "3k_main_henei_capital", 1, query_character:command_queue_index(), true, 477, 510);
		end;
		return true;
	end, --listener condition
	false, -- fire_once.
	success_key.."beat_rebels_01", -- completion event 
	nil, -- failure event
	false -- delay start
);

-- Travel to pingyuan
cdir_mission_manager:start_mission_db_listener(
	local_faction_key, -- faction_key 
	"3k_dlc04_tutorial_liu_bei_goto_anxi_mission", -- event_key 
	success_key.."beat_rebels_01", -- trigger event 
	function(context)
		return true;
	end, --listener condition
	false, -- fire_once.
	success_key.."reached_anxi", -- completion event 
	nil, -- failure event
	false -- delay start
);

-- Fight rebels 2
cdir_mission_manager:start_mission_db_listener(
	local_faction_key, -- faction_key 
	"3k_dlc04_tutorial_liu_bei_defeat_army_2_mission", -- event_key 
	success_key.."reached_anxi", -- trigger event 
	function(context)
		local query_character = cm:query_model():character_for_template(template_liu_bei);
		if query_character and not query_character:is_null_interface() then
			campaign_invasions:create_invasion_attack_force("3k_dlc04_faction_rebels", "3k_main_pingyuan_capital", 1, query_character:command_queue_index(), true);
		end;
		
		return true;
	end, --listener condition
	false, -- fire_once.
	success_key.."beat_rebels_02", -- completion event 
	nil, -- failure event
	false -- delay start
);

-- Travel to Han Fu
cdir_mission_manager:start_mission_db_listener(
	local_faction_key, -- faction_key 
	"3k_dlc04_tutorial_liu_bei_goto_han_fu_mission", -- event_key 
	success_key.."beat_rebels_02", -- trigger event 
	function(context)
		diplomacy_manager:grant_military_access(local_faction_key, "3k_main_faction_han_fu", true);
		return true;
	end, --listener condition
	false, -- fire_once.
	success_key.."reached_han_fu", -- completion event 
	nil, -- failure event
	false -- delay start
);

-- Fight rebels 3
cdir_mission_manager:start_mission_db_listener(
	local_faction_key, -- faction_key 
	"3k_dlc04_tutorial_liu_bei_defeat_army_3_mission", -- event_key 
	success_key.."reached_han_fu", -- trigger event 
	function(context)
		local query_character = cm:query_model():character_for_template(template_liu_bei);
		if query_character and not query_character:is_null_interface() then
			campaign_invasions:create_invasion_attack_force("3k_dlc04_faction_rebels", "3k_main_bohai_capital", 2, query_character:command_queue_index(), true);
		end;

		return true;
	end, --listener condition
	false, -- fire_once.
	success_key.."beat_rebels_03", -- completion event 
	nil, -- failure event
	false -- delay start
);

-- #endregion

-- #region The Hero's Journey
--[[
***************************************************
***************************************************
** The Hero's Journey
***************************************************
***************************************************
]]--

-- Initialise the chain.
core:add_listener(
	local_faction_key, -- Unique handle
	"FactionTurnStart", -- Campaign Event to listen for
	function(context) -- Criteria
		return cdir_mission_manager:get_turn_number() == 3 and context:faction():name() == local_faction_key;
	end,
	function(context) -- What to do if listener fires.
		core:trigger_event("3k_dlc04_tutorial_liu_bei_heros_journey_start");
	end,
	false --Is persistent
);

cdir_mission_manager:start_dilemma_db_listener(
	local_faction_key, -- faction_key 
	"3k_dlc04_progression_liu_bei_heros_journey_01_dilemma", -- event_key 
	"3k_dlc04_tutorial_liu_bei_heros_journey_start", -- trigger event 
	function(context)
		return true;
	end, --listener condition
	false, -- fire_once.
	"3k_dlc04_tutorial_liu_bei_heros_journey_01", -- completion event 
	"3k_dlc04_tutorial_liu_bei_heros_journey_01" -- failure event
);

cdir_mission_manager:start_dilemma_db_listener(
	local_faction_key, -- faction_key 
	"3k_dlc04_progression_liu_bei_heros_journey_02_dilemma", -- event_key 
	"3k_dlc04_tutorial_liu_bei_heros_journey_01", -- trigger event 
	function(context)
		return true;
	end, --listener condition
	false, -- fire_once.
	"3k_dlc04_tutorial_liu_bei_heros_journey_02", -- completion event 
	"3k_dlc04_tutorial_liu_bei_heros_journey_02", -- failure event
	true -- delay_start
);

cdir_mission_manager:start_dilemma_db_listener(
	local_faction_key, -- faction_key 
	"3k_dlc04_progression_liu_bei_heros_journey_03_dilemma", -- event_key 
	"3k_dlc04_tutorial_liu_bei_heros_journey_02", -- trigger event 
	function(context)
		return true;
	end, --listener condition
	false, -- fire_once.
	"3k_dlc04_tutorial_liu_bei_heros_journey_03", -- completion event 
	"3k_dlc04_tutorial_liu_bei_heros_journey_03", -- failure event
	true -- delay_start
);

cdir_mission_manager:start_dilemma_db_listener(
	local_faction_key, -- faction_key 
	"3k_dlc04_progression_liu_bei_heros_journey_04_dilemma", -- event_key 
	"3k_dlc04_tutorial_liu_bei_heros_journey_03", -- trigger event 
	function(context)
		return true;
	end, --listener condition
	false, -- fire_once.
	nil, -- completion event 
	nil, -- failure event
	true -- delay start
);

-- #endregion

-- #region The Peach Garden
--[[
***************************************************
***************************************************
** The Peach Garden
***************************************************
***************************************************
]]--

-- Liu bei & peach garden

-- Peach garden oath moved to global_events (campaign\dlc04_mandate\dlc04_campaign_global_events.lua).
-- Allows this to fire for others, not just liu_bei.
core:add_listener(
	"3k_dlc04_progression_liu_bei_peach_garden",
	success_key.."beat_rebels_03",
	true,
	function()
		-- force trigger our global event.
		global_events_manager:trigger_global_event_from_string("peach_garden_00");
	end,
	false
)

-- Horse Merchants
cdir_mission_manager:start_incident_db_listener(
	local_faction_key, -- faction_key 
	"3k_dlc04_progression_liu_bei_horse_merchants_incident", -- event_key 
	"FactionTurnStart", -- trigger event 
	function(context)
		return global_events_manager:get_flag("PeachGardenOathMade") and context:faction():name() == local_faction_key;
	end, --listener condition
	false, -- fire_once.
	"DLC04_Events_LiuBei_HorseMerchants", -- completion event 
	nil -- failure event
);

core:add_listener(
	local_faction_key, -- Unique handle
	"DLC04_Events_LiuBei_HorseMerchants", -- Campaign Event to listen for
	true,
	function(context) -- What to do if listener fires.
		core:add_listener(
			local_faction_key, -- Unique handle
			"FactionCeoAdded", -- Campaign Event to listen for
			function(context) -- Criteria
				--Criteria Test
				return context:ceo():ceo_data_key() == "3k_main_ancillary_weapon_shuang_gu_jian_faction"
			end,
			function(context) -- What to do if listener fires.
				local q_char = cm:query_model():character_for_template(template_liu_bei);
				if q_char and not q_char:is_null_interface() then
					ancillaries:equip_ceo_on_character( q_char, "3k_main_ancillary_weapon_shuang_gu_jian_faction", "3k_main_ceo_category_ancillary_weapon" )
				end;
			end,
			false --Is persistent
		);

		core:add_listener(
			local_faction_key, -- Unique handle
			"FactionCeoAdded", -- Campaign Event to listen for
			function(context) -- Criteria
				--Criteria Test
				return context:ceo():ceo_data_key() == "3k_main_ancillary_weapon_serpent_spear_faction"
			end,
			function(context) -- What to do if listener fires.
				local q_char = cm:query_model():character_for_template(template_zhang_fei);
				if q_char and not q_char:is_null_interface() then
					ancillaries:equip_ceo_on_character( q_char, "3k_main_ancillary_weapon_serpent_spear_faction", "3k_main_ceo_category_ancillary_weapon" )
				end;
			end,
			false --Is persistent
		);

		core:add_listener(
			local_faction_key, -- Unique handle
			"FactionCeoAdded", -- Campaign Event to listen for
			function(context) -- Criteria
				--Criteria Test
				return context:ceo():ceo_data_key() == "3k_main_ancillary_weapon_green_dragon_crescent_blade_faction"
			end,
			function(context) -- What to do if listener fires.
				local q_char = cm:query_model():character_for_template(template_guan_yu);
				if q_char and not q_char:is_null_interface() then
					ancillaries:equip_ceo_on_character( q_char, "3k_main_ancillary_weapon_green_dragon_crescent_blade_faction", "3k_main_ceo_category_ancillary_weapon" )
				end
			end,
			false --Is persistent
		);
	end,
	false --Is persistent
);
-- #endregion

-- #region Liu Bei Becomes a prefect
--[[
***************************************************
***************************************************
** Liu Bei Becomes a prefect
***************************************************
***************************************************
]]--

-- Liu Bei becomes prefect
cdir_mission_manager:start_incident_db_listener(
	local_faction_key, -- faction_key 
	"3k_dlc04_progression_liu_bei_becomes_prefect_anxi_incident", -- event_key 
	"ScriptEventLiuBeiProgressionDLC04Mission01Complete", -- trigger event 
	function(context)
		return true;
	end, --listener condition
	false, -- fire_once.
	nil, -- completion event 
	nil -- failure event
);

-- Whips the official
cdir_mission_manager:start_incident_db_listener(
	local_faction_key, -- faction_key 
	"3k_dlc04_progression_liu_bei_whips_the_official_incident", -- event_key 
	"FactionTurnStart", -- trigger event 
	function(context)
		return cdir_mission_manager:get_turn_number() == 13 and context:faction():name() == local_faction_key;
	end, --listener condition
	false, -- fire_once.
	nil, -- completion event 
	nil -- failure event
);
-- #endregion


-- #region Progression
--[[
***************************************************
***************************************************
** PROGRESSION
***************************************************
***************************************************
]]--
-- start the progression missions
core:add_listener(
    "start_progression_missions",
    "FactionTurnStart",
	function(context)
		return cdir_mission_manager:get_turn_number() == 9 and context:faction():name() == local_faction_key;
	end,
	function(context)
		local query_character = cm:query_model():character_for_template(template_liu_bei);
		if query_character and not query_character:is_null_interface() then
			campaign_invasions:create_invasion_attack_force("3k_main_faction_yellow_turban_generic", "3k_main_weijun_capital", 2, query_character:command_queue_index());
			campaign_invasions:create_invasion_attack_force("3k_main_faction_yellow_turban_generic", "3k_main_zhongshan_capital", 2, query_character:command_queue_index());
			campaign_invasions:create_invasion_attack_force("3k_main_faction_yellow_turban_generic", "3k_main_bohai_resource_1", 1, query_character:command_queue_index());
		end;

        core:trigger_event("ScriptEventLiuBeiProgressionDLC04Mission01Trigger");
    end,
    false
);
-- DLC04

-- liu bei dlc04 progression mission 1
cdir_mission_manager:start_mission_listener(
    local_faction_key,                          		-- faction key
    "3k_dlc04_victory_objective_chain_liu_bei_1",        -- mission key
    "DEFEAT_N_ARMIES_OF_FACTION",                 -- objective type
    {
		"subculture 3k_main_subculture_yellow_turban",
		"total 3"
    },                                                  -- conditions (single string or table of strings)
    {
        "money 2000"
    },                                                  -- mission rewards (table of strings)
	"ScriptEventLiuBeiProgressionDLC04Mission01Trigger",      -- trigger event 
	nil,												-- Listener condition
	false,												-- Fire once
	"ScriptEventLiuBeiProgressionDLC04Mission01Complete",     -- completion event
	nil,														-- failure event
	"3k_main_victory_objective_issuer"							--mission_issuer
)

-- liu bei dlc04 progression mission 2
cdir_mission_manager:start_mission_listener(
    local_faction_key,                          		-- faction key
    "3k_dlc04_victory_objective_chain_liu_bei_2",        -- mission key
    "CONTROL_N_REGIONS_INCLUDING",                 -- objective type
    {
        "total 3",
        "region 3k_main_pingyuan_capital",
        "exclude_allies"
    },                                                  -- conditions (single string or table of strings)
    {
        "money 2000"
    },                                                  -- mission rewards (table of strings)
	"ScriptEventLiuBeiProgressionDLC04Mission01Complete",      -- trigger event 
	nil,												-- Listener condition
	false,												-- Fire once
	"ScriptEventLiuBeiProgressionDLC04Mission02Complete",     -- completion event
	nil,														-- failure event
	"3k_main_victory_objective_issuer"							--mission_issuer
)

-- liu bei dlc04 progression mission 3
cdir_mission_manager:start_mission_listener(
    local_faction_key,                          		-- faction key
    "3k_dlc04_victory_objective_chain_liu_bei_3",        -- mission key
    "ATTAIN_FACTION_PROGRESSION_LEVEL",                 -- objective type
    {
        "rank_second_marquis"
    },                                                  -- conditions (single string or table of strings)
    {
        "money 2000"
    },                                                  -- mission rewards (table of strings)
	"ScriptEventLiuBeiProgressionDLC04Mission02Complete",      -- trigger event 
	nil,												-- Listener condition
	false,												-- Fire once
	"ScriptEventLiuBeiProgressionMission01Trigger",     -- completion event
	nil,														-- failure event
	"3k_main_victory_objective_issuer"							--mission_issuer
)

-- MAIN GAME
-- liu bei progression mission 1
cdir_mission_manager:start_mission_listener(
    local_faction_key,                          		-- faction key
    "3k_main_victory_objective_chain_1_liu_bei",        -- mission key
    "ATTAIN_FACTION_PROGRESSION_LEVEL",                 -- objective type
    {
        "rank_duke"
    },                                                  -- conditions (single string or table of strings)
    {
        "money 2000"
    },                                                  -- mission rewards (table of strings)
	"ScriptEventLiuBeiProgressionMission01Trigger",      -- trigger event 
	nil,												-- Listener condition
	false,												-- Fire once
	"ScriptEventLiuBeiProgressionMission01Complete",     -- completion event
	nil,														-- failure event
	"3k_main_victory_objective_issuer"							--mission_issuer
)

-- liu bei progression mission 02
cdir_mission_manager:start_mission_listener(
    local_faction_key,                          -- faction key
    "3k_main_victory_objective_chain_2_han_warlords",                    -- mission key
    "BECOME_WORLD_LEADER",                                  -- objective type
    nil,                                                    -- conditions (single string or table of strings)
    {
        "money 5000"
    },                                                  -- mission rewards (table of strings)
	"ScriptEventLiuBeiProgressionMission01Complete",      -- trigger event 
	nil,												-- Listener condition
	false,												-- Fire once
    "ScriptEventLiuBeiProgressionMission02Complete",     -- completion event
	nil,														-- failure event
	"3k_main_victory_objective_issuer"							--mission_issuer
)

-- liu bei progression mission 03
cdir_mission_manager:start_mission_listener(
    "3k_main_faction_liu_bei",                          -- faction key
    "3k_main_victory_objective_chain_3_han",                     -- mission key
    "DESTROY_ALL_WORLD_LEADERS",                                  -- objective type
    nil,                                                -- conditions (single string or table of strings)
    {
        "money 10000"
    },                                                  -- mission rewards (table of strings)
	"ScriptEventLiuBeiProgressionMission02Complete",      -- trigger event 
	nil,												-- Listener condition
	false,												-- Fire once
    "ScriptEventLiuBeiProgressionMission03Complete",     -- completion event
	nil,														-- failure event
	"3k_main_victory_objective_issuer"							--mission_issuer
)

-- liu bei progression mission 04
cdir_mission_manager:start_mission_listener(
    "3k_main_faction_liu_bei",                          -- faction key
    "3k_main_victory_objective_chain_4",                     -- mission key
    "CONTROL_N_REGIONS_INCLUDING",                                  -- objective type
    {
        "total 95"
    }, 
    {
        "money 10000"
    },                                                  -- mission rewards (table of strings)
	"ScriptEventLiuBeiProgressionMission03Complete",      -- trigger event 
	nil,												-- Listener condition
	false,												-- Fire once
    "ScriptEventLiuBeiProgressionMissionsCompleted",     -- completion event
	nil,														-- failure event
	"3k_main_victory_objective_issuer"							--mission_issuer
)
-- #endregion
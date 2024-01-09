--[[
***************************************************
***************************************************
** VARIABLES
***************************************************
***************************************************
]]--
local local_faction_key = "3k_main_faction_dong_zhuo";
local success_key = "dlc04_" .. local_faction_key .. "_success";
local failure_key = "dlc04_" .. local_faction_key .. "_failure";

output("Events script loaded for " .. local_faction_key);
setup_shared_faction_events_han_empire(local_faction_key, success_key, failure_key);

local lu_bu_cqi;

if not cm:query_model():character_for_startpos_id("189347572"):is_null_interface() then
	lu_bu_cqi = cm:query_model():character_for_startpos_id("189347572"):command_queue_index();
end;

-- Spawn initial armies and give them a settlement
local function initial_set_up()
	local invasion = campaign_invasions:create_invasion("3k_dlc04_faction_rebels", "3k_main_henei_capital", 1, true, local_faction_key, true, 311, 606);
	invasion:set_force_retreated();
	invasion:start_invasion();

	local rebel_faction_interface = cm:modify_faction("3k_dlc04_faction_rebels")
	cm:modify_region("3k_main_shoufang_resource_1"):settlement_gifted_as_if_by_payload(rebel_faction_interface)
end;

cm:add_first_tick_callback_new(initial_set_up);


-- #region progression events
--[[
***************************************************
***************************************************
** Intro
***************************************************
***************************************************
]]--
-- Remove the special weapons from liu bei 
core:add_listener(
	local_faction_key .. "_event_listener", -- Unique handle
	"FactionTurnStart", -- trigger event 
	function(context)
		return cdir_mission_manager:get_turn_number() == 1 and context:faction():name() == local_faction_key;
	end,
	function(context) -- What to do if listener fires.
		-- We'll remove their ancillaries so they can get them later, but when NOT playing as them, this won't happen.
		cm:modify_faction("3k_dlc04_faction_ding_yuan"):ceo_management():remove_ceos("3k_main_ancillary_mount_red_hare");
		core:trigger_event(success_key .. "start")
	end,
	false --Is persistent
);

cdir_mission_manager:start_incident_db_listener(
	local_faction_key, -- faction_key 
	"3k_dlc04_introduction_dong_zhuo_incident", -- event_key 
	success_key .. "start", -- trigger event 
	function(context)
		return true;
	end, --listener condition
	false, -- fire_once.
	success_key.."intro_fired", -- completion event 
	nil -- failure event
);

cdir_mission_manager:start_mission_db_listener(
	local_faction_key, -- faction_key 
	"3k_dlc04_progression_dong_zhuo_intro_engage_first_force_mission", -- event_key 
	success_key.."intro_fired", -- trigger event 
	function(context)
		return true;
	end, --listener condition
	false, -- fire_once.
	success_key.."engaged_first_force", -- completion event 
	failure_key.."engaged_first_force" -- failure event
);

cdir_mission_manager:start_mission_db_listener(
	local_faction_key, -- faction_key 
	"3k_dlc04_progression_dong_zhuo_intro_capture_region_mission", -- event_key 
	success_key.."engaged_first_force", -- trigger event 
	function(context)
		return true;
	end, --listener condition
	false, -- fire_once.
	success_key.."captured_region", -- completion event 
	failure_key.."captured_region" -- failure event
);

cdir_mission_manager:start_mission_db_listener(
	local_faction_key, -- faction_key 
	"3k_dlc04_progression_dong_zhuo_intro_secure_province_mission", -- event_key 
	success_key.."captured_region", -- trigger event 
	function(context)
		return true;
	end, --listener condition
	false, -- fire_once.
	success_key.."secured_province", -- completion event 
	failure_key.."secured_province" -- failure event
);
-- #endregion



--[[
***************************************************
***************************************************
** Red Hare
***************************************************
***************************************************
]]--
-- #region Red Hare

cdir_mission_manager:start_mission_db_listener(
	local_faction_key, -- faction_key 
	"3k_dlc04_progression_dong_zhuo_red_hare_mission", -- event_key 
	"FactionTurnStart", -- trigger event 
	function(context)
		return cdir_mission_manager:get_turn_number() == 6 and context:faction():name() == local_faction_key;
	end, --listener condition
	false, -- fire_once.
	nil, -- completion event 
	nil -- failure event
);

-- #endregion

-- #region Claiming Lu Bu
--[[
***************************************************
***************************************************
** Claiming Lu Bu
***************************************************
***************************************************
]]--

core:add_listener(
	"3k_dlc04_progression_dong_zhuo_hirelubu_backup_incident", -- Unique handle
	"CharacterDied", -- Campaign Event to listen for
	function(context) --Criteria
		return context:query_character():generation_template_key() == "3k_dlc04_template_historical_ding_yuan_wood" and context:query_character():faction():name() == "3k_dlc04_faction_ding_yuan";
	end,
	function(context) -- What to do if listener fires
		cm:trigger_incident(local_faction_key,"3k_dlc04_progression_dong_zhuo_hirelubu_backup_incident",true)
	end,
	false --Is persistent?
);

core:add_listener(
	"3k_main_faction_dong_zhuo_events_lubu", -- Unique handle
	"FactionTurnStart", -- Campaign Event to listen for
	function(context) -- Criteria
		return cdir_mission_manager:get_turn_number() >= 30 and context:faction():name() == local_faction_key;
	end,
	function(context) -- What to do if listener fires.
		core:trigger_event(success_key .. "_lu_bu_intro");
	end,
	false --Is persistent
);

cdir_mission_manager:start_incident_db_listener(
	local_faction_key, -- faction_key 
	"3k_dlc04_progression_dong_zhuo_hirelubu_01_meeting_incident", -- event_key 
	success_key .. "_lu_bu_intro", -- trigger event 
	function(context)
		return true;
	end, --listener condition
	false, -- fire_once.
	success_key .. "_met_lu_bu", -- completion event 
	nil, -- failure event
	false -- delay start
);

-- Other incidents, crafted as follow-ups in DaVE.
cdir_mission_manager:start_dilemma_db_listener(
	local_faction_key, -- faction_key 
	"3k_dlc04_progression_dong_zhuo_hirelubu_02_bribery_dilemma", -- event_key 
	success_key .. "_met_lu_bu", -- trigger event 
	function(context)
		return true
	end, --listener condition
	false, -- fire_once.
	nil, -- completion event 
	nil, -- failure event
	true, -- delay start
	nil, -- on trigger event
	success_key .. "_gave_gold", -- Choice A
	success_key .. "_do_nothing", -- Choice B
	success_key .. "_lu_bu_defects" -- Choice C
);

-- If the player gives only gold, then roll a random chance of him joining or not.
core:add_listener(
	local_faction_key, -- Unique handle
	success_key .. "_gave_gold", -- Campaign Event to listen for
	true,
	function(context) -- What to do if listener fires.
		if cm:roll_random_chance(50) then
			core:trigger_event(success_key .. "_lu_bu_defects");
		else
			core:trigger_event(success_key .. "_lu_bu_betrays");
		end;
	end,
	false --Is persistent
);

-- Split here as there may be different outcomes.
cdir_mission_manager:start_dilemma_db_listener(
	local_faction_key, -- faction_key 
	"3k_dlc04_progression_dong_zhuo_hirelubu_03a_joins_dilemma", -- event_key 
	success_key .. "_lu_bu_defects", -- trigger event 
	function(context)
		return true;
	end, --listener condition
	false, -- fire_once.
	nil, -- completion event 
	nil, -- failure event
	true, -- delay start
	nil, -- on trigger event. 
	success_key .. "_hired_lu_bu", -- Choice A
	success_key .. "_sent_away_lu_bu" -- Choice B
);

-- If we 'gave away' red hare, make sure lu bu gets it after.
core:add_listener(
	local_faction_key, -- Unique handle
	success_key .. "_hired_lu_bu", -- Campaign Event to listen for
	true,
	function(context) -- What to do if listener fires.
		local q_dz_faction = cm:query_faction(local_faction_key);
		local m_dz_faction = cm:modify_faction(local_faction_key);

		-- Exit if DZ died.
		if not q_dz_faction or q_dz_faction:is_null_interface() then
			return;
		end;

		-- If the player didn't give away red hare, then do nothing.
		if ancillaries:faction_has_ceo_key(q_dz_faction:ceo_management(), "3k_main_ancillary_mount_red_hare") then
			return false;
		end;

		--if lu bu has died, then we'll just give it back.
		if cm:query_character(lu_bu_cqi):is_dead() then
			
			m_dz_faction:ceo_management():add_ceo("3k_main_ancillary_mount_red_hare");

		-- Otherwise, spawn on Lu Bu and wait for him to gain the ancillary.
		else
			-- Make Lu Bu equip it.
			core:add_listener(
				local_faction_key, -- Unique handle
				"FactionCeoAdded", -- Campaign Event to listen for
				function(context) -- Criteria
					return context:ceo():ceo_data_key() == "3k_main_ancillary_mount_red_hare"
				end,
				function(context) -- What to do if listener fires.
					ancillaries:equip_ceo_on_character( cm:query_character(lu_bu_cqi), "3k_main_ancillary_mount_red_hare", "3k_main_ceo_category_ancillary_mount" )
				end,
				false --Is persistent
			);

			-- Add the CEO to Lu Bu's faction.
			local q_faction_lu_bu = cm:query_character(lu_bu_cqi):faction();
			local m_faction_lu_bu = cm:modify_faction(q_faction_lu_bu);
			m_faction_lu_bu:ceo_management():add_ceo("3k_main_ancillary_mount_red_hare");

		end;
			
	end,
	false --Is persistent
);

cdir_mission_manager:start_incident_db_listener(
	local_faction_key, -- faction_key 
	"3k_dlc04_progression_dong_zhuo_hirelubu_03b_rebuffs_incident", -- event_key 
	success_key .. "_lu_bu_betrays", -- trigger event 
	function(context)
		return true;
	end, --listener condition
	false, -- fire_once.
	success_key.."_rebuffed_by_lu_bu", -- completion event 
	failure_key.."_rebuffed_by_lu_bu" -- failure event
);

-- #endregion

-- #region Local Rebellions
--[[
***************************************************
***************************************************
** YT/Rebel Forces
***************************************************
***************************************************
]]--

core:add_listener(
	"3k_main_faction_dong_zhuo_events_lubu", -- Unique handle
	"FactionTurnStart", -- Campaign Event to listen for
	function(context) -- Criteria
		return cdir_mission_manager:get_turn_number() == 3 and context:faction():name() == local_faction_key;
	end,
	function(context) -- What to do if listener fires.
		core:trigger_event(success_key .. "fight_rebels_01");
	end,
	false --Is persistent
);

cdir_mission_manager:start_mission_db_listener(
	local_faction_key, -- faction_key 
	"3k_dlc04_progression_dong_zhuo_fight_rebels_01_mission", -- event_key 
	success_key.."fight_rebels_01", -- trigger event 
	function(context)
		-- Abusing the function here, but using the criteria test to actually fire the invasions.
		local character_leading_force_cqi= cm:modify_faction(local_faction_key):query_faction():military_force_list():item_at(0):character_list():item_at(0):command_queue_index();
		-- campaign_invasions:create_invasion_attack_character(invasion_faction_key, spawn_region, difficulty_rating, target_character_cqi, opt_suppress_event_feed, opt_x, opt_y)
		campaign_invasions:create_invasion_attack_character("3k_dlc04_faction_rebels", "3k_main_shoufang_resource_2", 1, character_leading_force_cqi, false, 265, 598);
		
		local rebel_faction = cm:modify_faction("3k_dlc04_faction_rebels");
		local rebel_region = cm:modify_region("3k_main_shoufang_resource_2");
		if rebel_region and not rebel_region:is_null_interface() 
			and rebel_faction and not rebel_faction:is_null_interface() then

			rebel_region:settlement_gifted_as_if_by_payload(rebel_faction);
		end;
		return true;
	end, --listener condition
	false, -- fire_once.
	success_key.."fight_rebels_02", -- completion event 
	failure_key.."fight_rebels_02", -- failure event
	true -- delay_start
);

cdir_mission_manager:start_mission_db_listener(
	local_faction_key, -- faction_key 
	"3k_dlc04_progression_dong_zhuo_fight_rebels_02_mission", -- event_key 
	success_key .. "fight_rebels_02", -- trigger event 
	function(context)
		-- Abusing the function here, but using the criteria test to actually fire the invasions.
		-- campaign_invasions:create_invasion(invasion_faction_key, spawn_region, difficulty_rating, opt_delay_start, opt_target_faction, opt_suppress_event_feed, opt_x, opt_y)
		campaign_invasions:create_invasion("3k_dlc04_faction_rebels", "3k_main_shoufang_resource_2", 1, false, local_faction_key, false, 244, 588);
		-- campaign_invasions:create_invasion_attack_region(invasion_faction_key, spawn_region, difficulty_rating, target_region, opt_suppress_event_feed, opt_x, opt_y)
		campaign_invasions:create_invasion_attack_region("3k_dlc04_faction_rebels", "3k_main_xihe_resource_1", 2, "3k_main_xihe_capital", false, 357, 525);
		-- campaign_invasions:create_invasion(invasion_faction_key, spawn_region, difficulty_rating, opt_delay_start, opt_target_faction, opt_suppress_event_feed, opt_x, opt_y)
		campaign_invasions:create_invasion("3k_dlc04_faction_rebels", "3k_main_anding_resource_1", 3, false, "3k_main_faction_han_empire", false, 305, 524);

		return true;
	end, --listener condition
	false, -- fire_once.
	nil, -- completion event 
	nil -- failure event
);

-- #endregion

--[[
***************************************************
***************************************************
** PROGRESSION
***************************************************
***************************************************
]]--
-- #region progression

-- start the progression missions from the intro incident.

-- DLC04
-- progression mission 1
cdir_mission_manager:start_mission_listener(
    local_faction_key,                          		-- faction key
    "3k_dlc04_victory_objective_chain_dong_zhuo_1",        -- mission key
    "ATTAIN_FACTION_PROGRESSION_LEVEL",                 -- objective type
    {
		"rank_noble"
    },                                                -- conditions (single string or table of strings)
    {
        "money 2000"
    },                                                  -- mission rewards (table of strings)
	success_key.."engaged_first_force",      -- trigger event 
	nil,												-- Listener condition
	false,												-- Fire once
	success_key .. "obj01",     -- completion event
	nil,														-- failure event
	"3k_main_victory_objective_issuer"							--mission_issuer
)

-- progression mission 2
cdir_mission_manager:start_mission_listener(
    local_faction_key,                          		-- faction key
    "3k_dlc04_victory_objective_chain_dong_zhuo_2",        -- mission key
    "ATTAIN_FACTION_PROGRESSION_LEVEL",                 -- objective type
    {
        "rank_second_marquis"
    },                                                 -- conditions (single string or table of strings)
    {
        "money 2000"
    },                                                  -- mission rewards (table of strings)
	success_key .. "obj01",      -- trigger event 
	nil,												-- Listener condition
	false,												-- Fire once
	success_key .. "obj02",     -- completion event
	nil,														-- failure event
	"3k_main_victory_objective_issuer"							--mission_issuer
)

-- Main Game
-- dong zhuo progression mission 01
cdir_mission_manager:start_mission_listener(
    "3k_main_faction_dong_zhuo",                          -- faction key
    "3k_main_victory_objective_chain_2_han_warlords",                    -- mission key
    "BECOME_WORLD_LEADER",                                  -- objective type
    nil,                                                    -- conditions (single string or table of strings)
    {
        "money 5000"
    },                                                  -- mission rewards (table of strings)
	success_key .. "obj02",      -- trigger event
	nil,
	false, 
	"ScriptEventDongZhuoProgressionMission01Complete",      -- completion event
	nil,
	"3k_main_victory_objective_issuer"							--mission_issuer
)

-- dong zhuo progression mission 02
cdir_mission_manager:start_mission_listener(
    "3k_main_faction_dong_zhuo",                          -- faction key
    "3k_main_victory_objective_chain_3_han",                     -- mission key
    "DESTROY_ALL_WORLD_LEADERS",                                  -- objective type
    nil,                                                -- conditions (single string or table of strings)
    {
        "money 10000"
    },                                                  -- mission rewards (table of strings)
	"ScriptEventDongZhuoProgressionMission01Complete",      -- trigger event
	nil,
	false,
    "ScriptEventDongZhuoProgressionMission02Complete",      -- completion event
	nil,
	"3k_main_victory_objective_issuer"							--mission_issuer
)

-- dong zhuo progression mission 03
cdir_mission_manager:start_mission_listener(
    "3k_main_faction_dong_zhuo",                          -- faction key
    "3k_main_victory_objective_chain_4",                     -- mission key
    "CONTROL_N_REGIONS_INCLUDING",                                  -- objective type
    {
        "total 95"
    }, 
    {
        "money 15000"
    },                                                  -- mission rewards (table of strings)
    "ScriptEventDongZhuoProgressionMission02Complete",      -- trigger event
	nil,
	false,
    "ScriptEventDongZhuoProgressionMission03Complete",      -- completion event
	nil,
	"3k_main_victory_objective_issuer"							--mission_issuer
)
-- #endregion


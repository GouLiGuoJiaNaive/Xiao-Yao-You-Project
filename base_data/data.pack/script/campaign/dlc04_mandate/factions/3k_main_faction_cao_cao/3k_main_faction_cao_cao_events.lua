--[[
***************************************************
***************************************************
** VARIABLES
***************************************************
***************************************************
]]--
local local_faction_key = "3k_main_faction_cao_cao";
local success_key = "dlc04_" .. local_faction_key .. "_success";
local failure_key = "dlc04_" .. local_faction_key .. "_failure";

output("Events script loaded for " .. local_faction_key);
setup_shared_faction_events_han_empire(local_faction_key, success_key, failure_key);

-- Spawn initial armies.
local function initial_set_up()
	local invasion = campaign_invasions:create_invasion("3k_dlc04_faction_rebels", "3k_main_henei_capital", 1, true, local_faction_key, true, 545, 351); 
	invasion:set_force_retreated();
	invasion:start_invasion();

	diplomacy_manager:grant_military_access(local_faction_key, "3k_dlc04_faction_cao_song", true);
end;

cm:add_first_tick_callback_new(initial_set_up);


-- #region Helper Functions
-- Always 4ward declare or lua gets grumpy.

local function cao_cao_check_crime_fought()
	if global_events_manager:get_flag("cao_cao_fought_crime") then
		current_tally = global_events_manager:get_flag("cao_cao_fought_crime");
		global_events_manager:set_flag("cao_cao_fought_crime", current_tally + 1 );
	else
		global_events_manager:set_flag("cao_cao_fought_crime", 1 );
	end;

	if global_events_manager:get_flag("cao_cao_fought_crime") >= 3 then
		core:trigger_event(success_key.."mission_chen");
	end;
end;
-- #endregion


-- #region Intro

-- Initial Incident
cdir_mission_manager:start_incident_db_listener(
	local_faction_key, -- faction_key 
	"3k_dlc04_introduction_cao_cao_incident", -- event_key 
	"FactionTurnStart", -- trigger event 
	function(context)
		return cdir_mission_manager:get_turn_number() == 1 and context:faction():name() == local_faction_key;
	end, --listener condition
	false, -- fire_once.
	success_key.."intro_fired", -- completion event 
	nil -- failure event
);

-- engage first force
cdir_mission_manager:start_mission_db_listener(
	local_faction_key, -- faction_key 
	"3k_dlc04_tutorial_cao_cao_01_mission", -- event_key 
	success_key.."intro_fired", -- trigger event 
	function(context)
		return true
	end, --listener condition
	false, --fire_once
	success_key.."engaged_first_force", -- completion event 
	failure_key.."engaged_first_force", -- failure event
	false -- delay_start
);

-- Recruit Units - Intro to regionless recruitment.
cdir_mission_manager:start_mission_db_listener(
	local_faction_key, -- faction_key 
	"3k_dlc04_tutorial_cao_cao_recruit_units_mission", -- event_key 
	success_key.."engaged_first_force", -- trigger event 
	function(context)
		return true
	end, --listener condition
	false, --fire_once
	success_key.."recruited_units", -- completion event 
	failure_key.."recruited_units", -- failure event
	false -- delay_start
);

-- #endregion


-- #region Punishing Lawbreakers

-- Crime 01 - A thief has been stealing from the market - 3k_main_yangzhou_resource_3
cdir_mission_manager:start_mission_db_listener(
	local_faction_key, -- faction_key 
	"3k_dlc04_progression_cao_cao_fight_crime_01_mission", -- event_key
	success_key.."engaged_first_force", -- trigger event 
	function(context)
		return true
	end, --listener condition
	false, --fire_once
	success_key.."fought_crime_01", -- completion event 
	failure_key.."fought_crime_01", -- failure event
	false -- delay_start
);

-- Crime 01 - Seize Theif
cdir_mission_manager:start_dilemma_db_listener(
	local_faction_key, -- faction_key 
	"3k_dlc04_progression_cao_cao_fight_crime_01a_dilemma", -- event_key
	success_key.."fought_crime_01", -- trigger event 
	function(context)
		return true
	end, --listener condition
	false, --fire_once
	success_key.."fought_crime_01a", -- completion event 
	failure_key.."fought_crime_01a", -- failure event
	false, -- delay_start
	nil, -- on trigger event
	success_key .. "hired_thief", -- Choice A
	success_key .. "executed_thief" -- Choice B
);


-- Crime 02 - Bandits have been attacking merchants - 3k_main_poyang_resource_2
cdir_mission_manager:start_mission_db_listener(
	local_faction_key, -- faction_key 
	"3k_dlc04_progression_cao_cao_fight_crime_02_mission", -- event_key
	success_key.."engaged_first_force", -- trigger event 
	function(context)
		return true
	end, --listener condition
	false, --fire_once
	success_key.."fought_crime_02", -- completion event 
	failure_key.."fought_crime_02", -- failure event
	false -- delay_start
);

-- Crime 02 - Fight bandits  - 3k_main_poyang_resource_2
cdir_mission_manager:start_mission_db_listener(
	local_faction_key, -- faction_key 
	"3k_dlc04_progression_cao_cao_fight_crime_02a_mission", -- event_key
	success_key.."fought_crime_02", -- trigger event 
	function(context)
		local query_character = cm:query_faction(local_faction_key):faction_leader();
		if query_character and not query_character:is_null_interface() then
			campaign_invasions:create_invasion_attack_force("3k_dlc04_faction_rebels", "3k_main_poyang_resource_2", 1, query_character:command_queue_index(), true);
		end;

		return true
	end, --listener condition
	false, --fire_once
	success_key.."fought_crime_02a", -- completion event 
	failure_key.."fought_crime_02a", -- failure event
	false
);


-- Crime 03 - Magistrate accused of embezzeling funds. 3k_main_lujiang_resource_2
cdir_mission_manager:start_mission_db_listener(
	local_faction_key, -- faction_key 
	"3k_dlc04_progression_cao_cao_fight_crime_03_mission", -- event_key
	success_key.."engaged_first_force", -- trigger event 
	function(context)
		return true
	end, --listener condition
	false, --fire_once
	success_key.."fought_crime_03", -- completion event 
	failure_key.."fought_crime_03", -- failure event
	false -- delay_start
);

-- Crime 03 - Dilemma - Accuse / Take Bribe
cdir_mission_manager:start_dilemma_db_listener(
	local_faction_key, -- faction_key 
	"3k_dlc04_progression_cao_cao_fight_crime_03a_dilemma", -- event_key
	success_key.."fought_crime_03", -- trigger event 
	function(context)
		return true
	end, --listener condition
	false, --fire_once
	success_key.."fought_crime_03a", -- completion event 
	failure_key.."fought_crime_03a", -- failure event
	false, -- delay_start
	nil, -- on trigger event
	success_key .. "took_bribe", -- Choice A
	success_key .. "executed_magistrate" -- Choice B
);

-- Crime 03 - Fight battle, you should have killed that magistrate! - 3k_main_lujiang_resource_2
cdir_mission_manager:start_mission_db_listener(
	local_faction_key, -- faction_key 
	"3k_dlc04_progression_cao_cao_fight_crime_03b_mission", -- event_key
	success_key.."took_bribe", -- trigger event 
	function(context)
		local query_character = cm:query_faction(local_faction_key):faction_leader();
		if query_character and not query_character:is_null_interface() then
			campaign_invasions:create_invasion_attack_force("3k_dlc04_faction_rebels", "3k_main_lujiang_resource_2", 1, query_character:command_queue_index(), true);
		end;

		return true
	end, --listener condition
	false, --fire_once
	success_key.."fought_crime_03b", -- completion event 
	failure_key.."fought_crime_03b", -- failure event
	false -- delay_start
);

-- Crime 03 - Listener to complete the chain if you selected the correct option.
core:add_listener(
	local_faction_key .. "fought_crime_02a",
	success_key .. "fought_crime_02a",
	true,
	function()
		cao_cao_check_crime_fought();
	end,
	false
)

core:add_listener(
	local_faction_key .. "fought_crime_03b",
	success_key .. "fought_crime_03b",
	true,
	function()
		cao_cao_check_crime_fought();
	end,
	false
)

core:add_listener(
	local_faction_key .. "executed_magistrate",
	success_key .. "executed_magistrate",
	true,
	function()
		cao_cao_check_crime_fought();
	end,
	false
)

core:add_listener(
	local_faction_key .. "executed_thief",
	success_key .. "executed_thief",
	true,
	function()
		cao_cao_check_crime_fought();
	end,
	false
)

core:add_listener(
	local_faction_key .. "hired_thief",
	success_key .. "hired_thief",
	true,
	function()
		cao_cao_check_crime_fought();
	end,
	false
)

-- #endregion


-- #region Joining Characters
-- Cao Ren
cdir_mission_manager:start_incident_db_listener(
	local_faction_key, -- faction_key 
	"3k_dlc04_progression_cao_cao_characters_cao_ren_joins_incident", -- event_key 
	"CharacterComesOfAge", -- trigger event 
	function(context)
		local query_character = context:query_character();
		return query_character:generation_template_key() == "3k_main_template_historical_cao_ren_hero_earth" and query_character:faction():name() == local_faction_key;
	end, --listener condition
	false, -- fire_once.
	success_key.."cao_ren_joined", -- completion event 
	nil -- failure event
);

-- Xiahou Brothers -- Handled by global events.
-- #endregion


-- #region The Great Decision

-- Choose between Chen / Father's Lands
cdir_mission_manager:start_dilemma_db_listener(
	local_faction_key, -- faction_key 
	"3k_dlc04_progression_cao_cao_first_land_dilemma", -- event_key
	success_key.."mission_chen", -- trigger event 
	function(context)
		return true
	end, --listener condition
	false, --fire_once
	success_key.."first_land", -- completion event 
	failure_key.."first_land", -- failure event
	false, -- delay_start
	nil, -- on trigger event
	success_key .. "chose_chen", -- Choice A
	success_key .. "chose_xindu" -- Choice B
);

-- teleport cao cao



-- #region Chose Chen - 3k_main_chenjun_capital
core:add_listener(
    success_key.."chose_chen",
    success_key.."chose_chen",
    true,
    function()
		local query_fl = cm:query_faction(local_faction_key):faction_leader();
		local mod_fl = cm:modify_character(query_fl);

		local found_spawn, spawn_x, spawn_y = cm:query_faction(local_faction_key):get_valid_spawn_location_in_region("3k_main_chenjun_capital", true);
		if found_spawn then
			mod_fl:teleport_to(spawn_x, spawn_y);
		end;

		campaign_invasions:create_invasion_attack_region("3k_dlc04_faction_rebels", "3k_main_chenjun_resource_1", 3, "3k_main_chenjun_resource_1"); -- Attack chen livestock
		diplomacy_manager:force_declare_war("3k_dlc04_faction_rebels", local_faction_key, true);

		core:trigger_event("dlc04_cao_cao_events_took_chen");
    end,
    false
);

-- engage Force
cdir_mission_manager:start_mission_db_listener(
	local_faction_key, -- faction_key 
	"3k_dlc04_progression_cao_cao_chen_01_mission", -- event_key
	success_key.."chose_chen", -- trigger event 
	function(context)
		return true
	end, --listener condition
	false, --fire_once
	success_key.."chen_01", -- completion event 
	failure_key.."chen_01", -- failure event
	false -- delay_start
);

-- Build building
cdir_mission_manager:start_mission_db_listener(
	local_faction_key, -- faction_key 
	"3k_dlc04_progression_cao_cao_chen_02_mission", -- event_key
	success_key.."chen_01", -- trigger event 
	function(context)
		return true
	end, --listener condition
	false, --fire_once
	success_key.."chen_02", -- completion event 
	failure_key.."chen_02", -- failure event
	false -- delay_start
);

-- Manipulate faction
cdir_mission_manager:start_mission_db_listener(
	local_faction_key, -- faction_key 
	"3k_dlc04_progression_cao_cao_chen_03_mission", -- event_key
	success_key.."chen_02", -- trigger event 
	function(context)
		return true
	end, --listener condition
	false, --fire_once
	success_key.."chen_03", -- completion event 
	failure_key.."chen_03", -- failure event
	false -- delay_start
);
--[[ Commented out until we can get it fixed.
-- 3k_dlc04_progression_cao_cao_chen_03_mission
cdir_mission_manager:start_mission_listener(
    local_faction_key,                          -- faction key
    "3k_dlc04_progression_cao_cao_chen_03_mission",                     -- mission key
    "SCRIPTED",                      -- objective type
    {
		"script_key cao_cao_manipulated",
		"override_text mission_text_text_3k_dlc04_scripted_manipulate_factions"
    },                                           -- conditions (single string or table of strings)
    {
        "money 2000"
    },                                                  -- mission rewards (table of strings)
	success_key.."chen_02",      -- trigger event 
	function() 
		return true;
	end,												-- Listener condition
	false,												-- Fire once
	success_key.."chen_03",     					-- completion event
	failure_key.."chen_03",							-- failure event
	"3k_main_victory_objective_issuer"							--mission_issuer
);

core:add_listener(
	"3k_dlc04_progression_cao_cao_chen_03_mission_listener",
	"DiplomacyDealNegotiated",
	function(context)
		-- Check missions are active (cheaper test)
		local event_gen = cm:query_model():event_generator_interface();

		if not event_gen or event_gen:is_null_interface() then
			return false;
		end;

		if not event_gen:any_of_missions_active(cm:query_faction(local_faction_key), "3k_dlc04_progression_cao_cao_chen_03_mission;3k_dlc04_progression_cao_cao_xindu_03_mission") then
			return false;
		end;

		-- Check deal
		local deals = context:deals():deals()
		if deals:is_empty() then
			return false;
		end;

		for i=0, deals:num_items() - 1 do
			for j=0, deals:item_at(i):components():num_items() - 1 do
				if deals:item_at(i):components():item_at(j):treaty_component_key() == "dummy_components_attitude_manipulation_negative" or deals:item_at(i):components():item_at(j):treaty_component_key() == "dummy_components_attitude_manipulation_positive" then										
					return true;
				end
			end
		end

		return false;
	end,
	function(context)
		local mod_faction = cm:modify_faction(local_faction_key);
		
		mod_faction:complete_custom_mission("3k_dlc04_progression_cao_cao_chen_03_mission");
		mod_faction:complete_custom_mission("3k_dlc04_progression_cao_cao_xindu_03_mission");
	end,
	false
);
]]--
-- #endregion

-- #region Chose Xindu
core:add_listener(
    success_key .. "chose_xindu",
    success_key .. "chose_xindu",
    true,
    function()
        local query_fl = cm:query_faction(local_faction_key):faction_leader();
		local mod_fl = cm:modify_character(query_fl);

		local found_spawn, spawn_x, spawn_y = cm:query_faction(local_faction_key):get_valid_spawn_location_in_region("3k_main_xindu_capital", true);
		if found_spawn then
			mod_fl:teleport_to(spawn_x, spawn_y);
		end;

		campaign_invasions:create_invasion_attack_region("3k_dlc04_faction_rebels", "3k_main_xindu_resource_1", 4, "3k_main_xindu_resource_1"); -- attack Xindu Farmland
		diplomacy_manager:force_declare_war("3k_dlc04_faction_rebels", local_faction_key, true);
    end,
    false
);

-- Engage Force
cdir_mission_manager:start_mission_db_listener(
	local_faction_key, -- faction_key 
	"3k_dlc04_progression_cao_cao_xindu_01_mission", -- event_key
	success_key.."chose_xindu", -- trigger event 
	function(context)
		return true
	end, --listener condition
	false, --fire_once
	success_key.."xindu_01", -- completion event 
	failure_key.."xindu_01", -- failure event
	false -- delay_start
);

-- Build building
cdir_mission_manager:start_mission_db_listener(
	local_faction_key, -- faction_key 
	"3k_dlc04_progression_cao_cao_xindu_02_mission", -- event_key
	success_key.."xindu_01", -- trigger event 
	function(context)
		return true
	end, --listener condition
	false, --fire_once
	success_key.."xindu_02", -- completion event 
	failure_key.."xindu_02", -- failure event
	false -- delay_start
);

--[[ Commented out until we can get it fixed.
-- Manipulate faction
cdir_mission_manager:start_mission_listener(
    local_faction_key,                          -- faction key
    "3k_dlc04_progression_cao_cao_xindu_03_mission",                     -- mission key
    "SCRIPTED",                      -- objective type
    {
		"script_key cao_cao_manipulated",
		"override_text mission_text_text_3k_dlc04_scripted_manipulate_factions"
    },                                           -- conditions (single string or table of strings)
    {
        "money 2000"
    },                                                  -- mission rewards (table of strings)
	success_key.."xindu_02",      -- trigger event 
	function() 
		return true;
	end,												-- Listener condition
	false,												-- Fire once
	success_key.."xindu_03",     					-- completion event
	failure_key.."xindu_03",							-- failure event
	"3k_main_victory_objective_issuer"							--mission_issuer
);
]]--
-- #endregion

-- #endregion


-- #region Progression
--[[
***************************************************
***************************************************
** PROGRESSION
***************************************************
***************************************************
]]--

core:add_listener(
    "start_progression_missions",
    "FactionTurnStart",
    function(context)
		return cdir_mission_manager:get_turn_number() == 2 and context:faction():name() == local_faction_key;
	end,
    function()
        core:trigger_event("ScriptEventCaoCaoDLC04ProgressionMission01Trigger")
    end,
    false
);

-- DLC04 reach rank Noble
cdir_mission_manager:start_mission_listener(
    local_faction_key,                          -- faction key
    "3k_dlc04_victory_objective_chain_cao_cao_1",                     -- mission key
    "ATTAIN_FACTION_PROGRESSION_LEVEL",                                  -- objective type
    {
        "rank_noble"
    },                                                  -- conditions (single string or table of strings)
    {
        "money 2000"
    },                                                  -- mission rewards (table of strings)
	"ScriptEventCaoCaoDLC04ProgressionMission01Trigger",      -- trigger event 
	nil,												-- Listener condition
	false,												-- Fire once
	"ScriptEventCaoCaoDLC04ProgressionMission01Complete",     -- completion event
	nil,														-- failure event
	"3k_main_victory_objective_issuer"							--mission_issuer
)

-- DLC04 reach rank Second Marquis
cdir_mission_manager:start_mission_listener(
    local_faction_key,                          -- faction key
    "3k_dlc04_victory_objective_chain_cao_cao_2",                     -- mission key
    "ATTAIN_FACTION_PROGRESSION_LEVEL",                                  -- objective type
    {
        "rank_second_marquis"
    },                                                  -- conditions (single string or table of strings)
    {
        "money 2000"
    },                                                  -- mission rewards (table of strings)
	"ScriptEventCaoCaoDLC04ProgressionMission01Complete",      -- trigger event 
	nil,												-- Listener condition
	false,												-- Fire once
	"ScriptEventCaoCaoProgressionMission01Trigger",     -- completion event
	nil,														-- failure event
	"3k_main_victory_objective_issuer"							--mission_issuer
)

-- cao cao progression mission 1
cdir_mission_manager:start_mission_listener(
    local_faction_key,                          -- faction key
    "3k_main_victory_objective_chain_1_cao_cao",                     -- mission key
    "ATTAIN_FACTION_PROGRESSION_LEVEL",                                  -- objective type
    {
        "rank_duke"
    },                                                  -- conditions (single string or table of strings)
    {
        "money 2000"
    },                                                  -- mission rewards (table of strings)
	"ScriptEventCaoCaoProgressionMission01Trigger",      -- trigger event 
	nil,												-- Listener condition
	false,												-- Fire once
	"ScriptEventCaoCaoProgressionMission01Complete",     -- completion event
	nil,														-- failure event
	"3k_main_victory_objective_issuer"							--mission_issuer
)

-- cao cao progression mission 02
cdir_mission_manager:start_mission_listener(
    local_faction_key,                          -- faction key
    "3k_main_victory_objective_chain_2_han_warlords",                    -- mission key
    "BECOME_WORLD_LEADER",                                  -- objective type
    nil,                                                    -- conditions (single string or table of strings)
    {
        "money 5000"
    },                                                  -- mission rewards (table of strings)
    "ScriptEventCaoCaoProgressionMission01Complete",      -- trigger event 
	nil,												-- Listener condition
	false,												-- Fire once
	"ScriptEventCaoCaoProgressionMission02Complete",     -- completion event
	nil,														-- failure event
	"3k_main_victory_objective_issuer"							--mission_issuer
)

-- cao cao progression mission 03
cdir_mission_manager:start_mission_listener(
    local_faction_key,                          -- faction key
    "3k_main_victory_objective_chain_3_han",                     -- mission key
    "DESTROY_ALL_WORLD_LEADERS",                                  -- objective type
    nil,                                                -- conditions (single string or table of strings)
    {
        "money 10000"
    },                                                  -- mission rewards (table of strings)
    "ScriptEventCaoCaoProgressionMission02Complete",      -- trigger event 
	nil,												-- Listener condition
	false,												-- Fire once
	"ScriptEventCaoCaoProgressionMission03Complete",     -- completion event
	nil,														-- failure event
	"3k_main_victory_objective_issuer"							--mission_issuer
)

--cao cao progression mission 04
cdir_mission_manager:start_mission_listener(
    local_faction_key,                          -- faction key
    "3k_main_victory_objective_chain_4",                     -- mission key
    "CONTROL_N_REGIONS_INCLUDING",                                  -- objective type
    {
        "total 95"
    }, 
    {
        "money 10000"
    },                                                  -- mission rewards (table of strings)
	"ScriptEventCaoCaoProgressionMission03Complete",      -- trigger event 
	nil,												-- Listener condition
	false,												-- Fire once
	"ScriptEventCaoCaoProgressionMissionsCompleted",     -- completion event
	nil,														-- failure event
	"3k_main_victory_objective_issuer"							--mission_issuer
)
-- #endregion
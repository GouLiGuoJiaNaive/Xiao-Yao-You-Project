--[[
***************************************************
***************************************************
** VARIABLES
***************************************************
***************************************************
]]--
local local_faction_key = "3k_main_faction_liu_biao";
local success_key = "dlc04_" .. local_faction_key .. "_success";
local failure_key = "dlc04_" .. local_faction_key .. "_failure";

output("Events script loaded for " .. local_faction_key);
setup_shared_faction_events_han_empire(local_faction_key, success_key, failure_key);

-- Spawn initial armies.
local function initial_set_up()
	local invasion = campaign_invasions:create_invasion("3k_dlc04_faction_rebels", "3k_main_henei_capital", 1, true, local_faction_key, true, 396, 361);
	invasion:set_force_retreated();
	invasion:start_invasion();
end;

cm:add_first_tick_callback_new(initial_set_up);


-- #region progression events
--[[
***************************************************
***************************************************
** Introduction
***************************************************
***************************************************
]]--

cdir_mission_manager:start_incident_db_listener(
	local_faction_key, -- faction_key 
	"3k_dlc04_introduction_liu_biao_incident", -- event_key 
	"FactionTurnStart", -- trigger event 
	function(context)
		return cdir_mission_manager:get_turn_number() == 1 and context:faction():name() == local_faction_key;
	end, --listener condition
	false, -- fire_once.
	success_key.."_Intro_Fired", -- completion event 
	nil -- failure event
);

cdir_mission_manager:start_mission_db_listener(
	local_faction_key, -- faction_key 
	"3k_dlc04_progression_liu_biao_intro_engage_first_force_mission", -- event_key 
	success_key.."_Intro_Fired", -- trigger event 
	function(context)
		return true;
	end, --listener condition
	false, -- fire_once.
	success_key.."_engage_first_force", -- completion event 
	failure_key.."_engage_first_force" -- failure event
);

-- Capture Jingzhou
cdir_mission_manager:start_mission_listener(
    local_faction_key,                          -- faction key
    "3k_dlc04_progression_liu_biao_intro_first_territory_mission",                     -- mission key
    "CONTROL_N_REGIONS_INCLUDING",                                  -- objective type
    {
        "total 1",
		"region 3k_main_jingzhou_resource_1",
    },    
    {
        "money 5000"
    },                                                  -- mission rewards (table of strings)
	success_key.."_engage_first_force", -- completion event 
	nil,												-- Listener condition
	false,												-- Fire once
	success_key.."_captured_first_city", -- completion event 
	failure_key.."_captured_first_city", -- failure event
	"3k_main_victory_objective_issuer"							--mission_issuer
);


--[[
***************************************************
***************************************************
** Build Buildings
***************************************************
***************************************************
]]--

cdir_mission_manager:start_mission_db_listener(
	local_faction_key, -- faction_key 
	"3k_dlc04_progression_liu_biao_city_of_scholars_01_first_building_mission", -- event_key 
	success_key.."_captured_first_city", -- trigger event 
	function(context)
		return true;
	end, --listener condition
	false, -- fire_once.
	success_key.."_building1", -- completion event 
	failure_key.."_building1" -- failure event
);

cdir_mission_manager:start_mission_db_listener(
	local_faction_key, -- faction_key 
	"3k_dlc04_progression_liu_biao_city_of_scholars_02_second_building_mission", -- event_key 
	success_key.."_building1", -- trigger event 
	function(context)
		return true;
	end, --listener condition
	false, -- fire_once.
	success_key.."_building2", -- completion event 
	failure_key.."_building2" -- failure event
);

cdir_mission_manager:start_mission_db_listener(
	local_faction_key, -- faction_key 
	"3k_dlc04_progression_liu_biao_city_of_scholars_03_third_building_mission", -- event_key 
	success_key.."_building2", -- trigger event 
	function(context)
		return true;
	end, --listener condition
	false, -- fire_once.
	success_key.."_building3", -- completion event 
	failure_key.."_building3" -- failure event
);

cdir_mission_manager:start_mission_db_listener(
	local_faction_key, -- faction_key 
	"3k_dlc04_progression_liu_biao_city_of_scholars_04_fourth_building_mission", -- event_key 
	success_key.."_building3", -- trigger event 
	function(context)
		return true;
	end, --listener condition
	false, -- fire_once.
	success_key.."_building4", -- completion event 
	failure_key.."_building4" -- failure event
);

cdir_mission_manager:start_incident_db_listener(
	local_faction_key, -- faction_key 
	"3k_dlc04_progression_liu_biao_city_of_scholars_05_city_scholars_incident", -- event_key 
	success_key.."_building4", -- trigger event 
	function(context)
		return true;
	end, --listener condition
	false, -- fire_once.
	success_key.."_Intro_Fired", -- completion event 
	nil -- failure event
);
-- #endregion

-- #region Rebels
--[[
***************************************************
***************************************************
** YT/Rebel Forces
***************************************************
***************************************************
]]--

-- Initialise the chain.
core:add_listener(
	local_faction_key, -- Unique handle
	"FactionTurnStart", -- Campaign Event to listen for
	function(context) -- Criteria
		return cdir_mission_manager:get_turn_number() == 2 and context:faction():name() == local_faction_key;
	end,
	function(context) -- What to do if listener fires.
		core:trigger_event(success_key .. "fight_rebels_start");
	end,
	false --Is persistent
);

cdir_mission_manager:start_mission_db_listener(
	local_faction_key, -- faction_key 
	"3k_dlc04_progression_liu_biao_fight_rebels_01_mission", -- event_key 
	success_key .. "fight_rebels_start", -- trigger event 
	function(context)
		-- Abusing the function here, but using the criteria test to actually fire the invasions.
		-- This one also targets the player so war gets declared.
		campaign_invasions:create_invasion("3k_dlc04_faction_rebels", "3k_main_jingzhou_resource_1", 1, false, local_faction_key, true);

		return true;
	end, --listener condition
	false, -- fire_once.
	success_key.."fight_rebels_01", -- completion event 
	failure_key.."fight_rebels_01" -- failure event
);

cdir_mission_manager:start_incident_db_listener(
	local_faction_key, -- faction_key 
	"3k_dlc04_progression_liu_biao_fight_rebels_02_incident", -- event_key 
	success_key.."fight_rebels_01", -- trigger event 
	function(context)
		return true;
	end, --listener condition
	false, -- fire_once.
	success_key.."fight_rebels_02", -- completion event 
	nil, -- failure event
	false -- delay_start
);

cdir_mission_manager:start_mission_db_listener(
	local_faction_key, -- faction_key 
	"3k_dlc04_progression_liu_biao_fight_rebels_03_mission", -- event_key 
	success_key.."fight_rebels_02", -- trigger event 
	function(context)
		-- Abusing the function here, but using the criteria test to actually fire the invasions.
		campaign_invasions:create_invasion("3k_dlc04_faction_rebels", "3k_main_jiangxia_capital", 1, false, local_faction_key);
		campaign_invasions:create_invasion("3k_dlc04_faction_rebels", "3k_main_xiangyang_resource_1", 2);
		campaign_invasions:create_invasion("3k_dlc04_faction_rebels", "3k_main_badong_resource_2", 1);		

		local query_faction = cm:query_faction("3k_dlc04_faction_rebels");
		local patrol_regions = {"3k_main_jingzhou_resource_1", "3k_main_jiangxia_capital", "3k_main_runan_resource_1"};
		local patrol_route = {};
		for i = 1, #patrol_regions do
			local found_spawn, pos_x, pos_y = query_faction:get_valid_spawn_location_in_region(patrol_regions[i], true);
			if found_spawn then
				table.insert( patrol_route, {x, y} );
			end;
		end;
		campaign_invasions:create_invasion_patrol("3k_dlc04_faction_rebels", "3k_main_xiangyang_resource_1", 1, patrol_route);

		return true;
	end, --listener condition
	false, -- fire_once.
	success_key.."fight_rebels_03", -- completion event 
	failure_key.."fight_rebels_03", -- failure event
	true -- delay_start
);

cdir_mission_manager:start_mission_db_listener(
	local_faction_key, -- faction_key 
	"3k_dlc04_progression_liu_biao_fight_rebels_04_aid_wang_rui_mission", -- event_key 
	success_key .. "fight_rebels_03", -- trigger event 
	function(context)
		-- Abusing the function here, but using the criteria test to actually fire the invasions.
		campaign_invasions:create_invasion("3k_dlc04_faction_rebels", "3k_main_badong_resource_1", 2, false, local_faction_key);
		
		campaign_invasions:create_invasion_attack_region("3k_dlc04_faction_rebels", "3k_main_badong_resource_2", 2, "3k_main_badong_resource_2", true);
		campaign_invasions:create_invasion_attack_region("3k_dlc04_faction_rebels", "3k_main_changsha_resource_1", 2, "3k_main_changsha_resource_1", true);
		campaign_invasions:create_invasion_attack_region("3k_dlc04_faction_rebels", "3k_main_changsha_resource_2", 2, "3k_main_changsha_resource_2", true);
		campaign_invasions:create_invasion_attack_region("3k_dlc04_faction_rebels", "3k_main_changsha_resource_3", 3, "3k_main_changsha_resource_3", true);

		return true;
	end, --listener condition
	false, -- fire_once.
	success_key.."fight_rebels_wang_rui", -- completion event 
	failure_key.."fight_rebels_wang_rui" -- failure event
);

-- #endregion

-- #region Unifying Jing
--[[
***************************************************
***************************************************
** Unifying Jing
***************************************************
***************************************************
]]--

core:add_listener(
	local_faction_key, -- Unique handle
	"FactionTurnStart", -- Campaign Event to listen for
	function(context) -- Criteria
		return cdir_mission_manager:get_turn_number() == 10 and context:faction():name() == local_faction_key;
	end,
	function(context) -- What to do if listener fires.
		cm:modify_faction(local_faction_key):create_character_from_template("general", "3k_general_earth", "3k_main_template_historical_lady_cai_yuxiang_hero_earth", true); 
		core:trigger_event(success_key .. "_claiming_jing_01_trigger");
	end,
	false --Is persistent
); 

cdir_mission_manager:start_dilemma_db_listener(
	local_faction_key, -- faction_key 
	"3k_dlc04_progression_liu_biao_unify_jing_01_lady_cai_joins_dilemma", -- event_key 
	success_key.."_claiming_jing_01_trigger", -- trigger event 
	function(context)
		return true;
	end, --listener condition
	false, -- fire_once.
	success_key.."_claiming_jing_01", -- completion event 
	success_key.."_claiming_jing_01" -- failure event
);

core:add_listener(
	local_faction_key, -- Unique handle
	"FactionTurnStart", -- Campaign Event to listen for
	function(context) -- Criteria
		return cdir_mission_manager:get_turn_number() == 15 and context:faction():name() == local_faction_key;
	end,
	function(context) -- What to do if listener fires.
		cm:modify_faction("3k_dlc04_faction_wang_rui"):create_character_from_template("general", "3k_general_wood", "3k_main_template_historical_huang_zu_hero_wood", true); 
		core:trigger_event(success_key .. "_claiming_jing_02_trigger");
	end,
	false --Is persistent
); 

cdir_mission_manager:start_incident_db_listener(
	local_faction_key, -- faction_key 
	"3k_dlc04_progression_liu_biao_unify_jing_02_huang_zu_joins_incident", -- event_key 
	success_key.."_claiming_jing_02_trigger", -- trigger event 
	function(context)
		return true;
	end, --listener condition
	false, -- fire_once.
	success_key.."_claiming_jing_02", -- completion event 
	success_key.."_claiming_jing_02" -- failure event
);

cdir_mission_manager:start_incident_db_listener(
	local_faction_key, -- faction_key 
	"3k_dlc04_progression_liu_biao_unify_jing_03_huang_zhong_joins_incident", -- event_key 
	"FactionTurnStart", -- trigger event 
	function(context)
		return cdir_mission_manager:get_turn_number() == 20 and context:faction():name() == local_faction_key;
	end, --listener condition
	false, -- fire_once.
	success_key.."_claiming_jing_03", -- completion event 
	success_key.."_claiming_jing_03" -- failure event
);


core:add_listener(
	local_faction_key, -- Unique handle
	"FactionTurnStart", -- Campaign Event to listen for
	function(context) -- Criteria
		return cdir_mission_manager:get_turn_number() == 25 and context:faction():name() == local_faction_key;
	end,
	function() -- Kill wang rui prior to offering Liu Biao his lands.
	local q_char = cm:query_model():character_for_template("3k_dlc04_template_historical_wang_rui_fire");
	cm:modify_character(q_char):kill_character(false);
		core:trigger_event(success_key .. "_claiming_jing_04_trigger");
	end,
	false --Is persistent
); 


cdir_mission_manager:start_dilemma_db_listener(
	local_faction_key, -- faction_key 
	"3k_dlc04_progression_liu_biao_unify_jing_04_claiming_jing_dilemma", -- event_key 
	success_key.."_claiming_jing_04_trigger", -- trigger event 
	function(context)
		return true;
	end, --listener condition
	false, -- fire_once.
	success_key.."_claiming_jing_04", -- completion event 
	success_key.."_claiming_jing_04", -- failure event
	true -- delay_start
);
-- #endregion

-- #region progression
--[[
***************************************************
***************************************************
** PROGRESSION
***************************************************
***************************************************
]]--

-- start the progression missions from the intro incident.

-- DLC04
-- progression mission 1
cdir_mission_manager:start_mission_listener(
    local_faction_key,                          		-- faction key
    "3k_dlc04_victory_objective_chain_liu_biao_1",        -- mission key
    "ATTAIN_FACTION_PROGRESSION_LEVEL",                 -- objective type
    {
		"rank_noble"
    },                                                  -- conditions (single string or table of strings)
    {
        "money 2000"
    },                                                  -- mission rewards (table of strings)
	success_key.."_captured_first_city",      -- trigger event 
	nil,												-- Listener condition
	false,												-- Fire once
	"ScriptEventLiuBiaoProgressionDLC04Mission01Complete",     -- completion event
	nil,														-- failure event
	"3k_main_victory_objective_issuer"							--mission_issuer
)

-- progression mission 2
cdir_mission_manager:start_mission_listener(
    local_faction_key,                          		-- faction key
    "3k_dlc04_victory_objective_chain_liu_biao_2",        -- mission key
    "ATTAIN_FACTION_PROGRESSION_LEVEL",                 -- objective type
    {
        "rank_second_marquis"
    },                                                  -- conditions (single string or table of strings)
    {
        "money 2000"
    },                                                  -- mission rewards (table of strings)
	"ScriptEventLiuBiaoProgressionDLC04Mission01Complete",      -- trigger event 
	nil,												-- Listener condition
	false,												-- Fire once
	"ScriptEventLiuBiaoProgressionMission01Trigger",     -- completion event
	nil,														-- failure event
	"3k_main_victory_objective_issuer"							--mission_issuer
)


-- Main Game
-- progression mission 01
cdir_mission_manager:start_mission_listener(
    local_faction_key,                          		-- faction key
    "3k_main_victory_objective_chain_1_liu_biao",        -- mission key
    "ATTAIN_FACTION_PROGRESSION_LEVEL",                                  -- objective type
    {
        "rank_duke"
    },                                                  -- conditions (single string or table of strings)
    {
        "money 2000"
    },                                                 -- mission rewards (table of strings)
	"ScriptEventLiuBiaoProgressionMission01Trigger",      -- trigger event 
	nil,												-- Listener condition
	false,												-- Fire once
	"ScriptEventLiuBiaoProgressionMission01Complete",     -- completion event
	nil,														-- failure event
	"3k_main_victory_objective_issuer"							--mission_issuer
);

-- progression mission 02
cdir_mission_manager:start_mission_listener(
    local_faction_key,                          		-- faction key
    "3k_main_victory_objective_chain_2_han_governors",        -- mission key
    "BECOME_WORLD_LEADER",                                  -- objective type
    nil,                                                    -- conditions (single string or table of strings)
    {
        "money 5000"
    },                                                 -- mission rewards (table of strings)
	"ScriptEventLiuBiaoProgressionMission01Complete",      -- trigger event 
	nil,												-- Listener condition
	false,												-- Fire once
	"ScriptEventLiuBiaoProgressionMission02Complete",     -- completion event
	nil,														-- failure event
	"3k_main_victory_objective_issuer"							--mission_issuer
);

-- liu biao progression mission 03
cdir_mission_manager:start_mission_listener(
    local_faction_key,                          		-- faction key
    "3k_main_victory_objective_chain_3_han",        -- mission key
    "DESTROY_ALL_WORLD_LEADERS",                                  -- objective type
    nil,                                                -- conditions (single string or table of strings)
    {
        "money 10000"
    },                                                -- mission rewards (table of strings)
	"ScriptEventLiuBiaoProgressionMission02Complete",      -- trigger event 
	nil,												-- Listener condition
	false,												-- Fire once
	"ScriptEventLiuBiaoProgressionMission03Complete",     -- completion event
	nil,														-- failure event
	"3k_main_victory_objective_issuer"							--mission_issuer
);

-- liu biao progression mission 04
cdir_mission_manager:start_mission_listener(
    local_faction_key,                          		-- faction key
    "3k_main_victory_objective_chain_4",        -- mission key
    "CONTROL_N_REGIONS_INCLUDING",                                  -- objective type
    {
        "total 95"
    }, 
    {
        "money 15000"
    },                                               -- mission rewards (table of strings)
	"ScriptEventLiuBiaoProgressionMission03Complete",      -- trigger event 
	nil,												-- Listener condition
	false,												-- Fire once
	"",     -- completion event
	nil,														-- failure event
	"3k_main_victory_objective_issuer"							--mission_issuer
);
-- #endregion
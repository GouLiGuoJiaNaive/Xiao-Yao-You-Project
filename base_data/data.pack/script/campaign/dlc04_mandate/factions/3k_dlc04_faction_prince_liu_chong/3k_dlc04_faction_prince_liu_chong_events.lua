--[[
***************************************************
***************************************************
** VARIABLES
***************************************************
***************************************************
]]--
local local_faction_key = "3k_dlc04_faction_prince_liu_chong";
local listener_key = "dlc04_" .. local_faction_key;
local success_key = "dlc04_" .. local_faction_key .. "_success";
local failure_key = "dlc04_" .. local_faction_key .. "_failure";

output("Events script loaded for " .. local_faction_key);
setup_shared_faction_events_han_empire(local_faction_key, success_key, failure_key);

-- Spawn initial armies.
local function initial_set_up()
	local invasion = campaign_invasions:create_invasion("3k_dlc04_faction_rebels", "3k_main_henei_capital", 1, true, local_faction_key, true, 471, 449);
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
		cm:modify_faction(local_faction_key):ceo_management():remove_ceos("3k_dlc04_ancillary_weapon_crossbow_prince_liu_chong_unique");
		cm:modify_faction(local_faction_key):ceo_management():remove_ceos("3k_dlc04_ancillary_accessory_nushe_bifa_unique");

		core:trigger_event(success_key .. "_fire_intro");
	end,
	false --Is persistent
);

-- Intro Event.
cdir_mission_manager:start_incident_db_listener(
	local_faction_key, -- faction_key 
	"3k_dlc04_introduction_liu_chong_incident", -- event_key 
	success_key .. "_fire_intro", -- trigger event 
	function(context)
		return true;
	end, --listener condition
	false, -- fire_once.
	success_key.."_Intro_Fired", -- completion event 
	nil, -- failure event
	false -- delay start
);

cdir_mission_manager:start_mission_db_listener(
	local_faction_key, -- faction_key 
	"3k_dlc04_progression_liu_chong_intro_engage_first_force_mission", -- event_key 
	success_key.."_Intro_Fired", -- trigger event 
	function(context)
		return true;
	end, --listener condition
	false, -- fire_once.
	success_key.."engaged_force", -- completion event 
	success_key.."engaged_force", -- failure event
	false -- delay start
);

cdir_mission_manager:start_mission_db_listener(
	local_faction_key, -- faction_key 
	"3k_dlc04_progression_liu_chong_intro_equip_trophy_mission", -- event_key 
	success_key.."engaged_force", -- trigger event 
	function(context)
		return true;
	end, --listener condition
	false, -- fire_once.
	success_key.."equipped_trophy", -- completion event 
	success_key.."equipped_trophy", -- failure event
	false -- delay start
);

cdir_mission_manager:start_mission_db_listener(
	local_faction_key, -- faction_key 
	"3k_dlc04_progression_liu_chong_prepares_for_war", -- event_key 
	success_key.."equipped_trophy", -- trigger event 
	function(context)
		return true;
	end, --listener condition
	false, -- fire_once.
	success_key.."_prepared1", -- completion event 
	success_key.."_prepared1", -- failure event
	false -- delay start
);

-- #endregion


-- #region Luo Jun
--[[
***************************************************
***************************************************
** Luo Jun
***************************************************
***************************************************
]]--


cdir_mission_manager:start_mission_db_listener(
	local_faction_key, -- faction_key 
	"3k_dlc04_progression_liu_chong_luo_jun_give_office_mission", -- event_key 
	"ScriptEventLiuChongProgressionMission01Trigger", -- trigger event 
	function(context)
		return true;
	end, --listener condition
	false, -- fire_once.
	success_key.."luo_jun_promoted", -- completion event 
	success_key.."luo_jun_promoted", -- failure event
	false -- delay start
);

cdir_mission_manager:start_incident_db_listener(
	local_faction_key, -- faction_key 
	"3k_dlc04_progression_liu_chong_luo_jun_finest_crossbow_incident", -- event_key 
	success_key .. "luo_jun_promoted", -- trigger event 
	function(context)
		return true;
	end, --listener condition
	false, -- fire_once.
	success_key.."luo_jun_crossbow", -- completion event
	success_key.."luo_jun_crossbow", -- failure event
	false -- delay start
);

-- #endregion


-- #region Building the Legend
--[[
***************************************************
***************************************************
** Building the Legend
***************************************************
***************************************************
]]--

core:add_listener(
	listener_key .. "building_legend", -- Unique handle
	"FactionTurnStart", -- Campaign Event to listen for
	function(context) -- Criteria
		return cdir_mission_manager:get_turn_number() == 12 and context:faction():name() == local_faction_key;
	end,
	function(context) -- What to do if listener fires.
		core:trigger_event(success_key .. "building_legend");
	end,
	false --Is persistent
);

cdir_mission_manager:start_dilemma_db_listener(
	local_faction_key, --faction_key
	"3k_dlc04_progression_liu_chong_building_the_legend_01_dilemma", --event_key
	success_key .. "building_legend", --trigger_event
	function(context) 
		return true 
	end, --listener_condition
	false, --fire_once
	nil, --completion_event
	success_key .. "building_legend_a", --failure_event
	false, -- delay_start
	nil, -- on trigger callback
	success_key .. "building_legend_a", -- choice one event (force of arms)
	success_key .. "building_legend_b" -- choice two event (great works)
);

-- Path a - Force of Arms
-- 3k_dlc04_progression_liu_chong_building_the_legend_02a_mission

cdir_mission_manager:start_mission_db_listener(
	local_faction_key, -- faction_key 
	"3k_dlc04_progression_liu_chong_building_the_legend_02a_mission", -- event_key 
	success_key.."building_legend_a", -- trigger event 
	function(context)
		return true;
	end, --listener condition
	false, -- fire_once.
	success_key.."building_legend_02a", -- completion event 
	success_key.."building_legend_02a", -- failure event
	false -- delay start
);
-- 3k_dlc04_progression_liu_chong_building_the_legend_03a_mission

cdir_mission_manager:start_mission_db_listener(
	local_faction_key, -- faction_key 
	"3k_dlc04_progression_liu_chong_building_the_legend_03a_mission", -- event_key 
	success_key.."building_legend_02a", -- trigger event 
	function(context)
		return true;
	end, --listener condition
	false, -- fire_once.
	success_key.."building_legend_03a", -- completion event 
	success_key.."building_legend_03a", -- failure event
	false -- delay start
);
-- 3k_dlc04_progression_liu_chong_building_the_legend_04a_mission

cdir_mission_manager:start_mission_db_listener(
	local_faction_key, -- faction_key 
	"3k_dlc04_progression_liu_chong_building_the_legend_04a_mission", -- event_key 
	success_key.."building_legend_03a", -- trigger event 
	function(context)
		return true;
	end, --listener condition
	false, -- fire_once.
	success_key.."building_legend_04a", -- completion event 
	success_key.."building_legend_04a", -- failure event
	false -- delay start
);
-- 3k_dlc04_progression_liu_chong_building_the_legend_05a_incident

cdir_mission_manager:start_incident_db_listener(
	local_faction_key, -- faction_key 
	"3k_dlc04_progression_liu_chong_building_the_legend_05a_incident", -- event_key 
	success_key .. "building_legend_05a", -- trigger event 
	function(context)
		return true;
	end, --listener condition
	false, -- fire_once.
	nil, -- completion event 
	nil, -- failure event
	false -- delay start
);

-- Path b - Great works
-- 3k_dlc04_progression_liu_chong_building_the_legend_02b_mission

cdir_mission_manager:start_mission_db_listener(
	local_faction_key, -- faction_key 
	"3k_dlc04_progression_liu_chong_building_the_legend_02b_mission", -- event_key 
	success_key.."building_legend_b", -- trigger event 
	function(context)
		return true;
	end, --listener condition
	false, -- fire_once.
	success_key.."building_legend_02b", -- completion event 
	success_key.."building_legend_02b", -- failure event
	false -- delay start
);
-- 3k_dlc04_progression_liu_chong_building_the_legend_03b_mission

cdir_mission_manager:start_mission_db_listener(
	local_faction_key, -- faction_key 
	"3k_dlc04_progression_liu_chong_building_the_legend_03b_mission", -- event_key 
	success_key.."building_legend_02b", -- trigger event 
	function(context)
		return true;
	end, --listener condition
	false, -- fire_once.
	success_key.."building_legend_03b", -- completion event 
	success_key.."building_legend_03b", -- failure event
	false -- delay start
);
-- 3k_dlc04_progression_liu_chong_building_the_legend_04b_mission

cdir_mission_manager:start_mission_db_listener(
	local_faction_key, -- faction_key 
	"3k_dlc04_progression_liu_chong_building_the_legend_04b_mission", -- event_key 
	success_key.."building_legend_03b", -- trigger event 
	function(context)
		return true;
	end, --listener condition
	false, -- fire_once.
	success_key.."building_legend_04b", -- completion event 
	success_key.."building_legend_04b", -- failure event
	false -- delay start
);
-- 3k_dlc04_progression_liu_chong_building_the_legend_05b_incident

cdir_mission_manager:start_incident_db_listener(
	local_faction_key, -- faction_key 
	"3k_dlc04_progression_liu_chong_building_the_legend_05b_incident", -- event_key 
	success_key .. "building_legend_04b", -- trigger event 
	function(context)
		return true;
	end, --listener condition
	false, -- fire_once.
	nil, -- completion event 
	nil, -- failure event
	false -- delay start
);

-- #endregion


-- #region Raising forces
--[[
***************************************************
***************************************************
** Raising forces
***************************************************
***************************************************
]]--

core:add_listener(
	listener_key .. "raising_forces", -- Unique handle
	"FactionTurnStart", -- Campaign Event to listen for
	function(context) -- Criteria
		return cdir_mission_manager:get_turn_number() == 5 and context:faction():name() == local_faction_key;
	end,
	function(context) -- What to do if listener fires.
		core:trigger_event(success_key .. "raising_forces_start");
	end,
	false --Is persistent
);

cdir_mission_manager:start_mission_db_listener(
	local_faction_key, -- faction_key 
	"3k_dlc04_progression_liu_chong_raising_forces_recruit_archers_mission", -- event_key 
	success_key.."raising_forces_start", -- trigger event 
	function(context)
		return true;
	end, --listener condition
	false, -- fire_once.
	success_key.."raising_forces_02", -- completion event 
	success_key.."raising_forces_02", -- failure event
	true -- delay start
);

core:add_listener(
	listener_key .. "spawn_rebels_01",
	success_key.."raising_forces_02",
	true,
	function()
		campaign_invasions:create_invasion("3k_dlc04_faction_rebels", "3k_main_chenjun_resource_2", 1, false, local_faction_key, true);
		campaign_invasions:create_invasion("3k_dlc04_faction_rebels", "3k_main_chenjun_capital", 1, false, local_faction_key, true);
		campaign_invasions:create_invasion_attack_region("3k_dlc04_faction_rebels", "3k_main_runan_resource_1", 2, "3k_main_chenjun_capital", true, 442, 421);
		core:trigger_event(success_key .. "raising_forces_03");
	end,
	false
);

cdir_mission_manager:start_mission_db_listener(
	local_faction_key, -- faction_key 
	"3k_dlc04_progression_liu_chong_raising_forces_defence_of_chen_mission", -- event_key 
	success_key.."raising_forces_03", -- trigger event 
	function(context)
		return true;
	end, --listener condition
	false, -- fire_once.
	success_key.."raising_forces_04", -- completion event 
	success_key.."raising_forces_04", -- failure event
	false -- delay start
);

cdir_mission_manager:start_incident_db_listener(
	local_faction_key, -- faction_key 
	"3k_dlc04_progression_liu_chong_raising_forces_nushe_bifa_incident", -- event_key 
	"ScriptEventLiuChongProgressionMission01Complete", -- trigger event 
	function(context)
		return true;
	end, --listener condition
	false, -- fire_once.
	nil, -- completion event 
	nil, -- failure event
	false -- delay start
);

-- #endregion


-- #region Progresison
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
		return cdir_mission_manager:get_turn_number() == 2 and context:faction():name() == local_faction_key;
	end,
    function(context)
        core:trigger_event("ScriptEventLiuChongProgressionDLC04Mission01Trigger");
    end,
    false
);

-- liu chong progression mission 1
cdir_mission_manager:start_mission_listener(
    local_faction_key,                          		-- faction key
    "3k_dlc04_victory_objective_chain_liu_chong_2",        -- mission key
    "ATTAIN_FACTION_PROGRESSION_LEVEL",                 -- objective type
    {
        "rank_second_marquis"
    },                                                  -- conditions (single string or table of strings)
    {
        "money 2000"
    },                                                  -- mission rewards (table of strings)
	"ScriptEventLiuChongProgressionDLC04Mission01Trigger",      -- trigger event 
	nil,												-- Listener condition
	false,												-- Fire once
	"ScriptEventLiuChongProgressionMission01Trigger",     -- completion event
	nil,														-- failure event
	"3k_main_victory_objective_issuer"							--mission_issuer
)

-- MAIN GAME
-- liu chong progression mission 3
cdir_mission_manager:start_mission_listener(
    local_faction_key,                          		-- faction key
    "3k_dlc04_victory_objective_chain_liu_chong_3",        -- mission key
    "ATTAIN_FACTION_PROGRESSION_LEVEL",                 -- objective type
    {
        "rank_marquis"
    },                                                  -- conditions (single string or table of strings)
    {
        "money 2000"
    },                                                  -- mission rewards (table of strings)
	"ScriptEventLiuChongProgressionMission01Trigger",      -- trigger event 
	nil,												-- Listener condition
	false,												-- Fire once
	"ScriptEventLiuChongProgressionMission01Complete",     -- completion event
	nil,														-- failure event
	"3k_main_victory_objective_issuer"							--mission_issuer
)

-- liu chong progression mission 4
cdir_mission_manager:start_mission_listener(
    local_faction_key,                          -- faction key
    "3k_main_victory_objective_chain_2_han_warlords",                    -- mission key
    "BECOME_WORLD_LEADER",                                  -- objective type
    nil,                                                    -- conditions (single string or table of strings)
    {
        "money 5000"
    },                                                  -- mission rewards (table of strings)
	"ScriptEventLiuChongProgressionMission01Complete",      -- trigger event 
	nil,												-- Listener condition
	false,												-- Fire once
    "ScriptEventLiuChongProgressionMission02Complete",     -- completion event
	nil,														-- failure event
	"3k_main_victory_objective_issuer"							--mission_issuer
)

-- liu chong progression mission 5
cdir_mission_manager:start_mission_listener(
    local_faction_key,                          -- faction key
    "3k_main_victory_objective_chain_3_han",                     -- mission key
    "DESTROY_ALL_WORLD_LEADERS",                                  -- objective type
    nil,                                                -- conditions (single string or table of strings)
    {
        "money 10000"
    },                                                  -- mission rewards (table of strings)
	"ScriptEventLiuChongProgressionMission02Complete",      -- trigger event 
	nil,												-- Listener condition
	false,												-- Fire once
    "ScriptEventLiuChongProgressionMission03Complete",     -- completion event
	nil,														-- failure event
	"3k_main_victory_objective_issuer"							--mission_issuer
)

-- liu chong progression mission 6
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
	"ScriptEventLiuChongProgressionMission03Complete",      -- trigger event 
	nil,												-- Listener condition
	false,												-- Fire once
    "ScriptEventLiuChongProgressionMissionsCompleted",     -- completion event
	nil,														-- failure event
	"3k_main_victory_objective_issuer"							--mission_issuer
)
-- #endregion
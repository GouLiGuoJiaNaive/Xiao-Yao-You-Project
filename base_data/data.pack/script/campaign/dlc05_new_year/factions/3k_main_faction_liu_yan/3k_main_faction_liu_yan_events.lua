--[[
***************************************************
***************************************************
** VARIABLES
***************************************************
***************************************************
]]--
local local_faction_key = "3k_main_faction_liu_yan";
local listener_key = "dlc07_" .. local_faction_key .. "_";
local success_key = "dlc07_" .. local_faction_key .. "_success_";
local failure_key = "dlc07_" .. local_faction_key .. "_failure_";

output("Events script loaded for " .. local_faction_key);

local function initial_set_up()

end;

cm:add_first_tick_callback_new(initial_set_up);
-- Intro Event.
cdir_mission_manager:start_incident_db_listener(
	local_faction_key, -- faction_key 
	"3k_dlc07_introduction_liu_yan_incident_194", -- event_key 
	"FactionTurnStart", -- trigger event 
	function(context)
		return cdir_mission_manager:get_turn_number() == 1 and context:faction():name() == local_faction_key;
	end, --listener condition
	false, -- fire_once.
	success_key.."intro_fired", -- completion event 
	nil -- failure event
);


-- Onboarding Missions


cdir_mission_manager:start_mission_db_listener(
	local_faction_key, -- faction_key 
	"3k_dlc07_progression_liu_yan_194_construct_building", -- event_key 
	success_key.."intro_fired", -- trigger event 
	function(context)
		return true;
	end, --listener condition
	false, -- fire_once.
	success_key.."building_constructed", -- completion event 
	failure_key.."building_constructed", -- failure event
	false -- delay start
);


start_tutorial_mission_listener(
    local_faction_key,                          -- faction key
    "3k_dlc07_progression_liu_yan_194_raise_army",                     -- mission key
    "OWN_N_UNITS",                                  -- objective type
    {
        4
    },                                                  -- conditions (single string or table of strings)
    {
        "effect_bundle{bundle_key 3k_main_introduction_mission_payload_recruit_units;turns 3;}"
    },                                                  -- mission rewards (table of strings)
    success_key.."building_constructed",      -- trigger event 
    success_key.."army_raised"     -- completion event
)


cdir_mission_manager:start_mission_db_listener(
	local_faction_key, -- faction_key 
	"3k_dlc07_progression_liu_yan_194_attack_settlement", -- event_key 
	success_key.."army_raised", -- trigger event 
	function(context)
		return true;
	end, --listener condition
	false, -- fire_once.
	success_key.."settlement_attacked", -- completion event 
	failure_key.."settlement_attacked", -- failure event
	false -- delay start
);

cdir_mission_manager:start_mission_listener(
	local_faction_key,                          -- faction key
	"3k_dlc07_progression_liu_yan_194_destroy_faction",                     -- mission key
	"DESTROY_FACTION",                                  -- objective type
	{
		"faction 3k_main_faction_ba"
	},   
	{
		"money 5000"
	},                                                    -- mission rewards (table of strings)
	success_key.."settlement_attacked",      -- trigger event 
	nil,												-- Listener condition
	false,												-- Fire once
	success_key.."trigger_progression",		-- completion event
	success_key.."trigger_progression",		-- failure event
	"3k_main_victory_objective_issuer"							--mission_issuer
);
---------------------------------------------------------------------------------------------------
---------------------------------PROGRESSION-------------------------------------------------------
--------------------------------------------------------------------------------------------------

-- Liu Yan progression mission 01
cdir_mission_manager:start_mission_listener(
    local_faction_key,                          -- faction key
    "3k_dlc07_victory_objective_chain_1_liu_yan",                     -- mission key
    "ATTAIN_FACTION_PROGRESSION_LEVEL",                                  -- objective type
    {
        "rank_duke"
    },                                                  -- conditions (single string or table of strings)
    {
        "money 2000"
    },                                                  -- mission rewards (table of strings)
	success_key.."trigger_progression",      -- trigger event 
	nil,												-- Listener condition
	false,												-- Fire once
	"ScriptEventLiuYanProgressionMission02Trigger",     -- completion event
	nil,														-- failure event
	"3k_main_victory_objective_issuer"							--mission_issuer
)

-- Liu Yan progression mission 02
cdir_mission_manager:start_mission_listener(
    local_faction_key,                          -- faction key
    "3k_main_victory_objective_chain_2_han_warlords",                    -- mission key
    "BECOME_WORLD_LEADER",                                  -- objective type
    nil,                                                    -- conditions (single string or table of strings)
    {
        "money 5000"
    },                                                  -- mission rewards (table of strings)
    "ScriptEventLiuYanProgressionMission02Trigger",      -- trigger event 
	nil,												-- Listener condition
	false,												-- Fire once
	"ScriptEventLiuYanProgressionMission03Trigger",     -- completion event
	nil,														-- failure event
	"3k_main_victory_objective_issuer"							--mission_issuer
)

-- Liu Yan progression mission 03
cdir_mission_manager:start_mission_listener(
    local_faction_key,                          -- faction key
    "3k_main_victory_objective_chain_3_han",                     -- mission key
    "DESTROY_ALL_WORLD_LEADERS",                                  -- objective type
    nil,                                                -- conditions (single string or table of strings)
    {
        "money 10000"
    },                                                  -- mission rewards (table of strings)
    "ScriptEventLiuYanProgressionMission03Trigger",      -- trigger event 
	nil,												-- Listener condition
	false,												-- Fire once
	"ScriptEventLiuYanProgressionMission04Trigger",     -- completion event
	nil,														-- failure event
	"3k_main_victory_objective_issuer"							--mission_issuer
)

-- Liu Yan progression mission 04
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
	"ScriptEventLiuYanProgressionMission04Trigger",      -- trigger event 
	nil,												-- Listener condition
	false,												-- Fire once
	"ScriptEventLiuYanProgressionMission04Complete",     -- completion event
	nil,														-- failure event
	"3k_main_victory_objective_issuer"							--mission_issuer
)
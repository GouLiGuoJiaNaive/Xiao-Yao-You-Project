--[[
***************************************************
***************************************************
** VARIABLES
***************************************************
***************************************************
]]--

local local_faction_key = "3k_main_faction_shi_xie";
local success_key = "dlc06_" .. local_faction_key .. "_success_";
local failure_key = "dlc06_" .. local_faction_key .. "_failure_";

output("Events script loaded for " .. local_faction_key);

-- Intro Event.
cdir_mission_manager:start_incident_db_listener(
	local_faction_key, -- faction_key 
	"3k_dlc06_introduction_shi_xie_194_incident", -- event_key 
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
	"3k_dlc06_objective_shi_xie_194_01", -- event_key 
	success_key.."governor_assigned", -- trigger event 
	function(context)
		return true;
	end, --listener condition
	false, -- fire_once.
	success_key.."chancellor_assigned", -- completion event 
	failure_key.."chancellor_assigned", -- failure event
	false -- delay start
);

cdir_mission_manager:start_mission_db_listener(
	local_faction_key, -- faction_key 
	"3k_dlc06_objective_shi_xie_194_02", -- event_key 
	success_key.."intro_fired", -- trigger event 
	function(context)
		return true;
	end, --listener condition
	false, -- fire_once.
	success_key.."governor_assigned", -- completion event 
	failure_key.."governor_assigned", -- failure event
	false -- delay start
);

cdir_mission_manager:start_mission_db_listener(
	local_faction_key, -- faction_key 
	"3k_dlc06_objective_shi_xie_194_03", -- event_key 
	success_key.."chancellor_assigned", -- trigger event 
	function(context)
		return true;
	end, --listener condition
	false, -- fire_once.
	success_key.."independence_granted", -- completion event 
	failure_key.."independence_granted", -- failure event
	false -- delay start
);

cdir_mission_manager:start_mission_db_listener(
	local_faction_key, -- faction_key 
	"3k_dlc06_objective_shi_xie_194_04", -- event_key 
	success_key.."independence_granted", -- trigger event 
	function(context)
		return true;
	end, --listener condition
	false, -- fire_once.
	success_key.."chest_given", -- completion event 
	failure_key.."chest_given", -- failure event
	false -- delay start
);


start_historical_mission_listener(
    "3k_main_faction_shi_xie",                          -- faction key
    "3k_dlc06_objective_shi_xie_194_05",                     -- mission key
    "OWN_N_REGIONS_INCLUDING",                                  -- objective type
    {
        "total 4",
		"region 3k_main_gaoliang_resource_1",
		"region 3k_main_gaoliang_capital"
    },                                                                     -- conditions (single string or table of strings)
    {
        "money 2000"
    },                                                  -- mission rewards (table of strings)
    success_key.."chest_given",      -- trigger event 
    success_key.."gaoliang_destroyed",     -- completion event
    nil,                                                -- precondition (nil, or a function that returns a boolean)
	failure_key.."gaoliang_destroyed"       -- failure event
)


---------------------------------------------------------------------------------------------------
---------------------------------PROGRESSION-------------------------------------------------------
--------------------------------------------------------------------------------------------------

-- ShiXie progression mission 01
cdir_mission_manager:start_mission_listener(
    local_faction_key,                          -- faction key
    "3k_dlc06_victory_objective_chain_shi_xie_190_1",                     -- mission key
    "ATTAIN_FACTION_PROGRESSION_LEVEL",                                  -- objective type
    {
		"rank_duke"
    },                                                  -- conditions (single string or table of strings)
    {
        "money 2000"
    },                                                  -- mission rewards (table of strings)
	success_key.."gaoliang_destroyed",      -- trigger event 
	nil,												-- Listener condition
	false,												-- Fire once
	"ScriptEventShiXieProgressionMission02Trigger",     -- completion event
	nil,														-- failure event
	"3k_main_victory_objective_issuer"							--mission_issuer
)

-- ShiXie progression mission 02
cdir_mission_manager:start_mission_listener(
    local_faction_key,                          -- faction key
    "3k_main_victory_objective_chain_2_han_warlords",                    -- mission key
    "BECOME_WORLD_LEADER",                                  -- objective type
    nil,                                                    -- conditions (single string or table of strings)
    {
        "money 5000"
    },                                                  -- mission rewards (table of strings)
    "ScriptEventShiXieProgressionMission02Trigger",      -- trigger event 
	nil,												-- Listener condition
	false,												-- Fire once
	"ScriptEventShiXieProgressionMission03Trigger",     -- completion event
	nil,														-- failure event
	"3k_main_victory_objective_issuer"							--mission_issuer
)

-- ShiXie progression mission 03
cdir_mission_manager:start_mission_listener(
    local_faction_key,                          -- faction key
    "3k_main_victory_objective_chain_3_han",                     -- mission key
    "DESTROY_ALL_WORLD_LEADERS",                                  -- objective type
    nil,                                                -- conditions (single string or table of strings)
    {
        "money 10000"
    },                                                  -- mission rewards (table of strings)
    "ScriptEventShiXieProgressionMission03Trigger",      -- trigger event 
	nil,												-- Listener condition
	false,												-- Fire once
	"ScriptEventShiXieProgressionMission04Trigger",     -- completion event
	nil,														-- failure event
	"3k_main_victory_objective_issuer"							--mission_issuer
)

-- ShiXie progression mission 04
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
	"ScriptEventShiXieProgressionMission04Trigger",      -- trigger event 
	nil,												-- Listener condition
	false,												-- Fire once
	"ScriptEventShiXieProgressionMission04Complete",     -- completion event
	nil,														-- failure event
	"3k_main_victory_objective_issuer"							--mission_issuer
)
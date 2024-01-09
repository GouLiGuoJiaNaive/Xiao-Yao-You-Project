-- Generic mission setup for 'lite' factions. Just fires events to become emperor and win the game.
local faction_key = "3k_dlc04_faction_prince_liu_chong";
local start_event = faction_key .. "_dlc07_progression_start";
local duke_event = faction_key .. "_dlc07_progression_duke";
local became_world_leader_event = faction_key .. "_dlc07_progression_became_emperor";

local destroy_world_leader_event = faction_key .. "_dlc07_progression_destroyed_all_emperors";

core:add_listener(
	"generic_faction_progression_trigger", -- Unique handle
	"FactionTurnStart", -- Campaign Event to listen for
	function(context) -- Criteria
		return cdir_mission_manager:get_turn_number() == 2 and context:faction():name() == faction_key;
	end,
	function(context) -- What to do if listener fires.
		core:trigger_event(start_event)
	end,
	false --Is persistent
);


cdir_mission_manager:start_mission_listener(
    faction_key,                          		-- faction key
    "3k_dlc04_victory_objective_chain_liu_chong_3",        -- mission key
    "ATTAIN_FACTION_PROGRESSION_LEVEL",                 -- objective type
    {
        "rank_duke"
    },                                                  -- conditions (single string or table of strings)
    {
        "money 2000"
    },                                                  -- mission rewards (table of strings)
	start_event,      -- trigger event 
	nil,												-- Listener condition
	false,												-- Fire once
	duke_event,     -- completion event
	nil,														-- failure event
	"3k_main_victory_objective_issuer"							--mission_issuer
)

cdir_mission_manager:start_mission_listener(
	faction_key,                          -- faction key
	"3k_main_victory_objective_chain_2_han_warlords",                     -- mission key
	"BECOME_WORLD_LEADER",                                  -- objective type
	nil, 
	{
		"money 5000"
	},                                                  -- mission rewards (table of strings)
	duke_event,      -- trigger event 
	nil,												-- Listener condition
	false,												-- Fire once
	became_world_leader_event,     -- completion event
	nil,														-- failure event
	"3k_main_victory_objective_issuer"							--mission_issuer
);

cdir_mission_manager:start_mission_listener(
	faction_key,                          -- faction key
	"3k_main_victory_objective_chain_3_han",                     -- mission key
	"DESTROY_ALL_WORLD_LEADERS",                                  -- objective type
	nil, 
	{
		"money 10000"
	},                                                  -- mission rewards (table of strings)
	became_world_leader_event,      -- trigger event 
	nil,												-- Listener condition
	false,												-- Fire once
	destroy_world_leader_event,     -- completion event
	nil,														-- failure event
	"3k_main_victory_objective_issuer"							--mission_issuer
);

cdir_mission_manager:start_mission_listener(
	faction_key,                          -- faction key
	"3k_main_victory_objective_chain_4",                     -- mission key
	"CONTROL_N_REGIONS_INCLUDING",                                  -- objective type
	{
		"total 95"
	}, 
	{
		"money 15000"
	},                                                 -- mission rewards (table of strings)
	destroy_world_leader_event,      -- trigger event 
	nil,												-- Listener condition
	false,												-- Fire once
	"",     -- completion event
	nil,														-- failure event
	"3k_main_victory_objective_issuer"							--mission_issuer
);
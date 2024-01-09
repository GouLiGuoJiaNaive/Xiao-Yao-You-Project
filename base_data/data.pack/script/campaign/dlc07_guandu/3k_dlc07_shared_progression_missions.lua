--[[ HEADER
	Name: dlc07_shared_progression_missions
	Description: 
		A shared setup for missions of the various factions within the Guandu/200ad DLC campaign.
		Attempted to unify the missions to make it easier to setup and maintain across factions.
		N.B. In most respects this will copy the implementations from previous DLCs, but this is considerably safer than retrofitting all the old setups.
]]--

output("dlc07_shared_progression_missions: Loading");

--[[ VARIABLES
	Setup variables here.
	Most variables should be 'local' (only in this script). 
	Only add global variables if they need to be accessed outside this script.
]]--
local default_turn_to_start_progression_missions = 10;
local mission_issuer = "3k_main_victory_objective_issuer";

local second_marquis_mission_key_default = "3k_dlc07_victory_objective_chain_become_second_marquis";
local second_marquis_mission_keys = {
	["3k_main_faction_cao_cao"] = "3k_main_tutorial_mission_cao_cao_reach_progression_rank";
	-- ["3k_main_faction_liu_bei"] = "3k_main_tutorial_mission_liu_bei_reach_progression_rank"; -- Talks about dong zhuo too much.
	["3k_main_faction_liu_yan"] = "3k_dlc07_victory_objective_chain_1_liu_zhang";
	-- ["3k_main_faction_liu_biao"] = "3k_main_tutorial_mission_liu_biao_reach_progression_rank_dong_zhuo"; -- Talks about dong zhuo too much.
	-- ["3k_main_faction_ma_teng"] = "3k_main_tutorial_mission_ma_teng_reach_progression_rank"; -- Talks about dong zhuo too much.
	["3k_main_faction_zhang_yan"] = "3k_main_tutorial_mission_zhang_yan_reach_progression_rank";
	["3k_main_faction_zheng_jiang"] = "3k_dlc05_tutorial_mission_zheng_jiang_reach_progression_rank";
	["3k_main_faction_yellow_turban_anding"] = "3k_ytr_tutorial_mission_gong_du_1_reach_rank_2";
}

local marquis_mission_key_default = "3k_dlc07_victory_objective_chain_become_marquis";
local marquis_mission_keys = {
	["3k_main_faction_yellow_turban_anding"] = "3k_ytr_tutorial_mission_gong_du_2_reach_rank_3";
	["3k_main_faction_zhang_yan"] = "3k_dlc07_victory_objective_chain_bandits_become_raider";
	["3k_main_faction_zheng_jiang"] = "3k_dlc07_victory_objective_chain_bandits_become_raider";
}

local duke_mission_key_default = "3k_dlc07_victory_objective_chain_become_duke";
local duke_mission_keys = {
	["3k_dlc05_faction_sun_ce"] = "3k_dlc05_victory_objective_chain_1_sun_ce";
	["3k_main_faction_cao_cao"] = "3k_main_victory_objective_chain_1_cao_cao";
	["3k_main_faction_liu_bei"] = "3k_main_victory_objective_chain_1_liu_bei";
	["3k_main_faction_liu_yan"] = "3k_dlc07_victory_objective_chain_1_liu_zhang";
	["3k_main_faction_liu_biao"] = "3k_main_victory_objective_chain_1_liu_biao";
	["3k_main_faction_ma_teng"] = "3k_main_victory_objective_chain_1_ma_teng";
	["3k_main_faction_shi_xie"] = "3k_dlc06_victory_objective_chain_shi_xie_190_1";
	["3k_main_faction_zhang_yan"] = "3k_main_victory_objective_chain_1_zhang_yan";
	["3k_main_faction_zheng_jiang"] = "3k_main_victory_objective_chain_1_zheng_jiang";
	["3k_main_faction_yellow_turban_anding"] = "3k_main_victory_objective_chain_1_gong_du";
}

local emperor_mission_key_default = "3k_dlc07_victory_objective_chain_become_emperor";
local emperor_mission_keys = {
	["3k_main_faction_yellow_turban_anding"] = "3k_main_victory_objective_chain_2_yellow_turban";
}

local destroy_world_leaders_mission_key_default = "3k_main_victory_objective_chain_3_han";
local destroy_world_leaders_mission_keys = {
	["3k_main_faction_yellow_turban_anding"] = "3k_main_victory_objective_chain_3_yellow_turban";
};

local conquer_95_regions_mission_key_default = "3k_main_victory_objective_chain_4";
local conquer_95_regions_mission_keys = {
	["3k_main_faction_yellow_turban_anding"] = "3k_main_victory_objective_chain_4";
}
  
-- If you want global variables/functions (and think carefully if you do), please wrap them in a table of 'dlc07_shared_progression_missions'.
dlc07_shared_progression_missions = {}


--[[ LOCAL FUNCTIONS
	Accesible only by this script. Should be defined before they are used in the file.
	Should define as 'local function function_name(params)'
]]--

-- Add local functions here.
-- Handles missions which ask the faction to increase their progression level.
-- Automatically adjusts to the faction's progression level when triggered.
function dlc07_shared_progression_missions:setup_han_progression_missions(faction_key, optional_start_round)

	-- All these missions occur before the player becomes world leader, so skip if we already are.
	if cm:query_faction(faction_key):is_world_leader() then
		return;
	end;
	
	local start_round = optional_start_round or default_turn_to_start_progression_missions;
	local start_progression_event = faction_key .. "_dlc07_progression_start";
	local second_marquis_event = faction_key .. "_dlc07_progression_rank_second_marquis";
	local marquis_event = faction_key .. "_dlc07_progression_rank_marquis";
	local duke_event = faction_key .. "_dlc07_progression_rank_duke";

	local second_marquis_mission_key = second_marquis_mission_keys[faction_key] or second_marquis_mission_key_default;
	local marquis_mission_key = marquis_mission_keys[faction_key] or marquis_mission_key_default;
	local duke_mission_key = duke_mission_keys[faction_key] or duke_mission_key_default;
	local emperor_mission_key = emperor_mission_keys[faction_key] or emperor_mission_key_default;

	
	-- Only establish the listener if we've not already triggered any missions from it, as it will try and resetablish each time we load the game.
	if not cdir_mission_manager:has_been_triggered(second_marquis_mission_key, faction_key) 
		and not cdir_mission_manager:has_been_triggered(marquis_mission_key, faction_key) 
		and not cdir_mission_manager:has_been_triggered(duke_mission_key, faction_key) 
		and not cdir_mission_manager:has_been_triggered(emperor_mission_key, faction_key) 
	then
		-- Kicks off the event chains at an arbitrary point in gameplay based on the faction's progression level. Could do something more elegant, but keeping this simple.
		core:add_listener(
			faction_key.."TriggerProgressionMissions",
			"FactionTurnStart",
			function(context)
				-- Use the optional start round if one is passed in, or just the default.
				return context:faction():name() == faction_key and context:query_model():turn_number() >= start_round;
			end,
			function(context) 
				-- N.B. We don't support Nanman as they're using their own cross-campaign script (_shared/dlc06_nanman_shared_progression_events.lua).
				-- Because the script is shared, we won't know the starting progression level of the faction. Using this we can 'skip' the missions we don't care about.
				if progression:has_progression_feature(faction_key, "rank_duke", true) then
					core:trigger_event(duke_event);
				elseif progression:has_progression_feature(faction_key, "rank_marquis", true) then
					core:trigger_event(marquis_event);
				elseif progression:has_progression_feature(faction_key, "rank_second_marquis", true) then
					core:trigger_event(second_marquis_event);
				elseif progression:has_progression_feature(faction_key, "rank_noble", true) then
					core:trigger_event(start_progression_event);
				end;
			end,
			false
		)
	end
	
	if not progression:has_progression_feature(faction_key, "rank_second_marquis") then
		cdir_mission_manager:start_mission_listener(
			faction_key,                          		-- faction key
			second_marquis_mission_key,        -- mission key
			"ATTAIN_FACTION_PROGRESSION_LEVEL",                 -- objective type
			{
				"rank_second_marquis"
			},                                                  -- conditions (single string or table of strings)
			{
				"money 2000"
			},                                                  -- mission rewards (table of strings)
			start_progression_event,      -- trigger event 
			nil,												-- Listener condition
			false,												-- Fire once
			second_marquis_event,     -- completion event
			nil,														-- failure event
			mission_issuer							--mission_issuer
		);
	end

	if not progression:has_progression_feature(faction_key, "rank_marquis") then
		cdir_mission_manager:start_mission_listener(
			faction_key,                          		-- faction key
			marquis_mission_key,        -- mission key
			"ATTAIN_FACTION_PROGRESSION_LEVEL",                 -- objective type
			{
				"rank_marquis"
			},                                                  -- conditions (single string or table of strings)
			{
				"money 2000"
			},                                                  -- mission rewards (table of strings)
			second_marquis_event,      -- trigger event 
			nil,												-- Listener condition
			false,												-- Fire once
			marquis_event,     -- completion event
			nil,														-- failure event
			mission_issuer							--mission_issuer
		);
	end;

	if not progression:has_progression_feature(faction_key, "rank_duke") then
		cdir_mission_manager:start_mission_listener(
			faction_key,                          -- faction key
			duke_mission_key,                     -- mission key
			"ATTAIN_FACTION_PROGRESSION_LEVEL",                                  -- objective type
			{
				"rank_duke"
			}, 
			{
				"money 2000"
			},                                                  -- mission rewards (table of strings)
			marquis_event,      -- trigger event 
			nil,												-- Listener condition
			false,												-- Fire once
			duke_event,     -- completion event
			nil,														-- failure event
			mission_issuer							--mission_issuer
		);
	end;

	cdir_mission_manager:start_mission_listener(
		faction_key,                          -- faction key
		emperor_mission_key,                     -- mission key
		"BECOME_WORLD_LEADER",                                  -- objective type
		nil, 
		{
			"money 5000"
		},                                                  -- mission rewards (table of strings)
		duke_event,      -- trigger event 
		nil,												-- Listener condition
		false,												-- Fire once
		"",     -- completion event
		nil,														-- failure event
		mission_issuer							--mission_issuer
	);

end

-- Sets up the missions to destroy world leaders and capture regions.
function dlc07_shared_progression_missions:setup_han_victory_missions(faction_key)
	local become_world_leader_event = faction_key .. "_dlc07_progression_became_emperor";
	local destroy_world_leader_event = faction_key .. "_dlc07_progression_destroyed_all_emperors";

	if not cm:query_faction(faction_key):is_world_leader() then
		core:add_listener(
			faction_key.."BecameEmperor",
			"FactionBecomesWorldLeader",
			function(context)
				return context:faction():name() == faction_key;
			end,
			function(context) 
				core:trigger_event(become_world_leader_event)
				core:remove_listener(faction_key.."BecameEmperor");
			end,
			false
		);

		core:add_listener(
			faction_key.."BecameEmperor",
			"FactionBecomesWorldLeaderCaptureSettlement",
			function(context)
				return context:faction():name() == faction_key;
			end,
			function(context) 
				core:trigger_event(become_world_leader_event)
				core:remove_listener(faction_key.."BecameEmperor");
			end,
			false
		);
		
	end

	cdir_mission_manager:start_mission_listener(
		faction_key,                          -- faction key
		destroy_world_leaders_mission_keys[faction_key] or destroy_world_leaders_mission_key_default,                     -- mission key
		"DESTROY_ALL_WORLD_LEADERS",                                  -- objective type
		nil, 
		{
			"money 10000"
		},                                                  -- mission rewards (table of strings)
		become_world_leader_event,      -- trigger event 
		nil,												-- Listener condition
		false,												-- Fire once
		destroy_world_leader_event,     -- completion event
		nil,														-- failure event
		"3k_main_victory_objective_issuer"							--mission_issuer
	);

	cdir_mission_manager:start_mission_listener(
		faction_key,                          -- faction key
		conquer_95_regions_mission_keys[faction_key] or conquer_95_regions_mission_key_default,                     -- mission key
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
end;


--[[ GLOBAL FUNCTIONS
	Accessible both inside and outside of this script.
	Should define as 'function dlc07_shared_progression_missions:function_name(params)'
]]--

-- Add global functions here.



--[[ INITIALISATION
	Handles installing the script into the game logic.
]]--

-- Fires on the first tick of a New Campaign
--[[ cm:add_first_tick_callback_new(function()
	output("dlc07_shared_progression_missions: New Game");
end); ]]

-- Fires on the first tick of every game loaded.
--[[ cm:add_first_tick_callback(function()
end); ]]
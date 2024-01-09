function setup_shared_faction_events_han_empire(local_faction_key, success_key, failure_key)
	--[[
	***************************************************
	***************************************************
	** TURN 3
	***************************************************
	***************************************************
	]]--

	-- The brothers zhang
	cdir_mission_manager:start_incident_db_listener(
		local_faction_key, -- faction_key 
		"3k_dlc04_progression_global_yellow_turban_rebellion_the_zhang_brothers_incident", -- event_key 
		"FactionTurnStart", -- trigger event 
		function(context)
			return cdir_mission_manager:get_turn_number() == 3 and context:faction():name() == local_faction_key;
		end, --listener condition
		false, -- fire_once.
		nil, -- completion event 
		nil -- failure event
	);

	--[[
	***************************************************
	***************************************************
	** TURN 5
	***************************************************
	***************************************************
	]]--

	-- The brothers zhang
	cdir_mission_manager:start_incident_db_listener(
		local_faction_key, -- faction_key 
		"3k_dlc04_progression_global_yellow_turban_rebellion_graffiti_incident", -- event_key 
		"FactionTurnStart", -- trigger event 
		function(context)
			return cdir_mission_manager:get_turn_number() == 5 and context:faction():name() == local_faction_key;
		end, --listener condition
		false, -- fire_once.
		nil, -- completion event 
		nil -- failure event
	);

	--[[
	***************************************************
	***************************************************
	** TURN 6
	***************************************************
	***************************************************
	]]--

	-- The brothers zhang
	cdir_mission_manager:start_incident_db_listener(
		local_faction_key, -- faction_key 
		"3k_dlc04_progression_global_yellow_turban_rebellion_tang_zhou_defects_incident", -- event_key 
		"FactionTurnStart", -- trigger event 
		function(context)
			return cdir_mission_manager:get_turn_number() == 6 and context:faction():name() == local_faction_key;
		end, --listener condition
		false, -- fire_once.
		nil, -- completion event 
		nil -- failure event
	);

end;

function setup_shared_faction_events_yellow_turbans(local_faction_key, success_key, failure_key)

end;
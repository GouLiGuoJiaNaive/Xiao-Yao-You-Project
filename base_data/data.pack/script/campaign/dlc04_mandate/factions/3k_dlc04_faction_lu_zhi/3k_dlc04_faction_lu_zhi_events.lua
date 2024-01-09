--[[
***************************************************
***************************************************
** VARIABLES
***************************************************
***************************************************
]]--
local local_faction_key = "3k_dlc04_faction_lu_zhi";
local success_key = "dlc04_" .. local_faction_key .. "_success";
local failure_key = "dlc04_" .. local_faction_key .. "_failure";

output("Events script loaded for " .. local_faction_key);
setup_shared_faction_events_han_empire(local_faction_key, success_key, failure_key);

-- Spawn initial armies.
local function initial_set_up()
	local invasion = campaign_invasions:create_invasion("3k_main_faction_yellow_turban_generic", "3k_main_henei_capital", 1, true, local_faction_key, true, 482, 509);
	invasion:set_force_retreated();
	invasion:start_invasion();
end;

cm:add_first_tick_callback_new(initial_set_up);


--[[
***************************************************
** Introduction
***************************************************
]]--

cdir_mission_manager:start_incident_db_listener(
	local_faction_key, -- faction_key 
	"3k_dlc04_introduction_lu_zhi_incident", -- event_key 
	"FactionTurnStart", -- trigger event 
	function(context)
		return cdir_mission_manager:get_turn_number() == 1 and context:faction():name() == local_faction_key;
	end, --listener condition
	false, -- fire_once.
	success_key.."_Intro_Fired", -- completion event 
	nil -- failure event
);

--[[
***************************************************
** Attack the bandits!
***************************************************
]]--

-- A mission
cdir_mission_manager:start_mission_db_listener(
	local_faction_key, -- faction_key 
	"3k_dlc04_tutorial_lu_zhi_mission", -- event_key 
	success_key.."_Intro_Fired", -- trigger event 
	function(context)
		return true
	end, --listener condition
	false, --fire_once
	success_key.."first_mission", -- completion event 
	failure_key.."first_mission", -- failure event
	false -- delay_start
);

core:add_listener(
	local_faction_key.."unlock_first_faction_ceo",
	success_key.."first_mission",
	true,
	function()
		local modfaction = cm:modify_faction(local_faction_key)
		modfaction:ceo_management():change_points_of_ceos("3k_dlc04_ceo_factional_great_library_authority_common",1)
	end,
	false
);

-- An incident
cdir_mission_manager:start_incident_db_listener(
	local_faction_key, -- faction_key 
	"3k_dlc04_progression_lu_zhi_faction_ceos_incident", -- event_key 
	success_key.."first_mission", -- trigger event 
	function(context)
		return true
	end, --listener condition
	false, --fire_once
	success_key.."faction_ceos", -- completion event
	false -- delay_start
);

-- A mission
cdir_mission_manager:start_mission_db_listener(
	local_faction_key, -- faction_key 
	"3k_dlc04_progression_lu_zhi_equip_faction_ceo_mission", -- event_key 
	success_key.."faction_ceos", -- trigger event 
	function(context)
		return true
	end, --listener condition
	false, --fire_once
	success_key.."equiped_ceo", -- completion event 
	failure_key.."equiped_ceo", -- failure event
	false -- delay_start
);


cdir_mission_manager:start_mission_db_listener(
	local_faction_key, -- faction_key 
	"3k_dlc04_progression_lu_zhi_reach_faction_rank", -- event_key 
	success_key.."equiped_ceo", -- trigger event 
	function(context)
		return true
	end, --listener condition
	false, --fire_once
	success_key.."faction_ranked_up", -- completion event 
	failure_key.."faction_ranked_up", -- failure event
	false -- delay_start
);

-- An incident
cdir_mission_manager:start_incident_db_listener(
	local_faction_key, -- faction_key 
	"3k_dlc04_progression_lu_zhi_title_incident", -- event_key 
	success_key.."equiped_ceo", -- trigger event 
	function(context)
		return true
	end, --listener condition
	false, --fire_once
	success_key.."gain_title", -- completion event
	false -- delay_start
);

--[[
***************************************************
***************************************************
** TURN 8
***************************************************
***************************************************
]]--

cdir_mission_manager:start_mission_db_listener(
	local_faction_key, -- faction_key 
	"3k_dlc04_progression_lu_zhi_01_yellow_turbans_mission", -- event_key 
	"FactionTurnStart", -- trigger event 
	function(context)
		return cdir_mission_manager:get_turn_number() == 8 and context:faction():name() == local_faction_key;
	end, --listener condition
	false, --fire_once
	success_key.."yt_attacked_01", -- completion event 
	failure_key.."yt_attacked_01", -- failure event
	false -- delay_start
);

cdir_mission_manager:start_mission_db_listener(
	local_faction_key, -- faction_key 
	"3k_dlc04_progression_lu_zhi_02_yellow_turbans_mission", -- event_key 
	success_key.."yt_attacked_01", -- trigger event 
	function(context)
		return true
	end, --listener condition
	false, --fire_once
	success_key.."yt_attacked_02", -- completion event 
	failure_key.."yt_attacked_02", -- failure event
	false -- delay_start
);

--[[
***************************************************
***************************************************
** TURN 32
***************************************************
***************************************************
]]--

cdir_mission_manager:start_incident_db_listener(
	local_faction_key, -- faction_key 
	"3k_dlc04_progression_lu_zhi_dong_zhuo_incident", -- event_key 
	"FactionTurnStart", -- trigger event 
	function(context)
		return cdir_mission_manager:get_turn_number() == 32 and context:faction():name() == local_faction_key;
	end, --listener condition
	false, -- fire_once.
	success_key.."dong_zhuo_incident", -- completion event 
	nil -- failure event
);
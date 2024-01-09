--[[
***************************************************
***************************************************
** VARIABLES
***************************************************
***************************************************
]]--
local local_faction_key = "3k_main_faction_liu_biao";
local listener_key = "dlc07_" .. local_faction_key;
local success_key = "dlc07_" .. local_faction_key .. "_success";
local failure_key = "dlc07_" .. local_faction_key .. "_failure";

output("Events script loaded for " .. local_faction_key);

-- Handles REACH_FACTION_RANK and VICTORY CONDITION missions for factions.
dlc07_shared_progression_missions:setup_han_progression_missions(local_faction_key, 2);
dlc07_shared_progression_missions:setup_han_victory_missions(local_faction_key);

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

		core:trigger_event(success_key .. "_fire_intro");
	end,
	false --Is persistent
);


cdir_mission_manager:start_incident_db_listener(
	local_faction_key, -- faction_key 
	"3k_dlc07_incident_liu_biao_campaign_intro_200", -- event_key 
	success_key .. "_fire_intro", -- trigger event 
	function(context)
		return true;
	end, --listener condition
	false, -- fire_once.
	success_key.."_Intro_Fired", -- completion event 
	nil, -- failure event
	false -- delay start
);

-- #endregion
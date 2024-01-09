--[[
***************************************************
***************************************************
** VARIABLES
***************************************************
***************************************************
]]--
local local_faction_key = "3k_dlc06_faction_nanman_king_mulu";
local listener_key = "dlc06_" .. local_faction_key;
local success_key = "dlc06_" .. local_faction_key .. "_success";
local failure_key = "dlc06_" .. local_faction_key .. "_failure";

output("Events script loaded for " .. local_faction_key);

nanman_shared_progression_events:setup(local_faction_key, "3k_dlc06_faction_nanman_jiaozhi");

-- Initial Logic.
local function initial_set_up()
	cm:trigger_incident(local_faction_key, "3k_dlc06_faction_king_mulu_introduction_190_incident", true);

end;

cm:add_first_tick_callback_new(initial_set_up);


--[[
***************************************************
***************************************************
** Intro
***************************************************
***************************************************
]]--


core:add_listener(
	listener_key.. "MissionSucceededMuluSecondSteps", -- Unique handle
	"MissionSucceeded", -- Campaign Event to listen for
	function(context)
		return context:mission():mission_record_key() == "3k_dlc06_progression_nanman_destroy_faction_mission" -- listen for first mission to be completed
		and context:faction():name()== local_faction_key -- also listen to see if the player faction is Mulu.
		end,
		  function(context) -- What to do if listener fires.
			core:trigger_event(success_key .. "_mulu_second_steps"); -- trigger second steps dilemma
		end,
		true, --is persistent
		nil, -- completion event 
		nil -- failure event
		);


-- Dilemma about who to go to war with, Shi Xie or Duosi
cdir_mission_manager:start_dilemma_db_listener(
	local_faction_key, --faction_key
	"3k_dlc06_faction_king_mulu_second_steps_dilemma", --event_key
	success_key .. "_mulu_second_steps", --trigger_event
	function(context)
		return true
	end, --listener condition
	true, -- fire_once.
	nil, -- completion event 
	nil, -- failure event
	true, -- delay start
	nil, -- on trigger event
	success_key.."_mulu_shi_xie_war", -- Choice A (go to war with Shi Xie, starts "3k_dlc06_faction_king_mulu_shi_xie_mission")
	success_key.."_mulu_duosi_war" -- Choice B (go to war with duosi, starts "3k_dlc06_faction_king_mulu_duosi_mission")
);


-- Destroy Shi Xie Faction
start_historical_mission_listener(
	local_faction_key,                          -- faction key
    "3k_dlc06_faction_king_mulu_shi_xie_mission",               -- mission key
    "DESTROY_FACTION",
    {
        "faction 3k_main_faction_shi_xie"
    }, 
    {
		"money 3000"
	    },
	success_key.."_mulu_shi_xie_war",   -- trigger event
    success_key.."_mulu_shi_xie_war_won", -- completion event
    function()
		return not cm:query_faction("3k_main_faction_shi_xie"):is_dead()
    end,                                                -- precondition (nil, or a function that returns a boolean)
	nil       -- failure event
);

-- Fire Incident if you defeat Shi Xie
cdir_mission_manager:start_incident_db_listener(
	local_faction_key, -- faction_key 
	"3k_dlc06_faction_king_mulu_after_shi_xie_event", -- event_key 
	success_key .. "_mulu_shi_xie_war_won", -- trigger event 
	function(context)
		return true;
	end, --listener condition
	true, -- fire_once.
	nil, -- completion event 
	nil, -- failure event
	false -- delay start
); 

-- Destroy Duosi Faction
start_historical_mission_listener(
	local_faction_key,                          -- faction key
    "3k_dlc06_faction_king_mulu_duosi_mission",               -- mission key
    "DESTROY_FACTION",
    {
        "faction 3k_dlc06_faction_nanman_king_duosi"
    }, 
    {
		"money 1000"
    },
	success_key.."_mulu_duosi_war",   -- trigger event
    success_key.."_mulu_duosi_war_won", -- completion event
    function()
		return not cm:query_faction("3k_dlc06_faction_nanman_king_duosi"):is_dead()
    end,                                                -- precondition (nil, or a function that returns a boolean)
	nil      -- failure event
);


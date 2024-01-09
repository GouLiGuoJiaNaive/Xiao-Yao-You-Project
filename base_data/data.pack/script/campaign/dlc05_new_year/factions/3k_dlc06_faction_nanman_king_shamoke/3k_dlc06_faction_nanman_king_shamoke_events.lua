---------------------------------------------------
---------------------------------------------------
------------------- VARIABLES ---------------------
---------------------------------------------------
---------------------------------------------------

local local_faction_key = "3k_dlc06_faction_nanman_king_shamoke";
local script_event_key = "script_event_dlc06_" .. local_faction_key;
local success_key = "dlc06_" .. local_faction_key .. "_success";
local failure_key = "dlc06_" .. local_faction_key .. "_failure";

output("Events script loaded for " .. local_faction_key);
nanman_shared_progression_events:setup(local_faction_key, "3k_dlc06_faction_nanman_jinhuansanjie");

-- Check if Shamoke has already made a choice for the reformation dilemma, if not assign a default value
if not cm:saved_value_exists("specialisation_option_saved_value_key", "DLC06_shamoke_faction_events_values") then
	cm:set_saved_value("specialisation_option_saved_value_key", "none", "DLC06_shamoke_faction_events_values");
end;


local function initial_set_up()
	-- Introduction incident
	cm:trigger_incident(local_faction_key, "3k_dlc06_introduction_shamoke_194_incident", true);
end;

cm:add_first_tick_callback_new(initial_set_up);

---------------------------------------------------
---------------------------------------------------
------------------- Functions ---------------------
---------------------------------------------------
---------------------------------------------------



---------------------------------------------------
---------------------------------------------------
---- Listeners for Shamokes Faction Incidents -----
---------------------------------------------------
---------------------------------------------------

-- Triggering Shamoke's incident 3k_dlc06_faction_king_shamoke_turmoil_in_distant_lands 
cdir_mission_manager:start_incident_db_listener(
	local_faction_key, -- faction_key 
	"3k_dlc06_faction_king_shamoke_turmoil_in_distant_lands", -- event_key 
	"FactionTurnStart", -- trigger event
	function(context)
		-- this event triggers for Shamoke on turn 2.
		output("3k_dlc06_faction_nanman_king_shamoke_events.lua: Listener 3k_dlc06_faction_king_shamoke_turmoil_in_distant_lands will trigger on turn 2");	
		return cdir_mission_manager:get_turn_number() == 2 and context:faction():name() == local_faction_key;
	end,
	false, -- fire_once.
	nil, -- completion event 
	nil -- failure event
)


---------------------------------------------------
---------------------------------------------------
-- Listeners to enable Shamokes Faction Features --
---------------------------------------------------
---------------------------------------------------


-- Triggering Shamoke's alternative victory objectives
core:add_listener(
	"Shamoke_cultural_dilemma", -- listener key
    "FealtyTribesUnitedBy", -- trigger event
	function(context)
		return local_faction_key == context:faction_key();
	end,
    function()
        cm:modify_faction(local_faction_key):trigger_dilemma("3k_dlc06_shamoke_cultural_reformation_dilemma",true);
    end, -- Function to fire.
    false -- Is Persistent?
);

-- If Shamoke chose to become Han, unlock Han diplomacy specialisation
core:add_listener(
	"shamoke_cultural_dilemma_chose_han",
	"DilemmaChoiceMadeEvent",
	function(context)
		return context:faction():name() == local_faction_key and context:dilemma() == "3k_dlc06_shamoke_cultural_reformation_dilemma" and context:choice() == 1
	end,
	function(context)
		cm:set_saved_value("specialisation_option_saved_value_key", "han_chosen", "DLC06_shamoke_faction_events_values")
		default_diplomacy:shamoke_han_diplomacy_specialisation()
	end,
	false
);

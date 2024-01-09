--[[
***************************************************
***************************************************
** VARIABLES
***************************************************
***************************************************
]]--
local local_faction_key = "3k_dlc06_faction_nanman_king_mulu";

output("Events script loaded for " .. local_faction_key);

nanman_shared_progression_events:setup(local_faction_key, "3k_dlc06_faction_nanman_dongtuna");

-- Initial Logic.
local function initial_set_up()
	cm:trigger_incident(local_faction_key, "3k_dlc06_faction_king_mulu_introduction_194_incident", true);

end;

cm:add_first_tick_callback_new(initial_set_up);
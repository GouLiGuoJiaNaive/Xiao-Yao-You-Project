--[[
***************************************************
***************************************************
** VARIABLES
***************************************************
***************************************************
]]--
local local_faction_key = "3k_dlc06_faction_nanman_king_shamoke";
local listener_key = "dlc07_" .. local_faction_key;
local success_key = "dlc07_" .. local_faction_key .. "_success";
local failure_key = "dlc07_" .. local_faction_key .. "_failure";

output("Events script loaded for " .. local_faction_key);

nanman_shared_progression_events:setup(local_faction_key, nil, true);

output("Events script loaded for " .. local_faction_key);

-- Check if Shamoke has already made a choice for the reformation dilemma, if not assign a default value
if not cm:saved_value_exists("specialisation_option_saved_value_key", "DLC06_shamoke_faction_events_values") then
	cm:set_saved_value("specialisation_option_saved_value_key", "none", "DLC06_shamoke_faction_events_values");
end;

-- Spawn initial armies.
local function initial_set_up()
	
	--shamokes characters
	local character_cai = cm:query_model():character_for_startpos_id("896670074")
	local character_luo_qun = cm:query_model():character_for_startpos_id("1280005895")

	--mulus character
	local character_dongtuna = cm:query_model():character_for_startpos_id("188106718")

	local modify_shamoke_force = cm:modify_model():get_modify_military_force(character_cai:military_force())
	cm:modify_scripting():override_ui("disable_selection_change", true)

	--adds luo qun to cai military force
	modify_shamoke_force:add_existing_character_as_retinue(cm:modify_model():get_modify_character(character_luo_qun), true)

	--if mulu not human, shuffles armies around to skew battle in shamoke favour
	if not cm:query_faction("3k_dlc06_faction_nanman_king_mulu"):is_human() then
		
		cm:modify_model():get_modify_character(character_cai):teleport_to(282,261)

		cm:modify_model():get_modify_military_force(character_dongtuna:military_force()):set_retreated()

		cm:modify_model():get_modify_character(character_dongtuna):teleport_to(281,256)
	end

	cm:modify_scripting():override_ui("disable_selection_change", false)
end

cm:add_first_tick_callback_sp_new(initial_set_up);
cm:add_first_tick_callback_mp_new(initial_set_up);


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
	"3k_dlc07_incident_shamoke_campaign_intro_200", -- event_key 
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
)
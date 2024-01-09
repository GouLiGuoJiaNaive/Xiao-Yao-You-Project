-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
------------------------- Cao Cao Tutorial Missions ---------------------------
-------------------------------------------------------------------------------
------------------------- Created by Nic: 29/05/2018 --------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

output("Introduction mission script loaded for " .. cm:get_local_faction());

function should_start_tutorial_missions()
	return not core:is_tweaker_set("FORCE_DISABLE_TUTORIAL");
end;

if not cm:get_saved_value("start_incident_unlocked") then 
    core:add_listener(
                "introduction_incident_lu_bu",
                "FactionTurnStart", 
                true,
                function(context)
					out.interventions(" ### Intro how to play incident triggered")
					cdir_events_manager:add_prioritised_incidents( context:faction():command_queue_index(), "3k_dlc05_introduction_lu_bu_incident" );
                    cm:set_saved_value("start_incident_unlocked", true);
                end,
                false
    )
end

-- cao cao introduction mission 01
-- lu bu historical mission 01
start_tutorial_mission_listener(
    "3k_main_faction_lu_bu",                          -- faction key
    "3k_dlc05_objective_lu_bu_01",                     -- mission key
    "ENGAGE_FORCE",                                  -- objective type
    {
        "faction 3k_main_faction_cao_cao",
        "armies_only"
    },                                                  -- conditions (single string or table of strings)
    {
        "effect_bundle{bundle_key 3k_dlc05_introduction_mission_bundle_lu_bu;turns 10;}"
    },                                                  -- mission rewards (table of strings)
    "ScriptEventStartTutorialMissions",      -- trigger event 
	"ScriptEventLuBuTutorialMission01Complete", -- completion event
	nil,											-- precondition
	"ScriptEventLuBuTutorialMission01Complete",		-- failure trigger
	nil, 											-- mission issuer
	25												--turn limit
 
)

-- lu bu historical mission 02a
start_tutorial_mission_listener(
    "3k_main_faction_lu_bu",                          -- faction key
    "3k_dlc05_objective_lu_bu_02",                     -- mission key
    "OWN_N_UNITS",                                  -- objective type
    {
        4       -- special case, just supply the number of units we want the player to recruit
    },                                                  -- conditions (single string or table of strings)
    {
        "effect_bundle{bundle_key 3k_main_introduction_mission_payload_recruit_units;turns 3;}"
    },                                                  -- mission rewards (table of strings)
    "ScriptEventLuBuTutorialMission01Complete",      -- trigger event 
	"ScriptEventLuBuTutorialMission02Complete",     -- completion event
	nil,											--precondition
	"ScriptEventLuBuTutorialMission02Complete",		--failure event
	nil,											--mission issuer
	25												--turn limit
)


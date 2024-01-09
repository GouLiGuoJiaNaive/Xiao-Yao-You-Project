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
                "introduction_incident_cao_cao",
                "FactionTurnStart", 
                true,
                function(context)
					out.interventions(" ### Intro how to play incident triggered")
					cdir_events_manager:add_prioritised_incidents( context:faction():command_queue_index(), "3k_dlc05_introduction_cao_cao_incident" );
                    cm:set_saved_value("start_incident_unlocked", true);
                end,
                false
    )
end

-- cao cao historical mission 01
start_tutorial_mission_listener(
    "3k_main_faction_cao_cao",                          -- faction key
    "3k_dlc05_objective_cao_cao_01",                     -- mission key
    "CONTROL_N_REGIONS_INCLUDING",                                  -- objective type
    {
        "total 1",
        "region 3k_main_chenjun_capital"
    },                                                  -- conditions (single string or table of strings)
    {
        "effect_bundle{bundle_key 3k_main_historical_mission_payload_01;turns 5;}"
    },                                                  -- mission rewards (table of strings)
    "ScriptEventStartTutorialMissions",      -- trigger event 
	"ScriptEventCaoCaoTutorialMission01Complete",     -- completion event
	nil,
	"ScriptEventCaoCaoTutorialMission01Complete",
	nil,
	25
)

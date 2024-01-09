-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
------------------------- Gongsun Zan 194 Tutorial Missions -------------------
-------------------------------------------------------------------------------
---------- Adapted by Will W from Nic's original script: 03/09/2019 -----------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

output("Introduction mission script loaded for " .. cm:get_local_faction());

function should_start_tutorial_missions()
	return not core:is_tweaker_set("FORCE_DISABLE_TUTORIAL");
end;

if not cm:get_saved_value("start_incident_unlocked") then 
    core:add_listener(
                "introduction_incident_gongsun_zan",
                "FactionTurnStart", 
                true,
                function(context)
					out.interventions(" ### Intro how to play incident triggered")
					cdir_events_manager:add_prioritised_incidents( context:faction():command_queue_index(), "3k_dlc05_introduction_gongsun_zan_incident" );
                    cm:set_saved_value("start_incident_unlocked", true);
                end,
                false
    )
end

-- gongsun zan introduction mission 01
start_tutorial_mission_listener(
    "3k_main_faction_gongsun_zan",                          -- faction key
    "3k_dlc05_tutorial_mission_gongsun_zan_defeat_army",                     -- mission key
    "ENGAGE_FORCE",                                  -- objective type
    {
        "faction 3k_main_faction_youzhou",
        "armies_only"
    },                                                  -- conditions (single string or table of strings)
    {
        "effect_bundle{bundle_key 3k_main_introduction_mission_payload_defeat_force;turns 3;}"
    },                                                  -- mission rewards (table of strings)
    "ScriptEventStartTutorialMissions",      -- trigger event 
	"ScriptEventGongsunZanIntroductionMission01Complete",     -- completion event
	nil,
	"ScriptEventGongsunZanIntroductionMission01Complete",
	nil,
	25
)


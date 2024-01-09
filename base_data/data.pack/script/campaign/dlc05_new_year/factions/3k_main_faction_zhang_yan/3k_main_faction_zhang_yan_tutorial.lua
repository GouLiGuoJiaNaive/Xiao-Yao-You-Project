-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
------------------------- Zhang Yan Tutorial Missions -------------------------
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
                "introduction_incident_zhang_yan",
                "FactionTurnStart", 
                true,
                function(context)
					out.interventions(" ### Intro how to play incident triggered")
					cdir_events_manager:add_prioritised_incidents( context:faction():command_queue_index(), "3k_dlc05_introduction_zhang_yan_incident" );
                    cm:set_saved_value("start_incident_unlocked", true);
                end,
                false
    )
end

-- zhang yan introduction mission 01
start_tutorial_mission_listener(
    "3k_main_faction_zhang_yan",                          -- faction key
    "3k_dlc05_tutorial_mission_zhang_yan_defeat_army",                     -- mission key
    "ENGAGE_FORCE",                                  -- objective type
    {
        "faction 3k_main_faction_gao_gan",
        "armies_only"
    },                                                  -- conditions (single string or table of strings)
    {
        "effect_bundle{bundle_key 3k_main_introduction_mission_payload_defeat_force;turns 3;}"
    },                                                  -- mission rewards (table of strings)
    "ScriptEventStartTutorialMissions",      -- trigger event 
	"ScriptEventZhangYanIntroductionMission01Complete",     -- completion event
	nil,
	"ScriptEventZhangYanIntroductionMission01Complete",
	nil,
	25
)


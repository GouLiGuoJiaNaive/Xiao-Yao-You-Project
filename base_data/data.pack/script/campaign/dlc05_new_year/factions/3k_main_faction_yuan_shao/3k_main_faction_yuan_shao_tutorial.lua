-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
------------------------- Yuan Shao Tutorial Missions -------------------------
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
                "introduction_incident_yuan_shao",
                "FactionTurnStart", 
                true,
                function(context)
                    out.interventions(" ### Intro how to play incident triggered")
					cdir_events_manager:add_prioritised_incidents( context:faction():command_queue_index(), "3k_dlc05_introduction_yuan_shao_incident" );
                    cm:set_saved_value("start_incident_unlocked", true);
                end,
                false
    )
end

-- yuan shao introduction mission 01
start_tutorial_mission_listener(
    "3k_main_faction_yuan_shao",                          -- faction key
    "3k_dlc05_tutorial_mission_yuan_shao_destroy_faction",                     -- mission key
    "DESTROY_FACTION",                                  -- objective type
    {
        "faction 3k_main_faction_dongjun"
    },                                                  -- conditions (single string or table of strings)
    {
        "effect_bundle{bundle_key 3k_main_introduction_mission_payload_defeat_force;turns 3;}"
    },                                                  -- mission rewards (table of strings)
    "ScriptEventStartTutorialMissions",      -- trigger event 
	"ScriptEventYuanShaoIntroductionMission01Complete",     -- completion event
	function() return not cm:query_faction("3k_main_faction_dongjun"):is_dead() end,
	"ScriptEventYuanShaoIntroductionMission01Complete",
	nil,
	25

)

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
------------------------- Liu Biao Tutorial Missions --------------------------
-------------------------------------------------------------------------------
------------------------- Created by Matt: 28/08/2019 --------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

output("Introduction mission script loaded for " .. cm:get_local_faction());

function should_start_tutorial_missions()
	return not core:is_tweaker_set("FORCE_DISABLE_TUTORIAL");
end;

if not cm:get_saved_value("start_incident_unlocked") then 
    core:add_listener(
                "introduction_incident_liu_biao",
                "FactionTurnStart", 
                true,
                function(context)
					out.interventions(" ### Intro how to play incident triggered")
					cdir_events_manager:add_prioritised_incidents( context:faction():command_queue_index(), "3k_dlc05_introduction_liu_biao_incident" );
                    cm:set_saved_value("start_incident_unlocked", true);
                end,
                false
    )
end

-- liu biao introduction mission 01
start_tutorial_mission_listener(
    "3k_main_faction_liu_biao",                          -- faction key
    "3k_dlc05_tutorial_mission_liu_biao_defeat_army",                     -- mission key
    "ENGAGE_FORCE",                                  -- objective type
    {
        "faction 3k_main_faction_yellow_turban_rebels",
        "armies_only"
    },                                                  -- conditions (single string or table of strings)
    {
        "effect_bundle{bundle_key 3k_main_introduction_mission_payload_defeat_force;turns 3;}"
    },                                                  -- mission rewards (table of strings)
    "ScriptEventStartTutorialMissions",      -- trigger event 
	"ScriptEventLiuBiaoIntroductionMission01Complete",     -- completion event
	nil,
	"ScriptEventLiuBiaoIntroductionMission01Complete",
	nil,
	25
)



-- liu biao introduction mission 02
start_tutorial_mission_listener(
    "3k_main_faction_liu_biao",                          -- faction key
    "3k_dlc05_tutorial_mission_liu_biao_recruit_units",                     -- mission key
    "OWN_N_UNITS",                                  -- objective type
    {
        4       -- special case, just supply the number of units we want the player to recruit
    },                                                  -- conditions (single string or table of strings)
    {
        "effect_bundle{bundle_key 3k_main_introduction_mission_payload_recruit_units;turns 3;}"
    },                                                  -- mission rewards (table of strings)
    "ScriptEventLiuBiaoIntroductionMission01Complete",      -- trigger event 
	"ScriptEventLiuBiaoIntroductionMission02Complete",     -- completion event
	nil,
	"ScriptEventLiuBiaoIntroductionMission02Complete",
	nil,
	25
)

-- liu biao introduction mission 03
start_tutorial_mission_listener(
    "3k_main_faction_liu_biao",                          -- faction key
    "3k_dlc05_tutorial_mission_liu_biao_reach_progression_rank",                     -- mission key
    "ATTAIN_FACTION_PROGRESSION_LEVEL",                                  -- objective type
    {
        "total 3"
    },                                                  -- conditions (single string or table of strings)
    {
        "effect_bundle{bundle_key 3k_main_introduction_mission_payload_liu_biao;turns 6;}"
    },                                                  -- mission rewards (table of strings)
    "ScriptEventLiuBiaoIntroductionMission02Complete",      -- trigger event 
    "ScriptEventLiuBiaoIntroductionMission03Complete"     -- completion event
)
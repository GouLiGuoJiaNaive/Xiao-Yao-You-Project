-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
------------------------- tao qian Tutorial Missions --------------------------
-------------------------------------------------------------------------------
------------------------- Created by Jakob: 23/08/2019 ------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

output("Introduction mission script loaded for " .. cm:get_local_faction());

function should_start_tutorial_missions()
	return not core:is_tweaker_set("FORCE_DISABLE_TUTORIAL");
end;

if not cm:get_saved_value("start_incident_unlocked") then 
    core:add_listener(
                "introduction_incident_tao_qian",
                "FactionTurnStart", 
                true,
                function(context)
					out.interventions(" ### Intro how to play incident triggered")
					cdir_events_manager:add_prioritised_incidents( context:faction():command_queue_index(), "3k_main_introduction_tao_qian_incident" );
                    cm:set_saved_value("start_incident_unlocked", true);
                end,
                false
    )
end

-- tao qian introduction mission 01
start_tutorial_mission_listener(
    "3k_main_faction_tao_qian",                          -- faction key
    "3k_main_tutorial_mission_tao_qian_defeat_army",                     -- mission key
    "ENGAGE_FORCE",                                  -- objective type
    {
        "faction 3k_main_faction_yellow_turban_generic",
        "armies_only"
    },                                                  -- conditions (single string or table of strings)
    {
        "effect_bundle{bundle_key 3k_main_introduction_mission_payload_defeat_force;turns 3;}"
    },                                                  -- mission rewards (table of strings)
    "ScriptEventStartTutorialMissions",      -- trigger event 
    "ScriptEventTaoQianIntroductionMission01Complete"     -- completion event
)

-- tao qian introduction mission 02
start_tutorial_mission_listener(
    "3k_main_faction_tao_qian",                          -- faction key
    "3k_main_tutorial_mission_tao_qian_capture_settlement",                     -- mission key
	"OWN_N_REGIONS_INCLUDING",                                  -- objective type
    {
        "total 3",
        "region 3k_main_penchang_capital"
    },                                                  -- conditions (single string or table of strings)
    {
        "effect_bundle{bundle_key 3k_main_introduction_mission_payload_capture_regions;turns 3;}",
        "money 1000"
    },                                                  -- mission rewards (table of strings)
    "ScriptEventTaoQianIntroductionMission01Complete",      -- trigger event 
    "ScriptEventTaoQianIntroductionMission02Complete"     -- completion event
)

-- tao qian introduction mission 03
start_tutorial_mission_listener(
    "3k_main_faction_tao_qian",                          -- faction key
    "3k_main_tutorial_mission_tao_qian_recruit_units",                     -- mission key
    "OWN_N_UNITS",                                  -- objective type
    {
        2
    },                                                  -- conditions (single string or table of strings)
    {
        "effect_bundle{bundle_key 3k_main_introduction_mission_payload_recruit_units;turns 3;}"
    },                                                  -- mission rewards (table of strings)
    "ScriptEventTaoQianIntroductionMission02Complete",      -- trigger event 
    "ScriptEventTaoQianIntroductionMission03Complete"     -- completion event
)

-- tao qian introduction mission 04
start_tutorial_mission_listener(
    "3k_main_faction_tao_qian",                          -- faction key
    "3k_main_tutorial_mission_tao_qian_construct_building",                     -- mission key
    "CONSTRUCT_ANY_BUILDING",                                  -- objective type
    nil,                                                  -- conditions (single string or table of strings)
    {
        "effect_bundle{bundle_key 3k_main_introduction_mission_payload_construct_building;turns 3;}"
    },                                                  -- mission rewards (table of strings)
    "ScriptEventTaoQianIntroductionMission03Complete",      -- trigger event 
    "ScriptEventTaoQianIntroductionMission04Complete"     -- completion event
)

-- tao qian introduction mission 05
start_tutorial_mission_listener(
    "3k_main_faction_tao_qian",                          -- faction key
    "3k_main_tutorial_mission_tao_qian_perform_assignment",                     -- mission key
    "PERFORM_ASSIGNMENT",                                  -- objective type
    nil,                                                  -- conditions (single string or table of strings)
    {
        "effect_bundle{bundle_key 3k_main_introduction_mission_payload_tao_qian;turns 3;}"
    },                                                  -- mission rewards (table of strings)
    "ScriptEventTaoQianIntroductionMission04Complete",      -- trigger event 
    "ScriptEventTaoQianIntroductionMission05Complete"     -- completion event
)

-- tao qian introduction mission 06
start_tutorial_mission_listener(
    "3k_main_faction_tao_qian",                          -- faction key
    "3k_main_tutorial_mission_tao_qian_reach_progression_rank",                     -- mission key
    "ATTAIN_FACTION_PROGRESSION_LEVEL",                                  -- objective type
    {
        "rank_marquis"
    },                                                  -- conditions (single string or table of strings)
    {
        "effect_bundle{bundle_key 3k_main_introduction_mission_payload_tao_qian;turns 6;}"
    },                                                  -- mission rewards (table of strings)
    "ScriptEventTaoQianIntroductionMission05Complete",      -- trigger event 
    "ScriptEventTaoQianIntroductionMission06Complete",     -- completion event
    function()
        if cm:query_faction("3k_main_faction_dong_zhuo"):is_dead() or progression.has_played_movie_fall_of_dong_zhuo == true then
            return true
        else
            return false
        end
    end,                                                -- precondition (nil, or a function that returns a boolean)
    "ScriptEventTaoQianIntroductionMission06Fail"       -- failure event
)

-- tao qian introduction mission 06a
start_tutorial_mission_listener(
    "3k_main_faction_tao_qian",                          -- faction key
    "3k_main_tutorial_mission_tao_qian_reach_progression_rank_dong_zhuo",                     -- mission key
    "ATTAIN_FACTION_PROGRESSION_LEVEL",                                  -- objective type
    {
        "rank_marquis"
    },                                                  -- conditions (single string or table of strings)
    {
        "effect_bundle{bundle_key 3k_main_introduction_mission_payload_tao_qian;turns 6;}"
    },                                                  -- mission rewards (table of strings)
    "ScriptEventTaoQianIntroductionMission06Fail",      -- trigger event 
    "ScriptEventTaoQianIntroductionMission06Complete"     -- completion event
)
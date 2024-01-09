-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
------------------------- liu chong Tutorial Missions ---------------------------
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
		"introduction_incident_tao_qian",
		"FactionTurnStart", 
		true,
		function(context)
			out.interventions(" ### Intro how to play incident triggered")
			cdir_events_manager:add_prioritised_incidents( context:faction():command_queue_index(), "3k_dlc04_main_introduction_liu_chong_incident" );
			cm:set_saved_value("start_incident_unlocked", true);
		end,
		false
    )
end

-- liu chong introduction mission 01
start_tutorial_mission_listener(
    "3k_dlc04_faction_prince_liu_chong",                          -- faction key
    "3k_dlc04_main_tutorial_liu_chong_defeat_army_mission",                     -- mission key
    "ENGAGE_FORCE",                                  -- objective type
    {
        "faction 3k_main_faction_yellow_turban_generic",
        "armies_only"
    },                                                  -- conditions (single string or table of strings)
    {
        "effect_bundle{bundle_key 3k_main_introduction_mission_payload_defeat_force;turns 3;}"
    },                                                  -- mission rewards (table of strings)
    "ScriptEventStartTutorialMissions",      -- trigger event 
    "ScriptEventLiuChongIntroductionMissionEngageForceComplete"     -- completion event
)


-- liu chong introduction mission 02
start_tutorial_mission_listener(
    "3k_dlc04_faction_prince_liu_chong",                          -- faction key
    "3k_dlc04_main_tutorial_liu_chong_recruit_units_mission",                     -- mission key
    "OWN_N_UNITS",                                  -- objective type
    {
        2
    },                                                  -- conditions (single string or table of strings)
    {
        "effect_bundle{bundle_key 3k_main_introduction_mission_payload_recruit_units;turns 3;}"
    },                                                  -- mission rewards (table of strings)
    "ScriptEventLiuChongIntroductionMissionEngageForceComplete",      -- trigger event 
    "ScriptEventLiuChongIntroductionMissionRecruitUnitsComplete"     -- completion event
)


-- liu chong introduction mission 05
start_tutorial_mission_listener(
    "3k_dlc04_faction_prince_liu_chong",                          -- faction key
    "3k_dlc04_main_tutorial_liu_chong_capture_settlement_mission",                     -- mission key
	"OWN_N_REGIONS_INCLUDING",                                  -- objective type
    {
        "total 1",
        "region 3k_main_chenjun_resource_3"
    },                                                  -- conditions (single string or table of strings)
    {
        "effect_bundle{bundle_key 3k_main_introduction_mission_payload_capture_regions;turns 3;}",
        "money 1000"
    },                                                  -- mission rewards (table of strings)
    "ScriptEventLiuChongIntroductionMissionRecruitUnitsComplete",      -- trigger event 
    "ScriptEventLiuChongIntroductionMissionCaptureRegionsComplete"     -- completion event
)


-- liu chong introduction mission 03
start_tutorial_mission_listener(
    "3k_dlc04_faction_prince_liu_chong",                          -- faction key
    "3k_dlc04_main_tutorial_liu_chong_equip_faction_ceo_mission",                     -- mission key
	"CEO_EQUIP_ACTIVE_ON_FACTION",                                  -- objective type
    {
        "ceo 3k_dlc04_ceo_factional_trophy_cabinet_melee_cav_common"
    },                                                  -- conditions (single string or table of strings)
    {
        "effect_bundle{bundle_key 3k_main_introduction_mission_payload_prince_liu_chong;turns 3;}",
        "money 1000"
    },                                                  -- mission rewards (table of strings)
    "ScriptEventLiuChongIntroductionMissionRecruitUnitsComplete",      -- trigger event 
    "ScriptEventLiuChongIntroductionMissionEquipCEOComplete"     -- completion event
)


-- liu chong introduction mission 04
start_tutorial_mission_listener(
    "3k_dlc04_faction_prince_liu_chong",                          -- faction key
    "3k_dlc04_main_tutorial_liu_chong_construct_building_mission",                     -- mission key
    "CONSTRUCT_ANY_BUILDING",                                  -- objective type
    nil,                                                  -- conditions (single string or table of strings)
    {
        "effect_bundle{bundle_key 3k_main_introduction_mission_payload_construct_building;turns 3;}"
    },                                                  -- mission rewards (table of strings)
    "ScriptEventLiuChongIntroductionMissionEquipCEOComplete",      -- trigger event 
    "ScriptEventLiuChongIntroductionMissionBuildBuildingComplete"     -- completion event
)


-- liu chong introduction mission 06
start_tutorial_mission_listener(
    "3k_dlc04_faction_prince_liu_chong",                          -- faction key
    "3k_dlc04_main_tutorial_liu_chong_perform_assignment_mission",                     -- mission key
    "PERFORM_ASSIGNMENT",                                  -- objective type
    nil,                                                  -- conditions (single string or table of strings)
    {
        "effect_bundle{bundle_key 3k_main_introduction_mission_payload_prince_liu_chong;turns 3;}"
    },                                                  -- mission rewards (table of strings)
    "ScriptEventLiuChongIntroductionMissionBuildBuildingComplete",      -- trigger event 
    "ScriptEventLiuChongIntroductionMissionPerformAssignmentComplete"     -- completion event
)


-- liu chong introduction mission 07
start_tutorial_mission_listener(
    "3k_dlc04_faction_prince_liu_chong",                          -- faction key
    "3k_dlc04_main_tutorial_liu_chong_reach_progression_rank_mission",                     -- mission key
    "ATTAIN_FACTION_PROGRESSION_LEVEL",                                  -- objective type
    {
        "rank_second_marquis"
    },                                                  -- conditions (single string or table of strings)
    {
        "effect_bundle{bundle_key 3k_main_introduction_mission_payload_prince_liu_chong;turns 6;}"
    },                                                  -- mission rewards (table of strings)
    "ScriptEventLiuChongIntroductionMissionCaptureRegionsComplete",      -- trigger event 
    "ScriptEventLiuChongIntroductionMissionSecondMarquisComplete",     -- completion event
    function()
        if cm:query_faction("3k_main_faction_dong_zhuo"):is_dead() or progression.has_played_movie_fall_of_dong_zhuo == true then
            return true
        else
            return false
        end
    end,                                                -- precondition (nil, or a function that returns a boolean)
    "ScriptEventLiuChongIntroductionMissionSecondMarquisDZFail"       -- failure event
)

-- liu chong introduction mission 07a
start_tutorial_mission_listener(
    "3k_dlc04_faction_prince_liu_chong",                          -- faction key
    "3k_dlc04_main_tutorial_liu_chong_reach_progression_rank_dong_zhuo_mission",                     -- mission key
    "ATTAIN_FACTION_PROGRESSION_LEVEL",                                  -- objective type
    {
        "rank_second_marquis"
    },                                                  -- conditions (single string or table of strings)
    {
        "effect_bundle{bundle_key 3k_main_introduction_mission_payload_prince_liu_chong;turns 6;}"
    },                                                  -- mission rewards (table of strings)
    "ScriptEventLiuChongIntroductionMissionSecondMarquisDZFail",      -- trigger event 
    "ScriptEventLiuChongIntroductionMissionSecondMarquisComplete"     -- completion event
)

-- cancel intro missions on faction rank up
start_tutorial_mission_cancel_listener(
    "3k_dlc04_faction_prince_liu_chong",
    {
        "3k_dlc04_main_tutorial_liu_chong_defeat_army_mission",
		"3k_dlc04_main_tutorial_liu_chong_capture_settlement_mission",
		"3k_dlc04_main_tutorial_liu_chong_recruit_units_mission",
		"3k_dlc04_main_tutorial_liu_chong_construct_building_mission",
		"3k_dlc04_main_tutorial_liu_chong_perform_assignment_mission",
		"3k_dlc04_main_tutorial_liu_chong_equip_faction_ceo_mission"
    },
    "ScriptEventLiuChongIntroductionMissionSecondMarquisComplete"
)
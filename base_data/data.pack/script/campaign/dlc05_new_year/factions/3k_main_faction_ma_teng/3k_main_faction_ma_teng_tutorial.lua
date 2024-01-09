-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
------------------------- Ma Teng Tutorial Missions ---------------------------
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
		"introduction_incident_ma_teng",
		"FactionTurnStart", 
		true,
		function(context)
			out.interventions(" ### Intro how to play incident triggered")
			cdir_events_manager:add_prioritised_incidents( context:faction():command_queue_index(), "3k_dlc05_introduction_ma_teng_incident" );
			cm:set_saved_value("start_incident_unlocked", true);
		end,
		false
    )
end

-- ma teng introduction mission 01
start_tutorial_mission_listener(
    "3k_main_faction_ma_teng",                          -- faction key
    "3k_dlc05_tutorial_mission_ma_teng_survival",                     -- mission key
    "REACH_SPECIFIED_DATE",                                  -- objective type
    {
		"year 196",
		"week_of_year 0"
    },                                                  -- conditions (single string or table of strings)
    {
        "money 1500"
    },                                                  -- mission rewards (table of strings)
    "ScriptEventStartTutorialMissions",      -- trigger event 
    "ScriptEventMaTengIntroductionMission196"     -- completion event
)

-- liu biao introduction mission 02
start_tutorial_mission_listener(
    "3k_main_faction_ma_teng",                          -- faction key
    "3k_dlc05_tutorial_mission_ma_teng_recruit_units",                     -- mission key
    "OWN_N_UNITS",                                  -- objective type
    {
        4       -- special case, just supply the number of units we want the player to recruit
    },                                                  -- conditions (single string or table of strings)
    {
        "effect_bundle{bundle_key 3k_main_introduction_mission_payload_recruit_units;turns 3;}"
    },                                                  -- mission rewards (table of strings)
    "ScriptEventStartTutorialMissions",      -- trigger event 
	"ScriptEventMaTengIntroductionMission01Complete",     -- completion event
	nil,
	"ScriptEventMaTengIntroductionMission01Complete",
	nil,
	25
)

-- liu biao introduction mission 03
start_tutorial_mission_listener(
    "3k_main_faction_ma_teng",                          -- faction key
    "3k_dlc05_tutorial_mission_ma_teng_construct_building",                     -- mission key
    "CONSTRUCT_ANY_BUILDING",                                  -- objective type
    {
    "region 3k_main_wudu_capital"                                            
    },                                                  -- conditions (single string or table of strings)
    {
       "effect_bundle{bundle_key 3k_main_introduction_mission_payload_construct_building;turns 3;}"
    },                                                  -- mission rewards (table of strings)
    "ScriptEventMaTengIntroductionMission01Complete",      -- trigger event 
	"ScriptEventMaTengIntroductionMission02Complete",     -- completion event
	nil,
	"ScriptEventMaTengIntroductionMission02Complete",
	nil,
	25
)

-- liu biao introduction mission 04
start_tutorial_mission_listener(
    "3k_main_faction_ma_teng",                          -- faction key
    "3k_dlc05_tutorial_mission_ma_teng_reach_progression_rank",                     -- mission key
    "ATTAIN_FACTION_PROGRESSION_LEVEL",                                  -- objective type
    {
        "total 1"
    },                                                  -- conditions (single string or table of strings)
    {
        "effect_bundle{bundle_key 3k_main_introduction_mission_payload_liu_biao;turns 6;}"
    },                                                  -- mission rewards (table of strings)
    "ScriptEventMaTengIntroductionMission02Complete",      -- trigger event 
	"ScriptEventMaTengIntroductionMission03Complete",     -- completion event
	nil,
	"ScriptEventMaTengIntroductionMission03Complete",
	nil,
	25
)

-- ma teng introduction mission 01a
start_tutorial_mission_listener(
    "3k_main_faction_ma_teng",                          -- faction key
    "3k_main_tutorial_mission_ma_teng_anding",                     -- mission key
    "OWN_N_REGIONS_INCLUDING",                                  -- objective type
    {
        "total 1",
		"region 3k_main_anding_capital"
    },                                                  -- conditions (single string or table of strings)
    {
       "effect_bundle{bundle_key 3k_main_introduction_mission_payload_capture_regions;turns 3;}"
    },                                                  -- mission rewards (table of strings)
    "ScriptEventMaTengIntroductionMission196",      -- trigger event 
	"ScriptEventMaTengIntroductionMission196finish",     -- completion event
	nil,
	"ScriptEventMaTengIntroductionMission196finish",
	nil,
	25
)
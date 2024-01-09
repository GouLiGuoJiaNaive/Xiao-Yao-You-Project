-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
------------------------- White Tiger Yan Tutorial Missions -------------------
-------------------------------------------------------------------------------
------------------------- Created by Craig: 27/08/2019 ------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

output("Introduction mission script loaded for " .. cm:get_local_faction());

function should_start_tutorial_missions()
	return not core:is_tweaker_set("FORCE_DISABLE_TUTORIAL");
end;

if not cm:get_saved_value("start_incident_unlocked") then 
    core:add_listener(
                "introduction_incident_yan_baihu",
                "FactionTurnStart", 
                true,
                function(context)
					out.interventions(" ### Intro how to play incident triggered")
					cdir_events_manager:add_prioritised_incidents( context:faction():command_queue_index(), "3k_dlc05_introduction_yan_baihu_incident" );
                    cm:set_saved_value("start_incident_unlocked", true);
                end,
                false
    )
end

-- yan baihu introduction mission 01
start_tutorial_mission_listener(
    "3k_dlc05_faction_white_tiger_yan",                          -- faction key
    "3k_dlc05_tutorial_mission_yan_baihu_capture_settlement",                     -- mission key
	"OWN_N_REGIONS_INCLUDING",                                  -- objective type
    {
        "total 1",
        "region 3k_main_poyang_resource_3"
    },                                                  -- conditions (single string or table of strings)
    {
        "effect_bundle{bundle_key 3k_main_introduction_mission_payload_capture_regions;turns 3;}"
    },                                                  -- mission rewards (table of strings)
    "ScriptEventStartTutorialMissions",      -- trigger event 
	"ScriptEventYanBaihuIntroductionMission01Complete",     -- completion event
	nil,													--precondition
	"ScriptEventYanBaihuIntroductionMission01Complete",		--failure event
	nil,													--mission issuer
	25														--turn limit
)

-- yan baihu introduction mission 02
start_tutorial_mission_listener(
    "3k_dlc05_faction_white_tiger_yan",                          -- faction key
    "3k_dlc05_tutorial_mission_yan_baihu_construct_building",                     -- mission key
    "CONSTRUCT_ANY_BUILDING",                                  -- objective type
    {
        "region 3k_main_xindu_capital"                                             -- conditions (single string or table of strings)
    },                                                  
    {
        "effect_bundle{bundle_key 3k_main_introduction_mission_payload_construct_building;turns 3;}"
    },                                                  -- mission rewards (table of strings)
    "ScriptEventYanBaihuIntroductionMission01Complete",      -- trigger event 
	"ScriptEventYanBaihuIntroductionMission02Complete",     -- completion event
	nil,
	"ScriptEventYanBaihuIntroductionMission02Complete",
	nil,
	25
)

-- yan baihu introduction mission 03
start_tutorial_mission_listener(
    "3k_dlc05_faction_white_tiger_yan",                          -- faction key
    "3k_dlc05_tutorial_mission_yan_baihu_recruit_units",                     -- mission key
    "OWN_N_UNITS",                                  -- objective type
    {
        2       -- special case, just supply the number of units we want the player to recruit
    },                                                  -- conditions (single string or table of strings)
    {
        "effect_bundle{bundle_key 3k_main_introduction_mission_payload_recruit_units;turns 3;}"
    },                                                  -- mission rewards (table of strings)
    "ScriptEventYanBaihuIntroductionMission02Complete",      -- trigger event 
	"ScriptEventYanBaihuIntroductionMission03Complete",     -- completion event
	nil,
	"ScriptEventYanBaihuIntroductionMission03Complete",
	nil,
	25
)

-- yan baihu introduction mission 04
start_tutorial_mission_listener(
    "3k_dlc05_faction_white_tiger_yan",                          -- faction key
    "3k_dlc05_tutorial_mission_yan_baihu_secure_province",                     -- mission key
    "OWN_N_REGIONS_INCLUDING",                                  -- objective type
    {
        "total 4",
		"region 3k_main_jianan_capital",
    },                                                  -- conditions (single string or table of strings)
    {
        "effect_bundle{bundle_key 3k_dlc05_introduction_mission_payload_yan_baihu;turns 3;}"
    },                                                  -- mission rewards (table of strings)
    "ScriptEventYanBaihuIntroductionMission03Complete",      -- trigger event 
	"ScriptEventYanBaihuIntroductionMission04Complete",     -- completion event
	nil,
	"ScriptEventYanBaihuIntroductionMission04Complete",
	nil,
	25
)

-- yan baihu introduction mission 05
start_tutorial_mission_listener(
    "3k_dlc05_faction_white_tiger_yan",                          -- faction key
    "3k_dlc05_tutorial_mission_yan_baihu_reach_progression_rank",                     -- mission key
    "ATTAIN_FACTION_PROGRESSION_LEVEL",                                  -- objective type
    {
        "total 2"
    },                                                  -- conditions (single string or table of strings)
    {
        "effect_bundle{bundle_key 3k_dlc05_introduction_mission_payload_yan_baihu;turns 6;}"
    },                                                  -- mission rewards (table of strings)
    "ScriptEventYanBaihuIntroductionMission04Complete",      -- trigger event 
	"ScriptEventYanBaihuIntroductionMission05Complete",     -- completion event
	nil,
	"ScriptEventYanBaihuIntroductionMission05Complete",
	nil,
	25
)
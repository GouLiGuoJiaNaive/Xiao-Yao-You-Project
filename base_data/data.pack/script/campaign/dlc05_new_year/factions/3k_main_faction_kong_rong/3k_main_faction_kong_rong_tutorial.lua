-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
------------------------- Kong Rong Tutorial Missions -------------------------
-------------------------------------------------------------------------------
------------------------- Created by Craig: 03/09/2019 ------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

output("Introduction mission script loaded for " .. cm:get_local_faction());

function should_start_tutorial_missions()
	return not core:is_tweaker_set("FORCE_DISABLE_TUTORIAL");
end;

if not cm:get_saved_value("start_incident_unlocked") then 
    core:add_listener(
                "introduction_incident_kong_rong",
                "FactionTurnStart", 
                true,
                function(context)
					out.interventions(" ### Intro how to play incident triggered")
					cdir_events_manager:add_prioritised_incidents( context:faction():command_queue_index(), "3k_dlc05_introduction_kong_rong_incident" );
                    cm:set_saved_value("start_incident_unlocked", true);
                end,
                false
    )
end

--this mission has been changed to a recruit units one
start_tutorial_mission_listener(
    "3k_main_faction_kong_rong",                          -- faction key
    "3k_dlc05_tutorial_mission_kong_rong_defeat_army",                     -- mission key
    "OWN_N_UNITS",                                  -- objective type
    {
        5       -- special case, just supply the number of units we want the player to recruit
    },                                                  -- conditions (single string or table of strings)
    {
        "effect_bundle{bundle_key 3k_main_introduction_mission_payload_recruit_units;turns 3;}"
    },                                                  -- mission rewards (table of strings)
    "ScriptEventStartTutorialMissions",      -- trigger event 
	"ScriptEventKongRongIntroductionMissionEconomyStart",     -- completion event
	nil,
	"ScriptEventKongRongIntroductionMissionEconomyStart",
	nil,
	25
)

start_tutorial_mission_listener(
    "3k_main_faction_kong_rong",                          -- faction key
    "3k_dlc05_tutorial_mission_kong_rong_income_increase",                     -- mission key
    "INCOME_AT_LEAST_X",                                  -- objective type
    {
      "income 1500"
    },                                                  -- conditions (single string or table of strings)
    {
        "effect_bundle{bundle_key 3k_main_historical_mission_payload_02;turns 5;}"
    },                                                  -- mission rewards (table of strings)
    "ScriptEventKongRongIntroductionMissionEconomyStart",      -- trigger event 
	"ScriptEventKongRongIntroductionMission01Complete",     -- completion event
	nil,
	"ScriptEventKongRongIntroductionMission01Complete",
	nil,
	25
)


-- kong rong introduction mission 01
start_tutorial_mission_listener(
    "3k_main_faction_kong_rong",                          -- faction key
    "3k_dlc05_tutorial_mission_kong_rong_capture_settlement",                     -- mission key
	"OWN_N_REGIONS_INCLUDING",                                  -- objective type
    {
        "total 2",
        "region 3k_main_taishan_resource_1",
		"region 3k_main_taishan_capital",
    },                                                  -- conditions (single string or table of strings)
    {
        "effect_bundle{bundle_key 3k_main_introduction_mission_payload_capture_regions;turns 3;}"
    },                                                  -- mission rewards (table of strings)
    "ScriptEventKongRongIntroductionMission01Complete",      -- trigger event 
	"ScriptEventKongRongIntroductionMission02Complete",     -- completion event
	nil,
	"ScriptEventKongRongIntroductionMission02Complete",
	nil,
	25
)

-- kong rong introduction mission 02
start_historical_mission_listener(
    "3k_main_faction_kong_rong",                          -- faction key
    "3k_dlc05_tutorial_mission_kong_rong_destroy_yuan_tan",                    -- mission key
    "DESTROY_FACTION",                                  -- objective type
    {
        "faction 3k_dlc05_faction_yuan_tan"
    },                                                  -- conditions (single string or table of strings)
    {
        "effect_bundle{bundle_key 3k_main_historical_mission_payload_01;turns 5;}"
    },                                                  -- mission rewards (table of strings)
    "ScriptEventKongRongIntroductionMission02Complete",      -- trigger event 
	"ScriptEventKongRongIntroductionMission03Complete",      -- completion event
	nil,
	"ScriptEventKongRongIntroductionMission03Complete",
	nil,
	25
)


-- kong rong introduction mission 03
start_historical_mission_listener(
    "3k_main_faction_kong_rong",                          -- faction key
    "3k_dlc05_tutorial_mission_kong_rong_destroy_yuan_shao",                    -- mission key
    "DESTROY_FACTION",                                  -- objective type
    {
        "faction 3k_main_faction_yuan_shao"
    },                                                  -- conditions (single string or table of strings)
    {
        "effect_bundle{bundle_key 3k_main_historical_mission_payload_01;turns 5;}"
    },                                                  -- mission rewards (table of strings)
    "ScriptEventKongRongIntroductionMission03Complete",      -- trigger event 
	"ScriptEventKongRongIntroductionMission04Complete",      -- completion event
	function()
		return not cm:query_faction("3k_main_faction_yuan_shao"):is_dead()
	end,
	"ScriptEventKongRongIntroductionMission04Complete",
	nil,
	25
)
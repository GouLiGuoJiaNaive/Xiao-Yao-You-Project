-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
------------------------- Zheng Jiang Tutorial Missions -----------------------
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
                "introduction_incident_zheng_jiang",
                "FactionTurnStart", 
                true,
                function(context)
                    out.interventions(" ### Intro how to play incident triggered")
					cdir_events_manager:add_prioritised_incidents( context:faction():command_queue_index(), "3k_dlc05_introduction_zheng_jiang_incident" );
                    cm:set_saved_value("start_incident_unlocked", true);
                end,
                false
    )
end

core:add_listener(
	"zheng_jiang_high_prestige_mission_autocomplete",
	"MissionIssued",
	function(context)
		if context:faction():name() == "3k_main_faction_zheng_jiang" and context:mission():mission_record_key() == "3k_dlc05_tutorial_mission_zheng_jiang_reach_progression_rank" then
			if cm:query_faction("3k_main_faction_zheng_jiang"):progression_level() >= 2 then
				return true
			end
		end
	end,
	function(context)
		cm:modify_faction("3k_main_faction_zheng_jiang"):complete_custom_mission("3k_dlc05_tutorial_mission_zheng_jiang_reach_progression_rank")
		core:remove_listener("zheng_jiang_high_prestige_mission_autocomplete")
	end,
	true
)

-- zheng jiang introduction mission 01
start_tutorial_mission_listener(
    "3k_main_faction_zheng_jiang",                          -- faction key
    "3k_dlc05_tutorial_mission_zheng_jiang_defeat_army",                     -- mission key
    "ENGAGE_FORCE",                                  -- objective type
    {
        "faction 3k_dlc05_faction_zang_ba",
        "armies_only"
    },                                                  -- conditions (single string or table of strings)
    {
        "effect_bundle{bundle_key 3k_main_introduction_mission_payload_defeat_force;turns 3;}"
    },                                                  -- mission rewards (table of strings)
    "ScriptEventStartTutorialMissions",      -- trigger event 
	"ScriptEventZhengJiangIntroductionMission01Complete",     -- completion event
	nil,
	"ScriptEventZhengJiangIntroductionMission01Complete",
	nil,
	25
)

-- zheng jiang introduction mission 02
start_tutorial_mission_listener(
    "3k_main_faction_zheng_jiang",                          -- faction key
    "3k_dlc05_tutorial_mission_zheng_jiang_capture_settlement",                     -- mission key
	"OWN_N_REGIONS_INCLUDING",                                  -- objective type
    {
        "total 2",
		"region 3k_main_dongjun_resource_1",
		"region 3k_main_penchang_resource_1"
    },                                                  -- conditions (single string or table of strings)
    {
        "effect_bundle{bundle_key 3k_main_introduction_mission_payload_capture_regions;turns 3;}"
    },                                                  -- mission rewards (table of strings)
    "ScriptEventZhengJiangIntroductionMission01Complete",      -- trigger event 
	"ScriptEventZhengJiangIntroductionMission02Complete",     -- completion event
	nil,
	"ScriptEventZhengJiangIntroductionMission02Complete",
	nil,
	25
)

-- zheng jiang introduction mission 03
start_tutorial_mission_listener(
    "3k_main_faction_zheng_jiang",                          -- faction key
    "3k_dlc05_tutorial_mission_zheng_jiang_construct_building",                     -- mission key
    "CONSTRUCT_ANY_BUILDING",                                  -- objective type
    nil,                                            -- conditions (single string or table of strings)     
    {
        "effect_bundle{bundle_key 3k_main_introduction_mission_payload_construct_building;turns 3;}"
    },                                                  -- mission rewards (table of strings)
    "ScriptEventZhengJiangIntroductionMission02Complete",      -- trigger event 
	"ScriptEventZhengJiangIntroductionMission03Complete",     -- completion event
	nil,
	"ScriptEventZhengJiangIntroductionMission03Complete",
	nil,
	25
)

-- zheng jiang introduction mission 04
start_tutorial_mission_listener(
    "3k_main_faction_zheng_jiang",                          -- faction key
    "3k_dlc05_tutorial_mission_zheng_jiang_reach_progression_rank",                     -- mission key
    "ATTAIN_FACTION_PROGRESSION_LEVEL",                                  -- objective type
    {
		"total 2"
    },                                                  -- conditions (single string or table of strings)
    {
        "effect_bundle{bundle_key 3k_main_introduction_mission_payload_zheng_jiang;turns 3;}"
    },                                                  -- mission rewards (table of strings)
    "ScriptEventZhengJiangIntroductionMission03Complete",      -- trigger event 
	"ScriptEventZhengJiangIntroductionMission04Complete",     -- completion event
	nil,
	"ScriptEventZhengJiangIntroductionMission04Complete",
	nil,
	25
)
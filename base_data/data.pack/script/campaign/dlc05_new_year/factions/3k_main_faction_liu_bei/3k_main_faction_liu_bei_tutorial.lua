-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
------------------------- Liu Bei Tutorial Missions ---------------------------
-------------------------------------------------------------------------------
------------------------- Created by Craig: 30/09/2019 ------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

output("Introduction mission script loaded for " .. cm:get_local_faction());

function should_start_tutorial_missions()
	return not core:is_tweaker_set("FORCE_DISABLE_TUTORIAL");
end;

if not cm:get_saved_value("start_incident_unlocked") then 
    core:add_listener(
                "introduction_incident_liu_bei",
                "FactionTurnStart", 
                true,
                function(context)
					out.interventions(" ### Intro how to play incident triggered")
					cdir_events_manager:add_prioritised_incidents( context:faction():command_queue_index(), "3k_dlc05_introduction_liu_bei_incident" );
                    cm:set_saved_value("start_incident_unlocked", true);
                end,
                false
    )
end

-- liu bei introduction mission 01
start_tutorial_mission_listener(
    "3k_main_faction_liu_bei",                          -- faction key
    "3k_dlc05_tutorial_mission_liu_bei_defeat_army",                     -- mission key
    "ENGAGE_FORCE",                                  -- objective type
    {
        "faction 3k_dlc05_faction_zang_ba",
        "armies_only"
    },                                                  -- conditions (single string or table of strings)
    {
        "effect_bundle{bundle_key 3k_main_introduction_mission_payload_defeat_force;turns 3;}"
    },                                                  -- mission rewards (table of strings)
    "ScriptEventStartTutorialMissions",      -- trigger event 
	"ScriptEventKongRongIntroductionMission01Complete",     -- completion event
	nil,
	"ScriptEventKongRongIntroductionMission01Complete",
	nil,
	25
)

-- liu bei introduction mission 02
start_tutorial_mission_listener(
    "3k_main_faction_liu_bei",                          -- faction key
    "3k_dlc05_tutorial_mission_liu_bei_capture_settlement",                     -- mission key
	"OWN_N_REGIONS_INCLUDING",                                  -- objective type
    {
        "total 2",
        "region 3k_main_penchang_resource_1",
		"region 3k_main_dongjun_resource_1",
    },                                                  -- conditions (single string or table of strings)
    {
        "effect_bundle{bundle_key 3k_main_introduction_mission_payload_capture_regions;turns 3;}"
    },                                                  -- mission rewards (table of strings)
    "ScriptEventKongRongIntroductionMission01Complete",      -- trigger event 
	"ScriptEventKongRongIntroductionMission03Complete",     -- completion event
	nil,
	"ScriptEventKongRongIntroductionMission03Complete",
	nil,
	25
)

-- kong rong introduction mission 02
start_historical_mission_listener(
    "3k_main_faction_liu_bei",                          -- faction key
    "3k_dlc05_tutorial_mission_liu_bei_destroy_yuan_shu",                    -- mission key
    "DESTROY_FACTION",                                  -- objective type
    {
        "faction 3k_main_faction_yuan_shu"
    },                                                  -- conditions (single string or table of strings)
    {
        "effect_bundle{bundle_key 3k_main_historical_mission_payload_01;turns 5;}"
    },                                                  -- mission rewards (table of strings)
    "ScriptEventKongRongIntroductionMission03Complete",      -- trigger event 
    "ScriptEventKongRongIntroductionMission05Complete",     -- completion event
    function()
        if not cm:query_faction("3k_main_faction_yuan_shu"):is_dead() then
            return true
        end
    end,  -- precondition (nil, or a function that returns a boolean)
	"ScriptEventKongRongIntroductionMission05Complete", -- failure event
	nil,
	25
)
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
------------------------ sun ce Progression Missions -------------------------
-------------------------------------------------------------------------------
------------------------ Created by Leif: 21/11/2018 --------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

output("Progression mission script loaded for " .. cm:get_local_faction());

sun_ce_progression = {};

-- OWN_N_REGIONS_INCLUDING
-- CAPTURE_REGIONS
-- CONTROL_N_PROVINCES_INCLUDING
-- CONTROL_N_REGIONS_INCLUDING
-- BE_AT_WAR_WITH_N_FACTIONS       -- db, total, faction_record, religion_record
-- BE_AT_WAR_WITH_FACTION          -- db, faction_record
-- CONFEDERATE_FACTIONS             -- db, total, faction_record

if not cm:get_saved_value("progression_mission_launched") then
    core:add_listener(
        "start_progression_missions",
        "ScriptEventLocalPlayerFactionTurnStart",
        function(context)
            return context:faction():region_list():num_items() >= 5
        end,
        function()
            core:trigger_event("ScriptEventSunCeProgressionMission01Trigger")
            --core:remove_listener("start_historical_missions");
            cm:set_saved_value("progression_mission_launched", true);
        end,
        false
    )
end

--Around turn 25 and the player has 12 or more regions or if Sun Ce is at war with Huang Zu, if Huang Zu or his faction isn't dead. Trigger Sun Ce's vengence mission. 
if not cm:get_saved_value("vengence_mission_launched") then
    core:add_listener(
        "vengence_mission_missions",
        "FactionTurnEnd",
        function(context)
            return (200<=context:query_model():calendar_year() and 12<=cm:query_faction("3k_dlc05_faction_sun_ce"):region_list():num_items() or 
                (cm:query_faction("3k_dlc05_faction_sun_ce"):has_specified_diplomatic_deal_with("treaty_components_war",cm:query_faction("3k_main_faction_huang_zu"))))
        end,
        function()
            core:trigger_event("ScriptEventSunCeVengenceMission")
            cm:set_saved_value("vengence_mission_launched", true);
        end,
        false
    )
end

-- sun ce progression mission 01
start_historical_mission_db_listener(
	"3k_dlc05_faction_sun_ce",                          -- faction key
    "3k_dlc05_victory_objective_chain_0_sun_ce",               -- mission key
    "ScriptEventSunCeProgressionMission01Trigger",      -- trigger event 
    "ScriptEventSunCeProgressionMission01Complete"     -- completion event
);

-- sun ce progression mission 02
start_progression_mission_listener(
    "3k_dlc05_faction_sun_ce",                          -- faction key
    "3k_dlc05_victory_objective_chain_1_sun_ce",                     -- mission key
    "ATTAIN_FACTION_PROGRESSION_LEVEL",                                  -- objective type
    {
        "total 3"
    },                                                  -- conditions (single string or table of strings)
    {
        "money 2000"
    },                                                  -- mission rewards (table of strings)
    "ScriptEventSunCeProgressionMission01Complete",      -- trigger event 
    "ScriptEventSunCeProgressionMission02Complete"     -- completion event
)

-- sun ce progression mission 03
start_progression_mission_listener(
    "3k_dlc05_faction_sun_ce",                          -- faction key
    "3k_main_victory_objective_chain_2_han_warlords",                    -- mission key
    "BECOME_WORLD_LEADER",                                  -- objective type
    nil,                                                    -- conditions (single string or table of strings)
    {
        "money 5000"
    },                                                  -- mission rewards (table of strings)
    "ScriptEventSunCeProgressionMission02Complete",      -- trigger event 
    "ScriptEventSunCeProgressionMission03Complete"      -- completion event
)

-- sun ce progression mission 04
start_progression_mission_listener(
    "3k_dlc05_faction_sun_ce",                          -- faction key
    "3k_main_victory_objective_chain_3_han",                     -- mission key
    "DESTROY_ALL_WORLD_LEADERS",                                  -- objective type
    nil,                                                -- conditions (single string or table of strings)
    {
        "money 10000"
    },                                                  -- mission rewards (table of strings)
    "ScriptEventSunCeProgressionMission03Complete",      -- trigger event 
    "ScriptEventSunCeProgressionMission04Complete"     -- completion event
)

--sun ce progression mission 05
start_progression_mission_listener(
    "3k_dlc05_faction_sun_ce",                          -- faction key
    "3k_main_victory_objective_chain_4",                     -- mission key
    "CONTROL_N_REGIONS_INCLUDING",                                  -- objective type
    {
        "total 95"
    }, 
    {
        "money 10000"
    },                                                  -- mission rewards (table of strings)
    "ScriptEventSunCeProgressionMission04Complete",      -- trigger event 
    "ScriptEventSunCeProgressionMission05Complete"
)

core:add_listener(
    "start_progression_missions",
    "ScriptEventSunCeHistoricalMission01Complete",
    true,
    function()
        core:trigger_event("ScriptEventSunCeProgressionMission01Trigger")
    end,
    false
);
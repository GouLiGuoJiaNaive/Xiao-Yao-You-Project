-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
------------------------- Sun Ce Missions -------------------------
-------------------------------------------------------------------------------
------------------------- Created by Jakob: 29/08/2019 --------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

output("Introduction mission script loaded for " .. cm:get_local_faction());

local sun_ce_faction_key = "3k_dlc05_faction_sun_ce";

function should_start_tutorial_missions()
	return not core:is_tweaker_set("FORCE_DISABLE_TUTORIAL");
end;

if not cm:get_saved_value("start_incident_unlocked") then 
    core:add_listener(
                "introduction_incident_sun_ce",
                "FactionTurnStart", 
                true,
                function(context)
					out.interventions(" ### Intro how to play incident triggered")
					cdir_events_manager:add_prioritised_incidents( context:faction():command_queue_index(), "3k_dlc05_introduction_sun_ce_incident" );
                    cm:set_saved_value("start_incident_unlocked", true);
                end,
                false
    )
end

--Function that moves character to a faction's court
function move_character_to_court(character,faction,modify_model)
	if not character:is_null_interface() then
        if(not character:is_dead()) then
            modify_model:get_modify_character(character):set_is_deployable(true)
            modify_model:get_modify_character(character):move_to_faction_and_make_recruited(faction)
            --modify_model:get_modify_character(character):move_to_faction(faction)
        end
    end
end;

--If the player picks the diplomacy or dilemma option to go to war with Yuan Shu. Check which missions to skip, but give him the men
function missions_to_skip()
    --If mission compleation haven't been saved, give Sun Ce his men and skip missions. 
    if not cm:saved_value_exists("SunCeMission1", "SunCeMissions") then
        cm:cancel_custom_mission(sun_ce_faction_key, "3k_dlc05_objective_sun_ce_01")
        core:remove_listener("historical_mission_listener_3k_dlc05_faction_sun_ce_3k_dlc05_objective_sun_ce_01")
        core:trigger_event("ScriptEventSunCeIntroductionMission01Complete")
    end
    if not cm:saved_value_exists("SunCeMission2", "SunCeMissions")  then
        cm:cancel_custom_mission(sun_ce_faction_key, "3k_dlc05_objective_sun_ce_02")
        core:remove_listener("historical_mission_listener_3k_dlc05_faction_sun_ce_3k_dlc05_objective_sun_ce_02")
        core:trigger_event("ScriptEventSunCeIntroductionMission02Complete")
    end
    cm:set_saved_value("SunCecIntroMissionsSkipped", true,"SunCeMissions")
end;

-- MOVE CHARACTERS TO FACTION WHEN MISSION IS COMPLETE --

    --MISSION 4b HAS BEEN COMPLETE, IF LU MENG IS TOO YOUNG, MAKE HIM SPAWN LATER WHEN 196 STARTS
    core:add_listener(
	"FactionTurnStartLuMeng", -- Unique handle
	"FactionTurnStart", -- Campaign Event to listen for
    function(context)
		return context:faction():name() == sun_ce_faction_key
		and cm:saved_value_exists("Mission4bDone", "SunCeMissions") and cm:get_saved_value("Mission4bDone", "SunCeMissions")
		and cm:query_faction(sun_ce_faction_key):is_human() and not context:query_model():date_in_range(0,195)
	end,
    function(context) -- What to do if listener fires.
        --MOVE/SPAWN LU MENG TO SUN CE's FACTION
        local characterToFind = cm:query_model():character_for_template("3k_main_template_historical_lu_meng_hero_metal")
        if not characterToFind:is_null_interface() then
            if not characterToFind:faction():is_human() and not characterToFind:faction():name()==sun_ce_faction_key then
                move_character_to_court(characterToFind,sun_ce_faction_key,context:modify_model())
            end					
		else
            if not context:query_model():date_in_range(0,195) then
                cdir_events_manager:spawn_character_subtype_template_in_faction(sun_ce_faction_key, "3k_general_metal", "3k_main_template_historical_lu_meng_hero_metal");
            end
        end
	end,
	false --Is persistent
    );

    --MISSION 1 HAS BEEN COMPLETE, FATHERS GENNERALS JOIN THE COURT
    core:add_listener(
	"MissionSucceededSunCeFathersGennerals", -- Unique handle
	"MissionSucceeded", -- Campaign Event to listen for
	function(context)
		return (context:faction():name()==sun_ce_faction_key
		and context:mission():mission_record_key()=="3k_dlc05_objective_sun_ce_01"
		and context:query_model():world():faction_by_key(sun_ce_faction_key):is_human())
	end,
    function(context) -- What to do if listener fires.
        --MOVE HUANG GAI TO SUN CE's FACTION
        local characterToFind = context:query_model():character_for_template("3k_cp01_template_historical_huang_gai_hero_fire")
        move_character_to_court(characterToFind,sun_ce_faction_key,context:modify_model())
        --MOVE CHENG PU TO SUN CE's FACTION
        characterToFind = context:query_model():character_for_template("3k_main_template_historical_cheng_pu_hero_metal")
        move_character_to_court(characterToFind,sun_ce_faction_key,context:modify_model())
        --MOVE HAN DANG TO SUN CE's FACTION
        characterToFind = context:query_model():character_for_template("3k_main_template_historical_han_dang_hero_fire")
        move_character_to_court(characterToFind,sun_ce_faction_key,context:modify_model())
        --SET SAVED VALUE        
		cm:set_saved_value("SunCeMission1", true,"SunCeMissions")
	end,
	false --Is persistent
    );

	--MISSION 2 HAS BEEN COMPLETE, ZHOU JOINS THE FIGHT WITH HIS ARMY
	core:add_listener(
    "MissionSucceededSunCeZhouYu", -- Unique handle
    "MissionSucceeded", -- Campaign Event to listen for
	function(context)
		return (context:faction():name()==sun_ce_faction_key 
		and context:mission():mission_record_key()=="3k_dlc05_objective_sun_ce_02"
		and context:query_model():world():faction_by_key(sun_ce_faction_key):is_human())
    end,
	function(context) -- What to do if listener fires.
        --MOVE ZHOU YU TO SUN CE's FACTION
        local characterToFind = context:query_model():character_for_template("3k_main_template_historical_zhou_yu_hero_water")
        move_character_to_court(characterToFind,sun_ce_faction_key,context:modify_model())

        --IF POSSIBLE, CREATE ZHOU YU'S ARMY
        if not characterToFind:is_null_interface() then
            if(not characterToFind:is_dead()) then
                -- Check if player has deployed less than three generals
                local number_of_deployed_generals = 0
                for m = 0,context:faction():military_force_list():num_items() - 1 do
                    local military_force = context:faction():military_force_list():item_at(m)
                    if not military_force:general_character():is_null_interface() then
                        local military_force_character = military_force:general_character()
                        if string.match(military_force_character:generation_template_key(),"hero_") or string.match(military_force_character:generation_template_key(),"general_") then
                            number_of_deployed_generals = number_of_deployed_generals+1
                        end
                    end
                end                
                if (number_of_deployed_generals<3) then 
                    local unit_list = ""
                    local position_x_character = context:faction():faction_leader():logical_position_x()
                    local position_y_character = context:faction():faction_leader():logical_position_y()
                    cm:create_force_with_existing_general(characterToFind:cqi(), sun_ce_faction_key, unit_list, context:faction():faction_leader():region():name(), (position_x_character-5), (position_y_character), "141",function(cqi) cm:force_created(cqi, true, true, true) end, 100);	    
                end
            end 
        end
        --MOVE ZHOU YU TO SUN CE's FACTION
        local characterToFind = context:query_model():character_for_template("3k_main_template_historical_zhou_yu_hero_water")
        move_character_to_court(characterToFind,sun_ce_faction_key,context:modify_model())      
        --SET SAVED VALUE        
        cm:set_saved_value("SunCeMission2", true,"SunCeMissions")
        --Removes listerns
        --core:remove_listener("DilemmaChoiceMadeEventSunCeYuanShu")
        --core:remove_listener("DiplomacyDealNegotiatedSunCeYuanShu")
	end,
    false --Is persistent
      );

    --MISSION 3 HAS BEEN COMPLETE, LU FAN JOIN THE COURT
    core:add_listener(
	"MissionSucceededSunCeLuFan", -- Unique handle
	"MissionSucceeded", -- Campaign Event to listen for
	function(context)
		return (context:faction():name()==sun_ce_faction_key
		and context:mission():mission_record_key()=="3k_dlc05_objective_sun_ce_03"
		and context:query_model():world():faction_by_key(sun_ce_faction_key):is_human())
	end,
    function(context) -- What to do if listener fires.        
        --MOVE LU FAN TO SUN CE's FACTION
        local characterToFind = context:query_model():character_for_template("3k_main_template_historical_lu_fan_hero_water")
        move_character_to_court(characterToFind,sun_ce_faction_key,context:modify_model())
	end,
	false --Is persistent
    );

    --MISSION 4 HAS BEEN COMPLETE, ZHANG HONG and ZHANG ZHAO JOIN THE COURT
    core:add_listener(
	"MissionSucceededSunCeTwoZhangs", -- Unique handle
	"MissionSucceeded", -- Campaign Event to listen for
	function(context)
		return (context:faction():name()==sun_ce_faction_key
		and context:mission():mission_record_key()=="3k_dlc05_objective_sun_ce_04"
		and context:query_model():world():faction_by_key(sun_ce_faction_key):is_human())
	end,
	function(context) -- What to do if listener fires.
        --MOVE ZHANG HONG TO SUN CE's FACTION
        local characterToFind = context:query_model():character_for_template("3k_main_template_historical_zhang_hong_hero_water")
        move_character_to_court(characterToFind,sun_ce_faction_key,context:modify_model())		
        --MOVE ZHANG ZHAO TO SUN CE's FACTION
        local characterToFind = context:query_model():character_for_template("3k_main_template_historical_zhang_zhao_hero_water")
        move_character_to_court(characterToFind,sun_ce_faction_key,context:modify_model())
	end,
	false --Is persistent
    );

    --MISSION 4a HAS BEEN COMPLETE, TAISHI CHI JOIN THE COURT
    core:add_listener(
	"MissionSucceededSunCeTaishiCi", -- Unique handle
	"MissionSucceeded", -- Campaign Event to listen for
	function(context)
		return (context:faction():name()==sun_ce_faction_key
		and context:mission():mission_record_key()=="3k_dlc05_objective_sun_ce_04a"
		and context:query_model():world():faction_by_key(sun_ce_faction_key):is_human())
	end,
	function(context) -- What to do if listener fires.
        --MOVE TAISHI CI TO SUN CE's FACTION
        local characterToFind = context:query_model():character_for_template("3k_main_template_historical_taishi_ci_hero_metal")
        move_character_to_court(characterToFind,sun_ce_faction_key,context:modify_model())
	end,
	false --Is persistent
    );

    --MISSION 4b HAS BEEN COMPLETE, LU MENG JOIN THE COURT
    core:add_listener(
	"MissionSucceededSunCeLuMeng", -- Unique handle
	"MissionSucceeded", -- Campaign Event to listen for
    function(context)
		return (context:faction():name()==sun_ce_faction_key
		and context:mission():mission_record_key()=="3k_dlc05_objective_sun_ce_04b"
		and context:query_model():world():faction_by_key(sun_ce_faction_key):is_human())
	end,
    function(context) -- What to do if listener fires.        
        --MOVE/SPAWN LU MENG TO SUN CE's FACTION
        local characterToFind = context:query_model():character_for_template("3k_main_template_historical_lu_meng_hero_metal")
        if not characterToFind:is_null_interface() then
            if not characterToFind:faction():is_human() then
                move_character_to_court(characterToFind,sun_ce_faction_key,context:modify_model())
            end					
		else
            if not context:query_model():date_in_range(0,195) then
                cdir_events_manager:spawn_character_subtype_template_in_faction(sun_ce_faction_key, "3k_general_metal", "3k_main_template_historical_lu_meng_hero_metal");
            end
        end
        cm:set_saved_value("Mission4bDone", true,"SunCeMissions")
	end,
	false --Is persistent
    );

    --MISSION 5 HAS BEEN COMPLETE, YU FAN JOIN THE COURT
    core:add_listener(
	"MissionSucceededSunCeYuFan", -- Unique handle
	"MissionSucceeded", -- Campaign Event to listen for
	function(context)
		return (context:faction():name()==sun_ce_faction_key
		and context:mission():mission_record_key()=="3k_dlc05_objective_sun_ce_05"
		and context:query_model():world():faction_by_key(sun_ce_faction_key):is_human())
	end,
    function(context) -- What to do if listener fires.        
        --MOVE YU FAN TO SUN CE's FACTION
        local characterToFind = context:query_model():character_for_template("3k_main_template_historical_yu_fan_hero_water")
        move_character_to_court(characterToFind,sun_ce_faction_key,context:modify_model()) 
	end,
	false --Is persistent
    );

    --MISSION 1 HAS FAILED, FATHERS GENNERALS JOIN THE COURT
    core:add_listener(
	"MissionCancelledSunCeFathersGennerals", -- Unique handle
	"MissionCancelled", -- Campaign Event to listen for
    function(context)
		return (context:faction():name()==sun_ce_faction_key
		and context:mission():mission_record_key()=="3k_dlc05_objective_sun_ce_01"
		and context:query_model():world():faction_by_key(sun_ce_faction_key):is_human())
	end,
	function(context) -- What to do if listener fires.		
        --MOVE HUANG GAI TO SUN CE's FACTION
        local characterToFind = context:query_model():character_for_template("3k_cp01_template_historical_huang_gai_hero_fire")
        move_character_to_court(characterToFind,sun_ce_faction_key,context:modify_model())
        --MOVE CHENG PU TO SUN CE's FACTION
        characterToFind = context:query_model():character_for_template("3k_main_template_historical_cheng_pu_hero_metal")
        move_character_to_court(characterToFind,sun_ce_faction_key,context:modify_model())
        --MOVE HAN DANG TO SUN CE's FACTION
        characterToFind = context:query_model():character_for_template("3k_main_template_historical_han_dang_hero_fire")
        move_character_to_court(characterToFind,sun_ce_faction_key,context:modify_model())
	end,
	false --Is persistent
    );

    --MISSION 2 HAS FAILED, ZHOU YU JOINS
    core:add_listener(
	"MissionCancelledSunCeZhouYu", -- Unique handle
	"MissionCancelled", -- Campaign Event to listen for
    function(context)
		return (context:faction():name()==sun_ce_faction_key
		and context:mission():mission_record_key()=="3k_dlc05_objective_sun_ce_02"
		and context:query_model():world():faction_by_key(sun_ce_faction_key):is_human())
	end,
	function(context) -- What to do if listener fires.
		--MOVE ZHOU YU TO SUN CE's FACTION
        local characterToFind = context:query_model():character_for_template("3k_main_template_historical_zhou_yu_hero_water")
        move_character_to_court(characterToFind,sun_ce_faction_key,context:modify_model())

        --IF POSSIBLE, CREATE ZHOU YU'S ARMY
        if not characterToFind:is_null_interface() then
            if(not characterToFind:is_dead()) then
                -- Check if player has deployed less than three generals
                local number_of_deployed_generals = 0
                for m = 0,context:faction():military_force_list():num_items() - 1 do
                    local military_force = context:faction():military_force_list():item_at(m)
                    if not military_force:general_character():is_null_interface() then
                        local military_force_character = military_force:general_character()
                        if string.match(military_force_character:generation_template_key(),"hero_") or string.match(military_force_character:generation_template_key(),"general_") then
                            number_of_deployed_generals = number_of_deployed_generals+1
                        end
                    end
                end                
                if (number_of_deployed_generals<3) then 
                    local unit_list = ""
                    local position_x_character = context:faction():faction_leader():logical_position_x()
                    local position_y_character = context:faction():faction_leader():logical_position_y()
                    cm:create_force_with_existing_general(characterToFind:cqi(), sun_ce_faction_key, unit_list, context:faction():faction_leader():region():name(), (position_x_character-5), (position_y_character), "141",function(cqi) cm:force_created(cqi, true, true, true) end, 100);	    
                end
            end 
        end
        --MOVE ZHOU YU TO SUN CE's FACTION
        local characterToFind = context:query_model():character_for_template("3k_main_template_historical_zhou_yu_hero_water")
        move_character_to_court(characterToFind,sun_ce_faction_key,context:modify_model())  
	end,
	false --Is persistent
    );

    --MISSION 3 HAS FAILED, LU FAN JOINS
    core:add_listener(
	"MissionCancelledLuFan", -- Unique handle
	"MissionCancelled", -- Campaign Event to listen for
    function(context)
		return (context:faction():name()==sun_ce_faction_key
		and context:mission():mission_record_key()=="3k_dlc05_objective_sun_ce_03"
		and context:query_model():world():faction_by_key(sun_ce_faction_key):is_human())
	end,
	function(context) -- What to do if listener fires.		
        --MOVE LU FAN TO SUN CE's FACTION
        local characterToFind = context:query_model():character_for_template("3k_main_template_historical_lu_fan_hero_water")
        move_character_to_court(characterToFind,sun_ce_faction_key,context:modify_model())
	end,
	false --Is persistent
    );

    --MISSION 4 HAS FAILED, ZHANG HONG AND ZHANG ZHAO JOIN THE COURT
    core:add_listener(
	"MissionCancelledZhangHongZhangZhao", -- Unique handle
	"MissionCancelled", -- Campaign Event to listen for
    function(context)
		return (context:faction():name()==sun_ce_faction_key
		and context:mission():mission_record_key()=="3k_dlc05_objective_sun_ce_04"
		and context:query_model():world():faction_by_key(sun_ce_faction_key):is_human())
	end,
	function(context) -- What to do if listener fires.		
        --MOVE ZHANG HONG TO SUN CE's FACTION
        local characterToFind = context:query_model():character_for_template("3k_main_template_historical_zhang_hong_hero_water")
        move_character_to_court(characterToFind,sun_ce_faction_key,context:modify_model())		
        --MOVE ZHANG ZHAO TO SUN CE's FACTION
        local characterToFind = context:query_model():character_for_template("3k_main_template_historical_zhang_zhao_hero_water")
        move_character_to_court(characterToFind,sun_ce_faction_key,context:modify_model())
        --Trigger the next mission
        core:trigger_event("ScriptEventSunCeIntroductionMission04Complete")
	end,
	false --Is persistent
    );

    --MISSION 4a HAS FAILED, TAISHI CI JOIN THE COURT
    core:add_listener(
	"MissionCancelledTaishiCi", -- Unique handle
	"MissionCancelled", -- Campaign Event to listen for
    function(context)
		return (context:faction():name()==sun_ce_faction_key
		and context:mission():mission_record_key()=="3k_dlc05_objective_sun_ce_04a"
		and context:query_model():world():faction_by_key(sun_ce_faction_key):is_human())
	end,
	function(context) -- What to do if listener fires.		
        --MOVE TAISHI CI TO SUN CE's FACTION
        local characterToFind = context:query_model():character_for_template("3k_main_template_historical_taishi_ci_hero_metal")
        move_character_to_court(characterToFind,sun_ce_faction_key,context:modify_model())
	end,
	false --Is persistent
    );

    --MISSION 4b HAS FAILED, LU MENG JOIN THE COURT
    core:add_listener(
	"MissionCancelledLuMeng", -- Unique handle
	"MissionCancelled", -- Campaign Event to listen for
    function(context)
		return (context:faction():name()==sun_ce_faction_key
		and context:mission():mission_record_key()=="3k_dlc05_objective_sun_ce_04b"
		and context:query_model():world():faction_by_key(sun_ce_faction_key):is_human())
	end,
	function(context) -- What to do if listener fires.		
        --MOVE/SPAWN LU MENG TO SUN CE's FACTION
        local characterToFind = context:query_model():character_for_template("3k_main_template_historical_lu_meng_hero_metal")
        if not characterToFind:is_null_interface() then
            if not characterToFind:faction():is_human() then
                move_character_to_court(characterToFind,sun_ce_faction_key,context:modify_model())
            end					
        else
            if not context:query_model():date_in_range(0,195) then
                cdir_events_manager:spawn_character_subtype_template_in_faction(sun_ce_faction_key, "3k_general_metal", "3k_main_template_historical_lu_meng_hero_metal");
                cm:set_saved_value("LuMengSpawned", true,"SunCeMissions")
            end
        end
        cm:set_saved_value("Mission4bDone", true,"SunCeMissions")
	end,
	false --Is persistent
    );

    --MISSION 5 HAS FAILED, YU FAN JOIN THE COURT
    core:add_listener(
	"MissionCancelledYuFan", -- Unique handle
	"MissionCancelled", -- Campaign Event to listen for
    function(context)
		return (context:faction():name()==sun_ce_faction_key
		and context:mission():mission_record_key()=="3k_dlc05_objective_sun_ce_05"
		and context:query_model():world():faction_by_key(sun_ce_faction_key):is_human())
	end,
	function(context) -- What to do if listener fires.		
        --MOVE YU FAN TO SUN CE's FACTION
        local characterToFind = context:query_model():character_for_template("3k_main_template_historical_yu_fan_hero_water")
        move_character_to_court(characterToFind,sun_ce_faction_key,context:modify_model()) 
	end,
	false --Is persistent
    );

    --MISSION ISSUED - CHECK IF THEY SHOULD BE CANCELED
    core:add_listener(
	"SunCeMissionIssuedChecker", -- Unique handle
	"MissionIssued", -- Campaign Event to listen for
    function(context)
		return (context:faction():name()==sun_ce_faction_key
		and context:query_model():world():faction_by_key(sun_ce_faction_key):is_human())
	end,
    function(context) -- What to do if listener fires.
        if context:mission():mission_record_key()=="3k_dlc05_objective_sun_ce_03" then
            if cm:query_region("3k_main_xindu_resource_2"):owning_faction():name()==sun_ce_faction_key then
                cm:modify_faction(sun_ce_faction_key):complete_custom_mission("3k_dlc05_objective_sun_ce_03")
            end
        elseif context:mission():mission_record_key()=="3k_dlc05_objective_sun_ce_04" then
            if cm:query_region("3k_main_jianye_capital"):owning_faction():name()==sun_ce_faction_key then
                cm:modify_faction(sun_ce_faction_key):complete_custom_mission("3k_dlc05_objective_sun_ce_04")
            end
        elseif context:mission():mission_record_key()=="3k_dlc05_objective_sun_ce_04a" then
            if cm:query_region("3k_main_poyang_capital"):owning_faction():name()==sun_ce_faction_key then
                cm:modify_faction(sun_ce_faction_key):complete_custom_mission("3k_dlc05_objective_sun_ce_04a")
            end
        elseif context:mission():mission_record_key()=="3k_dlc05_objective_sun_ce_04b" then
            if cm:query_region("3k_main_xindu_capital"):owning_faction():name()==sun_ce_faction_key then
                cm:modify_faction(sun_ce_faction_key):complete_custom_mission("3k_dlc05_objective_sun_ce_04b")
            end
        elseif context:mission():mission_record_key()=="3k_dlc05_objective_sun_ce_05" then            
            if cm:query_region("3k_main_kuaiji_capital"):owning_faction():name()==sun_ce_faction_key then
                cm:modify_faction(sun_ce_faction_key):complete_custom_mission("3k_dlc05_objective_sun_ce_05")
            end
        end
	end,
	true --Is persistent
    );

    --If the player picks the option to go to war with Yuan Shu, check which missions to skip
    core:add_listener(
	"DilemmaChoiceMadeEventSunCeYuanShu", -- Unique handle
    "DilemmaChoiceMadeEvent", -- Campaign Event to listen for
    function(context)
        if (((context:dilemma()=="3k_dlc05_historical_sun_ce_yuan_shu_dilemma" or 
        context:dilemma()=="3k_dlc05_historical_sun_ce_imperial_seal_dilemma") and context:choice()==1) or 
        (cm:saved_value_exists("SunCeMission1", "SunCeMissions") and cm:saved_value_exists("SunCeMission2", "SunCeMissions"))) then
            return true
        end
        return false
	end,
    function(context) -- What to do if listener fires.
        if not cm:saved_value_exists("SunCecIntroMissionsSkipped","SunCeMissions") then
            missions_to_skip()
        end        
    end,
    false --Is persistent
    );

    --If the player picks the diplomacy option to go to war with Yuan Shu, check which missions to skip
    core:add_listener(
    "DiplomacyDealNegotiatedSunCeYuanShu", -- Unique handle
    "DiplomacyDealNegotiated", -- Campaign Event to listen for
    function(context)
        if cm:query_faction(sun_ce_faction_key):has_specified_diplomatic_deal_with("treaty_components_war",cm:query_faction("3k_main_faction_yuan_shu")) then
            return true
        end
        return false
    end,
    function(context)
        if not cm:saved_value_exists("SunCecIntroMissionsSkipped","SunCeMissions") then
            missions_to_skip()
        end    
    end,
    false
    );

-- TUTORIAL MISSIONS LISTENERS --
start_historical_mission_db_listener(
	sun_ce_faction_key,                          -- faction key
    "3k_dlc05_objective_sun_ce_01",               -- mission key
    "ScriptEventStartTutorialMissions",      -- trigger event 
    "ScriptEventSunCeIntroductionMission01Complete", -- completion event
    function()
        if not cm:query_faction(sun_ce_faction_key):has_specified_diplomatic_deal_with("treaty_components_war",cm:query_faction("3k_main_faction_yuan_shu")) then
            return true
        end
        return false
    end,                                                -- precondition (nil, or a function that returns a boolean)
    "ScriptEventSunCeIntroductionMission01Fail"       -- failure event
);

start_historical_mission_db_listener(
	sun_ce_faction_key,                          -- faction key
    "3k_dlc05_objective_sun_ce_02",               -- mission key
    "ScriptEventSunCeIntroductionMission01Complete",      -- trigger event 
    "ScriptEventSunCeIntroductionMission02Complete" -- completion event
);

start_historical_mission_db_listener(
	sun_ce_faction_key,                          -- faction key
    "3k_dlc05_objective_sun_ce_03",               -- mission key
    "ScriptEventSunCeIntroductionMission02Complete",      -- trigger event 
    "ScriptEventSunCeIntroductionMission03Complete"
);

start_historical_mission_db_listener(
	sun_ce_faction_key,                          -- faction key
    "3k_dlc05_objective_sun_ce_03a",               -- mission key
    "ScriptEventSunCeIntroductionMission02Complete",      -- trigger event 
    "ScriptEventSunCeIntroductionMission03aComplete"     -- completion event
);

start_historical_mission_db_listener(
	sun_ce_faction_key,                          -- faction key
    "3k_dlc05_objective_sun_ce_04",               -- mission key
    "ScriptEventSunCeIntroductionMission03Complete",      -- trigger event 
    "ScriptEventSunCeIntroductionMission04Complete" -- completion event
);

start_historical_mission_db_listener(
	sun_ce_faction_key,                          -- faction key
    "3k_dlc05_objective_sun_ce_04a",               -- mission key
    "ScriptEventSunCeIntroductionMission03Complete",      -- trigger event 
    "ScriptEventSunCeIntroductionMission04aComplete" -- completion event
);

start_historical_mission_db_listener(
	sun_ce_faction_key,                          -- faction key
    "3k_dlc05_objective_sun_ce_04b",               -- mission key
    "ScriptEventSunCeIntroductionMission03Complete",      -- trigger event 
    "ScriptEventSunCeIntroductionMission04bComplete" -- completion event
);

start_historical_mission_db_listener(
	sun_ce_faction_key,                          -- faction key
    "3k_dlc05_objective_sun_ce_05",               -- mission key
    "ScriptEventSunCeIntroductionMission04Complete",      -- trigger event 
    "ScriptEventSunCeIntroductionMission05Complete" -- completion event
);

-- An event in Sun Ce's progression triggers Sun Ce's vengeance mission. 
start_historical_mission_listener(
	sun_ce_faction_key,                          -- faction key
    "3k_dlc05_objective_sun_ce_06",               -- mission key
    "DESTROY_FACTION",
    {
        "faction 3k_main_faction_huang_zu"
    }, 
    {
        "money 5000"
    },
    "ScriptEventSunCeVengenceMission",      -- trigger event
    "ScriptEventSunCeIntroductionMission06Complete", -- completion event
    function()
        if not cm:query_faction("3k_main_faction_huang_zu"):is_dead() then
            return true
        end
        return false
    end,                                                -- precondition (nil, or a function that returns a boolean)
    "ScriptEventSunCeIntroductionMission06Fail"       -- failure event
);
--cm:add_first_tick_callback_new(function() xyy_kafka_story_mode(); end);


function xyy_summon_huanlong_faction()
--      campaign_invasions:create_invasion("xyyhlyjf", "3k_main_wuling_resource_1", 2, false)

        local world_faction_list = cm:query_model():world():faction_list();
--         for i = 0, world_faction_list:num_items() - 1 do
--             local world_faction = world_faction_list:item_at(i)
--             ModLog(world_faction:name());
--         end;
        faction_xyyhlyjf = cm:query_faction("xyyhlyjf");
        
        cm:modify_region("3k_main_shoufang_resource_2"):settlement_gifted_as_if_by_payload(cm:modify_faction("3k_main_faction_shoufang"));
        cm:modify_region("3k_main_shoufang_resource_3"):settlement_gifted_as_if_by_payload(cm:modify_faction("xyyhlyjf"));
        cm:modify_region("3k_main_shoufang_resource_2"):settlement_gifted_as_if_by_payload(cm:modify_faction("xyyhlyjf"));
        cm:modify_region("3k_main_shoufang_resource_1"):settlement_gifted_as_if_by_payload(cm:modify_faction("xyyhlyjf"));
        cm:modify_region("3k_main_shoufang_capital"):settlement_gifted_as_if_by_payload(cm:modify_faction("xyyhlyjf"));
        
--         xyy_set_region_manager("3k_main_shoufang_resource_1","xyyhlyjf");
        local hlyjdingzhia = xyy_character_add("hlyjdingzhia", "xyyhlyjf", "3k_general_destroy")
        xyy_CEO_equip("hlyjdingzhia","hlyjdingzhiazuoqi","3k_main_ceo_category_ancillary_mount");
        xyy_CEO_equip("hlyjdingzhia","hlyjdingzhiawuqi","3k_main_ceo_category_ancillary_weapon");
        xyy_CEO_equip("hlyjdingzhia","hlyjdingzhiafujian","3k_main_ceo_category_ancillary_accessory");
        xyy_set_minister_position("hlyjdingzhia","faction_leader");
        xyy_remove_all_traits(hlyjdingzhia);
        cm:modify_character(hlyjdingzhia):ceo_management():add_ceo("kafka_mission_complete_01");
        cm:modify_character(hlyjdingzhia):ceo_management():add_ceo("3k_main_ceo_trait_personality_vengeful");
        cm:modify_character(hlyjdingzhia):ceo_management():add_ceo("3k_main_ceo_trait_personality_cruel");
        cm:modify_character(hlyjdingzhia):add_experience(295000,0);
--      modify_character:ceo_management():equip_ceo_in_slot(valid_equipment_slot_for_ceo_category, query_ceo);
        
--         xyy_character_add("hlyjdingzhid", "xyyhlyjf", "3k_general_destroy");
--         xyy_character_add("hlyjdingzhie", "xyyhlyjf", "3k_general_destroy");
--         xyy_character_add("hlyjdingzhif", "xyyhlyjf", "3k_general_destroy");
        
--         query_hlyjdingzhia = cm:query_model():character_for_template("hlyjdingzhia");
--         cm:create_force_with_existing_general(query_hlyjdingzhia:command_queue_index(), "xyyhlyjf", "", "3k_main_shoufang_resource_1", 186, 466, "hlyjdingzhia_force", nil, 100);
--         
--         local modify_xyyhlyjf_force = cm:modify_model():get_modify_military_force(query_hlyjdingzhia:military_force());
--         
--         modify_xyyhlyjf_force:add_existing_character_as_retinue(modify_hlyjdingzhid, true);
--         modify_xyyhlyjf_force:add_existing_character_as_retinue(modify_hlyjdingzhie, true);
        
        for i = 0, world_faction_list:num_items() - 1 do
            local q_faction = world_faction_list:item_at(i)
--             ModLog(random_faction:name());
--             if not random_faction:is_dead() and not random_faction:name() == "xyyhlyjf" then
--                 if faction_xyyhlyjf:can_apply_automatic_diplomatic_deal("data_defined_situation_war_proposer_to_recipient", random_faction, "faction_key:"..random_faction:name()) then
--                     faction_xyyhlyjf:apply_automatic_diplomatic_deal("data_defined_situation_war_proposer_to_recipient", random_faction, "faction_key:"..random_faction:name()); 
             if not q_faction:is_dead() and q_faction:name() ~= "xyyhlyjf" then
                diplomacy_manager:apply_automatic_deal_between_factions(faction_xyyhlyjf:name(), q_faction:name(), "data_defined_situation_war_proposer_to_recipient")
                ModLog(faction_xyyhlyjf:name().."向"..q_faction:name().."宣战了");
             end
--             end
        end;
        
        local xyyhlyjf = faction_xyyhlyjf;
        
        found_pos, x, y = cm:query_faction("xyyhlyjf"):get_valid_spawn_location_in_region(xyyhlyjf:capital_region():name(), false);
        cm:create_force_with_existing_general(hlyjdingzhia:command_queue_index(), "xyyhlyjf", "", xyyhlyjf:capital_region():name(), x, y, "hlyjdingzhia_force6", nil, 100);
        
        ModLog("debug: trigger is_kafka_mission_15" .. xyyhlyjf:capital_region():name() )
        local modify_force = cm:modify_model():get_modify_military_force(hlyjdingzhia:military_force());
        
        local modify_character_1 = cm:modify_faction("xyyhlyjf"):create_character_from_template("general", "3k_general_wood", "3k_xyy_template_scripted_xyyhlyjf_wood_strong_late", false);
        local modify_character_2 = cm:modify_faction("xyyhlyjf"):create_character_from_template("general", "3k_general_fire", "3k_xyy_template_scripted_xyyhlyjf_fire_strong_late", false);    
        
        modify_character_1:add_experience(295000,0);
        modify_character_2:add_experience(295000,0);
        
        if modify_force:query_military_force():character_list():num_items() < 3 then
            modify_force:add_existing_character_as_retinue(modify_character_1, true);
        end
        if modify_force:query_military_force():character_list():num_items() < 3 then
            modify_force:add_existing_character_as_retinue(modify_character_2, true);
        end

        cm:modify_character(hlyjdingzhia):apply_effect_bundle("freeze", -1);
end;


local is_kafka_with_leader = false;

local mission_keys = {
    "kafka_mission_01",
    "kafka_mission_02",
    "kafka_mission_02_dlc04",
    "kafka_mission_02_dlc05",
    "kafka_mission_02_dlc07",
    "kafka_mission_02_a",
    "kafka_mission_02_a_dlc04",
    "kafka_mission_02_a_dlc05",
    "kafka_mission_02_a_dlc07",
    "kafka_mission_03",
    "kafka_mission_04",
    "kafka_mission_04_dlc04",
    "kafka_mission_04_dlc05",
    "kafka_mission_04_dlc07",
    "kafka_mission_huanlong",
    "kafka_mission_05",
    "kafka_mission_05_dlc04",
    "kafka_mission_05_dlc05",
    "kafka_mission_05_dlc07",
    "kafka_mission_05_a",
    "kafka_mission_07",
    "kafka_mission_07_3",
    "kafka_mission_08",
    "kafka_mission_09",
    "kafka_mission_huanlong_01",
    "kafka_mission_12_a",
    "kafka_mission_14",
    "kafka_mission_14_a",
    "kafka_mission_huanlong_02",
    "kafka_mission_huanlong_03",
    "kafka_mission_15",
    "kafka_mission_15_a"
}

function create_force_with_existing_general(modify_character, faction_key, unit_list, region_key, x, y, id, success_callback, starting_health_percentage, starting_orientation)
	starting_health_percentage = starting_health_percentage or 100;
	starting_orientation = starting_orientation or 0;

	if not modify_character or modify_character:is_null_interface() then
		return;
	end;
	
	if not is_string(faction_key) then
		return;
	end;
	
	if not cm:faction_exists(faction_key) then
		return;
	end;
	
	-- We can support an empty unit list in 3K, so allow this to happen and fix it up.
	if not is_string(unit_list) then
		unit_list = "";
	end;
	
	if not is_string(region_key) then
		return;
	end;
	
	if not is_number(x) or x < 0 then
		return;
	end;
	
	if not is_number(y) or y < 0 then
		return;
	end;
	
	if not is_string(id) then
		return;
	end;
	
	if not is_function(success_callback) and not is_nil(success_callback) then
		return;
	end;
	
	if not cm:can_modify() then
		return;
	end;
	
	if not is_number(starting_health_percentage) or starting_health_percentage < 1 then
		return;
	end;
	
	if not is_number(starting_orientation) then
		return;
	end;
	
	local listener_name = "campaign_manager_create_force_" .. id;
	
	core:add_listener(
		listener_name,
		"ScriptedForceCreated",
		true,
		function() cm:force_created(id, listener_name, faction_key, x, y, success_callback) end,
		true
	);
	
	-- make the call to create the force
	modify_character:create_force(region_key, unit_list, x, y, id, starting_health_percentage, starting_orientation);
	
end;

core:add_listener(
    "on_character_wounded_received",
    "CharacterWoundReceivedEvent",
    function(context)
        return true;
    end,
    function(context)
        if context:query_character():is_wounded() then
            local key = "is_wounded"..context:query_character():cqi()
            if not cm:get_saved_value(key) then
                cm:set_saved_value(key,1);
            else
                cm:set_saved_value(key,cm:get_saved_value(key) + 1);
            end
            ModLog(context:query_character():generation_template_key().."已受伤")
        end
    end,
    true
)

core:add_listener(
    "on_character_wound_healed",
    "CharacterWoundHealedEvent",
    function(context)
        return true;
    end,
    function(context)
        local key = "is_wounded"..context:query_character():cqi()
        if not cm:get_saved_value(key) then
            cm:set_saved_value(key,0);
        else
            cm:set_saved_value(key,cm:get_saved_value(key) - 1);
        end
        ModLog(context:query_character():generation_template_key().."已恢复")
    end,
    true
)

--去除伤残
core:add_listener(
    "kafka_ceo_trait_remove",
    "CharacterCeoAdded",
    function(context)
        return 
            not is_wounded(context:query_character())
        and 
            (context:ceo():ceo_data_key() == "3k_main_ceo_trait_physical_one-eyed" 
            or context:ceo():ceo_data_key() == "3k_ytr_ceo_trait_physical_sprained_ankle" 
            or context:ceo():ceo_data_key() == "3k_main_ceo_trait_physical_scarred" 
            or context:ceo():ceo_data_key() == "3k_main_ceo_trait_physical_maimed_arm"
            or context:ceo():ceo_data_key() == "3k_main_ceo_trait_physical_maimed_leg");
    end,
    function(context)
        if context:query_character():generation_template_key() == "hlyjch"
        or context:query_character():generation_template_key() == "hlyjci"
        or context:query_character():generation_template_key() == "hlyjcj"
        or context:query_character():generation_template_key() == "hlyjck"
        or context:query_character():generation_template_key() == "hlyjcl"
        or context:query_character():generation_template_key() == "hlyjcm"
        or context:query_character():generation_template_key() == "hlyjcn"
        or context:query_character():generation_template_key() == "hlyjco"
        or context:query_character():generation_template_key() == "hlyjcp"
        or context:query_character():generation_template_key() == "hlyjcq"
        or context:query_character():generation_template_key() == "hlyjcr"
        or context:query_character():generation_template_key() == "hlyjcs"
        or context:query_character():generation_template_key() == "hlyjct"
        or context:query_character():generation_template_key() == "hlyjdingzhia"
        or context:query_character():generation_template_key() == "hlyjdingzhid"
        or context:query_character():generation_template_key() == "hlyjdingzhie"
        or context:query_character():generation_template_key() == "hlyjdingzhif"
        or context:query_character():generation_template_key() == "hlyjdingzhiu"
        or context:query_character():generation_template_key() == "hlyjdingzhiv"
        or context:query_character():generation_template_key() == "hlyjdingzhiw"
        or context:query_character():generation_template_key() == "hlyjdingzhix"
        or context:query_character():generation_template_key() == "hlyjdingzhir"
        or context:query_character():generation_template_key() == "hlyjdingzhis"
        or context:query_character():generation_template_key() == "hlyjdingzhit"
        or (cm:get_saved_value("kafka_mission_leader") and context:query_character():generation_template_key() == cm:get_saved_value("kafka_mission_leader"))
        then
            ModLog(context:query_character():generation_template_key().."不会伤残")
            local ceo_key = context:ceo():ceo_data_key(); --Get Ceo
            local character_modifier = context:modify_character(); 
            character_modifier:ceo_management():remove_ceos(ceo_key); 
            cm:set_saved_value("is_wounded"..context:query_character():cqi(),0);
        else
            ModLog(context:query_character():generation_template_key().."受伤状态下再次受伤可能伤残")
            if ceo_key ~= "3k_main_ceo_trait_physical_scarred" then
                local ceo_key = context:ceo():ceo_data_key(); --Get Ceo
                local character_modifier = context:modify_character(); 
                character_modifier:ceo_management():remove_ceos(ceo_key); 
                if cm:random_int(1,2) > 1 then
                    character_modifier:ceo_management():add_ceo("3k_main_ceo_trait_physical_scarred"); 
                end
            end
        end
    end,
    true
)

--是否受伤了
function is_wounded(query_character) 
    local key = "is_wounded"..query_character:cqi()
    return cm:get_saved_value(key) and cm:get_saved_value(key) > 1;
end



--卡芙卡剧情线
core:add_listener(
    "kafka_mission_01",
    "IncidentOccuredEvent",
    function(context)
        return context:incident() == "summon_hlyjcj";
    end,
    function(context)
        cm:trigger_mission(context:faction(), "kafka_mission_01", true);
        cm:set_saved_value("kafka_mission", true);
    end,
    false
)

core:add_listener(
    "kafka_mission_01_success",
    "MissionSucceeded",
    function(context)
        return context:mission():mission_record_key() == "kafka_mission_01";
    end,
    function(context)
        local leader = context:faction():faction_leader();
        cm:set_saved_value("kafka_mission_leader", leader:generation_template_key());
        local kafka = cm:query_model():character_for_template("hlyjcj");
        local kafka_force = kafka:military_force();
        if kafka_force and kafka:has_military_force() then
            if kafka_force:character_list():num_items() < 3 then
                cm:modify_model():get_modify_military_force(kafka_force):add_existing_character_as_retinue(cm:modify_character(leader),true);
            end
            local have_leader = false;
            for i = 0, kafka_force:character_list():num_items() - 1 do
                if kafka_force:character_list():item_at(i) == leader then
                    ModLog(i .. " " .. kafka_force:character_list():item_at(i):generation_template_key())
                    have_leader = true;
                end
            end
            if not have_leader then
                effect.advice(effect.get_localised_string("mod_kafka_mission_01_message"))
            else
                cm:set_saved_value("kafka_mission_01_success",true);
                if cm:query_model():campaign_name() == "3k_main_campaign_map" then
                    cm:trigger_mission(context:faction(), "kafka_mission_02", true)
                elseif cm:query_model():campaign_name() == "3k_dlc04_start_pos" then
                    cm:trigger_mission(context:faction(), "kafka_mission_02_dlc04", true)
                elseif cm:query_model():campaign_name() == "3k_dlc05_start_pos" then
                    cm:trigger_mission(context:faction(), "kafka_mission_02_dlc05", true)
                elseif cm:query_model():campaign_name() == "3k_dlc07_start_pos" then
                    cm:trigger_mission(context:faction(), "kafka_mission_02_dlc07", true)
                end
            end
        else
            effect.advice(effect.get_localised_string("mod_kafka_mission_01_message"))
            cm:set_saved_value("kafka_mission_01",true);
        end
    end,
    false
)

core:add_listener(
    "kafka_mission_force_created",
    "MilitaryForceCreated",
    function(context)
        local military_force_created = context:military_force_created();
        ModLog(military_force_created:general_character():generation_template_key());
        return military_force_created 
        and cm:get_saved_value("kafka_mission_leader")
        and not military_force_created:general_character():is_null_interface();
    end,
    function(context)
        local military_force_created = context:military_force_created();
        local kafka_force = context:military_force_created();
        local kafka = cm:query_model():character_for_template("hlyjcj");
        local leader = cm:query_model():character_for_template(cm:get_saved_value("kafka_mission_leader"));
        if military_force_created:general_character():generation_template_key() == "hlyjcj" 
        and kafka:has_military_force()
        and kafka_force 
        then
            if kafka_force:character_list():num_items() < 3 and not leader:has_military_force() then
                cm:modify_model():get_modify_military_force(kafka_force):add_existing_character_as_retinue(cm:modify_character(leader),true);
            end
        end
        if kafka:has_military_force() then
            ModLog("kafka_leader_military_force = true")
            cm:set_saved_value("kafka_leader_military_force", true)
        else
            ModLog("kafka_leader_military_force = false")
            cm:set_saved_value("kafka_leader_military_force", false)
        end
    end,
    true
)

core:add_listener(
    "kafka_mission_force_event",
    "MilitaryForceEvent",
    function(context)
        local military_force = context:military_force();
        ModLog(military_force:general_character():generation_template_key());
        return military_force 
        and cm:get_saved_value("kafka_mission_leader")
        and not military_force:general_character():is_null_interface();
    end,
    function(context)
        local kafka = cm:query_model():character_for_template("hlyjcj");
        if kafka:has_military_force() then
            ModLog("kafka_leader_military_force = true")
            cm:set_saved_value("kafka_leader_military_force", true)
        else
            ModLog("kafka_leader_military_force = false")
            cm:set_saved_value("kafka_leader_military_force", false)
        end
    end,
    true
)
--回合触发器
core:add_listener(
    "kafka_mission_01_round",
    "FactionTurnStart",
    function(context)
         if context:faction():name() == cm:query_local_faction():name() then
            return true
         end
    end,
    function(context)
        local leader = context:faction():faction_leader();
        local kafka = cm:query_model():character_for_template("hlyjcj");
        local leader = context:faction():faction_leader();
        if leader:has_military_force() then
            cm:set_saved_value("kafka_leader_military_force", true)
        else
            cm:set_saved_value("kafka_leader_military_force", false)
        end
        local shoufang = cm:query_faction("3k_main_faction_shoufang");
        if shoufang and not shoufang:is_dead() and not cm:get_saved_value("kafka_mission") then
            cm:modify_faction(shoufang):apply_effect_bundle("kafka_mission");
        end
        --检测卡芙卡是否在玩家派系
        if not cm:get_saved_value("kafka_mission") then
            if not kafka:is_null_interface() and kafka:faction():name() ~= "3k_main_faction_shoufang" or kafka:is_character_is_faction_recruitment_pool() then
                cm:modify_character(kafka):move_to_faction_and_make_recruited("3k_main_faction_shoufang")
            end
        elseif not cm:get_saved_value("kafka_mission_leader") then
            cm:set_saved_value("kafka_mission_leader", leader:generation_template_key());
        end
        if not cm:get_saved_value("kafka_mission") then
            return;
        end
        --主公换人会导致卡芙卡叛逃
        if cm:get_saved_value("kafka_mission_leader") 
        and not cm:get_saved_value("huanlong_dead") 
        and not cm:get_saved_value("is_kafka_leaved") 
        and cm:get_saved_value("kafka_mission_leader") ~= leader:generation_template_key() and kafka:faction():name() == context:faction():name() 
        and not kafka:is_faction_leader() then
            if not cm:get_saved_value("kafka_mission_ready_to_summon_huanlong") then
                cm:set_saved_value("kafka_mission_ready_to_summon_huanlong", 0);
            end
            
            cm:trigger_incident(context:faction():name(),"kafka_mission_13_a_incident", true);
            
            local hlyjdingzhie = xyy_character_add("hlyjdingzhie", "xyyhlyjf", "3k_general_water");
            if hlyjdingzhie and hlyjdingzhie:faction():name() == context:faction():name() then
                cm:modify_faction(context:faction()):ceo_management():remove_ceos("hlyjdingzhiewuqi");
                xyy_CEO_equip("hlyjdingzhie","hlyjdingzhiewuqi","3k_main_ceo_category_ancillary_weapon");
                cm:modify_character(hlyjdingzhie):apply_relationship_trigger_set(context:faction():faction_leader(),    "3k_main_relationship_trigger_set_event_negative_betrayed");
            end
            xyy_runaway("hlyjcj");
            
            if context:faction():ceo_management():has_ceo_equipped("hlyjcjwuqi") then
                cm:modify_faction(context:faction()):ceo_management():remove_ceos("hlyjcjwuqi");
                xyy_CEO_equip("hlyjcj","hlyjcjwuqi","3k_main_ceo_category_ancillary_weapon");
            end
            
            xyy_random_kill(context:faction():name(),3);
            
            cm:modify_character(kafka):apply_relationship_trigger_set(context:faction():faction_leader(), "3k_main_relationship_trigger_set_event_negative_betrayed");
            
            cm:set_saved_value("is_kafka_leaved", true);
        end
        
        --生成幻胧的倒计时
        if cm:get_saved_value("kafka_mission_ready_to_summon_huanlong") and cm:get_saved_value("kafka_mission_ready_to_summon_huanlong") >= 0 then 
            if cm:get_saved_value("kafka_mission_ready_to_summon_huanlong") <= 3 then
                cm:set_saved_value("kafka_mission_ready_to_summon_huanlong", cm:get_saved_value("kafka_mission_ready_to_summon_huanlong") + 1);
            else
                cm:trigger_incident(context:faction():name(), "kafka_mission_summon_huanlong", true)
                
                xyy_summon_huanlong_faction();
                cm:set_saved_value("kafka_mission_ready_to_summon_huanlong", -1);
            end
        end
        
        --停云来投的倒计时
        if cm:get_saved_value("summon_hlyjdingzhie") then
            ModLog("\n"..cm:get_saved_value("summon_hlyjdingzhie").."\n")
        end
        if cm:get_saved_value("summon_hlyjdingzhie") and cm:get_saved_value("summon_hlyjdingzhie") >= 0 then
            if  cm:get_saved_value("summon_hlyjdingzhie") >= 1 then
                ModLog("触发停云来投")
                cm:set_saved_value("summon_hlyjdingzhie", -1);
                local tingyun = cm:query_model():character_for_template("hlyjdingzhie")
                if not tingyun or tingyun:is_null_interface() then
                    cm:trigger_dilemma(context:faction():name(),"kafka_mission_06_choice", true);
                end
            else
                cm:set_saved_value("summon_hlyjdingzhie", cm:get_saved_value("summon_hlyjdingzhie") + 1);
            end
        end
        
        local kafka = cm:query_model():character_for_template("hlyjcj");
        
        --检测领袖是否在卡芙卡军队
        if kafka and not kafka:is_dead() and not kafka:is_character_is_faction_recruitment_pool() and kafka:faction() == context:faction() then 
            if not cm:get_saved_value("kafka_mission_01_success") then
                local leader = context:faction():faction_leader();
                local kafka_force = kafka:military_force();
                if kafka_force and kafka_force:has_general() and kafka_force:general_character() == kafka then
                    if kafka_force:character_list():num_items() < 3 then
                        cm:modify_model():get_modify_military_force(kafka_force):add_existing_character_as_retinue(cm:modify_character(leader),true);
                    end
                    local have_leader = false;
                    for i = 0, kafka_force:character_list():num_items() - 1 do
                        if kafka_force:character_list():item_at(i) == leader then
                            ModLog(i .. " " .. kafka_force:character_list():item_at(i):generation_template_key())
                            have_leader = true;
                        end
                    end
                    if not have_leader then
                        is_kafka_with_leader = false;
                        effect.advice(effect.get_localised_string("mod_kafka_mission_01_message"))
                    else
                        is_kafka_with_leader = true;
                        cm:set_saved_value("kafka_mission_01_success",true);
                        if cm:query_model():campaign_name() == "3k_main_campaign_map" then
                            cm:trigger_mission(context:faction(), "kafka_mission_02", true)
                        elseif cm:query_model():campaign_name() == "3k_dlc04_start_pos" then
                            cm:trigger_mission(context:faction(), "kafka_mission_02_dlc04", true)
                        elseif cm:query_model():campaign_name() == "3k_dlc05_start_pos" then
                            cm:trigger_mission(context:faction(), "kafka_mission_02_dlc05", true)
                        elseif cm:query_model():campaign_name() == "3k_dlc07_start_pos" then
                            cm:trigger_mission(context:faction(), "kafka_mission_02_dlc07", true)
                        end
                    end
                else
                    is_kafka_with_leader = false
                    effect.advice(effect.get_localised_string("mod_kafka_mission_01_message"))
                end
            end
        end
        
        --监测卡芙卡是否已经离开派系
        if 
        not cm:get_saved_value("kafka_mission_12_a") 
        and cm:get_saved_value("is_player_have_kafka") 
        and not cm:get_saved_value("is_kafka_leaved") 
        and not cm:get_saved_value("kafka_mission_12_a_trigger") 
        then
            local kafka = cm:query_model():character_for_template("hlyjcj"); 
            local tingyun = cm:query_model():character_for_template("hlyjdingzhie"); 
            if 
            kafka
            and not kafka:is_dead() 
            and (kafka:faction() ~= context:faction() or kafka:is_character_is_faction_recruitment_pool())
            and tingyun 
            and not tingyun:is_dead() 
            and tingyun:faction() == context:faction() 
            and not tingyun:is_character_is_faction_recruitment_pool()
            then
                local hlydingzhie = xyy_character_add("hlyjdingzhie", "xyyhlyjf", "3k_general_water");
                cm:modify_faction(context:faction()):ceo_management():remove_ceos("hlyjdingzhiewuqi");
                xyy_CEO_equip("hlyjdingzhie","hlyjdingzhiewuqi","3k_main_ceo_category_ancillary_weapon");
                
                local xyyhlyjf = cm:query_faction("xyyhlyjf");
                
                found_pos, x, y = xyyhlyjf:get_valid_spawn_location_in_region(xyyhlyjf:capital_region():name(), false);
                cm:create_force_with_existing_general(hlyjdingzhie:command_queue_index(), "xyyhlyjf", "", xyyhlyjf:capital_region():name(), x, y, "hlyjdingzhie_force", nil, 100);
                
                ModLog("debug: trigger is_kafka_mission_15" .. xyyhlyjf:capital_region():name() )
                local modify_force = cm:modify_model():get_modify_military_force(hlyjdingzhie:military_force());
                
                local modify_character_1 = cm:modify_faction("xyyhlyjf"):create_character_from_template("general", "3k_general_wood", "3k_xyy_template_scripted_xyyhlyjf_wood_strong_late", false);
                local modify_character_2 = cm:modify_faction("xyyhlyjf"):create_character_from_template("general", "3k_general_fire", "3k_xyy_template_scripted_xyyhlyjf_fire_strong_late", false);    
                
                modify_character_1:add_experience(295000,0);
                modify_character_2:add_experience(295000,0);
                
                if modify_force:query_military_force():character_list():num_items() < 3 then
                    modify_force:add_existing_character_as_retinue(modify_character_1, true);
                end
                
                if modify_force:query_military_force():character_list():num_items() < 3 then
                    modify_force:add_existing_character_as_retinue(modify_character_2, true);
                end
                
                
                if context:faction():ceo_management():has_ceo_equipped("hlyjcjwuqi") then
                    cm:modify_faction(context:faction()):ceo_management():remove_ceos("hlyjcjwuqi");
                    xyy_CEO_equip("hlyjcj","hlyjcjwuqi","3k_main_ceo_category_ancillary_weapon");
                end
                
                cm:trigger_incident(context:faction():name(),"kafka_mission_13_c_incident", true);
                cm:set_saved_value("is_kafka_leaved", true);
                
                for i = 1, #mission_keys do
				-- Cancel the mission if it's active.
				if context:faction():is_mission_active(mission_keys[i]) then
					cm:cancel_custom_mission(context:faction():name(), mission_keys[i])
					ModLog("Canceling intro mission " .. mission_keys[i] .. " as faction rank up has happened!")
				end;

			end;

            end;
        end;
        
        --击败停云之后事件
        if 
        cm:get_saved_value("hlyjdingzhie_has_been_killed") 
        and not cm:get_saved_value("is_kafka_mission_huanlong_02_triggered")
        then
            if not cm:get_saved_value("is_kafka_leaved") 
            then
                ModLog("debug: trigger kafka_mission_huanlong_02")
                local mission = string_mission:new("kafka_mission_huanlong_02");
                mission:add_primary_objective("DEFEAT_N_ARMIES_OF_FACTION", {"total 5","faction xyyhlyjf"});
                mission:add_primary_payload("money 15000");
                mission:trigger_mission_for_faction(context:faction():name());
                cm:set_saved_value("is_kafka_mission_huanlong_02_triggered",true);
            end
        end
        
        if 
        cm:get_saved_value("hlyjdingzhie_has_been_killed") 
        and not cm:get_saved_value("is_kafka_mission_14_triggered")
        then
            ModLog("debug: trigger is_kafka_mission_14")
            cm:set_saved_value("is_kafka_mission_14_triggered", true);
            local hlyjdingzhia = cm:query_model():character_for_template("hlyjdingzhia");
            local xyyhlyjf = cm:query_faction("xyyhlyjf");
            if not hlyjdingzhia:has_military_force() or not hlyjdingzhia:military_force() then
                found_pos, x, y = cm:query_faction("xyyhlyjf"):get_valid_spawn_location_in_region(xyyhlyjf:capital_region():name(), false);
                cm:create_force_with_existing_general(hlyjdingzhia:command_queue_index(), "xyyhlyjf", "", xyyhlyjf:capital_region():name(), x, y, "hlyjdingzhia_force7", nil, 100);
                
                ModLog("debug: trigger is_kafka_mission_15" .. xyyhlyjf:capital_region():name() )
                
                local modify_force = cm:modify_model():get_modify_military_force(hlyjdingzhia:military_force());
                
                local modify_character_1 = cm:modify_faction("xyyhlyjf"):create_character_from_template("general", "3k_general_wood", "3k_xyy_template_scripted_xyyhlyjf_wood_strong_late", false);
                local modify_character_2 = cm:modify_faction("xyyhlyjf"):create_character_from_template("general", "3k_general_fire", "3k_xyy_template_scripted_xyyhlyjf_fire_strong_late", false);    
                
                modify_character_1:add_experience(295000,0);
                modify_character_2:add_experience(295000,0);
                
                if modify_force:query_military_force():character_list():num_items() < 3 then
                    modify_force:add_existing_character_as_retinue(modify_character_1, true);
                end
                if modify_force:query_military_force():character_list():num_items() < 3 then
                    modify_force:add_existing_character_as_retinue(modify_character_2, true);
                end
                modify_force:set_retreated()
            else
                local modify_force = cm:modify_model():get_modify_military_force(hlyjdingzhia:military_force());
                modify_force:set_retreated()
            end
            if not cm:get_saved_value("is_kafka_leaved") then
                cm:trigger_mission(context:faction(), "kafka_mission_14", true);
            else
                cm:trigger_mission(context:faction(), "kafka_mission_14_a", true);
            end
        end
        
        if context:faction():is_mission_active("kafka_mission_14")
        or context:faction():is_mission_active("kafka_mission_14_a")  
        then
            local hlyjdingzhia = cm:query_model():character_for_template("hlyjdingzhia");
            local modify_force = cm:modify_model():get_modify_military_force(hlyjdingzhia:military_force());
            modify_force:set_retreated();
        end
        
        if 
        cm:get_saved_value("trigger_kafka_mission_15") 
        and not context:faction():has_mission_been_issued("kafka_mission_15")
        and not context:faction():has_mission_been_issued("kafka_mission_15_a")  
        then
            local hlyjdingzhia = cm:query_model():character_for_template("hlyjdingzhia");
            local xyyhlyjf = cm:query_faction("xyyhlyjf");
            local region = xyyhlyjf:capital_region():name()
            
            found_pos, x, y = cm:query_faction("xyyhlyjf"):get_valid_spawn_location_in_region(region, false);
            
            if 1 then
                if not hlyjdingzhia:has_military_force() or not hlyjdingzhia:military_force() then
                    cm:create_force_with_existing_general(hlyjdingzhia:command_queue_index(), "xyyhlyjf", "", region, x, y, "hlyjdingzhia_force0", nil, 100);
                    
                    local modify_force = cm:modify_model():get_modify_military_force(hlyjdingzhia:military_force());
                    
                    ModLog("debug: trigger is_kafka_mission_15_"..hlyjdingzhia:command_queue_index());
                    
                    local modify_character_1 = cm:modify_faction("xyyhlyjf"):create_character_from_template("general", "3k_general_wood", "3k_xyy_template_scripted_xyyhlyjf_wood_strong_late", false);
                    local modify_character_2 = cm:modify_faction("xyyhlyjf"):create_character_from_template("general", "3k_general_fire", "3k_xyy_template_scripted_xyyhlyjf_fire_strong_late", false);    
                    
                    modify_character_1:add_experience(295000,0);
                    modify_character_2:add_experience(295000,0);
                
                    cdir_events_manager:add_or_remove_ceo_from_faction("xyyhlyjf", "hlyjdingzhicwuqi", true);
                    ancillaries:equip_ceo_on_character(modify_character_2:query_character(), "hlyjdingzhicwuqi", "3k_main_ceo_category_ancillary_weapon");
                    
                    cdir_events_manager:add_or_remove_ceo_from_faction("xyyhlyjf", "hlyjdingzhibwuqi", true);
                    ancillaries:equip_ceo_on_character(modify_character_1:query_character(), "hlyjdingzhibwuqi", "3k_main_ceo_category_ancillary_weapon");
                    
                    if modify_force:query_military_force():character_list():num_items() < 3 then
                        modify_force:add_existing_character_as_retinue(modify_character_1, true);
                    end
                    
                    if modify_force:query_military_force():character_list():num_items() < 3 then
                        modify_force:add_existing_character_as_retinue(modify_character_2, true);
                    end
                else
                    cm:teleport_character(hlyjdingzhia, x, y)
                end
                cm:modify_character(hlyjdingzhia):apply_effect_bundle("freeze", -1);
                local log_x = hlyjdingzhia:logical_position_x();
                local log_y = hlyjdingzhia:logical_position_x();
                if 1 then
                    found_pos, x, y = cm:query_faction("xyyhlyjf"):get_valid_spawn_location_near(log_x, log_y, 4, false);
                    
                    if x == 0 or y == 0 then
                        found_pos, x1, y1 = cm:query_faction("xyyhlyjf"):get_valid_spawn_location_in_region(region, false);
                        x = x1;
                        y = y1;
                    end
                    
                    local modify_character_1 = cm:modify_faction("xyyhlyjf"):create_character_from_template("general", "3k_general_wood", "3k_xyy_template_scripted_xyyhlyjf_wood_strong_general", false);
                    
                    modify_character_1:add_experience(295000,0);
                    
                    ModLog(x.." "..y.." "..region)
                    
                    create_force_with_existing_general(modify_character_1, "xyyhlyjf", "", region, x, y, "hlyjdingzhia_force1", nil, 100);
                        
                    if modify_character_1:query_character():has_military_force() then
                        ModLog("debug: trigger is_kafka_mission_15_modify_character_1")
                        local modify_force = cm:modify_model():get_modify_military_force(modify_character_1:query_character():military_force());
                        
                        local modify_character_2 = cm:modify_faction("xyyhlyjf"):create_character_from_template("general", "3k_general_wood", "3k_xyy_template_scripted_xyyhlyjf_wood_strong_late", false);
                        
                        local modify_character_3 = cm:modify_faction("xyyhlyjf"):create_character_from_template("general", "3k_general_fire", "3k_xyy_template_scripted_xyyhlyjf_fire_strong_late", false);    
                        
                        modify_character_2:add_experience(295000,0);
                        modify_character_3:add_experience(295000,0);
                    
                        if modify_force:query_military_force():character_list():num_items() < 3 then
                            modify_force:add_existing_character_as_retinue(modify_character_2, true);
                        end
                        
                        if modify_force:query_military_force():character_list():num_items() < 3 then
                            modify_force:add_existing_character_as_retinue(modify_character_3, true);
                        end
                        cdir_events_manager:add_or_remove_ceo_from_faction("xyyhlyjf", "hlyjdingzhicwuqi", true);
                        ancillaries:equip_ceo_on_character(modify_character_1:query_character(), "hlyjdingzhicwuqi", "3k_main_ceo_category_ancillary_weapon");
                        
                        cdir_events_manager:add_or_remove_ceo_from_faction("xyyhlyjf", "hlyjdingzhibwuqi", true);
                        ancillaries:equip_ceo_on_character(modify_character_2:query_character(), "hlyjdingzhibwuqi", "3k_main_ceo_category_ancillary_weapon");
                        
                        cdir_events_manager:add_or_remove_ceo_from_faction("xyyhlyjf", "hlyjdingzhicwuqi", true);
                        ancillaries:equip_ceo_on_character(modify_character_3:query_character(), "hlyjdingzhicwuqi", "3k_main_ceo_category_ancillary_weapon");
                        
                        modify_character_1:apply_effect_bundle("freeze",-1);
                    end
                end
                
                if 1 then
                    found_pos, x, y = cm:query_faction("xyyhlyjf"):get_valid_spawn_location_near(log_x, log_y, 4, false);
                    
                    if x == 0 or y == 0 then
                        found_pos, x1, y1 = cm:query_faction("xyyhlyjf"):get_valid_spawn_location_in_region(region, false);
                        x = x1;
                        y = y1;
                    end
                    
                    local modify_character_1 = cm:modify_faction("xyyhlyjf"):create_character_from_template("general", "3k_general_fire", "3k_xyy_template_scripted_xyyhlyjf_fire_strong_general", false);
                    modify_character_1:add_experience(295000,0);
                    
                    ModLog(x.." "..y.." "..region)
                    
                    create_force_with_existing_general(modify_character_1, "xyyhlyjf", "", region, x, y, "hlyjdingzhia_force2", nil, 100);
                        
                    if modify_character_1:query_character():has_military_force() then
                        ModLog("debug: trigger is_kafka_mission_15_modify_character_2")
                        
                        local modify_force = cm:modify_model():get_modify_military_force(modify_character_1:query_character():military_force());
                        
                        local modify_character_2 = cm:modify_faction("xyyhlyjf"):create_character_from_template("general", "3k_general_wood", "3k_xyy_template_scripted_xyyhlyjf_wood_strong_late", false);
                        
                        local modify_character_3 = cm:modify_faction("xyyhlyjf"):create_character_from_template("general", "3k_general_fire", "3k_xyy_template_scripted_xyyhlyjf_fire_strong_late", false);    
                        
                        modify_character_2:add_experience(295000,0);
                        modify_character_3:add_experience(295000,0);
                                    
                        if modify_force:query_military_force():character_list():num_items() < 3 then
                            modify_force:add_existing_character_as_retinue(modify_character_2, true);
                        end
                        
                        if modify_force:query_military_force():character_list():num_items() < 3 then
                            modify_force:add_existing_character_as_retinue(modify_character_3, true);
                        end
                        
                        cdir_events_manager:add_or_remove_ceo_from_faction("xyyhlyjf", "hlyjdingzhibwuqi", true);
                        ancillaries:equip_ceo_on_character(modify_character_1:query_character(), "hlyjdingzhibwuqi", "3k_main_ceo_category_ancillary_weapon");
                        
                        cdir_events_manager:add_or_remove_ceo_from_faction("xyyhlyjf", "hlyjdingzhicwuqi", true);
                        ancillaries:equip_ceo_on_character(modify_character_2:query_character(), "hlyjdingzhicwuqi", "3k_main_ceo_category_ancillary_weapon");
                        
                        cdir_events_manager:add_or_remove_ceo_from_faction("xyyhlyjf", "hlyjdingzhibwuqi", true);
                        ancillaries:equip_ceo_on_character(modify_character_3:query_character(), "hlyjdingzhibwuqi", "3k_main_ceo_category_ancillary_weapon");
                        
                        modify_character_1:apply_effect_bundle("freeze",-1);
                    end
                end
                
                if 1 then
                    found_pos, x, y = cm:query_faction("xyyhlyjf"):get_valid_spawn_location_near(log_x, log_y, 5, false);
                    
                    if x == 0 or y == 0 then
                        found_pos, x1, y1 = cm:query_faction("xyyhlyjf"):get_valid_spawn_location_in_region(region, false);
                        x = x1;
                        y = y1;
                    end
                    
                    local modify_character_1 = cm:modify_faction("xyyhlyjf"):create_character_from_template("general", "3k_general_metal", "3k_xyy_template_scripted_xyyhlyjf_metal_strong_general", false);
                    modify_character_1:add_experience(295000,0);
                    
                    ModLog(x.." "..y.." "..region)
                    
                    create_force_with_existing_general(modify_character_1, "xyyhlyjf", "", region, x, y, "hlyjdingzhia_force3", nil, 100);
                        
                    if modify_character_1:query_character():has_military_force() then
                        ModLog("debug: trigger is_kafka_mission_15_modify_character_3")
                        local modify_force = cm:modify_model():get_modify_military_force(modify_character_1:query_character():military_force());
                        
                        local modify_character_2 = cm:modify_faction("xyyhlyjf"):create_character_from_template("general", "3k_general_wood", "3k_xyy_template_scripted_xyyhlyjf_wood_strong_late", false);
                        
                        local modify_character_3 = cm:modify_faction("xyyhlyjf"):create_character_from_template("general", "3k_general_fire", "3k_xyy_template_scripted_xyyhlyjf_fire_strong_late", false);    
                        
                        modify_character_2:add_experience(295000,0);
                        modify_character_3:add_experience(295000,0);
                                    
                        if modify_force:query_military_force():character_list():num_items() < 3 then
                            modify_force:add_existing_character_as_retinue(modify_character_2, true);
                        end
                        
                        if modify_force:query_military_force():character_list():num_items() < 3 then
                            modify_force:add_existing_character_as_retinue(modify_character_3, true);
                        end
                        
                        cdir_events_manager:add_or_remove_ceo_from_faction("xyyhlyjf", "hlyjdingzhicwuqi", true);
                        ancillaries:equip_ceo_on_character(modify_character_1:query_character(), "hlyjdingzhicwuqi", "3k_main_ceo_category_ancillary_weapon");
                        
                        cdir_events_manager:add_or_remove_ceo_from_faction("xyyhlyjf", "hlyjdingzhibwuqi", true);
                        ancillaries:equip_ceo_on_character(modify_character_2:query_character(), "hlyjdingzhibwuqi", "3k_main_ceo_category_ancillary_weapon");
                        
                        cdir_events_manager:add_or_remove_ceo_from_faction("xyyhlyjf", "hlyjdingzhibwuqi", true);
                        ancillaries:equip_ceo_on_character(modify_character_3:query_character(), "hlyjdingzhibwuqi", "3k_main_ceo_category_ancillary_weapon");
                        
                        modify_character_1:apply_effect_bundle("freeze",-1);
                    end
                end
                
                if 1 then
                    found_pos, x, y = cm:query_faction("xyyhlyjf"):get_valid_spawn_location_near(log_x, log_y, 6, false);
                    
                    if x == 0 or y == 0 then
                        found_pos, x1, y1 = cm:query_faction("xyyhlyjf"):get_valid_spawn_location_in_region(region, false);
                        x = x1;
                        y = y1;
                    end
                    
                    local modify_character_1 = cm:modify_faction("xyyhlyjf"):create_character_from_template("general", "3k_general_wood", "3k_xyy_template_scripted_xyyhlyjf_wood_strong_general", false);
                    modify_character_1:add_experience(295000,0);
                    
                    ModLog(x.." "..y.." "..region)
                    
                    create_force_with_existing_general(modify_character_1, "xyyhlyjf", "", region, x, y, "hlyjdingzhia_force4", nil, 100);
                        
                    if modify_character_1:query_character():has_military_force() then
                        ModLog("debug: trigger is_kafka_mission_15_modify_character_4")
                        local modify_force = cm:modify_model():get_modify_military_force(modify_character_1:query_character():military_force());
                        
                        local modify_character_2 = cm:modify_faction("xyyhlyjf"):create_character_from_template("general", "3k_general_wood", "3k_xyy_template_scripted_xyyhlyjf_wood_strong_late", false);
                        
                        local modify_character_3 = cm:modify_faction("xyyhlyjf"):create_character_from_template("general", "3k_general_fire", "3k_xyy_template_scripted_xyyhlyjf_fire_strong_late", false);    
                        
                        modify_character_2:add_experience(295000,0);
                        modify_character_3:add_experience(295000,0);
                                    
                        if modify_force:query_military_force():character_list():num_items() < 3 then
                            modify_force:add_existing_character_as_retinue(modify_character_2, true);
                        end
                        
                        if modify_force:query_military_force():character_list():num_items() < 3 then
                            modify_force:add_existing_character_as_retinue(modify_character_3, true);
                        end
                        
                        cdir_events_manager:add_or_remove_ceo_from_faction("xyyhlyjf", "hlyjdingzhibwuqi", true);
                        ancillaries:equip_ceo_on_character(modify_character_1:query_character(), "hlyjdingzhibwuqi", "3k_main_ceo_category_ancillary_weapon");
                        
                        cdir_events_manager:add_or_remove_ceo_from_faction("xyyhlyjf", "hlyjdingzhibwuqi", true);
                        ancillaries:equip_ceo_on_character(modify_character_2:query_character(), "hlyjdingzhibwuqi", "3k_main_ceo_category_ancillary_weapon");
                        
                        cdir_events_manager:add_or_remove_ceo_from_faction("xyyhlyjf", "hlyjdingzhibwuqi", true);
                        ancillaries:equip_ceo_on_character(modify_character_3:query_character(), "hlyjdingzhibwuqi", "3k_main_ceo_category_ancillary_weapon");
                        
                        modify_character_1:apply_effect_bundle("freeze",-1);
                    end
                end
            end
            
            if not cm:get_saved_value("is_kafka_leaved") then
                cm:trigger_mission(context:faction(), "kafka_mission_15",true);
            else
                cm:trigger_mission(context:faction(), "kafka_mission_15_a",true);
            end
        end
        if cm:get_saved_value("kafka_mission_07_2_incident") then
            ModLog("debug: trigger kafka_mission_07_2_incident")
            cm:set_saved_value("kafka_mission_07_2_incident",false);
            cm:trigger_incident(context:faction():name(),"kafka_mission_07_2_incident", true);
        end
        if cm:get_saved_value("kafka_mission_05_cancel") then
            cm:set_saved_value("kafka_mission_05_cancel", false);
            local hlyjdingzhia = cm:query_model():character_for_template("hlyjdingzhia");
            local xyyhlyjf = cm:query_faction("xyyhlyjf");
            found_pos, x, y = cm:query_faction("xyyhlyjf"):get_valid_spawn_location_in_region(xyyhlyjf:capital_region():name(), false);
            cm:create_force_with_existing_general(hlyjdingzhia:command_queue_index(), "xyyhlyjf", "", xyyhlyjf:capital_region():name(), x, y, "hlyjdingzhia_force5", nil, 100);
            
            ModLog("debug: trigger is_kafka_mission_15" .. xyyhlyjf:capital_region():name() )
            local modify_force = cm:modify_model():get_modify_military_force(hlyjdingzhia:military_force());
            
            local modify_character_1 = cm:modify_faction("xyyhlyjf"):create_character_from_template("general", "3k_general_wood", "3k_xyy_template_scripted_xyyhlyjf_wood_strong_late", false);
            local modify_character_2 = cm:modify_faction("xyyhlyjf"):create_character_from_template("general", "3k_general_fire", "3k_xyy_template_scripted_xyyhlyjf_fire_strong_late", false);    
            
            modify_character_1:add_experience(295000,0);
            modify_character_2:add_experience(295000,0);
            
            modify_force:add_existing_character_as_retinue(modify_character_1, true);
            modify_force:add_existing_character_as_retinue(modify_character_2, true);
            
            if cm:query_model():campaign_name() == "3k_main_campaign_map" then
                cm:trigger_mission(context:faction(), "kafka_mission_05", true)
            elseif cm:query_model():campaign_name() == "3k_dlc04_start_pos" then
                cm:trigger_mission(context:faction(), "kafka_mission_05_dlc04", true)
            elseif cm:query_model():campaign_name() == "3k_dlc05_start_pos" then
                cm:trigger_mission(context:faction(), "kafka_mission_05_dlc05", true)
            elseif cm:query_model():campaign_name() == "3k_dlc07_start_pos" then
                cm:trigger_mission(context:faction(), "kafka_mission_05_dlc07", true)
            end
        end 
        
        --幻胧死后的事件（玩家回合）
        if xyyhlyjf and not xyyhlyjf:is_dead() then
            local hlyjdingzhia = cm:query_model():character_for_template("hlyjdingzhia");
            if
            cm:get_saved_value("huanlong_dead") 
            or hlyjdingzhia:is_dead() 
            then
                if not hlyjdingzhia:is_dead() then
                    cm:modify_character(hlyjdingzhia):kill_character(false);
                elseif not cm:get_saved_value("huanlong_dead") then
                    cm:set_saved_value("huanlong_dead",true)
                end
                ModLog("huanlong_dead")
                local region_list = xyyhlyjf:region_list();
                local character_list = xyyhlyjf:character_list();
                cm:modify_character(hlyjdingzhia):kill_character(false);
                for i = 0 , region_list:num_items() - 1 do
                    local region = region_list:item_at(i);
                    ModLog(region:name());
                    cm:modify_region(region:name()):raze_and_abandon_settlement_without_attacking();
                end
                xyy_set_region_manager("3k_main_shoufang_capital","3k_dlc04_faction_rebels");
                diplomacy_manager:force_confederation("3k_dlc04_faction_rebels", "xyyhlyjf");
                return
            end
        end
        
        --任务中止后重新触发追杀停云任务
        local hlyjdingzhie = cm:query_model():character_for_template("hlyjdingzhie");
        if hlyjdingzhie
        and not hlyjdingzhie:is_null_interface()
        and not hlyjdingzhie:is_dead()
        and hlyjdingzhie:faction():name() == "xyyhlyjf"
        and not cm:get_saved_value("hlyjdingzhie_has_been_killed")
        and not context:faction():is_mission_active("kafka_mission_12_a")
        then
            if hlyjdingzhie:has_military_force() then
                xyy_set_minister_position("hlyjdingzhie","faction_leader");
                if not context:faction():is_mission_active("kafka_mission_12_a") then
                    cm:trigger_mission(context:faction(),"kafka_mission_12_a", true);
                end
                xyy_set_minister_position("hlyjdingzhia","faction_leader");
            else
                cm:set_saved_value("kafka_mission_12_a", true)
            end
        end
    end,
    true
)


core:add_listener(
    "kafka_mission_02_success",
    "MissionSucceeded",
    function(context)
        return context:mission():mission_record_key() == "kafka_mission_02" or context:mission():mission_record_key() == "kafka_mission_02_dlc04" or context:mission():mission_record_key() == "kafka_mission_02_dlc05" or context:mission():mission_record_key() == "kafka_mission_02_dlc07";
    end,
    function(context)
        cm:modify_model():get_modify_episodic_scripting():register_instant_movie_by_record("3k_main_game_lost_yuan_shao");
        cm:trigger_dilemma(context:faction():name(),"kafka_mission_02_choice", true);
        ModLog(cm:query_model():campaign_name())
    end,
    false
)

core:add_listener(
    "kafka_mission_02_dilemma",
    "DilemmaChoiceMadeEvent",
    function(context) 
        return context:dilemma() == "kafka_mission_02_choice" and context:choice() == 0 or context:choice() == 1 
    end, -- criteria
    function (context) --what to do if listener fires
        local query_faction = cm:query_local_faction();
        if context:choice() == 0 then
            if cm:query_model():campaign_name() == "3k_main_campaign_map" then
                cm:trigger_mission(context:faction(), "kafka_mission_02_a", true)
            elseif cm:query_model():campaign_name() == "3k_dlc04_start_pos" then
                cm:trigger_mission(context:faction(), "kafka_mission_02_a_dlc04", true)
            elseif cm:query_model():campaign_name() == "3k_dlc05_start_pos" then
                cm:trigger_mission(context:faction(), "kafka_mission_02_a_dlc05", true)
            elseif cm:query_model():campaign_name() == "3k_dlc07_start_pos" then
                cm:trigger_mission(context:faction(), "kafka_mission_02_a_dlc07", true)
            end
        end
        if context:choice() == 1 then
            if cm:query_model():campaign_name() == "3k_main_campaign_map" then
                cm:trigger_mission(context:faction(), "kafka_mission_04", true)
            elseif cm:query_model():campaign_name() == "3k_dlc04_start_pos" then
                cm:trigger_mission(context:faction(), "kafka_mission_04_dlc04", true)
            elseif cm:query_model():campaign_name() == "3k_dlc05_start_pos" then
                cm:trigger_mission(context:faction(), "kafka_mission_04_dlc05", true)
            elseif cm:query_model():campaign_name() == "3k_dlc07_start_pos" then
                cm:trigger_mission(context:faction(), "kafka_mission_04_dlc07", true)
            end
        end
    end,   
    false
)

core:add_listener(
    "kafka_mission_02_a_success",
    "MissionSucceeded",
    function(context)
        return 
        context:mission():mission_record_key() == "kafka_mission_02_a" 
        or context:mission():mission_record_key() == "kafka_mission_02_a_dlc04" 
        or context:mission():mission_record_key() == "kafka_mission_02_a_dlc05" 
        or context:mission():mission_record_key() == "kafka_mission_02_a_dlc07" 
        or context:mission():mission_record_key() == "kafka_mission_02_a_fallback";
    end,
    function(context)
        --{spawn_region = "3k_main_shoufang_resource_2", x_pos = 186, y_pos = 466}
        
        local faction_key = context:faction():name();
        if not faction_key then
            faction_key = cm:query_local_faction():name();
        end
        ModLog(faction_key);
        local invasion_faction_key = "3k_dlc04_faction_rebels";
        
        diplomacy_manager:apply_automatic_deal_between_factions(invasion_faction_key, faction_key, "data_defined_situation_war_proposer_to_recipient")
        
        campaign_invasions:create_invasion_attack_region("3k_dlc04_faction_rebels", "3k_main_shoufang_resource_2", 4, "3k_main_shoufang_resource_2", false, 248, 595);
        
        cm:modify_faction(cm:query_local_faction():name()):make_region_seen_in_shroud("3k_main_shoufang_resource_2");
        
        cm:scroll_camera_from_current(8, true, {166, 459, 14, -2, 11});

        cm:trigger_mission(context:faction(),"kafka_mission_03", true);
    end,
    false
)

core:add_listener(
    "kafka_mission_03_success",
    "MissionSucceeded",
    function(context)
        return context:mission():mission_record_key() == "kafka_mission_03";
    end,
    function(context)
        local kafka = cm:query_model():character_for_template("hlyjcj");
        incident = cm:modify_model():create_incident("kafka_mission_03_complete");
        incident:add_character_target("target_character_1", kafka);
        incident:add_faction_target("target_faction_1", context:faction());
        incident:trigger(cm:modify_faction(context:faction()), true);
        xyy_ticket_points_add(10);
    end,
    false
)

core:add_listener(
    "kafka_mission_03_failed",
    "MissionFailed",
    function(context)
        return context:mission():mission_record_key() == "kafka_mission_03";
    end,
    function(context)
        cm:trigger_mission(context:faction(),"kafka_mission_03", true);
    end,
    false
)

core:add_listener(
    "kafka_mission_04_success",
    "MissionSucceeded",
    function(context)
        return context:mission():mission_record_key() == "kafka_mission_04" or context:mission():mission_record_key() == "kafka_mission_04_dlc04" or context:mission():mission_record_key() == "kafka_mission_04_dlc05" or context:mission():mission_record_key() == "kafka_mission_04_dlc07";
    end,
    function(context)
        cm:set_saved_value("kafka_mission_ready_to_summon_huanlong",0);
    end,
    false
)

core:add_listener(
    "kafka_mission_summon_huanlong",
    "IncidentOccuredEvent",
    function(context)
        return context:incident() == "kafka_mission_summon_huanlong";
    end,
    function(context)
        local mission = string_mission:new("kafka_mission_huanlong");
        mission:add_primary_objective("DESTROY_FACTION", {"faction xyyhlyjf"});
        mission:add_primary_payload("text_display{lookup dummy_game_victory;}");
        local randomint = cm:random_int(42, 38);
        mission:set_turn_limit(randomint);
        mission:trigger_mission_for_faction(context:faction():name());
        cm:set_saved_value("kafka_mission_summon_huanlong",0);
        cm:modify_character(context:faction():faction_leader()):apply_effect_bundle("character_captives_escape_force",-1);
        cm:modify_character(cm:query_model():character_for_template("hlyjcj")):apply_effect_bundle("character_captives_escape_force",-1);
    end,
    false
)

core:add_listener(
    "kafka_mission_05_start",
    "MissionIssued",
    function(context)
        return 
        context:mission():mission_record_key() == "kafka_mission_05"
        or context:mission():mission_record_key() == "kafka_mission_05_dlc04"
        or context:mission():mission_record_key() == "kafka_mission_05_dlc05"
        or context:mission():mission_record_key() == "kafka_mission_05_dlc07";
    end,
    function(context)
        ModLog("debug: kafka_mission_05_start")
        cm:modify_character(context:faction():faction_leader()):apply_effect_bundle("character_captives_escape_force",-1);
        cm:modify_character(cm:query_model():character_for_template("hlyjcj")):apply_effect_bundle("character_captives_escape_force",-1);
    end,
    false
)

core:add_listener(
    "kafka_mission_05_cancel",
    "MissionCancelled",
    function(context)
        return 
        context:mission():mission_record_key() == "kafka_mission_05"
        or context:mission():mission_record_key() == "kafka_mission_05_dlc04"
        or context:mission():mission_record_key() == "kafka_mission_05_dlc05"
        or context:mission():mission_record_key() == "kafka_mission_05_dlc07";
    end,
    function(context)
        ModLog("debug: kafka_mission_05_cancel")
        cm:set_saved_value("kafka_mission_05_cancel",true);
    end,
    false
)

core:add_listener(
    "kafka_mission_05_success",
    "MissionSucceeded",
    function(context)
        return 
        context:mission():mission_record_key() == "kafka_mission_05"
        or context:mission():mission_record_key() == "kafka_mission_05_dlc04"
        or context:mission():mission_record_key() == "kafka_mission_05_dlc05"
        or context:mission():mission_record_key() == "kafka_mission_05_dlc07";
    end,
    function(context)
        cm:trigger_mission(context:faction(),"kafka_mission_05_a", true);
        local leader = cm:query_model():character_for_template(cm:get_saved_value("kafka_mission_leader"));
        local modify_hlyjdingzhia = cm:modify_character(cm:query_model():character_for_template("hlyjdingzhia"));
        
        modify_hlyjdingzhia:remove_effect_bundle("freeze");
        modify_hlyjdingzhia:replenish_action_points();
        modify_hlyjdingzhia:attack(kafka);
        
--         local kafka = cm:query_model():character_for_template("hlyjcj")
--         local kafka_force = cm:query_model():get_modify_military_force(kafka:military_force())
--         kafka_force:set_retreated();
        
    end,
    false
)

core:add_listener(
    "kafka_mission_05_BattleCompleted",
    "BattleCompleted",
    function(context)
        if not cm:get_saved_value("kafka_mission_leader") then
            return false
        end
        local leader = cm:query_model():character_for_template(cm:get_saved_value("kafka_mission_leader"));
        local faction = leader:faction();
        return faction:has_mission_been_issued("kafka_mission_05_a") and not cm:get_saved_value("summon_hlyjdingzhie");
        --return false;
    end,
    function(context)
        local pb = cm:query_model():pending_battle();
        local leader = cm:query_model():character_for_template(cm:get_saved_value("kafka_mission_leader"));
        local kafka = cm:query_model():character_for_template("hlyjcj");
        local faction = leader:faction();
        
        if pb:has_attacker() then
            ModLog(pb:attacker():generation_template_key() .. " " .. pb:attacker():faction():name())
        end
        
        if pb:has_defender() then
            ModLog(pb:defender():generation_template_key() .. " " .. pb:defender():faction():name())
        end
        
        if pb:has_attacker() 
        and pb:attacker():faction():name() == "xyyhlyjf" then 
            if pb:has_defender() and pb:defender():generation_template_key() == "hlyjcj"
            then
                if not kafka:won_battle() then
                    if faction:is_mission_active("kafka_mission_05_a") then
                        cm:modify_faction(faction):cancel_custom_mission("kafka_mission_05_a")
                    end
                    ModLog("loose battle")
                    incident = cm:modify_model():create_incident("kafka_mission_06");
                    incident:add_character_target("target_character_1", leader);
                    incident:trigger(cm:modify_faction(faction), true);
                    return;
                end
                ModLog("win battle")
            end
            if pb:has_defender() and pb:defender():generation_template_key() == cm:get_saved_value("kafka_mission_leader")
            then
                if not leader:won_battle() then
                    if faction:is_mission_active("kafka_mission_05_a") then
                        cm:modify_faction(faction):cancel_custom_mission("kafka_mission_05_a")
                    end
                    ModLog("loose battle")
                    incident = cm:modify_model():create_incident("kafka_mission_06");
                    incident:add_character_target("target_character_1", leader);
                    incident:trigger(cm:modify_faction(faction), true);
                    return;
                end
                ModLog("win battle")
            end
            ModLog("no defender")
        end
        
        if pb:has_defender() 
        and pb:defender():faction():name() == "xyyhlyjf" then 
            if pb:has_attacker() and pb:attacker():generation_template_key() == "hlyjcj"
            then
                if not kafka:won_battle() then
                    if faction:is_mission_active("kafka_mission_05_a") then
                        cm:modify_faction(faction):cancel_custom_mission("kafka_mission_05_a")
                    end
                    ModLog("loose battle")
                    incident = cm:modify_model():create_incident("kafka_mission_06");
                    incident:add_character_target("target_character_1", leader);
                    incident:trigger(cm:modify_faction(faction), true);
                    return;
                end
                ModLog("win battle")
            end
            if pb:has_attacker() and pb:attacker():generation_template_key() == cm:get_saved_value("kafka_mission_leader")
            then
                if not leader:won_battle() then
                    if faction:is_mission_active("kafka_mission_05_a") then
                        cm:modify_faction(faction):cancel_custom_mission("kafka_mission_05_a")
                    end
                    ModLog("loose battle")
                    incident = cm:modify_model():create_incident("kafka_mission_06");
                    incident:add_character_target("target_character_1", leader);
                    incident:trigger(cm:modify_faction(faction), true);
                    return;
                end
                ModLog("win battle")
            end
            ModLog("no attacker")
        end
        
        if cm:get_saved_value("kafka_leader_military_force") then
            local kafka_force = kafka:military_force();
            if not kafka:has_military_force()
            or not kafka_force
            or kafka_force:is_null_interface()
            then
                if (pb:has_attacker() and pb:attacker():faction():name() == "xyyhlyjf")
                or (pb:has_defender() and pb:defender():faction():name() == "xyyhlyjf")
                then
                    ModLog("kafka loose battle")
                    incident = cm:modify_model():create_incident("kafka_mission_06");
                    incident:add_character_target("target_character_1", leader);
                    incident:trigger(cm:modify_faction(faction), true);
                end
            end
            cm:set_saved_value("kafka_leader_military_force", false)
        end
    end,
    true
)

core:add_listener(
    "kafka_mission_05_a",
    "MissionSucceeded",
    function(context)
        return 
        context:mission():mission_record_key() == "kafka_mission_05_a" 
        and not cm:get_saved_value("summon_hlyjdingzhie");
    end,
    function(context)
        local pb = cm:query_model():pending_battle();
        local leader = cm:query_model():character_for_template(cm:get_saved_value("kafka_mission_leader"));
        local kafka = cm:query_model():character_for_template("hlyjcj");
        local faction = leader:faction();
        
        if pb:has_attacker() then
            ModLog(pb:attacker():generation_template_key() .. " " .. pb:attacker():faction():name())
        end
        
        if pb:has_defender() then
            ModLog(pb:defender():generation_template_key() .. " " .. pb:defender():faction():name())
        end
        
        if pb:has_attacker() 
        and pb:attacker():faction():name() == "xyyhlyjf" then 
            if pb:has_defender() and pb:defender():generation_template_key() == "hlyjcj"
            then
                if not kafka:won_battle() then
                    ModLog("loose battle")
                    incident = cm:modify_model():create_incident("kafka_mission_06");
                    incident:add_character_target("target_character_1", leader);
                    incident:trigger(cm:modify_faction(faction), true);
                    return;
                end
                ModLog("win battle")
            end
            if pb:has_defender() and pb:defender():generation_template_key() == cm:get_saved_value("kafka_mission_leader")
            then
                if not leader:won_battle() then
                    ModLog("loose battle")
                    incident = cm:modify_model():create_incident("kafka_mission_06");
                    incident:add_character_target("target_character_1", leader);
                    incident:trigger(cm:modify_faction(faction), true);
                    return;
                end
                ModLog("win battle")
            end
            ModLog("no defender")
        end
        
        if pb:has_defender() 
        and pb:defender():faction():name() == "xyyhlyjf" then 
            if pb:has_attacker() and pb:attacker():generation_template_key() == "hlyjcj"
            then
                if not kafka:won_battle() then
                    ModLog("loose battle")
                    incident = cm:modify_model():create_incident("kafka_mission_06");
                    incident:add_character_target("target_character_1", leader);
                    incident:trigger(cm:modify_faction(faction), true);
                    return;
                end
                ModLog("win battle")
            end
            if pb:has_attacker() and pb:attacker():generation_template_key() == cm:get_saved_value("kafka_mission_leader")
            then
                if not leader:won_battle() then
                    ModLog("loose battle")
                    incident = cm:modify_model():create_incident("kafka_mission_06");
                    incident:add_character_target("target_character_1", leader);
                    incident:trigger(cm:modify_faction(faction), true);
                    return;
                end
                ModLog("win battle")
            end
            ModLog("no attacker")
        end
        
        if cm:get_saved_value("kafka_leader_military_force") then
            local kafka_force = hlyjcj:military_force();
            if not hlyjcj:has_military_force()
            or not kafka_force
            or kafka_force:is_null_interface()
            then
                if (pb:has_attacker() and pb:attacker():faction():name() == "xyyhlyjf")
                or (pb:has_defender() and pb:defender():faction():name() == "xyyhlyjf")
                then
                    ModLog("loose battle")
                    incident = cm:modify_model():create_incident("kafka_mission_06");
                    incident:add_character_target("target_character_1", leader);
                    incident:trigger(cm:modify_faction(faction), true);
                end
            end
            cm:set_saved_value("kafka_leader_military_force", false)
        end
    end,
    false
)

core:add_listener(
    "leader_dead",
    "CharacterDied",
    function(context)
        return cm:get_saved_value("kafka_mission_leader") and context:query_character():generation_template_key() == cm:get_saved_value("kafka_mission_leader");
    end,
    function(context)
        cm:set_saved_value("leader_dead",true);
    end,
    true
)

core:add_listener(
    "kafka_defected",
    "CharacterDefectedEvent",
    function(context)
        return context:query_character():generation_template_key() == "hlyjcj";
    end,
    function(context)
        ModLog("卡芙卡叛逃")
    end,
    true
)

core:add_listener(
    "kafka_mission_06",
    "IncidentOccuredEvent",
    function(context)
        return context:incident() == "kafka_mission_06";
    end,
    function(context)
        --xyy_character_add(cm:get_saved_value("kafka_mission_leader"), context:faction():name(), leader:character_subtype_key());
        --xyy_set_minister_position(cm:get_saved_value("kafka_mission_leader"),"faction_leader");
        cm:modify_character(context:faction():faction_leader()):remove_effect_bundle("character_captives_escape_force");
        cm:modify_character(cm:query_model():character_for_template("hlyjcj")):remove_effect_bundle("character_captives_escape_force");
        cm:set_saved_value("summon_hlyjdingzhie",0);
    end,
    false
)


core:add_listener(
    "kafka_mission_06_choice",
    "DilemmaChoiceMadeEvent",
    function(context) 
        return context:dilemma() == "kafka_mission_06_choice" and (context:choice() == 0 or context:choice() == 1);
    end, -- criteria
    function (context) --what to do if listener fires
        local query_faction = cm:query_local_faction();
        if context:choice() == 0 then
        end
        if context:choice() == 1 then
            local tingyun = xyy_character_add("hlyjdingzhie", context:faction():name(), "3k_general_water")
            local kafka = cm:query_model():character_for_template("hlyjcj");
            cm:modify_character(tingyun):apply_relationship_trigger_set(kafka, "3k_main_relationship_trigger_set_event_negative_generic_extreme");
            cm:modify_character(tingyun):apply_relationship_trigger_set(kafka, "3k_main_relationship_trigger_set_event_negative_dilemma_extreme");
            cm:modify_character(tingyun):apply_relationship_trigger_set(kafka, "3k_main_relationship_trigger_set_event_negative_bad_omen");
        end
    end,   
    false
)

core:add_listener(
    "hlyjdingzhie_join_event",
    "ActiveCharacterCreated",
    function(context) 
        return context:query_character():generation_template_key() == "hlyjdingzhie";
    end,
    function (context)
        local tingyun = context:query_character()
        incident = cm:modify_model():create_incident("summon_hlyjdingzhie");
        incident:add_character_target("target_character_1", tingyun);
        incident:add_faction_target("target_faction_1", context:query_character():faction());
        incident:trigger(cm:modify_faction(context:query_character():faction()), true);
        xyy_character_close_agent("hlyjdingzhie");
    end,   
    false
)
 

core:add_listener(
    "kafka_mission_07_choice",
    "DilemmaChoiceMadeEvent",
    function(context)
        return context:dilemma() ==  "kafka_mission_07_choice" ;
    end,
    function(context)
        if context:choice() == 0 then
            cm:trigger_mission(context:faction(),"kafka_mission_07", true);
        end
    end,
    false
)

core:add_listener(
    "kafka_mission_07_1_choice",
    "DilemmaChoiceMadeEvent",
    function(context)
        return context:dilemma() ==  "kafka_mission_07_1_choice" ;
    end,
    function(context)
        if context:choice() == 1 then
            cm:set_saved_value("kafka_mission_07_2_incident", true)
        end
    end,
    false
)

core:add_listener(
    "kafka_mission_07_3_choice",
    "DilemmaChoiceMadeEvent",
    function(context)
        return context:dilemma() ==  "kafka_mission_07_3_choice" ;
    end,
    function(context)
        if context:choice() == 0 then
            ModLog("debug: kafka_mission_07_3_choice = 0")
            cm:modify_faction(context:faction()):ceo_management():add_ceo("hlyjdingzhibzuoqi")
            cm:trigger_mission(context:faction(),"kafka_mission_07_3", true);
        else
            ModLog("debug: kafka_mission_07_3_choice = 1")
            ModLog("debug: set kafka_mission_07_choice, true")
            cm:set_saved_value("kafka_mission_07_choice",true);
        end
    end,
    false
)

core:add_listener(
    "kafka_mission_07_3_success",
    "MissionSucceeded",
    function(context)
        return context:mission():mission_record_key() == "kafka_mission_07_3";
    end,
    function(context)
        ModLog("debug: set kafka_mission_07_choice, true")
        cm:set_saved_value("kafka_mission_07_choice",true);
        ModLog("debug: set is_kafka_have_horse, true")
        cm:set_saved_value("is_kafka_have_horse",true);
    end,
    false
)

core:add_listener(
    "hlyjdingzhie_joins", -- Unique handle
    "ActiveCharacterCreated", -- Campaign Event to listen for
    function(context) -- Criteria
        if context:query_character():generation_template_key() == "hlyjdingzhie" then
            return true
        end
    end,
    function(context)
        xyy_character_close_agent("hlyjdingzhie");
        cm:modify_character(context:query_character()):ceo_management():add_ceo("3k_ytr_ceo_trait_personality_heaven_tranquil");
    end,
    true --Is persistent
)

core:add_listener(
    "kafka_mission_08_incident",
    "IncidentOccuredEvent",
    function(context)
        return context:incident() == "kafka_mission_08_incident";
    end,
    function(context)
        local mission = string_mission:new("kafka_mission_08");
		mission:add_primary_objective("CONTROL_N_REGIONS_INCLUDING", {"total 2","region 3k_main_changan_capital", "region 3k_main_changan_resource_1"});
		mission:add_primary_payload("money 5000");
		--mission:set_turn_limit(40);
		mission:trigger_mission_for_faction(context:faction():name());
-- 		trigger_kafka_mission_05(context:faction():name());
        
        xyy_set_minister_position("hlyjdingzhid","faction_leader");
        cm:trigger_mission(context:faction(),"kafka_mission_09", true);
        xyy_set_minister_position("hlyjdingzhia","faction_leader");
    end,
    false
)

core:add_listener(
    "kafka_mission_09_success",
    "MissionSucceeded",
    function(context)
        return context:mission():mission_record_key() == "kafka_mission_09";
    end,
    function(context)
        local general = cm:query_model():character_for_template("hlyjdingzhid");
        if not general:has_garrison_residence() then
            cm:modify_character(general):kill_character(false);
        end
        cm:set_saved_value("kill_character_hlyjdingzhid",true);
        xyy_ticket_points_add(10);
--         incident = cm:modify_model():create_incident("kafka_mission_09_incident");
--         incident:add_character_target("target_character_1", hlyjdingzhia);
--         incident:add_faction_target("target_faction_1", context:faction());
--         incident:trigger(cm:modify_faction(context:faction()), true);
    end,
    false
)

core:add_listener(
    "summon_hlyjby_success",
    "MissionSucceeded",
    function(context)
        return context:mission():mission_record_key() == "summon_hlyjby";
    end,
    function(context)
        xyy_ticket_points_add(5);
    end,
    false
)

core:add_listener(
    "kafka_mission_08_success",
    "MissionSucceeded",
    function(context)
        return context:mission():mission_record_key() == "kafka_mission_08";
    end,
    function(context)
        cm:trigger_dilemma(context:faction():name(),"kafka_mission_09_dilemma", true);
    end,
    false
)

core:add_listener(
    "kafka_mission_09_failed",
    "MissionFailed ",
    function(context)
        return context:mission():mission_record_key() == "kafka_mission_09";
    end,
    function(context)
        cm:set_saved_value("kafka_mission_09",true);
    end,
    true
)

core:add_listener(
    "kafka_mission_09_cancel",
    "MissionCancelled ",
    function(context)
        return context:mission():mission_record_key() == "kafka_mission_09";
    end,
    function(context)
        cm:set_saved_value("kafka_mission_09",true);
    end,
    false
)

core:add_listener(
    "kafka_mission_10_a_incident",
    "IncidentOccuredEvent",
    function(context)
        return context:incident() == "kafka_mission_10_a_incident";
    end,
    function(context)
        local hlyjdingzhie = cm:query_model():character_for_template("hlyjdingzhie");
        cm:modify_character(hlyjdingzhie):move_to_faction_and_make_recruited("xyyhlyjf")
        
        cm:set_saved_value("kafka_mission_10_a_incident", true);
        
        cm:modify_faction(context:faction()):ceo_management():remove_ceos("hlyjdingzhiewuqi")
        xyy_CEO_equip("hlyjdingzhie","hlyjdingzhiewuqi","3k_main_ceo_category_ancillary_weapon");
        cm:modify_character(hlyjdingzhie):apply_relationship_trigger_set(context:faction():faction_leader(), "3k_main_relationship_trigger_set_event_negative_betrayed");
        
        
    end,
    false
)

core:add_listener(
    "kafka_mission_11_a_dilemma",
    "DilemmaChoiceMadeEvent",
    function(context)
        return context:dilemma() ==  "kafka_mission_11_a_dilemma" and context:choice() == 0;
    end,
    function(context)
        local hlyjdingzhie = cm:query_model():character_for_template("hlyjdingzhie");
        if not hlyjdingzhie:has_military_force() or not hlyjdingzhie:military_force() then
            local xyyhlyjf = cm:query_faction("xyyhlyjf");
            found_pos, x, y = xyyhlyjf:get_valid_spawn_location_in_region(xyyhlyjf:capital_region():name(), false);
            cm:create_force_with_existing_general(hlyjdingzhie:command_queue_index(), "xyyhlyjf", "", xyyhlyjf:capital_region():name(), x, y, "hlyjdingzhie_force", nil, 100);
            
            local modify_force = cm:modify_model():get_modify_military_force(hlyjdingzhie:military_force());
            
            local modify_character_1 = cm:modify_faction("xyyhlyjf"):create_character_from_template("general", "3k_general_wood", "3k_xyy_template_scripted_xyyhlyjf_wood_strong_late", false);
            local modify_character_2 = cm:modify_faction("xyyhlyjf"):create_character_from_template("general", "3k_general_fire", "3k_xyy_template_scripted_xyyhlyjf_fire_strong_late", false);    
            
            modify_character_1:add_experience(295000,0);
            modify_character_2:add_experience(295000,0);
            
            if modify_force:query_military_force():character_list():num_items() < 3 then
                modify_force:add_existing_character_as_retinue(modify_character_1, true);
            end
            if modify_force:query_military_force():character_list():num_items() < 3 then
                modify_force:add_existing_character_as_retinue(modify_character_2, true);
            end
        end
        cm:modify_character(hlyjdingzhie):apply_effect_bundle("freeze", -1);
        
        xyy_set_minister_position("hlyjdingzhie","faction_leader");
        if not context:faction():is_mission_active("kafka_mission_12_a") then
            cm:trigger_mission(context:faction(),"kafka_mission_12_a", true);
        end
        xyy_set_minister_position("hlyjdingzhia","faction_leader");
    end,
    false
)

core:add_listener(
    "kafka_mission_11_b_dilemma",
    "DilemmaChoiceMadeEvent",
    function(context)
        return context:dilemma() ==  "kafka_mission_11_b_dilemma" and context:choice() == 1;
    end,
    function(context)
        cm:trigger_incident(context:faction():name(),"kafka_mission_11_b_incident", true);
    end,
    false
)

core:add_listener(
    "kafka_mission_12_dilemma",
    "DilemmaChoiceMadeEvent",
    function(context)
        return (context:dilemma() ==  "kafka_mission_12_dilemma" or context:dilemma() ==  "kafka_mission_12_a_dilemma") and (context:choice() == 0 or context:choice() == 1);
    end,
    function(context)
        if context:choice() == 0 then
            cm:set_saved_value("kafka_mission_12_a",true);
            cm:set_saved_value("is_kafka_leaved", true);
            cm:trigger_incident(context:faction():name(),"kafka_mission_13_a_incident", true);
            local hlyjdingzhie = xyy_character_add("hlyjdingzhie", "xyyhlyjf", "3k_general_water");
            cm:modify_faction(context:faction()):ceo_management():remove_ceos("hlyjdingzhiewuqi");
            xyy_CEO_equip("hlyjdingzhie","hlyjdingzhiewuqi","3k_main_ceo_category_ancillary_weapon");
            local kafka = cm:query_model():character_for_template("hlyjcj");
            
            xyy_runaway("hlyjcj")
            
            if context:faction():ceo_management():has_ceo_equipped("hlyjcjwuqi") then
                cm:modify_faction(context:faction()):ceo_management():remove_ceos("hlyjcjwuqi");
                xyy_CEO_equip("hlyjcj","hlyjcjwuqi","3k_main_ceo_category_ancillary_weapon");
            end
            
            xyy_random_kill(context:faction():name(),5);
            cm:modify_character(hlyjdingzhie):apply_relationship_trigger_set(context:faction():faction_leader(), "3k_main_relationship_trigger_set_event_negative_betrayed");
            cm:modify_character(kafka):apply_relationship_trigger_set(context:faction():faction_leader(), "3k_main_relationship_trigger_set_event_negative_betrayed");
        elseif context:choice() == 1 then
            cm:trigger_incident(context:faction():name(), "kafka_mission_13_b_incident", true);
            local hlyjdingzhia = cm:query_model():character_for_template("hlyjdingzhia");
            xyy_kill_character("hlyjdingzhie");
            cm:modify_character(hlyjdingzhia):ceo_management():remove_ceos("kafka_mission_complete_01");
            cm:modify_character(hlyjdingzhia):ceo_management():add_ceo("kafka_mission_complete_04");
            cm:modify_faction(context:faction()):ceo_management():remove_ceos("hlyjdingzhiewuqi");
            
            cm:modify_faction(cm:query_faction("xyyhlyjf")):ceo_management():remove_ceos("hlyjdingzhiayifu");
            xyy_CEO_equip("hlyjdingzhia","hlyjdingzhibyifu","3k_main_ceo_category_ancillary_armour");
            
            cm:set_saved_value("hlyjdingzhie_has_been_killed",true);
        end
    end,
    false
)

core:add_listener(
    "kafka_mission_12_a_failed",
    "MissionFailed ",
    function(context)
        return context:mission():mission_record_key() == "kafka_mission_12_a";
    end,
    function(context)
        cm:set_saved_value("kafka_mission_12_a",true);
    end,
    true
)

core:add_listener(
    "kafka_mission_12_a_cancel",
    "MissionCancelled ",
    function(context)
        return context:mission():mission_record_key() == "kafka_mission_12_a";
    end,
    function(context)
        cm:set_saved_value("kafka_mission_12_a",true);
    end,
    true
)

core:add_listener(
    "kafka_mission_12_a_success",
    "MissionSucceeded",
    function(context)
        return context:mission():mission_record_key() == "kafka_mission_12_a";
    end,
    function(context)
        local tingyun = cm:query_model():character_for_template("hlyjdingzhie")
        
        if not tingyun:has_garrison_residence() then
            cm:modify_character(tingyun):kill_character(false);
        end 
        cm:set_saved_value("kill_character_hlyjdingzhie",true);
        cm:set_saved_value("hlyjdingzhie_has_been_killed",true);
    end,
    false
)



core:add_listener(
    "kafka_mission_14_success",
    "MissionSucceeded",
    function(context)
        return 
        context:mission():mission_record_key() == "kafka_mission_14"
        or context:mission():mission_record_key() == "kafka_mission_14_a";
    end,
    function(context)
        local hlyjdingzhia = cm:query_model():character_for_template("hlyjdingzhia");
        local xyyhlyjf = cm:query_faction("xyyhlyjf");
        cm:modify_faction(cm:query_faction("xyyhlyjf")):ceo_management():remove_ceos("hlyjdingzhibyifu");
        xyy_CEO_equip("hlyjdingzhia","hlyjdingzhicyifu","3k_main_ceo_category_ancillary_armour");
        cm:set_saved_value("trigger_kafka_mission_15",true)
    end,
    false
)




core:add_listener(
    "kafka_mission_15_success",
    "MissionSucceeded",
    function(context)
        return context:mission():mission_record_key() == "kafka_mission_15" or context:mission():mission_record_key() == "kafka_mission_15_a";
    end,
    function(context)
        local hlyjdingzhia = cm:query_model():character_for_template("hlyjdingzhia");
        if not hlyjdingzhia:has_garrison_residence() then
            cm:modify_character(hlyjdingzhia):kill_character(false);
        end
        cm:set_saved_value("huanlong_dead",true);
    end,
    false
)





--幻胧剧情线


core:add_listener(
    "xyyhlyjf_listener",
    "FactionTurnStart",
        
    function(context)
        if context:faction():name() == "xyyhlyjf" then
            return true
        end
    end,

    function(context)
        if cm:get_saved_value("kafka_mission_summon_huanlong") then
            ModLog("debug: 幻胧点数 = "..cm:get_saved_value("kafka_mission_summon_huanlong"));
        end
        local world_faction_list = cm:query_model():world():faction_list();
        local player_faction = cm:query_model():character_for_template(cm:get_saved_value("kafka_mission_leader")):faction();
        local xyyhlyjf = cm:query_faction("xyyhlyjf")
        if xyyhlyjf and not xyyhlyjf:is_dead() then
            local hlyjdingzhia = cm:query_model():character_for_template("hlyjdingzhia");
            if cm:get_saved_value("huanlong_dead") 
            or hlyjdingzhia:is_dead() then
                if not hlyjdingzhia:is_dead() then
                    cm:modify_character(hlyjdingzhia):kill_character(false);
                elseif not cm:get_saved_value("huanlong_dead") then
                    cm:set_saved_value("huanlong_dead",true)
                end
                ModLog("huanlong_dead")
                local region_list = xyyhlyjf:region_list();
                local character_list = xyyhlyjf:character_list();
                cm:modify_character(hlyjdingzhia):kill_character(false);
                for i = 0 , region_list:num_items() - 1 do
                    local region = region_list:item_at(i);
                    ModLog(region:name());
                    cm:modify_region(region:name()):raze_and_abandon_settlement_without_attacking();
                end
                xyy_set_region_manager("3k_main_shoufang_capital","3k_dlc04_faction_rebels");
                diplomacy_manager:force_confederation("3k_dlc04_faction_rebels", "xyyhlyjf");
                return
            end
            for i = 0, world_faction_list:num_items() - 1 do
                local q_faction = world_faction_list:item_at(i)
                if not q_faction:is_dead() and q_faction:name() ~= "xyyhlyjf" and not xyyhlyjf:has_specified_diplomatic_deal_with("data_defined_situation_war_proposer_to_recipient", q_faction) then
                    diplomacy_manager:apply_automatic_deal_between_factions("xyyhlyjf", q_faction:name(), "data_defined_situation_war_proposer_to_recipient")
                    ModLog("xyyhlyjf向"..q_faction:name().."宣战了");
                end;
            end;
            if cm:get_saved_value("kill_character_hlyjdingzhid") then
                local hlyjdingzhia = cm:query_model():character_for_template("hlyjdingzhia");
                
                local general = cm:query_model():character_for_template("hlyjdingzhid");
                cm:modify_character(general):kill_character(false);
                
                cm:modify_character(hlyjdingzhia):ceo_management():add_ceo("kafka_mission_complete_03");
                cm:set_saved_value("kill_character_hlyjdingzhid",false)
            end;
            if cm:get_saved_value("kill_character_hlyjdingzhie") then
                local hlyjdingzhie = cm:query_model():character_for_template("hlyjdingzhie");
                cm:modify_character(hlyjdingzhie):kill_character(false);
                    
                cm:modify_character(hlyjdingzhia):ceo_management():remove_ceos("kafka_mission_complete_01");
                cm:modify_character(hlyjdingzhia):ceo_management():add_ceo("kafka_mission_complete_04");
                cm:modify_faction(context:faction()):ceo_management():remove_ceos("hlyjdingzhiewuqi");
                cm:modify_faction(cm:query_faction("xyyhlyjf")):ceo_management():remove_ceos("hlyjdingzhiayifu");
                xyy_CEO_equip("hlyjdingzhia","hlyjdingzhibyifu","3k_main_ceo_category_ancillary_armour");
                cm:set_saved_value("kill_character_hlyjdingzhie",false)
            end;
            if cm:get_saved_value("hlyjdingzhie_has_been_killed") then
                local modify_hlyjdingzhia = cm:modify_character(cm:query_model():character_for_template("hlyjdingzhia"));
                modify_hlyjdingzhia:remove_effect_bundle("freeze");
            end;
            if cm:get_saved_value("kafka_mission_summon_huanlong") then
                local calendar = cm:get_saved_value("kafka_mission_summon_huanlong");
                if calendar >= 2 and not cm:get_saved_value("calendar_2") then
                    cm:set_saved_value("calendar_2",true);
                    xyy_set_region_manager("3k_main_shoufang_capital","xyyhlyjf");
                    xyy_set_region_manager("3k_main_shoufang_resource_1","xyyhlyjf");
                    xyy_set_region_manager("3k_main_shoufang_resource_2","xyyhlyjf");
                    xyy_set_region_manager("3k_main_shoufang_resource_3","xyyhlyjf");
                    
                    xyy_set_region_manager("3k_main_wuwei_capital","xyyhlyjf");
                    xyy_set_region_manager("3k_main_wuwei_resource_1","xyyhlyjf");
                    xyy_set_region_manager("3k_main_wuwei_resource_2","xyyhlyjf");
                    
                    xyy_set_region_manager("3k_main_anding_capital","xyyhlyjf");
                    xyy_set_region_manager("3k_main_anding_resource_1","xyyhlyjf");
                    xyy_set_region_manager("3k_main_anding_resource_2","xyyhlyjf");
                    xyy_set_region_manager("3k_main_anding_resource_3","xyyhlyjf");
                end
                if calendar >= 3 and not cm:get_saved_value("calendar_3") then
                    cm:set_saved_value("calendar_3",true);
                    xyy_set_region_manager("3k_main_wudu_capital","xyyhlyjf");
                    xyy_set_region_manager("3k_main_wudu_resource_1","xyyhlyjf");
                    
                    xyy_set_region_manager("3k_main_hanzhong_capital","xyyhlyjf");
                    xyy_set_region_manager("3k_main_hanzhong_resource_1","xyyhlyjf");
                    
                    xyy_set_region_manager("3k_main_jincheng_capital","xyyhlyjf");
                    xyy_set_region_manager("3k_main_jincheng_resource_1","xyyhlyjf");
                    xyy_set_region_manager("3k_main_jincheng_resource_2","xyyhlyjf");
                    
                    xyy_set_region_manager("3k_dlc06_san_pass","xyyhlyjf");
                    
                    local c1 = cm:modify_faction("xyyhlyjf"):create_character_from_template("general", "3k_general_metal", "3k_xyy_template_scripted_xyyhlyjf_metal_strong_late", false);
                    c1:add_experience(295000,0);
                    local c2 = cm:modify_faction("xyyhlyjf"):create_character_from_template("general", "3k_general_metal", "3k_xyy_template_scripted_xyyhlyjf_metal_strong_late", false);
                    c2:add_experience(295000,0);
                    local c3 = cm:modify_faction("xyyhlyjf"):create_character_from_template("general", "3k_general_fire", "3k_xyy_template_scripted_xyyhlyjf_fire_strong_late", false);
                    c3:add_experience(295000,0);
                    local c4 = cm:modify_faction("xyyhlyjf"):create_character_from_template("general", "3k_general_fire", "3k_xyy_template_scripted_xyyhlyjf_fire_strong_late", false);
                    c4:add_experience(295000,0);
                    local c5 = cm:modify_faction("xyyhlyjf"):create_character_from_template("general", "3k_general_wood", "3k_xyy_template_scripted_xyyhlyjf_wood_strong_late", false);
                    c5:add_experience(295000,0);
                    local c6 = cm:modify_faction("xyyhlyjf"):create_character_from_template("general", "3k_general_wood", "3k_xyy_template_scripted_xyyhlyjf_wood_strong_late", false);
                    c6:add_experience(295000,0);
                end
                if calendar >= 6 and not cm:get_saved_value("calendar_6") then
                    cm:set_saved_value("calendar_6",true);
                    local c7 = cm:modify_faction("xyyhlyjf"):create_character_from_template("general", "3k_general_metal", "3k_xyy_template_scripted_xyyhlyjf_metal_strong_late", false);
                    c7:add_experience(295000,0);
                    local c8 = cm:modify_faction("xyyhlyjf"):create_character_from_template("general", "3k_general_metal", "3k_xyy_template_scripted_xyyhlyjf_metal_strong_late", false);
                    c8:add_experience(295000,0);
                    local c9 = cm:modify_faction("xyyhlyjf"):create_character_from_template("general", "3k_general_fire", "3k_xyy_template_scripted_xyyhlyjf_fire_strong_late", false);
                    c9:add_experience(295000,0);
                    local c10 = cm:modify_faction("xyyhlyjf"):create_character_from_template("general", "3k_general_fire", "3k_xyy_template_scripted_xyyhlyjf_fire_strong_late", false);
                    c10:add_experience(295000,0);
                    local c11 = cm:modify_faction("xyyhlyjf"):create_character_from_template("general", "3k_general_wood", "3k_xyy_template_scripted_xyyhlyjf_wood_strong_late", false);
                    c11:add_experience(295000,0);
                    local c12 = cm:modify_faction("xyyhlyjf"):create_character_from_template("general", "3k_general_wood", "3k_xyy_template_scripted_xyyhlyjf_wood_strong_late", false);
                    c12:add_experience(295000,0);
                    
                    local mission = string_mission:new("kafka_mission_huanlong_01");
                    mission:add_primary_objective("DEFEAT_N_ARMIES_OF_FACTION", {"total 5","faction xyyhlyjf"});
                    mission:add_primary_payload("money 150000");
                    mission:set_turn_limit(50);
                    mission:trigger_mission_for_faction(cm:query_local_faction():name());
                end
                if calendar >= 8 and not cm:get_saved_value("summon_hlyjdingzhid") then
                    if cm:get_saved_value("kafka_mission_07_choice") then
                        cm:set_saved_value("kafka_mission_07_choice",false);
                        cm:set_saved_value("summon_hlyjdingzhid",true);
                        
                        cm:modify_region("3k_main_changan_capital"):settlement_gifted_as_if_by_payload(cm:modify_faction("xyyhlyjf"));
                        cm:modify_region("3k_main_changan_resource_1"):settlement_gifted_as_if_by_payload(cm:modify_faction("xyyhlyjf"));
                        
                        xyy_set_region_manager("3k_main_shoufang_capital","xyyhlyjf");
                        xyy_set_region_manager("3k_main_shoufang_resource_1","xyyhlyjf");
                        xyy_set_region_manager("3k_main_shoufang_resource_2","xyyhlyjf");
                        xyy_set_region_manager("3k_main_shoufang_resource_3","xyyhlyjf");
                        
                        xyy_set_region_manager("3k_main_wuwei_capital","xyyhlyjf");
                        xyy_set_region_manager("3k_main_wuwei_resource_1","xyyhlyjf");
                        xyy_set_region_manager("3k_main_wuwei_resource_2","xyyhlyjf");
                        
                        xyy_set_region_manager("3k_main_anding_capital","xyyhlyjf");
                        xyy_set_region_manager("3k_main_anding_resource_1","xyyhlyjf");
                        xyy_set_region_manager("3k_main_anding_resource_2","xyyhlyjf");
                        xyy_set_region_manager("3k_main_anding_resource_3","xyyhlyjf");
                        
                        xyy_set_region_manager("3k_main_jincheng_capital","xyyhlyjf");
                        xyy_set_region_manager("3k_main_jincheng_resource_1","xyyhlyjf");
                        xyy_set_region_manager("3k_main_jincheng_resource_2","xyyhlyjf");
                        
                        xyy_set_region_manager("3k_main_wudu_capital","xyyhlyjf");
                        xyy_set_region_manager("3k_main_wudu_resource_1","xyyhlyjf");
                        
                        xyy_set_region_manager("3k_main_hanzhong_capital","xyyhlyjf");
                        xyy_set_region_manager("3k_main_hanzhong_resource_1","xyyhlyjf");
                        
                        xyy_set_region_manager("3k_dlc06_san_pass","xyyhlyjf");
                        
                        xyy_set_region_manager("3k_dlc06_tong_pass","xyyhlyjf");
                        
                        local modify_xyyhlyjf = cm:modify_faction("xyyhlyjf")
                    
                        modify_xyyhlyjf:make_region_capital(cm:query_region("3k_main_changan_capital"));
                        
                        local hlyjdingzhid = xyy_character_add("hlyjdingzhid", "xyyhlyjf", "3k_general_destroy");
                        
                        cm:modify_character(hlyjdingzhid):apply_effect_bundle("freeze", 5);
                        
                        cm:modify_character(hlyjdingzhid):add_experience(295000,0);

                        local hlyjdingzhia = cm:query_model():character_for_template("hlyjdingzhia");
                        cm:modify_character(hlyjdingzhia):ceo_management():add_ceo("kafka_mission_complete_02");
                        
                        found_pos, x, y = cm:query_faction("xyyhlyjf"):get_valid_spawn_location_in_region("3k_main_changan_capital", false);
                        
                        cm:create_force_with_existing_general(hlyjdingzhid:command_queue_index(), "xyyhlyjf", "", "3k_main_changan_capital", x, y, "hlyjdingzhid_force", nil, 100);
                        
                        local modify_force = cm:modify_model():get_modify_military_force(hlyjdingzhid:military_force());
                        
                        local modify_character_1 = cm:modify_faction("xyyhlyjf"):create_character_from_template("general", "3k_general_wood", "3k_xyy_template_scripted_xyyhlyjf_wood_strong_late", false);
                        local modify_character_2 = cm:modify_faction("xyyhlyjf"):create_character_from_template("general", "3k_general_metal", "3k_xyy_template_scripted_xyyhlyjf_metal_strong_late", false);    
                        
                        modify_character_1:add_experience(295000,0);
                        modify_character_2:add_experience(295000,0);
                        
                        if modify_force:query_military_force():character_list():num_items() < 3 then
                            modify_force:add_existing_character_as_retinue(modify_character_1, true);
                        end
                        if modify_force:query_military_force():character_list():num_items() < 3 then
                            modify_force:add_existing_character_as_retinue(modify_character_2, true);
                        end
                        
                        cm:modify_faction(cm:query_local_faction():name()):make_region_seen_in_shroud("3k_main_changan_capital");
                        
                        cm:modify_faction(cm:query_local_faction():name()):make_region_seen_in_shroud("3k_main_changan_resource_1");
                        cm:trigger_incident(cm:query_local_faction():name(),"kafka_mission_08_incident", true);
                    end
                end
                if calendar == 9 and not cm:get_saved_value("hlyjdingzhie_has_been_killed") then
                    local c1 = cm:modify_faction("xyyhlyjf"):create_character_from_template("general", "3k_general_metal", "3k_xyy_template_scripted_xyyhlyjf_metal_strong_late", false);
                    c1:add_experience(295000,0);
                    local c2 = cm:modify_faction("xyyhlyjf"):create_character_from_template("general", "3k_general_metal", "3k_xyy_template_scripted_xyyhlyjf_metal_strong_late", false);
                    c2:add_experience(295000,0);
                    local c3 = cm:modify_faction("xyyhlyjf"):create_character_from_template("general", "3k_general_fire", "3k_xyy_template_scripted_xyyhlyjf_fire_strong_late", false);
                    c3:add_experience(295000,0);
                    local c4 = cm:modify_faction("xyyhlyjf"):create_character_from_template("general", "3k_general_fire", "3k_xyy_template_scripted_xyyhlyjf_fire_strong_late", false);
                    c4:add_experience(295000,0);
                    local c5 = cm:modify_faction("xyyhlyjf"):create_character_from_template("general", "3k_general_wood", "3k_xyy_template_scripted_xyyhlyjf_wood_strong_late", false);
                    c5:add_experience(295000,0);
                    local c6 = cm:modify_faction("xyyhlyjf"):create_character_from_template("general", "3k_general_wood", "3k_xyy_template_scripted_xyyhlyjf_wood_strong_late", false);
                    c6:add_experience(295000,0);
                    cm:set_saved_value("calendar_10",true);
                    local c7 = cm:modify_faction("xyyhlyjf"):create_character_from_template("general", "3k_general_metal", "3k_xyy_template_scripted_xyyhlyjf_metal_strong_late", false);
                    c7:add_experience(295000,0);
                    local c8 = cm:modify_faction("xyyhlyjf"):create_character_from_template("general", "3k_general_metal", "3k_xyy_template_scripted_xyyhlyjf_metal_strong_late", false);
                    c8:add_experience(295000,0);
                    local c9 = cm:modify_faction("xyyhlyjf"):create_character_from_template("general", "3k_general_fire", "3k_xyy_template_scripted_xyyhlyjf_fire_strong_late", false);
                    c9:add_experience(295000,0);
                    local c10 = cm:modify_faction("xyyhlyjf"):create_character_from_template("general", "3k_general_fire", "3k_xyy_template_scripted_xyyhlyjf_fire_strong_late", false);
                    c10:add_experience(295000,0);
                    local c11 = cm:modify_faction("xyyhlyjf"):create_character_from_template("general", "3k_general_wood", "3k_xyy_template_scripted_xyyhlyjf_wood_strong_late", false);
                    c11:add_experience(295000,0);
                    local c12 = cm:modify_faction("xyyhlyjf"):create_character_from_template("general", "3k_general_wood", "3k_xyy_template_scripted_xyyhlyjf_wood_strong_late", false);
                    c12:add_experience(295000,0);
                
                    xyy_set_region_manager("3k_dlc06_tong_pass","xyyhlyjf");
                    xyy_set_region_manager("3k_dlc06_wu_pass","xyyhlyjf");
                    xyy_set_region_manager("3k_dlc06_jiameng_pass","xyyhlyjf");
                    
                    xyy_set_region_manager("3k_main_baxi_capital","xyyhlyjf");
                    xyy_set_region_manager("3k_main_baxi_resource_1","xyyhlyjf");
                    xyy_set_region_manager("3k_main_baxi_resource_2","xyyhlyjf");
                end
                if calendar == 10 and not cm:get_saved_value("hlyjdingzhie_has_been_killed") then
                
                    xyy_set_region_manager("3k_main_xihe_capital","xyyhlyjf");
                    xyy_set_region_manager("3k_main_xihe_resource_1","xyyhlyjf");
                    
                    xyy_set_region_manager("3k_main_chengdu_capital","xyyhlyjf");
                    xyy_set_region_manager("3k_main_chengdu_resource_1","xyyhlyjf");
                    xyy_set_region_manager("3k_main_chengdu_resource_2","xyyhlyjf");
                    xyy_set_region_manager("3k_main_chengdu_resource_3","xyyhlyjf");
                    
                    xyy_set_region_manager("3k_main_bajun_capital","xyyhlyjf");
                    xyy_set_region_manager("3k_main_bajun_resource_1","xyyhlyjf");
                    
                    xyy_set_region_manager("3k_main_hedong_capital","xyyhlyjf");
                    xyy_set_region_manager("3k_main_hedong_resource_1","xyyhlyjf");
                    xyy_set_region_manager("3k_dlc06_hedong_resource_2","xyyhlyjf");
                end
                if calendar == 12 and not cm:get_saved_value("hlyjdingzhie_has_been_killed") then
                    local c1 = cm:modify_faction("xyyhlyjf"):create_character_from_template("general", "3k_general_metal", "3k_xyy_template_scripted_xyyhlyjf_metal_strong_late", false);
                    c1:add_experience(295000,0);
                    local c2 = cm:modify_faction("xyyhlyjf"):create_character_from_template("general", "3k_general_metal", "3k_xyy_template_scripted_xyyhlyjf_metal_strong_late", false);
                    c2:add_experience(295000,0);
                    local c3 = cm:modify_faction("xyyhlyjf"):create_character_from_template("general", "3k_general_fire", "3k_xyy_template_scripted_xyyhlyjf_fire_strong_late", false);
                    c3:add_experience(295000,0);
                    local c4 = cm:modify_faction("xyyhlyjf"):create_character_from_template("general", "3k_general_fire", "3k_xyy_template_scripted_xyyhlyjf_fire_strong_late", false);
                    c4:add_experience(295000,0);
                    local c5 = cm:modify_faction("xyyhlyjf"):create_character_from_template("general", "3k_general_wood", "3k_xyy_template_scripted_xyyhlyjf_wood_strong_late", false);
                    c5:add_experience(295000,0);
                    local c6 = cm:modify_faction("xyyhlyjf"):create_character_from_template("general", "3k_general_wood", "3k_xyy_template_scripted_xyyhlyjf_wood_strong_late", false);
                    c6:add_experience(295000,0);
                    cm:set_saved_value("calendar_10",true);
                    local c7 = cm:modify_faction("xyyhlyjf"):create_character_from_template("general", "3k_general_metal", "3k_xyy_template_scripted_xyyhlyjf_metal_strong_late", false);
                    c7:add_experience(295000,0);
                    local c8 = cm:modify_faction("xyyhlyjf"):create_character_from_template("general", "3k_general_metal", "3k_xyy_template_scripted_xyyhlyjf_metal_strong_late", false);
                    c8:add_experience(295000,0);
                    local c9 = cm:modify_faction("xyyhlyjf"):create_character_from_template("general", "3k_general_fire", "3k_xyy_template_scripted_xyyhlyjf_fire_strong_late", false);
                    c9:add_experience(295000,0);
                    local c10 = cm:modify_faction("xyyhlyjf"):create_character_from_template("general", "3k_general_fire", "3k_xyy_template_scripted_xyyhlyjf_fire_strong_late", false);
                    c10:add_experience(295000,0);
                    local c11 = cm:modify_faction("xyyhlyjf"):create_character_from_template("general", "3k_general_wood", "3k_xyy_template_scripted_xyyhlyjf_wood_strong_late", false);
                    c11:add_experience(295000,0);
                    local c12 = cm:modify_faction("xyyhlyjf"):create_character_from_template("general", "3k_general_wood", "3k_xyy_template_scripted_xyyhlyjf_wood_strong_late", false);
                    c12:add_experience(295000,0);
                
                    xyy_set_region_manager("3k_main_badong_capital","xyyhlyjf");
                    xyy_set_region_manager("3k_main_badong_resource_1","xyyhlyjf");
                    xyy_set_region_manager("3k_main_badong_resource_2","xyyhlyjf");
                    
                    xyy_set_region_manager("3k_main_wuling_capital","xyyhlyjf");
                    xyy_set_region_manager("3k_main_wuling_resource_1","xyyhlyjf");
                    xyy_set_region_manager("3k_main_wuling_resource_2","xyyhlyjf");
                    xyy_set_region_manager("3k_main_wuling_resource_3","xyyhlyjf");
                    
                    xyy_set_region_manager("3k_dlc06_hangu_pass","xyyhlyjf");
                    xyy_set_region_manager("3k_main_luoyang_resource_1","xyyhlyjf");
                    
                    xyy_set_region_manager("3k_main_taiyuan_capital","xyyhlyjf");
                    xyy_set_region_manager("3k_main_taiyuan_resource_1","xyyhlyjf");
                    xyy_set_region_manager("3k_main_taiyuan_resource_2","xyyhlyjf");
                    
                    xyy_set_region_manager("3k_main_yanmen_capital","xyyhlyjf");
                    xyy_set_region_manager("3k_main_yanmen_resource_1","xyyhlyjf");
                end
                if calendar == 13 and not cm:get_saved_value("hlyjdingzhie_has_been_killed") then
                
                    xyy_set_region_manager("3k_dlc06_gu_pass","xyyhlyjf");
                    xyy_set_region_manager("3k_dlc06_qi_pass","xyyhlyjf");
                    xyy_set_region_manager("3k_dlc06_hulao_pass","xyyhlyjf");
                    
                    xyy_set_region_manager("3k_main_luoyang_capital","xyyhlyjf");
                    
                    xyy_set_region_manager("3k_main_taiyuan_capital","xyyhlyjf");
                    xyy_set_region_manager("3k_main_taiyuan_resource_1","xyyhlyjf");
                    xyy_set_region_manager("3k_main_taiyuan_resource_2","xyyhlyjf");
                    
                    xyy_set_region_manager("3k_main_shangdang_capital","xyyhlyjf");
                    xyy_set_region_manager("3k_main_shangdang_resource_1","xyyhlyjf");
                    xyy_set_region_manager("3k_dlc06_shangdang_resource_2","xyyhlyjf");
                    
                    xyy_set_region_manager("3k_main_zhongshan_capital","xyyhlyjf");
                    xyy_set_region_manager("3k_main_zhongshan_resource_1","xyyhlyjf");
                end
                if calendar == 15 and not cm:get_saved_value("hlyjdingzhie_has_been_killed") then
                
                    xyy_set_region_manager("3k_main_anping_capital","xyyhlyjf");
                    xyy_set_region_manager("3k_main_anping_resource_1","xyyhlyjf");
                    
                    xyy_set_region_manager("3k_main_weijun_capital","xyyhlyjf");
                    xyy_set_region_manager("3k_main_weijun_resource_1","xyyhlyjf");
                    
                    xyy_set_region_manager("3k_main_henei_capital","xyyhlyjf");
                    xyy_set_region_manager("3k_main_henei_resource_1","xyyhlyjf");
                    
                    xyy_set_region_manager("3k_main_nanyang_capital","xyyhlyjf");
                    xyy_set_region_manager("3k_main_nanyang_resource_1","xyyhlyjf");
                    
                    xyy_set_region_manager("3k_main_yingchuan_capital","xyyhlyjf");
                    xyy_set_region_manager("3k_main_yingchuan_resource_1","xyyhlyjf");
                end
                if calendar == 17 and not cm:get_saved_value("hlyjdingzhie_has_been_killed") then
                
                    xyy_set_region_manager("3k_dlc06_kui_pass","xyyhlyjf");
                    
                    xyy_set_region_manager("3k_main_xiangyang_capital","xyyhlyjf");
                    xyy_set_region_manager("3k_main_xiangyang_resource_1","xyyhlyjf");
                    
                    xyy_set_region_manager("3k_main_jingzhou_capital","xyyhlyjf");
                    xyy_set_region_manager("3k_main_jingzhou_resource_1","xyyhlyjf");
                    
                    xyy_set_region_manager("3k_main_daijun_capital","xyyhlyjf");
                    xyy_set_region_manager("3k_main_daijun_resource_1","xyyhlyjf");
                    
                    xyy_set_region_manager("3k_main_bohai_capital","xyyhlyjf");
                    xyy_set_region_manager("3k_main_bohai_resource_1","xyyhlyjf");
                    
                    xyy_set_region_manager("3k_main_pingyuan_capital","xyyhlyjf");
                    xyy_set_region_manager("3k_main_pingyuan_resource_1","xyyhlyjf");
                end
                cm:set_saved_value("kafka_mission_summon_huanlong", calendar + 1);
            else
                local mission = string_mission:new("kafka_mission_huanlong_01");
                mission:add_primary_objective("DEFEAT_N_ARMIES_OF_FACTION", {"total 5","faction xyyhlyjf"});
                mission:add_primary_payload("money 150000");
                mission:set_turn_limit(50);
                mission:trigger_mission_for_faction(player_faction:name());
                cm:set_saved_value("kafka_mission_summon_huanlong", 11);
            end
            if cm:get_saved_value("kafka_mission_09") then
                
                local hlyjdingzhid = cm:query_model():character_for_template("hlyjdingzhid");
                
                found_pos, x, y = cm:query_faction("xyyhlyjf"):get_valid_spawn_location_in_region(xyyhlyjf:capital_region():name(), false);
                
                if not hlyjdingzhid:has_military_force() or not hlyjdingzhid:military_force() then
                    cm:create_force_with_existing_general(hlyjdingzhid:command_queue_index(), "xyyhlyjf", "", xyyhlyjf:capital_region():name(), x, y, "hlyjdingzhie_force", nil, 100);
                    
                    local modify_force = cm:modify_model():get_modify_military_force(hlyjdingzhid:military_force());
                    
                    local modify_character_1 = cm:modify_faction("xyyhlyjf"):create_character_from_template("general", "3k_general_wood", "3k_xyy_template_scripted_xyyhlyjf_wood_strong_late", false);
                    local modify_character_2 = cm:modify_faction("xyyhlyjf"):create_character_from_template("general", "3k_general_fire", "3k_xyy_template_scripted_xyyhlyjf_fire_strong_late", false);    
                    
                    modify_character_1:add_experience(295000,0);
                    modify_character_2:add_experience(295000,0);
                    
                    if modify_force:query_military_force():character_list():num_items() < 3 then
                        modify_force:add_existing_character_as_retinue(modify_character_1, true);
                    end
                    if modify_force:query_military_force():character_list():num_items() < 3 then
                        modify_force:add_existing_character_as_retinue(modify_character_2, true);
                    end
                end
                
                cm:modify_character(hlyjdingzhid):apply_effect_bundle("freeze", -1);
                
                xyy_set_minister_position("hlyjdingzhid","faction_leader");
                cm:trigger_mission(player_faction,"kafka_mission_09", true);
                xyy_set_minister_position("hlyjdingzhia","faction_leader");
                cm:set_saved_value("kafka_mission_09", false);
            end
            
            if cm:get_saved_value("kafka_mission_12_a") then
                
                local hlyjdingzhie = cm:query_model():character_for_template("hlyjdingzhie");
                
                found_pos, x, y = cm:query_faction("xyyhlyjf"):get_valid_spawn_location_in_region(xyyhlyjf:capital_region():name(), false);
                
                if not hlyjdingzhie:has_military_force() or not hlyjdingzhie:military_force() then
                    cm:create_force_with_existing_general(hlyjdingzhie:command_queue_index(), "xyyhlyjf", "", xyyhlyjf:capital_region():name(), x, y, "hlyjdingzhie_force", nil, 100);
                    
                    local modify_force = cm:modify_model():get_modify_military_force(hlyjdingzhie:military_force());
                    
                    local modify_character_1 = cm:modify_faction("xyyhlyjf"):create_character_from_template("general", "3k_general_wood", "3k_xyy_template_scripted_xyyhlyjf_wood_strong_late", false);
                    local modify_character_2 = cm:modify_faction("xyyhlyjf"):create_character_from_template("general", "3k_general_fire", "3k_xyy_template_scripted_xyyhlyjf_fire_strong_late", false);    
                    
                    modify_character_1:add_experience(295000,0);
                    modify_character_2:add_experience(295000,0);
                    
                    if modify_force:query_military_force():character_list():num_items() < 3 then
                        modify_force:add_existing_character_as_retinue(modify_character_1, true);
                    end
                    if modify_force:query_military_force():character_list():num_items() < 3 then
                        modify_force:add_existing_character_as_retinue(modify_character_2, true);
                    end
                end
                
                cm:modify_character(hlyjdingzhie):apply_effect_bundle("freeze", -1);
                
                xyy_set_minister_position("hlyjdingzhie","faction_leader");
                cm:trigger_mission(player_faction,"kafka_mission_12_a", true);
                xyy_set_minister_position("hlyjdingzhia","faction_leader");
                
                cm:set_saved_value("kafka_mission_12_a_trigger", true);
                
                cm:set_saved_value("kafka_mission_12_a", false);
                
            end
            
            if 
            cm:get_saved_value("trigger_kafka_mission_15") 
            and not player_faction:has_mission_been_issued("kafka_mission_15")
            and not player_faction:has_mission_been_issued("kafka_mission_15_a")  
            then
                local hlyjdingzhia = cm:query_model():character_for_template("hlyjdingzhia");
                local xyyhlyjf = cm:query_faction("xyyhlyjf");
                found_pos, x, y = cm:query_faction("xyyhlyjf"):get_valid_spawn_location_in_region(xyyhlyjf:capital_region():name(), false);
                
                if not hlyjdingzhia:has_military_force() or not hlyjdingzhia:military_force() then
                    cm:create_force_with_existing_general(hlyjdingzhia:command_queue_index(), "xyyhlyjf", "", xyyhlyjf:capital_region():name(), x, y, "hlyjdingzhia_force0", nil, 100);
                    
                    local modify_force = cm:modify_model():get_modify_military_force(hlyjdingzhia:military_force());
                    
                    ModLog("debug: trigger is_kafka_mission_15_"..hlyjdingzhia:command_queue_index());
                    
                    local modify_character_1 = cm:modify_faction("xyyhlyjf"):create_character_from_template("general", "3k_general_wood", "3k_xyy_template_scripted_xyyhlyjf_wood_strong_late", false);
                    local modify_character_2 = cm:modify_faction("xyyhlyjf"):create_character_from_template("general", "3k_general_fire", "3k_xyy_template_scripted_xyyhlyjf_fire_strong_late", false);    
                    
                    modify_character_1:add_experience(295000,0);
                    modify_character_2:add_experience(295000,0);
                
                    cdir_events_manager:add_or_remove_ceo_from_faction("xyyhlyjf", "hlyjdingzhicwuqi", true);
                    ancillaries:equip_ceo_on_character(modify_character_2:query_character(), "hlyjdingzhicwuqi", "3k_main_ceo_category_ancillary_weapon");
                    
                    cdir_events_manager:add_or_remove_ceo_from_faction("xyyhlyjf", "hlyjdingzhibwuqi", true);
                    ancillaries:equip_ceo_on_character(modify_character_1:query_character(), "hlyjdingzhibwuqi", "3k_main_ceo_category_ancillary_weapon");
                    
                    if modify_force:query_military_force():character_list():num_items() < 3 then
                        modify_force:add_existing_character_as_retinue(modify_character_1, true);
                    end
                    if modify_force:query_military_force():character_list():num_items() < 3 then
                        modify_force:add_existing_character_as_retinue(modify_character_2, true);
                    end
                end
                
                cm:modify_character(hlyjdingzhia):apply_effect_bundle("freeze", -1);
            end
            
            if cm:get_saved_value("kafka_mission_10_a_incident") and not cm:get_saved_value("hlyjdingzhie_has_been_killed") then
                local hlyjdingzhie = cm:query_model():character_for_template("hlyjdingzhie");
                
                cm:modify_character(hlyjdingzhie):apply_effect_bundle("freeze", 5);
                
                cm:modify_character(hlyjdingzhie):add_experience(295000,0);
                
                if not hlyjdingzhie:military_force() or not hlyjdingzhie:has_military_force() then
                    local xyyhlyjf = cm:query_faction("xyyhlyjf");
            
                    found_pos, x, y = xyyhlyjf:get_valid_spawn_location_in_region(xyyhlyjf:capital_region():name(), false);
                    cm:create_force_with_existing_general(hlyjdingzhie:command_queue_index(), "xyyhlyjf", "", xyyhlyjf:capital_region():name(), x, y, "hlyjdingzhie_force", nil, 100);
                    
                    ModLog("debug: trigger is_kafka_mission_15" .. xyyhlyjf:capital_region():name() )
                end
                local modify_force = cm:modify_model():get_modify_military_force(hlyjdingzhie:military_force());
                
                local modify_character_1 = cm:modify_faction("xyyhlyjf"):create_character_from_template("general", "3k_general_wood", "3k_xyy_template_scripted_xyyhlyjf_wood_strong_late", false);
                local modify_character_2 = cm:modify_faction("xyyhlyjf"):create_character_from_template("general", "3k_general_fire", "3k_xyy_template_scripted_xyyhlyjf_fire_strong_late", false);    
                
                modify_character_1:add_experience(295000,0);
                modify_character_2:add_experience(295000,0);
                
                if modify_force:query_military_force():character_list():num_items() < 3 then
                    modify_force:add_existing_character_as_retinue(modify_character_1, true);
                end
                if modify_force:query_military_force():character_list():num_items() < 3 then
                    modify_force:add_existing_character_as_retinue(modify_character_2, true);
                end
                    
            end
        end;
    end,
    true
)

core:add_listener(
    "kafka_mission_huanlong_failed",
    "MissionFailed",
    function(context)
        return context:mission():mission_record_key() == "kafka_mission_huanlong";
    end,
    function(context)
        cm:trigger_dilemma(context:faction():name(),"kafka_mission_failed_dilemma", true);
    end,
    false
)
core:add_listener(
    "kafka_mission_huanlong_02_succcess",
    "MissionSucceeded",
    function(context)
        return context:mission():mission_record_key() == "kafka_mission_huanlong_02";
    end,
    function(context)
        if not cm:get_saved_value("is_kafka_leaved") then
            ModLog("debug: trigger kafka_mission_huanlong_03")
            local xyyhlyjf = cm:query_faction("xyyhlyjf");
            local town_number = xyyhlyjf:region_list():num_items() - 5;
            ModLog("debug: town_number = " .. town_number)
            if town_number > 10 then town_number = 10 end;
            if town_number < 5 then town_number = 5 end;
            local mission = string_mission:new("kafka_mission_huanlong_03");
            mission:add_primary_objective("DEFEAT_N_ARMIES_OF_FACTION", {"total ".. town_number ,"faction xyyhlyjf"});
            mission:add_primary_payload("money " .. town_number * 10000);
            mission:trigger_mission_for_faction(context:faction():name());
        end
    end,
    false
)
core:add_listener(
    "kafka_mission_failed_dilemma",
    "DilemmaChoiceMadeEvent",
    function(context)
        return context:dilemma() == "kafka_mission_failed_dilemma" and (context:choice() == 0 or context:choice() == 1);
    end,
    function(context)
        local world_faction_list = cm:query_model():world():faction_list();
        local xyyhlyjf = cm:query_faction("xyyhlyjf")
        if not cm:query_local_faction():is_dead() then
            local not_human = 0;
            ModLog("not_human = "..not_human);
            if not_human == 0 then
                local faction = context:faction();
                if faction:name()=="3k_main_faction_cao_cao" then
                    cm:modify_model():get_modify_episodic_scripting():register_instant_movie_by_record("3k_main_game_lost_cao_cao");
                elseif faction:name()=="3k_main_faction_liu_bei" then
                    cm:modify_model():get_modify_episodic_scripting():register_instant_movie_by_record("3k_main_game_lost_liu_bei");
                elseif faction:name()=="3k_main_faction_sun_jian" or faction:name()=="3k_dlc05_faction_sun_ce" then
                    cm:modify_model():get_modify_episodic_scripting():register_instant_movie_by_record("3k_main_game_lost_sun_ce");
                else
                    cm:modify_model():get_modify_episodic_scripting():register_instant_movie_by_record("3k_main_game_lost_fire");
                end
                local region_list = faction:region_list()
                local character_list = faction:character_list()
                for i = 0, character_list:num_items() - 1 do
                    local character = character_list:item_at(i);
                    cm:modify_character(character):move_to_faction_and_make_recruited("xyyhlyjf");
                end;
                for i = 0, region_list:num_items() - 1 do
                    local region = region_list:item_at(i);
                    cm:modify_region(region:name()):settlement_gifted_as_if_by_payload(cm:modify_faction("xyyhlyjf"));
                end;
            else
                if xyyhlyjf and not xyyhlyjf:is_dead() then
                    local random_faction = world_faction_list:item_at(cm:random_int(world_faction_list:num_items() - 1,0));
                    while (
                    not random_faction 
                    or random_faction:is_null_interface() 
                    or random_faction:is_dead() 
                    or not random_faction:region_list() 
                    or random_faction:region_list():num_items() == 0 
                    or random_faction:name() == cm:query_local_faction():name() 
                    or random_faction:name() == "xyyhlyjf")
                    do
                        random_faction = world_faction_list:item_at(cm:random_int(world_faction_list:num_items() - 1,0));
                    end
                    diplomacy_manager:force_confederation("xyyhlyjf", random_faction:name());
                    ModLog("xyyhlyjf 吞并了 " .. random_faction:name());
                    cm:trigger_dilemma(context:faction():name(),"kafka_mission_failed_dilemma", true);
                end;
            end;
        end;
    end,
    true
)

core:add_listener(
    "kafka_mission_failed_incident",
    "IncidentOccuredEvent",
    function(context)
        return context:incident() == "kafka_mission_failed_incident";
    end,
    function(context)
        cm:trigger_dilemma(context:faction():name(),"kafka_mission_failed_dilemma", true);
        
    end,
    false
)

core:add_listener(
    "xyyhlyjf_About_To_Die",
    "FactionAboutToDie",
	function(context)
        return not cm:get_saved_value("huanlong_dead") and context:faction():name() == "xyyhlyjf";
	end,
	function(context)
        cm:modify_region("3k_main_shoufang_resource_2"):settlement_gifted_as_if_by_payload(cm:modify_faction("3k_main_faction_shoufang"));
        cm:modify_region("3k_main_shoufang_resource_3"):settlement_gifted_as_if_by_payload(cm:modify_faction("xyyhlyjf"));
        cm:modify_region("3k_main_shoufang_resource_2"):settlement_gifted_as_if_by_payload(cm:modify_faction("xyyhlyjf"));
        cm:modify_region("3k_main_shoufang_resource_1"):settlement_gifted_as_if_by_payload(cm:modify_faction("xyyhlyjf"));
        cm:modify_region("3k_main_shoufang_capital"):settlement_gifted_as_if_by_payload(cm:modify_faction("xyyhlyjf"));
	end,
	true
)
 
core:add_listener(
    "kafka_mission_07",
    "CharacterAssignedToPost",
	function(context)
        local character = context:query_character()
        ModLog(character:generation_template_key() .. "被任命为" .. character:character_post():ministerial_position_record_key());
		return character:generation_template_key() == "hlyjdingzhie" 
		and character:character_post():ministerial_position_record_key() == "3k_main_court_offices_prime_minister" 
		and character:faction():name() == cm:query_model():character_for_template("hlyjcj"):faction():name();
	end,
	function(context)
        kafka = cm:query_model():character_for_template("hlyjcj");
        faction_leader = kafka:faction():faction_leader();
        incident = cm:modify_model():create_incident("kafka_mission_07_incident");
        incident:add_character_target("target_character_1", kafka);
        incident:add_character_target("target_character_2", faction_leader);
        incident:trigger(cm:modify_faction(kafka:faction()), true);
	end,
	false
)

core:add_listener(
    "character_assigned_to_post",
    "CharacterAssignedToPost",
	function(context)
        local character = context:query_character()
        ModLog(character:generation_template_key() .. "被任命为" .. character:character_post():ministerial_position_record_key());
		return character:generation_template_key() == "hlyjcm" 
		and (character:character_post():ministerial_position_record_key() == "3k_main_court_offices_prime_minister" 
		or character:character_post():ministerial_position_record_key() == "ep_court_offices_prime_minister" 
		or character:character_post():ministerial_position_record_key() == "faction_heir" 
		or character:character_post():ministerial_position_record_key() == "3k_dlc04_court_offices_general_in_chief" 
		or character:character_post():ministerial_position_record_key() == "3k_dlc04_court_offices_grand_tutor" 
		or character:character_post():ministerial_position_record_key() == "3k_dlc04_court_offices_grand_excellency_of_works" 
		or character:character_post():ministerial_position_record_key() == "3k_dlc04_court_offices_grand_commandant" 
		or character:character_post():ministerial_position_record_key() == "3k_dlc04_court_offices_prime_minister");
	end,
	function(context)
        local query_faction = context:query_character():faction()
        cm:modify_faction(query_faction):remove_event_restricted_unit_record("hlyjdingzhiedanwei")
        cm:modify_faction(query_faction):remove_event_restricted_unit_record("hlyjdingzhifdanwei")
	end,
	false
)

core:add_listener(
    "xyyhlyjf_defeat_event",
    "RegionOwnershipChanged",
    function(context)
        --ModLog(context:previous_owner():name()..":"..context:previous_owner():region_list():num_items());
        return 
        context:previous_owner():name() == "xyyhlyjf"
        and context:previous_owner():region_list():num_items() == 0
        and context:previous_owner():faction_leader():generation_template_key() == "hlyjdingzhia"
        and not cm:query_model():character_for_template("hlyjdingzhia"):is_dead();
    end,
    function()
        cm:modify_region(context:region():name()):settlement_gifted_as_if_by_payload(cm:modify_faction("xyyhlyjf"));
    end,
    true
)
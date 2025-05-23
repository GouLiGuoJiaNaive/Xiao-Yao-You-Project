local gst = xyy_gst:get_mod()
local query_faction = nil;
local limit = 0;

core:add_listener(
    "AI_deployment_limit_turn_start",
    "FactionTurnStart",
    function(context)
        return
        not context:faction():is_null_interface()
        and not context:faction():is_dead()
    end,
    function(context)
        local faction = context:faction()
        if not faction:is_human() then
            query_faction = faction:name()
            cm:modify_faction(faction):apply_effect_bundle("force_escape", -1);
        end
        --武器归还机制
        for char_id, char_info in pairs(gst.all_character_detils) do
            local q_char = gst.character_query_for_template(char_id)
            --local world_faction_list = cm:query_model():world():faction_list();
            if char_info["weapon"] then
                if q_char
                and not q_char:is_null_interface()
                and not q_char:is_dead()
                and not q_char:is_character_is_faction_recruitment_pool()
                then
                    if q_char:faction():name() == faction:name() then
                        local is_equiped = false;
                        if (char_id ~= "hlyjdl" or not q_char:ceo_management():has_ceo_equipped("hlyjdlyifu2"))
                        and (char_id ~= "hlyjcj" or cm:get_saved_value("roguelike_mode"))
                        then
                            for k, weapon in ipairs(char_info["weapon"]) do
                                --ModLog(weapon)
                                if not gst.faction_has_ceo(faction:name(), weapon) then
                                    local AI_faction = gst.faction_find_ceo(weapon)
                                    if AI_faction and not AI_faction:is_human() then
                                        cm:modify_faction(AI_faction):ceo_management():remove_ceos(weapon)
                                        cm:modify_faction(faction):ceo_management():add_ceo(weapon)
                                        ancillaries:equip_ceo_on_character(q_char, weapon, "3k_main_ceo_category_ancillary_weapon");
                                    end
                                end
                                if q_char:ceo_management():has_ceo_equipped(weapon) then
                                    is_equiped = true;
                                end
                            end
                        end
                        if not is_equiped and not faction:is_human() then
                            ancillaries:equip_ceo_on_character(q_char, char_info["weapon"][1], "3k_main_ceo_category_ancillary_weapon");
                        end
                    else
                        local is_equiped = false;
                        for k, weapon in ipairs(char_info["weapon"]) do
                            --ModLog(weapon)
                            if not faction:is_human() and gst.faction_has_ceo(faction:name(), weapon) then
                                cm:modify_faction(faction):ceo_management():remove_ceos(weapon)
                                cm:modify_faction(q_char:faction()):ceo_management():add_ceo(weapon)
                                ancillaries:equip_ceo_on_character(q_char, weapon, "3k_main_ceo_category_ancillary_weapon");
                            end
                            if q_char:ceo_management():has_ceo_equipped(weapon) then
                                is_equiped = true;
                            end
                        end
                        if not is_equiped and not q_char:faction():is_human() then
                            ancillaries:equip_ceo_on_character(q_char, char_info["weapon"][1], "3k_main_ceo_category_ancillary_weapon");
                        end
                    end
                end
            end
        end
    end,
    true
)

core:add_listener(
    "AI_xyyhlyjf_start",
    "FactionTurnStart",
    function(context)
        return context:faction():name() == "xyyhlyjf";
    end,
    function(context)
        local xyyhlyjf = context:faction()
        if xyyhlyjf:treasury() < 10000 then
            cm:modify_faction(xyyhlyjf):increase_treasury(2000000)
        end
        local character_list = xyyhlyjf:character_list();
        for i = 0, character_list:num_items() - 1 do
            local query_character = character_list:item_at(i);
            if not query_character:is_null_interface()
            and not query_character:is_dead()
            and query_character:generation_template_key() ~= "hlyjdingzhia"
            and query_character:generation_template_key() ~= "hlyjdingzhid"
            and query_character:generation_template_key() ~= "hlyjdingzhie"
            and query_character:generation_template_key() ~= "hlyjcm"
            and query_character:generation_template_key() ~= "hlyjdf"
            and not string.find(query_character:generation_template_key(), "xyyhlyjf")
            and not string.find(query_character:generation_template_key(), "_dark")
            then
                local key = query_character:generation_template_key()
                --ModLog(key)
                if string.find(key, "hlyj")
                or string.find(key, "historical")
                then
                    gst.character_runaway_not_recruited(key);
                end
            end
        end
    end,
    true
)

core:add_listener(
    "AI_rebel_start",
    "FactionTurnStart",
    function(context)
        return context:faction():name() == "3k_dlc04_faction_rebels"
        or context:faction():name() == "3k_dlc04_faction_rebels";
    end,
    function(context)
        local rebels = context:faction()
        local character_list = rebels:character_list();
        for i = 0, character_list:num_items() - 1 do
            local query_character = character_list:item_at(i);
            if not query_character:is_null_interface()
            and not query_character:is_dead()
            and query_character:generation_template_key() ~= "hlyjdingzhia"
            and query_character:generation_template_key() ~= "hlyjdingzhid"
            and query_character:generation_template_key() ~= "hlyjdingzhie"
            and not string.find(query_character:generation_template_key(), "xyyhlyjf")
            and not string.find(query_character:generation_template_key(), "_dark")
            then
                local key = query_character:generation_template_key()
                --ModLog(key)
                if string.find(key, "hlyj")
                or string.find(key, "historical")
                then
                    gst.character_runaway_not_recruited(key);
                end
            end
        end
    end,
    true
)

core:add_listener(
    "AI_deployment_limit_pc",
    "FactionTurnEnd",
    function(context)
        return context:faction():is_human();
    end,
    function(context)
        local world_faction_list = cm:query_model():world():faction_list();
        for i = 0, world_faction_list:num_items() - 1 do
            local AI_faction = world_faction_list:item_at(i);
            if not AI_faction:is_null_interface()
            and not AI_faction:is_dead()
            and not AI_faction:is_human()
            then
                local force = 0;
                local military_force_list = AI_faction:military_force_list()
                for j = 0, military_force_list:num_items() - 1 do
                    local query_military_force = military_force_list:item_at(j);
                    local character_list = query_military_force:character_list()
                    for k = 0, character_list:num_items() - 1 do
                        local character = character_list:item_at(k);
                        if not character:is_null_interface()
                        and not character:is_dead()
--                         and character:generation_template_key() ~= "3k_main_template_generic_castellan_m_01"
--                         and character:generation_template_key() ~= "3k_main_template_generic_castellan_f_01"
--                         and character:generation_template_key() ~= "3k_dlc06_template_generic_castellan_nanman_m_01"
--                         and character:generation_template_key() ~= "3k_dlc06_template_generic_castellan_nanman_f_01"
                        and character:character_type("general")
                        then
                            force = force + 1;
                        end
                    end
                end
                local faction_name = AI_faction:name()
                ModLog(faction_name.." force: "..force)
                if AI_faction:name() == "xyyhlyjf" then
                    if cm:get_saved_value("hlyjdingzhie_has_been_killed") then
                        cm:modify_faction(AI_faction):apply_effect_bundle("AI_deployment_limit", 1);
                        return;
                    end
                    --cm:modify_faction(AI_faction):remove_effect_bundle("AI_deployment_limit");
                    if force > 75 then
                        cm:modify_faction(AI_faction):apply_effect_bundle("AI_deployment_limit", 1);
                    else
                        cm:modify_faction(AI_faction):remove_effect_bundle("AI_deployment_limit");
                        if not cm:get_saved_value("huanlong_dead") 
                        and not cm:get_saved_value("hlyjdingzhie_has_been_killed") 
                        then
                            local modify_character_1 = cm:modify_faction("xyyhlyjf"):create_character_from_template("general", "3k_general_wood", "3k_xyy_template_scripted_xyyhlyjf_wood_strong_general", false);
                            local modify_character_2 = cm:modify_faction("xyyhlyjf"):create_character_from_template("general", "3k_general_metal", "3k_xyy_template_scripted_xyyhlyjf_metal_strong_late", false);
                            local modify_character_3 = cm:modify_faction("xyyhlyjf"):create_character_from_template("general", "3k_general_fire", "3k_xyy_template_scripted_xyyhlyjf_fire_strong_late", false);    
                            modify_character_1:add_experience(295000,0);
                            modify_character_2:add_experience(295000,0);
                            modify_character_3:add_experience(295000,0);
                            cdir_events_manager:add_or_remove_ceo_from_faction("xyyhlyjf", "hlyjdingzhibwuqi", true);
                            ancillaries:equip_ceo_on_character(modify_character_1:query_character(), "hlyjdingzhibwuqi", "3k_main_ceo_category_ancillary_weapon");
                            cdir_events_manager:add_or_remove_ceo_from_faction("xyyhlyjf", "hlyjdingzhibwuqi", true);
                            ancillaries:equip_ceo_on_character(modify_character_2:query_character(), "hlyjdingzhibwuqi", "3k_main_ceo_category_ancillary_weapon");
                            cdir_events_manager:add_or_remove_ceo_from_faction("xyyhlyjf", "hlyjdingzhibwuqi", true);
                            ancillaries:equip_ceo_on_character(modify_character_3:query_character(), "hlyjdingzhibwuqi", "3k_main_ceo_category_ancillary_weapon");
                            local found_pos, x, y = AI_faction:get_valid_spawn_location_in_region(AI_faction:capital_region():name(), false);
                            local index = 0
                            while not found_pos and AI_faction:region_list():num_items() > index do
                                local region = AI_faction:region_list():item_at(index)
                                index = index + 1
                            end
                            if found_pos then
                                cm:create_force_with_existing_general(modify_character_1:query_character():command_queue_index(), "xyyhlyjf", "", AI_faction:capital_region():name(), x, y, "hlyjdingzhia_force4", nil, 100);
                                if modify_character_1:query_character():has_military_force() then
                                    local modify_force = cm:modify_model():get_modify_military_force(modify_character_1:query_character():military_force());
                                    if modify_force:query_military_force():character_list():num_items() < 3 then
                                        modify_force:add_existing_character_as_retinue(modify_character_2, true);
                                    end
                                    if modify_force:query_military_force():character_list():num_items() < 3 then
                                        modify_force:add_existing_character_as_retinue(modify_character_3, true);
                                    end
                                end
                            end
                        end
                    end
                    return;
                elseif cm:get_saved_value("roguelike_mode") then
                    if cm:get_saved_value("xyy_roguelike_mission_target_faction") 
                    and AI_faction:name() == cm:get_saved_value("xyy_roguelike_mission_target_faction") 
                    then
                        if force > 75 then
                            cm:modify_faction(AI_faction):apply_effect_bundle("AI_deployment_limit", 1);
                        else
                            cm:modify_faction(AI_faction):remove_effect_bundle("AI_deployment_limit");
                        end
                    else
                        if force > 45 then
                            cm:modify_faction(AI_faction):apply_effect_bundle("AI_deployment_limit", 1);
                        else
                            cm:modify_faction(AI_faction):remove_effect_bundle("AI_deployment_limit");
                        end
                    end
                elseif AI_faction:name() == "3k_main_faction_cao_cao" and cm:query_model():campaign_name() == "3k_dlc07_start_pos" then
                    if cm:query_model():calendar_year() < 207 and not valid_check() then
                        if cm:query_model():calendar_year() < 202 and force < 45 then
                            cm:modify_faction(AI_faction):remove_effect_bundle("AI_deployment_limit");
                        elseif cm:query_model():calendar_year() < 203 and force < 55 then
                            cm:modify_faction(AI_faction):remove_effect_bundle("AI_deployment_limit");
                        elseif cm:query_model():calendar_year() < 204 and force < 65 then
                            cm:modify_faction(AI_faction):remove_effect_bundle("AI_deployment_limit");
                        elseif force < 75 then
                            cm:modify_faction(AI_faction):remove_effect_bundle("AI_deployment_limit");
                        else
                            cm:modify_faction(AI_faction):apply_effect_bundle("AI_deployment_limit", 1);
                        end
                    else
                        if force >= 45 then
                            cm:modify_faction(AI_faction):apply_effect_bundle("AI_deployment_limit", 1);
                        else
                            cm:modify_faction(AI_faction):remove_effect_bundle("AI_deployment_limit");
                        end
                    end
                elseif AI_faction:has_effect_bundle("xyy_yuan_shao_AI") 
                or AI_faction:has_effect_bundle("xyy_yellow_turbans_AI")
                or AI_faction:has_effect_bundle("inazuma_AI") then
                    if force >= 75 then
                        cm:modify_faction(AI_faction):apply_effect_bundle("AI_deployment_limit", 1);
                    else
                        cm:modify_faction(AI_faction):remove_effect_bundle("AI_deployment_limit");
                    end
                else
                    if force >= 30 then
                        cm:modify_faction(AI_faction):apply_effect_bundle("AI_deployment_limit", 1);
                    else
                        cm:modify_faction(AI_faction):remove_effect_bundle("AI_deployment_limit");
                    end
                end
                
                if AI_faction:treasury() > 20000 and AI_faction:treasury() <= 100000 then
                    local lock_money = AI_faction:treasury() * 0.6
                    cm:modify_faction(AI_faction):decrease_treasury(lock_money)
                    cm:set_saved_value(faction_name .. "_treasury", lock_money)
                elseif AI_faction:treasury() > 100000 and AI_faction:treasury() <= 1000000 then
                    local lock_money = AI_faction:treasury() * 0.9
                    cm:modify_faction(AI_faction):decrease_treasury(lock_money)
                    cm:set_saved_value(faction_name .. "_treasury", lock_money)
                elseif AI_faction:treasury() > 1000000 then
                    local lock_money = AI_faction:treasury() - 100000
                    cm:modify_faction(AI_faction):decrease_treasury(lock_money)
                    cm:set_saved_value(faction_name .. "_treasury", lock_money)
                end
            end
        end
    end,
    true
)
        
core:add_listener(
    "AI_deployment_limit_2",
    "FactionTurnEnd",
    function(context)
        return not context:faction():is_dead() 
        and not context:faction():is_human() 
        and context:faction():name() == query_faction
        and not context:faction():name() == "xyyhlyjf" 
        and not context:faction():faction_leader():generation_template_key() == "hlyjcm";
    end,
    function(context)
        local faction = context:faction()
        limit = 0;
        cm:modify_faction(faction):apply_effect_bundle("force_escape", -1);
        local lock_money = cm:get_saved_value(query_faction .. "_treasury");
        if lock_money and lock_money > 0 then
            cm:modify_faction(faction):increase_treasury(lock_money);
            cm:set_saved_value(query_faction .. "_treasury", 0);
        end
        query_faction = nil
    end,
    true
)

core:add_listener(
    "AI_deployment_force_created",
    "MilitaryForceCreated",
    function(context)
        return query_faction
        and context:military_force_created():faction():name() == query_faction;
    end,
    function(context)
        local max_value = 5
        if query_faction == "xyyhlyjf" then
            max_value = 11
        end
        
        if query_faction == "xyyhlyjf" then
            max_value = 11
        end
        if limit < 5 then
            limit = limit + 1;
        else
            limit = 0;
            cm:modify_faction(query_faction):apply_effect_bundle("AI_deployment_limit", 1);
        end
        --ModLog(query_faction .. " ".. limit .. "/" .. max_value)
    end,
    true
)
core:add_listener(
    "AI_deployment_limit_player_turn",
    "FactionTurnStart",
    function(context)
        return context:faction():is_human()
    end,
    function(context)
        local world_faction_list = cm:query_model():world():faction_list();
        for i = 0, world_faction_list:num_items() - 1 do
            local AI_faction = world_faction_list:item_at(i);
            if not AI_faction:is_null_interface()
            and not AI_faction:is_dead()
            and not AI_faction:is_human()
            and AI_faction:has_effect_bundle("force_escape")
            then
                cm:modify_faction(AI_faction):remove_effect_bundle("force_escape");
            end
        end
    end,
    true
)

core:add_listener(
    "AI_deployment_limit_force_battle",
    "PendingBattle",
    true,
    function(context)
        local pb = cm:query_model():pending_battle();
            
        if pb:human_involved() 
        then
            --ModLog("玩家参与的战斗，移除保护")
            local world_faction_list = cm:query_model():world():faction_list();
            for i = 0, world_faction_list:num_items() - 1 do
                local AI_faction = world_faction_list:item_at(i);
                if not AI_faction:is_null_interface()
                and not AI_faction:is_dead()
                and not AI_faction:is_human()
                and AI_faction:has_effect_bundle("force_escape")
                then
                    cm:modify_faction(AI_faction):remove_effect_bundle("force_escape");
                end
            end
        end
        
        if not pb:human_involved() 
        then
            --ModLog("没有玩家参与的战斗，增加保护")
            local world_faction_list = cm:query_model():world():faction_list();
            for i = 0, world_faction_list:num_items() - 1 do
                local AI_faction = world_faction_list:item_at(i);
                if not AI_faction:is_null_interface()
                and not AI_faction:is_dead()
                and not AI_faction:is_human()
                and not AI_faction:has_effect_bundle("force_escape")
                then
                    cm:modify_faction(AI_faction):apply_effect_bundle("force_escape", 1);
                end
            end
        end
    end,
    true
)


-- core:add_listener(
--     "AI_deployment_limit_force_battle",
--     "CharacterTargetEvent",
--     function(context)
--         --ModLog("CharacterTargetEvent")
--         --ModLog(context:query_character():generation_template_key())
--         --ModLog(context:query_target_character():generation_template_key())
--         return true;
--     end,
--     function(context)
--         if context:query_target_character():faction():is_human()
--         or context:query_character():faction():is_human() then
--             --ModLog("玩家参与的战斗，移除保护")
--             if context:query_target_character():faction():has_effect_bundle("force_escape") then
--                 cm:modify_faction(context:query_target_character():faction()):remove_effect_bundle("force_escape");
--             else
--             if context:query_character():faction():has_effect_bundle("force_escape") then
--                 cm:modify_faction(context:query_character():faction()):remove_effect_bundle("force_escape");
--             then
--         else
--             if not context:query_target_character():faction():has_effect_bundle("force_escape") then
--                 cm:modify_faction(context:query_target_character():faction()):apply_effect_bundle("force_escape",1);
--             else
--             if not context:query_character():faction():has_effect_bundle("force_escape") then
--                 cm:modify_faction(context:query_character():faction()):apply_effect_bundle("force_escape",1);
--             then
--         end
--     end,
--     true
-- )
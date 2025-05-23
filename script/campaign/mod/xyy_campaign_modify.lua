local gst = xyy_gst:get_mod()
--本脚本主要为三国演义的剧情模式做铺垫

local liu_biao_death = false;
local cao_cao_military = nil
local liu_bei_military = nil
local sun_quan_military = nil

function valid_check()
    return not cm:get_saved_value("invalid")
end

function is_cao_cao_turn()
    return cm:query_model():world():whose_turn_is_it():name() == "3k_main_faction_cao_cao"
end

function is_liu_bei_turn()
    return cm:query_model():world():whose_turn_is_it():name() == "3k_main_faction_liu_bei"
end

function region_set_random_manager(region_key, faction_key)
    if not cm:query_region(region_key)
    or cm:query_region(region_key):is_null_interface()
    then
        return;
    end
    if cm:query_region(region_key):owning_faction():name() == faction_key
    then
        return;
    end
    local random = cm:random_int(1000,1)
    if not cm:query_region(region_key):owning_faction():is_human()
    and cm:query_region(region_key):owning_faction():name() ~= "xyyhlyjf"
    and cm:query_region(region_key):owning_faction():faction_leader():generation_template_key() ~= "hlyjcm"
    and random > 200
    then
        cm:modify_region(region_key):settlement_gifted_as_if_by_payload(cm:modify_faction(faction_key));
        ModLog("设置领地：" .. region_key .. "交给" .. faction_key);
    end
end;

--200年：张郃投靠曹操
core:add_listener(
    "zhang_he_cao_cao",
    "FactionTurnStart",
    function(context)
        return 
        context:query_model():calendar_year() >= 200
        and context:query_model():season() ~= "season_spring"
        and context:query_model():turn_number() > 1
    end,
    function(context)
        local zhanghe = gst.character_query_for_template("3k_main_template_historical_zhang_he_hero_fire")
        if not zhanghe:is_dead() and zhanghe:faction():name() == "3k_main_faction_yuan_shao" then
            local incident = cm:modify_model():create_incident("zhang_he_joins_cao_cao");
            incident:add_character_target("target_character_1", zhanghe);
            incident:add_faction_target("target_faction_1", cm:query_faction("3k_main_faction_cao_cao"));
            incident:trigger(cm:modify_faction("3k_main_faction_cao_cao"), true);
            cm:modify_character(gst.character_query_for_template("3k_main_template_historical_yuan_shao_hero_earth")):apply_relationship_trigger_set(zhanghe, "3k_main_relationship_trigger_set_event_negative_betrayed");
            cm:modify_character(zhanghe):apply_effect_bundle("essentials_effect_bundle", -1)
        end
    end,
    false
)


--200年：下邳之战
core:add_listener(
    "guan_yu_cao_cao_200_liu_bei",
    "FirstTickAfterWorldCreated",
    function(context)
        return 
        context:query_model():calendar_year() == 200
        and context:query_model():turn_number() == 1
        and cm:query_model():campaign_name() == "3k_dlc07_start_pos"
        and valid_check()
    end,
    function()
        local guanyu = gst.character_query_for_template("3k_main_template_historical_guan_yu_hero_wood")
        if not guanyu:is_null_interface() 
        and not guanyu:is_dead()
        and guanyu:faction():name() == "3k_main_faction_liu_bei" 
        then
            cm:modify_character(guanyu):apply_effect_bundle("freeze", 1);
            local cao_cao = gst.character_query_for_template("3k_main_template_historical_cao_cao_hero_earth")
            if not cm:query_faction("3k_main_faction_cao_cao"):is_human() then
                cm:modify_character(cao_cao):attack(guanyu);
            end
        end
        if not cm:query_faction("3k_main_faction_yuan_shao"):is_human() then
            local yuan_shao = gst.character_query_for_template("3k_main_template_historical_yuan_shao_hero_earth")
            cm:modify_character(yuan_shao):apply_effect_bundle("freeze", 3);
        end
    end,
    false
)


--200年：下邳之战，曹操招降关羽
core:add_listener(
    "guan_yu_cao_cao_200",
    "PendingBattle",
    function(context)
        local guanyu = gst.character_query_for_template("3k_main_template_historical_guan_yu_hero_wood");
        return 
        context:query_model():calendar_year() >= 200
        and context:query_model():calendar_year() < 202
        and guanyu:faction():name() == "3k_main_faction_liu_bei"
        and cm:query_model():campaign_name() == "3k_dlc07_start_pos"
        and is_cao_cao_turn()
        and valid_check()
    end,
    function(context)
        local pb = cm:query_model():pending_battle();
        --如果进攻方为曹操，防守方为关羽，不论输赢
        
        if pb:has_attacker() then
            ModLog("PendingBattle: " .. pb:attacker():generation_template_key());
        end
        
        if pb:has_defender() then
            ModLog("PendingBattle: " .. pb:defender():generation_template_key());
        end
        
        if pb:has_attacker() 
        and pb:attacker():generation_template_key() == "3k_main_template_historical_cao_cao_hero_earth"
        and pb:has_defender() 
        and pb:defender():generation_template_key() == "3k_main_template_historical_guan_yu_hero_wood"
        and pb:has_been_fought() 
        then
            --移除本监听器
            core:remove_listener("guan_yu_cao_cao_200");
        end
    end,
    true
)

core:add_listener(
    "cao_cao_AI_guan_yu",
    "FactionTurnStart",
    function(context)
        return 
        context:query_model():calendar_year() == 200
        and context:query_model():turn_number() > 1
        and not cm:query_faction("3k_main_faction_cao_cao"):is_human()
        and cm:query_model():campaign_name() == "3k_dlc07_start_pos"
        and valid_check()
    end,
    function(context)
        local guanyu = gst.character_query_for_template("3k_main_template_historical_guan_yu_hero_wood");
        if not guanyu:is_dead() and guanyu:faction():name() ~= "3k_main_faction_cao_cao" then
            --关羽加入曹操派系
            local guanyu = gst.character_add_to_faction("3k_main_template_historical_guan_yu_hero_wood", "3k_main_faction_cao_cao", "3k_general_wood");
            local lady_mi = gst.character_add_to_faction("3k_dlc04_template_historical_lady_mi_earth", "3k_main_faction_cao_cao", "3k_general_earth");
            --关羽获赠赤兔马
            gst.character_CEO_equip("3k_main_template_historical_guan_yu_hero_wood","3k_main_ancillary_mount_red_hare","3k_main_ceo_category_ancillary_mount");
            cm:trigger_incident(cm:query_faction("3k_main_faction_liu_bei"), "guan_yu_liu_bei_200", true);
        end
    end,
    false
)

--曹操完成击溃关羽任务
core:add_listener(
    "guan_yu_cao_cao_200_enslave",
    "BattleCompletedCameraMove",
    function(context)
        return not cm:get_saved_value("guan_yu_cao_cao_200_enslave")
        and valid_check()
    end,
    function(context)
        local guanyu = gst.character_query_for_template("3k_main_template_historical_guan_yu_hero_wood");
        if not guanyu:is_dead()
        and not guanyu:is_character_is_faction_recruitment_pool()
        and guanyu:faction():name() == "3k_main_faction_cao_cao" 
        then
            if cm:query_faction("3k_main_faction_cao_cao"):is_human() then
                --赠予赤兔马任务
                cm:trigger_mission(cm:query_faction("3k_main_faction_cao_cao"), "guan_yu_cao_cao_200", true);
                --关羽加入曹操派系
                local lady_mi = gst.character_add_to_faction("3k_dlc04_template_historical_lady_mi_earth", "3k_main_faction_cao_cao", "3k_general_earth");
                if cm:query_faction("3k_main_faction_liu_bei"):is_human() then
                    cm:trigger_incident(cm:query_faction("3k_main_faction_liu_bei"), "guan_yu_liu_bei_200", true);
                end
                cm:set_saved_value("guan_yu_cao_cao_200_enslave", true);
                --如果曹操不是玩家
            else
                --关羽加入曹操派系
                local guanyu = gst.character_add_to_faction("3k_main_template_historical_guan_yu_hero_wood", "3k_main_faction_cao_cao", "3k_general_wood");
                local lady_mi = gst.character_add_to_faction("3k_dlc04_template_historical_lady_mi_earth", "3k_main_faction_cao_cao", "3k_general_earth");
                --关羽获赠赤兔马
                gst.character_CEO_equip("3k_main_template_historical_guan_yu_hero_wood","3k_main_ancillary_mount_red_hare","3k_main_ceo_category_ancillary_mount");
                cm:trigger_incident(cm:query_faction("3k_main_faction_liu_bei"), "guan_yu_liu_bei_200", true);
                cm:set_saved_value("guan_yu_cao_cao_200_enslave", true);
            end
        end
    end,
    false
)


--曹操完成赠予赤兔马任务
core:add_listener(
    "guan_yu_cao_cao_200_completed",
    "MissionSucceeded",
    function(context)
        return context:mission():mission_record_key() == "guan_yu_cao_cao_200"
        and valid_check()
    end,
    function(context)
        --曹操派系抽奖券+20
        gst.faction_add_tickets(context:faction():name(), 20);
    end,
    false
)

--200年：关羽斩颜良
core:add_listener(
    "guan_yu_kill_yan_liang",
    "FactionTurnStart",
    function(context)
        local guan_yu = gst.character_query_for_template("3k_main_template_historical_guan_yu_hero_wood");
        return 
        context:query_model():calendar_year() == 200
        and context:query_model():turn_number() > 1
        and context:faction():is_human()
        and guan_yu:faction():name() == "3k_main_faction_cao_cao"
        and cm:query_model():campaign_name() == "3k_dlc07_start_pos"
        and not cm:query_faction("3k_main_faction_yuan_shao"):is_human()
        and valid_check()
    end,
    function(context)
        --如果曹操是玩家
        if cm:query_faction("3k_main_faction_cao_cao"):is_human() then
        
            cm:trigger_mission(cm:query_faction("3k_main_faction_cao_cao"), "guan_yu_kill_yan_liang", true);
            
            local guan_yu = gst.character_query_for_template("3k_main_template_historical_guan_yu_hero_wood");
            local yan_liang = gst.character_query_for_template("3k_main_template_historical_yan_liang_hero_fire");
            local yuan_shao = gst.character_query_for_template("3k_main_template_historical_yuan_shao_hero_earth")
            local yuan_shao_faction = cm:query_faction("3k_main_faction_yuan_shao");
            
            --目标地为东郡
            local region = "3k_main_dongjun_capital";
            
            --放置关羽军队
            found_pos, x, y = cm:query_faction("3k_main_faction_cao_cao"):get_valid_spawn_location_in_region(region, false);
            cm:create_force_with_existing_general(guan_yu:command_queue_index(), "3k_main_faction_cao_cao", "", region, x, y, "guan_yu_force_0", nil, 100);
        else
            --触发斩颜良事件
            --cm:trigger_incident(context:faction(), "guan_yu_kill_yan_liang", true);
        end
    end,
    false
)

            
--曹操获得斩颜良任务
core:add_listener(
    "guan_yu_kill_yan_liang_mission",
    "BattleCompletedCameraMove",
    function(context)
        return true
    end,
    function(context)
        local cao_cao_faction = cm:query_faction("3k_main_faction_cao_cao")
        if cao_cao_faction:is_mission_active("guan_yu_kill_yan_liang") then
            local yan_liang = gst.character_query_for_template("3k_main_template_historical_yan_liang_hero_fire");
            if yan_liang:is_wounded() then
                ModLog("yan_liang_is_wounded")
                cm:modify_faction(cao_cao_faction):complete_custom_mission("guan_yu_kill_yan_liang")
            end
            if yan_liang:is_dead() then
                cm:modify_faction(cao_cao_faction):complete_custom_mission("guan_yu_kill_yan_liang")
            end
        end
    end,
    true
)

--曹操获得斩文丑任务
core:add_listener(
    "guan_yu_kill_wen_chou_mission",
    "BattleCompletedCameraMove",
    function(context)
        return true
    end,
    function(context)
        local cao_cao_faction = cm:query_faction("3k_main_faction_cao_cao")
        if cao_cao_faction:is_mission_active("guan_yu_kill_wen_chou") then
            local wen_chou = gst.character_query_for_template("3k_main_template_historical_wen_chou_hero_wood");
            if wen_chou:is_wounded() then
                cm:modify_faction(cao_cao_faction):complete_custom_mission("guan_yu_kill_wen_chou")
            end
            if wen_chou:is_dead() then
                cm:modify_faction(cao_cao_faction):complete_custom_mission("guan_yu_kill_wen_chou")
            end
        end
    end,
    true
)

core:add_listener(
    "guan_yu_kill_wen_chou_trigger",
    "MissionSucceeded",
    function(context)
        return context:mission():mission_record_key() == "guan_yu_kill_yan_liang"
        and valid_check()
    end,
    function(context)
        core:remove_listener("guan_yu_kill_yan_liang");
        gst.character_force_been_killed("3k_main_template_historical_yan_liang_hero_fire");
        cm:trigger_mission(cm:query_faction("3k_main_faction_cao_cao"), "guan_yu_kill_wen_chou", true); 
    end,
    false
)

--200年：关羽加入曹操
core:add_listener(
    "zhang_he_cao_cao",
    "FactionTurnStart",
    function(context)
        local guan_yu = gst.character_query_for_template("3k_main_template_historical_guan_yu_hero_wood");
        return 
        context:query_model():calendar_year() >= 200
        and valid_check()
        and context:query_model():turn_number() > 1
        and not cm:query_faction("3k_main_faction_yuan_shao"):is_human()
        and not cm:query_faction("3k_main_faction_cao_cao"):is_human()
        and context:faction():name() == "3k_main_faction_cao_cao"
        and guan_yu:faction():name() == "3k_main_faction_cao_cao"
        and not guan_yu:has_military_force()
        and cm:query_model():campaign_name() == "3k_dlc07_start_pos";
    end,
    function()
        local region = "3k_main_dongjun_capital";
        local guan_yu = gst.character_query_for_template("3k_main_template_historical_guan_yu_hero_wood");
        --放置关羽军队
        found_pos, x, y = cm:query_faction("3k_main_faction_cao_cao"):get_valid_spawn_location_in_region(region, false);
        cm:create_force_with_existing_general(guan_yu:command_queue_index(), "3k_main_faction_cao_cao", "", region, x, y, "guan_yu_force_0", nil, 100);
    end,
    false
)

--200年：关羽斩文丑
core:add_listener(
    "guan_yu_kill_yan_liang_incident",
    "FactionTurnStart",
    function(context)
        local guan_yu = gst.character_query_for_template("3k_main_template_historical_guan_yu_hero_wood");
        return 
        context:query_model():calendar_year() == 200
        and valid_check()
        and context:query_model():turn_number() > 2
        and context:faction():is_human()
        and guan_yu:faction():name() == "3k_main_faction_cao_cao"
        and cm:query_model():campaign_name() == "3k_dlc07_start_pos"
        and not cm:query_faction("3k_main_faction_cao_cao"):is_human()
        and not cm:query_faction("3k_main_faction_yuan_shao"):is_human()
    end,
    function(context)
        --如果曹操不是玩家
        if not cm:query_faction("3k_main_faction_cao_cao"):is_human() then
            --触发斩文丑事件
            cm:trigger_incident(context:faction(), "guan_yu_kill_yan_liang", true);
        end
        if cm:query_faction("3k_main_faction_liu_bei"):is_human() then
            cm:trigger_incident(cm:query_faction("3k_main_faction_liu_bei"), "guan_yu_kill_yan_liang_liu_bei", true);
        end
    end,
    false
)

--200年：关羽斩文丑
core:add_listener(
    "guan_yu_kill_wen_chou_incident",
    "FactionTurnStart",
    function(context)
        local guan_yu = gst.character_query_for_template("3k_main_template_historical_guan_yu_hero_wood");
        return 
        context:query_model():calendar_year() == 200
        and valid_check()
        and context:query_model():turn_number() > 3
        and context:faction():is_human()
        and guan_yu:faction():name() == "3k_main_faction_cao_cao"
        and cm:query_model():campaign_name() == "3k_dlc07_start_pos"
        and not cm:query_faction("3k_main_faction_cao_cao"):is_human()
        and not cm:query_faction("3k_main_faction_yuan_shao"):is_human()
    end,
    function(context)
        --如果曹操不是玩家
        if not cm:query_faction("3k_main_faction_cao_cao"):is_human() then
            --触发斩文丑事件
            cm:trigger_incident(context:faction(), "guan_yu_kill_wen_chou", true);
        end
        if cm:query_faction("3k_main_faction_liu_bei"):is_human() then
            cm:trigger_incident(cm:query_faction("3k_main_faction_liu_bei"), "guan_yu_kill_wen_chou_liu_bei", true);
        end
    end,
    false
)

--200年：袁绍问罪
core:add_listener(
    "guan_yu_kill_wen_chou_2",
    "FactionTurnStart",
    function(context)
        local guan_yu = gst.character_query_for_template("3k_main_template_historical_guan_yu_hero_wood");
        local yan_liang = gst.character_query_for_template("3k_main_template_historical_yan_liang_hero_fire");
        local wen_chou = gst.character_query_for_template("3k_main_template_historical_wen_chou_hero_wood");
        return 
        context:query_model():calendar_year() < 203
        and valid_check()
        and context:query_model():turn_number() > 3
        and is_liu_bei_turn()
        and guan_yu:faction():name() == "3k_main_faction_cao_cao"
        and yan_liang:is_dead()
        and wen_chou:is_dead()
        and not cm:query_faction("3k_main_faction_yuan_shao"):is_human()
        and cm:query_model():campaign_name() == "3k_dlc07_start_pos"
        and not cm:get_saved_value("yuan_shao_liu_bei")
        --and (cm:query_model():event_generator_interface():have_any_of_incidents_been_generated(cm:query_faction("3k_main_faction_liu_bei"),"guan_yu_kill_wen_chou;guan_yu_kill_yan_liang")
        --or cm:query_model():event_generator_interface():have_any_of_incidents_been_generated(cm:query_faction("3k_main_faction_liu_bei"),"guan_yu_kill_yan_liang_liu_bei;guan_yu_kill_wen_chou_liu_bei"))
    end,
    function(context)
        if cm:query_faction("3k_main_faction_liu_bei"):is_human() then
            cm:trigger_dilemma(context:faction(), "yuan_shao_liu_bei", true);
        end
        cm:set_saved_value("yuan_shao_liu_bei", true)
    end,
    false
)

--202年：袁绍问罪，事件选择结果
core:add_listener(
    "yuan_shao_liu_bei_choice",
    "DilemmaChoiceMadeEvent",
    function(context)
        return 
        context:dilemma() == "yuan_shao_liu_bei"
        and valid_check()
    end,
    function(context)
        if context:choice() == 0 then
            gst.faction_add_tickets(context:faction():name(), 20);
        else
            cm:set_saved_value("invalid", true);
        end
        
    end,
    false
)


core:add_listener(
    "guan_yu_kill_wen_chou_succeeded",
    "MissionSucceeded",
    function(context)
        return context:mission():mission_record_key() == "guan_yu_kill_wen_chou"
        and valid_check()
    end,
    function(context)
        gst.character_force_been_killed("3k_main_template_historical_wen_chou_hero_wood");
        gst.faction_add_tickets(context:faction():name(), 20);
    end,
    false
)

--202年：关羽千里走单骑
core:add_listener(
    "guan_yu_cao_cao_202",
    "FactionTurnStart",
    function(context)
        local liu_bei = gst.character_query_for_template("3k_main_template_historical_liu_bei_hero_earth");
        local guan_yu = gst.character_query_for_template("3k_main_template_historical_guan_yu_hero_wood");
        local liu_bei_faction = cm:query_faction("3k_main_faction_liu_bei");
        
        return 
        context:query_model():calendar_year() >= 202
        and context:query_model():calendar_year() < 207
        and valid_check()
        and cm:query_model():campaign_name() == "3k_dlc07_start_pos"
        and not liu_bei:is_dead()
        and not liu_bei_faction:is_dead()
        and liu_bei_faction:faction_leader():generation_template_key() == "3k_main_template_historical_liu_bei_hero_earth"
        and not guan_yu:is_dead()
        and guan_yu:faction():name() == "3k_main_faction_cao_cao"
        and not cm:get_saved_value("guan_yu_leave")
    end,
    function(context)
        --如果曹操是玩家
        if cm:query_faction("3k_main_faction_cao_cao"):is_human() then
            if context:faction():name() == "3k_main_faction_cao_cao" then
            --曹操选择是否留下关羽
                cm:trigger_dilemma("3k_main_faction_cao_cao", "guan_yu_cao_cao_202", true);
                cm:set_saved_value("guan_yu_leave", true)
            end
        --否则，如果刘备是玩家
        else
            local guanyu = gst.character_add_to_faction("3k_main_template_historical_guan_yu_hero_wood", "3k_main_faction_liu_bei", "3k_general_wood");
            local lady_mi = gst.character_add_to_faction("3k_dlc04_template_historical_lady_mi_earth", "3k_main_faction_liu_bei", "3k_general_earth");
            local humans = cm:get_human_factions();
            for i, faction_key in ipairs(humans) do
                if faction_key ~= "3k_main_faction_cao_cao" then
                    cm:trigger_incident(cm:query_faction(faction_key), "guan_yu_liu_bei_202", true);
                end
            end
            cm:set_saved_value("guan_yu_leave", true)
        end
    end,
    true
)

--202年：关羽千里走单骑，事件选择结果
core:add_listener(
    "guan_yu_cao_cao_202_choice",
    "DilemmaChoiceMadeEvent",
    function(context)
        return 
        context:dilemma() == "guan_yu_cao_cao_202"
        and valid_check()
    end,
    function(context)
        --玩家选择留下
        if context:choice() == 0 then
            --cm:set_saved_value("invalid", true);
        end
        --玩家选择放行，触发过五关斩六将事件
        if context:choice() == 1 then
            --曹操派系抽奖券+20
            gst.faction_add_tickets(context:faction():name(), 20);
            local incident = cm:modify_model():create_incident("guan_yu_liu_bei_202");
            local guanyu = gst.character_add_to_faction("3k_main_template_historical_guan_yu_hero_wood", "3k_main_faction_liu_bei", "3k_general_wood");
            local lady_mi = gst.character_add_to_faction("3k_dlc04_template_historical_lady_mi_earth", "3k_main_faction_liu_bei", "3k_general_earth");
            incident:add_character_target("target_character_1", guanyu);
            incident:trigger(cm:modify_faction(context:faction()), true);
            --终止斩颜良文丑事件
            cm:modify_faction("3k_main_faction_cao_cao"):cancel_custom_mission("guan_yu_kill_yan_liang");
            cm:modify_faction("3k_main_faction_cao_cao"):cancel_custom_mission("guan_yu_kill_wen_chou");
            local humans = cm:get_human_factions();
            for i, faction_key in ipairs(humans) do
                if faction_key ~= "3k_main_faction_cao_cao" then
                    cm:trigger_incident(cm:query_faction(faction_key), "guan_yu_liu_bei_202", true);
                end
            end
        end
    end,
    false
)

--201年
core:add_listener(
    "201_event",
    "FactionTurnStart",
    function(context)
        return 
        context:query_model():calendar_year() >= 200
        and context:query_model():calendar_year() < 207
        and valid_check()
        and not cm:get_saved_value("liu_bei_defeat")
        and cm:query_model():campaign_name() == "3k_dlc07_start_pos"
    end,
    function(context)
        cm:modify_faction("3k_main_faction_liu_bei"):apply_effect_bundle("xyy_liu_bei", -1);
        if not cm:query_faction("3k_main_faction_cao_cao"):is_human() then
            cm:modify_faction("3k_main_faction_cao_cao"):increase_treasury(20000);
            cm:modify_faction("3k_main_faction_cao_cao"):apply_effect_bundle("xyy_cao_cao_AI", 5);
        end
    end,
    true
)

--官渡之战，袁绍加强！
core:add_listener(
    "yuan_shao_ai",
    "FactionTurnStart",
    function(context)
        return 
        context:query_model():calendar_year() >= 200
        and not cm:query_faction("3k_main_faction_yuan_shao"):is_dead()
        and cm:query_model():campaign_name() == "3k_dlc07_start_pos"
        and context:faction():name() == "3k_main_faction_yuan_shao"
        and cm:query_faction("3k_main_faction_cao_cao"):is_human();
    end,
    function(context)
        cm:modify_faction("3k_main_faction_yuan_shao"):increase_treasury(20000);
        cm:modify_faction("3k_dlc05_faction_yuan_tan"):increase_treasury(10000);
        cm:modify_faction("3k_dlc07_faction_yuan_xi"):increase_treasury(10000);
        cm:modify_faction("3k_main_faction_yuan_shao"):apply_effect_bundle("xyy_yuan_shao_AI", 5);
        cm:modify_faction("3k_main_faction_liu_bei"):apply_effect_bundle("xyy_cao_cao", 5);
    end,
    true
)

--其他AI加强
core:add_listener(
    "190_ai",
    "FactionTurnStart",
    function(context)
        return cm:query_model():campaign_name() ~= "3k_dlc07_start_pos"
        and cm:query_model():campaign_name() ~= "8p_start_pos"
    end,
    function(context)
        if context:faction():name() == "3k_main_faction_dong_zhuo" and not context:faction():is_human() then
            if context:query_model():calendar_year() > 189 then
                cm:modify_faction(context:faction()):increase_treasury(20000);
                cm:modify_faction(context:faction()):apply_effect_bundle("xyy_yuan_shao_AI", -1);
            else
                cm:modify_faction(context:faction()):remove_effect_bundle("xyy_yuan_shao_AI");
            end
        end
        if context:faction():name() == "3k_main_faction_yuan_shao" and cm:get_saved_value("yuan_shao_event_199") and not context:faction():is_human() then
            cm:modify_faction(context:faction()):increase_treasury(20000);
            cm:modify_faction(context:faction()):apply_effect_bundle("xyy_yuan_shao_AI", -1);
        end
        if context:faction():name() == "3k_dlc04_faction_zhang_jue" and not context:faction():is_human() then
            cm:modify_faction(context:faction()):increase_treasury(10000);
            cm:modify_faction(context:faction()):apply_effect_bundle("xyy_yellow_turbans_AI", -1);
        end
        if context:faction():name() == "3k_dlc04_faction_zhang_bao" and not context:faction():is_human() then
            cm:modify_faction(context:faction()):increase_treasury(10000);
            cm:modify_faction(context:faction()):apply_effect_bundle("xyy_yellow_turbans_AI", -1);
        end
        if context:faction():name() == "3k_dlc04_faction_zhang_liang" and not context:faction():is_human() then
            cm:modify_faction(context:faction()):increase_treasury(10000);
            cm:modify_faction(context:faction()):apply_effect_bundle("xyy_yellow_turbans_AI", -1);
        end
        if context:faction():name() == "3k_dlc04_faction_zhang_jue" and context:faction():is_human() then
            cm:modify_faction(context:faction()):apply_effect_bundle("xyy_yellow_turbans_human", -1);
        end
        if context:faction():name() == "3k_dlc04_faction_zhang_bao" and context:faction():is_human() then
            cm:modify_faction(context:faction()):apply_effect_bundle("xyy_yellow_turbans_human", -1);
        end
        if context:faction():name() == "3k_dlc04_faction_zhang_liang" and context:faction():is_human() then
            cm:modify_faction(context:faction()):apply_effect_bundle("xyy_yellow_turbans_human", -1);
        end
        if context:faction():name() == "3k_dlc04_faction_empress_he" and not context:faction():is_human() then
            if not cm:query_faction("3k_dlc04_faction_zhang_jue"):is_human()
            and not cm:query_faction("3k_dlc04_faction_zhang_bao"):is_human()
            and not cm:query_faction("3k_dlc04_faction_zhang_liang"):is_human()
            then
                cm:modify_faction(context:faction()):apply_effect_bundle("xyy_emperor_AI", -1);
            else
                cm:modify_faction(context:faction()):increase_treasury(50000);
                cm:modify_faction(context:faction()):apply_effect_bundle("xyy_yuan_shao_AI", -1);
            end
        end
        if context:faction():is_world_leader() and not context:faction():is_human() then
            cm:modify_faction(context:faction()):increase_treasury(50000);
            cm:modify_faction(context:faction()):apply_effect_bundle("xyy_yuan_shao_AI", -1);
        end
    end,
    true
)

core:add_listener(
    "yuan_shao_ai_2",
    "RegionOwnershipChanged",
    function(context)
        return 
        context:previous_owner():name() == "3k_main_faction_yuan_shao"
        and valid_check()
        and not cm:query_faction("3k_main_faction_yuan_shao"):is_human()
        and not cm:get_saved_value("yuan_shao_ai_2")
        and context:previous_owner():region_list():num_items() <= 2
        and cm:query_faction("3k_main_faction_cao_cao"):is_human()
        and cm:query_model():campaign_name() == "3k_dlc07_start_pos"
    end,
    function()
        cm:set_saved_value("yuan_shao_ai_2",true);
        diplomacy_manager:force_confederation("3k_main_faction_yuan_shao", "3k_dlc05_faction_yuan_tan");
        diplomacy_manager:force_confederation("3k_main_faction_yuan_shao", "3k_main_faction_gao_gan");
        diplomacy_manager:force_confederation("3k_main_faction_yuan_shao", "3k_dlc07_faction_yuan_xi");
    end,
    false
)

core:add_listener(
    "yuan_shao_ai_3",
    "FactionTurnStart",
    function(context)
        local faction = cm:query_faction("3k_main_faction_yuan_shao")
        return 
        context:faction():name() == "3k_main_faction_yuan_shao"
        and valid_check()
        and not faction:is_human()
        and not cm:get_saved_value("yuan_shao_ai_2")
        and faction:region_list():num_items() <= 2
        and cm:query_faction("3k_main_faction_cao_cao"):is_human()
        and cm:query_model():campaign_name() == "3k_dlc07_start_pos"
    end,
    function()
        cm:set_saved_value("yuan_shao_ai_2",true);
        diplomacy_manager:force_confederation("3k_main_faction_yuan_shao", "3k_dlc05_faction_yuan_tan");
        diplomacy_manager:force_confederation("3k_main_faction_yuan_shao", "3k_main_faction_gao_gan");
        diplomacy_manager:force_confederation("3k_main_faction_yuan_shao", "3k_dlc07_faction_yuan_xi");
    end,
    false
)

--刘备战败
core:add_listener(
    "liu_bei_defeat_event",
    "RegionOwnershipChanged",
    function(context)
        --ModLog(context:previous_owner():name()..":"..context:previous_owner():region_list():num_items());
        return 
        context:previous_owner():name() == "3k_main_faction_liu_bei"
        and valid_check()
        and not cm:get_saved_value("liu_bei_defeat")
        and context:previous_owner():region_list():num_items() == 0
        and context:query_model():calendar_year() < 209
        and cm:query_model():campaign_name() == "3k_dlc07_start_pos"
        and cm:query_faction("3k_main_faction_liu_biao"):faction_leader():generation_template_key() == "3k_main_template_historical_liu_biao_hero_earth";
    end,
    function()
        cm:modify_faction("3k_main_faction_liu_bei"):remove_effect_bundle("xyy_liu_bei");
        
        cm:modify_faction("3k_main_faction_cao_cao"):remove_effect_bundle("xyy_cao_cao_AI");
        
        cm:modify_faction("3k_main_faction_cao_cao"):apply_effect_bundle("xyy_cao_cao_AI_2", 30);
        
        cm:modify_region("3k_main_nanyang_resource_1"):settlement_gifted_as_if_by_payload(cm:modify_faction("3k_main_faction_liu_bei"));
        cm:modify_region("3k_main_nanyang_capital"):settlement_gifted_as_if_by_payload(cm:modify_faction("3k_main_faction_liu_bei"));
        
        diplomacy_manager:apply_automatic_deal_between_factions("3k_main_faction_liu_bei", "3k_main_faction_cao_cao", "data_defined_situation_peace")
        
        diplomacy_manager:apply_automatic_deal_between_factions("3k_main_faction_liu_bei", "3k_dlc07_faction_zhang_xiu", "data_defined_situation_peace")
        
        diplomacy_manager:apply_automatic_deal_between_factions("3k_main_faction_liu_biao", "3k_main_faction_liu_bei", "data_defined_situation_peace")
        
        diplomacy_manager:apply_automatic_deal_between_factions("3k_main_faction_liu_biao", "3k_main_faction_liu_bei", "data_defined_situation_liu_biao_vassalise_recipient")
        
        cm:set_saved_value("liu_bei_defeat",true);
        if cm:query_faction("3k_main_faction_liu_bei"):is_human() then
            cm:trigger_incident("3k_main_faction_liu_bei", "liu_biao_vassalise_recipient", true);
            cm:trigger_mission(cm:modify_faction("3k_main_faction_liu_bei"), "3k_dlc07_mission_liu_bei_goto_jing", true);
        end
        if cm:query_faction("3k_main_faction_cao_cao"):is_human() then
            cm:modify_faction("3k_main_faction_cao_cao"):complete_custom_mission("3k_dlc07_guandu_begins_01_cao_cao_mission")
        end
    end,
    false
)

--203年
core:add_listener(
    "sun_quan_203",
    "FactionTurnStart",
    function(context)
        return 
        context:query_model():calendar_year() == 203
        and valid_check()
        and not cm:query_faction("3k_dlc05_faction_sun_ce"):is_human()
        and cm:query_model():campaign_name() == "3k_dlc07_start_pos";
    end,
    function(context)
        local faction = cm:query_faction("3k_dlc07_faction_shanyue_rebels") 
        if faction 
        and not faction:is_null_interface()
        and not faction:is_dead() 
        then
            for i = 0, faction:region_list():num_items() - 1 do
                local region = faction:region_list():item_at(i);
                if region
                and not region:is_null_interface()
                then
                    cm:modify_region(region):settlement_gifted_as_if_by_payload(cm:modify_faction("3k_dlc05_faction_sun_ce"));
                end
            end
            diplomacy_manager:apply_automatic_deal_between_factions("3k_dlc05_faction_sun_ce", "3k_dlc07_faction_shanyue_rebels", "data_defined_situation_peace")
        end
        
    end,
    false
)
core:add_listener(
    "3k_dlc07_mission_liu_bei_goto_jing_success",
    "MissionSucceeded",
    function(context)
        return context:mission():mission_record_key() == "3k_dlc07_mission_liu_bei_goto_jing"
        and valid_check()
    end,
    function(context)
        gst.faction_add_tickets(context:faction():name(), 20)
    end,
    false
)


core:add_listener(
    "3k_main_faction_cao_cao_ai_research_event",
    "FactionTurnStart",
    function(context)
        return 
        (context:query_model():season() == "season_summer"
        and valid_check()
        or context:query_model():season() == "season_spring")
        and cm:query_model():campaign_name() == "3k_dlc07_start_pos"
        and context:faction():name() == "3k_main_faction_cao_cao"
        and not cm:query_faction("3k_main_faction_cao_cao"):is_human();
    end,
    function()
        cm:modify_faction("3k_main_faction_cao_cao"):set_tech_research_cooldown(0);
    end,
    true
)

--200年：孙策之死，吴景合并
core:add_listener(
    "sun_ce_dead_confederation_wu_jing_force",
    "FactionTurnStart",
    function(context)
        return 
        context:query_model():calendar_year() >= 200
        and context:query_model():turn_number() > 1
        and not cm:query_faction("3k_dlc05_faction_wu_jing"):is_human()
    end,
    function()
        local humans = cm:get_human_factions();
        if not gst.lib_value_in_list(humans, "3k_dlc05_faction_sun_ce") 
        and not gst.lib_value_in_list(humans, "3k_main_faction_sun_jian") 
        then
            local sun_ce = gst.character_query_for_template("3k_main_template_historical_sun_ce_hero_fire");
            local sun_ce_faction = sun_ce:faction()
            local incident = cm:modify_model():create_incident("3k_main_historical_sun_death_of_sun_ce_npc_incident");
            if sun_ce == sun_ce:faction():faction_leader() then
                for i, faction_key in ipairs(humans) do
                    incident:trigger(cm:modify_faction(faction_key), true);
                end
                gst.character_been_killed("3k_main_template_historical_sun_ce_hero_fire");
                local sun_quan = gst.character_add_to_faction("3k_main_template_historical_sun_quan_hero_earth", sun_ce_faction:name(), "3k_general_earth");
                cm:modify_character(sun_quan):assign_faction_leader()
            end
        else
            cm:trigger_dilemma(cm:query_faction(faction_key), "3k_main_historical_sun_death_of_sun_ce_pc_dilemma", true);
        end
        gst.character_been_killed("3k_main_template_historical_xu_zhao_hero_earth");
        diplomacy_manager:force_confederation("3k_dlc05_faction_sun_ce", "3k_dlc05_faction_wu_jing");
        diplomacy_manager:apply_automatic_deal_between_factions("3k_dlc05_faction_sun_ce", "3k_dlc05_faction_xu_zhao", "data_defined_situation_war_proposer_to_recipient");
        local lu_meng = gst.character_query_for_template("3k_main_template_historical_lu_meng_hero_metal");
        if lu_meng and not lu_meng:is_null_interface() then
            cm:modify_character(lu_meng):apply_effect_bundle("essentials_effect_bundle",-1);
        end
        local cheng_pu = gst.character_query_for_template("3k_main_template_historical_cheng_pu_hero_metal");
        if cheng_pu and not cheng_pu:is_null_interface() then
            cm:modify_character(cheng_pu):apply_effect_bundle("essentials_effect_bundle",-1);
        end
    end,
    false
)

--200年：孙策之死
core:add_listener(
    "sun_ce_dead_dilemma",
    "DilemmaChoiceMadeEvent",
    function(context)
        return 
        context:dilemma() == "3k_main_historical_sun_death_of_sun_ce_pc_dilemma"
    end,
    function()
        if context:choice() == 0 then
            local incident = cm:modify_model():create_incident("3k_main_historical_sun_death_of_sun_ce_npc_incident");
            for i, faction_key in ipairs(humans) do
                incident:trigger(cm:modify_faction(faction_key), true);
            end
            if context:faction():name() == "3k_main_faction_sun_jian" or context:faction():name() == "3k_dlc05_faction_sun_ce" then
                local sun_quan = gst.character_add_to_faction("3k_main_template_historical_sun_quan_hero_earth", context:faction():name(), "3k_general_earth");
                cm:modify_character(sun_quan):assign_faction_leader()
            end
        end
    end,
    false
)

--207年：曹操获得徐庶
core:add_listener(
    "xu_shu_join_cao_cao",
    "FactionTurnStart",
    function(context)
        return 
        context:query_model():calendar_year() == 207
        and not cm:query_faction("3k_main_faction_liu_bei"):is_human()
        and cm:query_model():campaign_name() == "3k_dlc07_start_pos"
        and valid_check()
    end,
    function()
        --local xu_shu = gst.character_query_for_template("3k_main_template_historical_xu_shu_hero_water")
        gst.character_add_to_faction("3k_main_template_historical_xu_shu_hero_water", "3k_main_faction_cao_cao", "3k_general_water")
        gst.character_add_to_faction("3k_main_template_historical_pang_tong_hero_water", "3k_main_faction_liu_bei", "3k_general_water"); 
    end,
    false
)
--207年：曹操击败袁绍，统一北方
core:add_listener(
    "cao_cao_ai_confederation_listener_yuan_shao_force",
    "FactionTurnStart",
    function(context)
        local faction = cm:query_faction("3k_main_faction_cao_cao")
        return cm:query_model():campaign_name() == "3k_dlc07_start_pos" 
        --and context:faction():name() == "3k_main_faction_cao_cao"
        and context:query_model():calendar_year() == 207 
        and valid_check()
        and not faction:is_dead() 
        and faction:region_list() 
        and faction:region_list():num_items() > 10 
        and not cm:query_faction("3k_main_faction_cao_cao"):is_human()
        and not cm:query_faction("3k_main_faction_yuan_shao"):is_human();
    end,
    function()
        local yuan_shang = gst.character_query_for_template("3k_main_template_historical_yuan_shang_hero_earth");
        
        local yuan_xi = gst.character_query_for_template("3k_main_template_historical_yuan_xi_hero_earth");
        
        local yuan_tan = gst.character_query_for_template("3k_main_template_historical_yuan_tan_hero_earth");
        
        local yuan_shao = gst.character_query_for_template("3k_main_template_historical_yuan_shao_hero_earth");
        
        if not yuan_xi:is_character_is_faction_recruitment_pool() and not yuan_xi:faction():is_human() then
            gst.character_been_killed("3k_main_template_historical_yuan_xi_hero_earth");
        end
        if not yuan_shang:is_character_is_faction_recruitment_pool() and not yuan_shang:faction():is_human() then
            gst.character_been_killed("3k_main_template_historical_yuan_shang_hero_earth");
        end
        if not yuan_tan:is_character_is_faction_recruitment_pool() and not yuan_tan:faction():is_human() then
            gst.character_been_killed("3k_main_template_historical_yuan_tan_hero_earth");
        end
        if not yuan_shao:is_character_is_faction_recruitment_pool() and not yuan_shao:faction():is_human() then
            gst.character_been_killed("3k_main_template_historical_yuan_shao_hero_earth");
        end
        diplomacy_manager:force_confederation("3k_main_faction_cao_cao", "3k_main_faction_yuan_shao");
        diplomacy_manager:force_confederation("3k_main_faction_cao_cao", "3k_dlc07_faction_yuan_xi");
        diplomacy_manager:force_confederation("3k_main_faction_cao_cao", "3k_dlc05_faction_yuan_tan");
        diplomacy_manager:force_confederation("3k_main_faction_cao_cao", "3k_main_faction_gao_gan");
        --diplomacy_manager:force_confederation("3k_main_faction_cao_cao", "3k_main_faction_ma_teng");
        --diplomacy_manager:force_confederation("3k_main_faction_cao_cao", "3k_main_faction_gongsun_du");
        --diplomacy_manager:force_confederation("3k_main_faction_cao_cao", "3k_main_faction_yellow_turban_anding");
        --凉州
        --武威
        --gst.region_set_manager("3k_main_wuwei_capital","3k_main_faction_cao_cao")
        --gst.region_set_manager("3k_main_wuwei_resource_1","3k_main_faction_cao_cao")
        --gst.region_set_manager("3k_main_wuwei_resource_2","3k_main_faction_cao_cao")
        
        --金城
        --gst.region_set_manager("3k_main_jincheng_capital","3k_main_faction_cao_cao")
        --gst.region_set_manager("3k_main_jincheng_resource_1","3k_main_faction_cao_cao")
        --gst.region_set_manager("3k_main_jincheng_resource_2","3k_main_faction_cao_cao")
        
        --安定
        gst.region_set_manager("3k_main_anding_capital","3k_main_faction_cao_cao")
        gst.region_set_manager("3k_main_anding_resource_1","xyyhlyja")--（羌胡占）
        gst.region_set_manager("3k_main_anding_resource_2","xyyhlyja")--（羌胡占）
        gst.region_set_manager("3k_main_anding_resource_3","xyyhlyja")--（羌胡占）
        
        --武都
        --gst.region_set_manager("3k_main_wudu_capital","3k_main_faction_cao_cao")
        --gst.region_set_manager("3k_main_wudu_resource_1","3k_main_faction_cao_cao")
        --gst.region_set_manager("3k_main_wudu_resource_2","3k_main_faction_cao_cao")
        
        --并州
        --朔方（羌胡占）
        gst.region_set_manager("3k_main_shoufang_capital","xyyhlyja")
        gst.region_set_manager("3k_main_shoufang_resource_1","xyyhlyja")
        gst.region_set_manager("3k_main_shoufang_resource_2","xyyhlyja")
        gst.region_set_manager("3k_main_shoufang_resource_3","xyyhlyja")
        
        --并州
        --朔方（羌胡占）
        gst.region_set_manager("3k_main_shoufang_capital","xyyhlyja")
        gst.region_set_manager("3k_main_shoufang_resource_1","xyyhlyja")
        gst.region_set_manager("3k_main_shoufang_resource_2","xyyhlyja")
        gst.region_set_manager("3k_main_shoufang_resource_3","xyyhlyja")
        
        --西河（羌胡占）
        gst.region_set_manager("3k_main_xihe_capital","xyyhlyja")
        gst.region_set_manager("3k_main_xihe_resource_1","xyyhlyja")
        
        --太原
        gst.region_set_manager("3k_main_taiyuan_capital","3k_main_faction_cao_cao")
        gst.region_set_manager("3k_main_taiyuan_resource_1","3k_main_faction_cao_cao")
        gst.region_set_manager("3k_main_taiyuan_resource_2","3k_main_faction_cao_cao")
        
        --故关
        gst.region_set_manager("3k_dlc06_gu_pass","3k_main_faction_cao_cao")
        
        --雁门
        gst.region_set_manager("3k_main_yanmen_capital","3k_main_faction_cao_cao")
        gst.region_set_manager("3k_main_yanmen_resource_1","3k_main_faction_cao_cao")
        
        --上党
        gst.region_set_manager("3k_main_shangdang_capital","3k_main_faction_cao_cao")
        gst.region_set_manager("3k_main_shangdang_resource_1","3k_main_faction_cao_cao")
        gst.region_set_manager("3k_dlc06_shangdang_resource_2","3k_main_faction_cao_cao")
        
        --冀州
        --中山
        gst.region_set_manager("3k_main_zhongshan_capital","3k_main_faction_cao_cao")
        gst.region_set_manager("3k_main_zhongshan_resource_1","3k_main_faction_cao_cao")
        
        --安平
        gst.region_set_manager("3k_main_anping_capital","3k_main_faction_cao_cao")
        gst.region_set_manager("3k_main_anping_resource_1","3k_main_faction_cao_cao")
        
        --魏郡
        gst.region_set_manager("3k_main_weijun_capital","3k_main_faction_cao_cao")
        gst.region_set_manager("3k_main_weijun_resource_1","3k_main_faction_cao_cao")
        
        --河内
        gst.region_set_manager("3k_main_henei_capital","3k_main_faction_cao_cao")
        gst.region_set_manager("3k_main_henei_resource_1","3k_main_faction_cao_cao")
        
        --渤海
        gst.region_set_manager("3k_main_bohai_capital","3k_main_faction_cao_cao")
        gst.region_set_manager("3k_main_bohai_resource_1","3k_main_faction_cao_cao")
        
        --幽州
        --代郡
        gst.region_set_manager("3k_main_daijun_capital","3k_main_faction_cao_cao")
        gst.region_set_manager("3k_main_daijun_resource_1","3k_main_faction_cao_cao")
        
        --广阳
        gst.region_set_manager("3k_main_youzhou_capital","3k_main_faction_cao_cao")
        gst.region_set_manager("3k_main_youzhou_resource_1","3k_main_faction_cao_cao")
        
        --右北平
        gst.region_set_manager("3k_main_youbeiping_capital","3k_main_faction_cao_cao")
        gst.region_set_manager("3k_main_youbeiping_resource_1","3k_main_faction_cao_cao")
        
        --辽西
        gst.region_set_manager("3k_main_yu_capital","3k_main_faction_cao_cao")
        gst.region_set_manager("3k_main_yu_resource_1","3k_main_faction_cao_cao")
        
        --青州
        --平原
        gst.region_set_manager("3k_main_pingyuan_capital","3k_main_faction_cao_cao")
        gst.region_set_manager("3k_main_pingyuan_resource_1","3k_main_faction_cao_cao")
        
        --乐安
        gst.region_set_manager("3k_main_taishan_capital","3k_main_faction_cao_cao")
        gst.region_set_manager("3k_main_taishan_resource_1","3k_main_faction_cao_cao")
        
        --北海
        gst.region_set_manager("3k_main_beihai_capital","3k_main_faction_cao_cao")
        gst.region_set_manager("3k_main_beihai_resource_1","3k_main_faction_cao_cao")
        
        --东莱
        gst.region_set_manager("3k_main_donglai_capital","3k_main_faction_cao_cao")
        gst.region_set_manager("3k_main_donglai_resource_1","3k_main_faction_cao_cao")
        
        --兖州
        --东郡
        gst.region_set_manager("3k_main_dongjun_capital","3k_main_faction_cao_cao")
        gst.region_set_manager("3k_main_dongjun_resource_1","3k_main_faction_cao_cao")
        
        --颍川
        gst.region_set_manager("3k_main_yingchuan_capital","3k_main_faction_cao_cao")
        gst.region_set_manager("3k_main_yingchuan_resource_1","3k_main_faction_cao_cao")
        
        --徐州
        --彭城
        gst.region_set_manager("3k_main_penchang_capital","3k_main_faction_cao_cao")
        gst.region_set_manager("3k_main_penchang_resource_1","3k_main_faction_cao_cao")
        gst.region_set_manager("3k_main_penchang_resource_2","3k_main_faction_cao_cao")
        
        --下邳
        gst.region_set_manager("3k_dlc06_xiapi_capital","3k_main_faction_cao_cao")
        gst.region_set_manager("3k_dlc06_xiapi_resource_1","3k_main_faction_cao_cao")
        
        --琅琊
        gst.region_set_manager("3k_main_langye_capital","3k_main_faction_cao_cao")
        gst.region_set_manager("3k_main_langye_resource_1","3k_main_faction_cao_cao")
        gst.region_set_manager("3k_main_langye_resource_2","3k_main_faction_cao_cao")
        
        --东海
        gst.region_set_manager("3k_main_donghai_capital","3k_main_faction_cao_cao")
        gst.region_set_manager("3k_main_donghai_resource_1","3k_main_faction_cao_cao")
        
        --广陵
        gst.region_set_manager("3k_main_guangling_capital","3k_main_faction_cao_cao")
        
        --豫州
        --陈郡
        gst.region_set_manager("3k_main_chenjun_capital","3k_main_faction_cao_cao")
        gst.region_set_manager("3k_main_chenjun_resource_1","3k_main_faction_cao_cao")
        gst.region_set_manager("3k_main_chenjun_resource_2","3k_main_faction_cao_cao")
        
        --汝南
        gst.region_set_manager("3k_main_runan_capital","3k_main_faction_cao_cao")
        gst.region_set_manager("3k_main_runan_resource_1","3k_main_faction_cao_cao")
        if not cm:query_faction("3k_dlc07_faction_liubei"):is_human() then
            local faction = cm:query_faction("3k_main_faction_liu_bei") 
            if faction 
            and faction
            and not faction:is_dead() then
            for i = 0, faction:region_list():num_items() - 1 do
                local region = faction:region_list():item_at(i);
                gst.region_set_manager(region:name(),"3k_main_faction_cao_cao")
            end
                diplomacy_manager:force_confederation("3k_main_faction_liu_biao", "3k_main_faction_liu_bei");
            end
        end
        diplomacy_manager:apply_automatic_deal_between_factions("3k_main_faction_liu_biao", "3k_dlc05_faction_sun_ce", "data_defined_situation_peace")
    end,
    false
)
--207年：马腾加入曹操，马腾派系交给马超
core:add_listener(
    "ma_teng_join_cao_cao",
    "FactionTurnStart",
    function(context)
        local faction = cm:query_faction("3k_main_faction_cao_cao")
        return cm:query_model():campaign_name() == "3k_dlc07_start_pos" 
        and context:query_model():calendar_year() == 207
        and valid_check()
    end,
    function(context)
        gst.character_add_to_faction("3k_main_template_historical_ma_teng_hero_fire", "3k_main_faction_cao_cao", "3k_general_fire")
        local ma_chao = gst.character_add_to_faction("3k_main_template_historical_ma_chao_hero_fire", "3k_main_faction_ma_teng", "3k_general_fire")
        --gst.faction_set_minister_position("3k_main_template_historical_ma_chao_hero_fire","faction_leader")
        cm:modify_character(ma_chao):assign_faction_leader();
    end,
    false
)


--207~211年：曹操不会与张鲁和马腾和韩遂开战
core:add_listener(
    "cao_cao_ai_peace_with_zhang_lu",
    "FactionTurnStart",
    function(context)
        local faction = cm:query_faction("3k_main_faction_cao_cao")
        return cm:query_model():campaign_name() == "3k_dlc07_start_pos" 
        and not faction:is_dead()
        and not faction:is_human()
        and context:query_model():calendar_year() >= 207
        and context:query_model():calendar_year() < 211
        and valid_check()
    end,
    function(context)
        diplomacy_manager:apply_automatic_deal_between_factions("3k_main_faction_ma_teng", "3k_main_faction_cao_cao", "data_defined_situation_peace")
        diplomacy_manager:apply_automatic_deal_between_factions("3k_main_faction_han_sui", "3k_main_faction_cao_cao", "data_defined_situation_peace")
        diplomacy_manager:apply_automatic_deal_between_factions("3k_dlc07_faction_zhang_lu", "3k_main_faction_cao_cao", "data_defined_situation_peace")
    end,
    false
)
core:add_listener(
    "ma_teng_leader_check",
    "FactionTurnStart",
    function(context)
        return cm:query_model():campaign_name() == "3k_dlc07_start_pos" 
        and context:faction():name() == "3k_main_faction_ma_teng"
        and not cm:query_faction("3k_main_faction_ma_teng"):is_human()
        and context:query_model():calendar_year() >= 207
        and context:query_model():calendar_year() < 213
        and valid_check()
    end,
    function(context)
        if context:faction():faction_leader():generation_template_key() ~= "3k_main_template_historical_ma_teng_hero_fire"
        or context:faction():faction_leader():generation_template_key() ~= "3k_main_template_historical_ma_chao_hero_fire"
        then
            local ma_chao = gst.character_add_to_faction("3k_main_template_historical_ma_chao_hero_fire", "3k_main_faction_ma_teng", "3k_general_fire")
            cm:modify_character(ma_chao):assign_faction_leader();
        end
    end,
    true
)

--强制触发司马懿事件
core:add_listener(
    "sima_yi_dilemma_trigger",
    "FactionTurnStart",
    function(context)
        return cm:query_model():campaign_name() == "3k_dlc07_start_pos" 
        and context:faction():name() == "3k_main_faction_cao_cao"
        and cm:query_faction("3k_main_faction_cao_cao"):is_human()
        and context:query_model():calendar_year() >= 208
    end,
    function(context)
        local sima_yi = gst.character_query_for_template("3k_main_template_historical_sima_yi_hero_water")
        if not sima_yi
        or sima_yi:is_null_interface()
        then
            cm:trigger_dilemma("3k_main_faction_cao_cao","3k_main_historical_cao_sima_yi_pc_01_dilemma",true);
        else
            if not sima_yi:is_dead()
            and not sima_yi:faction():is_human()
            then
                gst.character_add_to_recruit_pool("3k_main_template_historical_sima_yi_hero_water","3k_main_faction_cao_cao","3k_general_water", false)
            end
        end
    end,
    true
)

core:add_listener(
    "sima_yi_choice_02",
    "DilemmaChoiceMadeEvent",
    function(context)
        return 
        context:dilemma() == "3k_main_historical_cao_sima_yi_pc_01_dilemma"
        and valid_check()
    end,
    function(context)
        if context:choice() == 0 then
            cm:trigger_dilemma(cm:query_faction("3k_main_faction_cao_cao"), "3k_main_historical_cao_sima_yi_pc_02_dilemma", false);
        else
            cm:set_saved_value("invalid", true);
        end
    end,
    true
)

--211年：马超起兵攻打曹操
core:add_listener(
    "ma_chao_ai_attack_cao_cao",
    "FactionTurnStart",
    function(context)
        local faction = cm:query_faction("3k_main_faction_ma_teng")
        return cm:query_model():campaign_name() == "3k_dlc07_start_pos" 
        and not faction:is_dead()
        and not faction:is_human()
        and context:query_model():calendar_year() == 211
        and valid_check()
    end,
    function(context)
        diplomacy_manager:apply_automatic_deal_between_factions("3k_main_faction_han_sui", "3k_main_faction_cao_cao", "data_defined_situation_war_proposer_to_recipient");
        diplomacy_manager:apply_automatic_deal_between_factions("3k_main_faction_ma_teng", "3k_main_faction_cao_cao", "data_defined_situation_war_proposer_to_recipient");
        diplomacy_manager:apply_automatic_deal_between_factions("3k_dlc07_faction_zhang_lu", "3k_main_faction_cao_cao", "data_defined_situation_war_proposer_to_recipient");
        gst.character_been_killed("3k_main_template_historical_ma_teng_hero_fire");
        if cm:query_faction("3k_main_faction_cao_cao"):is_human() then
            local mission = string_mission:new("kill_ma_faction");
            mission:add_primary_objective("DESTROY_FACTION", {"faction 3k_main_faction_ma_teng"});
            mission:add_primary_payload("text_display{lookup dummy_factual_choice;}");
            mission:set_turn_limit(12);
            mission:trigger_mission_for_faction(context:faction():name());
        end
    end,
    false
)

core:add_listener(
    "kill_ma_faction",
    "MissionSucceeded",
    function(context)
        return context:mission():mission_record_key() == "kill_ma_faction"
        and valid_check()
    end,
    function(context)
        --曹操派系抽奖券+20
        gst.faction_add_tickets(context:faction():name(), 20);
    end,
    false
)

--207年：曹操挥师南下
core:add_listener(
    "cao_cao_ai_attack_liu_biao",
    "FactionTurnStart",
    function(context)
        local faction = cm:query_faction("3k_main_faction_cao_cao")
        return cm:query_model():campaign_name() == "3k_dlc07_start_pos" 
        and context:faction():name() == "3k_main_faction_cao_cao"
        and context:query_model():calendar_year() == 207 
        and valid_check()
        and not faction:is_dead() 
        and faction:region_list() 
        and faction:region_list():num_items() >= 10 
        and context:query_model():season() == "season_summer"
        and not cm:query_faction("3k_main_faction_cao_cao"):is_human()
        and not cm:query_faction("3k_main_faction_liu_biao"):is_human();
    end,
    function()
        diplomacy_manager:apply_automatic_deal_between_factions("3k_main_faction_cao_cao", "3k_main_faction_liu_biao", "data_defined_situation_war_proposer_to_recipient");
    end,
    false
)

--207年：刘禅出生
core:add_listener(
    "liu_shan_born",
    "FactionTurnStart",
    function(context)
        local liu_bei = gst.character_query_for_template("3k_main_template_historical_liu_bei_hero_earth")
        local liu_shan = gst.character_query_for_template("3k_main_template_historical_liu_shan_hero_earth")
        local faction = cm:query_faction("3k_main_faction_liu_bei")
        return context:query_model():calendar_year() >= 207 
        and valid_check()
        and (not liu_shan or liu_shan:is_null_interface())
        and not faction:is_dead()
        and faction:faction_leader():generation_template_key() == "3k_main_template_historical_liu_bei_hero_earth";
    end,
    function(context)
        local liu_bei = gst.character_query_for_template("3k_main_template_historical_liu_bei_hero_earth")
        local liu_shan = gst.character_add_to_faction("3k_main_template_historical_liu_shan_hero_earth","3k_main_faction_liu_bei","3k_general_earth");
        local faction = cm:query_faction("3k_main_faction_liu_bei")
        cm:modify_character(liu_shan):make_child_of(cm:modify_character(liu_bei));
        
        incident = cm:modify_model():create_incident("liu_shan_born");
        incident:add_character_target("target_character_1", liu_shan);
        incident:add_faction_target("target_faction_1", faction);
        incident:trigger(cm:modify_faction(faction), true);
    end,
    false
)

--208年：刘备取荆州
core:add_listener(
    "liu_bei_ai_confederation_listener_liu_biao_force",
    "FactionTurnStart",
    function(context)
        return 
        context:query_model():calendar_year() >= 208 
        and valid_check()
        and context:query_model():calendar_year() < 212 
        and not cm:query_faction("3k_main_faction_liu_bei"):is_human()
        and not cm:query_faction("3k_main_faction_liu_biao"):is_human()
        --and cm:query_faction("3k_main_faction_liu_biao"):faction_leader():generation_template_key() == "3k_main_template_historical_liu_biao_hero_earth"
        and cm:query_model():campaign_name() == "3k_dlc07_start_pos";
    end,
    function()
        if not cm:query_faction("3k_main_faction_liu_bei"):is_human() then
            local faction = cm:query_faction("3k_main_faction_liu_bei")
            local liubei = gst.character_query_for_template("3k_main_template_historical_liu_bei_hero_earth")
            
            if 
            not faction:is_dead() 
            and faction:region_list() 
            and faction:region_list():num_items() > 0 then
                return;
            end
            
            --如果刘备不在玩家派系则触发
            if (liubei:is_character_is_faction_recruitment_pool() or not liubei:faction():is_human()) then
                core:remove_listener("liu_bei_ai_confederation_listener_liu_biao");
                core:remove_listener("liu_bei_ai_confederation_listener_liu_biao_2");
                cm:set_saved_value("liu_biao_confederation", true);
                cm:set_saved_value("liu_biao_death", true);
                
                cm:modify_region("3k_main_xiangyang_capital"):settlement_gifted_as_if_by_payload(cm:modify_faction("3k_main_faction_liu_bei"));
                gst.character_add_to_faction("3k_main_template_historical_liu_bei_hero_earth", "3k_main_faction_liu_bei", "3k_general_earth");
                gst.faction_set_minister_position("3k_main_template_historical_liu_bei_hero_earth","faction_leader");
                
                
                --如果关羽不在玩家派系则加入刘备
                if 
                gst.character_query_for_template("3k_main_template_historical_guan_yu_hero_wood"):is_character_is_faction_recruitment_pool() 
                or not gst.character_query_for_template("3k_main_template_historical_guan_yu_hero_wood"):faction():is_human() then
                    gst.character_add_to_faction("3k_main_template_historical_guan_yu_hero_wood", "3k_main_faction_liu_bei", "3k_general_wood");
                end
                
                --如果张飞不在玩家派系则加入刘备
                if 
                gst.character_query_for_template("3k_main_template_historical_zhang_fei_hero_fire"):is_character_is_faction_recruitment_pool() 
                or not gst.character_query_for_template("3k_main_template_historical_zhang_fei_hero_fire"):faction():is_human() then
                    gst.character_add_to_faction("3k_main_template_historical_zhang_fei_hero_fire", "3k_main_faction_liu_bei", "3k_general_fire");
                end
                
                --如果赵云不在玩家派系则加入刘备
                if
                gst.character_query_for_template("3k_main_template_historical_zhao_yun_hero_metal"):is_character_is_faction_recruitment_pool() 
                or not gst.character_query_for_template("3k_main_template_historical_zhao_yun_hero_metal"):faction():is_human() then
                    gst.character_add_to_faction("3k_main_template_historical_zhao_yun_hero_metal", "3k_main_faction_liu_bei", "3k_general_metal");
                end
                
                --如果黄忠不在玩家派系则加入刘备
                if
                gst.character_query_for_template("3k_main_template_historical_huang_zhong_hero_metal"):is_character_is_faction_recruitment_pool() 
                or not gst.character_query_for_template("3k_main_template_historical_huang_zhong_hero_metal"):faction():is_human() then
                    gst.character_add_to_faction("3k_main_template_historical_huang_zhong_hero_metal", "3k_main_faction_liu_bei", "3k_general_metal");
                end
                
                --如果关银屏不在玩家派系则加入刘备
                if
                gst.character_query_for_template("hlyjbv"):is_character_is_faction_recruitment_pool() 
                or not gst.character_query_for_template("hlyjbv"):faction():is_human() then
                    gst.character_add_to_faction("hlyjbv", "3k_main_faction_liu_bei", "3k_general_wood");
                end
                
                --如果甘宁不在玩家派系则加入孙策
                if
                gst.character_query_for_template("3k_main_template_historical_gan_ning_hero_fire"):is_character_is_faction_recruitment_pool() 
                or not gst.character_query_for_template("3k_main_template_historical_gan_ning_hero_fire"):faction():is_human() then
                    gst.character_add_to_faction("3k_main_template_historical_gan_ning_hero_fire", "3k_dlc05_faction_sun_ce", "3k_general_fire"); 
                end
                
                --如果魏延不在玩家派系则加入刘备
                if
                gst.character_query_for_template("3k_main_template_historical_wei_yan_hero_wood"):is_character_is_faction_recruitment_pool() 
                or not gst.character_query_for_template("3k_main_template_historical_wei_yan_hero_wood"):faction():is_human() then
                    gst.character_add_to_faction("3k_main_template_historical_wei_yan_hero_wood", "3k_main_faction_liu_bei", "3k_general_wood"); 
                end
                
                --如果庞统不在玩家派系则加入刘备
                gst.character_add_to_faction("3k_main_template_historical_pang_tong_hero_water", "3k_main_faction_liu_bei", "3k_general_water"); 
                
                --如果糜夫人不在玩家派系则加入刘备
                local lady_mi = gst.character_query_for_template("3k_dlc04_template_historical_lady_mi_earth")
                if
                not lady_mi:is_null_interface()
                and not lady_mi:is_dead()
                and (not lady_mi:faction():is_human() or lady_mi:is_character_is_faction_recruitment_pool()) then
                    gst.character_add_to_faction("3k_dlc04_template_historical_lady_mi_earth", "3k_main_faction_liu_bei", "3k_general_earth"); 
                end
                
                --如果糜芳不在玩家派系则加入刘备
                local mi_fang = gst.character_query_for_template("3k_dlc04_template_historical_mi_fang_metal")
                if
                not mi_fang:is_null_interface()
                and not mi_fang:is_dead()
                and (not mi_fang:faction():is_human() or mi_fang:is_character_is_faction_recruitment_pool()) then
                    gst.character_add_to_faction("3k_dlc04_template_historical_mi_fang_metal", "3k_main_faction_liu_bei", "3k_general_metal"); 
                end
                
                --如果糜竺不在玩家派系则加入刘备
                local mi_zhu = gst.character_query_for_template("3k_main_template_historical_mi_zhu_hero_water")
                if
                not mi_zhu:is_null_interface()
                and not mi_zhu:is_dead()
                and (not mi_zhu:faction():is_human() or mi_zhu:is_character_is_faction_recruitment_pool()) then
                    gst.character_add_to_faction("3k_main_template_historical_mi_zhu_hero_water", "3k_main_faction_liu_bei", "3k_general_water"); 
                end
                
                --如果诸葛亮不在玩家派系则加入刘备
                local zhuge_liang_key = "3k_main_template_historical_zhuge_liang_hero_water";
                local huang_yueying_key = "hlyjbt";
                local zhuge_liang = gst.character_query_for_template(zhuge_liang_key);
                local huang_yueying = gst.character_query_for_template(huang_yueying_key);
                if not zhuge_liang 
                or zhuge_liang:is_null_interface() 
                then
                    zhuge_liang = gst.character_add_to_faction(zhuge_liang_key, "3k_main_faction_liu_bei", "3k_general_water");
                end
                if zhuge_liang:faction():name() == "3k_main_faction_liu_bei"
                then
                    if not huang_yueying:faction():is_human() then
                        gst.character_add_to_faction(huang_yueying_key, "3k_main_faction_liu_bei", "3k_general_water");
                        local modify_huang_yueying = cm:modify_character(huang_yueying);
                        local family_member = modify_huang_yueying:family_member()
                        
                        --和黄月英结婚
                        if not family_member:is_null_interface() then 
                            family_member:divorce_spouse();
                            family_member:marry_character(cm:modify_character(zhuge_liang):family_member());
                        end
                    end
                end
                gst.character_add_to_faction("hlyjbv", "3k_main_faction_liu_bei", "3k_general_wood")
                
                --刘禅成为刘备储君
                local liu_bei = gst.character_query_for_template("3k_main_template_historical_liu_bei_hero_earth")
                local liu_shan = gst.character_add_to_faction("3k_main_template_historical_liu_shan_hero_earth","3k_main_faction_liu_bei","3k_general_earth");
                
                cm:modify_character(liu_shan):make_child_of(cm:modify_character(liu_bei));
                
                gst.faction_set_minister_position("3k_main_template_historical_liu_shan_hero_earth","faction_heir");
                
                --蔡瑁加入曹操
                gst.character_add_to_faction("3k_main_template_historical_cai_mao_hero_fire", "3k_main_faction_cao_cao", "3k_general_fire"); 
                --张允加入曹操
                gst.character_add_to_faction("3k_main_template_historical_zhang_yun_hero_water", "3k_main_faction_cao_cao", "3k_general_water");
                --蒋干加入曹操
                local jiang_gan = gst.character_add_to_faction("3k_main_template_historical_jiang_gan_hero_water", "3k_main_faction_cao_cao", "3k_general_water");
                if cm:query_faction("3k_main_faction_cao_cao"):is_human() then 
                    local incident = cm:modify_model():create_incident("chibi_battle_ready_incident");
                    incident:add_character_target("target_character_1", jiang_gan);
                    incident:add_faction_target("target_faction_1", cm:query_faction("3k_main_faction_cao_cao"));
                    incident:trigger(cm:modify_faction(cm:query_faction("3k_main_faction_cao_cao")), true);
                end
                
                --合并刘表、黄祖
                diplomacy_manager:force_confederation("3k_main_faction_liu_bei", "3k_main_faction_liu_biao");
                diplomacy_manager:force_confederation("3k_main_faction_liu_bei", "3k_main_faction_huang_zu");
                
                cm:modify_faction("3k_main_faction_liu_biao_separatists"):increase_treasury(443120);
                cm:modify_faction("3k_main_faction_liu_bei"):apply_effect_bundle("xyy_liu_bei_AI",-1);
                cm:modify_faction("3k_dlc05_faction_sun_ce"):apply_effect_bundle("xyy_sun_ce_AI",-1);
                diplomacy_manager:apply_automatic_deal_between_factions("3k_main_faction_liu_bei", "3k_dlc05_faction_sun_ce", "data_defined_situation_peace",false)
                --diplomacy_manager:apply_automatic_deal_between_factions("3k_main_faction_liu_bei", "3k_dlc05_faction_sun_ce", "data_defined_situation_create_coalition_no_conditions",true)
--                 diplomacy_manager:apply_automatic_deal_between_factions("3k_main_faction_cao_cao", "3k_main_faction_liu_bei", "data_defined_situation_war_proposer_to_recipient",false)
--                 diplomacy_manager:apply_automatic_deal_between_factions("3k_dlc05_faction_sun_ce", "3k_main_faction_cao_cao", "data_defined_situation_war_proposer_to_recipient",false)
                --刘表病逝
--                 local liu_biao = gst.character_query_for_template("3k_main_template_historical_liu_biao_hero_earth");
--                 cm:modify_character(liu_biao):kill_character(false);
--                 
                gst.character_been_killed("3k_main_template_historical_liu_biao_hero_earth");

            end
        end
    end,
    true
)

--208年：刘备取荆州事件
core:add_listener(
    "liu_bei_human_confederation_listener_liu_biao",
    "FactionTurnStart",
    function(context)
        return 
        context:faction():name() == "3k_main_faction_liu_bei"
        and cm:get_saved_value("liu_bei_defeat")
        and not cm:get_saved_value("liu_biao_confederation")
        and context:query_model():calendar_year() >= 208 
        and context:query_model():calendar_year() < 212 
        and valid_check()
        and cm:query_faction("3k_main_faction_liu_bei"):is_human()
        and not cm:query_faction("3k_main_faction_liu_biao"):is_human()
        and not cm:query_faction("3k_main_faction_liu_biao"):is_dead()
        and cm:query_model():campaign_name() == "3k_dlc07_start_pos"
        and cm:query_faction("3k_main_faction_liu_biao"):faction_leader():generation_template_key() == "3k_main_template_historical_liu_biao_hero_earth";
    end,
    function(context)
        local huangzu = cm:query_faction("3k_main_faction_huang_zu")
        if huangzu and huangzu:is_dead() then
            cm:modify_region("3k_main_jiangxia_capital"):settlement_gifted_as_if_by_payload(cm:modify_faction("3k_main_faction_huang_zu"));
        end
        cm:trigger_dilemma("3k_main_faction_liu_bei","confederate_liu_bei_and_liu_biao", true);
    end,
    false
)

--208年：孙刘联盟
core:add_listener(
    "liu_bei_alliance_sun_quan",
    "FactionTurnStart",
    function(context)
        return 
        context:query_model():calendar_year() >= 208 
        and context:query_model():calendar_year() < 209
        and valid_check()
        and cm:get_saved_value("liu_biao_confederation")
        and not cm:get_saved_value("liu_bei_alliance_sun_quan")
        --and not cm:query_faction("3k_main_faction_cao_cao"):is_human()
        and context:query_model():campaign_name() == "3k_dlc07_start_pos"
        and context:faction():is_human();
    end,
    function(context)
        diplomacy_manager:apply_automatic_deal_between_factions("3k_main_faction_liu_bei", "3k_dlc05_faction_sun_ce", "data_defined_situation_peace")
        if cm:query_faction("3k_main_faction_liu_bei"):is_human() and context:faction():name() == "3k_main_faction_liu_bei" then
            cm:trigger_dilemma("3k_main_faction_liu_bei","liu_bei_alliance_sun_quan", true);
            cm:set_saved_value("liu_bei_alliance_sun_quan", true);
        else
            if cm:query_faction("3k_dlc05_faction_sun_ce"):is_human() and context:faction():name() == "3k_dlc05_faction_sun_ce" then
                cm:trigger_dilemma("3k_dlc05_faction_sun_ce","sun_quan_alliance_liu_bei", true);
                cm:set_saved_value("liu_bei_alliance_sun_quan", true);
            end
        end
        if not cm:query_faction("3k_main_faction_liu_bei"):is_human ()and not cm:query_faction("3k_dlc05_faction_sun_ce"):is_human() then
            diplomacy_manager:apply_automatic_deal_between_factions("3k_main_faction_liu_bei", "3k_dlc05_faction_sun_ce", "data_defined_situation_create_alliance_no_conditions", true)
            diplomacy_manager:apply_automatic_deal_between_factions("3k_dlc05_faction_sun_ce", "3k_main_faction_cao_cao", "data_defined_situation_war_proposer_to_recipient", false);
        end
    end,
    false
)

core:add_listener(
    "liu_bei_alliance_sun_quan",
    "DilemmaChoiceMadeEvent",
    function(context)
        return context:dilemma() == "liu_bei_alliance_sun_quan" or context:dilemma() == "sun_quan_alliance_liu_bei" 
    end,
    function(context)
        if context:choice() == 0 then
            diplomacy_manager:apply_automatic_deal_between_factions("3k_dlc05_faction_sun_ce", "3k_main_faction_cao_cao", "data_defined_situation_war_proposer_to_recipient", false);
        end
    end,
    false
)

function is_deployed(character)
    return gst.faction_is_character_deployed(character);
end

--函数：找到特定人物所在的军队，没有就创建
function find_character_military_force(character)
    return gst.faction_find_character_military_force(character);
end

function query_military_force_leader(military_force)
    if military_force 
    and not military_force:is_null_interface() 
    then
        if not military_force:general_character() then
            return military_force:character_list():item_at(0) 
        else
            return military_force:general_character()
        end
    else
        return false;
    end
end
--208年：赤壁之战准备
core:add_listener(
    "chibi_battle_ready",
    "FactionTurnStart",
    function(context)
        return 
        context:query_model():calendar_year() >= 208 
        and valid_check()
        and context:query_model():calendar_year() < 209 
        and not cm:query_faction("3k_main_faction_liu_bei"):is_human()
        and not cm:query_faction("3k_main_faction_liu_biao"):is_human()
        and cm:query_model():campaign_name() == "3k_dlc07_start_pos";
    end,
    function(context)
        if not cm:get_saved_value("chibi_battle_ready") then
            diplomacy_manager:force_confederation("3k_dlc05_faction_sun_ce", "3k_dlc05_faction_xu_zhao");
            diplomacy_manager:force_confederation("3k_dlc05_faction_sun_ce", "3k_dlc05_faction_hua_xin");
            diplomacy_manager:force_confederation("3k_dlc05_faction_sun_ce", "3k_dlc07_faction_li_shu");
            diplomacy_manager:force_confederation("3k_main_faction_cao_cao", "3k_dlc07_faction_zhang_xiu");
            
            gst.region_force_set_manager("3k_main_xiangyang_resource_1","3k_main_faction_cao_cao")
            gst.region_force_set_manager("3k_main_xiangyang_capital","3k_main_faction_cao_cao")
            --荆州
            --长沙
            gst.region_force_set_manager("3k_main_changsha_capital","3k_main_faction_liu_biao_separatists")
            gst.region_force_set_manager("3k_main_changsha_resource_1","3k_dlc05_faction_sun_ce")
            gst.region_force_set_manager("3k_main_changsha_resource_2","3k_main_faction_liu_biao_separatists")
            gst.region_force_set_manager("3k_main_changsha_resource_3","3k_main_faction_liu_biao_separatists")
            
            --零陵
            gst.region_force_set_manager("3k_main_lingling_capital","3k_main_faction_liu_biao_separatists")
            gst.region_force_set_manager("3k_main_lingling_resource_1","3k_main_faction_liu_biao_separatists")
            gst.region_force_set_manager("3k_main_lingling_resource_2","3k_main_faction_liu_biao_separatists")
            gst.region_force_set_manager("3k_main_lingling_resource_3","3k_main_faction_liu_biao_separatists")
        
            --苍梧
            gst.region_force_set_manager("3k_main_cangwu_capital","3k_main_faction_liu_biao_separatists")
            gst.region_force_set_manager("3k_main_cangwu_resource_1","3k_main_faction_liu_biao_separatists")
            gst.region_force_set_manager("3k_main_cangwu_resource_2","3k_main_faction_liu_biao_separatists")
            gst.region_force_set_manager("3k_main_cangwu_resource_3","3k_main_faction_liu_biao_separatists")
            
            --江夏
            gst.region_set_manager("3k_main_jiangxia_capital","3k_main_faction_liu_bei")
            
            --襄阳
            
            --南郡
            gst.region_set_manager("3k_main_jingzhou_capital","3k_main_faction_liu_bei")
            gst.region_force_set_manager("3k_main_jingzhou_resource_1","3k_main_faction_liu_bei")
            
            --武陵
            gst.region_force_set_manager("3k_main_wuling_capital","3k_main_faction_liu_biao_separatists")
            gst.region_force_set_manager("3k_main_wuling_resource_1","3k_main_faction_liu_biao_separatists")
            gst.region_force_set_manager("3k_main_wuling_resource_2","3k_main_faction_liu_biao_separatists")
            gst.region_force_set_manager("3k_main_wuling_resource_3","3k_main_faction_liu_biao_separatists")
            
            --南阳
            gst.region_force_set_manager("3k_main_nanyang_capital","3k_main_faction_cao_cao")
            gst.region_force_set_manager("3k_main_nanyang_resource_1","3k_main_faction_cao_cao")
            
            --交州
            --交趾
            gst.region_force_set_manager("3k_dlc06_jiaozhi_resource_3","3k_main_faction_liu_biao_separatists")
            
            gst.character_add_to_faction("3k_main_template_historical_liu_cong_hero_earth", "3k_main_faction_liu_biao_separatists", "3k_general_earth"); 
            
            gst.faction_set_minister_position("3k_main_template_historical_liu_cong_hero_earth","faction_leader");
            
            diplomacy_manager:apply_automatic_deal_between_factions("3k_main_faction_cao_cao", "3k_main_faction_liu_biao_separatists", "data_defined_situation_vassalise_recipient_no_requirements", true)
            
            --徐州
            --广陵
            gst.region_force_set_manager("3k_main_guangling_resource_1","3k_dlc05_faction_sun_ce")
            gst.region_force_set_manager("3k_main_guangling_resource_2","3k_dlc05_faction_sun_ce")
        
            --扬州
            --庐江
            gst.region_force_set_manager("3k_main_yangzhou_resource_3","3k_dlc05_faction_sun_ce")
            
            --淮南
            gst.region_force_set_manager("3k_main_lujiang_resource_1","3k_dlc05_faction_sun_ce")
            gst.region_force_set_manager("3k_main_lujiang_resource_2","3k_dlc05_faction_sun_ce")
            
            --鄱阳
            gst.region_force_set_manager("3k_main_poyang_capital","3k_dlc05_faction_sun_ce")
            gst.region_force_set_manager("3k_main_poyang_resource_1","3k_dlc05_faction_sun_ce")
            gst.region_force_set_manager("3k_main_poyang_resource_2","3k_dlc05_faction_sun_ce")
            gst.region_force_set_manager("3k_main_poyang_resource_3","3k_dlc05_faction_sun_ce")
            
            --豫章
            gst.region_force_set_manager("3k_main_yuzhang_capital","3k_dlc05_faction_sun_ce")
            gst.region_force_set_manager("3k_main_yuzhang_resource_1","3k_dlc05_faction_sun_ce")
            gst.region_force_set_manager("3k_main_yuzhang_resource_2","3k_dlc05_faction_sun_ce")
            gst.region_force_set_manager("3k_main_yuzhang_resource_3","3k_dlc05_faction_sun_ce")
            
            --庐陵
            gst.region_force_set_manager("3k_main_luling_capital","3k_dlc05_faction_sun_ce")
            gst.region_force_set_manager("3k_main_luling_resource_1","3k_dlc05_faction_sun_ce")
            
            --丹阳
            gst.region_force_set_manager("3k_main_jianye_capital","3k_dlc05_faction_sun_ce")
            gst.region_force_set_manager("3k_main_jianye_resource_1","3k_dlc05_faction_sun_ce")
            gst.region_force_set_manager("3k_main_jianye_resource_2","3k_dlc05_faction_sun_ce")
            
            --会稽
            gst.region_force_set_manager("3k_main_kuaiji_capital","3k_dlc05_faction_sun_ce")
            gst.region_force_set_manager("3k_main_kuaiji_resource_1","3k_dlc05_faction_sun_ce")
            gst.region_force_set_manager("3k_main_kuaiji_resource_2","3k_dlc05_faction_sun_ce")
            
            --北建安
            gst.region_force_set_manager("3k_main_jianan_capital","3k_dlc05_faction_sun_ce")
            gst.region_force_set_manager("3k_main_jianan_resource_1","3k_dlc05_faction_sun_ce")
            gst.region_force_set_manager("3k_main_jianan_resource_2","3k_dlc05_faction_sun_ce")
            
            --临海
            gst.region_force_set_manager("3k_main_dongou_capital","3k_dlc05_faction_sun_ce")
            gst.region_force_set_manager("3k_main_dongou_resource_1","3k_dlc05_faction_sun_ce")
            
            --南建安
            gst.region_force_set_manager("3k_main_tongan_capital","3k_dlc05_faction_sun_ce")
            gst.region_force_set_manager("3k_main_tongan_resource_1","3k_dlc05_faction_sun_ce")
            
            gst.region_set_manager("3k_main_badong_capital","3k_main_faction_liu_bei")
            gst.region_set_manager("3k_main_badong_resource_1","3k_main_faction_liu_bei")
            gst.region_set_manager("3k_main_badong_resource_2","3k_main_faction_liu_bei")
            
            --庐陵
            gst.region_set_manager("3k_main_luling_capital","3k_dlc05_faction_sun_ce")
            gst.region_set_manager("3k_main_luling_resource_1","3k_dlc05_faction_sun_ce")
            diplomacy_manager:apply_automatic_deal_between_factions("3k_main_faction_liu_bei", "3k_main_faction_liu_biao_separatists", "data_defined_situation_war_proposer_to_recipient",false)
            diplomacy_manager:apply_automatic_deal_between_factions("3k_dlc05_faction_sun_ce", "3k_main_faction_cao_cao", "data_defined_situation_war_proposer_to_recipient",false)
            cm:set_saved_value("chibi_battle_ready",true)
        end
    end,
    false
)

core:add_listener(
    "confederate_liu_bei_and_liu_biao",
    "DilemmaChoiceMadeEvent",
    function(context) 
        return context:dilemma() == "confederate_liu_bei_and_liu_biao"
        and valid_check()
    end, -- criteria
    function (context) --what to do if listener fires
        local query_faction = context:faction();
        local liu_biao = gst.character_query_for_template("3k_main_template_historical_liu_biao_hero_earth");
        
        diplomacy_manager:force_confederation("3k_dlc05_faction_sun_ce", "3k_dlc05_faction_xu_zhao");
        diplomacy_manager:force_confederation("3k_dlc05_faction_sun_ce", "3k_dlc05_faction_hua_xin");
        diplomacy_manager:force_confederation("3k_dlc05_faction_sun_ce", "3k_dlc07_faction_li_shu");
        diplomacy_manager:force_confederation("3k_main_faction_cao_cao", "3k_dlc07_faction_zhang_xiu");
            
        gst.region_force_set_manager("3k_main_xiangyang_resource_1","3k_main_faction_cao_cao")
        gst.region_force_set_manager("3k_main_xiangyang_capital","3k_main_faction_cao_cao")
        
        --蔡瑁加入曹操
        gst.character_add_to_faction("3k_main_template_historical_cai_mao_hero_fire", "3k_main_faction_cao_cao", "3k_general_fire"); 
        --张允加入曹操
        gst.character_add_to_faction("3k_main_template_historical_zhang_yun_hero_water", "3k_main_faction_cao_cao", "3k_general_water");
        --蒋干加入曹操
        local jiang_gan = gst.character_add_to_faction("3k_main_template_historical_jiang_gan_hero_water", "3k_main_faction_cao_cao", "3k_general_water");
        if cm:query_faction("3k_main_faction_cao_cao"):is_human() then 
            local incident = cm:modify_model():create_incident("chibi_battle_ready_incident");
            incident:add_character_target("target_character_1", jiang_gan);
            incident:add_faction_target("target_faction_1", cm:query_faction("3k_main_faction_cao_cao"));
            incident:trigger(cm:modify_faction(cm:query_faction("3k_main_faction_cao_cao")), true);
        end
        
        --如果甘宁不在玩家派系则加入孙策
        if
        gst.character_query_for_template("3k_main_template_historical_gan_ning_hero_fire"):is_character_is_faction_recruitment_pool() 
        or not gst.character_query_for_template("3k_main_template_historical_gan_ning_hero_fire"):faction():is_human() then
            gst.character_add_to_faction("3k_main_template_historical_gan_ning_hero_fire", "3k_dlc05_faction_sun_ce", "3k_general_fire"); 
        end
                
        --南阳
        gst.region_force_set_manager("3k_main_nanyang_capital","3k_main_faction_cao_cao")
        gst.region_force_set_manager("3k_main_nanyang_resource_1","3k_main_faction_cao_cao")
        
        --长沙
        gst.region_force_set_manager("3k_main_changsha_capital","3k_main_faction_liu_biao_separatists")
        gst.region_force_set_manager("3k_main_changsha_resource_1","3k_dlc05_faction_sun_ce")
        gst.region_force_set_manager("3k_main_changsha_resource_2","3k_main_faction_liu_biao_separatists")
        gst.region_force_set_manager("3k_main_changsha_resource_3","3k_main_faction_liu_biao_separatists")
        
        --零陵
        gst.region_force_set_manager("3k_main_lingling_capital","3k_main_faction_liu_biao_separatists")
        gst.region_force_set_manager("3k_main_lingling_resource_1","3k_main_faction_liu_biao_separatists")
        gst.region_force_set_manager("3k_main_lingling_resource_2","3k_main_faction_liu_biao_separatists")
        gst.region_force_set_manager("3k_main_lingling_resource_3","3k_main_faction_liu_biao_separatists")
    
        --武陵
        gst.region_force_set_manager("3k_main_wuling_capital","3k_main_faction_liu_biao_separatists")
        gst.region_force_set_manager("3k_main_wuling_resource_1","3k_main_faction_liu_biao_separatists")
        gst.region_force_set_manager("3k_main_wuling_resource_2","3k_main_faction_liu_biao_separatists")
        gst.region_force_set_manager("3k_main_wuling_resource_3","3k_main_faction_liu_biao_separatists")
        
        --苍梧
        gst.region_force_set_manager("3k_main_cangwu_capital","3k_main_faction_liu_biao_separatists")
        gst.region_force_set_manager("3k_main_cangwu_resource_1","3k_main_faction_liu_biao_separatists")
        gst.region_force_set_manager("3k_main_cangwu_resource_2","3k_main_faction_liu_biao_separatists")
        gst.region_force_set_manager("3k_main_cangwu_resource_3","3k_main_faction_liu_biao_separatists")
            
        --交州
        --交趾
        gst.region_force_set_manager("3k_dlc06_jiaozhi_resource_3","3k_main_faction_liu_biao_separatists")
        
        gst.character_add_to_faction("3k_main_template_historical_liu_cong_hero_earth", "3k_main_faction_liu_biao_separatists", "3k_general_earth"); 
        
        gst.faction_set_minister_position("3k_main_template_historical_liu_cong_hero_earth","faction_leader");
        
        diplomacy_manager:apply_automatic_deal_between_factions("3k_main_faction_cao_cao", "3k_main_faction_liu_biao_separatists", "data_defined_situation_vassalise_recipient_no_requirements", true)
        
        diplomacy_manager:apply_automatic_deal_between_factions("3k_dlc05_faction_sun_ce", "3k_main_faction_cao_cao", "data_defined_situation_war_proposer_to_recipient",false)
        --徐州
        --广陵
        gst.region_force_set_manager("3k_main_guangling_resource_1","3k_dlc05_faction_sun_ce")
        gst.region_force_set_manager("3k_main_guangling_resource_2","3k_dlc05_faction_sun_ce")
    
        --扬州
        --庐江
        gst.region_force_set_manager("3k_main_yangzhou_resource_3","3k_dlc05_faction_sun_ce")
        
        --淮南
        gst.region_force_set_manager("3k_main_lujiang_resource_1","3k_dlc05_faction_sun_ce")
        gst.region_force_set_manager("3k_main_lujiang_resource_2","3k_dlc05_faction_sun_ce")
        
        --鄱阳
        gst.region_force_set_manager("3k_main_poyang_capital","3k_dlc05_faction_sun_ce")
        gst.region_force_set_manager("3k_main_poyang_resource_1","3k_dlc05_faction_sun_ce")
        gst.region_force_set_manager("3k_main_poyang_resource_2","3k_dlc05_faction_sun_ce")
        gst.region_force_set_manager("3k_main_poyang_resource_3","3k_dlc05_faction_sun_ce")
        
        --豫章
        gst.region_force_set_manager("3k_main_yuzhang_capital","3k_dlc05_faction_sun_ce")
        gst.region_force_set_manager("3k_main_yuzhang_resource_1","3k_dlc05_faction_sun_ce")
        gst.region_force_set_manager("3k_main_yuzhang_resource_2","3k_dlc05_faction_sun_ce")
        gst.region_force_set_manager("3k_main_yuzhang_resource_3","3k_dlc05_faction_sun_ce")
        
        --庐陵
        gst.region_force_set_manager("3k_main_luling_capital","3k_dlc05_faction_sun_ce")
        gst.region_force_set_manager("3k_main_luling_resource_1","3k_dlc05_faction_sun_ce")
        
        --丹阳
        gst.region_force_set_manager("3k_main_jianye_capital","3k_dlc05_faction_sun_ce")
        gst.region_force_set_manager("3k_main_jianye_resource_1","3k_dlc05_faction_sun_ce")
        gst.region_force_set_manager("3k_main_jianye_resource_2","3k_dlc05_faction_sun_ce")
        
        --会稽
        gst.region_force_set_manager("3k_main_kuaiji_capital","3k_dlc05_faction_sun_ce")
        gst.region_force_set_manager("3k_main_kuaiji_resource_1","3k_dlc05_faction_sun_ce")
        gst.region_force_set_manager("3k_main_kuaiji_resource_2","3k_dlc05_faction_sun_ce")
        
        --北建安
        gst.region_force_set_manager("3k_main_jianan_capital","3k_dlc05_faction_sun_ce")
        gst.region_force_set_manager("3k_main_jianan_resource_1","3k_dlc05_faction_sun_ce")
        gst.region_force_set_manager("3k_main_jianan_resource_2","3k_dlc05_faction_sun_ce")
        
        --临海
        gst.region_force_set_manager("3k_main_dongou_capital","3k_dlc05_faction_sun_ce")
        gst.region_force_set_manager("3k_main_dongou_resource_1","3k_dlc05_faction_sun_ce")
        
        --南建安
        gst.region_force_set_manager("3k_main_tongan_capital","3k_dlc05_faction_sun_ce")
        gst.region_force_set_manager("3k_main_tongan_resource_1","3k_dlc05_faction_sun_ce")
        
        --庐陵
        gst.region_set_manager("3k_main_luling_capital","3k_dlc05_faction_sun_ce")
        gst.region_set_manager("3k_main_luling_resource_1","3k_dlc05_faction_sun_ce")
        
        cm:set_saved_value("chibi_battle_ready",true)
        gst.character_been_killed("3k_main_template_historical_liu_biao_hero_earth");
        
        if context:choice() == 0 then
            
            local huang_yueying = gst.character_add_to_faction("hlyjbt", "3k_main_faction_liu_bei", "3k_general_water");
            local zhuge_liang = gst.character_query_for_template("3k_main_template_historical_zhuge_liang_hero_water");
            
            local modify_huang_yueying = cm:modify_character(huang_yueying);
            local family_member = modify_huang_yueying:family_member()
            
            if not family_member:is_null_interface() and not zhuge_liang:is_null_interface() and not zhuge_liang:is_dead() then 
                family_member:divorce_spouse();
                family_member:marry_character(cm:modify_character(zhuge_liang):family_member());
            end
            
            cm:modify_faction("3k_main_faction_liu_bei"):increase_treasury(443120);
            gst.character_add_to_faction("3k_main_template_historical_huang_zhong_hero_metal", "3k_main_faction_liu_bei",
            "3k_general_metal");
            --cm:set_saved_value("liu_biao_confederation", true);
            
            --江夏
            gst.region_set_manager("3k_main_jiangxia_capital","3k_main_faction_liu_bei")
            
            --襄阳
            gst.region_set_manager("3k_main_xiangyang_resource_1","3k_main_faction_liu_bei")
            
            --南郡
            gst.region_set_manager("3k_main_jingzhou_capital","3k_main_faction_liu_bei")
            gst.region_set_manager("3k_main_jingzhou_resource_1","3k_main_faction_liu_bei")
            
            gst.region_set_manager("3k_main_badong_capital","3k_main_faction_liu_bei")
            gst.region_set_manager("3k_main_badong_resource_1","3k_main_faction_liu_bei")
            gst.region_set_manager("3k_main_badong_resource_2","3k_main_faction_liu_bei")
            diplomacy_manager:apply_automatic_deal_between_factions("3k_main_faction_liu_bei", "3k_main_faction_liu_biao_separatists", "data_defined_situation_war_proposer_to_recipient",false)
            cm:set_saved_value("liu_biao_confederation", true)
        end
    end,   
    false
)

--208年：赤壁之战准备阶段2
core:add_listener(
    "chibi_battle_ready2",
    "FactionTurnStart",
    function(context)
        return 
        context:query_model():calendar_year() >= 208 
        and context:query_model():calendar_year() < 209
        and valid_check()
        and cm:get_saved_value("chibi_battle_ready")
        and not cm:get_saved_value("chibi_battle_ready2")
        --and not cm:query_faction("3k_main_faction_cao_cao"):is_human()
        and context:query_model():campaign_name() == "3k_dlc07_start_pos"
    end,
    function(context)
        --如果曹操是玩家触发移动军队任务
        if cm:query_faction("3k_main_faction_cao_cao"):is_human() then
            local cao_cao = gst.character_query_for_template("3k_main_template_historical_cao_cao_hero_earth")
            local jiang_gan = gst.character_query_for_template("3k_main_template_historical_jiang_gan_hero_water")
            local mission = string_mission:new("chibi_battle_ready_cao_cao")
            if cao_cao:startpos_key() then
                mission:add_primary_objective("MOVE_TO_REGION", {"start_pos_character ".. cao_cao:startpos_key() .. ";region 3k_main_jingzhou_resource_1"});
            else
                mission:add_primary_objective("MOVE_TO_REGION", {"region 3k_main_jingzhou_resource_1"})
            end
            mission:add_primary_payload("text_display{lookup dummy_factual_choice;}")
            mission:trigger_mission_for_faction("3k_main_faction_cao_cao")
            cm:trigger_dilemma("3k_main_faction_cao_cao", "chibi_battle_ready2_dilemma", true);
        else
            gst.character_been_killed("3k_main_template_historical_cai_mao_hero_fire");
            gst.character_been_killed("3k_main_template_historical_zhang_yun_hero_water");
            if cm:query_faction("3k_dlc05_faction_sun_ce"):is_human() then
                cm:trigger_incident("3k_dlc05_faction_sun_ce","chibi_battle_ready3_incident",true)
            end
            if cm:query_faction("3k_main_faction_liu_bei"):is_human() then
                cm:trigger_incident("3k_main_faction_liu_bei","chibi_battle_ready3_incident",true)
            end
        end
        --如果刘备是玩家触发移动军队任务
        if cm:query_faction("3k_main_faction_liu_bei"):is_human() then
            local liu_bei = gst.character_query_for_template("3k_main_template_historical_liu_bei_hero_earth")
            local mission = string_mission:new("chibi_battle_ready_liu_bei")
            if liu_bei:startpos_key() then
                mission:add_primary_objective("MOVE_TO_REGION", {"start_pos_character ".. liu_bei:startpos_key() .. ";region 3k_main_jiangxia_capital"});
            else
                mission:add_primary_objective("MOVE_TO_REGION", {"region 3k_main_jiangxia_capital"})
            end
            mission:add_primary_payload("text_display{lookup dummy_factual_choice;}")
            mission:trigger_mission_for_faction("3k_main_faction_liu_bei")
        end
        --如果孙权是玩家触发移动军队任务
        if cm:query_faction("3k_dlc05_faction_sun_ce"):is_human() then
            local zhou_yu = gst.character_query_for_template("3k_main_template_historical_zhou_yu_hero_water")
            local mission = string_mission:new("chibi_battle_ready_sun_quan")
            if zhou_yu:startpos_key() then
                mission:add_primary_objective("MOVE_TO_REGION", {"start_pos_character ".. zhou_yu:startpos_key() .. ";region 3k_main_changsha_resource_1"});
            else
                mission:add_primary_objective("MOVE_TO_REGION", {"region 3k_main_changsha_resource_1"})
            end
            mission:add_primary_payload("text_display{lookup dummy_factual_choice;}")
            mission:trigger_mission_for_faction("3k_dlc05_faction_sun_ce")
        end
        cm:set_saved_value("chibi_battle_ready2",true)
    end,
    false
)

--208年：赤壁之战准备阶段
core:add_listener(
    "chibi_battle_ready3",
    "FactionTurnStart",
    function(context)
        return 
        context:query_model():calendar_year() >= 208 
        and context:query_model():calendar_year() < 209
        and valid_check()
        and context:query_model():season() == "season_harvest"
        and cm:get_saved_value("chibi_battle_ready2")
        and not cm:get_saved_value("chibi_battle_ready3")
        and context:query_model():campaign_name() == "3k_dlc07_start_pos"
    end,
    function(context)
        local huang_gai = gst.character_query_for_template("3k_cp01_template_historical_huang_gai_hero_fire")
        if huang_gai and not huang_gai:is_dead() then
            gst.character_add_to_faction("3k_cp01_template_historical_huang_gai_hero_fire", "3k_main_faction_liu_biao_separatists", "3k_general_fire"); 
            gst.character_add_to_faction("3k_cp01_template_historical_huang_gai_hero_fire", "3k_dlc05_faction_sun_ce", "3k_general_fire"); 
        end
        local zhou_yu = gst.character_query_for_template("3k_main_template_historical_zhou_yu_hero_water")
        if zhou_yu and not zhou_yu:is_dead() then
            gst.character_add_to_faction("3k_main_template_historical_zhou_yu_hero_water", "3k_main_faction_liu_biao_separatists", "3k_general_water"); 
            gst.character_add_to_faction("3k_main_template_historical_zhou_yu_hero_water", "3k_dlc05_faction_sun_ce", "3k_general_water"); 
        end
        local gan_ning = gst.character_query_for_template("3k_main_template_historical_gan_ning_hero_fire")
        if gan_ning and not gan_ning:is_dead() then
            gst.character_add_to_faction("3k_main_template_historical_gan_ning_hero_fire", "3k_main_faction_liu_biao_separatists", "3k_general_fire"); 
            gst.character_add_to_faction("3k_main_template_historical_gan_ning_hero_fire", "3k_dlc05_faction_sun_ce", "3k_general_fire"); 
        end
        local yue_jin = gst.character_query_for_template("3k_main_template_historical_yue_jin_hero_metal")
        if yue_jin and not yue_jin:is_dead() then
            gst.character_add_to_faction("3k_main_template_historical_yue_jin_hero_metal", "3k_main_faction_liu_biao_separatists", "3k_general_metal"); 
            gst.character_add_to_faction("3k_main_template_historical_yue_jin_hero_metal", "3k_main_faction_cao_cao", "3k_general_metal"); 
        end
        local xu_huang = gst.character_query_for_template("3k_main_template_historical_xu_huang_hero_metal")
        if xu_huang and not xu_huang:is_dead() then
            gst.character_add_to_faction("3k_main_template_historical_xu_huang_hero_metal", "3k_main_faction_liu_biao_separatists", "3k_general_metal"); 
            gst.character_add_to_faction("3k_main_template_historical_xu_huang_hero_metal", "3k_main_faction_cao_cao", "3k_general_metal"); 
        end
        local cao_ren = gst.character_query_for_template("3k_main_template_historical_cao_ren_hero_earth")
        if cao_ren and not cao_ren:is_dead() then
            gst.character_add_to_faction("3k_main_template_historical_cao_ren_hero_earth", "3k_main_faction_liu_biao_separatists", "3k_general_metal"); 
            gst.character_add_to_faction("3k_main_template_historical_cao_ren_hero_earth", "3k_main_faction_cao_cao", "3k_general_metal"); 
        end
        local zhuge_liang = gst.character_query_for_template("3k_main_template_historical_zhuge_liang_hero_water")
        if zhuge_liang and not zhuge_liang:is_dead() then
            gst.character_add_to_faction("3k_main_template_historical_zhuge_liang_hero_water", "3k_main_faction_liu_biao_separatists", "3k_general_water"); 
            gst.character_add_to_faction("3k_main_template_historical_zhuge_liang_hero_water", "3k_main_faction_liu_bei", "3k_general_water"); 
        end
        local pang_tong = gst.character_query_for_template("3k_main_template_historical_pang_tong_hero_water")
        if not pang_tong or pang_tong:is_null_interface() then
            gst.character_add_to_faction("3k_main_template_historical_pang_tong_hero_water", "3k_main_faction_liu_bei", "3k_general_water")
        elseif not pang_tong:is_dead() then
            gst.character_add_to_faction("3k_main_template_historical_pang_tong_hero_water", "3k_main_faction_liu_biao_separatists", "3k_general_water"); 
            gst.character_add_to_faction("3k_main_template_historical_pang_tong_hero_water", "3k_main_faction_liu_bei", "3k_general_water"); 
        end
        local guan_yu = gst.character_query_for_template("3k_main_template_historical_guan_yu_hero_wood")
        if not guan_yu:is_null_interface() and not guan_yu:is_dead() then
            if not is_deployed(guan_yu) then
                gst.character_add_to_faction("3k_main_template_historical_guan_yu_hero_wood", "3k_main_faction_liu_biao_separatists", "3k_general_wood"); 
                gst.character_add_to_faction("3k_main_template_historical_guan_yu_hero_wood", "3k_main_faction_liu_bei", "3k_general_wood"); 
            end
        end
        local military_force = gst.faction_find_character_military_force(guan_yu)
        if military_force and not military_force:is_null_interface() then
            local character = query_military_force_leader(military_force)
            if character and not character:is_null_interface() then
                cm:modify_character(character):teleport_to(450, 367);
                cm:modify_character(character):replenish_action_points()
                cm:modify_military_force(military_force):change_stance("MILITARY_FORCE_ACTIVE_STANCE_TYPE_AMBUSH")
                cm:modify_character(character):zero_action_points()
            end
        end
    end,
    false
)

core:add_listener(
    "chibi_battle_ready2_dilemma",
    "DilemmaChoiceMadeEvent",
    function(context)
        return context:dilemma() == "chibi_battle_ready2_dilemma"
    end,
    function(context)
        if context:choice() == 0 then
            gst.character_been_killed("3k_main_template_historical_cai_mao_hero_fire");
            gst.character_been_killed("3k_main_template_historical_zhang_yun_hero_water");
            if cm:query_faction("3k_dlc05_faction_sun_ce"):is_human() then
                cm:trigger_incident("3k_dlc05_faction_sun_ce","chibi_battle_ready3_incident",true)
            end
            if cm:query_faction("3k_main_faction_liu_bei"):is_human() then
                cm:trigger_incident("3k_main_faction_liu_bei","chibi_battle_ready3_incident",true)
            end
        else
            cm:set_saved_value("invalid", true);
        end
    end,
    false
)

--庞统献计
core:add_listener(
    "chibi_battle_ready4_1",
    "FactionTurnStart",
    function(context)
        return 
        context:query_model():calendar_year() == 208 
        and valid_check()
        and context:query_model():season() == "season_autumn"
        and not cm:get_saved_value("chibi_battle_ready3_1")
        and context:query_model():campaign_name() == "3k_dlc07_start_pos"
        and context:faction():name() == "3k_main_faction_cao_cao"
        and context:faction():is_human()
    end,
    function(context)
        local character_list = context:faction():character_list()
        for i = 0, character_list:num_items() - 1 do
            local character = character_list:item_at(i);
            if character:has_military_force() then
                if context:faction():is_human() then
                    cm:modify_character(character):apply_effect_bundle("chibi_battle_start",1)
                end
            end
        end
        if cm:query_faction("3k_main_faction_cao_cao"):is_human() then 
            local pang_tong = gst.character_add_to_faction("3k_main_template_historical_pang_tong_hero_water", "3k_main_faction_liu_bei", "3k_general_water"); 
            local incident = cm:modify_model():create_incident("chibi_battle_ready2_incident");
            incident:add_character_target("target_character_1", pang_tong);
            incident:add_faction_target("target_faction_1", cm:query_faction("3k_main_faction_cao_cao"));
            incident:trigger(cm:modify_faction("3k_main_faction_cao_cao"), true);
        end
        cm:set_saved_value("chibi_battle_ready3_1", true)
    end,
    false
)

core:add_listener(
    "chibi_battle_ready4",
    "FactionTurnStart",
    function(context)
        return 
        context:query_model():calendar_year() >= 208 
        and context:query_model():calendar_year() < 209
        and valid_check()
        and context:query_model():season() == "season_autumn"
        and cm:get_saved_value("chibi_battle_ready2")
        and not cm:get_saved_value("chibi_battle_ready3")
        and context:query_model():campaign_name() == "3k_dlc07_start_pos"
    end,
    function(context)
        ModLog("chibi_battle_ready4")
        --如果曹操是玩家完成移动军队任务
        if cm:query_faction("3k_main_faction_cao_cao"):is_human() then
            cm:modify_faction("3k_main_faction_cao_cao"):complete_custom_mission("chibi_battle_ready_cao_cao")
        else
            --cm:modify_faction("3k_main_faction_cao_cao"):disable_movement()
        end
        
        local cao_cao = gst.character_query_for_template("3k_main_template_historical_cao_cao_hero_earth")
        --cm:modify_character(cao_cao):set_is_deployable(false)
        --部署曹操的军队
        local general_characters = {}
        local xu_huang = gst.character_query_for_template("3k_main_template_historical_xu_huang_hero_metal")
        if xu_huang 
        and not xu_huang:is_dead() 
        and not xu_huang:is_character_is_faction_recruitment_pool() 
        and xu_huang:faction():name() == "3k_main_faction_cao_cao"
        then
            if not is_deployed(xu_huang) then
                gst.lib_table_insert(general_characters, "3k_main_template_historical_xu_huang_hero_metal")
            else
                local military_force = gst.faction_find_character_military_force(xu_huang)
                cm:modify_character(query_military_force_leader(military_force)):teleport_to(435, 341);
                cm:modify_character(query_military_force_leader(military_force)):zero_action_points()
            end
        end
        
        local yue_jin = gst.character_query_for_template("3k_main_template_historical_yue_jin_hero_metal")
        if yue_jin 
        and not yue_jin:is_dead() 
        and not yue_jin:is_character_is_faction_recruitment_pool() 
        and yue_jin:faction():name() == "3k_main_faction_cao_cao"
        then
            if not is_deployed(yue_jin) then
                gst.lib_table_insert(general_characters, "3k_main_template_historical_yue_jin_hero_metal")
            else
                local military_force = gst.faction_find_character_military_force(yue_jin)
                cm:modify_character(query_military_force_leader(military_force)):teleport_to(438, 345);
                cm:modify_character(query_military_force_leader(military_force)):zero_action_points()
            end
        end
        
        local cao_ren = gst.character_query_for_template("3k_main_template_historical_cao_ren_hero_earth")
        if cao_ren 
        and not cao_ren:is_dead() 
        and not cao_ren:is_character_is_faction_recruitment_pool() 
        and cao_ren:faction():name() == "3k_main_faction_cao_cao"
        then
            if not is_deployed(cao_ren) then
                gst.lib_table_insert(general_characters, "3k_main_template_historical_cao_ren_hero_earth")
            else
                local military_force = gst.faction_find_character_military_force(cao_ren)
                cm:modify_character(query_military_force_leader(military_force)):teleport_to(437, 350);
                cm:modify_character(query_military_force_leader(military_force)):zero_action_points()
            end
        end
        
        cao_cao_military = gst.faction_find_character_military_force(cao_cao)
        if query_military_force_leader(cao_cao_military) then
            local mod_cao_cao_military = cm:modify_military_force(cao_cao_military);
            
            for i = 0, 10 do
                if cao_cao_military and cao_cao_military:character_list():num_items() < 3 then
                    local num_items = cao_cao_military:character_list():num_items()
                    if #general_characters > 0 then
                        mod_cao_cao_military:add_existing_character_as_retinue(cm:modify_character( gst.character_query_for_template(general_characters[1])),true);
                        if num_items < cao_cao_military:character_list():num_items() then
                            gst.lib_remove_value_from_list(general_characters, general_characters[1])
                        end
                    else
                        break;
                    end
                else
                    break;
                end
            end
        end
        cm:modify_character(query_military_force_leader(cao_cao_military)):teleport_to(442, 350);
        cm:modify_character(query_military_force_leader(cao_cao_military)):zero_action_points()
        
        if #general_characters > 0 then
            local character = gst.character_query_for_template(general_characters[1])
            ModLog(general_characters[1])
            
            local force = gst.faction_find_character_military_force(character)
            
            gst.lib_remove_value_from_list(general_characters, general_characters[1])
            
            if force and not force:is_null_interface() then
                for i = 0, 10 do
                    if force and force:character_list():num_items() < 3 then
                        local num_items = force:character_list():num_items()
                        if #general_characters > 0 then
                            cm:modify_military_force(force):add_existing_character_as_retinue(cm:modify_character( gst.character_query_for_template(general_characters[1])),true);
                            if num_items < force:character_list():num_items() then
                                gst.lib_remove_value_from_list(general_characters, general_characters[1])
                            end
                        else
                            break;
                        end
                    else
                        break;
                    end
                end
                cm:modify_character(query_military_force_leader(force)):teleport_to(438, 345);
                cm:modify_character(query_military_force_leader(force)):zero_action_points()
            end
        end
        
        if #general_characters > 0 then
            local character = gst.character_query_for_template(general_characters[1])
            
            local force = gst.faction_find_character_military_force(character)
            
            gst.lib_remove_value_from_list(general_characters, general_characters[1])
            
            if force and not force:is_null_interface() then
                for i = 0, 10 do
                    if force and force:character_list():num_items() < 3 then
                        local num_items = force:character_list():num_items()
                        if #general_characters > 0 then
                            cm:modify_military_force(force):add_existing_character_as_retinue(cm:modify_character( gst.character_query_for_template(general_characters[1])),true);
                            if num_items < force:character_list():num_items() then
                                gst.lib_remove_value_from_list(general_characters, general_characters[1])
                            end
                        else
                            break;
                        end
                    else
                        break
                    end
                end
                cm:modify_character(query_military_force_leader(force)):teleport_to(435, 341);
                cm:modify_character(query_military_force_leader(force)):zero_action_points()
            end
        end
        
        
        
        local cao_cao_faction = cm:query_faction("3k_main_faction_cao_cao")
        --庞统献计
        if not cao_cao_faction:is_human() then 
            local character_list = cao_cao_faction:character_list()
            for i = 0, character_list:num_items() - 1 do
                local character = character_list:item_at(i);
                if character:has_military_force() then
                    cm:modify_character(character):apply_effect_bundle("chibi_battle_start_AI",1)
                    cm:modify_character(character):disable_movement()
                end
            end
        end
        
        cm:set_saved_value("chibi_battle_ready", true)
    end,
    false
)

core:add_listener(
    "chibi_battle_ready4_liu_bei",
    "FactionTurnStart",
    function(context)
        return 
        context:query_model():calendar_year() >= 208 
        and context:query_model():calendar_year() < 209
        and valid_check()
        and context:query_model():season() == "season_autumn"
        and cm:get_saved_value("chibi_battle_ready2")
        and context:query_model():campaign_name() == "3k_dlc07_start_pos"
        and context:faction():name() == "3k_main_faction_liu_bei"
    end,
    function(context)
        --如果刘备是玩家触发移动军队任务
        if cm:query_faction("3k_main_faction_liu_bei"):is_human() then
            cm:modify_faction("3k_main_faction_liu_bei"):complete_custom_mission("chibi_battle_ready_liu_bei")
        else
            --cm:modify_faction("3k_main_faction_liu_bei"):disable_movement()
        end
        
        local liu_bei = gst.character_query_for_template("3k_main_template_historical_liu_bei_hero_earth")
        --cm:modify_character(cao_cao):set_is_deployable(false)
        --部署刘备的军队
        
        liu_bei_military = gst.faction_find_character_military_force(liu_bei)
        
        if query_military_force_leader(liu_bei_military) then
            local mod_liu_bei_military = cm:modify_military_force(liu_bei_military);
            mod_liu_bei_military:add_existing_character_as_retinue(cm:modify_character(gst.character_query_for_template("3k_main_template_historical_zhuge_liang_hero_water")), true);
            
            mod_liu_bei_military:add_existing_character_as_retinue(cm:modify_character(gst.character_query_for_template("3k_main_template_historical_pang_tong_hero_water")), true);
            
            cm:modify_character(query_military_force_leader(liu_bei_military)):teleport_to(451, 353);
            cm:modify_character(query_military_force_leader(liu_bei_military)):zero_action_points()
        end
        
--         if #general_characters > 0 then
--             local character = gst.character_query_for_template(general_characters[1])
--             ModLog(general_characters[1])
--             local force = gst.faction_create_military_force("3k_main_faction_liu_bei", "3k_main_jiangxia_capital", character)
--             cm:modify_character(query_military_force_leader(force)):teleport_to(446, 355);
--         end
        
        local guan_yu = gst.character_query_for_template("3k_main_template_historical_guan_yu_hero_wood")
        if guan_yu 
        and not guan_yu:is_dead() 
        and not guan_yu:is_character_is_faction_recruitment_pool() 
        and guan_yu:faction():name() == "3k_main_faction_liu_bei"
        then
            local military_force = gst.faction_find_character_military_force(guan_yu)
            cm:modify_character(query_military_force_leader(military_force)):teleport_to(450, 367);
            cm:modify_character(query_military_force_leader(military_force)):zero_action_points()
        end
        if cm:query_faction("3k_main_faction_liu_bei"):is_human() then
            local zhuge_liang = gst.character_query_for_template("3k_main_template_historical_zhuge_liang_hero_water")
            local incident = cm:modify_model():create_incident("chibi_battle_start_ready");
            incident:add_character_target("target_character_1", zhuge_liang);
            incident:add_faction_target("target_faction_1", cm:query_faction("3k_main_faction_liu_bei"));
            incident:trigger(cm:modify_faction(cm:query_faction("3k_main_faction_liu_bei")), true);
        end
    end,
    false
)

core:add_listener(
    "chibi_battle_ready4_sun_ce",
    "FactionTurnStart",
    function(context)
        return 
        context:query_model():calendar_year() >= 208 
        and context:query_model():calendar_year() < 209
        and valid_check()
        and context:query_model():season() == "season_autumn"
        and cm:get_saved_value("chibi_battle_ready2")
        and context:query_model():campaign_name() == "3k_dlc07_start_pos"
        and context:faction():name() == "3k_dlc05_faction_sun_ce"
    end,
    function(context)
        --如果孙权是玩家触发移动军队任务
        if cm:query_faction("3k_dlc05_faction_sun_ce"):is_human() then
            cm:modify_faction("3k_dlc05_faction_sun_ce"):complete_custom_mission("chibi_battle_ready_sun_quan")
        else
            --cm:modify_faction("3k_dlc05_faction_sun_ce"):disable_movement()
        end
        
        local huang_gai = gst.character_query_for_template("3k_cp01_template_historical_huang_gai_hero_fire")
        
        --cm:modify_character(cao_cao):set_is_deployable(false)
        --部署孙权的军队
        
        huang_gai_military = gst.faction_find_character_military_force(huang_gai)
        
        if query_military_force_leader(huang_gai_military) then
            local mod_huang_gai_military = cm:modify_military_force(huang_gai_military);
            mod_huang_gai_military:add_existing_character_as_retinue(cm:modify_character(gst.character_query_for_template("3k_main_template_historical_zhou_yu_hero_water")), true);
            
            mod_huang_gai_military:add_existing_character_as_retinue(cm:modify_character(gst.character_query_for_template("3k_main_template_historical_sun_quan_hero_earth")), true);
            
            cm:modify_character(query_military_force_leader(huang_gai_military)):teleport_to(449, 344);
            cm:modify_character(query_military_force_leader(huang_gai_military)):apply_effect_bundle("chibi_battle_start_attack", 1)
        end
        
        if cm:query_faction("3k_dlc05_faction_sun_ce"):is_human() then
            local zhuge_liang = gst.character_query_for_template("3k_main_template_historical_zhuge_liang_hero_water")
            local incident = cm:modify_model():create_incident("chibi_battle_start_ready");
            incident:add_character_target("target_character_1", zhuge_liang);
            incident:add_faction_target("target_faction_1", cm:query_faction("3k_dlc05_faction_sun_ce"));
            incident:trigger(cm:modify_faction(cm:query_faction("3k_dlc05_faction_sun_ce")), true);
        end
    end,
    false
)

core:add_listener(
    "chibi_battle_start",
    "FactionTurnStart",
    function(context)
        return 
        context:query_model():calendar_year() >= 208 
        and context:query_model():calendar_year() < 209
        and valid_check()
        and cm:get_saved_value("chibi_battle_ready3")
        and context:query_model():season() == "season_autumn"
        and context:query_model():campaign_name() == "3k_dlc07_start_pos"
    end,
    function(context)
        if context:faction():name() == "3k_main_faction_liu_bei" 
        or context:faction():name() == "3k_main_faction_cao_cao" 
        or context:faction():name() == "3k_dlc05_faction_sun_ce" then
            local character_list = context:faction():character_list()
            for i = 0, character_list:num_items() - 1 do
                local character = character_list:item_at(i);
                if character:has_military_force() then
                    if context:faction():is_human() then
                        cm:modify_character(character):apply_effect_bundle("chibi_battle_start",-1)
                    else
                        cm:modify_character(character):apply_effect_bundle("chibi_battle_start_AI",-1)
                        cm:modify_character(character):disable_movement()
                    end
                end
            end
        end
        if context:faction():name() == "3k_dlc05_faction_sun_ce" then
            local huang_gai = gst.character_query_for_template("3k_cp01_template_historical_huang_gai_hero_fire")
            local query_sun = query_military_force_leader(gst.faction_find_character_military_force(huang_gai))
            cm:modify_character(query_sun):teleport_to(444, 355);
        end
    end,
    true
)

core:add_listener(
    "chibi_battle_start_cao_cao_human",
    "FactionTurnStart",
    function(context)
        return 
        context:query_model():calendar_year() == 208 
        and valid_check()
        and context:query_model():season() == "season_winter"
        and context:query_model():campaign_name() == "3k_dlc07_start_pos"
        and context:faction():name() == "3k_main_faction_cao_cao"
        and cm:query_faction("3k_main_faction_cao_cao"):is_human()
        and not cm:get_saved_value("chibi_battle_start_cao_cao_human")
    end,
    function(context)
        ModLog("trigger dilemma chibi_battle_start_dilemma")
        cm:trigger_dilemma("3k_main_faction_cao_cao", "chibi_battle_start_dilemma", true);
        cm:set_saved_value("chibi_battle_start_cao_cao_human", true)
    end,
    false
)

core:add_listener(
    "chibi_battle_start_dilemma",
    "DilemmaChoiceMadeEvent",
    function(context)
        return 
        context:query_model():calendar_year() == 208 
        and valid_check()
        and cm:get_saved_value("chibi_battle_ready3")
        and not cm:get_saved_value("chibi_battle_start_2")
        and context:query_model():campaign_name() == "3k_dlc07_start_pos"
        and context:dilemma() == "chibi_battle_start_dilemma"
    end,
    function(context)
        local huang_gai = gst.character_query_for_template("3k_cp01_template_historical_huang_gai_hero_fire")
        local sun_quan = gst.character_query_for_template("3k_main_template_historical_sun_quan_hero_earth")
        sun_quan_military = gst.faction_find_character_military_force(huang_gai)
        local cao_cao = gst.character_query_for_template("3k_main_template_historical_cao_cao_hero_earth")
        cao_cao_military = gst.faction_find_character_military_force(cao_cao)
        local liu_bei = gst.character_query_for_template("3k_main_template_historical_liu_bei_hero_earth")
        liu_bei_military = gst.faction_find_character_military_force(liu_bei)
        local query_cao = query_military_force_leader(cao_cao_military)
        local query_sun = query_military_force_leader(sun_quan_military)
        
--         cm:modify_character(query_cao):attack(query_sun)
        
        if context:choice() == 0 then
            cm:modify_model():get_modify_episodic_scripting():register_instant_movie_by_record("3k_main_game_lost_earth_yuan_shu");
            cm:modify_faction("3k_main_faction_cao_cao"):remove_effect_bundle("chibi_battle_cao_cao_buff_1")
            cm:modify_faction("3k_main_faction_cao_cao"):apply_effect_bundle("chibi_battle_cao_cao_buff_2", 1)
            cm:modify_faction("3k_main_faction_cao_cao"):apply_effect_bundle("chibi_battle_cao_cao_buff_2_unseen", 1)
        else
            cm:modify_character(huang_gai):kill_character(true)
            cm:set_saved_value("invalid", true)
            local character_list = cm:query_faction("3k_main_faction_liu_bei"):character_list()
            for i = 0, character_list:num_items() - 1 do
                local character = character_list:item_at(i);
                if character:has_military_force() then
                    cm:modify_character(character):remove_effect_bundle("chibi_battle_start")
                    cm:modify_character(character):remove_effect_bundle("chibi_battle_start_AI")
                    cm:modify_character(character):enable_movement()
                end
            end
            local character_list = cm:query_faction("3k_dlc05_faction_sun_ce"):character_list()
            for i = 0, character_list:num_items() - 1 do
                local character = character_list:item_at(i);
                if character:has_military_force() then
                    cm:modify_character(character):remove_effect_bundle("chibi_battle_start")
                    cm:modify_character(character):remove_effect_bundle("chibi_battle_start_AI")
                    cm:modify_character(character):enable_movement()
                end
            end
            local character_list = cm:query_faction("3k_main_faction_cao_cao"):character_list()
            for i = 0, character_list:num_items() - 1 do
                local character = character_list:item_at(i);
                if character:has_military_force() then
                    cm:modify_character(character):remove_effect_bundle("chibi_battle_start")
                    cm:modify_character(character):remove_effect_bundle("chibi_battle_start_AI")
                    cm:modify_character(character):enable_movement()
                end
            end
        end
        
        cm:modify_character(query_sun):assign_faction_leader()
        cm:trigger_mission(cm:query_faction("3k_main_faction_cao_cao"), "chibi_battle_start_cao_cao", true);
        gst.faction_set_minister_position("3k_main_template_historical_sun_quan_hero_earth","faction_leader");
        
        if cm:query_faction("3k_dlc05_faction_sun_ce"):is_human() then
            cm:trigger_mission(cm:query_faction("3k_dlc05_faction_sun_ce"), "chibi_battle_start_sun_quan", true);
        end
        if cm:query_faction("3k_main_faction_liu_bei"):is_human() then
            cm:trigger_mission(cm:query_faction("3k_main_faction_liu_bei"), "chibi_battle_start_liu_bei", true);
        end
        cm:set_saved_value("chibi_battle_start_2", true)
    end,
    true
)
core:add_listener(
    "chibi_battle_start_cao_cao_npc",
    "FactionTurnStart",
    function(context)
        return 
        context:query_model():calendar_year() == 208 
        and valid_check()
        and context:query_model():season() == "season_winter"
        and not cm:get_saved_value("chibi_battle_start_cao_cao_npc")
        and context:query_model():campaign_name() == "3k_dlc07_start_pos"
        and not cm:query_faction("3k_main_faction_cao_cao"):is_human()
    end,
    function(context)
        cm:modify_model():get_modify_episodic_scripting():register_instant_movie_by_record("3k_main_game_lost_earth_yuan_shu");
        if not cm:query_faction("3k_main_faction_liu_bei"):is_human() then
            cm:modify_faction("3k_main_faction_liu_bei"):apply_effect_bundle("chibi_battle_sun_quan_buff", 1)
        end
        if not cm:query_faction("3k_dlc05_faction_sun_ce"):is_human() then
            cm:modify_faction("3k_dlc05_faction_sun_ce"):apply_effect_bundle("chibi_battle_sun_quan_buff", 1)
        end
        
        if cm:query_faction("3k_dlc05_faction_sun_ce"):is_human() then
            cm:trigger_mission(cm:query_faction("3k_dlc05_faction_sun_ce"), "chibi_battle_start_sun_quan", true);
        end
        if cm:query_faction("3k_main_faction_liu_bei"):is_human() then
            cm:trigger_mission(cm:query_faction("3k_main_faction_liu_bei"), "chibi_battle_start_liu_bei", true);
        end
        cm:set_saved_value("chibi_battle_start_cao_cao_npc", true)
    end,
    true
)

--恢复行动力
core:add_listener(
    "chibi_battle_action_points",
    "CharacterFinishedMovingEvent",
    function(context)
        return 
        context:query_model():calendar_year() >= 208 
        and context:query_model():calendar_year() <= 209
        and valid_check()
        and cm:query_model():campaign_name() == "3k_dlc07_start_pos"
        and context:query_character():faction():is_human()
        and (context:query_character():faction():is_mission_active("chibi_battle_start_sun_quan")
        or context:query_character():faction():is_mission_active("chibi_battle_start_liu_bei")
        or context:query_character():faction():is_mission_active("chibi_battle_start_cao_cao"))
    end,
    function(context)
        cm:modify_character(context:query_character()):replenish_action_points()
    end,
    true
)
--赤壁之战之后
core:add_listener(
    "chibi_battle_start_after",
    "MissionSucceeded",
    function(context)
        return 
        context:query_model():calendar_year() >= 208 
        and context:query_model():calendar_year() <= 209
        and valid_check()
        and cm:query_model():campaign_name() == "3k_dlc07_start_pos"
        and not cm:get_saved_value("cao_cao_after_chibi_battle")
    end,
    function(context)
        if context:mission():mission_record_key() == "chibi_battle_start_cao_cao"
        or context:mission():mission_record_key() == "chibi_battle_start_liu_bei"
        or context:mission():mission_record_key() == "chibi_battle_start_sun_quan" 
        then
            local character_list = cm:query_faction("3k_main_faction_liu_bei"):character_list()
            for i = 0, character_list:num_items() - 1 do
                local character = character_list:item_at(i);
                if character:has_military_force() then
                    cm:modify_character(character):remove_effect_bundle("chibi_battle_start")
                    cm:modify_character(character):remove_effect_bundle("chibi_battle_start_AI")
                    cm:modify_character(character):enable_movement()
                end
            end
            local character_list = cm:query_faction("3k_dlc05_faction_sun_ce"):character_list()
            for i = 0, character_list:num_items() - 1 do
                local character = character_list:item_at(i);
                if character:has_military_force() then
                    cm:modify_character(character):remove_effect_bundle("chibi_battle_start")
                    cm:modify_character(character):remove_effect_bundle("chibi_battle_start_AI")
                    cm:modify_character(character):enable_movement()
                end
            end
            local character_list = cm:query_faction("3k_main_faction_cao_cao"):character_list()
            for i = 0, character_list:num_items() - 1 do
                local character = character_list:item_at(i);
                if character:has_military_force() then
                    cm:modify_character(character):remove_effect_bundle("chibi_battle_start")
                    cm:modify_character(character):remove_effect_bundle("chibi_battle_start_AI")
                    cm:modify_character(character):enable_movement()
                end
            end
            if cm:query_faction("3k_main_faction_cao_cao"):is_human() then
                cm:trigger_incident("3k_main_faction_cao_cao","chibi_battle_start_after",true)
                cm:modify_faction("3k_dlc05_faction_sun_ce"):complete_custom_mission("chibi_battle_start_cao_cao")
                gst.faction_add_tickets("3k_main_faction_cao_cao", 20);
            end
            if cm:query_faction("3k_main_faction_liu_bei"):is_human() then
                cm:trigger_incident("3k_main_faction_liu_bei","chibi_battle_start_after2",true)
                cm:modify_faction("3k_dlc05_faction_sun_ce"):complete_custom_mission("chibi_battle_start_liu_bei")
                gst.faction_add_tickets("3k_main_faction_liu_bei", 20);
            end
            if cm:query_faction("3k_dlc05_faction_sun_ce"):is_human() then
                cm:trigger_incident("3k_dlc05_faction_sun_ce","chibi_battle_start_after2",true)
                cm:modify_faction("3k_dlc05_faction_sun_ce"):complete_custom_mission("chibi_battle_start_sun_quan")
                gst.faction_add_tickets("3k_dlc05_faction_sun_ce", 20);
            end
            cm:modify_faction("3k_main_faction_cao_cao"):remove_effect_bundle("chibi_battle_cao_cao_buff_2")
            cm:modify_faction("3k_main_faction_cao_cao"):remove_effect_bundle("chibi_battle_cao_cao_buff_2_unseen")
            cm:modify_faction("3k_main_faction_cao_cao"):apply_effect_bundle("chibi_battle_cao_cao_buff_3", 5)
            cm:modify_faction("3k_dlc05_faction_sun_ce"):remove_effect_bundle("chibi_battle_sun_quan_buff")
            cm:modify_faction("3k_main_faction_liu_bei"):remove_effect_bundle("chibi_battle_sun_quan_buff")
            
            local cao_cao = gst.character_query_for_template("3k_main_template_historical_cao_cao_hero_earth")
            local m1 = gst.faction_military_teleport_to_region(cao_cao, "3k_main_runan_resource_1")
            cm:modify_character(m1:general_character()):zero_action_points()
            
            local xu_huang = gst.character_query_for_template("3k_main_template_historical_xu_huang_hero_metal")
            local m2 = gst.faction_military_teleport_to_region(xu_huang, "3k_main_runan_resource_1")
            cm:modify_character(m2:general_character()):zero_action_points()
            
            local yue_jin = gst.character_query_for_template("3k_main_template_historical_yue_jin_hero_metal")
            local m3 = gst.faction_military_teleport_to_region(yue_jin, "3k_main_runan_resource_1")
            cm:modify_character(m3:general_character()):zero_action_points()
            
            local cao_ren = gst.character_query_for_template("3k_main_template_historical_cao_ren_hero_earth")
            local m4 = gst.faction_military_teleport_to_region(cao_ren, "3k_main_runan_resource_1")
            cm:modify_character(m4:general_character()):zero_action_points()
            cm:set_saved_value("cao_cao_after_chibi_battle", true)
            
        end
    end,
    true
)

 --209年：刘备取荆州
core:add_listener(
    "confederate_liu_bei_209",
    "FactionTurnStart",
    function(context)
        return 
        context:query_model():calendar_year() == 209
        and valid_check()
        and not cm:get_saved_value("confederate_liu_bei_209")
        and cm:query_model():campaign_name() == "3k_dlc07_start_pos";
    end,
    function(context)
        if not cm:query_faction("3k_main_faction_liu_bei"):is_human() then
            diplomacy_manager:force_confederation("3k_main_faction_liu_bei", "3k_main_faction_liu_biao_separatists");
            --荆州
            --长沙
            gst.region_force_set_manager("3k_main_changsha_capital","3k_main_faction_liu_bei")
            gst.region_force_set_manager("3k_main_changsha_resource_1","3k_main_faction_liu_bei")
            gst.region_force_set_manager("3k_main_changsha_resource_2","3k_main_faction_liu_bei")
            gst.region_force_set_manager("3k_main_changsha_resource_3","3k_main_faction_liu_bei")
            
            --零陵
            gst.region_force_set_manager("3k_main_lingling_capital","3k_main_faction_liu_bei")
            gst.region_force_set_manager("3k_main_lingling_resource_1","3k_main_faction_liu_bei")
            gst.region_force_set_manager("3k_main_lingling_resource_2","3k_main_faction_liu_bei")
            gst.region_force_set_manager("3k_main_lingling_resource_3","3k_main_faction_liu_bei")
        
            --苍梧
            gst.region_force_set_manager("3k_main_cangwu_capital","3k_main_faction_liu_bei")
            gst.region_force_set_manager("3k_main_cangwu_resource_1","3k_main_faction_liu_bei")
            gst.region_force_set_manager("3k_main_cangwu_resource_2","3k_main_faction_liu_bei")
            gst.region_force_set_manager("3k_main_cangwu_resource_3","3k_main_faction_liu_bei")
            
            --江夏
            gst.region_set_manager("3k_main_jiangxia_capital","3k_main_faction_liu_bei")
            
            --襄阳
            
            --南郡
            gst.region_set_manager("3k_main_jingzhou_capital","3k_main_faction_liu_bei")
            gst.region_force_set_manager("3k_main_jingzhou_resource_1","3k_main_faction_liu_bei")
            
            --武陵
            gst.region_force_set_manager("3k_main_wuling_capital","3k_main_faction_liu_bei")
            gst.region_force_set_manager("3k_main_wuling_resource_1","3k_main_faction_liu_bei")
            gst.region_force_set_manager("3k_main_wuling_resource_2","3k_main_faction_liu_bei")
            gst.region_force_set_manager("3k_main_wuling_resource_3","3k_main_faction_liu_bei")
            
            --交州
            --交趾
            gst.region_force_set_manager("3k_dlc06_jiaozhi_resource_3","3k_main_faction_liu_bei")
        else
            cm:trigger_mission(cm:query_faction("3k_main_faction_liu_bei"), "confederate_liu_bei_209", true);
        end
        cm:set_saved_value("confederate_liu_bei_209", true)
    end,
    false
)
--209年：刘琮的领地被锁定为只能刘备获取
core:add_listener(
    "confederate_liu_bei_209_human",
    "FactionTurnStart",
    function(context)
        return 
        valid_check()
        and cm:get_saved_value("confederate_liu_bei_209")
        and cm:query_faction("3k_main_faction_liu_bei"):is_human()
        and cm:query_model():campaign_name() == "3k_dlc07_start_pos";
    end,
    function(context)
        local region_table = {
        "3k_main_changsha_capital",
        "3k_main_changsha_resource_1",
        "3k_main_changsha_resource_2",
        "3k_main_changsha_resource_3",
        "3k_main_lingling_capital",
        "3k_main_lingling_resource_1",
        "3k_main_lingling_resource_2",
        "3k_main_lingling_resource_3",
        "3k_main_cangwu_capital",
        "3k_main_cangwu_resource_1",
        "3k_main_cangwu_resource_2",
        "3k_main_changsha_resource_1",
        "3k_main_cangwu_resource_3",
        "3k_main_jiangxia_capital",
        "3k_main_jingzhou_capital",
        "3k_main_wuling_capital",
        "3k_main_wuling_resource_1",
        "3k_main_wuling_resource_2",
        "3k_main_wuling_resource_3",
        "3k_main_jiaozhi_capital"
        }
        
        for i, v in ipairs(region_table) do
            local region = cm:query_region(v)
            if region 
            and not region:is_null_interface() 
            then
                if not region:owning_faction() 
                or region:owning_faction():is_null_interface()
                then
                    gst.region_force_set_manager("3k_main_changsha_capital","3k_main_faction_liu_biao_separatists")
                elseif not region:owning_faction():name() == "3k_main_faction_liu_bei" 
                and not region:owning_faction():name() == "3k_main_faction_liu_biao_separatists" 
                then
                    gst.region_force_set_manager("3k_main_changsha_capital","3k_main_faction_liu_biao_separatists")
                end
            end
        end
            
    end,
    false
)
--210年：士燮投降
core:add_listener(
    "confederate_sun_quan_210",
    "FactionTurnStart",
    function(context)
        return 
        context:query_model():calendar_year() == 210
        and valid_check()
        and not cm:query_faction("3k_main_faction_shi_xie"):is_human()
        and not cm:query_faction("3k_dlc05_faction_shi_huang"):is_human()
        and not cm:query_faction("3k_dlc05_faction_shi_wu"):is_human()
        and not cm:query_faction("3k_dlc05_faction_shi_yi"):is_human()
        and not cm:query_faction("3k_dlc07_faction_shi_hui"):is_human()
        and not cm:query_faction("3k_dlc05_faction_sun_ce"):is_human()
        and cm:query_model():campaign_name() == "3k_dlc07_start_pos";
    end,
    function(context)
        diplomacy_manager:force_confederation("3k_dlc05_faction_sun_ce", "3k_main_faction_shi_xie");
        diplomacy_manager:force_confederation("3k_dlc05_faction_sun_ce", "3k_dlc05_faction_shi_wu");
        diplomacy_manager:force_confederation("3k_dlc05_faction_sun_ce", "3k_dlc05_faction_shi_yi");
        diplomacy_manager:force_confederation("3k_dlc05_faction_sun_ce", "3k_dlc07_faction_shi_hui");
        diplomacy_manager:force_confederation("3k_dlc05_faction_sun_ce", "3k_dlc05_faction_shi_huang");
    end,
    false
)

--213年：刘备入蜀，三分天下
core:add_listener(
    "liu_bei_ai_confederation_listener_liu_yan_force",
    "FactionTurnStart",
    function(context)
        return
        cm:get_saved_value("liu_biao_confederation") 
        and context:query_model():calendar_year() >= 213 
        and context:query_model():calendar_year() < 215 
        and valid_check()
        and not cm:query_faction("3k_main_faction_liu_bei"):is_dead()
        and not cm:query_faction("3k_main_faction_liu_yan"):is_human()
        and not cm:query_faction("3k_main_faction_liu_yan"):is_dead()
        and cm:query_model():campaign_name() == "3k_dlc07_start_pos";
    end,
    function()
        local faction = cm:query_faction("3k_main_faction_liu_bei")
        if not faction:is_human() then
        
            diplomacy_manager:apply_automatic_deal_between_factions("3k_dlc07_faction_zhang_lu", "3k_main_faction_liu_yan", "data_defined_situation_war_proposer_to_recipient")
            
            diplomacy_manager:force_confederation("3k_main_faction_liu_bei", "3k_main_faction_liu_yan");
            cm:modify_faction(faction):make_region_capital(cm:query_region("3k_main_chengdu_capital"));
--             liu_bei_defeat_nanman("3k_dlc06_faction_nanman_dongtuna") 
--             liu_bei_defeat_nanman("3k_dlc06_faction_nanman_jiangyang") 
--             liu_bei_defeat_nanman("3k_dlc06_faction_nanman_jianning")
--             liu_bei_defeat_nanman("3k_dlc06_faction_nanman_jiaozhi") 
--             liu_bei_defeat_nanman("3k_dlc06_faction_nanman_king_duosi") 
--             liu_bei_defeat_nanman("3k_dlc06_faction_nanman_king_mulu")
--             liu_bei_defeat_nanman("3k_dlc06_faction_nanman_king_shamoke")
--             liu_bei_defeat_nanman("3k_dlc06_faction_nanman_king_wutugu")
--             liu_bei_defeat_nanman("3k_dlc06_faction_nanman_lady_zhurong")
--             liu_bei_defeat_nanman("3k_dlc06_faction_nanman_mangyachang")
--             liu_bei_defeat_nanman("3k_dlc06_faction_nanman_tu_an")
--             liu_bei_defeat_nanman("3k_dlc06_faction_nanman_xi_ni")
--             liu_bei_defeat_nanman("3k_dlc06_faction_nanman_yang_feng")
--             liu_bei_defeat_nanman("3k_dlc06_faction_nanman_yongchang")
--             liu_bei_defeat_nanman("3k_dlc06_faction_nanman_yunnan")
--             liu_bei_defeat_nanman("3k_dlc06_faction_nanman_zangke")
            
            --益州
            --巴东
            gst.region_set_manager("3k_main_badong_capital","3k_main_faction_liu_bei")
            gst.region_set_manager("3k_main_badong_resource_1","3k_main_faction_liu_bei")
            gst.region_set_manager("3k_main_badong_resource_2","3k_main_faction_liu_bei")
            
            --上庸
            gst.region_set_manager("3k_main_shangyong_capital","3k_main_faction_liu_bei")
            gst.region_set_manager("3k_main_shangyong_resource_1","3k_main_faction_liu_bei")
            gst.region_set_manager("3k_main_shangyong_resource_2","3k_main_faction_liu_bei")
            
            --涪陵
            gst.region_set_manager("3k_main_fuling_capital","3k_main_faction_liu_bei")
            gst.region_set_manager("3k_main_fuling_resource_1","3k_main_faction_liu_bei")
            
            --巴郡
            gst.region_set_manager("3k_main_bajun_capital","3k_main_faction_liu_bei")
            gst.region_set_manager("3k_main_bajun_resource_1","3k_main_faction_liu_bei")
            
            --蜀郡
            gst.region_set_manager("3k_main_chengdu_capital","3k_main_faction_liu_bei")
            gst.region_set_manager("3k_main_chengdu_resource_1","3k_main_faction_liu_bei")
            gst.region_set_manager("3k_main_chengdu_resource_2","3k_main_faction_liu_bei")
            gst.region_set_manager("3k_main_chengdu_resource_3","3k_main_faction_liu_bei")
            
            --江阳
            gst.region_set_manager("3k_main_jiangyang_capital","3k_main_faction_liu_bei")
            gst.region_set_manager("3k_main_jiangyang_resource_1","3k_main_faction_liu_bei")
            gst.region_set_manager("3k_main_jiangyang_resource_2","3k_main_faction_liu_bei")
            gst.region_set_manager("3k_main_jiangyang_resource_3","3k_main_faction_liu_bei")
            
            --永昌
            gst.region_set_manager("3k_dlc06_yongchang_capital","3k_main_faction_liu_bei")
            gst.region_set_manager("3k_dlc06_yongchang_resource_1","3k_main_faction_liu_bei")
            
            --牂牁
            gst.region_set_manager("3k_main_zangke_capital","3k_main_faction_liu_bei")
            gst.region_set_manager("3k_main_zangke_resource_1","3k_main_faction_liu_bei")
            gst.region_set_manager("3k_main_zangke_resource_2","3k_main_faction_liu_bei")
            
            --云南
            gst.region_set_manager("3k_dlc06_yunnan_capital","3k_main_faction_liu_bei")
            gst.region_set_manager("3k_dlc06_yunnan_resource_1","3k_main_faction_liu_bei")
            gst.region_set_manager("3k_dlc06_yunnan_resource_2","3k_main_faction_liu_bei")
            
            --建宁
            gst.region_set_manager("3k_main_jianning_capital","3k_main_faction_liu_bei")
            gst.region_set_manager("3k_main_jianning_resource_1","3k_main_faction_liu_bei")
            gst.region_set_manager("3k_main_jianning_resource_2","3k_main_faction_liu_bei")
            gst.region_set_manager("3k_dlc06_jianning_resource_3","3k_main_faction_liu_bei")
            
            --巴西
            gst.region_set_manager("3k_main_baxi_capital","3k_main_faction_liu_bei")
            gst.region_set_manager("3k_main_baxi_resource_1","3k_main_faction_liu_bei")
            gst.region_set_manager("3k_main_baxi_resource_2","3k_main_faction_liu_bei")
            
            --夔关
            gst.region_set_manager("3k_dlc06_kui_pass","3k_main_faction_liu_bei")
            
            if not cm:query_faction("3k_main_faction_cao_cao"):is_human() then
                diplomacy_manager:force_confederation("3k_main_faction_cao_cao", "3k_dlc07_faction_zhang_lu");
            else
                cm:trigger_dilemma("3k_main_faction_cao_cao", "confederate_cao_cao_and_zhang_lu", true);
            end
            
            --如果法正不在玩家派系则加入刘备
            local fa_zheng = gst.character_query_for_template("3k_main_template_historical_fa_zheng_hero_water")
            if
            not mi_zhu:is_null_interface()
            and not mi_zhu:is_dead()
            and (not mi_zhu:faction():is_human() or mi_zhu:is_character_is_faction_recruitment_pool()) then
                gst.character_add_to_faction("3k_main_template_historical_fa_zheng_hero_water", "3k_main_faction_liu_bei", "3k_general_water"); 
            end
            
            --如果张松不在玩家派系则加入刘备
            local zhang_song = gst.character_query_for_template("3k_main_template_historical_zhang_song_hero_water")
            if
            not zhang_song:is_null_interface()
            and not zhang_song:is_dead()
            and (not zhang_song:faction():is_human() or zhang_song:is_character_is_faction_recruitment_pool()) then
                gst.character_add_to_faction("3k_main_template_historical_zhang_song_hero_water", "3k_main_faction_liu_bei", "3k_general_water"); 
            end
            
            --如果严颜不在玩家派系则加入刘备
            local yan_yan = gst.character_query_for_template("hlyjdb")
            if
            not yan_yan:is_null_interface()
            and not yan_yan:is_dead()
            and (not yan_yan:faction():is_human() or yan_yan:is_character_is_faction_recruitment_pool()) then
                gst.character_add_to_faction("hlyjdb", "3k_main_faction_liu_bei", "3k_general_fire"); 
            end
                
        else
            diplomacy_manager:apply_automatic_deal_between_factions("3k_dlc07_faction_zhang_lu", "3k_main_faction_liu_yan", "data_defined_situation_war_proposer_to_recipient")
            
            cm:trigger_dilemma("3k_main_faction_liu_bei", "confederate_liu_bei_and_liu_zhang", true);
        end
    end,
    true
)

core:add_listener(
    "confederate_liu_bei_and_liu_zhang",
    "DilemmaChoiceMadeEvent",
    function(context) 
        return context:dilemma() == "confederate_liu_bei_and_liu_zhang"
        and valid_check()
    end, -- criteria
    function (context) --what to do if listener fires
        if context:choice() == 0 then
            --益州
            --巴东
            gst.region_set_manager("3k_main_badong_capital","3k_main_faction_liu_bei")
            gst.region_set_manager("3k_main_badong_resource_1","3k_main_faction_liu_bei")
            gst.region_set_manager("3k_main_badong_resource_2","3k_main_faction_liu_bei")
            
            --上庸
            gst.region_set_manager("3k_main_shangyong_capital","3k_main_faction_liu_bei")
            gst.region_set_manager("3k_main_shangyong_resource_1","3k_main_faction_liu_bei")
            gst.region_set_manager("3k_main_shangyong_resource_2","3k_main_faction_liu_bei")
            
            --涪陵
            gst.region_set_manager("3k_main_fuling_capital","3k_main_faction_liu_bei")
            gst.region_set_manager("3k_main_fuling_resource_1","3k_main_faction_liu_bei")
            
            --巴郡
            gst.region_set_manager("3k_main_bajun_capital","3k_main_faction_liu_bei")
            gst.region_set_manager("3k_main_bajun_resource_1","3k_main_faction_liu_bei")
            
            --蜀郡
            gst.region_set_manager("3k_main_chengdu_capital","3k_main_faction_liu_bei")
            gst.region_set_manager("3k_main_chengdu_resource_1","3k_main_faction_liu_bei")
            gst.region_set_manager("3k_main_chengdu_resource_2","3k_main_faction_liu_bei")
            gst.region_set_manager("3k_main_chengdu_resource_3","3k_main_faction_liu_bei")
            
            --江阳
            gst.region_set_manager("3k_main_jiangyang_capital","3k_main_faction_liu_bei")
            gst.region_set_manager("3k_main_jiangyang_resource_1","3k_main_faction_liu_bei")
            gst.region_set_manager("3k_main_jiangyang_resource_2","3k_main_faction_liu_bei")
            gst.region_set_manager("3k_main_jiangyang_resource_3","3k_main_faction_liu_bei")
            
            --永昌
            gst.region_set_manager("3k_dlc06_yongchang_capital","3k_main_faction_liu_bei")
            gst.region_set_manager("3k_dlc06_yongchang_resource_1","3k_main_faction_liu_bei")
            
            --牂牁
            gst.region_set_manager("3k_main_zangke_capital","3k_main_faction_liu_bei")
            gst.region_set_manager("3k_main_zangke_resource_1","3k_main_faction_liu_bei")
            gst.region_set_manager("3k_main_zangke_resource_2","3k_main_faction_liu_bei")
            
            --云南
            gst.region_set_manager("3k_dlc06_yunnan_capital","3k_main_faction_liu_bei")
            gst.region_set_manager("3k_dlc06_yunnan_resource_1","3k_main_faction_liu_bei")
            gst.region_set_manager("3k_dlc06_yunnan_resource_2","3k_main_faction_liu_bei")
            
            --建宁
            gst.region_set_manager("3k_main_jianning_capital","3k_main_faction_liu_bei")
            gst.region_set_manager("3k_main_jianning_resource_1","3k_main_faction_liu_bei")
            gst.region_set_manager("3k_main_jianning_resource_2","3k_main_faction_liu_bei")
            gst.region_set_manager("3k_dlc06_jianning_resource_3","3k_main_faction_liu_bei")
            
            --巴西
            gst.region_set_manager("3k_main_baxi_capital","3k_main_faction_liu_bei")
            gst.region_set_manager("3k_main_baxi_resource_1","3k_main_faction_liu_bei")
            gst.region_set_manager("3k_main_baxi_resource_2","3k_main_faction_liu_bei")
            
            --夔关
            gst.region_set_manager("3k_dlc06_kui_pass","3k_main_faction_liu_bei")
            
            --cm:modify_faction("3k_main_faction_liu_bei"):apply_effect_bundle("world_leader",-1);
            
            --如果法正不在玩家派系则加入刘备
            local fa_zheng = gst.character_query_for_template("3k_main_template_historical_fa_zheng_hero_water")
            if
            not mi_zhu:is_null_interface()
            and not mi_zhu:is_dead()
            and (not mi_zhu:faction():is_human() or mi_zhu:is_character_is_faction_recruitment_pool()) then
                gst.character_add_to_faction("3k_main_template_historical_fa_zheng_hero_water", "3k_main_faction_liu_bei", "3k_general_water"); 
            end
            
            --如果张松不在玩家派系则加入刘备
            local zhang_song = gst.character_query_for_template("3k_main_template_historical_zhang_song_hero_water")
            if
            not zhang_song:is_null_interface()
            and not zhang_song:is_dead()
            and (not zhang_song:faction():is_human() or zhang_song:is_character_is_faction_recruitment_pool()) then
                gst.character_add_to_faction("3k_main_template_historical_zhang_song_hero_water", "3k_main_faction_liu_bei", "3k_general_water"); 
            end
            
            --如果严颜不在玩家派系则加入刘备
            local yan_yan = gst.character_query_for_template("hlyjdb")
            if
            not yan_yan:is_null_interface()
            and not yan_yan:is_dead()
            and (not yan_yan:faction():is_human() or yan_yan:is_character_is_faction_recruitment_pool()) then
                gst.character_add_to_faction("hlyjdb", "3k_main_faction_liu_bei", "3k_general_fire"); 
            end
            
            if not cm:query_faction("3k_main_faction_cao_cao"):is_human() then
                diplomacy_manager:force_confederation("3k_main_faction_cao_cao", "3k_dlc07_faction_zhang_lu");
            else
                cm:trigger_dilemma("3k_main_faction_cao_cao","confederate_cao_cao_and_zhang_lu", true);
            end
        else
            cm:set_saved_value("invalid", true);
        end
        
    end,   
    false
)

--213年：马超投靠刘备
core:add_listener(
    "ma_chao_liu_bei",
    "FactionTurnStart",
    function(context)
        return 
        context:query_model():calendar_year() == 213
        and valid_check()
        and not cm:query_faction("3k_main_faction_ma_teng"):is_human()
        and not cm:query_faction("3k_main_faction_liu_bei"):is_dead()
        and cm:query_model():campaign_name() == "3k_dlc07_start_pos";
    end,
    function()
        local ma_chao = gst.character_query_for_template("3k_main_template_historical_ma_chao_hero_fire")
        if not ma_chao:is_dead() then
            gst.character_add_to_faction("3k_main_template_historical_ma_chao_hero_fire", "3k_main_faction_liu_bei", "3k_general_fire")
        end
        if not cm:query_faction("3k_main_faction_ma_teng"):is_dead() then
            diplomacy_manager:force_confederation("3k_main_faction_cao_cao", "3k_main_faction_ma_teng");
        end
        if not cm:query_faction("3k_main_faction_ma_teng"):is_dead() then
            diplomacy_manager:force_confederation("3k_main_faction_cao_cao", "3k_main_faction_han_sui");
        end
    end,
    false
)

--215年 孙权索要荆州
core:add_listener(
    "215_event",
    "FactionTurnStart",
    function(context)
        return 
        context:query_model():calendar_year() == 215
        and valid_check()
        and context:faction():name() == "3k_dlc05_faction_sun_ce"
        and context:query_model():season() ~= "season_spring"
        and cm:query_model():campaign_name() == "3k_dlc07_start_pos"
        and not cm:query_faction("3k_main_faction_liu_bei"):is_dead()
        and not cm:get_saved_value("215_event")
    end,
    function(context)
            
        diplomacy_manager:apply_automatic_deal_between_factions("3k_dlc05_faction_sun_ce", "3k_main_faction_liu_bei", "data_quit_coalition")
        
        diplomacy_manager:apply_automatic_deal_between_factions("3k_dlc05_faction_sun_ce", "3k_main_faction_liu_bei",  "data_quit_allice")
            
        diplomacy_manager:apply_automatic_deal_between_factions("3k_main_faction_liu_bei", "3k_dlc05_faction_sun_ce", "data_defined_situation_break_deal")
        
        if not cm:query_faction("3k_dlc05_faction_sun_ce"):is_human() then
            gst.region_set_manager("3k_main_changsha_capital","3k_dlc05_faction_sun_ce")
            gst.region_set_manager("3k_main_changsha_resource_1","3k_dlc05_faction_sun_ce")
            gst.region_set_manager("3k_main_changsha_resource_2","3k_dlc05_faction_sun_ce")
            gst.region_set_manager("3k_main_changsha_resource_3","3k_dlc05_faction_sun_ce")
            
            gst.region_set_manager("3k_main_yuzhang_capital","3k_dlc05_faction_sun_ce")
            gst.region_set_manager("3k_main_yuzhang_resource_1","3k_dlc05_faction_sun_ce")
            gst.region_set_manager("3k_main_yuzhang_resource_2","3k_dlc05_faction_sun_ce")
            gst.region_set_manager("3k_main_yuzhang_resource_3","3k_dlc05_faction_sun_ce")
            
            gst.region_set_manager("3k_main_poyang_capital","3k_dlc05_faction_sun_ce")
            gst.region_set_manager("3k_main_poyang_resource_1","3k_dlc05_faction_sun_ce")
            gst.region_set_manager("3k_main_poyang_resource_2","3k_dlc05_faction_sun_ce")
            gst.region_set_manager("3k_main_poyang_resource_3","3k_dlc05_faction_sun_ce")
            
            gst.region_set_manager("3k_main_luling_capital","3k_dlc05_faction_sun_ce")
            gst.region_set_manager("3k_main_luling_resource_1","3k_dlc05_faction_sun_ce")
            
            gst.region_set_manager("3k_main_lingling_capital","3k_dlc05_faction_sun_ce")
            gst.region_set_manager("3k_main_lingling_resource_1","3k_dlc05_faction_sun_ce")
            gst.region_set_manager("3k_main_lingling_resource_2","3k_dlc05_faction_sun_ce")
            gst.region_set_manager("3k_main_lingling_resource_3","3k_dlc05_faction_sun_ce")
            
            gst.region_set_manager("3k_main_cangwu_capital","3k_dlc05_faction_sun_ce")
            gst.region_set_manager("3k_main_cangwu_resource_1","3k_dlc05_faction_sun_ce")
            gst.region_set_manager("3k_main_cangwu_resource_2","3k_dlc05_faction_sun_ce")
            gst.region_set_manager("3k_main_cangwu_resource_3","3k_dlc05_faction_sun_ce")
            
            gst.region_set_manager("3k_main_jiangxia_capital","3k_dlc05_faction_sun_ce")
        end
        if cm:query_faction("3k_main_faction_liu_bei"):is_human() then
            cm:trigger_dilemma("3k_main_faction_liu_bei", "sun_quan_request_jingzhou", true);
        end
        cm:set_saved_value("215_event", true)
    end,
    false
)

core:add_listener(
    "sun_quan_request_jingzhou",
    "DilemmaChoiceMadeEvent",
    function(context) 
        return context:dilemma() == "sun_quan_request_jingzhou"
        and valid_check()
    end,
    function (context)
        local query_faction = context:faction();
        local lu_meng = gst.character_query_for_template("3k_main_template_historical_lu_meng_hero_metal");
        if context:choice() == 0 
        and not lu_meng:is_null_interface()
        and not lu_meng:is_dead() 
        and lu_meng:faction():name() == "3k_dlc05_faction_sun_ce"
        then
            --treaty_components_quit_coalition_and_declare_war
            
            incident = cm:modify_model():create_incident("sun_quan_request_jingzhou_incident");
            incident:add_character_target("target_character_1", lu_meng);
            incident:add_faction_target("target_faction_1", query_faction);
            incident:trigger(cm:modify_faction(query_faction), true);
            
            diplomacy_manager:apply_automatic_deal_between_factions("3k_main_faction_liu_bei", "3k_dlc05_faction_sun_ce", "data_defined_situation_war_proposer_to_recipient")
            
            cm:modify_region("3k_main_changsha_capital"):settlement_gifted_as_if_by_payload(cm:modify_faction("3k_dlc05_faction_sun_ce"));
            cm:modify_region("3k_main_changsha_resource_1"):settlement_gifted_as_if_by_payload(cm:modify_faction("3k_dlc05_faction_sun_ce"));
            cm:modify_region("3k_main_changsha_resource_2"):settlement_gifted_as_if_by_payload(cm:modify_faction("3k_dlc05_faction_sun_ce"));
            cm:modify_region("3k_main_changsha_resource_3"):settlement_gifted_as_if_by_payload(cm:modify_faction("3k_dlc05_faction_sun_ce"));
            
            cm:modify_region("3k_main_lingling_capital"):settlement_gifted_as_if_by_payload(cm:modify_faction("3k_dlc05_faction_sun_ce"));
            cm:modify_region("3k_main_lingling_resource_1"):settlement_gifted_as_if_by_payload(cm:modify_faction("3k_dlc05_faction_sun_ce"));
            cm:modify_region("3k_main_lingling_resource_2"):settlement_gifted_as_if_by_payload(cm:modify_faction("3k_dlc05_faction_sun_ce"));
            
            cm:modify_region("3k_main_cangwu_capital"):settlement_gifted_as_if_by_payload(cm:modify_faction("3k_dlc05_faction_sun_ce"));
            cm:modify_region("3k_main_cangwu_resource_1"):settlement_gifted_as_if_by_payload(cm:modify_faction("3k_dlc05_faction_sun_ce"));
            cm:modify_region("3k_main_cangwu_resource_2"):settlement_gifted_as_if_by_payload(cm:modify_faction("3k_dlc05_faction_sun_ce"));
            cm:modify_region("3k_main_cangwu_resource_3"):settlement_gifted_as_if_by_payload(cm:modify_faction("3k_dlc05_faction_sun_ce"));
            
            cm:modify_region("3k_main_jiangxia_capital"):settlement_gifted_as_if_by_payload(cm:modify_faction("3k_dlc05_faction_sun_ce"));
            
            cm:modify_region("3k_main_yuzhang_capital"):settlement_gifted_as_if_by_payload(cm:modify_faction("3k_dlc05_faction_sun_ce"));
            cm:modify_region("3k_main_yuzhang_resource_1"):settlement_gifted_as_if_by_payload(cm:modify_faction("3k_dlc05_faction_sun_ce"));
            cm:modify_region("3k_main_yuzhang_resource_2"):settlement_gifted_as_if_by_payload(cm:modify_faction("3k_dlc05_faction_sun_ce"));
            cm:modify_region("3k_main_yuzhang_resource_3"):settlement_gifted_as_if_by_payload(cm:modify_faction("3k_dlc05_faction_sun_ce"));
            
            cm:modify_region("3k_main_poyang_capital"):settlement_gifted_as_if_by_payload(cm:modify_faction("3k_dlc05_faction_sun_ce"));
            cm:modify_region("3k_main_poyang_resource_1"):settlement_gifted_as_if_by_payload(cm:modify_faction("3k_dlc05_faction_sun_ce"));
            cm:modify_region("3k_main_poyang_resource_2"):settlement_gifted_as_if_by_payload(cm:modify_faction("3k_dlc05_faction_sun_ce"));
            cm:modify_region("3k_main_poyang_resource_3"):settlement_gifted_as_if_by_payload(cm:modify_faction("3k_dlc05_faction_sun_ce"));
            
            cm:modify_region("3k_main_luling_capital"):settlement_gifted_as_if_by_payload(cm:modify_faction("3k_dlc05_faction_sun_ce"));
            cm:modify_region("3k_main_luling_resource_1"):settlement_gifted_as_if_by_payload(cm:modify_faction("3k_dlc05_faction_sun_ce"));
            --cm:modify_region(cm:query_region("3k_main_lingling_resource_3")):settlement_gifted_as_if_by_payload(cm:modify_faction("3k_dlc05_faction_sun_ce"));
        end
        if context:choice() == 1 then
            cm:modify_region("3k_main_changsha_capital"):settlement_gifted_as_if_by_payload(cm:modify_faction("3k_dlc05_faction_sun_ce"));
            cm:modify_region("3k_main_changsha_resource_1"):settlement_gifted_as_if_by_payload(cm:modify_faction("3k_dlc05_faction_sun_ce"));
            cm:modify_region("3k_main_changsha_resource_2"):settlement_gifted_as_if_by_payload(cm:modify_faction("3k_dlc05_faction_sun_ce"));
            cm:modify_region("3k_main_changsha_resource_3"):settlement_gifted_as_if_by_payload(cm:modify_faction("3k_dlc05_faction_sun_ce"));
            
            cm:modify_region("3k_main_lingling_capital"):settlement_gifted_as_if_by_payload(cm:modify_faction("3k_dlc05_faction_sun_ce"));
            cm:modify_region("3k_main_lingling_resource_1"):settlement_gifted_as_if_by_payload(cm:modify_faction("3k_dlc05_faction_sun_ce"));
            cm:modify_region("3k_main_lingling_resource_2"):settlement_gifted_as_if_by_payload(cm:modify_faction("3k_dlc05_faction_sun_ce"));
            
            cm:modify_region("3k_main_cangwu_capital"):settlement_gifted_as_if_by_payload(cm:modify_faction("3k_dlc05_faction_sun_ce"));
            cm:modify_region("3k_main_cangwu_resource_1"):settlement_gifted_as_if_by_payload(cm:modify_faction("3k_dlc05_faction_sun_ce"));
            cm:modify_region("3k_main_cangwu_resource_2"):settlement_gifted_as_if_by_payload(cm:modify_faction("3k_dlc05_faction_sun_ce"));
            cm:modify_region("3k_main_cangwu_resource_3"):settlement_gifted_as_if_by_payload(cm:modify_faction("3k_dlc05_faction_sun_ce"));
            
            cm:modify_region("3k_main_jiangxia_capital"):settlement_gifted_as_if_by_payload(cm:modify_faction("3k_dlc05_faction_sun_ce"));
            
            cm:modify_region("3k_main_wuling_capital"):settlement_gifted_as_if_by_payload(cm:modify_faction("3k_dlc05_faction_sun_ce"));
            cm:modify_region("3k_main_wuling_resource_1"):settlement_gifted_as_if_by_payload(cm:modify_faction("3k_dlc05_faction_sun_ce"));
            cm:modify_region("3k_main_wuling_resource_2"):settlement_gifted_as_if_by_payload(cm:modify_faction("3k_dlc05_faction_sun_ce"));
            cm:modify_region("3k_main_wuling_resource_3"):settlement_gifted_as_if_by_payload(cm:modify_faction("3k_dlc05_faction_sun_ce"));
            
            cm:modify_region("3k_main_xiangyang_resource_1"):settlement_gifted_as_if_by_payload(cm:modify_faction("3k_dlc05_faction_sun_ce"));
            
            cm:modify_region("3k_main_jingzhou_capital"):settlement_gifted_as_if_by_payload(cm:modify_faction("3k_dlc05_faction_sun_ce"));
            cm:modify_region("3k_main_jingzhou_resource_1"):settlement_gifted_as_if_by_payload(cm:modify_faction("3k_dlc05_faction_sun_ce"));
            
            cm:modify_region("3k_main_yuzhang_capital"):settlement_gifted_as_if_by_payload(cm:modify_faction("3k_dlc05_faction_sun_ce"));
            cm:modify_region("3k_main_yuzhang_resource_1"):settlement_gifted_as_if_by_payload(cm:modify_faction("3k_dlc05_faction_sun_ce"));
            cm:modify_region("3k_main_yuzhang_resource_2"):settlement_gifted_as_if_by_payload(cm:modify_faction("3k_dlc05_faction_sun_ce"));
            cm:modify_region("3k_main_yuzhang_resource_3"):settlement_gifted_as_if_by_payload(cm:modify_faction("3k_dlc05_faction_sun_ce"));
            
            cm:modify_region("3k_main_poyang_capital"):settlement_gifted_as_if_by_payload(cm:modify_faction("3k_dlc05_faction_sun_ce"));
            cm:modify_region("3k_main_poyang_resource_1"):settlement_gifted_as_if_by_payload(cm:modify_faction("3k_dlc05_faction_sun_ce"));
            cm:modify_region("3k_main_poyang_resource_2"):settlement_gifted_as_if_by_payload(cm:modify_faction("3k_dlc05_faction_sun_ce"));
            cm:modify_region("3k_main_poyang_resource_3"):settlement_gifted_as_if_by_payload(cm:modify_faction("3k_dlc05_faction_sun_ce"));
            
            cm:modify_region("3k_main_luling_capital"):settlement_gifted_as_if_by_payload(cm:modify_faction("3k_dlc05_faction_sun_ce"));
            cm:modify_region("3k_main_luling_resource_1"):settlement_gifted_as_if_by_payload(cm:modify_faction("3k_dlc05_faction_sun_ce"));
            --cm:modify_region(cm:query_region("3k_main_lingling_resource_3")):settlement_gifted_as_if_by_payload(cm:modify_faction("3k_dlc05_faction_sun_ce"));
        end
    end,   
    false
)

--209年
core:add_listener(
    "209_event",
    "FactionTurnStart",
    function(context)
        return 
        context:query_model():calendar_year() == 209
        and not cm:query_faction("3k_main_faction_liu_bei"):is_human()
        and cm:query_model():campaign_name() == "3k_dlc07_start_pos"
        and not cm:query_faction("3k_dlc05_faction_sun_ce"):is_dead()
        and not cm:query_faction("3k_main_faction_cao_cao"):is_dead()
        and not cm:query_faction("3k_main_faction_liu_bei"):is_dead()
        and valid_check()
    end,
    function()
        if not cm:query_faction("3k_main_faction_cao_cao"):is_human() then
            gst.region_set_manager("3k_main_nanyang_capital","3k_main_faction_cao_cao")
            gst.region_set_manager("3k_main_nanyang_resource_1","3k_main_faction_cao_cao")
            gst.region_set_manager("3k_main_xiangyang_capital","3k_main_faction_cao_cao")
            gst.region_set_manager("3k_main_jiangxia_resource_1","3k_main_faction_cao_cao")
            
            if cm:query_faction("3k_main_faction_ma_teng"):is_human() then
                gst.region_set_manager("3k_main_wuwei_capital","3k_main_faction_cao_cao")
                gst.region_set_manager("3k_main_wuwei_resource_1","3k_main_faction_cao_cao")
                gst.region_set_manager("3k_main_wuwei_resource_2","3k_main_faction_cao_cao")
                
                gst.region_set_manager("3k_main_jincheng_capital","3k_main_faction_cao_cao")
                gst.region_set_manager("3k_main_jincheng_resource_1","3k_main_faction_cao_cao")
                gst.region_set_manager("3k_main_jincheng_resource_2","3k_main_faction_cao_cao")
                
                gst.region_set_manager("3k_main_anding_capital","3k_main_faction_cao_cao")
                
                local ma_teng = gst.character_query_for_template("3k_main_template_historical_ma_teng_hero_fire");
        
                if not ma_teng:is_character_is_faction_recruitment_pool() and not ma_teng:faction():is_human() then
                    gst.character_been_killed("3k_main_template_historical_ma_teng_hero_fire");
                end 
            end
        end
    end,
    false
)


--214年
core:add_listener(
    "214_event",
    "FactionTurnStart",
    function(context)
        return 
        context:query_model():calendar_year() <= 215
        and context:query_model():calendar_year() >= 213
        and cm:query_model():campaign_name() == "3k_dlc07_start_pos"
        and not cm:query_faction("3k_dlc05_faction_sun_ce"):is_dead()
        and not cm:query_faction("3k_main_faction_cao_cao"):is_dead()
        and not cm:query_faction("3k_main_faction_liu_bei"):is_dead()
        and valid_check()
    end,
    function(context)
        if not cm:get_saved_value("is_trigger_215") then
            cm:set_saved_value("is_trigger_215", true)
        else
            cm:set_saved_value("is_trigger_215", false)
            return;
        end
        if context:faction():name() == "3k_dlc05_faction_sun_ce"
        and not cm:query_faction("3k_dlc05_faction_sun_ce"):is_human() then
            --徐州
            --广陵
            region_set_random_manager("3k_main_guangling_resource_1","3k_dlc05_faction_sun_ce")
            region_set_random_manager("3k_main_guangling_resource_2","3k_dlc05_faction_sun_ce")
        
            --扬州
            --庐江
            region_set_random_manager("3k_main_yangzhou_resource_3","3k_dlc05_faction_sun_ce")
            
            --淮南
            region_set_random_manager("3k_main_lujiang_resource_1","3k_dlc05_faction_sun_ce")
            region_set_random_manager("3k_main_lujiang_resource_2","3k_dlc05_faction_sun_ce")
            
            --鄱阳
            region_set_random_manager("3k_main_poyang_capital","3k_dlc05_faction_sun_ce")
            region_set_random_manager("3k_main_poyang_resource_1","3k_dlc05_faction_sun_ce")
            region_set_random_manager("3k_main_poyang_resource_2","3k_dlc05_faction_sun_ce")
            region_set_random_manager("3k_main_poyang_resource_3","3k_dlc05_faction_sun_ce")
            
            --豫章
            region_set_random_manager("3k_main_yuzhang_capital","3k_dlc05_faction_sun_ce")
            region_set_random_manager("3k_main_yuzhang_resource_1","3k_dlc05_faction_sun_ce")
            region_set_random_manager("3k_main_yuzhang_resource_2","3k_dlc05_faction_sun_ce")
            region_set_random_manager("3k_main_yuzhang_resource_3","3k_dlc05_faction_sun_ce")
            
            --庐陵
            region_set_random_manager("3k_main_luling_capital","3k_dlc05_faction_sun_ce")
            region_set_random_manager("3k_main_luling_resource_1","3k_dlc05_faction_sun_ce")
            
            --丹阳
            region_set_random_manager("3k_main_jianye_capital","3k_dlc05_faction_sun_ce")
            region_set_random_manager("3k_main_jianye_resource_1","3k_dlc05_faction_sun_ce")
            region_set_random_manager("3k_main_jianye_resource_2","3k_dlc05_faction_sun_ce")
            
            --会稽
            region_set_random_manager("3k_main_kuaiji_capital","3k_dlc05_faction_sun_ce")
            region_set_random_manager("3k_main_kuaiji_resource_1","3k_dlc05_faction_sun_ce")
            region_set_random_manager("3k_main_kuaiji_resource_2","3k_dlc05_faction_sun_ce")
            
            --北建安
            region_set_random_manager("3k_main_jianan_capital","3k_dlc05_faction_sun_ce")
            region_set_random_manager("3k_main_jianan_resource_1","3k_dlc05_faction_sun_ce")
            region_set_random_manager("3k_main_jianan_resource_2","3k_dlc05_faction_sun_ce")
            
            --临海
            region_set_random_manager("3k_main_dongou_capital","3k_dlc05_faction_sun_ce")
            region_set_random_manager("3k_main_dongou_resource_1","3k_dlc05_faction_sun_ce")
            
            --南建安
            region_set_random_manager("3k_main_tongan_capital","3k_dlc05_faction_sun_ce")
            region_set_random_manager("3k_main_tongan_resource_1","3k_dlc05_faction_sun_ce")
            
            --交州
            --南海
            region_set_random_manager("3k_main_nanhai_capital","3k_dlc05_faction_sun_ce")
            region_set_random_manager("3k_main_nanhai_resource_1","3k_dlc05_faction_sun_ce")
            region_set_random_manager("3k_main_nanhai_resource_2","3k_dlc05_faction_sun_ce")
            region_set_random_manager("3k_main_nanhai_resource_3","3k_dlc05_faction_sun_ce")
            
            --苍梧
            region_set_random_manager("3k_main_cangwu_capital","3k_dlc05_faction_sun_ce")
            region_set_random_manager("3k_main_cangwu_resource_1","3k_dlc05_faction_sun_ce")
            region_set_random_manager("3k_main_cangwu_resource_2","3k_dlc05_faction_sun_ce")
            
            --高凉
            region_set_random_manager("3k_main_gaoliang_capital","3k_dlc05_faction_sun_ce")
            region_set_random_manager("3k_main_gaoliang_resource_1","3k_dlc05_faction_sun_ce")
        
            --合浦
            region_set_random_manager("3k_main_hepu_capital","3k_dlc05_faction_sun_ce")
            region_set_random_manager("3k_main_hepu_resource_1","3k_dlc05_faction_sun_ce")
            region_set_random_manager("3k_main_hepu_resource_2","3k_dlc05_faction_sun_ce")
            
            --郁林
            region_set_random_manager("3k_main_yulin_capital","3k_dlc05_faction_sun_ce")
            region_set_random_manager("3k_main_yulin_resource_1","3k_dlc05_faction_sun_ce")
            region_set_random_manager("3k_main_yulin_resource_2","3k_dlc05_faction_sun_ce")
            region_set_random_manager("3k_main_cangwu_resource_3","3k_dlc05_faction_sun_ce")
            
            --交趾
            region_set_random_manager("3k_main_jiaozhi_capital","3k_dlc05_faction_sun_ce")
            region_set_random_manager("3k_main_jiaozhi_resource_1","3k_dlc05_faction_sun_ce")
            region_set_random_manager("3k_main_jiaozhi_resource_2","3k_dlc05_faction_sun_ce")
            
            --九真
            region_set_random_manager("3k_dlc06_jiuzhen_capital","3k_dlc05_faction_sun_ce")
            region_set_random_manager("3k_dlc06_jiuzhen_resource_1","3k_dlc05_faction_sun_ce")
        end
        
        if context:faction():name() == "3k_main_faction_cao_cao"
        and not cm:query_faction("3k_main_faction_cao_cao"):is_human() 
        then
            --司隶
            --长安
            region_set_random_manager("3k_main_changan_capital","3k_main_faction_cao_cao")
            region_set_random_manager("3k_main_changan_resource_1","3k_main_faction_cao_cao")
            
            --河东
            region_set_random_manager("3k_main_hedong_capital","3k_main_faction_cao_cao")
            region_set_random_manager("3k_main_hedong_resource_1","3k_main_faction_cao_cao")
            region_set_random_manager("3k_dlc06_hedong_resource_2","3k_main_faction_cao_cao")
            
            --洛阳
            region_set_random_manager("3k_main_luoyang_capital","3k_main_faction_cao_cao")
            region_set_random_manager("3k_main_luoyang_resource_1","3k_main_faction_cao_cao")
            region_set_random_manager("3k_main_chenjun_resource_3","3k_main_faction_cao_cao")
            
            --散关
            region_set_random_manager("3k_dlc06_san_pass","3k_main_faction_cao_cao")
            
            --潼关
            region_set_random_manager("3k_dlc06_tong_pass","3k_main_faction_cao_cao")
            
            --武关
            region_set_random_manager("3k_dlc06_wu_pass","3k_main_faction_cao_cao")
            
            --函谷关
            region_set_random_manager("3k_dlc06_hangu_pass","3k_main_faction_cao_cao")
            
            --虎牢关
            region_set_random_manager("3k_dlc06_hulao_pass","3k_main_faction_cao_cao")
            
            --葭萌关
            region_set_random_manager("3k_dlc06_jiameng_pass","3k_main_faction_cao_cao")
            
            --濝关
            region_set_random_manager("3k_dlc06_qi_pass","3k_main_faction_cao_cao")
            
            --凉州
            --武威
            region_set_random_manager("3k_main_wuwei_capital","3k_main_faction_cao_cao")
            region_set_random_manager("3k_main_wuwei_resource_1","3k_main_faction_cao_cao")
            region_set_random_manager("3k_main_wuwei_resource_2","3k_main_faction_cao_cao")
            
            --金城
            region_set_random_manager("3k_main_jincheng_capital","3k_main_faction_cao_cao")
            region_set_random_manager("3k_main_jincheng_resource_1","3k_main_faction_cao_cao")
            region_set_random_manager("3k_main_jincheng_resource_2","3k_main_faction_cao_cao")
            
            --安定
            region_set_random_manager("3k_main_anding_capital","3k_main_faction_cao_cao")
            
            --武都
            region_set_random_manager("3k_main_wudu_capital","3k_main_faction_cao_cao")
            region_set_random_manager("3k_main_wudu_resource_1","3k_main_faction_cao_cao")
            region_set_random_manager("3k_main_wudu_resource_2","3k_main_faction_cao_cao")
            
            --武都
            region_set_random_manager("3k_main_wudu_capital","3k_main_faction_cao_cao")
            region_set_random_manager("3k_main_wudu_resource_1","3k_main_faction_cao_cao")
            region_set_random_manager("3k_main_wudu_resource_2","3k_main_faction_cao_cao")
            
            --并州
            --太原
            region_set_random_manager("3k_main_taiyuan_capital","3k_main_faction_cao_cao")
            region_set_random_manager("3k_main_taiyuan_resource_1","3k_main_faction_cao_cao")
            region_set_random_manager("3k_main_taiyuan_resource_2","3k_main_faction_cao_cao")
            
            --故关
            region_set_random_manager("3k_dlc06_gu_pass","3k_main_faction_cao_cao")
            
            --雁门
            region_set_random_manager("3k_main_yanmen_capital","3k_main_faction_cao_cao")
            region_set_random_manager("3k_main_yanmen_resource_1","3k_main_faction_cao_cao")
            
            --上党
            region_set_random_manager("3k_main_shangdang_capital","3k_main_faction_cao_cao")
            region_set_random_manager("3k_main_shangdang_resource_1","3k_main_faction_cao_cao")
            region_set_random_manager("3k_dlc06_shangdang_resource_2","3k_main_faction_cao_cao")
            
            --冀州
            --中山
            region_set_random_manager("3k_main_zhongshan_capital","3k_main_faction_cao_cao")
            region_set_random_manager("3k_main_zhongshan_resource_1","3k_main_faction_cao_cao")
            
            --安平
            region_set_random_manager("3k_main_anping_capital","3k_main_faction_cao_cao")
            region_set_random_manager("3k_main_anping_resource_1","3k_main_faction_cao_cao")
            
            --魏郡
            region_set_random_manager("3k_main_weijun_capital","3k_main_faction_cao_cao")
            region_set_random_manager("3k_main_weijun_resource_1","3k_main_faction_cao_cao")
            
            --河内
            region_set_random_manager("3k_main_henei_capital","3k_main_faction_cao_cao")
            region_set_random_manager("3k_main_henei_resource_1","3k_main_faction_cao_cao")
            
            --渤海
            region_set_random_manager("3k_main_bohai_capital","3k_main_faction_cao_cao")
            region_set_random_manager("3k_main_bohai_resource_1","3k_main_faction_cao_cao")
            
            --幽州
            --代郡
            region_set_random_manager("3k_main_daijun_capital","3k_main_faction_cao_cao")
            region_set_random_manager("3k_main_daijun_resource_1","3k_main_faction_cao_cao")
            
            --广阳
            region_set_random_manager("3k_main_youzhou_capital","3k_main_faction_cao_cao")
            region_set_random_manager("3k_main_youzhou_resource_1","3k_main_faction_cao_cao")
            
            --右北平
            region_set_random_manager("3k_main_youbeiping_capital","3k_main_faction_cao_cao")
            region_set_random_manager("3k_main_youbeiping_resource_1","3k_main_faction_cao_cao")
            
            --辽西
            region_set_random_manager("3k_main_yu_capital","3k_main_faction_cao_cao")
            region_set_random_manager("3k_main_yu_resource_1","3k_main_faction_cao_cao")
            
            --青州
            --平原
            region_set_random_manager("3k_main_pingyuan_capital","3k_main_faction_cao_cao")
            region_set_random_manager("3k_main_pingyuan_resource_1","3k_main_faction_cao_cao")
            
            --乐安
            region_set_random_manager("3k_main_taishan_capital","3k_main_faction_cao_cao")
            region_set_random_manager("3k_main_taishan_resource_1","3k_main_faction_cao_cao")
            
            --北海
            region_set_random_manager("3k_main_beihai_capital","3k_main_faction_cao_cao")
            region_set_random_manager("3k_main_beihai_resource_1","3k_main_faction_cao_cao")
            
            --东莱
            region_set_random_manager("3k_main_donglai_capital","3k_main_faction_cao_cao")
            region_set_random_manager("3k_main_donglai_resource_1","3k_main_faction_cao_cao")
            
            --兖州
            --东郡
            region_set_random_manager("3k_main_dongjun_capital","3k_main_faction_cao_cao")
            region_set_random_manager("3k_main_dongjun_resource_1","3k_main_faction_cao_cao")
            
            --颍川
            region_set_random_manager("3k_main_yingchuan_capital","3k_main_faction_cao_cao")
            region_set_random_manager("3k_main_yingchuan_resource_1","3k_main_faction_cao_cao")
            
            --徐州
            --彭城
            region_set_random_manager("3k_main_penchang_capital","3k_main_faction_cao_cao")
            region_set_random_manager("3k_main_penchang_resource_1","3k_main_faction_cao_cao")
            region_set_random_manager("3k_main_penchang_resource_2","3k_main_faction_cao_cao")
            
            --下邳
            region_set_random_manager("3k_dlc06_xiapi_capital","3k_main_faction_cao_cao")
            region_set_random_manager("3k_dlc06_xiapi_resource_1","3k_main_faction_cao_cao")
            
            --琅琊
            region_set_random_manager("3k_main_langye_capital","3k_main_faction_cao_cao")
            region_set_random_manager("3k_main_langye_resource_1","3k_main_faction_cao_cao")
            region_set_random_manager("3k_main_langye_resource_2","3k_main_faction_cao_cao")
            
            --东海
            region_set_random_manager("3k_main_donghai_capital","3k_main_faction_cao_cao")
            region_set_random_manager("3k_main_donghai_resource_1","3k_main_faction_cao_cao")
            
            --广陵
            region_set_random_manager("3k_main_guangling_capital","3k_main_faction_cao_cao")
            
            --豫州
            --陈郡
            region_set_random_manager("3k_main_chenjun_capital","3k_main_faction_cao_cao")
            region_set_random_manager("3k_main_chenjun_resource_1","3k_main_faction_cao_cao")
            region_set_random_manager("3k_main_chenjun_resource_2","3k_main_faction_cao_cao")
            
            --汝南
            region_set_random_manager("3k_main_runan_capital","3k_main_faction_cao_cao")
            region_set_random_manager("3k_main_runan_resource_1","3k_main_faction_cao_cao")
            
            --荆州
            --南阳
            region_set_random_manager("3k_main_nanyang_capital","3k_main_faction_cao_cao")
            region_set_random_manager("3k_main_nanyang_resource_1","3k_main_faction_cao_cao")
            
            --襄阳
            region_set_random_manager("3k_main_xiangyang_capital","3k_main_faction_cao_cao")
            
            --江夏
            region_set_random_manager("3k_main_jiangxia_resource_1","3k_main_faction_cao_cao")
            
            --扬州
            --庐江
            region_set_random_manager("3k_main_lujiang_capital","3k_main_faction_cao_cao")
            
            --淮南
            region_set_random_manager("3k_main_yangzhou_capital","3k_main_faction_cao_cao")
            region_set_random_manager("3k_main_yangzhou_resource_1","3k_main_faction_cao_cao")
            region_set_random_manager("3k_main_yangzhou_resource_2","3k_main_faction_cao_cao")
            
        end
        
        if context:faction():name() == "3k_main_faction_liu_bei"
        and not cm:query_faction("3k_main_faction_liu_bei"):is_human()then
            
            --荆州
            --长沙
            region_set_random_manager("3k_main_changsha_capital","3k_main_faction_liu_bei")
            region_set_random_manager("3k_main_changsha_resource_1","3k_main_faction_liu_bei")
            region_set_random_manager("3k_main_changsha_resource_2","3k_main_faction_liu_bei")
            region_set_random_manager("3k_main_changsha_resource_3","3k_main_faction_liu_bei")
            
            --零陵
            region_set_random_manager("3k_main_lingling_capital","3k_main_faction_liu_bei")
            region_set_random_manager("3k_main_lingling_resource_1","3k_main_faction_liu_bei")
            region_set_random_manager("3k_main_lingling_resource_2","3k_main_faction_liu_bei")
            region_set_random_manager("3k_main_lingling_resource_3","3k_main_faction_liu_bei")
            
            --江夏
            region_set_random_manager("3k_main_jiangxia_capital","3k_main_faction_liu_bei")
            
            --襄阳
            region_set_random_manager("3k_main_xiangyang_resource_1","3k_main_faction_liu_bei")
            
            --南郡
            region_set_random_manager("3k_main_jingzhou_capital","3k_main_faction_liu_bei")
            region_set_random_manager("3k_main_jingzhou_resource_1","3k_main_faction_liu_bei")
            
            --武陵
            region_set_random_manager("3k_main_wuling_capital","3k_main_faction_liu_bei")
            region_set_random_manager("3k_main_wuling_resource_1","3k_main_faction_liu_bei")
            region_set_random_manager("3k_main_wuling_resource_2","3k_main_faction_liu_bei")
            region_set_random_manager("3k_main_wuling_resource_3","3k_main_faction_liu_bei")
            
            --交州
            --交趾
            region_set_random_manager("3k_dlc06_jiaozhi_resource_3","3k_main_faction_liu_bei")
            
            --益州
            --巴东
            region_set_random_manager("3k_main_badong_capital","3k_main_faction_liu_bei")
            region_set_random_manager("3k_main_badong_resource_1","3k_main_faction_liu_bei")
            region_set_random_manager("3k_main_badong_resource_2","3k_main_faction_liu_bei")
            
            --上庸
            region_set_random_manager("3k_main_shangyong_capital","3k_main_faction_liu_bei")
            region_set_random_manager("3k_main_shangyong_resource_1","3k_main_faction_liu_bei")
            region_set_random_manager("3k_main_shangyong_resource_2","3k_main_faction_liu_bei")
            
            --涪陵
            region_set_random_manager("3k_main_fuling_capital","3k_main_faction_liu_bei")
            region_set_random_manager("3k_main_fuling_resource_1","3k_main_faction_liu_bei")
            
            --巴郡
            region_set_random_manager("3k_main_bajun_capital","3k_main_faction_liu_bei")
            region_set_random_manager("3k_main_bajun_resource_1","3k_main_faction_liu_bei")
            
            --蜀郡
            region_set_random_manager("3k_main_chengdu_capital","3k_main_faction_liu_bei")
            region_set_random_manager("3k_main_chengdu_resource_1","3k_main_faction_liu_bei")
            region_set_random_manager("3k_main_chengdu_resource_2","3k_main_faction_liu_bei")
            region_set_random_manager("3k_main_chengdu_resource_3","3k_main_faction_liu_bei")
            
            --江阳
            region_set_random_manager("3k_main_jiangyang_capital","3k_main_faction_liu_bei")
            region_set_random_manager("3k_main_jiangyang_resource_1","3k_main_faction_liu_bei")
            region_set_random_manager("3k_main_jiangyang_resource_2","3k_main_faction_liu_bei")
            region_set_random_manager("3k_main_jiangyang_resource_3","3k_main_faction_liu_bei")
            
            --永昌
            region_set_random_manager("3k_dlc06_yongchang_capital","3k_main_faction_liu_bei")
            region_set_random_manager("3k_dlc06_yongchang_resource_1","3k_main_faction_liu_bei")
            
            --牂牁
            region_set_random_manager("3k_main_zangke_capital","3k_main_faction_liu_bei")
            region_set_random_manager("3k_main_zangke_resource_1","3k_main_faction_liu_bei")
            region_set_random_manager("3k_main_zangke_resource_2","3k_main_faction_liu_bei")
            
            --云南
            region_set_random_manager("3k_dlc06_yunnan_capital","3k_main_faction_liu_bei")
            region_set_random_manager("3k_dlc06_yunnan_resource_1","3k_main_faction_liu_bei")
            region_set_random_manager("3k_dlc06_yunnan_resource_2","3k_main_faction_liu_bei")
            
            --建宁
            region_set_random_manager("3k_main_jianning_capital","3k_main_faction_liu_bei")
            region_set_random_manager("3k_main_jianning_resource_1","3k_main_faction_liu_bei")
            region_set_random_manager("3k_main_jianning_resource_2","3k_main_faction_liu_bei")
            region_set_random_manager("3k_dlc06_jianning_resource_3","3k_main_faction_liu_bei")
            
            --巴西
            region_set_random_manager("3k_main_baxi_capital","3k_main_faction_liu_bei")
            region_set_random_manager("3k_main_baxi_resource_1","3k_main_faction_liu_bei")
            region_set_random_manager("3k_main_baxi_resource_2","3k_main_faction_liu_bei")
            
            --夔关
            region_set_random_manager("3k_dlc06_kui_pass","3k_main_faction_liu_bei")
        end
    end,
    true
)

--205年
core:add_listener(
    "205_event",
    "FactionTurnStart",
    function(context)
        return 
        context:query_model():calendar_year() == 205
        and cm:query_model():campaign_name() == "3k_dlc07_start_pos"
        and not cm:query_faction("3k_dlc05_faction_sun_ce"):is_dead()
        and not cm:query_faction("3k_main_faction_cao_cao"):is_dead()
        and not cm:query_faction("3k_main_faction_liu_bei"):is_dead()
        and valid_check()
    end,
    function()
        if not cm:query_faction("3k_dlc05_faction_sun_ce"):is_human() then
            gst.region_set_manager("3k_main_kuaiji_capital","3k_dlc05_faction_sun_ce")
            gst.region_set_manager("3k_main_kuaiji_resource_1","3k_dlc05_faction_sun_ce")
            gst.region_set_manager("3k_main_kuaiji_resource_2","3k_dlc05_faction_sun_ce")
            gst.region_set_manager("3k_main_jianan_capital","3k_dlc05_faction_sun_ce")
            gst.region_set_manager("3k_main_jianan_resource_1","3k_dlc05_faction_sun_ce")
            gst.region_set_manager("3k_main_jianan_resource_2","3k_dlc05_faction_sun_ce")
        end
    end,
    false
)
--218年 刘备打下汉中
core:add_listener(
    "218_event",
    "FactionTurnStart",
    function(context)
        return 
        context:query_model():calendar_year() >= 216
        and context:query_model():calendar_year() <= 218
        and cm:query_model():campaign_name() == "3k_dlc07_start_pos"
        --and not cm:get_saved_value("is_trigger_218")
        and not cm:query_faction("3k_dlc05_faction_sun_ce"):is_dead()
        and not cm:query_faction("3k_main_faction_cao_cao"):is_dead()
        and not cm:query_faction("3k_main_faction_liu_bei"):is_dead()
        and valid_check()
    end,
    function(context)
        if not cm:get_saved_value("is_trigger_218") then
            cm:set_saved_value("is_trigger_218", true)
        else
            cm:set_saved_value("is_trigger_218", false)
            return;
        end
        if context:faction():name() == "3k_dlc05_faction_sun_ce"
        and not cm:query_faction("3k_dlc05_faction_sun_ce"):is_human() 
        then
            --徐州
            --广陵
            region_set_random_manager("3k_main_guangling_resource_1","3k_dlc05_faction_sun_ce")
            region_set_random_manager("3k_main_guangling_resource_2","3k_dlc05_faction_sun_ce")
        
            --扬州
            --庐江
            region_set_random_manager("3k_main_yangzhou_resource_3","3k_dlc05_faction_sun_ce")
            
            --淮南
            region_set_random_manager("3k_main_lujiang_resource_1","3k_dlc05_faction_sun_ce")
            region_set_random_manager("3k_main_lujiang_resource_2","3k_dlc05_faction_sun_ce")
            
            --鄱阳
            region_set_random_manager("3k_main_poyang_capital","3k_dlc05_faction_sun_ce")
            region_set_random_manager("3k_main_poyang_resource_1","3k_dlc05_faction_sun_ce")
            region_set_random_manager("3k_main_poyang_resource_2","3k_dlc05_faction_sun_ce")
            region_set_random_manager("3k_main_poyang_resource_3","3k_dlc05_faction_sun_ce")
            
            --豫章
            region_set_random_manager("3k_main_yuzhang_capital","3k_dlc05_faction_sun_ce")
            region_set_random_manager("3k_main_yuzhang_resource_1","3k_dlc05_faction_sun_ce")
            region_set_random_manager("3k_main_yuzhang_resource_2","3k_dlc05_faction_sun_ce")
            region_set_random_manager("3k_main_yuzhang_resource_3","3k_dlc05_faction_sun_ce")
            
            --庐陵
            region_set_random_manager("3k_main_luling_capital","3k_dlc05_faction_sun_ce")
            region_set_random_manager("3k_main_luling_resource_1","3k_dlc05_faction_sun_ce")
            
            --丹阳
            region_set_random_manager("3k_main_jianye_capital","3k_dlc05_faction_sun_ce")
            region_set_random_manager("3k_main_jianye_resource_1","3k_dlc05_faction_sun_ce")
            region_set_random_manager("3k_main_jianye_resource_2","3k_dlc05_faction_sun_ce")
            
            --会稽
            region_set_random_manager("3k_main_kuaiji_capital","3k_dlc05_faction_sun_ce")
            region_set_random_manager("3k_main_kuaiji_resource_1","3k_dlc05_faction_sun_ce")
            region_set_random_manager("3k_main_kuaiji_resource_2","3k_dlc05_faction_sun_ce")
            
            --北建安
            region_set_random_manager("3k_main_jianan_capital","3k_dlc05_faction_sun_ce")
            region_set_random_manager("3k_main_jianan_resource_1","3k_dlc05_faction_sun_ce")
            region_set_random_manager("3k_main_jianan_resource_2","3k_dlc05_faction_sun_ce")
            
            --临海
            region_set_random_manager("3k_main_dongou_capital","3k_dlc05_faction_sun_ce")
            region_set_random_manager("3k_main_dongou_resource_1","3k_dlc05_faction_sun_ce")
            
            --南建安
            region_set_random_manager("3k_main_tongan_capital","3k_dlc05_faction_sun_ce")
            region_set_random_manager("3k_main_tongan_resource_1","3k_dlc05_faction_sun_ce")
            
            --交州
            --南海
            region_set_random_manager("3k_main_nanhai_capital","3k_dlc05_faction_sun_ce")
            region_set_random_manager("3k_main_nanhai_resource_1","3k_dlc05_faction_sun_ce")
            region_set_random_manager("3k_main_nanhai_resource_2","3k_dlc05_faction_sun_ce")
            region_set_random_manager("3k_main_nanhai_resource_3","3k_dlc05_faction_sun_ce")
            
            --苍梧
            region_set_random_manager("3k_main_cangwu_capital","3k_dlc05_faction_sun_ce")
            region_set_random_manager("3k_main_cangwu_resource_1","3k_dlc05_faction_sun_ce")
            region_set_random_manager("3k_main_cangwu_resource_2","3k_dlc05_faction_sun_ce")
            
            --高凉
            region_set_random_manager("3k_main_gaoliang_capital","3k_dlc05_faction_sun_ce")
            region_set_random_manager("3k_main_gaoliang_resource_1","3k_dlc05_faction_sun_ce")
        
            --合浦
            region_set_random_manager("3k_main_hepu_capital","3k_dlc05_faction_sun_ce")
            region_set_random_manager("3k_main_hepu_resource_1","3k_dlc05_faction_sun_ce")
            region_set_random_manager("3k_main_hepu_resource_2","3k_dlc05_faction_sun_ce")
            
            --郁林
            region_set_random_manager("3k_main_yulin_capital","3k_dlc05_faction_sun_ce")
            region_set_random_manager("3k_main_yulin_resource_1","3k_dlc05_faction_sun_ce")
            region_set_random_manager("3k_main_yulin_resource_2","3k_dlc05_faction_sun_ce")
            region_set_random_manager("3k_main_cangwu_resource_3","3k_dlc05_faction_sun_ce")
            
            --交趾
            region_set_random_manager("3k_main_jiaozhi_capital","3k_dlc05_faction_sun_ce")
            region_set_random_manager("3k_main_jiaozhi_resource_1","3k_dlc05_faction_sun_ce")
            region_set_random_manager("3k_main_jiaozhi_resource_2","3k_dlc05_faction_sun_ce")
            
            --九真
            region_set_random_manager("3k_dlc06_jiuzhen_capital","3k_dlc05_faction_sun_ce")
            region_set_random_manager("3k_dlc06_jiuzhen_resource_1","3k_dlc05_faction_sun_ce")
            
            --荆州
            --长沙
            region_set_random_manager("3k_main_changsha_capital","3k_dlc05_faction_sun_ce")
            region_set_random_manager("3k_main_changsha_resource_1","3k_dlc05_faction_sun_ce")
            region_set_random_manager("3k_main_changsha_resource_2","3k_dlc05_faction_sun_ce")
            region_set_random_manager("3k_main_changsha_resource_3","3k_dlc05_faction_sun_ce")
            
            --零陵
            region_set_random_manager("3k_main_lingling_capital","3k_dlc05_faction_sun_ce")
            region_set_random_manager("3k_main_lingling_resource_1","3k_dlc05_faction_sun_ce")
            region_set_random_manager("3k_main_lingling_resource_2","3k_dlc05_faction_sun_ce")
            region_set_random_manager("3k_main_lingling_resource_3","3k_dlc05_faction_sun_ce")
            
            --庐陵
            region_set_random_manager("3k_main_luling_capital","3k_dlc05_faction_sun_ce")
            region_set_random_manager("3k_main_luling_resource_1","3k_dlc05_faction_sun_ce")
            
            --江夏
            region_set_random_manager("3k_main_jiangxia_capital","3k_dlc05_faction_sun_ce")
            
        end
        if context:faction():name() == "3k_main_faction_cao_cao"
        and not cm:query_faction("3k_main_faction_cao_cao"):is_human() 
        then
            --司隶
            --长安
            region_set_random_manager("3k_main_changan_capital","3k_main_faction_cao_cao")
            region_set_random_manager("3k_main_changan_resource_1","3k_main_faction_cao_cao")
            
            --河东
            region_set_random_manager("3k_main_hedong_capital","3k_main_faction_cao_cao")
            region_set_random_manager("3k_main_hedong_resource_1","3k_main_faction_cao_cao")
            region_set_random_manager("3k_dlc06_hedong_resource_2","3k_main_faction_cao_cao")
            
            --洛阳
            region_set_random_manager("3k_main_luoyang_capital","3k_main_faction_cao_cao")
            region_set_random_manager("3k_main_luoyang_resource_1","3k_main_faction_cao_cao")
            region_set_random_manager("3k_main_chenjun_resource_3","3k_main_faction_cao_cao")
            
            --散关
            region_set_random_manager("3k_dlc06_san_pass","3k_main_faction_cao_cao")
            
            --潼关
            region_set_random_manager("3k_dlc06_tong_pass","3k_main_faction_cao_cao")
            
            --武关
            region_set_random_manager("3k_dlc06_wu_pass","3k_main_faction_cao_cao")
            
            --函谷关
            region_set_random_manager("3k_dlc06_hangu_pass","3k_main_faction_cao_cao")
            
            --虎牢关
            region_set_random_manager("3k_dlc06_hulao_pass","3k_main_faction_cao_cao")
            
            --葭萌关
            region_set_random_manager("3k_dlc06_jiameng_pass","3k_main_faction_cao_cao")
            
            --濝关
            region_set_random_manager("3k_dlc06_qi_pass","3k_main_faction_cao_cao")
            
            --凉州
            --武威
            region_set_random_manager("3k_main_wuwei_capital","3k_main_faction_cao_cao")
            region_set_random_manager("3k_main_wuwei_resource_1","3k_main_faction_cao_cao")
            region_set_random_manager("3k_main_wuwei_resource_2","3k_main_faction_cao_cao")
            
            --金城
            region_set_random_manager("3k_main_jincheng_capital","3k_main_faction_cao_cao")
            region_set_random_manager("3k_main_jincheng_resource_1","3k_main_faction_cao_cao")
            region_set_random_manager("3k_main_jincheng_resource_2","3k_main_faction_cao_cao")
            
            --安定
            region_set_random_manager("3k_main_anding_capital","3k_main_faction_cao_cao")
            region_set_random_manager("3k_main_anding_resource_1","xyyhlyja")--（羌胡占）
            region_set_random_manager("3k_main_anding_resource_2","xyyhlyja")--（羌胡占）
            region_set_random_manager("3k_main_anding_resource_3","xyyhlyja")--（羌胡占）
            
            --武都
            region_set_random_manager("3k_main_wudu_capital","3k_main_faction_cao_cao")
            region_set_random_manager("3k_main_wudu_resource_1","3k_main_faction_cao_cao")
            region_set_random_manager("3k_main_wudu_resource_2","3k_main_faction_cao_cao")
            
            --武都
            region_set_random_manager("3k_main_wudu_capital","3k_main_faction_cao_cao")
            region_set_random_manager("3k_main_wudu_resource_1","3k_main_faction_cao_cao")
            region_set_random_manager("3k_main_wudu_resource_2","3k_main_faction_cao_cao")
            
            --并州
            --朔方（羌胡占）
            region_set_random_manager("3k_main_shoufang_capital","xyyhlyja")
            region_set_random_manager("3k_main_shoufang_resource_1","xyyhlyja")
            region_set_random_manager("3k_main_shoufang_resource_2","xyyhlyja")
            region_set_random_manager("3k_main_shoufang_resource_3","xyyhlyja")
            
            --西河（羌胡占）
            region_set_random_manager("3k_main_xihe_capital","xyyhlyja")
            region_set_random_manager("3k_main_xihe_resource_1","xyyhlyja")
            
            --太原
            region_set_random_manager("3k_main_taiyuan_capital","3k_main_faction_cao_cao")
            region_set_random_manager("3k_main_taiyuan_resource_1","3k_main_faction_cao_cao")
            region_set_random_manager("3k_main_taiyuan_resource_2","3k_main_faction_cao_cao")
            
            --故关
            region_set_random_manager("3k_dlc06_gu_pass","3k_main_faction_cao_cao")
            
            --雁门
            region_set_random_manager("3k_main_yanmen_capital","3k_main_faction_cao_cao")
            region_set_random_manager("3k_main_yanmen_resource_1","3k_main_faction_cao_cao")
            
            --上党
            region_set_random_manager("3k_main_shangdang_capital","3k_main_faction_cao_cao")
            region_set_random_manager("3k_main_shangdang_resource_1","3k_main_faction_cao_cao")
            region_set_random_manager("3k_dlc06_shangdang_resource_2","3k_main_faction_cao_cao")
            
            --冀州
            --中山
            region_set_random_manager("3k_main_zhongshan_capital","3k_main_faction_cao_cao")
            region_set_random_manager("3k_main_zhongshan_resource_1","3k_main_faction_cao_cao")
            
            --安平
            region_set_random_manager("3k_main_anping_capital","3k_main_faction_cao_cao")
            region_set_random_manager("3k_main_anping_resource_1","3k_main_faction_cao_cao")
            
            --魏郡
            region_set_random_manager("3k_main_weijun_capital","3k_main_faction_cao_cao")
            region_set_random_manager("3k_main_weijun_resource_1","3k_main_faction_cao_cao")
            
            --河内
            region_set_random_manager("3k_main_henei_capital","3k_main_faction_cao_cao")
            region_set_random_manager("3k_main_henei_resource_1","3k_main_faction_cao_cao")
            
            --渤海
            region_set_random_manager("3k_main_bohai_capital","3k_main_faction_cao_cao")
            region_set_random_manager("3k_main_bohai_resource_1","3k_main_faction_cao_cao")
            
            --幽州
            --代郡
            region_set_random_manager("3k_main_daijun_capital","3k_main_faction_cao_cao")
            region_set_random_manager("3k_main_daijun_resource_1","3k_main_faction_cao_cao")
            
            --广阳
            region_set_random_manager("3k_main_youzhou_capital","3k_main_faction_cao_cao")
            region_set_random_manager("3k_main_youzhou_resource_1","3k_main_faction_cao_cao")
            
            --右北平
            region_set_random_manager("3k_main_youbeiping_capital","3k_main_faction_cao_cao")
            region_set_random_manager("3k_main_youbeiping_resource_1","3k_main_faction_cao_cao")
            
            --辽西
            region_set_random_manager("3k_main_yu_capital","3k_main_faction_cao_cao")
            region_set_random_manager("3k_main_yu_resource_1","3k_main_faction_cao_cao")
            
            --青州
            --平原
            region_set_random_manager("3k_main_pingyuan_capital","3k_main_faction_cao_cao")
            region_set_random_manager("3k_main_pingyuan_resource_1","3k_main_faction_cao_cao")
            
            --乐安
            region_set_random_manager("3k_main_taishan_capital","3k_main_faction_cao_cao")
            region_set_random_manager("3k_main_taishan_resource_1","3k_main_faction_cao_cao")
            
            --北海
            region_set_random_manager("3k_main_beihai_capital","3k_main_faction_cao_cao")
            region_set_random_manager("3k_main_beihai_resource_1","3k_main_faction_cao_cao")
            
            --东莱
            region_set_random_manager("3k_main_donglai_capital","3k_main_faction_cao_cao")
            region_set_random_manager("3k_main_donglai_resource_1","3k_main_faction_cao_cao")
            
            --兖州
            --东郡
            region_set_random_manager("3k_main_dongjun_capital","3k_main_faction_cao_cao")
            region_set_random_manager("3k_main_dongjun_resource_1","3k_main_faction_cao_cao")
            
            --颍川
            region_set_random_manager("3k_main_yingchuan_capital","3k_main_faction_cao_cao")
            region_set_random_manager("3k_main_yingchuan_resource_1","3k_main_faction_cao_cao")
            
            --徐州
            --彭城
            region_set_random_manager("3k_main_penchang_capital","3k_main_faction_cao_cao")
            region_set_random_manager("3k_main_penchang_resource_1","3k_main_faction_cao_cao")
            region_set_random_manager("3k_main_penchang_resource_2","3k_main_faction_cao_cao")
            
            --下邳
            region_set_random_manager("3k_dlc06_xiapi_capital","3k_main_faction_cao_cao")
            region_set_random_manager("3k_dlc06_xiapi_resource_1","3k_main_faction_cao_cao")
            
            --琅琊
            region_set_random_manager("3k_main_langye_capital","3k_main_faction_cao_cao")
            region_set_random_manager("3k_main_langye_resource_1","3k_main_faction_cao_cao")
            region_set_random_manager("3k_main_langye_resource_2","3k_main_faction_cao_cao")
            
            --东海
            region_set_random_manager("3k_main_donghai_capital","3k_main_faction_cao_cao")
            region_set_random_manager("3k_main_donghai_resource_1","3k_main_faction_cao_cao")
            
            --广陵
            region_set_random_manager("3k_main_guangling_capital","3k_main_faction_cao_cao")
            
            --豫州
            --陈郡
            region_set_random_manager("3k_main_chenjun_capital","3k_main_faction_cao_cao")
            region_set_random_manager("3k_main_chenjun_resource_1","3k_main_faction_cao_cao")
            region_set_random_manager("3k_main_chenjun_resource_2","3k_main_faction_cao_cao")
            
            --汝南
            region_set_random_manager("3k_main_runan_capital","3k_main_faction_cao_cao")
            region_set_random_manager("3k_main_runan_resource_1","3k_main_faction_cao_cao")
            
            --荆州
            --南阳
            region_set_random_manager("3k_main_nanyang_capital","3k_main_faction_cao_cao")
            region_set_random_manager("3k_main_nanyang_resource_1","3k_main_faction_cao_cao")
            
            --襄阳
            region_set_random_manager("3k_main_xiangyang_capital","3k_main_faction_cao_cao")
            
            --江夏
            region_set_random_manager("3k_main_jiangxia_resource_1","3k_main_faction_cao_cao")
            
            --扬州
            --庐江
            region_set_random_manager("3k_main_lujiang_capital","3k_main_faction_cao_cao")
            
            --淮南
            region_set_random_manager("3k_main_yangzhou_capital","3k_main_faction_cao_cao")
            region_set_random_manager("3k_main_yangzhou_resource_1","3k_main_faction_cao_cao")
            region_set_random_manager("3k_main_yangzhou_resource_2","3k_main_faction_cao_cao")
            
        end
        if context:faction():name() == "3k_main_faction_liu_bei"
        and not cm:query_faction("3k_main_faction_liu_bei"):is_human()then
            --汉中
            region_set_random_manager("3k_main_hanzhong_capital","3k_main_faction_liu_bei")
            
            --荆州
            --襄阳
            region_set_random_manager("3k_main_xiangyang_resource_1","3k_main_faction_liu_bei")
            
            --南郡
            region_set_random_manager("3k_main_jingzhou_capital","3k_main_faction_liu_bei")
            region_set_random_manager("3k_main_jingzhou_resource_1","3k_main_faction_liu_bei")
            
            --武陵
            region_set_random_manager("3k_main_wuling_capital","3k_main_faction_liu_bei")
            region_set_random_manager("3k_main_wuling_resource_1","3k_main_faction_liu_bei")
            region_set_random_manager("3k_main_wuling_resource_2","3k_main_faction_liu_bei")
            region_set_random_manager("3k_main_wuling_resource_3","3k_main_faction_liu_bei")
            
            --交州
            --交趾
            region_set_random_manager("3k_dlc06_jiaozhi_resource_3","3k_main_faction_liu_bei")
            
            --益州
            --巴东
            region_set_random_manager("3k_main_badong_capital","3k_main_faction_liu_bei")
            region_set_random_manager("3k_main_badong_resource_1","3k_main_faction_liu_bei")
            region_set_random_manager("3k_main_badong_resource_2","3k_main_faction_liu_bei")
            
            --上庸
            region_set_random_manager("3k_main_shangyong_capital","3k_main_faction_liu_bei")
            region_set_random_manager("3k_main_shangyong_resource_1","3k_main_faction_liu_bei")
            region_set_random_manager("3k_main_shangyong_resource_2","3k_main_faction_liu_bei")
            
            --涪陵
            region_set_random_manager("3k_main_fuling_capital","3k_main_faction_liu_bei")
            region_set_random_manager("3k_main_fuling_resource_1","3k_main_faction_liu_bei")
            
            --巴郡
            region_set_random_manager("3k_main_bajun_capital","3k_main_faction_liu_bei")
            region_set_random_manager("3k_main_bajun_resource_1","3k_main_faction_liu_bei")
            
            --蜀郡
            region_set_random_manager("3k_main_chengdu_capital","3k_main_faction_liu_bei")
            region_set_random_manager("3k_main_chengdu_resource_1","3k_main_faction_liu_bei")
            region_set_random_manager("3k_main_chengdu_resource_2","3k_main_faction_liu_bei")
            region_set_random_manager("3k_main_chengdu_resource_3","3k_main_faction_liu_bei")
            
            --江阳
            region_set_random_manager("3k_main_jiangyang_capital","3k_main_faction_liu_bei")
            region_set_random_manager("3k_main_jiangyang_resource_1","3k_main_faction_liu_bei")
            region_set_random_manager("3k_main_jiangyang_resource_2","3k_main_faction_liu_bei")
            region_set_random_manager("3k_main_jiangyang_resource_3","3k_main_faction_liu_bei")
            
            --永昌
            region_set_random_manager("3k_dlc06_yongchang_capital","3k_main_faction_liu_bei")
            region_set_random_manager("3k_dlc06_yongchang_resource_1","3k_main_faction_liu_bei")
            
            --牂牁
            region_set_random_manager("3k_main_zangke_capital","3k_main_faction_liu_bei")
            region_set_random_manager("3k_main_zangke_resource_1","3k_main_faction_liu_bei")
            region_set_random_manager("3k_main_zangke_resource_2","3k_main_faction_liu_bei")
            
            --云南
            region_set_random_manager("3k_dlc06_yunnan_capital","3k_main_faction_liu_bei")
            region_set_random_manager("3k_dlc06_yunnan_resource_1","3k_main_faction_liu_bei")
            region_set_random_manager("3k_dlc06_yunnan_resource_2","3k_main_faction_liu_bei")
            
            --建宁
            region_set_random_manager("3k_main_jianning_capital","3k_main_faction_liu_bei")
            region_set_random_manager("3k_main_jianning_resource_1","3k_main_faction_liu_bei")
            region_set_random_manager("3k_main_jianning_resource_2","3k_main_faction_liu_bei")
            region_set_random_manager("3k_dlc06_jianning_resource_3","3k_main_faction_liu_bei")
            
            --巴西
            region_set_random_manager("3k_main_baxi_capital","3k_main_faction_liu_bei")
            region_set_random_manager("3k_main_baxi_resource_1","3k_main_faction_liu_bei")
            region_set_random_manager("3k_main_baxi_resource_2","3k_main_faction_liu_bei")
            
            --夔关
            region_set_random_manager("3k_dlc06_kui_pass","3k_main_faction_liu_bei")
        end
    end,
    false
)

function liu_bei_defeat_nanman(faction_key)
    local faction = cm:query_faction(faction_key) 
    if faction 
    and faction
    and not faction:is_dead() then
        for i = 0, faction:region_list():num_items() - 1 do
            local region = faction:region_list():item_at(i);
            region_set_random_manager(region:name(),"3k_main_faction_liu_bei")
        end
        diplomacy_manager:force_confederation("3k_dlc06_faction_nanman_king_meng_huo", "3k_dlc06_faction_nanman_dongtuna");
    end
end

core:add_listener(
    "cao_cao_becomes_world_leader",
    "FactionBecomesWorldLeader",
    function(context)
        return 
        not context:faction():is_human()
        and context:faction():name() == "3k_main_faction_cao_cao";
    end,
    function(context)
        local luoyang = cm:query_region("3k_main_luoyang_capital")
        local faction = cm:query_faction("3k_main_faction_cao_cao")
        if luoyang:owning_faction():name() == "3k_main_faction_cao_cao" then
            cm:modify_faction(faction):make_region_capital(luoyang);
        end
        diplomacy_manager:force_confederation("3k_dlc05_faction_sun_ce", "3k_dlc07_faction_chen_deng");
    end,
    false
)

core:add_listener(
    "sun_quan_becomes_world_leader",
    "FactionBecomesWorldLeader",
    function(context)
        return 
        not context:faction():is_human()
        and context:faction():name() == "3k_dlc05_faction_sun_ce";
    end,
    function(context)
        local jianye = cm:query_region("3k_main_jianye_capital")
        local faction = cm:query_faction("3k_dlc05_faction_sun_ce")
        if jianye:owning_faction():name() == "3k_dlc05_faction_sun_ce" then
            cm:modify_faction(faction):make_region_capital(jianye);
        end
    end,
    false
)

core:add_listener(
    "liu_bei_becomes_world_leader",
    "FactionBecomesWorldLeader",
    function(context)
        return 
        not context:faction():is_human()
        and context:faction():name() == "3k_main_faction_liu_bei";
    end,
    function(context)
        local chengdu = cm:query_region("3k_main_chengdu_capital")
        local faction = cm:query_faction("3k_main_faction_liu_bei")
        if chengdu:owning_faction():name() == "3k_main_faction_liu_bei" then
            cm:modify_faction(faction):make_region_capital(chengdu);
        end
    end,
    false
)

--设置称帝首都
core:add_listener(
    "is_world_leader_event",
    "FactionTurnStart",
    function(context)
        return cm:query_model():campaign_name() == "3k_dlc07_start_pos";
    end,
    function(context)
        local luoyang = cm:query_region("3k_main_luoyang_capital")
        local jianye = cm:query_region("3k_main_jianye_capital")
        local chengdu = cm:query_region("3k_main_chengdu_capital")
        if not cm:query_faction("3k_main_faction_cao_cao"):is_human() 
        and context:faction():name() == "3k_main_faction_cao_cao"
        and cm:query_faction("3k_main_faction_cao_cao"):is_world_leader() 
        and luoyang:owning_faction():name() == "3k_main_faction_cao_cao" 
        then
            cm:modify_faction("3k_main_faction_cao_cao"):make_region_capital(luoyang);
        end
        if not cm:query_faction("3k_main_faction_liu_bei"):is_human()
        and context:faction():name() == "3k_main_faction_liu_bei"
        and cm:query_faction("3k_main_faction_liu_bei"):is_world_leader() 
        and chengdu:owning_faction():name() == "3k_main_faction_liu_bei" 
        then
            cm:modify_faction("3k_main_faction_liu_bei"):make_region_capital(chengdu);
        end
        if not cm:query_faction("3k_dlc05_faction_sun_ce"):is_human() 
        and context:faction():name() == "3k_dlc05_faction_sun_ce"
        and cm:query_faction("3k_dlc05_faction_sun_ce"):is_world_leader()
        and jianye:owning_faction():name() == "3k_dlc05_faction_sun_ce"
        then
            cm:modify_faction("3k_dlc05_faction_sun_ce"):make_region_capital(jianye);
        end
    end,
    true
)

--3k_main_historical_liu_zhuge_liang_npc_incident
core:add_listener(
    "occured_3k_main_historical_liu_zhuge_liang_npc_incident",
    "IncidentOccuredEvent",
    function(context)
        return context:incident() == "3k_main_historical_liu_zhuge_liang_npc_incident";
    end,
    function(context)
        local zhuge_liang_key = "3k_main_template_historical_zhuge_liang_hero_water";
        local huang_yueying_key = "hlyjbt";
        local zhuge_liang = gst.character_query_for_template(zhuge_liang_key);
        local huang_yueying = gst.character_query_for_template(huang_yueying_key);
        if not cm:query_faction("3k_main_faction_liu_bei"):is_null_interface()
        and not cm:query_faction("3k_main_faction_liu_bei"):is_dead()
        then
            if not zhuge_liang 
            or zhuge_liang:is_null_interface() 
            then
                zhuge_liang = gst.character_add_to_faction(zhuge_liang_key, "3k_main_faction_liu_bei", "3k_general_water");
            
            --local pang_tong = gst.character_query_for_template("3k_main_template_historical_pang_tong_hero_water")
            cm:modify_character(zhuge_liang):apply_effect_bundle("essentials_effect_bundle",-1);
            end
            if zhuge_liang:faction():name() == "3k_main_faction_liu_bei"
            then
                if not huang_yueying:faction():is_human() then
                    gst.character_add_to_faction(huang_yueying_key, "3k_main_faction_liu_bei", "3k_general_water");
                    local modify_huang_yueying = cm:modify_character(huang_yueying);
                    local family_member = modify_huang_yueying:family_member()
                    
                    --和黄月英结婚
                    if not family_member:is_null_interface() then 
                        family_member:divorce_spouse();
                        family_member:marry_character(cm:modify_character(zhuge_liang):family_member());
                    end
                end
            end
        else
            zhuge_liang = gst.character_join_random_faction("3k_main_template_historical_zhuge_liang_hero_water", "3k_general_water");
        end
        cm:modify_character(zhuge_liang):apply_effect_bundle("essentials_effect_bundle",-1);
    end,
    true
)

--3k_main_historical_cao_sima_yi_npc_incident
core:add_listener(
    "occured_3k_main_historical_cao_sima_yi_npc_incident",
    "IncidentOccuredEvent",
    function(context)
        return context:incident() == "3k_main_historical_cao_sima_yi_npc_incident";
    end,
    function(context)
        if not cm:query_faction("3k_main_faction_cao_cao"):is_null_interface()
        and not cm:query_faction("3k_main_faction_cao_cao"):is_dead()
        then
            local sima_yi = gst.character_add_to_faction("3k_main_template_historical_sima_yi_hero_water", "3k_main_faction_cao_cao", "3k_general_water");
            cm:modify_character(sima_yi):apply_effect_bundle("essentials_effect_bundle",-1);
        else
            local sima_yi = gst.character_join_random_faction("3k_main_template_historical_sima_yi_hero_water", "3k_general_water");
            cm:modify_character(sima_yi):apply_effect_bundle("essentials_effect_bundle",-1);
        end
    end,
    true
)

core:add_listener(
    "valid_check",
    "FactionTurnStart",
    function(context)
        return context:faction():is_human() 
        and valid_check();
    end,
    function(context)
        if cm:query_model():campaign_name() ~= "3k_dlc07_start_pos" then
            cm:set_saved_value("invalid", true);
            return;
        end
        local cao_cao = cm:query_faction("3k_main_faction_cao_cao")
        local liu_bei = cm:query_faction("3k_main_faction_liu_bei")
        local sun_quan = cm:query_faction("3k_dlc05_faction_sun_ce")
        if cao_cao:is_dead()
        or cao_cao:faction_leader():generation_template_key() ~= "3k_main_template_historical_cao_cao_hero_earth" 
        then
            cm:set_saved_value("invalid", true)
        end
        
        if sun_quan:is_dead()
        or (sun_quan:faction_leader():generation_template_key() ~= "3k_main_template_historical_sun_quan_hero_earth" 
        and sun_quan:faction_leader():generation_template_key() ~= "3k_main_template_historical_sun_ce_hero_fire")
        then
            cm:set_saved_value("invalid", true)
        end
        
        if (liu_bei:is_dead()
        or liu_bei:faction_leader():generation_template_key() ~= "3k_main_template_historical_liu_bei_hero_earth")
        and context:query_model():calendar_year() >= 209
        then
            cm:set_saved_value("invalid", true)
        end
        if
        gst.character_query_for_template("3k_main_template_historical_liu_bei_hero_earth"):is_dead() 
        or gst.character_query_for_template("3k_main_template_historical_cao_cao_hero_earth"):is_dead() 
        or gst.character_query_for_template("3k_main_template_historical_sun_quan_hero_earth"):is_dead() 
        then
            cm:set_saved_value("invalid", true)
        end
    end,
    true
)

--强制触发诸葛亮事件
core:add_listener(
    "zhuge_liang_event",
    "FactionTurnStart",
    function(context)
        return context:faction():is_human()
        and cm:query_faction("3k_main_faction_liu_bei"):is_human()
    end,
    function(context)
        if context:query_model():calendar_year() == 206 
        and context:query_model():season() == "season_harvest"
        then
            cm:trigger_dilemma(cm:query_faction("3k_main_faction_liu_bei"), "3k_main_historical_liu_zhuge_liang_pc_01_dilemma", true);
        end
    end,
    true
)

core:add_listener(
    "zhuge_liang_choice_01",
    "DilemmaChoiceMadeEvent",
    function(context)
        return 
        context:dilemma() == "3k_main_historical_liu_zhuge_liang_pc_01_dilemma"
        and valid_check()
    end,
    function(context)
        if context:choice() == 0 then
            cm:trigger_dilemma(cm:query_faction("3k_main_faction_liu_bei"), "3k_main_historical_liu_zhuge_liang_pc_02_dilemma", false);
        else
            cm:set_saved_value("invalid", true);
        end
    end,
    true
)

core:add_listener(
    "zhuge_liang_choice_02",
    "DilemmaChoiceMadeEvent",
    function(context)
        return 
        context:dilemma() == "3k_main_historical_liu_zhuge_liang_pc_02_dilemma"
        and valid_check()
    end,
    function(context)
        if context:choice() == 0 then
            cm:trigger_dilemma(cm:query_faction("3k_main_faction_liu_bei"), "3k_main_historical_liu_zhuge_liang_pc_03_dilemma", false);
        else
            cm:set_saved_value("invalid", true);
        end
    end,
    true
)

core:add_listener(
    "zhuge_liang_choice_03",
    "DilemmaChoiceMadeEvent",
    function(context)
        return 
        context:dilemma() == "3k_main_historical_liu_zhuge_liang_pc_03_dilemma"
        and valid_check()
    end,
    function(context)
        if context:choice() == 0 then
            cm:trigger_incident(cm:query_faction("3k_main_faction_liu_bei"), "3k_main_historical_liu_zhuge_liang_pc_04_incident", false);
        else
            cm:set_saved_value("invalid", true);
        end
    end,
    true
)

core:add_listener(
    "3k_main_historical_dong_fall_of_empire_npc_incident",
    "IncidentOccuredEvent",
    function(context)
        return context:incident() == "3k_main_historical_dong_fall_of_empire_npc_incident";
    end,
    function(context)
        local faction = cm:query_faction("3k_main_faction_dong_separatists")
        if not faction 
        or faction:is_null_interface()
        or faction:is_dead()
        then
            local li_jue = gst.character_add_to_faction("3k_main_template_historical_li_jue_hero_fire","3k_main_faction_dong_zhuo","3k_general_fire")
            gst.faction_set_minister_position("3k_main_template_historical_li_jue_hero_fire","faction_leader");
            local guo_si = gst.character_add_to_faction("3k_main_template_historical_guo_si_hero_fire","3k_main_faction_dong_zhuo","3k_general_wood")
        else
            local li_jue = gst.character_add_to_faction("3k_main_template_historical_li_jue_hero_fire","3k_main_faction_dong_separatists","3k_general_fire")
            gst.faction_set_minister_position("3k_main_template_historical_li_jue_hero_fire","faction_leader");
            local guo_si = gst.character_add_to_faction("3k_main_template_historical_guo_si_hero_fire","3k_main_faction_dong_separatists","3k_general_wood")
        end
        local lu_bu_faction = cm:query_faction("3k_main_faction_lu_bu")
        if not lu_bu_faction
        or lu_bu_faction:is_null_interface()
        or lu_bu_faction:is_dead()
        then
            gst.region_set_manager("3k_main_yingchuan_capital","3k_main_faction_lu_bu");
        end
        gst.character_add_to_faction("3k_main_template_historical_lu_bu_hero_fire","3k_main_faction_lu_bu","3k_general_fire")
        gst.faction_set_minister_position("3k_main_template_historical_lu_bu_hero_fire","faction_leader");
        gst.character_add_to_faction("3k_main_template_historical_chen_gong_hero_water","3k_main_faction_lu_bu","3k_general_water");
        gst.character_add_to_faction("3k_main_template_historical_lady_diao_chan_hero_water","3k_main_faction_lu_bu","3k_general_water");
        gst.character_add_to_faction("3k_main_template_historical_zhang_liao_hero_metal","3k_main_faction_lu_bu","3k_general_metal");
        gst.character_add_to_faction("3k_main_template_historical_gao_shun_hero_fire","3k_main_faction_lu_bu","3k_general_fire");
    end,
    false
)


core:add_listener(
    "yuan_shao_event_194",
    "FactionTurnStart",
    function(context)
        return cm:query_model():campaign_name() ~= "3k_dlc07_start_pos"
        and context:faction():name() == "3k_main_faction_yuan_shao"
        and not cm:query_faction("3k_main_faction_yuan_shao"):is_human()
        and not cm:query_faction("3k_main_faction_han_fu"):is_dead()
        and not cm:query_faction("3k_main_faction_han_fu"):is_human()
        and context:query_model():calendar_year() >= 194 
        and not cm:get_saved_value("yuan_shao_event_194") 
    end,
    function(context)
        diplomacy_manager:force_confederation("3k_main_faction_yuan_shao", "3k_main_faction_han_fu");
        diplomacy_manager:apply_automatic_deal_between_factions("3k_main_faction_yuan_shao", "3k_main_faction_gongsun_zan", "data_defined_situation_war_proposer_to_recipient");
        local zhao_yun = gst.character_add_to_faction("3k_main_template_historical_zhao_yun_hero_metal","3k_main_faction_gongsun_zan","3k_general_metal")
        cm:modify_character(zhao_yun):apply_effect_bundle("essentials_effect_bundle", -1)
        cm:set_saved_value("yuan_shao_event_194", true)
    end,
    false
)

core:add_listener(
    "yuan_shao_event_199",
    "FactionTurnStart",
    function(context)
        return cm:query_model():campaign_name() ~= "3k_dlc07_start_pos"
        and context:faction():name() == "3k_main_faction_yuan_shao"
        and not cm:query_faction("3k_main_faction_yuan_shao"):is_human()
        and not cm:query_faction("3k_main_faction_gongsun_zan"):is_dead()
        and not cm:query_faction("3k_main_faction_gongsun_zan"):is_human()
        and context:query_model():calendar_year() >= 199
        and not cm:get_saved_value("yuan_shao_event_199") 
    end,
    function(context)
        diplomacy_manager:force_confederation("3k_main_faction_yuan_shao", "3k_main_faction_gongsun_zan");
        local zhao_yun = gst.character_add_to_faction("3k_main_template_historical_zhao_yun_hero_metal","3k_main_faction_liu_bei","3k_general_metal")
        if cm:query_faction("3k_main_faction_liu_bei"):is_human() then
            cm:modify_character(zhao_yun):remove_effect_bundle("essentials_effect_bundle")
        end
        cm:set_saved_value("yuan_shao_event_199", true)
    end,
    false
)

core:add_listener(
    "dong_zhuo_event_190",
    "FactionTurnStart",
    function(context)
        return context:faction():name() == "3k_main_faction_dong_zhuo"
        and not cm:query_faction("3k_main_faction_dong_zhuo"):is_human()
        and context:query_model():calendar_year() >= 191
        and not cm:query_faction("3k_dlc04_faction_empress_he"):is_null_interface()
        and not cm:query_faction("3k_dlc04_faction_empress_he"):is_dead()
        and not cm:query_faction("3k_dlc04_faction_empress_he"):is_human()
    end,
    function(context)
        cm:modify_model():get_modify_world():remove_world_leader_region_status("3k_main_luoyang_capital");
        diplomacy_manager:force_confederation("3k_main_faction_dong_zhuo", "3k_dlc04_faction_empress_he");
    end,
    false
)

core:add_listener(
    "dong_zhuo_event_190_1",
    "FactionTurnStart",
    function(context)
        return cm:query_model():campaign_name() == "3k_dlc04_start_pos"
        and not cm:query_faction("3k_main_faction_dong_zhuo"):is_dead()
        and not cm:query_faction("3k_main_faction_dong_zhuo"):is_human()
        and context:query_model():calendar_year() >= 190
        and cm:query_faction("3k_dlc04_faction_empress_he"):is_dead()
        and not cm:get_saved_value("dong_zhuo_event_190_1") 
    end,
    function(context)
        diplomacy_manager:force_confederation("3k_main_faction_dong_zhuo", "3k_dlc04_faction_yuan_yi");
        cm:modify_region("3k_main_luoyang_capital"):raze_and_abandon_settlement_without_attacking();
        cm:modify_faction("3k_main_faction_dong_zhuo"):make_region_capital(cm:query_region("3k_main_changan_capital"));
        cm:modify_world_power_tokens():transfer("empror", cm:modify_faction("3k_main_faction_dong_zhuo"));
        cm:set_saved_value("dong_zhuo_event_190_1", true)
        diplomacy_manager:apply_automatic_deal_between_factions("3k_main_faction_dong_zhuo", "3k_main_faction_han_empire", "data_defined_situation_vassalise_recipient")
        
        gst.region_set_manager("3k_dlc06_hulao_pass","3k_dlc04_faction_prince_liu_chong");
        
        diplomacy_manager:apply_automatic_deal_between_factions("3k_main_faction_dong_zhuo", "3k_main_faction_cao_cao", "data_defined_situation_war_proposer_to_recipient");
        diplomacy_manager:apply_automatic_deal_between_factions("3k_main_faction_dong_zhuo", "3k_main_faction_liu_bei", "data_defined_situation_war_proposer_to_recipient");
        diplomacy_manager:apply_automatic_deal_between_factions("3k_main_faction_dong_zhuo", "3k_dlc04_faction_prince_liu_chong", "data_defined_situation_war_proposer_to_recipient");
        diplomacy_manager:apply_automatic_deal_between_factions("3k_main_faction_dong_zhuo", "3k_main_faction_yuan_shao", "data_defined_situation_war_proposer_to_recipient");
        diplomacy_manager:apply_automatic_deal_between_factions("3k_main_faction_dong_zhuo", "3k_main_faction_han_fu", "data_defined_situation_war_proposer_to_recipient");
    end,
    true
)
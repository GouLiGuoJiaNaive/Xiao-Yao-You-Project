cm:add_first_tick_callback_new(function() xyy_startpos(); end);
local gst = xyy_gst:get_mod()

function xyy_startpos()
end;

local data = nil

local unfriendlyThreshold = -25

function save_saved_value()
    local saved_values = cm.saved_values
    for k, v in pairs(saved_values) do
        if string.find(k, "is_wounded") then
            saved_values[k] = nil;
        end
    end
    --gst.lib_create_and_save_table("saved_values", cm.saved_values)
    --ModLog(cm:saved_values_to_string())
end;

function reload_saved_value()
    if data then
        self:load_values_from_string(data);
        data = nil
    end
end;

function function_exists(funcName, ...)
    local success, result = pcall(funcName, ...)
    return success
end

core:add_listener(   
    "lu_bu_employee_loop_listener",
    "FactionTurnStart",
    function(context)
        return context:faction():name() == "3k_main_faction_lu_bu";
    end,
    function(context)
        local complete_list = {}
        for character_template,ceo_data_key in pairs(lb_faction_ceos.template_to_ceo) do
            if ceo_data_key then
                local character = gst.character_query_for_template(character_template)
                if character
                and not character:is_null_interface() then
                    if character:is_dead()
                    or (character:faction():name() == "3k_main_faction_lu_bu"
                    and not character:is_character_is_faction_recruitment_pool())
                    then
                        gst.lib_table_insert(complete_list, character_template)
                        if not character:is_dead() then
                            cm:modify_character(character):remove_effect_bundle("essentials_effect_bundle", -1)
                        end
                    else
                        cm:modify_character(character):apply_effect_bundle("essentials_effect_bundle", -1)
                    end
                end
            end
        end
        for index,value in ipairs(complete_list) do
            if lb_faction_ceos.template_to_ceo[value] then
                local ceo_key = lb_faction_ceos.template_to_ceo[value]
                lb_faction_ceos:add_points(ceo_key, 1);
                lb_faction_ceos:equip_ceo(ceo_key);
                lb_faction_ceos.template_to_ceo[value] = nil
            end
        end
    end,
    true
);  

core:add_listener(
    "campaign_model_callback_command",
    "CampaignModelScriptCallback",
    function(context)
        return string.find(context:context():event_id(), "xyy_callback_");
    end,
    function(context)
        -- 角色图鉴界面
        if context:context():event_id() == "xyy_callback_xyy_illustration_panel_open" then
            cm:steal_escape_key_with_callback("xyy_illustration_panel", function()
                closeIllustrationPanel()
            end)
        end
        if context:context():event_id() == "xyy_callback_xyy_illustration_panel_close" then
            cm:release_escape_key_with_callback("xyy_illustration_panel")
        end
        -- 逍遥游商店界面
        if context:context():event_id() == "xyy_callback_xyy_store_panel_open" then
            cm:steal_escape_key_with_callback("xyy_store_panel", function()
                closeStorePanel()
            end)
        end
        if context:context():event_id() == "xyy_callback_xyy_store_panel_close" then
            cm:release_escape_key_with_callback("xyy_store_panel")
        end
        -- 逐鹿商店界面
        if context:context():event_id() == "xyy_callback_xyy_roguelike_store_panel_open" then
            cm:steal_escape_key_with_callback("xyy_roguelike_store_panel", function()
                close_roguelike_store_pannel()
            end)
        end
        if context:context():event_id() == "xyy_callback_xyy_roguelike_store_panel_close" then
            cm:release_escape_key_with_callback("xyy_roguelike_store_panel")
        end
        -- 七王界面
        if context:context():event_id() == "xyy_callback_xyy_seven_king_panel_open" then
            cm:steal_escape_key_with_callback("xyy_seven_king_panel", function()
                the_seven_kings_close_pannel()
            end)
        end
        if context:context():event_id() == "xyy_callback_xyy_seven_king_panel_close" then
            cm:release_escape_key_with_callback("xyy_seven_king_panel")
        end
        -- 其他界面
        if context:context():event_id() == "xyy_callback_steal_escape_key_true" then
            cm:steal_escape_key(true);
        end
        if context:context():event_id() == "xyy_callback_steal_escape_key_false" then
            cm:steal_escape_key(false);
        end
    end,
    false
);

core:add_listener(
    "3k_dlc07_scheme_faction_misc_of_give_ticket",
    "FactionEffectBundleAwarded",
    function(context)
        return context:effect_bundle_key() == "3k_dlc07_scheme_faction_misc_of_give_ticket";
    end,
    function(context)
        gst.faction_add_tickets(context:faction():name(), 50)
    end,
    true
);  


core:add_listener(
    "character_relationship_modify",
    "ActiveCharacterCreated",
    function(context)
        return true;
    end,
    function(context)
        if context:query_character():generation_template_key() == "hlyjdc" 
        or context:query_character():generation_template_key() == "hlyjdd" then
            local modify_character = context:modify_character()
            local father = gst.character_query_for_template("3k_main_template_fake_father");
            if father and not father:is_null_interface() then
                modify_character:make_child_of(cm:modify_character(father));
            end
        end
        local character_key = context:query_character():generation_template_key()
        for i,v in ipairs(gst.character_relationship) do
            if character_key == v["character_from"] then
                local character2 = gst.character_query_for_template(v["character_to"]);
                if character2 
                and not character2:is_null_interface() 
                and not character2:is_dead() 
                then
                    context:modify_character():apply_relationship_trigger_set(character2, v["relationship"]);
                end
            end
            if character_key == v["character_to"] then
                local character2 = gst.character_query_for_template(v["character_from"]);
                if character2 
                and not character2:is_null_interface() 
                and not character2:is_dead() 
                then
                    cm:modify_character(character2):apply_relationship_trigger_set(context:query_character(), v["relationship"]);
                end
            end
        end
    end,
    true
);  

-- core:add_listener(
--     "ComponentLClickUp_debug",
--     "ComponentLClickUp",
--     function(context)
--         return context.string == "start_button" 
--         or context.string == "spectate_button" 
--     end,
--     function()
--         has_pending_battle = true
--     end,
--     true
-- );

core:add_listener(
    "pre_battle_listener",
    "ModelScriptNotificationEvent",
    function(model_script_notification_event)
        ModLog(model_script_notification_event:event_id())
        return true;
    end,
    function(model_script_notification_event)
        if model_script_notification_event:event_id() == "start_battle" then
            cm:set_saved_value("xyy_roguelike_character_wound_listener", true)
            cm:set_saved_value("has_pending_battle", true)
            cm:set_saved_value("has_pending_battle_year", cm:query_model():calendar_year())
            cm:set_saved_value("has_pending_battle_season", cm:query_model():season())
            cm:set_saved_value("has_pending_battle_turn", cm:query_model():turn_number())
        end
        if model_script_notification_event:event_id() == "auto_resolver" then
            cm:set_saved_value("xyy_roguelike_character_wound_listener", false)
            cm:set_saved_value("has_pending_battle", nil)
        end
    end,
    true
)

function get_another_player(faction)
    if cm:is_multiplayer() then
        if faction:name() == cm:get_saved_value("xyy_1p", name) then
            return cm:query_faction(cm:get_saved_value("xyy_2p", name))
        elseif faction:name() == cm:get_saved_value("xyy_2p", name) then
            return cm:query_faction(cm:get_saved_value("xyy_1p", name))
        end
    end
end;

core:add_listener(
    "CMFirstTickAfterWorldCreated",
    "FirstTickAfterWorldCreated",
    function(context)
        return cm:query_model():is_multiplayer() and not cm:get_saved_value("CMFirstTickAfterWorldCreated");
    end,
    function(context)
        local faction_list = get_cm():query_model():world():faction_list();

        for i = 0, faction_list:num_items() - 1 do
            if faction_list:item_at(i):is_human() then
                local name = faction_list:item_at(i):name()
                if name == cm:query_model():world():whose_turn_is_it():name() then
                    cm:set_saved_value("xyy_1p", name)
                    ModLog("玩家1："..name)
                else
                    cm:set_saved_value("xyy_2p", name)
                    ModLog("玩家2："..name)
                end
            end;
        end;
        cm:set_saved_value("CMFirstTickAfterWorldCreated", true)
    end,
    false
);

core:add_listener(
    "autosave",
    "BattleCompletedCameraMove",
    function(context)
        return cm:is_multiplayer()
    end,
    function(context)
        local pb = cm:query_model():pending_battle();
        if pb:human_involved() then
            cm:modify_model():get_modify_episodic_scripting():autosave_at_next_opportunity();
        end
    end,
    true
)

core:add_listener(
    "autosave2",
    "PendingBattle",
    function(context)
        return cm:is_multiplayer()
    end,
    function(context)
        local pb = cm:query_model():pending_battle();
        if pb:human_involved() then
            cm:modify_model():get_modify_episodic_scripting():autosave_at_next_opportunity();
        end
    end,
    true
)

core:add_listener(
    "a_fix",
    "FirstTickAfterWorldCreated",
    function(context)
        return true
    end,
    function(context)
        --save_saved_value()
        register_gatepass_lisenters()
        
        local cheat = false
        if TheGathering_core_object then
            cheat = true
        end
        if mod_wife_bt then
            cheat = true
        end
        if gst.lib_check_cheat_mods() then
            cheat = true
        end
        if not cm:get_saved_value("xyy_cheat_mode") and cheat then
            cm:trigger_dilemma(cm:query_local_faction():name(),"xyy_cheat_mode", true);
            cm:set_saved_value("xyy_cheat_mode", true)
        end
        
        gst.character_add_to_faction("3k_main_template_fake_father","3k_main_faction_shoufang","3k_general_earth")
        gst.character_been_killed("3k_main_template_fake_father")
    end,
    true
)

core:add_listener(
    "roguelike_first_listener",
    "FirstTickAfterWorldCreated",
    function(context)
        return true;
    end,
    function(context)
        local faction = cm:query_local_faction()
        if cm:get_saved_value("roguelike_mode") and faction:subculture() == "3k_main_subculture_yellow_turban" then
            cm:modify_faction(faction):apply_effect_bundle("roguelike_ytr_eff", -1);
        end
    end,
    true
)

core:add_listener(
    "playerStore_api_byHy_listener_1",
    "FirstTickAfterWorldCreated",
    function(context)
        return true;
    end,
    function(context)
        if cm:query_model():campaign_name() == "3k_dlc07_start_pos" and context:query_model():turn_number() <= 1 then
            gst.region_set_manager("3k_main_wuwei_capital", "3k_main_faction_ma_teng");
            gst.region_set_manager("3k_main_jincheng_capital", "3k_main_faction_ma_teng");
            gst.region_set_manager("3k_main_jincheng_resource_1", "3k_main_faction_ma_teng");
            gst.region_set_manager("3k_main_jincheng_resource_2", "3k_main_faction_ma_teng");
            gst.faction_military_teleport_to_region(cm:query_faction("3k_main_faction_han_sui"):faction_leader(), cm:query_faction("3k_main_faction_han_sui"):capital_region():name())
            gst.faction_military_teleport_to_region(cm:query_faction("3k_dlc07_faction_zhang_meng"):faction_leader(), cm:query_faction("3k_dlc07_faction_zhang_meng"):capital_region():name())
        end
        local cao_zhang = gst.character_query_for_template("3k_main_template_historical_cao_zhang_hero_wood")
        if cao_zhang and not cao_zhang:is_null_interface() and not cao_zhang:is_character_is_faction_recruitment_pool() then
            cm:modify_character(cao_zhang):ceo_management():add_scripted_permission("3k_main_ceo_permissions_ancillary_armour_character_specific_cao_zhang")
            if not cao_zhang:ceo_management():has_ceo_equipped("3k_main_ancillary_armour_cao_zhang_armour_unique") then
                cm:modify_character(cao_zhang):ceo_management():remove_ceos("3k_main_ancillary_armour_xiahou_duns_armour_unique")
                cm:modify_character(cao_zhang):ceo_management():add_ceo("3k_main_ancillary_armour_cao_zhang_armour_unique")
            end
        end
        local xiahou_dun = gst.character_query_for_template("3k_main_template_historical_xiahou_dun_hero_wood")
        if xiahou_dun and not xiahou_dun:is_null_interface() then
            cm:modify_character(xiahou_dun):ceo_management():add_scripted_permission("3k_main_ceo_permissions_ancillary_armour_character_specific_xiahou_dun")
            if not xiahou_dun:ceo_management():has_ceo_equipped("3k_main_ancillary_armour_xiahou_duns_armour_unique") then
                cm:modify_character(xiahou_dun):ceo_management():add_ceo("3k_main_ancillary_armour_xiahou_duns_armour_unique")
            end
        end
        local lu_xun = gst.character_query_for_template("3k_main_template_historical_lu_xun_hero_water")
        if lu_xun 
        and not lu_xun:is_null_interface() 
        and not lu_xun:is_dead() 
        and not lu_xun:is_character_is_faction_recruitment_pool()
        and not lu_xun:ceo_management():has_ceo_equipped("3k_main_ancillary_armour_lu_xun_armour_unique")
        then
            if not gst.character_has_ceo("3k_main_template_historical_lu_xun_hero_water", "3k_main_ancillary_armour_lu_xun_armour_unique") then
                cm:modify_character(lu_xun):ceo_management():add_ceo("3k_main_ancillary_armour_lu_xun_armour_unique")
            end
            cm:modify_character(lu_xun):ceo_management():add_scripted_permission("3k_main_ceo_permissions_ancillary_armour_character_specific_lu_xun")
            gst.character_CEO_equip("3k_main_template_historical_lu_xun_hero_water","3k_main_ancillary_armour_lu_xun_armour_unique","3k_main_ceo_category_ancillary_armour");
        end
        local lu_su = gst.character_query_for_template("3k_main_template_historical_lu_su_hero_water")
        if lu_su 
        and not lu_su:is_null_interface() 
        and not lu_su:is_dead() 
        and not lu_su:is_character_is_faction_recruitment_pool()
        and not lu_su:ceo_management():has_ceo_equipped("lu_su_yifu")
        then
            if not gst.character_has_ceo("3k_main_template_historical_lu_su_hero_water", "lu_su_yifu") then
                cm:modify_character(lu_su):ceo_management():add_ceo("lu_su_yifu")
            end
            cm:modify_character(lu_su):ceo_management():add_scripted_permission("lu_su_yifu_group")
            gst.character_CEO_equip("3k_main_template_historical_lu_su_hero_water","lu_su_yifu","3k_main_ceo_category_ancillary_armour");
        end
        local lu_meng = gst.character_query_for_template("3k_main_template_historical_lu_meng_hero_metal")
        if lu_meng 
        and not lu_meng:is_null_interface() 
        and not lu_meng:is_dead() 
        and not lu_meng:is_character_is_faction_recruitment_pool()
        and not lu_meng:ceo_management():has_ceo_equipped("3k_main_ancillary_armour_lu_meng_armour_unique")
        then
            if not gst.character_has_ceo("3k_main_template_historical_lu_meng_hero_metal", "3k_main_ancillary_armour_lu_meng_armour_unique") then
                cm:modify_character(lu_meng):ceo_management():add_ceo("3k_main_ancillary_armour_lu_meng_armour_unique")
            end
            cm:modify_character(lu_meng):ceo_management():add_scripted_permission("3k_main_ceo_permissions_ancillary_armour_character_specific_lu_meng")
            gst.character_CEO_equip("3k_main_template_historical_lu_meng_hero_metal","3k_main_ancillary_armour_lu_meng_armour_unique","3k_main_ceo_category_ancillary_armour");
        end
        local cai_yan = gst.character_query_for_template("3k_main_template_historical_lady_cai_yan_hero_water")
        if cai_yan 
        and not cai_yan:is_null_interface() 
        and not cai_yan:is_dead() 
        and not cai_yan:is_character_is_faction_recruitment_pool()
        and not cai_yan:ceo_management():has_ceo_equipped("3k_main_ancillary_armour_cai_yan_armour_unique")
        then
            if not gst.character_has_ceo("3k_main_template_historical_lady_cai_yan_hero_water", "3k_main_ancillary_armour_cai_yan_armour_unique") then
                cm:modify_character(cai_yan):ceo_management():add_ceo("3k_main_ancillary_armour_cai_yan_armour_unique")
            end
            cm:modify_character(cai_yan):ceo_management():add_scripted_permission("3k_main_ceo_permissions_ancillary_armour_character_specific_cai_yan")
            gst.character_CEO_equip("3k_main_template_historical_lady_cai_yan_hero_water","3k_main_ancillary_armour_cai_yan_armour_unique","3k_main_ceo_category_ancillary_armour");
        end
        local liu_shan = gst.character_query_for_template("3k_main_template_historical_liu_shan_hero_earth")
        if liu_shan 
        and not liu_shan:is_null_interface() 
        and not liu_shan:is_dead() 
        and not liu_shan:is_character_is_faction_recruitment_pool()
        and not liu_shan:ceo_management():has_ceo_equipped("3k_main_ancillary_armour_liu_shan_armour_unique")
        then
            if not gst.character_has_ceo("3k_main_template_historical_lady_cai_yan_hero_water", "3k_main_ancillary_armour_liu_shan_armour_unique") then
                cm:modify_character(liu_shan):ceo_management():add_ceo("3k_main_ancillary_armour_liu_shan_armour_unique")
            end
            cm:modify_character(liu_shan):ceo_management():add_scripted_permission("3k_main_ceo_permissions_ancillary_armour_character_specific_liu_shan")
            gst.character_CEO_equip("3k_main_template_historical_liu_shan_hero_earth","3k_main_ancillary_armour_liu_shan_armour_unique","3k_main_ceo_category_ancillary_armour");
        end
    end,
    false
)

--添加监听
core:add_listener(
    "playerStore_api_byHy_listener",
    "FirstTickAfterWorldCreated", --世界创建完成后的第一时间
    function(context)
        return cm:query_model():turn_number() == 1
        and not cm:get_saved_value("xyy_store_ready");
    end,

    function(context)
        if not cm:is_multiplayer() then
            if cm:query_model():campaign_name() == "3k_main_campaign_map" 
            or cm:query_model():campaign_name() == "3k_dlc05_start_pos" 
            then
                cm:modify_faction(cm:query_local_faction()):set_tech_research_cooldown(3)
            end
            if cm:query_model():campaign_name() == "3k_dlc04_start_pos" then
                cm:modify_faction(cm:query_local_faction()):set_tech_research_cooldown(1)
            end
        else
            if cm:query_model():campaign_name() == "3k_main_campaign_map" 
            or cm:query_model():campaign_name() == "3k_dlc05_start_pos" 
            then
                cm:modify_faction(cm:get_saved_value("xyy_1p")):set_tech_research_cooldown(3)
                cm:modify_faction(cm:get_saved_value("xyy_2p")):set_tech_research_cooldown(3)
            end
            if cm:query_model():campaign_name() == "3k_dlc04_start_pos" then
                cm:modify_faction(cm:get_saved_value("xyy_1p")):set_tech_research_cooldown(1)
                cm:modify_faction(cm:get_saved_value("xyy_2p")):set_tech_research_cooldown(1)
            end
        end
        if not cm:is_multiplayer() then
            if cm:query_local_faction(true):name() ~= "xyyhlyjb"
            and cm:query_local_faction(true):name() ~= "xyyhlyjc"
            and cm:query_local_faction(true):name() ~= "xyyhlyjd"
            and cm:query_local_faction(true):name() ~= "xyyhlyje"
            and cm:query_local_faction(true):name() ~= "xyyhlyjf"
            then
                cm:trigger_dilemma(cm:query_local_faction():name(),"hexie_script", true);
            else
                gst.character_browser_disable()
                core:remove_listener("character_join_event")
                cm:set_saved_values("character_join_or_dont", false)
                cm:set_saved_value("character_store_disable", true)
            end
        else
            if cm:query_faction(cm:get_saved_value("xyy_1p")):name() ~= "xyyhlyjb"
            and cm:query_faction(cm:get_saved_value("xyy_1p")):name() ~= "xyyhlyjc"
            and cm:query_faction(cm:get_saved_value("xyy_1p")):name() ~= "xyyhlyjd"
            and cm:query_faction(cm:get_saved_value("xyy_1p")):name() ~= "xyyhlyje"
            and cm:query_faction(cm:get_saved_value("xyy_1p")):name() ~= "xyyhlyjf"
            and cm:query_faction(cm:get_saved_value("xyy_2p")):name() ~= "xyyhlyjb"
            and cm:query_faction(cm:get_saved_value("xyy_2p")):name() ~= "xyyhlyjc"
            and cm:query_faction(cm:get_saved_value("xyy_2p")):name() ~= "xyyhlyjd"
            and cm:query_faction(cm:get_saved_value("xyy_2p")):name() ~= "xyyhlyje"
            and cm:query_faction(cm:get_saved_value("xyy_2p")):name() ~= "xyyhlyjf"
            then
                if context:query_model():world():whose_turn_is_it():name() == cm:get_saved_value("xyy_1p") then
                    cm:trigger_dilemma(cm:get_saved_value("xyy_1p"),"hexie_script", true);
                end
                if context:query_model():world():whose_turn_is_it():name() == cm:get_saved_value("xyy_2p") then
                    cm:trigger_dilemma(cm:get_saved_value("xyy_2p"),"hexie_script", true);
                end
            else
                gst.character_browser_disable()
                core:remove_listener("character_join_event")
                cm:set_saved_values("character_join_or_dont", false)
                cm:set_saved_value("character_store_disable", true)
            end
        end
        local xyyhlyja = cm:query_faction("xyyhlyja")
        if xyyhlyja and not xyyhlyja:is_null_interface() and not xyyhlyja:is_dead() then
            gst.character_add_to_faction("3k_main_template_historical_yuwen_wei_hero_metal","xyyhlyja","3k_general_metal")
            gst.character_add_to_faction("3k_main_template_historical_tuoba_zan_hero_wood","xyyhlyja","3k_general_wood")
            gst.character_add_to_faction("3k_main_template_historical_zhangsun_yuanji_hero_earth","xyyhlyja","3k_general_earth")
        end
        
        if 
        cm:query_model():campaign_name() ~= "3k_dlc04_start_pos" 
        and cm:query_model():campaign_name() ~= "8p_start_pos" 
        and cm:query_model():campaign_name() ~= "3k_main_campaign_map" 
        then
            local lu_xun = gst.character_add_to_faction("3k_main_template_historical_lu_xun_hero_water","3k_dlc05_faction_sun_ce","3k_general_water")
            cm:modify_character(lu_xun):ceo_management():add_ceo("3k_main_ancillary_armour_lu_xun_armour_unique")
            cm:modify_character(lu_xun):ceo_management():add_scripted_permission("3k_main_ceo_permissions_ancillary_armour_character_specific_lu_xun")
            gst.character_CEO_equip("3k_main_template_historical_lu_xun_hero_water","3k_main_ancillary_armour_lu_xun_armour_unique","3k_main_ceo_category_ancillary_armour");
            cm:modify_character(lu_xun):apply_effect_bundle("essentials_effect_bundle",-1);
            local lu_meng = gst.character_add_to_faction("3k_main_template_historical_lu_meng_hero_metal","3k_dlc05_faction_sun_ce","3k_general_metal")
            cm:modify_character(lu_meng):ceo_management():add_ceo("3k_main_ancillary_armour_lu_meng_armour_unique")
            cm:modify_character(lu_meng):ceo_management():add_scripted_permission("3k_main_ceo_permissions_ancillary_armour_character_specific_lu_meng")
            cm:modify_character(lu_meng):apply_effect_bundle("essentials_effect_bundle",-1);
            gst.character_CEO_equip("3k_main_template_historical_lu_meng_hero_metal","3k_main_ancillary_armour_lu_meng_armour_unique","3k_main_ceo_category_ancillary_armour");
            
            local lu_su = gst.character_add_to_faction("3k_main_template_historical_lu_su_hero_water", "3k_dlc05_faction_sun_ce", "3k_general_water");
            cm:modify_character(lu_su):apply_effect_bundle("essentials_effect_bundle",-1);
            
            local hua_tuo = gst.character_add_to_faction("3k_main_template_historical_hua_tuo_hero_water", "3k_dlc07_faction_li_shu", "3k_general_water");
            
            local yan_yan = gst.character_add_to_faction("hlyjdb", "3k_main_faction_liu_yan", "3k_general_fire");
            cm:modify_character(yan_yan):apply_effect_bundle("essentials_effect_bundle",-1);
            
            if cm:query_model():campaign_name() == "3k_dlc07_start_pos" then
                local lu_lingqi = cm:query_model():character_for_template("hlyjbw") -- 吕玲绮
                local lu_lingju = cm:query_model():character_for_template("hlyjbx") -- 吕灵雎
                local diaochan = cm:query_model():character_for_template("3k_main_template_historical_lady_diao_chan_hero_water")
                local lu_bu = cm:query_model():character_for_template("3k_main_template_historical_lu_bu_hero_fire")
                gst.character_add_to_faction("3k_dlc05_template_historical_lady_yan_hero_earth","3k_main_faction_cao_cao","3k_general_earth")
                local lady_yan = cm:query_model():character_for_template("3k_dlc05_template_historical_lady_yan_hero_earth");
                cm:modify_character(lu_lingqi):make_child_of(cm:modify_character(lady_yan));
                cm:modify_character(lu_lingju):make_child_of(cm:modify_character(diaochan));
                lu_bu = gst.character_add_to_faction("3k_main_template_historical_lu_bu_hero_fire","3k_main_faction_cao_cao","3k_general_fire");
                cm:modify_character(lu_lingqi):make_child_of(cm:modify_character(lu_bu));
                cm:modify_character(lu_lingju):make_child_of(cm:modify_character(lu_bu));
                cm:modify_character(lu_bu):kill_character(true);
            end
        end
    end,
    false
)

--角色装备切换
core:add_listener(
    "character_ceo_equipment",
    "FactionTurnEnd",
    function(context)
        local furina = cm:query_model():character_for_template("hlyjco")
        local jingliu = cm:query_model():character_for_template("hlyjck")
        local jingliu_dark = cm:query_model():character_for_template("hlyjck_dark")
        local c_chan = cm:query_model():character_for_template("hlyjby")
        return (not furina:is_null_interface() and not furina:is_dead() and context:faction():name() == furina:faction():name() and not furina:is_character_is_faction_recruitment_pool())
        or (not jingliu:is_null_interface() and not jingliu:is_dead() and context:faction():name() == jingliu:faction():name() and not jingliu:is_character_is_faction_recruitment_pool())
        or (not c_chan:is_null_interface() and not c_chan:is_dead() and context:faction():name() == c_chan:faction():name() and not c_chan:is_character_is_faction_recruitment_pool())
        or (not jingliu_dark:is_null_interface() and not jingliu_dark:is_dead() and context:faction():name() == jingliu_dark:faction():name() and not jingliu_dark:is_character_is_faction_recruitment_pool())
    end,
    function(context)
        if context:faction():is_human() then
            return;
        end
        local military_force_list = context:faction():military_force_list()
        for i = 0, military_force_list:num_items() - 1 do
            local query_military_force = military_force_list:item_at(i);
            local character_list = query_military_force:character_list()
            for j = 0, character_list:num_items() - 1 do
                local character = character_list:item_at(j);
                if not character:is_null_interface()
                and not character:is_dead()
                then
                    --ModLog(character:generation_template_key())
                    if character:generation_template_key() == "hlyjco"
                    and not character:faction():is_human()
                    then
                        ModLog("芙宁娜: "..query_military_force:strength())
                        if query_military_force:strength() > 20000 then
                            --gst.character_CEO_equip("hlyjco","hlyjcoyifu","3k_main_ceo_category_ancillary_armour");
                            local ceos = character:ceo_management():all_ceos()
                            local query_ceo;
                            for k = 0, ceos:num_items() - 1 do
                                local ceo = ceos:item_at(k);
                                if ceo:ceo_data_key() == "hlyjcoyifu" then
                                    query_ceo = ceo;
                                end
                            end
                            local slots = character:ceo_management():all_ceo_equipment_slots()
                            for l = 0, slots:num_items() - 1 do
                                local slot = slots:item_at(l);
                                if query_ceo and not query_ceo:is_null_interface() and character:ceo_management() and slot:category_key() == "3k_main_ceo_category_ancillary_armour" then
                                    cm:modify_character(character):ceo_management():equip_ceo_in_slot(slot,query_ceo);
                                end
                            end
                        else
                            local ceos = character:ceo_management():all_ceos()
                            local query_ceo;
                            for k = 0, ceos:num_items() - 1 do
                                local ceo = ceos:item_at(k);
                                if ceo:ceo_data_key() == "hlyjcoyifu2" then
                                    query_ceo = ceo;
                                end
                            end
                            local slots = character:ceo_management():all_ceo_equipment_slots()
                            for l = 0, slots:num_items() - 1 do
                                local slot = slots:item_at(l);
                                if query_ceo and not query_ceo:is_null_interface() and character:ceo_management() and slot:category_key() == "3k_main_ceo_category_ancillary_armour" then
                                    cm:modify_character(character):ceo_management():equip_ceo_in_slot(slot,query_ceo);
                                end
                            end
                        end
                    end
                    if character:generation_template_key() == "hlyjby"
                    and not character:faction():is_human()
                    then
                        ModLog("C酱: "..query_military_force:strength())
                        if query_military_force:strength() > 20000 then
                            --gst.character_CEO_equip("hlyjco","hlyjcoyifu","3k_main_ceo_category_ancillary_armour");
                            local ceos = character:ceo_management():all_ceos()
                            local query_ceo;
                            for k = 0, ceos:num_items() - 1 do
                                local ceo = ceos:item_at(k);
                                if ceo:ceo_data_key() == "hlyjbyyifu2" then
                                    query_ceo = ceo;
                                end
                            end
                            local slots = character:ceo_management():all_ceo_equipment_slots()
                            for l = 0, slots:num_items() - 1 do
                                local slot = slots:item_at(l);
                                if query_ceo and not query_ceo:is_null_interface() and character:ceo_management() and slot:category_key() == "3k_main_ceo_category_ancillary_armour" then
                                    cm:modify_character(character):ceo_management():equip_ceo_in_slot(slot,query_ceo);
                                end
                            end
                        else
                            local ceos = character:ceo_management():all_ceos()
                            local query_ceo;
                            for k = 0, ceos:num_items() - 1 do
                                local ceo = ceos:item_at(k);
                                if ceo:ceo_data_key() == "hlyjbyyifu" then
                                    query_ceo = ceo;
                                end
                            end
                            local slots = character:ceo_management():all_ceo_equipment_slots()
                            for l = 0, slots:num_items() - 1 do
                                local slot = slots:item_at(l);
                                if query_ceo and not query_ceo:is_null_interface() and character:ceo_management() and slot:category_key() == "3k_main_ceo_category_ancillary_armour" then
                                    cm:modify_character(character):ceo_management():equip_ceo_in_slot(slot,query_ceo);
                                end
                            end
                        end
                    end
                    if character:generation_template_key() == "hlyjck"
                    and not character:faction():is_human() 
                    then
                        ModLog("镜流: "..query_military_force:strength())
                        if query_military_force:strength() > 20000 then
                            gst.character_CEO_unequip("hlyjck", "3k_main_ceo_category_ancillary_accessory");
                            gst.character_CEO_equip("hlyjck","3k_main_ancillary_accessory_art_of_war","3k_main_ceo_category_ancillary_accessory");
                        else
                            local ceos = character:ceo_management():all_ceos()
                            local query_ceo;
                            for k = 0, ceos:num_items() - 1 do
                                local ceo = ceos:item_at(k);
                                if ceo:ceo_data_key() == "hlyjckyanzhao" then
                                    query_ceo = ceo;
                                end
                            end
                            local slots = character:ceo_management():all_ceo_equipment_slots()
                            for l = 0, slots:num_items() - 1 do
                                local slot = slots:item_at(l);
                                if query_ceo and not query_ceo:is_null_interface() and character:ceo_management() and slot:category_key() == "3k_main_ceo_category_ancillary_accessory" then
                                    cm:modify_character(character):ceo_management():equip_ceo_in_slot(slot,query_ceo);
                                end
                            end
                            gst.character_CEO_remove("hlyjck","3k_main_ancillary_accessory_art_of_war","3k_main_ceo_category_ancillary_accessory");
                        end
                    end
                end
            end
        end
    end,
    true
)


--禁用AI二次元角色结婚
core:add_listener(
    "character_disable_marriage",
    "CharacterMarried",
    function(context)
        return not context:query_proposer_character():faction():is_human()
        and not context:query_recipient_character():faction():is_human();
    end,
    function(context)
        if gst.lib_value_in_list(gst.xyy_character_list, context:query_proposer_character():generation_template_key()) 
        and not gst.lib_value_in_list(gst.xyy_character_list, context:query_recipient_character():generation_template_key()) 
        then
            context:modify_proposer_character():family_member():divorce_spouse()
            context:modify_recipient_character():family_member():divorce_spouse()
        end
        if gst.lib_value_in_list(gst.xyy_character_list, context:query_recipient_character():generation_template_key()) 
        and not gst.lib_value_in_list(gst.xyy_character_list, context:query_proposer_character():generation_template_key()) 
        then
            context:modify_proposer_character():family_member():divorce_spouse()
            context:modify_recipient_character():family_member():divorce_spouse()
        end
    end,
    true
)


core:add_listener(
    "on_character_wounded_received",
    "CharacterWoundReceivedEvent",
    function(context)
        return not context:query_character():is_dead()
        and context:query_character():is_wounded();
    end,
    function(context)
        local table;
        if not cm:get_saved_value("wounded_table") then
            table = {}
        else
            table = cm:get_saved_value("wounded_table")
        end
        local cqi = tostring(context:query_character():cqi())
        if table[cqi] then
            local a = table[cqi]
            table[cqi] = a + 1;
        else
            table[cqi] = 1;
        end
        
        cm:set_saved_value("wounded_table", table)
        
        if not context:query_character():is_dead()
        and not context:query_character():is_character_is_faction_recruitment_pool()
        and context:query_character():faction():has_effect_bundle("xyy_roguelike_15")
        then
            if table[cqi] and table[cqi] == 1 then
                cm:modify_character(context:query_character()):apply_effect_bundle("xyy_roguelike_15_unseen", -1)
            else
                cm:modify_character(context:query_character()):remove_effect_bundle("xyy_roguelike_15_unseen")
            end
        end
        ModLog(gst.character_get_string_name(context:query_character()).."("..cqi..") 已受伤")
    end,
    true
)

core:add_listener(
    "on_character_wound_healed",
    "CharacterWoundHealedEvent",
    function(context)
        return true
    end,
    function(context)
        local table;
        if not cm:get_saved_value("wounded_table") then
            table = {}
        else
            table = cm:get_saved_value("wounded_table")
        end
        
        local cqi = tostring(context:query_character():cqi())
        if table[cqi] then
            if table[cqi] == 1 then
                table[cqi] = nil;
            else
                local a = table[cqi]
                table[cqi] = a - 1;
            end
        end
        cm:set_saved_value("wounded_table", table)
        if not context:query_character():is_dead()
        and not context:query_character():is_character_is_faction_recruitment_pool()
        and context:query_character():faction():has_effect_bundle("xyy_roguelike_15")
        then
            if table[cqi] and table[cqi] == 1 then
                cm:modify_character(context:query_character()):apply_effect_bundle("xyy_roguelike_15_unseen", -1)
            else
                cm:modify_character(context:query_character()):remove_effect_bundle("xyy_roguelike_15_unseen")
            end
        end
        
        ModLog(gst.character_get_string_name(context:query_character()).."("..cqi..") 已恢复")
    end,
    true
)


--去除伤残
core:add_listener(
    "xyy_ceo_trait_remove",
    "CharacterCeoAdded",
    function(context)
        return (context:ceo():ceo_data_key() == "3k_main_ceo_trait_physical_one-eyed" 
        or context:ceo():ceo_data_key() == "3k_ytr_ceo_trait_physical_sprained_ankle" 
        or context:ceo():ceo_data_key() == "3k_main_ceo_trait_physical_scarred" 
        or context:ceo():ceo_data_key() == "3k_main_ceo_trait_physical_maimed_arm"
        or context:ceo():ceo_data_key() == "3k_main_ceo_trait_physical_maimed_leg");
    end,
    function(context)
        local key = context:query_character():generation_template_key()
        if string.find(key, "_f_hero") 
        or string.find(key, "_m_hero") 
        or string.find(key, "_scripted_") 
        then
            ModLog(gst.character_get_string_name(context:query_character()).."获得伤残特性（非独特武将）")
            return;
        end
        if (cm:get_saved_value("kafka_mission_leader") and context:query_character():generation_template_key() == cm:get_saved_value("kafka_mission_leader") 
        and not cm:get_saved_value("huanlong_dead")) -- 卡芙卡剧情激活时的派系领袖
        or gst.lib_value_in_list(gst.xyy_character_list, key) 
        or gst.lib_value_in_list(gst.cant_be_maimed_characters, key) 
        or context:query_character():faction():has_effect_bundle("blessing_preservation_1") --派系拥有存护I命途赐福
        or context:query_character():faction():has_effect_bundle("blessing_preservation_2") --派系拥有存护II命途赐福
        or context:query_character():faction():has_effect_bundle("blessing_preservation_3") --派系拥有存护III命途赐福
        or context:query_character():faction():has_effect_bundle("xyy_roguelike_44") --毫发无损buff
        or context:query_character():has_effect_bundle("essentials_effect_bundle") --人物是否为保护人物？
        or context:query_character():has_effect_bundle("dark_character") --人物是否为恶堕者
        or context:query_character():has_effect_bundle("xyy_roguelike_38_unseen_2") --人物是否被背水一战保护
        then
            ModLog(gst.character_get_string_name(context:query_character()).."不会伤残")
            local ceo_key = context:ceo():ceo_data_key(); --Get Ceo
            local character_modifier = context:modify_character(); 
            character_modifier:ceo_management():remove_ceos(ceo_key); 
        else
            if gst.character_is_wounded(context:query_character()) <= 1 then
                local ceo_key = context:ceo():ceo_data_key(); --Get Ceo
                local character_modifier = context:modify_character(); 
                character_modifier:ceo_management():remove_ceos(ceo_key); 
                ModLog(gst.character_get_string_name(context:query_character()).."受伤状态下再次受伤可能伤残")
            else
                if cm:random_int(0,2000) > 1200 and ceo_key ~= "3k_main_ceo_trait_physical_scarred" then
                    local ceo_key = context:ceo():ceo_data_key(); --Get Ceo
                    local character_modifier = context:modify_character(); 
                    character_modifier:ceo_management():remove_ceos(ceo_key); 
                    character_modifier:ceo_management():add_ceo("3k_main_ceo_trait_physical_scarred"); 
                end
                ModLog(gst.character_get_string_name(context:query_character()).."获得伤残特性")
            end
        end
    end,
    true
)

core:add_listener(
    "kujou_sara_debuff",
    "FactionTurnEnd",
    function(context)
        local hlyjdf = cm:query_model():character_for_template("hlyjdf")
        return hlyjdf
        and not hlyjdf:is_null_interface()
        and not hlyjdf:is_dead()
        and not hlyjdf:is_character_is_faction_recruitment_pool()
        and hlyjdf:faction():name() == context:faction():name()
    end,
    function(context)
        local hlyjdf = cm:query_model():character_for_template("hlyjdf")
        local hlyjcm = cm:query_model():character_for_template("hlyjcm")
        if hlyjcm
        and not hlyjcm:is_null_interface() 
        and not hlyjcm:is_dead() 
        and not hlyjcm:is_character_is_faction_recruitment_pool() 
        and hlyjcm:faction():name() == context:faction():name() then
           cm:modify_character(hlyjdf):remove_effect_bundle("kujou_sara_debuff") 
        else
           cm:modify_character(hlyjdf):apply_effect_bundle("kujou_sara_debuff", -1) 
        end
    end,
    true
)

--200剧情人物保护机制
core:add_listener(
    "character_essential_check",
    "FactionTurnStart",
    function(context)
        return context:faction():is_human()
    end,
    function(context)
        local chat_list_wait_for_reapply_effect = {
            {character_for_template = "3k_main_template_historical_lu_su_hero_water", faction_name = "3k_dlc05_faction_sun_ce" },
            {character_for_template = "3k_main_template_historical_cheng_pu_hero_metal", faction_name = "3k_dlc05_faction_sun_ce" },
            {character_for_template = "3k_main_template_historical_lu_xun_hero_water", faction_name = "3k_dlc05_faction_sun_ce" },
            {character_for_template = "3k_main_template_historical_cao_cao_hero_earth", faction_name = "3k_main_faction_cao_cao" },
            {character_for_template = "3k_main_template_historical_yuan_shao_hero_earth", faction_name = "3k_main_faction_yuan_shao" },
            {character_for_template = "3k_main_template_historical_zhang_fei_hero_fire", faction_name = "3k_main_faction_liu_bei" },
            {character_for_template = "3k_main_template_historical_guan_yu_hero_wood", faction_name = "3k_main_faction_liu_bei" },
            {character_for_template = "3k_main_template_historical_zhao_yun_hero_metal", faction_name = "3k_main_faction_liu_bei" },
            {character_for_template = "3k_main_template_historical_liu_bei_hero_earth", faction_name = "3k_main_faction_liu_bei" },
            {character_for_template = "3k_main_template_historical_yue_jin_hero_metal", faction_name = "3k_main_faction_cao_cao" },
            {character_for_template = "3k_main_template_historical_xu_chu_hero_wood", faction_name = "3k_main_faction_cao_cao" },
            {character_for_template = "3k_main_template_historical_cao_pi_hero_earth", faction_name = "3k_main_faction_cao_cao" },
            {character_for_template = "3k_main_template_historical_cao_zhi_hero_water", faction_name = "3k_main_faction_cao_cao" },
            {character_for_template = "3k_main_template_historical_zhou_tai_hero_fire", faction_name = "3k_dlc05_faction_sun_ce" },
            {character_for_template = "3k_main_template_historical_zhou_yu_hero_water", faction_name = "3k_dlc05_faction_sun_ce" },
            {character_for_template = "3k_cp01_template_historical_huang_gai_hero_fire", faction_name = "3k_dlc05_faction_sun_ce" },
            {character_for_template = "3k_main_template_historical_huang_gai_hero_wood", faction_name = "3k_dlc05_faction_sun_ce" },
            {character_for_template = "3k_main_template_historical_lady_da_qiao_hero_earth", faction_name = "3k_dlc05_faction_sun_ce" },
            {character_for_template = "3k_main_template_historical_lady_xiao_qiao_hero_metal", faction_name = "3k_dlc05_faction_sun_ce" },
            {character_for_template = "3k_main_template_historical_yu_jin_hero_metal", faction_name = "3k_main_faction_cao_cao" },
            {character_for_template = "3k_main_template_historical_cao_ren_hero_earth", faction_name = "3k_main_faction_cao_cao" },
            {character_for_template = "3k_main_template_historical_xiahou_dun_hero_wood", faction_name = "3k_main_faction_cao_cao" },
            {character_for_template = "3k_main_template_historical_xiahou_yuan_hero_fire", faction_name = "3k_main_faction_cao_cao" },
            {character_for_template = "3k_main_template_historical_zhang_liao_hero_metal", faction_name = "3k_main_faction_cao_cao" },
            {character_for_template = "3k_main_template_historical_huang_zhong_hero_metal", faction_name = "3k_main_faction_liu_bei" },
            {character_for_template = "3k_main_template_historical_ma_teng_hero_fire", faction_name = "3k_main_faction_cao_cao" },
            {character_for_template = "3k_main_template_historical_ma_chao_hero_fire", faction_name = "3k_main_faction_liu_bei" },
            {character_for_template = "3k_dlc06_template_historical_king_meng_huo_hero_nanman", faction_name = "3k_dlc06_faction_nanman_king_meng_huo" },
            {character_for_template = "3k_main_template_historical_zhuge_liang_hero_water", faction_name = "3k_main_faction_liu_bei" },
            {character_for_template = "3k_main_template_historical_wei_yan_hero_wood", faction_name = "3k_main_faction_liu_bei" },
            {character_for_template = "3k_main_template_historical_sima_yi_hero_water", faction_name = "3k_main_faction_cao_cao" },
            {character_for_template = "3k_main_template_historical_lady_sun_shangxiang_hero_fire", faction_name = "3k_dlc05_faction_sun_ce" },
            {character_for_template = "3k_main_template_historical_sun_quan_hero_earth", faction_name = "3k_dlc05_faction_sun_ce" },
            {character_for_template = "3k_main_template_historical_zhang_he_hero_fire", faction_name = "3k_main_faction_cao_cao" },
            {character_for_template = "3k_main_template_historical_xu_huang_hero_metal", faction_name = "3k_main_faction_cao_cao" },
            {character_for_template = "3k_main_template_historical_zhang_zhao_hero_water", faction_name = "3k_dlc05_faction_sun_ce" },
            {character_for_template = "3k_main_template_historical_zhang_hong_hero_water", faction_name = "3k_dlc05_faction_sun_ce" },
            {character_for_template = "3k_dlc07_template_historical_lady_zhen_water", faction_name = "3k_main_faction_cao_cao" },
            {character_for_template = "3k_main_template_historical_taishi_ci_hero_metal", faction_name = "3k_dlc05_faction_sun_ce" },
            {character_for_template = "3k_main_template_historical_gan_ning_hero_fire", faction_name = "3k_dlc05_faction_sun_ce" },
            {character_for_template = "3k_dlc04_template_historical_zhang_jue_healer", faction_name = "3k_dlc04_faction_zhang_jue" },
            {character_for_template = "3k_dlc04_template_historical_zhang_liang_veteran", faction_name = "3k_dlc04_faction_zhang_liang" },
            {character_for_template = "3k_dlc04_template_historical_zhang_bao_veteran", faction_name = "3k_dlc04_faction_zhang_bao" },
        }
        
        local function character_in_faction_reapply_effect(character_for_template, faction_name)
            local character = cm:query_model():character_for_template(character_for_template)
            if character
            and not character:is_null_interface()
            and not character:is_dead()
            then
                if character:faction():name() == faction_name
                and not character:faction():is_human()
                then
                    cm:modify_character(character):apply_effect_bundle("essentials_effect_bundle",-1);
                else
                    cm:modify_character(character):remove_effect_bundle("essentials_effect_bundle",-1);
                end
            end
        end
        
        if cm:query_model():campaign_name() == "3k_dlc07_start_pos" and not cm:get_saved_value("roguelike_mode") then
            for _,i in ipairs(chat_list_wait_for_reapply_effect) do
                character_in_faction_reapply_effect(i.character_for_template, i.faction_name)
            end
            --严颜
            local yan_yan = cm:query_model():character_for_template("hlyjdb")
            if yan_yan
            and not yan_yan:is_null_interface() 
            and not yan_yan:is_dead()
            then
                if (yan_yan:faction():name() == "3k_main_faction_liu_bei" or yan_yan:faction():name() == "3k_main_faction_liu_yan")
                and not yan_yan:faction():is_human()
                and valid_check()
                then
                    cm:modify_character(yan_yan):apply_effect_bundle("essentials_effect_bundle",-1);
                else
                    cm:modify_character(yan_yan):remove_effect_bundle("essentials_effect_bundle",-1);
                end
            end
            
        end
        
        --夜兰
        local yelan = cm:query_model():character_for_template("hlyjcy")
        if yelan
        and not yelan:is_null_interface() 
        and not yelan:is_dead()
        then
            if not yelan:is_spy() then
                cm:modify_character(yelan):set_undercover_character_enabler(true);        
            end
        end
                   
        --吟霖
        local yinlin = cm:query_model():character_for_template("hlyjdi")
        if yinlin
        and not yinlin:is_null_interface() 
        and not yinlin:is_dead()
        then
            if not yinlin:is_spy() then
                --cm:modify_character(yinlin):set_undercover_character_enabler(false);  
                cm:modify_character(yinlin):set_undercover_character_enabler(true);        
            end
        end
                   
        --符玄
        local fuxuan = cm:query_model():character_for_template("hlyjdp")
        if fuxuan
        and not fuxuan:is_null_interface() 
        and not fuxuan:is_dead()
        then
            if not fuxuan:is_spy() then
                --cm:modify_character(yinlin):set_undercover_character_enabler(false);  
                cm:modify_character(fuxuan):set_undercover_character_enabler(true);        
            end
        end
        
        --八重神子
--         local yae_miko = cm:query_model():character_for_template("hlyjdo")
--         if yae_miko
--         and not yae_miko:is_null_interface() 
--         and not yae_miko:is_dead()
--         and not yae_miko:is_character_is_faction_recruitment_pool()
--         and gst.faction_is_character_deployed(yae_miko)
--         then
--             local military_force = gst.faction_find_character_military_force(yae_miko)
--             for i = 0, military_force:character_list():num_items() - 1 do
--                 local character = military_force:character_list():item_at(i);
--                 if character:generation_template_key() ~= "hlyjcu"
--                 and character:generation_template_key() ~= "hlyjcm"
--                 and character:generation_template_key() ~= "hlyjco"
--                 then
--                     cm:modify_character(yae_miko):apply_relationship_trigger_set(character, "3k_xyy_relationship_trigger_set_someone_and_miko");
--                 end
--             end
--         end
        
        for i, v in ipairs(gst.xyy_character_list) do
            local character = cm:query_model():character_for_template(v)
            if character
            and not character:is_null_interface()
            and not character:is_dead()
            and cm:modify_character(character):ceo_management()
            and not cm:modify_character(character):ceo_management():is_null_interface()
            then
                ModLog("清除" .. v .. "伤残")
                cm:set_saved_value("is_wounded"..v,0);
                cm:modify_character(character):ceo_management():remove_ceos("3k_main_ceo_trait_physical_one-eyed");
                cm:modify_character(character):ceo_management():remove_ceos("3k_ytr_ceo_trait_physical_sprained_ankle");
                cm:modify_character(character):ceo_management():remove_ceos("3k_main_ceo_trait_physical_scarred");
                cm:modify_character(character):ceo_management():remove_ceos("3k_main_ceo_trait_physical_maimed_arm");
                cm:modify_character(character):ceo_management():remove_ceos("3k_main_ceo_trait_physical_maimed_leg");
            end
        end

        --雷电将军
        local hlyjcm = cm:query_model():character_for_template("hlyjcm")
        if hlyjcm
        and not hlyjcm:is_null_interface() 
        and not hlyjcm:is_dead()
        then
            if hlyjcm:faction():faction_leader():generation_template_key() == "hlyjcm" 
            and not hlyjcm:faction():is_human()
            then
                cm:modify_character(hlyjcm):apply_effect_bundle("essentials_effect_bundle",-1);
            else
                cm:modify_character(hlyjcm):remove_effect_bundle("essentials_effect_bundle",-1);
            end
        end
        
        --九条裟罗
        local hlyjdf = cm:query_model():character_for_template("hlyjdf")
        if hlyjdf
        and not hlyjdf:is_null_interface() 
        and not hlyjdf:is_dead()
        then
            if hlyjdf:faction():faction_leader():generation_template_key() == "hlyjcm" 
            and not hlyjdf:faction():is_human()
            then
                cm:modify_character(hlyjdf):apply_effect_bundle("essentials_effect_bundle",-1);
            else
                cm:modify_character(hlyjdf):remove_effect_bundle("essentials_effect_bundle",-1);
            end
        end
        
        -- 五子良将
        local zhang_he = cm:query_model():character_for_template("3k_main_template_historical_zhang_he_hero_fire")
        if zhang_he
        and not zhang_he:is_null_interface() 
        and not zhang_he:is_dead()
        then
            if zhang_he:faction():name() == "3k_main_faction_cao_cao" 
            and not cm:get_saved_value("zhang_he_is_wei_elite_general")
            then
                cm:modify_character(zhang_he):ceo_management():add_ceo("3k_main_ceo_trait_physical_wei_elite_general");
                cm:set_saved_value("zhang_he_is_wei_elite_general", true)
            end
        end
        local zhang_liao = cm:query_model():character_for_template("3k_main_template_historical_zhang_liao_hero_metal")
        if zhang_liao
        and not zhang_liao:is_null_interface() 
        and not zhang_liao:is_dead()
        then
            if zhang_liao:faction():name() == "3k_main_faction_cao_cao" 
            and not cm:get_saved_value("zhang_liao_is_wei_elite_general")
            then
                cm:modify_character(zhang_liao):ceo_management():add_ceo("3k_main_ceo_trait_physical_wei_elite_general");
                cm:set_saved_value("zhang_liao_is_wei_elite_general", true)
            end
        end
        local yu_jin = cm:query_model():character_for_template("3k_main_template_historical_yu_jin_hero_metal")
        if yu_jin
        and not yu_jin:is_null_interface() 
        and not yu_jin:is_dead()
        then
            if yu_jin:faction():name() == "3k_main_faction_cao_cao" 
            and not cm:get_saved_value("yu_jin_is_wei_elite_general")
            then
                cm:modify_character(yu_jin):ceo_management():add_ceo("3k_main_ceo_trait_physical_wei_elite_general");
                cm:set_saved_value("yu_jin_is_wei_elite_general", true)
            end
        end
        local yue_jin = cm:query_model():character_for_template("3k_main_template_historical_yue_jin_hero_metal")
        if yue_jin
        and not yue_jin:is_null_interface() 
        and not yue_jin:is_dead()
        then
            if yue_jin:faction():name() == "3k_main_faction_cao_cao" 
            and not cm:get_saved_value("yue_jin_is_wei_elite_general")
            then
                cm:modify_character(yue_jin):ceo_management():add_ceo("3k_main_ceo_trait_physical_wei_elite_general");
                cm:set_saved_value("yue_jin_is_wei_elite_general", true)
            end
        end
        local xu_huang = cm:query_model():character_for_template("3k_main_template_historical_xu_huang_hero_metal")
        if xu_huang
        and not xu_huang:is_null_interface() 
        and not xu_huang:is_dead()
        then
            if xu_huang:faction():name() == "3k_main_faction_cao_cao" 
            and not cm:get_saved_value("xu_huang_is_wei_elite_general")
            then
                cm:modify_character(xu_huang):ceo_management():add_ceo("3k_main_ceo_trait_physical_wei_elite_general");
                cm:set_saved_value("xu_huang_is_wei_elite_general", true)
            end
        end
        
        -- 五虎上将
        local ma_chao = cm:query_model():character_for_template("3k_main_template_historical_ma_chao_hero_fire")
        if ma_chao
        and not ma_chao:is_null_interface() 
        and not ma_chao:is_dead()
        then
            if ma_chao:faction():name() == "3k_main_faction_liu_bei" 
            and not cm:get_saved_value("ma_chao_is_shu_tiger_general")
            then
                cm:modify_character(ma_chao):ceo_management():add_ceo("3k_main_ceo_trait_physical_shu_tiger_general");
                cm:set_saved_value("ma_chao_is_shu_tiger_general", true)
            end
        end
        
        local guan_yu = cm:query_model():character_for_template("3k_main_template_historical_guan_yu_hero_wood")
        if guan_yu
        and not guan_yu:is_null_interface() 
        and not guan_yu:is_dead()
        then
            if guan_yu:faction():name() == "3k_main_faction_liu_bei" 
            and not cm:get_saved_value("guan_yu_is_shu_tiger_general")
            then
                cm:modify_character(guan_yu):ceo_management():add_ceo("3k_main_ceo_trait_physical_shu_tiger_general");
                cm:set_saved_value("guan_yu_is_shu_tiger_general", true)
            end
        end
        
        local zhang_fei = cm:query_model():character_for_template("3k_main_template_historical_zhang_fei_hero_fire")
        if zhang_fei
        and not zhang_fei:is_null_interface() 
        and not zhang_fei:is_dead()
        then
            if zhang_fei:faction():name() == "3k_main_faction_liu_bei" 
            and not cm:get_saved_value("zhang_fei_is_shu_tiger_general")
            then
                cm:modify_character(zhang_fei):ceo_management():add_ceo("3k_main_ceo_trait_physical_shu_tiger_general");
                cm:set_saved_value("zhang_fei_is_shu_tiger_general", true)
            end
        end
        local zhao_yun = cm:query_model():character_for_template("3k_main_template_historical_zhao_yun_hero_metal")
        if zhao_yun
        and not zhao_yun:is_null_interface() 
        and not zhao_yun:is_dead()
        then
            if zhao_yun:faction():name() == "3k_main_faction_liu_bei" 
            and not cm:get_saved_value("zhao_yun_is_shu_tiger_general")
            then
                cm:modify_character(zhao_yun):ceo_management():add_ceo("3k_main_ceo_trait_physical_shu_tiger_general");
                cm:set_saved_value("zhao_yun_is_shu_tiger_general", true)
            end
        end
        local huang_zhong = cm:query_model():character_for_template("3k_main_template_historical_huang_zhong_hero_metal")
        if huang_zhong
        and not huang_zhong:is_null_interface() 
        and not huang_zhong:is_dead()
        then
            if huang_zhong:faction():name() == "3k_main_faction_liu_bei" 
            and not cm:get_saved_value("huang_zhong_is_shu_tiger_general")
            then
                cm:modify_character(huang_zhong):ceo_management():add_ceo("3k_main_ceo_trait_physical_shu_tiger_general");
                cm:set_saved_value("huang_zhong_is_shu_tiger_general", true)
            end
        end
    end,
    true
)

--真理医生附件
core:add_listener(
    "ratio_ceo_change",
    "CharacterCeoChanged",
    function(context)
        return context:query_character():generation_template_key() == "hlyjcw"
        and context:ceo_equipment_slot():category_key() == "3k_main_ceo_category_ancillary_accessory";
    end,
    function(context)
        local query_character = context:query_character(); 
        local character_modifier = context:modify_character(); 
        if query_character:ceo_management():has_ceo_equipped("hlyjcwfujian") then
            character_modifier:ceo_management():remove_ceos("hlyjcwchenghao2"); 
            character_modifier:ceo_management():add_ceo("hlyjcwchenghao"); 
        else
            character_modifier:ceo_management():remove_ceos("hlyjcwchenghao"); 
            character_modifier:ceo_management():add_ceo("hlyjcwchenghao2"); 
        end
    end,
    true
)

--今汐武器自动切换
core:add_listener(
    "jinhsi_ceo_change",
    "CharacterCeoChanged",
    function(context)
        return context:query_character():generation_template_key() == "hlyjdl"
        and not context:query_character():is_character_is_faction_recruitment_pool()
        and context:ceo_equipment_slot():category_key() == "3k_main_ceo_category_ancillary_armour";
    end,
    function(context)
        local query_character = context:query_character(); 
        local character_modifier = context:modify_character(); 
        local faction = query_character:faction(); 
        character_modifier:ceo_management():add_scripted_permission("3k_main_ceo_group_ancillary_weapon_character_axe_two_handed")
        if query_character:ceo_management():has_ceo_equipped("hlyjdlyifu2") then
            character_modifier:ceo_management():add_ceo("hlyjdlwuqi2"); 
            ancillaries:equip_ceo_on_character(query_character, "hlyjdlwuqi2", "3k_main_ceo_category_ancillary_weapon");
            cm:modify_faction(faction):ceo_management():remove_ceos("hlyjdlwuqi"); 
        elseif query_character:ceo_management():has_ceo_equipped("hlyjdlyifu") then
            cm:modify_faction(faction):ceo_management():add_ceo("hlyjdlwuqi");
            character_modifier:ceo_management():remove_ceos("hlyjdlwuqi2");  
            ancillaries:equip_ceo_on_character(query_character, "hlyjdlwuqi", "3k_main_ceo_category_ancillary_weapon");
        end
    end,
    true
) 

--刘协成为天子
core:add_listener(
    "emperor_xian_check",
    "CharacterAssignedToPost",
	function(context)
        local character = context:query_character()
        return character:generation_template_key() == "3k_dlc04_template_historical_emperor_xian_earth"
        and character:character_post():ministerial_position_record_key() == "faction_leader"
	end,
	function(context)
        local character = context:query_character()
        local query_faction = character:faction()
        if query_faction:is_world_leader() then
            cm:modify_character(character):ceo_management():remove_ceos("3k_main_ceo_career_historical_liu_xie");
            cm:modify_character(character):ceo_management():add_ceo("3k_main_ceo_career_historical_liu_xie_emperor");
        end
	end,
	true
)

--流萤附件
core:add_listener(
    "firefly_sam_equip",
    "PendingBattle",
    function(context)
        --local firefly = cm:query_model():character_for_template("hlyjdj")
        --ModLog("PendingBattle".. context:query_character():generation_template_key())
        return true;
    end,
    function(context)
        local pb = cm:query_model():pending_battle();
        if pb:human_involved() then
            local firefly = cm:query_model():character_for_template("hlyjdj");
            if firefly
            and not firefly:is_null_interface()
            and not firefly:is_dead()
            then
                local character_modifier = cm:modify_character(firefly);
                if firefly:ceo_management():has_ceo_equipped("hlyjdingzhicfujian") then
                    character_modifier:ceo_management():remove_ceos("hlyjdjchenghao"); 
                    character_modifier:ceo_management():add_ceo("hlyjdjchenghao2"); 
                else
                    character_modifier:ceo_management():remove_ceos("hlyjdjchenghao2"); 
                    character_modifier:ceo_management():add_ceo("hlyjdjchenghao"); 
                end
            end
        end
    end,
    true
)

core:add_listener(
    "firefly_sam_unequip",
    "BattleCompletedCameraMove",
    function(context)
        --local firefly = cm:query_model():character_for_template("hlyjdj")
        --ModLog("PendingBattle".. context:query_character():generation_template_key())
        return true;
    end,
    function(context)
        local firefly = cm:query_model():character_for_template("hlyjdj");
        if firefly
        and not firefly:is_null_interface()
        and not firefly:is_dead()
        then
            local character_modifier = cm:modify_character(firefly);
            character_modifier:ceo_management():remove_ceos("hlyjdjchenghao2"); 
            character_modifier:ceo_management():add_ceo("hlyjdjchenghao"); 
        end
    end,
    true
)

--吞并附庸
core:add_listener(
    "AnnexVassalEvent", 
    "FactionTurnStart",
    function(context)
        return false;
    end,
    function(context)        
        local faction_key = context:faction():name();
        local vassal_list = diplomacy_manager:get_all_vassal_factions(faction_key);
        
        if vassal_list and vassal_list:num_items() == 0 then
            return false;
        end;
        
        if gst.faction_check_all_adjacent_factions_is_allies(faction_key) then
            local num = cm:random_int(1, vassal_list:num_items()) - 1
            diplomacy_manager:apply_automatic_deal_between_factions(faction_key, vassal_list:item_at(num):name(), "data_defined_situation_annex_vassal", true);
        end;
    end,
    true
);

--希儿特效
core:add_listener(
    "seele_effect",
    "BattleCompletedCameraMove",
    function(context)
        local seele = cm:query_model():character_for_template("hlyjcz")
        return not seele:is_null_interface() and not seele:is_dead() and not seele:is_wounded()
    end,
    function(context)
        local seele = cm:query_model():character_for_template("hlyjcz")
        local pb = cm:query_model():pending_battle();
        if pb:has_attacker() then
            if pb:attacker():generation_template_key() == "hlyjcz"
            and seele:won_battle()
            then
                if seele:has_military_force() then
                    --local modify_force = cm:modify_model():get_modify_military_force(seele:military_force());
                    cm:modify_character(seele):enable_movement();
                    cm:modify_character(seele):replenish_action_points();
                end
            end
        end
    end,
    true
)

core:add_listener(
    "ratio_ceo_unequipped",
    "CharacterCeoUnequipped",
    function(context)
        return context:query_character():generation_template_key() == "hlyjcw"
        and context:ceo_equipment_slot():category_key() == "3k_main_ceo_category_ancillary_accessory";
    end,
    function(context)
        local query_character = context:query_character(); 
        local character_modifier = context:modify_character(); 
        if query_character:ceo_management():has_ceo_equipped("hlyjcwfujian") then
            character_modifier:ceo_management():remove_ceos("hlyjcwchenghao2"); 
            character_modifier:ceo_management():add_ceo("hlyjcwchenghao"); 
        else
            character_modifier:ceo_management():remove_ceos("hlyjcwchenghao"); 
            character_modifier:ceo_management():add_ceo("hlyjcwchenghao2"); 
        end
    end,
    true
)

core:add_listener(
    "ratio_ceo_equipped",
    "CharacterCeoEquipped",
    function(context)
        return context:query_character():generation_template_key() == "hlyjcw"
        and context:ceo_equipment_slot():category_key() == "3k_main_ceo_category_ancillary_accessory";
    end,
    function(context)
        local query_character = context:query_character(); 
        local character_modifier = context:modify_character(); 
        if query_character:ceo_management():has_ceo_equipped("hlyjcwfujian") then
            character_modifier:ceo_management():remove_ceos("hlyjcwchenghao2"); 
            character_modifier:ceo_management():add_ceo("hlyjcwchenghao"); 
        else
            character_modifier:ceo_management():remove_ceos("hlyjcwchenghao"); 
            character_modifier:ceo_management():add_ceo("hlyjcwchenghao2"); 
        end
    end,
    true
)

core:add_listener(
    "wangsheng_funeral_parlor_incident", -- UID
    "CharacterDied", -- Campaign event
    function(context)
        return context:query_character():faction():is_human() 
        and context:was_recruited_in_faction() 
        and context:query_character():character_type("general")
    end,
    function(context)
        local query_faction = context:query_character():faction()
        local hu_tao = cm:query_model():character_for_template("hlyjcx");
        if
        hu_tao
        and not hu_tao:is_null_interface()
        and not hu_tao:is_dead()
        and not hu_tao:is_character_is_faction_recruitment_pool() 
        and hu_tao:faction():name() == query_faction:name()
        then
            local incident = cm:modify_model():create_incident("wangsheng_funeral_parlor_incident");
            incident:add_character_target("target_character_1", hu_tao);
            incident:trigger(cm:modify_faction(query_faction), true);
        end
    end,
    true
)

core:add_listener(
    "jinqianhuaA0shijian_dilemma", -- UID
    "DilemmaChoiceMadeEvent", -- CampaignEvent
    function(context) 
        return context:dilemma() == "jqhA0shijian";
    end, -- criteria
    function (context) --what to do if listener fires
        if context:choice() == 0 then
            local hlyjbz = gst.character_add_to_faction("hlyjbz", context:faction():name(), "3k_general_wood");
            cm:modify_character(hlyjbz):set_is_deployable(true)
            cm:trigger_dilemma(context:faction():name(),"jqhA1shijian", true);
        end
    end,
    false
)

core:add_listener(
    "jinqianhuaA6shijian_dilemma", -- UID
    "DilemmaChoiceMadeEvent", -- CampaignEvent
    function(context) 
        return context:dilemma() == "jqhA6shijian"  
        or context:dilemma() == "jqhB5shijian"
        or context:dilemma() == "jqhC5shijian"
        or context:dilemma() == "jqhD5shijian"
    end, -- criteria
    function (context) --what to do if listener fires
        --local jin_qianhua = cm:query_model():character_for_template("hlyjbz")
        gst.character_runaway("hlyjbz")
        local hlyjbz = gst.character_add_to_faction("hlyjbz", context:faction():name(), "3k_general_wood");
        cm:modify_character(hlyjbz):set_is_deployable(false)
        local target_player_character = context:faction():faction_leader()
        local mission = string_mission:new("go_to_taishan")
        if target_player_character:startpos_key() then
            mission:add_primary_objective("MOVE_TO_REGION", {"start_pos_character ".. target_player_character:startpos_key() .. ";region 3k_main_penchang_resource_1"});
        else
            mission:add_primary_objective("MOVE_TO_REGION", {"region 3k_main_penchang_resource_1"})
        end
        mission:add_primary_payload("text_display{lookup unknown;}")
        mission:trigger_mission_for_faction(context:faction():name())
    end,
    false
)

core:add_listener(
    "go_to_taishan_listener",
    "CharacterFinishedMovingEvent",
    function(context)
        local query_character = context:query_character()
        local faction = query_character:faction()
        return query_character
        and not query_character:is_null_interface()
        and not query_character:is_dead()
        and faction
        and not faction:is_null_interface()
        and context:query_character():faction():is_mission_active("go_to_taishan")
        and query_character:region()
        and not query_character:region():is_null_interface()
        and query_character:region():name() == "3k_main_penchang_resource_1"
    end,
    function(context)
        local query_character = context:query_character()
        local faction = query_character:faction()
        ModLog(gst.character_get_string_name(query_character) .. query_character:region():name());
        if gst.faction_is_character_in_force(faction:faction_leader(), gst.faction_find_character_military_force(query_character)) then
            cm:modify_faction(faction):complete_custom_mission("go_to_taishan")
        end
    end,
    true
)

core:add_listener(
    "go_to_taishan_success",
    "MissionSucceeded",
    function(context)
        return 
        context:mission():mission_record_key() == "go_to_taishan";
    end,
    function(context)
        cm:set_saved_value("jqhA0shijian", true)
    end,
    false
)

core:add_listener(
    "go_to_taishan_success_2",
    "FactionTurnStart",
    function(context)
        return context:faction():is_human() and cm:get_saved_value("jqhA0shijian");
    end,
    function(context)
        local hlyjbz = cm:query_model():character_for_template("hlyjbz")
        if hlyjbz:ceo_management():has_ceo_equipped("AB5texing") then
            ModLog("jqhB6shijian");
            cm:trigger_dilemma(hlyjbz:faction():name(),"jqhB6shijian", true);
        elseif hlyjbz:ceo_management():has_ceo_equipped("AC5texing") then
            ModLog("jqhC6shijian");
            cm:trigger_dilemma(hlyjbz:faction():name(),"jqhC6shijian", true);
        elseif hlyjbz:ceo_management():has_ceo_equipped("AD5texing") then
            ModLog("jqhD6shijian");
            cm:trigger_dilemma(hlyjbz:faction():name(),"jqhD6shijian", true);
        elseif hlyjbz:ceo_management():has_ceo_equipped("AA6texing") then
            ModLog("jqhA7shijian");
            cm:trigger_dilemma(hlyjbz:faction():name(),"jqhA7shijian", true);
        else
            ModLog("None");
        end
    end,
    true
)

core:add_listener(
    "jinqianhuaA7shijian_dilemma", -- UID
    "DilemmaChoiceMadeEvent", -- CampaignEvent
    function(context) 
        return context:dilemma() == "jqhA7shijian"  
        or context:dilemma() == "jqhB6shijian"
        or context:dilemma() == "jqhC6shijian"
        or context:dilemma() == "jqhD6shijian"
    end, -- criteria
    function (context)
        local hlyjbz = gst.character_query_for_template("hlyjbz")
        cm:modify_character(hlyjbz):set_is_deployable(true)
        if context:dilemma() == "jqhA7shijian" and context:choice() == 0 then
            gst.faction_create_military_force(hlyjbz:faction():name(), "3k_main_penchang_resource_1", hlyjbz)
        end
        if context:dilemma() == "jqhA7shijian" and context:choice() == 1 then
            cm:modify_character(context:faction():faction_leader()):wound_character();
            gst.character_runaway("hlyjbz");
        end
        if context:dilemma() == "jqhB6shijian" and context:choice() == 0 then
            gst.faction_create_military_force(hlyjbz:faction():name(), "3k_main_penchang_resource_1", hlyjbz)
        end
        if context:dilemma() == "jqhB6shijian" and context:choice() == 1 then
            cm:modify_character(context:faction():faction_leader()):wound_character();
            gst.character_runaway("hlyjbz");
        end
        if context:dilemma() == "jqhC6shijian" and context:choice() == 0 then
            gst.character_runaway("hlyjbz");
        end
        if context:dilemma() == "jqhC6shijian" and context:choice() == 1 then
            cm:modify_character(context:faction():faction_leader()):wound_character();
            gst.character_runaway("hlyjbz");
        end
        if context:dilemma() == "jqhD6shijian" and context:choice() == 0 then
            cm:modify_character(context:faction():faction_leader()):wound_character();
            gst.character_runaway("hlyjbz");
        end
        if context:dilemma() == "jqhD6shijian" and context:choice() == 1 then
            gst.character_been_killed(context:faction():faction_leader());
            gst.character_runaway("hlyjbz");
        end
        cm:set_saved_value("jqhA0shijian", false)
    end,
    false
)

core:add_listener(
    "jinqianhuaending", -- UID
    "DilemmaIssuedEvent", -- CampaignEvent
    function(context) 
        return context:dilemma() == "jqhB7shijian"  
        or context:dilemma() == "jqhA8shijian"
    end, -- criteria
    function (context)
        local hlyjbz = gst.character_add_to_faction("hlyjbz",context:faction():name(),"3k_general_wood");
        cm:modify_character(hlyjbz):set_is_deployable(true)
    end,
    false
)

core:add_listener(
    "testdilemmachoice", -- UID
    "DilemmaChoiceMadeEvent", -- CampaignEvent
    function(context) 
        return context:dilemma() == "hexie_script"  
    end, -- criteria
    function (context) --what to do if listener fires
        if context:choice() == 0 then
            if not cm:query_model():is_multiplayer() then
                gst.faction_add_tickets(context:faction():name(), 50)
            else
                gst.faction_add_tickets(cm:get_saved_value("xyy_1p"), 50)
                gst.faction_add_tickets(cm:get_saved_value("xyy_2p"), 50)
            end
            gst.character_been_killed("hlyjk");
            gst.character_been_killed("hlyjn");
            gst.character_been_killed("hlyjr");
            gst.character_been_killed("hlyju");
            gst.character_been_killed("hlyjx");
            gst.character_been_killed("hlyjba");
            gst.character_been_killed("hlyjbc");
            gst.character_been_killed("hlyjbn");
            gst.character_been_killed("hlyjcc");
            gst.character_been_killed("hlyjbo");
            
            if cm:query_model():campaign_name() ~= "3k_dlc04_start_pos" 
            and cm:query_model():campaign_name() ~= "8p_start_pos" 
            then
                if not cm:query_faction("xyyhlyje"):is_human() then
                    gst.region_set_manager("3k_main_yizhou_island_capital", "xyy");
                end;
                
                if not cm:query_faction("xyyhlyjd"):is_human() then
                    gst.region_set_manager("3k_dlc06_liaodong_capital", "3k_main_faction_gongsun_du");
                end;
                
                if cm:query_model():campaign_name() == "3k_main_campaign_map" then
                    if not cm:query_faction("xyyhlyjc"):is_human() then
                        gst.region_set_manager("3k_dlc06_xiapi_capital", "3k_main_faction_tao_qian");
                    end;
                    if not cm:query_faction("xyyhlyjb"):is_human() then
                        cm:modify_region("3k_main_luoyang_capital"):raze_and_abandon_settlement_without_attacking();
                        gst.character_add_to_recruit_pool("hlyjj","3k_main_faction_yuan_shao","3k_general_earth", false)
                        gst.character_add_to_recruit_pool("hlyjt","3k_main_faction_cao_cao","3k_general_earth", false)
                        gst.character_add_to_recruit_pool("hlyjo","3k_main_faction_sun_jian","3k_general_metal", false)
                        gst.character_add_to_recruit_pool("hlyjl","3k_main_faction_lu_bu","3k_general_water", false)
                        gst.character_add_to_recruit_pool("hlyjm","3k_main_faction_liu_biao","3k_general_wood", false)
                    end;
                end
                
                if cm:query_model():campaign_name() == "3k_dlc05_start_pos" then
                    if not cm:query_faction("xyyhlyjc"):is_human() then
                        gst.region_set_manager("3k_dlc06_xiapi_capital", "3k_main_faction_liu_bei");
                    end;
                    if not cm:query_faction("xyyhlyjb"):is_human() then
                        gst.region_set_manager("3k_main_shoufang_capital", "3k_main_faction_zhang_yan");
                        gst.character_add_to_recruit_pool("hlyjj","3k_main_faction_yuan_shao","3k_general_earth", false)
                        gst.character_add_to_recruit_pool("hlyjt","3k_main_faction_cao_cao","3k_general_earth", false)
                        gst.character_add_to_recruit_pool("hlyjo","3k_dlc05_faction_sun_ce","3k_general_metal", false)
                        gst.character_add_to_recruit_pool("hlyjl","3k_main_faction_lu_bu","3k_general_water", false)
                        gst.character_add_to_recruit_pool("hlyjm","3k_main_faction_liu_biao","3k_general_wood", false)
                    end;
                end
                
                if cm:query_model():campaign_name() == "3k_dlc07_start_pos" then
                    if not cm:query_faction("xyyhlyjc"):is_human() then
                        gst.region_set_manager("3k_dlc06_xiapi_capital", "3k_main_faction_liu_bei");
                    end;
                    if not cm:query_faction("xyyhlyjb"):is_human() then
                        gst.region_set_manager("3k_main_yanmen_capital", "3k_main_faction_gao_gan");
                        gst.character_add_to_recruit_pool("hlyjj","3k_main_faction_yuan_shao","3k_general_earth", false)
                        gst.character_add_to_recruit_pool("hlyjt","3k_main_faction_cao_cao","3k_general_earth", false)
                        if cm:random_int(0, 100) > 50 then
                            gst.character_add_to_recruit_pool("hlyjo","3k_dlc05_faction_sun_ce","3k_general_metal", false)
                        else
                            gst.character_add_to_recruit_pool("hlyjo","3k_main_faction_yuan_shao","3k_general_metal", false)
                        end
                        if cm:random_int(0, 100) > 50 then
                            gst.character_add_to_recruit_pool("hlyjl","3k_main_faction_liu_bei","3k_general_water", false)
                        else
                            gst.character_add_to_recruit_pool("hlyjl","3k_dlc05_faction_sun_ce","3k_general_water", false)
                        end
                        if cm:random_int(0, 100) > 50 then
                            gst.character_add_to_recruit_pool("hlyjm","3k_main_faction_liu_biao","3k_general_wood", false)
                        else
                            gst.character_add_to_recruit_pool("hlyjm","3k_main_faction_yuan_shao","3k_general_wood", false)
                        end
                    end;
                end
            end
        end
        if context:choice() == 2 then
            gst.character_been_killed("hlyjk");
            gst.character_been_killed("hlyjn");
            gst.character_been_killed("hlyjr");
            gst.character_been_killed("hlyju");
            gst.character_been_killed("hlyjx");
            gst.character_been_killed("hlyjba");
            gst.character_been_killed("hlyjbc");
            gst.character_been_killed("hlyjbn");
            gst.character_been_killed("hlyjcc");
            gst.character_been_killed("hlyjbo");
        end
        --:trigger_dilemma(cm:query_local_faction():name(),"roguelike_dilemma", true);
        if not cm:query_model():is_multiplayer() then
            cm:trigger_dilemma(cm:query_local_faction():name(),"roguelike_dilemma", true);
        else
            cm:set_saved_value("time", "first")
            cm:set_saved_value("xyy_page", 0)
            character_browser_multiplayer_1p_1();
--          cm:trigger_dilemma(cm:query_model():world():whose_turn_is_it():name(), "mp_character_event", true);
        end
    end,   
    false -- is persistent
)

core:add_listener(
    "testdilemmachoice2", -- UID
    "DilemmaChoiceMadeEvent", -- CampaignEvent
    function(context) 
        return context:dilemma() == "hexie2_script"  
    end, -- criteria
    function (context) --what to do if listener fires
        if context:choice() == 0 then
            character_browser();
        else
            gst.character_browser_disable()
            core:remove_listener("character_join_event")
            cm:set_saved_value("character_join_or_dont", nil)
        end
    end,   
    false -- is persistent
)

core:add_listener(
    "yaomingyueshijian", -- UID
    "DilemmaChoiceMadeEvent", -- CampaignEvent
    function(context) 
        return context:dilemma() == "C3shijian" or context:dilemma() == "D3shijian" or context:dilemma() == "E6shijian"
    end, -- criteria
    function (context) --what to do if listener fires
        local query_faction = context:faction();
        local query_leader = query_faction:faction_leader();
        local hlyjz = cm:query_model():character_for_template("hlyjz")
        local modify_hlyjz = cm:modify_character(hlyjz)
        local modify_leader = cm:modify_character(query_leader)
        modify_hlyjz:apply_relationship_trigger_set(query_leader, "3k_main_relationship_trigger_set_event_negative_generic_extreme");
        modify_leader:apply_relationship_trigger_set(hlyjz, "3k_main_relationship_trigger_set_event_negative_betrayed");
        --检测董卓派系
        local dongzhuo_faction = cm:query_faction("3k_main_faction_dong_zhuo");
        if not dongzhuo_faction or dongzhuo_faction:is_null_interface() or dongzhuo_faction:is_dead() or dongzhuo_faction:is_human() then
            ModLog("董卓派系已经不存在，加入新派系");
            --获取派系列表
            local world_faction_list = cm:query_model():world():faction_list();
            local random_faction = world_faction_list:item_at(cm:random_int(world_faction_list:num_items()-1, 0));
            while (not random_faction or random_faction:is_null_interface() or random_faction:is_dead() or random_faction:is_human())
            do
                random_faction = world_faction_list:item_at(cm:random_int(world_faction_list:num_items()-1, 0));
            end
            --加入随机派系
            ModLog("姚明月加入了" .. random_faction:name() .. "加入新派系");
            gst.character_add_to_faction("hlyjz",random_faction:name(),"3k_general_water");
            --cm:modify_character(hlyjz):move_to_faction_and_make_recruited(random_faction:name());
        else
            ModLog("姚明月加入了3k_main_faction_dong_zhuo加入新派系");
            gst.character_add_to_faction("hlyjz","3k_main_faction_dong_zhuo","3k_general_water");
            --cm:modify_character(hlyjz):move_to_faction_and_make_recruited("3k_main_faction_dong_zhuo");
        end
        if context:dilemma() == "D3shijian" then
            if context:choice() == 0 then
                gst.faction_random_kill_character(query_faction,1);
            else
                modify_leader:kill_character(false);
            end
        end
    end,   
    false -- is persistent
)

core:add_listener(
    "3k_main_dilemma_regent",
    "DilemmaChoiceMadeEvent",
    function(context)
        return context:dilemma() == "3k_main_dilemma_regent" or context:dilemma() == "3k_main_dilemma_fate_of_emperor";
    end,
    function(context)
        local faction = context:faction()
        ModLog(context:choice());
        if context:choice() == 2 then
            ModLog("皇帝禅让");
            cm:modify_faction(faction:name()):apply_effect_bundle("world_leader",-1);
            gst.character_add_to_faction("3k_dlc04_template_historical_emperor_xian_earth",faction:name(),"3k_general_earth");
        end        
    end,
    false
);

core:add_listener(
    "jqhA2shijian_dilemma",
    "DilemmaChoiceMadeEvent",
    function(context)
        return context:dilemma() == "jqhA2shijian";
    end,
    function(context)
        local faction = context:faction()
        ModLog(context:choice());
        if context:choice() == 0 then
            cm:modify_character(faction:faction_leader()):ceo_management():remove_ceos("3k_main_ceo_trait_physical_one-eyed"); 
            cm:modify_character(faction:faction_leader()):ceo_management():remove_ceos("3k_ytr_ceo_trait_physical_sprained_ankle");
            cm:modify_character(faction:faction_leader()):ceo_management():remove_ceos("3k_main_ceo_trait_physical_maimed_arm");
            cm:modify_character(faction:faction_leader()):ceo_management():remove_ceos("3k_main_ceo_trait_physical_maimed_leg");
            cm:modify_character(faction:faction_leader()):ceo_management():remove_ceos("3k_main_ceo_trait_physical_scarred"); 
        end        
    end,
    false
);
	
core:add_listener(
    "yaomingyuesummon", -- UID
    "DilemmaChoiceMadeEvent", -- CampaignEvent
    function(context) 
        return context:dilemma() == "mingyuewujiang_01"
        or context:dilemma() == "mingyuewujiang_01_mp"; 
    end, -- criteria
    function (context) --what to do if listener fires
        --local hlyjz = cm:query_model():character_for_template("hlyjz")
        --检测董卓派系
        if context:choice() == 2 or context:choice() == 3 then
            local dongzhuo_faction = cm:query_faction("3k_main_faction_dong_zhuo");
            if not dongzhuo_faction or dongzhuo_faction:is_null_interface() or dongzhuo_faction:is_dead() or dongzhuo_faction:is_human() then
                ModLog("董卓派系已经不存在，加入新派系");
                gst.character_join_random_faction("hlyjz", "3k_general_water");
                --cm:modify_character(hlyjz):move_to_faction_and_make_recruited(random_faction:name());
            else
                ModLog("姚明月加入了3k_main_faction_dong_zhuo加入新派系");
                gst.character_add_to_faction("hlyjz","3k_main_faction_dong_zhuo","3k_general_water");
                --cm:modify_character(hlyjz):move_to_faction_and_make_recruited("3k_main_faction_dong_zhuo");
            end
        end
        if context:choice() == 0 or context:choice() == 3 then
            local xyyhlyjb = cm:query_faction("xyyhlyjb") 
            if xyyhlyjb 
            and not xyyhlyjb:is_dead()
            and not xyyhlyjb:is_human()
            then
                gst.character_add_to_faction("hlyjq", "xyyhlyjb","3k_general_water")
                gst.character_add_to_faction("hlyjp", "xyyhlyjb","3k_general_fire")
                gst.character_add_to_faction("hlyjr", "xyyhlyjb","3k_general_fire")
            else
                gst.character_join_random_faction("hlyjq", "3k_general_water");
                gst.character_join_random_faction("hlyjp", "3k_general_fire");
                gst.character_join_random_faction("hlyjr", "3k_general_fire");
            end
        end
    end,   
    false -- is persistent
)

core:add_listener(
    "jinqianhuashijian", -- UID
    "DilemmaChoiceMadeEvent", -- CampaignEvent
    function(context) 
        return context:dilemma() == "jqhC7shijian" or context:dilemma() == "jqhD7shijian"
    end, -- criteria
    function(context) 
        local world_faction_list = cm:query_model():world():faction_list();
        local hlyjbz = cm:query_model():character_for_template("hlyjbz")
        local random_faction = world_faction_list:item_at(cm:random_int(world_faction_list:num_items() - 1,0));
        while (not random_faction or random_faction:is_null_interface() or random_faction:is_dead() or random_faction:is_human())
        do
            random_faction = world_faction_list:item_at(cm:random_int(world_faction_list:num_items() - 1,0));
        end
        --加入随机派系
        --gst.character_add_to_faction("hlyjbz",random_faction:name(),"3k_general_water");
        cm:modify_character(hlyjbz):move_to_faction_and_make_recruited(random_faction:name());
    end,   
    false -- is persistent
)

core:add_listener(
    "Furina_and_Neuvillette",
    "BattleCompleted",
    function(context)
        
        if cm:get_saved_value("furina_and_neuvillette") and cm:get_saved_value("furina_and_neuvillette") == 3 then
            return false;
        end
        
        local hlyjcl = cm:query_model():character_for_template("hlyjcl");
        local hlyjco = cm:query_model():character_for_template("hlyjco");
        
        if not hlyjcl 
        or not hlyjco 
        or hlyjcl:is_null_interface() 
        or hlyjco:is_null_interface() 
        or hlyjcl:is_dead() 
        or hlyjco:is_dead() 
        then
            return false;
        end
        
        
        local pb = cm:query_model():pending_battle();
        
        if not pb then
            return false;
        end
        
        if pb:has_attacker() then
            ModLog("Debug: BattleCompleted")
            local have_hlyjcl = false;
            local have_hlyjco = false;
            local attacker = pb:attacker()
            if attacker:has_military_force() then
                local attacker_force = attacker:military_force();
                for i = 0, attacker_force:character_list():num_items() - 1 do
                    ModLog(attacker_force:character_list():item_at(i):generation_template_key())
                    if attacker_force:character_list():item_at(i):generation_template_key() == "hlyjcl" then
                        have_hlyjcl = true;
                    end
                    if attacker_force:character_list():item_at(i):generation_template_key() == "hlyjco" then
                        have_hlyjco = true;
                    end
                    if have_hlyjcl and have_hlyjco then
                        if hlyjcl:won_battle() then
                            ModLog("Debug: BattleCompleted2")
                        end
                        return true;
                    end
                end
            end
        end
        
        if pb:has_defender() then
            ModLog("Debug: BattleCompleted4_2")
            local have_hlyjcl = false;
            local have_hlyjco = false;
            local defender = pb:defender()
            if defender:has_military_force() then
                local defender_force = defender:military_force();
                for i = 0, defender_force:character_list():num_items() - 1 do
                    ModLog(defender_force:character_list():item_at(i):generation_template_key())
                    if defender_force:character_list():item_at(i):generation_template_key() == "hlyjcl" then
                        have_hlyjcl = true;
                    end
                    if defender_force:character_list():item_at(i):generation_template_key() == "hlyjco" then
                        have_hlyjco = true;
                    end
                    if have_hlyjcl and have_hlyjco then
                        return true;
                    end
                end
            end
        end
        
        return false;
        --return false;
    end,
    function(context)
    
        if not cm:get_saved_value("furina_and_neuvillette") then
            cm:set_saved_value("furina_and_neuvillette", 1);
        else
            cm:set_saved_value("furina_and_neuvillette", cm:get_saved_value("furina_and_neuvillette") + 1);
        end
        
        if cm:get_saved_value("furina_and_neuvillette") == 3 then
            local hlyjcl = cm:query_model():character_for_template("hlyjcl");
            local hlyjco = cm:query_model():character_for_template("hlyjco");
            local faction = hlyjcl:faction()
            incident = cm:modify_model():create_incident("furina_and_neuvillette");
            incident:add_character_target("target_character_1", hlyjcl);
            incident:add_character_target("target_character_2", hlyjco);
            incident:trigger(cm:modify_faction(faction), true);
        end
        
    end,
    true
)


function register_gatepass_lisenters()
    for z_region_name, location_table in pairs(gst.gatepass_table) do
        cm:modify_scripting():remove_area_trigger("z_gatepass_trigger_"..z_region_name);
        cm:modify_scripting():remove_area_trigger("z_gatepass_trigger_2_"..z_region_name);

        cm:modify_scripting():add_circle_area_trigger(location_table["x"], location_table["y"], 5, "z_gatepass_trigger_"..z_region_name, "type:general", true, false, false);
        cm:modify_scripting():add_circle_area_trigger(location_table["x"], location_table["y"], 3, "z_gatepass_trigger_2_"..z_region_name, "type:general", true, false, false);
    end
	
    local z_x = cm:get_saved_value("Z_gatepass_logical_position_x")
    local z_y = cm:get_saved_value("Z_gatepass_logical_position_y")
    
    
    core:add_listener(
		"z_gatepass",
		"AreaEntered", 
		function(context)
            return context:area_trigger_name():starts_with("z_gatepass_trigger_") == true
        end,
		function(context)
			local character = context:query_character();
            if not char_is_general( character ) then
                return
            end;
			local z_area_trigger_name = context:area_trigger_name()
            local z_region_name = string.gsub(z_area_trigger_name, "z_gatepass_trigger_2_", "")
            z_region_name = string.gsub(z_region_name, "z_gatepass_trigger_", "")
			local region = cm:query_model():world():region_manager():region_by_key(z_region_name)
			local region_owner = region:owning_faction()
			
			if not region_owner or region_owner:is_null_interface() or region_owner:is_dead() then
                return
            end;
            local region_owner_name = region_owner:name()
            --ModLog("Region: "..z_region_name.."; Owner: "..region_owner_name)
            -- Abandoned settlements (Jiameng Pass) are owned by "rebels" apparently
            if region_owner_name == "rebels" then
                return
            end
            
            local character_faction = character:faction()
			if not character_faction or character_faction:is_null_interface() or character_faction:is_dead() then
                return
            end;
            local character_faction_name = character_faction:name()
            
            -- apparently the query objects are a bit buggy and can't handle when you pass the same faction as query and target
            -- this prevents erroneous boolean developments
            if character_faction_name == region_owner_name then 
                ModLog(character_faction_name.." traveling through own pass")
                return 
            end
            
            local isAtWar = (character_faction_name == "rebels" 
            or region_owner_name == "rebels" 
            or diplomacy_manager:is_at_war_with(character_faction_name, region_owner_name))
            
            -- Vassals by default have military access with master and vice versa?
            local hasMilitaryAccess = (diplomacy_manager:has_specified_diplomatic_deal(character_faction_name, region_owner_name, "treaty_components_military_access") or diplomacy_manager:has_specified_diplomatic_deal(character_faction_name, region_owner_name, "treaty_components_vassalage") or diplomacy_manager:has_specified_diplomatic_deal(region_owner_name, character_faction_name, "treaty_components_vassalage") or diplomacy_manager:is_in_coalition_with(region_owner_name, character_faction_name) or diplomacy_manager:is_allied_to(region_owner_name, character_faction_name) or diplomacy_manager:has_specified_diplomatic_deal(character_faction_name, region_owner_name, "treaty_components_empire"))
            
            ModLog(region_owner_name..z_region_name.." is blocking "..character_faction_name.."; \nHas military access - "..tostring(hasMilitaryAccess).."\nAt war - "..tostring(isAtWar))
            
            if character_faction_name ~= region_owner_name and (isAtWar or not hasMilitaryAccess) and not character:is_besieging() then
                
                -- Alex says this is to prevent bug where enemy AI attacking player standing too close to friendly pass causes the game to freeze
                --[[]]
                if not region_owner:is_human() then
                    local humans = cm:get_human_factions();
                    for i, human in ipairs(humans) do
                        -- prevent API error (is_at_war_with can't handle both argument factions being the same)
                        -- this seems to allow human to trespass though
                        --[[
                        if character_faction_name == human then
                            return
                        end
                        ]]
                        if character_faction_name ~= human 
                        and diplomacy_manager:is_at_war_with(character_faction_name, human) 
                        and cm:query_model():total_faction_armies_in_region(cm:query_faction(human), z_region_name) > 0 
                        then
                            ModLog("Premature exit due to enemy AI attempting to attack player within pass's zone of control (bug prevention)")
                            if 
                            not character_faction:is_human() 
                            and not region_owner:is_human() 
                            and diplomacy_manager:is_at_war_with(character_faction_name, region_owner_name)
                            then
                                cm:modify_region(region):settlement_gifted_as_if_by_payload(cm:modify_faction(character_faction))
                            else
                                cm:modify_character(character):zero_action_points();
                            end
                            return
                        end
                    end;
                end
                --]]
                
                --let's reorder this - if it's not under siege and enemy is attempting to pass, have it attack
                if z_area_trigger_name:starts_with("z_gatepass_trigger_2_") == true 
                then
                    if (isAtWar and region:garrison_residence():is_under_siege())
                    or (not isAtWar and not hasMilitaryAccess)
                    then
                        local found_spawn = true
                        local current_x, current_y
                        local z_logical_position_x = character:logical_position_x()
                        local z_logical_position_y = character:logical_position_y()
                        local zz_x = 2*z_logical_position_x-gst.gatepass_table[z_region_name]["x"] / 678.5 * 1016
                        local zz_y = 2*z_logical_position_y-gst.gatepass_table[z_region_name]["y"] / 555.37 * 720
                        if is_number(z_x) then
                            if distance_squared(zz_x,zz_y, z_logical_position_x, z_logical_position_y) < distance_squared(z_x, z_y, z_logical_position_x, z_logical_position_y) then
                                current_x, current_y = zz_x, zz_y
                            else
                                current_x, current_y = z_x, z_y
                            end
                        else
                            current_x, current_y = zz_x, zz_y
                        end
                        
                        if not invasion_manager:is_valid_position(current_x, current_y) then
                            found_spawn, current_x, current_y = cm:query_faction(character_faction_name):get_valid_spawn_location_near(z_x, z_y, 1 ,false)
                        end

                        local modify_character = cm:modify_character(character);
                        
                        if not found_spawn then
                            found_spawn, current_x, current_y = cm:query_faction(character_faction_name):get_valid_spawn_location_near(z_x, z_y, 2 ,false)
                        end
                        
                        if found_spawn then
                            modify_character:walk_to(current_x, current_y);
                        end
                    elseif isAtWar and not region:garrison_residence():is_under_siege()
                    then
                        cm:modify_character(character):attack_settlement(region:settlement())
                    end
                    
                    -- not enemies but not allowed on land
                    if not isAtWar 
                    and not hasMilitaryAccess 
                    and not region:garrison_residence():is_under_siege()
                    and not cm:get_saved_value("roguelike_mode") 
                    then
                         ModLog("Diplomatic standing of "..character_faction_name.." with "..region_owner_name..": "..tostring(character_faction:diplomatic_standing_with(region_owner)))
                         
                        -- if human, trigger dilemma. Also check that this faction has not triggered a dilemma this turn
                        if region_owner:is_human() then
                            if not cm:saved_value_exists(character_faction_name.."_gatepass_dilemma_triggered") then
                                cm:set_saved_value(character_faction_name.."_gatepass_dilemma_triggered", true)
                                ModLog("Creating saved value "..character_faction_name.."_gatepass_dilemma_triggered")
                            else
                                if cm:get_saved_value(character_faction_name.."_gatepass_dilemma_triggered") then
                                    ModLog(character_faction_name.."_gatepass_dilemma_triggered saved value has already been triggered this turn")
                                    return
                                end
                            end
                            
                            local dilemma = nil
                            -- arbitrary cutoff of -25 (unfriendly?). If higher, considered neutral or friendly
                            if character_faction:diplomatic_standing_with(region_owner) > unfriendlyThreshold then
                                dilemma = cm:modify_model():create_dilemma("army_at_gates_neutral");
                                ModLog("Neutral dilemma triggered")
                            -- if unfriendly, trigger ultimatum dilemma instead
                            else
                                dilemma = cm:modify_model():create_dilemma("army_at_gates_ultimatum");
                                ModLog("Ultimatum dilemma triggered")
                            end;
                            dilemma:add_faction_target("target_faction_1", region_owner);
                            dilemma:add_faction_target("target_faction_2", character_faction);
                            dilemma:trigger(cm:modify_faction(region_owner), true);
                            cm:set_saved_value(character_faction_name.."_gatepass_dilemma_triggered", true)
                        -- if AI, we'll skip the dilemma and just roll the outcome
                        else
                            --player trying to trespass on AI lands, lol - trigger advice
                            if character_faction:is_human() then
                                --campaign_manager:show_advice("We currently do not have a military access agreement with this faction, and therefore cannot travel through their gate pass. Negotiate a treaty with them, or take more drastic military action!")
                                
                                core:trigger_event("ScriptEventHumanAttemptGatepassTrespass")

                            else
                                if not cm:saved_value_exists(character_faction_name..region_owner_name.."_AI_gatepass_dilemma_triggered") then
                                    cm:set_saved_value(character_faction_name..region_owner_name.."_AI_gatepass_dilemma_triggered", true)
                                    ModLog("Creating saved value "..character_faction_name..region_owner_name.."_AI_gatepass_dilemma_triggered")
                                else
                                    if cm:get_saved_value(character_faction_name..region_owner_name.."_AI_gatepass_dilemma_triggered") then
                                        ModLog(character_faction_name..region_owner_name.."_AI_gatepass_dilemma_triggered saved value has already been triggered this turn")
                                        return
                                    end
                                end
                                
                                ModLog("AI dilemma triggered - region_owner: "..region_owner_name.."; character: "..character_faction_name)
                                -- outcome roll is biased towards region owner attitude towards attempted trespasser
                                local regionOwnerAttitude = region_owner:diplomatic_standing_with(character_faction)
                                local outcome = math.floor(gst.lib_getRandomValue(regionOwnerAttitude, unfriendlyThreshold))

                                -- cm:random_int is rigged (always generates same number order wtf)
                                --[[
                                for i = 1,3 do
                                    outcome = math.max(outcome, cm:random_int(unfriendlyThreshold,region_owner:diplomatic_standing_with(character_faction)))
                                    ModLog("Roll: "..tostring(outcome))
                                end
                                ]]
                                ModLog("AI dilemma rolled outcome: ("..tostring(unfriendlyThreshold)..","..tostring(regionOwnerAttitude)..") -> "..tostring(outcome))
                                if character_faction:diplomatic_standing_with(region_owner) > unfriendlyThreshold then
                                    if outcome > 0 then
                                        diplomacy_manager:grant_military_access(region_owner_name, character_faction_name, false)
                                        -- don't really know why localisation says "Cao Cao Manipulation" lol
                                        -- changed loc for that
                                        cm:modify_faction(character_faction):apply_automatic_diplomatic_deal("data_defined_situation_attitude_manipulation_positive", region_owner, "faction_key:"..character_faction_name);
                                        --cm:modify_faction(character_faction):apply_automatic_diplomatic_deal("data_defined_situation_military_access_accept", region_owner, "faction_key:"..character_faction_name);
                                        
                                        ModLog("AI neutral dilemma result - accepted")
                                    else
                                        cm:modify_faction(character_faction):apply_automatic_diplomatic_deal("data_defined_situation_attitude_manipulation_negative", region_owner, "faction_key:"..character_faction_name); 
                                        --cm:modify_faction(character_faction):apply_automatic_diplomatic_deal("data_defined_situation_military_access_reject", region_owner, "faction_key:"..character_faction_name);
                                        ModLog("AI neutral dilemma result - rejected")
                                    end         
                                -- More wars, more fun. AI automatically rejects other AI ultimatum and causes war
                                -- Maybe one day I'll be able to poll AI personality type for decision
                                else
                                    ModLog("AI ultimatum triggered, war declared")
                                    diplomacy_manager:force_declare_war(character_faction_name, region_owner_name, false);
                                end
                                
                                cm:set_saved_value(character_faction_name..region_owner_name.."_AI_gatepass_dilemma_triggered", true)
                            end
                        end
                    end
                    
                    -- this appears to force attack the pass? not sure the difference from the first part of the if
                    cm:os_clock_callback(
                        function()
                            local not_sieger = true
                            local invasion_faction_army_list = cm:query_faction(character_faction_name):military_force_list();
                            for i =0, invasion_faction_army_list:num_items() -1 do
                                if not invasion_faction_army_list:item_at(i) or not invasion_faction_army_list:item_at(i):is_null_interface() ~= nil then
                                    if not invasion_faction_army_list:item_at(i):region():is_null_interface() and invasion_faction_army_list:item_at(i):region():name()==z_region_name and invasion_faction_army_list:item_at(i):general_character():is_besieging() then
                                        not_sieger = false
                                        cm:modify_character(invasion_faction_army_list:item_at(i):general_character()):attack_settlement(region:settlement())
                                    end;
                                end;
                            end;
                            
                            if not_sieger and not character_faction:is_human() then
                                modify_character:zero_action_points()
                            end;
                        end,
                        0.3,
                        "z_gatepass"
                    );
                else
                    z_x = character:logical_position_x()
                    z_y = character:logical_position_y()
                    cm:set_saved_value("Z_gatepass_logical_position_x", z_x)
                    cm:set_saved_value("Z_gatepass_logical_position_y", z_y)
                end
            end;
        end, 
    true
	);
	
	-- listen for dilemma response
	core:add_listener(
        "gatepass_dilemma_response", 
        "DilemmaChoiceMadeEvent",
        function(context)
            return (context:dilemma() == "army_at_gates_neutral" or context:dilemma() == "army_at_gates_ultimatum")
        end,
        function(context)
            local saved_values_at_level = cm.saved_values
            
            for k,v in pairs(saved_values_at_level) do
                if string.match(k, "_gatepass_dilemma_triggered") then
                    cm:set_saved_value(k, false)
                    ModLog("Resetting saved value "..k)
                end
            end
            
        end,
        true
	);
	
	core:add_listener(
        "ResetSavedValuesOnHumanTurnEnd", 
        "FactionTurnEnd",
        function(context)
            return (context:faction():is_human())
        end,
        function(context)
            ModLog("Human turn ended")
            local saved_values_at_level = cm.saved_values
            
            for k,v in pairs(saved_values_at_level) do
                if string.match(k, "_gatepass_dilemma_triggered") then
                    cm:set_saved_value(k, false)
                    ModLog("Resetting saved value "..k)
                end
            end
            
        end,
        true
	);
	
    core:add_listener(
        "abdication",
        "FactionEffectBundleAwarded",
        function(context)
            return context:effect_bundle_key() == "abdication_exucute_ct";    
        end,
        function(context)  
            local old_leader = context:faction():faction_leader()
            gst.faction_leader_abdication(context:faction():name());
            if old_leader:generation_template_key() == "hlyjcm" then
                cm:modify_faction(context:faction()):remove_effect_bundle("inazuma_AI")
                local is_civil_war = generate_inazuma_civil_war_in_faction(context:faction():name()) 
                if not is_civil_war then
                    cm:set_saved_value("generated_inazuma_1", true);
                    local new_faction = gst.character_runaway("hlyjcm")
                    gst.character_add_to_faction("hlyjdf", new_faction:name(), "3k_general_fire");
                end
            end
        end,
        true
    );
    
--     core:add_listener(
-- 		"world_leader_seat_captured_listener", -- Unique handle
-- 		"SettlementAboutToBeCaptured",       -- Campaign Event to listen for
-- 		function(context)                    -- Criteria
--             local faction = context:settlement():faction()
-- 			return faction:is_world_leader() and context:settlement():region():name() == faction:capital_region():name();
-- 		end,
-- 		function(context)               
-- 			local region_key = context:settlement():region();
--             --
--             local modify_world = cm:modify_model():get_modify_world();
--             modify_world:remove_world_leader_region_status(region_key);
-- 		end,
-- 		true --Is persistent
-- 	);



	core:add_listener(
		"world_leader_seat_razed_listener",            -- Unique handle
		"CharacterWillPerformSettlementSiegeAction", -- Campaign Event to listen for
		function(context) 
            local garrison_residence = context:garrison_residence()
            if not garrison_residence
            or garrison_residence:is_null_interface()
            then
                return false
            end
            local faction = garrison_residence:region():owning_faction();                           -- Criteria
			return faction 
			and not faction:is_null_interface() 
			and faction:is_world_leader() 
			and context:garrison_residence():region():name() == faction:capital_region():name();
		end,
		function(context)
			local region_key = context:garrison_residence():region():name();
            local old_faction = context:garrison_residence():owning_faction();   
            local new_faction = context:query_character():faction();
            local world_faction_list = cm:query_model():world():faction_list();
            local change_slot = false
            if context:option_outcome_enum_key() == "raze" then
                change_slot = true
            end
            for i = 0, world_faction_list:num_items() - 1 do
                local faction = world_faction_list:item_at(i);
                if not faction:is_null_interface()
                and not faction:is_dead()
                and faction:is_world_leader()
                and faction ~= old_faction
                then
                    if faction == new_faction then
                        change_slot = true
                        break;
                    elseif 
                    diplomacy_manager:has_specified_diplomatic_deal(faction, new_faction, "treaty_components_vassalage") 
                    or diplomacy_manager:has_specified_diplomatic_deal(faction, new_faction, "treaty_components_vassalage") 
                    or diplomacy_manager:is_in_coalition_with(faction, new_faction) 
                    or diplomacy_manager:is_allied_to(faction, new_faction) 
                    or diplomacy_manager:has_specified_diplomatic_deal(faction, new_faction, "treaty_components_empire") 
                    then
                        change_slot = true
                        break;
                    end
                end
            end
            if change_slot then
                if cm:get_total_number_of_world_leader_seats() == 2 then
                    if old_faction:region_list() > 0 then
                        for i = 0, old_faction:region_list():num_items() - 1 do
                            local new_region = old_faction:region_list():item_at(i);
                            if new_region:name() ~= region_key
                            then
                                cm:modify_faction(old_faction):make_region_capital(new_region)
                                modify_world:add_world_leader_region_status(new_region:name());
                                break;
                            end
                        end
                    end
                    local modify_world = cm:modify_model():get_modify_world();
                    modify_world:remove_world_leader_region_status(region_key);
                else
                    local modify_world = cm:modify_model():get_modify_world();
                    modify_world:remove_world_leader_region_status(region_key);
                    if old_faction:region_list() > 0 then
                        for i = 0, old_faction:region_list():num_items() - 1 do
                            local new_region = old_faction:region_list():item_at(i);
                            if new_region:name() ~= region_key
                            then
                                cm:modify_faction(old_faction):make_region_capital(new_region)
                                modify_world:add_world_leader_region_status(new_region:name());
                                break;
                            end
                        end
                    end
                end
            end
		end,
		true --Is persistent
	);

    core:add_listener(
        "carlotta_becomes_faction_leader",
        "CharacterBecomesFactionLeader",
        function(context)
            return true
        end,
        function(context) -- What to do if listener fires.
            if context:query_character():generation_template_key() == "hlyjdy" then
                cm:modify_faction(context:query_character():faction()):apply_effect_bundle("carlotta_income", -1)
            else
                cm:modify_faction(context:query_character():faction()):remove_effect_bundle("carlotta_income")
            end
            if context:query_character():generation_template_key() == "hlyjco" then
                cm:modify_faction(context:query_character():faction()):apply_effect_bundle("furina_income", -1)
            else
                cm:modify_faction(context:query_character():faction()):remove_effect_bundle("furina_income")
            end
            if context:query_character():generation_template_key() == "hlyjeb" then
                cm:modify_faction(context:query_character():faction()):apply_effect_bundle("cantarella_income", -1)
            else
                cm:modify_faction(context:query_character():faction()):remove_effect_bundle("cantarella_income")
            end
        end,
        true
    );

    core:add_listener(
        "carlotta_and_cantarella_trigger",
        "FactionTurnStart",
        function(context)
            local carlotta = gst.character_query_for_template("hlyjdy")
            local cantarella = gst.character_query_for_template("hlyjeb")
            return carlotta
            and cantarella
            and not carlotta:is_null_interface()
            and not cantarella:is_null_interface()
            and not carlotta:is_dead()
            and not cantarella:is_dead()
            and not carlotta:is_character_is_faction_recruitment_pool()
            and not cantarella:is_character_is_faction_recruitment_pool()
            and carlotta:faction():name() == context:faction():name()
            and cantarella:faction():name() == context:faction():name()
        end,
        function(context) -- What to do if listener fires.
            local carlotta = gst.character_query_for_template("hlyjdy")
            local cantarella = gst.character_query_for_template("hlyjeb")
            if carlotta:is_faction_leader() then
                gst.character_runaway("hlyjeb")
                return
            end
            if cantarella:is_faction_leader() then
                gst.character_runaway("hlyjdy")
                return
            end
            if cm:get_saved_value("cc_duel_cooldown") then
                if cm:get_saved_value("cc_duel_cooldown") > 1 then
                    local cooldown = cm:get_saved_value("cc_duel_cooldown")
                    cm:set_saved_value("cc_duel_cooldown", cooldown - 1)
                else
                    cm:set_saved_value("cc_duel_cooldown", nil)
                end
                return;
            end
            local trigger = false
            if carlotta:character_post() 
            and not carlotta:character_post():is_null_interface()
            and carlotta:character_post():ministerial_position_record_key() ~= "3k_main_court_offices_governor" 
            and cantarella:character_post() 
            and not cantarella:character_post():is_null_interface()
            and cantarella:character_post():ministerial_position_record_key() ~= "3k_main_court_offices_governor"  then
                trigger = true
            end
            if gst.faction_query_character_force(carlotta) == gst.faction_query_character_force(cantarella) then
                trigger = true
            end
            if trigger then
                if context:faction():is_human() then
                    ModLog("duel_of_cantarella_and_carlotta")
                    local dilemma = cm:modify_model():create_dilemma("duel_of_cantarella_and_carlotta");
                    dilemma:add_faction_target("target_faction_1", context:faction());
                    dilemma:add_character_target("target_character_1", context:faction():faction_leader());
                    dilemma:add_character_target("target_character_2", carlotta);
                    dilemma:add_character_target("target_character_3", cantarella);
                    dilemma:trigger(cm:modify_faction(context:faction()), true);
                else
                    cm:modify_character(carlotta):apply_effect_bundle("3k_dlc07_effect_bundle_malcontent_character", 10)
                    cm:modify_character(cantarella):apply_effect_bundle("3k_dlc07_effect_bundle_malcontent_character", 10)
                    cm:modify_character(carlotta):apply_relationship_trigger_set(context:faction():faction_leader(), "3k_main_relationship_trigger_set_event_negative_dilemma_extreme");
                    cm:modify_character(cantarella):apply_relationship_trigger_set(context:faction():faction_leader(), "3k_main_relationship_trigger_set_event_negative_dilemma_extreme");
                    cm:set_saved_value("cc_duel_cooldown", 3)
                end
            end
        end,
        true
    );
    
	-- listen for dilemma response
	core:add_listener(
        "duel_of_cantarella_and_carlotta", 
        "DilemmaChoiceMadeEvent",
        function(context)
            return context:dilemma() == "duel_of_cantarella_and_carlotta"
        end,
        function(context)
            if context:choice() == 0 then
                local successed = cm:roll_random_chance(50)
                if successed then
                    gst.character_been_killed("hlyjdy")
                else
                    gst.character_been_killed("hlyjeb")
                end
            end
            if context:choice() == 1 then
                local carlotta = gst.character_query_for_template("hlyjdy")
                local cantarella = gst.character_query_for_template("hlyjeb")
                cm:modify_character(carlotta):apply_effect_bundle("3k_dlc07_effect_bundle_malcontent_character", 10)
                cm:modify_character(cantarella):apply_effect_bundle("3k_dlc07_effect_bundle_malcontent_character", 10)
                cm:set_saved_value("cc_duel_cooldown", 3)
--                 cm:modify_character(carlotta):apply_relationship_trigger_set(context:faction():faction_leader(), "3k_main_relationship_trigger_set_event_negative_dilemma_extreme");
--                 cm:modify_character(cantarella):apply_relationship_trigger_set(context:faction():faction_leader(), "3k_main_relationship_trigger_set_event_negative_dilemma_extreme");
            end
        end,
        true
	);
	
    core:add_listener(
        "xyy_path_blessing_ruan_mei_change_faction",
        "CharacterLeavesFaction",
        function(context)
            return context:query_character():generation_template_key() == "hlyjdy"
            or context:query_character():generation_template_key() == "hlyjeb"
        end,
        function(context)
            cm:modify_character(context:query_character()):remove_effect_bundle("3k_dlc07_effect_bundle_malcontent_character")
        end,
        true
    )
    
    core:add_listener(
        "yae_miko_relationship_event",
        "CharacterRelationshipCreatedEvent",
        function(context)
            local relationship_key = context:relationship():relationship_record_key()
            ModLog(relationship_key)
            if relationship_key == "3k_main_relationship_negative_01" 
            or relationship_key == "3k_main_relationship_negative_02" 
            or relationship_key == "3k_main_relationship_negative_03" then
                local characters = context:relationship():get_relationship_characters()
                for i = 0, characters:num_items() - 1 do
                    ModLog(gst.character_get_string_name(characters:item_at(i)))
                    if characters:item_at(i):generation_template_key() == "hlyjdo" then
                        return true
                    end
                end
            end
            return false
        end,
        function(context)
            local yae_miko = nil
            local character = nil
            local characters = context:relationship():get_relationship_characters()
            for i = 0, characters:num_items() - 1 do
                ModLog(gst.character_get_string_name(characters:item_at(i)))
                if characters:item_at(i):generation_template_key() == "hlyjdo" then
                    yae_miko = characters:item_at(i)
                else
                    character = characters:item_at(i)
                end
            end
            if character:generation_template_key() == "hlyjcm" --雷电将军
            or character:generation_template_key() == "hlyjcu" --珊瑚宫心海
            or character:generation_template_key() == "hlyjdz" --神里绫华
            or character:generation_template_key() == "hlyjcd" --千织
            or character:generation_template_key() == "hlyjdp" --宵宫
            or character:generation_template_key() == "hlyjdf" --九条裟罗
            then
                return
            end
            cm:modify_character(yae_miko):apply_relationship_trigger_set(character, "3k_xyy_relationship_trigger_set_someone_and_miko");
        end,
        true
    )
    
    core:add_listener(
        "pending_battle_listener",
        "PendingBattle",
        function(context)
            return true;
        end,
        function(context)
            local faction = cm:query_local_faction()
            local pb = cm:query_model():pending_battle();
            if pb:human_involved()
            and pb:has_attacker()
            and pb:has_defender()
            then
                ModLog("PendingBattle")
                cm:set_saved_value("has_pending_battle", nil)
                cm:set_saved_value("xyy_roguelike_character_wound_listener", true)
            else
                cm:set_saved_value("xyy_roguelike_character_wound_listener", false)
            end
        end,
        true
    )
    
    core:add_listener(
        "battle_completed_listener",
        "BattleCompletedCameraMove",
        function(context)
            cm:set_saved_value("has_pending_battle", nil)
            return cm:get_saved_value("xyy_roguelike_character_wound_listener");
        end,
        function(context)
            local pb = cm:query_model():pending_battle();
            if pb:human_involved() and pb:has_been_fought() then
                cm:set_saved_value("xyy_roguelike_character_wound_listener", false)
            end
        end,
        true
    )
end

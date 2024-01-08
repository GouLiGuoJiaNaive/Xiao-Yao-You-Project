local liu_biao_death = false;

--200年：张郃投靠曹操
core:add_listener(
    "zhang_he_cao_cao",
    "FactionTurnStart",
    function(context)
        return 
        context:query_model():calendar_year() >= 200
        and context:query_model():season() ~= "season_spring"
        and context:query_model():turn_number() > 1
        and not cm:query_faction("3k_main_faction_yuan_shao"):is_human()
        and cm:query_model():campaign_name() == "3k_dlc07_start_pos";
    end,
    function()
        local zhanghe = cm:query_model():character_for_template("3k_main_template_historical_zhang_he_hero_fire")
        if not zhanghe:is_dead() and zhanghe:faction():name() == "3k_main_faction_yuan_shao" then
            xyy_character_add("3k_main_template_historical_zhang_he_hero_fire", "3k_main_faction_cao_cao", "3k_general_metal")
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
        and not cm:get_saved_value("liu_bei_defeat")
        and cm:query_model():campaign_name() == "3k_dlc07_start_pos"
        and context:faction():name() == "3k_main_faction_cao_cao"
        and not cm:query_faction("3k_main_faction_cao_cao"):is_human();
    end,
    function()
        cm:modify_faction("3k_main_faction_cao_cao"):increase_treasury(20000);
        cm:modify_faction("3k_main_faction_cao_cao"):apply_effect_bundle("xyy_cao_cao_AI", 5);
        cm:modify_faction("3k_main_faction_liu_bei"):apply_effect_bundle("xyy_liu_bei", 5);
        if not cm:query_faction("3k_main_faction_yuan_shao"):is_human() then
            --cm:modify_faction("3k_main_faction_yuan_shao"):decrease_treasury(1000);
        end
    end,
    true
)

--刘备战败
core:add_listener(
    "liu_bei_defeat_event",
    "RegionOwnershipChanged",
    function(context)
        --ModLog(context:previous_owner():name()..":"..context:previous_owner():region_list():num_items());
        return 
        context:previous_owner():name() == "3k_main_faction_liu_bei"
        and cm:query_faction("3k_main_faction_liu_bei"):is_human()
        and not cm:get_saved_value("liu_bei_defeat")
        and context:previous_owner():region_list():num_items() == 0
        and not cm:query_faction("3k_main_faction_cao_cao"):is_human()
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
        cm:trigger_incident("3k_main_faction_liu_bei", "liu_biao_vassalise_recipient", true);
        cm:trigger_mission(cm:modify_faction("3k_main_faction_liu_bei"), "3k_dlc07_mission_liu_bei_goto_jing", true);
        
    end,
    false
)

core:add_listener(
    "3k_main_faction_cao_cao_ai_research_event",
    "FactionTurnStart",
    function(context)
        return 
        (context:query_model():season() == "season_summer"
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
        and not cm:query_faction("3k_dlc05_faction_sun_ce"):is_human()
        and cm:query_model():campaign_name() == "3k_dlc07_start_pos";
    end,
    function()
        xyy_kill_character("3k_main_template_historical_sun_ce_hero_fire");
        xyy_kill_character("3k_main_template_historical_xu_zhao_hero_earth");
        diplomacy_manager:force_confederation("3k_dlc05_faction_sun_ce", "3k_dlc05_faction_wu_jing");
        diplomacy_manager:apply_automatic_deal_between_factions("3k_dlc05_faction_sun_ce", "3k_dlc05_faction_xu_zhao", "data_defined_situation_war_proposer_to_recipient");
        local lu_meng = cm:query_model():character_for_template("3k_main_template_historical_lu_meng_hero_metal");
        if lu_meng and not lu_meng:is_null_interface() then
            cm:modify_character(lu_meng):apply_effect_bundle("lu_meng_effect_bundle",-1);
        end
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
        and not faction:is_dead() 
        and faction:region_list() 
        and faction:region_list():num_items() > 10 
        and not cm:query_faction("3k_main_faction_cao_cao"):is_human()
        and not cm:query_faction("3k_main_faction_yuan_shao"):is_human();
    end,
    function()
        local yuan_shang = cm:query_model():character_for_template("3k_main_template_historical_yuan_shang_hero_earth");
        
        local yuan_xi = cm:query_model():character_for_template("3k_main_template_historical_yuan_xi_hero_earth");
        
        local yuan_tan = cm:query_model():character_for_template("3k_main_template_historical_yuan_tan_hero_earth");
        
        local yuan_shao = cm:query_model():character_for_template("3k_main_template_historical_yuan_shao_hero_earth");
        
        if not yuan_xi:is_character_is_faction_recruitment_pool() and not yuan_xi:faction():is_human() then
            xyy_kill_character("3k_main_template_historical_yuan_xi_hero_earth");
        end
        if not yuan_shang:is_character_is_faction_recruitment_pool() and not yuan_shang:faction():is_human() then
            xyy_kill_character("3k_main_template_historical_yuan_shang_hero_earth");
        end
        if not yuan_tan:is_character_is_faction_recruitment_pool() and not yuan_tan:faction():is_human() then
            xyy_kill_character("3k_main_template_historical_yuan_tan_hero_earth");
        end
        if not yuan_shao:is_character_is_faction_recruitment_pool() and not yuan_shao:faction():is_human() then
            xyy_kill_character("3k_main_template_historical_yuan_shao_hero_earth");
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
        --xyy_set_region_manager("3k_main_wuwei_capital","3k_main_faction_cao_cao")
        --xyy_set_region_manager("3k_main_wuwei_resource_1","3k_main_faction_cao_cao")
        --xyy_set_region_manager("3k_main_wuwei_resource_2","3k_main_faction_cao_cao")
        
        --金城
        --xyy_set_region_manager("3k_main_jincheng_capital","3k_main_faction_cao_cao")
        --xyy_set_region_manager("3k_main_jincheng_resource_1","3k_main_faction_cao_cao")
        --xyy_set_region_manager("3k_main_jincheng_resource_2","3k_main_faction_cao_cao")
        
        --安定
        xyy_set_region_manager("3k_main_anding_capital","3k_main_faction_cao_cao")
        xyy_set_region_manager("3k_main_anding_resource_1","xyyhlyja")--（羌胡占）
        xyy_set_region_manager("3k_main_anding_resource_2","xyyhlyja")--（羌胡占）
        xyy_set_region_manager("3k_main_anding_resource_3","xyyhlyja")--（羌胡占）
        
        --武都
        --xyy_set_region_manager("3k_main_wudu_capital","3k_main_faction_cao_cao")
        --xyy_set_region_manager("3k_main_wudu_resource_1","3k_main_faction_cao_cao")
        --xyy_set_region_manager("3k_main_wudu_resource_2","3k_main_faction_cao_cao")
        
        --并州
        --朔方（羌胡占）
        xyy_set_region_manager("3k_main_shoufang_capital","xyyhlyja")
        xyy_set_region_manager("3k_main_shoufang_resource_1","xyyhlyja")
        xyy_set_region_manager("3k_main_shoufang_resource_2","xyyhlyja")
        xyy_set_region_manager("3k_main_shoufang_resource_3","xyyhlyja")
        
        --并州
        --朔方（羌胡占）
        xyy_set_region_manager("3k_main_shoufang_capital","xyyhlyja")
        xyy_set_region_manager("3k_main_shoufang_resource_1","xyyhlyja")
        xyy_set_region_manager("3k_main_shoufang_resource_2","xyyhlyja")
        xyy_set_region_manager("3k_main_shoufang_resource_3","xyyhlyja")
        
        --西河（羌胡占）
        xyy_set_region_manager("3k_main_xihe_capital","xyyhlyja")
        xyy_set_region_manager("3k_main_xihe_resource_1","xyyhlyja")
        
        --太原
        xyy_set_region_manager("3k_main_taiyuan_capital","3k_main_faction_cao_cao")
        xyy_set_region_manager("3k_main_taiyuan_resource_1","3k_main_faction_cao_cao")
        xyy_set_region_manager("3k_main_taiyuan_resource_2","3k_main_faction_cao_cao")
        
        --故关
        xyy_set_region_manager("3k_dlc06_gu_pass","3k_main_faction_cao_cao")
        
        --雁门
        xyy_set_region_manager("3k_main_yanmen_capital","3k_main_faction_cao_cao")
        xyy_set_region_manager("3k_main_yanmen_resource_1","3k_main_faction_cao_cao")
        
        --上党
        xyy_set_region_manager("3k_main_shangdang_capital","3k_main_faction_cao_cao")
        xyy_set_region_manager("3k_main_shangdang_resource_1","3k_main_faction_cao_cao")
        xyy_set_region_manager("3k_dlc06_shangdang_resource_2","3k_main_faction_cao_cao")
        
        --冀州
        --中山
        xyy_set_region_manager("3k_main_zhongshan_capital","3k_main_faction_cao_cao")
        xyy_set_region_manager("3k_main_zhongshan_resource_1","3k_main_faction_cao_cao")
        
        --安平
        xyy_set_region_manager("3k_main_anping_capital","3k_main_faction_cao_cao")
        xyy_set_region_manager("3k_main_anping_resource_1","3k_main_faction_cao_cao")
        
        --魏郡
        xyy_set_region_manager("3k_main_weijun_capital","3k_main_faction_cao_cao")
        xyy_set_region_manager("3k_main_weijun_resource_1","3k_main_faction_cao_cao")
        
        --河内
        xyy_set_region_manager("3k_main_henei_capital","3k_main_faction_cao_cao")
        xyy_set_region_manager("3k_main_henei_resource_1","3k_main_faction_cao_cao")
        
        --渤海
        xyy_set_region_manager("3k_main_bohai_capital","3k_main_faction_cao_cao")
        xyy_set_region_manager("3k_main_bohai_resource_1","3k_main_faction_cao_cao")
        
        --幽州
        --代郡
        xyy_set_region_manager("3k_main_daijun_capital","3k_main_faction_cao_cao")
        xyy_set_region_manager("3k_main_daijun_resource_1","3k_main_faction_cao_cao")
        
        --广阳
        xyy_set_region_manager("3k_main_youzhou_capital","3k_main_faction_cao_cao")
        xyy_set_region_manager("3k_main_youzhou_resource_1","3k_main_faction_cao_cao")
        
        --右北平
        xyy_set_region_manager("3k_main_youbeiping_capital","3k_main_faction_cao_cao")
        xyy_set_region_manager("3k_main_youbeiping_resource_1","3k_main_faction_cao_cao")
        
        --辽西
        xyy_set_region_manager("3k_main_yu_capital","3k_main_faction_cao_cao")
        xyy_set_region_manager("3k_main_yu_resource_1","3k_main_faction_cao_cao")
        
        --青州
        --平原
        xyy_set_region_manager("3k_main_pingyuan_capital","3k_main_faction_cao_cao")
        xyy_set_region_manager("3k_main_pingyuan_resource_1","3k_main_faction_cao_cao")
        
        --乐安
        xyy_set_region_manager("3k_main_taishan_capital","3k_main_faction_cao_cao")
        xyy_set_region_manager("3k_main_taishan_resource_1","3k_main_faction_cao_cao")
        
        --北海
        xyy_set_region_manager("3k_main_beihai_capital","3k_main_faction_cao_cao")
        xyy_set_region_manager("3k_main_beihai_resource_1","3k_main_faction_cao_cao")
        
        --东莱
        xyy_set_region_manager("3k_main_donglai_capital","3k_main_faction_cao_cao")
        xyy_set_region_manager("3k_main_donglai_resource_1","3k_main_faction_cao_cao")
        
        --兖州
        --东郡
        xyy_set_region_manager("3k_main_dongjun_capital","3k_main_faction_cao_cao")
        xyy_set_region_manager("3k_main_dongjun_resource_1","3k_main_faction_cao_cao")
        
        --颍川
        xyy_set_region_manager("3k_main_yingchuan_capital","3k_main_faction_cao_cao")
        xyy_set_region_manager("3k_main_yingchuan_resource_1","3k_main_faction_cao_cao")
        
        --徐州
        --彭城
        xyy_set_region_manager("3k_main_penchang_capital","3k_main_faction_cao_cao")
        xyy_set_region_manager("3k_main_penchang_resource_1","3k_main_faction_cao_cao")
        xyy_set_region_manager("3k_main_penchang_resource_2","3k_main_faction_cao_cao")
        
        --下邳
        xyy_set_region_manager("3k_dlc06_xiapi_capital","3k_main_faction_cao_cao")
        xyy_set_region_manager("3k_dlc06_xiapi_resource_1","3k_main_faction_cao_cao")
        
        --琅琊
        xyy_set_region_manager("3k_main_langye_capital","3k_main_faction_cao_cao")
        xyy_set_region_manager("3k_main_langye_resource_1","3k_main_faction_cao_cao")
        xyy_set_region_manager("3k_main_langye_resource_2","3k_main_faction_cao_cao")
        
        --东海
        xyy_set_region_manager("3k_main_donghai_capital","3k_main_faction_cao_cao")
        xyy_set_region_manager("3k_main_donghai_resource_1","3k_main_faction_cao_cao")
        
        --广陵
        xyy_set_region_manager("3k_main_guangling_capital","3k_main_faction_cao_cao")
        
        --豫州
        --陈郡
        xyy_set_region_manager("3k_main_chenjun_capital","3k_main_faction_cao_cao")
        xyy_set_region_manager("3k_main_chenjun_resource_1","3k_main_faction_cao_cao")
        xyy_set_region_manager("3k_main_chenjun_resource_2","3k_main_faction_cao_cao")
        
        --汝南
        xyy_set_region_manager("3k_main_runan_capital","3k_main_faction_cao_cao")
        xyy_set_region_manager("3k_main_runan_resource_1","3k_main_faction_cao_cao")
        if not cm:query_faction("3k_dlc07_faction_liubei"):is_human() then
            local faction = cm:query_faction("3k_main_faction_liu_bei") 
            if faction 
            and faction
            and not faction:is_dead() then
            for i = 0, faction:region_list():num_items() - 1 do
                local region = faction:region_list():item_at(i);
                xyy_set_region_manager(region:name(),"3k_main_faction_cao_cao")
            end
                diplomacy_manager:force_confederation("3k_main_faction_liu_biao", "3k_main_faction_liu_bei");
            end
        end
        diplomacy_manager:apply_automatic_deal_between_factions("3k_main_faction_liu_biao", "3k_dlc05_faction_sun_ce", "data_defined_situation_peace")
        xyy_character_add("3k_main_template_historical_lu_su_hero_water", "3k_dlc05_faction_sun_ce", "3k_general_water");
        xyy_character_add("3k_main_template_historical_ma_teng_hero_fire", "3k_main_faction_cao_cao", "3k_general_fire")
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
    end,
    function(context)
        xyy_character_add("3k_main_template_historical_ma_teng_hero_fire", "3k_main_faction_cao_cao", "3k_general_fire")
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
    end,
    function(context)
        diplomacy_manager:apply_automatic_deal_between_factions("3k_main_faction_ma_teng", "3k_main_faction_cao_cao", "data_defined_situation_peace")
        diplomacy_manager:apply_automatic_deal_between_factions("3k_main_faction_han_sui", "3k_main_faction_cao_cao", "data_defined_situation_peace")
        diplomacy_manager:apply_automatic_deal_between_factions("3k_dlc07_faction_zhang_lu", "3k_main_faction_cao_cao", "data_defined_situation_peace")
    end,
    false
)

--211年：马超起兵攻打曹操
core:add_listener(
    "ma_chao_ai_attack_cao_cao",
    "FactionTurnStart",
    function(context)
        local faction = cm:query_faction("3k_main_faction_ma_teng")
        return cm:query_model():campaign_name() == "3k_dlc07_start_pos" 
        and not faction:is_human()
        and not faction:is_dead()
        and context:query_model():calendar_year() == 211
    end,
    function(context)
        diplomacy_manager:apply_automatic_deal_between_factions("3k_main_faction_han_sui", "3k_main_faction_cao_cao", "data_defined_situation_war_proposer_to_recipient");
        diplomacy_manager:apply_automatic_deal_between_factions("3k_main_faction_ma_teng", "3k_main_faction_cao_cao", "data_defined_situation_war_proposer_to_recipient");
        diplomacy_manager:apply_automatic_deal_between_factions("3k_dlc07_faction_zhang_lu", "3k_main_faction_cao_cao", "data_defined_situation_war_proposer_to_recipient");
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
        local liu_bei = cm:query_model():character_for_template("3k_main_template_historical_liu_bei_hero_earth")
        local liu_shan = cm:query_model():character_for_template("3k_main_template_historical_liu_shan_hero_earth")
        local faction = cm:query_faction("3k_main_faction_liu_bei")
        return context:query_model():calendar_year() >= 207 
        and (not liu_shan or liu_shan:is_null_interface())
        and not faction:is_dead()
        and faction:faction_leader():generation_template_key() == "3k_main_template_historical_liu_bei_hero_earth";
    end,
    function(context)
        local liu_bei = cm:query_model():character_for_template("3k_main_template_historical_liu_bei_hero_earth")
        local liu_shan = xyy_character_add("3k_main_template_historical_liu_shan_hero_earth","3k_main_faction_liu_bei","3k_general_earth");
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
        and context:query_model():calendar_year() < 212 
        and not cm:query_faction("3k_main_faction_liu_bei"):is_human()
        and not cm:query_faction("3k_main_faction_liu_biao"):is_human()
        --and cm:query_faction("3k_main_faction_liu_biao"):faction_leader():generation_template_key() == "3k_main_template_historical_liu_biao_hero_earth"
        and cm:query_model():campaign_name() == "3k_dlc07_start_pos";
    end,
    function()
        if not cm:query_faction("3k_main_faction_liu_bei"):is_human() then
            local faction = cm:query_faction("3k_main_faction_liu_bei")
            local liubei = cm:query_model():character_for_template("3k_main_template_historical_liu_bei_hero_earth")
            
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
                xyy_character_add("3k_main_template_historical_liu_bei_hero_earth", "3k_main_faction_liu_bei", "3k_general_earth");
                xyy_set_minister_position("3k_main_template_historical_liu_bei_hero_earth","faction_leader");
                
                
                --如果关羽不在玩家派系则加入刘备
                if 
                cm:query_model():character_for_template("3k_main_template_historical_guan_yu_hero_wood"):is_character_is_faction_recruitment_pool() 
                or not cm:query_model():character_for_template("3k_main_template_historical_guan_yu_hero_wood"):faction():is_human() then
                    xyy_character_add("3k_main_template_historical_guan_yu_hero_wood", "3k_main_faction_liu_bei", "3k_general_wood");
                end
                
                --如果张飞不在玩家派系则加入刘备
                if 
                cm:query_model():character_for_template("3k_main_template_historical_zhang_fei_hero_fire"):is_character_is_faction_recruitment_pool() 
                or not cm:query_model():character_for_template("3k_main_template_historical_zhang_fei_hero_fire"):faction():is_human() then
                    xyy_character_add("3k_main_template_historical_zhang_fei_hero_fire", "3k_main_faction_liu_bei", "3k_general_fire");
                end
                
                --如果赵云不在玩家派系则加入刘备
                if
                cm:query_model():character_for_template("3k_main_template_historical_zhao_yun_hero_metal"):is_character_is_faction_recruitment_pool() 
                or not cm:query_model():character_for_template("3k_main_template_historical_zhao_yun_hero_metal"):faction():is_human() then
                    xyy_character_add("3k_main_template_historical_zhao_yun_hero_metal", "3k_main_faction_liu_bei", "3k_general_metal");
                end
                
                --如果关银屏不在玩家派系则加入刘备
                if
                cm:query_model():character_for_template("hlyjbv"):is_character_is_faction_recruitment_pool() 
                or not cm:query_model():character_for_template("hlyjbv"):faction():is_human() then
                    xyy_character_add("hlyjbv", "3k_main_faction_liu_bei", "3k_general_wood");
                end
                
                --如果甘宁不在玩家派系则加入孙策
                if
                cm:query_model():character_for_template("3k_main_template_historical_gan_ning_hero_fire"):is_character_is_faction_recruitment_pool() 
                or not cm:query_model():character_for_template("3k_main_template_historical_gan_ning_hero_fire"):faction():is_human() then
                    xyy_character_add("3k_main_template_historical_gan_ning_hero_fire", "3k_dlc05_faction_sun_ce", "3k_general_fire"); 
                end
                
                
                --如果诸葛亮不在玩家派系则加入刘备
                local zhuge_liang_key = "3k_main_template_historical_zhuge_liang_hero_water";
                local huang_yueying_key = "hlyjbt";
                local zhuge_liang = cm:query_model():character_for_template(zhuge_liang_key);
                local huang_yueying = cm:query_model():character_for_template(huang_yueying_key);
                if not zhuge_liang 
                or zhuge_liang:is_null_interface() 
                then
                    zhuge_liang = xyy_character_add(zhuge_liang_key, "3k_main_faction_liu_bei", "3k_general_water");
                end
                if zhuge_liang:faction():name() == "3k_main_faction_liu_bei"
                then
                    if not huang_yueying:faction():is_human() then
                        xyy_character_add(huang_yueying_key, "3k_main_faction_liu_bei", "3k_general_water");
                        local modify_huang_yueying = cm:modify_character(huang_yueying);
                        local family_member = modify_huang_yueying:family_member()
                        
                        --和黄月英结婚
                        if not family_member:is_null_interface() then 
                            family_member:divorce_spouse();
                            family_member:marry_character(cm:modify_character(zhuge_liang):family_member());
                        end
                    end
                end
                --合并刘表、黄祖
                diplomacy_manager:force_confederation("3k_main_faction_liu_bei", "3k_main_faction_liu_biao");
                diplomacy_manager:force_confederation("3k_main_faction_liu_bei", "3k_main_faction_huang_zu");
                
                cm:modify_faction("3k_main_faction_liu_bei"):increase_treasury(443120);
                --刘表病逝
--                 local liu_biao = cm:query_model():character_for_template("3k_main_template_historical_liu_biao_hero_earth");
--                 cm:modify_character(liu_biao):kill_character(false);
--                 
--                 cm:modify_faction(faction):make_region_capital(cm:query_region("3k_main_xiangyang_capital"));
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

--208年
core:add_listener(
    "liu_bei_alliance_sun_quan",
    "FactionTurnStart",
    function(context)
        return 
        context:query_model():calendar_year() >= 208 
        and context:query_model():calendar_year() < 215
        and cm:get_saved_value("liu_biao_confederation")
        --and not cm:get_saved_value("liu_bei_alliance_sun_quan")
        --and not cm:query_faction("3k_main_faction_cao_cao"):is_human()
        and cm:query_model():campaign_name() == "3k_dlc07_start_pos";
    end,
    function(context)
        cm:set_saved_value("liu_bei_alliance_sun_quan", true);
        if cm:query_faction("3k_main_faction_liu_bei"):is_human() then
            cm:trigger_dilemma("3k_main_faction_liu_bei","liu_bei_alliance_sun_quan", true);
        end
        if cm:query_faction("3k_dlc05_faction_sun_ce"):is_human() then
            cm:trigger_dilemma("3k_dlc05_faction_sun_ce","sun_quan_alliance_liu_bei", true);
        else
            cm:modify_faction("3k_dlc05_faction_sun_ce"):increase_treasury(443120);
        end
    end,
    false
)

core:add_listener(
    "confederate_liu_bei_and_liu_biao",
    "DilemmaChoiceMadeEvent",
    function(context) 
        return context:dilemma() == "confederate_liu_bei_and_liu_biao";
    end, -- criteria
    function (context) --what to do if listener fires
        local query_faction = cm:query_local_faction();
        local liu_biao = cm:query_model():character_for_template("3k_main_template_historical_liu_biao_hero_earth");
        if context:choice() == 0 then
            cm:set_saved_value("liu_biao_confederation", true)
            diplomacy_manager:apply_automatic_deal_between_factions("3k_main_faction_liu_bei", "3k_dlc05_faction_sun_ce", "data_defined_situation_peace")
            
            local huang_yueying = xyy_character_add("hlyjbt", "3k_main_faction_liu_bei", "3k_general_water");
            local zhuge_liang = cm:query_model():character_for_template("3k_main_template_historical_zhuge_liang_hero_water");
            
            local modify_huang_yueying = cm:modify_character(huang_yueying);
            local family_member = modify_huang_yueying:family_member()
            
            if not family_member:is_null_interface() and not zhuge_liang:is_null_interface() and not zhuge_liang:is_dead() then 
                family_member:divorce_spouse();
                family_member:marry_character(cm:modify_character(zhuge_liang):family_member());
            end
            
            cm:modify_faction("3k_main_faction_liu_bei"):increase_treasury(443120);
            xyy_character_add("3k_main_template_historical_huang_zhong_hero_metal", "3k_main_faction_liu_bei",
            "3k_general_metal");
            xyy_character_add("3k_main_template_historical_gan_ning_hero_fire", "3k_dlc05_faction_sun_ce", "3k_general_fire");
            --cm:set_saved_value("liu_biao_confederation", true);
            
            diplomacy_manager:force_confederation("3k_dlc05_faction_sun_ce", "3k_dlc05_faction_xu_zhao");
            diplomacy_manager:force_confederation("3k_dlc05_faction_sun_ce", "3k_dlc05_faction_hua_xin");
            diplomacy_manager:force_confederation("3k_dlc05_faction_sun_ce", "3k_dlc07_faction_li_shu");
            
            --荆州
            --长沙
            xyy_set_region_manager("3k_main_changsha_capital","3k_main_faction_liu_bei")
            xyy_set_region_manager("3k_main_changsha_resource_1","3k_main_faction_liu_bei")
            xyy_set_region_manager("3k_main_changsha_resource_2","3k_main_faction_liu_bei")
            xyy_set_region_manager("3k_main_changsha_resource_3","3k_main_faction_liu_bei")
            
            --零陵
            xyy_set_region_manager("3k_main_lingling_capital","3k_main_faction_liu_bei")
            xyy_set_region_manager("3k_main_lingling_resource_1","3k_main_faction_liu_bei")
            xyy_set_region_manager("3k_main_lingling_resource_2","3k_main_faction_liu_bei")
            xyy_set_region_manager("3k_main_lingling_resource_3","3k_main_faction_liu_bei")
            
            --庐陵
            xyy_set_region_manager("3k_main_luling_capital","3k_main_faction_liu_bei")
            xyy_set_region_manager("3k_main_luling_resource_1","3k_main_faction_liu_bei")
            
            --江夏
            xyy_set_region_manager("3k_main_jiangxia_capital","3k_main_faction_liu_bei")
            
            --襄阳
            xyy_set_region_manager("3k_main_xiangyang_resource_1","3k_main_faction_liu_bei")
            
            --南郡
            xyy_set_region_manager("3k_main_jingzhou_capital","3k_main_faction_liu_bei")
            xyy_set_region_manager("3k_main_jingzhou_resource_1","3k_main_faction_liu_bei")
            
            --武陵
            xyy_set_region_manager("3k_main_wuling_capital","3k_main_faction_liu_bei")
            xyy_set_region_manager("3k_main_wuling_resource_1","3k_main_faction_liu_bei")
            xyy_set_region_manager("3k_main_wuling_resource_2","3k_main_faction_liu_bei")
            xyy_set_region_manager("3k_main_wuling_resource_3","3k_main_faction_liu_bei")
            
            --交州
            --交趾
            --xyy_set_region_manager("3k_dlc06_jiaozhi_resource_3","3k_main_faction_liu_bei")
            
            --徐州
            --广陵
            xyy_set_region_manager_force("3k_main_guangling_resource_1","3k_dlc05_faction_sun_ce")
            xyy_set_region_manager_force("3k_main_guangling_resource_2","3k_dlc05_faction_sun_ce")
        
            --扬州
            --庐江
            xyy_set_region_manager_force("3k_main_yangzhou_resource_3","3k_dlc05_faction_sun_ce")
            
            --淮南
            xyy_set_region_manager_force("3k_main_lujiang_resource_1","3k_dlc05_faction_sun_ce")
            xyy_set_region_manager_force("3k_main_lujiang_resource_2","3k_dlc05_faction_sun_ce")
            
            --鄱阳
            xyy_set_region_manager_force("3k_main_poyang_capital","3k_dlc05_faction_sun_ce")
            xyy_set_region_manager_force("3k_main_poyang_resource_1","3k_dlc05_faction_sun_ce")
            xyy_set_region_manager_force("3k_main_poyang_resource_2","3k_dlc05_faction_sun_ce")
            xyy_set_region_manager_force("3k_main_poyang_resource_3","3k_dlc05_faction_sun_ce")
            
            --豫章
            xyy_set_region_manager_force("3k_main_yuzhang_capital","3k_dlc05_faction_sun_ce")
            xyy_set_region_manager_force("3k_main_yuzhang_resource_1","3k_dlc05_faction_sun_ce")
            xyy_set_region_manager_force("3k_main_yuzhang_resource_2","3k_dlc05_faction_sun_ce")
            xyy_set_region_manager_force("3k_main_yuzhang_resource_3","3k_dlc05_faction_sun_ce")
            
            --庐陵
            xyy_set_region_manager_force("3k_main_luling_capital","3k_dlc05_faction_sun_ce")
            xyy_set_region_manager_force("3k_main_luling_resource_1","3k_dlc05_faction_sun_ce")
            
            --丹阳
            xyy_set_region_manager_force("3k_main_jianye_capital","3k_dlc05_faction_sun_ce")
            xyy_set_region_manager_force("3k_main_jianye_resource_1","3k_dlc05_faction_sun_ce")
            xyy_set_region_manager_force("3k_main_jianye_resource_2","3k_dlc05_faction_sun_ce")
            
            --会稽
            xyy_set_region_manager_force("3k_main_kuaiji_capital","3k_dlc05_faction_sun_ce")
            xyy_set_region_manager_force("3k_main_kuaiji_resource_1","3k_dlc05_faction_sun_ce")
            xyy_set_region_manager_force("3k_main_kuaiji_resource_2","3k_dlc05_faction_sun_ce")
            
            --北建安
            xyy_set_region_manager_force("3k_main_jianan_capital","3k_dlc05_faction_sun_ce")
            xyy_set_region_manager_force("3k_main_jianan_resource_1","3k_dlc05_faction_sun_ce")
            xyy_set_region_manager_force("3k_main_jianan_resource_2","3k_dlc05_faction_sun_ce")
            
            --临海
            xyy_set_region_manager_force("3k_main_dongou_capital","3k_dlc05_faction_sun_ce")
            xyy_set_region_manager_force("3k_main_dongou_resource_1","3k_dlc05_faction_sun_ce")
            
            --南建安
            xyy_set_region_manager_force("3k_main_tongan_capital","3k_dlc05_faction_sun_ce")
            xyy_set_region_manager_force("3k_main_tongan_resource_1","3k_dlc05_faction_sun_ce")
        end
        --xyy_kill_character("3k_main_template_historical_liu_biao_hero_earth");
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
        and not cm:query_faction("3k_dlc05_faction_sun_ce"):is_human()
        and cm:query_model():campaign_name() == "3k_dlc07_start_pos";
    end,
    function(context)
        local faction = cm:query_faction("3k_dlc07_faction_shanyue_rebels") 
        if faction 
        and not faction:is_null_interface()
        and not faction:is_dead() then
            for i = 0, faction:region_list():num_items() - 1 do
                local region = faction:region_list():item_at(i);
                xyy_set_region_manager(region:name(),"3k_dlc05_faction_sun_ce")
            end
            diplomacy_manager:apply_automatic_deal_between_factions("3k_dlc05_faction_sun_ce", "3k_dlc07_faction_shanyue_rebels", "data_defined_situation_peace")
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
            xyy_set_region_manager("3k_main_badong_capital","3k_main_faction_liu_bei")
            xyy_set_region_manager("3k_main_badong_resource_1","3k_main_faction_liu_bei")
            xyy_set_region_manager("3k_main_badong_resource_2","3k_main_faction_liu_bei")
            
            --上庸
            xyy_set_region_manager("3k_main_shangyong_capital","3k_main_faction_liu_bei")
            xyy_set_region_manager("3k_main_shangyong_resource_1","3k_main_faction_liu_bei")
            xyy_set_region_manager("3k_main_shangyong_resource_2","3k_main_faction_liu_bei")
            
            --涪陵
            xyy_set_region_manager("3k_main_fuling_capital","3k_main_faction_liu_bei")
            xyy_set_region_manager("3k_main_fuling_resource_1","3k_main_faction_liu_bei")
            
            --巴郡
            xyy_set_region_manager("3k_main_bajun_capital","3k_main_faction_liu_bei")
            xyy_set_region_manager("3k_main_bajun_resource_1","3k_main_faction_liu_bei")
            
            --蜀郡
            xyy_set_region_manager("3k_main_chengdu_capital","3k_main_faction_liu_bei")
            xyy_set_region_manager("3k_main_chengdu_resource_1","3k_main_faction_liu_bei")
            xyy_set_region_manager("3k_main_chengdu_resource_2","3k_main_faction_liu_bei")
            xyy_set_region_manager("3k_main_chengdu_resource_3","3k_main_faction_liu_bei")
            
            --江阳
            xyy_set_region_manager("3k_main_jiangyang_capital","3k_main_faction_liu_bei")
            xyy_set_region_manager("3k_main_jiangyang_resource_1","3k_main_faction_liu_bei")
            xyy_set_region_manager("3k_main_jiangyang_resource_2","3k_main_faction_liu_bei")
            xyy_set_region_manager("3k_main_jiangyang_resource_3","3k_main_faction_liu_bei")
            
            --永昌
            xyy_set_region_manager("3k_dlc06_yongchang_capital","3k_main_faction_liu_bei")
            xyy_set_region_manager("3k_dlc06_yongchang_resource_1","3k_main_faction_liu_bei")
            
            --牂牁
            xyy_set_region_manager("3k_main_zangke_capital","3k_main_faction_liu_bei")
            xyy_set_region_manager("3k_main_zangke_resource_1","3k_main_faction_liu_bei")
            xyy_set_region_manager("3k_main_zangke_resource_2","3k_main_faction_liu_bei")
            
            --云南
            xyy_set_region_manager("3k_dlc06_yunnan_capital","3k_main_faction_liu_bei")
            xyy_set_region_manager("3k_dlc06_yunnan_resource_1","3k_main_faction_liu_bei")
            xyy_set_region_manager("3k_dlc06_yunnan_resource_2","3k_main_faction_liu_bei")
            
            --建宁
            xyy_set_region_manager("3k_main_jianning_capital","3k_main_faction_liu_bei")
            xyy_set_region_manager("3k_main_jianning_resource_1","3k_main_faction_liu_bei")
            xyy_set_region_manager("3k_main_jianning_resource_2","3k_main_faction_liu_bei")
            xyy_set_region_manager("3k_dlc06_jianning_resource_3","3k_main_faction_liu_bei")
            
            --巴西
            xyy_set_region_manager("3k_main_baxi_capital","3k_main_faction_liu_bei")
            xyy_set_region_manager("3k_main_baxi_resource_1","3k_main_faction_liu_bei")
            xyy_set_region_manager("3k_main_baxi_resource_2","3k_main_faction_liu_bei")
            
            --夔关
            xyy_set_region_manager("3k_dlc06_kui_pass","3k_main_faction_liu_bei")
            
            if not cm:query_faction("3k_main_faction_cao_cao"):is_human() then
                diplomacy_manager:force_confederation("3k_main_faction_cao_cao", "3k_dlc07_faction_zhang_lu");
            else
                cm:trigger_dilemma("3k_main_faction_cao_cao", "confederate_cao_cao_and_zhang_lu", true);
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
    end, -- criteria
    function (context) --what to do if listener fires
        if context:choice() == 0 then
            --益州
            --巴东
            xyy_set_region_manager("3k_main_badong_capital","3k_main_faction_liu_bei")
            xyy_set_region_manager("3k_main_badong_resource_1","3k_main_faction_liu_bei")
            xyy_set_region_manager("3k_main_badong_resource_2","3k_main_faction_liu_bei")
            
            --上庸
            xyy_set_region_manager("3k_main_shangyong_capital","3k_main_faction_liu_bei")
            xyy_set_region_manager("3k_main_shangyong_resource_1","3k_main_faction_liu_bei")
            xyy_set_region_manager("3k_main_shangyong_resource_2","3k_main_faction_liu_bei")
            
            --涪陵
            xyy_set_region_manager("3k_main_fuling_capital","3k_main_faction_liu_bei")
            xyy_set_region_manager("3k_main_fuling_resource_1","3k_main_faction_liu_bei")
            
            --巴郡
            xyy_set_region_manager("3k_main_bajun_capital","3k_main_faction_liu_bei")
            xyy_set_region_manager("3k_main_bajun_resource_1","3k_main_faction_liu_bei")
            
            --蜀郡
            xyy_set_region_manager("3k_main_chengdu_capital","3k_main_faction_liu_bei")
            xyy_set_region_manager("3k_main_chengdu_resource_1","3k_main_faction_liu_bei")
            xyy_set_region_manager("3k_main_chengdu_resource_2","3k_main_faction_liu_bei")
            xyy_set_region_manager("3k_main_chengdu_resource_3","3k_main_faction_liu_bei")
            
            --江阳
            xyy_set_region_manager("3k_main_jiangyang_capital","3k_main_faction_liu_bei")
            xyy_set_region_manager("3k_main_jiangyang_resource_1","3k_main_faction_liu_bei")
            xyy_set_region_manager("3k_main_jiangyang_resource_2","3k_main_faction_liu_bei")
            xyy_set_region_manager("3k_main_jiangyang_resource_3","3k_main_faction_liu_bei")
            
            --永昌
            xyy_set_region_manager("3k_dlc06_yongchang_capital","3k_main_faction_liu_bei")
            xyy_set_region_manager("3k_dlc06_yongchang_resource_1","3k_main_faction_liu_bei")
            
            --牂牁
            xyy_set_region_manager("3k_main_zangke_capital","3k_main_faction_liu_bei")
            xyy_set_region_manager("3k_main_zangke_resource_1","3k_main_faction_liu_bei")
            xyy_set_region_manager("3k_main_zangke_resource_2","3k_main_faction_liu_bei")
            
            --云南
            xyy_set_region_manager("3k_dlc06_yunnan_capital","3k_main_faction_liu_bei")
            xyy_set_region_manager("3k_dlc06_yunnan_resource_1","3k_main_faction_liu_bei")
            xyy_set_region_manager("3k_dlc06_yunnan_resource_2","3k_main_faction_liu_bei")
            
            --建宁
            xyy_set_region_manager("3k_main_jianning_capital","3k_main_faction_liu_bei")
            xyy_set_region_manager("3k_main_jianning_resource_1","3k_main_faction_liu_bei")
            xyy_set_region_manager("3k_main_jianning_resource_2","3k_main_faction_liu_bei")
            xyy_set_region_manager("3k_dlc06_jianning_resource_3","3k_main_faction_liu_bei")
            
            --巴西
            xyy_set_region_manager("3k_main_baxi_capital","3k_main_faction_liu_bei")
            xyy_set_region_manager("3k_main_baxi_resource_1","3k_main_faction_liu_bei")
            xyy_set_region_manager("3k_main_baxi_resource_2","3k_main_faction_liu_bei")
            
            --夔关
            xyy_set_region_manager("3k_dlc06_kui_pass","3k_main_faction_liu_bei")
            
            --cm:modify_faction("3k_main_faction_liu_bei"):apply_effect_bundle("world_leader",-1);
            
            if not cm:query_faction("3k_main_faction_cao_cao"):is_human() then
                diplomacy_manager:force_confederation("3k_main_faction_cao_cao", "3k_dlc07_faction_zhang_lu");
            else
                cm:trigger_dilemma("3k_main_faction_cao_cao","confederate_cao_cao_and_zhang_lu", true);
            end
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
        and not cm:query_faction("3k_main_faction_ma_teng"):is_human()
        and not cm:query_faction("3k_main_faction_liu_bei"):is_dead()
        and cm:query_model():campaign_name() == "3k_dlc07_start_pos";
    end,
    function()
        local ma_chao = cm:query_model():character_for_template("3k_main_template_historical_ma_chao_hero_fire")
        if not ma_chao:is_dead() then
            xyy_character_add("3k_main_template_historical_ma_chao_hero_fire", "3k_main_faction_liu_bei", "3k_general_fire")
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
        and context:faction():name() == "3k_dlc05_faction_sun_ce"
        and context:query_model():season() == "season_summer"
        and cm:query_model():campaign_name() == "3k_dlc07_start_pos"
        and not cm:query_faction("3k_main_faction_liu_bei"):is_dead();
    end,
    function(context)
            
        diplomacy_manager:apply_automatic_deal_between_factions("3k_dlc05_faction_sun_ce", "3k_main_faction_liu_bei", "data_quit_coalition")
        
        diplomacy_manager:apply_automatic_deal_between_factions("3k_dlc05_faction_sun_ce", "3k_main_faction_liu_bei",  "data_quit_allice")
            
        diplomacy_manager:apply_automatic_deal_between_factions("3k_main_faction_liu_bei", "3k_dlc05_faction_sun_ce", "data_defined_situation_break_deal")
        
        if not cm:query_faction("3k_dlc05_faction_sun_ce"):is_human() then
            xyy_set_region_manager("3k_main_changsha_capital","3k_dlc05_faction_sun_ce")
            xyy_set_region_manager("3k_main_changsha_resource_1","3k_dlc05_faction_sun_ce")
            xyy_set_region_manager("3k_main_changsha_resource_2","3k_dlc05_faction_sun_ce")
            xyy_set_region_manager("3k_main_changsha_resource_3","3k_dlc05_faction_sun_ce")
            
            xyy_set_region_manager("3k_main_yuzhang_capital","3k_dlc05_faction_sun_ce")
            xyy_set_region_manager("3k_main_yuzhang_resource_1","3k_dlc05_faction_sun_ce")
            xyy_set_region_manager("3k_main_yuzhang_resource_2","3k_dlc05_faction_sun_ce")
            xyy_set_region_manager("3k_main_yuzhang_resource_3","3k_dlc05_faction_sun_ce")
            
            xyy_set_region_manager("3k_main_poyang_capital","3k_dlc05_faction_sun_ce")
            xyy_set_region_manager("3k_main_poyang_resource_1","3k_dlc05_faction_sun_ce")
            xyy_set_region_manager("3k_main_poyang_resource_2","3k_dlc05_faction_sun_ce")
            xyy_set_region_manager("3k_main_poyang_resource_3","3k_dlc05_faction_sun_ce")
            
            xyy_set_region_manager("3k_main_luling_capital","3k_dlc05_faction_sun_ce")
            xyy_set_region_manager("3k_main_luling_resource_1","3k_dlc05_faction_sun_ce")
            
            xyy_set_region_manager("3k_main_lingling_capital","3k_dlc05_faction_sun_ce")
            xyy_set_region_manager("3k_main_lingling_resource_1","3k_dlc05_faction_sun_ce")
            xyy_set_region_manager("3k_main_lingling_resource_2","3k_dlc05_faction_sun_ce")
            xyy_set_region_manager("3k_main_lingling_resource_3","3k_dlc05_faction_sun_ce")
            
            xyy_set_region_manager("3k_main_cangwu_capital","3k_dlc05_faction_sun_ce")
            xyy_set_region_manager("3k_main_cangwu_resource_1","3k_dlc05_faction_sun_ce")
            xyy_set_region_manager("3k_main_cangwu_resource_2","3k_dlc05_faction_sun_ce")
            xyy_set_region_manager("3k_main_cangwu_resource_3","3k_dlc05_faction_sun_ce")
            
            xyy_set_region_manager("3k_main_jiangxia_capital","3k_dlc05_faction_sun_ce")
        end
        if cm:query_faction("3k_main_faction_liu_bei"):is_human() then
            cm:trigger_dilemma("3k_main_faction_liu_bei", "sun_quan_request_jingzhou", true);
        end
    end,
    false
)

core:add_listener(
    "sun_quan_request_jingzhou",
    "DilemmaChoiceMadeEvent",
    function(context) 
        return context:dilemma() == "sun_quan_request_jingzhou";
    end,
    function (context)
        local query_faction = context:faction();
        local lu_meng = cm:query_model():character_for_template("3k_main_template_historical_lu_meng_hero_metal");
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
        and not cm:query_faction("3k_main_faction_liu_bei"):is_dead();
    end,
    function()
        if not cm:query_faction("3k_main_faction_cao_cao"):is_human() then
            xyy_set_region_manager("3k_main_nanyang_capital","3k_main_faction_cao_cao")
            xyy_set_region_manager("3k_main_nanyang_resource_1","3k_main_faction_cao_cao")
            xyy_set_region_manager("3k_main_xiangyang_capital","3k_main_faction_cao_cao")
            xyy_set_region_manager("3k_main_jiangxia_resource_1","3k_main_faction_cao_cao")
            
            if cm:query_faction("3k_main_faction_ma_teng"):is_human() then
                xyy_set_region_manager("3k_main_wuwei_capital","3k_main_faction_cao_cao")
                xyy_set_region_manager("3k_main_wuwei_resource_1","3k_main_faction_cao_cao")
                xyy_set_region_manager("3k_main_wuwei_resource_2","3k_main_faction_cao_cao")
                
                xyy_set_region_manager("3k_main_jincheng_capital","3k_main_faction_cao_cao")
                xyy_set_region_manager("3k_main_jincheng_resource_1","3k_main_faction_cao_cao")
                xyy_set_region_manager("3k_main_jincheng_resource_2","3k_main_faction_cao_cao")
                
                xyy_set_region_manager("3k_main_anding_capital","3k_main_faction_cao_cao")
                
                local ma_teng = cm:query_model():character_for_template("3k_main_template_historical_ma_teng_hero_fire");
        
                if not ma_teng:is_character_is_faction_recruitment_pool() and not ma_teng:faction():is_human() then
                    xyy_kill_character("3k_main_template_historical_ma_teng_hero_fire");
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
        and not cm:query_faction("3k_main_faction_liu_bei"):is_dead();
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
            xyy_set_region_manager_random("3k_main_guangling_resource_1","3k_dlc05_faction_sun_ce")
            xyy_set_region_manager_random("3k_main_guangling_resource_2","3k_dlc05_faction_sun_ce")
        
            --扬州
            --庐江
            xyy_set_region_manager_random("3k_main_yangzhou_resource_3","3k_dlc05_faction_sun_ce")
            
            --淮南
            xyy_set_region_manager_random("3k_main_lujiang_resource_1","3k_dlc05_faction_sun_ce")
            xyy_set_region_manager_random("3k_main_lujiang_resource_2","3k_dlc05_faction_sun_ce")
            
            --鄱阳
            xyy_set_region_manager_random("3k_main_poyang_capital","3k_dlc05_faction_sun_ce")
            xyy_set_region_manager_random("3k_main_poyang_resource_1","3k_dlc05_faction_sun_ce")
            xyy_set_region_manager_random("3k_main_poyang_resource_2","3k_dlc05_faction_sun_ce")
            xyy_set_region_manager_random("3k_main_poyang_resource_3","3k_dlc05_faction_sun_ce")
            
            --豫章
            xyy_set_region_manager_random("3k_main_yuzhang_capital","3k_dlc05_faction_sun_ce")
            xyy_set_region_manager_random("3k_main_yuzhang_resource_1","3k_dlc05_faction_sun_ce")
            xyy_set_region_manager_random("3k_main_yuzhang_resource_2","3k_dlc05_faction_sun_ce")
            xyy_set_region_manager_random("3k_main_yuzhang_resource_3","3k_dlc05_faction_sun_ce")
            
            --庐陵
            xyy_set_region_manager_random("3k_main_luling_capital","3k_dlc05_faction_sun_ce")
            xyy_set_region_manager_random("3k_main_luling_resource_1","3k_dlc05_faction_sun_ce")
            
            --丹阳
            xyy_set_region_manager_random("3k_main_jianye_capital","3k_dlc05_faction_sun_ce")
            xyy_set_region_manager_random("3k_main_jianye_resource_1","3k_dlc05_faction_sun_ce")
            xyy_set_region_manager_random("3k_main_jianye_resource_2","3k_dlc05_faction_sun_ce")
            
            --会稽
            xyy_set_region_manager_random("3k_main_kuaiji_capital","3k_dlc05_faction_sun_ce")
            xyy_set_region_manager_random("3k_main_kuaiji_resource_1","3k_dlc05_faction_sun_ce")
            xyy_set_region_manager_random("3k_main_kuaiji_resource_2","3k_dlc05_faction_sun_ce")
            
            --北建安
            xyy_set_region_manager_random("3k_main_jianan_capital","3k_dlc05_faction_sun_ce")
            xyy_set_region_manager_random("3k_main_jianan_resource_1","3k_dlc05_faction_sun_ce")
            xyy_set_region_manager_random("3k_main_jianan_resource_2","3k_dlc05_faction_sun_ce")
            
            --临海
            xyy_set_region_manager_random("3k_main_dongou_capital","3k_dlc05_faction_sun_ce")
            xyy_set_region_manager_random("3k_main_dongou_resource_1","3k_dlc05_faction_sun_ce")
            
            --南建安
            xyy_set_region_manager_random("3k_main_tongan_capital","3k_dlc05_faction_sun_ce")
            xyy_set_region_manager_random("3k_main_tongan_resource_1","3k_dlc05_faction_sun_ce")
            
            --交州
            --南海
            xyy_set_region_manager_random("3k_main_nanhai_capital","3k_dlc05_faction_sun_ce")
            xyy_set_region_manager_random("3k_main_nanhai_resource_1","3k_dlc05_faction_sun_ce")
            xyy_set_region_manager_random("3k_main_nanhai_resource_2","3k_dlc05_faction_sun_ce")
            xyy_set_region_manager_random("3k_main_nanhai_resource_3","3k_dlc05_faction_sun_ce")
            
            --苍梧
            xyy_set_region_manager_random("3k_main_cangwu_capital","3k_dlc05_faction_sun_ce")
            xyy_set_region_manager_random("3k_main_cangwu_resource_1","3k_dlc05_faction_sun_ce")
            xyy_set_region_manager_random("3k_main_cangwu_resource_2","3k_dlc05_faction_sun_ce")
            
            --高凉
            xyy_set_region_manager_random("3k_main_gaoliang_capital","3k_dlc05_faction_sun_ce")
            xyy_set_region_manager_random("3k_main_gaoliang_resource_1","3k_dlc05_faction_sun_ce")
        
            --合浦
            xyy_set_region_manager_random("3k_main_hepu_capital","3k_dlc05_faction_sun_ce")
            xyy_set_region_manager_random("3k_main_hepu_resource_1","3k_dlc05_faction_sun_ce")
            xyy_set_region_manager_random("3k_main_hepu_resource_2","3k_dlc05_faction_sun_ce")
            
            --郁林
            xyy_set_region_manager_random("3k_main_yulin_capital","3k_dlc05_faction_sun_ce")
            xyy_set_region_manager_random("3k_main_yulin_resource_1","3k_dlc05_faction_sun_ce")
            xyy_set_region_manager_random("3k_main_yulin_resource_2","3k_dlc05_faction_sun_ce")
            xyy_set_region_manager_random("3k_main_cangwu_resource_3","3k_dlc05_faction_sun_ce")
            
            --交趾
            xyy_set_region_manager_random("3k_main_jiaozhi_capital","3k_dlc05_faction_sun_ce")
            xyy_set_region_manager_random("3k_main_jiaozhi_resource_1","3k_dlc05_faction_sun_ce")
            xyy_set_region_manager_random("3k_main_jiaozhi_resource_2","3k_dlc05_faction_sun_ce")
            
            --九真
            xyy_set_region_manager_random("3k_dlc06_jiuzhen_capital","3k_dlc05_faction_sun_ce")
            xyy_set_region_manager_random("3k_dlc06_jiuzhen_resource_1","3k_dlc05_faction_sun_ce")
        end
        
        if context:faction():name() == "3k_main_faction_cao_cao"
        and not cm:query_faction("3k_main_faction_cao_cao"):is_human() 
        then
            --司隶
            --长安
            xyy_set_region_manager_random("3k_main_changan_capital","3k_main_faction_cao_cao")
            xyy_set_region_manager_random("3k_main_changan_resource_1","3k_main_faction_cao_cao")
            
            --河东
            xyy_set_region_manager_random("3k_main_hedong_capital","3k_main_faction_cao_cao")
            xyy_set_region_manager_random("3k_main_hedong_resource_1","3k_main_faction_cao_cao")
            xyy_set_region_manager_random("3k_dlc06_hedong_resource_2","3k_main_faction_cao_cao")
            
            --洛阳
            xyy_set_region_manager_random("3k_main_luoyang_capital","3k_main_faction_cao_cao")
            xyy_set_region_manager_random("3k_main_luoyang_resource_1","3k_main_faction_cao_cao")
            xyy_set_region_manager_random("3k_main_chenjun_resource_3","3k_main_faction_cao_cao")
            
            --散关
            xyy_set_region_manager_random("3k_dlc06_san_pass","3k_main_faction_cao_cao")
            
            --潼关
            xyy_set_region_manager_random("3k_dlc06_tong_pass","3k_main_faction_cao_cao")
            
            --武关
            xyy_set_region_manager_random("3k_dlc06_wu_pass","3k_main_faction_cao_cao")
            
            --函谷关
            xyy_set_region_manager_random("3k_dlc06_hangu_pass","3k_main_faction_cao_cao")
            
            --虎牢关
            xyy_set_region_manager_random("3k_dlc06_hulao_pass","3k_main_faction_cao_cao")
            
            --葭萌关
            xyy_set_region_manager_random("3k_dlc06_jiameng_pass","3k_main_faction_cao_cao")
            
            --濝关
            xyy_set_region_manager_random("3k_dlc06_qi_pass","3k_main_faction_cao_cao")
            
            --凉州
            --武威
            xyy_set_region_manager_random("3k_main_wuwei_capital","3k_main_faction_cao_cao")
            xyy_set_region_manager_random("3k_main_wuwei_resource_1","3k_main_faction_cao_cao")
            xyy_set_region_manager_random("3k_main_wuwei_resource_2","3k_main_faction_cao_cao")
            
            --金城
            xyy_set_region_manager_random("3k_main_jincheng_capital","3k_main_faction_cao_cao")
            xyy_set_region_manager_random("3k_main_jincheng_resource_1","3k_main_faction_cao_cao")
            xyy_set_region_manager_random("3k_main_jincheng_resource_2","3k_main_faction_cao_cao")
            
            --安定
            xyy_set_region_manager_random("3k_main_anding_capital","3k_main_faction_cao_cao")
            
            --武都
            xyy_set_region_manager_random("3k_main_wudu_capital","3k_main_faction_cao_cao")
            xyy_set_region_manager_random("3k_main_wudu_resource_1","3k_main_faction_cao_cao")
            xyy_set_region_manager_random("3k_main_wudu_resource_2","3k_main_faction_cao_cao")
            
            --武都
            xyy_set_region_manager_random("3k_main_wudu_capital","3k_main_faction_cao_cao")
            xyy_set_region_manager_random("3k_main_wudu_resource_1","3k_main_faction_cao_cao")
            xyy_set_region_manager_random("3k_main_wudu_resource_2","3k_main_faction_cao_cao")
            
            --并州
            --太原
            xyy_set_region_manager_random("3k_main_taiyuan_capital","3k_main_faction_cao_cao")
            xyy_set_region_manager_random("3k_main_taiyuan_resource_1","3k_main_faction_cao_cao")
            xyy_set_region_manager_random("3k_main_taiyuan_resource_2","3k_main_faction_cao_cao")
            
            --故关
            xyy_set_region_manager_random("3k_dlc06_gu_pass","3k_main_faction_cao_cao")
            
            --雁门
            xyy_set_region_manager_random("3k_main_yanmen_capital","3k_main_faction_cao_cao")
            xyy_set_region_manager_random("3k_main_yanmen_resource_1","3k_main_faction_cao_cao")
            
            --上党
            xyy_set_region_manager_random("3k_main_shangdang_capital","3k_main_faction_cao_cao")
            xyy_set_region_manager_random("3k_main_shangdang_resource_1","3k_main_faction_cao_cao")
            xyy_set_region_manager_random("3k_dlc06_shangdang_resource_2","3k_main_faction_cao_cao")
            
            --冀州
            --中山
            xyy_set_region_manager_random("3k_main_zhongshan_capital","3k_main_faction_cao_cao")
            xyy_set_region_manager_random("3k_main_zhongshan_resource_1","3k_main_faction_cao_cao")
            
            --安平
            xyy_set_region_manager_random("3k_main_anping_capital","3k_main_faction_cao_cao")
            xyy_set_region_manager_random("3k_main_anping_resource_1","3k_main_faction_cao_cao")
            
            --魏郡
            xyy_set_region_manager_random("3k_main_weijun_capital","3k_main_faction_cao_cao")
            xyy_set_region_manager_random("3k_main_weijun_resource_1","3k_main_faction_cao_cao")
            
            --河内
            xyy_set_region_manager_random("3k_main_henei_capital","3k_main_faction_cao_cao")
            xyy_set_region_manager_random("3k_main_henei_resource_1","3k_main_faction_cao_cao")
            
            --渤海
            xyy_set_region_manager_random("3k_main_bohai_capital","3k_main_faction_cao_cao")
            xyy_set_region_manager_random("3k_main_bohai_resource_1","3k_main_faction_cao_cao")
            
            --幽州
            --代郡
            xyy_set_region_manager_random("3k_main_daijun_capital","3k_main_faction_cao_cao")
            xyy_set_region_manager_random("3k_main_daijun_resource_1","3k_main_faction_cao_cao")
            
            --广阳
            xyy_set_region_manager_random("3k_main_youzhou_capital","3k_main_faction_cao_cao")
            xyy_set_region_manager_random("3k_main_youzhou_resource_1","3k_main_faction_cao_cao")
            
            --右北平
            xyy_set_region_manager_random("3k_main_youbeiping_capital","3k_main_faction_cao_cao")
            xyy_set_region_manager_random("3k_main_youbeiping_resource_1","3k_main_faction_cao_cao")
            
            --辽西
            xyy_set_region_manager_random("3k_main_yu_capital","3k_main_faction_cao_cao")
            xyy_set_region_manager_random("3k_main_yu_resource_1","3k_main_faction_cao_cao")
            
            --青州
            --平原
            xyy_set_region_manager_random("3k_main_pingyuan_capital","3k_main_faction_cao_cao")
            xyy_set_region_manager_random("3k_main_pingyuan_resource_1","3k_main_faction_cao_cao")
            
            --乐安
            xyy_set_region_manager_random("3k_main_taishan_capital","3k_main_faction_cao_cao")
            xyy_set_region_manager_random("3k_main_taishan_resource_1","3k_main_faction_cao_cao")
            
            --北海
            xyy_set_region_manager_random("3k_main_beihai_capital","3k_main_faction_cao_cao")
            xyy_set_region_manager_random("3k_main_beihai_resource_1","3k_main_faction_cao_cao")
            
            --东莱
            xyy_set_region_manager_random("3k_main_donglai_capital","3k_main_faction_cao_cao")
            xyy_set_region_manager_random("3k_main_donglai_resource_1","3k_main_faction_cao_cao")
            
            --兖州
            --东郡
            xyy_set_region_manager_random("3k_main_dongjun_capital","3k_main_faction_cao_cao")
            xyy_set_region_manager_random("3k_main_dongjun_resource_1","3k_main_faction_cao_cao")
            
            --颍川
            xyy_set_region_manager_random("3k_main_yingchuan_capital","3k_main_faction_cao_cao")
            xyy_set_region_manager_random("3k_main_yingchuan_resource_1","3k_main_faction_cao_cao")
            
            --徐州
            --彭城
            xyy_set_region_manager_random("3k_main_penchang_capital","3k_main_faction_cao_cao")
            xyy_set_region_manager_random("3k_main_penchang_resource_1","3k_main_faction_cao_cao")
            xyy_set_region_manager_random("3k_main_penchang_resource_2","3k_main_faction_cao_cao")
            
            --下邳
            xyy_set_region_manager_random("3k_dlc06_xiapi_capital","3k_main_faction_cao_cao")
            xyy_set_region_manager_random("3k_dlc06_xiapi_resource_1","3k_main_faction_cao_cao")
            
            --琅琊
            xyy_set_region_manager_random("3k_main_langye_capital","3k_main_faction_cao_cao")
            xyy_set_region_manager_random("3k_main_langye_resource_1","3k_main_faction_cao_cao")
            xyy_set_region_manager_random("3k_main_langye_resource_2","3k_main_faction_cao_cao")
            
            --东海
            xyy_set_region_manager_random("3k_main_donghai_capital","3k_main_faction_cao_cao")
            xyy_set_region_manager_random("3k_main_donghai_resource_1","3k_main_faction_cao_cao")
            
            --广陵
            xyy_set_region_manager_random("3k_main_guangling_capital","3k_main_faction_cao_cao")
            
            --豫州
            --陈郡
            xyy_set_region_manager_random("3k_main_chenjun_capital","3k_main_faction_cao_cao")
            xyy_set_region_manager_random("3k_main_chenjun_resource_1","3k_main_faction_cao_cao")
            xyy_set_region_manager_random("3k_main_chenjun_resource_2","3k_main_faction_cao_cao")
            
            --汝南
            xyy_set_region_manager_random("3k_main_runan_capital","3k_main_faction_cao_cao")
            xyy_set_region_manager_random("3k_main_runan_resource_1","3k_main_faction_cao_cao")
            
            --荆州
            --南阳
            xyy_set_region_manager_random("3k_main_nanyang_capital","3k_main_faction_cao_cao")
            xyy_set_region_manager_random("3k_main_nanyang_resource_1","3k_main_faction_cao_cao")
            
            --襄阳
            xyy_set_region_manager_random("3k_main_xiangyang_capital","3k_main_faction_cao_cao")
            
            --江夏
            xyy_set_region_manager_random("3k_main_jiangxia_resource_1","3k_main_faction_cao_cao")
            
            --扬州
            --庐江
            xyy_set_region_manager_random("3k_main_lujiang_capital","3k_main_faction_cao_cao")
            
            --淮南
            xyy_set_region_manager_random("3k_main_yangzhou_capital","3k_main_faction_cao_cao")
            xyy_set_region_manager_random("3k_main_yangzhou_resource_1","3k_main_faction_cao_cao")
            xyy_set_region_manager_random("3k_main_yangzhou_resource_2","3k_main_faction_cao_cao")
            
        end
        
        if context:faction():name() == "3k_main_faction_liu_bei"
        and not cm:query_faction("3k_main_faction_liu_bei"):is_human()then
            
            --荆州
            --长沙
            xyy_set_region_manager_random("3k_main_changsha_capital","3k_main_faction_liu_bei")
            xyy_set_region_manager_random("3k_main_changsha_resource_1","3k_main_faction_liu_bei")
            xyy_set_region_manager_random("3k_main_changsha_resource_2","3k_main_faction_liu_bei")
            xyy_set_region_manager_random("3k_main_changsha_resource_3","3k_main_faction_liu_bei")
            
            --零陵
            xyy_set_region_manager_random("3k_main_lingling_capital","3k_main_faction_liu_bei")
            xyy_set_region_manager_random("3k_main_lingling_resource_1","3k_main_faction_liu_bei")
            xyy_set_region_manager_random("3k_main_lingling_resource_2","3k_main_faction_liu_bei")
            xyy_set_region_manager_random("3k_main_lingling_resource_3","3k_main_faction_liu_bei")
            
            --庐陵
            xyy_set_region_manager_random("3k_main_luling_capital","3k_main_faction_liu_bei")
            xyy_set_region_manager_random("3k_main_luling_resource_1","3k_main_faction_liu_bei")
            
            --江夏
            xyy_set_region_manager_random("3k_main_jiangxia_capital","3k_main_faction_liu_bei")
            
            --襄阳
            xyy_set_region_manager_random("3k_main_xiangyang_resource_1","3k_main_faction_liu_bei")
            
            --南郡
            xyy_set_region_manager_random("3k_main_jingzhou_capital","3k_main_faction_liu_bei")
            xyy_set_region_manager_random("3k_main_jingzhou_resource_1","3k_main_faction_liu_bei")
            
            --武陵
            xyy_set_region_manager_random("3k_main_wuling_capital","3k_main_faction_liu_bei")
            xyy_set_region_manager_random("3k_main_wuling_resource_1","3k_main_faction_liu_bei")
            xyy_set_region_manager_random("3k_main_wuling_resource_2","3k_main_faction_liu_bei")
            xyy_set_region_manager_random("3k_main_wuling_resource_3","3k_main_faction_liu_bei")
            
            --交州
            --交趾
            xyy_set_region_manager_random("3k_dlc06_jiaozhi_resource_3","3k_main_faction_liu_bei")
            
            --益州
            --巴东
            xyy_set_region_manager_random("3k_main_badong_capital","3k_main_faction_liu_bei")
            xyy_set_region_manager_random("3k_main_badong_resource_1","3k_main_faction_liu_bei")
            xyy_set_region_manager_random("3k_main_badong_resource_2","3k_main_faction_liu_bei")
            
            --上庸
            xyy_set_region_manager_random("3k_main_shangyong_capital","3k_main_faction_liu_bei")
            xyy_set_region_manager_random("3k_main_shangyong_resource_1","3k_main_faction_liu_bei")
            xyy_set_region_manager_random("3k_main_shangyong_resource_2","3k_main_faction_liu_bei")
            
            --涪陵
            xyy_set_region_manager_random("3k_main_fuling_capital","3k_main_faction_liu_bei")
            xyy_set_region_manager_random("3k_main_fuling_resource_1","3k_main_faction_liu_bei")
            
            --巴郡
            xyy_set_region_manager_random("3k_main_bajun_capital","3k_main_faction_liu_bei")
            xyy_set_region_manager_random("3k_main_bajun_resource_1","3k_main_faction_liu_bei")
            
            --蜀郡
            xyy_set_region_manager_random("3k_main_chengdu_capital","3k_main_faction_liu_bei")
            xyy_set_region_manager_random("3k_main_chengdu_resource_1","3k_main_faction_liu_bei")
            xyy_set_region_manager_random("3k_main_chengdu_resource_2","3k_main_faction_liu_bei")
            xyy_set_region_manager_random("3k_main_chengdu_resource_3","3k_main_faction_liu_bei")
            
            --江阳
            xyy_set_region_manager_random("3k_main_jiangyang_capital","3k_main_faction_liu_bei")
            xyy_set_region_manager_random("3k_main_jiangyang_resource_1","3k_main_faction_liu_bei")
            xyy_set_region_manager_random("3k_main_jiangyang_resource_2","3k_main_faction_liu_bei")
            xyy_set_region_manager_random("3k_main_jiangyang_resource_3","3k_main_faction_liu_bei")
            
            --永昌
            xyy_set_region_manager_random("3k_dlc06_yongchang_capital","3k_main_faction_liu_bei")
            xyy_set_region_manager_random("3k_dlc06_yongchang_resource_1","3k_main_faction_liu_bei")
            
            --牂牁
            xyy_set_region_manager_random("3k_main_zangke_capital","3k_main_faction_liu_bei")
            xyy_set_region_manager_random("3k_main_zangke_resource_1","3k_main_faction_liu_bei")
            xyy_set_region_manager_random("3k_main_zangke_resource_2","3k_main_faction_liu_bei")
            
            --云南
            xyy_set_region_manager_random("3k_dlc06_yunnan_capital","3k_main_faction_liu_bei")
            xyy_set_region_manager_random("3k_dlc06_yunnan_resource_1","3k_main_faction_liu_bei")
            xyy_set_region_manager_random("3k_dlc06_yunnan_resource_2","3k_main_faction_liu_bei")
            
            --建宁
            xyy_set_region_manager_random("3k_main_jianning_capital","3k_main_faction_liu_bei")
            xyy_set_region_manager_random("3k_main_jianning_resource_1","3k_main_faction_liu_bei")
            xyy_set_region_manager_random("3k_main_jianning_resource_2","3k_main_faction_liu_bei")
            xyy_set_region_manager_random("3k_dlc06_jianning_resource_3","3k_main_faction_liu_bei")
            
            --巴西
            xyy_set_region_manager_random("3k_main_baxi_capital","3k_main_faction_liu_bei")
            xyy_set_region_manager_random("3k_main_baxi_resource_1","3k_main_faction_liu_bei")
            xyy_set_region_manager_random("3k_main_baxi_resource_2","3k_main_faction_liu_bei")
            
            --夔关
            xyy_set_region_manager_random("3k_dlc06_kui_pass","3k_main_faction_liu_bei")
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
        and not cm:query_faction("3k_main_faction_liu_bei"):is_dead();
    end,
    function()
        if not cm:query_faction("3k_dlc05_faction_sun_ce"):is_human() then
            xyy_set_region_manager("3k_main_kuaiji_capital","3k_dlc05_faction_sun_ce")
            xyy_set_region_manager("3k_main_kuaiji_resource_1","3k_dlc05_faction_sun_ce")
            xyy_set_region_manager("3k_main_kuaiji_resource_2","3k_dlc05_faction_sun_ce")
            xyy_set_region_manager("3k_main_jianan_capital","3k_dlc05_faction_sun_ce")
            xyy_set_region_manager("3k_main_jianan_resource_1","3k_dlc05_faction_sun_ce")
            xyy_set_region_manager("3k_main_jianan_resource_2","3k_dlc05_faction_sun_ce")
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
        and not cm:query_faction("3k_main_faction_liu_bei"):is_dead();
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
            xyy_set_region_manager_random("3k_main_guangling_resource_1","3k_dlc05_faction_sun_ce")
            xyy_set_region_manager_random("3k_main_guangling_resource_2","3k_dlc05_faction_sun_ce")
        
            --扬州
            --庐江
            xyy_set_region_manager_random("3k_main_yangzhou_resource_3","3k_dlc05_faction_sun_ce")
            
            --淮南
            xyy_set_region_manager_random("3k_main_lujiang_resource_1","3k_dlc05_faction_sun_ce")
            xyy_set_region_manager_random("3k_main_lujiang_resource_2","3k_dlc05_faction_sun_ce")
            
            --鄱阳
            xyy_set_region_manager_random("3k_main_poyang_capital","3k_dlc05_faction_sun_ce")
            xyy_set_region_manager_random("3k_main_poyang_resource_1","3k_dlc05_faction_sun_ce")
            xyy_set_region_manager_random("3k_main_poyang_resource_2","3k_dlc05_faction_sun_ce")
            xyy_set_region_manager_random("3k_main_poyang_resource_3","3k_dlc05_faction_sun_ce")
            
            --豫章
            xyy_set_region_manager_random("3k_main_yuzhang_capital","3k_dlc05_faction_sun_ce")
            xyy_set_region_manager_random("3k_main_yuzhang_resource_1","3k_dlc05_faction_sun_ce")
            xyy_set_region_manager_random("3k_main_yuzhang_resource_2","3k_dlc05_faction_sun_ce")
            xyy_set_region_manager_random("3k_main_yuzhang_resource_3","3k_dlc05_faction_sun_ce")
            
            --庐陵
            xyy_set_region_manager_random("3k_main_luling_capital","3k_dlc05_faction_sun_ce")
            xyy_set_region_manager_random("3k_main_luling_resource_1","3k_dlc05_faction_sun_ce")
            
            --丹阳
            xyy_set_region_manager_random("3k_main_jianye_capital","3k_dlc05_faction_sun_ce")
            xyy_set_region_manager_random("3k_main_jianye_resource_1","3k_dlc05_faction_sun_ce")
            xyy_set_region_manager_random("3k_main_jianye_resource_2","3k_dlc05_faction_sun_ce")
            
            --会稽
            xyy_set_region_manager_random("3k_main_kuaiji_capital","3k_dlc05_faction_sun_ce")
            xyy_set_region_manager_random("3k_main_kuaiji_resource_1","3k_dlc05_faction_sun_ce")
            xyy_set_region_manager_random("3k_main_kuaiji_resource_2","3k_dlc05_faction_sun_ce")
            
            --北建安
            xyy_set_region_manager_random("3k_main_jianan_capital","3k_dlc05_faction_sun_ce")
            xyy_set_region_manager_random("3k_main_jianan_resource_1","3k_dlc05_faction_sun_ce")
            xyy_set_region_manager_random("3k_main_jianan_resource_2","3k_dlc05_faction_sun_ce")
            
            --临海
            xyy_set_region_manager_random("3k_main_dongou_capital","3k_dlc05_faction_sun_ce")
            xyy_set_region_manager_random("3k_main_dongou_resource_1","3k_dlc05_faction_sun_ce")
            
            --南建安
            xyy_set_region_manager_random("3k_main_tongan_capital","3k_dlc05_faction_sun_ce")
            xyy_set_region_manager_random("3k_main_tongan_resource_1","3k_dlc05_faction_sun_ce")
            
            --交州
            --南海
            xyy_set_region_manager_random("3k_main_nanhai_capital","3k_dlc05_faction_sun_ce")
            xyy_set_region_manager_random("3k_main_nanhai_resource_1","3k_dlc05_faction_sun_ce")
            xyy_set_region_manager_random("3k_main_nanhai_resource_2","3k_dlc05_faction_sun_ce")
            xyy_set_region_manager_random("3k_main_nanhai_resource_3","3k_dlc05_faction_sun_ce")
            
            --苍梧
            xyy_set_region_manager_random("3k_main_cangwu_capital","3k_dlc05_faction_sun_ce")
            xyy_set_region_manager_random("3k_main_cangwu_resource_1","3k_dlc05_faction_sun_ce")
            xyy_set_region_manager_random("3k_main_cangwu_resource_2","3k_dlc05_faction_sun_ce")
            
            --高凉
            xyy_set_region_manager_random("3k_main_gaoliang_capital","3k_dlc05_faction_sun_ce")
            xyy_set_region_manager_random("3k_main_gaoliang_resource_1","3k_dlc05_faction_sun_ce")
        
            --合浦
            xyy_set_region_manager_random("3k_main_hepu_capital","3k_dlc05_faction_sun_ce")
            xyy_set_region_manager_random("3k_main_hepu_resource_1","3k_dlc05_faction_sun_ce")
            xyy_set_region_manager_random("3k_main_hepu_resource_2","3k_dlc05_faction_sun_ce")
            
            --郁林
            xyy_set_region_manager_random("3k_main_yulin_capital","3k_dlc05_faction_sun_ce")
            xyy_set_region_manager_random("3k_main_yulin_resource_1","3k_dlc05_faction_sun_ce")
            xyy_set_region_manager_random("3k_main_yulin_resource_2","3k_dlc05_faction_sun_ce")
            xyy_set_region_manager_random("3k_main_cangwu_resource_3","3k_dlc05_faction_sun_ce")
            
            --交趾
            xyy_set_region_manager_random("3k_main_jiaozhi_capital","3k_dlc05_faction_sun_ce")
            xyy_set_region_manager_random("3k_main_jiaozhi_resource_1","3k_dlc05_faction_sun_ce")
            xyy_set_region_manager_random("3k_main_jiaozhi_resource_2","3k_dlc05_faction_sun_ce")
            
            --九真
            xyy_set_region_manager_random("3k_dlc06_jiuzhen_capital","3k_dlc05_faction_sun_ce")
            xyy_set_region_manager_random("3k_dlc06_jiuzhen_resource_1","3k_dlc05_faction_sun_ce")
            
            --荆州
            --长沙
            xyy_set_region_manager_random("3k_main_changsha_capital","3k_dlc05_faction_sun_ce")
            xyy_set_region_manager_random("3k_main_changsha_resource_1","3k_dlc05_faction_sun_ce")
            xyy_set_region_manager_random("3k_main_changsha_resource_2","3k_dlc05_faction_sun_ce")
            xyy_set_region_manager_random("3k_main_changsha_resource_3","3k_dlc05_faction_sun_ce")
            
            --零陵
            xyy_set_region_manager_random("3k_main_lingling_capital","3k_dlc05_faction_sun_ce")
            xyy_set_region_manager_random("3k_main_lingling_resource_1","3k_dlc05_faction_sun_ce")
            xyy_set_region_manager_random("3k_main_lingling_resource_2","3k_dlc05_faction_sun_ce")
            xyy_set_region_manager_random("3k_main_lingling_resource_3","3k_dlc05_faction_sun_ce")
            
            --庐陵
            xyy_set_region_manager_random("3k_main_luling_capital","3k_dlc05_faction_sun_ce")
            xyy_set_region_manager_random("3k_main_luling_resource_1","3k_dlc05_faction_sun_ce")
            
            --江夏
            xyy_set_region_manager_random("3k_main_jiangxia_capital","3k_dlc05_faction_sun_ce")
            
        end
        if context:faction():name() == "3k_main_faction_cao_cao"
        and not cm:query_faction("3k_main_faction_cao_cao"):is_human() 
        then
            --司隶
            --长安
            xyy_set_region_manager_random("3k_main_changan_capital","3k_main_faction_cao_cao")
            xyy_set_region_manager_random("3k_main_changan_resource_1","3k_main_faction_cao_cao")
            
            --河东
            xyy_set_region_manager_random("3k_main_hedong_capital","3k_main_faction_cao_cao")
            xyy_set_region_manager_random("3k_main_hedong_resource_1","3k_main_faction_cao_cao")
            xyy_set_region_manager_random("3k_dlc06_hedong_resource_2","3k_main_faction_cao_cao")
            
            --洛阳
            xyy_set_region_manager_random("3k_main_luoyang_capital","3k_main_faction_cao_cao")
            xyy_set_region_manager_random("3k_main_luoyang_resource_1","3k_main_faction_cao_cao")
            xyy_set_region_manager_random("3k_main_chenjun_resource_3","3k_main_faction_cao_cao")
            
            --散关
            xyy_set_region_manager_random("3k_dlc06_san_pass","3k_main_faction_cao_cao")
            
            --潼关
            xyy_set_region_manager_random("3k_dlc06_tong_pass","3k_main_faction_cao_cao")
            
            --武关
            xyy_set_region_manager_random("3k_dlc06_wu_pass","3k_main_faction_cao_cao")
            
            --函谷关
            xyy_set_region_manager_random("3k_dlc06_hangu_pass","3k_main_faction_cao_cao")
            
            --虎牢关
            xyy_set_region_manager_random("3k_dlc06_hulao_pass","3k_main_faction_cao_cao")
            
            --葭萌关
            xyy_set_region_manager_random("3k_dlc06_jiameng_pass","3k_main_faction_cao_cao")
            
            --濝关
            xyy_set_region_manager_random("3k_dlc06_qi_pass","3k_main_faction_cao_cao")
            
            --凉州
            --武威
            xyy_set_region_manager_random("3k_main_wuwei_capital","3k_main_faction_cao_cao")
            xyy_set_region_manager_random("3k_main_wuwei_resource_1","3k_main_faction_cao_cao")
            xyy_set_region_manager_random("3k_main_wuwei_resource_2","3k_main_faction_cao_cao")
            
            --金城
            xyy_set_region_manager_random("3k_main_jincheng_capital","3k_main_faction_cao_cao")
            xyy_set_region_manager_random("3k_main_jincheng_resource_1","3k_main_faction_cao_cao")
            xyy_set_region_manager_random("3k_main_jincheng_resource_2","3k_main_faction_cao_cao")
            
            --安定
            xyy_set_region_manager_random("3k_main_anding_capital","3k_main_faction_cao_cao")
            xyy_set_region_manager_random("3k_main_anding_resource_1","xyyhlyja")--（羌胡占）
            xyy_set_region_manager_random("3k_main_anding_resource_2","xyyhlyja")--（羌胡占）
            xyy_set_region_manager_random("3k_main_anding_resource_3","xyyhlyja")--（羌胡占）
            
            --武都
            xyy_set_region_manager_random("3k_main_wudu_capital","3k_main_faction_cao_cao")
            xyy_set_region_manager_random("3k_main_wudu_resource_1","3k_main_faction_cao_cao")
            xyy_set_region_manager_random("3k_main_wudu_resource_2","3k_main_faction_cao_cao")
            
            --武都
            xyy_set_region_manager_random("3k_main_wudu_capital","3k_main_faction_cao_cao")
            xyy_set_region_manager_random("3k_main_wudu_resource_1","3k_main_faction_cao_cao")
            xyy_set_region_manager_random("3k_main_wudu_resource_2","3k_main_faction_cao_cao")
            
            --并州
            --朔方（羌胡占）
            xyy_set_region_manager_random("3k_main_shoufang_capital","xyyhlyja")
            xyy_set_region_manager_random("3k_main_shoufang_resource_1","xyyhlyja")
            xyy_set_region_manager_random("3k_main_shoufang_resource_2","xyyhlyja")
            xyy_set_region_manager_random("3k_main_shoufang_resource_3","xyyhlyja")
            
            --西河（羌胡占）
            xyy_set_region_manager_random("3k_main_xihe_capital","xyyhlyja")
            xyy_set_region_manager_random("3k_main_xihe_resource_1","xyyhlyja")
            
            --太原
            xyy_set_region_manager_random("3k_main_taiyuan_capital","3k_main_faction_cao_cao")
            xyy_set_region_manager_random("3k_main_taiyuan_resource_1","3k_main_faction_cao_cao")
            xyy_set_region_manager_random("3k_main_taiyuan_resource_2","3k_main_faction_cao_cao")
            
            --故关
            xyy_set_region_manager_random("3k_dlc06_gu_pass","3k_main_faction_cao_cao")
            
            --雁门
            xyy_set_region_manager_random("3k_main_yanmen_capital","3k_main_faction_cao_cao")
            xyy_set_region_manager_random("3k_main_yanmen_resource_1","3k_main_faction_cao_cao")
            
            --上党
            xyy_set_region_manager_random("3k_main_shangdang_capital","3k_main_faction_cao_cao")
            xyy_set_region_manager_random("3k_main_shangdang_resource_1","3k_main_faction_cao_cao")
            xyy_set_region_manager_random("3k_dlc06_shangdang_resource_2","3k_main_faction_cao_cao")
            
            --冀州
            --中山
            xyy_set_region_manager_random("3k_main_zhongshan_capital","3k_main_faction_cao_cao")
            xyy_set_region_manager_random("3k_main_zhongshan_resource_1","3k_main_faction_cao_cao")
            
            --安平
            xyy_set_region_manager_random("3k_main_anping_capital","3k_main_faction_cao_cao")
            xyy_set_region_manager_random("3k_main_anping_resource_1","3k_main_faction_cao_cao")
            
            --魏郡
            xyy_set_region_manager_random("3k_main_weijun_capital","3k_main_faction_cao_cao")
            xyy_set_region_manager_random("3k_main_weijun_resource_1","3k_main_faction_cao_cao")
            
            --河内
            xyy_set_region_manager_random("3k_main_henei_capital","3k_main_faction_cao_cao")
            xyy_set_region_manager_random("3k_main_henei_resource_1","3k_main_faction_cao_cao")
            
            --渤海
            xyy_set_region_manager_random("3k_main_bohai_capital","3k_main_faction_cao_cao")
            xyy_set_region_manager_random("3k_main_bohai_resource_1","3k_main_faction_cao_cao")
            
            --幽州
            --代郡
            xyy_set_region_manager_random("3k_main_daijun_capital","3k_main_faction_cao_cao")
            xyy_set_region_manager_random("3k_main_daijun_resource_1","3k_main_faction_cao_cao")
            
            --广阳
            xyy_set_region_manager_random("3k_main_youzhou_capital","3k_main_faction_cao_cao")
            xyy_set_region_manager_random("3k_main_youzhou_resource_1","3k_main_faction_cao_cao")
            
            --右北平
            xyy_set_region_manager_random("3k_main_youbeiping_capital","3k_main_faction_cao_cao")
            xyy_set_region_manager_random("3k_main_youbeiping_resource_1","3k_main_faction_cao_cao")
            
            --辽西
            xyy_set_region_manager_random("3k_main_yu_capital","3k_main_faction_cao_cao")
            xyy_set_region_manager_random("3k_main_yu_resource_1","3k_main_faction_cao_cao")
            
            --青州
            --平原
            xyy_set_region_manager_random("3k_main_pingyuan_capital","3k_main_faction_cao_cao")
            xyy_set_region_manager_random("3k_main_pingyuan_resource_1","3k_main_faction_cao_cao")
            
            --乐安
            xyy_set_region_manager_random("3k_main_taishan_capital","3k_main_faction_cao_cao")
            xyy_set_region_manager_random("3k_main_taishan_resource_1","3k_main_faction_cao_cao")
            
            --北海
            xyy_set_region_manager_random("3k_main_beihai_capital","3k_main_faction_cao_cao")
            xyy_set_region_manager_random("3k_main_beihai_resource_1","3k_main_faction_cao_cao")
            
            --东莱
            xyy_set_region_manager_random("3k_main_donglai_capital","3k_main_faction_cao_cao")
            xyy_set_region_manager_random("3k_main_donglai_resource_1","3k_main_faction_cao_cao")
            
            --兖州
            --东郡
            xyy_set_region_manager_random("3k_main_dongjun_capital","3k_main_faction_cao_cao")
            xyy_set_region_manager_random("3k_main_dongjun_resource_1","3k_main_faction_cao_cao")
            
            --颍川
            xyy_set_region_manager_random("3k_main_yingchuan_capital","3k_main_faction_cao_cao")
            xyy_set_region_manager_random("3k_main_yingchuan_resource_1","3k_main_faction_cao_cao")
            
            --徐州
            --彭城
            xyy_set_region_manager_random("3k_main_penchang_capital","3k_main_faction_cao_cao")
            xyy_set_region_manager_random("3k_main_penchang_resource_1","3k_main_faction_cao_cao")
            xyy_set_region_manager_random("3k_main_penchang_resource_2","3k_main_faction_cao_cao")
            
            --下邳
            xyy_set_region_manager_random("3k_dlc06_xiapi_capital","3k_main_faction_cao_cao")
            xyy_set_region_manager_random("3k_dlc06_xiapi_resource_1","3k_main_faction_cao_cao")
            
            --琅琊
            xyy_set_region_manager_random("3k_main_langye_capital","3k_main_faction_cao_cao")
            xyy_set_region_manager_random("3k_main_langye_resource_1","3k_main_faction_cao_cao")
            xyy_set_region_manager_random("3k_main_langye_resource_2","3k_main_faction_cao_cao")
            
            --东海
            xyy_set_region_manager_random("3k_main_donghai_capital","3k_main_faction_cao_cao")
            xyy_set_region_manager_random("3k_main_donghai_resource_1","3k_main_faction_cao_cao")
            
            --广陵
            xyy_set_region_manager_random("3k_main_guangling_capital","3k_main_faction_cao_cao")
            
            --豫州
            --陈郡
            xyy_set_region_manager_random("3k_main_chenjun_capital","3k_main_faction_cao_cao")
            xyy_set_region_manager_random("3k_main_chenjun_resource_1","3k_main_faction_cao_cao")
            xyy_set_region_manager_random("3k_main_chenjun_resource_2","3k_main_faction_cao_cao")
            
            --汝南
            xyy_set_region_manager_random("3k_main_runan_capital","3k_main_faction_cao_cao")
            xyy_set_region_manager_random("3k_main_runan_resource_1","3k_main_faction_cao_cao")
            
            --荆州
            --南阳
            xyy_set_region_manager_random("3k_main_nanyang_capital","3k_main_faction_cao_cao")
            xyy_set_region_manager_random("3k_main_nanyang_resource_1","3k_main_faction_cao_cao")
            
            --襄阳
            xyy_set_region_manager_random("3k_main_xiangyang_capital","3k_main_faction_cao_cao")
            
            --江夏
            xyy_set_region_manager_random("3k_main_jiangxia_resource_1","3k_main_faction_cao_cao")
            
            --扬州
            --庐江
            xyy_set_region_manager_random("3k_main_lujiang_capital","3k_main_faction_cao_cao")
            
            --淮南
            xyy_set_region_manager_random("3k_main_yangzhou_capital","3k_main_faction_cao_cao")
            xyy_set_region_manager_random("3k_main_yangzhou_resource_1","3k_main_faction_cao_cao")
            xyy_set_region_manager_random("3k_main_yangzhou_resource_2","3k_main_faction_cao_cao")
            
        end
        if context:faction():name() == "3k_main_faction_liu_bei"
        and not cm:query_faction("3k_main_faction_liu_bei"):is_human()then
            --汉中
            xyy_set_region_manager_random("3k_main_hanzhong_capital","3k_main_faction_liu_bei")
            
            --荆州
            --襄阳
            xyy_set_region_manager_random("3k_main_xiangyang_resource_1","3k_main_faction_liu_bei")
            
            --南郡
            xyy_set_region_manager_random("3k_main_jingzhou_capital","3k_main_faction_liu_bei")
            xyy_set_region_manager_random("3k_main_jingzhou_resource_1","3k_main_faction_liu_bei")
            
            --武陵
            xyy_set_region_manager_random("3k_main_wuling_capital","3k_main_faction_liu_bei")
            xyy_set_region_manager_random("3k_main_wuling_resource_1","3k_main_faction_liu_bei")
            xyy_set_region_manager_random("3k_main_wuling_resource_2","3k_main_faction_liu_bei")
            xyy_set_region_manager_random("3k_main_wuling_resource_3","3k_main_faction_liu_bei")
            
            --交州
            --交趾
            xyy_set_region_manager_random("3k_dlc06_jiaozhi_resource_3","3k_main_faction_liu_bei")
            
            --益州
            --巴东
            xyy_set_region_manager_random("3k_main_badong_capital","3k_main_faction_liu_bei")
            xyy_set_region_manager_random("3k_main_badong_resource_1","3k_main_faction_liu_bei")
            xyy_set_region_manager_random("3k_main_badong_resource_2","3k_main_faction_liu_bei")
            
            --上庸
            xyy_set_region_manager_random("3k_main_shangyong_capital","3k_main_faction_liu_bei")
            xyy_set_region_manager_random("3k_main_shangyong_resource_1","3k_main_faction_liu_bei")
            xyy_set_region_manager_random("3k_main_shangyong_resource_2","3k_main_faction_liu_bei")
            
            --涪陵
            xyy_set_region_manager_random("3k_main_fuling_capital","3k_main_faction_liu_bei")
            xyy_set_region_manager_random("3k_main_fuling_resource_1","3k_main_faction_liu_bei")
            
            --巴郡
            xyy_set_region_manager_random("3k_main_bajun_capital","3k_main_faction_liu_bei")
            xyy_set_region_manager_random("3k_main_bajun_resource_1","3k_main_faction_liu_bei")
            
            --蜀郡
            xyy_set_region_manager_random("3k_main_chengdu_capital","3k_main_faction_liu_bei")
            xyy_set_region_manager_random("3k_main_chengdu_resource_1","3k_main_faction_liu_bei")
            xyy_set_region_manager_random("3k_main_chengdu_resource_2","3k_main_faction_liu_bei")
            xyy_set_region_manager_random("3k_main_chengdu_resource_3","3k_main_faction_liu_bei")
            
            --江阳
            xyy_set_region_manager_random("3k_main_jiangyang_capital","3k_main_faction_liu_bei")
            xyy_set_region_manager_random("3k_main_jiangyang_resource_1","3k_main_faction_liu_bei")
            xyy_set_region_manager_random("3k_main_jiangyang_resource_2","3k_main_faction_liu_bei")
            xyy_set_region_manager_random("3k_main_jiangyang_resource_3","3k_main_faction_liu_bei")
            
            --永昌
            xyy_set_region_manager_random("3k_dlc06_yongchang_capital","3k_main_faction_liu_bei")
            xyy_set_region_manager_random("3k_dlc06_yongchang_resource_1","3k_main_faction_liu_bei")
            
            --牂牁
            xyy_set_region_manager_random("3k_main_zangke_capital","3k_main_faction_liu_bei")
            xyy_set_region_manager_random("3k_main_zangke_resource_1","3k_main_faction_liu_bei")
            xyy_set_region_manager_random("3k_main_zangke_resource_2","3k_main_faction_liu_bei")
            
            --云南
            xyy_set_region_manager_random("3k_dlc06_yunnan_capital","3k_main_faction_liu_bei")
            xyy_set_region_manager_random("3k_dlc06_yunnan_resource_1","3k_main_faction_liu_bei")
            xyy_set_region_manager_random("3k_dlc06_yunnan_resource_2","3k_main_faction_liu_bei")
            
            --建宁
            xyy_set_region_manager_random("3k_main_jianning_capital","3k_main_faction_liu_bei")
            xyy_set_region_manager_random("3k_main_jianning_resource_1","3k_main_faction_liu_bei")
            xyy_set_region_manager_random("3k_main_jianning_resource_2","3k_main_faction_liu_bei")
            xyy_set_region_manager_random("3k_dlc06_jianning_resource_3","3k_main_faction_liu_bei")
            
            --巴西
            xyy_set_region_manager_random("3k_main_baxi_capital","3k_main_faction_liu_bei")
            xyy_set_region_manager_random("3k_main_baxi_resource_1","3k_main_faction_liu_bei")
            xyy_set_region_manager_random("3k_main_baxi_resource_2","3k_main_faction_liu_bei")
            
            --夔关
            xyy_set_region_manager_random("3k_dlc06_kui_pass","3k_main_faction_liu_bei")
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
            xyy_set_region_manager_random(region:name(),"3k_main_faction_liu_bei")
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


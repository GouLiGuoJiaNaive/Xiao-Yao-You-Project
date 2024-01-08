cm:add_first_tick_callback_new(function() zph_startpos_edited(); end);

function zph_startpos_edited()

    -- NOTE General global setting

    --[[
    local human_faction = cm:query_faction(cm:get_human_factions()[1]);
    for i = 0, human_faction:military_force_list():num_items() - 1 do
        local query_force = human_faction:military_force_list():num_items(i)
            cm:modify_faction("3k_main_faction_tao_qian"):ceo_management():add_ceo("3k_main_ancillary_follower_military_expert")
            cm:modify_faction("3k_main_faction_tao_qian"):ceo_management():add_ceo("3k_main_ancillary_accessory_wei_liaozi")
            -- cm:modify_military_force(query_force):apply_effect_bundle("zph_new_effect_bundle_ytr_debuff_tian", 5);
            -- cm:modify_military_force(query_force):apply_effect_bundle("zph_new_effect_bundle_ytr_debuff_di", 5);
            -- cm:modify_military_force(query_force):apply_effect_bundle("zph_new_effect_bundle_ytr_debuff_ren", 5);
    end;
    ]]--
    

    
    local world_faction_list = cm:query_model():world():faction_list()
    
    -- 是否使用part2
    local is_mod_start_pos = 0

    
    -- 南蛮/匪盗的天道主力设置
    -- 紫虚幻境禁用单位
    for i = 0, world_faction_list:num_items() - 1 do
        local world_faction = world_faction_list:item_at(i)
        
        -- 南蛮派系设置
        if world_faction:subculture() == "3k_dlc06_subculture_nanman" then
            
            -- 禁用紫虚幻境南蛮单位
            cm:modify_faction(world_faction):add_event_restricted_unit_record("zph_zixu_nanman_unit_fire_southern_elephants");
            cm:modify_faction(world_faction):add_event_restricted_unit_record("zph_zixu_nanman_unit_fire_war_elephants");
            cm:modify_faction(world_faction):add_event_restricted_unit_record("zph_zixu_nanman_unit_metal_axe_throwers");
            cm:modify_faction(world_faction):add_event_restricted_unit_record("zph_zixu_nanman_unit_metal_followers_of_the_flame");
            cm:modify_faction(world_faction):add_event_restricted_unit_record("zph_zixu_nanman_unit_metal_might_of_the_valley");
            cm:modify_faction(world_faction):add_event_restricted_unit_record("zph_zixu_nanman_unit_metal_nanzhong_champions");
            cm:modify_faction(world_faction):add_event_restricted_unit_record("zph_zixu_nanman_unit_metal_ravine_warriors");
            cm:modify_faction(world_faction):add_event_restricted_unit_record("zph_zixu_nanman_unit_metal_tiger_warriors");
            cm:modify_faction(world_faction):add_event_restricted_unit_record("zph_zixu_nanman_unit_metal_valley_tribesmen");
            cm:modify_faction(world_faction):add_event_restricted_unit_record("zph_zixu_nanman_unit_metal_wugou_axe_throwers");
            cm:modify_faction(world_faction):add_event_restricted_unit_record("zph_zixu_nanman_unit_metal_wuling_fighters");
            cm:modify_faction(world_faction):add_event_restricted_unit_record("zph_zixu_nanman_unit_water_fire_archers");
            cm:modify_faction(world_faction):add_event_restricted_unit_record("zph_zixu_nanman_unit_water_hidden_vipers");
            cm:modify_faction(world_faction):add_event_restricted_unit_record("zph_zixu_nanman_unit_water_javelin_throwers");
            cm:modify_faction(world_faction):add_event_restricted_unit_record("zph_zixu_nanman_unit_water_nanzhong_elephants");
            cm:modify_faction(world_faction):add_event_restricted_unit_record("zph_zixu_nanman_unit_water_sanjiang_poison_darts");
            cm:modify_faction(world_faction):add_event_restricted_unit_record("zph_zixu_nanman_unit_water_tiger_slingers");
            cm:modify_faction(world_faction):add_event_restricted_unit_record("zph_zixu_nanman_unit_water_wuling_slingers");
            cm:modify_faction(world_faction):add_event_restricted_unit_record("zph_zixu_nanman_unit_wood_javelin_spear_guards");
            cm:modify_faction(world_faction):add_event_restricted_unit_record("zph_zixu_nanman_unit_wood_javelin_spearmen");
            cm:modify_faction(world_faction):add_event_restricted_unit_record("zph_zixu_nanman_unit_wood_nanzhong_spearmen");
            cm:modify_faction(world_faction):add_event_restricted_unit_record("zph_zixu_nanman_unit_wood_sanjiang_poison_spears");
            cm:modify_faction(world_faction):add_event_restricted_unit_record("zph_zixu_nanman_unit_wood_shields_of_the_south");
            cm:modify_faction(world_faction):add_event_restricted_unit_record("zph_zixu_nanman_unit_wood_wolf_pack");
            
            -- AI南蛮天道效果
            if not world_faction:is_human() then
                cm:modify_faction(world_faction):apply_effect_bundle("3k_main_effect_bundle_zph_tiandao_nanman_ai",-1);
            end;
        end;
        
        -- 匪盗派系设置
        -- AI匪盗天道效果
        if not world_faction:is_human() and world_faction:subculture() == "3k_dlc05_subculture_bandits" then
            cm:modify_faction(world_faction):apply_effect_bundle("3k_main_effect_bundle_zph_tiandao_bandit_ai",-1);
        end;
    end;


    -- 关闭细作许可

----------------------------------------------------------------------------
----------------------------------------------------------------------------





























    -- 190剧本：豪杰蜂起
    if cm:query_model():campaign_name() == "3k_main_campaign_map" then
        
----------------------------------------------------------------------------
-- 刘备 3k_main_template_historical_liu_bei_hero_earth
    
        query_faction_of_liubei = cm:query_faction("3k_main_faction_liu_bei");
        modify_faction_of_liubei = cm:modify_faction(query_faction_of_liubei);
        
        query_liu_bei = cm:query_character("3k_main_template_historical_liu_bei_hero_earth");
        modify_liu_bei = cm:modify_character(query_liu_bei);
    
        -- AI加成
        if not query_faction_of_liubei:is_human() then
            modify_faction_of_liubei:apply_effect_bundle("3k_main_pooled_resource_liu_bei_unity_ai",-1);
            modify_faction_of_liubei:apply_effect_bundle("zph_liubei_talent_b_ai",-1);
        else
            modify_faction_of_liubei:apply_effect_bundle("zph_liubei_talent_b",-1);
        end;

        -- 角色效果
        modify_liu_bei:apply_effect_bundle("zph_liubei_talent", -1);
        
        -- 田豫 3k_main_template_historical_tian_yu_hero_fire
        modify_tian_yu = cm:modify_faction("3k_main_faction_liu_bei"):create_character_from_template("general", "3k_general_fire", "3k_main_template_historical_tian_yu_hero_fire", false);
        query_tian_yu = modify_tian_yu:query_character();

        -- 编辑特性
        mod_remove_all_trait(query_tian_yu);
        modify_tian_yu:ceo_management():add_ceo("3k_main_ceo_trait_personality_aescetic"); -- 清心寡欲
        modify_tian_yu:ceo_management():add_ceo("3k_main_ceo_trait_personality_dutiful"); -- 尽职尽责
        modify_tian_yu:ceo_management():add_ceo("3k_main_ceo_trait_personality_cautious"); -- 谨小慎微
        
        -- 设置与刘备关系
        modify_liu_bei:apply_relationship_trigger_set(query_tian_yu, "3k_main_relationship_trigger_set_event_positive_generic_extreme");

        -- 简雍 3k_main_template_historical_jian_yong_hero_metal
        query_jian_yong = cm:query_character("3k_main_template_historical_jian_yong_hero_metal");
        if query_jian_yong and not query_jian_yong:is_null_interface() then
            modify_jian_yong = cm:modify_character(query_jian_yong);

        
            -- 编辑特性
            mod_remove_all_trait(query_jian_yong);
            modify_jian_yong:ceo_management():add_ceo("3k_ytr_ceo_trait_personality_people_people_pleaser"); -- 深得民心
            modify_jian_yong:ceo_management():add_ceo("3k_main_ceo_trait_personality_trusting"); -- 言听计从
            modify_jian_yong:ceo_management():add_ceo("3k_ytr_ceo_trait_personality_people_cheerful"); -- 爽朗活泼
        end;        
        
--------------------------190 Limited -----------------------------------------
    if cm:query_model():calendar_year() <= 192 then

        -- test moh ally
        -- diplomacy_manager:apply_automatic_deal_between_factions("3k_main_faction_dong_zhuo", "3k_main_faction_shi_xie", "data_defined_situation_create_coalition_no_conditions",true);
        -- cm:modify_faction("3k_main_faction_shi_xie"):apply_effect_bundle("3k_main_effect_bundle_zph_tiandao_moh_sign",-1)
    
        -- test spawn generals
        
        -- test nanman invasion
        --[[
        local region_key = cm:query_faction("3k_dlc06_faction_nanman_king_meng_huo"):capital_region():name()
        campaign_invasions:create_invasion("3k_dlc06_faction_nanman_king_meng_huo", region_key, 2, false)
        ]]--
        
        -- test han empire
        --[[
        local guandong_alliance = diplomacy_manager:factions_at_war_with("3k_main_faction_dong_zhuo");
        for i = 0, guandong_alliance:num_items() - 1 do
            local query_faction_key = guandong_alliance:item_at(i):name();
            diplomacy_manager:apply_automatic_deal_between_factions(query_faction_key, "3k_main_faction_han_empire", "data_defined_situation_war_proposer_to_recipient",false);
        end;
        ]]--
----------------------------------------------------------------------------        
--朝廷辖地
   
        if cm:query_faction("3k_main_faction_han_empire"):is_human() == false then
            
    -- 葛阳，豫章畜牧场
    -- 离石，西河首府
    -- 大城，朔方驯兽场   
            mod_set_region_manager("3k_main_yuzhang_resource_2","3k_main_faction_han_empire")
            mod_set_region_manager("3k_main_xihe_capital","xyyhlyja")
            mod_set_region_manager("3k_main_shoufang_resource_2","3k_main_faction_han_empire")         

    -- 王允
            mod_character_add("3k_main_template_historical_wang_yun_hero_earth", "3k_main_faction_dong_zhuo", "3k_general_earth")
            mod_character_add("3k_main_template_historical_wang_yun_hero_earth", "3k_main_faction_han_empire", "3k_general_earth")            
            mod_set_minister_position("3k_main_template_historical_wang_yun_hero_earth","faction_leader")
            mod_CEO_equip("3k_main_template_historical_wang_yun_hero_earth", "3k_main_ancillary_armour_medium_armour_earth_unique", "3k_main_ceo_category_ancillary_armour")
            
        end

    -- 刘洪 3k_dlc04_template_historical_liu_hong_water
        mod_character_add("3k_dlc04_template_historical_liu_hong_water", "3k_main_faction_han_empire", "3k_general_water")

    -- 卢植 3k_dlc04_template_historical_lu_zhi_hero_water
        modify_lu_zhi_190 = cm:modify_character("3k_dlc04_template_historical_lu_zhi_hero_water");

    -- 卢毓 3k_main_template_historical_lu_yu_hero_water
        modify_lu_yu = cm:modify_faction("3k_main_faction_han_empire"):create_character_from_template("general", "3k_general_water", "3k_main_template_historical_lu_yu_hero_water", false);
        modify_lu_yu:make_child_of(modify_lu_zhi_190);


        
----------------------------------------------------------------------------              
-- 黄巾乱军
        
    -- 宕渠，巴郡农田
    -- 上廉，上庸铸兵坊
    -- 新野，南阳玉矿
    -- 梁县，洛阳储木场
    -- 朐忍，巴东铁矿
    -- 充县，武陵稻田
        if cm:query_faction("3k_main_faction_yellow_turban_generic"):is_human() == false then            
            mod_set_region_manager("3k_main_bajun_resource_1","3k_main_faction_yellow_turban_generic")
            mod_set_region_manager("3k_main_shangyong_resource_2","3k_main_faction_yellow_turban_generic")
            mod_set_region_manager("3k_main_chenjun_resource_3","3k_main_faction_yellow_turban_generic")
            mod_set_region_manager("3k_main_chenjun_resource_3","3k_main_faction_yellow_turban_generic")
            mod_set_region_manager("3k_main_badong_resource_1","3k_main_faction_yellow_turban_generic")
            mod_set_region_manager("3k_main_wuling_resource_1","3k_main_faction_yellow_turban_generic")            
        end
        
        
----------------------------------------------------------------------------          
-- 二袁的联军

        if not cm:query_faction("3k_main_faction_yuan_shu"):is_human()
            and not cm:query_faction("3k_main_faction_sun_jian"):is_human() then
                diplomacy_manager:apply_automatic_deal_between_factions("3k_main_faction_yuan_shu", "3k_main_faction_sun_jian", "data_defined_situation_create_coalition_no_conditions",true);            
        end;

        if not cm:query_faction("3k_main_faction_yuan_shao"):is_human()
            and not cm:query_faction("3k_main_faction_cao_cao"):is_human() then
                diplomacy_manager:apply_automatic_deal_between_factions("3k_main_faction_yuan_shao", "3k_main_faction_cao_cao", "data_defined_situation_create_coalition_no_conditions",true);
        end;



----------------------------------------------------------------------------  
-- 袁绍

        diplomacy_manager:apply_automatic_deal_between_factions("3k_main_faction_yuan_shao", "3k_main_faction_gao_gan", "data_defined_situation_vassalise_recipient_no_requirements",true)
        
        if not cm:query_faction("3k_main_faction_yuan_shao"):is_human() then
            
    -- Lineage AI Bonus
            
            cm:modify_faction("3k_main_faction_yuan_shao"):apply_effect_bundle("3k_main_pooled_resource_yuan_shao_lineage_ai",-1)
            
    -- Guo Jia
            local q_char_guojia_190 = cm:query_model():character_for_template("3k_main_template_historical_guo_jia_hero_water")
            if q_char_guojia_190 and not q_char_guojia_190:is_null_interface() and not q_char_guojia_190:is_dead() then
                local modify_character = cm:modify_character(q_char_guojia_190)
                modify_character:set_is_deployable(true)
                modify_character:move_to_faction_and_make_recruited("3k_main_faction_yuan_shao")
            end
            
    -- Cui Jun            
            mod_character_add("3k_main_template_historical_cui_jun_hero_metal", "3k_main_faction_yuan_shao", "3k_general_metal")
            
    -- Items
            --cm:modify_faction("3k_main_faction_yuan_shao"):ceo_management():add_ceo("ep_ancillary_armour_heavy_armour_fire_unique")
            --cm:modify_faction("3k_main_faction_yuan_shao"):ceo_management():add_ceo("ep_ancillary_armour_heavy_armour_wood_unique")
            --cm:modify_faction("3k_main_faction_yuan_shao"):ceo_management():add_ceo("3k_main_ancillary_weapon_two_handed_spear_exceptional")
            --cm:modify_faction("3k_main_faction_yuan_shao"):ceo_management():add_ceo("3k_main_ancillary_weapon_two_handed_axe_exceptional")
        
        end;

    -- 袁方
       
        mod_character_add("mod_main_template_historical_yuan_fang_earth", "3k_main_faction_yuan_shao", "3k_general_earth")
        mod_make_child("3k_main_template_historical_yuan_shao_hero_earth", "mod_main_template_historical_yuan_fang_earth")
        mod_set_minister_position("mod_main_template_historical_yuan_fang_earth", "3k_main_court_offices_prime_minister")
        mod_CEO_equip("mod_main_template_historical_yuan_fang_earth", "ep_ancillary_armour_medium_armour_earth_extraordinary", "3k_main_ceo_category_ancillary_armour")
        
        local q_char_yuanfang = cm:query_model():character_for_template("mod_main_template_historical_yuan_fang_earth")
        if q_char_yuanfang and not q_char_yuanfang:is_null_interface() and not q_char_yuanfang:is_dead() then

            mod_remove_all_trait(q_char_yuanfang);

            local modify_character = cm:modify_character(q_char_yuanfang);

            modify_character:ceo_management():add_ceo("3k_main_ceo_trait_personality_brilliant")
            modify_character:ceo_management():add_ceo("3k_main_ceo_trait_personality_distinguished")
            modify_character:ceo_management():add_ceo("3k_ytr_ceo_trait_personality_land_powerful")
            modify_character:ceo_management():add_ceo("3k_main_ceo_trait_personality_cunning")

            modify_character:ceo_management():remove_ceos("3k_main_ceo_career_generated_minister_earth")
            modify_character:ceo_management():add_ceo("3k_dlc04_ceo_career_historical_chen_su")
        end

        
    -- Yuan Family's genealogy
        
        mod_character_add("mod_main_template_historical_yuan_ji_earth", "3k_main_faction_yuan_shao", "3k_general_earth")
        mod_character_add("3k_main_template_historical_yuan_yi_hero_water", "3k_main_faction_yuan_shao", "3k_general_water")
        mod_character_add("mod_main_template_historical_yuan_tang_fire", "3k_main_faction_yuan_shao", "3k_general_fire")
        mod_character_add("mod_main_template_historical_yuan_ping_wood", "3k_main_faction_yuan_shao", "3k_general_wood")
        
        mod_make_child("mod_main_template_historical_yuan_tang_fire", "mod_main_template_historical_yuan_ping_wood")
        mod_make_child("mod_main_template_historical_yuan_tang_fire", "3k_main_template_ancestral_yuan_feng")
        mod_make_child("mod_main_template_historical_yuan_ping_wood", "3k_main_template_historical_yuan_yi_hero_water")
        mod_make_child("3k_main_template_ancestral_yuan_feng", "mod_main_template_historical_yuan_ji_earth")

        mod_kill_character("mod_main_template_historical_yuan_tang_fire")
        mod_kill_character("mod_main_template_historical_yuan_ping_wood")
        mod_kill_character("mod_main_template_historical_yuan_ji_earth")
        
        
----------------------------------------------------------------------------  
-- 刘表
        
    -- Xun You        
        mod_character_add("3k_main_template_historical_xun_you_hero_water", "3k_main_faction_liu_biao", "3k_general_water")
        
    -- Liu Xiu
        mod_character_add("mod_main_template_historical_liu_xiu_water", "3k_main_faction_liu_biao", "3k_general_water")
        mod_make_child("3k_main_template_historical_liu_biao_hero_earth", "mod_main_template_historical_liu_xiu_water") 
    
----------------------------------------------------------------------------  
-- 曹操

        -- cm:modify_faction("3k_main_faction_cao_cao"):increase_treasury(999999);

        if cm:query_faction("3k_main_faction_cao_cao"):is_human() == false then
            
            --沛县，陈郡畜牧场
            mod_set_region_manager("3k_main_chenjun_resource_1","3k_main_faction_cao_cao")
        end;
            
    -- Zao Zhi
        if cm:query_faction("3k_main_faction_yellow_turban_rebels"):is_human() == false then            
            mod_character_add("3k_main_template_historical_zao_zhi_hero_wood", "3k_main_faction_cao_cao", "3k_general_wood")            
        end;       
        
        
        
----------------------------------------------------------------------------  
-- 袁术
        
    -- 纪灵      
        local query_ji_ling = cm:query_model():character_for_template("3k_main_template_historical_ji_ling_hero_fire")
        if query_ji_ling and not query_ji_ling:is_null_interface() and not query_ji_ling:is_dead() then
            local modify_ji_ling = cm:modify_character(query_ji_ling);
            modify_ji_ling:move_to_faction_and_make_recruited("3k_main_faction_yuan_shu");
        end

    -- 郑泰
        if cm:query_faction("3k_main_faction_sun_jian"):is_human() == false then
            mod_character_add("3k_main_template_historical_zheng_tai_hero_water", "3k_main_faction_yuan_shu", "3k_general_water")            
        end

    -- 刘勋 3k_dlc04_template_historical_liu_xun_fire
        modify_liu_xun = cm:modify_faction("3k_main_faction_yuan_shu"):create_character_from_template("general", "3k_general_fire", "3k_dlc04_template_historical_liu_xun_fire", false);
        query_liu_xun = modify_liu_xun:query_character();

    -- 王宋 3k_dlc04_template_historical_lady_wang_song_water
        modify_wang_song = cm:modify_faction("3k_main_faction_yuan_shu"):create_character_from_template("general", "3k_general_water", "3k_dlc04_template_historical_lady_wang_song_water", false);
        query_wang_song = modify_wang_song:query_character();        

        local modify_liu_xun_family_member = cm:modify_model():get_modify_family_member(query_liu_xun:family_member());
        local modify_wang_song_family_member = cm:modify_model():get_modify_family_member(query_wang_song:family_member());    
        modify_wang_song_family_member:marry_character(modify_liu_xun_family_member);


----------------------------------------------------------------------------  
-- 孙坚

        if cm:query_faction("3k_main_faction_sun_jian"):is_human() == false then
            
    -- 江陵，南郡首府            
            mod_set_region_manager("3k_main_jingzhou_capital","3k_main_faction_sun_jian")
            
    -- Quan Rou
            mod_character_add("3k_main_template_historical_quan_rou_hero_wood", "3k_main_faction_sun_jian", "3k_general_wood")

    -- Items
            cm:modify_faction("3k_main_faction_sun_jian"):ceo_management():add_ceo("ep_ancillary_armour_medium_armour_earth_unique")            
        end;
            

    -- Sun Family's genealogy
        
        --("3k_main_template_historical_sun_yi_hero_fire", "3k_main_faction_sun_jian", "3k_general_fire")
        --mod_make_child("3k_main_template_historical_sun_jian_hero_metal", "3k_main_template_historical_sun_yi_hero_fire")

        --mod_character_add("mod_main_template_historical_sun_kuang_water", "3k_main_faction_sun_jian", "3k_general_water")
        --mod_make_child("3k_main_template_historical_sun_jian_hero_metal", "mod_main_template_historical_sun_kuang_water")

        mod_character_add("mod_main_template_historical_sun_lang_metal", "3k_main_faction_sun_jian", "3k_general_metal")
        mod_make_child("3k_main_template_historical_sun_jian_hero_metal", "mod_main_template_historical_sun_lang_metal")

        mod_character_add("mod_main_template_historical_wu_shixiong_earth", "3k_main_faction_sun_jian", "3k_general_metal")

        mod_character_add("3k_main_template_historical_wu_jing_hero_fire", "3k_main_faction_sun_jian", "3k_general_fire")
        mod_make_child("mod_main_template_historical_wu_shixiong_earth", "3k_main_template_historical_wu_jing_hero_fire")

        mod_make_child("mod_main_template_historical_wu_shixiong_earth", "3k_main_template_historical_lady_wu_minyu_hero_earth")

        mod_kill_character("mod_main_template_historical_wu_shixiong_earth")

        mod_character_add("mod_main_template_historical_wu_fen_wood", "3k_main_faction_sun_jian", "3k_general_wood")
        mod_make_child("3k_main_template_historical_wu_jing_hero_fire", "mod_main_template_historical_wu_fen_wood")

        mod_character_add("mod_main_template_historical_wu_qi_metal", "3k_main_faction_sun_jian", "3k_general_metal")
        mod_make_child("3k_main_template_historical_wu_jing_hero_fire", "mod_main_template_historical_wu_qi_metal")   
        
----------------------------------------------------------------------------  
-- 刘虞



----------------------------------------------------------------------------  
-- GONGSUN ZAN

    --Set as Liu Yu's vassal        
        if cm:query_faction("3k_main_faction_gongsun_zan"):is_human() == false then
             diplomacy_manager:apply_automatic_deal_between_factions("3k_main_faction_liu_yu", "3k_main_faction_gongsun_zan", "data_defined_situation_vassalise_recipient_no_requirements",true)
        end

    -- Yang Fan
       
        mod_character_add("mod_main_template_historical_yang_fan_wood", "3k_main_faction_gongsun_zan", "3k_general_wood")
        
        local q_char_yangfan = cm:query_model():character_for_template("mod_main_template_historical_yang_fan_wood")
        if q_char_yangfan and not q_char_yangfan:is_null_interface() and not q_char_yangfan:is_dead() then

            mod_remove_all_trait(q_char_yangfan);

            local modify_character = cm:modify_character(q_char_yangfan);

            modify_character:ceo_management():add_ceo("3k_main_ceo_trait_personality_stubborn")
            modify_character:ceo_management():add_ceo("3k_main_ceo_trait_personality_humble")
            modify_character:ceo_management():add_ceo("3k_main_ceo_trait_personality_brave")
        end
        
----------------------------------------------------------------------------  
-- 高干

    -- Items
        if cm:query_faction("3k_main_faction_gao_gan"):is_human() == false then
            cm:modify_faction("3k_main_faction_gao_gan"):ceo_management():add_ceo("ep_ancillary_armour_medium_armour_metal_extraordinary")
        end        

    -- Gao Family's genealogy
        mod_character_add("mod_main_template_historical_yuan_shuting_water", "3k_main_faction_gao_gan", "3k_general_water")
        mod_character_add("mod_main_template_historical_gao_ci_earth", "3k_main_faction_gao_gan", "3k_general_earth")
        mod_character_add("mod_main_template_historical_gao_gong_earth", "3k_main_faction_gao_gan", "3k_general_earth")
        mod_character_add("mod_main_template_historical_gao_jing_fire", "3k_main_faction_gao_gan", "3k_general_fire")
        mod_character_add("mod_main_age_fixed_historical_gao_dan_water", "3k_main_faction_gao_gan", "3k_general_water")
        mod_character_add("mod_main_age_fixed_historical_gao_jun_wood", "3k_main_faction_gao_gan", "3k_general_wood")
        mod_character_add("mod_main_template_historical_gao_zhun_hero_fire", "3k_main_faction_gao_gan", "3k_general_fire")
        
        mod_make_spouse("mod_main_template_historical_gao_gong_earth", "mod_main_template_historical_yuan_shuting_water")
        
        mod_make_child("mod_main_template_historical_gao_ci_earth", "mod_main_template_historical_gao_gong_earth")
        mod_make_child("mod_main_template_historical_gao_ci_earth", "mod_main_template_historical_gao_jing_fire")
        mod_make_child("mod_main_template_historical_gao_gong_earth", "3k_main_template_historical_gao_gan_hero_metal")
        mod_make_child("mod_main_template_historical_gao_gong_earth", "mod_main_template_historical_gao_zhun_hero_fire")
        mod_make_child("mod_main_template_historical_gao_jing_fire", "3k_main_template_historical_gao_rou_hero_water")
        mod_make_child("3k_main_template_historical_gao_rou_hero_water", "mod_main_age_fixed_historical_gao_dan_water")
        mod_make_child("3k_main_template_historical_gao_rou_hero_water", "mod_main_age_fixed_historical_gao_jun_wood")
        
        mod_make_child("3k_main_template_ancestral_yuan_feng", "mod_main_template_historical_yuan_shuting_water")
        mod_make_child("mod_main_template_historical_yuan_shuting_water", "3k_main_template_historical_gao_gan_hero_metal")
        mod_make_child("mod_main_template_historical_yuan_shuting_water", "mod_main_template_historical_gao_zhun_hero_fire")

        mod_kill_character("mod_main_template_historical_gao_ci_earth")
        -- mod_kill_character("mod_main_template_historical_gao_gong_earth")
        
        local q_char_gaozhun = cm:query_model():character_for_template("mod_main_template_historical_gao_zhun_hero_fire")
        if q_char_gaozhun and not q_char_gaozhun:is_null_interface() and not q_char_gaozhun:is_dead() then

            mod_remove_all_trait(q_char_gaozhun);

            local modify_character = cm:modify_character(q_char_gaozhun);
            
            modify_character:ceo_management():add_ceo("3k_main_ceo_trait_personality_artful")
            modify_character:ceo_management():add_ceo("3k_main_ceo_trait_personality_energetic")
            modify_character:ceo_management():add_ceo("3k_main_ceo_trait_personality_patient")
        end
        
        
----------------------------------------------------------------------------
-- 马腾
        mod_CEO_equip("3k_main_template_historical_ma_teng_hero_fire", "3k_main_ancillary_accessory_book_of_rites", "3k_main_ceo_category_ancillary_accessory")
        

----------------------------------------------------------------------------  
-- 郑昶/南海

        query_faction_of_nanhai = cm:query_faction("3k_main_faction_nanhai");

    -- 郑昶 mod_main_template_historical_zheng_chang_fire
        modify_zheng_chang = cm:modify_faction("3k_main_faction_nanhai"):create_character_from_template("general", "3k_general_fire", "mod_main_template_historical_zheng_chang_fire", false);
        query_zheng_chang = modify_zheng_chang:query_character();
        modify_zheng_chang:assign_faction_leader();
        mod_CEO_equip("mod_main_template_historical_zheng_chang_fire", "3k_main_ancillary_armour_heavy_armour_fire_unique", "3k_main_ceo_category_ancillary_armour")

    -- 设置派系成员A
        modify_nanhai_char_a = cm:modify_faction("3k_main_faction_nanhai"):create_character_from_template( "general", "3k_general_water", "3k_main_template_generic_water_governor_legendary_f_hero", false);
        query_nanhai_char_a = modify_nanhai_char_a:query_character();

    -- 设置派系成员B
        modify_nanhai_char_b = cm:modify_faction("3k_main_faction_nanhai"):create_character_from_template( "general", "3k_general_metal", "3k_main_template_generic_metal_envoy_normal_m_hero", false);

    -- 设置派系成员C
        modify_nanhai_char_c = cm:modify_faction("3k_main_faction_nanhai"):create_character_from_template( "general", "3k_general_wood", "3k_main_template_generic_wood_minister_normal_m_hero", false);

    -- 廷臣关系
        for i = 0, query_faction_of_nanhai:character_list():num_items() - 1 do
            local query_character = query_faction_of_nanhai:character_list():item_at(i);
            
            if query_character and not query_character:is_null_interface() and not query_character:is_dead()
                and query_character:is_character_in_faction_recruited_characters()
                and query_character:age() > 16 then
                    modify_zheng_chang:apply_relationship_trigger_set(query_character, "3k_main_relationship_trigger_set_event_positive_generic_extreme");
            end;
        end;

    -- 设置军队
        found_pos, x, y = query_faction_of_nanhai:get_valid_spawn_location_in_region("3k_main_nanhai_capital", false);
        if found_pos then
            cm:create_force_with_existing_general(query_nanhai_char_a:command_queue_index(), "3k_main_faction_nanhai", "", "3k_main_nanhai_capital", x, y, "nanhai_force", nil, 100);
            local modify_nanhai_force = cm:modify_model():get_modify_military_force(query_nanhai_char_a:military_force());
            
            -- 添加随机将领B和C
            modify_nanhai_force:add_existing_character_as_retinue(modify_nanhai_char_b, true);
            modify_nanhai_force:add_existing_character_as_retinue(modify_nanhai_char_c, true);
        end;

    -- 设置婚姻
        local modify_zheng_chang_family_member = cm:modify_model():get_modify_family_member(query_zheng_chang:family_member());
        local modify_zheng_chang_wife_family_member = cm:modify_model():get_modify_family_member(query_nanhai_char_a:family_member());
        modify_zheng_chang_family_member:marry_character(modify_zheng_chang_wife_family_member);


----------------------------------------------------------------------------
--刘繇 3k_main_template_historical_liu_yao_hero_earth
        
        query_liu_yao = cm:query_character("3k_main_template_historical_liu_yao_hero_earth");
        modify_liu_yao = cm:modify_character(query_liu_yao);

        -- 编辑特性
        mod_remove_all_trait(query_liu_yao);
        modify_liu_yao:ceo_management():add_ceo("3k_main_ceo_trait_personality_energetic"); -- 斗志昂扬
        modify_liu_yao:ceo_management():add_ceo("3k_ytr_ceo_trait_personality_relentless"); -- 不屈不挠
        modify_liu_yao:ceo_management():add_ceo("3k_ytr_ceo_trait_personality_land_alert"); -- 抱持戒心
        
----------------------------------------------------------------------------  
-- 刘宠

    -- Liu Rui
        mod_character_add("mod_main_template_historical_liu_rui_hero_water", "3k_dlc04_faction_prince_liu_chong", "3k_general_water")
        mod_make_child("3k_main_template_historical_liu_chong_hero_earth", "mod_main_template_historical_liu_rui_hero_water")
        mod_set_minister_position("mod_main_template_historical_liu_rui_hero_water","faction_heir")
        

----------------------------------------------------------------------------  
-- 张超

        if cm:query_faction("3k_main_faction_zhang_chao"):is_human() == false then

    -- 江都，广陵商港
    -- 居巢，淮南工具铺
            mod_set_region_manager("3k_main_guangling_resource_2","3k_main_faction_zhang_chao")
            mod_set_region_manager("3k_main_yangzhou_resource_3","3k_main_faction_zhang_chao")
            
    -- Items
            cm:modify_faction("3k_main_faction_zhang_chao"):ceo_management():add_ceo("ep_ancillary_armour_light_armour_metal_extraordinary")            
        end

    -- Zhang Family's genealogy
        mod_character_add("mod_main_template_historical_zhang_yue_earth", "3k_main_faction_zhang_chao", "3k_general_earth")
        mod_make_child("mod_main_template_historical_zhang_yue_earth", "3k_main_template_historical_zhang_chao_hero_water")
        mod_make_child("mod_main_template_historical_zhang_yue_earth", "3k_main_template_historical_zhang_miao_hero_water")
        mod_kill_character("mod_main_template_historical_zhang_yue_earth")
        
    -- Zhang Pian
        mod_character_add("mod_main_template_historical_zhang_pian_wood", "3k_main_faction_zhang_chao", "3k_general_wood")
        mod_make_child("3k_main_template_historical_zhang_chao_hero_water", "mod_main_template_historical_zhang_pian_wood")
        mod_set_minister_position("mod_main_template_historical_zhang_pian_wood","faction_heir") 
    
    -- Zhang Shan
        mod_character_add("mod_main_template_historical_zhang_shan_fire", "3k_main_faction_zhang_chao", "3k_general_fire")
        mod_make_child("3k_main_template_historical_zhang_chao_hero_water", "mod_main_template_historical_zhang_shan_fire")        

        
----------------------------------------------------------------------------  
-- 张鲁
        
    -- 西城，上庸储木场
    -- 汉昌，巴西工具铺
    -- 巴西首府
            mod_set_region_manager("3k_main_shangyong_resource_1","3k_main_faction_zhang_lu")
            mod_set_region_manager("3k_main_baxi_resource_1","3k_main_faction_zhang_lu")
            mod_set_region_manager("3k_main_baxi_capital","3k_main_faction_zhang_lu")
            
    -- Items
            cm:modify_faction("3k_main_faction_zhang_lu"):ceo_management():add_ceo("ep_ancillary_armour_heavy_armour_wood_extraordinary")


        
----------------------------------------------------------------------------  
-- 朱符
        

    -- 广郁，郁林香药
    -- 临尘，交趾稻田
    -- 龙编，交趾首府
          
        mod_set_region_manager("3k_main_yulin_resource_2","3k_dlc05_faction_zhu_fu")              
        mod_set_region_manager("3k_main_jiaozhi_resource_1","3k_dlc05_faction_zhu_fu") 
        mod_set_region_manager("3k_main_jiaozhi_capital","3k_dlc05_faction_zhu_fu")            

        
    -- Zhu Qian
        mod_character_add("mod_main_template_historical_zhu_qian_metal", "3k_dlc05_faction_zhu_fu", "3k_general_metal")
        mod_make_child("3k_main_template_historical_zhu_fu_hero_water", "mod_main_template_historical_zhu_qian_metal")
        mod_set_minister_position("mod_main_template_historical_zhu_qian_metal","faction_heir")
        
    -- Move Zhu Fu to his territory
        if cm:query_faction("3k_dlc06_faction_nanman_king_shamoke"):is_human() == false then           
            local q_char_zhufu_190 = cm:query_model():character_for_template("3k_main_template_historical_zhu_fu_hero_water")
            if q_char_zhufu_190 and not q_char_zhufu_190:is_null_interface() and not q_char_zhufu_190:is_dead() then
                cm:modify_character(q_char_zhufu_190):teleport_to(320, 200)
            end
        end
            
----------------------------------------------------------------------------  
-- 谷永（郁林太守）
        
    -- 潭中，郁林商港    
        mod_set_region_manager("3k_main_yulin_resource_1","3k_main_faction_yulin")
        
    -- 应劭及其子应玚、应璩
    -- 3k_main_template_historical_ying_shao_hero_fire
    -- 3k_main_template_historical_ying_yang_hero_water
    -- 3k_main_template_historical_ying_qu_hero_water
        
        query_ying_shao = cm:query_character("3k_main_template_historical_ying_shao_hero_fire");
        modify_ying_shao = cm:modify_character(query_ying_shao);
        modify_ying_shao:move_to_faction_and_make_recruited("3k_main_faction_han_empire");

        modify_ying_yang = cm:modify_faction("3k_main_faction_han_empire"):create_character_from_template("general", "3k_general_water", "3k_main_template_historical_ying_yang_hero_water", false);
        modify_ying_qu = cm:modify_faction("3k_main_faction_han_empire"):create_character_from_template("general", "3k_general_water", "3k_main_template_historical_ying_qu_hero_water", false);        
        
        modify_ying_yang:make_child_of(modify_ying_shao);
        modify_ying_qu:make_child_of(modify_ying_shao);

    -- Gu Yong
        mod_character_add("mod_main_template_historical_gu_yong_metal", "3k_main_faction_yulin", "3k_general_metal")
        cm:modify_character("mod_main_template_historical_gu_yong_metal"):assign_faction_leader()
        
    -- Diplomacy genealogy
        diplomacy_manager:apply_automatic_deal_between_factions("3k_main_faction_yulin", "3k_dlc05_faction_zhu_fu", "data_defined_situation_war_proposer_to_recipient",false)

        
----------------------------------------------------------------------------         
-- 杨忠（高粱太守）

        query_faction_of_gaoliang = cm:query_faction("3k_main_faction_gaoliang");

    -- 周奂 3k_main_template_historical_zhou_huan_hero_water
        query_zhou_huan = cm:query_character("3k_main_template_historical_zhou_huan_hero_water");
        query_gaoliang_force = query_zhou_huan:military_force()
        
        cm:modify_character(query_zhou_huan):move_to_faction_and_make_recruited("3k_main_faction_han_empire");

    -- 杨忠 3k_main_template_historical_yang_zhong_hero_metal
        modify_yang_zhong = cm:modify_character("3k_main_template_historical_yang_zhong_hero_metal");
        modify_yang_zhong:move_to_faction_and_make_recruited("3k_main_faction_gaoliang");
        query_yang_zhong = modify_yang_zhong:query_character();
        modify_yang_zhong:assign_faction_leader();

    -- 廷臣列表，设置关系
        female_list = {}
        court_noble_list = {}
        for i = 0, query_faction_of_gaoliang:character_list():num_items() - 1 do
        
            local query_character = query_faction_of_gaoliang:character_list():item_at(i);
            
            if query_character and not query_character:is_null_interface() and not query_character:is_dead()
                and query_character:is_character_in_faction_recruited_characters()
                and query_character:age() > 16 then
                
                    table.insert(court_noble_list, query_character:command_queue_index());
                    modify_yang_zhong:apply_relationship_trigger_set(query_character, "3k_main_relationship_trigger_set_event_positive_generic_extreme");
                    
                    if not query_character:is_male() then
                        table.insert(female_list, query_character:command_queue_index());
                    end;
            end;
        end;

    -- 设置军队
        local modify_gaoliang_force = cm:modify_model():get_modify_military_force(query_gaoliang_force);
        for k, v in ipairs(court_noble_list) do
            if k < 3 then
                modify_gaoliang_force:add_existing_character_as_retinue(cm:modify_character(v), true);
            end;
        end;

    -- 设置婚姻
        local modify_yang_zhong_family_member = cm:modify_model():get_modify_family_member(query_yang_zhong:family_member());
        
        local num = cm:random_int(1, #female_list)
        local modify_yang_zhong_wife_family_member = cm:modify_model():get_modify_family_member(cm:query_character(female_list[num]):family_member());
        
        modify_yang_zhong_family_member:marry_character(modify_yang_zhong_wife_family_member);




----------------------------------------------------------------------------  
-- 黄邵
        
    -- 平原，平原首府
    -- 乐陵，平原盐矿
        if cm:query_faction("3k_main_faction_yellow_turban_taishan"):is_human() == false then            
            mod_set_region_manager("3k_main_pingyuan_capital","3k_main_faction_yellow_turban_taishan")              
            mod_set_region_manager("3k_main_pingyuan_resource_1","3k_main_faction_yellow_turban_taishan")
        end
        
        
----------------------------------------------------------------------------  
-- 何仪
        
    -- 汝阳，陈郡农田
        if cm:query_faction("3k_main_faction_yellow_turban_rebels"):is_human() == false then
            mod_set_region_manager("3k_main_chenjun_resource_2","3k_main_faction_yellow_turban_rebels")            
        end
        

----------------------------------------------------------------------------  
-- 龚都
        
    -- 梓潼，巴西农田
        if cm:query_faction("3k_main_faction_yellow_turban_anding"):is_human() == false then
            mod_set_region_manager("3k_main_baxi_resource_2","3k_main_faction_yellow_turban_anding")
        end


----------------------------------------------------------------------------  
-- 严白虎
        
    -- 新安，新都储木场
    -- 乐安，鄱阳铸兵坊
        if cm:query_faction("3k_dlc05_faction_white_tiger_yan"):is_human() == false then            
            mod_set_region_manager("3k_main_xindu_resource_1","3k_dlc05_faction_white_tiger_yan")
            mod_set_region_manager("3k_main_poyang_resource_3","3k_dlc05_faction_white_tiger_yan")
        end
        

----------------------------------------------------------------------------  
-- 刘繇

        -- 宛陵，丹阳铜矿
        -- 芜湖，新都渔港
        if cm:query_faction("3k_main_faction_liu_yao"):is_human() == false then
            mod_set_region_manager("3k_main_jianye_resource_2","3k_main_faction_liu_yao");
            mod_set_region_manager("3k_main_xindu_resource_2","3k_main_faction_liu_yao");
        end;

----------------------------------------------------------------------------  
-- 王朗
        
    -- 乌伤，会稽畜牧场
    -- 建平，北建安储木场
        if cm:query_faction("3k_main_faction_wang_lang"):is_human() == false then            
            mod_set_region_manager("3k_main_kuaiji_resource_2","3k_main_faction_wang_lang")
            mod_set_region_manager("3k_main_jianan_resource_2","3k_main_faction_wang_lang")
        end
        
    -- 周昕 3k_main_template_historical_zhou_xin_hero_fire
    
        mod_character_add("3k_main_template_historical_zhou_xin_hero_fire", "3k_main_faction_wang_lang", "3k_general_fire")

----------------------------------------------------------------------------  
-- 士燮
        
    -- 朱崖，合浦储木场
        mod_set_region_manager("3k_main_hepu_resource_2","3k_main_faction_shi_xie")

    -- Diplomacy setting        
        diplomacy_manager:apply_automatic_deal_between_factions("3k_main_faction_shi_xie", "3k_main_faction_yulin", "data_defined_situation_peace", true)
        diplomacy_manager:apply_automatic_deal_between_factions("3k_main_faction_shi_xie", "3k_main_faction_gaoliang", "data_defined_situation_peace", true)
        diplomacy_manager:apply_automatic_deal_between_factions("3k_main_faction_shi_xie", "3k_dlc06_faction_jiuzhen", "data_defined_situation_peace", true)
        
    -- Shi Wu
        mod_character_add("3k_main_template_historical_shi_wu_hero_fire", "3k_main_faction_shi_xie", "3k_general_fire")
        mod_make_child("3k_main_template_ancestral_shi_ci", "3k_main_template_historical_shi_wu_hero_fire")


----------------------------------------------------------------------------          
-- 贾龙

        query_faction_of_jialong = cm:query_faction("3k_main_faction_jia_long");
        query_jia_long = cm:query_character("3k_main_template_historical_jia_long_hero_metal");
        modify_jia_long = cm:modify_character(query_jia_long);
        
        -- 设置初始成员A
        modify_jia_long_char_a = cm:modify_faction("3k_main_faction_jia_long"):create_character_from_template( "general", "3k_general_metal", "ep_template_generic_metal_minister_normal_m_hero", false);
        modify_jia_long:apply_relationship_trigger_set(modify_jia_long_char_a:query_character(), "3k_main_relationship_trigger_set_event_positive_generic_extreme");

        -- 设置初始成员B
        modify_jia_long_char_b = cm:modify_faction("3k_main_faction_jia_long"):create_character_from_template( "general", "3k_general_water", "3k_main_template_generic_water_agent_normal_f_hero", false);
        modify_jia_long:apply_relationship_trigger_set(modify_jia_long_char_b:query_character(), "3k_main_relationship_trigger_set_event_positive_generic_extreme");        


        if not query_faction_of_jialong:is_human() then
            
            -- 汉嘉，蜀郡甲匠坊
            -- 江州，巴郡首府
            mod_set_region_manager("3k_main_chengdu_resource_1","3k_main_faction_jia_long")
            mod_set_region_manager("3k_main_bajun_capital","3k_main_faction_jia_long")          
            
        -- 贤圣甲袍
            cm:modify_faction("3k_main_faction_jia_long"):ceo_management():add_ceo("ep_ancillary_armour_medium_armour_metal_extraordinary")
        end
        
        -- 贾虺 mod_main_template_historical_jia_hui_earth
        modify_jia_hui = cm:modify_faction("3k_main_faction_jia_long"):create_character_from_template("general", "3k_general_earth", "mod_main_template_historical_jia_hui_earth", false);
        modify_jia_hui:make_child_of(modify_jia_long);
        modify_jia_hui:assign_to_post("faction_heir");
    
        -- 贾巳 mod_main_template_historical_jia_si_water
        modify_jia_si = cm:modify_faction("3k_main_faction_jia_long"):create_character_from_template("general", "3k_general_water", "mod_main_template_historical_jia_si_water", false);
        modify_jia_si:make_child_of(modify_jia_long);

        -- 设置外交
        diplomacy_manager:apply_automatic_deal_between_factions("3k_main_faction_jia_long", "3k_main_faction_liu_yan", "data_defined_situation_war_proposer_to_recipient",false)
       
        
----------------------------------------------------------------------------  
-- 刘焉/刘璋
        
    --阆中，巴西首府
        if cm:query_faction("3k_main_faction_liu_yan"):is_human() == false then            
            mod_set_region_manager("3k_main_baxi_capital","3k_main_faction_liu_yan")
        end

    -- 杨洪
        mod_character_add("mod_main_template_historical_yang_hong_jixiu_water", "3k_main_faction_liu_yan", "3k_general_water");

    -- 赵韪 3k_main_template_historical_zhao_wei_hero_water
        mod_character_add("3k_main_template_historical_zhao_wei_hero_water", "3k_main_faction_liu_yan", "3k_general_water");
        
    -- 刘瑁 3k_dlc07_template_historical_liu_mao_hero_water
        mod_character_add("3k_dlc07_template_historical_liu_mao_hero_water", "3k_main_faction_liu_yan", "3k_general_water");
        mod_set_minister_position("3k_dlc07_template_historical_liu_mao_hero_water","faction_heir");

    -- 董和 3k_dlc04_template_historical_dong_he_earth
        mod_character_add("3k_dlc04_template_historical_dong_he_earth", "3k_main_faction_liu_yan", "3k_general_earth");

        
    -- 外交设置
        diplomacy_manager:apply_automatic_deal_between_factions("3k_main_faction_liu_yan", "3k_main_faction_zhang_lu", "data_defined_situation_vassalise_recipient_no_requirements",true);
        diplomacy_manager:apply_automatic_deal_between_factions("3k_main_faction_liu_yan", "3k_main_faction_yellow_turban_anding", "data_defined_situation_war_proposer_to_recipient",false);
        

        
--[[
    -- Liu Family's genealogy
        mod_character_add("3k_main_template_historical_liu_fan_hero_fire", "3k_main_faction_han_empire", "3k_general_fire")
        mod_make_child("3k_main_template_historical_liu_yan_hero_water", "3k_main_template_historical_liu_fan_hero_fire")

        mod_character_add("mod_main_template_historical_liu_dan_water", "3k_main_faction_han_empire", "3k_general_water")
        mod_make_child("3k_main_template_historical_liu_yan_hero_water", "mod_main_template_historical_liu_dan_water")

        mod_character_add("mod_main_template_historical_liu_mao_earth", "3k_main_faction_liu_yan", "3k_general_earth")
        mod_make_child("3k_main_template_historical_liu_yan_hero_water", "mod_main_template_historical_liu_mao_earth")
        mod_set_minister_position("mod_main_template_historical_liu_mao_earth","faction_heir")
        
]]--
----------------------------------------------------------------------------  
-- HUANG ZU

        if cm:query_faction("3k_main_faction_huang_zu"):is_human() == false then
        
    -- 寻阳，庐江渔港            
            mod_set_region_manager("3k_main_lujiang_resource_1","3k_main_faction_huang_zu")

    -- Items
            cm:modify_faction("3k_main_faction_huang_zu"):ceo_management():add_ceo("ep_ancillary_armour_heavy_armour_wood_extraordinary")

        end

----------------------------------------------------------------------------  
-- ZE RONG

        if cm:query_faction("3k_main_faction_zhai_rong"):is_human() == false then
        
    -- 海西，东海渔港            
            mod_set_region_manager("3k_main_donghai_resource_1","3k_main_faction_zhai_rong")
            
    -- Items
            cm:modify_faction("3k_main_faction_zhai_rong"):ceo_management():add_ceo("ep_ancillary_armour_medium_armour_fire_extraordinary")
        end


----------------------------------------------------------------------------  
-- HAN SUI
        
    --休屠，武威马场
        if cm:query_faction("3k_main_faction_han_sui"):is_human() == false then            
            mod_set_region_manager("3k_main_wuwei_resource_1","3k_main_faction_han_sui")            
        end

        
----------------------------------------------------------------------------  
-- 张羡（零陵太守）

        query_faction_of_lingling = cm:query_faction("3k_main_faction_lingling");
        
        -- 泉陵，零陵首府
        -- 富川，苍梧稻田
        -- 猛陵，苍梧储木场
        mod_set_region_manager("3k_main_lingling_capital","3k_main_faction_lingling");
        mod_set_region_manager("3k_main_cangwu_resource_1","3k_main_faction_lingling");
        mod_set_region_manager("3k_main_cangwu_resource_2","3k_main_faction_lingling");
            
        -- 张羡 mod_main_template_historical_zhang_xian_wood
        modify_zhang_xian = cm:modify_faction("3k_main_faction_lingling"):create_character_from_template("general", "3k_general_wood", "mod_main_template_historical_zhang_xian_wood", false);
        query_zhang_xian = modify_zhang_xian:query_character();
        modify_zhang_xian:assign_faction_leader();

        -- 编辑特性
        mod_remove_all_trait(query_zhang_xian);
        modify_zhang_xian:ceo_management():add_ceo("3k_ytr_ceo_trait_personality_people_people_pleaser"); -- 深得民心
        modify_zhang_xian:ceo_management():add_ceo("3k_ytr_ceo_trait_personality_land_alert"); -- 抱持戒心
        modify_zhang_xian:ceo_management():add_ceo("3k_ytr_ceo_trait_personality_land_aspiring"); -- 尽心尽力
        -- modify_zhang_xian:ceo_management():add_ceo("3k_main_ceo_trait_personality_disloyal"); -- 不臣之心，194/197
        
        modify_zhang_xian:ceo_management():remove_ceos("3k_main_ceo_career_generated_minister_wood");
        modify_zhang_xian:ceo_management():add_ceo("3k_dlc04_ceo_career_historical_xun_shuang_ciming"); -- 力克贪腐

        -- 张怿 mod_main_template_historical_zhang_yi_metal
        modify_zhang_yi = cm:modify_faction("3k_main_faction_lingling"):create_character_from_template("general", "3k_general_metal", "mod_main_template_historical_zhang_yi_metal", false);
        query_zhang_yi = modify_zhang_xian:query_character();
        modify_zhang_yi:assign_to_post("faction_heir");

        -- 设置亲属关系
        modify_zhang_yi:make_child_of(modify_zhang_xian);

        -- 设置初始成员A
        modify_lingling_char_a = cm:modify_faction("3k_main_faction_lingling"):create_character_from_template( "general", "3k_general_water", "3k_main_template_generic_water_agent_normal_m_hero", false);
        query_lingling_char_a = modify_lingling_char_a:query_character();

        -- 设置人事关系
        -- modify_zhang_xian:apply_relationship_trigger_set(cm:query_character("3k_main_template_historical_liu_biao_hero_earth"), "3k_main_relationship_trigger_set_event_negative_generic_extreme"); -- 194/197
        modify_zhang_xian:apply_relationship_trigger_set(query_zhang_yi, "3k_main_relationship_trigger_set_event_positive_generic_extreme");
        modify_zhang_xian:apply_relationship_trigger_set(query_lingling_char_a, "3k_main_relationship_trigger_set_startpos_family_member");
        modify_zhang_yi:apply_relationship_trigger_set(query_lingling_char_a, "3k_main_relationship_trigger_set_event_positive_generic_extreme");

        -- 设置军队
        found_pos, x, y = query_faction_of_lingling:get_valid_spawn_location_in_region("3k_main_lingling_capital", false);        
        if found_pos then        
            cm:create_force_with_existing_general(query_zhang_xian:command_queue_index(), "3k_main_faction_lingling", "", "3k_main_lingling_capital", x, y, "zhangxian_force", nil, 100);
            local modify_zhang_xian_force = cm:modify_model():get_modify_military_force(query_zhang_xian:military_force());
            
            -- 添加成员
            modify_zhang_xian_force:add_existing_character_as_retinue(modify_zhang_yi, true);
            modify_zhang_xian_force:add_existing_character_as_retinue(modify_lingling_char_a, true);
        end;

----------------------------------------------------------------------------  
-- 赵范（庐陵太守）      

        -- 雩都, 庐陵首府
        -- 南平, 零陵储木场
        -- 郴县, 零陵工具铺            
        mod_set_region_manager("3k_main_luling_capital","3k_main_faction_luling")
        mod_set_region_manager("3k_main_lingling_resource_2","3k_main_faction_luling")
        mod_set_region_manager("3k_main_lingling_resource_1","3k_main_faction_luling")

        -- 赵范
        mod_character_add("mod_main_template_historical_zhao_fan_water", "3k_main_faction_luling", "3k_general_water")
        cm:modify_character("mod_main_template_historical_zhao_fan_water"):assign_faction_leader()

        -- 编辑军队          
        campaign_invasions:create_invasion("3k_main_faction_luling", "3k_main_luling_capital", 2, false)

        -- 编辑装备
        mod_give_equipment("ep_ancillary_armour_strategist_light_armour_water_extraordinary","3k_main_faction_luling")


----------------------------------------------------------------------------  
-- CAO YIN /WU LIN
        
    -- 镡成，武陵工具铺
    -- 定州，苍梧畜牧场
        mod_set_region_manager("3k_main_wuling_resource_2","3k_main_faction_wuling")
        mod_set_region_manager("3k_main_cangwu_resource_3","3k_main_faction_wuling")

    -- Cao Yin
        mod_character_add("mod_main_template_historical_cao_yin_fire", "3k_main_faction_wuling", "3k_general_fire")
        cm:modify_character("mod_main_template_historical_cao_yin_fire"):assign_faction_leader()

    -- Initial army
        campaign_invasions:create_invasion("3k_main_faction_wuling", "3k_main_wuling_resource_2", 1, false)
            
    -- Items
        mod_give_equipment("ep_ancillary_armour_medium_armour_earth_extraordinary","3k_main_faction_wuling")

        
----------------------------------------------------------------------------  
-- DONG ZHUO
        
    -- Fan Chou
        local q_char_fanchou_190 = cm:query_model():character_for_template("3k_main_template_historical_fan_chou_hero_fire")
        if q_char_fanchou_190 and not q_char_fanchou_190:is_null_interface() and not q_char_fanchou_190:is_dead() then
            local modify_character = cm:modify_character(q_char_fanchou_190)
            modify_character:set_is_deployable(true)
            modify_character:move_to_faction_and_make_recruited("3k_main_faction_dong_zhuo")
        end

    -- Items
        if cm:query_faction("3k_main_faction_dong_zhuo"):is_human() == false then
            cm:modify_faction("3k_main_faction_dong_zhuo"):ceo_management():add_ceo("ep_ancillary_armour_medium_armour_earth_extraordinary")
        end

        
----------------------------------------------------------------------------          
-- HAN FU

    -- Shen Pei
        local q_char_shenpei_190 = cm:query_model():character_for_template("3k_main_template_historical_shen_pei_hero_water")
        if q_char_shenpei_190 and not q_char_shenpei_190:is_null_interface() and not q_char_shenpei_190:is_dead() then
            local modify_character = cm:modify_character(q_char_shenpei_190)
            modify_character:set_is_deployable(true)
            modify_character:move_to_faction_and_make_recruited("3k_main_faction_han_fu")
        end
        
    -- Tian Feng        
        mod_character_add("3k_main_template_historical_tian_feng_hero_water", "3k_main_faction_han_fu", "3k_general_water")
        
    -- Tian Geng
        mod_character_add("mod_main_template_historical_tian_geng_metal", "3k_main_faction_han_fu", "3k_general_metal")
        mod_make_child("3k_main_template_historical_tian_feng_hero_water", "mod_main_template_historical_tian_geng_metal")
        
        local q_char_tiangeng = cm:query_model():character_for_template("mod_main_template_historical_tian_geng_metal")
        
        if q_char_tiangeng and not q_char_tiangeng:is_null_interface() and not q_char_tiangeng:is_dead() then
            mod_remove_all_trait(q_char_tiangeng)
            local modify_character = cm:modify_character(q_char_tiangeng)
            modify_character:ceo_management():add_ceo("3k_ytr_ceo_trait_personality_people_understanding")
            modify_character:ceo_management():add_ceo("3k_ytr_ceo_trait_personality_stalwart")
            modify_character:ceo_management():add_ceo("3k_ytr_ceo_trait_personality_relentless")
        end

    -- Items
        if cm:query_faction("3k_main_faction_han_fu"):is_human() == false then
            cm:modify_faction("3k_main_faction_han_fu"):ceo_management():add_ceo("ep_ancillary_armour_medium_armour_wood_extraordinary")
        end
        
        
----------------------------------------------------------------------------  
-- 公孙度
        
    -- 太史慈
        mod_character_add("3k_main_template_historical_taishi_ci_hero_metal", "3k_main_faction_gongsun_du", "3k_general_metal")


        
----------------------------------------------------------------------------  
-- LIU DAI
        
    -- Items
        if cm:query_faction("3k_main_faction_liu_dai"):is_human() == false then
            cm:modify_faction("3k_main_faction_liu_dai"):ceo_management():add_ceo("ep_ancillary_armour_strategist_light_armour_water_extraordinary")
        end
        
    -- Liu Gong
        mod_character_add("mod_main_template_historical_liu_gong_metal", "3k_main_faction_liu_dai", "3k_general_metal")
        mod_make_child("3k_main_template_historical_liu_dai_hero_water", "mod_main_template_historical_liu_gong_metal")
        mod_set_minister_position("mod_main_template_historical_liu_gong_metal","faction_heir")

        
----------------------------------------------------------------------------          
-- ZHANG YANG

    -- Items
        if cm:query_faction("3k_main_faction_zhang_yang"):is_human() == false then
            cm:modify_faction("3k_main_faction_zhang_yang"):ceo_management():add_ceo("ep_ancillary_armour_medium_armour_fire_extraordinary")
        end

    -- Zhang Qiang
        mod_character_add("mod_main_template_historical_zhang_qiang_wood", "3k_main_faction_zhang_yang", "3k_general_wood")
        mod_make_child("3k_main_template_historical_zhang_yang_hero_earth", "mod_main_template_historical_zhang_qiang_wood")
        mod_set_minister_position("mod_main_template_historical_zhang_qiang_wood","faction_heir")


----------------------------------------------------------------------------          
-- WANG KUANG

    -- Items
        if cm:query_faction("3k_main_faction_wang_kuang"):is_human() == false then
            cm:modify_faction("3k_main_faction_wang_kuang"):ceo_management():add_ceo("ep_ancillary_armour_light_armour_metal_extraordinary")
        end
        
    -- Wang Yu
        mod_character_add("mod_main_template_historical_wang_yu_fire", "3k_main_faction_wang_kuang", "3k_general_fire")
        mod_make_child("3k_main_template_historical_wang_kuang_hero_metal", "mod_main_template_historical_wang_yu_fire")
        mod_set_minister_position("mod_main_template_historical_wang_yu_fire","faction_heir")        
        
        
----------------------------------------------------------------------------
 -- KONG ZHOU
        
    -- Kong Chang
        mod_character_add("mod_main_template_historical_kong_chang_earth", "3k_main_faction_kong_zhou", "3k_general_earth")
        mod_make_child("3k_main_template_historical_kong_zhou_hero_water", "mod_main_template_historical_kong_chang_earth")
        mod_set_minister_position("mod_main_template_historical_kong_chang_earth","faction_heir") 
    
    -- Kong Xuan
        mod_character_add("mod_main_template_historical_kong_xuan_water", "3k_main_faction_kong_zhou", "3k_general_water")
        mod_make_child("3k_main_template_historical_kong_zhou_hero_water", "mod_main_template_historical_kong_xuan_water")
       
        
----------------------------------------------------------------------------        
 -- QU PAN /JIU ZHEN

    -- Qu Lu
        mod_character_add("mod_main_template_historical_qu_lu_wood", "3k_dlc06_faction_jiuzhen", "3k_general_wood")
        mod_make_child("3k_dlc06_template_generic_qu_pan_hero_metal", "mod_main_template_historical_qu_lu_wood")
        mod_set_minister_position("mod_main_template_historical_qu_lu_wood","faction_heir")         
        

----------------------------------------------------------------------------        
        
        
        
        
        
        
        
----------------------------------------------------------------------------
    end;
    end;


    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    


    -- 194剧本：弃叛之世
    if cm:query_model():campaign_name() == "3k_dlc05_start_pos" then


        --cm:modify_faction("3k_main_faction_ma_teng"):ceo_management():add_ceo("3k_dlc07_ancillary_follower_northern_army_captain")
        --cm:modify_faction("3k_main_faction_liu_yan"):ceo_management():add_ceo("3k_dlc07_ancillary_follower_northern_army_captain")
----------------------------------------------------------------------------
-- 朝廷辖地
        
        -- 陈纪
        mod_character_add("3k_main_template_historical_chen_ji_hero_earth", "3k_main_faction_han_empire", "3k_general_earth")
        
        -- 周奂
        mod_character_add("3k_main_template_historical_zhou_huan_hero_water", "3k_main_faction_han_empire", "3k_general_water")
        
----------------------------------------------------------------------------        
-- 刘备 3k_main_template_historical_liu_bei_hero_earth
    
        query_faction_of_liubei = cm:query_faction("3k_main_faction_liu_bei");
        modify_faction_of_liubei = cm:modify_faction(query_faction_of_liubei);
        
        query_liu_bei = cm:query_character("3k_main_template_historical_liu_bei_hero_earth");
        modify_liu_bei = cm:modify_character(query_liu_bei);
    
        -- AI加成
        if not query_faction_of_liubei:is_human() then
            modify_faction_of_liubei:apply_effect_bundle("3k_main_pooled_resource_liu_bei_unity_ai",-1);
            modify_faction_of_liubei:apply_effect_bundle("zph_liubei_talent_b_ai",-1);
        else
            modify_faction_of_liubei:apply_effect_bundle("zph_liubei_talent_b",-1);
        end;

        -- 角色效果
        modify_liu_bei:apply_effect_bundle("zph_liubei_talent", -1);
        
        -- 简雍 3k_main_template_historical_jian_yong_hero_metal
        query_jian_yong = cm:query_character("3k_main_template_historical_jian_yong_hero_metal");
        modify_jian_yong = cm:modify_character(query_jian_yong);        
        
        -- 编辑特性
        mod_remove_all_trait(query_jian_yong);
        modify_jian_yong:ceo_management():add_ceo("3k_ytr_ceo_trait_personality_people_people_pleaser"); -- 深得民心
        modify_jian_yong:ceo_management():add_ceo("3k_main_ceo_trait_personality_trusting"); -- 言听计从
        modify_jian_yong:ceo_management():add_ceo("3k_ytr_ceo_trait_personality_people_cheerful"); -- 爽朗活泼    
        
        -- 陈群 3k_main_template_historical_chen_qun_hero_water
        modify_chen_qun = modify_faction_of_liubei:create_character_from_template("general", "3k_general_water", "3k_main_template_historical_chen_qun_hero_water", false);
        query_chen_qun = modify_chen_qun:query_character();
        modify_liu_bei:apply_relationship_trigger_set(query_chen_qun, "3k_main_relationship_trigger_set_event_positive_generic_extreme");     
        

        
        
----------------------------------------------------------------------------
-- 马腾
        mod_CEO_equip("3k_main_template_historical_ma_teng_hero_fire", "3k_main_ancillary_accessory_book_of_rites", "3k_main_ceo_category_ancillary_accessory")
        
----------------------------------------------------------------------------        
-- 袁术
        

        
----------------------------------------------------------------------------       
-- 刘表
        
    -- 荀攸       
        mod_character_add("3k_main_template_historical_xun_you_hero_water", "3k_main_faction_liu_biao", "3k_general_water")

    -- 设置外交
        --diplomacy_manager:apply_automatic_deal_between_factions("3k_main_faction_liu_biao", "3k_main_faction_liu_yan", "data_defined_situation_war_proposer_to_recipient",false)

    -- 刘修       
        mod_character_add("mod_main_template_historical_liu_xiu_water", "3k_main_faction_liu_biao", "3k_general_water")
        mod_make_child("3k_main_template_historical_liu_biao_hero_earth", "mod_main_template_historical_liu_xiu_water")


----------------------------------------------------------------------------        
-- 刘焉/刘璋
        
    -- 杨洪
        mod_character_add("mod_main_template_historical_yang_hong_jixiu_water", "3k_main_faction_liu_yan", "3k_general_water");

    -- 董和 3k_dlc04_template_historical_dong_he_earth
        mod_character_add("3k_dlc04_template_historical_dong_he_earth", "3k_main_faction_liu_yan", "3k_general_earth");

----------------------------------------------------------------------------        
-- 刘宠
    
    -- Liu Rui        
        mod_character_add("mod_main_template_historical_liu_rui_hero_water", "3k_dlc04_faction_prince_liu_chong", "3k_general_water")
        mod_make_child("3k_main_template_historical_liu_chong_hero_earth", "mod_main_template_historical_liu_rui_hero_water")
        mod_set_minister_position("mod_main_template_historical_liu_rui_hero_water","faction_heir")
        
        
----------------------------------------------------------------------------
-- 孙策
        if cm:query_faction("3k_dlc05_faction_sun_ce"):is_human() == false then
            
    -- Lü Fan
            mod_character_add("3k_main_template_historical_lu_fan_hero_water", "3k_dlc05_faction_sun_ce", "3k_general_water")
            
    -- Zhang Cheng
            mod_character_add("3k_main_template_historical_zhang_cheng_hero_water", "3k_dlc05_faction_sun_ce", "3k_general_water")
            
    -- Han Dang
            mod_character_add("3k_main_template_historical_han_dang_hero_fire", "3k_dlc05_faction_sun_ce", "3k_general_fire")
            
    -- Cheng Pu
            mod_character_add("3k_main_template_historical_cheng_pu_hero_metal", "3k_dlc05_faction_sun_ce", "3k_general_metal")
            
    -- Lu Su
            mod_character_add("3k_main_template_historical_lu_su_hero_water", "3k_dlc05_faction_sun_ce", "3k_general_water")
            
    -- Huang Gai
            mod_character_add("3k_cp01_template_historical_huang_gai_hero_fire", "3k_dlc05_faction_sun_ce", "3k_general_water")
            
    -- Items         
            mod_give_equipment("ep_ancillary_armour_medium_armour_earth_unique","3k_dlc05_faction_sun_ce")            
        end
        
        
    -- Sun Family's genealogy
        
        --mod_character_add("3k_main_template_historical_sun_yi_hero_fire", "3k_dlc05_faction_sun_ce", "3k_general_fire")
        --mod_make_child("3k_main_template_historical_sun_jian_hero_metal", "3k_main_template_historical_sun_yi_hero_fire")

        --mod_character_add("mod_main_template_historical_sun_kuang_water", "3k_dlc05_faction_sun_ce", "3k_general_water")
        --mod_make_child("3k_main_template_historical_sun_jian_hero_metal", "mod_main_template_historical_sun_kuang_water")

        mod_character_add("mod_main_template_historical_sun_lang_metal", "3k_dlc05_faction_sun_ce", "3k_general_metal")
        mod_make_child("3k_main_template_historical_sun_jian_hero_metal", "mod_main_template_historical_sun_lang_metal")
        
        
----------------------------------------------------------------------------
-- 吴景
        
        -- 编辑亲属关系
        
        mod_character_add("mod_main_template_historical_wu_shixiong_earth", "3k_dlc05_faction_wu_jing", "3k_general_metal")


        mod_make_child("mod_main_template_historical_wu_shixiong_earth", "3k_main_template_historical_wu_jing_hero_fire")
        mod_make_child("mod_main_template_historical_wu_shixiong_earth", "3k_main_template_historical_lady_wu_minyu_hero_earth")

        mod_kill_character("mod_main_template_historical_wu_shixiong_earth")

        mod_character_add("mod_main_template_historical_wu_fen_wood", "3k_dlc05_faction_wu_jing", "3k_general_wood")
        mod_make_child("3k_main_template_historical_wu_jing_hero_fire", "mod_main_template_historical_wu_fen_wood")
        mod_set_minister_position("mod_main_template_historical_liu_du_earth","faction_heir")

        mod_character_add("mod_main_template_historical_wu_qi_metal", "3k_dlc05_faction_wu_jing", "3k_general_metal")
        mod_make_child("3k_main_template_historical_wu_jing_hero_fire", "mod_main_template_historical_wu_qi_metal")
        

----------------------------------------------------------------------------
-- 吕布
        
        -- 昌豨
        mod_character_add("3k_main_template_historical_chang_xi_hero_wood", "3k_main_faction_lu_bu", "3k_general_wood")


----------------------------------------------------------------------------        
-- 杨忠（高粱太守）

        query_faction_of_gaoliang = cm:query_faction("3k_main_faction_gaoliang");

    -- 周奂 3k_main_template_historical_zhou_huan_hero_water
        query_zhou_huan = cm:query_character("3k_main_template_historical_zhou_huan_hero_water");
        query_gaoliang_force = query_zhou_huan:military_force()
        
        cm:modify_character(query_zhou_huan):move_to_faction_and_make_recruited("3k_main_faction_han_empire");

    -- 杨忠 3k_main_template_historical_yang_zhong_hero_metal
        modify_yang_zhong = cm:modify_character("3k_main_template_historical_yang_zhong_hero_metal");
        modify_yang_zhong:move_to_faction_and_make_recruited("3k_main_faction_gaoliang");
        query_yang_zhong = modify_yang_zhong:query_character();
        modify_yang_zhong:assign_faction_leader();

    -- 廷臣列表，设置关系
        female_list = {}
        court_noble_list = {}
        for i = 0, query_faction_of_gaoliang:character_list():num_items() - 1 do
        
            local query_character = query_faction_of_gaoliang:character_list():item_at(i);
            
            if query_character and not query_character:is_null_interface() and not query_character:is_dead()
                and query_character:is_character_in_faction_recruited_characters()
                and query_character:age() > 16 then
                
                    table.insert(court_noble_list, query_character:command_queue_index());
                    modify_yang_zhong:apply_relationship_trigger_set(query_character, "3k_main_relationship_trigger_set_event_positive_generic_extreme");
                    
                    if not query_character:is_male() then
                        table.insert(female_list, query_character:command_queue_index());
                    end;
            end;
        end;

    -- 设置军队
        campaign_invasions:create_invasion("3k_main_faction_gaoliang", "3k_main_gaoliang_capital", 2, false)

    -- 设置婚姻
        local modify_yang_zhong_family_member = cm:modify_model():get_modify_family_member(query_yang_zhong:family_member());
        
        local num = cm:random_int(1, #female_list)
        local modify_yang_zhong_wife_family_member = cm:modify_model():get_modify_family_member(cm:query_character(female_list[num]):family_member());
        
        modify_yang_zhong_family_member:marry_character(modify_yang_zhong_wife_family_member);



----------------------------------------------------------------------------
-- 朱符

    --布山，郁林首府
    --潭中，郁林商港
        mod_set_region_manager("3k_main_yulin_capital","3k_dlc05_faction_zhu_fu")
        mod_set_region_manager("3k_main_yulin_resource_1","3k_dlc05_faction_zhu_fu")


    -- Zhu Qian
        mod_character_add("mod_main_template_historical_zhu_qian_metal", "3k_dlc05_faction_zhu_fu", "3k_general_metal")
        mod_make_child("3k_main_template_historical_zhu_fu_hero_water", "mod_main_template_historical_zhu_qian_metal")
        mod_set_minister_position("mod_main_template_historical_zhu_qian_metal","faction_heir")
        
    -- Move Zhu Fu to his territory
        if cm:query_faction("3k_dlc06_faction_nanman_king_shamoke"):is_human() == false then           
            local q_char_zhufu_194 = cm:query_model():character_for_template("3k_main_template_historical_zhu_fu_hero_water")
            if q_char_zhufu_194 and not q_char_zhufu_194:is_null_interface() and not q_char_zhufu_194:is_dead() then
                cm:modify_character(q_char_zhufu_194):teleport_to(320, 200)
            end
        end
        
---------------------------------------------------------------------------- 
-- 朱符叛军

    -- 广郁，郁林香药集市
    -- 临尘，交趾稻田            
        mod_set_region_manager("3k_main_yulin_resource_2","3k_dlc05_faction_zhu_fu_separatists")
        mod_set_region_manager("3k_main_jiaozhi_resource_1","3k_dlc05_faction_zhu_fu_separatists")
            
    -- Initial army
        campaign_invasions:create_invasion("3k_dlc05_faction_zhu_fu_separatists", "3k_main_yulin_resource_2", 2, false)          

        
        
---------------------------------------------------------------------------- 
-- 史璜

    --广信, 苍梧首府
    --猛陵, 苍梧储木场
    --定周, 苍梧畜牧场
        mod_set_region_manager("3k_main_cangwu_capital","3k_main_faction_cangwu")
        mod_set_region_manager("3k_main_cangwu_resource_2","3k_main_faction_cangwu")
        mod_set_region_manager("3k_main_cangwu_resource_3","3k_main_faction_cangwu")

    -- Shi Huang
        mod_character_add("3k_main_template_historical_shi_huang_hero_earth", "3k_main_faction_cangwu", "3k_general_earth")
        cm:modify_character("3k_main_template_historical_shi_huang_hero_earth"):assign_faction_leader()
            
    -- Initial army
        campaign_invasions:create_invasion("3k_main_faction_cangwu", "3k_main_cangwu_capital", 2, false)
        

----------------------------------------------------------------------------
-- 金旋（武陵太守）

    -- 充县，武陵稻田
    -- 镡成，武陵工具铺
        mod_set_region_manager("3k_main_wuling_resource_1","3k_main_faction_wuling")
        mod_set_region_manager("3k_main_wuling_resource_2","3k_main_faction_wuling")
            
    -- 金旋 3k_main_template_historical_jin_xuan_hero_earth
        query_jin_xuan = cm:query_character("3k_main_template_historical_jin_xuan_hero_earth");
        modify_jin_xuan = cm:modify_character(query_jin_xuan);
        modify_jin_xuan:move_to_faction_and_make_recruited("3k_main_faction_wuling");
        modify_jin_xuan:assign_faction_leader();

    -- 金祎 3k_main_template_historical_jin_yi_hero_water
        modify_jin_yi = cm:modify_faction("3k_main_faction_wuling"):create_character_from_template("general", "3k_general_water", "3k_main_template_historical_jin_yi_hero_water", false);
        modify_jin_yi:make_child_of(modify_jin_xuan);
        modify_jin_yi:assign_to_post("faction_heir");

    -- 军队
        campaign_invasions:create_invasion("3k_main_faction_wuling", "3k_main_wuling_resource_1", 2, false)
            
    -- 道具
        mod_give_equipment("ep_ancillary_armour_medium_armour_earth_extraordinary","3k_main_faction_wuling")


----------------------------------------------------------------------------
-- 刘度（零陵太守）
        
        -- 泉陵，零陵首府
        -- 富川，苍梧稻田
        mod_set_region_manager("3k_main_lingling_capital","3k_main_faction_lingling")
        mod_set_region_manager("3k_main_cangwu_resource_1","3k_main_faction_lingling")

        -- Liu Du
        mod_character_add("mod_main_template_historical_liu_du_earth", "3k_main_faction_lingling", "3k_general_earth")
        cm:modify_character("mod_main_template_historical_liu_du_earth"):assign_faction_leader()
    
        -- Initial army
        campaign_invasions:create_invasion("3k_main_faction_lingling", "3k_main_lingling_capital", 2, false)

        -- Items
        mod_give_equipment("ep_ancillary_armour_medium_armour_earth_extraordinary","3k_main_faction_lingling")            

        -- 设置外交
        diplomacy_manager:apply_automatic_deal_between_factions("3k_main_faction_liu_biao", "3k_main_faction_lingling", "data_defined_situation_liu_biao_vassalise_recipient",true)
            
----------------------------------------------------------------------------
-- 赵范(庐陵太守）

    -- 雩都，庐陵首府
    -- 南平，零陵储木场
    -- 郴县，零陵工具铺
        mod_set_region_manager("3k_main_luling_capital","3k_main_faction_luling")
        mod_set_region_manager("3k_main_lingling_resource_2","3k_main_faction_luling")
        mod_set_region_manager("3k_main_lingling_resource_1","3k_main_faction_luling")

    -- Zhao Fan
        mod_character_add("mod_main_template_historical_zhao_fan_water", "3k_main_faction_luling", "3k_general_water")
        cm:modify_character("mod_main_template_historical_zhao_fan_water"):assign_faction_leader()
          
    -- Initial army
        campaign_invasions:create_invasion("3k_main_faction_luling", "3k_main_luling_capital", 2, false)

    -- Items
        mod_give_equipment("ep_ancillary_armour_strategist_light_armour_water_extraordinary","3k_main_faction_luling")            
 

----------------------------------------------------------------------------  
-- 张羡（长沙太守）

        query_faction_of_changsha = cm:query_faction("3k_main_faction_changsha");
        
        -- 临湘，长沙首府
        -- 酃县，长沙甲匠坊
        -- 茶陵，长沙茶馆
        mod_set_region_manager("3k_main_changsha_capital","3k_main_faction_changsha");
        mod_set_region_manager("3k_main_changsha_resource_2","3k_main_faction_changsha");
        mod_set_region_manager("3k_main_changsha_resource_3","3k_main_faction_changsha");
            
        -- 张羡 mod_main_template_historical_zhang_xian_wood
        modify_zhang_xian = cm:modify_faction("3k_main_faction_changsha"):create_character_from_template("general", "3k_general_wood", "mod_main_template_historical_zhang_xian_wood", false);
        query_zhang_xian = modify_zhang_xian:query_character();
        modify_zhang_xian:assign_faction_leader();

        -- 编辑特性
        mod_remove_all_trait(query_zhang_xian);
        modify_zhang_xian:ceo_management():add_ceo("3k_ytr_ceo_trait_personality_people_people_pleaser"); -- 深得民心
        modify_zhang_xian:ceo_management():add_ceo("3k_ytr_ceo_trait_personality_land_alert"); -- 抱持戒心
        modify_zhang_xian:ceo_management():add_ceo("3k_ytr_ceo_trait_personality_land_aspiring"); -- 尽心尽力
        modify_zhang_xian:ceo_management():add_ceo("3k_main_ceo_trait_personality_disloyal"); -- 不臣之心，194/197
        
        modify_zhang_xian:ceo_management():remove_ceos("3k_main_ceo_career_generated_minister_wood");
        modify_zhang_xian:ceo_management():add_ceo("3k_dlc04_ceo_career_historical_xun_shuang_ciming"); -- 力克贪腐

        -- 张怿 mod_main_template_historical_zhang_yi_metal
        modify_zhang_yi = cm:modify_faction("3k_main_faction_changsha"):create_character_from_template("general", "3k_general_metal", "mod_main_template_historical_zhang_yi_metal", false);
        query_zhang_yi = modify_zhang_xian:query_character();
        modify_zhang_yi:assign_to_post("faction_heir");

        -- 设置亲属关系
        modify_zhang_yi:make_child_of(modify_zhang_xian);

        -- 设置初始成员A
        modify_lingling_char_a = cm:modify_faction("3k_main_faction_changsha"):create_character_from_template( "general", "3k_general_water", "3k_main_template_generic_water_agent_normal_m_hero", false);
        query_lingling_char_a = modify_lingling_char_a:query_character();

        -- 设置人事关系
        modify_zhang_xian:apply_relationship_trigger_set(cm:query_character("3k_main_template_historical_liu_biao_hero_earth"), "3k_main_relationship_trigger_set_event_negative_generic_extreme");
        modify_zhang_xian:apply_relationship_trigger_set(query_zhang_yi, "3k_main_relationship_trigger_set_event_positive_generic_extreme");
        modify_zhang_xian:apply_relationship_trigger_set(query_lingling_char_a, "3k_main_relationship_trigger_set_startpos_family_member");
        modify_zhang_yi:apply_relationship_trigger_set(query_lingling_char_a, "3k_main_relationship_trigger_set_event_positive_generic_extreme");

        -- 设置军队
        found_pos, x, y = query_faction_of_changsha:get_valid_spawn_location_in_region("3k_main_changsha_capital", false);        
        if found_pos then        
            cm:create_force_with_existing_general(query_zhang_xian:command_queue_index(), "3k_main_faction_changsha", "", "3k_main_changsha_capital", x, y, "zhangxian_force", nil, 100);
            local modify_zhang_xian_force = cm:modify_model():get_modify_military_force(query_zhang_xian:military_force());
            
            -- 添加成员
            modify_zhang_xian_force:add_existing_character_as_retinue(modify_zhang_yi, true);
            modify_zhang_xian_force:add_existing_character_as_retinue(modify_lingling_char_a, true);
        end;
 
        -- 设置外交
        diplomacy_manager:apply_automatic_deal_between_factions("3k_main_faction_liu_biao", "3k_main_faction_changsha", "data_defined_situation_liu_biao_vassalise_recipient",true)
 
----------------------------------------------------------------------------
-- 华歆

        if cm:query_faction("3k_dlc05_faction_hua_xin"):is_human() == false then
            
    -- 南昌，豫章首府
    -- 建昌，豫章稻田
            mod_set_region_manager("3k_main_yuzhang_capital","3k_dlc05_faction_hua_xin")
            mod_set_region_manager("3k_main_yuzhang_resource_1","3k_dlc05_faction_hua_xin")

    -- Initial army
            campaign_invasions:create_invasion("3k_dlc05_faction_hua_xin", "3k_main_yuzhang_capital", 2, false)
        end


----------------------------------------------------------------------------
-- 黄祖

    -- Items
        if cm:query_faction("3k_main_faction_huang_zu"):is_human() == false then

            mod_give_equipment("ep_ancillary_armour_heavy_armour_wood_extraordinary","3k_main_faction_huang_zu")
        end

        
----------------------------------------------------------------------------
-- 高干
        
     -- Items   
        if cm:query_faction("3k_main_faction_gao_gan"):is_human() == false then
            mod_give_equipment("ep_ancillary_armour_medium_armour_metal_extraordinary","3k_main_faction_gao_gan")
        end

    -- Gao Family's genealogy
        mod_character_add("mod_main_template_historical_yuan_shuting_water", "3k_main_faction_gao_gan", "3k_general_water")
        mod_character_add("mod_main_template_historical_gao_ci_earth", "3k_main_faction_gao_gan", "3k_general_earth")
        mod_character_add("mod_main_template_historical_gao_gong_earth", "3k_main_faction_gao_gan", "3k_general_earth")
        mod_character_add("mod_main_template_historical_gao_jing_fire", "3k_main_faction_gao_gan", "3k_general_fire")
        mod_character_add("mod_main_age_fixed_historical_gao_dan_water", "3k_main_faction_gao_gan", "3k_general_water")
        mod_character_add("mod_main_age_fixed_historical_gao_jun_wood", "3k_main_faction_gao_gan", "3k_general_wood")
        mod_character_add("mod_main_template_historical_gao_zhun_hero_fire", "3k_main_faction_gao_gan", "3k_general_fire")
        
        mod_make_spouse("mod_main_template_historical_gao_gong_earth", "mod_main_template_historical_yuan_shuting_water")
        
        mod_make_child("mod_main_template_historical_gao_ci_earth", "mod_main_template_historical_gao_gong_earth")
        mod_make_child("mod_main_template_historical_gao_ci_earth", "mod_main_template_historical_gao_jing_fire")
        mod_make_child("mod_main_template_historical_gao_gong_earth", "3k_main_template_historical_gao_gan_hero_metal")
        mod_make_child("mod_main_template_historical_gao_gong_earth", "mod_main_template_historical_gao_zhun_hero_fire")
        mod_make_child("mod_main_template_historical_gao_jing_fire", "3k_main_template_historical_gao_rou_hero_water")
        mod_make_child("3k_main_template_historical_gao_rou_hero_water", "mod_main_age_fixed_historical_gao_dan_water")
        mod_make_child("3k_main_template_historical_gao_rou_hero_water", "mod_main_age_fixed_historical_gao_jun_wood")
        
        mod_make_child("3k_main_template_ancestral_yuan_feng", "mod_main_template_historical_yuan_shuting_water")
        mod_make_child("mod_main_template_historical_yuan_shuting_water", "3k_main_template_historical_gao_gan_hero_metal")
        mod_make_child("mod_main_template_historical_yuan_shuting_water", "mod_main_template_historical_gao_zhun_hero_fire")        

        mod_kill_character("mod_main_template_historical_gao_ci_earth")
        -- mod_kill_character("mod_main_template_historical_gao_gong_earth")
        
        local q_char_gaozhun = cm:query_model():character_for_template("mod_main_template_historical_gao_zhun_hero_fire")
        if q_char_gaozhun and not q_char_gaozhun:is_null_interface() and not q_char_gaozhun:is_dead() then

            mod_remove_all_trait(q_char_gaozhun);

            local modify_character = cm:modify_character(q_char_gaozhun);
            
            modify_character:ceo_management():add_ceo("3k_main_ceo_trait_personality_artful")
            modify_character:ceo_management():add_ceo("3k_main_ceo_trait_personality_energetic")
            modify_character:ceo_management():add_ceo("3k_main_ceo_trait_personality_patient")
        end
            
----------------------------------------------------------------------------
-- 张鲁
            
    -- 阆中，巴西首府
            mod_set_region_manager("3k_main_baxi_capital","3k_main_faction_zhang_lu")

    -- Items
            mod_give_equipment("ep_ancillary_armour_heavy_armour_wood_extraordinary","3k_main_faction_zhang_lu")



----------------------------------------------------------------------------
-- 士燮
        
        if cm:query_faction("3k_main_faction_shi_xie"):is_human() == false then

    -- 朱崖，合浦储木场            
            mod_set_region_manager("3k_main_hepu_resource_2","3k_main_faction_shi_xie")            
        end

    -- Diplomacy setting        
        diplomacy_manager:apply_automatic_deal_between_factions("3k_main_faction_shi_xie", "3k_main_faction_nanhai", "data_defined_situation_peace", true)
        diplomacy_manager:apply_automatic_deal_between_factions("3k_main_faction_shi_xie", "3k_main_faction_gaoliang", "data_defined_situation_peace", true)      
        diplomacy_manager:apply_automatic_deal_between_factions("3k_main_faction_shi_xie", "3k_dlc05_faction_zhu_fu", "data_defined_situation_war_proposer_to_recipient",false)

       
----------------------------------------------------------------------------
-- 笮荣

        if cm:query_faction("3k_main_faction_zhai_rong"):is_human() == false then
            
        -- Items
            mod_give_equipment("ep_ancillary_armour_medium_armour_fire_extraordinary","3k_main_faction_zhai_rong")
        end
        

----------------------------------------------------------------------------
-- 袁绍

        if cm:query_faction("3k_main_faction_yuan_shao"):is_human() == false then
            
    -- Lineage AI Bonus
            cm:modify_faction("3k_main_faction_yuan_shao"):apply_effect_bundle("3k_main_pooled_resource_yuan_shao_lineage_ai",-1)

            
    -- Items
            --mod_give_equipment("ep_ancillary_armour_heavy_armour_fire_unique","3k_main_faction_yuan_shao")
            --mod_give_equipment("ep_ancillary_armour_heavy_armour_wood_unique","3k_main_faction_yuan_shao")
            --mod_give_equipment("3k_main_ancillary_weapon_two_handed_spear_exceptional","3k_main_faction_yuan_shao")
            --mod_give_equipment("3k_main_ancillary_weapon_two_handed_axe_exceptional","3k_main_faction_yuan_shao")
        end
        
    -- Diplomacy setting        
        diplomacy_manager:apply_automatic_deal_between_factions("3k_main_faction_yuan_shao", "3k_main_faction_cao_cao", "data_defined_situation_create_coalition_no_conditions",true)

        
    -- Yuan Fang
       
        mod_character_add("mod_main_template_historical_yuan_fang_earth", "3k_main_faction_yuan_shao", "3k_general_earth")
        mod_make_child("3k_main_template_historical_yuan_shao_hero_earth", "mod_main_template_historical_yuan_fang_earth")
        mod_set_minister_position("mod_main_template_historical_yuan_fang_earth","3k_main_court_offices_prime_minister")
        mod_CEO_equip("mod_main_template_historical_yuan_fang_earth", "ep_ancillary_armour_medium_armour_earth_extraordinary", "3k_main_ceo_category_ancillary_armour")
        
        local q_char_yuanfang = cm:query_model():character_for_template("mod_main_template_historical_yuan_fang_earth")
        if q_char_yuanfang and not q_char_yuanfang:is_null_interface() and not q_char_yuanfang:is_dead() then

            mod_remove_all_trait(q_char_yuanfang)
            local modify_character = cm:modify_character(q_char_yuanfang)

            modify_character:ceo_management():add_ceo("3k_main_ceo_trait_personality_brilliant")
            modify_character:ceo_management():add_ceo("3k_main_ceo_trait_personality_distinguished")
            modify_character:ceo_management():add_ceo("3k_ytr_ceo_trait_personality_land_powerful")
            modify_character:ceo_management():add_ceo("3k_main_ceo_trait_personality_cunning")

            modify_character:ceo_management():remove_ceos("3k_main_ceo_career_generated_minister_earth")
            modify_character:ceo_management():add_ceo("3k_dlc04_ceo_career_historical_chen_su")
        end


    -- Yuan Family's genealogy
        
        mod_character_add("mod_main_template_historical_yuan_ji_earth", "3k_main_faction_yuan_shao", "3k_general_earth")
        mod_character_add("3k_main_template_historical_yuan_yi_hero_water", "3k_main_faction_yuan_shao", "3k_general_water")
        mod_character_add("mod_main_template_historical_yuan_tang_fire", "3k_main_faction_yuan_shao", "3k_general_fire")
        mod_character_add("mod_main_template_historical_yuan_ping_wood", "3k_main_faction_yuan_shao", "3k_general_wood")
        
        mod_make_child("mod_main_template_historical_yuan_tang_fire", "mod_main_template_historical_yuan_ping_wood")
        mod_make_child("mod_main_template_historical_yuan_tang_fire", "3k_main_template_ancestral_yuan_feng")
        mod_make_child("mod_main_template_historical_yuan_ping_wood", "3k_main_template_historical_yuan_yi_hero_water")        
        mod_make_child("3k_main_template_ancestral_yuan_feng", "mod_main_template_historical_yuan_ji_earth")        

        mod_kill_character("mod_main_template_historical_yuan_tang_fire")
        mod_kill_character("mod_main_template_historical_yuan_ping_wood")
        mod_kill_character("mod_main_template_historical_yuan_ji_earth")        
        
        
----------------------------------------------------------------------------
-- 韩遂
        
    -- Diplomacy setting
        diplomacy_manager:apply_automatic_deal_between_factions("3k_main_faction_han_sui", "3k_main_faction_dong_zhuo", "data_defined_situation_war_proposer_to_recipient",false)


----------------------------------------------------------------------------
--[[ cause the freeze of 194 liu yan
-- 李傕

    -- Diplomacy setting
        --diplomacy_manager:apply_automatic_deal_between_factions("3k_main_faction_dong_zhuo", "3k_main_faction_liu_yan", "data_defined_situation_war_proposer_to_recipient",false)
        diplomacy_manager:apply_automatic_deal_between_factions("3k_main_faction_dong_zhuo", "3k_main_faction_ba", "data_defined_situation_vassalise_recipient",true)

]]--        
----------------------------------------------------------------------------
-- 曹操

    -- Diplomacy setting
        diplomacy_manager:apply_automatic_deal_between_factions("3k_main_faction_cao_cao", "3k_main_faction_zhang_yan", "data_defined_situation_war_proposer_to_recipient",false)

    -- 卢毓 3k_main_template_historical_lu_yu_hero_water
        mod_character_add("3k_main_template_historical_lu_yu_hero_water", "3k_main_faction_cao_cao", "3k_general_water");
        
        
----------------------------------------------------------------------------
-- 公孙瓒
        
    -- Diplomacy setting
        diplomacy_manager:apply_automatic_deal_between_factions("3k_main_faction_gongsun_zan", "3k_main_faction_cao_cao", "data_defined_situation_war_proposer_to_recipient",false);

    -- 杨樊
       
        mod_character_add("mod_main_template_historical_yang_fan_wood", "3k_main_faction_gongsun_zan", "3k_general_wood");
        
        local q_char_yangfan = cm:query_model():character_for_template("mod_main_template_historical_yang_fan_wood");
        if q_char_yangfan and not q_char_yangfan:is_null_interface() and not q_char_yangfan:is_dead() then

            mod_remove_all_trait(q_char_yangfan);

            local modify_character = cm:modify_character(q_char_yangfan);

            modify_character:ceo_management():add_ceo("3k_main_ceo_trait_personality_stubborn");
            modify_character:ceo_management():add_ceo("3k_main_ceo_trait_personality_humble");
            modify_character:ceo_management():add_ceo("3k_main_ceo_trait_personality_brave");
        end;
        
        -- 田豫 3k_main_template_historical_tian_yu_hero_fire
        query_tian_yu = cm:query_character("3k_main_template_historical_tian_yu_hero_fire");
        modify_tian_yu = cm:modify_character(query_tian_yu);

        -- 编辑特性
        mod_remove_all_trait(query_tian_yu);
        modify_tian_yu:ceo_management():add_ceo("3k_main_ceo_trait_personality_aescetic"); -- 清心寡欲
        modify_tian_yu:ceo_management():add_ceo("3k_main_ceo_trait_personality_dutiful"); -- 尽职尽责
        modify_tian_yu:ceo_management():add_ceo("3k_main_ceo_trait_personality_cautious"); -- 谨小慎微
        
        -- 设置与刘备关系
        modify_liu_bei:apply_relationship_trigger_set(query_tian_yu, "3k_main_relationship_trigger_set_event_positive_generic_extreme");
        
---------------------------------------------------------------------------
-- 公孙度

    --黄县, 东莱首府
        mod_set_region_manager("3k_main_donglai_capital","3k_main_faction_gongsun_du")
        


----------------------------------------------------------------------------    
-- 刘繇

        query_liu_yao = cm:query_character("3k_main_template_historical_liu_yao_hero_earth");
        modify_liu_yao = cm:modify_character(query_liu_yao);

        -- 编辑特性
        mod_remove_all_trait(query_liu_yao);
        modify_liu_yao:ceo_management():add_ceo("3k_main_ceo_trait_personality_energetic"); -- 斗志昂扬
        modify_liu_yao:ceo_management():add_ceo("3k_ytr_ceo_trait_personality_relentless"); -- 不屈不挠
        modify_liu_yao:ceo_management():add_ceo("3k_ytr_ceo_trait_personality_land_alert"); -- 抱持戒心


----------------------------------------------------------------------------          
-- 张杨

    -- Items
        if cm:query_faction("3k_main_faction_zhang_yang"):is_human() == false then
            cm:modify_faction("3k_main_faction_zhang_yang"):ceo_management():add_ceo("ep_ancillary_armour_medium_armour_fire_extraordinary")
        end

    -- Zhang Qiang
        mod_character_add("mod_main_template_historical_zhang_qiang_wood", "3k_main_faction_zhang_yang", "3k_general_wood")
        mod_make_child("3k_main_template_historical_zhang_yang_hero_earth", "mod_main_template_historical_zhang_qiang_wood")
        mod_set_minister_position("mod_main_template_historical_zhang_qiang_wood","faction_heir")

----------------------------------------------------------------------------          
-- 袁术

    -- 刘勋 3k_dlc04_template_historical_liu_xun_fire
        modify_liu_xun = cm:modify_faction("3k_main_faction_yuan_shu"):create_character_from_template("general", "3k_general_fire", "3k_dlc04_template_historical_liu_xun_fire", false);
        query_liu_xun = modify_liu_xun:query_character();

    -- 王宋 3k_dlc04_template_historical_lady_wang_song_water
        modify_wang_song = cm:modify_faction("3k_main_faction_yuan_shu"):create_character_from_template("general", "3k_general_water", "3k_dlc04_template_historical_lady_wang_song_water", false);
        query_wang_song = modify_wang_song:query_character();        

        local modify_liu_xun_family_member = cm:modify_model():get_modify_family_member(query_liu_xun:family_member());
        local modify_wang_song_family_member = cm:modify_model():get_modify_family_member(query_wang_song:family_member());    
        modify_wang_song_family_member:marry_character(modify_liu_xun_family_member);

----------------------------------------------------------------------------          
-- 孔融

    -- 刘洪 3k_dlc04_template_historical_liu_hong_water
        mod_character_add("3k_dlc04_template_historical_liu_hong_water", "3k_main_faction_kong_rong", "3k_general_water")

----------------------------------------------------------------------------          
-- 王朗

    -- 周昕 3k_main_template_historical_zhou_xin_hero_fire
    
        mod_character_add("3k_main_template_historical_zhou_xin_hero_fire", "3k_main_faction_wang_lang", "3k_general_fire")



----------------------------------------------------------------------------
    end;





    
    
    
    
    
    
    
    
    
    
    
    
    
    













    -- 182剧本：天命之战
    if cm:query_model():campaign_name() == "3k_dlc04_start_pos" then

--[[
--南蛮，孟获
    
        mod_set_region_manager("3k_main_jianning_capital","3k_dlc06_faction_nanman_king_meng_huo")
        
--南蛮，建宁
        
        mod_set_region_manager("3k_main_jianning_resource_1","3k_dlc06_faction_nanman_jianning")
        

--南蛮，忙牙长
        
        mod_set_region_manager("3k_dlc06_yunnan_resource_1","3k_dlc06_faction_nanman_mangyachang")
        mod_character_add("3k_dlc06_template_historical_mangyachang_hero_nanman", "3k_dlc06_faction_nanman_mangyachang", "3k_general_nanman")        
        mod_set_minister_position("3k_dlc06_template_historical_mangyachang_hero_nanman", "faction_leader")
        
        
--南蛮，祝融
        
        mod_set_region_manager("3k_dlc06_yunnan_capital","3k_dlc06_faction_nanman_lady_zhurong")
        mod_character_add("3k_dlc06_template_genereated_she_bo_hero_nanman", "3k_dlc06_faction_nanman_lady_zhurong", "3k_general_nanman")        
        mod_set_minister_position("3k_dlc06_template_genereated_she_bo_hero_nanman", "faction_leader")        
        
        
--南蛮，交趾
        
        mod_set_region_manager("3k_main_jiaozhi_resource_2","3k_dlc06_faction_nanman_jiaozhi")

--南蛮，金环三结
        
        mod_set_region_manager("3k_main_fuling_capital","3k_dlc06_faction_nanman_jinhuansanjie") 
        mod_set_region_manager("3k_main_fuling_resource_1","3k_dlc06_faction_nanman_jinhuansanjie") 
        mod_character_add("3k_dlc06_template_historical_jinhuansanjie_hero_nanman", "3k_dlc06_faction_nanman_jinhuansanjie", "3k_general_nanman")        
        mod_set_minister_position("3k_dlc06_template_historical_jinhuansanjie_hero_nanman", "faction_leader")
        
        
--南蛮，云南
        
        mod_set_region_manager("3k_dlc06_yunnan_resource_2","3k_dlc06_faction_nanman_yunnan")

--南蛮，土安
        
        mod_set_region_manager("3k_main_jiangyang_resource_3","3k_dlc06_faction_nanman_tu_an")
        
--南蛮，牂牁
        
        mod_set_region_manager("3k_main_zangke_resource_1","3k_dlc06_faction_nanman_zangke")        
        
--南蛮，江阳
        
        mod_set_region_manager("3k_main_jiangyang_resource_2","3k_dlc06_faction_nanman_jiangyang")              
        
--南蛮，沙摩柯
        
        mod_set_region_manager("3k_main_wuling_capital","3k_dlc06_faction_nanman_king_shamoke")
        mod_character_add("3k_dlc06_template_historical_king_shamoke_hero_nanman", "3k_dlc06_faction_nanman_king_shamoke", "3k_general_nanman")        
        mod_set_minister_position("3k_dlc06_template_historical_king_shamoke_hero_nanman", "faction_leader")
        
--南蛮，阿会喃
        
        mod_set_region_manager("3k_main_jianning_resource_2","3k_dlc06_faction_nanman_ahuinan")          
        mod_character_add("3k_dlc06_template_historical_ahuinan_hero_nanman", "3k_dlc06_faction_nanman_ahuinan", "3k_general_nanman")        
        mod_set_minister_position("3k_dlc06_template_historical_ahuinan_hero_nanman", "faction_leader")

        
--南蛮，永昌
        
        mod_set_region_manager("3k_dlc06_yongchang_capital","3k_dlc06_faction_nanman_yongchang")          
        
--南蛮，朵思
        
        mod_set_region_manager("3k_main_zangke_capital","3k_dlc06_faction_nanman_king_duosi")               
        
--南蛮，杨锋
        
        mod_set_region_manager("3k_dlc06_yongchang_resource_1","3k_dlc06_faction_nanman_yang_feng")
        mod_set_region_manager("3k_dlc06_jianning_resource_3","3k_dlc06_faction_nanman_yang_feng")    
        mod_character_add("3k_dlc06_template_historical_yang_feng_hero_nanman", "3k_dlc06_faction_nanman_yang_feng", "3k_general_nanman")        
        mod_set_minister_position("3k_dlc06_template_historical_yang_feng_hero_nanman", "faction_leader")
        
--南蛮，董荼那
        
        mod_set_region_manager("3k_main_zangke_resource_2","3k_dlc06_faction_nanman_dongtuna")        
        
        
--南蛮，奚泥
        
        mod_set_region_manager("3k_main_jiangyang_resource_1","3k_dlc06_faction_nanman_xi_ni")              
        
--南蛮，木鹿
        
        mod_set_region_manager("3k_dlc06_jiaozhi_resource_3","3k_dlc06_faction_nanman_king_mulu")         
        
--南蛮，兀突骨
        
        mod_set_region_manager("3k_main_jiangyang_capital","3k_dlc06_faction_nanman_king_wutugu")          
        
]]--


-- 朝廷辖地

    -- 张羡
        -- 张羡 mod_main_template_historical_zhang_xian_wood
        modify_zhang_xian = cm:modify_faction("3k_main_faction_han_empire"):create_character_from_template("general", "3k_general_wood", "mod_main_template_historical_zhang_xian_wood", false);
        query_zhang_xian = modify_zhang_xian:query_character();

        -- 编辑特性
        mod_remove_all_trait(query_zhang_xian);
        modify_zhang_xian:ceo_management():add_ceo("3k_ytr_ceo_trait_personality_people_people_pleaser"); -- 深得民心
        modify_zhang_xian:ceo_management():add_ceo("3k_ytr_ceo_trait_personality_land_alert"); -- 抱持戒心
        modify_zhang_xian:ceo_management():add_ceo("3k_ytr_ceo_trait_personality_land_aspiring"); -- 尽心尽力
        -- modify_zhang_xian:ceo_management():add_ceo("3k_main_ceo_trait_personality_disloyal"); -- 不臣之心，194/197
        
        modify_zhang_xian:ceo_management():remove_ceos("3k_main_ceo_career_generated_minister_wood");
        modify_zhang_xian:ceo_management():add_ceo("3k_dlc04_ceo_career_historical_xun_shuang_ciming"); -- 力克贪腐

        -- 张怿 mod_main_template_historical_zhang_yi_metal
        modify_zhang_yi = cm:modify_faction("3k_main_faction_han_empire"):create_character_from_template("general", "3k_general_metal", "mod_main_template_historical_zhang_yi_metal", false);
        query_zhang_yi = modify_zhang_xian:query_character();

        -- 设置亲属关系
        modify_zhang_yi:make_child_of(modify_zhang_xian);

        -- 设置人事关系
        modify_zhang_xian:apply_relationship_trigger_set(query_zhang_yi, "3k_main_relationship_trigger_set_event_positive_generic_extreme");


-- 刘备 3k_main_template_historical_liu_bei_hero_earth
    
        query_faction_of_liubei = cm:query_faction("3k_main_faction_liu_bei");
        modify_faction_of_liubei = cm:modify_faction(query_faction_of_liubei);
        
        query_liu_bei = cm:query_character("3k_main_template_historical_liu_bei_hero_earth");
        modify_liu_bei = cm:modify_character(query_liu_bei);
    
        -- AI加成
        if not query_faction_of_liubei:is_human() then
            modify_faction_of_liubei:apply_effect_bundle("3k_main_pooled_resource_liu_bei_unity_ai",-1);
            modify_faction_of_liubei:apply_effect_bundle("zph_liubei_talent_b_ai",-1);
        else
            modify_faction_of_liubei:apply_effect_bundle("zph_liubei_talent_b",-1);
        end;

        -- 角色效果
        modify_liu_bei:apply_effect_bundle("zph_liubei_talent", -1);

        
-- 陶谦
        -- 简雍 3k_main_template_historical_jian_yong_hero_metal
        query_jian_yong = cm:query_character("3k_main_template_historical_jian_yong_hero_metal");
        if query_jian_yong and not query_jian_yong:is_null_interface() then
            modify_jian_yong = cm:modify_character(query_jian_yong);

        
            -- 编辑特性
            mod_remove_all_trait(query_jian_yong);
            modify_jian_yong:ceo_management():add_ceo("3k_ytr_ceo_trait_personality_people_people_pleaser"); -- 深得民心
            modify_jian_yong:ceo_management():add_ceo("3k_main_ceo_trait_personality_trusting"); -- 言听计从
            modify_jian_yong:ceo_management():add_ceo("3k_ytr_ceo_trait_personality_people_cheerful"); -- 爽朗活泼
        end;

        

--董扶
    --建立董扶并将其设置为首领
        mod_character_add("mod_main_template_historical_dong_fu_water", "3k_dlc04_faction_dong_he", "3k_general_water")        
        cm:modify_character("mod_main_template_historical_dong_fu_water"):assign_faction_leader()
        
    --与刘焉结盟
        
        diplomacy_manager:apply_automatic_deal_between_factions("3k_dlc04_faction_dong_he", "3k_main_faction_liu_yan", "data_defined_situation_create_coalition_no_conditions",true)
        
        
-- 刘宠
    --家谱和储君
        
        mod_character_add("mod_main_template_historical_liu_rui_hero_water", "3k_dlc04_faction_prince_liu_chong", "3k_general_water")
        mod_make_child("3k_main_template_historical_liu_chong_hero_earth", "mod_main_template_historical_liu_rui_hero_water")
        mod_set_minister_position("mod_main_template_historical_liu_rui_hero_water","faction_heir")


--刘宏
    --获得玉玺

        mod_give_equipment("3k_main_ancillary_imperial_jade_seal","3k_dlc04_faction_empress_he")

--袁绍
        if cm:query_faction("3k_main_faction_yuan_shao"):is_human() == false then
            cm:modify_faction("3k_main_faction_yuan_shao"):apply_effect_bundle("3k_main_pooled_resource_yuan_shao_lineage_ai",-1)
        end 

        
--袁遗
    --西城, 上庸储木场 
        
        if cm:query_faction("3k_dlc04_faction_yuan_yi"):is_human() == false then
            mod_set_region_manager("3k_main_shangyong_resource_1","3k_dlc04_faction_yuan_yi")            
        end


--袁术
    --纪灵投袁术

        local q_char_jiling_182 = cm:query_model():character_for_template("3k_main_template_historical_ji_ling_hero_fire");

        if q_char_jiling_182 and not q_char_jiling_182:is_null_interface() and not q_char_jiling_182:is_dead() then
            local modify_character = cm:modify_character(q_char_jiling_182);
            modify_character:set_is_deployable(true);
            modify_character:move_to_faction_and_make_recruited("3k_main_faction_yuan_shu");
        end;
        

-- YUAN FAMILY's Genealogy
        
        mod_character_add("mod_main_template_historical_yuan_ji_earth", "3k_dlc04_faction_yuan_yi", "3k_general_earth")
        mod_character_add("mod_main_template_historical_yuan_tang_fire", "3k_dlc04_faction_yuan_yi", "3k_general_fire")
        mod_character_add("mod_main_template_historical_yuan_ping_wood", "3k_dlc04_faction_yuan_yi", "3k_general_wood")
        mod_character_add("3k_main_template_ancestral_yuan_feng", "3k_dlc04_faction_yuan_yi", "3k_general_earth")
        mod_character_add("3k_main_template_historical_lady_yuan_anyang_hero_earth", "3k_main_faction_yuan_shu", "3k_general_earth")
        mod_character_add("3k_main_template_historical_yuan_yao_hero_earth", "3k_main_faction_yuan_shu", "3k_general_earth")        
        
        mod_make_child("mod_main_template_historical_yuan_tang_fire", "mod_main_template_historical_yuan_ping_wood")
        mod_make_child("mod_main_template_historical_yuan_tang_fire", "3k_main_template_ancestral_yuan_feng")
        mod_make_child("mod_main_template_historical_yuan_ping_wood", "3k_main_template_historical_yuan_yi_hero_water")
        mod_make_child("3k_main_template_ancestral_yuan_feng", "3k_main_template_historical_yuan_shu_hero_earth")
        mod_make_child("3k_main_template_ancestral_yuan_feng", "3k_main_template_historical_yuan_shao_hero_earth")
        mod_make_child("3k_main_template_ancestral_yuan_feng", "mod_main_template_historical_yuan_ji_earth")
        mod_make_child("3k_main_template_historical_yuan_shu_hero_earth", "3k_main_template_historical_lady_yuan_anyang_hero_earth")
        mod_make_child("3k_main_template_historical_yuan_shu_hero_earth", "3k_main_template_historical_yuan_yao_hero_earth")        
        

        mod_kill_character("mod_main_template_historical_yuan_tang_fire")
        mod_kill_character("3k_main_template_ancestral_yuan_feng")
        mod_kill_character("mod_main_template_historical_yuan_ping_wood")
        mod_kill_character("mod_main_template_historical_yuan_ji_earth")
        
        
     
        

----------------------------------------------------------------------------
-- 马腾
        mod_CEO_equip("3k_main_template_historical_ma_teng_hero_fire", "3k_main_ancillary_accessory_book_of_rites", "3k_main_ceo_category_ancillary_accessory")
        
        

--[[ 存在和地域招募冲突的bug，会导致单位全解锁
--汉朝辖地
    --南昌, 豫章首府
    --龙川, 南海稻田
    --揭阳, 南海商港
    --且兰, 牂牁首府

        if cm:query_faction("3k_main_faction_han_empire"):is_human() == false then
         
            mod_set_region_manager("3k_main_yuzhang_capital","3k_main_faction_han_empire")
            mod_set_region_manager("3k_main_nanhai_resource_1","3k_main_faction_han_empire")
            mod_set_region_manager("3k_main_nanhai_resource_3","3k_main_faction_han_empire")
            mod_set_region_manager("3k_main_zangke_capital","3k_main_faction_han_empire")      

        end
]]--

    end;
    

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    

    -- 200剧本：官渡之战
    if cm:query_model():campaign_name() == "3k_dlc07_start_pos" then
        
        
----------------------------------------------------------------------------
-- 黄金乱军
        --[[
        local liupi_faction = emergent_faction:new("liupi_faction", "3k_main_faction_yellow_turban_rebels", "3k_main_yangzhou_capital", true);
        liupi_faction:add_faction_leader("3k_ytr_template_historical_liu_pi_hero_water", "3k_general_water", true);
        liupi_faction:add_spawn_dates(200, 201);
        emergent_faction_manager:add_emergent_faction(liupi_faction);
        ]]--
        
----------------------------------------------------------------------------
-- 马腾
        mod_CEO_equip("3k_main_template_historical_ma_teng_hero_fire", "3k_main_ancillary_accessory_book_of_rites", "3k_main_ceo_category_ancillary_accessory")
        
----------------------------------------------------------------------------        
        
-- 刘表

    -- 金旋
        modify_jin_xuan = cm:modify_character("3k_main_template_historical_jin_xuan_hero_earth");

    -- 金祎 3k_main_template_historical_jin_yi_hero_water
        modify_jin_yi = cm:modify_faction("3k_main_faction_liu_biao"):create_character_from_template("general", "3k_general_water", "3k_main_template_historical_jin_yi_hero_water", false);
        modify_jin_yi:make_child_of(modify_jin_xuan);
      
----------------------------------------------------------------------------
        
-- 袁绍
        -- 袁方
       
        mod_character_add("mod_main_template_historical_yuan_fang_earth", "3k_main_faction_yuan_shao", "3k_general_earth")
        mod_make_child("3k_main_template_historical_yuan_shao_hero_earth", "mod_main_template_historical_yuan_fang_earth")
        mod_set_minister_position("mod_main_template_historical_yuan_fang_earth","3k_main_court_offices_prime_minister")
        mod_CEO_equip("mod_main_template_historical_yuan_fang_earth", "ep_ancillary_armour_medium_armour_earth_extraordinary", "3k_main_ceo_category_ancillary_armour")
        
        local q_char_yuanfang = cm:query_model():character_for_template("mod_main_template_historical_yuan_fang_earth")
        if q_char_yuanfang and not q_char_yuanfang:is_null_interface() and not q_char_yuanfang:is_dead() then

            mod_remove_all_trait(q_char_yuanfang);

            local modify_character = cm:modify_character(q_char_yuanfang);

            modify_character:ceo_management():add_ceo("3k_main_ceo_trait_personality_brilliant")
            modify_character:ceo_management():add_ceo("3k_main_ceo_trait_personality_distinguished")
            modify_character:ceo_management():add_ceo("3k_ytr_ceo_trait_personality_land_powerful")
            modify_character:ceo_management():add_ceo("3k_main_ceo_trait_personality_cunning")

            modify_character:ceo_management():remove_ceos("3k_main_ceo_career_generated_minister_earth")
            modify_character:ceo_management():add_ceo("3k_dlc04_ceo_career_historical_chen_su")
        end

        if cm:query_faction("3k_main_faction_yuan_shao"):is_human() == false then
            cm:modify_faction("3k_main_faction_yuan_shao"):apply_effect_bundle("3k_main_pooled_resource_yuan_shao_lineage_ai",-1)
        end 
        
----------------------------------------------------------------------------
        
-- 刘备 3k_main_template_historical_liu_bei_hero_earth
    
        query_faction_of_liubei = cm:query_faction("3k_main_faction_liu_bei");
        modify_faction_of_liubei = cm:modify_faction(query_faction_of_liubei);
        
        query_liu_bei = cm:query_character("3k_main_template_historical_liu_bei_hero_earth");
        modify_liu_bei = cm:modify_character(query_liu_bei);
    
        -- AI加成
        if not query_faction_of_liubei:is_human() then
            modify_faction_of_liubei:apply_effect_bundle("3k_main_pooled_resource_liu_bei_unity_ai",-1);
            modify_faction_of_liubei:apply_effect_bundle("zph_liubei_talent_b_ai",-1);
        else
            modify_faction_of_liubei:apply_effect_bundle("zph_liubei_talent_b",-1);
        end;

        -- 角色效果
        modify_liu_bei:apply_effect_bundle("zph_liubei_talent", -1);

        -- 简雍 3k_main_template_historical_jian_yong_hero_metal
        query_jian_yong = cm:query_character("3k_main_template_historical_jian_yong_hero_metal");
        if query_jian_yong and not query_jian_yong:is_null_interface() then
            modify_jian_yong = cm:modify_character(query_jian_yong);

        
            -- 编辑特性
            mod_remove_all_trait(query_jian_yong);
            modify_jian_yong:ceo_management():add_ceo("3k_ytr_ceo_trait_personality_people_people_pleaser"); -- 深得民心
            modify_jian_yong:ceo_management():add_ceo("3k_main_ceo_trait_personality_trusting"); -- 言听计从
            modify_jian_yong:ceo_management():add_ceo("3k_ytr_ceo_trait_personality_people_cheerful"); -- 爽朗活泼
        end;
    
----------------------------------------------------------------------------      
    
-- 高干

        -- 道具   
        if cm:query_faction("3k_main_faction_gao_gan"):is_human() == false then
            mod_give_equipment("ep_ancillary_armour_medium_armour_metal_extraordinary","3k_main_faction_gao_gan")
        end

        -- 族谱
        mod_character_add("mod_main_template_historical_yuan_shuting_water", "3k_main_faction_gao_gan", "3k_general_water")
        mod_character_add("mod_main_template_historical_gao_ci_earth", "3k_main_faction_gao_gan", "3k_general_earth")
        mod_character_add("mod_main_template_historical_gao_gong_earth", "3k_main_faction_gao_gan", "3k_general_earth")
        mod_character_add("mod_main_template_historical_gao_jing_fire", "3k_main_faction_gao_gan", "3k_general_fire")
        mod_character_add("mod_main_age_fixed_historical_gao_dan_water", "3k_main_faction_gao_gan", "3k_general_water")
        mod_character_add("mod_main_age_fixed_historical_gao_jun_wood", "3k_main_faction_gao_gan", "3k_general_wood")
        mod_character_add("mod_main_template_historical_gao_zhun_hero_fire", "3k_main_faction_gao_gan", "3k_general_fire")
        
        mod_make_spouse("mod_main_template_historical_gao_gong_earth", "mod_main_template_historical_yuan_shuting_water")
        
        mod_make_child("mod_main_template_historical_gao_ci_earth", "mod_main_template_historical_gao_gong_earth")
        mod_make_child("mod_main_template_historical_gao_ci_earth", "mod_main_template_historical_gao_jing_fire")
        mod_make_child("mod_main_template_historical_gao_gong_earth", "3k_main_template_historical_gao_gan_hero_metal")
        mod_make_child("mod_main_template_historical_gao_gong_earth", "mod_main_template_historical_gao_zhun_hero_fire")
        mod_make_child("mod_main_template_historical_gao_jing_fire", "3k_main_template_historical_gao_rou_hero_water")
        mod_make_child("3k_main_template_historical_gao_rou_hero_water", "mod_main_age_fixed_historical_gao_dan_water")
        mod_make_child("3k_main_template_historical_gao_rou_hero_water", "mod_main_age_fixed_historical_gao_jun_wood")
        
        mod_make_child("3k_main_template_ancestral_yuan_feng", "mod_main_template_historical_yuan_shuting_water")
        mod_make_child("mod_main_template_historical_yuan_shuting_water", "3k_main_template_historical_gao_gan_hero_metal")
        mod_make_child("mod_main_template_historical_yuan_shuting_water", "mod_main_template_historical_gao_zhun_hero_fire")        

        mod_kill_character("mod_main_template_historical_gao_ci_earth")
        -- mod_kill_character("mod_main_template_historical_gao_gong_earth")
    
        local q_char_gaozhun = cm:query_model():character_for_template("mod_main_template_historical_gao_zhun_hero_fire")
        if q_char_gaozhun and not q_char_gaozhun:is_null_interface() and not q_char_gaozhun:is_dead() then

            mod_remove_all_trait(q_char_gaozhun);

            local modify_character = cm:modify_character(q_char_gaozhun);
            
            modify_character:ceo_management():add_ceo("3k_main_ceo_trait_personality_artful")
            modify_character:ceo_management():add_ceo("3k_main_ceo_trait_personality_energetic")
            modify_character:ceo_management():add_ceo("3k_main_ceo_trait_personality_patient")
        end 

    -- 应劭及其子应玚、应璩
    -- 3k_main_template_historical_ying_shao_hero_fire
    -- 3k_main_template_historical_ying_yang_hero_water
    -- 3k_main_template_historical_ying_qu_hero_water
        
        query_ying_shao = cm:query_character("3k_main_template_historical_ying_shao_hero_fire");
        modify_ying_shao = cm:modify_character(query_ying_shao);
        modify_ying_shao:move_to_faction_and_make_recruited("3k_main_faction_gao_gan");

        modify_ying_yang = cm:modify_faction("3k_main_faction_gao_gan"):create_character_from_template("general", "3k_general_water", "3k_main_template_historical_ying_yang_hero_water", false);
        modify_ying_qu = cm:modify_faction("3k_main_faction_gao_gan"):create_character_from_template("general", "3k_general_water", "3k_main_template_historical_ying_qu_hero_water", false);        
        
        modify_ying_yang:make_child_of(modify_ying_shao);
        modify_ying_qu:make_child_of(modify_ying_shao);        
        
        found_pos, x, y = cm:query_faction("3k_main_faction_gao_gan"):get_valid_spawn_location_in_region("3k_main_shangdang_capital", false);        
        if found_pos then        
            cm:create_force_with_existing_general(query_ying_shao:command_queue_index(), "3k_main_faction_gao_gan", "", "3k_main_shangdang_capital", x, y, "yingshao_force", nil, 100);
            local modify_ying_shao_force = cm:modify_model():get_modify_military_force(query_ying_shao:military_force());
            
            -- 添加将领
            modify_ying_shao_force:add_existing_character_as_retinue(modify_ying_yang, true);
        end;




----------------------------------------------------------------------------     



----------------------------------------------------------------------------     
-- 孙策
    -- Sun Family's genealogy

        mod_character_add("mod_main_template_historical_sun_lang_metal", "3k_dlc05_faction_sun_ce", "3k_general_metal")
        mod_make_child("3k_main_template_historical_sun_jian_hero_metal", "mod_main_template_historical_sun_lang_metal")    
    
    
----------------------------------------------------------------------------
-- 刘焉/刘璋
    
        -- Yang Hong 
        mod_character_add("mod_main_template_historical_yang_hong_jixiu_water", "3k_main_faction_liu_yan", "3k_general_water")
    
-- 曹操
        
        query_faction_of_cao = cm:query_faction("3k_main_faction_cao_cao");
        modify_faction_of_cao = cm:modify_faction(query_faction_of_cao);
        
        query_cao_cao = cm:query_character("3k_main_template_historical_cao_cao_hero_earth");
        modify_cao_cao = cm:modify_character(query_cao_cao);
        
        -- 田豫 3k_main_template_historical_tian_yu_hero_fire
        modify_tian_yu = cm:modify_faction("3k_main_faction_cao_cao"):create_character_from_template("general", "3k_general_fire", "3k_main_template_historical_tian_yu_hero_fire", false);
        query_tian_yu = modify_tian_yu:query_character();

        -- 编辑特性
        mod_remove_all_trait(query_tian_yu);
        modify_tian_yu:ceo_management():add_ceo("3k_main_ceo_trait_personality_aescetic"); -- 清心寡欲
        modify_tian_yu:ceo_management():add_ceo("3k_main_ceo_trait_personality_dutiful"); -- 尽职尽责
        modify_tian_yu:ceo_management():add_ceo("3k_main_ceo_trait_personality_cautious"); -- 谨小慎微
        
        -- 设置与曹操、刘备关系
        modify_cao_cao:apply_relationship_trigger_set(query_tian_yu, "3k_main_relationship_trigger_set_event_positive_generic_extreme");          
        modify_liu_bei:apply_relationship_trigger_set(query_tian_yu, "3k_main_relationship_trigger_set_event_positive_generic_extreme");   
        
        -- 陈群 3k_main_template_historical_chen_qun_hero_water
        modify_chen_qun = modify_faction_of_liubei:create_character_from_template("general", "3k_general_water", "3k_main_template_historical_chen_qun_hero_water", false);
        query_chen_qun = modify_chen_qun:query_character();
        
        -- 设置与曹操、刘备关系
        modify_liu_bei:apply_relationship_trigger_set(query_chen_qun, "3k_main_relationship_trigger_set_event_positive_generic_extreme");  


        -- 卢毓 3k_main_template_historical_lu_yu_hero_water
        mod_character_add("3k_main_template_historical_lu_yu_hero_water", "3k_main_faction_cao_cao", "3k_general_water");




    
    end;    
    

    
    

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    --291剧本：八王之乱
    if cm:query_model():campaign_name() == "8p_start_pos" then
        
    --NOTE 晋帝国随机武将
        modify_jin_char_a = cm:modify_faction("ep_faction_empire_of_jin"):create_character_from_template( "general", "3k_general_fire", "3k_main_template_generic_fire_general_legendary_m_hero", false);

    --NOTE 祖先
        --NOTE T1
        -- 司马防 
        mod_character_add("3k_main_template_historical_sima_fang_hero_water", "ep_faction_empire_of_jin", "3k_general_water");

        --NOTE T2
        -- 司马孚
        mod_character_add("3k_main_template_historical_sima_fu_hero_water", "ep_faction_empire_of_jin", "3k_general_water");
        -- 司马馗 mod_main_template_historical_sima_kui_water
        modify_sima_kui = cm:modify_faction("ep_faction_empire_of_jin"):create_character_from_template( "general", "3k_general_water", "mod_main_template_historical_sima_kui_water", false);
        -- 司马恂
        mod_character_add("mod_main_template_historical_sima_xun_water", "ep_faction_empire_of_jin", "3k_general_water");

        -- 将司马懿、司马孚、司马馗、司马恂设为司马防之子
        mod_make_child("3k_main_template_historical_sima_fang_hero_water", "ep_template_ancestral_sima_yi_runan");
        mod_make_child("3k_main_template_historical_sima_fang_hero_water", "3k_main_template_historical_sima_fu_hero_water"); 
        mod_make_child("3k_main_template_historical_sima_fang_hero_water", "mod_main_template_historical_sima_kui_water");
        mod_make_child("3k_main_template_historical_sima_fang_hero_water", "mod_main_template_historical_sima_xun_water");
        


        --NOTE T3
        -- 司马师
        mod_character_add("mod_template_historical_sima_shi_hero_earth", "ep_faction_empire_of_jin", "3k_general_earth");
        -- 司马昭
        mod_character_add("mod_template_historical_sima_zhao_hero_earth", "ep_faction_empire_of_jin", "3k_general_earth");
        -- 司马伷
        modify_sima_zhou = cm:modify_faction("ep_faction_empire_of_jin"):create_character_from_template( "general", "3k_general_fire", "mod_main_template_historical_sima_zhou_fire", false);
        query_sima_zhou = modify_sima_zhou:query_character();
        -- 司马骏
        mod_character_add("mod_main_template_historical_sima_jun_metal", "ep_faction_empire_of_jin", "3k_general_metal");
        -- 司马觐
        modify_sima_jin = cm:modify_faction("ep_faction_empire_of_jin"):create_character_from_template( "general", "3k_general_wood", "mod_main_template_historical_sima_jin_wood", false);
        query_sima_jin = modify_sima_jin:query_character();
        -- 司马干
        modify_sima_gan = cm:modify_faction("ep_faction_prince_of_pingyuan"):create_character_from_template( "general", "3k_general_metal", "mod_main_template_historical_sima_gan_hero_metal", false);
        query_sima_gan = modify_sima_gan:query_character();
        -- 司马辅
        mod_character_add("mod_main_template_historical_sima_fu_water", "ep_faction_empire_of_jin", "3k_general_water");
        -- 司马遂
        mod_character_add("mod_main_template_historical_sima_sui_wood", "ep_faction_empire_of_jin", "3k_general_wood");
        -- 司马绥 mod_main_template_historical_sima_sui_fanyang_water
        modify_sima_sui_fanyang = cm:modify_faction("ep_faction_empire_of_jin"):create_character_from_template( "general", "3k_general_water", "mod_main_template_historical_sima_sui_fanyang_water", false);


        -- 将司马师、司马昭、司马伷、司马干、司马骏设为司马懿之子
        mod_make_child("ep_template_ancestral_sima_yi_runan", "mod_template_historical_sima_shi_hero_earth");
        mod_make_child("ep_template_ancestral_sima_yi_runan", "mod_template_historical_sima_zhao_hero_earth"); 
        mod_make_child("ep_template_ancestral_sima_yi_runan", "mod_main_template_historical_sima_zhou_fire");
        mod_make_child("ep_template_ancestral_sima_yi_runan", "mod_main_template_historical_sima_gan_hero_metal");
        mod_make_child("ep_template_ancestral_sima_yi_runan", "mod_main_template_historical_sima_jun_metal");

        -- 设定司马辅为司马孚之子
        mod_make_child("3k_main_template_historical_sima_fu_hero_water", "mod_main_template_historical_sima_fu_water");
        
        -- 设定司马遂为司马恂之子
        mod_make_child("mod_main_template_historical_sima_xun_water", "mod_main_template_historical_sima_sui_wood");

        -- 设定司马绥为司马馗之子
        modify_sima_sui_fanyang:make_child_of(modify_sima_kui);

        --NOTE T4
        -- 司马略（司马馗孙、司马泰子） mod_main_template_historical_sima_lue_metal
        modify_sima_lue = cm:modify_faction("ep_faction_empire_of_jin"):create_character_from_template( "general", "3k_general_metal", "mod_main_template_historical_sima_lue_metal", false);
        query_sima_lue = modify_sima_lue:query_character();
        
        -- 司马缉
        mod_character_add("mod_main_template_historical_sima_ji_fire", "ep_faction_prince_of_zhongshan", "3k_general_fire");


        -- 设定司马炎、司马鉴、司马攸为司马昭之子
        mod_make_child("mod_template_historical_sima_zhao_hero_earth", "ep_template_ancestral_sima_yan_changsha");
        mod_make_child("mod_template_historical_sima_zhao_hero_earth", "ep_template_historical_sima_jian_hero_earth_lean");
        mod_make_child("mod_template_historical_sima_zhao_hero_earth", "ep_template_ancestral_sima_you");
        
        -- 设定司马觐为司马伷之子
        modify_sima_jin:make_child_of(modify_sima_zhou);
        
        -- 设定司马闳为司马辅之子
        mod_make_child("mod_main_template_historical_sima_fu_water", "ep_template_historical_sima_hong_hero_metal");

        -- 设定司马耽、司马缉为司马遂之子
        mod_make_child("mod_main_template_historical_sima_sui_wood", "ep_template_historical_sima_dan_hero_earth");
        mod_make_child("mod_main_template_historical_sima_sui_wood", "mod_main_template_historical_sima_ji_fire");


        -- 将旧版司马干转移至晋帝国
        -- 满伟
        modify_man_wei = cm:modify_faction("ep_faction_prince_of_pingyuan"):create_character_from_template( "general", "3k_general_water", "mod_main_template_historical_man_wei_water", false);
        modify_man_wei:apply_relationship_trigger_set(cm:query_character("ep_template_historical_sima_yong_hero_fire_prince"), "3k_main_relationship_trigger_set_event_negative_generic_extreme");
        local modify_initial_pingyuan_force = cm:modify_model():get_modify_military_force(cm:query_character("ep_template_historical_sima_gan_hero_metal"):military_force());
        modify_initial_pingyuan_force:add_existing_character_as_retinue(modify_man_wei, true);
        
        mod_character_add("ep_template_historical_sima_gan_hero_metal", "ep_faction_empire_of_jin", "3k_general_fire");


    --NOTE 司马缉（中山王）
        cm:modify_character("mod_main_template_historical_sima_ji_fire"):assign_faction_leader();
        
        -- 转移司马耽
        mod_character_add("ep_template_historical_sima_dan_hero_earth", "ep_faction_empire_of_jin", "3k_general_earth");
        mod_character_add("ep_template_historical_sima_dan_hero_earth", "ep_faction_prince_of_zhongshan", "3k_general_earth");


    --NOTE 司马亮（汝南王）/司马玷（长乐王）
        query_prince_of_changle = cm:query_faction("ep_faction_prince_of_changle");

        -- 长乐王，创建司马玷至长乐王并设置为派系领袖
        modify_sima_dian = cm:modify_faction("ep_faction_prince_of_changle"):create_character_from_template( "general", "3k_general_water", "mod_main_template_historical_sima_dian_water", false);
        query_sima_dian = modify_sima_dian:query_character();
        modify_sima_dian:assign_faction_leader();

        -- 长乐王，设司马玷置与长乐王派系初始成员的关系
        for i = 0, query_prince_of_changle:character_list():num_items() - 1 do
            local query_character = query_prince_of_changle:character_list():item_at(i);
            if query_character and not query_character:is_null_interface() and not query_character:is_dead() then
                modify_sima_dian:apply_relationship_trigger_set(query_character, "3k_main_relationship_trigger_set_event_positive_generic_extreme");
            end;
        end;

        -- 长乐王，创建苟晞至长乐王 mod_main_template_historical_gou_xi_fire
            modify_gou_xi = cm:modify_faction("ep_faction_prince_of_changle"):create_character_from_template( "general", "3k_general_fire", "mod_main_template_historical_gou_xi_fire", false);
            query_gou_xi = modify_gou_xi:query_character();

        -- 长乐王，设置苟晞与派系初始成员的关系
        for i = 0, query_prince_of_changle:character_list():num_items() - 1 do
            local query_character = query_prince_of_changle:character_list():item_at(i);
            if query_character and not query_character:is_null_interface() and not query_character:is_dead() then
                modify_gou_xi:apply_relationship_trigger_set(query_character, "3k_main_relationship_trigger_set_event_positive_generic_extreme");
            end;
        end;

        -- 长乐王，编辑苟晞特性、装备
        mod_remove_all_trait(query_gou_xi);
        modify_gou_xi:ceo_management():add_ceo("3k_ytr_ceo_trait_personality_vindictive");
        modify_gou_xi:ceo_management():add_ceo("3k_ytr_ceo_trait_personality_people_stern");
        modify_gou_xi:ceo_management():add_ceo("3k_main_ceo_trait_personality_ambitious");
        
        modify_gou_xi:ceo_management():remove_ceos("3k_main_ceo_career_generated_general_fire");
        modify_gou_xi:ceo_management():add_ceo("3k_main_ceo_career_historical_gongsun_zan");

        -- 长乐王，设置苟晞为尚书令
        modify_gou_xi:assign_to_post("3k_main_court_offices_minister_earth");

        -- 长乐王，编辑军队
        found_pos, x, y = query_prince_of_changle:get_valid_spawn_location_in_region("3k_main_anping_capital", false);
        if found_pos then
            cm:create_force_with_existing_general(query_gou_xi:command_queue_index(), "ep_faction_prince_of_changle", "", "3k_main_anping_capital", x, y, "gouxi_force", nil, 100);
        end;

        -- 汝南王，转移司马祐至汝南王，并设置为司马矩之子
        mod_character_add("ep_template_historical_sima_you_hero_wood", "ep_faction_prince_of_runan", "3k_general_wood");
        mod_make_child("ep_template_historical_sima_ju_hero_earth", "ep_template_historical_sima_you_hero_wood");
        
        -- 汝南王，自动完成初始任务
        local m_faction_prince_of_runan = cm:modify_faction("ep_faction_prince_of_runan")
        m_faction_prince_of_runan:complete_custom_mission("ep_mission_introduction_destroy_army_sima_liang")


    --NOTE 司马矩 ep_template_historical_sima_ju_hero_earth
        
        modify_sima_ju = cm:modify_character("ep_template_historical_sima_ju_hero_earth");
        
        -- 编辑性格
        modify_sima_ju:ceo_management():remove_ceos("ep_ceo_career_historical_sima_ju");
        modify_sima_ju:ceo_management():add_ceo("3k_main_ceo_career_generated_minister_earth");


    --NOTE 司马冏（齐王） ep_template_historical_sima_jiong_hero_earth_prince
        
        query_prince_of_qi = cm:query_faction("ep_faction_prince_of_qi");
        
        -- 设定为司马几（燕王）之父
        mod_make_child("ep_template_historical_sima_jiong_hero_earth_prince", "ep_template_historical_sima_ji_hero_fire_yan");

        -- 设定与和燕王同盟关系
        diplomacy_manager:apply_automatic_deal_between_factions("ep_faction_prince_of_qi", "ep_faction_prince_of_yan", "data_defined_situation_create_alliance_no_conditions",true);

    --NOTE 王豹

        mod_character_add("ep_template_historical_wang_bao_hero_wood", "ep_faction_empire_of_jin", "3k_general_wood");
        mod_kill_character("ep_template_historical_wang_bao_hero_wood");        
        modify_wang_bao = cm:modify_faction("ep_faction_prince_of_qi"):create_character_from_template( "general", "3k_general_wood", "ep_template_historical_wang_bao_hero_wood", false);
        query_wang_bao = modify_wang_bao:query_character();

        -- 编辑特性
        mod_remove_all_trait(query_wang_bao);
        modify_wang_bao:ceo_management():add_ceo("3k_main_ceo_trait_personality_perceptive"); -- 锐目如炬
        modify_wang_bao:ceo_management():add_ceo("3k_main_ceo_trait_personality_dutiful"); -- 尽职尽责
        modify_wang_bao:ceo_management():add_ceo("3k_main_ceo_trait_personality_ambitious"); -- 雄心勃勃

        -- 编辑装备（天之盾）
        cdir_events_manager:add_or_remove_ceo_from_faction(query_wang_bao:faction():name(), "ep_ancillary_armour_heavy_armour_wood_unique", true);
        ancillaries:equip_ceo_on_character(query_wang_bao, "ep_ancillary_armour_heavy_armour_wood_unique", "3k_main_ceo_category_ancillary_armour");

        -- 设定王豹与齐王派系初始成员关系
        
        for i = 0, query_prince_of_qi:character_list():num_items() - 1 do
            local query_character = query_prince_of_qi:character_list():item_at(i);
            if query_character and not query_character:is_null_interface() and not query_character:is_dead() then
                modify_wang_bao:apply_relationship_trigger_set(query_character, "3k_main_relationship_trigger_set_event_positive_generic_extreme");
            end;
        end;

    --NOTE 祖逖 mod_main_template_historical_zu_di_fire
        modify_zu_ti = cm:modify_faction("ep_faction_prince_of_qi"):create_character_from_template( "general", "3k_general_fire", "mod_main_template_historical_zu_di_fire", false);
        query_zu_ti = modify_zu_ti:query_character();
        
        
        -- 编辑特性
        mod_remove_all_trait(query_zu_ti);
        modify_zu_ti:ceo_management():add_ceo("3k_main_ceo_trait_personality_brave");
        modify_zu_ti:ceo_management():add_ceo("3k_main_ceo_trait_personality_loyal");
        modify_zu_ti:ceo_management():add_ceo("3k_main_ceo_trait_personality_dutiful");
        
        modify_zu_ti:ceo_management():remove_ceos("3k_main_ceo_career_generated_general_fire");
        modify_zu_ti:ceo_management():add_ceo("3k_main_ceo_career_historical_taishi_ci");
          
        -- 编辑装备(裂胆槊/火凤革甲)
        cdir_events_manager:add_or_remove_ceo_from_faction(query_zu_ti:faction():name(), "3k_main_ancillary_weapon_ma_su_faction", true);
        ancillaries:equip_ceo_on_character(query_zu_ti, "3k_main_ancillary_weapon_ma_su_faction", "3k_main_ceo_category_ancillary_weapon");

        cdir_events_manager:add_or_remove_ceo_from_faction(query_zu_ti:faction():name(), "3k_main_ancillary_armour_medium_armour_fire_unique", true);
        ancillaries:equip_ceo_on_character(query_zu_ti, "3k_main_ancillary_armour_medium_armour_fire_unique", "3k_main_ceo_category_ancillary_armour");
        
        -- 编辑军队
        if not query_prince_of_qi:is_human() then
            found_pos, x, y = query_prince_of_qi:get_valid_spawn_location_in_region("3k_main_taishan_resource_1", false);        
            if found_pos then        
                cm:create_force_with_existing_general(query_wang_bao:command_queue_index(), "ep_faction_prince_of_qi", "", "3k_main_taishan_resource_1", x, y, "wangbao_force", nil, 100);
                local modify_wang_bao_force = cm:modify_model():get_modify_military_force(query_wang_bao:military_force());
                
                -- 添加祖逖
                modify_wang_bao_force:add_existing_character_as_retinue(modify_zu_ti, true);
            end;
        end;

    --NOTE 司马畅（顺阳王）/司马歆（涪陵王*）
        mod_character_add("ep_template_historical_sima_xin_hero_fire", "ep_faction_prince_of_fuling", "3k_general_fire");
        cm:modify_character("ep_template_historical_sima_xin_hero_fire"):assign_faction_leader();

        -- 设定司马骏和司马畅、司马歆的父子关系
        mod_make_child("mod_main_template_historical_sima_jun_metal", "ep_template_historical_sima_chang_hero_wood");
        mod_make_child("mod_main_template_historical_sima_jun_metal", "ep_template_historical_sima_xin_hero_fire");

        -- 设定顺阳王与涪陵王同盟
        diplomacy_manager:apply_automatic_deal_between_factions("ep_faction_prince_of_shunyang", "ep_faction_prince_of_fuling", "data_defined_situation_create_alliance_no_conditions",true);


    --NOTE 司马允（庐江王，史实为淮南王） ep_template_historical_sima_yun_hero_metal

        query_prince_of_lujiang = cm:query_faction("ep_faction_prince_of_lujiang");
        query_prince_of_huainan = cm:query_faction("ep_faction_prince_of_huainan");

        if cm:query_faction("ep_faction_prince_of_lujiang"):is_human() then
            modify_sima_yun = cm:modify_faction("ep_faction_prince_of_lujiang"):create_character_from_template( "general", "3k_general_metal", "ep_template_historical_sima_yun_hero_metal", false);
            query_sima_yun = modify_sima_yun:query_character();
            modify_sima_yun:assign_faction_leader();

            mod_remove_all_trait(query_sima_yun);
            modify_sima_yun:ceo_management():add_ceo("3k_main_ceo_trait_personality_charismatic"); -- 富有魅力
            modify_sima_yun:ceo_management():add_ceo("3k_main_ceo_trait_personality_loyal"); -- 忠贞不二
            modify_sima_yun:ceo_management():add_ceo("3k_main_ceo_trait_personality_charitable"); -- 义结天下
            
            modify_sima_yun:ceo_management():remove_ceos("3k_main_ceo_career_generated_general_metal");
            modify_sima_yun:ceo_management():add_ceo("3k_dlc05_ceo_career_historical_han_dang"); -- 忠义笃诚

            
            -- 周访 mod_main_template_historical_zhou_fang_metal
            modify_zhou_fang = cm:modify_faction("ep_faction_prince_of_lujiang"):create_character_from_template( "general", "3k_general_metal", "mod_main_template_historical_zhou_fang_metal", false);
            query_zhou_fang = modify_zhou_fang:query_character();
            
            mod_remove_all_trait(query_zhou_fang);
            modify_zhou_fang:ceo_management():add_ceo("3k_ytr_ceo_trait_personality_stalwart"); -- 坚贞善友
            modify_zhou_fang:ceo_management():add_ceo("3k_main_ceo_trait_personality_disciplined"); -- 令行禁止
            modify_zhou_fang:ceo_management():add_ceo("3k_main_ceo_trait_personality_brave"); -- 英勇无畏
            
            modify_zhou_fang:ceo_management():remove_ceos("3k_main_ceo_career_generated_general_metal");
            modify_zhou_fang:ceo_management():add_ceo("3k_main_ceo_career_historical_huangfu_song"); -- 镇国宿将
            
            
            -- 设置与周访关系
            modify_sima_yun:apply_relationship_trigger_set(query_zhou_fang, "3k_main_relationship_trigger_set_event_positive_generic_extreme");

            -- 设定与秦王、汉王同盟
            diplomacy_manager:apply_automatic_deal_between_factions("ep_faction_prince_of_lujiang", "ep_faction_prince_of_qin", "data_defined_situation_create_alliance_no_conditions",true);
            diplomacy_manager:apply_automatic_deal_between_factions("ep_faction_prince_of_lujiang", "ep_faction_prince_of_han", "data_defined_situation_join_alliance_proposer", true);

        else
            mod_set_region_manager("3k_main_lujiang_capital","ep_faction_prince_of_huainan");
            mod_set_region_manager("3k_main_lujiang_resource_1","ep_faction_prince_of_huainan");
            mod_set_region_manager("3k_main_lujiang_resource_2","ep_faction_prince_of_huainan");

            modify_sima_yun = cm:modify_faction("ep_faction_prince_of_huainan"):create_character_from_template( "general", "3k_general_metal", "ep_template_historical_sima_yun_hero_metal", false);
            query_sima_yun = modify_sima_yun:query_character();
            modify_sima_yun:assign_faction_leader();

            mod_remove_all_trait(query_sima_yun);
            modify_sima_yun:ceo_management():add_ceo("3k_main_ceo_trait_personality_charismatic"); -- 富有魅力
            modify_sima_yun:ceo_management():add_ceo("3k_main_ceo_trait_personality_loyal"); -- 忠贞不二
            modify_sima_yun:ceo_management():add_ceo("3k_main_ceo_trait_personality_charitable"); -- 义结天下
            
            modify_sima_yun:ceo_management():remove_ceos("3k_main_ceo_career_generated_general_metal");
            modify_sima_yun:ceo_management():add_ceo("3k_dlc05_ceo_career_historical_han_dang"); -- 忠义笃诚

            
            -- 周访 mod_main_template_historical_zhou_fang_metal
            modify_zhou_fang = cm:modify_faction("ep_faction_prince_of_huainan"):create_character_from_template( "general", "3k_general_metal", "mod_main_template_historical_zhou_fang_metal", false);
            query_zhou_fang = modify_zhou_fang:query_character();
            
            mod_remove_all_trait(query_zhou_fang);
            modify_zhou_fang:ceo_management():add_ceo("3k_ytr_ceo_trait_personality_stalwart"); -- 坚贞善友
            modify_zhou_fang:ceo_management():add_ceo("3k_main_ceo_trait_personality_disciplined"); -- 令行禁止
            modify_zhou_fang:ceo_management():add_ceo("3k_main_ceo_trait_personality_brave"); -- 英勇无畏
            
            modify_zhou_fang:ceo_management():remove_ceos("3k_main_ceo_career_generated_general_metal");
            modify_zhou_fang:ceo_management():add_ceo("3k_main_ceo_career_historical_huangfu_song"); -- 镇国宿将
            

            -- 编辑军队
            found_pos, x, y = query_prince_of_huainan:get_valid_spawn_location_in_region("3k_main_lujiang_capital", false);        
            if found_pos then        
                cm:create_force_with_existing_general(query_sima_yun:command_queue_index(), "ep_faction_prince_of_huainan", "", "3k_main_lujiang_capital", x, y, "simayun_force", nil, 100);
                local modify_sima_yun_force = cm:modify_model():get_modify_military_force(query_sima_yun:military_force());
                
                -- 添加周访
                modify_sima_yun_force:add_existing_character_as_retinue(modify_zhou_fang, true);
            end;



            -- 设置与周访关系
            modify_sima_yun:apply_relationship_trigger_set(query_zhou_fang, "3k_main_relationship_trigger_set_event_positive_generic_extreme");

            -- 设定与秦王、汉王同盟，移除庐江王势力
            diplomacy_manager:apply_automatic_deal_between_factions("ep_faction_prince_of_huainan", "ep_faction_prince_of_qin", "data_defined_situation_create_alliance_no_conditions",true)
            diplomacy_manager:apply_automatic_deal_between_factions("ep_faction_prince_of_huainan", "ep_faction_prince_of_han", "data_defined_situation_join_alliance_proposer", true)
            diplomacy_manager:apply_automatic_deal_between_factions("ep_faction_prince_of_huainan", "ep_faction_prince_of_lujiang", "data_defined_situation_confederate_recipient_no_requirements", true)
        end;

        -- 设定与司马伦关系
        modify_sima_yun:apply_relationship_trigger_set(cm:query_character("ep_template_historical_sima_lun_hero_earth_prince"), "3k_main_relationship_trigger_set_event_negative_generic_extreme");

        -- 设定为司马炎之子
        -- 设定为司马迪之父
        mod_make_child("ep_template_ancestral_sima_yan_changsha", "ep_template_historical_sima_yun_hero_metal");
        mod_make_child("ep_template_historical_sima_yun_hero_metal", "ep_template_historical_sima_di_hero_water");

        -- 转移宋微至晋帝国
        mod_character_add("ep_template_historical_song_wei_hero_earth", "ep_faction_empire_of_jin", "3k_general_earth");



    --NOTE 司马郁（秦王）
        mod_character_add("mod_main_template_historical_sima_yu_wood", "ep_faction_prince_of_qin", "3k_general_wood");
        cm:modify_character("mod_main_template_historical_sima_yu_wood"):assign_faction_leader();

        -- 设定为司马允之子
        mod_make_child("ep_template_historical_sima_yun_hero_metal", "mod_main_template_historical_sima_yu_wood");

 
    --NOTE 司马炽（豫章王） mod_main_template_historical_sima_chi_earth
        modify_sima_chi = cm:modify_faction("ep_faction_prince_of_yuzhang"):create_character_from_template( "general", "3k_general_earth", "mod_main_template_historical_sima_chi_earth", false);
        query_sima_chi = modify_sima_chi:query_character();
        modify_sima_chi:assign_faction_leader();

        -- 设定为司马炎之子
        mod_make_child("ep_template_ancestral_sima_yan_changsha", "mod_main_template_historical_sima_chi_earth");
        mod_CEO_equip("mod_main_template_historical_sima_chi_earth", "ep_ancillary_armour_medium_armour_earth_extraordinary", "3k_main_ceo_category_ancillary_armour");

        -- 将旧版司马炽转移至晋帝国
        mod_character_add("ep_template_historical_sima_chi_hero_water", "ep_faction_empire_of_jin", "3k_general_fire");


    --NOTE 司马睿（琅琊王） mod_main_template_historical_sima_rui_earth
        
        query_prince_of_langya = cm:query_faction("ep_faction_prince_of_langye");
        
        modify_sima_rui_langya = cm:modify_faction("ep_faction_prince_of_langye"):create_character_from_template( "general", "3k_general_earth", "mod_main_template_historical_sima_rui_earth", false);
        query_sima_rui_langya = modify_sima_rui_langya:query_character();
        modify_sima_rui_langya:assign_faction_leader();

        -- 设定为司马觐之子
        modify_sima_rui_langya:make_child_of(modify_sima_jin);

        -- 将旧版司马睿转移至晋帝国
        mod_character_add("ep_template_historical_sima_rui_hero_earth_langye", "ep_faction_empire_of_jin", "3k_general_fire");

        -- 编辑特性
        mod_remove_all_trait(query_sima_rui_langya);
        modify_sima_rui_langya:ceo_management():add_ceo("3k_main_ceo_trait_personality_trusting"); -- 言听计从
        modify_sima_rui_langya:ceo_management():add_ceo("3k_main_ceo_trait_personality_indecisive"); -- 优柔寡断
        modify_sima_rui_langya:ceo_management():add_ceo("3k_main_ceo_trait_personality_cowardly"); -- 暗弱无断
        
        modify_sima_rui_langya:ceo_management():remove_ceos("3k_main_ceo_career_generated_governor_earth");
        modify_sima_rui_langya:ceo_management():add_ceo("3k_dlc06_ceo_career_historical_shi_wei"); -- 即鹿无虞


        
    --NOTE 琅琊王氏
        
        -- 王览 3k_main_template_historical_wang_lan_hero_water
        mod_character_add("3k_main_template_historical_wang_lan_hero_water", "ep_faction_empire_of_jin", "3k_general_earth");
        
        -- 王裁 mod_main_template_historical_wang_cai_metal
        modify_wang_cai = cm:modify_faction("ep_faction_prince_of_langye"):create_character_from_template( "general", "3k_general_metal", "mod_main_template_historical_wang_cai_metal", false);
        query_wang_cai = modify_wang_cai:query_character();
        
        -- 王导 mod_main_template_historical_wang_dao_water
        modify_wang_dao = cm:modify_faction("ep_faction_prince_of_langye"):create_character_from_template( "general", "3k_general_water", "mod_main_template_historical_wang_dao_water", false);
        query_wang_dao = modify_wang_dao:query_character();
        
        -- 编辑军队
        found_pos, x, y = query_prince_of_langya:get_valid_spawn_location_in_region("3k_main_langye_capital", false);        
        if found_pos then        
            cm:create_force_with_existing_general(query_sima_rui_langya:command_queue_index(), "ep_faction_prince_of_langye", "", "3k_main_langye_capital", x, y, "simarui_force", nil, 100);
            local modify_sima_rui_force = cm:modify_model():get_modify_military_force(query_sima_rui_langya:military_force());
            
            -- 添加王裁
            modify_sima_rui_force:add_existing_character_as_retinue(modify_wang_cai, true);
        end;        
        



    --NOTE 司马柬（苍梧王，史实为南阳王。游戏时空与司马模调换封地）
        mod_character_add("ep_template_historical_sima_jian_hero_water_qin", "ep_faction_prince_of_cangwu", "3k_general_metal");
        cm:modify_character("ep_template_historical_sima_jian_hero_water_qin"):assign_faction_leader();

        -- 设定为司马炎之子
        mod_make_child("ep_template_ancestral_sima_yan_changsha", "ep_template_historical_sima_jian_hero_water_qin");

        -- 设定与汝南王同盟
        diplomacy_manager:apply_automatic_deal_between_factions("ep_faction_prince_of_runan", "ep_faction_prince_of_cangwu", "data_defined_situation_create_alliance_no_conditions",true);


    --NOTE 司马蕤（东莱王）
        cm:modify_character("ep_template_historical_sima_rui_hero_fire"):assign_faction_leader();

        -- 设定为司马攸之子
        mod_make_child("ep_template_ancestral_sima_you", "ep_template_historical_sima_rui_hero_fire");


    --NOTE 李含 ep_template_historical_li_han_hero_earth
    
        modify_li_han = cm:modify_character("ep_template_historical_li_han_hero_earth");
        
        -- 转移至秦王
        modify_li_han:move_to_faction_and_make_recruited("ep_faction_empire_of_qin");

        -- 编辑特性
        modify_li_han:ceo_management():remove_ceos("ep_ceo_career_historical_li_han");
        modify_li_han:ceo_management():add_ceo("3k_main_ceo_career_generated_minister_earth");


    --NOTE 皇甫商 ep_template_historical_huangfu_shang_hero_metal
        -- 备忘：转移至司马冏
        mod_character_add("ep_template_historical_huangfu_shang_hero_metal", "ep_faction_empire_of_qi", "3k_general_metal");
        modify_huangfu_shang = cm:modify_character("ep_template_historical_huangfu_shang_hero_metal");
        
        -- 编辑特性
        modify_huangfu_shang:ceo_management():remove_ceos("ep_ceo_career_historical_huangfu_shang");
        modify_huangfu_shang:ceo_management():add_ceo("3k_main_ceo_career_generated_envoy_metal"); -- 研桑心计


    --NOTE 司马伦 ep_template_historical_sima_fu_hero_earth_zhao
        query_prince_of_zhao = cm:query_faction("ep_faction_prince_of_zhao");


    --NOTE 孙秀 ep_template_historical_sun_xiu_hero_water
        
        -- 清理旧版孙秀
        mod_character_add("ep_template_historical_sun_xiu_hero_water", "ep_faction_empire_of_jin", "3k_general_water");
        mod_kill_character("ep_template_historical_sun_xiu_hero_water");

        -- 创建孙秀至赵王司马伦
        modify_sun_xiu = cm:modify_faction("ep_faction_prince_of_zhao"):create_character_from_template( "general", "3k_general_water", "ep_template_historical_sun_xiu_hero_water", false);
        query_sun_xiu = modify_sun_xiu:query_character();

        -- 设置与司马伦关系
        cm:modify_character("ep_template_historical_sima_lun_hero_earth_prince"):apply_relationship_trigger_set(query_sun_xiu, "3k_main_relationship_trigger_set_event_positive_generic_extreme");

        -- 设置与司马馥关系
        modify_sun_xiu:apply_relationship_trigger_set(cm:query_character("ep_template_historical_sima_fu_hero_earth_zhao"), "3k_main_relationship_trigger_set_event_positive_generic_extreme");

        -- 设置与司马虔关系
        modify_sun_xiu:apply_relationship_trigger_set(cm:query_character("ep_template_historical_sima_qian_hero_water"), "3k_main_relationship_trigger_set_event_positive_generic_extreme");

        -- 设置与司马诩关系
        modify_sun_xiu:apply_relationship_trigger_set(cm:query_character("ep_template_historical_sima_xu_hero_metal"), "3k_main_relationship_trigger_set_event_positive_generic_extreme");

        -- 编辑特性
        mod_remove_all_trait(query_sun_xiu);
        modify_sun_xiu:ceo_management():add_ceo("3k_main_ceo_trait_personality_deceitful");
        modify_sun_xiu:ceo_management():add_ceo("3k_main_ceo_trait_personality_cruel");
        modify_sun_xiu:ceo_management():add_ceo("3k_main_ceo_trait_personality_superstitious");
        
        modify_sun_xiu:ceo_management():remove_ceos("ep_ceo_career_historical_sun_xiu");
        modify_sun_xiu:ceo_management():add_ceo("3k_main_ceo_career_historical_liu_zhang");

        -- 编辑军队
        if not query_prince_of_zhao:is_human() then
            found_pos, x, y = query_prince_of_zhao:get_valid_spawn_location_in_region("3k_main_weijun_capital", false);        
            if found_pos then        
                cm:create_force_with_existing_general(query_sun_xiu:command_queue_index(), "ep_faction_prince_of_zhao", "", "3k_main_weijun_capital", x, y, "sunxiu_force", nil, 100);
                local modify_sun_xiu_force = cm:modify_model():get_modify_military_force(query_sun_xiu:military_force());
            end;
        end;


    --NOTE 陆机/陆云 mod_main_template_historical_lu_ji_hero_water

        -- 清理旧版“陆济”
        mod_character_add("ep_template_historical_lu_ji_hero_water", "ep_faction_empire_of_jin", "3k_general_water");
        mod_kill_character("ep_template_historical_lu_ji_hero_water");

        -- 清理旧版“陆允”
        mod_character_add("ep_template_historical_lu_yun_hero_fire", "ep_faction_empire_of_jin", "3k_general_fire");
        mod_kill_character("ep_template_historical_lu_yun_hero_fire");

        -- 创建陆机至吴王司马晏
        modify_lu_ji = cm:modify_faction("ep_faction_prince_of_wu"):create_character_from_template( "general", "3k_general_water", "mod_main_template_historical_lu_ji_hero_water", false);
        query_lu_ji = modify_lu_ji:query_character();

        -- 设置与司马晏关系
        cm:modify_character("ep_template_historical_sima_yan_hero_metal"):apply_relationship_trigger_set(query_lu_ji, "3k_main_relationship_trigger_set_event_positive_generic_extreme");


    --NOTE 曹奂（陈留王） mod_main_template_historical_cao_huan_hero_earth

        modify_cao_huan = cm:modify_faction("ep_faction_prince_of_chenliu"):create_character_from_template( "general", "3k_general_earth", "mod_main_template_historical_cao_huan_hero_earth", false);
        query_cao_huan = modify_cao_huan:query_character();
        
        mod_character_add("ep_template_historical_cao_huan_hero_earth", "ep_faction_empire_of_jin", "3k_general_earth");
        mod_kill_character("ep_template_historical_cao_huan_hero_earth");

        modify_cao_huan:assign_faction_leader();

        -- 编辑特性
        mod_remove_all_trait(query_cao_huan);
        modify_cao_huan:ceo_management():add_ceo("3k_ytr_ceo_trait_personality_land_powerful");
        modify_cao_huan:ceo_management():add_ceo("3k_main_ceo_trait_personality_charismatic");
        modify_cao_huan:ceo_management():add_ceo("3k_main_ceo_trait_personality_humble");
        
        modify_cao_huan:ceo_management():remove_ceos("3k_main_ceo_career_generated_governor_earth");
        modify_cao_huan:ceo_management():add_ceo("3k_main_ceo_career_historical_guan_jing");

        -- 清理派系其他初始成员
        query_prince_of_chenliu = cm:query_faction("ep_faction_prince_of_chenliu");
        for i = 0, query_prince_of_chenliu:character_list():num_items() - 1 do
            local query_character = query_prince_of_chenliu:character_list():item_at(i);
            if query_character and not query_character:is_null_interface() and not query_character:is_dead() then
                if not query_character:is_faction_leader() then
                    cm:modify_character(query_character):move_to_faction_and_make_recruited("ep_faction_empire_of_jin");
                    cm:modify_character(query_character):kill_character(false);
                end;
            end;
        end;

        -- 设置初始成员A
        modify_chenliu_char_a = cm:modify_faction("ep_faction_prince_of_chenliu"):create_character_from_template( "general", "3k_general_metal", "3k_main_template_generic_metal_minister_legendary_m_hero", false);
        modify_chenliu_char_a:assign_to_post("3k_main_court_offices_minister_earth");
        modify_cao_huan:apply_relationship_trigger_set(modify_chenliu_char_a:query_character(), "3k_main_relationship_trigger_set_event_positive_generic_extreme");

        -- 设置初始成员B
        modify_chenliu_char_b = cm:modify_faction("ep_faction_prince_of_chenliu"):create_character_from_template( "general", "3k_general_water", "3k_main_template_generic_water_agent_legendary_f_hero", false);
        modify_cao_huan:apply_relationship_trigger_set(modify_chenliu_char_b:query_character(), "3k_main_relationship_trigger_set_event_positive_generic_extreme");

        -- 设置初始成员C
        modify_chenliu_char_c = cm:modify_faction("ep_faction_prince_of_chenliu"):create_character_from_template( "general", "3k_general_fire", "3k_main_template_generic_fire_general_legendary_m_hero", false);
        modify_chenliu_char_c:add_experience(50000, 0)

        -- 设置军队，并让A和B加入

        found_pos, x, y = query_prince_of_chenliu:get_valid_spawn_location_in_region("3k_main_chenjun_resource_2", false);        
        if found_pos then        
            cm:create_force_with_existing_general(query_cao_huan:command_queue_index(), "ep_faction_prince_of_chenliu", "", "3k_main_chenjun_resource_2", x, y, "caohuan_force", nil, 100);
            local modify_cao_huan_force = cm:modify_model():get_modify_military_force(query_cao_huan:military_force());
            
            -- 添加随机将领A和B
            modify_cao_huan_force:add_existing_character_as_retinue(modify_chenliu_char_a, true);
            modify_cao_huan_force:add_existing_character_as_retinue(modify_chenliu_char_b, true);
        end;
        

        -- 设置与司马繇的关系
        modify_cao_huan:apply_relationship_trigger_set(cm:query_character("ep_template_historical_sima_yao_hero_wood_dongan"), "3k_main_relationship_trigger_set_event_positive_generic_extreme");

        -- 设置与司马亮的关系
        modify_cao_huan:apply_relationship_trigger_set(cm:query_character("ep_template_historical_sima_liang_hero_wood_prince"), "3k_main_relationship_trigger_set_event_positive_generic_extreme");


    --NOTE 张华（司空） ep_template_historical_zhang_hua_hero_water

        query_empire_of_jin = cm:query_faction("ep_faction_empire_of_jin");

        cm:modify_character("ep_template_historical_liang_shi_hero_earth"):assign_faction_leader();
        mod_kill_character("ep_template_historical_zhang_hua_hero_water");
        modify_zhang_hua = cm:modify_faction("ep_faction_empire_of_jin"):create_character_from_template( "general", "3k_general_water", "ep_template_historical_zhang_hua_hero_water", false);
        query_zhang_hua = modify_zhang_hua:query_character();
        modify_zhang_hua:assign_faction_leader();
        
        -- 编辑特性
        mod_remove_all_trait(query_zhang_hua);
        modify_zhang_hua:ceo_management():add_ceo("3k_ytr_ceo_trait_personality_heaven_selfless");
        modify_zhang_hua:ceo_management():add_ceo("3k_main_ceo_trait_personality_clever");
        modify_zhang_hua:ceo_management():add_ceo("3k_ytr_ceo_trait_personality_heaven_creative");

        -- 编辑装备(北军校尉)
        cdir_events_manager:add_or_remove_ceo_from_faction(query_zhang_hua:faction():name(), "3k_dlc07_ancillary_follower_northern_army_captain", true);
        ancillaries:equip_ceo_on_character(query_zhang_hua, "3k_dlc07_ancillary_follower_northern_army_captain", "3k_main_ceo_category_ancillary_follower");

        -- 设定与司马伦关系
        modify_zhang_hua:apply_relationship_trigger_set(cm:query_character("ep_template_historical_sima_lun_hero_earth_prince"), "3k_main_relationship_trigger_set_event_negative_generic_extreme");


    --NOTE 马隆 mod_main_template_historical_ma_long_metal
        modify_ma_long = cm:modify_faction("ep_faction_empire_of_jin"):create_character_from_template( "general", "3k_general_metal", "mod_main_template_historical_ma_long_metal", false);
        query_ma_long = modify_ma_long:query_character();        
        modify_ma_long:assign_to_post("3k_main_court_offices_minister_earth");

        -- 编辑特性
        mod_remove_all_trait(query_ma_long);
        modify_ma_long:ceo_management():add_ceo("3k_ytr_ceo_trait_personality_land_composed"); -- 沉着冷静
        modify_ma_long:ceo_management():add_ceo("3k_main_ceo_trait_personality_determined"); -- 心若磐石
        modify_ma_long:ceo_management():add_ceo("3k_main_ceo_trait_personality_distinguished"); -- 名满天下
        
        modify_ma_long:ceo_management():remove_ceos("3k_main_ceo_career_generated_governor_metal");
        modify_ma_long:ceo_management():add_ceo("ep_ceo_career_historical_shi_chao");        

        cdir_events_manager:add_or_remove_ceo_from_faction(query_ma_long:faction():name(), "3k_dlc07_ancillary_follower_northern_army_captain", true);
        ancillaries:equip_ceo_on_character(query_ma_long, "3k_dlc07_ancillary_follower_northern_army_captain", "3k_main_ceo_category_ancillary_follower");

        -- 设定与张华关系
        modify_ma_long:apply_relationship_trigger_set(query_zhang_hua, "3k_main_relationship_trigger_set_event_positive_generic_extreme");

        -- 设定与张轨关系
        modify_ma_long:apply_relationship_trigger_set(query_zhang_hua, "3k_main_relationship_trigger_set_event_positive_generic_extreme");

        -- 编辑军队
        found_pos, x, y = query_empire_of_jin:get_valid_spawn_location_in_region("3k_main_luoyang_capital", false);        
        if found_pos then        
            cm:create_force_with_existing_general(query_zhang_hua:command_queue_index(), "ep_faction_empire_of_jin", "", "3k_main_luoyang_capital", x, y, "zhanghua_force", nil, 100);
            local modify_zhang_hua_force = cm:modify_model():get_modify_military_force(query_zhang_hua:military_force());
            
            -- 添加马隆
            modify_zhang_hua_force:add_existing_character_as_retinue(modify_ma_long, true);
        end;        
        


    --NOTE 卫瓘（司空）
        --虎牢关、濝关、梁县（洛阳）、虎牢关
        mod_set_region_manager("3k_dlc06_hangu_pass","ep_faction_duke_of_lanling")
        mod_set_region_manager("3k_dlc06_qi_pass","ep_faction_duke_of_lanling")
        mod_set_region_manager("3k_dlc06_hulao_pass","ep_faction_duke_of_lanling")
        mod_set_region_manager("3k_main_chenjun_resource_3","ep_faction_duke_of_lanling")  


    --NOTE 卫瓘 ep_template_historical_wei_guan_hero_water
        
        -- 清理旧版卫瓘
        mod_character_add("ep_template_historical_wei_guan_hero_water", "ep_faction_empire_of_jin", "3k_general_water");
        mod_kill_character("ep_template_historical_wei_guan_hero_water");
        
        -- 创建卫瓘
        modify_wei_guan = cm:modify_faction("ep_faction_duke_of_lanling"):create_character_from_template( "general", "3k_general_water", "ep_template_historical_wei_guan_hero_water", false);
        query_wei_guan = modify_wei_guan:query_character();
        modify_wei_guan:assign_faction_leader();
        
        -- 编辑特性
        mod_remove_all_trait(query_wei_guan);
        modify_wei_guan:ceo_management():add_ceo("3k_main_ceo_trait_personality_dutiful");
        modify_wei_guan:ceo_management():add_ceo("3k_main_ceo_trait_personality_honourable");
        modify_wei_guan:ceo_management():add_ceo("3k_main_ceo_trait_personality_artful");

        -- 设定与司马亮关系
        modify_wei_guan:apply_relationship_trigger_set(cm:query_character("ep_template_historical_sima_liang_hero_wood_prince"), "3k_main_relationship_trigger_set_event_positive_generic_extreme");

        -- 设定与司马玮关系
        modify_wei_guan:apply_relationship_trigger_set(cm:query_character("ep_template_historical_sima_wei_hero_fire_prince"), "3k_main_relationship_trigger_set_event_negative_generic_extreme");


        query_duke_of_lanling = cm:query_faction("ep_faction_duke_of_lanling");
        local modify_initial_lanling_force = cm:modify_model():get_modify_military_force(cm:query_character("ep_template_historical_jin_yu_hero_fire"):military_force());


    --NOTE 潘岳 mod_main_template_historical_pan_yue_water

        modify_pan_yue = cm:modify_faction("ep_faction_duke_of_lanling"):create_character_from_template( "general", "3k_general_water", "mod_main_template_historical_pan_yue_water", false);
        query_pan_yue = modify_pan_yue:query_character();

        -- 编辑特性
        mod_remove_all_trait(query_pan_yue);
        modify_pan_yue:ceo_management():add_ceo("3k_main_ceo_trait_personality_modest"); -- 温柔尔雅
        modify_pan_yue:ceo_management():add_ceo("3k_main_ceo_trait_physical_handsome"); -- 容姿焕发
        modify_pan_yue:ceo_management():add_ceo("3k_main_ceo_trait_physical_beautiful"); -- 俊逸清秀
        
        modify_pan_yue:ceo_management():remove_ceos("3k_main_ceo_career_generated_envoy_water");
        modify_pan_yue:ceo_management():add_ceo("3k_dlc04_ceo_career_historical_chen_gui_hanyu"); -- 才华洋溢

        -- 设定与贾谧关系
        modify_pan_yue:apply_relationship_trigger_set(cm:query_character("ep_template_historical_jia_mi_hero_fire"), "3k_main_relationship_trigger_set_event_positive_generic_extreme");

        -- 设定与裴楷关系（裴楷待添加）
        
        -- 设定与石崇关系（石崇待添加）
        
        -- 设定与陆机关系
        modify_pan_yue:apply_relationship_trigger_set(query_lu_ji, "3k_main_relationship_trigger_set_event_positive_generic_extreme");

        -- 设定与左思关系（左思待添加）
        
        -- 设定与刘琨关系（刘琨待添加）
        
        -- 设定与孙秀关系
        modify_pan_yue:apply_relationship_trigger_set(query_sun_xiu, "3k_main_relationship_trigger_set_event_negative_generic_extreme");



    --NOTE 刘沈（太保掾） mod_main_template_historical_liu_shen_metal
        modify_liu_shen = cm:modify_faction("ep_faction_duke_of_lanling"):create_character_from_template( "general", "3k_general_metal", "mod_main_template_historical_liu_shen_metal", false);
        query_liu_shen = modify_liu_shen:query_character();
        modify_liu_shen:assign_to_post("3k_main_court_offices_minister_earth");

        -- 编辑特性
        mod_remove_all_trait(query_liu_shen);
        modify_liu_shen:ceo_management():add_ceo("3k_ytr_ceo_trait_personality_land_composed"); -- 沉着冷静
        modify_liu_shen:ceo_management():add_ceo("3k_main_ceo_trait_personality_artful"); -- 行事干练
        modify_liu_shen:ceo_management():add_ceo("3k_ytr_ceo_trait_personality_stalwart");
        
        modify_liu_shen:ceo_management():remove_ceos("3k_main_ceo_career_generated_villager_metal");
        modify_liu_shen:ceo_management():add_ceo("3k_main_ceo_career_historical_yu_jin"); -- 毅重严整
        
        -- 设定与卫瓘关系
        modify_wei_guan:apply_relationship_trigger_set(query_liu_shen, "3k_main_relationship_trigger_set_event_positive_generic_extreme");
        
        -- 设定与张华关系
        modify_wei_guan:apply_relationship_trigger_set(query_zhang_hua, "3k_main_relationship_trigger_set_event_positive_generic_extreme");        

        -- 设置军队（刘沈部/靳彧部）
        found_pos, x, y = cm:query_faction("ep_faction_duke_of_lanling"):get_valid_spawn_location_in_region("3k_main_chenjun_resource_3", false);
        
        if found_pos then
        
            -- 刘沈部
            cm:create_force_with_existing_general(query_liu_shen:command_queue_index(), "ep_faction_duke_of_lanling", "", "3k_main_chenjun_resource_3", x, y, "liushen_force", nil, 100);
            local modify_liu_shen_force = cm:modify_model():get_modify_military_force(query_liu_shen:military_force());  
                        
            -- 潘岳加入刘沈部
            modify_liu_shen_force:add_existing_character_as_retinue(modify_pan_yue, true);
                        
            -- 初始随机火将加入靳彧部
            local modify_jin_yu_force = cm:modify_model():get_modify_military_force(cm:query_character("ep_template_historical_jin_yu_hero_fire"):military_force());

            for i = 0, query_duke_of_lanling:character_list():num_items() - 1 do
                local query_character = query_duke_of_lanling:character_list():item_at(i);
                if query_character and not query_character:is_null_interface() and not query_character:is_dead() then
                    if query_character:generation_template_key() == "ep_template_generic_fire_general_normal_m_hero" then
                        modify_jin_yu_force:add_existing_character_as_retinue(cm:modify_character(query_character), true);
                    end;
                    if query_character:character_subtype("3k_general_earth") then
                        modify_jin_yu_force:add_existing_character_as_retinue(cm:modify_character(query_character), true);
                    end;
                end;
            end;

            -- 撤回靳彧
            mod_character_add("ep_template_historical_jin_yu_hero_fire", "ep_faction_empire_of_jin", "3k_general_fire");
            mod_character_add("ep_template_historical_jin_yu_hero_fire", "ep_faction_duke_of_lanling", "3k_general_fire");
            -- modify_liu_shen_force:add_existing_character_as_retinue(cm:modify_character("ep_template_historical_jin_yu_hero_fire"), true);
            
        end;

    --NOTE 司马几 ep_template_historical_sima_ji_hero_fire_yan

        -- 右北平1_临渝
        mod_set_region_manager("3k_main_youbeiping_resource_1","ep_faction_prince_of_yan");
        
        query_prince_of_yan = cm:query_faction("ep_faction_prince_of_yan");

        query_sima_ji_dai = cm:query_character("ep_template_historical_sima_ji_hero_fire_yan");
        modify_sima_ji_dai = cm:modify_character("ep_template_historical_sima_ji_hero_fire_yan");


    --NOTE 刘弘 mod_main_template_historical_liu_hong_earth
        
        modify_liu_hong = cm:modify_faction("ep_faction_prince_of_yan"):create_character_from_template( "general", "3k_general_earth", "mod_main_template_historical_liu_hong_earth", false);
        query_liu_hong = modify_liu_hong:query_character();

        -- 编辑特性
        mod_remove_all_trait(query_liu_hong);
        modify_liu_hong:ceo_management():add_ceo("3k_main_ceo_trait_personality_honourable"); -- 德昭之人
        modify_liu_hong:ceo_management():add_ceo("3k_main_ceo_trait_personality_brave"); -- 英勇无畏
        modify_liu_hong:ceo_management():add_ceo("3k_ytr_ceo_trait_personality_people_compassionate"); -- 关怀备至
        
        modify_liu_hong:ceo_management():remove_ceos("3k_main_ceo_career_generated_general_earth");
        modify_liu_hong:ceo_management():add_ceo("3k_main_ceo_career_historical_liu_biao"); -- 威行荆楚

        -- 祖父刘馥 3k_main_template_historical_liu_fu_hero_water
        modify_liu_fu = cm:modify_faction("ep_faction_empire_of_jin"):create_character_from_template( "general", "3k_general_water", "3k_main_template_historical_liu_fu_hero_water", false);        
        
        -- 父亲刘靖 3k_main_template_historical_liu_jing_hero_fire
        modify_liu_jing = cm:modify_faction("ep_faction_empire_of_jin"):create_character_from_template( "general", "3k_general_fire", "3k_main_template_historical_liu_jing_hero_fire", false);
        
        modify_liu_jing:make_child_of(modify_liu_fu);
        modify_liu_hong:make_child_of(modify_liu_jing);


        -- 设置军队
        local modify_sima_ji_force = cm:modify_model():get_modify_military_force(query_sima_ji_dai:military_force());
        modify_sima_ji_force:add_existing_character_as_retinue(modify_liu_hong, true);



    --NOTE 司马演（代王） mod_main_template_historical_sima_yan_water

        -- 代郡
        mod_set_region_manager("3k_main_daijun_capital","ep_faction_prince_of_dai");
        mod_set_region_manager("3k_main_daijun_resource_1","ep_faction_prince_of_dai");
        
        query_prince_of_dai = cm:query_faction("ep_faction_prince_of_dai");

        modify_sima_yan_dai = cm:modify_faction("ep_faction_prince_of_dai"):create_character_from_template( "general", "3k_general_water", "mod_main_template_historical_sima_yan_water", false);
        query_sima_yan_dai = modify_sima_yan_dai:query_character();
        modify_sima_yan_dai:assign_faction_leader();
        
        -- 设定为司马炎之子
        mod_make_child("ep_template_ancestral_sima_yan_changsha", "mod_main_template_historical_sima_yan_water")


    --NOTE 王浚 mod_main_template_historical_wang_jun_water
        
        modify_wang_jun = cm:modify_faction("ep_faction_prince_of_dai"):create_character_from_template( "general", "3k_general_water", "mod_main_template_historical_wang_jun_water", false);
        query_wang_jun = modify_wang_jun:query_character();

        
        -- 编辑特性
        mod_remove_all_trait(query_wang_jun);
        modify_wang_jun:ceo_management():add_ceo("3k_ytr_ceo_trait_personality_people_stern"); -- 严厉专横
        modify_wang_jun:ceo_management():add_ceo("3k_main_ceo_trait_personality_defiant"); -- 桀骜不驯
        modify_wang_jun:ceo_management():add_ceo("3k_main_ceo_trait_personality_ambitious"); -- 雄心勃勃
        
        modify_wang_jun:ceo_management():remove_ceos("3k_main_ceo_career_generated_villager_water");
        modify_wang_jun:ceo_management():add_ceo("3k_main_ceo_career_historical_gongsun_du"); -- 残暴不节

        -- 设置关系
        modify_wang_jun:apply_relationship_trigger_set(query_zhang_hua, "3k_main_relationship_trigger_set_event_positive_generic_extreme");
        modify_wang_jun:apply_relationship_trigger_set(query_sima_yan_dai, "3k_main_relationship_trigger_set_event_positive_generic_extreme");

        -- 设置军队
        local modify_ju_ruo_force = cm:modify_model():get_modify_military_force(cm:query_character("ep_template_historical_ju_ruo_hero_water_dai"):military_force());
        modify_ju_ruo_force:add_existing_character_as_retinue(modify_wang_jun, true);
        





    --NOTE 司马颙
        query_prince_of_hejian = cm:query_faction("ep_faction_prince_of_hejian");
        mod_set_region_manager("3k_main_henei_resource_1","ep_faction_prince_of_hejian");

    --NOTE 张方 ep_template_historical_zhang_fang_hero_fire
        mod_character_add("ep_template_historical_zhang_fang_hero_fire", "ep_faction_empire_of_jin", "3k_general_fire");
        mod_kill_character("ep_template_historical_zhang_fang_hero_fire");
        modify_zhang_fang = cm:modify_faction("ep_faction_prince_of_hejian"):create_character_from_template( "general", "3k_general_fire", "ep_template_historical_zhang_fang_hero_fire", false);
        query_zhang_fang = modify_zhang_fang:query_character();

        -- 编辑特性
        mod_remove_all_trait(query_zhang_fang);
        modify_zhang_fang:ceo_management():add_ceo("3k_main_ceo_trait_personality_energetic"); -- 斗志昂扬
        modify_zhang_fang:ceo_management():add_ceo("3k_main_ceo_trait_personality_cruel"); -- 残暴不仁
        modify_zhang_fang:ceo_management():add_ceo("3k_main_ceo_trait_personality_disciplined"); -- 令行禁止

        -- 设置与司马颙关系
        cm:modify_character("ep_template_historical_sima_yong_hero_fire_prince"):apply_relationship_trigger_set(query_zhang_fang, "3k_main_relationship_trigger_set_event_positive_generic_extreme");
        cm:modify_character("ep_template_historical_sima_yong_hero_fire_prince"):apply_relationship_trigger_set(query_zhang_fang, "3k_main_relationship_trigger_set_startpos_battle_own_victory_heroic");
        cm:modify_character("ep_template_historical_sima_yong_hero_fire_prince"):apply_relationship_trigger_set(query_zhang_fang, "3k_main_relationship_trigger_set_startpos_campaign_harmony_force");

        -- 设置与李含关系
        modify_zhang_fang:apply_relationship_trigger_set(cm:query_character("ep_template_historical_li_han_hero_earth"), "3k_main_relationship_trigger_set_event_positive_generic_extreme");

        -- 编辑军队

        found_pos, x, y = query_prince_of_hejian:get_valid_spawn_location_in_region("3k_main_henei_resource_1", false);        
        if found_pos then        
            cm:create_force_with_existing_general(query_zhang_fang:command_queue_index(), "ep_faction_prince_of_hejian", "", "3k_main_henei_resource_1", x, y, "zhangfang_force", nil, 100);
            local modify_zhang_fang_force = cm:modify_model():get_modify_military_force(query_zhang_fang:military_force());
        end;


    --NOTE 张轨（征西军司） mod_main_template_historical_zhang_gui_water
        
        query_faction_of_wuwei = cm:query_faction("ep_faction_wuwei");
        
        -- 武威
        mod_set_region_manager("3k_main_jincheng_resource_1","ep_faction_wuwei");
        mod_set_region_manager("3k_main_wuwei_capital","ep_faction_wuwei");
        mod_set_region_manager("3k_main_wuwei_resource_1","ep_faction_wuwei");

        modify_zhang_gui = cm:modify_faction("ep_faction_wuwei"):create_character_from_template("general", "3k_general_water", "mod_main_template_historical_zhang_gui_water", false);
        query_zhang_gui = modify_zhang_gui:query_character();
        modify_zhang_gui:assign_faction_leader();
        
        -- 编辑特性
        mod_remove_all_trait(query_zhang_gui);
        modify_zhang_gui:ceo_management():add_ceo("3k_main_ceo_trait_personality_resourceful"); -- 随机应变
        modify_zhang_gui:ceo_management():add_ceo("3k_main_ceo_trait_personality_cunning"); -- 奇谋百出
        modify_zhang_gui:ceo_management():add_ceo("3k_ytr_ceo_trait_personality_heaven_wise"); -- 睿智人杰
        
        modify_zhang_gui:ceo_management():remove_ceos("3k_main_ceo_career_generated_governor_water");
        modify_zhang_gui:ceo_management():add_ceo("3k_dlc04_ceo_career_historical_liu_hong_yuanzhuo"); -- 成算在心
        
        -- 设置张寔和张茂为张轨子
        modify_zhang_shi = cm:modify_faction("ep_faction_wuwei"):create_character_from_template("general", "3k_general_wood", "mod_main_template_historical_zhang_shi_wood", false);
        query_zhang_shi = modify_zhang_shi:query_character();

        modify_zhang_mao = cm:modify_faction("ep_faction_wuwei"):create_character_from_template("general", "3k_general_earth", "mod_main_template_historical_zhang_mao_earth", false);
        query_zhang_mao = modify_zhang_mao:query_character();

        modify_zhang_shi:make_child_of(modify_zhang_gui);
        modify_zhang_mao:make_child_of(modify_zhang_gui);
        
        -- 设定张茂为继承人
        modify_zhang_mao:assign_to_post("faction_heir");
        
        -- 设置和张寔的关系
        modify_zhang_gui:apply_relationship_trigger_set(query_zhang_shi, "3k_main_relationship_trigger_set_event_positive_generic_extreme");
        
        -- 设置和张华的关系
        modify_zhang_gui:apply_relationship_trigger_set(query_zhang_hua, "3k_main_relationship_trigger_set_event_positive_generic_extreme");

        -- 设置和马隆的关系
        modify_zhang_gui:apply_relationship_trigger_set(query_ma_long, "3k_main_relationship_trigger_set_event_positive_generic_extreme");

        -- test
        -- modify_zhang_gui:move_to_faction_and_make_recruited("ep_faction_prince_of_runan");


    --NOTE 北宫纯 ep_faction_wuwei/ mod_main_template_historical_beigong_chun_fire
        modify_beigong_chun = cm:modify_faction("ep_faction_wuwei"):create_character_from_template( "general", "3k_general_fire", "mod_main_template_historical_beigong_chun_fire", false);
        query_beigong_chun = modify_beigong_chun:query_character();
        modify_beigong_chun:assign_to_post("3k_main_court_offices_minister_earth");

        -- 编辑特性
        mod_remove_all_trait(query_beigong_chun);
        modify_beigong_chun:ceo_management():add_ceo("3k_ytr_ceo_trait_personality_benevolent"); -- 品行高尚
        modify_beigong_chun:ceo_management():add_ceo("3k_ytr_ceo_trait_personality_land_courageous"); -- 勇字当先
        modify_beigong_chun:ceo_management():add_ceo("3k_ytr_ceo_trait_personality_heaven_bright"); -- 识明智审
        
        modify_beigong_chun:ceo_management():remove_ceos("3k_main_ceo_career_generated_general_fire");
        modify_beigong_chun:ceo_management():add_ceo("3k_main_ceo_career_historical_xiahou_yuan"); -- 千里袭人

        -- 设置初始关系
        for i = 0, query_faction_of_wuwei:character_list():num_items() - 1 do
            local query_character = query_faction_of_wuwei:character_list():item_at(i);
            if query_character and not query_character:is_null_interface() and not query_character:is_dead() then
                modify_beigong_chun:apply_relationship_trigger_set(query_character, "3k_main_relationship_trigger_set_event_positive_generic_extreme");
            end;
        end;

        -- 设置初始军队
        found_pos, x, y = cm:query_faction("ep_faction_wuwei"):get_valid_spawn_location_in_region("3k_main_wuwei_capital", false);
        
        if found_pos then
            cm:create_force_with_existing_general(query_beigong_chun:command_queue_index(), "ep_faction_wuwei", "", "3k_main_wuwei_capital", x, y, "zhanggui_force", nil, 100);
            
            -- 设置张寔至初始军队
            local modify_zhang_gui_force = cm:modify_model():get_modify_military_force(query_beigong_chun:military_force());
            modify_zhang_gui_force:add_existing_character_as_retinue(modify_zhang_shi, true);
        end;


    --NOTE 刘渊（汉光乡侯） mod_main_template_historical_liu_yuan_metal
        --河内郡
        mod_set_region_manager("3k_main_henei_capital","ep_faction_henei");    

        modify_liu_yuan = cm:modify_faction("ep_faction_henei"):create_character_from_template( "general", "3k_general_metal", "mod_main_template_historical_liu_yuan_metal", false);
        query_liu_yuan = modify_liu_yuan:query_character();
        modify_liu_yuan:assign_faction_leader();

        -- 编辑特性
        mod_remove_all_trait(query_liu_yuan);
        modify_liu_yuan:ceo_management():add_ceo("3k_main_ceo_trait_personality_scholarly"); -- 笃信好学
        modify_liu_yuan:ceo_management():add_ceo("3k_main_ceo_trait_physical_tough"); -- 顽强不屈
        modify_liu_yuan:ceo_management():add_ceo("3k_main_ceo_trait_personality_perceptive"); -- 锐目如炬

        modify_liu_yuan:ceo_management():remove_ceos("3k_main_ceo_career_generated_envoy_water");
        modify_liu_yuan:ceo_management():add_ceo("ep_ceo_career_historical_huangfu_shang"); -- 容仪机鉴




        diplomacy_manager:apply_automatic_deal_between_factions("ep_faction_duke_of_lanling", "ep_faction_henei", "data_defined_situation_vassalise_recipient_no_requirements",true);

    
    --NOTE 司马颖
        query_prince_of_chengdu = cm:query_faction("ep_faction_prince_of_chengdu");
    
    --NOTE 石超 ep_template_historical_shi_chao_hero_metal
        modify_shi_chao = cm:modify_character("ep_template_historical_shi_chao_hero_metal");
        
        -- 编辑特性
        modify_shi_chao:ceo_management():remove_ceos("ep_ceo_career_historical_shi_chao");
        modify_shi_chao:ceo_management():add_ceo("3k_main_ceo_career_generated_general_metal");


    --NOTE 卢志 mod_main_template_historical_lu_zhi_water
        mod_character_add("ep_template_historical_lu_zhi_hero_water", "ep_faction_empire_of_jin", "3k_general_water");
        mod_kill_character("ep_template_historical_lu_zhi_hero_water");
        modify_lu_zhi = cm:modify_faction("ep_faction_prince_of_chengdu"):create_character_from_template( "general", "3k_general_water", "mod_main_template_historical_lu_zhi_water", false);
        query_lu_zhi = modify_lu_zhi:query_character();

        -- 编辑特性
        mod_remove_all_trait(query_lu_zhi);
        modify_lu_zhi:ceo_management():add_ceo("3k_main_ceo_trait_personality_brilliant");
        modify_lu_zhi:ceo_management():add_ceo("3k_main_ceo_trait_personality_loyal");
        modify_lu_zhi:ceo_management():add_ceo("3k_main_ceo_trait_personality_perceptive");

        modify_lu_zhi:ceo_management():remove_ceos("3k_main_ceo_career_generated_envoy_water");
        modify_lu_zhi:ceo_management():add_ceo("ep_ceo_career_historical_lu_zhi");

        -- 与司马颖关系
        cm:modify_character("ep_template_historical_sima_ying_hero_water_prince"):apply_relationship_trigger_set(query_lu_zhi, "3k_main_relationship_trigger_set_event_positive_generic_extreme");

        -- 与石超关系
        modify_lu_zhi:apply_relationship_trigger_set(cm:query_character("ep_template_historical_shi_chao_hero_metal"), "3k_main_relationship_trigger_set_event_positive_generic_extreme");


    --NOTE 公师藩 mod_main_template_historical_gongshi_fan_wood
        modify_gongshi_fan = cm:modify_faction("ep_faction_prince_of_chengdu"):create_character_from_template( "general", "3k_general_wood", "mod_main_template_historical_gongshi_fan_wood", false);
        query_gongshi_fan = modify_gongshi_fan:query_character();
        
        -- 编辑特性
        mod_remove_all_trait(query_gongshi_fan);
        modify_gongshi_fan:ceo_management():add_ceo("3k_main_ceo_trait_personality_direct");
        modify_gongshi_fan:ceo_management():add_ceo("3k_ytr_ceo_trait_personality_land_courageous");
        modify_gongshi_fan:ceo_management():add_ceo("3k_main_ceo_trait_personality_loyal");

        modify_gongshi_fan:ceo_management():remove_ceos("3k_dlc05_ceo_career_generated_poacher");
        modify_gongshi_fan:ceo_management():add_ceo("3k_main_ceo_career_historical_xiahou_dun");

        -- 与司马颖关系
        cm:modify_character("ep_template_historical_sima_ying_hero_water_prince"):apply_relationship_trigger_set(query_gongshi_fan, "3k_main_relationship_trigger_set_event_positive_generic_extreme");

        -- 与石超关系
        modify_gongshi_fan:apply_relationship_trigger_set(cm:query_character("ep_template_historical_shi_chao_hero_metal"), "3k_main_relationship_trigger_set_event_positive_generic_extreme");

        -- 与刘渊关系
        modify_gongshi_fan:apply_relationship_trigger_set(query_liu_yuan, "3k_main_relationship_trigger_set_event_positive_generic_extreme");

        -- 设置军队
        if not query_prince_of_chengdu:is_human() then
            found_pos, x, y = query_prince_of_chengdu:get_valid_spawn_location_in_region("3k_main_chengdu_resource_3", false);        
            if found_pos then        
                cm:create_force_with_existing_general(query_gongshi_fan:command_queue_index(), "ep_faction_prince_of_chengdu", "", "3k_main_chengdu_resource_3", x, y, "gongshifan_force", nil, 100);
                local modify_gongshi_fan_force = cm:modify_model():get_modify_military_force(query_gongshi_fan:military_force());
                
                -- 添加卢志
                modify_gongshi_fan_force:add_existing_character_as_retinue(modify_lu_zhi, true);
            end;
        end;


    --NOTE 司马永（交趾王，史实为安德县公） mod_main_template_historical_sima_yong_metal

        query_prince_of_jiaozhi = cm:query_faction("ep_faction_prince_of_jiaozhi");

        modify_sima_yong = cm:modify_faction("ep_faction_prince_of_jiaozhi"):create_character_from_template( "general", "3k_general_metal", "mod_main_template_historical_sima_yong_metal", false);
        query_sima_yong = modify_sima_yong:query_character();
        modify_sima_yong:assign_faction_leader();

        -- 设定为司马干之子
        modify_sima_yong:make_child_of(modify_sima_gan);


    --NOTE 陶侃 mod_main_template_historical_tao_kan_earth
        modify_tao_kan = cm:modify_faction("ep_faction_prince_of_jiaozhi"):create_character_from_template( "general", "3k_general_earth", "mod_main_template_historical_tao_kan_earth", false);
        query_tao_kan= modify_tao_kan:query_character();

        -- 编辑特性
        mod_remove_all_trait(query_tao_kan);
        modify_tao_kan:ceo_management():add_ceo("3k_main_ceo_trait_personality_brilliant"); -- 天纵英才
        modify_tao_kan:ceo_management():add_ceo("3k_main_ceo_trait_personality_perceptive"); -- 锐目如炬
        modify_tao_kan:ceo_management():add_ceo("3k_main_ceo_trait_personality_sincere"); -- 待人以诚

        modify_tao_kan:ceo_management():remove_ceos("3k_main_ceo_career_generated_minister_earth");
        modify_tao_kan:ceo_management():add_ceo("ep_ceo_career_historical_li_han");  -- 龙梭

        
        -- 设定与张华关系
        modify_tao_kan:apply_relationship_trigger_set(query_zhang_hua, "3k_main_relationship_trigger_set_event_positive_generic_extreme");


        -- 设置军队


        local modify_xi_kan_force = cm:modify_model():get_modify_military_force(cm:query_character("ep_template_historical_xi_kan_hero_earth"):military_force());
            
        -- 添加陶侃
        modify_xi_kan_force:add_existing_character_as_retinue(modify_tao_kan, true);









    --NOTE 司马广（江阳王*，司马干之子） mod_main_template_historical_sima_guang_earth
        mod_character_add("mod_main_template_historical_sima_guang_earth", "ep_faction_prince_of_jiangyang", "3k_general_earth");
        mod_make_child("mod_main_template_historical_sima_gan_hero_metal", "mod_main_template_historical_sima_guang_earth");
        cm:modify_character("mod_main_template_historical_sima_guang_earth"):assign_faction_leader();

        
    --NOTE 司马干（平原王） mod_main_template_historical_sima_gan_hero_metal
        
        modify_sima_gan:assign_faction_leader();

        -- 编辑特性
        mod_remove_all_trait(query_sima_gan);
        modify_sima_gan:ceo_management():add_ceo("3k_main_ceo_trait_personality_elusive"); -- 难以捉摸
        modify_sima_gan:ceo_management():add_ceo("3k_main_ceo_trait_personality_clever"); -- 足智多谋
        modify_sima_gan:ceo_management():add_ceo("3k_main_ceo_trait_personality_patient"); -- 不厌其烦
        
        modify_sima_gan:ceo_management():remove_ceos("3k_main_ceo_career_generated_minister_metal");
        modify_sima_gan:ceo_management():add_ceo("3k_dlc04_ceo_career_historical_empress_he"); -- 精妙操手
        


        --[[
        -- 如果司马颙不是玩家则休战
        if not cm:query_faction("ep_faction_prince_of_hejian"):is_human() then
            diplomacy_manager:apply_automatic_deal_between_factions("ep_faction_prince_of_hejian", "ep_faction_prince_of_pingyuan", "data_defined_situation_peace", true);
        end;
        ]]--

        -- 设定与交趾王、江阳王同盟
        diplomacy_manager:apply_automatic_deal_between_factions("ep_faction_prince_of_pingyuan", "ep_faction_prince_of_jiangyang", "data_defined_situation_create_alliance_no_conditions",true);
        diplomacy_manager:apply_automatic_deal_between_factions("ep_faction_prince_of_pingyuan", "ep_faction_prince_of_jiaozhi", "data_defined_situation_join_alliance_proposer", true);


    --NOTE 司马遹（长安王，史实为广陵王） mod_main_template_historical_sima_yu_water

        query_prince_of_changan = cm:query_faction("ep_faction_prince_of_changan");

        modify_sima_yu = cm:modify_faction("ep_faction_prince_of_changan"):create_character_from_template("general", "3k_general_water", "mod_main_template_historical_sima_yu_water", false);
        query_sima_yu = modify_sima_yu:query_character();
        modify_sima_yu:assign_faction_leader();

        -- 编辑特性
        mod_remove_all_trait(query_sima_yu);
        modify_sima_yu:ceo_management():add_ceo("3k_main_ceo_trait_personality_arrogant"); -- 骄横自大
        modify_sima_yu:ceo_management():add_ceo("3k_main_ceo_trait_personality_competative"); -- 锐目如炬
        modify_sima_yu:ceo_management():add_ceo("3k_main_ceo_trait_personality_brilliant"); -- 执拗固执
        
        modify_sima_yu:ceo_management():remove_ceos("3k_main_ceo_career_generated_minister_water");
        modify_sima_yu:ceo_management():add_ceo("3k_main_ceo_career_historical_yuan_shang"); -- 宠爱之子

    --NOTE 周处（建威将军） mod_main_template_historical_zhou_chu_wood
        modify_zhou_chu = cm:modify_faction("ep_faction_prince_of_changan"):create_character_from_template("general", "3k_general_wood", "mod_main_template_historical_zhou_chu_wood", false);
        query_zhou_chu = modify_zhou_chu:query_character();

        -- 编辑特性
        mod_remove_all_trait(query_zhou_chu);
        modify_zhou_chu:ceo_management():add_ceo("3k_ytr_ceo_trait_personality_land_composed"); -- 沉着冷静
        modify_zhou_chu:ceo_management():add_ceo("3k_main_ceo_trait_personality_perceptive"); -- 锐目如炬
        modify_zhou_chu:ceo_management():add_ceo("3k_ytr_ceo_trait_personality_strong_willed"); -- 执拗固执
        
        modify_zhou_chu:ceo_management():remove_ceos("3k_dlc05_ceo_career_generated_enforcer");
        modify_zhou_chu:ceo_management():add_ceo("3k_dlc04_ceo_career_historical_duan_gui_ziyin"); -- 铁腕执行

        -- 设置与司马遹关系
        modify_zhou_chu:apply_relationship_trigger_set(cm:query_character("mod_main_template_historical_sima_yu_water"), "3k_main_relationship_trigger_set_event_positive_generic_extreme");

        -- 设置司马遹军队
        found_pos, x, y = cm:query_faction("ep_faction_prince_of_changan"):get_valid_spawn_location_in_region("3k_main_changan_capital", false);
        
        if found_pos then
            cm:create_force_with_existing_general(query_sima_yu:command_queue_index(), "ep_faction_prince_of_changan", "", "3k_main_changan_capital", x, y, "simayu_force", nil, 100);
            local modify_sima_yu_force = cm:modify_model():get_modify_military_force(query_sima_yu:military_force());
            
            -- 设置周处至司马遹军队
            modify_sima_yu_force:add_existing_character_as_retinue(modify_zhou_chu, true);
        end;





    --NOTE 令狐茂搜(白马氐族首领） mod_main_template_historical_linghu_maosou_wood

        --金城、天水
        mod_set_region_manager("3k_main_jincheng_capital", "ep_faction_jincheng");
        mod_set_region_manager("3k_main_jincheng_resource_2", "ep_faction_jincheng");

        modify_linghu_maosou = cm:modify_faction("ep_faction_jincheng"):create_character_from_template("general", "3k_general_wood", "mod_main_template_historical_linghu_maosou_wood", false);
        query_linghu_maosou = modify_linghu_maosou:query_character();
        modify_linghu_maosou:assign_faction_leader();

        -- 编辑特性
        mod_remove_all_trait(query_linghu_maosou);
        modify_linghu_maosou:ceo_management():add_ceo("3k_ytr_ceo_trait_personality_heaven_wise");
        modify_linghu_maosou:ceo_management():add_ceo("3k_main_ceo_trait_physical_strong");
        modify_linghu_maosou:ceo_management():add_ceo("3k_main_ceo_trait_personality_determined");

        modify_linghu_maosou:ceo_management():remove_ceos("3k_main_ceo_career_generated_general_wood");
        modify_linghu_maosou:ceo_management():add_ceo("3k_dlc04_ceo_career_historical_liu_pi");

        
        -- 设置初始军队
        found_pos, x, y = cm:query_faction("ep_faction_jincheng"):get_valid_spawn_location_in_region("3k_main_jincheng_capital", false);
        
        if found_pos then
            cm:create_force_with_existing_general(query_linghu_maosou:command_queue_index(), "ep_faction_jincheng", "", "3k_main_runan_capital", x, y, "linghu_force", nil, 100);
            
            
            -- 设置初始成员a至初始军队
            modify_linghu_maosou_general_a = cm:modify_faction("ep_faction_jincheng"):create_character_from_template( "general", "3k_general_metal", "3k_main_template_generic_metal_general_legendary_f_hero", false);

            local modify_linghu_maosou_force = cm:modify_model():get_modify_military_force(cm:query_character("mod_main_template_historical_linghu_maosou_wood"):military_force());
            modify_linghu_maosou_force:add_existing_character_as_retinue(modify_linghu_maosou_general_a, true);            
        end;




    --NOTE 司马肜（梁王）和皇甫重（秦州刺史） ep_template_historical_sima_rong_hero_metal_liang
    
        query_prince_of_liang = cm:query_faction("ep_faction_prince_of_liang");
        
        if cm:query_faction("ep_faction_prince_of_wudu"):is_human() then
            modify_sima_rong = cm:modify_faction("ep_faction_prince_of_wudu"):create_character_from_template("general", "3k_general_water", "ep_template_historical_sima_rong_hero_metal_liang", false);
            query_sima_rong = modify_sima_rong:query_character();
            modify_sima_rong:assign_faction_leader();

            -- 编辑特性
            mod_remove_all_trait(query_sima_rong);
            modify_sima_rong:ceo_management():add_ceo("3k_main_ceo_trait_personality_cautious"); -- 谨小慎微
            modify_sima_rong:ceo_management():add_ceo("3k_main_ceo_trait_personality_humble"); -- 谦恭有礼
            modify_sima_rong:ceo_management():add_ceo("3k_ytr_ceo_trait_personality_heaven_bright"); -- 识明知审

            modify_sima_rong:ceo_management():remove_ceos("3k_main_ceo_career_generated_governor_water");
            modify_sima_rong:ceo_management():add_ceo("3k_main_ceo_career_historical_wang_lang"); -- 清修恭慎
            
            -- 增加廷臣
            mod_character_add("mod_main_template_historical_huangfu_kui_metal", "ep_faction_prince_of_wudu", "3k_general_metal");
            mod_character_add("3k_main_template_historical_huangfu_mi_hero_water", "ep_faction_prince_of_wudu", "3k_general_metal");
            mod_character_add("mod_main_template_historical_huangfu_zhen_water", "ep_faction_prince_of_wudu", "3k_general_water");
            mod_character_add("mod_main_template_historical_huangfu_zhong_earth", "ep_faction_prince_of_wudu", "3k_general_earth");

            -- 设为与赵王同盟
            diplomacy_manager:apply_automatic_deal_between_factions("ep_faction_prince_of_zhao", "ep_faction_prince_of_wudu", "data_defined_situation_create_alliance_no_conditions",true);

        else
            mod_set_region_manager("3k_main_wudu_capital","ep_faction_prince_of_liang");
            mod_set_region_manager("3k_main_wudu_resource_1","ep_faction_prince_of_liang");
            mod_set_region_manager("3k_main_wudu_resource_2","ep_faction_prince_of_liang");

            modify_sima_rong = cm:modify_faction("ep_faction_prince_of_liang"):create_character_from_template("general", "3k_general_water", "ep_template_historical_sima_rong_hero_metal_liang", false);
            query_sima_rong = modify_sima_rong:query_character();
            modify_sima_rong:assign_faction_leader();

            -- 编辑特性
            mod_remove_all_trait(query_sima_rong);
            modify_sima_rong:ceo_management():add_ceo("3k_main_ceo_trait_personality_cautious"); -- 谨小慎微
            modify_sima_rong:ceo_management():add_ceo("3k_main_ceo_trait_personality_humble"); -- 谦恭有礼
            modify_sima_rong:ceo_management():add_ceo("3k_ytr_ceo_trait_personality_heaven_bright"); -- 识明知审

            modify_sima_rong:ceo_management():remove_ceos("3k_main_ceo_career_generated_governor_water");
            modify_sima_rong:ceo_management():add_ceo("3k_main_ceo_career_historical_wang_lang"); -- 清修恭慎

            -- 增加廷臣
            mod_character_add("mod_main_template_historical_huangfu_kui_metal", "ep_faction_prince_of_liang", "3k_general_metal");
            mod_character_add("3k_main_template_historical_huangfu_mi_hero_water", "ep_faction_prince_of_liang", "3k_general_metal");
            mod_character_add("mod_main_template_historical_huangfu_zhen_water", "ep_faction_prince_of_liang", "3k_general_water");
            
            modify_huangfu_zhong = cm:modify_faction("ep_faction_prince_of_liang"):create_character_from_template("general", "3k_general_earth", "mod_main_template_historical_huangfu_zhong_earth", false);

            -- 编辑军队
            found_pos, x, y = query_prince_of_liang:get_valid_spawn_location_in_region("3k_main_wudu_capital", false);        
            if found_pos then        
                cm:create_force_with_existing_general(query_sima_rong:command_queue_index(), "ep_faction_prince_of_liang", "", "3k_main_wudu_capital", x, y, "simarong_force", nil, 100);
                local modify_sima_rong_force = cm:modify_model():get_modify_military_force(query_sima_rong:military_force());
                
                -- 添加皇甫重
                modify_sima_rong_force:add_existing_character_as_retinue(modify_huangfu_zhong, true);
            end;

            -- 移除武都王势力
            diplomacy_manager:apply_automatic_deal_between_factions("ep_faction_prince_of_liang", "ep_faction_prince_of_wudu", "data_defined_situation_confederate_recipient_no_requirements", true);
            
            -- 设为与赵王同盟
            diplomacy_manager:apply_automatic_deal_between_factions("ep_faction_prince_of_zhao", "ep_faction_prince_of_liang", "data_defined_situation_create_alliance_no_conditions",true);
        end;

        -- 设定司马肜为司马懿之子
        mod_make_child("ep_template_ancestral_sima_yi_runan", "ep_template_historical_sima_rong_hero_metal_liang");
        
        -- 设定皇甫家族的亲属关系
        mod_make_child("mod_main_template_historical_huangfu_kui_metal", "mod_main_template_historical_huangfu_zhen_water");
        mod_make_child("mod_main_template_historical_huangfu_kui_metal", "3k_main_template_historical_huangfu_mi_hero_water");
        mod_make_child("mod_main_template_historical_huangfu_zhen_water", "mod_main_template_historical_huangfu_zhong_earth");
        mod_make_child("mod_main_template_historical_huangfu_zhen_water", "ep_template_historical_huangfu_shang_hero_metal");

        -- 设置与周处关系
        cm:modify_character("ep_template_historical_sima_rong_hero_metal_liang"):apply_relationship_trigger_set(query_zhou_chu, "3k_main_relationship_trigger_set_event_negative_generic_extreme");


    --NOTE 司马鉴(乐安王）
        mod_set_region_manager("3k_main_luling_capital","ep_faction_prince_of_lean");
        mod_set_region_manager("3k_main_luling_resource_1","ep_faction_prince_of_lean");

        mod_character_add("ep_template_historical_sima_jian_hero_earth_lean", "ep_faction_prince_of_lean", "3k_general_earth");
        cm:modify_character("ep_template_historical_sima_jian_hero_earth_lean"):assign_faction_leader();

        campaign_invasions:create_invasion("ep_faction_prince_of_lean", "3k_main_luling_capital", 3, false)


    --NOTE 司马迈（江夏王，史实为随王）和夏靖（武昌太守）

        mod_character_add("mod_main_template_historical_sima_mai_fire", "ep_faction_prince_of_jiangxia", "3k_general_fire");
        cm:modify_character("mod_main_template_historical_sima_mai_fire"):assign_faction_leader();

        mod_character_add("mod_main_template_historical_xia_jin_hero_water", "ep_faction_prince_of_jiangxia", "3k_general_water");


    --NOTE 王遐（郁林太守）
        --郁林郡
        mod_set_region_manager("3k_main_yulin_capital","ep_faction_yulin");
        mod_set_region_manager("3k_main_yulin_resource_1","ep_faction_yulin");
        mod_set_region_manager("3k_main_yulin_resource_2","ep_faction_yulin");
         
        mod_character_add("mod_main_template_historical_wang_xia_hero_water", "ep_faction_yulin", "3k_general_water");
        cm:modify_character("mod_main_template_historical_wang_xia_hero_water"):assign_faction_leader();


    --NOTE 司马籍（合浦王，史实袭封乐安王）和王毅（广州刺史）
        mod_character_add("mod_main_template_historical_sima_ji_wood", "ep_faction_prince_of_hepu", "3k_general_wood");
        cm:modify_character("mod_main_template_historical_sima_ji_wood"):assign_faction_leader();

        mod_character_add("mod_main_template_historical_wang_yi_fire", "ep_faction_prince_of_hepu", "3k_general_fire");


    --NOTE 司马澹（武陵王）和钟离祎（天门太守）
        mod_character_add("mod_main_template_historical_sima_dan_water", "ep_faction_prince_of_wuling", "3k_general_water");
        cm:modify_character("mod_main_template_historical_sima_dan_water"):assign_faction_leader();

        mod_character_add("mod_main_template_historical_zhongli_yi_earth", "ep_faction_prince_of_wuling", "3k_general_earth");

        --设置为司马伷之子
        mod_make_child("mod_main_template_historical_sima_zhou_fire", "mod_main_template_historical_sima_dan_water");


    --NOTE 司马韬（鄱阳王，史实沛王）和李矩（江州刺史）

        mod_character_add("mod_main_template_historical_sima_tao_metal", "ep_faction_prince_of_poyang", "3k_general_metal");
        cm:modify_character("mod_main_template_historical_sima_tao_metal"):assign_faction_leader();
        
        mod_character_add("mod_main_template_historical_li_ju_fire", "ep_faction_prince_of_poyang", "3k_general_fire");


    --NOTE 司马蔚（巴东王*） mod_main_template_historical_sima_wei_water

        query_prince_of_badong = cm:query_faction("ep_faction_prince_of_badong");

        modify_sima_wei_badong = cm:modify_faction("ep_faction_prince_of_badong"):create_character_from_template("general", "3k_general_water", "mod_main_template_historical_sima_wei_water", false);
        query_sima_wei_badong = modify_sima_wei_badong:query_character();
        modify_sima_wei_badong:assign_faction_leader();
        
        
    --NOTE 毌丘奥 mod_main_template_historical_guanqiu_ao_fire
    
        modify_guanqiu_ao = cm:modify_faction("ep_faction_prince_of_badong"):create_character_from_template("general", "3k_general_fire", "mod_main_template_historical_guanqiu_ao_fire", false);
        query_guanqiu_ao = modify_guanqiu_ao:query_character();

        -- 设置与司马蔚关系
        modify_sima_wei_badong:apply_relationship_trigger_set(query_guanqiu_ao, "3k_main_relationship_trigger_set_event_positive_generic_extreme");

    --NOTE 李特 mod_main_template_historical_li_te_metal

        modify_li_te = cm:modify_faction("ep_faction_prince_of_badong"):create_character_from_template("general", "3k_general_metal", "mod_main_template_historical_li_te_metal", false);
        query_li_te = modify_li_te:query_character();

        -- 编辑特性
        mod_remove_all_trait(query_li_te);
        modify_li_te:ceo_management():add_ceo("3k_ytr_ceo_trait_personality_land_composed"); -- 沉着冷静
        modify_li_te:ceo_management():add_ceo("3k_ytr_ceo_trait_personality_trustworthy"); -- 守义堪信
        modify_li_te:ceo_management():add_ceo("3k_ytr_ceo_trait_personality_people_people_pleaser"); -- 深得民心
        
        modify_li_te:ceo_management():remove_ceos("3k_main_ceo_career_generated_villager_metal");
        modify_li_te:ceo_management():add_ceo("3k_ytr_ceo_career_historical_zhang_kai"); -- 铲灭暴政

        -- 编辑装备(战斧)
        cdir_events_manager:add_or_remove_ceo_from_faction(query_li_te:faction():name(), "3k_main_ancillary_weapon_one_handed_axe_exceptional", true);
        ancillaries:equip_ceo_on_character(query_li_te, "3k_main_ancillary_weapon_one_handed_axe_exceptional", "3k_main_ceo_category_ancillary_weapon");

        -- 设置与司马蔚关系
        modify_sima_wei_badong:apply_relationship_trigger_set(query_li_te, "3k_main_relationship_trigger_set_event_positive_generic_extreme");

    --NOTE 李雄 mod_main_template_historical_li_xiong_earth

        modify_li_xiong = cm:modify_faction("ep_faction_prince_of_badong"):create_character_from_template("general", "3k_general_earth", "mod_main_template_historical_li_xiong_earth", false);
        query_li_xiong = modify_li_xiong:query_character();

        -- 编辑特性
        mod_remove_all_trait(query_li_xiong);
        modify_li_xiong:ceo_management():add_ceo("3k_main_ceo_trait_physical_graceful"); -- 身形俊秀
        modify_li_xiong:ceo_management():add_ceo("3k_main_ceo_trait_personality_charismatic"); -- 富有魅力
        modify_li_xiong:ceo_management():add_ceo("3k_main_ceo_trait_personality_sincere"); -- 待人以诚
        
        modify_li_xiong:ceo_management():remove_ceos("3k_main_ceo_career_generated_governor_earth");
        modify_li_xiong:ceo_management():add_ceo("ep_ceo_career_historical_sima_ju"); -- 晏平巴蜀

        -- 设为李特之子
        modify_li_xiong:make_child_of(modify_li_te);

        -- 编辑关系
        modify_li_xiong:apply_relationship_trigger_set(query_guanqiu_ao, "3k_main_relationship_trigger_set_event_positive_generic_extreme");
        modify_li_xiong:apply_relationship_trigger_set(cm:query_character("ep_template_historical_shan_yu_hero_earth_badong"), "3k_main_relationship_trigger_set_event_positive_generic_extreme");
        modify_li_xiong:apply_relationship_trigger_set(query_li_te, "3k_main_relationship_trigger_set_startpos_family_member");

    --NOTE 山玉
        query_shan_yu = cm:query_character("ep_template_historical_shan_yu_hero_earth_badong");

        -- 设置军队
        local modify_shan_yu_force = cm:modify_model():get_modify_military_force(query_shan_yu:military_force());
        
        -- 添加李特和毌丘奥
        modify_shan_yu_force:add_existing_character_as_retinue(modify_li_te, true);




    --NOTE 司马聪（巴王，虚构，司马颖的初始对手，设为司马炎子）
        
        mod_character_add("mod_main_template_historical_sima_cong_metal", "ep_faction_prince_of_ba", "3k_general_metal")
        mod_make_child("ep_template_ancestral_sima_yan_changsha", "mod_main_template_historical_sima_cong_metal")
        cm:modify_character("mod_main_template_historical_sima_cong_metal"):assign_faction_leader()


    --NOTE 司马遐（零陵王，史实为清河王）
        mod_character_add("ep_template_historical_sima_xia_hero_fire", "ep_faction_prince_of_lingling", "3k_general_fire");
        mod_make_child("ep_template_ancestral_sima_yan_changsha", "ep_template_historical_sima_xia_hero_fire");
        cm:modify_character("ep_template_historical_sima_xia_hero_fire"):assign_faction_leader();


    --NOTE 司马虓（范阳王） ep_template_historical_sima_xiao_hero_metal
        
        mod_set_region_manager("3k_main_youzhou_capital","ep_faction_prince_of_fanyang");
        mod_set_region_manager("3k_main_youzhou_resource_1","ep_faction_prince_of_fanyang");

        query_prince_of_fanyang = cm:query_faction("ep_faction_prince_of_fanyang");

        modify_sima_xiao = cm:modify_faction("ep_faction_prince_of_fanyang"):create_character_from_template("general", "3k_general_metal", "ep_template_historical_sima_xiao_hero_metal", false);
        query_sima_xiao = modify_sima_xiao:query_character();
        modify_sima_xiao:assign_faction_leader();
        
        -- 编辑特性
        mod_remove_all_trait(query_sima_xiao);
        modify_sima_xiao:ceo_management():add_ceo("3k_main_ceo_trait_personality_scholarly"); -- 笃信好学
        modify_sima_xiao:ceo_management():add_ceo("3k_ytr_ceo_trait_personality_heaven_tolerant"); -- 宽大为怀
        modify_sima_xiao:ceo_management():add_ceo("3k_main_ceo_trait_personality_humble"); -- 谦恭有礼
        
        modify_sima_xiao:ceo_management():remove_ceos("3k_main_ceo_career_generated_governor_metal");
        modify_sima_xiao:ceo_management():add_ceo("3k_dlc04_ceo_career_historical_cao_de"); -- 忠诚子嗣
        
        
        -- 设置初始成员A
        modify_price_of_fanyang_char_a = cm:modify_faction("ep_faction_prince_of_fanyang"):create_character_from_template( "general", "3k_general_water", "3k_main_template_generic_water_general_legendary_m_hero", false);
        modify_price_of_fanyang_char_a:assign_to_post("3k_main_court_offices_minister_earth");

        -- 设置与派系成员关系，撤回初始随机武将
        for i = 0, query_prince_of_fanyang:character_list():num_items() - 1 do
            local query_character = query_prince_of_fanyang:character_list():item_at(i);
            if query_character and not query_character:is_null_interface() and not query_character:is_dead() then
                modify_sima_xiao:apply_relationship_trigger_set(query_character, "3k_main_relationship_trigger_set_event_positive_generic_extreme");                
            end;
        end;

        -- 设置军队
        found_pos, x, y = query_prince_of_fanyang:get_valid_spawn_location_in_region("3k_main_youzhou_capital", false);        
        if found_pos then        
            cm:create_force_with_existing_general(query_sima_xiao:command_queue_index(), "ep_faction_prince_of_fanyang", "", "3k_main_youzhou_capital", x, y, "simaxiao_force", nil, 100);
            local modify_sima_xiao_force = cm:modify_model():get_modify_military_force(query_sima_xiao:military_force());
            
            -- 添加成员
            modify_sima_xiao_force:add_existing_character_as_retinue(modify_price_of_fanyang_char_a, true);
        end;

        
        -- mod_character_add("ep_template_historical_sima_xiao_hero_metal", "ep_faction_duke_of_lanling", "3k_general_metal");


    --NOTE 司马泰（陇西王） ep_template_historical_sima_tai_hero_fire_donghai
        
        query_sima_tai = cm:query_character("ep_template_historical_sima_tai_hero_fire_donghai");
        modify_sima_tai = cm:modify_character("ep_template_historical_sima_tai_hero_fire_donghai");
        
        -- 设定为司马馗子
        modify_sima_tai:make_child_of(modify_sima_kui);
        
        -- 设定与南阳王、东海王同盟
        diplomacy_manager:apply_automatic_deal_between_factions("ep_faction_prince_of_longxi", "ep_faction_prince_of_nanyang", "data_defined_situation_create_alliance_no_conditions",true);
        diplomacy_manager:apply_automatic_deal_between_factions("ep_faction_prince_of_longxi", "ep_faction_prince_of_donghai", "data_defined_situation_join_alliance_proposer",true);


    --NOTE 刘琨 mod_template_historical_liu_kun_hero_earth
        
        modify_liu_kun = cm:modify_faction("ep_faction_prince_of_longxi"):create_character_from_template("general", "3k_general_earth", "mod_template_historical_liu_kun_hero_earth", false);
        query_liu_kun = modify_liu_kun:query_character();

        -- 编辑特性
        mod_remove_all_trait(query_liu_kun);
        modify_liu_kun:ceo_management():add_ceo("3k_ytr_ceo_trait_personality_people_compassionate"); -- 关怀备至
        modify_liu_kun:ceo_management():add_ceo("3k_main_ceo_trait_personality_fraternal"); -- 手足之谊
        modify_liu_kun:ceo_management():add_ceo("3k_main_ceo_trait_personality_energetic"); -- 斗志昂扬
        
        modify_liu_kun:ceo_management():remove_ceos("3k_main_ceo_career_generated_minister_earth");
        modify_liu_kun:ceo_management():add_ceo("3k_dlc04_ceo_career_historical_zhang_wen_boshen"); -- 无双国士

        -- 设置与祖逖关系
        modify_liu_kun:apply_relationship_trigger_set(query_zu_ti, "3k_main_relationship_trigger_set_event_positive_generic_extreme");

        -- 设置军队
        local modify_sima_tai_force = cm:modify_model():get_modify_military_force(query_sima_tai:military_force());
        modify_sima_tai_force:add_existing_character_as_retinue(modify_liu_kun, true);



    --NOTE 司马模（南阳王，史实此时为北中郎将） mod_template_historical_sima_mo_hero_fire
        query_prince_of_nanyang = cm:query_faction("ep_faction_prince_of_nanyang");
        
        mod_character_add("ep_template_historical_sima_mo_hero_fire", "ep_faction_empire_of_jin", "3k_general_fire");

        modify_sima_mo = cm:modify_faction("ep_faction_prince_of_nanyang"):create_character_from_template("general", "3k_general_fire", "mod_template_historical_sima_mo_hero_fire", false);
        query_sima_mo = modify_sima_mo:query_character();
        modify_sima_mo:assign_faction_leader();

        -- 编辑特性
        mod_remove_all_trait(query_sima_mo);
        modify_sima_mo:ceo_management():add_ceo("3k_main_ceo_trait_personality_determined"); -- 芯若磐石
        modify_sima_mo:ceo_management():add_ceo("3k_main_ceo_trait_personality_fraternal"); -- 手足之谊
        modify_sima_mo:ceo_management():add_ceo("3k_main_ceo_trait_personality_superstitious"); -- 笃信鬼神
        
        modify_sima_mo:ceo_management():remove_ceos("3k_main_ceo_career_generated_minister_fire");
        modify_sima_mo:ceo_management():add_ceo("3k_dlc06_ceo_career_historical_shi_hui"); -- 空有雄心

        -- 编辑家族
        modify_sima_mo:make_child_of(modify_sima_tai);

        -- 编辑外交关系
        diplomacy_manager:apply_automatic_deal_between_factions("ep_faction_prince_of_nanyang", "ep_faction_prince_of_chu", "data_defined_situation_vassal_declares_independence",true);
        diplomacy_manager:apply_automatic_deal_between_factions("ep_faction_prince_of_nanyang", "ep_faction_prince_of_runan", "data_defined_situation_peace",true);


    --NOTE 陈安 mod_main_template_historical_chen_an_wood
        
        modify_chen_an = cm:modify_faction("ep_faction_prince_of_nanyang"):create_character_from_template("general", "3k_general_wood", "mod_main_template_historical_chen_an_wood", false);
        query_chen_an = modify_chen_an:query_character();

        -- 编辑特性
        mod_remove_all_trait(query_chen_an);
        modify_chen_an:ceo_management():add_ceo("3k_main_ceo_trait_physical_strong"); -- 身强体壮
        modify_chen_an:ceo_management():add_ceo("3k_main_ceo_trait_personality_intimidating"); -- 咄咄逼人
        modify_chen_an:ceo_management():add_ceo("3k_main_ceo_trait_personality_disciplined"); -- 令行禁止
        
        modify_chen_an:ceo_management():remove_ceos("3k_main_ceo_career_generated_general_wood");
        modify_chen_an:ceo_management():add_ceo("3k_main_ceo_career_historical_wen_chou"); -- 气焰滔天

        -- 编辑装备(丈八蛇矛)
        cdir_events_manager:add_or_remove_ceo_from_faction(query_chen_an:faction():name(), "3k_main_ancillary_weapon_serpent_spear_faction", true);
        ancillaries:equip_ceo_on_character(query_chen_an, "3k_main_ancillary_weapon_serpent_spear_faction", "3k_main_ceo_category_ancillary_weapon");

        -- 设置与派系成员关系，撤回初始随机武将
        for i = 0, query_prince_of_nanyang:character_list():num_items() - 1 do
            local query_character = query_prince_of_nanyang:character_list():item_at(i);
            if query_character and not query_character:is_null_interface() and not query_character:is_dead() then
                modify_chen_an:apply_relationship_trigger_set(query_character, "3k_main_relationship_trigger_set_event_positive_generic_extreme");
                
                if query_character:generation_template_key() == "ep_template_generic_fire_minister_normal_m_hero" then
                    cm:modify_character(query_character):move_to_faction_and_make_recruited("ep_faction_empire_of_jin");
                    cm:modify_character(query_character):move_to_faction_and_make_recruited("ep_faction_prince_of_nanyang");
                end;
                
            end;
        end;
        
        -- 设置军队
        found_pos, x, y = query_prince_of_nanyang:get_valid_spawn_location_in_region("3k_main_nanyang_capital", false);
        if found_pos then
            cm:create_force_with_existing_general(query_sima_mo:command_queue_index(), "ep_faction_prince_of_nanyang", "", "3k_main_nanyang_capital", x, y, "simamo_force", nil, 100);
            local modify_sima_mo_force = cm:modify_model():get_modify_military_force(query_sima_mo:military_force());
            
            -- 添加陈安
            modify_sima_mo_force:add_existing_character_as_retinue(modify_chen_an, true);
        end;

    --NOTE 司马越（东海王） ep_template_historical_sima_yue_hero_metal_prince
        query_prince_of_donghai = cm:query_faction("ep_faction_prince_of_donghai");

        -- 设置初始成员A
        -- modify_price_of_donghai_char_a = cm:modify_faction("ep_faction_prince_of_donghai"):create_character_from_template( "general", "3k_general_fire", "3k_main_template_generic_fire_general_legendary_m_hero", false);



        modify_sima_yue = cm:modify_character("ep_template_historical_sima_yue_hero_metal_prince");
        query_sima_yue = cm:query_character("ep_template_historical_sima_yue_hero_metal_prince");
        
        modify_sima_yue_family_member = cm:modify_model():get_modify_family_member(query_sima_yue:family_member());

    --NOTE 何伦
        modify_he_lun = cm:modify_character("ep_template_historical_he_lun_hero_earth");
        modify_he_lun:ceo_management():remove_ceos("ep_ceo_career_historical_he_lun");
        modify_he_lun:ceo_management():add_ceo("3k_main_ceo_career_generated_general_earth");


    --NOTE 祁弘 mod_main_template_historical_qi_hong_wood
        modify_qi_hong = cm:modify_faction("ep_faction_prince_of_donghai"):create_character_from_template("general", "3k_general_wood", "mod_main_template_historical_qi_hong_wood", false);
        query_qi_hong = modify_qi_hong:query_character();

        -- 编辑特性
        mod_remove_all_trait(query_qi_hong);
        modify_qi_hong:ceo_management():add_ceo("3k_main_ceo_trait_personality_determined"); -- 心若磐石
        modify_qi_hong:ceo_management():add_ceo("3k_main_ceo_trait_personality_solitary"); -- 形单影只
        modify_qi_hong:ceo_management():add_ceo("3k_ytr_ceo_trait_personality_land_powerful"); -- 令人敬畏
        
        modify_qi_hong:ceo_management():remove_ceos("3k_main_ceo_career_generated_general_wood");
        modify_qi_hong:ceo_management():add_ceo("ep_ceo_career_historical_he_lun"); -- 赤日人屠


        -- 设置与司马越关系
        modify_sima_yue:apply_relationship_trigger_set(query_qi_hong, "3k_main_relationship_trigger_set_event_positive_generic_extreme");

     
    --NOTE 裴妃 ep_template_historical_princess_pei_hero_metal

        -- 转移旧版裴妃至晋帝国，并清理
        mod_character_add("ep_template_historical_princess_pei_hero_metal", "ep_faction_empire_of_jin", "3k_general_metal");
        mod_kill_character("ep_template_historical_princess_pei_hero_metal")

        modify_princess_pei = cm:modify_faction("ep_faction_prince_of_donghai"):create_character_from_template("general", "3k_general_metal", "ep_template_historical_princess_pei_hero_metal", false);
        query_princess_pei = modify_princess_pei:query_character();        

        local modify_princess_pei_family_member = cm:modify_model():get_modify_family_member(query_princess_pei:family_member());    
        modify_sima_yue_family_member:marry_character(modify_princess_pei_family_member);

        -- 编辑特性
        mod_remove_all_trait(query_princess_pei);
        modify_princess_pei:ceo_management():add_ceo("3k_main_ceo_trait_personality_cautious"); -- 谨小慎微
        modify_princess_pei:ceo_management():add_ceo("3k_ytr_ceo_trait_personality_people_understanding"); -- 深谙人情
        modify_princess_pei:ceo_management():add_ceo("3k_main_ceo_trait_personality_clever"); -- 足智多谋
        
        modify_princess_pei:ceo_management():remove_ceos("ep_ceo_career_historical_princess_pei");
        modify_princess_pei:ceo_management():add_ceo("3k_dlc05_ceo_career_historical_zhang_miao"); -- 长袖善舞

        -- 设置与派系成员关系
        for i = 0, query_prince_of_donghai:character_list():num_items() - 1 do
            local query_character = query_prince_of_donghai:character_list():item_at(i);
            if query_character and not query_character:is_null_interface() and not query_character:is_dead() then
                modify_princess_pei:apply_relationship_trigger_set(query_character, "3k_main_relationship_trigger_set_event_positive_generic_extreme");
            end;
        end;

        -- 设置军队
        if not query_prince_of_donghai:is_human() then
            found_pos, x, y = query_prince_of_donghai:get_valid_spawn_location_in_region("3k_main_donghai_resource_1", false);        
            if found_pos then        
                cm:create_force_with_existing_general(query_qi_hong:command_queue_index(), "ep_faction_prince_of_donghai", "", "3k_main_donghai_resource_1", x, y, "qihong_force", nil, 100);
                local modify_qi_hong_force = cm:modify_model():get_modify_military_force(query_qi_hong:military_force());
                
                -- 添加裴妃
                modify_qi_hong_force:add_existing_character_as_retinue(modify_princess_pei, true);
            end;
        end;

        -- 设置与司马肜关系
        modify_princess_pei:apply_relationship_trigger_set(cm:query_character("ep_template_historical_sima_rong_hero_metal_liang"), "3k_main_relationship_trigger_set_event_positive_generic_extreme");

        -- 设置与司马干关系
        modify_princess_pei:apply_relationship_trigger_set(query_sima_gan, "3k_main_relationship_trigger_set_event_positive_generic_extreme");        
        
        -- 设置与司马睿关系
        modify_princess_pei:apply_relationship_trigger_set(query_sima_rui_langya, "3k_main_relationship_trigger_set_event_positive_generic_extreme");  
        
        -- 设置与司马炽关系
        modify_princess_pei:apply_relationship_trigger_set(query_sima_chi, "3k_main_relationship_trigger_set_event_positive_generic_extreme");        
        
        -- 设置与张华关系
        modify_princess_pei:apply_relationship_trigger_set(query_zhang_hua, "3k_main_relationship_trigger_set_event_positive_generic_extreme"); 
        
        -- 设置与司马亮关系
        modify_princess_pei:apply_relationship_trigger_set(cm:query_character("ep_template_historical_sima_liang_hero_wood_prince"), "3k_main_relationship_trigger_set_event_positive_generic_extreme"); 

        
    --NOTE 司马腾 mod_main_template_historical_sima_teng_fire
        
        query_prince_of_xihe = cm:query_faction("ep_faction_prince_of_xihe");
        
        mod_set_region_manager("3k_main_xihe_capital","ep_faction_prince_of_xihe")
        mod_set_region_manager("3k_main_xihe_resource_1","ep_faction_prince_of_xihe")

        modify_sima_teng = cm:modify_faction("ep_faction_prince_of_xihe"):create_character_from_template("general", "3k_general_fire", "mod_main_template_historical_sima_teng_fire", false);
        query_sima_teng = modify_sima_teng:query_character();
        modify_sima_teng:assign_faction_leader();

        -- 编辑特性
        mod_remove_all_trait(query_sima_teng);
        modify_sima_teng:ceo_management():add_ceo("3k_main_ceo_trait_personality_clever"); -- 足智多谋
        modify_sima_teng:ceo_management():add_ceo("3k_main_ceo_trait_personality_cautious"); -- 谨小慎微
        modify_sima_teng:ceo_management():add_ceo("3k_main_ceo_trait_personality_intimidating"); -- 咄咄逼人
        
        modify_sima_teng:ceo_management():remove_ceos("3k_main_ceo_career_generated_minister_fire");
        modify_sima_teng:ceo_management():add_ceo("3k_ytr_ceo_career_historical_pei_yuanshao"); -- 忠勇先驱

        -- 编辑军队
        found_pos, x, y = query_prince_of_xihe:get_valid_spawn_location_in_region("3k_main_xihe_capital", false);        
        if found_pos then        
            cm:create_force_with_existing_general(query_sima_teng:command_queue_index(), "ep_faction_prince_of_xihe", "", "3k_main_xihe_capital", x, y, "sima_teng_force", nil, 100);
        end;

        -- 司马腾、司马略设为司马泰子
        modify_sima_lue:make_child_of(modify_sima_tai);
        modify_sima_teng:make_child_of(modify_sima_tai);

        
        -- 编辑关系
        for i = 0, query_prince_of_xihe:character_list():num_items() - 1 do
            local query_character = query_prince_of_xihe:character_list():item_at(i);
            if query_character and not query_character:is_null_interface() and not query_character:is_dead() then
                modify_sima_teng:apply_relationship_trigger_set(query_character, "3k_main_relationship_trigger_set_event_positive_generic_extreme");
            end;
        end;

        modify_sima_tai:apply_relationship_trigger_set(query_sima_teng, "3k_main_relationship_trigger_set_event_positive_generic_extreme");
        modify_sima_tai:apply_relationship_trigger_set(query_sima_lue, "3k_main_relationship_trigger_set_event_positive_generic_extreme");
        modify_sima_tai:apply_relationship_trigger_set(query_sima_mo, "3k_main_relationship_trigger_set_event_positive_generic_extreme");
        modify_sima_tai:apply_relationship_trigger_set(query_sima_yue, "3k_main_relationship_trigger_set_event_positive_generic_extreme");

        modify_sima_tai:apply_relationship_trigger_set(query_sima_teng, "3k_main_relationship_trigger_set_startpos_family_member");
        modify_sima_tai:apply_relationship_trigger_set(query_sima_lue, "3k_main_relationship_trigger_set_startpos_family_member");
        modify_sima_tai:apply_relationship_trigger_set(query_sima_mo, "3k_main_relationship_trigger_set_startpos_family_member");
        modify_sima_tai:apply_relationship_trigger_set(query_sima_yue, "3k_main_relationship_trigger_set_startpos_family_member");

        modify_sima_teng:apply_relationship_trigger_set(query_sima_lue, "3k_main_relationship_trigger_set_event_positive_generic_extreme");
        modify_sima_teng:apply_relationship_trigger_set(query_sima_mo, "3k_main_relationship_trigger_set_event_positive_generic_extreme");
        modify_sima_teng:apply_relationship_trigger_set(query_sima_yue, "3k_main_relationship_trigger_set_event_positive_generic_extreme");

        modify_sima_teng:apply_relationship_trigger_set(query_sima_lue, "3k_main_relationship_trigger_set_startpos_family_member");
        modify_sima_teng:apply_relationship_trigger_set(query_sima_mo, "3k_main_relationship_trigger_set_startpos_family_member");
        modify_sima_teng:apply_relationship_trigger_set(query_sima_yue, "3k_main_relationship_trigger_set_startpos_family_member");

        modify_sima_lue:apply_relationship_trigger_set(query_sima_mo, "3k_main_relationship_trigger_set_event_positive_generic_extreme");
        modify_sima_lue:apply_relationship_trigger_set(query_sima_yue, "3k_main_relationship_trigger_set_event_positive_generic_extreme");

        modify_sima_lue:apply_relationship_trigger_set(query_sima_mo, "3k_main_relationship_trigger_set_startpos_family_member");
        modify_sima_lue:apply_relationship_trigger_set(query_sima_yue, "3k_main_relationship_trigger_set_startpos_family_member");

        modify_sima_mo:apply_relationship_trigger_set(query_sima_yue, "3k_main_relationship_trigger_set_event_positive_generic_extreme");

        modify_sima_mo:apply_relationship_trigger_set(query_sima_yue, "3k_main_relationship_trigger_set_startpos_family_member");


        -- 设定同盟
        diplomacy_manager:apply_automatic_deal_between_factions("ep_faction_prince_of_longxi", "ep_faction_prince_of_xihe", "data_defined_situation_join_alliance_proposer",true);


    --NOTE 吾彦(雁门太守） mod_main_template_historical_wu_yan_earth

        query_faction_of_yanmen = cm:query_faction("ep_faction_yanmen");

        mod_set_region_manager("3k_main_yanmen_capital","ep_faction_yanmen")
        mod_set_region_manager("3k_main_yanmen_resource_1","ep_faction_yanmen")
        
        modify_wu_yan = cm:modify_faction("ep_faction_yanmen"):create_character_from_template("general", "3k_general_earth", "mod_main_template_historical_wu_yan_earth", false);
        query_wu_yan = modify_wu_yan:query_character();
        modify_wu_yan:assign_faction_leader();
        
        -- 设置军队
        found_pos, x, y = query_faction_of_yanmen:get_valid_spawn_location_in_region("3k_main_yanmen_capital", false);        
        if found_pos then        
            cm:create_force_with_existing_general(query_wu_yan:command_queue_index(), "ep_faction_yanmen", "", "3k_main_yanmen_capital", x, y, "wuyan_force", nil, 100);
            local modify_wu_yan_force = cm:modify_model():get_modify_military_force(query_wu_yan:military_force());
        end;

        -- 设置外交
        diplomacy_manager:apply_automatic_deal_between_factions("ep_faction_prince_of_xihe", "ep_faction_yanmen", "data_defined_situation_vassalise_recipient_no_requirements",true)



    --NOTE 贾疋 mod_main_template_historical_jia_ya_earth

        mod_set_region_manager("3k_main_anding_resource_3","ep_faction_anding")
        mod_set_region_manager("3k_main_shoufang_resource_3","ep_faction_anding")

        query_faction_of_anding = cm:query_faction("ep_faction_anding");

        modify_jia_ya = cm:modify_faction("ep_faction_anding"):create_character_from_template("general", "3k_general_earth", "mod_main_template_historical_jia_ya_earth", false);
        query_jia_ya = modify_jia_ya:query_character();
        modify_jia_ya:assign_faction_leader();

        -- 编辑特性
        mod_remove_all_trait(query_jia_ya);
        modify_jia_ya:ceo_management():add_ceo("3k_main_ceo_trait_personality_clever"); -- 足智多谋
        modify_jia_ya:ceo_management():add_ceo("3k_main_ceo_trait_personality_brilliant"); -- 天纵英才
        modify_jia_ya:ceo_management():add_ceo("3k_ytr_ceo_trait_personality_benevolent"); -- 品行高尚
        
        modify_jia_ya:ceo_management():remove_ceos("3k_main_ceo_career_generated_general_earth");
        modify_jia_ya:ceo_management():add_ceo("3k_main_ceo_career_historical_liu_yan"); -- 待机而动

        -- 设置和司马模关系
        modify_jia_ya:apply_relationship_trigger_set(query_sima_mo, "3k_main_relationship_trigger_set_event_negative_generic_extreme");

        -- 设置初始成员A
        modify_anding_char_a = cm:modify_faction("ep_faction_anding"):create_character_from_template( "general", "3k_general_metal", "ep_template_generic_metal_minister_normal_m_hero", false);
        modify_anding_char_a:assign_to_post("3k_main_court_offices_minister_earth");
        modify_jia_ya:apply_relationship_trigger_set(modify_anding_char_a:query_character(), "3k_main_relationship_trigger_set_event_positive_generic_extreme");

        -- 设置初始成员B
        modify_anding_char_b = cm:modify_faction("ep_faction_anding"):create_character_from_template( "general", "3k_general_water", "3k_main_template_generic_water_agent_normal_f_hero", false);
        modify_jia_ya:apply_relationship_trigger_set(modify_anding_char_b:query_character(), "3k_main_relationship_trigger_set_event_positive_generic_extreme");

        -- 设置军队，并让A和B加入

        found_pos, x, y = query_faction_of_anding:get_valid_spawn_location_in_region("3k_main_anding_resource_3", false);        
        if found_pos then        
            cm:create_force_with_existing_general(query_jia_ya:command_queue_index(), "ep_faction_anding", "", "3k_main_anding_resource_3", x, y, "jiaya_force", nil, 100);
            local modify_jia_ya_force = cm:modify_model():get_modify_military_force(query_jia_ya:military_force());
            
            -- 添加随机将领A和B
            modify_jia_ya_force:add_existing_character_as_retinue(modify_anding_char_a, true);
            modify_jia_ya_force:add_existing_character_as_retinue(modify_anding_char_b, true);
        end;


    -- 测试




    -- 清理角色

        mod_kill_character("mod_main_template_historical_huangfu_kui_metal");
        mod_kill_character("mod_main_template_historical_huangfu_zhen_water");
        mod_kill_character("3k_main_template_historical_huangfu_mi_hero_water");
        mod_kill_character("ep_template_historical_liu_shen_hero_wood");
                
        mod_kill_character("3k_main_template_historical_liu_fu_hero_water"); -- 刘馥，刘弘祖父
        mod_kill_character("3k_main_template_historical_liu_jing_hero_fire"); -- 刘靖，刘弘父
                
        mod_kill_character("ep_template_historical_sima_mo_hero_fire"); -- 司马模
        mod_kill_character("ep_template_historical_sima_chi_hero_water");
        mod_kill_character("mod_main_template_historical_sima_jin_wood");
        mod_kill_character("ep_template_historical_sima_rui_hero_earth_langye");
        mod_kill_character("ep_template_historical_sima_gan_hero_metal");
        mod_kill_character("ep_template_historical_sima_dan_hero_earth");
        
        mod_kill_character("mod_main_template_historical_sima_zhou_fire"); -- 司马伷
        mod_kill_character("mod_main_template_historical_sima_jun_metal"); -- 司马骏
        mod_kill_character("mod_template_historical_sima_shi_hero_earth"); -- 司马师
        mod_kill_character("mod_template_historical_sima_zhao_hero_earth"); -- 司马昭
        mod_kill_character("mod_main_template_historical_sima_fu_water");  -- 司马辅
        mod_kill_character("mod_main_template_historical_sima_sui_wood"); -- 司马随
        modify_sima_sui_fanyang:kill_character(false); -- 司马绥
        
        mod_kill_character("3k_main_template_historical_sima_fu_hero_water"); -- 司马孚
        modify_sima_kui:kill_character(false); -- 司马馗
        mod_kill_character("mod_main_template_historical_sima_xun_water"); -- 司马恂
        
        mod_kill_character("3k_main_template_historical_sima_fang_hero_water"); -- 司马防
        
        
    -- 关闭细作
        
        
    end;








    -- 后置基础设定


    -- 初始化随机技能
    --[[
    if cm:query_model():campaign_game_mode() == "romance" then
    
        valid_subtype = {"3k_general_metal", "3k_general_wood", "3k_general_water", "3k_general_fire", "3k_general_earth"};

        cm:query_model():world():faction_list():filter(function(filter_faction)
            return not filter_faction:is_dead()
        end):foreach(function(filter_faction)
            for i = 0, filter_faction:character_list():num_items() - 1 do
                ModLog("-----------------------------------------------------------------------------------");
                ModLog("zph_generic_random_skill. INITIAL GAME TRIGGER");

                query_character = filter_faction:character_list():item_at(i)


                if zph_generic_random_skill:is_valid_character(query_character)
                    and table.is_empty(zph_generic_random_skill:own_ability_list(query_character))
                    then
                    
                        ModLog("zph_generic_random_skill. valid_character.");
                        zph_generic_random_skill:main(query_character);

                end;
            end;
        end);

    end;
    ]]--


end;
local gst = xyy_gst:get_mod()
cm:add_first_tick_callback(function() zph_special_unit_region() end);

function zph_special_unit_region()
    
--test
--[[
    mod_set_region_manager("3k_main_chenjun_capital","3k_main_faction_tao_qian")
    mod_set_region_manager("3k_main_chenjun_resource_1","3k_main_faction_tao_qian")
    mod_set_region_manager("3k_main_chenjun_resource_2","3k_main_faction_tao_qian")
    mod_set_region_manager("3k_main_anping_resource_1","3k_main_faction_tao_qian")    
    mod_set_region_manager("3k_main_xiangyang_resource_1","3k_main_faction_tao_qian")
    
    mod_character_add("3k_dlc04_template_historical_luo_jun_xiaoyuan_wood", "3k_main_faction_tao_qian", "3k_general_water")
    mod_character_add("3k_main_template_historical_gao_shun_hero_fire", "3k_main_faction_tao_qian", "3k_general_fire")
    mod_character_add("3k_main_template_historical_wang_can_hero_water", "3k_main_faction_tao_qian", "3k_general_water")
]]--
    
--type 1
    --main    
    zph_mod_region_unlock(1, {"3k_dlc06_xiapi_capital"}, "3k_dlc04_unit_water_territorial_archer","3k_main_faction_tao_qian")
    zph_mod_region_unlock(1, {"3k_main_penchang_capital"}, "3k_dlc04_unit_wood_territorial_spearmen","3k_main_faction_tao_qian")
    zph_mod_region_unlock(1, {"3k_main_chenjun_capital"}, "3k_main_unit_fire_tiger_and_leopard_cavalry","3k_main_faction_cao_cao")   
    zph_mod_region_unlock(1, {"3k_main_shoufang_resource_1"}, "3k_main_unit_fire_xiliang_cavalry","3k_main_faction_dong_zhuo")
    zph_mod_region_unlock(1, {"3k_main_beihai_capital"}, "3k_main_unit_water_fury_of_beihai","3k_main_faction_kong_rong")
    zph_mod_region_unlock(1, {"3k_main_chengdu_capital"}, "3k_main_unit_water_yi_archers","3k_main_faction_liu_bei")
    zph_mod_region_unlock(1, {"3k_main_xiangyang_capital"}, "3k_main_unit_wood_infantry_of_jing","3k_main_faction_liu_biao")
    
    zph_mod_region_unlock(1, {"3k_main_wudu_capital"}, "3k_main_unit_water_qiang_hunters","3k_main_faction_ma_teng")
    zph_mod_region_unlock(1, {"3k_main_jincheng_capital"}, "3k_main_unit_fire_qiang_marauders","3k_main_faction_ma_teng")
    zph_mod_region_unlock(1, {"3k_main_wuwei_capital"}, "3k_main_unit_earth_qiang_raiders","3k_main_faction_ma_teng")
    
    zph_mod_region_unlock(1, {"3k_main_weijun_capital"}, "3k_main_unit_wood_warriors_of_ye","3k_main_faction_yuan_shao")
    zph_mod_region_unlock(1, {"3k_main_nanyang_capital"}, "3k_main_unit_metal_rapid_tiger_infantry","3k_main_faction_yuan_shu")
    zph_mod_region_unlock(1, {"3k_main_youbeiping_capital"}, "3k_main_unit_water_white_horse_raiders","3k_main_faction_gongsun_zan")

    --ep   
    zph_mod_region_unlock(1, {"3k_main_xiangyang_capital"}, "3k_main_unit_wood_infantry_of_jing","ep_faction_prince_of_changsha")
    zph_mod_region_unlock(1, {"3k_main_jiangxia_capital"}, "ep_unit_water_archers_of_jing","ep_faction_prince_of_changsha")
    zph_mod_region_unlock(1, {"3k_main_donghai_capital"}, "ep_unit_metal_xu_raiders","ep_faction_prince_of_donghai")
    zph_mod_region_unlock(1, {"3k_main_daijun_capital"}, "ep_unit_fire_xianbei_riders","ep_faction_prince_of_hejian")
    zph_mod_region_unlock(1, {"3k_main_youzhou_capital"}, "ep_unit_water_xianbei_horse_archers","ep_faction_prince_of_hejian")
    zph_mod_region_unlock(1, {"3k_main_luoyang_capital"}, "ep_unit_metal_imperial_guards","ep_faction_prince_of_runan")
    zph_mod_region_unlock(1, {"3k_main_xihe_capital"}, "ep_unit_fire_xiongnu_cavalry","ep_faction_prince_of_zhao")
    
    
    --乌桓枪骑：西河
    zph_mod_region_unlock(1, {"3k_main_xihe_capital"}, "wuhuan","xyyhlyja")
    
    --红缨铁骑：颍川
    zph_mod_region_unlock(1, {"3k_main_yingchuan_capital"}, "hongying","3k_main_faction_cao_cao")
    
    --战场女武神：洛阳
    zph_mod_region_unlock(1, {"3k_main_luoyang_capital"}, "hldanwei1","3k_main_faction_lu_bu")
    
    --火凤凰：长安
    zph_mod_region_unlock(1, {"3k_main_changan_capital"}, "hldanwei2","3k_main_faction_dong_zhuo")
    
    --天龙帮弩手：江夏
    zph_mod_region_unlock(1, {"3k_main_jiangxia_capital"}, "hldanwei3","3k_main_faction_sun_jian")
    
    --天龙帮弩骑：江夏
    zph_mod_region_unlock(1, {"3k_main_jiangxia_capital"}, "hldanwei4","3k_main_faction_sun_jian")
    
    --俗昆仑虎捷军：武都
    zph_mod_region_unlock(1, {"3k_main_wudu_capital"}, "hldanwei5","3k_main_faction_ma_teng")
    
    --环珠楼杀手：云南
    zph_mod_region_unlock(1, {"3k_dlc06_yunnan_capital"}, "hldanwei6","3k_dlc06_faction_yunnan")
    
    --凌霄禁卫：乐安（泰山）
    zph_mod_region_unlock(1, {"3k_main_taishan_capital"}, "lingxiao","3k_main_faction_taishan")
    
    --怡溪灵卫：长沙
    zph_mod_region_unlock(1, {"3k_main_changsha_capital"}, "yixi","3k_main_faction_sun_jian")
    

 --type 2
    --main
    zph_mod_region_unlock(1, {"3k_main_shoufang_capital","3k_main_shoufang_resource_1","3k_main_shoufang_resource_2","3k_main_shoufang_resource_3"}, "3k_main_unit_fire_heavy_xiliang_cavalry","3k_main_faction_dong_zhuo")
    zph_mod_region_unlock(1, {"3k_main_chengdu_capital","3k_main_chengdu_resource_1","3k_main_chengdu_resource_2","3k_main_chengdu_resource_3"}, "3k_main_unit_water_yi_marksmen","3k_main_faction_liu_bei")
    zph_mod_region_unlock(1, {"3k_main_changan_capital","3k_main_changan_resource_1","3k_dlc06_wu_pass","3k_dlc06_san_pass"}, "3k_dlc04_unit_wood_defenders_of_the_empire","3k_dlc04_faction_lu_zhi")    
    zph_mod_region_unlock(1, {"3k_main_chenjun_capital","3k_main_chenjun_resource_1","3k_main_chenjun_resource_2"}, "3k_dlc04_unit_earth_chen_peacekeepers","3k_dlc04_faction_prince_liu_chong")    
    zph_mod_region_unlock(1, {"3k_main_weijun_capital","3k_main_weijun_resource_1","3k_main_anping_capital","3k_main_anping_resource_1"}, "3k_main_unit_wood_defenders_of_hebei","3k_main_faction_yuan_shao")
    zph_mod_region_unlock(1, {"3k_main_nanyang_capital","3k_main_nanyang_resource_1","3k_main_runan_capital","3k_main_runan_resource_1"}, "3k_main_unit_metal_warriors_of_the_left","3k_main_faction_yuan_shu")    
    zph_mod_region_unlock(1, {"3k_main_donghai_capital","3k_main_donghai_resource_1","3k_main_guangling_capital","3k_main_guangling_resource_1","3k_main_guangling_resource_2"}, "ep_unit_metal_warriors_of_xu","ep_faction_prince_of_donghai")
    zph_mod_region_unlock(1, {"3k_main_xihe_capital","3k_main_xihe_resource_1","3k_main_hedong_capital","3k_main_hedong_resource_1","3k_dlc06_hedong_resource_2"}, "ep_unit_fire_xiongnu_cataphracts","ep_faction_prince_of_zhao")    
    zph_mod_region_unlock(1, {"3k_main_shangyong_capital","3k_main_shangyong_resource_1","3k_main_shangyong_resource_2"}, "3k_dlc05_unit_fire_formation_breakers","3k_main_faction_lu_bu")
    zph_mod_region_unlock(1, {"3k_main_cangwu_capital","3k_main_cangwu_resource_1","3k_main_cangwu_resource_2","3k_main_cangwu_resource_3"}, "3k_dlc05_unit_wood_tiger_guard","3k_dlc05_faction_sun_ce")   
    
    --ep
    zph_mod_region_unlock(1, {"3k_main_luoyang_capital","3k_main_luoyang_resource_1","3k_main_chenjun_resource_3"}, "ep_unit_metal_imperial_guards","ep_faction_prince_of_runan")
    zph_mod_region_unlock(1, {"3k_main_poyang_capital","3k_main_poyang_resource_1","3k_main_poyang_resource_2","3k_main_poyang_resource_3"}, "ep_unit_metal_chu_infantry","ep_faction_prince_of_chu")
    zph_mod_region_unlock(1, {"3k_main_yuzhang_capital","3k_main_yuzhang_resource_1","3k_main_yuzhang_resource_2"}, "ep_unit_wood_chu_spearmen","ep_faction_prince_of_chu")
    zph_mod_region_unlock(1, {"3k_main_pingyuan_capital","3k_main_pingyuan_resource_1","3k_main_taishan_capital","3k_main_taishan_resource_1"}, "ep_unit_water_qi_crossbowmen","ep_faction_prince_of_qi")
    zph_mod_region_unlock(1, {"3k_main_langye_capital","3k_main_langye_resource_1","3k_main_langye_resource_2"}, "ep_unit_wood_qi_guardsmen","ep_faction_prince_of_qi")
    
--type 3

    zph_mod_region_unlock(2, {"3k_main_yingchuan_capital","3k_main_yingchuan_resource_1"}, "3k_main_unit_fire_heavy_tiger_and_leopard_cavalry", "3k_main_faction_cao_cao",
{"3k_main_template_historical_cao_chun_hero_fire","3k_main_template_historical_cao_xiu_hero_fire","3k_main_template_historical_cao_zhen_hero_earth","3k_main_template_historical_cao_ren_hero_earth","3k_main_template_historical_cao_ang_hero_wood"})

    zph_mod_region_unlock(2, {"3k_main_dongjun_capital","3k_main_dongjun_resource_1"}, "3k_dlc05_unit_metal_camp_crushers", "3k_main_faction_lu_bu",
{"3k_main_template_historical_gao_shun_hero_fire","3k_main_template_historical_zhang_liao_hero_metal","3k_main_template_historical_lu_bu_hero_fire","3k_dlc05_template_historical_lu_lingqi_hero_metal","3k_dlc05_template_historical_hou_cheng_hero_wood"})

    zph_mod_region_unlock(2, {"3k_main_changsha_resource_1"}, "3k_dlc05_unit_earth_handmaid_guard", "3k_dlc05_faction_sun_ce",
{"3k_main_template_historical_lady_sun_shangxiang_hero_fire","3k_main_template_historical_xin_xianying_hero_water","3k_main_template_historical_wang_yuanji_hero_earth","3k_main_template_historical_lady_guan_yinping_hero_wood","3k_main_template_historical_fu_shou_hero_earth","3k_main_template_historical_lady_huang_yueying_hero_wood"})
    
    zph_mod_region_unlock(2, {"3k_dlc06_hulao_pass"}, "3k_dlc04_unit_fire_destroyer_of_traitors", "3k_dlc04_faction_lu_zhi",
{"3k_dlc04_template_historical_lu_zhi_hero_water","3k_main_template_historical_huangfu_song_hero_metal","3k_main_template_historical_zhu_jun_hero_fire"})
    
    zph_mod_region_unlock(2, {"3k_main_youbeiping_capital","3k_main_youbeiping_resource_1"}, "3k_main_unit_water_white_horse_fellows", "3k_main_faction_gongsun_zan",
{"3k_main_template_historical_gongsun_zan_hero_fire","3k_main_template_historical_gongsun_yue_hero_fire","3k_main_template_historical_gongsun_xu_hero_metal","3k_main_template_historical_zhao_yun_hero_metal","3k_main_template_historical_yan_gang_hero_metal"})
    
    zph_mod_region_unlock(2, {"3k_main_weijun_capital","3k_main_weijun_resource_1"}, "3k_main_unit_water_thunder_of_jian_an", "3k_main_faction_kong_rong",
{"3k_main_template_historical_kong_rong_hero_water","3k_main_template_historical_chen_lin_hero_water","3k_main_template_historical_wang_can_hero_water","3k_main_template_historical_xu_gan_hero_water","3k_main_template_historical_ruan_yu_hero_water","3k_main_template_historical_ying_yang_hero_water","3k_main_template_historical_liu_zhen_hero_water"})    
    
    zph_mod_region_unlock(2, {"3k_main_xiangyang_capital","3k_main_xiangyang_resource_1"}, "3k_main_unit_wood_imperial_defenders", "3k_main_faction_liu_biao",
{"3k_main_template_historical_kuai_liang_hero_water","3k_main_template_historical_pang_tong_hero_water","3k_main_template_historical_cai_mao_hero_fire","3k_main_template_historical_huang_zu_hero_wood","3k_main_template_historical_ma_liang_hero_water","3k_main_template_historical_xi_zhen_hero_fire","3k_main_template_historical_yang_yi_hero_fire"})

    zph_mod_region_unlock(2, {"3k_main_chenjun_capital","3k_main_chenjun_resource_1","3k_main_chenjun_resource_2"}, "3k_dlc04_unit_water_chen_royal_guard", "3k_dlc04_faction_prince_liu_chong",
{"3k_main_template_historical_liu_chong_hero_earth","3k_dlc04_template_historical_luo_jun_xiaoyuan_wood"})
    
    
end;

-- TODO: 加入新兵种

------------------------------------------------------------------------------------------------------------------------------------------


function zph_mod_region_unlock(mode, region_key, unit_key, faction_key, character_key)
    core:add_listener(
        "mod_region_unlock_listener_" .. unit_key,
        "FactionTurnStart",
            
        function(context)
            return not context:faction():is_dead()
            and not (cm:get_saved_value("hlyjdingzhiafujian") and cm:get_saved_value("hlyjdingzhiafujian") == context:faction():name())
        end,

        function(context)
            local query_faction = context:faction()
            -- ModLog("该派系为 " .. query_faction:name())

            if cm:query_model():turn_number() == 1 then
                cm:modify_faction(query_faction):add_event_restricted_unit_record(unit_key)
            end
            
            --ModLog("————————————————————————————————————————")
            --ModLog("script unlock_region_unit start!")
            local function faction_owning_region(region_list, faction_name)
                for _,region in ipairs(region_list) do
                    if cm:query_region(region):owning_faction():name() ~= faction_name then
                        return false
                    end
                    -- ModLog("确认派系 " .. faction_name .." 含有土地 " .. region)
                end

                return true
            end
            
            local function faction_owning_character(characters, faction_name)
                for _, character in ipairs(characters) do
                    if cm:query_model():character_for_template(character_key)
                       and not cm:query_model():character_for_template(character_key):is_null_interface()
                       and not cm:query_model():character_for_template(character_key):is_dead() then
                        --ModLog("current char check: "..character_key)
                        if cm:query_model():character_for_template(character_key):faction():name() == faction_name then
                            -- ModLog("派系 " .. faction_name .. " 中存在角色 " ..character_key)
                            return true
                        end
                    end
                end
            end

            
            --ModLog("current mode: "..mode)
            --ModLog("current unit: " ..unit_key)    
            --ModLog("current faction: " ..query_faction:name())
    
            -- cm:modify_faction(query_faction):remove_event_restricted_unit_record(unit_key)
            --ModLog("reset unit to unlock")

            if query_faction:subculture() == "3k_main_chinese" then
                if context:faction():name() == faction_key then
                    cm:modify_faction(query_faction):remove_event_restricted_unit_record(unit_key)
                    -- ModLog("为含有兵种的原生派系直接解锁" .. unit_key)
                else
                    if mode == 2 and faction_owning_region(region_key, query_faction:name()) 
                    and faction_owning_character(character_key, query_faction:name()) then
                        cm:modify_faction(query_faction):remove_event_restricted_unit_record(unit_key)
                        -- ModLog("通过mode2为派系解锁" .. unit_key)
                    elseif faction_owning_region(region_key, query_faction:name()) then
                        cm:modify_faction(query_faction):remove_event_restricted_unit_record(unit_key)
                        -- ModLog("通过mode1为派系解锁" .. unit_key)
                    else --不符合解锁条件，重新锁定
                        cm:modify_faction(query_faction):add_event_restricted_unit_record(unit_key) 
                    end
                end

            else
                cm:modify_faction(query_faction):remove_event_restricted_unit_record(unit_key)
                --ModLog("unlock unit for non-han faction")
            end
            --ModLog("mod_region_unlock execution is completed")
            --ModLog("————————————————————————————————————————")     
            
            if query_faction:is_human() 
            or not cm:get_saved_value("roguelike_mode")
            then
                return;
            end
        
--             cm:modify_faction(query_faction):unlock_technology("3k_main_tech_water_tier3_hostels") 
--             cm:modify_faction(query_faction):unlock_technology("3k_ytr_tech_yellow_turban_heaven_3_3") 
            
            if query_faction:has_effect_bundle("xyy_roguelike_enemy_earth_1")
            or query_faction:has_effect_bundle("xyy_roguelike_enemy_earth_2")
            or query_faction:has_effect_bundle("xyy_roguelike_enemy_earth_3")
            or query_faction:has_effect_bundle("xyy_roguelike_enemy_earth_4")
            or query_faction:has_effect_bundle("xyy_roguelike_enemy_earth_5")
            or query_faction:has_effect_bundle("xyy_roguelike_enemy_earth_6")
            then
                cm:modify_faction(query_faction):remove_event_restricted_unit_record("3k_dlc04_unit_water_chen_royal_guard")
                cm:modify_faction(query_faction):remove_event_restricted_unit_record("3k_dlc04_unit_earth_chen_peacekeepers")
                cm:modify_faction(query_faction):remove_event_restricted_unit_record("3k_dlc04_unit_earth_imperial_household_cavalry")
                cm:modify_faction(query_faction):remove_event_restricted_unit_record("xyyhlyjbbuqu2")
                cm:modify_faction(query_faction):remove_event_restricted_unit_record("xyyhlyjbbuqu3")
                cm:modify_faction(query_faction):remove_event_restricted_unit_record("wuhuan")
                cm:modify_faction(query_faction):remove_event_restricted_unit_record("longpao")
                cm:modify_faction(query_faction):remove_event_restricted_unit_record("hldanwei6")
            else
                cm:modify_faction(query_faction):add_event_restricted_unit_record("3k_dlc04_unit_water_chen_royal_guard")
                cm:modify_faction(query_faction):add_event_restricted_unit_record("3k_dlc04_unit_earth_chen_peacekeepers")
                cm:modify_faction(query_faction):add_event_restricted_unit_record("3k_dlc04_unit_earth_imperial_household_cavalry")
                cm:modify_faction(query_faction):add_event_restricted_unit_record("xyyhlyjbbuqu2")
                cm:modify_faction(query_faction):add_event_restricted_unit_record("xyyhlyjbbuqu3")
                cm:modify_faction(query_faction):add_event_restricted_unit_record("wuhuan")
                cm:modify_faction(query_faction):add_event_restricted_unit_record("longpao")
                cm:modify_faction(query_faction):add_event_restricted_unit_record("hldanwei6")
            end
            
            if query_faction:has_effect_bundle("xyy_roguelike_enemy_fire_1")
            or query_faction:has_effect_bundle("xyy_roguelike_enemy_fire_2")
            or query_faction:has_effect_bundle("xyy_roguelike_enemy_fire_3")
            or query_faction:has_effect_bundle("xyy_roguelike_enemy_fire_4")
            or query_faction:has_effect_bundle("xyy_roguelike_enemy_fire_5")
            or query_faction:has_effect_bundle("xyy_roguelike_enemy_fire_6")
            then
                cm:modify_faction(query_faction):remove_event_restricted_unit_record("3k_dlc05_unit_fire_formation_breakers")
                cm:modify_faction(query_faction):remove_event_restricted_unit_record("3k_dlc04_unit_fire_imperial_lancer_cavalry")
                cm:modify_faction(query_faction):remove_event_restricted_unit_record("3k_dlc04_unit_fire_destroyer_of_traitors")
                cm:modify_faction(query_faction):remove_event_restricted_unit_record("xyyhlyjbbuqu5")
                cm:modify_faction(query_faction):remove_event_restricted_unit_record("xyyhlyjbbuqu3")
                cm:modify_faction(query_faction):remove_event_restricted_unit_record("hongying")
                cm:modify_faction(query_faction):remove_event_restricted_unit_record("hldanwei1")
                cm:modify_faction(query_faction):remove_event_restricted_unit_record("yixi")
            else
                cm:modify_faction(query_faction):add_event_restricted_unit_record("3k_dlc04_unit_fire_imperial_lancer_cavalry")
                cm:modify_faction(query_faction):add_event_restricted_unit_record("3k_dlc05_unit_fire_formation_breakers")
                cm:modify_faction(query_faction):add_event_restricted_unit_record("3k_dlc04_unit_fire_destroyer_of_traitors")
                cm:modify_faction(query_faction):add_event_restricted_unit_record("xyyhlyjbbuqu5")
                cm:modify_faction(query_faction):add_event_restricted_unit_record("xyyhlyjbbuqu3")
                cm:modify_faction(query_faction):add_event_restricted_unit_record("hongying")
                cm:modify_faction(query_faction):add_event_restricted_unit_record("hldanwei1")
                cm:modify_faction(query_faction):add_event_restricted_unit_record("yixi")
            end
            
            if query_faction:has_effect_bundle("xyy_roguelike_enemy_metal_1")
            or query_faction:has_effect_bundle("xyy_roguelike_enemy_metal_2")
            or query_faction:has_effect_bundle("xyy_roguelike_enemy_metal_3")
            or query_faction:has_effect_bundle("xyy_roguelike_enemy_metal_4")
            or query_faction:has_effect_bundle("xyy_roguelike_enemy_metal_5")
            or query_faction:has_effect_bundle("xyy_roguelike_enemy_metal_6")
            then
                cm:modify_faction(query_faction):remove_event_restricted_unit_record("3k_dlc04_unit_metal_imperial_sword_guard")
                cm:modify_faction(query_faction):remove_event_restricted_unit_record("3k_dlc05_unit_metal_camp_crushers")
                cm:modify_faction(query_faction):remove_event_restricted_unit_record("3k_main_unit_metal_rapid_tiger_infantry")
                cm:modify_faction(query_faction):remove_event_restricted_unit_record("xyyhlyjbbuqu1")
                cm:modify_faction(query_faction):remove_event_restricted_unit_record("xyyhlyjbbuqu3")
                cm:modify_faction(query_faction):remove_event_restricted_unit_record("hongying")
                cm:modify_faction(query_faction):remove_event_restricted_unit_record("hldanwei2")
            else
                cm:modify_faction(query_faction):add_event_restricted_unit_record("3k_dlc04_unit_metal_imperial_sword_guard")
                cm:modify_faction(query_faction):add_event_restricted_unit_record("3k_dlc05_unit_metal_camp_crushers")
                cm:modify_faction(query_faction):add_event_restricted_unit_record("3k_main_unit_metal_rapid_tiger_infantry")
                cm:modify_faction(query_faction):add_event_restricted_unit_record("xyyhlyjbbuqu1")
                cm:modify_faction(query_faction):add_event_restricted_unit_record("xyyhlyjbbuqu3")
                cm:modify_faction(query_faction):add_event_restricted_unit_record("hongying")
                cm:modify_faction(query_faction):add_event_restricted_unit_record("hldanwei2")
            end
            
            if query_faction:has_effect_bundle("xyy_roguelike_enemy_water_1")
            or query_faction:has_effect_bundle("xyy_roguelike_enemy_water_2")
            or query_faction:has_effect_bundle("xyy_roguelike_enemy_water_3")
            or query_faction:has_effect_bundle("xyy_roguelike_enemy_water_4")
            or query_faction:has_effect_bundle("xyy_roguelike_enemy_water_5")
            or query_faction:has_effect_bundle("xyy_roguelike_enemy_water_6")
            then
                cm:modify_faction(query_faction):remove_event_restricted_unit_record("3k_dlc04_unit_water_chen_royal_guard")
                cm:modify_faction(query_faction):remove_event_restricted_unit_record("3k_dlc04_unit_water_territorial_archer")
                cm:modify_faction(query_faction):remove_event_restricted_unit_record("3k_main_unit_water_fury_of_beihai")
                cm:modify_faction(query_faction):remove_event_restricted_unit_record("xyyhlyjbbuqu6")
                cm:modify_faction(query_faction):remove_event_restricted_unit_record("xyyhlyjbbuqu7")
                cm:modify_faction(query_faction):remove_event_restricted_unit_record("xyyhlyjbbuqu3")
                cm:modify_faction(query_faction):remove_event_restricted_unit_record("hldanwei3")
                cm:modify_faction(query_faction):remove_event_restricted_unit_record("hldanwei4")
                cm:modify_faction(query_faction):remove_event_restricted_unit_record("hldanwei5")
                cm:modify_faction(query_faction):remove_event_restricted_unit_record("longpao")
                cm:modify_faction(query_faction):remove_event_restricted_unit_record("yixi")
            else
                cm:modify_faction(query_faction):add_event_restricted_unit_record("3k_dlc04_unit_water_chen_royal_guard")
                cm:modify_faction(query_faction):add_event_restricted_unit_record("3k_dlc04_unit_water_territorial_archer")
                cm:modify_faction(query_faction):add_event_restricted_unit_record("3k_main_unit_water_fury_of_beihai")
                cm:modify_faction(query_faction):add_event_restricted_unit_record("xyyhlyjbbuqu6")
                cm:modify_faction(query_faction):add_event_restricted_unit_record("xyyhlyjbbuqu7")
                cm:modify_faction(query_faction):add_event_restricted_unit_record("xyyhlyjbbuqu3")
                cm:modify_faction(query_faction):add_event_restricted_unit_record("hldanwei3")
                cm:modify_faction(query_faction):add_event_restricted_unit_record("hldanwei4")
                cm:modify_faction(query_faction):add_event_restricted_unit_record("hldanwei5")
                cm:modify_faction(query_faction):add_event_restricted_unit_record("longpao")
                cm:modify_faction(query_faction):add_event_restricted_unit_record("yixi")
            end
            
        end,
        true
    )

    core:add_listener(
        "mod_ceo_unlock_" .. unit_key,
        "CharacterCeoEquipped",
        function(context)
            return context:ceo_equipment_slot():category_key() == "3k_main_ceo_category_ancillary_accessory";
        end,
        function(context)
            local query_character = context:query_character(); 
            local character_modifier = context:modify_character(); 
            local query_faction = context:query_character():faction()
            if query_character:ceo_management():has_ceo_equipped("hlyjdingzhiafujian") then
                cm:modify_faction(query_faction):remove_event_restricted_unit_record(unit_key)
                cm:set_saved_value("hlyjdingzhiafujian", query_faction:name())
            end
        end,
        true
    )
end;    

core:add_listener(
    "mod_ceo_unlock",
    "CharacterCeoEquipped",
    function(context)
        return context:ceo_equipment_slot():category_key() == "3k_main_ceo_category_ancillary_accessory";
    end,
    function(context)
        local query_character = context:query_character(); 
        local character_modifier = context:modify_character(); 
        if query_character:ceo_management():has_ceo_equipped("hlyjdingzhiafujian") then
            cm:set_saved_value("hlyjdingzhiafujian", context:query_character():faction():name())
            cm:modify_faction(context:query_character():faction()):remove_event_restricted_unit_record("hlyjdingzhiedanwei")
            cm:modify_faction(context:query_character():faction()):remove_event_restricted_unit_record("hlyjdingzhifdanwei")
            cm:modify_faction(context:query_character():faction()):remove_event_restricted_unit_record("xyyhlyjbbuqu1")
            cm:modify_faction(context:query_character():faction()):remove_event_restricted_unit_record("xyyhlyjbbuqu2")
            cm:modify_faction(context:query_character():faction()):remove_event_restricted_unit_record("xyyhlyjbbuqu3")
            cm:modify_faction(context:query_character():faction()):remove_event_restricted_unit_record("xyyhlyjbbuqu4")
            cm:modify_faction(context:query_character():faction()):remove_event_restricted_unit_record("xyyhlyjbbuqu5")
            cm:modify_faction(context:query_character():faction()):remove_event_restricted_unit_record("xyyhlyjbbuqu6")
            cm:modify_faction(context:query_character():faction()):remove_event_restricted_unit_record("xyyhlyjbbuqu7")
        else
            cm:set_saved_value("hlyjdingzhiafujian", nil)
        end
    end,
    true
)
    
core:add_listener(
    "mod_ceo_lock",
    "CharacterCeoUnequipped",
    function(context)
        return context:ceo_equipment_slot():category_key() == "3k_main_ceo_category_ancillary_accessory";
    end,
    function(context)
        if cm:get_saved_value("hlyjdingzhiafujian") then
            cm:set_saved_value("hlyjdingzhiafujian", nil)
        end
    end,
    true
)

core:add_listener(
    "hlyjcm_unlock_listener",
    "FactionTurnStart",
    function(context)
        if not context:faction():is_dead() then
            return true
        end
    end,
    function(context)
        local query_faction = context:faction()
        
        ModLog("civil_war_point check ".. context:faction():name());
        
        cm:modify_faction(query_faction):add_event_restricted_unit_record("hlyjdingzhiedanwei")
        cm:modify_faction(query_faction):add_event_restricted_unit_record("hlyjdingzhifdanwei")
        
        local hlyjcm = cm:query_model():character_for_template("hlyjcm");
        if not hlyjcm
        or hlyjcm:is_null_interface() 
        or hlyjcm:is_dead()
        or hlyjcm:faction() ~= query_faction 
        or hlyjcm:is_character_is_faction_recruitment_pool() then
            return;
        end
        ModLog("- have raiden shogun");
        if hlyjcm:is_faction_leader() then
            cm:modify_faction(query_faction):remove_event_restricted_unit_record("hlyjdingzhiedanwei")
            cm:modify_faction(query_faction):remove_event_restricted_unit_record("hlyjdingzhifdanwei")
            cm:set_saved_value("raiden_shogun_unhappy", false);
            ModLog("- is faction leader")
            return;
        end
        local is_minister = false
        if hlyjcm:character_post()
        and not hlyjcm:character_post():is_null_interface()
        and hlyjcm:character_post():ministerial_position_record_key()
        and (
            hlyjcm:character_post():ministerial_position_record_key() == "3k_main_court_offices_prime_minister" 
            or hlyjcm:character_post():ministerial_position_record_key() == "3k_main_court_offices_prime_minister_liu_biao" 
            or hlyjcm:character_post():ministerial_position_record_key() == "3k_dlc06_court_offices_minister_prime_minister_shi_xie" 
            or hlyjcm:character_post():ministerial_position_record_key() == "3k_dlc05_court_offices_sun_ce_prime_minister" 
            or hlyjcm:character_post():ministerial_position_record_key() == "3k_dlc05_court_offices_minister_prime_minister" 
            or hlyjcm:character_post():ministerial_position_record_key() == "3k_dlc06_court_offices_nanman_minister_prime_minister" 
            or hlyjcm:character_post():ministerial_position_record_key() == "ep_prime_minister_sima_liang" 
            or hlyjcm:character_post():ministerial_position_record_key() == "ep_prime_minister_sima_ying" 
            or hlyjcm:character_post():ministerial_position_record_key() == "ep_prime_minister_sima_yue" 
            or hlyjcm:character_post():ministerial_position_record_key() == "ep_court_offices_prime_minister" 
            or hlyjcm:character_post():ministerial_position_record_key() == "faction_heir" 
            or hlyjcm:character_post():ministerial_position_record_key() == "3k_dlc04_court_offices_general_in_chief" 
            or hlyjcm:character_post():ministerial_position_record_key() == "3k_dlc04_court_offices_grand_tutor" 
            or hlyjcm:character_post():ministerial_position_record_key() == "3k_dlc04_court_offices_grand_excellency_of_works" 
            or hlyjcm:character_post():ministerial_position_record_key() == "3k_dlc04_court_offices_grand_commandant" 
            or hlyjcm:character_post():ministerial_position_record_key() == "3k_dlc04_court_offices_prime_minister"
        )
        then
            cm:modify_faction(query_faction):remove_event_restricted_unit_record("hlyjdingzhiedanwei")
            cm:modify_faction(query_faction):remove_event_restricted_unit_record("hlyjdingzhifdanwei")
            cm:set_saved_value("raiden_shogun_unhappy", false);
            ModLog("- is minister = ");
            is_minister = true
        end
            
        if (not cm:get_saved_value("generated_inazuma_1") or not hlyjcm:faction():is_human())
        and hlyjcm:faction():name() ~= "xyyhlyjf"
        then
            if cm:get_saved_value("roguelike_mode") then
                ModLog("- roguelike mode");
                return;
            end
            if cm:get_saved_value("raiden_shogun_unhappy") then
                local civil_war_point = cm:get_saved_value("raiden_shogun_unhappy")
                ModLog("civil_war_point = "..civil_war_point);
                if civil_war_point == 3 then
                    cm:modify_character(hlyjcm):apply_effect_bundle("kafka_lower_satisfaction", 1)
                    cm:set_saved_value("raiden_shogun_unhappy", civil_war_point + 1);
                elseif civil_war_point < 3 then
                    cm:set_saved_value("raiden_shogun_unhappy", civil_war_point + 1);
                elseif civil_war_point > 3 then
                    if query_faction:is_human() then
                        local region_list = query_faction:region_list()
                        if region_list:num_items() > 4 then
                            if not is_minister or cm:roll_random_chance(1) then
                                cm:trigger_dilemma(context:faction():name(),"raiden_mutiny", true);
                            end
                        end
                    else
                        if not is_minister or cm:roll_random_chance(30) then
                            generate_inazuma_civil_war_in_faction(query_faction:name())
                        end
                    end
                    ModLog("- civil_war_point = "..civil_war_point);
                    --cm:modify_character(hlyjcm):add_loyalty_effect("civil_war_event");
--                     if not query_faction:is_at_civil_war() then 
--                         cm:modify_model():force_civil_war(hlyjcm);
--                     end
                    --cm:set_saved_value("raiden_shogun_unhappy", false);
--                     if query_faction:is_at_civil_war() then 
--                         cm:set_saved_value("raiden_shogun_unhappy", false);
--                     end;
                end
            else
                cm:set_saved_value("raiden_shogun_unhappy", 1);
                ModLog("- civil_war_point = 1");
            end
        else
            cm:modify_character(hlyjcm):apply_effect_bundle("job_satisfaction_ignored", 1)
        end
    end,
    true
)

core:add_listener(
    "raiden_mutiny_choice",
    "DilemmaChoiceMadeEvent",
    function(context)
        return context:dilemma() ==  "raiden_mutiny" ;
    end,
    function(context)
        if context:choice() == 0 then
            gst.faction_set_minister_position("hlyjcm","faction_leader");
            local modify_hlyjcm = cm:modify_character(hlyjcm)
            local kujou_sara = gst.character_add_to_faction("hlyjdf", context:faction():name(), "3k_general_fire");
            local modify_hlyjdf = cm:modify_character(kujou_sara);
            gst.faction_set_minister_position("hlyjdf","faction_heir");
            modify_hlyjdf:add_experience(88000,0);
            modify_hlyjcm:apply_relationship_trigger_set(hlyjdf, "3k_dlc05_relationship_trigger_set_startpos_romance");
            modify_hlyjdf:apply_relationship_trigger_set(hlyjcm, "3k_dlc05_relationship_trigger_set_startpos_romance");
            cm:set_saved_value("generated_inazuma_1", true);
        elseif context:choice() == 1 then
            generate_inazuma_civil_war_in_faction(context:faction():name())
        end
    end,
    false
)

core:add_listener(
    "raiden_shogun_faction_leader",
    "CharacterBecomesFactionLeader",
    function(context)
        return true
    end,
    function(context) -- What to do if listener fires.
        if context:query_character():generation_template_key() == "hlyjcm" then
            cm:modify_faction(context:query_character():faction()):apply_effect_bundle("inazuma_debuff", -1)
        else
            cm:modify_faction(context:query_character():faction()):remove_effect_bundle("inazuma_debuff")
        end
    end,
    true
);

core:add_listener(
    "govenor_listener",
    "GovernorAssignedCharacterEvent",
    function(context)
        return context:query_character():generation_template_key() == "hlyjcm"
    end,
    function(context)
        cm:set_saved_value("govenor_hlyjcm", context:query_region():name())
    end,
    true
)

        
core:add_listener(
    "inazuma_AI",
    "FactionTurnStart",
    function(context)
        if context:faction():has_faction_leader()
        and context:faction():faction_leader():generation_template_key() == "hlyjcm" then
            return true
        else
            if context:faction():has_effect_bundle("inazuma_AI") then
                cm:modify_faction(context:faction()):remove_effect_bundle("inazuma_AI")
            end
        end
    end,
    function(context)
        if not cm:get_saved_value("generated_inazuma_1") then
            local civil_war_faction = context:faction():name()
            local hlyjcm = context:faction():faction_leader()
            local modify_hlyjcm = cm:modify_character(hlyjcm)
            if not context:faction():is_human() then
                cm:modify_faction(civil_war_faction):apply_effect_bundle("inazuma_AI", -1);
            end
            modify_hlyjcm:apply_effect_bundle("essentials_effect_bundle",-1);
            local hlyjdf = gst.character_add_to_faction("hlyjdf", civil_war_faction, "3k_general_fire");
            local modify_hlyjdf = cm:modify_character(hlyjdf);
            gst.faction_set_minister_position("hlyjdf","faction_heir");
            modify_hlyjdf:add_experience(88000,0);
            modify_hlyjdf:apply_effect_bundle("essentials_effect_bundle",-1);
            modify_hlyjcm:apply_relationship_trigger_set(hlyjdf, "3k_dlc05_relationship_trigger_set_startpos_romance");
            modify_hlyjdf:apply_relationship_trigger_set(hlyjcm, "3k_dlc05_relationship_trigger_set_startpos_romance");
            cm:set_saved_value("generated_inazuma_1", true);
            cm:modify_faction(civil_war_faction):add_event_restricted_unit_record("xyyhlyjbbuqu1")
            cm:modify_faction(civil_war_faction):add_event_restricted_unit_record("xyyhlyjbbuqu2")
            cm:modify_faction(civil_war_faction):add_event_restricted_unit_record("xyyhlyjbbuqu3")
            cm:modify_faction(civil_war_faction):add_event_restricted_unit_record("xyyhlyjbbuqu4")
            cm:modify_faction(civil_war_faction):add_event_restricted_unit_record("xyyhlyjbbuqu5")
            cm:modify_faction(civil_war_faction):add_event_restricted_unit_record("xyyhlyjbbuqu6")
            cm:modify_faction(civil_war_faction):add_event_restricted_unit_record("xyyhlyjbbuqu7")
        end
    end,
    true
)

function generate_inazuma_civil_war_in_faction(faction_key) 
	--local civil_war_chars = {};
	local query_faction = cm:query_faction(faction_key);
--[[
	if not query_faction then
		script_error("Passed in faction is nil " .. faction_key);
	end;

	if query_faction:is_null_interface() then
		script_error("Passed in faction is nil " .. faction_key);
	end;]]

    if query_faction
    and not query_faction:is_null_interface()
    and not query_faction:is_dead() then
        local region_list = query_faction:region_list()
        if query_faction:is_human() and region_list:num_items() <= 3 then
            return false;
        elseif region_list:num_items() <= 6 then
            if query_faction:name() == "3k_dlc04_faction_empress_he" then
                gst.character_runaway("hlyjcm")
            else
                local civil_war_faction = query_faction:name()
                gst.faction_set_minister_position("hlyjcm","faction_leader");
                local hlyjcm = cm:query_model():character_for_template("hlyjcm");
                local modify_hlyjcm = cm:modify_character(hlyjcm)
                cm:modify_faction(civil_war_faction):apply_effect_bundle("inazuma_AI", -1);
                modify_hlyjcm:apply_effect_bundle("essentials_effect_bundle",-1);
                local kujou_sara = gst.character_add_to_faction("hlyjdf", civil_war_faction, "3k_general_fire");
                local modify_hlyjdf = cm:modify_character(kujou_sara);
                gst.faction_set_minister_position("hlyjdf","faction_heir");
                modify_hlyjdf:add_experience(88000,0);
                modify_hlyjdf:apply_effect_bundle("essentials_effect_bundle",-1);
                modify_hlyjcm:apply_relationship_trigger_set(kujou_sara, "3k_dlc05_relationship_trigger_set_startpos_romance");
                modify_hlyjdf:apply_relationship_trigger_set(hlyjcm, "3k_dlc05_relationship_trigger_set_startpos_romance");
                cm:set_saved_value("generated_inazuma_1", true);
                cm:modify_faction(civil_war_faction):add_event_restricted_unit_record("xyyhlyjbbuqu1")
                cm:modify_faction(civil_war_faction):add_event_restricted_unit_record("xyyhlyjbbuqu2")
                cm:modify_faction(civil_war_faction):add_event_restricted_unit_record("xyyhlyjbbuqu3")
                cm:modify_faction(civil_war_faction):add_event_restricted_unit_record("xyyhlyjbbuqu4")
                cm:modify_faction(civil_war_faction):add_event_restricted_unit_record("xyyhlyjbbuqu5")
                cm:modify_faction(civil_war_faction):add_event_restricted_unit_record("xyyhlyjbbuqu6")
                cm:modify_faction(civil_war_faction):add_event_restricted_unit_record("xyyhlyjbbuqu7")
            end
        end
        
        local hlyjcm = cm:query_model():character_for_template("hlyjcm");
        local query_region;
        
        --检测雷电将军是否为太守
        if hlyjcm:character_post()
        and not hlyjcm:character_post():is_null_interface()
        and hlyjcm:character_post():ministerial_position_record_key()
        and hlyjcm:character_post():ministerial_position_record_key() == "3k_main_court_offices_governor" 
        and cm:get_saved_value("govenor_hlyjcm")
        then
            query_region = cm:query_region(cm:get_saved_value("govenor_hlyjcm")) 
        else
            query_region = region_list:item_at(cm:random_int(region_list:num_items() - 1,0));
        end
        local limit = 10
        while 
        not query_region 
        or query_region:is_null_interface()
        or not query_region:is_province_capital()
        or query_region:name() == query_faction:capital_region():name()
        or string.find(query_region:name(), "_pass")
        do
            if limit <= 10 then
                limit = limit + 1;
            else
                return false;
            end
            query_region = region_list:item_at(cm:random_int(region_list:num_items() - 1,0));
        end
        local region_key = query_region:name()
        local civil_war_faction;
        if string.find(query_faction:name(), "xyy") then
            civil_war_faction = query_faction:name().."_s";
        elseif gst.separatist_factions[query_faction:name()] then
            civil_war_faction = gst.separatist_factions[query_faction:name()]
        else
            civil_war_faction = query_faction:name().."_separatists";
        end
        ModLog(civil_war_faction)
        local modify_faction = cm:modify_faction(civil_war_faction)
        
        cm:query_model():world():region_manager():region_list():foreach(
        function(region)
            if region 
            and not region:is_null_interface()
            and region:province_name() == query_region:province_name() 
            then
                cm:modify_region(region):settlement_gifted_as_if_by_payload(modify_faction);
            end;
        end
        );
        modify_faction:increase_treasury(500000)
        gst.character_add_to_faction("hlyjcm", civil_war_faction, "3k_general_fire");
        gst.faction_set_minister_position("hlyjcm","faction_leader");
        diplomacy_manager:apply_automatic_deal_between_factions(civil_war_faction, query_faction:name(), "data_defined_situation_war_proposer_to_recipient")
        cm:modify_model():disable_diplomacy("faction:"..query_faction:name(), "faction:"..civil_war_faction, "treaty_components_proposer_declares_war_against_target,treaty_components_recipient_declares_war_against_target,treaty_components_abdicate_demand,treaty_components_abdicate_offer,treaty_components_acknowledge_legitimacy_demand,treaty_components_acknowledge_legitimacy_offer,treaty_components_alliance,treaty_components_alliance_democratic,treaty_components_alliance_to_alliance_group_peace,treaty_components_alliance_to_alliance_group_peace_no_vote,treaty_components_alliance_to_alliance_group_peace_no_vote_proposer,treaty_components_alliance_to_alliance_group_peace_no_vote_recipient,treaty_components_alliance_to_alliance_war,treaty_components_alliance_to_alliance_war_no_vote,treaty_components_alliance_to_empire,treaty_components_alliance_to_empire_white_tiger,treaty_components_alliance_to_empire_yuan_shao,treaty_components_alliance_to_faction_group_peace,treaty_components_alliance_to_faction_group_peace_no_vote,treaty_components_alliance_to_faction_war,treaty_components_alliance_to_faction_war_no_vote,treaty_components_ancillary_demand,treaty_components_ancillary_offer,treaty_components_annex_subject,treaty_components_annex_vassal,treaty_components_attitude_manipulation_negative,treaty_components_attitude_manipulation_negative_sima_yue,treaty_components_attitude_manipulation_positive,treaty_components_attitude_manipulation_positive_sima_yue,treaty_components_break_deal_negotiated,treaty_components_break_deal_unilateral,treaty_components_break_food_supply_demand,treaty_components_break_food_supply_offer,treaty_components_break_military_access,treaty_components_break_non_aggression,treaty_components_break_payment_regular_demand,treaty_components_break_payment_regular_demand_twenty_turns,treaty_components_break_payment_regular_offer,treaty_components_break_payment_regular_offer_twenty_turns,treaty_components_break_support_independence,treaty_components_break_support_legitimacy,treaty_components_break_trade,treaty_components_break_trade_monopoly,treaty_components_cai_balance_value,treaty_components_coalition,treaty_components_coalition_split_vote,treaty_components_coalition_to_alliance,treaty_components_coalition_to_alliance_white_tiger,treaty_components_coalition_to_alliance_yuan_shao,treaty_components_coalition_to_alliance_yuan_shu,treaty_components_coalition_to_empire,treaty_components_coalition_to_empire_white_tiger,treaty_components_coalition_to_empire_yuan_shao,treaty_components_coercion,treaty_components_confederate_proposer,treaty_components_confederate_recipient,treaty_components_confederate_recipient_no_conditions,treaty_components_create_alliance,treaty_components_create_alliance_yuan_shao,treaty_components_create_alliance_yuan_shu,treaty_components_create_coalition,treaty_components_create_coalition_white_tiger,treaty_components_create_coalition_yuan_shao,treaty_components_create_coalition_yuan_shu,treaty_components_create_empire,treaty_components_create_empire_counter_offer,treaty_components_create_empire_white_tiger,treaty_components_create_empire_yuan_shao,treaty_components_declare_independence,treaty_components_demand_autonomy,treaty_components_dissolve_empire,treaty_components_draw_vassal_into_war,treaty_components_empire,treaty_components_empire_mobilisation,treaty_components_empire_split_vote,treaty_components_enemy_of_the_han_negative,treaty_components_enemy_of_the_han_positive,treaty_components_faction_to_alliance_group_peace,treaty_components_faction_to_alliance_group_peace_no_vote,treaty_components_faction_to_alliance_war,treaty_components_food_supply_demand,treaty_components_food_supply_offer,treaty_components_forced_end_personal_feud_empress_he,treaty_components_forced_end_personal_feud_generic,treaty_components_governor_independence,treaty_components_group_war,treaty_components_guarentee_autonomy,treaty_components_instigate_proxy_war_proposer,treaty_components_instigate_proxy_war_recipient,treaty_components_instigate_trade_monopoly,treaty_components_issue_Imperial_decree,treaty_components_join_alliance_proposers,treaty_components_join_alliance_recipients,treaty_components_join_coalition_proposer,treaty_components_join_coalition_recipient,treaty_components_join_empire_proposer,treaty_components_join_empire_recipient,treaty_components_join_imperial_colaition_proposer,treaty_components_join_imperial_colaition_recipient,treaty_components_kick_alliance_member,treaty_components_kick_coalition_member,treaty_components_kick_empire_member,treaty_components_kick_empire_member_and_declare_war,treaty_components_liberate_proposer,treaty_components_liberate_recipient,treaty_components_liu_bei_confederate_proposer,treaty_components_liu_bei_confederate_recipient,treaty_components_lu_bu_coercion,treaty_components_lu_bu_receive_coercion,treaty_components_mandated_powers,treaty_components_mandated_powers_demand,treaty_components_mandated_powers_offer,treaty_components_marriage_confederate_proposer,treaty_components_marriage_confederate_recipient,treaty_components_marriage_give_female,treaty_components_marriage_give_female_male,treaty_components_marriage_give_male,treaty_components_marriage_give_male_female,treaty_components_marriage_recieve_female,treaty_components_marriage_recieve_female_male,treaty_components_marriage_recieve_male,treaty_components_marriage_recieve_male_female,treaty_components_master_accepts_war,treaty_components_mercenary_contract,treaty_components_mercenary_contract_proposer_declares_war_against_target,treaty_components_mercenary_contract_recipient_declares_war_against_target,treaty_components_mercenary_counter_contract_proposer_declares_war_against_target,treaty_components_mercenary_counter_contract_recipient_declares_war_against_target,treaty_components_mercenary_employer_signed_peace,treaty_components_military_access,treaty_components_military_alliance_split_vote,treaty_components_multiplayer_victory,treaty_components_non_aggression,treaty_components_offer_autonomy,treaty_components_payment_demand,treaty_components_payment_offer,treaty_components_payment_regular_demand,treaty_components_payment_regular_demand_twenty_turns,treaty_components_payment_regular_offer,treaty_components_payment_regular_offer_twenty_turns,treaty_components_peace,treaty_components_peace_no_event,treaty_components_pending_join_alliance_proposers,treaty_components_pending_join_coalition_proposers,treaty_components_pending_join_empire_proposers,treaty_components_personal_feud,treaty_components_quit_alliance,treaty_components_quit_alliance_and_declare_war,treaty_components_quit_alliance_no_treachery,treaty_components_quit_coalition,treaty_components_quit_coalition_and_declare_war,treaty_components_quit_coalition_no_treachery,treaty_components_quit_empire,treaty_components_quit_empire_and_declare_war,treaty_components_quit_empire_no_treachery,treaty_components_recieve_coercion,treaty_components_recieve_imperial_decree,treaty_components_recieve_threat,treaty_components_recieve_trade_monopoly,treaty_components_region_demand,treaty_components_region_offer,treaty_components_resolve_personal_feud,treaty_components_schemes_resource_demand,treaty_components_schemes_resource_offer,treaty_components_sima_lun_coercion,treaty_components_sima_lun_instigate_proxy_war_proposer,treaty_components_sima_lun_instigate_proxy_war_recipient,treaty_components_sima_lun_recieve_coercion,treaty_components_support_independence,treaty_components_support_independence_demand,treaty_components_support_independence_offer,treaty_components_supporting_legitimacy,treaty_components_take_tribute,treaty_components_threaten,treaty_components_threaten_sanctions,treaty_components_trade,treaty_components_trade_monopoly,treaty_components_tribute_demand,treaty_components_tribute_offer,treaty_components_vassal_demands_protection,treaty_components_vassal_demands_protection_group_war,treaty_components_vassal_han_empire_demands_protection,treaty_components_vassal_han_empire_demands_protection_group_war,treaty_components_vassal_joins_war,treaty_components_vassal_requests_war,treaty_components_vassalage,treaty_components_vassalise_proposer,treaty_components_vassalise_proposer_liu_biao,treaty_components_vassalise_proposer_sima_liang,treaty_components_vassalise_proposer_yellow_turban,treaty_components_vassalise_proposer_yuan_shu,treaty_components_vassalise_recipient,treaty_components_vassalise_recipient_liu_biao,treaty_components_vassalise_recipient_no_conditions,treaty_components_vassalise_recipient_sima_liang,treaty_components_vassalise_recipient_yellow_turban,treaty_components_vassalise_recipient_yuan_shu,treaty_components_war", "civil_war")
        local query_leader = query_faction:faction_leader()
        local modify_hlyjcm = cm:modify_character(hlyjcm)
        local modify_leader = cm:modify_character(query_leader)
        modify_hlyjcm:apply_relationship_trigger_set(query_leader, "3k_main_relationship_trigger_set_event_negative_generic_extreme");
        modify_leader:apply_relationship_trigger_set(hlyjcm, "3k_main_relationship_trigger_set_event_negative_betrayed");
        cm:modify_faction(civil_war_faction):apply_effect_bundle("inazuma_AI", -1);
        modify_hlyjcm:apply_effect_bundle("essentials_effect_bundle",-1);
        local kujou_sara = gst.character_add_to_faction("hlyjdf", civil_war_faction, "3k_general_fire");
        local modify_hlyjdf = cm:modify_character(kujou_sara);
        gst.faction_set_minister_position("hlyjdf","faction_heir");
        modify_hlyjdf:add_experience(88000,0);
        modify_hlyjdf:apply_effect_bundle("essentials_effect_bundle",-1);
        modify_hlyjcm:apply_relationship_trigger_set(hlyjdf, "3k_dlc05_relationship_trigger_set_startpos_romance");
        modify_hlyjdf:apply_relationship_trigger_set(hlyjcm, "3k_dlc05_relationship_trigger_set_startpos_romance");
        cm:set_saved_value("generated_inazuma_1", true);
        --放置军队
        cm:modify_faction(civil_war_faction):add_event_restricted_unit_record("xyyhlyjbbuqu1")
        cm:modify_faction(civil_war_faction):add_event_restricted_unit_record("xyyhlyjbbuqu2")
        cm:modify_faction(civil_war_faction):add_event_restricted_unit_record("xyyhlyjbbuqu3")
        cm:modify_faction(civil_war_faction):add_event_restricted_unit_record("xyyhlyjbbuqu4")
        cm:modify_faction(civil_war_faction):add_event_restricted_unit_record("xyyhlyjbbuqu5")
        cm:modify_faction(civil_war_faction):add_event_restricted_unit_record("xyyhlyjbbuqu6")
        cm:modify_faction(civil_war_faction):add_event_restricted_unit_record("xyyhlyjbbuqu7")
--         local hlyjdo = gst.character_add_to_recruit_pool("hlyjdo",civil_war_faction, "3k_general_earth")
--         local hlyjcp = gst.character_add_to_recruit_pool("hlyjcp",civil_war_faction, "3k_general_fire")
--         local hlyjck = gst.character_add_to_recruit_pool("hlyjck",civil_war_faction, "3k_general_metal")
--         local hlyjcl = gst.character_add_to_recruit_pool("hlyjcl",civil_war_faction, "3k_general_fire")
--         local hlyjch = gst.character_add_to_recruit_pool("hlyjch",civil_war_faction, "3k_general_earth")
--         local hlyjdl = gst.character_add_to_recruit_pool("hlyjdl",civil_war_faction, "3k_general_fire")
--         local hlyjdd = gst.character_add_to_recruit_pool("hlyjdd",civil_war_faction, "3k_general_metal")
--         local hlyjdd = gst.character_add_to_recruit_pool("hlyjco",civil_war_faction, "3k_general_water")
--         local hlyjdd = gst.character_add_to_recruit_pool("hlyjct",civil_war_faction, "3k_general_water")
        gst.faction_create_military_force(civil_war_faction, cm:query_faction(civil_war_faction):capital_region():name(), hlyjcm)
        if not hlyjcm:military_force():is_null_interface() then
            local modify_force = cm:modify_model():get_modify_military_force(hlyjcm:military_force());
            modify_force:add_existing_character_as_retinue(cm:modify_character(kujou_sara), true);
            modify_force:add_existing_character_as_retinue(cm:modify_character(hlyjck), true);
        end
        return true
	end
end;
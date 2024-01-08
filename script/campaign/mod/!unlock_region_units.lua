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

------------------------------------------------------------------------------------------------------------------------------------------


function zph_mod_region_unlock(mode, region_key, unit_key, faction_key, character_key)
    core:add_listener(
        "mod_region_unlock_listener",
        "FactionTurnStart",
            
        function(context)
            if not context:faction():is_dead() then
                return true
            end
        end,

        function(context)
            --ModLog("————————————————————————————————————————")
            --ModLog("script unlock_region_unit start!")
    
            local query_faction = context:faction()
            --ModLog("current mode: "..mode)
            --ModLog("current unit: " ..unit_key)    
            --ModLog("current faction: " ..query_faction:name())
    
            cm:modify_faction(query_faction):remove_event_restricted_unit_record(unit_key)
            --ModLog("reset unit to unlock")
    
            if query_faction:subculture() == "3k_main_chinese" then
                local unoccupied_regoin = 0
                for i, region_key in ipairs(region_key) do
                    if cm:query_region(region_key):owning_faction():name() ~= context:faction():name() then
                        cm:modify_faction(query_faction):add_event_restricted_unit_record(unit_key)
                        unoccupied_regoin = unoccupied_regoin + 1
                        --ModLog("current faction does not own "..region_key..", lock the unit")
                        break
                    end
                end    
                --ModLog("unoccupied_regoin = "..unoccupied_regoin)

                if mode == 2 and unoccupied_regoin == 0 then
                --ModLog("start character check for mode 2")
                    local checked_char = 0
                    local unavailable_char = 0
                    for i, character_key in ipairs(character_key) do
                        if cm:query_model():character_for_template(character_key)
                           and not cm:query_model():character_for_template(character_key):is_null_interface()
                           and not cm:query_model():character_for_template(character_key):is_dead() then
                            --ModLog("current char check: "..character_key)
                            checked_char = checked_char + 1
                            if cm:query_model():character_for_template(character_key):faction():name() ~= context:faction():name() then
                                unavailable_char = unavailable_char + 1
                            end
                        end
                    end
                    --ModLog("checked_char = "..checked_char)
                    --ModLog("unavailable_char = ".. unavailable_char)
                    if unavailable_char == checked_char then
                        cm:modify_faction(query_faction):add_event_restricted_unit_record(unit_key)
                        --ModLog("no available character, lock the unit")
                    end
                end

                if context:faction():name() == faction_key then
                    cm:modify_faction(query_faction):remove_event_restricted_unit_record(unit_key)
                    --ModLog("faction "..faction_key.." is original faction, unlock the unit")
                end
    
            else
                cm:modify_faction(query_faction):remove_event_restricted_unit_record(unit_key)
                --ModLog("unlock unit for non-han faction")
            end
    
            --ModLog("mod_region_unlock execution is completed")
            --ModLog("————————————————————————————————————————")     
        end,
        true
    )
end;    
    

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
        if hlyjcm:is_faction_leader() 
        or (hlyjcm:character_post()
        and not hlyjcm:character_post():is_null_interface()
        and hlyjcm:character_post():ministerial_position_record_key()
        and (hlyjcm:character_post():ministerial_position_record_key() == "3k_main_court_offices_prime_minister" 
        or hlyjcm:character_post():ministerial_position_record_key() == "ep_court_offices_prime_minister" 
        or hlyjcm:character_post():ministerial_position_record_key() == "faction_heir" 
        or hlyjcm:character_post():ministerial_position_record_key() == "3k_dlc04_court_offices_general_in_chief" 
        or hlyjcm:character_post():ministerial_position_record_key() == "3k_dlc04_court_offices_grand_tutor" 
        or hlyjcm:character_post():ministerial_position_record_key() == "3k_dlc04_court_offices_grand_excellency_of_works" 
        or hlyjcm:character_post():ministerial_position_record_key() == "3k_dlc04_court_offices_grand_commandant" 
        or hlyjcm:character_post():ministerial_position_record_key() == "3k_dlc04_court_offices_prime_minister"))
        then
            cm:modify_faction(query_faction):remove_event_restricted_unit_record("hlyjdingzhiedanwei")
            cm:modify_faction(query_faction):remove_event_restricted_unit_record("hlyjdingzhifdanwei")
        end
    end,
    true
)
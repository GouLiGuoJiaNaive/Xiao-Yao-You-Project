cm:add_first_tick_callback_new(function() xyy_startpos(); end);

function xyy_startpos()
end;

--添加监听
core:add_listener(
    "playerStore_api_byHy_listener",
    "FirstTickAfterWorldCreated", --世界创建完成后的第一时间
    function(context)
        return cm:query_model():turn_number() == 1;
    end,

    function(context)
        local xyyhlyja = cm:query_faction("xyyhlyja")
        if xyyhlyja and not xyyhlyja:is_null_interface() and not xyyhlyja:is_dead() then
            xyy_character_add("3k_main_template_historical_yuwen_wei_hero_metal","xyyhlyja","3k_general_metal")
            xyy_character_add("3k_main_template_historical_tuoba_zan_hero_wood","xyyhlyja","3k_general_wood")
            xyy_character_add("3k_main_template_historical_zhangsun_yuanji_hero_earth","xyyhlyja","3k_general_earth")
        end
        
        if 
        cm:query_model():campaign_name() ~= "3k_dlc04_start_pos" 
        and cm:query_model():campaign_name() ~= "8p_start_pos" 
        and cm:query_model():campaign_name() ~= "3k_main_campaign_map" 
        then
            local lu_xun = xyy_character_add("3k_main_template_historical_lu_xun_hero_water","3k_dlc05_faction_sun_ce","3k_general_water")
            cm:modify_character(lu_xun):ceo_management():add_ceo("3k_main_ancillary_armour_lu_xun_armour_unique")
            cm:modify_character(lu_xun):ceo_management():add_scripted_permission("3k_main_ceo_permissions_ancillary_armour_character_specific_lu_xun")
            xyy_CEO_equip("3k_main_template_historical_lu_xun_hero_water","3k_main_ancillary_armour_lu_xun_armour_unique","3k_main_ceo_category_ancillary_armour");
            local lu_meng = xyy_character_add("3k_main_template_historical_lu_meng_hero_metal","3k_dlc05_faction_sun_ce","3k_general_metal")
            cm:modify_character(lu_meng):ceo_management():add_ceo("3k_main_ancillary_armour_lu_meng_armour_unique")
            cm:modify_character(lu_meng):ceo_management():add_scripted_permission("3k_main_ceo_permissions_ancillary_armour_character_specific_lu_meng")
            xyy_CEO_equip("3k_main_template_historical_lu_meng_hero_metal","3k_main_ancillary_armour_lu_meng_armour_unique","3k_main_ceo_category_ancillary_armour");
        end
            
        if cm:query_model():campaign_name() == "3k_dlc07_start_pos" then
            local lu_lingqi = cm:query_model():character_for_template("hlyjbw") -- 吕玲绮
            local lu_lingju = cm:query_model():character_for_template("hlyjbx") -- 吕灵雎
            local diaochan = cm:query_model():character_for_template("3k_main_template_historical_lady_diao_chan_hero_water")
            local lu_bu = cm:query_model():character_for_template("3k_main_template_historical_lu_bu_hero_fire")
            xyy_character_add("3k_dlc05_template_historical_lady_yan_hero_earth","3k_main_faction_cao_cao","3k_general_earth")
            local lady_yan = cm:query_model():character_for_template("3k_dlc05_template_historical_lady_yan_hero_earth");
            cm:modify_character(lu_lingqi):make_child_of(cm:modify_character(lady_yan));
            cm:modify_character(lu_lingju):make_child_of(cm:modify_character(diaochan));
            lu_bu = xyy_character_add("3k_main_template_historical_lu_bu_hero_fire","3k_main_faction_cao_cao","3k_general_fire");
            cm:modify_character(lu_lingqi):make_child_of(cm:modify_character(lu_bu));
            cm:modify_character(lu_lingju):make_child_of(cm:modify_character(lu_bu));
            cm:modify_character(lu_bu):kill_character(true);
        end
    end,
    true
)


    
core:add_listener(
    "testdilemmachoice", -- UID
    "DilemmaChoiceMadeEvent", -- CampaignEvent
    function(context) 
        return context:dilemma() == "hexie_script"  
    end, -- criteria
    function (context) --what to do if listener fires
        if context:choice() == 0 then
            xyy_ticket_points_add(50)
            
            xyy_kill_character("hlyjk");
            xyy_kill_character("hlyjn");
            xyy_kill_character("hlyjr");
            xyy_kill_character("hlyju");
            xyy_kill_character("hlyjx");
            xyy_kill_character("hlyjba");
            xyy_kill_character("hlyjbc");
            xyy_kill_character("hlyjbn");
            xyy_kill_character("hlyjcc");
            
            if not cm:query_faction("xyyhlyje"):is_human() then
                xyy_set_region_manager("3k_main_yizhou_island_capital", "xyy");
            end;
            
            if not cm:query_faction("xyyhlyjd"):is_human() then
                xyy_set_region_manager("3k_dlc06_liaodong_capital", "3k_main_faction_gongsun_du");
            end;
            
            if cm:query_model():campaign_name() == "3k_main_campaign_map" then
                if not cm:query_faction("xyyhlyjc"):is_human() then
                    xyy_set_region_manager("3k_dlc06_xiapi_capital", "3k_main_faction_tao_qian");
                end;
                if not cm:query_faction("xyyhlyjb"):is_human() then
--                     local lu_bu = cm:query_model():character_for_template("3k_main_template_historical_lu_bu_hero_fire");  
--                     xyy_set_region_manager("3k_main_luoyang_capital", "3k_main_faction_lu_bu");
--                     cm:modify_character(lu_bu):move_to_faction_and_make_recruited("3k_main_faction_lu_bu");
--                     cm:modify_character(lu_bu):assign_faction_leader();
                    xyy_set_region_manager("3k_main_luoyang_capital", "3k_main_faction_dong_zhuo");
                end;
            end
            
            if cm:query_model():campaign_name() == "3k_dlc05_start_pos" then
                if not cm:query_faction("xyyhlyjc"):is_human() then
                    xyy_set_region_manager("3k_dlc06_xiapi_capital", "3k_main_faction_liu_bei");
                end;
                if not cm:query_faction("xyyhlyjb"):is_human() then
                    xyy_set_region_manager("3k_main_shoufang_capital", "3k_main_faction_zhang_yan");
                end;
            end
            
            if cm:query_model():campaign_name() == "3k_dlc07_start_pos" then
                if not cm:query_faction("xyyhlyjc"):is_human() then
                    xyy_set_region_manager("3k_dlc06_xiapi_capital", "3k_main_faction_liu_bei");
                end;
                if not cm:query_faction("xyyhlyjb"):is_human() then
                    xyy_set_region_manager("3k_main_yanmen_capital", "3k_main_faction_zhang_yan");
                end;
            end
        end
        if context:choice() == 2 then
            xyy_kill_character("hlyjk");
            xyy_kill_character("hlyjn");
            xyy_kill_character("hlyjr");
            xyy_kill_character("hlyju");
            xyy_kill_character("hlyjx");
            xyy_kill_character("hlyjba");
            xyy_kill_character("hlyjbc"); 
            xyy_kill_character("hlyjcc");
        end
        character_browser();
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
        local query_faction = cm:query_local_faction();
        local query_leader = query_faction:faction_leader();
        local hlyjz = cm:query_model():character_for_template("hlyjz")
        local modify_hlyjz = cm:modify_character(hlyjz)
        local modify_leader = cm:modify_character(query_leader)
        modify_hlyjz:apply_relationship_trigger_set(query_leader, "3k_main_relationship_trigger_set_event_negative_generic_extreme");
        modify_hlyjz:apply_relationship_trigger_set(query_leader, "3k_main_relationship_trigger_set_event_negative_betrayed");
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
            xyy_character_add("hlyjz",random_faction:name(),"3k_general_water");
            --cm:modify_character(hlyjz):move_to_faction_and_make_recruited(random_faction:name());
        else
            ModLog("姚明月加入了3k_main_faction_dong_zhuo加入新派系");
            xyy_character_add("hlyjz","3k_main_faction_dong_zhuo","3k_general_water");
            --cm:modify_character(hlyjz):move_to_faction_and_make_recruited("3k_main_faction_dong_zhuo");
        end
        if context:dilemma() == "D3shijian" then
            if context:choice() == 0 then
                xyy_random_kill(query_faction,1);
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
            xyy_character_add("3k_dlc04_template_historical_emperor_xian_earth",faction:name(),"3k_general_earth");
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
        return context:dilemma() == "mingyuewujiang_01"; 
    end, -- criteria
    function (context) --what to do if listener fires
        --local hlyjz = cm:query_model():character_for_template("hlyjz")
        --检测董卓派系
        if context:choice() == 2 or context:choice() == 3 then
            local dongzhuo_faction = cm:query_faction("3k_main_faction_dong_zhuo");
            if not dongzhuo_faction or dongzhuo_faction:is_null_interface() or dongzhuo_faction:is_dead() or dongzhuo_faction:is_human() then
                ModLog("董卓派系已经不存在，加入新派系");
                random_create_character("hlyjz", "3k_general_water");
                --cm:modify_character(hlyjz):move_to_faction_and_make_recruited(random_faction:name());
            else
                ModLog("姚明月加入了3k_main_faction_dong_zhuo加入新派系");
                xyy_character_add("hlyjz","3k_main_faction_dong_zhuo","3k_general_water");
                --cm:modify_character(hlyjz):move_to_faction_and_make_recruited("3k_main_faction_dong_zhuo");
            end
        end
        if context:choice() == 0 or context:choice() == 3 then
            local xyyhlyjb = cm:query_faction("xyyhlyjb") 
            if xyyhlyjb 
            and not xyyhlyjb:is_dead()
            and not xyyhlyjb:is_human()
            then
                xyy_character_add("hlyjq", "xyyhlyjb","3k_general_water")
                xyy_character_add("hlyjp", "xyyhlyjb","3k_general_fire")
                xyy_character_add("hlyjr", "xyyhlyjb","3k_general_fire")
            else
                random_create_character("hlyjq", "3k_general_water");
                random_create_character("hlyjp", "3k_general_fire");
                random_create_character("hlyjr", "3k_general_fire");
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
        --xyy_character_add("hlyjbz",random_faction:name(),"3k_general_water");
        cm:modify_character(hlyjbz):move_to_faction_and_make_recruited(random_faction:name());
    end,   
    false -- is persistent
)

function xyy_character_close_agent(character_key)
    local q_char = cm:query_model():character_for_template(character_key);
    if not q_char:is_null_interface() then
        if q_char:has_undercover_character_enabler() == true then
            cm:modify_character(q_char):set_undercover_character_enabler(false);        
        end;
    end;
end;
  -- move/create character in specified faction
function xyy_character_add(character_key, faction_key, character_subtype)
        ModLog( character_key..faction_key )
        local q_faction = cm:query_faction(faction_key);
        if not q_faction or q_faction:is_null_interface() or q_faction:is_dead() then
            ModLog("角色生成 -- ERROR：" .. faction_key .. "不存在！");
            return false;
        end
        
        local q_char = cm:query_model():character_for_template(character_key);
        
        if q_char and not q_char:is_null_interface() and q_char:is_dead() then
            return q_char;
        end 
        if q_char and not q_char:is_null_interface() then
            if q_char:is_character_is_faction_recruitment_pool() then
--                 cm:modify_character(q_char):kill_character(false);
--                 cm:modify_faction(faction_key):create_character_from_template("general", character_subtype, character_key, false); ..character_subtype);
				cm:modify_character(q_char):move_to_faction_and_make_recruited(faction_key)
                ModLog("角色生成 -- 重新生成：" .. character_key .. ",位于" .. faction_key .. "，五行为 "..character_subtype);
            else
                cm:modify_character(q_char):move_to_faction_and_make_recruited(faction_key);
                ModLog("角色生成 -- 转势力：" .. character_key .. ",位于" .. faction_key .. "，五行为 " ..character_subtype);
            end
            return q_char
        else    
            local char = cm:modify_faction(faction_key):create_character_from_template("general", character_subtype, character_key, false);
            ModLog("角色生成 -- 新建：" .. character_key .. ",位于" .. faction_key .. "，五行为 " ..character_subtype);
            return char:query_character();
        end
        return false;
end;

function xyy_CEO_equip(character_key, ceo_key, category_key)
    local q_char_to_be_set = cm:query_model():character_for_template(character_key);    

    
    if q_char_to_be_set and not q_char_to_be_set:is_null_interface() and not q_char_to_be_set:is_dead() then
        cdir_events_manager:add_or_remove_ceo_from_faction(q_char_to_be_set:faction():name(), ceo_key, true);
            ancillaries:equip_ceo_on_character(q_char_to_be_set, ceo_key, category_key);

        -- ModLog("装备修改：" .. character_key .. "装备了".. ceo_key );
    else
        -- ModLog("装备修改 -- ERROR：" .. character_key .. "不存在！");
    end
end;

function xyy_CEO_remove(ceo_key, faction_key) 
    local q_faction = cm:query_faction(faction_key);
    if q_faction and not q_faction:is_null_interface() and not q_faction:is_dead() then
        cdir_events_manager:add_or_remove_ceo_from_faction(faction_key, ceo_key, false);
        ModLog("装备修改：" .. faction_key .. "删除".. ceo_key );
    else
        -- ModLog("装备修改 -- ERROR：" .. character_key .. "不存在！");
    end
end;

function xyy_set_minister_position(character_key, minister_position)
    local q_char_to_be_set = cm:query_model():character_for_template(character_key);    
    
    if minister_position == "faction_leader" then
        cm:modify_character(q_char_to_be_set):assign_faction_leader();
    end
    if q_char_to_be_set and not q_char_to_be_set:is_null_interface() and not q_char_to_be_set:is_dead() then
        cm:modify_character(q_char_to_be_set):assign_to_post(minister_position);
        ModLog("设置官职：" .. character_key .. "设置为"..minister_position);
    else
        ModLog("设置官职 -- ERROR：" .. character_key .. "不存在！");
    end
end;

function xyy_set_region_manager(region_key, faction_key)
    if cm:query_region(region_key)
    and not cm:query_region(region_key):is_null_interface()
    and not cm:query_region(region_key):owning_faction():is_human()
    and cm:query_region(region_key):owning_faction():name() ~= "xyyhlyjf"
    and cm:query_region(region_key):owning_faction():name() ~= faction_key
    then
        cm:modify_region(region_key):settlement_gifted_as_if_by_payload(cm:modify_faction(faction_key));
    end
end;

function xyy_set_region_manager_random(region_key, faction_key)
    if not cm:query_region(region_key)
    or cm:query_region(region_key):is_null_interface()
        return;
    end
    if cm:query_region(region_key):owning_faction():name() == faction_key
    then
        return;
    end
    local random = cm:random_int(1000,1)
    if not cm:query_region(region_key):owning_faction():is_human()
    and cm:query_region(region_key):owning_faction():name() ~= "xyyhlyjf"
    and random > 200
    then
        cm:modify_region(region_key):settlement_gifted_as_if_by_payload(cm:modify_faction(faction_key));
    end
end;

function xyy_set_region_manager_force(region_key, faction_key)
    if cm:query_region(region_key)
    and not cm:query_region(region_key):is_null_interface()
    and cm:query_region(region_key):owning_faction():name() ~= faction_key
    then
        cm:modify_region(region_key):settlement_gifted_as_if_by_payload(cm:modify_faction(faction_key));
    end
end;

function xyy_kill_character(character_key)
    local q_char = cm:query_model():character_for_template(character_key);
    if q_char and not q_char:is_null_interface() and not q_char:is_dead() then
        cm:modify_character(q_char):kill_character(false);
    end
end;

function xyy_abdication_char(faction_key)
    local q_faction = cm:query_faction(faction_key);
    local modify_faction = cm:modify_faction(q_faction);
    for i = 0, q_faction:character_list():num_items() - 1 do
    local character_key = q_faction:character_list():item_at(i);
        if not character_key:is_dead() and character_key:family_member():come_of_age() and not character_key:character_post():is_null_interface()  then
            if character_key:character_type("general") and character_key:character_post():ministerial_position_record_key() == "faction_heir" then
                cm:modify_character(character_key):assign_faction_leader();
            break    
            end;
        end;
    end;
end;

function xyy_remove_all_traits(q_target_character)
    if q_target_character and not q_target_character:is_null_interface() then
        local modify_character = cm:modify_character(q_target_character); 
        modify_character:ceo_management():remove_ceos("3k_main_ceo_trait_personality_aescetic");
        modify_character:ceo_management():remove_ceos("3k_main_ceo_trait_personality_ambitious");
        modify_character:ceo_management():remove_ceos("3k_main_ceo_trait_personality_arrogant");
        modify_character:ceo_management():remove_ceos("3k_main_ceo_trait_personality_artful");
        modify_character:ceo_management():remove_ceos("3k_main_ceo_trait_personality_brave");
        modify_character:ceo_management():remove_ceos("3k_main_ceo_trait_personality_brilliant");
        modify_character:ceo_management():remove_ceos("3k_main_ceo_trait_personality_careless");
        modify_character:ceo_management():remove_ceos("3k_main_ceo_trait_personality_cautious");
        modify_character:ceo_management():remove_ceos("3k_main_ceo_trait_personality_charismatic");
        modify_character:ceo_management():remove_ceos("3k_main_ceo_trait_personality_charitable");
        modify_character:ceo_management():remove_ceos("3k_main_ceo_trait_personality_clever");
        modify_character:ceo_management():remove_ceos("3k_main_ceo_trait_personality_competative");
        modify_character:ceo_management():remove_ceos("3k_main_ceo_trait_personality_cowardly");
        modify_character:ceo_management():remove_ceos("3k_main_ceo_trait_personality_cruel");
        modify_character:ceo_management():remove_ceos("3k_main_ceo_trait_personality_cunning");
        modify_character:ceo_management():remove_ceos("3k_main_ceo_trait_personality_deceitful");
        modify_character:ceo_management():remove_ceos("3k_main_ceo_trait_personality_defiant");
        modify_character:ceo_management():remove_ceos("3k_main_ceo_trait_personality_determined");
        modify_character:ceo_management():remove_ceos("3k_main_ceo_trait_personality_direct");
        modify_character:ceo_management():remove_ceos("3k_main_ceo_trait_personality_disciplined");
        modify_character:ceo_management():remove_ceos("3k_main_ceo_trait_personality_disloyal");
        modify_character:ceo_management():remove_ceos("3k_main_ceo_trait_personality_distinguished");
        modify_character:ceo_management():remove_ceos("3k_main_ceo_trait_personality_dutiful");
        modify_character:ceo_management():remove_ceos("3k_main_ceo_trait_personality_elusive");
        modify_character:ceo_management():remove_ceos("3k_main_ceo_trait_personality_energetic");
        modify_character:ceo_management():remove_ceos("3k_main_ceo_trait_personality_enigmatic");
        modify_character:ceo_management():remove_ceos("3k_main_ceo_trait_personality_fiery");
        modify_character:ceo_management():remove_ceos("3k_main_ceo_trait_personality_fraternal");
        modify_character:ceo_management():remove_ceos("3k_main_ceo_trait_personality_greedy");
        modify_character:ceo_management():remove_ceos("3k_main_ceo_trait_personality_honourable");
        modify_character:ceo_management():remove_ceos("3k_main_ceo_trait_personality_humble");
        modify_character:ceo_management():remove_ceos("3k_main_ceo_trait_personality_incompetent");
        modify_character:ceo_management():remove_ceos("3k_main_ceo_trait_personality_indecisive");
        modify_character:ceo_management():remove_ceos("3k_main_ceo_trait_personality_intimidating");
        modify_character:ceo_management():remove_ceos("3k_main_ceo_trait_personality_kind");
        modify_character:ceo_management():remove_ceos("3k_main_ceo_trait_personality_loyal");
        modify_character:ceo_management():remove_ceos("3k_main_ceo_trait_personality_modest");
        modify_character:ceo_management():remove_ceos("3k_main_ceo_trait_personality_pacifist");
        modify_character:ceo_management():remove_ceos("3k_main_ceo_trait_personality_patient");
        modify_character:ceo_management():remove_ceos("3k_main_ceo_trait_personality_perceptive");
        modify_character:ceo_management():remove_ceos("3k_main_ceo_trait_personality_quiet");
        modify_character:ceo_management():remove_ceos("3k_main_ceo_trait_personality_reckless");
        modify_character:ceo_management():remove_ceos("3k_main_ceo_trait_personality_resourceful");
        modify_character:ceo_management():remove_ceos("3k_main_ceo_trait_personality_scholarly");
        modify_character:ceo_management():remove_ceos("3k_main_ceo_trait_personality_sincere");
        modify_character:ceo_management():remove_ceos("3k_main_ceo_trait_personality_solitary");
        modify_character:ceo_management():remove_ceos("3k_main_ceo_trait_personality_stubborn");
        modify_character:ceo_management():remove_ceos("3k_main_ceo_trait_personality_superstitious");
        modify_character:ceo_management():remove_ceos("3k_main_ceo_trait_personality_suspicious");
        modify_character:ceo_management():remove_ceos("3k_main_ceo_trait_personality_trusting");
        modify_character:ceo_management():remove_ceos("3k_main_ceo_trait_personality_unobservant");
        modify_character:ceo_management():remove_ceos("3k_main_ceo_trait_personality_vain");
        modify_character:ceo_management():remove_ceos("3k_main_ceo_trait_personality_vengeful");
        modify_character:ceo_management():remove_ceos("3k_main_ceo_trait_physical_agile");
        modify_character:ceo_management():remove_ceos("3k_main_ceo_trait_physical_beautiful");
        modify_character:ceo_management():remove_ceos("3k_main_ceo_trait_physical_blind");
        modify_character:ceo_management():remove_ceos("3k_main_ceo_trait_physical_clumsy");
        modify_character:ceo_management():remove_ceos("3k_main_ceo_trait_physical_coordinated");
        modify_character:ceo_management():remove_ceos("3k_main_ceo_trait_physical_decrepit");
        modify_character:ceo_management():remove_ceos("3k_main_ceo_trait_physical_drunk");
        modify_character:ceo_management():remove_ceos("3k_main_ceo_trait_physical_eunuch");
        modify_character:ceo_management():remove_ceos("3k_main_ceo_trait_physical_fat");
        modify_character:ceo_management():remove_ceos("3k_main_ceo_trait_physical_fertile");
        modify_character:ceo_management():remove_ceos("3k_main_ceo_trait_physical_graceful");
        modify_character:ceo_management():remove_ceos("3k_main_ceo_trait_physical_handsome");
        modify_character:ceo_management():remove_ceos("3k_main_ceo_trait_physical_healthy");
        modify_character:ceo_management():remove_ceos("3k_main_ceo_trait_physical_heartbroken");
        modify_character:ceo_management():remove_ceos("3k_main_ceo_trait_physical_ill");
        modify_character:ceo_management():remove_ceos("3k_main_ceo_trait_physical_infertile");
        modify_character:ceo_management():remove_ceos("3k_main_ceo_trait_physical_lovestruck");
        modify_character:ceo_management():remove_ceos("3k_main_ceo_trait_physical_lumbering");
        modify_character:ceo_management():remove_ceos("3k_main_ceo_trait_physical_mad");
        modify_character:ceo_management():remove_ceos("3k_main_ceo_trait_physical_maimed_arm");
        modify_character:ceo_management():remove_ceos("3k_main_ceo_trait_physical_maimed_leg");
        modify_character:ceo_management():remove_ceos("3k_main_ceo_trait_physical_one-eyed");
        modify_character:ceo_management():remove_ceos("3k_main_ceo_trait_physical_poxxed");
        modify_character:ceo_management():remove_ceos("3k_main_ceo_trait_physical_scarred");
        modify_character:ceo_management():remove_ceos("3k_main_ceo_trait_physical_shu_tiger_general");
        modify_character:ceo_management():remove_ceos("3k_main_ceo_trait_physical_sickly");
        modify_character:ceo_management():remove_ceos("3k_main_ceo_trait_physical_strong");
        modify_character:ceo_management():remove_ceos("3k_main_ceo_trait_physical_sui_knight");
        modify_character:ceo_management():remove_ceos("3k_main_ceo_trait_physical_tough");
        modify_character:ceo_management():remove_ceos("3k_main_ceo_trait_physical_weak");
        modify_character:ceo_management():remove_ceos("3k_main_ceo_trait_physical_wei_elite_general");
        modify_character:ceo_management():remove_ceos("3k_ytr_ceo_trait_personality_benevolent");
        modify_character:ceo_management():remove_ceos("3k_ytr_ceo_trait_personality_gentle_hearted");
        modify_character:ceo_management():remove_ceos("3k_ytr_ceo_trait_personality_heaven_bright");
        modify_character:ceo_management():remove_ceos("3k_ytr_ceo_trait_personality_heaven_creative");
        modify_character:ceo_management():remove_ceos("3k_ytr_ceo_trait_personality_heaven_honest");
        modify_character:ceo_management():remove_ceos("3k_ytr_ceo_trait_personality_heaven_selfless");
        modify_character:ceo_management():remove_ceos("3k_ytr_ceo_trait_personality_heaven_tolerant");
        modify_character:ceo_management():remove_ceos("3k_ytr_ceo_trait_personality_heaven_tranquil");
        modify_character:ceo_management():remove_ceos("3k_ytr_ceo_trait_personality_heaven_wise");
        modify_character:ceo_management():remove_ceos("3k_ytr_ceo_trait_personality_land_alert");
        modify_character:ceo_management():remove_ceos("3k_ytr_ceo_trait_personality_land_aspiring");
        modify_character:ceo_management():remove_ceos("3k_ytr_ceo_trait_personality_land_composed");
        modify_character:ceo_management():remove_ceos("3k_ytr_ceo_trait_personality_land_courageous");
        modify_character:ceo_management():remove_ceos("3k_ytr_ceo_trait_personality_land_generous");
        modify_character:ceo_management():remove_ceos("3k_ytr_ceo_trait_personality_land_powerful");
        modify_character:ceo_management():remove_ceos("3k_ytr_ceo_trait_personality_land_proud");
        modify_character:ceo_management():remove_ceos("3k_ytr_ceo_trait_personality_people_amiable");
        modify_character:ceo_management():remove_ceos("3k_ytr_ceo_trait_personality_people_cheerful");
        modify_character:ceo_management():remove_ceos("3k_ytr_ceo_trait_personality_people_compassionate");
        modify_character:ceo_management():remove_ceos("3k_ytr_ceo_trait_personality_people_friendly");
        modify_character:ceo_management():remove_ceos("3k_ytr_ceo_trait_personality_people_people_pleaser");
        modify_character:ceo_management():remove_ceos("3k_ytr_ceo_trait_personality_people_stern");
        modify_character:ceo_management():remove_ceos("3k_ytr_ceo_trait_personality_people_understanding");
        modify_character:ceo_management():remove_ceos("3k_ytr_ceo_trait_personality_relentless");
        modify_character:ceo_management():remove_ceos("3k_ytr_ceo_trait_personality_simple");
        modify_character:ceo_management():remove_ceos("3k_ytr_ceo_trait_personality_stalwart");
        modify_character:ceo_management():remove_ceos("3k_ytr_ceo_trait_personality_strong_willed");
        modify_character:ceo_management():remove_ceos("3k_ytr_ceo_trait_personality_temperamental");
        modify_character:ceo_management():remove_ceos("3k_ytr_ceo_trait_personality_trustworthy");
        modify_character:ceo_management():remove_ceos("3k_ytr_ceo_trait_personality_vindictive");
        modify_character:ceo_management():remove_ceos("3k_ytr_ceo_trait_physical_feared");
        modify_character:ceo_management():remove_ceos("3k_ytr_ceo_trait_physical_healer_of_people");
        modify_character:ceo_management():remove_ceos("3k_ytr_ceo_trait_physical_impeccable");
        modify_character:ceo_management():remove_ceos("3k_ytr_ceo_trait_physical_leader_of_people");
        modify_character:ceo_management():remove_ceos("3k_ytr_ceo_trait_physical_protector_of_people");
        modify_character:ceo_management():remove_ceos("3k_ytr_ceo_trait_physical_sprained_ankle");
        modify_character:ceo_management():remove_ceos("3k_ytr_ceo_trait_physical_wound");
    end;
end;

function xyy_runaway(character_key)
    --获取派系列表
    local world_faction_list = cm:query_model():world():faction_list();
    local random_faction = world_faction_list:item_at(cm:random_int(world_faction_list:num_items() - 1,0));
    while 
    not random_faction 
    or random_faction:is_null_interface() 
    or random_faction:is_human()
    or random_faction:is_dead() 
    or random_faction:name() == "xyyhlyjf"
    or random_faction:subculture() == "3k_main_subculture_yellow_turban"
    or random_faction:subculture() == "3k_dlc05_subculture_bandits"
    or random_faction:subculture() == "3k_dlc06_subculture_nanman"
    do
        random_faction = world_faction_list:item_at(cm:random_int(world_faction_list:num_items() - 1,0));
    end
    --加入随机派系
    ModLog(character_key .. "加入了" .. random_faction:name() .. "加入新派系");
    local query_character = cm:query_model():character_for_template(character_key)
    if query_character and not query_character:is_null_interface() then
        if not query_character:is_dead() then
            cm:modify_character(query_character):move_to_faction_and_make_recruited(random_faction:name());
        end
    end
end;

function random_create_character(character_key, character_subtype_key)
    local query_character = cm:query_model():character_for_template(character_key);
    --获取派系列表
    if not query_character or query_character:is_null_interface() then
        local world_faction_list = cm:query_model():world():faction_list();
        local random_faction = world_faction_list:item_at(cm:random_int(world_faction_list:num_items() - 1,0));
        while 
        not random_faction 
        or random_faction:is_null_interface()
        or random_faction:is_human()  
        or random_faction:is_dead() 
        or random_faction:name() == "xyyhlyjf"
        or random_faction:subculture() == "3k_main_subculture_yellow_turban"
        or random_faction:subculture() == "3k_dlc05_subculture_bandits"
        or random_faction:subculture() == "3k_dlc06_subculture_nanman"
        do
            random_faction = world_faction_list:item_at(cm:random_int(world_faction_list:num_items() - 1,0));
        end
        --加入随机派系
        ModLog(character_key .. "加入了" .. random_faction:name());
        return xyy_character_add(character_key,random_faction:name(),character_subtype_key)
        --cm:modify_faction(random_faction:name()):create_character_from_template("general", character_subtype_key, character_key, false);
    end
end;

function xyy_random_kill(faction_key, number) 
    local query_faction = cm:query_faction(faction_key);
    local index = {};
    for i = 0, query_faction:character_list():num_items() - 1 do
        local query_character = query_faction:character_list():item_at(i);
        if query_character 
        and not query_character:is_null_interface() 
        and not query_character:is_dead() 
        and query_faction:faction_leader() ~= query_character 
        and query_character:generation_template_key() ~= "hlyjdingzhie" 
        and query_character:generation_template_key() ~= "hlyjcj" 
        and query_character:has_come_of_age() 
        and not query_character:is_character_is_faction_recruitment_pool() 
        and query_character:character_subtype_key() ~= "3k_colonel"
        and query_character:character_subtype_key() ~= "3k_minister"
        then
            ModLog(query_character:character_subtype_key() .. " " .. query_character:generation_template_key());
            table.insert(index, query_character);
        end
    end
    for j = 0, number - 1 do
        if  #index >= 0 then
            local random = cm:random_int(#index, 1);
            local random_character = table.remove(index, random);
            incident = cm:modify_model():create_incident("kafka_mission_13_a_death_character");
            incident:add_character_target("target_character_1", random_character);
            incident:add_faction_target("target_faction_1", query_faction);
            incident:trigger(cm:modify_faction(query_faction), true);
            cm:modify_character(random_character):kill_character(false);
        end 
    end
end;

function xyy_ticket_points_add(number)
    if cm:get_saved_value("ticket_points") then
        cm:set_saved_value("ticket_points", cm:get_saved_value("ticket_points") + number);
    else
        cm:set_saved_value("ticket_points", number);
    end
end;


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
                attacker_force = attacker:military_force();
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
                defender_force = defender:military_force();
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

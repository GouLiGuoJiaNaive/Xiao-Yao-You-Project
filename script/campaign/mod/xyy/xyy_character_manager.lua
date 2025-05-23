local gst = xyy_gst:get_mod()

local function query_for_template(character_key)
    if is_string(character_key) then
    else
        return nil;
    end
    
    local query_characters_list = cm:query_model():all_characters_for_template(character_key)
    if query_characters_list and not query_characters_list:is_empty() then
        for i = 0, query_characters_list:num_items() - 1 do
            local character = query_characters_list:item_at(i)
            if character and not character:is_null_interface() and not character:is_dead() then
                return character;
            end
        end
        return query_characters_list:item_at(0);
    else
        return nil;
    end
end

local function get_string_name(query_character)     
    if is_number(query_character) then
        query_character = cm:query_model():character_for_command_queue_index(character_key)
    elseif is_string(query_character) then
        query_character = query_for_template(query_character)
    end
    
    if not query_character
    or query_character:is_null_interface() 
    then
        return
    end
    local name = ""
    local forename = effect.get_localised_string(tostring(query_character:get_forename()))
    local surname = effect.get_localised_string(tostring(query_character:get_surname()))
    if surname ~= "" then
        name = surname
    end
    if forename ~= "" then
        if locale == "en" and name ~= "" then
            name = name .. " " .. forename
        else
            name = name .. forename
        end
    end
    return name;
end

local function character_has_ceo(character_key, ceo_key)
    local q_char =query_for_template(character_key)
    if not q_char
    or q_char:is_null_interface()
    or q_char:is_dead()
    then
        return nil
    end
    local ceos = q_char:ceo_management():all_ceos()
    for j = 0, ceos:num_items() - 1 do
        local ceo = ceos:item_at(j);
        ----ModLog(ceo:ceo_data_key())
        if ceo:ceo_data_key() == ceo_key then
            return true
        end
    end
    return false
end

local function add_character(character_key, faction_key, character_subtype)
    local q_faction = cm:query_faction(faction_key)
    if not q_faction or q_faction:is_null_interface() or q_faction:is_dead() then
        return false
    end
    
    local q_char;
    
    if is_number(character_key) then
        q_char = cm:query_model():character_for_command_queue_index(character_key)
        if q_char and not q_char:is_null_interface() then
            character_key = q_char:generation_template_key()
        else
            return false;
        end
    elseif is_string(character_key) then
        q_char = query_for_template(character_key)
    elseif is_character(character_key) then
        q_char = character_key;
        character_key = q_char:generation_template_key()
    else
        return false
    end

    if q_char and not q_char:is_null_interface() and q_char:is_dead() then
        local modify_character = cm:modify_faction(faction_key):create_character_from_template("general", character_subtype, character_key, false)
        --ModLog("角色生成 -- 新建：" .. get_string_name(modify_character:query_character()) .. ",位于" .. gst.faction_get_string_name(faction_key) .. "，五行为 " .. character_subtype)
        return modify_character:query_character()
    end
    if q_char and not q_char:is_null_interface() then
        cm:modify_character(q_char):move_to_faction_and_make_recruited(faction_key)
        --ModLog("角色生成 -- 重新生成：" .. get_string_name(q_char) .. ",位于" .. gst.faction_get_string_name(faction_key) .. "，五行为 " .. character_subtype)
        return q_char
    else
        local modify_character = cm:modify_faction(faction_key):create_character_from_template("general", character_subtype, character_key, false)
        --ModLog("角色生成 -- 新建：" .. get_string_name(modify_character:query_character()) .. ",位于" .. gst.faction_get_string_name(faction_key) .. "，五行为 " .. character_subtype)
        return modify_character:query_character()
    end
    return false
end

local function kill_character(character_key)
    local q_char;
    
    if is_number(character_key) then
        q_char = cm:query_model():character_for_command_queue_index(character_key)
        if q_char and not q_char:is_null_interface() then
            character_key = q_char:generation_template_key()
        else
            return false;
        end
    elseif is_string(character_key) then
        q_char = query_for_template(character_key)
    elseif is_character(character_key) then
        q_char = character_key;
        character_key = q_char:generation_template_key()
    else
        return false
    end
    
    if q_char and not q_char:is_null_interface() and not q_char:is_dead() then
        --ModLog("收到命令要求".. get_string_name(q_char) .. "即刻去世")
        cm:modify_character(q_char):kill_character(false)
    end
end

local function force_kill_character(character_key)
    local q_char;
    
    if is_number(character_key) then
        q_char = cm:query_model():character_for_command_queue_index(character_key)
        if q_char and not q_char:is_null_interface() then
            character_key = q_char:generation_template_key()
        else
            return false;
        end
    elseif is_string(character_key) then
        q_char = query_for_template(character_key)
    elseif is_character(character_key) then
        q_char = character_key;
        character_key = q_char:generation_template_key()
    else
        return false
    end
    
    if q_char and not q_char:is_null_interface() and not q_char:is_dead() then
        cm:modify_character(q_char):kill_character(true);
    end
end;


local function add_character_to_pool(character_key, faction_key, character_subtype, force)
    local q_faction = cm:query_faction(faction_key)
    if not q_faction or q_faction:is_null_interface() or q_faction:is_dead() then
        return false
    end
    
    local q_char;
    
    if is_number(character_key) then
        q_char = cm:query_model():character_for_command_queue_index(character_key)
        if q_char and not q_char:is_null_interface() then
            character_key = q_char:generation_template_key()
        else
            return false;
        end
    elseif is_string(character_key) then
        q_char = query_for_template(character_key)
    elseif is_character(character_key) then
        q_char = character_key;
        character_key = q_char:generation_template_key()
    else
        return false
    end
    
    if gst.lib_value_in_list(cm:get_saved_value("xyy_character_lottery_pool"), character_key)
    or gst.lib_value_in_list(cm:get_saved_value("xyy_character_up_pool"), character_key)
    or gst.lib_value_in_list(cm:get_saved_value("selected_1p"), character_key)
    or gst.lib_value_in_list(cm:get_saved_value("selected_2p"), character_key)
    then
        return false
    end
    
    if q_char and not q_char:is_null_interface() and q_char:is_dead() then
        return q_char
    end 
    if q_char and not q_char:is_null_interface() then
        if not force and q_char:faction():is_human() and not q_char:is_character_is_faction_recruitment_pool() then
            return q_char
        else
            cm:modify_character(q_char):move_to_faction(faction_key)
            --ModLog("角色生成 -- 转势力：" .. get_string_name(q_char) .. ",位于" .. gst.faction_get_string_name(faction_key) .. "，五行为 " ..character_subtype)
            return q_char
        end
    else    
        local character = cm:modify_faction(faction_key):create_character_from_template("general", character_subtype, character_key, false)
        --ModLog("角色生成 -- 新建：" .. get_string_name(character:query_character()) .. ",位于" .. gst.faction_get_string_name(faction_key) .. "，五行为 " ..character_subtype)
        return character:query_character()
    end
    return false
end

local function character_close_agent(character_key)
    local q_char;
    
    if is_number(character_key) then
        q_char = cm:query_model():character_for_command_queue_index(character_key)
        if q_char and not q_char:is_null_interface() then
            character_key = q_char:generation_template_key()
        else
            return false;
        end
    elseif is_string(character_key) then
        q_char = query_for_template(character_key)
    elseif is_character(character_key) then
        q_char = character_key;
        character_key = q_char:generation_template_key()
    else
        return false
    end
    
    if not q_char:is_null_interface() then
        if q_char:has_undercover_character_enabler() == true then
            cm:modify_character(q_char):set_undercover_character_enabler(false);        
        end;
    end;
end;
  -- move/create character in specified faction

local function character_CEO_unequip(character_key, category_key)
    local q_char_to_be_set;
    
    if is_number(character_key) then
        q_char_to_be_set = cm:query_model():character_for_command_queue_index(character_key)
        if q_char_to_be_set and not q_char_to_be_set:is_null_interface() then
            character_key = q_char_to_be_set:generation_template_key()
        else
            return;
        end
    elseif is_string(character_key) then
        q_char_to_be_set = query_for_template(character_key)
    elseif is_character(character_key) then
        q_char_to_be_set = character_key;
        character_key = q_char_to_be_set:generation_template_key()
    else
        return
    end
    
    if q_char_to_be_set and not q_char_to_be_set:is_null_interface() and not q_char_to_be_set:is_dead() and not q_char_to_be_set:is_character_is_faction_recruitment_pool() then
        local slots = q_char_to_be_set:ceo_management():all_ceo_equipment_slots()
        for l = 0, slots:num_items() - 1 do
            local slot = slots:item_at(l);
            if slot:category_key() == category_key then
                cm:modify_character(q_char_to_be_set):ceo_management():unequip_slot(slot);
            end
        end
        --ModLog("装备修改：" .. get_string_name(q_char_to_be_set) .. "取消装备" );
    end
end;


local function character_CEO_equip(character_key, ceo_key, category_key)
    local q_char_to_be_set;
    
    if is_number(character_key) then
        q_char_to_be_set = cm:query_model():character_for_command_queue_index(character_key)
        if q_char_to_be_set and not q_char_to_be_set:is_null_interface() then
            character_key = q_char_to_be_set:generation_template_key()
        else
            return false;
        end
    elseif is_string(character_key) then
        q_char_to_be_set = query_for_template(character_key)
    elseif is_character(character_key) then
        q_char_to_be_set = character_key;
        character_key = q_char_to_be_set:generation_template_key()
    else
        return false
    end
    if q_char_to_be_set and not q_char_to_be_set:is_null_interface() and not q_char_to_be_set:is_dead() then
        cdir_events_manager:add_or_remove_ceo_from_faction(q_char_to_be_set:faction():name(), ceo_key, true);
        ancillaries:equip_ceo_on_character(q_char_to_be_set, ceo_key, category_key);
        --ModLog("装备修改：" .. get_string_name(q_char_to_be_set) .. "装备了".. ceo_key );
    end
end;

local function character_CEO_remove(ceo_key, faction_key) 
    local q_faction = cm:query_faction(faction_key);
    if q_faction and not q_faction:is_null_interface() and not q_faction:is_dead() then
        cdir_events_manager:add_or_remove_ceo_from_faction(faction_key, ceo_key, false);
    end
end;

local function random_create_character(character_key, character_subtype_key)
    local query_character;
    
    if is_number(character_key) then
        query_character = cm:query_model():character_for_command_queue_index(character_key)
        if query_character and not query_character:is_null_interface() then
            character_key = query_character:generation_template_key()
        else
            return false;
        end
    elseif is_string(character_key) then
        query_character = query_for_template(character_key)
    elseif is_character(character_key) then
        query_character = character_key;
        character_key = query_character:generation_template_key()
    else
        return false
    end
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
        query_character = gst.character_add_to_faction(character_key,random_faction:name(),character_subtype_key)
        --ModLog(get_string_name(query_character) .. "加入了" .. gst.faction_get_string_name(random_faction));
        return query_character;
        --cm:modify_faction(random_faction:name()):create_character_from_template("general", character_subtype_key, character_key, false);
    end
end
-- TODO: 随机派系方法是否可以提取共用
local function character_runaway(character_key)
    --获取派系列表
    local world_faction_list = cm:query_model():world():faction_list();
    local invalid_factions = {}
    for i = 0, world_faction_list:num_items() - 1 do
        local faction = world_faction_list:item_at(i);
        if not faction:is_null_interface()
        and not faction:is_dead()
        and not faction:is_human()
        and faction:name() ~= "xyyhlyjf"
        and faction:subculture() ~= "3k_main_subculture_yellow_turban"
        and faction:subculture() ~= "3k_dlc05_subculture_bandits"
        and faction:subculture() ~= "3k_dlc06_subculture_nanman"
        then
            table.insert(invalid_factions,faction:name());
        end
    end
    if #invalid_factions > 0 then
        local id = cm:random_int(#invalid_factions, 1)
        local random_faction = invalid_factions[id];
        --加入随机派系
        local query_character;
        
        if is_number(character_key) then
            query_character = cm:query_model():character_for_command_queue_index(character_key)
            if query_character and not query_character:is_null_interface() then
                character_key = query_character:generation_template_key()
            else
                return false;
            end
        elseif is_string(character_key) then
            query_character = query_for_template(character_key)
        elseif is_character(character_key) then
            query_character = character_key;
            character_key = query_character:generation_template_key()
        else
            return false
        end
        if query_character and not query_character:is_null_interface() then
            if not query_character:is_dead() then
                cm:modify_character(query_character):move_to_faction_and_make_recruited(random_faction);
                return cm:query_faction(random_faction)
            end
        end
    end
end;

local function character_runaway_not_recruited(character_key)
    --获取派系列表
    local world_faction_list = cm:query_model():world():faction_list();
    local invalid_factions = {}
    for i = 0, world_faction_list:num_items() - 1 do
        local faction = world_faction_list:item_at(i);
        if not faction:is_null_interface()
        and not faction:is_dead()
        and not faction:is_human()
        and faction:name() ~= "xyyhlyjf"
        and faction:subculture() ~= "3k_main_subculture_yellow_turban"
        and faction:subculture() ~= "3k_dlc05_subculture_bandits"
        and faction:subculture() ~= "3k_dlc06_subculture_nanman"
        then
            table.insert(invalid_factions,faction:name());
        end
    end
    if #invalid_factions > 0 then
        local id = cm:random_int(#invalid_factions, 1)
        local random_faction = invalid_factions[id];
        --加入随机派系
        local query_character;
        
        if is_number(character_key) then
            query_character = cm:query_model():character_for_command_queue_index(character_key)
            if query_character and not query_character:is_null_interface() then
                character_key = query_character:generation_template_key()
            else
                return false;
            end
        elseif is_string(character_key) then
            query_character = query_for_template(character_key)
        elseif is_character(character_key) then
            query_character = character_key;
            character_key = query_character:generation_template_key()
        else
            return false
        end
        if query_character and not query_character:is_null_interface() then
            if not query_character:is_dead() then
                cm:modify_character(query_character):move_to_faction(random_faction);
            end
        end
    end
end;

local function is_faction_have_character(faction_key, character_key)
    local character = query_for_template(character_key)
    if not character or character:is_null_interface() or character:is_dead() or character:is_character_is_faction_recruitment_pool() then
        return false;
    end
    return character:faction():name() == faction_key;
end;

local function get_random_deployable_character(faction_key)
    local query_faction = cm:query_faction(faction_key);
    local index = {};
    for i = 0, query_faction:character_list():num_items() - 1 do
        local query_character = query_faction:character_list():item_at(i);
        if query_character 
        and not query_character:is_null_interface() 
        and not query_character:is_dead() 
        and query_faction:faction_leader() ~= query_character 
        and query_character:get_is_deployable()
        and query_character:has_come_of_age()
        and not query_character:is_deployed()
        then
            table.insert(index, query_character);
        end
    end
    
    if #index >= 0 then
        local random = cm:random_int(#index, 1);
        local query_character = index[random];
        return query_character
    end 
    
    return nil;
end

local function character_remove_all_traits(q_target_character)
    local traits_ceos_list = {"3k_main_ceo_trait_personality_aescetic", "3k_main_ceo_trait_personality_ambitious", 
    "3k_main_ceo_trait_personality_arrogant", "3k_main_ceo_trait_personality_artful", "3k_main_ceo_trait_personality_brave", 
    "3k_main_ceo_trait_personality_brilliant", "3k_main_ceo_trait_personality_careless", "3k_main_ceo_trait_personality_cautious", 
    "3k_main_ceo_trait_personality_charismatic", "3k_main_ceo_trait_personality_charitable", "3k_main_ceo_trait_personality_clever", 
    "3k_main_ceo_trait_personality_competative", "3k_main_ceo_trait_personality_cowardly", "3k_main_ceo_trait_personality_cruel", 
    "3k_main_ceo_trait_personality_cunning", "3k_main_ceo_trait_personality_deceitful", "3k_main_ceo_trait_personality_defiant", 
    "3k_main_ceo_trait_personality_determined", "3k_main_ceo_trait_personality_direct", "3k_main_ceo_trait_personality_disciplined", 
    "3k_main_ceo_trait_personality_disloyal", "3k_main_ceo_trait_personality_distinguished", "3k_main_ceo_trait_personality_dutiful", 
    "3k_main_ceo_trait_personality_elusive", "3k_main_ceo_trait_personality_energetic", "3k_main_ceo_trait_personality_enigmatic", 
    "3k_main_ceo_trait_personality_fiery", "3k_main_ceo_trait_personality_fraternal", "3k_main_ceo_trait_personality_greedy", 
    "3k_main_ceo_trait_personality_honourable", "3k_main_ceo_trait_personality_humble", "3k_main_ceo_trait_personality_incompetent", 
    "3k_main_ceo_trait_personality_indecisive", "3k_main_ceo_trait_personality_intimidating", "3k_main_ceo_trait_personality_kind", 
    "3k_main_ceo_trait_personality_loyal", "3k_main_ceo_trait_personality_modest", "3k_main_ceo_trait_personality_pacifist", 
    "3k_main_ceo_trait_personality_patient", "3k_main_ceo_trait_personality_perceptive", "3k_main_ceo_trait_personality_quiet", 
    "3k_main_ceo_trait_personality_reckless", "3k_main_ceo_trait_personality_resourceful", "3k_main_ceo_trait_personality_scholarly", 
    "3k_main_ceo_trait_personality_sincere", "3k_main_ceo_trait_personality_solitary", "3k_main_ceo_trait_personality_stubborn", 
    "3k_main_ceo_trait_personality_superstitious", "3k_main_ceo_trait_personality_suspicious", "3k_main_ceo_trait_personality_trusting", 
    "3k_main_ceo_trait_personality_unobservant", "3k_main_ceo_trait_personality_vain", "3k_main_ceo_trait_personality_vengeful", 
    "3k_main_ceo_trait_physical_agile", "3k_main_ceo_trait_physical_beautiful", "3k_main_ceo_trait_physical_blind", 
    "3k_main_ceo_trait_physical_clumsy", "3k_main_ceo_trait_physical_coordinated", "3k_main_ceo_trait_physical_decrepit", 
    "3k_main_ceo_trait_physical_drunk", "3k_main_ceo_trait_physical_eunuch", "3k_main_ceo_trait_physical_fat", 
    "3k_main_ceo_trait_physical_fertile", "3k_main_ceo_trait_physical_graceful", "3k_main_ceo_trait_physical_handsome", 
    "3k_main_ceo_trait_physical_healthy", "3k_main_ceo_trait_physical_heartbroken", "3k_main_ceo_trait_physical_ill", 
    "3k_main_ceo_trait_physical_infertile", "3k_main_ceo_trait_physical_lovestruck", "3k_main_ceo_trait_physical_lumbering", 
    "3k_main_ceo_trait_physical_mad", "3k_main_ceo_trait_physical_maimed_arm", "3k_main_ceo_trait_physical_maimed_leg", 
    "3k_main_ceo_trait_physical_one-eyed", "3k_main_ceo_trait_physical_poxxed", "3k_main_ceo_trait_physical_scarred", 
    "3k_main_ceo_trait_physical_shu_tiger_general", "3k_main_ceo_trait_physical_sickly", "3k_main_ceo_trait_physical_strong", 
    "3k_main_ceo_trait_physical_sui_knight", "3k_main_ceo_trait_physical_tough", "3k_main_ceo_trait_physical_weak", 
    "3k_main_ceo_trait_physical_wei_elite_general", "3k_ytr_ceo_trait_personality_benevolent", "3k_ytr_ceo_trait_personality_gentle_hearted", 
    "3k_ytr_ceo_trait_personality_heaven_bright", "3k_ytr_ceo_trait_personality_heaven_creative", "3k_ytr_ceo_trait_personality_heaven_honest", 
    "3k_ytr_ceo_trait_personality_heaven_selfless", "3k_ytr_ceo_trait_personality_heaven_tolerant", "3k_ytr_ceo_trait_personality_heaven_tranquil", 
    "3k_ytr_ceo_trait_personality_heaven_wise", "3k_ytr_ceo_trait_personality_land_alert", "3k_ytr_ceo_trait_personality_land_aspiring", 
    "3k_ytr_ceo_trait_personality_land_composed", "3k_ytr_ceo_trait_personality_land_courageous", "3k_ytr_ceo_trait_personality_land_generous", 
    "3k_ytr_ceo_trait_personality_land_powerful", "3k_ytr_ceo_trait_personality_land_proud", "3k_ytr_ceo_trait_personality_people_amiable", 
    "3k_ytr_ceo_trait_personality_people_cheerful", "3k_ytr_ceo_trait_personality_people_compassionate", "3k_ytr_ceo_trait_personality_people_friendly", 
    "3k_ytr_ceo_trait_personality_people_people_pleaser", "3k_ytr_ceo_trait_personality_people_stern", "3k_ytr_ceo_trait_personality_people_understanding", 
    "3k_ytr_ceo_trait_personality_relentless", "3k_ytr_ceo_trait_personality_simple", "3k_ytr_ceo_trait_personality_stalwart", 
    "3k_ytr_ceo_trait_personality_strong_willed", "3k_ytr_ceo_trait_personality_temperamental", "3k_ytr_ceo_trait_personality_trustworthy", 
    "3k_ytr_ceo_trait_personality_vindictive", "3k_ytr_ceo_trait_physical_feared", "3k_ytr_ceo_trait_physical_healer_of_people", 
    "3k_ytr_ceo_trait_physical_impeccable", "3k_ytr_ceo_trait_physical_leader_of_people", "3k_ytr_ceo_trait_physical_protector_of_people", 
    "3k_ytr_ceo_trait_physical_sprained_ankle", "3k_ytr_ceo_trait_physical_wound"}
    
    if q_target_character and not q_target_character:is_null_interface() then
        for _,i in pairs(traits_ceos_list) do
            cm:modify_character(q_target_character):ceo_management():remove_ceos(i);
        end
    end;
end;

--是否受伤了
local function is_wounded(query_character) 
    if not cm:get_saved_value("wounded_table") then
        ModLog(get_string_name(query_character) .. "的受伤状态是：0（未受伤）")
        return 0
    end
    local table = cm:get_saved_value("wounded_table")
    local cqi = tostring(query_character:cqi())
    if table[cqi] and table[cqi] > 0 then
        ModLog(get_string_name(query_character) .. "的受伤状态是：".. table[cqi] .. "（已受伤）")
        return table[cqi]
    end
    ModLog(get_string_name(query_character) .. "的受伤状态是：0（未受伤）")
    return 0;
end

local function add_CEO_and_equip(character_key, ceo_key, category_key, is_unique)
    local q_char_to_be_set;
    
    if is_number(character_key) then
        q_char_to_be_set = cm:query_model():character_for_command_queue_index(character_key)
        if q_char_to_be_set and not q_char_to_be_set:is_null_interface() then
            character_key = q_char_to_be_set:generation_template_key()
        else
            return false;
        end
    elseif is_string(character_key) then
        q_char_to_be_set = query_for_template(character_key)
    elseif is_character(character_key) then
        q_char_to_be_set = character_key;
        character_key = q_char_to_be_set:generation_template_key()
    else
        return false
    end
    if q_char_to_be_set and not q_char_to_be_set:is_null_interface() and not q_char_to_be_set:is_dead() then
        if not (is_unique and gst.faction_has_ceo(q_char_to_be_set:faction():name(), ceo_key)) then
            cdir_events_manager:add_or_remove_ceo_from_faction(q_char_to_be_set:faction():name(), ceo_key, true);
        end
        cm:modify_character(q_char_to_be_set):ceo_management():add_ceo(ceo_key);
        ancillaries:equip_ceo_on_character(q_char_to_be_set, ceo_key, category_key);
    end
end;

local function is_dead(character_key)
    local q_char_to_be_set;
    
    if is_number(character_key) then
        q_char_to_be_set = cm:query_model():character_for_command_queue_index(character_key)
        if q_char_to_be_set and not q_char_to_be_set:is_null_interface() then
            character_key = q_char_to_be_set:generation_template_key()
        else
            return false;
        end
    elseif is_string(character_key) then
        q_char_to_be_set = query_for_template(character_key)
    elseif is_character(character_key) then
        q_char_to_be_set = character_key;
        character_key = q_char_to_be_set:generation_template_key()
    else
        return false
    end
    if q_char_to_be_set and not q_char_to_be_set:is_null_interface() and q_char_to_be_set:is_dead() then
        return true
    end
    return false
end;

-----------------------------------------------------------------
--  Register
-----------------------------------------------------------------
gst.character_add_to_faction = add_character
gst.character_been_killed = kill_character
gst.character_add_to_recruit_pool = add_character_to_pool
gst.character_close_agent = character_close_agent
gst.character_CEO_unequip = character_CEO_unequip
gst.character_CEO_equip = character_CEO_equip
gst.character_CEO_remove = character_CEO_remove
gst.character_force_been_killed = force_kill_character
gst.character_join_random_faction = random_create_character
gst.character_runaway = character_runaway
gst.character_runaway_not_recruited = character_runaway_not_recruited
gst.character_remove_all_traits = character_remove_all_traits
gst.character_is_wounded = is_wounded
gst.character_add_CEO_and_equip = add_CEO_and_equip
gst.character_is_faction_have = is_faction_have_character
gst.character_random_deployable_character = get_random_deployable_character
gst.character_query_for_template = query_for_template
gst.character_has_ceo = character_has_ceo
gst.character_get_string_name = get_string_name
gst.character_is_dead = is_dead
return gst
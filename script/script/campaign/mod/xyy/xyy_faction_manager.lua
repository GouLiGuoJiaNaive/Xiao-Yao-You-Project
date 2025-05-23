local gst = xyy_gst:get_mod()

local function query_military_force_leader(character)
    local military_force = nil
    if character 
    and not character:is_null_interface() 
    and not character:is_dead() 
    and not character:is_character_is_faction_recruitment_pool() then
        if character:has_military_force() then
            return character;
        end
        local military_force_list = character:faction():military_force_list()
        for j = 0, military_force_list:num_items() - 1 do
            local query_military_force = military_force_list:item_at(j);
            local character_list = query_military_force:character_list()
            for i = 0, character_list:num_items() - 1 do
                if character_list:item_at(i) == character then
                    military_force = query_military_force;
                    break
                end
            end
        end
    else
        return nil;
    end
    
    if military_force 
    and not military_force:is_null_interface() 
    then
        if not military_force:general_character() then
            return military_force:character_list():item_at(0) 
        else
            return military_force:general_character()
        end
    else
        return nil;
    end
end

local function getRandomValue(min,max)
    if cm:is_multiplayer() then
        return cm:random_int(min,max)
    end
    --比较大小
    if min > max then
        return math.random(max,min)
    elseif min < max then
        return math.random(min,max)
    else
        return min
    end
end

local function add_tickets(faction_name, int)
    if cm:get_saved_value("ticket_points_"..faction_name) then
        local ticket_points = cm:get_saved_value("ticket_points_"..faction_name)
        cm:set_saved_value("ticket_points_"..faction_name, ticket_points + int)
    else
        cm:set_saved_value("ticket_points_"..faction_name, int)
    end
end

local function sub_tickets(faction_name, int)
    if cm:get_saved_value("ticket_points_"..faction_name) then
        local ticket_points = cm:get_saved_value("ticket_points_"..faction_name)
        local new = ticket_points - int 
        if new < 0 then
            new = 0
        end
        cm:set_saved_value("ticket_points_"..faction_name, new)
    else
        cm:set_saved_value("ticket_points_"..faction_name, 0)
    end
end

local function get_tickets(faction_name)
    if cm:get_saved_value("ticket_points_"..faction_name) then
        return cm:get_saved_value("ticket_points_"..faction_name)
    else
        return 0
    end
end

local function has_ceo(faction_key, ceo_key)
    local q_faction = cm:query_faction(faction_key)
    if not q_faction
    or not q_faction:ceo_management()
    or q_faction:ceo_management():is_null_interface()
    then
        return false
    end
    local query_ceo_mgmt = q_faction:ceo_management()
    if ancillaries:faction_has_ceo_key(query_ceo_mgmt, ceo_key) then
        --ModLog(faction_key .. " has " .. ceo_key)
        return true
--     for j = 0, ceos:num_items() - 1 do
--         local ceo = ceos:item_at(j);
--         --ModLog(ceo:ceo_data_key())
--         if ceo:ceo_data_key() == ceo_key then
--             return true
--         end
--     end
    end
        --ModLog(faction_key .. " not have " .. ceo_key)
    return false
end

local function find_ceo(ceo_key)
    local world_faction_list = cm:query_model():world():faction_list();
    for i = 0, world_faction_list:num_items() - 1 do
        local faction = world_faction_list:item_at(i);
        if not faction:is_null_interface()
        and faction:ceo_management()
        and not faction:ceo_management():is_null_interface()
        and has_ceo(faction:name(), ceo_key)
        then
            return faction;
        end
    end
    return false
end

local function create_military_force(faction_key, region_key, query_character)
    local q_faction = cm:query_faction(faction_key)
    if not q_faction
    or q_faction:is_null_interface()
    or q_faction:is_dead()
    then
        return false
    end
    
    local region = cm:query_region(region_key)
--     if is_string(region_key) then
--         if not region
--         or region:is_null_interface()
--         then
--             return false
--         end
--     elseif is_region(region_key) then
--         region = region_key
--         region_key = region:name()
--     end
    
    local region_x = region:settlement():logical_position_x() + getRandomValue(1,1200) / 100 - 6;
    local region_y = region:settlement():logical_position_y() + getRandomValue(1,1200) / 100 - 6;
            
    local found_pos, x, y = q_faction:get_valid_spawn_location_near(region_x, region_y, 10, false);
    
    local i = 0
    
    while not found_pos do
        region_x = region:settlement():logical_position_x() + getRandomValue(1,1200 + i * 10) / 100 - 6;
        --ModLog(region_x)
        region_y = region:settlement():logical_position_y() + getRandomValue(1,1200 + i * 10) / 100 - 6;
        --ModLog(region_y)
        found_pos, x, y = q_faction:get_valid_spawn_location_near(region_x, region_y, 10, false);
        i = i + 1;
    end
    --ModLog(x.." "..y)
    if not query_character:has_military_force() then
        local military_force_name = faction_key .. "_" .. query_character:generation_template_key()
        cm:create_force_with_existing_general(query_character:command_queue_index(), faction_key, "", region_key, x, y, military_force_name, nil, 100);
    else
        cm:modify_character(query_character):teleport_to(x, y);
    end
    
    ModLog("创建了".. gst.character_get_string_name(query_character) .. "的部队")
    return query_character:military_force()
end

local function teleport_to_region(query_character, region_key)
    if is_string(query_character) then
        query_character = gst.character_query_for_template(query_character)
    end
    local q_faction = query_character:faction()
    if not q_faction
    or q_faction:is_null_interface()
    or q_faction:is_dead()
    then
        return false
    end
    
    local region = cm:query_region(region_key)
    local leader_character = query_military_force_leader(query_character)
--     if is_string(region_key) then
--         if not region
--         or region:is_null_interface()
--         then
--             return false
--         end
--     elseif is_region(region_key) then
--         region = region_key
--         region_key = region:name()
--     end
    
    local region_x = region:settlement():logical_position_x() + getRandomValue(1,1200) / 100 - 6;
    local region_y = region:settlement():logical_position_y() + getRandomValue(1,1200) / 100 - 6;
            
    local found_pos, x, y = q_faction:get_valid_spawn_location_near(region_x, region_y, 10, false);
    
    local i = 0
    
    while not found_pos do
        region_x = region:settlement():logical_position_x() + getRandomValue(1,1200 + i * 10) / 100 - 6;
        region_y = region:settlement():logical_position_y() + getRandomValue(1,1200 + i * 10) / 100 - 6;
        found_pos, x, y = q_faction:get_valid_spawn_location_near(region_x, region_y, 10, false);
        i = i + 1;
    end
    
    if leader_character and leader_character:has_military_force() then
        ModLog("移动".. gst.character_get_string_name(query_character) .. "的所在部队")
        cm:modify_character(leader_character):teleport_to(x, y);
    else
        return nil
    end
    return leader_character:military_force()
end

local function subtract_tickets(faction_name, int)
    if cm:get_saved_value("ticket_points_"..faction_name) then
        local ticket_points = cm:get_saved_value("ticket_points_"..faction_name)
        local tickets = ticket_points - int
        if tickets < 0 then
            tickets = 0
        end
        cm:set_saved_value("ticket_points_"..faction_name, tickets)
    elseif cm:get_saved_value("ticket_points") then
        local ticket_points = cm:get_saved_value("ticket_points")
        local tickets = ticket_points - int
        if tickets < 0 then
            tickets = 0
        end
        cm:set_saved_value("ticket_points_"..faction_name, tickets)
        cm:set_saved_value("ticket_points", false)
    else
        cm:set_saved_value("ticket_points_"..faction_name, 0)
    end
end

local function leader_abdication(faction_key)
    local q_faction = cm:query_faction(faction_key);
    for i = 0, q_faction:character_list():num_items() - 1 do
        local character = q_faction:character_list():item_at(i);
        if not character:is_dead() 
        and character:family_member():come_of_age() 
        and not character:character_post():is_null_interface()  
        then
            if character:character_type("general")
            and character:character_post():ministerial_position_record_key() == "faction_heir" 
            then
                
                cm:modify_character(character):assign_faction_leader();
            break;  
            end
        end
    end
end

local function get_faction_heir(faction_key)
    local q_faction = cm:query_faction(faction_key);
    for i = 0, q_faction:character_list():num_items() - 1 do
        local character = q_faction:character_list():item_at(i);
        if not character:is_dead() 
        and character:family_member():come_of_age() 
        and not character:character_post():is_null_interface()  
        then
            if character:character_type("general")
            and character:character_post():ministerial_position_record_key() == "faction_heir" 
            then
                return character
            end
        end
    end
end

local function set_minister_position(character_key, minister_position)
    local q_char_to_be_set = cm:query_model():character_for_template(character_key);    
    
    if minister_position == "faction_leader" then
        cm:modify_character(q_char_to_be_set):assign_faction_leader();
    end
    if q_char_to_be_set and not q_char_to_be_set:is_null_interface() and not q_char_to_be_set:is_dead() then
        cm:modify_character(q_char_to_be_set):assign_to_post(minister_position);
        --ModLog("设置官职：" .. character_key .. "设置为"..minister_position);
    else
        --ModLog("设置官职 -- ERROR：" .. character_key .. "不存在！");
    end
end

local function random_kill_character(faction_key, number) 
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
            --ModLog(query_character:character_subtype_key() .. " " .. query_character:generation_template_key());
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
end

local function kill_all_character_from_faction(faction_key)
    local q_faction = cm:query_faction(faction_key);
    if q_faction
    and not q_faction:is_null_interface()
    and not q_faction:is_dead()
    then
        local modify_faction = cm:modify_faction(q_faction);
        for i = 0, q_faction:character_list():num_items() - 1 do
        local character = q_faction:character_list():item_at(i);
            if 
            not character:is_null_interface() 
            and not character:is_dead() 
            and character:character_type("general")
            then
                modify_character(character):kill_character(true);
            end;
        end;
    end;
end

local function gen_check_if_all_adjacent_factions_allies(faction_key)
    
    local query_faction = cm:query_faction(faction_key);
    
    if not query_faction 
    or query_faction:is_null_interface()
    or query_faction:is_dead()
    or query_faction:has_capital_region() then
        return false;
    end;
    
    local region_list = query_faction:region_list();
    
    for i = 0, region_list:num_items() - 1 do
        
        local query_region = region_list:item_at(i);
        local adjacent_region_list = query_region:adjacent_region_list()
        
        for j = 0, adjacent_region_list:num_items() - 1 do
        
            local query_adjacent_region = adjacent_region_list:item_at(j);
            local adjacent_faction_key = query_adjacent_region:owning_faction():name();
            
            if query_adjacent_region:is_abandoned() then
                return false;
            end;

            if query_adjacent_region:owning_faction():is_human() then
                return false;
            end;

            if adjacent_faction_key == faction_key then
                return false;
            end;
            
            if not diplomacy_manager:is_ally_or_vassal(faction_key, adjacent_faction_key) then
                return false;
            end;
            
            return true;
        end;
    end;
end

local function get_string_name(faction)
    if is_string(faction) then
        faction = cm:query_faction(faction)
        if not faction 
        or faction:is_null_interface()
        then
            return ""
        end
    end
    if not cm:get_saved_value("kafka_mission") and faction:name() == "3k_main_faction_shoufang" then
        return effect.get_localised_string("factions_screen_name_unknown")
    end
    if faction:name() == "3k_dlc04_faction_rebels" then
        return effect.get_localised_string("factions_screen_name_3k_dlc04_faction_rebels")
    end
    if faction:name() == "3k_main_faction_yellow_turban_generic" then
        return effect.get_localised_string("factions_screen_name_3k_main_faction_yellow_turban_generic")
    end
    if faction:name() == "3k_main_faction_han_empire" then
        return effect.get_localised_string("factions_screen_name_3k_main_faction_han_empire")
    end
    if faction:name() == "3k_dlc06_faction_nanman_rebels" then
        return effect.get_localised_string("factions_screen_name_3k_dlc06_faction_nanman_rebels")
    end
    if faction:name() == "xyyhlyjf" then
        return effect.get_localised_string("factions_screen_name_xyyhlyjf")
    end
    
    if not faction:is_dead() then 
        if faction:faction_leader():generation_template_key() == "3k_dlc04_template_historical_emperor_xian_earth" then
            return effect.get_localised_string("campaign_group_faction_cosmetic_overrides_name_3k_dlc07_campaign_group_cosmetic_tag_faction_name_han_empire")
        elseif faction:faction_leader():generation_template_key() == "3k_dlc04_template_historical_emperor_ling_earth" then
            return effect.get_localised_string("campaign_group_faction_cosmetic_overrides_name_3k_dlc07_campaign_group_cosmetic_tag_faction_name_han_empire")
        elseif faction:faction_leader():generation_template_key() == "hlyjcm" then
            return effect.get_localised_string("campaign_group_faction_cosmetic_overrides_name_3k_main_campaign_group_cosmetic_tag_faction_name_hlyjcm")
        else
            if faction:is_world_leader() 
            and faction:name() 
            and not string.find(tostring(faction:name()),"_separatists") then
                if string.find(tostring(faction:name()),"xyy") then
                    return effect.get_localised_string("campaign_group_faction_cosmetic_overrides_name_3k_main_campaign_group_cosmetic_tag_faction_name_" .. faction:name() .. "_world_leader");
                end
                local name = string.gsub(faction:name(),"3k_main_faction_", "campaign_group_faction_cosmetic_overrides_name_3k_main_campaign_group_cosmetic_tag_faction_name_") 
                local name = string.gsub(name,"3k_dlc04_faction_", "campaign_group_faction_cosmetic_overrides_name_3k_dlc04_campaign_group_cosmetic_tag_faction_name_") 
                local name = string.gsub(name,"3k_dlc05_faction_", "campaign_group_faction_cosmetic_overrides_name_3k_dlc05_campaign_group_cosmetic_tag_faction_name_") 
                local name = string.gsub(name,"3k_dlc07_faction_", "campaign_group_faction_cosmetic_overrides_name_3k_dlc07_campaign_group_cosmetic_tag_faction_name_") 
                local name = name .. "_world_leader"
                return effect.get_localised_string(name)
            else
                local name = gst.character_get_string_name(faction:faction_leader())
                if name and name ~= "" then
                    return gst.character_get_string_name(faction:faction_leader())
                else
                    return effect.get_localised_string("factions_screen_name_" .. tostring(faction:name()))
                end
            end
        end
    else
        return effect.get_localised_string("factions_screen_name_" .. tostring(faction:name()))
    end
end

local function find_character_military_force(character)
    if is_string(character) then
        character = gst.character_query_for_template(character)
    end
    if character 
    and not character:is_null_interface() 
    and not character:is_dead() 
    and not character:is_character_is_faction_recruitment_pool() then
        local military_force_list = character:faction():military_force_list()
        for j = 0, military_force_list:num_items() - 1 do
            local query_military_force = military_force_list:item_at(j);
            local character_list = query_military_force:character_list()
            if character_list:contains(character) then
                return query_military_force;
            end
        end
        local force = create_military_force(character:faction():name(), character:faction():capital_region():name(), character)
        local index = 0
        while not force and index < character:faction():region_list():num_items() do
            force = create_military_force(character:faction():name(), character:faction():region_list():item_at(index):name(), character)
        end
        return force
    else
        return nil;
    end
end

local function is_deployed(character) 
    if is_string(character) then
        character = gst.character_query_for_template(character)
    end
    local military_force_list = character:faction():military_force_list()
    for j = 0, military_force_list:num_items() - 1 do
        local query_military_force = military_force_list:item_at(j);
        local character_list = query_military_force:character_list()
        if character_list:contains(character) then
            return true;
        end
    end
    return false;
end

local function is_character_in_force(character, military_force) 
    if is_string(character) then
        character = gst.character_query_for_template(character)
    end
    if not character
    or character:is_null_interface()
    or character:is_dead()
    then
        return false;
    end
    if military_force:has_general() and military_force:general_character() == character then
        return true;
    end
    local character_list = military_force:character_list()
    return character_list:contains(character);
end

local function query_character_force(character) 
    if is_string(character) then
        character = gst.character_query_for_template(character)
    end
    if character 
    and not character:is_null_interface() 
    and not character:is_dead() 
    and not character:is_character_is_faction_recruitment_pool() then
        local military_force_list = character:faction():military_force_list()
        for j = 0, military_force_list:num_items() - 1 do
            local query_military_force = military_force_list:item_at(j);
            local character_list = query_military_force:character_list()
            if character_list:contains(character) then
                return query_military_force;
            end
        end
    end
    return nil;
end
-----------------------------------------------------------------
--  Register
-----------------------------------------------------------------

gst.faction_add_tickets = add_tickets
gst.faction_sub_tickets = sub_tickets
gst.faction_get_tickets = get_tickets
gst.faction_leader_abdication = leader_abdication
gst.faction_get_faction_heir = get_faction_heir
gst.faction_set_minister_position = set_minister_position
gst.faction_random_kill_character = random_kill_character
gst.faction_kill_all_character = kill_all_character_from_faction
gst.faction_subtract_tickets = subtract_tickets
gst.faction_check_all_adjacent_factions_is_allies = gen_check_if_all_adjacent_factions_allies
gst.faction_create_military_force = create_military_force
gst.faction_military_teleport_to_region = teleport_to_region
gst.faction_has_ceo = has_ceo
gst.faction_find_ceo = find_ceo
gst.faction_get_string_name = get_string_name
gst.faction_find_character_military_force = find_character_military_force
gst.faction_is_character_deployed = is_deployed
gst.faction_is_character_in_force = is_character_in_force
gst.faction_query_character_force = query_character_force
return gst
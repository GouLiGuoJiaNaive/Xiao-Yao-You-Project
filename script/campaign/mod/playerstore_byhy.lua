local gst = xyy_gst:get_mod()

local static_id = 0

local static_id_2 = 0

local money_text
local ticket_text

local char_sel_pannel

local panel_time = false
local UI_MOD_NAME = "playerStore_byHy0"

local bt_close_size_x   = 36
local bt_close_size_y   = 36

local panel_size_x      = 1920
local panel_size_y      = 900

local bt_execute_size_x = 200
local bt_execute_size_y = 50

local menu_button = nil;

local menu_button_notification = nil;

local locale = gst.get_locale()

local currect_character_1p = nil
local currect_character_2p = nil

local home_btn_table = {};--主界面的入口按钮

local store_panel = nil;--商店面板

local store_panel_2 = nil;--商店面板2

local characters_illustrations_menu_button = nil;

local xyy_select_character_panel = nil;

local character_illustration_detail = nil;

local store_panel_btn_table = {};--商店面板中所有的按钮

local pannel_index = 0;

local pannel2_index = 0;

local page = 0;

local page2 = 0;

local last_random = 0;
local last_random1 = 0;

local guaranteed = 50;

local xyy_character_lottery_pool;

local selected_1p = {};

local selected_2p = {};

local info_panel;

local notification;

local has_firefly_unlocked;

local has_miyabi_unlocked;

local has_tingyun_unlocked;

local has_cantarella_unlocked;

local xyy_character_up_pool = gst.xyy_character_up_pool

local character_illustration_button = nil

local xyy_store_items = {
    "xyy_store_craft_weapons",
    "xyy_store_craft_mounts",
    "xyy_store_craft_armors",
    "xyy_store_craft_accessories",
    "xyy_store_craft_weapons_1",
    "xyy_store_craft_mounts_1",
    "xyy_store_craft_armors_1",
    "xyy_store_craft_accessories_1"
}

local store_items = {
    ["xyy_store_craft_weapons"] = { ["price"] = 7000, ["quality"] = "gold", ["time"] = 3 },
    ["xyy_store_craft_mounts"] = { ["price"] = 6000, ["quality"] = "gold", ["time"] = 4 },
    ["xyy_store_craft_armors"] = { ["price"] = 2000, ["quality"] = "gold", ["time"] = 2 },
    ["xyy_store_craft_accessories"] = { ["price"] = 4000, ["quality"] = "gold", ["time"] = 2 },
    ["xyy_store_craft_weapons_1"] = { ["price"] = 1000, ["quality"] = "silver", ["time"] = 3 },
    ["xyy_store_craft_mounts_1"] = { ["price"] = 1000, ["quality"] = "silver", ["time"] = 4 },
    ["xyy_store_craft_armors_1"] = { ["price"] = 1000, ["quality"] = "silver", ["time"] = 2 },
    ["xyy_store_craft_accessories_1"] = { ["price"] = 1000, ["quality"] = "silver", ["time"] = 2 },
}

local items_names = gst.all_items_names
--初级氪金    ------------------精制-----------------
local random_item1_weapon = gst.store_random_item1_weapon
local random_item1_armour = gst.store_random_item1_armour
local random_item1_mount = gst.store_random_item1_mount
local random_item1_horse = gst.store_random_item1_horse
local random_item1_follower = gst.store_random_item1_follower
local random_item1_accessory = gst.store_random_item1_accessory

--高级氪金   ------------------------exceptional:优秀---------------------------------------------------
local random_item2_weapon = gst.store_random_item2_weapon
local random_item2_armour = gst.store_random_item2_armour
local random_item2_mount = gst.store_random_item2_mount
local random_item2_horse = gst.store_random_item2_horse
local random_item2_follower = gst.store_random_item2_follower
local random_item2_accessory = gst.store_random_item2_accessory

--超级氪金    -------------------------传奇、独特----------------------------------
local random_item3_weapon = gst.store_random_item3_weapon
local random_item3_armour = gst.store_random_item3_armour
local random_item3_mount = gst.store_random_item3_mount
local random_item3_horse = gst.store_random_item3_horse
local random_item3_follower = gst.store_random_item3_follower
local random_item3_accessory = gst.store_random_item3_accessory

local character_browser_list = gst.character_browser_list

local function get_xyy_character_lottery_pool()
    if cm:get_saved_value("character_list") 
    and not cm:get_saved_value("xyy_character_lottery_pool")
    then
        xyy_character_lottery_pool = cm:get_saved_value("character_list")
        ModLog('发现存档中的旧变量记录 character_list')
    elseif cm:get_saved_value("xyy_character_lottery_pool") 
    then
        xyy_character_lottery_pool = cm:get_saved_value("xyy_character_lottery_pool")
        ModLog('发现存档中的新变量记录 xyy_character_lottery_pool')
    end
    if xyy_character_lottery_pool == nil then
        xyy_character_lottery_pool = {}
    end
    return true
end

local function in_xyy_character_browser_list(value)
    if not character_browser_list then
        character_browser_list = cm:get_saved_value("character_browser_list")
    end
    return gst.lib_value_in_list(character_browser_list, value);
end

function disable_menu_button()
    if menu_button and is_uicomponent(menu_button) then
        menu_button:SetState("inactive")
    end
end

function enable_menu_button()
    if menu_button and is_uicomponent(menu_button) then
        menu_button:SetState("active")
    end
end

function add_character_to_player(character_key, faction)
    local player_faction_modify_object = cm:modify_faction(faction)
    if not cm:is_multiplayer() and gst.all_character_detils[character_key]['movie'] then
        cm:modify_model():get_modify_episodic_scripting():register_instant_movie_by_record(gst.all_character_detils[character_key]['movie']);
    end
    local character = gst.character_add_to_faction(character_key, faction:name(), gst.all_character_detils[character_key]['subtype']);
    cm:modify_character(character):reset_skills();
    local incident = cm:modify_model():create_incident("summon_" .. character_key);
    incident:add_character_target("target_character_1", character);
    incident:add_faction_target("target_faction_1", faction);
    incident:trigger(player_faction_modify_object, true);
    
    if character_key == "hlyjct" then
        if cm:query_model():season() == "season_spring" then
            cm:trigger_dilemma(faction:name(), "xyy_path_blessing", true);
        end
    end
    
    if cm:query_model():turn_number() <= 40 and cm:query_model():turn_number() > 20 then
        cm:modify_character(character):add_experience(22000,0);
    elseif cm:query_model():turn_number() <= 70 and cm:query_model():turn_number() > 40 then
        cm:modify_character(character):add_experience(44000,0);
    elseif cm:query_model():turn_number() > 70 then
        cm:modify_character(character):add_experience(88000,0);
    end
    gst.lib_remove_value_from_list(xyy_character_up_pool, character_key)
    gst.lib_remove_value_from_list(xyy_character_lottery_pool, character_key)
    gst.lib_remove_value_from_list(character_browser_list, character_key)
    cm:set_saved_value("xyy_character_up_pool", xyy_character_up_pool)
    cm:set_saved_value("xyy_character_lottery_pool", xyy_character_lottery_pool)
    cm:set_saved_value("character_browser_list", character_browser_list)
    return character
end    

--创建ui：关闭按钮
local function create_bt_close(parent)
    local bt_name = UI_MOD_NAME .. "_store_close_btn";
    local btn_listener_name = bt_name .. "_click_up"
    local bt = core:get_or_create_component(bt_name, "ui/templates/3k_btn_close_32")
    parent:Adopt(bt:Address())
    bt:PropagatePriority(parent:Priority())
    bt:SetTooltipText(effect.get_localised_string("mod_xyy_store_main_tooltip_close_button"), true)
    gst.UI_Component_resize(bt, bt_close_size_x, bt_close_size_y, true)
    core:add_listener(
        btn_listener_name,
        "ComponentLClickUp",
        function(context)
            return bt == UIComponent(context.component) and context:can_request_model_callback()
        end,
        function(context)
            closeStorePanel()
            closeIllustrationPanel()
        end,
        false
    )
    gst.lib_recordObj(bt, btn_listener_name,  store_panel_btn_table);
    return bt
end

function create_item_by_category(category_key, faction)
    if category_key == "accessories" then
        local random = math.floor(gst.lib_getRandomValue(0, 1000))
        if random < 500 then
            create_item(faction, "random_item3_accessory")
        else
            create_item(faction, "random_item3_follower")
        end
    end
    if category_key == "weapons" then
        create_item(faction, "random_item3_weapon")
    end
    if category_key == "mounts" then
        create_item(faction, "random_item3_mount")
    end
    if category_key == "armors" then
        create_item(faction, "random_item3_armour")
    end
    if category_key == "accessories_1" then
        local random = math.floor(gst.lib_getRandomValue(0, 1000))
        local random2 = math.floor(gst.lib_getRandomValue(0, 1000))
        if random < 500 then
            if random2 <= 450 then
                create_item(faction, "random_item1_accessory")
            elseif random2 > 450 and random <= 900 then
                create_item(faction, "random_item2_accessory")
            elseif random2 > 900 then
                create_item(faction, "random_item3_accessory")
            end
        else
            if random2 <= 450 then
                create_item(faction, "random_item1_follower")
            elseif random2 > 450 and random <= 900 then
                create_item(faction, "random_item2_follower")
            elseif random2 > 900 then
                create_item(faction, "random_item3_follower")
            end
        end
    end
    if category_key == "weapons_1" then
        local random = math.floor(gst.lib_getRandomValue(0, 1000))
        if random <= 450 then
            create_item(faction, "random_item1_weapon")
        elseif random > 450 and random <= 900 then
            create_item(faction, "random_item2_weapon")
        elseif random > 900 then
            create_item(faction, "random_item3_weapon")
        end
    end
    if category_key == "mounts_1" then
        local random = math.floor(gst.lib_getRandomValue(0, 1000))
        if random <= 450 then
            create_item(faction, "random_item1_horse")
        elseif random > 450 and random <= 900 then
            create_item(faction, "random_item2_horse")
        elseif random > 900 then
            create_item(faction, "random_item3_horse")
        end
    end
    if category_key == "armors_1" then
        local random = math.floor(gst.lib_getRandomValue(0, 1000))
        if random <= 450 then
            create_item(faction, "random_item1_armour")
        elseif random > 450 and random <= 900 then
            create_item(faction, "random_item2_armour")
        elseif random > 900 then
            create_item(faction, "random_item3_armour")
        end
    end
end

function create_item(faction, item_stack)
    local items
    local can_create_ceo_tables = {}
    local player_faction_modify_object = cm:modify_faction(faction)
    if item_stack == "random_item1_weapon" then
        items = random_item1_weapon 
    elseif item_stack == "random_item1_armour" then
        items = random_item1_armour 
    elseif item_stack == "random_item1_mount" then
        items = random_item1_horse
    elseif item_stack == "random_item1_follower" then
        items = random_item1_follower 
    elseif item_stack == "random_item1_accessory" then
        items = random_item1_accessory 
    elseif item_stack == "random_item2_weapon" then
        items = random_item2_weapon 
    elseif item_stack == "random_item2_armour" then
        items = random_item2_armour 
    elseif item_stack == "random_item2_mount" then
        items = random_item2_horse
    elseif item_stack == "random_item2_follower" then
        items = random_item2_follower 
    elseif item_stack == "random_item2_accessory" then
        items = random_item2_accessory 
    elseif item_stack == "random_item3_weapon" then
        items = random_item3_weapon 
    elseif item_stack == "random_item3_armour" then
        items = random_item3_armour
    elseif item_stack == "random_item3_mount" then
        items = random_item3_horse 
    elseif item_stack == "random_item3_follower" then
        items = random_item3_follower 
    elseif item_stack == "random_item3_accessory" then
        items = random_item3_accessory 
    end
    
    local quality_color = "gold";
    if items == random_item1_weapon 
    or items == random_item1_armour 
    or items == random_item1_mount 
    or items == random_item1_follower 
    or items == random_item1_accessory then
        quality_color = "copper";
    end
    if items == random_item2_weapon 
    or items == random_item2_armour 
    or items == random_item2_mount 
    or items == random_item2_follower 
    or items == random_item2_accessory then
        quality_color = "silver";
    end
    for i = 1, #items do
        local split_arr = string.split(items[i], ",")
        if(player_faction_modify_object:ceo_management():query_faction_ceo_management():can_create_ceo(split_arr[2])) then
            gst.lib_table_insert(can_create_ceo_tables, split_arr);
        end
    end
    
    --随机一个道具
    local randomint = gst.lib_getRandomValue(1,#can_create_ceo_tables)
    local item = can_create_ceo_tables[randomint]
    local ceo = item[2];
    local name;
    
    if locale == "cn" then
        name = items_names[ceo].cn;
    elseif locale == "en" then
        name = items_names[ceo].en;
    elseif locale == "zh" then
        name = items_names[ceo].zh;
    elseif locale == "kr" then
        name = items_names[ceo].kr;
    end
    
    local message = effect.get_localised_string("mod_xyy_store_main_message_craft");
    message = string.gsub(message,"%%1", quality_color);
    message = string.gsub(message,"%%2", name);
    
    if faction:name() == cm:query_local_faction(true):name() then
        effect.advice(message)
    end
    player_faction_modify_object:ceo_management():add_ceo(item[2])
end

local function format_number(n)
    if locale == "cn" then
        if n >= 100000 then
            local formatted_number = math.floor((n / 10000) + 0.5)
            return tostring(formatted_number) .. "万"
        elseif n >= 10000 then
            local formatted_number = string.format("%.1f", (n / 10000))
            return formatted_number .. "万"
        else
            return tostring(n)
        end
    elseif locale == "zh" then
        if n >= 100000 then
            local formatted_number = math.floor((n / 10000) + 0.5)
            return tostring(formatted_number) .. "萬"
        elseif n >= 10000 then
            local formatted_number = string.format("%.1f", (n / 10000))
            return formatted_number .. "萬"
        else
            return tostring(n)
        end
    elseif locale == "en" then
        if n >= 1000000 then
            return (n < 10000000) and string.format("%.1fM", n / 1000000) or string.format("%dM", math.floor(n / 1000000 + 0.5))
        elseif n >= 1000 then
            return (n < 10000) and string.format("%.1fK", n / 1000) or string.format("%dK", math.floor(n / 1000 + 0.5))
        else
            return tostring(n)
        end
    end
end

--创建ui：购买按钮
local function create_gacha_button_1(parent, text, x, y)
    local bt_name = UI_MOD_NAME .. "_gacha_button_1";
    local gacha_button_1 = core:get_or_create_component(bt_name, "ui/templates/button_mp/gacha_button_1")
    parent:Adopt(gacha_button_1:Address())
    gacha_button_1:PropagatePriority(parent:Priority())
    gacha_button_1:SetState( "inactive" )
    find_uicomponent(gacha_button_1, "button_txt"):SetStateText(text)
    gacha_button_1:SetState( "down" )
    find_uicomponent(gacha_button_1, "button_txt"):SetStateText(text)
    gacha_button_1:SetState( "active" )
    find_uicomponent(gacha_button_1, "button_txt"):SetStateText(text)
    gst.UI_Component_resize(gacha_button_1, x, y, true)
    return gacha_button_1
end

local function create_gacha_button_10(parent, text, x, y)
    local bt_name = UI_MOD_NAME .. "_gacha_button_1";
    local gacha_button_10 = core:get_or_create_component(bt_name, "ui/templates/button_mp/gacha_button_10")
    parent:Adopt(gacha_button_10:Address())
    gacha_button_10:PropagatePriority(parent:Priority())
    gacha_button_10:SetState( "inactive" )
    find_uicomponent(gacha_button_10, "button_txt"):SetStateText(text)
    gacha_button_10:SetState( "down" )
    find_uicomponent(gacha_button_10, "button_txt"):SetStateText(text)
    gacha_button_10:SetState( "active" )
    find_uicomponent(gacha_button_10, "button_txt"):SetStateText(text)
    gst.UI_Component_resize(gacha_button_10, x, y, true)
    return gacha_button_10
end

local function create_table_button(parent, text, x, y, index)
    local bt_name = UI_MOD_NAME .. "_table_button";
    local btn_listener_name = bt_name .. "_listener";
    local bt = core:get_or_create_component(bt_name, "ui/templates/square_large_wish_button")
    parent:Adopt(bt:Address())
    bt:PropagatePriority(parent:Priority())
    bt:SetState( "inactive" )
    find_uicomponent(bt, "button_txt"):SetStateText(text)
    bt:SetState( "down" )
    find_uicomponent(bt, "button_txt"):SetStateText(text)
    bt:SetState( "active" )
    find_uicomponent(bt, "button_txt"):SetStateText(text)
    bt:SetImagePath("ui/skins/default/table_" .. index .. ".png");
    gst.UI_Component_resize(bt, x, y, true)
    core:add_listener(
        btn_listener_name,
        "ComponentLClickUp",
        function(context)
            return bt == UIComponent(context.component)
        end,
        function(context)
            if store_panel and index == 2 and pannel_index == 1 then
                if store_panel then
                    store_panel:SetVisible(false) 
                end
                
                if char_sel_pannel then
                    char_sel_pannel:SetVisible(false) 
                end
                
                --销毁商店面板中的所有按钮，并移除监听
                for i = 1, #store_panel_btn_table do
                    core:remove_listener(gst.lib_getRecordObjLisName(store_panel_btn_table[i]))
                    gst.UI_Component_destroy(gst.lib_getRecordObj(store_panel_btn_table[i]))
                end
                store_panel_btn_table = {}
                
                --销毁商店面板
                gst.UI_Component_destroy(store_panel)
                gst.UI_Component_destroy(char_sel_pannel)
                store_panel = nil
                char_sel_pannel = nil
                money_text = nil
                ticket_text = nil
                notification = nil
                static_id = static_id + 1;
                UI_MOD_NAME = "playerStore_byHy"..static_id
                pannel_index = 2
                openStorePanel2()
            end
            if store_panel_2 and index == 1 and pannel_index == 3 then
                if(store_panel_2 ~= nil) then
                    store_panel_2:SetVisible(false) 
                end
                
                --销毁商店面板中的所有按钮，并移除监听
                for i = 1, #store_panel_btn_table do
                    core:remove_listener(gst.lib_getRecordObjLisName(store_panel_btn_table[i]))
                    gst.UI_Component_destroy(gst.lib_getRecordObj(store_panel_btn_table[i]))
                end
                store_panel_btn_table = {}
                
                --销毁商店面板
                gst.UI_Component_destroy(store_panel_2)
                store_panel_2 = nil
                static_id = static_id + 1;
                UI_MOD_NAME = "playerStore_byHy"..static_id
                pannel_index = 0
                openStorePanel()
            end
        end,
        true
    )
    gst.lib_recordObj(bt, btn_listener_name, store_panel_btn_table);
    return bt
end

-- 计算正方形左上角坐标的函数
function calculate_position(n, index)
    -- 参数检查
    if index < 1 or index > n then
        return nil, "Invalid index"
    end

    -- 计算行数
    local rows = math.ceil(n / 5)
    -- 计算起始 y 坐标
    local start_y = math.floor((1080 - (rows * 160 + (rows - 1) * 20)) / 2)
    
    -- 计算当前行数和列数
    local row = math.floor((index - 1) / 5)
    local col = (index - 1) % 5
    
    -- 计算当前行的列数
    local columns = (row == rows - 1) and (n % 5 == 0 and 5 or n % 5) or 5
    local start_x
    -- 计算第一行起始 x 坐标
    if n > 5 then
        start_x = math.floor((1920 - (5 * 160 + 4 * 20)) / 2)
    else
        start_x = math.floor((1920 - (columns * 160 + (columns - 1) * 20)) / 2)
    end

    -- 计算正方形左上角的 x 和 y 坐标
    local x = start_x + col * (160 + 20)
    local y = start_y + row * (160 + 20)

    return x, y
end

-- 计算矩形左上角坐标的函数
function calculate_position_2(index)
    local rectangles_per_row = 4
    local interval = 20
    local rect_width = 120
    local rect_height = 180

    -- 计算起始 x 和 y 坐标
    local start_x = 830
    local start_y = 260

    -- 计算当前行数和列数
    local row = math.floor((index - 1) / rectangles_per_row)
    local col = (index - 1) % rectangles_per_row

    -- 计算矩形左上角的 x 和 y 坐标
    local x = start_x + col * (rect_width + interval)
    local y = start_y + row * (rect_height + interval)

    return x, y
end

local function create_char_button(parent)
    local bt_name = UI_MOD_NAME .. "_char_button"
    local btn_listener_name = bt_name .. "_click_up"
    local bt = core:get_or_create_component(bt_name, "ui/templates/xyy_char_button")
    parent:Adopt(bt:Address())
    bt:PropagatePriority(parent:Priority())
    gst.UI_Component_resize(bt, 60, 60, true)
    bt:SetImagePath("ui/skins/default/icon_hud_court.png");
    bt:SetTooltipText(effect.get_localised_string("mod_xyy_store_main_message_select_character"), true)
    core:add_listener(
        btn_listener_name,
        "ComponentLClickUp",
        function(context)
            return bt == UIComponent(context.component)
        end,
        function(context)
            local ui_root = core:get_ui_root()
            char_sel_pannel = core:get_or_create_component(bt_name, "ui/templates/xyy_char_sel_panel")
            ui_root:Adopt( char_sel_pannel:Address() )
            char_sel_pannel:PropagatePriority( ui_root:Priority() )
            if notification then
                notification:SetVisible(false) 
            end
            local characters
            if cm:is_multiplayer() then
                if cm:query_local_faction(true):name() == cm:get_saved_value("xyy_1p") then
                    characters = selected_1p
                elseif cm:query_local_faction(true):name() == cm:get_saved_value("xyy_2p") then
                    characters = selected_2p
                end
            else
                characters = {}
                for k,v in ipairs(xyy_character_up_pool) do
                    gst.lib_table_insert(characters, v)
                end
                for k,v in ipairs(xyy_character_lottery_pool) do
                    gst.lib_table_insert(characters, v)
                end
            end
            for i = 1, #characters do
                local slot_label = effect.get_localised_string("mod_xyy_character_browser_" .. characters[i])
                local x, y = calculate_position(#characters, i)
                if cm:is_multiplayer() then
                    if cm:query_local_faction(true):name() == cm:get_saved_value("xyy_1p") then
                        local button = add_character_button_1p(char_sel_pannel, 160, "ui/skins/default/character_browser/" .. characters[i] .. ".png", slot_label, characters[i])
                        gst.UI_Component_move_relative(button, char_sel_pannel, x, y, false)
                    elseif cm:query_local_faction(true):name() == cm:get_saved_value("xyy_2p") then
                        local button = add_character_button_2p(char_sel_pannel, 160, "ui/skins/default/character_browser/" .. characters[i] .. ".png", slot_label, characters[i])
                        gst.UI_Component_move_relative(button, char_sel_pannel, x, y, false)
                    end
                else
                    local button = add_character_button_char_sel(char_sel_pannel, 160, "ui/skins/default/character_browser/" .. characters[i] .. ".png", slot_label, characters[i])
                    gst.UI_Component_move_relative(button, char_sel_pannel, x, y, false)
                end
            end
        end,
        true
    )
    gst.lib_recordObj(bt, btn_listener_name, store_panel_btn_table);
    return bt;
end

local function refresh_menu_button_notification()
    if not menu_button_notification then
        return;
    end
    
    if cm:get_saved_value("roguelike_mode") then
        cm:modify_local_faction():remove_effect_bundle("not_set_character");
        menu_button_notification:SetVisible(false);
        return;
    end
    
    if cm:is_multiplayer() then
        if not currect_character_1p then
            cm:modify_faction(cm:get_saved_value("xyy_1p")):apply_effect_bundle("not_set_character", -1);
            ModLog("debug 1p not_set_character")
        else
            cm:modify_faction(cm:get_saved_value("xyy_1p")):remove_effect_bundle("not_set_character");
            ModLog("debug 1p has_set_character")
        end
        if not currect_character_2p then
            cm:modify_faction(cm:get_saved_value("xyy_2p")):apply_effect_bundle("not_set_character", -1);
            ModLog("debug 2p not_set_character")
        else
            cm:modify_faction(cm:get_saved_value("xyy_2p")):remove_effect_bundle("not_set_character");
            ModLog("debug 2p has_set_character")
        end
        
        if cm:query_local_faction(true):name() == cm:get_saved_value("xyy_1p") and not currect_character_1p then
            menu_button_notification:SetVisible(true)
        else
            menu_button_notification:SetVisible(false)
        end
        if cm:query_local_faction(true):name() == cm:get_saved_value("xyy_2p") and not currect_character_2p then
            menu_button_notification:SetVisible(true)
        else
            menu_button_notification:SetVisible(false)
        end
    else
        if not currect_character_1p then
            menu_button_notification:SetVisible(true)
            cm:modify_local_faction():apply_effect_bundle("not_set_character", -1);
            ModLog("debug not_set_character")
        else
            menu_button_notification:SetVisible(false)
            cm:modify_local_faction():remove_effect_bundle("not_set_character");
            ModLog("debug has_set_character")
        end
    end
    
    if cm:is_multiplayer() then
        if cm:query_faction(cm:get_saved_value("xyy_1p")):has_effect_bundle("3k_xyy_character_sold_out_dummy") then
            if query_local_faction(true):name() == cm:get_saved_value("xyy_1p") then
                menu_button_notification:SetVisible(false)
            end
            cm:modify_faction(cm:get_saved_value("xyy_1p")):remove_effect_bundle("not_set_character");
        end
        if cm:query_faction(cm:get_saved_value("xyy_2p")):has_effect_bundle("3k_xyy_character_sold_out_dummy") then
            if query_local_faction(true):name() == cm:get_saved_value("xyy_2p") then
                menu_button_notification:SetVisible(false)
            end
            cm:modify_faction(cm:get_saved_value("xyy_2p")):remove_effect_bundle("not_set_character");
        end
    else
        if cm:query_local_faction():has_effect_bundle("3k_xyy_character_sold_out_dummy") then
            menu_button_notification:SetVisible(false)
            cm:modify_local_faction():remove_effect_bundle("not_set_character");
        end
    end
    
    if not cm:get_saved_value("xyy_store_ready") or not cm:get_saved_value("enabled_character_pool") or cm:get_saved_value("character_store_disable") then
        menu_button_notification:SetVisible(false)
        if cm:is_multiplayer() then
            cm:modify_faction(cm:get_saved_value("xyy_1p")):remove_effect_bundle("not_set_character");
            cm:modify_faction(cm:get_saved_value("xyy_2p")):remove_effect_bundle("not_set_character");
        else
            cm:modify_local_faction():remove_effect_bundle("not_set_character");
        end
    end
end

local function create_notification_counter(parent, direction)
    local bt_name = UI_MOD_NAME .. "_notification_counter"
    notification = core:get_or_create_component(bt_name, "ui/templates/notification_counter_warning")
    parent:Adopt(notification:Address())
    notification:PropagatePriority(parent:Priority())
    find_uicomponent(notification, "circle_anim"):SetState( "warning" )
    find_uicomponent(notification, "notification"):SetState( "warning" )
    if direction and is_string(direction) then
        find_uicomponent(notification, "direction"):SetState( direction )
    end
    notification:SetTooltipText( effect.get_localised_string("mod_xyy_store_main_message_select_character_warning"), true)
    notification:SetVisible(true) 
    return notification;
end

local function refresh_text(faction)
    if faction == cm:query_local_faction(true) then
        if money_text then
            local money = "[[img:icon_coin]][[/img]] " .. format_number(faction:treasury())
            find_uicomponent(money_text, "text"):SetStateText(money)
        end
        if ticket_text then
            local ticket = "[[img:pooled_resource_credibility]][[/img]] " .. gst.faction_get_tickets(faction:name())
            find_uicomponent(ticket_text, "text"):SetStateText(ticket)
        end
    end
end

local function create_text_box(parent, text, x, y)
    if text == "money" then
        money_text = core:get_or_create_component(text, "ui/templates/3k_xyy_text_box")
        parent:Adopt(money_text:Address())
        money_text:PropagatePriority(parent:Priority())
        gst.UI_Component_resize(money_text, x, y, true)
        local money = "[[img:icon_coin]][[/img]] " .. format_number(cm:query_local_faction(true):treasury())
        find_uicomponent(money_text, "text"):SetStateText(money)
        return money_text
    elseif text == "ticket" then
        ticket_text = core:get_or_create_component(text, "ui/templates/3k_xyy_text_box")
        parent:Adopt(ticket_text:Address())
        ticket_text:PropagatePriority(parent:Priority())
        gst.UI_Component_resize(ticket_text, x, y, true)
        local ticket = "[[img:pooled_resource_credibility]][[/img]] " .. gst.faction_get_tickets(cm:query_local_faction(true):name());
        find_uicomponent(ticket_text, "text"):SetStateText(ticket)
        return ticket_text
    end
end

--如果商店panel存在，则直接切换（打开或者关闭）界面
function openStorePanel()
    if not cm:get_saved_value("xyy_store_ready") then 
        effect.advice(effect.get_localised_string("mod_xyy_store_unavailable"));
        return;
    end
    ModLog("pannel_index: " .. pannel_index)
    --如果商店panel状态是开启
    if pannel_index == 1 then
        if cm:get_saved_value("roguelike_mode") then
            close_roguelike_store_pannel()
            menu_button:SetState("active")
            pannel_index = 0
            return;
        end
        closeStorePanel()
        pannel_index = 0
        return;
    end
    --如果商店panel状态是3开启
    if pannel_index == 3 then
        closeStorePanel()
        pannel_index = 2
        return;
    end
    if pannel_index == 2 then
        openStorePanel2()
        pannel_index = 3
        return;
    end
    if pannel2_index == 1 then
        if (characters_illustrations_menu ~= nil) then
            characters_illustrations_menu:SetVisible(false) 
        end
        store_panel_btn_table = {}
        gst.UI_Component_destroy(characters_illustrations_menu)
        characters_illustrations_menu = nil
        
        if (character_illustration_detail ~= nil) then
            character_illustration_detail:SetVisible(false) 
        end
        store_panel_btn_table = {}
        gst.UI_Component_destroy(character_illustration_detail)
        character_illustration_detail = nil
        pannel2_index = 0
    end
    if cm:get_saved_value("roguelike_mode") then
        openRoguelikeStorePanel()
        menu_button:SetState("selected")
        pannel_index = 1
        return;
    end
    if cm:query_model():world():whose_turn_is_it():name() ~= cm:query_local_faction(true):name() then
        return;
    end
    if cm:query_local_faction(true):has_effect_bundle("3k_xyy_character_sold_out_dummy") or cm:get_saved_value("character_store_disable") then
        effect.advice(effect.get_localised_string("mod_xyy_store_main_message_welcome"))
        openStorePanel2()
        return;
    end
    effect.advice(effect.get_localised_string("mod_xyy_store_main_message_welcome"))
    local ui_root = core:get_ui_root()
    local ui_panel_name = UI_MOD_NAME .. "_store_panel";
    if store_panel then 
        ModLog("clear store_panel")
        store_panel = nil
    end
    ModLog("open panel ".. ui_panel_name)
    store_panel = core:get_or_create_component( ui_panel_name, "ui/templates/xyy_store")
    ui_root:Adopt( store_panel:Address() )
    store_panel:PropagatePriority( ui_root:Priority() )
    local x,y,w,h = gst.UI_Component_coordinates(ui_root)
    ModLog(w..","..h)
    gst.UI_Component_resize( store_panel, panel_size_x, panel_size_y, true )
    gst.UI_Component_move_relative( store_panel, ui_root, (w-panel_size_x)/2, (h-panel_size_y)/2, false )
    local bt_close = create_bt_close(store_panel)
    gst.UI_Component_move_relative(bt_close, store_panel, panel_size_x - bt_close_size_x - 350, 100, false)
    
    ModLog("opened ".. ui_panel_name)
    local banner = find_uicomponent(store_panel, "banner")
    if cm:is_multiplayer() then
        if cm:query_local_faction(true):name() == cm:get_saved_value("xyy_1p") then
            if currect_character_1p then
                banner:SetImagePath("ui/skins/default/banner/" .. currect_character_1p .. ".png");
            else
                banner:SetImagePath("ui/skins/default/banner/" .. selected_1p[1] .. ".png");
            end
        end
        if cm:query_local_faction(true):name() == cm:get_saved_value("xyy_2p") then
            if currect_character_2p then
                banner:SetImagePath("ui/skins/default/banner/" .. currect_character_2p .. ".png");
            else
                banner:SetImagePath("ui/skins/default/banner/" .. selected_2p[1] .. ".png");
            end
        end
    else
        if currect_character_1p then
            banner:SetImagePath("ui/skins/default/banner/" .. currect_character_1p .. ".png");
        else
            if #xyy_character_up_pool > 0 then
                banner:SetImagePath("ui/skins/default/banner/" .. xyy_character_up_pool[1] .. ".png");
            elseif #xyy_character_lottery_pool > 0 then
                banner:SetImagePath("ui/skins/default/banner/" .. xyy_character_lottery_pool[1] .. ".png");
            end
        end
    end
    
    local text_box_1 = create_text_box(store_panel, "money", 140, 50)
    text_box_1:SetImagePath("ui/skins/default/text_background.png")
    gst.UI_Component_move_relative(text_box_1, store_panel, 1220, 150, false)
    
    local text_box_2 = create_text_box(store_panel, "ticket", 140, 50)
    text_box_2:SetImagePath("ui/skins/default/text_background.png")
    gst.UI_Component_move_relative(text_box_2, store_panel, 1370, 150, false)
    
    local gacha_button_1 = create_gacha_button_1(store_panel, effect.get_localised_string("mod_xyy_character_browser_gacha_1"), 300, 50)
    gst.UI_Component_move_relative(gacha_button_1, store_panel, 890, 720, false)
    
    local gacha_button_10 = create_gacha_button_10(store_panel, effect.get_localised_string("mod_xyy_character_browser_gacha_10"), 300, 50)
    gst.UI_Component_move_relative(gacha_button_10, store_panel, 1210, 720, false)
    
    local char_button = create_char_button(store_panel)
    gst.UI_Component_move_relative(char_button, store_panel, 1420, 630, false)
    
    if cm:get_saved_value("currect_character_1p") then
        currect_character_1p = cm:get_saved_value("currect_character_1p") 
    end
    
    if cm:get_saved_value("currect_character_2p") then
        currect_character_2p = cm:get_saved_value("currect_character_2p") 
    end
    if cm:is_multiplayer() then
        if cm:query_local_faction(true):name() == cm:get_saved_value("xyy_1p") and not currect_character_1p then
            local notification_counter = create_notification_counter(store_panel)
            gst.UI_Component_move_relative(notification_counter, store_panel, 1460, 625, false)
        end
        if cm:query_local_faction(true):name() == cm:get_saved_value("xyy_2p") and not currect_character_2p then
            local notification_counter = create_notification_counter(store_panel)
            gst.UI_Component_move_relative(notification_counter, store_panel, 1460, 625, false)
        end
    elseif not currect_character_1p then
        local notification_counter = create_notification_counter(store_panel)
        gst.UI_Component_move_relative(notification_counter, store_panel, 1460, 625, false)
    end
    
    local tab_1 = create_table_button(store_panel, effect.get_localised_string("mod_xyy_store_table_1"), 290, 80, 1)
    gst.UI_Component_move_relative(tab_1, store_panel, 345, 200, false)
    
    local tab_2 = create_table_button(store_panel, effect.get_localised_string("mod_xyy_store_table_2"), 290, 80, 2)
    gst.UI_Component_move_relative(tab_2, store_panel, 345, 300, false)
    
    ModLog(ui_panel_name)
    pannel_index = 1
    
    if cm:is_player_turn() then
        menu_button:SetState("selected")
    end
--     cm:steal_escape_key_with_callback("xyy_store_panel", function()
--         closeStorePanel()
--     end)
    CampaignUI.CreateModelCallbackRequest("xyy_callback_xyy_store_panel_open");
end

function openStorePanel2()
    if not cm:get_saved_value("xyy_store_ready") then 
        return;
    end
    local ui_root = core:get_ui_root()
    local ui_panel_name = UI_MOD_NAME .. "_store_panel";
    store_panel_2 = core:get_or_create_component( ui_panel_name, "ui/templates/xyy_store_2")
    ui_root:Adopt( store_panel_2:Address() )
    store_panel_2:PropagatePriority( ui_root:Priority() )
    local x,y,w,h = gst.UI_Component_coordinates(ui_root)
    gst.UI_Component_resize( store_panel_2, panel_size_x, panel_size_y, true )
    gst.UI_Component_move_relative( store_panel_2, ui_root, (w-panel_size_x)/2, (h-panel_size_y)/2, false )
    local bt_close = create_bt_close(store_panel_2)
    gst.UI_Component_move_relative(bt_close, store_panel_2, panel_size_x - bt_close_size_x - 350, 100, false)
    store_panel_2:SetVisible(true)
    
    local text_box_1 = create_text_box(store_panel_2, "money", 140, 50)
    text_box_1:SetImagePath("ui/skins/default/text_background.png")
    gst.UI_Component_move_relative(text_box_1, store_panel_2, 1220, 150, false)
    
    local text_box_2 = create_text_box(store_panel_2, "ticket", 140, 50)
    text_box_2:SetImagePath("ui/skins/default/text_background.png")
    gst.UI_Component_move_relative(text_box_2, store_panel_2, 1370, 150, false)
    
    local tab_1 = create_table_button(store_panel_2, effect.get_localised_string("mod_xyy_store_table_1"), 290, 80, 1)
    gst.UI_Component_move_relative(tab_1, store_panel_2, 345, 200, false)
    if cm:query_local_faction(true):has_effect_bundle("3k_xyy_character_sold_out_dummy") or cm:get_saved_value("character_store_disable") then
        tab_1:SetState("inactive")
        find_uicomponent(tab_1, "button_txt"):SetStateText(effect.get_localised_string("mod_xyy_store_table_1_inactive"))
    else
        if cm:is_multiplayer() then
            if cm:query_local_faction(true):name() == cm:get_saved_value("xyy_1p") and not currect_character_1p then
                local notification_counter = create_notification_counter(store_panel_2, "bottom_left")
                gst.UI_Component_move_relative(notification_counter, store_panel_2, 650, 170, false)
            end
            if cm:query_local_faction(true):name() == cm:get_saved_value("xyy_2p") and not currect_character_2p then
                local notification_counter = create_notification_counter(store_panel_2, "bottom_left")
                gst.UI_Component_move_relative(notification_counter, store_panel_2, 650, 170, false)
            end
        elseif not currect_character_1p then
            local notification_counter = create_notification_counter(store_panel_2, "bottom_left")
            gst.UI_Component_move_relative(notification_counter, store_panel_2, 650, 170, false)
        end
    end
    
    local tab_2 = create_table_button(store_panel_2,effect.get_localised_string("mod_xyy_store_table_2"), 290, 80, 2)
    gst.UI_Component_move_relative(tab_2, store_panel_2, 345, 300, false)
    
    for i,v in ipairs(xyy_store_items) do
        local item = v
        local bt_name = UI_MOD_NAME .. "_purchase_button_"..i;
        local btn_listener_name = bt_name
        local bt = core:get_or_create_component(bt_name, "ui/templates/button_mp/" .. item)
        store_panel_2:Adopt(bt:Address())
        bt:PropagatePriority(store_panel_2:Priority())
        gst.UI_Component_resize(bt, 120, 180, true)
        gst.lib_recordObj(bt, btn_listener_name, store_panel_btn_table);
        bt:SetTooltipText(
        effect.get_localised_string("mod_xyy_roguelike_info") .. effect.get_localised_string("mod_info_" .. item), true)
        
        local text = effect.get_localised_string("effect_bundles_localised_description_" .. item);
        local button_txt = "[[col:" ..
        store_items[item]["quality"] ..
        "]]" .. effect.get_localised_string("effect_bundles_localised_title_" .. item) .. "[[/col]]";
        local price = "[[img:icon_coin]][[/img]]" .. store_items[item]["price"];

        bt:SetState("hover")
        find_uicomponent(bt, "button_txt"):SetStateText(button_txt)
        find_uicomponent(bt, "main_text_1"):SetStateText(text)
        find_uicomponent(bt, "price_text"):SetStateText(price)
        bt:SetState("down")
        find_uicomponent(bt, "button_txt"):SetStateText(button_txt)
        find_uicomponent(bt, "main_text_1"):SetStateText(text)
        find_uicomponent(bt, "price_text"):SetStateText(price)
        bt:SetState("down_off")
        find_uicomponent(bt, "button_txt"):SetStateText(button_txt)
        find_uicomponent(bt, "main_text_1"):SetStateText(text)
        find_uicomponent(bt, "price_text"):SetStateText(price)
        bt:SetState("inactive")
        find_uicomponent(bt, "button_txt"):SetStateText(button_txt)
        find_uicomponent(bt, "main_text_1"):SetStateText(text)
        find_uicomponent(bt, "price_text"):SetStateText(price)
        bt:SetState("active")
        find_uicomponent(bt, "button_txt"):SetStateText(button_txt)
        find_uicomponent(bt, "main_text_1"):SetStateText(text)
        find_uicomponent(bt, "price_text"):SetStateText(price)
        local x, y = calculate_position_2(i)
        if cm:query_local_faction(true):has_effect_bundle(item)
        then
            bt:SetState("selected_inactive")
        end
        store_items[item]["button"] = bt
        gst.UI_Component_move_relative(bt, store_panel_2, x, y, false)
    end
    
    if cm:is_player_turn() then
        menu_button:SetState("selected")
    end
    pannel_index = 3
--     cm:steal_escape_key_with_callback("xyy_store_panel", function()
--         closeStorePanel()
--     end)
    CampaignUI.CreateModelCallbackRequest("xyy_callback_xyy_store_panel_open");
end

function closeStorePanel()
    --ModLog( "playerstore_byhy============closeStorePanel=================" )
    --隐藏商店面板
    if store_panel then
        store_panel:SetVisible(false) 
    end
    
    if char_sel_pannel then
        char_sel_pannel:SetVisible(false) 
    end
    
    if store_panel_2 then
        store_panel_2:SetVisible(false) 
    end
    
    --销毁商店面板中的所有按钮，并移除监听
    for i = 1, #store_panel_btn_table do
        core:remove_listener(gst.lib_getRecordObjLisName(store_panel_btn_table[i]))
        gst.UI_Component_destroy(gst.lib_getRecordObj(store_panel_btn_table[i]))
    end
    store_panel_btn_table = {}
    
    --销毁商店面板
    gst.UI_Component_destroy(store_panel)
    gst.UI_Component_destroy(store_panel_2)
    gst.UI_Component_destroy(char_sel_pannel)
    store_panel = nil
    char_sel_pannel = nil
    money_text = nil
    ticket_text = nil
    notification = nil
    static_id = static_id + 1;
    UI_MOD_NAME = "playerStore_byHy"..static_id
    if pannel_index == 3 then
        pannel_index = 2
    elseif pannel_index == 1 then
        pannel_index = 0
    end
    if cm:is_player_turn() then
        menu_button:SetState("active")
    end
    CampaignUI.CreateModelCallbackRequest("xyy_callback_xyy_store_panel_close");
end

function closeIllustrationPanel()
    if character_illustration_detail then
        character_illustration_detail:SetVisible(false) 
        gst.UI_Component_destroy(character_illustration_detail)
        character_illustration_detail = nil;
        for i = 1, #store_panel_btn_table do
            core:remove_listener(gst.lib_getRecordObjLisName(store_panel_btn_table[i]))
            gst.UI_Component_destroy(gst.lib_getRecordObj(store_panel_btn_table[i]))
        end
        static_id = static_id + 1;
    end
    if characters_illustrations_menu then
        characters_illustrations_menu:SetVisible(false) 
        gst.UI_Component_destroy(characters_illustrations_menu)
        characters_illustrations_menu = nil;
        for i = 1, #store_panel_btn_table do
            core:remove_listener(gst.lib_getRecordObjLisName(store_panel_btn_table[i]))
            gst.UI_Component_destroy(gst.lib_getRecordObj(store_panel_btn_table[i]))
        end
        static_id = static_id + 1;
    end
    if characters_illustrations_menu_button and is_uicomponent(characters_illustrations_menu_button) then
        characters_illustrations_menu_button:SetState("active")
    end
    CampaignUI.CreateModelCallbackRequest("xyy_callback_xyy_illustration_panel_close");
end
--创建主界面的商店入口按钮
local function createHomeStoreButton()
    --获取系统的ui根节点
    local root = core:get_ui_root()
	--获取主界面的顶部父节点：派系那一排按钮
	local parent = find_uicomponent( root, "hud_campaign", "top_faction_header", "campaign_hud_faction_header", "button_parent", "button_group_management" )

	if not parent or not is_uicomponent(parent) then
		return --不存在直接返回
	end
    --创建一个入口按钮，使用的是data.pack中自带的3k_btn_medium.twui.xml布局
    local home_store_btn_name = "home_store_btn";
    local home_store_btn_listener_name = home_store_btn_name .. "_click_up"
    menu_button = find_uicomponent( parent, "dlc_buttons", "_3k_xyy_store", "button_store" )
    menu_button_notification = find_uicomponent( parent, "dlc_buttons", "_3k_xyy_store", "notification_counter" )
    menu_button_notification:SetTooltipText(effect.get_localised_string("end_turn_notifications_display_text_NOT_SET_CHARACTER"), true)
    --menu_button:SetState( "hover" )
    --menu_button:SetImagePath( "ui/skins/default/store2022.png" )
    --menu_button:SetState( "active" )
    menu_button:SetTooltipText(effect.get_localised_string("mod_xyy_store_main_message_main_welcome"), true) 
    core:remove_listener(home_store_btn_listener_name)
    --给按钮设置监听
    core:add_listener(
        home_store_btn_listener_name ,
        "ComponentLClickUp",
        function(context)
            return UIComponent(context.component) == menu_button
        end,
        function(context)
            if not cm:is_multiplayer() then
                the_seven_kings_close_pannel();
                closeIllustrationPanel();
                openStorePanel();
            else
                the_seven_kings_close_pannel();
                closeIllustrationPanel();
                openStorePanel();
                --effect.advice(effect.get_localised_string("mod_xyy_store_main_message_is_mp"))
            end
        end,
        true
    )
    gst.lib_recordObj(menu_button, home_store_btn_listener_name, home_btn_table);
end

function add_menu_button()
    --获取系统的ui根节点
    local root = core:get_ui_root()
	--获取主界面的顶部父节点：派系那一排按钮
	local parent = find_uicomponent( root, "hud_campaign", "top_faction_header", "campaign_hud_faction_header", "button_parent", "button_group_management" )

	if not parent or not is_uicomponent(parent) then
		return --不存在直接返回
	end
    local characters_illustrations_menu_id = "characters_illustrations_menu";
    local characters_illustrations_menu_btn_listener_name = characters_illustrations_menu_id .. "_click_up"
    characters_illustrations_menu_button = core:get_or_create_component( characters_illustrations_menu_id, "ui/templates/3k_btn_medium_toggle_panel" ) -- data.pack
    --将该按钮位置放在parent下，那么这个新创建的按钮就在顶部那一排中了
    parent:Adopt(characters_illustrations_menu_button:Address())
    
    --设置按钮的属性
    characters_illustrations_menu_button:SetImagePath( "ui/skins/default/3k_dlc05_ranks_and_titles_medium.png" ) --图片
    --gst.UI_Component_resize(characters_illustrations_menu_button, 50, 50, true)
    characters_illustrations_menu_button:SetOpacity( true, 255 ) --不透明度
        --按钮的悬浮提示，如果将鼠标移到按钮上，即可显示按钮的名字
    characters_illustrations_menu_button:SetTooltipText(effect.get_localised_string("mod_xyy_characters_illustrations_menu"), true) 
    gst.lib_recordObj(characters_illustrations_menu_btn_listener_name, home_store_btn_listener_name, home_btn_table);
end
--创建UI
local function createUI()
    --ModLog( "playerstore_byhy============createUI=================" )
--     if cm:is_multiplayer() then
--         return;
--     end
    createHomeStoreButton() --创建主界面的商店入口按钮
end

--销毁UI
local function destroyUI()
    --销毁主界面的入口按钮,并移除监听
    for i = 1, #home_btn_table do
        local record = gst.lib_getRecordObj(home_btn_table[i])
        if record then
            core:remove_listener( gst.lib_getRecordObjLisName(home_btn_table[i]))
            gst.UI_Component_destroy( gst.lib_getRecordObj(home_btn_table[i]) )
        end
    end
    home_btn_table ={}
end

core:add_ui_destroyed_callback( function( context ) destroyUI() end )

core:add_ui_created_callback( function( context ) createUI() end )

function firefly_unlock()
    if not cm:get_saved_value("xyy_cheat_mode") then
        has_firefly_unlocked = true
        local xyy_playerstore_config = gst.lib_try_load_table("xyy_playerstore_config");
        xyy_playerstore_config["hlyjdj"] = true;
        gst.lib_create_and_save_table("xyy_playerstore_config", xyy_playerstore_config);
    end
end

function miyabi_unlock()
    if not cm:get_saved_value("xyy_cheat_mode") then
        has_miyabi_unlocked = true
        local xyy_playerstore_config = gst.lib_try_load_table("xyy_playerstore_config");
        xyy_playerstore_config["hlyjdv"] = true;
        gst.lib_create_and_save_table("xyy_playerstore_config", xyy_playerstore_config);
    end
end

function tingyun_unlock()
    if not cm:get_saved_value("xyy_cheat_mode") then
        has_tingyun_unlocked = true
        local xyy_playerstore_config = gst.lib_try_load_table("xyy_playerstore_config");
        xyy_playerstore_config["hlyjdw"] = true;
        gst.lib_create_and_save_table("xyy_playerstore_config", xyy_playerstore_config);
    end
end

function cantarella_unlock()
    if not cm:get_saved_value("xyy_cheat_mode") then
        has_cantarella_unlocked = true
        local xyy_playerstore_config = gst.lib_try_load_table("xyy_playerstore_config");
        xyy_playerstore_config["hlyjea"] = true;
        gst.lib_create_and_save_table("xyy_playerstore_config", xyy_playerstore_config);
    end
end

function is_firefly_unlock()
    local filename = "xyy_playerstore_config"
    local xyy_playerstore_config = gst.lib_try_load_table(filename);
    if not xyy_playerstore_config then
        return false
    end
    if xyy_playerstore_config then
        has_firefly_unlocked = xyy_playerstore_config['hlyjdj'];
    else
        has_firefly_unlocked = false;
    end
    return has_firefly_unlocked;
end

function is_miyabi_unlock()
    local filename = "xyy_playerstore_config"
    local xyy_playerstore_config = gst.lib_try_load_table(filename);
    if not xyy_playerstore_config then
        return false
    end
    if xyy_playerstore_config then
        has_miyabi_unlocked = xyy_playerstore_config['hlyjdv'];
    else
        has_miyabi_unlocked = false;
    end
    return has_miyabi_unlocked;
end

function is_tingyun_unlock()
    local filename = "xyy_playerstore_config"
    local xyy_playerstore_config = gst.lib_try_load_table(filename);
    if not xyy_playerstore_config then
        return false
    end
    if xyy_playerstore_config then
        has_tingyun_unlocked = xyy_playerstore_config['hlyjdw'];
    else
        has_tingyun_unlocked = false;
    end
    return has_tingyun_unlocked;
end

function is_cantarella_unlock()
--     local filename = "xyy_playerstore_config"
--     local xyy_playerstore_config = gst.lib_try_load_table(filename);
--     local key = gst.lib_try_load_table("unlock_phoebe");
--     if not xyy_playerstore_config then
--         return false
--     end
--     if xyy_playerstore_config then
--         has_cantarella_unlocked = xyy_playerstore_config['hlyjea'];
--     else
--         has_cantarella_unlocked = false;
--     end
--     if key then
--         if key['key'] == "496A72C3-5DBB-1BC6-0B72-13036CB75D48" then
--             phoebe_unlock()
--         end
--     end

    has_cantarella_unlocked = false
    return has_cantarella_unlocked;
end

local function add_character_button(parent, slot_icon_size, slot_icon, slot_label, character_key)
    --ModLog('创建了按钮'..character_key)
    local bt_name = UI_MOD_NAME .. "_xyy_select_character_panel_" .. static_id .. character_key;
    local btn_listener_name = bt_name .. "_click_up"
    local bt
    if not cm:get_saved_value("roguelike_mode") and character_key == "hlyjdj" and not has_firefly_unlocked then
        bt = core:get_or_create_component(bt_name, "ui/templates/3k_btn_large_invalid")
    elseif not cm:get_saved_value("roguelike_mode") and character_key == "hlyjdv" and not has_miyabi_unlocked then
        bt = core:get_or_create_component(bt_name, "ui/templates/3k_btn_large_invalid")
    --菲比暂时不可用
    elseif not cm:get_saved_value("roguelike_mode") and character_key == "hlyjeb" and not has_cantarella_unlocked then
        bt = core:get_or_create_component(bt_name, "ui/templates/3k_btn_large_invalid")
    else
        bt = core:get_or_create_component(bt_name, "ui/templates/3k_btn_large")
    end
    parent:Adopt(bt:Address())
    bt:PropagatePriority(parent:Priority())
    gst.UI_Component_resize(bt, slot_icon_size, slot_icon_size, true)
    if not cm:get_saved_value("roguelike_mode") and character_key == "hlyjdj" and not has_firefly_unlocked then
        bt:SetImagePath("ui/skins/default/character_browser/hlyjdj_.png");
        slot_label = effect.get_localised_string("mod_xyy_character_browser_locked_hlyjdj") .. slot_label
    elseif not cm:get_saved_value("roguelike_mode") and character_key == "hlyjdv" and not has_miyabi_unlocked then
        bt:SetImagePath("ui/skins/default/character_browser/hlyjdv_.png");
        slot_label = effect.get_localised_string("mod_xyy_character_browser_locked_hlyjdv") .. slot_label
    --菲比暂时不可用
    elseif not cm:get_saved_value("roguelike_mode") and character_key == "hlyjeb" and not has_cantarella_unlocked then
        bt:SetImagePath("ui/skins/default/character_browser/hlyjea_.png");
        slot_label = effect.get_localised_string("mod_xyy_character_browser_locked_hlyjea") .. slot_label
    else
        bt:SetImagePath(slot_icon);
    end
    bt:SetTooltipText(slot_label, true);
    core:add_listener(
        btn_listener_name,
        "ComponentLClickUp",
        function(context)
            return bt == UIComponent(context.component)
        end,
        function(context)
            if not cm:get_saved_value("roguelike_mode") and character_key == "hlyjdj" and not has_firefly_unlocked then
                return;
            end
            if not cm:get_saved_value("roguelike_mode") and character_key == "hlyjdv" and not has_miyabi_unlocked then
                return;
            end
            if not cm:get_saved_value("roguelike_mode") and character_key == "hlyjdw" and not has_tingyun_unlocked then
                return;
            end
            --菲比暂时不可用
            if not cm:get_saved_value("roguelike_mode") and character_key == "hlyjeb" and not has_cantarella_unlocked then
                return;
            end
            if #xyy_character_lottery_pool < 6 then
                if cm:get_saved_value("roguelike_mode_character_pool") then
                    if cm:get_saved_value("roguelike_mode_character_pool") == "roguelike_select" 
                    and #xyy_character_lottery_pool >= get_max_character_selections() then
                        return;
                    elseif cm:get_saved_value("roguelike_mode_character_pool") == "roguelike_first_select" 
                    and #xyy_character_lottery_pool >= 3 then
                        return;
                    end
                end
                --隐藏商店面板
                if(parent ~= nil) then
                parent:SetVisible(false) 
                end
                --销毁商店面板中的所有按钮，并移除监听
                for i = 1, #store_panel_btn_table do
                    core:remove_listener(gst.lib_getRecordObjLisName(store_panel_btn_table[i]))
                    gst.UI_Component_destroy(gst.lib_getRecordObj(store_panel_btn_table[i]))
                end
                store_panel_btn_table = {}
                
                --销毁商店面板
                gst.UI_Component_destroy(parent)
                parent = nil
                
                gst.lib_table_insert(xyy_character_lottery_pool, character_key)
                
                
                if cm:get_saved_value("roguelike_mode_character_pool") then
                    gst.lib_remove_value_from_list(xyy_character_up_pool, character_key)
                else
                    gst.lib_remove_value_from_list(character_browser_list, character_key)
--                     for i, v in ipairs(character_browser_list) do
--                         if v == character_key then
--                             table.remove(character_browser_list, i)
--                             break
--                         end
--                     end
                end
                
                static_id = static_id + 1
                
                if cm:get_saved_value("roguelike_mode_character_pool") then
                    if cm:get_saved_value("roguelike_mode_character_pool") == "roguelike_select" then
                        character_browser_roguelike_select(true)
                    elseif cm:get_saved_value("roguelike_mode_character_pool") == "roguelike_first_select" then
                        character_browser_roguelike_first_select(true)
                    end
                else
                    character_browser()
                end
            end
        end,
        false
    )
    gst.lib_recordObj(bt, btn_listener_name,  store_panel_btn_table);
    return bt;
end

local function add_character_pool(parent, slot_icon_size, slot_icon, slot_label, character_key, lock, can_remove)
    if character_key == 'unkown' then
        --ModLog('创建了按钮未知角色头像')
    else 
        --ModLog('创建了按钮'..character_key)
    end
    local bt_name = UI_MOD_NAME .. "_xyy_select_character_panel_" .. static_id .. character_key;
    local btn_listener_name = bt_name .. "_click_up"
    local bt
    if lock then
        bt = core:get_or_create_component(bt_name, "ui/templates/3k_btn_large_lock")
    else
        bt = core:get_or_create_component(bt_name, "ui/templates/3k_btn_large")
    end
    -- local character = cm:query_model():character_for_template(character_key);
    parent:Adopt(bt:Address())
    bt:PropagatePriority(parent:Priority())
    gst.UI_Component_resize(bt, slot_icon_size, slot_icon_size, true)
    bt:SetImagePath(slot_icon);
    bt:SetTooltipText(slot_label, true)
    gst.lib_recordObj(bt, btn_listener_name,  store_panel_btn_table);
    core:add_listener(
        btn_listener_name,
        "ComponentLClickUp",
        function(context)
            return bt == UIComponent(context.component)
        end,
        function(context)
            if can_remove then
                --隐藏商店面板
                if(parent ~= nil) then
                parent:SetVisible(false) 
                end
                --销毁商店面板中的所有按钮，并移除监听
                for i = 1, #store_panel_btn_table do
                    core:remove_listener(gst.lib_getRecordObjLisName(store_panel_btn_table[i]))
                    gst.UI_Component_destroy(gst.lib_getRecordObj(store_panel_btn_table[i]))
                end
                store_panel_btn_table = {}
                
                --销毁商店面板
                gst.UI_Component_destroy(parent)
                parent = nil
                gst.lib_remove_value_from_list(xyy_character_lottery_pool,character_key)
                
                if cm:get_saved_value("roguelike_mode_character_pool") then
                    gst.lib_table_insert(xyy_character_up_pool, character_key)
                else
                    gst.lib_table_insert(character_browser_list, character_key)
                end
                ModLog('备选池长度'..(#character_browser_list))
                static_id = static_id + 1
                
                if cm:get_saved_value("roguelike_mode_character_pool") then
                    if cm:get_saved_value("roguelike_mode_character_pool") == "roguelike_select" then
                        character_browser_roguelike_select(true)
                    elseif cm:get_saved_value("roguelike_mode_character_pool") == "roguelike_first_select" then
                        character_browser_roguelike_first_select(true)
                    end
                else
                    character_browser()
                end
                
            end
        end,
        false
    )
    return bt;
end

local function add_character_illustration_button(parent, slot_icon_size, slot_icon, slot_label, character_key, is_dead)
    local bt_name = UI_MOD_NAME .. "_xyy_character_illustration_panel_" .. character_key;
    local btn_listener_name = bt_name .. "_click_up"
    local bt;
    if is_dead then
        bt = core:get_or_create_component(bt_name, "ui/templates/3k_btn_large_dead")
    else
        if character_key == "hlyjdj" and not has_firefly_unlocked then
            bt = core:get_or_create_component(bt_name, "ui/templates/3k_btn_large_invalid")
        elseif character_key == "hlyjdv" and not has_miyabi_unlocked then
            bt = core:get_or_create_component(bt_name, "ui/templates/3k_btn_large_invalid")
        elseif character_key == "hlyjdw" and not has_tingyun_unlocked then
            bt = core:get_or_create_component(bt_name, "ui/templates/3k_btn_large_invalid")
        --菲比暂时不可用
        elseif character_key == "hlyjeb" and not has_cantarella_unlocked then
            bt = core:get_or_create_component(bt_name, "ui/templates/3k_btn_large_invalid")
        else
            bt = core:get_or_create_component(bt_name, "ui/templates/3k_btn_large")
        end
    end
    local character = gst.character_query_for_template(character_key);
    local text = ""
    if character
    and not character:is_null_interface()
    and not character:is_dead()
    and not character:is_character_is_faction_recruitment_pool()
    and character:faction()
    and not character:faction():is_null_interface()
    then
        
        local name = gst.faction_get_string_name(character:faction())
        if name ~= "" then
            text = text .. effect.get_localised_string("mod_xyy_character_browser_faction") .. name
        else
            text = text .. effect.get_localised_string("mod_xyy_character_browser_faction_unknown")
        end
    elseif character
    and not character:is_null_interface()
    and character:is_dead() 
    then
        text = text .. effect.get_localised_string("mod_xyy_character_browser_dead")
    else
        text = text .. effect.get_localised_string("mod_xyy_character_browser_faction_unknown")
    end
    parent:Adopt(bt:Address())
    bt:PropagatePriority(parent:Priority())
    gst.UI_Component_resize(bt, slot_icon_size, slot_icon_size, true)
    bt:SetImagePath(slot_icon);
    bt:SetTooltipText(slot_label .. "\n\n" .. text, true)
    if character_key == "hlyjdj" and not has_firefly_unlocked then
        bt:SetImagePath("ui/skins/default/character_browser/hlyjdj_.png");
        bt:SetTooltipText(effect.get_localised_string("mod_xyy_character_browser_locked_hlyjdj") .. slot_label .. "\n\n" .. text, true)
    end
    if character_key == "hlyjdv" and not has_miyabi_unlocked then
        bt:SetImagePath("ui/skins/default/character_browser/hlyjdv_.png");
        bt:SetTooltipText(effect.get_localised_string("mod_xyy_character_browser_locked_hlyjdv") .. slot_label .. "\n\n" .. text, true)
    end
    if character_key == "hlyjdw" and not has_tingyun_unlocked then
        bt:SetImagePath("ui/skins/default/character_browser/hlyjdw_.png");
        bt:SetTooltipText(effect.get_localised_string("mod_xyy_character_browser_locked_hlyjdw") .. slot_label .. "\n\n" .. text, true)
    end
    if character_key == "hlyjea" and not has_cantarella_unlocked then
        bt:SetImagePath("ui/skins/default/character_browser/hlyjea_.png");
        bt:SetTooltipText(effect.get_localised_string("mod_xyy_character_browser_locked_hlyjea") .. slot_label .. "\n\n" .. text, true)
    end
    gst.lib_recordObj(bt, btn_listener_name,  store_panel_btn_table);
    core:add_listener(
        btn_listener_name,
        "ComponentLClickUp",
        function(context)
            return bt == UIComponent(context.component)
        end,
        function(context)
            if parent ~= nil then
            parent:SetVisible(false) 
            end
            --销毁商店面板中的所有按钮，并移除监听
            for i = 1, #store_panel_btn_table do
                core:remove_listener(gst.lib_getRecordObjLisName(store_panel_btn_table[i]))
                gst.UI_Component_destroy(gst.lib_getRecordObj(store_panel_btn_table[i]))
            end
            store_panel_btn_table = {}
            
            --销毁商店面板
            gst.UI_Component_destroy(parent)
            parent = nil
            
            static_id = static_id + 1
            
            open_character_illustration_detail(character_key);
        end,
        false
    )
    return bt;
end

local function add_page_button(parent, x, y, next_or_previous)
    local bt_name 
    if next_or_previous then
        bt_name = UI_MOD_NAME .. "_xyy_select_character_panel_page_next";
    else
        bt_name = UI_MOD_NAME .. "_xyy_select_character_panel_page_previous";
    end
    local btn_listener_name = bt_name .. "_click_up"
    local bt = core:get_or_create_component(bt_name, "ui/templates/square_large_text_button")
    -- local character = cm:query_model():character_for_template(character_key);
    parent:Adopt(bt:Address())
    bt:PropagatePriority(parent:Priority())
    gst.UI_Component_resize(bt, x, y, true)
    if next_or_previous then
        bt:SetTooltipText(effect.get_localised_string("mod_xyy_character_browser_next_page_tooltip"), true)
    else
        bt:SetTooltipText(effect.get_localised_string("mod_xyy_character_browser_previous_page_tooltip"), true)
    end
    core:add_listener(
        btn_listener_name,
        "ComponentLClickUp",
        function(context)
            return bt == UIComponent(context.component)
        end,
        function(context)
            if next_or_previous then
                page = page + 2;
            else
                page = page - 2;
                if page < 0 then
                    page = 0;
                end
            end
            
            --隐藏商店面板
            if parent ~= nil then
            parent:SetVisible(false) 
            end
            --销毁商店面板中的所有按钮，并移除监听
            for i = 1, #store_panel_btn_table do
                core:remove_listener(gst.lib_getRecordObjLisName(store_panel_btn_table[i]))
                gst.UI_Component_destroy(gst.lib_getRecordObj(store_panel_btn_table[i]))
            end
            store_panel_btn_table = {}
            
            --销毁商店面板
            gst.UI_Component_destroy(parent)
            parent = nil
            
            for i, v in ipairs(xyy_character_lottery_pool) do
                if v == character_key then
                    table.remove(xyy_character_lottery_pool, i)
                    ModLog('奖池长度'..(#xyy_character_lottery_pool))
                    break
                end
            end
            
            gst.lib_table_insert(character_browser_list, character_key)
            ModLog('备选池长度'..(#character_browser_list))
            static_id = static_id + 1
            
            if cm:get_saved_value("roguelike_mode_character_pool") then
                if cm:get_saved_value("roguelike_mode_character_pool") == "roguelike_select" then
                    character_browser_roguelike_select(true)
                elseif cm:get_saved_value("roguelike_mode_character_pool") == "roguelike_first_select" then
                    character_browser_roguelike_first_select(true)
                end
            else
                character_browser()
            end
        end,
        false
    )
    gst.lib_recordObj(bt, btn_listener_name,  store_panel_btn_table);
    return bt;
end

local function add_page2_button(parent, x, y, next_or_previous)
    local bt_name 
    if next_or_previous then
        bt_name = UI_MOD_NAME .. "_xyy_select_character_panel_page_next";
    else
        bt_name = UI_MOD_NAME .. "_xyy_select_character_panel_page_previous";
    end
    local btn_listener_name = bt_name .. "_click_up"
    local bt = core:get_or_create_component(bt_name, "ui/templates/square_large_text_button")
    -- local character = cm:query_model():character_for_template(character_key);
    parent:Adopt(bt:Address())
    bt:PropagatePriority(parent:Priority())
    gst.UI_Component_resize(bt, x, y, true)
    if next_or_previous then
        bt:SetTooltipText(effect.get_localised_string("mod_xyy_character_browser_next_page_tooltip"), true)
    else
        bt:SetTooltipText(effect.get_localised_string("mod_xyy_character_browser_previous_page_tooltip"), true)
    end
    core:add_listener(
        btn_listener_name,
        "ComponentLClickUp",
        function(context)
            return bt == UIComponent(context.component)
        end,
        function(context)
            if next_or_previous then
                page2 = page2 + 4;
            else
                page2 = page2 - 4;
                if page2 < 0 then
                    page2 = 0;
                end
            end
            closeIllustrationPanel()
            open_characters_illustrations_menu()
        end,
        false
    )
    gst.lib_recordObj(bt, btn_listener_name,  store_panel_btn_table);
    return bt;
end

local function add_confirm_button(parent, x, y)
    local bt_name = UI_MOD_NAME .. "_xyy_select_character_panel_confirm";
    local btn_listener_name = bt_name .. "_click_up"
    local bt = core:get_or_create_component(bt_name, "ui/templates/button_mp/confirm_button_1p")
    -- local character = cm:query_model():character_for_template(character_key);
    parent:Adopt(bt:Address())
    bt:PropagatePriority(parent:Priority())
    gst.UI_Component_resize(bt, x, y, true)
    bt:SetTooltipText(effect.get_localised_string(effect.get_localised_string("mod_xyy_character_browser_confirm_tooltip")), true)
    core:add_listener(
        btn_listener_name,
        "ComponentLClickUp",
        function(context)
            return bt == UIComponent(context.component)
        end,
        function(context)
            if #xyy_character_lottery_pool == 6 then
                --隐藏商店面板
                if xyy_select_character_panel then
                xyy_select_character_panel:SetVisible(false) 
                end
                --销毁商店面板中的所有按钮，并移除监听
                for i = 1, #store_panel_btn_table do
                    core:remove_listener(gst.lib_getRecordObjLisName(store_panel_btn_table[i]))
                    gst.UI_Component_destroy(gst.lib_getRecordObj(store_panel_btn_table[i]))
                end
                store_panel_btn_table = {}
                
                --销毁商店面板
                gst.UI_Component_destroy(xyy_select_character_panel)
                xyy_select_character_panel = nil
                
                gst.wait_for_model_sp(function()
                    cm:set_saved_value("xyy_character_lottery_pool", xyy_character_lottery_pool)
                    cm:set_saved_value("character_browser_list", character_browser_list)
                    cm:set_saved_value("xyy_character_up_pool", xyy_character_up_pool)
                    cm:set_saved_value("selected_up_character", true)
                    cm:set_saved_value("xyy_store_ready", true)
                    cm:set_saved_value("enabled_character_pool", true)
                    local player_faction_query_object = cm:query_model():world():whose_turn_is_it();
                    if cm:get_saved_value("roguelike_mode") then
                        local clist = {}
                        for i, v in ipairs(xyy_character_up_pool) do
                            gst.lib_table_insert(clist, v)
                        end
                        for i, v in ipairs(xyy_character_lottery_pool) do
                            gst.lib_table_insert(clist, v)
                        end
                        for i, v in ipairs(clist) do
                            add_character_to_player(v, player_faction_query_object)
                        end
                        cm:set_saved_value("xyy_character_lottery_pool", xyy_character_lottery_pool)
                        cm:set_saved_value("xyy_character_up_pool", xyy_character_up_pool)
                        openRoguelikePanel()
                    end
                    add_menu_button()
                    refresh_menu_button_notification()
                    cm:modify_model():get_modify_episodic_scripting():autosave_at_next_opportunity();
                    CampaignUI.CreateModelCallbackRequest("xyy_callback_steal_escape_key_false");

                    if cm:is_player_turn() then
                        menu_button:SetState("active")
                    end
                end)
                static_id = static_id + 1
            end
        end,
        false
    )
    gst.lib_recordObj(bt, btn_listener_name,  store_panel_btn_table);
    return bt;
end

local function add_close_button(parent, x, y)
    local bt_name = UI_MOD_NAME .. "_xyy_select_character_panel_confirm";
    local btn_listener_name = bt_name .. "_click_up"
    local bt = core:get_or_create_component(bt_name, "ui/templates/square_large_text_button")
    -- local character = cm:query_model():character_for_template(character_key);
    parent:Adopt(bt:Address())
    bt:PropagatePriority(parent:Priority())
    gst.UI_Component_resize(bt, x, y, true)
    bt:SetTooltipText(effect.get_localised_string(effect.get_localised_string("mod_xyy_character_browser_confirm_tooltip")), true)
    core:add_listener(
        btn_listener_name,
        "ComponentLClickUp",
        function(context)
            return bt == UIComponent(context.component)
        end,
        function(context)
            closeIllustrationPanel()
        end,
        false
    )
    gst.lib_recordObj(bt, btn_listener_name,  store_panel_btn_table);
    return bt;
end

local function add_back_button(parent, x, y)
    local bt_name = UI_MOD_NAME .. "_xyy_select_character_panel_confirm";
    local btn_listener_name = bt_name .. "_click_up"
    local bt = core:get_or_create_component(bt_name, "ui/templates/square_large_text_button")
    -- local character = cm:query_model():character_for_template(character_key);
    parent:Adopt(bt:Address())
    bt:PropagatePriority(parent:Priority())
    gst.UI_Component_resize(bt, x, y, true)
    bt:SetTooltipText(effect.get_localised_string(effect.get_localised_string("mod_xyy_character_browser_confirm_tooltip")), true)
    core:add_listener(
        btn_listener_name,
        "ComponentLClickUp",
        function(context)
            return bt == UIComponent(context.component)
        end,
        function(context)
            if character_illustration_detail ~= nil then
            character_illustration_detail:SetVisible(false) 
            end
            --销毁商店面板中的所有按钮，并移除监听
            for i = 1, #store_panel_btn_table do
                core:remove_listener(gst.lib_getRecordObjLisName(store_panel_btn_table[i]))
                gst.UI_Component_destroy(gst.lib_getRecordObj(store_panel_btn_table[i]))
            end
            store_panel_btn_table = {}
            
            --销毁商店面板
            gst.UI_Component_destroy(character_illustration_detail)
            character_illustration_detail = nil
            
            static_id = static_id + 1
            
            open_characters_illustrations_menu();
        end,
        false
    )
    gst.lib_recordObj(bt, btn_listener_name,  store_panel_btn_table);
    return bt;
end

function character_browser()
    if cm:get_saved_value("xyy_store_ready") then
        return;
    end
    -- 选择up角色的槽位
    local ui_root = core:get_ui_root()
    local ui_panel_name = UI_MOD_NAME .. "_xyy_select_character_panel" .. static_id;
    xyy_select_character_panel = core:get_or_create_component( ui_panel_name, "ui/xyy/character_browser_1") --date.pack中自带的panel_frame.twui.xml布局文件
    ui_root:Adopt( xyy_select_character_panel:Address() )
    xyy_select_character_panel:PropagatePriority(ui_root:Priority())
    
    local xoffset = 295;
    local yoffset = 250;
    
    ModLog('up角色池长度'..#xyy_character_up_pool)
    local slot1 = add_character_pool(xyy_select_character_panel, 130, "ui/skins/default/character_browser/".. xyy_character_up_pool[1] ..".png", effect.get_localised_string("mod_xyy_character_browser_".. xyy_character_up_pool[1]), xyy_character_up_pool[1], true, false)
    gst.UI_Component_move_relative(slot1, xyy_select_character_panel, xoffset+150*0, yoffset, false)
    
    local slot2 = add_character_pool(xyy_select_character_panel, 130, "ui/skins/default/character_browser/".. xyy_character_up_pool[2] ..".png", effect.get_localised_string("mod_xyy_character_browser_".. xyy_character_up_pool[2]), xyy_character_up_pool[2], true, false)
    gst.UI_Component_move_relative(slot2, xyy_select_character_panel, xoffset+150*1, yoffset, false)
    
    local slot3 = add_character_pool(xyy_select_character_panel, 130, "ui/skins/default/character_browser/".. xyy_character_up_pool[3] ..".png", effect.get_localised_string("mod_xyy_character_browser_".. xyy_character_up_pool[3]), xyy_character_up_pool[3], true, false)
    gst.UI_Component_move_relative(slot3, xyy_select_character_panel, xoffset+150*2, yoffset, false)
    
    if xyy_character_lottery_pool[1] then
        local slot4 = add_character_pool(xyy_select_character_panel, 130, "ui/skins/default/character_browser/".. xyy_character_lottery_pool[1] ..".png", effect.get_localised_string("mod_xyy_character_browser_".. xyy_character_lottery_pool[1]), xyy_character_lottery_pool[1], false, true)
        gst.UI_Component_move_relative(slot4, xyy_select_character_panel, xoffset+150*3, yoffset, false)
    else
        local slot4 = add_character_pool(xyy_select_character_panel, 130, "ui/skins/default/character_browser/placeholder.png", effect.get_localised_string("mod_xyy_character_browser_unknown"), "unknown", false, false)
        gst.UI_Component_move_relative(slot4, xyy_select_character_panel, xoffset+150*3, yoffset, false)
    end
    
    if xyy_character_lottery_pool[2] then
        local slot5 = add_character_pool(xyy_select_character_panel, 130, "ui/skins/default/character_browser/".. xyy_character_lottery_pool[2] ..".png", effect.get_localised_string("mod_xyy_character_browser_".. xyy_character_lottery_pool[2]), xyy_character_lottery_pool[2], false, true)
        gst.UI_Component_move_relative(slot5, xyy_select_character_panel, xoffset+150*4, yoffset, false)
    else
        local slot5 = add_character_pool(xyy_select_character_panel, 130, "ui/skins/default/character_browser/placeholder.png", effect.get_localised_string("mod_xyy_character_browser_unknown"), "unknown", false, false)
        gst.UI_Component_move_relative(slot5, xyy_select_character_panel, xoffset+150*4, yoffset, false)
    end
    
    if xyy_character_lottery_pool[3] then
        local slot6 = add_character_pool(xyy_select_character_panel, 130, "ui/skins/default/character_browser/".. xyy_character_lottery_pool[3] ..".png", effect.get_localised_string("mod_xyy_character_browser_".. xyy_character_lottery_pool[3]), xyy_character_lottery_pool[3], false, true)
        gst.UI_Component_move_relative(slot6, xyy_select_character_panel, xoffset+150*5, yoffset, false)
    else
        local slot6 = add_character_pool(xyy_select_character_panel, 130, "ui/skins/default/character_browser/placeholder.png", effect.get_localised_string("mod_xyy_character_browser_unknown"), "unknown", false, false)
        gst.UI_Component_move_relative(slot6, xyy_select_character_panel, xoffset+150*5, yoffset, false)
    end
    
    if xyy_character_lottery_pool[4] then
        local slot7 = add_character_pool(xyy_select_character_panel, 130, "ui/skins/default/character_browser/".. xyy_character_lottery_pool[4] ..".png", effect.get_localised_string("mod_xyy_character_browser_".. xyy_character_lottery_pool[4]), xyy_character_lottery_pool[4], false, true)
        gst.UI_Component_move_relative(slot7, xyy_select_character_panel, xoffset+150*6, yoffset, false)
    else
        local slot7 = add_character_pool(xyy_select_character_panel, 130, "ui/skins/default/character_browser/placeholder.png", effect.get_localised_string("mod_xyy_character_browser_unknown"), "unknown", false, false)
        gst.UI_Component_move_relative(slot7, xyy_select_character_panel, xoffset+150*6, yoffset, false)
    end
    
    if xyy_character_lottery_pool[5] then
        local slot8 = add_character_pool(xyy_select_character_panel, 130, "ui/skins/default/character_browser/".. xyy_character_lottery_pool[5] ..".png", effect.get_localised_string("mod_xyy_character_browser_".. xyy_character_lottery_pool[5]), xyy_character_lottery_pool[5], false, true)
        gst.UI_Component_move_relative(slot8, xyy_select_character_panel, xoffset+150*7, yoffset, false)
    else
        local slot8 = add_character_pool(xyy_select_character_panel, 130, "ui/skins/default/character_browser/placeholder.png", effect.get_localised_string("mod_xyy_character_browser_unknown"), "unknown", false, false)
        gst.UI_Component_move_relative(slot8, xyy_select_character_panel, xoffset+150*7, yoffset, false)
    end
    
    if xyy_character_lottery_pool[6] then
        local slot9 = add_character_pool(xyy_select_character_panel, 130, "ui/skins/default/character_browser/".. xyy_character_lottery_pool[6] ..".png", effect.get_localised_string("mod_xyy_character_browser_".. xyy_character_lottery_pool[6]), xyy_character_lottery_pool[6], false, true)
        gst.UI_Component_move_relative(slot9, xyy_select_character_panel, xoffset+150*8, yoffset, false)
    else
        local slot9 = add_character_pool(xyy_select_character_panel, 130, "ui/skins/default/character_browser/placeholder.png", effect.get_localised_string("mod_xyy_character_browser_unknown"), "unknown", false, false)
        gst.UI_Component_move_relative(slot9, xyy_select_character_panel, xoffset+150*8, yoffset, false)
    end

    local has_next_page = false;
    
    for i=1,#character_browser_list do
        local index_x = ((i-1)%11);
        local index_y = math.floor((i-1)/11) - page;
        
        if index_y >= 2 then
            has_next_page = true
            break;
        elseif index_y >= 0 then
            local x = 310+120*index_x;
            local y = 450+120*index_y;
            
            --ModLog(x..","..y);
            local slot = add_character_button(xyy_select_character_panel, 100, "ui/skins/default/character_browser/".. character_browser_list[i] ..".png", effect.get_localised_string("mod_xyy_character_browser_".. character_browser_list[i]), character_browser_list[i])
            gst.UI_Component_move_relative(slot, xyy_select_character_panel, x, y, false)
        end
    end
    
    -- 确认选择按钮
    local confirm_button =  add_confirm_button(xyy_select_character_panel, 800, 50)
    gst.UI_Component_move_relative(confirm_button, xyy_select_character_panel, 560, 720, false)
    
    confirm_button:SetState( "down" )
    find_uicomponent(confirm_button, "button_txt"):SetStateText(effect.get_localised_string("mod_xyy_character_browser_confirm"))
    
    if #xyy_character_lottery_pool == 6 then
        confirm_button:SetState( "active" )
        find_uicomponent(confirm_button, "button_txt"):SetStateText(effect.get_localised_string("mod_xyy_character_browser_confirm"))
    else
        confirm_button:SetState( "inactive" )
        find_uicomponent(confirm_button, "button_txt"):SetStateText(effect.get_localised_string("mod_xyy_character_browser_confirm"))
    end
    xyy_select_character_panel:SetVisible(true) 
    -- 下一页按钮
    if has_next_page then
        local next_page =  add_page_button(xyy_select_character_panel, 50, 50, true)
        gst.UI_Component_move_relative(next_page, xyy_select_character_panel, 1380, 720, false)
        next_page:SetState( "down" )
        find_uicomponent(next_page, "button_txt"):SetStateText(">>")
        next_page:SetState( "active" )
        find_uicomponent(next_page, "button_txt"):SetStateText(">>")
    end
    if page > 0 then
        local previous_page =  add_page_button(xyy_select_character_panel, 50, 50, false)
        gst.UI_Component_move_relative(previous_page, xyy_select_character_panel, 490, 720, false)
        previous_page:SetState( "down" )
        find_uicomponent(previous_page, "button_txt"):SetStateText("<<")
        previous_page:SetState( "active" )
        find_uicomponent(previous_page, "button_txt"):SetStateText("<<")
    end
end

--角色图鉴
function open_characters_illustrations_menu()
    local ui_root = core:get_ui_root()
    local ui_panel_name = UI_MOD_NAME .. "_xyy_select_character_panel" .. static_id;
    characters_illustrations_menu = core:get_or_create_component( ui_panel_name, "ui/xyy/character_browser_2")
    ui_root:Adopt( characters_illustrations_menu:Address() )
    characters_illustrations_menu:PropagatePriority(ui_root:Priority())
    
    local xoffset = 295;
    local yoffset = 250;

    local has_next_page = false;
    local i = 0
    local keys = {}
    for key, _ in pairs(gst.all_character_detils) do
        table.insert(keys, key)
    end
    table.sort(keys)
    local tingyun = cm:query_model():character_for_template("hlyjdw")
    if query_character
    and not query_character:is_null_interface()
    and not query_character:is_dead()
    and query_character:faction():name() == cm:query_local_faction():name() 
    and not query_character:is_character_is_faction_recruitment_pool() then
        gst.lib_remove_value_from_list(keys, "hlyjdingzhie")
    end
    if cm:get_saved_value("roguelike_mode") then
        gst.lib_remove_value_from_list(keys, "hlyjdingzhie")
    end
    for k, char_id in ipairs(keys) do
        local char_info = gst.all_character_detils[char_id]
        local index_x = (i%11);
        local index_y = math.floor(i/11) - page2;
        
        if index_y >= 4 then
            has_next_page = true
            break;
        elseif index_y >= 0 then
            local x = 310+120*index_x;
            local y = 210+120*index_y;
            local query_character = gst.character_query_for_template(char_id)
            if query_character
            and not query_character:is_null_interface()
            then
                if not query_character:is_dead()
                and query_character:faction():name() == cm:query_local_faction():name() 
                and not query_character:is_character_is_faction_recruitment_pool() 
                then
                    local slot = add_character_illustration_button(characters_illustrations_menu, 100, "ui/skins/default/character_browser/".. char_id ..".png", effect.get_localised_string("mod_xyy_character_illustrations_unlock") .. "\n" .. effect.get_localised_string("mod_xyy_character_browser_".. char_id) .. "\n\n" .. effect.get_localised_string("mod_xyy_character_illustrations_".. char_id), char_id, false);
                    gst.UI_Component_move_relative(slot, characters_illustrations_menu, x, y, false)
                elseif query_character:is_dead() then
                    local slot = add_character_illustration_button(characters_illustrations_menu, 100, "ui/skins/default/character_browser/".. char_id .."_.png",  effect.get_localised_string("mod_xyy_character_illustrations_lock") .. "\n" .. effect.get_localised_string("mod_xyy_character_browser_".. char_id) .. "\n\n" .. effect.get_localised_string("mod_xyy_character_illustrations_".. char_id), char_id, true);
                    gst.UI_Component_move_relative(slot, characters_illustrations_menu, x, y, false)
                else
                    local slot = add_character_illustration_button(characters_illustrations_menu, 100, "ui/skins/default/character_browser/".. char_id .."_.png",  effect.get_localised_string("mod_xyy_character_illustrations_lock") .. "\n" .. effect.get_localised_string("mod_xyy_character_browser_".. char_id) .. "\n\n" .. effect.get_localised_string("mod_xyy_character_illustrations_".. char_id), char_id, false);
                    gst.UI_Component_move_relative(slot, characters_illustrations_menu, x, y, false)
                end
            else
                local slot = add_character_illustration_button(characters_illustrations_menu, 100, "ui/skins/default/character_browser/".. char_id .."_.png",  effect.get_localised_string("mod_xyy_character_illustrations_lock") .. "\n" .. effect.get_localised_string("mod_xyy_character_browser_".. char_id) .. "\n\n" .. effect.get_localised_string("mod_xyy_character_illustrations_".. char_id), char_id, false);
                gst.UI_Component_move_relative(slot, characters_illustrations_menu, x, y, false)
            end
        end
        
        i = i+1;
    end
    
    -- 关闭按钮
    local confirm_button =  add_close_button(characters_illustrations_menu, 800, 50)
    gst.UI_Component_move_relative(confirm_button, characters_illustrations_menu, 560, 720, false)
    
    confirm_button:SetState( "down" )
    find_uicomponent(confirm_button, "button_txt"):SetStateText(effect.get_localised_string("mod_xyy_character_browser_close"))
    confirm_button:SetState( "active" )
    find_uicomponent(confirm_button, "button_txt"):SetStateText(effect.get_localised_string("mod_xyy_character_browser_close"))
    
    characters_illustrations_menu:SetVisible(true) 
    -- 下一页按钮
    if has_next_page then
        local next_page =  add_page2_button(characters_illustrations_menu, 50, 50, true)
        gst.UI_Component_move_relative(next_page, characters_illustrations_menu, 1380, 720, false)
        next_page:SetState( "down" )
        find_uicomponent(next_page, "button_txt"):SetStateText(">>")
        next_page:SetState( "active" )
        find_uicomponent(next_page, "button_txt"):SetStateText(">>")
    end
    if page2 > 0 then
        local previous_page =  add_page2_button(characters_illustrations_menu, 50, 50, false)
        gst.UI_Component_move_relative(previous_page, characters_illustrations_menu, 490, 720, false)
        previous_page:SetState( "down" )
        find_uicomponent(previous_page, "button_txt"):SetStateText("<<")
        previous_page:SetState( "active" )
        find_uicomponent(previous_page, "button_txt"):SetStateText("<<")
    end
    
    local bt_close = create_bt_close(characters_illustrations_menu)
    gst.UI_Component_move_relative(bt_close, characters_illustrations_menu, panel_size_x - bt_close_size_x - 350, 100, false)
    
    characters_illustrations_menu_button:SetState("selected")
    
--     cm:steal_escape_key_with_callback("xyy_illustration_panel", function()
--         closeIllustrationPanel()
--     end)

    CampaignUI.CreateModelCallbackRequest("xyy_callback_xyy_illustration_panel_open");

end

--打开角色图鉴
function open_character_illustration_detail(char_id)
    local ui_root = core:get_ui_root()
    local ui_panel_name = UI_MOD_NAME .. "_xyy_select_character_detail" .. static_id;
    character_illustration_detail = core:get_or_create_component( ui_panel_name, "ui/xyy/character_browser_2")
    ui_root:Adopt( character_illustration_detail:Address() )
    character_illustration_detail:PropagatePriority(ui_root:Priority())

    local bt_name = UI_MOD_NAME .. "_xyy_character_illustration_detail_" .. char_id;
    local btn_listener_name = bt_name .. "_click_up"
    local bt = core:get_or_create_component(bt_name, "ui/templates/3k_xyy_character_illustration")
    
    character_illustration_detail:Adopt(bt:Address())
    bt:PropagatePriority(character_illustration_detail:Priority())
    gst.UI_Component_move_relative(bt, character_illustration_detail, 510, 210, false)
    --gst.UI_Component_resize(bt, 1000, 1000, true)
    bt:SetImagePath("ui/skins/default/character_illustration/".. char_id ..".png");
    --bt:SetTooltipText(slot_label, true)
    gst.lib_recordObj(bt, btn_listener_name,  store_panel_btn_table);
                
    -- 关闭按钮
    local confirm_button =  add_back_button(character_illustration_detail, 800, 50)
    gst.UI_Component_move_relative(confirm_button, character_illustration_detail, 560, 720, false)
    
    confirm_button:SetState( "down" )
    find_uicomponent(confirm_button, "button_txt"):SetStateText(effect.get_localised_string("mod_xyy_character_browser_back"))
    confirm_button:SetState( "active" )
    find_uicomponent(confirm_button, "button_txt"):SetStateText(effect.get_localised_string("mod_xyy_character_browser_back"))
    
    character_illustration_detail:SetVisible(true) 
    
    local bt_close = create_bt_close(character_illustration_detail)
    gst.UI_Component_move_relative(bt_close, character_illustration_detail, panel_size_x - bt_close_size_x - 350, 100, false)
    
    characters_illustrations_menu_button:SetState("selected")
--     cm:steal_escape_key_with_callback("xyy_illustration_panel", function()
--         closeIllustrationPanel()
--     end)
    CampaignUI.CreateModelCallbackRequest("xyy_callback_xyy_illustration_panel_open");
end

--------------------------------------------------------
-- 事件监听
--------------------------------------------------------
--添加监听
-- core:add_listener(
--     "test",
--     "ModelScriptNotificationEvent",
--     function(model_script_notification_event)
--         ModLog(model_script_notification_event:event_id())
--         return true;
--     end,
--     function(model_script_notification_event)
--     end,
--     true
-- )

core:add_listener(
    "playerStore_api_byHy_listener",
    "FirstTickAfterWorldCreated", --进入存档后的第一时间
    function(context)
        return true
    end,
    function(context)
        gst.lib_reset_randomseed()
        locale = gst.get_locale()
        
        ModLog( "FirstTickAfterWorldCreated 成功,playerstore_byhy.lua 重置玩家派系的 modify_faction 为 nil")
        
        ModLog( "===========读取配置===========" );
        local new_table = {
            ['hlyjdj'] = false,
        }
        local filename = "xyy_playerstore_config"
        local xyy_playerstore_config = gst.lib_try_load_table(filename);
        if not xyy_playerstore_config then
            xyy_playerstore_config = gst.lib_create_and_save_table(filename, new_table)
        end
        if xyy_playerstore_config then
            has_firefly_unlocked = xyy_playerstore_config['hlyjdj'];
        else
            has_firefly_unlocked = false;
        end
        if xyy_playerstore_config then
            has_miyabi_unlocked = xyy_playerstore_config['hlyjdv'];
        else
            has_miyabi_unlocked = false;
        end
        
        ModLog( "===========读取存档===========" );
        
        if true then
            
            if cm:get_saved_value("character_browser_list") then
                character_browser_list = cm:get_saved_value("character_browser_list");
            else 
                ModLog('character_browser_list 写入存档'..#character_browser_list)
                cm:set_saved_value("character_browser_list", character_browser_list);
            end
            
            if cm:get_saved_value("xyy_selected_1p") then
                selected_1p = cm:get_saved_value("xyy_selected_1p");
            end
            
            if cm:get_saved_value("xyy_selected_2p") then
                selected_2p = cm:get_saved_value("xyy_selected_2p");
            end
            
            if cm:get_saved_value("xyy_character_up_pool") then
                xyy_character_up_pool = cm:get_saved_value("xyy_character_up_pool");
            end
            
            if cm:get_saved_value("currect_character_1p") then
                currect_character_1p = cm:get_saved_value("currect_character_1p");
            end
            
            if cm:get_saved_value("currect_character_2p") then
                currect_character_2p = cm:get_saved_value("currect_character_2p");
            end
            
            get_xyy_character_lottery_pool()
            ModLog( "=============================" );
            if not cm:get_saved_value("enabled_character_pool") then
                ModLog( "抽奖角色已禁用");
            else
                for char_id, char_info in pairs(gst.all_character_detils) do
                    if char_info['name'] then
                        local query_character = cm:query_model():character_for_template(char_id);
                        ModLog('开始检测角色：'..char_info['name'])
                        if not gst.lib_value_in_list(xyy_character_lottery_pool, char_id) 
                        and not gst.lib_value_in_list(xyy_character_up_pool, char_id) 
                        and not gst.lib_value_in_list(character_browser_list, char_id) 
                        then
                            ModLog('角色'..char_info['name']..'不存在')
                            if not query_character
                            or query_character:is_null_interface()
                            then
                                --防止隐藏角色进入
                                if char_id ~= "hlyjdf" 
                                and char_id ~= "hlyjdingzhie"
                                and char_id ~= "hlyjdw"
                                then
                                    if not cm:is_multiplayer() then
                                        if char_id == "hlyjdj" and 
                                        has_firefly_unlocked 
                                        then
                                            gst.lib_table_insert(character_browser_list, char_id);
                                        end
                                        if char_id == "hlyjdv" 
                                        and has_miyabi_unlocked 
                                        then
                                            gst.lib_table_insert(character_browser_list, char_id);
                                        end
                                    else
                                        if char_id == "hlyjdj"
                                        and not gst.lib_value_in_list(selected_1p,  "hlyjdj")
                                        and not gst.lib_value_in_list(selected_2p,  "hlyjdj")
                                        then
                                            gst.lib_table_insert(character_browser_list, "hlyjdj");
                                        end
                                        if char_id == "hlyjdv"
                                        and not gst.lib_value_in_list(selected_1p,  "hlyjdv")
                                        and not gst.lib_value_in_list(selected_2p,  "hlyjdv")
                                        then
                                            gst.lib_table_insert(character_browser_list, "hlyjdv");
                                        end
                                        if char_id == "hlyjea"
                                        and not gst.lib_value_in_list(selected_1p,  "hlyjea")
                                        and not gst.lib_value_in_list(selected_2p,  "hlyjea")
                                        then
                                            gst.lib_table_insert(character_browser_list, "hlyjea");
                                        end
                                        if char_id == "hlyjby" 
                                        then
                                            gst.lib_table_insert(character_browser_list, "hlyjby");
                                        end
                                    end
                                end
                                cm:set_saved_value("character_browser_list", character_browser_list);
                            end
                        elseif query_character 
                        and not query_character:is_null_interface() 
                        and not query_character:is_dead() 
                        then
                            ModLog( char_info['name'] .. "在" .. gst.faction_get_string_name(query_character:faction()) .. "派系");

                            if query_character:faction():is_human() 
                            and not query_character:is_character_is_faction_recruitment_pool()
                            then
                                ModLog( char_info['name'] .. "在玩家派系且不在武将招募池");
                                gst.lib_remove_value_from_list(xyy_character_up_pool, char_id);
                                gst.lib_remove_value_from_list(xyy_character_lottery_pool, char_id);
                                gst.lib_remove_value_from_list(character_browser_list, char_id);
                            end
                            if not query_character:generation_template_key() == "hlyjcj" then
                                gst.lib_remove_value_from_list(xyy_character_up_pool, char_id);
                                gst.lib_remove_value_from_list(xyy_character_lottery_pool, char_id);
                            end
                            gst.lib_remove_value_from_list(character_browser_list, char_id);
                        elseif gst.lib_value_in_list(character_browser_list, char_id) then
                            ModLog('角色'..char_info['name']..'位于备选池');
                        end
                    end
                end
            end
            if cm:get_saved_value("selected_up_character") then
                cm:set_saved_value("xyy_character_up_pool", xyy_character_up_pool);
                cm:set_saved_value("xyy_character_lottery_pool", xyy_character_lottery_pool);
                cm:set_saved_value("character_browser_list", character_browser_list);
            end
            ModLog( "=============================" );
        end
        ModLog( "FirstTickAfterWorldCreated 成功,playerstore_byhy.lua 获得玩家派系的 modify_faction ");
        ModLog( "===========读取完成===========" );
        ModLog("UP池列表：");
        for k, v in ipairs(xyy_character_up_pool) do
            gst.lib_remove_value_from_list(character_browser_list, char_id);
            ModLog(k ..": " .. gst.all_character_detils[v]['name']);
        end
        
        ModLog("自选抽奖池列表：");
        for k, v in ipairs(xyy_character_lottery_pool) do
            gst.lib_remove_value_from_list(character_browser_list, char_id);
            ModLog(k ..": " .. gst.all_character_detils[v]['name']);
        end
        
        ModLog("备选池列表：");
        
        if #xyy_character_up_pool > 0 then
            for k,v in ipairs(xyy_character_up_pool) do
                gst.lib_remove_value_from_list(character_browser_list, v)
            end
        end
        for k, v in ipairs(character_browser_list) do
            ModLog(k ..": " .. gst.all_character_detils[v]['name']);
        end
        if is_tingyun_unlock() then
            ModLog("已解锁停云");
        end
        if is_miyabi_unlock() then
            ModLog("已解锁星见雅");
        end
        if is_firefly_unlock() then
            ModLog("已解锁流萤");
        end
    end,
    false
)

cm:add_first_tick_callback(
    function()
        -- 角色入仕
        core:add_listener(
            "character_join_event",
            "FactionTurnStart",
            function(context)
                local faction = context:faction();
                return 
                #character_browser_list > 0
                and not faction:is_null_interface()
                and not faction:is_human()  
                and not faction:is_dead() 
                and faction:name() ~= "xyyhlyjb"
                and faction:name() ~= "xyyhlyjc"
                and faction:name() ~= "xyyhlyjd"
                and faction:name() ~= "xyyhlyje"
                and faction:name() ~= "xyyhlyjf"
                and faction:subculture() ~= "3k_main_subculture_yellow_turban"
                and faction:subculture() ~= "3k_dlc05_subculture_bandits"
                and faction:subculture() ~= "3k_dlc06_subculture_nanman"
                and cm:get_saved_value("enabled_character_pool")
                and not cm:get_saved_value("character_store_disable")
                and not cm:get_saved_value("roguelike_mode")
            end,
            function(context)
                local faction = context:faction();
                local max = 3000
                if cm:query_model():turn_number() <= 40 and cm:query_model():turn_number() > 20 then
                    max = 2000
                elseif cm:query_model():turn_number() <= 70 and cm:query_model():turn_number() > 40 then
                    max = 1000
                elseif cm:query_model():turn_number() > 70 then
                    max = 100
                end
                
                local random = gst.lib_getRandomValue(0, max)
                
                if faction:name() == "3k_main_faction_cao_cao" then
                    random = random - 300
                elseif faction:name() == "3k_main_faction_liu_bei" then
                    random = random - 230
                elseif faction:name() == "3k_dlc05_faction_sun_ce" then
                    random = random - 180
                elseif faction:name() == "3k_main_faction_yuan_shao" then
                    random = random - 300
                elseif faction:name() == "3k_main_faction_dong_zhuo" then
                    random = random - 300
                elseif faction:name() == "3k_main_faction_lu_bu" then
                    random = random - 140
                elseif faction:name() == "xyyhlyja" then
                    random = random - 40
                elseif faction:name() == "xyy" then
                    random = random - 60
                elseif faction:name() == "3k_main_faction_liu_biao" then
                    random = random - 40
                elseif faction:name() == "3k_main_faction_liu_yan" then
                    random = random - 30
                end
                
                if faction:treasury() >= 10000 then
                    random = random - 100
                end
                
                ModLog(faction:name() ..": ".. random)
                
                --符玄在AI派系时略微提高其获取角色的概率
                local hlyjcp = cm:query_model():character_for_template("hlyjcp");
                if hlyjcp 
                and not hlyjcp:is_null_interface()
                and not hlyjcp:is_dead()
                and not hlyjcp:is_character_is_faction_recruitment_pool()
                and hlyjcp:faction():name() == faction:name() 
                then
                    random = random - 300
                end
                
                local hlyjcm = cm:query_model():character_for_template("hlyjcm");
                if hlyjcm 
                and not hlyjcm:is_null_interface()
                and not hlyjcm:is_dead()
                and not hlyjcm:is_character_is_faction_recruitment_pool()
                and hlyjcm:faction():name() == faction:name() 
                and hlyjcm:faction():faction_leader():generation_template_key() == "hlyjcm"
                then
                    random = random - 300
                end
                
                ModLog("角色入仕随机数 " .. random)
                if random > 10 then
                    return;
                end

                -- 角色入仕的方法
                local function xyy_character_official(char_id, char_detil)
                    -- 如果角色是卡芙卡，直接取消
                    if char_id == 'hlyjcj' then
                        ModLog('角色入仕：跳过 卡芙卡')
                        return;
                    end 
                    
                    if char_id == "hlyjdj" and not is_firefly_unlock() and not cm:is_multiplayer() then
                        return;
                    end
                    
                    if char_id == "hlyjdv" and not is_miyabi_unlock() and not cm:is_multiplayer() then
                        return;
                    end
                    
                    if char_id == 'hlyjdf' 
                    or char_id == 'hlyjdingzhie' 
                    or char_id == 'hlyjdw' 
                    then
                        return;
                    end
                    
                    if char_id == 'hlyjby' 
                    and not cm:is_multiplayer()
                    then
                        return;
                    end
                    
                    if context:faction():has_faction_leader() 
                    and context:faction():faction_leader():generation_template_key() == "hlyjcm"
                    then
                        if char_id == "hlyjcu" then
                            return
                        end
                    end
                    
                    -- 角色开始入仕
                    local character = cm:query_model():character_for_template(char_id)
                    if not character or character:is_null_interface() then
                        character = gst.character_add_to_faction(char_id, context:faction():name(), char_detil['subtype']);
                        ModLog('刚刚' .. gst.all_character_detils[char_id]['name'] .. "加入" .. context:faction():name())
                        -- 角色特殊处理阶段
                        --如果人物是阮梅而且正值春季
                        if char_id == "hlyjct" and cm:query_model():season() == "season_spring" then
                            AI_chosen_path_blessing(context:faction());
                        end
            
                        cm:modify_character(character):add_experience(88000,0);
                        
                        if cm:query_model():turn_number() <= 20 then
                            cm:modify_character(character):apply_effect_bundle("job_satisfaction_ignored", 30);
                        elseif cm:query_model():turn_number() <= 30 and cm:query_model():turn_number() > 20 then
                            cm:modify_character(character):apply_effect_bundle("job_satisfaction_ignored", 20);
                        elseif cm:query_model():turn_number() <= 50 and  cm:query_model():turn_number() > 30 then
                            cm:modify_character(character):apply_effect_bundle("job_satisfaction_ignored", 10);
                        end
                        ModLog(gst.all_character_detils[char_id]['name'].."加入了"..context:faction():name())
                    end
                end

                -- 从待入仕角色中随机选一个
                local character_id = character_browser_list[gst.lib_getRandomValue(1, #character_browser_list)]
                gst.lib_remove_value_from_list(character_browser_list, character_id);
                ModLog('character_browser_list 写入存档')
                cm:set_saved_value("character_browser_list", character_browser_list)
                local character = cm:query_model():character_for_template(character_id)
                
                -- 如果角色已经入仕则取消
                if character and not character:is_null_interface() and character:faction():is_human() then
                    return;
                end
                
                for char_id, char_info in pairs(gst.all_character_detils) do
                    if character_id == char_id then
                        xyy_character_official(char_id, char_info)
                    end
                end
            end,
            true
        )
        
        --给按钮设置监听
        core:add_listener(
            "characters_illustrations_menu_button",
            "ComponentLClickUp",
            function(context)
                return UIComponent(context.component) == characters_illustrations_menu_button --当鼠标点击的按钮==此按钮时，返回true，触发下面的 “点击函数”
            end,
            --“点击函数”
            function(context)
                closeStorePanel()
                the_seven_kings_close_pannel();
                if not character_illustration_detail and not characters_illustrations_menu then
                    open_characters_illustrations_menu();
                else
                    closeIllustrationPanel()
                end
            end,
            true
        )
        
        core:add_listener(
            "character_select",
            "ModelScriptNotificationEvent",
            function(model_script_notification_event)
                return cm:get_saved_value("xyy_store_ready") 
                and string.find(model_script_notification_event:event_id(), "xyy_store_craft_");
            end,
            function(model_script_notification_event)
                local key = model_script_notification_event:event_id()
                local time = store_items[key]["time"]
                local button = store_items[key]["button"]
                local price = store_items[key]["price"]
                local faction = cm:query_model():world():whose_turn_is_it()
                refresh_text(faction)
                if (faction:has_effect_bundle("3k_xyy_character_sold_out_dummy") or cm:get_saved_value("character_store_disable")) and gst.faction_get_tickets(faction:name()) > 0 then
                    local ticket = gst.faction_get_tickets(faction:name())
                    if cm:query_local_faction(true):name() == faction:name() then
                        local ui_root = core:get_ui_root()
                        local ui_panel_name = UI_MOD_NAME .. "_info_panel" .. static_id_2;
                        info_panel = core:get_or_create_component( ui_panel_name, "ui/templates/info_dialogue") 
                        ui_root:Adopt( info_panel:Address() )
                        info_panel:PropagatePriority( ui_root:Priority() )
                        find_uicomponent(info_panel, "DY_header"):SetStateText(effect.get_localised_string("mod_xyy_store_info_4"))
                        find_uicomponent(info_panel, "settlement_name"):SetStateText(effect.get_localised_string("mod_xyy_store_info_5"))
                        find_uicomponent(info_panel, "DY_text"):SetStateText(string.gsub(effect.get_localised_string("mod_xyy_store_info_6"), "%%1", 1))
                    end
                    core:add_listener(
                        "gacha_button_listener",
                        "ModelScriptNotificationEvent",
                        function(model_script_notification_event)
                            return model_script_notification_event:event_id() == "gacha_cancel"
                            or model_script_notification_event:event_id() == "gacha_accept";
                        end,
                        function(model_script_notification_event)
                            if info_panel then
                                info_panel:SetVisible(false)
                                core:remove_listener("gacha_button_listener")
                                gst.UI_Component_destroy(info_panel)
                                info_panel = nil
                                static_id_2 = static_id_2 + 1
                            end
                            if model_script_notification_event:event_id() == "gacha_accept" then
                                local building_list_key = string.gsub(key, "xyy_store_craft_", "xyy_roguelike_craft_")
                                if not is_faction_have_building(faction, gst.building_list[building_list_key]) then
                                    if not time then
                                        time = -1
                                    end
                                    cm:modify_faction(faction):apply_effect_bundle(key, time)
                                    gst.faction_sub_tickets(faction:name(), 1)
                                    if button then
                                        button:SetState("selected_inactive")
                                    end
                                else
                                    gst.faction_sub_tickets(faction:name(), 1)
                                    create_item_by_category(string.gsub(key, "xyy_store_craft_", ""), faction)
                                    if button then
                                        button:SetState("active")
                                    end
                                end
                                refresh_text(faction)
                            else
                                if faction:treasury() >= price then
                                    local building_list_key = string.gsub(key, "xyy_store_craft_", "xyy_roguelike_craft_")
                                    if not is_faction_have_building(faction, gst.building_list[building_list_key]) then
                                        if not time then
                                            time = -1
                                        end
                                        cm:modify_faction(faction):apply_effect_bundle(key, time)
                                        cm:modify_faction(faction):decrease_treasury(price)
                                        if button then
                                            button:SetState("selected_inactive")
                                        end
                                    else
                                        cm:modify_faction(faction):decrease_treasury(price)
                                        create_item_by_category(string.gsub(key, "xyy_store_craft_", ""), faction)
                                        if button then
                                            button:SetState("active")
                                        end
                                    end
                                else
                                    if button then
                                        button:SetState("active")
                                        if faction:name() == cm:query_local_faction(true):name() then
                                            effect.advice(effect.get_localised_string("mod_xyy_store_main_message_no_money"))
                                        end
                                    end
                                end
                            end
                        end,
                        false
                    )
                else
                    if faction:treasury() >= price then
                        local building_list_key = string.gsub(key, "xyy_store_craft_", "xyy_roguelike_craft_")
                        if not is_faction_have_building(faction, gst.building_list[building_list_key]) then
                            if not time then
                                time = -1
                            end
                            cm:modify_faction(faction):apply_effect_bundle(key, time)
                            cm:modify_faction(faction):decrease_treasury(price)
                            if button then
                                button:SetState("selected_inactive")
                            end
                        else
                            cm:modify_faction(faction):decrease_treasury(price)
                            create_item_by_category(string.gsub(key, "xyy_store_craft_", ""), faction)
                            if button then
                                button:SetState("active")
                            end
                        end
                    else
                        if button then
                            button:SetState("active")
                            if faction:name() == cm:query_local_faction(true):name() then
                                effect.advice(effect.get_localised_string("mod_xyy_store_main_message_no_money"))
                            end
                        end
                    end
                    refresh_text(faction)
                end
            end,
            true
        )
        
        core:add_listener(
            "character_select",
            "ModelScriptNotificationEvent",
            function(model_script_notification_event)
                return cm:get_saved_value("xyy_store_ready") 
                and string.find(model_script_notification_event:event_id(), "select_");
            end,
            function(model_script_notification_event)
                local character_key = string.gsub(model_script_notification_event:event_id(), "^select_", "")
                if cm:is_multiplayer() then
                local faction = cm:query_model():world():whose_turn_is_it()
                    if faction:name() == cm:get_saved_value("xyy_1p") then
                        currect_character_1p = character_key
                        cm:set_saved_value("currect_character_1p", currect_character_1p)
                        ModLog("currect_character_1p = " ..currect_character_1p)
                        refresh_menu_button_notification()
                    end
                    if faction:name() == cm:get_saved_value("xyy_2p") then
                        currect_character_2p = character_key
                        cm:set_saved_value("currect_character_2p", currect_character_2p)
                        ModLog("currect_character_2p = " ..currect_character_2p)
                        refresh_menu_button_notification()
                    end
                else
                    currect_character_1p = character_key
                    cm:set_saved_value("currect_character_1p", currect_character_1p)
                    refresh_menu_button_notification()
                end
                if store_panel then
                    closeStorePanel()
                    openStorePanel()
                end
            end,
            true
        )
        
        core:add_listener(
            "gacha_button_1",
            "ModelScriptNotificationEvent",
            function(model_script_notification_event)
                return model_script_notification_event:event_id() == "gacha_button_1";
            end,
            function(model_script_notification_event)
                local faction = cm:query_model():world():whose_turn_is_it()
                refresh_text(faction)
                
--                 local ui_root = core:get_ui_root()
--                 local ui_panel_name = UI_MOD_NAME .. "_test_panel" .. static_id_2;
--                 local test_panel = core:get_or_create_component( ui_panel_name, "D:/Program Files (x86)/Steam/steamapps/common/Total War THREE KINGDOMS/assembly_kit/working_data/ui/templates/xyy_store") 
--                 ui_root:Adopt( test_panel:Address() )
--                 test_panel:PropagatePriority( ui_root:Priority() )
                
                if gst.faction_get_tickets(faction:name()) < 1 then
                    if cm:query_local_faction(true):name() == faction:name() then
                        local ui_root = core:get_ui_root()
                        local ui_panel_name = UI_MOD_NAME .. "_info_panel" .. static_id_2;
                        info_panel = core:get_or_create_component( ui_panel_name, "ui/templates/info_dialogue") 
                        ui_root:Adopt( info_panel:Address() )
                        info_panel:PropagatePriority( ui_root:Priority() )
                        find_uicomponent(info_panel, "DY_header"):SetStateText(effect.get_localised_string("mod_xyy_store_info_1"))
                        find_uicomponent(info_panel, "settlement_name"):SetStateText(string.gsub(effect.get_localised_string("mod_xyy_store_info_2"), "%%1", 1))
                        find_uicomponent(info_panel, "DY_text"):SetStateText(string.gsub(effect.get_localised_string("mod_xyy_store_info_3"), "%%1", 5000))
                        if faction:treasury() < 5000 then
                            local button = find_uicomponent(info_panel, "button_accept")
                            button:SetState("inactive")
                        end
                    end
                    core:add_listener(
                        "gacha_button_listener",
                        "ModelScriptNotificationEvent",
                        function(model_script_notification_event)
                            return model_script_notification_event:event_id() == "gacha_cancel"
                            or model_script_notification_event:event_id() == "gacha_accept";
                        end,
                        function(model_script_notification_event)
                            if info_panel then
                                info_panel:SetVisible(false)
                                core:remove_listener("gacha_button_listener")
                                gst.UI_Component_destroy(info_panel)
                                info_panel = nil
                                static_id_2 = static_id_2 + 1
                            end
                            if model_script_notification_event:event_id() == "gacha_accept" then
                                local message = effect.get_localised_string("mod_xyy_store_main_message_main_gacha_top")
                                cm:modify_faction(faction):decrease_treasury( 5000 )
                                gst.faction_add_tickets(faction:name(), 1)
                                if faction:name() == cm:query_local_faction(true):name() then
                                    refresh_text(faction)
                                end
                                message = message .. draw(faction)
                                message = message .. string.gsub(effect.get_localised_string("mod_xyy_store_main_message_main_gacha_bottom"), "%%1", 50 - cm:get_saved_value(faction:name().."_guaranteed")); 
                                if faction:name() == cm:query_local_faction(true):name() then
                                    effect.advice(message)
                                    refresh_text(faction)
                                end
                            else
                                
                            end
                        end,
                        false
                    )
                else
                    local message = effect.get_localised_string("mod_xyy_store_main_message_main_gacha_top")
                    message = message .. draw(faction)
                    message = message .. string.gsub(effect.get_localised_string("mod_xyy_store_main_message_main_gacha_bottom"), "%%1", 50 - cm:get_saved_value(faction:name().."_guaranteed")); 
                    if faction:name() == cm:query_local_faction(true):name() then
                        effect.advice(message)
                        refresh_text(faction)
                    end
                end
            end,
            true
        )
        
        core:add_listener(
            "gacha_button_10",
            "ModelScriptNotificationEvent",
            function(model_script_notification_event)
                return model_script_notification_event:event_id() == "gacha_button_10";
            end,
            function(model_script_notification_event)
                local faction = cm:query_model():world():whose_turn_is_it()
                refresh_text(faction)
                if gst.faction_get_tickets(faction:name()) < 10 then
                    local ticket = gst.faction_get_tickets(faction:name())
                    local left = 10 - ticket
                    if cm:query_local_faction(true):name() == faction:name() then
                        local ui_root = core:get_ui_root()
                        local ui_panel_name = UI_MOD_NAME .. "_info_panel" .. static_id_2;
                        info_panel = core:get_or_create_component( ui_panel_name, "ui/templates/info_dialogue") 
                        ui_root:Adopt( info_panel:Address() )
                        info_panel:PropagatePriority( ui_root:Priority() )
                        find_uicomponent(info_panel, "DY_header"):SetStateText(effect.get_localised_string("mod_xyy_store_info_1"))
                        find_uicomponent(info_panel, "settlement_name"):SetStateText(string.gsub(effect.get_localised_string("mod_xyy_store_info_2"), "%%1", left))
                        find_uicomponent(info_panel, "DY_text"):SetStateText(string.gsub(effect.get_localised_string("mod_xyy_store_info_3"), "%%1", 5000*left))
                        if faction:treasury() < 5000*left then
                            local button = find_uicomponent(info_panel, "button_accept")
                            button:SetState("inactive")
                        end
                    end
                    core:add_listener(
                        "gacha_button_listener",
                        "ModelScriptNotificationEvent",
                        function(model_script_notification_event)
                            return model_script_notification_event:event_id() == "gacha_cancel"
                            or model_script_notification_event:event_id() == "gacha_accept";
                        end,
                        function(model_script_notification_event)
                            if info_panel then
                                info_panel:SetVisible(false)
                                core:remove_listener("gacha_button_listener")
                                gst.UI_Component_destroy(info_panel)
                                info_panel = nil
                                static_id_2 = static_id_2 + 1
                            end
                            if model_script_notification_event:event_id() == "gacha_accept" then
                                local message = effect.get_localised_string("mod_xyy_store_main_message_main_gacha_top")
                                cm:modify_faction(faction):decrease_treasury( 5000 * left )
                                gst.faction_add_tickets(faction:name(), left)
                                if faction:name() == cm:query_local_faction(true):name() then
                                    refresh_text(faction)
                                end
                                for i = 0, 9 do
                                    message = message .. draw(faction)
                                    if cm:is_multiplayer() then
                                        if faction:name() == cm:get_saved_value("xyy_1p") and #selected_1p == 0 then
                                            break;
                                        end
                                        if faction:name() == cm:get_saved_value("xyy_2p") and #selected_2p == 0 then
                                            break;
                                        end
                                    else
                                        if #xyy_character_lottery_pool == 0 and #xyy_character_up_pool == 0 then
                                            break;
                                        end
                                    end
                                end
                                message = message .. string.gsub(effect.get_localised_string("mod_xyy_store_main_message_main_gacha_bottom"), "%%1", 50 - cm:get_saved_value(faction:name().."_guaranteed")); 
                                if faction:name() == cm:query_local_faction(true):name() then
                                    effect.advice(message)
                                    refresh_text(faction)
                                end
                            else
                                
                            end
                        end,
                        false
                    )
                else
                    local message = effect.get_localised_string("mod_xyy_store_main_message_main_gacha_top")
                    for i = 0, 9 do
                        message = message .. draw(faction)
                        if cm:is_multiplayer() then
                            if faction:name() == cm:get_saved_value("xyy_1p") and #selected_1p == 0 then
                                break;
                            end
                            if faction:name() == cm:get_saved_value("xyy_2p") and #selected_2p == 0 then
                                break;
                            end
                        else
                            if #xyy_character_lottery_pool == 0 and #xyy_character_up_pool == 0 then
                                break;
                            end
                        end
                    end
                    message = message .. string.gsub(effect.get_localised_string("mod_xyy_store_main_message_main_gacha_bottom"), "%%1", 50 - cm:get_saved_value(faction:name().."_guaranteed")); 
                    if faction:name() == cm:query_local_faction(true):name() then
                        effect.advice(message)
                        refresh_text(faction)
                    end
                end
            end,
            true
        )
        
        core:add_listener(
            "faction_effect_bundle_removed_event",
            "FactionEffectBundleRemoved",
            function(context)
                return string.find(context:effect_bundle_key(), "xyy_store_craft_");
            end,
            function(context)
                create_item_by_category(string.gsub(context:effect_bundle_key(), "xyy_store_craft_", ""), context:faction())
            end,
            true
        )
        
        core:add_listener(
            "faction_effect_check_building",
            "FactionTurnStart",
            function(context)
                return true;
            end,
            function(context)
                local faction = context:faction()
                if faction:has_effect_bundle("xyy_store_craft_accessories") then
                    local building_list = gst.building_list["xyy_roguelike_craft_accessories"]
                    if is_faction_have_building(context:faction(), building_list) then
                        cm:modify_faction(faction):remove_effect_bundle("xyy_store_craft_accessories")
                    end
                end
                if faction:has_effect_bundle("xyy_store_craft_weapons") then
                    local building_list = gst.building_list["xyy_roguelike_craft_weapons"]
                    if is_faction_have_building(context:faction(), building_list) then
                        cm:modify_faction(faction):remove_effect_bundle("xyy_store_craft_weapons")
                    end
                end
                if faction:has_effect_bundle("xyy_store_craft_mounts") then
                    local building_list = gst.building_list["xyy_roguelike_craft_mounts"]
                    if is_faction_have_building(context:faction(), building_list) then
                        cm:modify_faction(faction):remove_effect_bundle("xyy_store_craft_mounts")
                    end
                end
                if faction:has_effect_bundle("xyy_store_craft_armors") then
                    local building_list = gst.building_list["xyy_roguelike_craft_armors"]
                    if is_faction_have_building(context:faction(), building_list) then
                        cm:modify_faction(faction):remove_effect_bundle("xyy_store_craft_armors")
                    end
                end
                if faction:has_effect_bundle("xyy_store_craft_accessories_1") then
                    local building_list = gst.building_list["xyy_roguelike_craft_accessories_1"]
                    if is_faction_have_building(context:faction(), building_list) then
                        cm:modify_faction(faction):remove_effect_bundle("xyy_store_craft_accessories_1")
                    end
                end
                if faction:has_effect_bundle("xyy_store_craft_weapons_1") then
                    local building_list = gst.building_list["xyy_roguelike_craft_weapons_1"]
                    if is_faction_have_building(context:faction(), building_list) then
                        cm:modify_faction(faction):remove_effect_bundle("xyy_store_craft_weapons_1")
                    end
                end
                if faction:has_effect_bundle("xyy_store_craft_mounts_1") then
                    local building_list = gst.building_list["xyy_roguelike_craft_mounts_1"]
                    if is_faction_have_building(context:faction(), building_list) then
                        cm:modify_faction(faction):remove_effect_bundle("xyy_store_craft_mounts_1")
                    end
                end
                if faction:has_effect_bundle("xyy_store_craft_armors_1") then
                    local building_list = gst.building_list["xyy_roguelike_craft_armors_1"]
                    if is_faction_have_building(context:faction(), building_list) then
                        cm:modify_faction(faction):remove_effect_bundle("xyy_store_craft_armors_1")
                    end
                end
            end,
            true
        )
        
        core:add_listener(
            "closeallpanel",
            "FactionTurnEnd",
            function(context)  
                return context:faction():is_human()
            end,
            function(context)
                closeStorePanel();
                closeIllustrationPanel();
                the_seven_kings_close_pannel();
            end,
            true
        )
        
        core:add_listener(
            "refresh_menu_button_notification",
            "FirstTickAfterWorldCreated",
            function(context)  
                return true
            end,
            function(context)
                refresh_menu_button_notification()
            end,
            true
        )
        
        core:add_listener(
            "refresh_menu_button_notification",
            "FactionTurnStart",
            function(context)  
                return context:faction():is_human()
            end,
            function(context)
                refresh_menu_button_notification()
            end,
            true
        )
        
        core:add_listener(
            "ComponentLClickUp_button_end_notifications",
            "ComponentLClickUp",
            function(context)
                --ModLog(context.string)
                return context.string == "button_end_notifications"
            end,
            function()
                --refresh_menu_button_notification()
            end,
            true
        );
        
        core:add_listener(
            "ComponentLClickUp_close_panel",
            "ComponentLClickUp",
            function(context)
                --ModLog(context.string)
                return context.string == "button_ambitions"
                or context.string == "button_captains"
                or context.string == "button_schemes"
                or context.string == "button_tribes_fealty"
                or context.string == "button_faction_ancillaries_list"
                or context.string == "button_favour"
                or context.string == "button_missions"
                or context.string == "button_finance"
                or context.string == "button_undercover_network_panel"
                or context.string == "button_diplomacy"
                or context.string == "button_court"
            end,
            function()
                closeStorePanel();
                closeIllustrationPanel();
                the_seven_kings_close_pannel();
            end,
            true
        );
        
--         core:add_listener(
--             "ShortcutTriggered_debug",
--             "ShortcutTriggered",
--             function(context) 
--                 --ModLog(context.string)
--                 return context.string == "end_turn_notifications";
--             end,
--             function()
--                 --refresh_menu_button_notification()
--             end,
--             true
--         );	
    end
);


local function add_roguelike_confirm_button(parent, x, y)
    local bt_name = UI_MOD_NAME .. "_xyy_rogueli_select_character_confirm" .. static_id;
    local btn_listener_name = bt_name .. "_click_up"
    local bt = core:get_or_create_component(bt_name, "ui/templates/square_large_text_button")
    -- local character = cm:query_model():character_for_template(character_key);
    parent:Adopt(bt:Address())
    bt:PropagatePriority(parent:Priority())
    gst.UI_Component_resize(bt, x, y, true)
    bt:SetTooltipText(effect.get_localised_string(effect.get_localised_string("mod_xyy_character_browser_confirm_tooltip")), true)
    core:add_listener(
        btn_listener_name,
        "ComponentLClickUp",
        function(context)
            return bt == UIComponent(context.component)
        end,
        function(context)
            --隐藏商店面板
            if (parent ~= nil) then
            parent:SetVisible(false) 
            end
            --销毁商店面板中的所有按钮，并移除监听
            for i = 1, #store_panel_btn_table do
                core:remove_listener(gst.lib_getRecordObjLisName(store_panel_btn_table[i]))
                gst.UI_Component_destroy(gst.lib_getRecordObj(store_panel_btn_table[i]))
            end
            store_panel_btn_table = {}
            
            --销毁商店面板
            gst.UI_Component_destroy(parent)
            
            xyy_select_character_panel = nil;
            
            static_id = static_id + 1
            
            gst.wait_for_model_sp(function()
                if cm:get_saved_value("roguelike_mode") then
                    cm:set_saved_value("character_browser_list", character_browser_list)
                    cm:set_saved_value("selected_up_character", true)
                    cm:set_saved_value("xyy_store_ready", true)
                    cm:set_saved_value("enabled_character_pool", true)
                    cm:set_saved_value("xyy_roguelike_mission_boss_character_browser", nil)
                    cm:set_saved_value("xyy_roguelike_mission_2_boss_character_browser", nil)
                    
                    cm:set_saved_value("xyy_roguelike_character_select", nil);
                    local player_faction_query_object = cm:query_model():world():whose_turn_is_it();
                    local clist = {}
                    for i, v in ipairs(xyy_character_lottery_pool) do
                        gst.lib_table_insert(clist, v)
                    end
                    for i, v in ipairs(clist) do
                        add_character_to_player(v, player_faction_query_object)
                    end
                    for i, v in ipairs(xyy_character_up_pool) do
                        if not gst.lib_value_in_list(character_browser_list, v) then
                            gst.lib_table_insert(character_browser_list, v)
                        end
                    end
                    xyy_character_up_pool = {}
                    cm:set_saved_value("xyy_character_lottery_pool", xyy_character_lottery_pool)
                    cm:set_saved_value("xyy_character_up_pool", xyy_character_up_pool)
                    if cm:get_saved_value("roguelike_mode_character_pool") 
                    and cm:get_saved_value("roguelike_mode_character_pool") == "roguelike_first_select" 
                    then
                        add_menu_button()
                        cm:set_saved_value("roguelike_mode_character_pool", nil)
                    end
                    if cm:get_saved_value("xyy_select_character_panel_list") 
                    and cm:get_saved_value("xyy_select_character_panel_list") > 0 
                    then
                        cm:set_saved_value("xyy_select_character_panel_list", cm:get_saved_value("xyy_select_character_panel_list") - 1)
                        character_browser_roguelike_select(false);
                        return
                    end
                    if cm:get_saved_value("roguelike_safe_trigger") then
                        cm:set_saved_value("roguelike_safe_trigger", nil)
                    else
                        if not cm:get_saved_value("roguelike_enemy_effect_key") then
                            cm:set_saved_value("roguelike_panel_list", 1)
                            reapply_enemy_effect()
                        else
                            openRoguelikePanel(false)
                        end
                        return
                    end
                    if cm:get_saved_value("xyy_roguelike_51") then
                        cm:set_saved_value("xyy_roguelike_51", nil)
                        local random = math.floor(gst.lib_getRandomValue(1,1000))
                        if random > 500 then
                            cm:set_saved_value("roguelike_safe_trigger", true)
                            character_browser_roguelike_select(false);
                            return
                        end
                    end
                    cm:modify_model():get_modify_episodic_scripting():autosave_at_next_opportunity();
                    CampaignUI.CreateModelCallbackRequest("xyy_callback_steal_escape_key_false");
                    
                    if cm:is_player_turn() then
                        menu_button:SetState("active")
                    end
                    
--                     cm:modify_model():get_modify_episodic_scripting():disable_end_turn(false);
--                     cm:modify_scripting():disable_shortcut("button_end_turn", "end_turn", false);
--                     cm:modify_scripting():override_ui("disable_end_turn", false);
                end
            end)
        end,
        false
    )
    gst.lib_recordObj(bt, btn_listener_name,  store_panel_btn_table);
    return bt;
end

function character_browser_roguelike_first_select(is_redraw)
    cm:set_saved_value("xyy_roguelike_character_select", true);
    if not is_redraw and xyy_select_character_panel then
--         cm:modify_model():get_modify_episodic_scripting():disable_end_turn(true);
--         cm:modify_scripting():disable_shortcut("button_end_turn", "end_turn", true);
--         cm:modify_scripting():override_ui("disable_end_turn", true);

        if not cm:get_saved_value("xyy_select_character_panel_list") then
            cm:set_saved_value("xyy_select_character_panel_list", 1)
        else
            cm:set_saved_value("xyy_select_character_panel_list", cm:get_saved_value("xyy_select_character_panel_list") + 1)
        end 
        return;
    end
    
    if not is_redraw then
        if not gst.lib_value_in_list(character_browser_list, "hlyjby") then
            gst.lib_table_insert(character_browser_list, "hlyjby")
        end
        if not gst.lib_value_in_list(character_browser_list, "hlyjdf") then
            gst.lib_table_insert(character_browser_list, "hlyjdf")
        end
        if gst.lib_value_in_list(character_browser_list, "hlyjdingzhie") then
            gst.lib_remove_value_from_list(character_browser_list, "hlyjdingzhie")
        end
        if not is_firefly_unlock() then
            gst.lib_remove_value_from_list(character_browser_list, "hlyjdj")
        end
        if not is_tingyun_unlock() then
            gst.lib_remove_value_from_list(character_browser_list, "hlyjdw")
        end
        if not is_miyabi_unlock() then
            gst.lib_remove_value_from_list(character_browser_list, "hlyjdv")
        end
        if not is_cantarella_unlock() then
            gst.lib_remove_value_from_list(character_browser_list, "hlyjeb")
        end
    end
    
    cm:set_saved_value("roguelike_mode_character_pool", "roguelike_first_select")
    -- 选择up角色的槽位
    local ui_root = core:get_ui_root()
    local ui_panel_name = UI_MOD_NAME .. "_xyy_select_character_panel" .. static_id;
    xyy_select_character_panel = core:get_or_create_component( ui_panel_name, "ui/xyy/character_browser_1") --date.pack中自带的panel_frame.twui.xml布局文件
    find_uicomponent(xyy_select_character_panel, "faction_council_header"):SetStateText(effect.get_localised_string("mod_xyy_character_roguelike_select_first"))
    ui_root:Adopt( xyy_select_character_panel:Address() )
    xyy_select_character_panel:PropagatePriority(ui_root:Priority())
    
    local xoffset = 295;
    local yoffset = 250;
    
    if xyy_character_lottery_pool[1] then
        local slot4 = add_character_pool(xyy_select_character_panel, 130, "ui/skins/default/character_browser/".. xyy_character_lottery_pool[1] ..".png", effect.get_localised_string("mod_xyy_character_browser_".. xyy_character_lottery_pool[1]), xyy_character_lottery_pool[1], false, true)
        gst.UI_Component_move_relative(slot4, xyy_select_character_panel, xoffset+150*3, yoffset, false)
    else
        local slot4 = add_character_pool(xyy_select_character_panel, 130, "ui/skins/default/character_browser/placeholder.png", effect.get_localised_string("mod_xyy_character_browser_unknown"), "unknown", false, false)
        gst.UI_Component_move_relative(slot4, xyy_select_character_panel, xoffset+150*3, yoffset, false)
    end
    
    if xyy_character_lottery_pool[2] then
        local slot5 = add_character_pool(xyy_select_character_panel, 130, "ui/skins/default/character_browser/".. xyy_character_lottery_pool[2] ..".png", effect.get_localised_string("mod_xyy_character_browser_".. xyy_character_lottery_pool[2]), xyy_character_lottery_pool[2], false, true)
        gst.UI_Component_move_relative(slot5, xyy_select_character_panel, xoffset+150*4, yoffset, false)
    else
        local slot5 = add_character_pool(xyy_select_character_panel, 130, "ui/skins/default/character_browser/placeholder.png", effect.get_localised_string("mod_xyy_character_browser_unknown"), "unknown", false, false)
        gst.UI_Component_move_relative(slot5, xyy_select_character_panel, xoffset+150*4, yoffset, false)
    end
    
    if xyy_character_lottery_pool[3] then
        local slot6 = add_character_pool(xyy_select_character_panel, 130, "ui/skins/default/character_browser/".. xyy_character_lottery_pool[3] ..".png", effect.get_localised_string("mod_xyy_character_browser_".. xyy_character_lottery_pool[3]), xyy_character_lottery_pool[3], false, true)
        gst.UI_Component_move_relative(slot6, xyy_select_character_panel, xoffset+150*5, yoffset, false)
    else
        local slot6 = add_character_pool(xyy_select_character_panel, 130, "ui/skins/default/character_browser/placeholder.png", effect.get_localised_string("mod_xyy_character_browser_unknown"), "unknown", false, false)
        gst.UI_Component_move_relative(slot6, xyy_select_character_panel, xoffset+150*5, yoffset, false)
    end

    local has_next_page = false;
    if not is_redraw then
        local max_browser = 4
        if max_browser > #character_browser_list then
            max_browser = #character_browser_list
        end
        for i = 1, #xyy_character_up_pool do
            if gst.lib_value_in_list(character_browser_list, xyy_character_up_pool[i]) then
                gst.lib_remove_value_from_list(character_browser_list, xyy_character_up_pool[i])
            end
        end
        character_browser_list = gst.lib_shuffle_table(character_browser_list)
        for i = 1, max_browser do
            gst.lib_table_insert(xyy_character_up_pool, character_browser_list[i])
        end
    end
    
    if has_miyabi_unlocked and not is_redraw then
        gst.lib_table_insert(xyy_character_up_pool, "hlyjdv")
    end
    
    
    for i=1,#xyy_character_up_pool do
        local index_x = ((i-1)%11);
        local index_y = math.floor((i-1)/11) - page;
        
        if index_y >= 2 then
            has_next_page = true
            break;
        elseif index_y >= 0 then
            local x = 310+120*index_x;
            local y = 450+120*index_y;
            
            local slot = add_character_button(xyy_select_character_panel, 100, "ui/skins/default/character_browser/".. xyy_character_up_pool[i] ..".png", effect.get_localised_string("mod_xyy_character_browser_".. xyy_character_up_pool[i]), xyy_character_up_pool[i])
            gst.UI_Component_move_relative(slot, xyy_select_character_panel, x, y, false)
        end
    end
    
    -- 确认选择按钮
    local confirm_button =  add_roguelike_confirm_button(xyy_select_character_panel, 800, 50)
    gst.UI_Component_move_relative(confirm_button, xyy_select_character_panel, 560, 720, false)
    
    confirm_button:SetState( "down" )
    find_uicomponent(confirm_button, "button_txt"):SetStateText(effect.get_localised_string("mod_xyy_character_browser_confirm"))
    
    if #xyy_character_lottery_pool == 3 then
        confirm_button:SetState( "active" )
        find_uicomponent(confirm_button, "button_txt"):SetStateText(effect.get_localised_string("mod_xyy_character_browser_confirm"))
    else
        confirm_button:SetState( "inactive" )
        find_uicomponent(confirm_button, "button_txt"):SetStateText(effect.get_localised_string("mod_xyy_character_browser_confirm"))
    end
    if cm:get_saved_value("issued_dilemma") then
        xyy_select_character_panel:SetVisible(false) 
    else
        xyy_select_character_panel:SetVisible(true) 
    end
    -- 下一页按钮
--     if has_next_page then
--         local next_page =  add_page_button(xyy_select_character_panel, 50, 50, true)
--         gst.UI_Component_move_relative(next_page, xyy_select_character_panel, 1380, 720, false)
--         next_page:SetState( "down" )
--         find_uicomponent(next_page, "button_txt"):SetStateText(">>")
--         next_page:SetState( "active" )
--         find_uicomponent(next_page, "button_txt"):SetStateText(">>")
--     end
--     if page > 0 then
--         local previous_page =  add_page_button(xyy_select_character_panel, 50, 50, false)
--         gst.UI_Component_move_relative(previous_page, xyy_select_character_panel, 490, 720, false)
--         previous_page:SetState( "down" )
--         find_uicomponent(previous_page, "button_txt"):SetStateText("<<")
--         previous_page:SetState( "active" )
--         find_uicomponent(previous_page, "button_txt"):SetStateText("<<")
--     end
end


function character_browser_roguelike_select(is_redraw)
    cm:set_saved_value("xyy_roguelike_character_select", true);
    if not is_redraw and xyy_select_character_panel then
        if not cm:get_saved_value("xyy_select_character_panel_list") then
            cm:set_saved_value("xyy_select_character_panel_list", 1)
        else
            cm:set_saved_value("xyy_select_character_panel_list", cm:get_saved_value("xyy_select_character_panel_list") + 1)
        end 
        return;
    end
    cm:set_saved_value("roguelike_mode_character_pool", "roguelike_select")
    if not is_redraw then
        if gst.lib_value_in_list(character_browser_list, "hlyjby") 
        and gst.character_is_faction_have(cm:query_local_faction():name(), "hlyjby")
        then
            gst.lib_remove_value_from_list(character_browser_list, "hlyjby")
        end
        
--         if gst.lib_value_in_list(character_browser_list, "hlyjdingzhie") 
--         and gst.character_is_faction_have(cm:query_local_faction():name(), "hlyjdingzhie")
--         then
--             gst.lib_remove_value_from_list(character_browser_list, "hlyjdingzhie")
--         end
        
        if gst.lib_value_in_list(character_browser_list, "hlyjdf") 
        and gst.character_is_faction_have(cm:query_local_faction():name(), "hlyjdf")
        then
            gst.lib_remove_value_from_list(character_browser_list, "hlyjdf")
        end
        
        if not gst.character_is_faction_have(cm:query_local_faction():name(), "hlyjdj") then
            if has_firefly_unlocked then
                gst.lib_table_insert(character_browser_list, "hlyjdj")
            else
                gst.lib_remove_value_from_list(character_browser_list, "hlyjdj")
            end
        end
        
        if not gst.character_is_faction_have(cm:query_local_faction():name(), "hlyjdv") then
            if has_miyabi_unlocked then
                gst.lib_table_insert(character_browser_list, "hlyjdv")
            else
                gst.lib_remove_value_from_list(character_browser_list, "hlyjdv")
            end
        end
        
        --菲比暂时不可用
        if not gst.character_is_faction_have(cm:query_local_faction():name(), "hlyjeb") and not has_cantarella_unlocked then
            gst.lib_remove_value_from_list(character_browser_list, "hlyjeb")
        end
        
        if gst.lib_value_in_list(character_browser_list, "hlyjdingzhie") then
            gst.lib_remove_value_from_list(character_browser_list, "hlyjdingzhie")
        end
        
        if gst.character_is_faction_have(cm:query_local_faction():name(), "hlyjcj")
        then
            gst.lib_remove_value_from_list(character_browser_list, "hlyjcj")
        else
            gst.lib_table_insert(character_browser_list, "hlyjcj")
        end
        xyy_character_up_pool = {};
    end
    -- 选择up角色的槽位
    local ui_root = core:get_ui_root()
    local ui_panel_name = UI_MOD_NAME .. "_xyy_select_character_panel" .. static_id;
    xyy_select_character_panel = core:get_or_create_component( ui_panel_name, "ui/xyy/character_browser_1") --date.pack中自带的panel_frame.twui.xml布局文件
    
    find_uicomponent(xyy_select_character_panel, "faction_council_header"):SetStateText(effect.get_localised_string("mod_xyy_character_roguelike_select"))
    ui_root:Adopt( xyy_select_character_panel:Address() )
    xyy_select_character_panel:PropagatePriority(ui_root:Priority())
    
    local xoffset = 295;
    local yoffset = 250;
    
    local max_selections = get_max_character_selections()
    if max_selections == 1 or #character_browser_list <= 1 then
        if xyy_character_lottery_pool[1] then
            local slot5 = add_character_pool(xyy_select_character_panel, 130, "ui/skins/default/character_browser/".. xyy_character_lottery_pool[1] ..".png", effect.get_localised_string("mod_xyy_character_browser_".. xyy_character_lottery_pool[1]), xyy_character_lottery_pool[1], false, true)
            gst.UI_Component_move_relative(slot5, xyy_select_character_panel, xoffset+150*4, yoffset, false)
        else
            local slot5 = add_character_pool(xyy_select_character_panel, 130, "ui/skins/default/character_browser/placeholder.png", effect.get_localised_string("mod_xyy_character_browser_unknown"), "unknown", false, false)
            gst.UI_Component_move_relative(slot5, xyy_select_character_panel, xoffset+150*4, yoffset, false)
        end
    elseif max_selections == 2 then
        if xyy_character_lottery_pool[1] then
            local slot4 = add_character_pool(xyy_select_character_panel, 130, "ui/skins/default/character_browser/".. xyy_character_lottery_pool[1] ..".png", effect.get_localised_string("mod_xyy_character_browser_".. xyy_character_lottery_pool[1]), xyy_character_lottery_pool[1], false, true)
            gst.UI_Component_move_relative(slot4, xyy_select_character_panel, xoffset+150*3.5, yoffset, false)
        else
            local slot4 = add_character_pool(xyy_select_character_panel, 130, "ui/skins/default/character_browser/placeholder.png", effect.get_localised_string("mod_xyy_character_browser_unknown"), "unknown", false, false)
            gst.UI_Component_move_relative(slot4, xyy_select_character_panel, xoffset+150*3.5, yoffset, false)
        end
        
        if xyy_character_lottery_pool[2] then
            local slot6 = add_character_pool(xyy_select_character_panel, 130, "ui/skins/default/character_browser/".. xyy_character_lottery_pool[2] ..".png", effect.get_localised_string("mod_xyy_character_browser_".. xyy_character_lottery_pool[2]), xyy_character_lottery_pool[2], false, true)
            gst.UI_Component_move_relative(slot6, xyy_select_character_panel, xoffset+150*4.5, yoffset, false)
        else
            local slot6 = add_character_pool(xyy_select_character_panel, 130, "ui/skins/default/character_browser/placeholder.png", effect.get_localised_string("mod_xyy_character_browser_unknown"), "unknown", false, false)
            gst.UI_Component_move_relative(slot6, xyy_select_character_panel, xoffset+150*4.5, yoffset, false)
        end
    end

    local has_next_page = false;
    if not is_redraw then
        local max_browser = get_max_character_browser()
        if max_browser > #character_browser_list then
            max_browser = #character_browser_list
        end
        for i = 1, #xyy_character_up_pool do
            if gst.lib_value_in_list(character_browser_list, xyy_character_up_pool[i]) then
                gst.lib_remove_value_from_list(character_browser_list, xyy_character_up_pool[i])
            end
        end
        character_browser_list = gst.lib_shuffle_table(character_browser_list)
        for i = 1, max_browser do
            gst.lib_table_insert(xyy_character_up_pool, character_browser_list[i])
        end
    end
    
    for i = 1,#xyy_character_up_pool do
        local index_x = ((i-1)%11);
        local index_y = math.floor((i-1)/11) - page;
        
        if index_y >= 2 then
            has_next_page = true
            break;
        elseif index_y >= 0 then
            local x = 310+120*index_x;
            local y = 450+120*index_y;
            
            local slot = add_character_button(xyy_select_character_panel, 100, "ui/skins/default/character_browser/".. xyy_character_up_pool[i] ..".png", effect.get_localised_string("mod_xyy_character_browser_".. xyy_character_up_pool[i]), xyy_character_up_pool[i])
            gst.UI_Component_move_relative(slot, xyy_select_character_panel, x, y, false)
        end
    end
    
    -- 确认选择按钮
    local confirm_button =  add_roguelike_confirm_button(xyy_select_character_panel, 800, 50)
    gst.UI_Component_move_relative(confirm_button, xyy_select_character_panel, 560, 720, false)
    
    confirm_button:SetState( "down" )
    find_uicomponent(confirm_button, "button_txt"):SetStateText(effect.get_localised_string("mod_xyy_character_browser_confirm"))
    
    if #xyy_character_lottery_pool >= max_selections 
    or #xyy_character_lottery_pool >= #xyy_character_up_pool 
    or #xyy_character_up_pool == 0 
    then
        confirm_button:SetState( "active" )
        find_uicomponent(confirm_button, "button_txt"):SetStateText(effect.get_localised_string("mod_xyy_character_browser_confirm"))
    else
        confirm_button:SetState( "inactive" )
        find_uicomponent(confirm_button, "button_txt"):SetStateText(effect.get_localised_string("mod_xyy_character_browser_confirm"))
    end
    if cm:get_saved_value("issued_dilemma") then
        xyy_select_character_panel:SetVisible(false) 
    else
        xyy_select_character_panel:SetVisible(true) 
    end
    menu_button:SetState("inactive")
    -- 下一页按钮
--     if has_next_page then
--         local next_page =  add_page_button(xyy_select_character_panel, 50, 50, true)
--         gst.UI_Component_move_relative(next_page, xyy_select_character_panel, 1380, 720, false)
--         next_page:SetState( "down" )
--         find_uicomponent(next_page, "button_txt"):SetStateText(">>")
--         next_page:SetState( "active" )
--         find_uicomponent(next_page, "button_txt"):SetStateText(">>")
--     end
--     if page > 0 then
--         local previous_page =  add_page_button(xyy_select_character_panel, 50, 50, false)
--         gst.UI_Component_move_relative(previous_page, xyy_select_character_panel, 490, 720, false)
--         previous_page:SetState( "down" )
--         find_uicomponent(previous_page, "button_txt"):SetStateText("<<")
--         previous_page:SetState( "active" )
--         find_uicomponent(previous_page, "button_txt"):SetStateText("<<")
--     end
end

function reset_pannel_index()
    if pannel_index == 3 then
        pannel_index = 2
    else
        pannel_index = 0
    end
end

core:add_listener(
    "store_dilemma_hide_gui",
    "DilemmaIssuedEvent",
    function(context)
        return context:faction():is_human();
    end,
    function(context)
        if xyy_select_character_panel then
            xyy_select_character_panel:SetVisible(false)
        end
    end,
    true
)

core:add_listener(
    "store_dilemma_show_gui",
    "DilemmaChoiceMadeEvent",
    function(context)
        return context:faction():is_human();
    end,
    function(context)
        if xyy_select_character_panel then
            xyy_select_character_panel:SetVisible(true)
        end
    end,
    true
)

--多人模式
local function save_value()
    cm:set_saved_value("xyy_character_lottery_pool", xyy_character_lottery_pool)
    cm:set_saved_value("xyy_selected_1p", selected_1p)
    cm:set_saved_value("xyy_selected_2p", selected_2p)
    cm:set_saved_value("time", panel_time)
    cm:set_saved_value("xyy_page", page)
    cm:set_saved_value("character_browser_list", character_browser_list)
    cm:set_saved_value("xyy_character_up_pool", xyy_character_up_pool)
end

local function load_value()
    if cm:get_saved_value("xyy_character_lottery_pool") then
        xyy_character_lottery_pool = cm:get_saved_value("xyy_character_lottery_pool")
    end
    if cm:get_saved_value("xyy_character_up_pool") then
        xyy_character_up_pool = cm:get_saved_value("xyy_character_up_pool")
    end
    if cm:get_saved_value("xyy_selected_1p") then
        selected_1p = cm:get_saved_value("xyy_selected_1p")
        ModLog("selected_1p:")
        for i, v in ipairs(selected_1p) do
            ModLog(v)
        end;
    end
    if cm:get_saved_value("xyy_selected_2p") then
        selected_2p = cm:get_saved_value("xyy_selected_2p")
        ModLog("selected_2p:")
        for i, v in ipairs(selected_2p) do
            ModLog(v)
        end;
    end
    if cm:get_saved_value("character_browser_list") then
        character_browser_list = cm:get_saved_value("character_browser_list")
        for i, v in ipairs(selected_1p) do
            gst.lib_remove_value_from_list(character_browser_list, v)
        end;
        for i, v2 in ipairs(selected_2p) do
            gst.lib_remove_value_from_list(character_browser_list, v2)
        end;
        ModLog("character_browser_list:")
        for i, v3 in ipairs(character_browser_list) do
            ModLog(v3)
        end;
    end
    if cm:get_saved_value("xyy_page") then
        page = cm:get_saved_value("xyy_page")
    end
    if cm:get_saved_value("time") then
        panel_time = cm:get_saved_value("time")
        ModLog("panel_time = "..panel_time)
    end
end

local function remove_all_character_listener()
    for char_id,v in pairs(gst.all_character_detils) do
        local listener_name = "select_" .. char_id
        core:remove_listener(listener_name)
    end 
end

local function add_1p_character_button_listener(character_key)
    local listener_name = "select_" .. character_key
    core:add_listener(
        listener_name,
        "ModelScriptNotificationEvent",
        function(model_script_notification_event)
            return model_script_notification_event:event_id() == listener_name
        end,
        function(model_script_notification_event)
            ModLog("add_character_button_1p: ".. model_script_notification_event:event_id())
            if cm:get_saved_value("time") == "1p_1" then
                if #selected_1p < 1 then
                    remove_all_character_listener()
                    if(xyy_select_character_panel ~= nil) then
                        xyy_select_character_panel:SetVisible(false) 
                    end
                    for i = 1, #store_panel_btn_table do
                        core:remove_listener(gst.lib_getRecordObjLisName(store_panel_btn_table[i]))
                        gst.UI_Component_destroy(gst.lib_getRecordObj(store_panel_btn_table[i]))
                    end
                    store_panel_btn_table = {}
                    gst.UI_Component_destroy(xyy_select_character_panel)
                    xyy_select_character_panel = nil
                    static_id = static_id + 1;
                    UI_MOD_NAME = "playerStore_byHy"..static_id
                    gst.lib_remove_value_from_list(xyy_character_up_pool, character_key)
                    gst.lib_remove_value_from_list(character_browser_list, character_key)
                    gst.lib_table_insert(selected_1p, character_key)
                    character_browser_multiplayer_1p_1()
                end
            elseif cm:get_saved_value("time") == "1p_2" then
                if #selected_1p < 3 then
                    remove_all_character_listener()
                    if(xyy_select_character_panel ~= nil) then
                        xyy_select_character_panel:SetVisible(false) 
                    end
                    for i = 1, #store_panel_btn_table do
                        core:remove_listener(gst.lib_getRecordObjLisName(store_panel_btn_table[i]))
                        gst.UI_Component_destroy(gst.lib_getRecordObj(store_panel_btn_table[i]))
                    end
                    store_panel_btn_table = {}
                    gst.UI_Component_destroy(xyy_select_character_panel)
                    xyy_select_character_panel = nil
                    static_id = static_id + 1;
                    UI_MOD_NAME = "playerStore_byHy"..static_id
                    gst.lib_remove_value_from_list(character_browser_list, character_key)
                    gst.lib_table_insert(selected_1p, character_key)
                    character_browser_multiplayer_1p_2()
                end
            elseif cm:get_saved_value("time") == "1p_3" then
                if #selected_1p < 6 then
                    remove_all_character_listener()
                    if(xyy_select_character_panel ~= nil) then
                        xyy_select_character_panel:SetVisible(false) 
                    end
                    for i = 1, #store_panel_btn_table do
                        core:remove_listener(gst.lib_getRecordObjLisName(store_panel_btn_table[i]))
                        gst.UI_Component_destroy(gst.lib_getRecordObj(store_panel_btn_table[i]))
                    end
                    store_panel_btn_table = {}
                    gst.UI_Component_destroy(xyy_select_character_panel)
                    xyy_select_character_panel = nil
                    static_id = static_id + 1;
                    UI_MOD_NAME = "playerStore_byHy"..static_id
                    gst.lib_remove_value_from_list(character_browser_list, character_key)
                    gst.lib_table_insert(selected_1p, character_key)
                    character_browser_multiplayer_1p_3()
                end
            elseif cm:get_saved_value("time") == "1p_4" then
                if #selected_1p < 9 then
                    remove_all_character_listener()
                    if(xyy_select_character_panel ~= nil) then
                        xyy_select_character_panel:SetVisible(false) 
                    end
                    for i = 1, #store_panel_btn_table do
                        core:remove_listener(gst.lib_getRecordObjLisName(store_panel_btn_table[i]))
                        gst.UI_Component_destroy(gst.lib_getRecordObj(store_panel_btn_table[i]))
                    end
                    store_panel_btn_table = {}
                    gst.UI_Component_destroy(xyy_select_character_panel)
                    xyy_select_character_panel = nil
                    static_id = static_id + 1;
                    UI_MOD_NAME = "playerStore_byHy"..static_id
                    gst.lib_remove_value_from_list(character_browser_list, character_key)
                    gst.lib_table_insert(selected_1p, character_key)
                    character_browser_multiplayer_1p_4()
                end
            end
        end, 
        false
    )
end

function add_character_button_char_sel(parent, slot_icon_size, slot_icon, slot_label, character_key)
    --ModLog('创建了按钮'..character_key)
    local bt_name = UI_MOD_NAME .. "_xyy_select_character_panel_" .. static_id .. character_key;
    local btn_listener_name = bt_name .. "_click_up"
    local bt
    if character_key == "hlyjdj" and not has_firefly_unlocked then
        bt = core:get_or_create_component(bt_name, "ui/templates/3k_btn_large_invalid")
    elseif character_key == "hlyjdw" and not has_tingyun_unlocked then
        bt = core:get_or_create_component(bt_name, "ui/templates/3k_btn_large_invalid")
    elseif character_key == "hlyjdv" and not has_miyabi_unlocked then
        bt = core:get_or_create_component(bt_name, "ui/templates/3k_btn_large_invalid")
    --菲比暂时不可用
    elseif character_key == "hlyjeb" and not has_cantarella_unlocked then
        bt = core:get_or_create_component(bt_name, "ui/templates/3k_btn_large_invalid")
    else
        bt = core:get_or_create_component(bt_name, "ui/templates/button_mp/3k_btn_large_" .. character_key)
    end
    -- local character = cm:query_model():character_for_template(character_key);
    parent:Adopt(bt:Address())
    bt:PropagatePriority(parent:Priority())
    gst.UI_Component_resize(bt, slot_icon_size, slot_icon_size, true)
    
    bt:SetImagePath(slot_icon);
    if character_key == "hlyjdj" and not has_firefly_unlocked then
        bt:SetImagePath("ui/skins/default/character_browser/hlyjdj_.png");
    elseif character_key == "hlyjdw" and not has_tingyun_unlocked then
        bt:SetImagePath("ui/skins/default/character_browser/hlyjdw_.png");
    elseif character_key == "hlyjdv" and not has_miyabi_unlocked then
        bt:SetImagePath("ui/skins/default/character_browser/hlyjdv_.png");
    --菲比暂时不可用
    elseif character_key == "hlyjeb" and not has_cantarella_unlocked then
        bt:SetImagePath("ui/skins/default/character_browser/hlyjea_.png");
    end
    bt:SetTooltipText(slot_label, true);
    
    gst.lib_recordObj(bt, btn_listener_name,  store_panel_btn_table);
    return bt;
end

--角色按钮: 玩家1
function add_character_pool_1p(parent, slot_icon_size, slot_icon, slot_label, character_key, lock, can_remove)
    if character_key == 'unkown' then
        --ModLog('创建了按钮未知角色头像')
    else 
        --ModLog('创建了按钮'..character_key)
    end
    local bt_name = UI_MOD_NAME .. "_xyy_select_character_panel_" .. static_id .. character_key;
    local btn_listener_name = bt_name .. "_click_up"
    local bt
    if cm:query_local_faction(true):name() == cm:get_saved_value("xyy_1p") and can_remove then 
        bt = core:get_or_create_component(bt_name, "ui/templates/button_mp/3k_btn_large_" .. character_key)
    else
        bt = core:get_or_create_component(bt_name, "ui/templates/3k_btn_large")
    end
    -- local character = cm:query_model():character_for_template(character_key);
    parent:Adopt(bt:Address())
    bt:PropagatePriority(parent:Priority())
    gst.UI_Component_resize(bt, slot_icon_size, slot_icon_size, true)
    bt:SetImagePath(slot_icon);
    bt:SetTooltipText(slot_label, true)
    gst.lib_recordObj(bt, btn_listener_name,  store_panel_btn_table);
    
    core:add_listener(
        btn_listener_name,
        "ModelScriptNotificationEvent",
        function(model_script_notification_event)
            return model_script_notification_event:event_id() == "select_" .. character_key
        end,
        function(model_script_notification_event)
            ModLog("add_character_pool_1p: ".. model_script_notification_event:event_id())
            if(xyy_select_character_panel ~= nil) then
                xyy_select_character_panel:SetVisible(false) 
            end
            for i = 1, #store_panel_btn_table do
                core:remove_listener(gst.lib_getRecordObjLisName(store_panel_btn_table[i]))
                gst.UI_Component_destroy(gst.lib_getRecordObj(store_panel_btn_table[i]))
            end
            store_panel_btn_table = {}
            gst.UI_Component_destroy(xyy_select_character_panel)
            xyy_select_character_panel = nil
            static_id = static_id + 1;
            UI_MOD_NAME = "playerStore_byHy"..static_id
            if cm:get_saved_value("time") == "1p_1" then
                gst.lib_remove_value_from_list(selected_1p, character_key)
                gst.lib_table_insert(xyy_character_up_pool, character_key)
                gst.lib_table_insert(character_browser_list, character_key)
                character_browser_multiplayer_1p_1()
            elseif cm:get_saved_value("time") == "1p_2" then
                gst.lib_remove_value_from_list(selected_1p, character_key)
                gst.lib_table_insert(character_browser_list, character_key)
                character_browser_multiplayer_1p_2()
            elseif cm:get_saved_value("time") == "1p_3" then
                gst.lib_remove_value_from_list(selected_1p, character_key)
                gst.lib_table_insert(character_browser_list, character_key)
                character_browser_multiplayer_1p_3()
            elseif cm:get_saved_value("time") == "1p_4" then
                gst.lib_remove_value_from_list(selected_1p, character_key)
                gst.lib_table_insert(character_browser_list, character_key)
                character_browser_multiplayer_1p_4()
            end
        end,
        false
    )
    return bt;
end

function add_character_button_1p(parent, slot_icon_size, slot_icon, slot_label, character_key)
    --ModLog('创建了按钮'..character_key)
    local bt_name = UI_MOD_NAME .. "_xyy_select_character_panel_" .. static_id .. character_key;
    local btn_listener_name = bt_name .. "_click_up"
    local bt
    if character_key == "hlyjdj" and not has_firefly_unlocked then
        bt = core:get_or_create_component(bt_name, "ui/templates/3k_btn_large_invalid")
    elseif character_key == "hlyjdw" and not has_tingyun_unlocked then
        bt = core:get_or_create_component(bt_name, "ui/templates/3k_btn_large_invalid")
    elseif character_key == "hlyjdv" and not has_miyabi_unlocked then
        bt = core:get_or_create_component(bt_name, "ui/templates/3k_btn_large_invalid")
    --菲比暂时不可用
    elseif character_key == "hlyjeb" and not has_cantarella_unlocked then
        bt = core:get_or_create_component(bt_name, "ui/templates/3k_btn_large_invalid")
    else
        if cm:query_local_faction(true):name() == cm:get_saved_value("xyy_1p") then
            bt = core:get_or_create_component(bt_name, "ui/templates/button_mp/3k_btn_large_" .. character_key)
        else
            bt = core:get_or_create_component(bt_name, "ui/templates/3k_btn_large")
        end
    end
    -- local character = cm:query_model():character_for_template(character_key);
    parent:Adopt(bt:Address())
    bt:PropagatePriority(parent:Priority())
    gst.UI_Component_resize(bt, slot_icon_size, slot_icon_size, true)
    
    bt:SetImagePath(slot_icon);
    if character_key == "hlyjdj" and not has_firefly_unlocked then
        bt:SetImagePath("ui/skins/default/character_browser/hlyjdj_.png");
    elseif character_key == "hlyjdw" and not has_tingyun_unlocked then
        bt:SetImagePath("ui/skins/default/character_browser/hlyjdw_.png");
    elseif character_key == "hlyjdv" and not has_miyabi_unlocked then
        bt:SetImagePath("ui/skins/default/character_browser/hlyjdv_.png");
    --菲比暂时不可用
    elseif character_key == "hlyjeb" and not has_cantarella_unlocked then
        bt:SetImagePath("ui/skins/default/character_browser/hlyjea_.png");
    end
    bt:SetTooltipText(slot_label, true);
    
    gst.lib_recordObj(bt, btn_listener_name,  store_panel_btn_table);
    return bt;
end

--确认按钮: 玩家1
function add_confirm_button_1p(parent, x, y)
    local bt_name = UI_MOD_NAME .. "_xyy_select_character_panel_confirm";
    local btn_listener_name = bt_name .. "_click_up"
    local bt = core:get_or_create_component(bt_name, "ui/templates/button_mp/confirm_button_1p")
    parent:Adopt(bt:Address())
    bt:PropagatePriority(parent:Priority())
    gst.UI_Component_resize(bt, x, y, true)
    bt:SetTooltipText(effect.get_localised_string(effect.get_localised_string("mod_xyy_character_browser_confirm_tooltip")), true)
    
    core:add_listener(
        btn_listener_name,
        "ModelScriptNotificationEvent",
        function(model_script_notification_event)
            return model_script_notification_event:event_id() == "confirm_button_1p"
        end,
        function(model_script_notification_event)
            ModLog("add_confirm_button_1p: ".. model_script_notification_event:event_id())
            if cm:get_saved_value("time") == "1p_1" then
                if #selected_1p == 1 then
                    if(xyy_select_character_panel ~= nil) then
                        xyy_select_character_panel:SetVisible(false) 
                    end
                    for i = 1, #store_panel_btn_table do
                        core:remove_listener(gst.lib_getRecordObjLisName(store_panel_btn_table[i]))
                        gst.UI_Component_destroy(gst.lib_getRecordObj(store_panel_btn_table[i]))
                    end
                    store_panel_btn_table = {}
                    gst.UI_Component_destroy(xyy_select_character_panel)
                    xyy_select_character_panel = nil
                    static_id = static_id + 1;
                    UI_MOD_NAME = "playerStore_byHy"..static_id
                    character_browser_multiplayer_2p_1()
                end
            elseif cm:get_saved_value("time") == "1p_2" then
                if #selected_1p == 3 then
                    if(xyy_select_character_panel ~= nil) then
                        xyy_select_character_panel:SetVisible(false) 
                    end
                    for i = 1, #store_panel_btn_table do
                        core:remove_listener(gst.lib_getRecordObjLisName(store_panel_btn_table[i]))
                        gst.UI_Component_destroy(gst.lib_getRecordObj(store_panel_btn_table[i]))
                    end
                    store_panel_btn_table = {}
                    gst.UI_Component_destroy(xyy_select_character_panel)
                    xyy_select_character_panel = nil
                    static_id = static_id + 1;
                    UI_MOD_NAME = "playerStore_byHy"..static_id
                    character_browser_multiplayer_2p_2()
                end
            elseif cm:get_saved_value("time") == "1p_3" then
                if #selected_1p == 6 then
                    if(xyy_select_character_panel ~= nil) then
                        xyy_select_character_panel:SetVisible(false) 
                    end
                    for i = 1, #store_panel_btn_table do
                        core:remove_listener(gst.lib_getRecordObjLisName(store_panel_btn_table[i]))
                        gst.UI_Component_destroy(gst.lib_getRecordObj(store_panel_btn_table[i]))
                    end
                    store_panel_btn_table = {}
                    gst.UI_Component_destroy(xyy_select_character_panel)
                    xyy_select_character_panel = nil
                    static_id = static_id + 1;
                    UI_MOD_NAME = "playerStore_byHy"..static_id
                    character_browser_multiplayer_2p_3()
                end
            elseif cm:get_saved_value("time") == "1p_4" then
                if #selected_1p == 9 then
                    if(xyy_select_character_panel ~= nil) then
                        xyy_select_character_panel:SetVisible(false) 
                    end
                    for i = 1, #store_panel_btn_table do
                        core:remove_listener(gst.lib_getRecordObjLisName(store_panel_btn_table[i]))
                        gst.UI_Component_destroy(gst.lib_getRecordObj(store_panel_btn_table[i]))
                    end
                    store_panel_btn_table = {}
                    gst.UI_Component_destroy(xyy_select_character_panel)
                    xyy_select_character_panel = nil
                    static_id = static_id + 1;
                    UI_MOD_NAME = "playerStore_byHy"..static_id
                    character_browser_multiplayer_2p_4()
                end
            end
        end,
        false
    )
    gst.lib_recordObj(bt, btn_listener_name,  store_panel_btn_table);
    return bt;
end

--角色按钮: 玩家2
function add_character_pool_2p(parent, slot_icon_size, slot_icon, slot_label, character_key, lock, can_remove)
    local bt_name = UI_MOD_NAME .. "_xyy_select_character_panel_" .. static_id .. character_key;
    local btn_listener_name = bt_name .. "_click_up"
    local bt
    if cm:query_local_faction(true):name() == cm:get_saved_value("xyy_2p") and can_remove then
        bt = core:get_or_create_component(bt_name, "ui/templates/button_mp/3k_btn_large_" .. character_key)
    else
        bt = core:get_or_create_component(bt_name, "ui/templates/3k_btn_large")
    end
    -- local character = cm:query_model():character_for_template(character_key);
    parent:Adopt(bt:Address())
    bt:PropagatePriority(parent:Priority())
    gst.UI_Component_resize(bt, slot_icon_size, slot_icon_size, true)
    bt:SetImagePath(slot_icon);
    bt:SetTooltipText(slot_label, true)
    gst.lib_recordObj(bt, btn_listener_name,  store_panel_btn_table);
    
    core:add_listener(
        btn_listener_name,
        "ModelScriptNotificationEvent",
        function(model_script_notification_event)
            return model_script_notification_event:event_id() == "select_" .. character_key
        end,
        function(model_script_notification_event)
            ModLog("add_character_pool_2p: ".. model_script_notification_event:event_id())
            if(xyy_select_character_panel ~= nil) then
                xyy_select_character_panel:SetVisible(false) 
            end
            for i = 1, #store_panel_btn_table do
                core:remove_listener(gst.lib_getRecordObjLisName(store_panel_btn_table[i]))
                gst.UI_Component_destroy(gst.lib_getRecordObj(store_panel_btn_table[i]))
            end
            store_panel_btn_table = {}
            gst.UI_Component_destroy(xyy_select_character_panel)
            xyy_select_character_panel = nil
            static_id = static_id + 1;
            UI_MOD_NAME = "playerStore_byHy"..static_id
            if cm:get_saved_value("time") == "2p_1" then
                gst.lib_remove_value_from_list(selected_2p, character_key)
                gst.lib_table_insert(xyy_character_up_pool, character_key)
                gst.lib_table_insert(character_browser_list, character_key)
                character_browser_multiplayer_2p_1()
            elseif cm:get_saved_value("time") == "2p_2" then
                gst.lib_remove_value_from_list(selected_2p, character_key)
                gst.lib_table_insert(character_browser_list, character_key)
                character_browser_multiplayer_2p_2()
            elseif cm:get_saved_value("time") == "2p_3" then
                gst.lib_remove_value_from_list(selected_2p, character_key)
                gst.lib_table_insert(character_browser_list, character_key)
                character_browser_multiplayer_2p_3()
            elseif cm:get_saved_value("time") == "2p_4" then
                gst.lib_remove_value_from_list(selected_2p, character_key)
                gst.lib_table_insert(character_browser_list, character_key)
                character_browser_multiplayer_2p_4()
            end
        end,
        false
    )
    return bt;
end

function add_2p_character_button_listener(character_key)
    local listener_name = "select_" .. character_key
    core:add_listener(
        listener_name,
        "ModelScriptNotificationEvent",
        function(model_script_notification_event)
            return model_script_notification_event:event_id() == listener_name
        end,
        function(model_script_notification_event)
            if cm:get_saved_value("time") == "2p_1" then
                if #selected_2p < 2 then
                    remove_all_character_listener()
                    if(xyy_select_character_panel ~= nil) then
                        xyy_select_character_panel:SetVisible(false) 
                    end
                    for i = 1, #store_panel_btn_table do
                        core:remove_listener(gst.lib_getRecordObjLisName(store_panel_btn_table[i]))
                        gst.UI_Component_destroy(gst.lib_getRecordObj(store_panel_btn_table[i]))
                    end
                    store_panel_btn_table = {}
                    gst.UI_Component_destroy(xyy_select_character_panel)
                    xyy_select_character_panel = nil
                    static_id = static_id + 1;
                    UI_MOD_NAME = "playerStore_byHy"..static_id
                    gst.lib_remove_value_from_list(xyy_character_up_pool, character_key)
                    gst.lib_remove_value_from_list(character_browser_list, character_key)
                    gst.lib_table_insert(selected_2p, character_key)
                    character_browser_multiplayer_2p_1()
                end
            elseif cm:get_saved_value("time") == "2p_2" then
                if #selected_2p < 4 then
                    remove_all_character_listener()
                    if(xyy_select_character_panel ~= nil) then
                        xyy_select_character_panel:SetVisible(false) 
                    end
                    for i = 1, #store_panel_btn_table do
                        core:remove_listener(gst.lib_getRecordObjLisName(store_panel_btn_table[i]))
                        gst.UI_Component_destroy(gst.lib_getRecordObj(store_panel_btn_table[i]))
                    end
                    store_panel_btn_table = {}
                    gst.UI_Component_destroy(xyy_select_character_panel)
                    xyy_select_character_panel = nil
                    static_id = static_id + 1;
                    UI_MOD_NAME = "playerStore_byHy"..static_id
                    gst.lib_remove_value_from_list(character_browser_list, character_key)
                    gst.lib_table_insert(selected_2p, character_key)
                    character_browser_multiplayer_2p_2()
                end
            elseif cm:get_saved_value("time") == "2p_3" then
                if #selected_2p < 7 then
                    remove_all_character_listener()
                    if(xyy_select_character_panel ~= nil) then
                        xyy_select_character_panel:SetVisible(false) 
                    end
                    for i = 1, #store_panel_btn_table do
                        core:remove_listener(gst.lib_getRecordObjLisName(store_panel_btn_table[i]))
                        gst.UI_Component_destroy(gst.lib_getRecordObj(store_panel_btn_table[i]))
                    end
                    store_panel_btn_table = {}
                    gst.UI_Component_destroy(xyy_select_character_panel)
                    xyy_select_character_panel = nil
                    static_id = static_id + 1;
                    UI_MOD_NAME = "playerStore_byHy"..static_id
                    gst.lib_remove_value_from_list(character_browser_list, character_key)
                    gst.lib_table_insert(selected_2p, character_key)
                    character_browser_multiplayer_2p_3()
                end
            elseif cm:get_saved_value("time") == "2p_4" then
                if #selected_2p < 9 then
                    remove_all_character_listener()
                    if(xyy_select_character_panel ~= nil) then
                        xyy_select_character_panel:SetVisible(false) 
                    end
                    for i = 1, #store_panel_btn_table do
                        core:remove_listener(gst.lib_getRecordObjLisName(store_panel_btn_table[i]))
                        gst.UI_Component_destroy(gst.lib_getRecordObj(store_panel_btn_table[i]))
                    end
                    store_panel_btn_table = {}
                    gst.UI_Component_destroy(xyy_select_character_panel)
                    xyy_select_character_panel = nil
                    static_id = static_id + 1;
                    UI_MOD_NAME = "playerStore_byHy"..static_id
                    gst.lib_remove_value_from_list(character_browser_list, character_key)
                    gst.lib_table_insert(selected_2p, character_key)
                    character_browser_multiplayer_2p_4()
                end
            end
        end,
        false
    )
end

function add_character_button_2p(parent, slot_icon_size, slot_icon, slot_label, character_key)
    --ModLog('创建了按钮'..character_key)
    local bt_name = UI_MOD_NAME .. "_xyy_select_character_panel_" .. static_id .. character_key;
    local btn_listener_name = bt_name .. "_click_up"
    local bt
    if character_key == "hlyjdj" and not has_firefly_unlocked then
        bt = core:get_or_create_component(bt_name, "ui/templates/3k_btn_large_invalid")
    elseif character_key == "hlyjdw" and not has_tingyun_unlocked then
        bt = core:get_or_create_component(bt_name, "ui/templates/3k_btn_large_invalid")
    elseif character_key == "hlyjdv" and not has_miyabi_unlocked then
        bt = core:get_or_create_component(bt_name, "ui/templates/3k_btn_large_invalid")
    --菲比暂时不可用
    elseif character_key == "hlyjeb" and not has_cantarella_unlocked then
        bt = core:get_or_create_component(bt_name, "ui/templates/3k_btn_large_invalid")
    else
        if cm:query_local_faction(true):name() == cm:get_saved_value("xyy_2p") then
            bt = core:get_or_create_component(bt_name, "ui/templates/button_mp/3k_btn_large_" .. character_key)
        else
            bt = core:get_or_create_component(bt_name, "ui/templates/3k_btn_large")
        end
    end
    -- local character = cm:query_model():character_for_template(character_key);
    parent:Adopt(bt:Address())
    bt:PropagatePriority(parent:Priority())
    gst.UI_Component_resize(bt, slot_icon_size, slot_icon_size, true)
    bt:SetImagePath(slot_icon);
    if character_key == "hlyjdj" and not has_firefly_unlocked then
        bt:SetImagePath("ui/skins/default/character_browser/hlyjdj_.png");
    elseif character_key == "hlyjdw" and not has_tingyun_unlocked then
        bt:SetImagePath("ui/skins/default/character_browser/hlyjdw_.png");
    elseif character_key == "hlyjdv" and not has_miyabi_unlocked then
        bt:SetImagePath("ui/skins/default/character_browser/hlyjdv_.png");
    --菲比暂时不可用
    elseif character_key == "hlyjeb" and not has_cantarella_unlocked then
        bt:SetImagePath("ui/skins/default/character_browser/hlyjea_.png");
    end
    bt:SetTooltipText(slot_label, true);
    
    gst.lib_recordObj(bt, btn_listener_name,  store_panel_btn_table);
    return bt;
end


--确认按钮: 玩家2
function add_confirm_button_2p(parent, x, y)
    local bt_name = UI_MOD_NAME .. "_xyy_select_character_panel_confirm";
    local btn_listener_name = bt_name .. "_click_up"
    local bt = core:get_or_create_component(bt_name, "ui/templates/button_mp/confirm_button_2p")
    -- local character = cm:query_model():character_for_template(character_key);
    parent:Adopt(bt:Address())
    bt:PropagatePriority(parent:Priority())
    gst.UI_Component_resize(bt, x, y, true)
    bt:SetTooltipText(effect.get_localised_string(effect.get_localised_string("mod_xyy_character_browser_confirm_tooltip")), true)
    
    core:add_listener(
        btn_listener_name,
        "ModelScriptNotificationEvent",
        function(model_script_notification_event)
            return model_script_notification_event:event_id() == "confirm_button_2p"
        end,
        function(model_script_notification_event)
            ModLog("add_confirm_button_2p: ".. model_script_notification_event:event_id())
            if cm:get_saved_value("time") == "2p_1" then
                if #selected_2p == 2 then
                    if(xyy_select_character_panel ~= nil) then
                        xyy_select_character_panel:SetVisible(false) 
                    end
                    for i = 1, #store_panel_btn_table do
                        core:remove_listener(gst.lib_getRecordObjLisName(store_panel_btn_table[i]))
                        gst.UI_Component_destroy(gst.lib_getRecordObj(store_panel_btn_table[i]))
                    end
                    store_panel_btn_table = {}
                    gst.UI_Component_destroy(xyy_select_character_panel)
                    xyy_select_character_panel = nil
                    static_id = static_id + 1;
                    UI_MOD_NAME = "playerStore_byHy"..static_id
                    character_browser_multiplayer_1p_2()
                end
            elseif cm:get_saved_value("time") == "2p_2" then
                if #selected_2p == 4 then
                    if(xyy_select_character_panel ~= nil) then
                        xyy_select_character_panel:SetVisible(false) 
                    end
                    for i = 1, #store_panel_btn_table do
                        core:remove_listener(gst.lib_getRecordObjLisName(store_panel_btn_table[i]))
                        gst.UI_Component_destroy(gst.lib_getRecordObj(store_panel_btn_table[i]))
                    end
                    store_panel_btn_table = {}
                    gst.UI_Component_destroy(xyy_select_character_panel)
                    xyy_select_character_panel = nil
                    static_id = static_id + 1;
                    UI_MOD_NAME = "playerStore_byHy"..static_id
                    character_browser_multiplayer_1p_3()
                end
            elseif cm:get_saved_value("time") == "2p_3" then
                if #selected_2p == 7 then
                    if(xyy_select_character_panel ~= nil) then
                        xyy_select_character_panel:SetVisible(false) 
                    end
                    for i = 1, #store_panel_btn_table do
                        core:remove_listener(gst.lib_getRecordObjLisName(store_panel_btn_table[i]))
                        gst.UI_Component_destroy(gst.lib_getRecordObj(store_panel_btn_table[i]))
                    end
                    store_panel_btn_table = {}
                    gst.UI_Component_destroy(xyy_select_character_panel)
                    xyy_select_character_panel = nil
                    static_id = static_id + 1;
                    UI_MOD_NAME = "playerStore_byHy"..static_id
                    character_browser_multiplayer_1p_4()
                end
            elseif cm:get_saved_value("time") == "2p_4" then
                if #selected_2p == 9 then
                    if(xyy_select_character_panel ~= nil) then
                        xyy_select_character_panel:SetVisible(false) 
                    end
                    for i = 1, #store_panel_btn_table do
                        core:remove_listener(gst.lib_getRecordObjLisName(store_panel_btn_table[i]))
                        gst.UI_Component_destroy(gst.lib_getRecordObj(store_panel_btn_table[i]))
                    end
                    store_panel_btn_table = {}
                    gst.UI_Component_destroy(xyy_select_character_panel)
                    xyy_select_character_panel = nil
                    static_id = static_id + 1;
                    UI_MOD_NAME = "playerStore_byHy"..static_id
                    save_value()
                    cm:set_saved_value("selected_up_character", true)
                    cm:set_saved_value("xyy_store_ready", true)
                    cm:set_saved_value("enabled_character_pool", true)
                    cm:set_saved_value("time", false)
                    add_menu_button();
                    cm:modify_model():get_modify_episodic_scripting():autosave_at_next_opportunity();
                    CampaignUI.CreateModelCallbackRequest("xyy_callback_steal_escape_key_false");
                    refresh_menu_button_notification()
                    if cm:is_player_turn() then
                        menu_button:SetState("active")
                    end
                end
            end
            
        end,
        false
    )
    gst.lib_recordObj(bt, btn_listener_name,  store_panel_btn_table);
    return bt;
end

function add_page_button_1p(parent, x, y, next_or_previous)
    local bt_name 
    if next_or_previous then
        bt_name = UI_MOD_NAME .. "_xyy_select_character_panel_page_next";
    else
        bt_name = UI_MOD_NAME .. "_xyy_select_character_panel_page_previous";
    end
    local btn_listener_name = bt_name .. "_click_up"
    local bt = core:get_or_create_component(bt_name, "ui/templates/square_large_text_button")
    -- local character = cm:query_model():character_for_template(character_key);
    parent:Adopt(bt:Address())
    bt:PropagatePriority(parent:Priority())
    gst.UI_Component_resize(bt, x, y, true)
    if next_or_previous then
        bt:SetTooltipText(effect.get_localised_string("mod_xyy_character_browser_next_page_tooltip"), true)
    else
        bt:SetTooltipText(effect.get_localised_string("mod_xyy_character_browser_previous_page_tooltip"), true)
    end
    core:add_listener(
        btn_listener_name,
        "ComponentLClickUp",
        function(context)
            return bt == UIComponent(context.component) and context:can_request_model_callback()
        end,
        function(context)
            if next_or_previous then
                page = page + 2;
            else
                page = page - 2;
                if page < 0 then
                    page = 0;
                end
            end
            if(xyy_select_character_panel ~= nil) then
                xyy_select_character_panel:SetVisible(false) 
            end
            for i = 1, #store_panel_btn_table do
                core:remove_listener(gst.lib_getRecordObjLisName(store_panel_btn_table[i]))
                gst.UI_Component_destroy(gst.lib_getRecordObj(store_panel_btn_table[i]))
            end
            store_panel_btn_table = {}
            gst.UI_Component_destroy(xyy_select_character_panel)
            xyy_select_character_panel = nil
            static_id = static_id + 1;
            UI_MOD_NAME = "playerStore_byHy"..static_id
            ModLog( UI_MOD_NAME )
            if cm:get_saved_value("time") == "1p_1" then
                character_browser_multiplayer_1p_1()
            end
            if cm:get_saved_value("time") == "1p_2" then
                character_browser_multiplayer_1p_2()
            end
            if cm:get_saved_value("time") == "1p_3" then
                character_browser_multiplayer_1p_3()
            end
            if cm:get_saved_value("time") == "1p_4" then
                character_browser_multiplayer_1p_4()
            end
            if cm:get_saved_value("time") == "2p_1" then
                character_browser_multiplayer_2p_1()
            end
            if cm:get_saved_value("time") == "2p_2" then
                character_browser_multiplayer_2p_2()
            end
            if cm:get_saved_value("time") == "2p_3" then
                character_browser_multiplayer_2p_3()
            end
            if cm:get_saved_value("time") == "2p_4" then
                character_browser_multiplayer_2p_4()
            end
        end,
        false
    )
    gst.lib_recordObj(bt, btn_listener_name,  store_panel_btn_table);
    return bt;
end

function add_page_button_2p(parent, x, y, next_or_previous)
    local bt_name 
    if next_or_previous then
        bt_name = UI_MOD_NAME .. "_xyy_select_character_panel_page_next";
    else
        bt_name = UI_MOD_NAME .. "_xyy_select_character_panel_page_previous";
    end
    local btn_listener_name = bt_name .. "_click_up"
    local bt = core:get_or_create_component(bt_name, "ui/templates/square_large_text_button")
    -- local character = cm:query_model():character_for_template(character_key);
    parent:Adopt(bt:Address())
    bt:PropagatePriority(parent:Priority())
    gst.UI_Component_resize(bt, x, y, true)
    if next_or_previous then
        bt:SetTooltipText(effect.get_localised_string("mod_xyy_character_browser_next_page_tooltip"), true)
    else
        bt:SetTooltipText(effect.get_localised_string("mod_xyy_character_browser_previous_page_tooltip"), true)
    end
    core:add_listener(
        btn_listener_name,
        "ComponentLClickUp",
        function(context)
            return bt == UIComponent(context.component) and context:can_request_model_callback()
        end,
        function(context)
            if next_or_previous then
                page = page + 2;
            else
                page = page - 2;
                if page < 0 then
                    page = 0;
                end
            end
            if(xyy_select_character_panel ~= nil) then
                xyy_select_character_panel:SetVisible(false) 
            end
            for i = 1, #store_panel_btn_table do
                core:remove_listener(gst.lib_getRecordObjLisName(store_panel_btn_table[i]))
                gst.UI_Component_destroy(gst.lib_getRecordObj(store_panel_btn_table[i]))
            end
            store_panel_btn_table = {}
            gst.UI_Component_destroy(xyy_select_character_panel)
            xyy_select_character_panel = nil
            static_id = static_id + 1;
            UI_MOD_NAME = "playerStore_byHy"..static_id
            ModLog( UI_MOD_NAME )
            if cm:get_saved_value("time") == "1p_1" then
                character_browser_multiplayer_1p_1()
            end
            if cm:get_saved_value("time") == "1p_2" then
                character_browser_multiplayer_1p_2()
            end
            if cm:get_saved_value("time") == "1p_3" then
                character_browser_multiplayer_1p_3()
            end
            if cm:get_saved_value("time") == "1p_4" then
                character_browser_multiplayer_1p_4()
            end
            if cm:get_saved_value("time") == "2p_1" then
                character_browser_multiplayer_2p_1()
            end
            if cm:get_saved_value("time") == "2p_2" then
                character_browser_multiplayer_2p_2()
            end
            if cm:get_saved_value("time") == "2p_3" then
                character_browser_multiplayer_2p_3()
            end
            if cm:get_saved_value("time") == "2p_4" then
                character_browser_multiplayer_2p_4()
            end
        end,
        false
    )
    gst.lib_recordObj(bt, btn_listener_name,  store_panel_btn_table);
    return bt;
end

--主面板
function character_browser_multiplayer_1p_1()
    remove_all_character_listener()
    -- 选择up角色的槽位
    local ui_root = core:get_ui_root()
    local ui_panel_name = UI_MOD_NAME .. "_xyy_select_character_panel" .. static_id;
    xyy_select_character_panel = core:get_or_create_component( ui_panel_name, "ui/xyy/character_browser_1") --date.pack中自带的panel_frame.twui.xml布局文件
    ui_root:Adopt( xyy_select_character_panel:Address() )
    xyy_select_character_panel:PropagatePriority(ui_root:Priority())
    
    if cm:query_local_faction(true):name() == cm:get_saved_value("xyy_1p") then
        find_uicomponent(xyy_select_character_panel, "faction_council_header"):SetStateText(effect.get_localised_string("mod_xyy_character_select_1"))
    else
        find_uicomponent(xyy_select_character_panel, "faction_council_header"):SetStateText(effect.get_localised_string("mod_xyy_character_select_1_non_playable"))
    end
    
    cm:set_saved_value("character_browser_multiplayer_1p", 1)
    cm:set_saved_value("time", "1p_1")
    
    local xoffset = 295;
    local yoffset = 250;
    
    if selected_1p[1] then
        local slot4 = add_character_pool_1p(xyy_select_character_panel, 130, "ui/skins/default/character_browser/".. selected_1p[1] ..".png", effect.get_localised_string("mod_xyy_character_browser_".. selected_1p[1]), selected_1p[1], false, true)
        gst.UI_Component_move_relative(slot4, xyy_select_character_panel, xoffset+150*4, yoffset, false)
    else
        local slot4 = add_character_pool_1p(xyy_select_character_panel, 130, "ui/skins/default/character_browser/placeholder.png", effect.get_localised_string("mod_xyy_character_browser_unknown"), "unknown", false, false)
        gst.UI_Component_move_relative(slot4, xyy_select_character_panel, xoffset+150*4, yoffset, false)
    end
    
    for k,v in ipairs(xyy_character_up_pool) do
        add_1p_character_button_listener(v)
    end

    local has_next_page = false;
    
    for i=1,#xyy_character_up_pool do
        local index_x = ((i-1)%11);
        local index_y = math.floor((i-1)/11) - page;
        
        if index_y >= 2 then
            has_next_page = true
            break;
        elseif index_y >= 0 then
            local x = 310+120*index_x;
            local y = 450+120*index_y;
            
            --ModLog(x..","..y);
            local slot = add_character_button_1p(xyy_select_character_panel, 100, "ui/skins/default/character_browser/".. xyy_character_up_pool[i] ..".png", effect.get_localised_string("mod_xyy_character_browser_".. xyy_character_up_pool[i]), xyy_character_up_pool[i])
            gst.UI_Component_move_relative(slot, xyy_select_character_panel, x, y, false)
        end
    end
    local confirm_button = add_confirm_button_1p(xyy_select_character_panel, 800, 50)
    gst.UI_Component_move_relative(confirm_button, xyy_select_character_panel, 560, 720, false)
    
    confirm_button:SetState( "down" )
    find_uicomponent(confirm_button, "button_txt"):SetStateText(effect.get_localised_string("mod_xyy_character_browser_confirm"))
    
    if cm:query_local_faction(true):name() == cm:get_saved_value("xyy_1p") then
        if #selected_1p == 1 then
            confirm_button:SetState( "active" )
            find_uicomponent(confirm_button, "button_txt"):SetStateText(effect.get_localised_string("mod_xyy_character_browser_confirm"))
        else
            confirm_button:SetState( "inactive" )
            find_uicomponent(confirm_button, "button_txt"):SetStateText(effect.get_localised_string("mod_xyy_character_browser_confirm"))
        end
    else
        confirm_button:SetState( "inactive" )
        find_uicomponent(confirm_button, "button_txt"):SetStateText(effect.get_localised_string("mod_xyy_character_browser_wait"))
    end
    if has_next_page then
        local next_page =  add_page_button_1p(xyy_select_character_panel, 50, 50, true)
        gst.UI_Component_move_relative(next_page, xyy_select_character_panel, 1380, 720, false)
        next_page:SetState( "down" )
        find_uicomponent(next_page, "button_txt"):SetStateText(">>")
        next_page:SetState( "active" )
        find_uicomponent(next_page, "button_txt"):SetStateText(">>")
    end
    if page > 0 then
        local previous_page =  add_page_button_1p(xyy_select_character_panel, 50, 50, false)
        gst.UI_Component_move_relative(previous_page, xyy_select_character_panel, 490, 720, false)
        previous_page:SetState( "down" )
        find_uicomponent(previous_page, "button_txt"):SetStateText("<<")
        previous_page:SetState( "active" )
        find_uicomponent(previous_page, "button_txt"):SetStateText("<<")
    end
    xyy_select_character_panel:SetVisible(true) 
    CampaignUI.CreateModelCallbackRequest("xyy_callback_steal_escape_key_true");
end

function character_browser_multiplayer_2p_1()
    remove_all_character_listener()
    local ui_root = core:get_ui_root()
    local ui_panel_name = UI_MOD_NAME .. "_xyy_select_character_panel" .. static_id;
    xyy_select_character_panel = core:get_or_create_component( ui_panel_name, "ui/xyy/character_browser_1")
    ui_root:Adopt( xyy_select_character_panel:Address() )
    xyy_select_character_panel:PropagatePriority(ui_root:Priority())
    if cm:query_local_faction(true):name() == cm:get_saved_value("xyy_2p") then
        find_uicomponent(xyy_select_character_panel, "faction_council_header"):SetStateText(effect.get_localised_string("mod_xyy_character_select_1"))
    else
        find_uicomponent(xyy_select_character_panel, "faction_council_header"):SetStateText(effect.get_localised_string("mod_xyy_character_select_1_non_playable"))
    end
    cm:set_saved_value("character_browser_multiplayer_2p", 1)
    cm:set_saved_value("time", "2p_1")
    
    local xoffset = 295;
    local yoffset = 250;
    
    if selected_2p[1] then
        local slot4 = add_character_pool_2p(xyy_select_character_panel, 130, "ui/skins/default/character_browser/".. selected_2p[1] ..".png", effect.get_localised_string("mod_xyy_character_browser_".. selected_2p[1]), selected_2p[1], false, true)
        gst.UI_Component_move_relative(slot4, xyy_select_character_panel, xoffset+150*3.5, yoffset, false)
    else
        local slot4 = add_character_pool_2p(xyy_select_character_panel, 130, "ui/skins/default/character_browser/placeholder.png", effect.get_localised_string("mod_xyy_character_browser_unknown"), "unknown", false, false)
        gst.UI_Component_move_relative(slot4, xyy_select_character_panel, xoffset+150*3.5, yoffset, false)
    end
    if selected_2p[2] then
        local slot6 = add_character_pool_2p(xyy_select_character_panel, 130, "ui/skins/default/character_browser/".. selected_2p[2] ..".png", effect.get_localised_string("mod_xyy_character_browser_".. selected_2p[2]), selected_2p[2], false, true)
        gst.UI_Component_move_relative(slot6, xyy_select_character_panel, xoffset+150*4.5, yoffset, false)
    else
        local slot6 = add_character_pool_2p(xyy_select_character_panel, 130, "ui/skins/default/character_browser/placeholder.png", effect.get_localised_string("mod_xyy_character_browser_unknown"), "unknown", false, false)
        gst.UI_Component_move_relative(slot6, xyy_select_character_panel, xoffset+150*4.5, yoffset, false)
    end
    
    for k,v in ipairs(xyy_character_up_pool) do
        add_2p_character_button_listener(v)
    end
    
    local has_next_page = false;
    for i=1,#xyy_character_up_pool do
        local index_x = ((i-1)%11);
        local index_y = math.floor((i-1)/11) - page;
        
        if index_y >= 2 then
            has_next_page = true
            break;
        elseif index_y >= 0 then
            local x = 310+120*index_x;
            local y = 450+120*index_y;
            
            --ModLog(x..","..y);
            local slot = add_character_button_2p(xyy_select_character_panel, 100, "ui/skins/default/character_browser/".. xyy_character_up_pool[i] ..".png", effect.get_localised_string("mod_xyy_character_browser_".. xyy_character_up_pool[i]), xyy_character_up_pool[i])
            gst.UI_Component_move_relative(slot, xyy_select_character_panel, x, y, false)
        end
    end
    local confirm_button = add_confirm_button_2p(xyy_select_character_panel, 800, 50)
    gst.UI_Component_move_relative(confirm_button, xyy_select_character_panel, 560, 720, false)
    confirm_button:SetState( "down" )
    find_uicomponent(confirm_button, "button_txt"):SetStateText(effect.get_localised_string("mod_xyy_character_browser_confirm"))
    if cm:query_local_faction(true):name() == cm:get_saved_value("xyy_2p") then 
        if #selected_2p == 2 then
            confirm_button:SetState( "active" )
            find_uicomponent(confirm_button, "button_txt"):SetStateText(effect.get_localised_string("mod_xyy_character_browser_confirm"))
        else
            confirm_button:SetState( "inactive" )
            find_uicomponent(confirm_button, "button_txt"):SetStateText(effect.get_localised_string("mod_xyy_character_browser_confirm"))
        end
    else
        confirm_button:SetState( "inactive" )
        find_uicomponent(confirm_button, "button_txt"):SetStateText(effect.get_localised_string("mod_xyy_character_browser_wait"))
    end
    if has_next_page then
        local next_page =  add_page_button_2p(xyy_select_character_panel, 50, 50, true)
        gst.UI_Component_move_relative(next_page, xyy_select_character_panel, 1380, 720, false)
        next_page:SetState( "down" )
        find_uicomponent(next_page, "button_txt"):SetStateText(">>")
        next_page:SetState( "active" )
        find_uicomponent(next_page, "button_txt"):SetStateText(">>")
    end
    if page > 0 then
        local previous_page =  add_page_button_2p(xyy_select_character_panel, 50, 50, false)
        gst.UI_Component_move_relative(previous_page, xyy_select_character_panel, 490, 720, false)
        previous_page:SetState( "down" )
        find_uicomponent(previous_page, "button_txt"):SetStateText("<<")
        previous_page:SetState( "active" )
        find_uicomponent(previous_page, "button_txt"):SetStateText("<<")
    end
    xyy_select_character_panel:SetVisible(true) 
    CampaignUI.CreateModelCallbackRequest("xyy_callback_steal_escape_key_true");
end

function character_browser_multiplayer_1p_2()
    remove_all_character_listener()
    -- 选择up角色的槽位
    local ui_root = core:get_ui_root()
    local ui_panel_name = UI_MOD_NAME .. "_xyy_select_character_panel" .. static_id;
    xyy_select_character_panel = core:get_or_create_component( ui_panel_name, "ui/xyy/character_browser_1") --date.pack中自带的panel_frame.twui.xml布局文件
    ui_root:Adopt( xyy_select_character_panel:Address() )
    xyy_select_character_panel:PropagatePriority(ui_root:Priority())
    
    if cm:query_local_faction(true):name() == cm:get_saved_value("xyy_1p") then
        find_uicomponent(xyy_select_character_panel, "faction_council_header"):SetStateText(effect.get_localised_string("mod_xyy_character_select_2"))
    else
        find_uicomponent(xyy_select_character_panel, "faction_council_header"):SetStateText(effect.get_localised_string("mod_xyy_character_select_2_non_playable"))
    end
    
    cm:set_saved_value("character_browser_multiplayer_1p", 2)
    cm:set_saved_value("time", "1p_2")
    
    local xoffset = 295;
    local yoffset = 250;
    
    local slot3 = add_character_pool_1p(xyy_select_character_panel, 130, "ui/skins/default/character_browser/".. selected_1p[1] ..".png", effect.get_localised_string("mod_xyy_character_browser_".. selected_1p[1]), selected_1p[1], false, false)
    gst.UI_Component_move_relative(slot3, xyy_select_character_panel, xoffset+150*3, yoffset, false)
    
    if selected_1p[2] then
        local slot4 = add_character_pool_1p(xyy_select_character_panel, 130, "ui/skins/default/character_browser/".. selected_1p[2] ..".png", effect.get_localised_string("mod_xyy_character_browser_".. selected_1p[2]), selected_1p[2], false, true)
        gst.UI_Component_move_relative(slot4, xyy_select_character_panel, xoffset+150*4, yoffset, false)
    else
        local slot4 = add_character_pool_1p(xyy_select_character_panel, 130, "ui/skins/default/character_browser/placeholder.png", effect.get_localised_string("mod_xyy_character_browser_unknown"), "unknown", false, false)
        gst.UI_Component_move_relative(slot4, xyy_select_character_panel, xoffset+150*4, yoffset, false)
    end

    if selected_1p[3] then
        local slot5 = add_character_pool_1p(xyy_select_character_panel, 130, "ui/skins/default/character_browser/".. selected_1p[3] ..".png", effect.get_localised_string("mod_xyy_character_browser_".. selected_1p[3]), selected_1p[3], false, true)
        gst.UI_Component_move_relative(slot5, xyy_select_character_panel, xoffset+150*5, yoffset, false)
    else
        local slot5 = add_character_pool_1p(xyy_select_character_panel, 130, "ui/skins/default/character_browser/placeholder.png", effect.get_localised_string("mod_xyy_character_browser_unknown"), "unknown", false, false)
        gst.UI_Component_move_relative(slot5, xyy_select_character_panel, xoffset+150*5, yoffset, false)
    end
    
    for k,v in ipairs(character_browser_list) do
        add_1p_character_button_listener(v)
    end
    
    local has_next_page = false;
    
    for i=1,#character_browser_list do
        local index_x = ((i-1)%11);
        local index_y = math.floor((i-1)/11) - page;
        
        if index_y >= 2 then
            has_next_page = true
            break;
        elseif index_y >= 0 then
            local x = 310+120*index_x;
            local y = 450+120*index_y;
            
            --ModLog(x..","..y);
            local slot = add_character_button_1p(xyy_select_character_panel, 100, "ui/skins/default/character_browser/".. character_browser_list[i] ..".png", effect.get_localised_string("mod_xyy_character_browser_".. character_browser_list[i]), character_browser_list[i])
            gst.UI_Component_move_relative(slot, xyy_select_character_panel, x, y, false)
        end
    end
    local confirm_button = add_confirm_button_1p(xyy_select_character_panel, 800, 50)
    gst.UI_Component_move_relative(confirm_button, xyy_select_character_panel, 560, 720, false)
    
    confirm_button:SetState( "down" )
    find_uicomponent(confirm_button, "button_txt"):SetStateText(effect.get_localised_string("mod_xyy_character_browser_confirm"))
    
    if cm:query_local_faction(true):name() == cm:get_saved_value("xyy_1p") then
        if #selected_1p == 3 then
            confirm_button:SetState( "active" )
            find_uicomponent(confirm_button, "button_txt"):SetStateText(effect.get_localised_string("mod_xyy_character_browser_confirm"))
        else
            confirm_button:SetState( "inactive" )
            find_uicomponent(confirm_button, "button_txt"):SetStateText(effect.get_localised_string("mod_xyy_character_browser_confirm"))
        end
    else
        confirm_button:SetState( "inactive" )
        find_uicomponent(confirm_button, "button_txt"):SetStateText(effect.get_localised_string("mod_xyy_character_browser_wait"))
    end
    if has_next_page then
        local next_page =  add_page_button_1p(xyy_select_character_panel, 50, 50, true)
        gst.UI_Component_move_relative(next_page, xyy_select_character_panel, 1380, 720, false)
        next_page:SetState( "down" )
        find_uicomponent(next_page, "button_txt"):SetStateText(">>")
        next_page:SetState( "active" )
        find_uicomponent(next_page, "button_txt"):SetStateText(">>")
    end
    if page > 0 then
        local previous_page =  add_page_button_1p(xyy_select_character_panel, 50, 50, false)
        gst.UI_Component_move_relative(previous_page, xyy_select_character_panel, 490, 720, false)
        previous_page:SetState( "down" )
        find_uicomponent(previous_page, "button_txt"):SetStateText("<<")
        previous_page:SetState( "active" )
        find_uicomponent(previous_page, "button_txt"):SetStateText("<<")
    end
    xyy_select_character_panel:SetVisible(true) 
    CampaignUI.CreateModelCallbackRequest("xyy_callback_steal_escape_key_true");
end

function character_browser_multiplayer_2p_2()
    remove_all_character_listener()
    local ui_root = core:get_ui_root()
    local ui_panel_name = UI_MOD_NAME .. "_xyy_select_character_panel" .. static_id;
    xyy_select_character_panel = core:get_or_create_component( ui_panel_name, "ui/xyy/character_browser_1")
    ui_root:Adopt( xyy_select_character_panel:Address() )
    xyy_select_character_panel:PropagatePriority(ui_root:Priority())
    if cm:query_local_faction(true):name() == cm:get_saved_value("xyy_2p") then
        find_uicomponent(xyy_select_character_panel, "faction_council_header"):SetStateText(effect.get_localised_string("mod_xyy_character_select_2"))
    else
        find_uicomponent(xyy_select_character_panel, "faction_council_header"):SetStateText(effect.get_localised_string("mod_xyy_character_select_2_non_playable"))
    end
    cm:set_saved_value("character_browser_multiplayer_2p", 2)
    cm:set_saved_value("time", "2p_2")
    
    local xoffset = 295;
    local yoffset = 250;
    
    local slot2 = add_character_pool_2p(xyy_select_character_panel, 130, "ui/skins/default/character_browser/".. selected_2p[1] ..".png", effect.get_localised_string("mod_xyy_character_browser_".. selected_2p[1]), selected_2p[1], false, false)
    gst.UI_Component_move_relative(slot2, xyy_select_character_panel, xoffset+150*2.5, yoffset, false)
        
    local slot3 = add_character_pool_2p(xyy_select_character_panel, 130, "ui/skins/default/character_browser/".. selected_2p[2] ..".png", effect.get_localised_string("mod_xyy_character_browser_".. selected_2p[2]), selected_2p[2], false, false)
    gst.UI_Component_move_relative(slot3, xyy_select_character_panel, xoffset+150*3.5, yoffset, false)
        
    if selected_2p[3] then
        local slot4 = add_character_pool_2p(xyy_select_character_panel, 130, "ui/skins/default/character_browser/".. selected_2p[3] ..".png", effect.get_localised_string("mod_xyy_character_browser_".. selected_2p[3]), selected_2p[3], false, true)
        gst.UI_Component_move_relative(slot4, xyy_select_character_panel, xoffset+150*4.5, yoffset, false)
    else
        local slot4 = add_character_pool_2p(xyy_select_character_panel, 130, "ui/skins/default/character_browser/placeholder.png", effect.get_localised_string("mod_xyy_character_browser_unknown"), "unknown", false, false)
        gst.UI_Component_move_relative(slot4, xyy_select_character_panel, xoffset+150*4.5, yoffset, false)
    end
    if selected_2p[4] then
        local slot5 = add_character_pool_2p(xyy_select_character_panel, 130, "ui/skins/default/character_browser/".. selected_2p[4] ..".png", effect.get_localised_string("mod_xyy_character_browser_".. selected_2p[4]), selected_2p[4], false, true)
        gst.UI_Component_move_relative(slot5, xyy_select_character_panel, xoffset+150*5.5, yoffset, false)
    else
        local slot5 = add_character_pool_2p(xyy_select_character_panel, 130, "ui/skins/default/character_browser/placeholder.png", effect.get_localised_string("mod_xyy_character_browser_unknown"), "unknown", false, false)
        gst.UI_Component_move_relative(slot5, xyy_select_character_panel, xoffset+150*5.5, yoffset, false)
    end
    
    for k,v in ipairs(character_browser_list) do
        add_2p_character_button_listener(v)
    end
    
    local has_next_page = false;
    for i=1,#character_browser_list do
        local index_x = ((i-1)%11);
        local index_y = math.floor((i-1)/11) - page;
        
        if index_y >= 2 then
            has_next_page = true
            break;
        elseif index_y >= 0 then
            local x = 310+120*index_x;
            local y = 450+120*index_y;
            
            --ModLog(x..","..y);
            local slot = add_character_button_2p(xyy_select_character_panel, 100, "ui/skins/default/character_browser/".. character_browser_list[i] ..".png", effect.get_localised_string("mod_xyy_character_browser_".. character_browser_list[i]), character_browser_list[i])
            gst.UI_Component_move_relative(slot, xyy_select_character_panel, x, y, false)
        end
    end
    local confirm_button = add_confirm_button_2p(xyy_select_character_panel, 800, 50)
    gst.UI_Component_move_relative(confirm_button, xyy_select_character_panel, 560, 720, false)
    confirm_button:SetState( "down" )
    find_uicomponent(confirm_button, "button_txt"):SetStateText(effect.get_localised_string("mod_xyy_character_browser_confirm"))
    if cm:query_local_faction(true):name() == cm:get_saved_value("xyy_2p") then
        if #selected_2p == 4 then
            confirm_button:SetState( "active" )
            find_uicomponent(confirm_button, "button_txt"):SetStateText(effect.get_localised_string("mod_xyy_character_browser_confirm"))
        else
            confirm_button:SetState( "inactive" )
            find_uicomponent(confirm_button, "button_txt"):SetStateText(effect.get_localised_string("mod_xyy_character_browser_confirm"))
        end
    else
        confirm_button:SetState( "inactive" )
        find_uicomponent(confirm_button, "button_txt"):SetStateText(effect.get_localised_string("mod_xyy_character_browser_wait"))
    end
    if has_next_page then
        local next_page =  add_page_button_2p(xyy_select_character_panel, 50, 50, true)
        gst.UI_Component_move_relative(next_page, xyy_select_character_panel, 1380, 720, false)
        next_page:SetState( "down" )
        find_uicomponent(next_page, "button_txt"):SetStateText(">>")
        next_page:SetState( "active" )
        find_uicomponent(next_page, "button_txt"):SetStateText(">>")
    end
    if page > 0 then
        local previous_page =  add_page_button_2p(xyy_select_character_panel, 50, 50, false)
        gst.UI_Component_move_relative(previous_page, xyy_select_character_panel, 490, 720, false)
        previous_page:SetState( "down" )
        find_uicomponent(previous_page, "button_txt"):SetStateText("<<")
        previous_page:SetState( "active" )
        find_uicomponent(previous_page, "button_txt"):SetStateText("<<")
    end
    xyy_select_character_panel:SetVisible(true) 
    CampaignUI.CreateModelCallbackRequest("xyy_callback_steal_escape_key_true");
end

function character_browser_multiplayer_1p_3()
    remove_all_character_listener()
    -- 选择up角色的槽位
    local ui_root = core:get_ui_root()
    local ui_panel_name = UI_MOD_NAME .. "_xyy_select_character_panel" .. static_id;
    xyy_select_character_panel = core:get_or_create_component( ui_panel_name, "ui/xyy/character_browser_1") --date.pack中自带的panel_frame.twui.xml布局文件
    ui_root:Adopt( xyy_select_character_panel:Address() )
    xyy_select_character_panel:PropagatePriority(ui_root:Priority())
    
    if cm:query_local_faction(true):name() == cm:get_saved_value("xyy_1p") then
        find_uicomponent(xyy_select_character_panel, "faction_council_header"):SetStateText(effect.get_localised_string("mod_xyy_character_select_3"))
    else
        find_uicomponent(xyy_select_character_panel, "faction_council_header"):SetStateText(effect.get_localised_string("mod_xyy_character_select_3_non_playable"))
    end
    
    cm:set_saved_value("character_browser_multiplayer_1p", 3)
    cm:set_saved_value("time", "1p_3")
    
    local xoffset = 295;
    local yoffset = 250;
    
    local slot2 = add_character_pool_1p(xyy_select_character_panel, 130, "ui/skins/default/character_browser/".. selected_1p[1] ..".png", effect.get_localised_string("mod_xyy_character_browser_".. selected_1p[1]), selected_1p[1], false, false)
    gst.UI_Component_move_relative(slot2, xyy_select_character_panel, xoffset+150*1.5, yoffset, false)
    
    local slot3 = add_character_pool_1p(xyy_select_character_panel, 130, "ui/skins/default/character_browser/".. selected_1p[2] ..".png", effect.get_localised_string("mod_xyy_character_browser_".. selected_1p[2]), selected_1p[2], false, false)
    gst.UI_Component_move_relative(slot3, xyy_select_character_panel, xoffset+150*2.5, yoffset, false)
    
    local slot4 = add_character_pool_1p(xyy_select_character_panel, 130, "ui/skins/default/character_browser/".. selected_1p[3] ..".png", effect.get_localised_string("mod_xyy_character_browser_".. selected_1p[3]), selected_1p[3], false, false)
    gst.UI_Component_move_relative(slot4, xyy_select_character_panel, xoffset+150*3.5, yoffset, false)
    
    if selected_1p[4] then
        local slot5 = add_character_pool_1p(xyy_select_character_panel, 130, "ui/skins/default/character_browser/".. selected_1p[4] ..".png", effect.get_localised_string("mod_xyy_character_browser_".. selected_1p[4]), selected_1p[4], false, true)
        gst.UI_Component_move_relative(slot5, xyy_select_character_panel, xoffset+150*4.5, yoffset, false)
    else
        local slot5 = add_character_pool_1p(xyy_select_character_panel, 130, "ui/skins/default/character_browser/placeholder.png", effect.get_localised_string("mod_xyy_character_browser_unknown"), "unknown", false, false)
        gst.UI_Component_move_relative(slot5, xyy_select_character_panel, xoffset+150*4.5, yoffset, false)
    end

    if selected_1p[5] then
        local slot6 = add_character_pool_1p(xyy_select_character_panel, 130, "ui/skins/default/character_browser/".. selected_1p[5] ..".png", effect.get_localised_string("mod_xyy_character_browser_".. selected_1p[5]), selected_1p[5], false, true)
        gst.UI_Component_move_relative(slot6, xyy_select_character_panel, xoffset+150*5.5, yoffset, false)
    else
        local slot6 = add_character_pool_1p(xyy_select_character_panel, 130, "ui/skins/default/character_browser/placeholder.png", effect.get_localised_string("mod_xyy_character_browser_unknown"), "unknown", false, false)
        gst.UI_Component_move_relative(slot6, xyy_select_character_panel, xoffset+150*5.5, yoffset, false)
    end

    if selected_1p[6] then
        local slot7 = add_character_pool_1p(xyy_select_character_panel, 130, "ui/skins/default/character_browser/".. selected_1p[6] ..".png", effect.get_localised_string("mod_xyy_character_browser_".. selected_1p[6]), selected_1p[6], false, true)
        gst.UI_Component_move_relative(slot7, xyy_select_character_panel, xoffset+150*6.5, yoffset, false)
    else
        local slot7 = add_character_pool_1p(xyy_select_character_panel, 130, "ui/skins/default/character_browser/placeholder.png", effect.get_localised_string("mod_xyy_character_browser_unknown"), "unknown", false, false)
        gst.UI_Component_move_relative(slot7, xyy_select_character_panel, xoffset+150*6.5, yoffset, false)
    end
    
    local has_next_page = false;
    
    for k,v in ipairs(character_browser_list) do
        add_1p_character_button_listener(v)
    end
    
    for i=1,#character_browser_list do
        local index_x = ((i-1)%11);
        local index_y = math.floor((i-1)/11) - page;
        
        if index_y >= 2 then
            has_next_page = true
            break;
        elseif index_y >= 0 then
            local x = 310+120*index_x;
            local y = 450+120*index_y;
            
            --ModLog(x..","..y);
            local slot = add_character_button_1p(xyy_select_character_panel, 100, "ui/skins/default/character_browser/".. character_browser_list[i] ..".png", effect.get_localised_string("mod_xyy_character_browser_".. character_browser_list[i]), character_browser_list[i])
            gst.UI_Component_move_relative(slot, xyy_select_character_panel, x, y, false)
        end
    end
    local confirm_button = add_confirm_button_1p(xyy_select_character_panel, 800, 50)
    gst.UI_Component_move_relative(confirm_button, xyy_select_character_panel, 560, 720, false)
    
    confirm_button:SetState( "down" )
    find_uicomponent(confirm_button, "button_txt"):SetStateText(effect.get_localised_string("mod_xyy_character_browser_confirm"))
    if cm:query_local_faction(true):name() == cm:get_saved_value("xyy_1p") then
        if #selected_1p == 6 then
            confirm_button:SetState( "active" )
            find_uicomponent(confirm_button, "button_txt"):SetStateText(effect.get_localised_string("mod_xyy_character_browser_confirm"))
        else
            confirm_button:SetState( "inactive" )
            find_uicomponent(confirm_button, "button_txt"):SetStateText(effect.get_localised_string("mod_xyy_character_browser_confirm"))
        end
    else
        confirm_button:SetState( "inactive" )
        find_uicomponent(confirm_button, "button_txt"):SetStateText(effect.get_localised_string("mod_xyy_character_browser_wait"))
    end
    -- 下一页按钮
    if has_next_page then
        local next_page =  add_page_button_1p(xyy_select_character_panel, 50, 50, true)
        gst.UI_Component_move_relative(next_page, xyy_select_character_panel, 1380, 720, false)
        next_page:SetState( "down" )
        find_uicomponent(next_page, "button_txt"):SetStateText(">>")
        next_page:SetState( "active" )
        find_uicomponent(next_page, "button_txt"):SetStateText(">>")
    end
    if page > 0 then
        local previous_page =  add_page_button_1p(xyy_select_character_panel, 50, 50, false)
        gst.UI_Component_move_relative(previous_page, xyy_select_character_panel, 490, 720, false)
        previous_page:SetState( "down" )
        find_uicomponent(previous_page, "button_txt"):SetStateText("<<")
        previous_page:SetState( "active" )
        find_uicomponent(previous_page, "button_txt"):SetStateText("<<")
    end
    xyy_select_character_panel:SetVisible(true) 
    CampaignUI.CreateModelCallbackRequest("xyy_callback_steal_escape_key_true");
    
end

function character_browser_multiplayer_2p_3()
    remove_all_character_listener()
    local ui_root = core:get_ui_root()
    local ui_panel_name = UI_MOD_NAME .. "_xyy_select_character_panel" .. static_id;
    xyy_select_character_panel = core:get_or_create_component( ui_panel_name, "ui/xyy/character_browser_1")
    ui_root:Adopt( xyy_select_character_panel:Address() )
    xyy_select_character_panel:PropagatePriority(ui_root:Priority())
    if cm:query_local_faction(true):name() == cm:get_saved_value("xyy_2p") then
        find_uicomponent(xyy_select_character_panel, "faction_council_header"):SetStateText(effect.get_localised_string("mod_xyy_character_select_3"))
    else
        find_uicomponent(xyy_select_character_panel, "faction_council_header"):SetStateText(effect.get_localised_string("mod_xyy_character_select_3_non_playable"))
    end
    cm:set_saved_value("character_browser_multiplayer_2p", 3)
    cm:set_saved_value("time", "2p_3")
    local xoffset = 295;
    local yoffset = 250;
    
    local slot1 = add_character_pool_2p(xyy_select_character_panel, 130, "ui/skins/default/character_browser/".. selected_2p[1] ..".png", effect.get_localised_string("mod_xyy_character_browser_".. selected_2p[1]), selected_2p[1], false, false)
    gst.UI_Component_move_relative(slot1, xyy_select_character_panel, xoffset+150*1, yoffset, false)
        
    local slot2 = add_character_pool_2p(xyy_select_character_panel, 130, "ui/skins/default/character_browser/".. selected_2p[2] ..".png", effect.get_localised_string("mod_xyy_character_browser_".. selected_2p[2]), selected_2p[2], false, false)
    gst.UI_Component_move_relative(slot2, xyy_select_character_panel, xoffset+150*2, yoffset, false)
        
    local slot3 = add_character_pool_2p(xyy_select_character_panel, 130, "ui/skins/default/character_browser/".. selected_2p[3] ..".png", effect.get_localised_string("mod_xyy_character_browser_".. selected_2p[3]), selected_2p[3], false, false)
    gst.UI_Component_move_relative(slot3, xyy_select_character_panel, xoffset+150*3, yoffset, false)
        
    local slot4 = add_character_pool_2p(xyy_select_character_panel, 130, "ui/skins/default/character_browser/".. selected_2p[4] ..".png", effect.get_localised_string("mod_xyy_character_browser_".. selected_2p[4]), selected_2p[4], false, false)
    gst.UI_Component_move_relative(slot4, xyy_select_character_panel, xoffset+150*4, yoffset, false)
        
    if selected_2p[5] then
        local slot4 = add_character_pool_2p(xyy_select_character_panel, 130, "ui/skins/default/character_browser/".. selected_2p[5] ..".png", effect.get_localised_string("mod_xyy_character_browser_".. selected_2p[5]), selected_2p[5], false, true)
        gst.UI_Component_move_relative(slot4, xyy_select_character_panel, xoffset+150*5, yoffset, false)
    else
        local slot4 = add_character_pool_2p(xyy_select_character_panel, 130, "ui/skins/default/character_browser/placeholder.png", effect.get_localised_string("mod_xyy_character_browser_unknown"), "unknown", false, false)
        gst.UI_Component_move_relative(slot4, xyy_select_character_panel, xoffset+150*5, yoffset, false)
    end
    if selected_2p[6] then
        local slot5 = add_character_pool_2p(xyy_select_character_panel, 130, "ui/skins/default/character_browser/".. selected_2p[6] ..".png", effect.get_localised_string("mod_xyy_character_browser_".. selected_2p[6]), selected_2p[6], false, true)
        gst.UI_Component_move_relative(slot5, xyy_select_character_panel, xoffset+150*6, yoffset, false)
    else
        local slot5 = add_character_pool_2p(xyy_select_character_panel, 130, "ui/skins/default/character_browser/placeholder.png", effect.get_localised_string("mod_xyy_character_browser_unknown"), "unknown", false, false)
        gst.UI_Component_move_relative(slot5, xyy_select_character_panel, xoffset+150*6, yoffset, false)
    end
    if selected_2p[7] then
        local slot6 = add_character_pool_2p(xyy_select_character_panel, 130, "ui/skins/default/character_browser/".. selected_2p[7] ..".png", effect.get_localised_string("mod_xyy_character_browser_".. selected_2p[7]), selected_2p[7], false, true)
        gst.UI_Component_move_relative(slot6, xyy_select_character_panel, xoffset+150*7, yoffset, false)
    else
        local slot6 = add_character_pool_2p(xyy_select_character_panel, 130, "ui/skins/default/character_browser/placeholder.png", effect.get_localised_string("mod_xyy_character_browser_unknown"), "unknown", false, false)
        gst.UI_Component_move_relative(slot6, xyy_select_character_panel, xoffset+150*7, yoffset, false)
    end
    
    for k,v in ipairs(character_browser_list) do
        add_2p_character_button_listener(v)
    end
    
    local has_next_page = false;
    for i=1,#character_browser_list do
        local index_x = ((i-1)%11);
        local index_y = math.floor((i-1)/11) - page;
        
        if index_y >= 2 then
            has_next_page = true
            break;
        elseif index_y >= 0 then
            local x = 310+120*index_x;
            local y = 450+120*index_y;
            
            --ModLog(x..","..y);
            local slot = add_character_button_2p(xyy_select_character_panel, 100, "ui/skins/default/character_browser/".. character_browser_list[i] ..".png", effect.get_localised_string("mod_xyy_character_browser_".. character_browser_list[i]), character_browser_list[i])
            gst.UI_Component_move_relative(slot, xyy_select_character_panel, x, y, false)
        end
    end
    local confirm_button = add_confirm_button_2p(xyy_select_character_panel, 800, 50)
    gst.UI_Component_move_relative(confirm_button, xyy_select_character_panel, 560, 720, false)
    confirm_button:SetState( "down" )
    find_uicomponent(confirm_button, "button_txt"):SetStateText(effect.get_localised_string("mod_xyy_character_browser_confirm"))
    if cm:query_local_faction(true):name() == cm:get_saved_value("xyy_2p") then
        if #selected_2p == 7 then
            confirm_button:SetState( "active" )
            find_uicomponent(confirm_button, "button_txt"):SetStateText(effect.get_localised_string("mod_xyy_character_browser_confirm"))
        else
            confirm_button:SetState( "inactive" )
            find_uicomponent(confirm_button, "button_txt"):SetStateText(effect.get_localised_string("mod_xyy_character_browser_confirm"))
        end
    else
        confirm_button:SetState( "inactive" )
        find_uicomponent(confirm_button, "button_txt"):SetStateText(effect.get_localised_string("mod_xyy_character_browser_wait"))
    end
    -- 下一页按钮
    if has_next_page then
        local next_page =  add_page_button_2p(xyy_select_character_panel, 50, 50, true)
        gst.UI_Component_move_relative(next_page, xyy_select_character_panel, 1380, 720, false)
        next_page:SetState( "down" )
        find_uicomponent(next_page, "button_txt"):SetStateText(">>")
        next_page:SetState( "active" )
        find_uicomponent(next_page, "button_txt"):SetStateText(">>")
    end
    if page > 0 then
        local previous_page =  add_page_button_2p(xyy_select_character_panel, 50, 50, false)
        gst.UI_Component_move_relative(previous_page, xyy_select_character_panel, 490, 720, false)
        previous_page:SetState( "down" )
        find_uicomponent(previous_page, "button_txt"):SetStateText("<<")
        previous_page:SetState( "active" )
        find_uicomponent(previous_page, "button_txt"):SetStateText("<<")
    end
    xyy_select_character_panel:SetVisible(true) 
    CampaignUI.CreateModelCallbackRequest("xyy_callback_steal_escape_key_true");
end

function character_browser_multiplayer_1p_4()
    remove_all_character_listener()
    -- 选择up角色的槽位
    local ui_root = core:get_ui_root()
    local ui_panel_name = UI_MOD_NAME .. "_xyy_select_character_panel" .. static_id;
    xyy_select_character_panel = core:get_or_create_component( ui_panel_name, "ui/xyy/character_browser_1") --date.pack中自带的panel_frame.twui.xml布局文件
    ui_root:Adopt( xyy_select_character_panel:Address() )
    xyy_select_character_panel:PropagatePriority(ui_root:Priority())
    
    if cm:query_local_faction(true):name() == cm:get_saved_value("xyy_1p") then
        find_uicomponent(xyy_select_character_panel, "faction_council_header"):SetStateText(effect.get_localised_string("mod_xyy_character_select_4"))
    else
        find_uicomponent(xyy_select_character_panel, "faction_council_header"):SetStateText(effect.get_localised_string("mod_xyy_character_select_4_non_playable"))
    end
    
    cm:set_saved_value("character_browser_multiplayer_1p", 4)
    cm:set_saved_value("time", "1p_4")
    
    local xoffset = 295;
    local yoffset = 250;
    
    local slot1 = add_character_pool_1p(xyy_select_character_panel, 130, "ui/skins/default/character_browser/".. selected_1p[1] ..".png", effect.get_localised_string("mod_xyy_character_browser_".. selected_1p[1]), selected_1p[1], false, false)
    gst.UI_Component_move_relative(slot1, xyy_select_character_panel, xoffset+150*0, yoffset, false)
    
    local slot2 = add_character_pool_1p(xyy_select_character_panel, 130, "ui/skins/default/character_browser/".. selected_1p[2] ..".png", effect.get_localised_string("mod_xyy_character_browser_".. selected_1p[2]), selected_1p[2], false, false)
    gst.UI_Component_move_relative(slot2, xyy_select_character_panel, xoffset+150*1, yoffset, false)
    
    local slot3 = add_character_pool_1p(xyy_select_character_panel, 130, "ui/skins/default/character_browser/".. selected_1p[3] ..".png", effect.get_localised_string("mod_xyy_character_browser_".. selected_1p[3]), selected_1p[3], false, false)
    gst.UI_Component_move_relative(slot3, xyy_select_character_panel, xoffset+150*2, yoffset, false)
    
    local slot4 = add_character_pool_1p(xyy_select_character_panel, 130, "ui/skins/default/character_browser/".. selected_1p[4] ..".png", effect.get_localised_string("mod_xyy_character_browser_".. selected_1p[3]), selected_1p[4], false, false)
    gst.UI_Component_move_relative(slot4, xyy_select_character_panel, xoffset+150*3, yoffset, false)
    
    local slot5 = add_character_pool_1p(xyy_select_character_panel, 130, "ui/skins/default/character_browser/".. selected_1p[5] ..".png", effect.get_localised_string("mod_xyy_character_browser_".. selected_1p[3]), selected_1p[5], false, false)
    gst.UI_Component_move_relative(slot5, xyy_select_character_panel, xoffset+150*4, yoffset, false)

    local slot6 = add_character_pool_1p(xyy_select_character_panel, 130, "ui/skins/default/character_browser/".. selected_1p[6] ..".png", effect.get_localised_string("mod_xyy_character_browser_".. selected_1p[3]), selected_1p[6], false, false)
    gst.UI_Component_move_relative(slot6, xyy_select_character_panel, xoffset+150*5, yoffset, false)

    if selected_1p[7] then
        local slot7 = add_character_pool_1p(xyy_select_character_panel, 130, "ui/skins/default/character_browser/".. selected_1p[7] ..".png", effect.get_localised_string("mod_xyy_character_browser_".. selected_1p[7]), selected_1p[7], false, true)
        gst.UI_Component_move_relative(slot7, xyy_select_character_panel, xoffset+150*6, yoffset, false)
    else
        local slot7 = add_character_pool_1p(xyy_select_character_panel, 130, "ui/skins/default/character_browser/placeholder.png", effect.get_localised_string("mod_xyy_character_browser_unknown"), "unknown", false, false)
        gst.UI_Component_move_relative(slot7, xyy_select_character_panel, xoffset+150*6, yoffset, false)
    end
    
    if selected_1p[8] then
        local slot8 = add_character_pool_1p(xyy_select_character_panel, 130, "ui/skins/default/character_browser/".. selected_1p[8] ..".png", effect.get_localised_string("mod_xyy_character_browser_".. selected_1p[8]), selected_1p[8], false, true)
        gst.UI_Component_move_relative(slot8, xyy_select_character_panel, xoffset+150*7, yoffset, false)
    else
        local slot8 = add_character_pool_1p(xyy_select_character_panel, 130, "ui/skins/default/character_browser/placeholder.png", effect.get_localised_string("mod_xyy_character_browser_unknown"), "unknown", false, false)
        gst.UI_Component_move_relative(slot8, xyy_select_character_panel, xoffset+150*7, yoffset, false)
    end
    
    if selected_1p[9] then
        local slot9 = add_character_pool_1p(xyy_select_character_panel, 130, "ui/skins/default/character_browser/".. selected_1p[9] ..".png", effect.get_localised_string("mod_xyy_character_browser_".. selected_1p[9]), selected_1p[9], false, true)
        gst.UI_Component_move_relative(slot9, xyy_select_character_panel, xoffset+150*8, yoffset, false)
    else
        local slot9 = add_character_pool_1p(xyy_select_character_panel, 130, "ui/skins/default/character_browser/placeholder.png", effect.get_localised_string("mod_xyy_character_browser_unknown"), "unknown", false, false)
        gst.UI_Component_move_relative(slot9, xyy_select_character_panel, xoffset+150*8, yoffset, false)
    end
    
    for k,v in ipairs(character_browser_list) do
        add_1p_character_button_listener(v)
    end
    
    local has_next_page = false;
    
    for i=1,#character_browser_list do
        local index_x = ((i-1)%11);
        local index_y = math.floor((i-1)/11) - page;
        
        if index_y >= 2 then
            has_next_page = true
            break;
        elseif index_y >= 0 then
            local x = 310+120*index_x;
            local y = 450+120*index_y;
            
            --ModLog(x..","..y);
            local slot = add_character_button_1p(xyy_select_character_panel, 100, "ui/skins/default/character_browser/".. character_browser_list[i] ..".png", effect.get_localised_string("mod_xyy_character_browser_".. character_browser_list[i]), character_browser_list[i])
            gst.UI_Component_move_relative(slot, xyy_select_character_panel, x, y, false)
        end
    end
    -- 确认选择按钮
    local confirm_button = add_confirm_button_1p(xyy_select_character_panel, 800, 50)
    gst.UI_Component_move_relative(confirm_button, xyy_select_character_panel, 560, 720, false)
    
    confirm_button:SetState( "down" )
    find_uicomponent(confirm_button, "button_txt"):SetStateText(effect.get_localised_string("mod_xyy_character_browser_confirm"))
    if cm:query_local_faction(true):name() == cm:get_saved_value("xyy_1p") then
        if #selected_1p == 9 then
            confirm_button:SetState( "active" )
            find_uicomponent(confirm_button, "button_txt"):SetStateText(effect.get_localised_string("mod_xyy_character_browser_confirm"))
        else
            confirm_button:SetState( "inactive" )
            find_uicomponent(confirm_button, "button_txt"):SetStateText(effect.get_localised_string("mod_xyy_character_browser_confirm"))
        end
    else
        confirm_button:SetState( "inactive" )
        find_uicomponent(confirm_button, "button_txt"):SetStateText(effect.get_localised_string("mod_xyy_character_browser_wait"))
    end
    -- 下一页按钮
    if has_next_page then
        local next_page =  add_page_button_1p(xyy_select_character_panel, 50, 50, true)
        gst.UI_Component_move_relative(next_page, xyy_select_character_panel, 1380, 720, false)
        next_page:SetState( "down" )
        find_uicomponent(next_page, "button_txt"):SetStateText(">>")
        next_page:SetState( "active" )
        find_uicomponent(next_page, "button_txt"):SetStateText(">>")
    end
    if page > 0 then
        local previous_page =  add_page_button_1p(xyy_select_character_panel, 50, 50, false)
        gst.UI_Component_move_relative(previous_page, xyy_select_character_panel, 490, 720, false)
        previous_page:SetState( "down" )
        find_uicomponent(previous_page, "button_txt"):SetStateText("<<")
        previous_page:SetState( "active" )
        find_uicomponent(previous_page, "button_txt"):SetStateText("<<")
    end
    xyy_select_character_panel:SetVisible(true) 
    CampaignUI.CreateModelCallbackRequest("xyy_callback_steal_escape_key_true");
end

function character_browser_multiplayer_2p_4()
    remove_all_character_listener()
    local ui_root = core:get_ui_root()
    local ui_panel_name = UI_MOD_NAME .. "_xyy_select_character_panel" .. static_id;
    xyy_select_character_panel = core:get_or_create_component( ui_panel_name, "ui/xyy/character_browser_1")
    ui_root:Adopt( xyy_select_character_panel:Address() )
    xyy_select_character_panel:PropagatePriority(ui_root:Priority())
    if cm:query_local_faction(true):name() == cm:get_saved_value("xyy_2p") then
        find_uicomponent(xyy_select_character_panel, "faction_council_header"):SetStateText(effect.get_localised_string("mod_xyy_character_select_4"))
    else
        find_uicomponent(xyy_select_character_panel, "faction_council_header"):SetStateText(effect.get_localised_string("mod_xyy_character_select_4_non_playable"))
    end
    cm:set_saved_value("character_browser_multiplayer_2p", 4)
    cm:set_saved_value("time", "2p_4")
    local xoffset = 295;
    local yoffset = 250;
    
    local slot1 = add_character_pool_2p(xyy_select_character_panel, 130, "ui/skins/default/character_browser/".. selected_2p[1] ..".png", effect.get_localised_string("mod_xyy_character_browser_".. selected_2p[1]), selected_2p[1], false, false)
    gst.UI_Component_move_relative(slot1, xyy_select_character_panel, xoffset+150*0, yoffset, false)
        
    local slot2 = add_character_pool_2p(xyy_select_character_panel, 130, "ui/skins/default/character_browser/".. selected_2p[2] ..".png", effect.get_localised_string("mod_xyy_character_browser_".. selected_2p[2]), selected_2p[2], false, false)
    gst.UI_Component_move_relative(slot2, xyy_select_character_panel, xoffset+150*1, yoffset, false)
        
    local slot3 = add_character_pool_2p(xyy_select_character_panel, 130, "ui/skins/default/character_browser/".. selected_2p[3] ..".png", effect.get_localised_string("mod_xyy_character_browser_".. selected_2p[3]), selected_2p[3], false, false)
    gst.UI_Component_move_relative(slot3, xyy_select_character_panel, xoffset+150*2, yoffset, false)
        
    local slot4 = add_character_pool_2p(xyy_select_character_panel, 130, "ui/skins/default/character_browser/".. selected_2p[4] ..".png", effect.get_localised_string("mod_xyy_character_browser_".. selected_2p[4]), selected_2p[4], false, false)
    gst.UI_Component_move_relative(slot4, xyy_select_character_panel, xoffset+150*3, yoffset, false)
        
    local slot5 = add_character_pool_2p(xyy_select_character_panel, 130, "ui/skins/default/character_browser/".. selected_2p[5] ..".png", effect.get_localised_string("mod_xyy_character_browser_".. selected_2p[5]), selected_2p[5], false, false)
    gst.UI_Component_move_relative(slot5, xyy_select_character_panel, xoffset+150*4, yoffset, false)
    
    local slot6 = add_character_pool_2p(xyy_select_character_panel, 130, "ui/skins/default/character_browser/".. selected_2p[6] ..".png", effect.get_localised_string("mod_xyy_character_browser_".. selected_2p[6]), selected_2p[6], false, false)
    gst.UI_Component_move_relative(slot6, xyy_select_character_panel, xoffset+150*5, yoffset, false)
    
    local slot7 = add_character_pool_2p(xyy_select_character_panel, 130, "ui/skins/default/character_browser/".. selected_2p[7] ..".png", effect.get_localised_string("mod_xyy_character_browser_".. selected_2p[7]), selected_2p[7], false, false)
    gst.UI_Component_move_relative(slot7, xyy_select_character_panel, xoffset+150*6, yoffset, false)
    
    if selected_2p[8] then
        local slot8 = add_character_pool_2p(xyy_select_character_panel, 130, "ui/skins/default/character_browser/".. selected_2p[8] ..".png", effect.get_localised_string("mod_xyy_character_browser_".. selected_2p[8]), selected_2p[8], false, true)
        gst.UI_Component_move_relative(slot8, xyy_select_character_panel, xoffset+150*7, yoffset, false)
    else
        local slot8 = add_character_pool_2p(xyy_select_character_panel, 130, "ui/skins/default/character_browser/placeholder.png", effect.get_localised_string("mod_xyy_character_browser_unknown"), "unknown", false, false)
        gst.UI_Component_move_relative(slot8, xyy_select_character_panel, xoffset+150*7, yoffset, false)
    end
    if selected_2p[9] then
        local slot8 = add_character_pool_2p(xyy_select_character_panel, 130, "ui/skins/default/character_browser/".. selected_2p[9] ..".png", effect.get_localised_string("mod_xyy_character_browser_".. selected_2p[9]), selected_2p[9], false, true)
        gst.UI_Component_move_relative(slot8, xyy_select_character_panel, xoffset+150*8, yoffset, false)
    else
        local slot8 = add_character_pool_2p(xyy_select_character_panel, 130, "ui/skins/default/character_browser/placeholder.png", effect.get_localised_string("mod_xyy_character_browser_unknown"), "unknown", false, false)
        gst.UI_Component_move_relative(slot8, xyy_select_character_panel, xoffset+150*8, yoffset, false)
    end
    
    for k,v in ipairs(character_browser_list) do
        add_2p_character_button_listener(v)
    end
    local has_next_page = false;
    for i=1,#character_browser_list do
        local index_x = ((i-1)%11);
        local index_y = math.floor((i-1)/11) - page;
        
        if index_y >= 2 then
            has_next_page = true
            break;
        elseif index_y >= 0 then
            local x = 310+120*index_x;
            local y = 450+120*index_y;
            
            --ModLog(x..","..y);
            local slot = add_character_button_2p(xyy_select_character_panel, 100, "ui/skins/default/character_browser/".. character_browser_list[i] ..".png", effect.get_localised_string("mod_xyy_character_browser_".. character_browser_list[i]), character_browser_list[i])
            gst.UI_Component_move_relative(slot, xyy_select_character_panel, x, y, false)
        end
    end
    local confirm_button = add_confirm_button_2p(xyy_select_character_panel, 800, 50)
    gst.UI_Component_move_relative(confirm_button, xyy_select_character_panel, 560, 720, false)
    confirm_button:SetState( "down" )
    find_uicomponent(confirm_button, "button_txt"):SetStateText(effect.get_localised_string("mod_xyy_character_browser_confirm"))
    if cm:query_local_faction(true):name() == cm:get_saved_value("xyy_2p") then
        if #selected_2p == 9 then
            confirm_button:SetState( "active" )
            find_uicomponent(confirm_button, "button_txt"):SetStateText(effect.get_localised_string("mod_xyy_character_browser_confirm"))
        else
            confirm_button:SetState( "inactive" )
            find_uicomponent(confirm_button, "button_txt"):SetStateText(effect.get_localised_string("mod_xyy_character_browser_confirm"))
        end
    else
        confirm_button:SetState( "inactive" )
        find_uicomponent(confirm_button, "button_txt"):SetStateText(effect.get_localised_string("mod_xyy_character_browser_wait"))
    end
    if has_next_page then
        local next_page =  add_page_button_2p(xyy_select_character_panel, 50, 50, true)
        gst.UI_Component_move_relative(next_page, xyy_select_character_panel, 1380, 720, false)
        next_page:SetState( "down" )
        find_uicomponent(next_page, "button_txt"):SetStateText(">>")
        next_page:SetState( "active" )
        find_uicomponent(next_page, "button_txt"):SetStateText(">>")
    end
    if page > 0 then
        local previous_page =  add_page_button_2p(xyy_select_character_panel, 50, 50, false)
        gst.UI_Component_move_relative(previous_page, xyy_select_character_panel, 490, 720, false)
        previous_page:SetState( "down" )
        find_uicomponent(previous_page, "button_txt"):SetStateText("<<")
        previous_page:SetState( "active" )
        find_uicomponent(previous_page, "button_txt"):SetStateText("<<")
    end
    xyy_select_character_panel:SetVisible(true) 
    CampaignUI.CreateModelCallbackRequest("xyy_callback_steal_escape_key_true");
end

function remove_suffix(s, suffix)
    return (s:gsub("(.*)" .. suffix, "%1"))
end

function draw(faction)
    local player_faction_query_object = cm:query_model():world():whose_turn_is_it();
    local player_faction_modify_object = cm:modify_faction(player_faction_query_object)
    if faction then
        player_faction_query_object = faction
        player_faction_modify_object = cm:modify_faction(faction)
    end
    local ticket_points = gst.faction_get_tickets(player_faction_query_object:name())
    if ticket_points == 0 then
        return "";
    else
        gst.faction_sub_tickets(player_faction_query_object:name(), 1);
    end
    
    if player_faction_modify_object then 
        local guaranteed
        if cm:get_saved_value(player_faction_query_object:name().."_guaranteed") then
            guaranteed = cm:get_saved_value(player_faction_query_object:name().."_guaranteed")
        else
            guaranteed = 50
        end
        local can_create_ceo_tables = {}
        local items = nil;
        if true then
            if true then
                if cm:is_multiplayer() then
                    if #selected_1p == 0 
                    and cm:query_local_faction(true):name() == cm:get_saved_value("xyy_1p")
                    and player_faction_query_object:name() == cm:get_saved_value("xyy_1p")
                    then
                        return "";
                    end
                    
                    if #selected_2p == 0 
                    and cm:query_local_faction(true):name() == cm:get_saved_value("xyy_2p") 
                    and player_faction_query_object:name() == cm:get_saved_value("xyy_2p")
                    then
                        return "";
                    end
                end
                local score = 10;
                local max = 1000;
                if guaranteed == 11 then
                    score = 100
                elseif guaranteed == 10 then
                    score = 190
                elseif guaranteed == 9 then
                    score = 280
                elseif guaranteed == 8 then
                    score = 370
                elseif guaranteed == 7 then
                    score = 460
                elseif guaranteed == 6 then
                    score = 550
                elseif guaranteed == 5 then
                    score = 640
                elseif guaranteed == 4 then
                    score = 730
                elseif guaranteed == 3 then
                    score = 820
                elseif guaranteed == 2 then
                    score = 910
                elseif guaranteed == 1 then
                    score = max;
                end
                
                --符玄在玩家派系时略微提高抽中角色的概率
                local hlyjcp = cm:query_model():character_for_template("hlyjcp");
                if hlyjcp 
                and not hlyjcp:is_null_interface()
                and not hlyjcp:is_dead()
                and not hlyjcp:is_character_is_faction_recruitment_pool()
                and hlyjcp:faction():name() == player_faction_query_object:name() 
                then
                    score = score + 90;
                end
                
                local random = math.floor(gst.lib_getRandomValue(0,max))
                local rate = score*100/max;
                ModLog(guaranteed..": 随机数 = " .. random .. "  当前出货概率 = " .. rate .. "%")
                local successed
                if cm:is_multiplayer() then
                    successed = cm:roll_random_chance(rate)
                else
                    successed = random <= score
                end
                if not successed then
                    if random <= 80 then
                        items = random_item1_weapon;
                    elseif random > 80 and random <= 160 then
                        items = random_item1_armour;
                    elseif random > 160 and random <= 240 then
                        items = random_item1_mount;
                    elseif random > 240 and random <= 320 then
                        items = random_item1_follower;
                    elseif random > 320 and random <= 400 then
                        items = random_item1_accessory;
                    elseif random > 400 and random <= 460 then
                        items = random_item2_weapon;
                    elseif random > 460 and random <= 520 then
                        items = random_item2_armour;
                    elseif random > 520 and random <= 580 then
                        items = random_item2_mount;
                    elseif random > 580 and random <= 640 then
                        items = random_item2_follower;
                    elseif random > 640 and random <= 700 then
                        items = random_item2_accessory;
                    elseif random > 700 and random <= 780 then
                        items = random_item3_weapon;
                    elseif random > 780 and random <= 830 then
                        items = random_item3_armour;
                    elseif random > 830 and random <= 890 then
                        items = random_item3_mount;
                    elseif random > 890 and random <= 940 then
                        items = random_item3_follower;
                    elseif random > 940 then
                        items = random_item3_accessory;
                    end
                else
                    local character_key
                    if cm:query_model():is_multiplayer() then
                        if player_faction_modify_object:query_faction():name() == cm:get_saved_value("xyy_1p") then
                            if currect_character_1p then
                                character_key = currect_character_1p
                                add_character_to_player(currect_character_1p, player_faction_query_object)
                                gst.lib_remove_value_from_list(selected_1p, character_key)
                                currect_character_1p = nil
                                cm:set_saved_value("currect_character_1p", currect_character_1p)
                                refresh_menu_button_notification()
                            else
                                character_key = selected_1p[1]
                                add_character_to_player(character_key, player_faction_query_object)
                                local character = gst.lib_remove_value_from_list(selected_1p, character_key)
                            end
                            if #selected_1p == 0 then
                                cm:modify_faction(player_faction_modify_object):apply_effect_bundle("3k_xyy_character_sold_out_dummy", -1)
                            end
                        elseif player_faction_modify_object:query_faction():name() == cm:get_saved_value("xyy_2p") then
                            if currect_character_2p then
                                character_key = currect_character_2p
                                add_character_to_player(character_key, player_faction_query_object)
                                gst.lib_remove_value_from_list(selected_2p, character_key)
                                currect_character_2p = nil
                                cm:set_saved_value("currect_character_2p", currect_character_2p)
                                refresh_menu_button_notification()
                            else
                                character_key = selected_2p[1]
                                add_character_to_player(character_key, player_faction_query_object)
                                gst.lib_remove_value_from_list(selected_2p, character_key)
                            end
                            if #selected_2p == 0 then
                                cm:modify_faction(player_faction_modify_object):apply_effect_bundle("3k_xyy_character_sold_out_dummy", -1)
                            end
                        end
                        cm:set_saved_value("xyy_selected_1p", selected_1p)
                        cm:set_saved_value("xyy_selected_2p", selected_2p)
                    else
                        if currect_character_1p then
                            character_key = currect_character_1p
                            add_character_to_player(character_key, player_faction_query_object)
                            gst.lib_remove_value_from_list(xyy_character_up_pool, character_key)
                            gst.lib_remove_value_from_list(xyy_character_lottery_pool, character_key)
                            currect_character_1p = nil
                            cm:set_saved_value("currect_character_1p", currect_character_1p)
                            refresh_menu_button_notification()
                        else
                            if #xyy_character_up_pool > 0 then
                                character_key = xyy_character_up_pool[1]
                                add_character_to_player(character_key, player_faction_query_object)
                                gst.lib_remove_value_from_list(xyy_character_up_pool, character_key)
                            elseif #xyy_character_lottery_pool > 0 then
                                character_key = xyy_character_lottery_pool[1]
                                add_character_to_player(character_key, player_faction_query_object)
                                gst.lib_remove_value_from_list(xyy_character_lottery_pool, character_key)
                            end
                        end
                        if #xyy_character_up_pool == 0 and #xyy_character_lottery_pool == 0 then
                            cm:modify_faction(player_faction_modify_object):apply_effect_bundle("3k_xyy_character_sold_out_dummy", -1)
                        end
                    end
                    cm:set_saved_value("xyy_character_lottery_pool", xyy_character_lottery_pool)
                    cm:set_saved_value("character_browser_list", character_browser_list)
                    cm:set_saved_value("xyy_character_up_pool", xyy_character_up_pool)
                    guaranteed = 50
                    ModLog(player_faction_query_object:name().."_guaranteed = "..guaranteed)
                    cm:set_saved_value(player_faction_query_object:name().."_guaranteed", guaranteed);
                    closeStorePanel()
                    ModLog(character_key)
                    return "\n[[col:flavour]]" .. gst.character_get_string_name(character_key) .. "[[/col]]" ;
                end
            end
            local quality_color = "gold";
            if items == random_item1_weapon or items == random_item1_armour or items == random_item1_mount or items == random_item1_follower or items == random_item1_accessory then
                quality_color = "copper";
            end
            if items == random_item2_weapon or items == random_item2_armour or items == random_item2_mount or items == random_item2_follower or items == random_item2_accessory then
                quality_color = "silver";
            end
            for i = 1, #items do
                local split_arr = string.split(items[i], ",")
                if(player_faction_modify_object:ceo_management():query_faction_ceo_management():can_create_ceo(split_arr[2])) then
                    gst.lib_table_insert(can_create_ceo_tables, split_arr);
                end
            end
            if(#can_create_ceo_tables <= 0) then
                if cm:query_local_faction(true):name() == player_faction_query_object:name() then
                    effect.advice(effect.get_localised_string("mod_xyy_store_main_tooltip_sold_out"))
                end
            else
                --随机一个道具
                local randomint = gst.lib_getRandomValue(1,#can_create_ceo_tables)
                while randomint == last_random1 do
                    randomint = gst.lib_getRandomValue(1,#can_create_ceo_tables)
                end
                last_random1 = randomint;
                -- ModLog(randomint)
                local item = can_create_ceo_tables[randomint]
                local ceo = item[2];
                local name;
                if locale == "cn" then
                    name = items_names[ceo].cn;
                elseif locale == "en" then
                    name = items_names[ceo].en;
                elseif locale == "zh" then
                    name = items_names[ceo].zh;
                elseif locale == "kr" then
                    name = items_names[ceo].kr;
                end
                if true then
                    guaranteed = guaranteed - 1;
                    cm:set_saved_value(player_faction_query_object:name().."_guaranteed", guaranteed);
                    local a = 50 - guaranteed;
                    player_faction_modify_object:ceo_management():add_ceo(item[2])
                    if cm:query_local_faction(true):name() == player_faction_query_object:name() then
                        local message = effect.get_localised_string("mod_xyy_store_main_message_main_gacha_item");
                        message = string.gsub(message,"%%1", quality_color);
                        message = string.gsub(message,"%%2", name);
                        ModLog(message)
                        return message
                    end
                end
            end
        end
    end
    return ""
end

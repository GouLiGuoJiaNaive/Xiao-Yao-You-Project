local gst = xyy_gst:get_mod()


		--==============================================================================--
							 -- 本lua的局部变量--
		--==============================================================================--

local static_id = 0

local UI_MOD_NAME = nil;

local bt_close_size_x   = 36 --面板关闭按钮大小
local bt_close_size_y   = 36 --面板关闭按钮大小

local panel_size_x      = 1920 --面板大小
local panel_size_y      = 900 --面板大小

local path_panel = nil;
local path_button = nil;

local path_1_button = nil;
local path_2_button = nil;
local path_3_button = nil;
local path_4_button = nil;
local path_5_button = nil;
local path_6_button = nil;
local path_7_button = nil;

local confirm_button = nil;

local currect_path = nil;

local path_panel_btn_table = {};

local toggle_ui = true

local locale = gst.get_locale()

local local_faction = nil

local last_faction = nil
        
local path_table = {
    "abundance",
    "destruction",
    "erudition",
    "harmony",
    "nihility",
    "preservation",
    "the_hunt",
}

--添加一个按钮
local function add_path_button(parent, path_key, slot_icon, slot_label)
    local bt_name = UI_MOD_NAME .. "_character_panel_" .. path_key;
    local btn_listener_name = bt_name .. "_click_up"
    local bt 
    local button_key 
    
    if path_key == "abundance" then
        button_key = "xyy_path_blessing_1"
    elseif path_key == "destruction" then
        button_key = "xyy_path_blessing_2"
    elseif path_key == "erudition" then
        button_key = "xyy_path_blessing_3"
    elseif path_key == "harmony" then
        button_key = "xyy_path_blessing_4"
    elseif path_key == "nihility" then
        button_key = "xyy_path_blessing_5"
    elseif path_key == "preservation" then
        button_key = "xyy_path_blessing_6"
    elseif path_key == "the_hunt" then
        button_key = "xyy_path_blessing_7"
    end
    ModLog(path_key)
    bt = core:get_or_create_component(bt_name, "ui/templates/button_mp/" .. button_key)
    
    parent:Adopt(bt:Address())
    bt:PropagatePriority(parent:Priority())
    gst.UI_Component_resize(bt, 120, 180, true)
    local ruan_mei = gst.character_query_for_template("hlyjct")
    if hlyjct
    and not hlyjct:is_null_interface()
    and not hlyjct:is_dead()
    and not hlyjct:is_character_is_faction_recruitment_pool()
    and hlyjct:faction():has_effect_bundle("xyy_roguelike_8")
    then
        bt:SetImagePath("ui/skins/default/path/"..path_key..".png");  
        bt:SetTooltipText(effect.get_localised_string("mod_xyy_path_blessing_"..path_key), true);
    else
        if locale == "cn" then
        bt:SetImagePath("ui/skins/default/path/placeholder_cn.png");   
        elseif locale == "zh" then
        bt:SetImagePath("ui/skins/default/path/placeholder_zh.png");   
        end
    end
    bt:SetTooltipText(effect.get_localised_string("mod_xyy_path_blessing_select"), true)
    gst.lib_recordObj(bt, btn_listener_name,  path_panel_btn_table);
    core:add_listener(
        btn_listener_name,
        "ComponentLClickUp",
        function(context)
            return bt == UIComponent(context.component)
        end,
        function(context)
            currect_path = path_key;
            bt:SetState( "selected_inactive" );
            bt:SetImagePath(slot_icon);
            bt:SetTooltipText(slot_label, true);
            
            if bt ~= path_1_button then
                path_1_button:SetState( "inactive" );
                path_1_button:SetImagePath("ui/skins/default/path/"..path_table[1]..".png");  
                path_1_button:SetTooltipText(effect.get_localised_string("mod_xyy_path_blessing_"..path_table[1]), true);
            end
            if bt ~= path_2_button then
                path_2_button:SetState( "inactive" );
                path_2_button:SetImagePath("ui/skins/default/path/"..path_table[2]..".png");  
                path_2_button:SetTooltipText(effect.get_localised_string("mod_xyy_path_blessing_"..path_table[2]), true);
            end
            if bt ~= path_3_button then
                path_3_button:SetState( "inactive" );
                path_3_button:SetImagePath("ui/skins/default/path/"..path_table[3]..".png");  
                path_3_button:SetTooltipText(effect.get_localised_string("mod_xyy_path_blessing_"..path_table[3]), true);
            end
            if bt ~= path_4_button then
                path_4_button:SetState( "inactive" );
                path_4_button:SetImagePath("ui/skins/default/path/"..path_table[4]..".png");  
                path_4_button:SetTooltipText(effect.get_localised_string("mod_xyy_path_blessing_"..path_table[4]), true);
            end
            if bt ~= path_5_button then
                path_5_button:SetState( "inactive" );
                path_5_button:SetImagePath("ui/skins/default/path/"..path_table[5]..".png");  
                path_5_button:SetTooltipText(effect.get_localised_string("mod_xyy_path_blessing_"..path_table[5]), true);
            end
            if bt ~= path_6_button then
                path_6_button:SetState( "inactive" );
                path_6_button:SetImagePath("ui/skins/default/path/"..path_table[6]..".png");  
                path_6_button:SetTooltipText(effect.get_localised_string("mod_xyy_path_blessing_"..path_table[6]), true);
            end
            if bt ~= path_7_button then
                path_7_button:SetState( "inactive" );
                path_7_button:SetImagePath("ui/skins/default/path/"..path_table[7]..".png");  
                path_7_button:SetTooltipText(effect.get_localised_string("mod_xyy_path_blessing_"..path_table[7]), true);
            end
            confirm_button:SetState( "active" )
            find_uicomponent(confirm_button, "button_txt"):SetStateText(effect.get_localised_string("mod_xyy_character_browser_confirm"))
--             if not cm:is_multiplayer() then
--                 gst.wait_for_model_sp(
--                 function()
--                     if last_path then
--                         ModLog(last_path.." => "..currect_path)
--                         if last_path == currect_path
--                         and path_level < 3
--                         then
--                             path_level = path_level + 1;
--                         end
--                         if last_path ~= currect_path then
--                             path_level = 1;
--                         end
--                     end
--                     --ModLog(path_level)
--                     last_path = currect_path;
--                     cm:set_saved_value("xyy_last_path",last_path)
--                     cm:set_saved_value("xyy_path_level",path_level)
--                     if local_faction
--                     and not local_faction:is_null_interface()
--                     and not local_faction:is_dead()
--                     then
--                         ModLog("blessing_" .. path_key .. "_" .. path_level)
--                         cm:modify_faction(local_faction):apply_effect_bundle("blessing_" .. path_key .. "_" .. path_level, 5);
--                     end
--                     cm:set_saved_value("xyy_path_chosen_year", cm:query_model():calendar_year());
--                 end
--                 )
--             end
        end,
        true
    )
    return bt;
end

function removeAllEffectBundles(modify_faction)
    for _, v in ipairs(path_table) do
        modify_faction:remove_effect_bundle("blessing_" .. v .. "_1");
        modify_faction:remove_effect_bundle("blessing_" .. v .. "_2");
        modify_faction:remove_effect_bundle("blessing_" .. v .. "_3");
    end
end

local function add_confirm_button(parent, x, y)
    local bt_name = UI_MOD_NAME .. "_confirm";
    local btn_listener_name = bt_name .. "_click_up"
    local bt = core:get_or_create_component(bt_name, "ui/templates/square_large_text_button")
    -- local character = cm:query_model():character_for_template(character_key);
    parent:Adopt(bt:Address())
    bt:PropagatePriority(parent:Priority())
    gst.UI_Component_resize(bt, x, y, true)
    core:add_listener(
        btn_listener_name,
        "ComponentLClickUp",
        function(context)
            return bt == UIComponent(context.component)
        end,
        function(context)
            if currect_path then
                path_panel:SetVisible(false) 
                for i = 1, #path_panel_btn_table do
                    core:remove_listener(gst.lib_getRecordObjLisName(path_panel_btn_table[i]))
                    gst.UI_Component_destroy(gst.lib_getRecordObj(path_panel_btn_table[i]))
                end
                path_panel_btn_table = {}
                    gst.UI_Component_destroy(path_panel)
                path_panel = nil
                ModLog(UI_MOD_NAME)
            end
        end,
        false
    )
    gst.lib_recordObj(bt, btn_listener_name,  path_panel_btn_table);
    return bt;
end

--创建ui：关闭按钮
local function create_bt_close(parent)
    local bt_name = UI_MOD_NAME .. "_path_close_btn";
    local btn_listener_name = bt_name .. "_click_up"
    local bt = core:get_or_create_component(bt_name, "ui/templates/3k_btn_close_32")
    parent:Adopt(bt:Address())
    bt:PropagatePriority(parent:Priority())
    --bt:SetTooltipText("关闭", true)
    gst.UI_Component_resize(bt, bt_close_size_x, bt_close_size_y, true)
    core:add_listener(
        btn_listener_name,
        "ComponentLClickUp",
        function(context)
            return bt == UIComponent(context.component)
        end,
        function(context)
            path_panel:SetVisible(false) 
            for i = 1, #path_panel_btn_table do
                core:remove_listener(gst.lib_getRecordObjLisName(path_panel_btn_table[i]))
                gst.UI_Component_destroy(gst.lib_getRecordObj(path_panel_btn_table[i]))
            end
            path_panel_btn_table = {}
                gst.UI_Component_destroy(path_panel)
            path_panel = nil
            ModLog(UI_MOD_NAME)
        end,
        false
    )
    gst.lib_recordObj(bt, btn_listener_name,  path_panel_btn_table);
    return bt
end

--开启/关闭主界面UI
function openPathPanel()
    UI_MOD_NAME = "xyy_path_blessing_" .. cm:query_model():calendar_year()
    ModLog(UI_MOD_NAME);
    local ui_root = core:get_ui_root();
    local ui_panel_name = UI_MOD_NAME .. "_panel";
    path_panel = core:get_or_create_component( ui_panel_name, "ui/templates/xyy_path_blessing"); --选择模板文件
    ui_root:Adopt( path_panel:Address() );
    path_panel:PropagatePriority( ui_root:Priority() );
    local x,y,w,h = gst.UI_Component_coordinates(ui_root);
    --设置panel的大小
    gst.UI_Component_resize( path_panel, panel_size_x, panel_size_y, true );
    --移动panel的相对位置
    
    gst.UI_Component_move_relative( path_panel, ui_root, (w-panel_size_x)/2, 100, false );
    path_1_button = add_path_button(path_panel, path_table[1], "ui/skins/default/path/"..path_table[1]..".png", effect.get_localised_string("mod_xyy_path_blessing_"..path_table[1]));
    gst.UI_Component_move_relative(path_1_button, path_panel, 865, 250, false);
    
    path_2_button = add_path_button(path_panel, path_table[2], "ui/skins/default/path/"..path_table[2]..".png", effect.get_localised_string("mod_xyy_path_blessing_"..path_table[2]));
    gst.UI_Component_move_relative(path_2_button, path_panel, 1001, 250, false);
    
    path_3_button = add_path_button(path_panel, path_table[3], "ui/skins/default/path/"..path_table[3]..".png", effect.get_localised_string("mod_xyy_path_blessing_"..path_table[3]));
    gst.UI_Component_move_relative(path_3_button, path_panel, 1136, 250, false);
    
    path_4_button = add_path_button(path_panel, path_table[4], "ui/skins/default/path/"..path_table[4]..".png", effect.get_localised_string("mod_xyy_path_blessing_"..path_table[4]));
    gst.UI_Component_move_relative(path_4_button, path_panel, 1272, 250, false);
    
    path_5_button = add_path_button(path_panel, path_table[5], "ui/skins/default/path/"..path_table[5]..".png", effect.get_localised_string("mod_xyy_path_blessing_"..path_table[5]));
    gst.UI_Component_move_relative(path_5_button, path_panel, 932, 444, false);
    
    path_6_button = add_path_button(path_panel, path_table[6], "ui/skins/default/path/"..path_table[6]..".png", effect.get_localised_string("mod_xyy_path_blessing_"..path_table[6]));
    gst.UI_Component_move_relative(path_6_button, path_panel, 1068, 444, false);
    
    path_7_button = add_path_button(path_panel, path_table[7], "ui/skins/default/path/"..path_table[7]..".png", effect.get_localised_string("mod_xyy_path_blessing_"..path_table[7]));
    gst.UI_Component_move_relative(path_7_button, path_panel, 1204, 444, false);
    
    confirm_button = add_confirm_button(path_panel, 500, 50)
    gst.UI_Component_move_relative(confirm_button, path_panel, 880, 670, false)

    confirm_button:SetState( "down" )
    find_uicomponent(confirm_button, "button_txt"):SetStateText(effect.get_localised_string("mod_xyy_character_browser_confirm"))
    
    confirm_button:SetState( "inactive" )
    find_uicomponent(confirm_button, "button_txt"):SetStateText(effect.get_localised_string("mod_xyy_character_browser_confirm"))

    path_panel:SetVisible(true);
end

--AI派系选择自动命途
function AI_chosen_path_blessing(faction)
    if faction:is_human() then
        return nil;
    end
--     local shuffled = gst.lib_shuffle_table(path_table);
--     path_table = shuffled;

    local path_level = cm:get_saved_value("xyy_path_level")
    local last_path = cm:get_saved_value("xyy_last_path")
    local path_key = path_table[cm:random_int(7,1)];
    currect_path = path_key;
    if last_path then
        ModLog(last_path.." => "..currect_path)
        if not path_level or path_level <= 0 then
            path_level = 1
        end
        if last_path == currect_path
        and path_level < 3
        then
            path_level = path_level + 1;
        else
            path_level = 1;
        end
    end
    last_path = currect_path;
    cm:set_saved_value("xyy_last_path", last_path)
    cm:set_saved_value("xyy_path_level", path_level)
    if faction
    and not faction:is_null_interface()
    and not faction:is_dead()
    then
        local bundle_key = "blessing_" .. path_key .. "_" .. path_level;
        cm:modify_faction(faction):apply_effect_bundle(bundle_key, 5);
        ModLog(bundle_key);
        return bundle_key;
    end
    return nil;
end

core:add_listener(
    "xyy_path_blessing",
    "FirstTickAfterWorldCreated", --进入存档后的第一时间
    function(context)
        return not cm:get_saved_value("xyy_1p")
    end,

    function(context)
        --检测阮梅的所在势力
        local ruan_mei = cm:query_model():character_for_template("hlyjct")
        if ruan_mei 
        and not ruan_mei:is_null_interface() 
        and not ruan_mei:is_character_is_faction_recruitment_pool()
        then
            local_faction = ruan_mei:faction();
            if context:query_model():season() == "season_spring" then
                if (not cm:get_saved_value("xyy_path_chosen_year") 
                or cm:get_saved_value("xyy_path_chosen_year") < context:query_model():calendar_year())
                and local_faction:is_human()
                then
                    cm:trigger_dilemma(local_faction:name(),"xyy_path_blessing", true);
                end
            end
        end
    end,
    false
)

core:add_listener(
    "xyy_path_blessing_faction_start",
    "FactionTurnStart",
    function(context)
--         if cm:is_multiplayer() then
--             return false
--         end
        --AI派系可能存在BUG
        if context:faction():has_effect_bundle("xyy_roguelike_8") 
        and context:query_model():season() == "season_spring"
        then
            return true
        end
        local ruan_mei = cm:query_model():character_for_template("hlyjct")
        local faction = context:faction();
        if ruan_mei
        and not ruan_mei:is_null_interface()
        and not ruan_mei:is_dead()
        and not ruan_mei:is_character_is_faction_recruitment_pool()
        and ruan_mei:faction() == faction then
            if context:query_model():season() == "season_spring" then
                return true
            end
        end
        return false
    end,
    function(context)
        if context:faction():is_human() then
            cm:trigger_dilemma(context:faction():name(),"xyy_path_blessing", true);
        else
            AI_chosen_path_blessing(context:faction());
        end
    end,
    true
)

core:add_listener(
    "xyy_path_blessing_ruan_mei_change_faction",
    "CharacterLeavesFaction",
    function(context)
        return context:query_character():generation_template_key() == "hlyjct"
    end,
    function(context)
        cm:set_saved_value("xyy_last_path", nil)
        cm:set_saved_value("xyy_path_level", 1)
    end,
    true
)

core:add_listener(
    "xyy_path_blessing_dilemma",
    "DilemmaChoiceMadeEvent",
    function(context)
        ModLog(context:dilemma())
        return context:faction():is_human() and
        context:dilemma() == "xyy_path_blessing";
    end,
    function(context)
        local faction = context:faction()
        local shuffled = gst.lib_shuffle_table(path_table);
        path_table = shuffled;
        if cm:is_multiplayer() then
            if faction:name() == cm:query_local_faction(true):name() then
                openPathPanel();
            end
        else
            openPathPanel();
        end
    end,
    true
)

core:add_listener(
    "xyy_path_blessing_mp",
    "ModelScriptNotificationEvent",
    function(model_script_notification_event)
        return string.find(model_script_notification_event:event_id(), "xyy_path_blessing")
    end,
    function(model_script_notification_event)
        local_faction = cm:query_model():world():whose_turn_is_it()
        if model_script_notification_event:event_id() == "xyy_path_blessing_1" then
            currect_path = "abundance"
        elseif model_script_notification_event:event_id() == "xyy_path_blessing_2" then
            currect_path = "destruction"
        elseif model_script_notification_event:event_id() == "xyy_path_blessing_3" then
            currect_path = "erudition"
        elseif model_script_notification_event:event_id() == "xyy_path_blessing_4" then
            currect_path = "harmony"
        elseif model_script_notification_event:event_id() == "xyy_path_blessing_5" then
            currect_path = "nihility"
        elseif model_script_notification_event:event_id() == "xyy_path_blessing_6" then
            currect_path = "preservation"
        elseif model_script_notification_event:event_id() == "xyy_path_blessing_7" then
            currect_path = "the_hunt"
        end
        local path_level = cm:get_saved_value("xyy_path_level")
        local last_path = cm:get_saved_value("xyy_last_path")
        if not path_level then
            path_level = 1;
        end
        if last_path then
            ModLog(last_path.." => "..currect_path)
            if not path_level or path_level <= 0 then
                path_level = 1
            end
            if last_path == currect_path
            and path_level < 3
            then
                path_level = path_level + 1;
            end
            if last_path ~= currect_path then
                path_level = 1;
            end
        end
        path_key = currect_path;
        --ModLog(path_level)
        last_path = path_key;
        cm:set_saved_value("xyy_last_path", last_path)
        cm:set_saved_value("xyy_path_level", path_level)
        if local_faction
        and not local_faction:is_null_interface()
        and not local_faction:is_dead()
        then
            ModLog(local_faction:name()..": blessing_" .. path_key .. "_" .. path_level)
            cm:modify_faction(local_faction):apply_effect_bundle("blessing_" .. path_key .. "_" .. path_level, 5);
        end
        cm:set_saved_value("xyy_path_chosen_year", cm:query_model():calendar_year());
        cm:modify_model():get_modify_episodic_scripting():autosave_at_next_opportunity();
    end, 
    false
)

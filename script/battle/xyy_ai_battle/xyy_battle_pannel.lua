		--==============================================================================--
							 -- UI通用工具方法--
		--==============================================================================--

--销毁一个ui
local function UIComponent_destroy( component, divorce )
    if is_uicomponent( component ) then
        divorce = not not divorce
        if divorce then
            local parent = component:Parent()

            if is_uicomponent( parent ) then
                parent:Divorce( component:Address() )
            end
        end
    end
end

--设置一个ui对象的大小
local function UIComponent_resize( component, width, height, can_resize )
    if is_uicomponent( component ) then
        if (not not can_resize) then
            component:SetCanResizeHeight(true);
            component:SetCanResizeWidth(true);
            component:Resize(width, height);
            component:SetCanResizeHeight(false);
            component:SetCanResizeWidth(false);
        else
            component:Resize(width, height);
        end
    end
end

local function UIComponent_coordinates( component )
    if is_uicomponent( component ) then
        local x, y = component:Position()
        local w, h = component:Dimensions()
        return x, y, w, h
    end
    return 0, 0, 0, 0
end

--移动相对位置
local function UIComponent_move_relative( component, anchor, relative_x, relative_y, is_margin )
    is_margin = not not is_margin

    if is_uicomponent( component ) and is_uicomponent( anchor ) then
        local x, y, w, h = UIComponent_coordinates( anchor )
        if is_margin then
            component:MoveTo(x + w + relative_x, y + h + relative_y)
        elseif is_uicomponent( anchor ) then
            component:MoveTo(x + relative_x, y + relative_y)
        end
    end
end


		--==============================================================================--
							 -- 本lua的局部变量--
		--==============================================================================--
local playercontrol = {

}

local static_id = 0

local UI_MOD_NAME = "xyy_battle_panel"

local bt_close_size_x   = 36 --面板关闭按钮大小
local bt_close_size_y   = 36 --面板关闭按钮大小

local panel_size_x      = 800 --面板大小
local panel_size_y      = 260 --面板大小



local home_control_btn_obj = nil; --主界面入口按钮
local home_control_btn_listener_name = nil; --主界面入口按钮的监听id

local home_btn_table = {};--主界面的入口按钮
local control_panel = nil;
local control_button = nil;

local com_button = nil;
local inf_mel_button = nil;
local inf_mis_button = nil;
local inf_pik_button = nil;
local inf_spr_button = nil;
local cav_mel_button = nil;
local cav_mis_button = nil;
local cav_shk_button = nil;
local elph_button = nil;
local art_siege_button = nil;

local control_panel_btn_table = {};

local player_own_modify_faction = nil;

local toggle_ui = true

local created_pannel = 0;

		--==============================================================================--
							 -- UI--
		--==============================================================================--

--记录对象
local function recordObj(obj, btn_listener_name, obj_table) 
    local objInfo = {};
    objInfo["obj"] = obj; --对象
    objInfo["btn_listener_name"] = btn_listener_name; --对象的监听id，如果没有则为nil
    table.insert(obj_table, objInfo);
end

--获取一个记录对象的obj
local function getRecordObj(objInfo) 
    return  objInfo["obj"]
end

--获取一个记录对象的监听id
local function getRecordObjLisName(objInfo) 
    return  objInfo["btn_listener_name"]
end

local function add_control_button(parent, clsss_key, slot_icon_size, slot_icon, slot_label)
    local bt_name = UI_MOD_NAME .. "_character_panel_" .. clsss_key;
    local btn_listener_name = bt_name .. "_click_up"
    local bt = core:get_or_create_component(bt_name, "ui/templates/3k_btn_battle_control")
    parent:Adopt(bt:Address())
    bt:PropagatePriority(parent:Priority())
    UIComponent_resize(bt, slot_icon_size, slot_icon_size, true)
    bt:SetImagePath(slot_icon);
    bt:SetTooltipText(slot_label, true)
    recordObj(bt, btn_listener_name,  control_panel_btn_table);
    core:add_listener(
        btn_listener_name,
        "ComponentLClickUp",
        function(context)
            return bt == UIComponent(context.component)
        end,
        function(context)
            toggleControl(clsss_key);
            toggleButton();
        end,
        true
    )
    return bt;
end

--创建ui：关闭按钮
local function create_bt_close(parent)
    local bt_name = UI_MOD_NAME .. "_control_close_btn";
    local btn_listener_name = bt_name .. "_click_up"
    local bt = core:get_or_create_component(bt_name, "ui/templates/3k_btn_close_32")
    parent:Adopt(bt:Address())
    bt:PropagatePriority(parent:Priority())
    --bt:SetTooltipText("关闭", true)
    UIComponent_resize(bt, bt_close_size_x, bt_close_size_y, true)
    core:add_listener(
        btn_listener_name,
        "ComponentLClickUp",
        function(context)
            return bt == UIComponent(context.component)
        end,
        function(context)
            created_pannel= -1
            ModLog( "关闭界面 " .. created_pannel )
            control_panel:SetVisible(false) 
            for i = 1, #control_panel_btn_table do
                core:remove_listener(getRecordObjLisName(control_panel_btn_table[i]))
                UIComponent_destroy(getRecordObj(control_panel_btn_table[i]))
            end
            control_panel_btn_table = {}
                UIComponent_destroy(control_panel)
            control_panel = nil
            created_pannel = 0
            ModLog( "created_pannel 设置为 " .. created_pannel )
            static_id = static_id + 1;
            UI_MOD_NAME = "xyy_battle_panel"..static_id
            ModLog( UI_MOD_NAME )
        end,
        false
    )
    recordObj(bt, btn_listener_name,  control_panel_btn_table);
    return bt
end

function openControlPanel()
    if created_pannel == 0 then
        --界面为不可见
        local ui_root = core:get_ui_root()
        local ui_panel_name = UI_MOD_NAME .. "_panel";
        control_panel = core:get_or_create_component( ui_panel_name, "ui/templates/xyy_battle_control") --date.pack中自带的panel_frame.twui.xml布局文件
        ui_root:Adopt( control_panel:Address() )
        control_panel:PropagatePriority( ui_root:Priority() )
        local x,y,w,h = UIComponent_coordinates(ui_root)
        --设置panel的大小
        UIComponent_resize( control_panel, panel_size_x, panel_size_y, true )
        
        --移动panel的相对位置
        UIComponent_move_relative( control_panel, ui_root, (w-panel_size_x)/2, 100, false )
        
        --创建界面中的关闭按钮
        local bt_close = create_bt_close(control_panel)
        --移动关闭按钮的相对位置
        UIComponent_move_relative(bt_close, control_panel, panel_size_x - bt_close_size_x - 120, 20, false)
        
        
        com_button = add_control_button(control_panel, "com", 60, "ui/skins/default/battle_control/com.png", effect.get_localised_string("mod_xyy_battle_control_com"))
        UIComponent_move_relative(com_button, control_panel, (panel_size_x- 60)/2 - 160, 60, false)
        
        inf_mel_button = add_control_button(control_panel, "inf_mel", 60, "ui/skins/default/battle_control/inf_mel.png", effect.get_localised_string("mod_xyy_battle_control_inf_mel"))
        UIComponent_move_relative(inf_mel_button, control_panel, (panel_size_x- 60)/2 - 80, 60, false)
        
        inf_mis_button = add_control_button(control_panel, "inf_mis", 60, "ui/skins/default/battle_control/inf_mis.png", effect.get_localised_string("mod_xyy_battle_control_inf_mis"))
        UIComponent_move_relative(inf_mis_button, control_panel, (panel_size_x- 60)/2, 60, false)
        
        inf_pik_button = add_control_button(control_panel, "inf_pik", 60, "ui/skins/default/battle_control/inf_pik.png", effect.get_localised_string("mod_xyy_battle_control_inf_pik"))
        UIComponent_move_relative(inf_pik_button, control_panel, (panel_size_x- 60)/2 + 80, 60, false)
        
        inf_spr_button = add_control_button(control_panel, "inf_spr", 60, "ui/skins/default/battle_control/inf_spr.png", effect.get_localised_string("mod_xyy_battle_control_inf_spr"))
        UIComponent_move_relative(inf_spr_button, control_panel, (panel_size_x- 60)/2 + 160, 60, false)
        
        cav_mel_button = add_control_button(control_panel, "cav_mel", 60, "ui/skins/default/battle_control/cav_mel.png", effect.get_localised_string("mod_xyy_battle_control_cav_mel"))
        UIComponent_move_relative(cav_mel_button, control_panel, (panel_size_x- 60)/2 - 160, 140, false)
        
        cav_mis_button = add_control_button(control_panel, "cav_mis", 60, "ui/skins/default/battle_control/cav_mis.png", effect.get_localised_string("mod_xyy_battle_control_cav_mis"))
        UIComponent_move_relative(cav_mis_button, control_panel, (panel_size_x- 60)/2 - 80, 140, false)
        
        cav_shk_button = add_control_button(control_panel, "cav_shk", 60, "ui/skins/default/battle_control/cav_shk.png", effect.get_localised_string("mod_xyy_battle_control_cav_shk"))
        UIComponent_move_relative(cav_shk_button, control_panel, (panel_size_x- 60)/2, 140, false)
        
        elph_button = add_control_button(control_panel, "elph", 60, "ui/skins/default/battle_control/elph.png", effect.get_localised_string("mod_xyy_battle_control_elph"))
        UIComponent_move_relative(elph_button, control_panel, (panel_size_x- 60)/2 + 80, 140, false)
        
        art_siege_button = add_control_button(control_panel, "art_siege", 60, "ui/skins/default/battle_control/art_siege.png", effect.get_localised_string("mod_xyy_battle_control_art_siege"))
        UIComponent_move_relative(art_siege_button, control_panel, (panel_size_x- 60)/2 + 160, 140, false)
        
        created_pannel = 1;
        ModLog( "created_pannel 设置为 " .. created_pannel )
        control_panel:SetVisible(true)  
    elseif created_pannel == 1 then
        created_pannel= -1
        ModLog( "关闭界面 " .. created_pannel )
        control_panel:SetVisible(false) 
        for i = 1, #control_panel_btn_table do
            core:remove_listener(getRecordObjLisName(control_panel_btn_table[i]))
            UIComponent_destroy(getRecordObj(control_panel_btn_table[i]))
        end
        control_panel_btn_table = {}
        UIComponent_destroy(control_panel)
        control_panel = nil
        created_pannel = 0
        ModLog( "created_pannel 设置为 " .. created_pannel )
        static_id = static_id + 1;
        UI_MOD_NAME = "xyy_battle_panel"..static_id
        ModLog( UI_MOD_NAME )
    end
    toggleButton();
    
    bm:steal_escape_key_with_callback("battle_control_panel", function() 
        closePanel()
    end)
end

function closePanel()
    if created_pannel == 1 and control_panel then
        created_pannel= -1
        ModLog( "关闭界面 " .. created_pannel )
        control_panel:SetVisible(false) 
        for i = 1, #control_panel_btn_table do
            core:remove_listener(getRecordObjLisName(control_panel_btn_table[i]))
            UIComponent_destroy(getRecordObj(control_panel_btn_table[i]))
        end
        control_panel_btn_table = {}
        UIComponent_destroy(control_panel)
        control_panel = nil
        created_pannel = 0
        ModLog( "created_pannel 设置为 " .. created_pannel )
        static_id = static_id + 1;
        UI_MOD_NAME = "xyy_battle_panel"..static_id
        ModLog( UI_MOD_NAME )
        bm:release_escape_key_with_callback("battle_control_panel")
    end
end

local function create_button()
    local ui_root = core:get_ui_root()
    local button_name = UI_MOD_NAME .. "_button";
    local btn_listener_name = button_name .. "_click_up"
    control_button = core:get_or_create_component( button_name, "ui/templates/3k_btn_lieutenant")
    ui_root:Adopt( control_button:Address() )
    control_button:PropagatePriority( ui_root:Priority() )
    local x,y,w,h = UIComponent_coordinates(ui_root)
    --设置panel的大小
    UIComponent_resize( control_button, 60, 60, true )
    control_button:SetImagePath("ui/skins/default/battle_control/lieutenant.png");
    
    --移动panel的相对位置
    UIComponent_move_relative( control_button, ui_root, 25, 25, false )
    
    control_button:SetTooltipText(effect.get_localised_string("mod_xyy_battle_control_button"), true)
    
    ModLog( "created_pannel 设置为 " .. created_pannel )
    control_button:SetVisible(true) 
    
    core:add_listener(
        btn_listener_name,
        "ComponentLClickUp",
        function(context)
            --ModLog(tostring(context.component));
            return control_button == UIComponent(context.component)
        end,
        function(context)
            openControlPanel();
        end,
        true
    )
    
    return;
end

create_button()

function toggleButton()
    if com_button ~= nil then
        if control_table_have("com") then
            com_button:SetState( "selected" );
        else
            com_button:SetState( "active" );
        end
    end
    if inf_mel_button ~= nil then
        if control_table_have("inf_mel") then
            inf_mel_button:SetState( "selected" );
        else
            inf_mel_button:SetState( "active" );
        end
    end
    if inf_mis_button ~= nil then
        if control_table_have("inf_mis") then
            inf_mis_button:SetState( "selected" );
        else
            inf_mis_button:SetState( "active" );
        end
    end
    if inf_pik_button ~= nil then
        if control_table_have("inf_pik") then
            inf_pik_button:SetState( "selected" );
        else
            inf_pik_button:SetState( "active" );
        end
    end
    if inf_spr_button ~= nil then
        if control_table_have("inf_spr") then
            inf_spr_button:SetState( "selected" );
        else
            inf_spr_button:SetState( "active" );
        end
    end
    if cav_mel_button ~= nil then
        if control_table_have("cav_mel") then
            cav_mel_button:SetState( "selected" );
        else
            cav_mel_button:SetState( "active" );
        end
    end
    if cav_mis_button ~= nil then
        if control_table_have("cav_mis") then
            cav_mis_button:SetState( "selected" );
        else
            cav_mis_button:SetState( "active" );
        end
    end
    if cav_shk_button ~= nil then
        if control_table_have("cav_shk") then
            cav_shk_button:SetState( "selected" );
        else
            cav_shk_button:SetState( "active" );
        end
    end
    if elph_button ~= nil then
        if control_table_have("elph") then
            elph_button:SetState( "selected" );
        else
            elph_button:SetState( "active" );
        end
    end
    if art_siege_button ~= nil then
        if control_table_have("art_siege") then
            art_siege_button:SetState( "selected" );
        else
            art_siege_button:SetState( "active" );
        end
    end
    if is_control() then
        control_button:SetState( "selected" );
    else
        control_button:SetState( "active" );
    end
end

core:add_listener(
    "xyy_toggle_ui_pressed",
    "ShortcutTriggered",
    function(context) 
        return context.string == "toggle_ui";
    end,
    function()
        if toggle_ui then
            if control_button:Visible() then
                control_button:SetVisible(false)
            end
            toggle_ui = false;
        else
            if not control_button:Visible() then
                control_button:SetVisible(true)
            end
            toggle_ui = true;
        end
        if control_panel then
            openControlPanel();
        end
    end,
    true
);	

core:add_listener(
    "xyy_escape_menu_pressed",
    "ShortcutTriggered",
    function(context) 
        return context.string == "escape_menu";
    end,
    function()
        if toggle_ui then
            if control_panel and control_panel:Visible() then
                openControlPanel();
            end
        else
            if not control_button:Visible() then
                control_button:SetVisible(true)
            end
            toggle_ui = true;
        end
    end,
    true
);	


-- core:add_listener(
--     "button_parent_panel_moved",
--     "ComponentMoved",
--     function(context)
--         ModLog("ComponentMoved " .. context.string)
--         return context.string == "button_parent"
--     end,
--     function(context)
--         local panel = UIComponent(context.component)
--         local button = find_uicomponent( context, "button_rematch" )
--         if button and is_uicomponent(button) then
--             button:SetState( "inactive" )
--         end
--     end,
--     true
-- );

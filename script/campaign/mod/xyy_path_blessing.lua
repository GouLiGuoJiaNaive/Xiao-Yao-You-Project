
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

local static_id = 0

local UI_MOD_NAME = "xyy_path_blessing"

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

local path_level = 0;

local last_path = nil;
local currect_path = nil;

local path_panel_btn_table = {};

local toggle_ui = true

local local_faction = nil
        
local path_table = {
    "abundance",
    "destruction",
    "eruditio",
    "harmony",
    "nihility",
    "preservation",
    "the_hunt",
}

--检查UI开启状态的变量：
--  0 = 关闭
--  1 = 开启
-- -1 = 正在创建
local is_created_pannel = 0;

		--==============================================================================--
							 -- UI--
		--==============================================================================--

--记录注册的对象和监听器
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

--获取一个记录对象的监听器id
local function getRecordObjLisName(objInfo) 
    return  objInfo["btn_listener_name"]
end

--暂停
local function pause_timer(s)
    timer.sleep(s);
end

--添加一个按钮
local function add_path_button(parent, path_key, slot_icon, slot_label)
    local bt_name = UI_MOD_NAME .. "_character_panel_" .. path_key;
    local btn_listener_name = bt_name .. "_click_up"
    local bt = core:get_or_create_component(bt_name, "ui/templates/3k_btn_path_blessing")
    parent:Adopt(bt:Address())
    bt:PropagatePriority(parent:Priority())
    UIComponent_resize(bt, 120, 180, true)
    local locale = get_locale()
    if locale == "cn" then
      bt:SetImagePath("ui/skins/default/path/placeholder_cn.png");   
    elseif locale == "zh" then
      bt:SetImagePath("ui/skins/default/path/placeholder_zh.png");   
    end
    bt:SetTooltipText(effect.get_localised_string("mod_xyy_path_blessing_select"), true)
    recordObj(bt, btn_listener_name,  path_panel_btn_table);
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
            
            cm:wait_for_model_sp(function()
                if last_path 
                and last_path == currect_path
                and path_level < 3
                then
                    path_level = path_level + 1;
                end
                last_path = currect_path;
                
            end)
        end,
        true
    )
    return bt;
end

function shuffle_table(t)
    math.randomseed(os.time()*1000);
    math.random(100);
    math.random(100);
    math.random(100);
    local shuffled = {}
    for i, v in ipairs(t) do
        local pos = math.random(1, #shuffled + 1);
        table.insert(shuffled, pos, v)
    end
    for k, v in ipairs(shuffled) do
        ModLog(k..":"..v)
    end
    return shuffled;
end

local function add_confirm_button(parent, x, y)
    local bt_name = UI_MOD_NAME .. "_character_panel_confirm";
    local btn_listener_name = bt_name .. "_click_up"
    local bt = core:get_or_create_component(bt_name, "ui/templates/square_large_text_button")
    local character = cm:query_model():character_for_template(character_key);
    parent:Adopt(bt:Address())
    bt:PropagatePriority(parent:Priority())
    UIComponent_resize(bt, x, y, true)
    core:add_listener(
        btn_listener_name,
        "ComponentLClickUp",
        function(context)
            return bt == UIComponent(context.component)
        end,
        function(context)
            if currect_path then
                --隐藏商店面板
                if(parent ~= nil) then
                parent:SetVisible(false) 
                end
                --销毁商店面板中的所有按钮，并移除监听
                for i = 1, #store_panel_btn_table do
                    core:remove_listener(getRecordObjLisName(store_panel_btn_table[i]))
                    UIComponent_destroy(getRecordObj(store_panel_btn_table[i]))
                end
                store_panel_btn_table = {}
                
                --销毁商店面板
                UIComponent_destroy(parent)
                parent = nil
                
                static_id = static_id + 1
            end
        end,
        false
    )
    recordObj(bt, btn_listener_name,  store_panel_btn_table);
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
    UIComponent_resize(bt, bt_close_size_x, bt_close_size_y, true)
    core:add_listener(
        btn_listener_name,
        "ComponentLClickUp",
        function(context)
            return bt == UIComponent(context.component)
        end,
        function(context)
            is_created_pannel= -1
            ModLog( "关闭界面 " .. is_created_pannel )
            path_panel:SetVisible(false) 
            for i = 1, #path_panel_btn_table do
                core:remove_listener(getRecordObjLisName(path_panel_btn_table[i]))
                UIComponent_destroy(getRecordObj(path_panel_btn_table[i]))
            end
            path_panel_btn_table = {}
                UIComponent_destroy(path_panel)
            path_panel = nil
            is_created_pannel = 0
            ModLog( "is_created_pannel 设置为 " .. is_created_pannel )
            static_id = static_id + 1;
            UI_MOD_NAME = "xyy_battle_panel"..static_id
            ModLog( UI_MOD_NAME )
        end,
        false
    )
    recordObj(bt, btn_listener_name,  path_panel_btn_table);
    return bt
end

--开启/关闭主界面UI
function togglePanelVisible()
    if is_created_pannel == 0 then
        local ui_root = core:get_ui_root();
        local ui_panel_name = UI_MOD_NAME .. "_panel";
        path_panel = core:get_or_create_component( ui_panel_name, "ui/templates/xyy_path_blessing"); --选择模板文件
        ui_root:Adopt( path_panel:Address() );
        path_panel:PropagatePriority( ui_root:Priority() );
        local x,y,w,h = UIComponent_coordinates(ui_root);
        --设置panel的大小
        UIComponent_resize( path_panel, panel_size_x, panel_size_y, true );
        
        --移动panel的相对位置
        UIComponent_move_relative( path_panel, ui_root, (w-panel_size_x)/2, 100, false );
        
        --创建界面中的关闭按钮
        local bt_close = create_bt_close(path_panel);
        --移动关闭按钮的相对位置
        UIComponent_move_relative(bt_close, path_panel, panel_size_x - bt_close_size_x - 120, 20, false);
        
        local shuffled = shuffle_table(path_table);
        
        path_table = shuffled;
        
        path_1_button = add_path_button(path_panel, path_table[1], "ui/skins/default/path/"..path_table[1]..".png", effect.get_localised_string("mod_xyy_path_blessing_"..path_table[1]));
        UIComponent_move_relative(path_1_button, path_panel, 865, 250, false);
        
        path_2_button = add_path_button(path_panel, path_table[2], "ui/skins/default/path/"..path_table[2]..".png", effect.get_localised_string("mod_xyy_path_blessing_"..path_table[2]));
        UIComponent_move_relative(path_2_button, path_panel, 1001, 250, false);
        
        path_3_button = add_path_button(path_panel, path_table[3], "ui/skins/default/path/"..path_table[3]..".png", effect.get_localised_string("mod_xyy_path_blessing_"..path_table[3]));
        UIComponent_move_relative(path_3_button, path_panel, 1136, 250, false);
        
        path_4_button = add_path_button(path_panel, path_table[4], "ui/skins/default/path/"..path_table[4]..".png", effect.get_localised_string("mod_xyy_path_blessing_"..path_table[4]));
        UIComponent_move_relative(path_4_button, path_panel, 1272, 250, false);
        
        path_5_button = add_path_button(path_panel, path_table[5], "ui/skins/default/path/"..path_table[5]..".png", effect.get_localised_string("mod_xyy_path_blessing_"..path_table[5]));
        UIComponent_move_relative(path_5_button, path_panel, 932, 444, false);
        
        path_6_button = add_path_button(path_panel, path_table[6], "ui/skins/default/path/"..path_table[6]..".png", effect.get_localised_string("mod_xyy_path_blessing_"..path_table[6]));
        UIComponent_move_relative(path_6_button, path_panel, 1068, 444, false);
        
        path_7_button = add_path_button(path_panel, path_table[7], "ui/skins/default/path/"..path_table[7]..".png", effect.get_localised_string("mod_xyy_path_blessing_"..path_table[7]));
        
        local confirm_button =  add_confirm_button(character_panel, 500, 50)
        UIComponent_move_relative(confirm_button, character_panel, 860, 720, false)
    
        confirm_button:SetState( "down" )
        find_uicomponent(confirm_button, "button_txt"):SetStateText(effect.get_localised_string("mod_xyy_character_browser_confirm"))
        
        confirm_button:SetState( "inactive" )
        find_uicomponent(confirm_button, "button_txt"):SetStateText(effect.get_localised_string("mod_xyy_character_browser_confirm"))
    
        is_created_pannel = 1;
        ModLog( "is_created_pannel 设置为 " .. is_created_pannel );
        path_panel:SetVisible(true);
    elseif is_created_pannel == 1 then
        is_created_pannel= -1
        ModLog( "关闭界面 " .. is_created_pannel )
        path_panel:SetVisible(false) 
        for i = 1, #path_panel_btn_table do
            core:remove_listener(getRecordObjLisName(path_panel_btn_table[i]))
            UIComponent_destroy(getRecordObj(path_panel_btn_table[i]))
        end
        path_panel_btn_table = {}
        UIComponent_destroy(path_panel)
        path_panel = nil
        is_created_pannel = 0
        ModLog( "is_created_pannel 设置为 " .. is_created_pannel )
        static_id = static_id + 1;
        UI_MOD_NAME = "xyy_battle_panel"..static_id
        ModLog( UI_MOD_NAME )
    end
end

core:add_listener(
    "xyy_path_blessing",
    "FirstTickAfterWorldCreated", --进入存档后的第一时间
    function(context)
        return true
    end,

    function(context)
        --检测阮梅的所在势力
        local ruan_mei = cm:query_model():character_for_template("hlyjct")
        if ruan_mei and not ruan_mei:is_null_interface() and not ruan_mei:is_character_is_faction_recruitment_pool() then
            local_faction = ruan_mei:faction()
        end
        togglePanelVisible()
    end,
    false
)

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
local playerstore = {

}

local static_id = 0

local UI_MOD_NAME = "the_seven_kings"

local bt_close_size_x   = 36 --面板关闭按钮大小
local bt_close_size_y   = 36 --面板关闭按钮大小

local panel_size_x      = 1920 --面板大小
local panel_size_y      = 900 --面板大小



local home_store_btn_obj = nil; --主界面入口按钮
local home_store_btn_listener_name = nil; --主界面入口按钮的监听id

local home_btn_table = {};--主界面的入口按钮
local store_panel = nil;
local store_panel_btn_table = {};

local player_own_modify_faction = nil;

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

local function create_slot(parent, slot_icon_size, slot_icon, slot_label, character_key)
    local bt_name = UI_MOD_NAME .. slot_label .. "_store_btn";
    local btn_listener_name = bt_name .. "_click_up"
    local bt = core:get_or_create_component(bt_name, "ui/templates/3k_btn_medium")
    local character = cm:query_model():character_for_template(character_key);
    parent:Adopt(bt:Address())
    bt:PropagatePriority(parent:Priority())
    UIComponent_resize(bt, slot_icon_size, slot_icon_size, true)
    ModLog(character_key);
    if character 
    and not character:is_null_interface()
    and not character:is_dead()
    and not character:is_character_is_faction_recruitment_pool()
    and character:faction() == player_own_modify_faction:query_faction() 
    then
        bt:SetImagePath(slot_icon);
        bt:SetTooltipText(slot_label, true)
    else
        bt:SetImagePath("ui/skins/default/unknown_character_button.png");
        bt:SetTooltipText(effect.get_localised_string("mod_xyy_the_seven_kings_unknown"), true)
    end
--     core:add_listener(
--         btn_listener_name,
--         "ComponentLClickUp",
--         function(context)
--             return bt == UIComponent(context.component)
--         end,
--         function(context)
--             
--         end,
--         false
--     )
    recordObj(bt, btn_listener_name,  store_panel_btn_table);
    return bt;
end

--获取一个记录对象的obj
local function getRecordObj(objInfo) 
    return  objInfo["obj"]
end

--获取一个记录对象的监听id
local function getRecordObjLisName(objInfo) 
    return  objInfo["btn_listener_name"]
end

--创建ui：关闭按钮
local function create_bt_close(parent)
    local bt_name = UI_MOD_NAME .. "_store_close_btn";
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
            if(store_panel ~= nil) then
            store_panel:SetVisible(false) 
            end
            for i = 1, #store_panel_btn_table do
                core:remove_listener(getRecordObjLisName(store_panel_btn_table[i]))
                UIComponent_destroy(getRecordObj(store_panel_btn_table[i]))
            end
            store_panel_btn_table = {}
                UIComponent_destroy(store_panel)
            store_panel = nil
            created_pannel = 0
            static_id = static_id + 1;
            UI_MOD_NAME = "the_seven_kings"..static_id
            ModLog( UI_MOD_NAME )
        end,
        false
    )
    recordObj(bt, btn_listener_name,  store_panel_btn_table);
    return bt
end


local function togglePanelVisible()
    if created_pannel == -1 then
        ModLog( created_pannel )
        return;
    end
    if created_pannel == 1 then
        created_pannel = -1
        if store_panel:Visible() then
            store_panel:SetVisible(false);
        else
            created_pannel = 0;
            togglePanelVisible();
            return;
        end 
        for i = 1, #store_panel_btn_table do
            core:remove_listener(getRecordObjLisName(store_panel_btn_table[i]))
            UIComponent_destroy(getRecordObj(store_panel_btn_table[i]))
        end
        store_panel_btn_table = {}
        UIComponent_destroy(store_panel)
        store_panel = nil
        created_pannel = 0
        static_id = static_id + 1;
        UI_MOD_NAME = "the_seven_kings"..static_id
        ModLog( UI_MOD_NAME )
        return;

    end
    if created_pannel == 0 then
        created_pannel = -1;
        --界面为不可见
        local ui_root = core:get_ui_root()
        local ui_panel_name = UI_MOD_NAME .. "_panel";
        store_panel = core:get_or_create_component( ui_panel_name, "ui/templates/the_seven_kings") --date.pack中自带的panel_frame.twui.xml布局文件
        ui_root:Adopt( store_panel:Address() )
        store_panel:PropagatePriority( ui_root:Priority() )
        local x,y,w,h = UIComponent_coordinates(ui_root)
        --设置panel的大小
        UIComponent_resize( store_panel, panel_size_x, panel_size_y, true )
        --移动panel的相对位置
        UIComponent_move_relative( store_panel, ui_root, (w-panel_size_x)/2, (h-panel_size_y)/2, false )
        
        --创建界面中的关闭按钮
        local bt_close = create_bt_close(store_panel)
        --移动关闭按钮的相对位置
        UIComponent_move_relative(bt_close, store_panel, panel_size_x - bt_close_size_x - 350, 100, false)
        
        local slot_1 = create_slot(store_panel, 40, "ui/skins/default/the_seven_kings/hlyjp.png", effect.get_localised_string("mod_xyy_the_seven_kings_hlyjp"), "hlyjp")
        UIComponent_move_relative(slot_1, store_panel, 1245, 452,  false)
        
        local slot_2 = create_slot(store_panel, 40, "ui/skins/default/the_seven_kings/hlyjt.png", effect.get_localised_string("mod_xyy_the_seven_kings_hlyjt"), "hlyjt")
        UIComponent_move_relative(slot_2, store_panel, 1194, 578,  false)
        
        local slot_3 = create_slot(store_panel, 40, "ui/skins/default/the_seven_kings/hlyjm.png",  effect.get_localised_string("mod_xyy_the_seven_kings_hlyjm"), "hlyjm")
        UIComponent_move_relative(slot_3, store_panel, 997, 544,  false)
        
        local slot_4 = create_slot(store_panel, 40, "ui/skins/default/the_seven_kings/hlyjl.png",  effect.get_localised_string("mod_xyy_the_seven_kings_hlyjl"), "hlyjl")
        UIComponent_move_relative(slot_4, store_panel, 986, 430,  false)
        
        local slot_5 = create_slot(store_panel, 40, "ui/skins/default/the_seven_kings/hlyjo.png",  effect.get_localised_string("mod_xyy_the_seven_kings_hlyjo"), "hlyjo")
        UIComponent_move_relative(slot_5, store_panel, 871, 358,  false)
        
        local slot_6 = create_slot(store_panel, 40, "ui/skins/default/the_seven_kings/hlyjj.png",  effect.get_localised_string("mod_xyy_the_seven_kings_hlyjj"), "hlyjj")
        UIComponent_move_relative(slot_6, store_panel, 782, 290,  false)
        
        local slot_7 = create_slot(store_panel, 40, "ui/skins/default/the_seven_kings/hlyjq.png",   effect.get_localised_string("mod_xyy_the_seven_kings_hlyjq"), "hlyjq")
        UIComponent_move_relative(slot_7, store_panel, 615, 298,  false)
        
        --ui/campaign ui/faction_council_panel.twui.xml
        
        created_pannel = 1
        ModLog( "created_pannel 设置为 " .. created_pannel )
        store_panel:SetVisible(true) 
        ModLog( created_pannel )
        return;
    end
end


local function closeStorePanel()
    created_pannel= -1
    if(store_panel ~= nil) then
    store_panel:SetVisible(false) 
    end
    for i = 1, #store_panel_btn_table do
        core:remove_listener(getRecordObjLisName(store_panel_btn_table[i]))
        UIComponent_destroy(getRecordObj(store_panel_btn_table[i]))
    end
    store_panel_btn_table = {}
    
    UIComponent_destroy(store_panel)
    store_panel = nil
    created_pannel = 0
    static_id = static_id + 1;
    UI_MOD_NAME = "the_seven_kings"..static_id
    ModLog( UI_MOD_NAME )
end

--创建主界面的商店入口按钮
local function createHomeStoreButton()
    --获取系统的ui根节点
    local root = core:get_ui_root()
	--获取主界面的顶部父节点：派系那一排按钮
	local parent = find_uicomponent( root, "hud_campaign", "top_faction_header", "campaign_hud_faction_header", "button_parent", "button_group_management")

	if not parent or not is_uicomponent(parent) then
		return --不存在直接返回
	end
    --创建一个入口按钮，使用的是data.pack中自带的3k_btn_medium.twui.xml布局
    local home_store_btn_name = "the_seven_kings_home_button";
    local home_store_btn_listener_name = home_store_btn_name .. "_click_up"
    local menu_button = core:get_or_create_component( home_store_btn_name, "ui/templates/3k_btn_medium" ) -- data.pack
    --将该按钮位置放在parent下，那么这个新创建的按钮就在顶部那一排中了
    parent:Adopt(menu_button:Address())
    
    --设置按钮的属性
    menu_button:SetImagePath( "ui/skins/default/the_big_dipper_button.png" ) --图片
    menu_button:SetOpacity( true, 255 ) --不透明度
        --按钮的悬浮提示，如果将鼠标移到按钮上，即可显示按钮的名字
    menu_button:SetTooltipText( "[[col:flavour]]七星阵[[/col]]", true) 
    
    --给按钮设置监听
    core:add_listener(
        home_store_btn_listener_name ,
        "ComponentLClickUp",
        function(context)
            return UIComponent(context.component) == menu_button 
        end,
        function(context)
            local player_faction = cm:query_local_faction();--玩家的势力
            local query_faction = cm:query_faction(player_faction:name());
            togglePanelVisible()
        end,
        true
    )
    --
    recordObj(menu_button, home_store_btn_listener_name, home_btn_table);
end

--创建UI
local function createUI()
    createHomeStoreButton() --创建主界面的商店入口按钮
end

--销毁UI
local function destroyUI()
    --隐藏商店面板
    if(store_panel ~= nil) then
       store_panel:SetVisible(false) 
    end
  
    --销毁商店面板中的所有按钮，并移除监听
    for i = 1, #store_panel_btn_table do
        core:remove_listener(getRecordObjLisName(store_panel_btn_table[i]))
        UIComponent_destroy(getRecordObj(store_panel_btn_table[i]))
    end
    store_panel_btn_table = {}
    
    --销毁商店面板
    if(store_panel ~= nil) then
        UIComponent_destroy(store_panel)
        store_panel = nil
    end
    --销毁主界面的入口按钮,并移除监听
    for i = 1, #home_btn_table do
        getRecordObj(home_btn_table[i]):SetVisible(false)
        core:remove_listener( getRecordObjLisName(home_btn_table[i]))
        UIComponent_destroy( getRecordObj(home_btn_table[i]) )
    end
    home_btn_table ={}
end


		--==============================================================================--
							 -- Main Entry function 初始化--
		--==============================================================================--
-- local function pre_first_tick_callback( context )
--     ModLog( "playerstore_byhy============pre_first_tick_callback=================" )
--     createUI()
-- end



--添加监听
core:add_listener(
    "the_seven_kings_new_listener",
    "FirstTickAfterWorldCreated", --世界创建完成后的第一时间
    function(context)
        return true
    end,
    function(context)
        player_own_modify_faction = nil;
        local player_query_faction = cm:query_local_faction();--玩家的势力
        if player_query_faction then
            player_own_modify_faction = cm:modify_faction(player_query_faction);
        end
        if not cm:get_saved_value("the_seven_kings") then
            --设置伍腾龙的性格
            local hlyjt = cm:query_model():character_for_template("hlyjt");
            xyy_remove_all_traits(hlyjt);
            cm:modify_character(hlyjt):ceo_management():add_ceo("3k_main_ceo_trait_personality_cruel"); -- 残暴不仁
            cm:modify_character(hlyjt):ceo_management():add_ceo("3k_main_ceo_trait__personality_deceitful"); -- 奸佞狡猾
            cm:modify_character(hlyjt):ceo_management():add_ceo("3k_main_ceo_trait_personality_elusive"); -- 难以琢磨
            
            --设置炽燚的性格
            local hlyjm = cm:query_model():character_for_template("hlyjm");
            xyy_remove_all_traits(hlyjm);
            cm:modify_character(hlyjm):ceo_management():add_ceo("3k_main_ceo_trait_personality_reckless"); -- 鲁莽冒进
            cm:modify_character(hlyjm):ceo_management():add_ceo("3k_main_ceo_trait_personality_intimidating"); -- 咄咄逼人
            cm:modify_character(hlyjm):ceo_management():add_ceo("3k_main_ceo_trait_personality_brave"); -- 英勇无畏
            
            --设置南宫淼的性格
            local hlyjl = cm:query_model():character_for_template("hlyjl");
            xyy_remove_all_traits(hlyjl);
            cm:modify_character(hlyjl):ceo_management():add_ceo("3k_main_ceo_trait_personality_brilliant"); -- 天纵英才
            cm:modify_character(hlyjl):ceo_management():add_ceo("3k_main_ceo_trait_personality_aescetic"); -- 清心寡欲
            cm:modify_character(hlyjl):ceo_management():add_ceo("3k_main_ceo_trait_personality_charitable"); -- 义结天下
            
            --设置逸豪的性格
            local hlyjo = cm:query_model():character_for_template("hlyjo");
            xyy_remove_all_traits(hlyjo);
            cm:modify_character(hlyjo):ceo_management():add_ceo("3k_main_ceo_trait_personality_determined"); -- 心若磐石
            cm:modify_character(hlyjo):ceo_management():add_ceo("3k_main_ceo_trait_personality_disciplined"); -- 令行禁止
            cm:modify_character(hlyjo):ceo_management():add_ceo("3k_ytr_ceo_trait_personality_land_composed"); -- 沉着冷静
            
            --设置李长寿的性格
            local hlyjj = cm:query_model():character_for_template("hlyjj");
            xyy_remove_all_traits(hlyjj);
            cm:modify_character(hlyjj):ceo_management():add_ceo("3k_main_ceo_trait_personality_ambitious"); -- 雄心勃勃
            cm:modify_character(hlyjj):ceo_management():add_ceo("3k_main_ceo_trait_personality_charismatic"); -- 富有魅力
            cm:modify_character(hlyjj):ceo_management():add_ceo("3k_ytr_ceo_trait_personality_land_courageous"); -- 勇字当先
            
            cm:set_saved_value("the_seven_kings",true)
        end
    end,
    true
)



core:add_listener(
    "the_seven_kings_refresh",
    "FactionTurnStart",
    function(context)
        return context:faction():is_human();
    end,
    function(context)
        player_own_modify_faction = cm:modify_faction(context:faction());
    end,
    true
)

--添加ui销毁事件
core:add_ui_destroyed_callback( function( context ) destroyUI() end )
--添加ui创建事件
core:add_ui_created_callback( function( context ) createUI() end )


core:add_listener(
    "the_seven_kings_unlock_units",
    "FactionTurnStart",
    function(context)
        if not context:faction():is_dead() then
            return true
        end
    end,
    function(context)
        local query_faction = context:faction()
        local hlyjp = cm:query_model():character_for_template("hlyjp");
        local hlyjt = cm:query_model():character_for_template("hlyjt");
        local hlyjm = cm:query_model():character_for_template("hlyjm");
        local hlyjl = cm:query_model():character_for_template("hlyjl");
        local hlyjo = cm:query_model():character_for_template("hlyjo");
        local hlyjj = cm:query_model():character_for_template("hlyjj");
        local hlyjq = cm:query_model():character_for_template("hlyjq");
        if hlyjp 
        and not hlyjp:is_null_interface() 
        and not hlyjp:is_dead() 
        and not hlyjp:is_character_is_faction_recruitment_pool()
        and hlyjp:faction() == query_faction
        and hlyjt 
        and not hlyjt:is_null_interface() 
        and not hlyjt:is_dead()
        and not hlyjt:is_character_is_faction_recruitment_pool()
        and hlyjt:faction() == query_faction
        and hlyjm 
        and not hlyjm:is_null_interface() 
        and not hlyjm:is_dead()
        and not hlyjm:is_character_is_faction_recruitment_pool()
        and hlyjm:faction() == query_faction
        and hlyjl 
        and not hlyjl:is_null_interface() 
        and not hlyjl:is_dead() 
        and not hlyjl:is_character_is_faction_recruitment_pool()
        and hlyjl:faction() == query_faction
        and hlyjo 
        and not hlyjo:is_null_interface() 
        and not hlyjo:is_dead() 
        and not hlyjo:is_character_is_faction_recruitment_pool()
        and hlyjo:faction() == query_faction
        and hlyjj 
        and not hlyjj:is_null_interface() 
        and not hlyjj:is_dead() 
        and not hlyjj:is_character_is_faction_recruitment_pool()
        and hlyjj:faction() == query_faction
        and hlyjq 
        and not hlyjq:is_null_interface() 
        and not hlyjq:is_dead() 
        and not hlyjq:is_character_is_faction_recruitment_pool()
        and hlyjq:faction() == query_faction
        then
            if not cm:get_saved_value("the_seven_kings_event_"..query_faction:name()) and query_faction:is_human()
            then
                cm:trigger_incident(query_faction:name(),"the_seven_kings_event", true);
                cm:set_saved_value("the_seven_kings_event_"..query_faction:name(), true)
            end
            cm:modify_faction(query_faction):remove_event_restricted_unit_record("xyyhlyjbbuqu1")
            cm:modify_faction(query_faction):remove_event_restricted_unit_record("xyyhlyjbbuqu2")
            cm:modify_faction(query_faction):remove_event_restricted_unit_record("xyyhlyjbbuqu3")
            cm:modify_faction(query_faction):remove_event_restricted_unit_record("xyyhlyjbbuqu4")
            cm:modify_faction(query_faction):remove_event_restricted_unit_record("xyyhlyjbbuqu5")
            cm:modify_faction(query_faction):remove_event_restricted_unit_record("xyyhlyjbbuqu6")
            cm:modify_faction(query_faction):remove_event_restricted_unit_record("xyyhlyjbbuqu7")
        else
            cm:modify_faction(query_faction):add_event_restricted_unit_record("xyyhlyjbbuqu1")
            cm:modify_faction(query_faction):add_event_restricted_unit_record("xyyhlyjbbuqu2")
            cm:modify_faction(query_faction):add_event_restricted_unit_record("xyyhlyjbbuqu3")
            cm:modify_faction(query_faction):add_event_restricted_unit_record("xyyhlyjbbuqu4")
            cm:modify_faction(query_faction):add_event_restricted_unit_record("xyyhlyjbbuqu5")
            cm:modify_faction(query_faction):add_event_restricted_unit_record("xyyhlyjbbuqu6")
            cm:modify_faction(query_faction):add_event_restricted_unit_record("xyyhlyjbbuqu7")
            cm:set_saved_value("the_seven_kings_event_"..query_faction:name(), false)
        end
    end,
    true
)
local gst = xyy_gst:get_mod()


		--==============================================================================--
							 -- 本lua的局部变量--
		--==============================================================================--
local playerstore = {}

local static_id = 0

local menu_button = nil

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

local created_pannel = 0;

		--==============================================================================--
							 -- UI--
		--==============================================================================--




local function create_slot(parent, slot_icon_size, slot_icon, slot_label, character_key)
    local bt_name = UI_MOD_NAME .. slot_label .. "_store_btn";
    local btn_listener_name = bt_name .. "_click_up"
    local bt = core:get_or_create_component(bt_name, "ui/templates/3k_btn_medium")
    local character = gst.character_query_for_template(character_key);
    parent:Adopt(bt:Address())
    bt:PropagatePriority(parent:Priority())
    gst.UI_Component_resize(bt, slot_icon_size, slot_icon_size, true)
    ModLog(character_key);
    if character 
    and not character:is_null_interface()
    then
        if not character:is_dead()
        and not character:is_character_is_faction_recruitment_pool()
        and character:faction():name() == cm:query_local_faction(true):name() then
            bt:SetImagePath(slot_icon);
            bt:SetTooltipText(slot_label, true)
        elseif character:is_dead() then
            bt:SetImagePath(slot_icon);
            if gst.get_locale() == "cn" then
                bt:SetTooltipText(slot_label.."（已亡故）", true);
            else
                bt:SetTooltipText(slot_label.." (Died)", true);
            end
        elseif cm:is_multiplayer() 
        and diplomacy_manager:is_mp_coop_victory_enabled(cm:query_local_faction(true):name())
        and character:faction():is_human()
        then
            bt:SetImagePath(slot_icon);
            bt:SetTooltipText(slot_label, true)
        else
            bt:SetImagePath("ui/skins/default/unknown_character_button.png");
            bt:SetTooltipText(effect.get_localised_string("mod_xyy_the_seven_kings_unknown"), true)
        end
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
    gst.lib_recordObj(bt, btn_listener_name,  store_panel_btn_table);
    return bt;
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
            return bt == UIComponent(context.component)
        end,
        function(context)
            the_seven_kings_close_pannel()
        end,
        false
    )
    gst.lib_recordObj(bt, btn_listener_name,  store_panel_btn_table);
    return bt
end


local function openSevenKingPanel()
    if created_pannel == 1 then
        the_seven_kings_close_pannel()
        return;
    else
        --界面为不可见
        local ui_root = core:get_ui_root()
        local ui_panel_name = UI_MOD_NAME .. "_panel";
        store_panel = core:get_or_create_component( ui_panel_name, "ui/templates/the_seven_kings") --date.pack中自带的panel_frame.twui.xml布局文件
        ui_root:Adopt( store_panel:Address() )
        store_panel:PropagatePriority( ui_root:Priority() )
        local x,y,w,h = gst.UI_Component_coordinates(ui_root)
        --设置panel的大小
        gst.UI_Component_resize( store_panel, panel_size_x, panel_size_y, true )
        --移动panel的相对位置
        gst.UI_Component_move_relative( store_panel, ui_root, (w-panel_size_x)/2, (h-panel_size_y)/2, false )
        
        --创建界面中的关闭按钮
        local bt_close = create_bt_close(store_panel)
        --移动关闭按钮的相对位置
        gst.UI_Component_move_relative(bt_close, store_panel, panel_size_x - bt_close_size_x - 350, 100, false)
        
        local slot_1 = create_slot(store_panel, 40, "ui/skins/default/the_seven_kings/hlyjp.png", effect.get_localised_string("mod_xyy_the_seven_kings_hlyjp"), "hlyjp")
        gst.UI_Component_move_relative(slot_1, store_panel, 1245, 452,  false)
        
        local slot_2 = create_slot(store_panel, 40, "ui/skins/default/the_seven_kings/hlyjt.png", effect.get_localised_string("mod_xyy_the_seven_kings_hlyjt"), "hlyjt")
        gst.UI_Component_move_relative(slot_2, store_panel, 1194, 578,  false)
        
        local slot_3 = create_slot(store_panel, 40, "ui/skins/default/the_seven_kings/hlyjm.png",  effect.get_localised_string("mod_xyy_the_seven_kings_hlyjm"), "hlyjm")
        gst.UI_Component_move_relative(slot_3, store_panel, 997, 544,  false)
        
        local slot_4 = create_slot(store_panel, 40, "ui/skins/default/the_seven_kings/hlyjl.png",  effect.get_localised_string("mod_xyy_the_seven_kings_hlyjl"), "hlyjl")
        gst.UI_Component_move_relative(slot_4, store_panel, 986, 430,  false)
        
        local slot_5 = create_slot(store_panel, 40, "ui/skins/default/the_seven_kings/hlyjo.png",  effect.get_localised_string("mod_xyy_the_seven_kings_hlyjo"), "hlyjo")
        gst.UI_Component_move_relative(slot_5, store_panel, 871, 358,  false)
        
        local slot_6 = create_slot(store_panel, 40, "ui/skins/default/the_seven_kings/hlyjj.png",  effect.get_localised_string("mod_xyy_the_seven_kings_hlyjj"), "hlyjj")
        gst.UI_Component_move_relative(slot_6, store_panel, 782, 290,  false)
        
        local slot_7 = create_slot(store_panel, 40, "ui/skins/default/the_seven_kings/hlyjq.png",   effect.get_localised_string("mod_xyy_the_seven_kings_hlyjq"), "hlyjq")
        gst.UI_Component_move_relative(slot_7, store_panel, 615, 298,  false)
        
        --ui/campaign ui/faction_council_panel.twui.xml
        
        created_pannel = 1
        store_panel:SetVisible(true) 
        menu_button:SetState("selected")
        return;
    end
    CampaignUI.CreateModelCallbackRequest("xyy_callback_xyy_seven_king_panel_open");
end


local function closeSevenKingPanel()
    if(store_panel ~= nil) then
    store_panel:SetVisible(false) 
    end
    for i = 1, #store_panel_btn_table do
        core:remove_listener(gst.lib_getRecordObjLisName(store_panel_btn_table[i]))
        gst.UI_Component_destroy(gst.lib_getRecordObj(store_panel_btn_table[i]))
    end
    store_panel_btn_table = {}
    
    gst.UI_Component_destroy(store_panel)
    store_panel = nil
    created_pannel = 0
    static_id = static_id + 1;
    UI_MOD_NAME = "the_seven_kings"..static_id
    ModLog( UI_MOD_NAME )
    CampaignUI.CreateModelCallbackRequest("xyy_callback_xyy_seven_king_panel_close");
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
    menu_button = core:get_or_create_component( home_store_btn_name, "ui/templates/3k_btn_medium_toggle_panel" )
    parent:Adopt(menu_button:Address())
    menu_button:SetImagePath( "ui/skins/default/the_big_dipper_button.png" ) --图片
    gst.UI_Component_resize(menu_button, 50, 50, true)
    menu_button:SetTooltipText( "[[col:flavour]]七星阵[[/col]]", true) 
    core:add_listener(
        home_store_btn_listener_name ,
        "ComponentLClickUp",
        function(context)
            return UIComponent(context.component) == menu_button 
        end,
        function(context)
            local player_faction = cm:query_local_faction();--玩家的势力
            local query_faction = cm:query_faction(player_faction:name());
            if xyy_select_character_panel or roguelike_panel then
                return;
            end
            closeStorePanel();
            closeIllustrationPanel();
            close_roguelike_store_pannel();
            openSevenKingPanel();
        end,
        true
    )
    --
    gst.lib_recordObj(menu_button, home_store_btn_listener_name, home_btn_table);
    if cm:get_saved_value("enabled_character_pool") then
        add_menu_button()
    end
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
        core:remove_listener(gst.lib_getRecordObjLisName(store_panel_btn_table[i]))
        gst.UI_Component_destroy(gst.lib_getRecordObj(store_panel_btn_table[i]))
    end
    store_panel_btn_table = {}
    
    --销毁商店面板
    if(store_panel ~= nil) then
        gst.UI_Component_destroy(store_panel)
        store_panel = nil
    end
    --销毁主界面的入口按钮,并移除监听
    for i = 1, #home_btn_table do
        gst.lib_getRecordObj(home_btn_table[i]):SetVisible(false)
        core:remove_listener( gst.lib_getRecordObjLisName(home_btn_table[i]))
        gst.UI_Component_destroy( gst.lib_getRecordObj(home_btn_table[i]) )
    end
    home_btn_table ={}
    
    created_pannel = 0;
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
        if not cm:get_saved_value("the_seven_kings")
        and cm:query_model():campaign_name() == "3k_dlc04_start_pos" 
        then
            gst.character_add_to_recruit_pool("hlyjj","3k_main_faction_han_empire","3k_general_earth", false)
            gst.character_add_to_recruit_pool("hlyjt","3k_main_faction_han_empire","3k_general_earth", false)
            gst.character_add_to_recruit_pool("hlyjo","3k_main_faction_han_empire","3k_general_metal", false)
            gst.character_add_to_recruit_pool("hlyjl","3k_main_faction_han_empire","3k_general_water", false)
            gst.character_add_to_recruit_pool("hlyjm","3k_main_faction_han_empire","3k_general_wood", false)
            
            
             --设置伍腾龙
             local hlyjt = gst.character_query_for_template("hlyjt");
--              if not hlyjt:is_null_interface()
--              and not hlyjt:is_dead()
--              and not hlyjt:faction():is_human()
--              and not is_faction_have_tianshu(hlyjt:faction())
--              then
--                 cm:modify_character(hlyjt):apply_effect_bundle("satisfaction_debuff",-1)
--              end
             
             --设置炽燚
             local hlyjm = gst.character_query_for_template("hlyjm");
             
             --设置南宫淼
             local hlyjl = gst.character_query_for_template("hlyjl");
             gst.character_CEO_equip("hlyjl","3k_main_ancillary_weapon_blade_of_xiang_yu_faction","3k_main_ceo_category_ancillary_weapon");

             --设置逸豪
             local hlyjo = gst.character_query_for_template("hlyjo");

             --设置李长寿
             local hlyjj = gst.character_query_for_template("hlyjj");
             
            cm:set_saved_value("the_seven_kings",true)
        end
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
        return true
    end,
    function(context)
        local query_faction = context:faction()
        local hlyjp = gst.character_query_for_template("hlyjp");
        local hlyjt = gst.character_query_for_template("hlyjt");
        local hlyjm = gst.character_query_for_template("hlyjm");
        local hlyjl = gst.character_query_for_template("hlyjl");
        local hlyjo = gst.character_query_for_template("hlyjo");
        local hlyjj = gst.character_query_for_template("hlyjj");
        local hlyjq = gst.character_query_for_template("hlyjq");
        
        if cm:is_multiplayer() 
        and diplomacy_manager:is_mp_coop_victory_enabled(cm:query_local_faction(true):name())
        and context:faction():is_human()
        then
            if hlyjp 
            and not hlyjp:is_null_interface() 
            and not hlyjp:is_dead() 
            and not hlyjp:is_character_is_faction_recruitment_pool()
            and hlyjp:faction():is_human()
            and hlyjt 
            and not hlyjt:is_null_interface() 
            and not hlyjt:is_dead()
            and not hlyjt:is_character_is_faction_recruitment_pool()
            and hlyjt:faction():is_human()
            and hlyjm 
            and not hlyjm:is_null_interface() 
            and not hlyjm:is_dead()
            and not hlyjm:is_character_is_faction_recruitment_pool()
            and hlyjm:faction():is_human()
            and hlyjl 
            and not hlyjl:is_null_interface() 
            and not hlyjl:is_dead() 
            and not hlyjl:is_character_is_faction_recruitment_pool()
            and hlyjl:faction():is_human()
            and hlyjo 
            and not hlyjo:is_null_interface() 
            and not hlyjo:is_dead() 
            and not hlyjo:is_character_is_faction_recruitment_pool()
            and hlyjo:faction():is_human()
            and hlyjj 
            and not hlyjj:is_null_interface() 
            and not hlyjj:is_dead() 
            and not hlyjj:is_character_is_faction_recruitment_pool()
            and hlyjj:faction():is_human()
            and hlyjq 
            and not hlyjq:is_null_interface() 
            and not hlyjq:is_dead() 
            and not hlyjq:is_character_is_faction_recruitment_pool()
            and hlyjq:faction():is_human()
            then
                if not cm:get_saved_value("the_seven_kings_event_"..query_faction:name()) and query_faction:is_human()
                then
                    cm:trigger_incident(cm:get_saved_value("xyy_1p"),"the_seven_kings_event", true);
                    cm:trigger_incident(cm:get_saved_value("xyy_2p"),"the_seven_kings_event", true);
                    cm:set_saved_value("the_seven_kings_event_"..cm:get_saved_value("xyy_1p"), true)
                    cm:set_saved_value("the_seven_kings_event_"..cm:get_saved_value("xyy_2p"), true)
                end
                cm:modify_faction(cm:get_saved_value("xyy_1p")):remove_event_restricted_unit_record("xyyhlyjbbuqu1")
                cm:modify_faction(cm:get_saved_value("xyy_1p")):remove_event_restricted_unit_record("xyyhlyjbbuqu2")
                cm:modify_faction(cm:get_saved_value("xyy_1p")):remove_event_restricted_unit_record("xyyhlyjbbuqu3")
                cm:modify_faction(cm:get_saved_value("xyy_1p")):remove_event_restricted_unit_record("xyyhlyjbbuqu4")
                cm:modify_faction(cm:get_saved_value("xyy_1p")):remove_event_restricted_unit_record("xyyhlyjbbuqu5")
                cm:modify_faction(cm:get_saved_value("xyy_1p")):remove_event_restricted_unit_record("xyyhlyjbbuqu6")
                cm:modify_faction(cm:get_saved_value("xyy_1p")):remove_event_restricted_unit_record("xyyhlyjbbuqu7")
                
                cm:modify_faction(cm:get_saved_value("xyy_2p")):remove_event_restricted_unit_record("xyyhlyjbbuqu1")
                cm:modify_faction(cm:get_saved_value("xyy_2p")):remove_event_restricted_unit_record("xyyhlyjbbuqu2")
                cm:modify_faction(cm:get_saved_value("xyy_2p")):remove_event_restricted_unit_record("xyyhlyjbbuqu3")
                cm:modify_faction(cm:get_saved_value("xyy_2p")):remove_event_restricted_unit_record("xyyhlyjbbuqu4")
                cm:modify_faction(cm:get_saved_value("xyy_2p")):remove_event_restricted_unit_record("xyyhlyjbbuqu5")
                cm:modify_faction(cm:get_saved_value("xyy_2p")):remove_event_restricted_unit_record("xyyhlyjbbuqu6")
                cm:modify_faction(cm:get_saved_value("xyy_2p")):remove_event_restricted_unit_record("xyyhlyjbbuqu7")
            else
                cm:modify_faction(cm:get_saved_value("xyy_1p")):add_event_restricted_unit_record("xyyhlyjbbuqu1")
                cm:modify_faction(cm:get_saved_value("xyy_1p")):add_event_restricted_unit_record("xyyhlyjbbuqu2")
                cm:modify_faction(cm:get_saved_value("xyy_1p")):add_event_restricted_unit_record("xyyhlyjbbuqu3")
                cm:modify_faction(cm:get_saved_value("xyy_1p")):add_event_restricted_unit_record("xyyhlyjbbuqu4")
                cm:modify_faction(cm:get_saved_value("xyy_1p")):add_event_restricted_unit_record("xyyhlyjbbuqu5")
                cm:modify_faction(cm:get_saved_value("xyy_1p")):add_event_restricted_unit_record("xyyhlyjbbuqu6")
                cm:modify_faction(cm:get_saved_value("xyy_1p")):add_event_restricted_unit_record("xyyhlyjbbuqu7")
                
                cm:modify_faction(cm:get_saved_value("xyy_2p")):add_event_restricted_unit_record("xyyhlyjbbuqu1")
                cm:modify_faction(cm:get_saved_value("xyy_2p")):add_event_restricted_unit_record("xyyhlyjbbuqu2")
                cm:modify_faction(cm:get_saved_value("xyy_2p")):add_event_restricted_unit_record("xyyhlyjbbuqu3")
                cm:modify_faction(cm:get_saved_value("xyy_2p")):add_event_restricted_unit_record("xyyhlyjbbuqu4")
                cm:modify_faction(cm:get_saved_value("xyy_2p")):add_event_restricted_unit_record("xyyhlyjbbuqu5")
                cm:modify_faction(cm:get_saved_value("xyy_2p")):add_event_restricted_unit_record("xyyhlyjbbuqu6")
                cm:modify_faction(cm:get_saved_value("xyy_2p")):add_event_restricted_unit_record("xyyhlyjbbuqu7")
                    cm:set_saved_value("the_seven_kings_event_"..cm:get_saved_value("xyy_1p"), false)
                    cm:set_saved_value("the_seven_kings_event_"..cm:get_saved_value("xyy_2p"), false)
            end
        else
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
        end
    end,
    true
)

function the_seven_kings_close_pannel()
    if created_pannel == 0 then
        return;
    end
    created_pannel = -1
    if store_panel then
        store_panel:SetVisible(false);
        for i = 1, #store_panel_btn_table do
            core:remove_listener(gst.lib_getRecordObjLisName(store_panel_btn_table[i]))
            gst.UI_Component_destroy(gst.lib_getRecordObj(store_panel_btn_table[i]))
        end
        store_panel_btn_table = {}
        gst.UI_Component_destroy(store_panel)
        store_panel = nil
        created_pannel = 0
        static_id = static_id + 1;
    end
    menu_button:SetState("active")
    CampaignUI.CreateModelCallbackRequest("xyy_callback_xyy_seven_king_panel_close");
end

function check_seven_kings_available()
    local hlyjp = gst.character_query_for_template("hlyjp");
    if hlyjp 
    and not hlyjp:is_null_interface() 
    and hlyjp:is_dead() 
    then
        return false
    end
    local hlyjt = gst.character_query_for_template("hlyjt");
    if hlyjt 
    and not hlyjt:is_null_interface() 
    and hlyjt:is_dead() 
    then
        return false
    end
    local hlyjm = gst.character_query_for_template("hlyjm");
    if hlyjm 
    and not hlyjm:is_null_interface() 
    and hlyjm:is_dead() 
    then
        return false
    end
    local hlyjl = gst.character_query_for_template("hlyjl");
    if hlyjl 
    and not hlyjl:is_null_interface() 
    and hlyjl:is_dead() 
    then
        return false
    end
    local hlyjo = gst.character_query_for_template("hlyjo");
    if hlyjo 
    and not hlyjo:is_null_interface() 
    and hlyjo:is_dead() 
    then
        return false
    end
    local hlyjj = gst.character_query_for_template("hlyjj");
    if hlyjj 
    and not hlyjj:is_null_interface() 
    and hlyjj:is_dead() 
    then
        return false
    end
    local hlyjq = gst.character_query_for_template("hlyjq");
    if hlyjq 
    and not hlyjq:is_null_interface() 
    and hlyjq:is_dead() 
    then
        return false
    end
    return true
end
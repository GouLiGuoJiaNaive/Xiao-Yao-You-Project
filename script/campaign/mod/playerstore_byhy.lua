--参考链接：知乎，感谢Aya Magician的文章  https://zhuanlan.zhihu.com/p/145855054
--参考来自三国全面战争创意工坊的mod：The Gathering:Sanbox，感谢Inter-object大佬

--备注： 只有这一个lua脚本，看着也是比较乱的，不过注释很详细，感兴趣的mod制作者，可以优化一下代码结构，拆分一下这些funcation





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
-- local playerstore = {}

local static_id = 0

local UI_MOD_NAME = "playerStore_byHy0"

local bt_close_size_x   = 36 --面板关闭按钮大小
local bt_close_size_y   = 36 --面板关闭按钮大小

local panel_size_x      = 800 --面板大小
local panel_size_y      = 800 --面板大小

local bt_execute_size_x = 200 --按钮大小
local bt_execute_size_y = 50  --按钮大小

local locale;

-- local home_store_btn_obj = nil; --主界面入口按钮
-- local home_store_btn_listener_name = nil; --主界面入口按钮的监听id

local home_btn_table = {};--主界面的入口按钮
local store_panel = nil;--商店面板
local store_panel_btn_table = {};--商店面板中所有的按钮

local player_own_modify_faction = nil;--玩家势力的modify_faction()接口

local creaded_pannel = 0;

local last_random = 0;
local last_random1 = 0;

local guaranteed = 50;

local xyy_character_lottery_pool;

local xxy_character_up_pool = {'hlyjcj', 'hlyjco', 'hlyjcp'};

local all_character_detils = { 
    ['hlyjch'] = {['name']="钟离", ['subtype']='3k_general_earth'},
    ['hlyjci'] = {['name']="甘雨", ['subtype']='3k_general_water'},
    ['hlyjcj'] = {['name']="卡芙卡", ['subtype']='3k_general_fire'},
    ['hlyjck'] = {['name']="镜流", ['subtype']='3k_general_metal'},
    ['hlyjcl'] = {['name']="那维莱特", ['subtype']='3k_general_fire'},
    ['hlyjcm'] = {['name']="雷电将军", ['subtype']='3k_general_earth'},
    ['hlyjcn'] = {['name']="刻晴", ['subtype']='3k_general_metal'},
    ['hlyjco'] = {['name']="芙宁娜", ['subtype']='3k_general_water'},
    ['hlyjcp'] = {['name']="符玄", ['subtype']='3k_general_earth'},
    ['hlyjcq'] = {['name']="安柏", ['subtype']='3k_general_fire'},
    ['hlyjcr'] = {['name']="丽莎", ['subtype']='3k_general_water'},
    ['hlyjcs'] = {['name']="妮露", ['subtype']='3k_general_wood'},
};

local character_browser_list = {
    "hlyjch",
    "hlyjci",
    "hlyjcj",
    "hlyjck",
    "hlyjcl",
    "hlyjcm",
    "hlyjcn",
    "hlyjco",
    "hlyjcp",
    "hlyjcq",
    "hlyjcr",
    "hlyjcs",
    --"hlyjct",
    --"hlyjcu",
    --"hlyjcv",
    --"hlyjcw",
    --"hlyjcx",
    --"hlyjcy",
}

local items_names = sandbox.db_items

--初级氪金    ------------------精制-----------------

local random_item1_weapon = {
    --武器
    "refined,3k_main_ancillary_weapon_ceremonial_sword_refined,三公剑",
    "refined,3k_main_ancillary_weapon_halberd_refined,军用戟",
    "refined,3k_main_ancillary_weapon_two_handed_spear_refined,家传矛",
    "refined,3k_ytr_ancillary_weapon_2h_ball_mace_refined,双手锤",
    "refined,3k_ytr_ancillary_weapon_dual_maces_refined,鸳鸯锤",
    "refined,3k_ytr_ancillary_weapon_staff_refined,平衡棍"
}

local random_item1_armour = {
    --护甲
    "refined,3k_main_ancillary_armour_heavy_armour_wood_and_fire_refined,铁鳞甲",
    "refined,3k_main_ancillary_armour_light_armour_earth_metal_and_water_refined,游侠轻甲",
    "refined,3k_main_ancillary_armour_medium_armour_earth_and_metal_refined,老兵革甲",
    "refined,3k_main_ancillary_armour_medium_armour_wood_and_fire_refined,勇士精革甲",
    "refined,3k_main_ancillary_armour_strategist_light_armour_water_refined,天乩袍"
}

local random_item1_mount = {
    --马匹
    "refined,3k_main_ancillary_mount_black_thoroughbred,黑骏",
    "refined,3k_main_ancillary_mount_brown_thoroughbred,栗骏",
    "refined,3k_main_ancillary_mount_grey_thoroughbred,青骏",
    "refined,3k_main_ancillary_mount_red_thoroughbred,赤骏",
    "refined,3k_main_ancillary_mount_white_thoroughbred,白骏",
    "refined,3k_dlc06_ancillary_mount_elephant_refined,战象",
    "common,3k_dlc06_ancillary_mount_elephant_common,大象"
}

local random_item1_follower = {
    --随从
    "refined,3k_main_ancillary_follower_adept,巧匠",
    "refined,3k_main_ancillary_follower_artisan,工匠",
    "refined,3k_main_ancillary_follower_astronomer,钦天监",
    "refined,3k_main_ancillary_follower_bodyguard,侍卫",
    "refined,3k_main_ancillary_follower_cryptographer,阴书人",
    "refined,3k_main_ancillary_follower_eunuch,阉侍",
    "refined,3k_main_ancillary_follower_farm_manager,田庄司事",
    "refined,3k_main_ancillary_follower_farmer,农民",
    "refined,3k_main_ancillary_follower_foreman,工头",
    "refined,3k_main_ancillary_follower_law_enforcer,贼曹",
    "refined,3k_main_ancillary_follower_mathematician,筹算师",
    "refined,3k_main_ancillary_follower_merchant,商贾",
    "refined,3k_main_ancillary_follower_military_expert,历战勇士",
    "refined,3k_main_ancillary_follower_monk,道人",
    "refined,3k_main_ancillary_follower_officer,曹掾",
    "refined,3k_main_ancillary_follower_overseer,监工",
    "refined,3k_main_ancillary_follower_scholar,学士",
    "refined,3k_main_ancillary_follower_tax_collector,税吏",
    "refined,3k_dlc04_ancillary_follower_master_crafter,工匠大师",   
    "refined,3k_dlc06_ancillary_follower_shaman,巫觋",   
    "refined,3k_dlc06_ancillary_follower_translator,象胥" 
}

local random_item1_accessory = {
    --附件
    "refined,3k_main_ancillary_accessory_book_of_mountains_and_seas,《山海经》",
    "refined,3k_main_ancillary_accessory_book_of_songs,《诗经》",
    "refined,3k_main_ancillary_accessory_classic_of_filial_piety,《孝经》",
    "refined,3k_main_ancillary_accessory_clay_cup,陶杯",
    "refined,3k_main_ancillary_accessory_clay_dog,陶犬",
    "refined,3k_main_ancillary_accessory_clay_fish,陶鱼",
    "refined,3k_main_ancillary_accessory_clay_ox,陶牛",
    "refined,3k_main_ancillary_accessory_discourses_of_the_states,《国语》",
    "refined,3k_main_ancillary_accessory_iron_archer,铁弓手",
    "refined,3k_main_ancillary_accessory_iron_sickle,铁镰刀",    
    "refined,3k_main_ancillary_accessory_iron_snake,铁蛇",
    "refined,3k_main_ancillary_accessory_mozi,《墨子》",
    "refined,3k_main_ancillary_accessory_six_secret_teachings,《六韬》",
    "refined,3k_main_ancillary_accessory_stone_axe,石斧",
    "refined,3k_main_ancillary_accessory_stone_horse,石马",
    "refined,3k_main_ancillary_accessory_stone_monkey,石猴",
    "refined,3k_main_ancillary_accessory_stone_pig,石猪",
    "refined,3k_main_ancillary_accessory_stone_rat,石鼠",
    "refined,3k_main_ancillary_accessory_stone_rooster,石鸡",
    "refined,3k_main_ancillary_accessory_stone_statue_of_confucius,孔子石像",     
    "refined,3k_main_ancillary_accessory_strategies_of_the_warring_states,《战国策》",   
    "refined,3k_main_ancillary_accessory_the_nine_chapters_on_the_mathematical_art,《九章算术》",   
    "refined,3k_main_ancillary_accessory_the_three_strategies_of_the_duke_of_the_yellow_rock,《黄石公三略》",  
    "refined,3k_main_ancillary_accessory_wei_liaozi,《尉缭子》",   
    "refined,3k_main_ancillary_accessory_wuzi,《吴子》",   
    "refined,3k_main_ancillary_accessory_zhuangzi,《庄子》",   
    "refined,3k_main_ancillary_weapon_composite_bow_refined,复合弓",   
    "refined,3k_dlc06_ancillary_accessory_malaria_cure,薤叶芸香",   
    "refined,3k_dlc06_ancillary_accessory_tribute_chest_diplomacy_extraordinary,使节礼匣",   
    "refined,3k_dlc06_ancillary_accessory_tribute_chest_diplomacy_simple,商贩礼匣",   
    "refined,3k_dlc06_ancillary_accessory_tribute_chest_personal_extraordinary,将帅礼匣",   
    "refined,3k_dlc06_ancillary_accessory_tribute_chest_personal_simple,亲贵礼匣",   
    "refined,3k_dlc06_ancillary_accessory_tribute_chest_regional_extraordinary,工官礼匣",   
    "refined,3k_dlc06_ancillary_accessory_tribute_chest_regional_simple,民吏礼匣", 
    "common,3k_main_ancillary_accessory_water_clock,水钟"  
}



--高级氪金   ------------------------exceptional:优秀---------------------------------------------------

local random_item2_weapon={
    --武器
    "exceptional,3k_main_ancillary_weapon_ceremonial_sword_exceptional,通天剑",
    "exceptional,3k_main_ancillary_weapon_double_edged_sword_exceptional,杀阵剑",
    "exceptional,3k_main_ancillary_weapon_halberd_exceptional,羽林长戟",
    "exceptional,3k_main_ancillary_weapon_two_handed_spear_exceptional,遗古矛",
    "exceptional,3k_ytr_ancillary_weapon_2h_ball_mace_exceptional,长柄锤",
    "exceptional,3k_ytr_ancillary_weapon_dual_maces_exceptional,恒金锤",
    "exceptional,3k_ytr_ancillary_weapon_staff_exceptional,强化棍" 
}

local random_item2_armour={
     --护甲
    "extraordinary,3k_main_ancillary_armour_archer_light_armour_water_extraordinary,潜行衣",
    "extraordinary,3k_main_ancillary_armour_heavy_armour_fire_extraordinary,护身铁甲",
    "extraordinary,3k_main_ancillary_armour_heavy_armour_wood_extraordinary,硬铁铠",
    "extraordinary,3k_main_ancillary_armour_light_armour_earth_extraordinary,礼仪服饰",
    "extraordinary,3k_main_ancillary_armour_light_armour_metal_extraordinary,精雕轻甲",
    "extraordinary,3k_main_ancillary_armour_medium_armour_earth_extraordinary,贵族革甲",
    "extraordinary,3k_main_ancillary_armour_medium_armour_fire_extraordinary,猛士革甲",
    "extraordinary,3k_main_ancillary_armour_medium_armour_metal_extraordinary,宗师革甲",
    "extraordinary,3k_main_ancillary_armour_medium_armour_wood_extraordinary,护卫革甲",
    "extraordinary,3k_main_ancillary_armour_strategist_light_armour_water_extraordinary,方士袍",
    "extraordinary,ep_ancillary_armour_heavy_armour_fire_extraordinary,坚固鳞甲",
    "extraordinary,ep_ancillary_armour_heavy_armour_wood_extraordinary,坚韧护甲",
    "extraordinary,ep_ancillary_armour_light_armour_earth_extraordinary,厚重皮甲",
    "extraordinary,ep_ancillary_armour_light_armour_metal_extraordinary,巧工鳞甲",
    "extraordinary,ep_ancillary_armour_medium_armour_earth_extraordinary,巧匠护甲",
    "extraordinary,ep_ancillary_armour_medium_armour_fire_extraordinary,斗蟋甲",
    "extraordinary,ep_ancillary_armour_medium_armour_metal_extraordinary,贤圣甲袍",
    "extraordinary,ep_ancillary_armour_medium_armour_wood_extraordinary,密林之肤",
    "extraordinary,ep_ancillary_armour_strategist_light_armour_water_extraordinary,智者之裳"   
}

local random_item2_mount={
        --马匹
    "exceptional,3k_main_ancillary_mount_black_stallion,黑骥",
    "exceptional,3k_main_ancillary_mount_brown_stallion,栗骥",
    "exceptional,3k_main_ancillary_mount_grey_stallion,青骥",
    "exceptional,3k_main_ancillary_mount_red_stallion,赤骥",
    "exceptional,3k_main_ancillary_mount_white_stallion,白骥",
    "exceptional,3k_dlc06_ancillary_mount_elephant_exceptional,君王战象"
}


local random_item2_follower={
        --随从
    "exceptional,3k_main_ancillary_follower_architect,筑者",
    "exceptional,3k_main_ancillary_follower_concubine,媵妾",
    "exceptional,3k_main_ancillary_follower_confucian_sage,贤儒",
    "exceptional,3k_main_ancillary_follower_diviner,卜者",
    "exceptional,3k_main_ancillary_follower_engineer,攻械匠",
    "exceptional,3k_main_ancillary_follower_forge_master,锻师",
    "exceptional,3k_main_ancillary_follower_inspector,监军",
    "exceptional,3k_main_ancillary_follower_jade_sculptor,琢玉人",
    "exceptional,3k_main_ancillary_follower_land_shaper,营造师",
    "exceptional,3k_main_ancillary_follower_legalist_fanatic,申韩之徒",
    "exceptional,3k_main_ancillary_follower_local_administrator,本地望族",
    "exceptional,3k_main_ancillary_follower_master_craftsman,宗师匠人",
    "exceptional,3k_main_ancillary_follower_philosopher,贤哲",
    "exceptional,3k_main_ancillary_follower_professional_instuctor,专职教官",
    "exceptional,3k_main_ancillary_follower_provincial_advisor,郡丞",
    "exceptional,3k_main_ancillary_follower_spy_master,神纪密探",
    "exceptional,3k_main_ancillary_follower_tycoon,巨贾"
    
}


local random_item2_accessory={
        --附件
    "exceptional,3k_main_ancillary_accessory_art_of_war,《孙子兵法》",
    "exceptional,3k_main_ancillary_accessory_book_of_ceremonies,《仪礼》",
    "exceptional,3k_main_ancillary_accessory_book_of_changes,《易经》",
    "exceptional,3k_main_ancillary_accessory_book_of_rites,《礼记》",
    "exceptional,3k_main_ancillary_accessory_celestial_sphere,浑天仪",
    "exceptional,3k_main_ancillary_accessory_ceremonial_stone_axe,节钺",
    "exceptional,3k_main_ancillary_accessory_erya,《尔雅》",
    "exceptional,3k_main_ancillary_accessory_jade_archer,玉弓手",
    "exceptional,3k_main_ancillary_accessory_jade_horse,玉马",
    "exceptional,3k_main_ancillary_accessory_jade_horseman,玉骑士",
    "exceptional,3k_main_ancillary_accessory_jade_monkey,玉猴",
    "exceptional,3k_main_ancillary_accessory_jade_rooster,玉鸡",
    "exceptional,3k_main_ancillary_accessory_jade_sickle,玉镰刀",
    "exceptional,3k_main_ancillary_accessory_jade_snake,玉蛇",
    "exceptional,3k_main_ancillary_accessory_jade_statue_of_confucius,孔子玉雕",
    "exceptional,3k_main_ancillary_accessory_porcelain_cup,瓷杯",
    "exceptional,3k_main_ancillary_accessory_rites_of_zhou,《周礼》",
    "exceptional,3k_main_ancillary_accessory_the_methods_of_the_sima,《司马法》",
    "exceptional,3k_main_ancillary_weapon_composite_bow_exceptional,帝国弓",
    "exceptional,3k_dlc06_ancillary_accessory_flying_daggers,飞刀"
}

--超级氪金    -------------------------传奇、独特----------------------------------

local random_item3_weapon={
    --武器
    "legendary,3k_main_ancillary_weapon_ancient_silver_sword,古锭刀",
    "legendary,3k_main_ancillary_weapon_blade_of_xiang_yu_faction,项羽刀",
    "legendary,3k_main_ancillary_weapon_green_dragon_crescent_blade_faction,青龙偃月刀",
    "legendary,3k_main_ancillary_weapon_ma_su_faction,裂胆槊",
    "legendary,3k_main_ancillary_weapon_serpent_spear_faction,丈八蛇矛",
    "legendary,3k_main_ancillary_weapon_trident_halberd_faction,方天画戟",
    "legendary,3k_main_ancillary_weapon_trust_of_god_faction,倚天剑",
    "legendary,3k_dlc05_ancillary_weapon_white_tigers_claws_faction,白虎之爪",  
    "legendary,3k_main_ancillary_weapon_axes_of_the_bandit_queen_faction,血红姊妹",
    "legendary,3k_main_ancillary_weapon_shuang_gu_jian_faction,双股剑",
    "unique,3k_main_ancillary_weapon_two_handed_spear_unique,祖誓矛",
    "unique,3k_ytr_ancillary_weapon_2h_ball_mace_unique,破天锤",
    "unique,3k_ytr_ancillary_weapon_dual_maces_unique,天躯锤",
    "unique,3k_ytr_ancillary_weapon_staff_unique,纯元棍",
    "unique,3k_dlc06_ancillary_weapon_2h_ball_mace_king_shamoke_unique,蒺藜骨朵",
    "unique,3k_dlc06_ancillary_weapon_two_handed_axe_king_wutugu_unique,兀突骨的大斧",
    "unique,3k_main_ancillary_weapon_ceremonial_sword_unique,天极剑",
    "unique,3k_main_ancillary_weapon_double_edged_sword_unique,天子剑",
    "unique,3k_main_ancillary_weapon_dual_swords_unique,金兰剑",
    "unique,3k_main_ancillary_weapon_ganjiang,干将",
    "unique,3k_main_ancillary_weapon_halberd_unique,天命戟",
    "unique,3k_main_ancillary_weapon_moye,莫邪",
    "unique,3k_main_ancillary_weapon_the_blue_blade,青釭剑",
    "unique,3k_dlc07_ancillary_weapon_defence_of_levity,浮浪刃",
    "unique,3k_dlc07_ancillary_weapon_emperor_xian_weapon_unique,错金尚方剑",
    "unique,3k_dlc07_ancillary_weapon_fear_and_discipline,威厉对剑",
    "unique,3k_dlc07_ancillary_weapon_the_rule,铁律枪",
    "unique,3k_dlc06_ancillary_weapon_burning_mace_unique,烈焰锤",
    "unique,3k_main_ancillary_weapon_cleaver_of_mountains_unique,开山斧",
    "unique,3k_main_ancillary_weapon_giant_mace_unique,巨阙",
    "unique,3k_dlc04_ancillary_weapon_staff_zhang_jue_unique,张角之杖",
    "unique,3k_main_ancillary_weapon_two_handed_axe_unique,破胆斧头"
}

local random_item3_armour={
    --护甲
    "unique,3k_main_ancillary_armour_heavy_armour_fire_unique,炎坞甲",
    "unique,3k_main_ancillary_armour_heavy_armour_wood_unique,金龟铠",
    "unique,3k_main_ancillary_armour_light_armour_earth_unique,贵胄轻甲",
    "unique,3k_main_ancillary_armour_light_armour_metal_unique,宗师轻甲",
    "unique,3k_main_ancillary_armour_medium_armour_earth_unique,贵胄革甲",
    "unique,3k_main_ancillary_armour_medium_armour_fire_unique,火凤革甲",
    "unique,3k_main_ancillary_armour_medium_armour_metal_unique,匠神之灵",
    "unique,3k_main_ancillary_armour_medium_armour_wood_unique,卫御甲",
    "unique,ep_ancillary_armour_heavy_armour_fire_unique,龙鳞甲",
    "unique,ep_ancillary_armour_heavy_armour_wood_unique,天之盾",
    "unique,ep_ancillary_armour_light_armour_earth_unique,灵桃鳞皮",
    "unique,ep_ancillary_armour_light_armour_metal_unique,犬獒之灵",
    "unique,ep_ancillary_armour_medium_armour_earth_unique,百忍玉灵",
    "unique,ep_ancillary_armour_medium_armour_fire_unique,战意斗戎",
    "unique,ep_ancillary_armour_medium_armour_metal_unique,宗师之言",
    "unique,ep_ancillary_armour_medium_armour_wood_unique,林中仙鹤",
    "unique,ep_ancillary_armour_strategist_light_armour_water_unique,金丝螳螂袍", 
    "unique,3k_main_ancillary_armour_strategist_light_armour_water_unique,惊龙"
}

local random_item3_mount={
    --马匹
    "legendary,3k_main_ancillary_mount_dilu,的卢",
    "legendary,3k_main_ancillary_mount_heavenly_fire,天火",
    "legendary,3k_main_ancillary_mount_red_hare,赤兔",
    "legendary,3k_main_ancillary_mount_shadow_runner,绝影",
    "legendary,3k_dlc04_ancillary_mount_liu_chong,乌木王",
    "unique,3k_main_ancillary_mount_black_elite,黑骊",
    "unique,3k_main_ancillary_mount_brown_elite,腾黄",
    "unique,3k_main_ancillary_mount_grey_elite,青骢",
    "unique,3k_main_ancillary_mount_red_elite,赤骅",
    "unique,3k_main_ancillary_mount_white_elite,骕骦",
    "unique,3k_main_ancillary_mount_yellow_hoofed_thunder,爪黄飞电",
    "unique,3k_dlc06_ancillary_mount_elephant_unique,南中巨象"
}


local random_item3_follower={
    --随从
    --暂时注释北军校尉，为了不影响曹操和袁绍 "unique,3k_dlc07_ancillary_follower_northern_army_captain,北军校尉",
    "unique,3k_main_ancillary_follower_elite_trainer,精英教头",
    "unique,3k_main_ancillary_follower_hua_tuo,华佗",
    "unique,3k_main_ancillary_follower_prefect,县令",
    "unique,3k_main_ancillary_follower_professor,教授",
    "unique,3k_main_ancillary_follower_provincial_auditor,督邮"
}


local random_item3_accessory={
    --附件
    "legendary,3k_main_ancillary_accessory_crane_feather_fan,鹤羽扇",
    "legendary,3k_main_ancillary_accessory_imperial_jade_seal,玉玺",
    "legendary,3k_main_ancillary_weapon_bow_huang_zhong_faction,家传宝弓",
    "legendary,3k_main_ancillary_weapon_bow_lady_sun_faction,赤朱弓",
    "legendary,3k_main_ancillary_weapon_bow_taishi_ci_faction,风啸弓",
    "legendary,3k_main_ancillary_weapon_composite_bow_unique,黑螭弓",
    "legendary,3k_dlc04_ancillary_accessory_zhang_liang_unique,张梁的流珠",
    "legendary,3k_dlc04_ancillary_weapon_crossbow_prince_liu_chong_unique,辅汉弩",
    "unique,3k_main_ancillary_accessory_blade_of_seven_gems,七星刀",
    "unique,3k_main_ancillary_accessory_book_of_concealing_method,《遁甲天书》",
    "unique,3k_main_ancillary_accessory_book_of_documents,《书经》",
    "unique,3k_main_ancillary_accessory_earthquake_watching_device,地动仪",
    "unique,3k_main_ancillary_accessory_hua_tuos_manual,《青囊书》",
    "unique,3k_main_ancillary_accessory_king_of_jade_ge,王爵玉戈",
    "unique,3k_main_ancillary_accessory_south_pointing_chariot,指南车",
    "unique,3k_main_ancillary_accessory_the_emperor,皇帝",
    "unique,3k_dlc04_ancillary_accessory_calligraphy_set_unique,文房四宝",
    "unique,3k_dlc04_ancillary_accessory_nushe_bifa_unique,弩射秘法",
    "unique,3k_dlc04_ancillary_accessory_religious_bell_unique,信仰之铃",
    "unique,3k_dlc04_ancillary_weapon_bow_huangfu_song_unique,义真弓",
    "unique,3k_dlc06_ancillary_accessory_mulus_bell_unique,木鹿蒂钟",
    "unique,3k_dlc06_ancillary_weapon_bow_king_shamoke_unique,赤风",    
    "unique,3k_dlc07_ancillary_weapon_honour_manifested,彰誉弓",  
    "unique,3k_dlc07_ancillary_weapon_sequencer,天序弓",  
    "unique,3k_ytr_ancillary_accessory_book_of_earth,《地遁》",
    "unique,3k_ytr_ancillary_accessory_book_of_heaven,《天遁》",
    "unique,3k_ytr_ancillary_accessory_book_of_people,《人遁》"
}



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


--lua的table随机
local function getRandomValue(min,max)
    math.randomseed(os.time() + os.clock() * 100000000);
    return math.random(min,max);
end

local function get_xyy_character_lottery_pool()
    ModLog(type(cm:get_saved_value("xyy_character_lottery_pool")))
    if cm:get_saved_value("character_list") 
    and not cm:get_saved_value("xyy_character_lottery_pool")
    then
        xyy_character_lottery_pool = cm:get_saved_value("character_list")
        ModLog('发现存档中的旧变量记录 character_list'.. #character_list)
    else 
        xyy_character_lottery_pool = cm:get_saved_value("xyy_character_lottery_pool")
        ModLog('发现存档中的新变量记录 xyy_character_lottery_pool'.. #xyy_character_lottery_pool)
    end
end

local function remove_character_from_pool(key)
    for i, v in ipairs(xyy_character_lottery_pool) do
        if v == key then
            table.remove(xyy_character_lottery_pool, i)
            return
        end
    end
end

local function character_browser_list_remove(key)
    for i, v in ipairs(character_browser_list) do
        if v == key then
            table.remove(character_browser_list, i)
            return
        end
    end
end

local function in_xyy_character_pool(value)
    if not xyy_character_lottery_pool then
        get_xyy_character_lottery_pool()
    end
    for k, v in ipairs(xyy_character_lottery_pool) do
        if v == value then
            return true;
        end
    end
    return false;
end

local function in_xyy_character_browser_list(value)
    if not character_browser_list then
        character_browser_list = cm:get_saved_value("character_browser_list")
    end

    for k, v in ipairs(character_browser_list) do
        if v == value then
            return true;
        end
    end
    return false;
end

--创建ui：关闭按钮
local function create_bt_close(parent)
    local bt_name = UI_MOD_NAME .. "_store_close_btn";
    local btn_listener_name = bt_name .. "_click_up"
    local bt = core:get_or_create_component(bt_name, "ui/templates/3k_btn_close_32")
    parent:Adopt(bt:Address())
    bt:PropagatePriority(parent:Priority())
    bt:SetTooltipText(effect.get_localised_string("mod_xyy_store_main_tooltip_close_button"), true)
    UIComponent_resize(bt, bt_close_size_x, bt_close_size_y, true)
    core:add_listener(
        btn_listener_name,
        "ComponentLClickUp",
        function(context)
            return bt == UIComponent(context.component)
        end,
        function(context)
            creaded_pannel= -1
            ModLog( "playerstore_byhy============closeStorePanel=================" )
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
            UIComponent_destroy(store_panel)
            store_panel = nil
            creaded_pannel = 0
            static_id = static_id + 1;
            UI_MOD_NAME = "playerStore_byHy"..static_id
            ModLog( UI_MOD_NAME )
            --x, y, d, b, h = cm:get_camera_position();
            --effect.advice( "x="..x..", y="..y..", d="..d..", b="..b..", h="..h )
        end,
        false
    )
    recordObj(bt, btn_listener_name,  store_panel_btn_table);
    return bt
end

--创建ui：购买按钮
local function create_bt_buyItem(parent, btn_name, btn_xml, cost_money, random_item, button_txt)
    local btn_listener_name =  btn_name .. "_click_up"
    local bt_execute = core:get_or_create_component(btn_name,btn_xml)

    parent:Adopt(bt_execute:Address())
    bt_execute:PropagatePriority(parent:Priority())
    if btn_name == UI_MOD_NAME .. "_store_buy_btn16" then
        UIComponent_resize(bt_execute, 600, 200, true)
        find_uicomponent(bt_execute, "button_txt"):SetStateText(button_txt)
        bt_execute:SetState( "down" )
        find_uicomponent(bt_execute, "button_txt"):SetStateText(button_txt)
        bt_execute:SetState( "active" )
        bt_execute:SetImagePath("ui/skins/default/wish.png");
        
        local tooltip = effect.get_localised_string("mod_xyy_store_main_tooltip");
        tooltip = string.gsub(tooltip,"%%1", cost_money);
        bt_execute:SetTooltipText(tooltip, true);
        if #xyy_character_lottery_pool == 0 then
            bt_execute:SetImagePath("ui/skins/default/wish_unavailable.png");
            bt_execute:SetTooltipText(effect.get_localised_string("mod_xyy_store_main_tooltip_sold_out"), true);
        end
        
    else
        UIComponent_resize(bt_execute, bt_execute_size_x, bt_execute_size_y, true)
        find_uicomponent(bt_execute, "button_txt"):SetStateText(button_txt)
        bt_execute:SetState( "down" )
        find_uicomponent(bt_execute, "button_txt"):SetStateText(button_txt)
        bt_execute:SetState( "active" )
        local tooltip = effect.get_localised_string("mod_xyy_store_tooltip");
        tooltip = string.gsub(tooltip,"%%1", cost_money);
        bt_execute:SetTooltipText(tooltip, true)
        bt_execute:SetImagePath("ui/skins/default/duel_btn_gold_frame.png")
    end
    core:add_listener(
        btn_listener_name,
       "ComponentLClickUp",
        function(context)
            return bt_execute == UIComponent(context.component)
        end,
        function(context)
            local player_faction = player_own_modify_faction:query_faction();--玩家的势力
            local hlyjcp = cm:query_model():character_for_template("hlyjcp");
            if player_own_modify_faction then
                local can_create_ceo_tables = {}--可以创建ceo的道具集合
                local items = random_item;
                local ticket_points = 0;
                if cm:get_saved_value("ticket_points") then
                    ticket_points = cm:get_saved_value("ticket_points");
                end
                --cost_money = -1;
                if player_faction:treasury() >= cost_money or ticket_points > 0 then
                    if btn_name == UI_MOD_NAME .. "_store_buy_btn16" then
                        if #xyy_character_lottery_pool == 0 then
                            effect.advice(effect.get_localised_string("mod_xyy_store_main_message_sold_out"))
                            return true;
                        end
                        -- math.randomseed(tonumber(tostring(os.time()+os.clock()):reverse():sub(1, 9)))
                        local min = 0;
                        
                        if guaranteed <= 49 then
                            min = 1000 * (48 - guaranteed) /48
                        end
                        
                        local random = getRandomValue(min,1000)
                        
                        if hlyjcp 
                        and not hlyjcp:is_null_interface()
                        and not hlyjcp:is_dead()
                        and not hlyjcp:is_character_is_faction_recruitment_pool()
                        and hlyjcp:faction():name() == player_faction:name() 
                        then
                            random = getRandomValue(min,1050)
                        end
                        
                        ModLog("generate " .. random)
                        while random == last_random do
                            random = getRandomValue(min,1000) 
                            ModLog("generate " .. random)
                        end
                        last_random = random;
                        ModLog("random = " .. random)
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
                        elseif random > 940 and random <= 990 then
                            items = random_item3_accessory;
                        elseif random > 990 then
                            if ticket_points ==0 then
                                player_own_modify_faction:decrease_treasury( cost_money );
                            else
                            ticket_points = ticket_points - 1;
                            cm:set_saved_value("ticket_points", ticket_points);
                            end
                            
                            index = {};
                            
                            -- TODO: 建一个池子  这个池子里有两个up 加卡芙卡  
                            -- 在抽中角色的时候  如果池子有角色 就再走一次1-1000的随机数 大于500 卡芙卡 1-250 up角色1  251-499  up角色2
                            -- 这个up池空了之后  剩下的4个角色 xxy_character_up_pool
                            if in_xyy_character_pool("hlyjcj") then
                                table.insert(index, "hlyjcj");
                                table.insert(index, "hlyjcj");
                            end
                            
                            if in_xyy_character_pool("hlyjco") and (min < 990 or not in_xyy_character_pool("hlyjcj")) then
                                table.insert(index, "hlyjco");
                            end
                            
                            if in_xyy_character_pool("hlyjcp") and (min < 990 or not in_xyy_character_pool("hlyjcj")) then
                                table.insert(index, "hlyjcp");
                            end
                            
                            if not in_xyy_character_pool("hlyjcj")
                            and not in_xyy_character_pool("hlyjco")
                            and not in_xyy_character_pool("hlyjcp")
                            then
                                table.insert(index, xyy_character_lottery_pool[1]);
                            end
                            
                            cm:wait_for_model_sp(function()
                                local i = math.floor(cm:random_int(#index * 10000, 10000)/10000);
                                if index[i] == "hlyjco" then
                                    remove_character_from_pool("hlyjco")
                                    cm:modify_model():get_modify_episodic_scripting():register_instant_movie_by_record("3k_main_game_lost_yellow_turbans");
                                    local character = xyy_character_add("hlyjco", player_own_modify_faction:query_faction():name(), "3k_general_water");
                                    xyy_character_close_agent("hlyjco");
                                    cm:modify_character(character):reset_skills();
                                    incident = cm:modify_model():create_incident("summon_hlyjco");
                                    incident:add_character_target("target_character_1", character);
                                    incident:add_faction_target("target_faction_1", player_own_modify_faction:query_faction());
                                    incident:trigger(player_own_modify_faction, true);
                                    --设置和那维莱特的关系
                                    local neuvillette = cm:query_model():character_for_template("hlyjcl");
                                    if neuvillette and not neuvillette:is_null_interface() then
                                        cm:modify_character(character):apply_relationship_trigger_set(characterneuvillette, "3k_dlc05_relationship_trigger_set_startpos_romance");
                                    end
                                elseif index[i] == "hlyjcp" then
                                    remove_character_from_pool("hlyjcp")
                                    cm:modify_model():get_modify_episodic_scripting():register_instant_movie_by_record("3k_main_game_lost_earth_yuan_shu");
                                    local character = xyy_character_add("hlyjcp", player_own_modify_faction:query_faction():name(), "3k_general_earth");
                                    xyy_character_close_agent("hlyjcp");
                                    cm:modify_character(character):reset_skills();
                                    incident = cm:modify_model():create_incident("summon_hlyjcp");
                                    incident:add_character_target("target_character_1", character);
                                    incident:add_faction_target("target_faction_1", player_own_modify_faction:query_faction());
                                    incident:trigger(player_own_modify_faction, true);
                                elseif index[i] == "hlyjcj" then
                                    remove_character_from_pool("hlyjcj")
                                    cm:set_saved_value("is_player_have_kafka",true)
                                    cm:modify_model():get_modify_episodic_scripting():register_instant_movie_by_record("ep_faction_game_lost_sima_ai");
                                    local character = xyy_character_add("hlyjcj", player_own_modify_faction:query_faction():name(), "3k_general_fire");
                                    xyy_character_close_agent("hlyjcj");
                                    cm:modify_character(character):reset_skills();
                                    incident = cm:modify_model():create_incident("summon_hlyjcj");
                                    incident:add_character_target("target_character_1", character);
                                    incident:add_faction_target("target_faction_1", player_own_modify_faction:query_faction());
                                    incident:trigger(player_own_modify_faction, true);
                                elseif index[i] == "hlyjch" then
                                    remove_character_from_pool("hlyjch")
                                    local character = xyy_character_add("hlyjch", player_own_modify_faction:query_faction():name(), "3k_general_earth");
                                    xyy_character_close_agent("hlyjch");
                                    cm:modify_character(character):reset_skills();
                                    incident = cm:modify_model():create_incident("summon_hlyjch");
                                    incident:add_character_target("target_character_1", character);
                                    incident:add_faction_target("target_faction_1", player_own_modify_faction:query_faction());
                                    incident:trigger(player_own_modify_faction, true);
                                elseif index[i] == "hlyjci" then
                                    remove_character_from_pool("hlyjci")
                                    local character = xyy_character_add("hlyjci", player_own_modify_faction:query_faction():name(), "3k_general_water");
                                    xyy_character_close_agent("hlyjci");
                                    cm:modify_character(character):reset_skills();
                                    incident = cm:modify_model():create_incident("summon_hlyjci");
                                    incident:add_character_target("target_character_1", character);
                                    incident:add_faction_target("target_faction_1", player_own_modify_faction:query_faction());
                                    incident:trigger(player_own_modify_faction, true);
                                elseif index[i] == "hlyjck" then
                                    remove_character_from_pool("hlyjck")
                                    local character = xyy_character_add("hlyjck", player_own_modify_faction:query_faction():name(), "3k_general_metal");
                                    xyy_character_close_agent("hlyjck");
                                    cm:modify_character(character):reset_skills();
                                    incident = cm:modify_model():create_incident("summon_hlyjck");
                                    incident:add_character_target("target_character_1", character);
                                    incident:add_faction_target("target_faction_1", player_own_modify_faction:query_faction());
                                    incident:trigger(player_own_modify_faction, true);
                                elseif index[i] == "hlyjcl" then
                                    remove_character_from_pool("hlyjcl")
                                    local character = xyy_character_add("hlyjcl", player_own_modify_faction:query_faction():name(), "3k_general_fire");
                                    xyy_character_close_agent("hlyjcl");
                                    cm:modify_character(character):reset_skills();
                                    incident = cm:modify_model():create_incident("summon_hlyjcl");
                                    incident:add_character_target("target_character_1", character);
                                    incident:add_faction_target("target_faction_1", player_own_modify_faction:query_faction());
                                    incident:trigger(player_own_modify_faction, true);
                                    --设置和芙宁娜的关系
                                    local furina = cm:query_model():character_for_template("hlyjco");
                                    if furina and not furina:is_null_interface() then
                                        cm:modify_character(furina):apply_relationship_trigger_set(character, "3k_dlc05_relationship_trigger_set_startpos_romance");
                                    end
                                elseif index[i] == "hlyjcm" then
                                    remove_character_from_pool("hlyjcm")
                                    local character = xyy_character_add("hlyjcm", player_own_modify_faction:query_faction():name(), "3k_general_fire");
                                    xyy_character_close_agent("hlyjcm");
                                    cm:modify_character(character):reset_skills();
                                    incident = cm:modify_model():create_incident("summon_hlyjcm");
                                    incident:add_character_target("target_character_1", character);
                                    incident:add_faction_target("target_faction_1", player_own_modify_faction:query_faction());
                                    incident:trigger(player_own_modify_faction, true);
                                elseif index[i] == "hlyjcn" then
                                    remove_character_from_pool("hlyjcn")
                                    local character = xyy_character_add("hlyjcn", player_own_modify_faction:query_faction():name(), "3k_general_metal");
                                    xyy_character_close_agent("hlyjcn");
                                    cm:modify_character(character):reset_skills();
                                    incident = cm:modify_model():create_incident("summon_hlyjcn");
                                    incident:add_character_target("target_character_1", character);
                                    incident:add_faction_target("target_faction_1", player_own_modify_faction:query_faction());
                                    incident:trigger(player_own_modify_faction, true);
                                elseif index[i] == "hlyjcq" then
                                    remove_character_from_pool("hlyjcq")
                                    local character = xyy_character_add("hlyjcq", player_own_modify_faction:query_faction():name(), "3k_general_fire");
                                    xyy_character_close_agent("hlyjcq");
                                    cm:modify_character(character):reset_skills();
                                    incident = cm:modify_model():create_incident("summon_hlyjcq");
                                    incident:add_character_target("target_character_1", character);
                                    incident:add_faction_target("target_faction_1", player_own_modify_faction:query_faction());
                                    incident:trigger(player_own_modify_faction, true);
                                elseif index[i] == "hlyjcr" then
                                    remove_character_from_pool("hlyjcr")
                                    local character = xyy_character_add("hlyjcr", player_own_modify_faction:query_faction():name(), "3k_general_water");
                                    xyy_character_close_agent("hlyjcr");
                                    cm:modify_character(character):reset_skills();
                                    incident = cm:modify_model():create_incident("summon_hlyjcr");
                                    incident:add_character_target("target_character_1", character);
                                    incident:add_faction_target("target_faction_1", player_own_modify_faction:query_faction());
                                    incident:trigger(player_own_modify_faction, true);
                                elseif index[i] == "hlyjcs" then
                                    remove_character_from_pool("hlyjcs")
                                    local character = xyy_character_add("hlyjcs", player_own_modify_faction:query_faction():name(), "3k_general_wood");
                                    xyy_character_close_agent("hlyjcs");
                                    cm:modify_character(character):reset_skills();
                                    incident = cm:modify_model():create_incident("summon_hlyjcs");
                                    incident:add_character_target("target_character_1", character);
                                    incident:add_faction_target("target_faction_1", player_own_modify_faction:query_faction());
                                    incident:trigger(player_own_modify_faction, true);
                                end
                            end)
                            creaded_pannel= -1
                            ModLog( "playerstore_byhy============closeStorePanel=================" )
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
                            UIComponent_destroy(store_panel)
                            store_panel = nil
                            creaded_pannel = 0
                            static_id = static_id + 1;
                            UI_MOD_NAME = "playerStore_byHy"..static_id
                            ModLog( UI_MOD_NAME )
                            cm:set_saved_value("guaranteed", 50);
                            guaranteed = 50;
                            return true;
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
                        if(player_own_modify_faction:ceo_management():query_faction_ceo_management():can_create_ceo(split_arr[2])) then
                             table.insert(can_create_ceo_tables, split_arr);
                            --ModLog( "####可以创建CEO####" .. split_arr[3] )
                        else
                            --ModLog( "====不能创建CEO======" .. split_arr[3] )
                        end
                    end
                    if(#can_create_ceo_tables <= 0) then
                        effect.advice(effect.get_localised_string("mod_xyy_store_main_tooltip_sold_out"))
                    else
                        --随机一个道具
                        local randomint = getRandomValue(1,#can_create_ceo_tables)
                        while randomint == last_random1 do
                            randomint = getRandomValue(1,#can_create_ceo_tables)
                        end
                        last_random1 = randomint;
                        ModLog(randomint)
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
                        
                        if btn_name == UI_MOD_NAME .. "_store_buy_btn16" then
                            guaranteed = guaranteed - 1;
                            cm:set_saved_value("guaranteed", guaranteed);
                            a = 50 - guaranteed;
                            
                            if ticket_points > 2 then
                                local message = effect.get_localised_string("mod_xyy_store_main_message_main_with_tickets");
                                message = string.gsub(message,"%%1", 1);
                                message = string.gsub(message,"%%2", quality_color);
                                message = string.gsub(message,"%%3", name);
                                message = string.gsub(message,"%%4", a);
                                message = string.gsub(message,"%%5", (ticket_points - 1));
                                
                                effect.advice(message)
                            elseif ticket_points > 0 then
                                local message = effect.get_localised_string("mod_xyy_store_main_message_main_with_ticket");
                                message = string.gsub(message,"%%1", 1);
                                message = string.gsub(message,"%%2", quality_color);
                                message = string.gsub(message,"%%3", name);
                                message = string.gsub(message,"%%4", a);
                                message = string.gsub(message,"%%5", (ticket_points - 1));
                                
                                effect.advice(message)
                            else
                                local message = effect.get_localised_string("mod_xyy_store_main_message_main_purchase");
                                message = string.gsub(message,"%%1", cost_money);
                                message = string.gsub(message,"%%2", quality_color);
                                message = string.gsub(message,"%%3", name);
                                message = string.gsub(message,"%%4", a);
                                
                                effect.advice(message)
                            end
                        else
                            if ticket_points > 2 then
                                local message = effect.get_localised_string("mod_xyy_store_main_message_with_tickets");
                                message = string.gsub(message,"%%1", 1);
                                message = string.gsub(message,"%%2", quality_color);
                                message = string.gsub(message,"%%3", name);
                                message = string.gsub(message,"%%4", (ticket_points - 1));
                                
                                effect.advice(message)
                            elseif ticket_points > 0 then
                                local message = effect.get_localised_string("mod_xyy_store_main_message_with_ticket");
                                message = string.gsub(message,"%%1", 1);
                                message = string.gsub(message,"%%2", quality_color);
                                message = string.gsub(message,"%%3", name);
                                message = string.gsub(message,"%%4", (ticket_points - 1));
                                
                                effect.advice(message)
                            else
                                local message = effect.get_localised_string("mod_xyy_store_main_message_purchase");
                                message = string.gsub(message,"%%1", cost_money);
                                message = string.gsub(message,"%%2", quality_color);
                                message = string.gsub(message,"%%3", name);
                                
                                effect.advice(message)
                            end
                        end
                        
                        if ticket_points > 0 then
                           ticket_points = ticket_points - 1;
                           cm:set_saved_value("ticket_points", ticket_points);
                        else
                            player_own_modify_faction:decrease_treasury( cost_money );
                        end
                        player_own_modify_faction:ceo_management():add_ceo(item[2])
                    end
                else
                    local message = effect.get_localised_string("mod_xyy_store_main_message_no_money");
                    message = string.gsub(message, "%%1", cost_money);
                    effect.advice(message);
                end
            end
        end,
        true
    )
    recordObj(bt_execute, btn_listener_name, store_panel_btn_table);
    return bt_execute
end


--如果商店panel存在，则直接切换（打开或者关闭）界面
local function togglePanelVisible()
    if creaded_pannel == -1 then
        ModLog( creaded_pannel )
        return;
    end
    if not cm:get_saved_value("xyy_character_lottery_pool") then 
        effect.advice(effect.get_localised_string("mod_xyy_store_unavailable"));
        return;
    end
--如果商店panel状态是开启
    if creaded_pannel == 1 then
        creaded_pannel = -1
        ModLog( "creaded_pannel 设置为 " .. creaded_pannel )
        ModLog( "开始关闭面板" )
        --如果商店panel不为空
        --if store_pane ~= nil and is_uicomponent(store_panel) then
        --如果商店panel的界面打开了
            if store_panel:Visible() then
                ModLog( "面板实例存在" )
                --隐藏商店面板
                store_panel:SetVisible(false);
                ModLog( "成功关闭面板" );
            else
                ModLog( "警告：关闭面板时发现面板存在实例但并未显示，尝试重设" );
                creaded_pannel = 0;
                ModLog( "creaded_pannel 设置为 " .. creaded_pannel )
                togglePanelVisible();
                return;
            end 
            ModLog( "销毁商店面板中的所有按钮，并移除监听" );
            for i = 1, #store_panel_btn_table do
                core:remove_listener(getRecordObjLisName(store_panel_btn_table[i]))
                UIComponent_destroy(getRecordObj(store_panel_btn_table[i]))
            end
            store_panel_btn_table = {}
            ModLog( "移除商店面板实例" );
            UIComponent_destroy(store_panel)
            store_panel = nil
            creaded_pannel = 0
            ModLog( "creaded_pannel 设置为 " .. creaded_pannel )
            ModLog( "面板已关闭" )
            static_id = static_id + 1;
            UI_MOD_NAME = "playerStore_byHy"..static_id
            ModLog( UI_MOD_NAME )
            return;
--         else
--             ModLog( "警告：面板实例不存在，尝试重设" )
--             creaded_pannel = 0;
--             ModLog( "creaded_pannel 设置为 " .. creaded_pannel )
--             togglePanelVisible();
--             return;
--         end
    end
    if creaded_pannel == 0 then
        creaded_pannel = -1
        ModLog( "creaded_pannel 设置为 " .. creaded_pannel )
        --界面为不可见
        ModLog( "开始创建面板" )
        effect.advice(effect.get_localised_string("mod_xyy_store_main_message_welcome"))
        local ui_root = core:get_ui_root()
        ModLog( "创建一个面板" )
        local ui_panel_name = UI_MOD_NAME .. "_store_panel";
        store_panel = core:get_or_create_component( ui_panel_name, "ui/templates/panel_frame_shop") --date.pack中自带的panel_frame.twui.xml布局文件
        ui_root:Adopt( store_panel:Address() )
        store_panel:PropagatePriority( ui_root:Priority() )
        --store_panel:SetOpacity( true, 255 ) --不透明度
        
        --store_panel:SetImagePath("ui/skins/default/luoyang_background.png")
        --store_panel:SetImagePath( "ui/skins/default/button_square_backplate.png" ) --图片 fast.pack
        local x,y,w,h = UIComponent_coordinates(ui_root)
        --设置panel的大小
        ModLog( "设置面板的大小" )
        UIComponent_resize( store_panel, panel_size_x, panel_size_y, true )
        --移动panel的相对位置
        UIComponent_move_relative( store_panel, ui_root, (w-panel_size_x)/2, (h-panel_size_y)/2, false )
        
        --创建界面中的关闭按钮
        local bt_close = create_bt_close(store_panel)
        --移动关闭按钮的相对位置
        UIComponent_move_relative(bt_close, store_panel, panel_size_x - bt_close_size_x - 50, 50, false)

        --创建购买按钮
        local button_relative = { --居中的三个位置，左、中、右
            {panel_size_x/2-bt_execute_size_x/2 - bt_execute_size_x ,panel_size_y/2-bt_execute_size_y/2},
            {panel_size_x/2-bt_execute_size_x/2,panel_size_y/2-bt_execute_size_y/2},
            {panel_size_x/2-bt_execute_size_x/2 + bt_execute_size_x,panel_size_y/2-bt_execute_size_y/2}
        }

        local all_buy_btn_list = {
            {effect.get_localised_string("mod_xyy_store_main_button_cropper")..":"..effect.get_localised_string("mod_xyy_store_main_button_weapon"),random_item1_weapon,1500,button_relative[1][1], button_relative[1][2] + bt_execute_size_y *3},
            {effect.get_localised_string("mod_xyy_store_main_button_cropper")..":"..effect.get_localised_string("mod_xyy_store_main_button_armor"),random_item1_armour,1200,button_relative[1][1], button_relative[1][2] + bt_execute_size_y *2},
            {effect.get_localised_string("mod_xyy_store_main_button_cropper")..":"..effect.get_localised_string("mod_xyy_store_main_button_mount"),random_item1_mount,1200,button_relative[1][1], button_relative[1][2] + bt_execute_size_y *1}, 
            {effect.get_localised_string("mod_xyy_store_main_button_cropper")..":"..effect.get_localised_string("mod_xyy_store_main_button_follower"),random_item1_follower,1000,button_relative[1][1], button_relative[1][2]- bt_execute_size_y *0},
            {effect.get_localised_string("mod_xyy_store_main_button_cropper")..":"..effect.get_localised_string("mod_xyy_store_main_button_accessory"),random_item1_accessory,1000,button_relative[1][1], button_relative[1][2]- bt_execute_size_y *1},
            
            {effect.get_localised_string("mod_xyy_store_main_button_silver")..":"..effect.get_localised_string("mod_xyy_store_main_button_weapon"),random_item2_weapon,3000,button_relative[2][1], button_relative[2][2] + bt_execute_size_y *3},
            {effect.get_localised_string("mod_xyy_store_main_button_silver")..":"..effect.get_localised_string("mod_xyy_store_main_button_armor"),random_item2_armour,2500,button_relative[2][1], button_relative[2][2] + bt_execute_size_y *2},
            {effect.get_localised_string("mod_xyy_store_main_button_silver")..":"..effect.get_localised_string("mod_xyy_store_main_button_mount"),random_item2_mount,2500,button_relative[2][1], button_relative[2][2] + bt_execute_size_y *1}, 
            {effect.get_localised_string("mod_xyy_store_main_button_silver")..":"..effect.get_localised_string("mod_xyy_store_main_button_follower"),random_item2_follower,2000,button_relative[2][1], button_relative[2][2] - bt_execute_size_y *0},
            {effect.get_localised_string("mod_xyy_store_main_button_silver")..":"..effect.get_localised_string("mod_xyy_store_main_button_accessory"),random_item2_accessory,2000,button_relative[2][1], button_relative[2][2]- bt_execute_size_y *1},
            
            {effect.get_localised_string("mod_xyy_store_main_button_gold")..":"..effect.get_localised_string("mod_xyy_store_main_button_weapon"),random_item3_weapon,6000,button_relative[3][1], button_relative[3][2] + bt_execute_size_y *3},
            {effect.get_localised_string("mod_xyy_store_main_button_gold")..":"..effect.get_localised_string("mod_xyy_store_main_button_armor"),random_item3_armour,4500,button_relative[3][1], button_relative[3][2] + bt_execute_size_y *2},
            {effect.get_localised_string("mod_xyy_store_main_button_gold")..":"..effect.get_localised_string("mod_xyy_store_main_button_mount"),random_item3_mount,4500,button_relative[3][1], button_relative[3][2] + bt_execute_size_y *1}, 
            {effect.get_localised_string("mod_xyy_store_main_button_gold")..":"..effect.get_localised_string("mod_xyy_store_main_button_follower"),random_item3_follower,3000,button_relative[3][1], button_relative[3][2]- bt_execute_size_y *0},
            {effect.get_localised_string("mod_xyy_store_main_button_gold")..":"..effect.get_localised_string("mod_xyy_store_main_button_accessory"),random_item3_accessory,3000,button_relative[3][1], button_relative[3][2]- bt_execute_size_y *1},
        
            {"[[col:pink]][[/b]][[/b]][[/col]]", random_item3_weapon, 5000, 100, 125}
        }
        for i=1,#all_buy_btn_list do
            if i == 16 then
                local bt_execute = create_bt_buyItem(store_panel, UI_MOD_NAME .. "_store_buy_btn" .. i,   "ui/templates/square_large_wish_button",all_buy_btn_list[i][3],all_buy_btn_list[i][2], all_buy_btn_list[i][1])
                ModLog( UI_MOD_NAME .. "_store_buy_btn" .. i .." :购买按钮的位置："  .. all_buy_btn_list[i][4] .. "、" .. all_buy_btn_list[i][5])
                UIComponent_move_relative(bt_execute, store_panel, all_buy_btn_list[i][4], all_buy_btn_list[i][5], false)
            else
                local bt_execute = create_bt_buyItem(store_panel, UI_MOD_NAME .. "_store_buy_btn" .. i,   "ui/templates/square_large_text_button",all_buy_btn_list[i][3],all_buy_btn_list[i][2], all_buy_btn_list[i][1])
                ModLog( i .. ":购买按钮的位置："  .. all_buy_btn_list[i][4] .. "、" .. all_buy_btn_list[i][5])
                UIComponent_move_relative(bt_execute, store_panel, all_buy_btn_list[i][4], all_buy_btn_list[i][5], false)
            end
        end
        creaded_pannel = 1
        store_panel:SetVisible(true) 
        ModLog( creaded_pannel )
        return;
    end
end

--创建商店界面
local function createStorePanel()
    --store_panel:SetVisible(false) 
end

--关闭商店
local function closeStorePanel()
    creaded_pannel= -1
    ModLog( "playerstore_byhy============closeStorePanel=================" )
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
    UIComponent_destroy(store_panel)
    store_panel = nil
    creaded_pannel = 0
    static_id = static_id + 1;
    UI_MOD_NAME = "playerStore_byHy"..static_id
    ModLog( UI_MOD_NAME )
    --x, y, d, b, h = cm:get_camera_position();
    --effect.advice( "x="..x..", y="..y..", d="..d..", b="..b..", h="..h )
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
    local home_store_btn_name = UI_MOD_NAME .. "_home_store_btn";
    local home_store_btn_listener_name = home_store_btn_name .. "_click_up"
    local menu_button = core:get_or_create_component( home_store_btn_name, "ui/templates/3k_btn_medium" ) -- data.pack
    --将该按钮位置放在parent下，那么这个新创建的按钮就在顶部那一排中了
    parent:Adopt(menu_button:Address())
    
    --设置按钮的属性
    menu_button:SetImagePath( "ui/skins/default/store2022.png" ) --图片
    menu_button:SetOpacity( true, 255 ) --不透明度
        --按钮的悬浮提示，如果将鼠标移到按钮上，即可显示按钮的名字
    menu_button:SetTooltipText(effect.get_localised_string("mod_xyy_store_main_message_main_welcome"), true) 
    
    --给按钮设置监听
    core:add_listener(
        home_store_btn_listener_name ,
        "ComponentLClickUp",
        function(context)
            return UIComponent(context.component) == menu_button --当鼠标点击的按钮==此按钮时，返回true，触发下面的 “点击函数”
        end,
        --“点击函数”
        function(context)
            local player_faction = cm:query_local_faction();--玩家的势力
            -- local query_faction = cm:query_faction(player_faction:name());
            togglePanelVisible()
        end,
        true
    )
    --
    recordObj(menu_button, home_store_btn_listener_name, home_btn_table);
end

--创建UI
local function createUI()
    ModLog( "playerstore_byhy============createUI=================" )
    createHomeStoreButton() --创建主界面的商店入口按钮
end

--销毁UI
local function destroyUI()
    ModLog( "playerstore_byhy============destroyUI=================" )
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
    "playerStore_api_byHy_listener",
    "FirstTickAfterWorldCreated", --进入存档后的第一时间
    function(context)
        return true
    end,

    function(context)
        local surname = effect.get_localised_string( 'names_name_2012172474' )
        if surname == "刘" then
            locale = 'cn'
        elseif surname == "劉" then
            locale = 'zh'
        else
            locale = 'en'
        end
        
        ModLog( "FirstTickAfterWorldCreated 成功,playerstore_byhy.lua 重置玩家派系的 modify_faction 为 nil")
        
        player_own_modify_faction = nil;
        local player_query_faction = cm:query_local_faction();--玩家的势力
        
        if player_query_faction then
            
            if cm:get_saved_value("guaranteed") then
                guaranteed = cm:get_saved_value("guaranteed");
                ModLog( "读取已用保底抽数:" .. guaranteed);
            end
            
            if cm:get_saved_value("character_browser_list") then
                character_browser_list = cm:get_saved_value("character_browser_list");
                ModLog("随机武将列表：");
                for k, v in ipairs(character_browser_list) do
                    ModLog(k ..": " .. all_character_detils[v]['name']);
                end
            else 
                cm:set_saved_value("character_browser_list", character_browser_list);
            end
            
            if cm:get_saved_value("xyy_character_lottery_pool") then 
                get_xyy_character_lottery_pool()
                ModLog("抽奖池列表：");
                for k, v in ipairs(xyy_character_lottery_pool) do
                    ModLog(k ..": " .. all_character_detils[v]['name']);
                end
                for char_id, char_info in pairs(all_character_detils) do
                    local query_character = cm:query_model():character_for_template(char_id);
                    ModLog( "=============================" );

                    if not in_xyy_character_pool(char_id) then
                        if not query_character
                        or query_character:is_null_interface()
                        and not in_xyy_character_browser_list(char_id) 
                        then
                            ModLog( char_info['name'] .. "不存在世界上，将添加进随机派系");
                            table.insert(character_browser_list, char_id);
                        end

                    elseif query_character 
                    and not query_character:is_null_interface() 
                    and not query_character:is_dead() 
		            then
                        ModLog( char_info['name'] .. "在" .. query_character:faction():name() .. "派系");

                    	if query_character:faction():is_human() 
                    	and not query_character:faction():is_character_is_faction_recruitment_pool()
                   	    then
                            ModLog( char_info['name'] .. "在玩家派系且不在武将招募池");
			            end

                        remove_character_from_pool(char_id);
                        character_browser_list_remove(char_id);
		            end
                end
                ModLog( "=============================" );
                cm:set_saved_value("xyy_character_lottery_pool", xyy_character_lottery_pool);
                cm:set_saved_value("character_browser_list", character_browser_list);
            end
            ModLog( "FirstTickAfterWorldCreated 成功,playerstore_byhy.lua 获得玩家派系的 modify_faction ");
            player_own_modify_faction = cm:modify_faction(player_query_faction);
        end
    end,
    true
)

core:add_listener(
    "playerStore_refresh",
    "FactionTurnStart",
    function(context)
        return context:faction():is_human();
    end,
    function(context)
        player_own_modify_faction = cm:modify_faction(context:faction());
    end,
    true
)

function playerstore_byhy()
    ModLog( "playerstore_byhy============Main Entry function=================" )
-- 	cm:add_pre_first_tick_callback( function( context )
-- 			pre_first_tick_callback( context )
-- 		end )
end

--添加ui销毁事件
core:add_ui_destroyed_callback( function( context ) destroyUI() end )
--添加ui创建事件
core:add_ui_created_callback( function( context ) createUI() end )


local function add_character_button(parent, slot_icon_size, slot_icon, slot_label, character_key)
    local bt_name = UI_MOD_NAME .. "_xyy_select_character_panel_" .. character_key;
    local btn_listener_name = bt_name .. "_click_up"
    local bt = core:get_or_create_component(bt_name, "ui/templates/3k_btn_large")
    -- local character = cm:query_model():character_for_template(character_key);
    parent:Adopt(bt:Address())
    bt:PropagatePriority(parent:Priority())
    UIComponent_resize(bt, slot_icon_size, slot_icon_size, true)
    bt:SetImagePath(slot_icon);
    bt:SetTooltipText(slot_label, true)
    --bt:SetImagePath("ui/skins/default/unknown_character_button.png");
    --bt:SetTooltipText(effect.get_localised_string("mod_xyy_the_seven_kings_unknown"), true)
    core:add_listener(
        btn_listener_name,
        "ComponentLClickUp",
        function(context)
            return bt == UIComponent(context.component)
        end,
        function(context)
            if #xyy_character_lottery_pool < 7 then
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
                
                table.insert(xyy_character_lottery_pool, character_key)
                
                
                for i, v in ipairs(character_browser_list) do
                    if v == character_key then
                        table.remove(character_browser_list, i)
                        break
                    end
                end
                
                static_id = static_id + 1
                
                character_browser()
            end
        end,
        false
    )
    recordObj(bt, btn_listener_name,  store_panel_btn_table);
    return bt;
end

local function add_character_pool(parent, slot_icon_size, slot_icon, slot_label, character_key, lock, can_remove)
    local bt_name = UI_MOD_NAME .. "_xyy_select_character_panel_" .. character_key;
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
    UIComponent_resize(bt, slot_icon_size, slot_icon_size, true)
    bt:SetImagePath(slot_icon);
    bt:SetTooltipText(slot_label, true)
    recordObj(bt, btn_listener_name,  store_panel_btn_table);
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
                    core:remove_listener(getRecordObjLisName(store_panel_btn_table[i]))
                    UIComponent_destroy(getRecordObj(store_panel_btn_table[i]))
                end
                store_panel_btn_table = {}
                
                --销毁商店面板
                UIComponent_destroy(parent)
                parent = nil
                
                for i, v in ipairs(xyy_character_lottery_pool) do
                    if v == character_key then
                        table.remove(xyy_character_lottery_pool, i)
                        break
                    end
                end
                
                table.insert(character_browser_list, character_key)
                
                static_id = static_id + 1
                
                character_browser()
            end
        end,
        false
    )
    return bt;
end

local function add_confirm_button(parent, x, y)
    local bt_name = UI_MOD_NAME .. "_xyy_select_character_panel_confirm";
    local btn_listener_name = bt_name .. "_click_up"
    local bt = core:get_or_create_component(bt_name, "ui/templates/square_large_text_button")
    -- local character = cm:query_model():character_for_template(character_key);
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
            if #xyy_character_lottery_pool == 7 then
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
                
                cm:wait_for_model_sp(function()
                    cm:set_saved_value("xyy_character_lottery_pool", xyy_character_lottery_pool)
                    cm:set_saved_value("character_browser_list", character_browser_list)
                end)
                static_id = static_id + 1
            end
        end,
        false
    )
    recordObj(bt, btn_listener_name,  store_panel_btn_table);
    return bt;
end

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
        and faction:name() ~= "xyyhlyjf"
        and faction:subculture() ~= "3k_main_subculture_yellow_turban"
        and faction:subculture() ~= "3k_dlc05_subculture_bandits"
        and faction:subculture() ~= "3k_dlc06_subculture_nanman";
    end,
    function(context)
        local faction = context:faction();
        local random = cm:random_int(1000, 0)
        if faction:name() == "3k_main_faction_cao_cao" then
            random = random - 100
        elseif faction:name() == "3k_main_faction_liu_bei" then
            random = random - 30
        elseif faction:name() == "3k_dlc05_faction_sun_ce" then
            random = random - 80
        elseif faction:name() == "3k_main_faction_yuan_shao" then
            random = random - 100
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
        ModLog(random)
        if random > 10 then
            return;
        end
        -- 从待入仕角色中随机选一个
        local character_id = character_browser_list[cm:random_int(#character_browser_list, i)]
        character_browser_list_remove(character_id);
        cm:set_saved_value("character_browser_list", character_browser_list)
        local character = cm:query_model():character_for_template(character_id)
        -- 如果角色已经入仕则取消
        if character and not character:is_null_interface() and character:faction():is_human() then
            return;
        end

        ModLog(all_character_detils[character_id]['name'].."加入了"..context:faction():name())

        -- 角色入仕的方法
        local function xyy_character_official(character_id, character_detil)
            -- 如果角色是卡芙卡，直接取消
            if character_id == 'hlyjcj' then
                ModLog('角色入仕：跳过 卡芙卡')
                return;
            end
            -- 角色开始入仕
            local character = cm:query_model():character_for_template(character_id)
            if not character or character:is_null_interface() then
                character = xyy_character_add(character_id, context:faction():name(), character_detil['subtype']);
                ModLog('刚刚' .. all_character_detils[character_id]['name'] .. "加入" .. context:faction():name())
                -- 角色特殊处理阶段
                -- 如果角色是那维莱特，设置和芙宁娜的关系
                if character_id == "hlyjcl" then
                    local furina = cm:query_model():character_for_template("hlyjco");
                    if furina and not furina:is_null_interface() then
                        cm:modify_character(furina):apply_relationship_trigger_set(character, "3k_dlc05_relationship_trigger_set_startpos_romance");
                    end
                -- 如果角色是芙宁娜，设置和那维莱特的关系
                elseif character_id == "hlyjco" then
                    local neuvillette = cm:query_model():character_for_template("hlyjcl");
                    if neuvillette and not neuvillette:is_null_interface() then
                        cm:modify_character(neuvillette):apply_relationship_trigger_set(character, "3k_dlc05_relationship_trigger_set_startpos_romance");
                    end
                end
                cm:modify_character(character):add_experience(88000,0);
            end
        end

        for char_id, char_info in pairs(all_character_detils) do
            if character_id == char_id then
                xyy_character_official(char_id, char_info)
            end
        end
    end,
    true
)

function character_browser()
    if not cm:get_saved_value("xyy_character_lottery_pool") then
        if not xyy_character_lottery_pool or xyy_character_lottery_pool == {} then
            xyy_character_lottery_pool = {}
            -- 商店里默认的3个up角色 分别是 卡夫卡：hlyjcj  芙宁娜：hlyjco  符玄：hlyjcp
            table.insert(xyy_character_lottery_pool, "hlyjcj");
            table.insert(xyy_character_lottery_pool, "hlyjco");
            table.insert(xyy_character_lottery_pool, "hlyjcp");
            
            for i, v in ipairs(xyy_character_lottery_pool) do
                character_browser_list_remove(v)
            end
        end
    else
        return;
    end

    -- 选择up角色的槽位
    local ui_root = core:get_ui_root()
    local ui_panel_name = UI_MOD_NAME .. "_xyy_select_character_panel" .. static_id;
    xyy_select_character_panel = core:get_or_create_component( ui_panel_name, "ui/xyy/character_browser_1") --date.pack中自带的panel_frame.twui.xml布局文件
    ui_root:Adopt( xyy_select_character_panel:Address() )
    xyy_select_character_panel:PropagatePriority(ui_root:Priority())
    
    local xoffset = 160;
    local yoffset = 220;
    
    -- 设置角色抽取池的永久up角色
    function set_permanent_slot(index)
        local slot = add_character_pool(xyy_select_character_panel, 160, "ui/skins/default/character_browser/".. xyy_character_lottery_pool[index] ..".png", effect.get_localised_string("mod_xyy_character_browser_".. xyy_character_lottery_pool[index]), xyy_character_lottery_pool[index], true, false)
        return slot
    end

    -- 设置角色抽取池的本期up角色
    function set_changeable_slot(index)
        if xyy_character_lottery_pool[index] then
            local slot = add_character_pool(xyy_select_character_panel, 160, "ui/skins/default/character_browser/".. xyy_character_lottery_pool[index] ..".png", effect.get_localised_string("mod_xyy_character_browser_".. xyy_character_lottery_pool[index]), xyy_character_lottery_pool[index], false, true)
        else
            local slot = add_character_pool(xyy_select_character_panel, 160, "ui/skins/default/character_browser/placeholder.png", effect.get_localised_string("mod_xyy_character_browser_unknown"), "unknown", false, false)
        end
        return slot
    end

    -- 创建槽位 
    local slot_list = {}
    for i = 1,7 do
        if i >= 3 then
            slot_list[i] = set_permanent_slot(i)
            UIComponent_move_relative(slot_list[i], xyy_select_character_panel, xoffset+180*i, yoffset, false)
        else 
            slot_list[i] = set_changeable_slot(i)
            UIComponent_move_relative(slot_list[i], xyy_select_character_panel, xoffset+180*i, yoffset, false)
        end
    end

    for i=1,#character_browser_list do
        local x = 310+120*((i-1)%11)
        local y = 450+120*math.floor((i-1)/11)
        ModLog(x..","..y);
        local slot = add_character_button(xyy_select_character_panel, 100, "ui/skins/default/character_browser/".. character_browser_list[i] ..".png", effect.get_localised_string("mod_xyy_character_browser_".. character_browser_list[i]), character_browser_list[i])
        UIComponent_move_relative(slot, xyy_select_character_panel, x, y, false)
    end
    
    -- 确认选择按钮
    local confirm_button =  add_confirm_button(xyy_select_character_panel, 800, 50)
    UIComponent_move_relative(confirm_button, xyy_select_character_panel, 560, 720, false)
    
    confirm_button:SetState( "down" )
    find_uicomponent(confirm_button, "button_txt"):SetStateText(effect.get_localised_string("mod_xyy_character_browser_confirm"))
    
    if #xyy_character_lottery_pool == 7 then
        confirm_button:SetState( "active" )
        find_uicomponent(confirm_button, "button_txt"):SetStateText(effect.get_localised_string("mod_xyy_character_browser_confirm"))
    else
        confirm_button:SetState( "inactive" )
        find_uicomponent(confirm_button, "button_txt"):SetStateText(effect.get_localised_string("mod_xyy_character_browser_confirm"))
    end
    
    xyy_select_character_panel:SetVisible(true) 
end

-- 超强老婆！ 点击即送！
cm:add_first_tick_callback(
function()
    core:add_listener(
        "abdication",
        "ComponentLClickUp",
        function(context)
            return context:component_id() == "CcoCampaignGroupCharacterActionRecordabdication_ct_char1";    
        end,
        function(context)  
            core:add_listener(
                "abdication_confirm",
                "ComponentLClickUp",
                function(context)
                    return context:component_id() == "button_tick" or context:component_id() == "button_cancel"
                end,
                function(context)                    
                    if context:component_id() == "button_tick" then
                        cm:wait_for_model_sp(
                        function() 
                            xyy_abdication_char(player_own_modify_faction:query_faction():name());
                        end
                        );
                    end;
                end,
                false
            );
        end,
        true
    );
    end
);
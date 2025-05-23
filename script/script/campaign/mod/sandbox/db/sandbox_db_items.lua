local sandbox = TheGathering_sandbox:get_sandbox_mod()

		--==============================================================================--
									-- Common Header --
		--==============================================================================--

local lib		= sandbox:get_library()
local loc 	 	= sandbox:get_localisation()
local logger 	= sandbox:get_logger()
local util		= sandbox:get_util()
local utf8		= sandbox:get_utf8()

local _eq = function( ... ) return logger:eq( ... ) end
local _ee = function( ... ) return logger:ee( ... ) end
local _to = function( ... ) return logger:to( ... ) end
local _te = function( ... ) return logger:te( ... ) end
local _tm = function( ... ) return logger:tm( ... ) end
local _on = function( ... ) return logger:on( ... ) end
local _hi = function( ... ) return logger:hi( ... ) end
local _nn = function( ... ) return logger:nn( ... ) end
local _nt = function( ... ) return logger:nt( ... ) end
local _nf = function( ... ) return logger:nf( ... ) end
local _pr = function( ... ) return logger:pr( ... ) end
local _no = function( ... ) return logger:no( ... ) end
local _n2 = function( ... ) return logger:nto2( ... ) end
local _e2 = function( ... ) return logger:eto2( ... ) end

local mod_advice = sandbox:get_mod_advice()
local mod_patterns = sandbox:get_mod_patterns()

---------------------------------------------------------------------------------------------

sandbox.tk_item_tiers =
{
	['legendary'] = 5, ['unique'] = 4, ['exceptional'] = 3, ['refined'] = 2, ['common'] = 1, ['none'] = 0
}

sandbox.db_item_aliases = {}
sandbox.db_item_users = {}

local item_ban_list = {
	['3k_dlc06_ancillary_weapon_axe_stone_common'] = true
}

sandbox.db_items =
{
--
['3k_cp01_ancillary_armour_guo_jias_armour_unique'] = { dlc = "cp01", category = "armour", tier = "unique", en = "Guo Jia's Armour", kr = "곽가의 갑옷", zh = "郭嘉的護甲", cn = "郭嘉的护甲",  },
['3k_cp01_ancillary_armour_huang_gais_armour_unique'] = { dlc = "cp01", category = "armour", tier = "unique", en = "Huang Gai's Armour", kr = "황개의 갑옷", zh = "黃蓋的護甲", cn = "黄盖的护甲",  },
['3k_cp01_ancillary_armour_jia_xus_armour_unique'] = { dlc = "cp01", category = "armour", tier = "unique", en = "Jia Xu's Armour", kr = "가후의 갑옷", zh = "賈詡的護甲", cn = "贾诩的护甲",  },
['3k_cp01_ancillary_armour_pang_tongs_armour_unique'] = { dlc = "cp01", category = "armour", tier = "unique", en = "Pang Tong's Armour", kr = "방통의 갑옷", zh = "龐統的護甲", cn = "庞统的护甲",  },
-- cp01 4
['3k_main_ancillary_weapon_ancient_silver_sword'] = { dlc = "tke", category = "weapon", tier = "legendary", en = "Ancient Silver Sword", kr = "고정도", zh = "古代銀劍", cn = "古锭刀",  },
['3k_main_ancillary_weapon_axes_of_the_bandit_queen_faction'] = { dlc = "tke", category = "weapon", tier = "legendary", en = "The Red Sisters", kr = "적혈쌍부", zh = "緋紅雙姝", cn = "血红姊妹",  },
['3k_main_ancillary_weapon_blade_of_xiang_yu_faction'] = { dlc = "tke", category = "weapon", tier = "legendary", en = "Blade of Xiang Yu", kr = "항우의 검", zh = "項羽刀", cn = "项羽刀",  },
['3k_main_ancillary_weapon_cleaver_of_mountains_unique'] = { dlc = "tke", category = "weapon", tier = "legendary", en = "Cleaver of Mountains", kr = "백염부", zh = "開山斧", cn = "开山斧",  },
['3k_main_ancillary_weapon_giant_mace_unique'] = { dlc = "tke", category = "weapon", tier = "legendary", en = "Giantbane", kr = "천근추", zh = "巨禍錘", cn = "巨阙",  },
['3k_main_ancillary_weapon_green_dragon_crescent_blade_faction'] = { dlc = "tke", category = "weapon", tier = "legendary", en = "Green Dragon Crescent Blade", kr = "청룡언월도", zh = "青龍偃月刀", cn = "青龙偃月刀",  },
['3k_main_ancillary_weapon_ma_su_faction'] = { dlc = "tke", category = "weapon", tier = "legendary", en = "Dread Bringer", kr = "금정개산월", zh = "摧心槊", cn = "裂胆槊",  },
['3k_main_ancillary_weapon_serpent_spear_faction'] = { dlc = "tke", category = "weapon", tier = "legendary", en = "Serpent Spear", kr = "장팔사모", zh = "丈八蛇矛", cn = "丈八蛇矛",  },
['3k_main_ancillary_weapon_shuang_gu_jian_faction'] = { dlc = "tke", category = "weapon", tier = "legendary", en = "Shuang Gu Jian", kr = "쌍고검", zh = "雙股劍", cn = "双股剑",  },
['3k_main_ancillary_weapon_trident_halberd_faction'] = { dlc = "tke", category = "weapon", tier = "legendary", en = "Sky Piercer", kr = "방천화극", zh = "方天畫戟", cn = "方天画戟",  },
['3k_main_ancillary_weapon_trust_of_god_faction'] = { dlc = "tke", category = "weapon", tier = "legendary", en = "Trust of God", kr = "의천검", zh = "倚天劍", cn = "倚天剑",  },
['3k_main_ancillary_weapon_ceremonial_sword_unique'] = { dlc = "tke", category = "weapon", tier = "unique", en = "Celestial Sword", kr = "하늘의 검", zh = "穹蒼劍", cn = "天极剑",  },
['3k_main_ancillary_weapon_double_edged_sword_unique'] = { dlc = "tke", category = "weapon", tier = "unique", en = "Sovereign of Blades", kr = "검의 제왕", zh = "至尊劍", cn = "天子剑",  },
['3k_main_ancillary_weapon_dual_swords_unique'] = { dlc = "tke", category = "weapon", tier = "unique", en = "Sworn Brothers", kr = "의형제", zh = "義結金蘭", cn = "金兰剑",  },
['3k_main_ancillary_weapon_ganjiang'] = { dlc = "tke", category = "weapon", tier = "unique", en = "Gan Jiang", kr = "간장", zh = "干將", cn = "干将",  },
['3k_main_ancillary_weapon_halberd_unique'] = { dlc = "tke", category = "weapon", tier = "unique", en = "Ji of Heavenly Mandate", kr = "천명의 극", zh = "天命之戟", cn = "天命戟",  },
['3k_main_ancillary_weapon_moye'] = { dlc = "tke", category = "weapon", tier = "unique", en = "Mo Ye", kr = "막야", zh = "莫邪", cn = "莫邪",  },
['3k_main_ancillary_weapon_the_blue_blade'] = { dlc = "tke", category = "weapon", tier = "unique", en = "The Blue Blade", kr = "청강검", zh = "青釭劍", cn = "青釭剑",  },
['3k_main_ancillary_weapon_two_handed_axe_unique'] = { dlc = "tke", category = "weapon", tier = "unique", en = "Eater of Courage", kr = "서용부", zh = "噬勇斧", cn = "破胆斧",  },
['3k_main_ancillary_weapon_two_handed_spear_unique'] = { dlc = "tke", category = "weapon", tier = "unique", en = "Ancestral Pledge", kr = "선조의 창", zh = "祖誓之槍", cn = "祖誓矛",  },
['3k_main_ancillary_weapon_ceremonial_sword_exceptional'] = { dlc = "tke", category = "weapon", tier = "exceptional", en = "Heavenly Sword", kr = "천상의 검", zh = "天劍", cn = "通天剑",  },
['3k_main_ancillary_weapon_double_edged_sword_exceptional'] = { dlc = "tke", category = "weapon", tier = "exceptional", en = "Warblade", kr = "전쟁용 검", zh = "戰刃劍", cn = "杀阵剑",  },
['3k_main_ancillary_weapon_dual_axes_exceptional'] = { dlc = "tke", category = "weapon", tier = "exceptional", en = "Dual War Axes", kr = "전쟁용 쌍도끼", zh = "雙手戰斧", cn = "双斧",  },
['3k_main_ancillary_weapon_dual_short_ji_exceptional'] = { dlc = "tke", category = "weapon", tier = "exceptional", en = "Twin Martial Ji", kr = "쌍극", zh = "雙短戟", cn = "双戟",  },
['3k_main_ancillary_weapon_dual_swords_exceptional'] = { dlc = "tke", category = "weapon", tier = "exceptional", en = "Kindred Jian", kr = "쌍둥이 검", zh = "子母劍", cn = "雌雄剑",  },
['3k_main_ancillary_weapon_halberd_exceptional'] = { dlc = "tke", category = "weapon", tier = "exceptional", en = "Ji of the Imperial Guard", kr = "황실 호위병의 극", zh = "禁軍戟", cn = "羽林长戟",  },
['3k_main_ancillary_weapon_hook_sickle_sabre_exceptional'] = { dlc = "tke", category = "weapon", tier = "exceptional", en = "War Glaive", kr = "전투용 구겸도", zh = "偃月刀", cn = "长战刀",  },
['3k_main_ancillary_weapon_one_handed_axe_exceptional'] = { dlc = "tke", category = "weapon", tier = "exceptional", en = "War Axe", kr = "전쟁 도끼", zh = "戰斧", cn = "战斧",  },
['3k_main_ancillary_weapon_short_ji_exceptional'] = { dlc = "tke", category = "weapon", tier = "exceptional", en = "Martial Ji", kr = "단극", zh = "短戟", cn = "武戟",  },
['3k_main_ancillary_weapon_two_handed_axe_exceptional'] = { dlc = "tke", category = "weapon", tier = "exceptional", en = "Battle Axe", kr = "전투 도끼", zh = "大斧", cn = "两手战斧",  },
['3k_main_ancillary_weapon_two_handed_spear_exceptional'] = { dlc = "tke", category = "weapon", tier = "exceptional", en = "Heirloom Spear", kr = "가보 창", zh = "傳家古槍", cn = "遗古矛",  },
['3k_main_ancillary_weapon_ceremonial_sword_refined'] = { dlc = "tke", category = "weapon", tier = "refined", en = "Noble's Sword", kr = "귀족의 검", zh = "名門佩劍", cn = "三公剑",  },
['3k_main_ancillary_weapon_double_edged_sword_refined'] = { dlc = "tke", category = "weapon", tier = "refined", en = "Military Jian", kr = "군용 검", zh = "軍用劍", cn = "军剑",  },
['3k_main_ancillary_weapon_dual_swords_refined'] = { dlc = "tke", category = "weapon", tier = "refined", en = "Matched Jian", kr = "균형잡힌 검", zh = "對劍", cn = "子母剑",  },
['3k_main_ancillary_weapon_halberd_refined'] = { dlc = "tke", category = "weapon", tier = "refined", en = "Military Ji", kr = "군용 극", zh = "軍用戟", cn = "军用戟",  },
['3k_main_ancillary_weapon_hook_sicle_sabre_refined'] = { dlc = "tke", category = "weapon", tier = "refined", en = "Great Glaive", kr = "거대 구겸도", zh = "戟刀", cn = "巨长刀",  },
['3k_main_ancillary_weapon_one_handed_axe_refined'] = { dlc = "tke", category = "weapon", tier = "refined", en = "Military Axe", kr = "군용 도끼", zh = "軍用斧", cn = "军斧",  },
['3k_main_ancillary_weapon_two_handed_axe_refined'] = { dlc = "tke", category = "weapon", tier = "refined", en = "Military Great Axe", kr = "군사용 거대 도끼", zh = "軍用巨斧", cn = "大战斧",  },
['3k_main_ancillary_weapon_two_handed_spear_refined'] = { dlc = "tke", category = "weapon", tier = "refined", en = "Family Spear", kr = "물려받은 창", zh = "家傳長槍", cn = "家传矛",  },
['3k_main_ancillary_weapon_double_edged_sword_common'] = { dlc = "tke", category = "weapon", tier = "common", en = "Jian", kr = "검", zh = "劍", cn = "剑",  },
['3k_main_ancillary_weapon_dual_swords_common'] = { dlc = "tke", category = "weapon", tier = "common", en = "Dual Jian", kr = "쌍검", zh = "雙劍", cn = "双剑",  },
['3k_main_ancillary_weapon_halberd_common'] = { dlc = "tke", category = "weapon", tier = "common", en = "Ji", kr = "극", zh = "戟", cn = "戟",  },
['3k_main_ancillary_weapon_hook_sickle_sabre_common'] = { dlc = "tke", category = "weapon", tier = "common", en = "Glaive", kr = "구겸도", zh = "大刀", cn = "长刀",  },
['3k_main_ancillary_weapon_one_handed_axe_common'] = { dlc = "tke", category = "weapon", tier = "common", en = "Axe", kr = "도끼", zh = "斧", cn = "斧",  },
['3k_main_ancillary_weapon_single_edged_sword_common'] = { dlc = "tke", category = "weapon", tier = "common", en = "Ceremonial Sword", kr = "예식용 검", zh = "儀典刀", cn = "宫仪剑",  },
['3k_main_ancillary_weapon_two_handed_axe_common'] = { dlc = "tke", category = "weapon", tier = "common", en = "Great Axe", kr = "거대 도끼", zh = "巨斧", cn = "巨斧",  },
['3k_main_ancillary_weapon_two_handed_spear_common'] = { dlc = "tke", category = "weapon", tier = "common", en = "Spear", kr = "창", zh = "長槍", cn = "矛",  },
['3k_main_ancillary_armour_archer_light_armour_water_unique'] = { dlc = "tke", category = "armour", tier = "unique", en = "Slayer's Skin", kr = "학살자의 피부", zh = "屠夫裝", cn = "凶裘",  },
['3k_main_ancillary_armour_cao_caos_armour_unique'] = { dlc = "tke", category = "armour", tier = "unique", en = "Cao Cao's Armour", kr = "조조의 갑옷", zh = "曹操的護甲", cn = "曹操的护甲",  },
['3k_main_ancillary_armour_dian_weis_armour_unique'] = { dlc = "tke", category = "armour", tier = "unique", en = "Dian Wei's Armour", kr = "전위의 갑옷", zh = "典韋的護甲", cn = "典韦的护甲",  },
['3k_main_ancillary_armour_dong_zhuos_armour_unique'] = { dlc = "tke", category = "armour", tier = "unique", en = "Dong Zhuo's Armour", kr = "동탁의 갑옷", zh = "董卓的護甲", cn = "董卓的护甲",  },
['3k_main_ancillary_armour_gan_nings_armour_unique'] = { dlc = "tke", category = "armour", tier = "unique", en = "Gan Ning's Armour", kr = "감녕의 갑옷", zh = "甘寧的護甲", cn = "甘宁的护甲",  },
['3k_main_ancillary_armour_gongsun_zans_armour_unique'] = { dlc = "tke", category = "armour", tier = "unique", en = "Gongsun Zan's Armour", kr = "공손찬의 갑옷", zh = "公孫瓚的護甲", cn = "公孙瓒的护甲",  },
['3k_main_ancillary_armour_guan_yus_armour_unique'] = { dlc = "tke", category = "armour", tier = "unique", en = "Guan Yu's Armour", kr = "관우의 갑옷", zh = "關羽的護甲", cn = "关羽的护甲",  },
['3k_main_ancillary_armour_han_suis_armour_unique'] = { dlc = "tke", category = "armour", tier = "unique", en = "Han Sui's Armour", kr = "한수의 갑옷", zh = "韓遂的護甲", cn = "韩遂的护甲",  },
['3k_main_ancillary_armour_heavy_armour_fire_unique'] = { dlc = "tke", category = "armour", tier = "unique", en = "Bastion of Fire", kr = "불의 수호자", zh = "火壘甲", cn = "炎坞甲",  },
['3k_main_ancillary_armour_heavy_armour_wood_unique'] = { dlc = "tke", category = "armour", tier = "unique", en = "Gilded Turtle", kr = "금박갑", zh = "鍍金龜甲", cn = "金龟铠",  },
['3k_main_ancillary_armour_huang_zhongs_armour_unique'] = { dlc = "tke", category = "armour", tier = "unique", en = "Huang Zhong's Armour", kr = "황충의 갑옷", zh = "黃忠的護甲", cn = "黄忠的护甲",  },
['3k_main_ancillary_armour_kong_rongs_armour_unique'] = { dlc = "tke", category = "armour", tier = "unique", en = "Kong Rong's Armour", kr = "공융의 갑옷", zh = "孔融的護甲", cn = "孔融的护甲",  },
['3k_main_ancillary_armour_lady_suns_armour_unique'] = { dlc = "tke", category = "armour", tier = "unique", en = "Sun Ren's Armour", kr = "손인의 갑옷", zh = "孫仁的護甲", cn = "孙仁的护甲",  },
['3k_main_ancillary_armour_light_armour_earth_unique'] = { dlc = "tke", category = "armour", tier = "unique", en = "Noble's Right", kr = "고귀한 자의 갑옷", zh = "名門寶甲", cn = "贵胄轻甲",  },
['3k_main_ancillary_armour_light_armour_metal_unique'] = { dlc = "tke", category = "armour", tier = "unique", en = "Master's Attire", kr = "거장의 복장", zh = "大師衣裝", cn = "宗师轻甲",  },
['3k_main_ancillary_armour_liu_beis_armour_unique'] = { dlc = "tke", category = "armour", tier = "unique", en = "Liu Bei's Armour", kr = "유비의 갑옷", zh = "劉備的護甲", cn = "刘备的护甲",  },
['3k_main_ancillary_armour_liu_biaos_armour_unique'] = { dlc = "tke", category = "armour", tier = "unique", en = "Liu Biao's Armour", kr = "유표의 갑옷", zh = "劉表的護甲", cn = "刘表的护甲",  },
['3k_main_ancillary_armour_liu_zhangs_armour_unique'] = { dlc = "tke", category = "armour", tier = "unique", en = "Liu Zhang's Armour", kr = "유장의 갑옷", zh = "劉璋的護甲", cn = "刘璋的护甲",  },
['3k_main_ancillary_armour_lu_bus_armour_unique'] = { dlc = "tke", category = "armour", tier = "unique", en = "Lü Bu's Armour", kr = "여포의 갑옷", zh = "呂布的護甲", cn = "吕布的护甲",  },
['3k_main_ancillary_armour_ma_chaos_armour_unique'] = { dlc = "tke", category = "armour", tier = "unique", en = "Ma Chao's Armour", kr = "마초의 갑옷", zh = "馬超的護甲", cn = "马超的护甲",  },
['3k_main_ancillary_armour_ma_tengs_armour_unique'] = { dlc = "tke", category = "armour", tier = "unique", en = "Ma Teng's Armour", kr = "마등의 갑옷", zh = "馬騰的護甲", cn = "马腾的护甲",  },
['3k_main_ancillary_armour_medium_armour_earth_unique'] = { dlc = "tke", category = "armour", tier = "unique", en = "Lord's Will", kr = "군주의 뜻", zh = "護主靈甲", cn = "贵胄革甲",  },
['3k_main_ancillary_armour_medium_armour_fire_unique'] = { dlc = "tke", category = "armour", tier = "unique", en = "Leather of the Fire Phoenix", kr = "봉추의 가죽 갑옷", zh = "火鳳皮甲", cn = "火凤革甲",  },
['3k_main_ancillary_armour_medium_armour_metal_unique'] = { dlc = "tke", category = "armour", tier = "unique", en = "Spirit of the First Artist", kr = "초대 예술가의 혼", zh = "祖師神甲", cn = "匠神之灵",  },
['3k_main_ancillary_armour_medium_armour_wood_unique'] = { dlc = "tke", category = "armour", tier = "unique", en = "Guardian", kr = "수호자", zh = "護衛", cn = "卫御甲",  },
['3k_main_ancillary_armour_shi_xies_armour_unique'] = { dlc = "tke", category = "armour", tier = "unique", en = "Shi Xie's Armour", kr = "사섭의 갑옷", zh = "士燮的護甲", cn = "士燮的护甲",  },
['3k_main_ancillary_armour_sima_yis_armour_unique'] = { dlc = "tke", category = "armour", tier = "unique", en = "Sima Yi's Armour", kr = "사마의의 갑옷", zh = "司馬懿的護甲", cn = "司马懿的护甲",  },
['3k_main_ancillary_armour_strategist_light_armour_water_unique'] = { dlc = "tke", category = "armour", tier = "unique", en = "Waking Dragon", kr = "깨어난 용", zh = "醒龍", cn = "惊龙",  },
['3k_main_ancillary_armour_sun_ces_armour_unique'] = { dlc = "tke", category = "armour", tier = "unique", en = "Sun Ce's Armour", kr = "손책의 갑옷", zh = "孫策的護甲", cn = "孙策的护甲",  },
['3k_main_ancillary_armour_sun_jians_armour_unique'] = { dlc = "tke", category = "armour", tier = "unique", en = "Sun Jian's Armour", kr = "손견의 갑옷", zh = "孫堅的護甲", cn = "孙坚的护甲",  },
['3k_main_ancillary_armour_sun_quans_armour_unique'] = { dlc = "tke", category = "armour", tier = "unique", en = "Sun Quan's Armour", kr = "손권의 갑옷", zh = "孫權的護甲", cn = "孙权的护甲",  },
['3k_main_ancillary_armour_taishi_cis_armour_unique'] = { dlc = "tke", category = "armour", tier = "unique", en = "Taishi Ci's Armour", kr = "태사자의 갑옷", zh = "太史慈的護甲", cn = "太史慈的护甲",  },
['3k_main_ancillary_armour_tao_qians_armour_unique'] = { dlc = "tke", category = "armour", tier = "unique", en = "Tao Qian's Armour", kr = "도겸의 갑옷", zh = "陶謙的護甲", cn = "陶谦的护甲",  },
['3k_main_ancillary_armour_xiahou_duns_armour_unique'] = { dlc = "tke", category = "armour", tier = "unique", en = "Xiahou Dun's Armour", kr = "하후돈의 갑옷", zh = "夏侯惇的護甲", cn = "夏侯惇的护甲",  },
['3k_main_ancillary_armour_xiahou_yuans_armour_unique'] = { dlc = "tke", category = "armour", tier = "unique", en = "Xiahou Yuan's Armour", kr = "하후연의 갑옷", zh = "夏侯淵的護甲", cn = "夏侯渊的护甲",  },
['3k_main_ancillary_armour_xu_chus_armour_unique'] = { dlc = "tke", category = "armour", tier = "unique", en = "Xu Chu's Armour", kr = "허저의 갑옷", zh = "許褚的護甲", cn = "许褚的护甲",  },
['3k_main_ancillary_armour_xu_huangs_armour_unique'] = { dlc = "tke", category = "armour", tier = "unique", en = "Xu Huang's Armour", kr = "서황의 갑옷", zh = "徐晃的護甲", cn = "徐晃的护甲",  },
['3k_main_ancillary_armour_yuan_shaos_armour_unique'] = { dlc = "tke", category = "armour", tier = "unique", en = "Yuan Shao's Armour", kr = "원소의 갑옷", zh = "袁紹的護甲", cn = "袁绍的护甲",  },
['3k_main_ancillary_armour_yuan_shus_armour_unique'] = { dlc = "tke", category = "armour", tier = "unique", en = "Yuan Shu's Armour", kr = "원술의 갑옷", zh = "袁術的護甲", cn = "袁术的护甲",  },
['3k_main_ancillary_armour_yue_jins_armour_unique'] = { dlc = "tke", category = "armour", tier = "unique", en = "Yue Jin's Armour", kr = "악진의 갑옷", zh = "樂進的護甲", cn = "乐进的护甲",  },
['3k_main_ancillary_armour_zhang_feis_armour_unique'] = { dlc = "tke", category = "armour", tier = "unique", en = "Zhang Fei's Armour", kr = "장비의 갑옷", zh = "張飛的護甲", cn = "张飞的护甲",  },
['3k_main_ancillary_armour_zhang_liaos_armour_unique'] = { dlc = "tke", category = "armour", tier = "unique", en = "Zhang Liao's Armour", kr = "장료의 갑옷", zh = "張遼的護甲", cn = "张辽的护甲",  },
['3k_main_ancillary_armour_zhang_lus_armour_unique'] = { dlc = "tke", category = "armour", tier = "unique", en = "Zhang Lu's Armour", kr = "장로의 갑옷", zh = "張魯的護甲", cn = "张鲁的护甲",  },
['3k_main_ancillary_armour_zhang_yans_armour_unique'] = { dlc = "tke", category = "armour", tier = "unique", en = "Zhang Yan's Armour", kr = "장연의 갑옷", zh = "張燕的護甲", cn = "张燕的护甲",  },
['3k_main_ancillary_armour_zhao_yuns_armour_unique'] = { dlc = "tke", category = "armour", tier = "unique", en = "Zhao Yun's Armour", kr = "조운의 갑옷", zh = "趙雲的護甲", cn = "赵云的护甲",  },
['3k_main_ancillary_armour_zheng_jiangs_armour_unique'] = { dlc = "tke", category = "armour", tier = "unique", en = "Zheng Jiang's Armour", kr = "정강의 갑옷", zh = "鄭姜的護甲", cn = "郑姜的护甲",  },
['3k_main_ancillary_armour_zhou_yus_armour_unique'] = { dlc = "tke", category = "armour", tier = "unique", en = "Zhou Yu's Armour", kr = "주유의 갑옷", zh = "周瑜的護甲", cn = "周瑜的护甲",  },
['3k_main_ancillary_armour_zhuge_liangs_armour_unique'] = { dlc = "tke", category = "armour", tier = "unique", en = "Zhuge Liang's Armour", kr = "학창의", zh = "諸葛亮的護甲", cn = "诸葛亮的护甲",  },
['3k_main_ancillary_armour_archer_light_armour_water_extraordinary'] = { dlc = "tke", category = "armour", tier = "exceptional", en = "Stalker's Raiment", kr = "사냥꾼의 옷", zh = "追獵者裝束", cn = "潜行衣",  },
['3k_main_ancillary_armour_heavy_armour_fire_extraordinary'] = { dlc = "tke", category = "armour", tier = "exceptional", en = "Tempered Iron Skin", kr = "철갑피", zh = "鍛鐵衣", cn = "护身铁甲",  },
['3k_main_ancillary_armour_heavy_armour_wood_extraordinary'] = { dlc = "tke", category = "armour", tier = "exceptional", en = "Hardened Iron Shell", kr = "강철각", zh = "硬鐵殼", cn = "硬铁铠",  },
['3k_main_ancillary_armour_light_armour_earth_extraordinary'] = { dlc = "tke", category = "armour", tier = "exceptional", en = "Dignified Raiment", kr = "품위 있는 의복", zh = "莊嚴衣飾", cn = "礼仪服饰",  },
['3k_main_ancillary_armour_light_armour_metal_extraordinary'] = { dlc = "tke", category = "armour", tier = "exceptional", en = "Professional's Raiment", kr = "전문가의 예복", zh = "專才衣飾", cn = "精雕轻甲",  },
['3k_main_ancillary_armour_medium_armour_earth_extraordinary'] = { dlc = "tke", category = "armour", tier = "exceptional", en = "Noble's Leather", kr = "고귀한 자의 가죽 갑옷", zh = "名門皮甲", cn = "贵族革甲",  },
['3k_main_ancillary_armour_medium_armour_fire_extraordinary'] = { dlc = "tke", category = "armour", tier = "exceptional", en = "Champion's Leather", kr = "용장의 가죽 갑옷", zh = "鬥士皮甲", cn = "猛士革甲",  },
['3k_main_ancillary_armour_medium_armour_metal_extraordinary'] = { dlc = "tke", category = "armour", tier = "exceptional", en = "Master's Leather", kr = "거장의 가죽갑옷", zh = "大師皮甲", cn = "宗师革甲",  },
['3k_main_ancillary_armour_medium_armour_wood_extraordinary'] = { dlc = "tke", category = "armour", tier = "exceptional", en = "Defender's Leather", kr = "수호자의 가죽 갑옷", zh = "守軍皮甲", cn = "护卫革甲",  },
['3k_main_ancillary_armour_strategist_light_armour_water_extraordinary'] = { dlc = "tke", category = "armour", tier = "exceptional", en = "Robe of the Omen Maker", kr = "신탁의 예복", zh = "卜卦禮袍", cn = "方士袍",  },
['3k_main_ancillary_armour_heavy_armour_wood_and_fire_refined'] = { dlc = "tke", category = "armour", tier = "refined", en = "Forged Iron Scale", kr = "무쇠 미늘 갑옷", zh = "鍛鐵鱗甲", cn = "铁鳞甲",  },
['3k_main_ancillary_armour_light_armour_earth_metal_and_water_refined'] = { dlc = "tke", category = "armour", tier = "refined", en = "Ranger's Outfit", kr = "순찰자의 의복", zh = "遊俠裝束", cn = "游侠轻甲",  },
['3k_main_ancillary_armour_medium_armour_earth_and_metal_refined'] = { dlc = "tke", category = "armour", tier = "refined", en = "Expert's Leather", kr = "전문가의 가죽 갑옷", zh = "行家皮甲", cn = "老兵革甲",  },
['3k_main_ancillary_armour_medium_armour_wood_and_fire_refined'] = { dlc = "tke", category = "armour", tier = "refined", en = "Warrior's Reinforced Leather", kr = "전사의 보강된 가죽갑옷", zh = "加固戰士皮甲", cn = "勇士精革甲",  },
['3k_main_ancillary_armour_strategist_light_armour_water_refined'] = { dlc = "tke", category = "armour", tier = "refined", en = "Tunic of Divination", kr = "예언자의 웃옷", zh = "占卜祭袍", cn = "天乩袍",  },
['3k_main_ancillary_armour_heavy_armour_wood_and_fire_common'] = { dlc = "tke", category = "armour", tier = "common", en = "Dull Iron Carapace", kr = "투박한 철갑", zh = "鈍鐵甲", cn = "钝铁甲",  },
['3k_main_ancillary_armour_light_armour_earth_metal_and_water_common'] = { dlc = "tke", category = "armour", tier = "common", en = "Hunter's Garb", kr = "사냥꾼의 의복", zh = "獵裝", cn = "猎人轻甲",  },
['3k_main_ancillary_armour_medium_armour_earth_and_metal_common'] = { dlc = "tke", category = "armour", tier = "common", en = "Instructor's Leather", kr = "교관의 가죽 갑옷", zh = "教官皮甲", cn = "教头革甲",  },
['3k_main_ancillary_armour_medium_armour_wood_and_fire_common'] = { dlc = "tke", category = "armour", tier = "common", en = "Soldier's Reinforced Leather ", kr = "병사의 보강된 가죽갑옷 ", zh = "加固兵士皮甲 ", cn = "军士精革甲",  },
['3k_main_ancillary_armour_strategist_light_armour_water_common'] = { dlc = "tke", category = "armour", tier = "common", en = "Vestments of Learning", kr = "학문의 예복", zh = "太學服飾", cn = "学士服",  },
['3k_main_ancillary_mount_dilu'] = { dlc = "tke", category = "mount", tier = "legendary", en = "Dilu", kr = "적로", zh = "的盧", cn = "的卢",  },
['3k_main_ancillary_mount_heavenly_fire'] = { dlc = "tke", category = "mount", tier = "legendary", en = "Heavenly Fire", kr = "화종마", zh = "天火", cn = "天火",  },
['3k_main_ancillary_mount_red_hare'] = { dlc = "tke", category = "mount", tier = "legendary", en = "Red Hare", kr = "적토마", zh = "赤兔", cn = "赤兔",  },
['3k_main_ancillary_mount_shadow_runner'] = { dlc = "tke", category = "mount", tier = "legendary", en = "Shadow Runner", kr = "절영", zh = "絕影", cn = "绝影",  },
['3k_main_ancillary_mount_black_elite'] = { dlc = "tke", category = "mount", tier = "unique", en = "Black Elite", kr = "흑색 명마", zh = "黑色駿馬", cn = "黑骊",  },
['3k_main_ancillary_mount_brown_elite'] = { dlc = "tke", category = "mount", tier = "unique", en = "Brown Elite", kr = "갈색 명마", zh = "棕色駿馬", cn = "腾黄",  },
['3k_main_ancillary_mount_grey_elite'] = { dlc = "tke", category = "mount", tier = "unique", en = "Grey Elite", kr = "회색 명마", zh = "灰色駿馬", cn = "青骢",  },
['3k_main_ancillary_mount_red_elite'] = { dlc = "tke", category = "mount", tier = "unique", en = "Red Elite", kr = "적색 명마", zh = "赤色駿馬", cn = "赤骅",  },
['3k_main_ancillary_mount_white_elite'] = { dlc = "tke", category = "mount", tier = "unique", en = "White Elite", kr = "백색 명마", zh = "白色駿馬", cn = "骕骦",  },
['3k_main_ancillary_mount_yellow_hoofed_thunder'] = { dlc = "tke", category = "mount", tier = "unique", en = "Yellow-hoofed Thunder", kr = "조황비전", zh = "爪黃飛電", cn = "爪黄飞电",  },
['3k_main_ancillary_mount_black_stallion'] = { dlc = "tke", category = "mount", tier = "exceptional", en = "Black Stallion", kr = "흑색 종마", zh = "黑色良馬", cn = "黑骥",  },
['3k_main_ancillary_mount_brown_stallion'] = { dlc = "tke", category = "mount", tier = "exceptional", en = "Brown Stallion", kr = "갈색 종마", zh = "棕色良馬", cn = "栗骥",  },
['3k_main_ancillary_mount_grey_stallion'] = { dlc = "tke", category = "mount", tier = "exceptional", en = "Grey Stallion", kr = "회색 종마", zh = "灰色良馬", cn = "青骥",  },
['3k_main_ancillary_mount_red_stallion'] = { dlc = "tke", category = "mount", tier = "exceptional", en = "Red Stallion", kr = "적색 종마", zh = "赤色良馬", cn = "赤骥",  },
['3k_main_ancillary_mount_white_stallion'] = { dlc = "tke", category = "mount", tier = "exceptional", en = "White Stallion", kr = "백색 종마", zh = "白色良馬", cn = "白骥",  },
['3k_main_ancillary_mount_black_thoroughbred'] = { dlc = "tke", category = "mount", tier = "refined", en = "Black Thoroughbred", kr = "순종 흑마", zh = "純種黑馬", cn = "黑骏",  },
['3k_main_ancillary_mount_brown_thoroughbred'] = { dlc = "tke", category = "mount", tier = "refined", en = "Brown Thoroughbred", kr = "순종 갈색 말", zh = "純種棕馬", cn = "栗骏",  },
['3k_main_ancillary_mount_grey_thoroughbred'] = { dlc = "tke", category = "mount", tier = "refined", en = "Grey Thoroughbred", kr = "순종 회색 말", zh = "純種灰馬", cn = "青骏",  },
['3k_main_ancillary_mount_red_thoroughbred'] = { dlc = "tke", category = "mount", tier = "refined", en = "Red Thoroughbred", kr = "순종 적마", zh = "純種赤馬", cn = "赤骏",  },
['3k_main_ancillary_mount_white_thoroughbred'] = { dlc = "tke", category = "mount", tier = "refined", en = "White Thoroughbred", kr = "순종 백마", zh = "純種白馬", cn = "白骏",  },
['3k_main_ancillary_mount_black_horse'] = { dlc = "tke", category = "mount", tier = "common", en = "Black Horse", kr = "흑마", zh = "黑馬", cn = "黑马",  },
['3k_main_ancillary_mount_brown_horse'] = { dlc = "tke", category = "mount", tier = "common", en = "Brown Horse", kr = "갈색 말", zh = "棕馬", cn = "栗马",  },
['3k_main_ancillary_mount_grey_horse'] = { dlc = "tke", category = "mount", tier = "common", en = "Grey Horse", kr = "회색 말", zh = "灰馬", cn = "青马",  },
['3k_main_ancillary_mount_red_horse'] = { dlc = "tke", category = "mount", tier = "common", en = "Red Horse", kr = "적마", zh = "赤馬", cn = "赤马",  },
['3k_main_ancillary_mount_white_horse'] = { dlc = "tke", category = "mount", tier = "common", en = "White Horse", kr = "백마", zh = "白馬", cn = "白马",  },
['3k_main_ancillary_follower_elite_trainer'] = { dlc = "tke", category = "follower", tier = "unique", en = "Elite Trainer", kr = "정예 교관", zh = "精銳教官", cn = "精英教头",  },
['3k_main_ancillary_follower_hua_tuo'] = { dlc = "tke", category = "follower", tier = "unique", en = "Hua Tuo", kr = "화타", zh = "華佗", cn = "华佗",  },
['3k_main_ancillary_follower_prefect'] = { dlc = "tke", category = "follower", tier = "unique", en = "Prefect", kr = "현감", zh = "地方首長", cn = "县令",  },
['3k_main_ancillary_follower_professor'] = { dlc = "tke", category = "follower", tier = "unique", en = "Professor", kr = "교수", zh = "教師", cn = "教授",  },
['3k_main_ancillary_follower_provincial_auditor'] = { dlc = "tke", category = "follower", tier = "unique", en = "Provincial Auditor", kr = "지방 감사관", zh = "州務稅吏", cn = "督邮",  },
['3k_main_ancillary_follower_architect'] = { dlc = "tke", category = "follower", tier = "exceptional", en = "Architect", kr = "건축가", zh = "建築師", cn = "筑者",  },
['3k_main_ancillary_follower_concubine'] = { dlc = "tke", category = "follower", tier = "exceptional", en = "Concubine", kr = "첩", zh = "妾", cn = "媵妾",  },
['3k_main_ancillary_follower_confucian_sage'] = { dlc = "tke", category = "follower", tier = "exceptional", en = "Confucian Sage", kr = "유학자", zh = "孔門聖賢", cn = "贤儒",  },
['3k_main_ancillary_follower_diviner'] = { dlc = "tke", category = "follower", tier = "exceptional", en = "Diviner", kr = "예언자", zh = "卦師", cn = "卜者",  },
['3k_main_ancillary_follower_engineer'] = { dlc = "tke", category = "follower", tier = "exceptional", en = "Engineer", kr = "공학자", zh = "機關技師", cn = "攻械匠",  },
['3k_main_ancillary_follower_forge_master'] = { dlc = "tke", category = "follower", tier = "exceptional", en = "Forge Master", kr = "수석 대장장이", zh = "鍛工", cn = "锻师",  },
['3k_main_ancillary_follower_inspector'] = { dlc = "tke", category = "follower", tier = "exceptional", en = "Inspector", kr = "자사", zh = "刺史", cn = "监军",  },
['3k_main_ancillary_follower_jade_sculptor'] = { dlc = "tke", category = "follower", tier = "exceptional", en = "Jade Sculptor", kr = "옥 조각가", zh = "玉匠", cn = "琢玉人",  },
['3k_main_ancillary_follower_land_shaper'] = { dlc = "tke", category = "follower", tier = "exceptional", en = "Land Shaper", kr = "조경사", zh = "造景師", cn = "营造师",  },
['3k_main_ancillary_follower_legalist_fanatic'] = { dlc = "tke", category = "follower", tier = "exceptional", en = "Legalist Fanatic", kr = "열광적인 법률가", zh = "酷吏", cn = "申韩之徒",  },
['3k_main_ancillary_follower_local_administrator'] = { dlc = "tke", category = "follower", tier = "exceptional", en = "Local Administrator", kr = "현지 행정관", zh = "地方官員", cn = "本地望族",  },
['3k_main_ancillary_follower_master_craftsman'] = { dlc = "tke", category = "follower", tier = "exceptional", en = "Master Craftsman", kr = "명공", zh = "大工匠", cn = "宗师匠人",  },
['3k_main_ancillary_follower_philosopher'] = { dlc = "tke", category = "follower", tier = "exceptional", en = "Philosopher", kr = "철학자", zh = "哲人", cn = "贤哲",  },
['3k_main_ancillary_follower_professional_instuctor'] = { dlc = "tke", category = "follower", tier = "exceptional", en = "Professional Instructor", kr = "전문 교관", zh = "專業教官", cn = "专职教官",  },
['3k_main_ancillary_follower_provincial_advisor'] = { dlc = "tke", category = "follower", tier = "exceptional", en = "Provincial Advisor", kr = "지방 고문관", zh = "州從事", cn = "郡丞",  },
['3k_main_ancillary_follower_spy_master'] = { dlc = "tke", category = "follower", tier = "exceptional", en = "Spy Master", kr = "첩보 대장", zh = "間諜頭子", cn = "神纪密探",  },
['3k_main_ancillary_follower_tycoon'] = { dlc = "tke", category = "follower", tier = "exceptional", en = "Tycoon", kr = "거물", zh = "富商", cn = "巨贾",  },
['3k_main_ancillary_follower_adept'] = { dlc = "tke", category = "follower", tier = "refined", en = "Adept", kr = "대가", zh = "能手", cn = "巧匠",  },
['3k_main_ancillary_follower_artisan'] = { dlc = "tke", category = "follower", tier = "refined", en = "Artisan", kr = "장인", zh = "藝匠", cn = "艺匠",  },
['3k_main_ancillary_follower_astronomer'] = { dlc = "tke", category = "follower", tier = "refined", en = "Astronomer", kr = "천문학자", zh = "天文學家", cn = "钦天监",  },
['3k_main_ancillary_follower_bodyguard'] = { dlc = "tke", category = "follower", tier = "refined", en = "Bodyguard", kr = "경호원", zh = "貼身護衛", cn = "侍卫",  },
['3k_main_ancillary_follower_cryptographer'] = { dlc = "tke", category = "follower", tier = "refined", en = "Cryptographer", kr = "암호관", zh = "密碼師", cn = "阴书人",  },
['3k_main_ancillary_follower_eunuch'] = { dlc = "tke", category = "follower", tier = "refined", en = "Eunuch", kr = "환관", zh = "閹人", cn = "阉侍",  },
['3k_main_ancillary_follower_farm_manager'] = { dlc = "tke", category = "follower", tier = "refined", en = "Farm Manager", kr = "농장 관리자", zh = "農莊主", cn = "田庄司事",  },
['3k_main_ancillary_follower_farmer'] = { dlc = "tke", category = "follower", tier = "refined", en = "Farmer", kr = "농부", zh = "農人", cn = "农民",  },
['3k_main_ancillary_follower_foreman'] = { dlc = "tke", category = "follower", tier = "refined", en = "Foreman", kr = "공두", zh = "工頭", cn = "工头",  },
['3k_main_ancillary_follower_law_enforcer'] = { dlc = "tke", category = "follower", tier = "refined", en = "Law Enforcer", kr = "법 집행자", zh = "賊捕掾", cn = "贼曹",  },
['3k_main_ancillary_follower_mathematician'] = { dlc = "tke", category = "follower", tier = "refined", en = "Mathematician", kr = "수학자", zh = "算學士", cn = "筹算师",  },
['3k_main_ancillary_follower_merchant'] = { dlc = "tke", category = "follower", tier = "refined", en = "Merchant", kr = "상인", zh = "商販", cn = "商贾",  },
['3k_main_ancillary_follower_military_expert'] = { dlc = "tke", category = "follower", tier = "refined", en = "Military Expert", kr = "군사 전문가", zh = "軍事行家", cn = "历战勇士",  },
['3k_main_ancillary_follower_monk'] = { dlc = "tke", category = "follower", tier = "refined", en = "Taoist Monk", kr = "도사", zh = "道士", cn = "道人",  },
['3k_main_ancillary_follower_officer'] = { dlc = "tke", category = "follower", tier = "refined", en = "Officer", kr = "군관", zh = "官員", cn = "曹掾",  },
['3k_main_ancillary_follower_overseer'] = { dlc = "tke", category = "follower", tier = "refined", en = "Overseer", kr = "감독관", zh = "督軍", cn = "监工",  },
['3k_main_ancillary_follower_scholar'] = { dlc = "tke", category = "follower", tier = "refined", en = "Scholar", kr = "학자", zh = "學究", cn = "学士",  },
['3k_main_ancillary_follower_tax_collector'] = { dlc = "tke", category = "follower", tier = "refined", en = "Tax Collector", kr = "세금 징수원", zh = "稅吏", cn = "税吏",  },
['3k_main_ancillary_follower_builder'] = { dlc = "tke", category = "follower", tier = "common", en = "Builder", kr = "건설자", zh = "建造師", cn = "筑工",  },
['3k_main_ancillary_follower_craftsman'] = { dlc = "tke", category = "follower", tier = "common", en = "Craftsman", kr = "공예가", zh = "工匠", cn = "匠人",  },
['3k_main_ancillary_follower_devious_attendant'] = { dlc = "tke", category = "follower", tier = "common", en = "Devious Attendant", kr = "교활한 사자", zh = "狡詐隨侍", cn = "细作侍从",  },
['3k_main_ancillary_follower_eavesdropper'] = { dlc = "tke", category = "follower", tier = "common", en = "Eavesdropper", kr = "염탐꾼", zh = "竊聽者", cn = "窃听者",  },
['3k_main_ancillary_follower_guard'] = { dlc = "tke", category = "follower", tier = "common", en = "Guard", kr = "호위대", zh = "守衛", cn = "守卫",  },
['3k_main_ancillary_follower_herdsman'] = { dlc = "tke", category = "follower", tier = "common", en = "Herdsman", kr = "목동", zh = "牧人", cn = "牧人",  },
['3k_main_ancillary_follower_labour_recruiter'] = { dlc = "tke", category = "follower", tier = "common", en = "Labour Recruiter", kr = "노동자 징용관", zh = "招工官", cn = "徭长",  },
['3k_main_ancillary_follower_military_instructor'] = { dlc = "tke", category = "follower", tier = "common", en = "Military Instructor", kr = "교관", zh = "軍事教官", cn = "屯将",  },
['3k_main_ancillary_follower_trader'] = { dlc = "tke", category = "follower", tier = "common", en = "Trader", kr = "교역상", zh = "商賈", cn = "商人",  },
['3k_main_ancillary_accessory_crane_feather_fan'] = { dlc = "tke", category = "accessory", tier = "legendary", en = "Crane Feather Fan", kr = "백우선", zh = "鶴羽扇", cn = "鹤羽扇",  },
['3k_main_ancillary_accessory_imperial_jade_seal'] = { dlc = "tke", category = "accessory", tier = "legendary", en = "Imperial Jade Seal", kr = "황실 옥새", zh = "皇帝玉璽", cn = "玉玺",  },
['3k_main_ancillary_weapon_bow_huang_zhong_faction'] = { dlc = "tke", category = "accessory", tier = "legendary", en = "Heirloom Bow of Huang", kr = "황가의 활", zh = "黃家祖傳弓", cn = "家传宝弓",  },
['3k_main_ancillary_weapon_bow_lady_sun_faction'] = { dlc = "tke", category = "accessory", tier = "legendary", en = "Cinnabar-red Bow", kr = "진사홍궁", zh = "朱砂弓", cn = "赤朱弓",  },
['3k_main_ancillary_weapon_bow_taishi_ci_faction'] = { dlc = "tke", category = "accessory", tier = "legendary", en = "Breath & Wind", kr = "풍뢰궁", zh = "風雷弓", cn = "风啸弓",  },
['3k_main_ancillary_weapon_composite_bow_unique'] = { dlc = "tke", category = "accessory", tier = "legendary", en = "The Black Dragon", kr = "흑룡", zh = "黑龍弓", cn = "黑螭弓",  },
['3k_main_ancillary_accessory_blade_of_seven_gems'] = { dlc = "tke", category = "accessory", tier = "unique", en = "Blade of Seven Gems", kr = "칠성보도", zh = "七星寶刀", cn = "七星刀",  },
['3k_main_ancillary_accessory_book_of_concealing_method'] = { dlc = "tke", category = "accessory", tier = "unique", en = "Book of Concealing Method", kr = "둔갑천서", zh = "遁甲天書", cn = "《遁甲天书》",  },
['3k_main_ancillary_accessory_book_of_documents'] = { dlc = "tke", category = "accessory", tier = "unique", en = "Book of Documents", kr = "서경", zh = "尚書", cn = "《书经》",  },
['3k_main_ancillary_accessory_earthquake_watching_device'] = { dlc = "tke", category = "accessory", tier = "unique", en = "Seismograph", kr = "지진계", zh = "地動儀", cn = "地动仪",  },
['3k_main_ancillary_accessory_hua_tuos_manual'] = { dlc = "tke", category = "accessory", tier = "unique", en = "Hua Tuo's Manual", kr = "화타의 편람", zh = "華佗手稿", cn = "《青囊书》",  },
['3k_main_ancillary_accessory_king_of_jade_ge'] = { dlc = "tke", category = "accessory", tier = "unique", en = "King of Jade Ge", kr = "옥대", zh = "大玉戈", cn = "王爵玉戈",  },
['3k_main_ancillary_accessory_south_pointing_chariot'] = { dlc = "tke", category = "accessory", tier = "unique", en = "South-pointing Chariot", kr = "남방전차", zh = "指南車", cn = "指南车",  },
['3k_main_ancillary_accessory_the_emperor'] = { dlc = "tke", category = "accessory", tier = "unique", en = "The Emperor", kr = "천자", zh = "皇帝", cn = "皇帝",  },
['3k_main_ancillary_accessory_art_of_war'] = { dlc = "tke", category = "accessory", tier = "exceptional", en = "Art of War", kr = "손자병법", zh = "孫子兵法", cn = "《孙子兵法》",  },
['3k_main_ancillary_accessory_book_of_ceremonies'] = { dlc = "tke", category = "accessory", tier = "exceptional", en = "Book of Ceremonies", kr = "의례", zh = "儀禮", cn = "《仪礼》",  },
['3k_main_ancillary_accessory_book_of_changes'] = { dlc = "tke", category = "accessory", tier = "exceptional", en = "Book of Changes", kr = "역경", zh = "易經", cn = "《易经》",  },
['3k_main_ancillary_accessory_book_of_rites'] = { dlc = "tke", category = "accessory", tier = "exceptional", en = "Book of Rites", kr = "예기", zh = "禮記", cn = "《礼记》",  },
['3k_main_ancillary_accessory_celestial_sphere'] = { dlc = "tke", category = "accessory", tier = "exceptional", en = "Celestial Sphere", kr = "천구", zh = "渾天儀", cn = "浑天仪",  },
['3k_main_ancillary_accessory_ceremonial_stone_axe'] = { dlc = "tke", category = "accessory", tier = "exceptional", en = "Ceremonial Stone Axe", kr = "의식용 돌 도끼", zh = "儀典石斧", cn = "节钺",  },
['3k_main_ancillary_accessory_erya'] = { dlc = "tke", category = "accessory", tier = "exceptional", en = "Erya", kr = "이아", zh = "爾雅", cn = "《尔雅》",  },
['3k_main_ancillary_accessory_jade_archer'] = { dlc = "tke", category = "accessory", tier = "exceptional", en = "Jade Archer", kr = "옥 궁수", zh = "玉弓兵", cn = "玉弓手",  },
['3k_main_ancillary_accessory_jade_horse'] = { dlc = "tke", category = "accessory", tier = "exceptional", en = "Jade Horse", kr = "옥 말", zh = "玉馬", cn = "玉马",  },
['3k_main_ancillary_accessory_jade_horseman'] = { dlc = "tke", category = "accessory", tier = "exceptional", en = "Jade Horseman", kr = "옥 기병", zh = "玉騎兵", cn = "玉骑士",  },
['3k_main_ancillary_accessory_jade_monkey'] = { dlc = "tke", category = "accessory", tier = "exceptional", en = "Jade Monkey", kr = "옥 원숭이", zh = "玉猿", cn = "玉猴",  },
['3k_main_ancillary_accessory_jade_rooster'] = { dlc = "tke", category = "accessory", tier = "exceptional", en = "Jade Rooster", kr = "옥 수탉", zh = "玉雞", cn = "玉鸡",  },
['3k_main_ancillary_accessory_jade_sickle'] = { dlc = "tke", category = "accessory", tier = "exceptional", en = "Jade Sickle", kr = "옥 낫", zh = "玉鐮", cn = "玉镰刀",  },
['3k_main_ancillary_accessory_jade_snake'] = { dlc = "tke", category = "accessory", tier = "exceptional", en = "Jade Snake", kr = "옥 뱀", zh = "玉蛇", cn = "玉蛇",  },
['3k_main_ancillary_accessory_jade_statue_of_confucius'] = { dlc = "tke", category = "accessory", tier = "exceptional", en = "Jade Statue of Confucius", kr = "공자의 옥상", zh = "孔子玉像", cn = "孔子玉雕",  },
['3k_main_ancillary_accessory_porcelain_cup'] = { dlc = "tke", category = "accessory", tier = "exceptional", en = "Porcelain Cup", kr = "도자기 잔", zh = "瓷杯", cn = "瓷杯",  },
['3k_main_ancillary_accessory_rites_of_zhou'] = { dlc = "tke", category = "accessory", tier = "exceptional", en = "Rites of Zhou", kr = "주례", zh = "周禮", cn = "《周礼》",  },
['3k_main_ancillary_accessory_the_methods_of_the_sima'] = { dlc = "tke", category = "accessory", tier = "exceptional", en = "The Methods of the Sima", kr = "사마법", zh = "司馬法", cn = "《司马法》",  },
['3k_main_ancillary_weapon_composite_bow_exceptional'] = { dlc = "tke", category = "accessory", tier = "exceptional", en = "Imperial Bow", kr = "황실 활", zh = "帝王弓", cn = "帝国弓",  },
['3k_main_ancillary_accessory_book_of_mountains_and_seas'] = { dlc = "tke", category = "accessory", tier = "refined", en = "Book of Mountains & Seas", kr = "산해경", zh = "山海經", cn = "《山海经》",  },
['3k_main_ancillary_accessory_book_of_songs'] = { dlc = "tke", category = "accessory", tier = "refined", en = "Book of Songs", kr = "시경", zh = "詩經", cn = "《诗经》",  },
['3k_main_ancillary_accessory_classic_of_filial_piety'] = { dlc = "tke", category = "accessory", tier = "refined", en = "Classic of Filial Piety", kr = "효경", zh = "孝經", cn = "《孝经》",  },
['3k_main_ancillary_accessory_clay_cup'] = { dlc = "tke", category = "accessory", tier = "refined", en = "Clay Cup", kr = "점토 잔", zh = "陶杯", cn = "陶杯",  },
['3k_main_ancillary_accessory_clay_dog'] = { dlc = "tke", category = "accessory", tier = "refined", en = "Clay Dog", kr = "점토 개", zh = "陶犬", cn = "陶犬",  },
['3k_main_ancillary_accessory_clay_fish'] = { dlc = "tke", category = "accessory", tier = "refined", en = "Clay Fish", kr = "점토 물고기", zh = "陶魚", cn = "陶鱼",  },
['3k_main_ancillary_accessory_clay_ox'] = { dlc = "tke", category = "accessory", tier = "refined", en = "Clay Ox", kr = "점토 황소", zh = "陶牛", cn = "陶牛",  },
['3k_main_ancillary_accessory_discourses_of_the_states'] = { dlc = "tke", category = "accessory", tier = "refined", en = "Discourses of the States", kr = "국어", zh = "國語", cn = "《国语》",  },
['3k_main_ancillary_accessory_iron_archer'] = { dlc = "tke", category = "accessory", tier = "refined", en = "Iron Archer", kr = "강철 궁수", zh = "鐵弓兵", cn = "铁弓手",  },
['3k_main_ancillary_accessory_iron_sickle'] = { dlc = "tke", category = "accessory", tier = "refined", en = "Iron Sickle", kr = "강철 낫", zh = "鐵鐮", cn = "铁镰刀",  },
['3k_main_ancillary_accessory_iron_snake'] = { dlc = "tke", category = "accessory", tier = "refined", en = "Iron Snake", kr = "철 뱀", zh = "鐵蛇", cn = "铁蛇",  },
['3k_main_ancillary_accessory_mozi'] = { dlc = "tke", category = "accessory", tier = "refined", en = "Mozi", kr = "묵자", zh = "墨子", cn = "《墨子》",  },
['3k_main_ancillary_accessory_six_secret_teachings'] = { dlc = "tke", category = "accessory", tier = "refined", en = "Six Secret Teachings", kr = "육도", zh = "六韜", cn = "《六韬》",  },
['3k_main_ancillary_accessory_stone_axe'] = { dlc = "tke", category = "accessory", tier = "refined", en = "Stone Axe", kr = "돌 도끼", zh = "石斧", cn = "石斧",  },
['3k_main_ancillary_accessory_stone_horse'] = { dlc = "tke", category = "accessory", tier = "refined", en = "Stone Horse", kr = "말 석상", zh = "石馬", cn = "石马",  },
['3k_main_ancillary_accessory_stone_monkey'] = { dlc = "tke", category = "accessory", tier = "refined", en = "Stone Monkey", kr = "원숭이 석상", zh = "石猿", cn = "石猴",  },
['3k_main_ancillary_accessory_stone_pig'] = { dlc = "tke", category = "accessory", tier = "refined", en = "Stone Pig", kr = "돼지 석상", zh = "石豚", cn = "石猪",  },
['3k_main_ancillary_accessory_stone_rat'] = { dlc = "tke", category = "accessory", tier = "refined", en = "Stone Rat", kr = "쥐 석상", zh = "石鼠", cn = "石鼠",  },
['3k_main_ancillary_accessory_stone_rooster'] = { dlc = "tke", category = "accessory", tier = "refined", en = "Stone Rooster", kr = "수탉 석상", zh = "石雞", cn = "石鸡",  },
['3k_main_ancillary_accessory_stone_statue_of_confucius'] = { dlc = "tke", category = "accessory", tier = "refined", en = "Stone Statue of Confucius", kr = "공자 석상", zh = "孔子石像", cn = "孔子石像",  },
['3k_main_ancillary_accessory_strategies_of_the_warring_states'] = { dlc = "tke", category = "accessory", tier = "refined", en = "Strategies of the Warring States", kr = "전국책", zh = "戰國策", cn = "《战国策》",  },
['3k_main_ancillary_accessory_the_nine_chapters_on_the_mathematical_art'] = { dlc = "tke", category = "accessory", tier = "refined", en = "The Nine Chapters on the Mathematical Art", kr = "구장산술", zh = "九章算術", cn = "《九章算术》",  },
['3k_main_ancillary_accessory_the_three_strategies_of_the_duke_of_the_yellow_rock'] = { dlc = "tke", category = "accessory", tier = "refined", en = "The Three Strategies of the Duke of the Yellow Rock", kr = "황석공 삼략", zh = "黃石公三略", cn = "《黄石公三略》",  },
['3k_main_ancillary_accessory_wei_liaozi'] = { dlc = "tke", category = "accessory", tier = "refined", en = "Wei Liaozi", kr = "울요자", zh = "尉繚子", cn = "《尉缭子》",  },
['3k_main_ancillary_accessory_wuzi'] = { dlc = "tke", category = "accessory", tier = "refined", en = "Wuzi", kr = "오자", zh = "吳子", cn = "《吴子》",  },
['3k_main_ancillary_accessory_zhuangzi'] = { dlc = "tke", category = "accessory", tier = "refined", en = "Zhuangzi", kr = "장자", zh = "莊子", cn = "《庄子》",  },
['3k_main_ancillary_weapon_composite_bow_refined'] = { dlc = "tke", category = "accessory", tier = "refined", en = "Composite Bow", kr = "합성궁", zh = "複合弓", cn = "复合弓",  },
['3k_main_ancillary_accessory_clay_axe'] = { dlc = "tke", category = "accessory", tier = "common", en = "Clay Axe", kr = "점토 도끼", zh = "陶斧", cn = "陶斧",  },
['3k_main_ancillary_accessory_clay_pig'] = { dlc = "tke", category = "accessory", tier = "common", en = "Clay Pig", kr = "점토 돼지", zh = "陶豚", cn = "陶猪",  },
['3k_main_ancillary_accessory_clay_rat'] = { dlc = "tke", category = "accessory", tier = "common", en = "Clay Rat", kr = "점토 쥐", zh = "陶鼠", cn = "陶鼠",  },
['3k_main_ancillary_accessory_clay_warrior'] = { dlc = "tke", category = "accessory", tier = "common", en = "Clay Warrior", kr = "점토 전사", zh = "戰士陶偶", cn = "兵俑",  },
['3k_main_ancillary_accessory_feather_fan'] = { dlc = "tke", category = "accessory", tier = "common", en = "Feather Fan", kr = "깃털 부채", zh = "羽扇", cn = "羽扇",  },
['3k_main_ancillary_accessory_stone_archer'] = { dlc = "tke", category = "accessory", tier = "common", en = "Stone Archer", kr = "궁수 석상", zh = "石弓兵", cn = "石弓手",  },
['3k_main_ancillary_accessory_water_clock'] = { dlc = "tke", category = "accessory", tier = "common", en = "Water Clock", kr = "물시계", zh = "水鐘", cn = "水钟",  },
['3k_main_ancillary_accessory_wooden_dog'] = { dlc = "tke", category = "accessory", tier = "common", en = "Wooden Dog", kr = "나무 개", zh = "木犬", cn = "木狗",  },
['3k_main_ancillary_accessory_wooden_fish'] = { dlc = "tke", category = "accessory", tier = "common", en = "Wooden Fish", kr = "나무 물고기", zh = "木魚", cn = "木鱼",  },
['3k_main_ancillary_accessory_wooden_ox'] = { dlc = "tke", category = "accessory", tier = "common", en = "Wooden Ox", kr = "나무 황소", zh = "木牛", cn = "木牛",  },
['3k_main_ancillary_weapon_composite_bow_common'] = { dlc = "tke", category = "accessory", tier = "common", en = "Bow", kr = "활", zh = "弓", cn = "弓",  },
-- tke 260
['3k_ytr_ancillary_weapon_2h_ball_mace_unique'] = { dlc = "ytr", category = "weapon", tier = "unique", en = "Headcrusher", kr = "파쇄추", zh = "碎顱錘", cn = "破天锤",  },
['3k_ytr_ancillary_weapon_dual_maces_unique'] = { dlc = "ytr", category = "weapon", tier = "unique", en = "Heavenly Bodies", kr = "천상추", zh = "雙星錘", cn = "天躯锤",  },
['3k_ytr_ancillary_weapon_staff_unique'] = { dlc = "ytr", category = "weapon", tier = "unique", en = "Gun of Purity", kr = "정결의 곤", zh = "淨心棍", cn = "纯元棍",  },
['3k_ytr_ancillary_weapon_2h_ball_mace_exceptional'] = { dlc = "ytr", category = "weapon", tier = "exceptional", en = "Pole Mace", kr = "철추봉", zh = "錘杖", cn = "长柄锤",  },
['3k_ytr_ancillary_weapon_dual_maces_exceptional'] = { dlc = "ytr", category = "weapon", tier = "exceptional", en = "Identical Chuí", kr = "쌍추", zh = "鴛鴦錘", cn = "恒金锤",  },
['3k_ytr_ancillary_weapon_staff_exceptional'] = { dlc = "ytr", category = "weapon", tier = "exceptional", en = "Reinforced Gun", kr = "보강된 곤", zh = "強化棍", cn = "强化棍",  },
['3k_ytr_ancillary_weapon_2h_ball_mace_refined'] = { dlc = "ytr", category = "weapon", tier = "refined", en = "Two-handed Mace", kr = "양손 철퇴", zh = "雙手錘矛", cn = "双手锤",  },
['3k_ytr_ancillary_weapon_dual_maces_refined'] = { dlc = "ytr", category = "weapon", tier = "refined", en = "Matched Chuí", kr = "동추", zh = "對錘", cn = "鸳鸯锤",  },
['3k_ytr_ancillary_weapon_staff_refined'] = { dlc = "ytr", category = "weapon", tier = "refined", en = "Balanced Gun", kr = "평범한 곤", zh = "平衡棍", cn = "平衡棍",  },
['3k_ytr_ancillary_weapon_2h_ball_mace_common'] = { dlc = "ytr", category = "weapon", tier = "common", en = "Hammer Spear", kr = "철퇴", zh = "錘矛", cn = "锤矛",  },
['3k_ytr_ancillary_weapon_dual_maces_common'] = { dlc = "ytr", category = "weapon", tier = "common", en = "Chuí", kr = "추", zh = "錘", cn = "锤",  },
['3k_ytr_ancillary_weapon_staff_common'] = { dlc = "ytr", category = "weapon", tier = "common", en = "Gun", kr = "곤", zh = "棍", cn = "棍",  },
['3k_ytr_ancillary_armour_gong_dus_armour_unique'] = { dlc = "ytr", category = "armour", tier = "unique", en = "Gong Du's Armour", kr = "공도의 갑옷", zh = "龔都的護甲", cn = "龚都的护甲",  },
['3k_ytr_ancillary_armour_he_mans_armour_unique'] = { dlc = "ytr", category = "armour", tier = "unique", en = "He Man's Armour", kr = "하만의 갑옷", zh = "何曼的護甲", cn = "何曼的护甲",  },
['3k_ytr_ancillary_armour_he_yis_armour_unique'] = { dlc = "ytr", category = "armour", tier = "unique", en = "He Yi's Armour", kr = "하의의 갑옷", zh = "何儀的護甲", cn = "何仪的护甲",  },
['3k_ytr_ancillary_armour_healer_yellow_turban_unique'] = { dlc = "ytr", category = "armour", tier = "unique", en = "Heavenly Mender", kr = "천기요의", zh = "天道醫袍", cn = "天命愈者",  },
['3k_ytr_ancillary_armour_huang_shaos_armour_unique'] = { dlc = "ytr", category = "armour", tier = "unique", en = "Huang Shao's Armour", kr = "황소의 갑옷", zh = "黃邵的護甲", cn = "黄邵的护甲",  },
['3k_ytr_ancillary_armour_pei_yuanshaos_armour_unique'] = { dlc = "ytr", category = "armour", tier = "unique", en = "Pei Yuanshao's Armour", kr = "배원소의 갑옷", zh = "裴元紹的護甲", cn = "裴元绍的护甲",  },
['3k_ytr_ancillary_armour_scholar_medium_yellow_turban_unique'] = { dlc = "ytr", category = "armour", tier = "unique", en = "Wisdom's Wrappings", kr = "지략지복", zh = "智者之袍", cn = "智者之袍",  },
['3k_ytr_ancillary_armour_veteran_medium_yellow_turban_unique'] = { dlc = "ytr", category = "armour", tier = "unique", en = "Protection of the People", kr = "만민보구", zh = "護民服", cn = "庶民之护",  },
['3k_ytr_ancillary_armour_zhang_kais_armour_unique'] = { dlc = "ytr", category = "armour", tier = "unique", en = "Zhang Kai's Armour", kr = "장개의 갑옷", zh = "張闓的護甲", cn = "张闿的护甲",  },
['3k_ytr_ancillary_armour_healer_yellow_turban_exceptional'] = { dlc = "ytr", category = "armour", tier = "exceptional", en = "Physician's Robe", kr = "의술사의 의복", zh = "大夫長袍", cn = "神医长袍",  },
['3k_ytr_ancillary_armour_scholar_medium_yellow_turban_exceptional'] = { dlc = "ytr", category = "armour", tier = "exceptional", en = "Sage's Attire", kr = "현인의 의복", zh = "聖人衣裝", cn = "贤士便服",  },
['3k_ytr_ancillary_armour_veteran_medium_yellow_turban_exceptional'] = { dlc = "ytr", category = "armour", tier = "exceptional", en = "General's Uniform", kr = "장군의 제복", zh = "將領制服", cn = "将军战袍",  },
['3k_ytr_ancillary_armour_healer_yellow_turban_refined'] = { dlc = "ytr", category = "armour", tier = "refined", en = "Curer's Vestments", kr = "치료사의 의복", zh = "醫者法衣", cn = "医者祭服",  },
['3k_ytr_ancillary_armour_scholar_medium_yellow_turban_refined'] = { dlc = "ytr", category = "armour", tier = "refined", en = "Disciple's Attire", kr = "신도의 의복", zh = "信徒衣裝", cn = "门徒便服",  },
['3k_ytr_ancillary_armour_veteran_medium_yellow_turban_refined'] = { dlc = "ytr", category = "armour", tier = "refined", en = "Unit Leader's Outfit", kr = "부대장의 갑옷", zh = "部隊長服裝", cn = "伯长戎装",  },
['3k_ytr_ancillary_armour_healer_yellow_turban_common'] = { dlc = "ytr", category = "armour", tier = "common", en = "Healer's Tunic", kr = "의원의 웃옷", zh = "醫袍", cn = "医士外套",  },
['3k_ytr_ancillary_armour_scholar_medium_yellow_turban_common'] = { dlc = "ytr", category = "armour", tier = "common", en = "Student's Attire", kr = "학생의 의복", zh = "學生衣裝", cn = "新人便服",  },
['3k_ytr_ancillary_armour_veteran_medium_yellow_turban_common'] = { dlc = "ytr", category = "armour", tier = "common", en = "Commoner's Protective Garments", kr = "병사의 보호복", zh = "平民護身衣物", cn = "平民护服",  },
['3k_ytr_ancillary_accessory_book_of_earth'] = { dlc = "ytr", category = "accessory", tier = "unique", en = "Book of Earth", kr = "태평경 지편", zh = "地皇文", cn = "《地遁》",  },
['3k_ytr_ancillary_accessory_book_of_heaven'] = { dlc = "ytr", category = "accessory", tier = "unique", en = "Book of Heaven", kr = "태평경 천편", zh = "天皇文", cn = "《天遁》",  },
['3k_ytr_ancillary_accessory_book_of_people'] = { dlc = "ytr", category = "accessory", tier = "unique", en = "Book of People", kr = "태평경 인편", zh = "人皇文", cn = "《人遁》",  },
['3k_ytr_ancillary_accessory_simple_carving_of_huang_lao'] = { dlc = "ytr", category = "accessory", tier = "refined", en = "Old Master", kr = "노자", zh = "老子像", cn = "老子像",  },
['3k_ytr_ancillary_accessory_stone_statue_of_zhang_bao'] = { dlc = "ytr", category = "accessory", tier = "refined", en = "General of Land", kr = "지공장군", zh = "地公將軍像", cn = "地公将军像",  },
['3k_ytr_ancillary_accessory_stone_statue_of_zhang_jue'] = { dlc = "ytr", category = "accessory", tier = "refined", en = "Great Teacher", kr = "대현자", zh = "大賢良師像", cn = "大贤良师像",  },
['3k_ytr_ancillary_accessory_stone_statue_of_zhang_liang'] = { dlc = "ytr", category = "accessory", tier = "refined", en = "General of the People", kr = "인공장군", zh = "人公將軍像", cn = "人公将军像",  },
-- ytr 37
['3k_dlc04_ancillary_weapon_staff_zhang_jue_unique'] = { dlc = "moh", category = "weapon", tier = "legendary", en = "Zhang Jue's Staff", kr = "장각의 지팡이", zh = "張角的寶杖", cn = "张角之杖",  },
['3k_dlc04_ancillary_armour_diao_chans_armour_unique'] = { dlc = "moh", category = "armour", tier = "unique", en = "Diao Chan's Armour", kr = "초선의 갑옷", zh = "貂蟬的護甲", cn = "貂蝉的护甲",  },
['3k_dlc04_ancillary_armour_emperor_ling_armour_unique'] = { dlc = "moh", category = "armour", tier = "unique", en = "The Emperor's Robes", kr = "황제의 예복", zh = "皇袍", cn = "皇袍",  },
['3k_dlc04_ancillary_armour_empress_hes_armour_unique'] = { dlc = "moh", category = "armour", tier = "unique", en = "Empress He's Robes", kr = "하황후의 예복", zh = "何后后袍", cn = "何后之袍",  },
['3k_dlc04_ancillary_armour_he_jins_armour_unique'] = { dlc = "moh", category = "armour", tier = "unique", en = "He Jin's Armour", kr = "하진의 갑옷", zh = "何進的護甲", cn = "何进的护甲",  },
['3k_dlc04_ancillary_armour_huangfu_songs_armour_unique'] = { dlc = "moh", category = "armour", tier = "unique", en = "Huangfu Song's Armour", kr = "황보숭의 갑옷", zh = "皇甫嵩的護甲", cn = "皇甫嵩之甲",  },
['3k_dlc04_ancillary_armour_lu_zhis_armour_unique'] = { dlc = "moh", category = "armour", tier = "unique", en = "Lu Zhi's Armour", kr = "노식의 갑옷", zh = "盧植的護甲", cn = "卢植的护甲",  },
['3k_dlc04_ancillary_armour_non_deployable_armour_red_common'] = { dlc = "moh", category = "armour", tier = "unique", en = "Courtier's Robes", kr = "조관의 예복", zh = "官袍", cn = "廷臣的礼服",  },
['3k_dlc04_ancillary_armour_non_deployable_armour_red_refined'] = { dlc = "moh", category = "armour", tier = "unique", en = "Attendant's Robes", kr = "사자의 예복", zh = "侍中袍", cn = "侍宦之袍",  },
['3k_dlc04_ancillary_armour_non_deployable_armour_yellow_common'] = { dlc = "moh", category = "armour", tier = "unique", en = "Minister's Robes", kr = "고관의 예복", zh = "朝臣袍", cn = "辅臣的礼服",  },
['3k_dlc04_ancillary_armour_prince_liu_chongs_armour_unique'] = { dlc = "moh", category = "armour", tier = "unique", en = "Prince Liu Chong's Armour", kr = "유총의 갑옷", zh = "陳王劉寵的護甲", cn = "刘宠的护甲",  },
['3k_dlc04_ancillary_armour_xun_yus_armour_unique'] = { dlc = "moh", category = "armour", tier = "unique", en = "Xun Yu's Armour", kr = "순욱의 갑옷", zh = "荀彧的護甲", cn = "荀彧的护甲",  },
['3k_dlc04_ancillary_armour_zhang_baos_armour_unique'] = { dlc = "moh", category = "armour", tier = "unique", en = "Zhang Bao's Armour", kr = "장보의 갑옷", zh = "張寶的護甲", cn = "张宝的护甲",  },
['3k_dlc04_ancillary_armour_zhang_jues_armour_unique'] = { dlc = "moh", category = "armour", tier = "unique", en = "Zhang Jue's Armour", kr = "장각의 갑옷", zh = "張角的護甲", cn = "张角的护甲",  },
['3k_dlc04_ancillary_armour_zhang_liangs_armour_unique'] = { dlc = "moh", category = "armour", tier = "unique", en = "Zhang Liang's Armour", kr = "장량의 갑옷", zh = "張梁的護甲", cn = "张梁的护甲",  },
['3k_dlc04_ancillary_mount_liu_chong'] = { dlc = "moh", category = "mount", tier = "legendary", en = "Ebon Prince", kr = "흑왕", zh = "烏木宗王", cn = "乌木王",  },
['3k_dlc04_ancillary_follower_master_crafter'] = { dlc = "moh", category = "follower", tier = "refined", en = "Master Crafter", kr = "명장", zh = "名家工匠", cn = "工匠大师",  },
['3k_dlc04_ancillary_follower_apprentice_crafter'] = { dlc = "moh", category = "follower", tier = "common", en = "Apprentice Crafter", kr = "장인 도제", zh = "工匠學徒", cn = "匠人门徒",  },
['3k_dlc04_ancillary_accessory_zhang_liang_unique'] = { dlc = "moh", category = "accessory", tier = "legendary", en = "Zhang Liang's Garland", kr = "장량의 관", zh = "張梁的流珠", cn = "张梁的流珠",  },
['3k_dlc04_ancillary_weapon_crossbow_prince_liu_chong_unique'] = { dlc = "moh", category = "accessory", tier = "legendary", en = "Prince Liu Chong's Crossbow", kr = "진왕 유총의 쇠뇌", zh = "陳王劉寵的弩", cn = "辅汉弩",  },
['3k_dlc04_ancillary_accessory_calligraphy_set_unique'] = { dlc = "moh", category = "accessory", tier = "unique", en = "Calligraphy Set", kr = "서예 문방구", zh = "書法帖", cn = "文房四宝",  },
['3k_dlc04_ancillary_accessory_nushe_bifa_unique'] = { dlc = "moh", category = "accessory", tier = "unique", en = "Nushe Bifa", kr = "노사 비법", zh = "弩射秘法", cn = "弩射秘法",  },
['3k_dlc04_ancillary_accessory_religious_bell_unique'] = { dlc = "moh", category = "accessory", tier = "unique", en = "Religious Bell", kr = "명상 종", zh = "儀鐘", cn = "信仰之铃",  },
['3k_dlc04_ancillary_weapon_bow_huangfu_song_unique'] = { dlc = "moh", category = "accessory", tier = "unique", en = "Huangfu Song's Bow", kr = "황보숭의 활", zh = "皇甫嵩的弓", cn = "义真弓",  },
-- moh 24
['3k_dlc05_ancillary_weapon_white_tigers_claws_faction'] = { dlc = "wb", category = "weapon", tier = "legendary", en = "The White Tiger's Claws", kr = "백호의 발톱", zh = "白虎爪", cn = "白虎之爪",  },
['3k_dlc05_ancillary_armour_yan_baihus_armour_unique'] = { dlc = "wb", category = "armour", tier = "unique", en = "Yan Baihu's Armour", kr = "엄백호의 갑옷", zh = "嚴白虎的護甲", cn = "严白虎的护甲",  },
['3k_dlc05_ancilliary_armour_chen_gong_armour_unique'] = { dlc = "wb", category = "armour", tier = "unique", en = "Chen Gong's Armour", kr = "진궁의 갑옷", zh = "陳宮的護甲", cn = "陈宫的护甲",  },
['3k_dlc05_ancilliary_armour_cheng_pu_armour_unique'] = { dlc = "wb", category = "armour", tier = "unique", en = "Cheng Pu's Armour", kr = "정보의 갑옷", zh = "程普的護甲", cn = "程普的护甲",  },
['3k_dlc05_ancilliary_armour_da_qiao_armour_unique'] = { dlc = "wb", category = "armour", tier = "unique", en = "Da Qiao's Armour", kr = "대교의 갑옷", zh = "大喬的護甲", cn = "大乔的护甲",  },
['3k_dlc05_ancilliary_armour_gao_shun_armour_unique'] = { dlc = "wb", category = "armour", tier = "unique", en = "Gao Shun's Armour", kr = "고순의 갑옷", zh = "高順的護甲", cn = "高顺的护甲",  },
['3k_dlc05_ancilliary_armour_ji_ling_armour_unique'] = { dlc = "wb", category = "armour", tier = "unique", en = "Ji Ling's Armour", kr = "기령의 갑옷", zh = "紀靈的護甲", cn = "纪灵的护甲",  },
['3k_dlc05_ancilliary_armour_lady_bian_armour_unique'] = { dlc = "wb", category = "armour", tier = "unique", en = "Lady Bian's Armour", kr = "변부인의 갑옷", zh = "卞夫人的護甲", cn = "卞夫人的护甲",  },
['3k_dlc05_ancilliary_armour_lady_mi_armour_unique'] = { dlc = "wb", category = "armour", tier = "unique", en = "Lady Mi's Armour", kr = "미부인의 갑옷", zh = "麋夫人的護甲", cn = "糜夫人的护甲",  },
['3k_dlc05_ancilliary_armour_li_jue_armour_unique'] = { dlc = "wb", category = "armour", tier = "unique", en = "Li Jue's Armour", kr = "이각의 갑옷", zh = "李傕的護甲", cn = "李傕的护甲",  },
['3k_dlc05_ancilliary_armour_liu_yao_armour_unique'] = { dlc = "wb", category = "armour", tier = "unique", en = "Liu Yao's Armour", kr = "유요의 갑옷", zh = "劉繇的護甲", cn = "刘繇的护甲",  },
['3k_dlc05_ancilliary_armour_wang_lang_armour_unique'] = { dlc = "wb", category = "armour", tier = "unique", en = "Wang Lang's Armour", kr = "왕랑의 갑옷", zh = "王朗的護甲", cn = "王朗的护甲",  },
['3k_dlc05_ancilliary_armour_xiao_qiao_armour_unique'] = { dlc = "wb", category = "armour", tier = "unique", en = "Xiao Qiao's Armour", kr = "소교의 갑옷", zh = "小喬的護甲", cn = "小乔的护甲",  },
['3k_dlc05_ancilliary_armour_xu_shu_armour_unique'] = { dlc = "wb", category = "armour", tier = "unique", en = "Xu Shu's Armour", kr = "서서의 갑옷", zh = "徐庶的護甲", cn = "徐庶的护甲",  },
['3k_dlc05_ancilliary_armour_yan_yu_armour_unique'] = { dlc = "wb", category = "armour", tier = "unique", en = "Yan Yu's Armour", kr = "엄여의 갑옷", zh = "嚴輿的護甲", cn = "严舆的护甲",  },
['3k_dlc05_ancilliary_armour_zhang_hong_armour_unique'] = { dlc = "wb", category = "armour", tier = "unique", en = "Zhang Hong's Armour", kr = "장굉의 갑옷", zh = "張紘的護甲", cn = "张纮的护甲",  },
['3k_dlc05_ancilliary_armour_zhang_zhao_armour_unique'] = { dlc = "wb", category = "armour", tier = "unique", en = "Zhang Zhao's Armour", kr = "장소의 갑옷", zh = "張昭的護甲", cn = "张昭的护甲",  },
['3k_dlc05_ancilliary_armour_zhou_tai_armour_unique'] = { dlc = "wb", category = "armour", tier = "unique", en = "Zhou Tai's Armour", kr = "주태의 갑옷", zh = "周泰的護甲", cn = "周泰的护甲",  },
-- wb 18
['3k_dlc06_ancillary_weapon_2h_ball_mace_king_shamoke_unique'] = { dlc = "fw", category = "weapon", tier = "unique", en = "Mountain Sunder", kr = "철질려골타", zh = "鐵蒺藜骨朵", cn = "蒺藜骨朵",  },
['3k_dlc06_ancillary_weapon_burning_mace_unique'] = { dlc = "fw", category = "weapon", tier = "unique", en = "Burning Mace", kr = "불타는 곤봉", zh = "烈焰錘", cn = "烈焰锤",  },
['3k_dlc06_ancillary_weapon_two_handed_axe_king_wutugu_unique'] = { dlc = "fw", category = "weapon", tier = "unique", en = "King Wutugu's Two-handed Axe", kr = "올돌골대왕의 양손도끼", zh = "兀突骨大王的雙手斧", cn = "兀突骨的大斧",  },
['3k_dlc06_ancillary_weapon_axe_stone_common'] = { dlc = "fw", category = "weapon", tier = "common", en = "Stone Axe", kr = "돌 도끼", zh = "石斧", cn = "石斧",  },
['3k_dlc06_ancillary_weapon_machete_common'] = { dlc = "fw", category = "weapon", tier = "common", en = "Machete", kr = "벌채도", zh = "砍刀", cn = "砍刀",  },
['3k_dlc06_ancillary_weapon_mixed_flint_common'] = { dlc = "fw", category = "weapon", tier = "common", en = "Twin-flint Weapons", kr = "부싯돌 몽둥이", zh = "火石斧錘", cn = "双持石制兵器",  },
['3k_dlc06_ancillary_armour_nanman_ahuinan_unique'] = { dlc = "fw", category = "armour", tier = "unique", en = "Ahuinan's Armour", kr = "아회남의 갑옷", zh = "阿會喃的護甲", cn = "阿会喃的护甲",  },
['3k_dlc06_ancillary_armour_nanman_dailaidongzhu_unique'] = { dlc = "fw", category = "armour", tier = "unique", en = "Dailai Dongzhu's Armour", kr = "대래동주의 갑옷", zh = "帶來洞主的護甲", cn = "带来洞主的护甲",  },
['3k_dlc06_ancillary_armour_nanman_dongtuna_unique'] = { dlc = "fw", category = "armour", tier = "unique", en = "Dongtuna's Armour", kr = "동도나의 갑옷", zh = "董荼那的護甲", cn = "董荼那的护甲",  },
['3k_dlc06_ancillary_armour_nanman_jinhuansanjie_unique'] = { dlc = "fw", category = "armour", tier = "unique", en = "Jinhuansanjie's Armour", kr = "금환삼결의 갑옷", zh = "金環三結的護甲", cn = "金环三结的护甲",  },
['3k_dlc06_ancillary_armour_nanman_king_duosi_unique'] = { dlc = "fw", category = "armour", tier = "unique", en = "King Duosi's Armour", kr = "타사대왕의 갑옷", zh = "朵思大王的護甲", cn = "朵思大王的护甲",  },
['3k_dlc06_ancillary_armour_nanman_king_meng_huo_unique'] = { dlc = "fw", category = "armour", tier = "unique", en = "King Meng Huo's Armour", kr = "맹획대왕의 갑옷", zh = "孟獲大王的護甲", cn = "孟获大王的护甲",  },
['3k_dlc06_ancillary_armour_nanman_king_mulu_unique'] = { dlc = "fw", category = "armour", tier = "unique", en = "King Mulu's Armour", kr = "목록대왕의 갑옷", zh = "木鹿大王的護甲", cn = "木鹿大王的护甲",  },
['3k_dlc06_ancillary_armour_nanman_king_shamoke_unique'] = { dlc = "fw", category = "armour", tier = "unique", en = "King Shamoke's Armour", kr = "사마가 대왕의 갑옷", zh = "沙摩柯大王的護甲", cn = "沙摩柯的护甲",  },
['3k_dlc06_ancillary_armour_nanman_king_wutugu_unique'] = { dlc = "fw", category = "armour", tier = "unique", en = "King Wutugu's Armour", kr = "올돌골대왕의 갑옷", zh = "兀突骨大王的護甲", cn = "兀突骨大王的护甲",  },
['3k_dlc06_ancillary_armour_nanman_lady_zhurong_unique'] = { dlc = "fw", category = "armour", tier = "unique", en = "Lady Zhurong's Armour", kr = "축융부인의 갑옷", zh = "祝融夫人的護甲", cn = "祝融夫人的护甲",  },
['3k_dlc06_ancillary_armour_nanman_mangyachang_unique'] = { dlc = "fw", category = "armour", tier = "unique", en = "Mangyachang's Armour", kr = "망아장의 갑옷", zh = "忙牙長的護甲", cn = "忙牙长的护甲",  },
['3k_dlc06_ancillary_armour_nanman_medium_unique'] = { dlc = "fw", category = "armour", tier = "unique", en = "Unique Tribal Armour", kr = "고유 부족 갑옷", zh = "獨特部族護甲", cn = "独特南蛮铠甲",  },
['3k_dlc06_ancillary_armour_nanman_meng_jie_unique'] = { dlc = "fw", category = "armour", tier = "unique", en = "Meng Jie's Armour", kr = "맹절의 갑옷", zh = "孟節的護甲", cn = "孟节的护甲",  },
['3k_dlc06_ancillary_armour_nanman_meng_you_unique'] = { dlc = "fw", category = "armour", tier = "unique", en = "Meng You's Armour", kr = "맹우의 갑옷", zh = "孟優的護甲", cn = "孟优的护甲",  },
['3k_dlc06_ancillary_armour_nanman_tu_an_unique'] = { dlc = "fw", category = "armour", tier = "unique", en = "Tu An's Armour", kr = "토안의 갑옷", zh = "土安的護甲", cn = "土安的护甲",  },
['3k_dlc06_ancillary_armour_nanman_xi_ni_unique'] = { dlc = "fw", category = "armour", tier = "unique", en = "Xi Ni's Armour", kr = "해니의 갑옷", zh = "奚泥的護甲", cn = "奚泥的护甲",  },
['3k_dlc06_ancillary_armour_nanman_yang_feng_unique'] = { dlc = "fw", category = "armour", tier = "unique", en = "Yang Feng's Armour", kr = "양봉의 갑옷", zh = "楊鋒的護甲", cn = "杨锋的护甲",  },
['3k_dlc06_ancilliary_armour_li_ru_armour_unique'] = { dlc = "fw", category = "armour", tier = "unique", en = "Li Ru's Armour", kr = "이유의 갑옷", zh = "李儒的護甲", cn = "李儒的护甲",  },
['3k_dlc06_ancilliary_armour_wei_yan_armour_unique'] = { dlc = "fw", category = "armour", tier = "unique", en = "Wei Yan's Armour", kr = "위연의 갑옷", zh = "魏延的護甲", cn = "魏延的护甲",  },
['3k_dlc06_ancilliary_armour_xun_you_armour_unique'] = { dlc = "fw", category = "armour", tier = "unique", en = "Xun You's Armour", kr = "순유의 갑옷", zh = "荀攸的護甲", cn = "荀攸的护甲",  },
['3k_dlc06_ancillary_armour_nanman_medium_exceptional'] = { dlc = "fw", category = "armour", tier = "exceptional", en = "Exceptional Tribal Armour", kr = "고급 부족 갑옷", zh = "卓越部族護甲", cn = "优异部落护甲",  },
['3k_dlc06_ancillary_armour_nanman_medium_refined'] = { dlc = "fw", category = "armour", tier = "refined", en = "Refined Tribal Armour", kr = "제련 부족 갑옷", zh = "高級部族護甲", cn = "精制部落护甲",  },
['3k_dlc06_ancillary_armour_nanman_medium_common'] = { dlc = "fw", category = "armour", tier = "common", en = "Common Tribal Armour", kr = "일반 부족 갑옷", zh = "一般部族護甲", cn = "普通部落护甲",  },
['3k_dlc06_ancillary_mount_elephant_unique'] = { dlc = "fw", category = "mount", tier = "unique", en = "Southern Elephant", kr = "남방 코끼리", zh = "南方象", cn = "南中巨象",  },
['3k_dlc06_ancillary_mount_elephant_exceptional'] = { dlc = "fw", category = "mount", tier = "exceptional", en = "Monarchial Elephant", kr = "제왕의 코끼리", zh = "君王象", cn = "君王战象",  },
['3k_dlc06_ancillary_mount_elephant_refined'] = { dlc = "fw", category = "mount", tier = "refined", en = "War Elephant", kr = "전쟁 코끼리", zh = "戰象", cn = "战象",  },
['3k_dlc06_ancillary_mount_elephant_common'] = { dlc = "fw", category = "mount", tier = "common", en = "Elephant", kr = "코끼리", zh = "大象", cn = "大象",  },
['3k_dlc06_ancillary_follower_shaman'] = { dlc = "fw", category = "follower", tier = "refined", en = "Shaman", kr = "주술사", zh = "巫師", cn = "巫觋",  },
['3k_dlc06_ancillary_follower_translator'] = { dlc = "fw", category = "follower", tier = "refined", en = "Representationist", kr = "부족의 대표자", zh = "象胥", cn = "象胥",  },
['3k_dlc06_ancillary_accessory_mulus_bell_unique'] = { dlc = "fw", category = "accessory", tier = "unique", en = "Mulu's Bell", kr = "목록종", zh = "蒂鐘", cn = "木鹿蒂钟",  },
['3k_dlc06_ancillary_weapon_bow_king_shamoke_unique'] = { dlc = "fw", category = "accessory", tier = "unique", en = "Red Wind", kr = "적풍", zh = "赤風弓", cn = "赤风",  },
['3k_dlc06_ancillary_accessory_flying_daggers'] = { dlc = "fw", category = "accessory", tier = "exceptional", en = "Flying Daggers", kr = "비도", zh = "飛刀", cn = "飞刀",  },
['3k_dlc06_ancillary_accessory_malaria_cure'] = { dlc = "fw", category = "accessory", tier = "refined", en = "Garlic-leaved Fragrance", kr = "향초 빻은 비약", zh = "薤葉芸香", cn = "薤叶芸香",  },
['3k_dlc06_ancillary_accessory_tribute_chest_diplomacy_extraordinary'] = { dlc = "fw", category = "accessory", tier = "refined", en = "Diplomat's Chest", kr = "외교관의 상자", zh = "使節寶箱", cn = "使节礼匣",  },
['3k_dlc06_ancillary_accessory_tribute_chest_diplomacy_simple'] = { dlc = "fw", category = "accessory", tier = "refined", en = "Trader's Chest", kr = "상인의 상자", zh = "商販寶箱", cn = "商贩礼匣",  },
['3k_dlc06_ancillary_accessory_tribute_chest_personal_extraordinary'] = { dlc = "fw", category = "accessory", tier = "refined", en = "Commander's Chest", kr = "지휘관의 상자", zh = "將帥寶箱", cn = "将帅礼匣",  },
['3k_dlc06_ancillary_accessory_tribute_chest_personal_simple'] = { dlc = "fw", category = "accessory", tier = "refined", en = "Lord's Chest", kr = "군주의 상자", zh = "勛爵寶箱", cn = "亲贵礼匣",  },
['3k_dlc06_ancillary_accessory_tribute_chest_regional_extraordinary'] = { dlc = "fw", category = "accessory", tier = "refined", en = "Industrialist's Chest", kr = "산업가의 상자", zh = "工官寶箱", cn = "工官礼匣",  },
['3k_dlc06_ancillary_accessory_tribute_chest_regional_simple'] = { dlc = "fw", category = "accessory", tier = "refined", en = "Economist's Chest", kr = "관리의 상자", zh = "濟民官寶箱", cn = "民吏礼匣",  },
-- fw 45
['3k_dlc07_ancillary_weapon_defence_of_levity'] = { dlc = "fd", category = "weapon", tier = "unique", en = "Defence of Levity", kr = "경박의 변호", zh = "浮浪戟", cn = "浮浪刃",  },
['3k_dlc07_ancillary_weapon_emperor_xian_weapon_unique'] = { dlc = "fd", category = "weapon", tier = "unique", en = "Imperial Gold Inlaid Blade", kr = "황실 황금 보검", zh = "鑲金尚方劍", cn = "错金尚方剑",  },
['3k_dlc07_ancillary_weapon_fear_and_discipline'] = { dlc = "fd", category = "weapon", tier = "unique", en = "Fear & Discipline", kr = "공포와 규율", zh = "威令雙刀", cn = "威厉对剑",  },
['3k_dlc07_ancillary_weapon_the_rule'] = { dlc = "fd", category = "weapon", tier = "unique", en = "The Rule", kr = "지배", zh = "鐵律槍", cn = "铁律枪",  },
['3k_dlc07_ancillary_armour_cao_pi_armour_unique'] = { dlc = "fd", category = "armour", tier = "unique", en = "Cao Pi's Armour", kr = "조비의 갑옷", zh = "曹丕的護甲", cn = "曹丕的护甲",  },
['3k_dlc07_ancillary_armour_cao_ren_armour_unique'] = { dlc = "fd", category = "armour", tier = "unique", en = "Cao Ren's Armour", kr = "조인의 갑옷", zh = "曹仁的護甲", cn = "曹仁的护甲",  },
['3k_dlc07_ancillary_armour_emperor_xian_armour_unique'] = { dlc = "fd", category = "armour", tier = "unique", en = "Emperor Xian's Armour", kr = "헌제의 갑옷", zh = "獻帝的護甲", cn = "献帝的护甲",  },
['3k_dlc07_ancillary_armour_fa_zheng_armour_unique'] = { dlc = "fd", category = "armour", tier = "unique", en = "Fa Zheng's Armour", kr = "법정의 갑옷", zh = "法正的護甲", cn = "法正的护甲",  },
['3k_dlc07_ancillary_armour_lady_zhen_armour_unique'] = { dlc = "fd", category = "armour", tier = "unique", en = "Lady Zhen's Armour", kr = "견부인의 갑옷", zh = "甄夫人的護甲", cn = "甄夫人的护甲",  },
['3k_dlc07_ancillary_armour_liu_yan_armour_unique'] = { dlc = "fd", category = "armour", tier = "unique", en = "Liu Yan's Armour", kr = "유언의 갑옷", zh = "劉焉的護甲", cn = "刘焉的护甲",  },
['3k_dlc07_ancillary_armour_wen_chou_armour_unique'] = { dlc = "fd", category = "armour", tier = "unique", en = "Wen Chou's Armour", kr = "문추의 갑옷", zh = "文醜的護甲", cn = "文丑的护甲",  },
['3k_dlc07_ancillary_armour_yan_liang_armour_unique'] = { dlc = "fd", category = "armour", tier = "unique", en = "Yan Liang's Armour", kr = "안량의 갑옷", zh = "顏良的護甲", cn = "颜良的护甲",  },
['3k_dlc07_ancillary_armour_yu_jin_armour_unique'] = { dlc = "fd", category = "armour", tier = "unique", en = "Yu Jin's Armour", kr = "우금의 갑옷", zh = "于禁的護甲", cn = "于禁的护甲",  },
['3k_dlc07_ancillary_armour_yuan_shang_armour_unique'] = { dlc = "fd", category = "armour", tier = "unique", en = "Yuan Shang's Armour", kr = "원상의 갑옷", zh = "袁尚的護甲", cn = "袁尚的护甲",  },
['3k_dlc07_ancillary_armour_yuan_tan_armour_unique'] = { dlc = "fd", category = "armour", tier = "unique", en = "Yuan Tan's Armour", kr = "원담의 갑옷", zh = "袁譚的護甲", cn = "袁谭的护甲",  },
['3k_dlc07_ancillary_armour_zhang_he_armour_unique'] = { dlc = "fd", category = "armour", tier = "unique", en = "Zhang He's Armour", kr = "장합의 갑옷", zh = "張郃的護甲", cn = "张郃的护甲",  },
['3k_dlc07_ancillary_follower_northern_army_captain'] = { dlc = "fd", category = "follower", tier = "unique", en = "Colonel of the Northern Army", kr = "북방군의 교위", zh = "北軍校尉", cn = "北军校尉",  },
['3k_dlc07_ancillary_weapon_honour_manifested'] = { dlc = "fd", category = "accessory", tier = "unique", en = "Honour Manifested", kr = "명예의 징표", zh = "孝悌弓", cn = "彰誉弓",  },
['3k_dlc07_ancillary_weapon_sequencer'] = { dlc = "fd", category = "accessory", tier = "unique", en = "Sequencer", kr = "인과", zh = "天序弓", cn = "天序弓",  },
-- fd 19
['ep_ancillary_armour_heavy_armour_fire_unique'] = { dlc = "ep", category = "armour", tier = "unique", en = "Dragon's Scales", kr = "용린", zh = "龍鱗甲", cn = "龙鳞甲",  },
['ep_ancillary_armour_heavy_armour_wood_unique'] = { dlc = "ep", category = "armour", tier = "unique", en = "Nature's Shield", kr = "자연의 방패", zh = "震巽鎧", cn = "天之盾",  },
['ep_ancillary_armour_light_armour_earth_unique'] = { dlc = "ep", category = "armour", tier = "unique", en = "Skin of the Peach Tree", kr = "도목피", zh = "桃樹皮甲", cn = "灵桃鳞皮",  },
['ep_ancillary_armour_light_armour_metal_unique'] = { dlc = "ep", category = "armour", tier = "unique", en = "Spirit of the Dog", kr = "견백", zh = "犬靈甲", cn = "犬獒之灵",  },
['ep_ancillary_armour_medium_armour_earth_unique'] = { dlc = "ep", category = "armour", tier = "unique", en = "Enduring Tortoise", kr = "오래 사는 거북이", zh = "龜壽甲", cn = "百忍玉灵",  },
['ep_ancillary_armour_medium_armour_fire_unique'] = { dlc = "ep", category = "armour", tier = "unique", en = "Raiments of War", kr = "전쟁의 의복", zh = "征戰寶甲", cn = "战意斗戎",  },
['ep_ancillary_armour_medium_armour_metal_unique'] = { dlc = "ep", category = "armour", tier = "unique", en = "Words of the Master", kr = "언어의 달인", zh = "祖訓戰甲", cn = "宗师之言",  },
['ep_ancillary_armour_medium_armour_wood_unique'] = { dlc = "ep", category = "armour", tier = "unique", en = "The Forest Crane", kr = "숲 속의 두루미", zh = "松鶴護甲", cn = "林中仙鹤",  },
['ep_ancillary_armour_strategist_light_armour_water_unique'] = { dlc = "ep", category = "armour", tier = "unique", en = "Robes of the Mantis", kr = "사마귀의 예복", zh = "螳螂袍", cn = "金丝螳螂袍",  },
['ep_ancillary_sima_ai_armour_unique'] = { dlc = "ep", category = "armour", tier = "unique", en = "Sima Ai's Armour", kr = "사마예의 갑옷", zh = "司馬乂的護甲", cn = "司马乂的护甲",  },
['ep_ancillary_sima_jiong_armour_unique'] = { dlc = "ep", category = "armour", tier = "unique", en = "Sima Jiong's Armour", kr = "사마경의 갑옷", zh = "司馬冏的護甲", cn = "司马冏的护甲",  },
['ep_ancillary_sima_liang_armour_unique'] = { dlc = "ep", category = "armour", tier = "unique", en = "Sima Liang's Armour", kr = "사마량의 갑옷", zh = "司馬亮的護甲", cn = "司马亮的护甲",  },
['ep_ancillary_sima_lun_armour_unique'] = { dlc = "ep", category = "armour", tier = "unique", en = "Sima Lun's Armour", kr = "사마륜의 갑옷", zh = "司馬倫的護甲", cn = "司马伦的护甲",  },
['ep_ancillary_sima_wei_armour_unique'] = { dlc = "ep", category = "armour", tier = "unique", en = "Sima Wei's Armour", kr = "사마위의 갑옷", zh = "司馬瑋的護甲", cn = "司马玮的护甲",  },
['ep_ancillary_sima_ying_armour_unique'] = { dlc = "ep", category = "armour", tier = "unique", en = "Sima Ying's Armour", kr = "사마영의 갑옷", zh = "司馬穎的護甲", cn = "司马颖的护甲",  },
['ep_ancillary_sima_yong_armour_unique'] = { dlc = "ep", category = "armour", tier = "unique", en = "Sima Yong's Armour", kr = "사마옹의 갑옷", zh = "司馬顒的護甲", cn = "司马颙的护甲",  },
['ep_ancillary_sima_yue_armour_unique'] = { dlc = "ep", category = "armour", tier = "unique", en = "Sima Yue's Armour", kr = "사마월의 갑옷", zh = "司馬越的護甲", cn = "司马越的护甲",  },
['ep_ancillary_armour_heavy_armour_fire_extraordinary'] = { dlc = "ep", category = "armour", tier = "exceptional", en = "Unyielding Scale Mail", kr = "튼튼한 어린갑", zh = "堅實鱗甲", cn = "坚固鳞甲",  },
['ep_ancillary_armour_heavy_armour_wood_extraordinary'] = { dlc = "ep", category = "armour", tier = "exceptional", en = "Redoubtable Mail", kr = "경이로운 갑옷", zh = "堅韌鎖甲", cn = "坚韧护甲",  },
['ep_ancillary_armour_light_armour_earth_extraordinary'] = { dlc = "ep", category = "armour", tier = "exceptional", en = "Thick Leather Hide", kr = "두터운 가죽", zh = "厚皮甲", cn = "厚重皮甲",  },
['ep_ancillary_armour_light_armour_metal_extraordinary'] = { dlc = "ep", category = "armour", tier = "exceptional", en = "Proficient's Scale Mail", kr = "명인의 어린갑", zh = "名家鱗甲", cn = "巧工鳞甲",  },
['ep_ancillary_armour_medium_armour_earth_extraordinary'] = { dlc = "ep", category = "armour", tier = "exceptional", en = "Armour of the Adept", kr = "숙련자의 갑옷", zh = "強將護甲", cn = "巧匠护甲",  },
['ep_ancillary_armour_medium_armour_fire_extraordinary'] = { dlc = "ep", category = "armour", tier = "exceptional", en = "The Boistrous Cricket", kr = "힘찬 귀뚜라미", zh = "鬥蟋甲", cn = "斗蟋甲",  },
['ep_ancillary_armour_medium_armour_metal_extraordinary'] = { dlc = "ep", category = "armour", tier = "exceptional", en = "Sage's Armour", kr = "현자의 갑옷", zh = "聖賢護甲", cn = "贤圣甲袍",  },
['ep_ancillary_armour_medium_armour_wood_extraordinary'] = { dlc = "ep", category = "armour", tier = "exceptional", en = "Forest Skin",kr = "식자의 의복", zh = "智者袍", cn = "智者之裳",  },
['hlyjckyanzhao_faction'] = {  kr = "숲의 살갗", zh = "木德皮甲", cn = "密林之肤",  },
['ep_ancillary_armour_strategist_light_armour_water_extraordinary'] = { dlc = "ep", category = "armour", tier = "exceptional", en = "Intellectual Vestures", dlc = "main", category = "accessory", tier = "unique", en = "hlyjckyanzhao", kr = "hlyjckyanzhao", zh = "hlyjckyanzhao", cn = "hlyjckyanzhao",  },
['hlyjcjwuqi_faction'] = { dlc = "main", category = "weapon", tier = "unique", en = "hlyjcjwuqi", kr = "hlyjcjwuqi", zh = "hlyjcjwuqi", cn = "hlyjcjwuqi",  },
['hlyjckwuqi_faction'] = { dlc = "main", category = "weapon", tier = "unique", en = "hlyjckwuqi", kr = "hlyjckwuqi", zh = "hlyjckwuqi", cn = "hlyjckwuqi",  },
['hlyjcjgun_faction'] = { dlc = "main", category = "weapon", tier = "unique", en = "hlyjcjgun", kr = "hlyjcjgun", zh = "hlyjcjgun", cn = "hlyjcjgun",  },
['summon_hlyjck'] = { dlc = "main", category = "weapon", tier = "unique", en = "summon_hlyjck", kr = "summon_hlyjck", zh = "summon_hlyjck", cn = "summon_hlyjck",  },

['hlyjdingzhiayifu'] = { dlc = "main", category = "armour", tier = "unique", en = "hlyjdingzhiayifu", kr = "hlyjdingzhiayifu", zh = "hlyjdingzhiayifu", cn = "hlyjdingzhiayifu",  },
['hlyjdingzhibyifu'] = { dlc = "main", category = "armour", tier = "unique", en = "hlyjdingzhibyifu", kr = "hlyjdingzhibyifu", zh = "hlyjdingzhibyifu", cn = "hlyjdingzhibyifu",  },
['hlyjdingzhicyifu'] = { dlc = "main", category = "armour", tier = "unique", en = "hlyjdingzhicyifu", kr = "hlyjdingzhicyifu", zh = "hlyjdingzhicyifu", cn = "hlyjdingzhicyifu",  },
['hlyjdingzhidzuoqi'] = { dlc = "xyy", category = "mount", tier = "unique", en = "donkey", kr = "hlyjdingzhidzuoqi", zh = "宝驴", cn = "宝驴",  },

-- ep 26
-- items 433/433

-- cp01 = 4, main = 260, ytr = 37, moh = 24, wb = 18, fw = 45, fd 19, ep = 26
}

		--========================================================================--
								--	Item DB Functions --
		--========================================================================--

function sandbox:item_node_title_key( ceo_key )

	local log_head = "item_node_title_key"
	
	if lib.is_empty( ceo_key ) or loc:is_mbs( ceo_key ) then
		return 'unknown'
	end

	if self.db_items[ ceo_key ] then
		return "ceo_nodes_title_"..self:get_ceo_node_key( ceo_key )
	end

	local node_title_key = "ceo_nodes_title_"..ceo_key
	
	--if effect.get_localised_string( node_title_key ) then return node_title_key end
	
	local dlc = nil
	
	if ceo_key:match( "^3k_" ) then dlc = ceo_key:match( "^(3k_[%a%d]+)" ) end
	if ceo_key:match( "^ep_" ) then dlc = 'ep' end

	logger:dev( log_head, dlc, ceo_key )

	if dlc then
		local kindof, key = ceo_key:match( dlc.."_ancillary_(%a+)_([%d%a_]+)" )
		local _faction = false
		
		logger:dev( log_head, kindof, key )
		
		if key:match( "_faction$" ) then
			key = key:gsub( "_faction$", "" )
			_faction = true
			
			logger:dev( log_head, key )
		end
		
		node_title_key = "ceo_nodes_title_"..dlc.."_ancillary_"..key
		logger:dev( log_head, node_title_key )
		if effect.get_localised_string( node_title_key ) then return node_title_key end
			
		node_title_key = "ceo_nodes_title_"..dlc.."_ancillary_"..kindof.."_"..key
		logger:dev( log_head, node_title_key )
		if effect.get_localised_string( node_title_key ) then return node_title_key end
		
		if _faction then
			key = key.."_faction"
			
			node_title_key = "ceo_nodes_title_"..dlc.."_ancillary_"..key
			logger:dev( log_head, node_title_key )
			if effect.get_localised_string( node_title_key ) then return node_title_key end
				
			node_title_key = "ceo_nodes_title_"..dlc.."_ancillary_"..kindof.."_"..key
			logger:dev( log_head, node_title_key )
			if effect.get_localised_string( node_title_key ) then return node_title_key end
		end
	else
		local head, kindof, key = ceo_key:match( "([%a%d_]+)_ancillary_(%a+)_([%d%a_]+)" )
		
		if not head then
			head, key = ceo_key:match( "([%a%d_]+)_ancillary_(%a+)_([%d%a_]+)" )
			kindof = ""
		else
			kindof = kindof.."_"
		end

		if head and key then
			node_title_key = "ceo_nodes_title_"..head.."_ancillary_"..kindof..key
			if effect.get_localised_string( node_title_key ) then return node_title_key end
		end
	end

	logger:dev( log_head, "ceo_nodes_title_"..ceo_key )
	return "ceo_nodes_title_"..ceo_key
end

		--========================================================================--
								--	Build DB items
		--========================================================================--

function sandbox:assign_item_alias( item )
	local log_head = "assign_item_alias"
	local prev_indent = logger:inc_indent()
	
	local sub_en = item.en:gsub( "%s", ""):lower()
	local sub_kr = item.kr:gsub( "%s", "")
	local sub_zh = item.zh:gsub( "%s", "")
	local sub_cn = item.cn:gsub( "%s", "")
	
	if sub_kr ~= "" then
		if not self.db_item_aliases[ sub_kr ] then
			self.db_item_aliases[ sub_kr ] = item.ceo_key
		else
			logger:warn( log_head, "dup kr", self.db_item_aliases[ sub_kr ], "["..item.kr.."]", item.ceo_key )
		end
	end

	if sub_en ~= "" then
		if not self.db_item_aliases[ sub_en ] then
			self.db_item_aliases[ sub_en ] = item.ceo_key
		else
			logger:warn( log_head, "dup en", self.db_item_aliases[ sub_en ], "["..item.en.."]", item.ceo_key )
		end
	end

	if sub_zh ~= "" then
		if not self.db_item_aliases[ sub_zh ] then
			self.db_item_aliases[ sub_zh ] = item.ceo_key
		else
			logger:warn( log_head, "dup zh", self.db_item_aliases[ sub_zh ], "["..item.zh.."]", item.ceo_key )
		end
	end
	
	if sub_cn ~= "" and sub_cn ~= sub_zh then
		if not self.db_item_aliases[ sub_cn ] then
			self.db_item_aliases[ sub_cn ] = item.ceo_key
		else
			logger:warn( log_head, "dup cn", self.db_item_aliases[ sub_cn ], "["..item.cn.."]", item.ceo_key )
		end
	end
	
	logger:set_indent( prev_indent )
end

function sandbox:merge_mod_items( mod_name, mod_items )
	
	local log_head = "merge_mod_items:"..mod_name
	local ban_list = {}
	
	local count, ban_count = 0, 0
	
	for ceo_key, item in pairs( mod_items ) do
		if not self.db_items[ ceo_key ] then
			if not item_ban_list[ ceo_key ] then

				item.ceo_key = ceo_key
				------------------------------------
				self.db_items[ ceo_key ] = item
				------------------------------------
				self:assign_item_alias( item )
				------------------------------------
				count = count + 1			
			else
				ban_count = ban_count + 1
			end
		else
			logger:error( log_head, "duplicate ceo_key", ceo_key )
		end
	end
	
	logger:info( log_head, _eq( "aliased", count ), _eq( "banned", ban_count ) )
end

function sandbox:build_item_aliases( db_items, append )

	local log_head = "build_item_aliases"

	if not append then
		self.db_item_aliases = {}
	end

	local count, ban_count = 0, 0
	
	for ceo_key, item in pairs( db_items ) do
		if not item_ban_list[ ceo_key ] then

			item.ceo_key = ceo_key
			------------------------------------
			self:assign_item_alias( item )
			------------------------------------
			count = count + 1
		else
			ban_count = ban_count + 1
		end
	end

	self.db_item_aliases['왕옥과']	= "3k_main_ancillary_accessory_king_of_jade_ge"
	self.db_item_aliases['주고문관']	= "3k_main_ancillary_follower_provincial_advisor"
	self.db_item_aliases['주감사관']	= "3k_main_ancillary_follower_provincial_auditor"
	self.db_item_aliases['노사비파']	= "3k_dlc04_ancillary_accessory_nushe_bifa_unique"

	logger:info( log_head, _eq( "aliased", count ), _eq( "banned", ban_count ) )
end

function sandbox:build_db_items()
	
	self:build_item_aliases( self.db_items, false )
	
	if self:is_mod_on( "tup" ) then
		self:merge_mod_items( "tup", self.db_tup_items )
	end
end
--[[
*****************************************************************
3k_dlc05_faction_ceos_sun_ce.lua
SETUP
*****************************************************************
]]--

-- Don't load in campaigns which don't require it.
if cm.name == "ep_eight_princes" or cm.name == "three_kingdoms_early" then
	output("3k_dlc05_faction_ceos_sun_ce.lua: Not loaded in this campaign." );
	return;
else
	output("3k_dlc05_faction_ceos_sun_ce.lua: Loading");
end;

sc_faction_ceos = {};

-- VARIABLES
local sun_ce_faction_key = "3k_dlc05_faction_sun_ce";
local system_id = "[402] sc_faction_ceos - ";
local sun_ce_template_key = "3k_main_template_historical_sun_ce_hero_fire";
local huang_zu_template_key = "3k_main_template_historical_huang_zu_hero_wood";
local yan_baihu_template_key = "3k_main_template_historical_yan_baihu_hero_metal";
local sun_ce_ceo_category = "3k_dlc05_ceo_category_factional_sun_ce";

-- Initialise the incident values when loading a game if they aren't already setup
cm:add_first_tick_callback(function() 
	if not cm:saved_value_exists("ceo_set_sun_ce_ceo_ambitions_initialised", "ceo_set_sun_ce_ceo_ambitions") then
		if cm.name == "dlc07_guandu" then
			cm:set_saved_value("3k_dlc05_ceo_set_sun_ce_secure_the_heartland_scripted",3,"ceo_set_sun_ce_ceo_ambitions")
			cm:set_saved_value("3k_dlc05_ceo_set_sun_ce_secure_the_middle_yangtze_scripted",1,"ceo_set_sun_ce_ceo_ambitions")
			cm:set_saved_value("3k_dlc05_ceo_set_sun_ce_secure_wu_scripted",1,"ceo_set_sun_ce_ceo_ambitions")
			cm:set_saved_value("3k_dlc05_ceo_set_sun_ce_secure_kuaiji_scripted",0,"ceo_set_sun_ce_ceo_ambitions")
			cm:set_saved_value("3k_dlc05_ceo_set_sun_ce_the_little_conqueror_scripted",2,"ceo_set_sun_ce_ceo_ambitions")
			cm:set_saved_value("3k_dlc05_ceo_set_sun_ce_old_guard_scripted",0,"ceo_set_sun_ce_ceo_ambitions")
			cm:set_saved_value("3k_dlc05_ceo_set_sun_ce_young_guard_scripted",0,"ceo_set_sun_ce_ceo_ambitions")
			cm:set_saved_value("3k_dlc05_ceo_set_sun_ce_governors_and_scholars_scripted",2,"ceo_set_sun_ce_ceo_ambitions")
			cm:set_saved_value("3k_dlc05_ceo_set_sun_ce_four_warriors_of_china_scripted",1,"ceo_set_sun_ce_ceo_ambitions")
			cm:set_saved_value("3k_dlc05_ceo_set_sun_ce_bandits_and_murders_scripted",1,"ceo_set_sun_ce_ceo_ambitions")
			cm:set_saved_value("3k_dlc05_ceo_set_sun_ce_secure_the_homestead_scripted",4,"ceo_set_sun_ce_ceo_ambitions")
			cm:set_saved_value("3k_dlc05_ceo_set_sun_ce_fulfil_zhou_yu_ambition_scripted",4,"ceo_set_sun_ce_ceo_ambitions")
			cm:set_saved_value("3k_dlc05_ceo_set_sun_ce_legacy_of_sun_ce_scripted",2,"ceo_set_sun_ce_ceo_ambitions")
			cm:set_saved_value("3k_dlc05_ceo_set_sun_ce_grandmasters_scripted",5,"ceo_set_sun_ce_ceo_ambitions")
			cm:set_saved_value("3k_dlc05_ceo_set_sun_ce_the_southern_threat_scripted",3,"ceo_set_sun_ce_ceo_ambitions")
		else
			cm:set_saved_value("3k_dlc05_ceo_set_sun_ce_the_southern_threat_scripted",4,"ceo_set_sun_ce_ceo_ambitions")
			cm:set_saved_value("3k_dlc05_ceo_set_sun_ce_old_guard_scripted",2,"ceo_set_sun_ce_ceo_ambitions")
			cm:set_saved_value("3k_dlc05_ceo_set_sun_ce_the_little_conqueror_scripted",3,"ceo_set_sun_ce_ceo_ambitions")
			cm:set_saved_value("3k_dlc05_ceo_set_sun_ce_fulfil_zhou_yu_ambition_scripted",4,"ceo_set_sun_ce_ceo_ambitions")
			cm:set_saved_value("3k_dlc05_ceo_set_sun_ce_secure_the_heartland_scripted",3,"ceo_set_sun_ce_ceo_ambitions")
			cm:set_saved_value("3k_dlc05_ceo_set_sun_ce_secure_the_middle_yangtze_scripted",4,"ceo_set_sun_ce_ceo_ambitions")
			cm:set_saved_value("3k_dlc05_ceo_set_sun_ce_secure_the_homestead_scripted",4,"ceo_set_sun_ce_ceo_ambitions")
			cm:set_saved_value("3k_dlc05_ceo_set_sun_ce_secure_wu_scripted",3,"ceo_set_sun_ce_ceo_ambitions")
			cm:set_saved_value("3k_dlc05_ceo_set_sun_ce_secure_kuaiji_scripted",3,"ceo_set_sun_ce_ceo_ambitions")
			cm:set_saved_value("3k_dlc05_ceo_set_sun_ce_young_guard_scripted",3,"ceo_set_sun_ce_ceo_ambitions")
			cm:set_saved_value("3k_dlc05_ceo_set_sun_ce_legacy_of_sun_ce_scripted",3,"ceo_set_sun_ce_ceo_ambitions")
			cm:set_saved_value("3k_dlc05_ceo_set_sun_ce_four_warriors_of_china_scripted",2,"ceo_set_sun_ce_ceo_ambitions")
			cm:set_saved_value("3k_dlc05_ceo_set_sun_ce_grandmasters_scripted",5,"ceo_set_sun_ce_ceo_ambitions")
			cm:set_saved_value("3k_dlc05_ceo_set_sun_ce_governors_and_scholars_scripted",2,"ceo_set_sun_ce_ceo_ambitions")
			cm:set_saved_value("3k_dlc05_ceo_set_sun_ce_bandits_and_murders_scripted",2,"ceo_set_sun_ce_ceo_ambitions")
		end;

		cm:set_saved_value("ceo_set_sun_ce_ceo_ambitions_initialised", true, "ceo_set_sun_ce_ceo_ambitions")
	end
end);

---which character template should reward which CEO--
sc_faction_ceos.captured_region_to_ceo = {
	-- Secure regions
	["3k_main_jianye_capital"]="3k_dlc05_ceo_sun_ce_ambition_secure_jianye_capital",
	["3k_main_jianye_resource_1"]="3k_dlc05_ceo_sun_ce_ambition_secure_jianye_salt_mine",
	["3k_main_jianye_resource_2"]="3k_dlc05_ceo_sun_ce_ambition_secure_jianye_copper_mine",
	["3k_main_xindu_capital"]="3k_dlc05_ceo_sun_ce_ambition_secure_xindu_capital",
	["3k_main_xindu_resource_1"]="3k_dlc05_ceo_sun_ce_ambition_secure_xindu_lumber_yard",
	["3k_main_xindu_resource_2"]="3k_dlc05_ceo_sun_ce_ambition_secure_xindu_fishing_port",
	["3k_main_kuaiji_capital"]="3k_dlc05_ceo_sun_ce_ambition_secure_kuaiji_capital",
	["3k_main_kuaiji_resource_1"]="3k_dlc05_ceo_sun_ce_ambition_secure_kuaiji_rice_paddy",
	["3k_main_kuaiji_resource_2"]="3k_dlc05_ceo_sun_ce_ambition_secure_kuaiji_livestock",
	["3k_main_poyang_capital"]="3k_dlc05_ceo_sun_ce_ambition_secure_poyang_capital",
	["3k_main_poyang_resource_1"]="3k_dlc05_ceo_sun_ce_ambition_secure_poyang_iron_mine",
	["3k_main_poyang_resource_2"]="3k_dlc05_ceo_sun_ce_ambition_secure_poyang_copper_mine",
	["3k_main_poyang_resource_3"]="3k_dlc05_ceo_sun_ce_ambition_secure_poyang_weapon_craftsmen",
	["3k_main_changsha_capital"]="3k_dlc05_ceo_sun_ce_ambition_secure_changsha_capital",
	["3k_main_changsha_resource_1"]="3k_dlc05_ceo_sun_ce_ambition_secure_changsha_trade_port",
	["3k_main_changsha_resource_2"]="3k_dlc05_ceo_sun_ce_ambition_secure_changsha_armour_craftsmen",
	["3k_main_changsha_resource_3"]="3k_dlc05_ceo_sun_ce_ambition_secure_changsha_teahouse",
	["3k_main_jingzhou_capital"]="3k_dlc05_ceo_sun_ce_ambition_secure_jiangling_capital",
	["3k_main_jingzhou_resource_1"]="3k_dlc05_ceo_sun_ce_ambition_secure_jiangling_livestock",
	["3k_main_xiangyang_capital"]="3k_dlc05_ceo_sun_ce_ambition_secure_xiangyang_capital",
	["3k_main_xiangyang_resource_1"]="3k_dlc05_ceo_sun_ce_ambition_secure_xiangyang_toolmaker",
	--ARTERY OF THE WORLD
	["3k_main_jincheng_capital"]="3k_dlc05_ceo_sun_ce_ambition_achieve_artery_of_the_world",
	["3k_main_jincheng_resource_1"]="3k_dlc05_ceo_sun_ce_ambition_achieve_artery_of_the_world",
	["3k_main_wuwei_resource_1"]="3k_dlc05_ceo_sun_ce_ambition_achieve_artery_of_the_world",
	["3k_main_wuwei_resource_2"]="3k_dlc05_ceo_sun_ce_ambition_achieve_artery_of_the_world",
	["3k_main_anding_resource_3"]="3k_dlc05_ceo_sun_ce_ambition_achieve_artery_of_the_world",
	["3k_main_shoufang_resource_1"]="3k_dlc05_ceo_sun_ce_ambition_achieve_artery_of_the_world",
	["3k_main_shoufang_resource_2"]="3k_dlc05_ceo_sun_ce_ambition_achieve_artery_of_the_world",
	["3k_main_shoufang_capital"]="3k_dlc05_ceo_sun_ce_ambition_achieve_artery_of_the_world",
	["3k_main_xihe_capital"]="3k_dlc05_ceo_sun_ce_ambition_achieve_artery_of_the_world",
	["3k_main_anding_resource_1"]="3k_dlc05_ceo_sun_ce_ambition_achieve_artery_of_the_world",
	["3k_main_hedong_capital"]="3k_dlc05_ceo_sun_ce_ambition_achieve_artery_of_the_world",
	["3k_main_changan_capital"]="3k_dlc05_ceo_sun_ce_ambition_achieve_artery_of_the_world",
	["3k_main_luoyang_capital"]="3k_dlc05_ceo_sun_ce_ambition_achieve_artery_of_the_world",
	["3k_main_luoyang_resource_1"]="3k_dlc05_ceo_sun_ce_ambition_achieve_artery_of_the_world",
	["3k_main_hedong_resource_1"]="3k_dlc05_ceo_sun_ce_ambition_achieve_artery_of_the_world",
	["3k_main_henei_capital"]="3k_dlc05_ceo_sun_ce_ambition_achieve_artery_of_the_world",
	["3k_main_henei_resource_1"]="3k_dlc05_ceo_sun_ce_ambition_achieve_artery_of_the_world",
	["3k_main_yingchuan_resource_1"]="3k_dlc05_ceo_sun_ce_ambition_achieve_artery_of_the_world",
	["3k_main_dongjun_capital"]="3k_dlc05_ceo_sun_ce_ambition_achieve_artery_of_the_world",
	["3k_main_taishan_capital"]="3k_dlc05_ceo_sun_ce_ambition_achieve_artery_of_the_world",
	["3k_main_taishan_resource_1"]="3k_dlc05_ceo_sun_ce_ambition_achieve_artery_of_the_world",
	["3k_main_pingyuan_capital"]="3k_dlc05_ceo_sun_ce_ambition_achieve_artery_of_the_world",
	["3k_main_pingyuan_resource_1"]="3k_dlc05_ceo_sun_ce_ambition_achieve_artery_of_the_world"
}

--If the region is south of the Yangtze, put the region on the list
sc_faction_ceos.regions_south_of_the_yangtze = {
	["3k_main_jianye_capital"]="3k_dlc05_ceo_sun_ce_ambition_achieve_wolf_cub_roars",
	["3k_main_jianye_resource_1"]="3k_dlc05_ceo_sun_ce_ambition_achieve_wolf_cub_roars",
	["3k_main_jianye_resource_2"]="3k_dlc05_ceo_sun_ce_ambition_achieve_wolf_cub_roars",
	["3k_main_xindu_capital"]="3k_dlc05_ceo_sun_ce_ambition_achieve_wolf_cub_roars",
	["3k_main_xindu_resource_1"]="3k_dlc05_ceo_sun_ce_ambition_achieve_wolf_cub_roars",
	["3k_main_xindu_resource_2"]="3k_dlc05_ceo_sun_ce_ambition_achieve_wolf_cub_roars",
	["3k_main_poyang_capital"]="3k_dlc05_ceo_sun_ce_ambition_achieve_wolf_cub_roars",
	["3k_main_poyang_resource_1"]="3k_dlc05_ceo_sun_ce_ambition_achieve_wolf_cub_roars",
	["3k_main_poyang_resource_2"]="3k_dlc05_ceo_sun_ce_ambition_achieve_wolf_cub_roars",
	["3k_main_poyang_resource_3"]="3k_dlc05_ceo_sun_ce_ambition_achieve_wolf_cub_roars",
	["3k_main_changsha_capital"]="3k_dlc05_ceo_sun_ce_ambition_achieve_wolf_cub_roars",
	["3k_main_changsha_resource_1"]="3k_dlc05_ceo_sun_ce_ambition_achieve_wolf_cub_roars",
	["3k_main_changsha_resource_2"]="3k_dlc05_ceo_sun_ce_ambition_achieve_wolf_cub_roars",
	["3k_main_changsha_resource_3"]="3k_dlc05_ceo_sun_ce_ambition_achieve_wolf_cub_roars",
	["3k_main_badong_capital"]="3k_dlc05_ceo_sun_ce_ambition_achieve_wolf_cub_roars",
	["3k_main_badong_resource_1"]="3k_dlc05_ceo_sun_ce_ambition_achieve_wolf_cub_roars",
	["3k_main_badong_resource_2"]="3k_dlc05_ceo_sun_ce_ambition_achieve_wolf_cub_roars",
	["3k_main_fuling_capital"]="3k_dlc05_ceo_sun_ce_ambition_achieve_wolf_cub_roars",
	["3k_main_fuling_resource_1"]="3k_dlc05_ceo_sun_ce_ambition_achieve_wolf_cub_roars",
	["3k_main_jiangyang_resource_2"]="3k_dlc05_ceo_sun_ce_ambition_achieve_wolf_cub_roars",
	["3k_main_jiangyang_resource_3"]="3k_dlc05_ceo_sun_ce_ambition_achieve_wolf_cub_roars",
	["3k_main_kuaiji_capital"]="3k_dlc05_ceo_sun_ce_ambition_achieve_wolf_cub_roars",
	["3k_main_kuaiji_resource_1"]="3k_dlc05_ceo_sun_ce_ambition_achieve_wolf_cub_roars",
	["3k_main_kuaiji_resource_2"]="3k_dlc05_ceo_sun_ce_ambition_achieve_wolf_cub_roars",
	["3k_main_jianan_capital"]="3k_dlc05_ceo_sun_ce_ambition_achieve_wolf_cub_roars",
	["3k_main_jianan_resource_1"]="3k_dlc05_ceo_sun_ce_ambition_achieve_wolf_cub_roars",
	["3k_main_jianan_resource_2"]="3k_dlc05_ceo_sun_ce_ambition_achieve_wolf_cub_roars",
	["3k_main_yuzhang_capital"]="3k_dlc05_ceo_sun_ce_ambition_achieve_wolf_cub_roars",
	["3k_main_yuzhang_resource_1"]="3k_dlc05_ceo_sun_ce_ambition_achieve_wolf_cub_roars",
	["3k_main_yuzhang_resource_2"]="3k_dlc05_ceo_sun_ce_ambition_achieve_wolf_cub_roars",
	["3k_main_yuzhang_resource_3"]="3k_dlc05_ceo_sun_ce_ambition_achieve_wolf_cub_roars",
	["3k_main_luling_capital"]="3k_dlc05_ceo_sun_ce_ambition_achieve_wolf_cub_roars",
	["3k_main_luling_resource_1"]="3k_dlc05_ceo_sun_ce_ambition_achieve_wolf_cub_roars",
	["3k_main_ye_capital"]="3k_dlc05_ceo_sun_ce_ambition_achieve_wolf_cub_roars",
	["3k_main_ye_resource_1"]="3k_dlc05_ceo_sun_ce_ambition_achieve_wolf_cub_roars",
	["3k_main_dongou_capital"]="3k_dlc05_ceo_sun_ce_ambition_achieve_wolf_cub_roars",
	["3k_main_dongou_resource_1"]="3k_dlc05_ceo_sun_ce_ambition_achieve_wolf_cub_roars",
	["3k_main_tongan_capital"]="3k_dlc05_ceo_sun_ce_ambition_achieve_wolf_cub_roars",
	["3k_main_tongan_resource_1"]="3k_dlc05_ceo_sun_ce_ambition_achieve_wolf_cub_roars",
	["3k_main_nanhai_capital"]="3k_dlc05_ceo_sun_ce_ambition_achieve_wolf_cub_roars",
	["3k_main_nanhai_resource_1"]="3k_dlc05_ceo_sun_ce_ambition_achieve_wolf_cub_roars",
	["3k_main_nanhai_resource_2"]="3k_dlc05_ceo_sun_ce_ambition_achieve_wolf_cub_roars",
	["3k_main_nanhai_resource_3"]="3k_dlc05_ceo_sun_ce_ambition_achieve_wolf_cub_roars",
	["3k_main_lingling_capital"]="3k_dlc05_ceo_sun_ce_ambition_achieve_wolf_cub_roars",
	["3k_main_lingling_resource_1"]="3k_dlc05_ceo_sun_ce_ambition_achieve_wolf_cub_roars",
	["3k_main_lingling_resource_2"]="3k_dlc05_ceo_sun_ce_ambition_achieve_wolf_cub_roars",
	["3k_main_lingling_resource_3"]="3k_dlc05_ceo_sun_ce_ambition_achieve_wolf_cub_roars",
	["3k_main_wuling_capital"]="3k_dlc05_ceo_sun_ce_ambition_achieve_wolf_cub_roars",
	["3k_main_wuling_resource_1"]="3k_dlc05_ceo_sun_ce_ambition_achieve_wolf_cub_roars",
	["3k_main_wuling_resource_2"]="3k_dlc05_ceo_sun_ce_ambition_achieve_wolf_cub_roars",
	["3k_main_wuling_resource_3"]="3k_dlc05_ceo_sun_ce_ambition_achieve_wolf_cub_roars",
	["3k_main_zangke_capital"]="3k_dlc05_ceo_sun_ce_ambition_achieve_wolf_cub_roars",
	["3k_main_zangke_resource_1"]="3k_dlc05_ceo_sun_ce_ambition_achieve_wolf_cub_roars",
	["3k_main_zangke_resource_2"]="3k_dlc05_ceo_sun_ce_ambition_achieve_wolf_cub_roars",
	["3k_main_cangwu_capital"]="3k_dlc05_ceo_sun_ce_ambition_achieve_wolf_cub_roars",
	["3k_main_cangwu_resource_1"]="3k_dlc05_ceo_sun_ce_ambition_achieve_wolf_cub_roars",
	["3k_main_cangwu_resource_2"]="3k_dlc05_ceo_sun_ce_ambition_achieve_wolf_cub_roars",
	["3k_main_cangwu_resource_3"]="3k_dlc05_ceo_sun_ce_ambition_achieve_wolf_cub_roars",
	["3k_main_yulin_capital"]="3k_dlc05_ceo_sun_ce_ambition_achieve_wolf_cub_roars",
	["3k_main_yulin_resource_1"]="3k_dlc05_ceo_sun_ce_ambition_achieve_wolf_cub_roars",
	["3k_main_yulin_resource_2"]="3k_dlc05_ceo_sun_ce_ambition_achieve_wolf_cub_roars",
	["3k_main_gaoliang_capital"]="3k_dlc05_ceo_sun_ce_ambition_achieve_wolf_cub_roars",
	["3k_main_gaoliang_resource_1"]="3k_dlc05_ceo_sun_ce_ambition_achieve_wolf_cub_roars",
	["3k_main_hepu_capital"]="3k_dlc05_ceo_sun_ce_ambition_achieve_wolf_cub_roars",
	["3k_main_hepu_resource_1"]="3k_dlc05_ceo_sun_ce_ambition_achieve_wolf_cub_roars",
	["3k_main_hepu_resource_2"]="3k_dlc05_ceo_sun_ce_ambition_achieve_wolf_cub_roars",
	["3k_main_jiaozhi_capital"]="3k_dlc05_ceo_sun_ce_ambition_achieve_wolf_cub_roars",
	["3k_main_jiaozhi_resource_1"]="3k_dlc05_ceo_sun_ce_ambition_achieve_wolf_cub_roars",
	["3k_main_jiaozhi_resource_2"]="3k_dlc05_ceo_sun_ce_ambition_achieve_wolf_cub_roars",
	["3k_main_yizhou_capital"]="3k_dlc05_ceo_sun_ce_ambition_achieve_wolf_cub_roars",
	["3k_main_yizhou_island_capital"]="3k_dlc05_ceo_sun_ce_ambition_achieve_wolf_cub_roars",
	["3k_main_yizhou_island_resource_1"]="3k_dlc05_ceo_sun_ce_ambition_achieve_wolf_cub_roars",
	["3k_main_yizhou_resource_1"]="3k_dlc05_ceo_sun_ce_ambition_achieve_wolf_cub_roars",
	["3k_main_yizhou_resource_2"]="3k_dlc05_ceo_sun_ce_ambition_achieve_wolf_cub_roars",
	["3k_main_jianning_capital"]="3k_dlc05_ceo_sun_ce_ambition_achieve_wolf_cub_roars",
	["3k_main_jianning_resource_1"]="3k_dlc05_ceo_sun_ce_ambition_achieve_wolf_cub_roars",
	["3k_main_jianning_resource_2"]="3k_dlc05_ceo_sun_ce_ambition_achieve_wolf_cub_roars"
}

--DLC05 - SUN CE CEO TO INCIDENT
sc_faction_ceos.ceo_to_incident = {
	["3k_dlc05_ceo_sun_ce_ambition_achieve_artery_of_the_world"]="3k_dlc05_ceo_set_sun_ce_the_southern_threat_scripted",
	["3k_dlc05_ceo_sun_ce_ambition_achieve_independence"]="3k_dlc05_ceo_set_sun_ce_the_southern_threat_scripted",
	["3k_dlc05_ceo_sun_ce_ambition_achieve_new_centrum"]="3k_dlc05_ceo_set_sun_ce_the_southern_threat_scripted",
	["3k_dlc05_ceo_sun_ce_ambition_achieve_wolf_cub_roars"]="3k_dlc05_ceo_set_sun_ce_the_southern_threat_scripted",
	["3k_dlc05_ceo_sun_ce_ambition_secure_jianye_capital"]="3k_dlc05_ceo_set_sun_ce_secure_wu_scripted",
	["3k_dlc05_ceo_sun_ce_ambition_secure_jianye_copper_mine"]="3k_dlc05_ceo_set_sun_ce_secure_wu_scripted",
	["3k_dlc05_ceo_sun_ce_ambition_secure_jianye_salt_mine"]="3k_dlc05_ceo_set_sun_ce_secure_wu_scripted",
	["3k_dlc05_ceo_sun_ce_ambition_secure_poyang_capital"]="3k_dlc05_ceo_set_sun_ce_secure_the_middle_yangtze_scripted",
	["3k_dlc05_ceo_sun_ce_ambition_secure_poyang_copper_mine"]="3k_dlc05_ceo_set_sun_ce_secure_the_middle_yangtze_scripted",
	["3k_dlc05_ceo_sun_ce_ambition_secure_poyang_iron_mine"]="3k_dlc05_ceo_set_sun_ce_secure_the_middle_yangtze_scripted",	
	["3k_dlc05_ceo_sun_ce_ambition_secure_poyang_weapon_craftsmen"]="3k_dlc05_ceo_set_sun_ce_secure_the_middle_yangtze_scripted",			
	["3k_dlc05_ceo_sun_ce_ambition_secure_changsha_capital"]="3k_dlc05_ceo_set_sun_ce_secure_the_homestead_scripted",
	["3k_dlc05_ceo_sun_ce_ambition_secure_changsha_armour_craftsmen"]="3k_dlc05_ceo_set_sun_ce_secure_the_homestead_scripted",
	["3k_dlc05_ceo_sun_ce_ambition_secure_changsha_teahouse"]="3k_dlc05_ceo_set_sun_ce_secure_the_homestead_scripted",	
	["3k_dlc05_ceo_sun_ce_ambition_secure_changsha_trade_port"]="3k_dlc05_ceo_set_sun_ce_secure_the_homestead_scripted",			
	["3k_dlc05_ceo_sun_ce_ambition_secure_xindu_capital"]="3k_dlc05_ceo_set_sun_ce_secure_the_heartland_scripted",
	["3k_dlc05_ceo_sun_ce_ambition_secure_xindu_fishing_port"]="3k_dlc05_ceo_set_sun_ce_secure_the_heartland_scripted",
	["3k_dlc05_ceo_sun_ce_ambition_secure_xindu_lumber_yard"]="3k_dlc05_ceo_set_sun_ce_secure_the_heartland_scripted",				
	["3k_dlc05_ceo_sun_ce_ambition_secure_kuaiji_capital"]="3k_dlc05_ceo_set_sun_ce_secure_kuaiji_scripted",
	["3k_dlc05_ceo_sun_ce_ambition_secure_kuaiji_livestock"]="3k_dlc05_ceo_set_sun_ce_secure_kuaiji_scripted",
	["3k_dlc05_ceo_sun_ce_ambition_secure_kuaiji_rice_paddy"]="3k_dlc05_ceo_set_sun_ce_secure_kuaiji_scripted",			
	["3k_dlc05_ceo_sun_ce_ambition_recruit_young_earth_wood"]="3k_dlc05_ceo_set_sun_ce_young_guard_scripted",
	["3k_dlc05_ceo_sun_ce_ambition_recruit_young_metal_fire"]="3k_dlc05_ceo_set_sun_ce_young_guard_scripted",
	["3k_dlc05_ceo_sun_ce_ambition_recruit_young_water"]="3k_dlc05_ceo_set_sun_ce_young_guard_scripted",			
	["3k_dlc05_ceo_sun_ce_ambition_recruit_old_fire"]="3k_dlc05_ceo_set_sun_ce_old_guard_scripted",
	["3k_dlc05_ceo_sun_ce_ambition_recruit_old_metal"]="3k_dlc05_ceo_set_sun_ce_old_guard_scripted",			
	["3k_dlc05_ceo_sun_ce_ambition_recruit_high_level_sun_ce"]="3k_dlc05_ceo_set_sun_ce_legacy_of_sun_ce_scripted",
	["3k_dlc05_ceo_sun_ce_ambition_recruit_high_level_zhou_yu"]="3k_dlc05_ceo_set_sun_ce_legacy_of_sun_ce_scripted",
	["3k_dlc05_ceo_sun_ce_ambition_recruit_high_level_sun_quan"]="3k_dlc05_ceo_set_sun_ce_legacy_of_sun_ce_scripted",	
	["3k_dlc05_ceo_sun_ce_ambition_recruit_high_level_lady_sun"]="3k_dlc05_ceo_set_sun_ce_legacy_of_sun_ce_scripted",				
	["3k_dlc05_ceo_sun_ce_ambition_recruit_grandmasters_earth"]="3k_dlc05_ceo_set_sun_ce_grandmasters_scripted",
	["3k_dlc05_ceo_sun_ce_ambition_recruit_grandmasters_fire"]="3k_dlc05_ceo_set_sun_ce_grandmasters_scripted",
	["3k_dlc05_ceo_sun_ce_ambition_recruit_grandmasters_metal"]="3k_dlc05_ceo_set_sun_ce_grandmasters_scripted",	
	["3k_dlc05_ceo_sun_ce_ambition_recruit_grandmasters_water"]="3k_dlc05_ceo_set_sun_ce_grandmasters_scripted",	
	["3k_dlc05_ceo_sun_ce_ambition_recruit_grandmasters_wood"]="3k_dlc05_ceo_set_sun_ce_grandmasters_scripted",				
	["3k_dlc05_ceo_sun_ce_ambition_recruit_official_earth"]="3k_dlc05_ceo_set_sun_ce_governors_and_scholars_scripted",	
	["3k_dlc05_ceo_sun_ce_ambition_recruit_official_water"]="3k_dlc05_ceo_set_sun_ce_governors_and_scholars_scripted",
	["3k_dlc05_ceo_sun_ce_ambition_recruit_female_earth_wood"]="3k_dlc05_ceo_set_sun_ce_four_warriors_of_china_scripted",	
	["3k_dlc05_ceo_sun_ce_ambition_recruit_female_metal_fire"]="3k_dlc05_ceo_set_sun_ce_four_warriors_of_china_scripted",
	["3k_dlc05_ceo_sun_ce_ambition_secure_jiangling_capital"]="3k_dlc05_ceo_set_sun_ce_fulfil_zhou_yu_ambition_scripted",	
	["3k_dlc05_ceo_sun_ce_ambition_secure_jiangling_livestock"]="3k_dlc05_ceo_set_sun_ce_fulfil_zhou_yu_ambition_scripted",	
	["3k_dlc05_ceo_sun_ce_ambition_secure_xiangyang_capital"]="3k_dlc05_ceo_set_sun_ce_fulfil_zhou_yu_ambition_scripted",	
	["3k_dlc05_ceo_sun_ce_ambition_secure_xiangyang_toolmaker"]="3k_dlc05_ceo_set_sun_ce_fulfil_zhou_yu_ambition_scripted",
	["3k_dlc05_ceo_sun_ce_ambition_achieve_sun_familiy_rises_again"]="3k_dlc05_ceo_set_sun_ce_the_little_conqueror_scripted",
	["3k_dlc05_ceo_sun_ce_ambition_achieve_tiny_conqueror"]="3k_dlc05_ceo_set_sun_ce_the_little_conqueror_scripted",
	["3k_dlc05_ceo_sun_ce_ambition_achieve_unbeatable"]="3k_dlc05_ceo_set_sun_ce_the_little_conqueror_scripted",
	["3k_dlc05_ceo_sun_ce_ambition_achieve_defeat_huang_zu"]="3k_dlc05_ceo_set_sun_ce_bandits_and_murders_scripted",
	["3k_dlc05_ceo_sun_ce_ambition_achieve_defeat_the_white_tiger"]="3k_dlc05_ceo_set_sun_ce_bandits_and_murders_scripted"			
}

--[[
*****************************************************************
LISTENERS
*****************************************************************
]]--

-- Add the listeners for the different events.
function sc_faction_ceos:add_listeners()

	--After the fourth battle, the player is rewarded with Jiang Qin and Zhou Tai
	core:add_listener(
	"PendingBattleSunCeFireCampIncident", -- Unique handle
	"CampaignBattleLoggedEvent", -- Campaign Event to listen for
	function(context)

		return context:log_entry():winning_factions():any_of(function(query_faction) return query_faction:name() == sun_ce_faction_key end)

	end,
	function(context) -- What to do if listener fires.

		--if no counter then set to 0
		if not cm:saved_value_exists("dlc05_sun_ce_battles_fought_counter_zhou_tai_event", "dlc05_sun_ce") then
			cm:set_saved_value("dlc05_sun_ce_battles_fought_counter_zhou_tai_event", 0, "dlc05_sun_ce")
		end

		--adds 1 to count
		local current_counter = cm:get_saved_value("dlc05_sun_ce_battles_fought_counter_zhou_tai_event", "dlc05_sun_ce") + 1

		--updates value
		cm:set_saved_value("dlc05_sun_ce_battles_fought_counter_zhou_tai_event", current_counter, "dlc05_sun_ce")

		if current_counter >= 4 then
			local sun_ce_faction = cm:query_faction(sun_ce_faction_key)

			local zhou_tai_character = cm:query_model():character_for_template("3k_main_template_historical_zhou_tai_hero_fire")
			local jiang_qin_character =cm:query_model():character_for_template("3k_main_template_historical_jiang_qin_hero_fire") 

			if sun_ce_faction:is_human()
			and zhou_tai_character:is_null_interface() and jiang_qin_character:is_null_interface() then
				cm:trigger_incident(sun_ce_faction_key, "3k_dlc05_historical_jiang_qin_and_zhou_tai_joins_incident", true, true)
				
				--listener cleans up after itself
				core:remove_listener("PendingBattleSunCeFireCampIncident")
			end
		end		
	end,
	true --Is persistent
	);


	--Occupy settlement event 
	core:add_listener(
		"GarrisonOccupiedEventSunCe", -- Unique handle
		"GarrisonOccupiedEvent", -- Campaign Event to listen for
		function(context)
			return (self:was_my_faction(context:query_character():faction()))
		end,
		function(context) -- What to do if listener fires.
			--Occupy 5 settlements with Sun Ce as commanding genneral
			if (context:query_character():is_faction_leader()) then
				self:add_directly_ceos_for_achieving("3k_dlc05_ceo_sun_ce_ambition_achieve_tiny_conqueror",false)
			end
		end,
		true --Is persistent
	);

	--Occupy settlement event 
	core:add_listener(
		"GarrisonOccupiedEventSunCe", -- Unique handle
		"RegionOwnershipChanged", -- Campaign Event to listen for
		function(context)
			return not context:new_owner():is_null_interface() and self:was_my_faction(context:new_owner())
		end,
		function(context) -- What to do if listener fires.
			local region_name=context:region():name();
			--If the region hasn't been conquered before (so "artery of the world" can't be completed by conquering the same city)
			if not cm:saved_value_exists(region_name, "sun_ce_ambitions") then
				self:add_ceos_for_capturing_region(region_name,false)
				cm:set_saved_value(region_name,true,"sun_ce_ambitions")
			end
		end,
		true --Is persistent
	);

	--Start of Faction turn 
	core:add_listener(
		"FactionTurnStartSunCe", -- Unique handle
		"FactionTurnStart", -- Campaign Event to listen for
		function(context)
			return (self:was_my_faction(context:faction()))
		end,
		function(context) -- What to do if listener fires.
			local sun_ce_faction = context:faction();

			--Check if certain characters are in court
			--Ranks have to be +1 higher than what they need to be
			for i = 0, sun_ce_faction:character_list():num_items() - 1 do
				local character_key = sun_ce_faction:character_list():item_at(i);
				local character_key_template_key = character_key:generation_template_key();
				local character_key_rank = character_key:rank()

				if 5<=character_key_rank then
					--Check if age matches one of the targets					
					local character_key_age = character_key:age()

					--OLD GUARD
					if 40<=character_key_age then
						--If type matches fire, metal or wood
						if character_key:character_subtype("3k_general_fire") then
							self:add_directly_ceos_for_achieving("3k_dlc05_ceo_sun_ce_ambition_recruit_old_fire",true)
						elseif character_key:character_subtype("3k_general_metal") then
							self:add_directly_ceos_for_achieving("3k_dlc05_ceo_sun_ce_ambition_recruit_old_metal",true)
						elseif character_key:character_subtype("3k_general_wood") then
							self:add_directly_ceos_for_achieving("3k_dlc05_ceo_sun_ce_ambition_recruit_old_wood",true)
						end
					end

					--NEXT GENERATION				
					if character_key:has_come_of_age() and character_key_age<=30 then
						--Must not be Sun Ce
						if character_key_template_key ~= "3k_main_template_historical_sun_ce_hero_fire" then
							if (character_key:character_subtype("3k_general_fire") or character_key:character_subtype("3k_general_metal")) then
								self:add_directly_ceos_for_achieving("3k_dlc05_ceo_sun_ce_ambition_recruit_young_metal_fire",true)
							elseif character_key:character_subtype("3k_general_water") then
								self:add_directly_ceos_for_achieving("3k_dlc05_ceo_sun_ce_ambition_recruit_young_water",true)
							elseif (character_key:character_subtype("3k_general_wood") or character_key:character_subtype("3k_general_earth")) then
								self:add_directly_ceos_for_achieving("3k_dlc05_ceo_sun_ce_ambition_recruit_young_earth_wood",true)
							end
						end
					end

					local character_key_is_male = character_key:is_male()						
					--FOUR WARRIORS OF CHINA
					if not character_key_is_male then
						-- Increases women court members ceo
						if (character_key:character_subtype("3k_general_earth")) then
							if (cm:saved_value_exists("female_recruited_earth_wood", "sun_ce_ambitions")) then
								local character_name = cm:get_saved_value("female_recruited_earth_wood", "sun_ce_ambitions")
								if character_name~=character_key_template_key then
									self:add_directly_ceos_for_achieving("3k_dlc05_ceo_sun_ce_ambition_recruit_female_earth_wood",true)										
								end
							else
								self:add_directly_ceos_for_achieving("3k_dlc05_ceo_sun_ce_ambition_recruit_female_earth_wood",true)
								cm:set_saved_value("female_recruited_earth_wood",character_key_template_key ,"sun_ce_ambitions")
							end
						elseif (character_key:character_subtype("3k_general_metal") or character_key:character_subtype("3k_general_fire")) then
							if (cm:saved_value_exists("female_recruited_metal_fire", "sun_ce_ambitions")) then
								local character_name = cm:get_saved_value("female_recruited_metal_fire", "sun_ce_ambitions")
								if character_name~=character_key_template_key then
									self:add_directly_ceos_for_achieving("3k_dlc05_ceo_sun_ce_ambition_recruit_female_metal_fire",true)										
								end
							else
								self:add_directly_ceos_for_achieving("3k_dlc05_ceo_sun_ce_ambition_recruit_female_metal_fire",true)
								cm:set_saved_value("female_recruited_metal_fire",character_key_template_key ,"sun_ce_ambitions")
							end
						end
					end

					if 6<=character_key_rank then						
						--If type matches earth or water
						if character_key:character_subtype("3k_general_earth") then
							if (cm:saved_value_exists("recruited_earth_official", "sun_ce_ambitions")) then
								local character_name = cm:get_saved_value("recruited_earth_official", "sun_ce_ambitions")
								if character_name~=character_key_template_key then
									self:add_directly_ceos_for_achieving("3k_dlc05_ceo_sun_ce_ambition_recruit_official_earth",true)							
								end
							else
								self:add_directly_ceos_for_achieving("3k_dlc05_ceo_sun_ce_ambition_recruit_official_earth",true)
								cm:set_saved_value("recruited_earth_official",character_key_template_key ,"sun_ce_ambitions")
							end							
						elseif character_key:character_subtype("3k_general_water") then
							if (cm:saved_value_exists("recruited_water_official", "sun_ce_ambitions")) then
								local character_name = cm:get_saved_value("recruited_water_official", "sun_ce_ambitions")
								if character_name~=character_key_template_key then
									self:add_directly_ceos_for_achieving("3k_dlc05_ceo_sun_ce_ambition_recruit_official_water",true)										
								end
							else
								self:add_directly_ceos_for_achieving("3k_dlc05_ceo_sun_ce_ambition_recruit_official_water",true)
								cm:set_saved_value("recruited_water_official",character_key_template_key ,"sun_ce_ambitions")
							end							
						end

						--LEGACY OF SUN CE	
						if character_key_template_key== "3k_main_template_historical_sun_quan_hero_earth" then
							self:add_directly_ceos_for_achieving("3k_dlc05_ceo_sun_ce_ambition_recruit_high_level_sun_quan",true)	
						elseif character_key_template_key== "3k_main_template_historical_lady_sun_shangxiang_hero_fire" then
							self:add_directly_ceos_for_achieving("3k_dlc05_ceo_sun_ce_ambition_recruit_high_level_lady_sun",true)							
						elseif character_key_template_key== "3k_main_template_historical_zhou_yu_hero_water" and 7<=character_key_rank then
							self:add_directly_ceos_for_achieving("3k_dlc05_ceo_sun_ce_ambition_recruit_high_level_zhou_yu",true)	
						elseif character_key_template_key== "3k_main_template_historical_sun_ce_hero_fire" and 7<=character_key_rank then
							self:add_directly_ceos_for_achieving("3k_dlc05_ceo_sun_ce_ambition_recruit_high_level_sun_ce",true)							
						end
					end
				end
				--GRAND MASTERS
				if 160<=character_key:get_current_attribute_value("authority") then
					self:add_directly_ceos_for_achieving("3k_dlc05_ceo_sun_ce_ambition_recruit_grandmasters_earth",true)
				end
				if 160<=character_key:get_current_attribute_value("cunning") then
					self:add_directly_ceos_for_achieving("3k_dlc05_ceo_sun_ce_ambition_recruit_grandmasters_water",true)
				end
				if 160<=character_key:get_current_attribute_value("expertise") then
					self:add_directly_ceos_for_achieving("3k_dlc05_ceo_sun_ce_ambition_recruit_grandmasters_metal",true)
				end
				if 160<=character_key:get_current_attribute_value("instinct") then
					self:add_directly_ceos_for_achieving("3k_dlc05_ceo_sun_ce_ambition_recruit_grandmasters_fire",true)
				end
				if 160<=character_key:get_current_attribute_value("resolve") or 160<=character_key:get_current_attribute_value("resolve_records") then
					self:add_directly_ceos_for_achieving("3k_dlc05_ceo_sun_ce_ambition_recruit_grandmasters_wood",true)
				end
			end
			-- Check if certain regions are controlled by the player
			for i = 0, sun_ce_faction:faction_province_list():num_items() - 1 do
				local province_key = sun_ce_faction:faction_province_list():item_at(i);
				for i = 0, province_key:region_list():num_items() - 1 do
					local region_key = province_key:region_list():item_at(i);
					local region_name = region_key:name()
					--If the region hasn't been conquered before (so "artery of the world" and "Wolf cub roars" can't be completed by conquering the same city)
					if not cm:saved_value_exists(region_name, "sun_ce_ambitions") then
						self:add_ceos_for_capturing_region(region_name,true)
						cm:set_saved_value(region_name,region_name ,"sun_ce_ambitions")
					end
					
					--Check if Sun Ce has luoyang capital and it's city level is above 5 or if he has a city that is above level 9
					if region_name=="3k_main_luoyang_capital" then
						if(region_key:building_exists("3k_city_5") or 
						region_key:building_exists("3k_city_6") or  
						region_key:building_exists("3k_city_7") or  
						region_key:building_exists("3k_city_8") or 
						region_key:building_exists("3k_city_9") or 
						region_key:building_exists("3k_city_10")) then
							self:add_directly_ceos_for_achieving("3k_dlc05_ceo_sun_ce_ambition_achieve_new_centrum",true) 
						end
					else if (region_key:building_exists("3k_city_9") or 
						region_key:building_exists("3k_city_10")) then
							self:add_directly_ceos_for_achieving("3k_dlc05_ceo_sun_ce_ambition_achieve_new_centrum",true) 
						end
					end
				end				
			end	

			-- Check if player has deployed five commanders
			local number_of_deployed_characters = 0
			for m = 0,sun_ce_faction:military_force_list():num_items() - 1 do
				local military_force = sun_ce_faction:military_force_list():item_at(m)
				for c = 0,military_force:character_list():num_items() - 1 do
					local military_force_character = military_force:character_list():item_at(c)
					if string.match(military_force_character:generation_template_key(),"hero_") or string.match(military_force_character:generation_template_key(),"general_") then
						number_of_deployed_characters = number_of_deployed_characters+1
					end
				end
			end
			if (5<=number_of_deployed_characters) then 
				self:add_directly_ceos_for_achieving("3k_dlc05_ceo_sun_ce_ambition_achieve_sun_familiy_rises_again",true) 
			end

			--Check if the player is independent (returns false if the player has a vassal)
			if not diplomacy_manager:is_vassal(sun_ce_faction_key) then 
				self:add_directly_ceos_for_achieving("3k_dlc05_ceo_sun_ce_ambition_achieve_independence",true)
			end 

			--Check if Yan Baihu or Huang Zu is dead.
			local yan_baihu_character = cm:query_character(yan_baihu_template_key)
			if not yan_baihu_character:is_null_interface() then
				if yan_baihu_character:is_dead() then
					self:add_directly_ceos_for_achieving("3k_dlc05_ceo_sun_ce_ambition_achieve_defeat_the_white_tiger",true)
				end
			end	
			local huang_zu_character = cm:query_character(huang_zu_template_key)
			if not huang_zu_character:is_null_interface() then
				if huang_zu_character:is_dead() then
					self:add_directly_ceos_for_achieving("3k_dlc05_ceo_sun_ce_ambition_achieve_defeat_huang_zu",true)
				end
			end

			--Check if Huang Zu or Yan Baihu are defeated.
			local yan_baihu_faction = cm:query_faction("3k_dlc05_faction_white_tiger_yan");
			if not yan_baihu_faction or yan_baihu_faction:is_null_interface() or yan_baihu_faction:is_dead() then
				self:add_directly_ceos_for_achieving("3k_dlc05_ceo_sun_ce_ambition_achieve_defeat_the_white_tiger")			
			end;

			local huang_zu_faction = cm:query_faction("3k_main_faction_huang_zu");
			if not huang_zu_faction or huang_zu_faction:is_null_interface() or huang_zu_faction:is_dead() then
				self:add_directly_ceos_for_achieving("3k_dlc05_ceo_sun_ce_ambition_achieve_defeat_huang_zu")			
			end;



			-- Reset this flag so incidents can fire again.
			if self.is_new_game then
				self.is_new_game = false
			end;

		end,
		true --Is persistent
	);
	--END: Start of Faction turn 
		 
	-- Sun Ce Special experience ceo 
	core:add_listener(
		"CharacterCeoAddedToSunCe", -- Unique handle
		"CharacterCeoAdded", -- Campaign Event to listen for
		function(context)
			return (self:was_my_faction(context:query_character():faction()) and (context:ceo():ceo_data_key()=="3k_dlc05_ceo_hidden_shared_expertise"))
		end,
		function(context) -- What to do if listener fires.
			local ceo_key = context:ceo():ceo_data_key(); --Get Ceo
			local character_modifier = context:modify_character(); 
			character_modifier:ceo_management():remove_ceos(ceo_key); -- Remove CEO
			--Based on rank, grant experience
			local rank = context:query_character():rank();
			if rank < 3 then
				character_modifier:add_experience(5000,0);
			elseif rank < 7 then
				character_modifier:add_experience(8000,0);
			elseif rank < 11 then
				character_modifier:add_experience(15000,0);
			end
		end,
		true --Is persistent
	); 

	--Check battle and check performance
	core:add_listener(
		"CampaignBattleLoggedEventSunCeWins", -- Unique handle
		"CampaignBattleLoggedEvent", -- Campaign Event to listen for
		function(context)
		local log_entry = context:log_entry();
			return self:was_my_faction_in_winning_list(log_entry:winning_factions());
		end,
		function(context) -- What to do if listener fires.
			local log_entry = context:log_entry();
			--Check if Huang Zu or Yan Baihu were defeated
			local losing_characters=log_entry:losing_characters()

			local is_sun_ce_turn = cm:query_model():world():whose_turn_is_it():name() == sun_ce_faction_key
			for i = 0, losing_characters:num_items() - 1 do
				local losing_character = losing_characters:item_at(i):character()
				if not losing_character:is_null_interface() then
					if losing_character:generation_template_key()=="3k_main_template_historical_yan_baihu_hero_metal" then
						self:add_directly_ceos_for_achieving("3k_dlc05_ceo_sun_ce_ambition_achieve_defeat_the_white_tiger",not is_sun_ce_turn)
					elseif losing_character:generation_template_key()=="3k_main_template_historical_huang_zu_hero_wood" then
						self:add_directly_ceos_for_achieving("3k_dlc05_ceo_sun_ce_ambition_achieve_defeat_huang_zu",not is_sun_ce_turn)
					end
				end
			end

			--DUELS
			--Did Sun Ce win a duel
			for i = 0, log_entry:duels():num_items() - 1 do
				local duel = log_entry:duels():item_at(i);
				if duel:has_winner() then
					local character = duel:winner();
					if character:is_faction_leader() and self:was_my_faction(character:faction()) then
						self:add_directly_ceos_for_achieving("3k_dlc05_ceo_sun_ce_ambition_achieve_unbeatable",not is_sun_ce_turn)	
					end;
				end;
			end;
		
		end,
		true --Is persistent
	);
	  
end;

--[[
*****************************************************************
HELPERS
*****************************************************************
]]--

--Equips the Faction CEO
function sc_faction_ceos:equip_ceo(ceo_key)	
	local faction_ceos_category_all = cm:query_faction_ceos(sun_ce_faction_key):all_ceo_equipment_slots_for_category(sun_ce_ceo_category);

	for i = 0, faction_ceos_category_all:num_items() -1 do
		local faction_ceos_category_ceo_slot = faction_ceos_category_all:item_at(i); 
		--Find an empty CEO Slot
		if faction_ceos_category_ceo_slot:equipped_ceo():is_null_interface() then
			--Equip the CEO
			cm:modify_faction_ceos(sun_ce_faction_key):equip_ceo_in_slot(faction_ceos_category_ceo_slot,ceo_key);
			break
		end
	end
end

function sc_faction_ceos:get_ceo_from_string(ceo_key_string)
	local faction_ceo_manager = cm:query_faction(sun_ce_faction_key):ceo_management();

	if(faction_ceo_manager == nil) then 
		self:print("faction_ceo_manager is nil")
	else 
		for i = 0, faction_ceo_manager:all_ceos_for_category(sun_ce_ceo_category):num_items() -1 do
			local ceo=faction_ceo_manager:all_ceos_for_category(sun_ce_ceo_category):item_at(i); 
			if ceo:ceo_data_key() == ceo_key_string then 
				return ceo
			end
		end
	end	
	return nil;
end

--Go through the winning factions list and see if my faction is part of the list
function sc_faction_ceos:was_my_faction_in_winning_list(winning_factions)
	for i = 0, winning_factions:num_items() - 1 do
		if winning_factions:item_at(i):name()== sun_ce_faction_key then return true end
	end	
	return false
end;

--Check if it's my faction
function sc_faction_ceos:was_my_faction(query_faction)
	return query_faction:name() == sun_ce_faction_key;
end;

--Grant "Reckless Luck" pooled resource to Sun Ce
function sc_faction_ceos:grant_reckless_luck_to_sun_ce(bundle_granted_outside_of_turn)	
	local modify_faction = cm:modify_faction(sun_ce_faction_key);
	if not modify_faction:is_null_interface() then
		local sun_ce_faction = cm:query_faction(sun_ce_faction_key)
		if not sun_ce_faction:is_null_interface() then
			local amount = 1
			--If the Reckless Luck effect isn't present and it's granted outside of the players turn, increase the amount to 2. Otherwise it will not take effect proberly.
			if not sun_ce_faction:has_effect_bundle("3k_dlc05_payload_pressing_your_reckless_luck") and bundle_granted_outside_of_turn then
				amount = 2
			end
			modify_faction:apply_effect_bundle("3k_dlc05_payload_pressing_your_reckless_luck",amount);	
		end		
	end	
end

--Add Sun Ce ambition if specific region was captured. 
--Template_id is the ID of the region
--Was_completed_outside_of_players_turn determines if the ambition was done before the player could control. Important for determining length of reward.
function sc_faction_ceos:add_ceos_for_capturing_region(region_key,was_completed_outside_of_players_turn)
	if self.captured_region_to_ceo[region_key] ~= nil then
		self:add_points(self.captured_region_to_ceo[region_key], 1)
		local ceo_check = self:get_ceo_from_string((self.captured_region_to_ceo[region_key]))
		--IS IT AN ACTUAL CEO
		if (ceo_check ~= nil) then
			--CHECK IF NOT EQUIPED IN A SLOT
			if(not ceo_check:is_equipped_in_slot()) then			
				--CHECK IF HIGH ENOUGH POINTS TO BE EQUIPED
				if(ceo_check:max_points_in_ceo()<=ceo_check:num_points_in_ceo()) then
					self:equip_ceo(ceo_check)
					self:grant_reckless_luck_to_sun_ce(was_completed_outside_of_players_turn)
				end
			end
		end		
	end;
	
	--If the region can't be found, then increase: 3k_dlc05_ceo_sun_ce_ambition_achieve_wolf_cub_roars
	if self.regions_south_of_the_yangtze[region_key] == nil then
		self:add_points("3k_dlc05_ceo_sun_ce_ambition_achieve_wolf_cub_roars", 1)
		local ceo_check = self:get_ceo_from_string("3k_dlc05_ceo_sun_ce_ambition_achieve_wolf_cub_roars")
		--IS IT AN ACTUAL CEO
		if (ceo_check ~= nil) then
			--CHECK IF NOT EQUIPED IN A SLOT
			if(not ceo_check:is_equipped_in_slot()) then			
				--CHECK IF HIGH ENOUGH POINTS TO BE EQUIPED
				if(ceo_check:max_points_in_ceo()<=ceo_check:num_points_in_ceo()) then
					self:equip_ceo(ceo_check)
					self:grant_reckless_luck_to_sun_ce(was_completed_outside_of_players_turn)
				end
			end
		end	
	end

end;

--Add points to specific Sun Ce ambition
--ceo_id is the ID of the ambition
--Was_completed_outside_of_players_turn determines if the ambition was done before the player could control. Important for determining length of reward.
function sc_faction_ceos:add_directly_ceos_for_achieving(ceo_id,was_completed_outside_of_players_turn)
	self:add_points(ceo_id, 1)
	local ceo_check = self:get_ceo_from_string(ceo_id)
	--IS IT AN ACTUAL CEO
	if (ceo_check ~= nil) then
		--CHECK IF NOT EQUIPED IN A SLOT
		if(not ceo_check:is_equipped_in_slot()) then			
			--CHECK IF HIGH ENOUGH POINTS TO BE EQUIPED
			if(ceo_check:max_points_in_ceo()<=ceo_check:num_points_in_ceo()) then
				self:equip_ceo(ceo_check)								
				self:grant_reckless_luck_to_sun_ce(was_completed_outside_of_players_turn)
			end
		end
	else
		self:print("Sun Ce's ceo: "..ceo_id.." coundln't be found")
	end
end;

function sc_faction_ceos:add_points(ceo_key, ceo_points)
	local points = ceo_points
	if not is_string(ceo_key) then
		script_error("sc_faction_ceos:add_points() ceo_key must be a string.");
		return false;
	end;

	if not is_number(points) then
		script_error("sc_faction_ceos:add_points() points must be a number.");
		return false;
	end;

	local modify_faction = cm:modify_faction(sun_ce_faction_key);

	if not modify_faction or modify_faction:is_null_interface() then
		script_error("sc_faction_ceos:add_points() Unable to get modify faction.");
		return false;
	end;

	local ceo_mgmt = modify_faction:ceo_management();

	-- Make sure we got a CEO interface
	if not ceo_mgmt or ceo_mgmt:is_null_interface() then
		script_error("sc_faction_ceos:add_points() No CEO Management interface.");
		return false;
	end;
	
	local ceo_check = self:get_ceo_from_string(ceo_key)
	if ceo_check:num_points_in_ceo() < ceo_check:max_points_in_ceo() then
	
		-- No reason to add more points beyond the max, and the same condition checks if we're already maxed too
		local ceo_max_change = ceo_check:max_points_in_ceo() - ceo_check:num_points_in_ceo()
		if points > ceo_max_change  then
			points = ceo_max_change
		end
		
		-- If points aren't 0 it means we want to change the CEO, and we're not trying to push it above and beyond the max.
		if points ~= 0 then
		
			local m_model = cm:modify_model():get_modify_episodic_scripting();		
			
			-- Temporarily suppress the event feed whilst modifying a Sun Ce ceo..
			m_model:disable_event_feed_events(true, "", "3k_event_subcategory_ceo_ancillaries_gained", "");
			
			--Add the points ..
			ceo_mgmt:change_points_of_ceos(ceo_key, points);
			
			--And reenable the event feed!
			m_model:disable_event_feed_events(false, "", "3k_event_subcategory_ceo_ancillaries_gained", "");
			
			self:print("***SUN CE CEOS*** Adding points to [" .. ceo_key .. "]");
			return true;
		else
			self:print("***SUN CE CEOS*** Trying to add points to [" .. ceo_key .. "], but it's at the max");
			return false;
		end
	end
	
end;

function sc_faction_ceos:add_listeners_ceo_set()
	core:add_listener(
		"FactionCeoNodeChangedSunCeCeoSet", -- Unique handle
		"FactionCeoNodeChanged", -- Campaign Event to listen for
		function(context)
			return (context:faction():name() == sun_ce_faction_key 
				and context:faction():is_human() 
				and context:ceo():max_points_in_ceo() <= context:ceo():num_points_in_ceo())
				and self.ceo_to_incident[context:ceo():ceo_data_key()]
				and not self.is_new_game
		end,
		function(context)
			
			local sun_ce_ambition_ceo_incident = self.ceo_to_incident[context:ceo():ceo_data_key()]
			if sun_ce_ambition_ceo_incident ~= nil then
				if cm:saved_value_exists(sun_ce_ambition_ceo_incident, "ceo_set_sun_ce_ceo_ambitions") then
					local sun_ce_ambition_ceo_incident_value = cm:get_saved_value(sun_ce_ambition_ceo_incident, "ceo_set_sun_ce_ceo_ambitions")
					sun_ce_ambition_ceo_incident_value = sun_ce_ambition_ceo_incident_value - 1
					cm:set_saved_value(sun_ce_ambition_ceo_incident,sun_ce_ambition_ceo_incident_value,"ceo_set_sun_ce_ceo_ambitions")
					if sun_ce_ambition_ceo_incident_value <= 0 then
						cm:trigger_incident(sun_ce_faction_key, sun_ce_ambition_ceo_incident, true, true);
					end
				end
			end
	
		end,
		true
	);
end;

-- Function to print to the console. Wrapps up functionality to there is a singular point.
function sc_faction_ceos:print(string)
	out.design(system_id .. string);
end;



--[[
*****************************************************************
INITIALISERS
*****************************************************************
]]--

function sc_faction_ceos:new_game()
	output("Sun Ce faction CEO script NEW GAME.");

	local sun_ce_faction = cm:query_faction(sun_ce_faction_key);
	if not sun_ce_faction or sun_ce_faction:is_null_interface() then
		output("3k_dlc05_faction_ceos_sun_ce: Sun Ce's faction not found, exiting.")
		return;
	end;

	--"UN-EQUIP FACTION ITEMS FROM THE START"
	local faction_ceos_category_all = sun_ce_faction:ceo_management():all_ceo_equipment_slots_for_category(sun_ce_ceo_category);

	faction_ceos_category_all:foreach(function(faction_ceos_category_ceo)
		if not faction_ceos_category_ceo:equipped_ceo():is_null_interface() then 
			cm:modify_faction_ceos(sun_ce_faction_key):unequip_slot(faction_ceos_category_ceo);
		end
	end)

	self.is_new_game = true;
end;

function sc_faction_ceos:initialise()
	output("Sun Ce faction CEO script initialised.");
	
	local sun_ce_faction = cm:query_faction(sun_ce_faction_key);
	if not sun_ce_faction or sun_ce_faction:is_null_interface() then
		output("3k_dlc05_faction_ceos_sun_ce: Sun Ce's faction not found, exiting.")
		return;
	end;
	
	-- Different unlock criteria for human/AI factions?
	if sun_ce_faction:is_human() then
		self:add_listeners_ceo_set();
	end;

	self:add_listeners();
end;

cm:add_first_tick_callback_new(function() sc_faction_ceos:new_game() end);
cm:add_first_tick_callback(function() sc_faction_ceos:initialise() end);
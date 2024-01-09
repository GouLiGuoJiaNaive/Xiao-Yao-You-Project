-- #region Emergent Factions
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- EMERGENT FACTIONS
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
dlc04_emergent_factions = {};

function dlc04_emergent_factions:register()
	-- "3k_main_faction_yuan_shao"
	local yuan_shao_faction = emergent_faction:new("yuan_shao", "3k_main_faction_yuan_shao", "3k_main_weijun_capital", true);
	yuan_shao_faction:add_faction_leader("3k_main_template_historical_yuan_shao_hero_earth", "3k_general_earth", true);
	yuan_shao_faction:add_emergence_dilemma("3k_dlc04_emergence_global_emergence_spawn_yuan_shao_dilemma");
	yuan_shao_faction:add_leave_incident("3k_dlc04_emergence_global_emergence_leave_yuan_shao_incident");
	yuan_shao_faction:add_on_spawned_callback( function() out.design("Yuan Shao Army Spawned") end );
	yuan_shao_faction:add_spawn_dates(188, 192);
	yuan_shao_faction:add_spawn_condition(
		function()
			-- Only leave if He Jin is dead or has left the Empire. Most likely scenario is if he is killed by the Eunuchs.
			local he_jin = cm:query_model():character_for_template("3k_dlc04_template_historical_he_jin_metal");
			if he_jin:is_null_interface() or he_jin:is_dead() or he_jin:faction():name() ~= "3k_dlc04_faction_empress_he" then
				return true;
			end;
			return false;
		end);
	emergent_faction_manager:add_emergent_faction(yuan_shao_faction);

	-- "3k_main_faction_kong_rong"
	local kong_rong_faction = emergent_faction:new("kong_rong", "3k_main_faction_kong_rong", "3k_main_beihai_capital", true);
	kong_rong_faction:add_faction_leader("3k_main_template_historical_kong_rong_hero_water", "3k_general_water", true);
	kong_rong_faction:add_emergence_dilemma("3k_dlc04_emergence_global_emergence_spawn_kong_rong_dilemma");
	kong_rong_faction:add_leave_incident("3k_dlc04_emergence_global_emergence_leave_kong_rong_incident");
	kong_rong_faction:add_on_spawned_callback( function() out.design("Kong Rong Army Spawned") end );
	kong_rong_faction:add_spawn_dates(187, 187);
	emergent_faction_manager:add_emergent_faction(kong_rong_faction);

	-- Zhang Yan - 3k_main_faction_zhang_yan
	local zhang_yan_faction = emergent_faction:new("zhang_yan", "3k_main_faction_zhang_yan", "3k_main_yanmen_capital", false);
	zhang_yan_faction:add_faction_leader("3k_main_template_historical_zhang_yan_hero_wood", "3k_general_wood", true);
	zhang_yan_faction:add_emergence_dilemma("3k_dlc04_emergence_global_emergence_spawn_zhang_yan_dilemma");
	zhang_yan_faction:add_leave_incident("3k_dlc04_emergence_global_emergence_leave_zhang_yan_incident");
	zhang_yan_faction:add_on_spawned_callback( function() out.design("Zhang Yan Army Spawned") end );
	zhang_yan_faction:add_spawn_dates(185, 185);
	emergent_faction_manager:add_emergent_faction(zhang_yan_faction);

	-- Zheng Jiang -- 3k_main_faction_zheng_jiang
	local zheng_jiang_faction = emergent_faction:new("zheng_jiang", "3k_main_faction_zheng_jiang", "3k_main_taiyuan_capital", false);
	zheng_jiang_faction:add_faction_leader("3k_main_template_historical_lady_zheng_jiang_hero_wood", "3k_general_wood", true);
	zheng_jiang_faction:add_emergence_dilemma("3k_dlc04_emergence_global_emergence_spawn_zheng_jiang_dilemma");
	zheng_jiang_faction:add_leave_incident("3k_dlc04_emergence_global_emergence_leave_zheng_jiang_incident");
	zheng_jiang_faction:add_on_spawned_callback( function() out.design("Zheng Jiang Army Spawned") end );
	zheng_jiang_faction:add_spawn_dates(190, 190);
	emergent_faction_manager:add_emergent_faction(zheng_jiang_faction);

	-- Lu Bu -- 3k_main_faction_lu_bu
	local lu_bu_faction = emergent_faction:new("lu_bu", "3k_main_faction_lu_bu", "3k_main_yingchuan_capital", false);
	lu_bu_faction:add_faction_leader("3k_main_template_historical_lu_bu_hero_fire", "3k_general_fire", true);
	lu_bu_faction:add_emergence_dilemma("3k_dlc04_emergence_global_emergence_spawn_lu_bu_dilemma");
	lu_bu_faction:add_leave_incident("3k_dlc04_emergence_global_emergence_leave_lu_bu_incident");
	lu_bu_faction:add_on_spawned_callback( function() out.design("Lu Bu Army Spawned") end );
	lu_bu_faction:add_spawn_dates(192, 194);
	lu_bu_faction:add_spawn_condition(
		function()
			-- leave if dong zhuo died and not leader.
			local dz_char = cm:query_model():character_for_template("3k_main_template_historical_dong_zhuo_hero_fire");

			if dz_char and not dz_char:is_null_interface() then
				if dz_char:is_dead() then
					return true;
				end;
			end;

			return false;
		end);
	emergent_faction_manager:add_emergent_faction(lu_bu_faction);



	-- DLC06 Nanman Factions.
	local king_meng_huo_faction = emergent_faction:new("king_meng_huo_faction", "3k_dlc06_faction_nanman_king_meng_huo", "3k_main_jianning_capital", true);
	king_meng_huo_faction:add_faction_leader("3k_dlc06_template_historical_king_meng_huo_hero_nanman", "3k_general_nanman", true);
	king_meng_huo_faction:add_spawn_dates(190, 190);
	king_meng_huo_faction:add_on_spawned_callback( function() 
		-- Trigger a global event for the Nanman having spawned.
		for i, faction_key in ipairs( cm:get_human_factions() ) do
			cm:modify_faction(faction_key):trigger_incident("3k_dlc06_emergence_global_nanman_spawn_incident", true);
		end;

		core:trigger_event("NanmanTribesSpawned");
	end );
	emergent_faction_manager:add_emergent_faction(king_meng_huo_faction);


	local ahuinan_faction = emergent_faction:new("ahuinan_faction", "3k_dlc06_faction_nanman_ahuinan", "3k_main_jianning_resource_2", true);
	ahuinan_faction:add_faction_leader("3k_dlc06_template_historical_ahuinan_hero_nanman", "3k_general_nanman", true);
	ahuinan_faction:add_spawn_dates(190, 190);
	emergent_faction_manager:add_emergent_faction(ahuinan_faction);

	local dongtuna_faction = emergent_faction:new("dongtuna_faction", "3k_dlc06_faction_nanman_dongtuna", "3k_main_zangke_resource_2", true);
	dongtuna_faction:add_faction_leader("3k_dlc06_template_historical_dongtuna_hero_nanman", "3k_general_nanman", true);
	dongtuna_faction:add_spawn_dates(190, 190);
	emergent_faction_manager:add_emergent_faction(dongtuna_faction);

	local jiangyang_faction = emergent_faction:new("jiangyang_faction", "3k_dlc06_faction_nanman_jiangyang", "3k_main_jiangyang_resource_2", true);
	jiangyang_faction:add_faction_leader("3k_dlc06_template_generic_nanman_common_wood_01", "3k_general_nanman", false);
	jiangyang_faction:add_spawn_dates(190, 190);
	emergent_faction_manager:add_emergent_faction(jiangyang_faction);

	local jianning_faction = emergent_faction:new("jianning_faction", "3k_dlc06_faction_nanman_jianning", "3k_main_jianning_resource_1", true);
	jianning_faction:add_faction_leader("3k_dlc06_template_generic_nanman_common_metal_01__f", "3k_general_nanman", false);
	jianning_faction:add_spawn_dates(190, 190);
	emergent_faction_manager:add_emergent_faction(jianning_faction);

	local jiaozhi_faction = emergent_faction:new("jiaozhi_faction", "3k_dlc06_faction_nanman_jiaozhi", "3k_main_jiaozhi_resource_2", true);
	jiaozhi_faction:add_faction_leader("3k_dlc06_template_generic_nanman_common_water_02", "3k_general_nanman", false);
	jiaozhi_faction:add_spawn_dates(190, 190);
	emergent_faction_manager:add_emergent_faction(jiaozhi_faction);

	local jinhuansanjie_faction = emergent_faction:new("jinhuansanjie_faction", "3k_dlc06_faction_nanman_jinhuansanjie", "3k_main_fuling_capital", true);
	jinhuansanjie_faction:add_faction_leader("3k_dlc06_template_historical_jinhuansanjie_hero_nanman", "3k_general_nanman",  true);
	jinhuansanjie_faction:add_spawn_dates(190, 190);
	emergent_faction_manager:add_emergent_faction(jinhuansanjie_faction);

	local king_duosi_faction = emergent_faction:new("king_duosi_faction", "3k_dlc06_faction_nanman_king_duosi", "3k_main_zangke_capital", true);
	king_duosi_faction:add_faction_leader("3k_dlc06_template_historical_king_duosi_hero_nanman", "3k_general_nanman", true);
	king_duosi_faction:add_spawn_dates(190, 190);
	emergent_faction_manager:add_emergent_faction(king_duosi_faction);


	local king_mulu_faction = emergent_faction:new("king_mulu_faction", "3k_dlc06_faction_nanman_king_mulu", "3k_dlc06_jiaozhi_resource_3", true);
	king_mulu_faction:add_faction_leader("3k_dlc06_template_historical_king_mulu_hero_nanman", "3k_general_nanman", true);
	king_mulu_faction:add_spawn_dates(190, 190);
	emergent_faction_manager:add_emergent_faction(king_mulu_faction);

	local king_shamoke_faction = emergent_faction:new("king_shamoke_faction", "3k_dlc06_faction_nanman_king_shamoke", "3k_main_wuling_capital", true);
	king_shamoke_faction:add_faction_leader("3k_dlc06_template_historical_king_shamoke_hero_nanman", "3k_general_nanman", true);
	king_shamoke_faction:add_spawn_dates(190, 190);
	emergent_faction_manager:add_emergent_faction(king_shamoke_faction);

	local king_wutugu_faction = emergent_faction:new("king_wutugu_faction", "3k_dlc06_faction_nanman_king_wutugu", "3k_main_jiangyang_capital", true);
	king_wutugu_faction:add_faction_leader("3k_dlc06_template_historical_king_wutugu_hero_nanman", "3k_general_nanman", true);
	king_wutugu_faction:add_spawn_dates(190, 190);
	emergent_faction_manager:add_emergent_faction(king_wutugu_faction);

	local lady_zhurong_faction = emergent_faction:new("lady_zhurong_faction", "3k_dlc06_faction_nanman_lady_zhurong", "3k_dlc06_yunnan_capital", true);
	lady_zhurong_faction:add_faction_leader("3k_dlc06_template_historical_lady_zhurong_hero_nanman", "3k_general_nanman", true);
	lady_zhurong_faction:add_spawn_dates(190, 190);
	emergent_faction_manager:add_emergent_faction(lady_zhurong_faction);

	local mangyachang_faction = emergent_faction:new("mangyachang_faction", "3k_dlc06_faction_nanman_mangyachang", "3k_dlc06_yunnan_resource_2", true);
	mangyachang_faction:add_faction_leader("3k_dlc06_template_historical_mangyachang_hero_nanman", "3k_general_nanman", true);
	mangyachang_faction:add_spawn_dates(190, 190);
	emergent_faction_manager:add_emergent_faction(mangyachang_faction);

	local tu_an_faction = emergent_faction:new("tu_an_faction", "3k_dlc06_faction_nanman_tu_an", "3k_main_jiangyang_resource_3", true);
	tu_an_faction:add_faction_leader("3k_dlc06_template_historical_tu_an_hero_nanman", "3k_general_nanman", true);
	tu_an_faction:add_spawn_dates(190, 190);
	emergent_faction_manager:add_emergent_faction(tu_an_faction);

	local xi_ni_faction = emergent_faction:new("xi_ni_faction", "3k_dlc06_faction_nanman_xi_ni", "3k_main_jiangyang_resource_1", true);
	xi_ni_faction:add_faction_leader("3k_dlc06_template_historical_xi_ni_hero_nanman", "3k_general_nanman", true);
	xi_ni_faction:add_spawn_dates(190, 190);
	emergent_faction_manager:add_emergent_faction(xi_ni_faction);

	local yang_feng_faction = emergent_faction:new("yang_feng_faction", "3k_dlc06_faction_nanman_yang_feng", "3k_dlc06_yongchang_resource_1", true);
	yang_feng_faction:add_faction_leader("3k_dlc06_template_historical_yang_feng_hero_nanman", "3k_general_nanman", true);
	yang_feng_faction:add_spawn_dates(190, 190);
	emergent_faction_manager:add_emergent_faction(yang_feng_faction);

	local yongchang_faction = emergent_faction:new("yongchang_faction", "3k_dlc06_faction_nanman_yongchang", "3k_dlc06_yongchang_capital", true);
	yongchang_faction:add_faction_leader("3k_dlc06_template_generic_nanman_common_fire_02", "3k_general_nanman", false);
	yongchang_faction:add_spawn_dates(190, 190);
	emergent_faction_manager:add_emergent_faction(yongchang_faction);

	local yunnan_faction = emergent_faction:new("yunnan_faction", "3k_dlc06_faction_nanman_yunnan", "3k_dlc06_yunnan_resource_1", true);
	yunnan_faction:add_faction_leader("3k_dlc06_template_generic_nanman_common_metal_02", "3k_general_nanman", false);
	yunnan_faction:add_spawn_dates(190, 190);
	emergent_faction_manager:add_emergent_faction(yunnan_faction);

	local zangke_faction = emergent_faction:new("zangke_faction", "3k_dlc06_faction_nanman_zangke", "3k_main_zangke_resource_1", true);
	zangke_faction:add_faction_leader("3k_dlc06_template_generic_nanman_common_earth_01", "3k_general_nanman", false);
	zangke_faction:add_spawn_dates(190, 190);
	emergent_faction_manager:add_emergent_faction(zangke_faction);
end;
-- #endregion
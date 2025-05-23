--[[
*****************************************************************
SETUP
*****************************************************************
]]--


lb_faction_ceos = {};
lb_faction_ceos.faction_key = "3k_main_faction_lu_bu";
lb_faction_ceos.listener_name = "dlc05_lu_bu_faction_ceos";
lb_faction_ceos.system_id = "[401] lb_faction_ceos - ";


function lb_faction_ceos:initialise()
	output("Lu Bu faction CEO script initialised.");

	-- Different unlock criteria for human/AI factions?
	if cm:query_faction(self.faction_key):is_human() then
		cm:set_saved_value("3k_dlc05_ceo_set_lu_bu_bandits_and_rogues_scripted",3,"ceo_set_lu_bu_greatest_warrior")
		cm:set_saved_value("3k_dlc05_ceo_set_lu_bu_bruisers_and_brawlers_scripted",2,"ceo_set_lu_bu_greatest_warrior")
		cm:set_saved_value("3k_dlc05_ceo_set_lu_bu_cousins_in_arms_scripted",2,"ceo_set_lu_bu_greatest_warrior")
		cm:set_saved_value("3k_dlc05_ceo_set_lu_bu_father_figures_scripted",2,"ceo_set_lu_bu_greatest_warrior")
		cm:set_saved_value("3k_dlc05_ceo_set_lu_bu_five_elites_scripted",5,"ceo_set_lu_bu_greatest_warrior")
		cm:set_saved_value("3k_dlc05_ceo_set_lu_bu_great_strategists_scripted",5,"ceo_set_lu_bu_greatest_warrior")
		cm:set_saved_value("3k_dlc05_ceo_set_lu_bu_northern_defenders_scripted",3,"ceo_set_lu_bu_greatest_warrior")
		cm:set_saved_value("3k_dlc05_ceo_set_lu_bu_scholars_scripted",2,"ceo_set_lu_bu_greatest_warrior")
		cm:set_saved_value("3k_dlc05_ceo_set_lu_bu_setting_suns_scripted",3,"ceo_set_lu_bu_greatest_warrior")
		cm:set_saved_value("3k_dlc05_ceo_set_lu_bu_sworn_brothers_scripted",3,"ceo_set_lu_bu_greatest_warrior")
		cm:set_saved_value("3k_dlc05_ceo_set_lu_bu_three_kingdoms_scripted",3,"ceo_set_lu_bu_greatest_warrior")
		cm:set_saved_value("3k_dlc05_ceo_set_lu_bu_tiger_generals_scripted",5,"ceo_set_lu_bu_greatest_warrior")
		cm:set_saved_value("3k_dlc05_ceo_set_lu_bu_traitors_of_changan_scripted",3,"ceo_set_lu_bu_greatest_warrior")
		cm:set_saved_value("3k_dlc05_ceo_set_lu_bu_warriors_of_the_south_scripted",4,"ceo_set_lu_bu_greatest_warrior")
		cm:set_saved_value("3k_dlc05_ceo_set_lu_bu_yellow_turbans_scripted",3,"ceo_set_lu_bu_greatest_warrior")
		cm:set_saved_value("3k_dlc05_ceo_set_lu_bu_yuan_clan_scripted",2,"ceo_set_lu_bu_greatest_warrior")

		self:add_listeners();
		self:add_listeners_ceo_set();
	else
		self:print("TODO - Lu Bu is an ai faction but is using the player triggers.");
		self:add_listeners();
	end;

	--Equip the set "Father Figures"
	self:equip_ceo("3k_dlc05_ceo_factional_warrior_defeated_dong_zhuo");
	self:equip_ceo("3k_dlc05_ceo_factional_warrior_defeated_ding_yuan");
	
end;

-- system adds points to CEO Nodes, whenever a specific trigger is fired. Stops the system needing to save/load any state data.

---which character template should reward which CEO--
lb_faction_ceos.template_to_ceo = {
	["3k_main_template_historical_xiahou_dun_hero_wood"] ="3k_dlc05_ceo_factional_warrior_defeated_xiahou_dun",
	["3k_main_template_historical_xiahou_yuan_hero_fire"] = "3k_dlc05_ceo_factional_warrior_defeated_xiahou_yuan",
	["3k_main_template_historical_cao_cao_hero_earth"] = "3k_dlc05_ceo_factional_warrior_defeated_cao_cao",
	["3k_main_template_historical_yue_jin_hero_metal"] = "3k_dlc05_ceo_factional_warrior_defeated_yue_jin",
	["3k_main_template_historical_liu_bei_hero_earth"] = "3k_dlc05_ceo_factional_warrior_defeated_liu_bei",
	["3k_main_template_historical_guan_yu_hero_wood"] = "3k_dlc05_ceo_factional_warrior_defeated_guan_yu",
	["3k_main_template_historical_zhang_fei_hero_fire"] = "3k_dlc05_ceo_factional_warrior_defeated_zhang_fei",
	["3k_main_template_historical_lady_zheng_jiang_hero_wood"] = "3k_dlc05_ceo_factional_warrior_defeated_zheng_jiang",
	["3k_main_template_historical_zhang_yan_hero_wood"] = "3k_dlc05_ceo_factional_warrior_defeated_zhang_yan",
	["3k_main_template_historical_yan_baihu_hero_metal"] = "3k_dlc05_ceo_factional_warrior_defeated_yan_baihu",
	["3k_main_template_historical_zhao_yun_hero_metal"] = "3k_dlc05_ceo_factional_warrior_defeated_zhao_yun",
	["3k_main_template_historical_ma_chao_hero_fire"] = "3k_dlc05_ceo_factional_warrior_defeated_ma_chao",
	["3k_main_template_historical_huang_zhong_hero_metal"] = "3k_dlc05_ceo_factional_warrior_defeated_huang_zhong",
	["3k_main_template_historical_zhang_he_hero_fire"] = "3k_dlc05_ceo_factional_warrior_defeated_zhange_he",
	["3k_main_template_historical_yu_jin_hero_metal"] = "3k_dlc05_ceo_factional_warrior_defeated_yu_jin",
	["3k_main_template_historical_xu_huang_hero_metal"] = "3k_dlc05_ceo_factional_warrior_defeated_xu_huang",
	["3k_ytr_template_historical_huang_shao_hero_metal"] = "3k_dlc05_ceo_factional_warrior_defeated_huang_shao",
	["3k_ytr_template_historical_gong_du_hero_wood"] = "3k_dlc05_ceo_factional_warrior_defeated_gong_du",
	["3k_ytr_template_historical_he_yi_hero_water"] = "3k_dlc05_ceo_factional_warrior_defeated_he_yi",
	["3k_main_template_historical_xu_chu_hero_wood"] = "3k_dlc05_ceo_factional_warrior_defeated_xu_chu",
	["3k_main_template_historical_dian_wei_hero_wood"] = "3k_dlc05_ceo_factional_warrior_defeated_dian_wei",
	["3k_main_template_historical_gongsun_zan_hero_fire"] = "3k_dlc05_ceo_factional_warrior_defeated_gongsun_zan",
	["3k_main_template_historical_han_sui_hero_metal"] = "3k_dlc05_ceo_factional_warrior_defeated_han_sui",
	["3k_main_template_historical_ma_teng_hero_fire"] = "3k_dlc05_ceo_factional_warrior_defeated_ma_teng",
	["3k_main_template_historical_guo_jia_hero_water"] = "3k_dlc05_ceo_factional_warrior_defeated_guo_jia",
	["3k_main_template_historical_sun_quan_hero_earth"] = "3k_dlc05_ceo_factional_warrior_defeated_sun_quan",
	["3k_main_template_historical_sun_ce_hero_fire"] = "3k_dlc05_ceo_factional_warrior_defeated_sun_ce",
	["3k_main_template_historical_lady_sun_shangxiang_hero_fire"] = "3k_dlc05_ceo_factional_warrior_defeated_sun_ren",
	["3k_main_template_historical_guo_si_hero_fire"] = "3k_dlc05_ceo_factional_warrior_defeated_guo_si",
	["3k_main_template_historical_li_jue_hero_fire"] = "3k_dlc05_ceo_factional_warrior_defeated_li_jue",
	["3k_main_template_historical_jia_xu_hero_water"] = "3k_dlc05_ceo_factional_warrior_defeated_jia_xu",
	["3k_main_template_historical_sima_yi_hero_water"] = "3k_dlc05_ceo_factional_warrior_defeated_sima_yi",
	["3k_main_template_historical_zhuge_liang_hero_water"] = "3k_dlc05_ceo_factional_warrior_defeated_zhuge_liang",
	["3k_main_template_historical_zhou_yu_hero_water"] = "3k_dlc05_ceo_factional_warrior_defeated_zhou_yu",
	["3k_main_template_historical_pang_tong_hero_water"] = "3k_dlc05_ceo_factional_warrior_defeated_pang_tong",
	["3k_main_template_historical_zhou_tai_hero_fire"] = "3k_dlc05_ceo_factional_warrior_defeated_zhou_tai",
	["3k_main_template_historical_gan_ning_hero_fire"] = "3k_dlc05_ceo_factional_warrior_defeated_gan_ning",
	["3k_main_template_historical_taishi_ci_hero_metal"] = "3k_dlc05_ceo_factional_warrior_defeated_taishi_ci",
	["3k_main_template_historical_yuan_shao_hero_earth"] = "3k_dlc05_ceo_factional_warrior_defeated_yuan_shao",
	["3k_main_template_historical_yuan_shu_hero_earth"] = "3k_dlc05_ceo_factional_warrior_defeated_yuan_shu",
	["3k_main_template_historical_liu_biao_hero_earth"] = "3k_dlc05_ceo_factional_warrior_defeated_liu_biao",
	["3k_main_template_historical_kong_rong_hero_water"] = "3k_dlc05_ceo_factional_warrior_defeated_kong_rong",
	["3k_cp01_template_historical_huang_gai_hero_fire"] = "3k_dlc05_ceo_factional_warrior_defeated_huang_gai",
	["3k_main_template_historical_zhang_liao_hero_metal"]="3k_dlc05_ceo_factional_warrior_defeated_zhang_liao"
	};
--DLC05 - LU BU CEO TO INCIDENT
lb_faction_ceos.ceo_to_incident = {
	["3k_dlc05_ceo_factional_warrior_defeated_zheng_jiang"]="3k_dlc05_ceo_set_lu_bu_bandits_and_rogues_scripted",
	["3k_dlc05_ceo_factional_warrior_defeated_zhang_yan"]="3k_dlc05_ceo_set_lu_bu_bandits_and_rogues_scripted",
	["3k_dlc05_ceo_factional_warrior_defeated_yan_baihu"]="3k_dlc05_ceo_set_lu_bu_bandits_and_rogues_scripted",
	["3k_dlc05_ceo_factional_warrior_defeated_xu_chu"]="3k_dlc05_ceo_set_lu_bu_bruisers_and_brawlers_scripted",
	["3k_dlc05_ceo_factional_warrior_defeated_dian_wei"]="3k_dlc05_ceo_set_lu_bu_bruisers_and_brawlers_scripted",
	["3k_dlc05_ceo_factional_warrior_defeated_xiahou_dun"]="3k_dlc05_ceo_set_lu_bu_cousins_in_arms_scripted",
	["3k_dlc05_ceo_factional_warrior_defeated_xiahou_yuan"]="3k_dlc05_ceo_set_lu_bu_cousins_in_arms_scripted",
	["3k_dlc05_ceo_factional_warrior_defeated_dong_zhuo"]="3k_dlc05_ceo_set_lu_bu_father_figures_scripted",
	["3k_dlc05_ceo_factional_warrior_defeated_ding_yuan"]="3k_dlc05_ceo_set_lu_bu_father_figures_scripted",
	["3k_dlc05_ceo_factional_warrior_defeated_zhange_he"]="3k_dlc05_ceo_set_lu_bu_five_elites_scripted",	
	["3k_dlc05_ceo_factional_warrior_defeated_yu_jin"]="3k_dlc05_ceo_set_lu_bu_five_elites_scripted",
	["3k_dlc05_ceo_factional_warrior_defeated_yue_jin"]="3k_dlc05_ceo_set_lu_bu_five_elites_scripted",
	["3k_dlc05_ceo_factional_warrior_defeated_xu_huang"]="3k_dlc05_ceo_set_lu_bu_five_elites_scripted",
	["3k_dlc05_ceo_factional_warrior_defeated_zhang_liao"]="3k_dlc05_ceo_set_lu_bu_five_elites_scripted",
	["3k_dlc05_ceo_factional_warrior_defeated_zhuge_liang"]="3k_dlc05_ceo_set_lu_bu_great_strategists_scripted",			
	["3k_dlc05_ceo_factional_warrior_defeated_sima_yi"]="3k_dlc05_ceo_set_lu_bu_great_strategists_scripted",
	["3k_dlc05_ceo_factional_warrior_defeated_pang_tong"]="3k_dlc05_ceo_set_lu_bu_great_strategists_scripted",
	["3k_dlc05_ceo_factional_warrior_defeated_guo_jia"]="3k_dlc05_ceo_set_lu_bu_great_strategists_scripted",
	["3k_dlc05_ceo_factional_warrior_defeated_zhou_yu"]="3k_dlc05_ceo_set_lu_bu_great_strategists_scripted",					
	["3k_dlc05_ceo_factional_warrior_defeated_han_sui"]="3k_dlc05_ceo_set_lu_bu_northern_defenders_scripted",
	["3k_dlc05_ceo_factional_warrior_defeated_gongsun_zan"]="3k_dlc05_ceo_set_lu_bu_northern_defenders_scripted",
	["3k_dlc05_ceo_factional_warrior_defeated_ma_teng"]="3k_dlc05_ceo_set_lu_bu_northern_defenders_scripted",			
	["3k_dlc05_ceo_factional_warrior_defeated_liu_biao"]="3k_dlc05_ceo_set_lu_bu_scholars_scripted",
	["3k_dlc05_ceo_factional_warrior_defeated_kong_rong"]="3k_dlc05_ceo_set_lu_bu_scholars_scripted",
	["3k_dlc05_ceo_factional_warrior_defeated_sun_quan"]="3k_dlc05_ceo_set_lu_bu_setting_suns_scripted",			
	["3k_dlc05_ceo_factional_warrior_defeated_sun_ce"]="3k_dlc05_ceo_set_lu_bu_setting_suns_scripted",
	["3k_dlc05_ceo_factional_warrior_defeated_sun_ren"]="3k_dlc05_ceo_set_lu_bu_setting_suns_scripted",			
	["3k_dlc05_ceo_factional_warrior_defeated_guan_yu"]="3k_dlc05_ceo_set_lu_bu_sworn_brothers_scripted",
	["3k_dlc05_ceo_factional_warrior_defeated_zhang_fei"]="3k_dlc05_ceo_set_lu_bu_sworn_brothers_scripted",
	["3k_dlc05_ceo_factional_warrior_defeated_liu_bei"]="3k_dlc05_ceo_set_lu_bu_sworn_brothers_scripted",					
	["3k_dlc05_ceo_factional_warrior_defeated_liu_bei"]="3k_dlc05_ceo_set_lu_bu_three_kingdoms_scripted",
	["3k_dlc05_ceo_factional_warrior_defeated_sun_ce"]="3k_dlc05_ceo_set_lu_bu_three_kingdoms_scripted",
	["3k_dlc05_ceo_factional_warrior_defeated_cao_cao"]="3k_dlc05_ceo_set_lu_bu_three_kingdoms_scripted",	
	["3k_dlc05_ceo_factional_warrior_defeated_huang_zhong"]="3k_dlc05_ceo_set_lu_bu_tiger_generals_scripted",	
	["3k_dlc05_ceo_factional_warrior_defeated_zhao_yun"]="3k_dlc05_ceo_set_lu_bu_tiger_generals_scripted",				
	["3k_dlc05_ceo_factional_warrior_defeated_zhang_fei"]="3k_dlc05_ceo_set_lu_bu_tiger_generals_scripted",	
	["3k_dlc05_ceo_factional_warrior_defeated_guan_yu"]="3k_dlc05_ceo_set_lu_bu_tiger_generals_scripted",
	["3k_dlc05_ceo_factional_warrior_defeated_ma_chao"]="3k_dlc05_ceo_set_lu_bu_tiger_generals_scripted",	
	["3k_dlc05_ceo_factional_warrior_defeated_li_jue"]="3k_dlc05_ceo_set_lu_bu_traitors_of_changan_scripted",
	["3k_dlc05_ceo_factional_warrior_defeated_jia_xu"]="3k_dlc05_ceo_set_lu_bu_traitors_of_changan_scripted",	
	["3k_dlc05_ceo_factional_warrior_defeated_guo_si"]="3k_dlc05_ceo_set_lu_bu_traitors_of_changan_scripted",	
	["3k_dlc05_ceo_factional_warrior_defeated_huang_gai"]="3k_dlc05_ceo_set_lu_bu_warriors_of_the_south_scripted",
	["3k_dlc05_ceo_factional_warrior_defeated_gan_ning"]="3k_dlc05_ceo_set_lu_bu_warriors_of_the_south_scripted",
	["3k_dlc05_ceo_factional_warrior_defeated_zhou_tai"]="3k_dlc05_ceo_set_lu_bu_warriors_of_the_south_scripted",
	["3k_dlc05_ceo_factional_warrior_defeated_taishi_ci"]="3k_dlc05_ceo_set_lu_bu_warriors_of_the_south_scripted",
	["3k_dlc05_ceo_factional_warrior_defeated_he_yi"]="3k_dlc05_ceo_set_lu_bu_yellow_turbans_scripted",
	["3k_dlc05_ceo_factional_warrior_defeated_gong_du"]="3k_dlc05_ceo_set_lu_bu_yellow_turbans_scripted",
	["3k_dlc05_ceo_factional_warrior_defeated_huang_shao"]="3k_dlc05_ceo_set_lu_bu_yellow_turbans_scripted",
	["3k_dlc05_ceo_factional_warrior_defeated_yuan_shu"]="3k_dlc05_ceo_set_lu_bu_yuan_clan_scripted",
	["3k_dlc05_ceo_factional_warrior_defeated_yuan_shao"]="3k_dlc05_ceo_set_lu_bu_yuan_clan_scripted"
};

--[[
*****************************************************************
LISTENERS
*****************************************************************
]]--

-- Add the listeners for the different events.
function lb_faction_ceos:add_listeners()

  core:add_listener(
    "lu_bu_surrenders", -- Unique handle
    "WorldStartOfRoundEvent", -- Campaign Event to listen for
	function()
     -- trigger event for lu bu's surrender to cao cao and joining of liu bei
		--tracks if this is lu bus last region
		local lu_bu_last_stand = (cm:modify_faction("3k_main_faction_lu_bu"):query_faction():region_list():num_items() <= 1)
		--checks if cao cao is in lu bus last region
		local cao_cao_coming_for_you = false

		--alt trigger condition, is turn 5 or more
		local is_turn_5 = (cm:turn_number() >= 5)

		if lu_bu_last_stand then

			--gets lu bu's last remaining regions if his region count is low
			local region_list = cm:modify_faction("3k_main_faction_lu_bu"):query_faction():region_list()
			for i = 0, region_list:num_items()-1 do
				--goes through cao caos armies to find if theyre standing on lu bu lands
				for j = 0, cm:query_faction("3k_main_faction_cao_cao"):military_force_list():num_items()-1 do
					local force = cm:query_faction("3k_main_faction_cao_cao"):military_force_list():item_at(j)
					if force:has_general() then
						if force:general_character():region() == region_list:item_at(i) then
							cao_cao_coming_for_you = true
						end
					end
				end
			end
			
			--also set cao cao coming to true if we have no regions left. This is done separately to avoid passing anyone a null value
			if region_list:num_items() == 0 then
				cao_cao_coming_for_you = true
			end
		end

		--if you only have 1 region left, and either cao cao is nearby or its turn 5, trigger the event
		--also, must be at war with cao cao, and must not be anyone's vassal
		if lu_bu_last_stand and (cao_cao_coming_for_you or is_turn_5)
		and diplomacy_manager:is_at_war_with("3k_main_faction_lu_bu", "3k_main_faction_cao_cao")
		and not cm:query_faction("3k_main_faction_lu_bu"):has_specified_diplomatic_deal_with_anybody("treaty_components_vassalage")
		and not cm:saved_value_exists("3k_dlc05_has_lu_bu_join_liu_bei_dilemma_triggered", "dlc05_lu_bu") then
			return true
		end
    end,
    function() -- What to do if listener fires.
		cm:set_saved_value("3k_dlc05_has_lu_bu_join_liu_bei_dilemma_triggered", true, "dlc05_lu_bu")
		cm:modify_faction("3k_main_faction_lu_bu"):trigger_dilemma("3k_dlc05_historical_lu_bu_joins_liu_bei_dilemma", true)
		output("Lu Bu Join Liu Bei Triggered")
		core:remove_listener("lu_bu_surrenders")
    end,
    true --Is persistent
  );

  core:add_listener(
		"lu_bu_surrenders_listener", -- unique handle
		"DilemmaChoiceMadeEvent", -- trigger event
		function (context) 
			--if we chose option 1 on the first dilemma
			if context:dilemma() == "3k_dlc05_historical_lu_bu_joins_liu_bei_dilemma" and context:choice() == 0 then
				return true
			end
		end, -- criteria
		function (context) --what to do if listener fires
			--lu bu becomes liu bei vassal
			diplomacy_manager:apply_automatic_deal_between_factions("3k_main_faction_liu_bei", "3k_main_faction_lu_bu", "data_defined_situation_vassalise_recipient_forced", false);
			
			local region_list = cm:modify_faction("3k_main_faction_lu_bu"):query_faction():region_list()

			for i = 0, region_list:num_items() - 1 do
				cm:modify_region(region_list:item_at(i)):settlement_gifted_as_if_by_payload(cm:modify_faction("3k_main_faction_cao_cao"))
			end

			--triggers mission with liu bei
			core:trigger_event("3k_dlc05_lu_bu_liu_bei_mission")

			core:remove_listener("lu_bu_surrenders_listener")
		end, 
		true -- is persistent
	)

	core:add_listener(
		"lu_bu_betrays_listener", -- unique handle
		"DilemmaChoiceMadeEvent", -- trigger event
		function (context) 
			--if we chose option 1 on the first dilemma
			if (context:dilemma() == "3k_dlc05_historical_lu_bu_betrays_liu_bei_dilemma"
			or context:dilemma() == "3k_dlc05_historical_lu_bu_betrays_liu_bei_dilemma_repeated")
			and context:choice() == 0 then
				return true
			end
		end, -- criteria
		function (context) --what to do if listener fires
			cm:modify_faction("3k_main_faction_lu_bu"):remove_effect_bundle("3k_dlc05_effect_bundle_support_from_abroad")
		end, 
		true -- is persistent
	)

  core:add_listener(
    "CampaignBattleLoggedEventLuBuWins", -- Unique handle
    "CampaignBattleLoggedEvent", -- Campaign Event to listen for
    function(context)
	local log_entry = context:log_entry();
	local cached_pending_battle = pending_battle_cache:get_pending_battle_cache()
      return self:was_my_faction_leader_winner_in_battle(log_entry, cached_pending_battle)
    end,
    function(context) -- What to do if listener fires.
      local log_entry = context:log_entry();
	  self:add_ceos_for_great_warriors_on_the_losing_side(log_entry)
	  output("ADDED GREATEST WARRIORS ENTRY")
    end,
    true --Is persistent
  );

  output("LU BU FACTION CEOS LISTENERS ADDED")
end;

function lb_faction_ceos:add_listeners_ceo_set()

	core:add_listener(
		"FactionCeoNodeChangedLuBuCeoSet", -- Unique handle
		"FactionCeoNodeChanged", -- Campaign Event to listen for
		function(context)
			return (context:faction():name()==self.faction_key and context:faction():is_human() and context:ceo():max_points_in_ceo() <= context:ceo():num_points_in_ceo());
		end,
		function(context)
			local lu_bu_greatest_warrior_ceo_incident = self.ceo_to_incident[context:ceo():ceo_data_key()]
			if lu_bu_greatest_warrior_ceo_incident ~= nil then
				if(cm:saved_value_exists(lu_bu_greatest_warrior_ceo_incident, "ceo_set_lu_bu_greatest_warrior" )) then
					local lu_bu_greatest_warrior_ceo_incident_value = cm:get_saved_value(lu_bu_greatest_warrior_ceo_incident, "ceo_set_lu_bu_greatest_warrior")
					lu_bu_greatest_warrior_ceo_incident_value = lu_bu_greatest_warrior_ceo_incident_value-1
					cm:set_saved_value(lu_bu_greatest_warrior_ceo_incident,lu_bu_greatest_warrior_ceo_incident_value,"ceo_set_lu_bu_greatest_warrior")
					--Trigger when progress has been made
					cm:trigger_incident(self.faction_key, lu_bu_greatest_warrior_ceo_incident, true, true);
					--if lu_bu_greatest_warrior_ceo_incident_value == 0 then --ONLY DO ONCE
					--	cm:trigger_incident(self.faction_key, lu_bu_greatest_warrior_ceo_incident, true, true);
					--end
				end
			end
		end,
		true
	);
end;


--[[
*****************************************************************
HELPERS
*****************************************************************
]]--
function lb_faction_ceos:equip_ceo(ceo_key)
	local faction_ceo_manager = cm:modify_faction(self.faction_key):ceo_management()
	local faction_ceo_list = faction_ceo_manager:query_faction_ceo_management():all_ceos_for_category("3k_dlc05_ceo_category_factional_lu_bu")
	local faction_ceo_equipment_slot_list = faction_ceo_manager:query_faction_ceo_management():all_ceo_equipment_slots_for_category("3k_dlc05_ceo_category_factional_lu_bu")
	local ceo_script_interface = nil
	if faction_ceo_manager:query_faction_ceo_management():has_ceo_equipped(ceo_key) == false then
		for i = 0, faction_ceo_list:num_items() -1 do --- iterate through all the ceos to find the one with the correct key so we can get the script interface for that specific ceo
			ceo_script_interface = faction_ceo_list:item_at(i); 
			if ceo_script_interface:ceo_data_key() == ceo_key then 
				break
			end
		end
		for i = 0, faction_ceo_equipment_slot_list:num_items() -1 do
			local faction_ceos_category_ceo_slot= faction_ceo_equipment_slot_list:item_at(i); 
			if faction_ceos_category_ceo_slot:equipped_ceo():is_null_interface() then 
				faction_ceo_manager:equip_ceo_in_slot(faction_ceos_category_ceo_slot,ceo_script_interface);
				break
			end
		end
	end
end	



function lb_faction_ceos:was_my_faction(query_faction)
	return query_faction:name() == self.faction_key;
end;

function lb_faction_ceos:add_ceos_for_great_warriors_on_the_losing_side(log_entry)
	for i = 0, log_entry:losing_characters():num_items() - 1 do
		local character = log_entry:losing_characters():item_at(i):character():generation_template_key();
    if self.template_to_ceo[character] ~= nil then
      output(character.." found on losing side")
	  self:add_points(self.template_to_ceo[character], 1)
	  self:equip_ceo(self.template_to_ceo[character])
      end
  end;
end;

function lb_faction_ceos:was_my_faction_leader_winner_in_battle(log_entry, pending_battle)

	local lu_bu_faction_leader = cm:query_faction("3k_main_faction_lu_bu"):faction_leader()

	local was_leader_in_battle = pending_battle:was_character_in_battle(lu_bu_faction_leader)

	local was_my_faction_winner = false

	for i = 0, log_entry:winning_characters():num_items() - 1 do
		local character = log_entry:winning_characters():item_at(i):character();
		if character:faction():name() == self.faction_key then
			was_my_faction_winner = true
		end
	end;

	if was_leader_in_battle and was_my_faction_winner then
		return true
	end

	return false;
end;

function lb_faction_ceos:did_my_faction_leader_win_a_duel(log_entry)
	for i = 0, log_entry:duels():num_items() - 1 do
		local duel = log_entry:duels():item_at(i);
		if duel:has_winner() then
			local character = duel:winner();
			if character:is_faction_leader() and self:was_my_faction(character:faction()) then
				return true;
			end;
		end;
	end;

	return false;
end;

-- Attempts to add points to a CEO, returns false if it failed and true if it succeded.
function lb_faction_ceos:add_points(ceo_key, points)
	if not is_string(ceo_key) then
		script_error("lb_faction_ceos:add_points() ceo_key must be a string.");
		return false;
	end;

	if not is_number(points) then
		script_error("lb_faction_ceos:add_points() points must be a number.");
		return false;
	end;

	local modify_faction = cm:modify_faction(self.faction_key);

	if not modify_faction or modify_faction:is_null_interface() then
		script_error("lb_faction_ceos:add_points() Unable to get modify faction.");
		return false;
	end;

	local ceo_mgmt = modify_faction:ceo_management();

	-- Make sure we got a CEO interface
	if not ceo_mgmt or ceo_mgmt:is_null_interface() then
		script_error("lb_faction_ceos:add_points() No CEO Management interface.");
		return false;
	end;

	--[[ Check if it's worth trying to change points.
	if ceo_mgmt:query_faction_ceo_management():changing_points_for_ceo_data_will_have_no_impact(ceo_key) then
		script_error("lb_faction_ceos:add_points() Changing CEO [" .. ceo_key .. "] will have no effect.");
		return false;
	end;]]--
	ceo_mgmt:change_points_of_ceos(ceo_key, points);
	self:print("***LU BU CEOS*** Adding points to [" .. ceo_key .. "]");
	return true;
end;

function lb_faction_ceos:create_listener(ceo_key, points_change, event, callback)
	if not is_string(event) then
		script_error("lb_faction_ceos:create_listener() event is NOT a string.");
		return false;
	end;

	if not is_function(callback) and not is_boolean(callback) then
		script_error("lb_faction_ceos:create_listener() callback is NOT a function or a boolean.");
		return false;
	end;

	if not is_string(ceo_key) then
		script_error("lb_faction_ceos:create_listener() ceo_key is NOT a string.");
		return false;
	end;

	if not is_number(points_change) and not is_function(points_change) then
		script_error("lb_faction_ceos:create_listener() points_change is NOT a number or a function.");
		return false;
	end;

	if is_function(callback) then
		-- If our callback is a function then use this.

		core:add_listener(
			self.listener_name, -- Unique handle
			event, -- Campaign Event to listen for
			callback,
			function(context) -- What to do if listener fires.
				if is_function(points_change) then
					local value = points_change();
					self:add_points(ceo_key, value);
				else
					self:add_points(ceo_key, points_change);
				end;
			end,
			true --Is persistent
		);
	else
		-- If our callback was just a boolean use this.

		core:add_listener(
			self.listener_name, -- Unique handle
			event, -- Campaign Event to listen for
			callback,
			function(context) -- What to do if listener fires.
				if is_function(points_change) then
					local value = points_change();
					self:add_points(ceo_key, value);
				else
					self:add_points(ceo_key, points_change);
				end;
			end,
			true --Is persistent
		);
	end;
end;



-- Function to print to the console. Wrapps up functionality to there is a singular point.
function lb_faction_ceos:print(string)
	out.design(self.system_id .. string);
end;

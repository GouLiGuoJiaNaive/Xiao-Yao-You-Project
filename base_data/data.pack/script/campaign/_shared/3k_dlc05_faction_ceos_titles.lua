---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------
----- Name:			3k_dlc05_faction_ceos_titles.lua, 
----- Description: 	Three Kingdoms system to manage the character titles, which replaced wealth.
---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------

	--[[
	******************************************************************************************
											SETUP
	******************************************************************************************
	]]--

cm:add_first_tick_callback_new(function() faction_title_ceos:setup()  end)
cm:add_first_tick_callback(function() 
	faction_title_ceos:initialise()
	faction_title_ceos:remove_titles_from_all_faction_leaders() end); --Self register function

faction_title_ceos = {};
faction_title_ceos.locked_ceo_suffix = "_locked";

---dictionary of regions per CEO--
faction_title_ceos.template_to_ceo = {
	-- General who Brings Tranquility to the North
	["3k_main_yu_capital"]="3k_dlc05_ancillary_title_general_who_brings_tranquillity_to_the_north",
	["3k_main_yu_resource_1"]="3k_dlc05_ancillary_title_general_who_brings_tranquillity_to_the_north",
	["3k_main_youbeiping_capital"]="3k_dlc05_ancillary_title_general_who_brings_tranquillity_to_the_north",
	["3k_main_youbeiping_resource_1"]="3k_dlc05_ancillary_title_general_who_brings_tranquillity_to_the_north",
	["3k_main_youzhou_capital"]="3k_dlc05_ancillary_title_general_who_brings_tranquillity_to_the_north",
	["3k_main_youzhou_resource_1"]="3k_dlc05_ancillary_title_general_who_brings_tranquillity_to_the_north",
	["3k_main_daijun_capital"]="3k_dlc05_ancillary_title_general_who_brings_tranquillity_to_the_north",
	["3k_main_daijun_resource_1"]="3k_dlc05_ancillary_title_general_who_brings_tranquillity_to_the_north",
	["3k_main_zhongshan_capital"]="3k_dlc05_ancillary_title_general_who_brings_tranquillity_to_the_north",
	["3k_main_zhongshan_resource_1"]="3k_dlc05_ancillary_title_general_who_brings_tranquillity_to_the_north",
	["3k_main_yanmen_capital"]="3k_dlc05_ancillary_title_general_who_brings_tranquillity_to_the_north",
	["3k_main_yanmen_resource_1"]="3k_dlc05_ancillary_title_general_who_brings_tranquillity_to_the_north",
	["3k_main_xihe_capital"]="3k_dlc05_ancillary_title_general_who_brings_tranquillity_to_the_north",
	["3k_main_xihe_resource_1"]="3k_dlc05_ancillary_title_general_who_brings_tranquillity_to_the_north",
	["3k_main_taiyuan_capital"]="3k_dlc05_ancillary_title_general_who_brings_tranquillity_to_the_north",
	["3k_main_taiyuan_resource_1"]="3k_dlc05_ancillary_title_general_who_brings_tranquillity_to_the_north",
	["3k_main_taiyuan_resource_2"]="3k_dlc05_ancillary_title_general_who_brings_tranquillity_to_the_north",
	["3k_main_shangdang_capital"]="3k_dlc05_ancillary_title_general_who_brings_tranquillity_to_the_north",
	["3k_main_shangdang_resource_1"]="3k_dlc05_ancillary_title_general_who_brings_tranquillity_to_the_north",
	["3k_main_hedong_capital"]="3k_dlc05_ancillary_title_general_who_brings_tranquillity_to_the_north",
	["3k_main_hedong_resource_1"]="3k_dlc05_ancillary_title_general_who_brings_tranquillity_to_the_north",
	["3k_main_anping_capital"]="3k_dlc05_ancillary_title_general_who_brings_tranquillity_to_the_north",
	["3k_main_anping_resource_1"]="3k_dlc05_ancillary_title_general_who_brings_tranquillity_to_the_north",
	["3k_main_weijun_capital"]="3k_dlc05_ancillary_title_general_who_brings_tranquillity_to_the_north",
	["3k_main_weijun_resource_1"]="3k_dlc05_ancillary_title_general_who_brings_tranquillity_to_the_north",
	["3k_main_henei_capital"]="3k_dlc05_ancillary_title_general_who_brings_tranquillity_to_the_north",
	["3k_main_henei_resource_1"]="3k_dlc05_ancillary_title_general_who_brings_tranquillity_to_the_north",
	["3k_main_bohai_capital"]="3k_dlc05_ancillary_title_general_who_brings_tranquillity_to_the_north",
	["3k_main_bohai_resource_1"]="3k_dlc05_ancillary_title_general_who_brings_tranquillity_to_the_north",
	["3k_main_pingyuan_capital"]="3k_dlc05_ancillary_title_general_who_brings_tranquillity_to_the_north",
	["3k_main_pingyuan_resource_1"]="3k_dlc05_ancillary_title_general_who_brings_tranquillity_to_the_north",

	--General who pacifies the South
	["3k_main_jianye_capital"]="3k_dlc05_ancillary_title_general_who_pacifies_the_south",
	["3k_main_jianye_resource_1"]="3k_dlc05_ancillary_title_general_who_pacifies_the_south",
	["3k_main_jianye_resource_2"]="3k_dlc05_ancillary_title_general_who_pacifies_the_south",
	["3k_main_xindu_capital"]="3k_dlc05_ancillary_title_general_who_pacifies_the_south",
	["3k_main_xindu_resource_1"]="3k_dlc05_ancillary_title_general_who_pacifies_the_south",
	["3k_main_xindu_resource_2"]="3k_dlc05_ancillary_title_general_who_pacifies_the_south",
	["3k_main_poyang_capital"]="3k_dlc05_ancillary_title_general_who_pacifies_the_south",
	["3k_main_poyang_resource_1"]="3k_dlc05_ancillary_title_general_who_pacifies_the_south",
	["3k_main_poyang_resource_2"]="3k_dlc05_ancillary_title_general_who_pacifies_the_south",
	["3k_main_poyang_resource_3"]="3k_dlc05_ancillary_title_general_who_pacifies_the_south",
	["3k_main_changsha_capital"]="3k_dlc05_ancillary_title_general_who_pacifies_the_south",
	["3k_main_changsha_resource_1"]="3k_dlc05_ancillary_title_general_who_pacifies_the_south",
	["3k_main_changsha_resource_2"]="3k_dlc05_ancillary_title_general_who_pacifies_the_south",
	["3k_main_changsha_resource_3"]="3k_dlc05_ancillary_title_general_who_pacifies_the_south",
	["3k_main_badong_capital"]="3k_dlc05_ancillary_title_general_who_pacifies_the_south",
	["3k_main_badong_resource_1"]="3k_dlc05_ancillary_title_general_who_pacifies_the_south",
	["3k_main_badong_resource_2"]="3k_dlc05_ancillary_title_general_who_pacifies_the_south",
	["3k_main_fuling_capital"]="3k_dlc05_ancillary_title_general_who_pacifies_the_south",
	["3k_main_fuling_resource_1"]="3k_dlc05_ancillary_title_general_who_pacifies_the_south",
	["3k_main_jiangyang_resource_2"]="3k_dlc05_ancillary_title_general_who_pacifies_the_south",
	["3k_main_jiangyang_resource_3"]="3k_dlc05_ancillary_title_general_who_pacifies_the_south",
	["3k_main_kuaiji_capital"]="3k_dlc05_ancillary_title_general_who_pacifies_the_south",
	["3k_main_kuaiji_resource_1"]="3k_dlc05_ancillary_title_general_who_pacifies_the_south",
	["3k_main_kuaiji_resource_2"]="3k_dlc05_ancillary_title_general_who_pacifies_the_south",
	["3k_main_jianan_capital"]="3k_dlc05_ancillary_title_general_who_pacifies_the_south",
	["3k_main_jianan_resource_1"]="3k_dlc05_ancillary_title_general_who_pacifies_the_south",
	["3k_main_jianan_resource_2"]="3k_dlc05_ancillary_title_general_who_pacifies_the_south",
	["3k_main_yuzhang_capital"]="3k_dlc05_ancillary_title_general_who_pacifies_the_south",
	["3k_main_yuzhang_resource_1"]="3k_dlc05_ancillary_title_general_who_pacifies_the_south",
	["3k_main_yuzhang_resource_2"]="3k_dlc05_ancillary_title_general_who_pacifies_the_south",
	["3k_main_yuzhang_resource_3"]="3k_dlc05_ancillary_title_general_who_pacifies_the_south",
	["3k_main_luling_capital"]="3k_dlc05_ancillary_title_general_who_pacifies_the_south",
	["3k_main_luling_resource_1"]="3k_dlc05_ancillary_title_general_who_pacifies_the_south",
	["3k_main_ye_capital"]="3k_dlc05_ancillary_title_general_who_pacifies_the_south",
	["3k_main_ye_resource_1"]="3k_dlc05_ancillary_title_general_who_pacifies_the_south",
	["3k_main_dongou_capital"]="3k_dlc05_ancillary_title_general_who_pacifies_the_south",
	["3k_main_dongou_resource_1"]="3k_dlc05_ancillary_title_general_who_pacifies_the_south",
	["3k_main_tongan_capital"]="3k_dlc05_ancillary_title_general_who_pacifies_the_south",
	["3k_main_tongan_resource_1"]="3k_dlc05_ancillary_title_general_who_pacifies_the_south",
	["3k_main_nanhai_capital"]="3k_dlc05_ancillary_title_general_who_pacifies_the_south",
	["3k_main_nanhai_resource_1"]="3k_dlc05_ancillary_title_general_who_pacifies_the_south",
	["3k_main_nanhai_resource_2"]="3k_dlc05_ancillary_title_general_who_pacifies_the_south",
	["3k_main_nanhai_resource_3"]="3k_dlc05_ancillary_title_general_who_pacifies_the_south",
	["3k_main_lingling_capital"]="3k_dlc05_ancillary_title_general_who_pacifies_the_south",
	["3k_main_lingling_resource_1"]="3k_dlc05_ancillary_title_general_who_pacifies_the_south",
	["3k_main_lingling_resource_2"]="3k_dlc05_ancillary_title_general_who_pacifies_the_south",
	["3k_main_lingling_resource_3"]="3k_dlc05_ancillary_title_general_who_pacifies_the_south",
	["3k_main_wuling_capital"]="3k_dlc05_ancillary_title_general_who_pacifies_the_south",
	["3k_main_wuling_resource_1"]="3k_dlc05_ancillary_title_general_who_pacifies_the_south",
	["3k_main_wuling_resource_2"]="3k_dlc05_ancillary_title_general_who_pacifies_the_south",
	["3k_main_wuling_resource_3"]="3k_dlc05_ancillary_title_general_who_pacifies_the_south",
	["3k_main_zangke_capital"]="3k_dlc05_ancillary_title_general_who_pacifies_the_south",
	["3k_main_zangke_resource_1"]="3k_dlc05_ancillary_title_general_who_pacifies_the_south",
	["3k_main_zangke_resource_2"]="3k_dlc05_ancillary_title_general_who_pacifies_the_south",
	["3k_main_cangwu_capital"]="3k_dlc05_ancillary_title_general_who_pacifies_the_south",
	["3k_main_cangwu_resource_1"]="3k_dlc05_ancillary_title_general_who_pacifies_the_south",
	["3k_main_cangwu_resource_2"]="3k_dlc05_ancillary_title_general_who_pacifies_the_south",
	["3k_main_cangwu_resource_3"]="3k_dlc05_ancillary_title_general_who_pacifies_the_south",
	["3k_main_yulin_capital"]="3k_dlc05_ancillary_title_general_who_pacifies_the_south",
	["3k_main_yulin_resource_1"]="3k_dlc05_ancillary_title_general_who_pacifies_the_south",
	["3k_main_yulin_resource_2"]="3k_dlc05_ancillary_title_general_who_pacifies_the_south",
	["3k_main_gaoliang_capital"]="3k_dlc05_ancillary_title_general_who_pacifies_the_south",
	["3k_main_gaoliang_resource_1"]="3k_dlc05_ancillary_title_general_who_pacifies_the_south",
	["3k_main_hepu_capital"]="3k_dlc05_ancillary_title_general_who_pacifies_the_south",
	["3k_main_hepu_resource_1"]="3k_dlc05_ancillary_title_general_who_pacifies_the_south",
	["3k_main_hepu_resource_2"]="3k_dlc05_ancillary_title_general_who_pacifies_the_south",
	["3k_main_jiaozhi_capital"]="3k_dlc05_ancillary_title_general_who_pacifies_the_south",
	["3k_main_jiaozhi_resource_1"]="3k_dlc05_ancillary_title_general_who_pacifies_the_south",
	["3k_main_jiaozhi_resource_2"]="3k_dlc05_ancillary_title_general_who_pacifies_the_south",
	["3k_main_yizhou_capital"]="3k_dlc05_ancillary_title_general_who_pacifies_the_south",
	["3k_main_yizhou_island_capital"]="3k_dlc05_ancillary_title_general_who_pacifies_the_south",
	["3k_main_yizhou_island_resource_1"]="3k_dlc05_ancillary_title_general_who_pacifies_the_south",
	["3k_main_yizhou_resource_1"]="3k_dlc05_ancillary_title_general_who_pacifies_the_south",
	["3k_main_yizhou_resource_2"]="3k_dlc05_ancillary_title_general_who_pacifies_the_south",
	["3k_main_jianning_capital"]="3k_dlc05_ancillary_title_general_who_pacifies_the_south",
	["3k_main_jianning_resource_1"]="3k_dlc05_ancillary_title_general_who_pacifies_the_south",
	["3k_main_jianning_resource_2"]="3k_dlc05_ancillary_title_general_who_pacifies_the_south"
	}

-- Triggered only once on start of campaign.
function faction_title_ceos:setup()
	--As soon as the game starts, Go through all faction leaders, remove any potential title and add wealth to the character
	local faction_list = cm:query_model():world():faction_list()
	for i = 0, faction_list:num_items()-1 do 
		local faction = faction_list:item_at(i)
		if not faction:is_null_interface() then
			local faction_leader = faction:faction_leader()
			if (not faction_leader:is_null_interface() and (faction:subculture()=="3k_main_chinese" or faction:subculture()=="3k_dlc05_subculture_bandits")) then
				--Remove title
				self:remove_title_from_character(faction_leader)	

				--Add wealth
				local modify_character = cm:modify_model():get_modify_character(faction_leader)
				if not faction_leader:ceo_management():is_null_interface() then
					local wealth_ceos = faction_leader:ceo_management():all_ceos_for_category("3k_main_ceo_category_wealth")
					if not wealth_ceos:is_empty() then
						if not wealth_ceos:item_at(0):is_null_interface() then
							modify_character:ceo_management():change_points_of_ceos(wealth_ceos:item_at(0):ceo_data_key(),3)
						end
					end	
				end											
			end
		end
	end
end;

-- Removes all titles from all faction leaders in game
function faction_title_ceos:remove_titles_from_all_faction_leaders()
	local faction_list = cm:query_model():world():faction_list()
	for i = 0, faction_list:num_items()-1 do 
		local faction = faction_list:item_at(i)
		if not faction:is_null_interface() then
			local faction_leader = faction:faction_leader()
			if (not faction_leader:is_null_interface() and (faction:subculture()=="3k_main_chinese" or faction:subculture()=="3k_dlc05_subculture_bandits")) then
				--Remove title from charater
				self:remove_title_from_character(faction_leader)								
			end
		end
	end
end;

function faction_title_ceos:initialise()
	output("faction titles CEO script initialised.");
	self:add_listeners();
end;

-- Add the listeners for the different events.
function faction_title_ceos:add_listeners()	  
	output("Add ceo title listeners")
	
		--[[
	******************************************************************************************
									RULES SETUP FOR TITLES
	******************************************************************************************
	]]--

	--If character bceomes faction leader, then remove the title and add wealth to the character
	core:add_listener(
		"CharacterBecomesFactionLeaderRemoveTitle",
		"CharacterBecomesFactionLeader", 
		function(context)
			return true
		end,
		function(context)
			if not context:query_character():is_null_interface() and not context:query_character():faction():is_null_interface() then
				local subculture = context:query_character():faction():subculture()
				
				if (subculture=="3k_main_chinese" or subculture=="3k_dlc05_subculture_bandits") then
					--Remove title from charater
					self:remove_title_from_character(context:query_character())

					--Add wealth to the character
					local wealth_ceos = context:query_character():ceo_management():all_ceos_for_category("3k_main_ceo_category_wealth")
					if not wealth_ceos:is_empty() then
						if not wealth_ceos:item_at(0):is_null_interface() then
							context:modify_character():ceo_management():change_points_of_ceos(wealth_ceos:item_at(0):ceo_data_key(),3)
						end
					end
				end	
			end
		end,
		true
	);

	--Adding title gives promotion effect
	core:add_listener(
		"CharacterCeoEquippedTitleAdded",
		"CharacterCeoEquipped",
		function(context)
			if not context:ceo_equipment_slot():is_null_interface() then
				if context:ceo_equipment_slot():category_key()=="3k_dlc05_ceo_category_ancillary_titles" then
					return true
				end
			end
			return false
		end,
		function(context)
			local character = context:query_character()
			if not character:is_null_interface() then
				--If faction leader, remove their title
				if character:is_faction_leader() then
					context:modify_character():ceo_management():unequip_slot(context:ceo_equipment_slot())
				else
					--Give promotion relationship effect
					context:modify_character():add_loyalty_effect("recently_promoted")
				end
			end
		end,
		true
	);

	--Removing a title gives demotion effect
	core:add_listener(
		"CharacterCeoUnequippedTitleRemoved",
		"CharacterCeoUnequipped",
		function(context)
			if not context:ceo_equipment_slot():is_null_interface() then
				if context:ceo_equipment_slot():category_key()=="3k_dlc05_ceo_category_ancillary_titles" then
					return true
				end
			end
			return false
		end,
		function(context)
			--Give demotion relationship effect
			context:modify_character():add_loyalty_effect("recently_demoted")
		end,
		true
	);

	--Removing a title gives demotion effect
	core:add_listener(
		"CharacterCeoUnequippedTitleRemoved",
		"CharacterCeoUnequipped",
		function(context)
			if not context:ceo_equipment_slot():is_null_interface() then
				if context:ceo_equipment_slot():category_key()=="3k_dlc05_ceo_category_ancillary_titles" then
					return true
				end
			end
			return false
		end,
		function(context)
			--Give demotion relationship effect
			context:modify_character():add_loyalty_effect("recently_demoted")
		end,
		true
	);

	--[[
	******************************************************************************************
									ACHIVING TITLES
	******************************************************************************************
	]]--

	--Character Performs an settlement siege action (occupy, loot, colonize, etc.)
	core:add_listener(
    "TitleCharacterWillPerformSettlementSiegeActionEvent", -- Unique handle
    "CharacterWillPerformSettlementSiegeAction", -- Campaign Event to listen for option_integrate
	function(context)
		--Save the garrison faction of the settlement
		local was_garrison_annexed = (string.match(context:action_option_record_key(),"option_integrate"))
		cm:set_saved_value("was_garrison_annexed",was_garrison_annexed~=nil,"dlc05_titles")
		if not context:garrison_residence():is_null_interface() then
			if not context:garrison_residence():faction():is_null_interface()  then
				cm:set_saved_value("subculture_of_last_garrison_battle",context:garrison_residence():faction():subculture(),"dlc05_titles")
			else
				cm:set_saved_value("subculture_of_last_garrison_battle","","dlc05_titles")
			end
		end
		--Colonizing increases the expand the centre
		return string.match(context:action_option_record_key(),"colonise")
    end,
	function(context)
		local character = context:query_character()
		if not character:is_null_interface() then
			if not character:faction():is_null_interface() then
				self:add_points("3k_dlc05_ancillary_title_general_whom_expands_the_centre",1,character:faction():name())
			end			
		end		
	end,
	true
	)	

	--When capturing a settlement
	core:add_listener(
    "TitleGarrisonOccupiedEvent", -- Unique handle
    "GarrisonOccupiedEvent", -- Campaign Event to listen for
    function(context)
		return true
    end,
    function(context) -- What to do if listener fires.
		local character_attacker = context:query_character();	

		if not character_attacker:is_null_interface() then
			--Win 10 siege battles as the attacker. 
			if cm:saved_value_exists("was_garrison_annexed","dlc05_titles") then
				if not cm:get_saved_value("was_garrison_annexed","dlc05_titles") then
					if not character_attacker:faction():is_null_interface() then			
						-- Increase Director of Retainers Who Scales the City Wall
						self:add_points("3k_dlc05_ancillary_title_director_of_retainers_who_scales_the_city_wall",1,character_attacker:faction():name())
					end
				end
			else
				if not character_attacker:faction():is_null_interface() then			
					-- Increase Director of Retainers Who Scales the City Wall
					self:add_points("3k_dlc05_ancillary_title_director_of_retainers_who_scales_the_city_wall",1,character_attacker:faction():name())
				end
			end
			cm:set_saved_value("was_garrison_annexed",false,"dlc05_titles")			

			--Capture 20 settlements from factions that belong to Han Chinese factions.  
			if cm:saved_value_exists("subculture_of_last_garrison_battle","dlc05_titles") then
				local defending_faction_subculture = cm:get_saved_value("subculture_of_last_garrison_battle","dlc05_titles")
				if(defending_faction_subculture=="3k_main_chinese") then  
					-- Increase "Grand Design to Pacify the Han"
					self:add_points("3k_dlc05_ancillary_title_pacifier_of_the_han",1,context:garrison_residence():faction():name())
				end
			end
			
			--Occupy 15 settlements where an commanding general that has the "Honorable", "Benevolent" or "Humble" trait
			--First check if nearby aiding army or own army have registered a character with the traits, otherwise check the occupying army if it contains a character with those traits
			local found_protector_of_righteousness = false
			if not cm:saved_value_exists("General_of_Heavenly_Benevolence_in_battle","dlc05_titles") then
				if cm:get_saved_value("General_of_Heavenly_Benevolence_in_battle","dlc05_titles") then					
					found_protector_of_righteousness=true
				else
					if not character_attacker:faction():is_null_interface() then
						if character_attacker:has_military_force() then
							local character_attacker_army = character_attacker:military_force()
							for j =0,character_attacker_army:character_list():num_items()-1 do
								local character_ceos = character_attacker_army:character_list():item_at(j):ceo_management():all_ceos()
								for i = 0, character_ceos:num_items()-1 do
									local ceo_data = character_ceos:item_at(i):ceo_data_key();
									if (ceo_data=="3k_ytr_ceo_trait_personality_benevolent" or 
									ceo_data=="3k_main_ceo_trait_personality_humble" or 
									ceo_data=="3k_main_ceo_trait_personality_honourable") then 
										-- Increase "Protector of Righteousness"
										found_protector_of_righteousness=true
										break;
									end			
								end
								if found_protector_of_righteousness then 
									break 
								end
							end						
						else
							local character_ceos = character_attacker:ceo_management():all_ceos()
							for i = 0, character_ceos:num_items()-1 do
								local ceo_data = character_ceos:item_at(i):ceo_data_key();
								if (ceo_data=="3k_ytr_ceo_trait_personality_benevolent" or 
								ceo_data=="3k_main_ceo_trait_personality_humble" or 
								ceo_data=="3k_main_ceo_trait_personality_honourable") then 
									-- Increase "Protector of Righteousness"
									found_protector_of_righteousness=true
									break;
								end			
							end
						end
					end
				end
			--If saved value didn't exist
			else
				if not character_attacker:faction():is_null_interface() then
					if character_attacker:has_military_force() then
						local character_attacker_army = character_attacker:military_force()
						for j =0,character_attacker_army:character_list():num_items()-1 do
							local character_ceos = character_attacker_army:character_list():item_at(j):ceo_management():all_ceos()
							for i = 0, character_ceos:num_items()-1 do
								local ceo_data = character_ceos:item_at(i):ceo_data_key();
								if (ceo_data=="3k_ytr_ceo_trait_personality_benevolent" or 
								ceo_data=="3k_main_ceo_trait_personality_humble" or 
								ceo_data=="3k_main_ceo_trait_personality_honourable") then 
									-- Increase "Protector of Righteousness"
								found_protector_of_righteousness=true
									break;
								end
							end	
							if found_protector_of_righteousness then 
								break 
							end
						end						
					else
						local character_ceos = character_attacker:ceo_management():all_ceos()
						for i = 0, character_ceos:num_items()-1 do
							local ceo_data = character_ceos:item_at(i):ceo_data_key();
							if (ceo_data=="3k_ytr_ceo_trait_personality_benevolent" or 
							ceo_data=="3k_main_ceo_trait_personality_humble" or 
							ceo_data=="3k_main_ceo_trait_personality_honourable") then 
								-- Increase "Protector of Righteousness"
								found_protector_of_righteousness=true
								break;
							end			
						end
					end
				end
			end
			if found_protector_of_righteousness then
				self:add_points("3k_dlc05_ancillary_title_protector_of_righteousness",1,character_attacker:faction():name())
			end
			cm:set_saved_value("General_of_Heavenly_Benevolence_in_battle",false,"dlc05_titles")

			-- Check for CONQUERED 5 REGIONS NORTH OF YELLOW RIVER and CONQUERED 5 REGIONS SOUTH OF YANGTZE RIVER
			if not character_attacker:faction():is_null_interface() then
				local captured_region = context:garrison_residence():region():name()
				if self.template_to_ceo[captured_region]~=nil then
					self:add_points(self.template_to_ceo[captured_region], 1, character_attacker:faction():name())
				end
			end	
		end
    end,
    true --Is persistent
	  );

	--Battle check
	core:add_listener(
    "TitleCampaignBattleLoggedEventBattle", -- Unique handle
    "CampaignBattleLoggedEvent", -- Campaign Event to listen for
    function(context)
    --local log_entry = context:log_entry();
      return (context:query_model():pending_battle():has_been_fought())
    end,
	function(context) -- What to do if listener fires.
		local log_entry = context:log_entry()

		local pending_battle = context:query_model():pending_battle();

		--after the battle is fought, awards titles that require pre-battle conditions to be met
		self:pre_battle_check_if_character_gained_title(context:log_entry(),pending_battle:attacker_battle_result())
	  
	  --Go through all the factions that lost the battle and count the number of units they had
	  local number_of_units_on_enemy_side = 0
	  local number_of_units_on_own_side = 0
	  local number_of_misile_units = 0
	  local pending_battle_chached = pending_battle_cache:get_pending_battle_cache()
	  local attacker_units = pending_battle_chached:num_attacker_units(true)
	  local defender_units = pending_battle_chached:num_defender_units(true)
	  if string.match(pending_battle:attacker_battle_result(),"victory") then
		number_of_units_on_enemy_side = defender_units
		number_of_units_on_own_side = attacker_units
		number_of_misile_units = pending_battle_chached:num_attacker_unit_class("inf_mis")+pending_battle_chached:num_attacker_unit_class("cav_mis")+pending_battle_chached:num_attacker_unit_class("art_siege")
	  else
		number_of_units_on_enemy_side = attacker_units
		number_of_units_on_own_side = defender_units
		number_of_misile_units = pending_battle_chached:num_defender_unit_class("inf_mis")+pending_battle_chached:num_defender_unit_class("cav_mis")+pending_battle_chached:num_defender_unit_class("art_siege")
	  end

		--Go through all the factions that won the battle and do the checks
		for i = 0, log_entry:winning_factions():num_items() -1 do
			local winning_faction_check = log_entry:winning_factions():item_at(i)
			if winning_faction_check:is_null_interface() then break end --SKIP IF NULL
			local winning_faction = winning_faction_check:name()
			
			--WIN A 100 BATTLES
			self:add_points("3k_dlc05_ancillary_title_general_of_a_hundred_victories",1,winning_faction)

			if not pending_battle:is_null_interface() then
				--WON A AMBUSH BATTLE
				if pending_battle:ambush_battle() then					
					self:add_points("3k_dlc05_ancillary_title_flying_swallow_general",1,winning_faction)
				end			
				--DEFENDER WON A DESICIVE OR HEROIC BATTLE
				if(pending_battle:defender_battle_result()=="decisive_victory" or pending_battle:defender_battle_result()=="heroic_victory") then
					self:add_points("3k_dlc05_ancillary_title_iron_general",1,winning_faction)
				end
				--DEFENDER WON A SETTLEMENT BATTLE
				if pending_battle:seige_battle() then
					if pending_battle:has_contested_garrison() and not pending_battle:contested_garrison():is_null_interface() then
						local garrison = pending_battle:contested_garrison()
						--Just to be save, save the garrison factions subculture
						if not pending_battle:contested_garrison():faction():is_null_interface() then
							cm:set_saved_value("subculture_of_last_garrison_battle",pending_battle:contested_garrison():faction():subculture(),"dlc05_titles")
						end		
					end
					if (string.match(pending_battle:defender_battle_result(),"victory")) then
						self:add_points("3k_dlc05_ancillary_title_general_who_stands_his_ground",1,winning_faction)
					end
				end
				
			end
			
			--WON A DESICIVE OR HEROIC BATTLE
			if(log_entry:winner_result()=="decisive_victory" or log_entry:winner_result()=="heroic_victory") then
				self:add_points("3k_dlc05_ancillary_title_general_of_the_standard",1,winning_faction)
			end

			--Did the winning faction beat a specific subculture			
			if self:was_subculture_in_battle(log_entry:losing_factions(),"3k_dlc05_subculture_bandits") then  
				-- Increase "General Who Smashes the Caitiffs"
				self:add_points("3k_dlc05_ancillary_title_general_who_smashes_the_caitiffs",1,winning_faction)
			elseif self:was_subculture_in_battle(log_entry:losing_factions(),"3k_main_subculture_yellow_turban") then  
				-- Increase "Supports the han"
				self:add_points("3k_dlc05_ancillary_title_general_who_supports_the_han",1,winning_faction)
			end

			local number_of_units_that_participated = number_of_units_on_enemy_side+number_of_units_on_own_side
			if 35<=number_of_units_that_participated then
				self:add_points("3k_dlc05_ancillary_title_general_of_the_front",1,winning_faction)
			end
			
			--Must be higher than 0, if not the system failed
			if number_of_units_on_enemy_side ~= 0 then
				-- Check if a general has defeated rival
				local rival_characters = {};
				local rival_characters_faction_with_rivalry = {};
				--Check if there is three or more characters with the same general type on the winning side							
				local general_earth = 0
				local general_fire = 0
				local general_metal = 0
				local general_water = 0
				local general_wood = 0
				local found_three_of_three_same_type = false

				for j = 0, log_entry:winning_characters():num_items() -1 do
					local winning_character = log_entry:winning_characters():item_at(j)
					--Check character type. If there is three or more of the same type present
					if not found_three_of_three_same_type then
						if winning_character:character():character_subtype("3k_general_earth") then
							general_earth = general_earth+1
							found_three_of_three_same_type = (3<=general_earth)
						elseif winning_character:character():character_subtype("3k_general_fire") then
							general_fire = general_fire+1
							found_three_of_three_same_type = (3<=general_fire)
						elseif winning_character:character():character_subtype("3k_general_metal") then
							general_metal = general_metal+1
							found_three_of_three_same_type = (3<=general_metal)
						elseif winning_character:character():character_subtype("3k_general_water") then
							general_water = general_water+1
							found_three_of_three_same_type = (3<=general_water)
						elseif winning_character:character():character_subtype("3k_general_wood") then
							general_wood = general_wood+1
							found_three_of_three_same_type = (3<=general_wood)
						end
					end	
					
					--Check if any character has a rival
					local relationships = winning_character:character():relationships()
					for k = 0,relationships:num_items()-1 do
						if not relationships:item_at(k):is_null_interface() then
							if relationships:item_at(k):relationship_record_key()=="3k_main_relationship_negative_02" or relationships:item_at(k):relationship_record_key()=="3k_main_relationship_negative_03" then
								local characters_in_relationship = relationships:item_at(k):get_relationship_characters()
								for l = 0, characters_in_relationship:num_items()-1 do
									if characters_in_relationship:item_at(l):generation_template_key()~=winning_character:character():generation_template_key() then
										table.insert(rival_characters,characters_in_relationship:item_at(l):generation_template_key()) --Insert rival name
										table.insert(rival_characters_faction_with_rivalry,winning_character:character():faction():name())
									end												
								end
							end
						end
					end
				end

				--Check if three of the same general types were present, reward "Protector of the Three Realms"
				if found_three_of_three_same_type then
					for j = 0, log_entry:winning_factions():num_items() - 1 do 
						self:add_points("3k_dlc05_ancillary_title_guardian_of_three_mountains",1,log_entry:winning_factions():item_at(j):name())
					end
				end

				--Check if rivals were among the defeated characters							
				for j = 0, log_entry:losing_characters():num_items() -1 do
					local losing_character = log_entry:losing_characters():item_at(j)
					if not losing_character:is_null_interface() then
						for k = 0, table.getn(rival_characters) do
							local rival_character_name = rival_characters[k]
							if(losing_character:character():generation_template_key()==rival_character_name) then
								self:add_points("3k_dlc05_ancillary_title_master_of_the_hunt",1,rival_characters_faction_with_rivalry[k])
								break
							end
						end
					end			
				end

				--Enemy must have more than 8 units on their side
				if 8 <= number_of_units_on_enemy_side then
					--Win a battle where the enemy has twise as many units as you
					if math.floor((number_of_units_on_own_side/number_of_units_on_enemy_side)*100)<=50 then 
						self:add_points("3k_dlc05_ancillary_title_lord_of_thunder",1,winning_faction)
					end

					--Less than 200 men most die for the achivement to be granted
					local number_of_friendly_units_that_died = 0
					for j = 0, log_entry:losing_characters():num_items() -1 do
						local losing_character = log_entry:losing_characters():item_at(j)
						if not losing_character:is_null_interface() then
							number_of_friendly_units_that_died = number_of_friendly_units_that_died+losing_character:retinue_kills()
						else
							print("losing_character dosen't exsist")
						end			
					end
					--Enemy killed less than 200 units
					if number_of_friendly_units_that_died <= 200 then
						self:add_points("3k_dlc05_ancillary_title_earth_dragon",1,winning_faction)
					end
				end

				--Faction's army must consists of 10 or more units and number of missile troops not 0
				if 10<=number_of_units_on_own_side and number_of_misile_units ~= 0 then
					--60% or more of the army consists of missile units
					if 60<=math.floor((number_of_misile_units/number_of_units_on_own_side)*100) then 
						self:add_points("3k_dlc05_ancillary_title_general_who_calms_the_waves",1,winning_faction)
					end
				end

			else
				print("Titles failed to count number of enemies")
			end
		end		

		--Last time the "number_of_units_that_participated" is used, reset it.
		--cm:set_saved_value("number_of_units_that_participated"..context:query_model():local_faction():name(),0,"dlc05_titles")

		--Check if any characters have gained a title from the fight
		self:post_battle_check_if_character_gained_title(log_entry:winning_characters(),true)
		self:post_battle_check_if_character_gained_title(log_entry:losing_characters(),false)

		--Check if the duels have resulted in a new title
		local duels = log_entry:duels()
		local duel_winner_names = {};
		for i = 0, duels:num_items()-1 do				
			
			local duel_loser = duels:item_at(i):loser()
			if(not duel_loser:is_null_interface())then
				local loser_faction = duel_loser:faction()
				--check if the loser belongs to a yellow turban faction AND if the duel has been completed (no running away or interfering)
				if(loser_faction:subculture() == "3k_main_subculture_yellow_turban" and duels:item_at(i):outcome() == "complete")then
					self:add_points("3k_dlc05_ancillary_title_yellow_dragon",1,duels:item_at(i):winner():faction():name())
				end
			end

			local duel_winner = duels:item_at(i):winner()
			if(not duel_winner:is_null_interface()) then
				-- Check if a general has won two duels in one battle
				local duel_winner_name = duel_winner:generation_template_key()
				for j = 0, table.getn(duel_winner_names) do
					local previus_duel_winner_name = duel_winner_names[j]
					if(previus_duel_winner_name==duel_winner_name) then
						self:add_points("3k_dlc05_ancillary_title_coiled_dragon",1,duel_winner:faction():name())
					end
				end
				--output("INSERT "..duel_winner_name)
				table.insert(duel_winner_names,duel_winner_name)

				-- Check if a general with the scarred trait has won a duel
				if not duel_winner:ceo_management():is_null_interface() then
					if (duel_winner:ceo_management():has_ceo_equipped("3k_main_ceo_trait_physical_scarred")) then
						self:add_points("3k_dlc05_ancillary_title_divine_physician",5,duel_winner:faction():name())
					end
				end
			end	
		end
    end,
    true --Is persistent
	  );

	--Start of Faction turn 
	core:add_listener(
		"TitleFactionTurnStart", -- Unique handle
		"FactionTurnStart", -- Campaign Event to listen for
		function(context)
			return (not context:faction():is_dead() and not context:faction():is_rebel())
		end,
		function(context) -- What to do if listener fires.
			local faction = context:faction()

			local faction_ceo_manager_titles = faction:ceo_management():all_ceos()
			for i = 0, faction_ceo_manager_titles:num_items() -1 do
				local faction_ceo_manager_titles_ceo=faction_ceo_manager_titles:item_at(i);
				--print("faction_ceo_manager_titles_ceo "..faction_ceo_manager_titles_ceo:ceo_data_key())
			end	
			
			--Have more than 20000 in treasury
			if(20000<=faction:treasury()) then
				self:add_points("3k_dlc05_ancillary_title_divine_mathematician",1,context:faction():name())
			end	

			--Have 3000 or more in treasury project income
			if(3000<=faction:projected_net_income()) then
				self:add_points("3k_dlc05_ancillary_title_steward_of_the_changle_palace",1,context:faction():name())
			end	

			--Count the different trade deals
			local factions_with_non_aggression_deals = faction:number_of_factions_we_have_specified_diplomatic_deal_with("treaty_components_non_aggression")
			local factions_with_military_access_deals = faction:number_of_factions_we_have_specified_diplomatic_deal_with("treaty_components_military_access")
			local factions_with_trade_deals = faction:number_of_factions_we_have_specified_diplomatic_deal_with("treaty_components_trade")
			local factions_with_monopoly_deals = faction:number_of_factions_we_have_specified_diplomatic_deal_with("treaty_components_trade_monopoly")
			
			--Have 10 or more non-aggresion, military acces or trade deals in total
			if 10<=(factions_with_non_aggression_deals+factions_with_military_access_deals+factions_with_trade_deals+factions_with_monopoly_deals) then
				self:add_points("3k_dlc05_ancillary_title_master_of_writing",1,context:faction():name())
			end
			
		  end,
		  true --Is persistent
		)

	--Character health event
	core:add_listener(
		"TitleCharacterWoundHealedEvent", --Unique handle
		"CharacterWoundHealedEvent", -- trigger event
		function(context)
			return true
		end,
		function(context) -- what to do if the listener fires			
			--checks if the healed character belongs to the player faction
			if(not context:query_character():is_null_interface())then
				self:add_points("3k_dlc05_ancillary_title_divine_physician", 1, context:query_character():faction():name())
			end
		end,
		true -- Is persistent
	)

	--Check the factions tresury afterwards to see if points should be added to "gold_spotted_leopard"
	core:add_listener(
		"TitleGarrisonOccupiedEventTreasuryRecording", --Unique handle
		"GarrisonOccupiedEvent", -- trigger event
		function(context)
			return true
		end,
		function(context) -- what to do if the listener fires
			local occupying_faction = context:garrison_residence():faction()
			if cm:saved_value_exists("treasury"..occupying_faction:name(), "dlc05_titles") then
				local treasury_pre_battle = cm:get_saved_value("treasury"..occupying_faction:name(), "dlc05_titles")
				--If the value is 0 or lower, don't try to add to "gold spotted leopard"
				if 0<treasury_pre_battle then
					local difference = occupying_faction:treasury()-treasury_pre_battle
					--Don't add anything to the list if the difference isn't higher than 0
					if 0<difference then
						self:add_points("3k_dlc05_ancillary_title_gold_spotted_leopard", difference, occupying_faction:name())
					end
				end
				--Set value to be -1, so it dosen't get used accidentally.
				cm:set_saved_value("treasury"..occupying_faction:name(), -1,"dlc05_titles")
			end			
		end,
		true -- Is persistent
	)

	--Increase the saved tresury value to ensure that the correct amount of the "gold_spotted_leopard" points are added
	core:add_listener(
		"TitleCharacterCaptiveOptionApplied", --Unique handle
		"CharacterCaptiveOptionApplied", -- trigger event
		function(context)
			return true
		end,
		function(context) -- what to do if the listener fires
			local capturing_faction = context:capturing_force():faction()
			if not capturing_faction:is_null_interface() then
				if cm:saved_value_exists("treasury"..capturing_faction:name(), "dlc05_titles") then
					local treasury_pre_battle = cm:get_saved_value("treasury"..capturing_faction:name(), "dlc05_titles")
					--If the value is 0 or lower, don't save tresury
					if 0<treasury_pre_battle then
						cm:set_saved_value("treasury"..capturing_faction:name(), capturing_faction:treasury(),"dlc05_titles")
					end
				end
			end			
		end,
		true -- Is persistent
	)

	--Count the number of units and missile units before an battle starts
		core:add_listener(
		"TitlePendingBattleUnitCount", --Unique handle
		"PendingBattle", -- trigger event
		function(context)
			return true
		end,
		function(context) -- what to do if the listener fires
			local pending_battle = context:query_model():pending_battle()
			--Get groups
			local main_attacker = pending_battle:attacker()
			local secondary_attacker = pending_battle:secondary_attackers()
			local main_defender = pending_battle:defender()
			local secondary_defenders = pending_battle:secondary_defenders()
			--Count attackers
			local commander = main_attacker
			if not commander:is_null_interface() then 
				--Save tresury of the faction
				cm:set_saved_value("treasury"..commander:faction():name(), commander:faction():treasury(),"dlc05_titles")
			end
			for i = 0, secondary_attacker:num_items() -1 do
				commander = secondary_attacker:item_at(i)
				if not commander:is_null_interface() then 
					--Save tresury of the faction
					cm:set_saved_value("treasury"..commander:faction():name(), commander:faction():treasury(),"dlc05_titles")
				end
			end
			--Count defenders
			commander = main_defender
			if not commander:is_null_interface() then 
				--Save tresury of the faction
				cm:set_saved_value("treasury"..commander:faction():name(), commander:faction():treasury(),"dlc05_titles")
			end
			for i = 0, secondary_defenders:num_items() -1 do
				commander = secondary_defenders:item_at(i)
				if not commander:is_null_interface() then 
					--Save tresury of the faction
					cm:set_saved_value("treasury"..commander:faction():name(), commander:faction():treasury(),"dlc05_titles")
				end
			end
		end,
		true -- Is persistent
	)

end;

--[[
*****************************************************************
HELPERS
*****************************************************************
]]--

--Gets the number of units in a commanders retinue
function faction_title_ceos:count_the_number_of_unit_slots(commander)
	local commander_unit_list = commander:military_force():unit_list()
	local number_of_units = 0--commander_unit_list:num_items()
	for i = 0, commander_unit_list:num_items()-1 do
		if string.match(commander_unit_list:item_at(i):unit_key(),"hero_") or string.match(commander_unit_list:item_at(i):unit_key(),"general_") then
			--Hero or general. Don't do anything
		else 
			number_of_units = number_of_units+1
		end
	end
	return number_of_units
end

--Remoes the title CEO from the character
function faction_title_ceos:remove_title_from_character(character)
	--Remove title
	local modify_character = cm:modify_model():get_modify_character(character)
	-- Make sure the character actually has the ceos before unequipping them.
	if not character:ceo_management():is_null_interface() and not character:ceo_management():all_ceo_equipment_slots_for_category("3k_dlc05_ceo_category_ancillary_titles"):is_empty() then
		modify_character:ceo_management():unequip_slot(character:ceo_management():all_ceo_equipment_slots_for_category("3k_dlc05_ceo_category_ancillary_titles"):item_at(0))
	end	
end

-- Returns true if the subculture is in the faction list
function faction_title_ceos:was_subculture_in_battle(faction_list,subculture_name)
	for i = 0, faction_list:num_items() -1 do
		local faction = faction_list:item_at(i)
		if faction:subculture() == subculture_name then
			return true
		end
	end
	return false
end

 function faction_title_ceos:pre_battle_check_if_character_gained_title(log_entry,attacker_result)

	local pending_battle = pending_battle_cache:get_pending_battle_cache()

	if pending_battle == nil then
		output("Pending Battle passed from PendingBattleCache is nil!!")
	end

	if not string.match(attacker_result,"draw") then
		local did_attacker_win = string.match(attacker_result,"victory")
		if did_attacker_win then
			--gets all attacking forces in the pending post_battle_check_if_character_gained_title
			for i, force in ipairs(pending_battle.attackers) do

				local current_faction = force.faction				
				
				--for each force, grabs all retinues
				for j, retinue in ipairs(force.retinues) do
					--counts our unit types, and awards the titles appropriately
					if (retinue:num_unit_category("inf_melee") + retinue:num_unit_key("3k_main_unit_wood_azure_dragons")) >= 6 then
						self:add_points("3k_dlc05_ancillary_title_general_of_the_guards", 1, current_faction)
					end
					if retinue:num_unit_class("inf_pik") + retinue:num_unit_class("inf_spr") + retinue:num_unit_key("3k_main_unit_wood_azure_dragons") >= 6 then
						self:add_points("3k_dlc05_ancillary_title_ox_horn_general", 1, current_faction)
					end					
					if retinue:num_unit_class("cav_mis") + retinue:num_unit_class("inf_mis") >= 6 then
						self:add_points("3k_dlc05_ancillary_title_general_of_heavenly_vision", 1, current_faction)
					end
					if retinue:num_unit_category("cavalry") >= 6 then
						self:add_points("3k_dlc05_ancillary_title_general_of_chariots_and_cavalry", 1, current_faction)
					end					
				end
			end
		else
			--gets all defending forces in the pending post_battle_check_if_character_gained_title
			for i, force in ipairs(pending_battle.defenders) do

				local current_faction = force.faction
				
				--for each force, grabs all retinues
				for j, retinue in ipairs(force.retinues) do
					--counts our unit types, and awards the titles appropriately
					if (retinue:num_unit_category("inf_melee") + retinue:num_unit_key("3k_main_unit_wood_azure_dragons")) >= 6 then
						self:add_points("3k_dlc05_ancillary_title_general_of_the_guards", 1, current_faction)
					end
					if retinue:num_unit_class("inf_pik") + retinue:num_unit_class("inf_spr") + retinue:num_unit_key("3k_main_unit_wood_azure_dragons") >= 6 then
						self:add_points("3k_dlc05_ancillary_title_ox_horn_general", 1, current_faction)
					end					
					if retinue:num_unit_class("cav_mis") + retinue:num_unit_class("inf_mis") >= 6 then
						self:add_points("3k_dlc05_ancillary_title_general_of_heavenly_vision", 1, current_faction)
					end
					if retinue:num_unit_category("cavalry") >= 6 then
						self:add_points("3k_dlc05_ancillary_title_general_of_chariots_and_cavalry", 1, current_faction)
					end	
				end
			end
		end
	end		
end 

function faction_title_ceos:post_battle_check_if_character_gained_title(characters,win)	
	
	for i = 0, characters:num_items()-1 do
		local character = characters:item_at(i)
		local character_faction = character:character():faction()
		--context:query_model():pending_battle()
		--character:military_force()

		--If a genneral has killed more than 600 units in one battle
		if(600<=character:personal_kills()) then
			self:add_points("3k_dlc05_ancillary_title_blood_dragon",1,character_faction:name())
		end


		--If a superstious person was on the winning side
		if(win) then
			local superstious_character = character:character()
			if not superstious_character:is_null_interface() then
				local superstious_character_ceo_mangement = superstious_character:ceo_management()
				if not superstious_character_ceo_mangement:is_null_interface() then
					local superstious_character_ceo_mangement_ceos = superstious_character_ceo_mangement:all_ceos()
					for i = 0, superstious_character_ceo_mangement_ceos:num_items()-1 do
						local ceo_data = superstious_character_ceo_mangement_ceos:item_at(i):ceo_data_key();
						if (ceo_data=="3k_main_ceo_trait_personality_superstitious") then 
							self:add_points("3k_dlc05_ancillary_title_director_of_astronomy",1,character_faction:name())
						end
						if (ceo_data=="3k_ytr_ceo_trait_personality_benevolent" or 
							ceo_data=="3k_main_ceo_trait_personality_humble" or 
							ceo_data=="3k_main_ceo_trait_personality_honourable") then
								cm:set_saved_value("General_of_Heavenly_Benevolence_in_battle",true,"dlc05_titles")
						end
					end	
				end				
			end			
		end

	end
end

-- Attempts to add points to a CEO, returns false if it failed and true if it succeded.
function faction_title_ceos:add_points(ceo_key, points, faction_key)

	if faction_key == "rebels" then
		return false;
	end;

	if not is_string(ceo_key) then
		script_error("faction_title_ceos:add_points() ceo_key must be a string. Ceo: " .. tostring(ceo_key) .. " Points: " .. tostring(points) .." Faction: " .. tostring(faction_key));
		return false;
	end;

	if not is_number(points) then
		script_error("faction_title_ceos:add_points() points must be a number. Ceo: " .. tostring(ceo_key) .. " Points: " .. tostring(points) .." Faction: " .. tostring(faction_key));
		return false;
	end;

	local modify_faction = cm:modify_faction(faction_key);

	if not modify_faction or modify_faction:is_null_interface() then
		script_error("faction_title_ceos:add_points() Unable to get modify faction. Ceo: " .. tostring(ceo_key) .. " Points: " .. tostring(points) .." Faction: " .. tostring(faction_key));
		return false;
	end;

	local modify_ceo_mgmt = modify_faction:ceo_management();
	local query_ceo_mgmt = modify_ceo_mgmt:query_faction_ceo_management();

	-- Make sure we got a CEO interface
	if not modify_ceo_mgmt or modify_ceo_mgmt:is_null_interface() then
		script_error("faction_title_ceos:add_points() No CEO Management interface. Ceo: " .. tostring(ceo_key) .. " Points: " .. tostring(points) .." Faction: " .. tostring(faction_key));
		return false;
	end;
	
	-- if ceo dosen't exists, exit.
	if not ancillaries:faction_has_ceo_key(query_ceo_mgmt, ceo_key, "3k_dlc05_ceo_category_ancillary_titles") then
		return false;
	end;

	modify_ceo_mgmt:change_points_of_ceos(ceo_key, points);

	local ceo_interface = ancillaries:faction_get_ceo(query_ceo_mgmt, ceo_key, "3k_dlc05_ceo_category_ancillary_titles");

	--[[
	if ceo_interface:max_points_in_ceo() <= ceo_interface:num_points_in_ceo() + points then		
		--modify_ceo_mgmt:remove_ceos(ceo_interface);
		modify_ceo_mgmt:add_ceo(ceo_interface);
		modify_ceo_mgmt:change_points_of_ceos(ceo_key, ceo_interface:max_points_in_ceo());
	end;]]---
	
	return true;
end;
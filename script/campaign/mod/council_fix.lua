local issue_data_index =
{
	suggestion_key_index = 1,
	faction_index = 2,
	character_cqi_index = 3,
	post_cqi_index = 4,
	target_index = 5,
	effect_bundle_index = 6,
	effect_bundle_duration_index = 7,
	gold_cost_index = 8,
	applies_scripted_effect_index = 9,
	target_scope_index = 10,
	suggestion_icon_index = 11,
	available_to_ai_index = 12,
	incident_key_source_index = 13,
	incident_blocks_effects_source_index = 14,
	incident_key_target_index = 15,
	incident_blocks_effects_target_index = 16,
	incident_key_global_index = 17,
	use_distance_weighting_mod_index = 18;
}


--***********************************************************************************************************
--***********************************************************************************************************








--// issue_applies_scripted_effect(string)
--// If the suggestion has a scripted component we apply its effects via this function
function faction_council:issue_applies_scripted_effect(faction_key, suggestion_index, suggestion_key)
	if suggestion_index == nil or not is_number(suggestion_index) then
		script_error("ERROR: faction_council:issue_applies_scripted_effect - suggestion_index parameter is nil or not a number." );
		return;
	end
	if suggestion_key == nil then
		script_error("ERROR: faction_council:issue_applies_scripted_effect - suggestion_key parameter is nil." );
		return;
	end
	
	local suggestion_switch_table =
	{
		["issue_incomplete_ceo_set"] =  (function(faction_key, suggestion_index)
			-- adds an ancilliary to the factions ancilliary bank from a provided ancilliary data key
			local modify_faction = cm:modify_faction(faction_key);
			local ceo_key = faction_council:issue_incomplete_ceo_set(modify_faction:query_faction());
			modify_faction:ceo_management():add_ceo(ceo_key);
		end),
		["issue_few_unassigned_ancillaries"] =  (function(faction_key, suggestion_index)
			-- adds a random ancilliary to the factions ancillary bank
			local modify_faction = cm:modify_faction(faction_key);
			local ancilliaries_table =
			{
				"3k_main_ancillary_weapon_ceremonial_sword_exceptional",
				"3k_main_ancillary_weapon_composite_bow_exceptional",
				"3k_main_ancillary_weapon_halberd_exceptional",
				"3k_main_ancillary_weapon_short_ji_exceptional",
				"3k_main_ancillary_weapon_two_handed_axe_exceptional"
			};
			local item_key = ancilliaries_table[cm:random_int(1, #ancilliaries_table)];

			if item_key and is_string(item_key) then
				modify_faction:ceo_management():add_ceo(item_key);
			else
				script_error("ERROR: faction_council:issue_applies_scripted_effect() Unable to find a CEO key for issue_few_unassigned_ancillaries");
			end;
		end),
		["issue_own_character_unmarried"] =  (function(faction_key, suggestion_index)
			local target_character = cm:modify_character(cm:query_model():character_for_command_queue_index(self.current_suggestion_list[suggestion_index][issue_data_index.target_index]));
			target_character:family_member():marry_random_character();
		end),
		["issue_own_character_recruited_at_higher_rank"] =  (function(faction_key, suggestion_index)
			-- resets the assigned skill points of the provided character cqi
			local target_character = cm:modify_character(cm:query_model():character_for_command_queue_index(self.current_suggestion_list[suggestion_index][issue_data_index.target_index]));
			target_character:reset_skills();		
		end),
		["issue_no_characters_recruited_recently"] =  (function(faction_key, suggestion_index)
			-- generates a dilemma which will add a character to the factions court
			cm:modify_model():get_modify_faction(self.current_suggestion_list[suggestion_index][issue_data_index.faction_index]):trigger_dilemma("3k_dlc07_faction_council_generate_character_dilemma_scripted", true);	
		end),
		["issue_enemy_character_wounded_but_not_killed"] =  (function(faction_key, suggestion_index)
			-- kills the character of provided cqi
			cm:modify_character(self.current_suggestion_list[suggestion_index][issue_data_index.target_index]):kill_character(false)			
		end),
		["issue_enemy_faction_leader_in_foreign_territory"] =  (function(faction_key, suggestion_index)
			-- adds a map pin of the provided character cqi and makes them visible on the campaign map
			local mod_character = cm:modify_character(self.current_suggestion_list[suggestion_index][issue_data_index.target_index]);
			local mod_faction = cm:modify_faction(faction_key);
			local new_character_pin_cqi = mod_faction:get_map_pins_handler():add_character_pin(mod_character, "3k_dlc07_faction_council_pin_enemy_faction_leader", true);

			table.insert(self.faction_council_pin_data, {faction_key = mod_faction:query_faction():name(), pin_cqi = new_character_pin_cqi, expiration_turn = cm:query_model():turn_number() + self.current_suggestion_list[suggestion_index][issue_data_index.effect_bundle_duration_index]});
		end),
		["issue_own_character_has_undesirable_traits"] =  (function(faction_key, suggestion_index)
			-- first removes an undesirable character personality ceo then adds a new one to the character supplied by parameter
			local mod_character = cm:modify_character(self.current_suggestion_list[suggestion_index][issue_data_index.target_index]);
			local undesirable_character_trait_ceo_keys = -- "undesirable" character personality ceos
			{
				"3k_main_ceo_trait_personality_careless",
				"3k_main_ceo_trait_personality_cowardly",
				"3k_main_ceo_trait_personality_cruel",
				"3k_main_ceo_trait_personality_disloyal",
				"3k_main_ceo_trait_personality_greedy",
				"3k_main_ceo_trait_personality_incompetent",
				"3k_main_ceo_trait_personality_unobservant",
				"3k_main_ceo_trait_personality_vain"
			};
			local desirable_character_trait_ceo_keys = -- "desirable" character personality ceos
			{
				"3k_main_ceo_trait_personality_energetic",
				"3k_main_ceo_trait_personality_enigmatic",
				"3k_main_ceo_trait_personality_artful",
				"3k_main_ceo_trait_personality_brave",
				"3k_main_ceo_trait_personality_brilliant",
				"3k_main_ceo_trait_personality_intimidating",
				"3k_main_ceo_trait_personality_kind",
				"3k_main_ceo_trait_personality_loyal",
				"3k_main_ceo_trait_personality_resourceful",
				"3k_main_ceo_trait_personality_scholarly"
			};
			local filtered_personality_ceos_list = mod_character:query_character():ceo_management():all_ceos_for_category("3k_main_ceo_category_traits_personality");
			local filtered_undesirable_personality_ceos_list = filtered_personality_ceos_list:filter(function(filter_ceo)
				return table.contains(undesirable_character_trait_ceo_keys, filter_ceo:ceo_data_key());
			end);

			-- remove undesirable personality ceo
			mod_character:ceo_management():remove_ceo(filtered_undesirable_personality_ceos_list:item_at(0));
			filtered_personality_ceos_list = mod_character:query_character():ceo_management():all_ceos_for_category("3k_main_ceo_category_traits_personality");

			-- we want to randomise the ancillary assignement from the valid options and not duplicate personality ceos
			local new_character_ceo_keys = cm:random_sort(desirable_character_trait_ceo_keys)
			local ceo_matched = false;
			
			for n = 1, #new_character_ceo_keys do
				-- check if the current ceo already exists on the character (avoid having duplicate personality ceos)
				for i = 0, filtered_personality_ceos_list:num_items() -1 do
					if filtered_personality_ceos_list:item_at(i):ceo_data_key() == new_character_ceo_keys[n] then
						ceo_matched = true;
					end;
				end;
				-- add new ceo to the character
				if ceo_matched == false then
					mod_character:ceo_management():add_ceo(new_character_ceo_keys[n])
					return;
				end;
                ceo_matched = false;
			end;
			-- if script reaches this point no valid ceo replacement was found
			script_error("ERROR: faction_council:issue_applies_scripted_effect (".. tostring(self.current_suggestion_list[suggestion_index]) ..") - Unable to assign replacement ceo, all ceos in table(desirable_character_trait_ceo_keys) exist on character.");
			return;
		end),
		["issue_highly_developed_enemy_region_with_own_army"]  =  (function(faction_key, suggestion_index)
			-- takes a region cqi reference, gets the garrison force interface and then applies an effect bundle
			local target_region = cm:region_for_cqi(self.current_suggestion_list[suggestion_index][issue_data_index.target_index]);
			
			if not target_region or target_region:is_null_interface() then
				script_error("ERROR: faction_council:issue_applies_scripted_effect (".. tostring(self.current_suggestion_list[suggestion_index]) ..") - Supplied target_cqi parameter matches no regions.");
				return;
			end;

			if target_region:province():is_null_interface() then
				script_error("ERROR: faction_council:issue_applies_scripted_effect (".. tostring(self.current_suggestion_list[suggestion_index]) ..") - Supplied region of ".. target_region:name() .." provice returned a null interface.");
				return;
			end;

			local faction_province_list = target_region:province():faction_province_list():filter(function(filter_faction_province)
				return filter_faction_province:region_list():contains(target_region);
			end)
			local faction_province = faction_province_list:item_at(0)

			if not faction_province or faction_province:pooled_resources():is_null_interface() then
				script_error("ERROR: faction_council:issue_applies_scripted_effect (".. tostring(self.current_suggestion_list[suggestion_index]) ..") - Supplied region of ".. target_region:name() .." pooled resource manager returned a null interface.");
				return;
			end;

			if faction_province:pooled_resources():resource("3k_main_pooled_resource_supply"):is_null_interface() then
				script_error("ERROR: faction_council:issue_applies_scripted_effect (".. tostring(self.current_suggestion_list[suggestion_index]) ..") - Supplied region of ".. target_region:name() .." nas no 3k_main_pooled_resource_supply pooled resource.");
				return;
			end;

			local query_faction_province_supply_stockpile_interface = faction_province:pooled_resources():resource("3k_main_pooled_resource_supply");
			local faction_province_supply_stockpile_amount = query_faction_province_supply_stockpile_interface:value();

			cm:modify_model():get_modify_pooled_resource(query_faction_province_supply_stockpile_interface):apply_transaction_to_factor("3k_main_pooled_factor_supply_sabotage", - (faction_province_supply_stockpile_amount));
			cm:modify_faction_province(faction_province):apply_effect_bundle("3k_dlc07_effect_bundle_disable_pooled_resource_supply", self.current_suggestion_list[suggestion_index][issue_data_index.effect_bundle_duration_index]);
		end),
		["issue_enemy_region_with_highly_developed_infrastructure"] =  (function(faction_key, suggestion_index)
			-- takes a region cqi reference and then razes it
			local target_region = cm:region_for_cqi(self.current_suggestion_list[suggestion_index][issue_data_index.target_index]);

			if target_region:is_null_interface() then
				script_error("ERROR: faction_council:issue_applies_scripted_effect (".. tostring(self.current_suggestion_list[suggestion_index]) ..") - Supplied target_cqi parameter matches no regions.");
				return;
			end;

			local slots = target_region:slot_list():filter(function(slot) return slot:has_building() end);

			local num_to_damage = 1;
			if slots:num_items() >= 3 then
				num_to_damage = cm:random_int(2, slots:num_items() - 1);
			end;

			for i = 0, slots:num_items() - 1 do
				local m_slot = cm:modify_model():get_modify_slot(slots:item_at(i));
				local chance = (num_to_damage / (slots:num_items() - i)) * 100;

				if cm:roll_random_chance(chance) and m_slot:damage_building(cm:random_int(25, 90)) then
					num_to_damage = num_to_damage - 1;

					if num_to_damage < 1 then
						break;
					end;
				end;
			end;
		end),
		["issue_unused_own_trade_capacity"] =  (function(faction_key, suggestion_index)
			local faction_interface = cm:query_faction(faction_key);
			local target_faction = cm:query_model():faction_for_command_queue_index(self.current_suggestion_list[suggestion_index][issue_data_index.target_index]);

			local faction_modify_interface = cm:modify_faction(faction_key);
			faction_modify_interface:apply_effect_bundle(self.current_suggestion_list[suggestion_index][issue_data_index.effect_bundle_index], self.current_suggestion_list[suggestion_index][issue_data_index.effect_bundle_duration_index]);

			cm:modify_faction(target_faction):apply_automatic_diplomatic_deal("data_defined_situation_trade", faction_interface, "faction_key:"..target_faction:name()); 
		end),
		["issue_own_vassal_relationship_poor"] =  (function(faction_key, suggestion_index)
			-- moves the heir of the vassal faction to the vassal lord's faction and improves the relationship between the two faction leasders
			local faction_interface = cm:query_faction(faction_key);
			local target_faction = cm:query_model():faction_for_command_queue_index(self.current_suggestion_list[suggestion_index][issue_data_index.target_index]);
			local heir_post = target_faction:character_posts():filter(function(filter_post)
				return filter_post:ministerial_position_record_key() == "faction_heir";-- if the vassal faction has a relationship below the threshold value we keep them on the filtered list
			end)

			if heir_post:is_empty() then
				script_error("ERROR: faction_council:issue_applies_scripted_effect (".. tostring(self.current_suggestion_list[suggestion_index]) ..") - Heir post does not exist for this vassal faction.");
				return;
			end;

			local heir_character = heir_post:item_at(0):post_holders():item_at(0)

			if heir_character:is_null_interface() then
				script_error("ERROR: faction_council:issue_applies_scripted_effect (".. tostring(self.current_suggestion_list[suggestion_index]) ..") - Vassal has no heir to use as political hostage.");
				return;
			end;
			cm:modify_character(heir_character):move_to_faction_and_make_recruited(faction_interface:name());
			cm:modify_faction(target_faction):apply_automatic_diplomatic_deal("data_defined_situation_attitude_manipulation_hostage", faction_interface, "faction_key:"..target_faction:name()); 

			if faction_interface:is_human() then
				-- Working around basic incident functionality as we'll need 2 targets
				local incident = cm:modify_model():create_incident("3k_dlc07_faction_council_issue_own_vassal_relationship_poor_title_source_incident");
				incident:add_character_target("target_character_1", cm:query_character(self.current_suggestion_list[suggestion_index][issue_data_index.character_cqi_index]));
				incident:add_character_target("target_character_2", heir_character);
				incident:add_faction_target("target_faction_1", target_faction);
				incident:trigger(cm:modify_faction(faction_interface), true);
			end;
		end),
		["issue_non_allied_factions_control_southern_ports"] =  (function(faction_key, suggestion_index)
			-- takes a land region cqi, gets the associated spawn region + x/y coordinates then spawns an invasion army which declares war on the owner of the land region and attacks that location
			local target_region = cm:region_for_cqi(self.current_suggestion_list[suggestion_index][issue_data_index.target_index]);
			if not target_region or target_region:is_null_interface() then
				script_error("ERROR: faction_council:issue_applies_scripted_effect (".. tostring(self.current_suggestion_list[suggestion_index]) ..") - Supplied target region cqi parameter returns a null interface.");
				return;
			end;

			local spawn_regions_spawn_location_data =
			{
				["3k_dlc06_jiuzhen_capital"] = {spawn_region = "3k_dlc06_jiuzhen_capital", x_pos = 254, y_pos = 122},
				["3k_main_jiaozhi_capital"] = {spawn_region = "3k_main_jiaozhi_capital", x_pos = 271, y_pos = 138},
				["3k_main_hepu_capital"] = {spawn_region = "3k_main_hepu_capital", x_pos = 308, y_pos = 145},
				["3k_main_hepu_resource_1"] = {spawn_region = "3k_main_hepu_resource_1", x_pos = 368, y_pos = 133},
				["3k_main_hepu_resource_2"] = {spawn_region = "3k_main_hepu_resource_2", x_pos = 371, y_pos = 94},
				["3k_main_gaoliang_capital"] = {spawn_region = "3k_main_gaoliang_capital", x_pos = 432, y_pos = 148},
				["3k_main_gaoliang_resource_1"] = {spawn_region = "3k_main_gaoliang_resource_1", x_pos = 402, y_pos = 146},
			};
			if not spawn_regions_spawn_location_data[target_region:name()] then
				script_error("ERROR: faction_council:issue_applies_scripted_effect (".. tostring(self.current_suggestion_list[suggestion_index]) ..") - Supplied target region does not exist on the spawn_regions_spawn_location_data list.");
				return;
			end;

			local invasion_spawn_data = spawn_regions_spawn_location_data[target_region:name()];


				
				if faction_council:spawn_invasion_forces(target_region, invasion_spawn_data, "3k_dlc04_faction_rebels") == false then
					script_error("ERROR: faction_council:issue_applies_scripted_effect (".. tostring(self.current_suggestion_list[suggestion_index]) ..") - Failed to generate invasion force.");
					return;
				end;
		end),
		["issue_non_allied_factions_control_northern_ports"] =  (function(faction_key, suggestion_index)
			-- takes a land region cqi, gets the associated spawn region + x/y coordinates then spawns an invasion army which declares war on the owner of the land region and attacks that location
			local target_region = cm:region_for_cqi(self.current_suggestion_list[suggestion_index][issue_data_index.target_index]);
			if not target_region or target_region:is_null_interface() then
				script_error("ERROR: faction_council:issue_applies_scripted_effect (".. tostring(self.current_suggestion_list[suggestion_index]) ..") - Supplied target region cqi parameter returns a null interface.");
				return;
			end;

			local spawn_regions_spawn_location_data =
			{
				["3k_dlc06_liaodong_capital"] = {spawn_region = "3k_dlc06_liaodong_capital", x_pos = 627, y_pos = 611},
				["3k_dlc06_liaodong_resource_1"] = {spawn_region = "3k_dlc06_liaodong_resource_1", x_pos = 630, y_pos = 627},
				["3k_main_yu_capital"] = {spawn_region = "3k_main_yu_capital", x_pos = 617, y_pos = 626},
				["3k_main_youbeiping_capital"] = {spawn_region = "3k_main_youbeiping_capital", x_pos = 569, y_pos = 586},
				["3k_main_youbeiping_resource_1"] = {spawn_region = "3k_main_youbeiping_resource_1", x_pos = 597, y_pos = 606},
				["3k_main_bohai_resource_1"] = {spawn_region = "3k_main_bohai_resource_1", x_pos = 547, y_pos = 574},
				["3k_main_pingyuan_resource_1"] = {spawn_region = "3k_main_pingyuan_resource_1", x_pos = 570, y_pos = 564},
				["3k_main_taishan_resource_1"] = {spawn_region = "3k_main_taishan_resource_1", x_pos = 587, y_pos = 547},
				["3k_main_beihai_resource_1"] = {spawn_region = "3k_main_beihai_resource_1", x_pos = 592, y_pos = 540},
				["3k_main_donglai_capital"] = {spawn_region = "3k_main_donglai_capital", x_pos = 622, y_pos = 557},
				["3k_main_donglai_resource_1"] = {spawn_region = "3k_main_donglai_resource_1", x_pos = 648, y_pos = 550},
			};
			if not spawn_regions_spawn_location_data[target_region:name()] then
				script_error("ERROR: faction_council:issue_applies_scripted_effect (".. tostring(self.current_suggestion_list[suggestion_index]) ..") - Supplied target region does not exist on the spawn_regions_spawn_location_data list.");
				return;
			end;

			local invasion_spawn_data = spawn_regions_spawn_location_data[target_region:name()];


				if faction_council:spawn_invasion_forces(target_region, invasion_spawn_data, "3k_dlc04_faction_rebels") == false then
					script_error("ERROR: faction_council:issue_applies_scripted_effect (".. tostring(self.current_suggestion_list[suggestion_index]) ..") - Failed to generate invasion force.");
					return;
				end;
		end),

		["issue_non_allied_factions_control_north_west_regions"] =  (function(faction_key, suggestion_index)
			-- takes a land region cqi, gets the associated spawn region + x/y coordinates then spawns an invasion army which declares war on the owner of the land region and attacks that location
			local target_region = cm:region_for_cqi(self.current_suggestion_list[suggestion_index][issue_data_index.target_index]);
			if not target_region or target_region:is_null_interface() then
				script_error("ERROR: faction_council:issue_applies_scripted_effect (".. tostring(self.current_suggestion_list[suggestion_index]) ..") - Supplied target region cqi parameter returns a null interface.");
				return false;
			end;

			local spawn_regions_spawn_location_data =
			{
				["3k_main_wuwei_capital"] = {spawn_region = "3k_main_wuwei_capital", x_pos = 144, y_pos = 567},
				["3k_main_wuwei_resource_1"] = {spawn_region = "3k_main_wuwei_resource_1", x_pos = 178, y_pos = 582},
				["3k_main_wuwei_resource_2"] = {spawn_region = "3k_main_wuwei_resource_2", x_pos = 210, y_pos = 581},
				["3k_main_shoufang_capital"] = {spawn_region = "3k_main_shoufang_capital", x_pos = 297, y_pos = 616},
				["3k_main_shoufang_resource_2"] = {spawn_region = "3k_main_shoufang_resource_2", x_pos = 248, y_pos = 595},
			};
			if not spawn_regions_spawn_location_data[target_region:name()] then
				script_error("ERROR: faction_council:issue_applies_scripted_effect (".. tostring(self.current_suggestion_list[suggestion_index]) ..") - Supplied target region does not exist on the spawn_regions_spawn_location_data list.");
				return;
			end;
			
			local invasion_spawn_data = spawn_regions_spawn_location_data[target_region:name()];
			local can_invade, valid_x, valid_y = cm:query_faction("3k_dlc04_faction_rebels"):get_valid_spawn_location_near(invasion_spawn_data.x_pos, invasion_spawn_data.y_pos,30 ,false)
			
			
			if can_invade then
				invasion_spawn_data.x_pos = valid_x
				invasion_spawn_data.y_pos = valid_y
				
				if faction_council:spawn_invasion_forces(target_region, invasion_spawn_data, "3k_dlc04_faction_rebels") == false then
					script_error("ERROR: faction_council:issue_applies_scripted_effect (".. tostring(self.current_suggestion_list[suggestion_index]) ..") - Failed to generate invasion force.");
				end;
			end
		end)
	}

	if suggestion_switch_table[suggestion_key] then
		suggestion_switch_table[suggestion_key](faction_key, suggestion_index);
	else
		script_error("ERROR: faction_council:issue_applies_scripted_effect - suggestion_key:" .. suggestion_key.. " which does not match any valid issue key." );
		return;
	end
end;

local undesirable_character_trait_ceo_keys = { -- all han chinese character personality ceos (with the "not bad" ones commented out)
-- "3k_main_ceo_trait_personality_aescetic",
-- "3k_main_ceo_trait_personality_ambitious",
-- "3k_main_ceo_trait_personality_arrogant",
-- "3k_main_ceo_trait_personality_artful",
-- "3k_main_ceo_trait_personality_brave",
-- "3k_main_ceo_trait_personality_brilliant",
"3k_main_ceo_trait_personality_careless",
-- "3k_main_ceo_trait_personality_cautious",
-- "3k_main_ceo_trait_personality_charismatic",
-- "3k_main_ceo_trait_personality_charitable",
-- "3k_main_ceo_trait_personality_clever",
-- "3k_main_ceo_trait_personality_competative",
"3k_main_ceo_trait_personality_cowardly",
"3k_main_ceo_trait_personality_cruel",
-- "3k_main_ceo_trait_personality_cunning",
-- "3k_main_ceo_trait_personality_deceitful",
-- "3k_main_ceo_trait_personality_defiant",
-- "3k_main_ceo_trait_personality_determined",
-- "3k_main_ceo_trait_personality_direct",
-- "3k_main_ceo_trait_personality_disciplined",
"3k_main_ceo_trait_personality_disloyal",
-- "3k_main_ceo_trait_personality_distinguished",
-- "3k_main_ceo_trait_personality_dutiful",
-- "3k_main_ceo_trait_personality_elusive",
-- "3k_main_ceo_trait_personality_energetic",
-- "3k_main_ceo_trait_personality_enigmatic",
-- "3k_main_ceo_trait_personality_fiery",
-- "3k_main_ceo_trait_personality_fraternal",
"3k_main_ceo_trait_personality_greedy",
-- "3k_main_ceo_trait_personality_honourable",
-- "3k_main_ceo_trait_personality_humble",
"3k_main_ceo_trait_personality_incompetent",
-- "3k_main_ceo_trait_personality_indecisive",
-- "3k_main_ceo_trait_personality_intimidating",
-- "3k_main_ceo_trait_personality_kind",
-- "3k_main_ceo_trait_personality_loyal",
-- "3k_main_ceo_trait_personality_modest",
-- "3k_main_ceo_trait_personality_pacifist",
-- "3k_main_ceo_trait_personality_patient",
-- "3k_main_ceo_trait_personality_perceptive",
-- "3k_main_ceo_trait_personality_quiet",
-- "3k_main_ceo_trait_personality_reckless",
-- "3k_main_ceo_trait_personality_resourceful",
-- "3k_main_ceo_trait_personality_scholarly",
-- "3k_main_ceo_trait_personality_sincere",
-- "3k_main_ceo_trait_personality_solitary",
-- "3k_main_ceo_trait_personality_stubborn",
-- "3k_main_ceo_trait_personality_superstitious",
-- "3k_main_ceo_trait_personality_suspicious",
-- "3k_main_ceo_trait_personality_trusting",
"3k_main_ceo_trait_personality_unobservant",
"3k_main_ceo_trait_personality_vain",
-- "3k_main_ceo_trait_personality_vengeful"
}



local undesirable_character_trait_ceo_keys = { -- all han chinese character personality ceos (with the "not bad" ones commented out)
-- "3k_main_ceo_trait_personality_aescetic",
-- "3k_main_ceo_trait_personality_ambitious",
-- "3k_main_ceo_trait_personality_arrogant",
-- "3k_main_ceo_trait_personality_artful",
-- "3k_main_ceo_trait_personality_brave",
-- "3k_main_ceo_trait_personality_brilliant",
"3k_main_ceo_trait_personality_careless",
-- "3k_main_ceo_trait_personality_cautious",
-- "3k_main_ceo_trait_personality_charismatic",
-- "3k_main_ceo_trait_personality_charitable",
-- "3k_main_ceo_trait_personality_clever",
-- "3k_main_ceo_trait_personality_competative",
"3k_main_ceo_trait_personality_cowardly",
"3k_main_ceo_trait_personality_cruel",
-- "3k_main_ceo_trait_personality_cunning",
-- "3k_main_ceo_trait_personality_deceitful",
-- "3k_main_ceo_trait_personality_defiant",
-- "3k_main_ceo_trait_personality_determined",
-- "3k_main_ceo_trait_personality_direct",
-- "3k_main_ceo_trait_personality_disciplined",
"3k_main_ceo_trait_personality_disloyal",
-- "3k_main_ceo_trait_personality_distinguished",
-- "3k_main_ceo_trait_personality_dutiful",
-- "3k_main_ceo_trait_personality_elusive",
-- "3k_main_ceo_trait_personality_energetic",
-- "3k_main_ceo_trait_personality_enigmatic",
-- "3k_main_ceo_trait_personality_fiery",
-- "3k_main_ceo_trait_personality_fraternal",
"3k_main_ceo_trait_personality_greedy",
-- "3k_main_ceo_trait_personality_honourable",
-- "3k_main_ceo_trait_personality_humble",
"3k_main_ceo_trait_personality_incompetent",
-- "3k_main_ceo_trait_personality_indecisive",
-- "3k_main_ceo_trait_personality_intimidating",
-- "3k_main_ceo_trait_personality_kind",
-- "3k_main_ceo_trait_personality_loyal",
-- "3k_main_ceo_trait_personality_modest",
-- "3k_main_ceo_trait_personality_pacifist",
-- "3k_main_ceo_trait_personality_patient",
-- "3k_main_ceo_trait_personality_perceptive",
-- "3k_main_ceo_trait_personality_quiet",
-- "3k_main_ceo_trait_personality_reckless",
-- "3k_main_ceo_trait_personality_resourceful",
-- "3k_main_ceo_trait_personality_scholarly",
-- "3k_main_ceo_trait_personality_sincere",
-- "3k_main_ceo_trait_personality_solitary",
-- "3k_main_ceo_trait_personality_stubborn",
-- "3k_main_ceo_trait_personality_superstitious",
-- "3k_main_ceo_trait_personality_suspicious",
-- "3k_main_ceo_trait_personality_trusting",
"3k_main_ceo_trait_personality_unobservant",
"3k_main_ceo_trait_personality_vain",
-- "3k_main_ceo_trait_personality_vengeful"
}

function faction_council:issue_own_character_has_undesirable_traits(faction) -- tested 09/10/2020
	-- Look at all characters in the current faction and check their personality traits for ones which are predominantly negative, if such characters exist this issue is valid
	
	if not faction or faction:is_null_interface() then
		return nil;
	end;

	local filtered_character_list = faction:character_list():filter(function(character) -- Filtiering the force list of this faction by function predicate
		if not character:is_dead() and not misc:is_transient_character(character) then -- Only check for living characters
			if character:has_come_of_age() then -- Looking for characters who are adults (we cannot be sending infants off for spiritual soul searching!)
				local character_personality_ceos = character:ceo_management():all_ceos_for_category("3k_main_ceo_category_traits_personality")
	
				for i = 0, character_personality_ceos:num_items() -1 do
					if table.contains(undesirable_character_trait_ceo_keys, character_personality_ceos:item_at(i):ceo_data_key()) then -- checking to the character ceo keys against the undesirable_character_trait_ceo_keys for matches
						return true; -- character has one or more undesirable personality traits
					end;
				end;
				return false; -- Character is has no undesirable traits
			end;
			return false; -- character is not an adult
		end;
		return false; --character is dead
	end)

	if not filtered_character_list:is_empty() then 
		-- if we have characters who are eligible for marriage we return a random character CQI from the list
		return filtered_character_list:item_at(cm:random_int(0, filtered_character_list:num_items()-1)):command_queue_index();
	else
		return nil;
	end;	
end;

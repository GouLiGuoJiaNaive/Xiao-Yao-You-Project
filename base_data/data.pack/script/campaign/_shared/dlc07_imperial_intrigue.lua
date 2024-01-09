---------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------
----- Name:			3k_dlc07_imperial_intrigue.lua
----- Description:  This script handles the missions which require imperial favour.
---------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------

output("dlc07_imperial_intrigue.lua: Loading");

-- Don't load in campaigns which don't require it.
if cm.name == "ep_eight_princes" then
	output("3k_dlc07_imperial_intrigue.lua: Not loaded in this campaign.");
	return;
end;

-- #variables
--[[
***************************************************
***************************************************
** VARIABLES
***************************************************
***************************************************
]]--

-- Define Imperial Intrigue Manager
local debug_mode = false; -- spit out which factions have above or below the favour thresholds.
local system_id = "3k_dlc07_imperial_intrigue_manager - ";

local listener_key = "dlc07_imperial_intrigue_listener_";

local imperial_favour_pr_key = "3k_dlc07_pooled_resource_imperial_favour"
local favour_diplomacy_factor = "3k_dlc07_pooled_factor_imperial_favour_diplomacy"

local income_faction_leader_rank_req = 5; -- required rank of protectorate faction leader to trigger IF gain
local income_faction_leader_rank_pr = 2; -- IF gain rate for above
local income_eoth_treaties_minor = -0; -- IF loss for minor treaty with EotH (non aggression, trade ect) ((SET TO 0 AS CURRENTLY DISABLED))
local income_eoth_treaties_major = -0; -- IF loss for major treaty with EotH (alliance, coalition ect) ((SET TO 0 AS CURRENTLY DISABLED))
local diplomatic_standing_ignore_eoth = -50; -- diplomatic standing with protectorate at which EotH is ignored
local emperor_in_hiding = 5 -- how many turns emperor xian waits to re-appear on the campaign after being deposed
local length_of_applied_cooldown = 10 -- cooldown between a faction applying imperial favour changes to another faction
local length_of_targeted_cooldown = 8 -- cooldown between a faction being targeted by imperial favour change
local increase_imperial_favour_bundle = "3k_dlc07_effect_bundle_action_increase_imperial_favour"
local decrease_imperial_favour_bundle = "3k_dlc07_effect_bundle_action_decrease_imperial_favour"
local imperial_intrigue_start_year = 197 -- year that the system comes online (emperor's 16th birthday)

local enemy_of_the_han_data = {
	situation_negative		= "data_defined_situation_enemy_of_the_han_negative",
	situation_positive 		= "data_defined_situation_enemy_of_the_han_positive",
	indefinite 				= "data_defined_situation_enemy_of_the_han_indefinite",
	indefinite_break     	= "data_defined_situation_enemy_of_the_han_indefinite_break",
	component_key_indefinite = "dummy_treaty_components_enemy_of_the_han_indefinite",
}

local han_loyalists = {
"3k_main_faction_kong_rong",
"3k_main_faction_liu_bei",
"3k_main_faction_liu_biao",
"3k_main_faction_liu_yan",
"3k_main_faction_yuan_shao"
}


local starting_resources = { 
	["3k_dlc04_start_pos"] = {
		["3k_dlc04_faction_empress_he"] = 50,
		["3k_dlc04_faction_lu_zhi"] = 30,
		["3k_dlc04_faction_prince_liu_chong"] = 30,
		["3k_main_faction_tao_qian"] = 10,
		["3k_main_faction_cao_cao"] = -20,
		["3k_main_faction_dong_zhuo"] = 0,
		["3k_main_faction_liu_bei"] = 20,
		["3k_main_faction_liu_biao"] = 20,
		["3k_main_faction_sun_jian"] = 0,
		["3k_main_faction_ma_teng"] = -30,
		["3k_main_faction_yuan_shu"] = 0,
		["3k_main_faction_gongsun_zan"] = -10,	
		["3k_dlc04_faction_bian_zhang"] = -10,
		["3k_dlc04_faction_cao_song"] = 0,
		["3k_main_faction_han_sui"] = -30,
		["3k_dlc04_faction_liu_hong"] = 10,
		["3k_dlc04_faction_liu_xun"] = 10,
		["3k_main_faction_liu_yan"] = 10,
		["3k_main_faction_liu_yu"] = 10,
		["3k_dlc04_faction_lu_kang"] = -10,
		["3k_dlc04_faction_qiao_mao"] = -10,
		["3k_dlc04_faction_wang_rui"] = -5,
		["3k_dlc04_faction_ying_shao"] = 10,
		["3k_dlc04_faction_yuan_yi"] = 5,
	},

	["3k_main_campaign_map"] = {
		["3k_main_faction_liu_bei"] = 15,
		["3k_main_faction_gongsun_zan"] = -10,
		["3k_main_faction_yuan_shao"] = 5,
		["3k_main_faction_cao_cao"] = 0,
		["3k_main_faction_sun_jian"] = 5,
		["3k_main_faction_dong_zhuo"] = -20,
		["3k_main_faction_kong_rong"] = 0,
		["3k_main_faction_liu_biao"] = 10,
		["3k_main_faction_liu_yan"] = 10,
		["3k_main_faction_ma_teng"] = 5,
		["3k_main_faction_tao_qian"] = 5,
		["3k_main_faction_yuan_shu"] = -10,
		["3k_main_faction_shi_xie"] = -10,
		["3k_dlc04_faction_prince_liu_chong"] = 20,
		["3k_dlc05_faction_zhu_fu"] = 0,
		["3k_dlc05_faction_sheng_xian"] = 0,
		["3k_dlc05_faction_shi_huang"] = 0,
		["3k_main_faction_cai_mao"] = 0,
		["3k_main_faction_gao_gan"] = 5,
		["3k_main_faction_gongsun_du"] = -10,
		["3k_main_faction_han_fu"] = 0,
		["3k_main_faction_han_sui"] = -7,
		["3k_main_faction_huang_zu"] = 10,
		["3k_main_faction_wang_kuang"] = -5,
		["3k_main_faction_wang_lang"] = -5,
		["3k_main_faction_zhang_yang"] = 0,
	},

	["3k_dlc05_start_pos"] = {
		["3k_main_faction_cao_cao"] = -5,
		["3k_dlc05_faction_sun_ce"] = -5,
		["3k_main_faction_lu_bu"] = -10,
		["3k_main_faction_yuan_shao"] = 10,
		["3k_main_faction_yuan_shu"] = -15,
		["3k_main_faction_ma_teng"] = -5,
		["3k_main_faction_dong_zhuo"] = -30,
		["3k_main_faction_liu_biao"] = 5,
		["3k_main_faction_kong_rong"] = 5,
		["3k_main_faction_gongsun_zan"] = -10,
		["3k_main_faction_liu_bei"] = 15,
		["3k_main_faction_liu_yan"] = 5,
		["3k_main_faction_shi_xie"] = -10,
		["3k_dlc04_faction_prince_liu_chong"] = 20,
		["3k_main_faction_han_sui"] = -10,
		["3k_main_faction_han_empire"] = -10,
		["3k_main_faction_huang_zu"] = 5,
		["3k_main_faction_gongsun_du"] = -10,
		["3k_dlc05_faction_zhu_fu"] = -5,
		["3k_dlc05_faction_shi_huang"] = -2,
		["3k_dlc05_faction_yuan_tan"] = 10,
		["3k_main_faction_gao_gan"] = 10,
		["3k_main_faction_wang_lang"] = -10, 
	},

	["3k_dlc07_start_pos"] = {
		["3k_main_faction_cao_cao"] = 0,
		["3k_main_faction_yuan_shao"] = 15,
		["3k_main_faction_liu_bei"] = 20,
		["3k_dlc05_faction_sun_ce"] = 5,
		["3k_main_faction_ma_teng"] = -10,
		["3k_main_faction_liu_biao"] = 5,
		["3k_main_faction_liu_yan"] = 5,
		["3k_main_faction_shi_xie"] = -10,
		["3k_dlc05_faction_yuan_tan"] = 15,
		["3k_main_faction_huang_zu"] = 5,
		["3k_main_faction_gao_gan"] = 10,
		["3k_main_faction_han_sui"] = -5,
		["3k_main_faction_gongsun_du"] = -20,
		["3k_dlc05_faction_shi_yi"] = -10,
		["3k_dlc05_faction_shi_wu"] = -10,
		["3k_dlc07_faction_zhang_lu"] = -5,
		["3k_dlc07_faction_li_shu"] = -10,
		["3k_dlc07_faction_chen_deng"] = -10,
		["3k_dlc07_faction_zhang_meng"] = -10,
		["3k_dlc05_faction_shi_huang"] = -5,
		["3k_dlc05_faction_hua_xin"] = 0,
		["3k_dlc05_faction_xu_zhao"] = 0,
		["3k_dlc07_faction_zhang_xiu"] = -10,
		["3k_dlc07_faction_shi_hui"] = -10,
	}	
}

-- function for RNG whether an event should fire
local chance_of_no_event = 50 -- chance that no event will be chosen

-- Mission keys for the RNG function below
local high_favour_missions = {
	{"3k_dlc07_child_emperor_incident_high_favour_supply_food", 25.0},
   {"3k_dlc07_child_emperor_incident_high_favour_supply_military_aid", 25.0},
  {"3k_dlc07_child_emperor_incident_high_favour_supply_money", 25.0}, 
}

local low_favour_missions = {
	{"3k_dlc07_child_emperor_incident_low_favour_economic_sanctions", 15.0},
   {"3k_dlc07_child_emperor_incident_low_favour_military_sanctions", 15.0},
  {"3k_dlc07_child_emperor_mission_low_favour_demand_peace", 15.0}, 
 {"3k_dlc07_child_emperor_mission_low_favour_improve_favour", 50.0}, 
{"3k_dlc07_child_emperor_mission_low_favour_remove_troops", 15.0},  
}

local duty_to_the_han_missions = {
	{"3k_dlc07_child_emperor_mission_protect_faction", 0.0},
   {"3k_dlc07_child_emperor_mission_supply_food", 15.0},
  {"3k_dlc07_child_emperor_mission_supply_military_aid", 15.0}, 
 {"3k_dlc07_child_emperor_mission_supply_money", 15.0}
}

local all_child_emperor_missions = {
	"3k_dlc07_child_emperor_mission_destroy_enemy_faction",
	"3k_dlc07_child_emperor_mission_low_favour_demand_peace",
	"3k_dlc07_child_emperor_mission_low_favour_improve_favour",
	"3k_dlc07_child_emperor_mission_low_favour_remove_troops",
	"3k_dlc07_child_emperor_mission_protect_faction",
	"3k_dlc07_child_emperor_mission_supply_food",
	"3k_dlc07_child_emperor_mission_supply_military_aid",
	"3k_dlc07_child_emperor_mission_supply_money",
}
-- #endregion

-- #functions
--[[
***************************************************
***************************************************
** FUNCTIONS
***************************************************
***************************************************
]]--
-- n.b. When using 'local' functions, they must always have been defined before they are used.

-- function to print out text to the TW console (for debugging)
local function print_to_console(string, opt_debug_only)
	if opt_debug_only and not debug_mode then
		return;
	end;

	out.design(system_id .. string);
end;

local function get_protectorate_key()
	if cm:world_power_token_exists("emperor") and not cm:get_world_power_token_owner("emperor"):is_null_interface() then
		return cm:get_world_power_token_owner("emperor"):name(); -- find faction that owns the emperor
	else
		output("Imperial Intrigue: No emperor owner found when trying to provide protectorate_key.")
		return false
	end
end


local function destroy_enemy_of_the_han(mission_target_faction_key, local_faction_key)
	
	if cm:query_faction(local_faction_key):subculture() == "3k_main_chinese" and local_faction_key ~= mission_target_faction_key
	and not cm:is_mission_active_for_faction(local_faction_key, "3k_dlc07_child_emperor_mission_destroy_enemy_faction") then
		local mission = string_mission:new("3k_dlc07_child_emperor_mission_destroy_enemy_faction");

		mission:add_primary_objective("DESTROY_FACTION", {"faction " .. mission_target_faction_key});
		mission:add_primary_payload("effect_bundle{bundle_key 3k_dlc07_payload_imperial_favour_increase_large;turns 3;}")
		string_mission:set_turn_limit(25)
	
		mission:trigger_mission_for_faction(local_faction_key);
	end;
end

-- finds all Han factions and applies a diplomatic penalty towards the Enemy of the Han faction as long as the Han faction has a positive diplo relationship with the emperor owning faction.
-- apply diplomatic negative between that faction and all Han factions (unless that faction hates the faction that holds the emperor).
local function apply_enemy_of_the_han(activating_faction, target_faction_key)
	output("Imperial Intrigue: ".. tostring(activating_faction).. " has declared ".. tostring(target_faction_key).. " an Enemy of the Han"); -- output the result
	local faction_list = cm:query_model():world():faction_list()
	faction_list:foreach(function(q_faction) -- query all factions and filter them under "q_faction"
		if 	q_faction:can_do_diplomacy()
			and q_faction:subculture() == "3k_main_chinese"
			and q_faction:diplomatic_standing_with(cm:query_faction(activating_faction)) > diplomatic_standing_ignore_eoth
		then		
			-- apply automatic "enemy of the han" deal from Han faction to targeted EotH faction.
			cm:modify_faction(q_faction):apply_automatic_diplomatic_deal(enemy_of_the_han_data.situation_negative, cm:query_faction(target_faction_key), "");
			-- apply automatic "dummy" deal that tells UI when a faction is EotH.
			cm:modify_faction(q_faction):apply_automatic_diplomatic_deal(enemy_of_the_han_data.indefinite, cm:query_faction(target_faction_key), "");
		end;
	end)
	
	for i, local_faction_key in ipairs(cm:get_human_factions()) do
		destroy_enemy_of_the_han(target_faction_key, local_faction_key)
	end
end


-- finds all Han factions and applies a diplomatic penalty towards the Enemy of the Han faction as long as the Han faction has a positive diplo relationship with the emperor owning faction.
local function remove_enemy_of_the_han(target_faction_key)
	output("Imperial Intrigue: ".. tostring(target_faction_key).. "has had their status as an Enemy of the Han removed"); -- output the result
	local faction_list = cm:query_model():world():faction_list()
	faction_list:foreach(function(q_faction) -- query all factions and filter them under "q_faction"

		if 	q_faction:can_do_diplomacy()
			and q_faction:subculture() == "3k_main_chinese"
		then		
			-- apply automatic "enemy of the han" deal from Han faction to targeted EotH faction.
			cm:modify_faction(q_faction):apply_automatic_diplomatic_deal(enemy_of_the_han_data.situation_positive, cm:query_faction(target_faction_key), ""); 
			-- removes automatic "dummy" deal that tells UI when a faction is EotH.
			cm:modify_faction(target_faction_key):apply_automatic_diplomatic_deal(enemy_of_the_han_data.indefinite_break, cm:query_faction(q_faction), "");	
			
			cm:modify_faction(q_faction):cancel_custom_mission("3k_dlc07_child_emperor_mission_destroy_enemy_faction")
		end;
	end)
end	


-- function that spawns emperor xian as a character and makes him the emperor. 
local function restore_han_dynasty(target_faction_key)

	local emperor_xian_template = "3k_dlc04_template_historical_emperor_xian_earth"
	local emperor_xian_query = cm:query_model():character_for_template("3k_dlc04_template_historical_emperor_xian_earth")
	local emperor_xian_modify = nil
	
	-- Either spawn the emperor, or move him to the target faction (if he's not already there)
	if emperor_xian_query:is_null_interface() then
		emperor_xian_modify = cm:modify_faction(target_faction_key):create_character_from_template( "general", "3k_general_earth", emperor_xian_template, false);
		emperor_xian_query = emperor_xian_modify:query_character()
	else
		emperor_xian_modify = cm:modify_character(emperor_xian_query)
		if not emperor_xian_query:faction():name() == target_faction_key then
			emperor_xian_modify:move_to_faction_and_make_recruited(target_faction_key)
		end
	end
	
	-- If the emperor isn't the faction leader, make it so!
	if not emperor_xian_query:is_faction_leader() then
		emperor_xian_modify:assign_faction_leader()	
	end
	
	print_to_console("Imperial Intrigue: Spawning Han Emperor in".. target_faction_key.. "and placing as faction leader" )
	
end


--- 
local function apply_increase_imperial_favour(activating_faction_key, target_faction_key)
	output(activating_faction_key.." has targeted ".. target_faction_key.." with increase favour")
	
	local imperial_favour = cm:query_faction(target_faction_key):pooled_resources():resource(imperial_favour_pr_key);
	-- IF you change these values, you MUST update the imperial_favour_actions table... Lua execution order means you we can't just pull them out
	cm:modify_model():get_modify_pooled_resource(imperial_favour):apply_transaction_to_factor(favour_diplomacy_factor, 15);

	if cm:query_faction(target_faction_key):is_human() and activating_faction_key ~= target_faction_key then
		incident = cm:modify_model():create_incident("3k_dlc07_child_emperor_incident_political_scheme_good")
		incident:add_faction_target("target_faction_1", cm:query_faction(activating_faction_key));
		incident:trigger(cm:modify_faction(target_faction_key), true); -- triggers targeted by increase favour incident
	end

end

--- 
local function apply_decrease_imperial_favour(activating_faction_key, target_faction_key)
	output(tostring(activating_faction_key).." has targeted ".. tostring(target_faction_key).." with decrease favour")

	local imperial_favour = cm:query_faction(target_faction_key):pooled_resources():resource(imperial_favour_pr_key);
	-- IF you change these values, you MUST update the imperial_favour_actions table... Lua execution order means you we can't just pull them out
	cm:modify_model():get_modify_pooled_resource(imperial_favour):apply_transaction_to_factor(favour_diplomacy_factor, -15);

	if cm:query_faction(target_faction_key):is_human() and activating_faction_key ~= target_faction_key then
		incident = cm:modify_model():create_incident("3k_dlc07_child_emperor_incident_political_scheme_bad")
		incident:add_faction_target("target_faction_1", cm:query_faction(activating_faction_key));
		incident:trigger(cm:modify_faction(target_faction_key), true); -- triggers targeted by decrease favour incident
	end
end

local function ai_using_favour_change_event(activating_faction_key, target_faction_key, effect_bundle)
	if cm:query_faction(target_faction_key):is_human() and activating_faction_key ~= target_faction_key then
	
		if string.match(effect_bundle, "increase_imperial_favour") then
			incident = cm:modify_model():create_incident("3k_dlc07_child_emperor_incident_political_scheme_good")
			incident:add_faction_target("target_faction_1", cm:query_faction(activating_faction_key));
			incident:trigger(cm:modify_faction(target_faction_key), true); -- triggers targeted by increase favour incident
		end

		if string.match(effect_bundle, "decrease_imperial_favour") then
			incident = cm:modify_model():create_incident("3k_dlc07_child_emperor_incident_political_scheme_bad")
			incident:add_faction_target("target_faction_1", cm:query_faction(activating_faction_key));
			incident:trigger(cm:modify_faction(target_faction_key), true); -- triggers targeted by decrease favour incident
		end
	end
end

-- has to go under the actions so the functions exist and can be referenced
local imperial_favour_actions = {
	["enemy_of_the_han"] = { 
		title = "3k_dlc07_enemy_of_the_han_activation",
		icon_path = "3k_dlc07_imperial_intrigue_enemy_of_the_han.png",
		icon_background = "3k_dlc07_imperial_intrigue_enemy_of_the_han_back.png",
		favour_cost = 25,
		target_max_favour = 50,
		current_cooldown = {},
		cooldown = 10,
		effect_text = "3k_dlc07_imperial_action_enmy_of_the_han_effect_label",
		requires_world_power_token = "emperor",
		description = "3k_dlc07_Imperial_Intrigue_action_enemy_of_the_han_description",
		can_be_applied_to_self = false,
		func = apply_enemy_of_the_han, 
		can_be_applied_to_enemy_of_han = false,
	},
	["increase_favour"] = { 
		title = "3k_dlc07_imperial_action_favour_increase",
		icon_path = "3k_dlc07_imperial_intrigue_increase_favour.png",
		icon_background = "3k_dlc07_imperial_intrigue_increase_favour_back.png",
		favour_cost = 5,
		target_max_favour = 100,
		current_cooldown = {},
		cooldown = 5,
		effect_amount = 15,
		description = "3k_dlc07_Imperial_Intrigue_action_increase_favour_description",
		can_be_applied_to_self = true,
		func = apply_increase_imperial_favour, 
		can_be_applied_to_enemy_of_han = true,
	},
	["decrease_favour"] = { 
		title = "3k_dlc07_imperial_action_favour_decrease",
		icon_path = "3k_dlc07_imperial_intrigue_decrease_favour.png",
		icon_background = "3k_dlc07_imperial_intrigue_decrease_favour_back.png",
		favour_cost = 10,
		target_max_favour = 100,
		current_cooldown = {},
		cooldown = 5,
		effect_amount = -15,
		description = "3k_dlc07_Imperial_Intrigue_action_decrease_favour_description",
		can_be_applied_to_self = true,
		func = apply_decrease_imperial_favour, 
		can_be_applied_to_enemy_of_han = true,
	},
}

local function fire_event(faction_key, weighted_mission_list)
-- roll a value out of 100
	if cm:roll_random_chance(chance_of_no_event) then
		return;
	end

	-- Do a weighted random.
	--sum mission key weights.
	local sum_weight = 0; 
	
	for i, mission_data in ipairs(weighted_mission_list) do
    	sum_weight = sum_weight + mission_data[2];
	end
	
	-- generate a number which we will count down from
    local seek_value = cm:random_int(1, sum_weight);

    for i, mission_data in ipairs(weighted_mission_list) do
		-- subtract our weight from the seek_Value
    	seek_value = seek_value - mission_data[2];

		-- If we've hit 0 this is the mission we'll fire
		if seek_value <= 0 then
			if string.match(mission_data[1], "3k_dlc07_child_emperor_mission_")then
		
				--if we get the low favour mission, trigger it manually since the db version didn't give us the right targets
				if(string.match(mission_data[1], "3k_dlc07_child_emperor_mission_low_favour_remove_troops")) then

					local can_generate = false

					--finds our forces that are standing on enemy territory
					local filtered_force_list = cm:query_faction(faction_key):military_force_list():filter(
						function(force)
							local region_owner_faction = force:region():owning_faction()
							return not force:is_armed_citizenry()
							 and force:has_general()
							 and not misc:is_transient_character(force:general_character())
							 and diplomacy_manager:is_at_war_with(faction_key, region_owner_faction:name())
						end
					)

					local target_player_region
					local target_player_character

					--from our list of forces, finds one that is a max 2 regions away from a player region. Will always prioritise
					filtered_force_list:foreach(
						function(force)
							force:region():adjacent_region_list():foreach(
								function(first_degree_region)

									--if the adjacent region in question is owned by the player, return it
									if first_degree_region:owning_faction():name() == faction_key then
										target_player_region = first_degree_region
										target_player_character = force:general_character()
										return;
									end

									--if the adjacent region in question isnt owned by the player, check its adjacent regions (one more step out)
									--and see if one of those is owned by the player. if so, return it
									first_degree_region:adjacent_region_list():foreach(
										function(second_degree_region)
											if second_degree_region:owning_faction():name() == faction_key then
												target_player_region = second_degree_region;
												target_player_character = force:general_character()
												return;
											end
										end
									)
								end
							)
						end
					)

					if target_player_region and target_player_character and not cm:query_faction(faction_key):is_mission_active("3k_dlc07_child_emperor_mission_low_favour_remove_troops") then

						local mission = string_mission:new("3k_dlc07_child_emperor_mission_low_favour_remove_troops")
						mission:add_primary_objective("MOVE_TO_REGION", {"start_pos_character "..target_player_character:startpos_key()..";region "..target_player_region:name()})
						mission:add_primary_payload("effect_bundle{bundle_key 3k_dlc07_payload_imperial_favour_increase_small;turns 2;}")
						mission:set_turn_limit(5)

						can_generate = mission:trigger_mission_for_faction(faction_key)
					end

				elseif cm:trigger_mission(faction_key, mission_data[1], true) then
					return;
				end
			end

			--same here, but for the incidents
			if string.match(mission_data[1], "3k_dlc07_child_emperor_incident_")then
				if cm:trigger_incident(faction_key, mission_data[1], true) then
					return;
				end
			end
		end
    end
end


-- looks to see when faction last targeted another faction with increase or decrease IF action
local function get_turn_last_applied_cooldown(faction_key)
	local last_applied_cooldowns = nil;
	if cm:saved_value_exists("last_applied_cooldowns", "imperial_intrigue") then
		last_applied_cooldowns = cm:get_saved_value("last_applied_cooldowns", "imperial_intrigue");
	else
		return 0;
	end;

	for i, v in ipairs(last_applied_cooldowns) do
		if v[1] == faction_key then
			return v[2]
		end;
	end;

	return 0;
end;

-- begins cooldown when faction targets another faction with increase or decrease IF action
local function set_turn_last_applied_cooldown(faction_key, turn_number)
	local last_applied_cooldowns = {};
	if cm:saved_value_exists("last_applied_cooldowns", "imperial_intrigue") then
		last_applied_cooldowns = cm:get_saved_value("last_applied_cooldowns", "imperial_intrigue");
	end;

	for i, v in ipairs(last_applied_cooldowns) do
		if v[1] == faction_key then
			v[2] = turn_number;
			cm:set_saved_value("last_applied_cooldowns", last_applied_cooldowns, "imperial_intrigue");
			return;
		end;
	end;

	table.insert(last_applied_cooldowns, {faction_key, turn_number});
	cm:set_saved_value("last_applied_cooldowns", last_applied_cooldowns, "imperial_intrigue");
end;

-- looks to see when faction last targeted by another faction with increase or decrease IF action
local function get_turn_last_targeted_cooldown(faction_key)
	local last_targeted_cooldowns = nil;
	if cm:saved_value_exists("last_targeted_cooldowns", "imperial_intrigue") then
		last_targeted_cooldowns = cm:get_saved_value("last_targeted_cooldowns", "imperial_intrigue");
	else
		return 0;
	end;

	for i, v in ipairs(last_targeted_cooldowns) do
		if v[1] == faction_key then
			return v[2]
		end;
	end;

	return 0;
end;


-- begins cooldown when faction targeted by another faction with increase or decrease IF action
local function set_turn_last_targeted_cooldown(faction_key, turn_number)
	local last_targeted_cooldowns = {};
	if cm:saved_value_exists("last_targeted_cooldowns", "imperial_intrigue") then
		last_targeted_cooldowns = cm:get_saved_value("last_targeted_cooldowns", "imperial_intrigue");
	end;

	for i, v in ipairs(last_targeted_cooldowns) do
		if v[1] == faction_key then
			v[2] = turn_number;
			cm:set_saved_value("last_targeted_cooldowns", last_targeted_cooldowns, "imperial_intrigue");
			return;
		end;
	end;

	table.insert(last_targeted_cooldowns, {faction_key, turn_number});
	cm:set_saved_value("last_targeted_cooldowns", last_targeted_cooldowns, "imperial_intrigue");
end;


local function spend_imperial_favour(faction, amount)
	local imperial_favour = cm:query_faction(faction):pooled_resources():resource(imperial_favour_pr_key);
	cm:modify_model():get_modify_pooled_resource(imperial_favour):apply_transaction_to_factor(favour_diplomacy_factor, -amount);
end

local function increase_imperial_favour_by_factor(faction_key, amount, factor_key)
	local imperial_favour = cm:query_faction(faction_key):pooled_resources():resource(imperial_favour_pr_key);
	cm:modify_model():get_modify_pooled_resource(imperial_favour):apply_transaction_to_factor(factor_key, amount);
end

-- function for finding a factions imperial favour amount
local function get_imperial_favour(faction) -- define the context for imperial favour check, so it doesn't break.
    local imperial_favour = cm:query_faction(faction):pooled_resources():resource(imperial_favour_pr_key) -- create local key to search for an imperial favour value
    if imperial_favour:is_null_interface() then -- checks to see if the faction uses imperial favour resource
        return 0; -- Always returning a value will prevent crashes when it's null.
    end
    return imperial_favour:value()
end

local function imperial_favour_is_active(faction)
	local query_faction = cm:query_faction(faction)
	local imperial_favour = query_faction:pooled_resources():resource(imperial_favour_pr_key) -- create local key to search for an imperial favour value

	return not imperial_favour:is_null_interface() and query_faction:subculture() == "3k_main_chinese" and cm:query_model():calendar_year() >= imperial_intrigue_start_year
end;

-- function for sending data to the UI
local function update_ui_values(optional_emperor_reinstated_faction_key)
	local ui_data = {}

	-- enemy of the han
	ui_data["enemy_of_the_han_targets"] = {} -- have to initialise as a table so the insert function doesn't complain
	local protectorate_key
	if not optional_emperor_reinstated_faction_key then
		if cm:world_power_token_exists("emperor") then
			protectorate_key = cm:get_world_power_token_owner("emperor"):name(); -- find faction that owns the emperor
		end

	else
		if not is_string(optional_emperor_reinstated_faction_key) then
			print_to_console("Imperial Intrigue: No faction has yet restored the Han.")
			return false
		end

		if cm:query_faction(optional_emperor_reinstated_faction_key):is_null_interface() then
			print_to_console("Imperial Intrigue: No faction has yet restored the Han.")
			return false
		end

		protectorate_key = optional_emperor_reinstated_faction_key
	end
	
	if protectorate_key then
		local enemy_of_the_han_list = cm:query_faction(protectorate_key):factions_we_have_specified_diplomatic_deal_with_directional(enemy_of_the_han_data.component_key_indefinite,true) --Gets all the enemy of the Han factions
		enemy_of_the_han_list:foreach(function(q_faction)
			if q_faction:can_do_diplomacy() then
				table.insert(ui_data["enemy_of_the_han_targets"], q_faction:name())
			end
		end)
	end

	-- imperial favour actions
	ui_data["imperial_favour_actions"] = imperial_favour_actions

	-- send to the UI
	effect.set_context_value("dlc07_imperial_intrigue", ui_data)
end


-- Fires once.
local function initialise_intrigue_manager_debug() -- initialise imperial intrigue manager
	
	print_to_console("dlc07_imperial_intrigue: Intialising Intrigue Manager")
	--*****************DEBUGGING*****************
	if not cm:is_multiplayer() then
		-- Enables more verbose debugging.
		-- Example: trigger_cli_debug_event dlc07_imperial_intrigue_manager.enable_debug()
		core:add_cli_listener("dlc07_imperial_intrigue_manager.enable_debug",
			function()
				debug_mode = true;
			end
		);

		-- Enables triggers a low favour mission.
		-- Example: trigger_cli_debug_event dlc07_imperial_intrigue_manager.trigger_low_favour_mission(2)
		core:add_cli_listener("dlc07_imperial_intrigue_manager.trigger_low_favour_mission",
			function(number)
				-- +2 because the first two are incidents
				cm:trigger_mission(cm:get_local_faction(), low_favour_missions[number+2][1], true)
			end
		);

		-- Enables triggers a duty to the han favour mission.
		-- Example: trigger_cli_debug_event dlc07_imperial_intrigue_manager.trigger_duty_to_the_han_mission(2)
		core:add_cli_listener("dlc07_imperial_intrigue_manager.trigger_duty_to_the_han_mission",
			function(number)
				cm:trigger_mission(cm:get_local_faction(), duty_to_the_han_missions[number][1], true)
			end
		);
	end;
end
	
-- #endregion


--[[
***************************************************
***************************************************
** Events
***************************************************
***************************************************
]]--

local function add_mission_listeners(local_faction_key) -- initialise imperial intrigue manager


	-- #region High Favour Events
	--[[
	***************************************************
	***************************************************
	** High Favour Events
	***************************************************
	***************************************************
	]]--

	-- Fires for each human faction in the game
	-- DB controls chance to fire and turns between each event firing.
	-- Creates the faction key, listener key and failure key. 
	-- Placed after the above initialise as otherwise it tries to get the local faction key before the campaign model has been built.
	print_to_console("dlc07_imperial_intrigue: Imperial Favour Events loaded for " .. local_faction_key)

	core:add_listener(
		listener_key, -- unique handle
		"ScriptEventHumanFactionTurnStart",
		function(context) -- Criteria.
			if get_protectorate_key() then
				return context:faction():subculture() == "3k_main_chinese"
				and context:faction():name() ~= get_protectorate_key() -- checks to see if the faction doesn't hold the emperor token
				and context:faction():name() == local_faction_key -- checks to see if the faction is the local faction key
				and get_imperial_favour(context:faction()) > 60 -- checks if imperial favour is above 70
				and not context:faction():has_specified_diplomatic_deal_with_as_recipient(enemy_of_the_han_data.component_key_indefinite,cm:query_faction(get_protectorate_key())) -- Checks to see if the faction dosen't have the enemy of the han deal, where they're the recipiant
				and cm:query_model():turn_number() > 2
			end
		end,
		function(context) -- What to do if listener fires.
			print_to_console("dlc07_imperial_intrigue: Rolling the dice to Trigger a HIGH FAVOUR EVENT", true)
			fire_event(context:faction():name(), high_favour_missions)
		end,
		true --Is persistent
	);

	-- #endregion  


	-- #region Low Favour Events
	--[[
	***************************************************
	***************************************************
	** Low Favour Events
	***************************************************
	***************************************************
	]]--

	core:add_listener(
		listener_key, -- unique handle
		"ScriptEventHumanFactionTurnStart",
		function(context) -- Criteria.
			if get_protectorate_key() then
				return context:faction():subculture() == "3k_main_chinese"
				and context:faction():name() ~= get_protectorate_key() -- checks to see if the faction doesn't hold the emperor token
				and context:faction():name() == local_faction_key -- checks to see if the faction is the local faction key
				and get_imperial_favour(context:faction()) < 40 -- checks if imperial favour is below 40
				and cm:query_model():turn_number() > 2
			end
		end,
		function(context) -- What to do if listener fires.
			print_to_console("dlc07_imperial_intrigue: Rolling the dice to Trigger a LOW FAVOUR EVENT", true)			
			fire_event(context:faction():name(), low_favour_missions)
		end,
		true --Is persistent
	);


	-- #endregion  


	--#region Duty to the Han Events
	
	--[[
	***************************************************
	***************************************************
	** Duty to the Han Events
	***************************************************
	***************************************************
	]]--

	core:add_listener(
		listener_key, -- unique handle
		"ScriptEventHumanFactionTurnStart",
		function(context) -- Criteria.
			if get_protectorate_key() then
				return context:faction():subculture() == "3k_main_chinese"
				and context:faction():name() == local_faction_key -- checks to see if the faction is the local faction key
				and not context:faction():has_specified_diplomatic_deal_with_as_recipient(enemy_of_the_han_data.component_key_indefinite,cm:query_faction(get_protectorate_key())) -- Checks to see if the faction dosen't have the enemy of the han deal, where they're the recipiant
				and cm:query_model():turn_number() > 2
			end
		end,
		function(context) -- What to do if listener fires.
			print_to_console("dlc07_imperial_intrigue: Rolling the dice to Trigger a DUTY OF THE HAN EVENT", true)		
			fire_event(context:faction():name(), duty_to_the_han_missions)
		end,
		true --Is persistent
	);

	-- #endregion

end -- ends the add_mission_listeners function


local function start_imperial_actions(local_faction_key) -- initialise imperial intrigue manager:start_imperial_actions function


	-- #region Enemy of the Han Mechanics
	--[[
	***************************************************
	***************************************************
	** Enemy of the Han Feature
	***************************************************
	***************************************************
	]]--

	-- if a faction has 1 imperial favour then it gets declared an Enemy of the Han automatically.
	core:add_listener(
		listener_key, -- unique handle
		"ScriptEventHumanFactionTurnStart",
			function(context) -- Criteria.
				return not cm:get_world_power_token_owner("emperor"):is_null_interface()
				
			end,
			function(context) -- What to do if listener fires.
				
				if not get_protectorate_key() then
					print_to_console("Imperial Intrigue Listener failed: No Emperor owner found");
					return false;
				end;

				local filtered_factions = cm:query_model():world():faction_list():filter(function(q_faction) -- query all factions and filter them under "q_faction"
					return q_faction:subculture() == "3k_main_chinese"
					and not (q_faction:name() == "3k_main_faction_han_empire" or q_faction:name() == "3k_dlc04_faction_empress_he")
					and get_imperial_favour(q_faction:name()) <= 10 -- checks if imperial favour is 10 or below
					and q_faction:can_do_diplomacy()
					and not q_faction:is_human() 
					and not q_faction:has_specified_diplomatic_deal_with_as_recipient(enemy_of_the_han_data.component_key_indefinite,cm:query_faction(get_protectorate_key())) -- Checks to see if the faction dosen't have the enemy of the han deal, where they're the recipiant
					and q_faction:name() ~= get_protectorate_key()	
				end)
		
				filtered_factions:foreach(function(q_faction) -- for each faction that has been filtered through, apply the function below
					apply_enemy_of_the_han(get_protectorate_key(), q_faction:name()) -- apply Enemy of the Han automatic deal between all Han factions and target faction(s)	
				end)
				update_ui_values() --Update the UI of any potential changes
			end,
			true --Is persistent
	);	


	-- if player faction has 1 imperial favour then fire "3k_dlc07_child_emperor_mission_low_favour_improve_favour" mission.
	core:add_listener(
		listener_key, -- unique handle
		"ScriptEventHumanFactionTurnStart",
		true,
		function(context) -- What to do if listener fires.

			if not get_protectorate_key() then
				print_to_console("Imperial Intrigue Listener failed: No Emperor owner found");
				return false;
			end;

			local filtered_factions = cm:query_model():world():faction_list():filter(function(q_faction) -- query all factions and filter them under "q_faction"
				return q_faction:subculture() == "3k_main_chinese"
				and get_imperial_favour(q_faction:name()) <= 10 -- checks if imperial favour is 10 or below
				and q_faction:is_human()
				and not q_faction:has_specified_diplomatic_deal_with_as_recipient(enemy_of_the_han_data.component_key_indefinite,cm:query_faction(get_protectorate_key())) -- Checks to see if the faction dosen't have the enemy of the han deal, where they're the recipiant
				and q_faction:name() ~=get_protectorate_key()	
			end)

			filtered_factions:foreach(function(q_faction) -- for each faction that has been filtered through, apply the function below
				cm:modify_faction(q_faction):trigger_mission("3k_dlc07_child_emperor_mission_low_favour_improve_favour", true) -- fire mission
			end)
		
	end,
	true --Is persistent
	);	


	-- if a faction has above 50 imperial favour then Enemy of the Han status is removed.
	core:add_listener(
		listener_key, -- unique handle
		"ScriptEventHumanFactionTurnStart",
		true,
		function(context) -- What to do if listener fires.
			if not get_protectorate_key() then
				print_to_console("Imperial Intrigue Listener failed: No Emperor owner found");
				return false;
			end;

			local enemy_of_the_han_list = cm:query_faction(get_protectorate_key()):factions_we_have_specified_diplomatic_deal_with_directional(enemy_of_the_han_data.component_key_indefinite,true) --Gets all the factions, where they're the recipiant of the the enemy of the Han treaty
			local filtered_factions = enemy_of_the_han_list:filter(function(q_faction) -- query all factions and filter them under "q_faction"				
							
				return q_faction:subculture() == "3k_main_chinese" 
				and get_imperial_favour(q_faction:name()) > 50 -- checks if imperial favour is above 50
				and q_faction:can_do_diplomacy()
			end)

			filtered_factions:foreach(function(q_faction) -- for each faction that has been filtered through, apply the function below
				remove_enemy_of_the_han(q_faction:name()) -- Remove Enemy of the Han automatic deal between all Han factions and target faction(s)	
			end)
			update_ui_values() --Update the UI of any potential changes--Update the UI of any potential changes
	end,
	true --Is persistent
	);	


	-- if player fails low favour mission, declare them an enemy of the Han.
	core:add_listener(
		listener_key,
		"MissionFailed",
		function(context) -- Criteria.
			return context:mission():mission_record_key() == "3k_dlc07_child_emperor_mission_low_favour_improve_favour" -- has this mission failed?
		end, 
		function(context) -- What to do if listener fires.			

			if not get_protectorate_key() then
				print_to_console("Imperial Intrigue Listener failed: No Emperor owner found");
				return false;
			end;
			
			apply_enemy_of_the_han(get_protectorate_key(), context:faction():name()) -- apply Enemy of the Han automatic deal between all Han factions and target faction
			update_ui_values() --Update the UI of any potential changes
		end,
		true --Is persistent
	);


	-- If player is declared EotH then give them a dilemma about what to do next.
	core:add_listener(
		listener_key, -- unique handle
		"ScriptEventHumanFactionTurnStart",
		true,
		function(context) -- What to do if listener fires.
			
			if not get_protectorate_key() then
				print_to_console("Imperial Intrigue Listener failed: No Emperor owner found");
				return false;
			end;

			local protective_faction = cm:query_faction(get_protectorate_key())
			local enemy_of_the_han_list = protective_faction:factions_we_have_specified_diplomatic_deal_with_directional(enemy_of_the_han_data.component_key_indefinite,true) --Gets all the enemy of the Han factions

			local filtered_factions = enemy_of_the_han_list:filter(function(q_faction) -- query all "Enemy of the Han" factions and filter all the not dead human factions
				return not q_faction:is_dead() and q_faction:is_human()
			end)

			filtered_factions:foreach(function(q_faction) -- for each faction that has been filtered through, apply the function below
				cm:modify_faction(q_faction):trigger_dilemma("3k_dlc07_child_emperor_dilemma_declared_enemy_of_the_han", true) -- triggers dilemma for target faction(s)
			end)

			--Check if the protector is an enemy of the Han
			if not protective_faction:factions_we_have_specified_diplomatic_deal_with_directional(enemy_of_the_han_data.component_key_indefinite,false):is_empty() and 
			protective_faction:is_human() and 
			not protective_faction:is_dead() then
				cm:modify_faction(protective_faction):trigger_dilemma("3k_dlc07_child_emperor_dilemma_declared_enemy_of_the_han", true) -- triggers dilemma for target faction(s)
			end

		end,
		true --Is persistent
	);	


	--#endregion

	-- #region IF increase for Faction Leader Rank Mechanics
	--[[
	***************************************************
	***************************************************
	********* Faction Leader IF Increase **************
	***************************************************
	***************************************************
	]]--

	-- Check each turn if faction leader of protectorate faction is above rank 5. If true, give 10 IF each turn.
	core:add_listener(
		listener_key, -- Unique handle
		"FactionTurnStart", -- Campaign Event to listen for
		function(context) -- Listener condition
			if get_protectorate_key() then
				return context:faction():name() == get_protectorate_key() and context:faction():faction_leader():rank() >= income_faction_leader_rank_req -- listen for the emperor owning faction leader having rank 5 or above
			end
		end,
		function(context) -- What to do if listener fires.
			increase_imperial_favour_by_factor(context:faction():name(), income_faction_leader_rank_pr, "3k_dlc07_pooled_factor_imperial_favour_characters_people_in_power")
		end,
		true --Is persistent
	);

	--#endregion

	-- #region IF decrease having diplomatic treaties with enemy of the han.
	--[[
	***************************************************
	***************************************************
	****** Enemy of the Han Diplomatic Relations ******
	***************************************************
	***************************************************
	]]--

	core:add_listener(
        listener_key,
        "FactionTurnStart",
        function(context)
			if get_protectorate_key() then
            	return imperial_favour_is_active(context:faction())
			end
        end,
        function(context)
			local eoth_treaties_minor = 0
			local eoth_treaties_major = 0
			local enemy_of_the_han_list = cm:query_faction(get_protectorate_key()):factions_we_have_specified_diplomatic_deal_with_directional(enemy_of_the_han_data.component_key_indefinite,true) --Gets all the enemy of the Han factions
            for i = 0, enemy_of_the_han_list:num_items() - 1 do
                local target_faction = enemy_of_the_han_list:item_at(i);
                
                -- Check what deals the faction may have with an enemy of the Han
                if not target_faction:is_dead() then
                
                    -- Add one to the eoth_treaties for each trade agreement and non_aggression pact we have with enemies of the han
                    if target_faction:has_specified_diplomatic_deal_with("treaty_components_trade", context:faction()) then
                        eoth_treaties_minor = eoth_treaties_minor +1
					end
					if target_faction:has_specified_diplomatic_deal_with("treaty_components_trade_monopoly", context:faction()) then
                        eoth_treaties_minor = eoth_treaties_minor +1
                    end
                    if target_faction:has_specified_diplomatic_deal_with("treaty_components_non_aggression", context:faction()) then
                        eoth_treaties_minor = eoth_treaties_minor +1
					end
					if target_faction:has_specified_diplomatic_deal_with("treaty_components_military_access", context:faction()) then
                        eoth_treaties_minor = eoth_treaties_minor +1
					end
					if target_faction:has_specified_diplomatic_deal_with("treaty_components_alliance", context:faction()) then
                        eoth_treaties_major = eoth_treaties_major +1
					end	
					if target_faction:has_specified_diplomatic_deal_with("treaty_components_coalition", context:faction()) then
                        eoth_treaties_major = eoth_treaties_major +1
                    end									
                end
            end
            
            -- Modify the faction's Imperial Favour for each minor treaty that have with an enemy of the han faction
            if eoth_treaties_minor > 0 then
                increase_imperial_favour_by_factor(context:faction():name(), (income_eoth_treaties_minor * eoth_treaties_minor) , "3k_dlc07_pooled_factor_imperial_favour_enemy_of_the_han")
            end
			
			-- Modify the faction's Imperial Favour for each major treaty that have with an enemy of the han faction
			if eoth_treaties_major > 0 then
				increase_imperial_favour_by_factor(context:faction():name(), (income_eoth_treaties_major * eoth_treaties_major) , "3k_dlc07_pooled_factor_imperial_favour_enemy_of_the_han")
			end
        end,
        true
    );
	
	--#endregion

	--#region Imperial Favour AI interactions
	--[[
	***************************************************
	***************************************************
	****** AI interactions with Imperial Favour *******
	***************************************************
	***************************************************
	]]--


	-- check each turn if a Han faction should increase IF of a friendly faction with low IF.
	core:add_listener(
		listener_key, -- Unique handle
		"FactionTurnStart", -- Campaign Event to listen for
		function(context) -- Listener condition
			-- listen for AI faction of chinese subculture with cooldown not expired.
			local local_faction = context:faction()
			return local_faction:subculture() == "3k_main_chinese" and local_faction:name() ~= "3k_main_faction_han_empire" and not local_faction:is_human()
			and local_faction:name() ~= "3k_dlc04_faction_empress_he" and local_faction:name() ~= "3k_dlc04_faction_rebels" and not local_faction:is_rebel()
			and get_turn_last_applied_cooldown(local_faction:name()) + length_of_applied_cooldown >= cm:turn_number()
			and cm:roll_random_chance(20)
		end,
		function(context) -- What to do if listener fires.
			local local_faction = context:faction()
			local target_faction_score = nil
			local end_target_faction = nil
			local neg_target_faction_score = nil
			local neg_end_target_faction = nil


			local valid_targets_list = cm:query_model():world():faction_list():filter(function(target_faction)  
				return target_faction:is_dead() == false and target_faction:subculture() == "3k_main_chinese" and target_faction:name() ~= "3k_main_faction_han_empire" 
				and target_faction:name() ~= "3k_dlc04_faction_rebels" and not target_faction:is_rebel() and target_faction ~= local_faction
				and get_turn_last_targeted_cooldown(target_faction:name()) + length_of_targeted_cooldown <= cm:turn_number()
			end)

			-- grab a list of factions.
			-- use valid targets lists to define whether they are valid Han target, with IF enabled and has not been targeted recently.
			-- for each faction give a value based on diplomatic standing, EotH status, diplomatic treaties and IF level.
			for i=0, valid_targets_list:num_items() - 1 do
				local target_faction = valid_targets_list:item_at(i);
				local faction_score = 0; -- the higher the faction score, the more likely the target faction is chosen
				local neg_faction_score = 0; -- the lower the neg faction score, the more likely the target faction is chosen

				-- Reduce score if target faction holds Emperor (Scheming)
				if get_protectorate_key() then
					if target_faction == cm:query_faction(get_protectorate_key()) then
						faction_score = faction_score - 30
						neg_faction_score = neg_faction_score - 30
					end
				end


				-- Increase score if target faction is human
				if target_faction:is_human() then
					faction_score = faction_score + 10
					neg_faction_score = neg_faction_score + 15
				end

				-- Reduce score if target is at war with local faction
				if target_faction:has_specified_diplomatic_deal_with("treaty_components_war", local_faction) then
					faction_score = faction_score - 100
					neg_faction_score = neg_faction_score - 30
				end;

				-- Increase score if target faction is a vassal	of local faction						
				if diplomacy_manager:is_vassal_of(local_faction, target_faction) then
					faction_score = faction_score + 50
					neg_faction_score = neg_faction_score + 70
				end;

				-- Increase score if target faction is an ally or in coalition
				if target_faction:has_specified_diplomatic_deal_with("treaty_components_coalition", local_faction)
				or target_faction:has_specified_diplomatic_deal_with("treaty_components_alliance", local_faction) then
					faction_score = faction_score + 20
					neg_faction_score = neg_faction_score + 50
				end;

				-- Reduce score if target faction is EotH	
				if target_faction:has_specified_diplomatic_deal_with("dummy_treaty_components_enemy_of_the_han_indefinite", local_faction) then
					faction_score = faction_score - 40
					neg_faction_score = neg_faction_score + 70
				end;

				-- Increase score if target faction is EotH	but has positive diplomatic standing
				if target_faction:has_specified_diplomatic_deal_with("dummy_treaty_components_enemy_of_the_han_indefinite", local_faction)
				and target_faction:diplomatic_standing_with(local_faction) >= 25 then
					faction_score = faction_score + 100
					neg_faction_score = neg_faction_score + 100
				end;				

				-- change score depending on diplomatic standing with faction
				faction_score = faction_score + (target_faction:diplomatic_standing_with(local_faction)*0.5)
				neg_faction_score = neg_faction_score +	target_faction:diplomatic_standing_with(local_faction)

				-- change score depending on IF value of faction
				faction_score = (faction_score + 70) - get_imperial_favour(target_faction);
				neg_faction_score = (neg_faction_score + 50) - get_imperial_favour(target_faction);


				-- Set highest scoring faction as candidate for improve IF action
				if target_faction_score == nil or faction_score > target_faction_score then
					target_faction_score = faction_score
					end_target_faction = target_faction
				end;

				-- Set lowest scoring faction as candidate for decrease IF action
				if neg_target_faction_score == nil or neg_faction_score < neg_target_faction_score then
					neg_target_faction_score = neg_faction_score
					neg_end_target_faction = target_faction
				end;
			end	

			if end_target_faction ~= nil
			and neg_end_target_faction ~= nil
			then
			print_to_console("Imperial Intrigue: "..local_faction:name().." has chosen target faction " .. end_target_faction:name().." with faction score "..target_faction_score);
			print_to_console("Imperial Intrigue: "..local_faction:name().." has chosen negative target faction " .. neg_end_target_faction:name().." with negative faction score ".. neg_target_faction_score);
			
			local roll_chance = (50 + ((target_faction_score*0.25) + (neg_target_faction_score*0.25))) 

				if cm:roll_random_chance(roll_chance) 
				then 
					if target_faction_score >=0
					then
					-- if random roll succeeded choose to increase IF
					cm:modify_faction(end_target_faction:name()):apply_effect_bundle(increase_imperial_favour_bundle, 1)
					ai_using_favour_change_event(local_faction:name(), end_target_faction:name(), increase_imperial_favour_bundle)
					set_turn_last_targeted_cooldown(end_target_faction:name(), cm:turn_number())
					set_turn_last_applied_cooldown(local_faction:name(), cm:turn_number());
					print_to_console("Imperial Intrigue: "..local_faction:name().." applied increase favour on ".. end_target_faction:name().." on turn "..cm:turn_number().." with roll chance ".. roll_chance);
					end

				-- if random roll failed choose to decrease IF
				elseif neg_target_faction_score <=0 
				then 
					cm:modify_faction(neg_end_target_faction:name()):apply_effect_bundle(decrease_imperial_favour_bundle, 1)
					ai_using_favour_change_event(local_faction:name(), neg_end_target_faction:name(), decrease_imperial_favour_bundle)	
					set_turn_last_targeted_cooldown(neg_end_target_faction:name(), cm:turn_number())
					set_turn_last_applied_cooldown(local_faction:name(), cm:turn_number());
					print_to_console("Imperial Intrigue: "..local_faction:name().." applied decrease favour on ".. neg_end_target_faction:name().." on turn "..cm:turn_number().." with roll chance ".. roll_chance);
				end
			end
		end,
		true --Is persistent
	);


	--#endregion

end -- ends the start_imperial_actions function	


local function start_han_dynasty(local_faction_key) -- initialise imperial intrigue manager:start_han_dynasty function
	
	-- #region Han Dynasty
	--[[
	***************************************************
	***************************************************
	** HAN DYNASTY
	***************************************************
	***************************************************
	]]--

	-- When faction reaches emperor level faction progression, allow player to choose to place emperor back on throne.
	
	local function create_emperor_dilemma(last_emperor_key)
		if cm:query_faction(last_emperor_key):is_human() then
			cm:modify_faction(last_emperor_key):trigger_dilemma("3k_dlc07_han_dynasty_restoration", true) -- triggers dilemma for target faction
			print_to_console("Imperial Intrigue: Triggering Han Dynasty Dilemma");		
		else 
			-- check if Emperor Xian has already been spawned	
			if 	table.contains(han_loyalists, last_emperor_key) then -- if AI faction is a Han loyalist, they will restore the Han Dynasty.			
				restore_han_dynasty(last_emperor_key)	-- makes Emperor Xian faction leader.
				for i, local_faction_key in ipairs(cm:get_human_factions()) do
					cm:trigger_incident(local_faction_key, "3k_dlc07_child_emperor_incident_han_dynasty_restored_ai", true) -- triggers Han Dynasty Restored (by AI) incident
				end						
				output("Imperial Intrigue: ".. tostring(last_emperor_key) .. "has restored the Han Dynasty");	
			end
		end
	end

	-- If faction recently owned the emperor token, remove and create Emperor Xian character.
	-- Listen for UI context as to whether the emperor should take the place of faction leader, or remain part of the player faction as a character.
	core:add_listener(
		listener_key.."restorehandynastydilemma", -- UID
		"WorldLeaderRegionAdded", -- CampaignEvent
		function(event)
			print_to_console("Imperial Intrigue: World Power Token Removed, checking if Han Dynasty dilemma should be fired");
			local query_faction = event:region():owning_faction();

			-- did one of the factions that owns the world leader region hold the emperor token before it was removed? 
			if cm:saved_value_exists("last_emperor_owner", "imperial_intrigue")
			and cm:saved_value_exists("turn_emperor_token_removed", "imperial_intrigue")
			then 	
				local final_emperor_owner = cm:get_saved_value("last_emperor_owner", "imperial_intrigue")
				local emperor_removed_turn = cm:get_saved_value("turn_emperor_token_removed", "imperial_intrigue")
				return query_faction:name() == final_emperor_owner and event:query_model():turn_number() == emperor_removed_turn		
			end

		end, -- Function to fire.
		function(context)
			if cm:saved_value_exists("last_emperor_owner", "imperial_intrigue") then
				local last_emperor_key = cm:get_saved_value("last_emperor_owner", "imperial_intrigue")
				print_to_console("Imperial Intrigue:".. last_emperor_key.. " owned the World Power Token. Han Dynasty dilemma will be fired.");	

				--if the emperor is of age, fire the dilemma or make han loyalist AI faction restore him
				if(cm:query_model():calendar_year() >= 197) then
					create_emperor_dilemma(last_emperor_key)
				--if emperor is not of age, create a new listener that will fire when he does come of age. Pretty much does the same as above,
				else
					print_to_console("Imperial Intrigue: Emperor Xian not of age! The dilemma will instead fire when he comes of age.");	
					cm:set_saved_value("emperor_xian_waiting_for_restore_dilemma", true, "imperial_intrigue");
					core:add_listener(
						listener_key.."restore_han_dynasty_dilemma_come_of_age_variation",
						"FactionTurnStart",
						function(context)
							--if this is the faction who last owned the emperor, and the emperor has come of age,
							return context:faction():name() == cm:get_saved_value("last_emperor_owner", "imperial_intrigue")
							and cm:query_model():calendar_year() >= 197
						end,
						function (context)
							local last_emperor_key = cm:get_saved_value("last_emperor_owner", "imperial_intrigue")
							create_emperor_dilemma(last_emperor_key)
						end,
						false
					)

				end
			end
		end,
		false -- Is Persistent
	);

		-- listens for the player to choose who to place as emperor. If Han restored option chosen, place Emperor Xian on the throne.
		core:add_listener(
			listener_key.."restorehandynastydilemmachoice", -- UID
			"DilemmaChoiceMadeEvent", -- CampaignEvent
			function(context) 
				return context:dilemma() == "3k_dlc07_han_dynasty_restoration" and context:choice() == 1 
			end, -- criteria
			function (context) --what to do if listener fires
				if cm:saved_value_exists("last_emperor_owner", "imperial_intrigue")
				then local last_emperor_key = cm:get_saved_value("last_emperor_owner", "imperial_intrigue")

					restore_han_dynasty(last_emperor_key)
					cm:trigger_incident(last_emperor_key, "3k_dlc07_child_emperor_incident_han_dynasty_restored", true) -- triggers Han Dynasty Restored (by player) incident
					print_to_console("Imperial Intrigue:".. last_emperor_key .."has restored the Han Dynasty");
					update_ui_values(last_emperor_key)
					cm:modify_model():get_modify_episodic_scripting():disable_event_feed_events(false, "", "", "world_power_token_removed");
					output("Imperial Intrigue: UnSupressing the world_power_token_removed event.");		
				end
			end, 
			false -- is persistent
		)

	-- Function that listens each turn to see if emperor token has been removed for more than 5 turns. Then spawns Liu Xie if the Han have not been restored. 
	core:add_listener(
		listener_key.."RestoreHanLiuXieAbdicates", -- UID
		"WorldStartOfRoundEvent", -- CampaignEvent
		function(context)
			local emperor_xian = cm:query_model():character_for_template("3k_dlc04_template_historical_emperor_xian_earth");
			local liu_xie = cm:query_model():character_for_template("3k_main_template_historical_liu_xie_hero_earth");

			-- Has emperor xian previously existed, if so has it been more than a year after he was removed from the game
			if cm:saved_value_exists("last_emperor_owner", "imperial_intrigue")
			and cm:saved_value_exists("turn_emperor_token_removed", "imperial_intrigue")
			then
				local emperor_removed_turn = cm:get_saved_value("turn_emperor_token_removed", "imperial_intrigue")
				return (context:query_model():turn_number() == emperor_removed_turn + emperor_in_hiding) and emperor_xian:is_null_interface() and liu_xie:is_null_interface()
			end

		end, -- function to fire.	
		function(event)	
			print_to_console("Imperial Intrigue: Han Dynasty not restored. Checking to see if Liu Xie should spawn in a faction.");
			-- Make sure the Emperor wasn't killed before we try to spawn them
			if campaign_emperor_manager and campaign_emperor_manager.emperor_dead == false then
				-- Spawn the Emperor as a character in the game.

				
				-- Get a faction to spawn them in, try the Han Empire first
				local spawn_q_faction = cm:query_faction("3k_main_faction_han_empire");

				-- If they're dead pick another faction.
				if not spawn_q_faction or spawn_q_faction:is_dead() then
					local highest_score = 0;

					for i=0, event:query_model():world():faction_list():num_items() - 1 do
						local qFaction = event:query_model():world():faction_list():item_at(i);
						local qFactionScore = 0;
						if not qFaction:is_dead() and qFaction:subculture() == "3k_main_chinese" then
							if qFaction:is_world_leader() then
								qFactionScore = qFactionScore + ( 10 * qFaction:number_of_world_leader_regions() );
							end;
							if qFaction:is_human() then
								qFactionScore = qFactionScore + 5;
							end;
							qFactionScore = qFactionScore + cm:random_number(15);
							if qFactionScore > highest_score then
								spawn_q_faction = qFaction;
								highest_score = qFactionScore
							end;
						end;
					end 
				end

				-- Spawn the character in the faction if we got one.
				if not spawn_q_faction then
					script_error("Imperial Intrigue: No faction found for the emperor, this shouldn't happen!");
					return false;
				end;

				-- Spawn them in the faction.
				output( "Imperial Intrigue: Spawning Han Emperor in faction: " .. tostring(spawn_q_faction:name()) );
				local spawn_m_faction = cm:modify_faction( spawn_q_faction );
				spawn_m_faction:create_character_from_template( "general", "3k_general_earth", "3k_dlc04_template_historical_emperor_xian_earth", false);
			else
			print_to_console( "Imperial Intrigue: NOT Spawning Han Emperor as a character, because they're dead!");
			end
		end,
		false -- is persistent
	);	

	-- #endregion

end -- ends the start_han_dynasty function


-- #region Emperor Removed
--[[
***************************************************
***************************************************
** Emperor Token Removed
***************************************************
***************************************************
]]--

-- If world power token "emperor" is removed, then remove all enemy of the Han deals.
core:add_listener(
	listener_key .. "WorldPowerTokenRemoved", -- unique handle
	"WorldPowerTokenRemovedEvent", -- Campaign event
	function(context)
		return context:token() == "emperor";
	end,
	function(context)
	
		output("Imperial Intrigue: Emperor Token has been removed: Disabling Imperial Intrigue Systems")

		-- disable the ability to use the imperial decree diplo treaty
		cm:modify_model():disable_diplomacy("all", "all", "treaty_components_issue_Imperial_decree,treaty_components_recieve_imperial_decree",  "hidden")

		local filtered_factions = cm:query_model():world():faction_list():filter(function(q_faction) -- query all factions and filter them under "q_faction"
			return q_faction:subculture() == "3k_main_chinese"
		end)
		filtered_factions:foreach(function(q_faction) -- for each faction that has been filtered through, apply the function below
			if not q_faction:pooled_resources():resource(imperial_favour_pr_key):is_null_interface() and q_faction:subculture() == "3k_main_chinese" and cm:query_model():calendar_year() >= imperial_intrigue_start_year then-- checks if the pooled resource is enabled
				
				for _, mission_key in ipairs(all_child_emperor_missions) do
					if cm:query_model():event_generator_interface():any_of_missions_active(q_faction, mission_key) then
						cm:modify_faction(q_faction):cancel_custom_mission(mission_key)
					end
				end

			end
		end)
		
		-- Disable the imperial intrigue panel
		cm:modify_scripting():override_ui("disable_imperial_intrigue", true);
		cm:modify_model():set_end_turn_notification_suppressed("IMPERIAL_FAVOUR_LOW", true);
		
		-- Disable most of the imperial intrigue script
		core:remove_listener(listener_key)

		-- Save the last emperor owner, and remove any Enemy of the Han treaties
		cm:set_saved_value("last_emperor_owner", cm:get_world_power_token_owner("emperor"):name(), "imperial_intrigue") -- saves last faction to own the emperor token
		cm:set_saved_value("turn_emperor_token_removed", context:query_model():turn_number(), "imperial_intrigue") -- saves the turn the emperor token was removed
			local final_emperor_owner = cm:get_saved_value("last_emperor_owner", "imperial_intrigue")
			local emperor_removed_turn = cm:get_saved_value("turn_emperor_token_removed", "imperial_intrigue")			
		output("Imperial Intrigue:".. tostring(final_emperor_owner) .." owned the World Power Token before it was removed on turn" .. tostring(emperor_removed_turn))

		--Find and remove all the enemy of the han treaties
		local filtered_factions = cm:query_model():world():faction_list():filter(function(q_faction) -- query all factions and filter them under "q_faction"
			return q_faction:subculture() == "3k_main_chinese" 
			and q_faction:can_do_diplomacy()
			and q_faction:has_specified_diplomatic_deal_with(enemy_of_the_han_data.component_key_indefinite, cm:query_faction(final_emperor_owner))
		end)
		filtered_factions:foreach(function(q_faction) -- for each faction that has been filtered through, apply the function below
			remove_enemy_of_the_han(q_faction:name()) -- Remove Enemy of the Han automatic deal between all Han factions and target faction(s)							
		end)
		
		-- Disable the favour resource on all factions
		local faction_list = cm:query_model():world():faction_list()
		for i = 0, faction_list:num_items() - 1 do
			local faction = faction_list:item_at(i)
			local favour = faction:pooled_resources():resource(imperial_favour_pr_key);
			if not favour:is_null_interface() then
				cm:modify_model():get_modify_pooled_resource(favour):disable()
			end
		end
		
		update_ui_values() --Update the UI of any potential changes
		
		if cm:query_faction(final_emperor_owner):is_human() then
			-- We supress this event here so the player doesn't confusingly get the abdication event as well as the dilemma 
			cm:modify_model():get_modify_episodic_scripting():disable_event_feed_events(true, "", "", "world_power_token_removed");		
			output("Imperial Intrigue: Supressing the world_power_token_removed event.");		
		end
	end,
	true
);		
	

--#endregion



--#region Imperial Favour actions handler

-- listen for imperial favour actions being applied to a faction through imperial intrigue UI panel.
-- get faction key from the faction being targeted (needs context from UI code).
-- apply the results of that action
core:add_listener(
	"dlc07_emperor_panel", 
	"ModelScriptNotificationEvent",
	function(model_script_notification_event)
		
		return string.find(model_script_notification_event:event_id(),"dlc07_imperial_intrigue_action") -- listen for UI interaction with Enemy of the Han mechanic
	end,
	function(model_script_notification_event) 
		local target_faction_key = effect.get_context_value("CcoScriptObject", "dlc07_imperial_intrigue_panel_target_key", "StringValue") -- find targeted faction
		local activating_faction_key = effect.get_context_value("CcoScriptObject", "dlc07_imperial_intrigue_panel_local_faction_key", "StringValue") -- find targeted faction
		for key, action in pairs(imperial_favour_actions) do
			if string.find(model_script_notification_event:event_id(), key) then
				-- can afford imperial favour cost
				-- make sure off cooldown
				-- validate they have the required world power token
				local can_afford = get_imperial_favour(activating_faction_key) >= action.favour_cost
				local is_off_cooldown = action.current_cooldown[activating_faction_key] <= 0
				local has_required_token = action.requires_world_power_token == nil or cm:get_world_power_token_owner(action.requires_world_power_token):name() == activating_faction_key
				local target_below_imperial_favour_limit = action.target_max_favour == nil or get_imperial_favour(target_faction_key) <= action.target_max_favour
				if can_afford and is_off_cooldown and has_required_token and target_below_imperial_favour_limit then
					spend_imperial_favour(activating_faction_key, action.favour_cost)
					action.func(activating_faction_key, target_faction_key)
					action.current_cooldown[activating_faction_key] = action.cooldown
					update_ui_values()
					break
				end
			end
		end
	end,
	true    
)



-- #endregion 


---------------------------------------------------------------------------------------------------------
----- SAVE/LOAD
---------------------------------------------------------------------------------------------------------
cm:add_saving_game_callback(
	function(saving_game_event)
		for action_key, action in pairs(imperial_favour_actions) do
			cm:save_named_value("dlc07_imperial_intrigue_"..action_key .. "_cooldown", action.current_cooldown)
		end
	end
);
cm:add_loading_game_callback(
	function(loading_game_event)
		-- Load out the saved cooldowns
		for action_key, action in pairs(imperial_favour_actions) do
			imperial_favour_actions[action_key].current_cooldown = cm:load_named_value("dlc07_imperial_intrigue_"..action_key .. "_cooldown", imperial_favour_actions[action_key].current_cooldown)
		end
	end
)



--[[
***************************************************
***************************************************
** INITIALISATION
***************************************************
***************************************************
]]--

local function enable_system()

	-- set the resource to enabled for the right factions
	local faction_list = cm:query_model():world():faction_list()
	for i = 0, faction_list:num_items() - 1 do
		local faction = faction_list:item_at(i)
		local favour = faction:pooled_resources():resource(imperial_favour_pr_key);
		if not favour:is_null_interface() then
			cm:modify_model():get_modify_pooled_resource(favour):enable()
		end
	end

	for i, faction_key in ipairs(cm:get_human_factions()) do
	
		-- finds all human factions currently playing and add their missions.
		add_mission_listeners(faction_key)
		start_imperial_actions(faction_key)

		--setup the cooldowns so the UI can more easily use them
		for action_key, _ in pairs(imperial_favour_actions) do
			if 	imperial_favour_actions[action_key].current_cooldown[faction_key] == nil then
				imperial_favour_actions[action_key].current_cooldown[faction_key] = -1
			end
		end
	end
	
	-- Setup the right diplomacy treaties for the emperor's faction
	local emperor = cm:get_world_power_token_owner("emperor")
	output("Imperial Intrigue: Enabling Imperial Decrees for faction:" .. tostring(emperor:name()) .. "and han chinese subculture factions")
	cm:modify_model():enable_diplomacy("faction:"..emperor:name(), "subculture:3k_main_chinese", "treaty_components_issue_Imperial_decree", "hidden");
	cm:modify_model():enable_diplomacy("subculture:3k_main_chinese", "faction:".. tostring(emperor:name()), "treaty_components_recieve_imperial_decree", "hidden");

	-- Enable the imperial intrigue panel 
	cm:modify_scripting():override_ui("disable_imperial_intrigue", false);
	cm:modify_model():set_end_turn_notification_suppressed("IMPERIAL_FAVOUR_LOW", false);
	
	-- Add cooldown counter
	core:add_listener(
		listener_key .. "CooldownCounterStartOfRound", -- Unique handle
		"WorldStartOfRoundEvent", -- Campaign Event to listen for
		true,
		function(context) -- What to do if listener fires.
			for _, action in pairs(imperial_favour_actions) do
				for faction_key, cooldown in pairs(action.current_cooldown) do
					if cooldown > 0 then
						action.current_cooldown[faction_key] = cooldown - 1
					end
					if action.current_cooldown[faction_key] <= 0 then
						action.current_cooldown[faction_key] = -1
					end
				end
			end
			update_ui_values()
		end,
		true --Is persistent
	);	
	
	-- Give a favour boost to a faction if they're the Han Empire, or their faction leader is an Emperor/Empress
	core:add_listener(
		listener_key .. "HanEmpireFavourBoost", -- Unique handle
		"WorldStartOfRoundEvent", -- Campaign Event to listen for
		true,
		function(context) -- What to do if listener fires.
		
			-- Get a list of factions and make sure they have favour before we start modifying it
			local faction_list = cm:query_model():world():faction_list()
			for i = 0, faction_list:num_items() - 1 do
				local faction = faction_list:item_at(i)

				local favour = faction:pooled_resources():resource(imperial_favour_pr_key);
				if not favour:is_null_interface() then
				
					-- Check to see if we're a han empire faction
					local han_empire_faction = faction:name() == "3k_main_faction_han_empire"
					local empress_he_faction = faction:name() == "3k_dlc04_faction_empress_he"
					
					-- Check to see if we're lead by an emperor/empress
					local empress_he_leader = false
					local liu_hong_leader = false
					local liu_xie_leader = false
					if not faction:faction_leader():is_null_interface() then
						local faction_leader_key = faction:faction_leader():generation_template_key()
						empress_he_leader = faction:faction_leader():generation_template_key() == "3k_dlc04_template_historical_empress_he_fire"
						liu_hong_leader = faction:faction_leader():generation_template_key() == "3k_dlc04_template_historical_liu_hong_water"
						liu_xie_leader = faction:faction_leader():generation_template_key() == "3k_dlc04_template_historical_emperor_xian_earth"
					end
					
					-- If either check is true lets get some extra favour
					if han_empire_faction or empress_he_faction or empress_he_leader or liu_hong_leader or liu_xie_leader then
						cm:modify_model():get_modify_pooled_resource(favour):apply_transaction_to_factor("3k_dlc07_pooled_factor_imperial_favour_diplomacy", 20);
					end
					
				end
			end

			--Send the relevant data to the UI
			update_ui_values()
			
		end,
		true --Is persistent
	);	
	
	 -- Update ui data
	update_ui_values()
	
end



cm:add_first_tick_callback_new(function() -- initialise on new campaign start only

	local function apply_initial_factor_transactions(initial_values)
		for faction_key, amount in pairs(initial_values)
		do local faction = cm:query_faction(faction_key)
			local pr = faction:pooled_resources():resource(imperial_favour_pr_key);
			cm:modify_model():get_modify_pooled_resource(pr):apply_transaction_to_factor("3k_dlc07_pooled_factor_imperial_favour_events", amount);
			tostring("Imperial Intrigue: Varying starting faction imperial favour levels for faction: ".. tostring(faction:name()))
		end
	end

	local faction_values = starting_resources[cm:query_model():campaign_name()]
	if faction_values then 
		apply_initial_factor_transactions(faction_values)
	end
	
	-- Update ui data
	update_ui_values()

end)

 -- initialise each time campaign is loaded
cm:add_first_tick_callback(function()

	-- Disable the imperial intrigue panel
	cm:modify_scripting():override_ui("disable_imperial_intrigue", true);
	cm:modify_model():set_end_turn_notification_suppressed("IMPERIAL_FAVOUR_LOW", true);

	-- disable ability to issue or recieve decrees between all factions
	cm:modify_model():disable_diplomacy("all", "all", "treaty_components_issue_Imperial_decree,treaty_components_recieve_imperial_decree",  "hidden") 

	-- Check to see if the emperor token exists
   	if not cm:get_world_power_token_owner("emperor"):is_null_interface() then
	
		-- Check to see if we've reached the start date to turn the system on
		if cm:query_model():calendar_year() >= imperial_intrigue_start_year then
		
			output("dlc07_imperial_intrigue: Enabling system")
			enable_system();
		
		else
		
			-- It's too early to turn on the system, so add a listener to turn it on later
			core:add_listener(
				"intrigue_emperor_token_exists_round_start", -- unique handle
				"ScriptEventHumanFactionTurnStart",
				function(context) -- Criteria.
					return cm:query_model():calendar_year() >= imperial_intrigue_start_year and not cm:get_world_power_token_owner("emperor"):is_null_interface()
				end,
				function(context) -- What to do if listener fires.
					for i, faction_key in ipairs(cm:get_human_factions()) do
						cm:trigger_incident(faction_key, "3k_dlc07_child_emperor_incident_start_date", true) 
						output("dlc07_imperial_intrigue: Enabling system")
						enable_system();                        
					end
				end,
				false --Is persistent
			);
			
			-- Set the PR to disabled in the script
			local faction_list = cm:query_model():world():faction_list()
			for i = 0, faction_list:num_items() - 1 do
				local faction = faction_list:item_at(i)
				local favour = faction:pooled_resources():resource(imperial_favour_pr_key);
				if not favour:is_null_interface() then
					cm:modify_model():get_modify_pooled_resource(favour):disable()
				end
			end
			
			-- Update ui data
			update_ui_values()
			
		end
	else
		
		--if its before 197, then Xian is a child.
		--If the player is emperor rank, but Xian is still child, we need to create the listener to give the Restore the Han dilemma in 197
		if cm:saved_value_exists("emperor_xian_waiting_for_restore_dilemma", "imperial_intrigue") and cm:get_saved_value("emperor_xian_waiting_for_restore_dilemma","imperial_intrigue") == true then
			local emperor_owner_key = cm:get_saved_value("last_emperor_owner", "imperial_intrigue")
			print_to_console("Imperial Intrigue: Emperor Xian not of age! The dilemma will instead fire when he comes of age.");	
			core:add_listener(
				listener_key.."restore_han_dynasty_dilemma_come_of_age_variation",
				"FactionTurnStart",
				function(context)
					--if this is the faction who last owned the emperor, and the emperor has come of age,
					return context:faction():name() == emperor_owner_key
					and cm:query_model():calendar_year() >= 197
				end,
				function (context)
					if cm:query_faction(emperor_owner_key):is_human() then
						cm:modify_faction(emperor_owner_key):trigger_dilemma("3k_dlc07_han_dynasty_restoration", true) -- triggers dilemma for target faction
						print_to_console("Imperial Intrigue: Triggering Han Dynasty Dilemma");		
					else 
						-- check if Emperor Xian has already been spawned	
						if 	table.contains(han_loyalists, emperor_owner_key) then -- if AI faction is a Han loyalist, they will restore the Han Dynasty.			
							restore_han_dynasty(emperor_owner_key)	-- makes Emperor Xian faction leader.
							for i, local_faction_key in ipairs(cm:get_human_factions()) do
								cm:trigger_incident(local_faction_key, "3k_dlc07_child_emperor_incident_han_dynasty_restored_ai", true) -- triggers Han Dynasty Restored (by AI) incident
							end						
							output("Imperial Intrigue: ".. tostring(emperor_owner_key) .. "has restored the Han Dynasty");	
						end
					end
					cm:set_saved_value("emperor_xian_waiting_for_restore_dilemma", false, "imperial_intrigue")
				end,
				false
			)
		else
			-- Emperor token has already been removed so we can safely turn off the script now
			output("Imperial Intrigue: Emperor Token has been removed. Disabling Imperial Intrigue Script")
			return 
		end
		
	end
	
	 -- Setup debug listeners
	initialise_intrigue_manager_debug()
	
	-- Start han dynasty wrapper function
	for i, local_faction_key in ipairs(cm:get_human_factions()) do
		--- finds all human factions currently playing and create faction keys for Han Dilemma.
		start_han_dynasty(local_faction_key)
	end
 
end) --self register function
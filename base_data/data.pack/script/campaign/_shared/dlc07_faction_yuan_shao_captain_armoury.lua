---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------
----- Name:			dlc07_faction_yuan_shao_captain_armoury.lua
----- Description: 	This script handles Yuan Shao's captain armoury mechanic
---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------

-- Don't load in campaigns which don't require it.
if cm.name == "ep_eight_princes" then
	output("dlc07_faction_yuan_shao_captain_armoury.lua: Not loaded in this campaign." );
	return;
else
	output("dlc07_faction_yuan_shao_captain_armoury.lua: Loading");
end;

local yuan_shao_faction_key = "3k_main_faction_yuan_shao";
local yuan_shao_pr_key = "3k_main_pooled_resource_lineage"
local AI_pooled_resource_generation_amount = 40;

-- Table holding the script and variables.
yuan_shao_captain_armoury = {
	shop_items_data = {
		["tier_1"] = 
		{
			entry_threshold = 30,
			tier_icon_path = "ui/skins/default/3k_dlc07_captains_pooled_resource_tier_icon_1.png";
			["item_list"] = 
			{
				["3k_dlc07_captains_armoury_captain_missions_dummy"] = {
					title_key = "3k_dlc07_captains_armoury_captain_missions_title",
					icon_path = "ui/skins/default/3k_dlc07_captain_elite_bonus_icon_captain_quests.png",
					description_key = "3k_dlc07_captains_armoury_captain_missions_description",
					unlock_condition_key = "3k_dlc07_cao_cao_schemes_dummy_04_unlock_condition",
					effect_bundle_key = "3k_dlc07_captains_armoury_captain_missions_dummy",
					cost = 0,
					is_elite = true,
					is_faction_wide = true,
				},
				["3k_dlc07_captains_armoury_melee_charge_bonus"] = {
					title_key = "3k_dlc07_captains_melee_charge_bonus_title",
					icon_path = "ui/skins/default/3k_dlc07_captain_regular_bonus_icon_melee_charge_bonus.png",
					description_key = "3k_dlc07_captains_melee_charge_bonus_description",
					unlock_condition_key = "3k_dlc07_cao_cao_schemes_dummy_04_unlock_condition",
					effect_bundle_key = "3k_dlc07_captains_armoury_melee_charge_bonus",
					cost = 30,
					is_elite = false,
					is_faction_wide = false,
				},
				["3k_dlc07_captains_armoury_melee_damage"] = {
					title_key = "3k_dlc07_captains_melee_damage_title",
					icon_path = "ui/skins/default/3k_dlc07_captain_regular_bonus_icon_melee_damage_base.png",
					description_key = "3k_dlc07_captains_melee_damage_description",
					unlock_condition_key = "3k_dlc07_cao_cao_schemes_dummy_04_unlock_condition",
					effect_bundle_key = "3k_dlc07_captains_armoury_melee_damage",
					cost = 30,
					is_elite = false,
					is_faction_wide = false,
				},
				["3k_dlc07_captains_armoury_guerrilla_deployment"] = {
					title_key = "3k_dlc07_captains_guerrilla_deployment_title",
					icon_path = "ui/skins/default/3k_dlc07_captain_regular_bonus_icon_guerilla_deployment.png",
					description_key = "3k_dlc07_captains_guerrilla_deployment_description",
					unlock_condition_key = "3k_dlc07_cao_cao_schemes_dummy_04_unlock_condition",
					effect_bundle_key = "3k_dlc07_captains_armoury_guerrilla_deployment",
					cost = 30,
					is_elite = false,
					is_faction_wide = false,
				},
				["3k_dlc07_captains_armoury_melee_attack_rate"] = {
					title_key = "3k_dlc07_captains_melee_attack_rate_title",
					icon_path = "ui/skins/default/3k_dlc07_captain_regular_bonus_icon_melee_attack_rate.png",
					description_key = "3k_dlc07_captains_melee_attack_rate_description",
					unlock_condition_key = "3k_dlc07_cao_cao_schemes_dummy_04_unlock_condition",
					effect_bundle_key = "3k_dlc07_captains_armoury_melee_attack_rate",
					cost = 30,
					is_elite = false,
					is_faction_wide = false,
				},	
			},
		},
		["tier_2"] = 
		{
			entry_threshold = 60,
			tier_icon_path = "ui/skins/default/3k_dlc07_captains_pooled_resource_tier_icon_2.png";
			["item_list"] = 
			{
				["3k_dlc07_captains_armoury_unit_training"] = {
					title_key = "3k_dlc07_captains_armoury_unit_training_title",
					icon_path = "ui/skins/default/3k_dlc07_captain_elite_bonus_icon_training.png",
					description_key = "3k_dlc07_captains_armoury_unit_training_description",
					unlock_condition_key = "3k_dlc07_cao_cao_schemes_dummy_04_unlock_condition",
					effect_bundle_key = "3k_dlc07_captains_armoury_unit_training",
					cost = 60,
					is_elite = true,
					is_faction_wide = false,
				},
				["3k_dlc07_captains_armoury_armour_base"] = {
					title_key = "3k_dlc07_captains_armour_base_title",
					icon_path = "ui/skins/default/3k_dlc07_captain_regular_bonus_icon_armour_base.png",
					description_key = "3k_dlc07_captains_armour_base_description",
					unlock_condition_key = "3k_dlc07_cao_cao_schemes_dummy_04_unlock_condition",
					effect_bundle_key = "3k_dlc07_captains_armoury_armour_base",
					cost = 60,
					is_elite = false,
					is_faction_wide = false,
				},
				["3k_dlc07_captains_armoury_attack_range"] = {
					title_key = "3k_dlc07_captains_attack_range_title",
					icon_path = "ui/skins/default/3k_dlc07_captain_regular_bonus_icon_range.png",
					description_key = "3k_dlc07_captains_attack_range_description",
					unlock_condition_key = "3k_dlc07_cao_cao_schemes_dummy_04_unlock_condition",
					effect_bundle_key = "3k_dlc07_captains_armoury_attack_range",
					cost = 60,
					is_elite = false,
					is_faction_wide = false,
				},
				["3k_dlc07_captains_armoury_caltrops"] = {
					title_key = "3k_dlc07_captains_caltrops_title",
					icon_path = "ui/skins/default/3k_dlc07_captain_regular_bonus_icon_caltrops.png",
					description_key = "3k_dlc07_captains_caltrops_description",
					unlock_condition_key = "3k_dlc07_cao_cao_schemes_dummy_04_unlock_condition",
					effect_bundle_key = "3k_dlc07_captains_armoury_caltrops",
					cost = 60,
					is_elite = false,
					is_faction_wide = false,
				},
				["3k_dlc07_captains_armoury_flaming_shot"] = {
					title_key = "3k_dlc07_captains_flaming_shot_title",
					icon_path = "ui/skins/default/3k_dlc07_captain_regular_bonus_icon_flame_shot.png",
					description_key = "3k_dlc07_captains_flaming_shot_description",
					unlock_condition_key = "3k_dlc07_cao_cao_schemes_dummy_04_unlock_condition",
					effect_bundle_key = "3k_dlc07_captains_armoury_flaming_shot",
					cost = 60,
					is_elite = false,
					is_faction_wide = false,
				},
			},
		},
		["tier_3"] = 
		{
			entry_threshold = 100,
			tier_icon_path = "ui/skins/default/3k_dlc07_captains_pooled_resource_tier_icon_3.png";
			["item_list"] = 
			{
				["3k_dlc07_captains_armoury_enemy_territory_replenish"] = {
					title_key = "3k_dlc07_captains_armoury_enemy_territory_replenish_title",
					icon_path = "ui/skins/default/3k_dlc07_captain_elite_bonus_icon_replenish.png",
					description_key = "3k_dlc07_captains_armoury_enemy_territory_replenish_description",
					unlock_condition_key = "3k_dlc07_cao_cao_schemes_dummy_04_unlock_condition",
					effect_bundle_key = "3k_dlc07_captains_armoury_enemy_territory_replenish",
					cost = 100,
					is_elite = true,
					is_faction_wide = false,
				},
				["3k_dlc07_captains_armoury_enemy_territory_supplies"] = {
					title_key = "3k_dlc07_captains_armoury_enemy_territory_supplies_title",
					icon_path = "ui/skins/default/3k_dlc07_captain_elite_bonus_icon_supply_loss.png",
					description_key = "3k_dlc07_captains_armoury_enemy_territory_supplies_description",
					unlock_condition_key = "3k_dlc07_cao_cao_schemes_dummy_04_unlock_condition",
					effect_bundle_key = "3k_dlc07_captains_armoury_enemy_territory_supplies",
					cost = 100,
					is_elite = true,
					is_faction_wide = false,
				},
				["3k_dlc07_captains_armoury_melee_evasion"] = {
					title_key = "3k_dlc07_captains_melee_evasion_title",
					icon_path = "ui/skins/default/3k_dlc07_captain_regular_bonus_icon_melee_evasion_base.png",
					description_key = "3k_dlc07_captains_melee_evasion_description",
					unlock_condition_key = "3k_dlc07_cao_cao_schemes_dummy_04_unlock_condition",
					effect_bundle_key = "3k_dlc07_captains_armoury_melee_evasion",
					cost = 100,
					is_elite = false,
					is_faction_wide = false,
				},
				["3k_dlc07_captains_armoury_morale"] = {
					title_key = "3k_dlc07_captains_morale_title",
					icon_path = "ui/skins/default/3k_dlc07_captain_regular_bonus_icon_morale.png",
					description_key = "3k_dlc07_captains_morale_description",
					unlock_condition_key = "3k_dlc07_cao_cao_schemes_dummy_04_unlock_condition",
					effect_bundle_key = "3k_dlc07_captains_armoury_morale",
					cost = 100,
					is_elite = false,
					is_faction_wide = false,
				},
				["3k_dlc07_captains_armoury_poison_shot"] = {
					title_key = "3k_dlc07_captains_poison_shot_title",
					icon_path = "ui/skins/default/3k_dlc07_captain_regular_bonus_icon_poison_shot.png",
					description_key = "3k_dlc07_captains_poison_shot_description",
					unlock_condition_key = "3k_dlc07_cao_cao_schemes_dummy_04_unlock_condition",
					effect_bundle_key = "3k_dlc07_captains_armoury_poison_shot",
					cost = 100,
					is_elite = false,
					is_faction_wide = false,
				},
				["3k_dlc07_captains_armoury_ranged_ammunition"] = {
					title_key = "3k_dlc07_captains_ranged_ammunition_title",
					icon_path = "ui/skins/default/3k_dlc07_captain_regular_bonus_icon_ammunition.png",
					description_key = "3k_dlc07_captains_ranged_ammunition_description",
					unlock_condition_key = "3k_dlc07_cao_cao_schemes_dummy_04_unlock_condition",
					effect_bundle_key = "3k_dlc07_captains_armoury_ranged_ammunition",
					cost = 100,
					is_elite = false,
					is_faction_wide = false,
				},
				["3k_dlc07_captains_armoury_ranged_attack_rate"] = {
					title_key = "3k_dlc07_captains_ranged_attack_rate_title",
					icon_path = "ui/skins/default/3k_dlc07_captain_regular_bonus_icon_ranged_attack_rate.png",
					description_key = "3k_dlc07_captains_ranged_attack_rate_description",
					unlock_condition_key = "3k_dlc07_cao_cao_schemes_dummy_04_unlock_condition",
					effect_bundle_key = "3k_dlc07_captains_armoury_ranged_attack_rate",
					cost = 100,
					is_elite = false,
					is_faction_wide = false,
				},
			},
		},
		["tier_4"] = 
		{
			entry_threshold = 150,
			tier_icon_path = "ui/skins/default/3k_dlc07_captains_pooled_resource_tier_icon_4.png";
			["item_list"] = 
			{
				["3k_dlc07_captains_armoury_whitewater"] = {
					title_key = "3k_dlc07_captains_armoury_whitewater_title",
					icon_path = "ui/skins/default/3k_dlc07_captain_elite_bonus_icon_whitewater_ability.png",
					description_key = "3k_dlc07_captains_armoury_whitewater_description",
					unlock_condition_key = "3k_dlc07_cao_cao_schemes_dummy_04_unlock_condition",
					effect_bundle_key = "3k_dlc07_captains_armoury_whitewater",
					cost = 150,
					is_elite = true,
					is_faction_wide = false,
				},
				["3k_dlc07_captains_armoury_unbreakable"] = {
					title_key = "3k_dlc07_captains_armoury_unbreakable_title",
					icon_path = "ui/skins/default/3k_dlc07_captain_elite_bonus_icon_unbreakable_ability.png",
					description_key = "3k_dlc07_captains_armoury_unbreakable_description",
					unlock_condition_key = "3k_dlc07_cao_cao_schemes_dummy_04_unlock_condition",
					effect_bundle_key = "3k_dlc07_captains_armoury_unbreakable",
					cost = 150,
					is_elite = true,
					is_faction_wide = false,
				},
				["3k_dlc07_captains_armoury_ranged_damage_base"] = {
					title_key = "3k_dlc07_captains_ranged_damage_base_title",
					icon_path = "ui/skins/default/3k_dlc07_captain_regular_bonus_icon_ranged_damage_base.png",
					description_key = "3k_dlc07_captains_ranged_damage_base_description",
					unlock_condition_key = "3k_dlc07_cao_cao_schemes_dummy_04_unlock_condition",
					effect_bundle_key = "3k_dlc07_captains_armoury_ranged_damage_base",
					cost = 150,
					is_elite = false,
					is_faction_wide = false,
				},
				["3k_dlc07_captains_armoury_smoke_screen"] = {
					title_key = "3k_dlc07_captains_smoke_screen_title",
					icon_path = "ui/skins/default/3k_dlc07_captain_regular_bonus_icon_smoke_screen.png",
					description_key = "3k_dlc07_captains_smoke_screen_description",
					unlock_condition_key = "3k_dlc07_cao_cao_schemes_dummy_04_unlock_condition",
					effect_bundle_key = "3k_dlc07_captains_armoury_smoke_screen",
					cost = 150,
					is_elite = false,
					is_faction_wide = false,
				},
				["3k_dlc07_captains_armoury_speed"] = {
					title_key = "3k_dlc07_captains_speed_title",
					icon_path = "ui/skins/default/3k_dlc07_captain_regular_bonus_icon_speed.png",
					description_key = "3k_dlc07_captains_speed_description",
					unlock_condition_key = "3k_dlc07_cao_cao_schemes_dummy_04_unlock_condition",
					effect_bundle_key = "3k_dlc07_captains_armoury_speed",
					cost = 150,
					is_elite = false,
					is_faction_wide = false,
				},
				["3k_dlc07_captains_armoury_stalk"] = {
					title_key = "3k_dlc07_captains_stalk_title",
					icon_path = "ui/skins/default/3k_dlc07_captain_regular_bonus_icon_stalk.png",
					description_key = "3k_dlc07_captains_stalk_description",
					unlock_condition_key = "3k_dlc07_cao_cao_schemes_dummy_04_unlock_condition",
					effect_bundle_key = "3k_dlc07_captains_armoury_stalk",
					cost = 150,
					is_elite = false,
					is_faction_wide = false,
				},
			},
		},
		["tier_5"] = 
		{
			entry_threshold = 300,
			tier_icon_path = "ui/skins/default/3k_dlc07_captains_pooled_resource_tier_icon_5.png";
			["item_list"] = 
			{
				["3k_dlc07_captains_armoury_ambush_battles"] = {
					title_key = "3k_dlc07_captains_armoury_ambush_battles_title",
					icon_path = "ui/skins/default/3k_dlc07_captain_elite_bonus_icon_ambush_battles.png",
					description_key = "3k_dlc07_captains_armoury_ambush_battles_description",
					unlock_condition_key = "3k_dlc07_cao_cao_schemes_dummy_04_unlock_condition",
					effect_bundle_key = "3k_dlc07_captains_armoury_ambush_battles",
					cost = 300,
					is_elite = true,
					is_faction_wide = false,
				},
				["3k_dlc07_captains_armoury_army_limit"] = {
					title_key = "3k_dlc07_captains_armoury_army_limit_title",
					icon_path = "ui/skins/default/3k_dlc07_captain_elite_bonus_icon_increase_army_limit.png",
					description_key = "3k_dlc07_captains_armoury_army_limit_description",
					unlock_condition_key = "3k_dlc07_cao_cao_schemes_dummy_04_unlock_condition",
					effect_bundle_key = "3k_dlc07_captains_armoury_army_limit",
					cost = 300,
					is_elite = true,
					is_faction_wide = true,
				},
				["3k_dlc07_captains_armoury_scare"] = {
					title_key = "3k_dlc07_captains_scare_title",
					icon_path = "ui/skins/default/3k_dlc07_captain_regular_bonus_icon_scare.png",
					description_key = "3k_dlc07_captains_scare_description",
					unlock_condition_key = "3k_dlc07_cao_cao_schemes_dummy_04_unlock_condition",
					effect_bundle_key = "3k_dlc07_captains_armoury_scare",
					cost = 300,
					is_elite = false,
					is_faction_wide = false,
				},
				["3k_dlc07_captains_armoury_ranged_block_chance"] = {
					title_key = "3k_dlc07_captains_ranged_block_chance_title",
					icon_path = "ui/skins/default/3k_dlc07_captain_regular_bonus_icon_ranged_block_chance.png",
					description_key = "3k_dlc07_captains_ranged_block_chance_description",
					unlock_condition_key = "3k_dlc07_cao_cao_schemes_dummy_04_unlock_condition",
					effect_bundle_key = "3k_dlc07_captains_armoury_ranged_block_chance",
					cost = 300,
					is_elite = false,
					is_faction_wide = false,
				},
			},
		},	
	};
}

-- #region Yuan Shao Captain Quests
local captain_unit_keys = {
	"3k_dlc07_unit_earth_northern_sabre_cavalry_captain",
	"3k_dlc07_unit_fire_northern_lancer_cavalry_captain",
	"3k_main_unit_earth_jian_cavalry_captain",
	"3k_main_unit_fire_lance_cavalry_captain",
	"3k_main_unit_fire_mercenary_cavalry_captain",
	"3k_dlc04_unit_metal_imperial_guard_captain",
	"3k_dlc06_unit_metal_nanman_warriors_captain",
	"3k_dlc07_unit_metal_northern_sabre_infantry_captain",
	"3k_dlc07_unit_wood_northern_ji_infantry_captain",
	"3k_dlc07_unit_wood_northern_spear_guard_captain",
	"3k_main_unit_metal_jian_infantry_captain",
	"3k_main_unit_metal_mercenary_infantry_captain",
	"3k_main_unit_wood_ji_infantry_captain",
	"3k_ytr_unit_metal_yellow_turban_warriors_captain",
	"3k_ytr_unit_wood_yellow_turban_spearmen_captain",
	"ep_unit_metal_dao_swordguard_captain",
	"3k_main_unit_water_archer_captain",
	"3k_main_unit_water_mercenary_archers_captain",
	"3k_ytr_unit_water_yellow_turban_archers_captain"
}

local armoury_bonus_AI_weighting_list = {
	{effect_key = "3k_dlc07_captains_armoury_melee_charge_bonus", weight = 100},
	{effect_key = "3k_dlc07_captains_armoury_melee_damage", weight = 100},
	{effect_key = "3k_dlc07_captains_armoury_melee_attack_rate", weight = 100},
	{effect_key = "3k_dlc07_captains_armoury_guerrilla_deployment", weight = 200},
	{effect_key = "3k_dlc07_captains_armoury_morale", weight = 100},
	{effect_key = "3k_dlc07_captains_armoury_armour_base", weight = 100},
	{effect_key = "3k_dlc07_captains_armoury_attack_range", weight = 100},
	{effect_key = "3k_dlc07_captains_armoury_enemy_territory_replenish", weight = 500},
	{effect_key = "3k_dlc07_captains_armoury_melee_evasion", weight = 100},
	{effect_key = "3k_dlc07_captains_armoury_ranged_attack_rate", weight = 100},
	{effect_key = "3k_dlc07_captains_armoury_unbreakable", weight = 500},
	{effect_key = "3k_dlc07_captains_armoury_ranged_damage_base", weight = 100},
	{effect_key = "3k_dlc07_captains_armoury_scare", weight = 100},
	{effect_key = "3k_dlc07_captains_armoury_army_limit", weight = 500},
	{effect_key = "3k_dlc07_captains_armoury_ranged_block_chance", weight = 100}
}

-- Table for CEO nodes to be used by the yuan_shao_captain_quest_node_change_listener to fire incidents whenever a node changes 
local captain_quest_nodes_to_incidents = {
	["3k_dlc07_ceo_factional_yuan_shao_captain_quest_combat_01"] = "3k_dlc07_incident_yuan_shao_captains_manoeuvre";
	["3k_dlc07_ceo_factional_yuan_shao_captain_quest_combat_02"] = "3k_dlc07_incident_yuan_shao_captains_manoeuvre";
	["3k_dlc07_ceo_factional_yuan_shao_captain_quest_combat_03"] = "3k_dlc07_incident_yuan_shao_captains_manoeuvre";
	["3k_dlc07_ceo_factional_yuan_shao_captain_quest_recruitment_01"] = "3k_dlc07_incident_yuan_shao_captains_enlistment";
	["3k_dlc07_ceo_factional_yuan_shao_captain_quest_recruitment_02"] = "3k_dlc07_incident_yuan_shao_captains_enlistment";
	["3k_dlc07_ceo_factional_yuan_shao_captain_quest_recruitment_03"] = "3k_dlc07_incident_yuan_shao_captains_enlistment";
	["3k_dlc07_ceo_factional_yuan_shao_captain_quest_victory_01"] = "3k_dlc07_incident_yuan_shao_captains_triumph";
	["3k_dlc07_ceo_factional_yuan_shao_captain_quest_victory_02"] = "3k_dlc07_incident_yuan_shao_captains_triumph";
	["3k_dlc07_ceo_factional_yuan_shao_captain_quest_victory_03"] = "3k_dlc07_incident_yuan_shao_captains_triumph";
}

local function are_captain_quests_enabled()
	return cm:query_faction(yuan_shao_faction_key):has_effect_bundle("3k_dlc07_captains_armoury_captain_missions_dummy");
end;

local function set_captain_quests_enabled(is_enabled)
	if is_enabled then
		cm:modify_faction(yuan_shao_faction_key):apply_effect_bundle("3k_dlc07_captains_armoury_captain_missions_dummy",-1);
	elseif are_captain_quests_enabled() then
		cm:modify_faction(yuan_shao_faction_key):remove_effect_bundle("3k_dlc07_captains_armoury_captain_missions_dummy");
	end
end;

local function ys_was_winner_last_battle(log_entry)
	return log_entry:winning_factions():any_of(function(faction) return faction:name() == yuan_shao_faction_key end);
end;

local function ys_had_captains_last_battle(log_entry)
	return log_entry:winning_captains():any_of(function(unit_log) return unit_log:unit():faction():name() == yuan_shao_faction_key end)
		or log_entry:losing_captains():any_of(function(unit_log) return unit_log:unit():faction():name() == yuan_shao_faction_key end)
end;

local function ys_captain_kills_in_last_battle(log_entry)
	local count = 0;

	log_entry:winning_captains():filter(function(unit_log) return unit_log:unit():faction():name() == yuan_shao_faction_key end):foreach(function(unit_log) count = count + unit_log:personal_kills() end);
	log_entry:losing_captains():filter(function(unit_log) return unit_log:unit():faction():name() == yuan_shao_faction_key end):foreach(function(unit_log) count = count + unit_log:personal_kills() end);
	
	return count;
end;

local captain_quest_ceo_category = "3k_dlc07_ceo_category_factional_yuan_shao";
local captain_quest_data = {
	{ceo_key = "3k_dlc07_ceo_factional_yuan_shao_captain_quest_victory", condition_event = "CampaignBattleLoggedEvent", points_on_trigger = 1,
		condition_function = function(context) 
			return ys_was_winner_last_battle(context:log_entry()) and ys_had_captains_last_battle(context:log_entry());
		end};
	{ceo_key = "3k_dlc07_ceo_factional_yuan_shao_captain_quest_recruitment", condition_event = "MilitaryForceRetinueCreated", points_on_trigger = 1,
		condition_function = function(context) 
			local retinue = context:military_force_retinue_created();
			return retinue:owning_military_force():faction():name() == yuan_shao_faction_key
				and retinue:is_mercenary_retinue()
		end};
	{ceo_key = "3k_dlc07_ceo_factional_yuan_shao_captain_quest_combat", condition_event = "CampaignBattleLoggedEvent",
		points_on_trigger = function(context)
			return ys_captain_kills_in_last_battle(context:log_entry()) 
		end,
		condition_function = function(context) 
			return ys_had_captains_last_battle(context:log_entry());
		end};
}

local function validate_captain_quest_data()
	local is_error = false;

	local all_captain_ceos = cm:query_faction(yuan_shao_faction_key):ceo_management():all_ceos_for_category(captain_quest_ceo_category)

	for i, quest_data in ipairs(captain_quest_data) do
		if not is_string(quest_data.ceo_key) then
			script_error(string.format("ERROR: validate_captain_quest_data(): ceo_key for item %i is not a string.", i));
			is_error = true;
		end;

		if not all_captain_ceos:any_of(function(ceo) return ceo:ceo_data_key() == quest_data.ceo_key end) then
			script_error(string.format("ERROR: validate_captain_quest_data(): ceo_key [%s] for item %i is not a valid ceo key.", quest_data.ceo_key, i));
			is_error = true;
		end;

		if not is_string(quest_data.condition_event) then
			script_error(string.format("ERROR: validate_captain_quest_data(): condition_event key for item %i is not a string.", i));
			is_error = true;
		end;

		if quest_data.condition_function and not is_function(quest_data.condition_function) then
			script_error(string.format("ERROR: validate_captain_quest_data(): condition_function key for item %i is not a function.", i));
			is_error = true;
		end;

		if not is_function(quest_data.points_on_trigger) and not is_number(quest_data.points_on_trigger) then
			script_error(string.format("ERROR: validate_captain_quest_data(): points_on_trigger key for item %i is not a number or function which returns a number.", i));
			is_error = true;
		end;	
	end;

	if is_error then
		script_error("ERROR: validate_captain_quest_data(): Validation failed, exiting system.");
		return false;
	end;

	return true;
end;

local function captain_quest_initialise()

	-- Example: trigger_cli_debug_event toggle_captain_quests()
	core:add_cli_listener("toggle_captain_quests", 
		function() 
			if are_captain_quests_enabled() then
				set_captain_quests_enabled(false)
			else
				set_captain_quests_enabled(true)
			end;

			output("Toggled Captain Quests - Enabled = " .. tostring(are_captain_quests_enabled()));
		end 
	);

	-- Exit if we're loading a game without these CEOs at all (as it was made before the change).
	if cm:query_faction(yuan_shao_faction_key):ceo_management():all_ceos_for_category(captain_quest_ceo_category):is_empty() then
		output("captain_quest_initialise() not loading captain quest system as this is an older save.")
		return;
	end;

	if validate_captain_quest_data() then

		for i, quest_data in ipairs(captain_quest_data) do
			core:add_listener(
				"yuan_shao_captain_quest_listener",
				quest_data.condition_event,
				function(context)
					if not are_captain_quests_enabled() then 
						return false 
					elseif quest_data.condition_function then 
						return quest_data.condition_function(context)
					end;
	
					return true;
				end,
				function(context)
					local pts = quest_data.points_on_trigger;

					if is_function(quest_data.points_on_trigger) then
						pts = quest_data.points_on_trigger(context);
					end;

					if not is_number(pts) then pts = 1 end;
					
					cm:modify_faction(yuan_shao_faction_key):ceo_management():change_points_of_ceos(quest_data.ceo_key, pts);
				end,
				true
			);
		end;
		
-- Pass faction key and current node as context, then fire corresponding incidents by current node key
core:add_listener(
	"yuan_shao_captain_quest_node_change_listener",
	"FactionCeoNodeChanged",
	function(context)
		return context:faction():name() == yuan_shao_faction_key and
		context:faction():is_human() and 
		string.match(context:ceo():current_node_key(), "captain_quest");
	end,
	function(context)
		output("dlc07_faction_yuan_shao_captain_armoury.lua: ceo_data key is: "..context:ceo():ceo_data_key().." and current_node_key is: "..context:ceo():current_node_key())
		if captain_quest_nodes_to_incidents[context:ceo():current_node_key()] then
			cm:trigger_incident(yuan_shao_faction_key, captain_quest_nodes_to_incidents[context:ceo():current_node_key()], true);
		end
	end,
	true
)
	end;
end
-- #endregion Yuan Shao Captain Quests

function yuan_shao_captain_armoury:lineage_pooled_resource_transaction(amount)
	local pooled_resource = cm:query_faction(yuan_shao_faction_key):pooled_resources():resource(yuan_shao_pr_key)
	if pooled_resource:is_null_interface() then
		script_error(string.format("Failed to find pooled resource for Yuan shao"))
		return false
	end

	local factor_key = "3k_main_pooled_factor_lineage"
	cm:modify_model():get_modify_pooled_resource(pooled_resource):apply_transaction_to_factor(factor_key, -amount);

end

--- @function new_game
--- @desc Fires when the player starts a new campaign. Used to initialise things just once (usually saved values).
--- @r nil
function yuan_shao_captain_armoury:new_game()
	set_captain_quests_enabled(true);
end;

--- @function initialise
--- @desc Fires every campaign (after new_game if it's a new campaign). Sets things up such as listeners and the like.
--- @r nil
function yuan_shao_captain_armoury:initialise()

	self:setup_listeners()

	if not cm:query_faction(yuan_shao_faction_key):is_human() then
		self:setup_AI_listeners();
	end

	-- Remove a Romance only ability when playing in Records mode, and replace it with a Records-friendly skill
	if cm:query_model():campaign_game_mode() == "historical" then
		yuan_shao_captain_armoury.shop_items_data["tier_4"]["item_list"]["3k_dlc07_captains_armoury_whitewater"].title_key = "3k_main_tutorial_mode_prebattle_prediction_title"
		yuan_shao_captain_armoury.shop_items_data["tier_4"]["item_list"]["3k_dlc07_captains_armoury_whitewater"].effect_bundle_key = "3k_dlc07_captains_armoury_whitewater_records"
		yuan_shao_captain_armoury.shop_items_data["tier_4"]["item_list"]["3k_dlc07_captains_armoury_whitewater"].icon_path = "ui/skins/default/reinforcement_range.png"
	end	

	effect.set_context_value("dlc07_yuan_shao_shop_items", self.shop_items_data)

	captain_quest_initialise()
end;

function yuan_shao_captain_armoury:setup_listeners()

		--Listener for scheme selection from UI panel
	core:add_listener(
		"yuan_shao_shop_listener",		--UID
		"ModelScriptNotificationEvent", --Event
		function(model_script_notification_event) 				--Conditions for firing
			if not string.find(model_script_notification_event:event_id(), "yuan_shao_item_purchased") then
                return false;
            end

            return true;
		end,
		function(model_script_notification_event)				--Function to fire
			--Acquire data from UI
			local item_tier_key = effect.get_context_value("CcoScriptObject", "item_tier_key", "StringValue")
			local item_key = effect.get_context_value("CcoScriptObject", "item_key", "StringValue")
			local target_type = effect.get_context_value("CcoScriptObject", "item_target_type", "StringValue")
			local target_key = tonumber(effect.get_context_value("CcoScriptObject", "item_target_key", "StringValue"))
			
			output("****** SHOP ITEM INFO ******")
			output(string.format("Selected Item - %s", item_key))	
			output(string.format("Target Type - %s", target_type))
			output(string.format("Target ID - %s", target_key))
			
			--Find the selected item
			local selected_item = self.shop_items_data[item_tier_key]["item_list"][item_key]
			if selected_item == nil then
				script_error("Failed to find chosen shop item, this should NEVER happen! Likely some data is missing from UI -> Script comms")
			end

			--The UI always sets the target key to be the CQI of the retinue
			--Find retinue from the CQI
			local query_retinue = cm:query_military_force_retinue(target_key) 
			if query_retinue == nil or query_retinue:is_null_interface() then
				script_error("Failed to find retinue from CQI, this should NEVER happen!")
			end

			--If the target is the retinue then just apply the effect bundle 
			if target_type == "retinue" then
				cm:modify_military_force_retinue(query_retinue):apply_effect_bundle(
					selected_item.effect_bundle_key,
					-1
				)				
			--If the faction is the target, like the cpt recruitment, we're going to have to do some more messing around	
			elseif target_type == "faction" then
				local owning_faction = query_retinue:owning_military_force():faction()
				if owning_faction == nil or owning_faction:is_null_interface() then
					script_error("Failed to find owning faction for retinue, how could this happen!?")
				end

				--Now that we have the faction, apply the effect bundle
				cm:modify_faction(owning_faction):apply_effect_bundle(
					selected_item.effect_bundle_key,
					-1
				)

			else
				script_error("Effect Bundle target is not applicable in this case and cannot be applied!")
				return false
			end
			
			if selected_item.cost > 0 then
				self:lineage_pooled_resource_transaction(selected_item.cost)
			else
				-- The UI panel requires a 
				self:lineage_pooled_resource_transaction(1)
				self:lineage_pooled_resource_transaction(-1)
			end;
		end,
		true	-- Is Persistent?
	)
	
end;

function yuan_shao_captain_armoury:setup_AI_listeners()

	local function yuan_shao_lineage_amount()
		if cm:query_faction(yuan_shao_faction_key):pooled_resources():resource(yuan_shao_pr_key):is_null_interface() then
			return 0
		end
		return cm:query_faction(yuan_shao_faction_key):pooled_resources():resource(yuan_shao_pr_key):value()
	end

	--ADD POOLED RESOURCE PER TURN
	core:add_listener("yuan_shao_ai_add_pooled_resource",
	"FactionTurnStart",
	function(context)
		return context:faction():name() == yuan_shao_faction_key and not context:faction():is_human()
	end,
	function(context)
		--is negative because the function has been written to subtract for some reason. negative with negative = positive
		self:lineage_pooled_resource_transaction(-AI_pooled_resource_generation_amount)
	end,
	true
	)

	--APPLY ARMOURY BONUS TO RETINUE
	core:add_listener("yuan_shao_ai_bonus_for_retinue",
	"FactionTurnStart",
	function(context)
		return context:faction():name() == yuan_shao_faction_key and not context:faction():is_human() and yuan_shao_lineage_amount() > 1500
	end,
	function(context)
		local merc_retinues = {}

		--gets all mercenary retinues
		for i = 0, context:faction():military_force_list():num_items() -1 do
			for j = 0, context:faction():military_force_list():item_at(i):military_force_retinues():num_items() - 1 do
				local retinue = context:faction():military_force_list():item_at(i):military_force_retinues():item_at(j)
				
				if retinue:is_mercenary_retinue() then
					table.insert(merc_retinues, retinue:command_queue_index())
				end
			end
		end

		local retinue_max_points = -100;
		local best_retinue;

		--iterates on mercenary retinues
		for i, retinue_cqi in ipairs(merc_retinues) do
			local retinue = cm:query_military_force_retinue(retinue_cqi)
			local retinue_current_points = -100;

			--gives extra points if the commanding charcter of this retinue is an important character in the faction
			if not retinue:owning_military_force():general_character():is_null_interface() then
				local character = retinue:owning_military_force():general_character()
				
				if string.find(character:generation_template_key(), "yuan_shao") then
					retinue_current_points = retinue_current_points + 250;

				elseif string.find(character:generation_template_key(), "yuan_tan") then
					retinue_current_points = retinue_current_points + 200;

				elseif string.find(character:generation_template_key(), "lady_liu_limin") then
					retinue_current_points = retinue_current_points + 150;

				elseif string.find(character:generation_template_key(), "yan_liang") then
					retinue_current_points = retinue_current_points + 150;

				elseif string.find(character:generation_template_key(), "xu_you") then
					retinue_current_points = retinue_current_points + 150;

				end
			end

			--gives extra points if the retinue is in, or adjacent to, a region they're at war with.
			if not retinue:owning_military_force():region():is_null_interface() then
				local region = retinue:owning_military_force():region()

				if context:faction():name() ~= region:owning_faction():name()
				 and not region:owning_faction():is_null_interface() and not region:owning_faction():is_dead()
				 and not region:owning_faction():name() == "rebels" and not context:faction():name() == "rebels" then

					if diplomacy_manager:is_at_war_with(context:faction():name(), region:owning_faction():name()) then
						retinue_current_points = retinue_current_points + 400;
					end

				end

				for i = 0, region:adjacent_region_list():num_items() -1 do
					local adjacent_region = region:adjacent_region_list():item_at(i)
					
					if context:faction():name() ~= region:owning_faction():name()
					 and not region:owning_faction():is_null_interface() and not region:owning_faction():is_dead()
					 and not region:owning_faction():name() == "rebels" and not context:faction():name() == "rebels" then

						if diplomacy_manager:is_at_war_with(context:faction():name(), adjacent_region:owning_faction():name()) then
							retinue_current_points = retinue_current_points + 180;
							break;
						end
					end
				end
			end

			--removes a few points if this retinue already has some armoury bonuses
			for tier, tier_data in pairs(self.shop_items_data) do
				for item_list, item_data in pairs(tier_data.item_list) do
					
					if retinue:has_effect_bundle(item_data.effect_bundle_key) then
						retinue_current_points = retinue_current_points - 50;
					end

				end
			end

			if retinue_current_points > retinue_max_points then
				retinue_max_points = retinue_current_points
				best_retinue = retinue:command_queue_index()
			end

		end

		--ADDS AN EFFECT BUNDLE TO TARGET RETINUE
		if best_retinue and is_number(best_retinue) then

			local effect_bundle;

			local filtered_effects_list = armoury_bonus_AI_weighting_list

			--filters the list of bonuses available down to only the ones we can afford
			for i, filtered_effect_data in ipairs(filtered_effects_list) do
				local effect_cost
				for tier, tier_data in pairs(self.shop_items_data) do
					if tier_data["item_list"][filtered_effect_data.effect_key] then
						effect_cost = tier_data["item_list"][filtered_effect_data.effect_key].cost
					end
				end
				if not effect_cost then
					script_error("ERROR: effect_cost in yuan_shao_ai_bonus_for_retinue in dlc07_faction_yuan_shao_captain_armoury is nil. This shouldn't happen!\nLast time this happened, it was because the table data had been altered significantly!")
				elseif effect_cost > yuan_shao_lineage_amount() then
					table.remove(filtered_effects_list, i)
				end
			end

			retinue = cm:query_military_force_retinue(best_retinue)

			--filters the list of bonuses available down to only ones this retinue doesn't have already
			for i, bonus_data in ipairs(filtered_effects_list) do
				if retinue:has_effect_bundle(bonus_data.effect_key) then
					table.remove(filtered_effects_list,i)
				end
			end

			--get a weighted random number, use that as our effect
			local total_weight = 0
			for i, bonus_data in ipairs(filtered_effects_list) do
				total_weight = total_weight + bonus_data.weight
			end

			--gets a valid key from our weighted list
			local chosen_weight = cm:random_int(0, total_weight)
			for i, bonus_data in ipairs(filtered_effects_list) do
				if chosen_weight < bonus_data.weight then
					effect_bundle = bonus_data.effect_key
					break;
				end
				chosen_weight = chosen_weight - bonus_data.weight
			end

			--applies effect bundle to retinue
			if effect_bundle and is_string(effect_bundle) then
				cm:modify_military_force_retinue(retinue):apply_effect_bundle(effect_bundle, -1)
				
				for tier, tier_data in pairs(self.shop_items_data) do
					if tier_data["item_list"][effect_bundle] then
						self:lineage_pooled_resource_transaction(tier_data["item_list"][effect_bundle].cost)
					end
				end
			end
		end

	end,
	true
	)
end;

cm:add_first_tick_callback_new(function() yuan_shao_captain_armoury:new_game() end); -- Fires on the first tick of a New Campaign
cm:add_first_tick_callback(function() yuan_shao_captain_armoury:initialise() end); -- fires on the first tick of every game loaded.


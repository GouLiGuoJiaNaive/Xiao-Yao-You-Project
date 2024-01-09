---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------
----- Name:			3k_campaign_faction_council_world_data_queries.lua
----- Description: 	Queries game state to test if specific scenarios 
-----				are valid. Generates an issues list which is passed
-----				back to the faction council valid suggestions for
-----				sorting and passing to the UI.
---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------

--***********************************************************************************************************
--***********************************************************************************************************
-- MAGIC NUMEBERS

local force_low_morale_threshold = 30 -- used in determining if a force is low on supplies
local minimum_number_of_low_morale_forces = 1 -- used to ignore edge cases when checking for issues relating to low morale forces
local low_force_to_region_ratio_threshold = 4 -- ratio of forces to regions, if faction has below this number we assume they are unable to defend their holdings
local force_low_tier_unit_ratio_threshold = 0.5 -- used as the maximum percentage makeup of force lists with tier 1 units
local min_number_of_armies_in_hostile_territory = 2 -- used to eliminate edge cases when looking for faction deploying its armies aggressively
local minimum_forces_in_neutral_territory_without_siege_engines = 2 -- minimum number of armies present by source faction required to be in non-friendly territory
local faction_forces_unit_role_bias_ratio_threshold = 0.35 -- Ratio of units in faction for unit ratios. Counted against all units in faction's forces. 
local force_low_unit_experience_threshold = 3 -- used in checking for a force with a large amount of low experience units
local minimum_unequipped_ceo_threshold = 5 -- desired minimum number of spare ancillaries in the bank
local low_character_loyalty_threshold = 30 -- maximum satisfaction value for which we consider a character to be low loyalty
local low_characater_rank_threshold = 4 -- rank below which we consider a character to be low level
local high_character_loyalty_threshold = 50 -- character loyalty value above which they are considered to be high satisfaction
local high_characater_rank_threshold = 6 -- minimum rank above which a character is considered to be high level
local low_public_order_threshold = -20 -- maximum value below which a region is considered to have low public order
local capital_region_infrastructure_underdeveloped_threshold = 2 -- building superchain level below which a building is considered underdeveloped
local capital_minimum_building_count_threshold = 3 -- minimum number of buildings in a capital region required for it to be considered developed
local capital_region_infrastructure_developed_threshold = 12 -- cumulative count of region slot building levels which make a region "developed"
local low_unit_strength_threshold = 10 -- value below which a unit is assumed to be damaged
local pooled_resource_low_fill_percentage_threshold = 0.3 -- value below which the percentage fill of a pooled resource is considered to be low
local population_low_fill_percentage_threshold = 60 -- population fill level below which a region is considered to be underpopulated
local regions_low_population_level_threshold = 3 -- number of regions across an entire faction above which the faction is considered to be underpopulated
local faction_low_diplomatic_relationship_threshold = 50 -- diplomatic standing value below which factions their relationship considered to be poor
local low_food_food_income_threshold = 6 -- having ood income less than this value we deem the faction to have a lowe surplus
local large_faction_region_count = 5 -- number of regions required by a faction for them to be considered larger than average
local economic_infrastructure_bias_ratio_threshold = 0.2; -- the percentage of economic buildings of a specific type faction wide required to be considered the primary economic factor
local invasion_faction_key = "3k_dlc04_faction_rebels"; -- the faction for which we spawn rogue armies from the faction council
local max_invasion_armies_in_area = 2; -- maximum number of rogue armies we allow in each corner of the map

--***********************************************************************************************************
--***********************************************************************************************************
-- DB KEY LISTS
local ceo_sets_list = {
	item_set_vital_spirit = {"3k_main_ancillary_follower_hua_tuo", "3k_main_ancillary_accessory_hua_tuos_manual"},
	item_set_the_wall = {"3k_main_ancillary_armour_heavy_armour_wood_extraordinary",	"3k_main_ancillary_weapon_halberd_exceptional"},
	item_set_the_fortress = {"3k_main_ancillary_weapon_halberd_unique", "3k_main_ancillary_armour_heavy_armour_wood_unique",},
	item_set_the_builder = {"3k_main_ancillary_accessory_jade_snake", "3k_main_ancillary_follower_builder"},
	item_set_tamer_of_the_earth = {"3k_main_ancillary_accessory_book_of_mountains_and_seas", "3k_main_ancillary_follower_elite_trainer"},
	item_set_tacticians_design = {"3k_main_ancillary_armour_shi_xies_armour_unique", "3k_main_ancillary_weapon_ceremonial_sword_exceptional"},
	item_set_spirit_of_agriculture = {"3k_main_ancillary_accessory_jade_sickle", "3k_main_ancillary_follower_provincial_advisor"},
	item_set_shadow_runner = {"3k_main_ancillary_mount_shadow_runner", "3k_main_ancillary_accessory_jade_horseman"},
	item_set_scholar_of_the_future = {"3k_main_ancillary_follower_scholar", "3k_main_ancillary_accessory_book_of_changes"},
	item_set_raiment_of_nobility = {"3k_main_ancillary_armour_light_armour_earth_extraordinary", "3k_main_ancillary_weapon_one_handed_axe_exceptional"},
	item_set_preservation = {"3k_main_ancillary_follower_master_craftsman", "3k_main_ancillary_accessory_ceremonial_stone_axe"},
	item_set_perfection = {"3k_main_ancillary_armour_medium_armour_metal_unique", "3k_main_ancillary_weapon_double_edged_sword_unique"},
	item_set_peoples_justice = {"3k_main_ancillary_follower_inspector", "3k_main_ancillary_accessory_the_methods_of_the_sima"},
	item_set_orator = {"3k_main_ancillary_accessory_classic_of_filial_piety", "3k_main_ancillary_follower_philosopher"},
	item_set_natures_guidance = {"3k_main_ancillary_follower_astronomer", "3k_main_ancillary_accessory_water_clock"},
	item_set_monopoly = {"3k_main_ancillary_follower_merchant", "3k_main_ancillary_accessory_the_nine_chapters_on_the_mathematical_art"},
	item_set_mobiliser = {"3k_main_ancillary_follower_military_expert", "3k_main_ancillary_accessory_wuzi"},
	item_set_military_law = {"3k_main_ancillary_follower_military_expert", "3k_main_ancillary_accessory_wei_liaozi"},
	item_set_martial_law = {"3k_main_ancillary_accessory_discourses_of_the_states", "3k_main_ancillary_follower_law_enforcer"},
	item_set_mandate_of_war = {"3k_main_ancillary_armour_strategist_light_armour_water_unique", "3k_main_ancillary_weapon_ceremonial_sword_unique"},
	item_set_lord_of_fire = {"3k_main_ancillary_weapon_two_handed_spear_exceptional",	"3k_main_ancillary_armour_medium_armour_fire_extraordinary"},
	item_set_knowledge_of_heaven = {"3k_main_ancillary_follower_diviner", "3k_main_ancillary_accessory_celestial_sphere"},
	item_set_hidden_stratagem = {"3k_main_ancillary_follower_military_instructor", "3k_main_ancillary_accessory_six_secret_teachings"},
	item_set_heavenly_flight = {"3k_main_ancillary_follower_tycoon", "3k_main_ancillary_accessory_jade_archer"},
	item_set_harvester_of_tomorrow = {"3k_main_ancillary_follower_diviner", "3k_main_ancillary_accessory_clay_dog"},
	item_set_hand_of_the_king = {"3k_main_ancillary_follower_provincial_auditor", "3k_main_ancillary_accessory_the_three_strategies_of_the_duke_of_the_yellow_rock"},
	item_set_garb_of_the_first_sage = {"3k_main_ancillary_weapon_dual_swords_unique", "3k_main_ancillary_armour_light_armour_earth_unique"},
	item_set_fireborn = {"3k_main_ancillary_weapon_two_handed_spear_unique","3k_main_ancillary_armour_medium_armour_fire_unique"},
	item_set_expert_of_workshops = {"3k_main_ancillary_accessory_stone_monkey","3k_main_ancillary_follower_foreman"},
	item_set_expert_of_the_palace = {"3k_main_ancillary_follower_foreman","3k_main_ancillary_accessory_stone_rooster"},
	item_set_expert_of_farms = {"3k_main_ancillary_follower_foreman","3k_main_ancillary_accessory_clay_ox"},
	item_set_expert_of_barracks = {"3k_main_ancillary_accessory_clay_warrior","3k_main_ancillary_follower_foreman"},
	item_set_expert_of_academies = {"3k_main_ancillary_follower_foreman","3k_main_ancillary_accessory_clay_cup"},
	item_set_essence_of_sun_tzu = {"3k_main_ancillary_accessory_art_of_war","3k_main_ancillary_follower_military_instructor"},
	item_set_enginesmith = {"3k_main_ancillary_follower_forge_master","3k_main_ancillary_accessory_mozi"},
	item_set_earthwatcher = {"3k_main_ancillary_follower_professor","3k_main_ancillary_accessory_earthquake_watching_device"},
	item_set_dragons_storm = {"3k_main_ancillary_weapon_composite_bow_unique","3k_main_ancillary_armour_strategist_light_armour_water_unique"},
	item_set_constellation = {"3k_main_ancillary_armour_medium_armour_metal_extraordinary","3k_main_ancillary_weapon_double_edged_sword_exceptional"},
	item_set_commander_of_the_masses = {"3k_main_ancillary_follower_jade_sculptor","3k_main_ancillary_accessory_rites_of_zhou"},
	item_set_celestial_fury = {"3k_main_ancillary_weapon_composite_bow_exceptional","3k_main_ancillary_armour_shi_xies_armour_unique"},
	item_set_bookkeeper = {"3k_main_ancillary_follower_local_administrator","3k_main_ancillary_accessory_stone_rat"},
	item_set_ancient_sight = {"3k_main_ancillary_accessory_book_of_documents","3k_main_ancillary_follower_confucian_sage"}
}

local militia_unit_keys = { -- all han chinese militia unit keys
	"3k_main_unit_earth_mounted_sabre_militia",
	"3k_main_unit_fire_mounted_lancer_militia",
	"3k_main_unit_metal_sabre_militia",
	"3k_main_unit_water_archer_militia",
	"3k_main_unit_wood_ji_militia",
	"ep_dyn_unit_water_archer_militia"
}

local siege_engine_unit_keys = { -- all han chinese siege engine unit keys
"3k_main_unit_water_trebuchet",
"3k_dlc04_unit_water_multiple_bolt_crossbow",
"3k_dlc06_unit_water_juggernaut"
}

local commercial_building_chain_keys_list = { -- all commercial building keys
"3k_district_market_harbour",
"3k_district_market_inn",
"3k_district_market_inn_liu_biao",
"3k_district_market_school",
"3k_district_market_school_kong_rong",
"3k_district_market_trade",
"3k_district_market_trade_port",
"3k_resource_water_salt",
"3k_resource_water_silk",
"3k_resource_water_spice",
"3k_resource_water_trading_port",
"3k_resource_wood_tea"
}

local peasantry_building_chain_keys_list = { -- all commercial building keys
"3k_district_government_rural_administration",
"3k_district_government_rural_administration_han",
"3k_district_residential_housing",
"3k_district_residential_logistics",
"3k_district_residential_markets",
"3k_resource_fire_northern_horses",
"3k_resource_metal_craftsmen_animal",
"3k_resource_wood_farms_grain",
"3k_resource_wood_farms_grain_agricultural_garrison",
"3k_resource_wood_farms_rice",
"3k_resource_wood_fish",
"3k_resource_wood_livestock",
"3k_resource_wood_lumber_bamboo",
"3k_resource_wood_lumber_pine",
"3k_resource_wood_lumber_bamboo"
}

local industry_building_chain_keys_list = { -- all commercial building keys
"3k_district_artisan_labour",
"3k_district_artisan_private_workshops",
"3k_district_artisan_state_workshops",
"3k_district_artisan_sun_jian_fealty",
"3k_resource_metal_copper",
"3k_resource_metal_craftsmen_armour",
"3k_resource_metal_craftsmen_weapon",
"3k_resource_metal_jade",
"3k_resource_metal_tools"
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



--[[
	issue format:
	["issue_key"] = 
	{
		effect_target = function: How do we pick the effect target?
		weighting_value = float: What is the priority of this issue?
		personality_priorities = table: {domninance, influence, conscientious, steadiness}
		scope = string: What object this targets. {force, faction, character, region}
		effect_bundle_key = string: the key of the effect bundle which is applied.
		effect_bundle_duration = int: how many turns to be active for?
		cost = int: Gold cost to perform
		applies_scripted_effect = bool: Does this issue have a scripted effect?
		available_to_ai = bool: Can the ai use this?
		suggestion_icon = string: The icon to use in the UI
		incident_key_source = string: an incident to fire for the target faction of the suggestion.
		incident_blocks_effects_source = bool: If the incident fires for the source, should we still apply the effect bundle?
		incident_key_target = string: an incident to fire for the source/instigator faction of the suggestion.
		incident_blocks_effects_target = bool: If the incident fires for the target, should we still apply the effect bundle?
		incident_key_global = bool: if the incident effect is not targeting a specific faction but a geographic area we broadcast to all factions.
	}
]]

faction_council.valid_issues_table = {
	["issue_own_army_low_supplies"] = {
		effect_target = function(modify_faction, modify_model)
			return faction_council:issue_own_army_low_supplies(modify_faction:query_faction())
		end,
		weighting_value = 100, -- Weighting priority for the issue
		personality_priorities = { -- How relevant this issue is to each personality type
			dominance = 0.75,
			influence = 0.5,
			conscientious = 1,
			steadiness = 0.25,
		},
		scope = "force",
		effect_bundle_key = "3k_dlc07_issue_own_army_low_supplies",
		effect_bundle_duration = 5,
		cost = 0,
		applies_scripted_effect = false,
		available_to_ai = true,
		ai_weighting_multiplier = 1,
		suggestion_icon = "3k_dlc07_faction_council_suggestion_forces.png",
		incident_key_source = nil,
		incident_blocks_effects_source = nil,
		incident_key_target = nil,
		incident_blocks_effects_target = nil,
		incident_key_global = nil,
		use_distance_weighting_mod = false
	},
	["issue_hostile_army_in_own_territory"] = {
		effect_target = function(modify_faction, modify_model)
			return faction_council:issue_hostile_army_in_own_territory(modify_faction:query_faction())
		end,
		weighting_value = 100, -- Weighting priority for the issue
		personality_priorities = { -- How relevant this issue is to each personality type
			dominance = 1,
			influence = 0.75,
			conscientious = 0.5,
			steadiness = 0.25,
		},
		scope = "force",
		effect_bundle_key = "3k_dlc07_issue_hostile_army_in_own_territory",
		effect_bundle_duration = 6, -- Effect also lives on incident, make sure to update!
		cost = 500,
		applies_scripted_effect = false,
		available_to_ai = true,
		ai_weighting_multiplier = 1,
		suggestion_icon = "3k_dlc07_faction_council_suggestion_forces.png",
		incident_key_source = nil,
		incident_blocks_effects_source = nil,
		incident_key_target = "3k_dlc07_faction_council_issue_hostile_armies_in_own_territory_target_incident",
		incident_blocks_effects_target = true,
		incident_key_global = nil,
		use_distance_weighting_mod = false
	},
	["issue_rapid_force_redeployment"] = {
		effect_target = function(modify_faction, modify_model)
			return faction_council:issue_rapid_force_redeployment(modify_faction:query_faction())
		end,
		weighting_value = 40, -- Weighting priority for the issue
		personality_priorities = { -- How relevant this issue is to each personality type
			dominance = 0.5,
			influence = 0.25,
			conscientious = 0.75,
			steadiness = 1,
		},
		scope = "faction",
		effect_bundle_key = "3k_dlc07_issue_rapid_force_redeployment",
		effect_bundle_duration = 5,
		cost = 500,
		applies_scripted_effect = false,
		available_to_ai = true,
		ai_weighting_multiplier = 1,
		suggestion_icon = "3k_dlc07_faction_council_suggestion_forces.png",
		incident_key_source = nil,
		incident_blocks_effects_source = nil,
		incident_key_target = nil,
		incident_blocks_effects_target = nil,
		incident_key_global = nil,
		use_distance_weighting_mod = false
	},
	["issue_hostile_armies_replenishing"] = {
		effect_target = function(modify_faction, modify_model)
			return faction_council:issue_hostile_armies_replenishing(modify_faction:query_faction())
		end,
		weighting_value = 60, -- Weighting priority for the issue
		personality_priorities = { -- How relevant this issue is to each personality type
			dominance = 0.5,
			influence = 0.25,
			conscientious = 0.75,
			steadiness = 1,
		},
		scope = "force",
		effect_bundle_key = "3k_dlc07_issue_hostile_armies_replenishing",
		effect_bundle_duration = 11, -- Effect also lives on incident, make sure to update!
		cost = 500,
		applies_scripted_effect = false,
		available_to_ai = true,
		ai_weighting_multiplier = 1,
		suggestion_icon = "3k_dlc07_faction_council_suggestion_forces.png",
		incident_key_source = nil,
		incident_blocks_effects_source = nil,
		incident_key_target = "3k_dlc07_faction_council_issue_hostile_armies_replenishing_target_incident",
		incident_blocks_effects_target = true,
		incident_key_global = nil,
		use_distance_weighting_mod = true
	},
	["issue_retrain_army_rosters"] = {
		effect_target = function(modify_faction, modify_model)
			return faction_council:issue_retrain_army_rosters(modify_faction:query_faction())
		end,
		weighting_value = 50, -- Weighting priority for the issue
		personality_priorities = { -- How relevant this issue is to each personality type
			dominance = 0.75,
			influence = 0.25,
			conscientious = 1,
			steadiness = 0.5,
		},
		scope = "faction",
		effect_bundle_key = "3k_dlc07_issue_retrain_army_rosters",
		effect_bundle_duration = 5,
		cost = 200,
		applies_scripted_effect = false,
		available_to_ai = true,
		ai_weighting_multiplier = 1,
		suggestion_icon = "3k_dlc07_faction_council_suggestion_forces.png",
		incident_key_source = nil,
		incident_blocks_effects_source = nil,
		incident_key_target = nil,
		incident_blocks_effects_target = nil,
		incident_key_global = nil,
		use_distance_weighting_mod = false
	},
	["issue_own_armies_in_enemy_territory"] = {
		effect_target = function(modify_faction, modify_model)
			return faction_council:issue_own_armies_in_enemy_territory(modify_faction:query_faction())
		end,
		weighting_value = 80, -- Weighting priority for the issue
		personality_priorities = { -- How relevant this issue is to each personality type
			dominance = 1,
			influence = 0.75,
			conscientious = 0.25,
			steadiness = 0.5,
		},
		scope = "force",
		effect_bundle_key = "3k_dlc07_issue_own_armies_in_enemy_territory",
		effect_bundle_duration = 10,
		cost = 200,
		applies_scripted_effect = false,
		available_to_ai = true,
		ai_weighting_multiplier = 1,
		suggestion_icon = "3k_dlc07_faction_council_suggestion_forces.png",
		incident_key_source = nil,
		incident_blocks_effects_source = nil,
		incident_key_target = nil,
		incident_blocks_effects_target = nil,
		incident_key_global = nil,
		use_distance_weighting_mod = false
	},
	["issue_own_armies_in_non_allied_territory_without_siege_engines"] = {
		effect_target = function(modify_faction, modify_model)
			return faction_council:issue_own_armies_in_non_allied_territory_without_siege_engines(modify_faction:query_faction())
		end,
		weighting_value = 80, -- Weighting priority for the issue
		personality_priorities = { -- How relevant this issue is to each personality type
			dominance = 1,
			influence = 0.75,
			conscientious = 0.25,
			steadiness = 0.5,
		},
		scope = "force",
		effect_bundle_key = "3k_dlc07_issue_own_armies_in_non_allied_territory_without_siege_engines",
		effect_bundle_duration = 6,
		cost = 500,
		applies_scripted_effect = false,
		available_to_ai = true,
		ai_weighting_multiplier = 1,
		suggestion_icon = "3k_dlc07_faction_council_suggestion_forces.png",
		incident_key_source = "3k_dlc07_faction_council_issue_own_armies_in_non_allied_territory_without_siege_engines_incident",
		incident_blocks_effects_source = false,
		incident_key_target = nil,
		incident_blocks_effects_target = true,
		incident_key_global = nil,
		use_distance_weighting_mod = false
	},
	["issue_own_army_in_non_allied_territory"] = {
		effect_target = function(modify_faction, modify_model)
			return faction_council:issue_own_army_in_non_allied_territory(modify_faction:query_faction())
		end,
		weighting_value = 70, -- Weighting priority for the issue
		personality_priorities = { -- How relevant this issue is to each personality type
			dominance = 0.75,
			influence = 0.5,
			conscientious = 1,
			steadiness = 0.25,
		},
		scope = "force",
		effect_bundle_key = "3k_dlc07_issue_own_army_in_non_allied_territory",
		effect_bundle_duration = 5,
		cost = 1500,
		applies_scripted_effect = false,
		available_to_ai = true,
		ai_weighting_multiplier = 1,
		suggestion_icon = "3k_dlc07_faction_council_suggestion_forces.png",
		incident_key_source = nil,
		incident_blocks_effects_source = nil,
		incident_key_target = nil,
		incident_blocks_effects_target = nil,
		incident_key_global = nil,
		use_distance_weighting_mod = false
	},
	["issue_own_unit_lists_contain_high_ratio_of_cavalry"] = {
		effect_target = function(modify_faction, modify_model)
			return faction_council:issue_own_unit_lists_contain_high_ratio_of_cavalry(modify_faction:query_faction())
		end,
		weighting_value = 50, -- Weighting priority for the issue
		personality_priorities = { -- How relevant this issue is to each personality type
			dominance = 0.5,
			influence = 0.25,
			conscientious = 1,
			steadiness = 0.75,
		},
		scope = "faction",
		effect_bundle_key = "3k_dlc07_issue_own_unit_lists_contain_high_ratio_of_cavalry",
		effect_bundle_duration = 5,
		cost = 200,
		applies_scripted_effect = false,
		available_to_ai = true,
		ai_weighting_multiplier = 1,
		suggestion_icon = "3k_dlc07_faction_council_suggestion_forces.png",
		incident_key_source = nil,
		incident_blocks_effects_source = nil,
		incident_key_target = nil,
		incident_blocks_effects_target = nil,
		incident_key_global = nil,
		use_distance_weighting_mod = false
	},
	["issue_own_unit_lists_contain_high_ratio_of_melee_infantry"] = {
		effect_target = function(modify_faction, modify_model)
			return faction_council:issue_own_unit_lists_contain_high_ratio_of_melee_infantry(modify_faction:query_faction())
		end,
		weighting_value = 50, -- Weighting priority for the issue
		personality_priorities = { -- How relevant this issue is to each personality type
			dominance = 0.5,
			influence = 0.25,
			conscientious = 1,
			steadiness = 0.75,
		},
		scope = "faction",
		effect_bundle_key = "3k_dlc07_issue_own_unit_lists_contain_high_ratio_of_melee_infantry",
		effect_bundle_duration = 5,
		cost = 200,
		applies_scripted_effect = false,
		available_to_ai = true,
		ai_weighting_multiplier = 1,
		suggestion_icon = "3k_dlc07_faction_council_suggestion_forces.png",
		incident_key_source = nil,
		incident_blocks_effects_source = nil,
		incident_key_target = nil,
		incident_blocks_effects_target = nil,
		incident_key_global = nil,
		use_distance_weighting_mod = false
	},
	["issue_own_unit_lists_contain_high_ratio_of_ranged_units"] = {
		effect_target = function(modify_faction, modify_model)
			return faction_council:issue_own_unit_lists_contain_high_ratio_of_ranged_units(modify_faction:query_faction())
		end,
		weighting_value = 50, -- Weighting priority for the issue
		personality_priorities = { -- How relevant this issue is to each personality type
			dominance = 0.5,
			influence = 0.25,
			conscientious = 1,
			steadiness = 0.75,
		},
		scope = "faction",
		effect_bundle_key = "3k_dlc07_issue_own_unit_lists_contain_high_ratio_of_ranged_units",
		effect_bundle_duration = 5,
		cost = 200,
		applies_scripted_effect = false,
		available_to_ai = true,
		ai_weighting_multiplier = 1,
		suggestion_icon = "3k_dlc07_faction_council_suggestion_forces.png",
		incident_key_source = nil,
		incident_blocks_effects_source = nil,
		incident_key_target = nil,
		incident_blocks_effects_target = nil,
		incident_key_global = nil,
		use_distance_weighting_mod = false
	},
	["issue_own_army_unit_list_experience_amount_low"] = {
		effect_target = function(modify_faction, modify_model)
			return faction_council:issue_own_army_unit_list_experience_amount_low(modify_faction:query_faction())
		end,
		weighting_value = 60, -- Weighting priority for the issue
		personality_priorities = { -- How relevant this issue is to each personality type
			dominance = 0.5,
			influence = 0.25,
			conscientious = 0.75,
			steadiness = 1,
		},
		scope = "force",
		effect_bundle_key = "3k_dlc07_issue_own_army_unit_list_experience_amount_low",
		effect_bundle_duration = 5,
		cost = 200,
		applies_scripted_effect = false,
		available_to_ai = true,
		ai_weighting_multiplier = 1,
		suggestion_icon = "3k_dlc07_faction_council_suggestion_forces.png",
		incident_key_source = nil,
		incident_blocks_effects_source = nil,
		incident_key_target = nil,
		incident_blocks_effects_target = nil,
		incident_key_global = nil,
		use_distance_weighting_mod = false
	},
	["issue_incomplete_ceo_set"] = {
		effect_target = function(modify_faction, modify_model)
			if faction_council:issue_incomplete_ceo_set(modify_faction:query_faction()) then
				return modify_faction:query_faction():command_queue_index();
			end;
			return nil;
		end,
		weighting_value = 70, -- Weighting priority for the issue
		personality_priorities = { -- How relevant this issue is to each personality type
			dominance = 0.25,
			influence = 0.75,
			conscientious = 1,
			steadiness = 0.5,
		},
		scope = "faction",
		effect_bundle_key = "3k_dlc07_issue_incomplete_ceo_set",
		effect_bundle_duration = 0,
		cost = 500,
		applies_scripted_effect = true,
		available_to_ai = true,
		ai_weighting_multiplier = 1,
		suggestion_icon = "3k_dlc07_faction_council_suggestion_characters.png",
		incident_key_source = nil,
		incident_blocks_effects_source = nil,
		incident_key_target = nil,
		incident_blocks_effects_target = nil,
		incident_key_global = nil,
		use_distance_weighting_mod = false
	},
	["issue_few_unassigned_ancillaries"] = {
		effect_target = function(modify_faction, modify_model)
			return faction_council:issue_few_unassigned_ancillaries(modify_faction:query_faction())
		end,
		weighting_value = 80, -- Weighting priority for the issue
		personality_priorities = { -- How relevant this issue is to each personality type
			dominance = 0.25,
			influence = 0.75,
			conscientious = 1,
			steadiness = 0.5,
		},
		scope = "faction",
		effect_bundle_key = "3k_dlc07_issue_few_unassigned_ancillaries",
		effect_bundle_duration = 0,
		cost = 500,
		applies_scripted_effect = true,
		available_to_ai = true,
		ai_weighting_multiplier = 1,
		suggestion_icon = "3k_dlc07_faction_council_suggestion_characters.png",
		incident_key_source = nil,
		incident_blocks_effects_source = nil,
		incident_key_target = nil,
		incident_blocks_effects_target = nil,
		incident_key_global = nil,
		use_distance_weighting_mod = false
	},
	["issue_own_character_loyalty_low"] = {
		effect_target = function(modify_faction, modify_model)
			return faction_council:issue_own_character_loyalty_low(modify_faction:query_faction())
		end,
		weighting_value = 100, -- Weighting priority for the issue
		personality_priorities = { -- How relevant this issue is to each personality type
			dominance = 0.25,
			influence = 0.5,
			conscientious = 0.75,
			steadiness = 1,
		},
		scope = "character",
		effect_bundle_key = "3k_dlc07_issue_own_character_loyalty_low",
		effect_bundle_duration = 5,
		cost = 200,
		applies_scripted_effect = false,
		available_to_ai = true,
		ai_weighting_multiplier = 1,
		suggestion_icon = "3k_dlc07_faction_council_suggestion_characters.png",
		incident_key_source = nil,
		incident_blocks_effects_source = nil,
		incident_key_target = nil,
		incident_blocks_effects_target = nil,
		incident_key_global = nil,
		use_distance_weighting_mod = false
	},
	["issue_own_character_low_rank"] = {
		effect_target = function(modify_faction, modify_model)
			return faction_council:issue_own_character_low_rank(modify_faction:query_faction())
		end,
		weighting_value = 60, -- Weighting priority for the issue
		personality_priorities = { -- How relevant this issue is to each personality type
			dominance = 0.25,
			influence = 0.5,
			conscientious = 0.75,
			steadiness = 1,
		},
		scope = "character",
		effect_bundle_key = "3k_dlc07_issue_own_character_low_rank",
		effect_bundle_duration = 10,
		cost = 500,
		applies_scripted_effect = false,
		available_to_ai = true,
		ai_weighting_multiplier = 1,
		suggestion_icon = "3k_dlc07_faction_council_suggestion_characters.png",
		incident_key_source = nil,
		incident_blocks_effects_source = nil,
		incident_key_target = nil,
		incident_blocks_effects_target = nil,
		incident_key_global = nil,
		use_distance_weighting_mod = false
	},
	["issue_own_character_unmarried"] = {
		effect_target = function(modify_faction, modify_model)
			return faction_council:issue_own_character_unmarried(modify_faction:query_faction())
		end,
		weighting_value = 40, -- Weighting priority for the issue
		personality_priorities = { -- How relevant this issue is to each personality type
			dominance = 0.25,
			influence = 0.5,
			conscientious = 1,
			steadiness = 0.75,
		},
		scope = "character",
		effect_bundle_key = "3k_dlc07_issue_own_character_unmarried",
		effect_bundle_duration = 0,
		cost = 500,
		applies_scripted_effect = true,
		available_to_ai = true,
		ai_weighting_multiplier = 1,
		suggestion_icon = "3k_dlc07_faction_council_suggestion_characters.png",
		incident_key_source = nil,
		incident_blocks_effects_source = nil,
		incident_key_target = nil,
		incident_blocks_effects_target = nil,
		incident_key_global = nil,
		use_distance_weighting_mod = false
	},
	["issue_own_character_recruited_at_higher_rank"] = {
		effect_target = function(modify_faction, modify_model)
			return faction_council:issue_own_character_recruited_at_higher_rank(modify_faction:query_faction())
		end,
		weighting_value = 90, -- Weighting priority for the issue
		personality_priorities = { -- How relevant this issue is to each personality type
			dominance = 0.25,
			influence = 0.5,
			conscientious = 0.75,
			steadiness = 1,
		},
		scope = "character",
		effect_bundle_key = "3k_dlc07_issue_own_character_recruited_at_higher_rank",
		effect_bundle_duration = 0,
		cost = 1000,
		applies_scripted_effect = true,
		available_to_ai = true,
		ai_weighting_multiplier = 1,
		suggestion_icon = "3k_dlc07_faction_council_suggestion_characters.png",
		incident_key_source = nil,
		incident_blocks_effects_source = nil,
		incident_key_target = nil,
		incident_blocks_effects_target = nil,
		incident_key_global = nil,
		use_distance_weighting_mod = false
	},
	["issue_no_characters_recruited_recently"] = {
		effect_target = function(modify_faction, modify_model)
			return faction_council:issue_no_characters_recruited_recently(modify_faction:query_faction())
		end,
		weighting_value = 80, -- Weighting priority for the issue
		personality_priorities = { -- How relevant this issue is to each personality type
			dominance = 0.25,
			influence = 0.5,
			conscientious = 1,
			steadiness = 0.75,
		},
		scope = "faction",
		effect_bundle_key = "3k_dlc07_issue_no_characters_recruited_recently",
		effect_bundle_duration = 0,
		cost = 500,
		applies_scripted_effect = false,
		available_to_ai = true,
		ai_weighting_multiplier = 1,
		suggestion_icon = "3k_dlc07_faction_council_suggestion_characters.png",
		incident_key_source = "3k_dlc07_faction_council_issue_no_characters_recruited_recently_source_incident",
		incident_blocks_effects_source = true,
		incident_key_target = nil,
		incident_blocks_effects_target = nil,
		incident_key_global = nil,
		use_distance_weighting_mod = false
	},
	["issue_enemy_character_wounded_but_not_killed"] = {
		effect_target = function(modify_faction, modify_model)
			return faction_council:issue_enemy_character_wounded_but_not_killed(modify_faction:query_faction())
		end,
		weighting_value = 100, -- Weighting priority for the issue
		personality_priorities = { -- How relevant this issue is to each personality type
			dominance = 0.75,
			influence = 1,
			conscientious = 0.5,
			steadiness = 0.25,
		},
		scope = "character",
		effect_bundle_key = "3k_dlc07_issue_enemy_character_wounded_but_not_killed",
		effect_bundle_duration = 0, -- Effect also lives on incident, make sure to update!
		cost = 2000,
		applies_scripted_effect = true,
		available_to_ai = false,
		ai_weighting_multiplier = 1,
		suggestion_icon = "3k_dlc07_faction_council_suggestion_characters.png",
		incident_key_source = nil,
		incident_blocks_effects_source = nil,
		incident_key_target = "3k_dlc07_faction_council_issue_enemy_character_wounded_but_not_killed_target_incident",
		incident_blocks_effects_target = nil,
		incident_key_global = nil,
		use_distance_weighting_mod = false
	},
	["issue_enemy_faction_leader_in_foreign_territory"] = {
		effect_target = function(modify_faction, modify_model)
			return faction_council:issue_enemy_faction_leader_in_foreign_territory(modify_faction:query_faction())
		end,
		weighting_value = 70, -- Weighting priority for the issue
		personality_priorities = { -- How relevant this issue is to each personality type
			dominance = 0.75,
			influence = 1,
			conscientious = 0.5,
			steadiness = 0.25,
		},
		scope = "character",
		effect_bundle_key = "3k_dlc07_issue_enemy_faction_leader_in_foreign_territory",
		effect_bundle_duration = 10,
		cost = 500,
		applies_scripted_effect = true,
		available_to_ai = true,
		ai_weighting_multiplier = 1,
		suggestion_icon = "3k_dlc07_faction_council_suggestion_characters.png",
		incident_key_source = nil,
		incident_blocks_effects_source = nil,
		incident_key_target = nil,
		incident_blocks_effects_target = nil,
		incident_key_global = nil,
		use_distance_weighting_mod = true
	},
	["issue_own_character_has_undesirable_traits"] = {
		effect_target = function(modify_faction, modify_model)
			return faction_council:issue_own_character_has_undesirable_traits(modify_faction:query_faction())
		end,
		weighting_value = 50, -- Weighting priority for the issue
		personality_priorities = { -- How relevant this issue is to each personality type
			dominance = 0.25,
			influence = 1,
			conscientious = 0.75,
			steadiness = 0.5,
		},
		scope = "character",
		effect_bundle_key = "3k_dlc07_issue_own_character_has_undesirable_traits",
		effect_bundle_duration = 0,
		cost = 500,
		applies_scripted_effect = true,
		available_to_ai = true,
		ai_weighting_multiplier = 1,
		suggestion_icon = "3k_dlc07_faction_council_suggestion_characters.png",
		incident_key_source = nil,
		incident_blocks_effects_source = nil,
		incident_key_target = nil,
		incident_blocks_effects_target = nil,
		incident_key_global = nil,
		use_distance_weighting_mod = false
	},
	["issue_valuable_high_satisfaction_character_in_enemy_faction"] = {
		effect_target = function(modify_faction, modify_model)
			return faction_council:issue_valuable_high_satisfaction_character_in_enemy_faction(modify_faction:query_faction())
		end,
		weighting_value = 50, -- Weighting priority for the issue
		personality_priorities = { -- How relevant this issue is to each personality type
			dominance = 0.25,
			influence = 1,
			conscientious = 0.75,
			steadiness = 0.5,
		},
		scope = "character",
		effect_bundle_key = "3k_dlc07_issue_valuable_high_satisfaction_character_in_enemy_faction",
		effect_bundle_duration = 21, -- Effect also lives on incident, make sure to update!
		cost = 1000,
		applies_scripted_effect = false,
		available_to_ai = true,
		ai_weighting_multiplier = 1,
		suggestion_icon = "3k_dlc07_faction_council_suggestion_characters.png",
		incident_key_source = nil,
		incident_blocks_effects_source = nil,
		incident_key_target = "3k_dlc07_faction_council_issue_valuable_high_satisfaction_character_in_enemy_faction_target_incident",
		incident_blocks_effects_target = true,
		incident_key_global = nil,
		use_distance_weighting_mod = false
	},
	["issue_own_region_low_public_order"] = {
		effect_target = function(modify_faction, modify_model)
			return faction_council:issue_own_region_low_public_order(modify_faction:query_faction())
		end,
		weighting_value = 90, -- Weighting priority for the issue
		personality_priorities = { -- How relevant this issue is to each personality type
			dominance = 0.5,
			influence = 0.25,
			conscientious = 0.75,
			steadiness = 1,
		},
		scope = "province",
		effect_bundle_key = "3k_dlc07_issue_own_region_low_public_order",
		effect_bundle_duration = 5,
		cost = 500,
		applies_scripted_effect = false,
		available_to_ai = true,
		ai_weighting_multiplier = 1,
		suggestion_icon = "3k_dlc07_faction_council_suggestion_settlements.png",
		incident_key_source = nil,
		incident_blocks_effects_source = nil,
		incident_key_target = nil,
		incident_blocks_effects_target = nil,
		incident_key_global = nil,
		use_distance_weighting_mod = false
	},
	["issue_own_region_underdeveloped"] = {
		effect_target = function(modify_faction, modify_model)
			return faction_council:issue_own_region_underdeveloped(modify_faction:query_faction())
		end,
		weighting_value = 80, -- Weighting priority for the issue
		personality_priorities = { -- How relevant this issue is to each personality type
			dominance = 0.25,
			influence = 0.5,
			conscientious = 0.75,
			steadiness = 1,
		},
		scope = "province",		
		effect_bundle_key = "3k_dlc07_issue_own_region_underdeveloped",
		effect_bundle_duration = 5,
		cost = 200,
		applies_scripted_effect = false,
		available_to_ai = true,
		ai_weighting_multiplier = 1,
		suggestion_icon = "3k_dlc07_faction_council_suggestion_settlements.png",
		incident_key_source = nil,
		incident_blocks_effects_source = nil,
		incident_key_target = nil,
		incident_blocks_effects_target = nil,
		incident_key_global = nil,
		use_distance_weighting_mod = false
	},
	["issue_own_region_recently_attacked_or_is_sieged"] = {
		effect_target = function(modify_faction, modify_model)
			return faction_council:issue_own_region_recently_attacked_or_is_sieged(modify_faction:query_faction())
		end,
		weighting_value = 100, -- Weighting priority for the issue
		personality_priorities = { -- How relevant this issue is to each personality type
			dominance = 0.25,
			influence = 0.5,
			conscientious = 0.75,
			steadiness = 1,
		},
		scope = "region",		
		effect_bundle_key = "3k_dlc07_issue_own_region_recently_attacked_or_is_sieged",
		effect_bundle_duration = 5,
		cost = 0,
		applies_scripted_effect = false,
		available_to_ai = true,
		ai_weighting_multiplier = 1,
		suggestion_icon = "3k_dlc07_faction_council_suggestion_settlements.png",
		incident_key_source = nil,
		incident_blocks_effects_source = nil,
		incident_key_target = nil,
		incident_blocks_effects_target = nil,
		incident_key_global = nil,
		use_distance_weighting_mod = false
	},
	["issue_highly_developed_enemy_region_with_own_army"] = {
		effect_target = function(modify_faction, modify_model)
			return faction_council:issue_highly_developed_enemy_region_with_own_army(modify_faction:query_faction())
		end,
		weighting_value = 100, -- Weighting priority for the issue
		personality_priorities = { -- How relevant this issue is to each personality type
			dominance = 1,
			influence = 0.75,
			conscientious = 0.25,
			steadiness = 0.5,
		},
		scope = "region",			
		effect_bundle_key = "3k_dlc07_issue_highly_developed_enemy_region_with_own_army",
		effect_bundle_duration = 6, -- Effect also lives on incident, make sure to update!
		cost = 500,
		applies_scripted_effect = true,
		available_to_ai = true,
		ai_weighting_multiplier = 1,
		suggestion_icon = "3k_dlc07_faction_council_suggestion_settlements.png",
		incident_key_source = nil,
		incident_blocks_effects_source = nil,
		incident_key_target = "3k_dlc07_faction_council_issue_highly_developed_enemy_region_with_own_army_target_incident",
		incident_blocks_effects_target = true,
		incident_key_global = nil,
		use_distance_weighting_mod = false
	},
	["issue_own_region_low_on_supplies"] = {
		effect_target = function(modify_faction, modify_model)
			return faction_council:issue_own_region_low_on_supplies(modify_faction:query_faction())
		end,
		weighting_value = 70, -- Weighting priority for the issue
		personality_priorities = { -- How relevant this issue is to each personality type
			dominance = 0.25,
			influence = 0.5,
			conscientious = 0.75,
			steadiness = 1,
		},
		scope = "province",	
		effect_bundle_key = "3k_dlc07_issue_own_region_low_on_supplies",
		effect_bundle_duration = 5,
		cost = 0,
		applies_scripted_effect = false,
		available_to_ai = true,
		ai_weighting_multiplier = 1,
		suggestion_icon = "3k_dlc07_faction_council_suggestion_settlements.png",
		incident_key_source = nil,
		incident_blocks_effects_source = nil,
		incident_key_target = nil,
		incident_blocks_effects_target = nil,
		incident_key_global = nil,
		use_distance_weighting_mod = false
	},
	["issue_own_regions_low_percentage_capacity_for_population"] = {
		effect_target = function(modify_faction, modify_model)
			return faction_council:issue_own_regions_low_percentage_capacity_for_population(modify_faction:query_faction())
		end,
		weighting_value = 60, -- Weighting priority for the issue
		personality_priorities = { -- How relevant this issue is to each personality type
			dominance = 0.25,
			influence = 1,
			conscientious = 0.5,
			steadiness = 0.75,
		},
		scope = "faction",	
		effect_bundle_key = "3k_dlc07_issue_own_regions_low_percentage_capacity_for_population",
		effect_bundle_duration = 5,
		cost = 200,
		applies_scripted_effect = false,
		available_to_ai = true,
		ai_weighting_multiplier = 1,
		suggestion_icon = "3k_dlc07_faction_council_suggestion_settlements.png",
		incident_key_source = nil,
		incident_blocks_effects_source = nil,
		incident_key_target = nil,
		incident_blocks_effects_target = nil,
		incident_key_global = nil,
		use_distance_weighting_mod = false
	},
	["issue_enemy_region_with_highly_developed_infrastructure"] = {
		effect_target = function(modify_faction, modify_model)
			return faction_council:issue_enemy_region_with_highly_developed_infrastructure(modify_faction:query_faction())
		end,
		weighting_value = 70, -- Weighting priority for the issue
		personality_priorities = { -- How relevant this issue is to each personality type
			dominance = 0.5,
			influence = 0.75,
			conscientious = 1,
			steadiness = 0.25,
		},
		scope = "region",
		effect_bundle_key = "3k_dlc07_issue_enemy_region_with_highly_developed_infrastructure",
		effect_bundle_duration = 5, -- Effect also lives on incident, make sure to update!
		cost = 1000,
		applies_scripted_effect = true,
		available_to_ai = true,
		ai_weighting_multiplier = 1,
		suggestion_icon = "3k_dlc07_faction_council_suggestion_settlements.png",
		incident_key_source = "3k_dlc07_faction_council_issue_enemy_region_with_highly_developed_infrastructure_source_incident",
		incident_blocks_effects_source = false,
		incident_key_target = "3k_dlc07_faction_council_issue_enemy_region_with_highly_developed_infrastructure_target_incident",
		incident_blocks_effects_target = nil,
		incident_key_global = nil,
		use_distance_weighting_mod = true
	},
	["issue_unused_own_trade_capacity"] = {
		effect_target = function(modify_faction, modify_model)
			return faction_council:issue_unused_own_trade_capacity(modify_faction:query_faction())
		end,
		weighting_value = 100, -- Weighting priority for the issue
		personality_priorities = { -- How relevant this issue is to each personality type
			dominance = 0.5,
			influence = 0.75,
			conscientious = 1,
			steadiness = 0.25,
		},
		scope = "faction",
		effect_bundle_key = "3k_dlc07_issue_unused_own_trade_capacity",
		effect_bundle_duration = 5,
		cost = 0,
		applies_scripted_effect = true,
		available_to_ai = false,
		ai_weighting_multiplier = 1,
		suggestion_icon = "3k_dlc07_faction_council_suggestion_diplomacy.png",
		incident_key_source = nil,
		incident_blocks_effects_source = true, -- set to true here as we need to sign treaty with target but apply effect bundle to source, effect bundle applied elsewhere
		incident_key_target = nil,
		incident_blocks_effects_target = true, -- set to true here as we need to sign treaty with target but apply effect bundle to source, effect bundle applied elsewhere
		incident_key_global = nil,
		use_distance_weighting_mod = false
	},
	["issue_own_vassal_relationship_poor"] = {
		effect_target = function(modify_faction, modify_model)
			return faction_council:issue_own_vassal_relationship_poor(modify_faction:query_faction())
		end,
		weighting_value = 100, -- Weighting priority for the issue
		personality_priorities = { -- How relevant this issue is to each personality type
			dominance = 0.25,
			influence = 1,
			conscientious = 0.5,
			steadiness = 0.75,
		},
		scope = "faction",
		effect_bundle_key = "3k_dlc07_issue_own_vassal_relationship_poor",
		effect_bundle_duration = 0,
		cost = 1000,
		applies_scripted_effect = true,
		available_to_ai = true,
		ai_weighting_multiplier = 1,
		suggestion_icon = "3k_dlc07_faction_council_suggestion_diplomacy.png",
		incident_key_source = nil,
		incident_blocks_effects_source = nil,
		incident_key_target = nil,
		incident_blocks_effects_target = nil,
		incident_key_global = nil,
		use_distance_weighting_mod = false
	},
	["issue_non_allied_faction_in_adjacent_region"] = {
		effect_target = function(modify_faction, modify_model)
			return faction_council:issue_non_allied_faction_in_adjacent_region(modify_faction:query_faction())
		end,
		weighting_value = 60, -- Weighting priority for the issue
		personality_priorities = { -- How relevant this issue is to each personality type
			dominance = 0.75,
			influence = 0.5,
			conscientious = 0.25,
			steadiness = 1,
		},
		scope = "region",
		effect_bundle_key = "3k_dlc07_issue_non_allied_faction_in_adjacent_region",
		effect_bundle_duration = 5,
		cost = 1000,
		applies_scripted_effect = false,
		available_to_ai = true,
		ai_weighting_multiplier = 1,
		suggestion_icon = "3k_dlc07_faction_council_suggestion_diplomacy.png",
		incident_key_source = "3k_dlc07_faction_council_issue_non_allied_faction_in_adjacent_region_source_incident",
		incident_blocks_effects_source = nil,
		incident_key_target = nil,
		incident_blocks_effects_target = nil,
		incident_key_global = nil,
		use_distance_weighting_mod = false
	},
	["issue_other_faction_is_world_leader"] = {
		effect_target = function(modify_faction, modify_model)
			return faction_council:issue_other_faction_is_world_leader(modify_faction:query_faction())
		end,
		weighting_value = 80, -- Weighting priority for the issue
		personality_priorities = { -- How relevant this issue is to each personality type
			dominance = 0.25,
			influence = 1,
			conscientious = 0.5,
			steadiness = 0.75,
		},
		scope = "faction",
		effect_bundle_key = "3k_dlc07_issue_other_faction_is_world_leader",
		effect_bundle_duration = 5,
		cost = 500,
		applies_scripted_effect = false,
		available_to_ai = true,
		ai_weighting_multiplier = 1,
		suggestion_icon = "3k_dlc07_faction_council_suggestion_diplomacy.png",
		incident_key_source = nil,
		incident_blocks_effects_source = nil,
		incident_key_target = nil,
		incident_blocks_effects_target = nil,
		incident_key_global = nil,
		use_distance_weighting_mod = false
	},
	["issue_non_allied_factions_control_southern_ports"] = {
		effect_target = function(modify_faction, modify_model)
			return faction_council:issue_non_allied_factions_control_southern_ports(modify_faction:query_faction())
		end,
		weighting_value = 50, -- Weighting priority for the issue
		personality_priorities = { -- How relevant this issue is to each personality type
			dominance = 1,
			influence = 0.75,
			conscientious = 0.25,
			steadiness = 0.5,
		},
		scope = "region",
		effect_bundle_key = "3k_dlc07_issue_non_allied_factions_control_southern_ports",
		effect_bundle_duration = 0,
		cost = 500,
		applies_scripted_effect = true,
		available_to_ai = true,
		ai_weighting_multiplier = 0.75,
		suggestion_icon = "3k_dlc07_faction_council_suggestion_diplomacy.png",
		incident_key_source = "3k_dlc07_faction_council_issue_non_allied_factions_control_southern_ports_source_incident",
		incident_blocks_effects_source = true,
		incident_key_target = nil,
		incident_blocks_effects_target = nil,
		incident_key_global = "3k_dlc07_faction_council_issue_non_allied_factions_control_southern_ports_global_incident",
		use_distance_weighting_mod = true
	},
	["issue_non_allied_factions_control_northern_ports"] = {
		effect_target = function(modify_faction, modify_model)
			return faction_council:issue_non_allied_factions_control_northern_ports(modify_faction:query_faction())
		end,
		weighting_value = 50, -- Weighting priority for the issue
		personality_priorities = { -- How relevant this issue is to each personality type
			dominance = 1,
			influence = 0.75,
			conscientious = 0.25,
			steadiness = 0.5,
		},
		scope = "region",
		effect_bundle_key = "3k_dlc07_issue_non_allied_factions_control_northern_ports",
		effect_bundle_duration = 0,
		cost = 500,
		applies_scripted_effect = true,
		available_to_ai = true,
		ai_weighting_multiplier = 0.75,
		suggestion_icon = "3k_dlc07_faction_council_suggestion_diplomacy.png",
		incident_key_source = "3k_dlc07_faction_council_issue_non_allied_factions_control_northern_ports_source_incident",
		incident_blocks_effects_source = true,
		incident_key_target = nil,
		incident_blocks_effects_target = nil,
		incident_key_global = "3k_dlc07_faction_council_issue_non_allied_factions_control_northern_ports_global_incident",
		use_distance_weighting_mod = true
	},
	["issue_non_allied_factions_control_north_west_regions"] = {
		effect_target = function(modify_faction, modify_model)
			return faction_council:issue_non_allied_factions_control_north_west_regions(modify_faction:query_faction())
		end,
		weighting_value = 50, -- Weighting priority for the issue
		personality_priorities = { -- How relevant this issue is to each personality type
			dominance = 1,
			influence = 0.75,
			conscientious = 0.25,
			steadiness = 0.5,
		},
		scope = "region",
		effect_bundle_key = "3k_dlc07_issue_non_allied_factions_control_north_west_regions",
		effect_bundle_duration = 0,
		cost = 500,
		applies_scripted_effect = true,
		available_to_ai = true,
		ai_weighting_multiplier = 0.75,
		suggestion_icon = "3k_dlc07_faction_council_suggestion_diplomacy.png",
		incident_key_source = "3k_dlc07_faction_council_issue_non_allied_factions_control_north_west_regions_source_incident",
		incident_blocks_effects_source = true,
		incident_key_target = nil,
		incident_blocks_effects_target = nil,
		incident_key_global = "3k_dlc07_faction_council_issue_non_allied_factions_control_north_west_regions_global_incident",
		use_distance_weighting_mod = true
	},
	["issue_large_enemy_faction_with_little_excess_food"] = {
		effect_target = function(modify_faction, modify_model)
			return faction_council:issue_large_enemy_faction_with_little_excess_food(modify_faction:query_faction())
		end,
		weighting_value = 60, -- Weighting priority for the issue
		personality_priorities = { -- How relevant this issue is to each personality type
			dominance = 0.25,
			influence = 0.75,
			conscientious = 1,
			steadiness = 0.5,
		},
		scope = "faction",
		effect_bundle_key = "3k_dlc07_issue_large_enemy_faction_with_little_excess_food",
		effect_bundle_duration = 5,
		cost = 500,
		applies_scripted_effect = false,
		available_to_ai = true,
		ai_weighting_multiplier = 1,
		suggestion_icon = "3k_dlc07_faction_council_suggestion_economics.png",
		incident_key_source = nil,
		incident_blocks_effects_source = nil,
		incident_key_target = nil,
		incident_blocks_effects_target = nil,
		incident_key_global = nil,
		use_distance_weighting_mod = false
	},
	["issue_increase_commercial_economy_focus"] = {
		effect_target = function(modify_faction, modify_model)
			return faction_council:issue_increase_commercial_economy_focus(modify_faction:query_faction())
		end,
		weighting_value = 70, -- Weighting priority for the issue
		personality_priorities = { -- How relevant this issue is to each personality type
			dominance = 0.25,
			influence = 0.5,
			conscientious = 1,
			steadiness = 0.75,
		},
		scope = "faction",
		effect_bundle_key = "3k_dlc07_issue_increase_commercial_economy_focus",
		effect_bundle_duration = 5,
		cost = 0,
		applies_scripted_effect = false,
		available_to_ai = true,
		ai_weighting_multiplier = 1,
		suggestion_icon = "3k_dlc07_faction_council_suggestion_economics.png",
		incident_key_source = nil,
		incident_blocks_effects_source = nil,
		incident_key_target = nil,
		incident_blocks_effects_target = nil,
		incident_key_global = nil,
		use_distance_weighting_mod = false
	},
	["issue_increase_peasantry_economy_focus"] = {
		effect_target = function(modify_faction, modify_model)
			return faction_council:issue_increase_peasantry_economy_focus(modify_faction:query_faction())
		end,
		weighting_value = 70, -- Weighting priority for the issue
		personality_priorities = { -- How relevant this issue is to each personality type
			dominance = 0.25,
			influence = 0.5,
			conscientious = 1,
			steadiness = 0.75,
		},
		scope = "faction",
		effect_bundle_key = "3k_dlc07_issue_increase_peasantry_economy_focus",
		effect_bundle_duration = 5,
		cost = 0,
		applies_scripted_effect = false,
		available_to_ai = true,
		ai_weighting_multiplier = 1,
		suggestion_icon = "3k_dlc07_faction_council_suggestion_economics.png",
		incident_key_source = nil,
		incident_blocks_effects_source = nil,
		incident_key_target = nil,
		incident_blocks_effects_target = nil,
		incident_key_global = nil,
		use_distance_weighting_mod = false
	},
	["issue_increase_industry_economy_focus"] = {
		effect_target = function(modify_faction, modify_model)
			return faction_council:issue_increase_industry_economy_focus(modify_faction:query_faction())
		end,
		weighting_value = 70, -- Weighting priority for the issue
		personality_priorities = { -- How relevant this issue is to each personality type
			dominance = 0.25,
			influence = 0.5,
			conscientious = 1,
			steadiness = 0.75,
		},
		scope = "faction",
		effect_bundle_key = "3k_dlc07_issue_increase_industry_economy_focus",
		effect_bundle_duration = 5,
		cost = 0,
		applies_scripted_effect = false,
		available_to_ai = true,
		ai_weighting_multiplier = 1,
		suggestion_icon = "3k_dlc07_faction_council_suggestion_economics.png",
		incident_key_source = nil,
		incident_blocks_effects_source = nil,
		incident_key_target = nil,
		incident_blocks_effects_target = nil,
		incident_key_global = nil,
		use_distance_weighting_mod = false
	},
}

--***********************************************************************************************************
--***********************************************************************************************************
-- HELPERS

function faction_council:get_newly_recruited_characters(faction_name)	
	local temp_list = {}

	-- Don't allow returning new characters for the first turn or two, as some startpos characters don't have histories in factions and we don't have time to re-do all the data.
	if cm:turn_number() > 1 then
		local new_chars = cm:query_faction(faction_name):character_list():filter(function(char) 
			local rounds_in_faction = char:rounds_in_current_faction();
			return rounds_in_faction > 0 and rounds_in_faction < 5 and not misc:is_transient_character(char) and char:has_come_of_age();
		end);

		new_chars:foreach(function(char) table.insert(temp_list, char:cqi()) end);
	end

	return temp_list;

end;

function faction_council:get_neutral_factions(faction) -- tested 08/10/2020
	-- takes a faction interface and returns a list of faction interfaces who are diplomatically neutral

	local filtered_faction_list = cm:query_model():world():faction_list():filter(function(filter_faction) -- Filtiering the faction list using a function predicate (use world faction list as neutral factions need not have contact)
		if filter_faction:is_dead() then
			return false; -- filtering out dead factions
		end;
		if filter_faction == faction then
			return false; -- filtering out the source faction
		end;
		if filter_faction:name() == invasion_faction_key then
			return false; -- filtering out the looters faction
		end;
		if filter_faction:has_specified_diplomatic_deal_with("treaty_components_vassalage", faction) then
			return false; -- filtering out factions the source faction has signed a vassalage with
		end;
		
		local allied_factions = nil;
		if diplomacy_manager:is_faction_in_alliance(faction:name()) then
			allied_factions = diplomacy_manager:get_all_factions_in_alliance(faction:name()); -- adding alliance members to a list if the faction is in a military alliance
		elseif diplomacy_manager:is_faction_in_coalition(faction:name()) then
			allied_factions = diplomacy_manager:get_all_factions_in_coalition(faction:name()); -- adding alliance members to a list if the faction is in a coalition
		end;
		
		if allied_factions ~= nil then
			for i = 0, allied_factions:num_items() - 1 do
				local allied_vassal_factions_list = diplomacy_manager:get_all_vassal_factions(allied_factions:item_at(i))
				for k = 0, allied_vassal_factions_list:num_items() - 1 do
					if allied_vassal_factions_list:item_at(k) == filter_faction then
						return false; -- filtering vassals of allies from the list of world factions
					end;
				end;
				if allied_factions:item_at(i) == filter_faction then
					return false; -- filtering allies from the list of world factions
				end;
			end;
		end; 
		return true; -- faction is neutral or enemy
	end)
	return filtered_faction_list;
end;

function faction_council:get_mobile_forces_with_generals_for_faction(query_faction)
	return query_faction:military_force_list():filter(function(mf)
		return not mf:is_armed_citizenry() -- ignore garrisons.
			and mf:has_general()
			and not misc:is_transient_character(mf:general_character())
			and not mf:unit_list():is_empty()
	end);
end;


-- Suggestion tests.
function faction_council:faction_occupies_regions_with_n_or_more_forces(faction_key, region_list, minimum_match_count)
	-- Check that the faction exists
	if not cm:query_faction(faction_key) or cm:query_faction(faction_key):is_null_interface() then
		script_error("ERROR: faction_council:faction_has_forces_in_regions - supplied parameter (faction_key) has value ".. faction_key .." which returns nil or a null interface.");
		return nil;
	end;
	-- Check the region list has a table of values
	if not region_list or table.is_empty(region_list) then
		script_error("ERROR: faction_council:faction_has_forces_in_regions - supplied parameter (region list) is empty, table of region keys expected.");
		return nil;
	end;
	-- Check the region list contains valid region keys
	for i =1, #region_list do
		if cm:query_region(region_list[i]) == nil or cm:query_region(region_list[i]):is_null_interface() then
			script_error("ERROR: faction_council:faction_has_forces_in_regions - supplied parameter (region list) list contains value ".. region_list[i].." which is not a valid region key");
			return nil;
		end;
	end;
	-- Check that the numeric criteria supplied is a number
	if not is_number(minimum_match_count) then
		script_error("ERROR: faction_council_world_data_queries:faction_has_forces_in_regions - supplied parameter (minimum_match_count) has value ".. minimum_match_count .." integer expected.");
		return nil;
	end;

	-- If the faction is dead it cannot have any armies
	if cm:query_faction(faction_key):is_dead() then
		return false;
	end;

	local invasion_region_region_list = region_list;
	local invasion_faction_army_list = cm:query_faction(faction_key):military_force_list();
	local army_occupation_count = 0;

	-- Check the faction has forces
	if not invasion_faction_army_list:is_empty() then
		for i =0, invasion_faction_army_list:num_items() -1 do
			-- Check the region in which each of this factions armies are currently in, if they inhabit one of the regions in the supplied list add to count
			if not invasion_faction_army_list:item_at(i) or not invasion_faction_army_list:item_at(i):is_null_interface() ~= nil then
				if not invasion_faction_army_list:item_at(i):region():is_null_interface() and table.contains(invasion_region_region_list, invasion_faction_army_list:item_at(i):region():name()) then
					army_occupation_count = army_occupation_count +1;

					-- If the number of forces inhabiting regions exeeds the supplied minimum return true
					if army_occupation_count >= minimum_match_count then
						return true;
					end
				end;
			end;
		end;
	end;
	
	-- If this faction does not exist or has an insufficient number of forces in the provided regions return false
	return false;
end;

local function get_n_most_major_factions_unsorted(n)
	local faction_list = cm:query_model():world():faction_list():filter(function(fac) 
		return not fac:is_dead() and fac:name() ~= "3k_main_faction_han_empire" 
	end);

	local major_factions = {}; -- stored as {faction_key, value}

	faction_list:foreach(function(faction)
		local criteria_val = faction:region_list():num_items();

		if #major_factions == 0 then
			table.insert(major_factions, {faction:name(), criteria_val});
		else
			for i, faction_data in ipairs(major_factions) do
				if criteria_val > faction_data[2] then
					table.insert(major_factions, i, {faction:name(), criteria_val});
					
					if #major_factions > n then
						table.remove(major_factions);
					end;

					break; -- Since we've likely manipulated the table, always break out so we don't iterate over bad data.
				end;
			end;

			if #major_factions < n then
				table.insert(major_factions, {faction:name(), criteria_val});
			end;
		end
	end);

	local return_list = {};
	for i, faction_data in ipairs(major_factions) do
		table.insert(return_list, faction_data[1]);
	end;

	return return_list;
end;

--***********************************************************************************************************
--***********************************************************************************************************
-- WORLD QUERIES

function faction_council:issue_own_army_low_supplies(faction) -- tested 07/10/2020
	-- Force running low on supplies issue checks for owned armies with supplies under a defined threshold and if they exist returns a force list of valid targets to apply subsequent effect bundles to

	if not faction or faction:is_null_interface() then
		return nil;
	end;

	local filtered_force_list = faction:military_force_list()
	
	if filtered_force_list:num_items() > 0 then
		filtered_force_list = filtered_force_list:filter(function(filter_force) -- could use "find_if" instead of "filter" to return a single force CQI
			return not filter_force:is_armed_citizenry() -- force is not a garrison
				and filter_force:morale() <= force_low_morale_threshold -- force morale returned int value is less than the threshold
				and not filter_force:is_in_own_territory()
		end)
	end;
	if not filtered_force_list:is_empty() then
		return filtered_force_list:item_at(cm:random_int(0, filtered_force_list:num_items()-1)):command_queue_index();
	else
		return nil;
	end;
end;

function faction_council:issue_hostile_army_in_own_territory(faction) -- tested 07/10/2020
	-- Redeploy forces rapidly

	if not faction or faction:is_null_interface() then
		return nil;
	end;

	local war_factions =  diplomacy_manager:factions_at_war_with(faction:name()) -- returns a list of factions who are hostile to the source faction
	local filtered_character_list = cm:query_model():world():character_list():filter(function(filter_character) -- could use "find_if" instead of "filter" to return a single force CQI
		return not filter_character:is_dead() -- character is dead
		and filter_character:has_military_force() -- character is leading military force
		and filter_character:faction() ~= faction
		and war_factions:contains(filter_character:faction()) -- owning faction of target character is not at war with us
		and filter_character:has_region() -- region character is in has a null interface (don't think this should ever happen?)
		and not filter_character:region():owning_faction():is_null_interface() -- owning faction of regio nthe character is in has a null interface (could be rebels)
		and filter_character:region():owning_faction() == faction;-- region owner is not the source faction
	end)

	if not filtered_character_list:is_empty() then 
		-- if there are hostile characters in one of the source factions regions it will be on this list
		return filtered_character_list:item_at(cm:random_int(0, filtered_character_list:num_items()-1)):military_force():command_queue_index(); -- Who the effect will target
	else
		return nil;
	end;
end;

function faction_council:issue_rapid_force_redeployment(faction) -- tested 06/10/2020
	-- Rapid force redeployment is considered viable if the faction has too few forces to cover their size of held territory, it returns an integer value which is the number of forces divided by the number of regions
	
	if not faction or faction:is_null_interface() then
		return nil;
	end;
	
	local filtered_force_list = faction:military_force_list():filter(function(force_list) -- Filtiering the force list of this faction by function predicate
		return not force_list:is_armed_citizenry() -- Force is not a garrison
	end)
	
	if faction:region_list():num_items() > filtered_force_list:num_items()*low_force_to_region_ratio_threshold then
		-- Simple check to compare ratio of number of owned regions against number of deployed forces * multiplier
		return faction:command_queue_index();-- Who the effect will target
	else
		return nil;
	end;
end;

function faction_council:issue_hostile_armies_replenishing(faction) -- tested 08/10/2020
	-- Enemy armies resupplying/replenishing can be debuffed to delay them returning to combat effective strength

	if not faction or faction:is_null_interface() then
		return nil;
	end;

	local function get_replenishing_forces(query_faction)
		local armies = self:get_mobile_forces_with_generals_for_faction(query_faction);

		return armies:filter(function(filter_force) -- Generate a filtered list of this query factions forces
			return filter_force:is_in_own_territory() -- force is in own territory	
				and (filter_force:morale() <= force_low_morale_threshold -- Force morale returned int value is less than the threshold
				or (filter_force:morale() <= 100 and filter_force:is_replenishing())) -- Look for a force replenishing who've lost some supplies recently (should help ignore newly recruited forces).
		end)
	end;

	local highest_threat_level = 0
	local highest_threat_faction = nil
	local war_factions = diplomacy_manager:factions_at_war_with(faction:name()) -- returns a list of factions who are hostile to the source faction
	
	if not war_factions:is_empty() then
		war_factions = war_factions:filter(function(faction) -- The factions list is being filtered to look for factions with a specified number of forces which are below a minimum morale threshold and are in their own territory
			return get_replenishing_forces(faction):num_items() >= minimum_number_of_low_morale_forces -- Return true if the number of low morale forces exceeds the minimum threshold
		end)
	end;

	for i = 0, war_factions:num_items() -1 do -- Iterate through the private war factions and sum the strength of their armies, if the total is greater than the largest current total we set them as the highest threat
		local cumulative_force_strength = 0
		for k = 0, war_factions:item_at(i):military_force_list():num_items() -1 do
			if not war_factions:item_at(i):military_force_list():item_at(k):is_armed_citizenry() then
				cumulative_force_strength = cumulative_force_strength + war_factions:item_at(i):military_force_list():item_at(k):strength()
			end;
		end;
		if cumulative_force_strength > 0 and cumulative_force_strength > highest_threat_level then
			highest_threat_level = cumulative_force_strength
			highest_threat_faction = war_factions:item_at(i)
		end
	end;

	if highest_threat_faction ~= nil then
		local armies = get_replenishing_forces(highest_threat_faction);

		if armies:num_items() > 0 then
			-- We have at least one faction which is hostile and has a low morale army to target
			return armies:item_at(cm:random_int(0, armies:num_items()-1)):command_queue_index(); -- Who the effect will target
		end;
	end;
	
	--We found no valid targets, so return nil
	return nil;
	
end;

function faction_council:issue_retrain_army_rosters(faction) -- tested 06/10/2020
	-- Here we are looking to check the number of militia units making up the factions forces, there may be reasons for this choice. However we aim to incentivize the player to upgrade their armies over the course of a campaign

	if not faction or faction:is_null_interface() then
		return nil;
	end;

	local sum_low_tier_units = 0;
	local sum_total_units = 0;
	

	if faction:military_force_list():num_items() == 0 then
		return nil;
	end;

	local valid_forces = self:get_mobile_forces_with_generals_for_faction(faction);

	valid_forces:foreach(function(mf) 
		sum_low_tier_units = sum_low_tier_units + mf:unit_list():count_if(function(unit) 
			return table.contains(militia_unit_keys,unit:unit_key()) end);

		sum_total_units = sum_total_units + mf:unit_list():num_items()
	end)

	if sum_total_units > 0 and sum_low_tier_units/sum_total_units >= force_low_tier_unit_ratio_threshold then
		 -- If the ratio of low tier units exceeds the threshold we add this issue to the valid list
		return faction:command_queue_index(); -- Who the effect will target
	else
		return nil;
	end;
end;

function faction_council:issue_own_armies_in_enemy_territory(faction)
	-- We want to check to see if the curtrent faction has forces deployed aggressively, presently we cannot check the region in which a force is situated. The alternative approach
	-- is to look for the effect bundle applied to an army which has spent a turn in hostile territory.

	if not faction or faction:is_null_interface() then
		return nil;
	end;

	local war_factions = diplomacy_manager:factions_at_war_with(faction:name()) -- returns a list of factions who are hostile to the source faction
	local filtered_force_list = faction:military_force_list():filter(function(filter_force) -- Filtiering the force list of this faction by function predicate
		if filter_force:region() == nil or filter_force:region():is_null_interface() then -- ignore cases where forces are in regions that are null or nill interfaces
			return false;
		end;
		if filter_force:region():owning_faction() == nil or filter_force:region():owning_faction():is_null_interface() then -- ignore cases where forces are in regions not owned by any faction
			return false;
		end;
		return war_factions:contains(filter_force:region():owning_faction())
	end)

	if filtered_force_list:num_items() >= min_number_of_armies_in_hostile_territory then 
		-- There may be the chance that a single force is enemy territory, for the sake of tuning the issue requirements we use a defined minimum number of aggressively deployed forces (more than one).
		return filtered_force_list:item_at(cm:random_int(0, filtered_force_list:num_items()-1)):command_queue_index(); -- Who the effect will target
	else
		return nil;
	end;
	
end;

function faction_council:issue_own_armies_in_non_allied_territory_without_siege_engines(faction) -- tested 09/10/2020
	-- The intent of this issue is to look for the faction having deployed forces in hostile lands without siege engines, not having siege engines with a force means delays on attacking walled settlements

	if not faction or faction:is_null_interface() then
		return nil;
	end;

	local filtered_factions_list = faction_council:get_neutral_factions(faction) -- returns a list of factions with neutral diplomatic standing to the active faction
	local war_factions = diplomacy_manager:factions_at_war_with(faction:name()) -- returns a list of factions who are hostile to the source faction

	local filtered_region_list = cm:query_model():world():region_manager():region_list():filter(function(filter_region)
		return filtered_factions_list:contains(filter_region:owning_faction()) or
		war_factions:contains(filter_region:owning_faction()) -- returns a list of regions held by non-friendly factions
	end)

	local filtered_force_list = faction:military_force_list():filter(function(filter_force) -- returns a list of military forces in non-friendly regions
		if not filter_force:is_null_interface() then
			if not filter_force:region():is_null_interface() and filter_force:region() ~= nil then
				return filtered_region_list:contains(filter_force:region());
			end;
		end;

		return false; -- army is a null interface
	end)

	-- Script only works when you besiege AFTER triggering, not if you're already besieging. Sadly we don't have a reliable way of building equipment for an in progress siege.
	filtered_force_list = filtered_force_list:filter(function(filter_force) 
		return filter_force:has_general() and not filter_force:general_character():is_besieging();
	end)

	filtered_force_list = filtered_force_list:filter(function(filter_force) -- Filtering the force list of this faction by function predicate
		local has_siege_engine
		for i = 0, filter_force:unit_list():num_items()-1 do
			if table.contains(siege_engine_unit_keys, filter_force:unit_list():item_at(i):unit_key()) then -- Passing each unit key in the unit list to a function along with a table of siege engine unit keys to check for a match
				has_siege_engine = true; -- Force contains at least one siege engine
			end;
		end;	
		return not has_siege_engine; -- Force has no siege engines
	end)

	if not filtered_force_list:is_empty() then 
		-- We have at least one army in enemy territory and none of our forces in enemy territory have siege equipment
		return filtered_force_list:item_at(cm:random_int(0, filtered_force_list:num_items()-1)):command_queue_index(); -- Who the effect will target
	else
		return nil;
	end;
end;

function faction_council:issue_own_army_in_non_allied_territory(faction) -- tested 09/10/2020
	-- Determine if we have forces deployed outside of our own territory

	if not faction or faction:is_null_interface() then
		return nil;
	end;

	local filtered_factions_list = faction_council:get_neutral_factions(faction) -- returns a list of factions with neutral diplomatic standing to the active faction
	local war_factions = diplomacy_manager:factions_at_war_with(faction:name()) -- returns a list of factions who are hostile to the source faction

	local filtered_region_list = cm:query_model():world():region_manager():region_list():filter(function(filter_region)
	return filtered_factions_list:contains(filter_region:owning_faction()) or
		war_factions:contains(filter_region:owning_faction()) -- returns a list of regions held by non-friendly factions
	end)

	local filtered_force_list = faction:military_force_list():filter(function(filter_force) -- returns a list of military forces in non-friendly regions
		if not filter_force:is_null_interface() and filter_force ~= nil then
			if not filter_force:region():is_null_interface() and filter_force:region() ~= nil then
				return filtered_region_list:contains(filter_force:region());
			else
				return false; -- this army is not in a region
			end;
		else
			return false; -- army is a null interface
		end;
	end)

	if filtered_force_list:num_items() >= minimum_forces_in_neutral_territory_without_siege_engines then 
		-- Check if the number of characters in non-allied regions exceeds the minimum reguiirement
		return filtered_force_list:item_at(cm:random_int(0, filtered_force_list:num_items()-1)):command_queue_index(); -- Who the effect will target
	else
		return nil;
	end;
end;

function faction_council:issue_own_unit_lists_contain_high_ratio_of_cavalry(faction) -- tested 08/10/2020
	-- Look at the sum of all active army unit lists and check if the faction is cavalry focused

	if not faction or faction:is_null_interface() then
		return nil;
	end;

	local sum_cavalry_units = 0;
	local sum_total_units = 0;

	local valid_forces = self:get_mobile_forces_with_generals_for_faction(faction);

	valid_forces:foreach(function(mf) 
		sum_cavalry_units = sum_cavalry_units + mf:unit_list():count_if(function(unit) 
			return unit:unit_class() == "cav_shk" or unit:unit_class() == "cav_mis" or unit:unit_class() == "cav_mel" end);
		sum_total_units = sum_total_units + mf:unit_list():num_items()
	end)

	if sum_total_units > 0 and sum_cavalry_units/sum_total_units >= faction_forces_unit_role_bias_ratio_threshold then 
		-- If the ratio of low tier units exceeds the threshold we add this issue to the valid list
		return faction:command_queue_index(); -- Who the effect will target
	else
		return nil;
	end;
end;

function faction_council:issue_own_unit_lists_contain_high_ratio_of_melee_infantry(faction) -- tested 08/10/2020
	-- Look at the sum of all active army unit lists and check if the faction is melee infantry focused

	if not faction or faction:is_null_interface() then
		return nil;
	end;

	local sum_melee_infantry_units = 0;
	local sum_total_units = 0;

	local valid_forces = self:get_mobile_forces_with_generals_for_faction(faction);

	valid_forces:foreach(function(mf) 
		sum_melee_infantry_units = sum_melee_infantry_units + mf:unit_list():count_if(function(unit) 
			return unit:unit_class() == "inf_mel" end);
		sum_total_units = sum_total_units + mf:unit_list():num_items()
	end)

	if sum_total_units > 0 and sum_melee_infantry_units/sum_total_units >= faction_forces_unit_role_bias_ratio_threshold then 
		-- If the ratio of low tier units exceeds the threshold we add this issue to the valid list
		return faction:command_queue_index(); -- Who the effect will target
	else
		return nil;
	end;
end;

function faction_council:issue_own_unit_lists_contain_high_ratio_of_ranged_units(faction) -- tested 06/10/2020
	-- Look at the sum of all active army unit lists and check if the faction is ranged focused

	if not faction or faction:is_null_interface() then
		return nil;
	end;

	local sum_missile_units = 0;
	local sum_total_units = 0;

	local valid_forces = self:get_mobile_forces_with_generals_for_faction(faction);

	valid_forces:foreach(function(mf) 
		sum_missile_units = sum_missile_units + mf:unit_list():count_if(function(unit) 
			return unit:unit_class() == "inf_mis" or unit:unit_class() == "cav_mis"
		end);

		sum_total_units = sum_total_units + mf:unit_list():num_items()
	end)

	if sum_total_units > 0 and sum_missile_units/sum_total_units >= faction_forces_unit_role_bias_ratio_threshold then 
		-- If the ratio of low tier units exceeds the threshold we add this issue to the valid list
		return faction:command_queue_index(); -- Who the effect will target
	else
		return nil;
	end;
end;

function faction_council:issue_own_army_unit_list_experience_amount_low(faction) -- tested 07/10/2020
	-- Look at the sum of all active army unit lists and check if the faction is ranged focused
	
	if not faction or faction:is_null_interface() then
		return nil;
	end;

	local filtered_force_list = faction:military_force_list():filter(function(filter_force) -- Filtiering the force list of this faction by function predicate
		if not misc:is_transient_character(filter_force:general_character()) and not filter_force:is_armed_citizenry() and not filter_force:unit_list():is_empty() then -- Only check for mobile forces and not garrisons
			local sum_low_experience_units = 0;-- The sum numberof low tier units of this army

			for i = 0, filter_force:unit_list():num_items() -1 do -- We iterate through the units in the force roster looking for units with an experience value under the low experience threshold
				if filter_force:unit_list():item_at(i):experience_level() <= force_low_unit_experience_threshold then
					sum_low_experience_units = sum_low_experience_units + 1 -- if we find a unit under the low experience threshold we increase the sum count
					if sum_low_experience_units / filter_force:unit_list():num_items() >= faction_forces_unit_role_bias_ratio_threshold then
						return true; -- Force contains mostly low experience level units
					end;
				end;
			end;
			return false; -- Force has more than units over the lowe experience threshold than the unit ratio threshold
		end;
		return false; -- Force is not a regular army
	end)

	if not filtered_force_list:is_empty() then -- If there is an army mostly made of low tier units we return the CQI of a random force on the list
		return filtered_force_list:item_at(cm:random_int(0, filtered_force_list:num_items()-1)):command_queue_index();
	else
		return nil;
	end;
end;

function faction_council:issue_incomplete_ceo_set(faction) -- tested 08/10/2020 
	-- Looking for equipable CEO's in the factions ancillary bank and checking for set items, in the event of holding at least one of an item set generate an issue and return missing ancillary key
	
	if not faction or faction:is_null_interface() then
		return nil;
	end;

	local all_faction_ceos = faction:ceo_management():all_ceos();
	local missing_set_ceo_keys_list  = {};

	for set_name, ceos_in_set in pairs(ceo_sets_list) do
		local missing_ceos = {};

		for i, ceo_key in ipairs(ceos_in_set) do
			if all_faction_ceos:none_of(function(ceo) return ceo:ceo_data_key() == ceo_key end) then
				table.insert(missing_ceos, ceo_key);
			end;
		end;

		-- Only add if we own at least one ceo in the set and at least one is missing.
		if #missing_ceos > 0 and #ceos_in_set - #missing_ceos > 0   then
			for i, ceo_key in ipairs(missing_ceos) do
				table.insert(missing_set_ceo_keys_list, ceo_key);
			end;
		end;
	end;

	if table.is_empty(missing_set_ceo_keys_list) then
		return nil;
	end;

	return missing_set_ceo_keys_list[cm:random_int(1, #missing_set_ceo_keys_list)]; -- if we have at least 1 ceo key in the missing_set_ceo_keys_list we add this issue and return a ceo data key from the list at random 
end;

function faction_council:issue_few_unassigned_ancillaries(faction) -- tested 08/10/2020
	-- Looking for equipable CEO's in the factions anciallry bank and checking for set items, in the event of holding only one of a item set generate an issue and return missing ancillary key
	
	if not faction or faction:is_null_interface() then
		return nil;
	end;

	local filtered_ceo_list = faction:ceo_management():all_ceos():filter(function(filter_ceo) -- Filters the faction ancillary list to include only equippable CEOs
		return filter_ceo:category_key() == "3k_main_ceo_category_ancillary_weapon"
		or filter_ceo:category_key() == "3k_main_ceo_category_ancillary_armour"
		or filter_ceo:category_key() == "3k_main_ceo_category_ancillary_mount"
		or filter_ceo:category_key() == "3k_main_ceo_category_ancillary_follower"
		or filter_ceo:category_key() == "3k_main_ceo_category_ancillary_accessory"
	end)

	local total_ceos = filtered_ceo_list:num_items()
	local num_equipped_ceos = filtered_ceo_list:count_if(function(ceo) return ceo:is_equipped_in_slot() end);
	if total_ceos - num_equipped_ceos <= minimum_unequipped_ceo_threshold then
		-- if we have fewer than the minimum number of unassigned CEOs we add the issue to the list and return the number of unassigned ancilliaries
		return faction:command_queue_index(); 
	else
		return nil;
	end;
end;

function faction_council:issue_own_character_loyalty_low(faction)
	-- Looking at the factions' character loyalty levels and returning a suitable candidate/s who is under the specified threshold
	
	if not faction or faction:is_null_interface() then
		return nil;
	end;

	local lowest_loyalty = 999;
	local lowest_loyalty_character_cqi
	local filtered_character_list = faction:character_list():filter(function(filter_character) -- Filtiering the force list of this faction by function predicate
		if not filter_character:is_dead() then -- Only check for living characters
			if filter_character:loyalty() < low_character_loyalty_threshold then -- Looking for "low" loyalty characters
				if filter_character:loyalty() < lowest_loyalty then -- Additional filtering, we may want to change this in the future to just return the filtered list
					lowest_loyalty = filter_character:loyalty()
					lowest_loyalty_character_cqi = filter_character:command_queue_index()
				end;
				return true; -- Character is under the low loyalty threshold
			end;
			return false; -- Character is over or equal to the low loyalty threshold
		end;
	end)

	if not filtered_character_list:is_empty() then
		-- If there are low loyalty characters we return the CQI of the lowest loyalty character
		return lowest_loyalty_character_cqi;
	else
		return nil;
	end;
end;

function faction_council:issue_own_character_low_rank(faction) -- tested 07/10/2020
	-- Check the levels of all characters in the faction (who are not the faction leader), filter the list down to find low level characters who will benefit most from a level increase.
	
	if not faction or faction:is_null_interface() then
		return nil;
	end;

	local filtered_character_list = faction:character_list():filter(function(filter_character) -- Filtiering the force list of this faction by function predicate
		return not filter_character:is_dead() -- Only check for living characters
			and filter_character:character_post() ~= "faction_leader" -- Only check for non-faction leaders
			and filter_character:character_type("general") -- only apply to generals
			and filter_character:has_come_of_age() -- Only check for characters who are adults
			and filter_character:rank() < low_characater_rank_threshold  -- Looking for "low" rank/level characters
	end)

	if not filtered_character_list:is_empty() then 
		-- If there are low rank characters in the filtered list we pull out one of the characters at random and return it's CQI along with the issue key
		return filtered_character_list:item_at(cm:random_int(0, filtered_character_list:num_items()-1)):command_queue_index();
	else
		return nil;
	end;
end;

function faction_council:issue_own_character_unmarried(faction) -- untested
	-- Check all characters in the faction to see if they don't have a spouse and have come of age
	
	if not faction or faction:is_null_interface() then
		return nil;
	end;

	local filtered_character_list = faction:character_list():filter(function(filter_character) -- Filtiering the force list of this faction by function predicate
		return not filter_character:is_dead() -- Only check for living characters
			and filter_character:has_come_of_age() -- minimum age for a character to be considered an adult
			and filter_character:family_member():spouse():is_null_interface() -- Looking for unmarried characters
			and filter_character:family_member():is_in_faction_leaders_family() -- Gottas be related to leader
	end)

	if not filtered_character_list:is_empty() then 
		-- if we have characters who are eligible for marriage we return a random character from the list
		return filtered_character_list:item_at(cm:random_int(0, filtered_character_list:num_items()-1)):command_queue_index();
	else
		return nil;
	end;
end;

function faction_council:issue_own_character_recruited_at_higher_rank(faction) -- tested 07/10/2020
	-- Pass in the character list from when the last faction council was convened, look for new additions and check if they areworth resetting skills for
	
	if not faction or faction:is_null_interface() then
		return nil;
	end;

	local recruited_characters_table = faction_council:get_newly_recruited_characters(faction:name())

	local recruited_character_list = faction:character_list():filter(function(filter_character) -- Filtiering the force list of this faction by function predicate
		return not filter_character:is_dead() -- Only check for living characters
			and filter_character:character_subtype_key() ~= "3k_general_nanman"
			and filter_character:rank() >= low_characater_rank_threshold -- looking for characters over the minimum rank, it would not be worth resetting skills of characters under this level and it also filters out newborn characters
			and table.contains(recruited_characters_table, filter_character:command_queue_index())
	end);

	if not recruited_character_list:is_empty() then 
		-- if we have characters who have been recently recruited and are over the rank threshold we return one from the list at random
		return recruited_character_list:item_at(cm:random_int(0, recruited_character_list:num_items()-1)):command_queue_index();
	else
		return nil;
	end;
end;

function faction_council:issue_no_characters_recruited_recently(faction) -- tested 07/10/2020
	-- Pass in the character list from when the last faction council was convened, if there were no additional characters this season this issue becomes valid
	
	if not faction or faction:is_null_interface() then
		return nil;
	end;

	local recruited_characters_table = faction_council:get_newly_recruited_characters(faction:name())
	
	if table.is_empty(recruited_characters_table) then 
		-- if there are no new characters retun the issue along with the CQI of the faction
		return faction:command_queue_index()
	else
		return nil;
	end;
end;

function faction_council:issue_enemy_character_wounded_but_not_killed(faction) -- tested 08/10/2020
	-- Pass in a faction, find out who they are at war with and look for wounded characters, if we find a wounded character this issue is valid
	
	if not faction or faction:is_null_interface() then
		return nil;
	end;

	local wounded_characters_cqi_list ={}
	local war_factions = diplomacy_manager:factions_at_war_with(faction:name()) -- returns a list of factions who are hostile to the source faction

	if not war_factions:is_empty() then
		war_factions = war_factions:filter(function(filter_faction) -- The factions list is being filtered to look for factions with wounded characters
			local filtered_character_list = filter_faction:character_list()
			filtered_character_list = filtered_character_list:filter(function(filter_character) -- Generate a filtered list of this query factions forces
				if filter_character:is_wounded() and not filter_character:is_dead() then -- Character is currently wounded
					wounded_characters_cqi_list[#wounded_characters_cqi_list + 1] = filter_character:command_queue_index() -- Add the character CQI to the list of possible target characters
					return true;
				end;
				return false;
			end)
			return not filtered_character_list:is_empty() -- Return true if this faction had a wounded character
		end)
	end;

	if not table.is_empty(wounded_characters_cqi_list) then 
		-- If the wounded character list is not empty this issue is valid and we return the character CQI of one of the wounded characters at random
		return wounded_characters_cqi_list[cm:random_int(1, #wounded_characters_cqi_list)];
	else
		return nil;
	end;	
end;

function faction_council:issue_enemy_faction_leader_in_foreign_territory(faction) -- tested 07/10/2020 (ignore military_force null interface assert)
	-- Check all faction leaders belonging to factions we are at war with, check if they do not have the effect bundle of being in their own territory, if so this issue is valid
	
	if not faction or faction:is_null_interface() then
		return nil;
	end;

	local faction_leaders_in_foreign_land_cqi_list ={}
	local war_factions = diplomacy_manager:factions_at_war_with(faction:name()) -- returns a list of factions who are hostile to the source faction

	if not war_factions:is_empty() then -- only check if this faction is at war with others	
		cm:query_model():world():character_list():filter(function(filter_character) -- Generate a filtered list of this query factions forces
			if filter_character:has_military_force() then -- character is currently deployed in a military force
				if war_factions:contains(filter_character:faction()) and
				filter_character:is_faction_leader() and -- character must be a faction leader
				not filter_character:military_force():is_in_own_territory() then -- military force of character is not in home teriotry
					table.insert(faction_leaders_in_foreign_land_cqi_list, filter_character:command_queue_index()) -- Add the character CQI to the list of possible target characters
					return true; -- returns true if this character is a faction leader in a force in foreign land
				end;
				return false;
			end;
			return false;
		end)
	end;

	if not table.is_empty(faction_leaders_in_foreign_land_cqi_list) then 
		-- If the faction leaders in foreign land list is not empty this issue is valid and we return the character CQI of one of the wounded characters at random
		return faction_leaders_in_foreign_land_cqi_list[cm:random_int(1, #faction_leaders_in_foreign_land_cqi_list)];
	else
		return nil;
	end;	
end;

function faction_council:issue_own_character_has_undesirable_traits(faction) -- tested 09/10/2020
	-- Look at all characters in the current faction and check their personality traits for ones which are predominantly negative, if such characters exist this issue is valid
	
	if not faction or faction:is_null_interface() then
		return nil;
	end;

	local filtered_character_list = faction:character_list():filter(function(character) -- Filtiering the force list of this faction by function predicate
		if not character:is_dead() then -- Only check for living characters
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

function faction_council:issue_valuable_high_satisfaction_character_in_enemy_faction(faction) -- tested 08/10/2020
	-- We are looking for high level characters in enemy factions which would be difficult to turn through the use of spy actions, higher satisfaction characters are largely static which is a problem
	
	if not faction or faction:is_null_interface() then
		return nil;
	end;

	local war_factions = diplomacy_manager:factions_at_war_with(faction:name()) -- returns a list of factions who are hostile to the source faction
	local filtered_character_list = cm:query_model():world():character_list():filter(function(filter_character) -- Filtiering the force list of this faction by function predicate
		if not filter_character:is_dead() and not filter_character:is_faction_leader() then -- Only check for living characters and non-faction leaders
			if war_factions:contains(filter_character:faction()) and 
			filter_character:rank() >= high_characater_rank_threshold and 
			filter_character:loyalty() >= high_character_loyalty_threshold then -- Looking for characters in enemy factions, are generally content with the faction and are higher level
				return true;
			end;
			return false; -- is not a high level character in an enemy faction with high loyalty
		end;
		return false; -- character is dead or a faction leader
	end)

	if not filtered_character_list:is_empty() then 
		-- if we have characters who are eligible for marriage we return a random character CQI from the list
		return  filtered_character_list:item_at(cm:random_int(0, filtered_character_list:num_items()-1)):command_queue_index();
	else
		return nil;
	end;	
end;

function faction_council:issue_own_region_low_public_order(faction) -- tested 08/10/2020
	-- We are looking for regions with low public order that the current faction owns, if we find any this issue is valid
	
	if not faction or faction:is_null_interface() then
		return nil;
	end;

	local filtered_region_list = faction:region_list():filter(function(region) -- Filtiering the region list of this faction by function predicate
		return region:public_order() < low_public_order_threshold;
	end)

	if not filtered_region_list:is_empty() then 
		-- if regions with low public order exist on the list pull one at random, find the associated query provicne interface and return the CQI
		return filtered_region_list:item_at(cm:random_int(0, filtered_region_list:num_items()-1)):province():cqi();
	else
		return nil;
	end;	
end;

function faction_council:issue_own_region_underdeveloped(faction) -- tested 08/10/2020
	-- Checking for capital regions with low level infrastructure or a low number of building slots utilised, if the faction has some we validate this issue
	
	if not faction or faction:is_null_interface() then
		return nil;
	end;

	local filtered_region_list = faction:region_list():filter(function(region) -- Filtiering the region list of this faction by function predicate	
		if not region:is_province_capital() then -- We only want to apply this effect to region capitals
			return false;
		end;
		if region:pooled_resources():resource("3k_main_pooled_resource_population"):is_null_interface() or region:pooled_resources():resource("3k_main_pooled_resource_population"):maximum_value() == 0 then -- We wish to exclude regions which do not support population such as gate passes
			return false;	
		end;
		if region:slot_list():num_items() <= capital_minimum_building_count_threshold then -- This capital region has few secondary buildings, it can benefit greatly from construction buffs
			return true;
		end;
		 -- This is a capital region with more buildings than the minimum count, we need to check the development level of each particular building
		local underdevelopment_count = 0

		for i = 0, region:slot_list():num_items() - 1 do
			local slot = region:slot_list():item_at(i);
	
			if slot:has_building() then
				if string.find(slot:building():name(), "1") or string.find(slot:building():name(), "2") then -- building superchain building levels are appended to the name, we are checking for tier 1 and 2 buildings
					underdevelopment_count = underdevelopment_count + 1;
				end;
			end;
		end;
		return underdevelopment_count >= capital_region_infrastructure_underdeveloped_threshold; -- check if the sum of tier 1 and 2 buildings exceeds the maximum number of buildings we would deem acceptable
	end)

	if not filtered_region_list:is_empty() then 
		-- if we have a number of underdeveloped regions we pull a CQI from a region the list at random
		return filtered_region_list:item_at(cm:random_int(0, filtered_region_list:num_items()-1)):province():cqi();
	else
		return nil;
	end;
end;

function faction_council:issue_own_region_recently_attacked_or_is_sieged(faction) -- tested 08/10/2020
	-- Here we are trying to determine if the current faction has had one or more of it's regions attacked recently and has a weak garrison or if one of it's regions is actively under siege
	
	if not faction or faction:is_null_interface() then
		return nil;
	end;

	local filtered_region_list = faction:region_list():filter(function(region) -- Filtiering the force list of this faction by function predicate
		if region:garrison_residence():is_null_interface() or
			not region:garrison_residence():has_army() then -- region has no garrison so we do not care
			return false;
		end;
		if region:garrison_residence():is_under_siege() then -- region is currently sieged, source factions lands are under active attack
			return true;
		end;
		return region:garrison_residence():army():strength() <= low_unit_strength_threshold * region:garrison_residence():army():unit_list():num_items();
	end)

	if not filtered_region_list:is_empty() then 
		-- if we have a number of regions with weak garrisons or are sieged we pull a CQI from a region the list at random
		return filtered_region_list:item_at(cm:random_int(0, filtered_region_list:num_items()-1)):command_queue_index();
	else
		return nil;
	end;
end;

function faction_council:issue_highly_developed_enemy_region_with_own_army(faction) -- tested 08/10/2020
	-- looks at regions held by factions hostile to us and then checks if we have any forces present in these regions
	
	if not faction or faction:is_null_interface() then
		return nil;
	end;

	local filtered_factions_list = diplomacy_manager:factions_at_war_with(faction:name()) -- returns a list of factions who are hostile to the source faction
	local filtered_force_list = faction:military_force_list() -- returns a list of the source factions characters
	local filtered_region_list = cm:query_model():world():region_manager():region_list():filter(function(filter_region)
		if filtered_factions_list:contains(filter_region:owning_faction()) then -- returns a list of regions held by enemy factions
			for i = 0, filtered_force_list:num_items() -1 do
				if not filtered_force_list:item_at(i):is_null_interface() and not filtered_force_list:item_at(i):region():is_null_interface() then
					if filtered_force_list:item_at(i):region() == filter_region then
						return true; -- returns regions which have one or more of our characters in them
					end;
				end;
			end;
			return false;  -- force is a null interface or not currently deployed in a region
		end;
		return false; -- region is not owned by an enemy faction
	end)
		
	if not filtered_region_list:is_empty() then 
		-- returns true if there are one or more regions with one of our armies in them
		return filtered_region_list:item_at(cm:random_int(0, filtered_region_list:num_items()-1)):command_queue_index(); -- adds the issue to the list and returns the CQI of a region in which one of our forces is present
	else
		return nil;
	end;
end;

function faction_council:issue_own_region_low_on_supplies(faction) -- tested 09/10/2020
	-- Look for regions with low population levels belonging to the active faction, if enough exist this issue is valid
	
	if not faction or faction:is_null_interface() then
		return nil;
	end;

	local filtered_province_list = faction:faction_province_list():filter(function(province) -- Filtiering the force list of this faction by function predicate
		if province:pooled_resources():resource("3k_main_pooled_resource_supply") == nil or
		province:pooled_resources():resource("3k_main_pooled_resource_supply"):is_null_interface() then -- region has no suply stockpile
			return false;
		end;
		if province:pooled_resources():resource("3k_main_pooled_resource_supply"):percentage_of_capacity() <= pooled_resource_low_fill_percentage_threshold then -- region has low supply levels
			return true;
		end;
		return false;
	end)

	if not filtered_province_list:is_empty() then 
		-- if we have a number of regions with weak garrisons or are sieged we pull a region the list at random, and return the province CQI that it belongs to
		return filtered_province_list:item_at(cm:random_int(0, filtered_province_list:num_items()-1)):province():cqi();
	else
		return nil;
	end;
end;

function faction_council:issue_own_regions_low_percentage_capacity_for_population(faction) -- tested 08/10/2020
	-- Looking for settlements with low population percentage of capacity
	
	if not faction or faction:is_null_interface() then
		return nil;
	end;

	local filtered_region_list = faction:region_list():filter(function(region) -- Filtiering the force list of this faction by function predicate
		if not region:is_province_capital() or
		region:pooled_resources():resource("3k_main_pooled_resource_population"):is_null_interface() or 
		region:pooled_resources():resource("3k_main_pooled_resource_population") == nil then -- region has no population or is not a capital (we dont care about population levels of non-capital regions)
			return false;
		end;
		if region:pooled_resources():resource("3k_main_pooled_resource_population"):percentage_of_capacity() <= population_low_fill_percentage_threshold then -- region has low supply levels
			return true;
		end;
		return false;
	end)

	if filtered_region_list:num_items() >= regions_low_population_level_threshold then 
		-- if we have a number of regions with low population levels we return exactly how many
		return faction:command_queue_index();
	else
		return nil;
	end;
end;

function faction_council:issue_enemy_region_with_highly_developed_infrastructure(faction) -- tested 08/10/2020
	-- Looking for settlements held by enemy factions with high infrastructure investment
	
	if not faction or faction:is_null_interface() then
		return nil;
	end;

	local hostile_region_cqi_list ={}

	diplomacy_manager:factions_at_war_with(faction:name()):foreach(function(filter_faction)
		filter_faction:region_list():foreach(function(filter_region)
			if not filter_region:is_province_capital() then -- ignore non-capital regions
				return;
			end;
			if filter_region:slot_list():num_items() <= capital_minimum_building_count_threshold then -- This capital region has few secondary buildings and is therefore a poor choice of target
				return;
			end;

			local development_count = 0;
		
			for i = 0, filter_region:slot_list():num_items() - 1 do
				local slot = filter_region:slot_list():item_at(i);

				if slot:has_building() then
					if string.find(slot:building():name(), "10") then -- building superchain building levels are appended to the name, we are checking for tier 10 through to 1 and sum the building levels
						development_count = development_count + 10;
					elseif string.find(slot:building():name(), "9") then
						development_count = development_count + 9;
					elseif string.find(slot:building():name(), "8") then
						development_count = development_count + 8;
					elseif string.find(slot:building():name(), "7") then
						development_count = development_count + 7;
					elseif string.find(slot:building():name(), "6") then
						development_count = development_count + 6;
					elseif string.find(slot:building():name(), "5") then
						development_count = development_count + 5;
					elseif string.find(slot:building():name(), "4") then
						development_count = development_count + 4;
					elseif string.find(slot:building():name(), "3") then
						development_count = development_count + 3;
					elseif string.find(slot:building():name(), "2") then
						development_count = development_count + 2;
					else 
						development_count = development_count + 1; -- A few buildings have a single tier, we assume all tier 1 buildings as value of 1
					end;
				end;
			end;

			if development_count >= capital_region_infrastructure_developed_threshold then -- if the development sum is greater than the threshold this region remains on the list
				table.insert(hostile_region_cqi_list, filter_region:command_queue_index()) -- add this region to the targets list
			end;
		end)
	end)

	if not table.is_empty(hostile_region_cqi_list) then 
		return hostile_region_cqi_list[cm:random_int(1, #hostile_region_cqi_list)];
	else
		return nil;
	end;	
end;

function faction_council:issue_unused_own_trade_capacity(faction) -- tested 07/10/2020
	-- Looking for factions which we know and are able to sign a trade agreement with
	
	if not faction or faction:is_null_interface() then
		return nil;
	end;

	local filtered_factions_list = faction:factions_met():filter(function(filter_faction) -- Filtiering the force list of this faction by function predicate
		if faction:can_apply_automatic_diplomatic_deal("data_defined_situation_trade", filter_faction, "faction_key:" .. filter_faction:name()) then -- faction has trade capacity and there are factions they can sign trade agreements with
			return true;
		end;
		return false;
	end)

	if not filtered_factions_list:is_empty() then 
		-- if we have a number of factions we can sign trade deals with we add the issue to the list and return the CQI of one of the viable trade parteners
		return filtered_factions_list:item_at(cm:random_int(0, filtered_factions_list:num_items()-1)):command_queue_index();
	else
		return nil;
	end;	
end;

function faction_council:issue_own_vassal_relationship_poor(faction) -- tested 08/10/2020
	-- Looking for factions who are our vassal and have a poor faction standing with
	
	if not faction or faction:is_null_interface() then
		return nil;
	end;

	local filtered_factions_list = diplomacy_manager:get_all_vassal_factions(faction:name()) -- create a list of all the source ffactions vassals

	filtered_factions_list = filtered_factions_list:filter(function(filter_faction) -- Filtiering the faction list using a function predicate
		local heir_post = filter_faction:character_posts():find_if(function(filter_post) return filter_post:ministerial_position_record_key() == "faction_heir" end)
		
		-- if the vassal faction has a relationship below the threshold value we keep them on the filtered list
		-- Make sure only adults are chosen as children break the display and disappear in the new faction.
		return filter_faction:diplomatic_standing_with(faction) <= faction_low_diplomatic_relationship_threshold 
			and not heir_post:post_holders():is_empty()
			and heir_post:post_holders():all_of(function(char) return char:has_come_of_age() end);
	end)

	if not filtered_factions_list:is_empty() then 
		-- if we have any vassals who are in poor standing we return one of their CQI's at random from the list
		return filtered_factions_list:item_at(cm:random_int(0, filtered_factions_list:num_items()-1)):command_queue_index();
	else
		return nil;
	end;	
end;

function faction_council:issue_non_allied_faction_in_adjacent_region(faction) -- tested 08/10/2020
	-- Looking for factions who are adjacent to our territory and are are diplomatically non-allied
	
	if not faction or faction:is_null_interface() then
		return nil;
	end;

	local major_factions = get_n_most_major_factions_unsorted(5);
	local filtered_faction_list = faction_council:get_neutral_factions(faction)
		:filter(function(faction) return not table.contains(major_factions, faction:name()) end) -- takes a faction interface and returns a list of all diplomatically non-allied factions who are minor
	local faction_region_list = faction:region_list() -- all regions owned by source faction

	local filtered_regions_list = cm:query_model():world():region_manager():region_list():filter(function(filter_region) -- Filtiering the faction list using a function predicate
		if filter_region:owning_faction() == faction or not filtered_faction_list:contains(filter_region:owning_faction()) then
			return false; -- remove non-neutral faction factions and regions owned by the source faction
		end;

		for i = 0, faction_region_list:num_items() -1 do
			local adjacent_regions_list = faction_region_list:item_at(i):adjacent_region_list()
			return adjacent_regions_list:contains(filter_region) -- this world region is adjacent to one owned by the source faction
		end;
		return false; -- should never really get here
	end);

	if not filtered_regions_list:is_empty() then 
		-- if we have a number of regions with low population levels we return exactly how many
		return filtered_regions_list:item_at(cm:random_int(0, filtered_regions_list:num_items()-1)):command_queue_index();
	else
		return nil;
	end;	
end;

function faction_council:issue_other_faction_is_world_leader(faction) -- tested 08/10/2020
	-- Looking for factions who are world leaders
	
	if not faction or faction:is_null_interface() then
		return nil;
	end;
	
	local filtered_factions_list = cm:query_model():world():faction_list():filter(function(filter_faction) 
		return filter_faction ~= faction and filter_faction:is_world_leader() -- create a list of all world leader factions who are not us
	end);

	if not filtered_factions_list:is_empty() then 
		-- if other factions exist as world leaders we randomly pull one from the list and return it's CQI
		return filtered_factions_list:item_at(cm:random_int(0, filtered_factions_list:num_items()-1)):command_queue_index();
	else
		return nil;
	end;	
end;

function faction_council:issue_non_allied_factions_control_southern_ports(faction)
	-- Looking for coastal regions in the south of the map which are held by neutral or hostile factions

	if not faction or faction:is_null_interface() or not cm:query_faction(invasion_faction_key) then
		return nil;
	end;

	local filtered_faction_list = faction_council:get_neutral_factions(faction) -- takes a faction interface and returns a list of all diplomatically non-allied factions
	local target_region_keys_list = { -- all southern port settlements
		"3k_dlc06_jiuzhen_capital",
		"3k_main_jiaozhi_capital",
		"3k_main_hepu_capital",
		"3k_main_hepu_resource_1",
		"3k_main_hepu_resource_2",
		"3k_main_gaoliang_capital",
		"3k_main_gaoliang_resource_1"
	}

	-- Generate a list of regions to pass to the faction_occupies_regions_with_n_or_more_forces function to prevent excess spawns in localised areas of the map
	local target_and_adjacent_regions_list = {};
	for k,v in pairs(target_region_keys_list) do
		target_and_adjacent_regions_list[k] = v;
	end;

	-- Expand search area to include adjacent regions to the desired targets as AI fdorces may wander outside the desired area
	for i=1, #target_region_keys_list do
		cm:query_region(target_region_keys_list[i]):adjacent_region_list():foreach(function(region)
			if not table.contains(target_and_adjacent_regions_list, region:name()) then
				table.insert(target_and_adjacent_regions_list, region:name())
			end;
		end);
	end;

	-- Count the number of invasion faction forces in the target + adjacent regions
	local total_armies_in_area = 0;
	for _,v in pairs(target_and_adjacent_regions_list) do
		total_armies_in_area = total_armies_in_area + cm:query_model():total_faction_armies_in_region(cm:query_faction(invasion_faction_key), v);
		-- If the number of forces is equal to or exceeds the defined maximum return nil and this suggestion will not trigger
		if total_armies_in_area >= max_invasion_armies_in_area then
			return nil;
		end;
	end;

	-- Because sea regions don't count as adjacent regions and do not have a region interface we will check these seperately.
	local sea_region_keys_list = {
		"3k_dlc06_sea_nan_to_jiuzhen_capital",
		"3k_main_sea_nan_jiaozhi_capital",
		"3k_main_sea_nan_hepu_capital",
		"3k_main_sea_nan_hepu_resource_1",
		"3k_main_sea_nan_hepu_resource_2",
		"3k_main_sea_nan_gaoliang_capital",
		"3k_main_sea_nan_gaoliang_resource_1"
	}
	for _,v in pairs(sea_region_keys_list) do
		total_armies_in_area = total_armies_in_area + cm:query_model():total_faction_armies_in_region(cm:query_faction(invasion_faction_key), v);
		-- If the number of forces is equal to or exceeds the defined maximum return nil and this suggestion will not trigger
		if total_armies_in_area >= max_invasion_armies_in_area then
			return nil;
		end;
	end;

	local filtered_regions_list = cm:query_model():world():region_manager():region_list():filter(function(filter_region) -- Filtiering the faction list using a function predicate
		if  table.contains(target_region_keys_list,filter_region:name()) then -- region key must exist on the target region keys list
			return filtered_faction_list:contains(filter_region:owning_faction()) -- include only regions by non-friendly factions
		else return false; -- region is not in the target region table
		end;
	 end);

	if not filtered_regions_list:is_empty() then 
		-- if there are regions left on the list we return the CQI of one of the regions at random
		return filtered_regions_list:item_at(cm:random_int(0, filtered_regions_list:num_items()-1)):command_queue_index();
	else
		return nil;
	end;	
end;

function faction_council:issue_non_allied_factions_control_northern_ports(faction) -- tested 08/10/2020
	-- Looking for coastal regions in the north of the map which are held by neutral or hostile factions

	if not faction or faction:is_null_interface() or not cm:query_faction(invasion_faction_key) then
		return nil;
	end;

	local filtered_faction_list = faction_council:get_neutral_factions(faction) -- takes a faction interface and returns a list of all diplomatically non-allied factions
	local target_region_keys_list = { -- all northern port settlements
		"3k_dlc06_liaodong_capital",
		"3k_dlc06_liaodong_resource_1",
		"3k_main_yu_capital",
		"3k_main_youbeiping_capital",
		"3k_main_youbeiping_resource_1",
		"3k_main_bohai_resource_1",
		"3k_main_pingyuan_resource_1",
		"3k_main_taishan_resource_1",
		"3k_main_beihai_resource_1",
		"3k_main_donglai_capital",
		"3k_main_donglai_resource_1"
	}

	-- Generate a list of regions to pass to the faction_occupies_regions_with_n_or_more_forces function to prevent excess spawns in localised areas of the map
	local target_and_adjacent_regions_list = {};
	for k,v in pairs(target_region_keys_list) do
		target_and_adjacent_regions_list[k] = v;
	end;

	-- Expand search area to include adjacent regions to the desired targets as AI fdorces may wander outside the desired area
	for i=1, #target_region_keys_list do
		cm:query_region(target_region_keys_list[i]):adjacent_region_list():foreach(function(region)
			if not table.contains(target_and_adjacent_regions_list, region:name()) then
				table.insert(target_and_adjacent_regions_list, region:name())
			end;
		end);
	end;

	-- Count the number of invasion faction forces in the target + adjacent regions
	local total_armies_in_area = 0;
	for _,v in pairs(target_and_adjacent_regions_list) do
		total_armies_in_area = total_armies_in_area + cm:query_model():total_faction_armies_in_region(cm:query_faction(invasion_faction_key), v);
		-- If the number of forces is equal to or exceeds the defined maximum return nil and this suggestion will not trigger
		if total_armies_in_area >= max_invasion_armies_in_area then
			return nil;
		end;
	end;

	-- Because sea regions don't count as adjacent regions and do not have a region interface we will check these seperately.
	local sea_region_keys_list = {
		"3k_dlc06_sea_huang_to_liaodong_capital",
		"3k_dlc06_sea_huang_to_liaodong_resource_1",
		"3k_main_sea_huang_to_yu_capital",
		"3k_main_sea_huang_to_youbeiping_capital",
		"3k_main_sea_huang_to_youbeiping_resource_1",
		"3k_main_sea_huang_to_bohai_resource_1",
		"3k_main_sea_huang_to_pingyuan_resource_1",
		"3k_main_sea_huang_to_taishan_resource_1",
		"3k_main_sea_huang_to_beihai_resource_1",
		"3k_main_sea_huang_to_donglai_capital",
		"3k_main_sea_huang_to_donglai_resource_1"
	}
	for _,v in pairs(sea_region_keys_list) do
		total_armies_in_area = total_armies_in_area + cm:query_model():total_faction_armies_in_region(cm:query_faction(invasion_faction_key), v);
		if total_armies_in_area >= max_invasion_armies_in_area then
			return nil;
		end;
	end;

	local filtered_regions_list = cm:query_model():world():region_manager():region_list():filter(function(filter_region) -- Filtiering the faction list using a function predicate
		if  table.contains(target_region_keys_list,filter_region:name()) then -- region key must exist on the target region keys list
			return filtered_faction_list:contains(filter_region:owning_faction()) -- include only regions by non-friendly factions
		else return false; -- region is not in the target region table
		end;
	 end);

	if not filtered_regions_list:is_empty() then 
		-- if there are regions left on the list we return the CQI of one of the regions at random
		return filtered_regions_list:item_at(cm:random_int(0, filtered_regions_list:num_items()-1)):command_queue_index();
	else
		return nil;
	end;	
end;

function faction_council:issue_non_allied_factions_control_north_west_regions(faction) -- tested 08/10/2020
	-- Looking for coastal regions in the north of the map which are held by neutral or hostile factions

	if not faction or faction:is_null_interface() or not cm:query_faction(invasion_faction_key) then
		return nil;
	end;

	local filtered_faction_list = faction_council:get_neutral_factions(faction) -- takes a faction interface and returns a list of all diplomatically non-allied factions
	local target_region_keys_list = { -- all north west settlements
		"3k_main_wuwei_capital",
		"3k_main_wuwei_resource_1",
		"3k_main_wuwei_resource_2",
		"3k_main_shoufang_capital",
		"3k_main_shoufang_resource_2"
	}

	-- Generate a list of regions to pass to the faction_occupies_regions_with_n_or_more_forces function to prevent excess spawns in localised areas of the map
	local target_and_adjacent_regions_list = {};
	for k,v in pairs(target_region_keys_list) do
		target_and_adjacent_regions_list[k] = v;
	end;

	-- Expand search area to include adjacent regions to the desired targets as AI fdorces may wander outside the desired area
	for i=1, #target_region_keys_list do
		cm:query_region(target_region_keys_list[i]):adjacent_region_list():foreach(function(region)
			if not table.contains(target_and_adjacent_regions_list, region:name()) then
				table.insert(target_and_adjacent_regions_list, region:name())
			end;
		end);
	end;

	-- Count the number of invasion faction forces in the target + adjacent regions
	local total_armies_in_area = 0;
	for _,v in pairs(target_and_adjacent_regions_list) do
		total_armies_in_area = total_armies_in_area + cm:query_model():total_faction_armies_in_region(cm:query_faction(invasion_faction_key), v);
		-- If the number of forces is equal to or exceeds the defined maximum return nil and this suggestion will not trigger
		if total_armies_in_area >= max_invasion_armies_in_area then
			return nil;
		end;
	end;
	
	local filtered_regions_list = cm:query_model():world():region_manager():region_list():filter(function(filter_region) -- Filtiering the faction list using a function predicate
		if table.contains(target_region_keys_list,filter_region:name()) then -- region key must exist on the target region keys list
			return filtered_faction_list:contains(filter_region:owning_faction()) -- include only regions held by non-friendly factions
		else return false; -- region is not in the target region table
		end;
	 end);

	if not filtered_regions_list:is_empty() then 
		-- if there are regions left on the list we return the CQI of one of the regions at random
		return filtered_regions_list:item_at(cm:random_int(0, filtered_regions_list:num_items()-1)):command_queue_index();
	else
		return nil;
	end;	
end;

function faction_council:issue_large_enemy_faction_with_little_excess_food(faction) -- tested 08/10/2020
	-- Looking for coastal regions in the north of the map which are held by neutral or hostile factions

	if not faction or faction:is_null_interface() then
		return nil;
	end;

	local filtered_faction_list = diplomacy_manager:factions_at_war_with(faction:name()) -- takes a faction interface and returns a list of all diplomatically hostile factions
	filtered_faction_list = filtered_faction_list:filter(function(filter_faction) -- Filtiering the faction list using a function predicate
		return filter_faction:pooled_resources():resource("3k_main_pooled_resource_food"):value() <= low_food_food_income_threshold -- filtering the factions list to only include factions with food under the threshold and more than the minimum number of regions
			and filter_faction:region_list():num_items() >= large_faction_region_count
			and not filter_faction:has_effect_bundle("3k_dlc07_issue_large_enemy_faction_with_little_excess_food")
	 end)

	if not filtered_faction_list:is_empty() then 
		-- if there are regions still on the list
		return filtered_faction_list:item_at(cm:random_int(0, filtered_faction_list:num_items()-1)):command_queue_index(); -- if there is an enemy faction with little food and a lot of regions we add the issue to the list and return the CQI of one of the factions at random
	else
		return nil;
	end;	
end;

function faction_council:issue_increase_commercial_economy_focus(faction) -- tested 08/10/2020
	-- Looking for coastal regions in the north of the map which are held by neutral or hostile factions

	if not faction or faction:is_null_interface() then
		return nil;
	end;

	local commercial_buildings_count = 0;
	local total_buildings_count = 0;
	local filtered_region_list = faction:region_list()

	for i = 0, filtered_region_list:num_items() - 1 do
		local slot_list = filtered_region_list:item_at(i):slot_list();
		for k = 0, slot_list:num_items() - 1 do
			if slot_list:item_at(k):has_building() then
				if  table.contains(commercial_building_chain_keys_list,slot_list:item_at(k):building():chain()) then
					commercial_buildings_count = commercial_buildings_count + 1;
				end;
				total_buildings_count = total_buildings_count +1;
			end;
		end;
	end;

	if total_buildings_count > 0 and commercial_buildings_count/total_buildings_count >=  economic_infrastructure_bias_ratio_threshold then 
		-- if the ratio of commerical infrastructure across all of the factions regions exceeds the threshold we add the issue to the list and return the ratio
		return faction:command_queue_index();
	else
		return nil;
	end;
end;

function faction_council:issue_increase_peasantry_economy_focus(faction) -- tested 07/10/2020
	-- Looking for coastal regions in the north of the map which are held by neutral or hostile factions

	if not faction or faction:is_null_interface() then
		return nil;
	end;

	local peasantry_buildings_count = 0;
	local total_buildings_count = 0;
	local filtered_region_list = faction:region_list()
	
	for i = 0, filtered_region_list:num_items() - 1 do
		local slot_list = filtered_region_list:item_at(i):slot_list();
		for k = 0, slot_list:num_items() - 1 do
			if slot_list:item_at(k):has_building() then
				if table.contains(peasantry_building_chain_keys_list, slot_list:item_at(k):building():chain()) then
					peasantry_buildings_count = peasantry_buildings_count + 1;
				end;
				total_buildings_count = total_buildings_count +1;
			end;
		end;
	end;

	if total_buildings_count > 0 and peasantry_buildings_count/total_buildings_count >=  economic_infrastructure_bias_ratio_threshold then 
		-- if the ratio of commerical infrastructure across all of the factions regions exceeds the threshold we add the issue to the list and return the ratio
		return faction:command_queue_index();
	else
		return nil;
	end;
end;

function faction_council:issue_increase_industry_economy_focus(faction) -- tested 08/10/2020
	-- Looking for coastal regions in the north of the map which are held by neutral or hostile factions

	if not faction or faction:is_null_interface() then
		return nil;
	end;

	local industry_buildings_count = 0;
	local total_buildings_count = 0;
	local filtered_region_list = faction:region_list()
	
	for i = 0, filtered_region_list:num_items() - 1 do
		local slot_list = filtered_region_list:item_at(i):slot_list();
		for k = 0, slot_list:num_items() - 1 do
			if slot_list:item_at(k):has_building() then
				if table.contains(industry_building_chain_keys_list, slot_list:item_at(k):building():chain()) then
					industry_buildings_count = industry_buildings_count + 1;
				end;
				total_buildings_count = total_buildings_count +1;
			end;
		end;
	end;

	if total_buildings_count > 0 and industry_buildings_count/total_buildings_count >=  economic_infrastructure_bias_ratio_threshold then
		-- if the ratio of commerical infrastructure across all of the factions regions exceeds the threshold we add the issue to the list and return the ratio
		return faction:command_queue_index();
	else
		return nil;
	end;
end;
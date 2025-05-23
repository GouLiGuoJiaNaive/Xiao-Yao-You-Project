---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------
----- Name:			dlc07_faction_cao_cao_schemes.lua
----- Description: 	This script handles Cao Cao's schemes mechanic
---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------

-- Don't load in campaigns which don't require it.
if cm.name == "ep_eight_princes" then
	output("dlc07_faction_cao_cao_schemes.lua: Not loaded in this campaign.");
	return;
else
	output("dlc07_faction_cao_cao_schemes.lua: Loading");
end;

-- self initialiser
cm:add_first_tick_callback_new(function() cao_cao_schemes:new_game() end); -- Fires on the first tick of a New Campaign
cm:add_first_tick_callback(function() cao_cao_schemes:initialise() end);   -- fires on the first tick of every game loaded.

-- Table holding the script and variables.
cao_cao_schemes = {
	cao_cao_faction_key = "3k_main_faction_cao_cao",
	cao_cao_pr_key = "3k_main_pooled_resource_credibility",
	schemes_data = {
		["3k_dlc07_scheme_army_attacking_when_far_appear_near"] = {
			title_key = "3k_dlc07_scheme_army_attacking_when_far_appear_near_title",
			icon_path = "ui/skins/default/schemes/3k_dlc07_scheme_charge.png",
			description_key = "3k_dlc07_scheme_army_attacking_when_far_appear_near_description",
			unlock_condition_key = "3k_dlc07_schemes_unlock_condition_another_army_in_our_territory_or_with_our_army",
			effect_bundle_key = "3k_dlc07_scheme_army_attacking_when_far_appear_near",
			incident_key = "3k_dlc07_scheme_army_attacking_when_far_appear_near_incident",
			pr_transaction_amount = -5,
			cooldown = 3,
			target = "enemy",
			attributes_key = "resolve",
			precondition =
			"RegionOwnerFactionContext == PlayersFaction || CaoCaoHasMilitaryForceInProvince( this.ClosestSettlementContext.ProvinceContext )",
			--Info for script use only, UI shouldn't need this
			effect_bundle_duration = 5,
			turns_till_active = 0
		},
		["3k_dlc07_scheme_army_besieged_feign_defensive_inactivity"] = {
			title_key = "3k_dlc07_scheme_army_besieged_feign_defensive_inactivity_title",
			icon_path = "ui/skins/default/schemes/3k_dlc07_scheme_defence.png",
			description_key = "3k_dlc07_scheme_army_besieged_feign_defensive_inactivity_description",
			unlock_condition_key = "3k_dlc07_schemes_unlock_condition_besieged_superior",
			effect_bundle_key = "3k_dlc07_scheme_army_besieged_feign_defensive_inactivity",
			incident_key = "3k_dlc07_scheme_army_besieged_feign_defensive_inactivity_incident",
			pr_transaction_amount = -5,
			cooldown = 3,
			target = "enemy",
			attributes_key = "cunning",
			precondition = "(x = BesiegingForceBalance ) => { SiegeTurnsRemaining > 0 && x >= 0.66 }",
			--Info for script use only, UI shouldn't need this
			effect_bundle_duration = 5,
			turns_till_active = 0
		},
		["3k_dlc07_scheme_army_campaigning_hawk_and_tiger_manoeuvres"] = {
			title_key = "3k_dlc07_scheme_army_campaigning_hawk_and_tiger_manoeuvres_title",
			icon_path = "ui/skins/default/schemes/3k_dlc07_scheme_action_points.png",
			description_key = "3k_dlc07_scheme_army_campaigning_hawk_and_tiger_manoeuvres_description",
			unlock_condition_key = "3k_dlc07_schemes_unlock_condition_low_movement",
			effect_bundle_key = "3k_dlc07_scheme_army_campaigning_hawk_and_tiger_manoeuvres",
			pr_transaction_amount = 15,
			cooldown = 3,
			target = "self",
			attributes_key = "cunning",
			precondition =
			"CommandingCharacterContext.ActionPointsPerTurn > 0 && CommandingCharacterContext.ActionPointPercent < 0.1",
			--Info for script use only, UI shouldn't need this
			effect_bundle_duration = 1,
			turns_till_active = 0
		},
		["3k_dlc07_scheme_army_defending_when_near_appear_far"] = {
			title_key = "3k_dlc07_scheme_army_defending_when_near_appear_far_title",
			icon_path = "ui/skins/default/schemes/3k_dlc07_scheme_morale.png",
			description_key = "3k_dlc07_scheme_army_defending_when_near_appear_far_description",
			unlock_condition_key = "3k_dlc07_schemes_unlock_condition_another_army_in_our_territory_or_with_our_army",
			effect_bundle_key = "3k_dlc07_scheme_army_defending_when_near_appear_far",
			incident_key = "3k_dlc07_scheme_army_defending_when_near_appear_far_incident",
			pr_transaction_amount = -5,
			cooldown = 4,
			target = "enemy",
			attributes_key = "cunning",
			precondition =
			"RegionOwnerFactionContext == PlayersFaction || CaoCaoHasMilitaryForceInProvince( this.ClosestSettlementContext.ProvinceContext )",
			--Info for script use only, UI shouldn't need this
			effect_bundle_duration = 3,
			turns_till_active = 0
		},
		["3k_dlc07_scheme_army_sieging_release_the_damned_river"] = {
			title_key = "3k_dlc07_scheme_army_sieging_release_the_damned_river_title",
			icon_path = "ui/skins/default/schemes/3k_dlc07_scheme_melee_attack.png",
			description_key = "3k_dlc07_scheme_army_sieging_release_the_damned_river_description",
			unlock_condition_key = "3k_dlc07_schemes_unlock_condition_sieging_strong",
			effect_bundle_key = "3k_dlc07_scheme_army_sieging_release_the_damned_river",
			incident_key = "3k_dlc07_scheme_army_sieging_release_the_damned_river_incident",
			pr_transaction_amount = -5,
			cooldown = 3,
			target = "enemy",
			attributes_key = "cunning",
			precondition =
			"SettlementContext.IsUnderSiege && SettlementContext.BesiegingForceContext.FactionContext == PlayersFaction && SettlementContext.BesiegingForceContext.BesiegingForceBalance <= 0.33",
			--Info for script use only, UI shouldn't need this
			effect_bundle_duration = 5,
			turns_till_active = 0
		},
		["3k_dlc07_scheme_character_costing_salary_gift_of_honour"] = {
			title_key = "3k_dlc07_scheme_character_costing_salary_gift_of_honour_title",
			icon_path = "ui/skins/default/schemes/3k_dlc07_scheme_salary_reduction.png",
			description_key = "3k_dlc07_scheme_character_costing_salary_gift_of_honour_description",
			unlock_condition_key = "3k_dlc07_schemes_unlock_condition_character_in_another_faction_above_rank_4",
			effect_bundle_key = "3k_dlc07_scheme_character_costing_salary_gift_of_honour",
			incident_key = "3k_dlc07_scheme_character_costing_salary_gift_of_honour_incident",
			pr_transaction_amount = -5,
			cooldown = 3,
			target = "enemy",
			attributes_key = "cunning",
			precondition = "Rank >= 5 && Salary > 0",
			--Info for script use only, UI shouldn't need this
			effect_bundle_duration = 5,
			turns_till_active = 0
		},
		["3k_dlc07_scheme_character_costing_upkeep_feast_for_the_general"] = {
			title_key = "3k_dlc07_scheme_character_costing_upkeep_feast_for_the_general_title",
			icon_path = "ui/skins/default/schemes/3k_dlc07_scheme_retinue_upkeep.png",
			description_key = "3k_dlc07_scheme_character_costing_upkeep_feast_for_the_general_description",
			unlock_condition_key = "3k_dlc07_schemes_unlock_condition_character_in_another_faction_below_rank_5",
			effect_bundle_key = "3k_dlc07_scheme_character_costing_upkeep_feast_for_the_general",
			incident_key = "3k_dlc07_scheme_character_costing_upkeep_feast_for_the_general_incident",
			pr_transaction_amount = -5,
			cooldown = 3,
			target = "enemy",
			attributes_key = "cunning",
			precondition = "IsOnMap && Rank <= 4",
			--Info for script use only, UI shouldn't need this
			effect_bundle_duration = 5,
			turns_till_active = 0,
			initial_cooldown = {
				["dlc04_mandate"] = 0,
				["three_kingdoms_early"] = 0,
				["dlc05_new_year"] = 0,
				["dlc07_guandu"] = 0
			},
		},
		["3k_dlc07_scheme_character_costing_upkeep_flatter_the_general"] = {
			title_key = "3k_dlc07_scheme_character_costing_upkeep_flatter_the_general_title",
			icon_path = "ui/skins/default/schemes/3k_dlc07_scheme_retinue_upkeep.png",
			description_key = "3k_dlc07_scheme_character_costing_upkeep_flatter_the_general_description",
			unlock_condition_key = "3k_dlc07_schemes_unlock_condition_high_salary",
			effect_bundle_key = "3k_dlc07_scheme_character_costing_upkeep_flatter_the_general",
			pr_transaction_amount = 10,
			cooldown = 3,
			target = "self",
			attributes_key = "cunning",
			precondition = "IsOnMap && Salary > 300",
			--Info for script use only, UI shouldn't need this
			effect_bundle_duration = 5,
			turns_till_active = 0
		},
		["3k_dlc07_scheme_character_low_satisfaction_eyes_and_ears_within"] = {
			title_key = "3k_dlc07_scheme_character_low_satisfaction_eyes_and_ears_within_title",
			icon_path = "ui/skins/default/schemes/3k_dlc07_scheme_satisfaction.png",
			description_key = "3k_dlc07_scheme_character_low_satisfaction_eyes_and_ears_within_description",
			unlock_condition_key = "3k_dlc07_schemes_unlock_condition_character_in_another_faction_low_satisfaction",
			effect_bundle_key = "3k_dlc07_scheme_character_low_satisfaction_eyes_and_ears_within",
			incident_key = "3k_dlc07_scheme_character_low_satisfaction_eyes_and_ears_within_incident",
			pr_transaction_amount = -3,
			cooldown = 3,
			target = "enemy",
			attributes_key = "cunning",
			precondition = "SatisfactionValue <= 75",
			--Info for script use only, UI shouldn't need this
			effect_bundle_duration = 5,
			turns_till_active = 0
		},
		["3k_dlc07_scheme_character_low_satisfaction_knowledge_of_the_ambitious"] = {
			title_key = "3k_dlc07_scheme_character_low_satisfaction_knowledge_of_the_ambitious_title",
			icon_path = "ui/skins/default/schemes/3k_dlc07_scheme_satisfaction.png",
			description_key = "3k_dlc07_scheme_character_low_satisfaction_knowledge_of_the_ambitious_description",
			unlock_condition_key = "3k_dlc07_schemes_unlock_condition_high_court_position",
			effect_bundle_key = "3k_dlc07_scheme_character_low_satisfaction_knowledge_of_the_ambitious",
			pr_transaction_amount = 10,
			cooldown = 3,
			target = "self",
			attributes_key = "cunning",
			precondition =
			"SatisfactionValue <= 25 && NegativeSatisfactionModifierList.FindIf( RecordContext.Key == 'job_satisfaction' ).Index != -1",
			--Info for script use only, UI shouldn't need this
			effect_bundle_duration = 5,
			turns_till_active = 0
		},
		["3k_dlc07_scheme_character_recruitment_of_restore_skill"] = {
			title_key = "3k_dlc07_scheme_character_recruitment_of_restore_skill",
			icon_path = "ui/skins/default/schemes/3k_dlc07_scheme_satisfaction.png",
			description_key = "3k_dlc07_scheme_character_recruitment_of_restore_skill_description",
			unlock_condition_key = "3k_dlc07_schemes_unlock_condition_restore_skill_condition",
			effect_bundle_key = "3k_dlc07_scheme_character_recruitment_of_restore_skill",
			pr_transaction_amount = -25,
			cooldown = 5,
			target = "self",
			attributes_key = "cunning",
			precondition = "Rank >= 7",
			--Info for script use only, UI shouldn't need this
			effect_bundle_duration = 1,
			turns_till_active = 0
		},
		["3k_dlc07_scheme_character_recruitment_of_an_owl_to_seek_an_owl"] = {
			title_key = "3k_dlc07_scheme_character_recruitment_of_an_owl_to_seek_an_owl_title",
			icon_path = "ui/skins/default/schemes/3k_dlc07_scheme_character_cost.png",
			description_key = "3k_dlc07_scheme_character_recruitment_of_an_owl_to_seek_an_owl_description",
			unlock_condition_key = "3k_dlc07_schemes_unlock_condition_character_in_another_faction_not_general",
			effect_bundle_key = "3k_dlc07_scheme_character_recruitment_of_an_owl_to_seek_an_owl",
			incident_key = "3k_dlc07_scheme_character_recruitment_of_an_owl_to_seek_an_owl_incident",
			pr_transaction_amount = -5,
			cooldown = 4,
			target = "enemy",
			attributes_key = "cunning",
			precondition = "IsContextValid( MilitaryForceContext ) == false",
			--Info for script use only, UI shouldn't need this
			effect_bundle_duration = 5,
			turns_till_active = 0
		},
		["3k_dlc07_scheme_character_recruitment_to_mountain_air_will_harm_the_body"] = {
			title_key = "3k_dlc07_scheme_character_recruitment_to_mountain_air_will_harm_the_body_title",
			icon_path = "ui/skins/default/schemes/3k_dlc07_scheme_unit_cost.png",
			description_key = "3k_dlc07_scheme_character_recruitment_to_mountain_air_will_harm_the_body_description",
			unlock_condition_key = "3k_dlc07_schemes_unlock_condition_character_in_another_faction_is_general",
			effect_bundle_key = "3k_dlc07_scheme_character_recruitment_to_mountain_air_will_harm_the_body",
			incident_key = "3k_dlc07_scheme_character_recruitment_to_mountain_air_will_harm_the_body_incident",
			pr_transaction_amount = -5,
			cooldown = 4,
			target = "enemy",
			attributes_key = "cunning",
			precondition = "IsContextValid( MilitaryForceContext )",
			--Info for script use only, UI shouldn't need this
			effect_bundle_duration = 5,
			turns_till_active = 0
		},
		["3k_dlc07_scheme_faction_diplomacy_relative_above_stranger"] = {
			title_key = "3k_dlc07_scheme_faction_diplomacy_relative_above_stranger_title",
			icon_path = "ui/skins/default/schemes/3k_dlc07_scheme_diplomatic_relations.png",
			description_key = "3k_dlc07_scheme_faction_diplomacy_relative_above_stranger_description",
			unlock_condition_key = "3k_dlc07_schemes_unlock_condition_no_special_condition",
			effect_bundle_key = "3k_dlc07_scheme_faction_diplomacy_relative_above_stranger",
			incident_key = "3k_dlc07_scheme_faction_diplomacy_relative_above_stranger_incident",
			pr_transaction_amount = -3,
			cooldown = 3,
			target = "enemy",
			attributes_key = "cunning",
			precondition = "true",
			--Info for script use only, UI shouldn't need this
			effect_bundle_duration = 1,
			turns_till_active = 0,
			automatic_deal_key = "data_defined_situation_attitude_manipulation_schemes"
		},
		["3k_dlc07_scheme_faction_diplomacy_rival_tigers_and_one_prey"] = {
			title_key = "3k_dlc07_scheme_faction_diplomacy_rival_tigers_and_one_prey_title",
			icon_path = "ui/skins/default/schemes/3k_dlc07_scheme_diplomatic_relations.png",
			description_key = "3k_dlc07_scheme_faction_diplomacy_rival_tigers_and_one_prey_description",
			unlock_condition_key = "3k_dlc07_schemes_unlock_condition_no_special_condition",
			effect_bundle_key = "3k_dlc07_scheme_faction_diplomacy_rival_tigers_and_one_prey",
			pr_transaction_amount = 10,
			cooldown = 2,
			target = "self",
			attributes_key = "cunning",
			precondition = "true",
			--Info for script use only, UI shouldn't need this
			effect_bundle_duration = 3,
			turns_till_active = 0
		},
		["3k_dlc07_scheme_faction_food_low_the_cattle_go_without"] = {
			title_key = "3k_dlc07_scheme_faction_food_low_the_cattle_go_without_title",
			icon_path = "ui/skins/default/schemes/3k_dlc07_scheme_food.png",
			description_key = "3k_dlc07_scheme_faction_food_low_the_cattle_go_without_description",
			unlock_condition_key = "3k_dlc07_schemes_unlock_condition_another_faction_with_less_than_10_food",
			effect_bundle_key = "3k_dlc07_scheme_faction_food_low_the_cattle_go_without",
			incident_key = "3k_dlc07_scheme_faction_food_low_the_cattle_go_without_incident",
			pr_transaction_amount = -3,
			cooldown = 3,
			target = "enemy",
			attributes_key = "cunning",
			precondition = "PooledResourceContext('3k_main_pooled_resource_food').Total <= 10",
			--Info for script use only, UI shouldn't need this
			effect_bundle_duration = 5,
			turns_till_active = 0
		},
		["3k_dlc07_scheme_faction_spy_action_cost_hungry_snake_over_the_full"] = {
			title_key = "3k_dlc07_scheme_faction_spy_action_cost_hungry_snake_over_the_full_title",
			icon_path = "ui/skins/default/schemes/3k_dlc07_scheme_spy_action_cost.png",
			description_key = "3k_dlc07_scheme_faction_spy_action_cost_hungry_snake_over_the_full_description",
			unlock_condition_key = "3k_dlc07_schemes_unlock_condition_another_faction_known_to_us",
			effect_bundle_key = "3k_dlc07_scheme_faction_spy_action_cost_hungry_snake_over_the_full",
			incident_key = "3k_dlc07_scheme_faction_spy_action_cost_hungry_snake_over_the_full_incident",
			pr_transaction_amount = -5,
			cooldown = 3,
			target = "enemy",
			attributes_key = "cunning",
			precondition = "true",
			--Info for script use only, UI shouldn't need this
			effect_bundle_duration = 5,
			turns_till_active = 0
		},
		["3k_dlc07_scheme_faction_spy_undercover_network_pay_the_rats_to_hide_the_snake"] = {
			title_key = "3k_dlc07_scheme_faction_spy_undercover_network_pay_the_rats_to_hide_the_snake_title",
			icon_path = "ui/skins/default/schemes/3k_dlc07_scheme_undercover_network.png",
			description_key = "3k_dlc07_scheme_faction_spy_undercover_network_pay_the_rats_to_hide_the_snake_description",
			unlock_condition_key = "3k_dlc07_schemes_unlock_condition_another_faction_known_to_us",
			effect_bundle_key = "3k_dlc07_scheme_faction_spy_undercover_network_pay_the_rats_to_hide_the_snake",
			incident_key = "3k_dlc07_scheme_faction_spy_undercover_network_pay_the_rats_to_hide_the_snake_incident",
			pr_transaction_amount = -5,
			cooldown = 3,
			target = "enemy",
			attributes_key = "cunning",
			precondition = "true",
			--Info for script use only, UI shouldn't need this
			effect_bundle_duration = 5,
			turns_till_active = 0
		},
		["3k_dlc07_scheme_faction_tech_summer_dominion_over_the_realm"] = {
			title_key = "3k_dlc07_scheme_faction_tech_summer_dominion_over_the_realm_title",
			icon_path = "ui/skins/default/schemes/3k_dlc07_scheme_technology_unlock.png",
			description_key = "3k_dlc07_scheme_faction_tech_summer_dominion_over_the_realm_description",
			unlock_condition_key = "3k_dlc07_schemes_unlock_condition_technology_unlock",
			effect_bundle_key = "3k_dlc07_scheme_faction_tech_summer_dominion_over_the_realm",
			pr_transaction_amount = 20,
			cooldown = 5,
			target = "self",
			attributes_key = "cunning",
			precondition = "CampaignRoot.SeasonContext.Key != 'season_spring'",
			--Info for script use only, UI shouldn't need this
			effect_bundle_duration = 1,
			turns_till_active = 0
		},
		["3k_dlc07_scheme_faction_misc_of_give_ticket"] = {
			title_key = "3k_dlc07_scheme_faction_diplomacy_give_tickets_title",
			icon_path = "ui/skins/default/schemes/3k_dlc07_scheme_council_mission.png",
			description_key = "3k_dlc07_scheme_faction_misc_of_give_ticket_description",
			unlock_condition_key = "3k_dlc07_schemes_unlock_condition_give_ticket_condition",
			effect_bundle_key = "3k_dlc07_scheme_faction_misc_of_give_ticket",
			pr_transaction_amount = -100,
			cooldown = 15,
			target = "self",
			attributes_key = "cunning",
			--precondition = "PlayersFaction.EffectBundleList.FindIf( Key == '3k_xyy_character_sold_out_dummy' ).Index == -1 && PlayersFaction.EffectBundleList.FindIf( Key == '3k_xyy_roguelike_dummy' ).Index == -1",
			precondition = "false",
			--Info for script use only, UI shouldn't need this
			effect_bundle_duration = 10,
			turns_till_active = 0
		},
		["3k_dlc07_scheme_province_faction_support_douse_the_fires_of_rebellion"] = {
			title_key = "3k_dlc07_scheme_province_faction_support_douse_the_fires_of_rebellion_title",
			icon_path = "ui/skins/default/schemes/3k_dlc07_scheme_faction_support.png",
			description_key = "3k_dlc07_scheme_province_faction_support_douse_the_fires_of_rebellion_description",
			unlock_condition_key = "3k_dlc07_schemes_unlock_condition_our_army_in_other_region_above_50_faction_support",
			effect_bundle_key = "3k_dlc07_scheme_province_faction_support_douse_the_fires_of_rebellion",
			incident_key = "3k_dlc07_scheme_province_faction_support_douse_the_fires_of_rebellion_incident",
			pr_transaction_amount = -5,
			cooldown = 3,
			target = "enemy",
			attributes_key = "cunning",
			precondition =
			"CaoCaoHasMilitaryForceInProvince( this ) && SettlementList.Any( (x) => x.IsPlayerOwned == false && x.FactionSupportContext.OwningFactionSupportDataContext.PercentageValue >= 0.5 )",
			--Info for script use only, UI shouldn't need this
			effect_bundle_duration = 5,
			turns_till_active = 0
		},
		["3k_dlc07_scheme_province_low_population_contain_the_flood_not_the_river"] = {
			title_key = "3k_dlc07_scheme_province_low_population_contain_the_flood_not_the_river_title",
			icon_path = "ui/skins/default/schemes/3k_dlc07_scheme_population_attraction.png",
			description_key = "3k_dlc07_scheme_province_low_population_contain_the_flood_not_the_river_description",
			unlock_condition_key = "3k_dlc07_schemes_unlock_condition_our_army_in_other_region_above_50%_pop",
			effect_bundle_key = "3k_dlc07_scheme_province_low_population_contain_the_flood_not_the_river",
			incident_key = "3k_dlc07_scheme_province_low_population_contain_the_flood_not_the_river_incident",
			pr_transaction_amount = -7,
			cooldown = 3,
			target = "enemy",
			attributes_key = "cunning",
			precondition =
			"IsPlayerCompleteOwner == false && CaoCaoHasMilitaryForceInProvince( this ) && InvolvedFactionsList.Filter( IsRebelFaction == false ).Any( (f) => this.PooledResourceViewContext('3k_main_pooled_resource_population', f).PercentageOfCapacity > 50 )",
			--Info for script use only, UI shouldn't need this
			effect_bundle_duration = 5,
			turns_till_active = 0
		},
		["3k_dlc07_scheme_province_low_public_order_foresight_when_blind"] = {
			title_key = "3k_dlc07_scheme_province_low_public_order_foresight_when_blind_title",
			icon_path = "ui/skins/default/schemes/3k_dlc07_scheme_public_order.png",
			description_key = "3k_dlc07_scheme_province_low_public_order_foresight_when_blind_description",
			unlock_condition_key = "3k_dlc07_schemes_unlock_condition_our_army_in_other_region_below_50_public_order",
			effect_bundle_key = "3k_dlc07_scheme_province_low_public_order_foresight_when_blind",
			incident_key = "3k_dlc07_scheme_province_low_public_order_foresight_when_blind_incident",
			pr_transaction_amount = -5,
			cooldown = 3,
			target = "enemy",
			attributes_key = "cunning",
			precondition =
			"IsPlayerCompleteOwner == false && CaoCaoHasMilitaryForceInProvince( this ) && InvolvedFactionsList.Filter( IsRebelFaction == false ).Any( (x) => this.PublicOrderContext(x).PublicOrder < 50 )",
			--Info for script use only, UI shouldn't need this
			effect_bundle_duration = 5,
			turns_till_active = 0
		},
		["3k_dlc07_scheme_province_low_public_order_tiger_over_the_mouse"] = {
			title_key = "3k_dlc07_scheme_province_low_public_order_tiger_over_the_mouse_title",
			icon_path = "ui/skins/default/schemes/3k_dlc07_scheme_public_order.png",
			description_key = "3k_dlc07_scheme_province_low_public_order_tiger_over_the_mouse_description",
			unlock_condition_key = "3k_dlc07_schemes_unlock_condition_army_public_order",
			effect_bundle_key = "3k_dlc07_scheme_province_low_public_order_tiger_over_the_mouse",
			pr_transaction_amount = 15,
			cooldown = 4,
			target = "self",
			attributes_key = "cunning",
			precondition = "PublicOrderContext.PublicOrder < 0 && CaoCaoHasMilitaryForceInProvince( this )",
			--Info for script use only, UI shouldn't need this
			effect_bundle_duration = 3,
			turns_till_active = 0
		},
		["3k_dlc07_scheme_province_reserves_trapped_fish_above_the_retreating_tide"] = {
			title_key = "3k_dlc07_scheme_province_reserves_trapped_fish_above_the_retreating_tide_title",
			icon_path = "ui/skins/default/schemes/3k_dlc07_scheme_provincial_reserves.png",
			description_key = "3k_dlc07_scheme_province_reserves_trapped_fish_above_the_retreating_tide_description",
			unlock_condition_key = "3k_dlc07_schemes_unlock_condition_decreasing_reserves",
			effect_bundle_key = "3k_dlc07_scheme_province_reserves_trapped_fish_above_the_retreating_tide",
			pr_transaction_amount = 10,
			cooldown = 3,
			target = "self",
			attributes_key = "cunning",
			precondition = "PooledResourceContext('3k_main_pooled_resource_supply').PendingFactorTotal < 0",
			--Info for script use only, UI shouldn't need this
			effect_bundle_duration = 5,
			turns_till_active = 0
		},
		["3k_dlc07_scheme_province_reserves_two_bears_and_one_kill"] = {
			title_key = "3k_dlc07_scheme_province_reserves_two_bears_and_one_kill_title",
			icon_path = "ui/skins/default/schemes/3k_dlc07_scheme_provincial_reserves.png",
			description_key = "3k_dlc07_scheme_province_reserves_two_bears_and_one_kill_description",
			unlock_condition_key = "3k_dlc07_schemes_unlock_condition_our_army_in_other_region",
			effect_bundle_key = "3k_dlc07_scheme_province_reserves_two_bears_and_one_kill",
			incident_key = "3k_dlc07_scheme_province_reserves_two_bears_and_one_kill_incident",
			pr_transaction_amount = -5,
			cooldown = 3,
			target = "enemy",
			attributes_key = "cunning",
			precondition = "IsPlayerCompleteOwner == false && CaoCaoHasMilitaryForceInProvince( this )",
			--Info for script use only, UI shouldn't need this
			effect_bundle_duration = 5,
			turns_till_active = 0
		},
		["3k_dlc07_scheme_region_construction_the_wolf_guarding_over_the_chickens"] = {
			title_key = "3k_dlc07_scheme_region_construction_the_wolf_guarding_over_the_chickens_title",
			icon_path = "ui/skins/default/schemes/3k_dlc07_scheme_construction_time.png",
			description_key = "3k_dlc07_scheme_region_construction_the_wolf_guarding_over_the_chickens_description",
			unlock_condition_key = "3k_dlc07_schemes_unlock_condition_our_army_in_other_region_below_20_reserves",
			effect_bundle_key = "3k_dlc07_scheme_region_construction_the_wolf_guarding_over_the_chickens",
			incident_key = "3k_dlc07_scheme_region_construction_the_wolf_guarding_over_the_chickens_incident",
			pr_transaction_amount = -5,
			cooldown = 3,
			target = "enemy",
			attributes_key = "cunning",
			precondition =
			"IsPlayerCompleteOwner == false && CaoCaoHasMilitaryForceInProvince( this ) && InvolvedFactionsList.Filter( IsRebelFaction == false ).Any( (f) => this.PooledResourceContext('3k_main_pooled_resource_supply', f).Total > 20 )",
			--Info for script use only, UI shouldn't need this
			effect_bundle_duration = 5,
			turns_till_active = 0
		},
		["3k_dlc07_scheme_region_enemy_presence_changing_of_the_seasons"] = {
			title_key = "3k_dlc07_scheme_region_enemy_presence_changing_of_the_seasons_title",
			icon_path = "ui/skins/default/schemes/3k_dlc07_scheme_action_points.png",
			description_key = "3k_dlc07_scheme_region_enemy_presence_changing_of_the_seasons_description",
			unlock_condition_key = "3k_dlc07_schemes_unlock_condition_another_army_in_our_territory",
			effect_bundle_key = "3k_dlc07_scheme_region_enemy_presence_changing_of_the_seasons",
			incident_key = "3k_dlc07_scheme_region_enemy_presence_changing_of_the_seasons_incident",
			pr_transaction_amount = -5,
			cooldown = 4,
			target = "enemy",
			attributes_key = "cunning",
			precondition = "RegionOwnerFactionContext == PlayersFaction",
			--Info for script use only, UI shouldn't need this
			effect_bundle_duration = 3,
			turns_till_active = 0
		},
		["3k_dlc07_scheme_army_campaigning_arrows_from_the_enemy"] = {
			title_key = "3k_dlc07_scheme_army_campaigning_arrows_from_the_enemy_title",
			icon_path = "ui/skins/default/schemes/3k_dlc07_scheme_army_supplies.png",
			description_key = "3k_dlc07_scheme_army_campaigning_arrows_from_the_enemy_description",
			unlock_condition_key = "3k_dlc07_schemes_unlock_condition_low_supplies",
			effect_bundle_key = "3k_dlc07_scheme_army_campaigning_arrows_from_the_enemy",
			pr_transaction_amount = 10,
			cooldown = 2,
			target = "self",
			attributes_key = "cunning",
			precondition = "MoraleContext.CurrentMorale <= 25",
			--Info for script use only, UI shouldn't need this
			effect_bundle_duration = 3,
			turns_till_active = 0
		},
		["3k_dlc07_scheme_region_neutral_presence_children_in_the_hand"] = {
			title_key = "3k_dlc07_scheme_region_neutral_presence_children_in_the_hand_title",
			icon_path = "ui/skins/default/schemes/3k_dlc07_scheme_diplomatic_relations.png",
			description_key = "3k_dlc07_scheme_region_neutral_presence_children_in_the_hand_description",
			unlock_condition_key = "3k_dlc07_schemes_unlock_condition_another_faction_we_are_not_allied_with",
			effect_bundle_key = "3k_dlc07_scheme_region_neutral_presence_children_in_the_hand",
			incident_key = "3k_dlc07_scheme_region_neutral_presence_children_in_the_hand_incident",
			pr_transaction_amount = -3,
			cooldown = 3,
			target = "enemy",
			attributes_key = "cunning",
			precondition =
			"IsContextValid( DiplomacyAllianceContext ) == false || DiplomacyAllianceContext.FactionList.Find( PlayersFaction ).Index == -1",
			--Info for script use only, UI shouldn't need this
			effect_bundle_duration = 1,
			turns_till_active = 0
		},
		--[[["3k_dlc07_scheme_faction_trade_influence_mastery_of_the_dragons_way"] = {
			title_key = "3k_dlc07_scheme_faction_trade_influence_mastery_of_the_dragons_way_title",
			icon_path = "ui/skins/default/schemes/3k_dlc07_scheme_trade_influence.png",
			description_key = "3k_dlc07_scheme_faction_trade_influence_mastery_of_the_dragons_way_description",
			unlock_condition_key = "3k_dlc07_schemes_unlock_condition_another_faction_with_trade_with_someone_else",
			effect_bundle_key = "3k_dlc07_scheme_faction_trade_influence_mastery_of_the_dragons_way",
			incident_key = "3k_dlc07_scheme_faction_trade_influence_mastery_of_the_dragons_way_incident",
			pr_transaction_amount = -5,
			cooldown = 3,
			target = "enemy",
			attributes_key = "cunning",
			precondition = "IsContextValid( DiplomacyTradingList.FirstContext( PlayersFaction ) )",
			--Info for script use only, UI shouldn't need this
			effect_bundle_duration = 5,
			turns_till_active = 0
		},]] --
	},
}

--- @function get_activation_status
--- @desc Returs the table that contains a the most recent target and the cooldown of all schemes
--- @r the table
function cao_cao_schemes:get_activation_status()
	local activation_status_table = {}
	if cm:saved_value_exists("dlc07_cao_cao_schemes_activation_status") then
		activation_status_table = cm:get_saved_value("dlc07_cao_cao_schemes_activation_status")
	else
		cm:set_saved_value("dlc07_cao_cao_schemes_activation_status", activation_status_table)
	end

	return activation_status_table
end;

--- @function new_game
--- @desc Fires when the player starts a new campaign. Used to initialise things just once (usually saved values).
--- @r nil
function cao_cao_schemes:new_game()
end;

--- @function initialise
--- @desc Fires every campaign (after new_game if it's a new campaign). Sets things up such as listeners and the like.
--- @r nil
function cao_cao_schemes:initialise()
	self:setup_listeners()
	self:setup_debug_listeners()
	-- Initialise the tech saving system for the free tech schemes
	if not cm:saved_value_exists("dlc07_cao_cao_schemes_tech_cooldown", "dlc07_cao_cao_schemes") then
		cm:set_saved_value("dlc07_cao_cao_schemes_tech_cooldown", 0, "dlc07_cao_cao_schemes")
	end

	-- Load the scheme activation status
	local activation_status_table = self:get_activation_status()

	-- Initialise the starting cooldown values for schemes based on which campaign we're in. Uses default setting if there's no override
	if not cm:saved_value_exists("dlc07_cao_cao_schemes_initial_cooldowns", "dlc07_cao_cao_schemes") then
		cm:set_saved_value("dlc07_cao_cao_schemes_initial_cooldowns", true, "dlc07_cao_cao_schemes")

		for key, scheme in pairs(self.schemes_data) do
			if scheme["initial_cooldown"] then
				if scheme["initial_cooldown"][cm.name] then
					--Set the cooldown to the intended value + 1, as it'll be reduced by 1 at the start of the turn
					scheme["turns_till_active"] = scheme["initial_cooldown"][cm.name] + 1

					-- Get the save table
					activation_status_table[key] = {}
					-- Append the new value
					activation_status_table[key]["turns_till_active"] = scheme["turns_till_active"]
					activation_status_table[key]["most_recent_target_cqi"] = scheme["most_recent_target_cqi"]
				end
			end
		end

		-- Save out activation_status_table
		cm:set_saved_value("dlc07_cao_cao_schemes_activation_status", activation_status_table)
	end

	-- go through all schemes and apply the loaded values
	for key, scheme in pairs(activation_status_table) do
		if self.schemes_data[key] ~= nil then
			self.schemes_data[key]["turns_till_active"] = scheme["turns_till_active"]
			self.schemes_data[key]["most_recent_target_cqi"] = scheme["most_recent_target_cqi"]
		end
	end

	self:update_list()
	self:update_pawn_ui();
end;

function cao_cao_schemes:setup_debug_listeners()
	--Listener for turn change so we deduct from cooldowns
	core:add_listener(
		"cao_cao_schemes_listener",         --UID (unique id?)
		"ModelScriptNotificationEvent",     --Event
		function(model_script_notification_event) --Conditions for firing
			if not string.find(model_script_notification_event:event_id(), "DevSchemesResetCooldown") then
				return false;
			end

			return true;
		end,
		function() -- Function to fire			
			output("****** SCHEMES DEV - Reset CDs! ******")

			for key, scheme in pairs(self.schemes_data) do
				scheme["turns_till_active"] = 0
			end

			effect.call_context_command("UiMsg('DevSchemesCooldownReset')");
		end,
		true -- Is Persistent?
	)
end;

function cao_cao_schemes:scheme_pooled_resource_transaction(amount)
	local pooled_resource = cm:query_faction(self.cao_cao_faction_key):pooled_resources():resource(self.cao_cao_pr_key)
	if pooled_resource:is_null_interface() then
		script_error(string.format("Failed to find pooled resource for Cao Cao"))
		return false
	end

	local factor_key = "3k_main_pooled_factor_credibility"
	cm:modify_model():get_modify_pooled_resource(pooled_resource):apply_transaction_to_factor(factor_key, amount);
end

--[[
****************************
PAWNS
****************************
]] --

function cao_cao_schemes:update_list()
	if not cm:get_saved_value("roguelike_mode")
		and cm:query_faction("3k_main_faction_cao_cao"):is_human()
		and not cm:query_faction("3k_main_faction_cao_cao"):has_effect_bundle("3k_xyy_character_sold_out_dummy")
	then
		cao_cao_schemes.schemes_data["3k_dlc07_scheme_faction_misc_of_give_ticket"]["precondition"] = "true"
	else
        if  not cm:get_saved_value("roguelike_mode") then
            cao_cao_schemes.schemes_data["3k_dlc07_scheme_faction_misc_of_give_ticket"]["precondition"] = "false"
		else
            cao_cao_schemes.schemes_data["3k_dlc07_scheme_faction_misc_of_give_ticket"] = {
                title_key = "3k_dlc07_scheme_faction_trade_influence_mastery_of_the_dragons_way_title",
                icon_path = "ui/skins/default/schemes/3k_dlc07_scheme_trade_influence.png",
                description_key = "3k_dlc07_scheme_faction_trade_influence_mastery_of_the_dragons_way_description",
                unlock_condition_key = "3k_dlc07_schemes_unlock_condition_another_faction_with_trade_with_someone_else",
                effect_bundle_key = "3k_dlc07_scheme_faction_trade_influence_mastery_of_the_dragons_way",
                incident_key = "3k_dlc07_scheme_faction_trade_influence_mastery_of_the_dragons_way_incident",
                pr_transaction_amount = -5,
                cooldown = 3,
                target = "enemy",
                attributes_key = "cunning",
                precondition = "IsContextValid( DiplomacyTradingList.FirstContext( PlayersFaction ) )",
                --Info for script use only, UI shouldn't need this
                effect_bundle_duration = 5,
                turns_till_active = 0
            }
		end
	end
	if cm:query_model():season() == "season_spring" then
		cao_cao_schemes.schemes_data["3k_dlc07_scheme_faction_tech_summer_dominion_over_the_realm"]["cooldown"] = 5
	elseif cm:query_model():season() == "season_summer" then
		cao_cao_schemes.schemes_data["3k_dlc07_scheme_faction_tech_summer_dominion_over_the_realm"]["cooldown"] = 5
	elseif cm:query_model():season() == "season_harvest" then
		cao_cao_schemes.schemes_data["3k_dlc07_scheme_faction_tech_summer_dominion_over_the_realm"]["cooldown"] = 4
	elseif cm:query_model():season() == "season_autumn" then
		cao_cao_schemes.schemes_data["3k_dlc07_scheme_faction_tech_summer_dominion_over_the_realm"]["cooldown"] = 3
	elseif cm:query_model():season() == "season_winter" then
		cao_cao_schemes.schemes_data["3k_dlc07_scheme_faction_tech_summer_dominion_over_the_realm"]["cooldown"] = 2
	end
	local schemes = {}
	local index = 1
	for key, scheme in pairs(cao_cao_schemes.schemes_data) do
		schemes[key] = scheme
		index = index + 1
		if index > 30 then
			break;
		end
	end
	effect.set_context_value("dlc07_cao_cao_schemes_list", schemes)
end

function cao_cao_schemes:update_pawn_ui()
	effect.set_context_value("dlc07_cao_cao_schemes_pawn_count", self:get_available_pawns());
	effect.set_context_value("dlc07_cao_cao_schemes_pawn_max", self:get_pawn_cap());

	-- Custom handling when there are no pawns on cooldown.
	if self:get_available_pawns() == self:get_pawn_cap() then
		effect.set_context_value("dlc07_cao_cao_schemes_pawn_cooldown", 0);
	else
		effect.set_context_value("dlc07_cao_cao_schemes_pawn_cooldown", self:get_next_pawn_cooldown());
	end;
end

-- Represents the 'cap' specified by the game,
function cao_cao_schemes:get_pawn_cap()
	return cm:query_faction(self.cao_cao_faction_key):max_undercover_characters();
end

-- Always clamped to 0 or more.
function cao_cao_schemes:get_available_pawns()
	local schemes_on_cooldown = 0;
	for key, scheme in pairs(self.schemes_data) do
		if scheme.turns_till_active > 0 then
			schemes_on_cooldown = schemes_on_cooldown + 1;
		end
	end

	return math.max(self:get_pawn_cap() - schemes_on_cooldown, 0);
end

function cao_cao_schemes:get_next_pawn_cooldown()
	local lowest_cooldown = nil;

	-- We're trying to find the lowest cooldown above 0 here.
	for key, scheme in pairs(self.schemes_data) do
		if scheme.turns_till_active > 0 and (not lowest_cooldown or scheme.turns_till_active < lowest_cooldown) then
			lowest_cooldown = scheme.turns_till_active;
		end;
	end;

	return lowest_cooldown or 0;
end;

--[[
****************************
LISTENERS
****************************
]] --
function cao_cao_schemes:setup_listeners()
	--Listener for turn change so we deduct from cooldowns
	core:add_listener(
		"cao_cao_schemes_listener", --UID (unique id?)
		"FactionTurnStart",   --Event
		function(context)     --Conditions for firing
			return context:faction():name() == self.cao_cao_faction_key
		end,
		function(context) -- Function to fire			
			local activation_status_table = self:get_activation_status()

			--Reduce the cooldown of all schemes by 1 turn
			for key, scheme in pairs(self.schemes_data) do
				if scheme["turns_till_active"] > 0 then
					scheme["turns_till_active"] = scheme["turns_till_active"] - 1
				end

				-- update the saved values
				if activation_status_table[key] ~= nil then
					activation_status_table[key]["turns_till_active"] = scheme["turns_till_active"]
				end
			end

			-- update the UI with the new cooldowns
			self:update_list();

			-- Update the pawns UI.
			self:update_pawn_ui();

			--Handle AI for Schemes
			if not context:faction():is_human() then
				output("********* SCHEME AI CODE **********")

				-- Check if they have any available pawns.
				if self:get_available_pawns() < 1 then
					output("Schemes: Cao Cao AI Faction has no available pawns.")
					return false;
				end;

				local selected_scheme
				local target_faction

				--Check if we're at war with anyone, if so, choose them
				local war_list = cm:query_faction(self.cao_cao_faction_key)
				:factions_we_have_specified_diplomatic_deal_with("treaty_components_war")
				if not war_list:is_empty() then
					--Generate random number for target
					local selected_target_index = cm:random_int(0, war_list:num_items() - 1)
					if not is_number(selected_target_index) then
						script_error("Schemes: Unable to find any valid selected_target_index" ..
						tostring(selected_target_index))
						return false
					end;

					target_faction = war_list:item_at(selected_target_index)

					--Find schemes that target enemies
					local keyset = {}
					for k, v in pairs(self.schemes_data) do
						if v.target == "enemy" then
							table.insert(keyset, k)
						end
					end

					--Choose a random enemy-targetting scheme
					selected_scheme = self.schemes_data[keyset[cm:random_int(1, #keyset)]]
				else
					--Get list of known factions
					local player_faction = cm:query_faction(self.cao_cao_faction_key)
					--Filter out vassals and allies as we don't wanna be mean to them
					local non_ally_factions = player_faction:factions_met():filter(
						function(faction)
							return not faction:is_dead()
								and not diplomacy_manager:is_ally_or_vassal(player_faction, faction)
						end
					)

					if non_ally_factions:is_empty() then
						output("We can't target anyone so skipping this turn though this should seldom, if ever, happen")
						return false
					end

					--Pick a random faction from the non ally list
					target_faction = non_ally_factions:item_at(cm:random_int(0, non_ally_factions:num_items() - 1))

					if not non_ally_factions:is_empty() and target_faction:is_null_interface() then
						script_error("Failed to chose a target faction, this should never happen!")
						return false
					end

					--Fill keyset with all schemes
					local keyset = {}
					for k, v in pairs(self.schemes_data) do
						table.insert(keyset, k)
					end

					--Choose any scheme at all
					selected_scheme = self.schemes_data[keyset[cm:random_int(1, #keyset)]]
				end

				--If the scheme or target faction is nil, we're in trouble!
				if (selected_scheme == nil) then
					script_error("Scheme is null somehow! This should never happen")
					return false
				end

				if target_faction == nil then
					script_error("Target faction is null somehow! This should never happen")
					return false
				end

				--Dev debug output for the time being
				output(string.format("Chosen Scheme : %s, Chosen Target : %s", selected_scheme.title_key,
					target_faction:name()))

				-- Setup an incident to notify the recipient
				local incident = nil
				if target_faction:is_human() and selected_scheme.incident_key then
					incident = cm:modify_model():create_incident(selected_scheme.incident_key)
				end

				--Find target from chosen scheme's effect bundle
				local target_type = cm:query_model():target_from_effect_bundle_key(selected_scheme.effect_bundle_key)
				--Depending on target type (character, faction, province, force), apply the scheme in a specific way
				if target_type == "character" then
					--We could pick a random character within the faction but atm just sticking with faction leader
					local faction_leader = target_faction:faction_leader()
					if faction_leader:is_null_interface() then
						script_error(string.format("Failed to find faction leader for faction (%s)",
							target_faction:name()))
						return false
					end

					output(string.format("Applying effect bundle %s on faction leader in faction %s",
						selected_scheme.effect_bundle_key, target_faction:name()))
					cm:modify_character(faction_leader:command_queue_index()):apply_effect_bundle(
						selected_scheme.effect_bundle_key,
						selected_scheme.effect_bundle_duration
					)
					if incident then
						incident:add_character_target("target_character_1", faction_leader);
					end
				elseif target_type == "faction" then
					output(string.format("Applying effect bundle %s on faction %s", selected_scheme.effect_bundle_key,
						target_faction:name()))
					cm:modify_faction(target_faction:name()):apply_effect_bundle(
						selected_scheme.effect_bundle_key,
						selected_scheme.effect_bundle_duration
					)

					if incident then
						incident:add_faction_target("target_faction_1", target_faction);
					end
				elseif target_type == "force" then
					--Randomly select force in faction
					--TODO: Add the ability to reselect a faction if the current selection has no military forces (which seems very unlikely but just in case)
					local force_list = cm:query_faction(target_faction:name()):military_force_list():filter(function(mf)
						return not mf:is_armed_citizenry()
							and mf:has_general()
							and not misc:is_transient_character(mf:general_character())
					end)
					if not force_list:is_empty() then
						local selected_force_index = cm:random_int(0, force_list:num_items() - 1)
						--Failed to RNG number?
						if not is_number(selected_force_index) then
							script_error("Schemes: Unable to find any valid selected_force_index" ..
							tostring(selected_force_index))
							return false
						end
						--Is the selected force legit?
						local selected_force = force_list:item_at(selected_force_index)
						if selected_force:is_null_interface() then
							script_error(string.format(
							"Failed to find force at index (%i) in force list for faction (%s)", selected_force_index,
								target_faction:name()))
							return false
						end

						--Finally apply the effect bundle on the force
						output(string.format("Applying effect bundle %s on faction force %s",
							selected_scheme.effect_bundle_key,
							force_list:item_at(selected_force_index):command_queue_index()))
						cm:modify_military_force(force_list:item_at(selected_force_index)):apply_effect_bundle(
							selected_scheme.effect_bundle_key,
							selected_scheme.effect_bundle_duration
						)

						if incident then
							incident:add_force_target("target_military_1", selected_force);
						end
					end
				elseif target_type == "province" then
					--Randomly select settlement in one of faction's provinces
					local province_list = target_faction:faction_province_list()
					if not province_list:is_empty() then
						local selected_province_index = cm:random_int(0, province_list:num_items() - 1)
						--Failed to RNG number?
						if not is_number(selected_province_index) then
							script_error("Schemes: Unable to find any valid selected_province_index" ..
							tostring(selected_province_index))
							return false
						end
						--Is selected province legit?
						local selected_faction_province = province_list:item_at(selected_province_index)
						if selected_faction_province:is_null_interface() then
							script_error(string.format(
							"Failed to find province at index (%i) in province list for faction (%s)",
								selected_province_index, target_faction:name()))
							return false
						end

						cm:modify_faction_province(selected_faction_province):apply_effect_bundle(
							selected_scheme.effect_bundle_key,
							selected_scheme.effect_bundle_duration
						)

						local query_region = selected_faction_province:region_list():item_at(0)

						if incident and query_region:owning_faction():is_human() then
							incident:add_region_target("target_region_1", query_region);
							incident_target_faction = query_region:owning_faction();
						end
					end
				else
					script_error("Failed to find matching target type for scheme, this should never happen!")
					return false
				end

				-- Trigger incident.
				if incident then
					incident:trigger(cm:modify_faction(target_faction), true);
				end
			end
		end,
		true -- Is Persistent?
	);

	--Listener for scheme selection from UI panel
	core:add_listener(
		"cao_cao_schemes_listener",         --UID
		"ModelScriptNotificationEvent",     --Event
		function(model_script_notification_event) --Conditions for firing
			return string.find(model_script_notification_event:event_id(), "cao_cao_scheme_applied");
		end,
		function(model_script_notification_event) --Function to fire
			if self:get_available_pawns() < 1 then
				output("Schemes: Not activating current schemes as num pawns < 1");
				return false;
			end;

			local scheme_key = effect.get_context_value("CcoScriptObject", "scheme_key", "StringValue")
			local target_type = effect.get_context_value("CcoScriptObject", "scheme_target_type", "StringValue")
			local target_faction_key = effect.get_context_value("CcoScriptObject", "scheme_target_faction_key",
				"StringValue")
			local target_key = effect.get_context_value("CcoScriptObject", "scheme_target_key", "StringValue")

			output("****** SCHEME INFO ******")
			output(string.format("Selected Scheme - %s", scheme_key))
			output(string.format("Target Type - %s", target_type))
			output(string.format("Target Faction - %s", target_faction_key))
			output(string.format("Target ID - %s", target_key))

			-- Setup an incident to notify the recipient in MPC
			local incident = nil;
			local incident_target_faction = nil;

			if self.schemes_data[scheme_key].incident_key then
				incident = cm:modify_model():create_incident(self.schemes_data[scheme_key].incident_key);
			end

			if target_type == "character" then
				cm:modify_character(target_key):apply_effect_bundle(
					self.schemes_data[scheme_key].effect_bundle_key,
					self.schemes_data[scheme_key].effect_bundle_duration)

				if self.schemes_data[scheme_key].effect_bundle_key == "3k_dlc07_scheme_character_recruitment_of_restore_skill" then
					cm:modify_character(target_key):reset_skills()
				end

				local query_character = cm:query_character(target_key);

				if incident and query_character:faction():is_human() then
					incident:add_character_target("target_character_1", query_character);
					incident_target_faction = query_character:faction();
				end
			elseif target_type == "faction" then
				cm:modify_faction(target_faction_key):apply_effect_bundle(
					self.schemes_data[scheme_key].effect_bundle_key,
					self.schemes_data[scheme_key].effect_bundle_duration)

				local query_faction = cm:query_faction(target_faction_key);
				if incident and query_faction:is_human() then
					incident:add_faction_target("target_faction_1", query_faction);
					incident_target_faction = query_faction;
				end
				if self.schemes_data[scheme_key].automatic_deal_key then
					cm:modify_faction(target_faction_key):apply_automatic_diplomatic_deal(
					self.schemes_data[scheme_key].automatic_deal_key, cm:query_faction("3k_main_faction_cao_cao"),
						"faction_key:" .. target_faction_key);
				end
			elseif target_type == "force" then
				local military_force = cm:query_military_force(target_key)

				if military_force:is_null_interface() then
					script_error(string.format("Failed to find military force for character (%i)", target_key))
				else
					cm:modify_military_force(military_force):apply_effect_bundle(
						self.schemes_data[scheme_key].effect_bundle_key,
						self.schemes_data[scheme_key].effect_bundle_duration)

					-- Replenish AP for the force if it's the AP boosting scheme
					if self.schemes_data[scheme_key].effect_bundle_key == "3k_dlc07_scheme_army_campaigning_hawk_and_tiger_manoeuvres" then
						cm:modify_character(military_force:general_character()):replenish_action_points()
					end

					if incident and military_force:faction():is_human() then
						incident:add_force_target("target_military_1", military_force);
						incident_target_faction = military_force:faction();
					end
				end
			elseif target_type == "province" then
				local query_faction_province = cm:query_faction_province(tonumber(target_key), target_faction_key)

				if not query_faction_province or query_faction_province:is_null_interface() then
					script_error(string.format("Failed to find faction province for %s in province (%i)",
						target_faction_key, target_key))
				else
					cm:modify_faction_province(query_faction_province):apply_effect_bundle(
						self.schemes_data[scheme_key].effect_bundle_key,
						self.schemes_data[scheme_key].effect_bundle_duration)

					local query_region = query_faction_province:region_list():item_at(0)

					if incident and query_region:owning_faction():is_human() then
						incident:add_region_target("target_region_1", query_region);
						incident_target_faction = query_region:owning_faction();
					end
				end

				--this branch is currently unused but I've kept it just in case since the work is done	
			elseif target_type == "region" then
				local trimmed_target_key = string.gsub(target_key, "settlement:", "");

				cm:modify_region(trimmed_target_key):apply_effect_bundle(
					self.schemes_data[scheme_key].effect_bundle_key,
					self.schemes_data[scheme_key].effect_bundle_duration)

				local query_region = cm:query_region(trimmed_target_key)

				if incident and query_region:owning_faction():is_human() then
					incident:add_region_target("target_region_1", query_region);
					incident_target_faction = query_region:owning_faction();
				end
			else
				script_error("Failed to find matching target type for scheme, this should never happen!")
			end

			-- Trigger incident in MPC
			if incident and incident_target_faction then
				incident:trigger(cm:modify_faction(incident_target_faction), true);
			end

			if string.find(scheme_key, "scheme_faction_tech") then
				local tech_cooldown
				if cm:query_model():season() == "season_spring" then
                    tech_cooldown = 5
                elseif cm:query_model():season() == "season_summer" then
                    tech_cooldown = 4
                elseif cm:query_model():season() == "season_harvest" then
                    tech_cooldown = 3
                elseif cm:query_model():season() == "season_autumn" then
                    tech_cooldown = 2
                elseif cm:query_model():season() == "season_winter" then
                    tech_cooldown = 1
                end
				cm:set_saved_value("dlc07_cao_cao_schemes_tech_cooldown", tech_cooldown, "dlc07_cao_cao_schemes")
				cm:modify_faction(self.cao_cao_faction_key):set_tech_research_cooldown(0)
			end

			-- set the cooldown
			self:scheme_pooled_resource_transaction(self.schemes_data[scheme_key].pr_transaction_amount)
			self.schemes_data[scheme_key].turns_till_active = self.schemes_data[scheme_key].cooldown
			self.update_list()

			-- save out scheme, cooldown and target
			-- get the save table
			local activation_status_table = {}
			if cm:saved_value_exists("dlc07_cao_cao_schemes_activation_status") then
				activation_status_table = cm:get_saved_value("dlc07_cao_cao_schemes_activation_status")
			end
			activation_status_table[scheme_key] = {}
			-- append the new value
			activation_status_table[scheme_key]["most_recent_target_cqi"] = target_key
			activation_status_table[scheme_key]["turns_till_active"] = self.schemes_data[scheme_key].turns_till_active
			-- save out activation_status_table
			cm:set_saved_value("dlc07_cao_cao_schemes_activation_status", activation_status_table)

			-- UI Msg so icons can be added to the HUD etc
			effect.call_context_command("UiMsg('CaoCaoSchemeApplied')")

			self:update_pawn_ui();
		end,
		true -- Is Persistent?
	)


	--Listener to reset tech cooldown back to the previous value after getting a free tech from a scheme
	core:add_listener(
		"CaoCaoSchemesResearchStarted", -- Unique handle
		"ResearchStarted",        -- Campaign Event to listen for
		function(context)         -- Listener condition
			return context:faction():name() == self.cao_cao_faction_key
		end,
		function() -- What to do if listener fires.
			local tech_cooldown = cm:get_saved_value("dlc07_cao_cao_schemes_tech_cooldown", "dlc07_cao_cao_schemes")
			if tech_cooldown > 0 then
				cm:modify_faction(self.cao_cao_faction_key):set_tech_research_cooldown(tech_cooldown)
				cm:set_saved_value("dlc07_cao_cao_schemes_tech_cooldown", 0, "dlc07_cao_cao_schemes")
			end
		end,
		true --is persistent
	);

	core:add_listener(
		"cao_cao_schemes_repush_data",
		"UICreated",
		function()
			return cm:query_faction(self.cao_cao_faction_key):is_human();
		end,
		function()
			self:update_list();
			self:update_pawn_ui();
		end,
		true
	)
end

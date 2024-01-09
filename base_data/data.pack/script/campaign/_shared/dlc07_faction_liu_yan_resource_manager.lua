---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------
----- Name:			dlc07_faction_liu_yan_resource_manager.lua
----- Description: 	This script handles liu yan / liu zhang inheritance mechanic
---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------

-- Don't load in campaigns which don't require it.
if cm.name == "ep_eight_princes" then
	output("dlc07_faction_liu_yan_resource_manager.lua: Not loaded in this campaign." );
	return;
else
	output("dlc07_faction_liu_yan_resource_manager.lua: Loading");
end;

-- self initialiser
cm:add_first_tick_callback_new(function() liu_yan_features:new_game() end); -- Fires on the first tick of a New Campaign
cm:add_first_tick_callback(function() liu_yan_features:initialise() end); -- fires on the first tick of every game loaded.

--this faction is led by liu yan or liu zhang. for simplicity of writing it will be reffered as "liu yan" for this entire document,
--but the script applies for both

--liu yan campaign data
liu_yan_features = {

	debug_mode = false,

	liu_yan_faction_key = "3k_main_faction_liu_yan",
	liu_yan_pooled_resource_key = "3k_dlc07_pooled_resource_ambition",
	liu_yan_tradeoff_tracker_resource_key = "3k_dlc07_pooled_resource_tradeoffs_tracker",

	is_records_mode = false,


	--the "ambition panel data pack" contains the information which makes the individual bits of the feature work
	--this entire pack is sent over to the UI so it can have the data it needs to display things
	--it is loaded at campaign load, and saved whenever there is a change to it.
	ambition_panel_data_pack = {

		liu_yan_faction_leader_cqi = 0,
		turns_cooldown_rewards = 20,
		turns_cooldown_tradeoffs = 5,
		turns_upgrade_tradeoffs = 5,
	
		has_inherited = false,
		date_inherited = 0,
		is_inheritable = false,

		inheritance_dates = {
			{start_year = 190, end_year = 194 },
			{start_year = 195, end_year = 198 },			
			{start_year = 199, end_year = 200 },
			{start_year = 201}	
		},

		inheritance_effects_list = {
			["3k_dlc07_effect_bundle_liu_yan_ambition_inheritance_timely"] = {
				icon_path = "3k_dlc07_ambition_date_icon_1.png",
				effect_bundle = "3k_dlc07_effect_bundle_liu_yan_ambition_inheritance_timely",
				first_valid_year = 0,
				last_valid_year = 194
			},
			["3k_dlc07_effect_bundle_liu_yan_ambition_inheritance_delayed"] = {
				icon_path = "3k_dlc07_ambition_date_icon_2.png",
				effect_bundle = "3k_dlc07_effect_bundle_liu_yan_ambition_inheritance_delayed",
				first_valid_year = 195,
				last_valid_year = 198
			},
			["3k_dlc07_effect_bundle_liu_yan_ambition_inheritance_late"] = {
				icon_path = "3k_dlc07_ambition_date_icon_3.png",
				effect_bundle = "3k_dlc07_effect_bundle_liu_yan_ambition_inheritance_late",
				first_valid_year = 199,
				last_valid_year = 200
			},
			["3k_dlc07_effect_bundle_liu_yan_ambition_inheritance_forgotten"] = {
				icon_path = "3k_dlc07_ambition_date_icon_4.png",
				effect_bundle = "3k_dlc07_effect_bundle_liu_yan_ambition_inheritance_forgotten",
				first_valid_year = 201,
				last_valid_year = 999
			}	
		},

		mission_list = {
			["3k_dlc07_liu_yan_ambition_task_developed_town"] = {
				icon_path = "3k_dlc07_ambition_mission_the_shining_capital.png",
				title = "3k_dlc07_liu_yan_ambition_task_developed_town_title",
				description = "3k_dlc07_liu_yan_ambition_task_developed_town_desc",
				objective = "3k_dlc07_liu_yan_ambition_task_developed_town_objective",
				related_incident = "3k_dlc07_scripted_incident_liu_yan_task_completed_shining_capital",
				parts_completed = 0,
				parts_to_complete_total = 6,
				is_complete = false,
				reward_key = "3k_dlc07_effect_bundle_liu_yan_ambition_reward_build_times"
			},
			["3k_dlc07_liu_yan_ambition_task_full_stack_armies"] = {
				icon_path = "3k_dlc07_ambition_mission_stern_defense_and_cutting_attack.png",
				title = "3k_dlc07_liu_yan_ambition_task_full_stack_armies_title",
				description = "3k_dlc07_liu_yan_ambition_task_full_stack_armies_desc",
				objective = "3k_dlc07_liu_yan_ambition_task_full_stack_armies_objective",
				related_incident = "3k_dlc07_scripted_incident_liu_yan_task_completed_stern_defence_cutting_attack",
				parts_completed = 0,
				parts_to_complete_total = 3,
				is_complete = false,
				reward_key = "3k_dlc07_effect_bundle_liu_yan_ambition_reward_cheaper_recruitment"
			},
			["3k_dlc07_liu_yan_ambition_task_high_income"] = {
				icon_path = "3k_dlc07_ambition_mission_flowing_gold.png",
				title = "3k_dlc07_liu_yan_ambition_task_high_income_title",
				description = "3k_dlc07_liu_yan_ambition_task_high_income_desc",
				objective = "3k_dlc07_liu_yan_ambition_task_high_income_objective",
				related_incident = "3k_dlc07_scripted_incident_liu_yan_task_completed_flowing_gold",
				parts_completed = 0,
				parts_to_complete_total = 1500,
				is_complete = false,
				reward_key = "3k_dlc07_effect_bundle_liu_yan_ambition_reward_gdp_buff"			
			},
			["3k_dlc07_liu_yan_ambition_task_know_factions"] = {
				icon_path = "3k_dlc07_ambition_mission_worldwide_contacts.png",
				title = "3k_dlc07_liu_yan_ambition_task_know_factions_title",
				description = "3k_dlc07_liu_yan_ambition_task_know_factions_desc",
				objective = "3k_dlc07_liu_yan_ambition_task_know_factions_objective",
				related_incident = "3k_dlc07_scripted_incident_liu_yan_task_completed_worldwide_contacts",
				parts_completed = 0,
				parts_to_complete_total = 15,
				is_complete = false,
				reward_key = "3k_dlc07_effect_bundle_liu_yan_ambition_reward_ancillary_spawn"			
			},
			["3k_dlc07_liu_yan_ambition_task_lead_battles"] = {
				icon_path = "3k_dlc07_ambition_mission_experienced_general.png",
				title = "3k_dlc07_liu_yan_ambition_task_lead_battles_title",
				description = "3k_dlc07_liu_yan_ambition_task_lead_battles_desc",
				objective = "3k_dlc07_liu_yan_ambition_task_lead_battles_objective",
				related_incident = "3k_dlc07_scripted_incident_liu_yan_task_completed_experienced_general",
				parts_completed = 0,
				parts_to_complete_total = 5,
				is_complete = false,
				reward_key = "3k_dlc07_effect_bundle_liu_yan_ambition_reward_character_exp"		
			},
			["3k_dlc07_liu_yan_ambition_task_own_regions"] = {
				icon_path = "3k_dlc07_ambition_mission_swelling_domain.png",
				title = "3k_dlc07_liu_yan_ambition_task_own_regions_title",
				description = "3k_dlc07_liu_yan_ambition_task_own_regions_desc",
				objective = "3k_dlc07_liu_yan_ambition_task_own_regions_objective",
				related_incident = "3k_dlc07_scripted_incident_liu_yan_task_completed_swelling_domain",
				parts_completed = 0,
				parts_to_complete_total = 10,
				is_complete = false,
				reward_key = "3k_dlc07_effect_bundle_liu_yan_ambition_reward_defensive_army_buffs"			
			},
			["3k_dlc07_liu_yan_ambition_task_reach_level"] = {
				icon_path = "3k_dlc07_ambition_mission_trained_and_wise.png",
				title = "3k_dlc07_liu_yan_ambition_task_reach_level_title",
				description = "3k_dlc07_liu_yan_ambition_task_reach_level_desc",
				objective = "3k_dlc07_liu_yan_ambition_task_reach_level_objective",
				related_incident = "3k_dlc07_scripted_incident_liu_yan_task_completed_trained_wise",
				parts_completed = 0,
				parts_to_complete_total = 1,
				is_complete = false,
				reward_key = "3k_dlc07_effect_bundle_liu_yan_ambition_reward_factionwide_exp_gain"			
			},
			["3k_dlc07_liu_yan_ambition_task_win_duels"] = {
				icon_path = "3k_dlc07_ambition_mission_lethal_duelist.png",
				title = "3k_dlc07_liu_yan_ambition_task_win_duels_title",
				description = "3k_dlc07_liu_yan_ambition_task_win_duels_desc",
				objective = "3k_dlc07_liu_yan_ambition_task_win_duels_objective",
				related_incident = "3k_dlc07_scripted_incident_liu_yan_task_completed_lethal_duelist",
				parts_completed = 0,
				parts_to_complete_total = 3,
				is_complete = false,
				reward_key = "3k_dlc07_effect_bundle_liu_yan_ambition_reward_replenishment_buff"			
			}
		},

		tradeoff_list = {
			["3k_dlc07_effect_bundle_liu_yan_ambition_tradeoff_trade_influence"] = {
				icon_path = "3k_dlc07_trade_off_market_protectionism.png",
				bundle_key =
					{
					"3k_dlc07_effect_bundle_liu_yan_ambition_tradeoff_trade_influence_1",
					"3k_dlc07_effect_bundle_liu_yan_ambition_tradeoff_trade_influence_2",
					"3k_dlc07_effect_bundle_liu_yan_ambition_tradeoff_trade_influence_3"
					},
				can_be_toggled = true,
				turn_toggled = -1,
				is_enabled =  false,
				current_tier = 1
			},
			["3k_dlc07_effect_bundle_liu_yan_ambition_tradeoff_satisfaction"] = {
				icon_path = "3k_dlc07_trade_off_loyalty_ispections.png",
				bundle_key = 
					{
						"3k_dlc07_effect_bundle_liu_yan_ambition_tradeoff_satisfaction_1",
						"3k_dlc07_effect_bundle_liu_yan_ambition_tradeoff_satisfaction_2",
						"3k_dlc07_effect_bundle_liu_yan_ambition_tradeoff_satisfaction_3"
					},
				can_be_toggled = true,
				turn_toggled = -1,
				is_enabled =  false,
				current_tier = 1
			},
			["3k_dlc07_effect_bundle_liu_yan_ambition_tradeoff_public_order"] = {
				icon_path = "3k_dlc07_trade_off_public_checkpoints.png",
				bundle_key = 
					{
						"3k_dlc07_effect_bundle_liu_yan_ambition_tradeoff_public_order_1",
						"3k_dlc07_effect_bundle_liu_yan_ambition_tradeoff_public_order_2",
						"3k_dlc07_effect_bundle_liu_yan_ambition_tradeoff_public_order_3"
					},
				can_be_toggled = true,
				turn_toggled = -1,
				is_enabled =  false,
				current_tier = 1			
			},
			["3k_dlc07_effect_bundle_liu_yan_ambition_tradeoff_military_supplies"] = {
				icon_path = "3k_dlc07_trade_off_military_surplus_to_market.png",
				bundle_key = 
					{
						"3k_dlc07_effect_bundle_liu_yan_ambition_tradeoff_military_supplies_1",
						"3k_dlc07_effect_bundle_liu_yan_ambition_tradeoff_military_supplies_2",
						"3k_dlc07_effect_bundle_liu_yan_ambition_tradeoff_military_supplies_3"
					},
				can_be_toggled = true,
				turn_toggled = -1,
				is_enabled =  false,
				current_tier = 1			
			},
			["3k_dlc07_effect_bundle_liu_yan_ambition_tradeoff_gdp_debuff"] = {
				icon_path = "3k_dlc07_trade_off_divert_to_coffers.png",
				bundle_key = 
					{
						"3k_dlc07_effect_bundle_liu_yan_ambition_tradeoff_gdp_debuff_1",
						"3k_dlc07_effect_bundle_liu_yan_ambition_tradeoff_gdp_debuff_2",
						"3k_dlc07_effect_bundle_liu_yan_ambition_tradeoff_gdp_debuff_3"
					},
				can_be_toggled = true,
				turn_toggled = -1,
				is_enabled =  false,
				current_tier = 1			
			},
			["3k_dlc07_effect_bundle_liu_yan_ambition_tradeoff_construction_time"] = {
				icon_path = "3k_dlc07_trade_off_construction_inspectors.png",
				bundle_key =
					{
						"3k_dlc07_effect_bundle_liu_yan_ambition_tradeoff_construction_time_1",
						"3k_dlc07_effect_bundle_liu_yan_ambition_tradeoff_construction_time_2",
						"3k_dlc07_effect_bundle_liu_yan_ambition_tradeoff_construction_time_3"
					},
				can_be_toggled = true,
				turn_toggled = -1,
				is_enabled =  false,
				current_tier = 1			
			},
			["3k_dlc07_effect_bundle_liu_yan_ambition_tradeoff_character_salaries"] = {
				icon_path = "3k_dlc07_trade_off_raised_court_standards.png",
				bundle_key = 
					{
						"3k_dlc07_effect_bundle_liu_yan_ambition_tradeoff_character_salaries_1",
						"3k_dlc07_effect_bundle_liu_yan_ambition_tradeoff_character_salaries_2",
						"3k_dlc07_effect_bundle_liu_yan_ambition_tradeoff_character_salaries_3"
					},
				can_be_toggled = true,
				turn_toggled = -1,
				is_enabled =  false,
				current_tier = 1		
			},
			["3k_dlc07_effect_bundle_liu_yan_ambition_tradeoff_army_maintenance"] = {
				icon_path = "3k_dlc07_trade_off_smith_education.png",
				bundle_key = 
					{
						"3k_dlc07_effect_bundle_liu_yan_ambition_tradeoff_army_maintenance_1",
						"3k_dlc07_effect_bundle_liu_yan_ambition_tradeoff_army_maintenance_2",
						"3k_dlc07_effect_bundle_liu_yan_ambition_tradeoff_army_maintenance_3"
					},
				can_be_toggled = true,
				turn_toggled = -1,
				is_enabled =  false,
				current_tier = 1			
			}
		
		},
		
		reward_list = {
			["3k_dlc07_effect_bundle_liu_yan_ambition_reward_replenishment_buff"] = {
				icon_path = "3k_dlc07_ambition_bonus_recruitement_posters.png",
				bundle_key = "3k_dlc07_effect_bundle_liu_yan_ambition_reward_replenishment_buff",
				target_type = "region",
				turn_duration = 20,
				turn_cooldown = 20,
				ambition_cost = 80,
				is_unlocked = false,
				is_enabled =  false,
				turn_enabled = -1			
			},
			["3k_dlc07_effect_bundle_liu_yan_ambition_reward_gdp_buff"] = {
				icon_path = "3k_dlc07_ambition_bonus_economic_stimulus.png",
				bundle_key = "3k_dlc07_effect_bundle_liu_yan_ambition_reward_gdp_buff",
				target_type = "province_capital",
				turn_duration = 15,
				turn_cooldown = 15,
				ambition_cost = 50,
				is_unlocked = false,
				is_enabled =  false,
				turn_enabled = -1			
			},
			["3k_dlc07_effect_bundle_liu_yan_ambition_reward_factionwide_exp_gain"] = {
				icon_path = "3k_dlc07_ambition_bonus_investment_in_education.png",
				bundle_key = "3k_dlc07_effect_bundle_liu_yan_ambition_reward_factionwide_exp_gain",
				target_type = "none",
				turn_duration = 15,
				turn_cooldown = 15,
				ambition_cost = 120,
				is_unlocked = false,
				is_enabled =  false,
				turn_enabled = -1			
			},
			["3k_dlc07_effect_bundle_liu_yan_ambition_reward_defensive_army_buffs"] = {
				icon_path = "3k_dlc07_ambition_bonus_soldier_drills.png",
				bundle_key = "3k_dlc07_effect_bundle_liu_yan_ambition_reward_defensive_army_buffs",
				target_type = "force",
				turn_duration = 15,
				turn_cooldown = 15,
				ambition_cost = 60,
				is_unlocked = false,
				is_enabled =  false,
				turn_enabled = -1			
			},
			["3k_dlc07_effect_bundle_liu_yan_ambition_reward_cheaper_recruitment"] = {
				icon_path = "3k_dlc07_ambition_bonus_industrial_restructuring.png",
				bundle_key = "3k_dlc07_effect_bundle_liu_yan_ambition_reward_cheaper_recruitment",
				target_type = "region",
				turn_duration = 10,
				turn_cooldown = 10,
				ambition_cost = 50,
				is_unlocked = false,
				is_enabled =  false,
				turn_enabled = -1			
			},
			["3k_dlc07_effect_bundle_liu_yan_ambition_reward_character_exp"] = {
				icon_path = "3k_dlc07_ambition_bonus_private_tutelage.png",
				bundle_key = "3k_dlc07_effect_bundle_liu_yan_ambition_reward_character_exp",
				target_type = "character",
				turn_cooldown = 20,
				ambition_cost = 70,
				is_unlocked = false,
				is_enabled =  false,
				turn_enabled = -1			
			},
			["3k_dlc07_effect_bundle_liu_yan_ambition_reward_build_times"] = {
				icon_path = "3k_dlc07_ambition_bonus_construction_stimulus.png",
				bundle_key = "3k_dlc07_effect_bundle_liu_yan_ambition_reward_build_times",
				target_type = "region",
				turn_cooldown = 20,
				ambition_cost = 90,
				is_unlocked = false,
				is_enabled =  false,
				turn_enabled = -1			
			},
			["3k_dlc07_effect_bundle_liu_yan_ambition_reward_ancillary_spawn"] = {
				icon_path = "3k_dlc07_ambition_bonus_artisan_commisions.png",
				bundle_key = "3k_dlc07_effect_bundle_liu_yan_ambition_reward_ancillary_spawn",
				target_type = "none",
				turn_cooldown = 10,
				ambition_cost = 50,
				is_unlocked = false,
				is_enabled =  false,
				turn_enabled = -1			
			}
			
		},
	},

	experience_points_per_rank = {
		3000,
		8000,
		16000,
		30000,
		53000,
		88000,
		138000,
		206000,
		295000
	}
}

function liu_yan_features:print_data_pack()

	if not self.debug_mode then return end

	--used to monitor the backend of the ambitions panel to ensure it's working
	output("\n\n")
	output("++++++++++++++++++++++ LIU YAN AMBITION PANEL +++++++++++++++++++++++++\n")
	output("------------  BASICS ------------")
	output("Pack Initialised? "..tostring(self.ambition_panel_data_pack.data_pack_initialised))
	output("Inherited? "..tostring(self.ambition_panel_data_pack.has_inherited))
	if self.ambition_panel_data_pack.has_inherited then
		output("Date inherited: "..self.ambition_panel_data_pack.date_inherited)
	end
	output("\n")

	output("------------ TRADE OFFS ------------")
	for tradeoff_key, tradeoff_data in pairs(self.ambition_panel_data_pack.tradeoff_list) do
		output("Tradeoff: "..tradeoff_key)
		output("Is enabled? "..tostring(tradeoff_data.is_enabled))
		if tradeoff_data.is_enabled then
			output("Turn enabled: "..tradeoff_data.turn_toggled..",   current tier: "..tradeoff_data.current_tier)
		end
		output("--")
	end
	output("\n")

	output("------------ MISSIONS ------------")
	for mission_key, mission_data in pairs(self.ambition_panel_data_pack.mission_list) do
		output("Mission: "..mission_key)
		output("Associated reward: "..mission_data.reward_key)
		output("Is completed? "..tostring(mission_data.is_complete))
		if not mission_data.is_complete then
			output("Parts completed: "..mission_data.parts_completed.." out of: "..mission_data.parts_to_complete_total..". Percentage: "..(mission_data.parts_completed/mission_data.parts_to_complete_total*100).."%")
		end
		output("--")
	end
	output("\n")

	output("------------ REWARDS ------------")
	for reward_key, reward_data in pairs(self.ambition_panel_data_pack.reward_list) do
		output("Reward: "..reward_key)
		output("Is unlocked? "..tostring(reward_data.is_unlocked))
		if reward_data.is_unlocked then
			output("Is enabled? "..tostring(reward_data.is_enabled))
			if reward_data.is_enabled then
				output("Turn enabled: "..reward_data.turn_enabled)
			end
		end
		output("--")
	end
	output("\n")

	output("+++++++++++++++++++++ FINISHED WITH AMBITION PANEL ++++++++++++++++++++++++\n\n")
end


--- @function new_game
--- @desc Fires when the player starts a new campaign. Used to initialise things just once (usually saved values).
--- @r nil
function liu_yan_features:new_game()
	
end;

--- @function initialise
--- @desc Fires every campaign (after new_game if it's a new campaign). Sets things up such as listeners and the like.
--- @r nil
function liu_yan_features:initialise()
	
	--blocks the script from initialising if for whatever reason, liu yan's faction key is not in game
	if cm:query_faction(self.liu_yan_faction_key) and not cm:query_faction(self.liu_yan_faction_key):is_null_interface() then
		self:add_cli_listeners()
		self:initialise_data_pack()
		self:ambition_inheritance_screen_UI_listeners()
		-- initialise_data_pack might load in a date/save that has already inherited, so don't add these if that's happened as they can affect the data pack
		if not self.ambition_panel_data_pack.has_inherited then
			self:ambition_mission_progression_listeners()
			self:utility_listeners()
		end
		self:update_ui_lists()
		self:print_data_pack()
	end

end;

function liu_yan_features:add_cli_listeners()

	--trigger_cli_debug_event liu_yan_features.toggle_debug_mode()
	core:add_cli_listener("liu_yan_features.toggle_debug_mode",
		function()
			self.debug_mode = not self.debug_mode
		end
	)

	--trigger_cli_debug_event liu_yan_features.unlock_the_whole_shabang()
	core:add_cli_listener("liu_yan_features.unlock_the_whole_shabang",
		function()
			for mission_key, _ in pairs(self.ambition_panel_data_pack.mission_list) do
				self:complete_task(mission_key)
			end

			for reward_key, reward_data in pairs(self.ambition_panel_data_pack.reward_list) do
				self.ambition_panel_data_pack.reward_list[reward_key].is_unlocked = true
			end
			self:update_ui_lists()
		end
	)

end

function liu_yan_features:ambition_inheritance_screen_UI_listeners()

	--when panel opens, update all the UI-relevant information about this feature
	core:add_listener("liu_yan_ambition_panel_opened",
	"PanelOpenedCampaign",
	function(context)
		return context:component_id() == "3k_dlc07_ambition_panel"
	end,
	function(context)
		-- Create a callback so we have the model interface.
		context:create_model_callback_request("liu_yan_aspiration_panel_opened_model_access_created");
	end,
	true)

	core:add_listener(
		"extended_progression",
		"CampaignModelScriptCallback",
		function(context)
			return context:context():event_id() == "liu_yan_aspiration_panel_opened_model_access_created";
		end,
		function()
			self:update_ui_lists()
			self:print_data_pack()
		end,
		true
	);
	-- The UI sends a message to the system. Which then tells the script what to do

	--[[
	Please use the following format for UI script notifs:

	all of them start with > liu_yan_ui_script_notification_

	add to that the relevant information such as 
	
	liu_yan_ui_script_notification_inheritance_triggered

	liu_yan_ui_script_notification_tradeoff_enabled*

	liu_yan_ui_script_notification_tradeoff_disabled*

	liu_yan_ui_script_notification_reward_enabled*

	*for tradeoff_enabled and reward_enabled, please also add the relevant fxbundle information so:

	liu_yan_ui_script_notification_tradeoff_enabled_3k_dlc07_effect_bundle_liu_yan_ambition_tradeoff_trade_influence

	]]--
    core:add_listener(
        "liu_yan_ambition_panel_ui_event_listener", -- UID
        "ModelScriptNotificationEvent", -- Event
        function(model_script_notification_event) --"invoke_council"
			
			return string.find(model_script_notification_event:event_id(), "liu_yan_ui_script_notification_")
        end, --Conditions for firing
		function(model_script_notification_event)
			
			if string.find(model_script_notification_event:event_id(), "_inheritance_triggered") then
				
				self:inheritance_triggered()

			
			elseif string.find(model_script_notification_event:event_id(), "_tradeoff_disabled_") then
				-- Tradeoffs used to be toggle via the UI but now we've split the functionality. I didn't want to refactor the entire script for this so we guard state
				-- Will M 03/12/2020
				local tradeoff_id = string.gsub(model_script_notification_event:event_id(), "liu_yan_ui_script_notification_tradeoff_disabled_", "")
				if self:is_tradeoff_enabled(tradeoff_id) then
					self:tradeoff_toggled(tradeoff_id, false)
				end

			elseif string.find(model_script_notification_event:event_id(), "_tradeoff_enabled_") then
				-- Tradeoffs used to be toggle via the UI but now we've split the functionality. I didn't want to refactor the entire script for this so we guard state
				-- Will M 03/12/2020
				local tradeoff_id = string.gsub(model_script_notification_event:event_id(), "liu_yan_ui_script_notification_tradeoff_enabled_", "")
				if not self:is_tradeoff_enabled(tradeoff_id) then
					self:tradeoff_toggled(tradeoff_id, false)
				end

			elseif string.find(model_script_notification_event:event_id(), "_reward_enabled") then
				local reward_id = effect.get_context_value("CcoScriptObject", "dlc07_liu_yan_reward_key", "StringValue")
				local target_id = effect.get_context_value("CcoScriptObject", "dlc07_liu_yan_reward_target_key", "StringValue")
				self:reward_enabled(reward_id, target_id)
			end

			self:update_ui_lists()
        end, -- Function to fire.
        true -- Is Persistent?
	);

	-- DEBUG LISTENERS --

		--[[
	Please use the following format for UI script notifs:

	all of them start with > liu_yan_ui_script_debug_notification_

	add to that the relevant information such as 
	
	liu_yan_ui_script_debug_notification_unlock_reward

	]]--
	core:add_listener(
        "liu_yan_ambition_panel_ui_debug_event_listener", -- UID
        "ModelScriptNotificationEvent", -- Event
        function(model_script_notification_event) --"invoke_council"
			
			return string.find(model_script_notification_event:event_id(), "liu_yan_ui_script_debug_notification_")
        end, --Conditions for firing
		function(model_script_notification_event)
			
			if string.find(model_script_notification_event:event_id(), "unlock_reward") then
				local reward_id = effect.get_context_value("CcoScriptObject", "dlc07_liu_yan_reward_key", "StringValue")
				self.ambition_panel_data_pack.reward_list[reward_id].is_unlocked = true
				output("Liu Yan unlocking reward using dev UI: "..reward_id)
			elseif string.find(model_script_notification_event:event_id(), "complete_mission") then
				local mission_key = effect.get_context_value("CcoScriptObject", "dlc07_liu_yan_mission_key", "StringValue")
				self:complete_task(mission_key, true)
				output("Liu Yan completing mission using dev UI: "..mission_key)
			end
			self:update_ui_lists()
        end, -- Function to fire.
        true -- Is Persistent?
	);

	--TRACKS TRADEOFFS
	core:add_listener("dlc07_liu_yan_ambition_tradeoff_manager_listener", "FactionTurnStart",
	function(context)
		return context:faction():name() == self.liu_yan_faction_key and context:faction():is_human()
	end,
	function()

		--TRACKS ENABLING AND DISABLING OF TRADEOFF BONUSES!!
		for tradeoff_key, tradeoff_data in pairs(self.ambition_panel_data_pack.tradeoff_list) do
			
			if tradeoff_data.is_enabled then
				if cm:turn_number() >= tradeoff_data.turn_toggled + self.ambition_panel_data_pack.turns_upgrade_tradeoffs*tradeoff_data.current_tier then
					self:tradeoff_upgraded(tradeoff_key)
				end
			else
				if not tradeoff_data.can_be_toggled then
					if tradeoff_data.turn_toggled + self.ambition_panel_data_pack.turns_cooldown_tradeoffs <= cm:turn_number() then
						self:tradeoff_toggle_cooldown_finished(tradeoff_key)
					end
				end
			end
		end

	end,
	true)

	--TRACKS REWARDS
	core:add_listener("dlc07_liu_yan_ambition_reward_manager_listener", "FactionTurnStart",
	function(context)
		return context:faction():name() == self.liu_yan_faction_key and context:faction():is_human()
	end,
	function()
		--TRACKS ENABLING AND DISABLING OF REWARDS
		for reward_key, reward_data in pairs(self.ambition_panel_data_pack.reward_list) do
			if reward_data.is_enabled then
				if reward_data.turn_enabled + reward_data.turn_cooldown <= cm:turn_number() then
					self:reward_disabled(reward_key)
				end
			end
		end
	end,
	true)

end

--updates the data pack information for all the ambition missions
function liu_yan_features:ambition_mission_progress_update()

	local query_faction_liu_yan = cm:query_faction(self.liu_yan_faction_key)

	--updates the values in the data_pack as needed
	local function check_and_update_mission_completion(mission_key, objective_variable)
		--if objective_variable is greater than total needed, assign parts_completed to total needed and complete mission
		--otherwise save objective_variable
		if objective_variable >= self.ambition_panel_data_pack.mission_list[mission_key].parts_to_complete_total then
			self:complete_task(mission_key)
		else
			self.ambition_panel_data_pack.mission_list[mission_key].parts_completed = objective_variable
		end
	end

	--tracks and updates highest lvl building
	if self.ambition_panel_data_pack.mission_list["3k_dlc07_liu_yan_ambition_task_developed_town"].is_complete == false then
		local highest_building = 0
		for i = 0, query_faction_liu_yan:region_list():num_items() -1 do
			for j = 0, query_faction_liu_yan:region_list():item_at(i):settlement():slot_list():num_items() -1 do

				local slot = query_faction_liu_yan:region_list():item_at(i):settlement():slot_list():item_at(j)
				if slot:has_building() and slot:building():chain() == "3k_city" then
					--subtracts what we don't need from the key, example: 3k_city_4 -> 4
					local building_level = string.gsub(slot:building():name(), "3k_city_", "")
					building_level = tonumber(building_level)
					if building_level > highest_building then
						highest_building = building_level
					end
				end
			end
		end

		check_and_update_mission_completion("3k_dlc07_liu_yan_ambition_task_developed_town", highest_building)
	end

	--tracks full stack armies
	if self.ambition_panel_data_pack.mission_list["3k_dlc07_liu_yan_ambition_task_full_stack_armies"].is_complete == false then
		local fullstack_armies = 0
		for i = 0, query_faction_liu_yan:military_force_list():num_items() -1 do
			local unit_number = query_faction_liu_yan:military_force_list():item_at(i):unit_list():num_items()
			if unit_number >= 21 then
				fullstack_armies = fullstack_armies +1
			end
		end

		check_and_update_mission_completion("3k_dlc07_liu_yan_ambition_task_full_stack_armies", fullstack_armies)
	end

	--tracks income
	if self.ambition_panel_data_pack.mission_list["3k_dlc07_liu_yan_ambition_task_high_income"].is_complete == false then
		local current_income = query_faction_liu_yan:projected_net_income()

		--makes it impossible for current income to go below zero
		current_income = math.max(current_income, 0)

		check_and_update_mission_completion("3k_dlc07_liu_yan_ambition_task_high_income", current_income)
	end

	--tracks known living factions
	if self.ambition_panel_data_pack.mission_list["3k_dlc07_liu_yan_ambition_task_know_factions"].is_complete == false then
		
		local known_factions = query_faction_liu_yan:factions_met():count_if(
			function(faction)
				return not faction:is_dead()
			end
		)

		check_and_update_mission_completion("3k_dlc07_liu_yan_ambition_task_know_factions", known_factions)
	end

	--track owned regions
	if self.ambition_panel_data_pack.mission_list["3k_dlc07_liu_yan_ambition_task_own_regions"].is_complete == false then

		local regions_owned = query_faction_liu_yan:region_list():num_items()

		check_and_update_mission_completion("3k_dlc07_liu_yan_ambition_task_own_regions", regions_owned)
	end

	if self.ambition_panel_data_pack.mission_list["3k_dlc07_liu_yan_ambition_task_win_duels"].is_complete == false then
		check_and_update_mission_completion("3k_dlc07_liu_yan_ambition_task_win_duels", self.ambition_panel_data_pack.mission_list["3k_dlc07_liu_yan_ambition_task_win_duels"].parts_completed)
	end

	if self.ambition_panel_data_pack.mission_list["3k_dlc07_liu_yan_ambition_task_lead_battles"].is_complete == false then
		check_and_update_mission_completion("3k_dlc07_liu_yan_ambition_task_lead_battles", self.ambition_panel_data_pack.mission_list["3k_dlc07_liu_yan_ambition_task_lead_battles"].parts_completed)
	end

	self:save_data_pack()

end

--ambition missions and tradeoffs listeners
function liu_yan_features:ambition_mission_progression_listeners()
	--set up ambition related listeners

	--FIRES INCIDENT TO NOTIFY PLAYER OF INHERITANCE REWARD DECAY
	core:add_listener("dlc07_liu_yan_inheritance_decay_notification_listener", "FactionTurnStart",
	function(context)
		return context:faction():name() == self.liu_yan_faction_key and context:faction():is_human() and not self.ambition_panel_data_pack.has_inherited
		 and ( cm:query_model():calendar_year() == 194 or cm:query_model():calendar_year() == 198 or cm:query_model():calendar_year() == 200 ) and cm:query_model():season() == "season_winter"
	end,
	function(context)
		cm:trigger_incident(self.liu_yan_faction_key, "3k_dlc07_scripted_incident_liu_yan_inheritance_timeline_transition_reminder", true)
	end,
	true)

	--GENERAL TRACKING OF MISSIONS ON A TURN START BASIS
	core:add_listener("dlc07_liu_yan_mission_tracker_turn_start", "FactionTurnStart",
	function(context)
		return context:faction():name() == self.liu_yan_faction_key and context:faction():is_human()
	end,
	function()
		self:update_ui_lists()
	end,
	true)

	--TRACKS RECRUITMENTS
	core:add_listener("dlc07_liu_yan_inheritance_task_recruitment_tracker", "UnitRecruitmentInitiated",
	function(context)
		return context:faction():name() == self.liu_yan_faction_key and context:faction():is_human()
	end,
	function(context)
		--tracks full stack armies
	if self.ambition_panel_data_pack.mission_list["3k_dlc07_liu_yan_ambition_task_full_stack_armies"].is_complete == false then
		local query_faction_liu_yan = cm:query_faction(self.liu_yan_faction_key)
		local fullstack_armies = 0
		for i = 0, query_faction_liu_yan:military_force_list():num_items() -1 do
			local unit_number = query_faction_liu_yan:military_force_list():item_at(i):unit_list():num_items()
			if unit_number >= 20 then
				fullstack_armies = fullstack_armies +1
			end
		end
		if fullstack_armies >= self.ambition_panel_data_pack.mission_list["3k_dlc07_liu_yan_ambition_task_full_stack_armies"].parts_to_complete_total then
			self:complete_task("3k_dlc07_liu_yan_ambition_task_full_stack_armies")
		else
			self.ambition_panel_data_pack.mission_list["3k_dlc07_liu_yan_ambition_task_full_stack_armies"].parts_completed = fullstack_armies
		end
	end
		effect.set_context_value("dlc07_liu_yan_features", self.ambition_panel_data_pack)
	end,
	true)

	--TRACKS BUILDINGS
	core:add_listener("dlc07_liu_yan_inheritance_task_recruitment_tracker", "BuildingCompleted",
	function(context)
		return context:garrison_residence():faction():name() == self.liu_yan_faction_key and context:garrison_residence():faction():is_human()
	end,
	function(context)
		self:update_ui_lists()
	end,
	true)

	--TRACKS MEETING FACTIONS
	core:add_listener("dlc07_liu_yan_inheritance_task_recruitment_tracker", "FactionEncountersOtherFaction",
	function(context)
		return (context:faction():name() == self.liu_yan_faction_key and context:faction():is_human())
		 or (context:other_faction():name() == self.liu_yan_faction_key and context:other_faction():is_human())
	end,
	function(context)
		self:update_ui_lists()
	end,
	true)


	--TRACKS HEIR CHANGE
	core:add_listener("dlc07_liu_yan_new_inheritor_config_listener", "CharacterAssignedToPost",
	function(context)
		--if the character is heir and the heir is different from our previous heir
		local character = context:query_character()

		return not self.ambition_panel_data_pack.has_inherited and
		 character:character_post() and not character:character_post():is_null_interface() and
		 character:character_post():ministerial_position_record_key() == "faction_heir"
		 and character:faction():name() == self.liu_yan_faction_key and character:faction():is_human()
		
	end,
	function()

		if self.ambition_panel_data_pack.mission_list["3k_dlc07_liu_yan_ambition_task_reach_level"].is_complete == false then
			self.ambition_panel_data_pack.mission_list["3k_dlc07_liu_yan_ambition_task_reach_level"].parts_completed = 0
		end

		if self.ambition_panel_data_pack.mission_list["3k_dlc07_liu_yan_ambition_task_lead_battles"].is_complete == false then
			self.ambition_panel_data_pack.mission_list["3k_dlc07_liu_yan_ambition_task_lead_battles"].parts_completed = 0
		end

		if self.ambition_panel_data_pack.mission_list["3k_dlc07_liu_yan_ambition_task_win_duels"].is_complete == false then
			self.ambition_panel_data_pack.mission_list["3k_dlc07_liu_yan_ambition_task_win_duels"].parts_completed = 0
		end

		self:save_data_pack()

	end,
	true)

	--TRACKS HEIR LEVEL UP
	core:add_listener("dlc07_liu_yan_inheritor_level_up", "CharacterRank",
	function(context)
		local character = context:query_character()

		return not self.ambition_panel_data_pack.has_inherited and
		 character:faction():name() == self.liu_yan_faction_key and character:faction():is_human() and
		 character:character_post() and not character:character_post():is_null_interface() and
		 character:character_post():ministerial_position_record_key() == "faction_heir"
		 and not self.ambition_panel_data_pack.mission_list["3k_dlc07_liu_yan_ambition_task_reach_level"].is_complete
	end,
	function()
		self:complete_task("3k_dlc07_liu_yan_ambition_task_reach_level")
		self:save_data_pack()

	end,
	true)


	--TRACKS DUELS AND BATTLES LED
	core:add_listener("dlc_07_liu_yan_battle_logged_ambition_listener", "CampaignBattleLoggedEvent",
	function(context)

		--return true if liu yan faction was in battle
		return context:log_entry():winning_factions():any_of(function(faction) return faction:name() == self.liu_yan_faction_key end) or
		 context:log_entry():losing_factions():any_of(function(faction) return faction:name() == self.liu_yan_faction_key end)
	
	end,
	function(context)

		local heir_key = "";

		if self:get_character_heir() then
			heir_key = self:get_character_heir():generation_template_key();
		end

		local battles_task_data = self.ambition_panel_data_pack.mission_list["3k_dlc07_liu_yan_ambition_task_lead_battles"]
		local duels_task_data = self.ambition_panel_data_pack.mission_list["3k_dlc07_liu_yan_ambition_task_win_duels"]

		local heir_led_battles = battles_task_data.parts_completed
		local heir_fought_duels = duels_task_data.parts_completed

		--checks if character was leader (general) in battle
		if context:log_entry():winning_characters():any_of(function(character)
			--goes into the force and checks if the force leader is our guy
			if not character:character():is_null_interface() and not character:character():is_dead() and character:character():has_military_force() then
				return character:character():military_force():general_character():generation_template_key() == heir_key
			end
			return false
		end)then
			--limits to 1 extra point per battle (to avoid the system counting for different characters in the same force several times)
			if battles_task_data.parts_completed < heir_led_battles + 1 then
				self.ambition_panel_data_pack.mission_list["3k_dlc07_liu_yan_ambition_task_lead_battles"].parts_completed = heir_led_battles + 1
			end
		end

		--checks if character fought and won duel -- ROMANCE
		if not self.is_records_mode then
			local duels_won = context:log_entry():duels():count_if(function(duel)
					if duel:has_winner() then
						return duel:winner():generation_template_key() == heir_key
					end
					return false
			end)
			if duels_won > 0 then
				self.ambition_panel_data_pack.mission_list["3k_dlc07_liu_yan_ambition_task_win_duels"].parts_completed = heir_fought_duels + duels_won
			end
		
		else

			local character_battle_record;
		--checks if character killed enemy units -- RECORDS
			--checks winning and losing characters for our guy
			if context:log_entry():winning_characters():any_of(function(character)
				if not character:character():is_null_interface() and not character:character():is_dead() then
					if character:character():generation_template_key() == heir_key then
						character_battle_record = character
						return true
					end
				end
				return false
			end)
			or
			context:log_entry():losing_characters():any_of(function(character)
				if not character:character():is_null_interface() and not character:character():is_dead() then
					if character:character():generation_template_key() == heir_key then
						character_battle_record = character
						return true
					end
				end
				return false
			end)
			then
				local duel_parts = self.ambition_panel_data_pack.mission_list["3k_dlc07_liu_yan_ambition_task_win_duels"].parts_completed
				self.ambition_panel_data_pack.mission_list["3k_dlc07_liu_yan_ambition_task_win_duels"].parts_completed = duel_parts + character_battle_record:personal_kills()
			end
		end

		if battles_task_data.parts_completed >= battles_task_data.parts_to_complete_total then
			self:complete_task("3k_dlc07_liu_yan_ambition_task_lead_battles")
		end

		if duels_task_data.parts_completed >= duels_task_data.parts_to_complete_total then
			self:complete_task("3k_dlc07_liu_yan_ambition_task_win_duels")
		end
			

		self:save_data_pack()

	end,
	true)

end

function liu_yan_features:utility_listeners()

	core:add_listener("dlc07_liu_yan_turn_start_faction_leader_write_in", "WorldStartOfRoundEvent",
	function()
		return cm:query_faction(self.liu_yan_faction_key):is_human() and not cm:query_faction(self.liu_yan_faction_key):is_dead()
	end,
	function()
		if self.ambition_panel_data_pack.liu_yan_faction_leader_cqi ~= cm:query_faction(self.liu_yan_faction_key):faction_leader():cqi() then
			self.ambition_panel_data_pack.liu_yan_faction_leader_cqi = cm:query_faction(self.liu_yan_faction_key):faction_leader():cqi()
		end
	end,
	true)

	core:add_listener("dlc07_liu_yan_faction_leader_death_listener", "CharacterDied",
	function(context)
		return context:query_character():cqi() == self.ambition_panel_data_pack.liu_yan_faction_leader_cqi
	end,
	function()
		self:inheritance_triggered(true)
	end,
	true)
end

--updates the UI info on missions, tradeoffs, rewards, and sends that info to UIland
function liu_yan_features:update_ui_lists()
	--pre inherit info about missions and tradeoffs is only updated if we're in the pre inherit context
	if not self.ambition_panel_data_pack.has_inherited then
		self:ambition_mission_progress_update()
	end

	effect.set_context_value("dlc07_liu_yan_features", self.ambition_panel_data_pack)
end


--fires when inheritance is triggered
function liu_yan_features:inheritance_triggered(inheritance_override, year_override, unlocked_reward_list)

	-- ideally this won't happen, but we need to guard
	if self.ambition_panel_data_pack.has_inherited then
		return
	end

	--sets inherit values
	self.ambition_panel_data_pack.has_inherited = true

	if not year_override then
		self.ambition_panel_data_pack.date_inherited = cm:query_model():calendar_year()
	else
		self.ambition_panel_data_pack.date_inherited = year_override
	end

	--picks the valid effect bundle based on inheritance time
	local effect_to_enable = ""
	if not year_override then
		for inheritance_effect_key, inheritance_effect_details in pairs (self.ambition_panel_data_pack.inheritance_effects_list) do
			
			if cm:query_model():date_in_range(inheritance_effect_details["first_valid_year"], inheritance_effect_details["last_valid_year"]) then
				effect_to_enable = inheritance_effect_key
				break;
			end
		end
	else
		for inheritance_effect_key, inheritance_effect_details in pairs (self.ambition_panel_data_pack.inheritance_effects_list) do
			
			if year_override >= inheritance_effect_details["first_valid_year"] and year_override <= inheritance_effect_details["last_valid_year"] then
				effect_to_enable = inheritance_effect_key
				break;
			end
		end
	end

	if effect_to_enable == "" then
		script_error("ERORR! Invalid year passed for Liu Yan inheritance trigger")
		return
	end
	

	--add relevant fxb to faction
	local faction_fxb_key = effect_to_enable.."_faction_portion"
	cm:modify_faction(self.liu_yan_faction_key):apply_effect_bundle(faction_fxb_key, -1)
	
	--manages character heir - if death override, does the same but to the leader, which gets assigned the frame before

	--add relevant character CEO to character
	local character_ceo_key = "3k_dlc07_ceo_"..string.gsub(effect_to_enable, "3k_dlc07_effect_bundle_", "").."_character_portion"
	local character_modify_interface
	
	local previous_leader_modify_interface = false

	if inheritance_override then
		character_modify_interface = cm:modify_model():get_modify_character(cm:query_faction(self.liu_yan_faction_key):faction_leader())
	else
		character_modify_interface = cm:modify_model():get_modify_character(self:get_character_heir())
		previous_leader_modify_interface = cm:modify_model():get_modify_character(cm:query_faction(self.liu_yan_faction_key):faction_leader())
	end

	character_modify_interface:ceo_management():add_ceo(character_ceo_key)

	if not previous_leader_modify_interface == false then
		previous_leader_modify_interface:apply_effect_bundle("3k_dlc07_liu_yan_inheritance_previous_leader_court_desire", -1)
	end
	
	--add relevant XP bonus to character
	if string.match(effect_to_enable, "inheritance_timely") then
		character_modify_interface:add_experience(10000, 0)
	elseif string.match(effect_to_enable, "inheritance_delayed") then
		character_modify_interface:add_experience(5000, 0)
	end

	if not inheritance_override then
		--inherit faction
		cm:modify_model():get_modify_character(self:get_character_heir()):assign_faction_leader()
	end

	--disables mission and tradeoff tracking
	self:remove_pre_inheritance_listeners()

	if not unlocked_reward_list then
		--enables the rewards for having completed missions
		for mission_key, mission_data in pairs(self.ambition_panel_data_pack.mission_list) do
			if mission_data.is_complete == true then
				self.ambition_panel_data_pack.reward_list[mission_data.reward_key].is_unlocked = true
			end
		end
	else
		-- Unlock all the given rewards for this start date
		for _, reward_key in ipairs(unlocked_reward_list) do
			self.ambition_panel_data_pack.reward_list[reward_key].is_unlocked = true
			-- as we're forcing the reward, we also force the mission so the UI can show it properly
			for mission_key, mission_data in pairs(self.ambition_panel_data_pack.mission_list) do
				if mission_data.reward_key == reward_key then
					self:complete_task(mission_key, true)
				end
			end
		end
	end

	--disables tradeoffs
	for tradeoff_key, tradeoff_data in pairs(self.ambition_panel_data_pack.tradeoff_list) do
		if tradeoff_data.is_enabled == true then
			self:tradeoff_toggled(tradeoff_key, true)
		end
	end

	--unpin all tasks as they can no longer be completed
	for task_key, _ in pairs(self.ambition_panel_data_pack.mission_list) do
		self:unpin_task(task_key)
	end

	-- if triggered by gameplay, not from start date
	if (not year_override) and (not unlocked_reward_list) then
		cm:trigger_incident(self.liu_yan_faction_key, "3k_dlc07_incident_script_liu_yan_inheritance_triggered", true)
	end

	self:save_data_pack()
	self:print_data_pack()

end

function liu_yan_features:complete_task(task_key, incident_hidden)
	self.ambition_panel_data_pack.mission_list[task_key].parts_completed =
	self.ambition_panel_data_pack.mission_list[task_key].parts_to_complete_total
	self.ambition_panel_data_pack.mission_list[task_key].is_complete = true

	if not incident_hidden or incident_hidden == nil then
		cm:modify_faction(self.liu_yan_faction_key):trigger_incident(self.ambition_panel_data_pack.mission_list[task_key].related_incident, true)
	end

	self:unpin_task(task_key)

	if not self.ambition_panel_data_pack.is_inheritable then
		self.ambition_panel_data_pack.is_inheritable = true
	end

	self:save_data_pack()
	self:print_data_pack()
end

function liu_yan_features:unpin_task(task_key)
	if cm:query_shared_state():get_bool_value("3k_dlc07_ambition_mission_pinned_"..task_key) then
		output("liu_yan_features: Unpinning task "..task_key)
		-- Unpin in the shared states manager
		cm:modify_shared_state():set_bool_value("3k_dlc07_ambition_mission_pinned_"..task_key, false)
	end
end

function liu_yan_features:is_tradeoff_enabled(tradeoff_key)
	if tradeoff_key then
		local tradeoff = self.ambition_panel_data_pack.tradeoff_list[tradeoff_key]
		return tradeoff ~= nil and tradeoff.is_enabled
	end
	return false
end

--turns tradeoffs on and off. has an inheritance override which is used to reset the whole thing when inheritance happens
function liu_yan_features:tradeoff_toggled(tradeoff_key, inheritance_override)
	

	local modify_faction_interface = cm:modify_faction(self.liu_yan_faction_key)
	local liu_yan_tradeoff_tracker_resource_key = cm:query_faction(self.liu_yan_faction_key):pooled_resources():resource(self.liu_yan_tradeoff_tracker_resource_key)

	if not inheritance_override then
		if self.ambition_panel_data_pack.tradeoff_list[tradeoff_key].can_be_toggled then

			local toggling_on = not self:is_tradeoff_enabled(tradeoff_key)

			local effect_tier = self.ambition_panel_data_pack.tradeoff_list[tradeoff_key].current_tier
			local effect_key = self.ambition_panel_data_pack.tradeoff_list[tradeoff_key].bundle_key[effect_tier]

			if toggling_on then
				--modifies tradeoff tracker pooled resource so that it shows in/game
				cm:modify_model():get_modify_pooled_resource(liu_yan_tradeoff_tracker_resource_key):apply_transaction_to_factor("3k_dlc07_pooled_factor_ambition_tradeoffs_tracker", 1)


				modify_faction_interface:apply_effect_bundle(effect_key, -1)
				self.ambition_panel_data_pack.tradeoff_list[tradeoff_key].turn_toggled = cm:query_model():turn_number()
			else
				--modifies tradeoff tracker pooled resource so that it shows in/game
				cm:modify_model():get_modify_pooled_resource(liu_yan_tradeoff_tracker_resource_key):apply_transaction_to_factor("3k_dlc07_pooled_factor_ambition_tradeoffs_tracker", -1)

				modify_faction_interface:remove_effect_bundle(effect_key)
				self.ambition_panel_data_pack.tradeoff_list[tradeoff_key].current_tier = 1
				self.ambition_panel_data_pack.tradeoff_list[tradeoff_key].turn_toggled = cm:query_model():turn_number()
				self.ambition_panel_data_pack.tradeoff_list[tradeoff_key].can_be_toggled = false
			end

			self.ambition_panel_data_pack.tradeoff_list[tradeoff_key].is_enabled = toggling_on
		end
	
	else		--inheritance override

		--gets current effect key
		local effect_tier = self.ambition_panel_data_pack.tradeoff_list[tradeoff_key].current_tier
		local effect_key = self.ambition_panel_data_pack.tradeoff_list[tradeoff_key].bundle_key[effect_tier]
		
		--disables effect
		modify_faction_interface:remove_effect_bundle(effect_key)
		self.ambition_panel_data_pack.tradeoff_list[tradeoff_key].is_enabled = false

		--resets values in effect key
		self.ambition_panel_data_pack.tradeoff_list[tradeoff_key].current_tier = 1
		self.ambition_panel_data_pack.tradeoff_list[tradeoff_key].can_be_toggled = false

		--modifies tradeoff tracker pooled resource so that it shows in/game
		cm:modify_model():get_modify_pooled_resource(liu_yan_tradeoff_tracker_resource_key):apply_transaction_to_factor("3k_dlc07_pooled_factor_ambition_tradeoffs_tracker", -1)


	end


	self:save_data_pack()

end

--upgrades tradeoff to the next best tier once it's spent enough turns in its initial tier
function liu_yan_features:tradeoff_upgraded(tradeoff_key)

	local modify_faction_interface = cm:modify_faction(self.liu_yan_faction_key)

	--stores current effect bundle and tier
	local target_tier = self.ambition_panel_data_pack.tradeoff_list[tradeoff_key].current_tier
	local current_key = self.ambition_panel_data_pack.tradeoff_list[tradeoff_key].bundle_key[target_tier]
	
	--prepares for tier upgrade
	target_tier = target_tier + 1
	target_tier = math.min(target_tier, 3)

	--gets upgraded fx bundle
	local target_key = self.ambition_panel_data_pack.tradeoff_list[tradeoff_key].bundle_key[target_tier]
	
	--updates tier
	self.ambition_panel_data_pack.tradeoff_list[tradeoff_key].current_tier = target_tier

	--removes old bundle, adds new bundle
	modify_faction_interface:remove_effect_bundle(current_key)
	modify_faction_interface:apply_effect_bundle(target_key, -1)

	self:save_data_pack()
end

--re-enables tradeoffs after cooldown is done
function liu_yan_features:tradeoff_toggle_cooldown_finished(tradeoff_key)

	self.ambition_panel_data_pack.tradeoff_list[tradeoff_key].can_be_toggled = true

	self:save_data_pack()
end

--enabled reward
function liu_yan_features:reward_enabled(reward_key, target_key)

	local reward_data = self.ambition_panel_data_pack.reward_list[reward_key]

	local ambition_pooled_resource = cm:query_faction(self.liu_yan_faction_key):pooled_resources():resource(self.liu_yan_pooled_resource_key)

	cm:modify_model():get_modify_pooled_resource(ambition_pooled_resource):apply_transaction_to_factor("3k_dlc07_pooled_factor_ambition_spending", - reward_data.ambition_cost);


	if reward_data.target_type == "none" then
		local modify_faction_interface = cm:modify_faction(self.liu_yan_faction_key)
		if string.find(reward_key,"ancillary_spawn") then
			modify_faction_interface:ceo_management():apply_trigger("3k_dlc07_ceo_trigger_liu_yan_ambition_reward_ancillary_trigger")

		elseif string.find(reward_key, "factionwide_exp") then
			modify_faction_interface:apply_effect_bundle(reward_key, reward_data.turn_duration)

		end
	elseif reward_data.target_type == "region" or reward_data.target_type == "province_capital" then

		if string.find(reward_key, "build_times") then
			cm:modify_region(cm:query_region(target_key)):apply_effect_bundle("3k_dlc07_effect_bundle_liu_yan_ambition_reward_build_times_actual", 1)
		else
			cm:modify_region(cm:query_region(target_key)):apply_effect_bundle(reward_key, reward_data.turn_duration)
		end

	elseif reward_data.target_type == "force" then
		local force = cm:query_model():military_force_for_command_queue_index(tonumber(target_key))
		cm:modify_military_force(force):apply_effect_bundle(reward_key, reward_data.turn_duration)

	elseif reward_data.target_type == "character" then
		
		local level = cm:query_character(target_key):rank() - 1
		
		local XP_threshold = self.experience_points_per_rank[level]
		
		local XP_to_give = XP_threshold - cm:query_character(target_key):current_experience()
		
		--if the multiplier is enabled, divide this value so the final number is still accurate
		if self.ambition_panel_data_pack.reward_list["3k_dlc07_effect_bundle_liu_yan_ambition_reward_factionwide_exp_gain"].is_enabled then
			XP_to_give = XP_to_give / 1.75
		end
		cm:modify_character(target_key):add_experience(XP_to_give, 0)

	else
		output("ERROR! Liu yan features reward_enabled() invalid target_type supplied!")
		return
	end

	self.ambition_panel_data_pack.reward_list[reward_key].is_enabled = true
	self.ambition_panel_data_pack.reward_list[reward_key].turn_enabled = cm:query_model():turn_number()

	self:save_data_pack()

end

function liu_yan_features:reward_disabled(reward_key)
	self.ambition_panel_data_pack.reward_list[reward_key].is_enabled = false

	self:save_data_pack()
end

--returns your heir
function liu_yan_features:get_character_heir()

	--finds heir post
	local target_post = cm:query_faction(self.liu_yan_faction_key):character_posts():find_if(
		function(character_post)
			return character_post:ministerial_position_record_key() == "faction_heir"
		end
	)

	--gets heir character from heir post. will return error if for some reason there are more than one (or 0) heirs
	if target_post:current_post_holders() == 1 then
		return target_post:post_holders():item_at(0)
	else
		return false
	end
end

function liu_yan_features:remove_pre_inheritance_listeners()

	core:remove_listener("dlc07_liu_yan_mission_tracker_turn_start")
	core:remove_listener("dlc07_liu_yan_new_inheritor_config_listener")
	core:remove_listener("dlc07_liu_yan_inheritor_level_up")
	core:remove_listener("dlc_07_liu_yan_battle_logged_ambition_listener")
	core:remove_listener("dlc07_liu_yan_ambition_tradeoff_manager_listener")
	core:remove_listener("dlc07_liu_yan_turn_start_faction_leader_write_in")
	core:remove_listener("dlc07_liu_yan_faction_leader_death_listener") 
	core:remove_listener("dlc07_liu_yan_inheritance_decay_notification_listener")

end

--takes the changeable data from the data pack, and saves it as a saved_value
function liu_yan_features:save_data_pack()

	local variable_data_pack = {
	
		has_inherited = self.ambition_panel_data_pack.has_inherited,
		date_inherited = self.ambition_panel_data_pack.date_inherited,
		is_inheritable = self.ambition_panel_data_pack.is_inheritable,
		faction_leader_at_inheritence = self.ambition_panel_data_pack.liu_yan_faction_leader_cqi,

		mission_list = {},

		tradeoff_list = {},
		
		reward_list = {}
	}

	--saves the relevant, changeable information from missions, tradeoffs, and rewards
	for mission_key, mission_data in pairs(self.ambition_panel_data_pack.mission_list) do
		variable_data_pack.mission_list[mission_key] = {
			parts_completed = mission_data.parts_completed,
			is_complete = mission_data.is_complete
		}
	end

	for tradeoff_key, tradeoff_data in pairs(self.ambition_panel_data_pack.tradeoff_list) do
		variable_data_pack.tradeoff_list[tradeoff_key] = {
			can_be_toggled = tradeoff_data.can_be_toggled,
			turn_toggled = tradeoff_data.turn_toggled,
			is_enabled = tradeoff_data.is_enabled,
			current_tier = tradeoff_data.current_tier
		}
	end

	for reward_key, reward_data in pairs(self.ambition_panel_data_pack.reward_list) do
		variable_data_pack.reward_list[reward_key] = {
			is_unlocked = reward_data.is_unlocked,
			is_enabled = reward_data.is_enabled,
			turn_enabled = reward_data.turn_enabled
		}
	end

	cm:set_saved_value("dlc07_liu_yan_data_pack", variable_data_pack, "dlc07_liu_yan_values")
end

--initialises the game values and loads savegame info, if it exists
function liu_yan_features:initialise_data_pack()

	--changes duel-related task since duels arent a thing in historical
	if cm:query_model():campaign_game_mode() == "historical" then

		self.is_records_mode = true

		self.ambition_panel_data_pack.mission_list["3k_dlc07_liu_yan_ambition_task_win_duels"].title = "3l_dlc07_liu_yan_ambition_task_win_duels_records_title"
		self.ambition_panel_data_pack.mission_list["3k_dlc07_liu_yan_ambition_task_win_duels"].description = "3k_dlc07_liu_yan_ambition_task_win_duels_records_desc"
		self.ambition_panel_data_pack.mission_list["3k_dlc07_liu_yan_ambition_task_win_duels"].objective = "3k_dlc07_liu_yan_ambition_task_win_duels_records_objective"
		self.ambition_panel_data_pack.mission_list["3k_dlc07_liu_yan_ambition_task_win_duels"].related_incident = "3k_dlc07_scripted_incident_liu_yan_task_completed_lethal_duelist_records"
		self.ambition_panel_data_pack.mission_list["3k_dlc07_liu_yan_ambition_task_win_duels"].parts_to_complete_total = 300;
	end
	
	if cm:saved_value_exists("dlc07_liu_yan_data_pack", "dlc07_liu_yan_values") then
		
		local variable_data_pack = cm:get_saved_value("dlc07_liu_yan_data_pack", "dlc07_liu_yan_values")

		self.ambition_panel_data_pack.has_inherited = variable_data_pack.has_inherited
		self.ambition_panel_data_pack.date_inherited = variable_data_pack.date_inherited
		self.ambition_panel_data_pack.is_inheritable = variable_data_pack.is_inheritable
		self.ambition_panel_data_pack.liu_yan_faction_leader_cqi = variable_data_pack.faction_leader_at_inheritence

		for mission_key, mission_data in pairs(self.ambition_panel_data_pack.mission_list) do
			mission_data.parts_completed = variable_data_pack.mission_list[mission_key].parts_completed
			mission_data.is_complete = variable_data_pack.mission_list[mission_key].is_complete
		end

		for tradeoff_key, tradeoff_data in pairs(self.ambition_panel_data_pack.tradeoff_list) do
			tradeoff_data.can_be_toggled = variable_data_pack.tradeoff_list[tradeoff_key].can_be_toggled
			tradeoff_data.turn_toggled = variable_data_pack.tradeoff_list[tradeoff_key].turn_toggled
			tradeoff_data.is_enabled = variable_data_pack.tradeoff_list[tradeoff_key].is_enabled
			tradeoff_data.current_tier = variable_data_pack.tradeoff_list[tradeoff_key].current_tier
		end

		for reward_key, reward_data in pairs(self.ambition_panel_data_pack.reward_list) do
			reward_data.is_unlocked = variable_data_pack.reward_list[reward_key].is_unlocked
			reward_data.is_enabled = variable_data_pack.reward_list[reward_key].is_enabled
			reward_data.turn_enabled = variable_data_pack.reward_list[reward_key].turn_enabled
		end
	else

		if cm:query_model():campaign_name() == "3k_dlc05_start_pos" then
			output("\n\n\nStarting game at dlc05!! granting bonuses\n\n\n")
			self.ambition_panel_data_pack.mission_list["3k_dlc07_liu_yan_ambition_task_lead_battles"].parts_completed = 4;
			self.ambition_panel_data_pack.mission_list["3k_dlc07_liu_yan_ambition_task_win_duels"].parts_completed = 2;
			self:complete_task("3k_dlc07_liu_yan_ambition_task_reach_level")
		end

		if cm:query_model():campaign_name() == "3k_dlc07_start_pos" then

			--as he's already dead, we need to find Liu Yan and set the CQI so the UI can show the old leader
			local liu_yan_character = cm:query_model():character_for_template("3k_main_template_historical_liu_yan_hero_water")
			if liu_yan_character then
				self.ambition_panel_data_pack.liu_yan_faction_leader_cqi = liu_yan_character:cqi()
			end

			self:inheritance_triggered(true, 196, 
			{
				"3k_dlc07_effect_bundle_liu_yan_ambition_reward_replenishment_buff",
				"3k_dlc07_effect_bundle_liu_yan_ambition_reward_gdp_buff",
				"3k_dlc07_effect_bundle_liu_yan_ambition_reward_ancillary_spawn",
				"3k_dlc07_effect_bundle_liu_yan_ambition_reward_defensive_army_buffs",
				"3k_dlc07_effect_bundle_liu_yan_ambition_reward_character_exp"
			}
			)

			self:complete_task("3k_dlc07_liu_yan_ambition_task_full_stack_armies", true)
			self:complete_task("3k_dlc07_liu_yan_ambition_task_know_factions", true)
			self:complete_task("3k_dlc07_liu_yan_ambition_task_high_income", true)
			self:complete_task("3k_dlc07_liu_yan_ambition_task_lead_battles", true)
			self:complete_task("3k_dlc07_liu_yan_ambition_task_own_regions", true)
		end

		self:save_data_pack()
	end

end
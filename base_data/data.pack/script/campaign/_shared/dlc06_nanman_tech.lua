---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------
----- Name:			dlc06_nanman_tech.lua
----- Description: 	This script handles scripted tech unlocks for Nanman characters
---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------
output("dlc06_nanman_tech.lua: Loading");

-- Don't load in campaigns which don't require it.
if cm.name == "ep_eight_princes" then
	output("dlc06_nanman_tech.lua: Not loaded in this campaign.");
	return;
end;

force_require("dlc06_nanman_tech_missions");

-- Self initialiser on new campaigns only
cm:add_first_tick_callback_new( function() nanman_tech_manager:initialise_new_campaign() end );
-- self initialiser
cm:add_first_tick_callback( function() nanman_tech_manager:initialise() end ); --Self register function

---------------------------------------------------------
--------------------VARIABLES----------------------------
---------------------------------------------------------

nanman_tech_manager = {
	debug_mode = false;
	system_id = "[601] nanman_tech_manager - ";
	listener_name = "DLC06NanmanTech";
	first_tech = "3k_dlc06_tech_nanman_0_elephant_taming", -- The first tech on the tree. This is unlocked via uniting the tribes
	techs_locked_by_missions = {
	--ECONOMICAL
	"3k_dlc06_tech_nanman_eb1a_communal_incentivisation",
	"3k_dlc06_tech_nanman_eb1b_established_processes",
	"3k_dlc06_tech_nanman_eb1c_land_tax",
	"3k_dlc06_tech_nanman_er1_1_centralised_storage_han",
	"3k_dlc06_tech_nanman_er1_2_ancestral_farmland_nanman",
	"3k_dlc06_tech_nanman_eb2a_industrial_expansion",
	"3k_dlc06_tech_nanman_eb2b_artisans",
	"3k_dlc06_tech_nanman_eb2c_way_of_the_land",
	"3k_dlc06_tech_nanman_er2_1_division_of_labour_han",
	"3k_dlc06_tech_nanman_er2_2_advanced_metalwork_nanman",
	"3k_dlc06_tech_nanman_eb3a_riverside_waystations",
	"3k_dlc06_tech_nanman_eb3b_civilised_society",
	"3k_dlc06_tech_nanman_eb3c_resource_refinement",
	"3k_dlc06_tech_nanman_er3_1_streamlined_governance_han",
	"3k_dlc06_tech_nanman_er3_2_ancestral_belief_nanman",
	"3k_dlc06_tech_nanman_er4_1_centralised_labour_han",
	"3k_dlc06_tech_nanman_er4_2_ancient_heritage_nanman",
	"3k_dlc06_tech_nanman_er4_3_secrets_of_the_earth",
	--MILITARY
	"3k_dlc06_tech_nanman_mb1a_tribal_tenacity",
	"3k_dlc06_tech_nanman_mb1b_improved_spear_making",
	"3k_dlc06_tech_nanman_mb1c_professional_smithing",
	"3k_dlc06_tech_nanman_mr1_1_advanced_battle_tactics_han",
	"3k_dlc06_tech_nanman_mr1_2_tribal_zeal_nanman",
	"3k_dlc06_tech_nanman_mb2a_supply_chains",
	"3k_dlc06_tech_nanman_mb2b_tribal_conscription",
	"3k_dlc06_tech_nanman_mb2c_established_infrastructure",
	"3k_dlc06_tech_nanman_mr2_1_southern_hirelings_han",
	"3k_dlc06_tech_nanman_mr2_2_professional_soldiery_nanman",
	"3k_dlc06_tech_nanman_mb3a_marching_drills",
	"3k_dlc06_tech_nanman_mb3b_training_camps",
	"3k_dlc06_tech_nanman_mb3c_regimented_military",
	"3k_dlc06_tech_nanman_mr3_1_engineers_of_war_han",
	"3k_dlc06_tech_nanman_mr3_2_lays_of_the_land_nanman",
	"3k_dlc06_tech_nanman_mr4_1_cavalry_contracts_han",
	"3k_dlc06_tech_nanman_mr4_2_cave_networks_nanman",
	"3k_dlc06_tech_nanman_mr4_3_military_hierarchy",
	--POLITICAL
	"3k_dlc06_tech_nanman_pb1a_commercial_enterprise",
	"3k_dlc06_tech_nanman_pb1b_aggressive_negotiations",
	"3k_dlc06_tech_nanman_pb1c_spice_ships",
	"3k_dlc06_tech_nanman_pr1_1_methods_of_unification_han",
	"3k_dlc06_tech_nanman_pr1_2_trade_hubs_nanman",
	"3k_dlc06_tech_nanman_pb2a_intelligent_negotiations",
	"3k_dlc06_tech_nanman_pb2b_promises_of_co_operation",
	"3k_dlc06_tech_nanman_pb2c_tribal_council",
	"3k_dlc06_tech_nanman_pr2_1_demand_fealty_han",
	"3k_dlc06_tech_nanman_pr2_2_contractual_obligations_nanman",
	"3k_dlc06_tech_nanman_pb3a_refined_bureaucracy",
	"3k_dlc06_tech_nanman_pb3b_centralised_administration",
	"3k_dlc06_tech_nanman_pb3c_cultural_exchange",
	"3k_dlc06_tech_nanman_pr3_1_bureaucratic_reform_han",
	"3k_dlc06_tech_nanman_pr3_2_regional_investigations_nanman",
	"3k_dlc06_tech_nanman_pr4_1_diplomatic_authority_han", 
	"3k_dlc06_tech_nanman_pr4_2_manners_of_subterfuge_nanman",
	"3k_dlc06_tech_nanman_pr4_3_provincial_inspectors"}, -- Determines which additional techs (if any) are locked for the human Nanman factions, to be unlocked via missions
	locked_techs = {}, -- Stores which techs are (un)locked for save/load compatibility.
	tech_diplomacy_junctions = { -- This junctions diplomacy treaties to techs. When the tech is researched the diplomacy deal is unlocked too.
		["dummy_technology_record_key"] = "dummy_diplomacy_treaty_component",
		["3k_dlc06_tech_nanman_pr1_1_methods_of_unification_han"] = "treaty_components_region_offer,treaty_components_region_demand",
		["3k_dlc06_tech_nanman_pr1_2_trade_hubs_nanman"] = "treaty_components_payment_regular_offer,treaty_components_payment_regular_demand,treaty_components_break_payment_regular_offer,treaty_components_break_payment_regular_demand",
		["3k_dlc06_tech_nanman_pr1_all"] = "treaty_components_trade,treaty_components_military_access,treaty_components_non_aggression",
		["3k_dlc06_tech_nanman_pr2_1_demand_fealty_han"] = "treaty_components_join_coalition_proposer,treaty_components_join_coalition_recipient,treaty_components_create_coalition,treaty_components_create_alliance,treaty_components_join_alliance_proposers,treaty_components_join_alliance_recipients",
		["3k_dlc06_tech_nanman_pr2_2_contractual_obligations_nanman"] = "treaty_components_mercenary_contract_proposer_declares_war_against_target,treaty_components_mercenary_contract_recipient_declares_war_against_target,treaty_components_mercenary_counter_contract_recipient_declares_war_against_target,treaty_components_mercenary_counter_contract_proposer_declares_war_against_target",
		["3k_dlc06_tech_nanman_pr2_all"] = "treaty_components_annex_vassal,treaty_components_vassalise_recipient,treaty_components_vassalise_proposer,treaty_components_liberate_proposer,treaty_components_liberate_recipient",
		["3k_dlc06_tech_nanman_pr4_1_diplomatic_authority_han"] = "treaty_components_join_empire_recipient,treaty_components_join_empire_proposer",
		["3k_dlc06_tech_nanman_pr4_3_provincial_inspectors"] = "treaty_components_join_empire_recipient,treaty_components_join_empire_proposer"
	},
	tech_diplomacy_avaliability_junctions = { -- This junctions diplomacy treaties to their availiability reason. 
	["3k_dlc06_tech_nanman_pr1_1_methods_of_unification_han"] = "technology_required_proposer_methods_of_unification",
	["3k_dlc06_tech_nanman_pr1_2_trade_hubs_nanman"] = "technology_required_proposer_trade_hubs",
	["3k_dlc06_tech_nanman_pr1_all"] = "technology_required_proposer_methods_of_unification_or_trade_hubs",
	["3k_dlc06_tech_nanman_pr2_1_demand_fealty_han"] = "technology_required_proposer_demand_fealty",
	["3k_dlc06_tech_nanman_pr2_2_contractual_obligations_nanman"] = "technology_required_proposer_contractual_obligations",
	["3k_dlc06_tech_nanman_pr2_all"] = "technology_required_proposer_demand_fealty_or_contractual_obligations",
	["3k_dlc06_tech_nanman_pr4_1_diplomatic_authority_han"] = "technology_required_proposer_diplomatic_authority_or_provincial_inspectors",
	["3k_dlc06_tech_nanman_pr4_3_provincial_inspectors"] = "technology_required_proposer_diplomatic_authority_or_provincial_inspectors"
	},
	tech_specialisation_junctions = { 
		["3k_dlc06_faction_nanman_king_meng_huo"] = "all",
		["3k_dlc06_faction_nanman_lady_zhurong"] = "military",
		["3k_dlc06_faction_nanman_king_mulu"] = "economics",
		["3k_dlc06_faction_nanman_king_shamoke"] = "politics"
	},
	unlocked_diplomacy_treaties = {} -- Stores which diplomacy treaties the Nanman factions have unlocked for save/load compatibility.
};
---------------------------------------------------------
--------------------LISTENERS----------------------------
---------------------------------------------------------

--- @function add_listeners
--- @desc Setup the listeners for the Nanman tech tree
--- @return nil
function nanman_tech_manager:add_listeners()

	-- Unlocks specified diplomacy deals according to the table above 
	core:add_listener(
		self.listener_name .. "ResearchCompleted", -- Unique handle
		"ResearchCompleted", -- Campaign Event to listen for
		function(context) -- Listener condition
			self:print("ResearchCompleted "..context:technology_record_key().." "..tostring(self.tech_diplomacy_junctions[context:technology_record_key()] ~= nil))
			return self.tech_diplomacy_junctions[context:technology_record_key()] ~= nil
		end,
		function(context) -- What to do if listener fires.
			local technology_record_key = context:technology_record_key()
			self:unlock_diplomacy_treaties(context:faction():name(), self.tech_diplomacy_junctions[technology_record_key],self.tech_diplomacy_avaliability_junctions[technology_record_key])
			table.insert(self.unlocked_diplomacy_treaties[context:faction():name()], technology_record_key)

			--Ensure that the technology unlocked from either Political reform 1 or 2 is granted either way
			if string.match(technology_record_key,"pr1") then
				technology_record_key = "3k_dlc06_tech_nanman_pr1_all"				
			elseif string.match(technology_record_key,"pr2") then
				technology_record_key = "3k_dlc06_tech_nanman_pr2_all"
			else
				return
			end

			if technology_record_key ~= "" then
				self:unlock_diplomacy_treaties(context:faction():name(), self.tech_diplomacy_junctions[technology_record_key],self.tech_diplomacy_avaliability_junctions[technology_record_key])
				table.insert(self.unlocked_diplomacy_treaties[context:faction():name()], technology_record_key)
			end
		end,
		true --Is persistent
	);

end;

---------------------------------------------------------
--------------------FUNCTIONS----------------------------
---------------------------------------------------------

--- @function initialise_new_campaign
--- @desc Populates the variables table with data for all the Nanman factions in the campaign. Additionally locks the default techs for the human Nanman factions.
--- @return nil
function nanman_tech_manager:initialise_new_campaign()

	self:print("New campaign detected - setting up locked techs for Nanman factions");
	local faction_list = cm:query_model():world():faction_list()
	
	for i = 0, faction_list:num_items() - 1 do
		local faction_key = faction_list:item_at(i):name()

		if faction_list:item_at(i):subculture() == "3k_dlc06_subculture_nanman" and faction_list:item_at(i):name() ~= "3k_dlc06_faction_nanman_rebels" then
			self.locked_techs[faction_key] = {}
			self.unlocked_diplomacy_treaties[faction_key] = {}
			
			-- Lock default techs for human factions
			if faction_list:item_at(i):is_human() then
				for j = 1, #self.techs_locked_by_missions do
					self:lock_tech(faction_key, self.techs_locked_by_missions[j])
				end
				--Lock speciality techs away
				local specialization = self.tech_specialisation_junctions[faction_key];
				if specialization ~= nil then
					local faction = cm:query_faction(faction_key)
					if specialization ~= "all" then
						if specialization ~= "military" then
							self:lock_tech(faction_key, "3k_dlc06_tech_nanman_mb2a_supply_chains")
							self:lock_tech(faction_key, "3k_dlc06_tech_nanman_mb2b_tribal_conscription")
							self:lock_tech(faction_key, "3k_dlc06_tech_nanman_mb2c_established_infrastructure")
						end
						if specialization ~= "economics" then
							self:lock_tech(faction_key, "3k_dlc06_tech_nanman_eb2a_industrial_expansion")
							self:lock_tech(faction_key, "3k_dlc06_tech_nanman_eb2b_artisans")
							self:lock_tech(faction_key, "3k_dlc06_tech_nanman_eb2c_way_of_the_land")
						end
						if specialization ~= "politics" then
							self:lock_tech(faction_key, "3k_dlc06_tech_nanman_pb3a_refined_bureaucracy")
							self:lock_tech(faction_key, "3k_dlc06_tech_nanman_pb3b_centralised_administration")
							self:lock_tech(faction_key, "3k_dlc06_tech_nanman_pb3c_cultural_exchange")
						end
					end
					--LOCK ALL TIER 3 techs					
					self:lock_tech(faction_key, "3k_dlc06_tech_nanman_eb3a_riverside_waystations")
					self:lock_tech(faction_key, "3k_dlc06_tech_nanman_eb3b_civilised_society")
					self:lock_tech(faction_key, "3k_dlc06_tech_nanman_eb3c_resource_refinement")
					self:lock_tech(faction_key, "3k_dlc06_tech_nanman_mb3a_marching_drills")
					self:lock_tech(faction_key, "3k_dlc06_tech_nanman_mb3b_training_camps")
					self:lock_tech(faction_key, "3k_dlc06_tech_nanman_mb3c_regimented_military")					
					self:lock_tech(faction_key, "3k_dlc06_tech_nanman_pb2a_intelligent_negotiations")
					self:lock_tech(faction_key, "3k_dlc06_tech_nanman_pb2b_promises_of_co_operation")
					self:lock_tech(faction_key, "3k_dlc06_tech_nanman_pb2c_tribal_council")
				end
			end

		end
	end
end


--- @function initialise
--- @desc Turns on the Nanman tech manager. The script self initialises this!
--- @return nil
function nanman_tech_manager:initialise()

	-- Enables more verbose debugging.
	-- Example: trigger_cli_debug_event nanman_tech_manager.enable_debug()
	core:add_cli_listener("nanman_tech_manager.enable_debug",
		function()
			self.debug_mode = true;
		end
	);

	-- Debug command to instantly script lock a tech node
	-- Example: trigger_cli_debug_event nanman_tech_manager.debug_lock_tech(3k_dlc06_faction_nanman_king_mulu, 3k_dlc06_tech_nanman_0_elephant_taming)
	core:add_cli_listener("nanman_tech_manager.debug_lock_tech", 
		function(faction_key, tech_key)
			local query_faction = cm:query_faction(faction_key);

			if not query_faction or query_faction:is_null_interface() then
				script_error("ERROR: nanman_tech_manager.debug_lock_tech: Passed in faction key is not an existing faction. [" .. tostring(faction_key) .. "]");
				return false;
			end;

			self:lock_tech(faction_key, tech_key);
		end
	);

	-- Debug command to instantly script unlock a tech node
	-- Example: trigger_cli_debug_event nanman_tech_manager.debug_unlock_tech(3k_dlc06_faction_nanman_king_mulu, 3k_dlc06_tech_nanman_0_elephant_taming)
	core:add_cli_listener("nanman_tech_manager.debug_unlock_tech", 
	function(faction_key, tech_key)
		local query_faction = cm:query_faction(faction_key);

		if not query_faction or query_faction:is_null_interface() then
			script_error("nanman_tech_manager.debug_unlock_tech: Passed in faction key is not an existing faction. [" .. tostring(faction_key) .. "]");
			return false;
		end;
		
		self:unlock_tech(faction_key, tech_key);
	end
	);

	self:print("Nanman tech script initialised.");
	self:add_listeners();

	--Setup the script locked technologies, and the script unlocked diplomacy treaties
	local faction_list = cm:query_model():world():faction_list()
	for i = 0, faction_list:num_items() - 1 do
		
		if faction_list:item_at(i):subculture() == "3k_dlc06_subculture_nanman" then
			local faction_key = faction_list:item_at(i):name()
			local locked_techs = self.locked_techs[faction_key]
			local unlocked_diplomacy = self.unlocked_diplomacy_treaties[faction_key]

			-- Setup the locked techs
			if locked_techs and #locked_techs > 0 then
				for j = 1, #locked_techs do
					self:print("First tick callback - locking "..locked_techs[j].." for "..faction_key, true)
					cm:modify_faction(faction_key):lock_technology(locked_techs[j])
				end
			end;
			
			-- Setup the unlocked diplomacy
			if unlocked_diplomacy and #unlocked_diplomacy > 0 then
				for j = 1, #unlocked_diplomacy  do
					print("First tick callback - unlocking "..unlocked_diplomacy[j].." for "..faction_key, true)
					self:unlock_diplomacy_treaties(faction_key, self.tech_diplomacy_junctions[unlocked_diplomacy[j]],self.tech_diplomacy_avaliability_junctions[unlocked_diplomacy[j]])
				end
			end;
		end

	end	

end;

--- @function lock_tech
--- @desc Locks techs, and saves the value so that we can retrieve it on campaign load
--- @return nil
function nanman_tech_manager:lock_tech(faction_key, tech_key)
	self:print("Locking "..tech_key.." for "..faction_key);
	cm:modify_faction(faction_key):lock_technology(tech_key)
	table.insert(self.locked_techs[faction_key], tech_key)
end;

--- @function unlock_tech
--- @desc Unlocks techs, and removes the saved locked tech value
--- @return nil
function nanman_tech_manager:unlock_tech(faction_key, tech_key)
	self:print("Unlocking "..tech_key.." for "..faction_key);
	cm:modify_faction(faction_key):unlock_technology(tech_key)
	
	-- We're removing items from the list, so we do this in reverse. This stops the script breaking if we somehow have the same tech in the locked list twice
	for i = #self.locked_techs[faction_key], 1, -1 do
		if self.locked_techs[faction_key][i] == tech_key then
			table.remove(self.locked_techs[faction_key], i)
		end
	end
end;

--- @function unlock_diplomacy_treaties
--- @desc Unlocks treaties between the specified faction and the Han and Bandit subculture
--- @return nil
function nanman_tech_manager:unlock_diplomacy_treaties(faction_key, treaty_component,treaty_availability_reason)
	self:print("faction_key "..faction_key.." treaty_component "..treaty_component)
	if treaty_availability_reason == nil then treaty_availability_reason = "hidden" end
	if string.match(treaty_component,"mercenary_contract") then
		local human_factions = cm:get_human_factions();

		if cm:query_faction(faction_key):is_human() then
			cm:modify_model():enable_diplomacy("faction:" .. faction_key, "subculture:3k_main_chinese", "treaty_components_mercenary_contract_proposer_declares_war_against_target,treaty_components_mercenary_counter_contract_proposer_declares_war_against_target",treaty_availability_reason)
			cm:modify_model():enable_diplomacy("subculture:3k_main_chinese","faction:" .. faction_key, "treaty_components_mercenary_contract_recipient_declares_war_against_target,treaty_components_mercenary_counter_contract_recipient_declares_war_against_target","technology_required_recipient")
			cm:modify_model():enable_diplomacy("faction:" .. faction_key, "subculture:3k_dlc05_subculture_bandits", "treaty_components_mercenary_contract_proposer_declares_war_against_target,treaty_components_mercenary_counter_contract_proposer_declares_war_against_target",treaty_availability_reason)
			cm:modify_model():enable_diplomacy("subculture:3k_dlc05_subculture_bandits","faction:" .. faction_key, "treaty_components_mercenary_contract_recipient_declares_war_against_target,treaty_components_mercenary_counter_contract_recipient_declares_war_against_target","technology_required_recipient")
			cm:modify_model():enable_diplomacy("faction:" .. faction_key, "subculture:3k_dlc06_subculture_nanman", "treaty_components_mercenary_contract_proposer_declares_war_against_target,treaty_components_mercenary_counter_contract_proposer_declares_war_against_target",treaty_availability_reason)
			cm:modify_model():enable_diplomacy("subculture:3k_dlc06_subculture_nanman","faction:" .. faction_key, "treaty_components_mercenary_contract_recipient_declares_war_against_target,treaty_components_mercenary_counter_contract_recipient_declares_war_against_target","technology_required_recipient")
			--ALWAYS ALLOW NANMAN TO NANMAN MERCENARY CONTRACTS
			cm:modify_model():enable_diplomacy("faction:" .. faction_key, "subculture:3k_dlc06_subculture_nanman", "treaty_components_mercenary_contract_proposer_declares_war_against_target,treaty_components_mercenary_counter_contract_proposer_declares_war_against_target","technology_required_recipient")
		end

		for i = 1, #human_factions do
			if human_factions[i] ~= nil and cm:query_faction(human_factions[i]):subculture() ~= "3k_main_subculture_yellow_turban" then
				local human_faction = cm:query_faction(human_factions[i])
				if human_faction:subculture() == "3k_dlc05_subculture_bandits" or human_factions[i] == "3k_main_faction_lu_bu"  then
					cm:modify_model():enable_diplomacy("faction:" .. faction_key, "faction:" .. human_factions[i], "treaty_components_mercenary_contract_recipient_declares_war_against_target,treaty_components_mercenary_counter_contract_recipient_declares_war_against_target",treaty_availability_reason)
					cm:modify_model():enable_diplomacy("faction:" .. faction_key, "faction:" .. human_factions[i], "treaty_components_mercenary_contract_recipient_declares_war_against_target,treaty_components_mercenary_counter_contract_recipient_declares_war_against_target","technology_required_recipient")
					cm:modify_model():enable_diplomacy("faction:" .. human_factions[i],"faction:" .. faction_key, "treaty_components_mercenary_contract_proposer_declares_war_against_target,treaty_components_mercenary_counter_contract_proposer_declares_war_against_target","technology_required_recipient")
				end
			end
		end;
		--VASSALIGE
		treaty_component=",treaty_components_vassalise_recipient,treaty_components_vassalise_proposer,treaty_components_liberate_proposer,treaty_components_liberate_recipient,treaty_components_annex_vassal,treaty_components_draw_vassal_into_war,treaty_components_vassal_requests_war,treaty_components_vassal_joins_war,treaty_components_call_vassals_to_arms"
	
		cm:modify_model():enable_diplomacy("subculture:3k_main_chinese","faction:"..faction_key, treaty_component, "technology_required_recipient")
		cm:modify_model():enable_diplomacy("faction:"..faction_key,"subculture:3k_main_chinese", treaty_component, treaty_availability_reason)
		cm:modify_model():enable_diplomacy("subculture:3k_dlc05_subculture_bandits","faction:"..faction_key, treaty_component, "technology_required_recipient")
		cm:modify_model():enable_diplomacy("faction:"..faction_key,"subculture:3k_dlc05_subculture_bandits", treaty_component, treaty_availability_reason)
	else
		--enables generic treaties for all factions, with a guard against vassalisation treaties for YT factions
		cm:modify_model():enable_diplomacy("subculture:3k_main_chinese","faction:"..faction_key, treaty_component, "technology_required_recipient")
		cm:modify_model():enable_diplomacy("faction:"..faction_key,"subculture:3k_main_chinese", treaty_component, treaty_availability_reason)
		cm:modify_model():enable_diplomacy("subculture:3k_dlc05_subculture_bandits","faction:"..faction_key, treaty_component, "technology_required_recipient")
		cm:modify_model():enable_diplomacy("faction:"..faction_key,"subculture:3k_dlc05_subculture_bandits", treaty_component, treaty_availability_reason)
		if not string.match(treaty_component,"treaty_components_vassalise_recipient") then
            cm:modify_model():enable_diplomacy("subculture:3k_main_subculture_yellow_turban","faction:"..faction_key, treaty_component, "technology_required_recipient")
            cm:modify_model():enable_diplomacy("faction:"..faction_key,"subculture:3k_main_subculture_yellow_turban", treaty_component, treaty_availability_reason)
        end
	end
	--Disables generic treaties for factions with specific treaties, enables specific treaties instead
	if string.match(treaty_component,"treaty_components_create_coalition") then 
		-- Restricting Yan Baihu from using default alliance or coalition creation treaties
		cm:modify_model():disable_diplomacy("faction:3k_main_faction_yuan_shu", "faction:"..faction_key,"treaty_components_create_alliance,treaty_components_create_coalition,treaty_components_coalition_to_alliance,treaty_components_alliance_to_empire,treaty_components_coalition_to_empire,treaty_components_create_empire", "technology_required_recipient")
		cm:modify_model():disable_diplomacy("faction:3k_main_faction_yuan_shao", "faction:"..faction_key,"treaty_components_create_alliance,treaty_components_create_coalition,treaty_components_coalition_to_alliance,treaty_components_alliance_to_empire,treaty_components_coalition_to_empire,treaty_components_create_empire", "technology_required_recipient")		
		cm:modify_model():disable_diplomacy("faction:3k_dlc05_faction_white_tiger_yan", "faction:"..faction_key, "treaty_components_create_alliance,treaty_components_create_coalition,treaty_components_coalition_to_alliance,treaty_components_alliance_to_empire,treaty_components_coalition_to_empire,treaty_components_create_empire", "technology_required_recipient")
		-- Enabeling Yan Baihu to use default alliance or coalition creation treaties		
		cm:modify_model():enable_diplomacy("faction:3k_dlc05_faction_white_tiger_yan", "faction:"..faction_key,"treaty_components_create_alliance_white_tiger,treaty_components_create_coalition_white_tiger,treaty_components_coalition_to_alliance_white_tiger,treaty_components_create_empire_white_tiger,treaty_components_alliance_to_empire_white_tiger", "technology_required_recipient")
		cm:modify_model():enable_diplomacy("faction:"..faction_key,"faction:3k_dlc05_faction_white_tiger_yan", "treaty_components_create_empire_white_tiger_counter_offer,treaty_components_create_alliance_white_tiger_counter_offer,treaty_components_create_coalition_white_tiger_counter_offer", treaty_availability_reason)
		-- Enabeling Yuan Shao to use default alliance or coalition creation treaties	
		cm:modify_model():enable_diplomacy("faction:3k_main_faction_yuan_shao", "faction:"..faction_key, "treaty_components_create_alliance_yuan_shao,treaty_components_create_coalition_yuan_shao,treaty_components_coalition_to_alliance_yuan_shao,treaty_components_create_empire_yuan_shao,treaty_components_alliance_to_empire_yuan_shao,treaty_components_coalition_to_empire_yuan_shao", "technology_required_recipient")
		cm:modify_model():enable_diplomacy("faction:"..faction_key, "faction:3k_main_faction_yuan_shao", "treaty_components_create_alliance_yuan_shao_counter_offer,treaty_components_create_coalition_yuan_shao_counter_offer,treaty_components_create_empire_yuan_shao_counter_offer", treaty_availability_reason)
		-- Enabeling Yuan Shu to use his specific alliance and coalition creation treaties	
		cm:modify_model():enable_diplomacy("faction:3k_main_faction_yuan_shu", "faction:"..faction_key, "treaty_components_create_alliance_yuan_shu,treaty_components_create_coalition_yuan_shu,treaty_components_coalition_to_alliance_yuan_shu", "technology_required_recipient")
		cm:modify_model():enable_diplomacy("faction:"..faction_key, "faction:3k_main_faction_yuan_shu", "treaty_components_create_alliance_yuan_shu_counter_offer,treaty_components_create_coalition_yuan_shu_counter_offer", treaty_availability_reason)
	end
	if string.match(treaty_component,"treaty_components_vassalise_recipient") then
		--Restricting Yuan Shu from using default vassalise recipient
		cm:modify_model():disable_diplomacy("faction:3k_main_faction_yuan_shu", "faction:"..faction_key, "treaty_components_vassalise_recipient", "technology_required_recipient")
		--Restricting all factions from offering to become default vassals of Yuan Shu
		cm:modify_model():disable_diplomacy("faction:"..faction_key, "faction:3k_main_faction_yuan_shu", "treaty_components_vassalise_proposer", treaty_availability_reason)
		--Restricting Liu Biao from using default vassalise
		cm:modify_model():disable_diplomacy("faction:3k_main_faction_liu_biao", "faction:"..faction_key, "treaty_components_vassalise_recipient", "technology_required_recipient")
		--Restricting all factions from offering to become default vassals of Liu Biao
		cm:modify_model():disable_diplomacy("faction:"..faction_key, "faction:3k_main_faction_liu_biao", "treaty_components_vassalise_proposer", treaty_availability_reason)
		--Restricting Zheng Jiang from creating vassals
		cm:modify_model():disable_diplomacy("faction:3k_main_faction_zheng_jiang", "faction:"..faction_key, "treaty_components_vassalise_recipient,treaty_components_vassalise_proposer,treaty_components_demand_autonomy,treaty_components_offer_autonomy,treaty_components_liberate_proposer,treaty_components_liberate_recipient,treaty_components_annex_vassal,treaty_components_declare_independence,treaty_components_draw_vassal_into_war,treaty_components_call_vassals_to_arms,treaty_components_vassal_joins_war,treaty_components_vassal_requests_war,treaty_components_vassalise_recipient_yellow_turban,treaty_components_vassalise_recipient_yuan_shu,treaty_components_vassalise_recipient_liu_biao", "hidden")
		--Restricting all factions from offering to become vassals of Zheng Jiang
		cm:modify_model():disable_diplomacy("faction:"..faction_key, "faction:3k_main_faction_zheng_jiang", "treaty_components_vassalise_recipient,treaty_components_vassalise_proposer,treaty_components_demand_autonomy,treaty_components_offer_autonomy,treaty_components_annex_vassal,treaty_components_declare_independence,treaty_components_draw_vassal_into_war,treaty_components_vassal_joins_war,treaty_components_vassal_requests_war,treaty_components_vassalise_proposer_yellow_turban,treaty_components_vassalise_proposer_yuan_shu,treaty_components_liberate_recipient,treaty_components_liberate_proposer,treaty_components_support_independence_offer,treaty_components_vassalise_proposer_liu_biao", "hidden")
	end
	if string.match(treaty_component,"treaty_components_trade") then
		--Restrict Kong Rong from doing default trade deals, as he has his own method of doing so
		cm:modify_model():disable_diplomacy("faction:3k_main_faction_kong_rong", "faction:"..faction_key, "treaty_components_trade", "technology_required_recipient")
		cm:modify_model():disable_diplomacy("faction:"..faction_key, "faction:3k_main_faction_yuan_shu", "treaty_components_trade", treaty_availability_reason)
		
		-- Enable Kong Rong to use his specific monopoly (trade deal) treaty
		cm:modify_model():enable_diplomacy("faction:3k_main_faction_kong_rong", "faction:"..faction_key, "treaty_components_instigate_trade_monopoly", "technology_required_recipient")
		cm:modify_model():enable_diplomacy("faction:"..faction_key, "faction:3k_main_faction_kong_rong", "treaty_components_recieve_trade_monopoly", treaty_availability_reason)
	end
	if string.match(treaty_component, "treaty_components_join_empire_proposer") then
		
		--enables factions to create empires and offer them to nanman, and allows nanman to counter-propose and get better deals
		cm:modify_model():enable_diplomacy("all", "faction:"..faction_key, "treaty_components_create_empire,treaty_components_coalition_to_empire,treaty_components_alliance_to_empire", "technology_required_recipient")
		cm:modify_model():enable_diplomacy("faction:"..faction_key, "all", "treaty_components_create_empire_counter_offer", treaty_availability_reason)

		--disables faction specific empire stuff for yuan shao and yan baihu
		cm:modify_model():disable_diplomacy("faction:3k_main_faction_yuan_shao", "faction:"..faction_key, "treaty_components_create_empire", "technology_required_recipient")
		cm:modify_model():disable_diplomacy("faction:3k_dlc05_faction_white_tiger_yan", "faction:"..faction_key, "treaty_components_create_empire", "technology_required_recipient")
		cm:modify_model():disable_diplomacy("faction:"..faction_key, "faction:3k_main_faction_yuan_shao", "treaty_components_create_empire_counter_offer", treaty_availability_reason)
		cm:modify_model():disable_diplomacy("faction:"..faction_key,"faction:3k_dlc05_faction_white_tiger_yan", "treaty_components_create_empire_counter_offer", treaty_availability_reason)
		
		--re enables faction specific empire stuff for yuan shao and yan baihu
		cm:modify_model():enable_diplomacy("faction:3k_main_faction_yuan_shao", "faction:"..faction_key, "treaty_components_create_empire_yuan_shao", "technology_required_recipient")
		cm:modify_model():enable_diplomacy("faction:3k_dlc05_faction_white_tiger_yan", "faction:"..faction_key, "treaty_components_create_empire_white_tiger", "technology_required_recipient")
		cm:modify_model():enable_diplomacy("faction:"..faction_key, "faction:3k_main_faction_yuan_shao", "treaty_components_create_empire_yuan_shao_counter_offer", treaty_availability_reason)
		cm:modify_model():enable_diplomacy("faction:"..faction_key,"faction:3k_dlc05_faction_white_tiger_yan", "treaty_components_create_empire_white_tiger_counter_offer", treaty_availability_reason)
		
	end
end

--- @function print
--- @desc Prints output to the console. For debugging functionality only
--- @p [opt=false] string The message to output
--- @p [opt=false] opt_debug_only Should this only fire if the user has debug mode enabled.
--- @return nil
function nanman_tech_manager:print(string, opt_debug_only)
	if opt_debug_only and not self.debug_mode then
		return;
	end;

	out.design(self.system_id .. string);
end;

---------------------------------------------------------
--------------------SAVE/LOAD----------------------------
---------------------------------------------------------

function nanman_tech_manager:register_save_load_callbacks()

	cm:add_saving_game_callback(
		function(saving_game_event)
			cm:save_named_value("nanman_tech_manager_locked_techs", self.locked_techs);
			cm:save_named_value("nanman_tech_manager_unlocked_diplomacy_treaties", self.unlocked_diplomacy_treaties);
		end
	);

	cm:add_loading_game_callback(
		function(loading_game_event)
			self.locked_techs = cm:load_named_value("nanman_tech_manager_locked_techs", self.locked_techs);
			self.unlocked_diplomacy_treaties = cm:load_named_value("nanman_tech_manager_unlocked_diplomacy_treaties", self.unlocked_diplomacy_treaties);
		end
	);

end;

nanman_tech_manager:register_save_load_callbacks();
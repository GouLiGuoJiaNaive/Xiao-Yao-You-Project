---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------
----- Name:			dlc07_faction_yuan_shao_resource_manager.lua
----- Description: 	This script handles yuan shao's lineage pooled resource
---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------
----------------------VARIABLES AND SETUP---------------------------------
--------------------------------------------------------------------------

-- Don't load in campaigns which don't require it.
if cm.name == "ep_eight_princes" then
	output("dlc07_faction_yuan_shao_resource_manager.lua: Not loaded in this campaign." );
	return;
else
	output("dlc07_faction_yuan_shao_resource_manager.lua: Loading");
end;

cm:add_first_tick_callback(function() yuan_shao_features:initialise() end); -- fires on the first tick of every game loaded.

--yuan shao campaign data
yuan_shao_features = {

	debug_mode = false,

	yuan_shao_faction_key = "3k_main_faction_yuan_shao",
	yuan_shao_pooled_resource_key = "3k_main_pooled_resource_lineage",

	is_records_mode = false,
}

-- This table holds the pending recruitments incase they are cancelled
local number_of_pending_northern_army_units = 0

local northern_army_units = {
"3k_dlc07_unit_metal_liyang_daring_infantry",
"3k_dlc07_unit_wood_ye_vanguard_spearmen",
"3k_dlc07_unit_water_ye_vanguard_crossbows",
"3k_dlc07_unit_earth_xiongnu_noble_cavalry",
"3k_dlc07_unit_water_northern_mounted_raiders",
"3k_dlc07_unit_wood_northern_ji_infantry",
"3k_dlc07_unit_wood_northern_veteran_ji_infantry",
"3k_dlc07_unit_metal_northern_sabre_infantry",
"3k_dlc07_unit_metal_northern_veteran_sabre_infantry",
"3k_dlc07_unit_earth_northern_sabre_cavalry",
"3k_dlc07_unit_earth_northern_veteran_sabre_cavalry",
"3k_dlc07_unit_fire_northern_lancer_cavalry",
"3k_dlc07_unit_fire_northern_veteran_lancers",
"3k_dlc07_unit_wood_northern_spear_guards",
"3k_dlc07_unit_wood_northern_veteran_spears"
}

local lineage_prisoners_executed_amount = 10
local lineage_settlement_captured_amount = 20
local lineage_wars_declared_amount = 25
local lineage_vassals_obtained = 25
local lineage_northern_army_unit_employed = 10
local lineage_army_raised = 10
local lineage_siege_defended = 25
local lineage_captain_recruited = 10

function yuan_shao_features:initialise()
	self:add_listeners()

	local local_faction = cm:query_local_faction(true);
	-- we can use local faction here because these values are purely for the UI display
	if not local_faction:is_null_interface() and local_faction:name() == self.yuan_shao_faction_key then
		effect.set_context_value("dlc07_yuan_shao_lineage_captain_recruited", lineage_captain_recruited)
		effect.set_context_value("dlc07_yuan_shao_lineage_northern_army_unit_employed", lineage_northern_army_unit_employed)
		effect.set_context_value("dlc07_yuan_shao_lineage_army_raised", lineage_army_raised)
	end
  end
  
--------------------------------------------------------------------------
----------------------LISTENERS-------------------------------------------
--------------------------------------------------------------------------

function yuan_shao_features:add_listeners()
  
  output("yuan_shao_features:add_listeners()");
  
  
  --------------------------------
  ---pooled resource generation---
  --------------------------------

	core:add_listener(
		"PrisonersExecutedYuanShao",
		"CharacterCaptiveOptionApplied",
		function(context)

			if context:captive_option_outcome() == "EXECUTE" and context:capturing_force():faction():name() == self.yuan_shao_faction_key then
				return true
			end
		end,

		function(context)
			self:yuan_shao_generate_pooled_resource("3k_dlc07_pooled_factor_lineage_prisoners_executed", lineage_prisoners_executed_amount, true)
		end,
		true
	)

	core:add_listener(
		"SettlementCapturedYuanShao",
		"SettlementCaptured",
		function(context)
			--if the settlement was captured by our faction
			return context:settlement():faction():name() == self.yuan_shao_faction_key
		end,
		function(context)
			self:yuan_shao_generate_pooled_resource("3k_dlc07_pooled_factor_lineage_settlement_captured", lineage_settlement_captured_amount, true)
		end,
	true
	)

	core:add_listener(
		"WarDeclaredYuanShao",
		"ScriptEventWarDeclared",
		function(custom_context)
			return custom_context:attacker():name() == self.yuan_shao_faction_key or custom_context:defender():name() == self.yuan_shao_faction_key;
		end,
		function(context) -- What to do if listener fires.
			self:yuan_shao_generate_pooled_resource("3k_dlc07_pooled_factor_lineage_wars_declared", lineage_wars_declared_amount, true)
		end,
		true --Is persistent
	)

	core:add_listener(
		"VassalsObtainedYuanShao",
		"ScriptEventFactionBecomesVassal", -- campaign event
		function(custom_context)
			return custom_context:vassal_master():name() == self.yuan_shao_faction_key;
		end,
		function(context) -- What to do if listener fires.
			self:yuan_shao_generate_pooled_resource("3k_dlc07_pooled_factor_lineage_vassals_obtained", lineage_vassals_obtained, true)
		end,
		true --Is persistent
	)

	core:add_listener(
		"ArmyRaisedYuanShao",
		"MilitaryForceCreated",
		function(context)
			--Check if it's the correct faction
			if context:military_force_created():faction():name() == self.yuan_shao_faction_key then
				return true
			end
		end,
		function(context) -- What to do if listener fires.
			self:yuan_shao_generate_pooled_resource("3k_dlc07_pooled_factor_lineage_army_raised", lineage_army_raised, true)
		end,
		true
	)

	core:add_listener(
		"SettlementDefendedYuanShao",
		"CampaignBattleLoggedEvent",
		function(context)
			-- checks if the battle was a siege and yuan shao was defending and won
			if context:query_model():pending_battle():seige_battle() == true then 
				if context:log_entry():winning_factions():any_of(function(fac) return fac:name() == self.yuan_shao_faction_key  end) then
					if context:query_model():pending_battle():defender_battle_result() == "close_victory" or 
					context:query_model():pending_battle():defender_battle_result() == "decisive_victory" or 
					context:query_model():pending_battle():defender_battle_result() == "heroic_victory" or 
					context:query_model():pending_battle():defender_battle_result() == "pyrrhic_victory" then
						return true
					end
				end
			end
		end,
		function(context) -- What to do if listener fires.
			self:yuan_shao_generate_pooled_resource("3k_dlc07_pooled_factor_lineage_sieges_defended", lineage_siege_defended, true)
		end,
		true
	)

	core:add_listener(
		"NorthernUnitRecruitedYuanShao",
		"UnitRecruitmentInitiated",
		function(context)
			--Check if the unit is a northern army unit and it's the correct faction
			return table.contains(northern_army_units, context:unit_key()) and context:faction():name() == self.yuan_shao_faction_key
		end,
		function(context) -- What to do if listener fires.
			self:yuan_shao_generate_pooled_resource("3k_dlc07_pooled_factor_lineage_northern_army_unit_employed", lineage_northern_army_unit_employed, true)
			number_of_pending_northern_army_units = number_of_pending_northern_army_units + 1
		end,
		true
	)

	core:add_listener(
		"NorthernUnitRecruitmentCanceledYuanShao",
		"PersistentRetinueSlotSnapshotRestored",
		function(context)
			--Check if the restore is in our faction, if we have pending northen army units and if the slot that's being restored (refunded) is a northern army unit
			return table.contains(northern_army_units, context:previous_unit_record()) 
				and context:faction() ~= nil 
				and context:faction():name() == self.yuan_shao_faction_key 
				and number_of_pending_northern_army_units > 0
		end,
		function(context) -- What to do if listener fires.
			-- Take back the lineage they got for buying the unit in NorthernUnitRecruitedYuanShao
			self:yuan_shao_generate_pooled_resource("3k_dlc07_pooled_factor_lineage_northern_army_unit_employed", -lineage_northern_army_unit_employed, true)
			number_of_pending_northern_army_units = number_of_pending_northern_army_units - 1
		end,
		true
	)

	core:add_listener(
		"NorthernUnitRecruitmentCompletedYuanShao",
		"PersistentRetinueSlotSnapshotsCleared",
		function(context)
			-- Sadly can't guard here so will fire for all recruitment, no problem as recruitment should never be happening concurrently...
			return true
		end,
		function(context) -- What to do if listener fires.
			-- Reset the counter as recruitment has now been confirmed
			number_of_pending_northern_army_units = 0
		end,
		true
	)

	core:add_listener(
		"CaptainRecruitedYuanShao",
		"MilitaryForceRetinueCreated",
		function(context)
			-- check if the retinue created belongs to Yuan Shao's faction and is a mercenary (captain) retinue
			if context:military_force_retinue_created():owning_military_force():faction():name() == self.yuan_shao_faction_key and 
			context:military_force_retinue_created():is_mercenary_retinue() == true then
				return true
			end
		end,
		function(context) -- What to do if listener fires.
			self:yuan_shao_generate_pooled_resource("3k_dlc07_pooled_factor_lineage_captains_employed", lineage_captain_recruited, true)
		end,
		true
	)


end
		
--------------------------------------------------------------------------
----------------------FUNCTIONS-------------------------------------------
--------------------------------------------------------------------------

function yuan_shao_features:yuan_shao_generate_pooled_resource(pooled_resource_factor, value, adding_to_lineage)
  	output("3k_dlc07_campaign_yuan_shao_features: Add "..value.." to the lineage counts")
  	local query_faction = cm:query_faction(self.yuan_shao_faction_key);
	local query_resource_lineage = query_faction:pooled_resources():resource(self.yuan_shao_pooled_resource_key);
  
	if query_faction:is_null_interface() then
		script_error("3k_dlc07_campaign_yuan_shao_features: Cannot find faction.");
	end;

	if query_resource_lineage:is_null_interface() then
		script_error("3k_dlc07_campaign_yuan_shao_features: Cannot find lineage resource.");
	end;
	
	if adding_to_lineage then
		cm:modify_model():get_modify_pooled_resource(query_resource_lineage):apply_transaction_to_factor(pooled_resource_factor, value);
	end
end

---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------
----- Name:			Imperial Court
----- Description: 	Helper script for the Han Dynasty imperial court
---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------

out("dlc04_faction_emperor_imperial_court.lua: Loading");

--***********************************************************************************************************
--***********************************************************************************************************
-- VARIABLES
--***********************************************************************************************************
--***********************************************************************************************************

imperial_court = {};
imperial_court.han_dynasty_faction_name = "3k_dlc04_faction_empress_he";
imperial_court.system_id = "[304] Imperial Court - ";
imperial_court.print_to_console = false;

function imperial_court:initialise()
	self:print("Initialised.");

	-- Unlocking and locking diplomatic deals based on pooled resource amounts of the emperor.
	core:add_listener(
		"dlc04_imperial_court_political_party_powers",
		"PooledResourceEffectChangedEvent",
		function(context)
			return context:resource():record_key() == "3k_dlc04_pooled_resource_warlords_influence" or context:resource():record_key() == "3k_dlc04_pooled_resource_dynasty_influence";
		end,

		function(context)
			local emperor_faction = cm:modify_faction(self.han_dynasty_faction_name);
			local empire_deal_key = "treaty_components_empire";
			local deal_key;
			
			out.design("Imperial court political change in effect.")
			-- WARLORDS
			if context:resource():record_key() == "3k_dlc04_pooled_resource_warlords_influence" then
				out.design("New effect added: "..context:new_effect())
				if context:new_effect() == "3k_dlc04_effect_bundle_pooled_resource_warlords_power_level_3"
					or context:new_effect() == "3k_dlc04_effect_bundle_pooled_resource_warlords_power_level_4" 
					or context:new_effect() == "3k_dlc04_effect_bundle_pooled_resource_warlords_power_level_5" 
					then -- Level 3 Warlord Effect enable
						deal_key = "data_defined_war_coordination_enable";
						out.design("Warlord influence is level 3 or greater, deal component set to ".. deal_key..".")
				elseif context:old_effect() == "3k_dlc04_effect_bundle_pooled_resource_warlords_power_level_3" 
					or context:old_effect() == "3k_dlc04_effect_bundle_pooled_resource_warlords_power_level_4"
					or context:old_effect() == "3k_dlc04_effect_bundle_pooled_resource_warlords_power_level_5"
					then -- Level 3 Warlord Effect disable
					deal_key = "data_defined_war_coordination_disable";
					out.design("Warlord influence has dropped below level 3, deal component set to  ".. deal_key..".")
				end;

			-- DYNASTY
			elseif context:resource():record_key() == "3k_dlc04_pooled_resource_dynasty_influence" then
				out.design("New effect added: "..context:new_effect())
				if context:new_effect() == "3k_dlc04_effect_bundle_pooled_resource_dynasty_power_level_3" 
					or context:new_effect() == "3k_dlc04_effect_bundle_pooled_resource_dynasty_power_level_4" 
					or context:new_effect() == "3k_dlc04_effect_bundle_pooled_resource_dynasty_power_level_5" 
					then -- Level 3 Dynasty Effect enable
						deal_key = "data_defined_imperial_annexation_enable";
						out.design("Dynasty influence is level 3 or greater, deal component set to ".. deal_key..".")
				elseif context:old_effect() == "3k_dlc04_effect_bundle_pooled_resource_dynasty_power_level_3" 
					or context:old_effect() == "3k_dlc04_effect_bundle_pooled_resource_dynasty_power_level_4"
					or context:old_effect() == "3k_dlc04_effect_bundle_pooled_resource_dynasty_power_level_5"
					then -- Level 3 Dynasty Effect disable
					deal_key = "data_defined_imperial_annexation_disable";
					out.design("Dynasty influence has dropped below level 3, deal component set to ".. deal_key..".")
				end;
			end;

			-- Apply the deal to all empire factions.
			if deal_key then
				local world_factions = cm:query_model():world():faction_list();

				for i = 0, world_factions:num_items() - 1 do
					local target_faction = world_factions:item_at(i);
					-- Must be alive, not us and have an imperial deal with us. Can add more lookups here.
					-- The EMPIRE is a required deal, so this should be auto broken if they leave the empire.
					if not target_faction:is_dead()
						and target_faction:name() ~= emperor_faction
						and emperor_faction:query_faction():has_specified_diplomatic_deal_with(empire_deal_key, target_faction)
						and not emperor_faction:query_faction():has_specified_diplomatic_deal_with(deal_key, target_faction)
					then
						out.design("Signing automatic deal of ".. deal_key.." between 3k_dlc04_faction_empress_he and "..target_faction:name()..".")
						diplomacy_manager:apply_automatic_deal_between_factions("3k_dlc04_faction_empress_he", target_faction:name(), deal_key, false)
					end;
				end;
			end;
		end,
		true
	);
end;

-- Function to print to the console. Wrapps up functionality to there is a singular point.
function imperial_court:print(string)
	if not self.print_to_console then
		return;
	end;

	out.design(self.system_id .. string);
end;
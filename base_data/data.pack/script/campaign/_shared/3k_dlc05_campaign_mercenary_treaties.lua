---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------
----- Name:			3k_dlc05_campaign_mercenary_treaties.lua, 
----- Description: 	Three Kingdoms system to handle the granting and removal of mercenary treaties.
---------------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------
--[[
*****************************************************************
SETUP
*****************************************************************
]]--

campaign_mercenary_treaties = {};
campaign_mercenary_treaties.starting_amount=40;
campaign_mercenary_treaties.starting_effect="3k_dlc05_effect_bundle_pooled_resource_mercenary_activity_level_3";
campaign_mercenary_treaties.starting_chance=20;
campaign_mercenary_treaties.interval_between_gifts=2;
campaign_mercenary_treaties.minimum_interval_between_gifts=4;
campaign_mercenary_treaties.chance_level_3=6;
campaign_mercenary_treaties.chance_level_4=10;
campaign_mercenary_treaties.chance_level_5=12;

  
function campaign_mercenary_treaties:initialise()
	output("mercenary script initialised.");
	self:add_listeners();
end;

-- Add the listeners for the different events.
function campaign_mercenary_treaties:add_listeners()

	--If the pooled resource effect change is set to the lowest effect, break the mercenary deal with their employer. 
	core:add_listener(
    "PooledResourceEffectChangedEventMercenary", -- Unique handle
    "PooledResourceEffectChangedEvent", -- Campaign Event to listen for
	function(context)
		return string.match(context:new_effect(),"resource_mercenary_activity")
    end,
	function(context)
		local faction_keys = cm:get_human_factions();
		for i, key in ipairs(faction_keys) do
			local merc_faction = cm:query_faction(key)
			local mercenary_faction = merc_faction:name();
			local merc_effect_new = context:new_effect();
			local merc_pooled_resource = merc_faction:pooled_resources():resource("3k_dlc05_pooled_resource_mercenary_activity")
			if not merc_pooled_resource:is_null_interface() then 
				local merc_pooled_resource_value = merc_pooled_resource:value()

				--Ensures that only the appriate faction gets set their new effect
				if merc_effect_new=="3k_dlc05_effect_bundle_pooled_resource_mercenary_activity_level_1" and merc_pooled_resource_value==0 then
					cm:set_saved_value("mercenary_"..mercenary_faction, merc_effect_new,"diplomacyMercenaryEffect")
				elseif merc_effect_new=="3k_dlc05_effect_bundle_pooled_resource_mercenary_activity_level_2" and 1<=merc_pooled_resource_value and merc_pooled_resource_value<=20 then
					cm:set_saved_value("mercenary_"..mercenary_faction, merc_effect_new,"diplomacyMercenaryEffect")
				elseif merc_effect_new=="3k_dlc05_effect_bundle_pooled_resource_mercenary_activity_level_3" and 21<=merc_pooled_resource_value and merc_pooled_resource_value<=50  then
					cm:set_saved_value("mercenary_"..mercenary_faction, merc_effect_new,"diplomacyMercenaryEffect")
				elseif merc_effect_new=="3k_dlc05_effect_bundle_pooled_resource_mercenary_activity_level_4" and 51<=merc_pooled_resource_value and merc_pooled_resource_value<=79  then
					cm:set_saved_value("mercenary_"..mercenary_faction, merc_effect_new,"diplomacyMercenaryEffect")
				elseif merc_effect_new=="3k_dlc05_effect_bundle_pooled_resource_mercenary_activity_level_5" and 80<=merc_pooled_resource_value then
					cm:set_saved_value("mercenary_"..mercenary_faction, merc_effect_new,"diplomacyMercenaryEffect")
				end

				--If the Mercenary Pooled resource has fallen to zero, break the mercenary treaty
				if merc_effect_new=="3k_dlc05_effect_bundle_pooled_resource_mercenary_activity_level_1"  and merc_pooled_resource_value==0 then
					if cm:saved_value_exists("mercenary_"..mercenary_faction, "diplomacyMercenaryCQI") or cm:saved_value_exists("mercenary_"..mercenary_faction, "diplomacyMercenaryMaster") then
						cm:set_saved_value("mercenary_"..mercenary_faction, merc_effect_new,"diplomacyMercenaryEffect")
						local recipient= cm:get_saved_value("mercenary_"..mercenary_faction, "diplomacyMercenaryMaster")
						local deal_key="data_defined_situation_break_deal"
						local cqi = cm:get_saved_value("mercenary_"..mercenary_faction, "diplomacyMercenaryCQI")
		
						if cqi ~= -1 then
							--Break the mercenary contract
							cqi=cqi+1						
							self:break_treaty(context:modify_model():get_modify_faction(merc_faction),recipient,cqi)

							--If the pooled resource becomes zero, trigger the big penality. 
							cm:trigger_incident(mercenary_faction, "3k_dlc05_main_objective_mercenary_capture_failure_incident", true, true);
							--Remove the mercenary mission if it's exisiting
							self:cancel_existing_mercenary_mission(mercenary_faction)	
							--Setup the mercenary pooled resource
							self:remove_fame_and_fortune(context,mercenary_faction)
						end			
					end
				end
			end
		end;
	end,
	true
	);

	--At the start of the mercenary factions turn, check if the gift-dilemma should be granted
	core:add_listener(
    "FactionTurnStart_Mercenary", -- Unique handle
    "FactionTurnStart", -- Campaign Event to listen for
	function(context)	
		return context:faction():is_human()
    end,
	function(context)
		local faction = context:faction()
		local mercenary_faction_name = faction:name()
		--Skips the check if the faction has ever signed a mercenary deal
		if cm:saved_value_exists("mercenary_"..mercenary_faction_name,"diplomacyMercenaryChance") then
			--Check if the faction currently has a mercenary deal signed, and if it has a mercenary target deal signed
			--both lord and merc have a mercenary deal, both merc and target have a target deal,
			--therefore the only faction in the game with both a merc deal and target deal is the mercenary themselves.
			if faction:has_specified_diplomatic_deal_with_anybody("treaty_components_mercenary_contract") 
			and faction:has_specified_diplomatic_deal_with_anybody("dummy_components_mercenary_target") then
				--Whats the current chance of getting the reward - stacks every round it hasn't been rewarded
				local chance = cm:get_saved_value("mercenary_"..mercenary_faction_name,"diplomacyMercenaryChance")			
				local random_value = cm:random_number(0,100)
				--Get number of turns since the reward was handed out last time - there is minimum seperation of 4 turns
				local turns_since_last_reward = 20;
				if cm:saved_value_exists("mercenary_"..mercenary_faction_name,"diplomacyMercenaryTurnsSinceLastReward") then
					turns_since_last_reward = cm:get_saved_value("mercenary_"..mercenary_faction_name,"diplomacyMercenaryTurnsSinceLastReward")
				end
				if cm:saved_value_exists("mercenary_"..mercenary_faction_name,"diplomacyMercenaryEffect") then
					local mercenary_effect = cm:get_saved_value("mercenary_"..mercenary_faction_name,"diplomacyMercenaryEffect")
					--If nothing has been set as the effec, then get the current value and assign the effect.
					if(mercenary_effect==nil or mercenary_effect=="") then
						--Ensures that only the appriate faction gets set their new effect
						local merc_pooled_resource = cm:query_faction(mercenary_faction_name):pooled_resources():resource("3k_dlc05_pooled_resource_mercenary_activity")
						local merc_pooled_resource_value = 50
						if not merc_pooled_resource:is_null_interface() then 
							merc_pooled_resource_value = merc_pooled_resource:value()
						end
						if merc_pooled_resource_value==0 then
							mercenary_effect = "3k_dlc05_effect_bundle_pooled_resource_mercenary_activity_level_1"
						elseif 1<=merc_pooled_resource_value and merc_pooled_resource_value<=20 then
							mercenary_effect = "3k_dlc05_effect_bundle_pooled_resource_mercenary_activity_level_2"
						elseif 21<=merc_pooled_resource_value and merc_pooled_resource_value<=50  then
							mercenary_effect = "3k_dlc05_effect_bundle_pooled_resource_mercenary_activity_level_3"
						elseif 51<=merc_pooled_resource_value and merc_pooled_resource_value<=79  then
							mercenary_effect = "3k_dlc05_effect_bundle_pooled_resource_mercenary_activity_level_4"
						elseif 80<=merc_pooled_resource_value then
							mercenary_effect = "3k_dlc05_effect_bundle_pooled_resource_mercenary_activity_level_5"
						end
					end
					--Check if the player is allowed to get the gift
					if (mercenary_effect=="3k_dlc05_effect_bundle_pooled_resource_mercenary_activity_level_3" or 
					mercenary_effect=="3k_dlc05_effect_bundle_pooled_resource_mercenary_activity_level_4" or 
					mercenary_effect=="3k_dlc05_effect_bundle_pooled_resource_mercenary_activity_level_5") then
						--If the existing chance and random value are above 100 and it's has been more than 4 turns since the last reward, give an gift.
						--If its'nt then increase the chance of the gift being gifted
						if (100<=(chance+random_value) and self.minimum_interval_between_gifts<=turns_since_last_reward) then
							self:gift_dilemmas(mercenary_faction_name,mercenary_effect)
						else
							if mercenary_effect=="3k_dlc05_effect_bundle_pooled_resource_mercenary_activity_level_3" then
								chance = chance+self.chance_level_3
							elseif mercenary_effect=="3k_dlc05_effect_bundle_pooled_resource_mercenary_activity_level_4" then
								chance = chance+self.chance_level_4
							elseif mercenary_effect=="3k_dlc05_effect_bundle_pooled_resource_mercenary_activity_level_5" then
								chance = chance+self.chance_level_5
							end
							--Save the values for next turn
							cm:set_saved_value("mercenary_"..mercenary_faction_name, chance,"diplomacyMercenaryChance")
							cm:set_saved_value("mercenary_"..mercenary_faction_name,cm:get_saved_value("mercenary_"..mercenary_faction_name,"diplomacyMercenaryTurnsSinceLastReward")+1,"diplomacyMercenaryTurnsSinceLastReward")
						end
					end
					
				end
				--If the mercenary target is dead, cancel the mission.
				if cm:saved_value_exists("mercenary_"..mercenary_faction_name,"diplomacyMercenaryTarget") then
					local mercenary_target = cm:get_saved_value("mercenary_"..mercenary_faction_name,"diplomacyMercenaryTarget")
					if cm:query_faction(mercenary_target):is_dead() then
						cm:set_saved_value("mercenary_"..mercenary_faction_name, false,"diplomacyMercenaryMission")
						self:cancel_existing_mercenary_mission(mercenary_faction_name)
						self:remove_fame_and_fortune(context,mercenary_faction_name)
					end
				end
				--If there is more than 1 mercenary targets, adjust for it
				local dummy_components_mercenary_targets = faction:number_of_factions_we_have_specified_diplomatic_deal_with("dummy_components_mercenary_target")
				if 1<dummy_components_mercenary_targets then
					--Remove any extra "mercenary_decay" effect-bundle
					if cm:saved_value_exists("mercenary_"..mercenary_faction_name,"diplomacyMercenaryExtraMercenaryTarget") then
						local mercenary_effect_bundle = cm:get_saved_value("mercenary_"..mercenary_faction_name, "diplomacyMercenaryExtraMercenaryTarget")
						context:modify_model():get_modify_faction(context:faction()):remove_effect_bundle(mercenary_effect_bundle)
					end

					--Add the appropriate effect bundle
					if dummy_components_mercenary_targets==2 then
						context:modify_model():get_modify_faction(context:faction()):apply_effect_bundle("3k_dlc05_effect_bundle_mercenary_target_effect_bundle_1",2)
						cm:set_saved_value("mercenary_"..mercenary_faction_name, "3k_dlc05_effect_bundle_mercenary_target_effect_bundle_1","diplomacyMercenaryExtraMercenaryTarget")
					elseif dummy_components_mercenary_targets==3 then
						context:modify_model():get_modify_faction(context:faction()):apply_effect_bundle("3k_dlc05_effect_bundle_mercenary_target_effect_bundle_2",2)
						cm:set_saved_value("mercenary_"..mercenary_faction_name, "3k_dlc05_effect_bundle_mercenary_target_effect_bundle_2","diplomacyMercenaryExtraMercenaryTarget")
					elseif dummy_components_mercenary_targets==4 then
						context:modify_model():get_modify_faction(context:faction()):apply_effect_bundle("3k_dlc05_effect_bundle_mercenary_target_effect_bundle_3",2)
						cm:set_saved_value("mercenary_"..mercenary_faction_name, "3k_dlc05_effect_bundle_mercenary_target_effect_bundle_3","diplomacyMercenaryExtraMercenaryTarget")
					--If there is more than 4 mercenary targets
					elseif 4<dummy_components_mercenary_targets then
						context:modify_model():get_modify_faction(context:faction()):apply_effect_bundle("3k_dlc05_effect_bundle_mercenary_target_effect_bundle_3",2)
						cm:set_saved_value("mercenary_"..mercenary_faction_name, "3k_dlc05_effect_bundle_mercenary_target_effect_bundle_3","diplomacyMercenaryExtraMercenaryTarget")
						local mercenary_faction_pooled_resource = faction:pooled_resources():resource("3k_dlc05_pooled_resource_mercenary_activity")	
						local mercenary_faction_modified_pooled_resource = context:modify_model():get_modify_pooled_resource(mercenary_faction_pooled_resource)					
						local result = (dummy_components_mercenary_targets-4)*4
						mercenary_faction_modified_pooled_resource:apply_transaction_to_factor("3k_dlc05_pooled_factor_mercenary_activity_events",result)						
					end
				end
			elseif faction:has_specified_diplomatic_deal_with_anybody("treaty_components_mercenary_contract") 
			and not faction:has_specified_diplomatic_deal_with_anybody("dummy_components_mercenary_target") then
				local recipient= cm:get_saved_value("mercenary_"..mercenary_faction_name, "diplomacyMercenaryMaster")
				local deal_key="data_defined_situation_break_deal"
				local cqi = cm:get_saved_value("mercenary_"..mercenary_faction_name, "diplomacyMercenaryCQI") 

				if cqi ~= -1 then
					--Break the mercenary contract
					cqi=cqi+1			
					--self:break_treaty(context:modify_model():get_modify_faction(cm:query_faction(mercenary_faction_name)),recipient,cqi)
					self:break_treaty(context:modify_model():get_modify_faction(cm:query_faction(recipient)),mercenary_faction_name,cqi)
					--Remove the mercenary mission if it's exisiting
					self:cancel_existing_mercenary_mission(mercenary_faction_name)	
					--Reset the mercenary pooled resource
					self:remove_fame_and_fortune(context,mercenary_faction_name)
				end			
			else
				--Ensure that all values are reset
				--If no contract is signed, disable the pooled resource
				local mercenary_faction_pooled_resource = faction:pooled_resources():resource("3k_dlc05_pooled_resource_mercenary_activity")
				if not mercenary_faction_pooled_resource:is_null_interface() then
					self:remove_fame_and_fortune(context,mercenary_faction_name)
				end				
			end
		else
			--Ensure that all values are reset
			--If no contract is signed, disable the pooled resource
			local mercenary_faction_pooled_resource = faction:pooled_resources():resource("3k_dlc05_pooled_resource_mercenary_activity")
			if not mercenary_faction_pooled_resource:is_null_interface() then
				self:remove_fame_and_fortune(context,mercenary_faction_name)
			end	
		end
	end,
	true
	);

	--When the mercenary mission fails, check if the mission was present
	core:add_listener(
    "MissionCancelledMercenary", -- Unique handle
    "MissionCancelled", -- Campaign Event to listen for
	function(context)
		if string.match(context:mission():mission_record_key(),"objective_mercenary_capture") then
			return true;
		end			
		return false
    end,
	function(context)
		local faction_name = context:mission():faction():name()
		if cm:saved_value_exists("mercenary_"..faction_name,"diplomacyMercenaryMission") then
			local mission = cm:get_saved_value("mercenary_"..faction_name,"diplomacyMercenaryMission")
		end
	end,
	true
	);

	--When the mercenary mission is succesfull, set the CQI to 0
	core:add_listener(
    "MissionSucceededMercenary", -- Unique handle
    "MissionSucceeded", -- Campaign Event to listen for
	function(context)
		if string.match(context:mission():mission_record_key(),"objective_mercenary_capture") then
			return true;
		end			
		return false
    end,
	function(context)
		local faction_name = context:mission():faction():name()
		cm:set_saved_value("mercenary_"..faction_name, false,"diplomacyMercenaryMission")
	end,
	true
	);
	
	--When any kind of mercenary treaty is being signed, the listener handles the mission
	core:add_listener(
    "DiplomacyDealNegotiatedMercenaryMission", -- Unique handle
    "DiplomacyDealNegotiated", -- Campaign Event to listen for
	function(context)
		local deals = context:deals():deals()
		for i =0,deals:num_items()-1 do
			local deal = deals:item_at(i)
			for j = 0, deal:components():num_items()-1 do
				local component= deal:components():item_at(j)
				if ((component:proposer():is_human() or component:recipient():is_human()) and 
				(string.match(component:treaty_component_key(),"mercenary") or string.match(component:treaty_component_key(),"break"))) then
					return true
				end				
			end
		end		
		return false
    end,
	function(context)
		local deals = context:deals():deals()
		local mercenary_lord_faction = nil
		local mercenary_faction = nil
		local player_is_offering_the_deal = false;
		local mercenary_contract_found = false;
		for i =0,deals:num_items()-1 do
			local deal = deals:item_at(i)
			for j = 0, deal:components():num_items()-1 do
				local component= deal:components():item_at(j)
				if component:treaty_component_key()=="treaty_components_mercenary_contract_proposer_declares_war_against_target" or 
					component:treaty_component_key()=="treaty_components_mercenary_counter_contract_proposer_declares_war_against_target" then
					player_is_offering_the_deal=true;
				end
				if mercenary_contract_found then break end;	--If the mercenary deal is found - We don't need to search anymore
				
				--data has been set up in a way such that the merc lord is always the proposer
				mercenary_lord_faction = component:recipient();
				mercenary_faction = component:proposer();

				--If string matches mercenary_contract or mercenary_counter_contract
				if (string.match(component:treaty_component_key(),"mercenary_contract") or string.match(component:treaty_component_key(),"mercenary_counter_contract")) then
					--If recipient declares war, then the recipient is mercenary faction.
					if string.match(component:treaty_component_key(),"recipient_declares_war_against_target") then
						local mercenary_temp = mercenary_faction;
						mercenary_faction = mercenary_lord_faction;
						mercenary_lord_faction = mercenary_temp;
					end
					--If "mercenary_counter_contract", remove and then add information
					if string.match(component:treaty_component_key(),"mercenary_counter_contract") then
						self:remove_fame_and_fortune(context,mercenary_faction:name())
					end
					
					--Set the save values for the mercenary faction
					cm:set_saved_value("mercenary_"..mercenary_faction:name(), deal:deal():cqi(),"diplomacyMercenaryCQI")
					cm:set_saved_value("mercenary_"..mercenary_faction:name(), mercenary_lord_faction:name(),"diplomacyMercenaryMaster")
					
					--Mercenary deal is found - We don't need to search anymore
					mercenary_contract_found=true; 
				end
				--[[
				--If there is a break deal component, then
				elseif string.match(component:treaty_component_key(),"break") then
					if not mercenary_faction:has_specified_diplomatic_deal_with_anybody("treaty_components_mercenary_contract") then
						self:cancel_existing_mercenary_mission(mercenary_faction:name())				
						--Setup the mercenary pooled resource
						self:remove_fame_and_fortune(context,mercenary_faction:name())
					end
				--]]
			end
		end	
		--If the results aren't null, assign mission and setup whom to attack
		if (mercenary_faction ~= nil) then
			if not mercenary_faction:is_null_interface() then
				--Find whom the mercenary_target is
				local mercenary_targets = mercenary_faction:factions_we_have_specified_diplomatic_deal_with("dummy_components_mercenary_target")
				--If there is more than 0, continue
				if 0 < mercenary_targets:num_items() and mercenary_faction:is_human() then
					--Always get the first one (there is always 1 or 0 targets)
					local mercenary_target_faction = mercenary_targets:item_at(0)
					cm:set_saved_value("mercenary_"..mercenary_faction:name(), mercenary_target_faction:name(),"diplomacyMercenaryTarget")

					--Create the mercenary mission
					if mercenary_target_faction~=nil then
						start_tutorial_mission_listener(
						mercenary_faction:name(), -- faction key
						"3k_dlc05_main_objective_mercenary_capture", -- mission key
						"DEFEAT_N_ARMIES_OF_FACTION", -- objective type
						{
							("faction "..mercenary_target_faction:name()),
							"total 1"
						}, -- conditions (single string or table of strings)
						{
							"money 1000"
						}, -- mission rewards (table of strings)                                            
						(mercenary_faction:name().."_Mercenary_Mission_"..mercenary_target_faction:name()),      -- trigger event 
						(mercenary_faction:name().."_Mercenary_Mission_"..mercenary_target_faction:name().."_COMPLETE"),     -- completion event
						function()
							if not cm:query_faction(mercenary_target_faction:name()):is_dead() then
								return true
							end
						end, -- precondition (nil, or a function that returns a boolean)
						(mercenary_faction:name().."_Mercenary_Mission_"..mercenary_target_faction:name().."_FAIL")       -- failure event
						);
						--Trigger the mission
						core:trigger_event((mercenary_faction:name().."_Mercenary_Mission_"..mercenary_target_faction:name()))
						cm:set_saved_value("mercenary_"..mercenary_faction:name(), true,"diplomacyMercenaryMission")
						--Make target capital visible in the shroud 
						if not mercenary_target_faction:capital_region():is_null_interface() then
							context:modify_model():get_modify_faction(mercenary_faction):make_region_seen_in_shroud(mercenary_target_faction:capital_region():name());
						end				
						
						--Setup the mercenary pooled resource
						self:setup_fame_and_fortune(context,mercenary_faction:name(),player_is_offering_the_deal)
					end
					--If there is more than 1 mercenary targets, adjust for the decay for it
					if 1<mercenary_targets:num_items() then
						--Remove any extra "mercenary_decay" effect-bundle
						if cm:saved_value_exists("mercenary_"..mercenary_faction:name(),"diplomacyMercenaryExtraMercenaryTarget") then
							local mercenary_effect_bundle = cm:get_saved_value("mercenary_"..mercenary_faction:name(), "diplomacyMercenaryExtraMercenaryTarget")
							context:modify_model():get_modify_faction(mercenary_faction):remove_effect_bundle(mercenary_effect_bundle)
						end
						--Add the appropriate effect bundle
						if mercenary_targets:num_items()==2 then
							context:modify_model():get_modify_faction(mercenary_faction):apply_effect_bundle("3k_dlc05_effect_bundle_mercenary_target_effect_bundle_1",1)
							cm:set_saved_value("mercenary_"..mercenary_faction:name(), "3k_dlc05_effect_bundle_mercenary_target_effect_bundle_1","diplomacyMercenaryExtraMercenaryTarget")
						elseif mercenary_targets:num_items()==3 then
							context:modify_model():get_modify_faction(mercenary_faction):apply_effect_bundle("3k_dlc05_effect_bundle_mercenary_target_effect_bundle_2",1)
							cm:set_saved_value("mercenary_"..mercenary_faction:name(), "3k_dlc05_effect_bundle_mercenary_target_effect_bundle_2","diplomacyMercenaryExtraMercenaryTarget")
						elseif mercenary_targets:num_items()==4 then
							context:modify_model():get_modify_faction(mercenary_faction):apply_effect_bundle("3k_dlc05_effect_bundle_mercenary_target_effect_bundle_3",1)
							cm:set_saved_value("mercenary_"..mercenary_faction:name(), "3k_dlc05_effect_bundle_mercenary_target_effect_bundle_3","diplomacyMercenaryExtraMercenaryTarget")
						--If there is more than 4 mercenary targets
						elseif 4<mercenary_targets:num_items() then
							context:modify_model():get_modify_faction(mercenary_faction):apply_effect_bundle("3k_dlc05_effect_bundle_mercenary_target_effect_bundle_3",1)
							cm:set_saved_value("mercenary_"..mercenary_faction:name(), "3k_dlc05_effect_bundle_mercenary_target_effect_bundle_3","diplomacyMercenaryExtraMercenaryTarget")
							local mercenary_faction_pooled_resource = mercenary_faction:pooled_resources():resource("3k_dlc05_pooled_resource_mercenary_activity")	
							local mercenary_faction_modified_pooled_resource = context:modify_model():get_modify_pooled_resource(mercenary_faction_pooled_resource)					
							local result = (mercenary_targets:num_items()-4)*4
							mercenary_faction_modified_pooled_resource:apply_transaction_to_factor("3k_dlc05_pooled_factor_mercenary_activity_events",result)						
						end
					end							
				end
			end
		end	
	end,
	true
	);
end;

cm:add_first_tick_callback(function() campaign_mercenary_treaties:initialise() end);
--[[
*****************************************************************
HELPERS
*****************************************************************
]]--

--Cancels mercenary mission
function campaign_mercenary_treaties:cancel_existing_mercenary_mission(mercenary_faction_name)
	if cm:saved_value_exists("mercenary_"..mercenary_faction_name,"diplomacyMercenaryTarget") then
		if cm:get_saved_value("mercenary_"..mercenary_faction_name, "diplomacyMercenaryMission") then
			local mercenary_target_name = cm:get_saved_value("mercenary_"..mercenary_faction_name,"diplomacyMercenaryTarget")
			if mercenary_target_name ~= "" then
				cm:set_saved_value("mercenary_"..mercenary_faction_name, false,"diplomacyMercenaryMission")
				cm:cancel_custom_mission(mercenary_faction_name, "3k_dlc05_main_objective_mercenary_capture")
				core:remove_listener(mercenary_faction_name.."_Mercenary_Mission_"..mercenary_faction_name)
				--self:reset_saved_values(mercenary_faction_name)
			end
		end		
	end
end

function campaign_mercenary_treaties:reset_saved_values(mercenary_faction_name)
	cm:set_saved_value("mercenary_"..mercenary_faction_name, -1,"diplomacyMercenaryCQI")
	cm:set_saved_value("mercenary_"..mercenary_faction_name, "","diplomacyMercenaryMaster")
	cm:set_saved_value("mercenary_"..mercenary_faction_name, "","diplomacyMercenaryEffect")
	cm:set_saved_value("mercenary_"..mercenary_faction_name, -1,"diplomacyMercenaryChance")
	cm:set_saved_value("mercenary_"..mercenary_faction_name, -1,"diplomacyMercenaryTurnsSinceLastReward")	
	--cm:set_saved_value("mercenary_"..mercenary_faction_name, false,"diplomacyMercenaryMission")
end

--Setup "Fame and fortune" when signing a mercenary treaty
function campaign_mercenary_treaties:setup_fame_and_fortune(context,mercenary_faction_name,player_is_offering_the_deal)
	local mercenary_faction = context:query_model():world():faction_by_key(mercenary_faction_name)
	local mercenary_faction_pooled_resource = mercenary_faction:pooled_resources():resource("3k_dlc05_pooled_resource_mercenary_activity")	
	local mercenary_faction_modified_pooled_resource = context:modify_model():get_modify_pooled_resource(mercenary_faction_pooled_resource)
	--Reset the value to 40
	local starting_amount = self.starting_amount
	if not player_is_offering_the_deal then
		starting_amount=starting_amount+4;
	end
	local result = -(mercenary_faction_pooled_resource:value()-starting_amount)
	cm:set_saved_value("mercenary_"..mercenary_faction_name, self.starting_effect,"diplomacyMercenaryEffect")	
	cm:set_saved_value("mercenary_"..mercenary_faction_name, self.starting_chance,"diplomacyMercenaryChance")	
	cm:set_saved_value("mercenary_"..mercenary_faction_name, self.interval_between_gifts,"diplomacyMercenaryTurnsSinceLastReward")	
	
	mercenary_faction_modified_pooled_resource:enable()
	mercenary_faction_modified_pooled_resource:apply_transaction_to_factor("3k_dlc05_pooled_factor_mercenary_activity_events",result)
end

--Remove "Fame and fortune" when mercenary treaty is complete
function campaign_mercenary_treaties:remove_fame_and_fortune(context,mercenary_faction_name)
	local mercenary_faction = context:query_model():world():faction_by_key(mercenary_faction_name)
	local mercenary_faction_pooled_resource = mercenary_faction:pooled_resources():resource("3k_dlc05_pooled_resource_mercenary_activity")	
	local mercenary_faction_modified_pooled_resource = context:modify_model():get_modify_pooled_resource(mercenary_faction_pooled_resource)
	--Reset the value to 40
	local result = -(mercenary_faction_pooled_resource:value()-self.starting_amount)
	mercenary_faction_modified_pooled_resource:apply_transaction_to_factor("3k_dlc05_pooled_factor_mercenary_activity_events",result)
	mercenary_faction_modified_pooled_resource:disable()
	--Remove the mercenary mission if it's exisiting	
	self:cancel_existing_mercenary_mission(mercenary_faction_name)
	--Reset values
	self:reset_saved_values(mercenary_faction_name);
end

--Trigger the "gift"-dilemma
function campaign_mercenary_treaties:gift_dilemmas(mercenary_faction_name,mercenary_effect)
	if mercenary_effect=="3k_dlc05_effect_bundle_pooled_resource_mercenary_activity_level_3" then
		cm:trigger_dilemma(mercenary_faction_name, "3k_dlc05_main_objective_mercenary_reward_small_dilemma", true);
	elseif mercenary_effect=="3k_dlc05_effect_bundle_pooled_resource_mercenary_activity_level_4" then
		cm:trigger_dilemma(mercenary_faction_name, "3k_dlc05_main_objective_mercenary_reward_medium_dilemma", true);
	elseif mercenary_effect=="3k_dlc05_effect_bundle_pooled_resource_mercenary_activity_level_5" then
		cm:trigger_dilemma(mercenary_faction_name, "3k_dlc05_main_objective_mercenary_reward_large_dilemma", true);
	end
	--Resets the chance of getting an gift and the turns it takes
	cm:set_saved_value("mercenary_"..mercenary_faction_name, 0,"diplomacyMercenaryChance")
	cm:set_saved_value("mercenary_"..mercenary_faction_name,0,"diplomacyMercenaryTurnsSinceLastReward")
end

--Breaks an deal with the recipient
function campaign_mercenary_treaties:break_treaty(modifed_faction,recipient,cqi)
	local deal_key="data_defined_situation_break_deal"

	modifed_faction:apply_automatic_diplomatic_deal(
		deal_key, 
		cm:query_faction(recipient),
		"deal_cqi:"..tostring(cqi)
	);	
end
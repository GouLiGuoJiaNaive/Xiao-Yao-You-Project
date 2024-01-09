--------------------------------------------------------------------------
--------------------------------------------------------------------------
----------------------- LADY ZHURONG FEATURE -----------------------------
--------------------------------------------------------------------------
---------------------- Created by Jakob P. Holm --------------------------
--------------------------------------------------------------------------
--------------------------------------------------------------------------

-- Early exit if we're in certain campaigns.
if cm.name == "ep_eight_princes" or cm.name == "dlc07_guandu" then
	output("lady_zhurong_features: Not loaded in this campaign." );
	return;
else
	output("lady_zhurong_features.lua: Loading");
end;

--------------------------------------------------------------------------
----------------------VARIABLES AND SETUP---------------------------------
--------------------------------------------------------------------------
lady_zhurong_features = {
	--WILD FIRE VARIABLES
	faction_key="3k_dlc06_faction_nanman_lady_zhurong";
	wild_fire_duration=5;	--The max number of turns that Wild Fire can last. 4 is the number of turns the AI has it activated.
	wild_fire_duration_for_ai=4;	--The max number of turns that Wild Fire can last. 4 is the number of turns the AI has it activated.
	burn_out_duration=3; 	--The number of turns that Burn Out lasts if activated before the player takes control.
	smouldering_fire_reset_value=0;
	flaming_confinement_reset_value=0;
	--EFFECTS OF THE SEASONS
	spring_effect_bundle="3k_dlc06_effect_bundle_goddess_of_fire_season_spring";
	summer_effect_bundle="3k_dlc06_effect_bundle_goddess_of_fire_season_summer";
	harvest_effect_bundle="3k_dlc06_effect_bundle_goddess_of_fire_season_harvest";
	fall_effect_bundle_records="3k_dlc06_effect_bundle_goddess_of_fire_season_fall_records";
	fall_effect_bundle_romance="3k_dlc06_effect_bundle_goddess_of_fire_season_fall_romance";
	winter_effect_bundle="3k_dlc06_effect_bundle_goddess_of_fire_season_winter";
	--EFFECTS OF ACTIVATING WILD FIRE BASED ON SEASON
	wild_fire_spring_effect_bundle="3k_dlc06_effect_bundle_goddess_of_fire_wild_fire_season_spring";
	wild_fire_summer_effect_bundle="3k_dlc06_effect_bundle_goddess_of_fire_wild_fire_season_summer";
	wild_fire_harvest_effect_bundle="3k_dlc06_effect_bundle_goddess_of_fire_wild_fire_season_harvest";
	wild_fire_fall_records_effect_bundle="3k_dlc06_effect_bundle_goddess_of_fire_wild_fire_season_fall_records";
	wild_fire_fall_romance_effect_bundle="3k_dlc06_effect_bundle_goddess_of_fire_wild_fire_season_fall_romance";
	wild_fire_winter_effect_bundle="3k_dlc06_effect_bundle_goddess_of_fire_wild_fire_season_winter";
	--SEASONAL EFFECT WHEN WILD FIRE IS ACTIVE
	wild_fire_spring_effect_bundle_decay="3k_dlc06_effect_bundle_goddess_of_fire_wild_fire_season_spring_decay";
	wild_fire_summer_effect_bundle_decay="3k_dlc06_effect_bundle_goddess_of_fire_wild_fire_season_summer_decay";
	wild_fire_harvest_effect_bundle_decay="3k_dlc06_effect_bundle_goddess_of_fire_wild_fire_season_harvest_decay";
	wild_fire_fall_records_effect_bundle_decay="3k_dlc06_effect_bundle_goddess_of_fire_wild_fire_season_fall_records_decay";
	wild_fire_fall_romance_effect_bundle_decay="3k_dlc06_effect_bundle_goddess_of_fire_wild_fire_season_fall_romance_decay";
	wild_fire_winter_effect_bundle_decay="3k_dlc06_effect_bundle_goddess_of_fire_wild_fire_season_winter_decay";
	--WILD FIRE INFO EVENTS
	wild_fire_info_player = "3k_dlc06_faction_lady_zhurong_goddess_of_fire_wild_fire";
	wild_fire_info_opponent = "3k_dlc06_faction_lady_zhurong_goddess_of_fire_opponent";
	wild_fire_info_first_time = "3k_dlc06_faction_lady_zhurong_goddess_of_fire";
	wild_fire_info_burnout_first_time = "3k_dlc06_faction_lady_zhurong_goddess_of_fire_burnout";
	--BURNOUT WHEN WILD FIRE HAS ENDED
	wild_fire_burn_out_effect_bundle="3k_dlc06_effect_bundle_goddess_of_fire_wild_fire_burn_out";
	--EFFECTS OF ACTIVATING WILD FIRE EFFECTS ON ARMIES
	wild_fire_army_strong="3k_dlc06_effect_bundle_goddess_of_fire_wild_fire_army";
	wild_fire_army_weak="3k_dlc06_effect_bundle_goddess_of_fire_kindle_army";
	--EFFECTS OF ACTIVATING WILD FIRE EFFECTS ON REGIONS
	--wild_fire_region_effect_bundle_base="3k_dlc06_effect_bundle_goddess_of_fire_wild_fire_region_base";
	--wild_fire_region_effect_bundle_military_1="3k_dlc06_effect_bundle_goddess_of_fire_wild_fire_region_military_1";
	--wild_fire_region_effect_bundle_military_2="3k_dlc06_effect_bundle_goddess_of_fire_wild_fire_region_military_2";
	--wild_fire_region_effect_bundle_construction_1="3k_dlc06_effect_bundle_goddess_of_fire_wild_fire_region_construction_1";
	--wild_fire_region_effect_bundle_construction_2="3k_dlc06_effect_bundle_goddess_of_fire_wild_fire_region_construction_2";
	--wild_fire_region_effect_bundle_population_1="3k_dlc06_effect_bundle_goddess_of_fire_wild_fire_region_population_1";
	--wild_fire_region_effect_bundle_population_2="3k_dlc06_effect_bundle_goddess_of_fire_wild_fire_region_population_2";
   }

   -- Don't load in campaigns which don't require it.
if cm.name == "ep_eight_princes" then
	output("dlc06_faction_nanman_lady_zhurong_feature.lua: Not loaded in this campaign." );
	return;
else
	output("dlc06_faction_nanman_lady_zhurong_feature.lua: Loading");
end;

function lady_zhurong_features:initialise()

	-- Check if faction doesn't exist or pooled resource is broken.
	local lz_faction = cm:query_faction(self.faction_key);
	if not lz_faction or lz_faction:is_null_interface() then
		script_error("lady_zhurong_features:Initialise() Unable to find Lady Zhurong's faction, so exiting. Should this script be enabled?");
		return;
	end;

	local lz_pooled_resource = lz_faction:pooled_resources():resource("3k_dlc06_pooled_resource_goddess_of_fire")
	if not lz_pooled_resource or lz_pooled_resource:is_null_interface() then
		script_error("lady_zhurong_features:Initialise() Unable to find Lady Zhurong's pooled resource, so exiting. Has is been added in startpos?");
		return;
	end;

	self:add_listeners();
	--UPDATE THE UI OF THE LATEST
	self:update_ui_wild_fire_is_active()
	self:update_ui_wild_fire_can_be_active()
	self:update_ui_wild_fire_season()
end

cm:add_first_tick_callback(function() lady_zhurong_features:initialise() end); --Self register function
--------------------------------------------------------------------------
----------------------LISTENERS-------------------------------------------
--------------------------------------------------------------------------

function lady_zhurong_features:add_listeners()
  output("lady_zhurong_features:add_listeners()");

  --When button is pressed, activate "Wild FIRE"
  core:add_listener(
		"LadyZhuronglady_zhurong_wild_fire_activated", -- Unique handle
		"ModelScriptNotificationEvent", -- Campaign Event to listen for
		function(context)
			local faction = context:faction():query_faction()
			if context:event_id()=="lady_zhurong_wild_fire_activated" then
				local goddess_of_fire = faction:pooled_resources():resource("3k_dlc06_pooled_resource_goddess_of_fire")
				if not goddess_of_fire:is_null_interface() then
					local wild_fire_activated = false
					if cm:saved_value_exists("wild_fire_active", "goddess_of_fire") then
						wild_fire_activated=cm:get_saved_value("wild_fire_active","goddess_of_fire")
					end
					--CAN THE PLAYER AFFORD THE POWER AND CHECK IF IT'S ALREADY ACTIVATED
					if goddess_of_fire:value()==goddess_of_fire:maximum_value() or wild_fire_activated then 
						return context:faction():query_faction():name()==self.faction_key
					end					
				end
			end
			return false;
		end,
		function(context) -- What to do if listener fires.
			--Check if Wild Fire is activate.
			local wild_fire_activated = false
			if cm:saved_value_exists("wild_fire_active", "goddess_of_fire") then
				wild_fire_activated=cm:get_saved_value("wild_fire_active","goddess_of_fire")
			end
			if wild_fire_activated then
				--REMOVE WILD FIRE
				self:remove_wild_fire(context,true);
			else
				--IGNITE WILD FIRE
				self:activate_wild_fire(context);
			end
		end,
	true);

  --FactionTurnStart
  core:add_listener(
		"LadyZhurongFactionTurnStart", -- Unique handle
		"FactionTurnStart", -- Campaign Event to listen for
		function(context)
			return (not context:faction():is_dead() and context:faction():name()==self.faction_key)
		end,
		function(context) -- What to do if listener fires.
			local faction = context:faction()	
			--Check if pooled resource is 0 or MAX VALUE at the start of the turn
			--If it's 0 then remove WILD FIRE, if it's MAX VALUE then give WILD FIRE. 
			if not faction:is_null_interface() then
				if not faction:pooled_resources():is_null_interface() then
					local goddess_of_fire = faction:pooled_resources():resource("3k_dlc06_pooled_resource_goddess_of_fire")
					if not goddess_of_fire:is_null_interface() then

						--If the game mode hasn't been saved, save it.
						if not cm:saved_value_exists("campaign_game_mode", "goddess_of_fire") then
							cm:set_saved_value("campaign_game_mode",context:query_model():campaign_game_mode(),"goddess_of_fire")							
						end

						--Apply this seasons effect bundle -> The bundles only increases the faction pooled resource
						self:apply_season_effect(context:modify_model():get_modify_faction(faction))

						if cm:saved_value_exists("wild_fire_turns_left", "goddess_of_fire") then
							local number_of_turns_left = cm:get_saved_value("wild_fire_turns_left","goddess_of_fire")-1
							--IF ZERO, REMOVE WILD FIRE AND SET POOLED RESOURCE TO BE 0
							if number_of_turns_left == 0 then
								--FACTION LEVEL
								self:remove_wild_fire(context,false);
							
							--IN ALL OTHER CASES, SAVED THE REDUCED WILD FIRE COUNTER
							elseif number_of_turns_left ~= -1 then
								cm:set_saved_value("wild_fire_turns_left",number_of_turns_left,"goddess_of_fire")								
							end
						end
						
						--INFORM UI of the values
						self:update_ui_wild_fire_is_active() --Check if Wild Fire is activate.
						self:update_ui_wild_fire_can_be_active() --Check if Wild Fire can be active

						local wild_fire_activated = false
						if cm:saved_value_exists("wild_fire_active", "goddess_of_fire") then
							wild_fire_activated=cm:get_saved_value("wild_fire_active","goddess_of_fire")
						end	

						if not wild_fire_activated then 
							--If pooled resource is max, then Decrease flaming confinement to motivate player to use Wild Fire 
							if goddess_of_fire:value()==goddess_of_fire:maximum_value() then
								local flaming_confinement = faction:pooled_resources():resource("3k_dlc06_pooled_resource_flaming_confinement")
								if not flaming_confinement:is_null_interface() then
									context:modify_model():get_modify_pooled_resource(flaming_confinement):apply_transaction_to_factor("3k_dlc06_pooled_factor_resource_flaming_confinement_increase",1)
								end
								--Check if the AI should activate "Wild Fire"
								if not faction:is_human() then
									--ADD WILD FIRE
									wild_fire_activated=true;
									--FACTION LEVEL
									self:activate_wild_fire(context);
								--Inform the player about how to activate Wild Fire for the first time
								elseif faction:is_human() and not cm:has_incident_fired_for_faction(self.faction_key,self.wild_fire_info_first_time) then
									cm:trigger_incident(faction, self.wild_fire_info_first_time, true, true)
								end
							end							
						else
							--Increase smouldering fire to motivate player to not use Wild Fire anymore.
							local smouldering_fire = faction:pooled_resources():resource("3k_dlc06_pooled_resource_smouldering_fire")
							
							if not smouldering_fire:is_null_interface() then
								context:modify_model():get_modify_pooled_resource(smouldering_fire):apply_transaction_to_factor("3k_dlc06_pooled_factor_resource_smouldering_fire_increase",1)
							end	
						end
					end
				end				
			end			
		end,
		true);

	--PooledResourceEffectChangedEvent
	core:add_listener(
		"LadyZhurongPooledResourceEffectChangedEvent", -- Unique handle
		"PooledResourceEffectChangedEvent", -- Campaign Event to listen for
		function(context)
			--Check if "kindle"-effect was the old or new effect activated
			return context:old_effect()=="3k_dlc06_effect_bundle_pooled_resource_goddess_of_fire_level_1" or 
			context:new_effect()=="3k_dlc06_effect_bundle_pooled_resource_goddess_of_fire_level_1"
		end,
		function(context) -- What to do if listener fires.
			if context:new_effect()=="3k_dlc06_effect_bundle_pooled_resource_goddess_of_fire_level_1" then
				cm:set_saved_value("kindle_status", true,"goddess_of_fire")
			elseif context:old_effect()=="3k_dlc06_effect_bundle_pooled_resource_goddess_of_fire_level_1" then
				cm:set_saved_value("kindle_status", false,"goddess_of_fire")
				local military_force = cm:query_faction(self.faction_key):military_force_list()
				self:apply_wild_fire_effect_armies(military_force,"Remove_kindle")
			end		
		end,
	true);

	--MilitaryForceCreated
	core:add_listener(
		"LadyZhurongMilitaryForceCreated", -- Unique handle
		"MilitaryForceCreated", -- Campaign Event to listen for
		function(context)
			--Check if it's the correct faction
			return context:military_force_created():faction():name()==self.faction_key
		end,
		function(context) -- What to do if listener fires.
			local modified_force = context:modify_model():get_modify_military_force(context:military_force_created())
			local wild_fire_activated = false
			--Give the apprioriate army effect bundle based on wild fire or if the pooled resource is "kindle"
			--WILD FIRE IS ACTIVE
			if cm:saved_value_exists("wild_fire_active", "goddess_of_fire") then
				wild_fire_activated=cm:get_saved_value("wild_fire_active","goddess_of_fire")
				if cm:saved_value_exists("wild_fire_turns_left", "goddess_of_fire") then
					self:apply_wild_fire_effect_military_force(modified_force,cm:get_saved_value("wild_fire_turns_left", "goddess_of_fire"))
				end
			--KINDLE IS ACTIVE
			else
				if cm:saved_value_exists("wild_fire_turns_left", "goddess_of_fire") and cm:saved_value_exists("kindle_status", "goddess_of_fire") then
					if cm:get_saved_value("kindle_status", "goddess_of_fire") then
						self:apply_wild_fire_effect_military_force(modified_force,cm:get_saved_value("wild_fire_turns_left", "goddess_of_fire"))
					end					
				end
			end
			--OTHERWISE DO NOTHING			
		end,
	true);

	--If Lady Zhurong's faction is about to die, then remove Wild Fire. 
	core:add_listener(
		"LadyZhurongFactionAboutToDie", -- Unique handle
		"FactionAboutToDie", -- Campaign Event to listen for
		function(context)
			return context:faction():name()==self.faction_key
		end,
		function(context) -- What to do if listener fires.
			local killer_faction = cm:query_faction(context:killer_or_confederator_faction_key())
			if not killer_faction:is_null_interface() then
				local military_force = killer_faction:military_force_list()
				self:apply_wild_fire_effect_armies(military_force,"Remove_all")
			end
		end,
	true);

	--BuildingCompleted
	--Is incomplete because of final decision haven't been made on feature
	--[[
	core:add_listener(
		"LadyZhurongBuildingCompleted", -- Unique handle
		"BuildingCompleted", -- Campaign Event to listen for
		function(context)
			if context:building():faction():name()=="3k_dlc06_faction_nanman_lady_zhurong" then
				--Check if Wild Fire is activate.
				local wild_fire_activated = false
				if cm:saved_value_exists("wild_fire_active", "goddess_of_fire") then
					wild_fire_activated=cm:get_saved_value("wild_fire_active","goddess_of_fire")
				end
				if wild_fire_activated then
					--Check if it's one of temple the building
					return (context:building():name()=="" or --Base temple
					context:building():name()=="" or --Military temple 1
					context:building():name()=="" or --Military temple 2
					context:building():name()=="" or --Construction temple 1
					context:building():name()=="" or --Construction temple 2
					context:building():name()=="" or --Population temple 1
					context:building():name()=="")    --Population temple 2
				end
			end
			return false;
		end,
		function(context) -- What to do if listener fires.
			local faction = context:faction()			
			if context:building():name()=="" then 	--Base temple

			elseif (context:building():name()=="" or 	--Military temple 1
			context:building():name()=="" or 			--Construction temple 1
			context:building():name()=="" ) then 		--Population temple 1

			elseif context:building():name()=="" then  	--Military temple 2

			elseif context:building():name()=="" then  	--Construction temple 2

			elseif context:building():name()=="" then  	--Population temple 2
				--self:apply_wild_fire_effect_region(self.wild_fire_region_effect_bundle_population_2)
				--self:apply_wild_fire_effect_region(self.wild_fire_region_effect_bundle_population_2)
			end
		end,
	true);
	]]--
	
end

--------------------------------------------------------------------------
-------------------------------HELPERS------------------------------------
--------------------------------------------------------------------------

--Update the UI panel if Wild Fire is active
function lady_zhurong_features:update_ui_wild_fire_is_active()
	local wild_fire_activated_number = 0
	if cm:saved_value_exists("wild_fire_active", "goddess_of_fire") then
		wild_fire_activated_number=1
	end
	effect.set_context_value("3k_dlc06_wild_fire_panel_wild_fire_active", wild_fire_activated_number);
	effect.call_context_command("UiMsg('update_wildfire')")
end

--Update the UI panel if Wild Fire can be active
function lady_zhurong_features:update_ui_wild_fire_can_be_active()
	local wild_fire_can_active_number = 0
	local lady_zhurong_faction = cm:query_faction(self.faction_key)
	if lady_zhurong_faction and not lady_zhurong_faction:is_null_interface() then
		local goddess_of_fire = lady_zhurong_faction:pooled_resources():resource("3k_dlc06_pooled_resource_goddess_of_fire")
		if not goddess_of_fire:is_null_interface() then
			if  goddess_of_fire:value()==goddess_of_fire:maximum_value() then 
				wild_fire_can_active_number = 1
			end
		end
		effect.set_context_value("3k_dlc06_wild_fire_panel_wild_fire_can_active",wild_fire_can_active_number);
		effect.call_context_command("UiMsg('update_wildfire')")
	end
end

--Update the UI panel what season it's
function lady_zhurong_features:update_ui_wild_fire_season(context)
	if cm:saved_value_exists("wild_fire_season","goddess_of_fire") then
		local current_season = cm:get_saved_value("wild_fire_season","goddess_of_fire")
		if current_season=="fall" then current_season="autumn" end
		effect.set_context_value("3k_dlc06_wild_fire_panel_current_season", "season_"..current_season);
		effect.call_context_command("UiMsg('update_wildfire')")
	end
end

--Apply Lady Zhurong's Wild Fire based on what the season is
function lady_zhurong_features:activate_wild_fire(context)
	if cm:saved_value_exists("turn_season", "goddess_of_fire") then
		local current_season = cm:get_saved_value("turn_season","goddess_of_fire")
		local game_mode = "romance"
		if cm:saved_value_exists("campaign_game_mode", "goddess_of_fire") then
			game_mode = cm:get_saved_value("campaign_game_mode","goddess_of_fire")
		end		
		--Save the season that Wild Fire was activated
		cm:set_saved_value("wild_fire_season",current_season,"goddess_of_fire")
		cm:set_saved_value("wild_fire_active", true,"goddess_of_fire")
		--Update UI
		self:update_ui_wild_fire_is_active() 
		self:update_ui_wild_fire_season()

		local turns_of_wild_fire = self.wild_fire_duration
		local lady_zhurong_faction = cm:query_faction(self.faction_key)
		--AI WILL ONLY USE WILD FIRE FOR 4 TURNS
		if not lady_zhurong_faction:is_human() then 
			turns_of_wild_fire = self.wild_fire_duration_for_ai
		end
		cm:set_saved_value("wild_fire_turns_left",turns_of_wild_fire,"goddess_of_fire")
		local modify_faction = context:modify_model():get_modify_faction(lady_zhurong_faction)

		--FACTION
		--TELL PLAYER THAT WILD FIRE HAS BEEN ACTIVATED
		cm:trigger_incident(lady_zhurong_faction, self.wild_fire_info_player, true, true)
		--APPLY THE CORRECT FACTION EFFECT BUNDLE
		if current_season == "spring" then
			modify_faction:apply_effect_bundle(self.wild_fire_spring_effect_bundle,turns_of_wild_fire)	
			cm:set_saved_value("wild_fire_effect_bundle_season",self.wild_fire_spring_effect_bundle,"goddess_of_fire")
		elseif current_season == "summer" then
			modify_faction:apply_effect_bundle(self.wild_fire_summer_effect_bundle,turns_of_wild_fire)	
			cm:set_saved_value("wild_fire_effect_bundle_season",self.wild_fire_summer_effect_bundle,"goddess_of_fire")
		elseif current_season == "harvest" then
			modify_faction:apply_effect_bundle(self.wild_fire_harvest_effect_bundle,turns_of_wild_fire)
			cm:set_saved_value("wild_fire_effect_bundle_season",self.wild_fire_harvest_effect_bundle,"goddess_of_fire")	
		elseif current_season == "fall" then
			if game_mode=="romance" then
				modify_faction:apply_effect_bundle(self.wild_fire_fall_romance_effect_bundle,turns_of_wild_fire)
				cm:set_saved_value("wild_fire_effect_bundle_season",self.wild_fire_fall_romance_effect_bundle,"goddess_of_fire")	
			else
				modify_faction:apply_effect_bundle(self.wild_fire_fall_records_effect_bundle,turns_of_wild_fire)
				cm:set_saved_value("wild_fire_effect_bundle_season",self.wild_fire_fall_records_effect_bundle,"goddess_of_fire")	
			end			
		elseif current_season == "winter" then
			modify_faction:apply_effect_bundle(self.wild_fire_winter_effect_bundle,turns_of_wild_fire)	
			cm:set_saved_value("wild_fire_effect_bundle_season",self.wild_fire_winter_effect_bundle,"goddess_of_fire")
		end

		--Increase smouldering fire to motivate player to not use Wild Fire anymore.
		local smouldering_fire = lady_zhurong_faction:pooled_resources():resource("3k_dlc06_pooled_resource_smouldering_fire")
		if not smouldering_fire:is_null_interface() then
			context:modify_model():get_modify_pooled_resource(smouldering_fire):apply_transaction_to_factor("3k_dlc06_pooled_factor_resource_smouldering_fire_increase",1)
		end	

		--Reset flaming confinement
		local flaming_confinement = lady_zhurong_faction:pooled_resources():resource("3k_dlc06_pooled_resource_flaming_confinement")
		if not flaming_confinement:is_null_interface() then
			context:modify_model():get_modify_pooled_resource(flaming_confinement):apply_transaction_to_factor("3k_dlc06_pooled_factor_resource_flaming_confinement_increase",self.flaming_confinement_reset_value-(flaming_confinement:value()))
		end

		--ADD GODDESS OF FIRE DECAY
		if cm:saved_value_exists("turn_season", "goddess_of_fire") then
			local last_season = cm:get_saved_value("turn_season","goddess_of_fire")
			print("last_season "..last_season)
			if last_season == "spring" then
				print("last season effect "..self.wild_fire_spring_effect_bundle_decay)
				modify_faction:apply_effect_bundle(self.wild_fire_spring_effect_bundle_decay,-1)
			elseif last_season == "summer" then
				print("last season effect "..self.wild_fire_summer_effect_bundle_decay)
				modify_faction:apply_effect_bundle(self.wild_fire_summer_effect_bundle_decay,-1)
			elseif last_season == "harvest" then
				print("last season effect "..self.wild_fire_harvest_effect_bundle_decay)
				modify_faction:apply_effect_bundle(self.wild_fire_harvest_effect_bundle_decay,-1)
			elseif last_season == "fall" then
				if game_mode=="romance" then
					print("last season effect "..self.wild_fire_fall_romance_effect_bundle_decay)
					modify_faction:apply_effect_bundle(self.wild_fire_fall_romance_effect_bundle_decay,-1)
				else
					print("last season effect "..self.wild_fire_fall_records_effect_bundle_decay)
					modify_faction:apply_effect_bundle(self.wild_fire_fall_records_effect_bundle_decay,-1)
				end
			elseif last_season == "winter" then
				print("last season effect "..self.wild_fire_winter_effect_bundle_decay)
				modify_faction:apply_effect_bundle(self.wild_fire_winter_effect_bundle_decay,-1)
			end
		end	

		--WILD FIRE EVENT
		core:trigger_event("LadyZhurongWildFire")

		--ARMY
		--ARMIES NEED A SEPERATE EFFECT BUNDLE APPLIED, SO THE FIRE UI-EFFECTS CAN BE SEEN
		local military_force = cm:query_faction(self.faction_key):military_force_list()
		self:apply_wild_fire_effect_armies(military_force,"Add_wild_fire");
		
		--OPPONENTS
		--When "Wild Fire" is activated, then the players that are at war with Lady Zhurong should be informed of her faction feature. 
		self:add_fire_wild_fire_incident_for_opponents(self.wild_fire_info_opponent);
	end
end

--Adds the specific Lady Zhurong incidents to be fired for her opponents
function lady_zhurong_features:add_fire_wild_fire_incident_for_opponents(event_key)
	local humans = cm:get_human_factions();
	local lady_zhurong_faction = cm:query_faction(self.faction_key)
	
	--If a human faction is at war with Lady Zhurong when "Wild Fire" is activated, inform them of the incident
	for i, human in ipairs(humans) do
		local human_faction = cm:query_faction(human)

		if lady_zhurong_faction:has_specified_diplomatic_deal_with("treaty_components_war", human_faction) then
			cm:trigger_incident(human_faction, event_key, true, true)
		end
	end;
end;

--REMOVE Lady Zhurong's Wild Fire based on what the season is
function lady_zhurong_features:remove_wild_fire(context,removed_wild_fire_self)
	--Get the season that Wild Fire was activated
	if cm:saved_value_exists("wild_fire_season", "goddess_of_fire") then
		local wild_fire_season = cm:get_saved_value("wild_fire_season","goddess_of_fire")	
		local modify_faction = context:modify_model():get_modify_faction(cm:query_faction(self.faction_key))
		cm:set_saved_value("wild_fire_active", false,"goddess_of_fire")
		cm:set_saved_value("wild_fire_turns_left",-1,"goddess_of_fire")
		--Update UI
		self:update_ui_wild_fire_is_active() 
		self:update_ui_wild_fire_season()


		--APPLY BURNOUT EFFECT BUNDLE
		local burn_out_duration = self.burn_out_duration
		if not removed_wild_fire_self then burn_out_duration=burn_out_duration+1 end
		modify_faction:apply_effect_bundle(self.wild_fire_burn_out_effect_bundle,self.burn_out_duration)	
		--If it's the players first time to "Burnout", then explain what it's.
		if cm:query_faction(self.faction_key):is_human() and not cm:has_incident_fired_for_faction(self.faction_key,self.wild_fire_info_burnout_first_time) then
			cm:trigger_incident(cm:query_faction(self.faction_key), self.wild_fire_info_burnout_first_time, true, true)
		end

		--REMOVE WILD_FIRE EFFECT BUNDLE
		if cm:saved_value_exists("wild_fire_season", "goddess_of_fire") then
			print("wild_fire_effect_bundle_season "..cm:get_saved_value("wild_fire_effect_bundle_season","goddess_of_fire"))
			modify_faction:remove_effect_bundle(cm:get_saved_value("wild_fire_effect_bundle_season","goddess_of_fire"))
		end

		local last_season = cm:get_saved_value("turn_season","goddess_of_fire")
		local game_mode = "romance"
		if cm:saved_value_exists("campaign_game_mode", "goddess_of_fire") then
			game_mode = cm:get_saved_value("campaign_game_mode","goddess_of_fire")
		end	

		--REMOVE GODDESS OF FIRE DECAY
		if last_season == "spring" then
			modify_faction:remove_effect_bundle(self.wild_fire_spring_effect_bundle_decay)
		elseif last_season == "summer" then
			modify_faction:remove_effect_bundle(self.wild_fire_summer_effect_bundle_decay)
		elseif last_season == "harvest" then
			modify_faction:remove_effect_bundle(self.wild_fire_harvest_effect_bundle_decay)
		elseif last_season == "fall" then
			if game_mode=="romance" then
				modify_faction:remove_effect_bundle(self.wild_fire_fall_romance_effect_bundle_decay)
			else
				modify_faction:remove_effect_bundle(self.wild_fire_fall_records_effect_bundle_decay)
			end
		elseif last_season == "winter" then
			modify_faction:remove_effect_bundle(self.wild_fire_winter_effect_bundle_decay)
		end

		--RESET POOLED RESOURCE BACK TO ZERO
		local goddess_of_fire = cm:query_faction(self.faction_key):pooled_resources():resource("3k_dlc06_pooled_resource_goddess_of_fire")--SET POOLED RESOURCE TO BE 0
		context:modify_model():get_modify_pooled_resource(goddess_of_fire):apply_transaction_to_factor("3k_dlc06_pooled_factor_resource_goddess_of_fire_seasons",-goddess_of_fire:maximum_value())
		self:update_ui_wild_fire_can_be_active() --Update UI that Wild Fire can't be activated

		--Reset smouldering fire
		local smouldering_fire = cm:query_faction(self.faction_key):pooled_resources():resource("3k_dlc06_pooled_resource_smouldering_fire")
		if not smouldering_fire:is_null_interface() then
			context:modify_model():get_modify_pooled_resource(smouldering_fire):apply_transaction_to_factor("3k_dlc06_pooled_factor_resource_smouldering_fire_increase",self.smouldering_fire_reset_value-(smouldering_fire:value()))
		end

		--ARMY
		--ARMIES NEED A SEPERATE EFFECT BUNDLE APPLIED, SO THE FIRE UI-EFFECTS CAN BE SEEN
		local military_force = cm:query_faction(self.faction_key):military_force_list()
		self:apply_wild_fire_effect_armies(military_force,"Remove_wild_fire_Add_kindle");
	end
end

--Apply the season effect-bundle on Lady Zhurong's faction
function lady_zhurong_features:apply_season_effect(modify_faction)	
	--Apply the next season effect
	if cm:saved_value_exists("turn_season", "goddess_of_fire") then
		local last_season = cm:get_saved_value("turn_season","goddess_of_fire")
		local game_mode = "romance"
		if cm:saved_value_exists("campaign_game_mode", "goddess_of_fire") then
			game_mode = cm:get_saved_value("campaign_game_mode","goddess_of_fire")
		end	
		local wild_fire_activated = false
		if cm:saved_value_exists("wild_fire_active", "goddess_of_fire") then
			wild_fire_activated = cm:get_saved_value("wild_fire_active","goddess_of_fire")
		end

		if last_season == "spring" then
			cm:set_saved_value("turn_season", "summer","goddess_of_fire")
			modify_faction:remove_effect_bundle(self.spring_effect_bundle)
			modify_faction:apply_effect_bundle(self.summer_effect_bundle,-1)
			if wild_fire_activated then
				modify_faction:remove_effect_bundle(self.wild_fire_spring_effect_bundle_decay)
				modify_faction:apply_effect_bundle(self.wild_fire_summer_effect_bundle_decay,-1)
			end
		elseif last_season == "summer" then
			cm:set_saved_value("turn_season", "harvest","goddess_of_fire")
			modify_faction:remove_effect_bundle(self.summer_effect_bundle)
			modify_faction:apply_effect_bundle(self.harvest_effect_bundle,-1)
			if wild_fire_activated then
				modify_faction:remove_effect_bundle(self.wild_fire_summer_effect_bundle_decay)
				modify_faction:apply_effect_bundle(self.wild_fire_harvest_effect_bundle_decay,-1)
			end
		elseif last_season == "harvest" then
			cm:set_saved_value("turn_season", "fall","goddess_of_fire")
			modify_faction:remove_effect_bundle(self.harvest_effect_bundle)
			if game_mode=="romance" then
				modify_faction:apply_effect_bundle(self.fall_effect_bundle_romance,-1)
				if wild_fire_activated then
					modify_faction:remove_effect_bundle(self.wild_fire_harvest_effect_bundle_decay)
					modify_faction:apply_effect_bundle(self.wild_fire_fall_romance_effect_bundle_decay,-1)
				end
			else
				modify_faction:apply_effect_bundle(self.fall_effect_bundle_records,-1)
				if wild_fire_activated then
					modify_faction:remove_effect_bundle(self.wild_fire_harvest_effect_bundle_decay)
					modify_faction:apply_effect_bundle(self.wild_fire_fall_records_effect_bundle_decay,-1)
				end
			end
		elseif last_season == "fall" then
			cm:set_saved_value("turn_season", "winter","goddess_of_fire")
			if game_mode=="romance" then
				modify_faction:remove_effect_bundle(self.fall_effect_bundle_romance)
				if wild_fire_activated then
					modify_faction:remove_effect_bundle(self.wild_fire_fall_romance_effect_bundle_decay)
					modify_faction:apply_effect_bundle(self.wild_fire_winter_effect_bundle_decay,-1)
				end
			else
				modify_faction:remove_effect_bundle(self.fall_effect_bundle_records)
				if wild_fire_activated then
					modify_faction:remove_effect_bundle(self.wild_fire_fall_records_effect_bundle_decay)
					modify_faction:apply_effect_bundle(self.wild_fire_winter_effect_bundle_decay,-1)
				end
			end
			modify_faction:apply_effect_bundle(self.winter_effect_bundle,-1)
		elseif last_season == "winter" then
			cm:set_saved_value("turn_season", "spring","goddess_of_fire")
			modify_faction:remove_effect_bundle(self.winter_effect_bundle)
			modify_faction:apply_effect_bundle(self.spring_effect_bundle,-1)
			if wild_fire_activated then
				modify_faction:remove_effect_bundle(self.wild_fire_winter_effect_bundle_decay)
				modify_faction:apply_effect_bundle(self.wild_fire_spring_effect_bundle_decay,-1)
			end
		end

	--First time that the season is saved. Only for turn 1 of campaign.
	else
		if cm:query_model():campaign_name() == "3k_main_campaign_map" then
			cm:set_saved_value("turn_season", "harvest","goddess_of_fire")
			modify_faction:apply_effect_bundle(self.harvest_effect_bundle,-1)
		elseif cm:query_model():campaign_name() == "3k_dlc04_start_pos" then
			cm:set_saved_value("turn_season", "winter","goddess_of_fire")
			modify_faction:apply_effect_bundle(self.winter_effect_bundle,-1)
		elseif cm:query_model():campaign_name() == "3k_dlc05_start_pos" then
			cm:set_saved_value("turn_season", "harvest","goddess_of_fire")
			modify_faction:apply_effect_bundle(self.harvest_effect_bundle,-1)
		elseif cm:query_model():campaign_name() == "8p_start_pos" then
			cm:set_saved_value("turn_season", "summer","goddess_of_fire")
			modify_faction:apply_effect_bundle(self.summer_effect_bundle,-1)
		else
			cm:set_saved_value("turn_season", "harvest","goddess_of_fire")
			modify_faction:apply_effect_bundle(self.harvest_effect_bundle,-1)
		end
	end
	
	--Inform the UI about what season it currently is
	self:update_ui_wild_fire_season()
end

--Based on the action, add or remove the correct effect-bundle from the armies of the faction
function lady_zhurong_features:apply_wild_fire_effect_armies(military_force_list,action)
	if not military_force_list:is_empty() then
		if action=="Add_wild_fire" then
			for i =0,military_force_list:num_items()-1 do
				self:apply_wild_fire_effect_military_force(cm:modify_model():get_modify_military_force(military_force_list:item_at(i)),"Add_wild_fire",self.wild_fire_duration)
			end
		elseif action=="Remove_wild_fire_Add_kindle" then
			for i =0,military_force_list:num_items()-1 do
				self:apply_wild_fire_effect_military_force(cm:modify_model():get_modify_military_force(military_force_list:item_at(i)),"Remove_wild_fire_Add_kindle",-1)
			end
		elseif action=="Add_kindle" then
			for i =0,military_force_list:num_items()-1 do
				self:apply_wild_fire_effect_military_force(cm:modify_model():get_modify_military_force(military_force_list:item_at(i)),"Add_kindle",-1)
			end
		elseif action=="Remove_kindle" then
			for i =0,military_force_list:num_items()-1 do
				self:apply_wild_fire_effect_military_force(cm:modify_model():get_modify_military_force(military_force_list:item_at(i)),"Remove_kindle",-1)
			end
		elseif action=="Remove_all" then
			for i =0,military_force_list:num_items()-1 do
				self:apply_wild_fire_effect_military_force(cm:modify_model():get_modify_military_force(military_force_list:item_at(i)),"Remove_all",-1)
			end
		end
	end
end

--Based on the action, add or remove the correct effect-bundle from the specific army
function lady_zhurong_features:apply_wild_fire_effect_military_force(modify_military_force,action,turns)
	if not modify_military_force:is_null_interface() then
		if action=="Add_wild_fire" then
			modify_military_force:apply_effect_bundle(self.wild_fire_army_strong,turns)
		elseif action=="Remove_wild_fire_Add_kindle" then
			modify_military_force:remove_effect_bundle(self.wild_fire_army_strong)		
			modify_military_force:apply_effect_bundle(self.wild_fire_army_weak,turns)
		elseif action=="Add_kindle" then	
			modify_military_force:apply_effect_bundle(self.wild_fire_army_weak,turns)
		elseif action=="Remove_kindle" then	
			modify_military_force:remove_effect_bundle(self.wild_fire_army_weak)
		elseif action=="Remove_all" then	
			modify_military_force:remove_effect_bundle(self.wild_fire_army_strong)
			modify_military_force:remove_effect_bundle(self.wild_fire_army_weak)
		end
	end
end

--Based on the action, add or remove the correct effect-bundle from the factions regions
function lady_zhurong_features:apply_wild_fire_effect_regions(context)
	local regions_list = context:faction():region_list()
	if not regions_list:is_empty() then
		for i =0,regions_list:num_items()-1 do
			self:apply_wild_fire_effect_region(context:modify_model():get_modify_region(regions_list:item_at(i)))
		end
	end
end

--Based on the action, add or remove the correct effect-bundle from the specific region
--[[
function lady_zhurong_features:apply_wild_fire_effect_region(modify_region)
	if modify_region:is_null_interface() then
		--Check what special building that region has, if it dosen't have won then don't give the effect
		local region = modify_region:query_region()
		if region:building_exists("") then --Base temple
			modify_region:apply_effect_bundle(self.wild_fire_region_effect_bundle_base,self.wild_fire_duration)
		elseif region:building_exists("") then --Military temple 1
			modify_region:apply_effect_bundle(self.wild_fire_region_effect_bundle_military_1,self.wild_fire_duration)
		elseif region:building_exists("") then --Military temple 2
			modify_region:apply_effect_bundle(self.wild_fire_region_effect_bundle_military_2,self.wild_fire_duration)		
		elseif region:building_exists("") then --Construction temple 1
			modify_region:apply_effect_bundle(self.wild_fire_region_effect_bundle_construction_1,self.wild_fire_duration)		
		elseif region:building_exists("") then --Construction temple 1
			modify_region:apply_effect_bundle(self.wild_fire_region_effect_bundle_construction_2,self.wild_fire_duration)		
		elseif region:building_exists("") then --Population temple 1
			modify_region:apply_effect_bundle(self.wild_fire_region_effect_bundle_population_1,self.wild_fire_duration)		
		elseif region:building_exists("") then --Population temple 2
			modify_region:apply_effect_bundle(self.wild_fire_region_effect_bundle_population_2,self.wild_fire_duration)		
		end

	end
end

--Based on the action, add or remove the correct effect-bundle from the specific region
function lady_zhurong_features:remove_wild_fire_effect_region(modify_region,effect)
	if modify_region:is_null_interface() then
		--Check what special building that region has, if it dosen't have won then don't give the effect
		local region = modify_region:query_region()
		if effect=="" then --Base temple
			modify_region:remove_effect_bundle(self.wild_fire_region_effect_bundle_base)
		elseif effect=="" then --Military temple 1
			modify_region:remove_effect_bundle(self.wild_fire_region_effect_bundle_military_1)
		elseif effect=="" then --Military temple 2
			modify_region:remove_effect_bundle(self.wild_fire_region_effect_bundle_military_2)		
		elseif effect=="" then --Construction temple 1
			modify_region:remove_effect_bundle(self.wild_fire_region_effect_bundle_construction_1)		
		elseif effect=="" then --Construction temple 1
			modify_region:remove_effect_bundle(self.wild_fire_region_effect_bundle_construction_2)		
		elseif effect=="" then --Population temple 1
			modify_region:remove_effect_bundle(self.wild_fire_region_effect_bundle_population_1)		
		elseif effect=="" then --Population temple 2
			modify_region:remove_effect_bundle(self.wild_fire_region_effect_bundle_population_2)		
		end
	end
end
--]]
---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------
----- Name:			3k_campaign_ancillaries_master_craftsmen.lua
----- Description: 	Three Kingdoms system to allow certain buildings to spawn ancillaries to give to their owner.
-----				Note: This system only supports one spawning building per region, due to the way the data is serialised. Changing this will likely affect saved games.
---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------

output("3k_campaign_ancillaries_master_craftsmen.lua: Loading");

cm:add_first_tick_callback(function() master_craftsmen:initialise() end); --Self register function

---------------------------------------------------------------------------------------------------------
----- Data
---------------------------------------------------------------------------------------------------------
master_craftsmen = 
{
	debug_mode = false,
	console_id = "[MASTER CRAFTSMEN]";
	start_round_min = 2, -- The first round a master craftsmen can trigger
	start_round_max = 3,
	trigger_turns_by_tier = { --the amount of time between instances of spawning based on the 3 tiers.
		{15, 20},
		{10, 15},
		{5, 10}
	},
	default_trigger_key = "default", -- If the region owner's subculture is not found, then we pick this as a default.
	trigger_data = { -- Holds all the generic spawning data for the ancillary pools. Should NOT be serialsied
	-- ANIMAL TRAINERS
		["3k_resource_metal_craftsmen_animal_1"] = {
			["default"] = {event_key = "3k_main_master_craftsmen_animal_trainer_lvl01_01_incident_scripted", ceo_trigger_key = "3k_main_ceo_trigger_craftsmen_animal_1"};
		},
		["3k_resource_metal_craftsmen_animal_2"] = {
			["default"] = {event_key = "3k_main_master_craftsmen_animal_trainer_lvl02_01_incident_scripted", ceo_trigger_key = "3k_main_ceo_trigger_craftsmen_animal_2"};
		},
		["3k_resource_metal_craftsmen_animal_3"] = {
			["default"] = {event_key = "3k_main_master_craftsmen_animal_trainer_lvl03_01_incident_scripted", ceo_trigger_key = "3k_main_ceo_trigger_craftsmen_animal_3"};
		},
		["3k_resource_metal_craftsmen_animal_bandit_1"] = {
			["default"] = {event_key = "3k_main_master_craftsmen_animal_trainer_lvl01_01_incident_scripted", ceo_trigger_key = "3k_main_ceo_trigger_craftsmen_animal_1"};
		},
		["3k_resource_metal_craftsmen_animal_bandit_2"] = {
			["default"] = {event_key = "3k_main_master_craftsmen_animal_trainer_lvl02_01_incident_scripted", ceo_trigger_key = "3k_main_ceo_trigger_craftsmen_animal_2"};
		},
		["3k_resource_metal_craftsmen_animal_bandit_3"] = {
			["default"] = {event_key = "3k_main_master_craftsmen_animal_trainer_lvl03_01_incident_scripted", ceo_trigger_key = "3k_main_ceo_trigger_craftsmen_animal_3"};
		},
	
	-- ARMOUR MAKERS
		["3k_resource_metal_craftsmen_armour_1"] = {
			["default"] = {event_key = "3k_main_master_craftsmen_armourmaker_lvl01_01_incident_scripted", ceo_trigger_key = "3k_main_ceo_trigger_craftsmen_armour_1"};
			["3k_main_subculture_yellow_turban"] = {event_key = nil, ceo_trigger_key = nil}; -- Nil values will mean this is ignored.
			["3k_dlc06_subculture_nanman"] = {event_key = "3k_dlc06_master_craftsmen_armourmaker_lvl01_01_nanman_incident_scripted", ceo_trigger_key = "3k_dlc06_ceo_trigger_craftsmen_armour_nanman_1"};
		},
		["3k_resource_metal_craftsmen_armour_2"] = {
			["default"] = {event_key = "3k_main_master_craftsmen_armourmaker_lvl02_01_incident_scripted", ceo_trigger_key = "3k_main_ceo_trigger_craftsmen_armour_2"};
			["3k_main_subculture_yellow_turban"] = {event_key = nil, ceo_trigger_key = nil}; -- Nil values will mean this is ignored.
			["3k_dlc06_subculture_nanman"] = {event_key = "3k_dlc06_master_craftsmen_armourmaker_lvl02_01_nanman_incident_scripted", ceo_trigger_key = "3k_dlc06_ceo_trigger_craftsmen_armour_nanman_2"};
		},
		["3k_resource_metal_craftsmen_armour_3"] = {
			["default"] = {event_key = "3k_main_master_craftsmen_armourmaker_lvl03_01_incident_scripted", ceo_trigger_key = "3k_main_ceo_trigger_craftsmen_armour_3"};
			["3k_main_subculture_yellow_turban"] = {event_key = nil, ceo_trigger_key = nil}; -- Nil values will mean this is ignored.
			["3k_dlc06_subculture_nanman"] = {event_key = "3k_dlc06_master_craftsmen_armourmaker_lvl03_01_nanman_incident_scripted", ceo_trigger_key = "3k_dlc06_ceo_trigger_craftsmen_armour_nanman_3"};
		},
		["3k_resource_metal_craftsmen_armour_bandit_1"] = {
			["default"] = {event_key = "3k_main_master_craftsmen_armourmaker_lvl01_01_incident_scripted", ceo_trigger_key = "3k_main_ceo_trigger_craftsmen_armour_1"};
			["3k_main_subculture_yellow_turban"] = {event_key = nil, ceo_trigger_key = nil}; -- Nil values will mean this is ignored.
			["3k_dlc06_subculture_nanman"] = {event_key = "3k_dlc06_master_craftsmen_armourmaker_lvl01_01_nanman_incident_scripted", ceo_trigger_key = "3k_dlc06_ceo_trigger_craftsmen_armour_nanman_1"};
		},
		["3k_resource_metal_craftsmen_armour_bandit_2"] = {
			["default"] = {event_key = "3k_main_master_craftsmen_armourmaker_lvl02_01_incident_scripted", ceo_trigger_key = "3k_main_ceo_trigger_craftsmen_armour_2"};
			["3k_main_subculture_yellow_turban"] = {event_key = nil, ceo_trigger_key = nil}; -- Nil values will mean this is ignored.
			["3k_dlc06_subculture_nanman"] = {event_key = "3k_dlc06_master_craftsmen_armourmaker_lvl02_01_nanman_incident_scripted", ceo_trigger_key = "3k_dlc06_ceo_trigger_craftsmen_armour_nanman_2"};
		},
		["3k_resource_metal_craftsmen_armour_bandit_3"] = {
			["default"] = {event_key = "3k_main_master_craftsmen_armourmaker_lvl03_01_incident_scripted", ceo_trigger_key = "3k_main_ceo_trigger_craftsmen_armour_3"}; --TODO NANman armour
			["3k_main_subculture_yellow_turban"] = {event_key = nil, ceo_trigger_key = nil}; -- Nil values will mean this is ignored.
			["3k_dlc06_subculture_nanman"] = {event_key = "3k_dlc06_master_craftsmen_armourmaker_lvl03_01_nanman_incident_scripted", ceo_trigger_key = "3k_dlc06_ceo_trigger_craftsmen_armour_nanman_3"};
		},

	-- WEAPON MAKERS
		["3k_resource_metal_craftsmen_weapon_1"] = {
			["default"] = {event_key = "3k_main_master_craftsmen_weaponmaster_lvl01_01_incident_scripted", ceo_trigger_key = "3k_main_ceo_trigger_craftsmen_weapon_1"};
		},
		["3k_resource_metal_craftsmen_weapon_2"] = {
			["default"] = {event_key = "3k_main_master_craftsmen_weaponmaster_lvl02_01_incident_scripted", ceo_trigger_key = "3k_main_ceo_trigger_craftsmen_weapon_2"};
		},
		["3k_resource_metal_craftsmen_weapon_3"] = {
			["default"] = {event_key = "3k_main_master_craftsmen_weaponmaster_lvl03_01_incident_scripted", ceo_trigger_key = "3k_main_ceo_trigger_craftsmen_weapon_3"};
		},
		["3k_resource_metal_craftsmen_weapon_bandit_1"] = {
			["default"] = {event_key = "3k_main_master_craftsmen_weaponmaster_lvl01_01_incident_scripted", ceo_trigger_key = "3k_main_ceo_trigger_craftsmen_weapon_1"};
		},
		["3k_resource_metal_craftsmen_weapon_bandit_2"] = {
			["default"] = {event_key = "3k_main_master_craftsmen_weaponmaster_lvl02_01_incident_scripted", ceo_trigger_key = "3k_main_ceo_trigger_craftsmen_weapon_2"};
		},
		["3k_resource_metal_craftsmen_weapon_bandit_3"] = {
			["default"] = {event_key = "3k_main_master_craftsmen_weaponmaster_lvl03_01_incident_scripted", ceo_trigger_key = "3k_main_ceo_trigger_craftsmen_weapon_3"};
		},

	--MILITARY CRAFTSMEN
		["3k_district_military_equipment_2"] = {
			["default"] = {event_key = "3k_dlc05_military_craftsmen_general_incident_scripted", ceo_trigger_key = "3k_dlc05_ceo_trigger_military_craftsmen_general"};
		},
		["3k_district_military_equipment_armour_3"] = {
			["default"] = {event_key = "3k_dlc05_military_craftsmen_armour_incident_scripted", ceo_trigger_key = "3k_dlc05_ceo_trigger_military_craftsmen_armours"};
			["3k_dlc06_subculture_nanman"] = {event_key = "3k_dlc06_military_craftsmen_armour_nanman_incident_scripted", ceo_trigger_key = "3k_dlc06_ceo_trigger_military_craftsmen_armours_nanman"};
		},
		["3k_district_military_equipment_weapons_3"] = {
			["default"] = {event_key = "3k_dlc05_military_craftsmen_weapon_incident_scripted", ceo_trigger_key = "3k_dlc05_ceo_trigger_military_craftsmen_weapons"};
		},
		["3k_district_military_equipment_ranged_3"] = {
			["default"] = {event_key = "3k_dlc05_military_craftsmen_bow_incident_scripted", ceo_trigger_key = "3k_dlc05_ceo_trigger_military_craftsmen_bows"};
		}
	};

	--[[ Holds a list of regions and the last round they spawned an ancillary.
	SHOULD be serialsied!!!
		Formed as = { {name, turns}, {name, turns}, etc. } so it's mp safe when changing.
	]]--
	region_next_trigger_round = {};
};

---------------------------------------------------------------------------------------------------------
----- Initialisers
---------------------------------------------------------------------------------------------------------


--// add_listeners()
--// setup the listeners for the system. This needs to be done super early as LoadGame is called before FirstWorldTick.
function master_craftsmen:add_listeners()

	core:add_listener(
		"master_craftsmen_region_turn_start",
		"RegionTurnStart",
		function(context)
			return self:region_has_craftsmen_building(context:region());
		end,
		function(context)
			self:update_region(context:region(), false);
		end,
		true
	);

end;


--// add_debug_listeners()
--// setup the listeners for the system. This needs to be done super early as LoadGame is called before FirstWorldTick.
function master_craftsmen:add_debug_listeners()

	-- Example: trigger_cli_debug_event master_craftsmen.trigger_update_for_faction(3k_main_faction_sun_jian, true)
	core:add_cli_listener("master_craftsmen.trigger_update_for_faction", function(faction_key, ignore_timers)
		ignore_timers = ignore_timers or false;
		self:print_output("master_craftsmen: Debug Trigger update", true);
		local query_faction = cm:query_faction(faction_key);
		if query_faction then
			-- Go through each region the faction owns, finding the slots which have valid buildings and try and tirgger them.
			query_faction:region_list():filter(function(region) return self:region_has_craftsmen_building(region) end):foreach(function(region)
				self:update_region(region, ignore_timers);
			end);
		end;
	end);

	-- Example: trigger_cli_debug_event master_craftsmen.output_trigger_rounds()
	core:add_cli_listener("master_craftsmen.output_trigger_rounds", function()
		self:print_output("master_craftsmen: Outputting Trigger rounds.", true);
		inc_tab();
		for i, v in ipairs(self.region_next_trigger_round) do
			self:print_output(i .. " = " .. v[1] .. ", " .. v[2], true);
		end;
		dec_tab();
	end);

	-- Example: trigger_cli_debug_event master_craftsmen.toggle_debug()
	core:add_cli_listener("master_craftsmen.toggle_debug",function()
		self.debug_mode = not self.debug_mode;
		self:print_output("master_craftsmen: Setting debug mode to " .. tostring(self.debug_mode), true);
	end);
end;


--// initialise()
--// Sets up the system on game load.
function master_craftsmen:initialise()

	output("3k_campaign_master_craftsmen.lua: Initialise()");

	inc_tab();
	
	self:print_output("master_craftsmen:initialise(): Generating Region List");

	-- Go through every region in the world which has MC building and give them a trigger round if they don't have one.
	cm:query_model():world():region_manager():region_list():filter(function(region) return self:region_has_craftsmen_building(region) end):foreach(function(region)
		local region_name = region:name();

		region:slot_list():filter(function(slot) return self:slot_has_craftsmen_building(slot) end):foreach(function(slot)
			if not self:has_trigger_round(region_name) then
				self:print_output("master_craftsmen:update(): Found MC region with no trigger rounds, adding.");
				self:set_initial_trigger_round(region_name);
			end;
		end);
	end);

	dec_tab();

	self:add_listeners();
	self:add_debug_listeners();
end;


--// update_region()
--// Checks if the region should spawn a ceo, and manages updating timers.
function master_craftsmen:update_region(region, ignore_timers)
	ignore_timers = ignore_timers or false;

	local region_name = region:name();

	region:slot_list():filter(function(slot) return self:slot_has_craftsmen_building(slot) end):foreach(function(slot)
		local building_name = slot:building():name();
		
		-- This is to fix the bug that if the region wasn't present in startpos it'd never spawn as it didn't have a valid timer.
		if not self:has_trigger_round(region_name) then

			self:print_output("master_craftsmen:update(): Found MC region with no trigger rounds, adding.");
			self:reset_random_trigger_round(region_name, slot);

		elseif self:has_trigger_round_elapsed(slot) or ignore_timers then
			
			if slot:building():percent_health() < 100 then -- If the building is damaged, we add a turn to the timer to prevent players 'missing' their slot.
				self:set_trigger_round(region_name, self:get_trigger_round(region_name) + 1);
				self:print_output("master_craftsmen:trigger_for_building_slot(): " .. region_name .. ", " .. building_name .. ": Not able to fire due to damage. Adding a round");
				return false;
			else
				self:trigger_for_building_slot(slot);
				self:reset_random_trigger_round(region_name, slot);
			end;
			
		end;
	end);
end;


---------------------------------------------------------------------------------------------------------
----- Methods
---------------------------------------------------------------------------------------------------------

--// trigger_for_building_slot()
--// Spawn CEOs and fire events.
function master_craftsmen:trigger_for_building_slot(slot)
	local owner_subculture_key = slot:faction():subculture();
	local building_key = slot:building():name();

	local selected_trigger_data = self.trigger_data[building_key][self.default_trigger_key]; -- Use a default if we don't have a subculture.

	if self.trigger_data[building_key][owner_subculture_key] then -- Try and use subculture appropriate data if we can.
		selected_trigger_data = self.trigger_data[building_key][owner_subculture_key];
	end;

	if not selected_trigger_data then
		script_error(string.format("master_craftsmen:trigger_for_building_slot() no valid trigger data found for building_level %s and subculture %s. Does a 'default' exist for this?", building_key, owner_subculture_key))
		return false;
	end;

	-- Only fire if we have a trigger key. Allows subcultures to override the system and not spawn ceos for certain buildings.
	if selected_trigger_data.ceo_trigger_key then
		local modify_owner_faction = cm:modify_model():get_modify_faction(slot:faction());

		-- If we don't have an event or cannot fire (for example, we're an AI faction), add the CEOs directly.
		if not selected_trigger_data.event_key or not slot:faction():is_human() or not modify_owner_faction:trigger_incident(selected_trigger_data.event_key, true) then
			modify_owner_faction:ceo_management():apply_trigger(selected_trigger_data.ceo_trigger_key);
		end;

		return true;
	end;

	return false;
end;


--// faction_owns_craftsmen_region()
--// Checks if the faction owns any valid craftsmen regions.
function master_craftsmen:faction_owns_craftsmen_region(query_faction)
	return query_faction:region_list():any_of(function(region) return self:region_has_craftsmen_building(region) end);
end;


--// region_has_craftsmen_building()
--// Checks if the region owns any valid craftsmen buildings.
function master_craftsmen:region_has_craftsmen_building(query_region)

	-- Go through our valid keys and test if it matches a building in the region.
	for key, value in pairs(self.trigger_data) do
		if query_region:building_exists(key) then
			return true;
		end;
	end;

	return false;
end;


--// slot_has_craftsmen_building()
--// Works out if the slot has one of the buildings specified in the data.
function master_craftsmen:slot_has_craftsmen_building(query_slot)
	-- Check if the slot is used.
	if not query_slot:has_building() then
		return false;
	end;

	-- Check if the building in the building list.
	for key, value in pairs(self.trigger_data) do
		if query_slot:building():name() == key then
			return true;
		end;
	end;
	
	return false;
end;


--// has_trigger_round()
--// Checks if the region is valid for spawning.
function master_craftsmen:has_trigger_round(region_name)
	if not region_name then
		script_error("master_craftsmen:has_trigger_round(): Region name is null");
	end;

	-- Check if the slot is a craftsman.
	for i, v in ipairs(self.region_next_trigger_round) do	
		if region_name == v[1] then
			return true;
		end;
	end;

	return false;
end;


--// has_trigger_round_elapsed()
--// Returns true if the Master Craftsmen slot can spawn now.
--// Returns false when the slot if not a master crastsmen slot or cannot fire yet.
function master_craftsmen:has_trigger_round_elapsed(query_slot_interface)
	local building_name = query_slot_interface:building():name();
	local current_round = query_slot_interface:model():turn_number();
	local region_name = query_slot_interface:region():name();
	local owning_faction_name = query_slot_interface:faction():name();

	-- Check if slot has hit its turns required.
	if current_round < self:get_trigger_round(region_name) then
		self:print_output("master_craftsmen:has_trigger_round_elapsed(): CANNOT FIRE " .. region_name .. ", " .. building_name.. ", Owner: " .. owning_faction_name .. "- Not able to fire again. Next Round = " .. self:get_trigger_round(region_name).. ", Round = " .. current_round);
		return false;
	end;

	self:print_output("master_craftsmen:has_trigger_round_elapsed(): FIRING! " .. region_name .. ", " .. building_name .. ", Owner: " .. owning_faction_name .. ", Next Round = " .. self:get_trigger_round(region_name) .. ", Round = " .. current_round);
	return true;
end;


--// reset_random_trigger_round()
--// Sets the trigger rounds to the values assigned in the data
function master_craftsmen:reset_random_trigger_round(region_name, slot)
	local building_name = slot:building():name()

	local tier = string.sub(building_name, #building_name, #building_name)

	tier = tonumber(tier)

	if not tier or tier < 1 or tier > 3 then
		script_error(string.format("ERROR: master_craftsmen:reset_random_trigger_round() tier index for region [%s] passed is invalid. Building: [%s] Correcting it so we don't crash the LUA, but please fix the script.", region_name, building_name ))
		tier = 1
	end

	local min_rounds = self.trigger_turns_by_tier[tier][1]
	local max_rounds = self.trigger_turns_by_tier[tier][2]

	if not min_rounds or not max_rounds then
		--this error should never occur but hey it's never bad to guard against whackiness
		script_error("ERROR: master_craftsmen:reset_random_trigger_round() could not get round data from index.\n3k_campaign_ancillaries_master_craftsmen.lua")
		return;
	end

	self:set_random_trigger_round(region_name, min_rounds, max_rounds);

	self:print_output("master_craftsmen:reset_random_trigger_round(): " .. region_name .. ", Next spawn Round: " .. self:get_trigger_round(region_name));
end;


--// set_initial_trigger_round()
--// Sets the trigger rounds to the values assigned in the data
function master_craftsmen:set_initial_trigger_round(region_name)
	self:set_random_trigger_round(region_name, self.start_round_min, self.start_round_max);

	self:print_output("master_craftsmen:set_initial_trigger_round(): " .. region_name .. ", Start Round: " .. self:get_trigger_round(region_name));
end;


--// set_random_trigger_round()
--// Sets the trigger rounds between min and max.
function master_craftsmen:set_random_trigger_round(region_name, min_rounds, max_rounds)
	-- Work our the next fire round.
	local num_rounds_till_next = min_rounds;

	if min_rounds < max_rounds then
		num_rounds_till_next = cm:random_int(min_rounds, max_rounds);
	end;

	self:set_trigger_round(region_name, cm:query_model():turn_number() + num_rounds_till_next);
end;


--// set_trigger_round()
--// Sets the trigger round for the region, or adds a new one.
function master_craftsmen:set_trigger_round(region_name, round_to_set)
	if not region_name then
		script_error("master_craftsmen:set_trigger_round(): Region name is null");
	end;

	-- Update existing if we find it.
	for i, v in ipairs(self.region_next_trigger_round) do
		if v[1] == region_name then
			v[2] = round_to_set;
			return;
		end;
	end;

	-- Create new if we didn't
	self:print_output("master_craftsmen:set_trigger_round(): Adding new trigger round for region " .. region_name);
	table.insert( self.region_next_trigger_round, {region_name, round_to_set} );
end;


--// get_trigger_round()
--// Gets the trigger round for the region.
function master_craftsmen:get_trigger_round(region_name)
	if not region_name then
		script_error("master_craftsmen:get_trigger_round(): Region name is null");
	end;
	
	-- Update existing if we find it.
	for i, v in ipairs(self.region_next_trigger_round) do
		if v[1] == region_name then
			return v[2];
		end;
	end;

	return false;
end;


--// print_output()
--// Prints the output to the console.
function master_craftsmen:print_output(string, show_if_debug_disabled)
	if show_if_debug_disabled or self.debug_mode then
		out.traits(self.console_id .. string);
	end;
end;


---------------------------------------------------------------------------------------------------------
----- SAVE/LOAD
---------------------------------------------------------------------------------------------------------
function master_craftsmen:register_save_load_callbacks()
	cm:add_saving_game_callback(
		function(saving_game_event)
			cm:save_named_value("master_craftsmen_trigger_rounds", self.region_next_trigger_round);
		end
	);


	cm:add_loading_game_callback(
		function(loading_game_event)
			local load_tbl =  cm:load_named_value("master_craftsmen_trigger_rounds", self.region_next_trigger_round);

			self.region_next_trigger_round = load_tbl;
		end
	);
end;

master_craftsmen:register_save_load_callbacks();
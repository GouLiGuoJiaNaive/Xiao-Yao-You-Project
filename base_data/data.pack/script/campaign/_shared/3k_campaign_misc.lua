---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------
----- Name:			3k_campaign_misc.lua
----- Description: 	A storing place for little project, but not campaign specific helper scripts in a neat fashion.
---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------

output("3k_campaign_misc.lua :: Loaded");

misc = {};

-- #region Free Forces
--[[
***********************************************************************************************************
***********************************************************************************************************
FREE FORCES
***********************************************************************************************************
***********************************************************************************************************
]]--
misc.free_forces = {};
---------------------------------------------------------------
--	Adds listeners for managing the free forces effect bundle
---------------------------------------------------------------
function misc.free_forces:initialise_effect_bundle_listeners()

	self:effect_bundle_activation_listener();
	self:effect_bundle_deactivation_listener();

end

---------------------------------------------------------------
--	Listeners for attaching or removing the bundle
---------------------------------------------------------------
function misc.free_forces:effect_bundle_activation_listener()
	core:add_listener(
		"FreeForcesEffectBundleActivationListener",
		"FactionTurnStart",
		function(context) 
			local current_faction = context:faction();
			local current_faction_name = current_faction:name();

			-- if we have a saved value AND we're already regionless, exit.
			if cm:saved_value_exists( "is_regionless", current_faction_name ) and cm:get_saved_value( "is_regionless", current_faction_name ) then
				return false;
			end;

			if not current_faction:region_list() then 
				return false;
			end;

			local region_count = current_faction:region_list():num_items();

			return region_count == 0;
		end,
		function(context) 
			local current_faction_name = context:faction():name();

			out.design("[560] free forces effect bundle - Faction " .. current_faction_name .. " has no regions. Applying bundle.");
			
			cm:set_saved_value( "is_regionless", true, current_faction_name );
			cm:apply_effect_bundle("3k_dlc04_effect_bundle_free_force", current_faction_name, 0);
		end,
		true
	);
end;

function misc.free_forces:effect_bundle_deactivation_listener()
	core:add_listener(
		"FreeForcesEffectBundleDeactivationListener",
		"FactionTurnEnd",
		function(context) 
			local current_faction = context:faction();
			local current_faction_name = current_faction:name();

			-- Check if we've never been regionless OR we're not currently regionless, then ignore.
			if not cm:saved_value_exists( "is_regionless", current_faction_name ) or not cm:get_saved_value( "is_regionless", current_faction_name ) then
				return false;
			end;

			if not current_faction:region_list() then 
				return false;
			end;

			local region_count = current_faction:region_list():num_items();

			return region_count > 0;
		end,
		function(context) 
			local current_faction_name = context:faction():name();

			out.design("[560] free forces effect bundle - Faction " .. current_faction_name .. " has at least 1 region. Removing bundle.");
			
			cm:set_saved_value( "is_regionless", false, current_faction_name );
			cm:remove_effect_bundle("3k_dlc04_effect_bundle_free_force", current_faction_name );
		end,
		true
	);
end;
-- #endregion

-- #region Rebel Armies
--[[
***********************************************************************************************************
***********************************************************************************************************
Rebel Armies
***********************************************************************************************************
***********************************************************************************************************
]]--
misc.rebel_armies = {};
function misc.rebel_armies:initialise_effect_bundle_listeners()
	self:effect_bundle_activation_listener();
end

function misc.rebel_armies:effect_bundle_activation_listener()
	core:add_listener(
		"RebelArmiesEffectBundleActivationListener",
		"MilitaryForceCreated",
		function(context) 
			return not context:military_force_created():is_null_interface() and context:military_force_created():faction():is_rebel();
		end,
		function(context) 
			local modify_force = cm:modify_military_force(context:military_force_created());
			local force_cqi = context:military_force_created():command_queue_index();

			modify_force:apply_effect_bundle("3k_dlc04_effect_bundle_rebel_force", 0);
			modify_force:start_mustering(); -- Restarting mustering as bonuses are calculated when the force spawns.

			out.design("[561] rebel forces effect bundle - Force cqi [" .. tostring( force_cqi ) .. "] granted rebel effect bundle.");
		end,
		true
	);
end;
-- #endregion




function misc:is_transient_character(query_character)

	if query_character:is_null_interface() then
		script_error("is_transient_force_commander() Passed in quesy character is a null interface.")
		return false;
	end;

	return query_character:character_type("castellan") -- Castellens are not full characters
		or query_character:character_type("colonel") -- Colonels are temporary characters.
		or query_character:character_subtype("3k_colonel") -- Colonels are temporary characters who lead a force.
end;
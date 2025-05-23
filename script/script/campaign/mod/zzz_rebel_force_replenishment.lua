function z_rebel_armies_fix()
	core:add_listener(
		"RebelArmiesEffectBundleActivationListener",
		"MilitaryForceCreated",
		function(context) 
			return not context:military_force_created():is_null_interface() and (context:military_force_created():faction():is_rebel() or context:military_force_created():faction():name() == "3k_main_faction_yellow_turban_generic"  or context:military_force_created():faction():name() == "3k_main_faction_han_empire_separatists");
		end,
		function(context) 
			local modify_force = cm:modify_military_force(context:military_force_created());
			modify_force:apply_effect_bundle("3k_dlc04_effect_bundle_rebel_force", 0);
			modify_force:start_mustering();
		end,
		true
	);
end;

cm:add_first_tick_callback(function() z_rebel_armies_fix() end);
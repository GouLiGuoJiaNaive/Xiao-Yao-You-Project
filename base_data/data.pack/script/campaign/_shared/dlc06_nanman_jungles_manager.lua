---------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------
----- Name:			dlc06_nanman_jungles_manager.lua
----- Author:       Matthew Perkins
----- Description:  This script handles the effects applied when in Nanman Regions (Yunnan, Jianning and Yongchang)
---------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------

output("dlc06_nanman_jungles_manager.lua: Loading");

-- Don't load in campaigns which don't require it.
if cm.name == "ep_eight_princes" then
	output("dlc06_nanman_jungles_manager.lua: Not loaded in this campaign.");
	return;
end;

cm:add_first_tick_callback(function() dlc06_nanman_jungles_manager:Initialise() end) --self register function

-- Define jungle manager
dlc06_nanman_jungles_manager = {
	debug_mode = false;
	system_id = "dlc06_nanman_jungles_manager - ";
	
	-- effect bundles	
	han_bundle = "3k_dlc06_effect_bundle_region_jungle_han";
	nan_bundle = "3k_dlc06_effect_bundle_region_jungle_nanman";

	-- list of "nanman" regions
	nanman_regions = {
		"3k_dlc06_yunnan_capital",
		"3k_dlc06_yunnan_resource_1",
		"3k_dlc06_yunnan_resource_2",
		"3k_main_jianning_capital",
		"3k_main_jianning_resource_1",
		"3k_main_jianning_resource_2",
		"3k_dlc06_jianning_resource_3",
		"3k_dlc06_yongchang_capital",
		"3k_dlc06_yongchang_resource_1",
		"3k_main_zangke_capital",
		"3k_main_zangke_resource_1",
		"3k_main_zangke_resource_2",
		"3k_dlc06_jiaozhi_resource_3",
		"3k_main_jiangyang_resource_2",
		"3k_main_fuling_capital",
		"3k_main_fuling_resource_1"
	}
}

function dlc06_nanman_jungles_manager:Initialise() -- initialise jungle manager

	-- Enables more verbose debugging.
	-- Example: trigger_cli_debug_event dlc06_nanman_jungles_manager.enable_debug()
	core:add_cli_listener("dlc06_nanman_jungles_manager.enable_debug",
		function()
			self.debug_mode = true;
		end
	);

	core:add_listener(
		"FactionTurnStartJungles_apply_bundles_nanman", -- Unique handle
		"FactionTurnStart", -- Campaign Event to listen for
		function(context) -- Listener condition
			return context:faction():subculture() == "3k_dlc06_subculture_nanman"; -- return Nanman subculture factions
		end,
		function(context)
			context:faction():military_force_list():foreach(
				function(query_force)
					local modify_force = cm:modify_military_force(query_force);
					if self:should_apply_jungle_effect_bundle_to_force(query_force) and not query_force:has_effect_bundle(self.nan_bundle) then 
						
						-- Output is set to debug mode only in case it's spammy
						self:print("Applying Nanman bundle to force with CQI: "..query_force:command_queue_index(), true);	
						modify_force:apply_effect_bundle(self.nan_bundle, -1)

                        -- if forces are in Nanman regions and don't have the effect bundle, apply it

					elseif not self:should_apply_jungle_effect_bundle_to_force(query_force) 
					and query_force:has_effect_bundle(self.nan_bundle) then 
						
						-- Output is set to debug mode only in case it's spammy
						self:print("Removing Nanman bundle from force with CQI: "..query_force:command_queue_index(), true);
						modify_force:remove_effect_bundle(self.nan_bundle);

						-- if forces are not in Nanman regions and have the effect bundle, remove it
					end;
				end
			)
		end,
		true
	);

	core:add_listener(
		"FactionTurnStartJungles_apply_bundles_han", -- Unique handle
		"FactionTurnStart", -- Campaign Event to listen for
		function(context) -- Listener condition
			return context:faction():subculture() ~= "3k_dlc06_subculture_nanman"; -- return Non-Nanman subculture factions
		end,
		function(context)
			context:faction():military_force_list():foreach(
				function(query_force)
					local modify_force = cm:modify_military_force(query_force);
					if self:should_apply_jungle_effect_bundle_to_force(query_force) and not query_force:has_effect_bundle(self.han_bundle) then

						-- Output is set to debug mode only in case it's spammy
						self:print("Applying Han bundle to force with CQI: "..query_force:command_queue_index(), true);
						modify_force:apply_effect_bundle(self.han_bundle, -1)

						-- if forces are in Nanman regions and don't have the effect bundle, apply it
												
					elseif not self:should_apply_jungle_effect_bundle_to_force(query_force)
					and query_force:has_effect_bundle(self.han_bundle) then	
						
						-- Output is set to debug mode only in case it's spammy
						self:print("Removing Han bundle from force with CQI: "..query_force:command_queue_index(), true);
						modify_force:remove_effect_bundle(self.han_bundle);

						-- if forces are not in Nanman regions and have the effect bundle, remove it						
					end;
				end
			)
		end,
		true
	);	

end


function dlc06_nanman_jungles_manager:should_apply_jungle_effect_bundle_to_force(force) -- define function to call every turn start
	if not force:has_general() or not force:general_character():has_region() then -- return false if a character is not in a region, or has no army
		return false;
	end;
	local region = force:general_character():region(); 
	for i, region_key in ipairs(self.nanman_regions) do -- return true if a character with an army is in any of the nanman_regions
		if region:name() == region_key then
			return true;
		end;
	end;

	return false; -- if not in nanman_regions, also return false
end;

--- @function print
--- @desc Prints output to the console. For debugging functionality only
--- @p [opt=false] string The message to output
--- @p [opt=true] bool Should this only fire if the user has debug mode enabled.
--- @return nil
function dlc06_nanman_jungles_manager:print(string, opt_debug_only)
	if opt_debug_only and not self.debug_mode then
		return;
	end;

	out.design(self.system_id .. string);
end;
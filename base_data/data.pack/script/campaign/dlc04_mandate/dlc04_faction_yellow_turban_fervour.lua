---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------
----- Name:			Yellow Turban Fervour
----- Description: 	Controls the yellow turban growth/spread around the map.
---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------

out("dlc04_faction_yellow_turban_fervour.lua: Loading");



--***********************************************************************************************************
--***********************************************************************************************************
-- VARIABLES
--***********************************************************************************************************
--***********************************************************************************************************



yt_fervour = {};
yt_fervour.is_debug = false;
yt_fervour.system_id = "[305] YT Fervour - ";
yt_fervour.resource_key = "3k_dlc04_pooled_resource_fervour_regional";


--***********************************************************************************************************
--***********************************************************************************************************
-- LISTENERS
--***********************************************************************************************************
--***********************************************************************************************************



function yt_fervour:initialise()
	-- Example: trigger_cli_debug_event fervour.toggle_debug()
	core:add_cli_listener("fervour.toggle_debug",
		function(region_key, amount)
			self.is_debug = not self.is_debug;
			self:print("Debug print = " .. tostring(self.is_debug));
		end
	);

	-- Example: trigger_cli_debug_event fervour.apply_region_resource(region_key,resource_amount)
	core:add_cli_listener("fervour.apply_region_resource", 
		function(region_key, amount)
			local region = cm:query_region(region_key);
			if not region or region:is_null_interface() then
				script_error("region [" .. region_key .. "] does not exist");
				return;
			end;

			self:apply_resource_effect(region_key, "3k_dlc04_pooled_factor_fervour_regional_fervour", amount)
		end
	);

	-- Example: trigger_cli_debug_event fervour.disable()
	core:add_cli_listener("fervour.disable",
		function()
			self:disable();
		end
	);

	-- Don't establish listeners if the system is disabled.
	if not yt_fervour:is_active() then
		self:print("fervour system is disabled. Not starting listeners.");
		return false;
	end;

	self:print("Establishing listeners.");

	
	-- Listener to disable the regional fervour pooled resources.
	core:add_listener(
		self.resource_key .. "disable_listener",
		"DLC04_MandateOfHeavenWarFinished_HanVictory",
		true,
		function(context)
			self:print("DISABLING POOLED REGIONAL FERVOUR RESOURCES");
			self:disable();
		end,
		false
	);
end;




--***********************************************************************************************************
--***********************************************************************************************************
-- UTILS
--***********************************************************************************************************
--***********************************************************************************************************



function yt_fervour:new_game()
	self:enable();
end;

function yt_fervour:enable(enable_resource)
	cm:set_saved_value("is_active", true, "yt_fervour" );

	-- Enable the pooled resource, and its UI display.
	if enable_resource then
		cm:enable_regional_pooled_resource(self.resource_key, nil);
	end;
end;

function yt_fervour:disable()
	cm:set_saved_value("is_active", false, "yt_fervour" );

	-- Disable the pooled resource, and its UI display.
	cm:modify_model():get_modify_episodic_scripting():add_event_restricted_pooled_resource_record(self.resource_key);
end;

function yt_fervour:is_active()
	return cm:get_saved_value("is_active", "yt_fervour");
end;

function yt_fervour:get_sum_value()
	local regions = cm:query_model():world():region_manager():region_list();
	local total_val = 0;
	for i = 0, regions:num_items() - 1 do
		local resource = cm:get_regional_pooled_resource(self.resource_key, regions:item_at(i):name());

		if resource then
			total_val = total_val + resource:value();
		end;
	end;

	return total_val;
end;

function yt_fervour:are_yt_factions_dead()
	local factions = {
		"3k_dlc04_faction_zhang_jue",
		"3k_dlc04_faction_zhang_liang",
		"3k_dlc04_faction_zhang_bao"
	};

	for i, faction in ipairs(factions) do
		local q_faction = cm:query_faction(faction);
		if q_faction and not q_faction:is_null_interface() and not q_faction:is_dead() then
			return false;
		end;
	end;

	return true;
end;

function yt_fervour:apply_resource_effect(region_key, factor, amount)
	local region = cm:modify_region(region_key);

	if not region or region:is_null_interface() then
		script_error("Region doesn't exist");
		return false;
	end;

	local pr_modify = cm:modify_model():get_modify_pooled_resource_manager( region:query_region():pooled_resources() );

	if not pr_modify or pr_modify:is_null_interface() then
		self:print("yt fervour.lua: Cannot find pooled resource manager for region [" .. region_key .. "]");
		return false;
	end;

	local resource = pr_modify:resource(self.resource_key)

	if not resource or resource:is_null_interface() then
		self:print("yt fervour.lua: Cannot find fervour resource for region [" .. region_key .. "]");
		return false;
	end;

	resource:apply_transaction_to_factor(factor, amount);
	return true;
end;

-- Function to print to the console. Wrapps up functionality to there is a singular point.
function yt_fervour:print(string, debug_only)
	if not self.is_debug and debug_only then
		return false;
	end;

	out.design(self.system_id .. string);
end;
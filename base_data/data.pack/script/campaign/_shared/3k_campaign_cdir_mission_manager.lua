---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------
----- Name:			3k_campaign_cdir_mission_manager.lua
----- Description: 	Three Kingdoms system to manage missions in both single and multipler. Replaces the old historical, tutorial and progression mission scripts.
---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------

cm:add_first_tick_callback(function() cdir_mission_manager:initialise() end);

out("3k_campaign_cdir_mission_manager.lua: Loading");

cdir_mission_manager = {
	system_id = "[250] cdir_mission_manager - ";
	current_turn_number = nil,
	is_turn_overriden = false,
	debug_ignore_delays = false
};


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Usage Examples
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[
-- A Dilemma
cdir_mission_manager:start_dilemma_db_listener(
	"key", --faction_key
	"key", --event_key
	"key", --trigger_event
	function(context) 
		return true 
	end, --listener_condition
	false, --fire_once
	"eventtofire", --completion_event
	"eventtofire", --failure_event
	false, -- delay_start
	nil, -- on trigger callback
	"choice_one", -- choice one event
	"choice_two", -- choice two event
	"choice_three", -- choice three event
	"choice_four" -- choice four event
);

-- An incident
cdir_mission_manager:start_incident_db_listener(
	"faction_key", -- faction_key 
	"event_key", -- event_key 
	"trigger_event", -- trigger event 
	function(context)
		return true
	end, --listener condition
	false, --fire_once
	"completion_event", -- completion event 
	"failure_event", -- failure event
	false, -- delay_start
	nil -- on trigger callback
);

-- A mission
cdir_mission_manager:start_mission_db_listener(
	"faction_key", -- faction_key 
	"event_key", -- event_key 
	"trigger_event", -- trigger event 
	function(context)
		return true
	end, --listener condition
	false, --fire_once
	"completion_event", -- completion event 
	"failure_event", -- failure event
	false, -- delay_start
	nil -- on trigger callback
);

-- A scripted mission
cdir_mission_manager:start_mission_listener(
	"faction_key", -- faction_key
	"event_key", -- event_key
	"DESTROY_FACTION", -- objective
    { 
        "faction 3k_main_faction_tao_qian"
    }, -- conditions (single string or table of strings)
	{ 
        "effect_bundle{bundle_key 3k_main_historical_mission_payload_01;turns 5;}"
    }, -- mission_rewards
	"trigger_event", --trigger_event
	function(context)
		return true
	end, --listener_condition 
	false, --fire_once
	"completion_event", -- completion event 
	"failure_event" -- failure event 
	--optional_mission_issuer
);
]]--



------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- UTILS
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Returns the CQI of the nearest enemy force.
local function l_get_cqi_of_nearest_enemy(faction_key, enemy_faction_key)
    local faction_leader = cm:query_faction(faction_key):faction_leader();

    return cm:get_closest_general_to_position_from_faction(enemy_faction_key:gsub("faction ", ""), faction_leader:logical_position_x(), faction_leader:logical_position_y(), false):military_force():command_queue_index();
end;

-- Return the numbers of units in the player's entire faction.
local function l_get_faction_number_of_units(faction_key)
    local forces = cm:query_faction(faction_key):military_force_list();
	local unit_count = 0;
	
    for i = 0, forces:num_items() - 1 do
        local current_mf = forces:item_at(i);

        if not current_mf:is_armed_citizenry() then
            local units = current_mf:unit_list():num_items();
            unit_count = unit_count + units;
            --self:print("~~~ Tutorial mission unit counter is now " .. unit_count);
        end;
    end

    return unit_count;
end;

-- Helper function to set-up a mission manager, as the methods are shared between listener types.
local function l_setup_mission_manager(faction_key, mission_key, completion_event, failure_event)
	local mm = mission_manager:new(
        faction_key, -- Faction key
        mission_key, -- Mission key
        function() -- Success Callback
			if completion_event then -- If we have a completion event, then we trigger that so other things can listen to it.
				cdir_mission_manager:print("l_setup_mission_manager(): mission [" .. mission_key .. "] has been successfully completed, triggering event [" .. completion_event .. "]")
				core:trigger_event(completion_event)
			else
				cdir_mission_manager:print("l_setup_mission_manager(): mission [" .. mission_key .. "] has been successfully completed, no completion event specified")
			end;
        end,
		function() -- Failure callback
			-- If we have a failure event, use that. Otherwise we'll use the completion event.
			local event_to_use = failure_event;
			if not event_to_use then
				event_to_use = completion_event;
			end;
			
			if event_to_use then  -- If we have a failure/completion event, then we trigger that so other things can listen to it.
				cdir_mission_manager:print("l_setup_mission_manager(): mission [" .. mission_key .. "] has been failed, triggering event [" .. event_to_use .. "]")
				core:trigger_event(event_to_use)
			else
				cdir_mission_manager:print("l_setup_mission_manager(): mission [" .. mission_key .. "] has been failed, no completion or failure event specified")
			end;
        end,
		function() -- Cancellation callback
			-- If we have a failure event, use that. Otherwise we'll use the completion event.
			local event_to_use = failure_event;
			if not event_to_use then
				event_to_use = completion_event;
			end;
			
			if event_to_use then  -- If we have a failure/completion event, then we trigger that so other things can listen to it.
				cdir_mission_manager:print("l_setup_mission_manager(): mission [" .. tostring(mission_key) .. "] has been cancelled, triggering event [" .. tostring(event_to_use) .. "]")
				core:trigger_event(event_to_use)
			else
				cdir_mission_manager:print("l_setup_mission_manager(): mission [" .. tostring(mission_key) .. "] has been cancelled, no completion or failure event specified")
			end;
        end
    );
	
	return mm;
end;


-- Validates parameters for scripted missions.
local function l_validate_scripted_mission_parameters(objective, conditions, mission_rewards)

    if not is_string(objective) then
        script_error("ERROR: l_validate_scripted_mission_parameters() called but supplied objective key [" .. tostring(objective) .. "] is not a string")
        return false;
    end;

	if conditions then
		if is_string(conditions) then
			conditions = {conditions};
		
		else
			if not is_table(conditions) then
				script_error("ERROR: l_validate_scripted_mission_parameters() called but supplied conditions list [" .. tostring(conditions) .. "] is not a table")
				return false;
			end;

			if #conditions == 0 then
				script_error("ERROR: l_validate_scripted_mission_parameters() called but supplied conditions list [" .. tostring(conditions) .. "] is empty")
				return false;
			end;
		
			for i = 1, #conditions do
                if not is_string(conditions[i]) and not is_number(conditions[i]) then
					script_error("ERROR: l_validate_scripted_mission_parameters() called but element [" .. i .. "] in supplied conditions list is [" .. tostring(conditions[i]) .. "] and not a string or a number")
                    return false;
				end;
			end;
		end;
	end;

    if not mission_rewards then
		mission_rewards = {"money 100"};
	end;
	
	if not is_table(mission_rewards) then
		script_error("ERROR: l_validate_scripted_mission_parameters() called but supplied mission rewards [" .. tostring(mission_rewards) .. "] is not a table");
		return false;
	end;
	
	if #mission_rewards == 0 then
		script_error("ERROR: l_validate_scripted_mission_parameters() called but supplied mission rewards table is empty");
		return false;
	end;
	
	for i = 1, #mission_rewards do
		if not is_string(mission_rewards[i]) then
			script_error("ERROR: l_validate_scripted_mission_parameters() called but supplied mission reward [" .. i .. "] is [" .. tostring(mission_rewards[i]) .. "] and not a string");
			return false;
		end;
	end;
	
	return true;
end;

-- Validates parameters for both scriptd and database missions. Merged as they share these values.
local function l_validate_shared_mission_parameters(faction_key, mission_key, trigger_event, listener_condition, fire_once, completion_event, failure_event)
	if not is_string(faction_key) then
        script_error("ERROR: l_validate_shared_mission_parameters() called but supplied faction key [" .. tostring(faction_key) .. "] is not a string")
        return false;
    end;

    if not is_string(mission_key) then
        script_error("ERROR: l_validate_shared_mission_parameters() called but supplied mission key [" .. tostring(mission_key) .. "] is not a string")
        return false;
    end;
	
    if trigger_event and not is_string(trigger_event) then -- Trigger event can be nil, means fire instantly.
        script_error("ERROR: l_validate_shared_mission_parameters() called but supplied trigger event [" .. tostring(trigger_event) .. "] is not a string")
        return false;
    end;

	if listener_condition and not is_function(listener_condition) then
        script_error("ERROR: l_validate_shared_mission_parameters() called but supplied listener condition [" .. tostring(listener_condition) .. "] is not a function or nil")
        return false;
	elseif not listener_condition then
		listener_condition = function() return true; end;
	end;

    if fire_once and not is_boolean(fire_once) then
        script_error("ERROR: l_validate_shared_mission_parameters() called but supplied fire_once [" .. tostring(fire_once) .. "] is not a bool or nil")
        return false;
    end;

    if completion_event and not is_string(completion_event) then
        script_error("ERROR: l_validate_shared_mission_parameters() called but supplied success event [" .. tostring(completion_event) .. "] is not a string")
        return false;
	end;
	
    if failure_event and not is_string(failure_event) then
        script_error("ERROR: l_validate_shared_mission_parameters() called but supplied failure event [" .. tostring(failure_event) .. "] is not a string or nil")
        return false;
	end;

	return true;
end;

local function l_add_event_listener(mm, faction_key, event_key, objective, conditions, mission_rewards, trigger_event, listener_condition, fail_on_listener_fail, completion_event, failure_event, optional_mission_issuer)
	-- establish trigger listeners if this mission has not already been triggered
	if mm:has_been_triggered() then
		return false;
	end;

	local trigger_immediately = false;
	-- Allow passing through NO trigger event.
	if not trigger_event then
		trigger_immediately = true;
		trigger_event = "mission_manager_instant_trigger_" .. faction_key .. event_key;
	end;

	-- master listener
	core:add_listener(
		"cdir_mission_listener_" .. faction_key .. "_" .. event_key,
		trigger_event,
		function(context)
			if (not listener_condition or fail_on_listener_fail or listener_condition(context)) then
				return true;
			else
				return false;
			end;
		end,
		function(context)
			-- If we don't have a listener_condition, or it succeeded, then add the mission.
			if not listener_condition or not fail_on_listener_fail or listener_condition(context) then
				cdir_mission_manager:print("l_add_event_listener() has received event " .. trigger_event .. ", so triggering mission " .. event_key .. " for faction " .. faction_key);
				
				if objective and conditions then
					-- special case for own_n_units, calculate the condition at the point we trigger the mission
					if objective == "OWN_N_UNITS" then
						mm:add_condition("total " .. l_get_faction_number_of_units(faction_key) + conditions[1])
					end;

					-- special case for engage_force, get the cqi of the nearest military force at the point we trigger the mission
					if objective == "ENGAGE_FORCE" then
						mm:add_condition("cqi " .. l_get_cqi_of_nearest_enemy(faction_key, conditions[1]))
					end;

					-- Special case for progression level. User can pass in the 'key' of the progression feature instead or use the normal.
					if objective == "ATTAIN_FACTION_PROGRESSION_LEVEL" then
						local query_faction = cm:query_faction(faction_key);

						if string.match(conditions[1], "total") then
							mm:add_condition(conditions[1]);
						else
							if query_faction and not query_faction:is_null_interface() then
								mm:add_condition("total " .. progression:get_progression_level_for_feature(query_faction, conditions[1]));
							end;
						end;
					end;
				end;

				mm:trigger();
			else
				-- If we failed our test, then we fire the failed event
				local event_to_trigger = failure_event;
				if not event_to_trigger then
					event_to_trigger = completion_event;
				end;
				
				if trigger_event then
					cdir_mission_manager:print("l_add_event_listener() has received event " .. tostring(trigger_event) .. " but the specified test failed - triggering event " .. tostring(event_to_trigger));
					core:trigger_event(event_to_trigger);
				end;
			end;
		end,
		false
	);

	-- If we fire immediately, then we'll trigger our event.
	if trigger_immediately then
		core:trigger_event(trigger_event);
	end;

	return true;
end;

function cdir_mission_manager:get_turn_number()
	if not self.current_turn_number then
		self.current_turn_number = cm:query_model():turn_number();
	end;
	
	return self.current_turn_number;
end;

function cdir_mission_manager:initialise()
	-- Add a turn listener
	core:add_listener(
		"cdir_mission_manager_turn_counter", -- Unique handle
		"WorldStartOfRoundEvent", -- Campaign Event to listen for
		true,
		function(context) -- What to do if listener fires.
			--Do Stuff Here
			if self.is_turn_overriden then
				self.current_turn_number = self.current_turn_number + 1;
			else
				self.current_turn_number = cm:query_model():turn_number();
			end;
			
		end,
		true --Is persistent
	);
	
	-- Example: trigger_cli_debug_event cdir_mission_manager.override_turn_number(10)
	core:add_cli_listener("cdir_mission_manager.override_turn_number", 
		function(turn_number)
			self.current_turn_number = turn_number;
			self.is_turn_overriden = true;
		end
	);

	-- Example: trigger_cli_debug_event cdir_mission_manager.reset_turn_number()
	core:add_cli_listener("cdir_mission_manager.reset_turn_number", 
		function()
			self.current_turn_number = cm:query_model():turn_number();
		end
	);

	-- Example: trigger_cli_debug_event cdir_mission_manager.trigger_event("event_name")
	core:add_cli_listener("cdir_mission_manager.trigger_event", 
		function(event_key)
			core:trigger_event(event_key);
		end
	);

	-- Example: trigger_cli_debug_event cdir_mission_manager.toggle_ignore_delays()
	core:add_cli_listener("cdir_mission_manager.toggle_ignore_delays", 
		function()
			self.debug_ignore_delays = not self.debug_ignore_delays;
			self:print("MISSION MANAGER - self.debug_ignore_delays = " .. tostring(self.debug_ignore_delays));
		end
	);
end;



------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- MISSION LISTENERS
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------



function cdir_mission_manager:start_mission_listener(faction_key, event_key, objective, conditions, mission_rewards, trigger_event, listener_condition, fire_once, completion_event, failure_event, optional_mission_issuer)
	optional_mission_issuer = optional_mission_issuer or "SHOGUN";

	-- Validate Inputs
	if not l_validate_shared_mission_parameters(faction_key, event_key, trigger_event, listener_condition, fire_once, completion_event, failure_event) then
		return false;
	end;
	
	if not l_validate_scripted_mission_parameters(objective, conditions, mission_rewards) then
		return false;
	end;
	
	local mm = cm:get_mission_manager(event_key, faction_key);
	
	-- Temp hack to assert when we try to register a mission for the second time. This breaks multiplayer, as the mission manager stores data by key, not faction/key
	if mm and mm.faction_name ~= faction_key then
		script_error("ERROR: Not registering mission " .. event_key .. " for faction " .. faction_key .. "as it has been registered by another faction " .. mm.faction_name );
		return;
	end;

	if not mm then
		-- Set-up Mission Manager
		mm = l_setup_mission_manager(faction_key, event_key, completion_event, failure_event);
		
		if not mm then
			script_error("No Mission manager created, exiting. faction [" .. tostring(faction_key) .. " ] event_key [ " .. tostring(event_key) .. "]")
			return;
		end;
		-- Set Issuer
		mm:set_mission_issuer(optional_mission_issuer);

		-- Set Objective
		mm:add_new_objective(objective);

		-- Set Special Case conditions.
		-- OWN_N_UNITS is a special case, so we won't add the conditions yet.
		if conditions and objective ~= "OWN_N_UNITS" and objective ~= "ATTAIN_FACTION_PROGRESSION_LEVEL" then
			for i = 1, #conditions do
				mm:add_condition(conditions[i]);
			end;
		end;

		-- Set rewards.
		for i = 1, #mission_rewards do
			mm:add_payload(mission_rewards[i]);
		end;
	end;

	-- Exit early if we've already triggred.
	if mm:has_been_triggered() then
		return false;		
	end;

	self:print("start_mission_listener() starting listener for [" .. tostring(faction_key) .. "] with event [" .. tostring(event_key) .. "] for campaign event [" .. tostring(trigger_event) .. "]");

	-- establish trigger listeners if this mission has not already been triggered
	return l_add_event_listener(mm, faction_key, event_key, objective, conditions, mission_rewards, trigger_event, listener_condition, fire_once, completion_event, failure_event, optional_mission_issuer);
end;


-- start a historical mission listener where the mission data is set up in the database
function cdir_mission_manager:start_mission_db_listener(faction_key, event_key, trigger_event, listener_condition, fire_once, completion_event, failure_event, delay_start, on_trigger_callback)
	delay_start = delay_start or false;
	on_trigger_callback = on_trigger_callback or nil;

	-- Parameter validation.
	if not l_validate_shared_mission_parameters(faction_key, event_key, trigger_event, listener_condition, fire_once, completion_event, failure_event) then
		return false;
	end;

	local mm = cm:get_mission_manager(event_key, faction_key);
	
	-- Temp hack to assert when we try to register a mission for the second time. This breaks multiplayer, as the mission manager stores data by key, not faction/key
	if mm and mm.faction_name ~= faction_key then
		script_error("ERROR: Not registering mission " .. event_key .. " for faction " .. faction_key .. "as it has been registered by another faction " .. mm.faction_name );
		return;
	end;

	-- If we don't already have a mission manager, then we register a new one.
	if not mm then
		-- Set-up Mission Manager
		mm = l_setup_mission_manager(faction_key, event_key, completion_event, failure_event);
			
		-- set the mission manager to look in the db for the mission type/conditions/payloads etc
		mm:set_should_trigger_from_db(true);

		-- Set if the event should be delayed
		if delay_start and not self.debug_ignore_delays then
			mm:set_should_fire_immediately(false);
		end;

		if on_trigger_callback then
			mm:add_on_trigger_callback(on_trigger_callback);
		end;
	end;

	-- Exit early if we've already triggred.
	if mm:has_been_triggered() then
		return false;		
	end;

	self:print("start_mission_db_listener() starting listener for [" .. tostring(faction_key) .. "] with event [" .. tostring(event_key) .. "] for campaign event [" .. tostring(trigger_event) .. "]");
	
    -- establish trigger listeners if this mission has not already been triggered
	return l_add_event_listener(mm, faction_key, event_key, nil, nil, nil, trigger_event, listener_condition, fire_once, completion_event, failure_event, nil);
end;



function cdir_mission_manager:start_incident_db_listener(faction_key, event_key, trigger_event, listener_condition, fire_once, completion_event, failure_event, delay_start, on_trigger_callback)
	delay_start = delay_start or false;
	on_trigger_callback = on_trigger_callback or nil;

	-- Parameter validation.
	if not l_validate_shared_mission_parameters(faction_key, event_key, trigger_event, listener_condition, fire_once, completion_event, failure_event) then
		return false;
	end;

	local mm = cm:get_mission_manager(event_key, faction_key);

	-- Temp hack to assert when we try to register a mission for the second time. This breaks multiplayer, as the mission manager stores data by key, not faction/key
	if mm and mm.faction_name ~= faction_key then
		script_error("ERROR: Not registering mission " .. event_key .. " for faction " .. faction_key .. "as it has been registered by another faction " .. mm.faction_name );
		return;
	end;

	-- If we don't already have a mission manager, then we register a new one.
	if not mm then
		-- Set-up Mission Manager
		mm = l_setup_mission_manager(faction_key, event_key, completion_event, failure_event);

		-- set the mission manager to look in the db for the mission type/conditions/payloads etc
		mm:set_should_trigger_from_db(true);
		
		-- Tells the manager that this will be an incident.
		mm:set_is_incident();

		-- Set if the event should be delayed
		if delay_start and not self.debug_ignore_delays then
			mm:set_should_fire_immediately(false);
		end;

		if on_trigger_callback then
			mm:add_on_trigger_callback(on_trigger_callback);
		end;
	end;

	-- Exit early if we've already trigegred.
	if mm:has_been_triggered() then
		return false;		
	end;

	self:print("start_incident_db_listener() starting listener for [" .. tostring(faction_key) .. "] with event [" .. tostring(event_key) .. "] for campaign event [" .. tostring(trigger_event) .. "]");

    -- establish trigger listeners if this mission has not already been triggered
	return l_add_event_listener(mm, faction_key, event_key, nil, nil, nil, trigger_event, listener_condition, fire_once, completion_event, failure_event, nil);
end;


function cdir_mission_manager:start_dilemma_db_listener(faction_key, event_key, trigger_event, listener_condition, fire_once, completion_event, failure_event, delay_start, on_trigger_callback, choice_one_event, choice_two_event, choice_three_event, choice_four_event)
	delay_start = delay_start or false;
	on_trigger_callback = on_trigger_callback or nil;

	-- Parameter validation.
	if not l_validate_shared_mission_parameters(faction_key, event_key, trigger_event, listener_condition, fire_once, completion_event, failure_event) then
		return false;
	end;

	local mm = cm:get_mission_manager(event_key, faction_key);
	
	-- Temp hack to assert when we try to register a mission for the second time. This breaks multiplayer, as the mission manager stores data by key, not faction/key
	if mm and mm.faction_name ~= faction_key then
		script_error("ERROR: Not registering mission " .. event_key .. " for faction " .. faction_key .. "as it has been registered by another faction " .. mm.faction_name );
		return;
	end;

	-- If we don't already have a mission manager, then we register a new one.
	if not mm then
		-- Set-up Mission Manager
		mm = l_setup_mission_manager(faction_key, event_key, completion_event, failure_event);
		
		-- set the mission manager to look in the db for the mission type/conditions/payloads etc
		mm:set_should_trigger_from_db(true);
		
		-- Tells the manager that this will be an incident.
		mm:set_is_dilemma();

		-- Set if the event should be delayed
		if delay_start and not self.debug_ignore_delays then
			mm:set_should_fire_immediately(false);
		end;

		if on_trigger_callback then
			mm:add_on_trigger_callback(on_trigger_callback);
		end;
	end;

	
	-- Exit early if we've already trigegred.
	if mm:has_been_triggered() then
		return false;		
	end;

	self:print("start_dilemma_db_listener() starting listener for [" .. tostring(faction_key) .. "] with event [" .. tostring(event_key) .. "] for campaign event [" .. tostring(trigger_event) .. "]");

	-- Add the core listeners
	local success = l_add_event_listener(mm, faction_key, event_key, nil, nil, nil, trigger_event, listener_condition, fire_once, completion_event, failure_event, nil);

	if success then
		-- Dilemma choice callbacks.
		if choice_one_event then
			if not is_string(choice_one_event) and not is_function(choice_one_event) then
				script_error("ERROR: start_dilemma_db_listener() called but supplied choice one [" .. tostring(choice_one_event) .. "] is not a string or a function")
				return false;
			end;

			mm:add_dilemma_choice_callback(0, choice_one_event);
		end;
		
		if choice_two_event then
			if not is_string(choice_two_event) and not is_function(choice_two_event) then
				script_error("ERROR: start_dilemma_db_listener() called but supplied choice one [" .. tostring(choice_two_event) .. "] is not a string or a function")
				return false;
			end;

			mm:add_dilemma_choice_callback(1, choice_two_event);
		end;
		
		if choice_three_event then
			if not is_string(choice_three_event) and not is_function(choice_three_event) then
				script_error("ERROR: start_dilemma_db_listener() called but supplied choice one [" .. tostring(choice_three_event) .. "] is not a string or a function")
				return false;
			end;
			
			mm:add_dilemma_choice_callback(2, choice_three_event);
		end;
		
		if choice_four_event then
			if not is_string(choice_four_event) and not is_function(choice_four_event) then
				script_error("ERROR: start_dilemma_db_listener() called but supplied choice one [" .. tostring(choice_four_event) .. "] is not a string or a function")
				return false;
			end;

			mm:add_dilemma_choice_callback(3, choice_four_event);
		end;

	end;

	return success;
end;

function cdir_mission_manager:has_been_triggered(mission_key, faction_name)
	local qf = cm:query_faction(faction_name)

	if not qf then
		script_error("ERROR: cdir_mission_manager:has_been_triggered() Invalid faction passed in " .. tostring(faction_name) .. "returning nil.");
		return nil;
	end;

	return qf:has_mission_been_issued(mission_key);
end;





------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- DEBUGGING
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

function cdir_mission_manager:print(output_message)
	out.events(self.system_id .. output_message);
end;

-- Example: trigger_cli_debug_event invade()
core:add_cli_listener("invade", 
	function()
		campaign_invasions:create_invasion("3k_dlc04_faction_rebels", "3k_main_luoyang_capital", 2, false);
		campaign_invasions:create_invasion("3k_main_faction_yellow_turban_generic", "3k_main_luoyang_resource_1", 3, false);
		campaign_invasions:create_invasion("3k_main_faction_yellow_turban_generic", "3k_main_luoyang_capital", 1, false);
		campaign_invasions:create_invasion("3k_dlc04_faction_rebels", "3k_main_luoyang_resource_1", 1, false);
	end
);
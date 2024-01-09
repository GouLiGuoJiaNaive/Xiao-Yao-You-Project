---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------
----- Name:			3k_campaign_cdir_global_events.lua GLOBAL EVENTS MANAGER / GLOBAL EVENT.
----- Description: 	DLC04 - Mandate system
-----				Designed to manage events around the world, with different (or no) events triggering for players and AI in the game.
-----				
---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------

cm:add_first_tick_callback(function() global_events_manager:initialise() end); --Self register function

-- #region Global Event Manager
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- GLOBAL EVENT MANAGER
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

ge_gen_result = {
	null = 0;
	success = 1;
	fail_ai_only = 2;
	fail_event_gen = 3;
	fail_conditions = 4;
};


global_events_manager = {
	system_id = "[1001] Global Events Manager - "; -- Used when printing to the console.
	registered_global_events = {}; -- A list of events we've registered this session. Prevents registering two events with the same name (which is bad).
	global_event_processing = false;
};


function global_events_manager:initialise()
	-- Example: trigger_cli_debug_event set_global_flag(he_jin_killed, true)
	core:add_cli_listener("set_global_flag", 
		function(flag_key, val)
			self:set_flag(flag_key, val);
		end
	);

	-- Example: trigger_cli_debug_event get_global_flag(cao_cao_fought_crime)
	core:add_cli_listener("get_global_flag", 
		function(flag_key)
			output("GLOBAL FLAG: " .. tostring(flag_key) .. " = " .. tostring(self:get_flag(flag_key)));
		end
	);

	-- Example: trigger_cli_debug_event trigger_global_event(he_jin_killed)
	core:add_cli_listener("trigger_global_event", 
		function(event_key)
			self:trigger_global_event_from_string(event_key, nil);
		end
	);

	-- Example: trigger_cli_debug_event set_turn_number_modifier(10)
	core:add_cli_listener("set_turn_number_modifier", 
		function(num)
			num = num or 0;
			cm:set_turn_number_modifier(num);

			output("Turn number is now: " .. tostring(cm:turn_number()))
		end
	);
end;


--- @function global_events_manager:register_event
--- @desc Does testing and registers the event with a listener and adds to our list.
--- @p global_event The new_global_event to add.
--- @r nil
function global_events_manager:register_event(new_global_event)

	-- Always check type otherwise the below will break.
	if tostring(new_global_event) ~= "TYPE_GLOBAL_EVENT" then
		script_error("ERROR: passed in object is not a global_event");
		return false;
	end;

	-- We assume events are 'unique', so don't let them fire again if they've completed.
	if self:has_global_event_finished(new_global_event.key) then
		self:print("Event [" .. new_global_event.key .. "] has already completed.");
		return false;
	end;

	-- Make sure it's not a double register.
	if self:has_global_event_been_registered(new_global_event.key) then
		script_error("Event [" .. new_global_event.key .. "] already exists. Please use a unique key. This event will not be added.");
		return false;
	end;

	-- If the event has already triggered, but not completed, then we just restore the listeners, otherwise we'll listen for it triggering.
	if self:has_global_event_started(new_global_event.key) then
		self:print("Event [" .. new_global_event.key .. "] has already started. Restoring listeners.");
		new_global_event:setup_listeners();
	else
		self:print("Event [" .. new_global_event.key .. "] New event added.");
		-- Add the listener for the event.
		core:add_listener(
			new_global_event.key .. "campaign_event", -- Event key. A unique listener key based on the event key.
			new_global_event.campaign_event, -- The event which triggers this
			function(context) -- Conditions for firing
				if not new_global_event:are_spawn_dates_within_range() then
					return false;
				end;

				return new_global_event.opt_condition_event == true or new_global_event.opt_condition_event(context) -- default value is true in constructor.
			end,
			function(context) -- the actual 'doing' of the trigger.
				self:print("GLOBAL EVENT TRIGGERED: " .. tostring(new_global_event.key) );
			
				self.global_event_processing = true;

				-- Delay the firing of cdir events until the model will let us fire events.
				core:add_listener(
					"cdir_global_event_listener" .. new_global_event.key, -- Unique handle
					"ScriptEventPreDeleteModelInterface", -- Campaign Event to listen for
					function(context)
						if not cm:can_modify(true) then
							return false;
						end;

						if self.global_event_processing then
							return false;
						end;
					
						local query_model = cm:query_model();
						local modify_model = cm:modify_model();
					
						if not query_model or query_model:is_null_interface() then
							return false;
						end;
					
						if not modify_model or modify_model:is_null_interface() then
							return false;
						end;
					
						if query_model:pending_battle() and not query_model:pending_battle():is_null_interface() then
							if query_model:pending_battle():is_active() then
								return false;
							end;
						end;
					
						return true;
					end,
					function(context) -- What to do if listener fires.
						self:trigger_global_event(new_global_event, context);
					end,
					false --Is persistent
				);	

				self.global_event_processing = false;
				
			end,
			false -- Is persistent.
		);
	end;

	table.insert(self.registered_global_events, new_global_event);
end;

function global_events_manager:trigger_global_event(global_event, context)

	-- Added a test here to check if the event has already started or finished. This prevents entering here more than once if the event has already triggered (i.e. we have a listener and have called trigger_global_event_from_string on the same tick).
	-- TODO: In the long run we should deal with events being able to fire multiple times.
	if self:has_global_event_finished(global_event.key) or self:has_global_event_started(global_event.key) then
		self:print("WARNING: trigger_global_event(): Attempting to trigger an event which has finished or has already started. It will not be fired again. Key - [" .. tostring(global_event.key) .. "]");
		return false;
	end;

	-- Mark the event as having fired into the saved game, so it cannot trigger again, but may resume listeners.
	global_event:set_started(context);

	local event_fired = global_event:trigger_cdir_events(context);

	-- POST EVENT FUNCTIONS - Only if we actually managed to fire one.
	-- LISTENERS
	-- Register listeners for events which persist after the initial events. Also sets the event to have finished if no listeners were created
	local created_listener = global_event:setup_listeners();

	-- If we didn't fire the event, fire the callback if we got one.
	if not event_fired and global_event.fallback_callback then
		global_event.fallback_callback();
	end;

	-- If no listener was created then mark the event as finished.
	if not event_fired or not created_listener then
		global_event:set_finished(context);
	end;

end;

function global_events_manager:trigger_global_event_from_string(global_event_key, context)
	local global_event_to_trigger = nil;

	for i, v in ipairs(self.registered_global_events) do
		if v.key == global_event_key then
			global_event_to_trigger = v;
		end;
	end;

	if not global_event_to_trigger then
		script_error("ERROR: trigger_global_event_from_string(): Could not find a global event with key " .. tostring(global_event_key));
		return;
	end

	self:trigger_global_event(global_event_to_trigger, context);
end;

--- @function global_events_manager:has_global_event_been_registered
--- @desc Checks if we've previously registered an event of this key. Used to stop us overloading multiple of the same event.
--- @p string the key of the event.
--- @r boolean True if it exists, otherwise false.
function global_events_manager:has_global_event_been_registered(global_event_key)
	if not is_string(global_event_key) then
		script_error("ERROR: has_global_event_been_registered expected string.");
		return false;
	end;
	
	for i, event in ipairs(self.registered_global_events) do
		if event.key == global_event_key then
			return true;
		end;
	end;

	return false;
end;


--- @function global_events_manager:set_global_event_started
--- @desc Sets the event as having triggered. This means that it won't fire again, but will register any listeners it needs.
--- @p string the key of the event.
--- @r nil
function global_events_manager:set_global_event_started(global_event_key)
	if not is_string(global_event_key) then
		script_error("ERROR: set_global_event_started expected string.");
		return false;
	end;

	self:print("Event [" .. global_event_key .. "] marked as STARTED.")
	cm:set_saved_value("has_started", true, "global_events", "events", global_event_key);
end;


--- @function global_events_manager:has_global_event_started
--- @desc Tests if the event has already triggered this saved game.
--- @p string the key of the event.
--- @r nil
function global_events_manager:has_global_event_started(global_event_key)
	if not is_string(global_event_key) then
		script_error("ERROR: has_global_event_started expected string.");
		return false;
	end;

	if not cm:saved_value_exists("has_started", "global_events", "events", global_event_key) then
		return false;
	end;

	return cm:get_saved_value("has_started", "global_events", "events", global_event_key);
end;


--- @function global_events_manager:set_global_event_finished
--- @desc Sets the event as having completed. This means that it cannot be registered again this saved game.
--- @p string the key of the event.
--- @r nil
function global_events_manager:set_global_event_finished(global_event_key)
	if not is_string(global_event_key) then
		script_error("ERROR: set_global_event_finished expected string.");
		return false;
	end;

	self:print("Event [" .. global_event_key .. "] marked as FINISHED.")
	cm:set_saved_value("has_finished", true, "global_events", "events", global_event_key);
end;


--- @function global_events_manager:has_global_event_finished
--- @desc Tests if the event has already completed itself this saved game.
--- @p string the key of the event.
--- @r nil
function global_events_manager:has_global_event_finished(global_event_key)
	if not is_string(global_event_key) then
		script_error("ERROR: has_global_event_finished expected string.");
		return false;
	end;

	if not cm:saved_value_exists("has_finished", "global_events", "events", global_event_key) then
		return false;
	end;

	return cm:get_saved_value("has_finished", "global_events", "events", global_event_key);
end;


--- @function global_events_manager:clear_global_event
--- @desc Function to print to the console. Wraps up functionality to there is a singular point.
--- @p string event_key: The global_event_key to complete.
--- @r nil
function global_events_manager:clear_global_event(event_key)

	if not is_string(event_key) then
		script_error("ERROR: clear_global_event() Passed in event key is not a string.");
		return false;
	end;

	if not self:has_global_event_been_registered(event_key) then
		script_error("ERROR: clear_global_event() Attempting to remove an event key which hasn't been registered. [" .. tostring(event_key) .. "].");
	end

	core:remove_listener(event_key .. "campaign_event");
	--self:set_global_event_started(event_key); -- don't set as started so we can tell if it was cancelled, i.e. finished, but not started.
	self:set_global_event_finished(event_key);
end;

--- @function global_events_manager:print
--- @desc Function to print to the console. Wraps up functionality to there is a singular point.
--- @p string The string to print.
--- @r nil
function global_events_manager:print(string)
	if not is_string(string) then
		script_error("ERROR: print expected string.");
		return false;
	end;

	out.events(self.system_id .. string);
end;


--- @function global_events_manager:complete_string_mission
--- @desc Completes a mission with the specified key and script_key.
--- @p string mission_key: the mission key of the mission
--- @p string script_key: the script key of the objective to complete.
--- @p bool success: whether the mission succeeeded or failed.
--- @r nil
function global_events_manager:complete_string_mission(mission_key, script_key, success)
	local humans = get_human_factions();
	if not humans or #humans == 0 then
		return false;
	end;

	for i, faction_key in ipairs(humans) do
		local mod_faction = cm:modify_faction(faction_key);
		mod_faction:complete_scripted_mission_objective(mission_key, script_key, success);
	end;
end;


--- @function global_events_manager:set_flag
--- @desc Triggers a mission via the model
--- @p string flag_name: the key of the flag
--- @p string value: the value to set the flag to.
--- @r nil
function global_events_manager:set_flag(flag_name, value)
	value = value or true;

	cm:set_saved_value(flag_name, value, "global_events", "flags");
end;


--- @function global_events_manager:get_flag
--- @desc Triggers a mission via the model
--- @p string key: the key of the flag
--- @r boolean
function global_events_manager:get_flag(flag_name)
	if not cm:saved_value_exists(flag_name, "global_events", "flags") then
		return false;
	end;

	return cm:get_saved_value(flag_name, "global_events", "flags");
end;


-- #endregion
















-- #region Global Event
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- GLOBAL EVENT OBJECT
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- a global event
global_event = {};


-- #region Initialisation

--- @function global_event:new
--- @desc Creates a new global event, which can be added to the global_events_manager
--- @p string key: A Unique key for the global_event
--- @p string campaign_event: The campaign event which triggers this
--- @p function opt_condition_event: Any conditions which should be tested
--- @r nil the created global_event
function global_event:new(key, campaign_event, opt_condition_event)
	-- Declare our class.
	o = {};

	setmetatable(o, self);
	self.__index = self;
	self.__tostring = function() return "TYPE_GLOBAL_EVENT" end;

	if not is_string(key) then
		script_error("ERROR: new expected key string.");
		return false;
	end;

	if not is_string(campaign_event) then
		script_error("ERROR: new expected campaign_event string.");
		return false;
	end;

	if opt_condition_event and not is_function(opt_condition_event) then
		script_error("ERROR: new expected opt_condition_event to be nil or a function.");
		return false;
	end;
	opt_condition_event = opt_condition_event or true;


	-- Construct the class vars.
	o.key = key;
	o.campaign_event = campaign_event;
	o.opt_condition_event = opt_condition_event;
	o.opt_pre_callback = nil;
	o.opt_post_callback = nil;

	-- Conditions
	o.invalid_campaigns = {};
	o.min_year = 0;
	o.max_year = 9999;
	o.min_week = 0;
	o.max_week = 47;

	-- Incidents
	o.incidents_to_fire = {};
	o.incident_failure_events = {};
	o.incident_success_events = {};
	o.other_player_incidents = {};

	-- Dilemmas
	o.dilemmas_to_fire = {};
	o.dilemma_choice_outcomes = {};
	o.dilemma_failure_events = {};
	o.dilemma_success_events = {};

	-- Missions
	o.missions_to_fire = {};
	o.string_missions = {};
	o.mission_failure_events = {};
	o.mission_success_events = {};
	o.mission_not_triggered_events = {};

	-- Fallback events.
	o.fallback_callback = nil; -- If no events fired then fire this callback.
	
	o.event_conditions = {}; -- A list of condition functions to use.

	o.triggered_event_keys = {};
	o.factions_triggered_events = {};

	o.fire_events_immediately = true;

	-- return the new object
	return o;
end;


--- @function global_event:setup_listeners
--- @desc Sets up listeners for events which persist after they fire. Also sets the event to have finished if no listeners were created.
--- @r nil
function global_event:setup_listeners()
	local created_listener = false;

	-- Local function to initiate mission listeners
	local setup_mission_listener = function(mission_key)
		-- Mission success callbacks
		if self.mission_success_events[mission_key] then
			core:add_listener(
				"global_events_" .. mission_key .. "_mission_succeeded",
				"MissionSucceeded",
				function(context) return context:mission():mission_record_key() == mission_key end,
				function()
					core:trigger_event(self.mission_success_events[mission_key]);
					-- Mark the event as having fired into the saved game, so it cannot trigger again, but may resume listeners.
					self:set_finished();
				end,
				false
			);

			created_listener = true;
		end;

		-- Mission failure callbacks
		if self.mission_failure_events[mission_key] then
			core:add_listener(
				"global_events_" .. mission_key .. "_mission_succeeded",
				"MissionFailed",
				function(context) return context:mission():mission_record_key() == mission_key end,
				function()
					core:trigger_event(self.mission_failure_events[mission_key]);
					self:set_finished();
				end,
				false
			);

			core:add_listener(
				"global_events_" .. mission_key .. "_mission_succeeded",
				"MissionCancelled",
				function(context) return context:mission():mission_record_key() == mission_key end,
				function()
					core:trigger_event(self.mission_failure_events[mission_key]);
					self:set_finished();
				end,
				false
			);

			created_listener = true;
		end;
	end;


	if #self.triggered_event_keys > 0 then
		-- MISSIONS
		if self.missions_to_fire and #self.missions_to_fire > 0 then
			for i, mission_key in ipairs(self.missions_to_fire) do
				if self:has_event_triggered(mission_key) then
					setup_mission_listener(mission_key);
				end;
			end;
		end;


		-- SCRIPTED MISSIONS
		if self.string_missions and #self.string_missions > 0 then
			for i, string_mission in ipairs(self.string_missions) do
				if self:has_event_triggered(string_mission.mission_key) then
					setup_mission_listener(string_mission.mission_key);
				end;
			end;
		end;


		-- INCIDENTS
		if self.incidents_to_fire and #self.incidents_to_fire > 0 then
			for i, incident_key in ipairs(self.incidents_to_fire) do
				if self:has_event_triggered(incident_key) then
					core:add_listener(
						"global_events_" .. incident_key .. "_mission_succeeded",
						"IncidentOccuredEvent",
						function(context) return context:incident() == incident_key end,
						function(context)
							-- Incident success events.
							if self.incident_success_events[incident_key] then
								core:trigger_event(self.incident_success_events[incident_key]);
							end;

							self:set_finished();
						end,
						false
					);

					created_listener = true;
				end;
			end;
		end;


		-- DILEMMAS
		if self.dilemmas_to_fire and #self.dilemmas_to_fire > 0 then
			for i, dilemma_key in ipairs(self.dilemmas_to_fire) do
				if self:has_event_triggered(dilemma_key) then
					core:add_listener(
						"global_events_" .. dilemma_key .. "_mission_succeeded",
						"DilemmaIssuedEvent",
						function(context) return context:dilemma() == dilemma_key end,
						function(context)

							-- Dilemma success events.
							if self.dilemma_success_events[dilemma_key] then
								core:trigger_event(self.dilemma_success_events[dilemma_key]);
							end;

							-- If we have choice events registered then add a listener.
							local choices_for_dilemma = self:get_choice_outcomes_for_dilemma_key(dilemma_key);
							if choices_for_dilemma and #choices_for_dilemma > 0 then
								core:add_listener(
									"global_events_" .. dilemma_key .. "dilemma_choice",
									"DilemmaChoiceMadeEvent",
									function(context) 
										return context:dilemma() == dilemma_key
									end,
									function(context) 
										local choice = context:choice();
										for k, choice_outcome in ipairs(choices_for_dilemma) do
											if choice_outcome.dilemma_key == dilemma_key and choice_outcome.choice_id == choice then
												if choice_outcome.event_to_fire then
													global_events_manager:print("DILEMMA CHOICE MADE: PLAYER: ChoiceId: " .. tostring(choice_outcome.choice_id) .. " EventToFire: " .. tostring(choice_outcome.event_to_fire));
													core:trigger_event(choice_outcome.event_to_fire);
												end;

												break;
											end;
										end;
									end,
									false
								);
							end;

							self:set_finished();
						end,
						false
					);

					created_listener = true;
				end;
			end;
		end;
	end;

	return created_listener;
end;


--- @function global_event:register
--- @desc shorthand system to register the event with the global manager. Performs filtering to prevent registering invalid events.
--- @r nil
function global_event:register()
	if not global_events_manager then
		script_error("ERROR: No global events manager exists!");
		return false;
	end;

	-- Make sure the event can actually fire in this campaign/date range.
	if self:has_year_passed_outside_spawn_range() then
		global_events_manager:print("Not registering event [" .. self.key .. "] as start date [" .. tostring(self.max_year) .. "] has already passed.");
		return;
	end;

	if not self:is_campaign_valid() then
		global_events_manager:print("Not registering event [" .. self.key .. "] as campaign [" .. tostring(cm.name) .. "] is banned.");
		return;
	end;

	global_events_manager:register_event(self);
end;

-- #endregion



-- #region Trigger Conditions

--- @function global_event:set_delay_events
--- @desc Prevents incidents, dilemmas, etc firing immediately. They will fire on the next turn.
--- @p bool should delay? 
--- @r nil
function global_event:set_delay_events(delay)
	self.fire_events_immediately = not delay;
end;


--- @function global_event:set_valid_dates
--- @desc Sets the date ranges this can spawn in.
--- @p number min_year: Year to spawn 
--- @p number max_year: Year to spawn
--- @p number min_week: (0-48) week of year to spawn. default = 0
--- @p number max_week: (0-48) week of year to spawn. default = 47
--- @r nil
function global_event:set_valid_dates(min_year, max_year, opt_min_week, opt_max_week)
	opt_min_week = opt_min_week or 0;
	opt_max_week = opt_max_week or 47;

	if not is_number(min_year) then
		script_error("ERROR: global_event:set_valid_dates() Min year [" .. tostring(min_year) .. "] is not a number.");
		return;
	end;

	if not is_number(max_year) then
		script_error("ERROR: global_event:set_valid_dates() Max year [" .. tostring(max_year) .. "] is not a number.");
		return;
	end;

	self.min_year = min_year;
	self.max_year = max_year;
	self.min_week = opt_min_week;
	self.max_week = opt_max_week;
end;


--- @function global_event:set_invalid_campaigns
--- @desc Allows specifying campaigns which this global event cannot fire in.
--- @p args/string String parameters for each campaign this is invalid in. (three_kingdoms_early, ep_eight_princes, dlc05_new_year, dlc04_mandate)
--- @r nil
function global_event:set_invalid_campaigns(...)

	for i = 1, arg.n do
		local current_arg = arg[i];

		if not is_string(current_arg) then
			script_error("global_event:set_invalid_campaigns() Passed in campaign string is not a string [" .. tostring(current_arg) .. "]");
			return;
		end;

		-- Make sure it's not already in there.
		table.insert(self.invalid_campaigns, current_arg);
	end;
end;

-- #endregion



-- #region Cdir Events

--- @function global_event:add_incident
--- @desc Adds an incident to the global_event which can fire when it triggers.
--- @p string incident_key: The db key of the incident.
--- @r nil
function global_event:add_incident(incident_key, condition_function, success_event, failure_event)
	if not is_string(incident_key) then
		return false;
	end;

	if failure_event then
		self.incident_failure_events[incident_key] = failure_event;
	end;

	if success_event then
		self.incident_success_events[incident_key] = success_event;
	end;

	if condition_function then
		self.event_conditions[incident_key] = condition_function;
	end;

	table.insert( self.incidents_to_fire, incident_key );
end;


--- @function global_event:add_other_player_incident
--- @desc Adds an incident which will fire if any other incidents/dilemmas/missions fired for other factions.
--- @p string incident_key: The db key of the incidents.
--- @r nil
function global_event:add_other_player_incident(incident_key, condition_function)
	if condition_function then
		self.event_conditions[incident_key] = condition_function;
	end;

	table.insert(self.other_player_incidents, incident_key);
end;


--- @function global_event:add_dilemma
--- @desc Adds a dilemma to the global_event which can fire when it triggers.
--- @p string dilemma_key: The db key of the dilemma.
--- @r nil
function global_event:add_dilemma(dilemma_key, condition_function, success_event, failure_event)
	if not is_string(dilemma_key) then
		script_error("ERROR: add_dilemma: expected dilemma_key to be a string.");
		return false;
	end;


	if success_event then
		self.dilemma_success_events[dilemma_key] = success_event;
	end;

	if failure_event then
		self.dilemma_failure_events[dilemma_key] = failure_event;
	end;

	if condition_function then
		self.event_conditions[dilemma_key] = condition_function;
	end;

	table.insert( self.dilemmas_to_fire, dilemma_key );
end;


--- @function global_event:add_dilemma_choice_outcome
--- @desc Adds a scripted outcome based on one of the choices in a dilemma.
--- @p number choice: the code ID of the choice (1-4)
--- @p string event: A CampaignEvennt to fire when this event is triggered.
--- @p number ai_weighting: The weighting of this choice. Chance = weight / total_weight.
--- @p function fail_callback: Fire this is the dilemma failed to fire but this was chosen, mainly used for AI events.
--- @r nil
function global_event:add_dilemma_choice_outcome(dilemma, choice, event, ai_weighting, opt_fail_callback)
	ai_weighting = ai_weighting or 0;

	if not is_number(choice) then
		script_error("ERROR: add_dilemma_choice_outcome: expected choice to be a number.");
		return false;
	end;

	if event and not is_string(event) then
		script_error("ERROR: Event to fire is not a string!");
		return false;
	end;

	if opt_fail_callback and not is_function(opt_fail_callback) then
		script_error("ERROR: Fail callback it not a function.");
		return false;
	end;

	table.insert(self.dilemma_choice_outcomes, {dilemma_key = dilemma, choice_id = choice, event_to_fire = event, ai_weight = ai_weighting, fail_callback = opt_fail_callback});
end;


--- @function global_event:add_mission
--- @desc Adds a mission to the global_event which can fire when it triggers.
--- @p string mission_key: The db key of the mission.
--- @p string condition_function: A function to test if it should fire.
--- @p string success_event: Event to fire if the mission was completed.
--- @p string not_triggered_event: Event to fire if the mission failed to generate
--- @p string failure_event: Event to fire if the user fails the mission objective
--- @r nil
function global_event:add_mission(mission_key, condition_function, success_event, not_triggered_event, failure_event)
	if not is_string(mission_key) then
		script_error("ERROR: add_mission: expected mission_key to be a string.");
		return false;
	end;

	if success_event then
		self.mission_success_events[mission_key] = success_event;
	end;

	if failure_event then
		self.mission_failure_events[mission_key] = failure_event;
	end;

	if not_triggered_event then
		self.mission_not_triggered_events[mission_key] = not_triggered_event;
	end;

	if condition_function then
		self.event_conditions[mission_key] = condition_function;
	end;

	table.insert( self.missions_to_fire, mission_key );
end;


--- @function global_event:add_string_mission
--- @desc Adds a mission_manager to the global_event which can fire when it triggers.
--- @p mission_manager mission_manager: a mission manager
--- @r nil
function global_event:add_string_mission(mission_key, mission_issuer, objectives, condition_function)

	local string_mission = string_mission:new(mission_key);
	string_mission:set_issuer(mission_issuer);

	for i, objective in ipairs(objectives) do
		if i == 1 then
			string_mission:add_primary_objective(objective.objective_type, objective.conditions);
			for i, v in ipairs(objective.payloads) do
				string_mission:add_primary_payload(v);
			end;
		else
			string_mission:add_secondary_objective(objective.objective_type, objective.conditions, objective.payloads);
		end;
	end;
	
	if condition_function then
		self.event_conditions[mission_key] = condition_function;
	end;

	table.insert(self.string_missions, string_mission);
end;

-- #endregion



-- #region Callbacks

--- @function global_event:add_pre_event_callback
--- @desc Adds a function which fires before all other events have processed.
--- @p function callback: A function to fire before the event goes.
--- @r nil
function global_event:add_pre_event_callback(callback)
	if not is_function(callback) then
		script_error("ERROR: add_pre_event_callback: expected callback to be a function.");
		return false;
	end;

	self.opt_pre_callback = callback;
end;


--- @function global_event:add_post_event_callback
--- @desc Adds a function which fires after all other events have processed.
--- @p function callback: A function to fire after the event goes.
--- @r nil
function global_event:add_post_event_callback(callback)
	if not is_function(callback) then
		script_error("ERROR: add_post_event_callback: expected callback to be a function.");
		return false;
	end;

	self.opt_post_callback = callback;
end;


--- @function global_event:add_post_event_callback
--- @desc Adds a function which fires ONLY if no cdir events fired, but before the post_event_callback.
--- @p function callback: A function to fire.
--- @r nil
function global_event:add_fallback_callback(callback)
	if not is_function(callback) then
		script_error("ERROR: add_fallback_callback: expected callback to be a function.");
		return false;
	end;

	self.fallback_callback = callback;
end;

-- #endregion



-- #region Triggering

--- @function global_event:trigger
--- @desc Triggers the global event. firing all callbacks, cdir_events and updating itself.
--- @r boolean - did an event fire.
function global_event:trigger_cdir_events(context)

	-- INCIDENTS - Trigger and store any incidents we have.
	if self.incidents_to_fire and #self.incidents_to_fire > 0 then
		for i, incident_key in ipairs(self.incidents_to_fire) do
			local event_result = self:trigger_incident(incident_key);

			if event_result == ge_gen_result.success then

				-- We process the actual callbacks once the campaign tells us it's been triggered. We simply inform the system it's been registered so the setup_listeners() function can tell they've happened.
				self:add_triggered_event_key(incident_key);
				
			elseif event_result == ge_gen_result.fail_ai_only or event_result == ge_gen_result.fail_event_gen then
				-- Incident failure events.
				if self.incident_failure_events[incident_key] then
					core:trigger_event(self.incident_failure_events[incident_key]);
				end;
			end;
		end;
	end;


	-- MISSIONS - Trigger any missions we have.
	if self.missions_to_fire and #self.missions_to_fire > 0 then
		for i, mission_key in ipairs(self.missions_to_fire) do
			local event_result = self:trigger_mission(mission_key);

			if event_result == ge_gen_result.success then

				-- We process the actual callbacks once the campaign tells us it's been triggered. We simply inform the system it's been registered so the setup_listeners() function can tell they've happened.
				self:add_triggered_event_key(mission_key);

			elseif event_result == ge_gen_result.fail_ai_only or event_result == ge_gen_result.fail_event_gen then
				if self.mission_not_triggered_events[mission_key] then
					-- If we failed to trigger then fire any failure events we had.
					core:trigger_event(self.mission_not_triggered_events[mission_key]);
				end;
			end;
		end;
	end;


	-- STRING MISSIONS -- Trigger string missions.
	if self.string_missions and #self.string_missions > 0 then
		for i, string_mission in ipairs(self.string_missions) do
			if self:trigger_string_mission(string_mission, context) then

				-- We process the actual callbacks once the campaign tells us it's been triggered. We simply inform the system it's been registered so the setup_listeners() function can tell they've happened.
				self:add_triggered_event_key(string_mission.mission_key);

			end;
		end;
	end;


	-- DILEMMAS -- Trigger Dilemmas
	if self.dilemmas_to_fire and #self.dilemmas_to_fire > 0 then
		for i, dilemma_key in ipairs(self.dilemmas_to_fire) do
			local dilemma_result = self:trigger_dilemma(dilemma_key);

			-- Fire the dilemma. If it fired, create a listener to wait for the dilemma response to the dilemma. Else, simulate the AI decision.
			if dilemma_result == ge_gen_result.success then

				-- We process the actual callbacks once the campaign tells us it's been triggered. We simply inform the system it's been registered so the setup_listeners() function can tell they've happened.
				self:add_triggered_event_key(dilemma_key);
			
			elseif dilemma_result == ge_gen_result.fail_event_gen or dilemma_result == ge_gen_result.fail_ai_only then

				-- Dilemma failure events.
				if self.dilemma_failure_events[dilemma_key] then
					core:trigger_event(self.dilemma_failure_events[dilemma_key]);
				end;

				-- If AI. If we have choices then use a random weighting to decide which one was chosen by the AI.
				local choices_for_dilemma = self:get_choice_outcomes_for_dilemma_key(dilemma_key)
				if choices_for_dilemma and #choices_for_dilemma > 0 then
					local choice_weight = 0;
					for j, choice_outcome in ipairs(choices_for_dilemma) do
						choice_weight = choice_weight + choice_outcome.ai_weight;
					end;

					local r = cm:random_number(choice_weight);
					for k, choice_outcome in ipairs(choices_for_dilemma) do
						r = r - choice_outcome.ai_weight;

						if r < 0 then
							global_events_manager:print("DILEMMA CHOICE MADE: AI: ChoiceId: " .. tostring(choice_outcome.choice_id) .. " EventToFire: " .. tostring(choice_outcome.event_to_fire));
							
							if choice_outcome.event_to_fire then
								core:trigger_event(choice_outcome.event_to_fire);
							end;

							-- Fire our fail callback if we dot one.
							if choice_outcome.fail_callback then
								choice_outcome.fail_callback(context);
							end;
							break; -- Always break after finding the first one!
						end;
					end;
				end
			end;
		end;
	end;


	-- Fire other player incidents if we fires any.
	if #self.triggered_event_keys > 0 then
		-- MP EVENTS
		-- Fire events for other players if we have them.
		if self.other_player_incidents and #self.other_player_incidents > 0 then
			for i, incident_key in ipairs(self.other_player_incidents) do
				self:trigger_other_player_incident(incident_key)
			end;
		end;
	end;

	-- Return if we fired an event
	if #self.triggered_event_keys > 0 then
		return true;
	end;

	return false;
end;


--- @function global_event:trigger_incident
--- @desc Triggers an incident via the model
--- @p string key: the db key
--- @r nil
function global_event:trigger_incident(key)
	if not is_string(key) then
		script_error("ERROR: trigger_incident: expected key to be a string.");
		return false;
	end;

	local humans = get_human_factions();
	local trigger_result = ge_gen_result.null;

	-- Autorun only.
	if not humans or #humans == 0 then
		-- Add a dummy faction to test our conditions, so it behaves the same in autotests and not
		if not cm:query_model():world():faction_list():is_empty() then
			local dummy_faction = cm:query_model():world():faction_list():item_at(0);
			if dummy_faction and not dummy_faction:is_null_interface() then
				local m_faction = cm:modify_faction(dummy_faction:name());
				if self.event_conditions[key] and not self.event_conditions[key](m_faction:query_faction()) then
					return ge_gen_result.fail_conditions;
				end;
			end;

			return ge_gen_result.fail_ai_only;
		end;
	end;

	-- go through both humans.
	for i, faction_key in ipairs(humans) do
		local m_faction = cm:modify_faction(faction_key);
		
		-- Run a test on each faction to check if they can fire this event. Allows us to do db like tests.
		if not self.event_conditions[key] or self.event_conditions[key](m_faction:query_faction()) then
			if m_faction:trigger_incident( key, self.fire_events_immediately ) then
				global_events_manager:print("INDICENT Triggered: " .. key .. " Faction:" .. faction_key);

				self:add_triggered_event_key(key, faction_key);

				success = true;
				trigger_result = ge_gen_result.success;
			elseif trigger_result ~= ge_gen_result.success then
				trigger_result = ge_gen_result.fail_event_gen;
			end;
		elseif trigger_result ~= ge_gen_result.success then
			trigger_result = ge_gen_result.fail_conditions;
		end;
	end;

	return trigger_result;
end;


--- @function global_event:trigger_other_player_incident
--- @desc Triggers an incident via the model for any faction who didn't recieve one.
--- @p string key: the db key
--- @r nil
function global_event:trigger_other_player_incident(key)
	if not is_string(key) then
		script_error("ERROR: trigger_other_player_incident expected string.");
		return false;
	end;

	local humans = get_human_factions();
	local success = false;

	-- Autorun only.
	if not humans or #humans == 0 then
		-- Add a dummy faction to test our conditions, so it behaves the same in autotests and not
		if not cm:query_model():world():faction_list():is_empty() then
			local dummy_faction = cm:query_model():world():faction_list():item_at(0);
			if dummy_faction and not dummy_faction:is_null_interface() then
				local m_faction = cm:modify_faction(dummy_faction:name());
				if self.event_conditions[key] and not self.event_conditions[key](m_faction:query_faction()) then
					return ge_gen_result.fail_conditions;
				end;
			end;

			return ge_gen_result.fail_ai_only;
		end;
	end;

	-- go through both humans.
	for i, faction_key in ipairs(humans) do
		local m_faction = cm:modify_faction(faction_key);

		if not self.event_conditions[key] or self.event_conditions[key](m_faction:query_faction()) then
		
			if not self:has_faction_recieved_event(faction_key) then
				
				if m_faction:trigger_incident( key, self.fire_events_immediately ) then
					global_events_manager:print("INDICENT Triggered: " .. key .. " Faction:" .. faction_key);

					self:add_triggered_event_key(key, faction_key);

					success = true;
				end;
			end;
		end;
	end;

	return success;
end;


--- @function global_event:trigger_dilemma
--- @desc Triggers a dilemma via the model
--- @p string key: the db key
--- @r nil
function global_event:trigger_dilemma(key)
	if not is_string(key) then
		script_error("ERROR: trigger_dilemma expected string.");
		return false;
	end;

	local humans = get_human_factions();
	local trigger_result = ge_gen_result.null;

	-- Autorun only.
	if not humans or #humans == 0 then
		-- Add a dummy faction to test our conditions, so it behaves the same in autotests and not
		if not cm:query_model():world():faction_list():is_empty() then
			local dummy_faction = cm:query_model():world():faction_list():item_at(0);
			if dummy_faction and not dummy_faction:is_null_interface() then
				local m_faction = cm:modify_faction(dummy_faction:name());
				if self.event_conditions[key] and not self.event_conditions[key](m_faction:query_faction()) then
					return ge_gen_result.fail_conditions;
				end;
			end;

			return ge_gen_result.fail_ai_only;
		end;
	end;

	-- go through both humans.
	for i, faction_key in ipairs(humans) do
		local m_faction = cm:modify_faction(faction_key);

		-- Run a test on each faction to check if they can fire this event. Allows us to do db like tests.
		if not self.event_conditions[key] or self.event_conditions[key](m_faction:query_faction()) then
			if m_faction:trigger_dilemma( key, self.fire_events_immediately ) then
				global_events_manager:print("DILEMMA Triggered: " .. key .. " Faction:" .. faction_key);

				self:add_triggered_event_key(key, faction_key);

				trigger_result = ge_gen_result.success;
			elseif trigger_result ~= ge_gen_result.success then -- Only 'flip this is we've not already succeeded previously.

				trigger_result = ge_gen_result.fail_event_gen;
			end;
		elseif trigger_result ~= ge_gen_result.success then

			trigger_result = ge_gen_result.fail_conditions;
		end;
	end;

	return trigger_result;
end;


--- @function global_event:trigger_mission
--- @desc Triggers a mission via the model
--- @p string key: the db key
--- @r nil
function global_event:trigger_mission(key)
	if not is_string(key) then
		script_error("ERROR: trigger_mission expected string.");
		return false;
	end;

	local humans = get_human_factions();
	local trigger_result = ge_gen_result.null;

	-- Autorun only.
	if not humans or #humans == 0 then
		-- Add a dummy faction to test our conditions, so it behaves the same in autotests and not
		if not cm:query_model():world():faction_list():is_empty() then
			local dummy_faction = cm:query_model():world():faction_list():item_at(0);
			if dummy_faction and not dummy_faction:is_null_interface() then
				local m_faction = cm:modify_faction(dummy_faction:name());
				if self.event_conditions[key] and not self.event_conditions[key](m_faction:query_faction()) then
					return ge_gen_result.fail_conditions;
				end;
			end;

			return ge_gen_result.fail_ai_only;
		end;
	end;

	-- go through both humans.
	for i, faction_key in ipairs(humans) do
		local m_faction = cm:modify_faction(faction_key);

		-- Run a test on each faction to check if they can fire this event. Allows us to do db like tests.
		if not self.event_conditions[key] or self.event_conditions[key](m_faction:query_faction()) then
			if m_faction:trigger_mission( key, self.fire_events_immediately ) then
				global_events_manager:print("MISSION Triggered: " .. key .. " Faction:" .. faction_key);

				self:add_triggered_event_key(key, faction_key);

				trigger_result = ge_gen_result.success;
			elseif trigger_result ~= ge_gen_result.success then -- Only 'flip this is we've not already succeeded previously.

				trigger_result = ge_gen_result.fail_event_gen;
			end;
		elseif trigger_result ~= ge_gen_result.success then

			trigger_result = ge_gen_result.fail_conditions;
		end;
	end;

	return trigger_result;
end;


--- @function global_event:trigger_string_mission
--- @desc Triggers a scripted mission via the model. May have a validity callback which fires to check if the mission can fire.
--- @p type string_mission: the scripted mission string for the mission
--- @p userdata context: the passed in event context.
--- @r nil
function global_event:trigger_string_mission(string_mission_obj, context)
	local humans = get_human_factions();
	if not humans or #humans == 0 then
		return false;
	end;

	for i, faction_key in ipairs(humans) do
		local m_faction = cm:modify_faction(faction_key);

		-- Run a test on each faction to check if they can fire this event. Allows us to do db like tests.
		if not self.event_conditions[string_mission_obj.mission_key] or self.event_conditions[string_mission_obj.mission_key](m_faction:query_faction()) then
			if string_mission_obj:trigger_mission_for_faction(faction_key) then
				global_events_manager:print("STRING MISSION Triggered: " .. string_mission_obj.mission_key .. " Faction:" .. faction_key);

				self:add_triggered_event_key(string_mission_obj.mission_key, faction_key);

				success = true;
			end;
		end;
	end;

	return success;
end;

-- #endregion



-- #region Helpers

--- @function global_event:set_started
--- @desc shorthand system to start the event with the global manager
--- @r nil
function global_event:set_started(context)
	
	-- Pre event callback. Fired before any events have been processed.
	if self.opt_pre_callback then
		self.opt_pre_callback(context, self);
	end;

	global_events_manager:set_global_event_started(self.key);
end;


--- @function global_event:set_finished
--- @desc shorthand system to complete the event with the global manager
--- @r nil
function global_event:set_finished(context)
	-- Post event callback. Fired after all events have been processed.
	if self.opt_post_callback then
		self.opt_post_callback(context, self);
	end;

	global_events_manager:set_global_event_finished(self.key);
end;


--- @function global_event:has_faction_recieved_event
--- @desc Checks if the passed in faction has recieved an event from this.
--- @p string faction_key: DB event key
--- @r boolean true if it's found, else false.
function global_event:has_faction_recieved_event(faction_key)

	for i, v in ipairs(self.factions_triggered_events) do
		if v == faction_key then
			return true;
		end;
	end;

	return false;
end;


--- @function global_event:add_triggered_event_key
--- @desc Sets an incident/dilemma/mission as having fired.
--- @p string key: DB event key
--- @p faction_key: the faction who triggered this.
--- @r nil
function global_event:add_triggered_event_key(key, faction_key)
	table.insert(self.triggered_event_keys, key)

	if faction_key then
		table.insert(self.factions_triggered_events, faction_key);
	end;
end;


--- @function global_event:add_triggered_event_key
--- @desc Checks if an incident/dilemma/mission as having fired. Used when you want some logic not to happen if the event fires.
--- @p string key: DB event key
--- @r boolean true if it's fired, else false.
function global_event:has_event_triggered(key)
	for i, v in ipairs(self.triggered_event_keys) do
		if v == key then
			return true;
		end;
	end;

	return false;
end;


--- @function global_event:are_spawn_dates_within_range
--- @desc Checks if spawn dates are within range.
--- @r boolean true if within range, false if not.
function global_event:are_spawn_dates_within_range()
	-- Ignore if we don't have any dates.
	if not self.min_year or not self.max_year then
		return true;
	end;
	
	return cm:query_model():date_and_week_in_range(self.min_week, self.min_year, self.max_week, self.max_year );
end;

--- @function global_event:has_year_passed_outside_spawn_range
--- @desc Checks if the game has moved so far that the spawn dates cannot ever be hit.
--- @r boolean true if outside spawn window, false if not.
function global_event:has_year_passed_outside_spawn_range()
	-- If we don't have a max, then we cannot go past it.
	if not self.max_year then
		return true;
	end;

	return self.max_year < cm:query_model():calendar_year();
end;


--- @function global_event:is_campaign_valid
--- @desc Checks if the campaign we're playing is on a banned list.
--- @r boolean true if campaign not banned, else false.
function global_event:is_campaign_valid()
	-- If we have no filters, we can safely ignore.
	if not self.invalid_campaigns or #self.invalid_campaigns < 1 then
		return true;
	end;

	-- Go through and check if any of our stored keys match the campaign key. Exit if we find a match.
	for i, key in ipairs(self.invalid_campaigns) do
		if key == cm.name then
			return false;
		end;
	end;

	return true;
end;


--- @function global_event:get_choice_outcomes_for_dilemma_key
--- @desc Get the choice outcomes for the specified dilemma key.
--- @p the dilemma key we're testing for.
--- @r table list of the outcomes for the key or nil if none were found.
function global_event:get_choice_outcomes_for_dilemma_key(dilemma_key)
	local returned_outcomes = {};
	for i, outcome in ipairs(self.dilemma_choice_outcomes) do
		if outcome.dilemma_key == dilemma_key then
			table.insert(returned_outcomes, outcome);
		end;
	end;

	-- Return nil if we found nothing
	if #returned_outcomes == 0 then
		return nil;
	end;

	return returned_outcomes;
end;


-- #endregion

-- #endregion
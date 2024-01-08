

-----------------------------------------------------------------------------------------------------------
-- MODULAR SCRIPTING FOR MODDERS
-----------------------------------------------------------------------------------------------------------
-- The following allows modders to load their own script files without editing any existing game scripts
-- This allows multiple scripted mods to work together without one preventing the execution of another
--
-- Issue: Two modders cannot use the same existing scripting file to execute their own scripts as one
-- version of the script would always overwrite the other preventing one mod from working
--
--
-- The following scripting loads all scripts within a "mod" folder of each campaign and then executes
-- a function of the same name as the file (if one such function is declared)
-- Onus is on the modder to ensure the function/file name is unique which is fine
--
-- Example: The file "data/script/campaign/wh2_main_great_vortex/mod/cool_mod.lua" would be loaded and
-- then any function by the name of "cool_mod" will be run if it exists (sort of like a constructor)
--
-- ~ Mitch 18/10/17
-----------------------------------------------------------------------------------------------------------


--- @loaded_in_battle
--- @loaded_in_campaign
--- @loaded_in_frontend


----------------------------------------------------------------------------
---	@section Mod Output
----------------------------------------------------------------------------

if __game_mode < 0 then
	ModLog = function(...) mod_loader_logger():out(...) end
else
	--- @function ModLog
	--- @desc Writes output to the <code>lua_mod_log.txt</code> text file, and also to the development console.
	--- @p @string output text
	local logMade = false;
	function ModLog(text)

		if logMade == false then
			logMade = true;
			local logInterface = io.open("lua_mod_log.txt", "w");

			if not logInterface then
				return false;
			end;

			logInterface:write(text.."\n");
			logInterface:flush();
			logInterface:close();
		else
			local logInterface = io.open("lua_mod_log.txt", "a");

			if not logInterface then
				return false;
			end;

			logInterface:write(text.."\n");
			logInterface:flush();
			logInterface:close();
		end;
	end;
end

-- report a script error to Lua spool and to CampaignUI if available
local error_id = 0;
function script_error(msg, stack_level)

	-- default to 2, 0 is the debug function used, 1 is this, we only care about the function calling this
	stack_level = stack_level or 2;
	local traceback = debug.traceback( msg, stack_level ) -- *** sandbox

	error_id = error_id + 1;
	-- do output
	ModLog("");
	ModLog("**************");
	ModLog("ERROR ID: " .. error_id);
	ModLog("SCRIPT ERROR, timestamp " .. get_timestamp());
	ModLog("");
	ModLog(traceback);
	ModLog("**************");
	ModLog("");
end;

----------------------------------------------------------------------------
---	@section Event Handling
--- @desc The core object provides a wrapper interface for client scripts to listen for events triggered by the game code, which is the main mechanism by which the game sends messages to script.
----------------------------------------------------------------------------

--- @function add_listener
--- @desc Adds a listener for an event. When the code triggers this event, and should the optional supplied conditional test pass, the core object will call the supplied target callback with the event context as a single argument.
--- @desc A name must be specified for the listener which may be used to cancel it at any time. Names do not have to be unique between listeners.
--- @desc The conditional test should be a function that returns a boolean value. This conditional test callback is called when the event is triggered, and the listener only goes on to trigger the supplied target callback if the conditional test returns true. Alternatively, a boolean <code>true</code> value may be given in place of a conditional callback, in which case the listener will always go on to call the target callback if the event is triggered.
--- @desc Once a listener has called its callback it then shuts down unless the persistent flag is set to true, in which case it may only be stopped by being cancelled by name.
--- @p string listener name
--- @p string event name
--- @p function conditional test, Conditional test, or <code>true</code> to always pass
--- @p function target callback
--- @p boolean listener persists after target callback called
core.add_listener = function( self, new_name, new_event, new_condition, new_callback, new_persistent )
	if not is_string(new_name) then
		script_error("ERROR: event_handler:add_listener() called but name given [" .. tostring(new_name) .. "] is not a string");
		return false;
	end;

	if not is_string(new_event) then
		script_error("ERROR: event_handler:add_listener() called but event given [" .. tostring(new_event) .. "] is not a string");
		return false;
	end;

	if not is_function(new_condition) and not (is_boolean(new_condition) and new_condition == true) then
		script_error("ERROR: event_handler:add_listener() called but condition given [" .. tostring(new_condition) .. "] is not a function or true");
		return false;
	end;

	if not is_function(new_callback) then
		script_error("ERROR: event_handler:add_listener() called but callback given [" .. tostring(new_callback) .. "] is not a function");
		return false;
	end;

	new_persistent = new_persistent or false;

	-- attach to the event if we're not already
	self:attach_to_event(new_event);

	--== *** sandbox *** ==--
	-- check existing same name event
	local duplicate_event_found = false

	for idx, listener in ipairs( self.event_listeners[new_event] ) do
		if listener.name == new_name
			and not listener.to_remove
			and listener.callback == new_callback
			and listener.condition == new_condition
		then
			ModLog( "core:add_listener : duplicate listener : <"..new_event.."> ["..idx.."] \""..new_name.."\"" )
			duplicate_event_found = true
			--
			break
		end
	end
	--== *** sandbox *** ==--

	if not duplicate_event_found then  -- ** sandbox ** --
		local new_listener = {
			name = new_name,
			event = new_event,
			condition = new_condition,
			callback = new_callback,
			persistent = new_persistent,
			to_remove = false
		}

		table.insert(self.event_listeners[new_event], new_listener)
	end
end

local ignored_events_for_debug = {
	"ScriptEventPanelClosedCampaign",
	"UICreated",
	"PanelOpenedCampaign",
	"PanelClosedCampaign",
	"ScriptEventPreDeleteModelInterface",
	"ComponentLClickUp",
	"CampaignTimeTriggerEvent"
}

-- event callback
-- an event has occured, work out who to notify
core.event_callback = function( self, eventname, context )
	-- Guard against bad scripting deleting listeners while we're iterating them.
	self.is_processing_callbacks = true;

	-- if the context seems to be from a code-generated event, and we are running in campaign, then attempt to register context and model/query interfaces with the campaign manager
	local is_code_context = false;

	if __game_mode == __lib_type_campaign and is_eventcontext(context) then
		is_code_context = true;
		cm:register_model_interface(eventname, context);
	end;

	-- Debug output the event.
	
	--[[
	if self.debug_events and not table.contains(ignored_events_for_debug, eventname) then
		ModLog( "ignored_events_for_debug Event: " .. eventname );
	end;
	]]
	-- make a list of callbacks to fire and listeners to remove. We can't call the callbacks whilst
	-- processing the list because the callbacks may alter the list length, and we can't rescan because
	-- this will continually hit persistent callbacks
	local callbacks_to_call = {}
	local listeners = self.event_listeners[eventname]
	local callee_name = ""

	local function condition_error( err_message )
		ModLog( "\ncore:condition_check_error:<"..eventname.."> [ "..callee_name.." ]" )
		ModLog( "\terror: "..debug.traceback( err_message, 3 ).."\n" )
	end

	local function callback_error( err_message )
		ModLog( "\ncore:event_callback_error:<"..eventname.."> [ "..callee_name.." ]" )
		ModLog( "\terror: "..debug.traceback( err_message, 3 ).."\n" )
	end

	--== *** sandbox *** ==--
	if listeners and #listeners > 0 then
		for _, listener in ipairs( listeners ) do
			local condition_checked = false

			if not listener.to_remove then

				if type(listener.condition) == "boolean" then
					condition_checked = listener.condition
				elseif type(listener.condition) == "function" then
					callee_name = listener.name
					_, condition_checked = xpcall( function() return listener.condition(context) end, condition_error )
				else
					ModLog( "event_callback <"..eventname.."> : [ "..listener.name.." ] condition is not function nor boolean. removing" )
					listener.to_remove = true
				end

				if condition_checked then
					table.insert(callbacks_to_call, { callback = listener.callback, name = listener.name } )
					-- mark this listener to be removed post-list
					listener.to_remove = not listener.persistent
				end
			end
		end

		-- clean out all the listeners that have been marked for removal
		local new_event_listeners = {}
		for _, listener in ipairs( listeners ) do
			if not listener.to_remove then
				table.insert( new_event_listeners, listener )
			end
		end

		self.event_listeners[eventname] = new_event_listeners

		for _, listener in ipairs( callbacks_to_call ) do
			callee_name = listener.name
			xpcall( function() listener.callback( context ) end, callback_error )
		end;
	end
	--== *** sandbox *** ==--

	-- notify the campaign manager that it needs to delete its context
	if __game_mode == __lib_type_campaign and is_code_context then
		cm:delete_model_interface()
	end

	self.is_processing_callbacks = false;
end


--- @function trigger_event
--- @desc Triggers an event from script, to which event listeners will respond. An event name must be specified, as well as zero or more items of data to package up in a custom event context. See custom_context documentation for information about what types of data may be supplied with a custom context. A limitation of the implementation means that only one data item of each supported type may be specified.
--- @desc By convention, the names of events triggered from script are prepended with "ScriptEvent" e.g. "ScriptEventLocalPlayerFactionTurnStart".
--- @p @string event name
--- @p ... context data items
core.trigger_event = function( self, event, ... )
	
	-- build an event context
	local context = custom_context:new();
	
	for i = 1, arg.n do
		local current_obj = arg[i];
	
		-- if this is a proper context object, pass it through directly
		if is_eventcontext(current_obj) then
		
			if arg.n > 1 then
				script_error("WARNING: trigger_event() was called with multiple objects to pass through on the event context, yet one of them was a proper event context - the rest will be discarded");
			end;
			
			context = current_obj;
			break;
		end;
	
		context:add_data(current_obj);
	end;

	--== *** sandbox *** ==--
	local function callback_error( err_message )
		ModLog( "\ncore:trigger_event_error:<"..event..">" )
		ModLog( "\terror: "..debug.traceback( err_message, 3 ).."\n" )
	end

	if __game_mode >= 0 then
		-- trigger the event with the context
		local event_table = events[event];
		
		if event_table then
			for i = 1, #event_table do
				xpcall( function() event_table[i](context) end, callback_error )
			end;
		end;
	else
		core:event_callback( event, context )
	end
	--== *** sandbox *** ==--
end;


--- @function trigger_custom_event
--- @desc Triggers an event from script with a context object constructed from custom data. An event name must be specified, as well as a table containing context data at key/value pairs. For keys that are strings, the value corresponding to the key will be added to the @custom_context generated, and will be available to listening scripts through a function with the same name as the key value. An example might be a hypothetical event <code>ScriptEventCharacterInfected</code>, with a key <code>disease</code> and a value which is the name of the disease. This would be accessible to listeners of this event that call <code>context:disease()</code>.
--- @desc Should the key not be a string then the data is added to the context as normal, as if supplied to @custom_context:add_data.
--- @desc By convention, the names of events triggered from script are prepended with "ScriptEvent" e.g. "ScriptEventLocalPlayerFactionTurnStart".
--- @p @string event name
--- @p @table data items
core.trigger_custom_event = function( self, event, context_data )
	if not is_string(event) then
		script_error("ERROR: trigger_custom_event() called but supplied event name [" .. tostring(event) .. "] is not a string");
		return false;
	end;

	if not is_table(context_data) then
		script_error("ERROR: trigger_custom_event() called but supplied context data [" .. tostring(context_data) .. "] is not a table");
		return false;
	end;

    -- build an event context
	local context = custom_context:new();
	
	for key, value in pairs(context_data) do
		if is_eventcontext(value) then
			script_error("WARNING: trigger_custom_event() was called with a proper event context - any other values will be discarded. Use trigger_event() instead");
            context = value;
			break;
		end;

		if not is_string(key) then
			-- the key is not a string, so just add the data as if a key wasn't specified
			context:add_data(value);
		else
			-- add the value with the key
			context:add_data_with_key(value, key);
		end;
	end;

	--== *** sandbox *** ==--
	local function callback_error( err_message )
		ModLog( "\ncore:trigger_event_error:<"..event..">" )
		ModLog( "\terror: "..debug.traceback( err_message, 3 ).."\n" )
	end

	if __game_mode >= 0 then
		-- trigger the event with the context
		local event_table = events[event];
		
		if event_table then
			for i = 1, #event_table do
				xpcall( function() event_table[i](context) end, callback_error )
			end;
		end;
	else
		core:event_callback( event, context )
	end
	--== *** sandbox *** ==--
end

--- @section Performance Monitoring
----------------------------------------------------------------------------

--- @function monitor_performance
--- @desc Immediately calls a supplied function, and monitors how long it takes to complete. If this duration is longer than a supplied time limit a script error is thrown. A string name must also be specified for the function, for output purposes.
--- @p function function to call
--- @p number time limit in s
--- @p string name
core.monitor_performance = function( self, callback, time_limit, name )
	local start_timestamp = os.clock();
	--== *** sandbox *** ==--
	local function check_callback_error( err_message )
		ModLog( "\ncore:timer_callback_error : ".. is_string(name) and name or "no name" )
		ModLog( "\terror: "..debug.traceback( err_message, 3 ).."\n" )
	end

	xpcall( callback, check_callback_error )
	--== *** sandbox *** ==--

	local calltime = os.clock() - start_timestamp;

	if calltime > time_limit + 0.1 then -- ** sandbox
		script_error("PERFORMANCE WARNING: function with the following name or callstack took [" .. tostring(calltime) .. "]s to execute, exceeding its allowed time of [" .. tostring(time_limit) .. "]s:\n%%%%%%%%%%%%%%%%%%%%\n" .. tostring(name) .. "\n%%%%%%%%%%%%%%%%%%%%\n", 3)
	end;
end

--- @function execute_mods
--- @desc Attempts to execute a function of the same name as the filename of each mod that has previously been loaded by @core_object:load_mods. For example, if mods have been loaded from <code>mod_a.lua</code>, <code>mod_b.lua</code> and <code>mod_c.lua</code>, the functions <code>mod_a()</code>, <code>mod_b()</code> and <code>mod_c()</code> will be called, if they exist. This can be used to start the execution of mod scripts at an appropriate time, particularly during campaign script startup.
--- @desc One or more arguments can be passed to <code>execute_mods</code>, which are in-turn passed to the mod functions being executed.
--- @p ... arguments, Arguments to be passed to mod function(s).
--- @r @boolean No errors reported
core.execute_mods = function( self, ... )

	ModLog("");
	ModLog("****************************");
	ModLog("Executing Mods");
	ModLog("***************");

	local executing_mod_name = ""

	local function execute_error( err_message )
		ModLog( "\ncore:execute_mods: " .. executing_mod_name .. "() failed while executing" )
		ModLog( "\terror: "..debug.traceback( err_message, 3 ).."\n" )
	end
	
	--== *** sandbox *** ==--
	local function call_start_func( mod_name, mod_start_func )
		executing_mod_name = mod_name
		mod_start_func( unpack(arg) )
	end

	for _, mod_name in ipairs( self.loaded_mods ) do
		local mod_start_func = self:get_env()[ mod_name ]
		-- proceed if there's a function with the same name as the mod file
		if is_function( mod_start_func ) then

			local ok = xpcall( function() call_start_func( mod_name, mod_start_func ) end, execute_error )

			if ok then
				ModLog( "executed : ".. mod_name.."()" )
			end

			self:trigger_event( "ScriptEventModExecuted", mod_name, ok )
		end
	end
	--== *** sandbox *** ==--
	
	ModLog("****************************");
	ModLog("");
end;

-- internal function to load an individual mod script
core.load_mod_script = function( self, filepath )
	local pointer = 1;

	local filename_for_out = filepath;
	local filename = filepath -- *** sandbox *** --

	while true do
		local next_separator = string.find(filepath, "\\", pointer) or string.find(filepath, "/", pointer);

		if next_separator then
			pointer = next_separator + 1;
		else
			if pointer > 1 then
				filepath = string.sub(filepath, pointer);
			end;
			break;
		end;
	end;

	local suffix = string.sub(filepath, string.len(filepath) - 3);

	if string.lower(suffix) == ".lua" then
		-- ** sandbox ** --
		filename = string.sub(filepath, 1, string.len(filepath) - 4);
		-- ** sandbox ** --
	end;

	ModLog( "[ "..filename.." ]" )
	ModLog( (" "):rep( 10 ).."File \""..filename_for_out.."\"" )

	-- Avoid loading more than once
	if package.loaded[filename] and not core:is_battle() then
		ModLog( (" "):rep( 10 ).."Already loaded. File path [" .. filename_for_out .. "]");
		return true, filename, filename_for_out
	end

	local function execute_error( err_message )
		ModLog( "\ncore:load_mod_script_error: "..filename.." : Error : while executing loaded mod file \"" .. filename_for_out .. "\"" )
		ModLog( "\terror: "..debug.traceback( err_message, 3 ).."\n" )
	end

	-- Loads a Lua chunk from the file
	local loaded_file, load_error = loadfile( __game_mode >= 0 and filename or filename_for_out )

	-- Make sure something was loaded from the file
	if loaded_file then
		-- Mod was loaded successfully - print some output, set its function environment, add it to the list of loaded mods and execute it

		-- *** sandbox *** --
		if not _G.loader_env_0 then _G.loader_env_0 = getfenv(0) end
		-- *** sandbox *** --

		-- Set the environment of the Lua chunk to the global environment
		setfenv(loaded_file, self:get_env());
		-- Make sure the file is set as loaded
		package.loaded[filename] = true;
		-- Execute the loaded Lua chunk so the functions within are registered
		local ok = xpcall( loaded_file, execute_error )

		if not ok then
			return false, false
		end

		table.insert(self.loaded_mods, filename);

		return true
	else
		-- Mod was not loaded successfully - print some output

		ModLog( (" "):rep( 8 ).."Failed to load mod file ["..filename_for_out.."], error is: " .. tostring(load_error) .. ". Will attempt to require() this file to generate a more meaningful error message:");

		local require_result, require_error = pcall(require, filename);

		if require_result then
			ModLog( (" "):rep( 8 ).."Warning : require() seemed to be able to load file with filename [" .. filename_for_out .. "], where loadfile failed? Maybe the mod is loaded, maybe it isn't - proceed with caution!")
			return true
		else
			-- strip tab and newline characters from error string
			ModLog( (" "):rep( 8 ).."Error : "..string.gsub(string.gsub(require_error, "\t", ""), "\n", ""))
		end

		return false
	end;
end;

----------------------------------------------------------------------------
--- @section Mod Loading
--- @desc Functions for loading and, in campaign, executing mod scripts. Note that @global:ModLog can be used by mods for output.
----------------------------------------------------------------------------


--- @function load_mods
--- @desc Loads all mod scripts found on each of the supplied paths, setting the environment of every loaded mod to the global environment.
--- @p ... paths, List of string paths from which to load mods from. The terminating <code>/</code> character must be included.
--- @r @boolean All mods loaded correctly
--- @example core:load_mods("/script/_lib/mod/", "/script/battle/mod/");
core.load_mods = function( self, ... )

	ModLog("");
	ModLog("****************************");
	ModLog("Loading Mods");
	ModLog("***************");

	local all_mods_loaded_successfully = true;
	local out_str = false;

	for i = 1, arg.n do
		local path = arg[i];

		if not is_string(path) then
			script_error("ERROR: load_mods() called but supplied path [" .. tostring(path) .. "] is not a string");

			ModLog("****************************");
			ModLog("");
			return false;
		end;

		package.path = path .. "?.lua;" .. package.path;

		local file_str = effect.filesystem_lookup(path, "*.lua");

		for filepath in string.gmatch(file_str, '([^,]+)') do

		--== *** sandbox *** ==--
		-- ***
		-- *** Not pre-loading all the LUA files in mod's sub-directory
		-- ***
		-- *** after 1.5.0 the 'require' function forced in the fenv(0) environment
		-- *** therefore, 'require' function not inherit the fenv(1), but the model thread's fenv(0)
		-- *** so LUA sub-files through 'require' function is unable to access core:env & _G.campain_env
		-- *** @#$@%!

			-- /script/_lib/mod/:[script\_lib\mod\test_script_here.lua]

			--filepath [script\campaign\mod/thegathering_sandbox.lua] *** old
			--filepath [script\campaign\mod\thegathering_sandbox.lua] *** changed 1.5.0

			--filepath [script\campaign\mod\sandbox\thegathering_mod_lib.lua]
			--filepath [script\campaign\3k_main_campaign_map\mod\thegathering_tke_factions.lua]
			--path [/script/campaign/mod/] *** posix format
			--path [/script/campaign/3k_main_campaign_map/mod/]
			--path [/script/_lib/mod/]
			--path [/script/mod_frontend/]
			--path [/script/battle/mod/]

			--ModLog( path..":["..filepath.."]" )
			if filepath:match( "campaign\\mod\\([^,\\/]+)%.lua$" )
				or (CampaignName and filepath:match( "campaign\\"..CampaignName.."\\mod\\([^,\\/]+)%.lua$" ))
				or filepath:match( "_lib\\mod\\([^,\\/]+)%.lua$" )
				or filepath:match( "battle\\mod\\([^,\\/]+)%.lua$" )
				or filepath:match( "script\\mod_frontend\\([^,\\/]+)%.lua$" )
			then
				--ModLog( "\t["..i.."]["..filepath.."]" )
				----------------------------------------------------------------------
				local result = self:load_mod_script(filepath);
				----------------------------------------------------------------------
				if result == true then
					ModLog( (" "):rep( 8 ).."Mod loaded successfully" )
				else
					ModLog( (" "):rep( 8 ).."Failed to load mod" )
					all_mods_loaded_successfully = false;
				end;

				self:trigger_event("ScriptEventModLoaded", filepath, result )
			end;
		end;
		--== *** sandbox *** ==--
	end;

	ModLog("****************************");
	ModLog("");

	return all_mods_loaded_successfully;
end;

-- load mods here
if core:is_campaign() then
	-- LOADING CAMPAIGN MODS

	-- load mods on NewSession
	core:add_listener(
		"new_session_mod_scripting_loader",
		"NewSession",
		true,
		function(context)

			local all_mods_loaded_successfully = core:load_mods(
				"/script/_lib/mod/",								-- general script library mods
				"/script/campaign/mod/",							-- root campaign folder
				-- campaign-specific folder
				-- NB: the CampaignName variable is automatically created in the campaign script environment, and corresponds to the internal
				-- name of the campaign. In 3K this doesn't necessarily correspond to the name of the folder in data/script/campaigns that
				-- contains the script for a given campaign, but it does correspond to the name of the folder in data/campaigns that contains
				-- the startpos files. Therefore, when making mods for a given campaign, those scripts should go in a folder named after the
				-- actual campaign name e.g.
				-- script/campaign/3k_main_campaign_map/mod/your_mod_script_here.lua		-- main Three Kingdoms campaign
				-- script/campaign/8p_start_pos/mod/your_mod_script_here.lua				-- Eight Princes
				"/script/campaign/" .. CampaignName .. "/mod/"
			);

			core:trigger_event("ScriptEventAllModsLoaded", all_mods_loaded_successfully);
		end,
		true
	);

	-- execute mods on first tick
	core:add_listener(
		"first_tick_after_world_created_mod_scripting_loader",
		"FirstTickAfterWorldCreated",
		true,
		function(context)
			core:execute_mods(context);
		end,
		false
	);


elseif core:is_battle() then
	-- LOADING BATTLE MODS

	local all_mods_loaded_successfully = core:load_mods(
		"/script/_lib/mod/",				-- general script library mods
		"/script/battle/mod/"				-- root battle folder
	);

	core:trigger_event("ScriptEventAllModsLoaded", all_mods_loaded_successfully);

else
	-- LOADING FRONTEND MODS

	local all_mods_loaded_successfully = core:load_mods(
		"/script/_lib/mod/",				-- general script library mods
		"/script/mod_frontend/"				-- frontend-specific mods
	);

	core:trigger_event("ScriptEventAllModsLoaded", all_mods_loaded_successfully);
end;

if core:is_campaign() then
	--== *** sandbox *** ==--
	-- using 'pcall' to prevent from failure of all following script mods lower load order
	-- and log-out the catched error message for debugging
	-- if loading failed, only that mod is failed
	--== *** sandbox *** ==--
	function campaign_manager:process_first_tick_callbacks(context)

		local call_stage, call_index = "", 0

		local function callback_error( err_message )
			ModLog( "\ncm:process_first_tick_callbacks:"..call_stage.."<"..call_index.."> : call failed" )
			ModLog( "\terror: "..debug.traceback( err_message, 3 ).."\n" )
		end

		local function callback_call( stage, index )
			call_stage = stage
			call_index = index

			self[call_stage][call_index]( context )
		end

		-- process pre first-tick callbacks
		for i = 1, #self.pre_first_tick_callbacks do
			xpcall( function() callback_call( "pre_first_tick_callbacks", i ) end, callback_error )
		end

		if self:is_multiplayer() then
			if self:is_new_game() then
				-- process new mp callbacks
				for i = 1, #self.first_tick_callbacks_mp_new do
					xpcall( function() callback_call( "first_tick_callbacks_mp_new", i ) end, callback_error )
				end;
			end;

			-- process each mp callbacks
			for i = 1, #self.first_tick_callbacks_mp_each do
				xpcall( function() callback_call( "first_tick_callbacks_mp_each", i ) end, callback_error )
			end;
		else
			if self:is_new_game() then
				-- process new sp callbacks
				for i = 1, #self.first_tick_callbacks_sp_new do
					xpcall( function() callback_call( "first_tick_callbacks_sp_new", i ) end, callback_error )
				end;
			end;

			-- process each sp callbacks
			for i = 1, #self.first_tick_callbacks_sp_each do
				xpcall( function() callback_call( "first_tick_callbacks_sp_each", i ) end, callback_error )
			end;
		end;

		-- process post first-tick callbacks
		for i = 1, #self.post_first_tick_callbacks do
			xpcall( function() callback_call( "post_first_tick_callbacks", i ) end, callback_error )
		end;

	end;
	
	-- releases a key stolen with steal_key_with_callback()
	function campaign_manager:release_key_with_callback(name, key)
		if not is_string(name) then
			script_error("ERROR: release_key_with_callback() called but supplied name [" .. tostring(name) .. "] is not a string");
			return false;
		end;

		if not is_string(key) then
			script_error("ERROR: release_key_with_callback() called but supplied key [" .. tostring(key) .. "] is not a string");
			return false;
		end;

		--== *** sandbox *** ==--
		-- create a table for this key if one doesn't already exist
		if not is_table(self.stolen_keys[key]) then
			self.stolen_keys[key] = {};
		end;
		--== *** sandbox *** ==--

		local key_steal_entries_for_key = self.stolen_keys[key];
		
		for i = 1, #key_steal_entries_for_key do
			if key_steal_entries_for_key[i].name == name then
				table.remove(key_steal_entries_for_key, i);
				break;
			end;
		end;
		
		return true;
	end;
	
	--== *** sandbox *** ==--

end -- core:is_campaign()

function char_lookup_str(obj)
	if is_nil(obj) then
		script_error("ERROR: char_lookup_str() called but supplied object is nil");
		return false;
	end

	if is_number(obj) or is_string(obj) then
		return "character_cqi:" .. obj;
	end;

	if is_query_character(obj) then
		return "character_cqi:" .. obj:cqi();
	elseif is_modify_character(obj) then

		--== *** sandbox *** ==--
		-- selecting character in UI when 'Detailed Character Panel' is opened cause CTD sometimes
		-- return "character_cqi:" .. obj:query_faction():cqi()
		return "character_cqi:" .. obj:query_character():cqi()
		--== *** sandbox *** ==--
	else
		script_error( "ERROR: char_lookup_str() called but could not recognise supplied object [" .. tostring(obj) .. "]" )
	end;
end;
--[[ string missions - allows firing missions in a string format in the same way as the victory objectives. Used by the mission manager and global events systems.

Example string mission:
	local test_mission = string_mission:new("debug_mission");
	test_mission:add_primary_objective("ENGAGE_FORCE");
	test_mission:add_primary_objective("CONTROL_N_REGIONS_INCLUDING", {"total 1"})
	test_mission:add_primary_payload("money 100;");
	test_mission:add_primary_payload("effect_bundle{bundle_key 3k_main_introduction_mission_payload_defeat_force;turns 3;}");
	test_mission:trigger_mission_for_faction("3k_main_faction_cao_cao");

]]--


string_mission = {}

--- @function string_mission:new
--- @desc Creates a new string mission object.
--- @p string - the key of the mission to fire.
--- @r TYPE_STRING_MISSION the object created.
function string_mission:new(mission_key)

	if not is_string(mission_key) then
		script_error("ERROR: string_mission:new() called but supplied mission_key " .. tostring(mission_key) .. " is not a string");
		return false;
	end;

	local sm = {};
	setmetatable(sm, self);
	self.__index = self;
	self.__tostring = function() return "TYPE_STRING_MISSION" end;

	sm.mission_key = mission_key;
	sm.mission_issuer = "EUROPEANS";
	sm.primary_objectives = {};
	sm.primary_payloads = {};
	sm.secondary_objectives = {};

	return sm;
end;


--- @function string_mission:set_issuer
--- @desc Overrides the issuer of the string mission
--- @r string - the mission string.
function string_mission:set_issuer(issuer_key)
	if not is_string(issuer_key) then
		script_error("ERROR: string_mission:set_issuer() called but supplied issuer_key " .. tostring(issuer_key) .. " is not a string");
		return false;
	end;

	self.mission_issuer = issuer_key;
end;


function string_mission:set_turn_limit(turn_limit)
	if not is_number(turn_limit) then
		script_error("ERROR: set_turn_limit() called on mission manager for mission key [" .. self.mission_key .. "] but supplied turn limit [" .. tostring(turn_limit) .. "] is not a number");
		return false;
	end;
	
	self.turn_limit = turn_limit;
end;


function string_mission:set_chapter(chapter)
	if not is_number(chapter) then
		script_error("ERROR: set_chapter() called on mission manager for mission key [" .. self.mission_key .. "] but supplied chapter [" .. tostring(chapter) .. "] is not a number");
		return false;
	end;
	
	self.chapter_mission = chapter;
end;

function string_mission:add_primary_objective(objective_key, conditions_table, opt_heading_key, opt_description_key)
	local objective = {
		objective_type = objective_key,
		conditions = conditions_table,
		heading = opt_heading_key,
		description = opt_description_key	
	};

	table.insert(self.primary_objectives, objective);
end;

function string_mission:add_primary_payload(payload_string)

	--[[ Make sure payload have the correct endings.
		Single are parsed as 'payload_key payload_value;'
		Multi-param payload values are parsed as 'payload_key{param1 value1;param2 value2;}'
		#TODO - We should probably handle this more elegantly.
	]]--
	local last = string.sub (payload_string, -1)
	if last ~= "}" and last ~= ";" then 
		payload_string = payload_string .. ";";
	elseif last == "}" then
		local second_last = string.sub(payload_string, -2, -2);
		if second_last ~= ";" then
			script_error("ERROR: string_mission:add_primary_payload() Invalid format multi-param payload entered [" .. payload_string .. "]. Should be formed as 'payload_key{param1 value1;param2 value2;}'. Fixing up for now, but functionality is not guaranteed.");
			payload_string = string.sub(payload_string, 1, -2) .. ";}";
		end;
	end;

	table.insert(self.primary_payloads, payload_string);
end;

function string_mission:add_secondary_objective(objective_key, conditions_table, payloads_table, opt_heading_key, opt_description_key)
	if not is_string(objective_key) then
		script_error("ERROR: string_mission:add_secondary_objective() called but supplied objective_key " .. tostring(objective_key) .. " is not a string");
		return false;
	end;

	if not is_table(conditions_table) then
		script_error("ERROR: string_mission:add_secondary_objective() called but supplied conditions_table " .. tostring(conditions_table) .. " is not a table");
		return false;
	end;

	if not is_table(payloads_table) then
		script_error("ERROR: string_mission:add_secondary_objective() called but supplied payloads_table " .. tostring(payloads_table) .. " is not a table");
		return false;
	end;

	local objective = {
		objective_type = objective_key,
		conditions = conditions_table,
		payloads = payloads_table,
		heading = opt_heading_key,
		description = opt_description_key
	};
	
	table.insert(self.secondary_objectives, objective);
end;


--- @function string_mission:trigger_mission_for_faction
--- @desc Makes a string which the code can read from the passed in mission data
--- @p string the key of the faction to fire this for.
--- @r bool did the mission trigger?
function string_mission:trigger_mission_for_faction(faction_key, whitelist)
	whitelist = whitelist or false;
	if not is_string(faction_key) then
		script_error("ERROR: string_mission:trigger_mission_for_faction() called but supplied faction_key " .. tostring(faction_key) .. " is not a string");
		return false;
	end;

	local mission_string = self:construct_mission_string();

	if mission_string and cm:trigger_custom_mission_from_string(faction_key, mission_string, whitelist) then
		return true;
	end;

	return false;
end;


--- @function string_mission:construct_mission_string
--- @desc Makes a string which the code can read from the passed in mission data
--- @r string - the mission string.
function string_mission:construct_mission_string()

	if #self.primary_objectives == 0 then
		script_error("ERROR: construct_mission_string() called with key [" .. self.mission_key .. "] but we have no primary objectives to add");
		return false;
	end;
	
	local mission_string = "mission{key " .. self.mission_key .. ";issuer " .. self.mission_issuer .. ";"; --open mission

	if self.chapter_mission then
		mission_string = mission_string .. "chapter " .. self.chapter_mission .. ";"
	end;

	if self.turn_limit then
		mission_string = mission_string .. "turn_limit "..self.turn_limit .. ";"
	end;
	
	-- PRIMARY OBJECTIVES
	mission_string = mission_string .. "primary_objectives_and_payload{" --open primary_objectives_and_payload

	-- objectives first
	for i, obj in ipairs(self.primary_objectives) do
		
		-- optional heading/decription key overrides
		if obj.heading then
			mission_string = mission_string .. "heading " .. obj.heading .. ";";
		end;
		
		if obj.description then
			mission_string = mission_string .. "description " .. obj.description .. ";";
		end;

		mission_string = mission_string .. "objective{type " .. obj.objective_type .. ";" --open objective

		if obj.conditions and #obj.conditions > 0 then
			for j = 1, #obj.conditions do
				mission_string = mission_string .. obj.conditions[j] .. ";"
			end;
		end;

		mission_string = mission_string .. "}" --close objective
	end;

	-- then payloads
	mission_string = mission_string .. "payload{" --open payload
	for i, payload_key in ipairs(self.primary_payloads) do
		mission_string = mission_string .. payload_key
	end;
	mission_string = mission_string .. "}" --close payload

	mission_string = mission_string .. "}" -- close primary_objectives_and_payload
	
	-- PRIMARY OBJECTIVES: END

	-- SECONDARY OBJECTIVES
	if #self.secondary_objectives > 0 then
		mission_string = mission_string .. "secondary_objectives_and_payloads{" -- open secondary_objectives_and_payloads

		for i, obj in ipairs(self.secondary_objectives) do
			mission_string = mission_string .. "objectives_and_payload{" -- open objectives_and_payload

			-- optional heading/decription key overrides
			if obj.heading then
				mission_string = mission_string .. "heading " .. obj.heading .. ";";
			end;
			
			if obj.description then
				mission_string = mission_string .. "description " .. obj.description .. ";";
			end;
			
			mission_string = mission_string .. "objective{type " .. obj.objective_type .. ";"  -- open objective

			if obj.conditions and #obj.conditions > 0 then
				for j = 1, #obj.conditions do
					mission_string = mission_string .. obj.conditions[j] .. ";"
				end;
			end;

			mission_string = mission_string .. "}"   -- close objective

			mission_string = mission_string .. "payload{"; -- open payload

			for i, obj in ipairs(self.secondary_objectives) do
				for j = 1, #obj.payloads do
					mission_string = mission_string .. obj.payloads[j] .. ";"
				end;
			end;

			mission_string = mission_string .. "}"; -- close payload

			mission_string = mission_string .. "}" -- close objectives_and_payload
		end;

		mission_string = mission_string .. "}" -- close secondary_objectives_and_payloads
	end;

	mission_string = mission_string .. "}" -- close mission

	-- SECONDARY OBJECTIVES: END
	return mission_string;
end;
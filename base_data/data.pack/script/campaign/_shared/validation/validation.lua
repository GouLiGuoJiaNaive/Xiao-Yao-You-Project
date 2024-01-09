print("*** Loading validation... ***");
print("*** Call 'validate_campaign' from the console to force validation.")

--[[
*************************************************************************
	ASSUMPTION
	Named assumption with a tester function
************************************************************************* 
]]--

Assumption = 
{
	name = "",
	test_function = nil,
};

---@f Assumption:new()
---@d Creates a new Assumption, which tests a specific aspect of an object
---@p string: The name of the assumption
---@p function: The test to run
---@r Assumption: A new, unique Assumption.
function Assumption:new(name, test_function)
	local new_assumption = {};
	setmetatable(new_assumption, self);

	new_assumption.name = name;
	new_assumption.test_function = test_function;

	self.__index = self;
	return new_assumption;
end;

---@f Assumption:test()
---@d Tests the assumption, returning whether it succeeded or failed.
---@p object: The object to run the assumption on
---@r Test_result : A test result object defining if we succeeded or failed and by how much.
function Assumption:test(corresponding_game_object)
	local succeeded = self.test_function(corresponding_game_object, self);
	local information = "";

	if succeeded then
		information = "Assumption \"" .. self.name .. "\" holds.";
	else
		information = "Assumption \"" .. self.name .. "\" doesn't hold.";
	end;

	return Test_result.new(succeeded, information);
end;

function Assumption:add_failure_reason(output)
	table.insert(self.failures, output);
end;



--[[
*************************************************************************
	TEST RESULT
	Boolean value with some information about the result
*************************************************************************
]]--

Test_result = 
{
	succeeded = false,
	information = ""
}

---@f Test_result:new()
---@d Creates a new Test_result, which reports the result of the test.
---@p bool: the result of the test
---@p table: The information returned from the assumptions
---@r Test_result : A test result object defining if we succeeded or failed and by how much.
function Test_result.new(result, information)
	local new_result = {};
	setmetatable(new_result, Test_result);

	new_result.succeeded = result;
	new_result.information = information;

	Test_result.__index = Test_result;
	return new_result;
end;



--[[
*************************************************************************
	VALIDATED OBJECT
	A named set of assumptions with a corresponding game object
	e.g. faction list with assumptions about all the factions in the game
*************************************************************************
]]--
Validated_object = 
{
	name = "",
	corresponding_game_object = nil,
	assumptions = {}
};

---@f Validated_object:new()
---@d Creates a new Validated_object, which can be used to run tests upon.
---@p string: Name of the object
---@p object: The game object(s) to test
---@p table: List of Assumptions to run.
---@r Validated_object : A new object
function Validated_object:new(name, corresponding_game_object, assumptions)
	local new_object = {};
	setmetatable(new_object, self);

	new_object.name = name;
	new_object.corresponding_game_object = corresponding_game_object;
	new_object.assumptions = assumptions;

	self.__index = self;
	return new_object;
end;

---@f Validated_object:test()
---@d Runs through all the assumptions on the object, returning trie if they all passed, or false if they all failed. Also adds information for later output
---@p nil
---@r Test_result : A test result object defining if we succeeded or failed and by how much.
function Validated_object:test()
	local succeeded = true;
	local information = {};

	Validation:inc_tab();

	for i = 1, #self.assumptions do
		local current_result = self.assumptions[i]:test(self.corresponding_game_object);
		succeeded = succeeded and current_result.succeeded;
		table.insert(information, current_result.information)
	end;

	Validation:dec_tab();

	return Test_result.new(succeeded, information);
end;


-- Register any new validation files here, before we register them.

force_require("faction_validation");
force_require("diplomacy_validation");
force_require("character_ceo_validation");
force_require("character_validation");
force_require("region_validation");



--[[
*************************************************************************
	VALIDATION
	The actual performer of the validation.
*************************************************************************
]]--
Validation = {
	console_indent = 0;
};

---@f Validation:print_to_console
---@d Prints the string to the console, using string.format if rrequired.
---@p string: the message
---@p ...: Args for string.format if required.
---@r nil
function Validation:print_to_console(message, ...)
	local out_str = "";

	for i = 1, self.console_indent do
		out_str = out_str .. "\t";
	end;

	if #arg > 0 then
		out_str = out_str .. string.format(message, unpack(arg));
	else
		out_str = out_str .. message;
	end

	out.validation(out_str);
end;

function Validation:inc_tab()
	out.inc_tab("validation");
end;

function Validation:dec_tab()
	out.dec_tab("validation");
end;

---@f Validation:get_character_string
---@d Takes a QUERY_CHARACTER and formats them as a string to output to the console.
---@p QUERY_CHARACTER
---@r string: the formatted string for the character. 
function Validation:get_character_string(character)
	return string.format("CQI: %s, faction: %s, template:%s",
		character:cqi(),
		character:faction():name(),
		character:generation_template_key()
		)
end;


local validation_success = true;
local report_errors_on_failed_validation = false;

---@f validate
---@d Takes a function and an object to pass in, and runs the test on it.
---@p function: The validation function to call on the game_object.
---@p object: Can be any type really, just needs to match what the function is expecting.
---@r string: the formatted string for the character. 
local function validate(object_definition_function, corresponding_game_oject)
	local validated_object = object_definition_function(corresponding_game_oject);

	Validation:print_to_console("***** Validating " .. validated_object.name .. "*****");

	Validation:inc_tab();

	local object_validation_result = validated_object:test();

	for i = 1, #object_validation_result.information do
		Validation:print_to_console(object_validation_result.information[i]);
	end;

	if report_errors_on_failed_validation and not object_validation_result.succeeded then
		script_error(validated_object.name .. " validation failed. See output for details");
	end;

	Validation:dec_tab();

	validation_success = validation_success and object_validation_result.succeeded;
end;


-- register validation callback
core:add_listener(
	"campaign_validation_listener",
	"ValidateCampaign",
	true,
	function(campaign_model_context)
		Validation:print_to_console("********* Starting campaign validation... *********");
		report_errors_on_failed_validation = campaign_model_context:should_error_on_failed_campaign_validation();

		if not validation_success then 
			validation_success = true;
		end;

		Validation:inc_tab();

		-- Register new functions defining Validated_objects here.
		validate(validate_factions, campaign_model_context:query_model():world():faction_list());
		validate(validate_diplomacy, campaign_model_context:query_model():world());
		validate(validate_active_character_ceos, campaign_model_context:query_model():world():active_character_list());
		validate(validate_active_characters, campaign_model_context:query_model():world():active_character_list());
		validate(validate_regions, campaign_model_context:query_model():world():region_manager():region_list());

		Validation:dec_tab();
		if validation_success then
			Validation:print_to_console("********* Campaign validation successfull *********");
		else
			Validation:print_to_console("********* Campaign validation failed *********");
		end;
	end,
	true	
);

print("*** Validation loaded... ***");
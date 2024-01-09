--[[ HEADER

	NB. This is a template script. Please go through and change the 'my_' bits to suit your needs. Please delete anything you won't use, and then delete this comment :).

	Name: my_class_name
	Description: 
		my_class_description
]]--

-- Don't load in campaigns which don't require it.
if cm.name == "ep_eight_princes" then
	output("my_class_name: Not loaded in this campaign." );
	return;
else
	output("my_class_name: Loading");
end;



--[[ VARIABLES
	Setup variables here.
	Most variables should be 'local' (only in this script). 
	Only add global variables if they need to be accessed outside this script.
]]--
-- Define the table which holds all our data and functions.
local first_round = 3;
  
-- If you want global variables/functions (and think carefully if you do), please wrap them in a table of 'my_class_name'.
-- my_class_name = {}



--[[ LOCAL FUNCTIONS
	Accesible only by this script. Should be defined before they are used in the file.
	Should define as 'local function function_name(params)'
]]--

-- Add local functions here.

-- Adds the listeners which control the script's functionality.
local function add_first_tick_listeners()
	core:add_listener(
		"class_name_test_listener", -- Listener Name
		"WorldStartOfRoundEvent", -- Campaign Event
		function(context)
			return cm:turn_number() >= first_round;
		end, -- Condition (true/function())
		function(context) -- Action
			output("my_class_name: Start of Round");
		end,
		true -- Is persistent
	)
end;



--[[ GLOBAL FUNCTIONS
	Accessible both inside and outside of this script.
	Should define as 'function my_class_name:function_name(params)'
]]--

-- Add global functions here.



--[[ INITIALISATION
	Handles installing the script into the game logic.
]]--

-- Fires on the first tick of a New Campaign
cm:add_first_tick_callback_new(function()
	output("my_class_name: New Game");
end);

-- Fires on the first tick of every game loaded.
cm:add_first_tick_callback(function()
	output("my_class_name: Loaded Game");

	add_first_tick_listeners();
end);
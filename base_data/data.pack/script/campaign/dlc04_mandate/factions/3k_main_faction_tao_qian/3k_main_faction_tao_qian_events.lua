-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
------------------------- Tao Qian Tutorial Missions --------------------------
-------------------------------------------------------------------------------
----------------------- Created by Ricky: 20/06/2019 --------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

local campaign_key = "3k_dlc04";
local local_faction_key = "3k_main_faction_tao_qian";

output("Event script loaded for faction " .. local_faction_key);

-- Spawn initial armies.
local function initial_set_up()
	local invasion = campaign_invasions:create_invasion("3k_dlc04_faction_rebels", "3k_main_henei_capital", 1, true, local_faction_key, true, 614, 458);
	invasion:set_force_retreated();
	invasion:start_invasion();
end;

cm:add_first_tick_callback_new(initial_set_up);


-------------------------------------------------------------------------------
------------------------------------- Turn 1 ----------------------------------
-------------------------------------------------------------------------------
if not cm:get_saved_value("start_mission_unlocked") then
	cdir_mission_manager:start_mission_db_listener(
		local_faction_key, -- faction_key 
		"3k_dlc04_mission_3k_dlc04_faction_tao_qian_tutorial_01", -- event_key 
		"FactionTurnStart", -- trigger event 
		function(context) -- returns bool
			return cm:query_model():turn_number() == 1 and context:faction():name() == local_faction_key;
		end, --listener condition
		false, -- fire once
		"3k_dlc04_mission_3k_dlc04_faction_tao_qian_tutorial_01_complete", -- completion event 
		nil -- failure
	)
end

core:add_listener(
	"mission_progression",
	campaign_key.."incident"..local_faction_key.."tutorial_01_complete",
	true,
	function()
		cm:set_saved_value("start_mission_unlocked", true);
	end,
	false
)


cdir_mission_manager:start_mission_db_listener(
	local_faction_key, -- faction_key 
	"3k_dlc04_mission_3k_dlc04_faction_tao_qian_tutorial_02", -- event_key 
	"3k_dlc04_mission_3k_dlc04_faction_tao_qian_tutorial_01_complete", -- trigger event 
	function(context) -- returns bool
		return true;
	end, --listener condition
	false, -- fire_once
	"3k_dlc04_mission_3k_dlc04_faction_tao_qian_tutorial_02_complete", -- completion event 
	"3k_dlc04_mission_3k_dlc04_faction_tao_qian_tutorial_02_failed" -- failure event
);

core:add_listener(
	"spawn_first_rebel_invasion",
	"FactionTurnEnd",

	function(context)
		output("3k_main_faction_tao_qian_events.lua: Turn two has ended.");
		return context:query_model():turn_number() == 2;
	end,

	function()
		campaign_invasions:create_invasion_attack_region("3k_dlc04_faction_rebels", "3k_main_langye_resource_1", 3, "3k_main_langye_resource_1"); -- Attack Langye Lumber
		diplomacy_manager:force_declare_war("3k_dlc04_faction_rebels", local_faction_key, true);
	end,
	false
)

cdir_mission_manager:start_mission_db_listener(
	local_faction_key, -- faction_key 
	"3k_dlc04_mission_3k_dlc04_faction_tao_qian_tutorial_03", -- event_key 
	"3k_dlc04_mission_3k_dlc04_faction_tao_qian_tutorial_01_complete", -- trigger event 
	function(context) -- returns bool
		return true;
	end, --listener condition
	false, -- fire_once
	"3k_dlc04_mission_3k_dlc04_faction_tao_qian_tutorial_03_complete"-- completion event 
);

core:add_listener(
	"spawn_second_rebel_invasion",
	"FactionTurnEnd",

	function(context)
		output("3k_main_faction_tao_qian_events.lua: Turn three has ended.");
		return context:query_model():turn_number() == 3;
	end,

	function()
		campaign_invasions:create_invasion_attack_region("3k_dlc04_faction_rebels", "3k_main_langye_resource_2", 3, "3k_main_langye_resource_2"); -- Attack Langye Fishing
		diplomacy_manager:force_declare_war("3k_dlc04_faction_rebels", local_faction_key, true);
	end,
	false
)

cdir_mission_manager:start_mission_db_listener(
	local_faction_key, -- faction_key 
	"3k_dlc04_mission_3k_dlc04_faction_tao_qian_tutorial_04a", -- event_key 
	"3k_dlc04_mission_3k_dlc04_faction_tao_qian_tutorial_03_complete", -- trigger event 
	function(context) -- returns bool
		return true;
	end, --listener condition
	false, -- fire_once
	"3k_dlc04_mission_3k_dlc04_faction_tao_qian_tutorial_04_complete", -- completion event 
	"3k_dlc04_mission_3k_dlc04_faction_tao_qian_tutorial_04a_failed" -- failed event 
);

cdir_mission_manager:start_mission_db_listener(
	local_faction_key, -- faction_key 
	"3k_dlc04_mission_3k_dlc04_faction_tao_qian_tutorial_04b", -- event_key 
	"3k_dlc04_mission_3k_dlc04_faction_tao_qian_tutorial_04a_failed", -- trigger event
	function(context) -- returns bool
		return true;
	end, --listener condition
	false, -- fire_once
	"3k_dlc04_mission_3k_dlc04_faction_tao_qian_tutorial_04_complete", -- completion event 
	nil -- failure
);

cdir_mission_manager:start_mission_db_listener(
	local_faction_key, -- faction_key 
	"3k_dlc04_mission_3k_dlc04_faction_tao_qian_tutorial_05a", -- event_key 
	"3k_dlc04_mission_3k_dlc04_faction_tao_qian_tutorial_04_complete", -- trigger event
	function(context) -- returns bool
		return true;
	end, --listener condition
	false, -- fire_once
	"3k_dlc04_mission_3k_dlc04_faction_tao_qian_tutorial_05_complete", -- completion event 
	"3k_dlc04_mission_3k_dlc04_faction_tao_qian_tutorial_05a_failed" -- failed event 
);

cdir_mission_manager:start_mission_db_listener(
	local_faction_key, -- faction_key 
	"3k_dlc04_mission_3k_dlc04_faction_tao_qian_tutorial_05b", -- event_key 
	"3k_dlc04_mission_3k_dlc04_faction_tao_qian_tutorial_05a_failed", -- trigger event
	function(context) -- returns bool
		return true;
	end, --listener condition
	false, -- fire_once
	"3k_dlc04_mission_3k_dlc04_faction_tao_qian_tutorial_05_complete", -- completion event 
	nil -- failure
);
--[[ NOTE - These missions are utterly failing as scripted events. 
			Going to be doing them with pure event gen stuff...

cdir_mission_manager:start_mission_db_listener(
	local_faction_key, -- faction_key 
	"3k_dlc04_mission_3k_dlc04_faction_tao_qian_tutorial_06", -- event_key 
	"3k_dlc04_mission_3k_dlc04_faction_tao_qian_tutorial_03_complete", -- trigger event 
	function(context) -- returns bool
		return true;
	end, --listener condition
	false, -- fire_once
	"3k_dlc04_mission_3k_dlc04_faction_tao_qian_tutorial_6_complete", -- completion event 
	"3k_dlc04_mission_3k_dlc04_faction_tao_qian_tutorial_6_failed" -- failed event 
);

cdir_mission_manager:start_mission_db_listener(
	local_faction_key, -- faction_key 
	"3k_dlc04_mission_3k_dlc04_faction_tao_qian_tutorial_07a", -- event_key 
	"3k_dlc04_mission_3k_dlc04_faction_tao_qian_tutorial_6_complete", -- trigger event
	function(context) -- returns bool
		return true;
	end, --listener condition
	false, -- fire_once
	"3k_dlc04_mission_3k_dlc04_faction_tao_qian_tutorial_07_complete", -- completion event 
	nil -- failure
);

cdir_mission_manager:start_mission_db_listener(
	local_faction_key, -- faction_key 
	"3k_dlc04_mission_3k_dlc04_faction_tao_qian_tutorial_07b", -- event_key 
	"3k_dlc04_mission_3k_dlc04_faction_tao_qian_tutorial_6_failed", -- trigger event
	function(context) -- returns bool
		return true;
	end, --listener condition
	false, -- fire_once
	"3k_dlc04_mission_3k_dlc04_faction_tao_qian_tutorial_07_complete", -- completion event 
	nil -- failure
);]]

-------------------------------------------------------------------------------
------------------------------------- Turn 7 ---------------------------------
-------------------------------------------------------------------------------

cdir_mission_manager:start_dilemma_db_listener(
	local_faction_key, -- faction_key 
	"3k_dlc04_dilemma_3k_dlc04_faction_tao_qian_dilemma_01", -- event key
	"FactionTurnStart", -- trigger event 
	function(context)
		return cm:query_model():turn_number() == 7 and context:faction():name() == local_faction_key;
	end, --listener condition
	false, -- fire_once
	campaign_key.."_dilemma_"..local_faction_key.."_dilemma_01_complete", -- completion event 
	nil -- failure event
);

-------------------------------------------------------------------------------
------------------------------------- Turn 10 ----------------------------------
-------------------------------------------------------------------------------
cdir_mission_manager:start_dilemma_db_listener(
	local_faction_key, -- faction_key 
	"3k_dlc04_dilemma_3k_dlc04_faction_tao_qian_dilemma_02", -- event key
	"FactionTurnStart", -- trigger event 
	function(context)
		return cm:query_model():turn_number() == 10 and context:faction():name() == local_faction_key;
	end, --listener condition
	false, -- fire once
	campaign_key.."_dilemma_"..local_faction_key.."_dilemma_02_complete", -- completion event 
	nil -- failure event
);

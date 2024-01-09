---------------------------------------------------
---------------------------------------------------
------------------- VARIABLES ---------------------
---------------------------------------------------
---------------------------------------------------

local campaign_key = "3k_dlc04";
local local_faction_key = "3k_dlc04_faction_empress_he";
local listener_key = "dlc04_" .. local_faction_key;
local success_key = "dlc04_" .. local_faction_key .. "_success";
local failure_key = "dlc04_" .. local_faction_key .. "_failure";

output("Events script loaded for " .. local_faction_key);
setup_shared_faction_events_han_empire(local_faction_key, success_key, failure_key);

-- Spawn initial armies.
local function initial_set_up()
	local invasion = campaign_invasions:create_invasion("3k_dlc04_faction_rebels", "3k_main_henei_capital", 1, true, local_faction_key, true, 361, 481);
	invasion:set_force_retreated();
	invasion:start_invasion();

	-- Give luoyang lumberyard to the Han Empire.
	local query_region = cm:query_region("3k_main_chenjun_resource_3");
	cm:modify_region(query_region):settlement_gifted_as_if_by_payload(cm:modify_faction("3k_main_faction_han_empire"));

	-- Spawn an army in Luoyang Lumberyard.
	campaign_invasions:create_invasion_attack_region("3k_dlc04_faction_rebels", "3k_main_chenjun_resource_3", 3, "3k_main_chenjun_resource_3", true);

	-- Force the rebels to be at war with the han.
	diplomacy_manager:force_declare_war("3k_dlc04_faction_rebels", "3k_main_faction_han_empire", true);
end;

cm:add_first_tick_callback_new(initial_set_up);



---------------------------------------------------
---------------------------------------------------
----------------- Loss Conditions -----------------
---------------------------------------------------
---------------------------------------------------
--[[
	SM: Lose the campaign if the capital is captured/razed. This is a last minute fix due to oddities surrounding the emperor surviving after the capital falls.
	http://totalwar-jira:8080/browse/MAN-4046
	http://totalwar-jira:8080/browse/MAN-4047
]]--

-- Luoyang is captured or razed.
core:add_listener(
	listener_key .. "campaign_loss_luoyang", -- handle
	"CharacterWillPerformSettlementSiegeAction", -- Campaign event
	function(context) -- Criteria

		-- Only fire for Luoyang
		if context:garrison_residence():region():name() == "3k_main_luoyang_capital" then
			local outcome = context:option_outcome_enum_key();

			-- We care about both raze and occupy as they transition the settlement state.
			if outcome == "raze" or outcome == "occupy" then
				return true;
			end;

		end;

		return false;
	end,
	function(context) -- What to do if listener fires.

		-- lose the game by cancelling their custom mission.
		local query_faction = cm:query_faction(local_faction_key);
		cm:modify_faction(query_faction):cancel_custom_mission("3k_main_long_victory");

		core:remove_listener("progression_emperor") -- Remove the progression listener so the three kingdoms movie doesn't play.
	end,
	false -- is persistent
);



---------------------------------------------------
---------------------------------------------------
--------------------- Intro -----------------------
---------------------------------------------------
---------------------------------------------------

core:add_listener(
	listener_key .. "intro_start", -- Unique handle
	"FactionTurnStart", -- Campaign Event to listen for
	function(context) -- Criteria
		return cdir_mission_manager:get_turn_number() == 1 and context:faction():name() == local_faction_key;
	end,
	function(context) -- What to do if listener fires
		core:trigger_event(success_key .. "_fire_intro");
	end,
	false --Is persistent
);

cdir_mission_manager:start_incident_db_listener(
	local_faction_key, -- faction_key
	"3k_dlc04_introduction_empress_he_incident", -- event_key
	success_key .. "_fire_intro", -- trigger event
	function(context)
		return true;
	end, --listener condition
	false, -- fire_once
	success_key.."_Intro_Fired", -- completion event
	nil, -- failure event
	false -- delay start
);

---------------------------------------------------
---------------------------------------------------
------------------- Tutorial ----------------------
---------------------------------------------------
---------------------------------------------------

cdir_mission_manager:start_mission_db_listener(
	local_faction_key, -- faction_key
	"3k_dlc04_mission_3k_dlc04_faction_empress_he_tutorial_01", -- event_key
	success_key.."_Intro_Fired", -- trigger event
	function(context)
		return true;
	end, --listener condition
	false, -- fire_once
	success_key.."_tutorial_01_complete", -- completion event
	success_key.."_tutorial_01_complete", -- failure event
	false -- delay start
);

-- Get positive food
cdir_mission_manager:start_mission_db_listener(
	local_faction_key, -- faction_key 
	"3k_dlc04_mission_3k_dlc04_faction_empress_he_tutorial_02", -- event_key 
	success_key.."_tutorial_01_complete", -- trigger event 
	function(context)
		return true;
	end, --listener condition
	false, -- fire_once.
	success_key.."_tutorial_02_complete", -- completion event 
	success_key.."_tutorial_02_complete", -- failure event
	false -- delay start
);

-- Capture port region
cdir_mission_manager:start_mission_listener(
    local_faction_key,                          		-- faction key
    "3k_dlc04_mission_3k_dlc04_faction_empress_he_tutorial_03",        -- mission key
    "OWN_N_REGIONS_INCLUDING",                                  -- objective type
    {
        "total 2",
        "region 3k_main_luoyang_resource_1"
    },                                                  -- conditions (single string or table of strings)
    {
        "effect_bundle{bundle_key 3k_main_introduction_mission_payload_capture_regions;turns 3;}"
    },                                                  -- mission rewards (table of strings)
	success_key .."_tutorial_01_complete",      -- trigger event 
	nil,												-- Listener condition
	false,							-- Fire once
	success_key.."_tutorial_03_complete",    -- completion event
	success_key.."_tutorial_03_complete",	-- failure event
	"SHOGUN"	--mission_issuer
);

-- Own a province
cdir_mission_manager:start_mission_db_listener(
	local_faction_key, -- faction_key
	"3k_dlc04_mission_3k_dlc04_faction_empress_he_tutorial_04", -- event_key
	success_key .."_tutorial_03_complete", -- trigger event
	function(context) -- returns bool
		return true;
	end, --listener condition
	false, -- fire_once
	success_key .."_tutorial_04_complete", -- completion event
	success_key .."_tutorial_04_complete" -- failed event
);

cdir_mission_manager:start_mission_db_listener(
	local_faction_key, -- faction_key
	"3k_dlc04_mission_3k_dlc04_faction_empress_he_tutorial_05", -- event_key
	success_key .."_tutorial_04_complete", -- trigger event
	function(context) -- returns bool
		return true;
	end, --listener condition
	false, -- fire_once
	success_key .."_tutorial_05_complete", -- completion event
	success_key .."_tutorial_05_failed" -- failed event
);

-- Upgrade the palace. This takes a long time, so issue it early
cdir_mission_manager:start_mission_listener(
    local_faction_key,											-- faction key
    "3k_dlc04_victory_objective_chain_empress_he_7",			-- mission key
    "CONSTRUCT_BUILDINGS_INCLUDING",							-- objective type
    {
		"building_level 3k_district_government_administration_5",
		"faction 3k_dlc04_faction_empress_he",
		"total 1"
    }, 
    {
        "money 10000"
    },															-- mission rewards (table of strings)
	success_key .."_tutorial_05_complete",	-- trigger event 
	nil,														-- Listener condition
	false,														-- Fire once
    "ScriptEventEmpressHeProgressionDLC04Mission07Complete",	-- completion event
	nil,														-- failure event
	"3k_main_victory_objective_issuer"							-- mission_issuer
)

---------------------------------------------------
---------------------------------------------------
------------------ PROGRESSION --------------------
---------------------------------------------------
---------------------------------------------------

-- start the progression missions
core:add_listener(
    "start_progression_missions",
    "DLC04_MandateOfHeavenWarFinished",
	function(context)
		return true;
	end,
    function(context)
        core:trigger_event("ScriptEventEmpressHeProgressionMandateWarComplete");
    end,
    false
);

--Upgrade Emperor Ling's Career CEO when you win the mandate war
core:add_listener(
	"emperor_ling_trait_increase",
	"ScriptEventEmpressHeProgressionMandateWarComplete",
	true,
	function()
		local q_char = cm:query_model():character_for_template("3k_dlc04_template_historical_emperor_ling_earth");
		
		if not q_char or q_char:is_null_interface() then
			return false;
		end;

		if q_char:is_dead() then
			return false;
		end;

		local m_char = cm:modify_character(q_char);

		if not m_char:ceo_management() or m_char:ceo_management():is_null_interface() then
			return false;
		end;

		m_char:ceo_management():change_points_of_ceos("3k_dlc04_ceo_career_historical_emperor_ling",1);
		return true;
	end,
	false
)

---------------------------------------------------
---------------------------------------------------
------------------ POST MANDATE WAR ---------------
---------------------------------------------------
---------------------------------------------------

-- empress he progression mission 3b
cdir_mission_manager:start_mission_listener(
    local_faction_key,											-- faction key
    "3k_dlc04_victory_objective_chain_empress_he_3b",			-- mission key
    "POOLED_RESOURCE_TOTAL_AT_LEAST_X",						-- objective type
    {
		"pooled_resource 3k_dlc04_pooled_resource_warlords_influence",
        "total 30"
    }, 
    {
        "money 10000"
    },															-- mission rewards (table of strings)
	success_key .."_tutorial_05_complete",	-- trigger event 
	nil,														-- Listener condition
	false,														-- Fire once
    success_key .."_mission_3b_complete",	-- completion event
	nil,														-- failure event
	"3k_main_victory_objective_issuer"							-- mission_issuer
)

-- empress he progression mission 3c
cdir_mission_manager:start_mission_listener(
    local_faction_key,											-- faction key
    "3k_dlc04_victory_objective_chain_empress_he_3c",			-- mission key
    "POOLED_RESOURCE_TOTAL_AT_LEAST_X",						-- objective type
    {
		"pooled_resource 3k_dlc04_pooled_resource_dynasty_influence",
        "total 40"
    }, 
    {
        "money 10000"
    },															-- mission rewards (table of strings)
	success_key .."_tutorial_05_complete",	-- trigger event 
	nil,														-- Listener condition
	false,														-- Fire once
    success_key .."_mission_3c_complete",	-- completion event
	nil,														-- failure event
	"3k_main_victory_objective_issuer"							-- mission_issuer
)

-- Remove the other pooled resource mission and trigger the next mission
core:add_listener(
	local_faction_key, --faction_key
	success_key .."_mission_3b_complete", -- Campaign Event to listen for
	true,
	function() -- What to do if listener fires.
		cm:modify_faction(local_faction_key):cancel_custom_mission("3k_dlc04_victory_objective_chain_empress_he_3c")
	end,
	false --Is persistent
);

core:add_listener(
	local_faction_key, --faction_key
	success_key .."_mission_3c_complete", -- Campaign Event to listen for
	true,
	function() -- What to do if listener fires.
		cm:modify_faction(local_faction_key):cancel_custom_mission("3k_dlc04_victory_objective_chain_empress_he_3b")
	end,
	false --Is persistent
);

-- Complete the victory objective
cdir_mission_manager:start_mission_listener(
    local_faction_key,											-- faction key
    "3k_dlc04_victory_objective_chain_empress_he_6",			-- mission key
    "CONTROL_N_REGIONS_INCLUDING",                              -- objective type
    {
        "total 95"
    }, 
    {
        "money 10000"
    },  														-- mission rewards (table of strings)
	"ScriptEventEmpressHeProgressionMandateWarComplete",	-- trigger event 
	nil,														-- Listener condition
	false,														-- Fire once
    "ScriptEventEmpressHeProgressionDLC04Mission06Complete",	-- completion event
	nil,														-- failure event
	"3k_main_victory_objective_issuer"							-- mission_issuer
)

-- #endregion
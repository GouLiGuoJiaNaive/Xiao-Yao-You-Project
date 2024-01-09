--[[
***************************************************
***************************************************
** VARIABLES
***************************************************
***************************************************
]]--
local local_faction_key = "3k_main_faction_sun_jian";
local listener_key = "dlc04_" .. local_faction_key;
local success_key = "dlc04_" .. local_faction_key .. "_success";
local failure_key = "dlc04_" .. local_faction_key .. "_failure";

output("Events script loaded for " .. local_faction_key);
setup_shared_faction_events_han_empire(local_faction_key, success_key, failure_key);

-- Spawn initial armies.
local function initial_set_up()
	local invasion = campaign_invasions:create_invasion("3k_dlc04_faction_rebels", "3k_main_henei_capital", 1, true, local_faction_key, true, 592, 291);
	invasion:set_force_retreated();
	invasion:start_invasion();
end;

cm:add_first_tick_callback_new(initial_set_up);


-- #region Introduction
--[[
***************************************************
***************************************************
** Introduction
***************************************************
***************************************************
]]--

--[[
"3k_dlc04_progression_sun_jian_investment_opportunities_01a_success_dilemma"
"3k_dlc04_progression_sun_jian_investment_opportunities_01b_failure_dilemma"
"3k_dlc04_progression_sun_jian_investment_opportunities_02a_investigated_success_dilemma"
"3k_dlc04_progression_sun_jian_investment_opportunities_02b_investigated_failure_dilemma"
"3k_dlc04_progression_sun_jian_investment_opportunities_03a_outcome_success_incident"
"3k_dlc04_progression_sun_jian_investment_opportunities_03b_outcome_failure_incident"
"3k_dlc04_progression_sun_jian_investment_opportunities_03c_outcome_critical_success_incident"
]]--
-- #endregion
core:add_listener(
	listener_key .. "intro_start", -- Unique handle
	"FactionTurnStart", -- Campaign Event to listen for
	function(context) -- Criteria
		return cdir_mission_manager:get_turn_number() == 1 and context:faction():name() == local_faction_key;
	end,
	function(context) -- What to do if listener fires.

		core:trigger_event(success_key .. "_fire_intro");
	end,
	false --Is persistent
);

-- Intro Event.
cdir_mission_manager:start_incident_db_listener(
	local_faction_key, -- faction_key 
	"3k_dlc04_introduction_sun_jian_incident", -- event_key 
	success_key .. "_fire_intro", -- trigger event 
	function(context)
		return true;
	end, --listener condition
	false, -- fire_once.
	success_key.."_Intro_Fired", -- completion event 
	nil, -- failure event
	false -- delay start
);

cdir_mission_manager:start_mission_db_listener(
	local_faction_key, -- faction_key 
	"3k_dlc04_progression_sun_jian_intro_engage_first_force_mission", -- event_key 
	success_key.."_Intro_Fired", -- trigger event 
	function(context)
		return true;
	end, --listener condition
	false, -- fire_once.
	success_key.."engaged_force", -- completion event 
	success_key.."engaged_force", -- failure event
	false -- delay start
);

cdir_mission_manager:start_mission_listener(
    local_faction_key,                          		-- faction key
    "3k_dlc04_progression_sun_jian_intro_conquer_region_mission",        -- mission key
    "OWN_N_REGIONS_INCLUDING",                                  -- objective type
    {
        "total 2",
        "region 3k_main_jianan_capital"
    },                                                  -- conditions (single string or table of strings)
    {
        "effect_bundle{bundle_key 3k_main_introduction_mission_payload_capture_regions;turns 3;}",
        "money 1000"
    },                                                  -- mission rewards (table of strings)
	success_key.."engaged_force",      -- trigger event 
	nil,												-- Listener condition
	false,							-- Fire once
	success_key.."conquered_region",    -- completion event
	success_key.."conquered_region",	-- failure event
	"SHOGUN"	--mission_issuer
);

cdir_mission_manager:start_mission_db_listener(
	local_faction_key, -- faction_key 
	"3k_dlc04_progression_sun_jian_intro_construct_first_building_mission", -- event_key 
	success_key.."conquered_region", -- trigger event 
	function(context)
		return true;
	end, --listener condition
	false, -- fire_once.
	success_key.."built_building", -- completion event 
	success_key.."built_building", -- failure event
	false -- delay start
);

cdir_mission_manager:start_mission_db_listener(
	local_faction_key, -- faction_key 
	"3k_dlc04_progression_sun_jian_intro_sign_trade_deal_mission", -- event_key 
	success_key.."built_building", -- trigger event 
	function(context)
		return true;
	end, --listener condition
	false, -- fire_once.
	success_key.."trade_deal", -- completion event 
	success_key.."trade_deal", -- failure event
	true -- delay start
);

--Complete Sun Jian's Have any trade agrement mission, if he has a trade agrement when the mission starts
core:add_listener(
    "MissionIssuedSunJianTradeAgreement", -- Unique handle
    "MissionIssued", -- Campaign Event to listen for
    function(context)
		return context:mission():mission_record_key()=="3k_dlc04_progression_sun_jian_intro_sign_trade_deal_mission"
    end,
	function(context) -- What to do if listener fires.
		if context:faction():has_specified_diplomatic_deal_with_anybody("treaty_components_trade") then
			context:modify_model():get_modify_faction(context:faction()):complete_custom_mission("3k_dlc04_progression_sun_jian_intro_sign_trade_deal_mission")
		end
    end,
    false --Is persistent
);

-- #region Investment Opportunities
--[[
***************************************************
***************************************************
** Investment Opportunities
***************************************************
***************************************************
]]--
-- #endregion

-- #region Defeat Pirates
--[[
***************************************************
***************************************************
** Defeat Pirates
***************************************************
***************************************************
]]--
core:add_listener(
	listener_key .. "defeat_pirates", -- Unique handle
	"FactionTurnStart", -- Campaign Event to listen for
	function(context) -- Criteria
		return cdir_mission_manager:get_turn_number() == 2 and context:faction():name() == local_faction_key;
	end,
	function(context) -- What to do if listener fires.
		campaign_invasions:create_invasion("3k_dlc04_faction_rebels", "3k_main_jianan_resource_1", 1, false, "3k_main_faction_sun_jian", true);
		core:trigger_event(success_key .. "defeat_pirates");
	end,
	false --Is persistent
);

cdir_mission_manager:start_mission_db_listener(
	local_faction_key, -- faction_key 
	"3k_dlc04_progression_sun_jian_defeat_pirates_01_mission", -- event_key 
	success_key.."defeat_pirates", -- trigger event 
	function(context)
		return true;
	end, --listener condition
	false, -- fire_once.
	success_key.."defeat_pirates_01", -- completion event 
	success_key.."defeat_pirates_01", -- failure event
	false -- delay start
);

cdir_mission_manager:start_mission_db_listener(
	local_faction_key, -- faction_key 
	"3k_dlc04_progression_sun_jian_defeat_pirates_02_mission", -- event_key 
	success_key.."defeat_pirates_01", -- trigger event 
	function(context)
		campaign_invasions:create_invasion("3k_dlc04_faction_rebels", "3k_main_jianan_resource_2", 1, false, "3k_main_faction_sun_jian", true);
		campaign_invasions:create_invasion("3k_dlc04_faction_rebels", "3k_main_ye_resource_1", 1, false, "3k_main_faction_sun_jian", true);
		campaign_invasions:create_invasion("3k_dlc04_faction_rebels", "3k_main_yuzhang_resource_3", 1, false, "3k_main_faction_sun_jian", true);
		return true;
	end, --listener condition
	false, -- fire_once.
	success_key.."defeat_pirates_02", -- completion event 
	success_key.."defeat_pirates_02", -- failure event
	false -- delay start
);

cdir_mission_manager:start_mission_db_listener(
	local_faction_key, -- faction_key 
	"3k_dlc04_progression_sun_jian_defeat_pirates_03_pirate_lord_mission", -- event_key 
	success_key.."defeat_pirates_02", -- trigger event 
	function(context)
		campaign_invasions:create_invasion("3k_dlc04_faction_rebels", "3k_main_yuzhang_resource_3", 3, false, "3k_main_faction_sun_jian", true); -- Pirate leader.
		return true;
	end, --listener condition
	false, -- fire_once.
	success_key.."defeat_pirates_03", -- completion event 
	success_key.."defeat_pirates_03", -- failure event
	false -- delay start
);

-- #endregion



-- #region Tax Collector
--[[
***************************************************
***************************************************
** Tax Collector
***************************************************
***************************************************
]]--
--[[
core:add_listener(
	listener_key .. "tax_collector", -- Unique handle
	"FactionTurnStart", -- Campaign Event to listen for
	function(context) -- Criteria
		return cdir_mission_manager:get_turn_number() == 4 and context:faction():name() == local_faction_key;
	end,
	function(context) -- What to do if listener fires.

		core:trigger_event(success_key .. "tax_collector");
	end,
	false --Is persistent
);

cdir_mission_manager:start_mission_db_listener(
	local_faction_key, -- faction_key 
	"3k_dlc04_progression_sun_jian_tax_collector_01_mission", -- event_key 
	success_key .. "tax_collector", -- trigger event 
	function(context)
		return true;
	end, --listener condition
	false, -- fire_once.
	success_key.."tax_collector_01", -- completion event 
	success_key.."tax_collector_01", -- failure event
	false -- delay start
);

cdir_mission_manager:start_mission_db_listener(
	local_faction_key, -- faction_key 
	"3k_dlc04_progression_sun_jian_tax_collector_02_mission", -- event_key 
	success_key.."tax_collector_01", -- trigger event 
	function(context)
		return true;
	end, --listener condition
	false, -- fire_once.
	success_key.."tax_collector_02", -- completion event 
	success_key.."tax_collector_02", -- failure event
	false -- delay start
);

-- Cancel the 'impossible' mission when the yt war starts.
core:add_listener(
	listener_key .. "tax_collector_cancel", -- Unique handle
	"DLC04_MandateOfHeavenWarStarted", -- Campaign Event to listen for
	function(context) -- Criteria
		return true;
	end,
	function(context) -- What to do if listener fires.
		local mm = cm:get_mission_manager("3k_dlc04_progression_sun_jian_tax_collector_01_mission");
		local mm2 = cm:get_mission_manager("3k_dlc04_progression_sun_jian_tax_collector_02_mission");
		
		
		mm:cancel_mission();
		mm2:cancel_mission();
		
	end,
	false --Is persistent
);
]]--
-- #endregion



-- #region Progression
--[[
***************************************************
***************************************************
** Progression
***************************************************
***************************************************
]]--
-- start the progression missions
core:add_listener(
    listener_key .. "start_progression_missions",
    "FactionTurnStart",
	function(context)
		return cdir_mission_manager:get_turn_number() == 3 and context:faction():name() == local_faction_key;
	end,
    function(context)
        core:trigger_event("ScriptEventSunJianProgressionDLC04Mission01Trigger");
    end,
    false
);
-- DLC04
-- sun jian progression mission 1
cdir_mission_manager:start_mission_listener(
    local_faction_key,                          		-- faction key
    "3k_dlc04_victory_objective_chain_liu_biao_1",        -- mission key
    "ATTAIN_FACTION_PROGRESSION_LEVEL",                 -- objective type
    {
		"rank_noble"
    },                                                  -- conditions (single string or table of strings)
    {
        "money 2000"
    },                                                  -- mission rewards (table of strings)
	"ScriptEventSunJianProgressionDLC04Mission01Trigger",      -- trigger event 
	nil,												-- Listener condition
	false,												-- Fire once
	"ScriptEventSunJianProgressionDLC04Mission01Complete",     -- completion event
	nil,														-- failure event
	"3k_main_victory_objective_issuer"							--mission_issuer
)

-- sun jian progression mission 2
cdir_mission_manager:start_mission_listener(
    local_faction_key,                          		-- faction key
    "3k_dlc04_victory_objective_chain_sun_jian_2",        -- mission key
    "ATTAIN_FACTION_PROGRESSION_LEVEL",                 -- objective type
    {
        "rank_second_marquis"
    },                                                  -- conditions (single string or table of strings)
    {
        "money 2000"
    },                                                  -- mission rewards (table of strings)
	"ScriptEventSunJianProgressionDLC04Mission01Complete",      -- trigger event 
	nil,												-- Listener condition
	false,												-- Fire once
	"ScriptEventSunJianProgressionDLC04Mission02Complete",     -- completion event
	nil,														-- failure event
	"3k_main_victory_objective_issuer"							--mission_issuer
)

-- sun jian progression mission 3
cdir_mission_manager:start_mission_listener(
    local_faction_key,                          		-- faction key
    "3k_dlc04_victory_objective_chain_sun_jian_3",        -- mission key
    "ATTAIN_FACTION_PROGRESSION_LEVEL",                 -- objective type
    {
        "rank_marquis"
    },                                                  -- conditions (single string or table of strings)
    {
        "money 2000"
    },                                                  -- mission rewards (table of strings)
	"ScriptEventSunJianProgressionDLC04Mission02Complete",      -- trigger event 
	nil,												-- Listener condition
	false,												-- Fire once
	"ScriptEventSunJianProgressionMission01Trigger",     -- completion event
	nil,														-- failure event
	"3k_main_victory_objective_issuer"							--mission_issuer
)

-- MAIN GAME
-- sun jian progression mission 1
cdir_mission_manager:start_mission_listener(
    "3k_main_faction_sun_jian",                          -- faction key
    "3k_main_victory_objective_chain_1_sun_jian",                     -- mission key
    "ATTAIN_FACTION_PROGRESSION_LEVEL",                                  -- objective type
    {
        "rank_duke"
    }, 
    {
        "money 2000"
    },                                                  -- mission rewards (table of strings)
	"ScriptEventSunJianProgressionMission01Trigger",      -- trigger event 
	nil,												-- Listener condition
	false,												-- Fire once
    "ScriptEventSunJianProgressionMission01Complete",     -- completion event
	nil,														-- failure event
	"3k_main_victory_objective_issuer"							--mission_issuer
);

-- sun jian progression mission 02
cdir_mission_manager:start_mission_listener(
    "3k_main_faction_sun_jian",                          -- faction key
    "3k_main_victory_objective_chain_2_han_warlords",                     -- mission key
    "BECOME_WORLD_LEADER",                                  -- objective type
    nil, 
    {
        "money 5000"
    },                                                  -- mission rewards (table of strings)
	"ScriptEventSunJianProgressionMission01Complete",      -- trigger event 
	nil,												-- Listener condition
	false,												-- Fire once
    "ScriptEventSunJianProgressionMission02Complete",     -- completion event
	nil,														-- failure event
	"3k_main_victory_objective_issuer"							--mission_issuer
);

-- sun jian progression mission 03
cdir_mission_manager:start_mission_listener(
    "3k_main_faction_sun_jian",                          -- faction key
    "3k_main_victory_objective_chain_3_han",                     -- mission key
    "DESTROY_ALL_WORLD_LEADERS",                                  -- objective type
    nil, 
    {
        "money 10000"
    },                                                  -- mission rewards (table of strings)
	"ScriptEventSunJianProgressionMission02Complete",      -- trigger event 
	nil,												-- Listener condition
	false,												-- Fire once
    "ScriptEventSunJianProgressionMission03Complete",     -- completion event
	nil,														-- failure event
	"3k_main_victory_objective_issuer"							--mission_issuer
);

-- sun jian progression mission 04
cdir_mission_manager:start_mission_listener(
    "3k_main_faction_sun_jian",                          -- faction key
    "3k_main_victory_objective_chain_4",                     -- mission key
    "CONTROL_N_REGIONS_INCLUDING",                                  -- objective type
    {
        "total 95"
    }, 
    {
        "money 15000"
    },                                                 -- mission rewards (table of strings)
	"ScriptEventSunJianProgressionMission03Complete",      -- trigger event 
	nil,												-- Listener condition
	false,												-- Fire once
    "",     -- completion event
	nil,														-- failure event
	"3k_main_victory_objective_issuer"							--mission_issuer
);
-- #endregion
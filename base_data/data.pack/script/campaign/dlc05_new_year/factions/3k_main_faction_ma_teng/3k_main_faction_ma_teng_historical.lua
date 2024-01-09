-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
------------------------- Ma Teng Historical Missions -------------------------
-------------------------------------------------------------------------------
------------------------- Created by Nic: 04/09/2018 --------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

output("Historical mission script loaded for " .. cm:get_local_faction());


-- ma teng historical mission 02a
start_historical_mission_listener(
    "3k_main_faction_ma_teng",                          -- faction key
    "3k_dlc05_objective_ma_teng_02a",                    -- mission key
    "CONTROL_N_REGIONS_INCLUDING",                                  -- objective type
    {
        "total 1",
        "region 3k_main_changan_capital"
    },                                                  -- conditions (single string or table of strings)
    {
        "effect_bundle{bundle_key 3k_main_historical_mission_payload_02;turns 5;}"
    },                                                  -- mission rewards (table of strings)
    "ScriptEventMaTengIntroductionMission196finish",      -- trigger event 
	"ScriptEventMaTengHistoricalMission02Complete",      -- completion event
	nil,
	"ScriptEventMaTengHistoricalMission02Complete",
	nil,
	25
)

-- ma teng historical mission 03
start_historical_mission_listener(
    "3k_main_faction_ma_teng",                          -- faction key
    "3k_main_objective_ma_teng_03",                     -- mission key
    "DESTROY_FACTION",                                  -- objective type
    {
        "faction 3k_main_faction_cao_cao"
    },                                                  -- conditions (single string or table of strings)
    {
        "effect_bundle{bundle_key 3k_main_historical_mission_payload_03;turns 5;}"
    },                                                  -- mission rewards (table of strings)
    "ScriptEventMaTengHistoricalMission02Complete",      -- trigger event 
    "ScriptEventMaTengHistoricalMission03Complete",     -- completion event
    function()
        if not cm:query_faction("3k_main_faction_cao_cao"):is_dead() then
            return true
        end
    end,                                                -- precondition (nil, or a function that returns a boolean)
	"ScriptEventMaTengHistoricalMission03Failure",      -- failure event
	nil,
	25
)

-- ma teng historical mission 03a
start_historical_mission_listener(
    "3k_main_faction_ma_teng",                          -- faction key
    "3k_main_objective_ma_teng_03a",                    -- mission key
    "CONTROL_N_REGIONS_INCLUDING",                                  -- objective type
    {
        "total 1",
        "region 3k_main_chenjun_capital"
    },                                                  -- conditions (single string or table of strings)
    {
        "effect_bundle{bundle_key 3k_main_historical_mission_payload_03;turns 5;}"
    },                                                  -- mission rewards (table of strings)
    "ScriptEventMaTengHistoricalMission03Failure",      -- trigger event 
	"ScriptEventMaTengHistoricalMission03Complete",      -- completion event
	nil,
	"ScriptEventMaTengHistoricalMission03Complete",
	nil,
	25
)

-- ma teng historical mission 04
start_historical_mission_listener(
    "3k_main_faction_ma_teng",                          -- faction key
    "3k_main_objective_ma_teng_04",                     -- mission key
    "MAKE_ALLIANCE",                                  -- objective type
    {
        "faction 3k_main_faction_liu_bei",
        "faction 3k_dlc05_faction_sun_ce"
    },                                                  -- conditions (single string or table of strings)
    {
        "effect_bundle{bundle_key 3k_main_historical_mission_payload_04;turns 5;}"
    },                                                  -- mission rewards (table of strings)
    "ScriptEventMaTengHistoricalMission03Complete",      -- trigger event 
    "ScriptEventMaTengHistoricalMission04Complete",     -- completion event
    function()
        if not cm:query_faction("3k_main_faction_liu_bei"):is_dead() and not cm:query_faction("3k_main_faction_sun_jian"):is_dead() then
            return true
        end
    end,                                                -- precondition (nil, or a function that returns a boolean)
	"ScriptEventMaTengHistoricalMission04Failure",       -- failure event
	nil,
	25
)

-- ma teng historical mission 04a
start_historical_mission_listener(
    "3k_main_faction_ma_teng",                          -- faction key
    "3k_main_objective_ma_teng_04a",                    -- mission key
    "CONTROL_N_REGIONS_INCLUDING",                                  -- objective type
    {
        "total 6",
        "region 3k_main_luoyang_capital",
        "region 3k_main_chengdu_capital",
        "region 3k_main_weijun_capital",
        "region 3k_main_changsha_capital",
        "region 3k_main_youbeiping_capital",
        "region 3k_main_jianye_capital"
    },                                                   -- conditions (single string or table of strings)
    {
        "effect_bundle{bundle_key 3k_main_historical_mission_payload_04;turns 5;}"
    },                                                  -- mission rewards (table of strings)
    "ScriptEventMaTengHistoricalMission04Failure",      -- trigger event 
	"ScriptEventMaTengHistoricalMission04Complete",      -- completion event
	nil,
	"ScriptEventMaTengHistoricalMission04Complete",
	nil,
	25
)

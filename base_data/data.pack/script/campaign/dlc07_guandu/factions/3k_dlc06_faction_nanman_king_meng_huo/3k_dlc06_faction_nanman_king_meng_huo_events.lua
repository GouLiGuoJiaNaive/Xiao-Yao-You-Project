--[[
***************************************************
***************************************************
** VARIABLES
***************************************************
***************************************************
]]--
local local_faction_key = "3k_dlc06_faction_nanman_king_meng_huo";
local listener_key = "dlc07_" .. local_faction_key .. "_";
local success_key = "dlc07_" .. local_faction_key .. "_success_";
local failure_key = "dlc07_" .. local_faction_key .. "_failure_";

output("Events script loaded for " .. local_faction_key);

nanman_shared_progression_events:setup(local_faction_key, nil, true);

local function initial_set_up()

end;

cm:add_first_tick_callback_new(initial_set_up);


-- #region Intro
--[[
***************************************************
***************************************************
** Intro
***************************************************
***************************************************
]]--

--Triggers the intro event, which starts off all progression missions
core:add_listener(
	listener_key .. "intro_start", -- Unique handle
	"ScriptEventHumanFactionTurnStart", -- Campaign Event to listen for
	function(context) -- Criteria
		return cdir_mission_manager:get_turn_number() == 1 and context:faction():name() == local_faction_key;
	end,
	function(context) -- What to do if listener fires.
		core:trigger_event(success_key .. "fire_intro");
	end,
	false --Is persistent
);

-- #endregion

-- #region Progression

--[[
***************************************************
***************************************************
** PROGRESSION MISSIONS
***************************************************
***************************************************
]]--

-- Defeat King Mulu
cdir_mission_manager:start_mission_listener(
	local_faction_key,                          -- faction key
	"3k_dlc07_mission_meng_huo_mulu",                     -- mission key
	"HAVE_DIPLOMATIC_RELATIONSHIP",                                  -- objective type
	{
		"faction 3k_dlc06_faction_nanman_king_mulu",
		"treaty_component_set 3k_dlc06_objective_treaties_vassal_or_dead",
		"succeed_on_faction_death"
	},                                                  -- conditions (single string or table of strings)
	{
		"money 5000"
	},                                                  -- mission rewards (table of strings)
	success_key .. "fire_intro",      -- trigger event 
	nil,												-- Listener condition
	false,												-- Fire once
	success_key .. "king_mulu",     -- completion event
	success_key .. "king_mulu",														-- failure event
	"3k_main_victory_objective_issuer"							--mission_issuer
)

-- Destroy Shi Xie
cdir_mission_manager:start_mission_listener(
	local_faction_key,                          -- faction key
	"3k_dlc07_mission_meng_huo_shi_xie",                     -- mission key
	"DESTROY_FACTION",                                  -- objective type
	{
		"faction 3k_main_faction_shi_xie",
		"faction 3k_dlc07_faction_shi_hui"
	},   
	{
		"money 5000"
	},                                                    -- mission rewards (table of strings)
	success_key.."king_mulu",      -- trigger event 
	nil,												-- Listener condition
	false,												-- Fire once
	success_key.."shi_xie",		-- completion event
	success_key.."shi_xie",		-- failure event
	"3k_main_victory_objective_issuer"							--mission_issuer
);

-- Defeat King Shamoke
cdir_mission_manager:start_mission_listener(
	local_faction_key,                          -- faction key
	"3k_dlc07_mission_meng_huo_shamoke",                     -- mission key
	"HAVE_DIPLOMATIC_RELATIONSHIP",                                  -- objective type
	{
		"faction 3k_dlc06_faction_nanman_king_shamoke",
		"treaty_component_set 3k_dlc06_objective_treaties_vassal_or_dead",
		"succeed_on_faction_death"
	},                                                  -- conditions (single string or table of strings)
	{
		"money 5000"
	},                                                  -- mission rewards (table of strings)
	success_key .. "fire_intro",      -- trigger event 
	nil,												-- Listener condition
	false,												-- Fire once
	success_key .. "king_shamoke",     -- completion event
	nil,														-- failure event
	"3k_main_victory_objective_issuer"							--mission_issuer
)

-- Conquer Jiangyang commandery
cdir_mission_manager:start_mission_listener(
    local_faction_key,                          -- faction key
    "3k_dlc07_mission_meng_huo_jiangyang",                     -- mission key
    "CONTROL_N_REGIONS_INCLUDING",                                  -- objective type
    {
        "total 4",
		"region 3k_main_jiangyang_capital",
		"region 3k_main_jiangyang_resource_1",
		"region 3k_main_jiangyang_resource_2",
		"region 3k_main_jiangyang_resource_3"
    }, 
    {
        "money 5000"
    },                                                  -- mission rewards (table of strings)
	success_key.."king_shamoke",      -- trigger event 
	nil,												-- Listener condition
	false,												-- Fire once
  	success_key.."jiangyang",     -- completion event
	success_key.."jiangyang",														-- failure event
	"3k_main_victory_objective_issuer"							--mission_issuer
);

-- Conquer the Changsha basin
cdir_mission_manager:start_mission_listener(
    local_faction_key,                          -- faction key
    "3k_dlc07_mission_meng_huo_liu_zhang",                     -- mission key
    "CONTROL_N_REGIONS_INCLUDING",                                  -- objective type
    {
        "total 4",
		"region 3k_main_chengdu_capital",
		"region 3k_main_chengdu_resource_1",
		"region 3k_main_chengdu_resource_2",
		"region 3k_main_chengdu_resource_3"
    }, 
    {
        "money 5000"
    },                                                  -- mission rewards (table of strings)
	success_key.."jiangyang",      -- trigger event 
	nil,												-- Listener condition
	false,												-- Fire once
  	success_key.."chengdu",     -- completion event
	success_key.."chengdu",														-- failure event
	"3k_main_victory_objective_issuer"							--mission_issuer
);

if not cm:query_model():event_generator_interface():have_any_of_incidents_been_generated(cm:query_faction(local_faction_key), "3k_dlc07_incident_meng_huo_jiuzhen_rebellion") then
	--Jiuzhen rebellion incident trigger
	core:add_listener(
		listener_key .. "jiuzhen_rebellion", -- Unique handle
		"ScriptEventHumanFactionTurnStart", -- Campaign Event to listen for
		function(context) -- Criteria
			if context:faction():name() == local_faction_key and cdir_mission_manager:get_turn_number() >= 5 then
				-- If we fail to find a spawn location we'll try next turn until we're able.
				local found_spawn, spawn_x, spawn_y = cm:query_faction(local_faction_key):get_valid_spawn_location_near(217, 180, 3, false)
				return found_spawn;
			end;

			return false;
		end,
		function() -- What to do if listener fires.

			local found_spawn, spawn_x, spawn_y = cm:query_faction(local_faction_key):get_valid_spawn_location_near(217, 180, 3, false)
			
			if found_spawn then
				local modify_rebels_faction = cm:modify_faction("3k_main_faction_jiaozhi")

				local jiuzhen_rebels_spawn = invasion_manager:new_invasion("jiuzhen_rebellion", "3k_main_faction_jiaozhi","", {spawn_x, spawn_y})

				local modify_chen_bai = modify_rebels_faction:create_character_from_template("general", "3k_general_earth", "3k_dlc07_template_generated_chen_bai_hero_earth", true);
				local modify_wan_bing = modify_rebels_faction:create_character_from_template("general", "3k_general_fire", "3k_dlc07_template_generated_wan_bing_hero_fire", true);

				jiuzhen_rebels_spawn:assign_general(modify_chen_bai:query_character():cqi())
				jiuzhen_rebels_spawn:set_target("REGION", "3k_main_jiaozhi_resource_2", local_faction_key);
				jiuzhen_rebels_spawn:start_invasion()

				modify_chen_bai:assign_faction_leader()

				cm:modify_model():get_modify_military_force(modify_chen_bai:query_character():military_force()):add_existing_character_as_retinue(modify_wan_bing, true)

				cm:trigger_incident(local_faction_key, "3k_dlc07_incident_meng_huo_jiuzhen_rebellion", true, true)

			end

		end,
		false --Is persistent
	);
end;
-- #endregion
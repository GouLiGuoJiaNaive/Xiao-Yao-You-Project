--[[ HEADER
	Name: 3k_campaign_progression_extended
	Added: DLC07
	Description: 
		Handles the extended progression - Where a faction is able to spend points when levelling up to increase their caps in certain areas.
		Data is defined for how many points a faction gets each level, how those points are distributed and what effects they give.
		We save the number of points gained into the save file.
		For the AI we use a weighting to define their points distribution, for saved games we use the default distribution to keep parity.
		Script runs validation on game load.
]]--

-- Don't load in campaigns which don't require it.
if cm.name == "ep_eight_princes" then
	output("3k_campaign_progression_extended: Not loaded in this campaign." );
	return;
else
	output("3k_campaign_progression_extended: Loading");
end;

if not progression then -- If the table doesn't exist yet, create it. Allows this to load before/after/independently of the other progression scripts.
	progression = {};
end


--[[ VARIABLES
	Setup variables here.
	Most variables should be 'local' (only in this script). 
	Only add global variables if they need to be accessed outside this script.
]]--

-- Enum - category. Enabled shorthand writing of category keys, will less room for error. 
-- NOTE: these are baked into the save so changing them will have consequences.
local category = {
	ARMIES = "armies";
	ASSIGNMENTS = "assignments";
	SPIES = "spies";
	GOVERNORS = "governors";
	TRADE = "trade";
}

-- References loc keys for the categories.
local category_displays = {
	[category.ARMIES] = {
		title = "extended_progression_category_armies",
		icon = "ui/skins/default/3k_main_progression_icon_armies.png"
	};
	[category.ASSIGNMENTS] = {
		title = "extended_progression_category_assignments",
		icon = "ui/skins/default/3k_main_progression_icon_assignments.png"
	};
	[category.SPIES] = {
		title = "extended_progression_category_spies",
		icon = "ui/skins/default/3k_main_progression_icon_spies.png"
	};
	[category.GOVERNORS] = {
		title = "extended_progression_category_governors",
		icon = "ui/skins/default/3k_main_progression_icon_governors.png"
	};
	[category.TRADE] = {
		title = "extended_progression_category_trade",
		icon = "ui/skins/default/3k_main_progression_icon_trade_agreements.png"
	};
}

-- Defines which subcultures use this mechanic.
local valid_subcultures = {"3k_main_chinese"};

-- A list of factions who do NOT use the mechanic, overrides valid_subcultures,
local ignored_factions = {};

-- Sets a 'default' lookup in-case data hasn't been entered for a specific faction/campaign.
local default_progression_data =  {points_group_key = "default", default_distribution_key = "default", ai_personality_key = "balanced", effects_group_key = "default"};

-- Sets a campaign default, for if a faction hasn't has data set up.
-- Overrides default data.
local campaign_default_progression_data = {
	["3k_dlc04_start_pos"] = {points_group_key = "182_factions", default_distribution_key = "182_factions", ai_personality_key = "balanced", effects_group_key = "default"};
}

-- Based on the 'progression_level_group' key from the db, defines how the faction will behave.
-- Overrides both default and campaign_default data.
local progression_datas = {
-- Dong Zhuo starts at rank 3 in 190.
	["3k_main_progression_level_group_dong_zhuo"] = {points_group_key = "dong_zhuo_190", default_distribution_key = "dong_zhuo_190", ai_personality_key = "warmonger", effects_group_key = "default"};
	["3k_main_progression_level_group_dong_zhuo_ai"] = {points_group_key = "dong_zhuo_190", default_distribution_key = "dong_zhuo_190", ai_personality_key = "warmonger", effects_group_key = "default"};
-- Han Empire faction only has one progression level
	["3k_main_progression_level_group_han_empire_faction"] = {points_group_key = "han_empire", default_distribution_key = "han_empire", ai_personality_key = "balanced", effects_group_key = "default"};
	["3k_dlc04_progression_level_group_han_empire"] = {points_group_key = "han_empire", default_distribution_key = "han_empire", ai_personality_key = "balanced", effects_group_key = "default"};
	["3k_dlc04_progression_level_group_han_empire_ai"] = {points_group_key = "han_empire", default_distribution_key = "han_empire", ai_personality_key = "balanced", effects_group_key = "default"};
-- Liu Chong has his 6 levels in 182/190.
	["3k_dlc04_main_progression_level_group_liu_chong"] = {points_group_key = "182_factions", default_distribution_key = "182_factions", ai_personality_key = "balanced", effects_group_key = "default"};
	["3k_dlc04_main_progression_level_group_liu_chong_ai"] = {points_group_key = "182_factions", default_distribution_key = "182_factions", ai_personality_key = "balanced", effects_group_key = "default"};
-- Empress he/Emperor Ling has just one level.
	["3k_dlc04_progression_level_group_empress_he"] = {points_group_key = "empress_he", default_distribution_key = "empress_he", ai_personality_key = "balanced", effects_group_key = "default"};
	["3k_dlc04_progression_level_group_empress_he_ai"] = {points_group_key = "empress_he", default_distribution_key = "empress_he", ai_personality_key = "balanced", effects_group_key = "default"};
-- Sun Ce gains most cap unlocks from Ambitions, so we'll give him less points.
	["3k_dlc05_progression_level_group_sun_ce"] = {points_group_key = "sun_ce", default_distribution_key = "sun_ce", ai_personality_key = "balanced", effects_group_key = "default"};
	["3k_dlc05_progression_level_group_sun_ce_ai"] = {points_group_key = "sun_ce", default_distribution_key = "sun_ce", ai_personality_key = "balanced", effects_group_key = "default"};
-- Rebels have just one group.
	["3k_main_progression_level_group_rebels_chinese"]  = {points_group_key = "rebels", default_distribution_key = "rebels", ai_personality_key = "balanced", effects_group_key = "default"};
	["3k_dlc04_progression_level_group_rebels_chinese"] = {points_group_key = "rebels", default_distribution_key = "rebels", ai_personality_key = "balanced", effects_group_key = "default"};
-- Shie Xie gets an early governor advantage over his rivals.
	["3k_dlc06_progression_level_shi_xie"] = {points_group_key = "shi_xie", default_distribution_key = "shi_xie", ai_personality_key = "diplomat", effects_group_key = "default"};
	["3k_dlc06_progression_level_shi_xie_ai"] = {points_group_key = "shi_xie", default_distribution_key = "shi_xie", ai_personality_key = "diplomat", effects_group_key = "default"};
-- Gongsun Zan gets no governors in early levels due to his unique mechanics.
	["3k_main_progression_level_group_gongsun_zan"] = {points_group_key = "gongsun_zan", default_distribution_key = "gongsun_zan", ai_personality_key = "balanced", effects_group_key = "default"};
	["3k_main_progression_level_group_gongsun_zan_ai"] = {points_group_key = "gongsun_zan", default_distribution_key = "gongsun_zan", ai_personality_key = "balanced", effects_group_key = "default"};
-- Liu Bei starts unlanded in 190 so only has one army limit.
	["3k_main_progression_level_group_liu_bei"] = {points_group_key = "liu_bei_190", default_distribution_key = "liu_bei_190", ai_personality_key = "balanced", effects_group_key = "default"};
	["3k_main_progression_level_group_liu_bei_ai"] = {points_group_key = "liu_bei_190", default_distribution_key = "liu_bei_190", ai_personality_key = "balanced", effects_group_key = "default"};
}

-- Defines how many points the faction will have at each level, this is TOTAL, not additive
-- First level will generally be the one they start at, which is handles by the default distribution.
local point_groups = {
	["default"] = {4, 8, 12, 18, 24};
	["dong_zhuo_190"] = {12, 18, 24};
	["han_empire"] = {24};
	["182_factions"] = {2, 4, 8, 12, 18, 24};
	["empress_he"] = {16};
	["sun_ce"] = {3, 5, 8, 12, 16, 20};
	["rebels"] = {0};
	["shi_xie"] = {5, 9, 13, 18, 24};
	["gongsun_zan"] = {4, 7, 10, 15, 22};
	["liu_bei_190"] = {2, 7, 11, 16, 24};
	["liu_chong_194"] = {}
}

-- Defines the default distribution of points when starting a new game or loading a save which doesn't contain these changes.
local default_points_distribution = {
	["default"] = {
		{[category.ARMIES] = 3, [category.ASSIGNMENTS] = 1}, -- = 4pts
		{[category.ARMIES] = 3, [category.ASSIGNMENTS] = 2, [category.GOVERNORS] = 1, [category.TRADE] = 1, [category.SPIES] = 1}, -- 8pts
		{[category.ARMIES] = 4, [category.ASSIGNMENTS] = 3, [category.GOVERNORS] = 2, [category.TRADE] = 2, [category.SPIES] = 1}, -- 12pts
		{[category.ARMIES] = 5, [category.ASSIGNMENTS] = 4, [category.GOVERNORS] = 3, [category.TRADE] = 3, [category.SPIES] = 2}, -- 17pts
		{[category.ARMIES] = 7, [category.ASSIGNMENTS] = 5, [category.GOVERNORS] = 4, [category.TRADE] = 5, [category.SPIES] = 3} -- 24pts
	},
	["dong_zhuo_190"] = {
		{[category.ARMIES] = 4, [category.ASSIGNMENTS] = 3, [category.GOVERNORS] = 2, [category.TRADE] = 2, [category.SPIES] = 1}, -- 12pts
		{[category.ARMIES] = 5, [category.ASSIGNMENTS] = 4, [category.GOVERNORS] = 3, [category.TRADE] = 3, [category.SPIES] = 2}, -- 17pts
		{[category.ARMIES] = 7, [category.ASSIGNMENTS] = 5, [category.GOVERNORS] = 4, [category.TRADE] = 5, [category.SPIES] = 3} -- 24pts
	},
	["han_empire"] = {
		{[category.ARMIES] = 8, [category.ASSIGNMENTS] = 4, [category.GOVERNORS] = 4, [category.TRADE] = 8, [category.SPIES] = 0} -- 24pts
	},
	["182_factions"] = {
		{[category.ARMIES] = 1, [category.ASSIGNMENTS] = 1}, -- = 2pts
		{[category.ARMIES] = 3, [category.ASSIGNMENTS] = 1}, -- = 4pts
		{[category.ARMIES] = 3, [category.ASSIGNMENTS] = 2, [category.GOVERNORS] = 1, [category.TRADE] = 1, [category.SPIES] = 1}, -- 8pts
		{[category.ARMIES] = 4, [category.ASSIGNMENTS] = 3, [category.GOVERNORS] = 2, [category.TRADE] = 2, [category.SPIES] = 1}, -- 12pts
		{[category.ARMIES] = 5, [category.ASSIGNMENTS] = 4, [category.GOVERNORS] = 3, [category.TRADE] = 3, [category.SPIES] = 2}, -- 17pts
		{[category.ARMIES] = 7, [category.ASSIGNMENTS] = 5, [category.GOVERNORS] = 4, [category.TRADE] = 5, [category.SPIES] = 3} -- 24pts
	},
	["empress_he"] = {
		{[category.ARMIES] = 3, [category.GOVERNORS] = 5, [category.TRADE] = 3, [category.SPIES] = 5} -- 16pts
	},
	["sun_ce"] = {
		{[category.ARMIES] = 3}, -- 3pts
		{[category.ARMIES] = 3, [category.ASSIGNMENTS] = 1, [category.TRADE] = 1}, -- 5pts
		{[category.ARMIES] = 3, [category.ASSIGNMENTS] = 2, [category.GOVERNORS] = 1, [category.TRADE] = 1, [category.SPIES] = 1}, -- 8pts
		{[category.ARMIES] = 4, [category.ASSIGNMENTS] = 3, [category.GOVERNORS] = 2, [category.TRADE] = 2, [category.SPIES] = 1}, -- 12pts
		{[category.ARMIES] = 5, [category.ASSIGNMENTS] = 3, [category.GOVERNORS] = 3, [category.TRADE] = 3, [category.SPIES] = 2}, -- 16pts
		{[category.ARMIES] = 7, [category.ASSIGNMENTS] = 3, [category.GOVERNORS] = 3, [category.TRADE] = 4, [category.SPIES] = 3} -- 20pts
	},
	["rebels"] = {
		{[category.ARMIES] = 8, [category.GOVERNORS] = 8, [category.TRADE] = 8, [category.SPIES] = 8} -- 16pts
	},
	["shi_xie"] = {
		{[category.ARMIES] = 3, [category.ASSIGNMENTS] = 1, [category.GOVERNORS] = 1}, -- 5pts
		{[category.ARMIES] = 3, [category.ASSIGNMENTS] = 2, [category.GOVERNORS] = 2, [category.TRADE] = 1, [category.SPIES] = 1}, -- 9pts
		{[category.ARMIES] = 4, [category.ASSIGNMENTS] = 3, [category.GOVERNORS] = 3, [category.TRADE] = 2, [category.SPIES] = 1}, -- 13pts
		{[category.ARMIES] = 5, [category.ASSIGNMENTS] = 4, [category.GOVERNORS] = 4, [category.TRADE] = 3, [category.SPIES] = 2}, -- 18pts
		{[category.ARMIES] = 7, [category.ASSIGNMENTS] = 5, [category.GOVERNORS] = 4, [category.TRADE] = 5, [category.SPIES] = 3} -- 24pts
	},
	["gongsun_zan"] = {
		{[category.ARMIES] = 3, [category.ASSIGNMENTS] = 1}, -- = 4pts
		{[category.ARMIES] = 3, [category.ASSIGNMENTS] = 2, [category.TRADE] = 1, [category.SPIES] = 1}, -- 7pts
		{[category.ARMIES] = 4, [category.ASSIGNMENTS] = 3, [category.TRADE] = 2, [category.SPIES] = 1}, -- 10pts
		{[category.ARMIES] = 5, [category.ASSIGNMENTS] = 4, [category.GOVERNORS] = 1, [category.TRADE] = 3, [category.SPIES] = 2}, -- 15pts
		{[category.ARMIES] = 7, [category.ASSIGNMENTS] = 5, [category.GOVERNORS] = 2, [category.TRADE] = 5, [category.SPIES] = 3} -- 22pts
	},
	["liu_bei_190"] = {
		{[category.ARMIES] = 1, [category.ASSIGNMENTS] = 1}, -- = 2pts
		{[category.ARMIES] = 2, [category.ASSIGNMENTS] = 2, [category.GOVERNORS] = 1, [category.TRADE] = 1, [category.SPIES] = 1}, -- 7pts
		{[category.ARMIES] = 3, [category.ASSIGNMENTS] = 3, [category.GOVERNORS] = 2, [category.TRADE] = 2, [category.SPIES] = 1}, -- 11pts
		{[category.ARMIES] = 4, [category.ASSIGNMENTS] = 4, [category.GOVERNORS] = 3, [category.TRADE] = 3, [category.SPIES] = 2}, -- 16pts
		{[category.ARMIES] = 7, [category.ASSIGNMENTS] = 5, [category.GOVERNORS] = 4, [category.TRADE] = 5, [category.SPIES] = 3} -- 24pts
	}
}

-- Defines how the AI will attempts to distribute its points.
local ai_personality_weights = {
	["balanced"] = {[category.ARMIES] = 7, [category.ASSIGNMENTS] = 5, [category.SPIES] = 4, [category.GOVERNORS] = 5, [category.TRADE] = 3};
	["warmonger"] = {[category.ARMIES] = 10, [category.ASSIGNMENTS] = 4, [category.SPIES] = 2, [category.GOVERNORS] = 5, [category.TRADE] = 3};
	["diplomat"] = {[category.ARMIES] = 5, [category.ASSIGNMENTS] = 4, [category.SPIES] = 3, [category.GOVERNORS] = 5, [category.TRADE] = 7};
	["spymaster"] = {[category.ARMIES] = 5, [category.ASSIGNMENTS] = 5, [category.SPIES] = 7, [category.GOVERNORS] = 3, [category.TRADE] = 4};
	["governor"] = {[category.ARMIES] = 5, [category.ASSIGNMENTS] = 5, [category.SPIES] = 3, [category.GOVERNORS] = 7, [category.TRADE] = 4};
}

-- Defines what effects are available when adding points to a category. Also defines the 'max' points in a category.
-- N.B. The first bundle is always the 0 level one (i.e. no points).
local point_effect_groups = {
	["default"] = {
		[category.ARMIES] = {
			"3k_dlc07_bundle_extended_progression_default_armies_00",
			"3k_dlc07_bundle_extended_progression_default_armies_01",
			"3k_dlc07_bundle_extended_progression_default_armies_02",
			"3k_dlc07_bundle_extended_progression_default_armies_03",
			"3k_dlc07_bundle_extended_progression_default_armies_04",
			"3k_dlc07_bundle_extended_progression_default_armies_05",
			"3k_dlc07_bundle_extended_progression_default_armies_06",
			"3k_dlc07_bundle_extended_progression_default_armies_07",
			"3k_dlc07_bundle_extended_progression_default_armies_08"
		},
		[category.ASSIGNMENTS] = {
			"3k_dlc07_bundle_extended_progression_default_assignments_00",
			"3k_dlc07_bundle_extended_progression_default_assignments_01",
			"3k_dlc07_bundle_extended_progression_default_assignments_02",
			"3k_dlc07_bundle_extended_progression_default_assignments_03",
			"3k_dlc07_bundle_extended_progression_default_assignments_04",
			"3k_dlc07_bundle_extended_progression_default_assignments_05",
			"3k_dlc07_bundle_extended_progression_default_assignments_06",
			"3k_dlc07_bundle_extended_progression_default_assignments_07",
			"3k_dlc07_bundle_extended_progression_default_assignments_08"
		},
		[category.SPIES] = {
			"3k_dlc07_bundle_extended_progression_default_spies_00",
			"3k_dlc07_bundle_extended_progression_default_spies_01",
			"3k_dlc07_bundle_extended_progression_default_spies_02",
			"3k_dlc07_bundle_extended_progression_default_spies_03",
			"3k_dlc07_bundle_extended_progression_default_spies_04",
			"3k_dlc07_bundle_extended_progression_default_spies_05",
			"3k_dlc07_bundle_extended_progression_default_spies_06",
			"3k_dlc07_bundle_extended_progression_default_spies_07",
			"3k_dlc07_bundle_extended_progression_default_spies_08"
		},
		[category.GOVERNORS] = {
			"3k_dlc07_bundle_extended_progression_default_governors_00",
			"3k_dlc07_bundle_extended_progression_default_governors_01",
			"3k_dlc07_bundle_extended_progression_default_governors_02",
			"3k_dlc07_bundle_extended_progression_default_governors_03",
			"3k_dlc07_bundle_extended_progression_default_governors_04",
			"3k_dlc07_bundle_extended_progression_default_governors_05",
			"3k_dlc07_bundle_extended_progression_default_governors_06",
			"3k_dlc07_bundle_extended_progression_default_governors_07",
			"3k_dlc07_bundle_extended_progression_default_governors_08"
		},
		[category.TRADE] = {
			"3k_dlc07_bundle_extended_progression_default_trade_00",
			"3k_dlc07_bundle_extended_progression_default_trade_01",
			"3k_dlc07_bundle_extended_progression_default_trade_02",
			"3k_dlc07_bundle_extended_progression_default_trade_03",
			"3k_dlc07_bundle_extended_progression_default_trade_04",
			"3k_dlc07_bundle_extended_progression_default_trade_05",
			"3k_dlc07_bundle_extended_progression_default_trade_06",
			"3k_dlc07_bundle_extended_progression_default_trade_07",
			"3k_dlc07_bundle_extended_progression_default_trade_08"
		}
	}
}


local temporary_points_delta = {};

--[[ LOCAL FUNCTIONS
	Accessible only by this script. Should be defined before they are used in the file.
	Should define as 'local function function_name(params)'
]]--

-- Add local functions here.

-- formed as points_spent[faction_key] = {armies = 0, assignments = 0, spies = 0, governors = 0, trade = 0}
local function get_points_spent()
	if cm:saved_value_exists("points_spent", "extended_progression") then
		return cm:get_saved_value("points_spent", "extended_progression");
	end

	return {};
end;

local function set_points_spent(points_table)
	if not points_table then
		return;
	end;
	cm:set_saved_value("points_spent", points_table, "extended_progression");
end;

--- @function reset_points
--- @desc Wipes out the saves data for the faction.
--- @p string The key of the faction
--- @r nil
local function reset_points(faction_key)
	local points_spent = get_points_spent();

	points_spent[faction_key] = {};

	for k, v in pairs(category) do
		points_spent[faction_key][v] = 0;
	end

	set_points_spent(points_spent);
end;

--- @function should_use_new_progression
--- @desc Test if the faction can use the new progression system.
--- @p string The key of the faction
--- @r bool true if they are valid, else false.
local function should_use_new_progression(faction_key)
	local q_faction = cm:query_faction(faction_key);

	if not q_faction or q_faction:is_null_interface() then
		script_error(string.format("ERROR: Passed in faction [%s] is not a valid faction key.", faction_key));
		return false;
	end;

	return table.contains(valid_subcultures, q_faction:subculture()) and not table.contains(ignored_factions, faction_key);
end;

--- @function get_progression_level_group_key
--- @desc The DB stores the progression level key as 'progression_level_group + level'. To convert this back to a group key, we remove the level from the end.
--- @p string The progression level of the faction
--- @p string The current level of the faction
--- @r string the 'progression_level_group' key
local function get_progression_level_group_key(prog_level, level)

	-- Doing a log10(), rather than tostring() is a teensy bit faster. However log10(0) == inf, so we need a special case.
	local length;
	if level == 0 then
		length = 1;
	else
		length = math.floor(math.log10(level)+1);
	end;

	return string.sub(prog_level, string.len(length), -2)
end;


--- @function get_progression_data
--- @desc Returns the 'progression_datas' for the faction, allowing access to the groups inside. Falls back to a default if one doesn't exist.
--- @p string The key of the faction
--- @r table progression_data
local function get_progression_data(faction_key)
	local q_faction = cm:query_faction(faction_key);
	local group_key = get_progression_level_group_key(q_faction:progression_level_key(), q_faction:progression_level());

	if progression_datas[group_key] then
		return progression_datas[group_key];
	end;

	local campaign_key = cm:query_model():campaign_name();
	if campaign_default_progression_data[campaign_key] then
		return campaign_default_progression_data[campaign_key];
	end;
	
	return default_progression_data;
end;


--- @function get_points_group
--- @desc Returns the 'points_group' for the faction, defining how many points it gains each level. 
--- @p string The key of the faction
--- @r table 'points_group'
local function get_points_group(faction_key)

	if not point_groups[get_progression_data(faction_key).points_group_key] then
		script_error("ERROR: Unable to find points group for faction: " .. faction_key);
		return nil;
	end;

	return point_groups[get_progression_data(faction_key).points_group_key];
end;


--- @function get_point_effect_group
--- @desc Returns the 'points_group' for the faction, defining what effects are available at each level. 
--- @p string The key of the faction
--- @r table 'point_effect_group'
local function get_point_effect_group(faction_key)

	local effect_group_data = point_effect_groups[get_progression_data(faction_key).effects_group_key];
	if not effect_group_data then
		script_error("ERROR: Unable to find effect group for faction: " .. faction_key);
		return nil;
	end;

	return effect_group_data;
end;


--- @function get_ai_weighting_group
--- @desc Returns the 'ai_personality_weights' for the faction, defining what preferences the AI has for points distribution. 
--- @p string The key of the faction
--- @r table 'ai_personality_weights'
local function get_ai_weighting_group(faction_key)
	local personality_key = get_progression_data(faction_key).ai_personality_key;
	
	if not ai_personality_weights[personality_key] then
		script_error("ERROR: Unable to find points group for faction: " .. faction_key .. " personality type:" .. tostring(personality_key));
		return nil;
	end;

	return ai_personality_weights[personality_key];
end;


--- @function get_default_distribution_group
--- @desc Returns the 'default_distribution_group' for the faction, defining what points are defaulted for it's progression level. 
--- @p string The key of the faction
--- @r table 'default_distribution_group'
local function get_default_distribution_group(faction_key)

	if not default_points_distribution[get_progression_data(faction_key).default_distribution_key] then
		script_error("ERROR: Unable to find distribution group for faction: " .. faction_key);
		return nil;
	end;

	return default_points_distribution[get_progression_data(faction_key).default_distribution_key];
end;


--- @function get_points_for_progression_level
--- @desc Returns the max_points for the progression level. 
--- @p string The key of the faction
--- @p number The progression_level we wish to query. If none is passed in, the current progression_level is used.
--- @r number The expected points the faction should have
local function get_points_for_progression_level(faction_key, raw_level)
	local points_group = get_points_group(faction_key);

	local q_faction = cm:query_faction(faction_key);
	local lowest_lvl = q_faction:min_progression_level();
	local highest_level = q_faction:max_progression_level();
	
	raw_level = raw_level or q_faction:progression_level(); -- If no raw_level passed in, we'll assume the current.

	if raw_level > highest_level then -- Clamp the level to our max so we don't go oob.
		raw_level = highest_level;
	end;

	local num_levels_gained = raw_level - lowest_lvl + 1; -- Progression levels can start from 0, or below. We want to get how many levels the faction has gained, rather than the index.

	if not points_group then
		script_error(string.format("get_points_for_progression_level() No points_group for this faction, does it exist? faction [%s], progression level [%i]. levels gained [%i]. Returning 0.", faction_key, raw_level, num_levels_gained));
		return 0;
	elseif not points_group[num_levels_gained] then
		script_error(string.format("get_points_for_progression_level() No points_group for this level, is the data correct?. faction [%s], progression level [%i]. levels gained [%i]. Returning 0.", faction_key, raw_level, num_levels_gained));
		return 0;
	end;

	return points_group[num_levels_gained];
end;


--- @function get_category_max_points
--- @desc Returns the max_points the category can ever have. This is based on the number of effects within the category.
--- @p string The key of the faction
--- @p number The category we wish to query
--- @r number The max number of points in the category
local function get_category_max_points(faction_key, category_key)
	if not table.contains(category, category_key) then
		script_error(string.format("get_category_max_points() Unable to find category named [%s]. Returning 0.", category_key));
		return 0;
	end;

	local effect_group = get_point_effect_group(faction_key);

	if not effect_group[category_key] then
		script_error(string.format("get_category_max_points() Unable to get points for category [%s] as it doesn't have any effect_bundles assigned. Returning 0.", category_key));
		return 0;
	end;

	return #effect_group[category_key] - 1; -- The first element is always the 0 level one.
end;


--- @function get_points_spent_in_category
--- @desc Returns the number of points the faction has spent in the specified category
--- @p string The key of the faction
--- @p number The category we wish to query
--- @r number The current points spent in this category
local function get_points_spent_in_category(faction_key, category_key)
	if not table.contains(category, category_key) then
		script_error(string.format("get_points_spent_in_category() Unable to find category named: %s", category_key));
		return false;
	end;

	local points_spent = get_points_spent();
	-- We assume that if the values do not exist, the faction hasn't gained any points in that category yet. Assigning points will create that entry.
	if not points_spent[faction_key] or not points_spent[faction_key][category_key] then
		return 0;
	end;

	return points_spent[faction_key][category_key];
end;


--- @function get_total_points_spent
--- @desc Gets how many points the faction has spent all together.
--- @p string The key of the faction
--- @r number total points spent
local function get_total_points_spent(faction_key)

	local total_points = 0;

	local points_spent = get_points_spent();

	-- We assume that if the values do not exist, the faction hasn't gained any points in that category yet. Assigning points will create that entry.
	if not points_spent[faction_key] then
		return 0;
	end;

	for category_key, points in pairs(points_spent[faction_key]) do
		total_points = total_points + points;
	end;

	return total_points;
end;


--- @function get_categories_which_can_have_points
--- @desc Creates a list of all categories which are able to have points added to them for that faction.
--- @p string The key of the faction
--- @r nil
local function get_categories_which_can_have_points(faction_key)
	local ret_val = {};
	for key, value in pairs(category) do
		if get_points_spent_in_category(faction_key, value) < get_category_max_points(faction_key, value) then
			table.insert(ret_val, value);
		end;
	end;

	return ret_val;
end;


--- @function lock_progression
--- @desc Sets whether the faction can rank up their progression levels.
--- @p string The key of the faction
--- @r nil
local function lock_progression(faction_key)
	local m_faction = cm:modify_faction(faction_key);
	if not m_faction:is_progression_level_changes_locked() then
		m_faction:lock_progression_level_changes();
	end
end;

--- @function unlock_progression
--- @desc Sets whether the faction can rank up their progression levels.
--- @p string The key of the faction
--- @r nil
local function unlock_progression(faction_key)
	local m_faction = cm:modify_faction(faction_key);
	if m_faction:is_progression_level_changes_locked() then
		m_faction:unlock_progression_level_changes();
	end
end;

--- @function allow_single_progression_rank_up
--- @desc Allows one rank up.
--- @p string The key of the faction
--- @r nil
local function allow_single_progression_rank_up(faction_key)
	local m_faction = cm:modify_faction(faction_key);
	if m_faction:is_progression_level_changes_locked() then
		m_faction:unlock_progression_level_to_allow_x_levels(1);
	end
end;

--- @function assign_points_to_category
--- @desc Assigns a number of points to a specific category for the faction. Creates new values in the points_spent[] table if they do not exist.
--- @p string The key of the faction
--- @p number The category we wish to query
--- @p number The number of points to add. [Default = 1]
--- @r bool true if points assigned, false if not.
local function assign_points_to_category(faction_key, category_key, opt_points_change)
	opt_points_change = opt_points_change or 1;

	if not table.contains(category, category_key) then
		script_error(string.format("assign_points_to_category() Unable to find category named: %s", category_key));
		return false;
	end;

	local points_spent = get_points_spent();

	-- Add the values to our table if we don't have them. Allows it to populate at runtime.
	if not points_spent[faction_key] then
		reset_points(faction_key)
	end;

	if not points_spent[faction_key][category_key] then
		points_spent[faction_key][category_key] = 0;
	end;

	if get_points_spent_in_category(faction_key, category_key) + opt_points_change > get_category_max_points(faction_key, category_key) then
		if get_points_spent_in_category(faction_key, category_key) >= get_category_max_points(faction_key, category_key) then
			script_error(string.format("assign_points_to_category() Unable to assign points to category [%s] as it's reached max points.", category_key));
		else
			script_error(string.format("assign_points_to_category() Unable to assign points to category [%s] as it will go over the max points.", category_key));
		end;

		return false;
	end;

	points_spent[faction_key][category_key] = points_spent[faction_key][category_key] + opt_points_change;

	set_points_spent(points_spent);
	return true;
end;


--- @function update_effect_bundles
--- @desc Goes through and makes sure the correct effect bundles are active for the specified faction. Removing any which are invalid and adding those that are valid.
--- @p string The key of the faction
--- @r nil
local function update_effect_bundles(faction_key)
	local q_faction = cm:query_faction(faction_key);
	local m_faction = cm:modify_faction(q_faction);

	local effects_data = get_point_effect_group(faction_key);

	-- Go thorugh all the category, unlocking their bundles.
	for key, category_key in pairs(category) do
		local total_points_invested = get_points_spent_in_category(faction_key, category_key);

		if not effects_data[category_key] then
			script_error(string.format("update_effect_bundles() Unable to update bonus values for category [%s] as it doesn't have any.", category_key));
			return;
		end;

		for i, bundle_key in ipairs(effects_data[category_key]) do

			-- Enable the bundle for our level. Subract one from the iterarator to allow for values at 0 index (the default if no points)
			if i - 1 == total_points_invested then
				if not q_faction:has_effect_bundle(bundle_key) then
					m_faction:apply_effect_bundle(bundle_key, 0); -- Enable the bundle forever
				end;
			-- Disable all other bundles if they're enabled.
            elseif q_faction:has_effect_bundle(bundle_key) then
                m_faction:remove_effect_bundle(bundle_key);
            end
        end
    end
end;


--- @function process_ai_rank_up
--- @desc Using a faction and personality will assign points to different categories for the faction.
--- @p string The key of the faction
--- @p string OPTIONAL The key of the personality to use
--- @r nil
local function process_ai_rank_up(faction_key)
	local weighting_group_data = get_ai_weighting_group(faction_key);

	if not weighting_group_data then
		script_error(string.format("process_ai_rank_up() No personality key for faction [%s].", faction_key));
		return false;
	end;

	-- The number of points is the expected total - the current points.
	local points_to_give = get_points_for_progression_level(faction_key) - get_total_points_spent(faction_key);

	while points_to_give > 0 do
		local valid_categories = get_categories_which_can_have_points(faction_key);

		if #valid_categories < 1 then
			script_error(string.format("process_ai_rank_up() No category can have points added for this faction [%s].", faction_key));
			return;
		end;

		local sum_weight = 0;
		-- sum the weightings for our valid category.
		for i, category_key in ipairs(valid_categories) do
			sum_weight = sum_weight + weighting_group_data[category_key];
		end;

		local seek_value = cm:random_int(1, sum_weight);
		for i, category_key in ipairs(valid_categories) do
			-- subtract our weight from the seek_Value
			seek_value = seek_value - weighting_group_data[category_key];

			-- If we've hit 0 this is the mission we'll fire
			if seek_value <= 0 then
				assign_points_to_category(faction_key, category_key, 1);
				points_to_give = points_to_give - 1;
				break;
			end;
		end;
	end;

	update_effect_bundles(faction_key);
end;


--- @function distribute_initial_points
--- @desc Using the defined data, distribute points to the faction. Used for new game and loading saves.
--- @p string The key of the faction
--- @r nil
local function distribute_initial_points(faction_key)
	local q_faction = cm:query_faction(faction_key);
	local default_distribution = get_default_distribution_group(faction_key);
	local current_lvl = q_faction:progression_level();
	local lowest_lvl = q_faction:min_progression_level();

	reset_points(faction_key);

	local num_levels_gained = current_lvl - lowest_lvl + 1; -- Progression levels can start from 0, or below. We want to get how many levels the faction has gained, rather than the index.

	for i, dist_level in ipairs(default_distribution) do
		-- Exit once we reach the current level.
		if i > num_levels_gained then
			break;
		end;

		for category_key, points in pairs(dist_level) do
			local points_to_add = points - get_points_spent_in_category(faction_key, category_key);
			if points_to_add > 0 then
				assign_points_to_category(faction_key, category_key, points_to_add);
			end;
		end;
	end;

	update_effect_bundles(faction_key);
end;



--[[ GLOBAL FUNCTIONS
	Accessible both inside and outside of this script.
	Should define as 'function my_class_name:function_name(params)'
]]--

-- Add global functions here.



--[[ INITIALISATION
	Handles installing the script into the game logic.
]]--

-- Setup the system values.
local function first_time_setup()
	-- At the start of a new game, go through all the factions and assign their initial points.
	local all_factions = cm:query_model():world():faction_list();
	all_factions:foreach(function(q_faction) 
		if should_use_new_progression(q_faction:name()) then
			distribute_initial_points(q_faction:name())
		end;
	end);
end;

local function lock_progression_all_factions()
	-- At the start of a new game, go through all the factions and assign their initial points.
	local all_factions = cm:query_model():world():faction_list():filter(function(f) return not f:is_dead() end); -- Filter out dead factions or the game will crash...
	all_factions:foreach(function(q_faction) 
		-- Prevent human faction from levelling up until we say so.
		if q_faction:is_human() and should_use_new_progression(q_faction:name()) then
			lock_progression(q_faction:name());
		else
			-- We found some saves where factions had gotten their progression locked but were AI. This will help dislodge that issue when reloading.
			unlock_progression(q_faction:name());
		end;
	end);
end;


local function add_listeners()
	-- Local helper functions
	local function reset_temporary_points()
		-- Create an empty table of temporary points.
		temporary_points_delta = {};
		for _, v in pairs(category) do
			temporary_points_delta[v] = 0;
		end;
	end;

	local function set_ui_values(faction_key, points_remaining)
		local points_spent = get_points_spent();
		local is_enabled = 0;
		if should_use_new_progression(faction_key) then
			is_enabled = 1;
		end;
		effect.set_context_value("extended_progression_data_is_enabled", is_enabled);
		effect.set_context_value("extended_progression_data_current_points", points_spent[faction_key] or 0);
		effect.set_context_value("extended_progression_data_remaining_points", points_remaining or 0);
		effect.set_context_value("extended_progression_data_effect_bundles", get_point_effect_group(faction_key) or 0);
		effect.set_context_value("extended_progression_data_category_displays", category_displays);
		effect.set_context_value("extended_progression_data_temporary_points", temporary_points_delta or 0);
	end

	-- SYSTEM LISTENERS
	-- When an AI faction levels up, auto-distribute the points.
	core:add_listener(
		"extended_progression",
		"FactionFameLevelUp",
		function(context)
			return should_use_new_progression(context:faction():name());
		end,
		function(context)
			local faction_key = context:faction():name();

			if not context:faction():is_human() then
				process_ai_rank_up(faction_key);
			else
				reset_temporary_points(); -- If we don't reset, they'll remain on the panel.

				set_ui_values(faction_key,
					get_points_for_progression_level(faction_key, context:faction():progression_level() + 1) - get_total_points_spent(faction_key) -- remaining points
				);
			end;
		end,
		true
	);

	-- LEVEL UP AVAILABLE
	-- We fire an incident when the player can level up which has a special category and opens a custom panel.
	core:add_listener(
		"extended_progression",
		"FactionFameLevelUpReady",
		function(context)
			return context:faction():is_human() and should_use_new_progression(context:faction());
		end,
		function(context)
			cm:trigger_incident(context:faction():name(), "ui_prompt_progression_available", true);
		end,
		true
	);


	-- UI LISTENERS

	-- CURRENT POINTS DISPLAY
	-- Send the current points to the UI when the faction summary panel is opened.
	-- Sent only for the current faction.
	core:add_listener(
		"extended_progression",
		"PanelOpenedCampaign",
		function(context)
			return context:component_id() == "faction_summary_panel";
		end,
		function(context)
			-- Create a callback so we have the model interface.
			context:create_model_callback_request("extended_progression_faction_summary_opened");
		end,
		true
	);

	core:add_listener(
		"extended_progression",
		"CampaignModelScriptCallback",
		function(context)
			local faction_key = context:query_model():world():whose_turn_is_it():name();-- The callback doesn't give us a faction so we'll assume it's the current.

			return context:context():event_id() == "extended_progression_faction_summary_opened" and should_use_new_progression(faction_key);
		end,
		function(context)
			local q_faction = context:query_model():world():whose_turn_is_it(); -- The callback doesn't give us a faction so we'll assume it's the current.
			local faction_key = q_faction:name();

			-- Send the current points spend/remaining to the ui.
			reset_temporary_points();

			set_ui_values(faction_key,
				get_points_for_progression_level(faction_key, q_faction:progression_level() + 1) - get_total_points_spent(faction_key) -- remaining points
			);
		end,
		true
	);


	-- POINT ALLOCATION
	-- When the panel assigns points, we store them in a local variable.
	core:add_listener(
        "extended_progression", -- UID
        "ModelScriptNotificationEvent", -- Event
		function(event)
            return string.find(event:event_id(), "extended_progression_add_points");
        end, --Conditions for firing
		function(event)
			local q_faction = event:faction():query_faction();
			local faction_key = q_faction:name();
			local split_arr = string.split(event:event_id(), ";");
			local total_points_available = get_points_for_progression_level(faction_key, q_faction:progression_level() + 1);

			if not split_arr or not is_table(split_arr) then
				script_error("Extended Progression: Empty split_array passed in.")
				return false;
			end;
				
			if #split_arr < 3 or (#split_arr - 1) % 2 ~= 0 then
				script_error(string.format("Extended Progression: split_array does not have the correct number of values (Expected: 1+2*, Revieved: %i).", #split_arr));
				return false;
			end;

			for i = 2, #split_arr, 2 do
				local category_key = split_arr[i];
				local points_change = split_arr[i+1];

				local total_temp_points = 0;
				for k, v in pairs(temporary_points_delta) do
					total_temp_points = total_temp_points + v;
				end;

				if total_points_available - get_total_points_spent(faction_key) - total_temp_points - points_change >= 0 then
					local current_temp_points = temporary_points_delta[category_key] or 0;
					current_temp_points = current_temp_points + points_change;

					temporary_points_delta[category_key] = math.clamp(current_temp_points, 0, get_category_max_points(faction_key, category_key) - get_points_spent_in_category(faction_key, category_key));
				end
			end;

			-- Get the temp points again here as the user may have changed them.
			local total_temp_points = 0;
			for k, v in pairs(temporary_points_delta) do
				total_temp_points = total_temp_points + v;
			end;

			set_ui_values(faction_key,
				total_points_available - get_total_points_spent(faction_key) - total_temp_points -- remaining points
			);
        end, -- Function to fire.
        true -- Is Persistent?
	);


	-- APPLICATION
	-- When applied, we apply the temp points to the true values and update effect bundles.
	core:add_listener(
        "extended_progression", -- UID
        "ModelScriptNotificationEvent", -- Event
        function(event)
            return string.find(event:event_id(), "extended_progression_apply_points");
        end, --Conditions for firing
		function(event)
			local q_faction = event:faction():query_faction();
			local faction_key = q_faction:name();
			
			for i, category_key in pairs(category) do
				local points_to_add = temporary_points_delta[category_key];

				if points_to_add > 0 then
					assign_points_to_category(faction_key, category_key, points_to_add);
				end;
			end;

			reset_temporary_points(); -- If we don't reset, they'll remain on the panel.

			set_ui_values(faction_key,
				get_points_for_progression_level(faction_key, q_faction:progression_level() + 1) - get_total_points_spent(faction_key) -- remaining points
			);

			update_effect_bundles(faction_key); -- Apply effect bundles before rankUp so that systems looking for the bonuses can see them.

			-- Level up the faction.
			allow_single_progression_rank_up(faction_key);
        end, -- Function to fire.
        true -- Is Persistent?
	);


	-- CANCEL
	-- If the user cancels, we'll reset the temprary points.
	core:add_listener(
        "extended_progression", -- UID
        "ModelScriptNotificationEvent", -- Event
        function(event)
            return string.find(event:event_id(), "extended_progression_cancel_allocation");
        end, --Conditions for firing
		function(event)
			local q_faction = event:faction():query_faction();
			local faction_key = q_faction:name();

			reset_temporary_points();

			local total_points_available = get_points_for_progression_level(faction_key, q_faction:progression_level() + 1);
			local total_temp_points = 0;
			for k, v in pairs(temporary_points_delta) do
				total_temp_points = total_temp_points + v;
			end;

			set_ui_values(faction_key,
				total_points_available - get_total_points_spent(faction_key) - total_temp_points -- remaining points
			);
        end, -- Function to fire.
        true -- Is Persistent?
	);
end;

-- Adds the listeners which control the script's functionality.
local function add_debug_listeners()
	-- Example: trigger_cli_debug_event progression.debugdebug(3k_main_faction_cao_cao,armies,1)
	core:add_cli_listener("progression.debugdebug", 
		function() 
			local event_id = "extended_progression_add_points;assignments;1"


			local split_arr = string.split(event_id, ";");

			if not split_arr or #split_arr < 3 or (#split_arr - 1) % 2 ~= 0 then
				script_error("Empty split_array passed in or does not have the correct values.")
				return false;
			end;

			for i = 2, #split_arr, 2 do
				local category_key = split_arr[i];
				local num_points = split_arr[i+1];

				temporary_points_delta[category_key] = temporary_points_delta[category_key] + num_points;
			end;
		end 
	);

	-- Example: trigger_cli_debug_event progression.debug_add_points(3k_main_faction_cao_cao,armies,1)
	core:add_cli_listener("progression.debug_add_points", 
		function(faction_key, category_key, points) 
			assign_points_to_category(faction_key, category_key, points);
			update_effect_bundles(faction_key);
		end 
	);

	-- Example: trigger_cli_debug_event progression.simulate_ai_rank_up(3k_main_faction_cao_cao,warmonger)
	core:add_cli_listener("progression.simulate_ai_rank_up",
		function(faction_key)
			process_ai_rank_up(faction_key)
		end
	);

	-- Example: trigger_cli_debug_event progression.print_all_values()
	core:add_cli_listener("progression.print_all_values",
		function()
			output("--------------------- OUTPUT START -----------------------");
			output("");
			local points_spent = get_points_spent();
			for faction_key, pts_table in pairs(points_spent) do
				output(string.format("[%s]:", faction_key));

				-- Output What data the faction uses.
				local q_faction = cm:query_faction(faction_key);
				local group_key = get_progression_level_group_key(q_faction:progression_level_key(), q_faction:progression_level());
				local data = get_progression_data(faction_key);
				output("\tData Used:");
				output(string.format("\t\tProgression Group Key: %s", group_key));
				output(string.format("\t\tProgression Level: %i", q_faction:progression_level()));
				output(string.format("\t\tPoints Data Key: %s", data.points_group_key));
				output(string.format("\t\tAI Personality Key: %s", data.effects_group_key));

				-- Output Points Spent
				output("\tPoints Spent:");
				output(string.format("\t\tTOTAL: %s", get_total_points_spent(faction_key)));
				for category_key, points in pairs(pts_table) do
					output(string.format("\t\t%s = %i", category_key, points));
				end;

				-- Output active effects.
				output("\tEffects:");
				local q_faction = cm:query_faction(faction_key);
				for k, category_key in pairs(category) do
					for l, bundle_key in pairs(get_point_effect_group(faction_key)[category_key]) do
						if q_faction:has_effect_bundle(bundle_key) then
							output(string.format("\t\t%s", bundle_key));
						end
					end
				end;
				output("");
				output("--------------------------");
				output("");
			end;
			output("");
			output("--------------------- OUTPUT END -----------------------");
		end
	);
end;


-- Validate the data we pass in, throwing script_errors for problems.
local function validate_progression_setups()
	-- Data validation
	for k, v in pairs(progression_datas) do
		if not v.default_distribution_key or not default_points_distribution[v.default_distribution_key] then
			script_error(string.format("ERROR: validate_progression() DATA progression_data group [%s] has no valid default_distribution_key of [%s].",  tostring(k), tostring(v.default_distribution_key)));
		end;

		if not v.effects_group_key or not point_effect_groups[v.effects_group_key] then
			script_error(string.format("ERROR: validate_progression() DATA progression_data group [%s] has no valid effects_group_key of [%s].", tostring(k), tostring(v.effects_group_key)));
		end;

		if not v.points_group_key or not point_groups[v.points_group_key] then
			script_error(string.format("ERROR: validate_progression() DATA progression_data group [%s] has no valid points_group_key of [%s]", tostring(k), tostring(v.points_group_key)));
		end;

		if not v.ai_personality_key or not ai_personality_weights[v.ai_personality_key] then
			script_error(string.format("ERROR: validate_progression() DATA progression_data group [%s] has no valid ai_personality_key of [%s].", tostring(k), tostring(v.ai_personality_key)));
		end;
	end;

	-- Faction link validation
	cm:query_model():world():faction_list():foreach(function(q_faction)
		local faction_key = q_faction:name();

		if not should_use_new_progression(faction_key) then
			return;
		end;
	
		-- Validate levels match.
		local num_lvls = q_faction:num_progression_levels();

		local prog_group_key = get_progression_level_group_key(q_faction:progression_level_key(), q_faction:progression_level());
		-- Check we have enough points groups for our levels.
		if table.length(get_points_group(faction_key)) ~= num_lvls then
			script_error(string.format("ERROR: validate_progression() POINTS_GROUPS Faction [%s] has %i levels, but the points_group has %i levels. Group [%s]", 
				faction_key, num_lvls, table.length(get_points_group(faction_key)), prog_group_key));
		end;

		if table.length(get_default_distribution_group(faction_key)) ~= num_lvls then
			script_error(string.format("ERROR: validate_progression() DISTRIBUTION_GROUPS Faction [%s] has %i levels, but the default_distribution_group has %i levels. Group [%s]", 
				faction_key, num_lvls, table.length(get_default_distribution_group(faction_key)), prog_group_key));
		end;
	end)
end;


-- Fires on the first tick of a New Campaign
cm:add_first_tick_callback_new(function()
	output("3k_campaign_progression_extended: New Game");

	first_time_setup();
	lock_progression_all_factions();
end);


-- Fires on the first tick of every game loaded.
cm:add_first_tick_callback(function()
	output("3k_campaign_progression_extended: Loaded Game");

	validate_progression_setups();

	-- Check if the save contains our progression system. If it doesn't we'll initialise it.
	if not cm:saved_value_exists("points_spent", "extended_progression") then
		first_time_setup();
	end;

	lock_progression_all_factions();

	add_debug_listeners();

	add_listeners();
end);
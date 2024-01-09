
--[[ HEADER
	Name: 3k_campaign_progression_groups.lua
	Description: 
		DLC04 - Progression Groups - Added so that we can deal with factions having different progression level criteria in different campaigns.
		For example, different factions could unlock the faction council at different times, based on their campaign's progression level setup.

]]--


--[[ VARIABLES
	Setup variables here.
	Most variables should be 'local' (only in this script). 
	Only add global variables if they need to be accessed outside this script.
]]--
if not progression then -- If the table doesn't exist yet, create it. Allows this to load before/after/independently of the other progression scripts.
	progression = {};
end

-- The default progression group to use if we don't match any other ones.
local progression_group_default = "default";

-- Lookups for the progression_groups. Used to generate a best match on which to use
local progression_group_lookups =
{
	--Example: {group = "", priority = 1 (higher is more important), campaign = "", faction = "", subculture = "", culture = ""}
	{group = "dlc04_default", priority = 1, campaign = "3k_dlc04_start_pos"},
	{group = "dlc04_han_dynasty", priority = 1, campaign = "3k_dlc04_start_pos", faction = "3k_dlc04_faction_empress_he"},
	{group = "dlc05_bandits", priority = 2, subculture = "3k_dlc05_subculture_bandits"},
	{group = "dlc06_nanman", priority = 2, subculture = "3k_dlc06_subculture_nanman"},
	{group = "dlc05_default", priority = 2, campaign = "3k_dlc05_start_pos", faction = "3k_dlc04_faction_prince_liu_chong"}
}

-- Progression groups which define the features which are unlocked and when. Please only use numbers as the indexes as this will break the script.
local progression_groups = {
	["default"] = -- Default for 3k_main factions.
	{
		[1] = { -- 1 -- Noble (was 0)
			"rank_noble",
			"faction_council"
		},
		[2] = { -- 2 -- Second Marquis (was 1)
			"rank_second_marquis",
			"tax_slider",
			"coalitions"
		},
		[3] = { -- 3 -- Marquis (was 2)
			"rank_marquis",
			"alliances"
		}, 
		[4] = { -- 4 -- Duke (was 3)
			"rank_duke",
			"play_movie_warlords",
			"emperor_capture_bonus"
		},
		[5] = { -- 5 -- King (was 4)
			"rank_king"
		}
	},
	["dlc04_default"] = -- Default for dlc04 factions. We added an extra progression level.
	{
		[0] = { -- 0 -- Governor
			"rank_governor"
		},
		[1] = { -- 1 -- Noble
			"rank_noble"
		},
		[2] = { -- 2 -- Second Marquis
			"rank_second_marquis",
			"tax_slider",
			"faction_council",
			"coalitions"
		},
		[3] = { -- 3 -- Marquis
			"rank_marquis",
			"alliances"
		},
		[4] = { -- 4 -- Duke
			"rank_duke",
			"play_movie_warlords",
			"emperor_capture_bonus"
		},
		[5] = { -- 5 -- King
			"rank_king"
		}
	},
	["dlc04_han_dynasty"] = -- Han Dynasty in DLC04 campaign. Only one level as they've already ascended.
	{
		{ -- 0 -- Emperor
			"rank_governor",
			"rank_noble",
			"rank_second_marquis",
			"rank_marquis",
			"rank_duke",
			"rank_king",
			"tax_slider",
			"faction_council",
			"emperor_capture_bonus",
			"coalitions",
			"alliances"
		}
	},
	["dlc05_bandits"] = --Bandit faction was changed in DLC05 
	{
		[0] = { -- 1 -- Outlaw
			"rank_noble"
		},
		[1] = { -- 2 -- Bandit
			"rank_second_marquis",
			"tax_slider",
			"faction_council",
			"coalitions"
		},
		[2] = { -- 3 -- Raider
			"rank_marquis",
			"alliances"
		}, 
		[3] = { -- 4 -- Bandit Leader
			"rank_duke",
			"play_movie_warlords",
			"emperor_capture_bonus"
		},
		[4] = { -- 5 -- Bandit King/Queen 
			"rank_king"
		}
	},
	["dlc06_nanman"] = 
	{
		[0] = { -- Headsman
			"rank_governor"
		},
		[1] = {
			"rank_noble",
			"tax_slider"
		},
		[2] = {
			"rank_second_marquis"
		},
		[3] = {
			"rank_marquis"
		}, 
		[4] = {
			"rank_duke"
		},
		[5] = { 
			"rank_king"
		}
	},
	["dlc05_default"] = 
	{
		[0] = { -- Noble
			"rank_noble"
		},
		[1] = { -- Second Marquis
			"rank_second_marquis",
			"tax_slider",
			"faction_council",
			"coalitions"
		},
		[2] = { -- Marquis
			"rank_marquis",
			"alliances"
		}, 
		[3] = { -- Duke/Prince
			"rank_duke",
			"play_movie_warlords",
			"emperor_capture_bonus"
		},
		[4] = { -- King
			"rank_king"
		}
	}
}



--[[ LOCAL FUNCTIONS
	Accesible only by this script. Should be defined before they are used in the file.
	Should define as 'local function function_name(params)'
]]--

--- @function get_progression_group
--- @desc Gets the best patch progression group based on faction_key, campaign_key, culture_key, subculture_key
--- @p string faction_key
--- @p string campaign_key
--- @p string culture_key
--- @p string subculture_key
--- @r progression_group
local function impl_get_best_progression_group(faction_key, campaign_key, culture_key, subculture_key)
	local highest_scoring_group = progression_group_default; -- the group to return if we matched nothing.
	local highest_score = -1;
	local highest_priority = -1;
	
	for index, lookup in pairs(progression_group_lookups) do
		local score = -1;

		if lookup.faction == faction_key then -- We matched our value
			score = score + 40;
		elseif lookup.faction and lookup.faction ~= "" then -- It has a different value
			score = score - 10000;
		end;
		
		if lookup.subculture == subculture_key then -- We matched our value
			score = score + 30;
		elseif lookup.subculture and lookup.subculture ~= "" then -- It has a different value
			score = score - 10000;
		end;

		if lookup.culture == culture_key then -- We matched our value
			score = score + 20;
		elseif lookup.culture and lookup.subculture ~= "" then -- It has a different value
			score = score - 10000;
		end;

		if lookup.campaign == campaign_key then -- We matched our value
			score = score + 10;
		elseif lookup.campaign and lookup.campaign ~= "" then -- It has a different value
			score = score - 10000;
		end;

		-- Test if we got a higher value.
		if score > highest_score and lookup.priority >= highest_priority then
			highest_scoring_group = lookup.group;
			highest_priority = lookup.priority;
			highest_score = score;
		end;
	end;

	local retVal = progression_groups[highest_scoring_group];

	if retVal then
		return retVal;
	end;

	script_error("Error unable to find group match on the follwing criteria. [faction: " .. faction_key .. "] [campaign: " .. campaign_key .. "] [subculture: " .. subculture_key .. "] [culture_key: " .. culture_key .. "]");
	return nil;
end;



--[[ GLOBAL FUNCTIONS
	Accessible both inside and outside of this script.
	Should define as 'function my_class_name:function_name(params)'
]]--

--- @function force_from_general_cqi
--- @desc Checks whether the faction has unlocked feature x based on their progression level.
--- @p string/QUERY_FACTION_INTERFACE the key/or query interface of the faction to test
--- @p string the feature to test
--- @p bool Only test the level passed in, not any of its predecessors.
--- @r true if unlocked, false if not.
function progression:has_progression_feature(query_faction, feature, only_current)
	only_current = only_current or false;

	if not is_query_faction(query_faction) then
		query_faction = cm:query_faction(query_faction);
	end;

	local faction_progression_level = query_faction:progression_level();
	local feature_level_index = self:get_progression_level_for_feature(query_faction, feature);

	-- this will ne nil if we didnt find it.
	if not feature_level_index then
		output("WARNING: progression:has_progression_feature() Feature doesn't exist for current faction. This may be intended. Key= " .. tostring(feature));
		return false;
	end;

	-- If we only check our level it must match, otherwise must be lower.
	local has_feature_current = only_current and feature_level_index == faction_progression_level;
	local has_feature_not_current = not only_current and feature_level_index <= faction_progression_level;
	if has_feature_not_current or has_feature_current then
		return true;
	end

	return false;
end;

function progression:get_progression_level_for_feature(query_faction, feature)
	if not is_query_faction(query_faction) then
		query_faction = cm:query_faction(query_faction);
	end;

	local faction_key = query_faction:name();
	local campaign_key = cm:query_model():campaign_name();
	local faction_culture_key = query_faction:culture();
	local faction_subculture_key = query_faction:subculture();

	local prog_group = impl_get_best_progression_group(faction_key, campaign_key, faction_culture_key, faction_subculture_key);

	if not prog_group then
		script_error("ERROR: progression:get_progression_level_for_feature() Unable to find progression group. " .. faction_key);
		return false;
	end;

	for i, prog_level in pairs(prog_group) do

		if not is_number(i) then
			script_error("ERROR: progression:get_progression_level_for_feature() Invalid index assigned, please only use numbers. " .. tostring(i));
			return nil;
		end;

		-- Go through each 'feature' and test if it matches ours.
		for j, v in ipairs(prog_level) do
			if v == feature then
				return i;
			end;
		end;
	end;

	return nil;
end;
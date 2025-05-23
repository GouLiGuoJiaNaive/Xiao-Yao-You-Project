--[[
***************************************************
***************************************************
** Lu Zhi Faction CEOs
***************************************************
***************************************************
]]--

-- Create a new faction_ceo object.
local lz_faction_ceos = {
	lz_faction_key = "3k_dlc04_faction_lu_zhi";
	ceo_category_key = "3k_dlc04_ceo_category_factional_lu_zhi";
	listener_name = "lz_faction_ceos3k_dlc04_faction_lu_zhi";
	system_id = "lz_faction_ceos_3k_dlc04_faction_lu_zhi";
	locked_ceo_suffix = "_locked";
}

out("dlc04_faction_ceos_lu_zhi.lua: Loading");

cm:add_first_tick_callback(function() lz_faction_ceos:initialise() end); --Self register function


function lz_faction_ceos:initialise()

	-- Quick check to make sure he actually exists.
	local q_faction = cm:query_faction(self.lz_faction_key);
	if not q_faction or q_faction:is_null_interface() then
		self:print("lz_faction_ceos: Not initialising and Lu Zhi doesn't exist.")
		return false;
	end;
	
	--Remove locked CEOs if we gain a real CEO
	core:add_listener(
		self.listener_name .. "FactionCeoAdded", -- Unique handle
		"FactionCeoAdded", -- Campaign Event to listen for
		function(context) -- Criteria
			return context:ceo():category_key() == self.ceo_category_key and (string.match(context:ceo():ceo_data_key(),"*" .. self.locked_ceo_suffix) == nil);
		end,
		function(context) -- What to do if listener fires.
			
			self:print("Faction CEO "..context:ceo():ceo_data_key().." Added. Checking if we have locked CEO");

			-- Remove the locked CEO
			if self:has_lz_ceo(context:ceo():ceo_data_key() .. self.locked_ceo_suffix) then
				self:print("We have locked CEO "..context:ceo():ceo_data_key() .. self.locked_ceo_suffix..". Remove it!");
				cm:modify_faction(context:faction():name()):ceo_management():remove_ceos(context:ceo():ceo_data_key() .. self.locked_ceo_suffix);
			end

			-- Remove the listener so it cannot fire. allows us to handle things which skip this.
			core:remove_listener(self.listener_name .. context:ceo():ceo_data_key());
		end,
		true --Is persistent
	);


	-- Establish the individual CEO listeners.
	self:add_ceo_unlock_listeners();
end;


--- @function print
--- @desc Function to print to the console. Wrapps up functionality so there is a singular point.
--- @p string name
function lz_faction_ceos:print(string)
	out.design(self.system_id .. string);
end;


--- @function add_listener
--- @desc Core function. Adds a listener for the specified CEOkey, which will gain an amount of points when the trigger fires.
--- @p string The key of the CEO to change
--- @p string the campaign events which triggers this.
--- @p function a callback to fire when it happens
--- @p number/function the number of points to add into the ceo when it fires, or a function to define the points. If not passed in will default to 1.
--- @p bool shoulkd this only fire once?
function lz_faction_ceos:add_ceo_unlock_listener(ceo_key, event, callback, points_to_give, fire_once)
	points_to_give = points_to_give or 1;
	fire_once = fire_once or false;

	if not is_string(ceo_key) then
		script_error("lz_faction_ceos:add_ceo_unlock_listener() ceo_key is NOT a string.");
		return false;
	end;

	if self:has_lz_ceo(ceo_key) then
		self:print("Not adding listener [" .. ceo_key .. "] is already unlocked.");
		return false;
	end;

	if not is_string(event) then
		script_error("lz_faction_ceos:add_ceo_unlock_listener() event is NOT a string.");
		return false;
	end;

	if not is_function(callback) and not is_boolean(callback) then
		script_error("lz_faction_ceos:add_ceo_unlock_listener() callback is NOT a function or a boolean.");
		return false;
	end;

	if not is_number(points_to_give) and not is_function(points_to_give) then
		script_error("lz_faction_ceos:add_ceo_unlock_listener() points_change is NOT a number or a function.");
		return false;
	end;


	-- Add our actual listener here.
	core:add_listener(
		self.listener_name .. ceo_key, -- Unique handle
		event, -- Campaign Event to listen for
		callback,
		function(context) -- What to do if listener fires.
			-- Make sure we've not already unlocked the ceo. If we have, remove this listener.
			if self:has_lz_ceo(ceo_key) then
				core:remove_listener(self.listener_name .. ceo_key);
			end;

			if is_function(points_to_give) then
				points_to_give(context);
			else
				self:add_points(ceo_key, points_to_give);
			end;
		end,
		not fire_once --Is persistent
	);
end;


--- @function add_points
--- @desc Adds the specified number of point to the ceo. Will remove if negative.
--- @p string ceo to change
--- @p number the amount of points to add/remove.
function lz_faction_ceos:add_points(ceo_key, points_to_add)
	if not is_string(ceo_key) then
		script_error("lz_faction_ceos:add_points() ceo_key must be a string.");
		return false;
	end;

	if not is_number(points_to_add) then
		script_error("lz_faction_ceos:add_points() desired_points must be a number.");
		return false;
	end;

	local locked_ceo_key = ceo_key .. self.locked_ceo_suffix;
	local modify_ceo_mgmt = cm:modify_faction(self.lz_faction_key):ceo_management();
	local query_ceo_mgmt = modify_ceo_mgmt:query_faction_ceo_management();
	local current_points = self:get_points_in_locked_ceo(ceo_key);
	local locked_ceo = ancillaries:faction_get_ceo(query_ceo_mgmt, locked_ceo_key, self.ceo_category_key);
	
	if not current_points then -- This means the CEO doesn't exist.
		return false;
	end;

	modify_ceo_mgmt:change_points_of_ceos(locked_ceo_key, points_to_add);

	-- if 'locked' ceo is at max, remove locked ceo and add real CEO.
	if locked_ceo:num_points_in_ceo() >= locked_ceo:max_points_in_ceo() then
			
		self:print("Unlocking [" .. ceo_key .. "]");
		-- Create the unlocked CEO.
		modify_ceo_mgmt:add_ceo(ceo_key);

		-- Remove the listener so it won't fire again.
		core:remove_listener(self.listener_name .. ceo_key);
	end;
end;


--- @function set_points
--- @desc Sets the specified CEO to the number of points passed in.. Will remove if negative.
--- @p string ceo to change
--- @p number the amount of points the ceo should have.
--- @p bool Prevent the score becoming lower than the current. Essentially creating a high watermark.
function lz_faction_ceos:set_points(ceo_key, desired_points)
	local locked_ceo_key = ceo_key .. self.locked_ceo_suffix;

	if not is_string(ceo_key) then
		script_error("lz_faction_ceos:set_points() ceo_key must be a string.");
		return false;
	end;

	if not is_number(desired_points) then
		script_error("lz_faction_ceos:set_points() desired_points must be a number.");
		return false;
	end;

	local query_ceo_mgmt = cm:query_faction(self.lz_faction_key):ceo_management();
	local locked_ceo = ancillaries:faction_get_ceo(query_ceo_mgmt, locked_ceo_key, self.ceo_category_key);

	local points_change = (desired_points + 1) - locked_ceo:num_points_in_ceo(); -- We actually want to raise our desired points by one, as we count from 1 upwards.
	
	self:add_points(ceo_key, points_change);
end;


--- @function get_points_in_locked_ceo
--- @desc Get the number of points in the specified CEO.
--- @p string The Ceo to check for.
--- @r number the score of the ceo, nil if couldn't find it.
function lz_faction_ceos:get_points_in_locked_ceo(ceo_key)
	local query_faction = cm:query_faction(self.lz_faction_key);
	local query_ceo_mgmt = query_faction:ceo_management();

	-- Make sure we got a CEO interface
	if not query_ceo_mgmt or query_ceo_mgmt:is_null_interface() then
		script_error("lz_faction_ceos:get_points_in_locked_ceo() No CEO Management interface.");
		return nil;
	end;

	local ceo = ancillaries:faction_get_ceo(query_ceo_mgmt, ceo_key .. self.locked_ceo_suffix, self.ceo_category_key);

	if not ceo or ceo:is_null_interface() then
		script_error("lz_faction_ceos:get_points_in_locked_ceo() No CEO found with key [" .. tostring(ceo_key) .. "]");
		return nil;
	end;

	return ceo:num_points_in_ceo();
end;


--- @function has_lz_ceo
--- @desc Test if the query faction is the owner of the ceo.
--- @p string The Ceo to check for.
--- @r boolean has ceo unlocked
function lz_faction_ceos:has_lz_ceo(ceo_key)
	local query_faction = cm:query_faction(self.lz_faction_key);
	local ceo_list = query_faction:ceo_management():all_ceos_for_category(self.ceo_category_key)
	for i = 0, ceo_list:num_items() - 1 do

		local ceo = ceo_list:item_at(i)
		if ceo:ceo_data_key() == ceo_key then
			return true;
		end;

	end

	return false;
end;


--- @function is_lz_faction
--- @desc Test if the query faction is the owner faction of the system.
--- @p query_faction Faction to test against
--- @r boolean is match
function lz_faction_ceos:is_lz_faction(query_faction)
	return query_faction:name() == self.lz_faction_key;
end;


-- Add the listeners for the different events. Done in this fashion so we can use self for brevity.
function lz_faction_ceos:add_ceo_unlock_listeners()
-- AUTHORITY

	--Dongguan Hanji : Campaign Start
	self:add_ceo_unlock_listener("3k_dlc04_ceo_factional_great_library_authority_common",
		"FactionTurnStart",
		function(context) return context:query_model():turn_number() == 1 and context:faction():is_human() == false end
	);

	--Huainanzi : Have a Rank 10 Faction Leader

	self:add_ceo_unlock_listener("3k_dlc04_ceo_factional_great_library_authority_exceptional",
		"FactionTurnStart",
		function(context)
			return self:is_lz_faction(context:faction()) and context:faction():has_faction_leader();
		end,
		function(context) -- Custom Points Allocator
			self:set_points("3k_dlc04_ceo_factional_great_library_authority_exceptional",  context:faction():faction_leader():rank(), false);
		end
	);

	--Records of the Grand Historian : Travel to Anding
	self:add_ceo_unlock_listener("3k_dlc04_ceo_factional_great_library_authority_refined",
		"FactionTurnStart",
		function(context)
            return self:is_lz_faction(context:faction())
		end,
		function(context)
			-- MOD EDIT: start of new script.
			local lz_character_list = context:faction():character_list(); -- geting all the characters for Lu Zhi's faction.
			for i = 1, lz_character_list:num_items() - 1 do --for each character in the list
				local this_character = lz_character_list:item_at(i); --get the character
                if this_character:has_region() then
                    local this_region = this_character:region():name(); --and thier region
                    if this_region == "3k_main_anding_capital" or this_region == "3k_main_anding_resource_1" or this_region == "3k_main_anding_resource_2" or this_region == "3k_main_anding_resource_3" then
                        self:set_points("3k_dlc04_ceo_factional_great_library_authority_refined",  1, false);
                        return true		--this character is in a region within Anding. award the ceo.			
                    end;
                end
				if temp_break then
					break -- no point going through all the other characters in the list, breaking the loop.
				end;
			end;
		end
	);


	--The Book of Lord Shang : Fully upgrade a city
	local function points_for_building_level(region)
		local points_to_give = 0

		if region:building_exists("3k_city_10") then
			points_to_give = 10;
		elseif  region:building_exists("3k_city_9") then
			points_to_give = 9;
		elseif  region:building_exists("3k_city_8") then
			points_to_give = 8;
		elseif  region:building_exists("3k_city_7") then
			points_to_give = 7;
		elseif  region:building_exists("3k_city_6") then
			points_to_give = 6;
		elseif  region:building_exists("3k_city_5") then
			points_to_give = 5;
		elseif  region:building_exists("3k_city_4") then
			points_to_give = 4;
		elseif  region:building_exists("3k_city_3") then
			points_to_give = 3;
		elseif region:building_exists("3k_city_2") then
			points_to_give = 2;
		elseif region:building_exists("3k_city_1") then
			points_to_give = 1;
		end;
		
		-- Need to add one point as this CEO is out of 11.
		return points_to_give + 1;
	end;

	-- This fires onces on campaign load, tyo keep everything in sync.
	self:add_ceo_unlock_listener("3k_dlc04_ceo_factional_great_library_authority_unique",
		"FactionTurnStart",
		function(context)
			return self:is_lz_faction(context:faction());
		end,
		function(context) -- Custom Points Allocation
			local region_list = context:faction():region_list();
			local highest_points = 0;

			if not region_list:is_empty() then
				--GO THROUGH ALL THE REGIONS THE FACTION CONTROLS
				for i = 0, region_list:num_items() - 1 do
					local region = region_list:item_at(i);
					
					local points_to_give = points_for_building_level(region);

					if points_to_give > highest_points then
						highest_points = points_to_give;
					end;
				end;

				if highest_points > 0 then
					self:set_points("3k_dlc04_ceo_factional_great_library_authority_unique",  highest_points, true); -- Don't let this drop!
				end;
			end;
		end,
		true -- Only fire once.
	);

	self:add_ceo_unlock_listener(
		"3k_dlc04_ceo_factional_great_library_authority_unique",
		"BuildingCompleted",
		function(context)
			return self:is_lz_faction(context:building():faction());
		end,
		function(context) -- Custom Points Allocation
			local pts = points_for_building_level(context:building():region());
			self:set_points("3k_dlc04_ceo_factional_great_library_authority_unique",  pts, true); -- Don't let this drop!
		end
	)

-- CUNNING

	--Book of Changes : Perform an undercover network action
	self:add_ceo_unlock_listener("3k_dlc04_ceo_factional_great_library_cunning_common",
		"UndercoverCharacterSourceFactionActionCompleteEvent",
		function(context)
			return self:is_lz_faction(context:source_faction())
		end
	);
	self:add_ceo_unlock_listener("3k_dlc04_ceo_factional_great_library_cunning_common",
		"UndercoverCharacterTargetCharacterActionCompleteEvent",
		function(context)
			return self:is_lz_faction(context:source_faction())
		end
	);
	self:add_ceo_unlock_listener("3k_dlc04_ceo_factional_great_library_cunning_common",
		"UndercoverCharacterTargetFactionActionCompleteEvent",
		function(context)
			return self:is_lz_faction(context:source_faction())
		end
	);
	self:add_ceo_unlock_listener("3k_dlc04_ceo_factional_great_library_cunning_common",
		"UndercoverCharacterTargetGarrisonActionCompleteEvent",
		function(context)
			return self:is_lz_faction(context:source_faction())
		end
	);

	--The Writings on Reckoning : Have an income exceeding 3000
	self:add_ceo_unlock_listener("3k_dlc04_ceo_factional_great_library_cunning_exceptional",
		"FactionTurnStart",
		function(context)
			return self:is_lz_faction(context:faction()) and context:faction():projected_net_income() >= 0;
		end,
		function(context) -- Custom Points Allocator
			self:set_points("3k_dlc04_ceo_factional_great_library_cunning_exceptional",  context:faction():projected_net_income(), false);
		end
	);

	--Classic of Poetry : Maintain 5 trade deals
	self:add_ceo_unlock_listener("3k_dlc04_ceo_factional_great_library_cunning_refined",
		"TradeRouteEstablished",
		function(context)
			return self:is_lz_faction(context:faction());
		end,
		function(context) -- Custom Points Allocator
			self:set_points("3k_dlc04_ceo_factional_great_library_cunning_refined",  context:faction():number_of_trade_routes(), false);
		end
	);

	--Book of Rites : Fight a battle alongside another faction
	self:add_ceo_unlock_listener("3k_dlc04_ceo_factional_great_library_cunning_unique",
		"CampaignBattleLoggedEvent",
		function(context) 
			local log_entry = context:log_entry();
			
			-- check winners only if more than one faction
			if log_entry:winning_factions():num_items() > 1 then
				for i = 0, log_entry:winning_factions():num_items() - 1 do
					local faction = log_entry:winning_factions():item_at(i);

					if self:is_lz_faction(faction) then
						return true;
					end;
				end;
			end;

			-- check losers only if more than one faction
			if log_entry:losing_factions():num_items() > 1 then
				for i = 0, log_entry:losing_factions():num_items() - 1 do
					local faction = log_entry:losing_factions():item_at(i);

					if self:is_lz_faction(faction) then
						return true;
					end;
				end;
			end;

			return false;
		end
	);

-- EXPERTISE

	--Huangdi Neijing : Complete a Mission
	self:add_ceo_unlock_listener("3k_dlc04_ceo_factional_great_library_expertise_common",
		"MissionSucceeded",
		function(context) 	
			return self:is_lz_faction(context:faction());
		end
	);

	--Discourses on Salt & Iron : Have 10 characters in your faction
	self:add_ceo_unlock_listener("3k_dlc04_ceo_factional_great_library_expertise_exceptional",
		"FactionTurnStart",
		function(context)
			return self:is_lz_faction(context:faction());
		end,
		function(context) -- Custom Points Allocator
			local character_list = context:faction():character_list()
			local num_characters = 0
			for i = 0, character_list:num_items() - 1 do
				if not misc:is_transient_character(character_list:item_at(i))
				and not character_list:item_at(i):is_character_is_faction_recruitment_pool() then
						
					num_characters = num_characters + 1;
				end
			end
			self:set_points("3k_dlc04_ceo_factional_great_library_expertise_exceptional",  num_characters, false);
		end
	);

	--Nan Jing : Have a wound healed
	self:add_ceo_unlock_listener("3k_dlc04_ceo_factional_great_library_expertise_refined",
		"CharacterWoundHealedEvent",
		function(context)
			return self:is_lz_faction(context:query_character():faction());
		end
	);

	--Chu Ci : Own a silk resource
	self:add_ceo_unlock_listener("3k_dlc04_ceo_factional_great_library_expertise_unique",
		"GarrisonOccupiedEvent",
		function(context)
			return self:is_lz_faction(context:query_character():faction()) 
				and (context:garrison_residence():region():name() == "3k_main_hanzhong_resource_1"
				or context:garrison_residence():region():name() == "3k_main_jincheng_resource_1"
				or context:garrison_residence():region():name() == "3k_main_wudu_resource_1")
		end
	);

-- INSTINCT

	--Wei Liaozi : Have an income of 10 food
	self:add_ceo_unlock_listener("3k_dlc04_ceo_factional_great_library_instinct_common",
		"FactionTurnStart",
		function(context)
			return self:is_lz_faction(context:faction());
		end,
		function(context) -- Custom Points Allocator
			local food_amount = context:faction():pooled_resources():resource("3k_main_pooled_resource_food"):value();
			self:set_points("3k_dlc04_ceo_factional_great_library_instinct_common",  food_amount, false);
		end
	);

	--The Six Secret Teachings : Occupy 10 settlements
	self:add_ceo_unlock_listener("3k_dlc04_ceo_factional_great_library_instinct_exceptional",
		"GarrisonOccupiedEvent",
		function(context)
			return self:is_lz_faction(context:query_character():faction());
		end
	);

	--The Three Strategies of Huang Shigong : Win an ambush battle
	self:add_ceo_unlock_listener("3k_dlc04_ceo_factional_great_library_instinct_refined",
		"CampaignBattleLoggedEvent",
		function(context)
			if cm:query_model():pending_battle():ambush_battle() then
				local log_entry = context:log_entry();
				
				for i = 0, log_entry:winning_factions():num_items() - 1 do
					local faction = log_entry:winning_factions():item_at(i);
					if self:is_lz_faction(faction) then
						return true;
					end;
				end;

			end;
				
			return false;
		end
	);

	--The Art of War : Win 30 battles
	self:add_ceo_unlock_listener("3k_dlc04_ceo_factional_great_library_instinct_unique",
		"CampaignBattleLoggedEvent",
		function(context)
			local log_entry = context:log_entry();
				
			for i = 0, log_entry:winning_factions():num_items() - 1 do
				local faction = log_entry:winning_factions():item_at(i);
				if self:is_lz_faction(faction) then
					return true;
				end;
			end;
				
			return false;
		end
	);

	--Zuo Zhuan : Win a battle with a Wood general in your army
	self:add_ceo_unlock_listener("3k_dlc04_ceo_factional_great_library_resolve_common",
		"CampaignBattleLoggedEvent",
		function(context)
			local log_entry = context:log_entry();

			for i = 0, log_entry:winning_characters():num_items() - 1 do
				local character = log_entry:winning_characters():item_at(i):character();

				if self:is_lz_faction(character:faction()) and character:character_subtype_key() == "3k_general_wood" then
					return true;
				end;
			end;
				
			return false;
		end
	);

	--Classic of Mountains & Seas : Reach 10,000,000 population
	self:add_ceo_unlock_listener("3k_dlc04_ceo_factional_great_library_resolve_exceptional",
		"FactionTurnStart",
		function(context)
			return self:is_lz_faction(context:faction());
		end,
		function(context) -- Custom Points Allocator
			local region_list = context:faction():region_list()
			local thousand_people = 0

			if not region_list:is_empty() then
				--GO THROUGH ALL THE REGIONS THE FACATION CONTROLS
				for i = 0, region_list:num_items() - 1 do
					--ADDS THE REGIONS POPULATION TO THE LIST

					thousand_people = region_list:item_at(i):pooled_resources():resource("3k_main_pooled_resource_population"):value() + thousand_people;
				end
			end;

			self:set_points("3k_dlc04_ceo_factional_great_library_resolve_exceptional",  thousand_people * 1000, false);
		end
	);

	--Lüshi Chunqiu : Own 2 Farm regions
	self:add_ceo_unlock_listener("3k_dlc04_ceo_factional_great_library_resolve_refined",
		"GarrisonOccupiedEvent",
		function(context)
			if self:is_lz_faction(context:query_character():faction()) then
				for i = 0, context:garrison_residence():region():slot_list():num_items() - 1 do
					local slot = context:garrison_residence():region():slot_list():item_at(i);

					if slot:has_building() 
					and (slot:building():superchain() == "3k_resource_wood_farms_grain"
					or slot:building():superchain() == "3k_resource_wood_farms_rice") then
						return true;
					end;
				end;
			end;
			
			return false;
		end
	);

	--Mencius : Hire 5 enemy Generals
	self:add_ceo_unlock_listener("3k_dlc04_ceo_factional_great_library_resolve_unique",
		"CharacterCaptiveOptionApplied",
		function(context) 
			return self:is_lz_faction(context:capturing_force():faction()) and context:captive_option_outcome() == "EMPLOY";
		end
	);
end;
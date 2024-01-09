---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------
----- Name:			dlc06_nanman_skills.lua
----- Description: 	This script handles the skill progression for Nanman characters
---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------

output("dlc06_nanman_skills.lua: Loading");

-- Don't load in campaigns which don't require it.
if cm.name == "ep_eight_princes" then
	output("dlc06_nanman_skills.lua: Not loaded in this campaign.");
	return;
end;

-- self initialiser
cm:add_first_tick_callback(function() nanman_skills_manager:initialise() end); --Self register function


---------------------------------------------------------
--------------------VARIABLES----------------------------
---------------------------------------------------------

nanman_skills_manager = {
	debug_mode = false;
	pinned_goals = {}; -- Pinned goals in table form. Saved and Loaded.
	system_id = "[602] nanman_skills_manager - ";
	listener_name = "DLC06NanmanSkills";
	ceo_category_skills = "3k_dlc06_ceo_category_nanman_skills";
	ceo_category_career = "3k_main_ceo_category_career";
	butcher			 =	"3k_dlc06_ceo_character_nanman_skills_fire_instinct_butcher"; -- Kill x men
	cavalry_chief	 =	"3k_dlc06_ceo_character_nanman_skills_earth_authority_cavalry_chief"; -- Rank up cavalry/animals x times
	cave_defender	 =	"3k_dlc06_ceo_character_nanman_skills_metal_expertise_cave_defender"; -- Win x defensive battles
	flurry			 =	"3k_dlc06_ceo_character_nanman_skills_metal_expertise_flurry"; -- Win x offensive battles
	hit_and_run		 =	"3k_dlc06_ceo_character_nanman_skills_earth_authority_hit_and_run"; -- Construct buildings in governed provinces.
	infantry_chief	 =	"3k_dlc06_ceo_character_nanman_skills_wood_resolve_infantry_chief"; -- Rank up infantry x times
	marshal			 =	"3k_dlc06_ceo_character_nanman_skills_wood_resolve_marshal"; -- Win x battles
	missile_chief	 =	"3k_dlc06_ceo_character_nanman_skills_water_cunning_missile_chief"; -- Rank up archer units x times
	prudence		 =	"3k_dlc06_ceo_character_nanman_skills_fire_instinct_prudence"; -- Release x characters
	role_model		 =	"3k_dlc06_ceo_character_nanman_skills_wood_resolve_role_model"; -- Fight x battles with reinforcements
	shaman_rites	 =	"3k_dlc06_ceo_character_nanman_skills_water_cunning_shaman_rites"; -- Recruit captives x times
	stalker			 =	"3k_dlc06_ceo_character_nanman_skills_water_cunning_stalker"; -- Fight x ambush battles
	tireless_soul	 =	"3k_dlc06_ceo_character_nanman_skills_earth_authority_tireless_soul"; -- Fight x siege battles
	tribal_hero		 =	"3k_dlc06_ceo_character_nanman_skills_metal_expertise_tribal_hero"; -- Fight x duels
	warmonger		 =	"3k_dlc06_ceo_character_nanman_skills_fire_instinct_warmonger"; -- Occupy x settlements
};

---------------------------------------------------------
--------------------LISTENERS----------------------------
---------------------------------------------------------

--- @function add_listeners
--- @desc Setup the listeners for automatically adding points to the skill CEOs
--- @return nil
function nanman_skills_manager:add_listeners()

	-- Check when a character ranks up. This is used to upgrade the career CEO for nanman characters
	core:add_listener(
		self.listener_name .. "CharacterRank", -- Unique handle
		"CharacterRank", -- Campaign Event to listen for
		function(context) -- Listener condition
			
			--Find if we have any nanman career CEOs equipped
			local query_ceo_list = context:query_character():ceo_management():all_ceos_for_category(self.ceo_category_career);
			
			if query_ceo_list:num_items() > 0 and string.match(query_ceo_list:item_at(0):ceo_data_key(),"nanman") then
				
				--Character has a nanman career trait
				return true
				
			end
			
			--Character doesn't have a nanman career trait
			return false
			
		end,
		function(context) -- What to do if listener fires.
	
			-- Find the career CEO and save it
			local query_ceo = context:query_character():ceo_management():all_ceos_for_category(self.ceo_category_career):item_at(0);
			
			-- Add points to the career CEO to make it match the new character rank. Prevent this accidentally pinning a skill goal.
			self:modify_points(context:modify_character(), query_ceo:ceo_data_key(), (context:query_character():rank() - query_ceo:num_points_in_ceo()), true);

		end,
		true --Is persistent
	);

	-- Post battle captives listeners
	core:add_listener(
		self.listener_name .. "CharacterCaptiveOptionApplied", -- Unique handle
		"CharacterCaptiveOptionApplied", -- Campaign Event to listen for
		true, -- conditions.
		function(context) -- What to do if listener fires.

			-- Go through all characters in the force and grant skill points.
			context:capturing_force():character_list():foreach(function(query_character)
				-- Check the capturing character can have skills.
				if not self:is_character_valid(query_character) then
					return;
				end;

				-- Employ captives x times
				if query_character:ceo_management():has_ceo_equipped(self.shaman_rites) and context:captive_option_outcome() == "EMPLOY" then
					self:modify_points(cm:modify_character(query_character), self.shaman_rites, 1)
				end
				
				-- Release captives x times
				if query_character:ceo_management():has_ceo_equipped(self.prudence) and context:captive_option_outcome() == "RELEASE" then
					self:modify_points(cm:modify_character(query_character), self.prudence, 1)
				end
			end)

		end,
		true --Is persistent
	);

	-- Occupation option listeners
	core:add_listener(
		self.listener_name .. "CharacterWillPerformSettlementSiegeAction", -- Unique handle
		"CharacterWillPerformSettlementSiegeAction", -- Campaign Event to listen for
		function(context) -- Listener condition
			return self:is_character_valid(context:query_character());
		end,
		function(context) -- What to do if listener fires.
			
			-- Go through all characters in the force and grant skill points.
			context:query_character():military_force():character_list():foreach(function(query_character)
				if not self:is_character_valid(query_character) then
					return;
				end;
					
				-- Occupy x settlments
				if query_character:ceo_management():has_ceo_equipped(self.warmonger) 
					and (string.match(context:action_option_record_key(),"occupy") or string.match(context:action_option_record_key(),"confederate")) then

					self:modify_points(cm:modify_character(query_character), self.warmonger, 1)
				end;
			end);
		
		end,
		true --Is persistent
	);
	
	-- Post-battle listener
	core:add_listener(
		self.listener_name .. "CampaignBattleLoggedEvent", -- Unique handle
		"CampaignBattleLoggedEvent", -- Campaign Event to listen for
		true,
		function(context)
			
			local cached_battle = pending_battle_cache:get_pending_battle_cache();

			if not cached_battle then
				script_error("ERROR: Nanman skills: no penging battle cache found.");
				return false;
			end;

			-- Find all the winning characters, and add points to their relevant CEOs
			context:log_entry():winning_characters():foreach(function(battle_log_character)
				self:assign_battle_victory_skill_points(cached_battle, battle_log_character)
			end);
			
			-- Find all the losing characters, and add points to their relevant CEOs
			context:log_entry():losing_characters():foreach(function(battle_log_character)
				self:assign_battle_defeat_skill_points(cached_battle, battle_log_character)
			end);
			
			-- Find all the duels and add points to the relevant CEOs
			context:log_entry():duels():foreach(function(duel)
				
				if self:is_character_valid(duel:proposer()) then
					local query_character = duel:proposer();
					if query_character:ceo_management():has_ceo_equipped(self.tribal_hero) then
						self:modify_points(cm:modify_character(query_character), self.tribal_hero, 1)
					end;
				end;

				if self:is_character_valid(duel:target()) then
					local query_character = duel:target();
					if query_character:ceo_management():has_ceo_equipped(self.tribal_hero) then
						self:modify_points(cm:modify_character(query_character), self.tribal_hero, 1)
					end;
				end;
			end);
		end,
		true --Is persistent
	);
	
	-- Unit ranked up listener
	core:add_listener(
		self.listener_name .. "UnitExperienceLevelGained", -- Unique handle
		"UnitExperienceLevelGained", -- Campaign Event to listen for
		function(context) -- Listener condition
			-- Make sure the unit has an interface, and the unit commander has an interface. 
			return not context:unit():is_null_interface() and not context:unit():military_force_retinue():retinue_commander():is_null_interface() and self:is_character_valid(context:unit():military_force_retinue():retinue_commander());
		end,
		function(context) -- What to do if listener fires.
		
			local query_character = context:unit():military_force_retinue():retinue_commander()
			local points_to_add = context:unit():experience_level() - context:previous_experience_level();

			if points_to_add < 1 then -- Shouldn't ever get hit, but just in-case.
				return;
			end;
			
			-- Rank up cavalry and warbeast units x times
			if query_character:ceo_management():has_ceo_equipped(self.cavalry_chief) then
				if context:unit():unit_key() == "3k_dlc06_unit_metal_tiger_warriors" or context:unit():unit_key() == "3k_dlc06_unit_water_tiger_slingers" then
					self:modify_points(cm:modify_character(query_character), self.cavalry_chief, points_to_add)
					return -- Return if we match these as tigers and wolves are using the inf_melee/inf_ranged categories.
				elseif context:unit():unit_category() == "cavalry" or context:unit():unit_category() == "war_beast" then
					self:modify_points(cm:modify_character(query_character), self.cavalry_chief, points_to_add)
				end
			end

			-- Rank up missile units x times
			if query_character:ceo_management():has_ceo_equipped(self.missile_chief) and (context:unit():unit_category() == "inf_ranged" or context:unit():unit_category() == "artillery" or context:unit():unit_class() == "cav_mis") then
				self:modify_points(cm:modify_character(query_character), self.missile_chief, points_to_add)
			end
						
			-- Rank up infantry units x times
			if query_character:ceo_management():has_ceo_equipped(self.infantry_chief) and (context:unit():unit_category() == "inf_melee" or context:unit():unit_category() == "inf_ranged") then
				self:modify_points(cm:modify_character(query_character), self.infantry_chief, points_to_add)
			end
			
		end,
		true --Is persistent
	);


	-- Building constructed listener.
	core:add_listener(
		self.listener_name .. "CharacterBuildingCompleted",
		"CharacterBuildingCompleted",
		function(context)
			return self:is_character_valid(context:character());
		end,
		function(context)
			local query_character = context:character();
			
			-- Construct buildings in governed provinces.
			if query_character:ceo_management():has_ceo_equipped(self.hit_and_run) then
				self:modify_points(cm:modify_character(query_character), self.hit_and_run, 1)
			end;
		end,
		true
	)

end;

---------------------------------------------------------
--------------------FUNCTIONS----------------------------
---------------------------------------------------------

--- @function initialise
--- @desc Turns on the Nanman skills manager. The script self initialises this!
--- @return nil
function nanman_skills_manager:initialise()

	-- Enables more verbose debugging.
	-- Example: trigger_cli_debug_event nanman_skills_manager.enable_debug()
	core:add_cli_listener("nanman_skills_manager.enable_debug",
		function()
			self.debug_mode = true;
		end
	);

	-- Example: trigger_cli_debug_event nanman_skills_manager.output_skill_levels()
	core:add_cli_listener("nanman_skills_manager.output_skill_levels",
		function()
			
			local output_list = {};
			table.insert(output_list, string.format("%s,%s,%s,%s", "char_cqi", "ceo_key", "ceo_level", "ceo_points"));
			
			local all_characters = cm:query_model():world():active_character_list();

			all_characters = all_characters:filter(function(c) return c:character_subtype("3k_general_nanman") end);

			all_characters:foreach(function(c)
				local skill_ceos = c:ceo_management():all_ceos_for_category(self.ceo_category_skills);
				
				skill_ceos:foreach(function(ceo)
					local char_cqi = c:cqi();
					local ceo_key = ceo:ceo_data_key();
					local ceo_level = ceo:current_node_key();
					local ceo_points = ceo:num_points_in_ceo();
					table.insert(output_list, string.format("%s,%s,%s,%s", char_cqi, ceo_key, ceo_level, ceo_points));
				end);
			end);

			--[[
			output("****>>>> OUTPUTTING SKILL LEVELS <<<<<**** ")
			local fo = file_output:new("nanman_skills_data.csv", true);

			for i, data in ipairs(output_list) do
				fo:write_line(data);
			end;

			output("****>>>> OUTPUTTING SKILL LEVELS END <<<<<**** ")
			]]--
		end
	);
	
	self:print("Nanman skills CEO script initialised.");
	self:add_listeners();
	self:add_goal_pin_listeners();
end;

--- @function compare_points
--- @desc Returns the difference between a user defined value and a ceo's current points. Designed for character CEOs only
--- @return number
function nanman_skills_manager:compare_points(query_character, value, ceo_key)

	local query_ceo_management = query_character:ceo_management();

	-- Make sure we got a CEO interface
	if not query_ceo_management or query_ceo_management:is_null_interface() then
		script_error("nanman_skills_manager:compare_points() No CEO Management interface.");
		return false;
	end;

	-- Make sure the ceo_key is a string
	if not is_string(ceo_key) then
		script_error("nanman_skills_manager:compare_points() ceo_key must be a string.");
		return false;
	end;

	-- Make sure the number to compare is actually a number
	if not is_number(value) then
		script_error("nanman_skills_manager:compare_points() value must be a number.");
		return false;
	end;

	local ceo_value = 0
	local query_ceo_list = query_ceo_management:all_ceos_for_category(self.ceo_category_skills);
	
	for i = 0, query_ceo_list:num_items() - 1 do
		local query_ceo = query_ceo_list:item_at(i)
		if query_ceo:ceo_data_key() == ceo_key then
			ceo_value = query_ceo:num_points_in_ceo()
			break
		end
	end

	-- Return the difference between the supplied value and the points in the CEO
	-- CEO needs to have 1 additional point subtracted from it because it starts at 1 instead of 0
	return (value - (ceo_value - 1));
end;

--- @function modify_points
--- @desc Attempts to add points to a CEO, returns false if it failed and true if it succeded.
--- @return boolean
function nanman_skills_manager:modify_points(modify_character, ceo_key, points, opt_prevent_pinning_skill_goal)
	opt_prevent_pinning_skill_goal = opt_prevent_pinning_skill_goal or false;
	local modify_ceo_management = modify_character:ceo_management();

	-- Make sure we got a CEO interface
	if not modify_ceo_management or modify_ceo_management:is_null_interface() then
		script_error("nanman_skills_manager:modify_points() No CEO Management interface.");
		return false;
	end;

	if not is_string(ceo_key) then
		script_error("nanman_skills_manager:modify_points() ceo_key must be a string.");
		return false;
	end;

	if not is_number(points) then
		script_error("nanman_skills_manager:modify_points() points must be a number.");
		return false;
	end;

	if modify_character:query_character():ceo_management():changing_points_for_ceo_data_will_have_no_impact(ceo_key) then
		self:print("Could not add points to "..ceo_key.."for character cqi:"..tostring(modify_character:query_character():cqi()), true);
		return false;
	end;

	modify_ceo_management:change_points_of_ceos(ceo_key, points);

	-- FTUX - If the user has never pinned a goal, add it as a pinned goal.
	local character_faction = modify_character:query_character():faction();

	-- Using the saved value system to make it function in MP.
	if not opt_prevent_pinning_skill_goal and character_faction:is_human() then
		local has_ever_pinned_goal = false;
		if cm:saved_value_exists("has_ever_pinned_goal", "nanman_skills", character_faction:name()) then
			has_ever_pinned_goal = cm:get_saved_value("has_ever_pinned_goal", "nanman_skills", character_faction:name());
		end;

		if not has_ever_pinned_goal then
			cm:set_saved_value("has_ever_pinned_goal", true, "nanman_skills", character_faction:name());
			
			self:pin_character_skill_goal(modify_character:query_character():cqi(), ceo_key);
			self:update_ui(); -- Force a ui update as this is outside of the normal cycle.
		end;
	end;
	
	--Debug output for adding points. It can be spammy so it's only enabled in debug mode
	self:print("Adding points to "..ceo_key.."for character cqi:"..tostring(modify_character:query_character():cqi()), true);
	
	return true;
end;

--- @function is_character_valid
--- @desc Checks to see if a character and their faction is alive.
--- @return boolean
function nanman_skills_manager:is_character_valid(query_character)
	if not is_query_character(query_character) or query_character:is_null_interface() then
		script_error("nanman_skills_manager:is_character_valid() Invalid character passed in " .. tostring(query_character));
		return false;
	end;

	-- check the the character is a nanman in a living faction who can have nanman skills
	if query_character:is_dead()
		or query_character:faction():is_null_interface()
		or query_character:faction():is_dead()
		or query_character:ceo_management():is_null_interface() 
		or query_character:ceo_management():number_of_ceos_equipped_for_category(self.ceo_category_skills) == 0
		then	

		return false
	end
		
	return true

end

--- @function print
--- @desc Prints output to the console. For debugging functionality only
--- @p [opt=false] string The message to output
--- @p [opt=false] opt_debug_only Should this only fire if the user has debug mode enabled.
--- @return nil
function nanman_skills_manager:print(string, opt_debug_only)
	if opt_debug_only and not self.debug_mode then
		return;
	end;

	out.design(self.system_id .. string);
end;

function nanman_skills_manager:assign_battle_victory_skill_points(cached_battle, battle_log_character)

	local query_character = battle_log_character:character();

	-- Make sure the character has an interface and isn't dead
	if not self:is_character_valid(query_character) then
		return;
	end;

	local was_attacker = cached_battle:faction_was_attacker(query_character:faction():name());
	
	-- Win x battles	
	if query_character:ceo_management():has_ceo_equipped(self.marshal) then
		self:modify_points(cm:modify_character(query_character), self.marshal, 1)
	end;

	-- Win x offensive battles
	if query_character:ceo_management():has_ceo_equipped(self.flurry) and was_attacker then
		self:modify_points(cm:modify_character(query_character), self.flurry, 1)
	end;
	
	-- Win x defensive battles
	if query_character:ceo_management():has_ceo_equipped(self.cave_defender) and not was_attacker then
		self:modify_points(cm:modify_character(query_character), self.cave_defender, 1)
	end;	
	
	self:assign_battle_shared_skill_points(cached_battle, battle_log_character);
end;

function nanman_skills_manager:assign_battle_defeat_skill_points(cached_battle, battle_log_character)	

	local query_character = battle_log_character:character();

	-- Make sure the character has an interface and isn't dead
	if not self:is_character_valid(query_character) then
		return;
	end;

	self:assign_battle_shared_skill_points(cached_battle, battle_log_character);
end;

function nanman_skills_manager:assign_battle_shared_skill_points(cached_battle, battle_log_character)
	local query_character = battle_log_character:character();

	local was_ambush = cached_battle.is_ambush;
	local was_siege = cached_battle.is_siege;
	local was_attacker = cached_battle:faction_was_attacker(query_character:faction():name());
	local num_attackers = cached_battle:num_attackers();
	local num_defenders = cached_battle:num_defenders();
	
	-- Fight x siege battles
	if query_character:ceo_management():has_ceo_equipped(self.tireless_soul) and was_siege then
		self:modify_points(cm:modify_character(query_character), self.tireless_soul, 1)
	end;

	-- Fight x ambush battles
	if query_character:ceo_management():has_ceo_equipped(self.stalker) and was_ambush then
		self:modify_points(cm:modify_character(query_character), self.stalker, 1)
	end;

	-- Kill x men in battle
	if query_character:ceo_management():has_ceo_equipped(self.butcher) then
		self:modify_points(cm:modify_character(query_character), self.butcher, battle_log_character:personal_kills())
	end;

	-- Fight x battles with reinforcements
	if query_character:ceo_management():has_ceo_equipped(self.role_model) then		
		local had_reinforcements = false;
		if (was_attacker and num_attackers > 1) or (not was_attacker and num_defenders > 1) then
			had_reinforcements = true;
		end;

		if had_reinforcements then
			self:modify_points(cm:modify_character(query_character), self.role_model, 1)
		end;
	end;
	
end;


-- #region Pinned character goals.


function nanman_skills_manager:add_goal_pin_listeners()

	self:update_ui(); -- Force a UI Update.

	-- The UI sends a message to the system. Which will pin or unpin the skills.
    core:add_listener(
        self.listener_name .."skill_pin_update", -- UID
        "CharacterSkillsPinUpdate", -- Event
        true, --Conditions for firing
		function(context)
			local cqi = context:query_character():cqi()
			local ceo_key = context:ceo_key()
			if context:pinned() then
				if not self:is_character_skill_goal_pinned(cqi, ceo_key) then
					self:pin_character_skill_goal(cqi, ceo_key);
				end
			else
				if self:is_character_skill_goal_pinned(cqi, ceo_key) then
					self:unpin_character_skill_goal(cqi, ceo_key);
				end
			end;

			self:update_ui();
        end, -- Function to fire.
        true -- Is Persistent?
	);


	-- CEO node changed - We'll assume if it changed, it's been unlocked as the data has two levels and cannot level down.
	core:add_listener(
		self.listener_name .. "goal_pins", -- Unique handle
		"CharacterCeoNodeChanged", -- Campaign Event to listen for
		function(context) -- Listener condition
			return context:ceo():category_key() == self.ceo_category_skills;
		end,
		function(context) -- What to do if listener fires.
			local cqi = context:query_character():cqi()
			local ceo_key = context:ceo():ceo_data_key()

			if self:is_character_skill_goal_pinned(cqi, ceo_key) then
				self:unpin_character_skill_goal(cqi, ceo_key);
				self:update_ui(); -- Force a UI Update.
			end
		end,
		true --Is persistent
	);

	-- Character Leaves.
	core:add_listener(
		self.listener_name .. "goal_pins", -- Unique handle
		"CharacterLeavesFaction", -- Campaign Event to listen for
		function(context) -- Listener condition
			if context:old_faction():subculture() ~= "3k_dlc06_subculture_nanman" then
				return false;
			end;

			return true;
		end,
		function(context) -- What to do if listener fires.
			local query_character = context:query_character();
			self:clear_pinned_goals_for_character(query_character:cqi());
			self:update_ui(); -- Force a UI Update.
		end,
		true --Is persistent
	);

	-- Character Dies.
	core:add_listener(
		self.listener_name .. "goal_pins", -- Unique handle
		"CharacterDied", -- Campaign Event to listen for
		function(context) -- Listener condition
			local query_character = context:query_character();

			return query_character:faction():subculture() == "3k_dlc06_subculture_nanman";
		end,
		function(context) -- What to do if listener fires.
			local query_character = context:query_character();
			self:clear_pinned_goals_for_character(query_character:cqi());
			self:update_ui(); -- Force a UI Update.
		end,
		true --Is persistent
	);

	core:add_listener(
		self.listener_name .. "ui_update_ui_created", -- Unique handle
		"UICreated", -- Campaign Event to listen for
		true,
		function(context) -- What to do if listener fires.
			self:update_ui();
		end,
		true --Is persistent
	);

	core:add_listener(
		self.listener_name .. "ui_update_start_of_round", -- Unique handle
		"WorldStartOfRoundEvent", -- Campaign Event to listen for
		true,
		function(context) -- What to do if listener fires.
			self:update_ui();
		end,
		true --Is persistent
	);


	
	-- Example: trigger_cli_debug_event nanman_skills.pin_skill(134,3k_dlc06_ceo_character_nanman_skills_fire_instinct_butcher)
	core:add_cli_listener("nanman_skills.pin_skill", 
		function(character_cqi, skill_key) 
			skill_key = skill_key or self.butcher;
				
			local query_character = cm:query_character(character_cqi);

			if not query_character or query_character:is_null_interface() then
				return;
            end;
			if not self:is_character_skill_goal_pinned(query_character:cqi(), skill_key) then
				self:pin_character_skill_goal(query_character:cqi(), skill_key);
			end
		end 
	);

	-- Example: trigger_cli_debug_event nanman_skills.unpin_skill(134,3k_dlc06_ceo_character_nanman_skills_fire_instinct_butcher)
	core:add_cli_listener("nanman_skills.unpin_skill", 
		function(character_cqi, skill_key) 
			skill_key = skill_key or self.butcher;
				
			local query_character = cm:query_character(character_cqi);

			if not query_character or query_character:is_null_interface() then
				return;
            end;
			if self:is_character_skill_goal_pinned(query_character:cqi(), skill_key) then
				self:unpin_character_skill_goal(query_character:cqi(), skill_key);
			end
		end 
	);
	
	-- Example: trigger_cli_debug_event nanman_skills.clear_pinned_skills_for_char(134)
	core:add_cli_listener("nanman_skills.clear_pinned_skills_for_char", 
		function(character_cqi) 
				
			local query_character = cm:query_character(character_cqi);

			if not query_character or query_character:is_null_interface() then
				return;
            end;
			
			self:clear_pinned_goals_for_character(query_character:cqi());
		end 
	);

end;


function nanman_skills_manager:clear_pinned_goals_for_character(character_cqi)
	if not is_string(character_cqi) and not is_number(character_cqi) then
		script_error("nanman_skills_manager:clear_pinned_goals_for_character() character_cqi is not a string/number. " .. tostring(character_cqi));
		return;
	end;

	-- Key value pairs cannot use a number as the Key, so cast it to a string.
	if is_number(character_cqi) then
		character_cqi = tostring(character_cqi);
	end;

	-- go through our goals and remove all matching pinned goals.
	if not self.pinned_goals[character_cqi] then
		return;
	end;

	-- Set the value to nil so it's removed from the list.
	self.pinned_goals[character_cqi] = nil;
end;


function nanman_skills_manager:pin_character_skill_goal(character_cqi, goal_ceo_key)
	if not is_string(character_cqi) and not is_number(character_cqi) then
		script_error("nanman_skills_manager:pin_character_skill_goal() character_cqi is not a string/number. " .. tostring(character_cqi));
		return;
	end;

	if not is_string(goal_ceo_key) then
		script_error("nanman_skills_manager:pin_character_skill_goal() goal_ceo_key is not a string. " .. tostring(goal_ceo_key));
		return;
	end;
		
	-- Key value pairs cannot use a number as the Key, so cast it to a string.
	if is_number(character_cqi) then
		character_cqi = tostring(character_cqi);
	end;
	
	-- already pinned
	if self:is_character_skill_goal_pinned(character_cqi, goal_ceo_key) then
		script_error("nanman_skills_manager:pin_character_skill_goal() Trying to pin a goal which is already pinned. " .. tostring(goal_ceo_key));
		return;
	end

	-- check if the character has pinned goals.
	if not self.pinned_goals[character_cqi] then
		self.pinned_goals[character_cqi] = {};
	end;

	table.insert(self.pinned_goals[character_cqi], goal_ceo_key);
end;


function nanman_skills_manager:unpin_character_skill_goal(character_cqi, goal_ceo_key)
	if not is_string(character_cqi) and not is_number(character_cqi) then
		script_error("nanman_skills_manager:unpin_character_skill_goal() character_cqi is not a string/number. " .. tostring(character_cqi));
		return;
	end;

	if not is_string(goal_ceo_key) then
		script_error("nanman_skills_manager:unpin_character_skill_goal() goal_ceo_key is not a string. " .. tostring(goal_ceo_key));
		return;
	end;
	
	-- Key value pairs cannot use a number as the Key, so cast it to a string.
	if is_number(character_cqi) then
		character_cqi = tostring(character_cqi);
	end;
	
	-- check if the character has pinned goals.
	if not self:is_character_skill_goal_pinned(character_cqi, goal_ceo_key) then
		script_error("nanman_skills_manager:unpin_character_skill_goal() Trying to unpin a goal which isn't pinned. " .. tostring(goal_ceo_key));
		return;
	end;

	-- go through our goals and remove if we can find the matching one.
	for i = #self.pinned_goals[character_cqi], 1, -1 do
		local goal = self.pinned_goals[character_cqi][i];

		if goal == goal_ceo_key then
			table.remove(self.pinned_goals[character_cqi], i);
			break;
		end;
	end;

	-- if the pin group is now empty, then remove it from our table.
	if #self.pinned_goals[character_cqi] == 0 then
		self:clear_pinned_goals_for_character(character_cqi);
	end;
end;

function nanman_skills_manager:is_character_skill_goal_pinned(character_cqi, goal_ceo_key)
	if not is_string(character_cqi) and not is_number(character_cqi) then
		script_error("nanman_skills_manager:is_character_skill_goal_pinned() character_cqi is not a string/number. " .. tostring(character_cqi));
		return false;
	end;

	if not is_string(goal_ceo_key) then
		script_error("nanman_skills_manager:is_character_skill_goal_pinned() goal_ceo_key is not a string. " .. tostring(goal_ceo_key));
		return false;
	end;
	
	-- Key value pairs cannot use a number as the Key, so cast it to a string.
	if is_number(character_cqi) then
		character_cqi = tostring(character_cqi);
	end;
	
	-- check if the character has pinned goals.
	if self.pinned_goals[character_cqi] then
		-- go through our goals and see if it's present
		for i = #self.pinned_goals[character_cqi], 1, -1 do
			local goal = self.pinned_goals[character_cqi][i];
			if goal == goal_ceo_key then
				return true;
			end;
		end;
	end;
	return false;
end;


function nanman_skills_manager:update_ui()
	effect.set_context_value("nanman_character_skills_pinned", self.pinned_goals);
end;
-- #endregion

-- #region Save/Load
---------------------------------------------------------------------------------------------------------
----- SAVE/LOAD
---------------------------------------------------------------------------------------------------------
function nanman_skills_manager:register_save_load_callbacks()
	cm:add_saving_game_callback(
		function(saving_game_event)
			cm:save_named_value("nanman_skills_manager_pinned_goals", self.pinned_goals);
		end
	);


	cm:add_loading_game_callback(
		function(loading_game_event)
			self.pinned_goals = cm:load_named_value("nanman_skills_manager_pinned_goals", self.pinned_goals);
		end
	);
end;

nanman_skills_manager:register_save_load_callbacks();
-- #endregion
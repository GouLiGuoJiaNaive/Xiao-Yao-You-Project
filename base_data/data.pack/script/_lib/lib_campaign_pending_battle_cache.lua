----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------
--
--	PENDING BATTLE CACHE
--  lib_campaign_pending_battle_cache.lua
--
--- @loaded_in_campaign
--- @desc The battle cache allows scripters to store some data from a pending_battle, which can be saved and reaccessed later.
--- @desc The system also stores the last battle for easy retrieval. This is serialised into the saved game.
----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------

pending_battle_cache = {
	battle_cache_version = 1; --Cache version. Please update when making changed to the data in the classes or tables and put an if to cope with older data.
	cached_last_battle = {};
};

function pending_battle_cache:cache_last_pending_battle(query_model)
	self.cached_last_battle = pending_battle_cached_battle:new(query_model);
end;

function pending_battle_cache:get_pending_battle_cache()
	return self.cached_last_battle;
end;

-- Saving lua tables strips out the metatables (removing the functions). In order for loading data to work we must re-establish the relationships.
function pending_battle_cache:post_load_fixup(saved_cached_battle)
	-- If there isn't valid data don't try and load.
	if table.length(saved_cached_battle) == 0 then
		return false;
	end;

	pending_battle_cached_battle:post_load_fixup(saved_cached_battle);

	self.cached_last_battle = saved_cached_battle;
end;


-- #region Pending Battle Cached Battle

-- PENDING BATTLE
pending_battle_cached_battle = {};
function pending_battle_cached_battle:new(query_model)
	local pending_battle = query_model:pending_battle();

	-- Early exit if no character is valid.
	if not query_model or query_model:is_null_interface() then
		script_error("Pending Battle Cache Query Model is Nil!")
		return nil;
	end;

	if not pending_battle or pending_battle:is_null_interface() then
		script_error("Pending Battle Cached Battle is Nil!")
		return nil;
	end;

	-- Declare our class.
	local o = {};
	
	setmetatable(o, self);
	self.__index = self;
	self.__tostring = function() return "TYPE_PENDING_BATTLE_CACHE_BATTLE" end;

	-- Construct the class vars.
	o.battle_cache_version = pending_battle_cache.battle_cache_version;

	o.turn_number = query_model:turn_number();
	o.campaign_name = query_model:campaign_name();
	o.is_multiplayer = query_model:is_multiplayer();
	o.unit_scale_multiplier = query_model:unit_scale_multiplier();
	o.difficulty_level = query_model:difficulty_level();

	o.is_siege = pending_battle:seige_battle();
	o.is_ambush = pending_battle:ambush_battle();
	o.is_naval =  pending_battle:naval_battle();
	o.night_battle = pending_battle:night_battle();
	o.human_involved = pending_battle:human_involved();
	o.battle_type = pending_battle:battle_type();
	o.attacker_is_stronger = pending_battle:attacker_is_stronger();
	o.attackers = {};
	o.defenders = {};

	-- Primary Attacker
	if pending_battle:has_attacker() then
		local attacker_force = pending_battle_cached_force:new(pending_battle:attacker():military_force(), true);

		if attacker_force then
			table.insert(o.attackers, attacker_force);
		end;
	end;

	-- Secondary Attacker
	if not pending_battle:secondary_attackers():is_empty() then
		for i = 0, pending_battle:secondary_attackers():num_items() - 1 do
			local sec_attacker_force = pending_battle_cached_force:new(pending_battle:secondary_attackers():item_at(i):military_force(), true)

			if sec_attacker_force then
				table.insert(o.attackers, sec_attacker_force);
			end;
		end;
	end;

	-- Primary Defender
	if pending_battle:has_defender() then
		local defender_force = pending_battle_cached_force:new(pending_battle:defender():military_force(), false);

		if defender_force then
			table.insert(o.defenders, defender_force);
		end;
	end;

	-- Secondary Defender
	if not pending_battle:secondary_defenders():is_empty() then
		for i = 0, pending_battle:secondary_defenders():num_items() - 1 do
			local sec_defender_force = pending_battle_cached_force:new(pending_battle:secondary_defenders():item_at(i):military_force(), false);

			if sec_defender_force then
				table.insert(o.defenders, sec_defender_force);
			end;
		end;
	end;

	return o;
end;

function pending_battle_cached_battle:post_load_fixup(loaded_battle)
	setmetatable(loaded_battle, self);
	self.__index = self;
	self.__tostring = function() return "TYPE_PENDING_BATTLE_CACHE_BATTLE" end;

	for i, force in ipairs(loaded_battle.attackers) do
		pending_battle_cached_force:post_load_fixup(force);
	end;

	for i, force in ipairs(loaded_battle.defenders) do
		pending_battle_cached_force:post_load_fixup(force);
	end;
end;

function pending_battle_cached_battle:attacker_commander()
    return self.attackers[1].force_commander;
end
 
function pending_battle_cached_battle:defender_commander()
    return self.defenders[1].force_commander;
end

function pending_battle_cached_battle:num_attackers()
	return #self.attackers;
end;

function pending_battle_cached_battle:num_defenders()
	return #self.defenders;
end;

function pending_battle_cached_battle:num_attacker_units(exclude_characters)
	exclude_characters = exclude_characters or false;

	local num_units = 0;
	for i, force in ipairs(self.attackers) do
		num_units = num_units + force:num_units();
	end;

	return num_units;
end;

function pending_battle_cached_battle:num_defender_units(exclude_characters)
	exclude_characters = exclude_characters or false;

	local num_units = 0;
	for i, force in ipairs(self.defenders) do
		num_units = num_units + force:num_units();
	end;

	return num_units;
end;

function pending_battle_cached_battle:num_attacker_unit_key(unit_key)
	local num_units = 0;
	for i, force in ipairs(self.attackers) do
		num_units = num_units + force:num_unit_key(unit_key);
	end;

	return num_units;
end;

function pending_battle_cached_battle:num_defender_unit_key(unit_key)
	local num_units = 0;
	for i, force in ipairs(self.defenders) do
		num_units = num_units + force:num_unit_key(unit_key);
	end;

	return num_units;
end;

function pending_battle_cached_battle:num_faction_unit_key(faction_key, unit_key)
	local num_units = 0;
	for i, force in ipairs(self.attackers) do
		if force.faction == faction_key then
			num_units = num_units + force:num_unit_key(unit_key);
		end;
	end;

	for i, force in ipairs(self.defenders) do
		if force.faction == faction_key then
			num_units = num_units + force:num_unit_key(unit_key);
		end;
	end;

	return num_units;
end;

function pending_battle_cached_battle:num_attacker_unit_class(unit_class)
	local num_units = 0;
	for i, force in ipairs(self.attackers) do
		num_units = num_units + force:num_unit_class(unit_class);
	end;

	return num_units;
end;

function pending_battle_cached_battle:num_defender_unit_class(unit_class)
	local num_units = 0;
	for i, force in ipairs(self.defenders) do
		num_units = num_units + force:num_unit_class(unit_class);
	end;

	return num_units;
end;

function pending_battle_cached_battle:num_faction_unit_class(faction_key, unit_class)
	local num_units = 0;
	for i, force in ipairs(self.attackers) do
		if force.faction == faction_key then
			num_units = num_units + force:num_unit_class(unit_class);
		end;
	end;

	for i, force in ipairs(self.defenders) do
		if force.faction == faction_key then
			num_units = num_units + force:num_unit_class(unit_class);
		end;
	end;

	return num_units;
end;

function pending_battle_cached_battle:num_attacker_unit_category(unit_category)
	local num_units = 0;
	for i, force in ipairs(self.attackers) do
		num_units = num_units + force:num_unit_category(unit_category);
	end;

	return num_units;
end;

function pending_battle_cached_battle:num_defender_unit_category(unit_category)
	local num_units = 0;
	for i, force in ipairs(self.defenders) do
		num_units = num_units + force:num_unit_category(unit_category);
	end;

	return num_units;
end;

function pending_battle_cached_battle:num_faction_unit_category(faction_key, unit_category)
	local num_units = 0;
	for i, force in ipairs(self.attackers) do
		if force.faction == faction_key then
			num_units = num_units + force:num_unit_category(unit_category);
		end;
	end;

	for i, force in ipairs(self.defenders) do
		if force.faction == faction_key then
			num_units = num_units + force:num_unit_category(unit_category);
		end;
	end;

	return num_units;
end;

function pending_battle_cached_battle:faction_was_involved(faction_key)
	return self:faction_was_attacker(faction_key) or self:faction_was_defender(faction_key);
end;

function pending_battle_cached_battle:faction_was_attacker(faction_key)
	for i, force in ipairs(self.attackers) do
		if force.faction == faction_key then
			return true;
		end;
	end;

	return false;
end;

function pending_battle_cached_battle:faction_was_defender(faction_key)
	for i, force in ipairs(self.defenders) do
		if force.faction == faction_key then
			return true;
		end;
	end;

	return false;
end;

function pending_battle_cached_battle:was_character_in_battle(query_character)

	return self:was_character_attacker_in_battle(query_character) or self:was_character_defender_in_battle(query_character)
	
end

function pending_battle_cached_battle:was_character_attacker_in_battle(query_character)
	if(query_character ~= nil and not query_character:is_null_interface()) then
		for i, force in ipairs(self.attackers) do
			for j, retinue in ipairs(force.retinues) do
				local character = retinue.commander
				if character~= nil then
					if character.template == query_character:generation_template_key() then
						return true
					end
				end
			end
		end
	end
	return false
end

function pending_battle_cached_battle:was_character_defender_in_battle(query_character)
	if(query_character ~= nil and not query_character:is_null_interface()) then
		for i, force in ipairs(self.defenders) do
			for j, retinue in ipairs(force.retinues) do
				local character = retinue.commander
				if character~= nil then
					if character.template == query_character:generation_template_key() then
						return true
					end
				end
			end
		end
	end
	return false
end
-- #endregion



-- #region Pending Battle Cached Force

-- FORCE
pending_battle_cached_force = {
	faction = nil;
	force_commander = nil;
	num_retinues = nil;
	cqi = nil;
	retinues = {};
	is_attacker = false;
};
function pending_battle_cached_force:new(military_force, is_attacker)
	
	-- Early exit if no character is valid.
	if not military_force or military_force:is_null_interface() then
		script_error("Pending Battle Cached Force is Nil!!")
		return nil;
	end;

	-- Declare our class.
	local o = {};
	
	setmetatable(o, self);
	self.__index = self;
	self.__tostring = function() return "TYPE_PENDING_BATTLE_CACHE_FORCE" end;

	-- Construct the class vars.
	o.faction = military_force:faction():name();	
	o.num_retinues = military_force:military_force_retinues():num_items();
	o.force_cqi = military_force:command_queue_index();
	o.retinues = {};
	o.is_attacker = is_attacker;

	o.force_commander = pending_battle_cached_character:new(military_force:general_character())

	for i = 0, o.num_retinues - 1 do
		local pb_retinue = pending_battle_retinue:new(military_force:military_force_retinues():item_at(i));
		
		if pb_retinue then
			table.insert(o.retinues, pb_retinue);
		end;
	end;

	return o;
end;

function pending_battle_cached_force:post_load_fixup(loaded_force)
	setmetatable(loaded_force, self);
	self.__index = self;
	self.__tostring = function() return "TYPE_PENDING_BATTLE_CACHE_FORCE" end;

	pending_battle_cached_character:post_load_fixup(loaded_force.force_commander);

	for i, retinue in ipairs(loaded_force.retinues) do
		pending_battle_retinue:post_load_fixup(retinue);
	end;
end;

function pending_battle_cached_force:units()
	local retVal = {};

	for i, retinue in ipairs(self.retinues) do
		for j, unit in ipairs(retinue.units) do
			table.insert(retVal, unit);
		end;
	end;

	return retVal;
end;

function pending_battle_cached_force:characters()
	local retVal = {};

	for i, retinue in ipairs(self.retinues) do
		table.insert(retVal, retinue.commander);
	end;

	return retVal;
end;

function pending_battle_cached_force:num_units(exclude_characters)
	exclude_characters = exclude_characters or false;

	local retVal = 0;

	for i, retinue in ipairs(self.retinues) do
		retVal = retVal + retinue:num_units();
	end;

	return retVal;
end;

function pending_battle_cached_force:num_characters()
	local retVal = 0;

	for i, retinue in ipairs(self.retinues) do
		retVal = retVal + retinue:num_characters();
	end;

	return retVal;
end;

function pending_battle_cached_force:num_unit_key(unit_key)
	local retVal = 0;

	for i, retinue in ipairs(self.retinues) do
		retVal = retVal + retinue:num_unit_key(unit_key);
	end;

	return retVal;
end;

function pending_battle_cached_force:num_unit_class(unit_class)
	local retVal = 0;

	for i, retinue in ipairs(self.retinues) do
		retVal = retVal + retinue:num_unit_class(unit_class);
	end;

	return retVal;
end;

function pending_battle_cached_force:num_unit_category(unit_category)
	local retVal = 0;

	for i, retinue in ipairs(self.retinues) do
		retVal = retVal + retinue:num_unit_category(unit_category);
	end;

	return retVal;
end;

-- #endregion Pending Battle Cached Force


-- #region Pending Battle Retinue

pending_battle_retinue = {
	is_commanding_retinue = false;
	commander = nil;
	units = {};
};

function pending_battle_retinue:new(query_retinue)
	-- Declare our class.
	local o = {};

	setmetatable(o, self);
	self.__index = self;
	self.__tostring = function() return "TYPE_PENDING_BATTLE_CACHE_RETINUE" end;

	o.is_commanding_retinue = query_retinue:retinue_commander_is_commanding_military_force();
	o.commander = nil;
	o.units = {};

	-- Get Commander
	if query_retinue:retinue_commander() and not query_retinue:retinue_commander():is_null_interface() then
		local char_data = pending_battle_cached_character:new(query_retinue:retinue_commander());

		if char_data then
			o.commander = char_data;
		end;
	end;

	-- Get units.
	local retinue_slots = query_retinue:military_force_retinue_slots()
	for j = 0, retinue_slots:num_items() - 1 do
		local retinue_slot = retinue_slots:item_at(j);
		local retinue_slot_unit = retinue_slot:linked_to_unit();

		if retinue_slot_unit and not retinue_slot_unit:is_null_interface() then

			-- Only grab if they're not the commander of that retinue.
			if not retinue_slot:slot_commander() or retinue_slot:slot_commander():is_null_interface() then
				local unit_data = pending_battle_unit:new(retinue_slot_unit);
				if unit_data then
					table.insert(o.units, unit_data);
				end;
			end;
			
		end;
	end;
	-- return the new object
	return o;

end;

function pending_battle_retinue:post_load_fixup(loaded_retinue)
	setmetatable(loaded_retinue, self);
	self.__index = self;
	self.__tostring = function() return "TYPE_PENDING_BATTLE_CACHE_RETINUE" end;

	if loaded_retinue.commander then
		pending_battle_cached_character:post_load_fixup(loaded_retinue.commander);
	end;

	for i, unit in ipairs(loaded_retinue.units) do
		pending_battle_unit:post_load_fixup(unit);
	end;
end;

function pending_battle_retinue:num_units(exclude_characters)
	exclude_characters = exclude_characters or false;

	if not exclude_characters then
		return #self.units + self:num_characters();
	end;
		
	return #self.units;
end;

function pending_battle_retinue:num_characters()
	if self.commander ~= nil then
		return 1;
	end;

	return 0;
end;

function pending_battle_retinue:num_unit_key(unit_key)
	local retVal = 0;

	for i, unit in ipairs(self.units) do
		if unit.unit_key == unit_key then
			retVal = retVal + 1;
		end;
	end;

	return retVal;
end;

function pending_battle_retinue:num_unit_class(unit_class)
	local retVal = 0;

	for i, unit in ipairs(self.units) do
		if unit.unit_class == unit_class then
			retVal = retVal + 1;
		end;
	end;

	return retVal;
end;

function pending_battle_retinue:num_unit_category(unit_category)
	local retVal = 0;

	for i, unit in ipairs(self.units) do
		if unit.unit_category == unit_category then
			retVal = retVal + 1;
		end;
	end;

	return retVal;
end;

-- #endregion Pending Battle Retinue


-- #region Pending Battle Cached Character

-- CHARACTER
pending_battle_cached_character = {
	cqi = nil;
	faction = nil;
	subtype = nil;
	template = nil;
	is_faction_leader = false;
};
function pending_battle_cached_character:new(query_character)

	-- Early exit if no character is valid.
	if not query_character or query_character:is_null_interface() then
		script_error("Pending Battle Cached Character is Nil!!")
		return nil;
	end;

	-- Declare our class.
	local o = {};

	setmetatable(o, self);
	self.__index = self;
	self.__tostring = function() return "TYPE_PENDING_BATTLE_CACHE_CHARACTER" end;

	-- Construct the class vars.
	o.cqi = query_character:command_queue_index();
	o.faction = query_character:faction():name();
	o.subtype = query_character:character_subtype_key();
	o.template = query_character:generation_template_key();
	o.is_faction_leader = query_character:is_faction_leader();

	-- return the new object
	return o;

end;

function pending_battle_cached_character:post_load_fixup(loaded_character)
	setmetatable(loaded_character, self);
	self.__index = self;
	self.__tostring = function() return "TYPE_PENDING_BATTLE_CACHE_CHARACTER" end;
end;

-- #endregion Pending Battle Cached Character


-- #region Pending Battle Cached Unit
-- UNIT
pending_battle_unit = {
	unit_key = nil;
	unit_category = nil;
	unit_class = nil;
	pct_units_alive = nil;
	rank = nil;
};
function pending_battle_unit:new(query_unit)
	
	-- Early exit if no character is valid.
	if not query_unit or query_unit:is_null_interface() then
		script_error("Pending Battle Cached Unit is Nil!")
		return nil;
	end;

	-- Declare our class.
	local o = {};

	setmetatable(o, self);
	self.__index = self;
	self.__tostring = function() return "TYPE_PENDING_BATTLE_UNIT" end;

	-- Construct the class vars.
	o.unit_key = query_unit:unit_key();
	o.unit_category = query_unit:unit_category();
	o.unit_class = query_unit:unit_class();
	o.pct_units_alive = query_unit:percentage_proportion_of_full_strength();
	o.rank = query_unit:experience_level();

	-- return the new object
	return o;
end;

function pending_battle_unit:post_load_fixup(loaded_unit)
	setmetatable(loaded_unit, self);
	self.__index = self;
	self.__tostring = function() return "TYPE_PENDING_BATTLE_UNIT" end;
end;

-- #endregion Pending Battle Cached Unit
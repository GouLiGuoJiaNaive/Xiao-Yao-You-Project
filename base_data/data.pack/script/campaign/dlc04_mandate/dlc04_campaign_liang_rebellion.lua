------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- LIANG REBELLION
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
dlc04_liang_rebellion = {
	faction_key = "3k_dlc04_faction_liang_rebels",
	phases = { -- Turns must be in order! There must also be a 0 turn. The system will pick the phase with the lowest number of turns.
		{num_turns = 0, ideal_forces = 6, force_strength = 3}, -- Initial Phase
		{num_turns = 3, ideal_forces = 0, force_strength = 3},
		{num_turns = 6, ideal_forces = 0, force_strength = 3},
		{num_turns = 12, ideal_forces = 0, force_strength = 4},
		{num_turns = 15, ideal_forces = 0, force_strength = 2},
		{num_turns = 25, ideal_forces = 0, force_strength = 2}
	},
	rebel_character_start_pos_ids = { -- Will define the initial number of forces, if it's higher than the value in the initial phase
		{template="3k_dlc04_template_historical_beigong_boyu_fire", subtype="3k_general_fire", region="3k_main_anding_capital"}, -- 3k_dlc04_template_historical_beigong_boyu_fire, Anding
		{template="3k_dlc04_template_historical_li_wenhou_wood", subtype="3k_general_wood", region="3k_main_hanzhong_capital"} -- 3k_dlc04_template_historical_li_wenhou_wood
	},
	spawn_regions = {
		"3k_main_jincheng_capital",
		"3k_main_jincheng_resource_1",
		"3k_main_jincheng_resource_2",
		"3k_main_wudu_capital",
		"3k_main_wudu_resource_1",
		"3k_main_wudu_resource_2",
		"3k_main_wuwei_capital",
		"3k_main_wuwei_resource_1",
		"3k_main_wuwei_resource_2",
		"3k_main_anding_capital",
		"3k_main_anding_resource_1",
		"3k_main_anding_resource_2",
		"3k_main_anding_resource_3"
	}
}


function dlc04_liang_rebellion:register_listeners()
	if self:has_finished() then
		return;
	elseif self:has_started() then
		core:add_listener(
			"dlc04_liang_rebellion_update", -- Unique handle
			"WorldStartOfRoundEvent", -- Campaign Event to listen for
			function(context) -- Criteria
				return true;
			end,
			function(context) -- What to do if listener fires.
				self:update();
			end,
			true --Is persistent
		);
	else -- not started or finished.
		
		-- Example: trigger_cli_debug_event trigger_liang_rebellion()
		core:add_cli_listener("trigger_liang_rebellion", 
			function()
				self:start();
			end
		);

		core:add_listener(
			"dlc04_liang_rebellion_start", -- Unique handle
			"WorldStartOfRoundEvent", -- Campaign Event to listen for
			function(context) -- Criteria
				return context:query_model():turn_number() >= 10;
			end,
			function(context) -- What to do if listener fires.
				self:start();
			end,
			false --Is persistent
		);
	end;
end;


function dlc04_liang_rebellion:start()
	global_events_manager:print("!-!-!-! Starting Liang Rebellion !-!-!-!");

	-- start the rebellion
	self:set_has_started(true);
	self:set_turn_started(cm:query_model():turn_number());
	

	-- establish our update listener (this will be established in the register listeners in future playthroughs).
	core:add_listener(
		"dlc04_liang_rebellion_update", -- Unique handle
		"WorldStartOfRoundEvent", -- Campaign Event to listen for
		function(context) -- Criteria
			return true;
		end,
		function(context) -- What to do if listener fires.
			self:update();
		end,
		true --Is persistent
	);

	-- Spawn the liang rebels, lead, by preference by Beigong Boyu.
	for i, char in ipairs(self.rebel_character_start_pos_ids) do
		local selected_region = char.region;
	
		if not selected_region then
			script_error("Error unable to find region, returning the first.");
			selected_region = self.spawn_regions[1];
		end;
		
		local invasion = campaign_invasions:create_invasion(self.faction_key, selected_region, 3, true, nil);

		if invasion then
			if i == 1 then 
				-- Make first char faction leader.
				invasion:create_general(true, char.subtype, char.template); -- override the given general with our own one.
			else
				invasion:create_general(false, char.subtype, char.template); -- override the given general with our own one.
			end;

			invasion:start_invasion();
		end
	end;

	-- Call an update to 'bolster up' the rebels.
	self:update();

	-- Fire a global event
	core:trigger_event("DLC04LiangRebellionStarts");

	-- Declare war on the entire Han Dynasty
	diplomacy_manager:apply_automatic_deal_between_factions("3k_dlc04_faction_empress_he", self.faction_key, "data_defined_situation_alliance_to_faction_war_no_vote", false);
	diplomacy_manager:apply_automatic_deal_between_factions(self.faction_key, "3k_dlc04_faction_empress_he", "data_defined_situation_alliance_to_faction_war_no_vote", false);
	diplomacy_manager:apply_automatic_deal_between_factions("3k_dlc04_faction_empress_he", self.faction_key, "data_defined_situation_alliance_to_alliance_war_no_vote", false);
	
	--- if Dong Zhuo has left the Empire, declare war on him too.
	if not cm:modify_faction("3k_main_faction_dong_zhuo"):query_faction():has_specified_diplomatic_deal_with_anybody("treaty_components_empire") then
		diplomacy_manager:apply_automatic_deal_between_factions(self.faction_key, "3k_main_faction_dong_zhuo", "data_defined_situation_war_proposer_to_recipient")
	end
	-- Set Ma Teng and Han Sui as part of this rebellion.
	
end;


function dlc04_liang_rebellion:update()
	-- Make sure the rebellion is kept strong for X turns.

	if self:has_finished() then
		core:remove_listener("dlc04_liang_rebellion_update");
		return;
	end;

	-- #region Phase Selection
	local turn_number = cm:query_model():turn_number();
	local current_phase = nil;
	local phase_id = 0;
	local turns_elapsed = self:turns_elapsed(turn_number);

	for i, phase in ipairs(self.phases) do
		-- If we've already found our highest then we can skip the rest.
		if phase.num_turns > turns_elapsed then
			break;
		end;

		phase_id = i;
		current_phase = phase;
	end;

	if not current_phase then
		script_error("Error unable to find spawn phase, returning the first.");
		current_phase = self.phases[1];
	end;

	global_events_manager:print("!-!-!-! Liang Rebellion: Update Turns Elapsed [" .. turns_elapsed .. "], Current Phase [" .. phase_id .. "] !-!-!-!");
	-- #endregion

	-- #region Force Spawning	
	local liang_rebels = cm:query_faction(self.faction_key);

	local num_forces = liang_rebels:military_force_list():num_items();

	-- If we've no rebels left, then end the war.
	if num_forces == 0 then
		self:finish();
		return false;
	end;

	for i=1, current_phase.ideal_forces - num_forces do
		-- select a region
		local selected_region = nil;

		-- Roll a weighted random
		local r = cm:modify_model():random_number(0, #self.spawn_regions);

		-- Use our modified values from above to work out the weighting.
		for i, region in ipairs( self.spawn_regions ) do
			r = r - 1; -- Subtract the weighting from our random total above.
			if r <= 0 then -- If we're below 0 then we fall within that attribute's values.
				selected_region = region;
				break;
			end;
		end;

		if not selected_region then
			script_error("Error unable to find region, returning the first.");
			selected_region = self.spawn_regions[1];
		end;

		-- spawn the force
		campaign_invasions:create_invasion(self.faction_key, selected_region, current_phase.force_strength);

		global_events_manager:print("!-!-!-! Liang Rebellion: Spawning Force !-!-!-!");
	end;
	
	-- #endregion

	-- #region Events
	-- late 183/early 184 - Zuo Chang - inspector of liang embezzles money for troops. (apply attrition to all forces).

	-- *late 184 - rebellion rises, takes hostages. Chen Yi negotiates for the hostages, is executed. Bian Zhang forced to join (if alive), Han Sui forced to join.

	-- 185 - Huangfu song sent to deal with it.

	-- 185 - Zhang Wen, DZ, Zhou Shen sent to quell them.

	-- 186 - Bian Zhang dies illness, Beigong Boyu and Li Wenhou die from infighting. 

	-- 186 - Geng Bi appointed, hires the corrupt Cheng Qiu.

	-- *187 - Geng Bi attacks. Ma Teng Joins, Wang Guo joins.

	-- 189 - Song Jian, Ma Teng, Han Sui become warlords in the West.

	-- 211 - Liang Rebellion ends.

	-- #endregion
end;


function dlc04_liang_rebellion:finish()
	global_events_manager:print("!-!-!-! Ending Liang Rebellion !-!-!-!");

	core:trigger_event("DLC04LiangRebellionEnds");

	self:set_has_finished(true);
end;


function dlc04_liang_rebellion:set_has_started(boolean)
	return cm:set_saved_value("has_started", boolean, "global_events", "liang_rebellion");
end;


function dlc04_liang_rebellion:has_started()
	if not cm:saved_value_exists("has_started", "global_events", "liang_rebellion") then
		return false;
	end;

	return cm:get_saved_value("has_started", "global_events", "liang_rebellion");
end;


function dlc04_liang_rebellion:set_has_finished(boolean)
	return cm:set_saved_value("has_finished", boolean, "global_events", "liang_rebellion");
end;


function dlc04_liang_rebellion:has_finished()
	if not cm:saved_value_exists("has_finished", "global_events", "liang_rebellion") then
		return false;
	end;

	return cm:get_saved_value("has_finished", "global_events", "liang_rebellion");
end;


function dlc04_liang_rebellion:set_turn_started(turn_number)
	return cm:set_saved_value("turn_started", turn_number, "global_events", "liang_rebellion");
end;


function dlc04_liang_rebellion:turn_started()
	return cm:get_saved_value("turn_started", "global_events", "liang_rebellion");
end;


function dlc04_liang_rebellion:turns_elapsed(current_turn)
	if not current_turn then
		return 0;
	end;

	return current_turn - self.turn_started();
end;
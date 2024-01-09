---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------
----- Name:			Mandate of Heaven
----- Description: 	DLC04 - Mandate system
-----				Designed to manager and send display to the associated UI systems
-----
---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------

mandate_war_manager = {
	save_key = "mandate_war_manager";
	system_id = "[220] mandate_war_manager - "; -- Debug string to prepend when outputting to console via print()

	num_regions_for_victory = 50;

	game_end_region_key = "3k_main_luoyang_capital";


	region_count_to_effect_bundles = {
		--{count = 10, bundle_key = "3k_main_payload_faction_council_metal_2"}
	};

	yt_faction_groups = {
		{ key = "group_zhang_bao", factions = "3k_dlc04_faction_zhang_bao", display_key = "3k_dlc04_faction_zhang_bao" },
		{ key = "group_zhang_jue", factions = "3k_dlc04_faction_zhang_jue", display_key = "3k_dlc04_faction_zhang_jue" },
		{ key = "group_zhang_liang", factions = "3k_dlc04_faction_zhang_liang", display_key = "3k_dlc04_faction_zhang_liang" },
		{
			key = "group_other",
			display_key = nil,
			factions = {
				"3k_main_faction_yellow_turban_anding",
				"3k_main_faction_yellow_turban_generic",
				"3k_main_faction_yellow_turban_rebels",
				"3k_main_faction_yellow_turban_taishan"
			}
		}
	};

	han_dynasty_faction_key = "3k_dlc04_faction_empress_he";
	yt_leader_faction_key = "3k_dlc04_faction_zhang_jue";
};

-- #region Initialisers
function mandate_war_manager:initialise()

	-- Debug functions
	-- Example: trigger_cli_debug_event mandate.trigger_war()
	core:add_cli_listener("mandate.trigger_war",
		function()
			self:print("Debug Trigger Start");
			self:start_war();
		end
	);

	-- Example: trigger_cli_debug_event mandate.end_war(true)
	core:add_cli_listener("mandate.end_war",
		function(han_victory)
			self:print("Debug Trigger End");
			han_victory = han_victory or false;
			self:end_war(han_victory);
		end
	);

	core:add_cli_listener("mandate.update_ui",
		function()
			self:print("Debug Refresh UI");
			self:update_ui();
		end
	);

	-- Example: trigger_cli_debug_event mandate.debug_score()
	core:add_cli_listener("mandate.debug_score",
		function()
			self:print("Debug Score");

			self:print("Total Regions: " .. tostring(self:get_total_yt_regions()));
			for i, group in ipairs(self.yt_faction_groups) do
				self:print("Group: " .. tostring(group.key) .. " Score: " .. self:get_group_score(group));
			end;
		end
	);

	if self:has_finished() then
		self:print("Initialise() Mandate War has finished. Exiting.");
		return;

	elseif self:is_active() then
		self:resume();

	elseif not self:has_started() then
		if #cm:get_human_factions() == 1 then
			-- Test if we should start
			core:add_listener(
				"mandate_round_listener_singleplayer", -- Unique handle
				"WorldStartOfRoundEvent", -- Campaign Event to listen for
				function(context) -- Criteria
					return context:query_model():turn_number() == 8; --Criteria Test
				end,
				function(context) -- What to do if listener fires.
					self:start_war_dilemmas()
				end,
				true --Is persistent
			);
			core:add_listener(
				"mandate_end_round_listener", -- Unique handle
				"DilemmaChoiceMadeEvent", -- Campaign Event to listen for
				function(context) -- Criteria
					return context:dilemma() == "3k_dlc04_progression_global_yellow_turban_rebellion_starts_dilemma"
					or context:dilemma() == "3k_dlc04_progression_global_yellow_turban_rebellion_starts_dilemma_emperor_variant"
					or context:dilemma() == "3k_dlc04_progression_global_yellow_turban_rebellion_starts_ytr_dilemma"
				end,
				function(context) -- What to do if listener fires.
					self:start_war();
				end,
				true --Is persistent
			);
		else
			core:add_listener(
				"mandate_round_listener", -- Unique handle
				"WorldStartOfRoundEvent", -- Campaign Event to listen for
				function(context) -- Criteria
					return context:query_model():turn_number() == 8; --Criteria Test
				end,
				function(context) -- What to do if listener fires.
					self:start_war_incidents();
					self:start_war();
				end,
				true --Is persistent
			);		
		end
	end;

end;

function mandate_war_manager:register_war_listeners()

	core:add_listener(
		"mandate_death_listener",
		"CharacterDied",
		function(context) -- Criteria
			return self:is_active(); --Criteria Test
		end,
		function(context) -- What to do if listener fires.
			self:print("Updating: CharacterDied");
			self:update_ui();

			self:update_effect_bundles();

			self:check_for_war_end();
		end,
		true --Is persistent
	);

	core:add_listener(
		"mandate_round_listener", -- Unique handle
		"WorldStartOfRoundEvent", -- Campaign Event to listen for
		function(context) -- Criteria
			return self:is_active(); --Criteria Test
		end,
		function(context) -- What to do if listener fires.
			self:print("Updating: RoundStart");
			self:update_ui();

			self:update_effect_bundles();

			self:check_for_war_end();

			self:set_last_round_score( self:get_total_yt_regions() );
		end,
		true --Is persistent
	);

	-- We only listen for events where the num_regions might change.
	core:add_listener(
		"mandate_round_listener", -- Unique handle
		"GarrisonOccupiedEvent", -- Campaign Event to listen for
		function(context) -- Criteria
			return self:is_active(); --Criteria Test
		end,
		function(context) -- What to do if listener fires.
			self:print("Updating: GarrisonOccupied");
			self:update_ui();

			self:update_effect_bundles();

			self:check_for_war_end();
		end,
		true --Is persistent
	);

	core:add_listener(
		"mandate_round_listener", -- Unique handle
		"FactionJoinsConfederation", -- Campaign Event to listen for
		function(context) -- Criteria
			return self:is_active(); --Criteria Test
		end,
		function(context) -- What to do if listener fires.
			self:print("Updating: FactionConfederated");
			self:update_ui();
		end,
		true --Is persistent
	);

	core:add_listener(
		"mandate_round_listener", -- Unique handle
		"SettlementRazed", -- Campaign Event to listen for
		function(context) -- Criteria
			return self:is_active(); --Criteria Test
		end,
		function(context) -- What to do if listener fires.
			self:print("Updating: SettlementRazed");
			self:update_ui();
		end,
		true --Is persistent
	);

	core:add_listener(
		"mandate_round_listener", -- Unique handle
		"UICreated", -- Campaign Event to listen for
		function(context) -- Criteria
			return self:is_active(); --Criteria Test
		end,
		function(context) -- What to do if listener fires.
			self:print("Updating: SettlementRazed");
			self:update_ui();
		end,
		true --Is persistent
	);

	core:add_listener(
		"mandate_mission_succeeded",
		"MissionSucceeded",
		function(context)
			return context:mission():mission_record_key() == "3k_dlc04_victory_objective_chain_yellow_turbans_win_mandate_war"
				or context:mission():mission_record_key() == "3k_dlc04_victory_objective_chain_han_factions_win_mandate_war"
		end,
		function(context)
			if context:mission():mission_record_key() == "3k_dlc04_victory_objective_chain_yellow_turbans_win_mandate_war" then
				self:end_war(false); -- YTR Victory
			else
				self:end_war(true); -- Han Victory
			end
		end,
		false
	)
end;

function mandate_war_manager:start_war_incidents()
	if not self:can_trigger_war() then
		script_error("mandate_war_manager:start_war() WAR NOT TRIGGERED THERE AREN'T ENOUGH FACTIONS ALIVE TO DO IT!")
		return;
	end;

	core:trigger_event("DLC04_MandateOfHeavenWarStartedIncidents");
end;

function mandate_war_manager:start_war_dilemmas()
	if not self:can_trigger_war() then
		script_error("mandate_war_manager:start_war() WAR NOT TRIGGERED THERE AREN'T ENOUGH FACTIONS ALIVE TO DO IT!")
		return;
	end;

	core:trigger_event("DLC04_MandateOfHeavenWarStartedDilemmas");
end;

function mandate_war_manager:start_war()

	self:print("start_war() Beggining new war.");
	self:set_started();
	core:trigger_event("DLC04_MandateOfHeavenWarStarted");

	self:war_start_events();
	self:register_war_listeners();

	self:update_ui();
	self:update_effect_bundles();
end;

function mandate_war_manager:resume()
	self:print("resume() Restarting war");
	core:trigger_event("DLC04_MandateOfHeavenWarResuming");

	self:register_war_listeners();

	self:update_ui();
	self:update_effect_bundles();
end;

function mandate_war_manager:end_war(is_han_victory)

	if self:has_finished() then
		script_error("ERROR: Not firing end Mandate war as it's already finished. Please fix this.");
		return;
	end;

	self:print("start_war() Ending the war.");
	self:set_finished();
	core:trigger_event("DLC04_MandateOfHeavenWarFinished");

	if is_han_victory then
		core:trigger_event("DLC04_MandateOfHeavenWarFinished_HanVictory");
	else
		core:trigger_event("DLC04_MandateOfHeavenWarFinished_YTVictory");
	end;

	self:update_ui();
	self:update_effect_bundles();
end;

function mandate_war_manager:check_for_war_end()

	-- Yt Victory - Num regions
	if self:get_total_yt_regions() >= self.num_regions_for_victory then

		-- AND capture Luoyang
		local region = cm:query_region(self.game_end_region_key);
		local region_owner = region:owning_faction();
		if region_owner and not region_owner:is_null_interface() then
			if region_owner:subculture() == "3k_main_subculture_yellow_turban" then
				self:end_war(false);
			end;
		end;
	end;


	-- Han Victory
	local living_yt_factions = 0;
	for i = 1, 3 do
		local key;
		if i == 1 then key = "3k_dlc04_faction_zhang_jue"
		elseif i == 2 then key = "3k_dlc04_faction_zhang_bao"
		elseif i == 3 then key = "3k_dlc04_faction_zhang_liang"
		end;

		local q_faction = cm:query_faction(key);
		if q_faction and not q_faction:is_null_interface() and not q_faction:is_dead() then
			living_yt_factions = living_yt_factions + 1;
		end;
	end

	if living_yt_factions == 0 then
		self:end_war(true);
	end;

end;

function mandate_war_manager:war_start_events()
	--[[
		SPAWN EMERGENT FACTIONS/FORCES
	]]--
	self:print("Spawning Forces");

	-- Gong Du 3k_general_wood	3k_ytr_template_historical_gong_du_hero_wood
	if cm:query_faction("3k_dlc04_faction_zhang_bao"):is_human() == false then
		local gong_du = campaign_invasions:create_invasion("3k_main_faction_yellow_turban_anding", "3k_main_bajun_capital", 3, true);
		local gong_du_character = cm:query_model():character_for_template("3k_ytr_template_historical_gong_du_hero_wood")
		if gong_du_character:is_null_interface() then
			gong_du:create_general(true, "3k_general_wood", "3k_ytr_template_historical_gong_du_hero_wood"); -- override the given general with our own one.
		else
			cm:modify_character(gong_du_character):move_to_faction_and_make_recruited("3k_main_faction_yellow_turban_anding")
		end
		gong_du:start_invasion();
		diplomacy_manager:apply_automatic_deal_between_factions(self.yt_leader_faction_key, "3k_main_faction_yellow_turban_anding", "data_defined_situation_join_alliance_proposer", false);
	end

	-- Huang Shao 3k_general_metal	3k_ytr_template_historical_huang_shao_hero_metal
	if cm:query_faction("3k_dlc04_faction_zhang_liang"):is_human() == false then
		local huang_shao = campaign_invasions:create_invasion("3k_main_faction_yellow_turban_taishan", "3k_main_dongjun_capital", 3, true);
		huang_shao:create_general(true, "3k_general_metal", "3k_ytr_template_historical_huang_shao_hero_metal"); -- override the given general with our own one.
		huang_shao:start_invasion();
		diplomacy_manager:apply_automatic_deal_between_factions(self.yt_leader_faction_key, "3k_main_faction_yellow_turban_taishan", "data_defined_situation_join_alliance_proposer", false);
	end

	-- He Yi 3k_general_water	3k_ytr_template_historical_he_yi_hero_water
	if cm:query_faction("3k_dlc04_faction_zhang_jue"):is_human() == false then
		local he_yi = campaign_invasions:create_invasion("3k_main_faction_yellow_turban_rebels", "3k_main_runan_resource_1", 3, true);
		he_yi:create_general(true, "3k_general_water", "3k_ytr_template_historical_he_yi_hero_water"); -- override the given general with our own one.
		he_yi:start_invasion();
		diplomacy_manager:apply_automatic_deal_between_factions(self.yt_leader_faction_key, "3k_main_faction_yellow_turban_rebels", "data_defined_situation_join_alliance_proposer", false);
	end

	-- 'Generic' Rebellions
	campaign_invasions:create_invasion("3k_main_faction_yellow_turban_generic", "3k_main_yingchuan_resource_1", 2);
	campaign_invasions:create_invasion("3k_main_faction_yellow_turban_generic", "3k_main_yangzhou_capital", 3);
	campaign_invasions:create_invasion("3k_main_faction_yellow_turban_generic", "3k_main_yangzhou_resource_2", 2);
	campaign_invasions:create_invasion("3k_main_faction_yellow_turban_generic", "3k_main_youbeiping_resource_1", 2);
	campaign_invasions:create_invasion("3k_main_faction_yellow_turban_generic", "3k_main_guangling_resource_1", 2);
	campaign_invasions:create_invasion("3k_main_faction_yellow_turban_generic", "3k_main_nanyang_resource_1", 2);

	--[[
		MAKE NEW YT FACTION JOIN ALLIANCE
	]]--
	diplomacy_manager:apply_automatic_deal_between_factions(self.yt_leader_faction_key, "3k_main_faction_yellow_turban_generic", "data_defined_situation_join_alliance_proposer", false);

	--[[
		TRIGGER WAR
	]]--
	self:print("Triggering Deal");

	-- Add actual war between the two faction blocs here.
	local han_dynasty_faction = cm:query_faction(self.han_dynasty_faction_key);

	-- We apply different deals between human and AI Han Dynasty (Emperor) factions.

	local world_factions = cm:query_model():world():faction_list();

	for i = 0, world_factions:num_items() - 1 do
		local target_faction = world_factions:item_at(i);
		-- Must be alive, not us and have an imperial deal with us. Can add more lookups here.
		-- Must not already have mandated powers between the two factions.
		if not target_faction:is_dead()
			and target_faction:name() ~= han_dynasty_faction:name()
			and han_dynasty_faction:has_specified_diplomatic_deal_with("treaty_components_empire", target_faction)
			and not han_dynasty_faction:has_specified_diplomatic_deal_with("data_defined_situation_mandated_powers", target_faction)
		then
			diplomacy_manager:apply_automatic_deal_between_factions(han_dynasty_faction:name(), target_faction:name(), "data_defined_situation_mandated_powers", false)
		end;
	end;

	-- Declare the mandate war.
	diplomacy_manager:apply_automatic_deal_between_factions(self.han_dynasty_faction_key, self.yt_leader_faction_key, "data_defined_situation_alliance_to_alliance_war_no_vote", false);

end;
-- #endregion

-- #region Scoring

function mandate_war_manager:update_ui()

	if not self:is_active() then
		effect.set_context_value("mandate_war_is_active", 0);
		effect.set_context_value("script_ui_state_override", "");  -- Clear our UI override. Affects the UI Ink.
		return;
	end;

	effect.set_context_value("mandate_war_is_active", 1);
	effect.set_context_value("script_ui_state_override", "mandate_war"); -- Set our ui override to be the mandate war. Affects the UI Ink.

	effect.set_context_value("mandate_war_pct_victory", (self:get_total_yt_regions() / self.num_regions_for_victory) * 100);
	effect.set_context_value("mandate_war_victory_score", self.num_regions_for_victory);
	effect.set_context_value("mandate_war_current_score", self:get_total_yt_regions());

	if self:get_total_yt_regions() > self:get_last_round_score() then
		effect.set_context_value("mandate_war_yt_growing", 1);
	elseif self:get_total_yt_regions() < self:get_last_round_score() then
		effect.set_context_value("mandate_war_yt_growing", -1);
	else
		effect.set_context_value("mandate_war_yt_growing", 0);
	end;

	for i, group in ipairs(self.yt_faction_groups) do
		effect.set_context_value("mandate_war_score_" .. group.key, self:get_group_score(group));

		if group.display_key then
			--self:print("I gots a display key!")
			effect.set_context_value("mandate_war_score_name_" .. group.key, group.display_key);
		end;
	end;
end;

function mandate_war_manager:get_num_regions(faction_key)
	local q_faction = cm:query_faction(faction_key);

	if not q_faction or q_faction:is_null_interface() then
		script_error("ERROR: mandate_war_manager:get_num_regions() Faction key [" .. tostring(faction_key) .. "] is not a valid faction.");
		return 0;
	end;

	return q_faction:region_list():num_items();
end;

function mandate_war_manager:get_group_score(group)
	local score = 0;

	if is_table(group.factions) then
		for j, faction in ipairs(group.factions) do
			score = score + self:get_num_regions(faction);
		end;
	else
		score = score + self:get_num_regions(group.factions);
	end;

	return score;
end;

function mandate_war_manager:get_total_yt_regions()
	local score = 0;

	for i, group in ipairs(self.yt_faction_groups) do

		score = score + self:get_group_score(group);

	end;

	return score;
end;
-- #endregion

-- #region Properties

function mandate_war_manager:can_trigger_war()
	-- Check anyone's alive to have the actual war.
	local yt_factions = {};
	local han_factions = {};
	local all_factions = cm:query_model():world():faction_list();
	for i = 0, all_factions:num_items() - 1 do
		local faction = all_factions:item_at(i);

		if not faction:is_dead() then
			if faction:subculture() == "3k_main_subculture_yellow_turban" then
				table.insert(yt_factions, faction:name());
			else
				table.insert(han_factions, faction:name());
			end;
		end
	end;

	-- If either side is no longer fighting then, don't trigger!
	if #yt_factions < 1 or #han_factions < 1 then
		self:print("WARNING: Not triggering war as either the YT or Han are dead.");
		return false;
	end;

	return true;
end;

function mandate_war_manager:set_started()
	self:set_saved_value("has_started", true);
end;

function mandate_war_manager:has_started()
	return self:get_saved_value("has_started");
end;

function mandate_war_manager:set_finished()
	self:set_saved_value("has_finished", true);
end;

function mandate_war_manager:has_finished()
	return self:get_saved_value("has_finished");
end;

function mandate_war_manager:is_active()
	return self:has_started() and not self:has_finished();
end;

function mandate_war_manager:set_last_round_score(score)
	self:set_saved_value("last_round_score", score);
end;

function mandate_war_manager:get_last_round_score()
	if self:get_saved_value("last_round_score") then
		return self:get_saved_value("last_round_score");
	end;

	return 0;
end;

-- Function to print to the console. Wrapps up functionality to there is a singular point.
function mandate_war_manager:print(string)
	out.design(self.system_id .. string);
end;

function mandate_war_manager:get_saved_value(name)
	if not cm:saved_value_exists(name, self.save_key) then
		return nil;
	end;

	return cm:get_saved_value(name, self.save_key);
end;

function mandate_war_manager:set_saved_value(name, value)
	cm:set_saved_value(name, value, self.save_key);
end;

-- #endregion

-- #region Effect Bundles

function mandate_war_manager:update_effect_bundles()
	local num_regions = self:get_total_yt_regions();

	local highest_bundle_key = nil;
	local highest_bundle_score = -1;
	for i, entry in ipairs(self.region_count_to_effect_bundles) do
		if entry.count >= num_regions and entry.count > highest_bundle_score then
			highest_bundle_key = entry.bundle_key;
			highest_bundle_score = entry.count;
		end;
	end;

	if highest_bundle_key and ( highest_bundle_key ~= self:get_active_bundle()  or not self:get_active_bundle() ) then
		local all_factions = cm:query_model():world():faction_list();

		if all_factions and not all_factions:is_empty() then
			for i = 0, all_factions:num_items() - 1 do
				local faction = all_factions:item_at(i);
				local faction_key = faction:name();

				if faction:subculture() == "3k_main_subculture_yellow_turban" then
					if self:get_active_bundle() then
						cm:modify_faction(faction_key):remove_effect_bundle(self:get_active_bundle());
					end;
					self:set_active_bundle(faction_key, highest_bundle_key);
				end;
			end;
		end;
	end;
end;

function mandate_war_manager:set_active_bundle(faction_key, bundle_key)
	cm:modify_faction(faction_key):apply_effect_bundle(bundle_key, 5);
	self:set_saved_value("active_bundle", bundle_key);
end;

function mandate_war_manager:get_active_bundle()
	return self:get_saved_value("active_bundle");
end;

function mandate_war_manager:remove_all_bundles(faction_key)
	for i, entry in ipairs(self.region_count_to_effect_bundles) do
		cm:modify_faction(faction_key):remove_effect_bundle(entry.bundle_key);
	end;

	self:set_saved_value("active_bundle", nil);
end;

-- #endregion
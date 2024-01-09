---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------
----- Name:			dlc06_nanman_shared_progression_events.lua
----- Description: 	This script holds the shared progression events and victory dconditions of the nanman factions.
---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------

nanman_shared_progression_events = {
	victory_emperor_num_regions = 95;
	victory_mission_emperor_key = "3k_dlc06_victory_objective_nanman_become_emperor";
	victory_mission_kingdom_key = "3k_dlc06_victory_objective_nanman_nanman_kingdom";

	victory_nanman_regions_count = 21;
	victory_unfamiliar_territory_regions_count = 50;
	victory_turns_for_victory_completion = 20;

	nanman_regions = {
		"3k_dlc06_jianning_resource_3",
		"3k_dlc06_jiaozhi_resource_3",
		"3k_dlc06_yongchang_capital",
		"3k_dlc06_yongchang_resource_1",
		"3k_dlc06_yunnan_capital",
		"3k_dlc06_yunnan_resource_1",
		"3k_dlc06_yunnan_resource_2",
		"3k_main_fuling_capital",
		"3k_main_fuling_resource_1",
		"3k_main_jiangyang_capital",
		"3k_main_jiangyang_resource_1",
		"3k_main_jiangyang_resource_2",
		"3k_main_jiangyang_resource_3",
		"3k_main_jianning_capital",
		"3k_main_jianning_resource_1",
		"3k_main_jianning_resource_2",
		"3k_main_jiaozhi_resource_2",
		"3k_main_wuling_capital",
		"3k_main_zangke_capital",
		"3k_main_zangke_resource_1",
		"3k_main_zangke_resource_2"
	};
};

-- Setup the listeners for progression and victory conditions.
function nanman_shared_progression_events:setup(local_faction_key, initial_destroy_faction_key, skip_intro_missions)
	skip_intro_missions = skip_intro_missions or false;
	local script_event_key = "script_event_dlc06_" .. local_faction_key;

	-- For 200ad, nanman don't want the intro missions (go straight to unite tribes), so we'll skip them.
	if not skip_intro_missions then
		self:intro_missions(local_faction_key, script_event_key, initial_destroy_faction_key);
	end

	self:progression_missions(local_faction_key, script_event_key);
	self:victory_missions(local_faction_key, script_event_key);

	local local_query_faction = cm:query_faction(local_faction_key);
	-- If we skipped intro missions we need to kick off the unite the tribes missions if it's not already issued (save games).
	if skip_intro_missions and local_query_faction:has_mission_been_issued("3k_dlc06_progression_nanman_unite_the_tribes_mission") == false then 
		core:trigger_event(script_event_key .. "begin_unite_tribes");
	end

	-- Example: trigger_cli_debug_event nanman_progression.skip_to(victory,3k_dlc06_faction_nanman_king_meng_huo)
	core:add_cli_listener("nanman_progression.skip_to", 
		function(skip_step, faction_key)
			local query_faction = cm:query_faction(faction_key);

			if not query_faction or query_faction:is_null_interface() then
				return false;
			end;

			if not skip_step then
				return false;
			end;

			if skip_step == "emperor" then
				core:trigger_event(script_event_key .. "_activate_emperor_victory");
			elseif skip_step == "kingdom" then
				core:trigger_event(script_event_key .. "_activate_nanman_kingdom_victory");
			elseif skip_step == "victory" then
				progression:force_campaign_victory(query_faction);
			end;
		end
	);


	--SHORTCUT CLI COMMANDS FOR TESTING PURPOSES

	-- shortcut so we can assign lots of nanman regions to our faction, to test the victory condition
	-- Example: trigger_cli_debug_event nanman_progression.assign_all_nanman_regions(3k_dlc06_faction_nanman_king_meng_huo)
	core:add_cli_listener("nanman_progression.assign_all_nanman_regions", function(faction_key)
		for i, region in ipairs(self.nanman_regions) do
			if cm:query_region(region):owning_faction():name() ~= faction_key then
				cm:modify_region(region):settlement_gifted_as_if_by_payload(cm:modify_faction(faction_key))
			end
		end
	end);

	-- shortcut so we can assign lots of non-nanman regions to our faction, to test the victory condition
	-- Example: trigger_cli_debug_event nanman_progression.assign_non_nanman_regions(3k_dlc06_faction_nanman_king_meng_huo)
	core:add_cli_listener("nanman_progression.assign_non_nanman_regions", function(faction_key)

		local region_list = {
			"3k_main_anding_capital",
			"3k_main_anding_resource_1",
			"3k_main_anding_resource_3",
			"3k_main_anding_resource_2",
			"3k_main_anping_capital",
			"3k_main_anping_resource_1",
			"3k_main_bajun_capital",
			"3k_main_bajun_resource_1",
			"3k_main_badong_resource_1",
			"3k_main_badong_resource_2",
			"3k_main_baxi_capital",
			"3k_main_baxi_resource_2",
			"3k_main_baxi_resource_1",
			"3k_main_beihai_capital",
			"3k_main_beihai_resource_1",
			"3k_main_bohai_capital",
			"3k_main_bohai_resource_1",
			"3k_main_yulin_resource_2",
			"3k_main_cangwu_capital",
			"3k_main_cangwu_resource_3",
			"3k_main_cangwu_resource_2",
			"3k_main_cangwu_resource_1",
			"3k_main_poyang_resource_3",
			"3k_main_wuling_resource_2",
			"3k_main_changsha_resource_2",
			"3k_main_changsha_capital",
			"3k_main_changsha_resource_3",
			"3k_main_changsha_resource_1",
			"3k_main_chenjun_capital",
		}

		for i, region in ipairs(region_list) do
			if cm:query_region(region):owning_faction():name() ~= faction_key then
				cm:modify_region(region):settlement_gifted_as_if_by_payload(cm:modify_faction(faction_key))
			end
		end
	end);
end;

-- #region Intro Missions

-- Missions about starting out your kingdoms.
function nanman_shared_progression_events:intro_missions(local_faction_key, script_event_key, initial_destroy_faction_key)

	if not local_faction_key or not cm:query_faction(local_faction_key) then
		script_error("nanman_shared_progression_events() local faction is invalid " .. tostring(local_faction_key));
		return;
	end;

	if not initial_destroy_faction_key then
		script_error("nanman_shared_progression_events() No initial faction key defined");
		return;
	end;

	if not cm:query_faction(initial_destroy_faction_key) or cm:query_faction(initial_destroy_faction_key):is_null_interface() then
		script_error("nanman_shared_progression_events() Initial faction is not in this startpos. " .. tostring(initial_destroy_faction_key));
		return;
	end;

	core:add_listener(
		"start_progression_missions",
		"FactionTurnStart",
		function(context)
			return cdir_mission_manager:get_turn_number() == 1 and context:faction():name() == local_faction_key;
		end,
		function()
			core:trigger_event(script_event_key.."01");
		end,
		false
	);
	
	-- Defeat your neighbour
	cdir_mission_manager:start_mission_listener(
		local_faction_key,                          -- faction key
		"3k_dlc06_progression_nanman_destroy_faction_mission",                     -- mission key
		"HAVE_DIPLOMATIC_RELATIONSHIP",                                  -- objective type
		{
			"faction " .. initial_destroy_faction_key,
			"treaty_component_set 3k_dlc06_objective_treaties_vassal_or_dead",
			"succeed_on_faction_death"
		},                                                  -- conditions (single string or table of strings)
		{
			"money 2000"
		},                                                  -- mission rewards (table of strings)
		script_event_key.."01",      -- trigger event 
		nil,												-- Listener condition
		false,												-- Fire once
		script_event_key.."02",     -- completion event
		nil,														-- failure event
		"3k_main_victory_objective_issuer"							--mission_issuer
	)
	
	cdir_mission_manager:start_mission_listener(
		local_faction_key,                          -- faction key
		"3k_dlc06_progression_nanman_conquer_regions_mission",                     -- mission key
		"CONTROL_N_REGIONS_INCLUDING",                                  -- objective type
		{
			"total 4"
		},                                                  -- conditions (single string or table of strings)
		{
			"money 2000"
		},                                                  -- mission rewards (table of strings)
		script_event_key.."02",      -- trigger event 
		nil,												-- Listener condition
		false,												-- Fire once
		script_event_key.."begin_unite_tribes",     -- completion event
		nil,														-- failure event
		"3k_main_victory_objective_issuer"							--mission_issuer
	)
end;

-- #endregion Intro Missions


-- #region Progression Missions

-- Sets up the progression mission listeners.
function nanman_shared_progression_events:progression_missions(local_faction_key, script_event_key)

	if not local_faction_key or not cm:query_faction(local_faction_key) then
		script_error("nanman_shared_progression_events() local faction is invalid " .. tostring(local_faction_key));
		return;
	end;
	
	-- Unite the Tribes
	cdir_mission_manager:start_mission_listener(
		local_faction_key,                          -- faction key
		"3k_dlc06_progression_nanman_unite_the_tribes_mission",                     -- mission key
		"SCRIPTED",                                  -- objective type
		{
			"script_key tribes_united",
			"override_text mission_text_text_3k_dlc06_scripted_unite_the_tribes"
		},                                                  -- conditions (single string or table of strings)
		{
			"money 2000",
			"text_display{lookup dummy_dlc06_unlock_nanman_tech_tree;}"
		},                                                  -- mission rewards (table of strings)
		script_event_key.."begin_unite_tribes",      -- trigger event 
		function()
			-- Only allow this if the tribes haven't yet been united
			return not nanman_fealty:get_sv_has_faction_gained_all_fealties(local_faction_key);
		end,												-- Listener condition
		true,												-- Fire once
		script_event_key.."04",     -- completion event
		script_event_key.."04",														-- failure event
		"3k_main_victory_objective_issuer"							--mission_issuer
	)
	
	-- Listener to complete the unite mission once we get all the CEOs.
	core:add_listener(
		"dlc06_progression_missions", -- UID
		"FealtyTribesUnitedBy", -- Event
		function(context)
			return context:faction_key() == local_faction_key 
				and cm:query_model():event_generator_interface():any_of_missions_active(cm:query_faction(local_faction_key), "3k_dlc06_progression_nanman_unite_the_tribes_mission");
		end, --Conditions for firing
		function(context)
			local mod_faction = cm:modify_faction(context:faction_key());
			
			mod_faction:complete_scripted_mission_objective("3k_dlc06_progression_nanman_unite_the_tribes_mission", "tribes_united", true);
		end, -- Function to fire.
		false -- Is Persistent?
	);
end;

-- #endregion


-- #region Victory Missions
function nanman_shared_progression_events:victory_missions(local_faction_key, script_event_key)

	local local_query_faction = cm:query_faction(local_faction_key);

-- EMPEROR VICTORY - shamoke only - win by becoming emperor
	local emperor_dilemma_key = "3k_dlc06_shamoke_cultural_reformation_dilemma";
	
	if not local_query_faction:has_mission_been_issued(self.victory_mission_emperor_key) then
		-- Listener - decision made
		core:add_listener(
			"nanman_shared_progression_victory_mission_emperor",
			"DilemmaChoiceMadeEvent",
			function(context)
				return context:faction():name() == local_faction_key and context:dilemma() == emperor_dilemma_key and context:choice() == 1;
			end,
			function(context)
				core:trigger_event(script_event_key .. "_activate_emperor_victory");
			end,
			false
		);

		-- Mission setup and triggering.
		core:add_listener(
			self.victory_mission_emperor_key,
			script_event_key .. "_activate_emperor_victory",
			true,
			function()
				local sm = string_mission:new(self.victory_mission_emperor_key);
				sm:set_issuer("3k_main_victory_objective_issuer");
				sm:add_primary_objective("BECOME_WORLD_LEADER");
				sm:add_primary_objective("DESTROY_ALL_WORLD_LEADERS");
				sm:add_primary_objective("CONTROL_N_REGIONS_INCLUDING",
					{"total " .. self.victory_emperor_num_regions}
				);
				sm:add_primary_payload("text_display{lookup dummy_game_victory;}");
				sm:trigger_mission_for_faction(local_faction_key);
			end,
			false
		);

	end;


-- NANMAN KINGDOM VICTORY - all nanman - Conquery the regions and hold them.

	-- get all the faction who count towards our victory conditions, count their regions and add to a list so we never count twice. Return both the counts.
	local function get_nanman_and_foreign_region_counts(faction_key)
		local counted_faction_list = {};
		local num_nanman_regions = 0;
		local num_foreign_regions = 0;

		local function count_regions_and_add_faction_to_counted_list(query_faction)
			if not table.contains(counted_faction_list, query_faction:name()) then
				table.insert(counted_faction_list, query_faction:name());

				local total_r = query_faction:region_list():num_items();
				local num_nanman_r = query_faction:region_list():count_if(function(region) return table.contains(self.nanman_regions, region:name()) end);

				num_nanman_regions = num_nanman_regions + num_nanman_r;
				num_foreign_regions = num_foreign_regions + (total_r - num_nanman_r);
			end;
		end;

		count_regions_and_add_faction_to_counted_list(cm:query_faction(faction_key));
		diplomacy_manager:get_all_vassal_factions(faction_key):foreach(count_regions_and_add_faction_to_counted_list);
		diplomacy_manager:get_all_factions_in_alliance(faction_key):foreach(count_regions_and_add_faction_to_counted_list);
		diplomacy_manager:get_all_factions_in_coalition(faction_key):foreach(count_regions_and_add_faction_to_counted_list);


		return num_nanman_regions, num_foreign_regions;
	end;

	
	-- Count our current regions and check for completion. Push our values to the UI when required. UI data is destroyed whenever you load/save, exit campaign.
	local function nanman_kingdom_update_region_counts_and_ui()
		local nanman_region_count, foreign_region_count = get_nanman_and_foreign_region_counts(local_faction_key);

		effect.set_context_value("ScriptValueNanmanLandsRegions", nanman_region_count);

		effect.set_context_value("ScriptValueTotalNumberNonNanmanRegions", self.victory_unfamiliar_territory_regions_count);
		effect.set_context_value("ScriptValueCurrentNonNanmanRegions", nanman_region_count + foreign_region_count);

		--if we have all 21 nanman regions, set our flag to true or clear it if we went below.
		if nanman_region_count >= self.victory_nanman_regions_count then
			cm:modify_faction(local_faction_key):complete_scripted_mission_objective(self.victory_mission_kingdom_key, "nanman_kingdom_own_nanman_regions_victory", true)
		else
			cm:modify_faction(local_faction_key):set_scripted_mission_objective_as_incomplete(self.victory_mission_kingdom_key, "nanman_kingdom_own_nanman_regions_victory")
		end
	end;

	local function instantiate_nanman_kingdom_mission()
		
		local sm = string_mission:new(self.victory_mission_kingdom_key);
		sm:set_issuer("3k_main_victory_objective_issuer");
		sm:add_primary_objective("MEET_ALL_OTHER_OBJECTIVES_FOR_X_TURNS",
		{
			"total "..self.victory_turns_for_victory_completion
		}
		);
		sm:add_primary_objective("SCRIPTED",
			{
				"script_key nanman_kingdom_own_nanman_regions_victory",
				"override_text mission_text_text_3k_dlc06_scripted_own_nanman_regions"
			}
		);
		sm:add_primary_objective("CONTROL_N_REGIONS_INCLUDING",
			{
				"total " .. self.victory_unfamiliar_territory_regions_count
			}
		);

		sm:add_primary_payload("text_display{lookup dummy_game_victory;}");
		sm:trigger_mission_for_faction(local_faction_key);
		
		nanman_kingdom_update_region_counts_and_ui();
	end
	
	if not local_query_faction:has_mission_been_issued(self.victory_mission_kingdom_key) then

		--fires mission when tribes united -- FOR ALL BUT SHAMOKE
		core:add_listener(
			"nanman_shared_progression_victory_mission_kingdom_tribes_united",
			"FealtyTribesUnitedBy",
			function(context)
				local uniter_faction_key = context:faction_key();
				return local_faction_key == uniter_faction_key and uniter_faction_key ~= "3k_dlc06_faction_nanman_king_shamoke"
			end,
			function()
				core:trigger_event(script_event_key .. "_activate_nanman_kingdom_victory");
			end,
			false
		);
	
		--fires mission when tribes united -- SHAMOKE VARIANT
		core:add_listener(
			"nanman_shared_progression_victory_mission_kingdom_tribes_united_shamoke",
			"DilemmaChoiceMadeEvent",
			function(context)
				return context:faction():name() == local_faction_key and context:dilemma() == emperor_dilemma_key and context:choice() == 0;
			end,
			function(context)
				core:trigger_event(script_event_key .. "_activate_nanman_kingdom_victory");
			end,
			false
		);

		-- Mission setup and triggering.
		core:add_listener(
			"nanman_shared_progression_victory_mission_nanman_kingdom",
			script_event_key .. "_activate_nanman_kingdom_victory",
			true,
			function()
				instantiate_nanman_kingdom_mission()
			end,
			false
		);

		-- Post load fixup.
		if nanman_fealty:get_sv_has_faction_gained_all_fealties(local_faction_key)
		and not local_query_faction:has_mission_been_issued(self.victory_mission_emperor_key) then
			
			core:trigger_event(script_event_key .. "_activate_nanman_kingdom_victory");
			-- Clear our listeners as we don't need them any longer.
			core:remove_listener("nanman_shared_progression_victory_mission_kingdom_tribes_united");
			core:remove_listener("nanman_shared_progression_victory_mission_kingdom_tribes_united_shamoke");
		end;

	end


	-- Listener for campaign victory. When any of the required missions are completed, we finish the campaign.
	-- When we take a settlement, count our number of Nanman settlements and non-nanman ones, and complete mission objectives based on these numbers
	core:add_listener(
		"nanman_nanman_kingdom_regions_capture_victory_listener",
		"SettlementCaptured",
		function(context)
			--if the settlement was captured by our faction
			return context:settlement():faction():name() == local_faction_key
		end,
		function(context)
			nanman_kingdom_update_region_counts_and_ui();
		end,
		true
	);

	--this one accounts for gaining lands diplomatically
	core:add_listener(
		"nanman_nanman_kingdom_regions_capture_victory_listener",
		"DiplomacyDealNegotiated",
		function(context)
			--returns true if we have any of the 5 treaties that exchange lands (for nanman)
			if not context:deals():is_null_interface() then
				local proposer_faction_is_nanman_and_human = context:deals():deals():any_of(
					function(deal)
						return deal:proposers():any_of(
							function(negotiation_participant)
								return negotiation_participant:primary_faction():name() == local_faction_key and negotiation_participant:primary_faction():is_human()
							end
						)
					end
				)
				local land_gained_in_treaties = context:deals():deals():any_of(
					function(deal)
						return deal:deal():components():any_of(
							function(deal_component)
								return deal_component:treaty_component_key() == "treaty_components_confederate_proposer" 
								or deal_component:treaty_component_key() == "treaty_components_annex_vassal"
								or deal_component:treaty_component_key() == "treaty_components_vassalage"
								or deal_component:treaty_component_key() == "dummy_component_imperial_subject"
								or deal_component:treaty_component_key() == "treaty_components_region_demand"
							end
						)
					end
				)
				return proposer_faction_is_nanman_and_human and land_gained_in_treaties
			end
		end,
		function(context)
			nanman_kingdom_update_region_counts_and_ui();
		end,
		true
	);


	-- Listener for campaign victory. When any of the required missions are completed, we finish the campaign.
	-- validates if our region counts are still valid (we might have lost some in other factions' turns)
	-- if they are, starts our final counter
	core:add_listener(
		"nanman_nanman_kingdom_turns_counter_victory_listener",
		"FactionTurnStart",
		function(context)
			--if its our faction's turn
			return context:faction():name() == local_faction_key
		end,
		function(context)
			nanman_kingdom_update_region_counts_and_ui();
		end,
		true
	);

	-- UI created happens generally when the UI is forced to refresh, but it doesn't have model access, so we'll ask for it.
	core:add_listener(
		"nanman_kingdom_ui_created_listener",
		"UICreated",
		function(context)
			return context:can_request_model_callback();
		end,
		function(context)
			context:create_model_callback_request("nanman_kingdom_ui_created");
			
			core:add_listener("nanman_kingdom_ui_created", "CampaignModelScriptCallback", 
				function(context) return context:context():event_id() == "nanman_kingdom_ui_created" end,
				function(context) return nanman_kingdom_update_region_counts_and_ui() end,
				false
			)
		end,
		true
	)

	
	-- Listener for campaign victory. When any of the required missions are completed, we finish the campaign.
	core:add_listener(
		"nanman_shared_progression_events_victory_listener",
		"MissionSucceeded",
		function(context)
				return context:mission():mission_record_key() == self.victory_mission_emperor_key
					or context:mission():mission_record_key() == self.victory_mission_kingdom_key
		end,
		function(context)
			progression:force_campaign_victory(context:faction());
		end,
		false
	);
	
	-- Quick force update of the UI when we fire the victory condition method, to make sure it's in sync when starting a game or loading a saved game.
	nanman_kingdom_update_region_counts_and_ui();
end;

function nanman_shared_progression_events:has_any_victory_mission_generated(faction_key)
	return cm:query_faction(faction_key):has_mission_been_issued(self.victory_mission_emperor_key)
		or cm:query_faction(faction_key):has_mission_been_issued(self.victory_mission_kingdom_key)
end;
-- #endregion
---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------
----- Name:			DLC04 GLOBAL EVENTS
----- Description: 	DLC04 - Mandate system
-----				Fires and manages events which affect the world as a whole.
-----
---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- MAIN
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
dlc04_global_events = {};

function dlc04_global_events:new_game()
	cm:modify_region("3k_main_luoyang_capital"):apply_effect_bundle("3k_main_effect_bundle_world_leader_effects_region",-1);
end

function dlc04_global_events:initialise()

	-- Example: trigger_cli_debug_event global_event_yt_victory()
	core:add_cli_listener("global_event_yt_victory",
		function()
			self:win_campaign_yt_factions();
		end
	);

	self:mandate_war_events();
	self:liang_rebellion_events();
	self:fall_of_the_han();
	self:the_peach_garden();
	self:xiahou_bros_join_cao_cao();
	self:misc();
	self:lu_bu_betrays_ding_yuan();
	self:luoyang_capture_listener();
	self:transition_events();
	self:emperor_capture_events();
	self:liu_yan_takeover_from_que_jian();
	
end;

-- #region Global Events
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- GLOBAL EVENTS
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- #region Mandate War
function dlc04_global_events:mandate_war_events()
	local mandate_war_start_dilemmas = global_event:new("mandate_war_start_dilemmas", "DLC04_MandateOfHeavenWarStartedDilemmas");
	mandate_war_start_dilemmas:add_dilemma("3k_dlc04_progression_global_yellow_turban_rebellion_starts_dilemma"); -- Fires for han_factions, except the emperor
	mandate_war_start_dilemmas:add_dilemma("3k_dlc04_progression_global_yellow_turban_rebellion_starts_dilemma_emperor_variant"); -- Fires for the emperor
	mandate_war_start_dilemmas:add_dilemma("3k_dlc04_progression_global_yellow_turban_rebellion_starts_ytr_dilemma"); -- Fires for yt_factions.
	mandate_war_start_dilemmas:register();
	
	local mandate_war_start_incidents = global_event:new("mandate_war_start_incidents", "DLC04_MandateOfHeavenWarStartedIncidents");
	mandate_war_start_incidents:add_incident("3k_dlc04_progression_global_yellow_turban_rebellion_starts_incident"); -- Fires for han_factions, except the emperor
	mandate_war_start_incidents:add_incident("3k_dlc04_progression_global_yellow_turban_rebellion_starts_incident_emperor_variant"); -- Fires for the emperor
	mandate_war_start_incidents:add_incident("3k_dlc04_progression_global_yellow_turban_rebellion_starts_ytr_incident"); -- Fires for yt_factions.
	mandate_war_start_incidents:register();
	
	local mandate_war_start = global_event:new("mandate_war_start", "DLC04_MandateOfHeavenWarStarted");
	mandate_war_start:add_string_mission("3k_dlc04_victory_objective_chain_han_factions_win_mandate_war",
		"EUROPEANS",
		{
			{
				objective_type = "DESTROY_FACTION",
				conditions = {"faction 3k_dlc04_faction_zhang_jue", "faction 3k_dlc04_faction_zhang_bao", "faction 3k_dlc04_faction_zhang_liang"},
				payloads = { "money 4000" }
			}
		},
		function(q_faction)
			return q_faction:subculture() ~= "3k_main_subculture_yellow_turban";
		end
	);
	mandate_war_start:add_string_mission("3k_dlc04_victory_objective_chain_yellow_turbans_win_mandate_war",
		"EUROPEANS",
		{
			{
				objective_type = "CONTROL_N_REGIONS_INCLUDING",
				conditions = {"total ".. tostring(mandate_war_manager.num_regions_for_victory), "region 3k_main_luoyang_capital"},
				payloads = { "effect_bundle{bundle_key 3k_dlc04_mission_payload_campaign_victory_dummy;turns 1;}" }
			}
		},
		function(q_faction)
			return q_faction:subculture() == "3k_main_subculture_yellow_turban";
		end
	);
	mandate_war_start:register();

	-- Only fire event for the Han as the Yellow Turbans will have 'lost' the campaign.
	local mandate_war_end = global_event:new("mandate_war_ends", "DLC04_MandateOfHeavenWarFinished_HanVictory");
	mandate_war_end:add_incident("3k_dlc04_progression_global_yellow_turban_rebellion_ends_incident"); -- Fires for han_factions.
	mandate_war_end:add_post_event_callback(function()
			self:lose_campaign_yt_factions();
		end);
	mandate_war_end:register();

	-- Only fire event for the YTR as the Han will have 'lost' the campaign.
	local mandate_war_end2 = global_event:new("mandate_war_ends2", "DLC04_MandateOfHeavenWarFinished_YTVictory");
	mandate_war_end2:add_incident("3k_dlc04_progression_global_yellow_turban_rebellion_ends_ytr_incident"); -- Fires for yt_factions.
	mandate_war_end2:add_post_event_callback(function()
			self:win_campaign_yt_factions();
		end);
	mandate_war_end2:register();
end;
-- #endregion


-- #region Liang Rebellion
function dlc04_global_events:liang_rebellion_events()
	local liang_rebellion_begins = global_event:new("liang_rebellion_starts", "DLC04LiangRebellionStarts");
	liang_rebellion_begins:add_incident("3k_dlc04_progression_global_liang_rebellion_incident");
	liang_rebellion_begins:register();
end;
-- #endregion


-- #region Rise of Dong Zhuo
function dlc04_global_events:fall_of_the_han()

	-- 000 Emperor Dies event - killed in the dilemma or the incident.
	local emperor_dies = global_event:new("emperor_dies", "WorldStartOfRoundEvent",
		function() return cdir_mission_manager:get_turn_number() >= 33
	end);
	emperor_dies:add_dilemma("3k_dlc04_global_event_fallofhan_00_emperor_feeling_ill_dilemma", function(faction) return cm:is_human_faction("3k_dlc04_faction_empress_he") end);
	emperor_dies:add_dilemma_choice_outcome("3k_dlc04_global_event_fallofhan_00_emperor_feeling_ill_dilemma", 0, "EmperorSaved", 0);
	emperor_dies:add_dilemma_choice_outcome("3k_dlc04_global_event_fallofhan_00_emperor_feeling_ill_dilemma", 1, "EmperorDied", 100);
	emperor_dies:add_incident("3k_dlc04_global_event_fallofhan_00_global_emperor_dies_incident", function(faction) return not cm:is_human_faction("3k_dlc04_faction_empress_he") end, "EmperorDied"); -- Fires for ALL players
	emperor_dies:add_other_player_incident("3k_dlc04_global_event_fallofhan_00_global_emperor_dies_dummy_incident"); -- Not for DZ. No effects
	emperor_dies:add_fallback_callback(function() -- Fires if NEITHER of the events were able to fire.
		-- If the old emperor is still alive, kill him otherwise we get two emperors wandering round
		local q_char = cm:query_model():character_for_template("3k_dlc04_template_historical_emperor_ling_earth");
		if q_char and not q_char:is_null_interface() and not q_char:is_dead() then
			cm:modify_character(q_char):kill_character(false);
		end;

		core:trigger_event("EmperorDied");
	end);
	emperor_dies:register();


	if not cm:is_human_faction("3k_dlc04_faction_empress_he") then -- We assume an alternate history if the Han are a human faction.
		--001 Eunuchs kill he_jin -- Fire one or the other. Also encompasses Dong Zhuo reach luoyang mission. Fires when the emperor dies.
		local he_jin_killed = global_event:new("he_jin_killed", "EmperorDied");
		he_jin_killed:set_delay_events(true);
		-- He Jin is killed - if he's alive.
		he_jin_killed:add_incident("3k_dlc04_global_event_fallofhan_01a_global_eunuchs_kill_he_jin_incident", function(faction) return self:is_character_template_alive("3k_dlc04_template_historical_he_jin_metal") end); -- Fires for ALL players, contains the 'kill he jin payload'
		-- Or a generic other character.
		he_jin_killed:add_incident("3k_dlc04_global_event_fallofhan_01b_global_eunuchs_kill_official_incident", function(faction) return not self:is_character_template_alive("3k_dlc04_template_historical_he_jin_metal") end); -- Fires for ALL players, contains the 'kill official payload'
		he_jin_killed:add_post_event_callback(function()
			if he_jin_killed:has_event_triggered("3k_dlc04_global_event_fallofhan_01b_global_eunuchs_kill_official_incident") then
				global_events_manager:set_flag("EunuchsKilledOfficial");
			else
				global_events_manager:set_flag("EunuchsKilledHeJin");
			end;
			core:trigger_event("HeJinKilled") 
		end);
		he_jin_killed:register();


		--002 DZ avenges the death of He Jin. (DZ only mission)
		local dz_avenge_he_jin = global_event:new("avenge_he_jin", "HeJinKilled");
		dz_avenge_he_jin:set_delay_events(true);
		dz_avenge_he_jin:add_mission("3k_dlc04_global_event_fallofhan_02a_dong_zhuo_avenge_he_jin_mission", function() return global_events_manager:get_flag("EunuchsKilledHeJin") end, "OfficialAvenged", "OfficialAvenged"); -- Fires for Dong Zhuo Only, if failed, go-to next
		dz_avenge_he_jin:add_mission("3k_dlc04_global_event_fallofhan_02b_dong_zhuo_avenge_official_mission", function() return global_events_manager:get_flag("EunuchsKilledOfficial") end, "OfficialAvenged", "OfficialAvenged"); -- Fires for Dong Zhuo Only, if failed, go-to next
		dz_avenge_he_jin:register();


		--003 Eunuchs killed - because Dong Zhuo got there.
		local eunuchs_killed = global_event:new("eunuchs_killed", "OfficialAvenged");
		eunuchs_killed:add_pre_event_callback(function() global_events_manager:set_flag("eunuchs_killed", true) end); -- Set a flag for when the eunuchs being killed.
		eunuchs_killed:add_incident("3k_dlc04_global_event_fallofhan_03a_dong_zhuo_kill_the_eunuchs_incident", function(q_faction) return q_faction:name() == "3k_main_faction_dong_zhuo" end, "EunuchsKilled", "EunuchsKilled"); -- Dong Zhuo arriving after killing the eunuchs
		eunuchs_killed:add_incident("3k_dlc04_global_event_fallofhan_03a_global_kill_the_eunuchs_incident", function(q_faction) return q_faction:name() ~= "3k_main_faction_dong_zhuo" end, "EunuchsKilled", "EunuchsKilled"); -- Eunuchs being killed by anyone else.
		eunuchs_killed:register();


		--004 Eunuchs flee, Empire collapses. Dong Zhuo considers seizing the emperor via event chain
		local dz_can_sieze_emperor = global_event:new("dz_can_sieze_emperor", "WorldStartOfRoundEvent", function() return global_events_manager:get_flag("eunuchs_killed") end);
		dz_can_sieze_emperor:add_pre_event_callback(
			function(context)--- we need to remove the world power status from Luoyang so Dong doesn't become emperor when he confederates.
				local modify_world = cm:modify_model():get_modify_world();
				if modify_world and not modify_world:is_null_interface() then
					modify_world:remove_world_leader_region_status("3k_main_luoyang_capital");
					
					--Remove the imperial garrison unit
					local modify_capital = cm:modify_model():get_modify_region(cm:query_region("3k_main_luoyang_capital"))
					if modify_capital and not modify_capital:is_null_interface() then
						modify_capital:remove_effect_bundle("3k_main_effect_bundle_world_leader_effects_region");
					end;
				end;

				global_events_manager:clear_global_event("emperor_capture_decision");
       		end)
		dz_can_sieze_emperor:add_dilemma("3k_dlc04_global_event_fallofhan_04a_dong_zhuo_seizing_the_emperor_dz_dilemma"); -- DZ Only - Choose whether to kill the emperor.
		dz_can_sieze_emperor:add_dilemma_choice_outcome("3k_dlc04_global_event_fallofhan_04a_dong_zhuo_seizing_the_emperor_dz_dilemma", 0, "EmperorSeized", 100,
			function() 
				diplomacy_manager:force_confederation("3k_main_faction_dong_zhuo", "3k_dlc04_faction_empress_he");
				global_events_manager:set_flag("DongZhuoSeizedTheEmpire");
			end); -- Confederate Han Dynasty
		dz_can_sieze_emperor:add_dilemma_choice_outcome("3k_dlc04_global_event_fallofhan_04a_dong_zhuo_seizing_the_emperor_dz_dilemma", 1, "DidntSeizeEmperor", 0); -- Decreases DZ's intimidation
		dz_can_sieze_emperor:register();
	end;

	--[[ SM: 25/11/19 Removing these events as they aren't up to our quality bar.
	--007 Coalition forms
	local coalition = global_event:new("coalition", "WorldStartOfRoundEvent", function() return global_events_manager:has_global_event_finished("emperor_seized") and not cm:query_faction("3k_main_faction_yuan_shao"):is_dead() end);
	coalition:add_incident("3k_dlc04_global_event_fallofhan_05a_dong_zhuo_the_coalition_incident");
	coalition:add_incident("3k_dlc04_global_event_fallofhan_05a_global_the_coalition_incident");
	coalition:add_post_event_callback(
		function() -- Create the coalition
			
			--self:form_coalition("3k_main_faction_yuan_shao"); -- Removed as it doesn't work as expected.
		end);
	coalition:register();


	--008 Should Luoyang burn?
	local should_luoyang_burn = global_event:new("should_luoyang_burn", "WorldStartOfRoundEvent", function() return global_events_manager:has_global_event_finished("coalition") end);
	should_luoyang_burn:add_dilemma("3k_dlc04_global_event_fallofhan_06a_dong_zhuo_burning_luoyang_dilemma"); -- DZ only decide whether to burn luoyang.
	should_luoyang_burn:add_dilemma_choice_outcome("3k_dlc04_global_event_fallofhan_06a_dong_zhuo_burning_luoyang_dilemma", 0, "DongZhuoBurnedLuoyang", 90);
	should_luoyang_burn:add_dilemma_choice_outcome("3k_dlc04_global_event_fallofhan_06a_dong_zhuo_burning_luoyang_dilemma", 1, "DongZhuoSparedLuoyang", 10);
	should_luoyang_burn:register();


	--009 Burning of Luoyang
	local luoyang_burns = global_event:new("luoyang_burns", "DongZhuoBurnedLuoyang");
	luoyang_burns:add_incident("3k_dlc04_global_event_fallofhan_06b_global_burning_luoyang_incident");
	luoyang_burns:add_post_event_callback(
		function()-- Destroy Luoyang
		cm:modify_region("3k_main_luoyang_capital"):raze_and_abandon_settlement_without_attacking();

		local changan = cm:modify_region("3k_main_changan_capital"):query_region() 	---move capital to Chang'an (if owned)
		if changan:owning_faction():is_null_interface() == false and  changan:owning_faction():name() == "3k_main_faction_dong_zhuo" then
			 cm:modify_faction("3k_main_faction_dong_zhuo"):make_region_capital(changan)
		end
		end);
	luoyang_burns:register();
	]]--
end;
-- #endregion


-- #region Minor chains
function dlc04_global_events:the_peach_garden()
	local local_faction_key = "3k_main_faction_liu_bei";

	local peach_garden_00 = global_event:new("peach_garden_00", "WorldStartOfRoundEvent",
	function(context)
		local q_faction = cm:query_faction(local_faction_key);

		if cm:query_faction(local_faction_key):is_dead() then -- Do not fire for dead liu bei.
			return false;
		end;

		if cdir_mission_manager:get_turn_number() < 8 then -- Don't fire before turn 8.
			return false;
		end;

		if q_faction:military_force_list():is_empty() then -- No military forces.
			return false;
		end;

		local q_force_general = q_faction:military_force_list():item_at(0):general_character();
		
		-- Early exit if we're not in a region, such as a sea region.
		if not q_force_general:has_region() or not q_force_general:region():name() then
			return false;
		end;

		return true;
	end);
	peach_garden_00:add_incident("3k_dlc04_progression_liu_bei_peach_garden_incident");
	peach_garden_00:add_post_event_callback(function()
		local q_faction = cm:query_faction(local_faction_key);
		local m_faction = cm:modify_faction(local_faction_key);

		-- ZHANG FEI & GUAN YU spawn
		local m_char_zhang_fei = m_faction:create_character_from_template("general", "3k_general_fire", "3k_main_template_historical_zhang_fei_hero_fire", true);
		local m_char_guan_yu = m_faction:create_character_from_template("general", "3k_general_wood", "3k_main_template_historical_guan_yu_hero_wood", true);

		-- Spawn them onto the map.
		-- Get the positon of the player's first force.
		local q_force_general = q_faction:military_force_list():item_at(0):general_character();
		local region_key = q_force_general:region():name();
		local general_x = q_force_general:logical_position_x();
		local general_y = q_force_general:logical_position_y();

		-- ZHANG FEI
		local found_pos, x, y = q_faction:get_valid_spawn_location_near(general_x, general_y, 4, false);

		if not found_pos then
			found_pos, x, y = q_faction:get_valid_spawn_location_in_region(region_key, false);
		end;

		if found_pos then
			cm:create_force_with_existing_general(m_char_zhang_fei:query_character():command_queue_index(), local_faction_key, "", region_key, x, y, "liu_bei_zhang_fei", nil, 100);
		end;


		-- GUAN YU
		found_pos, x, y = q_faction:get_valid_spawn_location_near(general_x, general_y, 10, false);

		if not found_pos then
			found_pos, x, y = q_faction:get_valid_spawn_location_in_region(region_key, false);
		end;

		if found_pos then
			cm:create_force_with_existing_general(m_char_guan_yu:query_character():command_queue_index(), local_faction_key, "", region_key, x, y, "liu_bei_guan_yu", nil, 100);
		end;

		-- Remove their items if this was a human.
		if q_faction:is_human() then
			m_faction:ceo_management():remove_ceos("3k_main_ancillary_weapon_serpent_spear_faction");
			m_faction:ceo_management():remove_ceos("3k_main_ancillary_weapon_green_dragon_crescent_blade_faction");
		end;


		global_events_manager:set_flag("PeachGardenOathMade");
	end);
	peach_garden_00:register();
end;


function dlc04_global_events:xiahou_bros_join_cao_cao()
	local local_faction_key = "3k_main_faction_cao_cao";

	local xiahou_bros = global_event:new("xiahou_bros", "FactionTurnStart",
		function(context)
			return progression:has_progression_feature(context:faction(), "rank_noble") and context:faction():name() == local_faction_key;
		end);
	xiahou_bros:add_incident("3k_dlc04_progression_cao_cao_characters_xiahou_bros_join_incident");
	xiahou_bros:add_post_event_callback(function()
		-- Xiahou Dun
		local xiahou_dun_character = cm:query_model():character_for_template("3k_main_template_historical_xiahou_dun_hero_wood")
		
		if not xiahou_dun_character or xiahou_dun_character:is_null_interface() then
			cm:modify_faction(local_faction_key):create_character_from_template("general", "3k_general_wood", "3k_main_template_historical_xiahou_dun_hero_wood", true);
		end
		-- Xiahou Yuan
		local xiahou_yuan_character = cm:query_model():character_for_template("3k_main_template_historical_xiahou_yuan_hero_fire")

		if not xiahou_yuan_character or xiahou_yuan_character:is_null_interface() then
			cm:modify_faction(local_faction_key):create_character_from_template("general", "3k_general_fire", "3k_main_template_historical_xiahou_yuan_hero_fire", true);
		end
		global_events_manager:set_flag("XiahouBrosSpawned");
	end);
	xiahou_bros:register();
end;

function dlc04_global_events:lu_bu_betrays_ding_yuan()
	local lu_bu_betrays_ding_yuan = global_event:new("lu_bu_betrays_ding_yuan", "WorldStartOfRoundEvent",
	function(context)
		return cdir_mission_manager:get_turn_number() >= 30 and not cm:query_faction("3k_main_faction_dong_zhuo"):is_human();
	end);
	lu_bu_betrays_ding_yuan:add_incident("3k_dlc04_historical_global_lu_bu_defects_to_dong_zhuo_dz_npc")
	lu_bu_betrays_ding_yuan:add_other_player_incident("3k_dlc04_historical_global_lu_bu_defects_to_dong_zhuo_dz_npc_mp_dummy")
	lu_bu_betrays_ding_yuan:register()
end



function dlc04_global_events:misc()
	-- Cao Cao takes Chen MP dummy.
	local cao_cao_takes_chen = global_event:new("cao_cao_takes_chen", "dlc04_cao_cao_events_took_chen");
	cao_cao_takes_chen:add_incident("3k_dlc04_global_event_cao_cao_takes_chen");
	cao_cao_takes_chen:register();


	-- Sun Jian recieves the seal.
	local sun_jian_finds_the_imperial_seal = global_event:new("sun_jian_finds_the_imperial_seal", "WorldStartOfRoundEvent",
		function(context)
			-- We check for their being no world leaders, which means that the Empire has fallen.
			return cm:get_total_number_of_world_leaders() == 0;
		end);
	sun_jian_finds_the_imperial_seal:add_incident("3k_main_faction_sun_jade_seal_incident_scripted");
	sun_jian_finds_the_imperial_seal:add_post_event_callback(function()
		-- If we didn't fire the event, give the imperial seal to AI sun jian.
		if not cm:has_incident_fired_for_anyone("3k_main_faction_sun_jade_seal_incident_scripted") then
			local mod_sun_jian = cm:modify_faction("3k_main_faction_sun_jian");

			if not mod_sun_jian or mod_sun_jian:is_null_interface() or mod_sun_jian:query_faction():is_dead() then
				return false;
			end;

			mod_sun_jian:ceo_management():add_ceo("3k_main_ancillary_accessory_imperial_jade_seal");
		end
		end);
	sun_jian_finds_the_imperial_seal:register();


	-- Sun Ren is born.
	local sun_ren_is_born = global_event:new("sun_ren_is_born", "WorldStartOfRoundEvent",
		function() return cdir_mission_manager:get_turn_number() >= 35
	end);
	sun_ren_is_born:add_incident("3k_dlc04_sun_jian_sun_ren_born_scripted")
	sun_ren_is_born:add_post_event_callback(function()
		-- get sun jian
		local q_char_sun_jian = cm:query_model():character_for_template("3k_main_template_historical_sun_jian_hero_metal");

		-- Early exit if he's dead.
		if not q_char_sun_jian or q_char_sun_jian:is_null_interface() or q_char_sun_jian:is_dead() then
			global_events_manager:print("Sun Ren is Born: EXIT: Sun Jian is dead.");
			return;
		end;

		m_faction_sun_jian = cm:modify_faction(q_char_sun_jian:faction());
		m_char_sun_jian = cm:modify_character(q_char_sun_jian);
		
		-- create sun ren.
		local m_char_sun_ren = m_faction_sun_jian:create_character_from_template("general", "3k_general_fire", "3k_main_template_historical_lady_sun_shangxiang_hero_fire", false);

		if not m_char_sun_ren or m_char_sun_ren:is_null_interface() then
			global_events_manager:print("Sun Ren is Born: EXIT: Sun Ren did not spawn.");
			return;
		end;

		-- set her daddy to Sun Jian
		m_char_sun_ren:make_child_of(m_char_sun_jian);

		global_events_manager:print("Sun Ren is Born: spawned, made Sun jian her father.");

		-- if Sun Jian has a wife. We only get a family member back, and we have no efficient way of passing back.
		--[[
		if q_char_sun_jian:family_member():has_spouse() then
			-- Set his wife to be the mother.
			local q_char_spouse = q_char_sun_jian:family_member():spouse();

			if q_char_spouse and not q_char_spouse:is_null_interface() then
				global_events_manager:print("Sun Ren is Born: Making Sun Jian's Wife her mother.");
				local m_char_spouse = cm:modify_character(q_char_spouse);
				m_char_sun_ren:make_child_of(m_char_spouse);
			end;
		end;]]--
		
	end);
	sun_ren_is_born:register();
end;
-- #endregion


-- #region Transition Events
function dlc04_global_events:transition_events()

	-- Transition events after the end of the mandate war to give the player more grounding.
	local transition_event_war_over = global_event:new("transition_event_war_over", "DLC04_MandateOfHeavenWarFinished_HanVictory");
	transition_event_war_over:set_delay_events(true);
	transition_event_war_over:add_incident("3k_dlc04_transition_incident_mandate_war_end_emperor_not_player");
	transition_event_war_over:add_incident("3k_dlc04_transition_incident_emperor_is_player_luoyang_not_owned");
	transition_event_war_over:add_incident("3k_dlc04_transition_incident_emperor_is_player_luoyang_owned");
	transition_event_war_over:register();


	-- Transition events after Emperor Captured
	local transition_event_emperor = global_event:new("transition_event_emperor", "WorldPowerTokenGainedEvent",function(context) return not context.token or context:token() == "emperor" end);
	transition_event_emperor:set_delay_events(true);
	-- Dong Zhuo owns emperor (and either allied or not).
	transition_event_emperor:add_incident("3k_dlc04_transition_incident_emperor_captured_dong_zhuo_allied", function(q_faction) return cm:is_world_power_token_owned_by("emperor", "3k_main_faction_dong_zhuo") end);
	transition_event_emperor:add_incident("3k_dlc04_transition_incident_emperor_captured_dong_zhuo_not_allied", function(q_faction) return cm:is_world_power_token_owned_by("emperor", "3k_main_faction_dong_zhuo") end);
	transition_event_emperor:add_incident("3k_dlc04_transition_incident_emperor_captured_eunuchs", function(q_faction) return cm:is_world_power_token_owned_by("emperor", "3k_dlc04_faction_empress_he") end);
	transition_event_emperor:add_incident("3k_dlc04_transition_incident_emperor_captured_other",
		function(q_faction)
			return not cm:is_world_power_token_owned_by("emperor", q_faction:name())
			and not cm:is_world_power_token_owned_by("emperor", "3k_dlc04_faction_empress_he")
			and not cm:is_world_power_token_owned_by("emperor", "3k_main_faction_dong_zhuo")
		end);
	-- Player owns the Emperor.
	transition_event_emperor:add_incident("3k_dlc04_transition_incident_emperor_captured_player", function(q_faction) return cm:is_world_power_token_owned_by("emperor", q_faction:name()) end);
	transition_event_emperor:add_incident("3k_dlc04_transition_incident_emperor_captured_player_dong_zhuo", function(q_faction) return cm:is_world_power_token_owned_by("emperor", q_faction:name()) end);
	transition_event_emperor:register();
end;
-- #endregion


-- #region Luoyang Capture Listener
function dlc04_global_events:luoyang_capture_listener()
	-- Luoyang Capture Listener - Make Luoyang NOT a world leader region just before it's captured to prevent everyone becoming emperor too early.
	core:add_listener(
        "mandate_luoyang_captured_listener", -- Unique handle
        "SettlementAboutToBeCaptured", -- Campaign Event to listen for
		function(context) -- Criteria
			local region_key = context:settlement():region():name();

            return region_key == "3k_main_luoyang_capital" and context:settlement():faction():name() == "3k_dlc04_faction_empress_he"; --Criteria Test
        end,
        function(context) -- What to do if listener fires.
			output("Updating: Luoyang Captured by Enemies");
			if cm:get_total_number_of_world_leader_seats() == 1 then -- Only remove if we have just 1 world leader seat, which by convention means it's luoyang.
				local modify_world = cm:modify_model():get_modify_world();

				if modify_world and not modify_world:is_null_interface() then
					modify_world:remove_world_leader_region_status("3k_main_luoyang_capital");
					--Remove the imperial garrison unit
					local modify_capital = cm:modify_model():get_modify_region(cm:query_region("3k_main_luoyang_capital"))
					if modify_capital and not modify_capital:is_null_interface() then
						modify_capital:remove_effect_bundle("3k_main_effect_bundle_world_leader_effects_region");
					end;
				end;
			end;
        end,
        false --Is persistent
	);


	---- Strip world leader status from Luoyang if it's razed
	core:add_listener(
        "mandate_luoyang_razed_listener", -- Unique handle
        "CharacterWillPerformSettlementSiegeAction", -- Campaign Event to listen for
		function(context) -- Criteria
			local region_key = context:garrison_residence():region():name();

            return context:option_outcome_enum_key() == "raze" and region_key == "3k_main_luoyang_capital";
        end,
        function(context) -- What to do if listener fires.
			output("Updating: Luoyang Razed by Enemies");
			if cm:get_total_number_of_world_leader_seats() == 1 then -- Only remove if we have just 1 world leader seat, which by convention means it's luoyang.
				local modify_world = cm:modify_model():get_modify_world();

				if modify_world and not modify_world:is_null_interface() then
					modify_world:remove_world_leader_region_status("3k_main_luoyang_capital");
					--Remove the imperial garrison unit
					local modify_capital = cm:modify_model():get_modify_region(cm:query_region("3k_main_luoyang_capital"))
					if modify_capital and not modify_capital:is_null_interface() then
						modify_capital:remove_effect_bundle("3k_main_effect_bundle_world_leader_effects_region");
					end;
				end;
			end;
        end,
        false --Is persistent
	);


	-- Luoyang re-capture listener -- Make the emperor the emperor again if they recapture luoyang under certain conditions.
	-- Note: This will trigger the Three Kingdoms phase if it's not already happened.
	core:add_listener(
        "mandate_luoyang_recaptured_listener", -- Unique handle
        "GarrisonOccupiedEvent", -- Campaign Event to listen for
		function(context) -- Criteria
			if not context:query_character() or context:query_character():is_null_interface() then
				return false;
			end;

			local region_key = context:garrison_residence():region():name();
			local capturing_faction_key = context:query_character():faction():name();
            return region_key == "3k_main_luoyang_capital" and capturing_faction_key == "3k_dlc04_faction_empress_he"; --Criteria Test
        end,
        function(context) -- What to do if listener fires.
			output("Updating: Emperor Recaptured Luoyang");
			local query_faction = context:query_character():faction();

			-- If they've already become a world leader again, then ignore.
			if query_faction:is_world_leader() then
				output("Exiting: Emperor Recaptured Luoyang, but is already world leader.");
				return false;
			end;

			-- If we're already in emperor phase then ignore.
			if cm:get_total_number_of_world_leaders() > 0 then
				output("Exiting: Emperor Recaptured Luoyang, but other world leaders now exist.");
				return false;
			end;

			local modify_world = cm:modify_model():get_modify_world();

			if modify_world and not modify_world:is_null_interface() then
				modify_world:add_world_leader_region_status("3k_main_luoyang_capital");
				
				--Add the imperial seat
				local modify_capital = cm:modify_model():get_modify_region(cm:query_region("3k_main_luoyang_capital"))
				
				if modify_capital and not modify_capital:is_null_interface() then
					modify_capital:apply_effect_bundle("3k_main_effect_bundle_world_leader_effects_region",-1);
				end;
			end;
        end,
        false --Is persistent
	);
end;
-- #endregion


function dlc04_global_events:emperor_capture_events()
	-- Event 1 - Emperor Dilemma, Luoyang Captured.
	local event1 = global_event:new(
		"emperor_capture_decision",
		"CharacterPerformsSettlementSiegeAction",
		function(context)
			return context:garrison_residence():region():name() == "3k_main_luoyang_capital" and context:query_character():faction():subculture() == "3k_main_chinese" and not cm:world_power_token_exists("emperor");
		end);
	event1:add_pre_event_callback(
		function()
			-- Disable the DZ Events.
			global_events_manager:clear_global_event("he_jin_killed");
			global_events_manager:clear_global_event("avenge_he_jin");
			global_events_manager:clear_global_event("eunuchs_killed");
			global_events_manager:clear_global_event("dz_can_sieze_emperor");
		end);
	-- If DZ use this dilemma.
	event1:add_dilemma("3k_dlc04_global_event_fallofhan_04a_dong_zhuo_seizing_the_emperor_dz_dilemma", 
		function(q_faction) 
			return q_faction:name() == "3k_main_faction_dong_zhuo"
			and (cm:query_region("3k_main_luoyang_capital"):is_abandoned() or cm:query_region("3k_main_luoyang_capital"):owning_faction():name() == "3k_main_faction_dong_zhuo") -- Have to do ALL the conditionals here otherwise, both will fire.
		end) -- Choose whether to seize the emperor,  DZ version
	event1:add_dilemma_choice_outcome("3k_dlc04_global_event_fallofhan_04a_dong_zhuo_seizing_the_emperor_dz_dilemma", 0, "EmperorSeized", 100,
		function() diplomacy_manager:force_confederation("3k_main_faction_dong_zhuo", "3k_dlc04_faction_empress_he") end); -- Confederate Han Dynasty
	event1:add_dilemma_choice_outcome("3k_dlc04_global_event_fallofhan_04a_dong_zhuo_seizing_the_emperor_dz_dilemma", 1, "DidntSeizeEmperor", 0); -- Lower intimidation
	-- If not dz use this dilemma.
	event1:add_dilemma("3k_dlc04_global_event_fallofhan_04c_global_seizing_the_emperor_dilemma", 
		function(q_faction) 
			return cm:query_region("3k_main_luoyang_capital"):owning_faction():name() == q_faction:name()
			and q_faction:name() ~= "3k_main_faction_dong_zhuo" -- Have to do ALL the conditionals here otherwise, both will fire.
		end);-- Choose whether to seize the emperor
	event1:add_dilemma_choice_outcome("3k_dlc04_global_event_fallofhan_04c_global_seizing_the_emperor_dilemma", 0, "EmperorSeized", 90,
		function(context) diplomacy_manager:force_confederation(cm:query_region("3k_main_luoyang_capital"):owning_faction():name(), "3k_dlc04_faction_empress_he") end); -- Confederate Han Dynasty
	event1:add_dilemma_choice_outcome("3k_dlc04_global_event_fallofhan_04c_global_seizing_the_emperor_dilemma", 1, "DidntSeizeEmperor", 10); -- Don't confederate
	event1:add_post_event_callback(function(context)
		-- If the old emperor is still alive, kill him otherwise we get two emperors wandering round
		local q_char = cm:query_model():character_for_template("3k_dlc04_template_historical_emperor_ling_earth");
		if q_char and not q_char:is_null_interface() and not q_char:is_dead() then
			cm:modify_character(q_char):kill_character(false);
		end;
	end);
	event1:register();


	-- Event 2 - Emperor captured
	local event2 = global_event:new("emperor_captured","EmperorSeized");
	event2:add_pre_event_callback(function()
		global_events_manager:clear_global_event("emperor_released");
	end);
	-- If dz use this event. Confederates the Han
	event2:add_incident("3k_dlc04_global_event_fallofhan_04a_global_seizing_the_emperor_dz_npc_incident", function(faction) return (cm:query_region("3k_main_luoyang_capital"):is_abandoned() or cm:query_region("3k_main_luoyang_capital"):owning_faction():name() == "3k_main_faction_dong_zhuo") and cm:query_region("3k_main_luoyang_capital"):owning_faction():name() ~= faction:name() end); -- Not for DZ. Performs the confederation.
	event2:add_other_player_incident("3k_dlc04_global_event_fallofhan_04a_global_seizing_the_emperor_dz_npc_dummy_incident", function(faction) return (cm:query_region("3k_main_luoyang_capital"):is_abandoned() or cm:query_region("3k_main_luoyang_capital"):owning_faction():name() == "3k_main_faction_dong_zhuo") and cm:query_region("3k_main_luoyang_capital"):owning_faction():name() ~= faction:name() end); -- Not for DZ. No effects
	-- else. Confederates the Han.
	event2:add_incident("3k_dlc04_global_event_fallofhan_04b_global_seizing_the_emperor_npc_incident", function(faction) return cm:query_region("3k_main_luoyang_capital"):owning_faction():name() ~= "3k_main_faction_dong_zhuo" and cm:query_region("3k_main_luoyang_capital"):owning_faction():name() ~= faction:name() end); -- Not for DZ. Performs the confederation.
	event2:add_other_player_incident("3k_dlc04_global_event_fallofhan_04b_global_seizing_the_emperor_npc_dummy_incident", function(faction) return cm:query_region("3k_main_luoyang_capital"):owning_faction():name() ~= "3k_main_faction_dong_zhuo" and cm:query_region("3k_main_luoyang_capital"):owning_faction():name() ~= faction:name() end); -- Not for DZ. No effects
	-- Move emperor token over!
	event2:add_post_event_callback(function(context)
		-- Get the owner of Luoyang
		local q_luoyang = cm:query_region("3k_main_luoyang_capital");
		local m_faction_luoyang = cm:modify_faction("3k_main_faction_dong_zhuo")
		if not cm:query_region("3k_main_luoyang_capital"):is_abandoned() then
			m_faction_luoyang = cm:modify_faction( q_luoyang:owning_faction() );
		end

		-- Spawn emperor for owner of Luoyang
		local wp_tokens = cm:modify_world_power_tokens();
		if wp_tokens and not wp_tokens:is_null_interface() then
			wp_tokens:transfer("emperor", m_faction_luoyang);
		end;

		---Move capital to Luoyang
		if not cm:query_region("3k_main_luoyang_capital"):is_abandoned() then
			m_faction_luoyang:make_region_capital(q_luoyang)
		end
	end);
	event2:register();


	-- Event 3 - Emperor Released
	local event3 = global_event:new("emperor_released","DidntSeizeEmperor");
	event3:add_pre_event_callback(function()
		global_events_manager:clear_global_event("emperor_captured");
	end);
	event3:add_pre_event_callback(function(context, event) --- spawn the world power token for the emperor faction if they're still around
		if not cm:modify_faction("3k_dlc04_faction_empress_he"):query_faction():is_dead() then
			local wp_tokens = cm:modify_world_power_tokens();
			if wp_tokens and not wp_tokens:is_null_interface() then
				wp_tokens:transfer("emperor", cm:modify_faction("3k_dlc04_faction_empress_he"))
			end;
		else -- otherwise find someone using the emperor manager function. Prefer dong zhuo, unless he's human, but otherwise let the script pick.
			local emperor_destination = nil;
			if cm:modify_faction("3k_main_faction_dong_zhuo"):query_faction():is_human() then
				emperor_destination = campaign_emperor_manager:find_best_faction_for_emperor(cm:modify_faction("3k_main_faction_dong_zhuo"):query_faction(),-50)
			else
				emperor_destination = campaign_emperor_manager:find_best_faction_for_emperor(cm:modify_faction("3k_main_faction_dong_zhuo"):query_faction(),150)
			end

			if emperor_destination then
				local wp_tokens = cm:modify_world_power_tokens();
				if wp_tokens and not wp_tokens:is_null_interface() then
					wp_tokens:transfer("emperor", cm:modify_faction(emperor_destination:name()))
				end;
			end;
		end;
	end);
	event3:register();

end;

function dlc04_global_events:liu_yan_takeover_from_que_jian()

	local que_jian_dies_event = global_event:new("que_jian_dies_liu_yan_takes_over", "FactionTurnStart",
		function(context)
			return context:faction():name() == "3k_main_faction_liu_yan" and not context:faction():is_human()
		end)
		que_jian_dies_event:set_valid_dates(188, 189)
		que_jian_dies_event:add_incident("3k_dlc07_incident_historical_liu_yan_takes_yi_province");
		que_jian_dies_event:add_post_event_callback(
		function(context)
			local liu_yan_character = cm:query_model():character_for_template("3k_main_template_historical_liu_yan_hero_water")
			local lady_liu_character = cm:query_model():character_for_template("3k_main_template_generated_lady_liu_mengan_hero_water")
			local liu_zhang_character = cm:query_model():character_for_template("3k_main_template_historical_liu_zhang_hero_earth")
			local que_jian_character = cm:query_model():character_for_template("3k_dlc07_template_generated_xi_jian_hero_earth")

			if not liu_yan_character:is_null_interface() and not liu_yan_character:is_dead() then
				cm:modify_character(liu_yan_character:cqi()):move_to_faction_and_make_recruited("3k_main_faction_liu_yan")
				cm:modify_character(liu_yan_character:cqi()):assign_faction_leader()
			end

			if not lady_liu_character:is_null_interface() and not lady_liu_character:is_dead() then
				cm:modify_character(lady_liu_character:cqi()):move_to_faction_and_make_recruited("3k_main_faction_liu_yan")
			end

			if not liu_zhang_character:is_null_interface() and not liu_zhang_character:is_dead() then
				cm:modify_character(liu_zhang_character:cqi()):move_to_faction_and_make_recruited("3k_main_faction_liu_yan")
			end

			if not que_jian_character:is_null_interface() and not que_jian_character:is_dead() then
				cm:modify_character(que_jian_character:cqi()):kill_character(true)
			end
		end
	)
	que_jian_dies_event:register()

end

-- #region Helpers
function dlc04_global_events:form_coalition(coalition_leader_key)

	-- list of coalition factions
	local coalition_factions = {
		"3k_main_faction_liu_bei",
		"3k_main_faction_cao_cao",
		"3k_main_faction_sun_jian",
		"3k_main_faction_yuan_shu",
		"3k_main_faction_kong_rong",
		"3k_dlc04_faction_prince_liu_chong"
	};

	local leader_faction = cm:query_faction(coalition_leader_key);
	if not leader_faction or leader_faction:is_null_interface() or leader_faction:is_dead() then
		script_error("ERROR: leader_faction is dead or missing. " .. tostring(coalition_leader_key));
		return false;
	end

	for i, faction_key in ipairs(coalition_factions) do
		if faction_key == coalition_leader_key then
			-- don't add.
		else
			local q_faction = cm:query_faction(faction_key);
			if q_faction and not q_faction:is_null_interface() and not q_faction:is_dead() then

				diplomacy_manager:apply_automatic_deal_between_factions(coalition_leader_key, faction_key, "data_defined_situation_create_coalition_yuan_shao");
			end;
		end
	end;
end;


-- We have 2 victory types, 3k_main_long_victory & 3k_main_ultimate_victory.
function dlc04_global_events:win_campaign_yt_factions()
	local human_factions = cm:get_human_factions();

	for i, faction_key in ipairs( human_factions ) do
		local query_faction = cm:query_faction(faction_key);

		if query_faction:subculture() == "3k_main_subculture_yellow_turban" then -- win if YT faction
			cm:modify_faction(query_faction):complete_custom_mission("3k_main_long_victory");
		elseif query_faction:subculture() == "3k_main_chinese" then -- Lose if Han Faction
			cm:modify_faction(query_faction):cancel_custom_mission("3k_main_long_victory");
		end;
	end;
end;


function dlc04_global_events:lose_campaign_yt_factions()
	local human_factions = cm:get_human_factions();

	for i, faction_key in ipairs( human_factions ) do
		local query_faction = cm:query_faction(faction_key);

		if query_faction:subculture() == "3k_main_subculture_yellow_turban" then -- Lose if YT faction
			cm:modify_faction(query_faction):cancel_custom_mission("3k_main_long_victory");
		end;
	end;
end;

function dlc04_global_events:is_character_template_alive(template_key)
	local q_char = cm:query_model():character_for_template(template_key);
	if q_char and not q_char:is_null_interface() and not q_char:is_dead() then
		return true;
	end;

	return false;
end;
-- #endregion
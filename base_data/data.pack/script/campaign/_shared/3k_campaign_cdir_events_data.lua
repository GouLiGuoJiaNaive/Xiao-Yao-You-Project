
--***********************************************************************************************************
--***********************************************************************************************************
-- MIRROR EVENTS
--***********************************************************************************************************
--***********************************************************************************************************


-- List events and 'mirror' versions of them to fire if in multiplayer.
-- [key_of_Event] = {event_to_fire_key, is_incident, choice_required}
cdir_events_manager.mp_mirror_events = {
	["3k_main_historical_sun_jian_dies_npc_incident_scripted"] = {"3k_main_historical_sun_jian_dies_npc_incident_mp_dummy", true}, -- [event to listen for] = event to fire, is_incident, dilemma_choice.
	["3k_main_historical_sun_jian_dies_npc_incident"] = {"3k_main_historical_sun_jian_dies_npc_incident_mp_dummy", true},
	["3k_dlc04_historical_global_killing_liu_chong_followup_incident"] = {"3k_dlc04_historical_global_killing_liu_chong_followup_mp_dummy_incident", true},
	["3k_dlc04_historical_yuan_shu_yuan_shu_emperor_dilemma"] = {"3k_dlc04_historical_global_yuan_shu_emperor_mp_dummy_incident", true, 1}
};



--***********************************************************************************************************
--***********************************************************************************************************
-- CUSTOM POST_EVENT_ACTIONS
--***********************************************************************************************************
--***********************************************************************************************************


-- List of functions to fire after certain events have triggered.
-- [key_of_Event] = {function, choice}
cdir_events_manager.post_trigger_actions = {
	["3k_main_historical_dong_fall_of_empire_npc_incident"] = {
		function()
			cdir_events_manager:trigger_civil_war_in_faction("3k_main_faction_dong_zhuo", {"3k_main_template_historical_li_jue_hero_fire","3k_main_template_historical_guo_si_hero_fire"})
		end, 
		nil
	},
	["3k_main_tutorial_progression_ma_teng_primary_dilemma_scripted"] = {
		function()
			cdir_events_manager:trigger_civil_war_in_faction("3k_main_faction_dong_zhuo", {"3k_main_template_historical_li_jue_hero_fire","3k_main_template_historical_guo_si_hero_fire"})
		end,
		nil
	},
	["3k_main_tutorial_progression_ma_teng_primary_dilemma_scripted_allied_dz"] = {
		function()
			cdir_events_manager:trigger_civil_war_in_faction("3k_main_faction_dong_zhuo", {"3k_main_template_historical_li_jue_hero_fire","3k_main_template_historical_guo_si_hero_fire"})
		end,
		nil
	},
	["3k_main_tutorial_progression_ma_teng_primary_dilemma_scripted_allied_mt"] = {
		function()
			cdir_events_manager:trigger_civil_war_in_faction("3k_main_faction_dong_zhuo", {"3k_main_template_historical_li_jue_hero_fire","3k_main_template_historical_guo_si_hero_fire"})
		end,
		nil
	},
	["3k_main_historical_liu_zhuge_liang_npc_incident"] = {
		function()
			cdir_events_manager:spawn_character_subtype_template_in_faction("3k_main_faction_liu_bei", "3k_general_water", "3k_main_template_historical_zhuge_liang_hero_water");
		end,
		nil
	},
	["3k_main_historical_cao_sima_yi_npc_incident"] = {
		function()
			cdir_events_manager:spawn_character_subtype_template_in_faction("3k_main_faction_cao_cao", "3k_general_water", "3k_main_template_historical_sima_yi_hero_water");
		end,
		nil
	},
	["3k_main_tutorial_progression_sun_jian_primary_dilemma_scripted"] = {
		function() cdir_events_manager:add_or_remove_ceo_from_faction("3k_main_faction_liu_biao", "3k_main_ancillary_accessory_imperial_jade_seal", true); end,
		0
	},
	["3k_main_tutorial_progression_sun_jian_primary_dilemma_scripted_allied_lb"] = {
		function() cdir_events_manager:add_or_remove_ceo_from_faction("3k_main_faction_liu_biao", "3k_main_ancillary_accessory_imperial_jade_seal", true); end,
		0
	},
	["3k_main_tutorial_progression_tao_qian_primary_dilemma_scripted"] = { -- Kill Cao Song
		function() cdir_events_manager:kill_startpos_character( "1258522052", false ); end,
		nil
	},
	["3k_main_tutorial_progression_tao_qian_primary_dilemma_scripted_allied_cc"] = { -- Kill Cao Song
		function() cdir_events_manager:kill_startpos_character( "1258522052", false ); end,
		nil
	},
	["3k_main_tutorial_progression_liu_bei_primary_dilemma_scripted"] = { -- Kill Cao Song
		function() cdir_events_manager:kill_startpos_character( "1258522052", false ); end,
		nil
	},
	["3k_main_tutorial_progression_liu_bei_primary_dilemma_scripted_allied_cc"] = { -- Kill Cao Song
		function() cdir_events_manager:kill_startpos_character( "1258522052", false ); end,
		nil
	},
	["3k_main_tutorial_progression_liu_bei_secondary_incident_scripted"] = { -- Kill Tao Qian
		function()
			cdir_events_manager:kill_startpos_character( "2140784098", false ); 
		end,
		nil
	},
	["3k_main_char_historical_xiahou_dun_wounded_eats_eyeball_incident_scripted"] = {
		function() 
			local xiahou_dun = cm:query_model():character_for_template("3k_main_template_historical_xiahou_dun_hero_wood"):startpos_key()
			cdir_events_manager:add_or_remove_ceo_from_startpos_character( "333687161", "3k_main_ceo_career_historical_xiahou_dun", false );
			cdir_events_manager:add_or_remove_ceo_from_startpos_character( "333687161", "3k_main_ceo_career_historical_xiahou_dun_blinded", true );
		end,
		nil
	},
	["3k_main_faction_sun_give_the_seal_dilemma"] = {
		function() cdir_events_manager:add_or_remove_ceo_from_faction("3k_main_faction_yuan_shu", "3k_main_ancillary_accessory_imperial_jade_seal", true); end,
		0
	},
	["3k_dlc05_historical_yuan_shu_sun_ce_dilemma"] = { 
		function() cdir_events_manager:add_or_remove_ceo_from_faction("3k_dlc05_faction_sun_ce", "3k_main_ancillary_accessory_imperial_jade_seal", true); end,
		1
	},
	["3k_dlc05_historical_sun_ce_imperial_seal_dilemma"] = { 
		function() cdir_events_manager:add_or_remove_ceo_from_faction("3k_main_faction_yuan_shu", "3k_main_ancillary_accessory_imperial_jade_seal", true); end,
		0
	},
	["3k_dlc05_historical_sun_ce_yuan_shu_dilemma"] = { 
		function() cdir_events_manager:transfer_region_to_faction("3k_main_lujiang_capital", "3k_main_faction_yuan_shu"); end,
		0
	},
	["3k_dlc05_historical_yuan_shao_yuan_tan_dilemma"] = { 
		function() cdir_events_manager:transfer_region_to_faction("3k_main_taishan_capital", "3k_dlc05_faction_yuan_tan"); end,
		0
	},
	["3k_dlc05_char_historical_zhou_tai_scarred_incident"] = {
		function() 
			local zhou_tai = cm:query_model():character_for_template("3k_main_template_historical_zhou_tai_hero_fire"):startpos_key()
			cdir_events_manager:add_or_remove_ceo_from_startpos_character( zhou_tai, "3k_main_ceo_career_historical_zhou_tai", false );
			cdir_events_manager:add_or_remove_ceo_from_startpos_character( zhou_tai, "3k_dlc05_ceo_career_historical_zhou_tai_scarred", true );
		end,
		nil
	},
	["3k_dlc05_char_historical_cheng_pu_becomes_elder_cheng_incident"] = {
		function() 
			local cheng_pu = cm:query_model():character_for_template("3k_main_template_historical_cheng_pu_hero_metal"):startpos_key()
			cdir_events_manager:add_or_remove_ceo_from_startpos_character( cheng_pu, "3k_main_ceo_career_historical_cheng_pu", false );
			cdir_events_manager:add_or_remove_ceo_from_startpos_character( cheng_pu, "3k_dlc05_ceo_career_historical_cheng_pu_elder", true );
		end,
		nil
	},
	["3k_dlc05_historical_liu_biao_shi_huang_dilemma"] = {
		function() 
			cdir_events_manager:kill_faction_leader("3k_dlc05_faction_shi_huang")
		end,
		nil
	},
	["3k_dlc05_historical_liu_biao_zhu_fu_dilemma"] = {
		function() 
			cdir_events_manager:kill_faction_leader("3k_dlc05_faction_zhu_fu")
		end,
		nil
	},
	
	
	["3k_main_historical_cao_xu_shu_joins_01_01_incident"] = {
		function() 
			local xu_shu = cm:query_model():character_for_template("3k_main_template_historical_xu_shu_hero_water"):startpos_key()
			cdir_events_manager:add_or_remove_ceo_from_startpos_character( xu_shu, "3k_dlc05_ceo_career_historical_xu_shu_early", false );
			cdir_events_manager:add_or_remove_ceo_from_startpos_character( xu_shu, "3k_main_ceo_career_historical_xu_shu", true );
		end,
		nil
	},


	["3k_dlc05_historical_cao_cao_cheng_yu_dilemma"] = {
		function()
			diplomacy_manager:apply_automatic_deal_between_factions("3k_main_faction_yuan_shao", "3k_main_faction_cao_cao", "data_defined_situation_vassalise_recipient_forced", false);
		end,
		0
	},

	["3k_dlc07_dilemma_liu_yan_save_sons"] = {
		function()
			local liu_dan = cm:query_model():character_for_template("3k_dlc07_template_historical_liu_dan_hero_wood")
			local liu_fan = cm:query_model():character_for_template("3k_dlc07_template_historical_liu_fan_hero_earth")

			if not liu_dan:is_null_interface() and not liu_dan:is_dead() then
				cm:modify_character(liu_dan):move_to_faction_and_make_recruited("3k_main_faction_liu_yan")
			else
				cdir_events_manager:spawn_character_subtype_template_in_faction("3k_main_faction_liu_yan", "3k_general_wood", "3k_dlc07_template_historical_liu_dan_hero_wood");
			end

			if not liu_fan:is_null_interface() and not liu_fan:is_dead() then
				cm:modify_character(liu_fan):move_to_faction_and_make_recruited("3k_main_faction_liu_yan")
			else
				cdir_events_manager:spawn_character_subtype_template_in_faction("3k_main_faction_liu_yan", "3k_general_earth", "3k_dlc07_template_historical_liu_fan_hero_earth");
			end
		end,
		0
	},

	["3k_dlc07_incident_liu_yan_liu_mao_death"] = {
		function()
			local liu_mao = cm:query_model():character_for_template("3k_dlc07_template_historical_liu_mao_hero_water")
			
			if not liu_mao:is_null_interface() and not liu_mao:is_dead() then
				cm:modify_character(liu_mao):kill_character(false)
			end
		end,
		nil
	},

	["3k_dlc07_incident_liu_yan_death_of_sons_didnt_save_them"] = {
		function()
			local q_liu_dan = cm:query_model():character_for_template("3k_dlc07_template_historical_liu_fan_hero_earth")
			local q_liu_fan = cm:query_model():character_for_template("3k_dlc07_template_historical_liu_dan_hero_wood")

			if not q_liu_dan:is_null_interface() and not q_liu_dan:is_dead() and not q_liu_fan:is_null_interface() and not q_liu_fan:is_dead() then
				cm:modify_character(q_liu_dan):kill_character(false)
				cm:modify_character(q_liu_fan):kill_character(false)
			end
		end,
		nil
	},
}



--***********************************************************************************************************
--***********************************************************************************************************
-- LISTENERS
--***********************************************************************************************************
--***********************************************************************************************************


function cdir_events_manager:add_core_listeners()

	core:add_listener(
		"cdir_events_manager_battle_logged", -- Unique handle
		"CampaignBattleLoggedEvent", -- Campaign Event to listen for
		function(context) -- Criteria
			return true;
		end,
		function(context) -- What to do if listener fires.
			local log_entry = context:log_entry();

			for i = 0, log_entry:winning_factions():num_items() - 1 do
				local faction = log_entry:winning_factions():item_at(i);
				if faction:is_human() then
					self:player_battle_logged_events(faction, log_entry, true);
				end;
			end;

			for i = 0, log_entry:losing_factions():num_items() - 1 do
				local faction = log_entry:losing_factions():item_at(i);
				if faction:is_human() then
					self:player_battle_logged_events(faction, log_entry, false);
				end;
			end;
		end,
		true --Is persistent
	);

	core:add_listener(
		"cdir_events_manager_battle_completed", -- Unique handle
		"BattleCompleted", -- Campaign Event to listen for
		function(context) -- Criteria
			local pb = context:query_model():pending_battle();
			
            return pb:has_been_fought() and (pb:has_attacker() or pb:has_defender());
		end,
		function(context) -- What to do if listener fires.
			local pb = context:query_model():pending_battle();
			local attacker_won = pending_battle_attacker_victory(pb);

			-- Attacker events


			-- Defender events

			local attacker = nil;
			local defender = nil;
			local player_was_attacker = false;
			local player_was_defender = false;

			if pb:has_attacker() then
				attacker = pb:attacker();
				player_was_attacker = player_attacker_in_battle(pb)
			end;

			if pb:has_defender() then
				defender = pb:defender();
				player_was_defender = player_defender_in_battle(pb)
			end;

			-- Fire events for attacking players.
			if player_involved_in_battle(pb) then

				-- Check both players since we can have them both involved in the same battle.
				if player_was_attacker and attacker and not attacker:is_null_interface() then
					self:player_battle_completed_events(pb, attacker:faction(), true, attacker_won)
				end;

				if player_was_defender and defender and not defender:is_null_interface()  then
					self:player_battle_completed_events(pb, defender:faction(), false, not attacker_won)
				end;

			elseif pb:has_attacker() and pb:has_defender() then
				self:ai_only_battle_events(pb, attacker, defender);
			end
		end,
		true --Is persistent
	);

	-- Player spy completed action targeting their source faction.
    core:add_listener(
        "cdir_events_manager_undercover_character_source_faction_action", -- UID
        "UndercoverCharacterSourceFactionActionCompleteEvent", -- Campaign event
        function(context)
            return context:source_faction():is_human();
        end,
        function(context)
            local query_faction = context:source_faction()
			self:player_undercover_action_completed_events( query_faction, context:action_key() );   
        end,
        true
    );

    -- Player spy completed action targeting a character.
    core:add_listener(
        "cdir_events_manager_undercover_character_character_action", -- UID
        "UndercoverCharacterTargetCharacterActionCompleteEvent", -- Campaign event
        function(context)
            return context:source_faction():is_human();
        end,
        function(context)
            local query_faction = context:source_faction()
            self:player_undercover_action_completed_events( query_faction, context:agent_action_key() );      
        end,
        true
    );

    -- Player spy completed action targeting their target faction.
    core:add_listener(
        "cdir_events_manager_undercover_character_target_faction_action", -- UID
        "UndercoverCharacterTargetFactionActionCompleteEvent", -- Campaign event
        function(context)
            return context:source_faction():is_human();
        end,
        function(context)
            local query_faction = context:source_faction()
            self:player_undercover_action_completed_events( query_faction, context:agent_action_key() );    
        end,
        true
    );

    -- Player spy completed action targeting a garrison.
    core:add_listener(
        "cdir_events_manager_character_garrison_action", -- UID
        "UndercoverCharacterTargetGarrisonActionCompleteEvent", -- Campaign event
        function(context)
            return context:source_faction():is_human();
        end,
        function(context)
            local query_faction = context:source_faction()
            self:player_undercover_action_completed_events( query_faction, context:agent_action_key() );    
        end,
        true
	);
	
	core:add_listener(
        "cdir_events_manager_character_died", -- UID
        "CharacterDied", -- Campaign event
		function(context)
			return context:query_character():faction():is_human() and context:was_recruited_in_faction();
		end,
        function(context)
            local query_faction = context:query_character():faction()
            self:player_character_dies_events( query_faction, context:query_character() );
        end,
        true
	);
	
	core:add_listener(
        "cdir_events_manager_character_comes_of_age", -- UID
        "CharacterComesOfAge", -- Campaign event
		function(context)
			return context:query_character():faction():is_human();
		end,
        function(context)
			local query_faction = context:query_character():faction();
			self:player_character_comes_of_age_events( query_faction, context:query_character() );
        end,
        true
	);

	core:add_listener(
		"cdir_events_manager_new_faction_leader", -- Unique handle
		"CharacterBecomesFactionLeader", -- Campaign Event to listen for
		function(context)
			return context:query_character():faction():is_human();
		end,
		function(context) -- What to do if listener fires.
			local query_faction = context:query_character():faction()
			self:player_character_becomes_faction_leader_events( query_faction, context:query_character() );
		end,
		true --Is persistent
	);

	-- PLAYER CAPTURES SETTLEMENT -- Store if the character captured a settlement, to use in BattleCompleted
    core:add_listener(
        "cdir_events_manager_player_captures_settlement", -- UID
        "GarrisonOccupiedEvent", -- Campaign event
        function(context)
            return context:query_character() and context:query_character():faction():is_human(); -- Only fire for humans occupying.
        end,
        function(context)
            self:player_captures_settlement_events( context:query_character():faction() );
        end,
        true
    );

    -- PLAYER SETTLEMENT CAPTURED -- Store if the character captured a settlement, to use in BattleCompleted
    core:add_listener(
        "cdir_events_manager_player_settlement_captured", -- UID
        "GarrisonOccupiedEvent", -- Campaign event
        function(context)
            return context:garrison_residence() and context:garrison_residence():faction():is_human(); -- Only fire occupied humans
        end,
        function(context)
            self:player_settlement_captured_events( context:garrison_residence():faction() );
        end,
        true
	);

	-- Captive option applied.
	core:add_listener(
		"cdir_events_manager_captive_option_applied", -- UID
		"CharacterCaptiveOptionApplied", -- campaign event
		function(context)
			return true;
		end,
		function(context)
			if context:captive_option_outcome() == "RELEASE" then
				self:captive_option_release_events(context);
			end;
		end,
		true
	);

	-- Research completed.
	core:add_listener(
		"cdir_events_manager_research_completed",
		"ResearchCompleted",
		true,
		function(context)
			self:research_completed_events(context);
		end,
		true
	)
	
end;


--***********************************************************************************************************
--***********************************************************************************************************
-- EVENT LISTS
--***********************************************************************************************************
--***********************************************************************************************************



function cdir_events_manager:ai_only_battle_events(pb, attacker, defender)

	local humans = cm:get_human_factions();

	if #humans > 0 then
		local query_faction = cm:query_faction( humans[1] );

		if not query_faction or query_faction:is_null_interface() then
			script_error("ai_only_battle_events(): Query faction is null");
			return;
		end;

		-- Sun Jian Faction
		if faction_involved_in_battle(pb, "3k_main_faction_sun_jian") 
		and ( faction_involved_in_battle(pb, "3k_main_faction_liu_biao") or faction_involved_in_battle(pb, "3k_main_faction_huang_zu") ) then
			self:add_prioritised_incidents( query_faction:command_queue_index(), "3k_main_historical_sun_jian_dies_npc_incident_scripted" );
		end;
	end;
end;


function cdir_events_manager:player_battle_logged_events(triggering_faction, log_entry, won_battle)

	for i = 0, log_entry:winning_characters():num_items() - 1 do
		local character = log_entry:winning_characters():item_at(i):character();

		if character and not character:is_null_interface() then
			if character:generation_template_key() == "3k_main_template_historical_xiahou_dun_hero_wood" then
				self:add_important_incidents( triggering_faction:command_queue_index(), "3k_main_char_historical_xiahou_dun_wounded_eats_eyeball_incident_scripted" );
			end;
		end;
	end;

	for i = 0, log_entry:losing_characters():num_items() - 1 do
		local character = log_entry:losing_characters():item_at(i):character();

		if character and not character:is_null_interface() then
			if character:generation_template_key() == "3k_main_template_historical_xiahou_dun_hero_wood" then
				self:add_important_incidents( triggering_faction:command_queue_index(), "3k_main_char_historical_xiahou_dun_wounded_eats_eyeball_incident_scripted" );
			end;
		end;
	end;

	if self:character_won_duel(log_entry, "3k_main_template_historical_guan_yu_hero_wood") then
		self:add_standard_incidents( triggering_faction:command_queue_index(), "3k_main_char_historical_guan_yu_fights_hua_xiong_incident_scripted" );
	end;

	-- Meng Huo and Zhurong fought together in battle.
	if log_entry:winning_characters():count_if(function(log_character) 
		return log_character:character():generation_template_key() == "3k_dlc06_template_historical_king_meng_huo_hero_nanman" 
		or log_character:character():generation_template_key() == "3k_dlc06_template_historical_lady_zhurong_hero_nanman" end) == 2 then

		self:add_prioritised_incidents( triggering_faction:command_queue_index(), "3k_dlc06_faction_meng_huo_zhurong_fight_together_incident" );
	end;

	-- Meng Huo and Lu Bu fight in battle.
	if log_entry:winning_characters():count_if(function(log_character) 
		return log_character:character():generation_template_key() == "3k_dlc06_template_historical_king_meng_huo_hero_nanman" 
		or log_character:character():generation_template_key() == "3k_main_template_historical_lu_bu_hero_fire" end)
		+
		log_entry:losing_characters():count_if(function(log_character) 
			return log_character:character():generation_template_key() == "3k_dlc06_template_historical_king_meng_huo_hero_nanman" 
			or log_character:character():generation_template_key() == "3k_main_template_historical_lu_bu_hero_fire" end) 
		== 2 then

		self:add_prioritised_incidents(triggering_faction:command_queue_index(), "3k_dlc06_faction_meng_huo_fights_lu_bu_incident")
	end;

	-- Victory with Lady Zhurong
	if log_entry:winning_characters():any_of(function(log_character) 
		return log_character:character():generation_template_key() == "3k_dlc06_template_historical_lady_zhurong_hero_nanman" and log_character:character():faction():is_human() end) then

		self:add_prioritised_incidents(triggering_faction:command_queue_index(), "3k_dlc06_char_deeds_lady_zhurong_throwing_knife") --Character owned version
		self:add_prioritised_incidents(triggering_faction:command_queue_index(), "3k_dlc06_faction_lady_zhurong_throwing_knife") --Faction leader version
	end
end;

function cdir_events_manager:player_battle_completed_events(pb, triggering_faction, was_attacker, won_battle )

	local cqi = triggering_faction:command_queue_index();
	local pct_attacker_killed = pb:percentage_of_attacker_killed();
	local pct_defender_killed = pb:percentage_of_defender_killed();
	
	self:add_standard_dilemmas( cqi,
		{
			"3k_main_faction_zheng_the_scholar_dilemma_scripted",
			"3k_main_faction_zheng_the_warrior_dilemma_scripted"
		}
	);

	self:add_standard_incidents( cqi,
		{
			"3k_main_char_historical_zhou_yu_keen_ear_incident_scripted",
			"3k_main_char_heroism_win_battle_kill_troops_incident",
			"3k_main_char_heroism_win_battle_save_troops_incident",
			"3k_main_char_heroism_win_battle_wound_char_incident",
			"3k_main_char_historical_xu_chu_fights_naked_incident_scripted",
		}
	);

	self:add_important_incidents( cqi, 
		{
			"3k_main_historical_liu_zhao_yun_joins_pc_incident_post_battle"
		}
	);
	
    -- Winner killed > 80% of the enemy troops.
    if won_battle and (was_attacker and pct_defender_killed > 80) or (not was_attacker and pct_attacker_killed > 80) then
		self:add_standard_dilemmas( cqi,"3k_main_ancillary_hex_mark_dilemma_scripted" );
    end;

    -- Cao Cao Events
    if triggering_faction:name() == "3k_main_faction_cao_cao" and faction_involved_in_battle(pb, "3k_main_faction_liu_bei") then
        -- Defeated liu bei and captured God of War.
		self:add_standard_dilemmas( cqi,"3k_main_historical_cao_god_of_war_pc_01_dilemma_scripted" );
    end;

    -- Sun Jian
    if triggering_faction:name() == "3k_main_faction_sun_jian" then
        -- Battle happened in Xiangyang
		if faction_involved_in_battle(pb, "3k_main_faction_liu_biao") or faction_involved_in_battle(pb, "3k_main_faction_huang_zu") then
			self:add_important_dilemmas( cqi,"3k_main_historical_sun_jian_dies_pc_dilemma_scripted" );
        end;
	end;
	
	-- Nanman glorious dead event.
	if pb:percentage_of_attacker_killed() + pb:percentage_of_defender_killed() >= 150 then
		-- Victory with high casualties.
		self:add_standard_incidents(triggering_faction:command_queue_index(), "3k_dlc06_ambient_nanman_hail_the_glorious_dead_incident");
	end;
end;



function cdir_events_manager:player_captures_settlement_events(triggering_faction)

	local cqi = triggering_faction:command_queue_index();

	self:add_standard_dilemmas( cqi,
		{
			"3k_main_faction_zheng_captured_magistrate_dilemma_scripted",
			"3k_main_faction_zheng_the_scholar_dilemma_scripted",
			"3k_main_faction_zheng_the_warrior_dilemma_scripted",
			"3k_main_siege_post_assassin_pc_dilemma_scripted",
			"3k_main_siege_post_colonise_forced_migration_dilemma_scripted",
			"3k_main_siege_post_colonise_ghosts_pc_dilemma_scripted",
			"3k_main_siege_post_captured_garrison_att_pc_dilemma_scripted",
			"3k_main_siege_post_colonise_terrible_collapse_dilemma_scripted"
		}
	);

	self:add_standard_incidents( cqi,
		{
			"3k_main_siege_post_discover_item_pc_incident",
			"3k_main_siege_post_discover_item_npc_incident",
			"3k_main_siege_post_discover_gold_pc_incident",
			"3k_main_siege_post_discover_gold_npc_incident",
			"3k_main_siege_post_assassin_npc_good_incident",
			"3k_main_siege_post_assassin_npc_bad_incident"
		}
	);

	self:add_important_incidents( cqi, "3k_main_char_historical_xu_chu_spawns_incident_scripted" );

end;



function cdir_events_manager:player_settlement_captured_events(triggering_faction)

	local cqi = triggering_faction:command_queue_index();

	self:add_standard_dilemmas( cqi,
		{
			"3k_main_faction_zheng_captured_magistrate_dilemma_scripted",
			"3k_main_faction_zheng_the_scholar_dilemma_scripted",
			"3k_main_faction_zheng_the_warrior_dilemma_scripted"
		}
	);

	self:add_standard_incidents( cqi,
		{
			"3k_main_char_historical_zhou_yun_save_baby_incident"
		}
	);

	self:add_important_incidents( cqi, "3k_main_char_historical_xu_chu_spawns_incident_scripted" );

end;

function cdir_events_manager:player_character_comes_of_age_events(triggering_faction, query_character)

end;

function cdir_events_manager:player_character_dies_events(triggering_faction, query_character)
	
	local cqi = triggering_faction:command_queue_index();

	-- Zhuge liang died!
	if query_character:generation_template_key() == "3k_main_template_historical_zhuge_liang_hero_water" then
		self:add_standard_incidents( cqi, "3k_main_char_historical_zhuge_liang_dies_but_wins_incident");
	end;

	-- If Xun You is in the faction, try to fire his incident
	if triggering_faction:character_list():any_of(function(log_character) 
		return log_character:generation_template_key() == "3k_main_template_historical_xun_you_hero_water" and log_character:faction():is_human() end) then		
			self:add_prioritised_incidents( cqi, "3k_dlc06_char_deeds_xun_you_tomb_keeper_incident");
	end

end;

function cdir_events_manager:player_character_becomes_faction_leader_events(triggering_faction, query_character)
	
end;

function cdir_events_manager:player_undercover_action_completed_events(triggering_faction, action_key)

	local cqi = triggering_faction:command_queue_index();

	if action_key == "undercover_character_target_character_bribe_soldiers" then 

		self:add_dilemma_key( cqi, "3k_main_spy_bribe_soldiers_more_money_dilemma");

	elseif action_key == "undercover_character_target_character_exhaust_force" then 

		self:add_standard_incidents( cqi, "3k_main_spy_misdirection_hermits_hut_incident");

	elseif action_key == "undercover_character_target_character_hinder_replenishment" then 

		self:add_standard_incidents( cqi, 
			{
				"3k_main_spy_hinder_replenishment_sold_supplies_incident",
				"3k_main_spy_hinder_replenishment_black_market_incident"
			}
		);

	elseif action_key == "undercover_character_target_character_supply_units" then 

		self:add_standard_incidents( cqi, "3k_main_spy_supply_units_left_over_funds_incident");

	elseif action_key == "undercover_character_target_faction_build_spy_network" then 

		self:add_standard_incidents( cqi, "3k_main_spy_spy_network_new_spy_incident");

	end;
end;


function cdir_events_manager:captive_option_release_events(context)

	-- Meng Huo was captured.
	if context:query_character():generation_template_key() == "3k_dlc06_template_historical_king_meng_huo_hero_nanman" then
		-- Add events for his captor.
		local captor_faction_key = context:capturing_force():faction():name();
		local captor_cqi = context:capturing_force():faction():command_queue_index();

		-- NAN-2967 Fixing these in one go caused a domino effect of them all firing consecutively. Now spacing out so they cannot all fire at once.
		if cm:has_incident_fired_for_faction(captor_faction_key, "3k_dlc06_faction_meng_huo_captured_king_06_npc_incident") then
			self:add_prioritised_incidents(captor_cqi, "3k_dlc06_faction_meng_huo_captured_king_07_npc_incident");
		elseif cm:has_incident_fired_for_faction(captor_faction_key, "3k_dlc06_faction_meng_huo_captured_king_05_npc_incident") then
			self:add_prioritised_incidents(captor_cqi, "3k_dlc06_faction_meng_huo_captured_king_06_npc_incident");
		elseif cm:has_incident_fired_for_faction(captor_faction_key, "3k_dlc06_faction_meng_huo_captured_king_04_npc_incident") then
			self:add_prioritised_incidents(captor_cqi, "3k_dlc06_faction_meng_huo_captured_king_05_npc_incident");
		elseif cm:has_incident_fired_for_faction(captor_faction_key, "3k_dlc06_faction_meng_huo_captured_king_03_npc_incident") then
			self:add_prioritised_incidents(captor_cqi, "3k_dlc06_faction_meng_huo_captured_king_04_npc_incident");
		elseif cm:has_incident_fired_for_faction(captor_faction_key, "3k_dlc06_faction_meng_huo_captured_king_02_npc_incident") then
			self:add_prioritised_incidents(captor_cqi, "3k_dlc06_faction_meng_huo_captured_king_03_npc_incident");
		elseif cm:has_incident_fired_for_faction(captor_faction_key, "3k_dlc06_faction_meng_huo_captured_king_01_npc_incident") then
			self:add_prioritised_incidents(captor_cqi, "3k_dlc06_faction_meng_huo_captured_king_02_npc_incident");
		else
			self:add_prioritised_incidents(captor_cqi, "3k_dlc06_faction_meng_huo_captured_king_01_npc_incident");
		end;

		-- Add event for him
		self:add_prioritised_incidents(context:query_character():faction():command_queue_index(), "3k_dlc06_faction_meng_huo_captured_king_01_incident");
	end;

	-- When Wei Yan captures an Nanman belonging to the nanman subculture, fire his event.
	if not context:query_character():faction():is_null_interface() and context:query_character():faction():subculture()=="3k_dlc06_subculture_nanman" then
		if not context:capturing_force():is_null_interface() then
			local character_list = context:capturing_force():character_list()
			for i = 0,character_list:num_items()-1 do
				local character = character_list:item_at(i)
				if not character:is_null_interface() then
					if character:generation_template_key()=="3k_main_template_historical_wei_yan_hero_wood" then
						cm:trigger_incident(character:faction():name(),"3k_dlc06_char_deeds_wei_yan_capture_nanman",true,true)
						break;
					end
				end
			end
		end
	end
end;


function cdir_events_manager:research_completed_events(context)

	-- Nanman tech research events.
	self:add_standard_incidents(
		context:faction():command_queue_index(), 
		{
			"3k_dlc06_ambient_nanman_path_you_walk_negative_incident",
			"3k_dlc06_ambient_nanman_path_you_walk_positive_incident",
			"3k_dlc06_ambient_nanman_path_you_walk_dilemma"
		}
	);
end;


--***********************************************************************************************************
--***********************************************************************************************************
-- HELPER FUNCTIONS
--***********************************************************************************************************
--***********************************************************************************************************


function cdir_events_manager:trigger_civil_war_in_faction(faction_key, priority_characters) 
	local civil_war_chars = {};
	local query_faction = cm:query_faction(faction_key);

	if not query_faction then
		script_error("Passed in faction is nil " .. faction_key);
	end;

	if query_faction:is_null_interface() then
		script_error("Passed in faction is nil " .. faction_key);
	end;

	for i=0, query_faction:character_list():num_items() - 1 do
		local qCharacter = query_faction:character_list():item_at(i);

		for j = 1, #priority_characters do
			if qCharacter:generation_template_key() == priority_characters[j] then
				table.insert( civil_war_chars, qCharacter );
			end;
		end;
	end;

	if #civil_war_chars == 0 then
		for i=0, query_faction:character_list():num_items() - 1 do
			local qCharacter = query_faction:character_list():item_at(i);

			if qCharacter and not qCharacter:is_null_interface() and qCharacter:character_post() then
				if qCharacter:character_type("general") and qCharacter:character_post() ~= "faction_leader" then
					if #civil_war_chars < 1 then -- Always add the first character we find
						table.insert( civil_war_chars, qCharacter );
					elseif #civil_war_chars > 3 then -- If we add more chanthan this, then we're good.
						break;
					elseif cm:roll_random_chance(30) then -- For others do a random roll on them being added.
						table.insert( civil_war_chars, qCharacter );
					end;
				end;
			end;
		end;
	end;
	
	if #civil_war_chars == 0 then
		script_error("trigger_civil_war_in_faction - No characters found!");
		return false;
	end;

	if #civil_war_chars > 1 then -- For all our civil war chars greater than 1 make them disloyal.
		for i=2, #civil_war_chars do
			local mCharacter = cm:modify_character( civil_war_chars[i] );
			mCharacter:add_loyalty_effect("civil_war_event");
		end;
	end;

	-- Exit if faction is in civil war already
	if query_faction:is_at_civil_war() then 
		return true; 
	end;

	local modify_faction = cm:modify_faction(query_faction);
	cm:modify_model():force_civil_war(civil_war_chars[1]);
	out.events("cdir_events_manager:trigger_civil_war_in_faction() forcing civil war for faction " .. faction_key);
end;


function cdir_events_manager:spawn_character_subtype_template_in_faction(faction_key, subtype_key, template_key)
	local query_faction = cm:query_faction(faction_key);

	if not query_faction then
		script_error("Passed in faction is nil " .. faction_key);
	end;

	if query_faction:is_null_interface() then
		script_error("Passed in faction is nil " .. faction_key);
	end;

	local modify_faction = cm:modify_faction(query_faction);

	local modify_character = modify_faction:create_character_from_template("general", subtype_key, template_key, false);

	
	if not modify_character or modify_character:is_null_interface() then
		script_error("cdir_events_manager:spawn_character_subtype_template_in_faction(): Character did not spawn!. template: " .. tostring(template_key) .. " faction: " .. tostring(faction_key));
	else
		local char_cqi =  modify_character:query_character():command_queue_index();
		out.events("cdir_events_manager:spawn_character_subtype_template_in_faction() Spawned cqi [" .. tostring(char_cqi) .. "] - template " .. tostring(template_key) .. " to faction " .. tostring(faction_key));
	end;
end;

function cdir_events_manager:kill_startpos_character(character_startpos_id, destroy_force)
	
	if not character_startpos_id or not is_string(character_startpos_id) then
		script_error("cdir_events_manager:kill_startpos_character(): char_startpos_id is either nil or not a string.");
		return false;
	end;

	local query_model = cm:query_model();
	local query_character = query_model:character_for_startpos_id( tostring(character_startpos_id) );

	if query_character == nil or query_character:is_null_interface() then
		script_error("cdir_events_manager:kill_startpos_character(): No character with id " .. character_startpos_id .. " found to kill.");
		return false;
	end;

	if query_character:is_dead() then
		script_error("cdir_events_manager:kill_startpos_character(): The selected character is allready dead.");
		return false;
	end;

	local modify_character = cm:modify_character( query_character );

	modify_character:kill_character( destroy_force );

	out.events("cdir_events_manager:kill_startpos_character() Killing character with template: " .. query_character:generation_template_key());
end;


function cdir_events_manager:add_or_remove_ceo_from_startpos_character(character_startpos_id, ceo_key, should_add)
	
	if not character_startpos_id or not is_string(character_startpos_id) then
		script_error("cdir_events_manager:add_or_remove_ceo_from_startpos_character(): char_startpos_id is either nil or not a string.");
		return false;
	end;

	if not ceo_key or not is_string( ceo_key ) then
		script_error("cdir_events_manager:add_or_remove_ceo_from_startpos_character(): ceo_key is either nil or not a string.");
		return false;
	end;

	local query_model = cm:query_model();
	local query_character = query_model:character_for_startpos_id( tostring(character_startpos_id) );

	if query_character == nil or query_character:is_null_interface() then
		script_error("cdir_events_manager:add_or_remove_ceo_from_startpos_character(): No character with id " .. character_startpos_id .. " found.");
		return false;
	end;

	if query_character:is_dead() then
		script_error("cdir_events_manager:add_or_remove_ceo_from_startpos_character(): The selected character is dead.");
		return false;
	end;

	local modify_character = cm:modify_character( query_character );

	if should_add then
		modify_character:ceo_management():add_ceo(ceo_key);
		out.events("cdir_events_manager:add_or_remove_ceo_from_startpos_character() Adding CEO:" .. ceo_key .. " to " .. query_character:generation_template_key());
	else
		modify_character:ceo_management():remove_ceos(ceo_key);
		out.events("cdir_events_manager:add_or_remove_ceo_from_startpos_character() Removing CEO: " .. ceo_key .. " to " .. query_character:generation_template_key());
	end;
end;


function cdir_events_manager:add_or_remove_ceo_from_faction( faction_key, ceo_key, should_add )

	if not faction_key or not is_string( faction_key ) then
		script_error("cdir_events_manager:add_or_remove_ceo_from_faction(): faction_key is either nil or not a string.");
		return false;
	end;

	if not ceo_key or not is_string( ceo_key ) then
		script_error("cdir_events_manager:add_or_remove_ceo_from_faction(): ceo_key is either nil or not a string.");
		return false;
	end;

	local modify_faction = cm:modify_faction( faction_key );

	if not modify_faction or modify_faction:is_null_interface() or modify_faction:query_faction():is_dead() then
		script_error( "cdir_events_manager:add_or_remove_ceo_from_faction(): Faction does not exist or is dead. " .. tostring(faction_key) );
		return false;
	end;

	if should_add then
		modify_faction:ceo_management():add_ceo( ceo_key );
	else
		modify_faction:ceo_management():remove_ceos( ceo_key );
	end;
end;

function cdir_events_manager:character_was_involved_in_duel(campaign_battle_log, template_key)

	if campaign_battle_log or campaign_battle_log:is_null_interface() then
		return false;
	end;

	local duels = campaign_battle_log:duels();

	for i=0, duels:num_items() - 1 do
		local duel = duels:item_at(i);

		if duel:proposer():generation_template_key() == template_key then
			return true;
		elseif duel:target():generation_template_key() == template_key then
			return true;
		end;
	end;

	return false;
end;

function cdir_events_manager:character_won_duel(campaign_battle_log, template_key)

	if campaign_battle_log or campaign_battle_log:is_null_interface() then
		return false;
	end;

	local duels = campaign_battle_log:duels();

	for i=0, duels:num_items() - 1 do
		local duel = duels:item_at(i);

		if duel:has_winner() then
			if duel:winner():generation_template_key() == template_key then
				return true;
			end;
		end;
	end;

	return false;
end;


function cdir_events_manager:transfer_region_to_faction(region_key, faction_key)
	local region_script_interface = cm:query_model():world():region_manager():region_by_key(region_key)
	local faction_script_interface = cm:modify_faction(faction_key)
	cm:modify_model():get_modify_region(region_script_interface):settlement_gifted_as_if_by_payload(faction_script_interface)
end

function cdir_events_manager:kill_faction_leader(faction_key)
	local character_to_kill = cm:modify_faction(faction_key):query_faction():faction_leader()
	cm:modify_character(character_to_kill):kill_character(false)
end
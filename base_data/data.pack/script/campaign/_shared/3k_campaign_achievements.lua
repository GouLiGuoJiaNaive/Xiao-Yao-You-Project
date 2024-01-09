---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------
----- Name:			3k_campaign_achievements.lua
----- Description: 	Helper script for granting achievements
---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------

output("3k_campaign_achievements.lua: Loading");

cm:add_first_tick_callback(function() achievements:initialise() end); --Self register function

achievements = {};

function achievements:initialise()
	--First check if existing factions has completed their achivements or in the progress of doing so
	self:check_if_player_has_completed_achivements()
	--Add normal listners
	self:add_listeners();
end;

--DLC05 - SUN CE ACHIVEMENT SETS
achievements.template_to_ceo = {
	["3k_dlc05_ceo_sun_ce_ambition_achieve_artery_of_the_world"]="3k_dlc05_item_set_sun_ce_ambition_the_southern_threat",
	["3k_dlc05_ceo_sun_ce_ambition_achieve_independence"]="3k_dlc05_item_set_sun_ce_ambition_the_southern_threat",
	["3k_dlc05_ceo_sun_ce_ambition_achieve_new_centrum"]="3k_dlc05_item_set_sun_ce_ambition_the_southern_threat",
	["3k_dlc05_ceo_sun_ce_ambition_achieve_wolf_cub_roars"]="3k_dlc05_item_set_sun_ce_ambition_the_southern_threat",
	["3k_dlc05_ceo_sun_ce_ambition_secure_jianye_capital"]="3k_dlc05_item_set_sun_ce_ambition_secure_wu",
	["3k_dlc05_ceo_sun_ce_ambition_secure_jianye_copper_mine"]="3k_dlc05_item_set_sun_ce_ambition_secure_wu",
	["3k_dlc05_ceo_sun_ce_ambition_secure_jianye_salt_mine"]="3k_dlc05_item_set_sun_ce_ambition_secure_wu",
	["3k_dlc05_ceo_sun_ce_ambition_secure_poyang_capital"]="3k_dlc05_item_set_sun_ce_ambition_secure_the_middle_yangtze",
	["3k_dlc05_ceo_sun_ce_ambition_secure_poyang_copper_mine"]="3k_dlc05_item_set_sun_ce_ambition_secure_the_middle_yangtze",
	["3k_dlc05_ceo_sun_ce_ambition_secure_poyang_iron_mine"]="3k_dlc05_item_set_sun_ce_ambition_secure_the_middle_yangtze",	
	["3k_dlc05_ceo_sun_ce_ambition_secure_poyang_weapon_craftsmen"]="3k_dlc05_item_set_sun_ce_ambition_secure_the_middle_yangtze",			
	["3k_dlc05_ceo_sun_ce_ambition_secure_changsha_capital"]="3k_dlc05_item_set_sun_ce_ambition_secure_the_homestead",
	["3k_dlc05_ceo_sun_ce_ambition_secure_changsha_armour_craftsmen"]="3k_dlc05_item_set_sun_ce_ambition_secure_the_homestead",
	["3k_dlc05_ceo_sun_ce_ambition_secure_changsha_teahouse"]="3k_dlc05_item_set_sun_ce_ambition_secure_the_homestead",	
	["3k_dlc05_ceo_sun_ce_ambition_secure_changsha_trade_port"]="3k_dlc05_item_set_sun_ce_ambition_secure_the_homestead",			
	["3k_dlc05_ceo_sun_ce_ambition_secure_xindu_capital"]="3k_dlc05_item_set_sun_ce_ambition_secure_the_heartland",
	["3k_dlc05_ceo_sun_ce_ambition_secure_xindu_fishing_port"]="3k_dlc05_item_set_sun_ce_ambition_secure_the_heartland",
	["3k_dlc05_ceo_sun_ce_ambition_secure_xindu_lumber_yard"]="3k_dlc05_item_set_sun_ce_ambition_secure_the_heartland",				
	["3k_dlc05_ceo_sun_ce_ambition_secure_kuaiji_capital"]="3k_dlc05_item_set_sun_ce_ambition_secure_kuaiji",
	["3k_dlc05_ceo_sun_ce_ambition_secure_kuaiji_livestock"]="3k_dlc05_item_set_sun_ce_ambition_secure_kuaiji",
	["3k_dlc05_ceo_sun_ce_ambition_secure_kuaiji_rice_paddy"]="3k_dlc05_item_set_sun_ce_ambition_secure_kuaiji",			
	["3k_dlc05_ceo_sun_ce_ambition_recruit_young_earth_wood"]="3k_dlc05_item_set_sun_ce_ambition_recruit_young_guard",
	["3k_dlc05_ceo_sun_ce_ambition_recruit_young_metal_fire"]="3k_dlc05_item_set_sun_ce_ambition_recruit_young_guard",
	["3k_dlc05_ceo_sun_ce_ambition_recruit_young_water"]="3k_dlc05_item_set_sun_ce_ambition_recruit_young_guard",			
	["3k_dlc05_ceo_sun_ce_ambition_recruit_old_fire"]="3k_dlc05_item_set_sun_ce_ambition_recruit_old_guard",
	["3k_dlc05_ceo_sun_ce_ambition_recruit_old_metal"]="3k_dlc05_item_set_sun_ce_ambition_recruit_old_guard",			
	["3k_dlc05_ceo_sun_ce_ambition_recruit_high_level_sun_ce"]="3k_dlc05_item_set_sun_ce_ambition_recruit_legacy_of_sun_ce",
	["3k_dlc05_ceo_sun_ce_ambition_recruit_high_level_zhou_yu"]="3k_dlc05_item_set_sun_ce_ambition_recruit_legacy_of_sun_ce",
	["3k_dlc05_ceo_sun_ce_ambition_recruit_high_level_sun_quan"]="3k_dlc05_item_set_sun_ce_ambition_recruit_legacy_of_sun_ce",	
	["3k_dlc05_ceo_sun_ce_ambition_recruit_high_level_lady_sun"]="3k_dlc05_item_set_sun_ce_ambition_recruit_legacy_of_sun_ce",				
	["3k_dlc05_ceo_sun_ce_ambition_recruit_grandmasters_earth"]="3k_dlc05_item_set_sun_ce_ambition_recruit_grandmasters",
	["3k_dlc05_ceo_sun_ce_ambition_recruit_grandmasters_fire"]="3k_dlc05_item_set_sun_ce_ambition_recruit_grandmasters",
	["3k_dlc05_ceo_sun_ce_ambition_recruit_grandmasters_metal"]="3k_dlc05_item_set_sun_ce_ambition_recruit_grandmasters",	
	["3k_dlc05_ceo_sun_ce_ambition_recruit_grandmasters_water"]="3k_dlc05_item_set_sun_ce_ambition_recruit_grandmasters",	
	["3k_dlc05_ceo_sun_ce_ambition_recruit_grandmasters_wood"]="3k_dlc05_item_set_sun_ce_ambition_recruit_grandmasters",				
	["3k_dlc05_ceo_sun_ce_ambition_recruit_official_earth"]="3k_dlc05_item_set_sun_ce_ambition_recruit_governors_and_scholars",	
	["3k_dlc05_ceo_sun_ce_ambition_recruit_official_water"]="3k_dlc05_item_set_sun_ce_ambition_recruit_governors_and_scholars",
	["3k_dlc05_ceo_sun_ce_ambition_recruit_female_earth_wood"]="3k_dlc05_item_set_sun_ce_ambition_recruit_four_warriors_of_china",	
	["3k_dlc05_ceo_sun_ce_ambition_recruit_female_metal_fire"]="3k_dlc05_item_set_sun_ce_ambition_recruit_four_warriors_of_china",
	["3k_dlc05_ceo_sun_ce_ambition_secure_jiangling_capital"]="3k_dlc05_item_set_sun_ce_ambition_fulfil_zhou_yu_ambition",	
	["3k_dlc05_ceo_sun_ce_ambition_secure_jiangling_livestock"]="3k_dlc05_item_set_sun_ce_ambition_fulfil_zhou_yu_ambition",	
	["3k_dlc05_ceo_sun_ce_ambition_secure_xiangyang_capital"]="3k_dlc05_item_set_sun_ce_ambition_fulfil_zhou_yu_ambition",	
	["3k_dlc05_ceo_sun_ce_ambition_secure_xiangyang_toolmaker"]="3k_dlc05_item_set_sun_ce_ambition_fulfil_zhou_yu_ambition",
	["3k_dlc05_ceo_sun_ce_ambition_achieve_sun_familiy_rises_again"]="3k_dlc05_item_set_sun_ce_ambition_achieve_the_little_conqueror",
	["3k_dlc05_ceo_sun_ce_ambition_achieve_tiny_conqueror"]="3k_dlc05_item_set_sun_ce_ambition_achieve_the_little_conqueror",
	["3k_dlc05_ceo_sun_ce_ambition_achieve_unbeatable"]="3k_dlc05_item_set_sun_ce_ambition_achieve_the_little_conqueror",
	["3k_dlc05_ceo_sun_ce_ambition_achieve_defeat_huang_zu"]="3k_dlc05_item_set_sun_ce_ambition_achieve_bandits_and_murders",
	["3k_dlc05_ceo_sun_ce_ambition_achieve_defeat_the_white_tiger"]="3k_dlc05_item_set_sun_ce_ambition_achieve_bandits_and_murders"			
}

function achievements:award(achievement_key)
	if not is_string(achievement_key) then
		script_error("ERROR: Passed in achievement key is not a string: " .. tostring(achievement_key));
		return;
	end;
	print("Awarding Achievement: "..achievement_key)
	--self:print("Awarding Achievement:" .. achievement_key);
	cm:modify_scripting():award_achievement(achievement_key);
end;

function achievements:print(text)
	out.random_army("[124] 3K Achievements: " .. tostring(text));
end;

function achievements:check_if_player_has_completed_achivements()
	
	--Check if Lu Zhi has his books at game start
	local faction_lu_zhi = cm:query_faction("3k_dlc04_faction_lu_zhi")
	if faction_lu_zhi then
		if not faction_lu_zhi:is_null_interface() and faction_lu_zhi:is_human() then
			if not faction_lu_zhi:ceo_management():is_null_interface() then
				local book_number = faction_lu_zhi:ceo_management():all_ceos_for_category("3k_dlc04_ceo_category_factional_lu_zhi"):count_if(
					function(query_ceo)
						return not string.match(query_ceo:ceo_data_key(),"_locked")
					end
				)

				if book_number >= 20 then
					self:award("TK_DLC04_ACHIEVEMENT_COLLECT_ALL_BOOKS")
				end
			end
		end
	end

	--Check if Liu Chong has his trophies at game start
	local faction_liu_chong = cm:query_faction("3k_dlc04_faction_prince_liu_chong")
	if faction_liu_chong then
		if not faction_liu_chong:is_null_interface() and faction_liu_chong:is_human() then
			if not faction_liu_chong:ceo_management():is_null_interface() then
				local trophy_number = faction_liu_chong:ceo_management():all_ceos_for_category("3k_dlc04_ceo_category_factional_liu_chong"):count_if(
					function(query_ceo)
						return not string.match(query_ceo:ceo_data_key(),"_locked")
					end
				)

				if trophy_number >= 20 then
					self:award("TK_DLC04_ACHIEVEMENT_COLLECT_ALL_TROPHIES")
				end
			end
		end
	end
end

function achievements:add_listeners()

	-- DLC04 Specific Achievements.
	if cm:query_model():campaign_name() == "3k_dlc04_start_pos" then
		-- The Librarian - TK_DLC04_ACHIEVEMENT_COLLECT_ALL_BOOKS
		core:add_listener(
			"achievements_lu_zhi_faction_ceos",
			"FactionCeoAdded",
			function(context)
				return (context:faction():name()=="3k_dlc04_faction_lu_zhi" and context:faction():is_human()
				and context:ceo():category_key()=="3k_dlc04_ceo_category_factional_lu_zhi");
			end,
			function(context)
				if not context:faction():ceo_management():is_null_interface() then
					local book_number = context:faction():ceo_management():all_ceos_for_category("3k_dlc04_ceo_category_factional_lu_zhi"):count_if(
						function(query_ceo)
							return not string.match(query_ceo:ceo_data_key(),"_locked")
						end
					)
		
					if book_number >= 20 then
						self:award("TK_DLC04_ACHIEVEMENT_COLLECT_ALL_BOOKS")
					end
				end
			end,
			true
		);

		-- Restore the Han Achievement - TK_DLC04_ACHIEVEMENT_WIN_CAMPAIGN_AS_EMPRESS_HE
		core:add_listener(
			"achievements_restore_the_han",
			"PlayerCampaignFinished",
			function(context)
				return context:player_won() and context:faction():name() == "3k_dlc04_faction_empress_he";
			end,
			function(context)
				self:award("TK_DLC04_ACHIEVEMENT_WIN_CAMPAIGN_AS_EMPRESS_HE");
			end,
			false
		);

		-- Yellow Sky Achievement - TK_DLC04_ACHIEVEMENT_WIN_CAMPAIGN_AS_JIAZI_REBELLION
		core:add_listener(
			"achievements_yellow_sky",
			"PlayerCampaignFinished",
			function(context)
				return context:player_won() and context:faction():subculture() == "3k_main_subculture_yellow_turban";
			end,
			function(context)
				self:award("TK_DLC04_ACHIEVEMENT_WIN_CAMPAIGN_AS_JIAZI_REBELLION");
			end,
			false
		);
	end;

	-- DLC05 Specific or DLC07 Achievements.
	if (cm:query_model():campaign_name() == "3k_dlc05_start_pos" or cm:query_model():campaign_name() == "3k_dlc07_start_pos") then

		--Only set the save values when starting the campaign
		core:add_listener(
			"achievements_sun_ce_faction_ceos_turn_FactionTurnStart",
			"FactionTurnStart",
			function(context)
				return context:faction():name()=="3k_dlc05_faction_sun_ce" and context:faction():is_human() and context:query_model():turn_number()==1
			end,
			function(context)
				if not cm:saved_value_exists("3k_dlc05_item_set_sun_ce_ambition_the_southern_threat", "achievements_sun_ce_ceo_ambitions") then
					cm:set_saved_value("3k_dlc05_item_set_sun_ce_ambition_the_southern_threat",4,"achievements_sun_ce_ceo_ambitions")
					cm:set_saved_value("3k_dlc05_item_set_sun_ce_ambition_recruit_old_guard",2,"achievements_sun_ce_ceo_ambitions")
					cm:set_saved_value("3k_dlc05_item_set_sun_ce_ambition_achieve_the_little_conqueror",3,"achievements_sun_ce_ceo_ambitions")
					cm:set_saved_value("3k_dlc05_item_set_sun_ce_ambition_fulfil_zhou_yu_ambition",4,"achievements_sun_ce_ceo_ambitions")
					cm:set_saved_value("3k_dlc05_item_set_sun_ce_ambition_secure_the_heartland",3,"achievements_sun_ce_ceo_ambitions")
					cm:set_saved_value("3k_dlc05_item_set_sun_ce_ambition_secure_the_middle_yangtze",4,"achievements_sun_ce_ceo_ambitions")
					cm:set_saved_value("3k_dlc05_item_set_sun_ce_ambition_secure_the_homestead",4,"achievements_sun_ce_ceo_ambitions")
					cm:set_saved_value("3k_dlc05_item_set_sun_ce_ambition_secure_wu",3,"achievements_sun_ce_ceo_ambitions")
					cm:set_saved_value("3k_dlc05_item_set_sun_ce_ambition_secure_kuaiji",3,"achievements_sun_ce_ceo_ambitions")
					cm:set_saved_value("3k_dlc05_item_set_sun_ce_ambition_recruit_young_guard",3,"achievements_sun_ce_ceo_ambitions")
					cm:set_saved_value("3k_dlc05_item_set_sun_ce_ambition_recruit_legacy_of_sun_ce",4,"achievements_sun_ce_ceo_ambitions")
					cm:set_saved_value("3k_dlc05_item_set_sun_ce_ambition_recruit_four_warriors_of_china",2,"achievements_sun_ce_ceo_ambitions")
					cm:set_saved_value("3k_dlc05_item_set_sun_ce_ambition_recruit_grandmasters",5,"achievements_sun_ce_ceo_ambitions")
					cm:set_saved_value("3k_dlc05_item_set_sun_ce_ambition_recruit_governors_and_scholars",2,"achievements_sun_ce_ceo_ambitions")
					cm:set_saved_value("3k_dlc05_item_set_sun_ce_ambition_achieve_bandits_and_murders",2,"achievements_sun_ce_ceo_ambitions")	
				end
			end,
			false
		);

		-- Like my father before me Achievement - TK_DLC05_ACHIEVEMENT_SUN_CE_5_AMBITIONS_BEFORE_201
		core:add_listener(
			"achievements_sun_ce_like_my_father_before_me",
			"FactionCeoNodeChanged",
			function(context)
				local ceo = context:ceo()
				return (context:faction():name()=="3k_dlc05_faction_sun_ce" and context:faction():is_human() and ceo:max_points_in_ceo() <= ceo:num_points_in_ceo() and ceo:category_key()=="3k_dlc05_ceo_category_factional_sun_ce");
			end,
			function(context)
				local sun_ce_ambition_ceo_set = self.template_to_ceo[context:ceo():ceo_data_key()]

				if sun_ce_ambition_ceo_set ~= nil then		
					if(cm:saved_value_exists(sun_ce_ambition_ceo_set, "achievements_sun_ce_ceo_ambitions")) then
						local sun_ce_ambition_ceo_set_value = cm:get_saved_value(sun_ce_ambition_ceo_set, "achievements_sun_ce_ceo_ambitions")
						sun_ce_ambition_ceo_set_value = sun_ce_ambition_ceo_set_value-1
						cm:set_saved_value(sun_ce_ambition_ceo_set,sun_ce_ambition_ceo_set_value,"achievements_sun_ce_ceo_ambitions")
						if sun_ce_ambition_ceo_set_value == 0 then --ONLY DO ONCE
							if(cm:saved_value_exists("sun_ce_ambitions_count", "achievements" )) then 
								local sun_ce_ambitions_count = cm:get_saved_value("sun_ce_ambitions_count", "achievements") + 1
								if (5 <= sun_ce_ambitions_count and context:query_model():date_in_range(0,200)) then 
									self:award("TK_DLC05_ACHIEVEMENT_SUN_CE_5_AMBITIONS_BEFORE_201");
								end
								cm:set_saved_value("sun_ce_ambitions_count", sun_ce_ambitions_count, "achievements" )
							else 						
								cm:set_saved_value("sun_ce_ambitions_count", 1, "achievements" )
							end
						end
					end
				end
			end,
			true
		);

		-- Killed my father, prepare to die! Achievement - TK_DLC05_ACHIEVEMENT_SUN_CE_KILL_HUANG_ZU
		core:add_listener(
			"achievements_killed_my_father_CampaignBattleLoggedEvent",
			"CampaignBattleLoggedEvent",
			function(context)

				local pre_battle_log = pending_battle_cache:get_pending_battle_cache()
				local post_battle_log = context:log_entry()

				local char_huang_zu = cm:query_model():character_for_template("3k_main_template_historical_huang_zu_hero_wood")
				local char_sun_ce = cm:query_model():character_for_template("3k_main_template_historical_sun_ce_hero_fire")
				
				--quits if either character doesnt exist
				if not char_sun_ce or char_sun_ce:is_null_interface()
				or not char_huang_zu or char_huang_zu:is_null_interface() then
					return
				end

				--quits if not sun ce faction, or if sun ce faction isnt human
				if not char_sun_ce:faction():name() == "3k_dlc05_faction_sun_ce" 
				or not cm:query_faction("3k_dlc05_faction_sun_ce"):is_human() then
					return
				end

				--quits if either character wasnt in battle
				if not pre_battle_log:was_character_in_battle(char_huang_zu)
				or not pre_battle_log:was_character_in_battle(char_sun_ce) then
					return
				end


				--if guys were in battle and are in post battle 
				if pre_battle_log:was_character_in_battle(char_huang_zu)
				and pre_battle_log:was_character_in_battle(char_sun_ce) then

					local sun_ce_wins = post_battle_log:winning_characters():any_of(
						function(character)
							return character:character() == char_sun_ce
						end
					)

					local huang_zu_loses = post_battle_log:losing_characters():any_of(
						function(character)
							return character:character() == char_huang_zu
						end
					)

					local huang_zu_dead = char_huang_zu:is_dead()



					--returns true if sun ce and huang zu participated in the battle, and sun ce won and huang zu lost
					if sun_ce_wins and (huang_zu_loses or huang_zu_dead) then
						return true
					end


					local sun_ce_wins_duel = post_battle_log:duels():any_of(
						function(duel)
							if duel:has_winner()
							and not duel:winner():is_null_interface()
							and not duel:loser():is_null_interface() then
								return duel:winner() == char_sun_ce and duel:loser() == char_huang_zu
							end
						end
					)

					--returns true if sun ce and huang zu participated in the battle, and sun ce won a duel vs huang zu
					if sun_ce_wins_duel and huang_zu_dead then 
						return true
					end
				end
			end,
			function(context)
				local char_huang_zu = cm:query_model():character_for_template("3k_main_template_historical_huang_zu_hero_wood")

				if char_huang_zu:is_dead() then
					self:award("TK_DLC05_ACHIEVEMENT_SUN_CE_KILL_HUANG_ZU")
				end
			end,
			true
		)

		core:add_listener(
			"achievements_killed_my_father_CharacterPostBattleSlaughter",
			"CharacterPostBattleSlaughter",
			function(context)
				local char_huang_zu = cm:query_model():character_for_template("3k_main_template_historical_huang_zu_hero_wood")
				local char_sun_ce = cm:query_model():character_for_template("3k_main_template_historical_sun_ce_hero_fire")

				local pre_battle_log = pending_battle_cache:get_pending_battle_cache()


				if not char_huang_zu or char_huang_zu:is_null_interface() 
				or not char_sun_ce or char_sun_ce:is_null_interface() then
					return
				end

				--returns true if huang zu is the character executed, and huang zu and sun ce fought the last battle
				-- and sun ces faction is human
				if not context:query_character() == char_huang_zu then
					return
				else
					if cm:query_faction("3k_dlc05_faction_sun_ce"):is_human() then
						if pre_battle_log:was_character_in_battle(char_huang_zu)
						and pre_battle_log:was_character_in_battle(char_sun_ce) then
							return true
						end
					end
				end
			end,
			function(context)
				self:award("TK_DLC05_ACHIEVEMENT_SUN_CE_KILL_HUANG_ZU")
			end,
			true
		)
	end

	-- DLC05 Specific 
	if (cm:query_model():campaign_name() == "3k_dlc05_start_pos") then

		-- First blood Achievement - TK_DLC05_ACHIEVEMENT_LU_BU_1_KILL_LIST_COMPLETE
		-- Among Men, Lu Bu Achievement - TK_DLC05_ACHIEVEMENT_LU_BU_25_KILL_LIST_COMPLETE
		core:add_listener(
			"achievements_among_men_lu_bu_changed",
			"FactionCeoNodeChanged",
			function(context)
				local ceo = context:ceo()
				return (context:faction():name()=="3k_main_faction_lu_bu" and context:faction():is_human() and ceo:max_points_in_ceo() <= ceo:num_points_in_ceo() and ceo:category_key()=="3k_dlc05_ceo_category_factional_lu_bu");
			end,
			function(context)
				if(cm:saved_value_exists("kill_list_count", "achievements")) then 
					local kill_list_count = cm:get_saved_value("kill_list_count", "achievements") + 1
					if 25 == kill_list_count then 
						self:award("TK_DLC05_ACHIEVEMENT_LU_BU_25_KILL_LIST_COMPLETE");
					end
					cm:set_saved_value("kill_list_count", kill_list_count, "achievements" )
				else 	
					local kill_list_count = 3				
					self:award("TK_DLC05_ACHIEVEMENT_LU_BU_1_KILL_LIST_COMPLETE");
					cm:set_saved_value("kill_list_count", kill_list_count, "achievements" )
				end
			end,
			true
		);

		-- Combo Kill Achievement - TK_DLC05_ACHIEVEMENT_LU_BU_WIN_THREE_BATTLES_ONE_TURN
		core:add_listener(
			"achievements_combo_kill",
			"CampaignBattleLoggedEvent",
			function(context)
				local pending_battle_chached = pending_battle_cache:get_pending_battle_cache()
				if pending_battle_chached~=nil then
					if not pending_battle_chached:attacker_commander()~=nil then
						return (pending_battle_chached:attacker_commander().faction =="3k_main_faction_lu_bu" and cm:query_faction("3k_main_faction_lu_bu"):is_human());
					end
				end		
				return false						
			end,
			function(context)
				local lu_bu_faction_leader = cm:query_faction("3k_main_faction_lu_bu"):faction_leader()
				if not lu_bu_faction_leader:is_null_interface() then
					for i = 0, context:log_entry():winning_characters():num_items()-1 do
						local winning_character = context:log_entry():winning_characters():item_at(i):character()
						if not winning_character:is_null_interface() then
							local winning_character_name = winning_character:generation_template_key()
							if(winning_character_name==lu_bu_faction_leader:generation_template_key()) then
								if(cm:saved_value_exists("battles_fought_lu_bu", "achievements" )) then 
									local battles_fought = cm:get_saved_value("battles_fought_lu_bu", "achievements") + 1
									if 3 == battles_fought then 
										self:award("TK_DLC05_ACHIEVEMENT_LU_BU_WIN_THREE_BATTLES_ONE_TURN");
									end
									cm:set_saved_value("battles_fought_lu_bu", battles_fought, "achievements" )
								else 						
									cm:set_saved_value("battles_fought_lu_bu", 1, "achievements" )
								end
								break
							end
						end					
					end	
				end								
			end,
			true
		);

		--RESETS LU_BU'S COMBO COUNTER
		core:add_listener(
			"achievements_combo_kill_reset",
			"FactionTurnEnd",
			function(context)
				if not context:faction():is_null_interface() then
					return (context:faction():name()=="3k_main_faction_lu_bu");
				end
			end,
			function(context)
				cm:set_saved_value("battles_fought_lu_bu", 0, "achievements" )
			end,
			true
		);	
	end

	--DLC04 OR DLC05 OR ORGINAL STARTPOS 
	if (cm:query_model():campaign_name() == "3k_dlc04_start_pos" or cm:query_model():campaign_name() == "3k_dlc05_start_pos" or cm:query_model():campaign_name() == "3k_main_campaign_map" ) then
		-- Trophy Hunter - TK_DLC04_ACHIEVEMENT_COLLECT_ALL_TROPHIES
		core:add_listener(
			"achievements_liu_chong_faction_ceos",
			"FactionCeoAdded",
			function(context)
				return (context:faction():name()=="3k_dlc04_faction_prince_liu_chong" and context:faction():is_human()
				and context:ceo():category_key()=="3k_dlc04_ceo_category_factional_liu_chong");
			end,
			function(context)
				if not context:faction():ceo_management():is_null_interface() then
					local trophy_number = context:faction():ceo_management():all_ceos_for_category("3k_dlc04_ceo_category_factional_liu_chong"):count_if(
						function(query_ceo)
							return not string.match(query_ceo:ceo_data_key(),"_locked")
						end
					)
		
					if trophy_number >= 20 then
						self:award("TK_DLC04_ACHIEVEMENT_COLLECT_ALL_TROPHIES")
					end
				end
			end,
			true
		);
	end

	--DLC05 OR ORGINAL START POS
	if (cm:query_model():campaign_name() == "3k_dlc05_start_pos" or cm:query_model():campaign_name() == "3k_main_campaign_map") then
		-- White Tiger Burning Bright Achievement - TK_DLC05_ACHIEVEMENT_YAN_BAIHU_15_ALLICES
		core:add_listener(
			"achievements_White_Tiger_Burning_Bright",
			"PooledResourceEffectChangedEvent",
			function(context)
				if cm:query_faction("3k_dlc05_faction_white_tiger_yan") ~= nil then
					if (not cm:query_faction("3k_dlc05_faction_white_tiger_yan"):is_null_interface()) then
						if (not context:resource():is_null_interface()) then
							return (context:resource():record_key()=="3k_dlc05_pooled_resource_white_tiger_confederation"
							and context:new_effect()=="3k_dlc05_effect_bundle_pooled_resource_white_tiger_confederation_level_4"
							and cm:query_faction("3k_dlc05_faction_white_tiger_yan"):is_human());
						end
					end	
				end		
				return false			
			end,
			function(context)
				self:award("TK_DLC05_ACHIEVEMENT_YAN_BAIHU_15_ALLICES");
			end,
			true
		);

		--Fear the Tiger more than the government Achivement- TK_DLC05_ACHIEVEMENT_YAN_BAIHU_DESTROY_SUN_CE
		core:add_listener(
			"FactionDied_achievements_fear_the_tiger",
			"FactionDied",
			function(context)
			if (not cm:query_faction("3k_dlc05_faction_sun_ce"):is_null_interface()
				and not cm:query_faction("3k_dlc05_faction_white_tiger_yan"):is_null_interface()) then
				return (cm:query_faction( "3k_dlc05_faction_white_tiger_yan"):is_human()) and (context:faction():name()=="3k_dlc05_faction_sun_ce")
			end
			return false
			end,				
			function(context)
				self:award("TK_DLC05_ACHIEVEMENT_YAN_BAIHU_DESTROY_SUN_CE");
			end,
			true
		);	
	end

	--DLC05 OR ORGINAL START POS OR DLC07
	if (cm:query_model():campaign_name() == "3k_dlc05_start_pos" or cm:query_model():campaign_name() == "3k_main_campaign_map" or cm:query_model():campaign_name() == "3k_dlc07_start_pos") then
		
		--THE PURIST
		--During a Nanman campaign, complete a tech tree where all major reforms are to one side.
		core:add_listener(
			"achievements_nanman_research",
			"ResearchCompleted",
			function(context)
				
				-- "3k_dlc06_tech_nanman_" -> filters for nanman techs only
				-- "r4_" -> using the tech naming convention, r stands for reform, 4 is the tier
				--returns true if it's a nanman tech, and the final reform for any of the tech trees.
				return string.match(context:technology_record_key(), "3k_dlc06_tech_nanman_") and string.match(context:technology_record_key(), "r4_")
			end,
			function(context)

				--Note: ideally I'd have made this cleaner/smaller, but there's no "researched tech list" in the query_faction interface
				--so we have to check key by key
				--i tried using lists and stuff, but this method turned out way easier to read, even if it's chunkier
				
				--checks to see if the player has all techs to one side of any one of the 3 trees
				local function achivement_unlock_through_techs()
					--economic tree, han side
					if context:faction():has_technology("3k_dlc06_tech_nanman_er1_1_centralised_storage_han")
					and context:faction():has_technology("3k_dlc06_tech_nanman_er2_1_division_of_labour_han")
					and context:faction():has_technology("3k_dlc06_tech_nanman_er3_1_streamlined_governance_han") then
						return true
					end

					--economic tree, nanman side
					if context:faction():has_technology("3k_dlc06_tech_nanman_er1_2_ancestral_farmland_nanman")
					and context:faction():has_technology("3k_dlc06_tech_nanman_er2_2_advanced_metalwork_nanman")
					and context:faction():has_technology("3k_dlc06_tech_nanman_er3_2_ancestral_belief_nanman") then
						return true
					end

					--military tree, han side
					if context:faction():has_technology("3k_dlc06_tech_nanman_mr1_1_advanced_battle_tactics_han")
					and context:faction():has_technology("3k_dlc06_tech_nanman_mr2_1_southern_hirelings_han")
					and context:faction():has_technology("3k_dlc06_tech_nanman_mr3_1_engineers_of_war_han") then
						return true
					end

					--military tree, nanman side
					if context:faction():has_technology("3k_dlc06_tech_nanman_mr1_2_tribal_zeal_nanman")
					and context:faction():has_technology("3k_dlc06_tech_nanman_mr2_2_professional_soldiery_nanman")
					and context:faction():has_technology("3k_dlc06_tech_nanman_mr3_2_lays_of_the_land_nanman") then
						return true
					end

					--political tree, han side
					if context:faction():has_technology("3k_dlc06_tech_nanman_pr1_1_methods_of_unification_han")
					and context:faction():has_technology("3k_dlc06_tech_nanman_pr2_1_demand_fealty_han")
					and context:faction():has_technology("3k_dlc06_tech_nanman_pr3_1_bureaucratic_reform_han") then
						return true
					end

					---political tree, nanman side
					if context:faction():has_technology("3k_dlc06_tech_nanman_pr1_2_trade_hubs_nanman")
					and context:faction():has_technology("3k_dlc06_tech_nanman_pr2_2_contractual_obligations_nanman")
					and context:faction():has_technology("3k_dlc06_tech_nanman_pr3_2_regional_investigations_nanman") then
						return true
					end

					return false
				end

				if achivement_unlock_through_techs() then
					self:award("TK_DLC06_ACHIEVEMENT_NANMAN_TECHS")
					--self removes once no longer needed.
					core:remove_listener("achievements_nanman_research")
				end
			end,
			true
		);


		--I'm the Man	
		--During a Nanman campaign, have all Nanman fealties under your control	
		core:add_listener(
			"achievements_nanman_tribes_united",
			"FealtyTribesUnitedBy",
			function(context)
				local faction_key = context:faction_key();
				for i, human_faction in ipairs(cm:get_human_factions()) do
					if human_faction == faction_key then
						return true
					end
				end
			end,
			function()
				self:award("TK_DLC06_ACHIEVEMENT_NANMAN_FEALTY");
			end,
			false
		);


		--The Barbarian Emperor
		--Playing as a Nanman, become the emperor of the Han, or support an emperor's claim and win.	
		core:add_listener(
			"achievements_nanman_emperor",
			"PlayerCampaignFinished",
			function(context)
				return context:player_won() and context:faction():culture() == "3k_dlc06_barbarian"
			end,
			function(context)
				self:award("TK_DLC06_ACHIEVEMENT_NANMAN_EMPEROR");
			end,
			false
		);

		--Lords of the South
		--Playing as Shi Xie, have 4 vassals that are also members of your family.	
		core:add_listener(
			"achievements_shi_xie_vassalisation",
			"FactionTurnStart",
			function(context)
				return context:faction():name() == "3k_main_faction_shi_xie" and context:faction():is_human()
			end,
			function(context)

				local shi_xie_vassal_counter = 0
				local shi_xie_faction = cm:query_faction("3k_main_faction_shi_xie")
				for i = 0, cm:query_model():world():faction_list():num_items() -1 do
					local current_faction = cm:query_model():world():faction_list():item_at(i)

					if current_faction ~= nil and not current_faction:is_null_interface()
					and not current_faction:is_dead() and not current_faction:is_rebel()
					and current_faction:name() ~= "3k_main_faction_shi_xie"
					and current_faction:has_specified_diplomatic_deal_with("treaty_components_vassalage", shi_xie_faction)
					and shi_xie_resource_manager:is_in_family_list(current_faction:faction_leader()) then
					
						shi_xie_vassal_counter = shi_xie_vassal_counter + 1
					end
				end

				if shi_xie_vassal_counter >=4 then
					self:award("TK_DLC06_ACHIEVEMENT_SHI_XIE_SOUTH")
					--self removes once no longer needed
					core:remove_listener("achievements_shi_xie_vassalisation")
				end
			end,
			true
		);


		--That Still Only Counts as One	
		--Win a battle against an opponent fielding at least one elephant unit, or with a General that has an elephant as their mount.	
		
		local function elephants_present(pending_battle_cache_military_forces)
			--gets us all the retinues for our attacker/defender force
			for i, military_force in ipairs(pending_battle_cache_military_forces) do
				for j, retinue in ipairs(military_force.retinues) do
					
					if retinue.commander then

						local commander = cm:query_character(retinue.commander.cqi)

						if commander and not commander:is_null_interface()
						and not commander:ceo_management():is_null_interface() then

							--checks commander equipped items and looks for elephant mount
							local ceo_list = commander:ceo_management():all_ceos_equipped_on_character()
							for k = 0, ceo_list:num_items() -1 do
								if string.match(ceo_list:item_at(k):ceo_data_key(), "3k_dlc06_ancillary_mount_elephant_") then
									return true
								end
							end
						end

						--checks retinue units for elephants
						for k, unit in ipairs(retinue.units) do
							if unit.unit_class == "elph" then
								return true
							end
						end
					end
				end
			end
			return false
		end

		--goes through each one of the winning factions, tries to match them with any of the attacking factions	
		local function attackers_won(post_battle_log, pending_battle_log)
			for i = 0, post_battle_log:winning_factions():num_items() -1 do
				local winning_faction_key = post_battle_log:winning_factions():item_at(i):name()

				for j = 1, #pending_battle_log.attackers do
					local attacking_faction_key = pending_battle_log.attackers[j].faction

					if winning_faction_key == attacking_faction_key then
						return true
					end
				end
			end
			return false
		end

		core:add_listener(
			"achievements_dlc06_elephants",
			"CampaignBattleLoggedEvent",
			function(context)
				local pending_log = pending_battle_cache:get_pending_battle_cache()
			
				--if we got elephants, procceed to the next phase.
				return elephants_present(pending_log.attackers) or elephants_present(pending_log.defenders)
			end,
			function(context)
				
				local elephants_lost_battle = false

				local pending_battle_log = pending_battle_cache:get_pending_battle_cache()
				local post_battle_log = context:log_entry()

				
				if attackers_won(post_battle_log, pending_battle_log) then
					elephants_lost_battle = elephants_present(pending_battle_log.defenders)
				else
					elephants_lost_battle = elephants_present(pending_battle_log.attackers)
				end

				if elephants_lost_battle then
					self:award("TK_DLC06_ACHIEVEMENT_ELEPHANT_MOUNTS")
					core:remove_listener("achievements_dlc06_elephants")
				end

			end,
			true
		);


		--Tiger King	
		--Win a battle where an entire retinue was made up of tiger units.	
		core:add_listener(
			"achievements_nanman_tiger_units",
			"CampaignBattleLoggedEvent",
			function(context)
				local pending_log = pending_battle_cache:get_pending_battle_cache()

				local function tiger_units_present(pending_battle_cache_military_forces)
					--gets us all the retinues for our attacker/defender force
					for i, military_force in ipairs(pending_battle_cache_military_forces) do
						for j, retinue in ipairs(military_force.retinues) do

							--checks retinue units for elephants
							for k, unit in ipairs(retinue.units) do

								if unit.unit_key == "3k_dlc06_unit_metal_tiger_warriors" or unit.unit_key == "3k_dlc06_unit_water_tiger_slingers" then
									return true
								end
							end
						end
					end
				end
				return tiger_units_present(pending_log.attackers) or tiger_units_present(pending_log.defenders)
			end,
			function(context)

				local pending_log = pending_battle_cache:get_pending_battle_cache()
				local post_battle_log = context:log_entry()

				local function count_tiger_units(pending_battle_cache_military_forces)
					--gets us all the retinues for our attacker/defender force
					for i, military_force in ipairs(pending_battle_cache_military_forces) do
						for j, retinue in ipairs(military_force.retinues) do

							local tiger_unit_count = 0

							--checks retinue units for tigers
							for k, unit in ipairs(retinue.units) do

								if unit.unit_key == "3k_dlc06_unit_metal_tiger_warriors" or unit.unit_key == "3k_dlc06_unit_water_tiger_slingers" then
									tiger_unit_count = tiger_unit_count + 1
								end
							end

							if tiger_unit_count >= 6 then
								return true
							end
						end
					end
				end

				if ( attackers_won(post_battle_log, pending_log) and count_tiger_units(pending_log.attackers) ) or
				( not attackers_won(post_battle_log, pending_log) and count_tiger_units(pending_log.defenders) ) then
					self:award("TK_DLC06_ACHIEVEMENT_TIGER_RETINUE");
					core:remove_listener("achievements_nanman_tiger_units")
				end
			end,
			true
		);
	end
	
	-- Bandit Emperor Achievement - TK_DLC05_ACHIEVEMENT_WIN_CAMPAIGN_AS_BANDIT_EMPEROR
	core:add_listener(
		"achievements_bandit_emperor",
		"PlayerCampaignFinished",
		function(context)
			return context:player_won() and context:faction():subculture() == "3k_dlc05_subculture_bandits";
		end,
		function(context)
			self:award("TK_DLC05_ACHIEVEMENT_WIN_CAMPAIGN_AS_BANDIT_EMPEROR");
		end,
		false
	);

	-- Many Faces, Many Names Achievement - TK_DLC05_ACHIEVEMENT_GIVE_OUT_5_TITLES_CEOS
	core:add_listener(
		"achievements_a_man_of_many_names",
		"CharacterCeoEquipped",
		function(context)
			if context:query_character():faction():is_human() then
				local numberOfTitles = 0;
				local character_list = context:query_character():faction():character_list()
				local faction_ceo_management = context:query_character():faction():ceo_management()
				local titles = faction_ceo_management:all_ceos_for_category("3k_dlc05_ceo_category_ancillary_titles")
				for j =0,titles:num_items() - 1 do 
					if titles:item_at(j):is_equipped_in_slot() then
						numberOfTitles = numberOfTitles + 1
						if numberOfTitles == 5 then 
							return true
						end
					end
				end
			end
			return false;
		end,
		function(context)
			self:award("TK_DLC05_ACHIEVEMENT_GIVE_OUT_5_TITLES_CEOS");
		end,
		true
	);
	-- Honour among Thieves Achievement - TK_DLC05_ACHIEVEMENT_STANCE_SHARE_LOOT_MAX
	core:add_listener(
		"achievements_honour_among_thieves",
		"ForceAdoptsStance",
		function(context)
			if not context:military_force():is_null_interface() then
				return (context:query_model():is_player_turn() and 
				context:military_force():morale()==100 and
				context:military_force():faction():subculture()=="3k_dlc05_subculture_bandits" and 
				context:stance_adopted()=="MILITARY_FORCE_ACTIVE_STANCE_TYPE_CHANNELING"); 
			end
		end,
		function(context)
			self:award("TK_DLC05_ACHIEVEMENT_STANCE_SHARE_LOOT_MAX");
		end,
		true
	);

end;
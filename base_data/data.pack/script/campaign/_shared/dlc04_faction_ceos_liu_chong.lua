---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------
----- Name:			dlc04_faction_ceos_liu_chong.lua
----- Description: 	Three Kingdoms system for managing Liu Chong's faction ceos.
---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------

cm:add_first_tick_callback_new(function() lc_faction_ceos:new_game() end);
cm:add_first_tick_callback(function() lc_faction_ceos:initialise() end); --Self register function


lc_faction_ceos = {
	faction_key = "3k_dlc04_faction_prince_liu_chong";
	listener_name = "dlc04_liu_chong_faction_ceos";
	system_id = "[301] lc_faction_ceos - ";
	locked_ceo_suffix = "_locked";
	category_key = "3k_dlc04_ceo_category_factional_liu_chong";
};

local melee_inf_unique_rank = 7;

function lc_faction_ceos:new_game()
	local lc_faction = cm:query_faction(self.faction_key);
	
	if not lc_faction then
		return false;
	end;

	if lc_faction:has_faction_leader() then

		-- Bronze Boshanlu - Reach rank 6 with faction leader
		if lc_faction:faction_leader():rank() >= melee_inf_unique_rank then
			lc_faction_ceos:add_points("3k_dlc04_ceo_factional_trophy_cabinet_melee_inf_unique", 1)
		end;
	end;
	
end;

function lc_faction_ceos:initialise()
	self:print("Liu Chong faction CEO script initialised.");

	-- Exit if we cannot find Liu Chong.
	if not cm:query_faction(self.faction_key) then
		return false;
	end;

	-- Different unlock criteria for human/AI factions?
	if cm:query_faction(self.faction_key):is_human() then
		self:add_listeners();
	else
		self:print("TODO - Liu Chong is an ai faction but is using the player triggers.");
		self:add_listeners();
	end;
end;

-- system adds points to CEO Nodes, whenever a specific trigger is fired. Stops the system needing to save/load any state data.



--[[
*****************************************************************
LISTENERS
*****************************************************************
]]--



-- Add the listeners for the different events.
function lc_faction_ceos:add_listeners()

	-- Gained on Marquis Rank
	self:create_listener("3k_dlc04_ceo_factional_trophy_cabinet_heroes_unique", 1,
		"FactionFameLevelUp",
		function(context) return self:was_my_faction(context:faction()) and progression:has_progression_feature(context:faction(), "rank_marquis", true) end);
		
	-- Starts with
	self:create_listener("3k_dlc04_ceo_factional_trophy_cabinet_melee_cav_common", 1, 
		"FactionTurnStart",
		function(context) return self:was_my_faction(context:faction()) and context:query_model():turn_number() == 1 end);
		
	-- Win 5 Duels (with faction leader)
	self:create_listener("3k_dlc04_ceo_factional_trophy_cabinet_melee_cav_refined", 1,
		"CampaignBattleLoggedEvent",
		function(context) 
			local log_entry = context:log_entry();
			return self:did_my_faction_leader_win_a_duel(log_entry)
		end);
		
	--Have five mount ancilaries
	core:add_listener(
		"FactionTurnStartLiuChongMetal", -- Unique handle
		"FactionTurnStart", -- Campaign Event to listen for
		function(context)
			return (self:was_my_faction(context:faction()))
		end,
		function(context)
			local ceo_management = context:faction():ceo_management()
			local ceo_management_mounts = ceo_management:all_ceos_for_category("3k_main_ceo_category_ancillary_mount")
			local ceo_management_mounts_max = 0;

			if cm:saved_value_exists("mount_ceo_max", "liu_chong_trophy" ) then	
				ceo_management_mounts_max = cm:get_saved_value("mount_ceo_max", "liu_chong_trophy" )
			end

			-- Dodgy data can be saved to the saved values if the script breaks. This will mean it cannot ever break.
			if not ceo_management_mounts_max then
				ceo_management_mounts_max = 0
			end

			if ceo_management_mounts_max < ceo_management_mounts:num_items() then
				self:add_points("3k_dlc04_ceo_factional_trophy_cabinet_melee_cav_unique", (ceo_management_mounts:num_items() - ceo_management_mounts_max));
			end
			cm:set_saved_value("mount_ceo_max", ceo_management_mounts:num_items(),"liu_chong_trophy" );
		end,
	true --Is persistent
	);

	-- Have 15 Melee, Pikemen, Ranged, Siege or Crossbow Units
	core:add_listener(
		"FactionTurnStartLiuChongMetal", -- Unique handle
		"FactionTurnStart", -- Campaign Event to listen for
		function(context)
			return (self:was_my_faction(context:faction()))
		end,
		function(context) -- What to do if listener fires.	
			--CEO VARIABLES
			local melee_inf_ceo = self:get_liu_chong_ceo_from_string("3k_dlc04_ceo_factional_trophy_cabinet_melee_inf_refined")
			local spear_inf_ceo = self:get_liu_chong_ceo_from_string("3k_dlc04_ceo_factional_trophy_cabinet_spear_inf_refined")
			local ranged_ceo = self:get_liu_chong_ceo_from_string("3k_dlc04_ceo_factional_trophy_cabinet_ranged_common")
			local siege_ceo = self:get_liu_chong_ceo_from_string("3k_dlc04_ceo_factional_trophy_cabinet_siege_unique")
			local shock_cav_ceo = self:get_liu_chong_ceo_from_string("3k_dlc04_ceo_factional_trophy_cabinet_shock_cav_refined")
			--VARIABLES
			local melee_units,spear_units,missile_units,siege_units,cross_bow_units = 0,0,0,0,0;
			local melee_units_max,spear_units_max,missile_units_max,siege_units_max,cross_bow_units_max = 0,0,0,0,0;
			--CHECK IF ALL THE TROPHIES HAVE NOT BEEN UNLOCKED
			if((melee_inf_ceo==nil) or 
			(spear_inf_ceo==nil) or
			(ranged_ceo==nil) or
			(siege_ceo==nil) or
			(shock_cav_ceo==nil)) then
				--GET THE MAX VALUES
				if (cm:saved_value_exists("melee_units_max", "liu_chong_trophy" )) then	
					melee_units_max = cm:get_saved_value("melee_units_max", "liu_chong_trophy" )
					if(melee_units_max==nil) then melee_units_max=0 end
				end
				if (cm:saved_value_exists("spear_units_max", "liu_chong_trophy" )) then	
					spear_units_max = cm:get_saved_value("spear_units_max", "liu_chong_trophy" )	
					if(spear_units_max==nil) then spear_units_max=0 end
				end
				if (cm:saved_value_exists("missile_units_max", "liu_chong_trophy" )) then 
					missile_units_max = cm:get_saved_value("missile_units_max", "liu_chong_trophy" )					
					if(missile_units_max==nil) then missile_units_max=0 end
				end
				if (cm:saved_value_exists("siege_units_max", "liu_chong_trophy" )) then	
					siege_units_max = cm:get_saved_value("siege_units_max", "liu_chong_trophy") 
					if(siege_units_max==nil) then siege_units_max=0 end
				end
				if (cm:saved_value_exists("cross_bow_units_max", "liu_chong_trophy" )) then	
					cross_bow_units_max = cm:get_saved_value("cross_bow_units_max", "liu_chong_trophy")
					if(cross_bow_units_max==nil) then cross_bow_units_max=0 end
				end

				--COUNT THE DIFFERENT UNITS IN THE FACTION 
				local military_list = context:faction():military_force_list()
				--Go through all the military retinue lists		
				for i = 0, military_list:num_items() - 1 do				
					local unit_list = military_list:item_at(i):unit_list()
					--MILITARY FORCE MUST NOT BE GARRISON RETINUE OR EMPTY
					if not misc:is_transient_character(military_list:item_at(i):general_character()) and not unit_list:is_empty() then
						for j = 0, unit_list:num_items() - 1 do
							local unit = unit_list:item_at(j)
							--Have 15 Melee Infantry units
							if(unit:unit_class()=="inf_mel") then
								melee_units = melee_units+1
							--Have 15 Pikemen Infantry units -- the in game text reads: Unlocked by: Have 15 spear infantry units (at the start of your turn)
							--adjusting to include inf_spr due to 1.7.1 bug fix GUAN-4778
							elseif(unit:unit_class()=="inf_pik" or unit:unit_class()=="inf_spr") then
								spear_units = spear_units+1
							--Have 15 Ranged Infantry units
							elseif(unit:unit_class()=="inf_mis" or unit:unit_class() == "cav_mis") then
								missile_units = missile_units+1
							--Have 15 Melee Cavarly units
							elseif(unit:unit_class()=="art_siege") then
								siege_units = siege_units+1
							end
							--Have 15 Crossbow units
							if(unit:unit_key() == "3k_dlc04_unit_water_chen_royal_guard" 
								or unit:unit_key() == "3k_dlc04_unit_water_imperial_palace_cavalry" 
								or unit:unit_key() == "3k_dlc04_unit_water_imperial_palace_crossbowmen" 
								or unit:unit_key() == "3k_main_unit_water_crossbowmen" 
								or unit:unit_key() == "3k_main_unit_water_fury_of_beihai"
								or unit:unit_key() == "3k_main_unit_water_heavy_crossbowmen"
								or unit:unit_key() == "3k_main_unit_water_heavy_repeating_crossbowmen"
								or unit:unit_key() == "3k_main_unit_water_repeating_crossbowmen"
								or unit:unit_key() == "3k_main_unit_water_thunder_of_jian_an"
								or unit:unit_key() == "3k_ytr_unit_water_watchmen_of_the_peace") then
									cross_bow_units = cross_bow_units+1
							end
						end
					end				
				end
				--APPLY NUMBER OF COUNTED UNITS TO THE CEOS
				if(melee_units_max<=melee_units) then 
					self:add_points("3k_dlc04_ceo_factional_trophy_cabinet_melee_inf_refined", melee_units-melee_units_max); 
					cm:set_saved_value("melee_units_max",melee_units,"liu_chong_trophy")
				end
				if(spear_units_max<=spear_units) then 
					self:add_points("3k_dlc04_ceo_factional_trophy_cabinet_spear_inf_refined", spear_units-spear_units_max);
					cm:set_saved_value("spear_units_max",spear_units,"liu_chong_trophy")
				end
				if(missile_units_max<=missile_units) then 
					self:add_points("3k_dlc04_ceo_factional_trophy_cabinet_ranged_common", missile_units-missile_units_max);
					cm:set_saved_value("missile_units_max",missile_units,"liu_chong_trophy")
				end
				if(siege_units_max<=siege_units) then 
					self:add_points("3k_dlc04_ceo_factional_trophy_cabinet_siege_unique", siege_units-siege_units_max);
					cm:set_saved_value("siege_units_max",siege_units,"liu_chong_trophy")
				end
				if(cross_bow_units_max<=cross_bow_units) then 
					self:add_points("3k_dlc04_ceo_factional_trophy_cabinet_shock_cav_refined", cross_bow_units-cross_bow_units_max);
					cm:set_saved_value("cross_bow_units_max",cross_bow_units,"liu_chong_trophy")
				end
			end
		end,
	true --Is persistent
	);

	-- Bronze Boshanlu - Reach rank 6 with faction leader
	self:create_listener("3k_dlc04_ceo_factional_trophy_cabinet_melee_inf_unique", 1,
		"CharacterRank",
		function(context) 
			local character = context:query_character()
			if character:is_faction_leader() and self:was_my_faction(character:faction()) and character:rank() >= melee_inf_unique_rank then
				return true;
			end;
			return false;
		end);
	
	-- Win 5 Siege Battles
	self:create_listener("3k_dlc04_ceo_factional_trophy_cabinet_people_unique", 1,
		"CampaignBattleLoggedEvent",
		function(context) 
			local log_entry = context:log_entry();
			local was_liu_chong = self:was_my_faction_leader_winner_in_battle(log_entry);

			-- Only return true if we were liu chong winning and it was a siege battle.
			if was_liu_chong and cm:query_model():pending_battle():seige_battle() then
				return true;
			end;

			return false;
		end);

	-- Defeat a yellow turban force.
	self:create_listener("3k_dlc04_ceo_factional_trophy_cabinet_melee_inf_common", 1, 
	"CampaignBattleLoggedEvent",
	function(context) 
		local log_entry = context:log_entry();
		local was_liu_chong = self:was_my_faction_leader_winner_in_battle(log_entry);

		if was_liu_chong then
			for i = 0, log_entry:losing_factions():num_items() - 1 do
				local faction = log_entry:losing_factions():item_at(i);
				if faction:subculture() == "3k_main_subculture_yellow_turban" then
					return true;
				end;
			end;
		end;

		return false;
	end);
	
	-- Rank up Ranged Units 15 times
	self:create_listener("3k_dlc04_ceo_factional_trophy_cabinet_ranged_refined", 1,
		"UnitExperienceLevelGained",
		function(context) 
			return self:was_my_faction(context:unit():faction()) and (context:unit():unit_class() == "inf_mis" or context:unit():unit_class() == "cav_mis")
		end);
		
	-- Win 15 battles
	self:create_listener("3k_dlc04_ceo_factional_trophy_cabinet_ranged_unique", 1,
		"CampaignBattleLoggedEvent",
		function(context) 
			local log_entry = context:log_entry();
			return self:was_my_faction_leader_winner_in_battle(log_entry);
		end);

	-- Win 5 battles where you had atleast six crossbow men
	self:create_listener("3k_dlc04_ceo_factional_trophy_cabinet_shock_cav_common", 1, 
		"CampaignBattleLoggedEvent",
		function(context) 
			local log_entry = context:log_entry();
			for i = 0,log_entry:winning_factions():num_items()-1 do

				if self:was_my_faction(log_entry:winning_factions():item_at(i)) then
					local number_of_crossbow_units = 0;
					local winning_characters = log_entry:winning_characters()
					local num_crossbow_units_required = 6;
		

					for j = 0, winning_characters:num_items() - 1 do
						--CHECK IF CHARACTER BELONGS TO LIU CHONGS FACTION
						local winning_character = winning_characters:item_at(j):character()

						-- Only go further if the character has a force.
						if self:was_my_faction(winning_character:faction()) and winning_character:has_military_force() then

							--GET UNIT LIST AND CHECK IF ANY OF THEM WERE CROSSBOW UNITS
							local unit_list = winning_character:military_force():unit_list();
							for k = 0, unit_list:num_items() - 1 do
								local unit_key = unit_list:item_at(k):unit_key()
								if(unit_key == "3k_dlc04_unit_water_chen_royal_guard" 
									or unit_key == "3k_dlc04_unit_water_imperial_palace_cavalry" 
									or unit_key == "3k_dlc04_unit_water_imperial_palace_crossbowmen" 
									or unit_key == "3k_main_unit_water_crossbowmen" 
									or unit_key == "3k_main_unit_water_fury_of_beihai"
									or unit_key == "3k_main_unit_water_heavy_crossbowmen"
									or unit_key == "3k_main_unit_water_heavy_repeating_crossbowmen"
									or unit_key == "3k_main_unit_water_repeating_crossbowmen"
									or unit_key == "3k_main_unit_water_thunder_of_jian_an"
									or unit_key == "3k_ytr_unit_water_watchmen_of_the_peace") then

									number_of_crossbow_units = number_of_crossbow_units + 1;
								end
							end

							--IF NUMBER OF CROSSBOW MEN PRESENT ARE HIGHER THAN 6
							if num_crossbow_units_required <= number_of_crossbow_units then
								print("RETURN TRUE FOR CHEN BANNER")
								return true;
							end
						end;

					end	
					--LIU CHONG'S FACTION HAS BEEN CHECKED FOR WINNING CHARACTERS. END LOOP

					break;
				end
			end
			return false;
		end);
		
	-- Rank up Melee Cavalry 15 times
	self:create_listener("3k_dlc04_ceo_factional_trophy_cabinet_shock_cav_unique", 1,
		"UnitExperienceLevelGained",
		function(context) 
			return self:was_my_faction(context:unit():faction()) and context:unit():unit_class() == "cav_mel" 
		end);
	
	-- Win a defensive siege battle with Liu Chong
	self:create_listener("3k_dlc04_ceo_factional_trophy_cabinet_siege_common", 1,
		"CampaignBattleLoggedEvent",
		function(context) 
			local log_entry = context:log_entry();
			local was_liu_chong = self:was_my_faction_leader_winner_in_battle(log_entry);

			if was_liu_chong then

			for i = 0, log_entry:winning_characters():num_items() - 1 do
				local character = log_entry:winning_characters():item_at(i):character();
				if character:is_faction_leader() 
					and self:was_my_faction(character:faction())	
					and character:has_military_force() 
					and character:military_force():general_character():command_queue_index() == character:command_queue_index() 
					and character:defensive_sieges_won() >= 1
				then
					return true;
				end;
	
			end;

			return false;
		end
	end);

	-- Rank up Trebuchet 5 times	
	self:create_listener("3k_dlc04_ceo_factional_trophy_cabinet_siege_refined", 1,		
		"UnitExperienceLevelGained",
		function(context) 
			return self:was_my_faction(context:unit():faction()) and context:unit():unit_class() == "art_siege" 
		end);	
		
	-- 'Recruit' captives after battle 10 times
	self:create_listener("3k_dlc04_ceo_factional_trophy_cabinet_spear_inf_common", 1,
		"CharacterCaptiveOptionApplied",
		function(context)
			return self:was_my_faction(context:capturing_force():faction()) and context:captive_option_outcome() == "EMPLOY" 
		end);

	-- Win 30 land battles
	self:create_listener("3k_dlc04_ceo_factional_trophy_cabinet_spear_inf_unique", 1,
		"CampaignBattleLoggedEvent",
		function(context) 
			local log_entry = context:log_entry();
			return self:was_my_faction_leader_winner_in_battle(log_entry);
		end);

end;



--[[
*****************************************************************
HELPERS
*****************************************************************
]]--



function lc_faction_ceos:was_my_faction(query_faction)
	return query_faction:name() == self.faction_key;
end;

function lc_faction_ceos:was_my_faction_leader_winner_in_battle(log_entry)
	for i = 0, log_entry:winning_characters():num_items() - 1 do
		local character = log_entry:winning_characters():item_at(i):character();
		if character:is_faction_leader() 
			and self:was_my_faction(character:faction())	
			and character:has_military_force() 
			and character:military_force():general_character():command_queue_index() == character:command_queue_index() 
		then
			return true;
		end;
	end;

	return false;
end;

function lc_faction_ceos:did_my_faction_leader_win_a_duel(log_entry)
	for i = 0, log_entry:duels():num_items() - 1 do
		local duel = log_entry:duels():item_at(i);
		if duel:has_winner() then
			local character = duel:winner();
			if character:is_faction_leader() and self:was_my_faction(character:faction()) then
				return true;
			end;
		end;
	end;

	return false;
end;

-- Attempts to add points to a CEO, returns false if it failed and true if it succeded.
function lc_faction_ceos:add_points(ceo_key, points)
	local locked_ceo_key = ceo_key .. self.locked_ceo_suffix;

	if not is_string(ceo_key) then
		script_error("lc_faction_ceos:add_points() ceo_key must be a string.");
		return false;
	end;

	if not is_number(points) then
		script_error("lc_faction_ceos:add_points() points must be a number.");
		return false;
	end;

	local modify_faction = cm:modify_faction(self.faction_key);

	if not modify_faction or modify_faction:is_null_interface() then
		script_error("lc_faction_ceos:add_points() Unable to get modify faction.");
		return false;
	end;

	local modify_ceo_mgmt = modify_faction:ceo_management();
	local query_ceo_mgmt = modify_ceo_mgmt:query_faction_ceo_management();

	-- Make sure we got a CEO interface
	if not modify_ceo_mgmt or modify_ceo_mgmt:is_null_interface() then
		script_error("lc_faction_ceos:add_points() No CEO Management interface.");
		return false;
	end;

	-- if 'real' ceo exists, exit.
	if ancillaries:faction_has_ceo_key(query_ceo_mgmt, ceo_key, self.category_key) then
		return false;
	end;

	local locked_ceo = ancillaries:faction_get_ceo(query_ceo_mgmt, locked_ceo_key, self.category_key);

	if not locked_ceo or locked_ceo:is_null_interface() then
		return false;
	end;
	-- if 'locked' ceo is at max, remove locked ceo and add real CEO.
	if locked_ceo:num_points_in_ceo() + points >= locked_ceo:max_points_in_ceo() then
		modify_ceo_mgmt:add_ceo(ceo_key);
		modify_ceo_mgmt:remove_ceos(locked_ceo_key);
		self:print("***LIU CHONG CEOS*** Unlocking [" .. ceo_key .. "]");

	else -- add points to the locked CEO.
		modify_ceo_mgmt:change_points_of_ceos(locked_ceo_key, points);
		self:print("***LIU CHONG CEOS*** Adding points to [" .. locked_ceo_key .. "]");
	end;
	
	
	return true;
end;

function lc_faction_ceos:create_listener(ceo_key, points_change, event, callback)
	if not is_string(event) then
		script_error("lc_faction_ceos:create_listener() event is NOT a string.");
		return false;
	end;

	if not is_function(callback) and not is_boolean(callback) then
		script_error("lc_faction_ceos:create_listener() callback is NOT a function or a boolean.");
		return false;
	end;

	if not is_string(ceo_key) then
		script_error("lc_faction_ceos:create_listener() ceo_key is NOT a string.");
		return false;
	end;

	if not is_number(points_change) and not is_function(points_change) then
		script_error("lc_faction_ceos:create_listener() points_change is NOT a number or a function.");
		return false;
	end;

	if is_function(callback) then
		-- If our callback is a function then use this.

		core:add_listener(
			self.listener_name, -- Unique handle
			event, -- Campaign Event to listen for
			callback,
			function(context) -- What to do if listener fires.
				if is_function(points_change) then
					local value = points_change();
					self:add_points(ceo_key, value);
				else
					self:add_points(ceo_key, points_change);
				end;
			end,
			true --Is persistent
		);
	else
		-- If our callback was just a boolean use this.

		core:add_listener(
			self.listener_name, -- Unique handle
			event, -- Campaign Event to listen for
			callback,
			function(context) -- What to do if listener fires.
				if is_function(points_change) then
					local value = points_change();
					self:add_points(ceo_key, value);
				else
					self:add_points(ceo_key, points_change);
				end;
			end,
			true --Is persistent
		);
	end;
end;

--GET LIU CHONG CEO BASED ON STRING
function lc_faction_ceos:get_liu_chong_ceo_from_string(ceo_key)	
	local modify_faction = cm:modify_faction(self.faction_key);
	local liu_chong_ceos = modify_faction:ceo_management():query_faction_ceo_management():all_ceos_for_category(self.category_key)
	for i = 0, liu_chong_ceos:num_items() - 1 do
		local ceo = liu_chong_ceos:item_at(i)
			if(ceo:ceo_data_key()==ceo_key) then
				return ceo;
			end		 
	end
	return nil
end

-- Function to print to the console. Wrapps up functionality to there is a singular point.
function lc_faction_ceos:print(string)
	out.design(self.system_id .. string);
end;

---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------
----- Name:			3k_campaign_emperor_manager.lua 
----- Description: 	This script causes player dilemma choices to move, or remove, the Emperor World Power Token
---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------

-- Early exit if we're in eight princes.
if cm.name == "ep_eight_princes" then
	output("campaign_emperor_manager: Not loaded in this campaign." );
	return;
end;

cm:add_first_tick_callback(function() campaign_emperor_manager:initialise() end); --Self register function

---------------------------------------------------------
--------------------VARIABLES----------------------------
---------------------------------------------------------

campaign_emperor_manager = {}

campaign_emperor_manager.humans_intialised = false -- Used for adding the initial data setup to the human factions
campaign_emperor_manager.emperor_dead = false -- Tells the progression script whether or not to spawn the emperor as a character
campaign_emperor_manager.dynamic_variables = {} -- Tracks the emperor decisions and the turns since a player declared themselves as regent
campaign_emperor_manager.emperor_token_key = "emperor";
campaign_emperor_manager.turns_before_emperor_flag = 15;
campaign_emperor_manager.turns_before_first_event = 5;
local imperial_favour_base_value = 50 -- Deducted from imperial favour to work out score multiplier. 50 is recommended value
local emperor_flee_favour_threshold = 16 -- The threshold below which the emperor will want to run away

---------------------------------------------------------
--------------------LISTENERS----------------------------
---------------------------------------------------------

function campaign_emperor_manager:initialise()
	output("campaign_emperor_manager:initialise()");

  
  	--Make sure the query data is setup for human factions
	if self.humans_intialised == false then
		for i=0, cm:query_model():world():faction_list():num_items() - 1 do
			local faction = cm:query_model():world():faction_list():item_at(i);
			if faction:is_human() then
				self.dynamic_variables[faction:name()] = {}
				self.dynamic_variables[faction:name()]["emperor_flag"] = 0 -- Tracks the state of the emperor. 0 = no emperor, 1 = emperor fled to faction, 2 = regent, 3 = emperor token removed
				self.dynamic_variables[faction:name()]["turns_as_regent"] = (self.turns_before_emperor_flag - self.turns_before_first_event) -- Sets the delay for the first event after capturing the emperor
			end;
		end
		self.humans_intialised = true;
	end

	-- Listen for the emperor dilemmas and resolve the scripted effects of them
	core:add_listener(
		"DilemmaChoiceMadeEventEmperorChoiceMade",
		"DilemmaChoiceMadeEvent",
		function(context)
			return context:dilemma() == "3k_main_dilemma_regent" or context:dilemma() == "3k_main_dilemma_fate_of_emperor"
		end,
		function(context)
			local faction = context:faction()
			if context:choice() == 0 then
				-- 流放皇帝
				self.dynamic_variables[faction:name()]["emperor_flag"] = 3
				self:remove_token(faction, self.emperor_token_key)
			elseif context:choice() == 1 then
				-- 继续担任丞相
				self.dynamic_variables[faction:name()]["turns_as_regent"] = 0
				self.dynamic_variables[faction:name()]["emperor_flag"] = 2
			elseif context:choice() == 2 then
				-- 禅让
				self.dynamic_variables[faction:name()]["emperor_flag"] = 3
				self:remove_token(faction, self.emperor_token_key)
			elseif context:choice() == 3 then
				-- 弑君
				self.dynamic_variables[faction:name()]["emperor_flag"] = 3
				self.emperor_dead = true
				self:remove_token(faction, self.emperor_token_key);
			end        
		end,
		true
	);
	-- Check who has the emperor token. If it's a Han player: check whether they've owned it long enough to fire an event or increment the turns counter if not
	core:add_listener(
		"FactionTurnStartEmperorManagerPlayerChecks",
		"FactionTurnStart",
		function(context)
			return context:faction():is_human() and context:faction():subculture() == "3k_main_chinese"
		end,
		function(context)
			local faction_key = context:faction():name();
			
			if cm:is_world_power_token_owned_by("emperor", faction_key) then
				if self.dynamic_variables[faction_key]["emperor_flag"] ~= 3 then
					-- Increment the turns as regent counter
					self.dynamic_variables[faction_key]["turns_as_regent"] = self.dynamic_variables[faction_key]["turns_as_regent"] + 1
					if self.dynamic_variables[faction_key]["turns_as_regent"] >= self.turns_before_emperor_flag then
						-- Calculate whether the emperor is going to stay or leave
						local emperor_faction = context:faction()
						if self:imperial_favour_value(emperor_faction) < emperor_flee_favour_threshold then
							local emperor_modifier = self:calculate_emperor_bonus(context:faction())
							emperor_faction = self:find_best_faction_for_emperor(context:faction(), emperor_modifier)
						end
						if emperor_faction == context:faction() then
						-- Emperor is staying, fire a dilemma
							if self.dynamic_variables[faction_key]["emperor_flag"] == 2 then
								cm:trigger_dilemma(faction_key, "3k_main_dilemma_regent", true)
							else
								cm:trigger_dilemma(faction_key, "3k_main_dilemma_fate_of_emperor", true)
							end
						else
						-- EMPEROR IS RUNNING AWAY!
							output("Campaign emperor manager: sending the emperor to "..emperor_faction:name())
							self:transfer_token_to_faction(emperor_faction, context:faction(), self.emperor_token_key)
						end
					end
				end
			else 
				-- Human faction doesn't own the emperor token, so reset any script flags
				if not self.dynamic_variables[faction_key] then
					return false;
				end;
				self.dynamic_variables[faction_key]["turns_as_regent"] = (self.turns_before_emperor_flag - self.turns_before_first_event);
				self.dynamic_variables[faction_key]["emperor_flag"] = 0;
				-- Remove the emperor world power token bundle in case it's lingering from an event
				self:remove_bundle(faction_key)
			end
		end,
		true
	);
	
    core:add_listener(
        "emperor_join_event",
        "CharacterLeavesFaction",
        function(context) 
            return context:query_character():generation_template_key() == "3k_dlc04_template_historical_emperor_xian_earth";
        end,
        function (context)
            self:transfer_token_to_faction(context:new_faction(), context:old_faction(), self.emperor_token_key)
            -- self.dynamic_variables[context:query_character():faction():name()]["emperor_flag"] = 3
            -- self:remove_token(context:query_character():faction(), self.emperor_token_key)
        end,   
        false
    )

	-- Listen for the emperor holding faction having low imperial favour, trigger emperor fleeing if this is the case.
	core:add_listener(
		"FactionTurnStartImperialFavourEmperorFlees",
		"FactionTurnStart",
		function(context)
			if cm:query_model():calendar_year() >= 197 then
				local emperor_owner = cm:get_world_power_token_owner("emperor")

				if not emperor_owner:is_null_interface() -- check to see if a faction holds the emperor token
				and context:faction() == emperor_owner then  -- Only update on the emperor's turn to prevent spamming
					-- Check if faction is not chinese, a vassal, EotH, or has low favour. In all cases it opens the change for the emperor to flee
					local subculture = (emperor_owner:subculture() ~= "3k_main_chinese")
					local vassal = diplomacy_manager:is_vassal(emperor_owner)
					local eoth = (not emperor_owner:factions_we_have_specified_diplomatic_deal_with_directional("dummy_treaty_components_enemy_of_the_han_indefinite",false):is_empty())
					local favour = self:imperial_favour_value(emperor_owner) < emperor_flee_favour_threshold 
					
					return subculture or vassal or eoth or favour;
				end
			end
		end,
		function(context)
			-- Calculate which faction the emperor would move to.
			local emperor_modifier = self:calculate_emperor_bonus(context:faction())
			local emperor_faction = self:find_best_faction_for_emperor(context:faction(), emperor_modifier)
			-- If emperor would prefer to move to another faction then..
			if emperor_faction ~= context:faction() then
				-- EMPEROR IS RUNNING AWAY!
				output("Campaign emperor manager: sending the emperor to "..emperor_faction:name())
				self:transfer_token_to_faction(emperor_faction, context:faction(), self.emperor_token_key)
			end	
		end,
		true
	);

end; -- ends initialisation of emperor_manager

---------------------------------------------------------
--------------------FUNCTIONS----------------------------
---------------------------------------------------------

-- Remove the Emperor token from the campaign
function campaign_emperor_manager:remove_token(faction, token)
	
	-- Remove the token
	cm:modify_model():get_modify_world():get_modify_world_power_tokens(cm:modify_model():get_modify_world():query_world():world_power_tokens()):remove(token, cm:modify_faction(faction))
	
 	-- Remove the emperor world power token bundle in case it's lingering from an event
	self:remove_bundle(faction:name())
	
end

 -- Removes the emperor world power token effect bundle
function campaign_emperor_manager:remove_bundle(faction_key)
	
	cm:remove_effect_bundle("3k_main_bundle_world_power_emperor", faction_key)
	
end

-- Defines the context and usage of calling for a factions imperial favour level. This will help to define where the emperor flees to.
function campaign_emperor_manager:imperial_favour_value(faction) -- define the context for imperial favour check, so it doesn't break.

	if cm:query_model():calendar_year() < 197 then
		-- Imperial favour isn't enabled before 197 so we should return the default value
		return imperial_favour_base_value
	end

	if faction:is_null_interface() then
		output("Imperial Favour Value cannot be found, [" .. tostring(faction) .. "] query interface is null")
		return imperial_favour_base_value
	end

	local imperial_favour = faction:pooled_resources():resource("3k_dlc07_pooled_resource_imperial_favour") -- create local key to search for an imperial favour value

	if imperial_favour:is_null_interface() then -- checks to see if the faction uses imperial favour resource
		output("Imperial favour is null interface")
		return imperial_favour_base_value
	end

	return imperial_favour:value()
		
end

-- Transfer the emperor token to the new faction, and remove any lingering effect bundle from the old one
-- Supports faction key, query interface, or modify interface for new_faction and old_faction.
function campaign_emperor_manager:transfer_token_to_faction(new_faction, old_faction, token)

	local new_faction_query_interface = nil
	local old_faction_query_interface = nil
	
	-- Check what new_faction is, and set new_faction_query_interface to that faction's query interface (if possible)
	if is_query_faction(new_faction) then
		new_faction_query_interface = new_faction
	elseif is_modify_faction(new_faction) then
		new_faction_query_interface = new_faction:query_faction()
	elseif is_string(new_faction) and not cm:query_faction(new_faction):is_null_interface() then
		new_faction_query_interface = cm:query_faction(new_faction)
	else
		script_error("ERROR: campaign_emperor_manager:transfer_token_to_faction - supplied new_faction is not a faction key, query interface, or modify interface.");
		return false;
	end;
	
	-- Check what old_faction is, and set old_faction_query_interface to that faction's query interface (if possible)
	if is_query_faction(old_faction) then
		old_faction_query_interface = old_faction
	elseif is_modify_faction(old_faction) then
		old_faction_query_interface = old_faction:query_faction()
	elseif is_string(old_faction) and not cm:query_faction(old_faction):is_null_interface() then
		old_faction_query_interface = cm:query_faction(old_faction)
	else
		script_error("ERROR: campaign_emperor_manager:transfer_token_to_faction - supplied old_faction is not a faction key, query interface, or modify interface.");
		return false;
	end;
 
	-- 检查我们是否试图将皇帝转交给已经拥有他的派别。
	if cm:is_world_power_token_owned_by("emperor", new_faction_query_interface:name()) then
		return false;
	end
	
	cm:modify_model():get_modify_world():get_modify_world_power_tokens(cm:modify_model():get_modify_world():query_world():world_power_tokens()):transfer(token, cm:modify_faction(new_faction_query_interface))
	cm:remove_effect_bundle("3k_main_bundle_world_power_emperor", old_faction_query_interface:name()) 	-- Remove the emperor world power token bundle in case it's lingering from an event
	
	if old_faction_query_interface:is_human() then
		self.dynamic_variables[old_faction_query_interface:name()]["emperor_flag"] = 0
		
		if(old_faction_query_interface:subculture() == "3k_main_chinese") then
			cm:modify_faction(old_faction_query_interface:name()):trigger_incident("3k_main_incident_emperor_flees_from_faction", true)
		end
	end
	if new_faction_query_interface:is_human() then
		self.dynamic_variables[new_faction_query_interface:name()]["emperor_flag"] = 1
		cm:modify_faction(new_faction_query_interface:name()):trigger_incident("3k_main_incident_emperor_flees_to_faction", true)
	end
		
end

-- 为皇帝找一个可以逃跑的目的地。倾向于强大的派系，可玩派系占一定比重，并在 mpc 中为对方玩家提供奖励
function campaign_emperor_manager:find_best_faction_for_emperor(owning_faction, modifier) 

	output(" find_best_faction_for_emperor")
	local transfer_faction = owning_faction;
	local highest_score = nil;
	local emperor_owner = cm:get_world_power_token_owner("emperor")	
	
	-- 遍历派系列表，找出皇帝的最佳人选。
	for i=0, cm:query_model():world():faction_list():num_items() - 1 do
		local faction = cm:query_model():world():faction_list():item_at(i);
		local faction_score = 0;

		-- 只看还活着的汉文化派系，除了汉帝国/何太后。屏蔽目前被列为汉贼目标的派系或附庸
		if faction:is_dead() == false and faction:subculture() == "3k_main_chinese" and faction:name() ~= "3k_main_faction_han_empire" and faction:name() ~= "3k_dlc04_faction_empress_he" and faction:name() ~= "3k_dlc04_faction_rebels" and not faction:is_rebel() and not diplomacy_manager:is_vassal(faction) and faction:factions_we_have_specified_diplomatic_deal_with_directional("dummy_treaty_components_enemy_of_the_han_indefinite",false):is_empty() then
			
			-- 如果是多人游戏，优先选择其他玩家
			if faction:is_human() and owning_faction:is_human() and faction ~= owning_faction then
				-- 如果有共同目标，则大幅减少权重，如果没有，则增加权重
				if faction:has_specified_diplomatic_deal_with("treaty_components_multiplayer_victory", owning_faction) then
					faction_score = faction_score - 150
				else  
					faction_score = faction_score + 30
				end
			end
				
			-- 首选与玩家交战的派系
			if faction ~= owning_faction and faction:has_specified_diplomatic_deal_with("treaty_components_war", owning_faction) then
				faction_score = faction_score + 15
			end;  
			
			 -- 首选一个主要的/可玩的汉文化派系
			if faction:name() == "3k_main_faction_cao_cao" or faction:name() == "3k_main_faction_liu_bei" or faction:name() == "3k_main_faction_sun_jian" or faction:name() == "3k_dlc05_faction_sun_ce" then
				faction_score = faction_score + 25
			end;

			 -- 不太重要的可玩汉朝派系提供较少权重
			if faction:name() == "3k_dlc04_faction_prince_liu_chong" or faction:name() == "3k_main_faction_yuan_shao" or faction:name() == "3k_main_faction_liu_biao" or faction:name() == "3k_main_faction_kong_rong" or faction:name() == "3k_main_faction_ma_teng" or faction:name() == "3k_main_faction_gongsun_zan" then
				faction_score = faction_score + 10
			end;
			
			 -- 让袁术减少更多的权重
			if faction:name() == "3k_main_faction_yuan_shu" then
				faction_score = faction_score - 50
			end;

			-- 根据天子宠信（0-100 之间）给予奖励或负值
            faction_score = faction_score + ((self:imperial_favour_value(faction) - imperial_favour_base_value)*2); -- bonus for imperial favour between -100 to +100 faction score which rises as the pooled resource does.		

			-- Prefer factions with lots of regions
			faction_score = faction_score + (faction:region_list():num_items());
			
			-- Prefer factions with higher progression level
			faction_score = faction_score + (faction:progression_level()*3);

			-- Add the modifier passed to the function
			if faction == owning_faction then
				faction_score = faction_score + modifier;
			end

			output("campaign_emperor_manager: Final score for "..faction:name().." is "..faction_score);
			-- Set this faction as the candidate if they're the current highest score
			if highest_score == nil or faction_score > highest_score then
				transfer_faction = faction;
				highest_score = faction_score
			end;
		end;
	end;
	
	-- Return the faction that the Emperor is going to be in
	output("campaign_emperor_manager: transfer_faction is "..transfer_faction:name());
	return transfer_faction
	
end

-- Used to calculate a bonus/penalty for the current owner of the Emperor token. Might be best to not rush the Emperor when you're a one region minor...
function campaign_emperor_manager:calculate_emperor_bonus(faction)
	local bonus = 0

	-- Give a bonus if the emperor just fled here or the faction is the regent
	local faction_name = faction:name();
	if self.dynamic_variables[faction_name] then
		if self.dynamic_variables[faction_name]["emperor_flag"] == 1 then
			-- Emperor fled here
			bonus = bonus + 150;
		elseif self.dynamic_variables[faction_name]["emperor_flag"] == 2 then
			-- Faction is the regent
			bonus = bonus + 80;
		end
	end
 
	--- Dong Zhuo's faction will get a bonus to keeping the emperor that gets drastically reduced once he's dead
	if faction_name == "3k_main_faction_dong_zhuo" then
		if faction:faction_leader():generation_template_key() == "3k_main_template_historical_dong_zhuo_hero_fire" then
			bonus = bonus + 150
		else
			bonus = bonus + 100
		end
	end

	-- Give a huge penalty for tiny factions
	if faction:region_list():num_items() <= 1 then
		bonus = bonus - 150;
	elseif faction:region_list():num_items() <= 3 then
		bonus = bonus - 25;
	elseif faction:region_list():num_items() <= 5 then
		bonus = bonus - 15;
	end

	output("campaign_emperor_manager: Bonus score for "..faction:name().." is "..bonus);
  
	return bonus
    
end

---------------------------------------------------------
--------------------SAVE/LOAD----------------------------
---------------------------------------------------------

function campaign_emperor_manager:register_save_load_callbacks()

	cm:add_saving_game_callback(
		function(saving_game_event)
			cm:save_named_value("campaign_emperor_manager_dynamic_variables", self.dynamic_variables);
			cm:save_named_value("campaign_emperor_manager_humans_intialised", self.humans_intialised);
		end
	);

	cm:add_loading_game_callback(
		function(loading_game_event)
			self.dynamic_variables = cm:load_named_value("campaign_emperor_manager_dynamic_variables", self.dynamic_variables);
			self.humans_intialised = cm:load_named_value("campaign_emperor_manager_humans_intialised", self.humans_intialised);
		end
	);

end;

campaign_emperor_manager:register_save_load_callbacks();
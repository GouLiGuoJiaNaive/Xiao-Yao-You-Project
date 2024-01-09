---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------
----- Name:			DLC05 GLOBAL EVENTS
----- Description: 	DLC05
-----				Fires and manages events which affect the world as a whole.
-----
---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- MAIN
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
dlc05_global_events = {};

dlc05_global_events.lu_bu_turns_until_first_incident = 3 --- after this many turns in Liu Bei's faction, Lu Bu will rebel (if Liu Bei is AI) or suffer a satisfaction penalty (if player)
dlc05_global_events.lu_bu_turns_until_second_incident = 6 --- after this many turns in Liu Bei's faction, Lu Bu will rebel for the player if their satisfaction is <50



function dlc05_global_events:initialise()
	output("\n\n\n initialising global events\n\n\n")

	self:emperor_flees_events();
	self:lu_bu_taken_in_events();
	self:yuan_shu_and_sun_ce_events();
	self:yuan_shao_kong_rong_events();
	self:register_lu_bu_emergent_faction();
	self:yuan_shu_crushed_events();
	self:sun_ce_gathering_characters_and_life();
	self:lu_bu_cao_cao_ai_war_manager();
	self:liu_bei_income_modifier();
end;

-- Global Events
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- GLOBAL EVENTS
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

----------LU BU EMERGENT FACTION------

function dlc05_global_events:register_lu_bu_emergent_faction() --- create a lu bu emergent faction that will fire when certain conditions are met
	local lu_bu_emergent_faction = emergent_faction:new("lu_bu_emergent_faction", "3k_main_faction_lu_bu", "3k_dlc06_xiapi_capital", false)
	lu_bu_emergent_faction:add_faction_leader("3k_main_template_historical_lu_bu_hero_fire", "3k_general_fire", true);
	lu_bu_emergent_faction:add_spawn_dates(194, 200);
	lu_bu_emergent_faction:add_spawn_condition(
		function()
			local lu_bu = cm:query_model():character_for_template("3k_main_template_historical_lu_bu_hero_fire")
			local turns_with_liu_bei = cm:turn_number() - cm:get_saved_value("lu_bu_joined_turn")
			if cm:query_faction("3k_main_faction_lu_bu"):is_dead() and lu_bu:faction():name() == "3k_main_faction_liu_bei" then
				if  lu_bu:loyalty() == 0 then
					return true
				elseif cm:modify_faction("3k_main_faction_liu_bei"):query_faction():is_human() then
					if turns_with_liu_bei >= dlc05_global_events.lu_bu_turns_until_second_incident
					and lu_bu:loyalty() <=50 then
						return true
					end
				elseif turns_with_liu_bei >= dlc05_global_events.lu_bu_turns_until_first_incident then
					return true
				end
			end
			return false
		end);
	lu_bu_emergent_faction:add_on_spawned_callback( function()
		core:trigger_event("LuBuRebels") -- if Lu Bu successfully spawns, fire the associated global events
	end);
	emergent_faction_manager:add_emergent_faction(lu_bu_emergent_faction)
end


-----------------------THE EMPEROR ESCAPES------------------------------------------------------------------------

function dlc05_global_events:emperor_flees_events()
	local yang_feng = cm:modify_faction("3k_dlc05_faction_yang_feng")
	local luoyang = cm:modify_region("3k_main_luoyang_capital")
	local li_jue = cm:modify_faction("3k_main_faction_dong_zhuo")


	local li_jue_guo_si_conflict_begins = global_event:new("li_jue_guo_si_conflict_begins", "WorldStartOfRoundEvent",
		function() if cm:turn_number() <6 then return false else return true end
		end);
	li_jue_guo_si_conflict_begins:add_incident("3k_dlc05_historical_global_li_jue_guo_si_conflict_incident");
	li_jue_guo_si_conflict_begins:add_post_event_callback( 
		function() ---apply penalties to li jue's faction
			li_jue:apply_effect_bundle("3k_dlc05_effect_bundle_internal_conflict",-1)
		end)
	li_jue_guo_si_conflict_begins:register();


	local emperor_flees_to_luoyang = global_event:new("emperor_flees", "WorldStartOfRoundEvent",
		function()
		
			--gets the empire's master
			local emperor_master = cm:query_faction("3k_main_faction_han_empire"):factions_we_have_specified_diplomatic_deal_with("treaty_components_vassalage"):item_at(0)
			
			--wait until turn 10, and only trigger if the emperor's master is not human
			if cm:turn_number() >= 10 and not emperor_master:is_human() then  --- wait until turn 10
				return true
			end
		end)
  emperor_flees_to_luoyang:add_pre_event_callback(
    function()
      if luoyang:query_region():owning_faction():is_human() == false then
        emperor_flees_to_luoyang:add_incident("3k_dlc05_historical_global_the_emperor_escapes_incident_xun_yu"); -- variant if you have Xun Yu
        emperor_flees_to_luoyang:add_incident("3k_dlc05_historical_global_the_emperor_escapes_incident"); -- normal variant for all factions
        emperor_flees_to_luoyang:add_post_event_callback( 
          function() ---give Yang Feng Luoyang, move his capital there, and give him the emperor
            luoyang:settlement_gifted_as_if_by_payload(yang_feng)
            yang_feng:make_region_capital(luoyang:query_region())
            li_jue:apply_effect_bundle("3k_dlc05_effect_bundle_emperor_lost",-1)
			campaign_emperor_manager:transfer_token_to_faction(yang_feng:query_faction(), li_jue:query_faction(), "emperor")
          end)
      else
        emperor_flees_to_luoyang:add_dilemma("3k_dlc05_historical_global_emperor_escapes_player_owns_luoyang") -- only triggers for player who owns luoyang
        emperor_flees_to_luoyang:add_dilemma_choice_outcome("3k_dlc05_historical_global_emperor_escapes_player_owns_luoyang", 1, "EmperorLooksForProtector", 25);
        emperor_flees_to_luoyang:add_dilemma_choice_outcome("3k_dlc05_historical_global_emperor_escapes_player_owns_luoyang", 0, "PlayerTakesInEmperor", 75);
      end
    end)
	emperor_flees_to_luoyang:register();
  
  
  local player_welcomes_emperor_into_luoyang = global_event:new("player_welcomes_emperor_into_luoyang", "PlayerTakesInEmperor");
  player_welcomes_emperor_into_luoyang:add_pre_event_callback(
		function()-- Move emperor to player who owns luoyang
			local luoyang_owner = luoyang:query_region():owning_faction()
			campaign_emperor_manager:transfer_token_to_faction(luoyang_owner, li_jue:query_faction(), "emperor")
			campaign_emperor_manager.dynamic_variables[luoyang_owner:name()]["emperor_flag"] = 2
		end);
  player_welcomes_emperor_into_luoyang:register()
  
  
  local emperor_looks_for_protection = global_event:new("emperor_looks_for_protection", "WorldStartOfRoundEvent", 
   function()
	local emperor_owner_faction = cm:modify_world_power_tokens():query_world_power_tokens():owning_faction("emperor")

	  if cm:turn_number() >=12 and cm:turn_number() <=20 and not emperor_owner_faction:is_null_interface()
	  and emperor_owner_faction:name() == "3k_dlc05_faction_yang_feng"  then
        return true
      end
    end)
  emperor_looks_for_protection:add_post_event_callback(
	function()
		local cao_cao = cm:query_faction("3k_main_faction_cao_cao")
		local yuan_shao = cm:query_faction("3k_main_faction_yuan_shao")
		
		
		--if both cao cao and yuan shao are alive, perform the usual checks to see which of the 2 gets the emperor,
		if not cao_cao:is_dead() and not yuan_shao:is_dead() then

			core:trigger_event("EmperorLooksForProtector")

			--if yuan shao is still around, give him the emperor directly
		elseif cao_cao:is_dead() and yuan_shao:is_dead() == false then
				core:trigger_event("YuanShaoTookInTheEmperor")

			--if cao cao is still around, give him the emperor directly
		elseif yuan_shao:is_dead() and cao_cao:is_dead() == false then
				core:trigger_event("YuanShaoDidNotTakeInTheEmperor")
				
			--if they're both dead, leave the emperor be, the game's systems will take care of this
		end
	end); 
  emperor_looks_for_protection:register();
  
--- Emperor needs better protector - does he go to Yuan Shao or Cao Cao?
	local who_takes_in_the_emperor = global_event:new("who_takes_in_the_emperor", "EmperorLooksForProtector")
	who_takes_in_the_emperor:add_dilemma("3k_dlc05_historical_yuan_shao_emperor_dilemma") -- only for Yuan Shao
	who_takes_in_the_emperor:add_dilemma_choice_outcome("3k_dlc05_historical_yuan_shao_emperor_dilemma", 0, "YuanShaoTookInTheEmperor", 25);
	who_takes_in_the_emperor:add_dilemma_choice_outcome("3k_dlc05_historical_yuan_shao_emperor_dilemma", 1, "YuanShaoDidNotTakeInTheEmperor", 75);
	who_takes_in_the_emperor:register();

-- Yuan Shao gets the emperor
	local yuan_shao_takes_in_the_emperor = global_event:new("yuan_shao_takes_in_the_emperor", "YuanShaoTookInTheEmperor")
	yuan_shao_takes_in_the_emperor:add_post_event_callback(
		function()
			if cm:modify_faction("3k_main_faction_yuan_shao"):query_faction():is_human()== false then 
				yuan_shao_takes_in_the_emperor:add_incident("3k_dlc05_historical_global_the_emperor_escapes_to_yuan_shao_incident");
			end
			campaign_emperor_manager:transfer_token_to_faction(cm:modify_faction("3k_main_faction_yuan_shao"):query_faction(), yang_feng:query_faction(), "emperor")
			if cm:modify_faction("3k_main_faction_yuan_shao"):query_faction():is_human() then
				campaign_emperor_manager.dynamic_variables["3k_main_faction_yuan_shao"]["emperor_flag"] = 2
			end
		end);
	yuan_shao_takes_in_the_emperor:register();


-- Cao Cao gets the emperor
	local cao_cao_takes_in_the_emperor = global_event:new("cao_cao_takes_in_the_emperor", "YuanShaoDidNotTakeInTheEmperor",
    	function() if cm:modify_faction("3k_main_faction_cao_cao"):query_faction():is_human() == false then return true end
    end)
	cao_cao_takes_in_the_emperor:add_incident("3k_dlc05_historical_global_the_emperor_escapes_to_cao_cao_incident");
	cao_cao_takes_in_the_emperor:add_post_event_callback(
		function()
			-- Move emperor to Cao Cao
			campaign_emperor_manager:transfer_token_to_faction(cm:modify_faction("3k_main_faction_cao_cao"):query_faction(), yang_feng:query_faction(), "emperor")
			if cm:modify_faction("3k_main_faction_cao_cao"):query_faction():is_human() then
				campaign_emperor_manager.dynamic_variables["3k_main_faction_cao_cao"]["emperor_flag"] = 2
			end
		end);
	cao_cao_takes_in_the_emperor:register();

end;



--------------------------------------------------------------
----------------LU BU AND LIU BEI------------------------------
--------------------------------------------------------------
function dlc05_global_events:lu_bu_taken_in_events()

	if not cm:saved_value_exists("lu_bu_joined_turn") then
		cm:set_saved_value("lu_bu_joined_turn", 99999)
	end

	if not cm:saved_value_exists("liu_bei_lu_bu_death_blow") then
		cm:set_saved_value("liu_bei_lu_bu_death_blow", false)
	end

	core:add_listener(
		"dlc05_lu_bu_death_blow_monitor", -- Unique handle
		"FactionDied", -- Campaign Event to listen for
		function(context) -- Criteria
			if context:faction():name()=="3k_main_faction_lu_bu" and
			   context:killer_or_confederator_faction_key()=="3k_main_faction_liu_bei" then
		    		return true
				end
		end,
		function(context) -- What to do if listener fires.
			cm:set_saved_value("liu_bei_lu_bu_death_blow", true)
			core:remove_listener("dlc05_lu_bu_death_blow_monitor")
		end,
		true --Is persistent
		)


	-- Lu Bu looks for new master
	local lu_bu_seeks_asylum = global_event:new("lu_bu_seeks_asylum", "WorldStartOfRoundEvent",
		function () -- If Lu Bu's faction is dead but Lu Bu is alive, and Liu Bei is around, send him there
			if cm:modify_faction("3k_main_faction_lu_bu"):query_faction():is_dead()
			and not cm:modify_faction("3k_main_faction_liu_bei"):query_faction():is_dead()
			and not cm:get_saved_value("liu_bei_lu_bu_death_blow") then
				return true
			end 
		end)
	lu_bu_seeks_asylum:add_dilemma("3k_dlc05_historical_liu_bei_lu_bu_chain_01_dilemma")
	lu_bu_seeks_asylum:add_dilemma_choice_outcome("3k_dlc05_historical_liu_bei_lu_bu_chain_01_dilemma", 0, "LiuBeiTakesInLuBu", 100)
	lu_bu_seeks_asylum:add_dilemma_choice_outcome("3k_dlc05_historical_liu_bei_lu_bu_chain_01_dilemma", 1, "LiuBeiDoesNotTakeInLuBu", 0)
	lu_bu_seeks_asylum:add_fallback_callback(
		function ()
			if cm:query_faction("3k_main_faction_liu_bei"):is_human() == false then 
				core:trigger_event("LiuBeiTakesInLuBu")
				local lu_bu = cm:query_model():character_for_template("3k_main_template_historical_lu_bu_hero_fire")
				cm:modify_character(lu_bu):move_to_faction_and_make_recruited("3k_main_faction_liu_bei")
				cm:modify_character(lu_bu):add_loyalty_effect("lu_bu_ai_gratitude_to_liu_bei")
				cm:modify_character(lu_bu):add_loyalty_effect("data_lu_bu_inspire")
			end
		end
	)
	lu_bu_seeks_asylum:register()

	---Liu Bei takes in Lu Bu
	local liu_bei_takes_in_lu_bu = global_event:new("liu_bei_takes_in_lu_bu", "LiuBeiTakesInLuBu")
	liu_bei_takes_in_lu_bu:add_incident("3k_dlc05_historical_global_lu_bu_seeks_sanctuary_with_liu_bei")
	liu_bei_takes_in_lu_bu:add_post_event_callback(
		function()
			cm:set_saved_value("lu_bu_joined_turn", cm:turn_number())
			liu_bei_faction = cm:query_faction("3k_main_faction_liu_bei")
			if liu_bei_faction:is_human() == false then
				cm:modify_faction("3k_main_faction_liu_bei"):apply_effect_bundle("3k_dlc05_effect_bundle_ai_cao_cao_bonus_income",-1)
			end
		end
	)
	liu_bei_takes_in_lu_bu:register()


	local lu_bu_considers_rebellion = global_event:new("lu_bu_considers_rebellion","WorldStartOfRoundEvent",
		function()
			local current_lu_bu_turns = cm:turn_number() - cm:get_saved_value("lu_bu_joined_turn")
			if current_lu_bu_turns >= dlc05_global_events.lu_bu_turns_until_first_incident then return true end
		end)
	lu_bu_considers_rebellion:add_pre_event_callback(
		function() 
			if cm:modify_faction("3k_main_faction_liu_bei"):query_faction():is_human() then 
				lu_bu_considers_rebellion:add_incident("3k_dlc05_historical_liu_bei_lu_bu_chain_02_incident")
			end;
		end);
	lu_bu_considers_rebellion:register()


	local lu_bu_rebels = global_event:new("lu_bu_rebels","LuBuRebels")
	lu_bu_rebels:add_incident("3k_dlc05_historical_liu_bei_lu_bu_chain_03_incident") -- Liu Bei only variant
	lu_bu_rebels:add_incident("3k_dlc05_historical_global_lu_bu_betrays_liu_bei") -- global variant
	lu_bu_rebels:add_post_event_callback(
		function() 

		----if Liu Bei is AI, give Lu Bu some more regions
			if not cm:modify_faction("3k_main_faction_liu_bei"):query_faction():is_human() then
				cm:modify_faction("3k_main_faction_liu_bei"):remove_effect_bundle("3k_dlc05_effect_bundle_ai_cao_cao_bonus_income")
				local xiapi_region = cm:query_region("3k_dlc06_xiapi_capital")
				local adjacent_regions = xiapi_region:adjacent_region_list()
				for i = 0, adjacent_regions:num_items() -1 do
					local region_to_transfer = adjacent_regions:item_at(i)
					if region_to_transfer:owning_faction():name() == "3k_main_faction_liu_bei" then
						cm:modify_model():get_modify_region(region_to_transfer):settlement_gifted_as_if_by_payload(cm:modify_faction("3k_main_faction_lu_bu"))
					end
				end
			end

			--populate lu bu's faction with characters if its AI
			local lu_bu_faction = cm:query_faction("3k_main_faction_lu_bu")
			if not lu_bu_faction:is_human() then
				local general_count = 0
				--make list of characters
				local characters = {};
				table.insert(characters, cm:query_model():character_for_template("3k_main_template_historical_chen_gong_hero_water"))
				table.insert(characters, cm:query_model():character_for_template("3k_main_template_historical_zhang_liao_hero_metal"))
				table.insert(characters, cm:query_model():character_for_template("3k_dlc05_template_historical_lady_yan_hero_earth"))
				table.insert(characters, cm:query_model():character_for_template("3k_main_template_historical_hao_meng_hero_fire"))
				table.insert(characters, cm:query_model():character_for_template("3k_dlc05_template_historical_hou_cheng_hero_wood"))
				table.insert(characters, cm:query_model():character_for_template("3k_main_template_historical_gao_shun_hero_fire"))

				-- Only spawn some characters in romance.
				if cm:query_model():campaign_game_mode() == "romance" then
					table.insert(characters, cm:query_model():character_for_template("3k_main_template_historical_lady_diao_chan_hero_water"))
				end;

				for i, character in ipairs(characters) do
					if character ~= nil and not character:is_null_interface() then
						if character:is_character_is_faction_recruitment_pool() then
							cm:modify_character(character):move_to_faction_and_make_recruited(lu_bu_faction:name())
							general_count = general_count + 1
						end
					end
				end

				if general_count < 5 then
					for i = 1, 5 - general_count do
						cm:modify_faction(lu_bu_faction):create_character_with_gender("general", true)
					end

				end


				cm:modify_faction(lu_bu_faction):apply_effect_bundle("3k_dlc05_introduction_mission_bundle_lu_bu",10)
			end
		end
	)
	lu_bu_rebels:register()

end

-------------------------------------------------
------------YUAN SHU AND SUN CE------------------
-------------------------------------------------

function dlc05_global_events:yuan_shu_and_sun_ce_events()
	local yuan_shu_faction = cm:modify_faction("3k_main_faction_yuan_shu")
	local sun_ce_faction = cm:modify_faction("3k_dlc05_faction_sun_ce")
	local imperial_seal = "3k_main_ancillary_accessory_imperial_jade_seal"


	if not cm:query_model():character_for_template("3k_main_template_historical_lu_kang_hero_water"):is_dead() then
		core:add_listener(
			"dlc05_lu_kang_death_monitor", -- Unique handle
			"WorldStartOfRoundEvent", -- Campaign Event to listen for
			function(context) -- Criteria
				--if its past turn 2, lu kang is alive, and someone other than lu kang owns his initial settlement, then...
				if cm:turn_number()>=2 and not cm:query_model():character_for_template("3k_main_template_historical_lu_kang_hero_water"):is_dead() and
				cm:query_model():world():region_manager():region_by_key("3k_main_lujiang_capital"):owning_faction():name() ~= "3k_dlc04_faction_lu_kang" then
					return true
				end

				if cm:query_model():character_for_template("3k_main_template_historical_lu_kang_hero_water"):is_dead() then
					core:remove_listener("dlc05_lu_kang_death_monitor")
					return false
				end
			end,
			function(context) -- What to do if listener fires.
				--kill lu kang, destroy this listener
				local lu_kang = cm:query_model():character_for_template("3k_main_template_historical_lu_kang_hero_water")
				cm:modify_character(lu_kang):kill_character(true)
				core:remove_listener("dlc05_lu_kang_death_monitor")
			end,
			true --Is persistent
			)
	end

	local yuan_shu_asks_for_the_imperial_seal = global_event:new("yuan_shu_asks_for_the_imperial_seal", "WorldStartOfRoundEvent",
		function() 
			if cm:turn_number() <2 then return false 
			else  return true end
		end);
	yuan_shu_asks_for_the_imperial_seal:add_dilemma("3k_dlc05_historical_yuan_shu_sun_ce_dilemma")
	yuan_shu_asks_for_the_imperial_seal:add_dilemma("3k_dlc05_historical_sun_ce_imperial_seal_dilemma")
	yuan_shu_asks_for_the_imperial_seal:add_post_event_callback(
		function ()

			if sun_ce_faction:query_faction():is_human() == false
			and yuan_shu_faction:query_faction():is_human() == false then
				sun_ce_faction:ceo_management():remove_ceos(imperial_seal)
				yuan_shu_faction:ceo_management():add_ceo(imperial_seal)
				
			end
			
		end
	)
	yuan_shu_asks_for_the_imperial_seal:register()


	local yuan_shu_declares_himself_emperor = global_event:new("yuan_shu_declares_himself_emperor", "WorldStartOfRoundEvent",
		function()
			if yuan_shu_faction:query_faction():pooled_resources():resource("3k_main_pooled_resource_legitimacy"):value() >= 349 then
			return true
			end
		end
	)
	yuan_shu_declares_himself_emperor:add_dilemma("3k_dlc04_historical_yuan_shu_yuan_shu_emperor_dilemma")
	yuan_shu_declares_himself_emperor:add_dilemma("3k_dlc05_historical_sun_ce_yuan_shu_declares_himself_emperor_dilemma")
	yuan_shu_declares_himself_emperor:add_post_event_callback(
		function()

			global_events_manager:set_flag("YuanShuDeclaresEmperorship", true)

			if sun_ce_faction:query_faction():is_human() == false and sun_ce_faction:query_faction():has_specified_diplomatic_deal_with("treaty_components_vassalage",yuan_shu_faction:query_faction()) then
				diplomacy_manager:apply_automatic_deal_between_factions("3k_dlc05_faction_sun_ce","3k_main_faction_yuan_shu", "data_defined_situation_vassal_declares_independence")
			end
			if cm:query_faction("3k_dlc05_faction_wu_jing"):has_specified_diplomatic_deal_with("treaty_components_vassalage",yuan_shu_faction:query_faction()) then
				diplomacy_manager:apply_automatic_deal_between_factions("3k_dlc05_faction_wu_jing","3k_main_faction_yuan_shu", "data_defined_situation_vassal_declares_independence")
			end

			--depending on whether the Han empire is alive or dead, trigger one or another version of the event
			if cm:query_faction("3k_main_faction_han_empire"):is_dead() then
				yuan_shu_declares_himself_emperor:add_incident("3k_dlc04_historical_global_yuan_shu_emperor_incident_no_han")
			else
				yuan_shu_declares_himself_emperor:add_incident("3k_dlc04_historical_global_yuan_shu_emperor_incident")
			end
		end
	)
	yuan_shu_declares_himself_emperor:register()
	

end

function dlc05_global_events:yuan_shao_kong_rong_events()

	--yuan shao gifts taishan to yuan tan - the region just next to kong rong
	local yuan_shao_gives_province_to_yuan_tan = global_event:new("yuan_shao_gives_province_to_yuan_tan", "WorldStartOfRoundEvent",
	function ()
		local taishan_region = cm:query_region("3k_main_taishan_capital")
		if taishan_region:owning_faction():name() == "3k_main_faction_yuan_shao" and cm:query_faction("3k_main_faction_yuan_shao"):is_human() == false then
			return true
		end
	end
	)yuan_shao_gives_province_to_yuan_tan:add_post_event_callback(
		function ()
			local taishan_region = cm:query_region("3k_main_taishan_capital")
			cm:modify_model():get_modify_region(taishan_region):settlement_gifted_as_if_by_payload(cm:modify_faction("3k_dlc05_faction_yuan_tan"))
		end
	)
	yuan_shao_gives_province_to_yuan_tan:register()

	--Kong Rong fights yuan shao
	local kong_rong_surrenders_to_yuan_shao = global_event:new("kong_rong_surrenders_to_yuan_shao", "WorldStartOfRoundEvent",
	function ()
		local kong_rong = cm:query_faction("3k_main_faction_kong_rong")
		if kong_rong:is_human() == false and kong_rong:region_list():num_items() <= 4 and cm:turn_number()>=5 then
			return true
		end
	end
	)
	kong_rong_surrenders_to_yuan_shao:add_incident("3k_dlc05_historical_global_kong_rong_surrenders_to_yuan_shao")
	kong_rong_surrenders_to_yuan_shao:add_dilemma("3k_dlc05_faction_liu_bei_help_kong_rong_fight_yuan_shao")
	kong_rong_surrenders_to_yuan_shao:register()
end

--The crusade against Yuan Shu for when he declares himself emperor
function dlc05_global_events:yuan_shu_crushed_events()

	local emperor_crushes_yuan_shu = global_event:new("emperor_crushes_yuan_shu", "WorldStartOfRoundEvent",
	function ()
		return global_events_manager:get_flag("YuanShuDeclaresEmperorship")
	end
	)

	emperor_crushes_yuan_shu:add_mission("3k_dlc05_global_event_capture_yuan_shu_regions", function() return true end, "YuanShuCrushed", "YuanShuCrushedNotFired")
	emperor_crushes_yuan_shu:register()


	local yuan_shu_mission_complete = global_event:new("yuan_shu_mission_complete", "YuanShuCrushed")

	local yuan_shu_mission_canceled = global_event:new("yuan_shu_mission_canceled", "YuanShuCrushedNotFired")
end

-------------------------------------------------
------------SUN CE CHARACTERS AND LIFE-----------
-------------------------------------------------
function dlc05_global_events:sun_ce_gathering_characters_and_life()
--If Sun Ce is AI, make his famous characters join him regardless, reduce his reckless luck and kill him at a certain turn
core:add_listener(
	"FactionTurnStartSunCeAI",
	"FactionTurnStart",		
	function(context)
		if context:faction():name()=="3k_dlc05_faction_sun_ce" then 
			return (not context:faction():is_human() or context:query_model():is_multiplayer())
		end
		return false
	end,
	function(context)
		local turn_number = context:query_model():turn_number()
		--CHARACTERS && ITEMS
		if turn_number == 1 then
			--Set the turn_number for when Sun Ce is supose to die. Randomness ensures small variaty between playthoughs.
			if not context:faction():is_human() then
				cm:set_saved_value("SunCeLifeSpawn", 35+cm:random_number(0,4),"SunCeAILife")
			else
				cm:set_saved_value("SunCeLifeSpawn", -1,"SunCeAILife")
			end
			
			--Ensure that Yuan Shu starts with the imperial seal 
			--If Yuan Shu isn't human, then give Sun Ce his fathers generals.
			if not cm:query_faction("3k_main_faction_yuan_shu"):is_human() then
				--MOVE HUANG GAI TO SUN CE's FACTION
				local characterToFind = context:query_model():character_for_template("3k_cp01_template_historical_huang_gai_hero_fire")
				if not characterToFind:faction():is_human() then
					move_character_to_court(characterToFind,"3k_dlc05_faction_sun_ce",context:modify_model())
				end					
				--MOVE CHENG PU TO SUN CE's FACTION
				characterToFind = context:query_model():character_for_template("3k_main_template_historical_cheng_pu_hero_metal")
				if not characterToFind:faction():is_human() then
					move_character_to_court(characterToFind,"3k_dlc05_faction_sun_ce",context:modify_model())
				end
				--MOVE HAN DANG TO SUN CE's FACTION
				characterToFind = context:query_model():character_for_template("3k_main_template_historical_han_dang_hero_fire")
				if not characterToFind:faction():is_human() then
					move_character_to_court(characterToFind,"3k_dlc05_faction_sun_ce",context:modify_model())
				end
			end
		elseif turn_number == 3 then
			local characterToFind = context:query_model():character_for_template("3k_main_template_historical_zhou_yu_hero_water")
			--MOVE ZHOU YU TO SUN CE's FACTION
			if not characterToFind:is_null_interface() then
				if not characterToFind:faction():is_human() then
					move_character_to_court(characterToFind,"3k_dlc05_faction_sun_ce",context:modify_model())
				end
			end
		elseif turn_number == 5 then
			local characterToFind = context:query_model():character_for_template("3k_main_template_historical_lu_fan_hero_water")
			--MOVE LU FAN TO SUN CE's FACTION
			if not characterToFind:is_null_interface() then
				if not characterToFind:faction():is_human() then
					move_character_to_court(characterToFind,"3k_dlc05_faction_sun_ce",context:modify_model())
				end
			end
		elseif turn_number == 10 then
			--MOVE ZHANG HONG TO SUN CE's FACTION
			local characterToFind = context:query_model():character_for_template("3k_main_template_historical_zhang_hong_hero_water")
			if not characterToFind:is_null_interface() then
				if not characterToFind:faction():is_human() then
					move_character_to_court(characterToFind,"3k_dlc05_faction_sun_ce",context:modify_model())
				end
			end
			--MOVE ZHANG ZHAO TO SUN CE's FACTION
			characterToFind = context:query_model():character_for_template("3k_main_template_historical_zhang_zhao_hero_water")
			if not characterToFind:is_null_interface() then
				if not characterToFind:faction():is_human() then
					move_character_to_court(characterToFind,"3k_dlc05_faction_sun_ce",context:modify_model())
				end	
			end				
		elseif turn_number == 15 then
			--MOVE TAISHI CI TO SUN CE's FACTION
			local characterToFind = context:query_model():character_for_template("3k_main_template_historical_taishi_ci_hero_metal")
			if not characterToFind:is_null_interface() then
				if not characterToFind:faction():is_human() then
					move_character_to_court(characterToFind,"3k_dlc05_faction_sun_ce",context:modify_model())
				end	
			end	
			--MOVE/SPAWN ZHOU TAI TO SUN CE's FACTION
			characterToFind = context:query_model():character_for_template("3k_main_template_historical_zhou_tai_hero_fire")
			if not characterToFind:is_null_interface() then
				if not characterToFind:faction():is_human() then
					move_character_to_court(characterToFind,"3k_dlc05_faction_sun_ce",context:modify_model())
				end					
			else
				cdir_events_manager:spawn_character_subtype_template_in_faction("3k_dlc05_faction_sun_ce", "3k_general_fire", "3k_main_template_historical_zhou_tai_hero_fire");
			end
			characterToFind = context:query_model():character_for_template("3k_main_template_historical_jiang_qin_hero_fire")
			--MOVE/SPAWN JIANG QIN TO SUN CE's FACTION
			if not characterToFind:is_null_interface() then
				if not characterToFind:faction():is_human() then
					move_character_to_court(characterToFind,"3k_dlc05_faction_sun_ce",context:modify_model())
				end					
			else
				cdir_events_manager:spawn_character_subtype_template_in_faction("3k_dlc05_faction_sun_ce", "3k_general_fire", "3k_main_template_historical_jiang_qin_hero_fire");
			end
		elseif turn_number == 25 then
			--MOVE LU MENG TO SUN CE's FACTION
			local characterToFind = context:query_model():character_for_template("3k_main_template_historical_lu_meng_hero_metal")
			if not characterToFind:is_null_interface() then
				if not characterToFind:faction():is_human() then
					move_character_to_court(characterToFind,"3k_dlc05_faction_sun_ce",context:modify_model())
				end 
			end
			--MOVE YU FAN TO SUN CE's FACTION
			characterToFind = context:query_model():character_for_template("3k_main_template_historical_yu_fan_hero_water")
			if not characterToFind:is_null_interface() then
				if not characterToFind:faction():is_human() then
					move_character_to_court(characterToFind,"3k_dlc05_faction_sun_ce",context:modify_model())
				end 
			end
		end

		--RECKLESS LUCK
		local pooled_resource_reckless_luck = cm:query_faction("3k_dlc05_faction_sun_ce"):pooled_resources():resource("3k_dlc05_pooled_resource_reckless_luck")
		local modified_pooled_resource_reckless_luck = context:modify_model():get_modify_pooled_resource(pooled_resource_reckless_luck)
		--For the first five turns, Sun Ce has max reckless luck. But after that his faction pooled resource bonuses is reduced significantly. 
		--Around the turn when Sun Ce is suppose to die and his brother takes over, his reckless luck is reduced further.
		if 35<= turn_number then
			local set_value = 55
			modified_pooled_resource_reckless_luck:apply_transaction_to_factor("3k_dlc05_pooled_factor_reckless_luck_decay",-(pooled_resource_reckless_luck:value()-set_value));
		elseif 15<= turn_number then			
			local set_value = 75
			modified_pooled_resource_reckless_luck:apply_transaction_to_factor("3k_dlc05_pooled_factor_reckless_luck_decay",-(pooled_resource_reckless_luck:value()-set_value));
		end

		--SUN CE LIFE-SPAN
		--When the turn number hits the life span set at the start of his campaign, kill Sun Ce.
		local sun_ce_character = context:query_model():character_for_template("3k_main_template_historical_sun_ce_hero_fire")
		if not sun_ce_character:is_dead() then
			if cm:saved_value_exists("SunCeLifeSpawn", "SunCeAILife") then 
				if (cm:get_saved_value("SunCeLifeSpawn", "SunCeAILife") ~= -1 and turn_number==(cm:get_saved_value("SunCeLifeSpawn", "SunCeAILife"))) then
					if sun_ce_character:is_faction_leader() then
						cdir_events_manager:kill_faction_leader(sun_ce_character:faction():name());
					else
						cdir_events_manager:kill_startpos_character( "1283665913", false );
					end	
				end
			end
		end
	end,
	true
);
end

--Function that moves character to a faction's court
function move_character_to_court(character,faction,modify_model)
	if not character:is_null_interface() then
        if(not character:is_dead()) then
            modify_model:get_modify_character(character):set_is_deployable(true)
            modify_model:get_modify_character(character):move_to_faction_and_make_recruited(faction)
        end
    end
end;

-------------------------------------------------
---------LU BU and CAO CAO AI WAR MANAGER--------
-------------------------------------------------
function dlc05_global_events:lu_bu_cao_cao_ai_war_manager()

	local cao_cao_ai = cm:query_faction("3k_main_faction_cao_cao"):is_human() == false

	--gives ai cao cao his specific buffs
	if cao_cao_ai then
		cm:modify_faction("3k_main_faction_cao_cao"):apply_effect_bundle("3k_dlc05_effect_bundle_ai_cao_cao_bonus_income",-1)
	end
end

-------------------------------------------------
---------Liu Bei Income Modifier-----------------
-------------------------------------------------
function dlc05_global_events:liu_bei_income_modifier()

	--gives Liu Bei extra starting income
		cm:modify_faction("3k_main_faction_liu_bei"):apply_effect_bundle("3k_dlc05_faction_trait_liu_bei",-1)
end
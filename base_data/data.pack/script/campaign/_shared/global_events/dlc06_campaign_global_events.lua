---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------
----- Name:			DLC06 GLOBAL EVENTS
----- Description: 	DLC06 Events - Nanman.
-----				Fires and manages events which affect the world as a whole.
-----
---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- MAIN
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
dlc06_global_events = {};

local meng_huo_template = "3k_dlc06_template_historical_king_meng_huo_hero_nanman";
local zhurong_template = "3k_dlc06_template_historical_lady_zhurong_hero_nanman";

-- Don't load in campaigns which don't require it.
if cm.name == "ep_eight_princes" or cm.name == "dlc07_guandu" then
	output("dlc06_global_events.lua: Not loaded in this campaign." );
	return;
end;

output("dlc06_global_events.lua: Loading");

local function new_game()
end;

local function initialise()
	local meng_huo = cm:query_character(meng_huo_template);		
	local zhurong = cm:query_character(zhurong_template);		

	if meng_huo and not meng_huo:is_null_interface() and not meng_huo:is_dead()	
	and zhurong and not zhurong:is_null_interface() and not zhurong:is_dead()
	and (not meng_huo:family_member():has_spouse() or meng_huo:family_member():spouse():character():generation_template_key() ~= zhurong_template) then
		-- If the lovers are alive and aren't married then queue up the events to make it happen.
		dlc06_global_events:meng_huo_and_zhurong_events();
	end;

end;

cm:add_first_tick_callback_new(new_game);
cm:add_first_tick_callback(initialise); --Self register function

-- Events centering around the romance between meng_huo and lady zhurong.
function dlc06_global_events:meng_huo_and_zhurong_events()
	local mh_faction_key = "3k_dlc06_faction_nanman_king_meng_huo";
	local zr_faction_key = "3k_dlc06_faction_nanman_lady_zhurong";
	local ah_faction_key = "3k_dlc06_faction_nanman_ahuinan"

	-- first meeting Meng Huo's faction
	local mh_zr_first_meeting = global_event:new("mh_zr_first_meeting", "MissionSucceeded", 
		function(context) 
			return context:mission():mission_record_key() == "3k_dlc06_progression_nanman_destroy_faction_mission" and 
			(context:faction():name() == mh_faction_key or context:faction():name() == zr_faction_key)
		end);
	mh_zr_first_meeting:set_valid_dates(190, 190);
	mh_zr_first_meeting:set_invalid_campaigns("dlc05_new_year"); -- they're already at war in new_year.
	mh_zr_first_meeting:add_dilemma("3k_dlc06_faction_meng_huo_zhurong_fight_enemies_dilemma");
	--mh_zr_first_meeting:add_dilemma_choice_outcome("3k_dlc06_faction_meng_huo_zhurong_fight_enemies_dilemma", 0, nil, 100, function() diplomacy_manager:force_declare_war(mh_faction_key, ah_faction_key); end)
	mh_zr_first_meeting:add_dilemma("3k_dlc06_faction_zhurong_meng_huo_fight_enemies_dilemma");
	--mh_zr_first_meeting:add_dilemma_choice_outcome("3k_dlc06_faction_zhurong_meng_huo_fight_enemies_dilemma", 0, nil, 100, function() diplomacy_manager:force_declare_war(zr_faction_key, ah_faction_key); end)
	mh_zr_first_meeting:register();

	-- Went to war together
	local mh_zr_went_to_war_with_ahuinan = global_event:new("mh_zr_went_to_war_with_ahuinan", "WorldStartOfRoundEvent",
		function(context)
			-- Wait for the decision to have fired.
			if global_events_manager:has_global_event_finished("mh_zr_first_meeting") then
				-- Check they both went to war
				if diplomacy_manager:is_at_war_with(mh_faction_key, ah_faction_key) and diplomacy_manager:is_at_war_with(zr_faction_key, ah_faction_key) then
					return true;
				else -- If not, we clear the event.
					global_events_manager:clear_global_event("mh_zr_went_to_war_with_ahuinan");
				end;
			end;
			return false;
		end);
	mh_zr_went_to_war_with_ahuinan:add_incident("3k_dlc06_faction_meng_huo_zhurong_fight_enemies_joins"); -- Meng Huo variant
	mh_zr_went_to_war_with_ahuinan:add_incident("3k_dlc06_faction_zhurong_meng_huo_fight_enemies_joins"); -- Zhurong Variant
	mh_zr_went_to_war_with_ahuinan:register();

	-- spoils of war.
	local mh_zr_spoils_of_war = global_event:new("mh_zr_spoils_of_war", "WorldStartOfRoundEvent",
	function(context)
		-- Check if Meng Huo owns both of Ahuinan's original regions.
		local mh_region_count = cm:query_faction(mh_faction_key):region_list():count_if(
			function(region) return region:name() == "3k_main_jianning_resource_2" or region:name() == "3k_dlc06_jianning_resource_3" end);				
		-- Check if Lady Zhurong Huo both of Ahuinan's original regions.
		local zr_region_count = cm:query_faction(zr_faction_key):region_list():count_if(
			function(region) return region:name() == "3k_main_jianning_resource_2" or region:name() == "3k_dlc06_jianning_resource_3" end);

		if cm:query_model():campaign_name() == "3k_main_campaign_map" then
			return global_events_manager:has_global_event_finished("mh_zr_first_meeting") and (mh_region_count == 2 or zr_region_count == 2);
		
		elseif cm:query_model():campaign_name() == "3k_dlc05_start_pos" then
			return mh_region_count == 2 or zr_region_count == 2
		end
			
	end
	);
	mh_zr_spoils_of_war:add_dilemma("3k_dlc06_faction_meng_huo_zhurong_spoils_of_war_dilemma");
	mh_zr_spoils_of_war:add_dilemma("3k_dlc06_faction_zhurong_meng_huo_spoils_of_war_dilemma");
	mh_zr_spoils_of_war:register();

	--If the player picks the option to attack Lady Zhurong or Meng Huo, fire off the relevant mission.
    core:add_listener(
    "DiplomacyDealNegotiatedMengHuoLadyZhurongFight", -- Unique handle
    "DiplomacyDealNegotiated", -- Campaign Event to listen for
    function(context)
        return cm:query_faction(mh_faction_key):has_specified_diplomatic_deal_with("treaty_components_war",cm:query_faction(zr_faction_key))
    end,
	function(context)
		if cm:query_faction(mh_faction_key):is_human() then
			cm:modify_faction(mh_faction_key):trigger_mission("3k_dlc06_faction_meng_huo_zhurong_nemesis_01_mission", true)
		elseif cm:query_faction(zr_faction_key):is_human() then
			cm:modify_faction(zr_faction_key):trigger_mission("3k_dlc06_faction_zhurong_meng_huo_nemesis_01_mission", true)
		end		
    end,
    false
	);

	--Marriage by conflict handler
	local mh_zr_marriage_after_conflict = global_event:new("mh_zr_marriage_after_conflict", "MissionSucceeded", 
		function(context)
			local mission_key = context:mission():mission_record_key()
			--DILLEMMA MOST NOT BE TRUE, IF BOTH FACTIONS ARE PLAYERS	
			return (mission_key == "3k_dlc06_faction_meng_huo_zhurong_nemesis_01_mission" or mission_key == "3k_dlc06_faction_zhurong_meng_huo_nemesis_01_mission") and not (cm:query_faction(mh_faction_key):is_human() and cm:query_faction(zr_faction_key):is_human())
		end);
	mh_zr_marriage_after_conflict:add_dilemma("3k_dlc06_faction_meng_huo_zhurong_nemesis_02_dilemma");
	mh_zr_marriage_after_conflict:add_dilemma("3k_dlc06_faction_zhurong_meng_huo_nemesis_02_dilemma");
	mh_zr_marriage_after_conflict:register();


	--If the player is issued with the mission to attack Lady Zhurong or Meng Huo, keep track if either becomes a vassal.
    core:add_listener(
    "MissionIssuedMengHuoLadyZhurongFight", -- Unique handle
    "MissionIssued", -- Campaign Event to listen for
	function(context)
		local mission_key = context:mission():mission_record_key()
		return (mission_key == "3k_dlc06_faction_meng_huo_zhurong_nemesis_01_mission" or mission_key == "3k_dlc06_faction_zhurong_meng_huo_nemesis_01_mission")
    end,
	function(context)
		--Create a listener to check if either of them becomes a vassal of the other
		--Via settlement occupation option
		core:add_listener(
			"CharacterPerformsSettlementSiegeActionMengHuoLadyZhurongCancelMission", -- Unique handle
			"CharacterPerformsSettlementSiegeAction", -- Campaign Event to listen for
			function(context)
				if context:action_option_record_key()=="dlc06_option_subjugate_major_nanman_vs_nanman_last_settlement" or context:action_option_record_key()=="dlc06_option_subjugate_minor_nanman_vs_nanman_last_settlement" then
					local meng_huo_faction = cm:query_faction(mh_faction_key)
					local lady_zhurong_faction = cm:query_faction(zr_faction_key)
					if not meng_huo_faction:is_null_interface() and not lady_zhurong_faction:is_null_interface() then
						if (meng_huo_faction:is_human() or lady_zhurong_faction:is_human()) and (diplomacy_manager:is_vassal(mh_faction_key) or diplomacy_manager:is_vassal(zr_faction_key)) then
							return meng_huo_faction:has_specified_diplomatic_deal_with("treaty_components_vassalage",lady_zhurong_faction) or lady_zhurong_faction:has_specified_diplomatic_deal_with("treaty_components_vassalage",meng_huo_faction)
						end
					end
				end
				return false;
			end,
			function(context)
				if cm:query_faction(mh_faction_key):is_human() then
					context:modify_model():get_modify_faction(cm:query_faction(mh_faction_key)):cancel_custom_mission("3k_dlc06_faction_meng_huo_zhurong_nemesis_01_mission")
				elseif cm:query_faction(zr_faction_key):is_human() then
					context:modify_model():get_modify_faction(cm:query_faction(zr_faction_key)):cancel_custom_mission("3k_dlc06_faction_zhurong_meng_huo_nemesis_01_mission")
				end
			end,
			false
			);	
		--Via Diplomacy or other means
		core:add_listener(
			"FactionTurnStartMengHuoLadyZhurongCancelMission", -- Unique handle
			"FactionTurnStart", -- Campaign Event to listen for
			function(context)
				if context:faction():is_human() then
					local meng_huo_faction = cm:query_faction(mh_faction_key)
					local lady_zhurong_faction = cm:query_faction(zr_faction_key)
					if not meng_huo_faction:is_null_interface() and not lady_zhurong_faction:is_null_interface() then
						if (meng_huo_faction:is_human() or lady_zhurong_faction:is_human()) and (diplomacy_manager:is_vassal(mh_faction_key) or diplomacy_manager:is_vassal(zr_faction_key)) then
							return meng_huo_faction:has_specified_diplomatic_deal_with("treaty_components_vassalage",lady_zhurong_faction) or lady_zhurong_faction:has_specified_diplomatic_deal_with("treaty_components_vassalage",meng_huo_faction)
						end
					end
				end
				return false;
			end,
			function(context)
				if cm:query_faction(mh_faction_key):is_human() then
					context:modify_model():get_modify_faction():cancel_custom_mission("3k_dlc06_faction_meng_huo_zhurong_nemesis_01_mission")
				elseif cm:query_faction(zr_faction_key):is_human() then
					context:modify_model():get_modify_faction(cm:query_faction(zr_faction_key)):cancel_custom_mission("3k_dlc06_faction_zhurong_meng_huo_nemesis_01_mission")
				end
			end,
			false
			);	
    end,
    false
	);

	--Marriage by conflict - mission cancelled handler
	local mh_zr_marriage_after_conflict_failed = global_event:new("mh_zr_marriage_after_conflict_cancelled", "MissionCancelled", 
		function(context)
			local mission_key = context:mission():mission_record_key()
			local fire_dilemma = (mission_key == "3k_dlc06_faction_meng_huo_zhurong_nemesis_01_mission" or mission_key == "3k_dlc06_faction_zhurong_meng_huo_nemesis_01_mission") and not (cm:query_faction(mh_faction_key):is_human() and cm:query_faction(zr_faction_key):is_human())
			--Remove the listeners
			if fire_dilemma then
				core:remove_listener("CharacterPerformsSettlementSiegeActionMengHuoLadyZhurongCancelMission")
				core:remove_listener("FactionTurnStartMengHuoLadyZhurongCancelMission")
			end
			return fire_dilemma
		end);
	mh_zr_marriage_after_conflict_failed:add_dilemma("3k_dlc06_faction_meng_huo_zhurong_harmony_dilemma");
	mh_zr_marriage_after_conflict_failed:add_dilemma("3k_dlc06_faction_zhurong_meng_huo_harmony_dilemma");
	mh_zr_marriage_after_conflict_failed:register();

	--Before marriage is made, then record who the old spouse is.
    core:add_listener(
    "DilemmaIssuedEventMengHuoLadyZhurongFight", -- Unique handle
    "DilemmaIssuedEvent", -- Campaign Event to listen for
	function(context)
		local dilemma = context:dilemma()
		return dilemma=="3k_dlc06_faction_meng_huo_zhurong_harmony_dilemma" or dilemma=="3k_dlc06_faction_zhurong_meng_huo_harmony_dilemma" or dilemma=="3k_dlc06_faction_meng_huo_zhurong_starcrossed_dilemma" or
		dilemma=="3k_dlc06_faction_zhurong_meng_huo_starcrossed_dilemma" or dilemma=="3k_dlc06_faction_meng_huo_zhurong_nemesis_02_dilemma" or dilemma=="3k_dlc06_faction_zhurong_meng_huo_nemesis_02_dilemma"
    end,
	function(context)
		local meng_huo_cqi = cm:query_model():character_for_template(meng_huo_template):cqi();		
		local lady_zhurong_cqi = cm:query_model():character_for_template(zhurong_template):cqi();

		local character = context:query_model():character_for_command_queue_index(meng_huo_cqi)
		if not character:is_null_interface() then
			local character_family = character:family_member()
			if not character_family:is_null_interface() and character_family:has_spouse() and not character_family:spouse():character():is_null_interface() then
				cm:set_saved_value("meng_huo_spouse",character_family:spouse():character():command_queue_index(),"meng_huo_lady_zhurong_marriage")
			end
		end

		character = context:query_model():character_for_command_queue_index(lady_zhurong_cqi)
		if not character:is_null_interface() then
			local character_family = character:family_member()
			if not character_family:is_null_interface() and character_family:has_spouse() and not character_family:spouse():character():is_null_interface() then
				cm:set_saved_value("lady_zhurong_spouse",character_family:spouse():character():command_queue_index(),"meng_huo_lady_zhurong_marriage")
			end
		end
    end,
    false
	);

	--If AI Meng Huo and Lady Zhurong get married, be sure divorse them from any former spouses
	core:add_listener(
    "IncidentOccuredEventMengHuoLadyZhurongTogether", -- Unique handle
    "IncidentOccuredEvent", -- Campaign Event to listen for
	function(context)
		return context:incident()=="3k_dlc06_faction_meng_huo_zhurong_marriage_npc_incident"
	end,
	function(context)
		local meng_huo_faction = cm:query_faction(mh_faction_key)
		local meng_huo_character_list = meng_huo_faction:character_list()
		--Go through all characters in his court and divorse them from Lady Zhurong
		meng_huo_character_list:foreach(function(character)
			--Character isn't Meng Huo
			if not character:is_null_interface() and character:generation_template_key() ~=meng_huo_template then
				local character_family = character:family_member()
				--Character has a souse
				if not character_family:is_null_interface() and character_family:has_spouse() then
					local spouse = character_family:spouse()
					--If Spouse is Lady Zhurong, then divorse them
					if not spouse:character():is_null_interface() and spouse:character():generation_template_key()==zhurong_template then
						context:modify_model():get_modify_family_member(character_family):divorce_spouse()
					end
				end
			end
		end);		
	end,
    false
	);

	
	--Regardless of which marriage dilemma fires, then be sure to divorse the old spouse.
	core:add_listener(
    "DilemmaChoiceMadeEventMengHuoLadyZhurongDivoses", -- Unique handle
    "DilemmaChoiceMadeEvent", -- Campaign Event to listen for
	function(context)
		local dilemma = context:dilemma()
		return (dilemma=="3k_dlc06_faction_meng_huo_zhurong_harmony_dilemma" or dilemma=="3k_dlc06_faction_zhurong_meng_huo_harmony_dilemma" or dilemma=="3k_dlc06_faction_meng_huo_zhurong_starcrossed_dilemma" or
		dilemma=="3k_dlc06_faction_zhurong_meng_huo_starcrossed_dilemma" or dilemma=="3k_dlc06_faction_meng_huo_zhurong_nemesis_02_dilemma" or dilemma=="3k_dlc06_faction_zhurong_meng_huo_nemesis_02_dilemma") and 
		context:choice()==0
    end,
	function(context)
		if cm:saved_value_exists("meng_huo_spouse","meng_huo_lady_zhurong_marriage") then
			local spouse = cm:get_saved_value("meng_huo_spouse","meng_huo_lady_zhurong_marriage")
			local spouse_character = context:query_model():character_for_command_queue_index(spouse)
			if not spouse_character:is_null_interface() and not spouse_character:is_dead() and spouse_character:generation_template_key() ~=zhurong_template then
				context:modify_model():get_modify_family_member(spouse_character:family_member()):divorce_spouse()
			end	
		end

		if cm:saved_value_exists("lady_zhurong_spouse","meng_huo_lady_zhurong_marriage") then
			local spouse = cm:get_saved_value("lady_zhurong_spouse","meng_huo_lady_zhurong_marriage")
			local spouse_character = context:query_model():character_for_command_queue_index(spouse)
			if not spouse_character:is_null_interface() and not spouse_character:is_dead() and spouse_character:generation_template_key() ~=meng_huo_template then
				context:modify_model():get_modify_family_member(spouse_character:family_member()):divorce_spouse()
			end			
		end
    end,
    false
	);
end;
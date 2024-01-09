output("dlc06_nanman_tech_missions.lua: Loading");

--Nanman tech tree mission--
--Author: Matthew Perkins--
--This script utilizes the nanman_tech script to unlock technologies, CEO and diplomacy deals--


---------------------------------------------------------
-------------------INITIAL TECH MISSIONS-----------------
---------------------------------------------------------

-- initialise manager for UI context list (see UI Context section).

nanman_tech_missions = {}

cm:add_first_tick_callback(function() nanman_tech_missions:Initialise() end) --self register function

function nanman_tech_missions:Initialise() 

	-- Early exit in autoruns and the like.
	local local_faction_key = cm:get_local_faction(true);
	if local_faction_key then
		--Set the correct missions to the mission_lists depending on the Nanman faction playing
		local local_faction = cm:query_faction(local_faction_key);
		
		if local_faction and local_faction:is_human() then -- Ai runs don't have a local human.
			local specialization = nanman_tech_manager.tech_specialisation_junctions[local_faction:name()]
			if specialization ~= nil then
				effect.set_context_value("tech_tree_specialization",specialization)
				if local_faction:name()=="3k_dlc06_faction_nanman_king_meng_huo" then
					effect.set_context_value("Techs_to_Mission_List",techs_to_missions_meng_huo)
				elseif local_faction:name()=="3k_dlc06_faction_nanman_king_shamoke" then
					effect.set_context_value("Techs_to_Mission_List",techs_to_missions_shamoke)
				elseif local_faction:name()=="3k_dlc06_faction_nanman_king_mulu" then
					effect.set_context_value("Techs_to_Mission_List",techs_to_missions_mulu)
				elseif local_faction:name()=="3k_dlc06_faction_nanman_lady_zhurong" then
					effect.set_context_value("Techs_to_Mission_List",techs_to_missions_zhurong)
				end
			end
		end
	end;
 
	--GUANGU BYPASS OF LOCKED MISSIONS
	if cm:get_campaign_name() == "dlc07_guandu" then

		for i, human_faction in ipairs(cm:get_human_factions()) do
			local m_faction = cm:modify_faction(human_faction)
			
			if m_faction:query_faction():subculture() == "3k_dlc06_subculture_nanman" then
				
				local faction_name = string.gsub(m_faction:query_faction():name(), "_faction", "")
				local tech_unlock = "_tech_unlock_"
				local tier1 = "_tier1"

				--creates strings for each tech
				local economic_tech = faction_name..tech_unlock.."economic"..tier1
				local military_tech = faction_name..tech_unlock.."military"..tier1
				local political_tech = faction_name..tech_unlock.."political"..tier1
				
				--disables event feed then triggers and completes all missions
				cm:disable_event_feed_events(true, "", "3k_event_subcategory_faction_missions_objectives")

				m_faction:trigger_mission(economic_tech, true)
				m_faction:trigger_mission(military_tech, true)

				local political_mission = string_mission:new(political_tech)
				political_mission:set_issuer("3k_dlc06_nanman_tech_issuer");
				political_mission:add_primary_objective("SCRIPTED",
					{"script_key 3k_dlc06_scripted_know_ten_factions",
					"override_text mission_text_text_3k_dlc06_scripted_know_ten_factions"}
				);
				political_mission:add_primary_objective("SCRIPTED",
					{"script_key 3k_dlc06_scripted_have_a_treaty",
					"override_text mission_text_text_3k_dlc06_scripted_have_a_treaty"}
				);
				political_mission:add_primary_payload( "effect_bundle{bundle_key 3k_dlc06_payload_technology_political;turns 3;}" );
				
				political_mission:trigger_mission_for_faction(m_faction:query_faction():name())
								
				m_faction:complete_custom_mission(economic_tech)
				m_faction:complete_custom_mission(military_tech)
				m_faction:complete_custom_mission(political_tech)

				cm:disable_event_feed_events(false, "", "3k_event_subcategory_faction_missions_objectives")

				--removes effect bundles from game. since it's 3 bundles, instead of 3 listeners, i made 1 listener
				--and another one that removes both listeners
				core:add_listener(
					"nanman_200_tech_mission_effect_bundle_remover",
					"FactionEffectBundleAwarded",
					function(context)
						return (context:effect_bundle_key() == "3k_dlc06_payload_technology_economic"
						 or context:effect_bundle_key() == "3k_dlc06_payload_technology_military"
						 or context:effect_bundle_key() == "3k_dlc06_payload_technology_political")
						 and cm:get_campaign_name() == "dlc07_guandu"
						 and context:faction():is_human()
					end,
					function(context)
						cm:modify_faction(context:faction():name()):remove_effect_bundle(context:effect_bundle_key())
					end,
					true
				)

				core:add_listener(
					"nanman_200_tech_mission_effect_bundle_remover_remover",
					"FactionTurnStart",
					function(context)
						return cm:get_campaign_name() == "dlc07_guandu"
						 and context:faction():is_human()
						 and context:faction():subculture() == "3k_dlc06_subculture_nanman"
						 and cm:query_model():turn_number() == 2
					end,
					function(context)
						core:remove_listener("nanman_200_tech_mission_effect_bundle_remover")
						core:remove_listener("nanman_200_tech_mission_effect_bundle_remover_remover")
					end,
					true
				)
			end
		end
	end
end

-- Unlock Tier 1 missions after researching the elephant mount tech.

		core:add_listener(
        "ResearchCompletedElephantMount", -- Unique handle
        "ResearchCompleted", -- Campaign Event to listen for
        function(context) -- Listener condition
			return context:technology_record_key() == nanman_tech_manager.first_tech 
				and context:faction():is_human() and not context:faction():ceo_management():is_null_interface()
        end,
        function(context) -- What to do if listener fires.
		
            -- cache the modify faction
			local modify_faction = cm:modify_faction(context:faction());

            -- add the elephant mount ceo
            modify_faction:ceo_management():add_ceo("3k_dlc06_ancillary_mount_elephant_refined");

			-- only trigger the missions in non dlc07 campaigns
			if cm:get_campaign_name() ~= "dlc07_guandu" then

				--mission key for the politial mission
				local mission_key = ""

				-- use it to trigger mission
				local faction_name = context:faction():name();
				if faction_name == "3k_dlc06_faction_nanman_king_meng_huo" then
					modify_faction:trigger_mission("3k_dlc06_nanman_king_meng_huo_tech_unlock_economic_tier1", true)
					modify_faction:trigger_mission("3k_dlc06_nanman_king_meng_huo_tech_unlock_military_tier1", true)
					mission_key="3k_dlc06_nanman_king_meng_huo_tech_unlock_political_tier1"
				elseif faction_name == "3k_dlc06_faction_nanman_king_mulu" then
					modify_faction:trigger_mission("3k_dlc06_nanman_king_mulu_tech_unlock_economic_tier1", true)
					modify_faction:trigger_mission("3k_dlc06_nanman_king_mulu_tech_unlock_military_tier1", true)	
					mission_key="3k_dlc06_nanman_king_mulu_tech_unlock_political_tier1"

				elseif faction_name == "3k_dlc06_faction_nanman_king_shamoke" then
					modify_faction:trigger_mission("3k_dlc06_nanman_king_shamoke_tech_unlock_economic_tier1", true)
					modify_faction:trigger_mission("3k_dlc06_nanman_king_shamoke_tech_unlock_military_tier1", true)
					mission_key = "3k_dlc06_nanman_king_shamoke_tech_unlock_political_tier1"				
				elseif faction_name == "3k_dlc06_faction_nanman_lady_zhurong" then
					modify_faction:trigger_mission("3k_dlc06_nanman_lady_zhurong_tech_unlock_economic_tier1", true)
					modify_faction:trigger_mission("3k_dlc06_nanman_lady_zhurong_tech_unlock_military_tier1", true)		
					mission_key="3k_dlc06_nanman_lady_zhurong_tech_unlock_political_tier1"
				end     

				local political_mission = string_mission:new(mission_key)
				political_mission:set_issuer("3k_dlc06_nanman_tech_issuer");
				political_mission:add_primary_objective("SCRIPTED",
					{"script_key 3k_dlc06_scripted_know_ten_factions",
					"override_text mission_text_text_3k_dlc06_scripted_know_ten_factions"}
				);
				political_mission:add_primary_objective("SCRIPTED",
					{"script_key 3k_dlc06_scripted_have_a_treaty",
					"override_text mission_text_text_3k_dlc06_scripted_have_a_treaty"}
				);
				political_mission:add_primary_payload( "effect_bundle{bundle_key 3k_dlc06_payload_technology_political;turns 3;}" );
				
				return political_mission:trigger_mission_for_faction(context:faction():name())
			
			end
        end,
        true--Is persistent
		);
		
		--When the political tier mission is issued, check if objecitves have been completed already.
		core:add_listener(
		"MissionIssuedPoliticalTier1", -- Unique handle
		"MissionIssued", -- Campaign Event to listen for
		function(context)
			return string.match(context:mission():mission_record_key(), "political_tier1")
		end,
		function(context) -- What to do if listener fires.
			local faction = context:faction()
			cm:set_saved_value("political_mission_cqi"..context:faction():name(),context:mission():cqi(),"nanman_tech_missions")
			--Know more than 10 factions -- factions have to be alive and active in game
			local living_factions_known = 0
			for i = 0, faction:factions_met():num_items()-1 do
				local faction_to_inspect = faction:factions_met():item_at(i)
				if not faction_to_inspect:is_dead() then
					living_factions_known = living_factions_known +1
				end
			end
			if living_factions_known >= 10 then 
				context:modify_model():get_modify_faction(context:faction()):complete_scripted_mission_objective(context:mission():mission_record_key(),"3k_dlc06_scripted_know_ten_factions",true)
			end
			--Have signed a treaty
			if faction:has_specified_diplomatic_deal_with_anybody("treaty_components_non_aggression") or  
			faction:has_specified_diplomatic_deal_with_anybody("treaty_components_military_access") or
			faction:has_specified_diplomatic_deal_with_anybody("treaty_components_trade") then
				context:modify_model():get_modify_faction(context:faction()):complete_scripted_mission_objective(context:mission():mission_record_key(),"3k_dlc06_scripted_have_a_treaty",true)
			end
		end,
		true, --is persistent
		nil, --completion event
		nil -- failure event
		);

		--When the political tier mission is issued, check if objecitves have been completed already.
		core:add_listener(
		"MissionIssuedPoliticalTier4_1", -- Unique handle
		"MissionIssued", -- Campaign Event to listen for
		function(context)
			return context:mission():mission_record_key()=="3k_dlc06_nanman_tech_unlock_political_tier4_1" and not context:faction():is_null_interface() and context:faction():is_human()
		end,
		function(context) -- What to do if listener fires.
			local character_posts = context:faction():character_posts()

			--Check if the Nanman seer position is assigned already
			local seer_is_assigned_already = character_posts:find_if(function(character_position) 
				return not character_position:is_null_interface() and 
					character_position:ministerial_position_record_key()== "3k_dlc06_court_offices_nanman_seer" and 
					character_position:current_post_holders() ~= 0
			end);

			--If the Nanman seer assigned, then complete the mission
			if seer_is_assigned_already ~= nil and not seer_is_assigned_already:is_null_interface() and seer_is_assigned_already then
				context:modify_model():get_modify_faction(context:faction()):complete_custom_mission(context:mission():mission_record_key())
			end
		end,
		false --is persistent
		);
---------------------------------------------------------
-----------------UNITING THE TRIBES------------------
---------------------------------------------------------

-- If the tribes have been united, unlock the remaning tech missions.
core:add_listener(
    "UniteTheTribesUnlockRemainingTechnologies", -- Unique handle
    "UnlockNanmanTechTreeLateTiers", -- Campaign Event to listen for
    true,
	function(context) -- What to do if listener fires.
		local human_factions = cm:get_human_factions()
		for i = 1, #human_factions do
			local faction_name = human_factions[i]
			--UNLOCK TIER 2 Techs
			if cm:saved_value_exists("military_tier2"..faction_name,"tech_progression") then
				if cm:saved_value_exists("military_tier3"..faction_name,"tech_progression") then
					nanman_tech_manager:unlock_tech(faction_name, "3k_dlc06_tech_nanman_mb3a_marching_drills")
					nanman_tech_manager:unlock_tech(faction_name, "3k_dlc06_tech_nanman_mb3b_training_camps")
					nanman_tech_manager:unlock_tech(faction_name, "3k_dlc06_tech_nanman_mb3c_regimented_military")
					nanman_tech_manager:unlock_tech(faction_name, "3k_dlc06_tech_nanman_mr3_1_engineers_of_war_han")
					nanman_tech_manager:unlock_tech(faction_name, "3k_dlc06_tech_nanman_mr3_2_lays_of_the_land_nanman")
				else
					nanman_tech_manager:unlock_tech(faction_name, "3k_dlc06_tech_nanman_mb2a_supply_chains")
					nanman_tech_manager:unlock_tech(faction_name, "3k_dlc06_tech_nanman_mb2b_tribal_conscription")
					nanman_tech_manager:unlock_tech(faction_name, "3k_dlc06_tech_nanman_mb2c_established_infrastructure")
					nanman_tech_manager:unlock_tech(faction_name, "3k_dlc06_tech_nanman_mr2_1_southern_hirelings_han")
					nanman_tech_manager:unlock_tech(faction_name, "3k_dlc06_tech_nanman_mr2_2_professional_soldiery_nanman")
				end
			end
			if cm:saved_value_exists("economic_tier2"..faction_name,"tech_progression") then
				if cm:saved_value_exists("economic_tier3"..faction_name,"tech_progression") then
					nanman_tech_manager:unlock_tech(faction_name, "3k_dlc06_tech_nanman_eb3a_riverside_waystations")
					nanman_tech_manager:unlock_tech(faction_name, "3k_dlc06_tech_nanman_eb3b_civilised_society")
					nanman_tech_manager:unlock_tech(faction_name, "3k_dlc06_tech_nanman_eb3c_resource_refinement")
					nanman_tech_manager:unlock_tech(faction_name, "3k_dlc06_tech_nanman_er3_1_streamlined_governance_han")
					nanman_tech_manager:unlock_tech(faction_name, "3k_dlc06_tech_nanman_er3_2_ancestral_belief_nanman")
				else
					nanman_tech_manager:unlock_tech(faction_name, "3k_dlc06_tech_nanman_eb2a_industrial_expansion")
					nanman_tech_manager:unlock_tech(faction_name, "3k_dlc06_tech_nanman_eb2b_artisans")
					nanman_tech_manager:unlock_tech(faction_name, "3k_dlc06_tech_nanman_eb2c_way_of_the_land")
					nanman_tech_manager:unlock_tech(faction_name, "3k_dlc06_tech_nanman_er2_1_division_of_labour_han")
					nanman_tech_manager:unlock_tech(faction_name, "3k_dlc06_tech_nanman_er2_2_advanced_metalwork_nanman")
				end
			end
			if cm:saved_value_exists("political_tier2"..faction_name,"tech_progression") then
				if cm:saved_value_exists("political_tier3"..faction_name,"tech_progression") then
					nanman_tech_manager:unlock_tech(faction_name, "3k_dlc06_tech_nanman_pb2a_intelligent_negotiations")
					nanman_tech_manager:unlock_tech(faction_name, "3k_dlc06_tech_nanman_pb2b_promises_of_co_operation")
					nanman_tech_manager:unlock_tech(faction_name, "3k_dlc06_tech_nanman_pb2c_tribal_council")
					nanman_tech_manager:unlock_tech(faction_name, "3k_dlc06_tech_nanman_pr2_1_demand_fealty_han")
					nanman_tech_manager:unlock_tech(faction_name, "3k_dlc06_tech_nanman_pr2_2_contractual_obligations_nanman")				
				else
					nanman_tech_manager:unlock_tech(faction_name, "3k_dlc06_tech_nanman_pb3a_refined_bureaucracy")
					nanman_tech_manager:unlock_tech(faction_name, "3k_dlc06_tech_nanman_pb3b_centralised_administration")
					nanman_tech_manager:unlock_tech(faction_name, "3k_dlc06_tech_nanman_pb3c_cultural_exchange")
					nanman_tech_manager:unlock_tech(faction_name, "3k_dlc06_tech_nanman_pr3_1_bureaucratic_reform_han")
					nanman_tech_manager:unlock_tech(faction_name, "3k_dlc06_tech_nanman_pr3_2_regional_investigations_nanman")
				end
			end		
		end;
		
	end,
	true, --is persistent
	nil, --completion event
	nil -- failure event
	);

---------------------------------------------------------
-----------------MILITARY TECH MISSIONS------------------
---------------------------------------------------------

-- Unlock Tier 1: Defeat 3 armies
	-- listener that unlocks tier 1 tech and starts the next mission
    core:add_listener(
    "MissionSucceededMilitaryTechMission1", -- Unique handle
    "MissionSucceeded", -- Campaign Event to listen for
    function(context)
        return string.match(context:mission():mission_record_key(), "military_tier1")
    end,
	function(context) -- What to do if listener fires.
		nanman_tech_manager:unlock_tech(context:faction():name(), "3k_dlc06_tech_nanman_mb1a_tribal_tenacity")
		nanman_tech_manager:unlock_tech(context:faction():name(), "3k_dlc06_tech_nanman_mb1b_improved_spear_making")
		nanman_tech_manager:unlock_tech(context:faction():name(), "3k_dlc06_tech_nanman_mb1c_professional_smithing")
		nanman_tech_manager:unlock_tech(context:faction():name(), "3k_dlc06_tech_nanman_mr1_1_advanced_battle_tactics_han")
		nanman_tech_manager:unlock_tech(context:faction():name(), "3k_dlc06_tech_nanman_mr1_2_tribal_zeal_nanman")
	end,
	true, --is persistent
	nil, --completion event
	nil -- failure event
	);

-- Unlock Tier 2: Reach rank 4 with your faction leader.

	-- listener that unlocks tier 2 tech.
    core:add_listener(
    "MissionSucceededMilitaryTechMission2", -- Unique handle
    "MissionSucceeded", -- Campaign Event to listen for
    function(context)
        return context:mission():mission_record_key() == "3k_dlc06_nanman_tech_unlock_military_tier2"
    end,
	function(context) -- What to do if listener fires.
		local specialization = nanman_tech_manager.tech_specialisation_junctions[context:faction():name()];
		if specialization ~= nil then
			if nanman_fealty:get_sv_have_tribes_been_united_by_anyone() or specialization == "all" or specialization == "military"  then
				nanman_tech_manager:unlock_tech(context:faction():name(), "3k_dlc06_tech_nanman_mb2a_supply_chains")
				nanman_tech_manager:unlock_tech(context:faction():name(), "3k_dlc06_tech_nanman_mb2b_tribal_conscription")
				nanman_tech_manager:unlock_tech(context:faction():name(), "3k_dlc06_tech_nanman_mb2c_established_infrastructure")
				nanman_tech_manager:unlock_tech(context:faction():name(), "3k_dlc06_tech_nanman_mr2_1_southern_hirelings_han")
				nanman_tech_manager:unlock_tech(context:faction():name(), "3k_dlc06_tech_nanman_mr2_2_professional_soldiery_nanman")
			end
		end
		--SAVE TECHNOLOGY PROGRESSION
		cm:set_saved_value("military_tier2"..context:faction():name(),true,"tech_progression")
	end,
	true, --is persistent
	nil, --completion event
	nil -- failure event
	);

	-- listener that starts the next mission after reseaching the first military reform
    core:add_listener(
    "ResearchCompletedMilitaryTechMission1", -- Unique handle
    "ResearchCompleted", -- Campaign Event to listen for
	function(context) -- Listener condition
		local tech = context:technology_record_key()
        return string.match(tech,"3k_dlc06_tech_nanman_mr1") and context:faction():is_human()
    end,
	function(context) -- What to do if listener fires.
		-- Fires next mission
		cm:modify_faction(context:faction()):trigger_mission("3k_dlc06_nanman_tech_unlock_military_tier2", true)

		--Check if unite the tribes mission have been granted
		local event_generator = cm:query_model():event_generator_interface()
		local faction = context:faction()
		local mission = "3k_dlc06_progression_nanman_unite_the_tribes_mission"
		if not event_generator:any_of_missions_active(faction, mission) then
			-- Fires the united the tribes mission
			core:trigger_event("script_event_dlc06_" .. faction:name().."03");
		end

	end,
	true, --is persistent
	nil, --completion event
	nil -- failure event
	);

	-- listener that starts the next mission. Must research mr2_1
    core:add_listener(
    "ResearchCompletedMilitaryTechMission2_1", -- Unique handle
    "ResearchCompleted", -- Campaign Event to listen for
	function(context) -- Listener condition
		local tech = context:technology_record_key()
        return (tech == "3k_dlc06_tech_nanman_mr2_1_southern_hirelings_han" or tech == "3k_dlc06_tech_nanman_mr2_2_professional_soldiery_nanman") and context:faction():is_human()
    end,
	function(context) -- What to do if listener fires.
		local tech = context:technology_record_key()
		if tech == "3k_dlc06_tech_nanman_mr2_1_southern_hirelings_han" then
			-- Unlock Tier 3: Recruit 3 units of Mercenary Cavalry.
			cm:modify_faction(context:faction()):trigger_mission("3k_dlc06_nanman_tech_unlock_military_tier3_1", true)
		else
			-- Unlock Tier 3: Recruit an additional 10 units.
			cm:modify_faction(context:faction()):trigger_mission("3k_dlc06_nanman_tech_unlock_military_tier3_2", true)
		end
	end,
	true, --is persistent
	nil, --completion event
	nil -- failure event
	);

	-- listener that unlocks tier 3 tech. 
    core:add_listener(
    "MissionSucceededMilitaryTechMission3", -- Unique handle
    "MissionSucceeded", -- Campaign Event to listen for
    function(context)
		return context:mission():mission_record_key() == "3k_dlc06_nanman_tech_unlock_military_tier3_1" or
		context:mission():mission_record_key() == "3k_dlc06_nanman_tech_unlock_military_tier3_2"
	end,
	function(context) -- What to do if listener fires.
		if nanman_fealty:get_sv_have_tribes_been_united_by_anyone() then
			nanman_tech_manager:unlock_tech(context:faction():name(), "3k_dlc06_tech_nanman_mb3a_marching_drills")
			nanman_tech_manager:unlock_tech(context:faction():name(), "3k_dlc06_tech_nanman_mb3b_training_camps")
			nanman_tech_manager:unlock_tech(context:faction():name(), "3k_dlc06_tech_nanman_mb3c_regimented_military")
			nanman_tech_manager:unlock_tech(context:faction():name(), "3k_dlc06_tech_nanman_mr3_1_engineers_of_war_han")
			nanman_tech_manager:unlock_tech(context:faction():name(), "3k_dlc06_tech_nanman_mr3_2_lays_of_the_land_nanman")
		end
		--SAVE TECHNOLOGY PROGRESSION
		cm:set_saved_value("military_tier3"..context:faction():name(),true,"tech_progression")
	end,
	true, --is persistent
	nil, --completion event
	nil -- failure event
	);

-- Unlock Tier 4: Win 10 battles against the Han.

-- listener that starts the next mission. Must research mr3_1
core:add_listener(
    "ResearchCompletedMilitaryTechMission3", -- Unique handle
    "ResearchCompleted", -- Campaign Event to listen for
    function(context) -- Listener condition
		return (context:technology_record_key() == "3k_dlc06_tech_nanman_mr3_1_engineers_of_war_han" or
		context:technology_record_key() == "3k_dlc06_tech_nanman_mr3_2_lays_of_the_land_nanman" )and context:faction():is_human()
    end,
    function(context) -- What to do if listener fires.
		
		local completed_military_missions_han=0
		if context:faction():has_technology("3k_dlc06_tech_nanman_mr1_1_advanced_battle_tactics_han") then 
			completed_military_missions_han = completed_military_missions_han+1
		end
		if context:faction():has_technology("3k_dlc06_tech_nanman_mr2_1_southern_hirelings_han") then 
			completed_military_missions_han = completed_military_missions_han+1
		end
		if context:faction():has_technology("3k_dlc06_tech_nanman_mr3_1_engineers_of_war_han") then 
			completed_military_missions_han = completed_military_missions_han+1
		end

		if 2<=completed_military_missions_han then
			cm:modify_faction(context:faction()):trigger_mission("3k_dlc06_nanman_tech_unlock_military_tier4_1", true)
		else
			cm:modify_faction(context:faction()):trigger_mission("3k_dlc06_nanman_tech_unlock_military_tier4_2", true)
		end	
	end,
	true, --is persistent
	nil, --completion event
	nil -- failure event
	);
---------------------------------------------------------
-----------------ECONOMIC TECH MISSIONS------------------
---------------------------------------------------------

-- Tier 1: Requires Tier 2 of a certain building or six food resources

-- Listener that unlocks the Tier 1 Techs and fires the next mission.
	core:add_listener(
	"MissionSucceededEconomicTechMission1", -- Unique handle
	"MissionSucceeded", -- Campaign Event to listen for
	function(context)
		return string.match(context:mission():mission_record_key(), "economic_tier1")
	end,
	function(context) -- What to do if listener fires.
		nanman_tech_manager:unlock_tech(context:faction():name(), "3k_dlc06_tech_nanman_eb1a_communal_incentivisation")
		nanman_tech_manager:unlock_tech(context:faction():name(), "3k_dlc06_tech_nanman_eb1b_established_processes")
		nanman_tech_manager:unlock_tech(context:faction():name(), "3k_dlc06_tech_nanman_eb1c_land_tax")
		nanman_tech_manager:unlock_tech(context:faction():name(), "3k_dlc06_tech_nanman_er1_1_centralised_storage_han")
		nanman_tech_manager:unlock_tech(context:faction():name(), "3k_dlc06_tech_nanman_er1_2_ancestral_farmland_nanman")
	end,
	true, --is persistent
	nil, --completion event
	nil -- failure event
	);

	-- Listener that ensures that economic missions are completed when you own the prober buildings
	--TODO: REMOVE AND DO THROUGH MISSION DATA INSTEAD (cdir_events_mission_option_junctions)
	core:add_listener(
	"MissionIssuedCheckEconomicTechMission", -- Unique handle
	"MissionIssued", -- Campaign Event to listen for
	function(context)
		return not context:mission():is_null_interface() and string.match(context:mission():mission_record_key(), "tech_unlock_economic_tier")
	end,
	function(context) -- What to do if listener fires.
		cm:set_saved_value("economic_mission_cqi"..context:faction():name(),context:mission():cqi(),"nanman_tech_missions")
	end,
	true, --is persistent
	nil, --completion event
	nil -- failure event
	);

-- Listener that ensures that economic missions objectives aren't missed
--TODO: REMOVE AND DO THROUGH MISSION DATA INSTEAD (cdir_events_mission_option_junctions)
core:add_listener(
	"FactionTurnStartCheckEconomicTechMission", -- Unique handle
	"FactionTurnStart", -- Campaign Event to listen for
	function(context)
		return context:faction():is_human() and cm:saved_value_exists("economic_mission_cqi"..context:faction():name(), "nanman_tech_missions")
	end,
	function(context) -- What to do if listener fires.
		local economical_cqi = cm:get_saved_value("economic_mission_cqi"..context:faction():name(),"nanman_tech_missions")


		
		local economic_mission_strings = {
			"3k_dlc06_nanman_king_meng_huo_tech_unlock_economic_tier1",
			"3k_dlc06_nanman_king_mulu_tech_unlock_economic_tier1",
			"3k_dlc06_nanman_king_shamoke_tech_unlock_economic_tier1",
			"3k_dlc06_nanman_lady_zhurong_tech_unlock_economic_tier1",
			"3k_dlc06_nanman_tech_unlock_economic_tier1",
			"3k_dlc06_nanman_tech_unlock_economic_tier2",
			"3k_dlc06_nanman_tech_unlock_economic_tier3",
			"3k_dlc06_nanman_tech_unlock_economic_tier4"
		}

		local economic_mission_active = false

		for i, mission_string in ipairs(economic_mission_strings) do
			if context:faction():is_mission_active(mission_string) then
				economic_mission_active = true
			end
		end


		if economical_cqi ~= "-1" and economic_mission_active then
			local economic_mission_modified = cm:modify_model():get_modify_mission_by_cqi(economical_cqi)
			if not economic_mission_modified:is_null_interface() then
				local economical_mission = economic_mission_modified:query_mission()
				if not economical_mission:is_null_interface() then
					local economical_mission_key = economical_mission:mission_record_key()
					local found_building = false;
					local region_list = context:faction():region_list()

					if string.match(economical_mission_key, "unlock_economic_tier1") then				
						if context:faction():name() == "3k_dlc06_faction_nanman_king_mulu" then
							for i = 0, region_list:num_items()-1 do
								local region = region_list:item_at(i)					
								found_building = region:building_exists("3k_resource_wood_tea_2") or region:building_exists("3k_resource_wood_tea_3") or region:building_exists("3k_resource_wood_tea_4") or region:building_exists("3k_resource_wood_tea_5") or region:building_exists("3k_resource_wood_tea_bandit_2") or region:building_exists("3k_resource_wood_tea_bandit_3") or region:building_exists("3k_resource_wood_tea_garden_4") or region:building_exists("3k_resource_wood_tea_garden_5")
							end
							
						elseif context:faction():name() == "3k_dlc06_faction_nanman_king_meng_huo" or context:faction():name() == "3k_dlc06_faction_nanman_lady_zhurong" then
							for i = 0, region_list:num_items()-1 do
								local region = region_list:item_at(i)					
								found_building = region:building_exists("3k_resource_fire_iron_2") or region:building_exists("3k_resource_fire_iron_3") or region:building_exists("3k_resource_fire_iron_military_4") or region:building_exists("3k_resource_fire_iron_military_5")	or region:building_exists("3k_resource_fire_iron_artisans_4") or region:building_exists("3k_resource_fire_iron_artisans_5") or region:building_exists("3k_resource_fire_iron_military_5") or region:building_exists("3k_resource_fire_iron_bandit_3")
							end
							
						end				
					elseif economical_mission_key=="3k_dlc06_nanman_tech_unlock_economic_tier2" then
						for i = 0, region_list:num_items()-1 do
							local region = region_list:item_at(i)
							found_building = region:building_exists("3k_resource_metal_tools_3") or region:building_exists("3k_resource_metal_tools_artisan_4") or region:building_exists("3k_resource_metal_tools_artisan_5") or region:building_exists("3k_resource_metal_tools_industry_4") or region:building_exists("3k_resource_metal_tools_industry_5")
						end
					elseif economical_mission_key=="3k_dlc06_nanman_tech_unlock_economic_tier3" then
						for i = 0, region_list:num_items()-1 do
							local region = region_list:item_at(i)
							found_building = region:building_exists("3k_resource_water_trading_port_4")	or region:building_exists("3k_resource_water_trading_port_5") or  region:building_exists("3k_resource_water_trading_port_industry_5") or region:building_exists("3k_resource_water_trading_port_spice_5")
						end
					end
					--If the building was found, complete the mission
					if found_building then
						context:modify_model():get_modify_faction(context:faction()):complete_custom_mission(economical_mission_key)
					end
				end
			end			
		end
	end,
	true, --is persistent
	nil, --completion event
	nil -- failure event
	);

	-- listener that starts the next mission after reaching the first economic tech
	core:add_listener(
    "ResearchCompletedEconomicTechMission1", -- Unique handle
    "ResearchCompleted", -- Campaign Event to listen for
	function(context) -- Listener condition
		local tech = context:technology_record_key()
        return string.match(tech,"3k_dlc06_tech_nanman_er1") and context:faction():is_human()
    end,
	function(context) -- What to do if listener fires.
		-- Fires next mission
		cm:modify_faction(context:faction()):trigger_mission("3k_dlc06_nanman_tech_unlock_economic_tier2", true)

		--Check if unite the tribes mission have been granted
		local event_generator = cm:query_model():event_generator_interface()
		local faction = context:faction()
		local mission = "3k_dlc06_progression_nanman_unite_the_tribes_mission"
		if not event_generator:any_of_missions_active(faction, mission) then
			-- Fires the united the tribes mission
			core:trigger_event("script_event_dlc06_" .. faction:name().."03");
		end

	end,
	true, --is persistent
	nil, --completion event
	nil -- failure event
	);

-- Tier 2: Requires Tier 3 Tools resource.

-- Listener that unlocks the Tier 2 Techs and fires the next mission.
core:add_listener(
	"MissionSucceededEconomicTechMission2", -- Unique handle
	"MissionSucceeded", -- Campaign Event to listen for
	function(context)
		return context:mission():mission_record_key() == "3k_dlc06_nanman_tech_unlock_economic_tier2"
		end,
		function(context) -- What to do if listener fires.
			local specialization = nanman_tech_manager.tech_specialisation_junctions[context:faction():name()];
			if specialization ~= nil then
				if nanman_fealty:get_sv_have_tribes_been_united_by_anyone() or specialization == "all" or specialization == "economics"  then
					nanman_tech_manager:unlock_tech(context:faction():name(), "3k_dlc06_tech_nanman_eb2a_industrial_expansion")
					nanman_tech_manager:unlock_tech(context:faction():name(), "3k_dlc06_tech_nanman_eb2b_artisans")
					nanman_tech_manager:unlock_tech(context:faction():name(), "3k_dlc06_tech_nanman_eb2c_way_of_the_land")
					nanman_tech_manager:unlock_tech(context:faction():name(), "3k_dlc06_tech_nanman_er2_1_division_of_labour_han")
					nanman_tech_manager:unlock_tech(context:faction():name(), "3k_dlc06_tech_nanman_er2_2_advanced_metalwork_nanman")
				end
			end
			--SAVE TECHNOLOGY PROGRESSION
			cm:set_saved_value("economic_tier2"..context:faction():name(),true,"tech_progression")
			cm:set_saved_value("economic_mission_cqi"..context:faction():name(),-1,"nanman_tech_missions") --TODO: REMOVE AND DO THROUGH MISSION DATA
		end,
		true, --is persistent
		nil, --completion event
		nil -- failure event
		);

	-- listener that starts the next mission after reaching the first economic tech
	core:add_listener(
    "ResearchCompletedEconomicTechMission2", -- Unique handle
    "ResearchCompleted", -- Campaign Event to listen for
	function(context) -- Listener condition
		local tech = context:technology_record_key()
        return string.match(tech,"3k_dlc06_tech_nanman_er2") and context:faction():is_human()
    end,
	function(context) -- What to do if listener fires.
		-- Fires next mission
		cm:modify_faction(context:faction()):trigger_mission("3k_dlc06_nanman_tech_unlock_economic_tier3", true)
	end,
	true, --is persistent
	nil, --completion event
	nil -- failure event
	);

-- Tier 3: Requires Tier 4 Trade Port resource.

-- Listener that unlocks the Tier 3 Techs
core:add_listener(
	"MissionSucceededEconomicTechMission3", -- Unique handle
	"MissionSucceeded", -- Campaign Event to listen for
	function(context)
		return context:mission():mission_record_key() == "3k_dlc06_nanman_tech_unlock_economic_tier3"
		end,
		function(context) -- What to do if listener fires.
			if nanman_fealty:get_sv_have_tribes_been_united_by_anyone() then
				nanman_tech_manager:unlock_tech(context:faction():name(), "3k_dlc06_tech_nanman_eb3a_riverside_waystations")
				nanman_tech_manager:unlock_tech(context:faction():name(), "3k_dlc06_tech_nanman_eb3b_civilised_society")
				nanman_tech_manager:unlock_tech(context:faction():name(), "3k_dlc06_tech_nanman_eb3c_resource_refinement")
				nanman_tech_manager:unlock_tech(context:faction():name(), "3k_dlc06_tech_nanman_er3_1_streamlined_governance_han")
				nanman_tech_manager:unlock_tech(context:faction():name(), "3k_dlc06_tech_nanman_er3_2_ancestral_belief_nanman")
			end
			--SAVE TECHNOLOGY PROGRESSION
			cm:set_saved_value("economic_tier3"..context:faction():name(),true,"tech_progression")
			cm:set_saved_value("economic_mission_cqi"..context:faction():name(),-1,"nanman_tech_missions") --TODO: REMOVE AND DO THROUGH MISSION DATA
		end,
		true, --is persistent
		nil, --completion event
		nil -- failure event
		);

-- Fires Tier 4 mission: Own 50 regions
core:add_listener(
	"ResearchCompletedEconomicTechMission4", -- Unique handle
	"ResearchCompleted", -- Campaign Event to listen for
	function(context)
		return context:technology_record_key() == "3k_dlc06_tech_nanman_er3_1_streamlined_governance_han" or 
		context:technology_record_key() =="3k_dlc06_tech_nanman_er3_2_ancestral_belief_nanman" and context:faction():is_human()
	end,
	function(context) -- What to do if listener fires.
		cm:modify_faction(context:faction()):trigger_mission("3k_dlc06_nanman_tech_unlock_economic_tier4", true)
	end,
	true, --is persistent
	nil, --completion event
	nil -- failure event
	);
		
---------------------------------------------------------
----------------POLITICAL TECH MISSIONS------------------
---------------------------------------------------------

	--When the political tier mission is issued, check if objecitves have been completed already.
	core:add_listener(
		"FactionTurnStartPoliticalTier1", -- Unique handle
		"FactionTurnStart", -- Campaign Event to listen for
		function(context)
			return context:faction():is_human() and cm:saved_value_exists("political_mission_cqi"..context:faction():name(),"nanman_tech_missions")
		end,
		function(context) -- What to do if listener fires.
			local faction = context:faction()
			local mission_key = cm:modify_model():get_modify_mission_by_cqi(cm:get_saved_value("political_mission_cqi"..context:faction():name(),"nanman_tech_missions")):query_mission():mission_record_key()
			--Know more than 10 factions
			if faction:factions_met():num_items() >= 10 then 
				context:modify_model():get_modify_faction(context:faction()):complete_scripted_mission_objective(mission_key,"3k_dlc06_scripted_know_ten_factions",true)
			end
			--Have signed a treaty
			if faction:has_specified_diplomatic_deal_with_anybody("treaty_components_non_aggression") or  
			faction:has_specified_diplomatic_deal_with_anybody("treaty_components_military_access") or
			faction:has_specified_diplomatic_deal_with_anybody("treaty_components_trade") then
				context:modify_model():get_modify_faction(context:faction()):complete_scripted_mission_objective(mission_key,"3k_dlc06_scripted_have_a_treaty",true)
			end
		end,
		true, --is persistent
		nil, --completion event
		nil -- failure event
		);

	-- Unlock by knowing 10 factions and having a deal with someone
	core:add_listener(
		"MissionSucceededPoliticalTechMission1", -- Unique handle
		"MissionSucceeded", -- Campaign Event to listen for
		function(context)
			return string.match(context:mission():mission_record_key(), "political_tier1")
		end,
		function(context) -- What to do if listener fires.
			nanman_tech_manager:unlock_tech(context:faction():name(), "3k_dlc06_tech_nanman_pb1a_commercial_enterprise")
			nanman_tech_manager:unlock_tech(context:faction():name(), "3k_dlc06_tech_nanman_pb1b_aggressive_negotiations")
			nanman_tech_manager:unlock_tech(context:faction():name(), "3k_dlc06_tech_nanman_pb1c_spice_ships")
			nanman_tech_manager:unlock_tech(context:faction():name(), "3k_dlc06_tech_nanman_pr1_1_methods_of_unification_han")
			nanman_tech_manager:unlock_tech(context:faction():name(), "3k_dlc06_tech_nanman_pr1_2_trade_hubs_nanman")
		end,
		true, --is persistent
		nil, --completion event
		nil -- failure event
		);

	-- listener that starts the next mission after reaching the first political tech
core:add_listener(
    "ResearchCompletedpoliticalTechMission1", -- Unique handle
    "ResearchCompleted", -- Campaign Event to listen for
	function(context) -- Listener condition
		local tech = context:technology_record_key()
        return string.match(tech,"3k_dlc06_tech_nanman_pr1") and context:faction():is_human()
    end,
	function(context) -- What to do if listener fires.
		-- Fires next mission
		cm:modify_faction(context:faction()):trigger_mission("3k_dlc06_nanman_tech_unlock_political_tier2", true)	

		--Check if unite the tribes mission have been granted
		local event_generator = cm:query_model():event_generator_interface()
		local faction = context:faction()
		local mission = "3k_dlc06_progression_nanman_unite_the_tribes_mission"
		if not event_generator:any_of_missions_active(faction, mission) then
			-- Fires the united the tribes mission
			core:trigger_event("script_event_dlc06_" .. faction:name().."03");
		end

	end,
	true, --is persistent
	nil, --completion event
	nil -- failure event
	);


-- Unlock Tier 2 by having 750 gold from trade deals

core:add_listener(
	"MissionSucceededPoliticalTechMission2", -- Unique handle
	"MissionSucceeded", -- Campaign Event to listen for
	function(context)
		return context:mission():mission_record_key() == "3k_dlc06_nanman_tech_unlock_political_tier2"
	end,
	function(context) -- What to do if listener fires.
		local specialization = nanman_tech_manager.tech_specialisation_junctions[context:faction():name()];
		if specialization ~= nil then
			if nanman_fealty:get_sv_have_tribes_been_united_by_anyone() or specialization == "all" or specialization == "politics"  then			
				nanman_tech_manager:unlock_tech(context:faction():name(), "3k_dlc06_tech_nanman_pb3a_refined_bureaucracy")
				nanman_tech_manager:unlock_tech(context:faction():name(), "3k_dlc06_tech_nanman_pb3b_centralised_administration")
				nanman_tech_manager:unlock_tech(context:faction():name(), "3k_dlc06_tech_nanman_pb3c_cultural_exchange")
				nanman_tech_manager:unlock_tech(context:faction():name(), "3k_dlc06_tech_nanman_pr3_1_bureaucratic_reform_han")
				nanman_tech_manager:unlock_tech(context:faction():name(), "3k_dlc06_tech_nanman_pr3_2_regional_investigations_nanman")
			end
		end
		--SAVE TECHNOLOGY PROGRESSION
		cm:set_saved_value("political_tier2"..context:faction():name(),true,"tech_progression")
	end,
	true, --is persistent
	nil, --completion event
	nil -- failure event
	);

	-- Fires Tier 3 mission.
	core:add_listener(
    "ResearchCompletedPoliticalTechMission3", -- Unique handle
    "ResearchCompleted", -- Campaign Event to listen for
	function(context) -- Listener condition
		return 
		(context:technology_record_key() == "3k_dlc06_tech_nanman_pr3_1_bureaucratic_reform_han" or 
		context:technology_record_key() == "3k_dlc06_tech_nanman_pr3_2_regional_investigations_nanman") and
		context:faction():is_human()
    end,
		function(context) -- What to do if listener fires.		
			if context:technology_record_key() == "3k_dlc06_tech_nanman_pr3_1_bureaucratic_reform_han" then
				cm:modify_faction(context:faction()):trigger_mission("3k_dlc06_nanman_tech_unlock_political_tier4_1", true)
			else
				-- Fires Tier 3 mission: Have one mercenary contract. Requires pr2_2 tech.
				start_tutorial_mission_listener(
					context:faction():name(),                          -- faction key
					"3k_dlc06_nanman_tech_unlock_political_tier4_2",   -- mission key
					"PERFORM_ASSIGNMENT",                                  -- objective type
					{
						"character_assignment 3k_dlc06_foreign_assignment_nanman_harass_enemy"
					},                                                  -- conditions (single string or table of strings)
					{
						"effect_bundle{bundle_key 3k_dlc06_payload_final_technology_political;turns 3;}"
					},                                                  -- mission rewards (table of strings)
					"script_event_dlc06_political_tier"..context:faction():name().."4_2",      -- trigger event 
					"script_event_dlc06_political_tier4_2Complete"     -- completion event
					)
				core:trigger_event("script_event_dlc06_political_tier"..context:faction():name().."4_2");
			end
		end,
		true, --is persistent
		nil, --completion event
		nil -- failure event
		);

	-- Fires Tier 4 mission.
	core:add_listener(
		"ResearchCompletedPoliticalTechMission2_1", -- Unique handle
		"ResearchCompleted", -- Campaign Event to listen for
		function(context) -- Listener condition
			return (context:technology_record_key() == "3k_dlc06_tech_nanman_pr2_1_demand_fealty_han" or
			context:technology_record_key() == "3k_dlc06_tech_nanman_pr2_2_contractual_obligations_nanman") and context:faction():is_human()
		end,
		function(context) -- What to do if listener fires.
			-- Fires Tier 4 mission: Have at least one vassal.
			if context:technology_record_key() == "3k_dlc06_tech_nanman_pr2_1_demand_fealty_han" then
				cm:modify_faction(context:faction()):trigger_mission("3k_dlc06_nanman_tech_unlock_political_tier3_1", true)
			else
			-- Fires Tier 4 mission: Have one mercenary contract.
				cm:modify_faction(context:faction()):trigger_mission("3k_dlc06_nanman_tech_unlock_political_tier3_2", true)
			end	
		end,
		true, --is persistent
		nil, --completion event
		nil -- failure event
	);

	-- listener that unlocks tier 3 tech.
    core:add_listener(
    "MissionSucceededPoliticalTechMission3", -- Unique handle
    "MissionSucceeded", -- Campaign Event to listen for
    function(context)
		return context:mission():mission_record_key() == "3k_dlc06_nanman_tech_unlock_political_tier4_1" or
		context:mission():mission_record_key() == "3k_dlc06_nanman_tech_unlock_political_tier4_2"
	end,
	function(context) -- What to do if listener fires.
		if nanman_fealty:get_sv_have_tribes_been_united_by_anyone() then
			nanman_tech_manager:unlock_tech(context:faction():name(), "3k_dlc06_tech_nanman_pb2a_intelligent_negotiations")
			nanman_tech_manager:unlock_tech(context:faction():name(), "3k_dlc06_tech_nanman_pb2b_promises_of_co_operation")
			nanman_tech_manager:unlock_tech(context:faction():name(), "3k_dlc06_tech_nanman_pb2c_tribal_council")
			nanman_tech_manager:unlock_tech(context:faction():name(), "3k_dlc06_tech_nanman_pr2_1_demand_fealty_han")
			nanman_tech_manager:unlock_tech(context:faction():name(), "3k_dlc06_tech_nanman_pr2_2_contractual_obligations_nanman")
		end		
		--SAVE TECHNOLOGY PROGRESSION
		cm:set_saved_value("political_tier3"..context:faction():name(),true,"tech_progression")
	end,
	true, --is persistent
	nil, --completion event
	nil -- failure event
	);

---------------------------------------------------------
-----------------TIER 4 TECH UNLOCKING-------------------
---------------------------------------------------------

-- Military Tech unlocks

core:add_listener(
	"MissionSucceededMilitaryTechMission4", -- Unique handle
	"MissionSucceeded", -- Campaign Event to listen for
	function(context)
		return context:mission():mission_record_key() == "3k_dlc06_nanman_tech_unlock_military_tier4_1" or
		context:mission():mission_record_key() == "3k_dlc06_nanman_tech_unlock_military_tier4_2"
	end,
        function(context) -- What to do if listener fires.
			nanman_tech_manager:unlock_tech(context:faction():name(), "3k_dlc06_tech_nanman_mr4_1_cavalry_contracts_han")
			nanman_tech_manager:unlock_tech(context:faction():name(), "3k_dlc06_tech_nanman_mr4_2_cave_networks_nanman")
			nanman_tech_manager:unlock_tech(context:faction():name(), "3k_dlc06_tech_nanman_mr4_3_military_hierarchy")
		end,
		true, --is persistent
		nil, --completion event
		nil -- failure event
		);

-- Political Tech Unlocks

core:add_listener(
	"MissionSucceededPoliticalTechMission4", -- Unique handle
	"MissionSucceeded", -- Campaign Event to listen for
	function(context)
		return context:mission():mission_record_key() == "3k_dlc06_nanman_tech_unlock_political_tier3_1" or 
		context:mission():mission_record_key() == "3k_dlc06_nanman_tech_unlock_political_tier3_2"
	end,
        function(context) -- What to do if listener fires.
			nanman_tech_manager:unlock_tech(context:faction():name(), "3k_dlc06_tech_nanman_pr4_1_diplomatic_authority_han")
			nanman_tech_manager:unlock_tech(context:faction():name(), "3k_dlc06_tech_nanman_pr4_2_manners_of_subterfuge_nanman")
			nanman_tech_manager:unlock_tech(context:faction():name(), "3k_dlc06_tech_nanman_pr4_3_provincial_inspectors")
		end,
		true, --is persistent
		nil, --completion event
		nil -- failure event
		);

	-- Economic Tech Unlocks
	core:add_listener(
		"MissionSucceededEconomicTechMission4", -- Unique handle
		"MissionSucceeded", -- Campaign Event to listen for
		function(context)
			return context:mission():mission_record_key() == "3k_dlc06_nanman_tech_unlock_economic_tier4"
        end,
        function(context) -- What to do if listener fires.
			nanman_tech_manager:unlock_tech(context:faction():name(), "3k_dlc06_tech_nanman_er4_1_centralised_labour_han")
			nanman_tech_manager:unlock_tech(context:faction():name(), "3k_dlc06_tech_nanman_er4_2_ancient_heritage_nanman")
			nanman_tech_manager:unlock_tech(context:faction():name(), "3k_dlc06_tech_nanman_er4_3_secrets_of_the_earth")
        end,
		true, --is persistent
		nil, --completion event
		nil -- failure event
		);

	--listener that unlocks the "Visibility over an random army"
	core:add_listener( 
	"ResearchCompletedPoliticalTech4VisibilityOverRandomArmy", -- Unique handle
    "ResearchCompleted", -- Campaign Event to listen for
	function(context) -- Listener condition
        return context:technology_record_key() == "3k_dlc06_tech_nanman_pr4_2_manners_of_subterfuge_nanman" and context:faction():is_human()
    end,
		function(context) -- What to do if listener fires.
			cm:set_saved_value("manners_of_subterfuge_unlocked"..context:faction():name(),true,"nanman_technology_unlock")
		end,
		true, --is persistent
		nil, --completion event
		nil -- failure event
		);	

	--At the start of each turn, grant visibility over the region that an random army from a faction the player has a treaty with (including war-treaties)
	core:add_listener(
		"FactionTurnStartVisibilityOverRandomArmy", -- Unique handle
		"FactionTurnStart", -- Campaign Event to listen for
		function(context)
			return not context:faction():is_null_interface() and context:faction():is_human() and cm:saved_value_exists("manners_of_subterfuge_unlocked"..context:faction():name(),"nanman_technology_unlock")
		end,
		function(context) -- What to do if listener fires.
			--Take a random character from a character list and make their region visible
			local function make_region_from_character_list_visible(character_list)
				--Remove potential garrisons, colonels and characters without military force (e.g. not deployed) characters from the list
				character_list = character_list:filter(function(character)
					return not misc:is_transient_character(character)
						and character:has_military_force()
				end);

				--Check if list is not empty
				if not character_list:is_empty() then

					--Pick a random number from the size of the character list.
					local r = cm:random_int(0, character_list:num_items()-1)
					--Get character and make the region visible
					local character = character_list:item_at(r)
					local military_force = character:military_force()

					if not character:is_null_interface() and character:has_region() then
						local region = character:region()
						context:modify_model():get_modify_faction(context:faction()):make_region_visible_in_shroud(region:name())
					--If region is null, try to get the character commanding geneneral region
					else 
						character = military_force:general_character()

						if not character:is_null_interface() and character:has_region() then 
							local force_leader_region = character:region()					
							if not force_leader_region:is_null_interface() then
								context:modify_model():get_modify_faction(context:faction()):make_region_visible_in_shroud(force_leader_region:name())
							end
						end
					end
				end
			end
			--Local function to check if the table has the value
			local function has_value (table_to_check, value)
				for i = 0, table.getn(table_to_check) do 
					local current_value = table_to_check[i]
					if current_value==value then
						return true
					end												
				end			
				return false
			end

			if cm:saved_value_exists("manners_of_subterfuge_unlocked"..context:faction():name(),"nanman_technology_unlock") then
				local manners_of_subterfuge_unlocked = cm:get_saved_value("manners_of_subterfuge_unlocked"..context:faction():name(),"nanman_technology_unlock")
				if manners_of_subterfuge_unlocked then
					--Find all the factions that the faction has a deal with
					local diplomacy_deal_list = context:faction():diplomatic_deal_list()
					local diplomacy_deal_list_unique = {};
					diplomacy_deal_list:foreach(function(deal)
						local diplomacy_deal_list_components = deal:components()
						diplomacy_deal_list_components:foreach(function(component)
							local proposer = component:proposer()
							if not proposer:is_null_interface() and proposer:name() ~= context:faction():name() and not has_value(diplomacy_deal_list_unique,proposer:name()) then
								table.insert(diplomacy_deal_list_unique,proposer:name()) --Insert faction name
							end
			
							local recipient = component:recipient()
							if not recipient:is_null_interface() and recipient:name() ~= context:faction():name() and not has_value(diplomacy_deal_list_unique,recipient:name()) then
								table.insert(diplomacy_deal_list_unique,recipient:name()) --Insert faction name
							end				
						end)		
					end)

					--Go through all the factions on the unique list and find a region to make visible.
					for i = 0, table.getn(diplomacy_deal_list_unique) do
						if diplomacy_deal_list_unique[i] ~= nil then
							local faction_name = diplomacy_deal_list_unique[i]
							local faction = cm:query_faction(faction_name)
							make_region_from_character_list_visible(faction:character_list())
						end
					end
				end
			end
		end,
		true --is persistent
		);

	--Listener that triggers the 3k_dlc06_nanman_tech_unlock_political_tier4_1 again, if the character dies
	core:add_listener( 
	"MissionCancelled3k_dlc06_nanman_tech_unlock_political_tier4_1", -- Unique handle
    "MissionCancelled", -- Campaign Event to listen for
	function(context) -- Listener condition
        return context:mission():mission_record_key() == "3k_dlc06_nanman_tech_unlock_political_tier4_1" and context:faction():is_human()
    end,
	function(context) -- What to do if listener fires.
		cm:modify_faction(context:faction()):trigger_mission("3k_dlc06_nanman_tech_unlock_political_tier4_1", true)
	end,
	true, --is persistent
	nil, --completion event
	nil -- failure event
	);
	
	--Listener that triggers the 3k_dlc06_nanman_tech_unlock_military_tier3_1 again, if the character dies
	core:add_listener( 
	"MissionCancelled3k_dlc06_nanman_tech_unlock_military_tier3_1", -- Unique handle
    "MissionCancelled", -- Campaign Event to listen for
	function(context) -- Listener condition
        return context:mission():mission_record_key() == "3k_dlc06_nanman_tech_unlock_military_tier3_1" and context:faction():is_human()
    end,
	function(context) -- What to do if listener fires.
		cm:modify_faction(context:faction()):trigger_mission("3k_dlc06_nanman_tech_unlock_military_tier3_1", true)
	end,
	true, --is persistent
	nil, --completion event
	nil -- failure event
	);	

	--Listener that triggers the 3k_dlc06_nanman_tech_unlock_military_tier3_2 again, if the character dies
	core:add_listener( 
	"MissionCancelled3k_dlc06_nanman_tech_unlock_military_tier3_2", -- Unique handle
    "MissionCancelled", -- Campaign Event to listen for
	function(context) -- Listener condition
        return context:mission():mission_record_key() == "3k_dlc06_nanman_tech_unlock_military_tier3_2" and context:faction():is_human()
    end,
	function(context) -- What to do if listener fires.
		cm:modify_faction(context:faction()):trigger_mission("3k_dlc06_nanman_tech_unlock_military_tier3_2", true)
	end,
	true, --is persistent
	nil, --completion event
	nil -- failure event
	);	

	--Listener that triggers the 3k_dlc06_nanman_tech_unlock_military_tier4_1 again, if the character dies
	core:add_listener( 
	"MissionCancelled3k_dlc06_nanman_tech_unlock_military_tier4_1", -- Unique handle
    "MissionCancelled", -- Campaign Event to listen for
	function(context) -- Listener condition
        return context:mission():mission_record_key() == "3k_dlc06_nanman_tech_unlock_military_tier4_1" and context:faction():is_human()
    end,
	function(context) -- What to do if listener fires.
		cm:modify_faction(context:faction()):trigger_mission("3k_dlc06_nanman_tech_unlock_military_tier4_1", true)
	end,
	true, --is persistent
	nil, --completion event
	nil -- failure event
	);	

	--Listener that triggers the 3k_dlc06_nanman_tech_unlock_military_tier4_1 again, if the character dies
	core:add_listener( 
	"MissionCancelled3k_dlc06_nanman_tech_unlock_military_tier4_2", -- Unique handle
    "MissionCancelled", -- Campaign Event to listen for
	function(context) -- Listener condition
        return context:mission():mission_record_key() == "3k_dlc06_nanman_tech_unlock_military_tier4_2" and context:faction():is_human()
    end,
	function(context) -- What to do if listener fires.
		cm:modify_faction(context:faction()):trigger_mission("3k_dlc06_nanman_tech_unlock_military_tier4_2", true)
	end,
	true, --is persistent
	nil, --completion event
	nil -- failure event
	);	

---------------------------------------------------------
--------------------UI Context --------------------------
---------------------------------------------------------		

-- List of techs to missions required.
techs_to_missions_meng_huo= {
	-- Tier 1 Economic
	["3k_dlc06_tech_nanman_eb1a_communal_incentivisation"] = {"3k_dlc06_nanman_king_meng_huo_tech_unlock_economic_tier1"},
	["3k_dlc06_tech_nanman_eb1b_established_processes"] = {"3k_dlc06_nanman_king_meng_huo_tech_unlock_economic_tier1"},
	["3k_dlc06_tech_nanman_eb1c_land_tax"] = {"3k_dlc06_nanman_king_meng_huo_tech_unlock_economic_tier1"},
	["3k_dlc06_tech_nanman_er1_1_centralised_storage_han"] = {"3k_dlc06_nanman_king_meng_huo_tech_unlock_economic_tier1"},
	["3k_dlc06_tech_nanman_er1_2_ancestral_farmland_nanman"] = {"3k_dlc06_nanman_king_meng_huo_tech_unlock_economic_tier1"},
	-- Tier 2 Economic
	["3k_dlc06_tech_nanman_eb2a_industrial_expansion"] = {"3k_dlc06_nanman_tech_unlock_economic_tier2"},
	["3k_dlc06_tech_nanman_eb2b_artisans"] = {"3k_dlc06_nanman_tech_unlock_economic_tier2"},
	["3k_dlc06_tech_nanman_eb2c_way_of_the_land"] = {"3k_dlc06_nanman_tech_unlock_economic_tier2"},
	["3k_dlc06_tech_nanman_er2_1_division_of_labour_han"] = {"3k_dlc06_nanman_tech_unlock_economic_tier2"},
	["3k_dlc06_tech_nanman_er2_2_advanced_metalwork_nanman"] = {"3k_dlc06_nanman_tech_unlock_economic_tier2"},
	-- Tier 3 Economic
	["3k_dlc06_tech_nanman_eb3a_riverside_waystations"] = {"3k_dlc06_nanman_tech_unlock_economic_tier3","3k_dlc06_progression_nanman_unite_the_tribes_mission"},
	["3k_dlc06_tech_nanman_eb3b_civilised_society"] = {"3k_dlc06_nanman_tech_unlock_economic_tier3","3k_dlc06_progression_nanman_unite_the_tribes_mission"},
	["3k_dlc06_tech_nanman_eb3c_resource_refinement"] = {"3k_dlc06_nanman_tech_unlock_economic_tier3","3k_dlc06_progression_nanman_unite_the_tribes_mission"},
	["3k_dlc06_tech_nanman_er3_1_streamlined_governance_han"] = {"3k_dlc06_nanman_tech_unlock_economic_tier3","3k_dlc06_progression_nanman_unite_the_tribes_mission"},
	["3k_dlc06_tech_nanman_er3_2_ancestral_belief_nanman"] = {"3k_dlc06_nanman_tech_unlock_economic_tier3","3k_dlc06_progression_nanman_unite_the_tribes_mission"},
	-- Tier 4 Economic
	["3k_dlc06_tech_nanman_er4_1_centralised_labour_han"] = {"3k_dlc06_nanman_tech_unlock_economic_tier4"},
	["3k_dlc06_tech_nanman_er4_2_ancient_heritage_nanman"] = {"3k_dlc06_nanman_tech_unlock_economic_tier4"},
	["3k_dlc06_tech_nanman_er4_3_secrets_of_the_earth"] = {"3k_dlc06_nanman_tech_unlock_economic_tier4"},
	-- Tier 1 Military
	["3k_dlc06_tech_nanman_mb1a_tribal_tenacity"] = {"3k_dlc06_nanman_king_meng_huo_tech_unlock_military_tier1"},
	["3k_dlc06_tech_nanman_mb1b_improved_spear_making"] = {"3k_dlc06_nanman_king_meng_huo_tech_unlock_military_tier1"},
	["3k_dlc06_tech_nanman_mb1c_professional_smithing"] = {"3k_dlc06_nanman_king_meng_huo_tech_unlock_military_tier1"},
	["3k_dlc06_tech_nanman_mr1_1_advanced_battle_tactics_han"] = {"3k_dlc06_nanman_king_meng_huo_tech_unlock_military_tier1"},
	["3k_dlc06_tech_nanman_mr1_2_tribal_zeal_nanman"] = {"3k_dlc06_nanman_king_meng_huo_tech_unlock_military_tier1"},
	-- Tier 2 Military
	["3k_dlc06_tech_nanman_mb2a_supply_chains"] = {"3k_dlc06_nanman_tech_unlock_military_tier2"},
	["3k_dlc06_tech_nanman_mb2b_tribal_conscription"] = {"3k_dlc06_nanman_tech_unlock_military_tier2"},
	["3k_dlc06_tech_nanman_mb2c_established_infrastructure"] = {"3k_dlc06_nanman_tech_unlock_military_tier2"},
	["3k_dlc06_tech_nanman_mr2_1_southern_hirelings_han"] = {"3k_dlc06_nanman_tech_unlock_military_tier2"},
	["3k_dlc06_tech_nanman_mr2_2_professional_soldiery_nanman"] = {"3k_dlc06_nanman_tech_unlock_military_tier2"},
	-- Tier 3 Military
	["3k_dlc06_tech_nanman_mb3a_marching_drills"] = {"3k_dlc06_nanman_tech_unlock_military_tier3_1", "3k_dlc06_nanman_tech_unlock_military_tier3_2","3k_dlc06_progression_nanman_unite_the_tribes_mission"},
	["3k_dlc06_tech_nanman_mb3b_training_camps"] = {"3k_dlc06_nanman_tech_unlock_military_tier3_1", "3k_dlc06_nanman_tech_unlock_military_tier3_2","3k_dlc06_progression_nanman_unite_the_tribes_mission"},
	["3k_dlc06_tech_nanman_mb3c_regimented_military"] = {"3k_dlc06_nanman_tech_unlock_military_tier3_1", "3k_dlc06_nanman_tech_unlock_military_tier3_2","3k_dlc06_progression_nanman_unite_the_tribes_mission"},
	["3k_dlc06_tech_nanman_mr3_1_engineers_of_war_han"] = {"3k_dlc06_nanman_tech_unlock_military_tier3_1", "3k_dlc06_nanman_tech_unlock_military_tier3_2","3k_dlc06_progression_nanman_unite_the_tribes_mission"},
	["3k_dlc06_tech_nanman_mr3_2_lays_of_the_land_nanman"] = {"3k_dlc06_nanman_tech_unlock_military_tier3_1", "3k_dlc06_nanman_tech_unlock_military_tier3_2","3k_dlc06_progression_nanman_unite_the_tribes_mission"},
	-- Tier 4 Military
	["3k_dlc06_tech_nanman_mr4_1_cavalry_contracts_han"] = {"3k_dlc06_nanman_tech_unlock_military_tier4_1", "3k_dlc06_nanman_tech_unlock_military_tier4_2"},
	["3k_dlc06_tech_nanman_mr4_2_cave_networks_nanman"] = {"3k_dlc06_nanman_tech_unlock_military_tier4_1", "3k_dlc06_nanman_tech_unlock_military_tier4_2"},
	["3k_dlc06_tech_nanman_mr4_3_military_hierarchy"] = {"3k_dlc06_nanman_tech_unlock_military_tier4_1", "3k_dlc06_nanman_tech_unlock_military_tier4_2"},
	-- Tier 1 Politcal
	["3k_dlc06_tech_nanman_pb1a_commercial_enterprise"] = {"3k_dlc06_nanman_king_meng_huo_tech_unlock_political_tier1"},
	["3k_dlc06_tech_nanman_pb1b_aggressive_negotiations"] = {"3k_dlc06_nanman_king_meng_huo_tech_unlock_political_tier1"},
	["3k_dlc06_tech_nanman_pb1c_spice_ships"] = {"3k_dlc06_nanman_king_meng_huo_tech_unlock_political_tier1"},
	["3k_dlc06_tech_nanman_pr1_1_methods_of_unification_han"] = {"3k_dlc06_nanman_king_meng_huo_tech_unlock_political_tier1"},
	["3k_dlc06_tech_nanman_pr1_2_trade_hubs_nanman"] = {"3k_dlc06_nanman_king_meng_huo_tech_unlock_political_tier1"},
	-- Tier 2 Politcal
	["3k_dlc06_tech_nanman_pb3a_refined_bureaucracy"] = {"3k_dlc06_nanman_tech_unlock_political_tier2"},
	["3k_dlc06_tech_nanman_pb3b_centralised_administration"] = {"3k_dlc06_nanman_tech_unlock_political_tier2"},
	["3k_dlc06_tech_nanman_pb3c_cultural_exchange"] = {"3k_dlc06_nanman_tech_unlock_political_tier2"},
	["3k_dlc06_tech_nanman_pr3_1_bureaucratic_reform_han"] = {"3k_dlc06_nanman_tech_unlock_political_tier2"},
	["3k_dlc06_tech_nanman_pr3_2_regional_investigations_nanman"] = {"3k_dlc06_nanman_tech_unlock_political_tier2"},
	-- Tier 3 Politcal
	["3k_dlc06_tech_nanman_pb2a_intelligent_negotiations"] = {"3k_dlc06_nanman_tech_unlock_political_tier4_1", "3k_dlc06_nanman_tech_unlock_political_tier4_2","3k_dlc06_progression_nanman_unite_the_tribes_mission"},
	["3k_dlc06_tech_nanman_pb2b_promises_of_co_operation"] = {"3k_dlc06_nanman_tech_unlock_political_tier4_1", "3k_dlc06_nanman_tech_unlock_political_tier4_2","3k_dlc06_progression_nanman_unite_the_tribes_mission"},
	["3k_dlc06_tech_nanman_pb2c_tribal_council"] = {"3k_dlc06_nanman_tech_unlock_political_tier4_1", "3k_dlc06_nanman_tech_unlock_political_tier4_2","3k_dlc06_progression_nanman_unite_the_tribes_mission"},
	["3k_dlc06_tech_nanman_pr2_1_demand_fealty_han"] = {"3k_dlc06_nanman_tech_unlock_political_tier4_1", "3k_dlc06_nanman_tech_unlock_political_tier4_2","3k_dlc06_progression_nanman_unite_the_tribes_mission"},
	["3k_dlc06_tech_nanman_pr2_2_contractual_obligations_nanman"] = {"3k_dlc06_nanman_tech_unlock_political_tier4_1", "3k_dlc06_nanman_tech_unlock_political_tier4_2","3k_dlc06_progression_nanman_unite_the_tribes_mission"},
	-- Tier 4 Politcal
	["3k_dlc06_tech_nanman_pr4_1_diplomatic_authority_han"] = {"3k_dlc06_nanman_tech_unlock_political_tier3_1", "3k_dlc06_nanman_tech_unlock_political_tier3_2"},
	["3k_dlc06_tech_nanman_pr4_2_manners_of_subterfuge_nanman"] = {"3k_dlc06_nanman_tech_unlock_political_tier3_1", "3k_dlc06_nanman_tech_unlock_political_tier3_2"},
	["3k_dlc06_tech_nanman_pr4_3_provincial_inspectors"] = {"3k_dlc06_nanman_tech_unlock_political_tier3_1", "3k_dlc06_nanman_tech_unlock_political_tier3_2"}
}
techs_to_missions_shamoke = {
	-- Tier 1 Economic
	["3k_dlc06_tech_nanman_eb1a_communal_incentivisation"] = {"3k_dlc06_nanman_king_shamoke_tech_unlock_economic_tier1"},
	["3k_dlc06_tech_nanman_eb1b_established_processes"] = {"3k_dlc06_nanman_king_shamoke_tech_unlock_economic_tier1"},
	["3k_dlc06_tech_nanman_eb1c_land_tax"] = {"3k_dlc06_nanman_king_shamoke_tech_unlock_economic_tier1"},
	["3k_dlc06_tech_nanman_er1_1_centralised_storage_han"] = {"3k_dlc06_nanman_king_shamoke_tech_unlock_economic_tier1"},
	["3k_dlc06_tech_nanman_er1_2_ancestral_farmland_nanman"] = {"3k_dlc06_nanman_king_shamoke_tech_unlock_economic_tier1"},
	-- Tier 2 Economic
	["3k_dlc06_tech_nanman_eb2a_industrial_expansion"] = {"3k_dlc06_nanman_tech_unlock_economic_tier2","3k_dlc06_progression_nanman_unite_the_tribes_mission"},
	["3k_dlc06_tech_nanman_eb2b_artisans"] = {"3k_dlc06_nanman_tech_unlock_economic_tier2","3k_dlc06_progression_nanman_unite_the_tribes_mission"},
	["3k_dlc06_tech_nanman_eb2c_way_of_the_land"] = {"3k_dlc06_nanman_tech_unlock_economic_tier2","3k_dlc06_progression_nanman_unite_the_tribes_mission"},
	["3k_dlc06_tech_nanman_er2_1_division_of_labour_han"] = {"3k_dlc06_nanman_tech_unlock_economic_tier2","3k_dlc06_progression_nanman_unite_the_tribes_mission"},
	["3k_dlc06_tech_nanman_er2_2_advanced_metalwork_nanman"] = {"3k_dlc06_nanman_tech_unlock_economic_tier2","3k_dlc06_progression_nanman_unite_the_tribes_mission"},
	-- Tier 3 Economic
	["3k_dlc06_tech_nanman_eb3a_riverside_waystations"] = {"3k_dlc06_nanman_tech_unlock_economic_tier3"},
	["3k_dlc06_tech_nanman_eb3b_civilised_society"] = {"3k_dlc06_nanman_tech_unlock_economic_tier3"},
	["3k_dlc06_tech_nanman_eb3c_resource_refinement"] = {"3k_dlc06_nanman_tech_unlock_economic_tier3"},
	["3k_dlc06_tech_nanman_er3_1_streamlined_governance_han"] = {"3k_dlc06_nanman_tech_unlock_economic_tier3"},
	["3k_dlc06_tech_nanman_er3_2_ancestral_belief_nanman"] = {"3k_dlc06_nanman_tech_unlock_economic_tier3"},
	-- Tier 4 Economic
	["3k_dlc06_tech_nanman_er4_1_centralised_labour_han"] = {"3k_dlc06_nanman_tech_unlock_economic_tier4"},
	["3k_dlc06_tech_nanman_er4_2_ancient_heritage_nanman"] = {"3k_dlc06_nanman_tech_unlock_economic_tier4"},
	["3k_dlc06_tech_nanman_er4_3_secrets_of_the_earth"] = {"3k_dlc06_nanman_tech_unlock_economic_tier4"},
	-- Tier 1 Military
	["3k_dlc06_tech_nanman_mb1a_tribal_tenacity"] = {"3k_dlc06_nanman_king_shamoke_tech_unlock_military_tier1"},
	["3k_dlc06_tech_nanman_mb1b_improved_spear_making"] = {"3k_dlc06_nanman_king_shamoke_tech_unlock_military_tier1"},
	["3k_dlc06_tech_nanman_mb1c_professional_smithing"] = {"3k_dlc06_nanman_king_shamoke_tech_unlock_military_tier1"},
	["3k_dlc06_tech_nanman_mr1_1_advanced_battle_tactics_han"] = {"3k_dlc06_nanman_king_shamoke_tech_unlock_military_tier1"},
	["3k_dlc06_tech_nanman_mr1_2_tribal_zeal_nanman"] = {"3k_dlc06_nanman_king_shamoke_tech_unlock_military_tier1"},
	-- Tier 2 Military
	["3k_dlc06_tech_nanman_mb2a_supply_chains"] = {"3k_dlc06_nanman_tech_unlock_military_tier2","3k_dlc06_progression_nanman_unite_the_tribes_mission"},
	["3k_dlc06_tech_nanman_mb2b_tribal_conscription"] = {"3k_dlc06_nanman_tech_unlock_military_tier2","3k_dlc06_progression_nanman_unite_the_tribes_mission"},
	["3k_dlc06_tech_nanman_mb2c_established_infrastructure"] = {"3k_dlc06_nanman_tech_unlock_military_tier2","3k_dlc06_progression_nanman_unite_the_tribes_mission"},
	["3k_dlc06_tech_nanman_mr2_1_southern_hirelings_han"] = {"3k_dlc06_nanman_tech_unlock_military_tier2","3k_dlc06_progression_nanman_unite_the_tribes_mission"},
	["3k_dlc06_tech_nanman_mr2_2_professional_soldiery_nanman"] = {"3k_dlc06_nanman_tech_unlock_military_tier2","3k_dlc06_progression_nanman_unite_the_tribes_mission"},
	-- Tier 3 Military
	["3k_dlc06_tech_nanman_mb3a_marching_drills"] = {"3k_dlc06_nanman_tech_unlock_military_tier3_1", "3k_dlc06_nanman_tech_unlock_military_tier3_2"},
	["3k_dlc06_tech_nanman_mb3b_training_camps"] = {"3k_dlc06_nanman_tech_unlock_military_tier3_1", "3k_dlc06_nanman_tech_unlock_military_tier3_2"},
	["3k_dlc06_tech_nanman_mb3c_regimented_military"] = {"3k_dlc06_nanman_tech_unlock_military_tier3_1", "3k_dlc06_nanman_tech_unlock_military_tier3_2"},
	["3k_dlc06_tech_nanman_mr3_1_engineers_of_war_han"] = {"3k_dlc06_nanman_tech_unlock_military_tier3_1", "3k_dlc06_nanman_tech_unlock_military_tier3_2"},
	["3k_dlc06_tech_nanman_mr3_2_lays_of_the_land_nanman"] = {"3k_dlc06_nanman_tech_unlock_military_tier3_1", "3k_dlc06_nanman_tech_unlock_military_tier3_2"},
	-- Tier 4 Military
	["3k_dlc06_tech_nanman_mr4_1_cavalry_contracts_han"] = {"3k_dlc06_nanman_tech_unlock_military_tier4_1", "3k_dlc06_nanman_tech_unlock_military_tier4_2"},
	["3k_dlc06_tech_nanman_mr4_2_cave_networks_nanman"] = {"3k_dlc06_nanman_tech_unlock_military_tier4_1", "3k_dlc06_nanman_tech_unlock_military_tier4_2"},
	["3k_dlc06_tech_nanman_mr4_3_military_hierarchy"] = {"3k_dlc06_nanman_tech_unlock_military_tier4_1", "3k_dlc06_nanman_tech_unlock_military_tier4_2"},
	-- Tier 1 Politcal
	["3k_dlc06_tech_nanman_pb1a_commercial_enterprise"] = {"3k_dlc06_nanman_king_shamoke_tech_unlock_political_tier1"},
	["3k_dlc06_tech_nanman_pb1b_aggressive_negotiations"] = {"3k_dlc06_nanman_king_shamoke_tech_unlock_political_tier1"},
	["3k_dlc06_tech_nanman_pb1c_spice_ships"] = {"3k_dlc06_nanman_king_shamoke_tech_unlock_political_tier1"},
	["3k_dlc06_tech_nanman_pr1_1_methods_of_unification_han"] = {"3k_dlc06_nanman_king_shamoke_tech_unlock_political_tier1"},
	["3k_dlc06_tech_nanman_pr1_2_trade_hubs_nanman"] = {"3k_dlc06_nanman_king_shamoke_tech_unlock_political_tier1"},
	-- Tier 2 Politcal
	["3k_dlc06_tech_nanman_pb3a_refined_bureaucracy"] = {"3k_dlc06_nanman_tech_unlock_political_tier2"},
	["3k_dlc06_tech_nanman_pb3b_centralised_administration"] = {"3k_dlc06_nanman_tech_unlock_political_tier2"},
	["3k_dlc06_tech_nanman_pb3c_cultural_exchange"] = {"3k_dlc06_nanman_tech_unlock_political_tier2"},
	["3k_dlc06_tech_nanman_pr3_1_bureaucratic_reform_han"] = {"3k_dlc06_nanman_tech_unlock_political_tier2"},
	["3k_dlc06_tech_nanman_pr3_2_regional_investigations_nanman"] = {"3k_dlc06_nanman_tech_unlock_political_tier2"},
	-- Tier 3 Politcal
	["3k_dlc06_tech_nanman_pb2a_intelligent_negotiations"] = {"3k_dlc06_nanman_tech_unlock_political_tier4_1", "3k_dlc06_nanman_tech_unlock_political_tier4_2","3k_dlc06_progression_nanman_unite_the_tribes_mission"},
	["3k_dlc06_tech_nanman_pb2b_promises_of_co_operation"] = {"3k_dlc06_nanman_tech_unlock_political_tier4_1", "3k_dlc06_nanman_tech_unlock_political_tier4_2","3k_dlc06_progression_nanman_unite_the_tribes_mission"},
	["3k_dlc06_tech_nanman_pb2c_tribal_council"] = {"3k_dlc06_nanman_tech_unlock_political_tier4_1", "3k_dlc06_nanman_tech_unlock_political_tier4_2","3k_dlc06_progression_nanman_unite_the_tribes_mission"},
	["3k_dlc06_tech_nanman_pr2_1_demand_fealty_han"] = {"3k_dlc06_nanman_tech_unlock_political_tier4_1", "3k_dlc06_nanman_tech_unlock_political_tier4_2","3k_dlc06_progression_nanman_unite_the_tribes_mission"},
	["3k_dlc06_tech_nanman_pr2_2_contractual_obligations_nanman"] = {"3k_dlc06_nanman_tech_unlock_political_tier4_1", "3k_dlc06_nanman_tech_unlock_political_tier4_2","3k_dlc06_progression_nanman_unite_the_tribes_mission"},
	-- Tier 4 Politcal
	["3k_dlc06_tech_nanman_pr4_1_diplomatic_authority_han"] = {"3k_dlc06_nanman_tech_unlock_political_tier3_1", "3k_dlc06_nanman_tech_unlock_political_tier3_2"},
	["3k_dlc06_tech_nanman_pr4_2_manners_of_subterfuge_nanman"] = {"3k_dlc06_nanman_tech_unlock_political_tier3_1", "3k_dlc06_nanman_tech_unlock_political_tier3_2"},
	["3k_dlc06_tech_nanman_pr4_3_provincial_inspectors"] = {"3k_dlc06_nanman_tech_unlock_political_tier3_1", "3k_dlc06_nanman_tech_unlock_political_tier3_2"}
}
techs_to_missions_mulu = {
	-- Tier 1 Economic
	["3k_dlc06_tech_nanman_eb1a_communal_incentivisation"] = {"3k_dlc06_nanman_king_mulu_tech_unlock_economic_tier1"},
	["3k_dlc06_tech_nanman_eb1b_established_processes"] = {"3k_dlc06_nanman_king_mulu_tech_unlock_economic_tier1"},
	["3k_dlc06_tech_nanman_eb1c_land_tax"] = {"3k_dlc06_nanman_king_mulu_tech_unlock_economic_tier1"},
	["3k_dlc06_tech_nanman_er1_1_centralised_storage_han"] = {"3k_dlc06_nanman_king_mulu_tech_unlock_economic_tier1"},
	["3k_dlc06_tech_nanman_er1_2_ancestral_farmland_nanman"] = {"3k_dlc06_nanman_king_mulu_tech_unlock_economic_tier1"},
	-- Tier 2 Economic
	["3k_dlc06_tech_nanman_eb2a_industrial_expansion"] = {"3k_dlc06_nanman_tech_unlock_economic_tier2"},
	["3k_dlc06_tech_nanman_eb2b_artisans"] = {"3k_dlc06_nanman_tech_unlock_economic_tier2"},
	["3k_dlc06_tech_nanman_eb2c_way_of_the_land"] = {"3k_dlc06_nanman_tech_unlock_economic_tier2"},
	["3k_dlc06_tech_nanman_er2_1_division_of_labour_han"] = {"3k_dlc06_nanman_tech_unlock_economic_tier2"},
	["3k_dlc06_tech_nanman_er2_2_advanced_metalwork_nanman"] = {"3k_dlc06_nanman_tech_unlock_economic_tier2"},
	-- Tier 3 Economic
	["3k_dlc06_tech_nanman_eb3a_riverside_waystations"] = {"3k_dlc06_nanman_tech_unlock_economic_tier3","3k_dlc06_progression_nanman_unite_the_tribes_mission"},
	["3k_dlc06_tech_nanman_eb3b_civilised_society"] = {"3k_dlc06_nanman_tech_unlock_economic_tier3","3k_dlc06_progression_nanman_unite_the_tribes_mission"},
	["3k_dlc06_tech_nanman_eb3c_resource_refinement"] = {"3k_dlc06_nanman_tech_unlock_economic_tier3","3k_dlc06_progression_nanman_unite_the_tribes_mission"},
	["3k_dlc06_tech_nanman_er3_1_streamlined_governance_han"] = {"3k_dlc06_nanman_tech_unlock_economic_tier3","3k_dlc06_progression_nanman_unite_the_tribes_mission"},
	["3k_dlc06_tech_nanman_er3_2_ancestral_belief_nanman"] = {"3k_dlc06_nanman_tech_unlock_economic_tier3","3k_dlc06_progression_nanman_unite_the_tribes_mission"},
	-- Tier 4 Economic
	["3k_dlc06_tech_nanman_er4_1_centralised_labour_han"] = {"3k_dlc06_nanman_tech_unlock_economic_tier4"},
	["3k_dlc06_tech_nanman_er4_2_ancient_heritage_nanman"] = {"3k_dlc06_nanman_tech_unlock_economic_tier4"},
	["3k_dlc06_tech_nanman_er4_3_secrets_of_the_earth"] = {"3k_dlc06_nanman_tech_unlock_economic_tier4"},
	-- Tier 1 Military
	["3k_dlc06_tech_nanman_mb1a_tribal_tenacity"] = {"3k_dlc06_nanman_king_mulu_tech_unlock_military_tier1"},
	["3k_dlc06_tech_nanman_mb1b_improved_spear_making"] = {"3k_dlc06_nanman_king_mulu_tech_unlock_military_tier1"},
	["3k_dlc06_tech_nanman_mb1c_professional_smithing"] = {"3k_dlc06_nanman_king_mulu_tech_unlock_military_tier1"},
	["3k_dlc06_tech_nanman_mr1_1_advanced_battle_tactics_han"] = {"3k_dlc06_nanman_king_mulu_tech_unlock_military_tier1"},
	["3k_dlc06_tech_nanman_mr1_2_tribal_zeal_nanman"] = {"3k_dlc06_nanman_king_mulu_tech_unlock_military_tier1"},
	-- Tier 2 Military
	["3k_dlc06_tech_nanman_mb2a_supply_chains"] = {"3k_dlc06_nanman_tech_unlock_military_tier2","3k_dlc06_progression_nanman_unite_the_tribes_mission"},
	["3k_dlc06_tech_nanman_mb2b_tribal_conscription"] = {"3k_dlc06_nanman_tech_unlock_military_tier2","3k_dlc06_progression_nanman_unite_the_tribes_mission"},
	["3k_dlc06_tech_nanman_mb2c_established_infrastructure"] = {"3k_dlc06_nanman_tech_unlock_military_tier2","3k_dlc06_progression_nanman_unite_the_tribes_mission"},
	["3k_dlc06_tech_nanman_mr2_1_southern_hirelings_han"] = {"3k_dlc06_nanman_tech_unlock_military_tier2","3k_dlc06_progression_nanman_unite_the_tribes_mission"},
	["3k_dlc06_tech_nanman_mr2_2_professional_soldiery_nanman"] = {"3k_dlc06_nanman_tech_unlock_military_tier2","3k_dlc06_progression_nanman_unite_the_tribes_mission"},
	-- Tier 3 Military
	["3k_dlc06_tech_nanman_mb3a_marching_drills"] = {"3k_dlc06_nanman_tech_unlock_military_tier3_1", "3k_dlc06_nanman_tech_unlock_military_tier3_2"},
	["3k_dlc06_tech_nanman_mb3b_training_camps"] = {"3k_dlc06_nanman_tech_unlock_military_tier3_1", "3k_dlc06_nanman_tech_unlock_military_tier3_2"},
	["3k_dlc06_tech_nanman_mb3c_regimented_military"] = {"3k_dlc06_nanman_tech_unlock_military_tier3_1", "3k_dlc06_nanman_tech_unlock_military_tier3_2"},
	["3k_dlc06_tech_nanman_mr3_1_engineers_of_war_han"] = {"3k_dlc06_nanman_tech_unlock_military_tier3_1", "3k_dlc06_nanman_tech_unlock_military_tier3_2"},
	["3k_dlc06_tech_nanman_mr3_2_lays_of_the_land_nanman"] = {"3k_dlc06_nanman_tech_unlock_military_tier3_1", "3k_dlc06_nanman_tech_unlock_military_tier3_2"},
	-- Tier 4 Military
	["3k_dlc06_tech_nanman_mr4_1_cavalry_contracts_han"] = {"3k_dlc06_nanman_tech_unlock_military_tier4_1", "3k_dlc06_nanman_tech_unlock_military_tier4_2"},
	["3k_dlc06_tech_nanman_mr4_2_cave_networks_nanman"] = {"3k_dlc06_nanman_tech_unlock_military_tier4_1", "3k_dlc06_nanman_tech_unlock_military_tier4_2"},
	["3k_dlc06_tech_nanman_mr4_3_military_hierarchy"] = {"3k_dlc06_nanman_tech_unlock_military_tier4_1", "3k_dlc06_nanman_tech_unlock_military_tier4_2"},
	-- Tier 1 Politcal
	["3k_dlc06_tech_nanman_pb1a_commercial_enterprise"] = {"3k_dlc06_nanman_king_mulu_tech_unlock_political_tier1"},
	["3k_dlc06_tech_nanman_pb1b_aggressive_negotiations"] = {"3k_dlc06_nanman_king_mulu_tech_unlock_political_tier1"},
	["3k_dlc06_tech_nanman_pb1c_spice_ships"] = {"3k_dlc06_nanman_king_mulu_tech_unlock_political_tier1"},
	["3k_dlc06_tech_nanman_pr1_1_methods_of_unification_han"] = {"3k_dlc06_nanman_king_mulu_tech_unlock_political_tier1"},
	["3k_dlc06_tech_nanman_pr1_2_trade_hubs_nanman"] = {"3k_dlc06_nanman_king_mulu_tech_unlock_political_tier1"},
	-- Tier 2 Politcal
	["3k_dlc06_tech_nanman_pb3a_refined_bureaucracy"] = {"3k_dlc06_nanman_tech_unlock_political_tier2","3k_dlc06_progression_nanman_unite_the_tribes_mission"},
	["3k_dlc06_tech_nanman_pb3b_centralised_administration"] = {"3k_dlc06_nanman_tech_unlock_political_tier2","3k_dlc06_progression_nanman_unite_the_tribes_mission"},
	["3k_dlc06_tech_nanman_pb3c_cultural_exchange"] = {"3k_dlc06_nanman_tech_unlock_political_tier2","3k_dlc06_progression_nanman_unite_the_tribes_mission"},
	["3k_dlc06_tech_nanman_pr3_1_bureaucratic_reform_han"] = {"3k_dlc06_nanman_tech_unlock_political_tier2","3k_dlc06_progression_nanman_unite_the_tribes_mission"},
	["3k_dlc06_tech_nanman_pr3_2_regional_investigations_nanman"] = {"3k_dlc06_nanman_tech_unlock_political_tier2","3k_dlc06_progression_nanman_unite_the_tribes_mission"},
	-- Tier 3 Politcal
	["3k_dlc06_tech_nanman_pb2a_intelligent_negotiations"] = {"3k_dlc06_nanman_tech_unlock_political_tier4_1", "3k_dlc06_nanman_tech_unlock_political_tier4_2"},
	["3k_dlc06_tech_nanman_pb2b_promises_of_co_operation"] = {"3k_dlc06_nanman_tech_unlock_political_tier4_1", "3k_dlc06_nanman_tech_unlock_political_tier4_2"},
	["3k_dlc06_tech_nanman_pb2c_tribal_council"] = {"3k_dlc06_nanman_tech_unlock_political_tier4_1", "3k_dlc06_nanman_tech_unlock_political_tier4_2"},
	["3k_dlc06_tech_nanman_pr2_1_demand_fealty_han"] = {"3k_dlc06_nanman_tech_unlock_political_tier4_1", "3k_dlc06_nanman_tech_unlock_political_tier4_2"},
	["3k_dlc06_tech_nanman_pr2_2_contractual_obligations_nanman"] = {"3k_dlc06_nanman_tech_unlock_political_tier4_1", "3k_dlc06_nanman_tech_unlock_political_tier4_2"},
	-- Tier 4 Politcal
	["3k_dlc06_tech_nanman_pr4_1_diplomatic_authority_han"] = {"3k_dlc06_nanman_tech_unlock_political_tier3_1", "3k_dlc06_nanman_tech_unlock_political_tier3_2"},
	["3k_dlc06_tech_nanman_pr4_2_manners_of_subterfuge_nanman"] = {"3k_dlc06_nanman_tech_unlock_political_tier3_1", "3k_dlc06_nanman_tech_unlock_political_tier3_2"},
	["3k_dlc06_tech_nanman_pr4_3_provincial_inspectors"] = {"3k_dlc06_nanman_tech_unlock_political_tier3_1", "3k_dlc06_nanman_tech_unlock_political_tier3_2"}
}
techs_to_missions_zhurong = {
	-- Tier 1 Economic
	["3k_dlc06_tech_nanman_eb1a_communal_incentivisation"] = {"3k_dlc06_nanman_lady_zhurong_tech_unlock_economic_tier1"},
	["3k_dlc06_tech_nanman_eb1b_established_processes"] = {"3k_dlc06_nanman_lady_zhurong_tech_unlock_economic_tier1"},
	["3k_dlc06_tech_nanman_eb1c_land_tax"] = {"3k_dlc06_nanman_lady_zhurong_tech_unlock_economic_tier1"},
	["3k_dlc06_tech_nanman_er1_1_centralised_storage_han"] = {"3k_dlc06_nanman_lady_zhurong_tech_unlock_economic_tier1"},
	["3k_dlc06_tech_nanman_er1_2_ancestral_farmland_nanman"] = {"3k_dlc06_nanman_lady_zhurong_tech_unlock_economic_tier1"},
	-- Tier 2 Economic
	["3k_dlc06_tech_nanman_eb2a_industrial_expansion"] = {"3k_dlc06_nanman_tech_unlock_economic_tier2","3k_dlc06_progression_nanman_unite_the_tribes_mission"},
	["3k_dlc06_tech_nanman_eb2b_artisans"] = {"3k_dlc06_nanman_tech_unlock_economic_tier2","3k_dlc06_progression_nanman_unite_the_tribes_mission"},
	["3k_dlc06_tech_nanman_eb2c_way_of_the_land"] = {"3k_dlc06_nanman_tech_unlock_economic_tier2","3k_dlc06_progression_nanman_unite_the_tribes_mission"},
	["3k_dlc06_tech_nanman_er2_1_division_of_labour_han"] = {"3k_dlc06_nanman_tech_unlock_economic_tier2","3k_dlc06_progression_nanman_unite_the_tribes_mission"},
	["3k_dlc06_tech_nanman_er2_2_advanced_metalwork_nanman"] = {"3k_dlc06_nanman_tech_unlock_economic_tier2","3k_dlc06_progression_nanman_unite_the_tribes_mission"},
	-- Tier 3 Economic
	["3k_dlc06_tech_nanman_eb3a_riverside_waystations"] = {"3k_dlc06_nanman_tech_unlock_economic_tier3"},
	["3k_dlc06_tech_nanman_eb3b_civilised_society"] = {"3k_dlc06_nanman_tech_unlock_economic_tier3"},
	["3k_dlc06_tech_nanman_eb3c_resource_refinement"] = {"3k_dlc06_nanman_tech_unlock_economic_tier3"},
	["3k_dlc06_tech_nanman_er3_1_streamlined_governance_han"] = {"3k_dlc06_nanman_tech_unlock_economic_tier3"},
	["3k_dlc06_tech_nanman_er3_2_ancestral_belief_nanman"] = {"3k_dlc06_nanman_tech_unlock_economic_tier3"},
	-- Tier 4 Economic
	["3k_dlc06_tech_nanman_er4_1_centralised_labour_han"] = {"3k_dlc06_nanman_tech_unlock_economic_tier4"},
	["3k_dlc06_tech_nanman_er4_2_ancient_heritage_nanman"] = {"3k_dlc06_nanman_tech_unlock_economic_tier4"},
	["3k_dlc06_tech_nanman_er4_3_secrets_of_the_earth"] = {"3k_dlc06_nanman_tech_unlock_economic_tier4"},
	-- Tier 1 Military
	["3k_dlc06_tech_nanman_mb1a_tribal_tenacity"] = {"3k_dlc06_nanman_lady_zhurong_tech_unlock_military_tier1"},
	["3k_dlc06_tech_nanman_mb1b_improved_spear_making"] = {"3k_dlc06_nanman_lady_zhurong_tech_unlock_military_tier1"},
	["3k_dlc06_tech_nanman_mb1c_professional_smithing"] = {"3k_dlc06_nanman_lady_zhurong_tech_unlock_military_tier1"},
	["3k_dlc06_tech_nanman_mr1_1_advanced_battle_tactics_han"] = {"3k_dlc06_nanman_lady_zhurong_tech_unlock_military_tier1"},
	["3k_dlc06_tech_nanman_mr1_2_tribal_zeal_nanman"] = {"3k_dlc06_nanman_lady_zhurong_tech_unlock_military_tier1"},
	-- Tier 2 Military
	["3k_dlc06_tech_nanman_mb2a_supply_chains"] = {"3k_dlc06_nanman_tech_unlock_military_tier2"},
	["3k_dlc06_tech_nanman_mb2b_tribal_conscription"] = {"3k_dlc06_nanman_tech_unlock_military_tier2"},
	["3k_dlc06_tech_nanman_mb2c_established_infrastructure"] = {"3k_dlc06_nanman_tech_unlock_military_tier2"},
	["3k_dlc06_tech_nanman_mr2_1_southern_hirelings_han"] = {"3k_dlc06_nanman_tech_unlock_military_tier2"},
	["3k_dlc06_tech_nanman_mr2_2_professional_soldiery_nanman"] = {"3k_dlc06_nanman_tech_unlock_military_tier2"},
	-- Tier 3 Military
	["3k_dlc06_tech_nanman_mb3a_marching_drills"] = {"3k_dlc06_nanman_tech_unlock_military_tier3_1", "3k_dlc06_nanman_tech_unlock_military_tier3_2","3k_dlc06_progression_nanman_unite_the_tribes_mission"},
	["3k_dlc06_tech_nanman_mb3b_training_camps"] = {"3k_dlc06_nanman_tech_unlock_military_tier3_1", "3k_dlc06_nanman_tech_unlock_military_tier3_2","3k_dlc06_progression_nanman_unite_the_tribes_mission"},
	["3k_dlc06_tech_nanman_mb3c_regimented_military"] = {"3k_dlc06_nanman_tech_unlock_military_tier3_1", "3k_dlc06_nanman_tech_unlock_military_tier3_2","3k_dlc06_progression_nanman_unite_the_tribes_mission"},
	["3k_dlc06_tech_nanman_mr3_1_engineers_of_war_han"] = {"3k_dlc06_nanman_tech_unlock_military_tier3_1", "3k_dlc06_nanman_tech_unlock_military_tier3_2","3k_dlc06_progression_nanman_unite_the_tribes_mission"},
	["3k_dlc06_tech_nanman_mr3_2_lays_of_the_land_nanman"] = {"3k_dlc06_nanman_tech_unlock_military_tier3_1", "3k_dlc06_nanman_tech_unlock_military_tier3_2","3k_dlc06_progression_nanman_unite_the_tribes_mission"},
	-- Tier 4 Military
	["3k_dlc06_tech_nanman_mr4_1_cavalry_contracts_han"] = {"3k_dlc06_nanman_tech_unlock_military_tier4_1", "3k_dlc06_nanman_tech_unlock_military_tier4_2"},
	["3k_dlc06_tech_nanman_mr4_2_cave_networks_nanman"] = {"3k_dlc06_nanman_tech_unlock_military_tier4_1", "3k_dlc06_nanman_tech_unlock_military_tier4_2"},
	["3k_dlc06_tech_nanman_mr4_3_military_hierarchy"] = {"3k_dlc06_nanman_tech_unlock_military_tier4_1", "3k_dlc06_nanman_tech_unlock_military_tier4_2"},
	-- Tier 1 Politcal
	["3k_dlc06_tech_nanman_pb1a_commercial_enterprise"] = {"3k_dlc06_nanman_lady_zhurong_tech_unlock_political_tier1"},
	["3k_dlc06_tech_nanman_pb1b_aggressive_negotiations"] = {"3k_dlc06_nanman_lady_zhurong_tech_unlock_political_tier1"},
	["3k_dlc06_tech_nanman_pb1c_spice_ships"] = {"3k_dlc06_nanman_lady_zhurong_tech_unlock_political_tier1"},
	["3k_dlc06_tech_nanman_pr1_1_methods_of_unification_han"] = {"3k_dlc06_nanman_lady_zhurong_tech_unlock_political_tier1"},
	["3k_dlc06_tech_nanman_pr1_2_trade_hubs_nanman"] = {"3k_dlc06_nanman_lady_zhurong_tech_unlock_political_tier1"},
	-- Tier 2 Politcal
	["3k_dlc06_tech_nanman_pb3a_refined_bureaucracy"] = {"3k_dlc06_nanman_tech_unlock_political_tier2","3k_dlc06_progression_nanman_unite_the_tribes_mission"},
	["3k_dlc06_tech_nanman_pb3b_centralised_administration"] = {"3k_dlc06_nanman_tech_unlock_political_tier2","3k_dlc06_progression_nanman_unite_the_tribes_mission"},
	["3k_dlc06_tech_nanman_pb3c_cultural_exchange"] = {"3k_dlc06_nanman_tech_unlock_political_tier2","3k_dlc06_progression_nanman_unite_the_tribes_mission"},
	["3k_dlc06_tech_nanman_pr3_1_bureaucratic_reform_han"] = {"3k_dlc06_nanman_tech_unlock_political_tier2","3k_dlc06_progression_nanman_unite_the_tribes_mission"},
	["3k_dlc06_tech_nanman_pr3_2_regional_investigations_nanman"] = {"3k_dlc06_nanman_tech_unlock_political_tier2","3k_dlc06_progression_nanman_unite_the_tribes_mission"},
	-- Tier 3 Politcal
	["3k_dlc06_tech_nanman_pb2a_intelligent_negotiations"] = {"3k_dlc06_nanman_tech_unlock_political_tier4_1", "3k_dlc06_nanman_tech_unlock_political_tier4_2"},
	["3k_dlc06_tech_nanman_pb2b_promises_of_co_operation"] = {"3k_dlc06_nanman_tech_unlock_political_tier4_1", "3k_dlc06_nanman_tech_unlock_political_tier4_2"},
	["3k_dlc06_tech_nanman_pb2c_tribal_council"] = {"3k_dlc06_nanman_tech_unlock_political_tier4_1", "3k_dlc06_nanman_tech_unlock_political_tier4_2"},
	["3k_dlc06_tech_nanman_pr2_1_demand_fealty_han"] = {"3k_dlc06_nanman_tech_unlock_political_tier4_1", "3k_dlc06_nanman_tech_unlock_political_tier4_2"},
	["3k_dlc06_tech_nanman_pr2_2_contractual_obligations_nanman"] = {"3k_dlc06_nanman_tech_unlock_political_tier4_1", "3k_dlc06_nanman_tech_unlock_political_tier4_2"},
	-- Tier 4 Politcal
	["3k_dlc06_tech_nanman_pr4_1_diplomatic_authority_han"] = {"3k_dlc06_nanman_tech_unlock_political_tier3_1", "3k_dlc06_nanman_tech_unlock_political_tier3_2"},
	["3k_dlc06_tech_nanman_pr4_2_manners_of_subterfuge_nanman"] = {"3k_dlc06_nanman_tech_unlock_political_tier3_1", "3k_dlc06_nanman_tech_unlock_political_tier3_2"},
	["3k_dlc06_tech_nanman_pr4_3_provincial_inspectors"] = {"3k_dlc06_nanman_tech_unlock_political_tier3_1", "3k_dlc06_nanman_tech_unlock_political_tier3_2"}
}
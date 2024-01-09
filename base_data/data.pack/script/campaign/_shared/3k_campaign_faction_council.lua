---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------
----- Name:			3k_campaign_faction_council.lua
----- Description: 	Three Kingdoms system to trigger missions for the faction based on settings.
---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------

cm:add_first_tick_callback_new(function() faction_council:new_game() end)
cm:add_first_tick_callback(function() 
	faction_council:initialise() 
	faction_council:debug_initialise()
	faction_council:specific_issue_listeners()
end); --Self register function

--***********************************************************************************************************
--***********************************************************************************************************
-- MAGIC NUMEBERS

local maximum_required_issues_per_post = 2; -- When assigning issues to each character post this sets the minimum number required
local season_of_council = "season_spring";

local cooldown_issue_cooldown_multiplier = 0.25; -- If an issue is considered 'on cooldown' then add here.
local cooldown_recently_fired_penalty = -4; -- A modifier on the weighting of an issue when sorting it's priority. weight + modifier
local cooldown_recently_fired_history = 50; -- how many cooldown values we can store MAX.
local cooldown_min_recent_issue_weighting = 10; -- Value to prevent issues being driven to less than a set amount by being on the recent list.

local turns_until_next_year =
{
	["season_spring"] = 0,
	["season_summer"] = 4,
	["season_harvest"] = 3,
	["season_autumn"] = 2,
	["season_winter"] = 1
}
local locked_council_reasons =
{
	-- Strings are mapped to keys in the campaign_localised_strings table, numeric value is used to sort display order
	["faction_council_availability_no_councilors"] = {"3k_main_faction_council_availability_no_councilors", 1},
	["faction_council_availability_already_triggered"]  = {"3k_main_faction_council_availability_already_triggered", 3},
	["faction_council_availability_unavailable_this_season"]  = {"3k_main_faction_council_availability_unavailable_this_season", 4},
}
local issue_data_index =
{
	suggestion_key_index = 1,
	faction_index = 2,
	character_cqi_index = 3,
	post_cqi_index = 4,
	target_index = 5,
	effect_bundle_index = 6,
	effect_bundle_duration_index = 7,
	gold_cost_index = 8,
	applies_scripted_effect_index = 9,
	target_scope_index = 10,
	suggestion_icon_index = 11,
	available_to_ai_index = 12,
	incident_key_source_index = 13,
	incident_blocks_effects_source_index = 14,
	incident_key_target_index = 15,
	incident_blocks_effects_target_index = 16,
	incident_key_global_index = 17,
	use_distance_weighting_mod_index = 18;
}

local major_han_factions = { -- all playable han factions
	"3k_dlc04_faction_empress_he",
	"3k_dlc04_faction_lu_zhi",
	"3k_dlc04_faction_prince_liu_chong",
	"3k_dlc05_faction_sun_ce",
	"3k_main_faction_cao_cao",
	"3k_main_faction_dong_zhuo",
	"3k_main_faction_gongsun_zan",
	"3k_main_faction_liu_bei",
	"3k_main_faction_lu_zhi",
	"3k_main_faction_sun_jian",
	"3k_main_faction_tao_qian",
	"3k_main_faction_yuan_shao",
	"3k_main_faction_kong_rong",
	"3k_main_faction_liu_biao",
	"3k_main_faction_liu_yan",
	"3k_main_faction_lu_bu",
	"3k_main_faction_ma_teng",
	"3k_main_faction_shi_xie",
	"3k_main_faction_yuan_shu",
	"ep_faction_prince_of_changsha",
	"ep_faction_prince_of_chengdu",
	"ep_faction_prince_of_chu",
	"ep_faction_prince_of_donghai",
	"ep_faction_prince_of_hejian",
	"ep_faction_prince_of_qi",
	"ep_faction_prince_of_runan",
	"ep_faction_prince_of_zhao",
}

--***********************************************************************************************************
--***********************************************************************************************************

faction_council = {
	enabled = true,
	last_turn_triggered = {},
	court_held_this_turn = {},
	faction_posts_list = {},
	current_suggestion_list = {};
	ministerial_positions_on_council = function(query_faction_interface)
		local ministerial_positions_to_council_seats = {}
		
		if not query_faction_interface:is_world_leader() then
			ministerial_positions_to_council_seats = 
			{
				["3k_main_court_offices_prime_minister"] = "prime_minister",
				["3k_main_court_offices_minister_fire"] = "defence_minister",
				["3k_main_court_offices_minister_metal"] = "construction_minister",
				["3k_main_court_offices_minister_water"] = "grand_tutor",
				["3k_main_court_offices_minister_wood"] = "civil_minister",
			}
		else
			ministerial_positions_to_council_seats = 
			{
				["3k_dlc04_court_offices_general_in_chief"] = "prime_minister",
				["3k_dlc04_court_offices_grand_commandant"] = "defence_minister",
				["3k_dlc04_court_offices_grand_excellency_of_works"] = "construction_minister",
				["3k_dlc04_court_offices_grand_excellency_over_the_masses"] = "civil_minister",
				["3k_dlc04_court_offices_grand_tutor"] = "grand_tutor",
			}
		end;
		return ministerial_positions_to_council_seats;
	end,
	backup_mission_key = "3k_main_council_backup_mission_key",
	-- Cooldowns
	starting_issue_keys_on_cooldown = {}; -- Add the issues which should be deprioritised in start here.
	issues_on_cooldown = {}; -- Saved. A list of all issue keys currently on cooldown.
	faction_council_pin_data = {}; -- Some council suggestions enable map pins
	initial_incident_triggered = {};
};

local personality_ceos = {
	-- Categorise the personality CEO's into 4 personality groups:
	-- Dominance = Direct, results oriented, firm, strong willed, foreceful
	-- Influence = Outgoing, enthusiastic, optimistic, spirted, lively
	-- Conscientious = Analystical, reserved, precise, private, systematic
	-- Steadiness =  Even-tempered, accomodating, patient, humble, tactful
	["3k_dlc06_ceo_trait_personality_animal_friend"] =  {ceo_archetype ="steadiness", ceo_weight = 3},
	["3k_main_ceo_trait_personality_aescetic"] =  {ceo_archetype ="steadiness", ceo_weight = 8},
	["3k_main_ceo_trait_personality_ambitious"] =  {ceo_archetype ="influence", ceo_weight = 9},
	["3k_main_ceo_trait_personality_arrogant"] =  {ceo_archetype ="influence", ceo_weight = 4},
	["3k_main_ceo_trait_personality_artful"] =  {ceo_archetype ="conscientious", ceo_weight = 5},
	["3k_main_ceo_trait_personality_brave"] =  {ceo_archetype ="influence", ceo_weight = 6},
	["3k_main_ceo_trait_personality_brilliant"] =  {ceo_archetype ="conscientious", ceo_weight = 10},
	["3k_main_ceo_trait_personality_careless"] =  {ceo_archetype ="dominance", ceo_weight = 3},
	["3k_main_ceo_trait_personality_cautious"] =  {ceo_archetype ="conscientious", ceo_weight = 4},
	["3k_main_ceo_trait_personality_charismatic"] =  {ceo_archetype ="steadiness", ceo_weight = 8},
	["3k_main_ceo_trait_personality_charitable"] =  {ceo_archetype ="steadiness", ceo_weight = 4},
	["3k_main_ceo_trait_personality_clever"] =  {ceo_archetype ="conscientious", ceo_weight = 7},
	["3k_main_ceo_trait_personality_competative"] =  {ceo_archetype ="influence", ceo_weight = 3},
	["3k_main_ceo_trait_personality_cowardly"] =  {ceo_archetype ="steadiness", ceo_weight = 3},
	["3k_main_ceo_trait_personality_cruel"] =  {ceo_archetype ="dominance", ceo_weight = 10},
	["3k_main_ceo_trait_personality_cunning"] =  {ceo_archetype ="conscientious", ceo_weight = 8},
	["3k_main_ceo_trait_personality_deceitful"] =  {ceo_archetype ="conscientious", ceo_weight = 6},
	["3k_main_ceo_trait_personality_defiant"] =  {ceo_archetype ="dominance", ceo_weight = 7},
	["3k_main_ceo_trait_personality_determined"] =  {ceo_archetype ="influence", ceo_weight = 5},
	["3k_main_ceo_trait_personality_direct"] =  {ceo_archetype ="dominance", ceo_weight = 6},
	["3k_main_ceo_trait_personality_disciplined"] =  {ceo_archetype ="conscientious", ceo_weight = 5},
	["3k_main_ceo_trait_personality_disloyal"] =  {ceo_archetype ="influence", ceo_weight = 3},
	["3k_main_ceo_trait_personality_distinguished"] =  {ceo_archetype ="dominance", ceo_weight = 5},
	["3k_main_ceo_trait_personality_dutiful"] =  {ceo_archetype ="steadiness", ceo_weight = 10},
	["3k_main_ceo_trait_personality_elusive"] =  {ceo_archetype ="conscientious", ceo_weight = 3},
	["3k_main_ceo_trait_personality_energetic"] =  {ceo_archetype ="steadiness", ceo_weight = 6},
	["3k_main_ceo_trait_personality_enigmatic"] =  {ceo_archetype ="influence", ceo_weight = 10},
	["3k_main_ceo_trait_personality_fiery"] =  {ceo_archetype ="dominance", ceo_weight = 9},
	["3k_main_ceo_trait_personality_fraternal"] =  {ceo_archetype ="influence", ceo_weight = 3},
	["3k_main_ceo_trait_personality_greedy"] =  {ceo_archetype ="dominance", ceo_weight = 4},
	["3k_main_ceo_trait_personality_honourable"] =  {ceo_archetype ="steadiness", ceo_weight = 7},
	["3k_main_ceo_trait_personality_humble"] =  {ceo_archetype ="steadiness", ceo_weight = 5},
	["3k_main_ceo_trait_personality_incompetent"] =  {ceo_archetype ="dominance", ceo_weight = 3},
	["3k_main_ceo_trait_personality_indecisive"] =  {ceo_archetype ="influence", ceo_weight = 2},
	["3k_main_ceo_trait_personality_intimidating"] =  {ceo_archetype ="dominance", ceo_weight = 8},
	["3k_main_ceo_trait_personality_kind"] =  {ceo_archetype ="steadiness", ceo_weight = 7},
	["3k_main_ceo_trait_personality_loyal"] =  {ceo_archetype ="steadiness", ceo_weight = 8},
	["3k_main_ceo_trait_personality_modest"] =  {ceo_archetype ="steadiness", ceo_weight = 5},
	["3k_main_ceo_trait_personality_pacifist"] =  {ceo_archetype ="conscientious", ceo_weight = 9},
	["3k_main_ceo_trait_personality_patient"] =  {ceo_archetype ="steadiness", ceo_weight = 6},
	["3k_main_ceo_trait_personality_perceptive"] =  {ceo_archetype ="conscientious", ceo_weight = 6},
	["3k_main_ceo_trait_personality_quiet"] =  {ceo_archetype ="steadiness", ceo_weight = 2},
	["3k_main_ceo_trait_personality_reckless"] =  {ceo_archetype ="influence", ceo_weight = 4},
	["3k_main_ceo_trait_personality_resourceful"] =  {ceo_archetype ="conscientious", ceo_weight = 4},
	["3k_main_ceo_trait_personality_scholarly"] =  {ceo_archetype ="conscientious", ceo_weight = 6},
	["3k_main_ceo_trait_personality_sincere"] =  {ceo_archetype ="steadiness", ceo_weight = 5},
	["3k_main_ceo_trait_personality_solitary"] =  {ceo_archetype ="steadiness", ceo_weight = 4},
	["3k_main_ceo_trait_personality_stubborn"] =  {ceo_archetype ="dominance", ceo_weight = 6},
	["3k_main_ceo_trait_personality_superstitious"] =  {ceo_archetype ="dominance", ceo_weight = 2},
	["3k_main_ceo_trait_personality_suspicious"] =  {ceo_archetype ="conscientious", ceo_weight = 3},
	["3k_main_ceo_trait_personality_trusting"] =  {ceo_archetype ="influence", ceo_weight = 5},
	["3k_main_ceo_trait_personality_unobservant"] =  {ceo_archetype ="dominance", ceo_weight = 3},
	["3k_main_ceo_trait_personality_vain"] =  {ceo_archetype ="influence", ceo_weight = 2},
	["3k_main_ceo_trait_personality_vengeful"] =  {ceo_archetype ="dominance", ceo_weight = 9},
	["3k_ytr_ceo_trait_personality_benevolent"] =  {ceo_archetype ="conscientious", ceo_weight = 10},
	["3k_ytr_ceo_trait_personality_gentle_hearted"] =  {ceo_archetype ="conscientious", ceo_weight = 5},
	["3k_ytr_ceo_trait_personality_heaven_bright"] =  {ceo_archetype ="conscientious", ceo_weight = 6},
	["3k_ytr_ceo_trait_personality_heaven_creative"] =  {ceo_archetype ="conscientious", ceo_weight = 4},
	["3k_ytr_ceo_trait_personality_heaven_honest"] =  {ceo_archetype ="steadiness", ceo_weight = 6},
	["3k_ytr_ceo_trait_personality_heaven_selfless"] =  {ceo_archetype ="steadiness", ceo_weight = 9},
	["3k_ytr_ceo_trait_personality_heaven_tolerant"] =  {ceo_archetype ="steadiness", ceo_weight = 7},
	["3k_ytr_ceo_trait_personality_heaven_tranquil"] =  {ceo_archetype ="steadiness", ceo_weight = 8},
	["3k_ytr_ceo_trait_personality_heaven_wise"] =  {ceo_archetype ="conscientious", ceo_weight = 8},
	["3k_ytr_ceo_trait_personality_land_alert"] =  {ceo_archetype ="conscientious", ceo_weight = 6},
	["3k_ytr_ceo_trait_personality_land_aspiring"] =  {ceo_archetype ="influence", ceo_weight = 6},
	["3k_ytr_ceo_trait_personality_land_composed"] =  {ceo_archetype ="dominance", ceo_weight = 7},
	["3k_ytr_ceo_trait_personality_land_courageous"] =  {ceo_archetype ="influence", ceo_weight = 9},
	["3k_ytr_ceo_trait_personality_land_generous"] =  {ceo_archetype ="steadiness", ceo_weight = 8},
	["3k_ytr_ceo_trait_personality_land_powerful"] =  {ceo_archetype ="dominance", ceo_weight = 8},
	["3k_ytr_ceo_trait_personality_land_proud"] =  {ceo_archetype ="dominance", ceo_weight = 5},
	["3k_ytr_ceo_trait_personality_people_amiable"] =  {ceo_archetype ="steadiness", ceo_weight = 5},
	["3k_ytr_ceo_trait_personality_people_cheerful"] =  {ceo_archetype ="influence", ceo_weight = 7},
	["3k_ytr_ceo_trait_personality_people_compassionate"] = {ceo_archetype ="influence", ceo_weight = 9},
	["3k_ytr_ceo_trait_personality_people_friendly"] =  {ceo_archetype ="influence", ceo_weight = 5},
	["3k_ytr_ceo_trait_personality_people_people_pleaser"] = {ceo_archetype ="influence", ceo_weight = 4},
	["3k_ytr_ceo_trait_personality_people_stern"] =  {ceo_archetype ="dominance", ceo_weight = 4},
	["3k_ytr_ceo_trait_personality_people_understanding"] =  {ceo_archetype ="influence", ceo_weight = 8},
	["3k_ytr_ceo_trait_personality_relentless"] =  {ceo_archetype ="dominance", ceo_weight = 7},
	["3k_ytr_ceo_trait_personality_simple"] =  {ceo_archetype ="steadiness", ceo_weight = 4},
	["3k_ytr_ceo_trait_personality_stalwart"] =  {ceo_archetype ="dominance", ceo_weight = 4},
	["3k_ytr_ceo_trait_personality_strong_willed"] =  {ceo_archetype ="dominance", ceo_weight = 6},
	["3k_ytr_ceo_trait_personality_temperamental"] =  {ceo_archetype ="dominance", ceo_weight = 3},
	["3k_ytr_ceo_trait_personality_trustworthy"] =  {ceo_archetype ="conscientious", ceo_weight = 7},
	["3k_ytr_ceo_trait_personality_vindictive"] =  {ceo_archetype ="dominance", ceo_weight = 10},
	["3k_main_ceo_trait_physical_agile"] =  {ceo_archetype ="conscientious", ceo_weight = 7},
	["3k_main_ceo_trait_physical_beautiful"] =  {ceo_archetype ="influence", ceo_weight = 6},
	["3k_main_ceo_trait_physical_blind"] =  {ceo_archetype ="steadiness", ceo_weight = 4},
	["3k_main_ceo_trait_physical_clumsy"] =  {ceo_archetype ="dominance", ceo_weight = 5},
	["3k_main_ceo_trait_physical_coordinated"] =  {ceo_archetype ="conscientious", ceo_weight = 6},
	["3k_main_ceo_trait_physical_decrepit"] =  {ceo_archetype ="influence", ceo_weight = 4},
	["3k_main_ceo_trait_physical_drunk"] =  {ceo_archetype ="dominance", ceo_weight = 8},
	["3k_main_ceo_trait_physical_eunuch"] =  {ceo_archetype ="influence", ceo_weight = 9},
	["3k_main_ceo_trait_physical_fat"] =  {ceo_archetype ="dominance", ceo_weight = 5},
	["3k_main_ceo_trait_physical_fertile"] =  {ceo_archetype ="steadiness", ceo_weight = 1},
	["3k_main_ceo_trait_physical_graceful"] =  {ceo_archetype ="conscientious", ceo_weight = 8},
	["3k_main_ceo_trait_physical_handsome"] =  {ceo_archetype ="influence", ceo_weight = 6},
	["3k_main_ceo_trait_physical_healthy"] =  {ceo_archetype ="steadiness", ceo_weight = 4},
	["3k_main_ceo_trait_physical_heartbroken"] =  {ceo_archetype ="conscientious", ceo_weight = 5},
	["3k_main_ceo_trait_physical_ill"] =  {ceo_archetype ="conscientious", ceo_weight = 3},
	["3k_main_ceo_trait_physical_infertile"] =  {ceo_archetype ="influence", ceo_weight = 1},
	["3k_main_ceo_trait_physical_lovestruck"] =  {ceo_archetype ="conscientious", ceo_weight = 5},
	["3k_main_ceo_trait_physical_lumbering"] =  {ceo_archetype ="dominance", ceo_weight = 4},
	["3k_main_ceo_trait_physical_mad"] =  {ceo_archetype ="dominance", ceo_weight = 3},
	["3k_main_ceo_trait_physical_poxxed"] =  {ceo_archetype ="conscientious", ceo_weight = 2},
	["3k_main_ceo_trait_physical_shu_tiger_general"] =  {ceo_archetype ="influence", ceo_weight = 10},
	["3k_main_ceo_trait_physical_sickly"] =  {ceo_archetype ="influence", ceo_weight = 2},
	["3k_main_ceo_trait_physical_strong"] =  {ceo_archetype ="dominance", ceo_weight = 7},
	["3k_main_ceo_trait_physical_sui_knight"] =  {ceo_archetype ="dominance", ceo_weight = 9},
	["3k_main_ceo_trait_physical_tough"] =  {ceo_archetype ="steadiness", ceo_weight = 7},
	["3k_main_ceo_trait_physical_weak"] =  {ceo_archetype ="influence", ceo_weight = 2},
	["3k_main_ceo_trait_physical_wei_elite_general"] =  {ceo_archetype ="influence", ceo_weight = 10},
	["3k_ytr_ceo_trait_physical_feared"] =  {ceo_archetype ="dominance", ceo_weight = 8},
	["3k_ytr_ceo_trait_physical_healer_of_people"] =  {ceo_archetype ="conscientious", ceo_weight = 6},
	["3k_ytr_ceo_trait_physical_impeccable"] =  {ceo_archetype ="steadiness", ceo_weight = 7},
	["3k_ytr_ceo_trait_physical_leader_of_people"] =  {ceo_archetype ="influence", ceo_weight = 10},
	["3k_dlc07_ceo_trait_personality_frivolous"] =  {ceo_archetype ="dominance", ceo_weight = 3},
}

--***********************************************************************************************************
--***********************************************************************************************************
-- INCLUDES
--***********************************************************************************************************
--***********************************************************************************************************

force_require("3k_campaign_faction_council_data"); -- All the issues fired by the cdir system.
force_require("3k_campaign_faction_council_missions"); -- Contains the missions for each issue in the cdir system.
force_require("3k_campaign_faction_council_scripted_missions"); -- Contains issues and missions fired from script.
force_require("3k_campaign_faction_council_world_data_queries"); -- All the issues fired by the cdir system.


--***********************************************************************************************************
--***********************************************************************************************************
-- LISTENERS
--***********************************************************************************************************
--***********************************************************************************************************

function faction_council:add_listeners()
	-- The UI sends a message to the system. Which will then fire missions.
    core:add_listener(
        "faction_council_invoke_council_listener", -- UID
        "ModelScriptNotificationEvent", -- Event
        function(model_script_notification_event) --"invoke_council"
            if model_script_notification_event:event_id() ~= "invoke_council" then
                return false;
            end;
            return self:can_trigger_council(cm:modify_faction(model_script_notification_event:faction()));
        end, --Conditions for firing
		function(model_script_notification_event)
            self:on_invoke_council( model_script_notification_event:faction(), model_script_notification_event:modify_model() );
        end, -- Function to fire.
        true -- Is Persistent?
	);
	
	-- Listen for a council suggestion being enacted, if it has script requirements we trigger them.
    core:add_listener(
        "faction_council_suggestion_actioned", -- UID
        "ModelScriptNotificationEvent", -- Event
        function(event)
			return string.find(event:event_id(), "3k_dlc07_faction_council_suggestion_enacted");
        end, --Conditions for firing
		function(event)
			local faction_key = event:faction():query_faction():name();
			local split_arr = string.split(event:event_id(), ";");

			if not split_arr or not is_table(split_arr) then
				script_error("ERROR: faction_council: Empty split_array passed in.")
				return false;
			end;
				
			if #split_arr ~= 2 then
				script_error(string.format("ERROR: faction_council: split_array does not have the correct number of values (Expected: 1+1, Revieved: %i).", #split_arr));
				return false;
			end;

			local suggestion_key = split_arr[2];

			self:apply_suggestion(faction_key, suggestion_key)
			
        end, -- Function to fire.
        true -- Is Persistent?
	);
	
	-- Listen for a council panel being closed, if a suggestion has been picked we set the feature on cooldown
    core:add_listener(
		"faction_council_panel_closed_listener", -- UID
		"PanelClosedCampaign", -- Event
		function(context)
			return context:component_id() == "faction_council_panel"
		end,
		function(context)
			-- Create a callback so we have the model interface and we can't do logic on a UI event because it desyncs MP
			context:create_model_callback_request("faction_council_screen_closed");
        end, -- Function to fire.
        true -- Is Persistent?
	);

	core:add_listener(
		"faction_council_panel_closed_listener_callback",
		"CampaignModelScriptCallback",
		function(callback_info)
			return callback_info:context():event_id() == "faction_council_screen_closed";
		end,
		function()
			local q_faction = cm:query_model():world():whose_turn_is_it()

			if not table_contains(major_han_factions, q_faction:name()) then -- Faction council is restricted to major han chinese
				return false;
			end;

			if self.last_turn_triggered[q_faction:name()] ~= nil then
				if self.last_turn_triggered[q_faction:name()] == cm:query_model():turn_number() then
					self.court_held_this_turn[q_faction:name()] = true
					self:feature_availability(cm:query_faction(q_faction:name()), cm:query_model())

					-- Mark all suggestions as having been seen (regardless of if they were enacted), so they don't fire again next season.
					self:add_all_active_issues_on_cooldown_using_faction_key(q_faction:name());
				end;
			end;
			
		end,
		true
	);

	-- Listen for the start of each factions turn to enable the feature in the spring
	core:add_listener(
		"faction_council_enable_council", -- UID
		"FactionTurnStart", -- Event
		function(context)
			return table_contains(major_han_factions, context:faction():name()); -- Faction council is restricted to major han chinese
		end, --Conditions for firing
		function(context)

			-- update state on turn start..
			self.court_held_this_turn[context:faction():name()] = false;

			-- Turns counter between council sessions needs to be updated each turn
			self.update_next_session_counter_ui_values();

			local is_human_faction = context:faction():is_human()
			local is_it_council_season = cm:query_model():season() == season_of_council
			local can_we_trigger_the_council = self:can_trigger_council(cm:modify_faction(context:faction()))

			if is_it_council_season and can_we_trigger_the_council then

				-- remove last year's map pins for the faction (if they exist)
				if not table.is_empty(self.faction_council_pin_data) then
					for _,pin in ipairs(self.faction_council_pin_data) do
						if pin.faction_key == context:faction() and pin.expiration_turn <= cm:query_model():turn_number() then
							cm:modify_model():get_modify_faction(context:faction()):get_map_pins_handler():remove_pin(pin.pin_cqi);
						end;
					end;
				end;

				-- if AI we basically force enact the council (if not on cooldown or disabled)
				if not is_human_faction then
					self:on_invoke_council(cm:modify_faction(context:faction()), cm:modify_model());
				end;

			end

			if is_human_faction then
				-- we want to update UI availability state even if it is not the turn we need to trigger the feature
				local is_available = self:feature_availability(cm:query_faction(context:faction()), cm:query_model())

				-- trigger an incident if this is the 1st time the council is available, and it's not the 1st turn
				if not self.initial_incident_triggered[context:faction():name()] and is_it_council_season and is_available and cm:query_model():turn_number() ~= 1 then
					
					local incident = cm:modify_model():create_incident("3k_dlc07_faction_council_ready_to_be_convened");
					incident:trigger(cm:modify_faction(context:faction()), true);
					self.initial_incident_triggered[context:faction():name()] = true
					
				end
			end

		end, -- Function to fire.
		true -- Is Persistent?
	);

	-- Listen for each faction ending summer and cache the characters they have
	core:add_listener(
		"faction_council_character_register_listener", -- UID
		"FactionTurnEnd", -- Event
		function(context)
			return table_contains(major_han_factions, context:faction():name()) and cm:query_model():season() == season_of_council; -- Faction council is restricted to major han chinese
		end, --Conditions for firing
		function(context)
			local faction_character_register = {};
			local saved_factions_character_data = {};

			-- Storing data of characters in factions so we can use it for issues.
			context:faction():character_list():foreach(function(filter_character) table.insert(faction_character_register, filter_character:command_queue_index()) end);
			saved_factions_character_data[context:faction():name().."_character_register"] = faction_character_register;
			cm:set_saved_value("3k_faction_characters_table", saved_factions_character_data);
		end, -- Function to fire.
		true -- Is Persistent?
	);

	-- Send FC values when the court panel is opened.
	core:add_listener(
		"faction_council_court_opened_listener",
		"PanelOpenedCampaign",
		function(context)
			return context:component_id() == "family_court_panel" 
		end,
		function(context)
			-- Create a callback so we have the model interface and we can't do logic on a UI event because it desyncs MP
			context:create_model_callback_request("faction_council_court_screen_opened");
		end,
		true
	);

	core:add_listener(
		"faction_council_court_opened_listener_callback",
		"CampaignModelScriptCallback",
		function(callback_info)
			return callback_info:context():event_id() == "faction_council_court_screen_opened";
		end,
		function()
			local q_faction = cm:query_model():world():whose_turn_is_it(); -- The callback doesn't give us a faction so we'll assume it's the current.

			if not table_contains(major_han_factions, q_faction:name()) then -- Faction council is restricted to major han chinese
				return false;
			end;
			local council_ministerial_positions = self.ministerial_positions_on_council(q_faction);
			self:set_faction_council_post_cqi_list(q_faction:name(), council_ministerial_positions);
		end,
		true
	);
end;


--***********************************************************************************************************
--***********************************************************************************************************
-- METHODS
--***********************************************************************************************************
--***********************************************************************************************************

--// new_game
--// Sets up the system for first run.
function faction_council:new_game()
	-- Set the issues which start on cooldown.
	for _, issue in ipairs(self.starting_issue_keys_on_cooldown) do
		self:add_issue_on_cooldown_using_suggestion_key(issue);
	end
end;

--// initialise()
--// Sets up the system on game load.
function faction_council:initialise()
	out.events("faction_council:initialise(): Initialise" );
	
	local update_ui_state_of_availability = function()
		local local_faction_interface = cm:query_local_faction(true)
		if local_faction_interface and local_faction_interface:is_human() then
			self:feature_availability(local_faction_interface, cm:query_model())
		end
	end

    --Get element count
    local issue_count = 0
	for _ in pairs(self.valid_issues_table) do issue_count = issue_count + 1 end
	
    inc_tab();
    out.events("Is Enabled: " .. tostring(self.enabled) );
	out.events("Issue Count: " .. issue_count );
	dec_tab();

	self:update_next_session_counter_ui_values();
	self:update_council_post_ui_values();
	update_ui_state_of_availability();
	
	-- Add the listeners.
	self:add_listeners();
end;

function faction_council:on_invoke_council(modify_faction, modify_model)
	out.events("faction_council: Invoking council.");
	local query_faction_interface = modify_faction:query_faction();
	local faction_key = query_faction_interface:name();

	-- Clear out our existing data.
	self:clear_exisiting_council_data_for_this_faction(query_faction_interface:command_queue_index());

	-- check the faction for a power token and configure their council seats to the court minister positions
	local council_ministerial_positions = self.ministerial_positions_on_council(query_faction_interface);
	self:set_faction_council_post_cqi_list(faction_key, council_ministerial_positions);

	if self:feature_availability(query_faction_interface, modify_model:query_model()) then
		local valid_issue_keys = {}
		valid_issue_keys = self:get_valid_issues(query_faction_interface, modify_faction, modify_model, self.valid_issues_table ); -- filter to remove non-ai issues

		-- Set character posts and create the issues list
		local faction_character_posts = query_faction_interface:character_posts();
		-- create a reserved issues list which we use to ensure that each councilor has unique options
		local reserved_issues_table = {}

		for i=0, faction_character_posts:num_items() - 1 do
			local post = faction_character_posts:item_at(i);

			-- Check if the post is in our list and someone holds it.
			if not post:is_null_interface()
			and council_ministerial_positions[post:ministerial_position_record_key()]
			and post:current_post_holders() > 0 then
				local post_holder = post:post_holders():item_at(0);

				local post_holder_bias_matched_issues = self:filter_issues_by_bias(self:get_character_bias(post_holder), valid_issue_keys, self.valid_issues_table, reserved_issues_table, faction_key)
				-- sort issues by priority and return the minimum required for a post and then add them to the reserved list
				local post_holder_assigned_issues = self:get_issues_to_suggest_by_weighting(post_holder_bias_matched_issues, query_faction_interface:is_human(), faction_key)

				for _,v in ipairs(post_holder_assigned_issues) do
					table.insert(reserved_issues_table, {v, post_holder:command_queue_index(), post:cqi()})
					self:add_to_active_list(v, modify_faction:query_faction(), post_holder, post, self.valid_issues_table)
					-- Index
						-- (string)Issue ID
						-- (int) Faction CQI
						-- (int) Character CQI of post holder
						-- (int)CQI of post
						-- (function returns int) Target CQI reference
						-- (string) Effect bundle key
						-- (int) Effect bundle duration in turns
						-- (int) Gold cost of this option
						-- (bool) Scripted effect
						-- (string) scope
						-- (bool) available to AI
						-- (string) suggestion icon name located in (//branches/3k/guandu/three_kingdoms/working_data/UI/skins/default)
						-- (optional string) incident key target
				end;
			end;
		end;

		if not query_faction_interface:is_human() then
			for _, v in ipairs(reserved_issues_table) do
				self:apply_suggestion(query_faction_interface:name(), v[1])
				self:add_issue_on_cooldown_using_suggestion_key(query_faction_interface:name(), v[1])
			end;
		else
			-- Update UI values if this is a human faction
			self:update_suggestion_ui_values()
		end;
	else
		-- council was not held, return reasons to the UI to be shown in the panel
		out.events("faction_council:on_invoke_council(): Council invoked by UI but is presently unavailable.");
	end;
end;

function faction_council:feature_availability(query_faction_interface, query_model_interface)
	local faction_character_posts = query_faction_interface:character_posts();
	local council_ministerial_positions = self.ministerial_positions_on_council(query_faction_interface);
	local reasons_table = {};

	-- check if the faction has ministers in court positions which are involved in the council
	local council_populated = false;
	for i=0, faction_character_posts:num_items() - 1 do
		local post = faction_character_posts:item_at(i);
		if not post:is_null_interface()
		and council_ministerial_positions[post:ministerial_position_record_key()]
		and post:current_post_holders() > 0 then
			council_populated = true;
			break;
		end;
	end;

	if not council_populated then
		local reason_key = "faction_council_availability_no_councilors";
		if locked_council_reasons[reason_key] == nil then
			script_error("ERROR: faction_council:feature_availability - locked_council_reasons table does not contain key: " .. reason_key );
		else
			reasons_table[reason_key] = locked_council_reasons[reason_key];
		end;
	end;

	-- Faction council is concened once per year, check that this is the correct season
	if cm:query_model():season() ~= season_of_council then
		local reason_key = "faction_council_availability_unavailable_this_season";
		if locked_council_reasons[reason_key] == nil then
			script_error("ERROR: faction_council:feature_availability - locked_council_reasons table does not contain key: " .. reason_key );
		else	
			reasons_table[reason_key] = locked_council_reasons[reason_key];
		end;
	end;

	-- Check if council has already been called into session this year (suggestion has been actioned)
	if self.court_held_this_turn[query_faction_interface:name()] == true then
		local reason_key = "faction_council_availability_already_triggered";
		if locked_council_reasons[reason_key] == nil then
			script_error("ERROR: faction_council:feature_availability - locked_council_reasons table does not contain key: " .. reason_key );
		else	
			reasons_table[reason_key] = locked_council_reasons[reason_key];
		end;
	end;

	if query_faction_interface:is_human() then
		self:update_panel_accessibility_ui_values(reasons_table)
	end;

	-- If the reasons table is not empty we return to the UI the reason why
	if not table.is_empty(reasons_table) then
		return false;
	end;

	-- No reason for the feature being unavailable
	return true;
end;

--// get_valid_issues(query_faction, modify_faction_interface, modify_model_interface, table)
--// Gets all the currently valid issues for the council.
function faction_council:get_valid_issues(query_faction, modify_faction, modify_model, raw_issue_list)
	-- Add new missions.
    local l_valid_issue_keys = {};

    -- Step 1 - Find which 'issues' can fire.
    for k, v in pairs(raw_issue_list) do
		-- Filter out AI issues at this stage to save the time of testing all the issues on turn_start for every faction in the game.
        if (query_faction:is_human() or v.available_to_ai) and v.effect_target(modify_faction, modify_model) ~= nil then
            table.insert(l_valid_issue_keys, k);
        end;
    end;

    -- Step 2 - If we can fire ANY missions, clear out the old missions. Doing this here so we don't wipe the missions and then have none to give. 
    if l_valid_issue_keys == nil or #l_valid_issue_keys <= 0 then
        out.events("faction_council:get_valid_issues(): No Valid Issues Found.");
    else
        out.events("faction_council:get_valid_issues(): Valid Missions: " .. #l_valid_issue_keys);
	end;
	
	return l_valid_issue_keys;
end;

local base_distance_weight_mod = 1.2;
local region_distance_range_size = 2;
local number_of_region_ranges = 5;
local distance_weight_mod_decay = 0.2;

-- Returns the n highest weighted values from a discreet list passed in. n = maximum_required_issues_per_post, or 1 if AI.
function faction_council:get_issues_to_suggest_by_weighting(valid_issue_keys, is_human, faction_key)
	local weighted_issues = {};

	local issues_required = maximum_required_issues_per_post;
	if not is_human then -- AI only ever gets one issue.
		issues_required = 1;
	end;

	-- If we have enough or fewer issues than we need then skip everything else as the result won't change.
	if #valid_issue_keys <= issues_required then
		return valid_issue_keys;
	end

	-- Cache the weightings of the issues once to save grabbing them constantly. 
	for i, issue_key in ipairs(valid_issue_keys) do
		local issue_data = self.valid_issues_table[issue_key];
		local issue_weight = issue_data.weighting_value

		if not issue_data then
			script_error("ERROR: Faction council: Cannot find issue data for issue_key [" .. tostring(issue_key) .. "]");
		else
			-- If issue is on cooldown do the multiply OR abs reduce value. Doing both felt like double dipping.
			if self:is_issue_on_cooldown(faction_key, issue_key) then 
				issue_weight = issue_weight * cooldown_issue_cooldown_multiplier 
			else
				issue_weight = issue_weight + (self:times_issue_fired_recently(faction_key, issue_key) * cooldown_recently_fired_penalty);
				issue_weight = math.max(issue_weight, cooldown_min_recent_issue_weighting); -- The issue weight can be reduced to less than issues which have been 0ed out by distance/cooldown, so always make sure these are clamped to a max.
			end
			
			if issue_data.use_distance_weighting_mod then
				local distance_from_source_faction_capital_region = self:query_distance_to_region(
					issue_data.effect_target(cm:modify_faction(faction_key), cm:modify_model()), 
					issue_data.scope, 
					cm:query_faction(faction_key):capital_region():name()
				);

				local weighting_modifier = faction_council:calculate_weighting_modifier_from_distance(
					distance_from_source_faction_capital_region,
					base_distance_weight_mod,
					region_distance_range_size, 
					number_of_region_ranges, 
					distance_weight_mod_decay
				);

				issue_weight = issue_weight * weighting_modifier
			end;

			if not is_human then
				issue_weight = issue_weight * issue_data.ai_weighting_multiplier;
			end
			
			table.insert(weighted_issues, {issue_key, issue_weight})
		end;
	end;

	-- Get the N highest weighting issues.
	local return_array = {};
	for i = 1, issues_required do
		local highest_score = -1;
		local highest_issue_key = nil;

		for i, v in ipairs(weighted_issues) do
			if not table.contains(return_array, v[1]) and v[2] > highest_score then
				highest_issue_key = v[1];
				highest_score = v[2];
			end;
		end;

		table.insert(return_array, highest_issue_key);
	end;
	
	return return_array;

end;


--// get_character_bias(character_interface_interface)
--// Get the character personality archetype as determined by their personality ceos
--// Thia is a subjective concept, in this case based upon the DiSC profile (Walter Clark 1940)
--// The groups are Dominance, Inflcuence, Conscientiousness and Steadiness
function faction_council:get_character_bias(query_character)

	if query_character:is_null_interface() then
		return nil;
	end;

	if query_character:ceo_management():is_null_interface()  then
		return nil;
	end;

	local character_personality_ceo_keys_list = query_character:ceo_management():all_ceos_for_category("3k_main_ceo_category_traits_personality");
	local character_personality_values =
	{
		["steadiness"] = 0,
		["conscientious"] = 0,
		["dominance"] = 0,
		["influence"] = 0,
	}
	
	--// Pass in a character interface, check its personality ceos
	--// Sum the weighting values of each of the personality ceo on the character
	for i = 0, character_personality_ceo_keys_list:num_items() -1 do
		if not personality_ceos[character_personality_ceo_keys_list:item_at(i):ceo_data_key()] then
			out.design("WARNING: faction_council:get_character_bias - Unexpected personality trait of " .. character_personality_ceo_keys_list:item_at(i):ceo_data_key() .. " exists on character with CQI: ".. query_character.command_queue_index() ..". Add  this ceo entry to personality_ceos table in _shared\3k_campaign_faction_council.lua with weight value (1-10) and one of the 4 existing archetypes.");
		else
			local personality_ceo = personality_ceos[character_personality_ceo_keys_list:item_at(i):ceo_data_key()]

			if personality_ceo.ceo_archetype ~= nil then
				character_personality_values[personality_ceo.ceo_archetype] = character_personality_values[personality_ceo.ceo_archetype] + personality_ceo.ceo_weight;
			else
				script_error("ERROR: faction_council:get_character_bias - Supplied ceo data key: " .. character_personality_ceo_keys_list:item_at(i):ceo_data_key() .. " has returned a nil value." );
			end;
		end;
	end;

	--// Sort the character personalities table by the weighting values
	local sorted_table = {}
	for k, v in pairs(character_personality_values) do 
		table.insert(sorted_table, {k,v}) 
	end
	table.sort(sorted_table, function(a,b) return a[2] > b[2] end)

	return sorted_table;
end;

--// filter_issues_by_bias(table, table, table, table)
--// Matches potential suggestions to characters based on personality affiliation
function faction_council:filter_issues_by_bias( character_bias_table, issue_keys_table, valid_issues_table, reserved_issues, faction_key)
	local filtered_issues_list = {};
	local issue_bias_match_requirement = 1;
	local bias_matched_required_issues_per_post = 2;

	-- remove issues that are being used by other characters from the issue_keys_table
	if not table.is_empty(reserved_issues) then
		for _, l in ipairs(reserved_issues) do
			for i = #issue_keys_table, 1, -1 do
				if  issue_keys_table[i] ==  l[1] then
					table.remove(issue_keys_table, i)
				end;
			end;
		end;
	end;

	-- If the weight of the first element on the sorted list is 0 all values are zero
	-- We can assume that the character is using a set of personaility ceos that are not
	-- accounted for, as a result we do not filter by bias (but do remove reserved issues)
	if character_bias_table[1][2] == 0 then
		return issue_keys_table;
	end

	-- Find which issues can match this character's bias.
	for _, personality_bias in ipairs(character_bias_table) do
		for _, v in pairs(issue_keys_table) do
			if not table.contains(filtered_issues_list, v) and valid_issues_table[v].personality_priorities[personality_bias[1]] >= issue_bias_match_requirement then
				table.insert(filtered_issues_list, v);
				if self:is_issue_on_cooldown(faction_key, v) then
					-- increase the pool of options if one of the suggestions considered is currently on cooldown (to a maximum of 4)
					if bias_matched_required_issues_per_post < 4 then
						bias_matched_required_issues_per_post = bias_matched_required_issues_per_post +1;
					end;
				end;
			end;
		end;
		-- we only cycle through other personality bias whilst we do not have enough issues on the list
		if table.length(filtered_issues_list) >= bias_matched_required_issues_per_post then
			return filtered_issues_list;
		else
			issue_bias_match_requirement = issue_bias_match_requirement - 0.25;
		end
	end

	-- the only way we get here is if there are 1 or fewer issues on the list
	return filtered_issues_list;
end;

--// clear_exisiting_council_data_for_this_faction(faction_cqi)
--// Cancels all missions currently available
function faction_council:clear_exisiting_council_data_for_this_faction(faction_cqi)
	out.events("faction_council:trigger_faction_council(): Cancelling suggestions for faction " .. faction_cqi);

	for i = #self.current_suggestion_list, 1, -1 do -- Go in reverse as we'll be removing items.
		if is_number(self.current_suggestion_list[i]) or self.current_suggestion_list[i][issue_data_index.faction_index] == faction_cqi then
			table.remove(self.current_suggestion_list, i); -- Also remove the mission from our tracker. We used to delete the table but mp needs to work with multiple factions.
		end;
	end;

	local faction_key = cm:query_model():faction_for_command_queue_index(faction_cqi):name();

	if self.faction_posts_list[faction_key] then
		self.faction_posts_list[faction_key] = nil;
	end;
end;

--***********************************************************************************************************
--***********************************************************************************************************
-- HELPERS
--***********************************************************************************************************
--***********************************************************************************************************

--// is_council_suggestion(string)
--// Returns true if the supplied string matches a valid issue key.
function faction_council:is_council_suggestion(suggestion_context)
    if self.valid_issues_table[suggestion_context] == nil then
        return false;
    end;

    return true;
end;


--// query_distance_to_region (int, string, string)
--// returns int
function faction_council:query_distance_to_region(obj_cqi, obj_type, target_region_key)
	if not is_number(obj_cqi) then
		script_error("ERROR: query_distance_to_region() called but supplied cqi value of [" .. tostring(target_region_key) .. "] is not a number");
		return math.huge;
	end;

	local target_region_query_interface = cm:query_region(target_region_key);
	if not target_region_query_interface or target_region_query_interface:is_null_interface() then
		script_error("ERROR: query_distance_to_region() called but supplied value [" .. tostring(target_region_key) .. "] is not a valid region key");
		return math.huge;
	end;

	local supported_obj_types ={
		["character"] = function (cqi)
			return cm:query_model():character_for_command_queue_index(cqi);
		end,
		["force"] = function (cqi)
			return cm:query_model():military_force_for_command_queue_index(cqi);
		end,
		["faction"] = function (cqi)
			return cm:query_model():faction_for_command_queue_index(cqi);
		end,
		["region"] = function (cqi)
			local filtered_region_list = cm:query_model():world():region_manager():region_list():filter(function(filter_region)
				return filter_region:command_queue_index() == cqi;
			end)
			return filtered_region_list:item_at(0);
		end
	};
	if not supported_obj_types[obj_type] then
		script_error("ERROR: query_distance_to_region() called but supplied object type key [" .. tostring(obj_type) .. "] is not one of expected [character], [force], [faction] or [region] keys");
		return math.huge;
	end;

	local query_interface = supported_obj_types[obj_type](obj_cqi);
	if not query_interface or query_interface:is_null_interface() then
		script_error("ERROR: query_distance_to_region() called but supplied [" .. tostring(obj_type) .. "] with command queue index of [" .. tostring(obj_cqi) .. "] returns a null interface");
		return math.huge;
	end;

	if obj_type == "character" and not query_interface:is_deployed() then -- guard against characters not being present on map
		return 99;
	end;

	local distance_value = query_interface:distance_to_region(cm:query_region(target_region_key))
	if not is_number(distance_value) then
		return math.huge;
	end;

	return distance_value;
end;


--// query_distance_to_capital (int, string, string)
--// returns int
function faction_council:query_distance_to_capital(obj_cqi, obj_type, target_faction_key)
	local target_faction_query_interface = cm:query_faction(target_faction_key);
	if not target_faction_query_interface or target_faction_query_interface:is_null_interface() then
		script_error("ERROR: query_distance_to_capital() called but supplied value [" .. tostring(target_faction_query_interface) .. "] is not a valid faction key");
		return math.huge;
	end;

	local target_capital_region_query_interface = target_faction_query_interface:capital_region()
	if not target_capital_region_query_interface or target_capital_region_query_interface:is_null_interface() then
		script_error("ERROR: query_distance_to_capital() called but supplied value [" .. tostring(target_faction_query_interface) .. "] has no capital region");
		return math.huge;
	end;

	local supported_obj_types ={
		["character"] = function (cqi)
			return self:query_model():character_for_command_queue_index(cqi);
		end,
		["force"] = function (cqi)
			return self:query_model():military_force_for_command_queue_index(cqi);
		end,
		["faction"] = function (cqi)
			return self:query_model():faction_for_command_queue_index(cqi);
		end,
		["region"] = function (cqi)
			local filtered_region_list = cm:query_model():world():region_manager():region_list():filter(function(filter_region)
				return filter_region:command_queue_index() == cqi;
			end)
			return filtered_region_list:item_at(0);
		end
	};
	if not supported_obj_types[obj_type] then
		script_error("ERROR: query_distance_to_region() called but supplied object type key [" .. tostring(obj_type) .. "] is not one of expected [character], [force], [faction] or [region] keys");
		return math.huge;
	end;

	local query_interface = supported_obj_types[obj_type](obj_cqi);
	if not query_interface or query_interface:is_null_interface() then
		script_error("ERROR: query_distance_to_region() called but supplied [" .. tostring(obj_type) .. "] with command queue index of [" .. tostring(obj_cqi) .. "] returns a null interface");
		return math.huge;
	end;

	if obj_type == "character" and not query_interface:is_deployed() then -- guard against characters not being present on map
		return 99;
	end;

	local distance_value = query_interface:capital_region_distance(cm:query_region(target_capital_region_query_interface))
	if not is_number(distance_value) then
		return math.huge;
	end;

	return distance_value;
end;


--// calculate_weighting_modifier_from_distance(string)
--// Returns foat
--// Takes values for number of regions between two points on the map, a base modifier value, a number of distance ranges to check, the incremental value of each distance range and a decay rate
--// It calculates which number range the supplied distance value is within and applies the given decay rate to the base modifier value. If the distance is outside of the provided scope we retun a 0 modifer value
function faction_council:calculate_weighting_modifier_from_distance(int_distance, float_base_modifier_value, int_region_distance_increments, int_number_of_distance_ranges, float_modifier_value_decay)

	if float_base_modifier_value - (float_modifier_value_decay*(int_number_of_distance_ranges-1)) < 0 then
		out.design("WARNING: faction_council:calculate_weighting_modifier_from_distance - Supplied values may produce negative weighting modifier values, this should not happen");
		-- Return a weighting value mod of 1 which would have no impact on the result.
		return 1;
	end;

	for i = 1, int_number_of_distance_ranges do
		local max_distance = i*int_region_distance_increments;

		if int_distance <= max_distance then
			return float_base_modifier_value - (float_modifier_value_decay*(i-1));
		end;
	end;
	
	-- If the distance is outside of the provided range we return 0
    return 0;
end;


--// apply_suggestion(string, string)
--// called by a listener after recieving a UI event, applies effects of suggestions actioned by the user.
function faction_council:apply_suggestion(faction_key, suggestion_key)
	if self.last_turn_triggered[faction_key] ~= nil then
	 	if self.last_turn_triggered[faction_key] ~= cm:query_model():turn_number() then
			self.last_turn_triggered[faction_key] = cm:query_model():turn_number();
		 end;
	else
		self.last_turn_triggered[faction_key] = cm:query_model():turn_number();
	end;

	local source_q_faction = cm:query_faction(faction_key);

	-- find the index of the suggestion on the current_suggestion_list which has been passed back by UI
	local index;
    for i = #self.current_suggestion_list, 1, -1 do
        if self.current_suggestion_list[i][issue_data_index.suggestion_key_index] == suggestion_key and self.current_suggestion_list[i][issue_data_index.faction_index] == source_q_faction:command_queue_index() then
			if index == nil then
				index = i;
				break;
			end;
        end;
	end;
	if index == nil then
		script_error("ERROR: faction_council:apply_suggestion - Suggestion of ".. suggestion_key.." does not exist on the current suggestion list.");
		return;
	end;
	
	-- apply effect bundle attached to the suggestion against it's matched target
	local incident_fired = false; -- Use this to decide if we apply effect bundles and scripted effects when an incident is triggered.

	if self.current_suggestion_list[index][issue_data_index.effect_bundle_index] then
		local suggestion_modify_interface, target_q_faction = self:get_suggestion_modify_interface_and_owner_faction(self.current_suggestion_list[index][issue_data_index.target_scope_index], self.current_suggestion_list[index][issue_data_index.target_index], faction_key)
		
		-- check that we have a modify interface accessible to this function
		if suggestion_modify_interface == nil then
			script_error("ERROR: faction_council:apply_suggestion - get_suggestion_modify_interface returned nil, expected modify interface.");
			return;
		elseif suggestion_modify_interface:is_null_interface() then
			script_error("ERROR: faction_council:apply_suggestion - get_suggestion_modify_interface returned a null interface.");
			return;
		elseif self.current_suggestion_list[index][issue_data_index.effect_bundle_duration_index] == nil or not is_number(self.current_suggestion_list[index][issue_data_index.effect_bundle_duration_index]) then
			script_error("ERROR: faction_council:apply_suggestion - Supplied duration parameter is either nil or an integer.");
			return false;
		else
			local incident_fired_source = false;
			local incident_fired_target = false;

			-- Trigger incident for the human source
			if self.valid_issues_table[suggestion_key].incident_key_source and source_q_faction:is_human() then
				self:fire_council_action_incident_for_target(
					self.valid_issues_table[suggestion_key].incident_key_source,
					source_q_faction,
					cm:query_character(self.current_suggestion_list[index][issue_data_index.character_cqi_index]),
					suggestion_modify_interface
				);

				incident_fired_source = true;
			end;

			-- Trigger incident for the human target.
			if self.valid_issues_table[suggestion_key].incident_key_global then
				local human_faction_interfaces_list = cm:query_model():world():faction_list():filter(function(filter_faction)
					return filter_faction:is_human() and not filter_faction == source_q_faction
				 end)
				if not human_faction_interfaces_list:is_empty() then 
					for i = 0, human_faction_interfaces_list:num_items() -1 do
						self:fire_council_action_incident_for_target(
							human_faction_interfaces_list:item_at(i):name(),
							target_q_faction, 
							cm:query_character(self.current_suggestion_list[index][issue_data_index.character_cqi_index]),
							suggestion_modify_interface
						);
					end;
					incident_fired_target = true;
				end;
			else
				if self.valid_issues_table[suggestion_key].incident_key_target and target_q_faction:is_human() then
					self:fire_council_action_incident_for_target(
						self.valid_issues_table[suggestion_key].incident_key_target,
						target_q_faction, 
						cm:query_character(self.current_suggestion_list[index][issue_data_index.character_cqi_index]),
						suggestion_modify_interface
					);

					incident_fired_target = true;
				end; 
			end;

			-- Apply the effect bundle, if it's not prevented by the preceeding incidents.
			if (not incident_fired_target or not self.valid_issues_table[suggestion_key].incident_blocks_effects_target)
			and (not incident_fired_source or not self.valid_issues_table[suggestion_key].incident_blocks_effects_source) then

				suggestion_modify_interface:apply_effect_bundle(self.current_suggestion_list[index][issue_data_index.effect_bundle_index], self.current_suggestion_list[index][issue_data_index.effect_bundle_duration_index]);
			end;

			-- Only attempt treasury transactions if the cost of the suggestion is greater than 0, and don't try to take more money than a faction has
			local cost = math.min(self.current_suggestion_list[index][issue_data_index.gold_cost_index], cm:query_faction(faction_key):treasury())
			if cost > 0 then
				cm:modify_faction(faction_key):decrease_treasury(cost);
			end;		
		end;

	else
		script_error("ERROR: faction_council:apply_effect_bundle - suggestion list at index".. index .."effect bundle/element 6 returned nil.");
		return;
	end;

	-- some suggestions may have post-conditions that cannot be generated by effect bundles, trigger these via script where necessary
	if self.current_suggestion_list[index][issue_data_index.applies_scripted_effect_index] and not incident_fired then
		faction_council:issue_applies_scripted_effect(faction_key, index, self.current_suggestion_list[index][issue_data_index.suggestion_key_index])
	end;
end;

--// get_suggestion_modify_interface_and_owner(string, int, string)
--// get the modify interface to apply an effect to based on scope
--// also gets the query_faction owner of the object
function faction_council:get_suggestion_modify_interface_and_owner_faction(target_scope, target_cqi, faction_key)
	if target_scope == nil then
		script_error("ERROR: faction_council:get_suggestion_modify_interface - Supplied target_scope parameter is nil.");
		return nil, nil;
	end;
	if target_cqi == nil or not is_number(target_cqi) then
		script_error("ERROR: faction_council:get_suggestion_modify_interface - Supplied target_cqi parameter is either nil or an integer.");
		return nil, nil;
	end;
	if faction_key == nil or not cm:query_faction(faction_key) then
		script_error("ERROR: faction_council:get_suggestion_modify_interface - Supplied faction_key parameter is either nil or does not match any faction.");
		return nil, nil;
	end;

	local return_modify_interface_from_scope =
	{
		["faction"] = function(cqi, l_faction_key)
			-- takes a cqi reference and returns a modify faction interface
			if not cm:query_model():has_faction_command_queue_index(cqi) then
				script_error("ERROR: faction_council:get_suggestion_modify_interface - Supplied target_cqi " .. cqi .. " parameter matches no factions.");
				return nil;
			end;

			local q_faction = cm:query_model():faction_for_command_queue_index(cqi);

			return cm:modify_faction(q_faction), q_faction;
		end,
		["force"] = function(cqi, l_faction_key)
			-- takes a cqi reference and returns a modify force interface
			if not cm:query_model():has_military_force_command_queue_index(cqi) then
				script_error("ERROR: faction_council:get_suggestion_modify_interface - Supplied target_cqi " .. cqi .. " parameter matches no forces.");
				return nil;
			end;

			local q_force = cm:query_model():military_force_for_command_queue_index(cqi);

			return cm:modify_military_force(q_force), q_force:faction();
		end,
		["character"] = function(cqi, l_faction_key)
			-- takes a cqi reference and returns a modify character interface
			if not cm:query_model():has_character_command_queue_index(cqi) then
				script_error("ERROR: faction_council:get_suggestion_modify_interface - Supplied target_cqi " .. cqi .. " parameter matches no characters.");
				return nil;
			end;

			local q_character = cm:query_model():character_for_command_queue_index(cqi);

			return cm:modify_character(q_character), q_character:faction();
		end,
		["province"] = function(cqi, l_faction_key)
			-- takes a cqi reference (for a region) and returns a modify province interface
			if cm:query_model():faction_province_for_command_queue_index_faction_key(cqi, l_faction_key):is_null_interface() then
				script_error("ERROR: faction_council:get_suggestion_modify_interface - Supplied target_cqi " .. cqi .. " parameter matches no provinces");
				return nil;
			end;

			return cm:modify_faction_province(cm:query_model():faction_province_for_command_queue_index_faction_key(cqi, l_faction_key)), cm:query_faction(l_faction_key); -- Had to make an assumption here as we can't get the faction from a faction_province_script_interface at present.
		end,
		["region"] = function(cqi, l_faction_key)
			-- takes a cqi reference and returns a modify region interface
			local filtered_region_list = cm:query_model():world():region_manager():region_list():filter(function(filter_region)
				return filter_region:command_queue_index() == cqi;
			end)

			if filtered_region_list:is_empty() then
				script_error("ERROR: faction_council:get_suggestion_modify_interface - Supplied target_cqi " .. cqi .. " parameter matches no regions.");
				return nil;
			end;
			
			return cm:modify_region(filtered_region_list:item_at(0)), filtered_region_list:item_at(0):owning_faction();
		end;
	}
	
	if not return_modify_interface_from_scope[target_scope] then
		script_error("ERROR: faction_council:get_suggestion_modify_interface - Supplied target_scope parameter is nil.");
		return nil, nil;
	end;
	
	-- get the modify inteface of the 'thing' to which we are going to be applying the effect bundle
	local modify_interface_from_scope, owning_faction = return_modify_interface_from_scope[target_scope](target_cqi, faction_key);

	-- will return nil if the modify interface does not exist
	return modify_interface_from_scope, owning_faction;
end;


--// issue_applies_scripted_effect(string)
--// If the suggestion has a scripted component we apply its effects via this function
function faction_council:issue_applies_scripted_effect(faction_key, suggestion_index, suggestion_key)
	if suggestion_index == nil or not is_number(suggestion_index) then
		script_error("ERROR: faction_council:issue_applies_scripted_effect - suggestion_index parameter is nil or not a number." );
		return;
	end
	if suggestion_key == nil then
		script_error("ERROR: faction_council:issue_applies_scripted_effect - suggestion_key parameter is nil." );
		return;
	end
	
	local suggestion_switch_table =
	{
		["issue_incomplete_ceo_set"] =  (function(faction_key, suggestion_index)
			-- adds an ancilliary to the factions ancilliary bank from a provided ancilliary data key
			local modify_faction = cm:modify_faction(faction_key);
			local ceo_key = faction_council:issue_incomplete_ceo_set(modify_faction:query_faction());
			modify_faction:ceo_management():add_ceo(ceo_key);
		end),
		["issue_few_unassigned_ancillaries"] =  (function(faction_key, suggestion_index)
			-- adds a random ancilliary to the factions ancillary bank
			local modify_faction = cm:modify_faction(faction_key);
			local ancilliaries_table =
			{
				"3k_main_ancillary_weapon_ceremonial_sword_exceptional",
				"3k_main_ancillary_weapon_composite_bow_exceptional",
				"3k_main_ancillary_weapon_halberd_exceptional",
				"3k_main_ancillary_weapon_short_ji_exceptional",
				"3k_main_ancillary_weapon_two_handed_axe_exceptional"
			};
			local item_key = ancilliaries_table[cm:random_int(1, #ancilliaries_table)];

			if item_key and is_string(item_key) then
				modify_faction:ceo_management():add_ceo(item_key);
			else
				script_error("ERROR: faction_council:issue_applies_scripted_effect() Unable to find a CEO key for issue_few_unassigned_ancillaries");
			end;
		end),
		["issue_own_character_unmarried"] =  (function(faction_key, suggestion_index)
			local target_character = cm:modify_character(cm:query_model():character_for_command_queue_index(self.current_suggestion_list[suggestion_index][issue_data_index.target_index]));
			target_character:family_member():marry_random_character();
		end),
		["issue_own_character_recruited_at_higher_rank"] =  (function(faction_key, suggestion_index)
			-- resets the assigned skill points of the provided character cqi
			local target_character = cm:modify_character(cm:query_model():character_for_command_queue_index(self.current_suggestion_list[suggestion_index][issue_data_index.target_index]));
			target_character:reset_skills();		
		end),
		["issue_no_characters_recruited_recently"] =  (function(faction_key, suggestion_index)
			-- generates a dilemma which will add a character to the factions court
			cm:modify_model():get_modify_faction(self.current_suggestion_list[suggestion_index][issue_data_index.faction_index]):trigger_dilemma("3k_dlc07_faction_council_generate_character_dilemma_scripted", true);	
		end),
		["issue_enemy_character_wounded_but_not_killed"] =  (function(faction_key, suggestion_index)
			-- kills the character of provided cqi
			cm:modify_character(self.current_suggestion_list[suggestion_index][issue_data_index.target_index]):kill_character(false)			
		end),
		["issue_enemy_faction_leader_in_foreign_territory"] =  (function(faction_key, suggestion_index)
			-- adds a map pin of the provided character cqi and makes them visible on the campaign map
			local mod_character = cm:modify_character(self.current_suggestion_list[suggestion_index][issue_data_index.target_index]);
			local mod_faction = cm:modify_faction(faction_key);
			local new_character_pin_cqi = mod_faction:get_map_pins_handler():add_character_pin(mod_character, "3k_dlc07_faction_council_pin_enemy_faction_leader", true);

			table.insert(self.faction_council_pin_data, {faction_key = mod_faction:query_faction():name(), pin_cqi = new_character_pin_cqi, expiration_turn = cm:query_model():turn_number() + self.current_suggestion_list[suggestion_index][issue_data_index.effect_bundle_duration_index]});
		end),
		["issue_own_character_has_undesirable_traits"] =  (function(faction_key, suggestion_index)
			-- first removes an undesirable character personality ceo then adds a new one to the character supplied by parameter
			local mod_character = cm:modify_character(self.current_suggestion_list[suggestion_index][issue_data_index.target_index]);
			local undesirable_character_trait_ceo_keys = -- "undesirable" character personality ceos
			{
				"3k_main_ceo_trait_personality_careless",
				"3k_main_ceo_trait_personality_cowardly",
				"3k_main_ceo_trait_personality_cruel",
				"3k_main_ceo_trait_personality_disloyal",
				"3k_main_ceo_trait_personality_greedy",
				"3k_main_ceo_trait_personality_incompetent",
				"3k_main_ceo_trait_personality_unobservant",
				"3k_main_ceo_trait_personality_vain"
			};
			local desirable_character_trait_ceo_keys = -- "desirable" character personality ceos
			{
				"3k_main_ceo_trait_personality_energetic",
				"3k_main_ceo_trait_personality_enigmatic",
				"3k_main_ceo_trait_personality_artful",
				"3k_main_ceo_trait_personality_brave",
				"3k_main_ceo_trait_personality_brilliant",
				"3k_main_ceo_trait_personality_intimidating",
				"3k_main_ceo_trait_personality_kind",
				"3k_main_ceo_trait_personality_loyal",
				"3k_main_ceo_trait_personality_resourceful",
				"3k_main_ceo_trait_personality_scholarly"
			};
			local filtered_personality_ceos_list = mod_character:query_character():ceo_management():all_ceos_for_category("3k_main_ceo_category_traits_personality");
			local filtered_undesirable_personality_ceos_list = filtered_personality_ceos_list:filter(function(filter_ceo)
				return table.contains(undesirable_character_trait_ceo_keys, filter_ceo:ceo_data_key());
			end);

			-- remove undesirable personality ceo
			mod_character:ceo_management():remove_ceo(filtered_undesirable_personality_ceos_list:item_at(0));
			filtered_personality_ceos_list = mod_character:query_character():ceo_management():all_ceos_for_category("3k_main_ceo_category_traits_personality");

			-- we want to randomise the ancillary assignement from the valid options and not duplicate personality ceos
			local new_character_ceo_keys = cm:random_sort(desirable_character_trait_ceo_keys)
			local ceo_matched = false;
			
			for n = 1, #new_character_ceo_keys do
				-- check if the current ceo already exists on the character (avoid having duplicate personality ceos)
				for i = 0, filtered_personality_ceos_list:num_items() -1 do
					if filtered_personality_ceos_list:item_at(i):ceo_data_key() == new_character_ceo_keys[n] then
						ceo_matched = true;
					end;
				end;
				-- add new ceo to the character
				if ceo_matched == false then
					mod_character:ceo_management():add_ceo(new_character_ceo_keys[n])
					return;
				end;
			end;
			-- if script reaches this point no valid ceo replacement was found
			script_error("ERROR: faction_council:issue_applies_scripted_effect (".. tostring(self.current_suggestion_list[suggestion_index]) ..") - Unable to assign replacement ceo, all ceos in table(desirable_character_trait_ceo_keys) exist on character.");
			return;
		end),
		["issue_highly_developed_enemy_region_with_own_army"]  =  (function(faction_key, suggestion_index)
			-- takes a region cqi reference, gets the garrison force interface and then applies an effect bundle
			local target_region = cm:region_for_cqi(self.current_suggestion_list[suggestion_index][issue_data_index.target_index]);
			
			if not target_region or target_region:is_null_interface() then
				script_error("ERROR: faction_council:issue_applies_scripted_effect (".. tostring(self.current_suggestion_list[suggestion_index]) ..") - Supplied target_cqi parameter matches no regions.");
				return;
			end;

			if target_region:province():is_null_interface() then
				script_error("ERROR: faction_council:issue_applies_scripted_effect (".. tostring(self.current_suggestion_list[suggestion_index]) ..") - Supplied region of ".. target_region:name() .." provice returned a null interface.");
				return;
			end;

			local faction_province_list = target_region:province():faction_province_list():filter(function(filter_faction_province)
				return filter_faction_province:region_list():contains(target_region);
			end)
			local faction_province = faction_province_list:item_at(0)

			if not faction_province or faction_province:pooled_resources():is_null_interface() then
				script_error("ERROR: faction_council:issue_applies_scripted_effect (".. tostring(self.current_suggestion_list[suggestion_index]) ..") - Supplied region of ".. target_region:name() .." pooled resource manager returned a null interface.");
				return;
			end;

			if faction_province:pooled_resources():resource("3k_main_pooled_resource_supply"):is_null_interface() then
				script_error("ERROR: faction_council:issue_applies_scripted_effect (".. tostring(self.current_suggestion_list[suggestion_index]) ..") - Supplied region of ".. target_region:name() .." nas no 3k_main_pooled_resource_supply pooled resource.");
				return;
			end;

			local query_faction_province_supply_stockpile_interface = faction_province:pooled_resources():resource("3k_main_pooled_resource_supply");
			local faction_province_supply_stockpile_amount = query_faction_province_supply_stockpile_interface:value();

			cm:modify_model():get_modify_pooled_resource(query_faction_province_supply_stockpile_interface):apply_transaction_to_factor("3k_main_pooled_factor_supply_sabotage", - (faction_province_supply_stockpile_amount));
			cm:modify_faction_province(faction_province):apply_effect_bundle("3k_dlc07_effect_bundle_disable_pooled_resource_supply", self.current_suggestion_list[suggestion_index][issue_data_index.effect_bundle_duration_index]);
		end),
		["issue_enemy_region_with_highly_developed_infrastructure"] =  (function(faction_key, suggestion_index)
			-- takes a region cqi reference and then razes it
			local target_region = cm:region_for_cqi(self.current_suggestion_list[suggestion_index][issue_data_index.target_index]);

			if target_region:is_null_interface() then
				script_error("ERROR: faction_council:issue_applies_scripted_effect (".. tostring(self.current_suggestion_list[suggestion_index]) ..") - Supplied target_cqi parameter matches no regions.");
				return;
			end;

			local slots = target_region:slot_list():filter(function(slot) return slot:has_building() end);

			local num_to_damage = 1;
			if slots:num_items() >= 3 then
				num_to_damage = cm:random_int(2, slots:num_items() - 1);
			end;

			for i = 0, slots:num_items() - 1 do
				local m_slot = cm:modify_model():get_modify_slot(slots:item_at(i));
				local chance = (num_to_damage / (slots:num_items() - i)) * 100;

				if cm:roll_random_chance(chance) and m_slot:damage_building(cm:random_int(25, 90)) then
					num_to_damage = num_to_damage - 1;

					if num_to_damage < 1 then
						break;
					end;
				end;
			end;
		end),
		["issue_unused_own_trade_capacity"] =  (function(faction_key, suggestion_index)
			local faction_interface = cm:query_faction(faction_key);
			local target_faction = cm:query_model():faction_for_command_queue_index(self.current_suggestion_list[suggestion_index][issue_data_index.target_index]);

			local faction_modify_interface = cm:modify_faction(faction_key);
			faction_modify_interface:apply_effect_bundle(self.current_suggestion_list[suggestion_index][issue_data_index.effect_bundle_index], self.current_suggestion_list[suggestion_index][issue_data_index.effect_bundle_duration_index]);

			cm:modify_faction(target_faction):apply_automatic_diplomatic_deal("data_defined_situation_trade", faction_interface, "faction_key:"..target_faction:name()); 
		end),
		["issue_own_vassal_relationship_poor"] =  (function(faction_key, suggestion_index)
			-- moves the heir of the vassal faction to the vassal lord's faction and improves the relationship between the two faction leasders
			local faction_interface = cm:query_faction(faction_key);
			local target_faction = cm:query_model():faction_for_command_queue_index(self.current_suggestion_list[suggestion_index][issue_data_index.target_index]);
			local heir_post = target_faction:character_posts():filter(function(filter_post)
				return filter_post:ministerial_position_record_key() == "faction_heir";-- if the vassal faction has a relationship below the threshold value we keep them on the filtered list
			end)

			if heir_post:is_empty() then
				script_error("ERROR: faction_council:issue_applies_scripted_effect (".. tostring(self.current_suggestion_list[suggestion_index]) ..") - Heir post does not exist for this vassal faction.");
				return;
			end;

			local heir_character = heir_post:item_at(0):post_holders():item_at(0)

			if heir_character:is_null_interface() then
				script_error("ERROR: faction_council:issue_applies_scripted_effect (".. tostring(self.current_suggestion_list[suggestion_index]) ..") - Vassal has no heir to use as political hostage.");
				return;
			end;
			cm:modify_character(heir_character):move_to_faction_and_make_recruited(faction_interface:name());
			cm:modify_faction(target_faction):apply_automatic_diplomatic_deal("data_defined_situation_attitude_manipulation_hostage", faction_interface, "faction_key:"..target_faction:name()); 

			if faction_interface:is_human() then
				-- Working around basic incident functionality as we'll need 2 targets
				local incident = cm:modify_model():create_incident("3k_dlc07_faction_council_issue_own_vassal_relationship_poor_title_source_incident");
				incident:add_character_target("target_character_1", cm:query_character(self.current_suggestion_list[suggestion_index][issue_data_index.character_cqi_index]));
				incident:add_character_target("target_character_2", heir_character);
				incident:add_faction_target("target_faction_1", target_faction);
				incident:trigger(cm:modify_faction(faction_interface), true);
			end;
		end),
		["issue_non_allied_factions_control_southern_ports"] =  (function(faction_key, suggestion_index)
			-- takes a land region cqi, gets the associated spawn region + x/y coordinates then spawns an invasion army which declares war on the owner of the land region and attacks that location
			local target_region = cm:region_for_cqi(self.current_suggestion_list[suggestion_index][issue_data_index.target_index]);
			if not target_region or target_region:is_null_interface() then
				script_error("ERROR: faction_council:issue_applies_scripted_effect (".. tostring(self.current_suggestion_list[suggestion_index]) ..") - Supplied target region cqi parameter returns a null interface.");
				return;
			end;

			local spawn_regions_spawn_location_data =
			{
				["3k_dlc06_jiuzhen_capital"] = {spawn_region = "3k_dlc06_sea_nan_to_jiuzhen_capital", x_pos = 254, y_pos = 122},
				["3k_main_jiaozhi_capital"] = {spawn_region = "3k_main_sea_nan_jiaozhi_capital", x_pos = 271, y_pos = 138},
				["3k_main_hepu_capital"] = {spawn_region = "3k_main_sea_nan_hepu_capital", x_pos = 308, y_pos = 145},
				["3k_main_hepu_resource_1"] = {spawn_region = "3k_main_sea_nan_hepu_resource_1", x_pos = 368, y_pos = 133},
				["3k_main_hepu_resource_2"] = {spawn_region = "3k_main_sea_nan_hepu_resource_2", x_pos = 371, y_pos = 94},
				["3k_main_gaoliang_capital"] = {spawn_region = "3k_main_sea_nan_gaoliang_capital", x_pos = 432, y_pos = 148},
				["3k_main_gaoliang_resource_1"] = {spawn_region = "3k_main_sea_nan_gaoliang_resource_1", x_pos = 402, y_pos = 146},
			};
			if not spawn_regions_spawn_location_data[target_region:name()] then
				script_error("ERROR: faction_council:issue_applies_scripted_effect (".. tostring(self.current_suggestion_list[suggestion_index]) ..") - Supplied target region does not exist on the spawn_regions_spawn_location_data list.");
				return;
			end;

			local invasion_spawn_data = spawn_regions_spawn_location_data[target_region:name()];

			local can_invade, valid_x, valid_y = cm:query_faction("3k_dlc04_faction_rebels"):get_valid_spawn_location_near(invasion_spawn_data.x_pos, invasion_spawn_data.y_pos,30 ,false)
			
			if can_invade then
				invasion_spawn_data.x_pos = valid_x
				invasion_spawn_data.y_pos = valid_y
				
				if faction_council:spawn_invasion_forces(target_region, invasion_spawn_data, "3k_dlc04_faction_rebels") == false then
					script_error("ERROR: faction_council:issue_applies_scripted_effect (".. tostring(self.current_suggestion_list[suggestion_index]) ..") - Failed to generate invasion force.");
				end;
			end
		end),
		["issue_non_allied_factions_control_northern_ports"] =  (function(faction_key, suggestion_index)
			-- takes a land region cqi, gets the associated spawn region + x/y coordinates then spawns an invasion army which declares war on the owner of the land region and attacks that location
			local target_region = cm:region_for_cqi(self.current_suggestion_list[suggestion_index][issue_data_index.target_index]);
			if not target_region or target_region:is_null_interface() then
				script_error("ERROR: faction_council:issue_applies_scripted_effect (".. tostring(self.current_suggestion_list[suggestion_index]) ..") - Supplied target region cqi parameter returns a null interface.");
				return;
			end;

			local spawn_regions_spawn_location_data =
			{
				["3k_dlc06_liaodong_capital"] = {spawn_region = "3k_dlc06_sea_huang_to_liaodong_capital", x_pos = 627, y_pos = 611},
				["3k_dlc06_liaodong_resource_1"] = {spawn_region = "3k_dlc06_sea_huang_to_liaodong_resource_1", x_pos = 630, y_pos = 627},
				["3k_main_yu_capital"] = {spawn_region = "3k_main_sea_huang_to_yu_capital", x_pos = 617, y_pos = 626},
				["3k_main_youbeiping_capital"] = {spawn_region = "3k_main_sea_huang_to_youbeiping_capital", x_pos = 569, y_pos = 586},
				["3k_main_youbeiping_resource_1"] = {spawn_region = "3k_main_sea_huang_to_youbeiping_resource_1", x_pos = 597, y_pos = 606},
				["3k_main_bohai_resource_1"] = {spawn_region = "3k_main_sea_huang_to_bohai_resource_1", x_pos = 547, y_pos = 574},
				["3k_main_pingyuan_resource_1"] = {spawn_region = "3k_main_sea_huang_to_pingyuan_resource_1", x_pos = 570, y_pos = 564},
				["3k_main_taishan_resource_1"] = {spawn_region = "3k_main_sea_huang_to_taishan_resource_1", x_pos = 587, y_pos = 547},
				["3k_main_beihai_resource_1"] = {spawn_region = "3k_main_sea_huang_to_beihai_resource_1", x_pos = 592, y_pos = 540},
				["3k_main_donglai_capital"] = {spawn_region = "3k_main_sea_huang_to_donglai_capital", x_pos = 622, y_pos = 557},
				["3k_main_donglai_resource_1"] = {spawn_region = "3k_main_sea_huang_to_donglai_resource_1", x_pos = 648, y_pos = 550},
			};
			if not spawn_regions_spawn_location_data[target_region:name()] then
				script_error("ERROR: faction_council:issue_applies_scripted_effect (".. tostring(self.current_suggestion_list[suggestion_index]) ..") - Supplied target region does not exist on the spawn_regions_spawn_location_data list.");
				return;
			end;

			local invasion_spawn_data = spawn_regions_spawn_location_data[target_region:name()];

			local can_invade, valid_x, valid_y = cm:query_faction("3k_dlc04_faction_rebels"):get_valid_spawn_location_near(invasion_spawn_data.x_pos, invasion_spawn_data.y_pos,30 ,false)
			
			if can_invade then
				invasion_spawn_data.x_pos = valid_x
				invasion_spawn_data.y_pos = valid_y
				
				if faction_council:spawn_invasion_forces(target_region, invasion_spawn_data, "3k_dlc04_faction_rebels") == false then
					script_error("ERROR: faction_council:issue_applies_scripted_effect (".. tostring(self.current_suggestion_list[suggestion_index]) ..") - Failed to generate invasion force.");
					return;
				end;
			end
		end),
		["issue_non_allied_factions_control_north_west_regions"] =  (function(faction_key, suggestion_index)
			-- takes a land region cqi, gets the associated spawn region + x/y coordinates then spawns an invasion army which declares war on the owner of the land region and attacks that location
			local target_region = cm:region_for_cqi(self.current_suggestion_list[suggestion_index][issue_data_index.target_index]);
			if not target_region or target_region:is_null_interface() then
				script_error("ERROR: faction_council:issue_applies_scripted_effect (".. tostring(self.current_suggestion_list[suggestion_index]) ..") - Supplied target region cqi parameter returns a null interface.");
				return false;
			end;

			local spawn_regions_spawn_location_data =
			{
				["3k_main_wuwei_capital"] = {spawn_region = "3k_main_wuwei_capital", x_pos = 144, y_pos = 567},
				["3k_main_wuwei_resource_1"] = {spawn_region = "3k_main_wuwei_resource_1", x_pos = 178, y_pos = 582},
				["3k_main_wuwei_resource_2"] = {spawn_region = "3k_main_wuwei_resource_2", x_pos = 210, y_pos = 581},
				["3k_main_shoufang_capital"] = {spawn_region = "3k_main_shoufang_capital", x_pos = 297, y_pos = 616},
				["3k_main_shoufang_resource_2"] = {spawn_region = "3k_main_shoufang_resource_2", x_pos = 248, y_pos = 595},
			};
			if not spawn_regions_spawn_location_data[target_region:name()] then
				script_error("ERROR: faction_council:issue_applies_scripted_effect (".. tostring(self.current_suggestion_list[suggestion_index]) ..") - Supplied target region does not exist on the spawn_regions_spawn_location_data list.");
				return;
			end;
			
			local invasion_spawn_data = spawn_regions_spawn_location_data[target_region:name()];
			local can_invade, valid_x, valid_y = cm:query_faction("3k_dlc04_faction_rebels"):get_valid_spawn_location_near(invasion_spawn_data.x_pos, invasion_spawn_data.y_pos,30 ,false)
			
			
			if can_invade then
				invasion_spawn_data.x_pos = valid_x
				invasion_spawn_data.y_pos = valid_y
				
				if faction_council:spawn_invasion_forces(target_region, invasion_spawn_data, "3k_dlc04_faction_rebels") == false then
					script_error("ERROR: faction_council:issue_applies_scripted_effect (".. tostring(self.current_suggestion_list[suggestion_index]) ..") - Failed to generate invasion force.");
				end;
			end
		end)
	}

	if suggestion_switch_table[suggestion_key] then
		suggestion_switch_table[suggestion_key](faction_key, suggestion_index);
	else
		script_error("ERROR: faction_council:issue_applies_scripted_effect - suggestion_key:" .. suggestion_key.. " which does not match any valid issue key." );
		return;
	end
end;

--// add_to_active_list()
--// Adds the suggestion to the active list so it's tracked.
function faction_council:add_to_active_list(issue_key, faction_key, post_holder, post, valid_issues)
	
    for i = #self.current_suggestion_list, 1, -1 do
        if self.current_suggestion_list[i][issue_data_index.suggestion_key_index] == issue_key and self.current_suggestion_list[i][issue_data_index.faction_index] == cm:query_faction(faction_key):command_queue_index() then
            script_error("ERROR: faction_council:add_to_active_list - Trying to add a suggestion to the active list when it already exists. Key=" .. issue_key );
            return false;
        end;
	end;
				
	table.insert(
		self.current_suggestion_list, 
		{
			issue_key,
			cm:query_faction(faction_key):command_queue_index(),
			post_holder:command_queue_index(),
			post:cqi(),
			valid_issues[issue_key].effect_target(cm:modify_faction(faction_key), cm:modify_model()),
			valid_issues[issue_key].effect_bundle_key,
			valid_issues[issue_key].effect_bundle_duration,
			valid_issues[issue_key].cost,
			valid_issues[issue_key].applies_scripted_effect,
			valid_issues[issue_key].scope,
			valid_issues[issue_key].suggestion_icon,
			valid_issues[issue_key].available_to_ai,
			valid_issues[issue_key].incident_key_source,
			valid_issues[issue_key].incident_blocks_effects_source,
			valid_issues[issue_key].incident_key_target,
			valid_issues[issue_key].incident_blocks_effects_target,
			valid_issues[issue_key].incident_key_global,
			valid_issues[issue_key].use_distance_weighting_mod
		}
	);
end;

--// set_faction_council_post_cqi_list()
--// Council seats are not statically linked to ministerial positions
--// UI representation of ministerial positions requires the post configuration of each faction
function faction_council:set_faction_council_post_cqi_list(faction_key, ministerial_position_keys_list)
	local post_cqi_table ={}
	local filtered_post_list = cm:query_faction(faction_key):character_posts();
	filtered_post_list = filtered_post_list:filter(function(filter_post)
		return ministerial_position_keys_list[filter_post:ministerial_position_record_key()] ~= nil;
	end)
	for i=0, filtered_post_list:num_items() -1 do 
		table.insert( post_cqi_table, filtered_post_list:item_at(i):cqi())
	end;

	self.faction_posts_list[faction_key] = post_cqi_table;
	
	-- Update UI values if this is a human faction
	if cm:query_faction(faction_key):is_human() then
		self:update_council_post_ui_values()
	end;
end;

--// remove_from_active_list()
--// Stop tracking this suggestion.
function faction_council:remove_from_active_list(issue_key, faction)
	local suggestion_key = issue_key;
	local faction_cqi = faction;

	for i = #self.current_suggestion_list, 1, -1 do
		local suggestion_data = self.current_suggestion_list[i];
        if suggestion_data[1] == issue_key and suggestion_data[2] == faction_cqi then
            table.remove(self.current_suggestion_list, i);
            return true;
        end;
    end;
    script_error("ERROR: faction_council:remove_from_active_list - Trying to remove suggestion from active list when it doesn't exist. Key=" .. suggestion_key .. "Faction CQI =" .. faction_cqi );
    return false;
end;

--// can_trigger_council()
--// Returns false if the council cannot be invoked for any reason.
function faction_council:can_trigger_council(modify_faction)
    --Exit if disabled.
    if not self.enabled then
        out.events("faction_council:can_trigger_council(): Cannot trigger - System Disabled.");
        return false;
	end;
		
    --out.events("faction_council:can_trigger_council(): System can trigger.");
    return true;
end;

function faction_council:is_issue_on_cooldown(faction_key, issue_key)
	if not self.issues_on_cooldown[faction_key] or not is_table(self.issues_on_cooldown[faction_key]) then -- Catches old saved data
		return false;
	end;

	local last_round_fired = nil; -- Cooldowns stored as {round, key} and the top values will be the highest. So, to find issues last round, we just grab all issues with the highest round number.
	for i, cooldown in ipairs(self.issues_on_cooldown[faction_key]) do
		if not last_round_fired then
			last_round_fired = cooldown[1];
		end;

		if cooldown[1] ~= last_round_fired then
			return false;
		end;

		if cooldown[2] == issue_key then
			return true;
		end;
	end;

	return false;
end;

function faction_council:times_issue_fired_recently(faction_key, issue_key)
	if not self.issues_on_cooldown[faction_key] or not is_table(self.issues_on_cooldown[faction_key]) then -- Catches old saved data
		return 0;
	end;

	local count = 0;
	if self.issues_on_cooldown[faction_key] then
		for i, cooldown in ipairs(self.issues_on_cooldown[faction_key]) do
			if cooldown[2] == issue_key then
				count = count + 1;
			end;
		end;
	end;

	return count;
end;

function faction_council:add_all_active_issues_on_cooldown_using_faction_key(faction_key)
	for i = #self.current_suggestion_list, 1, -1 do -- Go in reverse as we'll be removing items.
		if self.current_suggestion_list[i][issue_data_index.faction_index] == cm:query_faction(faction_key):command_queue_index() then
			-- Check if the faction has issues on cooldown, if so we append the string containing the keys of suggestions on cooldown
			self:add_issue_on_cooldown_using_suggestion_key(faction_key, self.current_suggestion_list[i][issue_data_index.suggestion_key_index])
		end;
	end
end;

function faction_council:add_issue_on_cooldown_using_suggestion_key(faction_key, issue_key)
	
	local issue_data = {cm:turn_number(), issue_key};
	if not self.issues_on_cooldown[faction_key] 
	or #self.issues_on_cooldown[faction_key] == 0 
	or not is_table(self.issues_on_cooldown[faction_key]) then -- Old data was stored as a string. I've updated to a table but this check stops it erroring, but will ovewrite.
		self.issues_on_cooldown[faction_key] = {issue_data}
	else
		table.insert(self.issues_on_cooldown[faction_key], 1, issue_data);
	end;
	
	while #self.issues_on_cooldown[faction_key] >= cooldown_recently_fired_history do
		table.remove(self.issues_on_cooldown[faction_key]);
	end;
end;

function faction_council:update_council_post_ui_values()
	effect.set_context_value("3k_dlc07_faction_council_faction_post_cqis_list", self.faction_posts_list);
end;

function faction_council:update_suggestion_ui_values()
	effect.set_context_value("3k_dlc07_faction_council_current_suggestion_list", self.current_suggestion_list);
end;

function faction_council:update_panel_accessibility_ui_values(reasons_table)
	effect.set_context_value("3k_dlc07_faction_council_is_available", tostring(table.is_empty(reasons_table)));
	effect.set_context_value("3k_dlc07_faction_council_reasons", reasons_table);
end;

function faction_council:update_next_session_counter_ui_values()
	effect.set_context_value("3k_dlc07_faction_council_turns_until_next_available", turns_until_next_year[cm:query_model():season()]);
end;

function faction_council:fire_council_action_incident_for_target(incident_key, target_faction, performing_character, target_modify_interface)
	-- construct our incident here.
	local incident = cm:modify_model():create_incident(incident_key);

	if incident then -- and not incident:is_null_interface() then
		-- Pass the performing character
		if performing_character and not performing_character:is_null_interface() then
			incident:add_character_target("target_character_1", performing_character);
		end;

		-- Pass the target
		if is_modify_region(target_modify_interface) then
			local target_region = target_modify_interface:query_region()
			if not target_region:is_null_interface() then
				incident:add_region_target("target_region_1", target_region);
			end;
		elseif is_modify_faction_province(target_modify_interface) then
			local target_region = target_modify_interface:query_faction_province():region_list():item_at(0);
			if not target_region:is_null_interface() then
				incident:add_region_target("target_region_1", target_region);
			end;
		elseif is_modify_military_force(target_modify_interface) then
			local target_char = target_modify_interface:query_military_force():general_character();
			if not target_char:is_null_interface() then
				incident:add_force_target("target_military_1",  target_modify_interface:query_military_force());
				incident:add_character_target("target_character_2", target_char);
			end;
		elseif is_modify_character(target_modify_interface) then
			local target_char = target_modify_interface:query_character();
			if not target_char:is_null_interface() then
				incident:add_character_target("target_character_2", target_char);
			end;
		elseif is_modify_faction(target_modify_interface) then
			local target_faction = target_modify_interface:query_faction();
			if not target_faction:is_null_interface() then
				incident:add_faction_target("target_faction_1", target_faction);
			end;
		end

		-- Trigger Incident.
		incident:trigger(cm:modify_faction(target_faction), true);
	end;
end;

function faction_council:debug_initialise()

	-- Calls the on_invoke_council() function temporarily 'resetting' the values to make it work.
	-- Example: trigger_cli_debug_event faction_council.invoke(3k_main_faction_cao_cao)
	core:add_cli_listener("faction_council.invoke", 
		function( faction_key )
			faction_key = faction_key or cm:get_local_faction(false);
			local q_faction = cm:query_faction(faction_key);
			-- Falsify the variables here to make it always able to fire. 
			local stored_season_of_council = season_of_council;
			season_of_council = cm:query_model():season();
			self.court_held_this_turn[q_faction:name()] = not self.court_held_this_turn[q_faction:name()];
			
			self:on_invoke_council( cm:modify_faction( faction_key ), cm:modify_model() );

			--reset our falisified vars. If the script crashes before getting here the gamestate will be desynced.
			season_of_council = stored_season_of_council;
			self.court_held_this_turn[q_faction:name()] = not self.court_held_this_turn[q_faction:name()];
		end
	);

	-- Allows re-triggering of faction council at any point by reopening the panel.
	-- WARNING: Will likely cause saved data to be broken forever!!!!
	-- Example: trigger_cli_debug_event faction_council.force_allow(3k_main_faction_cao_cao)
	core:add_cli_listener("faction_council.force_allow", 
		function( faction_key )
			faction_key = faction_key or cm:get_local_faction(false);

			if faction_key then
				local q_faction = cm:query_faction(faction_key);
				-- Falsify the variables here to make it always able to fire.
				local stored_season_of_council = season_of_council;
				season_of_council = cm:query_model():season();
				self.court_held_this_turn[q_faction:name()] = false;
			end;
		end
	);

	-- Override the weighting of an issue for the rest of the session
	-- Example: trigger_cli_debug_event faction_council.override_issue_weighting(issue_non_allied_factions_control_north_west_regions,10000)
	core:add_cli_listener("faction_council.override_issue_weighting", 
		function( issue_key, new_weighting )
			if self.valid_issues_table[issue_key] then
				self.valid_issues_table[issue_key].weighting_value = new_weighting;
			end
		end
	);

	-- Force all issues to fire from the council. Skips ui and used for texting functionality.
	-- Example: trigger_cli_debug_event faction_council.trigger_all_issues(3k_main_faction_cao_cao,true)
	core:add_cli_listener("faction_council.trigger_all_issues", 
		function(faction_key, force) 
			local issues_list = {}
			for k, v in pairs(self.valid_issues_table) do
				table.insert(issues_list, k);
			end;

			self:debug_apply_issues(faction_key, issues_list, force);
		end 
	);

	-- Force a specific issue to fire. Skips ui and used for texting functionality.
	-- Example: trigger_cli_debug_event faction_council.trigger_issue(3k_main_faction_cao_cao,issue_own_force_low_supplies,true)
	core:add_cli_listener("faction_council.trigger_issue", 
		function(faction_key, issue_key, force) 
			self:debug_apply_issues(faction_key, {issue_key}, force);
		end 
	);
end;

function faction_council:debug_apply_issues(faction_key, issue_keys, force)
	local q_source_faction = cm:query_faction(faction_key);
	local m_source_faction = cm:modify_faction(q_source_faction);

	if not q_source_faction or q_source_faction:is_null_interface() then
		script_error(string.format("ERROR: faction_council:debug_apply_issues(): Unable to find valid faction [%s]. Exiting.", faction_key));
		return;
	end;

	-- back up current suggestion list
	local backup_current_suggestions = self.current_suggestion_list;
	self.current_suggestion_list = {};

	-- pick post_holder (faction leader as we know they'll generally exist)
	local performing_character = q_source_faction:faction_leader();
	local performing_character_post = performing_character:character_post();

	-- generate the issue(s)
	for i, key in ipairs(issue_keys) do
		if not self.valid_issues_table[key] then
			script_error(string.format("ERROR: faction_council:debug_apply_issues(): Unable to find valid issue key [%s]. Restoring state and Exiting.", key));
			self.current_suggestion_list = backup_current_suggestions;
			return;
		end;

		if self.valid_issues_table[key].effect_target(m_source_faction, nil) or force then
			self:add_to_active_list(key, m_source_faction, performing_character, performing_character_post, self.valid_issues_table)

			-- if we force override, then do so here.
			if force and not self.current_suggestion_list[i][issue_data_index.target_index] then
				local new_target_cqi = nil;

				local query_world = cm:query_model():world();
				if self.valid_issues_table[key].scope == "character" then
					new_target_cqi = q_source_faction:character_list():item_at(0):cqi();
				elseif self.valid_issues_table[key].scope == "faction" then
					new_target_cqi = q_source_faction:command_queue_index();
				elseif self.valid_issues_table[key].scope == "force" then
					new_target_cqi = q_source_faction:military_force_list():item_at(0):command_queue_index();
				elseif self.valid_issues_table[key].scope == "province" then
					new_target_cqi = q_source_faction:region_list():item_at(0):province():cqi();
				elseif self.valid_issues_table[key].scope == "region" then
					new_target_cqi = q_source_faction:region_list():item_at(0):command_queue_index();
				else
					script_error(string.format("ERROR: faction_council:debug_apply_issues(): Unexpected scope type: %s is not a known scope.  Restoring state and Exiting.", self.valid_issues_table[key].scope));
					self.current_suggestion_list = backup_current_suggestions;
					return;
				end;

				if new_target_cqi then
					self.current_suggestion_list[i][issue_data_index.target_index] = new_target_cqi;
				end;
			end;
		end;
	end;

	-- apply all suggestions
	for i, suggestion in ipairs(self.current_suggestion_list) do
		local sug_key = suggestion[1];
		faction_council:apply_suggestion(faction_key, sug_key);
	end;

	-- restore the backup.
	self.current_suggestion_list = backup_current_suggestions;
end;

-- spawn_invasion_forces(script_region_interface, invasion_spawn_data, faction_key)
-- returns true if invasion force is generated
function faction_council:spawn_invasion_forces(target_region, invasion_spawn_data, invasion_faction_key)
	if not target_region or target_region:is_null_interface() then
		script_error("ERROR: faction_council:spawn_invasion_forces - Supplied target_region parameter returns a null interface.");
		return false;
	end;

	if not cm:query_faction(invasion_faction_key) or cm:query_faction(invasion_faction_key):is_null_interface() then
		script_error("ERROR: faction_council:spawn_invasion_forces - Supplied invasion_faction_key parameter returns a null interface.");
		return false;
	end;

	local scaled_force_strength = 1;
	if cm:query_model():turn_number() > 20 and cm:query_model():turn_number() <= 40 then
		scaled_force_strength = 2;
	elseif cm:query_model():turn_number() > 40 and cm:query_model():turn_number() <= 60 then
		scaled_force_strength = 3;
	elseif cm:query_model():turn_number() > 60 then
		scaled_force_strength = 4;
	end;

	if cm:query_faction(invasion_faction_key):can_apply_automatic_diplomatic_deal("data_defined_situation_war_proposer_to_recipient", target_region:owning_faction(), "faction_key:"..invasion_faction_key) then
		cm:modify_faction(invasion_faction_key):apply_automatic_diplomatic_deal("data_defined_situation_war_proposer_to_recipient", target_region:owning_faction(), "faction_key:"..invasion_faction_key); 
	end;
	
	campaign_invasions:create_invasion_attack_region("3k_dlc04_faction_rebels", invasion_spawn_data.spawn_region, scaled_force_strength, target_region:name(), false, invasion_spawn_data.x_pos, invasion_spawn_data.y_pos);
	return true;		
end;


function faction_council:specific_issue_listeners()

	-- issue_own_armies_in_non_allied_territory_without_siege_engines
	-- Listens for a force besieging a settlement with the bundle equipped, forces spawning of siege equipment.
	core:add_listener(
		"faction_council_issue_own_armies_in_non_allied_territory_without_siege_engines_listener",
		"CharacterBesiegesSettlement",
		function(context)
			return context:query_region():settlement():has_walls()
			and context:query_character():military_force():has_effect_bundle("3k_dlc07_issue_own_armies_in_non_allied_territory_without_siege_engines")
		end,
		function(context)
			local modify_force = cm:modify_military_force(context:query_character():military_force());

			modify_force:force_immediate_construct_siege_item("3k_main_blk_battering_ram", true);
			modify_force:force_immediate_construct_siege_item("3k_dlc04_blk_siege_tower", true);
		end,
		true
	);
end;

--***********************************************************************************************************
--***********************************************************************************************************
-- SAVE/LOAD
--***********************************************************************************************************
--***********************************************************************************************************

function faction_council:register_save_load_callbacks()
    cm:add_saving_game_callback(
		function(saving_game_event)
			cm:save_named_value("faction_council_current_suggestion_list", self.current_suggestion_list);
			cm:save_named_value("faction_council_issues_on_cooldown", self.issues_on_cooldown);   
			cm:save_named_value("faction_council_court_held",self.court_held_this_turn);
			cm:save_named_value("faction_council_pins",self.faction_council_pin_data);
			cm:save_named_value("initial_incident_triggered",self.initial_incident_triggered);
        end
    );

    cm:add_loading_game_callback(
        function(loading_game_event)
			local l_faction_council_suggestion_list =  cm:load_named_value("faction_council_current_suggestion_list", self.current_suggestion_list);
			local l_issues_on_cooldown =  cm:load_named_value("faction_council_issues_on_cooldown", self.issues_on_cooldown);
			local l_court_held_this_turn =  cm:load_named_value("faction_council_court_held", self.court_held_this_turn);
			local l_faction_council_pin_data = 	cm:load_named_value("faction_council_pins",self.faction_council_pin_data);
			local l_initial_incident_triggered = cm:load_named_value("initial_incident_triggered",self.initial_incident_triggered);

			self.current_suggestion_list = l_faction_council_suggestion_list;
			self.issues_on_cooldown = l_issues_on_cooldown;
			self.court_held_this_turn = l_court_held_this_turn;
			self.faction_council_pin_data = l_faction_council_pin_data;
			self.initial_incident_triggered = l_initial_incident_triggered;
        end
    );
end;

faction_council:register_save_load_callbacks();
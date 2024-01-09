---------------------------------------------------
---------------------------------------------------
------------------- VARIABLES ---------------------
---------------------------------------------------
---------------------------------------------------

local local_faction_key = "3k_dlc06_faction_nanman_king_shamoke";
local success_key = "dlc06_" .. local_faction_key .. "_success";
local failure_key = "dlc06_" .. local_faction_key .. "_failure";
local shamoke_sister_cqi = cm:query_model():character_for_template("3k_dlc06_template_historical_shamoke_sister_placeholder"):cqi();
local duosi_cqi = cm:query_model():character_for_template("3k_dlc06_template_historical_king_duosi_hero_nanman"):cqi();

output("Events script loaded for " .. local_faction_key);
nanman_shared_progression_events:setup(local_faction_key, "3k_dlc06_faction_nanman_jinhuansanjie");

-- Check if Shamoke has already made a choice for the reformation dilemma, if not assign a default value
if not cm:saved_value_exists("specialisation_option_saved_value_key", "DLC06_shamoke_faction_events_values") then
	cm:set_saved_value("specialisation_option_saved_value_key", "none", "DLC06_shamoke_faction_events_values");
end;

-- Check if a turn has been set for Shamoke's sister sparring event, if not assign a value
if not cm:saved_value_exists("sister_sparring_event_turn_number", "DLC06_shamoke_faction_events_values") then
	cm:set_saved_value("sister_sparring_event_turn_number", cm:random_int(6,4), "DLC06_shamoke_faction_events_values");
end;


-- Initial setup
local function initial_set_up()
	-- Remove Shamoke's bow in 190, as he recieves it via an event.
	cm:modify_faction(local_faction_key):ceo_management():remove_ceos("3k_dlc06_ancillary_weapon_bow_king_shamoke_unique");

	cm:trigger_incident(local_faction_key, "3k_dlc06_introduction_shamoke_190_incident", true);
end;

cm:add_first_tick_callback_new(initial_set_up);


---------------------------------------------------
---------------------------------------------------
------------------- Functions ---------------------
---------------------------------------------------
---------------------------------------------------


local function return_largest_potential_ally_of_faction_with_sepcified_culture(param_faction_interface, param_culture_key, param_minimum_diplomatic_standing)
	-- Check function input values are valid
	local known_faction_interfaces_list = param_faction_interface:factions_met()
	local friendly_faction_interfaces_list = known_faction_interfaces_list:filter(
		function(faction)
			return not faction:is_dead()
				and not faction:is_human()
				and faction:subculture() == param_culture_key
				and param_faction_interface:diplomatic_standing_with(faction) >= param_minimum_diplomatic_standing
				and not diplomacy_manager:is_vassal(faction:name())
				and faction:name() ~= "3k_main_faction_han_empire"
		end)

	-- If there are friendly factions in the array we want to try to determine which is the largest of those factions based on number of regions owned
	if not friendly_faction_interfaces_list:is_empty() then
		-- Set the first element in the friendly factions array to be the largest
		local largest_friendly_faction_interface = friendly_faction_interfaces_list:item_at(0);

		-- check that there are multiple friendly factions existing
		if friendly_faction_interfaces_list:num_items() >= 2 then
			-- Starting with the second entry in the array
			for x = 1, friendly_faction_interfaces_list:num_items() - 1 do
					-- Compare the stored "largest faction" number of regions against the current faction, if the current faction has more set it to be the largest faction
				if friendly_faction_interfaces_list:item_at(x):region_list():num_items() > largest_friendly_faction_interface:region_list():num_items() then
					largest_friendly_faction_interface = friendly_faction_interfaces_list:item_at(x)
				end;
			end;
		end;
		return true, largest_friendly_faction_interface;
		-- If the list is empty the supplied faction has no friends, this is kind of sad :(
	else output("3k_dlc06_faction_nanman_king_shamoke_events.lua: Function return_largest_potential_ally_of_faction_with_sepcified_culture supplied faction has no friendly factions matching criteria, returning false");
		return false, nil;
	end;
end;


---------------------------------------------------
---------------------------------------------------
---- Listeners for Shamokes Faction Incidents -----
---------------------------------------------------
---------------------------------------------------

-- Triggering Shamoke's event in which his sister sparrs with one of his generals
cdir_mission_manager:start_incident_db_listener(
	local_faction_key, -- faction_key
	"3k_dlc06_faction_king_shamoke_sister_sparring_incident", -- event_key
	"FactionTurnStart", -- trigger event
	function(context)
		-- this event triggers for Shamoke between turns 4 and 6.
		--output("3k_dlc06_faction_nanman_king_shamoke_events.lua: Listener Shamoke_sister_sparring_event will trigger event 3k_dlc06_char_deeds_king_shamoke_sister_sparring on turn " .. cm:get_saved_value("sister_sparring_event_turn_number", "DLC06_shamoke_faction_events_values"));
		return cdir_mission_manager:get_turn_number() == cm:get_saved_value("sister_sparring_event_turn_number", "DLC06_shamoke_faction_events_values") and context:faction():name() == local_faction_key;
    end, -- Function to fire.
	false, -- fire_once.
	nil, -- completion event 
	nil -- failure event
);


-- Triggering Shamoke's incident 3k_dlc06_faction_king_shamoke_turmoil_in_distant_lands 
cdir_mission_manager:start_incident_db_listener(
	local_faction_key, -- faction_key 
	"3k_dlc06_faction_king_shamoke_turmoil_in_distant_lands", -- event_key 
	"FactionTurnStart", -- trigger event
	function(context)
		-- this event triggers for Shamoke on turn 2.
		if cdir_mission_manager:get_turn_number() == 4 and context:faction():name() == local_faction_key then
			-- The event is themed around news of the events unfolding in the capital and news being passed to Sun Jian and Shie Xie, we reveal these regions beneath the shroud
			cm:modify_faction(context:faction():name()):make_region_seen_in_shroud("3k_main_changsha_capital");
			cm:modify_faction(context:faction():name()):make_region_seen_in_shroud("3k_main_hepu_capital");
			cm:modify_faction(context:faction():name()):make_region_seen_in_shroud("3k_main_luoyang_capital");
			cm:modify_faction(context:faction():name()):make_region_seen_in_shroud("3k_main_changan_capital");
			return true;
		end;	
	end,
	false, -- fire_once.
	nil, -- completion event 
	nil -- failure event
);


---------------------------------------------------
---------------------------------------------------
------ Listeners for Shamokes Faction Dilemma -----
---------------------------------------------------
---------------------------------------------------

-- Triggering Shamoke's dilemma for Duosi marrying his sister
cdir_mission_manager:start_dilemma_db_listener(
	local_faction_key, -- faction_key 
	"3k_dlc06_shamoke_duosi_and_sister_marriage_dilemma", -- event_key	
	"FactionTurnStart", -- trigger event
	function(context)
		-- Only fire for shamoke.
		if context:faction():name() ~= local_faction_key then
			return false;
		end;
		-- Fith condition is that at least half a year has passed since the event involving Shamoke's sister
		if context:query_model():turn_number() < cm:get_saved_value("sister_sparring_event_turn_number", "DLC06_shamoke_faction_events_values") + 2 then
			--output("3k_dlc06_faction_nanman_king_shamoke_events.lua: Listener Shamoke_Duosi_and_sister_marriage_dilemma will be triggered on turn ".. cm:get_saved_value("sister_sparring_event_turn_number", "DLC06_shamoke_faction_events_values") + 4);
			return false;
		end;
		-- Check the supplied character interfaces are valid for Shamoke's Sister and Duosi
		if cm:query_model():character_for_template("3k_dlc06_template_historical_king_duosi_hero_nanman"):is_null_interface() or cm:query_model():character_for_template("3k_dlc06_template_historical_shamoke_sister_placeholder"):is_null_interface() or cm:query_model():character_for_template("3k_dlc06_template_historical_shamoke_sister_placeholder") == nil or cm:query_model():character_for_template("3k_dlc06_template_historical_king_duosi_hero_nanman") == nil then
			script_error( "3k_dlc06_faction_nanman_king_shamoke_events.lua: Listener Shamoke_Duosi_and_sister_marriage_dilemma supplied interface is invalid.");
			return false;
		end;
		if not cm:query_model():character_for_template("3k_dlc06_template_historical_shamoke_sister_placeholder") or not cm:query_model():character_for_template("3k_dlc06_template_historical_king_duosi_hero_nanman") then
			script_error( "3k_dlc06_faction_nanman_king_shamoke_events.lua: Listener Shamoke_Duosi_and_sister_marriage_dilemma supplied interface is invalid.");
			return false;
		end;
		-- Check Shamoke's Sister and Duosi are both stil alive
		if  cm:query_character(shamoke_sister_cqi):is_dead() or cm:query_character(duosi_cqi):is_dead() then
			script_error( "3k_dlc06_faction_nanman_king_shamoke_events.lua: Listener Shamoke_Duosi_and_sister_marriage_dilemma one or both of the supplied characters is dead.");
			return false;
		end;
		-- First set of conditions for Shamoke's sister are that she is not already married, is not the present faction leader and still exists within Shamoke's faction
		if cm:query_character(shamoke_sister_cqi):family_member():has_spouse() or cm:query_character(shamoke_sister_cqi):is_faction_leader() or not cm:query_character(shamoke_sister_cqi):faction():name() == local_faction_key then
			--output("3k_dlc06_faction_nanman_king_shamoke_events.lua: Listener Shamoke_Duosi_and_sister_marriage_dilemma failed to trigger as Shamoke's sister is already married, not present in faction or is a faction leader.");
			return false;
		end;
		-- Second condition is that King Duosi is still within his faction (and presumably faction leader)
		if  not cm:query_character(duosi_cqi):faction():name() == "3k_dlc06_faction_nanman_king_duosi" then
			--output("3k_dlc06_faction_nanman_king_shamoke_events.lua: Listener Shamoke_Duosi_and_sister_marriage_dilemma failed to trigger as Duosi no longer exists within his own faction.");
			return false;
		end;
		-- Third condition is that Shamoke and King Duosi are not at war with each other
		if  cm:query_faction("3k_dlc06_faction_nanman_king_shamoke"):has_specified_diplomatic_deal_with("treaty_components_war", cm:query_faction("3k_dlc06_faction_nanman_king_duosi")) then
			--output("3k_dlc06_faction_nanman_king_shamoke_events.lua: Listener Shamoke_Duosi_and_sister_marriage_dilemma failed to trigger as Shamoke's faction is at war with Duosi's faction.");
			return false;
		end;
		-- Fourth condition is that Shamoke and King Duosi don't hate each other
		if cm:query_faction("3k_dlc06_faction_nanman_king_duosi"):diplomatic_standing_with(cm:query_faction(local_faction_key)) < -10 then
			--output("3k_dlc06_faction_nanman_king_shamoke_events.lua: Listener Shamoke_Duosi_and_sister_marriage_dilemma has not yet triggered due to poor faction relationship.");
			return false;
		end;	
		-- We check is Duosi has a wife...
		if cm:query_character(duosi_cqi):family_member():has_spouse() then
			-- If he does grab her CQI reference
			local duosi_wife_cqi = cm:query_character(duosi_cqi):family_member():spouse():character():cqi()
			--output("3k_dlc06_faction_nanman_king_shamoke_events.lua: Listener Shamoke_Duosi_and_sister_marriage_dilemma "..cm:query_character(duosi_cqi):get_forename().." is maried to "..cm:query_character(duosi_wife_cqi):get_forename()..", "..cm:query_character(duosi_wife_cqi):get_forename().." will be killed so further marriage possible.");
			cm:modify_character(duosi_wife_cqi):kill_character(false);
		end;
		return true;
	end,
	false, -- fire_once.
	success_key .. "_marriage_dilemma", -- completion event 
	failure_key .. "_marriage_dilemma",  -- failure event
	true, -- delay_start
	nil, -- on trigger event
	success_key .. "_marriage_dilemma_accepted", -- Choice One
	success_key .. "_marriage_dilemma_declined" -- Choice Two
);


-- Triggering Shamoke's dilemma for Duosi offering to become his vassal
cdir_mission_manager:start_dilemma_db_listener(
	local_faction_key, -- faction_key 
	"3k_dlc06_shamoke_duosi_vassalage_offer", -- event_key
	"FealtyCEOGained", -- trigger event
	function(context)
		-- Only fire for shamoke.
		if context:faction():name() == local_faction_key then
			-- We cannot perform this action if either of the factions involved is a vassal
			if diplomacy_manager:is_vassal(local_faction_key) or diplomacy_manager:is_vassal("3k_dlc06_faction_nanman_king_duosi") then
				output("3k_dlc06_faction_nanman_king_shamoke_events.lua: start_dilemma_db_listener 3k_dlc06_shamoke_duosi_vassalage_offer will not generate as Shamoke or Duosi is a vassal.");
				return false;
			end;
			return true;
		end;
		return false;
	end,
	false, -- fire_once.
	success_key .. "_duosi_vassalage_dilemma", -- completion event 
	failure_key .. "_duosi_vassalage_dilemma",  -- failure event
	true, -- delay_start
	nil, -- on trigger event
	success_key .. "_duosi_vassalage_dilemma_accepted", -- Choice One
	success_key .. "_duosi_vassalage_dilemma_declined", -- Choice Two
	success_key .. "_duosi_vassalage_dilemma_treachery" -- Choice Three
);

	
	-- Triggering Shamoke's dilemma for a Han faction offering an alliance after completion of 3k_dlc06_nanman_king_shamoke_han_relations_2 mission
cdir_mission_manager:start_dilemma_db_listener(
	local_faction_key, -- faction_key 
	"3k_dlc06_shamoke_alliance_proposal", -- event_key
	success_key.."_han_relations_2_complete", -- trigger event
	function(context)
		-- Always fire
		return true;
	end,
	false, -- fire_once.
	success_key .. "_alliance_proposal", -- completion event 
	failure_key .. "_alliance_proposal",  -- failure event
	false, -- delay_start
	nil, -- on trigger event
	success_key .. "_alliance_proposal_accepted_coalition", -- Choice One
	success_key .. "_alliance_proposal_accepted_military_alliance", -- Choice Two
	success_key .. "_alliance_proposal_rejected" -- Choice Three
);


---------------------------------------------------
---------------------------------------------------
-- Listeners to enable Shamokes Faction Features --
---------------------------------------------------
---------------------------------------------------

-- Selecting a potential Han Chinese faction ally for the palyer
cdir_mission_manager:start_mission_db_listener(
	local_faction_key, -- faction_key
	"3k_dlc06_nanman_king_shamoke_han_relations_1", -- event_key 
	"FactionTurnStart", -- trigger event
	function(context)
		-- Trigger the mission chain at the start of turn 5 for Shamoke
		if cdir_mission_manager:get_turn_number() == 15 and context:faction():name() == local_faction_key then
			local param_faction_interface = context:faction();
			local param_culture_key = "3k_main_chinese";
			local param_minimum_diplomatic_standing = 5;

			if param_faction_interface:is_null_interface() or param_faction_interface == nil then
				script_error("3k_dlc06_faction_nanman_king_shamoke_events.lua Function:3k_dlc06_nanman_king_shamoke_han_relations_1 supplied invalid faction interface for faction_interface");
				return false, nil;
			end;
			if not is_string(param_culture_key) then
				script_error("3k_dlc06_faction_nanman_king_shamoke_events.lua Function:3k_dlc06_nanman_king_shamoke_han_relations_1 supplied non-string for culture_key");
				return false, nil;
			end;
			if not is_number(param_minimum_diplomatic_standing) then
				script_error("3k_dlc06_faction_nanman_king_shamoke_events.lua Function:3k_dlc06_nanman_king_shamoke_han_relations_1 supplied non-numeric value for minimum_diplomatic_standing");
				return false, nil;
			end;
			-- Return a success bool and faction interface for a potential candidate
			local faction_exists, largest_faction = return_largest_potential_ally_of_faction_with_sepcified_culture(param_faction_interface ,param_culture_key, param_minimum_diplomatic_standing);
			
			-- If a faction matched the criteria given
			if faction_exists == true then
				cm:modify_faction(context:faction()):apply_automatic_diplomatic_deal("data_defined_situation_event_system_generated_target", largest_faction, "faction_key:"..context:faction():name()); 
				return true;
			end;
			-- No faction matched criteria
			return false;
		end;
	end, -- Function to fire.
	false, -- fire_once.
	success_key.."_han_relations_1_complete", -- completion event s
	success_key.."_han_relations_1_complete", -- failure event
	false -- delay start
);


cdir_mission_manager:start_mission_db_listener(
	local_faction_key, -- faction_key
	"3k_dlc06_nanman_king_shamoke_han_relations_2", -- event_key 
	success_key.."_han_relations_1_complete", -- trigger event
	function(context)
		-- This mission sends the player to the capital of another faction, we reveal the desitantion region as a means to direct them.
		-- First we find the faction who has been marked as the mission chain target by an automatic deal we had previously signed with them
		if not cm:query_faction(local_faction_key):factions_we_have_specified_diplomatic_deal_with("dummy_components_event_system_generated_target"):is_empty() then
			local target_faction_query_interface = cm:query_faction(local_faction_key):factions_we_have_specified_diplomatic_deal_with("dummy_components_event_system_generated_target"):item_at(0);

			-- Check to see if this faction has a capital (this is also a data defined generation condition)
			if not target_faction_query_interface:capital_region():is_null_interface() then
				-- Make their capital region visible through the shroud
				cm:modify_faction(local_faction_key):make_region_seen_in_shroud(target_faction_query_interface:capital_region():name());
				return true;
			end;		
		end;
		return false;
	end, -- Function to fire.
	false, -- fire_once.
	success_key.."_han_relations_2_complete", -- completion event 
	success_key.."_han_relations_2_complete", -- failure event
	true -- delay start
);

-- Triggering Shamoke's alternative victory objectives
core:add_listener(
	"Shamoke_cultural_dilemma", -- listener key
    "FealtyTribesUnitedBy", -- trigger event
	function(context)
		return local_faction_key == context:faction_key();
	end,
    function()
        cm:modify_faction(local_faction_key):trigger_dilemma("3k_dlc06_shamoke_cultural_reformation_dilemma",true);
    end, -- Function to fire.
    false -- Is Persistent?
);

-- If Shamoke chose to become Han, unlock Han diplomacy specialisation
core:add_listener(
	"shamoke_cultural_dilemma_chose_han",
	"DilemmaChoiceMadeEvent",
	function(context)
		return context:faction():name() == local_faction_key and context:dilemma() == "3k_dlc06_shamoke_cultural_reformation_dilemma" and context:choice() == 1
	end,
	function(context)
		cm:set_saved_value("specialisation_option_saved_value_key", "han_chosen", "DLC06_shamoke_faction_events_values")
		default_diplomacy:shamoke_han_diplomacy_specialisation()
	end,
	false
)
---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------
----- Name:			3k_campaign_diplomacy_manager.lua
----- Description: 	This script allows users to make requests of the diplomacy system, it also handles sending events when certain actions happen.
---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------

diplomacy_manager = {};


-- self initialsier
cm:add_first_tick_callback(function() diplomacy_manager:diplomacy_event_listeners() end); --Self register function



-- #region send events when certain deals are signed.

function diplomacy_manager:diplomacy_event_listeners()

	-- Declared as a local function as it was getting a bit long for a predicate.
	local function components_to_events(deal)
				
		local lookup = diplomacy_manager_deal_lookup:new();

		-- War Declared
		lookup:set_component("dummy_components_war_negative_trustworthiness");
		lookup:get_all_matching_components(deal):foreach(
			function(component)
				local context_data = {
					attacker = component:proposer();
					defender = component:recipient();
					component_key = component:treaty_component_key();
				}
				core:trigger_custom_event("ScriptEventWarDeclared", context_data);
			end
		);


		-- Faction Becomes Vassal
		-- Recipent becomes vassal
		lookup:set_components({
			"treaty_components_vassalage",
			"treaty_components_vassalise_recipient_no_conditions",
			"treaty_components_vassalise_recipient",
			"treaty_components_vassalise_recipient_liu_biao",
			"treaty_components_vassalise_recipient_sima_liang",
			"treaty_components_vassalise_recipient_yellow_turban",
			"treaty_components_vassalise_recipient_yuan_shu"
		});
		lookup:get_all_matching_components(deal):foreach(
			function(component)
				local context_data = {
					vassal_master = component:proposer();
					vassal = component:recipient();
					component_key = component:treaty_component_key();
				}
				core:trigger_custom_event("ScriptEventFactionBecomesVassal", context_data);
			end
		);

		-- Proposer becomes vassal
		lookup:set_components({
			"treaty_components_vassalise_proposer",
			"treaty_components_vassalise_proposer_liu_biao",
			"treaty_components_vassalise_proposer_sima_liang",
			"treaty_components_vassalise_proposer_yellow_turban",
			"treaty_components_vassalise_proposer_yuan_shu"
		});
		lookup:get_all_matching_components(deal):foreach(
			function(component)
				local context_data = {
					vassal_master = component:recipient();
					vassal = component:proposer();
					component_key = component:treaty_component_key();
				}
				core:trigger_custom_event("ScriptEventFactionBecomesVassal", context_data);
			end
		);

		-- Trade aggreement signed
		lookup:set_components({
			"treaty_components_trade",
			"treaty_components_trade_monopoly"
		});
		lookup:get_all_matching_components(deal):foreach(
			function(component)
				local context_data = {
					vassal_master = component:recipient();
					vassal = component:proposer();
					component_key = component:treaty_component_key();
				}
				core:trigger_custom_event("ScriptEventFactionSignsTrade", context_data);
			end
		);

		-- #region Alliances
		-- Creation
		lookup:set_components({
			"treaty_components_create_alliance",
			"treaty_components_create_alliance_white_tiger",
			"treaty_components_create_alliance_white_tiger_counter_offer",
			"treaty_components_create_alliance_yuan_shao",
			"treaty_components_create_alliance_yuan_shao_counter_offer",
			"treaty_components_create_alliance_yuan_shu",
			"treaty_components_create_alliance_yuan_shu_counter_offer"
		});
		lookup:get_all_matching_components(deal):foreach(
			function(component)
				local context_data = {
					proposer = component:proposer();
					recipient = component:recipient();
					component_key = component:treaty_component_key();
				}
				core:trigger_custom_event("ScriptEventAllianceCreated", context_data);
			end
		);

		-- Proposer joins
		lookup:set_component("treaty_components_join_alliance_recipients");
		lookup:get_all_matching_components(deal):foreach(
			function(component)
				local context_data = {
					alliance_member = component:recipient();
					joining_faction = component:proposer();
					component_key = component:treaty_component_key();
				}
				core:trigger_custom_event("ScriptEventAllianceJoined", context_data);
			end
		);

		-- Recipent joins
		lookup:set_component("treaty_components_join_alliance_proposers");
		lookup:get_all_matching_components(deal):foreach(
			function(component)
				local context_data = {
					alliance_member = component:proposer();
					joining_faction = component:recipient();
					component_key = component:treaty_component_key();
				}
				core:trigger_custom_event("ScriptEventAllianceJoined", context_data);
			end
		);

		-- #endregion Alliances


		-- #region Coalitions
		-- Create Coalition
		lookup:set_components({
			"treaty_components_create_coalition",
			"treaty_components_create_coalition_white_tiger",
			"treaty_components_create_coalition_white_tiger_counter_offer",
			"treaty_components_create_coalition_yuan_shao",
			"treaty_components_create_coalition_yuan_shao_counter_offer",
			"treaty_components_create_coalition_yuan_shu",
			"treaty_components_create_coalition_yuan_shu_counter_offer"
		});
		lookup:get_all_matching_components(deal):foreach(
			function(component)
				local context_data = {
					proposer = component:proposer();
					recipient = component:recipient();
					component_key = component:treaty_component_key();
				}
				core:trigger_custom_event("ScriptEventCoalitionCreated", context_data);
			end
		);

		-- Proposer joins
		lookup:set_component("treaty_components_join_coalition_recipient");
		lookup:get_all_matching_components(deal):foreach(
			function(component)
				local context_data = {
					alliance_member = component:recipient();
					joining_faction = component:proposer();
					component_key = component:treaty_component_key();
				}
				core:trigger_custom_event("ScriptEventCoalitionJoined", context_data);
			end
		);

		-- Recipents joins
		lookup:set_component("treaty_components_join_coalition_proposer");
		lookup:get_all_matching_components(deal):foreach(
			function(component)
				local context_data = {
					alliance_member = component:proposer();
					joining_faction = component:recipient();
					component_key = component:treaty_component_key();
				}
				core:trigger_custom_event("ScriptEventCoalitionJoined", context_data);
			end
		);
		-- #endregion Coalitions

		-- #region Empires
		-- Empires
		lookup:set_components({
			"treaty_components_create_empire",
			"treaty_components_create_empire_counter_offer",
			"treaty_components_create_empire_white_tiger",
			"treaty_components_create_empire_white_tiger_counter_offer",
			"treaty_components_create_empire_yuan_shao",
			"treaty_components_create_empire_yuan_shao_counter_offer"
		});
		lookup:get_all_matching_components(deal):foreach(
			function(component)
				local context_data = {
					proposer = component:proposer();
					recipient = component:recipient();
					component_key = component:treaty_component_key();
				}
				core:trigger_custom_event("ScriptEventEmpireCreated", context_data);
			end
		);

		-- Proposer joins
		lookup:set_component("treaty_components_join_empire_recipient");
		lookup:get_all_matching_components(deal):foreach(
			function(component)
				local context_data = {
					alliance_member = component:recipent();
					joining_faction = component:proposer();
					component_key = component:treaty_component_key();
				}
				core:trigger_custom_event("ScriptEventEmpireJoined", context_data);
			end
		);

		-- Recipent joins
		lookup:set_component("treaty_components_join_empire_proposer");
		lookup:get_all_matching_components(deal):foreach(
			function(component)
				local context_data = {
					alliance_member = component:proposer();
					joining_faction = component:recipient();
					component_key = component:treaty_component_key();
				}
				core:trigger_custom_event("ScriptEventEmpireJoined", context_data);
			end
		);

		-- #endregion Empires


		-- #region MPCoop
		lookup:set_component("treaty_components_multiplayer_victory");
		lookup:get_all_matching_components(deal):foreach(
			function(component)
				local context_data = {
					proposer = component:proposer();
					recipient = component:recipient();
					component_key = component:treaty_component_key();
				}
				core:trigger_custom_event("ScriptEventMultiplayerVictorySigned", context_data);
			end
		)
		-- #endregion
	end


	core:add_listener(
		"diplomacy_manager_event_triggerer", -- Unique handle
		"DiplomacyDealNegotiated", -- Campaign Event to listen for
		true, -- Criteria
		function(context) -- What to do if listener fires.
			context:deals():deals():foreach(function(deal) components_to_events(deal) end);
		end,
		true --Is persistent
	);
end;

-- #endregion

core:add_listener(
		"mp_co_op_registrar", -- UID
		"ScriptEventMultiplayerVictorySigned", -- campaign event
		function(custom_context)
			return true
		end,
		function(custom_context)
			cm:modify_model():get_modify_world():register_mp_co_op_factions(custom_context:proposer(), custom_context:recipient());
		end,
		true
	);


-- #region general query functions

function diplomacy_manager:has_specified_diplomatic_deal(faction_key, target_key, deal_key)
	local faction = cm:query_faction(faction_key);
	local target_faction = cm:query_faction(target_key);

	if faction_key == target_key then
		script_error("ERROR: Cannot apply deal with self!");
		return false;
	end;

	if not faction or faction:is_null_interface() then
		script_error("ERROR: Passed in faction doesn't exist.")
		return false;
	end;

	if not target_faction or target_faction:is_null_interface() then
		script_error("ERROR: Passed in target_faction doesn't exist.")
		return false;
	end;

	return faction:has_specified_diplomatic_deal_with(deal_key, target_faction);
end;

-- #region War
function diplomacy_manager:is_at_war_with(faction_key, target_key)
	return self:has_specified_diplomatic_deal(faction_key, target_key, "treaty_components_war") 
		or self:has_specified_diplomatic_deal(faction_key, target_key, "treaty_components_group_war")
end;

function diplomacy_manager:factions_at_war_with(faction_key)
	local query_faction = cm:query_faction(faction_key);

	if not query_faction or query_faction:is_null_interface() then
		script_error("ERROR: Passed in faction doesn't exist.")
		return;
	end;

	local faction_list = cm:query_model():world():faction_list();
	return faction_list:filter(function(test_faction) 
			return not test_faction:is_dead()
				and test_faction ~= query_faction
				and self:is_at_war_with(query_faction, test_faction)
		end);
end;
-- #endregion War

-- #region Trade

function diplomacy_manager:factions_trading_with(faction_reference)
	local query_faction = cm:query_faction(faction_reference);

	if not query_faction or query_faction:is_null_interface() then
		return false;
	end;

	local faction_list = cm:query_model():world():faction_list();
	return faction_list:filter(function(test_faction) 
			return not test_faction:is_dead()
				and test_faction ~= query_faction
				and self:is_trading_with(query_faction, test_faction)
		end);
end

function diplomacy_manager:is_trading_with(faction_key, target_key)
	return self:has_specified_diplomatic_deal(faction_key, target_key, "treaty_components_trade") or self:has_specified_diplomatic_deal(faction_key, target_key, "treaty_components_trade_monopoly");
end

function diplomacy_manager:has_trade(faction_reference)
	local query_faction = cm:query_faction(faction_reference);

	if not query_faction or query_faction:is_null_interface() then
		return false;
	end;

	return query_faction:has_specified_diplomatic_deal_with_anybody("treaty_components_trade") or query_faction:has_specified_diplomatic_deal_with_anybody("treaty_components_trade_monopoly");	
end

-- #endregion Trade

-- #region Vassals
function diplomacy_manager:is_vassal_of(master_key, vassal_key)
	return self:get_vassal_master(vassal_key) == cm:query_faction(master_key)
end;

function diplomacy_manager:is_vassal(faction_key)
	if self:get_vassal_master(cm:query_faction(faction_key)) then
		return true;
	end;

	return false;
end;

function diplomacy_manager:get_all_vassal_factions(faction_reference)
	local master_faction = cm:query_faction(faction_reference);

	if not master_faction or master_faction:is_null_interface() then
		script_error("ERROR: Passed in faction doesn't exist.")
		return;
	end;

	-- we cannot directly get a faction's vassal status so we'll go through all factions and check if they have the treaty and can be annexed.
	return master_faction:factions_we_have_specified_diplomatic_deal_with_directional("treaty_components_vassalage", true)
end;

function diplomacy_manager:get_vassal_master(query_vassal_faction)
	
	query_vassal_faction = cm:query_faction(query_vassal_faction)

	if not query_vassal_faction or query_vassal_faction:is_null_interface() then
		script_error("Diplomacy Manager: Error! Get Vassal Master faction passed invalid!")
		return
	end
	
	local matching_factions = query_vassal_faction:factions_we_have_specified_diplomatic_deal_with_directional("treaty_components_vassalage", false)

	if not matching_factions or matching_factions:is_empty() then
		return nil;
	end;

	--if only 1 master in list
	if matching_factions:num_items() < 2 then
		matching_factions = matching_factions:item_at(0)
	else
		script_error("Diplomacy Manager: More than 1 vassal master for faction "..query_vassal_faction)
		return
	end

	return matching_factions;
end;

function diplomacy_manager:get_num_vassal_regions(faction_reference)
	local num_regions = 0;
	local query_faction = cm:query_faction(faction_reference);
	self:get_all_vassal_factions(query_faction:name()):foreach(
		function(vassal_faction)
			num_regions = num_regions + vassal_faction:region_list():num_items();
		end
	)

	return num_regions;
end;
-- #endregion Vassals


-- #region Alliances


function diplomacy_manager:is_faction_in_alliance(faction_reference)
	local query_faction = cm:query_faction(faction_reference);

	if not query_faction or query_faction:is_null_interface() then
		return false;
	end;

	return query_faction:has_specified_diplomatic_deal_with_anybody("treaty_components_alliance");	
end;

function diplomacy_manager:is_faction_in_coalition(faction_reference)
	local query_faction = cm:query_faction(faction_reference);

	if not query_faction or query_faction:is_null_interface() then
		return false;
	end;

	return query_faction:has_specified_diplomatic_deal_with_anybody("treaty_components_coalition");	
end;


function diplomacy_manager:is_allied_to(faction_key, target_key)
	return self:has_specified_diplomatic_deal(faction_key, target_key, "treaty_components_alliance");
end;

function diplomacy_manager:is_in_coalition_with(faction_key, target_key)
	return self:has_specified_diplomatic_deal(faction_key, target_key, "treaty_components_coalition");
end;


function diplomacy_manager:get_all_factions_in_alliance(faction_reference)
	local query_faction = cm:query_faction(faction_reference);
	
	if not query_faction or query_faction:is_null_interface() then
		return nil;
	end;

	return query_faction:factions_we_have_specified_diplomatic_deal_with("treaty_components_alliance");
end;

function diplomacy_manager:get_all_factions_in_coalition(faction_reference)
	local query_faction = cm:query_faction(faction_reference);
	
	if not query_faction or query_faction:is_null_interface() then
		return nil;
	end;

	return query_faction:factions_we_have_specified_diplomatic_deal_with("treaty_components_coalition");
end;


function diplomacy_manager:get_num_allied_regions(faction_reference)
	local num_regions = 0;
	local query_faction = cm:query_faction(faction_reference);

	if not self:is_faction_in_alliance(query_faction) then
		return 0;
	end;

	self:get_all_factions_in_alliance(query_faction):foreach(
		function(ally)
			num_regions = num_regions + ally:region_list():num_items();
		end
	)

	return num_regions;
end;

function diplomacy_manager:get_num_coalition_regions(faction_reference)
	local num_regions = 0;
	local query_faction = cm:query_faction(faction_reference);

	if not self:is_faction_in_coalition(query_faction) then
		return 0;
	end;

	self:get_all_factions_in_coalition(query_faction):foreach(
		function(ally)
			num_regions = num_regions + ally:region_list():num_items();
		end
	)

	return num_regions;
end;

function diplomacy_manager:is_ally_or_vassal(faction_key, target_key)
	return self:is_allied_to(faction_key, target_key) or self:is_faction_in_coalition(faction_key, target_key) or self:is_vassal_of(faction_key, target_key)
end

-- #endregion Alliances


-- #region Coop Victory
function diplomacy_manager:is_mp_coop_victory_enabled(faction_reference)
	local query_faction = cm:query_faction(faction_reference);
	return query_faction:has_specified_diplomatic_deal_with_anybody("treaty_components_multiplayer_victory");
end;

function diplomacy_manager:get_all_coop_victory_partners(faction_reference)
	local query_faction = cm:query_faction(faction_reference)
	
	if not query_faction or query_faction:is_null_interface() then
		return nil;
	end;

	return query_faction:factions_we_have_specified_diplomatic_deal_with("treaty_components_multiplayer_victory")
end

-- #endregion Coop Victory

-- #endregion



-- #region general modify functions

function diplomacy_manager:apply_automatic_deal_between_factions(primary_faction_key, target_faction_key, deal_key, is_silent)
	local primary_faction = cm:query_faction(primary_faction_key);
	local target_faction = cm:query_faction(target_faction_key);
	is_silent = is_silent or false;

	if primary_faction_key == target_faction_key then
		script_error("ERROR: Cannot apply deal with self!");
		return false;
	end;

	if not is_string(deal_key) then
		script_error("ERROR: Deal key must be a string.");
		return;
	end;

	if not primary_faction or primary_faction:is_null_interface() then
		script_error("ERROR: Passed in primary_faction doesn't exist.");
		return;
	end;

	if not target_faction or target_faction:is_null_interface() then
		script_error("ERROR: Passed in target_faction doesn't exist.");
		return;
	end;

	if not primary_faction:can_apply_automatic_diplomatic_deal(deal_key, target_faction, "faction_key:" .. target_faction_key) then
		output("ERROR: Cannot apply deal between factions.");
		return false;
	end;

	if is_silent then
		output("blocking EF")
		cm:disable_event_feed_events(true, "3k_event_category_diplomacy");
		core:add_listener(
			"ev_supp",
			"ScriptEventPreDeleteModelInterface",
			true,
			function()
				core:add_listener(
				"ev_supp",
				"ScriptEventPreDeleteModelInterface",
				true,
				function()
					output("unblocking EF")
					cm:disable_event_feed_events(false, "3k_event_category_diplomacy");
				end,
				false
			);
			end,
			false
		);
	end;

	cm:modify_faction(primary_faction):apply_automatic_diplomatic_deal(
		deal_key, 
		target_faction,
		"faction_key:" .. target_faction_key
	);

	return true;
end;

function diplomacy_manager:force_declare_war(faction_key, target_faction_key, is_silent)

	if faction_key == target_faction_key then
		script_error("ERROR: Cannot declare war against yourself. Please find out why this is happening. Faction: " .. faction_key);
		return false;
	end;

	if self:is_at_war_with(faction_key, target_faction_key) then
		output("ERROR: Factions already at war!");

		return false;
	end;

	return self:apply_automatic_deal_between_factions(faction_key, target_faction_key, "data_defined_situation_war_proposer_to_recipient", is_silent);
end;

function diplomacy_manager:grant_military_access(faction_key, target_faction_key, is_silent)
	if self:has_specified_diplomatic_deal(faction_key, target_faction_key, "treaty_components_military_access") then
		output("ERROR: Factions already have military access.");

		return false;
	end;

	return self:apply_automatic_deal_between_factions(faction_key, target_faction_key, "data_defined_situation_military_access", is_silent);
end;

function diplomacy_manager:force_confederation(confederator_key, confederated_key)
	
	if not is_string(confederator_key) then
        script_error("ERROR: force_confederation() called but supplied faction key [" .. tostring(confederator_key) .. "] is not a string")
        return false;
	end;
	
	if not is_string(confederated_key) then
        script_error("ERROR: force_confederation() called but supplied other_faction key [" .. tostring(confederated_key) .. "] is not a string")
        return false;
	end;	

	local confederator = cm:query_faction(confederator_key);
	local confederated = cm:query_faction(confederated_key);
		
	if not confederator or confederator:is_null_interface() or not confederated or confederated:is_null_interface() then
		return false;
	end;

	if confederated:is_human() then
		output("force_confederation() Not proceeding with confederation as human faction is being confederated.")
		return false;
	end;

	if confederator:is_dead() or confederated:is_dead() then
		output("force_confederation() Either " .. confederator_key .. " or " .. confederated_key .. " is dead")
		return false;
	end;

	if not cm:modify_faction(confederator):make_confederation_with(confederated) then
		output("force_confederation() Failed to trigger confederation with " .. confederator_key .. " and " .. confederated_key)
		return false;
	end;
		
	output("force_confederation() Successfully to trigger confederation with " .. confederator_key .. " and " .. confederated_key)
	return true;
end;

-- #endregion



-- #region Deal Lookup Object

diplomacy_manager_deal_lookup = {
	component_keys = nil; -- Can be a table OR a string.
	proposer_faction_key = nil;
	recipient_faction_key = nil;
	wildcard_faction_keys = {};
};

function diplomacy_manager_deal_lookup:new()
	-- Declare our class.
	local o = {};
		
	setmetatable(o, self);
	self.__index = self;
	self.__tostring = function() return "TYPE_DIPLOMACY_DEAL_LOOKUP" end;

	o.component_keys = nil; -- Can be a table OR a string.
	o.proposer_faction_key = nil;
	o.recipient_faction_key = nil;
	o.wildcard_faction_keys = {};

	return o;
end;

function diplomacy_manager_deal_lookup:set_component(component_key)

	if not is_string(component_key) then
		script_error("diplomacy_manager_deal_lookup:set_component() Component key must be a string.");
		return false;
	end;

	self.component_keys = component_key;
end;

function diplomacy_manager_deal_lookup:set_components(component_keys)

	-- If user passed in a string, just deal with it as a component.
	if is_string(component_keys) then
		self:set_component(component_keys);
		return true;
	end;

	if not is_table(component_keys) then
		script_error("diplomacy_manager_deal_lookup:set_components_any_of() Component key must be a table.");
		return false;
	end;

	self.component_keys = component_keys;
end;

function diplomacy_manager_deal_lookup:set_proposer_faction_key(proposer_faction_key)

	if not is_string(proposer_faction_key) then
		script_error("diplomacy_manager_deal_lookup:set_proposer_faction_key() set_proposer_faction_key must be a string.");
		return false;
	end;

	self.proposer_faction_key = proposer_faction_key;
end;

function diplomacy_manager_deal_lookup:set_recipient_faction_key(recipient_faction_key)

	if not is_string(recipient_faction_key) then
		script_error("diplomacy_manager_deal_lookup:recipient_faction_key() recipient_faction_key must be a string.");
		return false;
	end;

	self.recipient_faction_key = recipient_faction_key;
end;

function diplomacy_manager_deal_lookup:add_faction_key(faction_key)

	if not is_string(faction_key) then
		script_error("diplomacy_manager_deal_lookup:add_faction_key() add_faction_key must be a string.");
		return false;
	end;

	table.insert(self.wildcard_faction_keys, faction_key);
end;

function diplomacy_manager_deal_lookup:is_match_in_deal(deal)

	return deal:components():any_of(function(component) return self:does_component_match_lookup(component) end);
end;

function diplomacy_manager_deal_lookup:is_match_in_deals(deal_list)
	-- Check we got the correct objects
	if not is_query_diplomacy_negotiated_deals(deal_list)
		and not is_query_diplomacy_deal_list(deal_list)
		and not is_query_diplomacy_negotiated_deal_list(deal_list)
		then

		script_error("diplomacy_manager_deal_lookup:is_match_in_deals() Expected negotiated_deals or a deal list, got " .. tostring(deal_list));
		return false;
	end;
	
	-- Convert to a deal_list if it's not already.
	if is_query_diplomacy_negotiated_deals(deal_list) then
		deal_list = deal_list:deals();
	end;
	
	if deal_list:is_empty() then
		script_error("Deal list is empty.");
		return false;
	end;

	return deal_list:any_of( function(deal) return self:is_match_in_deal(deal) end );
end;

function diplomacy_manager_deal_lookup:get_all_matching_components(deal)

	if not is_query_diplomacy_negotiated_deal(deal) and not is_query_diplomacy_deal(deal) then
		script_error("Expected deal or negotiated_deal, got " .. tostring(deal));
		return false;
	end;

	return deal:components():filter(function(component) return self:does_component_match_lookup(component) end);
end;

function diplomacy_manager_deal_lookup:does_component_match_lookup(component)

	if not is_query_diplomacy_proposed_component(component) and not is_query_diplomacy_deal_component(component) then
		script_error("Expected proposed_compoenent or deal_component, got " .. tostring(component));
		return false;
	end;

	-- check for component key match.
	if self.component_keys then 
		if is_string(self.component_keys) and component:treaty_component_key() ~= self.component_keys then
			return false;
		elseif is_table(self.component_keys) and #self.component_keys > 0 then
			local found_match = false;
			for i, key in ipairs(self.component_keys) do
				if component:treaty_component_key() == key then
					found_match = true;
					break;
				end;
			end;

			if not found_match then
				return false;
			end;
		end;
	end

	-- proposer match.
	if self.proposer_faction_key and component:proposer():name() ~= self.proposer_faction_key then
		return false;
	end;

	-- recipient match.
	if self.recipient_faction_key and component:recipient():name() ~= self.recipient_faction_key then
		return false;
	end;

	-- wildcard matches.
	for i, key in ipairs(self.wildcard_faction_keys) do
		if component:proposer():name() ~= key and component:recipient():name() ~= key then
			return false;
		end;
	end;

	return true;
end;

-- #endregion



-- #region Deal List Functions

function diplomacy_manager:faction_signed_component_in_deals(deals, faction_key, treaty_component_key, opt_other_faction)

	if not is_string(faction_key) then
		script_error("diplomacy_manager:faction_signed_component_in_deals() faction_key must be a string");
		return false;
	end;

	if opt_other_faction and not is_string(opt_other_faction) then
		script_error("diplomacy_manager:faction_signed_component_in_deals() opt_other_faction must be a string or nil");
		return false;
	end;

	if not is_string(treaty_component_key) then
		script_error("diplomacy_manager:faction_signed_component_in_deals() treaty_component_key must be a string");
		return false;
	end;

	-- create a lookup.
	local lookup = diplomacy_manager_deal_lookup:new();
		lookup:set_component(treaty_component_key);
		lookup:add_faction_key(faction_key);
		if opt_other_faction then
			lookup:add_faction_key(opt_other_faction);
		end;

	-- return if lookup matches.
	return lookup:is_match_in_deals(deals);
end;

function diplomacy_manager:faction_proposer_in_deals(deals, faction_key)

	if not is_string(faction_key) then
		script_error("diplomacy_manager:faction_proposer_in_deals() faction_key must be a string.");
		return false;
	end;

	-- create a lookup.
	local lookup = diplomacy_manager_deal_lookup:new();
		lookup:set_proposer_faction_key(faction_key);

	return lookup:is_match_in_deals(deals);
end;

function diplomacy_manager:faction_recipient_in_deals(deals, faction_key)

	if not is_string(faction_key) then
		script_error("diplomacy_manager:faction_recipient_in_deals() faction_key must be a string.");
		return false;
	end;

	-- create a lookup.
	local lookup = diplomacy_manager_deal_lookup:new();
		lookup:set_recipient_faction_key(faction_key);

	return lookup:is_match_in_deals(deals);
end;

-- #endregion

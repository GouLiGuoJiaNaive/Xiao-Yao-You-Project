---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------
----- Name:			dlc06_faction_nanman_king_shamoke_features.lua
----- Description: 	This script handles king shamoke's faction mechanics.
---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------

-- Don't load in campaigns which don't require it.
if cm.name == "ep_eight_princes" then
	output("dlc06_faction_nanman_king_shamoke_features.lua: Not loaded in this campaign." );
	return;
else
	output("dlc06_faction_nanman_king_shamoke_features.lua: Loading");
end;

local local_faction_key = "3k_dlc06_faction_nanman_king_shamoke";


-- #region Private Methods

--- Function Shamoke_vassalisation_resource_modify
--- Function applies the resource_modify_value to the query_pooled_resource_shamoke_vassalise using the factor of default_pooled_resource_factor
--- Can be a increase or decrease based on arguments. We trigger increase on creation of a new vassal, a decrease on vassal independence or vassal faction death.
local function Shamoke_vassalisation_resource_modify(resource_modify_value)
	resource_modify_value = resource_modify_value or 1;

	local query_faction = cm:query_faction(local_faction_key);
	local query_pooled_resource_shamoke_vassalise = query_faction:pooled_resources():resource("3k_dlc06_pooled_resource_shamoke_vassalise");
	
	if not query_faction or query_faction:is_null_interface() then
		script_error("dlc06_faction_nanman_king_shamoke_features.lua: Cannot find faction.");
	end;

	if query_pooled_resource_shamoke_vassalise:is_null_interface() then
		script_error("dlc06_faction_nanman_king_shamoke_features.lua: Cannot find [3k_dlc06_pooled_resource_shamoke_vassalise] resource.");
	end;

	cm:modify_model():get_modify_pooled_resource(query_pooled_resource_shamoke_vassalise):apply_transaction_to_factor("3k_dlc06_pooled_factor_shamoke_vassalise", resource_modify_value);	
end;


--- Function Shamoke_confederation_resource_modify
--- Function applies the resource_modify_value to the query_pooled_resource_shamoke_vassalise using the factor of default_pooled_resource_factor
--- Can be a increase or decrease based on arguments. We trigger increase on creation of a new vassal, a decrease on vassal independence or vassal faction death.
local function Shamoke_confederation_resource_modify(resource_modify_value)
	resource_modify_value = resource_modify_value or 1;

	local query_faction = cm:query_faction(local_faction_key);
	local query_pooled_resource_shamoke_confederate = query_faction:pooled_resources():resource("3k_dlc06_pooled_resource_shamoke_confederate");
	
	if not query_faction or query_faction:is_null_interface() then
		script_error("dlc06_faction_nanman_king_shamoke_features.lua: Cannot find faction.");
	end;

	if query_pooled_resource_shamoke_confederate:is_null_interface() then
		script_error("dlc06_faction_nanman_king_shamoke_features.lua: Cannot find [3k_dlc06_pooled_resource_shamoke_confederate] resource.");
	end;

	cm:modify_model():get_modify_pooled_resource(query_pooled_resource_shamoke_confederate):apply_transaction_to_factor("3k_dlc06_pooled_factor_shamoke_confederate", resource_modify_value);
end;


--- Function deal signed between factions of the same culture
--- Function passed a deal as a parameter then checks the proposer and recipient participants.
local function Deal_signed_by_factions_of_same_culture(negotiated_deal)
	local has_one_proposer = negotiated_deal:proposers():num_items() == 1;
	local has_one_recipient = negotiated_deal:recipients():num_items() == 1;
	local proposer_faction = negotiated_deal:proposers():item_at(0):primary_faction();
	local recipient_faction = negotiated_deal:recipients():item_at(0):primary_faction();

	-- Check that the supplied deal has only 1 proposer and 1 recipient
	if not has_one_proposer then
		script_error("dlc06_faction_nanman_king_shamoke_features.lua Function:Deal_signed_by_factions_of_same_culture supplied " .. tostring(negotiated_deal:proposers():num_items()) " proposers, exceeding expected amount (1)");
		return false;
	end;

	if not has_one_recipient then
		script_error("dlc06_faction_nanman_king_shamoke_features.lua Function:Deal_signed_by_factions_of_same_culture supplied " .. tostring(negotiated_deal:recipients():num_items()) " recipients, exceeding expected amount (1)");
		return false;
	end;

	-- Check that the supplied faction interfaces from the deal are both valid
	if not proposer_faction or proposer_faction:is_null_interface() then
		script_error("dlc06_faction_nanman_king_shamoke_features.lua Function:Deal_signed_by_factions_of_same_culture supplied invalid proposer faction interface");
		return false;
	end;

	if not recipient_faction or recipient_faction:is_null_interface() then
		script_error("dlc06_faction_nanman_king_shamoke_features.lua Function:Deal_signed_by_factions_of_same_culture supplied invalid recipient faction interface");
		return false;
	end;

	-- Check the supplied deal primary participants are not of the same culutre
	return proposer_faction:subculture() == recipient_faction:subculture();
end;

-- #endregion


-- #region Public Methods

-- #endregion


-- #region Events

-- Faction vassalised. If the vassal lord is Shamoke, give vassalisation pooled resource.
core:add_listener(
	"Shamoke_diplomacy_option_vassalise", -- listener key
	"ScriptEventFactionBecomesVassal", -- campaign event
	function(context)
		-- Check if Shamoke is the vassal lord and that the recipient shares the same subculture
		if context:vassal_master():name() ~= local_faction_key then
			output("dlc06_faction_nanman_king_shamoke_features.lua Shamoke_diplomacy_option_vassalise vassal lord: " .. context:vassal_master():name().. "is not Shamoke");
			return false;
		end;

		
		return not context:vassal():is_rebel() and context:vassal():subculture() == context:vassal_master():subculture();
	end, --Conditions for firing
	function(context)
		output("dlc06_faction_nanman_king_shamoke_features.lua Shamoke_diplomacy_option_vassalise_recipient modifying Shamoke vassalisation resource");
		Shamoke_vassalisation_resource_modify(1) -- applies vassalisation pooled resource incease
	end, -- Function to fire.
	true -- Is Persistent?
);


-- Listener to see if Shamoke has offered liberation to any of his Nanman vassals
core:add_listener(
	"Shamoke_diplomacy_option_liberate", -- listener key
	"DiplomacyDealNegotiated", -- campaign event
	function(context)
		if not context:deals():deals():any_of(Deal_signed_by_factions_of_same_culture) then
			return false;
		end;

		return (diplomacy_manager:faction_signed_component_in_deals(context:deals(), local_faction_key, "treaty_components_liberate_recipient") and diplomacy_manager:faction_proposer_in_deals(context:deals(), local_faction_key))
			or (diplomacy_manager:faction_signed_component_in_deals(context:deals(), local_faction_key, "treaty_components_liberate_proposer") and diplomacy_manager:faction_recipient_in_deals(context:deals(), local_faction_key))
	end,
	function(context)
		output("dlc06_faction_nanman_king_shamoke_features.lua Shamoke_diplomacy_option_liberate modifying Shamoke vassalisation resource");
		Shamoke_vassalisation_resource_modify(-1) -- applies vassalisation pooled resource change
	end, -- Function to fire.
	true -- Is Persistent?
);


-- Listener to see if any of Shamoke's Nanman vassals have declared independence
core:add_listener(
	"Shamoke_diplomacy_option_declare_independence", -- listener key
	"DiplomacyDealNegotiated", -- campaign event
	function(context)
		if not context:deals():deals():any_of(Deal_signed_by_factions_of_same_culture) then
			return false;
		end;
		-- Check if Shamoke is the recipient in the signed deal and that the proposer is of the same culture
		return diplomacy_manager:faction_signed_component_in_deals(context:deals(), local_faction_key, "treaty_components_declare_independence") and diplomacy_manager:faction_recipient_in_deals(context:deals(), local_faction_key);
	end,
	function(context)
		-- Apply vassalisation pooled resource change
		output("dlc06_faction_nanman_king_shamoke_features.lua Shamoke_diplomacy_option_liberate_proposer modifying Shamoke vassalisation resource");
		Shamoke_vassalisation_resource_modify(-1) 
	end, -- Function to fire.
	true -- Is Persistent?
);


-- Faction About to Die. If the confederator is Shamoke, give confederate pooled resource.
-- Else if the faction is Nanman and a vassal of Shamoke remove vassal pooled resource.
core:add_listener(
	"nanman_faction_about_to_die", -- listener key
	"FactionAboutToDie", -- campaign event
	function(context)
		-- Only check for factions about to die of same culture.
		return context:faction():subculture() == cm:query_faction(local_faction_key):subculture() and not context:faction():is_rebel(); 
	end, --Conditions for firing
	function(context)
		-- If we know who killed them it was likely through battle or confederation.
		if context:killer_or_confederator_faction_key() ~= "" then
			local query_killer_faction = cm:query_faction(context:killer_or_confederator_faction_key());

			if query_killer_faction and query_killer_faction:is_null_interface() then 
				script_error("dlc06_faction_nanman_king_shamoke_features.lua Supplied interface for query_killer_faction is invalid"); 
				return; 
			end;

			-- Check if Shamoke is the perpetrator of this act
			if query_killer_faction:name() == local_faction_key then
				-- Shamoke has wiped out an opposing tribe, this makes him mighty
				Shamoke_confederation_resource_modify(1)
			end;
		end;

		-- We need to check if it was a vassal of Shamoke who died
		if cm:query_faction(local_faction_key):has_specified_diplomatic_deal_with("treaty_components_vassalage", context:faction()) then
			-- We reduce his vassalisation pooled resource as a result
			Shamoke_vassalisation_resource_modify(-1)
		end;
	end, -- Function to fire.
	true -- Is Persistent?
);
-- #endregion
---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------
----- Name:			Shi Xie pooled resource and unique CEO creation manager
----- Description: 	This script handles the management of Shi Xie's family and creation and management of Tribute Chests
---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------

-- Early exit if we're in certain campaigns.
if cm.name == "ep_eight_princes" or cm.name == "dlc04_mandate" then
	output("shi_xie_resource_manager: Not loaded in this campaign." );
	return;
else
	output("dlc06_faction_resource_shi_xie.lua: Loading");
end;


--namespace
shi_xie_resource_manager = {
	debug_mode = false;
	system_id = "shi_xie_resource_manager - ";
	listener_name = "dlc06_shi_xie_resource_manager_listener_";

	shi_xie_faction_name = "3k_main_faction_shi_xie";
	
	------ pooled resource key and factors ------
	pooled_resource_key = "3k_dlc06_pooled_resource_splendour";
	pooled_factor_chest_creation = "3k_dlc06_pooled_factor_splendour_tribute_chests";

	------ resource generation numbers ----------
	splendour_generation_faction_leaders = 10;

	splendour_chest_cost = 65;	
	
	------- ceo generation data ------------------
	accessory_ceo_key = "3k_main_ceo_category_ancillary_accessory";

	chest_diplomacy_simple = "3k_dlc06_ancillary_accessory_tribute_chest_diplomacy_simple";
	chest_diplomacy_extraordinary = "3k_dlc06_ancillary_accessory_tribute_chest_diplomacy_extraordinary";
	chest_personal_simple = "3k_dlc06_ancillary_accessory_tribute_chest_personal_simple";
	chest_personal_extraordinary = "3k_dlc06_ancillary_accessory_tribute_chest_personal_extraordinary";
	chest_regional_simple = "3k_dlc06_ancillary_accessory_tribute_chest_regional_simple";
	chest_regional_extraordinary = "3k_dlc06_ancillary_accessory_tribute_chest_regional_extraordinary";

	
	family_member_ceo_key = "3k_dlc06_ceo_family_member_tag";

	------ family and court keys ------
	family_tree = {};
	family_progenitor_key = "3k_main_template_ancestral_shi_ci";
	------------------------

}

function shi_xie_resource_manager:add_listeners()

	self:add_narrative_listeners()


	--handles faction spawnings so we can know the exact number of shi factions
	core:add_listener(
		self.listener_name.."shi_xie_vassals_check", -- Unique handle
		"FactionTurnStart", -- Campaign Event to listen for
		function(context) -- Criteria
			return context:faction():name() == "3k_main_faction_shi_xie"
		end,
		function(context) -- What to do if listener fires.
			self:update_family_member_vassals()
		end,
		true --Is persistent
	)

	--listeners for the chest spawning

	-- The UI sends a message to the system. Which will then spawn chests.
	core:add_listener(
		self.listener_name.."chest_spawn_listener", -- UID
		"ModelScriptNotificationEvent", -- Event
		function(context)
			if string.match(context:event_id(), "create_tribute_chest_3k_dlc06_ancillary_accessory_tribute_chest") then
				return true
			end
		end, --Conditions for firing
		function(context)
			local splendour_amount = cm:query_faction(self.shi_xie_faction_name):pooled_resources():resource(self.pooled_resource_key):value()

			local ceo_key = string.gsub(context:event_id(), "create_tribute_chest_", "")

			if splendour_amount - self.splendour_chest_cost >= 0 then
				self:spawn_chest(ceo_key)
			else
				script_error("SCRIPT ERROR IN SPAWNING TRIBUTE CHEST. Not enough pooled resource. This shouldn't happen as the UI should filter for this")
			end

		end, -- Function to fire.
		true -- Is Persistent?
	)

	core:add_listener(
		self.listener_name.."CharacterComesOfAge", -- Unique handle
		"CharacterComesOfAge", -- Campaign Event to listen for
		function(context) -- Criteria
			return cm:query_faction(self.shi_xie_faction_name):is_human() and self:is_in_family_tree(context:query_character()) --Criteria Test
		end,
		function(context) -- What to do if listener fires.
			self:add_to_family_tree(context:query_character())
		end,
		true --Is persistent
	)

	core:add_listener(
		self.listener_name.."CharacterMarries", -- Unique handle
		"CharacterMarried", -- Campaign Event to listen for
		function(context) -- Criteria

			if self:is_in_family_list(context:query_proposer_character()) or
			self:is_in_family_list(context:query_recipient_character()) then
				return true
			end
			
			
		end,
		function(context) -- What to do if listener fires.
			if self:is_in_family_list(context:query_proposer_character()) then
				self:add_to_family_tree(context:query_recipient_character())
			end

			if self:is_in_family_list(context:query_recipient_character()) then
				self:add_to_family_tree(context:query_proposer_character())
			end

		end,
		true --Is persistent
	)

	core:add_listener(
		self.listener_name.."CharacterAdopted", -- Unique handle
		"CharacterAdopted", -- Campaign Event to listen for
		function(context) -- Criteria
			if self:is_in_family_list(context:query_new_parent_character()) then
				return true
			end
		end,
		function(context) -- What to do if listener fires.
			self:add_to_family_tree(context:query_adopted_character())
		end,
		true --Is persistent
	)


end

function shi_xie_resource_manager:add_narrative_listeners()

	--adds family members added via events
	core:add_listener(
		self.listener_name.."shi_xie_shi_wei_joins", -- Unique handle
		"ActiveCharacterCreated", -- Campaign Event to listen for
		function(context) -- Criteria
			if context:query_character():generation_template_key() == "3k_dlc06_template_historical_shi_wei_hero_metal"
			or context:query_character():generation_template_key() == "3k_dlc06_template_historical_shi_kuang_hero_fire"
			or context:query_character():generation_template_key() == "3k_main_template_historical_shi_zhi_hero_water" then
				return true
			end
		end,
		function(context) -- What to do if listener fires.

			--gets the characters we need
			local modify_shi_ci = cm:modify_character(cm:query_model():character_for_template("3k_main_template_ancestral_shi_ci"):cqi())
			local modify_shi_xie = cm:modify_character(cm:query_model():character_for_template("3k_main_template_historical_shi_xie_hero_water"):cqi())
			local modify_shi_yi = cm:modify_character(cm:query_model():character_for_template("3k_main_template_historical_shi_yi_hero_metal"):cqi())
			local modify_character = cm:modify_character(context:query_character():cqi())


			--assigns our character to model family so we can get the full in-game family functionality
			if context:query_character():generation_template_key() == "3k_dlc06_template_historical_shi_wei_hero_metal" then
				modify_character:make_child_of(modify_shi_ci)
			elseif context:query_character():generation_template_key() == "3k_dlc06_template_historical_shi_kuang_hero_fire" then
				modify_character:make_child_of(modify_shi_yi)
			elseif context:query_character():generation_template_key() == "3k_main_template_historical_shi_zhi_hero_water" then
				modify_character:make_child_of(modify_shi_xie)
			end

			--assigns character to script family so we can get the new shi family mechanics
			self:add_to_family_tree(context:query_character())
		end,
		true --Is persistent
	)

	--listens for envy event
	core:add_listener(
		self.listener_name.."shi_xie_non_family_envy", -- Unique handle
		"DilemmaChoiceMadeEvent", -- Campaign Event to listen for
		function(context) -- Criteria
			return context:dilemma() == "3k_dlc06_dilemma_shi_xie_family_envy" and context:choice() == 0
		end,
		function(context) -- What to do if listener fires.

			for i = 0, context:faction():character_list():num_items()-1 do
				local character = context:faction():character_list():item_at(i)
				if not self:is_in_family_list(character) then
					cm:modify_character(character):ceo_management():add_ceo("3k_dlc06_ceo_shi_xie_non_family_unsatisfied")
				end
			end

		end,
		true --Is persistent
	)

	--listens for jealousy event
	core:add_listener(
		self.listener_name.."shi_xie_family_jealousy", -- Unique handle
		"DilemmaChoiceMadeEvent", -- Campaign Event to listen for
		function(context) -- Criteria
			return context:dilemma() == "3k_dlc06_dilemma_shi_xie_family_jealousy" and context:choice() == 2
		end,
		function(context) -- What to do if listener fires.

			for i = 0, context:faction():character_list():num_items()-1 do
				local character = context:faction():character_list():item_at(i)
				if character:ceo_management():has_ceo_equipped("3k_dlc06_ceo_hidden_script_event_character_mark") then
					output("\n\n\neureka\n\n\n")
				end
			end
			

		end,
		true --Is persistent
	)

end

cm:add_first_tick_callback(function() shi_xie_resource_manager:Initialise() end) --self register function

function shi_xie_resource_manager:update_UI_values()
	effect.set_context_value("3k_dlc06_pooled_resource_splendour_generation_faction_leader_value", self.splendour_generation_faction_leaders)
	effect.set_context_value("3k_dlc06_ancillary_accessory_tribute_chest_regional_simple_cost", self.splendour_chest_cost)
	effect.set_context_value("3k_dlc06_ancillary_accessory_tribute_chest_regional_extraordinary_cost", self.splendour_chest_cost)
	effect.set_context_value("3k_dlc06_ancillary_accessory_tribute_chest_personal_simple_cost", self.splendour_chest_cost)
	effect.set_context_value("3k_dlc06_ancillary_accessory_tribute_chest_personal_extraordinary_cost", self.splendour_chest_cost)
	effect.set_context_value("3k_dlc06_ancillary_accessory_tribute_chest_diplomacy_simple_cost", self.splendour_chest_cost)
	effect.set_context_value("3k_dlc06_ancillary_accessory_tribute_chest_diplomacy_extraordinary_cost", self.splendour_chest_cost)
end

function shi_xie_resource_manager:Initialise()

	-- Check if faction doesn't exist or pooled resource is broken.
	local shi_xie_faction = cm:query_faction(self.shi_xie_faction_name);
	if not shi_xie_faction or shi_xie_faction:is_null_interface() then
		script_error(self.system_id.."shi_xie_resource_manager:Initialise() Unable to find Shi Xie's faction, so exiting. Should this script be enabled?");
		return;
	end;

	local shi_xie_pooled_resource = shi_xie_faction:pooled_resources():resource(self.pooled_resource_key)
	if not shi_xie_pooled_resource or shi_xie_pooled_resource:is_null_interface() then
		script_error(self.system_id.."shi_xie_resource_manager:Initialise() Unable to find Shi Xie's pooled resource, Splendour, so exiting. Has is been added in startpos?");
		return;
	end;

	local shi_xie_pooled_resource2 = shi_xie_faction:pooled_resources():resource("3k_dlc06_pooled_resource_family_member_faction_leaders")
	if not shi_xie_pooled_resource2 or shi_xie_pooled_resource2:is_null_interface() then
		script_error(self.system_id.."shi_xie_resource_manager:Initialise() Unable to find Shi Xie's pooled resource, Family Members, so exiting. Has is been added in startpos?");
		return;
	end;


	self:update_UI_values()

	core:add_listener("shi_xie_effect_value_refresh_on_ui_load",
	"UICreated",
	function(context)
		return cm:query_faction(self.shi_xie_faction_name):is_human()
	end,
	function(context)
		self:update_UI_values()
	end,
	true
	)

	self:add_listeners()

	-- Enables more verbose debugging.
	-- Example: trigger_cli_debug_event shi_xie_resource_manager.enable_debug()
	core:add_cli_listener("shi_xie_resource_manager.enable_debug",
		function()
			self.debug_mode = true;
		end
	)

	self:generate_family_tree()

	self:update_family_member_vassals()

	self:print("Shi Xie Faction Resource Manager Initialised")
end

--once, at game start, does a sweep of the entire map for shi family.
--we could hardcode this or sweep just the faction, but then we open ourselves up for failure when we add in new startposes, etc.
function shi_xie_resource_manager:generate_family_tree()
	self:print("\n+++++++++++++++++++++++Generating Family Tree", true)

	for i = 0, cm:query_model():world():faction_list():num_items() - 1 do
		local character_list = cm:query_model():world():faction_list():item_at(i):character_list()

		for j = 0, character_list:num_items() -1 do
			local character = character_list:item_at(j)

			--checks to see if the character or their spouse is in our family tree
			if self:is_in_family_tree(character) then
				
				self:add_to_family_tree(character)
			end

		end
	end

	self:print("+++++++++++++++++++++++++++++++++++++++++++++++++++++++", true)
end

function shi_xie_resource_manager:add_to_family_tree(character_to_add)
	
	if not is_query_character(character_to_add) or character_to_add:is_null_interface() then
		script_error(self.system_id.."update_family_tree() INVALID CHARACTER INTERFACE PASSED!")
		return;
	end

	if self:is_in_family_list(character_to_add) then
		self:print("Tried adding "..character_to_add:generation_template_key().." to Shi Xie family tree, but they're already there! Ignoring instead")
		return
	end

	if character_to_add:ceo_management():is_null_interface() then
		self:print("ERROR: Shi Xie Resources: Character ["..character_to_add:cqi().."] with template ["..character_to_add:generation_template_key().."] does not support CEOs. Ignoring instead.")
		return;
	end;


	self:print("Adding "..character_to_add:generation_template_key().." to family tree", true)
	table.insert(self.family_tree, character_to_add:cqi())
	cm:modify_character(character_to_add):ceo_management():add_ceo(self.family_member_ceo_key);


end


function shi_xie_resource_manager:is_in_family_list(character)
	
	if not is_query_character(character) or character:is_null_interface() then
		script_error(self.system_id.."is_in_family_tree_list() INVALID CHARACTER INTERFACE PASSED!")
		return;
	end
	
	for i, family_member in ipairs(self.family_tree) do
		if family_member == character:cqi() then
			return true
		end
	end

	return false
end

function shi_xie_resource_manager:is_in_family_tree(character)

	if not is_query_character(character) or character:is_null_interface() then
		script_error(self.system_id.."is_in_family_tree() INVALID CHARACTER INTERFACE PASSED!")
		return;
	end
	
	if not character:character_type("general") then
		return false
	end

	local current_character_to_inspect = character

	--goes up a character's family tree, to try and find Shi Ci
	--inspects the current character's father, if it has one.
	while current_character_to_inspect:has_father() do
		local current_character_father = current_character_to_inspect:father():character()

		--if my father is shi ci, return is_in_family_tree() as true 
		if current_character_father:generation_template_key() == self.family_progenitor_key then
			return true
		end

		--checks for maternal grandfather
		if current_character_father:family_member():has_spouse() then
			local current_character_mother = current_character_father:family_member():spouse():character()
			if current_character_mother:has_father() and
			current_character_mother:father():character():generation_template_key() == self.family_progenitor_key then
				return true
			end
		end
		
		--next, inspect my father's father
		current_character_to_inspect = current_character_father

		--this will repeat (do while loop) until we reach a dad end (pun 100% intended)
	end

	--checks the character's spouse's family tree, to check for in-laws
	--uses the same process of do while
	if character:family_member():has_spouse() then
		current_character_to_inspect = character:family_member():spouse():character()

		while current_character_to_inspect:has_father() do
			current_character_father = current_character_to_inspect:father():character()
	
			--if my father is shi ci, return is_in_family_tree() as true 
			if current_character_father:generation_template_key() == self.family_progenitor_key then
				return true
			end
			
			--next, inspect my father's father
			current_character_to_inspect = current_character_father
			
			--this will repeat (do while loop) until we reach a dad end (pun 100% intended)
		end
	end

	return false
end

function shi_xie_resource_manager:update_family_member_vassals()

	local family_member_faction_leaders = 0

	--counts people in your family who are faction leaders
	for i, char_cqi in ipairs(self.family_tree) do
		local character = cm:query_character(char_cqi)

		--if a faction leader of any faction other than our own
		if character:is_faction_leader() and character:faction():name() ~= self.shi_xie_faction_name then
			family_member_faction_leaders = family_member_faction_leaders + 1
		end
	end
	
	local query_pooled_resource = cm:query_faction(self.shi_xie_faction_name):pooled_resources():resource("3k_dlc06_pooled_resource_family_member_faction_leaders")
	
	local current_pooled_resource_amount = query_pooled_resource:value()


	--current_pooled_resource_amount is the amount from the previous turn / before update.
	--family_member_faction_leaders is the "correct" amount (they might be the same)
	local amount_delta = family_member_faction_leaders - current_pooled_resource_amount

	--if there's been any change, apply said change to the resource
	if amount_delta ~= 0 then

		cm:modify_model():get_modify_pooled_resource(query_pooled_resource):apply_transaction_to_factor("3k_dlc06_pooled_factor_family_member_faction_leaders", amount_delta);
	end

end

function shi_xie_resource_manager:modify_splendour(resource_factor, value)

	local splendour_resource = cm:query_faction(self.shi_xie_faction_name):pooled_resources():resource(self.pooled_resource_key)
	local modify_splendour_resource = cm:modify_model():get_modify_pooled_resource(splendour_resource)

	modify_splendour_resource:apply_transaction_to_factor(resource_factor, value)
end

function shi_xie_resource_manager:spawn_chest(ceo_key)
	
	if ceo_key and not is_string(ceo_key) then
		script_error(self.system_id.."spawn_chest() DIDN'T PASS A STRING!")
		return;
	end

	--checks to make sure we passed a valid chest key
	if ceo_key == self.chest_diplomacy_extraordinary
	or ceo_key == self.chest_diplomacy_simple
	or ceo_key == self.chest_personal_extraordinary
	or ceo_key == self.chest_personal_simple
	or ceo_key == self.chest_regional_extraordinary
	or ceo_key == self.chest_regional_simple then
		
		local modify_faction_ceo_management = cm:modify_faction(self.shi_xie_faction_name):ceo_management()

		modify_faction_ceo_management:add_ceo(ceo_key)
		self:print("Spawned "..ceo_key.." chest!", true)
		self:modify_splendour(self.pooled_factor_chest_creation, -self.splendour_chest_cost)

		return
	end

	--only reaches this part if the CEO key was not a chest
	script_error(self.system_id.."spawn_chest() INVALID CHEST TYPE PASSED!")
end

function shi_xie_resource_manager:print(string, opt_debug_mode_only)
	if opt_debug_mode_only and self.debug_mode == false then
		return
	end

	out.design(self.system_id..tostring(string))
end
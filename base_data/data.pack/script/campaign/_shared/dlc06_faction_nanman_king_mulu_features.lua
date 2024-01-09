---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------
----- Name:			dlc06_faction_nanman_king_mulu_features.lua
----- Description: 	This script handles king mulu's faction pooled resource and the rituals mechanic.
---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------

-- Don't load in campaigns which don't require it.
if cm.name == "ep_eight_princes" then
	output("dlc06_faction_nanman_king_mulu.lua: Not loaded in this campaign." );
	return;
else
	output("dlc06_faction_nanman_king_mulu.lua: Loading");
end;

-- self initialiser
cm:add_first_tick_callback_new(function() king_mulu_features:new_game() end); -- Fires on the first tick of a New Campaign
cm:add_first_tick_callback(function() king_mulu_features:initialise() end); -- fires on the first tick of every game loaded.

-- Table holding the script and variables.
king_mulu_features = {
	mulu_faction_key = "3k_dlc06_faction_nanman_king_mulu";
	-- Pride Data
	pride_db_key = "3k_dlc06_pooled_resource_mulu_pride";
	pride_military_factor = "3k_dlc06_pooled_factor_mulu_pride_military_feats";
	-- Rituals Data
	ritual_ceo_category = "3k_dlc06_ceo_category_factional_king_mulu_rituals";
	ritual_panel_title = "3k_dlc06_nanman_king_mulu_rituals_panel_title";
	ritual_panel_body = "3k_dlc06_nanman_king_mulu_rituals_panel_body";
	ritual_turns_to_apply_for = 4;
	ritual_data = {
		["3k_dlc06_ceo_factional_nanman_king_mulu_rituals_elephant"] = {
			title_key = "3k_dlc06_nanman_king_mulu_rituals_title_elephant", 
			effect_bundle_key = "3k_main_payload_empty_faction",
			icon_path = "3k_dlc06_rituals_ritual_of_the_elephant.png",
			event_picture_path = "3k_dlc06_king_mulu_rites_ritual_elephant.png"
		},
		["3k_dlc06_ceo_factional_nanman_king_mulu_rituals_ox"] = {
			title_key = "3k_dlc06_nanman_king_mulu_rituals_title_ox", 
			effect_bundle_key = "3k_main_payload_empty_faction",
			icon_path = "3k_dlc06_rituals_ritual_of_the_ox.png",
			event_picture_path = "3k_dlc06_king_mulu_rites_ritual_ox.png"
		},
		["3k_dlc06_ceo_factional_nanman_king_mulu_rituals_fish"] = {
			title_key = "3k_dlc06_nanman_king_mulu_rituals_title_fish", 
			effect_bundle_key = "3k_main_payload_empty_faction",
			icon_path = "3k_dlc06_rituals_ritual_of_the_fish.png",
			event_picture_path = "3k_dlc06_king_mulu_rites_ritual_fish.png"
		},
		["3k_dlc06_ceo_factional_nanman_king_mulu_rituals_tiger"] = {
			title_key = "3k_dlc06_nanman_king_mulu_rituals_title_tiger", 
			effect_bundle_key = "3k_main_payload_empty_faction",
			icon_path = "3k_dlc06_rituals_ritual_of_the_tiger.png",
			event_picture_path = "3k_dlc06_king_mulu_rites_ritual_tiger.png"
		},
		["3k_dlc06_ceo_factional_nanman_king_mulu_rituals_eagle"] = {
			title_key = "3k_dlc06_nanman_king_mulu_rituals_title_eagle", 
			effect_bundle_key = "3k_main_payload_empty_faction",
			icon_path = "3k_dlc06_rituals_ritual_of_the_eagle.png",
			event_picture_path = "3k_dlc06_king_mulu_rites_ritual_eagle.png"
		},
		["3k_dlc06_ceo_factional_nanman_king_mulu_rituals_dragon"] = {
			title_key = "3k_dlc06_nanman_king_mulu_rituals_title_dragon", 
			effect_bundle_key = "3k_main_payload_empty_faction",
			icon_path = "3k_dlc06_rituals_ritual_of_the_dragon.png",
			event_picture_path = "3k_dlc06_king_mulu_rites_ritual_dragon.png"
		},
		["3k_dlc06_ceo_factional_nanman_king_mulu_rituals_goat"] = {
			title_key = "3k_dlc06_nanman_king_mulu_rituals_title_goat", 
			effect_bundle_key = "3k_main_payload_empty_faction",
			icon_path = "3k_dlc06_rituals_ritual_of_the_goat.png",
			event_picture_path = "3k_dlc06_king_mulu_rites_ritual_goat.png"
		},
		["3k_dlc06_ceo_factional_nanman_king_mulu_rituals_monkey"] = {
			title_key = "3k_dlc06_nanman_king_mulu_rituals_title_monkey", 
			effect_bundle_key = "3k_main_payload_empty_faction",
			icon_path = "3k_dlc06_rituals_ritual_of_the_monkey.png",
			event_picture_path = "3k_dlc06_king_mulu_rites_ritual_monkey.png"
		}
	};
	ai_ritual_regions = {
		["3k_dlc06_ceo_factional_nanman_king_mulu_rituals_elephant"]	= "3k_dlc06_jiaozhi_resource_3";
		["3k_dlc06_ceo_factional_nanman_king_mulu_rituals_ox"]			= "3k_dlc06_jiaozhi_resource_3";
		["3k_dlc06_ceo_factional_nanman_king_mulu_rituals_fish"]		= "3k_main_zangke_resource_2";
		["3k_dlc06_ceo_factional_nanman_king_mulu_rituals_tiger"]		= "3k_main_jiangyang_resource_1";
		["3k_dlc06_ceo_factional_nanman_king_mulu_rituals_eagle"]		= "3k_main_shangyong_resource_1";
		["3k_dlc06_ceo_factional_nanman_king_mulu_rituals_dragon"]		= "3k_main_yuzhang_capital";
		["3k_dlc06_ceo_factional_nanman_king_mulu_rituals_goat"]		= "3k_dlc06_wu_pass";
		["3k_dlc06_ceo_factional_nanman_king_mulu_rituals_monkey"]		= "3k_main_yanmen_resource_1";
	};
	ritual_regions_to_missions = {
		["3k_main_zangke_resource_2"] = "3k_dlc06_faction_king_mulu_third_ritual_mission";
		["3k_main_jiangyang_resource_1"] = "3k_dlc06_faction_king_mulu_fourth_ritual_mission";
		["3k_main_shangyong_resource_1"] = "3k_dlc06_faction_king_mulu_fifth_ritual_mission";
		["3k_main_yuzhang_capital"] = "3k_dlc06_faction_king_mulu_sixth_ritual_mission";
		["3k_dlc06_wu_pass"] = "3k_dlc06_faction_king_mulu_seventh_ritual_mission";
		["3k_main_yanmen_resource_1"] = "3k_dlc06_faction_king_mulu_eighth_ritual_mission";
	};
	ritual_first_turn = 3;
	ritual_turns_between = 4;
}

--- @function new_game
--- @desc Fires when the player starts a new campaign. Used to initialise things just once (usually saved values).
--- @r nil
function king_mulu_features:new_game()
	
	-- Add mulu's default CEOs. Eventually move this to db, but here for testing.
	local modify_faction_ceo_management = cm:modify_faction(self.mulu_faction_key):ceo_management()

	if not cm:query_faction(self.mulu_faction_key):is_human() then
		modify_faction_ceo_management:add_ceo("3k_dlc06_ceo_factional_nanman_king_mulu_rituals_elephant");
		modify_faction_ceo_management:add_ceo("3k_dlc06_ceo_factional_nanman_king_mulu_rituals_ox");
	end;
end;

--- @function initialise
--- @desc Fires every campaign (after new_game if it's a new campaign). Sets things up such as listeners and the like.
--- @r nil
function king_mulu_features:initialise()
	self:setup_pride_listeners();
	self:setup_rituals_listeners();
end;


-- #region Pride

--- @function setup_pride_listeners
--- @desc Sets up listeners for Pride mechanic 
--- @r nil
function king_mulu_features:setup_pride_listeners()

	-- Create a listener which sums the levels of the heroes in the enemy force and adds them to Mulu's Pride when he defeats them.
	core:add_listener(
        "king_mulu_features_pride_battle_listener", -- UID
        "CampaignBattleLoggedEvent", -- Campaign code event
		function(context) -- Conditions
			-- Only fire if Mulu's faction was involved in the battle as a winner.
			return context:log_entry():winning_factions():any_of(
				function(query_faction) return query_faction:name() == self.mulu_faction_key end);
		end,
		function(context) -- Actions
			
			-- Sum the ranks of ALL defeated characters.
			local total_enemy_rank = 0;
			context:log_entry():losing_characters():foreach(
				function(log_character)
					if not log_character:character():is_null_interface() then

						--some characters' numerical rank is 1 higher than what is displayed.
						--This is not the case with garrison leaders and other units that are also commanders
						--the following will correct the character's rank by -1 if he is a garrison leader or unit leader (a.k.a. a character generated just for the battle)
						local char_rank = log_character:character():rank()
						if not misc:is_transient_character(log_character:character()) then
							char_rank = char_rank - 1
						end


						total_enemy_rank = total_enemy_rank + char_rank;
					end;
				end);

			-- Add the total of all the ranks to the pooled resource.
			if total_enemy_rank > 0 then
				
				local pride_resource = cm:get_faction_pooled_resource(self.pride_db_key, self.mulu_faction_key);

				if not pride_resource or pride_resource:is_null_interface() then -- Make sure we got something back!
					script_error("ERROR: Unable to find mulu's pride resource! This should never happen, returning.");
					return false;
				end;

				cm:modify_model():get_modify_pooled_resource(pride_resource):apply_transaction_to_factor(
					self.pride_military_factor,
					total_enemy_rank
				);
				
				output(string.format("king_mulu_features:Mulu's pride increased by %i", total_enemy_rank))

			end;
        end,
        true -- Is persistent
	);
	
	-- Checks the number of rituals we have, so we can add Pride based on unlocked rituals. done at turn start rather than round, so
	-- the first two rituals (at round start) get counted the same turn they're unlocked
    core:add_listener(
        "mulu_pride_rituals_from_pride_listener", -- UID
        "FactionTurnStart", -- Event
        function(context)
            return context:faction():name() == self.mulu_faction_key;
        end, --Conditions for firing
		function(context)
			
			--gets current number of rituals in faction
			local mulu_rituals_unlocked = context:faction():ceo_management():all_ceos_for_category(self.ritual_ceo_category):num_items()
			
			--gets the pooled resource which will count how many rituals we have. starts at 0
			local rituals_resource = cm:get_faction_pooled_resource("3k_dlc06_pooled_resource_mulu_rituals", self.mulu_faction_key);

			local new_round_ritual_delta = mulu_rituals_unlocked - rituals_resource:value()

			--if there's been any change, apply said change to the resource
			if new_round_ritual_delta ~= 0 then

				cm:modify_model():get_modify_pooled_resource(rituals_resource):apply_transaction_to_factor("3k_dlc06_pooled_factor_mulu_rituals", new_round_ritual_delta);
			end
			
        end, -- Function to fire.
        true -- Is Persistent?
	);
end;

-- #endregion


-- #region Rituals

--- @function setup_rituals_listeners
--- @desc Listeners to manage the Ritual mechanic lifecycle.
--- @r nil
function king_mulu_features:setup_rituals_listeners()

	-- Add a listener to show the ui panel on certain turn numbers.
	core:add_listener(
		"mulu_rituals_event_listeners",
		"FactionTurnStart",
		function(context)
			-- Modulo used here to give a spacing of n turns between firings.
			return context:faction():name() == self.mulu_faction_key 
				and cm:turn_number() >= self.ritual_first_turn
				and (cm:turn_number() - self.ritual_first_turn) % self.ritual_turns_between == 0
		end,
		function(context)

			local selected_ritual_keys = self:generate_random_rituals_ceo_list();

			if not selected_ritual_keys or #selected_ritual_keys < 1 then
				script_error("Mulu rites: Unable to find any valid ceos! Are you calling the panel before giving CEOs?");
				return false;
			end;

			self:generate_ritual_effects_by_pride()
			if context:faction():is_human() then
				-- Humans get a panel which triggers the effect bundle.
				self:build_ui_data(selected_ritual_keys);
				
				--only opens the ritual panel if the victory screen ritual panel guard isnt up
				if not cm:saved_value_exists("dlc06_king_mulu_game_victory_turn_ritual_panel")
				or cm:get_saved_value("dlc06_king_mulu_game_victory_turn_ritual_panel") == false then
					self:open_rituals_panel();
				end
				
			else
				-- The AI doesn't receive dilemmas, so we'll just pick at random.
				local selected_index = cm:random_int(#selected_ritual_keys, 1);

				if not is_number(selected_index) then
					script_error("Mulu rites: Unable to find any valid selected_index" .. tostring(selected_index));
					return false;
				end;

				local selected_ritual_ceo_key = selected_ritual_keys[selected_index];

				if not self.ritual_data[selected_ritual_ceo_key] then
					script_error("Mulu rites: Unable to find any valid selected_ritual_ceo_key " .. tostring(selected_ritual_ceo_key));
					return false;
				end;

				if self.ritual_data[selected_ritual_ceo_key].effect_bundle_key == "3k_main_payload_empty_faction" then
					script_error("Mulu Rituals Error! Failed to update ritual effect bundles!!")
					return false;
				end

				cm:modify_faction(self.mulu_faction_key):apply_effect_bundle(
					self.ritual_data[selected_ritual_ceo_key].effect_bundle_key,
					self.ritual_turns_to_apply_for);
			end;

		end,
		true
	);

	-- The UI sends a message to the system. Which will then fire missions.
    core:add_listener(
        "mulu_rituals_event_listeners", -- UID
        "ModelScriptNotificationEvent", -- Event
        function(model_script_notification_event) --"invoke_council"
            if not string.find(model_script_notification_event:event_id(), "mulu_ritual_triggered_") then
                return false;
            end

            return true;
        end, --Conditions for firing
		function(model_script_notification_event)
			local ceo_key = string.gsub(model_script_notification_event:event_id(), "mulu_ritual_triggered_", "");

			if self.ritual_data[ceo_key].effect_bundle_key == "3k_main_payload_empty_faction" then
				script_error("Mulu Rituals Error! Failed to update ritual effect bundles!!")
			end

			cm:modify_faction(self.mulu_faction_key):apply_effect_bundle(
				self.ritual_data[ceo_key].effect_bundle_key,
				self.ritual_turns_to_apply_for);
			-- UI Msg so icons can be added to the HUD etc
			effect.call_context_command("UiMsg('MuluRitesApplied')");
        end, -- Function to fire.
        true -- Is Persistent?
	);
	

	-- Listener to grant AI mulu rituals when conquering appropriate regions.
	core:add_listener(
		"mulu_rituals_event_listeners",
		"FactionTurnStart",
		function(context)
			return context:faction():name() == self.mulu_faction_key;
		end,
		function(context)

			for ceo_key, region_key in ipairs(self.ai_ritual_regions) do
				if not context:faction():ceo_management():has_ceo_equipped(ceo_key)
				and context:faction():region_list():any_of(function(region) return region:name() == region_key end) then

					cm:modify_faction(self.mulu_faction_key):ceo_management():add_ceo(ceo_key);
				end
			end;
		end,
		true
	);

	--unlocks rituals and complete mission if player doesn't conquer region, but otherwise gains control of it (vassalisation, etc.)
	core:add_listener(
		"mulu_rituals_region_conquest",
		"CharacterWillPerformSettlementSiegeAction",
		function(context)
			return context:query_character():faction():name() == self.mulu_faction_key and
			not (string.match(context:action_option_record_key(), "sack_and_withdraw") or string.match(context:action_option_record_key(), "raze"))
		end,
		function(context)
			local conquered_region = context:garrison_residence():region():name()
			local event_generator = cm:query_model():event_generator_interface()
			local mulu_faction = cm:query_faction(self.mulu_faction_key)
			
			for region, mission in pairs(self.ritual_regions_to_missions) do
				--if we just conquered a region tied to a Ritual, and the Ritual mission is active...
				if conquered_region == region and event_generator:any_of_missions_active(mulu_faction, mission) then
					--auto complete the mission (the rewards will be given by it)
					cm:modify_faction(mulu_faction):complete_custom_mission(mission)
				end
			end
		end,
		true
	);


-- HACK: Listener to catch missions which have triggered, but the faction already owns the region. Shoud be fixed in code or use alternate mission type.
core:add_listener(
	"mulu_rituals_region_conquest",
	"MissionIssued",
	function(context)
		local triggered_mission = context:mission():mission_record_key();
		for k, mission_key in pairs(self.ritual_regions_to_missions) do
			if triggered_mission == mission_key then
				return true;
			end;
		end

		return false;
	end,
	function(context)
		local triggered_mission_key = context:mission():mission_record_key();
		local q_faction_regions = context:faction():region_list();
		local target_region_key = nil;

		for region_key, mission_key in pairs(self.ritual_regions_to_missions) do
			if triggered_mission_key == mission_key then
				target_region_key = region_key;
			end;
		end

		if target_region_key and q_faction_regions:any_of(function(region) return region:name() == target_region_key end) then
			cm:modify_faction(context:faction():name()):complete_custom_mission(triggered_mission_key)
		end;
	end,
	true
)

	-----------------VICTORY SCREEN RITUAL PANEL GUARDS -------------------------

	-- if mulu is about to win the game, and the victory screen is gonna appear,
	-- set this saved value which acts as a guard to stop the rituals screen from popping up
	core:add_listener(
		"mulu_game_victory_protections5235a41252", -- UID
		"PlayerCampaignFinished", -- Event
		function(context) --"invoke_council"
			--returns true if mulu completes the game victory condition
			return context:faction():name() == "3k_dlc06_faction_nanman_king_mulu"
		end, --Conditions for firing
		
		function(context)
			cm:set_saved_value("dlc06_king_mulu_game_victory_turn_ritual_panel", true);
		end, -- Function to fire.
		true -- Is Persistent?
	);


	--if the player presses the "continue campaign" button after the victory screen
	--allows for the rituals panel to be displayed again.
	-- also triggers ritual panel since it wont have appeared at turn start
	core:add_listener(
		"mulu_rituals_post_victory_screen_panel_open", -- UID
		"ModelScriptNotificationEvent", -- Event
		function(context) --"script notification events"
			--returns true if this is mulus faction, pressing the button to "continue campaign" after campaign victory,
			--on the same turn as the rituals panel would otherwise trigger
			return context:faction():query_faction():name() == self.mulu_faction_key
			and context:event_id() == "campaign_victory_defeat_panel_continue_button_pressed"
		end, --Conditions for firing
		function(context)


			if cm:turn_number() >= self.ritual_first_turn
			and (cm:turn_number() - self.ritual_first_turn) % self.ritual_turns_between == 0
			and cm:saved_value_exists("dlc06_king_mulu_game_victory_turn_ritual_panel")
			and cm:get_saved_value("dlc06_king_mulu_game_victory_turn_ritual_panel") == true then
				local selected_ritual_keys = self:generate_random_rituals_ceo_list();

			if not selected_ritual_keys or #selected_ritual_keys < 1 then
				script_error("Mulu rites: Unable to find any valid ceos! Are you calling the panel before giving CEOs?");
				return false;
			end;

			self:generate_ritual_effects_by_pride()
				-- Humans get a panel which triggers the effect bundle.
				self:build_ui_data(selected_ritual_keys);
				self:open_rituals_panel();
			end

			cm:set_saved_value("dlc06_king_mulu_game_victory_turn_ritual_panel", false);
			
		end, -- Function to fire.
		true -- Is Persistent?
	);

	--at turn end, if mulu's victory screen ritual panel guard is up, disables said guard to enable rituals
	--this one exists as a net to catch exceptions and edge cases
	core:add_listener(
		"mulu_rituals_post_victory_screen_panel_open", -- UID
		"FactionTurnEnd", -- Event
		function(context) --"script notification events"
			return context:faction():name() == "3k_dlc06_faction_nanman_mulu"
			and cm:saved_value_exists("dlc06_king_mulu_game_victory_turn_ritual_panel")
			and cm:get_saved_value("dlc06_king_mulu_game_victory_turn_ritual_panel") == true
		end, --Conditions for firing
		function(context)

			cm:set_saved_value("dlc06_king_mulu_game_victory_turn_ritual_panel", false);

		end, -- Function to fire.
		true -- Is Persistent?
	);
end;

--- @function generate_random_rituals_ceo_list
--- @desc Picks up to 4 random CEOs which Mulu has available and returns the list
--- @r table{ceo_key, ceo_key}
function king_mulu_features:generate_random_rituals_ceo_list()
	-- Go through all the owned ceos and add choices for them.
	local owned_ritual_ceos = cm:query_faction(self.mulu_faction_key):ceo_management():all_ceos_for_category(self.ritual_ceo_category);

	if owned_ritual_ceos:num_items() < 1 then
		return;
	end;

	-- Build a running list of ceos we can choose.
	local available_rituals = {};
	owned_ritual_ceos:foreach(function(ceo) table.insert(available_rituals, ceo:ceo_data_key()) end);

	local selected_rituals = {};

	local num_rituals_to_select = math.min(owned_ritual_ceos:num_items(), 4);
	for i = 1, num_rituals_to_select do
		local selected_id = cm:random_number(#available_rituals, 1);
		selected_id = math.round(selected_id, 0);

		table.insert(selected_rituals, available_rituals[selected_id]);
		table.remove(available_rituals, selected_id); -- Remove from the list so we don't pick it twice.
	end;

	return selected_rituals;
end;

function king_mulu_features:generate_ritual_effects_by_pride()

	local mulu_faction = cm:query_faction(self.mulu_faction_key)

	--gets the current effect bundle active for the pooled resource. this is useful as a way to gauge what resource "level" we're at
	local current_pride_level = mulu_faction:pooled_resources():resource(self.pride_db_key):active_effect(1)
	
	if string.match(current_pride_level, "3k_dlc06_effect_bundle_pooled_resource_mulu_pride_level") then
		
		--this will format as "_n" where n is between 1 and 4
		current_pride_level = string.gsub(current_pride_level, "3k_dlc06_effect_bundle_pooled_resource_mulu_pride_level", "")
	else
		script_error("Mulu Ritual Effects by Pride Error! Unexpected resource effect bundle key!")
		return false
	end

	local owned_ritual_ceos = cm:query_faction(self.mulu_faction_key):ceo_management():all_ceos_for_category(self.ritual_ceo_category);

	for i = 0, owned_ritual_ceos:num_items()-1 do
		local ceo_key = owned_ritual_ceos:item_at(i):ceo_data_key()
		--removes the first bit of the key, which references the CEO part
		local processed_key = string.gsub(ceo_key, "3k_dlc06_ceo_", "")
		
		--this will format as "3k_dlc06_effect_bundle_factional_nanman_king_mulu_rituals_animal_n"
		--where animal = goat, monkey etc. and n is a number between 1 and 4
		processed_key = "3k_dlc06_effect_bundle_"..processed_key..current_pride_level

		self.ritual_data[ceo_key].effect_bundle_key = processed_key
	end
end

--- @function build_ui_data
--- @desc Convers the data into ui friendly context_vales.
--- @p A ceo_rituals_list {ceo_key, ceo_key}
--- @r nil
function king_mulu_features:build_ui_data(rituals_list)

	effect.set_context_value("dlc06_king_mulu_rituals_title", self.ritual_panel_title);
	effect.set_context_value("dlc06_king_mulu_rituals_body", self.ritual_panel_body);

	-- Ritual options
	local ui_values = {};
	for i, key in ipairs(rituals_list) do

		if self.ritual_data[key].effect_bundle_key == "3k_main_payload_empty_faction" then
			script_error("Mulu Rituals Error! Failed to update ritual effect bundles!!")
			break
		end

		ui_values[key] = self.ritual_data[key];
	end;

	effect.set_context_value("dlc06_king_mulu_rituals_info", ui_values);
	
end;


--- @function open_rituals_panel
--- @desc Opens the rituals panel
--- @r nil
function king_mulu_features:open_rituals_panel()
	--particularly useful in multiplayer, this ensures the panel only opens for king mulu himself.
	if cm:get_local_faction(true) == self.mulu_faction_key then
		effect.call_context_command("OpenPanel(\"ui/campaign ui/3k_dlc06_king_mulu_rites_panel\")");
	end
end;

-- #endregion
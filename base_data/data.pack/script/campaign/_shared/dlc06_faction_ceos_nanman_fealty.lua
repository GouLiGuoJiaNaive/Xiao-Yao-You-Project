---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------
----- Name:			dlc06_faction_ceos_nanman_fealty.lua
----- Description: 	Manages the faction fealty CEOs
--[[ Intention
	Core functionality:
		INIT:
			On a New Game:
				Add any fealties which aren't in the startpos data. add_starting_fealty_ceo()
				Save out all the fealties owned by the Nanman factions into a lua table. This saves us doing individual setup for each startpos. set_sv_initial_fealties_cache()
			On loading a game:
				Perform a load_game_fixup():
					Cache the fealties, if they weren't already (using the nanman_fealty.initial_fealties_fallback_XXX tables)
					For dead factions, delete all their fealties which don't exist in initial fealties. get_sv_initial_fealties_cache()
					If no one owns one of the fealties, add it to a faction.
					If all owners of a fealty are dead, pick one and mark the fealty as 'lost'. mark_fealty_as_lost_in_region()
					Perform a 'sync' by sharing all nanman factions fealties with their vassls and allies.
				Setup listeners and debug listeners.
		SHARING FEALTIES:
			When a Nanman faction is killed (by a Nanman):
				Give all fealties of the dead faction to the killer
			When an alliance/coalition is signed, or a faction becomes a vassal (Nanman - Nanman):
				Each faction shares their fealties between one another.
		'LOSING' FEALTIES:
			When a Nanman faction is killed (by a non nanman):
				Save lua data for the fealties which were lost. mark_fealty_as_lost_in_region()
				Spawn a mission and pin for human factions to go and reclaim them.
		'RECAPTURING' FEALTIES:
			When a Nanman faction conquers a region with lost fealties:
				Spawn all the 'lost' fealties for the faction. recover_lost_fealties()
				Clear the mission and pins.
		CLEANING UP FEALTIES:
			When a Nanman faction dies:
				Delete all their fealties which don't exist in their initial data. clear_all_gathered_fealty_ceos_from_faction()
		MISC:
			FactionAwakensFromDeath listener grants the factions initial fealties if they turn up.
]]--
---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------


-- Don't load in campaigns which don't require it.
if cm.name == "ep_eight_princes" then
	output("dlc06_faction_ceos_nanman_fealty.lua: Not loaded in this campaign." );
	return;
end;

output("dlc06_faction_ceos_nanman_fealty.lua: Loading");

-- self initialiser
cm:add_first_tick_callback_new(function() nanman_fealty:new_game() end);
cm:add_first_tick_callback(function() nanman_fealty:initialise() end); --Self register function

--#region Variables

nanman_fealty = {
	debug_mode = false;
	do_load_game_fixup = true;
	fealty_category_key = "3k_dlc06_ceo_category_factional_nanman_fealty";
	nanman_subculture_key = "3k_dlc06_subculture_nanman";
	fealty_map_pin_key = "3k_dlc06_pin_nanman_fealty";
	fealty_data = {
		["3k_dlc06_ceo_factional_nanman_fealty_major_king_duosi"] = {
			gained_event_key = "3k_dlc06_nanman_fealty_tribe_united_king_duosi_incident"
		},
		["3k_dlc06_ceo_factional_nanman_fealty_major_king_meng_huo"] = {
			gained_event_key = "3k_dlc06_nanman_fealty_tribe_united_king_meng_huo_incident"
		},
		["3k_dlc06_ceo_factional_nanman_fealty_major_king_mulu"] = {
			gained_event_key = "3k_dlc06_nanman_fealty_tribe_united_king_mulu_incident"
		},
		["3k_dlc06_ceo_factional_nanman_fealty_major_king_shamoke"] = {
			gained_event_key = "3k_dlc06_nanman_fealty_tribe_united_king_shamoke_incident"
		},
		["3k_dlc06_ceo_factional_nanman_fealty_major_king_wutugu"] = {
			gained_event_key = "3k_dlc06_nanman_fealty_tribe_united_king_wutugu_incident"
		},
		["3k_dlc06_ceo_factional_nanman_fealty_major_lady_zhurong"] = {
			gained_event_key = "3k_dlc06_nanman_fealty_tribe_united_lady_zhurong_incident"
		},
		["3k_dlc06_ceo_factional_nanman_fealty_major_yang_feng"] = {
			gained_event_key = "3k_dlc06_nanman_fealty_tribe_united_yang_feng_incident"
		},
		["3k_dlc06_ceo_factional_nanman_fealty_minor_ahuinan"] = {
			gained_event_key = "3k_dlc06_nanman_fealty_tribe_united_ahuinan_incident"
		},
		["3k_dlc06_ceo_factional_nanman_fealty_minor_dongtuna"] = {
			gained_event_key = "3k_dlc06_nanman_fealty_tribe_united_dongtuna_incident"
		},
		["3k_dlc06_ceo_factional_nanman_fealty_minor_jiangyang"] = {
			gained_event_key = "3k_dlc06_nanman_fealty_tribe_united_jiangyang_incident"
		},
		["3k_dlc06_ceo_factional_nanman_fealty_minor_jianning"] = {
			gained_event_key = "3k_dlc06_nanman_fealty_tribe_united_jianning_incident"
		},
		["3k_dlc06_ceo_factional_nanman_fealty_minor_jiaozhi"] = {
			gained_event_key = "3k_dlc06_nanman_fealty_tribe_united_jiaozhi_incident"
		},
		["3k_dlc06_ceo_factional_nanman_fealty_minor_jinhuansanjie"] = {
			gained_event_key = "3k_dlc06_nanman_fealty_tribe_united_jinhuansanjie_incident"
		},
		["3k_dlc06_ceo_factional_nanman_fealty_minor_mangyachang"] = {
			gained_event_key = "3k_dlc06_nanman_fealty_tribe_united_mangyachang_incident"
		},
		["3k_dlc06_ceo_factional_nanman_fealty_minor_tu_an"] = {
			gained_event_key = "3k_dlc06_nanman_fealty_tribe_united_tu_an_incident"
		},
		["3k_dlc06_ceo_factional_nanman_fealty_minor_xi_ni"] = {
			gained_event_key = "3k_dlc06_nanman_fealty_tribe_united_xi_ni_incident"
		},
		["3k_dlc06_ceo_factional_nanman_fealty_minor_yongchang"] = {
			gained_event_key = "3k_dlc06_nanman_fealty_tribe_united_yongchang_incident"
		},
		["3k_dlc06_ceo_factional_nanman_fealty_minor_yunnan"] = {
			gained_event_key = "3k_dlc06_nanman_fealty_tribe_united_yunnan_incident"
		},
		["3k_dlc06_ceo_factional_nanman_fealty_minor_zangke"] = {
			gained_event_key = "3k_dlc06_nanman_fealty_tribe_united_zangke_incident"
		},
	};

	saved_lost_fealty_datas = {};
	event_keys_all_fealty_gained = "3k_dlc06_nanman_fealty_all_tribes_united_incident";
	event_keys_all_fealty_gained_other_nanman = "3k_dlc06_nanman_fealty_all_tribes_united_other_nanman_incident";
	event_keys_all_fealty_gained_other_non_nanman = "3k_dlc06_nanman_fealty_all_tribes_united_other_non_nanman_incident";
	event_keys_fealty_dropped_mission = "3k_dlc06_nanman_fealty_reclaim_fealty_mission";
	delay_first_panel_open = false; -- Delay the panel opening if we gave the player CEOs in new_game().
	fealty_ceos_pending_stack = 0; -- SP only. Used to control when there are no pending ceos to be added. ++ when a ceo is added by script, -- when the FactionCeoAdded event fires. Not saved.
	allow_gained_events = true;
};

-- Fealties fallback data. Used in the case of old saves (before the cache was setup). Prevents us soft-locking QA playthroughs. #TODO - Delete in DLC07 onwards.
nanman_fealty.initial_fealties_fallback_190 = {
	["3k_dlc06_faction_nanman_ahuinan"] = {"3k_dlc06_ceo_factional_nanman_fealty_minor_ahuinan"};
	["3k_dlc06_faction_nanman_dongtuna"] = {"3k_dlc06_ceo_factional_nanman_fealty_minor_dongtuna"};
	["3k_dlc06_faction_nanman_jiangyang"] = {"3k_dlc06_ceo_factional_nanman_fealty_minor_jiangyang"};
	["3k_dlc06_faction_nanman_jianning"] = {"3k_dlc06_ceo_factional_nanman_fealty_minor_jianning"};
	["3k_dlc06_faction_nanman_jiaozhi"] = {"3k_dlc06_ceo_factional_nanman_fealty_minor_jiaozhi"};
	["3k_dlc06_faction_nanman_jinhuansanjie"] = {"3k_dlc06_ceo_factional_nanman_fealty_minor_jinhuansanjie"};
	["3k_dlc06_faction_nanman_king_duosi"] = {"3k_dlc06_ceo_factional_nanman_fealty_major_king_duosi"};
	["3k_dlc06_faction_nanman_king_meng_huo"] = {"3k_dlc06_ceo_factional_nanman_fealty_major_king_meng_huo"};
	["3k_dlc06_faction_nanman_king_mulu"] = {"3k_dlc06_ceo_factional_nanman_fealty_major_king_mulu"};
	["3k_dlc06_faction_nanman_king_shamoke"] = {"3k_dlc06_ceo_factional_nanman_fealty_major_king_shamoke"};
	["3k_dlc06_faction_nanman_king_wutugu"] = {"3k_dlc06_ceo_factional_nanman_fealty_major_king_wutugu"};
	["3k_dlc06_faction_nanman_lady_zhurong"] = {"3k_dlc06_ceo_factional_nanman_fealty_major_lady_zhurong"};
	["3k_dlc06_faction_nanman_mangyachang"] = {"3k_dlc06_ceo_factional_nanman_fealty_minor_mangyachang"};
	["3k_dlc06_faction_nanman_tu_an"] = {"3k_dlc06_ceo_factional_nanman_fealty_minor_tu_an"};
	["3k_dlc06_faction_nanman_xi_ni"] = {"3k_dlc06_ceo_factional_nanman_fealty_minor_xi_ni"};
	["3k_dlc06_faction_nanman_yang_feng"] = {"3k_dlc06_ceo_factional_nanman_fealty_major_yang_feng"};
	["3k_dlc06_faction_nanman_yongchang"] = {"3k_dlc06_ceo_factional_nanman_fealty_minor_yongchang"};
	["3k_dlc06_faction_nanman_yunnan"] = {"3k_dlc06_ceo_factional_nanman_fealty_minor_yunnan"};
	["3k_dlc06_faction_nanman_zangke"] = {"3k_dlc06_ceo_factional_nanman_fealty_minor_zangke"};
};

nanman_fealty.initial_fealties_fallback_194 = {
	["3k_dlc06_faction_nanman_ahuinan"] = {"3k_dlc06_ceo_factional_nanman_fealty_minor_ahuinan"};
	["3k_dlc06_faction_nanman_dongtuna"] = {"3k_dlc06_ceo_factional_nanman_fealty_minor_dongtuna"};
	["3k_dlc06_faction_nanman_jiangyang"] = {"3k_dlc06_ceo_factional_nanman_fealty_minor_jiangyang"};
	["3k_dlc06_faction_nanman_jinhuansanjie"] = {"3k_dlc06_ceo_factional_nanman_fealty_minor_jinhuansanjie"};
	["3k_dlc06_faction_nanman_king_duosi"] = {"3k_dlc06_ceo_factional_nanman_fealty_major_king_duosi"};
	["3k_dlc06_faction_nanman_king_meng_huo"] = {"3k_dlc06_ceo_factional_nanman_fealty_major_king_meng_huo", "3k_dlc06_ceo_factional_nanman_fealty_minor_jianning"};
	["3k_dlc06_faction_nanman_king_mulu"] = {"3k_dlc06_ceo_factional_nanman_fealty_major_king_mulu", "3k_dlc06_ceo_factional_nanman_fealty_minor_jiaozhi"};
	["3k_dlc06_faction_nanman_king_shamoke"] = {"3k_dlc06_ceo_factional_nanman_fealty_major_king_shamoke", "3k_dlc06_ceo_factional_nanman_fealty_minor_zangke"};
	["3k_dlc06_faction_nanman_king_wutugu"] = {"3k_dlc06_ceo_factional_nanman_fealty_major_king_wutugu", "3k_dlc06_ceo_factional_nanman_fealty_minor_tu_an"};
	["3k_dlc06_faction_nanman_lady_zhurong"] = {"3k_dlc06_ceo_factional_nanman_fealty_major_lady_zhurong", "3k_dlc06_ceo_factional_nanman_fealty_minor_yunnan"};
	["3k_dlc06_faction_nanman_mangyachang"] = {"3k_dlc06_ceo_factional_nanman_fealty_minor_mangyachang"};
	["3k_dlc06_faction_nanman_xi_ni"] = {"3k_dlc06_ceo_factional_nanman_fealty_minor_xi_ni"};
	["3k_dlc06_faction_nanman_yang_feng"] = {"3k_dlc06_ceo_factional_nanman_fealty_major_yang_feng", "3k_dlc06_ceo_factional_nanman_fealty_minor_yongchang"};
};
--#endregion



--#region Core Methods

--- @function new_game
--- @desc New game setup for fealty. Making sure we all have the correct CEOs.
--- @r nil
function nanman_fealty:new_game()

	-- In 194, make sure the factions own the CEOs they should.
	if cm.name == "dlc05_new_year" then
		self:add_starting_fealty_ceo(cm:query_faction("3k_dlc06_faction_nanman_king_meng_huo"), "3k_dlc06_ceo_factional_nanman_fealty_minor_jianning");
		self:add_starting_fealty_ceo(cm:query_faction("3k_dlc06_faction_nanman_king_mulu"), "3k_dlc06_ceo_factional_nanman_fealty_minor_jiaozhi");
		self:add_starting_fealty_ceo(cm:query_faction("3k_dlc06_faction_nanman_king_shamoke"), "3k_dlc06_ceo_factional_nanman_fealty_minor_zangke"); -- Gained from Duosi being vassal.
		self:add_starting_fealty_ceo(cm:query_faction("3k_dlc06_faction_nanman_yang_feng"), "3k_dlc06_ceo_factional_nanman_fealty_minor_yongchang");
		self:add_starting_fealty_ceo(cm:query_faction("3k_dlc06_faction_nanman_lady_zhurong"), "3k_dlc06_ceo_factional_nanman_fealty_minor_yunnan");
		self:add_starting_fealty_ceo(cm:query_faction("3k_dlc06_faction_nanman_king_wutugu"), "3k_dlc06_ceo_factional_nanman_fealty_minor_tu_an");
	elseif cm.name == "dlc07_guandu" then
		local meng_huo_faction = cm:query_faction("3k_dlc06_faction_nanman_king_meng_huo");
		local shamoke_faction = cm:query_faction("3k_dlc06_faction_nanman_king_shamoke");
		local mulu_faction = cm:query_faction("3k_dlc06_faction_nanman_king_mulu");

		self.allow_gained_events = false; -- Supress the incidents as they cause spam.
		
		local m_model = cm:modify_model():get_modify_episodic_scripting();
		m_model:disable_event_feed_events(true, "", "3k_event_subcategory_faction_developments", ""); -- Temporarily suppress the event feed whilst modifying the initial fealties
		
		self:add_starting_fealty_ceo(mulu_faction, "3k_dlc06_ceo_factional_nanman_fealty_major_king_duosi");
		self:add_starting_fealty_ceo(meng_huo_faction, "3k_dlc06_ceo_factional_nanman_fealty_major_king_meng_huo");
		self:add_starting_fealty_ceo(mulu_faction, "3k_dlc06_ceo_factional_nanman_fealty_major_king_mulu");
		self:add_starting_fealty_ceo(shamoke_faction, "3k_dlc06_ceo_factional_nanman_fealty_major_king_shamoke");
		self:add_starting_fealty_ceo(meng_huo_faction, "3k_dlc06_ceo_factional_nanman_fealty_major_king_wutugu");
		self:add_starting_fealty_ceo(meng_huo_faction, "3k_dlc06_ceo_factional_nanman_fealty_major_lady_zhurong");
		self:add_starting_fealty_ceo(meng_huo_faction, "3k_dlc06_ceo_factional_nanman_fealty_major_yang_feng");
		self:add_starting_fealty_ceo(meng_huo_faction, "3k_dlc06_ceo_factional_nanman_fealty_minor_ahuinan");
		self:add_starting_fealty_ceo(mulu_faction, "3k_dlc06_ceo_factional_nanman_fealty_minor_dongtuna");
		self:add_starting_fealty_ceo(meng_huo_faction, "3k_dlc06_ceo_factional_nanman_fealty_minor_jiangyang");
		self:add_starting_fealty_ceo(mulu_faction, "3k_dlc06_ceo_factional_nanman_fealty_minor_jianning");
		self:add_starting_fealty_ceo(mulu_faction, "3k_dlc06_ceo_factional_nanman_fealty_minor_jiaozhi");
		self:add_starting_fealty_ceo(shamoke_faction, "3k_dlc06_ceo_factional_nanman_fealty_minor_jinhuansanjie");
		self:add_starting_fealty_ceo(meng_huo_faction, "3k_dlc06_ceo_factional_nanman_fealty_minor_mangyachang");
		self:add_starting_fealty_ceo(shamoke_faction, "3k_dlc06_ceo_factional_nanman_fealty_minor_tu_an");
		self:add_starting_fealty_ceo(shamoke_faction, "3k_dlc06_ceo_factional_nanman_fealty_minor_xi_ni");
		self:add_starting_fealty_ceo(meng_huo_faction, "3k_dlc06_ceo_factional_nanman_fealty_minor_yongchang");
		self:add_starting_fealty_ceo(meng_huo_faction, "3k_dlc06_ceo_factional_nanman_fealty_minor_yunnan");
		self:add_starting_fealty_ceo(shamoke_faction, "3k_dlc06_ceo_factional_nanman_fealty_minor_zangke");

		self.allow_gained_events = true; -- Reset gained events for future ceos.
		
		m_model:disable_event_feed_events(false, "", "3k_event_subcategory_faction_developments", ""); --And reenable the event feed for faction developments
		
	end

	self:set_sv_initial_fealties_cache(); -- Cache the initial fealties, so that when a faction dies, we know which we need to remove. Always do this after adding the starting_fealties, or they won't be counted.
	
	if cm.name == "dlc04_mandate" then
		-- Nanman tribes aren't spawned in startpos in 182. The emergent_factions script flips this flag.
		cm:set_saved_value("nanman_fealty_tribes_have_yet_to_spawn", true);
	else
		cm:set_saved_value("nanman_fealty_tribes_have_yet_to_spawn", false);
	end;

	self.do_load_game_fixup = false; -- prevent load game fixup on first load as it's not neccessary.
end;


--- @function initialise
--- @desc Initialise function for debug commands and listener setup.
--- @r nil
function nanman_fealty:initialise()
	
	output("dlc06_faction_ceos_nanman_fealty.lua: Initialise()" );
	
	self:setup_listeners();
	self:setup_debug_listeners();

	if self.do_load_game_fixup then
		self:load_game_fixup();
	end;
end;


--- @function setup_debug_listeners
--- @desc Setup the debug listeners for the CEOs.
--- @r nil
function nanman_fealty:setup_debug_listeners()
	-- Enables more verbose debugging.
	-- Example: trigger_cli_debug_event nanman_fealty.enable_debug()
	core:add_cli_listener("nanman_fealty.enable_debug",
		function()
			self.debug_mode = true;
		end
	);

	-- Skips the whole gameplay around uniting the tribes and just force united them. Won't match gameplay!
	-- Example: trigger_cli_debug_event nanman_fealty.unite_the_tribes(3k_dlc06_faction_nanman_king_meng_huo)
	core:add_cli_listener("nanman_fealty.unite_the_tribes",
		function(faction_key)
			local query_faction = cm:query_faction(faction_key);

			if not query_faction or query_faction:is_null_interface() then
				script_error("Uniting the Tribes: Passed in faction key is not an existing faction. [" .. tostring(faction_key) .. "]");
				return false;
			end;

			for key, data in pairs(self.fealty_data) do
				self:add_fealty_ceo_to_faction_master_and_vassals(query_faction, key);
			end;
		end
	);

	-- Makes the faction drop their fealties in the specified region.
	-- Example: trigger_cli_debug_event nanman_fealty.lose_faction_fealties(3k_dlc06_faction_nanman_king_meng_huo,3k_main_jianning_capital)
	core:add_cli_listener("nanman_fealty.lose_faction_fealties",
		function(faction_key, region_lost_in)
			local query_faction = cm:query_faction(faction_key);
			local query_region = cm:query_region(region_lost_in);

			if not query_faction or query_faction:is_null_interface() then
				script_error("Uniting the Tribes: Passed in faction key is not an existing faction. [" .. tostring(faction_key) .. "]");
				return false;
			end;

			if not query_region or query_region:is_null_interface() then
				script_error("Uniting the Tribes: Passed in region_lost_in is not a valid region. [" .. tostring(region_lost_in) .. "]");
				return false;
			end;

			-- Force override their capital region.
			self:set_sv_stored_faction_capital(query_faction:name(), region_lost_in);

			self:mark_all_faction_fealties_as_lost(query_faction);
		end
	);

	-- Makes the faction gain all fealties dropped in the specified region.
	-- Example: trigger_cli_debug_event nanman_fealty.recover_lost_fealties(3k_dlc06_faction_nanman_king_meng_huo,3k_main_jianning_capital)
	core:add_cli_listener("nanman_fealty.recover_lost_fealties",
		function(faction_key, region_lost_in)
			local query_faction = cm:query_faction(faction_key);
			local query_region = cm:query_region(region_lost_in);

			if not query_faction or query_faction:is_null_interface() then
				script_error("Uniting the Tribes: Passed in faction key is not an existing faction. [" .. tostring(faction_key) .. "]");
				return false;
			end;
			
			if not query_region or query_region:is_null_interface() then
				script_error("Uniting the Tribes: Passed in region_lost_in is not an existing region. [" .. tostring(region_lost_in) .. "]");
				return false;
			end;

			self:recover_lost_fealties(query_faction, region_lost_in);
		end
	);
end;


--- @function setup_listeners
--- @desc Setup the listeners for the CEOs.
--- @r nil
function nanman_fealty:setup_listeners()
	-- Round checks. Store the factions last capital (if they had one).
	core:add_listener(
		"nanman_fealty_round_checks", -- UID
		"WorldStartOfRoundEvent", -- campaign event
		true,
		function(context)
			cm:get_all_factions_of_subculture(self.nanman_subculture_key, true):foreach(function(query_faction)
				local stored_region_key = nil;

				if query_faction:has_capital_region() then
					stored_region_key = query_faction:capital_region():name();
				end;
	
				if stored_region_key and self:get_sv_stored_faction_capital(query_faction:name()) ~= stored_region_key then
					self:set_sv_stored_faction_capital(query_faction:name(), stored_region_key);
				end;
			end);
		end,
		true
	);

	-- pre 190, listen for the nanman spawning.
	if cm:get_saved_value("nanman_fealty_tribes_have_yet_to_spawn") then
		core:add_listener(
			"nanman_fealty_emergence_listener",
			"NanmanTribesSpawned",
			true,
			function(context)
				cm:set_saved_value("nanman_fealty_tribes_have_yet_to_spawn", false);
			end,
			false
		)
	end;

	-- This event fires whenever a fealty ceo is gained.
	core:add_listener(
		"nanman_fealty_ceo_gained", -- UID
		"FactionCeoAdded",
		function(context)
			return context:ceo():category_key() == self.fealty_category_key;
		end,
		function(context)
			local query_faction = context:faction();
			core:trigger_event("FealtyCEOGained", context);

			self:test_if_faction_has_gained_all_fealties(query_faction);

			-- FTUE - Panel open listeners.
			if not cm:is_multiplayer()
			and query_faction:is_human() 
			and not self:get_sv_has_gained_first_fealty(query_faction:name()) 
			then
			
				if self.fealty_ceos_pending_stack <= 0 then
					script_error("ERROR: nanman_fealty:FactionCeoAdded() fealty_ceos_pending_stack <= 0, This should never happen, as it should have been placed on the stack.")
				else
					self.fealty_ceos_pending_stack = self.fealty_ceos_pending_stack - 1;
				end;

				-- FTUE open the fealty panel if this is the first time the player has gained a fealty. SP only.
				if self.fealty_ceos_pending_stack == 0 then 
				
					-- Can defer (for starting CEOs) the panel opening (if we gave it in new_game for example).
					if self.delay_first_panel_open then
						self.delay_first_panel_open = false;
					else
						effect.call_context_command("OpenPanel(\"3k_dlc06_uniting_the_tribes_panel\")");
						self:set_sv_has_gained_first_fealty(query_faction:name(), true);
					end;
				end;
			end;
		end,
		true
	);

	-- Scenario A+B: Faction About to Die. If the confederator is Nanman, then transfer to killer, else lose the CEOs
	core:add_listener(
		"nanman_fealty_faction_about_to_die", -- listener key
		"FactionAboutToDie", -- campaign event.
		function(context)
			-- Only check for Nanman factions about to die.
			return context:faction():subculture() == self.nanman_subculture_key;
		end,
		function(context)

			local query_killer_faction = nil;

			-- If we know who killed them it was likely through battle or confederation.
			if context:killer_or_confederator_faction_key() ~= "" then
				query_killer_faction = cm:query_faction(context:killer_or_confederator_faction_key());
			end

			-- Scenario A: if it's nanman, we'll transfer.
			if query_killer_faction 
			and not query_killer_faction:is_null_interface() 
			and query_killer_faction:subculture() == self.nanman_subculture_key then

				self:transfer_fealty_ceos_between_factions(context:faction(), query_killer_faction, false);

			-- Scenario B: if the faction was not Nanman, as we'll mark them as 'lost'
			else
				self:mark_all_faction_fealties_as_lost(context:faction());
			end;

			-- Clear out all the Fealty CEOs the faction has gained since the start, preserving their initial fealties.
			self:clear_all_gathered_fealty_ceos_from_faction(context:faction());
		end,
		true
	)

	-- Scenario B: Region captured. Restore lost CEOs.
	core:add_listener(
		"nanman_fealty_garrison_occupied", -- UID
		"GarrisonOccupiedEvent", -- campaign event
		function(context)
			return context:query_character():faction():subculture() == self.nanman_subculture_key 
			and self:does_region_have_lost_fealty_data(context:garrison_residence():region():name());
		end,
		function(context)
			self:recover_lost_fealties(
				context:query_character():faction(),
				context:garrison_residence():region():name()
			);
		end,
		true
	);
	
	-- Scenario C: Faction Subjugated. Give master all ceos of vassalised faction. Also give vassal all the master's CEOs.
	core:add_listener(
		"nanman_fealty_vassalisation", -- UID
		"ScriptEventFactionBecomesVassal", -- Event
		function(custom_context)
			return custom_context:vassal_master():subculture() == self.nanman_subculture_key 
			and custom_context:vassal():subculture() == self.nanman_subculture_key
		end, --Conditions for firing
		function(custom_context)
			self:transfer_fealty_ceos_between_factions(custom_context:vassal_master(), custom_context:vassal(), true);
		end, -- Function to fire.
		true -- Is Persistent?
	);

	-- Scenario D: Joined alliance or coalition.
	core:add_listener(
		"nanman_fealty_diplomacy_trading", -- UID
		"ScriptEventAllianceCreated", -- campaign event
		function(custom_context)
			return custom_context:proposer():subculture() == self.nanman_subculture_key
			and custom_context:recipient():subculture() == self.nanman_subculture_key
		end,
		function(custom_context)
			self:transfer_fealty_ceos_between_factions(custom_context:proposer(), custom_context:recipient(), true);
		end,
		true
	);
	core:add_listener(
		"nanman_fealty_diplomacy_trading", -- UID
		"ScriptEventAllianceJoined", -- campaign event
		function(custom_context)
			return custom_context:alliance_member():subculture() == self.nanman_subculture_key
			and custom_context:joining_faction():subculture() == self.nanman_subculture_key
		end,
		function(custom_context)
			self:transfer_fealty_ceos_between_factions(custom_context:alliance_member(), custom_context:joining_faction(), true);
		end,
		true
	);
	core:add_listener(
		"nanman_fealty_diplomacy_trading", -- UID
		"ScriptEventCoalitionCreated", -- campaign event
		function(custom_context)
			return custom_context:proposer():subculture() == self.nanman_subculture_key
			and custom_context:recipient():subculture() == self.nanman_subculture_key
		end,
		function(custom_context)
			self:transfer_fealty_ceos_between_factions(custom_context:proposer(), custom_context:recipient(), true);
		end,
		true
	);
	core:add_listener(
		"nanman_fealty_diplomacy_trading", -- UID
		"ScriptEventCoalitionJoined", -- campaign event
		function(custom_context)
			return custom_context:alliance_member():subculture() == self.nanman_subculture_key
			and custom_context:joining_faction():subculture() == self.nanman_subculture_key
		end,
		function(custom_context)
			self:transfer_fealty_ceos_between_factions(custom_context:alliance_member(), custom_context:joining_faction(), true);
		end,
		true
	);

	-- MP Coop event.
	core:add_listener(
		"nanman_fealty_diplomacy_trading", -- UID
		"ScriptEventMultiplayerVictorySigned", -- campaign event
		function(custom_context)
			return custom_context:proposer():subculture() == self.nanman_subculture_key
			and custom_context:recipient():subculture() == self.nanman_subculture_key
		end,
		function(custom_context)
			self:transfer_fealty_ceos_between_factions(custom_context:proposer(), custom_context:recipient(), true);
		end,
		true
	);

	-- 5: When the faction awakens from death, give them their initial CEO.
	core:add_listener(
		"nanman_fealty_awaken_from_death", -- UID
		"FactionAwakensFromDeath", -- event
		function(context) -- condition
			return context:faction():subculture() == self.nanman_subculture_key;
		end,
		function(context) -- action
			local awakened_faction_name = context:faction():name();
			local awakened_faction = context:faction();

			local initial_ceos = self:get_initial_ceos_for_faction_key_from_cache(awakened_faction_name);
			if initial_ceos then
				for i, ceo_key in ipairs(initial_ceos) do
					if not awakened_faction:ceo_management():has_ceo_equipped(ceo_key) then
						self:add_starting_fealty_ceo(awakened_faction, ceo_key);
					end;
				end;
			end;
		end,
		true
	)
	
end;

--- @function load_game_fixup
--- @desc Fixes up games where the fealties may have gotten out of sync.
--- @r nil
function nanman_fealty:load_game_fixup()
	
	local nanman_factions = cm:get_all_factions_of_subculture(self.nanman_subculture_key);

	-- NOTE: In 182 campaigns, the nanman have their CEOs equipped in their initial data, but are dead so we shouldn't try to fix them up.
	if cm:get_saved_value("nanman_fealty_tribes_have_yet_to_spawn") then
		return;
	end;

	-- Don't continue if all the nanman faction are dead.
	if nanman_factions:all_of(function(faction) return faction:is_dead() end) then
		return;
	end;

	-- Check we have a cache of origin CEOs to read from, if we don't we'll use a fallback. This should only happen when loading a saved game before this was implemented.
	if not self:get_sv_initial_fealties_cache() then
		script_error(string.format("ERROR: nanman_fealty:load_game_fixup() Unable to find initial_fealties_cache so using fallback. This should only happen in old saves and only the first time it's loaded."));
		if cm.name == "dlc05_new_year" then
			self:set_sv_initial_fealties_cache(self.initial_fealties_fallback_194);
		else
			self:set_sv_initial_fealties_cache(self.initial_fealties_fallback_190);
		end;
	end;

	-- go through the dead factions and remove any CEOs they shouldn't have.
	nanman_factions:filter(function(faction) return faction:is_dead() end):foreach(function(faction)
		self:clear_all_gathered_fealty_ceos_from_faction(faction);
	end);

	-- If no one owns fealty (at all) - spawn into the origin faction (even if they're dead). This guards against them being unwittingly destroyed by script or CEO changes, allowing saved games to recover.
	for ceo_key, data in pairs(self.fealty_data) do
		if nanman_factions:none_of(function(faction) return faction:ceo_management():has_ceo_equipped(ceo_key) end) then

			local initial_ceo_owner_key = self:get_initial_faction_for_ceo_key_from_cache(ceo_key);

			-- If for some crazy reason we didn't find an initial owner, we should error and pick a random nanman faction.
			if not initial_ceo_owner_key or not cm:query_faction(initial_ceo_owner_key) then
				script_error(string.format("ERROR: nanman_fealty:load_game_fixup() Unable to find an owner for the CEO [%s]. Picking the first living Nanman faction to prevent breakages.", ceo_key));
				initial_ceo_owner_key = nanman_factions:filter(function(faction) return not faction:is_dead() end):item_at(0):name();
			end;

			self:add_fealty_ceo_to_faction(cm:query_faction(initial_ceo_owner_key), ceo_key);
		end;
	end;

	-- If all owners of fealty are dead AND no mission is spawned to get them, then 'lose' all faction's fealties from the first faction. 
	-- This covers for Nanman factions having somehow died without exposing their CEOs to be captured.
	-- Note, with the test above, ALL fealties should be owned by someone.
	for ceo_key, data in pairs(self.fealty_data) do
		local factions_owning_fealty = nanman_factions:filter(function(faction) return faction:ceo_management():has_ceo_equipped(ceo_key) end);
		
		if not factions_owning_fealty:is_empty()
		and not self:is_fealty_lost_in_any_region(ceo_key) 
		and factions_owning_fealty:all_of(function(faction) return faction:is_dead() end) then

			self:mark_all_faction_fealties_as_lost(factions_owning_fealty:item_at(0)); -- #TODO: Prefer originator faction if possible.
		end;

	end;

	-- Sync fealties between all factions to make sure allies/vassals/etc. are in sync.
	nanman_factions:foreach(function(faction)
		local source_faction_fealties = faction:ceo_management():all_ceos_for_category(self.fealty_category_key);

		source_faction_fealties:foreach(function(ceo)
			self:add_fealty_ceo_to_faction_master_and_vassals(faction, ceo:ceo_data_key());
		end);

		self:test_if_faction_has_gained_all_fealties(faction);
	end)

end;

--#endregion



--#region Helper Methods


--- @function transfer_fealty_ceos_between_factions
--- @desc Transfer the fealty CEOs from a source faction to a destination faction. Creating them on the destination faction. If clone, the source will also gain the destinations ones.
--- @p [opt=false] query_faction The source faction who is giving up their CEOs
--- @p [opt=false] query_faction The destination faction who is giving up their CEOs
--- @p [opt=false] boolean Whether the CEOs should clone both ways or not.
--- @p [opt=true] bool Should incidents and panels fire.
--- @r nil
function nanman_fealty:transfer_fealty_ceos_between_factions(query_source_faction, query_desination_faction, give_to_source_faction)

	if not query_source_faction or query_source_faction:is_null_interface() then
		script_error("ERROR: nanman_fealty:transfer_fealty_ceos_between_factions() passed in region key is not a query faction. [" .. tostring(query_source_faction) .. "]");
		return;
	end;

	if not query_desination_faction or query_desination_faction:is_null_interface() then
		script_error("ERROR: nanman_fealty:transfer_fealty_ceos_between_factions() passed in region key is not a query faction. [" .. tostring(query_desination_faction) .. "]");
		return;
	end;

	self:print("Transferring CEOs from [" .. query_source_faction:name() .. "] to faction [" .. query_desination_faction:name() .. "]. Should clone? = " .. tostring(give_to_source_faction), true);
	
	-- store a list of the source_faction's ceos.
	local source_faction_fealties = query_source_faction:ceo_management():all_ceos_for_category(self.fealty_category_key);

	-- default to giving the destination faction all that factions ceos.
	source_faction_fealties:foreach(function(ceo)
		self:add_fealty_ceo_to_faction_master_and_vassals(query_desination_faction, ceo:ceo_data_key());
	end);

	-- If we're cloning then give them to the source as well.
	if give_to_source_faction then
		-- store a list of the destination_faction's ceos.
		local destination_faction_fealties = query_desination_faction:ceo_management():all_ceos_for_category(self.fealty_category_key);

		for i = 0, destination_faction_fealties:num_items() - 1 do
			local ceo = destination_faction_fealties:item_at(i);

			self:add_fealty_ceo_to_faction_master_and_vassals(query_source_faction, ceo:ceo_data_key());
		end;
	end;

end;


--- @function mark_all_faction_fealties_as_lost
--- @desc Makes the passed in faction have all their CEOs stored for later retrieval. Also adds a pin to the map on the settlement it was lost in.
--- @p [opt=false] query_faction The faction who is losing all their CEOs.
--- @p [opt=true] bool Should incidents and panels fire.
--- @r nil
function nanman_fealty:mark_all_faction_fealties_as_lost(query_faction)

	if not query_faction or query_faction:is_null_interface() then
		script_error("ERROR: nanman_fealty:mark_all_faction_fealties_as_lost() passed in query_faction is not a query faction. [" .. tostring(query_faction) .. "]");
		return;
	end;

	local faction_owned_fealties = query_faction:ceo_management():all_ceos_for_category(self.fealty_category_key);
	local last_owned_region = self:get_sv_stored_faction_capital(query_faction:name());
	
	-- Check if they have a last owned region. This usually means they've never lived.
	if not last_owned_region then
		script_error("mark_all_faction_fealties_as_lost: Faction " .. query_faction:name() .. " has no last owned region but is losing their fealties. This should never happen.")
		return;
	end;

	-- Check to make sure the region isn't owned by another nanman. If it is, just grant them the CEOs. This saves doing all the setup/pin data.
	local new_region_owner = cm:query_region(last_owned_region):owning_faction();
	if new_region_owner:subculture() == self.nanman_subculture_key then
		for i = 0, faction_owned_fealties:num_items() - 1 do
			local fealty_key = faction_owned_fealties:item_at(i):ceo_data_key();

			self:add_fealty_ceo_to_faction_master_and_vassals(new_region_owner, fealty_key);
		end;

	-- Otherwise, we save out all the datas to be stored. But only if they had fealties to lose.
	elseif not faction_owned_fealties:is_empty() then

		-- Mark any CEOs as lost.
		faction_owned_fealties:foreach(function(query_ceo)
			local fealty_key = query_ceo:ceo_data_key();

			if self:is_fealty_lost_in_region(fealty_key, last_owned_region) then
				return;
			end;

			self:mark_fealty_as_lost_in_region(last_owned_region, query_faction:name(), fealty_key);
			
			self:print("Marking ceo [" .. query_ceo:ceo_data_key() .. "] as lost in region [" .. last_owned_region .. "] from faction [" .. query_faction:name() .. "].", true);
		end);

		--Create Pins and Missions. Since it's done per faction, we need to set up one per human faction.
		local lost_fealty_object = self:get_region_lost_fealty_object(last_owned_region);
		local modify_settlement = cm:modify_settlement(last_owned_region);

		for i, human_faction_key in ipairs(cm:get_human_factions()) do

			local modify_faction = cm:modify_faction(human_faction_key);

			-- Only add for Nanman, as Han factions cannot claim fealty CEOs.
			if modify_faction:query_faction():subculture() == self.nanman_subculture_key then
				
				-- Add Map Pins
				local new_pin_cqi = modify_faction:get_map_pins_handler():add_settlement_pin(modify_settlement, self.fealty_map_pin_key, true);

				table.insert(lost_fealty_object.lost_pin_datas, {faction_key = human_faction_key, pin_cqi = new_pin_cqi});


				-- Add missions Fire an incident for all factions.
				-- We'll setup a listener for when the mission triggers so we can store the cqi (to cancel it later if we have to).
				core:add_listener(
					"nanman_fealty_vassalisation", -- UID
					"MissionIssued", -- Event
					function(context)
						return context:faction():name() == human_faction_key and context:mission():mission_record_key() == self.event_keys_fealty_dropped_mission;
					end, --Conditions for firing
					function(context)
						table.insert(lost_fealty_object.mission_cqis, context:mission():cqi());
					end, -- Function to fire.
					true -- Is Persistent?
				);

				-- MISSION CONSTRUCTOR
				local reclaim_fealty_mission = string_mission:new(self.event_keys_fealty_dropped_mission);
				reclaim_fealty_mission:set_issuer("CLAN_ELDERS");
				reclaim_fealty_mission:add_primary_objective(
					"CONTROL_N_REGIONS_INCLUDING",
					{
						"total 1",
						"region " .. last_owned_region,
						"exclude_allies"
					}
				);
				-- We only add fealties the human player doesn't have as rewards.
				for i, ceo_key in ipairs(lost_fealty_object.ceo_keys) do
					if i > 4 then -- Since there could potentially be 18 ceos in this payload, we'll limit it to 4.
						break;
					end;
					if not modify_faction:query_faction():ceo_management():has_ceo_equipped(ceo_key) then
						reclaim_fealty_mission:add_primary_payload("faction_add_ceo{faction_key " .. human_faction_key .. ";ceo_key " .. ceo_key .. ";}");
					end;
				end;

				reclaim_fealty_mission:trigger_mission_for_faction(human_faction_key);
			end;

		end;

	end;
end;


--- @function mark_fealty_as_lost_in_region
--- @desc Either creates or appends the specified ceo to an existing lost_fealty_object.
--- @p [opt=false] string The region the CEO was lost in.
--- @p [opt=false] string The faction who lost it
--- @p [opt=false] string The CEO key
--- @r nil
function nanman_fealty:mark_fealty_as_lost_in_region(lost_region_key, owner_key, dropped_ceo_key)
	local lost_fealty_object = nil;

	-- Guard against adding it twice.
	if self:is_fealty_lost_in_region(dropped_ceo_key, lost_region_key) then
		return;
	end;

	if self:does_region_have_lost_fealty_data(lost_region_key) then
		lost_fealty_object = self:get_region_lost_fealty_object(lost_region_key)
	else
		lost_fealty_object = {
			region_key = lost_region_key,
			last_owner_key = owner_key,
			ceo_keys = {},
			lost_pin_datas = {}, -- formed as ipairs {faction_key, pin_cqi}
			mission_cqis = {} -- formed as ipairs {faction_key, mission_cqi}
		};
	
		table.insert(self.saved_lost_fealty_datas, lost_fealty_object);
	end;

	table.insert(lost_fealty_object.ceo_keys, dropped_ceo_key);
end;


--- @function get_region_lost_fealty_object
--- @desc Deletes the fealty data for a specified region.
--- @p [opt=false] string The region the CEO was lost in.
--- @r nil
function nanman_fealty:clear_lost_fealties_in_region(region_key)
	local removal_index = -1
	for i, v in ipairs(self.saved_lost_fealty_datas) do
		if v.region_key == region_key then
			removal_index = i;
		end;
	end;

	if removal_index > -1 then
		table.remove(self.saved_lost_fealty_datas, removal_index);
	end;
end;


--- @function get_region_lost_fealty_object
--- @desc Returns the data for a specified region is it has lost fealties. Returns nil if empty.
--- @p [opt=false] string The region the CEO was lost in.
--- @r lost_fealty_object / nil
function nanman_fealty:get_region_lost_fealty_object(region_key)
	
	for i, v in ipairs(self.saved_lost_fealty_datas) do
		if v.region_key == region_key then
			return v;
		end;
	end;

	return nil;
end;


--- @function is_fealty_lost_in_any_region
--- @desc Checks if the specified fealty key is lost in any region.
--- @p [opt=false] string The CEO to test
--- @r bool
function nanman_fealty:is_fealty_lost_in_any_region(target_ceo_key)
	for i, v in ipairs(self.saved_lost_fealty_datas) do
		for j, ceo in ipairs(v.ceo_keys) do

			if ceo == target_ceo_key then
				return true;
			end;
		end;
	end;

	return false;
end;


--- @function does_region_have_lost_fealty_data
--- @desc Checks if the region has it's fealty data set-up.
--- @p [opt=false] string The region the CEO was lost in.
--- @r bool
function nanman_fealty:does_region_have_lost_fealty_data(region_key)
	for i, v in ipairs(self.saved_lost_fealty_datas) do
		if v.region_key == region_key then
			return true;
		end;
	end;

	return false;
end;


--- @function is_fealty_lost_in_region
--- @desc Texts if the specified fealty is marked as lost in that region.
--- @p [opt=false] string The region the CEO was lost in.
--- @p [opt=false] string The ceo key which was lost.
--- @r bool
function nanman_fealty:is_fealty_lost_in_region(fealty_key, region_key)
	if not self:does_region_have_lost_fealty_data() then
		return false;
	end;

	for i, v in ipairs(self.saved_lost_fealty_datas) do
		if v.ceo_key == fealty_key then
			return true;
		end;
	end;
	
	return false;
end;


--- @function recover_lost_fealties
--- @desc Recover any lost CEOs in the region (if there are any). Removes pins and missions.
--- @p [opt=false] query_faction The faction who will gain the CEOs
--- @p [opt=false] string The region to recover them from.
--- @r nil
function nanman_fealty:recover_lost_fealties(query_faction, region_key)

	if not query_faction or query_faction:is_null_interface() then
		script_error("ERROR: nanman_fealty:recover_lost_fealties() passed in region key is not a query faction. [" .. tostring(query_faction) .. "]");
		return;
	end;

	if not is_string(region_key) then
		script_error("ERROR: nanman_fealty:recover_lost_fealties() passed in region key is not a string. [" .. tostring(region_key) .. "]");
		return;
	end;

	if self:does_region_have_lost_fealty_data(region_key) then
		-- Restore CEOs
		for i, fealty_key in ipairs(self:get_region_lost_fealty_object(region_key).ceo_keys) do
			self:add_fealty_ceo_to_faction_master_and_vassals(query_faction, fealty_key);
		end;

		-- Remove pins for each human player.
		local humans = cm:get_human_factions();
		for i, human_faction_key in ipairs(humans) do
			local modify_faction = cm:modify_faction(human_faction_key);

			for i2, pin in ipairs(self:get_region_lost_fealty_object(region_key).lost_pin_datas) do
				if pin.faction_key == human_faction_key then
					local pin_cqi = pin.pin_cqi;

					modify_faction:get_map_pins_handler():remove_pin(pin_cqi);
				end;
			end;
		end;

		-- Remove missions.
		for i, mission_cqi in ipairs(self:get_region_lost_fealty_object(region_key).mission_cqis) do
			local modify_mission = cm:modify_model():get_modify_mission_by_cqi(mission_cqi);

			if not modify_mission:is_null_interface() then
				modify_mission:cancel();
			end;
		end;

		self:clear_lost_fealties_in_region(region_key);
	end;

end;


--- @function test_if_faction_has_gained_all_fealties
--- @desc Whenever a CEO changes hands, go through this test (rather than going through all factions). Passed in faction should always be the one who gained the CEO, but we check their master instead if they're a vassal.
--- @p [opt=false] query_faction The faction we want to test got all their CEOs
--- @r nil
function nanman_fealty:test_if_faction_has_gained_all_fealties(tested_query_faction)
	local tested_faction_key = tested_query_faction:name();

	-- Test if the faction has gained all fealties
	if self:has_faction_gathered_all_fealty_ceos(tested_query_faction) and not self:get_sv_has_faction_gained_all_fealties(tested_faction_key) then
		
		local united_context_data = { -- Data for the custom events.
			faction_key = tested_query_faction:name();
		};
		
		self:set_sv_has_faction_gained_all_fealties(tested_faction_key);

		if tested_query_faction:is_human() then
			cm:trigger_incident(tested_faction_key, self.event_keys_all_fealty_gained, true);
		end;

		core:trigger_custom_event("FealtyTribesUnitedBy", united_context_data);

		-- If they're the first tribe to achieve this and not a vassal, trigger an incident for the other players, and unlock the tech tree.
		-- This should eventually fire for their master.
		if not self:get_sv_have_tribes_been_united_by_anyone() and not diplomacy_manager:is_vassal(tested_faction_key)  then
			self:set_sv_tribes_united_by_anyone();

			-- Fire an incident for all other factions.
			for i, human_faction_key in ipairs(cm:get_human_factions()) do
				if human_faction_key ~= tested_faction_key then
					local query_human_faction = cm:query_faction(human_faction_key);
					
					if query_human_faction:subculture() == self.nanman_subculture_key then -- Fire for all other Nanman.
						cm:trigger_incident(human_faction_key, self.event_keys_all_fealty_gained_other_nanman, true);
					else -- Fire for all non-nanman factions.
						cm:trigger_incident(human_faction_key, self.event_keys_all_fealty_gained_other_non_nanman, true);
					end
				end;
			end;
			
			core:trigger_custom_event("FealtyTribesUnitedByFirst", united_context_data);

			core:trigger_event("UnlockNanmanTechTreeLateTiers"); -- Unlock the final parts of the tech tree.

			self:print("All Nanman Fealties gathered FOR THE FIRST TIME by [" .. tested_query_faction:name() .. "].");
		else
			self:print("All Nanman Fealties gathered by [" .. tested_query_faction:name() .. "].");
		end;
	end;
end;


--- @function has_faction_gathered_all_fealty_ceos
--- @desc Test if the specified faction has gathered all the fealty CEOs
--- @p [opt=false] query_faction The faction who united the tribes.
--- @r--true/false
function nanman_fealty:has_faction_gathered_all_fealty_ceos(query_faction)
	local num_fealties = table.length(self.fealty_data);

	local all_fealty_ceos = query_faction:ceo_management():all_ceos_for_category(self.fealty_category_key);


	if all_fealty_ceos:num_items() < num_fealties then -- Use this test as a gate so we don't always do expensive tests.
		return false;
	end;
	
	self:print(
		"Fealty Gather Test: faction [" .. tostring(query_faction:name()) .. "] Ceos Gathered [" .. tostring(all_fealty_ceos:num_items()) .. "] / [" .. tostring(num_fealties) .. "].",
		true
	);

	-- We had some issues with CEOs getting duplicated when an incident AND the script tried to add them at the same time, so we'll do a more rigorous test. 
	for ceo_key, data in pairs(self.fealty_data) do
		if all_fealty_ceos:none_of(function(ceo) return ceo_key == ceo:ceo_data_key() end) then
			return false;
		end;
	end;
	
	return true;
end;


--- @function print
--- @desc Prints out data to the game.
--- @p [opt=false] string The message to output
--- @p [opt=false] opt_debug_only Should this only fire if the user has debug mode enabled.
--- @r nil
function nanman_fealty:print(string, opt_debug_only)
	if opt_debug_only and not self.debug_mode then
		return;
	end;

	out.traits("[NMFC] Nanman CEOs: " .. string);
end;


--- @function add_starting_fealty_ceo
--- @desc Give the specified faction the specified CEO, also go through their vassals and add to them as well.
--- @p [opt=false] query_faction The faction gaining the CEO.
--- @p [opt=false] string The CEO key to gain.
--- @p [opt=true] bool Should incidents and panels fire.
--- @r nil
function nanman_fealty:add_starting_fealty_ceo(query_faction, fealty_key)

	-- Set the fealty panel to not open for fealties granted at the start, so you don't get a panel pop-up at game start.
	if not cm:is_multiplayer() and query_faction:is_human() then
		self.delay_first_panel_open = true;
	end;
	
	self:add_fealty_ceo_to_faction_master_and_vassals(query_faction, fealty_key)
end;


--- @function add_fealty_ceo_to_faction_master_and_vassals
--- @desc Give the specified faction the specified CEO, also go through their vassals and master and add to them as well.
--- @p [opt=false] query_faction The faction gaining the CEO.
--- @p [opt=false] string The CEO key to gain.
--- @r nil
function nanman_fealty:add_fealty_ceo_to_faction_master_and_vassals(query_faction, fealty_key)

	-- If we give the CEO to the master, it'll get given to vassals, this includes the gaining faction.
	-- We exit early and call this function again with the master as the target.
	local vassal_master = diplomacy_manager:get_vassal_master(query_faction);
	if vassal_master and not vassal_master:is_null_interface() then
		self:add_fealty_ceo_to_faction_master_and_vassals(vassal_master, fealty_key);
		return;	
	end;

	-- Add to the faction and their vassals. Making an assumption that vassals cannot have separate alliances.
	self:add_fealty_ceo_to_faction_and_vassals(query_faction, fealty_key);

	-- Allies members
	diplomacy_manager:get_all_factions_in_alliance(query_faction):foreach(function(allied_faction)
		self:add_fealty_ceo_to_faction_and_vassals(allied_faction, fealty_key);
	end);

	-- Coalition members
	diplomacy_manager:get_all_factions_in_coalition(query_faction):foreach(function(coalition_faction)
		self:add_fealty_ceo_to_faction_and_vassals(coalition_faction, fealty_key);
	end)

	-- MULTIPLAYER: Give Fealties to coop faction in multiplayer.
	if query_faction:is_human() then
		local human_factions = cm:get_human_factions()
		for i, key in ipairs(human_factions) do
			if key ~= query_faction:name() then
				local other_player_faction = cm:query_faction(key);
				if query_faction:has_specified_diplomatic_deal_with("treaty_components_multiplayer_victory", other_player_faction) then
					self:add_fealty_ceo_to_faction_and_vassals(other_player_faction, fealty_key);
				end;
			end;
		end;
	end;
end;


--- @function add_fealty_ceo_to_faction_and_vassals
--- @desc Give the specified faction the specified CEO, also go through their vassals and add to them as well.
--- @p [opt=false] query_faction The faction gaining the CEO.
--- @p [opt=false] string The CEO key to gain.
--- @r nil
function nanman_fealty:add_fealty_ceo_to_faction_and_vassals(query_faction, fealty_key)

	self:add_fealty_ceo_to_faction(query_faction, fealty_key)

	-- Also add fealty to any vassals of that faction, to keep them in sync.
	local vassals = diplomacy_manager:get_all_vassal_factions(query_faction:name());
	for i = 0, vassals:num_items() - 1 do
		self:add_fealty_ceo_to_faction(vassals:item_at(i), fealty_key);
	end;
end;


--- @function add_fealty_ceo_to_faction
--- @desc Give the specified faction the specified CEO. We don't add it agin if they already have it. We also fire an incident to the faction which gained it.
--- @p [opt=false] query_faction The faction gaining the CEO.
--- @p [opt=false] string The CEO key to gain.
--- @r nil
function nanman_fealty:add_fealty_ceo_to_faction(query_faction, fealty_key)

	if not query_faction or query_faction:is_null_interface() then
		script_error("ERROR: add_fealty_ceo_to_faction() No valid faction passed in.");
		return false;
	end;

	if not is_string(fealty_key) then
		script_error("ERROR: nanman_fealty:add_fealty_ceo_to_faction() passed in fealty_key is not a string. [" .. tostring(fealty_key) .. "]");
		return;
	end;

	-- Don't add again if they cannot have it.
	if not query_faction:ceo_management():can_create_ceo(fealty_key) then
		self:print("Not adding ceo [" .. fealty_key .. "] as faction [" .. query_faction:name() .. "] already has it.", true);
		return;
	end;

	-- Double check they're Nanman.
	if query_faction:subculture() ~= self.nanman_subculture_key then
		self:print("Not adding ceo [" .. fealty_key .. "] as faction [" .. query_faction:name() .. "] is not a Nanman.", true);
		return;
	end;

	-- Add a number onto the ceos stack. Used to control when there are no pending ceos to be added.
	if not cm:is_multiplayer()
	and query_faction:is_human() 
	and not self:get_sv_has_gained_first_fealty(query_faction:name()) then

		self.fealty_ceos_pending_stack = self.fealty_ceos_pending_stack + 1;
	end;

	local event_key = self.fealty_data[fealty_key].gained_event_key;

	local modify_faction = cm:modify_faction(query_faction, true);
	modify_faction:ceo_management():add_ceo(fealty_key);
	-- Try to fire the incident giving the CEO (if there is an incident and the faction is human).
	if self.allow_gained_events and event_key and query_faction:is_human() then
		cm:trigger_incident(query_faction:name(), event_key, true);
	end;

	self:print("Added Fealty CEO [" .. fealty_key .. "] to faction [" .. query_faction:name() .. "].", true);
end;


--- @function clear_all_gathered_fealty_ceos_from_faction
--- @desc Removes all fealty ceos from the faction if they don't exist in the initial_ceos cache.
--- @p QueryFaction the faction we want to clear on.
--- @r nil
function nanman_fealty:clear_all_gathered_fealty_ceos_from_faction(query_faction_target)

	if not is_query_faction(query_faction_target) then
		script_error("ERROR: nanman_fealty:clear_all_gathered_fealty_ceos_from_faction() Passed in faction is not a query_faction.")
		return false;
	end;

	if not query_faction_target or query_faction_target:is_null_interface() then
		return false;
	end;

	-- Go through all their fealties and delete them, unless it's their own one.
	local modify_faction_target = cm:modify_faction(query_faction_target);
	local all_fealty_ceos = query_faction_target:ceo_management():all_ceos_for_category(self.fealty_category_key);
	local initial_ceos = self:get_initial_ceos_for_faction_key_from_cache(query_faction_target:name());
	local ceos_to_remove = {};

	if initial_ceos then
		all_fealty_ceos:foreach(function(ceo)
			local ceo_key = ceo:ceo_data_key();

			if not table.contains(initial_ceos, ceo_key) then
				table.insert(ceos_to_remove, ceo_key);
			end;
		end);

		for i, ceo_key in ipairs(ceos_to_remove) do
			modify_faction_target:ceo_management():remove_ceos(ceo_key);
		end;
	end;
end;


--- @function get_sv_have_tribes_been_united_by_anyone
--- @desc Gets if all the fealties have been gathered.
--- @r boolean have they all been gathered?
function nanman_fealty:get_sv_have_tribes_been_united_by_anyone()
	if not cm:saved_value_exists("all_tribes_united", "nanman_fealty") then
		return false;
	end;

	return cm:get_saved_value("all_tribes_united", "nanman_fealty");
end;


--- @function set_sv_tribes_united_by_anyone
--- @desc Sets all the fealties as having been gathered.
--- @r nil
function nanman_fealty:set_sv_tribes_united_by_anyone()
	cm:set_saved_value("all_tribes_united", true, "nanman_fealty");
end;


--- @function get_sv_stored_faction_capital
--- @desc Get the stored faction capital for the faction.
--- @p [opt=false] string The faction whose capital we want.
--- @r string/nil The region key.
function nanman_fealty:get_sv_stored_faction_capital(faction_key)
	if not cm:saved_value_exists("stored_capital", "nanman_fealty", faction_key) then
		return nil;
	end;
	
	return cm:get_saved_value("stored_capital", "nanman_fealty", faction_key);
end;


--- @function set_sv_stored_faction_capital
--- @desc Set a stored capital for the faction.
--- @p [opt=false] string The faction whose capital we want.
--- @p [opt=false] string The region key to set to.
--- @r nil
function nanman_fealty:set_sv_stored_faction_capital(faction_key, capital_key)
	cm:set_saved_value("stored_capital", capital_key, "nanman_fealty", faction_key);
end;


--- @function get_sv_has_gained_first_fealty
--- @desc Get whether the faction has gained their first fealty. Used for FTUE.
--- @p [opt=false] string The faction.
--- @r bool whether they have gained it or not.
function nanman_fealty:get_sv_has_gained_first_fealty(faction_key)
	if not is_string(faction_key) then
		script_error("Fealty faction key is not a string");
		return false;
	end;

	if not cm:saved_value_exists("has_gained_first_fealty", "nanman_fealty", faction_key) then
		return false;
	end;
	
	return cm:get_saved_value("has_gained_first_fealty", "nanman_fealty", faction_key);
end;


--- @function set_sv_has_gained_first_fealty
--- @desc Set thast the faction has gained their first fealty.
--- @p [opt=false] string The faction whose capital we want.
--- @p [opt=false] bool the value to set it to.
--- @r nil
function nanman_fealty:set_sv_has_gained_first_fealty(faction_key, value)
	if not is_string(faction_key) then
		script_error("Fealty faction key is not a string");
		return false;
	end;

	cm:set_saved_value("has_gained_first_fealty", value, "nanman_fealty", faction_key);
end;


--- @function get_sv_has_faction_gained_all_fealties
--- @desc Get if the faction has all the fealties.
--- @p [opt=false] string The faction whose capital we want.
--- @p [opt=false] bool the value to set it to.
--- @r nil
function nanman_fealty:get_sv_has_faction_gained_all_fealties(faction_key)
	if not is_string(faction_key) then
		script_error("Fealty faction key is not a string");
		return false;
	end;

	if not cm:saved_value_exists("has_gained_all_fealties", "nanman_fealty", faction_key) then
		return false;
	end;
	
	return cm:get_saved_value("has_gained_all_fealties", "nanman_fealty", faction_key);
end;


--- @function set_sv_has_faction_gained_all_fealties
--- @desc Set the faction has gained all the fealties.
--- @p [opt=false] string The faction whose capital we want.
--- @p [opt=false] bool the value to set it to.
--- @r nil
function nanman_fealty:set_sv_has_faction_gained_all_fealties(faction_key)
	if not is_string(faction_key) then
		script_error("Fealty faction key is not a string");
		return false;
	end;

	cm:set_saved_value("has_gained_all_fealties", true, "nanman_fealty", faction_key);
end;


--- @function set_sv_initial_fealties_cache
--- @desc Set the value of the fealty cache. Used to work out which factions are the original owner of which CEOs.
--- @p [opt=true] table the value to set it to.
--- @r nil
function nanman_fealty:set_sv_initial_fealties_cache(value)
	if value then
		cm:set_saved_value("initial_fealties_cache", value, "nanman_fealty");
	else
		local initial_fealties = {};

		local faction_list = cm:query_model():world():faction_list()
			:filter(function(faction) return faction:subculture() == self.nanman_subculture_key end)
			:foreach(function(faction)
				local all_fealty_ceos = faction:ceo_management():all_ceos_for_category(self.fealty_category_key);

				if all_fealty_ceos:num_items() > 0 then
					initial_fealties[faction:name()] = {};
					
					all_fealty_ceos:foreach(function(ceo)
						table.insert(initial_fealties[faction:name()], ceo:ceo_data_key());
					end);
				end;
				
			end);

		cm:set_saved_value("initial_fealties_cache", initial_fealties, "nanman_fealty");
	end;
end;


--- @function get_sv_initial_fealties_cache
--- @desc Get the value of the fealty cache. Used to work out which factions are the original owner of which CEOs.
--- @r table or nil
function nanman_fealty:get_sv_initial_fealties_cache()
	if not cm:saved_value_exists("initial_fealties_cache", "nanman_fealty") then
		return nil;
	end;
	
	return cm:get_saved_value("initial_fealties_cache", "nanman_fealty");
end;


--- @function get_initial_faction_for_ceo_key_from_cache
--- @desc Get the first faction in the table who is marked as having that ceo at the start.
--- @p [opt=false] string the ceo_key of the Ceo we're looking for.
--- @r string or nil
function nanman_fealty:get_initial_faction_for_ceo_key_from_cache(ceo_key)
	if not is_string(ceo_key) then
		script_error("ERROR: nanman_fealty:get_initial_faction_for_ceo_key_from_cache() Passed in parameter [ceo_key]. Must be a string.");
		return nil;
	end;

	local cached_origin_ceos = self:get_sv_initial_fealties_cache();

	if cached_origin_ceos then
		for faction_key, initial_ceos in pairs(cached_origin_ceos) do
			for i, initial_ceo_key in ipairs(initial_ceos) do
				if ceo_key == initial_ceo_key then
					return faction_key;
				end;
			end;
		end;
	end;

	return nil;
end;


--- @function get_initial_ceos_for_faction_key_from_cache
--- @desc Get the ceos this faction started the game with.
--- @p [opt=false] string The faction we're looking for.
--- @r table or nil
function nanman_fealty:get_initial_ceos_for_faction_key_from_cache(faction_key)
	if not is_string(faction_key) then
		script_error("ERROR: nanman_fealty:get_initial_ceos_for_faction_key_from_cache() Passed in parameter [faction_key]. Must be a string.");
		return nil;
	end;
	local cached_origin_ceos = self:get_sv_initial_fealties_cache();

	if cached_origin_ceos and cached_origin_ceos[faction_key] then
		return cached_origin_ceos[faction_key];
	end;

	return nil;
end;

--#endregion



--#region Save/Load
---------------------------------------------------------------------------------------------------------
----- SAVE/LOAD
---------------------------------------------------------------------------------------------------------
function nanman_fealty:register_save_load_callbacks()
    cm:add_saving_game_callback(
        function(saving_game_event)
			cm:save_named_value("nanman_fealty_saved_lost_fealty_datas", self.saved_lost_fealty_datas);
        end
    );

    cm:add_loading_game_callback(
        function(loading_game_event)
			local l_saved_lost_fealty_datas = cm:load_named_value("nanman_fealty_saved_lost_fealty_datas", self.saved_lost_fealty_datas);

			self.saved_lost_fealty_datas = l_saved_lost_fealty_datas;
        end
    );
end;

nanman_fealty:register_save_load_callbacks();
--#endregion



-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
--
--	CAMPAIGN SCRIPT
--	This file gets loaded before any of the faction scripts
--
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------


-- require a file in the factions subfolder that matches the name of our local faction. The model will be set up by the time
-- the ui is created, so we wait until this event to query who the local faction is. This is why we defer loading of our
-- faction scripts until this time.

-------------------------------------------------------
--	load in faction scripts when the game is created
-------------------------------------------------------
output("3k_mandate_start.lua :: Loaded");

-- remove this (speak to Steve V first)
cm:set_check_callback_frequency(true);

cm:add_pre_first_tick_callback(
	function()	
		local local_faction = cm:get_local_faction(true);
		
		-- only load faction scripts if we have a local faction
		if not local_faction then
			return;
		end;
		
		output("game_created_callback() called. Player is faction " .. local_faction);
			
		-- if the tweaker to force the campaign prelude is set, then set the sbool value as if the tickbox had been ticked on the frontend
		if effect.tweaker_value("FORCE_FULL_CAMPAIGN_PRELUDE") ~= "0" then
			core:svr_save_bool("sbool_campaign_includes_prelude_intro", true);
		end;
		
		-- if the tweaker to force the campaign prelude to the main section is set, then set the corresponding savegame value
		if effect.tweaker_value("FORCE_CAMPAIGN_PRELUDE_TO_SECOND_PART") ~= "0" then
			cm:set_saved_value("bool_first_turn_intro_completed", true);
		end;
		
		-- load the faction scripts
		-- loads the file in script/campaigns/<campaign_name>/factions/<faction_name>/<faction_name>_start.lua
		cm:load_local_faction_scripts("_start");
		cm:load_faction_scripts_for_both_mp_factions("_events", true); -- Both factions need to register their missions/events so they don't desync in multiplayer.
	end
);

-------------------------------------------------------
--	functions to call when the first tick occurs
-------------------------------------------------------

cm:add_first_tick_callback_new(function() start_new_game_all_factions() end);
cm:add_first_tick_callback(function() start_game_all_factions() end);


-- Called when a new campaign game is started.
-- Put things here that need to be initialised only once, at the start 
-- of the first turn, but for all factions
-- This is run before start_game_all_factions()
function start_new_game_all_factions()
	output("start_new_game_all_factions() called");
	
	inc_tab();
	
	setup_3k_campaign_new();

	-- DO SHARED STUFF HERE
	yt_fervour:new_game(); -- start the yt_frevour listeners.

	-- applies default diplomatic restrictions (not related to gating)
	-- this function may be found in 3k_campaign_default_diplomacy.lua
	campaign_default_diplomacy_start_new_game();

	--Setup the starting emperor seat
	dlc04_global_events:new_game()
	
	-- Liu Bei gains pingyuan AI only
	local m_liu_bei = cm:modify_faction("3k_main_faction_liu_bei");

	if not m_liu_bei:query_faction():is_human() then
		local query_region = cm:query_region("3k_main_pingyuan_capital");
		cm:modify_region(query_region):settlement_gifted_as_if_by_payload(m_liu_bei);

		query_region = cm:query_region("3k_main_pingyuan_resource_1");
		cm:modify_region(query_region):settlement_gifted_as_if_by_payload(m_liu_bei);
	end;

	-- Zhang Liang is moved closer to Ye, Town when both him and Lu Zhi are AI
	local m_lu_zhi = cm:modify_faction("3k_dlc04_faction_lu_zhi");
	local m_zhang_liang = cm:modify_faction("3k_dlc04_faction_zhang_liang");

	output("Checking to see if I should teleport Zhang Liang")
	if m_zhang_liang:query_faction():is_human() or m_lu_zhi:query_faction():is_human() then
		output("Teleporting zhang liang's army!")
		cm:teleport_character(m_zhang_liang:query_faction():faction_leader(), 471, 522);
	end

	dec_tab();
end;


-- Called whenever the game starts over multiple sessions.
-- Useful for systems with listeners or which already hold their own states.
function start_game_all_factions()
	output("start_game_all_factions() called");
	
	inc_tab();
	
	setup_3k_campaign();

	-- Custom modules here!
	campaign_default_diplomacy_start_any_game();

	-- DLC04
	mandate_war_manager:initialise(); -- Listeners for the Mandate of Heaven war system.

	imperial_court:initialise(); -- start listeners for imperial court mechanics
	yt_fervour:initialise(); -- start listeners for yt fervour mechanics
	dlc04_global_events:initialise(); -- Initialise the global eve3nts data for the dlc04 campaign.
	dlc04_emergent_factions:register(); -- Register listeners to spawn emergent factions into the world.
	dlc04_liang_rebellion:register_listeners(); -- Triggers for the liang rebellion.

	misc.free_forces:initialise_effect_bundle_listeners();  -- Adds effect bundles for all forces when they become regionless.
	misc.rebel_armies:initialise_effect_bundle_listeners();  -- Adds effect bundles for all forces when they become regionless.

	
	-- Project specific
	--endgame:initialise();
	--campaign_tutorial:initialise();
	
	-- YTR specific
	
	-- DLC05

	-- Only load the gating scripts if we're NOT in multiplayer.
	if not cm:is_multiplayer() then
		setup_gating();
	end;
	
	dec_tab();
end

function start_campaign_from_intro_cutscene_shared(suppress_startup_missions)

	if not suppress_startup_missions then
		core:trigger_event("ScriptEventStartTutorialMissions");
	end;
	
	-- start advice interventions
	start_global_interventions();
end;

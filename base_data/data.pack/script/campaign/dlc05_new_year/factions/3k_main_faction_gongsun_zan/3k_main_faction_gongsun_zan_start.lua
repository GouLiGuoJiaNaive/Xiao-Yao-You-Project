

-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
--
--	FACTION SCRIPT
--
--	Custom script for this faction starts here. This script loads in additional
--	scripts depending on the mode the campaign is being started in (first turn vs
--	open), sets up the faction_start object and does some other things
--
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------

if not cm:is_multiplayer() then
  cm:load_faction_script(cm:get_local_faction() .. "_tutorial", true);
	cm:load_faction_script(cm:get_local_faction() .. "_progression", true);
	cm:load_faction_script(cm:get_local_faction() .. "_historical", true);
	output("campaign script loaded for " .. cm:get_local_faction());
end

---------------------------------------------------------------
--	First-Tick callbacks
---------------------------------------------------------------

cm:add_first_tick_callback_sp_new(
	function() 
		-- put faction-specific calls that should only gets triggered in a new singleplayer game here
		output("New  SP Game Events Fired for " .. cm:get_local_faction());
		
		cm:start_intro_cutscene_on_loading_screen_dismissed(
			function()
				cm:show_benchmark_if_required(
					function()						
						cutscene_intro_play()
					end,																					-- function to call if not in benchmark mode
					"script/benchmarks/campaign_benchmark/scenes/main1.CindyScene",			                -- benchmark cindy scene
					64.00,																					-- duration of cindy scene
					100,																					-- cam position x at start of scene
					200,																					-- cam position y at start of scene
					6,																						-- cam position d at start of scene
					0,																						-- cam position b at start of scene
					4																						-- cam position h at start of scene
				);
			end
		);
		
		
	end
);


cm:add_first_tick_callback_sp_each(
	function() 
		-- put faction-specific calls that should get triggered each time a singleplayer game loads here
		output("Each SP Game Events Fired for " .. cm:get_local_faction());
	end
);

cm:add_first_tick_callback_mp_new(
	function() 
		-- put faction-specific calls that should only gets triggered in a new multiplayer game here
		-- output("New MP Game Events Fired for " .. cm:get_local_faction());
		
		-- Set starting camera
		cm:set_camera_position(
			353.689453,		-- camera x position 
			465.90332,  	-- camera y position
			13.779046, 		-- camera d position
			0.16,       	-- camera b position
			5.63919	    	-- camera h position
		);
	end
);
--[[

cm:add_first_tick_callback_mp_each(
	function()
		-- put faction-specific calls that should get triggered each time a multiplayer game loads here
		-- output("Each MP Game Events Fired for " .. cm:get_local_faction());
	end
);
]]--





---------------------------------------------------------------
--	Intro Cutscene
---------------------------------------------------------------

function cutscene_intro_play()

	output("cutscene_intro_play");
	
	local cutscene_intro = campaign_cutscene:new(
		"intro",
		80,
		function()
			start_campaign_from_intro_cutscene()
		end,
		true
	);
	
	-- cutscene_intro:set_debug(true);
	cutscene_intro:set_disable_shroud(true);
	
	cutscene_intro:action(
		function()
			cutscene_intro:cindy_playback("script/campaign/dlc05_new_year/factions/dlc05_cutscenes/scenes/dlc05_gongsun_zan.CindyScene", 0, 10);
		end,
		0
	);
	
	cutscene_intro:add_cinematic_trigger_listener( "gongsun_zan_advisor_01", function() cm:show_advice("3k_dlc05_campaign_faction_intro_gongsun_zan_01_advisor"); end );
	cutscene_intro:add_cinematic_trigger_listener( "gongsun_zan_advisor_02", function() cm:show_advice("3k_dlc05_campaign_faction_intro_gongsun_zan_02_gongsun_zan"); end );
	cutscene_intro:add_cinematic_trigger_listener( "gongsun_zan_advisor_03", function() cm:show_advice("3k_dlc05_campaign_faction_intro_gongsun_zan_03_advisor"); end );
	cutscene_intro:add_cinematic_trigger_listener( "gongsun_zan_advisor_04", function() cm:show_advice("3k_dlc05_campaign_faction_intro_gongsun_zan_04_gongsun_zan"); end );
	cutscene_intro:add_cinematic_trigger_listener( "gongsun_zan_advisor_05", function() cm:show_advice("3k_dlc05_campaign_faction_intro_gongsun_zan_05_advisor"); end );
	
	cutscene_intro:start();
end;


function cutscene_intro_skipped(advice_to_play)
	cm:override_ui("disable_advice_audio", true);
	
	effect.clear_advice_session_history();
	
	cm:show_advice("3k_dlc05_campaign_faction_intro_gongsun_zan_01_advisor");
	cm:show_advice("3k_dlc05_campaign_faction_intro_gongsun_zan_02_gongsun_zan");
	cm:show_advice("3k_dlc05_campaign_faction_intro_gongsun_zan_03_advisor");
	cm:show_advice("3k_dlc05_campaign_faction_intro_gongsun_zan_04_gongsun_zan");
	cm:show_advice("3k_dlc05_campaign_faction_intro_gongsun_zan_05_advisor");
	
	cm:callback(function() cm:override_ui("disable_advice_audio", false) end, 0.5);

end;

---------------------------------------------------------------
--	Start of Gameplay
---------------------------------------------------------------

function start_campaign_from_intro_cutscene()
	-- call shared startup function in 3k_early_start.lua
	start_campaign_from_intro_cutscene_shared();
	add_turn_one_character_map_pins();
	add_turn_one_settlement_map_pins();
	end_turn_map_pin_removal_listener();
	turn_one_region_visibility();
	core:trigger_event("ScriptEventStartFirstAdvice");

	--extended_tutorial:setup();
end


---------------------------------------------------------------
--	Turn One Region Visibility: Gongsun Zan
---------------------------------------------------------------

function turn_one_region_visibility()
	-- Reveal a number of relevant regions (and their owning factions) at the start of turn one.

	local modify_faction = cm:modify_faction("3k_main_faction_gongsun_zan");

	if not modify_faction then
		script_error("Error no faction found");
		return;
	end;
	
	-- Visibility for non-adjacent importants factions

	-- Dong Zhuo
	modify_faction:make_region_seen_in_shroud("3k_main_changan_capital");
	
	-- Han Empire
	modify_faction:make_region_seen_in_shroud("3k_main_lingling_resource_2");

end



---------------------------------------------------------------
--	Turn One Map Pins: Gongsun Zan -- [DS]
---------------------------------------------------------------0

function add_turn_one_character_map_pins()
	output("3k_main_faction_gongsun_zan_start.lua: Adding turn one character map pins for Gongsun Zan's faction.");
	-- Find pinned faction leader character cqis from their faction records
	local yuan_shao = cm:query_faction("3k_main_faction_yuan_shao"):faction_leader():cqi();
	local zhang_yan = cm:query_faction("3k_main_faction_zhang_yan"):faction_leader():cqi();
	local gongsun_zan = cm:query_faction("3k_main_faction_gongsun_zan"):faction_leader():cqi();

	-- Create a table connecting our map_pin records with our derived character CQIs
	local map_pin_characters = 
		{
			["3k_dlc05_startpos_pin_gongsun_zan_yuan_shao"] = yuan_shao,
			["3k_dlc05_startpos_pin_gongsun_zan_gongsun_zan"] = gongsun_zan,
			["3k_dlc05_startpos_pin_gongsun_zan_zhang_yan"] = zhang_yan
		}
	
	local is_visible = true;
	local map_pins_handler = cm:modify_local_faction():get_map_pins_handler();
	

	for map_pin_record_key, character_cqi in pairs(map_pin_characters) do

		local modify_character = cm:modify_character(character_cqi);

		map_pins_handler:add_character_pin(modify_character, map_pin_record_key, is_visible);
	end

end

function add_turn_one_settlement_map_pins()
	output("3k_main_faction_gongsun_zan_start.lua: Adding turn one settlement map pins for Sun Jian's faction.");
--[[
	-- Create a table connecting our map_pin records with our region records /settlements
	local map_pin_settlements = 
		{
			["3k_startpos_pin_gongsun_zan_luoyang"] = "3k_main_luoyang_capital",
			["3k_startpos_pin_gongsun_zan_captive_emperor"] = "3k_main_changan_capital"
		}
		
	local is_visible = true;
	local map_pins_handler = cm:modify_local_faction():get_map_pins_handler();


	for map_pin_record_key, region in pairs(map_pin_settlements) do

		local modify_settlement = cm:modify_settlement(region);

		map_pins_handler:add_settlement_pin(modify_settlement, map_pin_record_key, is_visible);
	end
]]
end



-- Clear Map Pins Listeners

function end_turn_map_pin_removal_listener()
	output("3k_main_faction_gongsun_zan_start.lua: Adding End Turn Map Pin Removal Listener.");
	core:add_listener(
		"Turn One End Check",
		"FactionTurnEnd",
		
		-- Is it turn one? If so, when we end turn, carry on to the next function.
		function(context)
			output("3k_main_faction_gongsun_zan_start.lua: Turn one has ended.");
			return context:query_model():turn_number() == 1;
		end,

		-- Remove the scripted pins.
		function(context)
			output("3k_main_faction_gongsun_zan_start.lua: Removing guide map pins.");
			cm:modify_local_faction():get_map_pins_handler():remove_all_runtime_script_pins();
		end,
		false
	);
end;
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
local local_faction_key = "3k_dlc06_faction_nanman_king_meng_huo";

if not cm:is_multiplayer() then
	output("SP campaign script loaded for " .. local_faction_key);
else
	output("MP campaign script loaded for " .. local_faction_key);
end

---------------------------------------------------------------
--	First-Tick callbacks
---------------------------------------------------------------

cm:add_first_tick_callback_sp_new(
	function() 
		-- put faction-specific calls that should only gets triggered in a new singleplayer game here
		output("New  SP Game Events Fired for " .. local_faction_key);

		cm:start_intro_cutscene_on_loading_screen_dismissed(
			function()

				cm:show_benchmark_if_required(
					function()						
						cutscene_intro_play()
					end,																					-- function to call if not in benchmark mode
					"script/benchmarks/campaign_benchmark/scenes/main.CindyScene",			                -- benchmark cindy scene
					90.00,																					-- duration of cindy scene
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

cm:add_first_tick_callback_mp_new(
	function() 
		-- put faction-specific calls that should only gets triggered in a new multiplayer game here
		output("New MP Game Events Fired for " .. local_faction_key);
		
		-- Set starting camera
		cm:set_camera_position(
			113.354462,	-- camera x position 
			205.577151,	-- camera y position 
			25.401993,	-- camera d position 
			-0.000012,	-- camera b position 
			25.39278	-- camera h position			
		);
	end
);


---------------------------------------------------------------
--	Intro Cutscene
---------------------------------------------------------------

function cutscene_intro_play()

	output("cutscene_intro_play");
	
	local cutscene_intro = campaign_cutscene:new(
		"intro",
		97,
		function()
			start_campaign_from_intro_cutscene()
		end,
		true
	);

	cutscene_intro:set_disable_shroud(true);

	cutscene_intro:action( function() cutscene_intro:cindy_playback("script/campaign/three_kingdoms_early/factions/campaign_intro_cutscenes/scenes/scene_01_king_meng_huo.CindyScene", 0, 6); end, 0 );
	
	cutscene_intro:add_cinematic_trigger_listener( "3k_dlc06_190_campaign_faction_intro_king_meng_huo_01_advisor", function() cm:show_advice("3k_dlc06_190_campaign_faction_intro_king_meng_huo_01_advisor"); end );
	cutscene_intro:add_cinematic_trigger_listener( "3k_dlc06_190_campaign_faction_intro_king_meng_huo_02_advisor", function() cm:show_advice("3k_dlc06_190_campaign_faction_intro_king_meng_huo_02_advisor"); end );
	cutscene_intro:add_cinematic_trigger_listener( "3k_dlc06_190_campaign_faction_intro_king_meng_huo_03_advisor", function() cm:show_advice("3k_dlc06_190_campaign_faction_intro_king_meng_huo_03_advisor"); end );
	cutscene_intro:add_cinematic_trigger_listener( "3k_dlc06_190_campaign_faction_intro_king_meng_huo_04_advisor", function() cm:show_advice("3k_dlc06_190_campaign_faction_intro_king_meng_huo_04_advisor"); end );
	cutscene_intro:add_cinematic_trigger_listener( "3k_dlc06_190_campaign_faction_intro_king_meng_huo_05_advisor", function() cm:show_advice("3k_dlc06_190_campaign_faction_intro_king_meng_huo_05_advisor"); end );
	cutscene_intro:add_cinematic_trigger_listener( "3k_dlc06_190_campaign_faction_intro_king_meng_huo_06_advisor", function() cm:show_advice("3k_dlc06_190_campaign_faction_intro_king_meng_huo_06_advisor"); end );
	cutscene_intro:add_cinematic_trigger_listener( "3k_dlc06_190_campaign_faction_intro_king_meng_huo_07_advisor", function() cm:show_advice("3k_dlc06_190_campaign_faction_intro_king_meng_huo_07_advisor"); end );
	cutscene_intro:add_cinematic_trigger_listener( "3k_dlc06_190_campaign_faction_intro_king_meng_huo_08_advisor", function() cm:show_advice("3k_dlc06_190_campaign_faction_intro_king_meng_huo_08_advisor"); end );
	cutscene_intro:add_cinematic_trigger_listener( "3k_dlc06_190_campaign_faction_intro_king_meng_huo_09_advisor", function() cm:show_advice("3k_dlc06_190_campaign_faction_intro_king_meng_huo_09_advisor"); end );

	cutscene_intro:start();


	
end;


function cutscene_intro_skipped(advice_to_play)
	cm:override_ui("disable_advice_audio", true);
	
	effect.clear_advice_session_history();

	cm:show_advice("3k_dlc06_190_campaign_faction_intro_king_meng_huo_01_advisor");
	cm:show_advice("3k_dlc06_190_campaign_faction_intro_king_meng_huo_02_advisor");
	cm:show_advice("3k_dlc06_190_campaign_faction_intro_king_meng_huo_03_advisor");
	cm:show_advice("3k_dlc06_190_campaign_faction_intro_king_meng_huo_04_advisor");
	cm:show_advice("3k_dlc06_190_campaign_faction_intro_king_meng_huo_05_advisor");
	cm:show_advice("3k_dlc06_190_campaign_faction_intro_king_meng_huo_06_advisor");
	cm:show_advice("3k_dlc06_190_campaign_faction_intro_king_meng_huo_07_advisor");
	cm:show_advice("3k_dlc06_190_campaign_faction_intro_king_meng_huo_08_advisor");
	cm:show_advice("3k_dlc06_190_campaign_faction_intro_king_meng_huo_09_advisor");

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

	if extended_tutorial then
		extended_tutorial:setup();
	end;
end





---------------------------------------------------------------
--	Turn One Region Visibility: Meng Huo
---------------------------------------------------------------

function turn_one_region_visibility()

	-- Reveal a number of relevant regions (and their owning factions) at the start of turn one.

	local modify_faction = cm:modify_faction(local_faction_key);

	if not modify_faction then
		script_error("Error no faction found");
		return;
	end;

	-- Jianning
	modify_faction:make_region_seen_in_shroud("3k_main_jianning_resource_1");
	modify_faction:make_region_seen_in_shroud("3k_main_jianning_resource_2");

	-- Zhurong
	modify_faction:make_region_seen_in_shroud("3k_dlc06_yunnan_capital");
	
end



---------------------------------------------------------------
--	Turn One Map Pins: Meng Huo
---------------------------------------------------------------

function add_turn_one_character_map_pins()
	output("3k_dlc06_faction_nanman_king_meng_huo_start.lua: Adding turn one character map pins for Meng Huo's faction.");

	-- Create a table connecting our map_pin records with our derived character CQIs
	local map_pin_characters = 
		{
			["3k_dlc06_startpos_pin_meng_huo_meng_huo"] = cm:query_faction(local_faction_key):faction_leader():cqi(),
			["3k_dlc06_startpos_pin_meng_huo_lady_zhurong"] = cm:query_faction("3k_dlc06_faction_nanman_lady_zhurong"):faction_leader():cqi(),
			["3k_dlc06_startpos_pin_meng_huo_jianning"] = cm:query_faction("3k_dlc06_faction_nanman_jianning"):faction_leader():cqi(),
			["3k_dlc06_startpos_pin_meng_huo_meng_jie"] = cm:query_model():character_for_template("3k_dlc06_template_historical_meng_jie_hero_nanman"):cqi()
		}
		
	
	local is_visible = true;
	local map_pins_handler = cm:modify_local_faction():get_map_pins_handler();
	

	for map_pin_record_key, character_cqi in pairs(map_pin_characters) do

		local modify_character = cm:modify_character(character_cqi);

		map_pins_handler:add_character_pin(modify_character, map_pin_record_key, is_visible);
	end

end

function add_turn_one_settlement_map_pins()
	output("3k_dlc06_faction_nanman_king_meng_huo_start.lua: Adding turn one settlement map pins for Meng Huo's faction.");

	-- Create a table connecting our map_pin records with our region records /settlements
	local map_pin_settlements = 
		{
			["3k_dlc06_startpos_pin_meng_huo_luoyang"] = "3k_main_luoyang_capital"
		}
		
	local is_visible = true;
	local map_pins_handler = cm:modify_local_faction():get_map_pins_handler();


	for map_pin_record_key, region in pairs(map_pin_settlements) do

		local modify_settlement = cm:modify_settlement(region);

		map_pins_handler:add_settlement_pin(modify_settlement, map_pin_record_key, is_visible);
	end

end



-- Clear Map Pins Listeners

function end_turn_map_pin_removal_listener()
	output("3k_dlc06_faction_nanman_king_meng_huo_start.lua: Adding End Turn Map Pin Removal Listener.");

	core:add_listener(
		"Turn One End Check",
		"FactionTurnEnd",
		
		-- Is it turn one? If so, when we end turn, carry on to the next function.
		function(context)
			output("3k_dlc06_faction_nanman_king_meng_huo_start.lua: Turn one has ended.");
			return context:query_model():turn_number() == 1;
		end,

		-- Remove the scripted pins.
		function(context)
			output("3k_dlc06_faction_nanman_king_meng_huo_start.lua: Removing guide map pins.");
			cm:modify_local_faction():get_map_pins_handler():remove_all_runtime_script_pins();
		end,
		false
	);
	
end;
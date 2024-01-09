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

local local_faction_key = "3k_dlc05_faction_sun_ce";

if not cm:is_multiplayer() then
	output("campaign script loaded for " .. local_faction_key);
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



cm:add_first_tick_callback_sp_each(
	function() 
		-- put faction-specific calls that should get triggered each time a singleplayer game loads here
		output("Each SP Game Events Fired for " .. local_faction_key);
	end
);

cm:add_first_tick_callback_mp_new(
	function() 
		-- put faction-specific calls that should only gets triggered in a new multiplayer game here
		-- output("New MP Game Events Fired for " .. local_faction_key);
		
		-- Set starting camera
		cm:set_camera_position(
			352.04,	-- camera x position 
			222.34,	-- camera y position 
			6.64,	-- camera d position 
			-0.416052,	-- camera b position 
			0.64	-- camera h position			
		);
	end
	
);

--[[
cm:add_first_tick_callback_mp_each(
	function()
		-- put faction-specific calls that should get triggered each time a multiplayer game loads here
		-- output("Each MP Game Events Fired for " .. local_faction_key);
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
		98,
		function()
			start_campaign_from_intro_cutscene()
		end,
		true
	);
	
	--cutscene_intro:set_debug(true)
	cutscene_intro:set_disable_shroud(true);
	
	cutscene_intro:action( function() cutscene_intro:cindy_playback("script/campaign/dlc07_guandu/factions/campaing_intro_cutscenes/scenes/sun_quan_198.CindyScene", 0, 6); end, 0 );

	cutscene_intro:add_cinematic_trigger_listener( "sun_ce_01", function() cm:show_advice("3k_dlc07_campaign_faction_intro_sun_quan_01_advisor"); end );
	cutscene_intro:add_cinematic_trigger_listener( "sun_ce_02", function() cm:show_advice("3k_dlc07_campaign_faction_intro_sun_quan_02_advisor"); end );
	cutscene_intro:add_cinematic_trigger_listener( "sun_ce_03", function() cm:show_advice("3k_dlc07_campaign_faction_intro_sun_quan_03_advisor"); end );
	cutscene_intro:add_cinematic_trigger_listener( "sun_ce_04", function() cm:show_advice("3k_dlc07_campaign_faction_intro_sun_quan_04_advisor"); end );
	cutscene_intro:add_cinematic_trigger_listener( "sun_ce_05", function() cm:show_advice("3k_dlc07_campaign_faction_intro_sun_quan_05_advisor"); end );
	cutscene_intro:add_cinematic_trigger_listener( "sun_ce_06", function() cm:show_advice("3k_dlc07_campaign_faction_intro_sun_quan_06_advisor"); end );
	cutscene_intro:add_cinematic_trigger_listener( "sun_ce_07", function() cm:show_advice("3k_dlc07_campaign_faction_intro_sun_quan_07_advisor"); end );

	cutscene_intro:start();
end;


function cutscene_intro_skipped(advice_to_play)
	cm:override_ui("disable_advice_audio", true);
	
	effect.clear_advice_session_history();
	
	cm:show_advice("3k_dlc07_campaign_faction_intro_sun_quan_01_advisor");
	cm:show_advice("3k_dlc07_campaign_faction_intro_sun_quan_02_advisor");
	cm:show_advice("3k_dlc07_campaign_faction_intro_sun_quan_03_advisor");
	cm:show_advice("3k_dlc07_campaign_faction_intro_sun_quan_04_advisor");
	cm:show_advice("3k_dlc07_campaign_faction_intro_sun_quan_05_advisor");
	cm:show_advice("3k_dlc07_campaign_faction_intro_sun_quan_06_advisor");
	cm:show_advice("3k_dlc07_campaign_faction_intro_sun_quan_07_advisor");

	cm:callback(function() cm:override_ui("disable_advice_audio", false) end, 0.5);

end;
---------------------------------------------------------------
--	Start of Gameplay
---------------------------------------------------------------

function start_campaign_from_intro_cutscene()
	start_campaign_from_intro_cutscene_shared()
	add_turn_one_character_map_pins();
	--add_turn_one_settlement_map_pins();
	end_turn_map_pin_removal_listener();
	turn_one_region_visibility();
	core:trigger_event("ScriptEventStartFirstAdvice");

end



---------------------------------------------------------------
--	Turn One Region Visibility
---------------------------------------------------------------

function turn_one_region_visibility()

	-- Reveal a number of relevant regions (and their owning factions) at the start of turn one.

	local modify_faction = cm:modify_faction("3k_dlc05_faction_sun_ce");

	if not modify_faction then
		script_error("Error no faction found");
		return;
	end;

	--Liu Biao
	modify_faction:make_region_seen_in_shroud("3k_main_jingzhou_capital");

	-- Hua Xin
	modify_faction:make_region_visible_in_shroud("3k_main_yuzhang_capital");

	-- Chen Deng
	modify_faction:make_region_seen_in_shroud("3k_main_guangling_capital");

	-- Cao Cao
	modify_faction:make_region_seen_in_shroud("3k_main_yingchuan_capital");

	-- Luoyang
	modify_faction:make_region_seen_in_shroud("3k_main_luoyang_capital");

	-- Yuan Shao
	modify_faction:make_region_seen_in_shroud("3k_main_anping_capital");
		
end


---------------------------------------------------------------
--	Turn One Map Pins
---------------------------------------------------------------0

function add_turn_one_character_map_pins()
	output("3k_dlc05_faction_sun_ce_start.lua: Adding turn one character map pins.");
		-- Create a table connecting our map_pin records with our derived character CQIs
		local map_pin_characters = 
		{
			["3k_dlc07_startpos_pin_sun_ce_chen_deng"] = cm:query_faction("3k_dlc07_faction_chen_deng"):faction_leader():cqi(),
			["3k_dlc07_startpos_pin_sun_ce_hua_xin"] = cm:query_faction("3k_dlc05_faction_hua_xin"):faction_leader():cqi(),
			["3k_dlc07_startpos_pin_sun_ce_liu_biao"] = cm:query_faction("3k_main_faction_liu_biao"):faction_leader():cqi(),
			["3k_dlc07_startpos_pin_sun_ce_sun_ce"] = cm:query_faction("3k_dlc05_faction_sun_ce"):faction_leader():cqi(),
		}
		
	
	local is_visible = true;
	local map_pins_handler = cm:modify_local_faction():get_map_pins_handler();
	

	for map_pin_record_key, character_cqi in pairs(map_pin_characters) do

		local modify_character = cm:modify_character(character_cqi);

		map_pins_handler:add_character_pin(modify_character, map_pin_record_key, is_visible);
	end

end

function add_turn_one_settlement_map_pins()
	output("3k_dlc05_faction_sun_ce_start.lua: Adding turn one settlement map pins.");

end

-- Clear Map Pins Listeners

function end_turn_map_pin_removal_listener()
	output("3k_dlc05_faction_sun_ce_start.lua: Adding End Turn Map Pin Removal Listener.");

	core:add_listener(
		"Turn One End Check",
		"FactionTurnEnd",
		
		-- Is it turn one? If so, when we end turn, carry on to the next function.
		function(context)
			output("3k_dlc05_faction_sun_ce_start.lua: Turn one has ended.");
			return context:query_model():turn_number() == 1;
		end,

		-- Remove the scripted pins.
		function(context)
			output("3k_dlc05_faction_sun_ce_start.lua: Removing guide map pins.");
			cm:modify_local_faction():get_map_pins_handler():remove_all_runtime_script_pins();
		end,
		false
	);
end;
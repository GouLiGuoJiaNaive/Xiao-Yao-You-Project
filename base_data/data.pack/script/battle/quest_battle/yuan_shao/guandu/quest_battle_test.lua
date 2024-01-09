
-- Guandu Battle Yuan Shao

load_script_libraries();

bm = battle_manager:new(empire_battle:new());

-- local gc = generated_cutscene:new(true, true);


gb = generated_battle:new(
	true,                                     			-- screen starts black
	false,                                      			-- prevent deployment for player
	false,                                      		-- prevent deployment for ai
	nil, 				-- intro cutscene function
	true                                      			-- debug mode
);

gb:set_end_deployment_phase_after_loading_screen(true); -- Starts the game and cutscene when the user presses "Start Battle" in the loading screen

-- gb:set_cutscene_during_deployment(true);


-------GENERALS SPEECH--------


-------ARMY SETUP-------
ga_player_01 = gb:get_army(gb:get_player_alliance_num(), 1);
ga_ai_01 = gb:get_army(gb:get_non_player_alliance_num(), 1);
player_army_sunits = gb:get_allied_force(gb:get_player_alliance_num(), -1);
enemy_army_sunits = gb:get_allied_force(gb:get_non_player_alliance_num(), -1);

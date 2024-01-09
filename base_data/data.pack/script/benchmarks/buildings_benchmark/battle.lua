-- Lua version=3.0 --

-------------------------------------------------------------------------------
------------------ Battle Benchmark ---- buildings_benchmark v1.---------------
-------------------------------------------------------------------------------
------------------ Author: Hamish Goodall -------------------------------------
------------------ Last Updated: 22/10/2018 -----------------------------------
-------------------------------------------------------------------------------

load_script_libraries();
bm = battle_manager:new(empire_battle:new());

bool_benchmark_mode = false;

if bm:is_benchmarking_mode() then
	bool_benchmark_mode = true;
end;

bm:setup_battle(function() end_deployment_phase() end);

alliances = bm:alliances();

alliance_army1 = alliances:item(1);
army_army1_01 = alliance_army1:armies():item(1);

alliance_army2 = alliances:item(2); 
army_army2_01 = alliance_army2:armies():item(1);

----------------
--- Army One ---
----------------

------------------------ Army 1 ----------------------------
sunit_army1_01 = script_unit:new(army_army1_01, "army1_01");


uc_army1_01_all = unitcontroller_from_army(army_army1_01);
uc_army1_01_all:take_control();

----------------
--- Army Two ---
----------------

------------------------ Army 2 ----------------------------
sunit_army2_01 = script_unit:new(army_army2_01, "army2_01");


uc_army2_01_all = unitcontroller_from_army(army_army2_01);
uc_army2_01_all:take_control();


function end_deployment_phase()
	bm:out("Starting benchmark");
	
	if bool_benchmark_mode then
		play_cutscene_intro();
	end;
end;
	
--------------------------------------------------------------
------------------------- cutscene ---------------------------
--------------------------------------------------------------

cutscene_intro = cutscene:new(
	"cutscene_intro", 							-- unique string name for cutscene
	uc_army1_01_all, 								-- unitcontroller over player's army
	60000, 										-- duration of cutscene in ms
	function() bm:end_benchmark() end 			-- what to call when cutscene is finished
);

cam = cutscene_intro:camera();
cutscene_intro:set_skippable(false, nil);
--cutscene_intro:set_debug();

function play_cutscene_intro()
	cutscene_intro:action(function() cam:fade(false, 0.5) end, 0);
	
	-- Camera start and first transition -- 
	cutscene_intro:action(function() cam:move_to(v(-117.299759,90.982956,-525.681519),v(-118.443031,17.97937,-309.189148), 0, true, -1) end, 0);
	cutscene_intro:action(function() cam:move_to(v(-114.428986,31.050657,-37.442848),v(-111.985382,-61.084518,171.614685), 7, true, 0) end, 5000);
	
	
	cutscene_intro:action(function() cam:move_to(v(-270.3685,18.431417,236.728226),v(-375.978699,-65.922615,52.525208), 7, true, 0) end, 13000);
	cutscene_intro:action(function() cam:move_to(v(-399.885345,22.076874,-182.584167),v(-214.119522,-52.360222,-292.81192), 9, false, -1) end, 21000);
	cutscene_intro:action(function() cam:move_to(v(-0.694848,15.691501,-347.057983),v(99.411865,-52.390079,-153.296631), 10, true, 0) end, 31000);
	cutscene_intro:action(function() cam:move_to(v(142.206116,26.19463,152.013367),v(-27.947021,-48.837147,19.280502), 10, true, -1) end, 42000);
	
	cutscene_intro:action(function() cam:move_to(v(297.42868,90.982956,287.303558),v(125.946518,20.259109,153.917328), 5, true, -1) end, 55000);
	
	cutscene_intro:action(function() cam:fade(true, 0.5) end, 60000);
	
	cutscene_intro:start();	
end;
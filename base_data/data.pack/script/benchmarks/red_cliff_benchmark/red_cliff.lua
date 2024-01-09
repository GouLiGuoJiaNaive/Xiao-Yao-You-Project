-- Lua version=3.0 --

-------------------------------------------------------------------------------
------------------ Historical Battle Benchmark ---- red_cliff_benchmark v1.----
-------------------------------------------------------------------------------
------------------ Author: Jeremy Gapper - Towse ------------------------------
------------------ Last Updated: 14/02/2019 -----------------------------------
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
army_army3_01 = alliance_army2:armies():item(2);
army_army4_01 = alliance_army2:armies():item(3);

----------------
--- Army One ---
----------------

------------------------- Army 1 ----------------------------
sunit_army1_01 = script_unit:new(army_army1_01, "player_01");


uc_army1_01_all = unitcontroller_from_army(army_army1_01);
uc_army1_01_all:take_control();

----------------
--- Army Two ---
----------------

------------------------- Army 2 ----------------------------
sunit_army2_01 = script_unit:new(army_army2_01, "enemy_cao_cao");


uc_army2_01_all = unitcontroller_from_army(army_army2_01);
uc_army2_01_all:take_control();

------------------------- Army 3 ----------------------------
sunit_army3_01 = script_unit:new(army_army2_02, "enemy_01");


uc_army2_02_all = unitcontroller_from_army(army_army3_01);
uc_army2_02_all:take_control();


------------------------- Army 4 ----------------------------

sunit_army4_01 = script_unit:new(army_army2_03, "enemy_02_centre");

uc_army2_03_all = unitcontroller_from_army(army_army4_01);
uc_army2_03_all:take_control();


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
	120000, 										-- duration of cutscene in ms
	function() bm:end_benchmark() end 			-- what to call when cutscene is finished
);

cam = cutscene_intro:camera();
cutscene_intro:set_skippable(false, nil);
--cutscene_intro:set_debug();

function play_cutscene_intro()
	cutscene_intro:action(function() cam:fade(false, 0.5) end, 0);
	
	-- Camera start and first transition -- 
	cutscene_intro:action(function() cam:move_to(v(483.751831,114.728073,-109.757339),v(271.508545,72.100441,9.903442), 0, true, -1) end, 0);
	cutscene_intro:action(function() cam:move_to(v(483.751831,170.096252,546.343933),v(299.306366,97.033051,398.612946), 8, true, 0) end, 20000);
	
	cutscene_intro:action(function() cam:move_to(v(196.337616,189.448669,910.144348),v(117.391708,115.647987,687.650024), 6, true, 0) end, 40000);
	cutscene_intro:action(function() cam:move_to(v(-387.161957,267.58078,804.802307),v(-231.221863,179.856018,634.010925), 6, true, 0) end, 60000);
	
	cutscene_intro:action(function() cam:move_to(v(-530.181763,50.935291,83.572159),v(-291.288513,36.238556,145.997147), 8, true, 0) end, 80000);
	cutscene_intro:action(function() cam:move_to(v(136.198837,52.365379,-107.159004),v(-33.510712,-9.385628,61.867027), 8, true, 0) end, 100000);
	
	cutscene_intro:action(function() cam:fade(true, 0.5) end, 120000);
	
	cutscene_intro:start();	
end;
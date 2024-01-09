-- Lua version=4.0 --
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

------------------ Dong Zhuo's Army -----------------------
sunit_army1_01 = script_unit:new(army_army1_01, "army1_01");
sunit_army1_02 = script_unit:new(army_army1_01, "army1_02");
sunit_army1_03 = script_unit:new(army_army1_01, "army1_03");
sunit_army1_04 = script_unit:new(army_army1_01, "army1_04");
sunit_army1_05 = script_unit:new(army_army1_01, "army1_05");
sunit_army1_06 = script_unit:new(army_army1_01, "army1_06");
sunit_army1_07 = script_unit:new(army_army1_01, "army1_07");
------------------ Lu Bu's Army ---------------------------
sunit_army1_08 = script_unit:new(army_army1_01, "army1_08");
sunit_army1_09 = script_unit:new(army_army1_01, "army1_09");
sunit_army1_10 = script_unit:new(army_army1_01, "army1_10");
sunit_army1_11 = script_unit:new(army_army1_01, "army1_11");
sunit_army1_12 = script_unit:new(army_army1_01, "army1_12");
sunit_army1_13 = script_unit:new(army_army1_01, "army1_13");
sunit_army1_14 = script_unit:new(army_army1_01, "army1_14");
------------------- Li Ru's Army ---------------------------
sunit_army1_15 = script_unit:new(army_army1_01, "army1_15");
sunit_army1_16 = script_unit:new(army_army1_01, "army1_16");
sunit_army1_17 = script_unit:new(army_army1_01, "army1_17");
sunit_army1_18 = script_unit:new(army_army1_01, "army1_18");
sunit_army1_19 = script_unit:new(army_army1_01, "army1_19");
sunit_army1_20 = script_unit:new(army_army1_01, "army1_20");
sunit_army1_21 = script_unit:new(army_army1_01, "army1_21");

uc_army1_01_all = unitcontroller_from_army(army_army1_01);
uc_army1_01_all:take_control();

----------------
--- Army Two ---
----------------

-------------------- Shen Pei's Army -----------------------
sunit_army2_01 = script_unit:new(army_army2_01, "army2_01");
sunit_army2_02 = script_unit:new(army_army2_01, "army2_02");
sunit_army2_03 = script_unit:new(army_army2_01, "army2_03");
sunit_army2_04 = script_unit:new(army_army2_01, "army2_04");
sunit_army2_05 = script_unit:new(army_army2_01, "army2_05");
sunit_army2_06 = script_unit:new(army_army2_01, "army2_06");
sunit_army2_07 = script_unit:new(army_army2_01, "army2_07");
-------------------- Yan Liang's Army ----------------------
sunit_army2_08 = script_unit:new(army_army2_01, "army2_08");
sunit_army2_09 = script_unit:new(army_army2_01, "army2_09");
sunit_army2_10 = script_unit:new(army_army2_01, "army2_10");
sunit_army2_11 = script_unit:new(army_army2_01, "army2_11");
sunit_army2_12 = script_unit:new(army_army2_01, "army2_12");
sunit_army2_13 = script_unit:new(army_army2_01, "army2_13");
sunit_army2_14 = script_unit:new(army_army2_01, "army2_14");
--------------------- Wen Chou's Army ----------------------
sunit_army2_15 = script_unit:new(army_army2_01, "army2_15");
sunit_army2_16 = script_unit:new(army_army2_01, "army2_16");
sunit_army2_17 = script_unit:new(army_army2_01, "army2_17");
sunit_army2_18 = script_unit:new(army_army2_01, "army2_18");
sunit_army2_19 = script_unit:new(army_army2_01, "army2_19");
sunit_army2_20 = script_unit:new(army_army2_01, "army2_20");
sunit_army2_21 = script_unit:new(army_army2_01, "army2_21");

uc_army2_01_all = unitcontroller_from_army(army_army2_01);
uc_army2_01_all:take_control();

sunits_army1_all = script_units:new(
	"army1_all",
	sunit_army1_01,
	sunit_army1_02,
	sunit_army1_03,
	sunit_army1_04,
	sunit_army1_05,
	sunit_army1_06,
	sunit_army1_07,
	sunit_army1_08,
	sunit_army1_09,
	sunit_army1_10,
	sunit_army1_11,
	sunit_army1_12,
	sunit_army1_13,
	sunit_army1_14,
	sunit_army1_15,
	sunit_army1_16,
	sunit_army1_17,
	sunit_army1_18,
	sunit_army1_19,
	sunit_army1_20,
	sunit_army1_21
);

sunits_army1_cav = script_units:new(
	"army1_cav",
	sunit_army1_06,
	sunit_army1_07,
	sunit_army1_09,
	sunit_army1_10,
	sunit_army1_11,
	sunit_army1_12,
	sunit_army1_13,
	sunit_army1_14
);

sunits_army1_inf = script_units:new(
	"army1_inf",
	sunit_army1_01,
	sunit_army1_02,
	sunit_army1_03,
	sunit_army1_04,
	sunit_army1_05,
	sunit_army1_20,
	sunit_army1_21
);

sunits_army1_mis = script_units:new(
	"army1_mis",
	sunit_army1_16,
	sunit_army1_17,
	sunit_army1_18,
	sunit_army1_19
);

sunits_army1_heroes = script_units:new(
	"army1_heroes",
	sunit_army1_01,
	sunit_army1_08,
	sunit_army1_15
);

sunits_army2_all = script_units:new(
	"army2_all",
	sunit_army2_01,
	sunit_army2_02,
	sunit_army2_03,
	sunit_army2_04,
	sunit_army2_05,
	sunit_army2_06,
	sunit_army2_07,
	sunit_army2_08,
	sunit_army2_09,
	sunit_army2_10,
	sunit_army2_11,
	sunit_army2_12,
	sunit_army2_13,
	sunit_army2_14,
	sunit_army2_15,
	sunit_army2_16,
	sunit_army2_17,
	sunit_army2_18,
	sunit_army2_19,
	sunit_army2_20,
	sunit_army2_21
);

sunits_army2_cav = script_units:new(
	"army2_cav",
	sunit_army2_09,
	sunit_army2_10,
	sunit_army2_11,
	sunit_army2_12,
	sunit_army2_13,
	sunit_army2_14
);

sunits_army2_inf = script_units:new(
	"army2_inf",
	sunit_army2_02,
	sunit_army2_03,
	sunit_army2_16,
	sunit_army2_17,
	sunit_army2_18,
	sunit_army2_19,
	sunit_army2_20,
	sunit_army2_21
);

sunits_army2_mis = script_units:new(
	"army2_mis",
	sunit_army2_03,
	sunit_army2_04,
	sunit_army2_05,
	sunit_army2_06,
	sunit_army2_07
);

sunits_army2_heroes = script_units:new(
	"army2_heroes",
	sunit_army2_01,
	sunit_army2_08,
	sunit_army2_15
);

------------------------------
--          Archers         --
------------------------------

sunits_archers = script_units:new(
	"archers",
	sunit_army1_16,
	sunit_army1_17,
	sunit_army1_18,
	sunit_army1_19,
	sunit_army2_04,
	sunit_army2_05,
	sunit_army2_06,
	sunit_army2_07
	
);



function end_deployment_phase()
	bm:out("Starting benchmark");
	
	if bool_benchmark_mode then
		play_cutscene_intro();
	end;
	
	---------------------
	-- Armies Marching --
	---------------------
	
		-- ** Remove comments to Enable Fire Arrows **
	
	--for i = 1, sunits_archers:count() do
		--local current_sunit = sunits_archers:item(i);
		
		--current_sunit.uc:change_shot_type("small_arm_flaming");
		
	--end;
	
	bm:callback(
		function()
			
			sunits_army1_inf:goto_location_offset(0, -300, true, 0);
			sunits_army1_cav:goto_location_offset(0, -300, true, 0);
			sunits_army1_mis:goto_location_offset(-30, -100, true, 0);
			--sunits_army1_mis:change_shot_type("small_arm_flaming");
			sunits_army1_heroes:goto_location_offset(0, -300, true, 0);
			
			sunits_army2_all:goto_location_offset(0, 100, true, 0);
			--sunits_army2_mis:change_shot_type("small_arm_flaming");
		
		end,
		0
	);
	
	---------------------------
	-- Infantry Attack Order --
	---------------------------
	
	bm:callback(
		function()
		
			sunit_army1_02.uc:attack_unit(sunit_army2_02, true, true);
			sunit_army1_03.uc:attack_unit(sunit_army2_16, true, true);
			sunit_army1_04.uc:attack_unit(sunit_army2_21, true, true);
			sunit_army1_05.uc:attack_unit(sunit_army2_17, true, true);
			sunit_army1_20.uc:attack_unit(sunit_army2_01, true, true);
			sunit_army1_21.uc:attack_unit(sunit_army2_02, true, true);
			
		end,
		6000
	
	);
	
	--------------------------
	-- Cavalry Attack Order --
	--------------------------
	
	bm:callback(
		function()
		
			sunit_army1_06.uc:attack_unit(sunit_army2_20, true, true);
			sunit_army1_07.uc:attack_unit(sunit_army2_02, true, true);
			sunit_army1_09.uc:attack_unit(sunit_army2_13, true, true);
			sunit_army1_10.uc:attack_unit(sunit_army2_09, true, true);
			sunit_army1_11.uc:attack_unit(sunit_army2_15, true, true);
			sunit_army1_12.uc:attack_unit(sunit_army2_12, true, true);
			sunit_army1_13.uc:attack_unit(sunit_army2_07, true, true);
			sunit_army2_14.uc:attack_unit(sunit_army2_05, true, true);
			
		end,
		9000
	);
	
	bm:callback(
		function()
			
			sunits_army1_mis:goto_location_offset(0, 100, true, 180);
		
		end,
		30000
	);
	
	bm:callback(
		function()
			
			sunits_army2_cav:goto_location_offset(0, 60, true, 0);
		
		end,
		43000
	);
	
	
	
	bm:callback(
		function()
			
			sunits_army1_mis:change_behaviour_active("fire_at_will", true);
			sunits_army2_cav:goto_location_offset(0, 65, true, 0);
		
		end,
		58000
	);
	
	--------------------------------
	-- Enemy army movement orders --
	--------------------------------
	
	bm:callback(
		function()
			
			sunits_army2_inf:goto_location_offset(0, 50, true, 0);
			sunits_army2_mis:goto_location_offset(0, 50, true, 0);
			sunits_army2_heroes:goto_location_offset(0, 50, true, 0);
		
		end,
		64000
	);
	
	---------------------------------
	-- Enemy Archers attack orders --
	---------------------------------
	
	bm:callback(
		function()
		
			sunit_army2_04.uc:attack_unit(sunit_army1_16.unit, true, true);	
			sunit_army2_05.uc:attack_unit(sunit_army1_17.unit, true, true);
			sunit_army2_06.uc:attack_unit(sunit_army1_18.unit, true, true);
			sunit_army2_07.uc:attack_unit(sunit_army1_19.unit, true, true);
		
		end,
		80000
	);
	
end;


--------------------------------------------------------------
------------------------- cutscene ---------------------------
--------------------------------------------------------------

cutscene_intro = cutscene:new(
	"cutscene_intro", 							-- unique string name for cutscene
	uc_army1_01_all, 								-- unitcontroller over player's army
	100000, 										-- duration of cutscene in ms
	function() bm:end_benchmark() end 			-- what to call when cutscene is finished
);

cam = cutscene_intro:camera();
cutscene_intro:set_skippable(false, nil);
--cutscene_intro:set_debug();

function play_cutscene_intro()
	cutscene_intro:action(function() cam:fade(false, 0.5) end, 0);
	
	-- Camera start and first transition -- 
	cutscene_intro:action(function() cam:move_to(v(16.612877,717.376953,409.651001),v(49.210381,677.831116,167.665573), 0, true, -1) end, 0);
	cutscene_intro:action(function() cam:move_to(v(219.41098,628.751587,186.241653),v(113.925591,573.561951,-30.578537), 9, true, -1) end, 3000);
	
	-- players right side pan & preparing for army clash -- 
	cutscene_intro:action(function() cam:move_to(v(-298.90509,690.848267,-51.111019),v(-86.767593,582.223267,15.089428), 12, true, -1) end, 30000);
	cutscene_intro:action(function() cam:move_to(v(-171.782486,650.526245,-51.727909),v(49.050201,539.094604,-51.641171), 14, true, -1) end, 47000);
	
	-- army clash pan test -- 
	cutscene_intro:action(function() cam:move_to(v(14.18733,612.309875,-89.51712),v(187.431381,573.899414,82.804718), 10, true, -1) end, 66000);
	cutscene_intro:action(function() cam:move_to(v(141.611206,609.066772,-96.485085),v(-10.977692,604.024902,98.129631), 10, true, -1) end, 74000);
	
	cutscene_intro:action(function() cam:fade(true, 0.5) end, 100000);
	
	cutscene_intro:start();	
end;
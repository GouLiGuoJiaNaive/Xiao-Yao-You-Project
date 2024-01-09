-- Lua version=3.0 --

-------------------------------------------------------------------------------
------------------ CPU Benchmark ---- Gamescom Demo v1.0 ------------------
-------------------------------------------------------------------------------
------------------ Created by Hamish: 26/06/2018 ------------------------------
------------------ Last Updated: 26/06/2018 by Hamish -------------------------
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

------------------- Sun Quan's Army ------------------------
sunit_army1_01 = script_unit:new(army_army1_01, "army1_01");
sunit_army1_02 = script_unit:new(army_army1_01, "army1_02");
sunit_army1_03 = script_unit:new(army_army1_01, "army1_03");
sunit_army1_04 = script_unit:new(army_army1_01, "army1_04");
sunit_army1_05 = script_unit:new(army_army1_01, "army1_05");
----------------- Sun Shanxiang's Army ---------------------
sunit_army1_06 = script_unit:new(army_army1_01, "army1_06");
sunit_army1_07 = script_unit:new(army_army1_01, "army1_07");
sunit_army1_08 = script_unit:new(army_army1_01, "army1_08");
sunit_army1_09 = script_unit:new(army_army1_01, "army1_09");
sunit_army1_10 = script_unit:new(army_army1_01, "army1_10");


uc_army1_01_all = unitcontroller_from_army(army_army1_01);
uc_army1_01_all:take_control();

----------------
--- Army Two ---
----------------

--------------------- General's Army -----------------------
sunit_army2_01 = script_unit:new(army_army2_01, "army2_01");
sunit_army2_02 = script_unit:new(army_army2_01, "army2_02");
sunit_army2_03 = script_unit:new(army_army2_01, "army2_03");
--------------------- Captain's Army  ----------------------
sunit_army2_04 = script_unit:new(army_army2_01, "army2_04");
sunit_army2_05 = script_unit:new(army_army2_01, "army2_05");
sunit_army2_06 = script_unit:new(army_army2_01, "army2_06");
sunit_army2_07 = script_unit:new(army_army2_01, "army2_07");
sunit_army2_08 = script_unit:new(army_army2_01, "army2_08");
-------------------- Xu Huang's Army -----------------------
sunit_army2_09 = script_unit:new(army_army2_01, "army2_09");
sunit_army2_10 = script_unit:new(army_army2_01, "army2_10");
sunit_army2_11 = script_unit:new(army_army2_01, "army2_11");
sunit_army2_12 = script_unit:new(army_army2_01, "army2_12");
sunit_army2_13 = script_unit:new(army_army2_01, "army2_13");
------------------- Zhang Liao's Army ----------------------
sunit_army2_14 = script_unit:new(army_army2_01, "army2_14");
sunit_army2_15 = script_unit:new(army_army2_01, "army2_15");
sunit_army2_16 = script_unit:new(army_army2_01, "army2_16");
sunit_army2_17 = script_unit:new(army_army2_01, "army2_17");
sunit_army2_18 = script_unit:new(army_army2_01, "army2_18");
sunit_army2_19 = script_unit:new(army_army2_01, "army2_19");
sunit_army2_20 = script_unit:new(army_army2_01, "army2_20");

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
	sunit_army1_10

);

sunits_army1_cav = script_units:new(
	"army1_cav",
	sunit_army1_01,
	sunit_army1_02,
	sunit_army1_03,
	sunit_army1_04,
	sunit_army1_05

);

sunits_army1_Hinf = script_units:new(
	"army1_Hinf",
	sunit_army1_09,
	sunit_army1_10
	
);

sunits_army1_heroes = script_units:new(
	"army1_heroes",
	sunit_army1_01,
	sunit_army1_06
	
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
	sunit_army2_20

);

sunits_army2_mis = script_units:new(
	"army2_mis",
	sunit_army2_02,
	sunit_army2_03
);

sunits_army2_heroes = script_units:new(
	"army2_heroes",
	sunit_army2_01,
	sunit_army2_04,
	sunit_army2_09,
	sunit_army2_14
	
);

sunits_army2_inf = script_units:new(
	"army1_inf",
	sunit_army2_05,
	sunit_army2_06,
	sunit_army2_07,
	sunit_army2_08,
	sunit_army2_15,
	sunit_army2_16,
	sunit_army2_17,
	sunit_army2_18,
	sunit_army2_19,
	sunit_army2_20
	
);

------------------------------
--          Archers         --
------------------------------

sunits_archers = script_units:new(
	"archers",
	sunit_army2_02,
	sunit_army2_03,
	sunit_army1_09,
	sunit_army1_10

);



function end_deployment_phase()
	bm:out("Starting benchmark");
	
	if bool_benchmark_mode then
		play_cutscene_intro();
	end;
	
	-- ** Remove comments to Enable Fire Arrows **
	
	for i = 1, sunits_archers:count() do
		local current_sunit = sunits_archers:item(i);
		
		--current_sunit.uc:change_shot_type("small_arm_flaming");
		current_sunit.uc:change_behaviour_active("Skirmish", false);
		current_sunit.uc:change_behaviour_active("Fire_at_will", false);
		
	end;
	
	for i = 1, sunits_army1_Hinf:count() do
		local current_sunit = sunits_army1_Hinf:item(i);
		
		current_sunit.uc:change_behaviour_active("Melee", true);
		
	end;
	
	
	for i = 1, sunits_army1_all:count() do
		local current_sunit = sunits_army1_all:item(i);
		

		current_sunit.uc:set_invincible(true);
		
	end;
	
	for i = 1, sunits_army2_all:count() do
		local current_sunit = sunits_army2_all:item(i);
		

		current_sunit.uc:set_invincible(true);
		
	end;
	
	
	sunit_army1_01.uc:set_invincible(true);
	sunit_army1_06.uc:set_invincible(true);
	
	----------------------------
	--   Enemy Ambush Charge  --
	----------------------------
	
	bm:callback(
		function()
				
			--sunits_army2_inf:goto_location_offset(0, 50, true, 0);
			
			-- Enemy Archer Volley --
			sunit_army2_02.uc:attack_unit(sunit_army1_04.unit, true, true);
			sunit_army2_03.uc:attack_unit(sunit_army1_05.unit, true, true);
			
			
			-- Enemy infantry charge --
			sunit_army2_05.uc:attack_unit(sunit_army1_07.unit, true, true);
			sunit_army2_06.uc:attack_unit(sunit_army1_08.unit, true, true);
			sunit_army2_07.uc:attack_unit(sunit_army1_09.unit, true, true);
			sunit_army2_08.uc:attack_unit(sunit_army1_10.unit, true, true);
			
			-- Enemy Hero charge
			sunit_army2_01.uc:attack_unit(sunit_army1_06.unit, true, true);
			sunit_army2_04.uc:attack_unit(sunit_army1_01.unit, true, true);
		
		end,
		3000
	);
	
	------------------------
	--  Enemy Charge 2.0  --
	------------------------		
	bm:callback(
		function()
			
			sunit_army2_10.uc:attack_unit(sunit_army1_07.unit, true, true);
			sunit_army2_11.uc:attack_unit(sunit_army1_08.unit, true, true);
			sunit_army2_12.uc:attack_unit(sunit_army1_09.unit, true, true);
			sunit_army2_13.uc:attack_unit(sunit_army1_10.unit, true, true);
			
			-- Enemy Hero targets General
			sunit_army2_09.uc:attack_unit(sunit_army1_01.unit, true, true);
			sunit_army2_14.uc:attack_unit(sunit_army1_07.unit, true, true);
			
			-- Enemy Reinforcement charge
			sunit_army2_15.uc:attack_unit(sunit_army1_07.unit, true, true);
			sunit_army2_16.uc:attack_unit(sunit_army1_08.unit, true, true);
			sunit_army2_17.uc:attack_unit(sunit_army1_09.unit, true, true);
			sunit_army2_18.uc:attack_unit(sunit_army1_10.unit, true, true);
			sunit_army2_19.uc:attack_unit(sunit_army1_08.unit, true, true);
			sunit_army2_20.uc:attack_unit(sunit_army1_09.unit, true, true);

		end,
		4000
	
	);
	
	bm:callback(
		function()
			
			-- Allied forces reaction
			sunit_army1_07.uc:attack_unit(sunit_army2_05.unit, true, true);
			sunit_army1_08.uc:attack_unit(sunit_army2_06.unit, true, true);
			sunit_army1_09.uc:attack_unit(sunit_army2_07.unit, true, true);
			sunit_army1_10.uc:attack_unit(sunit_army2_08.unit, true, true);
			
			-- Enemy Hero charge
			sunit_army1_01.uc:attack_unit(sunit_army2_04.unit, true, true);
			sunit_army1_06.uc:attack_unit(sunit_army2_02.unit, true, true);
			
			-- Cavalry flank order
			sunit_army1_02.uc:attack_unit(sunit_army2_02.unit, true, true);
			sunit_army1_03.uc:attack_unit(sunit_army2_02.unit, true, true);
			sunit_army1_04.uc:attack_unit(sunit_army2_03.unit, true, true);
			sunit_army1_05.uc:attack_unit(sunit_army2_03.unit, true, true);
		
		end,
		11000
	);
	
	--------------------------
	-- Cavalry Attack Order --
	--------------------------
	
	bm:callback(
		function()
		
			sunit_army1_02.uc:attack_unit(sunit_army2_15.unit, true, true);
			sunit_army1_03.uc:attack_unit(sunit_army2_16.unit, true, true);
			sunit_army1_04.uc:attack_unit(sunit_army2_17.unit, true, true);
			sunit_army1_05.uc:attack_unit(sunit_army2_18.unit, true, true);
			
		end,
		30000
	);
	
	----------------------------------
	-- Hero attack --
	----------------------------------
	
	bm:callback(
		function()
			
			sunit_army1_01.uc:attack_unit(sunit_army2_09.unit, true, true);
			sunit_army1_06.uc:attack_unit(sunit_army2_14.unit, true, true);
		
		end,
		50000
	);
	
	--------------------------
	-- Cavalry Attack Order 2.0 --
	--------------------------
	
	
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
	cutscene_intro:action(function() cam:move_to(v(411.032684,611.315247,78.81691),v(412.015747,611.205444,78.963669), 0, true, -1) end, 0);
	cutscene_intro:action(function() cam:move_to(v(454.094788,624.842224,52.713036),v(453.927399,624.581604,53.663872), 13, true, -1) end, 4000);
	
	-- players right side pan & preparing for army clash -- 
	cutscene_intro:action(function() cam:move_to(v(572.205017,649.732544,147.410614),v(571.377136,649.381775,146.871109), 12, true, -1) end, 14000);
	cutscene_intro:action(function() cam:move_to(v(563.866211,624.476318,31.48687),v(563.343811,624.308838,32.380116), 14, true, 0) end, 40000);
	
	-- army clash pan test -- 
	cutscene_intro:action(function() cam:move_to(v(423.293091,625.545105,120.261856),v(424.275269,625.274536,120.507896), 10, false, -1) end, 60000);
	cutscene_intro:action(function() cam:move_to(v(451.790375,651.546082,27.955427),v(452.039917,651.120911,28.880203), 20, true, -1) end, 84000);
	
	cutscene_intro:action(function() cam:fade(true, 0.5) end, 120000);
	
	cutscene_intro:start();	
end;
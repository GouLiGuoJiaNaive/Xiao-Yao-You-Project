-- Lua version=3.0 --

-------------------------------------------------------------------------------
------------------ CPU Benchmark ---- Rise of Dong Zhuo v1.0 ------------------
-------------------------------------------------------------------------------
------------------ Created by Hamish: 25/06/2018 ------------------------------
------------------ Last Updated: 25/06/2018 by Hamish -------------------------
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

------------------ Dong Zhuo's Army -----------------------
sunit_army1_01 = script_unit:new(army_army1_01, "army1_01");
sunit_army1_02 = script_unit:new(army_army1_01, "army1_02");
sunit_army1_03 = script_unit:new(army_army1_01, "army1_03");
sunit_army1_04 = script_unit:new(army_army1_01, "army1_04");
sunit_army1_05 = script_unit:new(army_army1_01, "army1_05");
------------------ Lu Bu's Army ---------------------------
sunit_army1_06 = script_unit:new(army_army1_01, "army1_06");
sunit_army1_07 = script_unit:new(army_army1_01, "army1_07");
sunit_army1_08 = script_unit:new(army_army1_01, "army1_08");
sunit_army1_09 = script_unit:new(army_army1_01, "army1_09");
sunit_army1_10 = script_unit:new(army_army1_01, "army1_10");
------------------- Li Ru's Army ---------------------------
sunit_army1_11 = script_unit:new(army_army1_01, "army1_11");
sunit_army1_12 = script_unit:new(army_army1_01, "army1_12");
sunit_army1_13 = script_unit:new(army_army1_01, "army1_13");
sunit_army1_14 = script_unit:new(army_army1_01, "army1_14");
sunit_army1_15 = script_unit:new(army_army1_01, "army1_15");
sunit_army1_16 = script_unit:new(army_army1_01, "army1_16");
sunit_army1_17 = script_unit:new(army_army1_01, "army1_17");

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
	sunit_army1_17

);

sunits_army1_cav = script_units:new(
	"army1_cav",
	sunit_army1_06,
	sunit_army1_07,
	sunit_army1_08,
	sunit_army1_09,
	sunit_army1_10

);

sunits_army1_Hinf = script_units:new(
	"army1_Hinf",
	sunit_army1_12,
	sunit_army1_13,
	sunit_army1_14,
	sunit_army1_15
);

sunits_army1_mis = script_units:new(
	"army1_mis",
	sunit_army1_16,
	sunit_army1_17
);

sunits_army1_heroes = script_units:new(
	"army1_heroes",
	sunit_army1_01,
	sunit_army1_06,
	sunit_army1_11
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
	sunit_army2_19

);

sunits_army2_mis = script_units:new(
	"army2_mis",
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

sunits_army2_inf = script_units:new(
	"army1_inf",
	sunit_army2_09,
	sunit_army2_10,
	sunit_army2_11,
	sunit_army2_12,
	sunit_army2_02,
	sunit_army2_03,
	sunit_army2_16,
	sunit_army2_17,
	sunit_army2_18,
	sunit_army2_19
);

------------------------------
--          Archers         --
------------------------------

sunits_archers = script_units:new(
	"archers",
	sunit_army1_16,
	sunit_army1_17,
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
	
	-- ** Remove comments to Enable Fire Arrows **
	
	for i = 1, sunits_archers:count() do
		local current_sunit = sunits_archers:item(i);
		
		current_sunit.uc:change_shot_type("small_arm_flaming");
		current_sunit.uc:change_behaviour_active("Skirmish", false);
		current_sunit.uc:change_behaviour_active("Fire_at_will", false);
		
	end;
	
	--for i = 1, sunits_army1_all:count() do
	--	local current_sunit = sunits_army1_all:item(i);
		
	--	current_sunit.uc:set_invincible(true);
		
	--end;
	
	--for i = 1, sunits_army2_all:count() do
	--	local current_sunit = sunits_army2_all:item(i);
		
	--	current_sunit.uc:set_invincible(true);
		
	--end;
	
	
	sunit_army1_16.uc:set_invincible(true);
	sunit_army1_17.uc:set_invincible(true);
	sunit_army2_16.uc:set_invincible(true);
	sunit_army2_03.uc:set_invincible(true);
	
	---------------------
	--   Enemy Charge  --
	---------------------
	
	---------------------------
	-- Infantry Brace Order  --
	---------------------------
	
	bm:callback(
		function()
		
			--sunits_army1_Hinf:perform_special_ability("3K_main_formation_turtle");
			
			for j = 1, sunits_army1_Hinf:count() do
				local current_sunit = sunits_army1_Hinf:item(j);
				
				current_sunit.uc:perform_special_ability("3K_main_formation_turtle", current_sunit.unit);
				
			end;

		end,
		0
	
	);
	
	bm:callback(
		function()
				
			--sunits_army2_inf:goto_location_offset(0, 50, true, 0);
			
			-- Enemy Archer Volley --
			sunit_army2_04.uc:attack_unit(sunit_army1_15.unit, true, true);
			sunit_army2_05.uc:attack_unit(sunit_army1_13.unit, true, true);
			sunit_army2_06.uc:attack_unit(sunit_army1_12.unit, true, true);
			sunit_army2_07.uc:attack_unit(sunit_army1_14.unit, true, true);
			
			-- Allied archers
			sunit_army1_16.uc:attack_unit(sunit_army2_03.unit, true, true);
			sunit_army1_17.uc:attack_unit(sunit_army2_18.unit, true, true);
		
		end,
		2000
	);
	
	bm:callback(
		function()
			
			sunit_army2_02.uc:attack_unit(sunit_army1_15.unit, true, true);
			sunit_army2_03.uc:attack_unit(sunit_army1_14.unit, true, true);
			sunit_army2_16.uc:attack_unit(sunit_army1_15.unit, true, true);
			sunit_army2_17.uc:attack_unit(sunit_army1_14.unit, true, true);
			sunit_army2_18.uc:attack_unit(sunit_army1_13.unit, true, true);
			sunit_army2_19.uc:attack_unit(sunit_army1_12.unit, true, true);

		end,
		2100
	);
	
	
	------------------------
	--  Enemy Charge 2.0  --
	------------------------		
	bm:callback(
		function()
			
			sunit_army2_09.uc:attack_unit(sunit_army1_13.unit, true, true);
			sunit_army2_10.uc:attack_unit(sunit_army1_13.unit, true, true);
			sunit_army2_11.uc:attack_unit(sunit_army1_12.unit, true, true);
			sunit_army2_12.uc:attack_unit(sunit_army1_12.unit, true, true);
			
			sunit_army2_02.uc:attack_unit(sunit_army1_15.unit, true, true);
			sunit_army2_03.uc:attack_unit(sunit_army1_14.unit, true, true);
			sunit_army2_16.uc:attack_unit(sunit_army1_15.unit, true, true);
			sunit_army2_17.uc:attack_unit(sunit_army1_14.unit, true, true);
			sunit_army2_18.uc:attack_unit(sunit_army1_13.unit, true, true);
			sunit_army2_19.uc:attack_unit(sunit_army1_12.unit, true, true);
			
			sunit_army2_01.uc:attack_unit(sunit_army1_01.unit, true, true);
			sunit_army2_08.uc:attack_unit(sunit_army1_11.unit, true, true);
			sunit_army2_15.uc:attack_unit(sunit_army1_11.unit, true, true);

		end,
		6100
	
	);
	
	--------------------------
	-- Cavalry Attack Order --
	--------------------------
	
	bm:callback(
		function()
		
			sunit_army1_06.uc:attack_unit(sunit_army2_01.unit, true, true);
			sunit_army1_07.uc:attack_unit(sunit_army2_18.unit, true, true);
			sunit_army1_08.uc:attack_unit(sunit_army2_17.unit, true, true);
			sunit_army1_09.uc:attack_unit(sunit_army2_05.unit, true, true);
			sunit_army1_10.uc:attack_unit(sunit_army2_04.unit, true, true);
			
		end,
		11000
	);
	
	----------------------------------
	-- Cavalry Counter Attack Order --
	----------------------------------
	
	bm:callback(
		function()
			
			sunit_army2_13.uc:attack_unit(sunit_army1_07.unit, true, true);
			sunit_army2_14.uc:attack_unit(sunit_army1_08.unit, true, true);
		
		end,
		30000
	);
	
	--------------------------
	-- Cavalry Attack Order 2.0 --
	--------------------------
	
	bm:callback(
		function()
		
			sunit_army1_09.uc:attack_unit(sunit_army2_17.unit, true, true);
			sunit_army1_10.uc:attack_unit(sunit_army2_18.unit, true, true);
			sunit_army1_06.uc:attack_unit(sunit_army2_17.unit, true, true);
			
		end,
		40000
	);
	
	bm:callback(
		function()
		
			sunit_army1_02.uc:attack_unit(sunit_army2_19.unit, true, true);
			sunit_army1_03.uc:attack_unit(sunit_army2_16.unit, true, true);
			sunit_army1_04.uc:attack_unit(sunit_army2_02.unit, true, true);
			sunit_army1_05.uc:attack_unit(sunit_army2_03.unit, true, true);
			
		end,
		65000
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
	cutscene_intro:action(function() cam:move_to(v(-56.552429,604.962158,-35.599857),v(-656.39801,595.268616,-595.30896), 0, true, -1) end, 0);
	cutscene_intro:action(function() cam:move_to(v(-52.556557,606.022644,-41.360294),v(-495.205109,626.553223,649.166321), 9, true, -1) end, 3000);
	
	-- players right side pan & preparing for army clash -- 
	cutscene_intro:action(function() cam:move_to(v(-9.951303,604.636292,-22.344233),v(-813.636108,479.144501,85.051247), 12, true, -1) end, 10000);
	cutscene_intro:action(function() cam:move_to(v(-53.647705,620.435242,159.340866),v(-316.096039,412.072266,-589.572693), 14, true, 0) end, 30000);
	
	-- army clash pan test -- 
	cutscene_intro:action(function() cam:move_to(v(-68.603256,603.807861,0.144862),v(-866.349426,652.07782,-185.422058), 10, false, -1) end, 50000);
	cutscene_intro:action(function() cam:move_to(v(-259.545135,643.414246,-76.392624),v(188.767731,295.694061,516.291443), 20, true, -1) end, 74000);
	
	cutscene_intro:action(function() cam:fade(true, 0.5) end, 100000);
	
	cutscene_intro:start();	
end;
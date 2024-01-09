-- Lua version=3.0 --

-------------------------------------------------------------------------------
------------------ Battle Benchmark ---- Luoyang v1.34 -------------------------
-------------------------------------------------------------------------------
------------------ Author: Hamish Goodall -------------------------------------
------------------ Last Updated: 10/10/2018 -----------------------------------
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

------------------ Zhuge Liang's Army ----------------------
sunit_army1_01 = script_unit:new(army_army1_01, "army1_01");
sunit_army1_02 = script_unit:new(army_army1_01, "army1_02");
sunit_army1_03 = script_unit:new(army_army1_01, "army1_03");
sunit_army1_04 = script_unit:new(army_army1_01, "army1_04");
sunit_army1_05 = script_unit:new(army_army1_01, "army1_05");
sunit_army1_06 = script_unit:new(army_army1_01, "army1_06");
sunit_army1_07 = script_unit:new(army_army1_01, "army1_07");
------------------ Zhuo Yun's Army -------------------------
sunit_army1_08 = script_unit:new(army_army1_01, "army1_08");
sunit_army1_09 = script_unit:new(army_army1_01, "army1_09");
sunit_army1_10 = script_unit:new(army_army1_01, "army1_10");
sunit_army1_11 = script_unit:new(army_army1_01, "army1_11");
sunit_army1_12 = script_unit:new(army_army1_01, "army1_12");
sunit_army1_13 = script_unit:new(army_army1_01, "army1_13");
sunit_army1_14 = script_unit:new(army_army1_01, "army1_14");
------------------- Ma Teng's Army -------------------------
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

-------------------- Cao Cao's Army ------------------------
sunit_army2_01 = script_unit:new(army_army2_01, "army2_01");
sunit_army2_02 = script_unit:new(army_army2_01, "army2_02");
sunit_army2_03 = script_unit:new(army_army2_01, "army2_03");
sunit_army2_04 = script_unit:new(army_army2_01, "army2_04");
sunit_army2_05 = script_unit:new(army_army2_01, "army2_05");
sunit_army2_06 = script_unit:new(army_army2_01, "army2_06");
sunit_army2_07 = script_unit:new(army_army2_01, "army2_07");
-------------------- Dian Wei's Army ----------------------
sunit_army2_08 = script_unit:new(army_army2_01, "army2_08");
sunit_army2_09 = script_unit:new(army_army2_01, "army2_09");
sunit_army2_10 = script_unit:new(army_army2_01, "army2_10");
sunit_army2_11 = script_unit:new(army_army2_01, "army2_11");
sunit_army2_12 = script_unit:new(army_army2_01, "army2_12");
sunit_army2_13 = script_unit:new(army_army2_01, "army2_13");
sunit_army2_14 = script_unit:new(army_army2_01, "army2_14");
--------------------- Han Sui's Army ----------------------
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
	sunit_army1_16,
	sunit_army1_17,
	sunit_army1_18,
	sunit_army1_19

);

sunits_army1_Hinf = script_units:new(
	"army1_Hinf",
	sunit_army1_02,
	sunit_army1_03,
	sunit_army1_04,
	sunit_army1_05
);

sunits_army1_mis = script_units:new(
	"army1_mis",
	sunit_army1_09,
	sunit_army1_10,
	sunit_army1_11,
	sunit_army1_12
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

sunits_army2_mis = script_units:new(
	"army2_mis",
	sunit_army2_09,
	sunit_army2_10
);

sunits_army2_heroes = script_units:new(
	"army2_heroes",
	sunit_army2_01,
	sunit_army2_08,
	sunit_army2_15
);

sunits_army2_inf = script_units:new(
	"army1_inf",
	sunit_army2_02,
	sunit_army2_03,
	sunit_army2_04,
	sunit_army2_05,
	sunit_army2_06,
	sunit_army2_07,
	sunit_army2_11,
	sunit_army2_12,
	sunit_army2_13,
	sunit_army2_14,
	sunit_army2_20,
	sunit_army2_21
);

------------------------------
--          Archers         --
------------------------------

sunits_archers = script_units:new(
	"archers",
	sunit_army2_09,
	sunit_army2_10
);



function end_deployment_phase()
	bm:out("Starting benchmark");
	
	if bool_benchmark_mode then
		play_cutscene_intro();
	end;
	
	for i = 1, sunits_army2_mis:count() do
		local current_sunit = sunits_army2_mis:item(i);
		
		current_sunit.uc:change_behaviour_active("Skirmish", false);
		current_sunit.uc:change_behaviour_active("Fire_at_will", false);
		
	end;
	
	for i = 1, sunits_army1_mis:count() do
		local current_sunit = sunits_army1_mis:item(i);
		
		current_sunit.uc:change_behaviour_active("Skirmish", false);
		
	end;
	
	sunit_army1_02.uc:set_invincible(true);
	sunit_army1_03.uc:set_invincible(true);
	sunit_army1_04.uc:set_invincible(true);
	sunit_army1_05.uc:set_invincible(true);
	sunit_army1_01.uc:set_invincible(true);
	sunit_army2_01.uc:set_invincible(true);
	
	---------------------
	--   Enemy Charge  --
	---------------------
	
	---------------------------
	-- Infantry Brace Order  --
	---------------------------
	
	bm:callback(
		function()
		
			-- Enemy Army full Charge --
		
			-- Enemy Archer Volley --
			sunit_army2_09.uc:attack_unit(sunit_army1_11.unit, true, true);
			sunit_army2_10.uc:attack_unit(sunit_army1_10.unit, true, true);
			
			-- Enemy Frontline --
			sunit_army2_02.uc:attack_unit(sunit_army1_03.unit, true, true);
			sunit_army2_03.uc:attack_unit(sunit_army1_03.unit, true, true);
			sunit_army2_04.uc:attack_unit(sunit_army1_04.unit, true, true);
			sunit_army2_05.uc:attack_unit(sunit_army1_05.unit, true, true);
			sunit_army2_06.uc:attack_unit(sunit_army1_02.unit, true, true);
			sunit_army2_07.uc:attack_unit(sunit_army1_02.unit, true, true);
			
			-- Enemy Secondline --
			sunit_army2_11.uc:attack_unit(sunit_army1_03.unit, true, true);
			sunit_army2_12.uc:attack_unit(sunit_army1_04.unit, true, true);
			sunit_army2_13.uc:attack_unit(sunit_army1_05.unit, true, true);
			sunit_army2_14.uc:attack_unit(sunit_army1_02.unit, true, true);
			
			-- Elite Infantry --
			sunit_army2_20.uc:attack_unit(sunit_army1_12.unit, true, true);
			sunit_army2_21.uc:attack_unit(sunit_army1_09.unit, true, true);
			
			-- Cavalry --
			sunit_army2_17.uc:attack_unit(sunit_army1_03.unit, true, true);
			sunit_army2_16.uc:attack_unit(sunit_army1_04.unit, true, true);
			sunit_army2_19.uc:attack_unit(sunit_army1_05.unit, true, true);
			sunit_army2_18.uc:attack_unit(sunit_army1_02.unit, true, true);
			
			-- Enemy Generals --
			sunit_army2_01.uc:attack_unit(sunit_army1_01.unit, false, true);
			sunit_army2_08.uc:attack_unit(sunit_army1_03.unit, false, true);
			sunit_army2_15.uc:attack_unit(sunit_army1_02.unit, false, true);

		end,
		0
	
	);
	
	------------------------
	--    Allied Pincer   --
	------------------------		
	bm:callback(
		function()
			
		-- Allied Left Flank Pincer --
		sunit_army1_17.uc:attack_unit(sunit_army2_21.unit, true, true);
		sunit_army1_16.uc:attack_unit(sunit_army2_13.unit, true, true);
		sunit_army1_19.uc:attack_unit(sunit_army2_12.unit, true, true);
		sunit_army1_18.uc:attack_unit(sunit_army2_19.unit, true, true);
		sunit_army1_15.uc:attack_unit(sunit_army2_15.unit, true, true);
		
		-- Enemy Archer re-target --
		sunit_army2_09.uc:attack_unit(sunit_army1_03.unit, true, true);
		sunit_army2_10.uc:attack_unit(sunit_army1_02.unit, true, true);
		
		end,
		18000
	
	);	
	
	bm:callback(
		function()
		
			-- Allied Reinforcements --
			
			-- Allied Right Flank --
			sunit_army1_07.uc:attack_unit(sunit_army2_02.unit, true, true);
			sunit_army1_06.uc:attack_unit(sunit_army2_02.unit, true, true);
			
			-- Allied Left Flank --
			sunit_army1_20.uc:attack_unit(sunit_army2_07.unit, true, true);
			sunit_army1_21.uc:attack_unit(sunit_army2_07.unit, true, true);

		end,
		34000
	);
	
	
	bm:callback(
		function()
			
		-- Allied right Flank Pincer --
		sunit_army1_13.uc:attack_unit(sunit_army2_20.unit, true, true);
		sunit_army1_14.uc:attack_unit(sunit_army2_11.unit, true, true);
		sunit_army1_08.uc:attack_unit(sunit_army2_08.unit, true, true);
		
		end,
		45000
	
	);
	
	--------------------------
	--     Enemy Counter    --
	--------------------------
	
	bm:callback(
		function()
		
		sunit_army2_21.uc:attack_unit(sunit_army1_17.unit, true, true);
		sunit_army2_14.uc:attack_unit(sunit_army1_16.unit, true, true);
		sunit_army2_13.uc:attack_unit(sunit_army1_19.unit, true, true);
		sunit_army2_19.uc:attack_unit(sunit_army1_18.unit, true, true);
		sunit_army2_15.uc:attack_unit(sunit_army1_15.unit, true, true);
		
		sunit_army2_20.uc:attack_unit(sunit_army1_13.unit, true, true);
		sunit_army2_11.uc:attack_unit(sunit_army1_14.unit, true, true);
		sunit_army2_08.uc:attack_unit(sunit_army1_08.unit, true, true);
			
		end,
		75000
	);
	
	
end;


--------------------------------------------------------------
------------------------- cutscene ---------------------------
--------------------------------------------------------------

cutscene_intro = cutscene:new(
	"cutscene_intro", 							-- unique string name for cutscene
	uc_army1_01_all, 								-- unitcontroller over player's army
	93000, 										-- duration of cutscene in ms
	function() bm:end_benchmark() end 			-- what to call when cutscene is finished
);

cam = cutscene_intro:camera();
cutscene_intro:set_skippable(false, nil);
--cutscene_intro:set_debug();

function play_cutscene_intro()
	cutscene_intro:action(function() cam:fade(false, 0.5) end, 0);
	
	-- Camera start and first transition -- 
	cutscene_intro:action(function() cam:move_to(v(115.336105,173.960419,-323.885529),v(4.785492,152.682663,-385.693848), 0, true, -1) end, 0);
	cutscene_intro:action(function() cam:move_to(v(-55.981678,98.646606,-415.246216),v(-154.484955,110.817276,-496.753601), 7, true, 0) end, 5000);
	cutscene_intro:action(function() cam:move_to(v(-68.907234,98.53508,-415.838898),v(37.771896,108.733032,-486.620453), 7, true, 0) end, 13000);
	
	
	-- players right side pan & preparing for army clash -- 
	cutscene_intro:action(function() cam:move_to(v(-142.89743,126.507607,-436.495026),v(-37.376396,77.769363,-381.865753), 9, false, -1) end, 21000);
	cutscene_intro:action(function() cam:move_to(v(38.1847,112.020065,-424.742523),v(-53.436821,57.401733,-353.210754), 10, true, 0) end, 31000);
	
	-- army clash pan test -- 
	cutscene_intro:action(function() cam:move_to(v(-146.699249,105.887199,-350.379791),v(-110.60817,86.887611,-472.161957), 10, true, -1) end, 42000);
	cutscene_intro:action(function() cam:move_to(v(31.503056,126.818916,-333.07663),v(-30.306145,72.259949,-431.552063), 18, true, -1) end, 55000);
	cutscene_intro:action(function() cam:move_to(v(77.965126,171.399643,-343.837372),v(-34.271652,132.322281,-392.523468), 8, true, -1) end, 73000);
	cutscene_intro:action(function() cam:move_to(v(28.632778,127.843956,-470.506622),v(-45.193447,95.450455,-370.532532), 6, true, -1) end, 83000);
	
	cutscene_intro:action(function() cam:fade(true, 0.5) end, 93000);
	
	cutscene_intro:start();	
end;
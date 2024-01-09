-- Lua version=3.0 --

-------------------------------------------------------------------------------
------------------ Dynasty Benchmark ---- Dynasty Mode v2.0 -------------------
-------------------------------------------------------------------------------
------------------ Created by Hamish: 12/03/2019 ------------------------------
------------------ Last Updated: 12/03/2019 by Hamish -------------------------
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

-------------------------- Heroes --------------------------
sunit_army1_01 = script_unit:new(army_army1_01, "army1_01");
sunit_army1_02 = script_unit:new(army_army1_01, "army1_02");
sunit_army1_03 = script_unit:new(army_army1_01, "army1_03");



uc_army1_01_all = unitcontroller_from_army(army_army1_01);
uc_army1_01_all:take_control();

----------------
--- Army Two ---
----------------

---------------------- Zhuge Liang's -----------------------
sunit_army2_01 = script_unit:new(army_army2_01, "army2_01");
sunit_army2_02 = script_unit:new(army_army2_01, "army2_02");
sunit_army2_03 = script_unit:new(army_army2_01, "army2_03");
sunit_army2_04 = script_unit:new(army_army2_01, "army2_04");
sunit_army2_05 = script_unit:new(army_army2_01, "army2_05");
sunit_army2_06 = script_unit:new(army_army2_01, "army2_06");
sunit_army2_07 = script_unit:new(army_army2_01, "army2_07");
sunit_army2_08 = script_unit:new(army_army2_01, "army2_08");
sunit_army2_09 = script_unit:new(army_army2_01, "army2_09");
sunit_army2_10 = script_unit:new(army_army2_01, "army2_10");
sunit_army2_11 = script_unit:new(army_army2_01, "army2_11");
sunit_army2_12 = script_unit:new(army_army2_01, "army2_12");
sunit_army2_13 = script_unit:new(army_army2_01, "army2_13");
sunit_army2_14 = script_unit:new(army_army2_01, "army2_14");
sunit_army2_15 = script_unit:new(army_army2_01, "army2_15");
sunit_army2_16 = script_unit:new(army_army2_01, "army2_16");
sunit_army2_17 = script_unit:new(army_army2_01, "army2_17");
sunit_army2_18 = script_unit:new(army_army2_01, "army2_18");
sunit_army2_19 = script_unit:new(army_army2_01, "army2_19");
sunit_army2_20 = script_unit:new(army_army2_01, "army2_20");
sunit_army2_21 = script_unit:new(army_army2_01, "army2_21");
sunit_army2_22 = script_unit:new(army_army2_01, "army2_22");
sunit_army2_23 = script_unit:new(army_army2_01, "army2_23");
sunit_army2_24 = script_unit:new(army_army2_01, "army2_24");
sunit_army2_25 = script_unit:new(army_army2_01, "army2_25");
sunit_army2_26 = script_unit:new(army_army2_01, "army2_26");
sunit_army2_27 = script_unit:new(army_army2_01, "army2_27");
sunit_army2_28 = script_unit:new(army_army2_01, "army2_28");
sunit_army2_29 = script_unit:new(army_army2_01, "army2_29");
sunit_army2_30 = script_unit:new(army_army2_01, "army2_30");
sunit_army2_31 = script_unit:new(army_army2_01, "army2_31");
sunit_army2_32 = script_unit:new(army_army2_01, "army2_32");
sunit_army2_33 = script_unit:new(army_army2_01, "army2_33");


uc_army2_01_all = unitcontroller_from_army(army_army2_01);
uc_army2_01_all:take_control();

sunits_army1_all = script_units:new(
	"army1_all",
	sunit_army1_01,
	sunit_army1_02,
	sunit_army1_03,
	sunit_army1_04,
	sunit_army1_05,
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
	sunit_army2_20,
	sunit_army2_21,
	sunit_army2_22,
	sunit_army2_23,
	sunit_army2_24,
	sunit_army2_25,
	sunit_army2_26,
	sunit_army2_27,
	sunit_army2_28,
	sunit_army2_29,
	sunit_army2_30,
	sunit_army2_31,
	sunit_army2_32,
	sunit_army2_33
);


function end_deployment_phase()
	bm:out("Starting benchmark");
	
	if bool_benchmark_mode then
		play_cutscene_intro();
	end;
	
	-- HERO GODMODE ENABLED! --
	
	for i = 1, sunits_army1_all:count() do
		local current_sunit = sunits_army1_all:item(i);
		
		current_sunit.uc:set_invincible(true);
		
	end;
	
	
	---------------------
	--   Enemy Charge  --
	---------------------
	
	bm:callback(
		function()
		
			--------------------------
			--- Enemy Charge Order --
			--------------------------
			
			-- Enemies targeting Cao Cao 1st wave --
			sunit_army2_14.uc:attack_unit(sunit_army1_01.unit, false, false);
			sunit_army2_15.uc:attack_unit(sunit_army1_01.unit, false, false);
			sunit_army2_17.uc:attack_unit(sunit_army1_01.unit, false, false);
			sunit_army2_05.uc:attack_unit(sunit_army1_01.unit, false, false);
			sunit_army2_11.uc:attack_unit(sunit_army1_01.unit, false, false);
			sunit_army2_06.uc:attack_unit(sunit_army1_01.unit, false, false);
			sunit_army2_12.uc:attack_unit(sunit_army1_01.unit, false, false);
			sunit_army2_18.uc:attack_unit(sunit_army1_01.unit, false, false);
			
			-- Enemies targeting Dian Wei 1st wave --
			sunit_army2_08.uc:attack_unit(sunit_army1_02.unit, false, false);
			sunit_army2_02.uc:attack_unit(sunit_army1_02.unit, false, false);
			sunit_army2_07.uc:attack_unit(sunit_army1_02.unit, false, false);
			sunit_army2_01.uc:attack_unit(sunit_army1_02.unit, false, false);
			sunit_army2_13.uc:attack_unit(sunit_army1_02.unit, false, false);
			sunit_army2_09.uc:attack_unit(sunit_army1_02.unit, false, false);
			
			-- Enemies targeting Dong Zhuo --
			sunit_army2_03.uc:attack_unit(sunit_army1_03.unit, false, false);
			sunit_army2_10.uc:attack_unit(sunit_army1_03.unit, false, false);
			sunit_army2_04.uc:attack_unit(sunit_army1_03.unit, false, false);
			sunit_army2_16.uc:attack_unit(sunit_army1_03.unit, false, false);
			

		end,
		16000
	);
	
	bm:callback(
		function()
		
			--------------------------
			--- Allied Charge Order --
			--------------------------
			
			sunit_army1_01.uc:attack_unit(sunit_army2_11.unit, true, true);
			sunit_army1_02.uc:attack_unit(sunit_army2_04.unit, true, true);
			sunit_army1_03.uc:attack_unit(sunit_army2_01.unit, true, true);

		end,
		20000
	);
	
	bm:callback(
		function()
		
			-- ** ENABLED ENEMY GUARD MODE **
	
			for i = 1, sunits_army2_all:count() do
				local current_sunit = sunits_army2_all:item(i);
				
				current_sunit.uc:change_behaviour_active("defend", true);
		
			end;

		end,
		25000
	);
	
	--------------------------
	----- Hero Abilities------
	--------------------------
	
	bm:callback(
		function()
			
			-- Cao Cao - Earth --
			sunit_army1_01.uc:perform_special_ability("ep_dyn_ability_arrow_storm", sunit_army2_11.unit);
			
			-- Dian Wei - Wood --
			sunit_army1_02.uc:perform_special_ability("ep_dyn_ability_seismic_slam", sunit_army2_04.unit);
			
			-- Dong Zhuo - Fire --
			sunit_army1_03.uc:perform_special_ability("ep_dyn_ability_sweeping_arc", sunit_army2_01.unit);
		
		end,
		30000
	);
	
	bm:callback(
		function()
		
			--------------------------
			--- Allied Charge Order --
			--------------------------
			
			sunit_army1_01.uc:attack_unit(sunit_army2_09.unit, true, true);
			sunit_army1_02.uc:attack_unit(sunit_army2_12.unit, true, true);
			sunit_army1_03.uc:attack_unit(sunit_army2_17.unit, true, true);

		end,
		40000
	);
	
--bm:callback(
	--	function()
		
			--------------------------
			---  Enemy Second Wave ---
			--------------------------
			
			-- Enemies targeting Cao Cao 2nd wave --
			--sunit_army2_32.uc:attack_unit(sunit_army1_01.unit, false, true);
			--sunit_army2_33.uc:attack_unit(sunit_army1_01.unit, false, true);
			--sunit_army2_23.uc:attack_unit(sunit_army1_01.unit, false, true);
			--sunit_army2_29.uc:attack_unit(sunit_army1_01.unit, false, true);
			--sunit_army2_24.uc:attack_unit(sunit_army1_01.unit, false, true);
			--sunit_army2_30.uc:attack_unit(sunit_army1_01.unit, false, true);
			
			-- Enemies targeting Dian Wei 2nd wave --
			--sunit_army2_26.uc:attack_unit(sunit_army1_02.unit, false, true);
			--sunit_army2_20.uc:attack_unit(sunit_army1_02.unit, false, true);
			--sunit_army2_25.uc:attack_unit(sunit_army1_02.unit, false, true);
			--sunit_army2_19.uc:attack_unit(sunit_army1_02.unit, false, true);
			--sunit_army2_31.uc:attack_unit(sunit_army1_02.unit, false, true);
			
			-- Enemies targeting Dong Zhuo 2nd wave --
			--sunit_army2_27.uc:attack_unit(sunit_army1_03.unit, false, true);
			--sunit_army2_22.uc:attack_unit(sunit_army1_03.unit, false, true);
			--sunit_army2_28.uc:attack_unit(sunit_army1_03.unit, false, true);
			
		--end,
		--50000
	--);
	
	--------------------------
	----- Hero Abilities------
	--------------------------
	
	bm:callback(
		function()
			
			-- Cao Cao - Earth --
			sunit_army1_01.uc:perform_special_ability("ep_dyn_ability_palm_strike", sunit_army2_09.unit);
			
			-- Dian Wei - Wood --
			sunit_army1_02.uc:perform_special_ability("ep_dyn_ability_clear_a_path", sunit_army2_12.unit);
			
			-- Dong Zhuo - Fire --
			sunit_army1_03.uc:perform_special_ability("ep_dyn_ability_flaming_fury", sunit_army2_17.unit);
		
		end,
		55000
	);
	
	bm:callback(
		function()
		
			--------------------------
			--- Allied Charge Order --
			--------------------------
			
			sunit_army1_01.uc:attack_unit(sunit_army2_14.unit, true, true);
			sunit_army1_02.uc:attack_unit(sunit_army2_10.unit, true, true);
			sunit_army1_03.uc:attack_unit(sunit_army2_07.unit, true, true);

		end,
		60000
	);
	
	
	

	
	
	--------------------------
	----- Remove Routing -----
	--------------------------
	
	
	
end;


--------------------------------------------------------------
------------------------- cutscene ---------------------------
--------------------------------------------------------------

cutscene_intro = cutscene:new(
	"cutscene_intro", 							-- unique string name for cutscene
	uc_army1_01_all, 								-- unitcontroller over player's army
	80000, 										-- duration of cutscene in ms
	function() bm:end_benchmark() end 			-- what to call when cutscene is finished
);

cam = cutscene_intro:camera();
cutscene_intro:set_skippable(false, nil);
--cutscene_intro:set_debug();

function play_cutscene_intro()
	cutscene_intro:action(function() cam:fade(false, 0.5) end, 0);
	
	-- Camera start and Hero pan -- 
	cutscene_intro:action(function() cam:move_to(v(14.402782,595.964172,25.941364),v(-107.253273,485.102386,-156.98526), 1, true, -1) end, 0);
	cutscene_intro:action(function() cam:move_to(v(14.949832,607.230774,32.91193),v(-54.074963,464.917664,-155.59642), 6, false, 0) end, 3000);
	cutscene_intro:action(function() cam:move_to(v(-89.309471,638.63855,-58.878212),v(86.441154,507.513611,52.794579), 3, false, 0) end, 9000);
	
	-- Pan out -- 
	cutscene_intro:action(function() cam:move_to(v(97.442993,641.261841,-70.877571),v(-69.610306,502.116486,44.381317), 12, true, -1) end, 45000);
	cutscene_intro:action(function() cam:move_to(v(68.381714,652.814758,97.059937),v(-53.044434,499.662598,-52.448975), 14, true, 0) end, 55000);
	cutscene_intro:action(function() cam:move_to(v(-91.542908,654.425781,70.65538),v(58.60878,496.486816,-43.636963), 10, false, -1) end, 75000);
	cutscene_intro:action(function() cam:fade(true, 0.5) end, 80000);
	
	cutscene_intro:start();	
end;
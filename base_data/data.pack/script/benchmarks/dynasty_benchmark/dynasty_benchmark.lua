-- Lua version=3.0 --

-------------------------------------------------------------------------------
------------------ CPU Benchmark ---- Dynasty Mode v1.0 -----------------------
-------------------------------------------------------------------------------
------------------ Created by Hamish: 10/08/2018 ------------------------------
------------------ Last Updated: 10/08/2018 by Hamish -------------------------
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
sunit_army1_04 = script_unit:new(army_army1_01, "army1_04");
sunit_army1_05 = script_unit:new(army_army1_01, "army1_05");
sunit_army1_06 = script_unit:new(army_army1_01, "army1_06");


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
sunit_army2_34 = script_unit:new(army_army2_01, "army2_34");
sunit_army2_35 = script_unit:new(army_army2_01, "army2_35");
sunit_army2_36 = script_unit:new(army_army2_01, "army2_36");
----------------------- Archers ----------------------------
--sunit_army2_37 = script_unit:new(army_army2_01, "army2_37");
--sunit_army2_38 = script_unit:new(army_army2_01, "army2_38");
--sunit_army2_39 = script_unit:new(army_army2_01, "army2_39");
--sunit_army2_40 = script_unit:new(army_army2_01, "army2_40");
--sunit_army2_41 = script_unit:new(army_army2_01, "army2_41");
--sunit_army2_42 = script_unit:new(army_army2_01, "army2_42");



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
	sunit_army2_33,
	sunit_army2_34,
	sunit_army2_35,
	sunit_army2_36

);

------------------------------
--          Archers         --
------------------------------

--sunits_army2_archers = script_units:new(
	--"army2_archers",
	--sunit_army2_37,
	--sunit_army2_38,
	--sunit_army2_39,
	--sunit_army2_40,
	--sunit_army2_41,
	--sunit_army2_42
--);


function end_deployment_phase()
	bm:out("Starting benchmark");
	
	if bool_benchmark_mode then
		play_cutscene_intro();
	end;
	
	-- ** Remove comments to Enable Fire Arrows **
	
	--for i = 1, sunits_army2_archers:count() do
		--local current_sunit = sunits_army2_archers:item(i);
		
		--current_sunit.uc:change_shot_type("small_arm_flaming");
		--current_sunit.uc:change_behaviour_active("Fire_at_will", false);
		
	--end;
	
	-- HERO GODMODE ENABLED! --
	
	for i = 1, sunits_army1_all:count() do
		local current_sunit = sunits_army1_all:item(i);
		
		current_sunit.uc:set_invincible(true);
		
	end;
	
	
	---------------------
	--   Enemy Charge  --
	---------------------
	
	---------------------------
	-- Infantry Brace Order  --
	---------------------------
	
	--bm:callback(
		--function()
			
			-- Units Cheer for a glorious battle --
			
			--sunit_army1_01.uc:celebrate();
			--sunit_army1_02.uc:celebrate();
			--sunit_army1_03.uc:celebrate();
			--sunit_army1_04.uc:celebrate();
			--sunit_army1_05.uc:celebrate();
			--sunit_army1_06.uc:celebrate();
			
		--end,
		--0
	--);
	
	
	bm:callback(
		function()
			
			--------------------------
			--- Enemy Charge Order ---
			--------------------------
			
			-- Enemy Charge Guan Yu --
			sunit_army2_02.uc:attack_unit(sunit_army1_01.unit, true, true);			
			sunit_army2_04.uc:attack_unit(sunit_army1_01.unit, true, true);			
			sunit_army2_06.uc:attack_unit(sunit_army1_01.unit, true, true);
			
			
			-- Enemy Charge Ma Chao --
			sunit_army2_09.uc:attack_unit(sunit_army1_02.unit, true, true);			
			sunit_army2_11.uc:attack_unit(sunit_army1_02.unit, true, true);			
			sunit_army2_13.uc:attack_unit(sunit_army1_02.unit, true, true);
			
			
			-- Enemy Charge Lu Bu --
			sunit_army2_16.uc:attack_unit(sunit_army1_03.unit, true, true);			
			sunit_army2_18.uc:attack_unit(sunit_army1_03.unit, true, true);			
			sunit_army2_20.uc:attack_unit(sunit_army1_03.unit, true, true);
			
			
			-- Enemy Charge Zhang Liao --
			sunit_army2_23.uc:attack_unit(sunit_army1_04.unit, true, true);
			sunit_army2_25.uc:attack_unit(sunit_army1_04.unit, true, true);
			sunit_army2_27.uc:attack_unit(sunit_army1_04.unit, true, true);
			
			
			-- Enemy Charge Zhange Fei --
			sunit_army2_30.uc:attack_unit(sunit_army1_05.unit, true, true);
			sunit_army2_32.uc:attack_unit(sunit_army1_05.unit, true, true);
			sunit_army2_34.uc:attack_unit(sunit_army1_05.unit, true, true);
			
			
			-- Enemy Charge Xiahou Dun --
			sunit_army2_07.uc:attack_unit(sunit_army1_01.unit, true, true);
			sunit_army2_21.uc:attack_unit(sunit_army1_03.unit, true, true);
			sunit_army2_35.uc:attack_unit(sunit_army1_05.unit, true, true);
			
			
		end,
		8000
	);
	
	bm:callback(
		function()
		
			--------------------------
			--- Allied Charge Order --
			--------------------------
			
			sunit_army1_01.uc:attack_unit(sunit_army2_02.unit, true, true);
			sunit_army1_02.uc:attack_unit(sunit_army2_09.unit, true, true);
			sunit_army1_03.uc:attack_unit(sunit_army2_16.unit, true, true);
			sunit_army1_04.uc:attack_unit(sunit_army2_23.unit, true, true);
			sunit_army1_05.uc:attack_unit(sunit_army2_30.unit, true, true);
			sunit_army1_06.uc:attack_unit(sunit_army2_07.unit, true, true);

		end,
		29000
	);
	
	bm:callback(
		function()
		
			--------------------------
			---  Enemy Second Wave ---
			--------------------------
			
			-- Guan Yu-- 
			sunit_army2_03.uc:attack_unit(sunit_army1_01.unit, true, true);
			sunit_army2_05.uc:attack_unit(sunit_army1_01.unit, true, true);
			
			-- Ma Chao --
			sunit_army2_10.uc:attack_unit(sunit_army1_02.unit, true, true);
			sunit_army2_12.uc:attack_unit(sunit_army1_02.unit, true, true);
			
			-- Lu Bu --
			sunit_army2_17.uc:attack_unit(sunit_army1_03.unit, true, true);
			sunit_army2_19.uc:attack_unit(sunit_army1_03.unit, true, true);
			
			-- Zhang Liao --
			sunit_army2_24.uc:attack_unit(sunit_army1_04.unit, true, true);
			sunit_army2_26.uc:attack_unit(sunit_army1_04.unit, true, true);
			
			-- Zhange Fei --
			sunit_army2_31.uc:attack_unit(sunit_army1_05.unit, true, true);
			sunit_army2_33.uc:attack_unit(sunit_army1_05.unit, true, true);
			
			-- Xiahou Dun --
			sunit_army2_14.uc:attack_unit(sunit_army1_02.unit, true, true);
			sunit_army2_28.uc:attack_unit(sunit_army1_04.unit, true, true);
			
		end,
		70000
	);
	
	
	--------------------------
	----- Hero Abilities------
	--------------------------
	
	bm:callback(
		function()
			
			-- Guan Yu --
			sunit_army1_01.uc:perform_special_ability("3k_main_ability_god_of_war", sunit_army2_09.unit);
			
			-- Ma Chao --
			sunit_army1_02.uc:perform_special_ability("3k_main_ability_flames_of_the_phoenix", sunit_army2_04.unit);
			
			-- Lu Bu --
			sunit_army1_03.uc:perform_special_ability("3k_main_ability_rage_of_lu_bu", sunit_army2_24.unit);
			
			-- Zhang Liao --
			sunit_army1_04.uc:perform_special_ability("3k_main_ability_adamant_resolve", sunit_army2_17.unit);
			
			-- Zhange Fei --
			sunit_army1_05.uc:perform_special_ability("3k_main_ability_sundering_strike", sunit_army2_31.unit);
			
			-- Xiahou Dun --
			sunit_army1_06.uc:perform_special_ability("3k_main_ability_binding_fury", sunit_army2_13.unit);
			
		end,
		80000
	);
	
	
	--------------------------
	----- Remove Routing -----
	--------------------------
	
	bm:callback(
		function()
			
			--------------------------
			--- Enemy Charge Order ---
			--------------------------
			
			-- Enemy Charge Guan Yu --
			sunit_army2_02.uc:attack_unit(sunit_army1_01.unit, true, true);			
			sunit_army2_04.uc:attack_unit(sunit_army1_01.unit, true, true);			
			sunit_army2_06.uc:attack_unit(sunit_army1_01.unit, true, true);
			sunit_army2_03.uc:attack_unit(sunit_army1_01.unit, true, true);
			sunit_army2_05.uc:attack_unit(sunit_army1_01.unit, true, true);
			
			
			-- Enemy Charge Ma Chao --
			sunit_army2_09.uc:attack_unit(sunit_army1_02.unit, true, true);			
			sunit_army2_11.uc:attack_unit(sunit_army1_02.unit, true, true);			
			sunit_army2_13.uc:attack_unit(sunit_army1_02.unit, true, true);
			sunit_army2_10.uc:attack_unit(sunit_army1_02.unit, true, true);
			sunit_army2_12.uc:attack_unit(sunit_army1_02.unit, true, true)
			
			
			-- Enemy Charge Lu Bu --
			sunit_army2_16.uc:attack_unit(sunit_army1_03.unit, true, true);			
			sunit_army2_18.uc:attack_unit(sunit_army1_03.unit, true, true);			
			sunit_army2_20.uc:attack_unit(sunit_army1_03.unit, true, true);
			sunit_army2_17.uc:attack_unit(sunit_army1_03.unit, true, true);
			sunit_army2_19.uc:attack_unit(sunit_army1_03.unit, true, true);
			
			
			-- Enemy Charge Zhang Liao --
			sunit_army2_23.uc:attack_unit(sunit_army1_04.unit, true, true);
			sunit_army2_25.uc:attack_unit(sunit_army1_04.unit, true, true);
			sunit_army2_27.uc:attack_unit(sunit_army1_04.unit, true, true);
			sunit_army2_24.uc:attack_unit(sunit_army1_04.unit, true, true);
			sunit_army2_26.uc:attack_unit(sunit_army1_04.unit, true, true);
			
			
			-- Enemy Charge Zhange Fei --
			sunit_army2_30.uc:attack_unit(sunit_army1_05.unit, true, true);
			sunit_army2_32.uc:attack_unit(sunit_army1_05.unit, true, true);
			sunit_army2_34.uc:attack_unit(sunit_army1_05.unit, true, true);
			sunit_army2_31.uc:attack_unit(sunit_army1_05.unit, true, true);
			sunit_army2_33.uc:attack_unit(sunit_army1_05.unit, true, true);
			
			
			-- Enemy Charge Xiahou Dun --
			sunit_army2_07.uc:attack_unit(sunit_army1_01.unit, true, true);
			sunit_army2_21.uc:attack_unit(sunit_army1_03.unit, true, true);
			sunit_army2_35.uc:attack_unit(sunit_army1_05.unit, true, true);
			sunit_army2_14.uc:attack_unit(sunit_army1_02.unit, true, true);
			sunit_army2_28.uc:attack_unit(sunit_army1_04.unit, true, true);
			
			
		end,
		110000
	);
	
	bm:callback(
		function()
			
			--------------------------
			--- Enemy Charge Order ---
			--------------------------
			
			-- Enemy Charge Guan Yu --
			sunit_army2_02.uc:attack_unit(sunit_army1_01.unit, true, true);			
			sunit_army2_04.uc:attack_unit(sunit_army1_01.unit, true, true);			
			sunit_army2_06.uc:attack_unit(sunit_army1_01.unit, true, true);
			sunit_army2_03.uc:attack_unit(sunit_army1_01.unit, true, true);
			sunit_army2_05.uc:attack_unit(sunit_army1_01.unit, true, true);
			
			
			-- Enemy Charge Ma Chao --
			sunit_army2_09.uc:attack_unit(sunit_army1_02.unit, true, true);			
			sunit_army2_11.uc:attack_unit(sunit_army1_02.unit, true, true);			
			sunit_army2_13.uc:attack_unit(sunit_army1_02.unit, true, true);
			sunit_army2_10.uc:attack_unit(sunit_army1_02.unit, true, true);
			sunit_army2_12.uc:attack_unit(sunit_army1_02.unit, true, true)
			
			
			-- Enemy Charge Lu Bu --
			sunit_army2_16.uc:attack_unit(sunit_army1_03.unit, true, true);			
			sunit_army2_18.uc:attack_unit(sunit_army1_03.unit, true, true);			
			sunit_army2_20.uc:attack_unit(sunit_army1_03.unit, true, true);
			sunit_army2_17.uc:attack_unit(sunit_army1_03.unit, true, true);
			sunit_army2_19.uc:attack_unit(sunit_army1_03.unit, true, true);
			
			
			-- Enemy Charge Zhang Liao --
			sunit_army2_23.uc:attack_unit(sunit_army1_04.unit, true, true);
			sunit_army2_25.uc:attack_unit(sunit_army1_04.unit, true, true);
			sunit_army2_27.uc:attack_unit(sunit_army1_04.unit, true, true);
			sunit_army2_24.uc:attack_unit(sunit_army1_04.unit, true, true);
			sunit_army2_26.uc:attack_unit(sunit_army1_04.unit, true, true);
			
			
			-- Enemy Charge Zhange Fei --
			sunit_army2_30.uc:attack_unit(sunit_army1_05.unit, true, true);
			sunit_army2_32.uc:attack_unit(sunit_army1_05.unit, true, true);
			sunit_army2_34.uc:attack_unit(sunit_army1_05.unit, true, true);
			sunit_army2_31.uc:attack_unit(sunit_army1_05.unit, true, true);
			sunit_army2_33.uc:attack_unit(sunit_army1_05.unit, true, true);
			
			
			-- Enemy Charge Xiahou Dun --
			sunit_army2_07.uc:attack_unit(sunit_army1_01.unit, true, true);
			sunit_army2_21.uc:attack_unit(sunit_army1_03.unit, true, true);
			sunit_army2_35.uc:attack_unit(sunit_army1_05.unit, true, true);
			sunit_army2_14.uc:attack_unit(sunit_army1_02.unit, true, true);
			sunit_army2_28.uc:attack_unit(sunit_army1_04.unit, true, true);
			
			
		end,
		150000
	);
	
end;


--------------------------------------------------------------
------------------------- cutscene ---------------------------
--------------------------------------------------------------

cutscene_intro = cutscene:new(
	"cutscene_intro", 							-- unique string name for cutscene
	uc_army1_01_all, 								-- unitcontroller over player's army
	190000, 										-- duration of cutscene in ms
	function() bm:end_benchmark() end 			-- what to call when cutscene is finished
);

cam = cutscene_intro:camera();
cutscene_intro:set_skippable(false, nil);
--cutscene_intro:set_debug();

function play_cutscene_intro()
	cutscene_intro:action(function() cam:fade(false, 0.5) end, 0);
	
	-- Camera start and Hero pan -- 
	cutscene_intro:action(function() cam:move_to(v(-87.285263,113.063622,281.748779),v(-96.704872,111.535881,265.273987), 1, true, -1) end, 0);
	cutscene_intro:action(function() cam:move_to(v(-81.559967,113.193245,274.929199),v(-99.757225,110.995995,269.779755), 3, false, 0) end, 3000);
	cutscene_intro:action(function() cam:move_to(v(-84.903183,112.83007,264.338043),v(-97.152748,111.648201,278.86499), 3, false, 0) end, 6000);
	cutscene_intro:action(function() cam:move_to(v(-97.850128,112.226341,264.161377),v(-87.002281,111.988075,279.805969), 3, false, 0) end, 9000);
	
	-- Pan out -- 
	cutscene_intro:action(function() cam:move_to(v(-124.121773,131.009811,272.161591),v(-106.249619,124.623131,273.674774), 12, true, -1) end, 12000);
	cutscene_intro:action(function() cam:move_to(v(-65.323814,143.640167,212.364761),v(-73.254692,136.201508,227.993591), 14, true, 0) end, 50000);
	cutscene_intro:action(function() cam:move_to(v(-15.292207,161.879379,333.358429),v(-28.930281,155.022995,321.979279), 10, false, -1) end, 70000);
	
	-- Fight summary -- 
	cutscene_intro:action(function() cam:move_to(v(-129.496109,121.52684,456.746796),v(-122.700798,118.59008,439.205872), 10, false, -1) end, 90000);
	cutscene_intro:action(function() cam:move_to(v(-209.890244,168.357468,197.585663),v(-195.955307,160.740707,208.087753), 20, true, -1) end, 100000);
	cutscene_intro:action(function() cam:move_to(v(-127.739235,125.517593,257.838806),v(-112.108688,117.672203,265.363434), 25, true, -1) end, 150000);
	
	cutscene_intro:action(function() cam:fade(true, 0.5) end, 190000);
	
	cutscene_intro:start();	
end;
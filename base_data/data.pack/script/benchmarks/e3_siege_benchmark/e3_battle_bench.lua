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


sunit_army1_01 = script_unit:new(army_army1_01, "army1_01");
sunit_army1_02 = script_unit:new(army_army1_01, "army1_02");
sunit_army1_03 = script_unit:new(army_army1_01, "army1_03");
sunit_army1_04 = script_unit:new(army_army1_01, "army1_04");
sunit_army1_05 = script_unit:new(army_army1_01, "army1_05");
sunit_army1_06 = script_unit:new(army_army1_01, "army1_06");
sunit_army1_07 = script_unit:new(army_army1_01, "army1_07");
sunit_army1_08 = script_unit:new(army_army1_01, "army1_08");
sunit_army1_09 = script_unit:new(army_army1_01, "army1_09");
sunit_army1_10 = script_unit:new(army_army1_01, "army1_10");
sunit_army1_11 = script_unit:new(army_army1_01, "army1_11");
sunit_army1_12 = script_unit:new(army_army1_01, "army1_12");
sunit_army1_13 = script_unit:new(army_army1_01, "army1_13");
sunit_army1_14 = script_unit:new(army_army1_01, "army1_14");
sunit_army1_15 = script_unit:new(army_army1_01, "army1_15");
sunit_army1_16 = script_unit:new(army_army1_01, "army1_16");
sunit_army1_17 = script_unit:new(army_army1_01, "army1_17");
sunit_army1_18 = script_unit:new(army_army1_01, "army1_18");
sunit_army1_19 = script_unit:new(army_army1_01, "army1_19");
sunit_army1_20 = script_unit:new(army_army1_01, "army1_20");
sunit_army1_21 = script_unit:new(army_army1_01, "army1_21");


uc_army1_01_all = unitcontroller_from_army(army_army1_01);
uc_army1_01_all:take_control();


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


uc_army2_01_all = unitcontroller_from_army(army_army2_01);
uc_army2_01_all:take_control();


------------------------------
-- Army 1, 2nd regiment --
------------------------------

sunits_archers = script_units:new(
	"archers",
	sunit_army1_16,
	sunit_army1_17,
	sunit_army1_18,
	sunit_army2_14,
	sunit_army2_15,
	sunit_army2_16

);

sunits_army1_movement = script_units:new(
	"army1_01 movement",
	sunit_army1_01
	
);

-------------------------------
--      Infantry Units       --
-------------------------------

sunits_infantry = script_units:new(
	"infantry",
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
	sunit_army1_21,
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
	sunit_army2_18

);




sunits_all = script_units:new(
	"all",
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
	sunit_army1_21,
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
	sunit_army2_18

);



function end_deployment_phase()
	bm:out("Starting benchmark");
	
	if bool_benchmark_mode then
		play_cutscene_intro();
	end;
	
	for i = 1, sunits_all:count() do
		local current_sunit = sunits_all:item(i);
		
		current_sunit.uc:change_behaviour_active("fire_at_will", false);
		current_sunit.uc:change_behaviour_active("skirmish", false);
		
	end;
	
	-- ** Remove comments to Enable Fire Arrows **
	
	--for i = 1, sunits_archers:count() do
		--local current_sunit = sunits_archers:item(i);
		
		--current_sunit.uc:change_shot_type("small_arm_flaming");
		
	--end;
	
	-- Prevents armies from routing --
	
	--for i = 1, sunits_infantry:count() do
		--local current_sunit = sunits_infantry:item(i);
		
		--current_sunit.uc:set_invincible(true);
		
	--end;
	
	------------------------
	--    Battle Phase    --
	------------------------
	bm:callback(
		function()		
		
			-- Allied Charge --
			sunit_army1_09.uc:attack_unit(sunit_army2_07.unit,true, true);
			sunit_army1_10.uc:attack_unit(sunit_army2_06.unit,true, true);
			sunit_army1_11.uc:attack_unit(sunit_army2_05.unit,true, true);
			sunit_army1_12.uc:attack_unit(sunit_army2_04.unit,true, true);
			sunit_army1_13.uc:attack_unit(sunit_army2_03.unit,true, true);
			sunit_army1_14.uc:attack_unit(sunit_army2_02.unit,true, true);
			sunit_army1_19.uc:attack_unit(sunit_army2_07.unit,true, true);
			sunit_army1_20.uc:attack_unit(sunit_army2_06.unit,true, true);
			
			-- Enemy Charge --
			sunit_army2_07.uc:attack_unit(sunit_army1_09.unit,true, true);
			sunit_army2_06.uc:attack_unit(sunit_army1_10.unit,true, true);
			sunit_army2_05.uc:attack_unit(sunit_army1_11.unit,true, true);
			sunit_army2_04.uc:attack_unit(sunit_army1_12.unit,true, true);
			sunit_army2_03.uc:attack_unit(sunit_army1_13.unit,true, true);
			sunit_army2_02.uc:attack_unit(sunit_army1_14.unit,true, true);
			sunit_army2_08.uc:attack_unit(sunit_army1_12.unit,false, false);
			
			-- Allied Artillery --
			sunit_army1_21.uc:attack_unit(sunit_army2_15.unit,true, true);
			
			-- Make Heros invincible to prevent unexpected routing
			sunit_army2_07.uc:set_invincible(true);
			sunit_army1_08.uc:set_invincible(true);
			sunit_army2_13.uc:set_invincible(true);
			sunit_army1_15.uc:set_invincible(true);
			
		end,
		8000
	);	
	
	------------------------
	--    Archers Phase   --
	------------------------
	bm:callback(
		function()		
		
			-- Allied Volley --
			sunit_army1_16.uc:attack_unit(sunit_army2_14.unit,true, true);
			sunit_army1_17.uc:attack_unit(sunit_army2_15.unit,true, true);
			sunit_army1_18.uc:attack_unit(sunit_army2_15.unit,true, true);
			
			
			-- Enemy Volley --
			sunit_army2_14.uc:attack_unit(sunit_army1_16.unit,true, true);
			sunit_army2_15.uc:attack_unit(sunit_army1_18.unit,true, true);
			sunit_army2_16.uc:attack_unit(sunit_army1_20.unit,true, true);

		end,
		8500
	);	
	
	------------------------
	--     First Phase    --
	------------------------
	bm:callback(
		function()		
		
			-- Allied Charge --
			sunit_army1_02.uc:attack_unit(sunit_army2_11.unit,true, true);
			sunit_army1_08.uc:attack_unit(sunit_army2_11.unit,true, true);
			sunit_army1_04.uc:attack_unit(sunit_army2_08.unit,true, true);

		end,
		30010
	);	
	
	------------------------
	--    Second Phase    --
	------------------------
	bm:callback(
		function()		
		
			-- Allied Charge --
			sunit_army1_06.uc:attack_unit(sunit_army2_18.unit,true, true);
			sunit_army1_03.uc:attack_unit(sunit_army2_10.unit,true, true);
			
			-- Enemy Charge --
			sunit_army2_18.uc:attack_unit(sunit_army1_03.unit,true, true);
			sunit_army2_10.uc:attack_unit(sunit_army1_06.unit,true, true);

		end,
		35000
	);	
	
	------------------------
	--     Third Phase    --
	------------------------
	bm:callback(
		function()		
		
			-- Allied Charge --
			sunit_army1_07.uc:attack_unit(sunit_army2_17.unit,true, true);

		end,
		56000
	);	
	
	------------------------
	--    Fourth Phase    --
	------------------------
	bm:callback(
		function()		
		
			-- Allied Charge --
			--sunit_army1_05.uc:attack_unit(sunit_army2_13.unit,true, true);
			
			-- Enemy Charge --
			sunit_army2_12.uc:attack_unit(sunit_army1_05.unit,true, true);
			

		end,
		68000
	);
	
	------------------------
	--        DUEL        --
	------------------------
	bm:callback(
		function()		
		
			-- Allied Charge --
			sunit_army1_01.uc:attack_unit(sunit_army2_01.unit,true, true);
			
			-- Enemy Charge --
			sunit_army2_01.uc:attack_unit(sunit_army1_01.unit,true, true);
			
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
	99000, 										-- duration of cutscene in ms
	function() bm:end_benchmark() end 			-- what to call when cutscene is finished
);

cam = cutscene_intro:camera();
cutscene_intro:set_skippable(false, nil);
--cutscene_intro:set_debug();

function play_cutscene_intro()
	cutscene_intro:action(function() cam:fade(false, 0.5) end, 0);
	
	-- Intro scene
	cutscene_intro:action(function() cam:move_to(v(-5.125882,195.453186,-525.495728),v(769.536377,130.969284,-1127.334839), 0, true, -1) end, 0);
	cutscene_intro:action(function() cam:move_to(v(-3.761871,195.538437,-531.362915),v(344.748016,110.820099,383.974365), 4, true, -1) end, 2000);
	
	-- Main battle Charge
	cutscene_intro:action(function() cam:move_to(v(-31.374802,203.525055,-502.733795),v(799.685364,-121.302277,-90.054138), 6, true, -1) end, 13000);
	cutscene_intro:action(function() cam:move_to(v(-26.265751,211.141785,-398.039825),v(672.253601,-119.651764,209.519684), 3, true, -1) end, 25000);

	-- Phase one 
	cutscene_intro:action(function() cam:move_to(v(-167.888657,206.699631,-316.171356),v(0.674866,-262.766296,530.973755), 6, false, -1) end, 30000);
	--cutscene_intro:action(function() cam:move_to(v(-165.164017,206.060989,-318.700317),v(-640.061096,-153.631058,463.33252), 6, false, -1) end, 30000);
	cutscene_intro:action(function() cam:move_to(v(-197.310089,201.085617,-302.877167),v(491.893646,-176.424454,287.856537), 6, true, -1) end, 36000);
	
	-- Phase Two
	cutscene_intro:action(function() cam:move_to(v(-232.716583,224.166656,-160.744705),v(-932.11084,-293.303619,297.026367), 6, false, -1) end, 42000);
	cutscene_intro:action(function() cam:move_to(v(-377.398987,204.480423,-37.516819),v(288.75177,-273.561157,504.875092), 3, true, -1) end, 50000);
	--cutscene_intro:action(function() cam:move_to(v(-374.432678,202.409119,-81.14061),v(396.610901,-148.233063,417.885193), 3, true, -1) end, 50000);
	
	-- Phase Three
	cutscene_intro:action(function() cam:move_to(v(-207.21022,201.494141,-7.213121),v(690.716003,-44.770798,308.332275), 6, true, -1) end, 56000);
	cutscene_intro:action(function() cam:move_to(v(-180.259918,213.533691,-24.14081),v(14.002655,-166.099518,861.650024), 6, true, -1) end, 62000);
	
	-- Phase Four
	cutscene_intro:action(function() cam:move_to(v(-17.719954,207.242371,-24.300014),v(840.13678,-73.043365,-414.183502), 6, true, -1) end, 68000);
	cutscene_intro:action(function() cam:move_to(v(-3.242511,205.438293,-15.87556),v(169.596786,-36.59082,-952.912964), 6, true, -1) end, 74000);
	
	-- Ultimate Duel
	cutscene_intro:action(function() cam:move_to(v(-4.055923,203.257706,-15.607509),v(355.921112,155.698853,897.979553), 3, true, -1) end, 80000);
	cutscene_intro:action(function() cam:move_to(v(-143.788467,282.765198,-227.024521),v(269.886841,33.910599,629.38031), 6, true, -1) end, 90000);
	
	cutscene_intro:action(function() cam:fade(true, 0.5) end, 98000);
	
	cutscene_intro:start();	
end;
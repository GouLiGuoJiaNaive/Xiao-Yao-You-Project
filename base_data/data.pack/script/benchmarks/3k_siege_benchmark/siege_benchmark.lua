-- Lua version=3.0 --

-------------------------------------------------------------------------------
------------------ Siege Benchmark ---- Youbeiping 2.0 -------------------------
-------------------------------------------------------------------------------
------------------ Author: Hamish Goodall -------------------------------------
------------------ Last Updated: 26/02/2019 -----------------------------------
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
army_army2_01 = alliance_army1:armies():item(2);

alliance_army2 = alliances:item(2); 
army_army3_01 = alliance_army2:armies():item(1);

----------------
--- Army One ---
----------------

-------------------- Lei Bei's Army ------------------------
sunit_army1_01 = script_unit:new(army_army1_01, "army1_01");
sunit_army1_02 = script_unit:new(army_army1_01, "army1_02");
sunit_army1_03 = script_unit:new(army_army1_01, "army1_03");
sunit_army1_04 = script_unit:new(army_army1_01, "army1_04");
sunit_army1_05 = script_unit:new(army_army1_01, "army1_05");
sunit_army1_06 = script_unit:new(army_army1_01, "army1_06");
sunit_army1_07 = script_unit:new(army_army1_01, "army1_07");
------------------- Zhang Fei's Army -------------------------
sunit_army1_08 = script_unit:new(army_army1_01, "army1_08");
sunit_army1_09 = script_unit:new(army_army1_01, "army1_09");
sunit_army1_10 = script_unit:new(army_army1_01, "army1_10");
sunit_army1_11 = script_unit:new(army_army1_01, "army1_11");
sunit_army1_12 = script_unit:new(army_army1_01, "army1_12");
sunit_army1_13 = script_unit:new(army_army1_01, "army1_13");
sunit_army1_14 = script_unit:new(army_army1_01, "army1_14");
------------------- Guan Yu's Army -------------------------
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

-------------------- Sun Jian's Army ------------------------
sunit_army2_01 = script_unit:new(army_army2_01, "army2_01");
sunit_army2_02 = script_unit:new(army_army2_01, "army2_02");
sunit_army2_03 = script_unit:new(army_army2_01, "army2_03");
sunit_army2_04 = script_unit:new(army_army2_01, "army2_04");
sunit_army2_05 = script_unit:new(army_army2_01, "army2_05");
sunit_army2_06 = script_unit:new(army_army2_01, "army2_06");
sunit_army2_07 = script_unit:new(army_army2_01, "army2_07");
-------------------- Sun Ce's Army ----------------------
sunit_army2_08 = script_unit:new(army_army2_01, "army2_08");
sunit_army2_09 = script_unit:new(army_army2_01, "army2_09");
sunit_army2_10 = script_unit:new(army_army2_01, "army2_10");
sunit_army2_11 = script_unit:new(army_army2_01, "army2_11");
sunit_army2_12 = script_unit:new(army_army2_01, "army2_12");
sunit_army2_13 = script_unit:new(army_army2_01, "army2_13");
sunit_army2_14 = script_unit:new(army_army2_01, "army2_14");
------------------ Huang Zhong's Army ----------------------
sunit_army2_15 = script_unit:new(army_army2_01, "army2_15");
sunit_army2_16 = script_unit:new(army_army2_01, "army2_16");
sunit_army2_17 = script_unit:new(army_army2_01, "army2_17");
sunit_army2_18 = script_unit:new(army_army2_01, "army2_18");
sunit_army2_19 = script_unit:new(army_army2_01, "army2_19");
sunit_army2_20 = script_unit:new(army_army2_01, "army2_20");
sunit_army2_21 = script_unit:new(army_army2_01, "army2_21");

uc_army2_01_all = unitcontroller_from_army(army_army2_01);
uc_army2_01_all:take_control();

------------------
--- Army Three ---
------------------

-------------------- Cao Cao's Army ------------------------
sunit_army3_01 = script_unit:new(army_army3_01, "army3_01");
sunit_army3_02 = script_unit:new(army_army3_01, "army3_02");
sunit_army3_03 = script_unit:new(army_army3_01, "army3_03");
sunit_army3_04 = script_unit:new(army_army3_01, "army3_04");
sunit_army3_05 = script_unit:new(army_army3_01, "army3_05");
sunit_army3_06 = script_unit:new(army_army3_01, "army3_06");
sunit_army3_07 = script_unit:new(army_army3_01, "army3_07");
-------------------- Xiahou Yuan's Army ----------------------
sunit_army3_08 = script_unit:new(army_army3_01, "army3_08");
sunit_army3_09 = script_unit:new(army_army3_01, "army3_09");
sunit_army3_10 = script_unit:new(army_army3_01, "army3_10");
sunit_army3_11 = script_unit:new(army_army3_01, "army3_11");
sunit_army3_12 = script_unit:new(army_army3_01, "army3_12");
sunit_army3_13 = script_unit:new(army_army3_01, "army3_13");
sunit_army3_14 = script_unit:new(army_army3_01, "army3_14");
------------------- Xiahou Dun's Army ---------------------
sunit_army3_15 = script_unit:new(army_army3_01, "army3_15");
sunit_army3_16 = script_unit:new(army_army3_01, "army3_16");
sunit_army3_17 = script_unit:new(army_army3_01, "army3_17");
sunit_army3_18 = script_unit:new(army_army3_01, "army3_18");
sunit_army3_19 = script_unit:new(army_army3_01, "army3_19");
sunit_army3_20 = script_unit:new(army_army3_01, "army3_20");
sunit_army3_21 = script_unit:new(army_army3_01, "army3_21");

uc_army3_01_all = unitcontroller_from_army(army_army3_01);
uc_army3_01_all:take_control();

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
	sunit_army1_05,
	sunit_army1_06,
	sunit_army1_07,
	sunit_army2_09,
	sunit_army2_10,
	sunit_army3_06,
	sunit_army3_07,
	sunit_army3_09,
	sunit_army3_10
);

-------------------------------
--		Heavy Spear Inf      --
-------------------------------
sunits_spears = script_units:new(
	"spears",
	sunit_army1_09,
	sunit_army1_10,
	sunit_army1_11
);

-------------------------------
--		Heavy Pike Inf       --
-------------------------------
sunits_pikes = script_units:new(
	"pikes",
	sunit_army3_11,
	sunit_army3_19,
	sunit_army3_21,
	sunit_army3_13,
	sunit_army3_14
);

-------------------------------
--    Sword + shield Inf     --
-------------------------------
sunits_swords = script_units:new(
	"swords",
	sunit_army3_04,
	sunit_army3_05
);



function end_deployment_phase()
	bm:out("Starting benchmark");
	
	if bool_benchmark_mode then
		play_cutscene_intro();
	end;
	
	for i = 1, sunits_archers:count() do
		local current_sunit = sunits_archers:item(i);
		
		current_sunit.uc:change_behaviour_active("Skirmish", false);
		current_sunit.uc:change_behaviour_active("Fire_at_will", false);
		
	end;
	
	sunit_army1_01.uc:set_invincible(true);
	sunit_army2_01.uc:set_invincible(true);
	sunit_army3_01.uc:set_invincible(true);
	sunit_army3_16.uc:set_invincible(true);
	sunit_army3_17.uc:set_invincible(true);
	sunit_army3_18.uc:set_invincible(true);
	sunit_army1_09.uc:set_invincible(true);
	sunit_army1_10.uc:set_invincible(true);
	sunit_army1_11.uc:set_invincible(true);
	
	
	---------------------------
	-- Infantry Charge  --
	---------------------------
	
	bm:callback(
		function()
		
			-- Set army formations --
			for i = 1, sunits_spears:count() do
				local current_sunit = sunits_spears:item(i);
				
				current_sunit.uc:perform_special_ability("3k_main_formation_turtle", current_sunit.unit);
				
			end;
			
			for i = 1, sunits_pikes:count() do
				local current_sunit = sunits_pikes:item(i);
				
				current_sunit.uc:perform_special_ability("3k_main_formation_pike_wall", current_sunit.unit);
				
			end;
			
			for i = 1, sunits_swords:count() do
				local current_sunit = sunits_swords:item(i);
				
				current_sunit.uc:perform_special_ability("3k_main_formation_shield_wall", current_sunit.unit);
				
			end;	
			
			----------------------------------------------------------------
			----------------------------------------------------------------
		
			-- Enemy Army full Charge --
			sunit_army3_16.uc:attack_unit(sunit_army1_09.unit, true, true);
			sunit_army3_18.uc:attack_unit(sunit_army1_10.unit, true, true);
			sunit_army3_17.uc:attack_unit(sunit_army1_11.unit, true, true);
			
			-- Ally army full charge --
			--sunit_army1_09.uc:attack_unit(sunit_army3_16.unit, true, true);
			--sunit_army1_10.uc:attack_unit(sunit_army3_18.unit, true, true);
			--sunit_army1_11.uc:attack_unit(sunit_army3_17.unit, true, true);
			
			-- Set archers to attack spear units --
			sunit_army1_05.uc:attack_unit(sunit_army3_16.unit, true, true);
			sunit_army1_06.uc:attack_unit(sunit_army3_18.unit, true, true);
			sunit_army1_07.uc:attack_unit(sunit_army3_17.unit, true, true);
			sunit_army2_09.uc:attack_unit(sunit_army3_02.unit, true, true);
			sunit_army2_10.uc:attack_unit(sunit_army3_03.unit, true, true);
			
			-- Set trebuchet attack --
			sunit_army2_19.uc:attack_unit(sunit_army3_05.unit, true, true);
			sunit_army2_17.uc:attack_unit(sunit_army3_04.unit, true, true);
			sunit_army2_16.uc:attack_unit(sunit_army3_13.unit, true, true);
			sunit_army2_18.uc:attack_unit(sunit_army3_21.unit, true, true);

		end,
		0
	
	);
	
	---------------------------------
	--    Enemy Secondary Charge   --
	---------------------------------	
	bm:callback(
		function()
			
			-- Enemy frontal Cav charge --
			sunit_army3_02.uc:attack_unit(sunit_army2_09.unit, true, true);
			sunit_army3_03.uc:attack_unit(sunit_army2_10.unit, true, true);
			sunit_army3_15.uc:attack_unit(sunit_army2_01.unit, true, true);			

		end,
		10000
	
	);	
	
	---------------------------------
	--      Allies Climb Walls     --
	---------------------------------
	
	bm:callback(
		function()
			
			-- DEBUG - PROBABLY BROKEN --
			sunit_army2_03.uc:attack_unit(sunit_army3_13.unit, true, true);
			sunit_army2_02.uc:attack_unit(sunit_army3_14.unit, true, true);
			
			---------------------------------
			--      Gyan Yu Charge Cav     --
			---------------------------------
			
			-- Allies Cav --
			sunit_army1_15.uc:attack_unit(sunit_army3_13.unit, true, true);
			sunit_army1_08.uc:attack_unit(sunit_army3_08.unit, true, true);
			sunit_army1_02.uc:attack_unit(sunit_army3_13.unit, true, true);
			sunit_army1_04.uc:attack_unit(sunit_army3_08.unit, true, true);
			sunit_army1_03.uc:attack_unit(sunit_army3_14.unit, true, true);

		end,
		20000
	);
	
	---------------------------------
	--      Sun Ce Cav Charge      --
	---------------------------------
	
	bm:callback(
		function()
			
			sunit_army2_11.uc:attack_unit(sunit_army3_11.unit, true, true);
			sunit_army2_12.uc:attack_unit(sunit_army3_11.unit, true, true);
			sunit_army2_13.uc:attack_unit(sunit_army3_12.unit, true, true);
			sunit_army2_14.uc:attack_unit(sunit_army3_12.unit, true, true);
			sunit_army2_08.uc:attack_unit(sunit_army3_12.unit, true, true);
			
		end,
		50000
	
	);
	
	--------------------------
	--     Bridge Inf att   --
	--------------------------
	
	bm:callback(
		function()
		
			sunit_army1_13.uc:attack_unit(sunit_army3_11.unit, true, true);
			sunit_army2_07.uc:attack_unit(sunit_army3_11.unit, true, true);
			sunit_army2_06.uc:attack_unit(sunit_army3_12.unit, true, true);
			sunit_army2_05.uc:attack_unit(sunit_army3_12.unit, true, true);
			sunit_army1_18.uc:attack_unit(sunit_army3_11.unit, true, true);
			sunit_army1_16.uc:attack_unit(sunit_army3_12.unit, true, true);
			
			-- Gate pikement counter attack --
			sunit_army3_20.uc:attack_unit(sunit_army2_04.unit, true, true);
			
		end,
		51000
	);
	
	--------------------------
	--    Sword Melee att   --
	--------------------------
	
	bm:callback(
		function()
		
			sunit_army2_04.uc:attack_unit(sunit_army3_05.unit, true, true);
			sunit_army1_12.uc:attack_unit(sunit_army3_05.unit, true, true);
			sunit_army1_17.uc:attack_unit(sunit_army3_04.unit, true, true);
			sunit_army1_14.uc:attack_unit(sunit_army3_04.unit, true, true);
			
		end,
		85000
	);
	
	
	--------------------------
	--     Elite Inf att    --
	--------------------------
	
	bm:callback(
		function()
		
			sunit_army2_15.uc:attack_unit(sunit_army3_01.unit, true, true);
			sunit_army2_21.uc:attack_unit(sunit_army3_19.unit, true, true);
			sunit_army2_20.uc:attack_unit(sunit_army3_21.unit, true, true);
			sunit_army1_21.uc:attack_unit(sunit_army3_06.unit, true, true);
			sunit_army1_20.uc:attack_unit(sunit_army3_07.unit, true, true);
			sunit_army1_19.uc:attack_unit(sunit_army3_01.unit, true, true);
			
		end,
		90000
	);
	
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
	cutscene_intro:action(function() cam:move_to(v(793.090698,186.122406,-298.931396),v(631.185547,103.544327,-122.631958), 0, true, -1) end, 0);
	cutscene_intro:action(function() cam:move_to(v(633.402893,114.362473,-16.755054),v(451.482422,33.952148,139.523239), 7, true, 0) end, 5000);
	cutscene_intro:action(function() cam:move_to(v(645.132019,113.351799,71.067314),v(415.538635,8.620064,29.100819), 7, true, 0) end, 13000);
	
	-- players right side pan & preparing for inf wall climb -- 
	cutscene_intro:action(function() cam:move_to(v(414.995667,126.651062,174.724731),v(185.978577,9.499535,170.839447), 9, false, -1) end, 21000);

	-- Guan yu cav charge -- 
	cutscene_intro:action(function() cam:move_to(v(276.279602,102.689919,129.652542),v(155.368805,32.817268,339.05719), 10, true, 0) end, 26000);
	cutscene_intro:action(function() cam:move_to(v(217.878143,97.856285,146.018204),v(411.845398,3.866875,281.450104), 10, true, -1) end, 42000);
	
	-- Sun ce Cav Charge --
	cutscene_intro:action(function() cam:move_to(v(-322.328552,134.424911,-45.956818),v(-180.286758,13.515541,131.861099), 5, true, -1) end, 55000);
	cutscene_intro:action(function() cam:move_to(v(-322.328552,134.424911,-45.956818),v(-100.790817,1.535332,-65.815224), 8, true, -1) end, 63000);
	
	-- Regular units attack elite --
	cutscene_intro:action(function() cam:move_to(v(-38.234104,134.424896,-212.067108),v(113.052567,-26.480682,-70.519592), 6, true, -1) end, 73000);
	cutscene_intro:action(function() cam:move_to(v(55.238892,116.335831,-202.073639),v(-121.973831,-18.204506,-68.932663), 6, true, -1) end, 80000);
	
	-- Regular units attack elite GATE --
	cutscene_intro:action(function() cam:move_to(v(161.907455,121.150902,-30.032049),v(348.125885,17.259758,111.115059), 6, true, -1) end, 85000);
	cutscene_intro:action(function() cam:move_to(v(256.061646,105.769867,-5.569464),v(225.867828,-13.843056,220.522644), 6, true, -1) end, 95000);
	
	-- Huang Zhong attacks Cao Cao --
	cutscene_intro:action(function() cam:move_to(v(170.664246,100.189171,-114.256027),v(273.519531,8.972679,-328.10965), 6, true, -1) end, 100000);
	cutscene_intro:action(function() cam:move_to(v(171.278351,104.122574,-230.539474),v(342.552368,-14.502907,-79.308502), 6, true, -1) end, 110000);
	cutscene_intro:action(function() cam:move_to(v(36.433533,180.785385,-579.471436),v(118.595146,93.0345,-355.921539), 6, true, -1) end, 115000);
	
	cutscene_intro:action(function() cam:fade(true, 0.5) end, 120000);
	
	cutscene_intro:start();	
end;
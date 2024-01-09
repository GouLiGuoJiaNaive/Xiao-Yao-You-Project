-------------------------------------------------------------------------------------------------------------------------
---------------------------------------------- Three Kingdoms UB - Setup Armies  ---------------------------------------------
------------------------------------------------- Hugh McLaughlin / Nov 2018 -------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------
-- Will store a list of unit vs unit matchups in Unit_Matchup_Controllers based on each matchup having a unique retinue id for the two involved units 

--------------------------------------------------
---------------- Army Declarations ---------------
--------------------------------------------------

Alliances = bm:alliances()

Alliance_01 = Alliances:item(1)
Armies_01 = Alliance_01:armies()

Army_01 = Armies_01:item(1)
Units_01 = Army_01:units()

Alliance_02 = Alliances:item(2)
Armies_02 = Alliance_02:armies()

Army_02 = Armies_02:item(1)
Units_02 = Army_02:units()


--------------------------------------------------
-- Declare Units and Individual UnitControllers --
--------------------------------------------------

--All Units
SUnit_01_All = unitcontroller_from_army(Army_01)
SUnit_01_All:take_control()

--All Units
SUnit_02_All = unitcontroller_from_army(Army_02)
SUnit_02_All:take_control()

Alliance_01_Rout_Position = Alliance_01:rout_position()
Alliance_02_Rout_Position = Alliance_02:rout_position()

Unit_Matchup_Controllers = {} --Vector of pairs  [ (1)[uc1, uc2], (2)[uc3, uc4], ...]
Num_Matchups = 0

function create_unit_matchup_controllers()
	bm:out("---------------------------------")
	bm:out("create_unit_matchup_controllers")
	bm:out("---------------------------------")
	
	num_units_1 = Units_01:count()
	num_units_2 = Units_02:count()
	
	num_matchups = num_units_1
	
	if (num_units_1 ~= num_units_2) then
		bm:out("FATAL ERROR, both sides should have the same number of units, Tests will be invalid. Army1: " ..num_units_1.. ", Army2: " .. num_units_2)
	end
	
	for i = 1,num_units_1,1 
	do 
		unit_1 = Units_01:item(i)
		bm:out(unit_1:name() .. "RetinueId: " .. unit_1:retinue_id())
		Unit1Controller = script_unit:new(Army_01, unit_1:name())
	   
		for j = 1,num_units_2,1 
		do 
			unit_2 = Units_02:item(j)
			if (unit_2:retinue_id() == unit_1:retinue_id()) then 
			   Unit2Controller = script_unit:new(Army_02, unit_2:name())
			   bm:out(unit_2:name() .. "RetinueId: " .. unit_2:retinue_id())
			   Unit1Controller:cache_health()
			   Unit2Controller:cache_health()
			   Unit_Matchup_Controllers[i] = { Unit1Controller, Unit2Controller }
			end
		end 
	end
end 


create_unit_matchup_controllers()

--------------------------------------------------
----------------- Loop Check Time ----------------
--------------------------------------------------

battle_count_end = 600
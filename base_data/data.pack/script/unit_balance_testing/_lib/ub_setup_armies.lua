-------------------------------------------------------------------------------------------------------------------------
---------------------------------------------- Warhammer UB - Setup Armies  ---------------------------------------------
------------------------------------------------- Ewan Stone / Oct 2015 -------------------------------------------------
--------------------------------------------------- Chris Reed / 2015 ---------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------


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
--First Army
SUnit_01_01 = script_unit:new(Army_01, "Test_01")

--All Units
SUnit_01_All = unitcontroller_from_army(Army_01)
SUnit_01_All:take_control()

--Second Army
SUnit_02_01 = script_unit:new(Army_02, "Test_02")

--All Units
SUnit_02_All = unitcontroller_from_army(Army_02)
SUnit_02_All:take_control()


--------------------------------------------------
----------------- Loop Check Time ----------------
--------------------------------------------------

battle_count_end = 600
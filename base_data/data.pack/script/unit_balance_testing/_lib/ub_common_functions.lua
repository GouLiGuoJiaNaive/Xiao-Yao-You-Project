-------------------------------------------------------------------------------------------------------------------------
-------------------------------------------- Warhammer UB - Common Functions  -------------------------------------------
------------------------------------------------- Ewan Stone / Oct 2015 -------------------------------------------------
--------------------------------------------------- Chris Reed / 2015 ---------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------


--------------------------------------------------
---------------- Starting Functions --------------
--------------------------------------------------

function determine_unit_type()		-- Sets unit state to 1 by default
	bm:out("SUnit_01_01")
	SUnit_01_01_state = 1
	bm:out("Unit: " .. SUnit_01_01.unit:type())
	bm:out("Class: " .. SUnit_01_01.unit:unit_class())
	bm:out("Starting Ammo: " .. SUnit_01_01.unit:starting_ammo())
	SUnit_01_01.uc:set_invincible(false)
	--SUnit_01_01.uc:rotate(180)
	SUnit_01_01.uc:change_fatigue_amount(2)
	--SUnit_01_01.uc:morale_behavior_rout()
	
	bm:out("---------------------------------")
	bm:out("SUnit_02_01")
	SUnit_02_01_state = 1
	bm:out("Unit: " .. SUnit_02_01.unit:type())
	bm:out("Class: " .. SUnit_02_01.unit:unit_class())
	bm:out("Starting Ammo: " .. SUnit_02_01.unit:starting_ammo())
	SUnit_02_01.uc:set_invincible(false)
	--SUnit_02_01.uc:rotate(180)
	SUnit_02_01.uc:change_fatigue_amount(2)
	--SUnit_02_01.uc:morale_behavior_rout()
end

--------------------------------------------------
-------------- End Battle Functions --------------
--------------------------------------------------

function start_battle_timer()			-- begins a 10 minute countdown and can be reset with battle engagements
	battle_count = 0
	bm:out("Countdown Started: 10 minutes remaining")
	-- watching for when the units are shattered/dead/routing or if it is over the battle_count_end amount (found in ub_setup_armies) to stop the timer
	bm:watch(
		function() return (is_shattered_or_dead(SUnit_01_01) or is_shattered_or_dead(SUnit_02_01) or battle_count >= battle_count_end) end, 0, function() stop_battle_timer() end, "stop_battle_timer"
	)
	-- battle_count timer is reset when combat is initiated
	bm:watch(
		function() return (SUnit_01_01:has_taken_casualties() or SUnit_02_01:has_taken_casualties() or SUnit_01_01.unit:is_under_missile_attack() or SUnit_02_01.unit:is_under_missile_attack() or SUnit_01_01.unit:is_in_melee() or SUnit_02_01.unit:is_in_melee()) end, 0, function() reset_battle_timer() end, "reset_battle_timer"
	)
	-- watching for when the units engage in melee to force them into it if they are ranged units
	--bm:watch(
	--	function() return (SUnit_01_01.unit:is_in_melee() or SUnit_02_01.unit:is_in_melee()) end, 4000, function() enter_melee() end, "enter_melee"
	--)
		--table.insert(watches_table, "enter_melee")
	bm:callback(function() battle_timer_loop() end, 1000)
end

function battle_timer_loop()
	battle_count = battle_count + 1
	bm:callback(function() battle_timer_loop() end, 1000)
end

function reset_battle_timer()
	battle_count = 0
	bm:out("Countdown Reset: 10 minutes remaining")
	bm:out("Combat has been initiated")
end

function stop_battle_timer()		-- stops the battle if the victory conditions are met
	if (battle_count >= battle_count_end) then
		bm:out("Countdown Timer over 600, units killed and test ended.")
		SUnit_01_01.uc:kill()
		SUnit_02_01.uc:kill()
	end

	bm:clear_watches_and_callbacks()
	bm:end_battle()
	
	if (SUnit_01_01.unit:is_routing() == true or SUnit_02_01.unit:is_routing() == true) then
		if (SUnit_01_01.unit:is_routing() == true and SUnit_02_01.unit:is_routing() == true) then
			SUnit_01_01.uc:kill()
			SUnit_02_01.uc:kill()
		else
			if (SUnit_01_01.unit:is_routing() == true) then
				SUnit_02_01.uc:attack_unit(SUnit_01_01.unit, true, true)
			else
				if (SUnit_02_01.unit:is_routing() == true) then
					SUnit_01_01.uc:attack_unit(SUnit_02_01.unit, true, true)
				end
			end
		end
	end
	
	bm:watch(
		function() return (SUnit_01_01.unit:is_routing() == true or SUnit_02_01.unit:is_routing() == true) end, 1000, function() routing_check() end, "routing_check"		-- watching for the same as above if they are both routing just to be safe
	)
end

function battle_ending()		-- Causes battle to end early if conditions were met
	bm:out("---------------------------------")
	bm:out("Battle Ending")
	bm:out("---------------------------------")
	bm:out("Unit 1 Killed: " .. SUnit_01_01.unit:number_of_enemies_killed())
	bm:out("Unit 2 Killed: " .. SUnit_02_01.unit:number_of_enemies_killed())
	
	
	
	bm:watch(
		function() return (SUnit_01_01.unit:is_routing() == true or SUnit_02_01.unit:is_routing() == true) end, 1000, function() routing_check() end, "routing_check"
	)
end

function routing_check()		-- If the units are stuck routing, lets stop that by killing them or making them kill eachother.
	bm:out("Units now have 300 seconds left to damage each other")
	routing_timer = 0
	bm:callback(function() routing_ending() end, 0)
end

function routing_ending()
	if (SUnit_01_01.unit:is_routing() == true or SUnit_02_01.unit:is_routing() == true) then
		if (SUnit_01_01.unit:is_routing() == true and SUnit_02_01.unit:is_routing() == true) then
			SUnit_01_01.uc:kill()
			SUnit_02_01.uc:kill()
		else
			if (SUnit_01_01.unit:is_routing() == true) then
				SUnit_02_01.uc:attack_unit(SUnit_01_01.unit, true, true)
			else
				if (SUnit_02_01.unit:is_routing() == true) then
					SUnit_01_01.uc:attack_unit(SUnit_02_01.unit, true, true)
				end
			end
		end
	end
	
	if (routing_timer >= 300) then
		SUnit_01_01.uc:kill()
		SUnit_02_01.uc:kill()
	else
		routing_timer = routing_timer + 1
		bm:callback(function() routing_ending() end, 1000)
	end
end

--------------------------------------------------
---------------- Action Functions ----------------
--------------------------------------------------

function enter_melee()		-- Forces units into melee stance if engaged in melee so they fight properly
	
	for i = 1, #watches_table do
		bm:remove_process(watches_table[i])
	end
	
	for i = 1, #callback_table do
		bm:remove_process(callback_table[i])
	end

	SUnit_01_01.uc:melee(true)
	SUnit_01_01.uc:attack_unit(SUnit_02_01.unit, true, true)
	SUnit_01_01_state = 0
	bm:out("SUnit_01_01 In Melee")
	SUnit_02_01.uc:melee(true)
	SUnit_02_01.uc:attack_unit(SUnit_01_01.unit, true, true)
	SUnit_02_01_state = 0
	bm:out("SUnit_02_01 In Melee")
	bm:callback(function() attack_loop() end, 4000)
end

function unit_1_attack()
	bm:out("SUnit_01_01 Attack")
	SUnit_01_01.uc:attack_unit(SUnit_02_01.unit, true, true)
end

function unit_2_attack()
	bm:out("SUnit_02_01 Attack")
	SUnit_02_01.uc:attack_unit(SUnit_01_01.unit, true, true)
end

function unit_1_alt_attack()
	bm:out("SUnit_01_01 Alt Attack")
	SUnit_01_01.uc:attack_unit_q(SUnit_02_01.unit, false, true)
end

function unit_2_alt_attack()
	bm:out("SUnit_02_01 Alt Attack")
	SUnit_02_01.uc:attack_unit_q(SUnit_01_01.unit, false, true)
end

function unit_1_abandon_engine()
	bm:out("SUnit_01_01 Abandon and attack")
	SUnit_01_01.uc:change_behaviour_active("defend", true)
	--SUnit_01_01.uc:melee(true) -- Melee stance makes artillery units abandon their engine
	SUnit_01_01.uc:attack_unit(SUnit_02_01.unit, true, true)
	bm:callback(function() SUnit_01_01.uc:attack_unit(SUnit_02_01.unit, true, true) end, 4000)
end

function unit_2_abandon_engine()
	bm:out("SUnit_02_01 Abandon and attack")
	SUnit_02_01.uc:change_behaviour_active("defend", true)
	--SUnit_02_01.uc:melee(true) -- Melee stance makes artillery units abandon their engine
	SUnit_02_01.uc:attack_unit(SUnit_01_01.unit, true, true)
	bm:callback(function() SUnit_02_01.uc:attack_unit(SUnit_01_01.unit, true, true) end, 4000)
end	

function unit_1_skirmish()
	bm:out("SUnit_01_01 Skirmish")
	SUnit_01_01.uc:melee(true)
	SUnit_01_01.uc:attack_unit(SUnit_02_01.unit, true, true)
	bm:callback(function() SUnit_01_01.uc:attack_unit(SUnit_02_01.unit, true, true) end, 4000)
end

function unit_2_skirmish()
	bm:out("SUnit_02_01 Skirmish")
	SUnit_02_01.uc:melee(true)	
	SUnit_02_01.uc:attack_unit(SUnit_01_01.unit, true, true)
	bm:callback(function() SUnit_02_01.uc:attack_unit(SUnit_01_01.unit, true, true) end, 4000)
end

--NOT USED
function unit_1_rotate()
	--bm:out("SUnit_01_01 Rotating")
	SUnit_01_01.uc:rotate(180, true)
	--bm:callback(function() unit_1_attack() end, 0, "unit_1_attack")
		--table.insert(callback_table, "unit_1_attack")
end

function unit_2_rotate_attack_cav()
	bm:out("SUnit_02_01 Rotating")
	SUnit_02_01.uc:rotate(180, true)
	bm:callback(function() unit_2_attack() end, 0, "unit_2_attack")
		table.insert(callback_table, "unit_2_attack")
end

--------------------------------------------------
------------ Looping Attack Functions ------------
--------------------------------------------------

function attack_loop()
	bm:out("In attack loop")
	unit_1_attack()
	unit_2_attack()
	bm:callback(function() attack_loop() end, 10000)
end

--IT WORKS--------------------------------------------
function unit_1_attack_or_retreat_cav()
	bm:callback(function() unit_1_attack() end, 0, "unit_1_attack")
	bm:callback(function() unit_1_ranged_attack_cav() end, 1000, "unit_1_ranged_attack_cav")
end

function unit_1_ranged_attack_cav()

	--bm:callback(function() unit_1_attack() end, 5000, "unit_1_attack")
	
	bm:watch(
		function() return (distance_between_forces(Army_01, Army_02) < (SUnit_01_01.unit:missile_range()-5)) end, 0, function() unit_1_retreat_cav() end, "unit_1_retreat_cav"
	)
		table.insert(watches_table, "unit_1_retreat_cav")
end

function unit_1_retreat_cav()
	bm:out("SUnit_01_01 Retreat")
	bm:remove_process("unit_1_retreat_cav")
	SUnit_01_01:goto_location_offset(0, -(SUnit_01_01.unit:missile_range()), true)	-- run this unit backward 100m
	bm:callback(function() unit_1_ranged_attack_cav() end, 10000, "unit_1_ranged_attack_cav")
		table.insert(callback_table, "unit_1_ranged_attack_cav")
end
--IT WORKS--------------------------------------------
function unit_1_attack_or_retreat_inf()
	bm:callback(function() unit_1_attack() end, 0, "unit_1_attack")
	bm:callback(function() unit_1_ranged_attack_inf() end, 1000, "unit_1_ranged_attack_inf")
end

function unit_1_ranged_attack_inf()
	bm:watch(
		function() return (distance_between_forces(Army_01, Army_02) < (SUnit_01_01.unit:missile_range()-10)) end, 0, function() unit_1_retreat_inf() end, "unit_1_retreat_inf"
	)
		table.insert(watches_table, "unit_1_retreat_inf")
	
	bm:watch(
		function() return (SUnit_01_01.unit:is_in_melee()) end, 0, function() unit_1_inf_melee() end, "unit_1_inf_melee"
	)
		table.insert(watches_table, "unit_1_inf_melee")
end

function unit_1_retreat_inf()
	bm:out("SUnit_01_01 Inf Retreat")
	bm:remove_process("unit_1_retreat_cav")
	SUnit_01_01:goto_location_offset(0, -(SUnit_01_01.unit:missile_range()*2), true)	-- run this unit backward 100m
	bm:callback(function() unit_1_attack() end, 8000, "unit_1_attack")
		table.insert(callback_table, "unit_1_attack")
end

function unit_1_inf_melee()
	SUnit_01_01.uc:melee(true)
	SUnit_01_01.uc:attack_unit(SUnit_02_01.unit, true, true)
end
--IT WORKS--------------------------------------------

--IT WORKS--------------------------------------------
function unit_2_attack_or_retreat_cav()
	bm:callback(function() unit_2_attack() end, 0, "unit_2_attack")
	bm:callback(function() unit_2_ranged_attack_cav() end, 1000, "unit_2_ranged_attack_cav")
end

function unit_2_ranged_attack_cav()
	bm:watch(
	function() return (distance_between_forces(Army_01, Army_02) < (SUnit_02_01.unit:missile_range()-5)) end, 1000, function() unit_2_retreat_cav() end, "unit_2_retreat_cav"
	)
		table.insert(watches_table, "unit_2_retreat_cav")
end

function unit_2_retreat_cav()
	bm:out("SUnit_02_01 Retreat")
	bm:remove_process("unit_2_retreat_cav")
	SUnit_02_01:goto_location_offset(0, -(SUnit_02_01.unit:missile_range()), true)	-- run this unit backward its missile range length
	bm:callback(function() unit_2_ranged_attack_cav() end, 10000, "unit_2_ranged_attack_cav")
		table.insert(callback_table, "unit_2_ranged_attack_cav")
end
--IT WORKS--------------------------------------------
function unit_2_attack_or_retreat_inf()
	bm:callback(function() unit_2_attack() end, 0, "unit_2_attack")
	bm:callback(function() unit_2_ranged_attack_inf() end, 1000, "unit_2_ranged_attack_inf")
end

function unit_2_ranged_attack_inf()
	bm:watch(
		function() return (distance_between_forces(Army_01, Army_02) < (SUnit_02_01.unit:missile_range()-10)) end, 0, function() unit_2_retreat_inf() end, "unit_2_retreat_inf"
	)
		table.insert(watches_table, "unit_2_retreat_inf")
	
		bm:watch(
		function() return (SUnit_02_01.unit:is_in_melee()) end, 0, function() unit_2_inf_melee() end, "unit_2_inf_melee"
	)
		table.insert(watches_table, "unit_2_inf_melee")	
end

function unit_2_retreat_inf()
	bm:out("SUnit_02_01 Inf Retreat")
	bm:remove_process("unit_2_retreat_cav")
	SUnit_02_01:goto_location_offset(0, -(SUnit_02_01.unit:missile_range()*2), true)	-- run this unit backward 100m
	bm:callback(function() unit_2_attack() end, 8000, "unit_2_attack")
		table.insert(callback_table, "unit_2_attack")
end

function unit_2_inf_melee()
	SUnit_02_01.uc:melee(true)
	SUnit_02_01.uc:attack_unit(SUnit_01_01.unit, true, true)
end
--IT WORKS--------------------------------------------
function unit_1_inf_attack()
	if (distance_between_forces(Army_01, Army_02) < 20) then
		bm:remove_process("unit_1_inf_move")
		bm:remove_process("unit_1_inf_attack")
		unit_1_attack()
	else
		bm:callback(function() unit_1_inf_move() end, 10000, "unit_1_inf_move")
	end
end

function unit_1_inf_move()
	SUnit_01_01:goto_location_offset(0, distance_between_forces(Army_01, Army_02), true)
	bm:callback(function() unit_1_inf_attack() end, 30000)
		table.insert(callback_table, "unit_1_inf_attack")
end

function unit_2_inf_attack()
	if (distance_between_forces(Army_01, Army_02) < 20) then
		bm:remove_process("unit_2_inf_move")
		bm:remove_process("unit_2_inf_attack")
		unit_2_attack()
	else
		bm:callback(function() unit_2_inf_move() end, 10000, "unit_2_inf_move")
	end
end

function unit_2_inf_move()
	SUnit_02_01:goto_location_offset(0, distance_between_forces(Army_01, Army_02), true)
	bm:callback(function() unit_2_inf_attack() end, 30000)
		table.insert(callback_table, "unit_2_inf_attack")
end

function unit_1_missle_attack_loop()
	unit_1_attack()
	bm:callback(function() unit_1_missle_attack_loop() end, 5000, "unit_1_missle_attack_loop")
		table.insert(callback_table, "unit_1_missle_attack_loop")
end

function unit_2_missle_attack_loop()
	unit_2_attack()
	bm:callback(function() unit_2_missle_attack_loop() end, 5000, "unit_2_missle_attack_loop")
		table.insert(callback_table, "unit_2_missle_attack_loop")
end
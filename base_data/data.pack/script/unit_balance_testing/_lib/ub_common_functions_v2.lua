------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------- Three Kingdoms UB - Setup Armies  ---------------------------------------------
------------------------------------------------ Hugh McLaughlin / Nov 2018 --------------------------------------------------
----------------------------------------- Based on original by Ewan Stone / Oct 2015 -----------------------------------------
------------------------------------------------------------------------------------------------------------------------------


--------------------------------------------------
---------------- Starting Functions --------------
--------------------------------------------------

function determine_unit_type()

	for i = 1,num_matchups,1 
	do 
		local SUnit_01_01 = Unit_Matchup_Controllers[i][1]
		local SUnit_02_01 = Unit_Matchup_Controllers[i][2]
		
		bm:out("--------------------------------- Matchup: " .. i)
		bm:out(SUnit_01_01.unit:name())
		bm:out("Unit: " .. SUnit_01_01.unit:type())
		bm:out("Class: " .. SUnit_01_01.unit:unit_class())
		bm:out("Starting Ammo: " .. SUnit_01_01.unit:starting_ammo())
		SUnit_01_01.uc:set_invincible(false)
		SUnit_01_01.uc:change_fatigue_amount(2)
		
		bm:out("---------------------------------")
		bm:out(SUnit_02_01.unit:name())
		bm:out("Unit: " .. SUnit_02_01.unit:type())
		bm:out("Class: " .. SUnit_02_01.unit:unit_class())
		bm:out("Starting Ammo: " .. SUnit_02_01.unit:starting_ammo())
		SUnit_02_01.uc:set_invincible(false)
		SUnit_02_01.uc:change_fatigue_amount(2)
	end
end

function teleport_and_rout_unit(SUnit)
		local rout_position = (SUnit.unit:alliance_index() == 1) and Alliance_01_Rout_Position or Alliance_02_Rout_Position
		local is_unit_1_routing = SUnit.unit:is_routing()
		
		bm:out("Teleporting and routing unit : " .. SUnit.unit:name() .. " to pos: " .. rout_position:get_x() .. "," .. rout_position:get_z())
	
		SUnit.uc:set_invincible(true)
		if (is_unit_1_routing == true) then 
			SUnit.uc:morale_behavior_rally() --Wont teleport while routing so rally then rout after
		end
		
		--These calls are staggered to allow states to resolve
		--Trigger the teleport after 1/2 second
		bm:callback(function() SUnit.uc:teleport_to_location(v(rout_position:get_x(), rout_position:get_z()), SUnit.unit:bearing(), SUnit.unit:ordered_width()) end, 500, "teleport_and_rout_unit_teleport_callback")
			table.insert(callback_table, "teleport_and_rout_unit_teleport_callback")
			
		--Trigger rout after 1 second
		bm:callback(function() SUnit.uc:morale_behavior_rout() end, 1000, "teleport_and_rout_unit_rout_callback")
			table.insert(callback_table, "teleport_and_rout_unit_rout_callback")
end 

function has_remaining_ammo(SUnit)
	--bm:out("Checking ammo remaining for unit : " .. SUnit.unit:name() .. ", Ammo: " .. SUnit.unit:ammo_left())
	
	return SUnit.unit:ammo_left() > 0
end

function check_for_no_remaining_ammo_loop(SUnit)
	local ammo_remaining = has_remaining_ammo(SUnit)
	
	if (ammo_remaining == false) then 
		teleport_and_rout_unit(SUnit)
	else 
		bm:callback(function() check_for_no_remaining_ammo_loop(SUnit) end, 1000, "check_for_no_remaining_ammo_loop")
			table.insert(callback_table, "check_for_no_remaining_ammo_loop")
	end 
end

--Each unit will be teleported to their alliances rout position and made invincible before routing
function end_unit_matchup(SUnit1, SUnit2)
	bm:out("ending unit matchup " .. SUnit1.unit:name() .. " vs " .. SUnit2.unit:name())
	teleport_and_rout_unit(SUnit1)
	teleport_and_rout_unit(SUnit2)
end 

function watch_unit_vs_unit_matchup_loop(SUnit1, SUnit2)
	--bm:out("watch_unit_vs_unit_matchup_loop " .. SUnit1.unit:name() .. " vs " .. SUnit2.unit:name())
	
	local is_unit_1_routing = SUnit1.unit:is_routing()
	local is_unit_2_routing = SUnit2.unit:is_routing()
	
	local is_unit_1_dead = SUnit1.unit:number_of_men_alive() == 0
	local is_unit_2_dead = SUnit2.unit:number_of_men_alive() == 0
	
	--bm:out("watch_unit_vs_unit_matchup_loop: " .. SUnit1.unit:name() .. " routing: " .. tostring(is_unit_1_routing) .. " dead: " .. tostring(is_unit_1_dead))
	--bm:out("watch_unit_vs_unit_matchup_loop: " .. SUnit2.unit:name() .. " routing: " .. tostring(is_unit_2_routing) .. " dead: " .. tostring(is_unit_2_dead))
	
	if (is_unit_1_routing == true or is_unit_2_routing == true or is_unit_1_dead == true or is_unit_2_dead == true) then 
		end_unit_matchup(SUnit1, SUnit2)
	else 
		bm:callback(function() watch_unit_vs_unit_matchup_loop(SUnit1, SUnit2) end, 2000, "watch_unit_vs_unit_matchup_loop")
			table.insert(callback_table, "watch_unit_vs_unit_matchup_loop")
	end 
end

--------------------------------------------------
-------------- End Battle Functions --------------
--------------------------------------------------

function start_battle_timer()			-- begins a 10 minute countdown and can be reset with battle engagements
	battle_count = 0
	bm:out("Countdown Started: 10 minutes remaining")
	-- watching for when the units are shattered/dead/routing or if it is over the battle_count_end amount (found in ub_setup_armies) to stop the timer
	-- bm:watch(
		-- function() return (is_shattered_or_dead(SUnit_01_01) or is_shattered_or_dead(SUnit_02_01) or battle_count >= battle_count_end) end, 0, function() stop_battle_timer() end, "stop_battle_timer"
	-- )
	-- battle_count timer is reset when combat is initiated
	-- bm:watch(
		-- function() return (SUnit_01_01:has_taken_casualties() or SUnit_02_01:has_taken_casualties() or SUnit_01_01.unit:is_under_missile_attack() or SUnit_02_01.unit:is_under_missile_attack() or SUnit_01_01.unit:is_in_melee() or SUnit_02_01.unit:is_in_melee()) end, 0, function() reset_battle_timer() end, "reset_battle_timer"
	-- )

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

function battle_ending()		-- Causes battle to end early if conditions were met
	bm:out("---------------------------------")
	bm:out("Battle Ending")
	bm:out("---------------------------------")
	
	for i = 1,num_matchups,1 
	do 
		local SUnit_01_01 = Unit_Matchup_Controllers[i][1]
		local SUnit_02_01 = Unit_Matchup_Controllers[i][2]
		bm:out("Unit: " .. SUnit_01_01.unit:name() .. " Killed: " .. SUnit_01_01.unit:number_of_enemies_killed())
		bm:out("Unit: " .. SUnit_02_01.unit:name() .. " Killed: " .. SUnit_02_01.unit:number_of_enemies_killed())
	end
end


--------------------------------------------------
---------------- Action Functions ----------------
--------------------------------------------------

function unit_attack(SUnit1, SUnit2)
	--bm:out(SUnit1.unit:name() .. " attacks " .. SUnit2.unit:name())
	SUnit1.uc:attack_unit(SUnit2.unit, true, true)
end

function unit_attack_loop(SUnit1, SUnit2)
	unit_attack(SUnit1, SUnit2)
	
	if SUnit2.unit:is_in_melee() and SUnit1.unit:is_charging() == false then --We only retaliate attack if were not being charged and are in melee 
		--bm:out("Defending unit is in melee, issuing attack response - " ..  SUnit2.unit:name())
		unit_attack(SUnit2, SUnit1)
	end
	
	bm:callback(function() unit_attack_loop(SUnit1, SUnit2) end, 1000, "unit_attack_loop")
		table.insert(callback_table, "unit_attack_loop")
end

function unit_missle_attack_loop(SUnit1, SUnit2)
	unit_attack(SUnit1, SUnit2)
	bm:callback(function() unit_missle_attack_loop(SUnit1, SUnit2) end, 1000, "unit_missle_attack_loop")
		table.insert(callback_table, "unit_missle_attack_loop")
end

function unit_skirmish(SUnit1, SUnit2)
	--bm:out(SUnit1.unit:name() .. " skirmish vs " .. SUnit2.unit:name())
	SUnit1.uc:melee(true)
	SUnit1.uc:attack_unit(SUnit2.unit, true, true)
	bm:callback(function() SUnit1.uc:attack_unit(SUnit2.unit, true, true) end, 4000)
end

--DUELS

function unit_duel_accept(SUnit)
	bm:out(SUnit.unit:name() .. " calling accept ability")
	SUnit.uc:perform_special_ability("3k_main_hero_duel_ability_accept")
end

function unit_duel_propose(SUnit1, SUnit2)
	--Issue a propose ability
	SUnit1.uc:perform_special_ability("3k_main_hero_duel_ability_propose", SUnit2.unit)
end 

function unit_matchup_can_duel(SUnit1, SUnit2)
	return SUnit1.unit:can_duel() and SUnit2.unit:can_duel()
end
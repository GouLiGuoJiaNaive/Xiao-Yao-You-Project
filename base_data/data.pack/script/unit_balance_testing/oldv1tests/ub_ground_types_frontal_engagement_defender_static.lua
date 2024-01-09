-------------------------------------------------------------------------------------------------------------------------
-------------------------------------------- Warhammer UB - Frontal Engagement ------------------------------------------
------------------------------------------------- Ewan Stone / Oct 2015 -------------------------------------------------
--------------------------------------------------- Chris Reed / 2015 ---------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------

print("Here we go again!")

-- load the script libraries
load_script_libraries()

-- declare battlemanager object
bm = battle_manager:new(empire_battle:new())

package.path = package.path .. ";TestData/UnitTesting/?.lua" .. ";data/script/unit_balance_testing/_lib/?.lua"

-- get battle name from folder, and print header
battle_name = "Frontal"
battle_shorthand = "UB"

require ("ub_setup_armies")
require ("ub_common_functions")

bm:out("==============================")
bm:out("Script started: " .. battle_name .. " Engagement")
bm:out("==============================")

-- subtitles/camera object
subtitles = bm:subtitles()
subtitles:clear()
cam = bm:camera()

------ Tables ------
watches_table = {}
callback_table = {}

-- If true, ranged units will rout when their ammo has been depleted
ROUT_WHEN_RANGED_AMMO_DEPLETED = true

--------------------------------------------------
------------------ Start Script ------------------
--------------------------------------------------

bm:setup_battle(function() deployment_phase() end)
bm:setup_victory_callback(function() battle_ending() end)

function deployment_phase()
	bm:out("---------------------------------")
	bm:out("Beginning of deployment_phase")
	bm:out("---------------------------------")
		--set_deployment_strip()
	determine_unit_type()
		-- bm:out(bm:get_map_param()) --get_map_param would need to be integrated from Arena
	SUnit_01_01:cache_health()
	SUnit_02_01:cache_health()
	bm:out("---------------------------------")
	bm:out(battle_name .. " Engagement Started")
	bm:out("---------------------------------")
	battle_count = 0
	cam:fade(false, 0)
	bm:change_victory_countdown_limit(0)
	start_battle_timer()	
	bm:callback(function() engagement_behaviour() end, 0, "engagement_behaviour")
end

--------------------------------------------------
-------------- Engagement Behaviour --------------
--------------------------------------------------

function engagement_behaviour()
------ Unit 1 ------
	if (SUnit_01_01.unit:unit_class() == "inf_mis" or SUnit_01_01.unit:unit_class() == "cav_mis") then
		if(SUnit_02_01.unit:unit_class() == "inf_mis" or SUnit_02_01.unit:unit_class() == "cav_mis") then		-- if a missile unit fighting against missile unit then just attack them and dont run off
			bm:callback(function() unit_1_missle_attack_loop() end, 4000, "unit_1_missle_attack_loop")
				table.insert(callback_table, "unit_1_missle_attack_loop")
		elseif (SUnit_02_01.unit:unit_class() == "com") then
			if (SUnit_01_01.unit:unit_class() == "cav_mis") then		-- if its a cav missle unit, then attempt to retreat using the unit_1_attack_or_retreat_cav callback
				bm:callback(function() unit_1_attack_or_retreat_cav() end, 4000, "unit_1_attack_or_retreat_cav")
					table.insert(callback_table, "unit_1_attack_or_retreat_cav")
			elseif (SUnit_01_01.unit:unit_class() == "inf_mis") then		-- if its a inf missle unit, then attempt to retreat using the unit_1_attack_or_retreat_inf callback
				bm:callback(function() unit_1_attack_or_retreat_inf() end, 4000, "unit_1_attack_or_retreat_inf")
					table.insert(callback_table, "unit_1_attack_or_retreat_inf")
			end	
		elseif (SUnit_02_01.unit:unit_class() == "spcl") then
			if (SUnit_01_01.unit:unit_class() == "cav_mis") then		-- if its a cav missle unit, then attempt to retreat using the unit_1_attack_or_retreat_cav callback
				bm:callback(function() unit_1_attack_or_retreat_cav() end, 4000, "unit_1_attack_or_retreat_cav")
					table.insert(callback_table, "unit_1_attack_or_retreat_cav")
			elseif (SUnit_01_01.unit:unit_class() == "inf_mis") then		-- if its a inf missle unit, then attempt to retreat using the unit_1_attack_or_retreat_inf callback
				bm:callback(function() unit_1_attack_or_retreat_inf() end, 4000, "unit_1_attack_or_retreat_inf")
					table.insert(callback_table, "unit_1_attack_or_retreat_inf")
			end	
		elseif (SUnit_02_01.unit:unit_class() == "chariot" or SUnit_02_01.unit:unit_class() == "art_fld") then
			bm:callback(function() unit_1_attack() end, 4000, "unit_1_attack")
				table.insert(callback_table, "unit_1_attack")
			if (SUnit_02_01.unit:unit_class() == "chariot" and SUnit_02_01.unit:ammo_left() < 1) then
				if (SUnit_01_01.unit:unit_class() == "cav_mis") then		-- if its a cav missle unit, then attempt to retreat using the unit_1_attack_or_retreat_cav callback
					bm:callback(function() unit_1_attack_or_retreat_cav() end, 4000, "unit_1_attack_or_retreat_cav")
					table.insert(callback_table, "unit_1_attack_or_retreat_cav")
				elseif (SUnit_01_01.unit:unit_class() == "inf_mis") then		-- if its a inf missle unit, then attempt to retreat using the unit_1_attack_or_retreat_inf callback
					bm:callback(function() unit_1_attack_or_retreat_inf() end, 4000, "unit_1_attack_or_retreat_inf")
						table.insert(callback_table, "unit_1_attack_or_retreat_inf")
				end
			end			
		elseif (SUnit_01_01.unit:unit_class() == "cav_mis") then		-- if its a cav missle unit, then attempt to retreat using the unit_1_attack_or_retreat_cav callback
			bm:callback(function() unit_1_attack_or_retreat_cav() end, 4000, "unit_1_attack_or_retreat_cav")
				table.insert(callback_table, "unit_1_attack_or_retreat_cav")
		elseif (SUnit_01_01.unit:unit_class() == "inf_mis") then		-- if its a inf missle unit, then attempt to retreat using the unit_1_attack_or_retreat_inf callback
			bm:callback(function() unit_1_attack_or_retreat_inf() end, 4000, "unit_1_attack_or_retreat_inf")
				table.insert(callback_table, "unit_1_attack_or_retreat_inf")
		end
		bm:watch(
			function() return (SUnit_01_01.unit:ammo_left() < 1) end, 0, function() unit_1_skirmish() end, "unit_1_skirmish"		-- if a missle unit runs out of ammo, it will enter melee
		)
			table.insert(watches_table, "unit_1_skirmish")
	elseif (SUnit_01_01.unit:unit_class() == "art_fld") then		-- artillery doesn't really work, need to investigate why they rout if they enter melee
		bm:callback(function() unit_1_attack() end, 4000, "unit_1_attack")
			table.insert(callback_table, "unit_1_attack")
		bm:watch(
			function() return (distance_between_forces(Army_01, Army_02) < 20) end, 0, function() unit_1_abandon_engine() end, "unit_1_abandon_engine"
		)
			table.insert(watches_table, "unit_1_abandon_engine")
		if (SUnit_02_01.unit:unit_class() == "inf_mis" or SUnit_02_01.unit:unit_class() == "cav_mis") then
			bm:watch(
				function() return (SUnit_01_01:has_taken_casualties() or SUnit_01_01.unit:is_under_missile_attack()) end, 0, function() unit_1_abandon_engine() end, "unit_1_abandon_engine"
			)
				table.insert(watches_table, "unit_1_abandon_engine")
		end
	elseif (SUnit_02_01.unit:is_currently_flying() == true) then --SUnit_02_01.unit:can_fly()
		if (SUnit_01_01.unit:is_currently_flying() == true and SUnit_02_01.unit:is_currently_flying() == true) then
			bm:callback(function() unit_1_attack() end, 2000, "unit_1_attack")
				table.insert(callback_table, "unit_1_attack")
		elseif (SUnit_01_01.unit:unit_class() == "chariot") then
			bm:callback(function() unit_1_attack() end, 2000, "unit_1_attack")
				table.insert(callback_table, "unit_1_attack")
		else
			bm:callback(function() unit_1_inf_attack() end, 2000, "unit_1_inf_attack")
				table.insert(callback_table, "unit_1_inf_attack")
		end
	elseif (SUnit_01_01.unit:unit_class() == "com") then --Heroes can be both ranged and melee
		if(SUnit_01_01.unit:ammo_left() > 0) then
			bm:callback(function() unit_1_missle_attack_loop() end, 4000, "unit_1_missle_attack_loop")
				table.insert(callback_table, "unit_1_missle_attack_loop")
		else 
			bm:callback(function() unit_1_attack() end, 2000, "unit_1_attack")
				table.insert(callback_table, "unit_1_attack")
		end
	else
		bm:callback(function() unit_1_attack() end, 2000, "unit_1_attack")
			table.insert(callback_table, "unit_1_attack")
	end

	if(ROUT_WHEN_RANGED_AMMO_DEPLETED == true and SUnit_01_01.unit:ammo_left() > 0) then
		bm:out("Adding rout when ammo depleted listener")
		bm:watch(function() return (SUnit_01_01.unit:ammo_left() < 1) end, 0, function() SUnit_01_01.uc:morale_behavior_rout() end, "morale_behavior_rout")
	end
	
------ Unit 2 ------
	--Unit 2 should remain static and able to fire at will --
end
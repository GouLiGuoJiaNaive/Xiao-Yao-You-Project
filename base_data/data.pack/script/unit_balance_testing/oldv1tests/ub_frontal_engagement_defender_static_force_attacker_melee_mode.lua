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

	bm:callback(function() unit_1_attack() end, 2000, "unit_1_attack")
			table.insert(callback_table, "unit_1_attack")
			
	bm:callback(function() unit_1_skirmish() end, 1, "unit_1_skirmish")
			table.insert(callback_table, 1, "unit_1_skirmish")
			
------ Unit 2 ------
	--Unit 2 should remain static and able to fire at will --
end
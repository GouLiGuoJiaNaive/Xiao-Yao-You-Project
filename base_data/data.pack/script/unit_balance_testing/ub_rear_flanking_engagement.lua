-------------------------------------------------------------------------------------------------------------------------
-------------------------------------------- Warhammer UB - Rear Flanking Engagement ------------------------------------
------------------------------------------------- Hugh McLaughlin / Nov 2018 --------------------------------------------
-------------------------------------------------------------------------------------------------------------------------

print("Here we go again!")

-- load the script libraries
load_script_libraries()

-- declare battlemanager object
bm = battle_manager:new(empire_battle:new())

package.path = package.path .. ";TestData/UnitTesting/?.lua" .. ";data/script/unit_balance_testing/_lib/?.lua"

-- get battle name from folder, and print header
battle_name = "Rear Flanking"
battle_shorthand = "UB"

require ("ub_setup_armies_v2")
require ("ub_common_functions_v2")

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
	determine_unit_type()
	bm:out("---------------------------------")
	bm:out(battle_name .. " Engagement Started")
	bm:out("---------------------------------")
	battle_count = 0
	cam:fade(false, 0)
	bm:change_victory_countdown_limit(0)
	start_battle_timer()	
	setup_orientations()
	bm:callback(function() engagement_behaviour() end, 0, "engagement_behaviour")
end

--------------------------------------------------
-------------- Engagement Behaviour --------------
--------------------------------------------------

function setup_orientations()
for i = 1,num_matchups,1 
	do 
		local SUnit_01_01 = Unit_Matchup_Controllers[i][1]
		local SUnit_02_01 = Unit_Matchup_Controllers[i][2]

		------ Unit 1 ------
		--Flanked, should do nothing until attacked, turn to face the same direction as the unit 2
		SUnit_01_01.uc:teleport_to_location(SUnit_01_01.unit:position(), SUnit_02_01.unit:bearing(), SUnit_01_01.unit:ordered_width())
	end
end 

function engagement_behaviour()
for i = 1,num_matchups,1 
	do 
		local SUnit_01_01 = Unit_Matchup_Controllers[i][1]
		local SUnit_02_01 = Unit_Matchup_Controllers[i][2]
		
		bm:out(SUnit_02_01.unit:name() .. " flanking " .. SUnit_01_01.unit:name())

		------ Unit 2 ------
		--Unit 2 do a default attack 
		unit_attack_loop(SUnit_02_01, SUnit_01_01)
	
		--We Add a watch to teleport the completed matchup when finished 
		watch_unit_vs_unit_matchup_loop(SUnit_01_01, SUnit_02_01)
	
	end
end
------------------------------------------------------------------------------------------------------------------------------
-------------------------------------- Three Kingdoms UB - Frontal Engagement (Def Static)  ----------------------------------
------------------------------------------------ Hugh McLaughlin / Nov 2018 --------------------------------------------------
----------------------------------------- Based on original by Ewan Stone / Oct 2015 -----------------------------------------
------------------------------------------------------------------------------------------------------------------------------

print("Here we go again!")

-- load the script libraries
load_script_libraries()

-- declare battlemanager object
bm = battle_manager:new(empire_battle:new())

package.path = package.path .. ";TestData/UnitTesting/?.lua" .. ";data/script/unit_balance_testing/_lib/?.lua"

-- get battle name from folder, and print header
battle_name = "Frontal"
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

-- If true, ranged units will rout when their ammo has been depleted
ROUT_WHEN_RANGED_AMMO_DEPLETED = true

--------------------------------------------------
------------------ Start Script ------------------
--------------------------------------------------

bm:setup_battle(function() deployment_phase() end)
bm:setup_victory_callback(function() battle_ending() end)

function deployment_phase()
	bm:out("---------------------------------")
	bm:out("Beginning of deployment_phase V2")
	bm:out("---------------------------------")
		--set_deployment_strip()
	determine_unit_type()
		-- bm:out(bm:get_map_param()) --get_map_param would need to be integrated from Arena
	--SUnit_01_01:cache_health()
	--SUnit_02_01:cache_health()
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

	for i = 1,num_matchups,1 
	do 
		local SUnit_01_01 = Unit_Matchup_Controllers[i][1]
		local SUnit_02_01 = Unit_Matchup_Controllers[i][2]
		
		bm:out(SUnit_01_01.unit:name() .. " vs " .. SUnit_02_01.unit:name())
		
		------ Unit 1 ------
		if (SUnit_01_01.unit:unit_class() == "com") then --Heroes can be both ranged and melee
			if(SUnit_01_01.unit:ammo_left() > 0) then
				SUnit_01_01.uc:melee(false)
				bm:out("Commander Attacking Ranged case: " .. SUnit_01_01.unit:name() .. " attacks " .. SUnit_02_01.unit:name())
				unit_missle_attack_loop(SUnit_01_01, SUnit_02_01)
			else 
				SUnit_01_01.uc:melee(true)
				bm:out("Commander Attacking Melee case: " .. SUnit_01_01.unit:name() .. " attacks " .. SUnit_02_01.unit:name())
				unit_attack_loop(SUnit_01_01, SUnit_02_01)
			end
		else
			--bm:out("Default attack case: " .. SUnit_01_01.unit:name() .. " attacks " .. SUnit_02_01.unit:name())
			unit_attack_loop(SUnit_01_01, SUnit_02_01)
		end

		if(ROUT_WHEN_RANGED_AMMO_DEPLETED == true and SUnit_01_01.unit:ammo_left() > 0) then
			check_for_no_remaining_ammo_loop(SUnit_01_01)
		end
		
		
	------ Unit 2 ------
		--Unit 2 should remain static and able to fire at will --
		
	
		--We Add a watch to teleport the completed matchup when finished 
		watch_unit_vs_unit_matchup_loop(SUnit_01_01, SUnit_02_01)
	
	end
end
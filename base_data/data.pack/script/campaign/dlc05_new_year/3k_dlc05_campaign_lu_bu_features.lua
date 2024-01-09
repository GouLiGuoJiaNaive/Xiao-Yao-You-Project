---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------
----- Name:			3k_campaign_ancillaries.lua
----- Description: 	Three Kingdoms system to spawn an ancillary on a character when they spawn.
----- 				This script rewards/removes pooled resources from the Lu Bu faction depending on the faction leader's performance in battle.
----- 				It also governs the 'movement reset' he gains upon performing the 'enslave' post-battle option
---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------

cm:add_first_tick_callback(function() lu_bu_features:initialise() end); --Self register function



--------------------------------------------------------------------------
----------------------VARIABLES AND SETUP---------------------------------
--------------------------------------------------------------------------

lu_bu_features = {}

function lu_bu_features:initialise()
  self:add_listeners()
end
--------------------------------------------------------------------------
----------------------LISTENERS-------------------------------------------
--------------------------------------------------------------------------

function lu_bu_features:add_listeners()
  
  output("lu_bu_features:add_listeners()");
  
------------------------ 
---Post-battle effects---
-------------------------
	core:add_listener(
        "CharacterPostBattleEnslaveLuBu",
        "CharacterPostBattleEnslave",
		function(context)
			return context:query_character():faction():name() == "3k_main_faction_lu_bu"
		end,
    function(context)
        context:modify_character():replenish_action_points()
		end,
    true
	);
  
  --------------------------------
  ---pooled resource generation---
  --------------------------------
	core:add_listener(
		"BattleLoggedLuBu",
		"CampaignBattleLoggedEvent",
		function (context)
			--checks for the leader of the lu bu faction in both the winning and losing parties.
			for i=0, context:log_entry():winning_characters():num_items()-1 do
				if(context:log_entry():winning_characters():item_at(i):character():faction():name() == "3k_main_faction_lu_bu" and context:log_entry():winning_characters():item_at(i):character():is_faction_leader()) then
					return true	
				end
			end

			for i=0, context:log_entry():losing_characters():num_items()-1 do
				if(context:log_entry():losing_characters():item_at(i):character():faction():name() == "3k_main_faction_lu_bu" and context:log_entry():losing_characters():item_at(i):character():is_faction_leader()) then
					return true	
				end
			end

			if context:log_entry():winner_result() == "draw" or context:log_entry():loser_result() == "draw" then
				return true
			end

		end,
		function (context)
			local LuBuWon = false
			
			--checks if lu bu's faction is among the winning factions, in case of draw, skips this part
			if (context:log_entry():winner_result() == "draw" and context:log_entry():loser_result() == "draw") == false then
				for i = 0, context:log_entry():winning_factions():num_items()-1 do
					if context:log_entry():winning_factions():item_at(i):name() == "3k_main_faction_lu_bu" then
						LuBuWon = true
					end
				end
			end

			--adds a point per character defeated
			if LuBuWon then 
				self:lu_bu_generate_pooled_resource("3k_dlc05_pooled_factor_momentum_battles_won", self:count_characters_in_battle(context:log_entry(), LuBuWon), true)
				self:lu_bu_generate_pooled_resource("3k_dlc05_pooled_factor_personal_victories_characters_defeated", self:count_characters_in_battle(context:log_entry(), LuBuWon), false)
			end

		end,
		true
	)

----------------------------------------------------
-------trigger dilemma when faction leader dies-----
----------------------------------------------------

	core:add_listener(
        "CharacterBecomesFactionLeaderLuBuFaction",
        "CharacterBecomesFactionLeader",
		function(context)
			return context:query_character():faction():name() == "3k_main_faction_lu_bu" and context:query_character():faction():is_human()
		end,
    function(context)
        cm:trigger_dilemma("3k_main_faction_lu_bu", "3k_dlc05_faction_leader_dies_dilemma_generic", true)
		end,
    true
	);


-----------------------------------------------------------------
-------reset personal victories to 0 if the player chooses to----
-----------------------------------------------------------------
	core:add_listener(
        "DilemmaChoiceMadeEventLuBuLeaderDeath",
        "DilemmaChoiceMadeEvent",
		function(context)
			return context:dilemma() == "3k_dlc05_faction_leader_dies_dilemma_generic"
		end,
    function(context)
        if context:choice() == 1 then
        self:reset_faction_pooled_resource_to_0("3k_main_faction_lu_bu", "3k_dlc05_pooled_resource_lu_bu_personal_victories","3k_dlc05_pooled_factor_personal_victories_characters_defeated")
        end
		end,
    true
	);
	
	-----------------------------------------------------------------
	------------------halves momentum each turn----------------------
	-----------------------------------------------------------------
	
	core:add_listener(
		"StartOfTurnLuBuMomentumDecay",
		"FactionTurnStart",
		function(context)
			return context:faction():name() == "3k_main_faction_lu_bu"
		end,
		function(context)
			self:decay_momentum(context:faction())
		end,
		true
	)
	
end
	
--------------------------------------------------------------------------
----------------------FUNCTIONS-------------------------------------------
--------------------------------------------------------------------------

function lu_bu_features:lu_bu_generate_pooled_resource(pooled_resource_factor, value, adding_to_momentum)
  	output("add "..value.." to the momentum and personal victories counts")
  	local query_faction = cm:query_faction("3k_main_faction_lu_bu");
	local query_resource_momentum = query_faction:pooled_resources():resource("3k_dlc05_pooled_resource_lu_bu_momentum");
	local query_resource_personal_victories = query_faction:pooled_resources():resource("3k_dlc05_pooled_resource_lu_bu_personal_victories");
  
	if query_faction:is_null_interface() then
		script_error("3k_dlc05_campaign_lu_bu_features: Cannot find faction.");
	end;

	if query_resource_momentum:is_null_interface() then
		script_error("3k_dlc05_campaign_lu_bu_features: Cannot find momentum resource.");
	end;
	
  if query_resource_personal_victories:is_null_interface() then
		script_error("3k_dlc05_campaign_lu_bu_features: Cannot find personal victories resource.");
	end;

	if adding_to_momentum then
		cm:modify_model():get_modify_pooled_resource(query_resource_momentum):apply_transaction_to_factor(pooled_resource_factor, value);
	else
		cm:modify_model():get_modify_pooled_resource(query_resource_personal_victories):apply_transaction_to_factor(pooled_resource_factor, value);
	end
end
  
  
  
function lu_bu_features:reset_faction_pooled_resource_to_0(faction, pooled_resource_key,transaction_factor)
  local query_faction = cm:query_faction(faction);
	local query_resource = query_faction:pooled_resources():resource(pooled_resource_key);
  
  local pooled_resource_total = query_resource:value()
  
  cm:modify_model():get_modify_pooled_resource(query_resource):apply_transaction_to_factor(transaction_factor,(0 - pooled_resource_total));
end


function lu_bu_features:count_characters_in_battle(battle_log_entry, battle_won)
	
	local characters_defeated_points = 0
	
	if battle_won then

		for i = 0, battle_log_entry:losing_characters():num_items()-1 do
			characters_defeated_points = characters_defeated_points + 1
		end

	end

	return characters_defeated_points
	
end

function lu_bu_features:decay_momentum(faction)
	local query_resource_momentum = faction:pooled_resources():resource("3k_dlc05_pooled_resource_lu_bu_momentum")
	--raw momentum at the end of the previous turn
	local pre_process_momentum = query_resource_momentum:value()

	local rate_of_decay = 0

	if pre_process_momentum < 4 then --momentum levels 0-3 have no decay
			rate_of_decay = 0
	elseif pre_process_momentum < 9 then --1 point of decay for levels 4-8
			rate_of_decay = 1
	else 								 --2 points of decay for levels 9 and 10
			rate_of_decay = 2
	end

	cm:modify_model():get_modify_pooled_resource(query_resource_momentum):apply_transaction_to_factor("3k_dlc05_pooled_factor_momentum_decay",(0-rate_of_decay))
	
end
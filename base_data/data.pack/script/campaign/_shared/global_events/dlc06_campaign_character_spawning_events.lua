---------------------------------------------------------------------------------------------------------
----- Name:			DLC06 GLOBAL EVENTS - character spawning manager
----- Description: 	
-----				Manages spawning of historical characters into the game world
-----
---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- MAIN
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

character_spawning_events = {}

-- Don't load in campaigns which don't require it.
if cm.name == "ep_eight_princes" then
	output("dlc06_global_events.lua: Not loaded in this campaign." );
	return;
end;

output("dlc06_campaign_character_spawning_events.lua: Loading");


local function new_game()

end

local function initialise()

	output("Initialising character spawn manager")

	
	character_spawning_events:spawn_characters()
end

cm:add_first_tick_callback_new(new_game);
cm:add_first_tick_callback(initialise); --Self register function

function character_spawning_events:spawn_characters()


	local wei_yan_spawn_event = global_event:new("wei_yan_spawn_event", "WorldStartOfRoundEvent",
	function(context)
		--15% spawn chance
		if cm:random_number(0, 100) <= 15 then
			return true
		end
	end)
	wei_yan_spawn_event:set_valid_dates(195, 220)
	wei_yan_spawn_event:add_incident("3k_dlc06_char_historical_wei_yan_spawns_incident")
	wei_yan_spawn_event:add_fallback_callback(
		function()
			if not cm:query_faction("3k_main_faction_liu_bei"):is_human() then

				--if liu bei is alive, spawn to him, if not, spawn to liu biao, if not, find a random han faction to give him to
				if not cm:query_faction("3k_main_faction_liu_bei"):is_dead() then
					cm:modify_faction("3k_main_faction_liu_bei"):create_character_from_template("general", "3k_general_wood", "3k_main_template_historical_wei_yan_hero_wood", true)
				else

					if not cm:query_faction("3k_main_faction_liu_biao"):is_dead() then
						cm:modify_faction("3k_main_faction_liu_biao"):create_character_from_template("general", "3k_general_wood", "3k_main_template_historical_wei_yan_hero_wood", true)
					else

						function find_random_faction()
							while true do
								local random_index = cm:random_int(0, cm:query_model():world():faction_list():num_items()-1)
								local random_faction = cm:query_model():world():faction_list():item_at(random_index)

								if random_faction:name() ~= "3k_main_faction_liu_bei" and random_faction:name() ~= "3k_main_faction_liu_biao"
								and not random_faction:is_dead() and random_faction:subculture() == "3k_main_chinese" and not random_faction:is_rebel() then
									return random_faction:name()
								end
							end
						end

						cm:modify_faction(find_random_faction()):create_character_from_template("general", "3k_general_wood", "3k_main_template_historical_wei_yan_hero_wood", true)

					end
				end

			end
		end)
	wei_yan_spawn_event:register()



end
core_global_events = {};

-- Don't load in campaigns which don't require it.
if cm.name == "ep_eight_princes" then
	output("core_global_events.lua: Not loaded in this campaign." );
	return;
end;

output("core_global_events.lua: Loading");

local function new_game()
end;

local function initialise()

	core_global_events:sun_ce_death_global_event()

end;

cm:add_first_tick_callback_new(new_game);
cm:add_first_tick_callback(initialise); --Self register function

function core_global_events:sun_ce_death_global_event()

	local death_of_sun_ce = global_event:new("sun_ce_death_by_reckless_luck_event", "FactionTurnStart",
	function(context)
		local sun_ce_faction = cm:query_faction("3k_dlc05_faction_sun_ce")
		local sun_ce_character = cm:query_model():character_for_template("3k_main_template_historical_sun_ce_hero_fire")
		
		if sun_ce_faction and sun_ce_character
		 and not sun_ce_faction:is_null_interface() and not sun_ce_character:is_null_interface() and not sun_ce_character:is_dead() then
			return context:faction():name() == sun_ce_faction:name() and sun_ce_faction:pooled_resources():resource("3k_dlc05_pooled_resource_reckless_luck"):value() <=0
		else
			return false
		end
	end)
	death_of_sun_ce:add_dilemma("3k_dlc05_sun_ce_zero_reckless_luck_dead_event")
	death_of_sun_ce:add_dilemma_choice_outcome("3k_dlc05_sun_ce_zero_reckless_luck_dead_event", 0, "SunCeDeathTrigger" ,100)
	death_of_sun_ce:register()

	local kill_sun_ce = global_event:new("sun_ce_death_trigger","SunCeDeathTrigger")
	kill_sun_ce:add_post_event_callback(
		function()
			local sun_ce_character = cm:query_model():character_for_template("3k_main_template_historical_sun_ce_hero_fire")
			cm:modify_character(sun_ce_character:cqi()):kill_character(false)
		end)
	kill_sun_ce:register()

end
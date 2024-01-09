output("campaign events script loaded for Lu Bu");

-- Spawn initial armies.
local function initial_set_up()
	---Spawn an additional force with Xiahou Yuan in it ---
	local xiahou_yuan_spawn = invasion_manager:new_invasion("xiahou_yuan_invasion", "3k_main_faction_cao_cao", "", {488, 488})
	local xiahou_yuan = cm:query_model():character_for_template("3k_main_template_historical_xiahou_yuan_hero_fire")
	xiahou_yuan_spawn:assign_general(xiahou_yuan:cqi())
	xiahou_yuan_spawn:start_invasion()
	cm:modify_model():get_modify_military_force(xiahou_yuan:military_force()):set_retreated()

	-- spawn xiahou dun in lu bu's way 
	local xiahou_dun_spawn = invasion_manager:new_invasion("xiahou_dun_invasion", "3k_main_faction_cao_cao", "", {494, 480})
	local xiahou_dun = cm:query_model():character_for_template("3k_main_template_historical_xiahou_dun_hero_wood")
	xiahou_dun_spawn:assign_general(xiahou_dun:cqi())
	xiahou_dun_spawn:start_invasion()
	cm:modify_model():get_modify_military_force(xiahou_dun:military_force()):set_retreated()


	-- make the annexation treaty with all factions.
	local lu_bu = "3k_main_faction_lu_bu"
	local all_factions = cm:query_model():world():faction_list();
	output("3k_main_faction_lu_bu_start - setting up annexation treaty with all factions");
	for i=0, all_factions:num_items() - 1 do
		local query_faction = all_factions:item_at(i);
		if not query_faction or query_faction:is_null_interface() then
			script_error( "3k_main_faction_lu_bu_start - No faction! found for annexation treaty!" );
		elseif not query_faction:is_dead() and query_faction:name() ~= "rebels"  and query_faction:name() ~= "3k_main_faction_lu_bu" then
			diplomacy_manager:apply_automatic_deal_between_factions(lu_bu, query_faction:name(), "data_defined_situation_set_up_lu_bu_annexation", false);
		end;
	end;
end;

cm:add_first_tick_callback_sp_new(initial_set_up);
cm:add_first_tick_callback_mp_new(initial_set_up);


local function each_time_setup()

	-- Anexation treaty.
	core:add_listener(
		"LuBuAnnexationTreatyListener",
		"FactionEncountersOtherFaction",
		function(context)
			return context:faction():name() == "3k_main_faction_lu_bu" and not context:other_faction():has_specified_diplomatic_deal_with_anybody("3k_dlc05_automatic_deal_lu_bu_annexation")
		end,
		function(context)
			output("applying annexation treaty between lu bu and newly discovered faction"..context:faction():name())
			diplomacy_manager:apply_automatic_deal_between_factions("3k_main_faction_lu_bu", context:faction():name(), "data_defined_situation_set_up_lu_bu_annexation", false);
		end,
		true
	);
end;

cm:add_first_tick_callback_mp_each( function() each_time_setup() end );
cm:add_first_tick_callback_sp_each( function() each_time_setup() end );
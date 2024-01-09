-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
--
--	FACTION SCRIPT
--
--	Custom script for this faction starts here. This script loads in additional
--	scripts depending on the mode the campaign is being started in (first turn vs
--	open), sets up the faction_start object and does some other things
--
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------

local local_faction_key = "3k_main_faction_ma_teng";

output("campaign script loaded for " .. local_faction_key);

---------------------------------------------------------------
--	First-Tick callbacks
---------------------------------------------------------------

cm:add_first_tick_callback_sp_new(
	function() 
		-- put faction-specific calls that should only gets triggered in a new singleplayer game here
		output("New  SP Game Events Fired for " .. local_faction_key);

		start_campaign_from_intro_cutscene_shared();
		turn_one_region_visibility();
	end
);

--[[
cm:add_first_tick_callback_sp_each(
	function() 
		-- put faction-specific calls that should get triggered each time a singleplayer game loads here
		output("Each SP Game Events Fired for " .. local_faction_key);
	end
);]]--

cm:add_first_tick_callback_mp_new(
	function() 
		-- put faction-specific calls that should only gets triggered in a new multiplayer game here
		output("New MP Game Events Fired for " .. local_faction_key);
		
		-- Set starting camera
		cm:set_camera_position(
			162.822205,		-- camera x position 
			375.354889, 	-- camera y position
			13.779042, 		-- camera d position
			-0.973967, 		-- camera b position
			5.775582		-- camera h position
		);
	end
);

--[[
cm:add_first_tick_callback_mp_each(
	function()
		-- put faction-specific calls that should get triggered each time a multiplayer game loads here
		-- output("Each MP Game Events Fired for " .. local_faction_key);
	end
);]]--


---------------------------------------------------------------
--	Turn One Region Visibility
---------------------------------------------------------------

function turn_one_region_visibility()

	-- Reveal a number of relevant regions (and their owning factions) at the start of turn one.

	local modify_faction = cm:modify_faction(local_faction_key);

	if not modify_faction then
		script_error("Error no faction found");
		return;
	end;

	-- Luoyang
	modify_faction:make_region_seen_in_shroud("3k_main_luoyang_capital");
	modify_faction:make_region_seen_in_shroud("3k_main_luoyang_resource_1");
end

---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------
----- Name:			3k_campaign_progression
----- Description: 	Three Kingdoms system to create an interesting endgame when needed. Written in an State Machine style since it's very much 'phase' based.
----- Style:		SelfRegistering, StoresData, PlaysMovies
---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------

-- Don't load in campaigns which don't require it.
if cm.name == "ep_eight_princes" then
	output("3k_campaign_progression: Not loaded in this campaign." );
	return;
else
	output("3k_campaign_progression: Loading");
end;

cm:add_first_tick_callback(function() progression:initialise() end); --Self register function

---------------------------------------------------------------------------------------------------------
----- DATA
---------------------------------------------------------------------------------------------------------

if not progression then -- If the table doesn't exist yet, create it. Allows this to load before/after/independently of the other progression scripts.
	progression = {};
end

progression.disable_progression = false;
progression.max_emperor_seats = 3;

-- Movie keys and 'played' values.
-- Intro, Game Won and Game Lost handled in the DB.
progression.movie_key_190_start_default = "3k_main_faction_intro_earth"
progression.movie_key_190_start_faction = {
	["3k_main_faction_cao_cao"] = "3k_main_faction_intro_cao_cao",
	["3k_main_faction_dong_zhuo"] = "3k_main_faction_intro_dong_zhuo",
	["3k_dlc04_faction_empress_he"] = "3k_main_faction_intro_earth",
	["3k_main_faction_liu_bei"] = "3k_main_faction_intro_liu_bei",
	["3k_main_faction_liu_biao"] = "3k_main_faction_intro_earth_liu_biao",
	["3k_dlc04_faction_prince_liu_chong"] = "3k_main_faction_intro_earth",
	["3k_dlc04_faction_lu_zhi"] = "3k_main_faction_intro_water",
	["3k_main_faction_sun_jian"] = "3k_main_faction_intro_sun_jian",
	["3k_main_faction_tao_qian"] = "3k_main_faction_intro_earth"
};

progression.movie_key_fall_of_dong_zhuo = "3k_main_fall_of_dong_zhuo";
progression.movie_key_warlords = "3k_main_warlords";
progression.movie_key_three_kingdoms = "3k_main_three_kingdoms";
progression.movie_key_guandu_cao_cao_win = "3k_dlc07_fullscreen_event_cao_cao_wins";
progression.movie_key_guandu_yuan_shao_win = "3k_dlc07_fullscreen_event_yuan_shao_wins";

progression.has_played_movie_190_start = false;
progression.has_played_movie_fall_of_dong_zhuo = false;
progression.has_played_movie_warlords = false;
progression.has_played_movie_three_kingdoms = false;
progression.has_played_movie_guandu_win = false;


---------------------------------------------------------------------------------------------------------
----- MAIN FUNCTIONS
---------------------------------------------------------------------------------------------------------

--[[
    initialise()
        Entry point.
]]--
function progression:initialise()
	output("3k_campaign_progression.lua: Initialise()" );

	-- Campaign specific logic.
	if cm:query_model():campaign_name() == "3k_dlc04_start_pos" then
		-- Artificially increase the threat score of the main YT factions in the Mandate campaign (this is to reflect their global destabilising effect in the threat score)
		local fac = cm:query_faction("3k_dlc04_faction_zhang_bao");
		cm:modify_faction(fac):change_base_threat_score_for_a_faction(70);
		fac = cm:query_faction("3k_dlc04_faction_zhang_jue");
		cm:modify_faction(fac):change_base_threat_score_for_a_faction(70);
		fac = cm:query_faction("3k_dlc04_faction_zhang_liang");
		cm:modify_faction(fac):change_base_threat_score_for_a_faction(70);
		output("-*- progression(): AFTER THREAT MOD");
	else
		self.has_played_movie_190_start = true;
	end;
	
	-- Generic listeners
	self:add_progression_listener_fame_level_up(); -- Faction rank increase.
	self:add_progression_listener_new_faction_leader(); -- Faction has a new leader.
	self:add_progression_listener_debug_movie(); -- Debug Movie, Faction Turn

	-- Specific event listeners.
	self:add_progression_listener_dong_zhuo_captures_emperor(); -- Emperor seized by dong zhuo.
	self:add_progression_listener_dong_zhuo_dies(); -- Character Death: Dong Zhuo.
	self:add_progression_listener_emperor(); -- Faction Becomes World Leader & 3Kingdoms.

	if cm:query_model():campaign_name() == "3k_dlc07_start_pos" then -- TODO: Limited to dlc07 for now, but we should expose this for all campaigns.
		self:add_progression_listener_guandu_war_ended(); -- Either Cao Cao or Yuan Shao has won the Guandu War
	end;
	
end;


---------------------------------------------------------------------------------------------------------
----- LISTENERS
---------------------------------------------------------------------------------------------------------

--// Intro
--// Start of game.
--// Handled in the DB frontend_faction_leaders table loading_screen_intro_video field

--[[
    add_progression_listener_debug_movie()
        When Turn Start, if the flag it set to true.
]]--

function progression:add_progression_listener_debug_movie()
    -- Example: trigger_cli_debug_event progression.play_debug_movie(3k_main_fall_of_dong_zhuo)
    core:add_cli_listener("progression.play_debug_movie", 
		function(movie_key)
            output("-*- progression(): Playing Debug Movie");

            self:play_movie(cm:modify_model(), movie_key);
		end
    );
end;


--[[
	add_progression_listener_dong_zhuo_captures_emperor()
        When DZ (or other) siezes the emperor.
        Play Movie
]]
function progression:add_progression_listener_dong_zhuo_captures_emperor()
	core:add_listener(
        "progression_190_start", -- UID
        "WorldPowerTokenGainedEvent", -- CampaignEvent
		function(context)
			local emperor_owner = cm:get_world_power_token_owner("emperor");
			if emperor_owner and not emperor_owner:is_null_interface() and emperor_owner:has_faction_leader() then
				local gen_key = emperor_owner:faction_leader():generation_template_key();
				return gen_key == "3k_main_template_historical_dong_zhuo_general_fire" or gen_key == "3k_main_template_historical_dong_zhuo_hero_fire";
			end;

			return false;
		end, --Conditions for firing
        function(context)
            output("-*- progression(): Emperor Siezed!");

			if not self.has_played_movie_190_start then
				local movie_key = self.movie_key_190_start_default;

				if not cm:is_multiplayer() then
					local l_faction_key = cm:get_local_faction(false);
					if l_faction_key and self.movie_key_190_start_faction[l_faction_key] then
						movie_key = self.movie_key_190_start_faction[l_faction_key];
					end;
				end;

                self:play_movie(cm:modify_model(), movie_key);
                self.has_played_movie_190_start = true;

            end;
        end, -- Function to fire.
        false -- Is Persistent?
    );
end;


--[[
    add_progression_listener_dong_zhuo()
        When DZ dies.
        Play Movie
]]--
function progression:add_progression_listener_dong_zhuo_dies()

    core:add_listener(
        "progression_dong_zhuo", -- UID
        "CharacterDied", -- CampaignEvent
        function(event)
            if event:query_character():is_null_interface() then
                output("-*- progression(): Null character interface " .. tostring(event:query_character():is_null_interface()) .. tostring(event:query_character():ceo_management():is_null_interface()) );
                return false;
            end;
            
            return event:query_character():generation_template_key() == "3k_main_template_historical_dong_zhuo_general_fire" or event:query_character():generation_template_key() == "3k_main_template_historical_dong_zhuo_hero_fire";
        end, --Conditions for firing
        function(event)
			output("-*- progression(): Dong Zhuo Has Died!");

			-- Don't queue this up unless Dong Zhuo is the tyrant.
			if cm:get_campaign_name() == "dlc04_mandate" and not global_events_manager:get_flag("DongZhuoSeizedTheEmpire") then
				output("-*- progression(): Dong Zhuo Never seized the emperor, so don't show this!");
				return false;
			end;

            if not self.has_played_movie_fall_of_dong_zhuo then
                self:play_movie(cm:modify_model(), self.movie_key_fall_of_dong_zhuo);
                self.has_played_movie_fall_of_dong_zhuo = true
            end;
        end, -- Function to fire.
        false -- Is Persistent?
    );
end;


--[[
    add_progression_listener_fame_level_up()
        Play Movies
]]--
function progression:add_progression_listener_fame_level_up()
    core:add_listener(
        "progression_duke", -- UID
        "FactionFameLevelUp", -- CampaignEvent
        true, --Conditions for firing
        function(event)
            local query_faction = event:faction();
			
			if self:has_progression_feature(query_faction, "play_movie_warlords", true) then -- DLC04 - Replace progression level check with feature_test
				output("-*- progression(): Rank reached: 3 Duke");

				if query_faction:is_human() and not self.has_played_movie_warlords then
                    self:play_movie(cm:modify_model(), self.movie_key_warlords);
                    self.has_played_movie_warlords = true
                end;
			end;
        end, -- Function to fire.
        true -- Is Persistent?
    );
end;


--[[
    add_progression_listener_emperor()
        When any faction becomes emperor.
        Apply permenant effect bundle to their capital region.
        If we have Three Kingdoms (AKA Emperor Seats) then fire the movie!
]]--
function progression:add_progression_listener_emperor()
    core:add_listener(
        "progression_emperor", -- UID
        "WorldLeaderRegionAdded", -- CampaignEvent
        true, --Conditions for firing
        function(event)
            local query_faction = event:region():owning_faction();
            local modify_faction = cm:modify_model():get_modify_faction(query_faction);
            local query_capital_region = modify_faction:query_faction():capital_region();

			output("-*- progression(): Emperor Seat Established in " .. query_capital_region:name());
					
			-- THREE KINGDOMS
			local num_world_leader_seats = cm:get_total_number_of_world_leader_seats();
			output("-*- progression(): Total number of Emperor Seats in the world: " .. tostring(num_world_leader_seats));
            if num_world_leader_seats and num_world_leader_seats >= self.max_emperor_seats then
                output("-*- progression(): We Have Three Kingdoms!");

                if not self.has_played_movie_three_kingdoms then
                    self:play_movie(cm:modify_model(), self.movie_key_three_kingdoms);
                    self.has_played_movie_three_kingdoms = true
					
					-- AI SCRIPT to trigger global personality change (late game)
					out.ai("AI SCRIPT: global personality change after establishing 3 Emperor seats");
					self:global_personality_change();
					-- AI SCRIPT END
                end;
            end;
        end, -- Function to fire.
        true -- Is Persistent?
    );
end;

 
--[[
    add_progression_listener_world_power_token_removed()
        When the emperor world power token is removed, we try to spawn his template in another faction.
]]--



--[[
    add_progression_listener_guandu_war_ended()
        When the war between Cao Cao and Yuan Shao ends, we'll fire a movie.
]]--
function progression:add_progression_listener_guandu_war_ended()
	core:add_listener(
		"progression_guandu_war_ended",
		"FactionDied",
		function(context)
			local dead_faction_key = context:faction():name();
			local killer_key = context:killer_or_confederator_faction_key();
			return (dead_faction_key == "3k_main_faction_cao_cao" and killer_key == "3k_main_faction_yuan_shao")
				or (killer_key == "3k_main_faction_cao_cao" and dead_faction_key == "3k_main_faction_yuan_shao");
		end,
		function(context)
			if not self.has_played_movie_guandu_win then
				if context:faction():name() == "3k_main_faction_cao_cao" then -- if the dying faction was Cao Cao...
					self:play_movie(context:modify_model(), self.movie_key_guandu_yuan_shao_win);
				else
					self:play_movie(context:modify_model(), self.movie_key_guandu_cao_cao_win);
				end;
				self.has_played_movie_guandu_win = true;
			end;
		end,
		false
	)
end;


--[[ ************** AI SCRIPT ************** 
    add_progression_listener_new_faction_leader()
        A faction gets a new faction leader.
]]--
function progression:add_progression_listener_new_faction_leader()
    core:add_listener(
        "progression_new_faction_leader", -- UID
        "CharacterBecomesFactionLeader", -- CampaignEvent
        function(context)
            return not cm:get_saved_value("roguelike_mode");
        end,
        function(context)
            output("-*- progression(): Faction has new faction leader");
			local character = context:query_character();
			local faction = character:faction();
            -- AI SCRIPT to trigger personality change for this faction
			out.ai("AI SCRIPT: changing the personality of faction: " .. faction:name());
			self:change_personality_of_faction(faction,false);
			-- AI SCRIPT END
        end, -- Function to fire.
        true -- Is Persistent?
    );
end;


---------------------------------------------------------------------------------------------------------
----- METHODS
---------------------------------------------------------------------------------------------------------

--[[
    play_movie()
        Plays the given movie string.
        Path is relative to the 'working_data/movies' folder. e.g. cm:register_instant_movie("Warhammer/chs_rises");
]]--
function progression:play_movie(modify_model, movie_db_record)
    if self.disable_progression then
        output("progression:play_movie(): progression Disabled. Tried to play: " .. movie_db_record);
        return;
    end;

    output("progression:play_movie(): Playing Movie: " .. movie_db_record);

    modify_model:get_modify_episodic_scripting():register_instant_movie_by_record(movie_db_record);
end;


--[[ ************** AI SCRIPT ************** 
    global_personality_change()
        Used when the game enters a new phase; 
		Shifts the personality of all non-emperors;
]]--
function progression:global_personality_change()
	output("progression:global_personality_change(): AI SCRIPT is triggering global personality change");
	local faction_list = cm:query_model():world():faction_list();
		
		for i = 0, faction_list:num_items() - 1 do
			local faction = faction_list:item_at(i);
			
			self:change_personality_of_faction(faction,true);
		end;
	return;
end;


--[[ ************** AI SCRIPT ************** 
    change_personality_of_faction()
        Triggers the personality change or shift of the specified faction;
		If shift == true then we make sure the new personality is similar to the old, otherwise it's a complete random roll;
]]--
function progression:change_personality_of_faction(faction,similar)	
	local weight = 0;
	if similar == true then
		weight = 10;
	end;
	local faction_phase = self:determine_phase_value_of_faction(faction);
	out.ai("progression:change_personality_of_faction(): AI SCRIPT is changing the personality of faction: " .. faction:name() .. " Phase number: " .. faction_phase .. " Bias towards old personality: " ..weight);
	cm:modify_campaign_ai():cai_force_personality_change(faction:name(),faction_phase,weight);
	return;
end;


--[[ ************** AI SCRIPT ************** 
    determine_phase_value_of_faction()
        Determines and returns the phase value of this specific faction. This is what we use as a turn number when triggering the personality change.
]]--
function progression:determine_phase_value_of_faction(faction)	
	--query if faction is world leader; if yes, return 3; if no, continue
	if self.has_played_movie_three_kingdoms then
		return 2;
	else
		return 0;
	end;
end;


function progression:force_campaign_victory(faction_reference)
	local query_faction = cm:query_faction(faction_reference);
	local human_factions = cm:get_human_factions();

	if not query_faction or query_faction:is_null_interface() then
		script_error("ERROR: cm:trigger_campaign_victory() Null faction passed in with key " .. tostring(faction_reference));
		return false;
	end;

	-- Win game for main faction.
	if cm:is_multiplayer() then
		if not diplomacy_manager:is_mp_coop_victory_enabled(query_faction) then -- Only one can win mp game. It could also not be any human.
			cm:modify_faction(query_faction):complete_custom_mission("3k_main_mp_versus_victory");
			
			for i, v in ipairs(human_factions) do
				if query_faction:name() ~= v then
					self:force_campaign_defeat(v);
				end;
			end;
			
		elseif query_faction:is_human() then -- All humans wins coop game.
			for i, v in ipairs(human_factions) do
				if query_faction:name() ~= v then
					cm:modify_faction(query_faction):complete_custom_mission("3k_main_mp_coop_victory");
				end;
			end;
		end;

	else -- If we're not in mp, we assume the one victory type for all factions.
		cm:modify_faction(query_faction):complete_custom_mission("3k_main_long_victory");

		-- Lose the game for any human factions, as the AI may have won.
		for i, v in ipairs(human_factions) do
			if query_faction:name() ~= v then
				self:force_campaign_defeat(v);
			end;
		end;
	end;
end;


-- Note: unlock force_camapign_victory, this doesn't actually complete the campaign for anyone else.
function progression:force_campaign_defeat(faction_reference)
	local query_faction = cm:query_faction(faction_reference);
	local human_factions = cm:get_human_factions();


	if not query_faction or query_faction:is_null_interface() then
		script_error("ERROR: cm:trigger_campaign_victory() Null faction passed in with key " .. tostring(faction_reference));
		return false;
	end;

	if cm:is_multiplayer() then
        for i, v in ipairs(human_factions) do
            if diplomacy_manager:is_mp_coop_victory_enabled(v) then
                cm:modify_faction(v):cancel_custom_mission("3k_main_mp_coop_victory");
            else
                cm:modify_faction(v):cancel_custom_mission("3k_main_mp_versus_victory");
            end;
		end;
	else
		cm:modify_faction(query_faction):cancel_custom_mission("3k_main_long_victory");
	end;
end;

---------------------------------------------------------------------------------------------------------
----- SAVE/LOAD
---------------------------------------------------------------------------------------------------------
function progression:register_save_load_callbacks()
    cm:add_saving_game_callback(
        function(saving_game_event)
			cm:save_named_value("progression_has_played_movie_190_start", self.has_played_movie_190_start);
			cm:save_named_value("progression_has_played_movie_fall_of_dong_zhuo", self.has_played_movie_fall_of_dong_zhuo);
            cm:save_named_value("progression_has_played_movie_warlords", self.has_played_movie_warlords);
			cm:save_named_value("progression_has_played_movie_three_kingdoms", self.has_played_movie_three_kingdoms);
			cm:save_named_value("progression_has_played_movie_guandu_win", self.has_played_movie_guandu_win);
        end
    );

    cm:add_loading_game_callback(
        function(loading_game_event)
			local l_has_played_movie_190_start = cm:load_named_value("progression_has_played_movie_190_start", self.has_played_movie_190_start);
			local l_has_played_movie_fall_of_dong_zhuo = cm:load_named_value("progression_has_played_movie_fall_of_dong_zhuo", self.has_played_movie_fall_of_dong_zhuo);
            local l_has_played_movie_warlords = cm:load_named_value("progression_has_played_movie_warlords", self.has_played_movie_warlords);
            local l_has_played_movie_three_kingdoms = cm:load_named_value("progression_has_played_movie_three_kingdoms", self.has_played_movie_three_kingdoms);
			local l_has_played_movie_guandu_win = cm:load_named_value("progression_has_played_movie_guandu_win", self.has_played_movie_guandu_win);

			self.has_played_movie_190_start = l_has_played_movie_190_start;
            self.has_played_movie_fall_of_dong_zhuo = l_has_played_movie_fall_of_dong_zhuo;
            self.has_played_movie_warlords = l_has_played_movie_warlords;
			self.has_played_movie_three_kingdoms = l_has_played_movie_three_kingdoms;
			self.has_played_movie_guandu_win = l_has_played_movie_guandu_win;
        end
    );
end;

progression:register_save_load_callbacks();
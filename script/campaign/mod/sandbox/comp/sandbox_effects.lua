local sandbox = TheGathering_sandbox:get_sandbox_mod()

--==============================================================================--
							-- Common Header --
--==============================================================================--

local lib		= sandbox:get_library()
local loc 	 	= sandbox:get_localisation()
local logger 	= sandbox:get_logger()
local util		= sandbox:get_util()
local utf8		= sandbox:get_utf8()

local _eq = function( ... ) return logger:eq( ... ) end
local _ee = function( ... ) return logger:ee( ... ) end
local _to = function( ... ) return logger:to( ... ) end
local _te = function( ... ) return logger:te( ... ) end
local _tm = function( ... ) return logger:tm( ... ) end
local _on = function( ... ) return logger:on( ... ) end
local _hi = function( ... ) return logger:hi( ... ) end
local _nn = function( ... ) return logger:nn( ... ) end
local _nt = function( ... ) return logger:nt( ... ) end
local _nf = function( ... ) return logger:nf( ... ) end
local _pr = function( ... ) return logger:pr( ... ) end
local _no = function( ... ) return logger:no( ... ) end
local _n2 = function( ... ) return logger:nto2( ... ) end
local _e2 = function( ... ) return logger:eto2( ... ) end
local _c2 = function( ... ) return logger:cto2( ... ) end

local mod_advice = sandbox:get_mod_advice()
local mod_patterns = sandbox:get_mod_patterns()

		--==============================================================================--
									-- Effects Locals --
		--==============================================================================--

		--==============================================================================--
							-- Read User Action Command Functions --
		--==============================================================================--

function sandbox:read_user_action_ef_resilience( line )

	local log_head = "read_user_action_ef_resilience"
	local faction, plus = string.match( line, mod_patterns( "ef_resilience" ) )

	logger:dev( log_head, _eq( "faction", faction ), _eq( "plus", plus ) )

	plus = tonumber(plus)
	if not faction or not plus or lib.not_in( plus, { 0, 1 } ) then
		logger:warn( log_head, "pattern mismatch", "_[:"..line )
		return
	end

	local action = self:create_action( "ef_resilience" )

	action.faction = self:input_to_faction_key( faction )
	if not action.faction then
		logger:warn( log_head, "faction not found", faction, line )
		
		return nil, loc:format( "faction_not_found", faction )
	end

	action.plus = plus
	action.turn = 1

	return action
end

function sandbox:read_user_action_ef_exp_bonus( line )

	local log_head = "read_user_action_ef_exp_bonus"
	local faction, experience = string.match( line, mod_patterns( "ef_exp_bonus" ) )

	logger:dev( log_head, _eq( "faction", faction ), _eq( "experience", experience ) )

	if not faction or lib.not_in( experience, { "0", "25", "50", "100", "200", "300", "500" } )
	then
		logger:warn( log_head, "pattern mismatch", "_[:"..line )
		return
	end

	local action = self:create_action( "ef_exp_bonus" )

	action.faction = self:input_to_faction_key( faction )
	if not action.faction then
		logger:warn( log_head, "faction not found", faction, line )
		
		return nil, loc:format( "faction_not_found", faction )
	end

	action.experience = tonumber(experience)
	action.turn = 1

	return action
end

function sandbox:read_user_action_ef_research_rate( line )

	local log_head = "read_user_action_ef_research_rate"
	local faction, rate = string.match( line, mod_patterns( "ef_research_rate" ) )

	logger:dev( log_head, _eq( "faction", faction ), _eq( "rate", rate ) )

	if not faction
		or lib.not_in( rate, { "0", "100", "200", "300", "400", "500" } )
	then
		logger:warn( log_head, "pattern mismatch", "_[:"..line )
		return
	end

	local action = self:create_action( "ef_research_rate" )

	action.faction = self:input_to_faction_key( faction )
	if not action.faction then
		logger:warn( log_head, "faction not found", faction, line )
		
		return nil, loc:format( "faction_not_found", faction )
	end

	action.rate = tonumber(rate)
	action.turn = 1

	return action
end

function sandbox:read_user_action_ef_armies( line )

	local log_head = "read_user_action_ef_armies"
	local faction, count = string.match( line, mod_patterns( "ef_armies" ) )

	logger:dev( log_head, _eq( "faction", faction ), _eq( "count", count ) )

	count = tonumber( count )

	if not faction or not count or count < 0 or count > 10 then
		logger:warn( log_head, "pattern mismatch", "_[:"..line )
		return
	end

	local action = self:create_action( "ef_armies" )

	action.faction = self:input_to_faction_key( faction )
	if not action.faction then
		logger:warn( log_head, "faction not found", faction, line )
		
		return nil, loc:format( "faction_not_found", faction )
	end

	action.count = count
	action.turn = 1

	return action
end

function sandbox:read_user_action_ef_assignments( line )

	local log_head = "read_user_action_ef_assignments"
	local faction, count = string.match( line, mod_patterns( "ef_assignments" ) )

	logger:dev( log_head, _eq( "faction", faction ), _eq( "count", count ) )

	count = tonumber( count )

	if not faction or not count or count < 0 or count > 10 then
		logger:warn( log_head, "pattern mismatch", "_[:"..line )
		return
	end

	local action = self:create_action( "ef_assignments" )

	action.faction = self:input_to_faction_key( faction )
	if not action.faction then
		logger:warn( log_head, "faction not found", faction, line )
		
		return nil, loc:format( "faction_not_found", faction )
	end

	action.count = count
	action.turn = 1

	return action
end

function sandbox:read_user_action_ef_governors( line )

	local log_head = "read_user_action_ef_governors"
	local faction, count = string.match( line, mod_patterns( "ef_governors" ) )

	logger:dev( log_head, _eq( "faction", faction ), _eq( "count", count ) )

	count = tonumber( count )

	if not faction or not count or count < 0 or count > 10 then
		logger:warn( log_head, "pattern mismatch", "_[:"..line )
		return
	end

	local action = self:create_action( "ef_governors" )

	action.faction = self:input_to_faction_key( faction )
	if not action.faction then
		logger:warn( log_head, "faction not found", faction, line )
		
		return nil, loc:format( "faction_not_found", faction )
	end

	action.count = count
	action.turn = 1

	return action
end

function sandbox:read_user_action_ef_force_movement( line )

	local log_head = "read_user_action_ef_force_movement"
	local faction, degree = string.match( line, mod_patterns( "ef_force_movement" ) )

	logger:dev( log_head, _eq( "faction", faction ), _eq( "degree", degree ) )

	degree = tonumber( degree )

	if not faction or not degree or lib.not_in( degree, { 0, 10, 20, 30, 40, 50 } ) then
		logger:warn( log_head, "pattern mismatch", "_[:"..line )
		return
	end

	local action = self:create_action( "ef_force_movement" )

	action.faction = self:input_to_faction_key( faction )
	if not action.faction then
		logger:warn( log_head, "faction not found", faction, line )
		
		return nil, loc:format( "faction_not_found", faction )
	end

	action.degree = degree
	action.turn = 1

	return action
end

function sandbox:read_user_action_ef_retinue_upkeep( line )

	local log_head = "read_user_action_ef_retinue_upkeep"
	local faction, degree = string.match( line, mod_patterns( "ef_retinue_upkeep" ) )

	logger:dev( log_head, _eq( "faction", faction ), _eq( "degree", degree ) )

	degree = tonumber( degree )

	if not faction or not degree or lib.not_in( degree, { 0, 10, 20, 30, 40, 50 } ) then
		logger:warn( log_head, "pattern mismatch", "_[:"..line )
		return
	end

	local action = self:create_action( "ef_retinue_upkeep" )

	action.faction = self:input_to_faction_key( faction )
	if not action.faction then
		logger:warn( log_head, "faction not found", faction, line )
		
		return nil, loc:format( "faction_not_found", faction )
	end

	action.degree = degree
	action.turn = 1

	return action
end

function sandbox:read_user_action_ef_deploy_cost( line )

	local log_head = "read_user_action_ef_deploy_cost"
	local faction, degree = string.match( line, mod_patterns( "ef_deploy_cost" ) )

	logger:dev( log_head, _eq( "faction", faction ), _eq( "degree", degree ) )

	degree = tonumber( degree )

	if not faction or not degree or lib.not_in( degree, { 0, 10, 20, 30, 40, 50 } ) then
		logger:warn( log_head, "pattern mismatch", "_[:"..line )
		return
	end

	local action = self:create_action( "ef_deploy_cost" )

	action.faction = self:input_to_faction_key( faction )
	if not action.faction then
		logger:warn( log_head, "faction not found", faction, line )
		
		return nil, loc:format( "faction_not_found", faction )
	end

	action.degree = degree
	action.turn = 1

	return action
end

function sandbox:read_user_action_ef_salary( line )

	local log_head = "read_user_action_ef_salary"
	local faction, degree = string.match( line, mod_patterns( "ef_salary" ) )

	logger:dev( log_head, _eq( "faction", faction ), _eq( "degree", degree ) )

	degree = tonumber( degree )

	if not faction or not degree or lib.not_in( degree, { 0, 10, 20, 30, 40, 50, 60, 70, 80, 90, 100 } ) then
		logger:warn( log_head, "pattern mismatch", "_[:"..line )
		return
	end

	local action = self:create_action( "ef_salary" )

	action.faction = self:input_to_faction_key( faction )
	if not action.faction then
		logger:warn( log_head, "faction not found", faction, line )
		
		return nil, loc:format( "faction_not_found", faction )
	end

	action.degree = degree
	action.turn = 1

	return action
end

function sandbox:read_user_action_ef_recruit_rank( line )

	local log_head = "read_user_action_ef_recruit_rank"
	local faction, rank = string.match( line, mod_patterns( "ef_recruit_rank" ) )

	logger:dev( log_head, _eq( "faction", faction ), _eq( "rank", rank ) )

	rank = tonumber( rank )

	if not faction or not rank or rank < 0 or rank > 5 then
		logger:warn( log_head, "pattern mismatch", "_[:"..line )
		return
	end

	local action = self:create_action( "ef_recruit_rank" )

	action.faction = self:input_to_faction_key( faction )
	if not action.faction then
		logger:warn( log_head, "faction not found", faction, line )
		
		return nil, loc:format( "faction_not_found", faction )
	end

	action.rank = rank
	action.turn = 1

	return action
end

function sandbox:read_user_action_ef_satisfaction( line )

	local log_head = "read_user_action_ef_satisfaction"
	local faction, degree = string.match( line, mod_patterns( "ef_satisfaction" ) )

	logger:dev( log_head, _eq( "faction", faction ), _eq( "degree", degree ) )

	degree = tonumber( degree )

	if not faction or not degree or lib.not_in( degree, { 0, 10, 20, 30, 40 } ) then
		logger:warn( log_head, "pattern mismatch", "_[:"..line )
		return
	end

	local action = self:create_action( "ef_satisfaction" )

	action.faction = self:input_to_faction_key( faction )
	if not action.faction then
		logger:warn( log_head, "faction not found", faction, line )
		
		return nil, loc:format( "faction_not_found", faction )
	end

	action.degree = degree
	action.turn = 1

	return action
end

function sandbox:read_user_action_ef_job_satisfaction( line )

	local log_head = "read_user_action_ef_job_satisfaction"
	local faction, mode = string.match( line, mod_patterns( "ef_job_satisfaction" ) )

	logger:dev( log_head, _eq( "faction", faction ), _eq( "mode", mode ) )

	mode = tonumber( mode )

	if not faction or not mode or mode < 0 or mode > 2 then
		logger:warn( log_head, "pattern mismatch", "_[:"..line )
		return
	end

	local action = self:create_action( "ef_job_satisfaction" )

	action.faction = self:input_to_faction_key( faction )
	if not action.faction then
		logger:warn( log_head, "faction not found", faction, line )
		
		return nil, loc:format( "faction_not_found", faction )
	end

	action.mode = mode
	action.turn = 1

	return action
end

function sandbox:read_user_action_ef_presented( line )

	local log_head = "read_user_action_ef_presented"
	local hero, turn = string.match( line, mod_patterns( "ef_presented" ) )

	logger:dev( log_head, _eq( "hero", hero ) )

	if not hero then
		logger:warn( log_head, "pattern mismatch", "_[:"..line )
		return
	end

	local action = self:create_action( "ef_presented" )

	self:set_action_hero( action, hero )
	action.turn = lib.numberorone( turn )

	return action
end


		--==============================================================================--
								-- Faction Effect Bundles --
		--==============================================================================--

sandbox.faction_effect_bundles = {
	['force_captive_chance'] = {
		['low'] = "the_sandbox_force_captive_chance_low",
		['med'] = "the_sandbox_force_captive_chance_med",
		['high'] = "the_sandbox_force_captive_chance_high",
	},
}

function sandbox:faction_remove_effect_bundle( query_faction, bundle_name, effect_bundles, not_quiet )

	not_quiet = not not not_quiet

	local modify_faction = self:modify_faction( query_faction )
	local success = true

	for _, remove_key in pairs( effect_bundles ) do
		modify_faction:remove_effect_bundle( remove_key )
		
		if query_faction:has_effect_bundle( remove_key ) then
			success = false
		end
	end

	if not_quiet then
		logger:verbose( "faction_remove_effect_bundle", self:faction_kr(query_faction), _eq( "removing", bundle_name ), _eq( "success", success ) )
	end
	
	return success
end

function sandbox:faction_apply_effect_bundle( query_faction, bundle_name, bundle_key, effect_bundles, turn, not_quiet )

	local log_head = "faction_apply_effect_bundle"
	not_quiet = not not not_quiet
	turn = turn or 0
	local success = false

	local modify_faction = self:modify_faction( query_faction )

	for _, remove_key in pairs( effect_bundles ) do
		modify_faction:remove_effect_bundle( remove_key )
	end

	if bundle_key then
		modify_faction:apply_effect_bundle( bundle_key, turn )
		if query_faction:has_effect_bundle( bundle_key ) then
			success = true
		end
	end

	if not_quiet then
		logger:verbose( "_i:1", log_head, self:faction_kr(query_faction), _eq( bundle_name..":"..((bundle_key and "adding") or "removing"),  success ) )
	end
	
	return success
end

function sandbox:all_faction_apply_effect_bundle( faction, bundle_name, bundle_key, effect_bundles, turn )

	turn = turn or 0

	local log_head = "all_faction_apply_effect_bundle"
	local effect_key_count = lib.table_rows( effect_bundles )
	local all_factions = sandbox:query_world():faction_list()
	local added, removed, total = 0, 0, 0
	local prev_indent = logger:inc_indent()

	logger:verbose( log_head, faction, bundle_name, bundle_key, _eq( "bundles", #effect_bundles), turn )

	for i = 0, all_factions:num_items() - 1 do
		local query_faction = all_factions:item_at( i )

		if is_interface(query_faction) and not query_faction:is_dead() then

			local modify_faction = self:modify_faction( query_faction )

			for _, remove_key in pairs( effect_bundles ) do
				modify_faction:remove_effect_bundle( remove_key )
			end

			if ( faction == "all"
				or (faction == "others" and self:not_local_faction( query_faction ))
				or (faction == "player" and self:is_local_faction( query_faction ))
				or (faction == query_faction:name()) )
			then
				removed = removed + 1

				if bundle_key then
					modify_faction:apply_effect_bundle( bundle_key, turn )

					added = added + 1
				end
			end

			total = total + 1
		end
	end

	if added > 0 then
		logger:verbose( log_head, bundle_name.." ["..effect_key_count.."]", faction, bundle_key, added.."/"..removed.."/"..total, turn )
	else
		logger:verbose( log_head, bundle_name.." ["..effect_key_count.."]", faction, "null", removed.."/"..total, turn )
	end

	logger:set_indent( prev_indent )
	return added, removed, total
end

function sandbox:apply_faction_effect_bundles()

	-- 3k_main_effect_province_corruption_unseen
	-- 3k_main_effect_characters_satisfaction
	-- 3k_main_effect_character_num_lives

	-- 3k_main_effect_character_stat_mod_battle_movement_speed
	-- 3k_main_effect_character_stat_mod_charge_speed
	-- 3k_main_skill_run_speed

	local effect_bundles_keys =
	{
		--[1] = { variable = "degree",	name = "heroes_salary" },
		--[2] = { variable = "degree",	name = "force_retinue_upkeep" },
		--[3] = { variable = "degree",	name = "force_redeployment_cost" },
		--[4] = { variable = "degree",	name = "force_homeland_movement" },
		--[5] = { variable = "degree",	name = "force_captive_chance" },
	   --[10] = { variable = "rank",	name = "force_recruit_rank" },
	   --[11] = { variable = "limit",	name = "faction_limit_army" },
	   --[12] = { variable = "limit",	name = "faction_limit_governor" },
	   --[13] = { variable = "limit",	name = "faction_limit_assignment" },
	}

	local prev_indent = logger:inc_indent()

	for _, row in pairs( effect_bundles_keys ) do
		local bundle_name = row.name

		if self[ bundle_name ] then
			local bundles = self.faction_effect_bundles[ bundle_name ]

			local call_indent = logger:inc_indent()
			if self[ bundle_name ].enable then
				local bundle_key = bundles[ self[ bundle_name ][ row.variable ] ]

				self:all_faction_apply_effect_bundle( self[ bundle_name ].faction, bundle_name, bundle_key, bundles, 0 )
			else
				self:all_faction_apply_effect_bundle( nil, bundle_name, nil, bundles, 0 )
			end

			logger:set_indent( call_indent )
		end
	end

	--self:modify_faction(self:local_faction()):apply_effect_bundle( "the_sandbox_faction_job_satisfaction_reduced", 0 )
	--self:remove_zheng_jiang_from_banned_list()

	logger:set_indent( prev_indent )
end

		--==============================================================================--
								-- User Scripted Functions --
		--==============================================================================--

function sandbox:user_scripted_ef_resilience( action )

	local log_head = "user_scripted_ef_resilence"

	local bundle_name = "faction_ef_resilence"
	local effect_bundles = {
		[1] = "the_sandbox_faction_num_lives_plus",
	}
	local bundle_key = effect_bundles[ action.plus ]
	local added, removed, total = 1, 1, 1

	if lib.is_in( action.faction, { "all", "others" } ) then

		added, removed, total = self:all_faction_apply_effect_bundle( action.faction, bundle_name, bundle_key, effect_bundles, 0 )
		logger( log_head, _eq( "added", added ), _eq( "removed", removed ), _eq( "total", total ) )
	else
		local query_faction = sandbox:query_faction( action.faction )

		self:faction_apply_effect_bundle( query_faction, bundle_name, bundle_key, effect_bundles, 0, true  )
	end

	return added, removed, total
end

function sandbox:user_scripted_ef_research_rate( action )

	local log_head = "user_scripted_ef_research_rate"
	local bundle_name = "faction_research_rates"
	local effect_bundles = {
		[100] = "the_sandbox_faction_research_rate_100",
		[200] = "the_sandbox_faction_research_rate_200",
		[300] = "the_sandbox_faction_research_rate_300",
		[400] = "the_sandbox_faction_research_rate_400",
		[500] = "the_sandbox_faction_research_rate_500",
	}
	local bundle_key = effect_bundles[ action.rate ]
	local added, removed, total = 1, 1, 1
	local success = true

	logger( log_head, bundle_name, bundle_key, action )

	if lib.is_in( action.faction, { "all", "others" } ) then

		added, removed, total = self:all_faction_apply_effect_bundle( action.faction, bundle_name, bundle_key, effect_bundles, 0 )
		logger( log_head, _eq( "added", added ), _eq( "removed", removed ), _eq( "total", total ) )

	else
		local query_faction = sandbox:query_faction( action.faction )

		success = self:faction_apply_effect_bundle( query_faction, bundle_name, bundle_key, effect_bundles, 0, true  )
	end

	return added, removed, total, success
end

function sandbox:user_scripted_ef_exp_bonus( action )

	local log_head = "user_scripted_ef_exp_bonus"
	local prev_indent = logger:inc_indent()

	local bundle_name = "faction_exp_bonus"
	local effect_bundles = 	{
		[25] = "the_sandbox_faction_character_experience_25",
		[50] = "the_sandbox_faction_character_experience_50",
	   [100] = "the_sandbox_faction_character_experience_100",
	   [200] = "the_sandbox_faction_character_experience_200",
	   [300] = "the_sandbox_faction_character_experience_300",
	   [500] = "the_sandbox_faction_character_experience_500",
	}
	local bundle_key = effect_bundles[ action.experience ]
	local added, removed, total = 1, 1, 1

	if lib.is_in( action.faction, { "all", "others" } ) then

		added, removed, total = self:all_faction_apply_effect_bundle( action.faction, bundle_name, bundle_key, effect_bundles, 0 )
		logger( log_head, _eq( "added", added ), _eq( "removed", removed ), _eq( "total", total ) )
	else
		local query_faction = sandbox:query_faction( action.faction )

		self:faction_apply_effect_bundle( query_faction, bundle_name, bundle_key, effect_bundles, 0, true  )
	end

	logger:set_indent( prev_indent )

	return added, removed, total
end

function sandbox:user_scripted_ef_governors( action )

	local log_head = "user_scripted_ef_governors"
	local prev_indent = logger:inc_indent()

	local bundle_name = "faction_limit_governors"
	local effect_bundles = 	{
		[1] = "the_sandbox_faction_limit_governor_1",
		[2] = "the_sandbox_faction_limit_governor_2",
		[3] = "the_sandbox_faction_limit_governor_3",
		[4] = "the_sandbox_faction_limit_governor_4",
		[5] = "the_sandbox_faction_limit_governor_5",
		[6] = "the_sandbox_faction_limit_governor_6",
		[7] = "the_sandbox_faction_limit_governor_7",
		[8] = "the_sandbox_faction_limit_governor_8",
		[9] = "the_sandbox_faction_limit_governor_9",
	   [10] = "the_sandbox_faction_limit_governor_10",
	}
	local bundle_key = effect_bundles[ action.count ]
	local added, removed, total = 1, 1, 1

	if lib.is_in( action.faction, { "all", "others" } ) then

		added, removed, total = self:all_faction_apply_effect_bundle( action.faction, bundle_name, bundle_key, effect_bundles, 0 )
		logger( log_head, _eq( "added", added ), _eq( "removed", removed ), _eq( "total", total ) )
	else
		local query_faction = sandbox:query_faction( action.faction )

		self:faction_apply_effect_bundle( query_faction, bundle_name, bundle_key, effect_bundles, 0, true  )
	end

	logger:set_indent( prev_indent )

	return added, removed, total
end

function sandbox:user_scripted_ef_armies( action )

	local log_head = "user_scripted_ef_armies"
	local prev_indent = logger:inc_indent()

	local bundle_name = "faction_limit_armies"
	local effect_bundles = 	{
		[1] = "the_sandbox_faction_limit_army_1",
		[2] = "the_sandbox_faction_limit_army_2",
		[3] = "the_sandbox_faction_limit_army_3",
		[4] = "the_sandbox_faction_limit_army_4",
		[5] = "the_sandbox_faction_limit_army_5",
		[6] = "the_sandbox_faction_limit_army_1",
		[7] = "the_sandbox_faction_limit_army_2",
		[8] = "the_sandbox_faction_limit_army_3",
		[9] = "the_sandbox_faction_limit_army_4",
	   [10] = "the_sandbox_faction_limit_army_5",
	}
	local bundle_key = effect_bundles[ action.count ]
	local added, removed, total = 1, 1, 1

	if lib.is_in( action.faction, { "all", "others" } ) then

		added, removed, total = self:all_faction_apply_effect_bundle( action.faction, bundle_name, bundle_key, effect_bundles, 0 )
		logger( log_head, _eq( "added", added ), _eq( "removed", removed ), _eq( "total", total ) )
	else
		local query_faction = sandbox:query_faction( action.faction )

		self:faction_apply_effect_bundle( query_faction, bundle_name, bundle_key, effect_bundles, 0, true  )
	end

	logger:set_indent( prev_indent )

	return added, removed, total
end

function sandbox:user_scripted_ef_assignments( action )

	local log_head = "user_scripted_ef_assignments"
	local prev_indent = logger:inc_indent()

	local bundle_name = "faction_limit_assignments"
	local effect_bundles = 	{
		[1] = "the_sandbox_faction_limit_assignment_1",
		[2] = "the_sandbox_faction_limit_assignment_2",
		[3] = "the_sandbox_faction_limit_assignment_3",
		[4] = "the_sandbox_faction_limit_assignment_4",
		[5] = "the_sandbox_faction_limit_assignment_5",
		[6] = "the_sandbox_faction_limit_assignment_6",
		[7] = "the_sandbox_faction_limit_assignment_7",
		[8] = "the_sandbox_faction_limit_assignment_8",
		[9] = "the_sandbox_faction_limit_assignment_9",
	   [10] = "the_sandbox_faction_limit_assignment_10",
	}
	local bundle_key = effect_bundles[ action.count ]
	local added, removed, total = 1, 1, 1

	if lib.is_in( action.faction, { "all", "others" } ) then

		added, removed, total = self:all_faction_apply_effect_bundle( action.faction, bundle_name, bundle_key, effect_bundles, 0 )
		logger( log_head, _eq( "added", added ), _eq( "removed", removed ), _eq( "total", total ) )
	else
		local query_faction = sandbox:query_faction( action.faction )

		self:faction_apply_effect_bundle( query_faction, bundle_name, bundle_key, effect_bundles, 0, true  )
	end

	logger:set_indent( prev_indent )

	return added, removed, total
end

function sandbox:user_scripted_ef_force_movement( action )

	local log_head = "user_scripted_ef_force_movement"
	local prev_indent = logger:inc_indent()

	local bundle_name = "faction_movement_range"
	local effect_bundles = 	{
		[10] = "the_sandbox_faction_movement_range_10",
		[20] = "the_sandbox_faction_movement_range_20",
		[30] = "the_sandbox_faction_movement_range_30",
		[40] = "the_sandbox_faction_movement_range_40",
		[50] = "the_sandbox_faction_movement_range_50",
	}
	local bundle_key = effect_bundles[ action.degree ]
	local added, removed, total = 1, 1, 1

	if lib.is_in( action.faction, { "all", "others" } ) then

		added, removed, total = self:all_faction_apply_effect_bundle( action.faction, bundle_name, bundle_key, effect_bundles, 0 )
		logger( log_head, _eq( "added", added ), _eq( "removed", removed ), _eq( "total", total ) )
	else
		local query_faction = sandbox:query_faction( action.faction )

		self:faction_apply_effect_bundle( query_faction, bundle_name, bundle_key, effect_bundles, 0, true  )
	end

	logger:set_indent( prev_indent )

	return added, removed, total
end

function sandbox:user_scripted_ef_retinue_upkeep( action )

	local log_head = "user_scripted_ef_retinue_upkeep"
	local prev_indent = logger:inc_indent()

	local bundle_name = "faction_retinue_upkeep"
	local effect_bundles = 	{
		[10] = "the_sandbox_faction_retinue_upkeep_10",
		[20] = "the_sandbox_faction_retinue_upkeep_20",
		[30] = "the_sandbox_faction_retinue_upkeep_30",
		[40] = "the_sandbox_faction_retinue_upkeep_40",
		[50] = "the_sandbox_faction_retinue_upkeep_50",
		[100] = "the_sandbox_faction_retinue_upkeep_100",

	}
	local bundle_key = effect_bundles[ action.degree ]
	local added, removed, total = 1, 1, 1

	if lib.is_in( action.faction, { "all", "others" } ) then

		added, removed, total = self:all_faction_apply_effect_bundle( action.faction, bundle_name, bundle_key, effect_bundles, 0 )
		logger( log_head, _eq( "added", added ), _eq( "removed", removed ), _eq( "total", total ) )
	else
		local query_faction = sandbox:query_faction( action.faction )

		self:faction_apply_effect_bundle( query_faction, bundle_name, bundle_key, effect_bundles, 0, true  )
	end

	logger:set_indent( prev_indent )

	return added, removed, total
end

function sandbox:user_scripted_ef_deploy_cost( action )

	local log_head = "user_scripted_ef_deploy_cost"
	local prev_indent = logger:inc_indent()

	local bundle_name = "faction_redeployment_cost"
	local effect_bundles = 	{
		[10] = "the_sandbox_faction_redeployment_cost_10",
		[20] = "the_sandbox_faction_redeployment_cost_20",
		[30] = "the_sandbox_faction_redeployment_cost_30",
		[40] = "the_sandbox_faction_redeployment_cost_40",
		[50] = "the_sandbox_faction_redeployment_cost_50",
	}
	local bundle_key = effect_bundles[ action.degree ]
	local added, removed, total = 1, 1, 1

	if lib.is_in( action.faction, { "all", "others" } ) then

		added, removed, total = self:all_faction_apply_effect_bundle( action.faction, bundle_name, bundle_key, effect_bundles, 0 )
		logger( log_head, _eq( "added", added ), _eq( "removed", removed ), _eq( "total", total ) )
	else
		local query_faction = sandbox:query_faction( action.faction )

		self:faction_apply_effect_bundle( query_faction, bundle_name, bundle_key, effect_bundles, 0, true  )
	end

	logger:set_indent( prev_indent )

	return added, removed, total
end

function sandbox:user_scripted_ef_salary( action )

	local log_head = "user_scripted_ef_ef_salary"
	local prev_indent = logger:inc_indent()

	local bundle_name = "faction_salary"
	local effect_bundles = 	{
		[10] = "the_sandbox_faction_salary_10",
		[20] = "the_sandbox_faction_salary_20",
		[30] = "the_sandbox_faction_salary_30",
		[40] = "the_sandbox_faction_salary_40",
		[50] = "the_sandbox_faction_salary_50",
		[60] = "the_sandbox_faction_salary_60",
		[70] = "the_sandbox_faction_salary_70",
		[80] = "the_sandbox_faction_salary_80",
		[90] = "the_sandbox_faction_salary_90",
	   [100] = "the_sandbox_faction_salary_100",
	}
	local bundle_key = effect_bundles[ action.degree ]
	local added, removed, total = 1, 1, 1

	if lib.is_in( action.faction, { "all", "others" } ) then

		added, removed, total = self:all_faction_apply_effect_bundle( action.faction, bundle_name, bundle_key, effect_bundles, 0 )
		logger( log_head, _eq( "added", added ), _eq( "removed", removed ), _eq( "total", total ) )
	else
		local query_faction = sandbox:query_faction( action.faction )

		self:faction_apply_effect_bundle( query_faction, bundle_name, bundle_key, effect_bundles, 0, true )
	end

	logger:set_indent( prev_indent )

	return added, removed, total
end

function sandbox:user_scripted_ef_recruit_rank( action )

	local log_head = "user_scripted_ef_recruit_rank"
	local prev_indent = logger:inc_indent()

	local bundle_name = "faction_recruit_rank"
	local effect_bundles = 	{
		[1] = "the_sandbox_faction_unit_recruit_rank_1",
		[2] = "the_sandbox_faction_unit_recruit_rank_2",
		[3] = "the_sandbox_faction_unit_recruit_rank_3",
		[4] = "the_sandbox_faction_unit_recruit_rank_4",
		[5] = "the_sandbox_faction_unit_recruit_rank_5",
	}
	local bundle_key = effect_bundles[ action.rank ]
	local added, removed, total = 1, 1, 1

	if lib.is_in( action.faction, { "all", "others" } ) then

		added, removed, total = self:all_faction_apply_effect_bundle( action.faction, bundle_name, bundle_key, effect_bundles, 0 )
		logger( log_head, _eq( "added", added ), _eq( "removed", removed ), _eq( "total", total ) )
	else
		local query_faction = sandbox:query_faction( action.faction )

		self:faction_apply_effect_bundle( query_faction, bundle_name, bundle_key, effect_bundles, 0, true )
	end

	logger:set_indent( prev_indent )

	return added, removed, total
end

function sandbox:user_scripted_ef_satisfaction( action )

	local log_head = "user_scripted_ef_satisfaction"
	local prev_indent = logger:inc_indent()

	local bundle_name = "faction_satisfaction"
	local effect_bundles = 	{
		[10] = "the_sandbox_faction_satisfaction_bonus_10",
		[20] = "the_sandbox_faction_satisfaction_bonus_20",
		[30] = "the_sandbox_faction_satisfaction_bonus_30",
		[40] = "the_sandbox_faction_satisfaction_bonus_40",
	}
	local bundle_key = effect_bundles[ action.degree ]
	local added, removed, total = 1, 1, 1

	if lib.is_in( action.faction, { "all", "others" } ) then

		added, removed, total = self:all_faction_apply_effect_bundle( action.faction, bundle_name, bundle_key, effect_bundles, 0 )
		logger( log_head, _eq( "added", added ), _eq( "removed", removed ), _eq( "total", total ) )
	else
		local query_faction = sandbox:query_faction( action.faction )

		self:faction_apply_effect_bundle( query_faction, bundle_name, bundle_key, effect_bundles, 0, true )
	end

	logger:set_indent( prev_indent )

	return added, removed, total
end

function sandbox:user_scripted_ef_job_satisfaction( action )

	local log_head = "user_scripted_ef_job_satisfaction"
	local prev_indent = logger:inc_indent()

	local bundle_name = "faction_job_satisfaction"
	local effect_bundles_reduced = 	{
		[1] = "the_sandbox_faction_job_satisfaction_reduced",
	}
	local effect_bundles_ignored = 	{
		[2] = "the_sandbox_faction_job_satisfaction_ignored",
	}
	local bundle_key_reduced = effect_bundles_reduced[ action.mode ]
	local bundle_key_ignored = effect_bundles_ignored[ action.mode ]
	local added, removed, total = 1, 1, 1

	if lib.is_in( action.faction, { "all", "others" } ) then
		added, removed, total = self:all_faction_apply_effect_bundle( action.faction, bundle_name, bundle_key_reduced, effect_bundles_reduced, 0 )
		added, removed, total = self:all_faction_apply_effect_bundle( action.faction, bundle_name, bundle_key_ignored, effect_bundles_ignored, 0 )
		logger:verbose( log_head, _eq( "added", added ), _eq( "removed", removed ), _eq( "total", total ) )
	else
		local query_faction = sandbox:query_faction( action.faction )

		self:faction_apply_effect_bundle( query_faction, bundle_name, bundle_key_reduced, effect_bundles_reduced, 0, true )
		self:faction_apply_effect_bundle( query_faction, bundle_name, bundle_key_ignored, effect_bundles_ignored, 0, true )
	end

	logger:set_indent( prev_indent )

	return added, removed, total
end

function sandbox:user_scripted_ef_presented( action, query_character )

	local log_head = "user_scripted_ef_presented";
	local result = false

	local prev_indent = logger:inc_indent()

	query_character = query_character or self:find_action_character( action )

	if is_interface( query_character ) then
		self:modify_character( query_character ):add_loyalty_effect( "presented_gift" )

		logger:debug( log_head, "add_loyalty_effect", self:character_kr(query_character), action )

		result = true
	else
		logger:error( log_head, "hero NOT found", action or "invalid query_character" )
	end

	logger:set_indent( prev_indent )

	return result
end

		--==============================================================================--
								-- Do Input functions --
		--==============================================================================--

function sandbox:do_input_ef_resilience( action ) -- resilience

	local log_head = "do_input_num_lives"
	local prev_indent = logger:inc_indent()
	local added, removed, total = self:user_scripted_ef_resilience( action )

	if lib.is_in( action.faction, { "all", "others" } ) then
		if action.faction == "all" then
			if action.plus == 1 then
				mod_advice:push( "ef_resilience_added_all", added )
			else
				mod_advice:push( "ef_resilience_removed_all", removed )
			end
		else
			if action.plus == 1 then
				mod_advice:push( "ef_resilience_added_others", added )
			else
				mod_advice:push( "ef_resilience_removed_others", removed )
			end
		end
	else
		if action.plus == 1 then
			mod_advice:push( "ef_resilience_added_faction", self:faction_kr(action.faction) )
		else
			mod_advice:push( "ef_resilience_removed_faction", self:faction_kr(action.faction) )
		end
	end

	logger:set_indent( prev_indent )
end

function sandbox:do_input_ef_research_rate( action )

	local log_head = "do_input_ef_research_rate"
	local prev_indent = logger:inc_indent()
	local added, removed, total, success = self:user_scripted_ef_research_rate( action )

	logger( log_head, added, removed, total, action )

	if lib.is_in( action.faction, { "all", "others" } ) then
		if action.faction == "all" then
			if action.rate ~= 0 then
				mod_advice:push( "ef_research_rate_added_all", added, action.rate )
			else
				mod_advice:push( "ef_research_rate_removed_all", removed )
			end
		else
			if action.rate ~= 0 then
				mod_advice:push( "ef_research_rate_added_others", added, action.rate )
			else
				mod_advice:push( "ef_research_rate_removed_others", removed )
			end
		end
	else
		if action.rate ~= 0 then
			if success then
				mod_advice:push( "ef_research_rate_added_faction", self:faction_kr(action.faction), action.rate )
			else
				mod_advice:push( "ef_faction_adding_failed", "Research rate", self:faction_kr(action.faction) )
			end
		else
			mod_advice:push( "ef_research_rate_removed_faction", self:faction_kr(action.faction) )
		end
	end

	logger:set_indent( prev_indent )
end

function sandbox:do_input_ef_exp_bonus( action )

	local log_head = "do_input_ef_exp_bonus"
	local prev_indent = logger:inc_indent()
	local added, removed, total = self:user_scripted_ef_exp_bonus( action )

	if lib.is_in( action.faction, { "all", "others" } ) then

		if action.faction == "all" then
			if action.experience ~= 0 then
				mod_advice:push( "ef_exp_bonus_added_all", added, action.experience )
			else
				mod_advice:push( "ef_exp_bonus_removed_all", removed )
			end
		else
			if action.experience ~= 0 then
				mod_advice:push( "ef_exp_bonus_added_others", added, action.experience )
			else
				mod_advice:push( "ef_exp_bonus_removed_others", removed )
			end
		end
	else
		if action.experience ~= 0 then
			mod_advice:push( "ef_exp_bonus_added_faction", self:faction_kr(action.faction), action.experience )
		else
			mod_advice:push( "ef_exp_bonus_removed_faction", self:faction_kr(action.faction), action.experience )
		end
	end

	logger:set_indent( prev_indent )
end

function sandbox:do_input_ef_armies( action )

	local log_head = "do_input_ef_armies"
	local prev_indent = logger:inc_indent()
	local added, removed, total = self:user_scripted_ef_armies( action )

	logger( log_head, added, removed, total, action )

	if lib.is_in( action.faction, { "all", "others" } ) then
		if action.faction == "all" then
			if action.count ~= 0 then
				mod_advice:push( "ef_armies_added_all", added, action.count )
			else
				mod_advice:push( "ef_armies_removed_all", removed )
			end
		else
			if action.count ~= 0 then
				mod_advice:push( "ef_armies_added_others", added, action.count )
			else
				mod_advice:push( "ef_armies_removed_others", removed )
			end
		end
	else
		if action.count ~= 0 then
			mod_advice:push( "ef_armies_added_faction", self:faction_kr(action.faction), action.count )
		else
			mod_advice:push( "ef_armies_removed_faction", self:faction_kr(action.faction) )
		end
	end

	logger:set_indent( prev_indent )
end

function sandbox:do_input_ef_governors( action )

	local log_head = "do_input_ef_governors"
	local prev_indent = logger:inc_indent()
	local added, removed, total = self:user_scripted_ef_governors( action )

	logger( log_head, added, removed, total, action )

	if lib.is_in( action.faction, { "all", "others" } ) then
		if action.faction == "all" then
			if action.count ~= 0 then
				mod_advice:push( "ef_governors_added_all", added, action.count )
			else
				mod_advice:push( "ef_governors_removed_all", removed )
			end
		else
			if action.count ~= 0 then
				mod_advice:push( "ef_governors_added_others", added, action.count )
			else
				mod_advice:push( "ef_governors_removed_others", removed )
			end
		end
	else
		if action.count ~= 0 then
			mod_advice:push( "ef_governors_added_faction", self:faction_kr(action.faction), action.count )
		else
			mod_advice:push( "ef_governors_removed_faction", self:faction_kr(action.faction) )
		end
	end

	logger:set_indent( prev_indent )
end

function sandbox:do_input_ef_assignments( action )

	local log_head = "do_input_ef_assignments"
	local prev_indent = logger:inc_indent()
	local added, removed, total = self:user_scripted_ef_assignments( action )

	logger( log_head, added, removed, total, action )

	if lib.is_in( action.faction, { "all", "others" } ) then
		if action.faction == "all" then
			if action.count ~= 0 then
				mod_advice:push( "ef_assignments_added_all", added, action.count )
			else
				mod_advice:push( "ef_assignments_removed_all", removed )
			end
		else
			if action.count ~= 0 then
				mod_advice:push( "ef_assignments_added_others", added, action.count )
			else
				mod_advice:push( "ef_assignments_removed_others", removed )
			end
		end
	else
		if action.count ~= 0 then
			mod_advice:push( "ef_assignments_added_faction", self:faction_kr(action.faction), action.count )
		else
			mod_advice:push( "ef_assignments_removed_faction", self:faction_kr(action.faction) )
		end
	end

	logger:set_indent( prev_indent )
end

function sandbox:do_input_ef_force_movement( action )

	local log_head = "do_input_ef_force_movement"
	local prev_indent = logger:inc_indent()
	local added, removed, total = self:user_scripted_ef_force_movement( action )

	logger( log_head, added, removed, total, action )

	if lib.is_in( action.faction, { "all", "others" } ) then
		if action.faction == "all" then
			if action.degree ~= 0 then
				mod_advice:push( "ef_force_movement_added_all", added, action.degree )
			else
				mod_advice:push( "ef_force_movement_removed_all", removed )
			end
		else
			if action.degree ~= 0 then
				mod_advice:push( "ef_force_movement_added_others", added, action.degree )
			else
				mod_advice:push( "ef_force_movement_removed_others", removed )
			end
		end
	else
		if action.degree ~= 0 then
			mod_advice:push( "ef_force_movement_added_faction", self:faction_kr(action.faction), action.degree )
		else
			mod_advice:push( "ef_force_movement_removed_faction", self:faction_kr(action.faction) )
		end
	end

	logger:set_indent( prev_indent )
end

function sandbox:do_input_ef_recruit_rank( action )

	local log_head = "do_input_ef_recruit_rank"
	local prev_indent = logger:inc_indent()
	local added, removed, total = self:user_scripted_ef_recruit_rank( action )

	logger( log_head, added, removed, total, action )

	if lib.is_in( action.faction, { "all", "others" } ) then
		if action.faction == "all" then
			if action.rank ~= 0 then
				mod_advice:push( "ef_recruit_rank_added_all", added, action.rank )
			else
				mod_advice:push( "ef_recruit_rank_removed_all", removed )
			end
		else
			if action.rank ~= 0 then
				mod_advice:push( "ef_recruit_rank_added_others", added, action.rank )
			else
				mod_advice:push( "ef_recruit_rank_removed_others", removed )
			end
		end
	else
		if action.rank ~= 0 then
			mod_advice:push( "ef_recruit_rank_added_faction", self:faction_kr(action.faction), action.rank )
		else
			mod_advice:push( "ef_recruit_rank_removed_faction", self:faction_kr(action.faction) )
		end
	end

	logger:set_indent( prev_indent )
end

function sandbox:do_input_ef_retinue_upkeep( action )

	local log_head = "do_input_ef_retinue_upkeep"
	local prev_indent = logger:inc_indent()
	local added, removed, total = self:user_scripted_ef_retinue_upkeep( action )

	logger( log_head, added, removed, total, action )

	if lib.is_in( action.faction, { "all", "others" } ) then
		if action.faction == "all" then
			if action.degree ~= 0 then
				mod_advice:push( "ef_retinue_upkeep_added_all", added, action.degree )
			else
				mod_advice:push( "ef_retinue_upkeep_removed_all", removed )
			end
		else
			if action.degree ~= 0 then
				mod_advice:push( "ef_retinue_upkeep_added_others", added, action.degree )
			else
				mod_advice:push( "ef_retinue_upkeep_removed_others", removed )
			end
		end
	else
		if action.degree ~= 0 then
			mod_advice:push( "ef_retinue_upkeep_added_faction", self:faction_kr(action.faction), action.degree )
		else
			mod_advice:push( "ef_retinue_upkeep_removed_faction", self:faction_kr(action.faction) )
		end
	end

	logger:set_indent( prev_indent )
end

function sandbox:do_input_ef_deploy_cost( action )

	local log_head = "do_input_ef_deploy_cost"
	local prev_indent = logger:inc_indent()
	local added, removed, total = self:user_scripted_ef_deploy_cost( action )

	logger( log_head, added, removed, total, action )

	if lib.is_in( action.faction, { "all", "others" } ) then
		if action.faction == "all" then
			if action.degree ~= 0 then
				mod_advice:push( "ef_deploy_cost_added_all", added, action.degree )
			else
				mod_advice:push( "ef_deploy_cost_removed_all", removed )
			end
		else
			if action.degree ~= 0 then
				mod_advice:push( "ef_deploy_cost_added_others", added, action.degree )
			else
				mod_advice:push( "ef_deploy_cost_removed_others", removed )
			end
		end
	else
		if action.degree ~= 0 then
			mod_advice:push( "ef_deploy_cost_added_faction", self:faction_kr(action.faction), action.degree )
		else
			mod_advice:push( "ef_deploy_cost_removed_faction", self:faction_kr(action.faction) )
		end
	end

	logger:set_indent( prev_indent )
end

function sandbox:do_input_ef_salary( action )

	local log_head = "do_input_ef_salary"
	local prev_indent = logger:inc_indent()
	local added, removed, total = self:user_scripted_ef_salary( action )

	logger( log_head, added, removed, total, action )

	if lib.is_in( action.faction, { "all", "others" } ) then
		if action.faction == "all" then
			if action.degree ~= 0 then
				mod_advice:push( "ef_salary_added_all", added, action.degree )
			else
				mod_advice:push( "ef_salary_removed_all", removed )
			end
		else
			if action.degree ~= 0 then
				mod_advice:push( "ef_salary_added_others", added, action.degree )
			else
				mod_advice:push( "ef_salary_removed_others", removed )
			end
		end
	else
		if action.degree ~= 0 then
			mod_advice:push( "ef_salary_added_faction", self:faction_kr(action.faction), action.degree )
		else
			mod_advice:push( "ef_salary_removed_faction", self:faction_kr(action.faction) )
		end
	end

	logger:set_indent( prev_indent )
end

function sandbox:do_input_ef_satisfaction( action )

	local log_head = "do_input_ef_satisfaction"
	local prev_indent = logger:inc_indent()
	local added, removed, total = self:user_scripted_ef_satisfaction( action )

	logger( log_head, added, removed, total, action )

	if lib.is_in( action.faction, { "all", "others" } ) then
		if action.faction == "all" then
			if action.degree ~= 0 then
				mod_advice:push( "ef_satisfaction_added_all", added, action.degree )
			else
				mod_advice:push( "ef_satisfaction_removed_all", removed )
			end
		else
			if action.degree ~= 0 then
				mod_advice:push( "ef_satisfaction_added_others", added, action.degree )
			else
				mod_advice:push( "ef_satisfaction_removed_others", removed )
			end
		end
	else
		if action.degree ~= 0 then
			mod_advice:push( "ef_satisfaction_added_faction", self:faction_kr(action.faction), action.degree )
		else
			mod_advice:push( "ef_satisfaction_removed_faction", self:faction_kr(action.faction) )
		end
	end

	logger:set_indent( prev_indent )
end

function sandbox:do_input_ef_job_satisfaction( action )

	local log_head = "do_input_ef_job_satisfaction"
	local prev_indent = logger:inc_indent()
	local added, removed, total = self:user_scripted_ef_job_satisfaction( action )

	logger( log_head, added, removed, total, action )

	if lib.is_in( action.faction, { "all", "others" } ) then
		if action.faction == "all" then
			if action.mode == 0 then
				mod_advice:push( "ef_job_satisfaction_removed_all", removed )
			elseif action.mode == 1 then
				mod_advice:push( "ef_job_satisfaction_reduced_others", added )
			else
				mod_advice:push( "ef_job_satisfaction_ignored_all", added )
			end
		else
			if action.mode == 0 then
				mod_advice:push( "ef_job_satisfaction_removed_others", removed )
			elseif action.mode == 1 then
				mod_advice:push( "ef_job_satisfaction_reduced_others", added )
			else
				mod_advice:push( "ef_job_satisfaction_ignored_others", added )
			end
		end
	else
		if action.mode == 0 then
			mod_advice:push( "ef_job_satisfaction_removed_faction", self:faction_kr(action.faction) )
		elseif action.mode == 1 then
			mod_advice:push( "ef_job_satisfaction_reduced_faction", self:faction_kr(action.faction) )
		else
			mod_advice:push( "ef_job_satisfaction_ignored_faction", self:faction_kr(action.faction) )
		end
	end

	logger:set_indent( prev_indent )
end

function sandbox:do_input_ef_presented( action )

	local query_character = self:find_action_character( action )
	local prev_indent = logger:inc_indent()

	if is_interface( query_character ) then 
		local success = self:user_scripted_ef_presented( action, query_character )
		
		if success then 
			mod_advice:push( "ef_presented_success", self:character_kr(query_character) )
		else
			mod_advice:push( "ef_presented_failed", self:character_kr(query_character) )
		end
	else
		mod_advice:push( "hero_not_found_input", action.hero_kr )
	end
	
	logger:set_indent( prev_indent )
end

		--==============================================================================--
								-- DB Effects Functions --
		--==============================================================================--
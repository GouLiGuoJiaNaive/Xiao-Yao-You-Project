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

local mod_advice = sandbox:get_mod_advice()
local mod_patterns = sandbox:get_mod_patterns()

		--==============================================================================--
								-- Position Titles --
		--==============================================================================--
--[[
['lu_bu_five_elites'] = { kr = "오장", location = "faction", en = "Five Elites", zh = "五豪傑", cn = "五豪傑",
	[1] = '3k_dlc05_ceo_factional_warrior_defeated_zhange_he',
	[2] = '3k_dlc05_ceo_factional_warrior_defeated_zhang_liao',
	[3] = '3k_dlc05_ceo_factional_warrior_defeated_yue_jin',
	[4] = '3k_dlc05_ceo_factional_warrior_defeated_yu_jin',
	[5] = '3k_dlc05_ceo_factional_warrior_defeated_xu_huang' },
]]--

sandbox.db_positions_kr = {}

sandbox.db_positions =
{
	['all'] = { dlc =  "all", en = "all", kr = "모든", zh = "一切",cn = "一切", threshold = 0, node_key = "all", },

-- wb
                                     ['3k_dlc05_ancillary_title_attendant'] = { dlc =  "wb", en = "Attendant", kr = "종사", zh = "侍中", cn = "中郎", threshold = 2, node_key = "3k_dlc05_ancillary_title_attendant_01", },
                                  ['3k_dlc05_ancillary_title_blood_dragon'] = { dlc =  "wb", en = "Blood Dragon", kr = "혈룡", zh = "血龍", cn = "血龙", threshold = 2, node_key = "3k_dlc05_ancillary_title_blood_dragon_01", },
                              ['3k_dlc05_ancillary_title_chief_of_records'] = { dlc =  "wb", en = "Chief of Records", kr = "사관", zh = "主簿", cn = "太常丞", threshold = 2, node_key = "3k_dlc05_ancillary_title_chief_of_records_01", },
                                 ['3k_dlc05_ancillary_title_coiled_dragon'] = { dlc =  "wb", en = "Coiled Dragon", kr = "장룡", zh = "蟠龍", cn = "蟠龙", threshold = 2, node_key = "3k_dlc05_ancillary_title_coiled_dragon_01", },
                         ['3k_dlc05_ancillary_title_director_of_astronomy'] = { dlc =  "wb", en = "Director of Astronomy", kr = "천문관장", zh = "星象師", cn = "太史令", threshold = 4, node_key = "3k_dlc05_ancillary_title_director_of_astronomy_01", },
['3k_dlc05_ancillary_title_director_of_retainers_who_scales_the_city_wall'] = { dlc =  "wb", en = "Commander Who Scales City Walls", kr = "축성장군", zh = "司隸緣城", cn = "厉锋将军", threshold = 11, node_key = "3k_dlc05_ancillary_title_director_of_retainers_who_scales_the_city_wall_01", },
                          ['3k_dlc05_ancillary_title_divine_mathematician'] = { dlc =  "wb", en = "Attending Secretary", kr = "주부", zh = "侍御史", cn = "少府丞", threshold = 2, node_key = "3k_dlc05_ancillary_title_divine_mathematician_01", },
                              ['3k_dlc05_ancillary_title_divine_physician'] = { dlc =  "wb", en = "Doctor Who Prevents Disaster", kr = "응급의", zh = "消災名醫", cn = "防患良医", threshold = 6, node_key = "3k_dlc05_ancillary_title_divine_physician_01", },
                                  ['3k_dlc05_ancillary_title_earth_dragon'] = { dlc =  "wb", en = "Earth Dragon", kr = "지룡", zh = "地龍", cn = "青龙", threshold = 2, node_key = "3k_dlc05_ancillary_title_earth_dragon_01", },
                        ['3k_dlc05_ancillary_title_flying_swallow_general'] = { dlc =  "wb", en = "Flying Swallow General", kr = "비연장군", zh = "飛燕將軍", cn = "飞燕", threshold = 2, node_key = "3k_dlc05_ancillary_title_flying_swallow_general_01", },
                              ['3k_dlc05_ancillary_title_general_in_chief'] = { dlc =  "wb", en = "General Commander", kr = "아장", zh = "司馬", cn = "司马", threshold = 2, node_key = "3k_dlc05_ancillary_title_general_in_chief_01", },
                ['3k_dlc05_ancillary_title_general_of_a_hundred_victories'] = { dlc =  "wb", en = "General Who Exterminates Adversaries", kr = "백승장군", zh = "討虜將軍", cn = "横野将军", threshold = 101, node_key = "3k_dlc05_ancillary_title_general_of_a_hundred_victories_01", },
               ['3k_dlc05_ancillary_title_general_of_chariots_and_cavalry'] = { dlc =  "wb", en = "General of Chariots and Cavalry", kr = "거기장군", zh = "車騎將軍", cn = "车骑将军", threshold = 11, node_key = "3k_dlc05_ancillary_title_general_of_chariots_and_cavalry_01", },
                     ['3k_dlc05_ancillary_title_general_of_flying_cavalry'] = { dlc =  "wb", en = "General-in-Chief", kr = "비장", zh = "大將軍", cn = "大将军", threshold = 2, node_key = "3k_dlc05_ancillary_title_general_of_flying_cavalry_01", },
                    ['3k_dlc05_ancillary_title_general_of_heavenly_vision'] = { dlc =  "wb", en = "General of Unfailing Aim", kr = "천위장군", zh = "天威將軍", cn = "射声校尉", threshold = 11, node_key = "3k_dlc05_ancillary_title_general_of_heavenly_vision_01", },
                          ['3k_dlc05_ancillary_title_general_of_the_front'] = { dlc =  "wb", en = "General of the Front", kr = "전장군", zh = "前將軍", cn = "前将军", threshold = 2, node_key = "3k_dlc05_ancillary_title_general_of_the_front_01", },
                         ['3k_dlc05_ancillary_title_general_of_the_guards'] = { dlc =  "wb", en = "General of the Guards", kr = "위장군", zh = "衛將軍", cn = "卫将军", threshold = 11, node_key = "3k_dlc05_ancillary_title_general_of_the_guards_01", },
                           ['3k_dlc05_ancillary_title_general_of_the_left'] = { dlc =  "wb", en = "General of the Left", kr = "좌장군", zh = "左將軍", cn = "左将军", threshold = 2, node_key = "3k_dlc05_ancillary_title_general_of_the_left_01", },
                          ['3k_dlc05_ancillary_title_general_of_the_right'] = { dlc =  "wb", en = "General of the Right", kr = "우장군", zh = "右將軍", cn = "右将军", threshold = 2, node_key = "3k_dlc05_ancillary_title_general_of_the_right_01", },
                       ['3k_dlc05_ancillary_title_general_of_the_standard'] = { dlc =  "wb", en = "General of the Standard", kr = "무위장군", zh = "鎮軍將軍", cn = "镇军将军", threshold = 11, node_key = "3k_dlc05_ancillary_title_general_of_the_standard_01", },
  ['3k_dlc05_ancillary_title_general_who_brings_tranquillity_to_the_north'] = { dlc =  "wb", en = "General Who Gives Tranquillity to the North", kr = "정북장군", zh = "鎮北將軍", cn = "镇北将军", threshold = 6, node_key = "3k_dlc05_ancillary_title_general_who_brings_tranquillity_to_the_north_01", },
                   ['3k_dlc05_ancillary_title_general_who_calms_the_waves'] = { dlc =  "wb", en = "General Who Calms the Waves", kr = "평파장군", zh = "伏波將軍", cn = "伏波将军", threshold = 2, node_key = "3k_dlc05_ancillary_title_general_who_calms_the_waves_01", },
                ['3k_dlc05_ancillary_title_general_who_pacifies_the_south'] = { dlc =  "wb", en = "General Who Pacifies the South", kr = "정남장군", zh = "平南將軍", cn = "平南将军", threshold = 6, node_key = "3k_dlc05_ancillary_title_general_who_pacifies_the_south_01", },
              ['3k_dlc05_ancillary_title_general_who_smashes_the_caitiffs'] = { dlc =  "wb", en = "General Who Smashes the Caitiffs", kr = "파로장군", zh = "破虜將軍", cn = "破虏将军", threshold = 11, node_key = "3k_dlc05_ancillary_title_general_who_smashes_the_caitiffs_01", },
                 ['3k_dlc05_ancillary_title_general_who_stands_his_ground'] = { dlc =  "wb", en = "General Who Stands His Ground", kr = "안중장군", zh = "鎮遠將軍", cn = "镇远将军", threshold = 2, node_key = "3k_dlc05_ancillary_title_general_who_stands_his_ground_01", },
                  ['3k_dlc05_ancillary_title_general_who_supports_the_han'] = { dlc =  "wb", en = "General Who Supports the Han", kr = "보한장군", zh = "輔漢將軍", cn = "辅汉将军", threshold = 11, node_key = "3k_dlc05_ancillary_title_general_who_supports_the_han_01", },
               ['3k_dlc05_ancillary_title_general_whom_expands_the_centre'] = { dlc =  "wb", en = "General Whom Expands the Centre", kr = "평중장군", zh = "中將軍", cn = "中军将军", threshold = 6, node_key = "3k_dlc05_ancillary_title_general_whom_expands_the_centre_01", },
                          ['3k_dlc05_ancillary_title_gold_spotted_leopard'] = { dlc =  "wb", en = "Gold-covered Thief", kr = "금전표적", zh = "錦衣賊", cn = "锦帆贼", threshold = 15001, node_key = "3k_dlc05_ancillary_title_gold_coin_spotted_leopard_01", },
                   ['3k_dlc05_ancillary_title_guardian_of_three_mountains'] = { dlc =  "wb", en = "Protector of the Three Realms", kr = "삼주수장", zh = "三界戍衛", cn = "三境守护", threshold = 2, node_key = "3k_dlc05_ancillary_title_guardian_of_three_mountains_01", },
                                  ['3k_dlc05_ancillary_title_iron_general'] = { dlc =  "wb", en = "Iron General", kr = "철혈장군", zh = "鐵將軍", cn = "铁血城隍", threshold = 11, node_key = "3k_dlc05_ancillary_title_iron_general_01", },
                               ['3k_dlc05_ancillary_title_lord_of_thunder'] = { dlc =  "wb", en = "Lord of Thunder", kr = "뇌공", zh = "雷公", cn = "扫秽雷公", threshold = 2, node_key = "3k_dlc05_ancillary_title_lord_of_thunder_01", },
                            ['3k_dlc05_ancillary_title_master_of_the_hunt'] = { dlc =  "wb", en = "Master of the Hunt", kr = "추적자", zh = "獵官", cn = "嗔恚仇魂", threshold = 2, node_key = "3k_dlc05_ancillary_title_master_of_the_hunt_01", },
                             ['3k_dlc05_ancillary_title_master_of_writing'] = { dlc =  "wb", en = "Master of Writing", kr = "박사", zh = "尚書", cn = "尚书", threshold = 2, node_key = "3k_dlc05_ancillary_title_master_of_writing_01", },
                                        ['3k_dlc05_ancillary_title_orator'] = { dlc =  "wb", en = "Orator", kr = "세객", zh = "說客", cn = "县长史", threshold = 2, node_key = "3k_dlc05_ancillary_title_orator_01", },
                               ['3k_dlc05_ancillary_title_ox_horn_general'] = { dlc =  "wb", en = "Ox-horn General", kr = "우각장군", zh = "牛角將軍", cn = "牛角", threshold = 11, node_key = "3k_dlc05_ancillary_title_ox_horn_general_01", },
                           ['3k_dlc05_ancillary_title_pacifier_of_the_han'] = { dlc =  "wb", en = "Pacifier of the Han", kr = "한평정자", zh = "安漢公", cn = "安汉公", threshold = 21, node_key = "3k_dlc05_ancillary_title_grand_design_to_pacify_the_han_01", },
                              ['3k_dlc05_ancillary_title_patrol_commander'] = { dlc =  "wb", en = "Patrol Commander", kr = "교위", zh = "巡哨長", cn = "郎中骑将", threshold = 2, node_key = "3k_dlc05_ancillary_title_patrol_commander_01", },
                    ['3k_dlc05_ancillary_title_protector_of_righteousness'] = { dlc =  "wb", en = "General of Heavenly Benevolence", kr = "천의장군", zh = "天儀將軍 ", cn = "昭德将军", threshold = 16, node_key = "3k_dlc05_ancillary_title_protector_of_righteousness_01", },
                                ['3k_dlc05_ancillary_title_senior_officer'] = { dlc =  "wb", en = "Senior Officer", kr = "부장", zh = "資深官員", cn = "别部司马", threshold = 2, node_key = "3k_dlc05_ancillary_title_senior_officer_01", },
                 ['3k_dlc05_ancillary_title_steward_of_the_changle_palace'] = { dlc =  "wb", en = "Steward of the Changle Palace", kr = "장락궁의 보루", zh = "長樂少府", cn = "长乐少府", threshold = 2, node_key = "3k_dlc05_ancillary_title_steward_of_the_changle_palace_01", },
                                 ['3k_dlc05_ancillary_title_yellow_dragon'] = { dlc =  "wb", en = "Yellow Dragon", kr = "황룡", zh = "黃龍", cn = "黄龙", threshold = 6, node_key = "3k_dlc05_ancillary_title_yellow_dragon_01", },
-- wb 41
-- position titles out 41
}

					-- ====================================================== --
									-- Title DB functions --
					-- ====================================================== --


function sandbox:position_kr( ceo_key, node_key )

if __game_mode >= 0 then
	node_key = node_key or self:get_ceo_node_key( ceo_key )

	return effect.get_localised_string( self:ceo_node_title_key( node_key ) )
else
	return self.db_positions[ ceo_key ][loc:get_locale()]
end
end

function sandbox:positon_to_ceo_key( input_key )

	if self.db_positions_kr[ input_key ] then
		return self.db_positions_kr[ input_key ]
	end

	if self.db_positions[ input_key ] then
		return input_key
	end
	
	return nil
end

function sandbox:action_positon_to_ceo_key( action )

	local log_head = "action_positon_to_ceo_key"
	logger:verbose( log_head, action )
	
	local ceo_key = self:positon_to_ceo_key( action.input )
	
	if ceo_key then
		action.ceo_key = ceo_key
		action.node_key = self.db_positions[ ceo_key ].node_key
		
		logger:verbose( log_head, action )
		
		return action.ceo_key
	end
end

			-- ====================================================== --
							-- Read user script command --
			-- ====================================================== --

function sandbox:read_user_action_add_position( line )
	
	local log_head = "read_user_action_add_position"
	local faction, input, turn = string.match( line, mod_patterns( "add_position" )  );

	if not faction or not input then
		logger:warn( log_head, "pattern mismatch", line );
		
		return nil;
	end
	
	local action = self:create_action( "add_position" )
	
	action.input = input
	self:action_positon_to_ceo_key( action )
	
	if not action.node_key then
		logger:warn( log_head, "position node_key not found", action )
		
		return nil, loc:format( "add_position_not_found", input )
	end

	action.faction = self:input_to_faction_key( faction )
	
	if not action.faction or lib.is_in( action.faction, { "all", "others" } ) then
		logger:warn( log_head, faction, "faction not found", line )
		
		return nil, loc:format( "faction_not_found", faction )
	end
	
	action.turn = lib.numberorone( turn )

	logger:dev( log_head, action.command, action );

	return action
end

function sandbox:user_scripted_add_position( action, query_faction, quiet )

	if quiet then logger:set_quiet( true ) end

	local log_head = "user_scripted_add_position"
	
	query_faction = query_faction or sandbox:query_faction( action.faction )
	
	local prev_indent = logger:inc_indent()
	logger( log_head, self:faction_kr( query_faction ), action )

	local r_ceo_key, r_node_key, r_points = nil, nil, 0
	
	if self:is_faction_ceo_managable( query_faction ) then
		
		if not action.ceo_key then self:action_positon_to_ceo_key( action ) end
		local category_position = "3k_dlc05_ceo_category_ancillary_titles"		
		if action.ceo_key == 'all' then
			--
			for ceo_key, row in pairs( self.db_positions ) do
				if ceo_key ~= 'all' then
					-----------------------------------------------------------------------------------------------
					self:faction_change_points_of_ceos( query_faction, category_position, ceo_key, row.threshold )
					-----------------------------------------------------------------------------------------------
				end
			end
			--
			r_ceo_key, r_node_key, r_points = 'all', 'all', 0
		elseif action.ceo_key then
			local threshold = self.db_positions[ action.ceo_key ].threshold
			
			logger:debug( log_head, action.ceo_key, threshold )
			----------------------------------------------------------------
			self:faction_change_points_of_ceos( query_faction, category_position, action.ceo_key, threshold )
			----------------------------------------------------------------
			
			r_ceo_key, r_node_key, r_points = action.ceo_key, action.node_key, threshold
		else
			logger:error( log_head, _to( action.input, "ceo_key", "not found") )
		end
	else
		logger:error( log_head, action.input, "not found or invalid management" )
	end

	if quiet then logger:set_quiet( false ) end

	logger:set_indent( prev_indent )
	
	return r_ceo_key, r_node_key, r_points
end

function sandbox:do_input_add_position( action )

	local log_head = "do_input_add_position"
	
	logger:trace( log_head, action )
	local prev_indent = logger:inc_indent()
	
	local query_faction = sandbox:query_faction( action.faction )

	if self:is_faction_ceo_managable( query_faction ) then
		local call_indent = logger:inc_indent()
		--------------------------------------------------------------------------------------------
		local new_ceo_key, new_node_key = self:user_scripted_add_position( action, query_faction, false )
		--------------------------------------------------------------------------------------------
		logger:set_indent( call_indent )
		
		if new_ceo_key == 'all' then
			mod_advice:push( "add_position_added", self:faction_kr( query_faction ), self.db_positions['all'][loc:get_locale()] )
		elseif lib.not_empty( new_ceo_key ) and new_node_key == action.node_key then
			local position_kr = self:position_kr( new_ceo_key, new_node_key )
			
			mod_advice:push( "add_position_added", self:faction_kr( query_faction ), position_kr )
		elseif action.ceo_key then
			mod_advice:push( "add_position_failed", self:faction_kr( query_faction ) )
		else
			mod_advice:push( "add_position_not_found", action.input )
		end
	else
		mod_advice:push( "ceo_character_unmanagable", action.input )
	end
	
	logger:set_indent( prev_indent )
end

				-- ====================================================== --
								-- Position Title DB functions --
				-- ====================================================== --

function sandbox:build_postion_aliases()

	self.db_positions_kr = {}
	
	local log_head = "build_postion_aliases"
	local count = 0

	for ceo_key, title in pairs( self.db_positions ) do
		---------------------------
		title.ceo_key = ceo_key
		---------------------------
		local alias_en = title.en:gsub( "%s", "" ):lower()
		local alias_kr = title.kr:gsub( "%s", "" )

		self.db_positions_kr[ alias_en ] = ceo_key
		self.db_positions_kr[ alias_kr ] = ceo_key
		self.db_positions_kr[ title.zh ] = ceo_key
		self.db_positions_kr[ title.cn ] = ceo_key
		
		count = count + 1
	end

	logger:info( log_head, count )
end
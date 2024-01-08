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

---------------------------------------------------------------------------------------------

sandbox.db_users = {}
sandbox.auto_register_banned =
{
	['3k_mtu_template_ancestral_ma'] = true,	-- 마씨 (마등)
}

sandbox.unique_items = {}
sandbox.except_items = {}
sandbox.refined_items = {}
sandbox.common_items = {}

sandbox.ep_unique_items = {}
sandbox.ep_except_items = {}

sandbox.user_gatherings = {}
sandbox.user_weights = {}

			---===================================================================--
									-- Heroes Aliasing --
			---===================================================================--

local conflictions = {

	['고유']	= { [1] = { en_key = "gao_you", dlc = "moh" }, [2] = { en_key = "gao_rou", dlc = "main" } },
	['노숙']	= { [1] = { en_key = "lu_su", dlc = "main" }, [2] = { en_key = "lu_shu", dlc = "main" } },
	['노식']	= { [1] = { en_key = "lu_zhi", dlc = "moh" }, [2] = { en_key = "lu_zhi_m", dlc = "main" } },
	['석위']	= { [1] = { en_key = "shi_wei_w", dlc = "main" }, [2] = { en_key = "shi_wei_f", dlc = "ep" } },

	['양봉']	= { [1] = { en_key = "yang_feng", dlc = "fw" }, [2] = { en_key = "yang_feng_w", dlc = "main" } },
	['엄여']	= { [1] = { en_key = "yan_yu", dlc = "main" }, [2] = { en_key = "yan_yu_w", dlc = "main" } },
	['오경']	= { [1] = { en_key = "wu_jing", dlc = "main" }, [2] = { en_key = "wu_qiong", dlc = "moh" } },
	['위관']	= { [1] = { en_key = "wei_guan", dlc = "ep" }, [2] = { en_key = "wei_guan_f", dlc = "ep" } },
	['왕기']	= { [1] = { en_key = "wang_ji", dlc = "main" }, [2] = { en_key = "wang_qi", dlc = "main" } },
	['왕숙']	= { [1] = { en_key = "wang_su", dlc = "main" }, [2] = { en_key = "wang_su_m", dlc = "main" } },

	['유기']	= { [1] = { en_key = "liu_qi", dlc = "main" }, [2] = { en_key = "liu_ji_w", dlc = "main" }, [3] = { en_key = "liu_ji_f", dlc = "main" } },
	['유승']	= { [1] = { en_key = "liu_cheng", dlc = "main" }, [2] = { en_key = "liu_cheng_e", dlc = "moh" } },
	['유정']	= { [1] = { en_key = "liu_jing", dlc = "main" }, [2] = { en_key = "liu_zhen", dlc = "main" } },
	['유협']	= { [1] = { en_key = "liu_xie", dlc = "main" }, [2] = { en_key = "liu_xie_e", dlc = "moh" } },
	['육기']	= { [1] = { en_key = "li_ji_w", dlc = "main" }, [2] = { en_key = "lu_ji_w", dlc = "ep" } },
	['육준']	= { [1] = { en_key = "lu_jun", dlc = "moh" }, [2] = { en_key = "lu_jun_e", dlc = "moh" } },
	['임기']	= { [1] = { en_key = "ren_qi", dlc = "main" }, [2] = { en_key = "ren_kui", dlc = "main" } },
	['유훈']	= { [1] = { en_key = "liu_xun", dlc = "main" }, [2] = { en_key = "liu_xun_m", dlc = "dlc07" } },
	['유범']	= { [1] = { en_key = "liu_fan", dlc = "main" }, [2] = { en_key = "liu_fan_e", dlc = "dlc07" } },
	['유부인'] = { [1] = { en_key = "lady_liu", dlc = "main" }, [2] = { en_key = "lady_liu_z", dlc = "dlc07" } },

--[[
  Error : build_heroes_link, 유훈, en_key duplicated { liu_xun -> 3k_dlc07_template_generated_liu_xun_metal }, 3k_dlc04_template_historical_liu_xun_fire, 유훈
  Error : build_heroes_link, 유범, en_key duplicated { liu_fan -> 3k_dlc07_template_historical_liu_fan_hero_earth }, 3k_main_template_historical_liu_fan_hero_fire, 유범
]]
	['장방']	= { [1] = { en_key = "zhang_fang", dlc = "wb" }, [2] = { en_key = "zhang_fang_w", dlc = "wb" }, [3] = { en_key = "zhang_fang_f", dlc = "ep" } },
	['장양']	= { [1] = { en_key = "zhang_yang", dlc = "main" }, [2] = { en_key = "zhang_rang", dlc = "moh" } },
	['장진']	= { [1] = { en_key = "zhang_jin", dlc = "main" }, [2] = { en_key = "zhang_zhen", dlc = "main" } },
	['장천']	= { [1] = { en_key = "zhang_quan", dlc = "main" }, [2] = { en_key = "zhang_jian", dlc = "main" } },
	['장패']	= { [1] = { en_key = "zang_ba", dlc = "main" }, [2] = { en_key = "zhang_ba", dlc = "main" } },

	['정보']	= { [1] = { en_key = "cheng_pu", dlc = "main" }, [2] = { en_key = "zheng_bao", dlc = "main" } },
	['조앙']	= { [1] = { en_key = "cao_ang", dlc = "main" }, [2] = { en_key = "zhao_ang", dlc = "main" } },
	['조예']	= { [1] = { en_key = "cao_rui", dlc = "main" }, [2] = { en_key = "zhao_rui", dlc = "main" } },
	['조충']	= { [1] = { en_key = "cao_chong", dlc = "main" }, [2] = { en_key = "zhao_zhong", dlc = "moh" } },
	['조홍']	= { [1] = { en_key = "cao_hong", dlc = "main" }, [2] = { en_key = "zhao_hong", dlc = "moh" } },
	['주환']	= { [1] = { en_key = "zhu_huan", dlc = "main" }, [2] = { en_key = "zhou_huan", dlc = "main" } },

	['주지']	= { [1] = { en_key = "zhou_zhi", dlc = "main" }, [2] = { en_key = "zhu_zhi_m", dlc = "main" } },

   ['정부인']	= { [1] = { en_key = "lady_ding", dlc = "moh" }, [2] = { en_key = "lady_cheng", dlc = "ep" } },

   ['사마의']	= { [1] = { en_key = "sima_yi", dlc = "main" }, [2] = { en_key = "sima_yi_w", dlc = "ep" }, [3] = { en_key = "sima_yi_e", dlc = "ep" } },

   ['사마예']	= { [1] = { en_key = "sima_ai", dlc = "ep" }, [2] = { en_key = "sima_rui_e", dlc = "ep" } },
   ['사마영']	= { [1] = { en_key = "sima_ying", dlc = "ep" }, [2] = { en_key = "sima_ying_m", dlc = "ep" } },
   ['사마태']	= { [1] = { en_key = "sima_tai", dlc = "ep" }, [2] = { en_key = "sima_tai_f", dlc = "ep" } },
   ['사마위']	= { [1] = { en_key = "sima_wei", dlc = "ep" }, [2] = { en_key = "sima_wei_f", dlc = "ep" } },
   ['사마검']	= { [1] = { en_key = "sima_jian", dlc = "ep" }, [2] = { en_key = "sima_jian_e", dlc = "ep" } },
   ['사마수']	= { [1] = { en_key = "sima_cui", dlc = "ep" }, [2] = { en_key = "sima_sui", dlc = "ep" } },
   ['사마식']	= { [1] = { en_key = "sima_zhi", dlc = "ep" }, [2] = { en_key = "sima_shi_w", dlc = "ep" } },
   ['사마보']	= { [1] = { en_key = "sima_pu", dlc = "ep" }, [2] = { en_key = "sima_fu_m", dlc = "ep" } },

   ['王肅']	= { [1] = { en_key = "wang_su", dlc = "main" }, [2] = { en_key = "wang_su_m", dlc = "main" } },
   ['衛瓘']	= { [1] = { en_key = "wei_guan", dlc = "ep" }, [2] = { en_key = "wei_guan_f", dlc = "ep" } },
   ['劉基']	= { [1] = { en_key = "liu_ji_w", dlc = "main" }, [2] = { en_key = "liu_ji_f", dlc = "main" } },
   ['劉協']	= { [1] = { en_key = "liu_xie", dlc = "main" }, [2] = { en_key = "liu_xie_e", dlc = "moh" } },
   ['盧植']	= { [1] = { en_key = "lu_zhi", dlc = "moh" }, [2] = { en_key = "lu_zhi_m", dlc = "main" } },

   ['劉範']	= { [1] = { en_key = "liu_fan", dlc = "main" }, [2] = { en_key = "liu_fan_e", dlc = "dlc07" } },
	['劉夫人'] = { [1] = { en_key = "lady_liu", dlc = "main" }, [2] = { en_key = "lady_liu_z", dlc = "dlc07" } },

   ['陸機']	= { [1] = { en_key = "li_ji_w", dlc = "main" }, [2] = { en_key = "lu_ji_w", dlc = "ep" } },
   ['石偉']	= { [1] = { en_key = "shi_wei_w", dlc = "main" }, [2] = { en_key = "shi_wei_f", dlc = "ep" } },

   ['張方'] = { [1] = { en_key = "zhang_fang", dlc = "wb" }, [2] = { en_key = "zhang_fang_f", dlc = "ep" } },
   ['嚴輿'] = { [1] = { en_key = "yan_yu", dlc = "main" }, [2] = { en_key = "yan_yu_w", dlc = "main" } },

 ['司馬泰']	= { [1] = { en_key = "sima_tai", dlc = "ep" }, [2] = { en_key = "sima_tai_f", dlc = "ep" } },
 ['司馬儀']	= { [1] = { en_key = "sima_yi_w", dlc = "ep" }, [2] = { en_key = "sima_yi_e", dlc = "ep" } },

    ['王肃']	= { [1] = { en_key = "wang_su", dlc = "main" }, [2] = { en_key = "wang_su_m", dlc = "main" } },
    ['卫瓘']	= { [1] = { en_key = "wei_guan", dlc = "ep" }, [2] = { en_key = "wei_guan_f", dlc = "ep" } },
    ['刘基']	= { [1] = { en_key = "liu_ji_w", dlc = "main" }, [2] = { en_key = "liu_ji_f", dlc = "main" } },
    ['刘协']	= { [1] = { en_key = "liu_xie", dlc = "main" }, [2] = { en_key = "liu_xie_e", dlc = "moh" } },
    ['卢植']	= { [1] = { en_key = "lu_zhi", dlc = "moh" }, [2] = { en_key = "lu_zhi_m", dlc = "main" } },

    ['刘范']	= { [1] = { en_key = "liu_fan", dlc = "main" }, [2] = { en_key = "liu_fan_e", dlc = "dlc07" } },
	['刘夫人'] = { [1] = { en_key = "lady_liu", dlc = "main" }, [2] = { en_key = "lady_liu_z", dlc = "dlc07" } },

    ['陆济']	= { [1] = { en_key = "li_ji_w", dlc = "main" }, [2] = { en_key = "lu_ji_w", dlc = "ep" } },
    ['石伟']	= { [1] = { en_key = "shi_wei_w", dlc = "main" }, [2] = { en_key = "shi_wei_f", dlc = "ep" } },

    ['严舆'] = { [1] = { en_key = "yan_yu", dlc = "main" }, [2] = { en_key = "yan_yu_w", dlc = "main" } },
    ['张方'] = { [1] = { en_key = "zhang_fang", dlc = "wb" }, [2] = { en_key = "zhang_fang_f", dlc = "ep" } },

  ['司马泰']	= { [1] = { en_key = "sima_tai", dlc = "ep" }, [2] = { en_key = "sima_tai_f", dlc = "ep" } },
   ['司马仪']	= { [1] = { en_key = "sima_yi_w", dlc = "ep" }, [2] = { en_key = "sima_yi_e", dlc = "ep" } },
  ['司马矩']	= { [1] = { en_key = "sima_ju", dlc = "moh" }, [2] = { en_key = "sima_ju_e", dlc = "ep" } },
}

--[[
{ li_xian -> 3k_dlc05_template_historical_li_xian_hero_metal }
{ shi_yi -> 3k_main_template_historical_shi_yi_hero_metal }
{ yan_yu -> 3k_main_template_historical_yan_yu_hero_water }
{ zhang_fang -> 3k_dlc05_template_historical_zhang_fang_hero_earth }
]]

function sandbox:assign_hero_link( hero_name, hero )

	local db = self.db_heroes
	local db_kr = self.db_heroes_kr
	local dlc_priorities = nil
	local assigned = false

	if self:is_three_kingdoms_early() then
		dlc_priorities = { ['main'] = 1, ['tke'] = 1, ['ytr'] = 2, ['wb'] = 3, ['moh'] = 4, ['fw'] = 5, ['fd'] = 6, ['ep'] = 7 }
	elseif self:is_eight_princes() then
		dlc_priorities = { ['main'] = 2, ['tke'] = 2, ['ytr'] = 3, ['wb'] = 4, ['moh'] = 5, ['fw'] = 6, ['fd'] = 7, ['ep'] = 1 }
	elseif self:is_mandate_of_heaven() then
		dlc_priorities = { ['main'] = 2, ['tke'] = 2, ['ytr'] = 3, ['wb'] = 4, ['moh'] = 1, ['fw'] = 5, ['fd'] = 6, ['ep'] = 7 }
	elseif self:is_world_betrayed() then
		dlc_priorities = { ['main'] = 2, ['tke'] = 2, ['ytr'] = 3, ['wb'] = 1, ['moh'] = 4, ['fw'] = 5, ['fd'] = 6, ['ep'] = 7 }
	elseif self:is_fates_divided() then
		dlc_priorities = { ['main'] = 2, ['tke'] = 2, ['ytr'] = 3, ['wb'] = 4, ['moh'] = 5, ['fw'] = 6, ['fd'] = 1, ['ep'] = 7 }
	else -- unknown
		dlc_priorities = { ['main'] = 1, ['tke'] = 1, ['ytr'] = 2, ['wb'] = 3, ['moh'] = 4, ['fw'] = 5, ['fd'] = 6, ['ep'] = 7 }
	end

	function assign_priority( who, hero_name, assign, en_key )

		for idx, row in pairs( assign ) do
			if row.en_key == en_key then return idx end
		end

		logger:warn( "assign_priority", _eq(who, en_key), "_n", " not found in ['"..hero_name.."']" )

		return 0
	end

	local p_old = assign_priority( "old", hero_name, conflictions[ hero_name ], db[ db_kr[ hero_name ] ].en_key )
	local p_new = assign_priority( "new", hero_name, conflictions[ hero_name ], hero.en_key )

	--logger:trace( hero_name, en_key, db_kr[ hero_name ], db[ en_key ].dlc )

	if db[ db_kr[ hero_name ] ].dlc == hero.dlc then
		if p_old > p_new then
			logger:verbose( string.format( "%14s  \t<< %24s - %-s", hero_name,
				string.format( "(%d.%s) %s", p_new, hero.dlc, hero.en_key ),
				string.format( "%s (%s.%d)", db[db_kr[ hero_name ]].en_key, db[db_kr[ hero_name ]].dlc, p_old )) )
			db_kr[ hero_name ] = hero.template_key
			assigned = true
		else
			logger:verbose( string.format( "%14s  \t|| %24s - %-s", hero_name,
				string.format( "(%d.%s) %s", p_old, db[db_kr[ hero_name ]].dlc, db[db_kr[ hero_name ]].en_key ),
				string.format( "%s (%s.%d)", hero.en_key, hero.dlc, p_new )) )
		end
	elseif dlc_priorities[ db[ db_kr[ hero_name ] ].dlc ] > dlc_priorities[ hero.dlc ] then
		logger:verbose( string.format( "%14s  \t<< %24s - %-s", hero_name,
			string.format( "(%d.%s) %s", p_new, hero.dlc, hero.en_key ),
			string.format( "%s (%s.%d)", db[db_kr[ hero_name ]].en_key, db[db_kr[ hero_name ]].dlc, p_old )) )

		db_kr[ hero_name ] = hero.template_key
		assigned = true
	else
		logger:verbose( string.format( "%14s  \t|| %24s - %-s", hero_name,
			string.format( "(%d.%s) %s", p_old, db[db_kr[ hero_name ]].dlc, db[db_kr[ hero_name ]].en_key ),
			string.format( "%s (%s.%d)", hero.en_key, hero.dlc, p_new )) )
	end
	
	return assigned
end

function sandbox:assign_hero_aliases( hero, remapping )

	local log_head = "assign_hero_aliases"
	local en_key = hero.en_key
	local db = self.db_heroes
	local db_kr = self.db_heroes_kr
	local assigned = true

	if hero.kr and hero.kr ~= "" then
		local hero_name = hero.kr

		if db_kr[ hero_name ] then
			if conflictions[ hero_name ] then
				assigned = self:assign_hero_link( hero_name, hero )
			else
				if not remapping then
					logger:warn( log_head.." - kr", hero_name, db_kr[ hero_name ], "_>:", en_key, "no conflictions table" )
					assigned = false
				elseif hero.template_key ~= db_kr[ hero_name ] then
					logger:warn( log_head.." kr overwrite", _to( hero_name, db_kr[ hero_name ], en_key ) )
					db_kr[ hero_name ] = hero.template_key
				end
			end
		else
			db_kr[ hero_name ] = hero.template_key
		end
	end

	if loc:get_locale() ~= "cn" and hero.zh and hero.zh ~= "" and hero.zh ~= hero.kr then
		local hero_name = hero.zh

		if db_kr[ hero_name ] then
			if conflictions[ hero_name ] then
				self:assign_hero_link( hero_name, hero )
				assigned = true
			else
				if not remapping then
					logger:warn( log_head.." zh - kr", hero_name, db_kr[ hero_name ], "_>:", en_key, "no conflictions table" )
					assigned = false
				elseif hero.template_key ~= db_kr[ hero_name ] then
					logger:warn( log_head.." zh overwrite", _to( hero_name, db_kr[ hero_name ], en_key ) )
					db_kr[ hero_name ] = hero.template_key
				end
			end
		else
			db_kr[ hero_name ] = hero.template_key
		end
	end

	if loc:get_locale() ~= "zh" and hero.cn and hero.cn ~= "" and hero.cn ~= hero.zh then
		local hero_name = hero.cn

		if db_kr[ hero_name ] then
			if conflictions[ hero_name ] then
				self:assign_hero_link( hero_name, hero )
			else
				if not remapping then
					logger:warn( log_head.." cn - zh", hero_name, db_kr[ hero_name ], "_>:", en_key, "no conflictions table" )
					assigned = false
				elseif hero.template_key ~= db_kr[ hero_name ] then
					logger:warn( log_head.." cn overwrite", _to( hero_name, db_kr[ hero_name ], en_key ) )
					db_kr[ hero_name ] = hero.template_key
				end
			end
		else
			db_kr[ hero_name ] = hero.template_key
		end
	end
	
	if hero.en_key == hero.en:lower():gsub( " ", "_" ) then
		local en_name = hero.en:gsub( "%s", "" ):lower()
		db_kr[ en_name ] = hero.template_key
	end
end
				---===============================================================--
									-- Re-indexing DB --
				---===============================================================--

function sandbox:global_db_reindexing()

	local log_head = "Global DB Reindexing"
	local found, updated, not_found, searched_cqi, last_cqi, is_dead, is_spy, is_pool, new_hero_count = 0, 0, 0, 0, 0, 0, 0, 0, 0

	local t_deads, t_spies, t_pools, d_pools = {}, {}, {}, {}

	logger:mline( "=", log_head, true )

	--3k_main_template_historical_huang_gai_hero_wood
	--3k_cp01_template_historical_huang_gai_hero_fire

	local all_general_list = sandbox:query_world():character_list():filter(
				function( hero ) return hero:character_type("general")
			end )
	local all_count = all_general_list:num_items()

	--logger:inspect( "3k_mtu_template_historical_li_ru_hero_water", self.db_heroes[ "3k_mtu_template_historical_li_ru_hero_water" ] )

	for i = 0, all_count - 1 do

		local query_character = all_general_list:item_at( i )
		local template_key = query_character:generation_template_key()

		if self.db_heroes[ template_key ] then

			--logger:out( self:character_kr(query_character), query_character:generation_template_key())

			last_cqi = query_character:cqi()

			if (self.db_heroes[ template_key ].cqi or 0) ~= query_character:cqi()
				and not query_character:is_dead()
			then

				local other_character = nil
				local update = true

				if self.db_heroes[ template_key ].cqi then
					other_character = sandbox:query_character( self.db_heroes[ template_key ].cqi )
				end

				if is_interface( other_character )
					and not other_character:is_dead()
					and not other_character:is_spy()
				then
					if other_character:generation_template_key() == query_character:generation_template_key() then
						if other_character:cqi() < query_character:cqi() then
							update = false
						end
					end
				end

				if update then

					logger:verbose( string.format( "%16s %10s %3d %10s -> %-10s %3d %10s %s",
						self.db_heroes[ template_key ].en_key,
						(self.db_heroes[ template_key ].startpos_id or ""), tostring(self.db_heroes[ template_key ].cqi or 0),
						self.db_heroes[ template_key ][ loc:get_locale() ], self:character_kr( query_character ),
						tostring(query_character:cqi()), query_character:startpos_key(), template_key ) )

					self.db_heroes[ template_key ].cqi = query_character:cqi();
					self.db_heroes[ template_key ].startpos_id = lib.emptytonil( query_character:startpos_key() );

					updated = updated + 1

				else

					logger:verbose( string.format( "%16s %10s %3d %10s -X %-10s %3d %10s %s",
						self.db_heroes[ template_key ].en_key,
						(self.db_heroes[ template_key ].startpos_id or ""), tostring(self.db_heroes[ template_key ].cqi or 0),
						self.db_heroes[ template_key ][ loc:get_locale() ], self:character_kr( query_character ),
						tostring(query_character:cqi()), query_character:startpos_key(), template_key ) )
				end

				local char_element = self.tk_hero_subtype_to_element[ query_character:character_subtype_key() ]

				if not self.tk_hero_classes[ char_element ]
					or self.tk_hero_classes[ char_element ].element ~= self.tk_hero_classes[ self.db_heroes[ template_key ].element ].element
				then
					logger:info( log_head, self.db_heroes[ template_key ].en_key, self:character_kr( query_character ), _to( "element", self.db_heroes[ template_key ].element, char_element ) )
					self.db_heroes[ template_key ].element = char_element
				end

				if not self.db_heroes[ template_key ].birth then
					self.db_heroes[ template_key ].birth = self:campaign_start_year() - query_character:age()
				end

				found = found + 1;
			end -- cqi changed

			if query_character:is_dead() then
				is_dead = is_dead + 1

				self.db_heroes[ template_key ].cqi = nil

				if self.db_heroes[ template_key ].named then
					table.insert( t_deads, query_character )
				end
			end

			if query_character:is_spy() then
				is_spy = is_spy + 1
				table.insert( t_spies, query_character )
			end

			if query_character:is_character_is_faction_recruitment_pool() then
				is_pool = is_pool + 1

				if self.db_heroes[ template_key ].named then
					table.insert( t_pools, query_character )
				elseif self.this_turn == 1 then
					table.insert( d_pools, query_character )
				end
			end
		-- is db_heroes --
		elseif not query_character:is_dead()
			and query_character:character_type( "general" )
			and not self:is_clone_template_key( template_key )
			and not self.auto_register_banned[ template_key ]
		then
			------------------------------------------------------------
			if self.db_users[ template_key ] then
				self:update_hero_to_db( query_character )
			else
				self:register_new_hero_to_db( query_character )
				new_hero_count = new_hero_count + 1
			end
		else
			-- castellan
			-- scripted, ancestral, generic
		end
	end

	if #t_spies > 0 then
		for _, query_character in pairs( t_spies ) do
			local name_kr = self:character_kr( query_character )
			if not query_character:has_come_of_age() then name_kr = name_kr.."("..query_character:age()..")"
			else name_kr = name_kr.."    " end
			logger:trace( log_head, "spy", "_t", name_kr, "_t", _eq( "cqi", query_character:cqi() ), self:faction_kr( query_character:faction() ) )
		end
	end

	if #t_deads > 0 then
		for _, query_character in pairs( t_deads ) do
			local name_kr = self:character_kr( query_character )
			if not query_character:has_come_of_age() then name_kr = name_kr.."("..query_character:age()..")"
			else name_kr = name_kr.."    " end
			logger:trace( log_head, "dead", "_t", name_kr, "_t", _eq( "cqi", query_character:cqi() ), self:faction_kr( query_character:faction() ), self:death_title( query_character ) )
		end
	end

	if #t_pools > 0 then
		for _, query_character in pairs( t_pools ) do
			local name_kr = self:character_kr( query_character )
			if not query_character:has_come_of_age() then name_kr = name_kr.."("..query_character:age()..")"
			else name_kr = name_kr.."    " end
			logger:trace( log_head, "pool", "_t", name_kr, "_t", _eq( "cqi", query_character:cqi() ), self:faction_kr( query_character:faction() ) )
		end
	end

	if #d_pools > 0 then
		for _, query_character in pairs( d_pools ) do
			local name_kr = self:character_kr( query_character )
			if not query_character:has_come_of_age() then name_kr = name_kr.."("..query_character:age()..")"
			else name_kr = name_kr.."    " end
			logger:dev( log_head, "pool", "_t", name_kr, "_t", _eq( "cqi", query_character:cqi() ), self:faction_kr( query_character:faction() ) )
		end
	end

	local all_character_list = sandbox:query_world():character_list()
	local castellan_list = sandbox:query_world():character_list():filter( function( hero ) return hero:character_type("castellan") end )
	local others_list = sandbox:query_world():character_list():filter( function( hero ) return not hero:character_type("castellan") and not hero:character_type("general") end )

	local faction_rebels = sandbox:query_model():faction_for_command_queue_index( 1 )
	local faction_rebels_list = faction_rebels:character_list()

	logger:debug( log_head, _eq( "generals", all_count ), _eq( "castellans", castellan_list:num_items() ), _eq( "others", others_list:num_items() ), _eq( "all characters", all_character_list:num_items() ), _eq( faction_rebels:name(), faction_rebels_list:num_items()) )
	logger:debug( log_head, _eq( "all", all_count ), _eq( "updated", updated ), _eq( "last_hero", last_cqi ), _eq( "found", found ), _eq( "pool", #t_pools.."/"..is_pool ), _eq( "spy", is_spy ), _eq( "new hero", new_hero_count ), _eq( "dead", is_dead ) )
	logger:mline( "=", log_head.."[ "..self.this_turn.." ]", true )

	t_deads, t_spies, t_pools, d_pools = nil, nil, nil, nil
	all_character_list, all_general_list, castellan_list, others_list = nil, nil, nil, nil
end

sandbox.db_alias_ban_list = {
	"ep_template_historical_empress_jia_dummy",
	"ep_template_ancestral_sima_yi_runan",
	"3k_main_template_historical_huang_gai_hero_wood", -- 황개
	"3k_main_template_historical_lu_zhi_hero_metal", -- 노식
	"3k_main_template_historical_li_xian_hero_fire", -- 이섬
	"3k_main_template_historical_wei_guan_hero_fire", -- 위관
	"3k_main_template_historical_xun_you_hero_earth", -- 순유
	"3k_main_template_historical_wei_yan_hero_fire", -- 위연
	"3k_dlc06_template_historical_king_shamoke_hero_nanman_194", -- 사마가
}

function sandbox:allocate_hero_alias( row, force )
	force = not not force

	local db_kr = self.db_heroes_kr
	-----------------------------------------------------
	if row.kr and row.kr ~= "" then db_kr[ row.kr ] = row.template_key end
	if row.zh and row.zh ~= "" then db_kr[ row.zh ] = row.template_key end
	if row.cn and row.cn ~= "" then db_kr[ row.cn ] = row.template_key end
	if row.en and row.en ~= "" then
		local en_name = row.en:gsub("%s", ""):lower()
		if force or not db_kr[ en_name ] or row.named then db_kr[ en_name ] = row.template_key end
	end
	-----------------------------------------------------
end

function sandbox:build_heroes_link( db_heroes )

	local log_head = "build_heroes_link"
	local db_kr = self.db_heroes_kr
	local count, total, assign_count, banned_count = 0, 0, 0, 0
	local prev_indent = logger:inc_indent()

	for template_key, row in pairs( db_heroes ) do

		row.template_key = template_key

		if lib.not_in( template_key, self.db_alias_ban_list ) then

			if not db_kr[ row.en_key ] then
				db_kr[ row.en_key ] = template_key
			else
				logger:error( log_head, row.kr, _to( "en_key duplicated", row.en_key, db_kr[ row.en_key ] ), template_key, db_heroes[template_key].kr )
			end

			if (row.kr and row.kr ~= "" and not db_kr[ row.kr ])
				and (row.zh and row.zh ~= "" and not db_kr[ row.zh ])
				and (row.cn and row.cn ~= "" and not db_kr[ row.cn ])
				and (row.en and row.en ~= "" and not db_kr[ row.en:gsub("%s", ""):lower() ])
			then
				-----------------------------------------------------
				self:allocate_hero_alias( row )
				-----------------------------------------------------
				count = count + 1
			else
				-------------------------------------------
				self:assign_hero_aliases( row, row.named )
				-------------------------------------------
				assign_count = assign_count + 1
			end
		else
			banned_count = banned_count + 1
			logger:debug( log_head, "banned", template_key )
		end

		total = total + 1
	end

	self.db_heroes_kr['정난'] 		= "3k_dlc05_template_generated_lady_zhang_jinglan_hero_metal"
	self.db_heroes_kr['정란'] 		= "3k_dlc05_template_generated_lady_zhang_jinglan_hero_metal"

	logger:set_indent( prev_indent )
	logger:info( log_head, string.format( "normal %d/en_key fixed %d/aliased %d/db_heroes %d", count, assign_count, total, lib.table_rows(db_heroes) ), logger:nz("banned", banned_count) )
end

local mod_ban = {
	['tup'] = {
			['3k_main_template_historical_quan_zong_hero_fire'] = true,				-- 전종
		},
	['mtu'] = {
	},
}

local mod_skip = {
	['tup'] = {
			['3k_main_template_historical_liu_bao_hero_earth'] = true,				-- 유표
			['3k_main_template_historical_lady_zhenji_hero_water'] = true,			-- 견부인
			['3k_main_template_historical_zhang_ji_dong_zhou_hero_earth'] = true,	-- 장제(張濟) 후한
		},
	['mtu'] = {
	},
}

function sandbox:build_mod_heroes_link( name, db_heroes )

	local log_head = "build_mod_heroes_link:"..name
	local db_kr = self.db_heroes_kr
	local count, total, assign_count, banned_count, warn_count, err_count = 0, 0, 0, 0, 0, 0

	local prev_indent = logger:inc_indent()

    logger:debug( log_head, name.." heroes = ", "_[:"..lib.table_rows( db_heroes ) )

	for template_key, row in pairs( db_heroes ) do

		if not mod_ban[ name ][ template_key ] then
			local add = true
			row.template_key = template_key

			if self.db_heroes[ template_key ] then
				logger:info( log_head, "db_heroes already has ", row.kr, "_s", template_key )
				warn_count = warn_count + 1
				
				self.db_heroes[ template_key ] = row
			elseif mod_skip[name][template_key] then
				add = false
			else
				self.db_heroes[ template_key ] = row

				if not db_kr[ row.en_key ] then
					db_kr[ row.en_key ] = template_key
				elseif template_key ~= db_kr[ row.en_key ] then
					logger:verbose( log_head, row.en_key, _to( "en_key duplicated", template_key, db_kr[ row.en_key ] ) )

					local prev_db_hero = self.db_heroes[ db_kr[ row.en_key ] ]
					local new_key, orig_key = self:find_new_key_for_db_hero( prev_db_hero )

					if new_key then
						prev_db_hero.en_key = new_key
						db_kr[ prev_db_hero.en_key ] = prev_db_hero.template_key
					end

					db_kr[ row.en_key ] = template_key
				else
					logger:error( log_head, row.en_key, _to( "template_key duplicated", template_key, db_kr[ row.en_key ] ) )
				end
			end

			if template_key == "3k_main_template_historical_zhang_ji_dong_zhou_hero_earth" then
				if self:is_mandate_of_heaven() then
					add = true
				else
					add = false
				end
			end
			
			if add then
				---------------------------------
				self:allocate_hero_alias( row, true )
				---------------------------------
				count = count + 1
			end
		end

		total = total + 1
	end

	logger:set_indent( prev_indent )
	logger:info( name, "sandbox 조범", sandbox.db_heroes_kr[ "조범" ], self.db_heroes[ sandbox.db_heroes_kr[ "조범" ] ] )
	logger:info( log_head, string.format( "%d/en_key fixed %d/aliased %d/db_heroes %d banned %d warn %d error %d",
			count, assign_count, total, lib.table_rows(db_heroes), banned_count, warn_count, err_count ) )
end

function sandbox:clear_db_cqi_links()

	for _, db in ipairs( { self.db_three_kingdoms_heroes, self.db_mandate_heroes, self.db_eight_princes_heroes } ) do
		for _, row in pairs( db ) do
			row.cqi = nil
		end
	end
end

function sandbox:clear_user_db()

	self.db_heroes_kr = {};

	local count = 0

	for template_key, row in pairs( self.db_users ) do

		if self.db_heroes[ template_key ] then self.db_heroes[ template_key ] = nil end

		count = count + 1
	end

	if count > 0 then
		logger:info( "clear_user_db", "clearing user db count = " .. count )
	end

	self.db_users = {}

end

function sandbox:build_db_cross_links()

	self:clear_user_db()
	------------------------------------------------
	self:build_heroes_link( self.db_heroes )
	------------------------------------------------
	if self:is_mod_on( "tup" ) then
		self:build_mod_heroes_link( "tup", self.db_tup_heroes )
		self:build_mod_heroes_link( "mtu", self.db_mtu_heroes )
	elseif self:is_mod_on( "mtu" ) then
		self:build_mod_heroes_link( "mtu", self.db_mtu_heroes )
	end
	------------------------------------------------
	logger:info( "build_db_cross_links", _eq( "db_heroes", lib.table_rows(self.db_heroes)), _eq( "db_heroes_kr", lib.table_rows(self.db_heroes_kr)) )
end
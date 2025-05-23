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

sandbox.db_regions_kr = {}

-- Wei 魏, Shu 蜀, Wu 吳
-- provinces (zhōu 州), commanderies (jùn 郡), counties (xiàn 縣), cities (chéng 城)
-- 國 Guó 国
-- 太守

sandbox.db_regions_building = {
	['district'] = { en = 'District', kr = '도성', zh = '郡治', cn = '城市' },
	['commune'] = { en = 'Commune', kr = '공동체', zh = '集村', cn = '部族聚落' },
	['animal_tamer'] = { en = 'Horse Land', kr = '동물 조련장', zh = '馴獸場', cn = '驯兽场' },
	['horse_land'] = { en = 'Horse Land', kr = '말 목장', zh = '馬場', cn = '马场' },
	['weapon_craftsmen'] = { en = 'Weapon Craftsmen', kr = '무기 수공업자', zh = '武器匠行', cn = '铸兵坊' },
	['lumber_yard'] = { en = 'Lumber Yard', kr = '벌목장', zh = '鋸木場', cn = '贮木场' },
	['rice_paddy'] = { en = 'Rice Paddy', kr = '벼 농장', zh = '稻田', cn = '稻田' },
	['Silk Trader'] = { en = 'District', kr = '비단 거래상', zh = '絲綢商', cn = '锦市' },
	['Temple'] = { en = 'Temple', kr = '사원', zh = '廟宇', cn = '庙宇' },
	['Salt Mine'] = { en = 'Salt Mine', kr = '소금 광산', zh = '鹽礦', cn = '盐矿' },
	['Fishing Port'] = { en = 'Fishing Port', kr = '어획항', zh = '漁港', cn = '渔港' },
	['Jade Mine'] = { en = 'Jade Mine', kr = '옥 광산', zh = '採玉場', cn = '玉矿' },
	['Lumber Mill'] = { en = 'Lumber Mill', kr = '제재소', zh = '伐木場', cn = '伐木场' },
	['Iron Mine'] = { en = 'Iron Mine', kr = '철 광산', zh = '鐵礦', cn = '铁矿' },
	['Livestock Farm'] = { en = 'Livestock Farm', kr = '축사', zh = '牲畜牧場', cn = '畜牧场' },
	['Spice Trader'] = { en = 'Spice Trader', kr = '향신료 교역상', zh = '香料商', cn = '香药商' },
	['Teahouse'] = { en = 'Teahouse', kr = '다관', zh = '茶館', cn = '茶馆' },
}

sandbox.db_states_kr = {}
sandbox.db_states = {
		  ['theg_state_sili'] = { kr = "사례", 	en = "Sili", 	zh = "司隸", cn = "司隶", province_key = '3k_main_province_luoyang',
									provinces = {
										"3k_main_province_luoyang",			-- 하남윤 ( 낙양 )
										"3k_main_province_henei",			-- 하내 ( 회현 )
										"3k_main_province_hedong",			-- 하동 ( 안읍 )
										"3k_dlc06_province_hulao_pass",		-- 호뢰관
										"3k_dlc06_province_hangu_pass",		-- 함곡관
										"3k_dlc06_province_tong_pass",		-- 동관
										"3k_dlc06_province_qi_pass"			-- 기관
									},
		  },
		  ['theg_state_bang'] = { kr = "병주", 	en = "Bang", 	zh = "幷州", cn = "并州", province_key = '3k_main_province_taiyuan',
									provinces = {
										"3k_main_province_taiyuan",			-- 태원 ( 진양 )
										"3k_main_province_shangdang",		-- 상당
										"3k_main_province_xihe",			-- 서하
										"3k_main_province_yanmen",			-- 안문
										"3k_main_province_shoufang",		-- 삭방
										"3k_dlc06_province_gu_pass",		-- 고관 ( 정형관 )
									},
								},
		   ['theg_state_you'] = { kr = "유주", 	en = "You", 	zh = "幽州", cn = "幽州", province_key = '3k_main_province_youzhou',
									provinces = {
										"3k_main_province_youzhou",			-- 광양 ( 계 )
										"3k_dlc06_province_liaodong",		-- 요동
										"3k_main_province_yu",				-- 요서
										"3k_main_province_youbeiping",		-- 우북평
										"3k_main_province_daijun",			-- 대군
									},
								},
			['theg_state_ji'] = { kr = "기주", 	en = "Ji", 		zh = "冀州", cn = "冀州", province_key = '3k_main_province_anping',
									provinces = {
										"3k_main_province_anping",			-- 안평 ( 신도 )
										"3k_main_province_weijun",			-- 위군 ( 업 )
										"3k_main_province_zhongshan",		-- 중산 ( 남피 )
										"3k_main_province_bohai",			-- 발해 ( 노노 )
									},
								},
		  ['theg_state_qing'] = { kr = "청주", 	en = "Qing", 	zh = "靑州", cn = "靑州", province_key = '3k_main_province_beihai',
									provinces = {
										-- 제국
										"3k_main_province_beihai",			-- 북해 ( 극현 )
										"3k_main_province_donglai",			-- 동래 ( 황현 )
										"3k_main_province_pingyuan",		-- 평원
										"3k_main_province_taishan",			-- 낙안 ( 동평릉 ), 구 태산
									},
								},
		   ['theg_state_yan'] = { kr = "연주", 	en = "Yan", 	zh = "兗州", cn = "兗州", province_key = '3k_main_province_dongjun',
									provinces = {
										"3k_main_province_dongjun",			-- 동군 ( 복양 )
									},
								},
			['theg_state_xu'] = { kr = "서주", 	en = "Xu", 		zh = "徐州", cn = "徐州", province_key = '3k_dlc06_province_xiapi',
									provinces = {
										"3k_dlc06_province_xiapi",			-- 하비 ( 하비 )
										"3k_main_province_donghai",			-- 동해
										"3k_main_province_langye",			-- 낭야
										"3k_main_province_penchang",		-- 팽성
										"3k_main_province_guangling",		-- 광릉 ( 회음 )
									},
								},
			['theg_state_yu'] = { kr = "예주", 	en = "Yu", 		zh = "豫州", cn = "豫州", province_key = '3k_main_province_runan',
									provinces = {
										"3k_main_province_runan",			-- 여남 ( 여음 )
										"3k_main_province_yingchuan",		-- 영천 ( 허창, 진류 )
										"3k_main_province_chenjun",			-- 진군 ( 수양, 패현 )
									},
								},
		  ['theg_state_yang'] = { kr = "양주", 	en = "Yang", 	zh = "揚州", cn = "揚州", province_key = '3k_main_province_jianye',
									provinces = {
										"3k_main_province_jianye",			-- 단양 ( 건업, 오 )
										"3k_main_province_yangzhou",		-- 회남 ( 수춘 )
										"3k_main_province_lujiang",			-- 여강 ( 합비 )
										"3k_main_province_luling",			-- 여릉 ( 우도 )
										"3k_main_province_xindu",			-- 신도 ( 시신 )
										"3k_main_province_kuaiji",			-- 회계 ( 산음 )
										"3k_main_province_yuzhang",			-- 예장 ( 남창 )
										"3k_main_province_poyang",			-- 파양 ( 파양 )
										"3k_main_province_dongou",			-- 임해 ( 영녕 )
										"3k_main_province_jianan",			-- 북건안 ( 건안 )
										"3k_main_province_tongan",			-- 남건안 ( 동안 )
										"3k_main_province_ye"				-- 후관* 侯官
									},
								},
		 ['theg_state_guang'] = { kr = "광주", 	en = "Guang", 	zh = "廣州", cn = "廣州", province_key = '3k_main_province_guangling',
									provinces = {
									},
								},
	   ['theg_state_jiaozhi'] = { kr = "교주", 	en = "Jiao", 	zh = "交州", cn = "交州", province_key = '3k_main_province_nanhai',	 -- en = "Jiaozhi", zh = "交趾", cn = "交趾" },
									provinces = {
										"3k_main_province_nanhai",			-- 남해
										"3k_main_province_hepu",			-- 합포
										"3k_main_province_cangwu",			-- 창오
										"3k_main_province_yulin",			-- 울림
										"3k_main_province_jiaozhi",			-- 교지
										"3k_main_province_gaoliang",		-- 고량 ( 사평, 안녕 )
										"3k_dlc06_province_jiuzhen",		-- 구진
									},
								},
		  ['theg_state_jing'] = { kr = "형주", 	en = "Jing", 	zh = "荊州", cn = "荊州", province_key = '3k_main_province_xiangyang',
									provinces = {
										"3k_main_province_nanyang",			-- 남양 ( 완, 신야 )
										"3k_main_province_xiangyang",		-- 양양 ( 양양, 임저 )
										"3k_main_province_jiangxia",		-- 강하 ( 서릉 )
										"3k_main_province_wuling",			-- 무릉 ( 천릉 遷陵 )
										"3k_main_province_changsha",		-- 장사 ( 임상, 적벽 )
										"3k_main_province_shangyong",		-- 상용
										"3k_main_province_jingzhou",		-- 남군 ( 강릉, 화용 )
										"3k_main_province_lingling",		-- 영릉 ( 천릉 泉陵 )
									},
								},
		  ['theg_state_yong'] = { kr = "옹주", 	en = "Yong", 	zh = "雍州", cn = "雍州", province_key = '3k_main_province_changan',
									provinces = {
										"3k_main_province_changan",			-- 경조윤 ( 장안 )
										"3k_main_province_anding",			-- 안정 ( 임경 )
										"3k_dlc06_province_san_pass",		-- 산관
										"3k_dlc06_province_wu_pass",		-- 무관
									},
								},
		 ['theg_state_liang'] = { kr = "량주", 	en = "Liang", 	zh = "凉州", cn = "凉州", province_key = '3k_main_province_wuwei',
									provinces = {
										"3k_main_province_wuwei",			-- 무위 ( 고장 )
										"3k_main_province_wudu",			-- 무도 ( 하변 )
										"3k_main_province_jincheng",		-- 금성 ( 금성, 천수 )
									},
								},
			['theg_state_yi'] = { kr = "익주", 	en = "Yi", 		zh = "益州", cn = "益州", province_key = '3k_main_province_chengdu',
									provinces = {
										"3k_main_province_chengdu",			-- 촉군 ( 성도 )
										"3k_main_province_hanzhong",		-- 한중 ( 남정, 미현 )
										"3k_main_province_baxi",			-- 파서 ( 낭중, 자동 )
										"3k_main_province_bajun",			-- 파군 ( 강주 )
										"3k_main_province_fuling",			-- 부릉
										"3k_dlc06_province_yunnan",			-- 운남
										"3k_main_province_zangke",			-- 장가
										"3k_main_province_badong",			-- 파동
										"3k_main_province_jianning",		-- 건녕 ( 매현 )
										"3k_dlc06_province_yongchang",		-- 영창 ( 불위 )
										"3k_main_province_jiangyang",		-- 강양
										"3k_dlc06_province_kui_pass",		-- 귀관
										"3k_dlc06_province_jiameng",		-- 가맹관
										"3k_main_province_yizhou",			-- 익주*
									},
								},
		    ['theg_state_ye'] = { kr = "이주", 	en = "Ye", 		zh = "夷洲", cn = "夷洲", province_key = '3k_main_province_yizhou_island',
									provinces = {
										"3k_main_province_yizhou_island",	-- 이주 ( 담수 )
									},
								},
--[[
		  ['theg_state_ning'] = { kr = "령주", 	en = "Ling", 	zh = "寧州", cn = "寧州", province_key = '3k_main_province_jianning',
									-- province_key = "3k_main_province_jianning",
								},
]]--
}

--[[
3k_dlc06_province_jiameng	3k_dlc06_jiameng_pass	익주	파서군	가맹관	Jiameng Pass
3k_dlc06_province_gu_pass	3k_dlc06_gu_pass	병주	상당군	고관	Gu Pass		故關
3k_dlc06_province_kui_pass	3k_dlc06_kui_pass	익주	파동군	귀관	Kui Pass	夔關
3k_dlc06_province_qi_pass	3k_dlc06_qi_pass	사예주	하내군	기관	Qi Pass		箕關
3k_dlc06_province_tong_pass	3k_dlc06_tong_pass	사예주	홍농군	동관	Tong Pass		潼關
3k_dlc06_province_wu_pass	3k_dlc06_wu_pass	옹주	경조윤	무관	Wu Pass
3k_dlc06_province_san_pass	3k_dlc06_san_pass	옹주	부풍군	산관	San Pass
3k_dlc06_province_hangu_pass	3k_dlc06_hangu_pass	사예주	하남윤	함곡관	Hangu Pass
3k_dlc06_province_hulao_pass	3k_dlc06_hulao_pass	사예주	하남윤	호뢰관	Hulao Pass
]]--

sandbox.db_county_passes = {
		 ['3k_dlc06_gu_pass'] = { province_key = '3k_main_province_shangdang' },
	['3k_dlc06_jiameng_pass'] = { province_key = 'theg_province_zitong' },
		['3k_dlc06_kui_pass'] = { province_key = '3k_main_province_badong' },
		 ['3k_dlc06_qi_pass'] = { province_key = '3k_main_province_henei' },
	   ['3k_dlc06_tong_pass'] = { province_key = 'theg_province_hongnong' },
		 ['3k_dlc06_wu_pass'] = { province_key = '3k_main_province_changan' },
		['3k_dlc06_san_pass'] = { province_key = 'theg_province_youfufeng' },
	  ['3k_dlc06_hangu_pass'] = { province_key = 'theg_province_hongnong' },
	  ['3k_dlc06_hulao_pass'] = { province_key = '3k_main_province_luoyang' },
}

sandbox.db_provinces = {

				 ['theg_province_zitong'] = { capital_key = '3k_dlc06_jiameng_pass', kr = '자동', en = "Zitong", zh = '梓潼', cn = '梓潼', state_key = 'theg_state_yi' },
			  ['theg_province_changshan'] = { capital_key = '3k_main_zhongshan_resource_1', kr = '상산', en = "Changshan", zh = '常山', cn = '常山', state_key = 'theg_state_ji' },
			   ['theg_province_hongnong'] = { capital_key = '3k_dlc06_tong_pass', kr = '홍농', en = "Hongnong", zh = '弘農', cn = '弘农', state_key = 'theg_state_sili' },
			  ['theg_province_youfufeng'] = { capital_key = '3k_dlc06_san_pass', kr = '부풍', en = "Fufeng", zh = '扶風', cn = '扶風', state_key = 'theg_state_sili' },
				   ['theg_province_lean'] = { capital_key = '3k_main_taishan_resource_1', kr = '낙안', en = "Lean", zh = '樂安', cn = '乐安', state_key = 'theg_state_qing' },
				  ['theg_province_jinan'] = { capital_key = '3k_main_taishan_capital', kr = '제남', en = "Jinan", zh = '濟南', cn = '济南', state_key = 'theg_state_qing' },
			    ['theg_province_taishan'] = { capital_key = '3k_main_dongjun_resource_1', kr = '태산', en = "Taishan", zh = '泰山', cn = '泰山', state_key = 'theg_state_yan' },
			   ['theg_province_dongping'] = { capital_key = '3k_main_dongjun_resource_1', kr = '동평', en = "Dongping", zh = '東平', cn = '东平', state_key = 'theg_state_yan' },
--
		--['3k_dlc06_province_gu_pass'] = { en = "Gu Pass", kr = "고관", zh = "故關", cn = "故关", capital_key = "3k_dlc06_gu_pass", state_key = "theg_state_ji",  },
--
            ['3k_dlc06_province_gu_pass'] = { en = "Jingxing Pass", kr = "정형관", zh = "井陘關", cn = "井陉关", capital_key = "3k_dlc06_gu_pass", state_key = "theg_state_bang",  },
         ['3k_dlc06_province_hangu_pass'] = { en = "Hangu Pass", kr = "함곡관", zh = "函谷關", cn = "函谷关", capital_key = "3k_dlc06_hangu_pass", state_key = "theg_state_sili",  },
         ['3k_dlc06_province_hulao_pass'] = { en = "Hulao Pass", kr = "호뢰관", zh = "虎牢關", cn = "虎牢关", capital_key = "3k_dlc06_hulao_pass", state_key = "theg_state_sili",  },
            ['3k_dlc06_province_jiameng'] = { en = "Jiameng Pass", kr = "가맹관", zh = "葭萌關", cn = "葭萌关", capital_key = "3k_dlc06_jiameng_pass", state_key = "theg_state_yi",  },
            ['3k_dlc06_province_jiuzhen'] = { en = "Jiuzhen", kr = "구진", zh = "九真", cn = "九真", capital_key = "3k_dlc06_jiuzhen_capital", state_key = "theg_state_jiaozhi",  },
           ['3k_dlc06_province_kui_pass'] = { en = "Kui Pass", kr = "귀관", zh = "夔關", cn = "夔关", capital_key = "3k_dlc06_kui_pass", state_key = "theg_state_yi",  },
           ['3k_dlc06_province_liaodong'] = { en = "Liaodong", kr = "요동", zh = "遼東", cn = "辽东", capital_key = "3k_dlc06_liaodong_capital", state_key = "theg_state_you",  },
            ['3k_dlc06_province_qi_pass'] = { en = "Qi Pass", kr = "기관", zh = "箕關", cn = "濝关", capital_key = "3k_dlc06_qi_pass", state_key = "theg_state_sili",  },
           ['3k_dlc06_province_san_pass'] = { en = "San Pass", kr = "산관", zh = "散關", cn = "散关", capital_key = "3k_dlc06_san_pass", state_key = "theg_state_yong",  },
          ['3k_dlc06_province_tong_pass'] = { en = "Tong Pass", kr = "동관", zh = "潼關", cn = "潼关", capital_key = "3k_dlc06_tong_pass", state_key = "theg_state_sili",  },
            ['3k_dlc06_province_wu_pass'] = { en = "Wu Pass", kr = "무관", zh = "武關", cn = "武关", capital_key = "3k_dlc06_wu_pass", state_key = "theg_state_yong",  },
              ['3k_dlc06_province_xiapi'] = { en = "Xiapi", kr = "하비", zh = "下邳", cn = "下邳", capital_key = "3k_dlc06_xiapi_capital", state_key = "theg_state_xu",  },
          ['3k_dlc06_province_yongchang'] = { en = "Yongchang", kr = "영창", zh = "永昌", cn = "永昌", capital_key = "3k_dlc06_yongchang_capital", state_key = "theg_state_yi",  },
             ['3k_dlc06_province_yunnan'] = { en = "Yunnan", kr = "운남", zh = "雲南", cn = "云南", capital_key = "3k_dlc06_yunnan_capital", state_key = "theg_state_yi",  },
              ['3k_main_province_anding'] = { en = "Anding", kr = "안정", zh = "安定", cn = "安定", capital_key = "3k_main_anding_capital", state_key = "theg_state_yong",  },
              ['3k_main_province_anping'] = { en = "Anping", kr = "안평", zh = "安平", cn = "安平", capital_key = "3k_main_anping_capital", state_key = "theg_state_ji",  },
              ['3k_main_province_badong'] = { en = "Badong", kr = "파동", zh = "巴東", cn = "巴东", capital_key = "3k_main_badong_capital", state_key = "theg_state_yi",  },
               ['3k_main_province_bajun'] = { en = "Ba", kr = "파군", zh = "巴郡", cn = "巴郡", capital_key = "3k_main_bajun_capital", state_key = "theg_state_yi",  },
                ['3k_main_province_baxi'] = { en = "Baxi", kr = "파서", zh = "巴西", cn = "巴西", capital_key = "3k_main_baxi_capital", state_key = "theg_state_yi",  },
              ['3k_main_province_beihai'] = { en = "Beihai", kr = "북해", zh = "北海", cn = "北海", capital_key = "3k_main_beihai_capital", state_key = "theg_state_qing",  },
               ['3k_main_province_bohai'] = { en = "Bohai", kr = "발해", zh = "渤海", cn = "勃海", capital_key = "3k_main_bohai_capital", state_key = "theg_state_ji",  },
              ['3k_main_province_cangwu'] = { en = "Cangwu", kr = "창오", zh = "蒼梧", cn = "苍梧", capital_key = "3k_main_cangwu_capital", state_key = "theg_state_jiaozhi",  },
             ['3k_main_province_changan'] = { en = "Jingzhaoyin", kr = "경조윤", zh = "京兆尹", cn = "京兆尹", capital_key = "3k_main_changan_capital", state_key = "theg_state_yong",  },
            ['3k_main_province_changsha'] = { en = "Changsha", kr = "장사", zh = "長沙", cn = "长沙", capital_key = "3k_main_changsha_capital", state_key = "theg_state_jing",  },
             ['3k_main_province_chengdu'] = { en = "Shu", kr = "촉군", zh = "蜀", cn = "蜀郡", capital_key = "3k_main_chengdu_capital", state_key = "theg_state_yi",  },
             ['3k_main_province_chenjun'] = { en = "Chen", kr = "진군", zh = "陳郡", cn = "陈郡", capital_key = "3k_main_chenjun_capital", state_key = "theg_state_yu",  },
              ['3k_main_province_daijun'] = { en = "Dai", kr = "대군", zh = "代郡", cn = "代郡", capital_key = "3k_main_daijun_capital", state_key = "theg_state_you",  },
             ['3k_main_province_donghai'] = { en = "Donghai", kr = "동해", zh = "東海", cn = "东海", capital_key = "3k_main_donghai_capital", state_key = "theg_state_xu",  },
             ['3k_main_province_dongjun'] = { en = "Dong", kr = "동군", zh = "東郡", cn = "东郡", capital_key = "3k_main_dongjun_capital", state_key = "theg_state_yan",  },
             ['3k_main_province_donglai'] = { en = "Donglai", kr = "동래", zh = "東萊", cn = "东莱", capital_key = "3k_main_donglai_capital", state_key = "theg_state_qing",  },
              ['3k_main_province_dongou'] = { en = "Linhai", kr = "임해", zh = "臨海", cn = "临海", capital_key = "3k_main_dongou_capital", state_key = "theg_state_yang",  },
              ['3k_main_province_fuling'] = { en = "Fuling", kr = "부릉", zh = "涪陵", cn = "涪陵", capital_key = "3k_main_fuling_capital", state_key = "theg_state_yi",  },
            ['3k_main_province_gaoliang'] = { en = "Gaoliang", kr = "고량", zh = "高涼", cn = "高凉", capital_key = "3k_main_gaoliang_capital", state_key = "theg_state_jiaozhi",  },
           ['3k_main_province_guangling'] = { en = "Guangling", kr = "광릉", zh = "廣陵", cn = "广陵", capital_key = "3k_main_guangling_capital", state_key = "theg_state_xu",  },
            ['3k_main_province_hanzhong'] = { en = "Hanzhong", kr = "한중", zh = "漢中", cn = "汉中", capital_key = "3k_main_hanzhong_capital", state_key = "theg_state_yi",  },
              ['3k_main_province_hedong'] = { en = "Hedong", kr = "하동", zh = "河東", cn = "河东", capital_key = "3k_main_hedong_capital", state_key = "theg_state_sili",  },
               ['3k_main_province_henei'] = { en = "Henei", kr = "하내", zh = "河內", cn = "河内", capital_key = "3k_main_henei_capital", state_key = "theg_state_sili",  },
                ['3k_main_province_hepu'] = { en = "Hepu", kr = "합포", zh = "合浦", cn = "合浦", capital_key = "3k_main_hepu_capital", state_key = "theg_state_jiaozhi",  },
              ['3k_main_province_jianan'] = { en = "Jian'an", kr = "건안", zh = "建安", cn = "建安", capital_key = "3k_main_jianan_capital", state_key = "theg_state_yang",  },
            ['3k_main_province_jiangxia'] = { en = "Jiangxia", kr = "강하", zh = "江夏", cn = "江夏", capital_key = "3k_main_jiangxia_capital", state_key = "theg_state_jing",  },
           ['3k_main_province_jiangyang'] = { en = "Jiangyang", kr = "강양", zh = "江陽", cn = "江阳", capital_key = "3k_main_jiangyang_capital", state_key = "theg_state_yi",  },
            ['3k_main_province_jianning'] = { en = "Jianning", kr = "건녕", zh = "建寧", cn = "建宁", capital_key = "3k_main_jianning_capital", state_key = "theg_state_yi",  },
              ['3k_main_province_jianye'] = { en = "Danyang", kr = "단양", zh = "丹陽", cn = "丹阳", capital_key = "3k_main_jianye_capital", state_key = "theg_state_yang",  },
             ['3k_main_province_jiaozhi'] = { en = "Jiaozhi", kr = "교지", zh = "交趾", cn = "交趾", capital_key = "3k_main_jiaozhi_capital", state_key = "theg_state_jiaozhi",  },
            ['3k_main_province_jincheng'] = { en = "Jincheng", kr = "금성", zh = "金城", cn = "金城", capital_key = "3k_main_jincheng_capital", state_key = "theg_state_liang",  },
            ['3k_main_province_jingzhou'] = { en = "Nan", kr = "남군", zh = "南郡", cn = "南郡", capital_key = "3k_main_jingzhou_capital", state_key = "theg_state_jing",  },
              ['3k_main_province_kuaiji'] = { en = "Kuaiji", kr = "회계", zh = "會稽", cn = "会稽", capital_key = "3k_main_kuaiji_capital", state_key = "theg_state_yang",  },
              ['3k_main_province_langye'] = { en = "Langya", kr = "낭야", zh = "琅邪", cn = "琅琊", capital_key = "3k_main_langye_capital", state_key = "theg_state_xu",  },
            ['3k_main_province_lingling'] = { en = "Lingling", kr = "영릉", zh = "零陵", cn = "零陵", capital_key = "3k_main_lingling_capital", state_key = "theg_state_jing",  },
             ['3k_main_province_lujiang'] = { en = "Lujiang", kr = "여강", zh = "廬江", cn = "庐江", capital_key = "3k_main_lujiang_capital", state_key = "theg_state_yang",  },
              ['3k_main_province_luling'] = { en = "Luling", kr = "여릉", zh = "廬陵", cn = "庐陵", capital_key = "3k_main_luling_capital", state_key = "theg_state_yang",  },
             ['3k_main_province_luoyang'] = { en = "Henanyin", kr = "하남윤", zh = "河南尹", cn = "河南尹", capital_key = "3k_main_luoyang_capital", state_key = "theg_state_sili",  },
              ['3k_main_province_nanhai'] = { en = "Nanhai", kr = "남해", zh = "南海", cn = "南海", capital_key = "3k_main_nanhai_capital", state_key = "theg_state_jiaozhi",  },
             ['3k_main_province_nanyang'] = { en = "Nanyang", kr = "남양", zh = "南陽", cn = "南阳", capital_key = "3k_main_nanyang_capital", state_key = "theg_state_jing",  },
            ['3k_main_province_penchang'] = { en = "Pengcheng", kr = "팽성", zh = "彭城", cn = "彭城", capital_key = "3k_main_penchang_capital", state_key = "theg_state_xu",  },
            ['3k_main_province_pingyuan'] = { en = "Pingyuan", kr = "평원", zh = "平原", cn = "平原", capital_key = "3k_main_pingyuan_capital", state_key = "theg_state_qing",  },
              ['3k_main_province_poyang'] = { en = "Poyang", kr = "파양", zh = "鄱陽", cn = "鄱阳", capital_key = "3k_main_poyang_capital", state_key = "theg_state_yang",  },
               ['3k_main_province_runan'] = { en = "Runan", kr = "여남", zh = "汝南", cn = "汝南", capital_key = "3k_main_runan_capital", state_key = "theg_state_yu",  },
           ['3k_main_province_shangdang'] = { en = "Shangdang", kr = "상당", zh = "上黨", cn = "上党", capital_key = "3k_main_shangdang_capital", state_key = "theg_state_bang",  },
           ['3k_main_province_shangyong'] = { en = "Shangyong", kr = "상용", zh = "上庸", cn = "上庸", capital_key = "3k_main_shangyong_capital", state_key = "theg_state_jing",  },
            ['3k_main_province_shoufang'] = { en = "Shuofang", kr = "삭방", zh = "朔方", cn = "朔方", capital_key = "3k_main_shoufang_capital", state_key = "theg_state_bang",  },
             ['3k_main_province_taishan'] = { en = "Lean", kr = "낙안", zh = "樂安", cn = "乐安", capital_key = "3k_main_taishan_capital", state_key = "theg_state_qing",  },
             ['3k_main_province_taiyuan'] = { en = "Taiyuan", kr = "태원", zh = "太原", cn = "太原", capital_key = "3k_main_taiyuan_capital", state_key = "theg_state_bang",  },
              ['3k_main_province_tongan'] = { en = "Jian'an", kr = "건안", zh = "建安", cn = "建安", capital_key = "3k_main_tongan_capital", state_key = "theg_state_yang",  },
              ['3k_main_province_weijun'] = { en = "Wei", kr = "위군", zh = "魏", cn = "魏郡", capital_key = "3k_main_weijun_capital", state_key = "theg_state_ji",  },
                ['3k_main_province_wudu'] = { en = "Wudu", kr = "무도", zh = "武都", cn = "武都", capital_key = "3k_main_wudu_capital", state_key = "theg_state_liang",  },
              ['3k_main_province_wuling'] = { en = "Wuling", kr = "무릉", zh = "武陵", cn = "武陵", capital_key = "3k_main_wuling_capital", state_key = "theg_state_jing",  },
               ['3k_main_province_wuwei'] = { en = "Wuwei", kr = "무위", zh = "武威", cn = "武威", capital_key = "3k_main_wuwei_capital", state_key = "theg_state_liang",  },
           ['3k_main_province_xiangyang'] = { en = "Xiangyang", kr = "양양", zh = "襄陽", cn = "襄阳", capital_key = "3k_main_xiangyang_capital", state_key = "theg_state_jing",  },
                ['3k_main_province_xihe'] = { en = "Xihe", kr = "서하", zh = "西河", cn = "西河", capital_key = "3k_main_xihe_capital", state_key = "theg_state_bang",  },
               ['3k_main_province_xindu'] = { en = "Xindu", kr = "신도", zh = "新都", cn = "新都", capital_key = "3k_main_xindu_capital", state_key = "theg_state_yang",  },
            ['3k_main_province_yangzhou'] = { en = "Huainan", kr = "회군", zh = "淮南", cn = "淮南", capital_key = "3k_main_yangzhou_capital", state_key = "theg_state_yang",  },
              ['3k_main_province_yanmen'] = { en = "Yanmen", kr = "안문", zh = "雁門", cn = "雁门", capital_key = "3k_main_yanmen_capital", state_key = "theg_state_bang",  },
                  ['3k_main_province_ye'] = { en = "Houguan", kr = "후관", zh = "侯官", cn = "侯官", capital_key = "3k_main_ye_capital", state_key = "theg_state_yang",  },
           ['3k_main_province_yingchuan'] = { en = "Yingchuan", kr = "영천", zh = "潁川", cn = "颍川", capital_key = "3k_main_yingchuan_capital", state_key = "theg_state_yu",  },
              ['3k_main_province_yizhou'] = { en = "Yizhou", kr = "익주", zh = "益州", cn = "益州", capital_key = "3k_main_yizhou_capital", state_key = "theg_state_yi",  },
       ['3k_main_province_yizhou_island'] = { en = "Yizhou", kr = "이주", zh = "夷洲", cn = "夷洲", capital_key = "3k_main_yizhou_island_capital", state_key = "theg_state_ye",  },
          ['3k_main_province_youbeiping'] = { en = "Beiping", kr = "북평", zh = "北平", cn = "北平", capital_key = "3k_main_youbeiping_capital", state_key = "theg_state_you",  },
             ['3k_main_province_youzhou'] = { en = "Guangyang", kr = "광양", zh = "廣陽", cn = "广阳", capital_key = "3k_main_youzhou_capital", state_key = "theg_state_you",  },
                  ['3k_main_province_yu'] = { en = "Liaoxi", kr = "요서", zh = "遼西", cn = "辽西", capital_key = "3k_main_yu_capital", state_key = "theg_state_you",  },
               ['3k_main_province_yulin'] = { en = "Yulin", kr = "울림", zh = "鬱林", cn = "郁林", capital_key = "3k_main_yulin_capital", state_key = "theg_state_jiaozhi",  },
             ['3k_main_province_yuzhang'] = { en = "Yuzhang", kr = "예장", zh = "豫章", cn = "豫章", capital_key = "3k_main_yuzhang_capital", state_key = "theg_state_yang",  },
              ['3k_main_province_zangke'] = { en = "Zangke", kr = "장가", zh = "牂牁", cn = "牂牁", capital_key = "3k_main_zangke_capital", state_key = "theg_state_yi",  },
           ['3k_main_province_zhongshan'] = { en = "Zhongshan", kr = "중산", zh = "中山", cn = "中山", capital_key = "3k_main_zhongshan_capital", state_key = "theg_state_ji",  },
-- provinces 84
}

sandbox.db_regions =
{
-- 
             ['3k_dlc06_jiuzhen_capital'] = { en_key = "xupu", kr = "서포", en = "Xupu", zh = "胥浦", cn = "胥浦", is_capital = true, province_key = "3k_dlc06_province_jiuzhen",  },
          ['3k_dlc06_jiuzhen_resource_1'] = { en_key = "rinan", kr = "일남", en = "Rinan", zh = "日南", cn = "日南", province_key = "3k_dlc06_province_jiuzhen",  },
            ['3k_dlc06_liaodong_capital'] = { en_key = "xiangping", kr = "양평", en = "Xiangping", zh = "襄平", cn = "襄平", is_capital = true, province_key = "3k_dlc06_province_liaodong",  },
         ['3k_dlc06_liaodong_resource_1'] = { en_key = "xuantu", kr = "현도", en = "Xuantu", zh = "玄菟", cn = "玄菟", province_key = "3k_dlc06_province_liaodong",  },
               ['3k_dlc06_xiapi_capital'] = { en_key = "xiapi", kr = "하비", en = "Xiapi", zh = "下邳", cn = "下邳", is_capital = true, province_key = "3k_dlc06_province_xiapi",  },
            ['3k_dlc06_xiapi_resource_1'] = { en_key = "xuexian", kr = "설현", en = "Xuexian", zh = "薛縣", cn = "薛县", province_key = "3k_dlc06_province_xiapi",  },
           ['3k_dlc06_yongchang_capital'] = { en_key = "buwei", kr = "불위", en = "Buwei", zh = "不韋", cn = "不韦", is_capital = true, province_key = "3k_dlc06_province_yongchang",  },
        ['3k_dlc06_yongchang_resource_1'] = { en_key = "yongshou", kr = "영수", en = "Yongshou", zh = "永壽", cn = "永寿", province_key = "3k_dlc06_province_yongchang",  },
              ['3k_dlc06_yunnan_capital'] = { en_key = "longdong", kr = "농동", en = "Longdong", zh = "梇棟", cn = "梇栋", is_capital = true, province_key = "3k_dlc06_province_yunnan",  },
           ['3k_dlc06_yunnan_resource_1'] = { en_key = "qingling", kr = "청령", en = "Qingling", zh = "青蛉", cn = "青蛉", province_key = "3k_dlc06_province_yunnan",  },
           ['3k_dlc06_yunnan_resource_2'] = { en_key = "yuexi", kr = "월수", en = "Yuexi", zh = "越巂", cn = "越巂", province_key = "3k_dlc06_province_yunnan",  },
               ['3k_main_anding_capital'] = { en_key = "linjing", kr = "임경", en = "Linjing", zh = "臨涇", cn = "临泾", is_capital = true, province_key = "3k_main_province_anding",  },
            ['3k_main_anding_resource_1'] = { en_key = "gaonu", kr = "고노", en = "Gaonu", zh = "高奴", cn = "高奴", province_key = "3k_main_province_anding",  },
            ['3k_main_anding_resource_2'] = { en_key = "canluan", kr = "참련", en = "Canluan", zh = "參䜌", cn = "参䜌", province_key = "3k_main_province_anding",  },
            ['3k_main_anding_resource_3'] = { en_key = "sanshui", kr = "삼수", en = "Sanshui", zh = "三水", cn = "三水", province_key = "3k_main_province_anding",  },
               ['3k_main_anping_capital'] = { en_key = "xindu", kr = "신도", en = "Xindu", zh = "信都", cn = "信都", is_capital = true, province_key = "3k_main_province_anping",  },
            ['3k_main_anping_resource_1'] = { en_key = "julu", kr = "거록", en = "Julu", zh = "鉅鹿", cn = "巨鹿", province_key = "3k_main_province_anping",  },
                    ['3k_dlc06_kui_pass'] = { en_key = "kui pass", kr = "귀관", en = "Kui Pass", zh = "夔關", cn = "夔关", is_capital = true, is_pass = true, province_key = "3k_main_province_badong",  },
               ['3k_main_badong_capital'] = { en_key = "yongan", kr = "영안", en = "Yong'an", zh = "永安", cn = "永安", is_capital = true, province_key = "3k_main_province_badong",  },
            ['3k_main_badong_resource_1'] = { en_key = "quren", kr = "구인", en = "Quren", zh = "朐忍", cn = "朐忍", province_key = "3k_main_province_badong",  },
            ['3k_main_badong_resource_2'] = { en_key = "linyuan", kr = "임원", en = "Linyuan", zh = "臨沅", cn = "临沅", province_key = "3k_main_province_badong",  },
                ['3k_main_bajun_capital'] = { en_key = "jiangzhou", kr = "강주", en = "Jiangzhou", zh = "江州", cn = "江州", is_capital = true, province_key = "3k_main_province_bajun",  },
             ['3k_main_bajun_resource_1'] = { en_key = "danqu", kr = "탕거", en = "Danqu", zh = "宕渠", cn = "宕渠", province_key = "3k_main_province_bajun",  },
                 ['3k_main_baxi_capital'] = { en_key = "langzhong", kr = "낭중", en = "Langzhong", zh = "閬中", cn = "阆中", is_capital = true, province_key = "3k_main_province_baxi",  },
              ['3k_main_baxi_resource_1'] = { en_key = "hanchang", kr = "한창", en = "Hanchang", zh = "漢昌", cn = "汉昌", province_key = "3k_main_province_baxi",  },
              ['3k_main_baxi_resource_2'] = { en_key = "zitong", kr = "자동", en = "Zitong", zh = "梓潼", cn = "梓潼", province_key = "3k_main_province_baxi",  },
               ['3k_main_beihai_capital'] = { en_key = "juxian", kr = "극현", en = "Juxian", zh = "劇縣", cn = "剧县", is_capital = true, province_key = "3k_main_province_beihai",  },
            ['3k_main_beihai_resource_1'] = { en_key = "jimo", kr = "즉묵", en = "Jimo", zh = "即墨", cn = "即墨", province_key = "3k_main_province_beihai",  },
                ['3k_main_bohai_capital'] = { en_key = "nanpi", kr = "남피", en = "Nanpi", zh = "南皮", cn = "南皮", is_capital = true, province_key = "3k_main_province_bohai",  },
             ['3k_main_bohai_resource_1'] = { en_key = "zhangwu", kr = "장무", en = "Zhangwu", zh = "章武", cn = "章武", province_key = "3k_main_province_bohai",  },
               ['3k_main_cangwu_capital'] = { en_key = "guangxin", kr = "광신", en = "Guangxin", zh = "廣信", cn = "广信", is_capital = true, province_key = "3k_main_province_cangwu",  },
            ['3k_main_cangwu_resource_1'] = { en_key = "fuchuan", kr = "부천", en = "Fuchuan", zh = "富川", cn = "富川", province_key = "3k_main_province_cangwu",  },
            ['3k_main_cangwu_resource_2'] = { en_key = "mengling", kr = "맹릉", en = "Mengling", zh = "猛陵", cn = "猛陵", province_key = "3k_main_province_cangwu",  },
            ['3k_main_cangwu_resource_3'] = { en_key = "dingzhou", kr = "정주", en = "Dingzhou", zh = "定周", cn = "定周", province_key = "3k_main_province_cangwu",  },
                     ['3k_dlc06_wu_pass'] = { en_key = "wu pass", kr = "무관", en = "Wu Pass", zh = "武關", cn = "武关", is_capital = true, is_pass = true, province_key = "3k_main_province_changan",  },
              ['3k_main_changan_capital'] = { en_key = "changan", kr = "장안", en = "Chang'an", zh = "長安", cn = "长安", is_capital = true, province_key = "3k_main_province_changan",  },
           ['3k_main_changan_resource_1'] = { en_key = "lantian", kr = "남전", en = "Lantian", zh = "藍田", cn = "蓝田", province_key = "3k_main_province_changan",  },
             ['3k_main_changsha_capital'] = { en_key = "linxiang", kr = "임상", en = "Linxiang", zh = "臨湘", cn = "临湘", is_capital = true, province_key = "3k_main_province_changsha",  },
          ['3k_main_changsha_resource_1'] = { en_key = "chibi", kr = "적벽", en = "Chibi", zh = "赤壁", cn = "赤壁", province_key = "3k_main_province_changsha",  },
          ['3k_main_changsha_resource_2'] = { en_key = "lingxian", kr = "영현", en = "Lingxian", zh = "酃縣", cn = "酃县", province_key = "3k_main_province_changsha",  },
          ['3k_main_changsha_resource_3'] = { en_key = "chaling", kr = "차릉", en = "Chaling", zh = "茶陵", cn = "茶陵", province_key = "3k_main_province_changsha",  },
              ['3k_main_chengdu_capital'] = { en_key = "chengdu", kr = "성도", en = "Chengdu", zh = "成都", cn = "成都", is_capital = true, province_key = "3k_main_province_chengdu",  },
           ['3k_main_chengdu_resource_1'] = { en_key = "hanjia", kr = "한가", en = "Hanjia", zh = "漢嘉", cn = "汉嘉", province_key = "3k_main_province_chengdu",  },
           ['3k_main_chengdu_resource_2'] = { en_key = "luocheng", kr = "낙성", en = "Luocheng", zh = "洛城", cn = "雒城", province_key = "3k_main_province_chengdu",  },
           ['3k_main_chengdu_resource_3'] = { en_key = "zizhong", kr = "자중", en = "Zizhong", zh = "資中", cn = "资中", province_key = "3k_main_province_chengdu",  },
              ['3k_main_chenjun_capital'] = { en_key = "suiyang", kr = "수양", en = "Suiyang", zh = "睢陽", cn = "睢阳", is_capital = true, province_key = "3k_main_province_chenjun",  },
           ['3k_main_chenjun_resource_1'] = { en_key = "peixian", kr = "패현", en = "Peixian", zh = "沛縣", cn = "沛县", province_key = "3k_main_province_chenjun",  },
           ['3k_main_chenjun_resource_2'] = { en_key = "ruyang", kr = "여양", en = "Ruyang", zh = "汝陽", cn = "汝阳", province_key = "3k_main_province_chenjun",  },
               ['3k_main_daijun_capital'] = { en_key = "gaoliu", kr = "고류", en = "Gaoliu", zh = "高柳", cn = "高柳", is_capital = true, province_key = "3k_main_province_daijun",  },
            ['3k_main_daijun_resource_1'] = { en_key = "zhuo lu", kr = "탁록", en = "Zhuo Lu", zh = "涿鹿", cn = "涿鹿", province_key = "3k_main_province_daijun",  },
              ['3k_main_donghai_capital'] = { en_key = "tanxian", kr = "담현", en = "Tanxian", zh = "郯縣", cn = "郯县", is_capital = true, province_key = "3k_main_province_donghai",  },
           ['3k_main_donghai_resource_1'] = { en_key = "haixi", kr = "해서", en = "Haixi", zh = "海西", cn = "海西", province_key = "3k_main_province_donghai",  },
              ['3k_main_dongjun_capital'] = { en_key = "puyang", kr = "복양", en = "Puyang", zh = "濮陽", cn = "濮阳", is_capital = true, province_key = "3k_main_province_dongjun",  },
              ['3k_main_donglai_capital'] = { en_key = "huangxian", kr = "황현", en = "Huangxian", zh = "黃縣", cn = "黄县", is_capital = true, province_key = "3k_main_province_donglai",  },
           ['3k_main_donglai_resource_1'] = { en_key = "changyang", kr = "창양", en = "Changyang", zh = "昌陽", cn = "昌阳", province_key = "3k_main_province_donglai",  },
               ['3k_main_dongou_capital'] = { en_key = "yongning", kr = "영녕", en = "Yongning", zh = "永寧", cn = "永宁", is_capital = true, province_key = "3k_main_province_dongou",  },
            ['3k_main_dongou_resource_1'] = { en_key = "wenma", kr = "온마", en = "Wenma", zh = "溫麻", cn = "温麻", province_key = "3k_main_province_dongou",  },
               ['3k_main_fuling_capital'] = { en_key = "fuling", kr = "부릉", en = "Fuling", zh = "涪陵", cn = "涪陵", is_capital = true, province_key = "3k_main_province_fuling",  },
            ['3k_main_fuling_resource_1'] = { en_key = "jianwei", kr = "건위", en = "Jianwei", zh = "犍為", cn = "犍为", province_key = "3k_main_province_fuling",  },
             ['3k_main_gaoliang_capital'] = { en_key = "siping", kr = "사평", en = "Siping", zh = "思平", cn = "思平", is_capital = true, province_key = "3k_main_province_gaoliang",  },
          ['3k_main_gaoliang_resource_1'] = { en_key = "anning", kr = "안녕", en = "Anning", zh = "安寧", cn = "安宁", province_key = "3k_main_province_gaoliang",  },
            ['3k_main_guangling_capital'] = { en_key = "huaiyin", kr = "회음", en = "Huaiyin", zh = "淮陰", cn = "淮阴", is_capital = true, province_key = "3k_main_province_guangling",  },
         ['3k_main_guangling_resource_1'] = { en_key = "gaoyou", kr = "고우", en = "Gaoyou", zh = "高郵", cn = "高邮", province_key = "3k_main_province_guangling",  },
         ['3k_main_guangling_resource_2'] = { en_key = "jiangdu", kr = "강도", en = "Jiangdu", zh = "江都", cn = "江都", province_key = "3k_main_province_guangling",  },
             ['3k_main_hanzhong_capital'] = { en_key = "nanzheng", kr = "남정", en = "Nanzheng", zh = "南鄭", cn = "南郑", is_capital = true, province_key = "3k_main_province_hanzhong",  },
          ['3k_main_hanzhong_resource_1'] = { en_key = "meixian", kr = "미현", en = "Meixian", zh = "眉縣", cn = "眉县", province_key = "3k_main_province_hanzhong",  },
           ['3k_dlc06_hedong_resource_2'] = { en_key = "pingyang", kr = "평양", en = "Pingyang", zh = "平陽", cn = "平阳", province_key = "3k_main_province_hedong",  },
               ['3k_main_hedong_capital'] = { en_key = "anyi", kr = "안읍", en = "Anyi", zh = "安邑", cn = "安邑", is_capital = true, province_key = "3k_main_province_hedong",  },
            ['3k_main_hedong_resource_1'] = { en_key = "puzhou", kr = "포주", en = "Puzhou", zh = "蒲州", cn = "蒲州", province_key = "3k_main_province_hedong",  },
                     ['3k_dlc06_qi_pass'] = { en_key = "qi pass", kr = "기관", en = "Qi Pass", zh = "箕關", cn = "濝关", is_capital = true, is_pass = true, province_key = "3k_main_province_henei",  },
                ['3k_main_henei_capital'] = { en_key = "huaixian", kr = "회현", en = "Huaixian", zh = "懷縣", cn = "怀县", is_capital = true, province_key = "3k_main_province_henei",  },
             ['3k_main_henei_resource_1'] = { en_key = "zhaoge", kr = "조가", en = "Zhaoge", zh = "朝歌", cn = "朝歌", province_key = "3k_main_province_henei",  },
                 ['3k_main_hepu_capital'] = { en_key = "hepu", kr = "합포", en = "Hepu", zh = "合浦", cn = "合浦", is_capital = true, province_key = "3k_main_province_hepu",  },
              ['3k_main_hepu_resource_1'] = { en_key = "xuwen", kr = "서문", en = "Xuwen", zh = "徐聞", cn = "徐闻", province_key = "3k_main_province_hepu",  },
              ['3k_main_hepu_resource_2'] = { en_key = "zhuya", kr = "주애", en = "Zhuya", zh = "朱崖", cn = "朱崖", province_key = "3k_main_province_hepu",  },
               ['3k_main_jianan_capital'] = { en_key = "jianan", kr = "건안", en = "Jian'an", zh = "建安", cn = "建安", is_capital = true, province_key = "3k_main_province_jianan",  },
            ['3k_main_jianan_resource_1'] = { en_key = "jiangle", kr = "장락", en = "Jiangle", zh = "將樂", cn = "将乐", province_key = "3k_main_province_jianan",  },
            ['3k_main_jianan_resource_2'] = { en_key = "jianping", kr = "건평", en = "Jianping", zh = "建平", cn = "建平", province_key = "3k_main_province_jianan",  },
             ['3k_main_jiangxia_capital'] = { en_key = "xiling", kr = "서릉", en = "Xiling", zh = "西陵", cn = "西陵", is_capital = true, province_key = "3k_main_province_jiangxia",  },
          ['3k_main_jiangxia_resource_1'] = { en_key = "xiyang", kr = "서양", en = "Xiyang", zh = "西陽", cn = "西阳", province_key = "3k_main_province_jiangxia",  },
            ['3k_main_jiangyang_capital'] = { en_key = "jiangyang", kr = "강양", en = "Jiangyang", zh = "江陽", cn = "江阳", is_capital = true, province_key = "3k_main_province_jiangyang",  },
         ['3k_main_jiangyang_resource_1'] = { en_key = "wuyang", kr = "무양", en = "Wuyang", zh = "武陽", cn = "武阳", province_key = "3k_main_province_jiangyang",  },
         ['3k_main_jiangyang_resource_2'] = { en_key = "zhuti", kr = "주제", en = "Zhuti", zh = "朱提", cn = "朱提", province_key = "3k_main_province_jiangyang",  },
         ['3k_main_jiangyang_resource_3'] = { en_key = "pingyi", kr = "평이", en = "Pingyi", zh = "平夷", cn = "平夷", province_key = "3k_main_province_jiangyang",  },
         ['3k_dlc06_jianning_resource_3'] = { en_key = "dianchi", kr = "전지", en = "Dianchi", zh = "滇池", cn = "滇池", province_key = "3k_main_province_jianning",  },
             ['3k_main_jianning_capital'] = { en_key = "weixian", kr = "매현", en = "Weixian", zh = "味縣", cn = "味县", is_capital = true, province_key = "3k_main_province_jianning",  },
          ['3k_main_jianning_resource_1'] = { en_key = "tangao", kr = "담고", en = "Tangao", zh = "談槁", cn = "谈稿", province_key = "3k_main_province_jianning",  },
          ['3k_main_jianning_resource_2'] = { en_key = "xiuyun", kr = "수운", en = "Xiuyun", zh = "修雲", cn = "修云", province_key = "3k_main_province_jianning",  },
               ['3k_main_jianye_capital'] = { en_key = "jianye", kr = "건업", en = "Jianye", zh = "建業", cn = "建业", is_capital = true, province_key = "3k_main_province_jianye",  },
            ['3k_main_jianye_resource_1'] = { en_key = "wu", kr = "오", en = "Wu", zh = "吳", cn = "吴", province_key = "3k_main_province_jianye",  },
            ['3k_main_jianye_resource_2'] = { en_key = "wanling", kr = "완릉", en = "Wanling", zh = "宛陵", cn = "宛陵", province_key = "3k_main_province_jianye",  },
          ['3k_dlc06_jiaozhi_resource_3'] = { en_key = "wanwen", kr = "완온", en = "Wanwen", zh = "宛溫", cn = "宛温", province_key = "3k_main_province_jiaozhi",  },
              ['3k_main_jiaozhi_capital'] = { en_key = "longbien", kr = "용편", en = "Longbien", zh = "龍編", cn = "龙编", is_capital = true, province_key = "3k_main_province_jiaozhi",  },
           ['3k_main_jiaozhi_resource_1'] = { en_key = "linchen", kr = "임진", en = "Linchen", zh = "臨塵", cn = "临尘", province_key = "3k_main_province_jiaozhi",  },
           ['3k_main_jiaozhi_resource_2'] = { en_key = "xisui", kr = "서수", en = "Xisui", zh = "西隨", cn = "西随", province_key = "3k_main_province_jiaozhi",  },
             ['3k_main_jincheng_capital'] = { en_key = "jincheng", kr = "금성", en = "Jincheng", zh = "金城", cn = "金城", is_capital = true, province_key = "3k_main_province_jincheng",  },
          ['3k_main_jincheng_resource_1'] = { en_key = "zhanyin", kr = "전음", en = "Zhanyin", zh = "鸇陰", cn = "鹯阴", province_key = "3k_main_province_jincheng",  },
          ['3k_main_jincheng_resource_2'] = { en_key = "tianshui", kr = "천수", en = "Tianshui", zh = "天水", cn = "天水", province_key = "3k_main_province_jincheng",  },
             ['3k_main_jingzhou_capital'] = { en_key = "jiangling", kr = "강릉", en = "Jiangling", zh = "江陵", cn = "江陵", is_capital = true, province_key = "3k_main_province_jingzhou",  },
          ['3k_main_jingzhou_resource_1'] = { en_key = "huarong", kr = "화용", en = "Huarong", zh = "華容", cn = "华容", province_key = "3k_main_province_jingzhou",  },
               ['3k_main_kuaiji_capital'] = { en_key = "shanyin", kr = "산음", en = "Shanyin", zh = "山陰", cn = "山阴", is_capital = true, province_key = "3k_main_province_kuaiji",  },
            ['3k_main_kuaiji_resource_1'] = { en_key = "linhai", kr = "임해", en = "Linhai", zh = "臨海", cn = "临海", province_key = "3k_main_province_kuaiji",  },
            ['3k_main_kuaiji_resource_2'] = { en_key = "wushang", kr = "오상", en = "Wushang", zh = "烏傷", cn = "乌伤", province_key = "3k_main_province_kuaiji",  },
               ['3k_main_langye_capital'] = { en_key = "dongwu", kr = "동무", en = "Dongwu", zh = "東武", cn = "东武", is_capital = true, province_key = "3k_main_province_langye",  },
            ['3k_main_langye_resource_1'] = { en_key = "kaiyang", kr = "개양", en = "Kaiyang", zh = "開陽", cn = "开阳", province_key = "3k_main_province_langye",  },
            ['3k_main_langye_resource_2'] = { en_key = "buji", kr = "불기", en = "Buji", zh = "不其", cn = "不其", province_key = "3k_main_province_langye",  },
             ['3k_main_lingling_capital'] = { en_key = "quanling", kr = "천능", en = "Quanling", zh = "泉陵", cn = "泉陵", is_capital = true, province_key = "3k_main_province_lingling",  },
          ['3k_main_lingling_resource_1'] = { en_key = "chenxian", kr = "침현", en = "Chenxian", zh = "郴縣", cn = "郴县", province_key = "3k_main_province_lingling",  },
          ['3k_main_lingling_resource_2'] = { en_key = "nanping", kr = "남평", en = "Nanping", zh = "南平", cn = "南平", province_key = "3k_main_province_lingling",  },
          ['3k_main_lingling_resource_3'] = { en_key = nil, kr = "공구 제작소", en = "Toolmaker", zh = "工具鋪", cn = "工具铺", province_key = "3k_main_province_lingling",  },
              ['3k_main_lujiang_capital'] = { en_key = "hefei", kr = "합비", en = "Hefei", zh = "合肥", cn = "合肥", is_capital = true, province_key = "3k_main_province_lujiang",  },
           ['3k_main_lujiang_resource_1'] = { en_key = "xunyang", kr = "심양", en = "Xunyang", zh = "潯陽", cn = "寻阳", province_key = "3k_main_province_lujiang",  },
           ['3k_main_lujiang_resource_2'] = { en_key = "shuxian", kr = "서현", en = "Shuxian", zh = "舒縣", cn = "舒县", province_key = "3k_main_province_lujiang",  },
               ['3k_main_luling_capital'] = { en_key = "yudu", kr = "우도", en = "Yudu", zh = "雩都", cn = "雩都", is_capital = true, province_key = "3k_main_province_luling",  },
            ['3k_main_luling_resource_1'] = { en_key = "yangdu", kr = "양도", en = "Yangdu", zh = "楊都", cn = "扬都", province_key = "3k_main_province_luling",  },
                  ['3k_dlc06_hulao_pass'] = { en_key = "hulao pass", kr = "호뢰관", en = "Hulao Pass", zh = "虎牢關", cn = "虎牢关", is_capital = true, is_pass = true, province_key = "3k_main_province_luoyang",  },
           ['3k_main_chenjun_resource_3'] = { en_key = "liangxian", kr = "양현", en = "Liangxian", zh = "梁縣", cn = "梁县", province_key = "3k_main_province_luoyang",  },
              ['3k_main_luoyang_capital'] = { en_key = "luoyang", kr = "낙양", en = "Luoyang", zh = "洛陽", cn = "洛阳", is_capital = true, province_key = "3k_main_province_luoyang",  },
           ['3k_main_luoyang_resource_1'] = { en_key = "hongnong", kr = "홍농", en = "Hongnong", zh = "弘農", cn = "弘农", province_key = "3k_main_province_luoyang",  },
               ['3k_main_nanhai_capital'] = { en_key = "panyu", kr = "번우", en = "Panyu", zh = "番禺", cn = "番禺", is_capital = true, province_key = "3k_main_province_nanhai",  },
            ['3k_main_nanhai_resource_1'] = { en_key = "longchuan", kr = "용천", en = "Longchuan", zh = "龍川", cn = "龙川", province_key = "3k_main_province_nanhai",  },
            ['3k_main_nanhai_resource_2'] = { en_key = "jieyang", kr = "게양", en = "Jieyang", zh = "揭陽", cn = "揭阳", province_key = "3k_main_province_nanhai",  },
            ['3k_main_nanhai_resource_3'] = { en_key = nil, kr = "교역항", en = "Trade Port", zh = "貿易港", cn = "商港", province_key = "3k_main_province_nanhai",  },
              ['3k_main_nanyang_capital'] = { en_key = "wanxian", kr = "완현", en = "Wanxian", zh = "宛縣", cn = "宛县", is_capital = true, province_key = "3k_main_province_nanyang",  },
           ['3k_main_nanyang_resource_1'] = { en_key = "xinye", kr = "신야", en = "Xinye", zh = "新野", cn = "新野", province_key = "3k_main_province_nanyang",  },
             ['3k_main_penchang_capital'] = { en_key = "pengcheng", kr = "팽성", en = "Pengcheng", zh = "彭城", cn = "彭城", is_capital = true, province_key = "3k_main_province_penchang",  },
          ['3k_main_penchang_resource_1'] = { en_key = "luxian", kr = "여현", en = "Luxian", zh = "呂縣", cn = "鲁县", province_key = "3k_main_province_penchang",  },
          ['3k_main_penchang_resource_2'] = { en_key = nil, kr = "농지", en = "Farmland", zh = "農地", cn = "农田", province_key = "3k_main_province_penchang",  },
             ['3k_main_pingyuan_capital'] = { en_key = "pingyuan", kr = "평원", en = "Pingyuan", zh = "平原", cn = "平原", is_capital = true, province_key = "3k_main_province_pingyuan",  },
          ['3k_main_pingyuan_resource_1'] = { en_key = "leling", kr = "낙릉", en = "Leling", zh = "樂陵", cn = "乐陵", province_key = "3k_main_province_pingyuan",  },
               ['3k_main_poyang_capital'] = { en_key = "poyang", kr = "파양", en = "Poyang", zh = "鄱陽", cn = "鄱阳", is_capital = true, province_key = "3k_main_province_poyang",  },
            ['3k_main_poyang_resource_1'] = { en_key = "haihun", kr = "해혼", en = "Haihun", zh = "海昏", cn = "海昏", province_key = "3k_main_province_poyang",  },
            ['3k_main_poyang_resource_2'] = { en_key = "guangchang", kr = "광창", en = "Guangchang", zh = "廣昌", cn = "广昌", province_key = "3k_main_province_poyang",  },
            ['3k_main_poyang_resource_3'] = { en_key = "lean_1", kr = "낙안_1", en = "Lean_1", zh = "樂安_1", cn = "乐安_1", province_key = "3k_main_province_poyang",  },
                ['3k_main_runan_capital'] = { en_key = "ruyin", kr = "여음", en = "Ruyin", zh = "汝陰", cn = "汝阴", is_capital = true, province_key = "3k_main_province_runan",  },
             ['3k_main_runan_resource_1'] = { en_key = "pingyu", kr = "평여", en = "Pingyu", zh = "平輿", cn = "平舆", province_key = "3k_main_province_runan",  },
                     ['3k_dlc06_gu_pass'] = { en_key = "gu pass", kr = "정형관", en = "Jingxing Pass", zh = "井陘關", cn = "井陉关", is_capital = true, is_pass = true, province_key = "3k_main_province_shangdang",  },
        ['3k_dlc06_shangdang_resource_2'] = { en_key = "zhixian", kr = "지현", en = "Zhixian", zh = "軹縣", cn = "轵县", province_key = "3k_main_province_shangdang",  },
            ['3k_main_shangdang_capital'] = { en_key = "zhangzi", kr = "장자", en = "Zhangzi", zh = "長子", cn = "长子", is_capital = true, province_key = "3k_main_province_shangdang",  },
         ['3k_main_shangdang_resource_1'] = { en_key = "shexian", kr = "섭현", en = "Shexian", zh = "涉縣", cn = "涉县", province_key = "3k_main_province_shangdang",  },
            ['3k_main_shangyong_capital'] = { en_key = "shangyong", kr = "상용", en = "Shangyong", zh = "上庸", cn = "上庸", is_capital = true, province_key = "3k_main_province_shangyong",  },
         ['3k_main_shangyong_resource_1'] = { en_key = "xicheng", kr = "서성", en = "Xicheng", zh = "西城", cn = "西城", province_key = "3k_main_province_shangyong",  },
         ['3k_main_shangyong_resource_2'] = { en_key = "shanglian", kr = "상렴", en = "Shanglian", zh = "上廉", cn = "上廉", province_key = "3k_main_province_shangyong",  },
             ['3k_main_shoufang_capital'] = { en_key = "heyin", kr = "하음", en = "Heyin", zh = "河陰", cn = "河阴", is_capital = true, province_key = "3k_main_province_shoufang",  },
          ['3k_main_shoufang_resource_1'] = { en_key = "pingding", kr = "평정", en = "Pingding", zh = "平定", cn = "平定", province_key = "3k_main_province_shoufang",  },
          ['3k_main_shoufang_resource_2'] = { en_key = "dacheng", kr = "대성", en = "Dacheng", zh = "大城", cn = "大城", province_key = "3k_main_province_shoufang",  },
          ['3k_main_shoufang_resource_3'] = { en_key = "sheyan", kr = "사연", en = "Sheyan", zh = "奢延", cn = "奢延", province_key = "3k_main_province_shoufang",  },
              ['3k_main_taiyuan_capital'] = { en_key = "jinyang", kr = "진양", en = "Jinyang", zh = "晉陽", cn = "晋阳", is_capital = true, province_key = "3k_main_province_taiyuan",  },
           ['3k_main_taiyuan_resource_1'] = { en_key = "jingxing", kr = "경흥", en = "Jingxing", zh = "景興", cn = "井陉", province_key = "3k_main_province_taiyuan",  },
           ['3k_main_taiyuan_resource_2'] = { en_key = "jiexiu", kr = "개휴", en = "Jiexiu", zh = "介休", cn = "界休", province_key = "3k_main_province_taiyuan",  },
               ['3k_main_tongan_capital'] = { en_key = "dongan", kr = "동안", en = "Dong'an", zh = "東安", cn = "东安", is_capital = true, province_key = "3k_main_province_tongan",  },
            ['3k_main_tongan_resource_1'] = { en_key = "shashu", kr = "사술", en = "Shashu", zh = "沙戍", cn = "沙戍", province_key = "3k_main_province_tongan",  },
               ['3k_main_weijun_capital'] = { en_key = "ye", kr = "업", en = "Ye", zh = "鄴", cn = "邺", is_capital = true, province_key = "3k_main_province_weijun",  },
            ['3k_main_weijun_resource_1'] = { en_key = "gongcheng", kr = "공성", en = "Gongcheng", zh = "共城", cn = "恭城", province_key = "3k_main_province_weijun",  },
                 ['3k_main_wudu_capital'] = { en_key = "xiabian", kr = "하변", en = "Xiabian", zh = "下辨", cn = "下辨", is_capital = true, province_key = "3k_main_province_wudu",  },
              ['3k_main_wudu_resource_1'] = { en_key = "shanggui", kr = "상규", en = "Shanggui", zh = "上邽", cn = "上邽", province_key = "3k_main_province_wudu",  },
              ['3k_main_wudu_resource_2'] = { en_key = "yinping", kr = "음평", en = "Yinping", zh = "陰平", cn = "阴平", province_key = "3k_main_province_wudu",  },
               ['3k_main_wuling_capital'] = { en_key = "qianling", kr = "천릉", en = "Qianling", zh = "遷陵", cn = "迁陵", is_capital = true, province_key = "3k_main_province_wuling",  },
            ['3k_main_wuling_resource_1'] = { en_key = "chongxian", kr = "충현", en = "Chongxian", zh = "充縣", cn = "充县", province_key = "3k_main_province_wuling",  },
            ['3k_main_wuling_resource_2'] = { en_key = "chancheng", kr = "심성", en = "Chancheng", zh = "鐔成", cn = "镡成", province_key = "3k_main_province_wuling",  },
            ['3k_main_wuling_resource_3'] = { en_key = nil, kr = "공구 제작소", en = "Toolmaker", zh = "工具鋪", cn = "工具铺", province_key = "3k_main_province_wuling",  },
                ['3k_main_wuwei_capital'] = { en_key = "guzang", kr = "고장", en = "Guzang", zh = "姑臧", cn = "姑臧", is_capital = true, province_key = "3k_main_province_wuwei",  },
             ['3k_main_wuwei_resource_1'] = { en_key = "xiutu", kr = "휴도", en = "Xiutu", zh = "休屠", cn = "休屠", province_key = "3k_main_province_wuwei",  },
             ['3k_main_wuwei_resource_2'] = { en_key = "lingzhou", kr = "영주", en = "Lingzhou", zh = "靈州", cn = "灵州", province_key = "3k_main_province_wuwei",  },
            ['3k_main_xiangyang_capital'] = { en_key = "xiangyang", kr = "양양", en = "Xiangyang", zh = "襄陽", cn = "襄阳", is_capital = true, province_key = "3k_main_province_xiangyang",  },
         ['3k_main_xiangyang_resource_1'] = { en_key = "linju", kr = "임저", en = "linju", zh = "臨沮", cn = "临沮", province_key = "3k_main_province_xiangyang",  },
                 ['3k_main_xihe_capital'] = { en_key = "lishi", kr = "이석", en = "Lishi", zh = "離石", cn = "离石", is_capital = true, province_key = "3k_main_province_xihe",  },
              ['3k_main_xihe_resource_1'] = { en_key = "mengmen", kr = "맹문", en = "Mengmen", zh = "孟門", cn = "孟门", province_key = "3k_main_province_xihe",  },
                ['3k_main_xindu_capital'] = { en_key = "shixin", kr = "시신", en = "Shixin", zh = "始新", cn = "始新", is_capital = true, province_key = "3k_main_province_xindu",  },
             ['3k_main_xindu_resource_1'] = { en_key = "xinan", kr = "신안", en = "Xin'an", zh = "新安", cn = "新安", province_key = "3k_main_province_xindu",  },
             ['3k_main_xindu_resource_2'] = { en_key = "wuhu", kr = "무호", en = "Wuhu", zh = "蕪湖", cn = "芜湖", province_key = "3k_main_province_xindu",  },
             ['3k_main_yangzhou_capital'] = { en_key = "shouchun", kr = "수춘", en = "Shouchun", zh = "壽春", cn = "寿春", is_capital = true, province_key = "3k_main_province_yangzhou",  },
          ['3k_main_yangzhou_resource_1'] = { en_key = "fuli", kr = "부리", en = "Fuli", zh = "符離", cn = "符离", province_key = "3k_main_province_yangzhou",  },
          ['3k_main_yangzhou_resource_2'] = { en_key = "gushi", kr = "고시", en = "Gushi", zh = "固始", cn = "固始", province_key = "3k_main_province_yangzhou",  },
          ['3k_main_yangzhou_resource_3'] = { en_key = "juchao", kr = "거소", en = "Juchao", zh = "居巢", cn = "居巢", province_key = "3k_main_province_yangzhou",  },
               ['3k_main_yanmen_capital'] = { en_key = "yinguan", kr = "음관", en = "Yinguan", zh = "陰館", cn = "阴馆", is_capital = true, province_key = "3k_main_province_yanmen",  },
            ['3k_main_yanmen_resource_1'] = { en_key = "fanzhi", kr = "번치", en = "Fanzhi", zh = "繁峙", cn = "繁畤", province_key = "3k_main_province_yanmen",  },
                   ['3k_main_ye_capital'] = { en_key = nil, kr = "도성", en = "District", zh = "郡治", cn = "城市", is_capital = true, province_key = "3k_main_province_ye",  },
                ['3k_main_ye_resource_1'] = { en_key = nil, kr = "축사", en = "Livestock Farm", zh = "牲畜牧場", cn = "畜牧场", province_key = "3k_main_province_ye",  },
            ['3k_main_yingchuan_capital'] = { en_key = "xuchang", kr = "허창", en = "Xuchang", zh = "許昌", cn = "许昌", is_capital = true, province_key = "3k_main_province_yingchuan",  },
         ['3k_main_yingchuan_resource_1'] = { en_key = "chenliu", kr = "진류", en = "Chenliu", zh = "陳留", cn = "陈留", province_key = "3k_main_province_yingchuan",  },
               ['3k_main_yizhou_capital'] = { en_key = nil, kr = "도성", en = "District", zh = "郡治", cn = "城市", is_capital = true, province_key = "3k_main_province_yizhou",  },
            ['3k_main_yizhou_resource_1'] = { en_key = nil, kr = "벌목장", en = "Lumber Yard", zh = "鋸木場", cn = "贮木场", province_key = "3k_main_province_yizhou",  },
            ['3k_main_yizhou_resource_2'] = { en_key = nil, kr = "다관", en = "Teahouse", zh = "茶館", cn = "茶馆", province_key = "3k_main_province_yizhou",  },
        ['3k_main_yizhou_island_capital'] = { en_key = "danshui", kr = "담수", en = "Danshui", zh = "淡水", cn = "淡水", is_capital = true, province_key = "3k_main_province_yizhou_island",  },
     ['3k_main_yizhou_island_resource_1'] = { en_key = "chiqian", kr = "적감", en = "Chiqian", zh = "赤嵌", cn = "赤嵌", province_key = "3k_main_province_yizhou_island",  },
           ['3k_main_youbeiping_capital'] = { en_key = "tuyin", kr = "토은", en = "Tuyin", zh = "土垠", cn = "土垠", is_capital = true, province_key = "3k_main_province_youbeiping",  },
        ['3k_main_youbeiping_resource_1'] = { en_key = "linyu", kr = "임유", en = "Linyu", zh = "臨渝", cn = "临渝", province_key = "3k_main_province_youbeiping",  },
              ['3k_main_youzhou_capital'] = { en_key = "ji", kr = "계", en = "Ji", zh = "薊", cn = "蓟", is_capital = true, province_key = "3k_main_province_youzhou",  },
           ['3k_main_youzhou_resource_1'] = { en_key = "junmi", kr = "준미", en = "Junmi", zh = "俊靡", cn = "俊靡", province_key = "3k_main_province_youzhou",  },
                   ['3k_main_yu_capital'] = { en_key = "yangle", kr = "양락", en = "Yangle", zh = "陽樂", cn = "阳乐", is_capital = true, province_key = "3k_main_province_yu",  },
                ['3k_main_yu_resource_1'] = { en_key = "liucheng", kr = "유성", en = "Liucheng", zh = "柳城", cn = "柳城", province_key = "3k_main_province_yu",  },
                ['3k_main_yulin_capital'] = { en_key = "bushan", kr = "포산", en = "Bushan", zh = "布山", cn = "布山", is_capital = true, province_key = "3k_main_province_yulin",  },
             ['3k_main_yulin_resource_1'] = { en_key = "tanzhong", kr = "담중", en = "Tanzhong", zh = "潭中", cn = "潭中", province_key = "3k_main_province_yulin",  },
             ['3k_main_yulin_resource_2'] = { en_key = "guangyu", kr = "광울", en = "Guangyu", zh = "廣鬱", cn = "广郁", province_key = "3k_main_province_yulin",  },
              ['3k_main_yuzhang_capital'] = { en_key = "nanchang", kr = "남창", en = "Nanchang", zh = "南昌", cn = "南昌", is_capital = true, province_key = "3k_main_province_yuzhang",  },
           ['3k_main_yuzhang_resource_1'] = { en_key = "jianchang", kr = "건창", en = "Jianchang", zh = "建昌", cn = "建昌", province_key = "3k_main_province_yuzhang",  },
           ['3k_main_yuzhang_resource_2'] = { en_key = "geyang", kr = "갈양", en = "Geyang", zh = "葛陽", cn = "葛阳", province_key = "3k_main_province_yuzhang",  },
           ['3k_main_yuzhang_resource_3'] = { en_key = nil, kr = "구리 광산", en = "Copper Mine", zh = "銅礦", cn = "铜矿", province_key = "3k_main_province_yuzhang",  },
               ['3k_main_zangke_capital'] = { en_key = "julan", kr = "저란", en = "Julan", zh = "且蘭", cn = "且兰", is_capital = true, province_key = "3k_main_province_zangke",  },
            ['3k_main_zangke_resource_1'] = { en_key = "yelang", kr = "야랑", en = "Yelang", zh = "夜郎", cn = "夜郎", province_key = "3k_main_province_zangke",  },
            ['3k_main_zangke_resource_2'] = { en_key = "wulian", kr = "무렴", en = "Wulian", zh = "毋斂", cn = "毋敛", province_key = "3k_main_province_zangke",  },
            ['3k_main_zhongshan_capital'] = { en_key = "lunu", kr = "노노", en = "Lunu", zh = "盧奴", cn = "卢奴", is_capital = true, province_key = "3k_main_province_zhongshan",  },
         ['3k_main_zhongshan_resource_1'] = { en_key = "changshan", kr = "상산", en = "Changshan", zh = "常山", cn = "常山", province_key = "theg_province_changshan",  },
           ['3k_main_dongjun_resource_1'] = { en_key = "dongping", kr = "동평", en = "Dongping", zh = "東平", cn = "东平", province_key = "theg_province_dongping",  },
                  ['3k_dlc06_hangu_pass'] = { en_key = "hangu pass", kr = "함곡관", en = "Hangu Pass", zh = "函谷關", cn = "函谷关", is_capital = true, is_pass = true, province_key = "theg_province_hongnong",  },
                   ['3k_dlc06_tong_pass'] = { en_key = "tong pass", kr = "동관", en = "Tong Pass", zh = "潼關", cn = "潼关", is_capital = true, is_pass = true, province_key = "theg_province_hongnong",  },
              ['3k_main_taishan_capital'] = { en_key = "dongpingling", kr = "동평릉", en = "Dongpingling", zh = "東平陵", cn = "东平陵", is_capital = true, province_key = "theg_province_jinan",  },
           ['3k_main_taishan_resource_1'] = { en_key = "lean", kr = "낙안", en = "Lean", zh = "樂安", cn = "乐安", province_key = "theg_province_lean",  },
                    ['3k_dlc06_san_pass'] = { en_key = "san pass", kr = "산관", en = "San Pass", zh = "散關", cn = "散关", is_capital = true, is_pass = true, province_key = "theg_province_youfufeng",  },
                ['3k_dlc06_jiameng_pass'] = { en_key = "jiameng pass", kr = "가맹관", en = "Jiameng Pass", zh = "葭萌關", cn = "葭萌关", is_capital = true, is_pass = true, province_key = "theg_province_zitong",  },
-- regions_lua 211/211 skipped 0 err 0
}

-----------------------------------------------------------------------------------------------


		--------------------------------------------------------------------------------
								-- Build Region DB --
		--------------------------------------------------------------------------------

function sandbox:build_region_aliases()

	local log_head = "build_region_aliases"

	self.db_regions_kr = {}

	for pass_key, pass in pairs( self.db_county_passes ) do
		if self.db_regions[ pass_key ] then
			self.db_regions[ pass_key ].province_key = pass.province_key
		else
			logger:error( log_head, pass_key, "not found in db_regions")
		end
	end

	local province_count = 0
	for state_mod_key, state in pairs( self.db_states ) do
		self.db_states_kr[ state.en:gsub( "%s", "" ) ] = state_mod_key
		self.db_states_kr[ state.kr ] = state_mod_key
		self.db_states_kr[ state.zh ] = state_mod_key
		self.db_states_kr[ state.cn ] = state_mod_key

		province_count = province_count + 1
	end

	local skipped, county_count = 0, 0
	for region_tk_key, region in pairs( self.db_regions ) do

		if not self.db_provinces[ region.province_key ] then
			logger:error( log_head, "province not found", region_tk_key )
		end

		if region.en_key then
			if self.db_regions_kr[ region.en:gsub( "%s", "" ) ] then
				logger:warn( log_head, "en key dup", self.db_regions_kr[ region.en ], "_[:"..region.en, region_tk_key )
			end

			if self.db_regions_kr[ region.kr ] then
				logger:warn( log_head, "kr key dup", self.db_regions_kr[ region.kr ], "_[:"..region.kr, region_tk_key )
			end

			if self.db_regions_kr[ region.zh ] then
				logger:warn( log_head, "zh key dup", self.db_regions_kr[ region.zh ], "_[:"..region.zh, region_tk_key )
			end

			if self.db_regions_kr[ region.cn ] then
				logger:warn( log_head, "cn key dup", self.db_regions_kr[ region.cn ], "_[:"..region.cn, region_tk_key )
			end

			self.db_regions_kr[ region.en_key ] = region_tk_key

			self.db_regions_kr[ region.en:gsub( "%s", "" ):lower() ] = region_tk_key
			self.db_regions_kr[ region.kr ] = region_tk_key
			self.db_regions_kr[ region.zh ] = region_tk_key
			self.db_regions_kr[ region.cn ] = region_tk_key

			county_count = county_count + 1
		else
			skipped = skipped + 1
		end
	end

	for _, row in pairs( self.db_provinces ) do

		if not self.db_regions_kr[ row.en:gsub( "%s", "" ):lower() ] then
			self.db_regions_kr[ row.en:gsub( "%s", "" ) ] = row.capital_key
		end

		if not self.db_regions_kr[ row.kr ] then
			self.db_regions_kr[ row.kr ] = row.capital_key
			county_count = county_count + 1
		end

		if not self.db_regions_kr[ row.zh ] then
			self.db_regions_kr[ row.zh ] = row.capital_key
		end

		if not self.db_regions_kr[ row.cn ] then
			self.db_regions_kr[ row.cn ] = row.capital_key
		end

	end

	local state_count = 0
	for _, row in pairs( self.db_states ) do

		local capital_key = self.db_provinces[ row.province_key ].capital_key

		if not self.db_regions_kr[ row.en:gsub( "%s", "" ):lower() ] then
			self.db_regions_kr[ row.en:gsub( "%s", "" ) ] = capital_key
		end

		if not self.db_regions_kr[ row.kr ] then
			self.db_regions_kr[ row.kr ] = capital_key
		end

		if not self.db_regions_kr[ row.zh ] then
			self.db_regions_kr[ row.zh ] = capital_key
		end

		if not self.db_regions_kr[ row.cn ] then
			self.db_regions_kr[ row.cn ] = capital_key
		end

	end

	self.db_regions_kr['고관'] = "3k_dlc06_gu_pass"
	self.db_regions_kr['gupass'] = "3k_dlc06_gu_pass"
	self.db_regions_kr['故關'] = "3k_dlc06_gu_pass"
	self.db_regions_kr['故关'] = "3k_dlc06_gu_pass"

	self.db_regions_kr['소패'] = '3k_main_chenjun_resource_1'
	self.db_regions_kr['회남'] = '3k_main_yangzhou_capital'

	logger:info( log_head, _eq( "province", province_count ), _eq( "county", county_count ), _eq( "skipped", skipped ) )
end
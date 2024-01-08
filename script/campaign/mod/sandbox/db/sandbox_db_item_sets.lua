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

local default_category_tup = {
	count = 0,
	legendary = { count = 0, weapon = {}, mount = {}, accessory = {}, follower = {}, armour = {} },
	unique = { count = 0, weapon = {}, mount = {}, accessory = {}, follower = {}, armour = {} },
	exceptional = { count = 0, weapon = {}, mount = {}, accessory = {}, follower = {}, armour = {} },
	refined = { count = 0, weapon = {}, mount = {}, accessory = {}, follower = {}, armour = {} },
	common = { count = 0, weapon = {}, mount = {}, accessory = {}, follower = {}, armour = {} },
}

sandbox.item_categories = {
	count = 0,
	['tke'] = {
		count = 0,
		legendary = { count = 0, weapon = {}, mount = {}, accessory = {}, follower = {}, armour = {} },
		unique = { count = 0, weapon = {}, mount = {}, accessory = {}, follower = {}, armour = {} },
		exceptional = { count = 0, weapon = {}, mount = {}, accessory = {}, follower = {}, armour = {} },
		refined = { count = 0, weapon = {}, mount = {}, accessory = {}, follower = {}, armour = {} },
		common = { count = 0, weapon = {}, mount = {}, accessory = {}, follower = {}, armour = {} },
	},
	['moh'] = {
		count = 0,
		legendary = { count = 0, weapon = {}, mount = {}, accessory = {}, follower = {}, armour = {} },
		unique = { count = 0, weapon = {}, mount = {}, accessory = {}, follower = {}, armour = {} },
		exceptional = { count = 0, weapon = {}, mount = {}, accessory = {}, follower = {}, armour = {} },
		refined = { count = 0, weapon = {}, mount = {}, accessory = {}, follower = {}, armour = {} },
		common = { count = 0, weapon = {}, mount = {}, accessory = {}, follower = {}, armour = {} },
	},
	['ytr'] = {
		count = 0,
		legendary = { count = 0, weapon = {}, mount = {}, accessory = {}, follower = {}, armour = {} },
		unique = { count = 0, weapon = {}, mount = {}, accessory = {}, follower = {}, armour = {} },
		exceptional = { count = 0, weapon = {}, mount = {}, accessory = {}, follower = {}, armour = {} },
		refined = { count = 0, weapon = {}, mount = {}, accessory = {}, follower = {}, armour = {} },
		common = { count = 0, weapon = {}, mount = {}, accessory = {}, follower = {}, armour = {} },
	},
	['ep'] = {
		count = 0,
		legendary = { count = 0, weapon = {}, mount = {}, accessory = {}, follower = {}, armour = {} },
		unique = { count = 0, weapon = {}, mount = {}, accessory = {}, follower = {}, armour = {} },
		exceptional = { count = 0, weapon = {}, mount = {}, accessory = {}, follower = {}, armour = {} },
		refined = { count = 0, weapon = {}, mount = {}, accessory = {}, follower = {}, armour = {} },
		common = { count = 0, weapon = {}, mount = {}, accessory = {}, follower = {}, armour = {} },
	},
	['wb'] = {
		count = 0,
		legendary = { count = 0, weapon = {}, mount = {}, accessory = {}, follower = {}, armour = {} },
		unique = { count = 0, weapon = {}, mount = {}, accessory = {}, follower = {}, armour = {} },
		exceptional = { count = 0, weapon = {}, mount = {}, accessory = {}, follower = {}, armour = {} },
		refined = { count = 0, weapon = {}, mount = {}, accessory = {}, follower = {}, armour = {} },
		common = { count = 0, weapon = {}, mount = {}, accessory = {}, follower = {}, armour = {} },
	},
	['fw'] = {
		count = 0,
		legendary = { count = 0, weapon = {}, mount = {}, accessory = {}, follower = {}, armour = {} },
		unique = { count = 0, weapon = {}, mount = {}, accessory = {}, follower = {}, armour = {} },
		exceptional = { count = 0, weapon = {}, mount = {}, accessory = {}, follower = {}, armour = {} },
		refined = { count = 0, weapon = {}, mount = {}, accessory = {}, follower = {}, armour = {} },
		common = { count = 0, weapon = {}, mount = {}, accessory = {}, follower = {}, armour = {} },
	},
	['fd'] = {
		count = 0,
		legendary = { count = 0, weapon = {}, mount = {}, accessory = {}, follower = {}, armour = {} },
		unique = { count = 0, weapon = {}, mount = {}, accessory = {}, follower = {}, armour = {} },
		exceptional = { count = 0, weapon = {}, mount = {}, accessory = {}, follower = {}, armour = {} },
		refined = { count = 0, weapon = {}, mount = {}, accessory = {}, follower = {}, armour = {} },
		common = { count = 0, weapon = {}, mount = {}, accessory = {}, follower = {}, armour = {} },
	},
}

sandbox.db_item_user_sets = {}
sandbox.db_faction_sets = {}

sandbox.db_item_sets =
{
-- item sets
                                   ['the_builder'] = { kr = "건설자", location = "character", en = "The Builder", zh = "建造家", cn = "建造家", [1] = '3k_main_ancillary_accessory_jade_snake', [2] = '3k_main_ancillary_follower_builder' },
                                   ['martial_law'] = { kr = "계엄령", location = "character", en = "Martial Law", zh = "戒嚴", cn = "戒嚴", [1] = '3k_main_ancillary_accessory_discourses_of_the_states', [2] = '3k_main_ancillary_follower_law_enforcer' },
                                 ['ancient_sight'] = { kr = "고대의 식견", location = "character", en = "Ancient Sight", zh = "古代風光", cn = "古代風光", [1] = '3k_main_ancillary_accessory_book_of_documents', [2] = '3k_main_ancillary_follower_confucian_sage' },
                           ['expert_of_workshops'] = { kr = "공방의 전문가", location = "character", en = "Expert of Workshops", zh = "作坊專家", cn = "作坊專家", [1] = '3k_main_ancillary_accessory_stone_monkey', [2] = '3k_main_ancillary_follower_foreman' },
                        ['protectors_of_the_army'] = { kr = "군단의 수호자", location = "character", en = "Protectors of the Army", zh = "護軍", cn = "護軍", [1] = '3k_dlc05_ancillary_title_general_of_the_left', [2] = '3k_dlc05_ancillary_title_general_of_the_front', [3] = '3k_dlc05_ancillary_title_director_of_retainers_who_scales_the_city_wall', [4] = '3k_dlc05_ancillary_title_general_of_the_right', [5] = '3k_dlc05_ancillary_title_general_of_a_hundred_victories', [6] = '3k_dlc05_ancillary_title_general_of_heavenly_vision', [7] = '3k_dlc05_ancillary_title_general_who_stands_his_ground', [8] = '3k_dlc05_ancillary_title_general_of_the_guards', [9] = '3k_dlc05_ancillary_title_general_of_chariots_and_cavalry' },
                                  ['military_law'] = { kr = "군법", location = "character", en = "Military Law", zh = "軍法", cn = "軍法", [1] = '3k_main_ancillary_follower_military_expert', [2] = '3k_main_ancillary_accessory_wei_liaozi' },
                            ['expert_of_barracks'] = { kr = "군영의 전문가", location = "character", en = "Expert of Barracks", zh = "軍營專家", cn = "軍營專家", [1] = '3k_main_ancillary_accessory_clay_warrior', [2] = '3k_main_ancillary_follower_foreman' },
                                  ['men_of_merit'] = { kr = "군자", location = "character", en = "Men of Merit", zh = "賢士", cn = "賢士", [1] = '3k_dlc05_ancillary_title_chief_of_records', [2] = '3k_dlc05_ancillary_title_orator', [3] = '3k_dlc05_ancillary_title_general_of_flying_cavalry', [4] = '3k_dlc05_ancillary_title_senior_officer', [5] = '3k_dlc05_ancillary_title_attendant', [6] = '3k_dlc05_ancillary_title_general_in_chief', [7] = '3k_dlc05_ancillary_title_patrol_commander' },
                       ['commander_of_the_masses'] = { kr = "군중의 지도자", location = "character", en = "Commander of the Masses", zh = "大眾指揮者", cn = "大眾指揮者", [1] = '3k_main_ancillary_follower_jade_sculptor', [2] = '3k_main_ancillary_accessory_rites_of_zhou' },
                          ['expert_of_the_palace'] = { kr = "궁전의 전문가", location = "character", en = "Expert of the Palace", zh = "宮殿專家", cn = "宮殿專家", [1] = '3k_main_ancillary_follower_foreman', [2] = '3k_main_ancillary_accessory_stone_rooster' },
                           ['raiment_of_nobility'] = { kr = "귀족의 복장", location = "character", en = "Raiment of Nobility", zh = "貴族的華服", cn = "貴族的華服", [1] = '3k_main_ancillary_armour_light_armour_earth_extraordinary', [2] = '3k_main_ancillary_weapon_one_handed_axe_exceptional' },
                                   ['enginesmith'] = { kr = "기계 제작자", location = "character", en = "Enginesmith", zh = "工程師", cn = "工程師", [1] = '3k_main_ancillary_follower_forge_master', [2] = '3k_main_ancillary_accessory_mozi' },
                         ['harvester_of_tomorrow'] = { kr = "내일의 수확자", location = "character", en = "Harvester of Tomorrow", zh = "明日的收成者", cn = "明日的收成者", [1] = '3k_main_ancillary_follower_diviner', [2] = '3k_main_ancillary_accessory_clay_dog' },
                         ['spirit_of_agriculture'] = { kr = "농업의 영령", location = "character", en = "Spirit of Agriculture", zh = "農業精神", cn = "農業精神", [1] = '3k_main_ancillary_accessory_jade_sickle', [2] = '3k_main_ancillary_follower_provincial_advisor' },
                               ['expert_of_farms'] = { kr = "농장의 전문가", location = "character", en = "Expert of Farms", zh = "農場專家", cn = "農場專家", [1] = '3k_main_ancillary_follower_foreman', [2] = '3k_main_ancillary_accessory_clay_ox' },
                              ['natures_guidance'] = { kr = "대자연의 인도", location = "character", en = "Nature's Guidance", zh = "自然的指引", cn = "自然的指引", [1] = '3k_main_ancillary_follower_astronomer', [2] = '3k_main_ancillary_accessory_water_clock' },
                            ['tamer_of_the_earth'] = { kr = "대지의 조련사", location = "character", en = "Tamer of the Earth", zh = "善耕家", cn = "善耕家", [1] = '3k_main_ancillary_accessory_book_of_mountains_and_seas', [2] = '3k_main_ancillary_follower_elite_trainer' },
                                      ['monopoly'] = { kr = "독점", location = "character", en = "Monopoly", zh = "壟斷", cn = "壟斷", [1] = '3k_main_ancillary_follower_merchant', [2] = '3k_main_ancillary_accessory_the_nine_chapters_on_the_mathematical_art' },
                                     ['mobiliser'] = { kr = "동원병", location = "character", en = "Mobiliser", zh = "動員專家", cn = "動員專家", [1] = '3k_main_ancillary_follower_military_expert', [2] = '3k_main_ancillary_accessory_wuzi' },
                             ['tacticians_design'] = { kr = "모사의 계획", location = "character", en = "Tactician's Design", zh = "軍師的佈局", cn = "軍師的佈局", [1] = '3k_main_ancillary_armour_shi_xies_armour_unique', [2] = '3k_main_ancillary_weapon_ceremonial_sword_exceptional' },
                         ['scholar_of_the_future'] = { kr = "미래의 학자", location = "character", en = "Scholar of the Future", zh = "未來的學者", cn = "未來的學者", [1] = '3k_main_ancillary_follower_scholar', [2] = '3k_main_ancillary_accessory_book_of_changes' },
                                      ['fireborn'] = { kr = "발화", location = "character", en = "Fireborn", zh = "生於火中", cn = "生於火中", [1] = '3k_main_ancillary_weapon_two_handed_spear_unique', [2] = '3k_main_ancillary_armour_medium_armour_fire_unique' },
                               ['peoples_justice'] = { kr = "백성의 정의", location = "character", en = "People's Justice", zh = "百姓的正義", cn = "百姓的正義", [1] = '3k_main_ancillary_follower_inspector', [2] = '3k_main_ancillary_accessory_the_methods_of_the_sima' },
                                 ['constellation'] = { kr = "별자리", location = "character", en = "Constellation", zh = "星宿", cn = "星宿", [1] = '3k_main_ancillary_armour_medium_armour_metal_extraordinary', [2] = '3k_main_ancillary_weapon_double_edged_sword_exceptional' },
                                  ['preservation'] = { kr = "보존", location = "character", en = "Preservation", zh = "保存", cn = "保存", [1] = '3k_main_ancillary_follower_master_craftsman', [2] = '3k_main_ancillary_accessory_ceremonial_stone_axe' },
                                  ['lord_of_fire'] = { kr = "불의 지배자", location = "character", en = "Lord of Fire", zh = "火焰主宰", cn = "火焰主宰", [1] = '3k_main_ancillary_weapon_two_handed_spear_exceptional', [2] = '3k_main_ancillary_armour_medium_armour_fire_extraordinary' },
                              ['hidden_stratagem'] = { kr = "비책", location = "character", en = "Hidden Stratagem", zh = "深藏不露的奇謀", cn = "深藏不露的奇謀", [1] = '3k_main_ancillary_follower_military_instructor', [2] = '3k_main_ancillary_accessory_six_secret_teachings' },
                                  ['vital_spirit'] = { kr = "생명의 영령", location = "character", en = "Vital Spirit", zh = "活力十足", cn = "活力十足", [1] = '3k_main_ancillary_follower_hua_tuo', [2] = '3k_main_ancillary_accessory_hua_tuos_manual' },
                                        ['orator'] = { kr = "세객", location = "character", en = "Orator", zh = "能言善道", cn = "能言善道", [1] = '3k_main_ancillary_accessory_classic_of_filial_piety', [2] = '3k_main_ancillary_follower_philosopher' },
                            ['essence_of_sun_tzu'] = { kr = "손자의 정수", location = "character", en = "Essence of Sun Tzu", zh = "孫子精義", cn = "孫子精義", [1] = '3k_main_ancillary_accessory_art_of_war', [2] = '3k_main_ancillary_follower_military_instructor' },
                              ['infamous_bandits'] = { kr = "악명 높은 도적떼", location = "character", en = "Infamous Bandits", zh = "惡名盜賊", cn = "惡名盜賊", [1] = '3k_dlc05_ancillary_title_ox_horn_general', [2] = '3k_dlc05_ancillary_title_flying_swallow_general', [3] = '3k_dlc05_ancillary_title_gold_spotted_leopard', [4] = '3k_dlc05_ancillary_title_pacifier_of_the_han' },
                                    ['perfection'] = { kr = "완벽성", location = "character", en = "Perfection", zh = "盡善盡美", cn = "盡善盡美", [1] = '3k_main_ancillary_armour_medium_armour_metal_unique', [2] = '3k_main_ancillary_weapon_double_edged_sword_unique' },
                              ['hand_of_the_king'] = { kr = "왕의 손길", location = "character", en = "Hand of the King", zh = "君王之手", cn = "君王之手", [1] = '3k_main_ancillary_follower_provincial_auditor', [2] = '3k_main_ancillary_accessory_the_three_strategies_of_the_duke_of_the_yellow_rock' },
                                  ['the_fortress'] = { kr = "요새", location = "character", en = "The Fortress", zh = "堡壘", cn = "堡壘", [1] = '3k_main_ancillary_weapon_halberd_unique', [2] = '3k_main_ancillary_armour_heavy_armour_wood_unique' },
                            ['heart_of_courage_1'] = { kr = "용맹한 마음 [1]", location = "character", en = "Heart of Courage [I]", zh = "英勇之心·一", cn = "英勇之心·一", [1] = '3k_dlc06_ancillary_weapon_bow_king_shamoke_unique', [2] = '3k_dlc06_ancillary_armour_nanman_king_shamoke_unique' },
                            ['heart_of_courage_2'] = { kr = "용맹한 마음 [2]", location = "character", en = "Heart of Courage [II]", zh = "英勇之心·二", cn = "英勇之心·二", [1] = '3k_main_ancillary_follower_overseer', [2] = '3k_dlc06_ancillary_armour_nanman_king_shamoke_unique', [3] = '3k_dlc06_ancillary_weapon_bow_king_shamoke_unique' },
                               ['dragon_warriors'] = { kr = "용의 전사들", location = "character", en = "Dragon Warriors", zh = "蛟龍勇士", cn = "蛟龍勇士", [1] = '3k_dlc05_ancillary_title_coiled_dragon', [2] = '3k_dlc05_ancillary_title_yellow_dragon', [3] = '3k_dlc05_ancillary_title_blood_dragon', [4] = '3k_dlc05_ancillary_title_earth_dragon' },
                                 ['dragons_storm'] = { kr = "용의 폭풍", location = "character", en = "Dragon's Storm", zh = "龍之風暴", cn = "龍之風暴", [1] = '3k_main_ancillary_weapon_composite_bow_unique', [2] = '3k_main_ancillary_armour_strategist_light_armour_water_unique' },
                         ['lords_of_the_elements'] = { kr = "자연의 주인", location = "character", en = "Lords of the Elements", zh = "五行天師", cn = "五行天師", [1] = '3k_dlc05_ancillary_title_general_who_calms_the_waves', [2] = '3k_dlc05_ancillary_title_iron_general', [3] = '3k_dlc05_ancillary_title_lord_of_thunder', [4] = '3k_dlc05_ancillary_title_guardian_of_three_mountains', [5] = '3k_dlc05_ancillary_title_master_of_the_hunt' },
                                      ['the_wall'] = { kr = "장벽", location = "character", en = "The Wall", zh = "長城", cn = "長城", [1] = '3k_main_ancillary_armour_heavy_armour_wood_extraordinary', [2] = '3k_main_ancillary_weapon_halberd_exceptional' },
                                    ['bookkeeper'] = { kr = "장부 관리인", location = "character", en = "Bookkeeper", zh = "簿記員", cn = "簿記員", [1] = '3k_main_ancillary_follower_local_administrator', [2] = '3k_main_ancillary_accessory_stone_rat' },
                                ['mandate_of_war'] = { kr = "전쟁의 명령", location = "character", en = "Mandate of War", zh = "兵權", cn = "兵權", [1] = '3k_main_ancillary_armour_strategist_light_armour_water_unique', [2] = '3k_main_ancillary_weapon_ceremonial_sword_unique' },
                                 ['shadow_runner'] = { kr = "절영", location = "character", en = "Shadow Runner", zh = "絕影", cn = "絕影", [1] = '3k_main_ancillary_mount_shadow_runner', [2] = '3k_main_ancillary_accessory_jade_horseman' },
              ['gennerals_who_supports_the_state'] = { kr = "제국을 떠받치는 장수들", location = "character", en = "Generals Who Support the State", zh = "輔國將軍", cn = "輔國將軍", [1] = '3k_dlc05_ancillary_title_general_of_the_standard', [2] = '3k_dlc05_ancillary_title_protector_of_righteousness', [3] = '3k_dlc05_ancillary_title_general_who_supports_the_han', [4] = '3k_dlc05_ancillary_title_general_who_smashes_the_caitiffs' },
                               ['heavenly_flight'] = { kr = "천상의 비행", location = "character", en = "Heavenly Flight", zh = "遨翔九天", cn = "遨翔九天", [1] = '3k_main_ancillary_follower_tycoon', [2] = '3k_main_ancillary_accessory_jade_archer' },
                 ['generals_who_subdue_the_world'] = { kr = "천하를 다스리는 장수들", location = "character", en = "Generals Who Subdue the World", zh = "鎮世將軍", cn = "鎮世將軍", [1] = '3k_dlc05_ancillary_title_general_who_brings_tranquillity_to_the_north', [2] = '3k_dlc05_ancillary_title_general_whom_expands_the_centre', [3] = '3k_dlc05_ancillary_title_general_who_pacifies_the_south' },
                           ['incorrupt_officials'] = { kr = "청렴한 관리", location = "character", en = "Incorrupt Officials", zh = "清廉官吏", cn = "清廉官吏", [1] = '3k_dlc05_ancillary_title_steward_of_the_changle_palace', [2] = '3k_dlc05_ancillary_title_master_of_writing', [3] = '3k_dlc05_ancillary_title_divine_mathematician', [4] = '3k_dlc05_ancillary_title_divine_physician', [5] = '3k_dlc05_ancillary_title_director_of_astronomy' },
                        ['garb_of_the_first_sage'] = { kr = "초대 현자의 복장", location = "character", en = "Garb of the First Sage", zh = "先賢之袍", cn = "先賢之袍", [1] = '3k_main_ancillary_weapon_dual_swords_unique', [2] = '3k_main_ancillary_armour_light_armour_earth_unique' },
                                  ['earthwatcher'] = { kr = "풍수지리사", location = "character", en = "Earthwatcher", zh = "地象觀測者", cn = "地象觀測者", [1] = '3k_main_ancillary_follower_professor', [2] = '3k_main_ancillary_accessory_earthquake_watching_device' },
                                ['celestial_fury'] = { kr = "하늘의 분노", location = "character", en = "Celestial Fury", zh = "天怒", cn = "天怒", [1] = '3k_main_ancillary_weapon_composite_bow_exceptional', [2] = '3k_main_ancillary_armour_shi_xies_armour_unique' },
                           ['knowledge_of_heaven'] = { kr = "하늘의 지식", location = "character", en = "Knowledge of Heaven", zh = "天文知識", cn = "天文知識", [1] = '3k_main_ancillary_follower_diviner', [2] = '3k_main_ancillary_accessory_celestial_sphere' },
                           ['expert_of_academies'] = { kr = "학당의 전문가", location = "character", en = "Expert of Academies", zh = "學院專家", cn = "學院專家", [1] = '3k_main_ancillary_follower_foreman', [2] = '3k_main_ancillary_accessory_clay_cup' },
                            ['lu_bu_setting_suns'] = { kr = "가문 재건", location = "faction", en = "Setting Suns", zh = "孫郎殞落", cn = "孫郎殞落", [1] = '3k_dlc05_ceo_factional_warrior_defeated_sun_quan', [2] = '3k_dlc05_ceo_factional_warrior_defeated_sun_ce', [3] = '3k_dlc05_ceo_factional_warrior_defeated_sun_ren' },
                   ['lu_bu_warriors_of_the_south'] = { kr = "강남의 전사들", location = "faction", en = "Warriors of the South", zh = "南方勇士", cn = "南方勇士", [1] = '3k_dlc05_ceo_factional_warrior_defeated_huang_gai', [2] = '3k_dlc05_ceo_factional_warrior_defeated_gan_ning', [3] = '3k_dlc05_ceo_factional_warrior_defeated_zhou_tai', [4] = '3k_dlc05_ceo_factional_warrior_defeated_taishi_ci' },
   ['sun_ce_ambition_achieve_bandits_and_murders'] = { kr = "강도떼와 살인자들", location = "faction", en = "Bandits & Murderers", zh = "盜匪兇徒", cn = "盜匪兇徒", [1] = '3k_dlc05_ceo_sun_ce_ambition_achieve_defeat_the_white_tiger', [2] = '3k_dlc05_ceo_sun_ce_ambition_achieve_defeat_huang_zu' },
                   ['lu_bu_bruisers_and_brawlers'] = { kr = "거한과 장사", location = "faction", en = "Bruisers & Brawlers", zh = "好鬥勇夫", cn = "好鬥勇夫", [1] = '3k_dlc05_ceo_factional_warrior_defeated_dian_wei', [2] = '3k_dlc05_ceo_factional_warrior_defeated_xu_chu' },
                                ['lu_zhi_resolve'] = { kr = "결의", location = "faction", en = "Resolve", zh = "決心", cn = "決心", [1] = '3k_dlc04_ceo_factional_great_library_resolve_exceptional', [2] = '3k_dlc04_ceo_factional_great_library_resolve_unique', [3] = '3k_dlc04_ceo_factional_great_library_resolve_common', [4] = '3k_dlc04_ceo_factional_great_library_resolve_refined' },
             ['sun_ce_ambition_recruit_old_guard'] = { kr = "고참 근위대", location = "faction", en = "The Old Guard", zh = "護國老將", cn = "護國老將", [1] = '3k_dlc05_ceo_sun_ce_ambition_recruit_old_fire', [2] = '3k_dlc05_ceo_sun_ce_ambition_recruit_old_metal' },
                 ['sun_ce_ambition_secure_kuaiji'] = { kr = "군량 확보", location = "faction", en = "Secure Campaign Provisions", zh = "確保戰役糧草", cn = "確保戰役糧草", [1] = '3k_dlc05_ceo_sun_ce_ambition_secure_kuaiji_rice_paddy', [2] = '3k_dlc05_ceo_sun_ce_ambition_secure_kuaiji_capital', [3] = '3k_dlc05_ceo_sun_ce_ambition_secure_kuaiji_livestock' },
                              ['lu_zhi_authority'] = { kr = "권위", location = "faction", en = "Authority", zh = "權威", cn = "權威", [1] = '3k_dlc04_ceo_factional_great_library_authority_unique', [2] = '3k_dlc04_ceo_factional_great_library_authority_exceptional', [3] = '3k_dlc04_ceo_factional_great_library_authority_refined', [4] = '3k_dlc04_ceo_factional_great_library_authority_common' },
                     ['sun_ce_ambition_secure_wu'] = { kr = "기초 자원 확보", location = "faction", en = "Secure the Base Resources", zh = "掌控基本資源", cn = "掌控基本資源", [1] = '3k_dlc05_ceo_sun_ce_ambition_secure_jianye_capital', [2] = '3k_dlc05_ceo_sun_ce_ambition_secure_jianye_copper_mine', [3] = '3k_dlc05_ceo_sun_ce_ambition_secure_jianye_salt_mine' },
          ['sun_ce_ambition_secure_the_homestead'] = { kr = "농지 확보", location = "faction", en = "Secure the Homestead", zh = "掌控農莊", cn = "掌控農莊", [1] = '3k_dlc05_ceo_sun_ce_ambition_secure_changsha_trade_port', [2] = '3k_dlc05_ceo_sun_ce_ambition_secure_changsha_teahouse', [3] = '3k_dlc05_ceo_sun_ce_ambition_secure_changsha_capital', [4] = '3k_dlc05_ceo_sun_ce_ambition_secure_changsha_armour_craftsmen' },
           ['sun_ce_ambition_recruit_young_guard'] = { kr = "다음 세대", location = "faction", en = "Next Generation", zh = "新生代", cn = "新生代", [1] = '3k_dlc05_ceo_sun_ce_ambition_recruit_young_metal_fire', [2] = '3k_dlc05_ceo_sun_ce_ambition_recruit_young_water', [3] = '3k_dlc05_ceo_sun_ce_ambition_recruit_young_earth_wood' },
                      ['lu_bu_bandits_and_rogues'] = { kr = "도적과 강도", location = "faction", en = "Bandits & Rogues", zh = "盜匪流氓", cn = "盜匪流氓", [1] = '3k_dlc05_ceo_factional_warrior_defeated_yan_baihu', [2] = '3k_dlc05_ceo_factional_warrior_defeated_zhang_yan', [3] = '3k_dlc05_ceo_factional_warrior_defeated_zheng_jiang' },
          ['sun_ce_ambition_recruit_grandmasters'] = { kr = "도통한 달인", location = "faction", en = "Grandmasters", zh = "當世宗師", cn = "當世宗師", [1] = '3k_dlc05_ceo_sun_ce_ambition_recruit_grandmasters_fire', [2] = '3k_dlc05_ceo_sun_ce_ambition_recruit_grandmasters_wood', [3] = '3k_dlc05_ceo_sun_ce_ambition_recruit_grandmasters_earth', [4] = '3k_dlc05_ceo_sun_ce_ambition_recruit_grandmasters_water', [5] = '3k_dlc05_ceo_sun_ce_ambition_recruit_grandmasters_metal' },
                               ['lu_zhi_instinct'] = { kr = "본능", location = "faction", en = "Instinct", zh = "本能", cn = "本能", [1] = '3k_dlc04_ceo_factional_great_library_instinct_exceptional', [2] = '3k_dlc04_ceo_factional_great_library_instinct_refined', [3] = '3k_dlc04_ceo_factional_great_library_instinct_unique', [4] = '3k_dlc04_ceo_factional_great_library_instinct_common' },
                      ['lu_bu_northern_defenders'] = { kr = "북방의 수호자", location = "faction", en = "Northern Defenders", zh = "北方戍守", cn = "北方戍守", [1] = '3k_dlc05_ceo_factional_warrior_defeated_han_sui', [2] = '3k_dlc05_ceo_factional_warrior_defeated_gongsun_zan', [3] = '3k_dlc05_ceo_factional_warrior_defeated_ma_teng' },
          ['sun_ce_ambition_secure_the_heartland'] = { kr = "산지 확보", location = "faction", en = "Secure the Mountains", zh = "掌控山區", cn = "掌控山區", [1] = '3k_dlc05_ceo_sun_ce_ambition_secure_xindu_capital', [2] = '3k_dlc05_ceo_sun_ce_ambition_secure_xindu_lumber_yard', [3] = '3k_dlc05_ceo_sun_ce_ambition_secure_xindu_fishing_port' },
                          ['lu_bu_three_kingdoms'] = { kr = "삼국", location = "faction", en = "Three Kingdoms", zh = "三國", cn = "三國", [1] = '3k_dlc05_ceo_factional_warrior_defeated_liu_bei', [2] = '3k_dlc05_ceo_factional_warrior_defeated_sun_ce', [3] = '3k_dlc05_ceo_factional_warrior_defeated_cao_cao' },
  ['sun_ce_ambition_achieve_the_little_conqueror'] = { kr = "소패왕", location = "faction", en = "The Little Conqueror", zh = "小霸王", cn = "小霸王", [1] = '3k_dlc05_ceo_sun_ce_ambition_achieve_sun_familiy_rises_again', [2] = '3k_dlc05_ceo_sun_ce_ambition_achieve_unbeatable', [3] = '3k_dlc05_ceo_sun_ce_ambition_achieve_tiny_conqueror' },
['sun_ce_ambition_recruit_four_warriors_of_china'] = { kr = "손부인의 호위병", location = "faction", en = "Lady Sun's Guards", zh = "孫夫人的侍衛", cn = "孫夫人的侍衛", [1] = '3k_dlc05_ceo_sun_ce_ambition_recruit_female_earth_wood', [2] = '3k_dlc05_ceo_sun_ce_ambition_recruit_female_metal_fire' },
      ['sun_ce_ambition_recruit_legacy_of_sun_ce'] = { kr = "손책의 유산", location = "faction", en = "Legacy of Sun Ce", zh = "孫策偉業", cn = "孫策偉業", [1] = '3k_dlc05_ceo_sun_ce_ambition_recruit_high_level_sun_quan', [2] = '3k_dlc05_ceo_sun_ce_ambition_recruit_high_level_zhou_yu', [3] = '3k_dlc05_ceo_sun_ce_ambition_recruit_high_level_sun_ce', [4] = '3k_dlc05_ceo_sun_ce_ambition_recruit_high_level_lady_sun' },
                          ['lu_bu_father_figures'] = { kr = "아버지의 상", location = "faction", en = "Father Figures", zh = "為人父者", cn = "為人父者", [1] = '3k_dlc05_ceo_factional_warrior_defeated_dong_zhuo', [2] = '3k_dlc05_ceo_factional_warrior_defeated_ding_yuan' },
                             ['lu_bu_five_elites'] = { kr = "오장", location = "faction", en = "Five Elites", zh = "五豪傑", cn = "五豪傑", [1] = '3k_dlc05_ceo_factional_warrior_defeated_zhange_he', [2] = '3k_dlc05_ceo_factional_warrior_defeated_zhang_liao', [3] = '3k_dlc05_ceo_factional_warrior_defeated_yue_jin', [4] = '3k_dlc05_ceo_factional_warrior_defeated_yu_jin', [5] = '3k_dlc05_ceo_factional_warrior_defeated_xu_huang' },
                          ['lu_bu_tiger_generals'] = { kr = "오호대장군", location = "faction", en = "Tiger Generals", zh = "五虎將", cn = "五虎將", [1] = '3k_dlc05_ceo_factional_warrior_defeated_huang_zhong', [2] = '3k_dlc05_ceo_factional_warrior_defeated_zhao_yun', [3] = '3k_dlc05_ceo_factional_warrior_defeated_guan_yu', [4] = '3k_dlc05_ceo_factional_warrior_defeated_zhang_fei', [5] = '3k_dlc05_ceo_factional_warrior_defeated_ma_chao' },
                               ['lu_bu_yuan_clan'] = { kr = "원가", location = "faction", en = "Yuan Clan", zh = "袁氏", cn = "袁氏", [1] = '3k_dlc05_ceo_factional_warrior_defeated_yuan_shu', [2] = '3k_dlc05_ceo_factional_warrior_defeated_yuan_shao' },
                       ['lu_bu_great_strategists'] = { kr = "위대한 모사", location = "faction", en = "Great Strategists", zh = "善謀策士", cn = "善謀策士", [1] = '3k_dlc05_ceo_factional_warrior_defeated_zhuge_liang', [2] = '3k_dlc05_ceo_factional_warrior_defeated_sima_yi', [3] = '3k_dlc05_ceo_factional_warrior_defeated_pang_tong', [4] = '3k_dlc05_ceo_factional_warrior_defeated_guo_jia', [5] = '3k_dlc05_ceo_factional_warrior_defeated_zhou_yu' },
                          ['lu_bu_sworn_brothers'] = { kr = "의형제", location = "faction", en = "Sworn Brothers", zh = "義結金蘭", cn = "義結金蘭", [1] = '3k_dlc05_ceo_factional_warrior_defeated_guan_yu', [2] = '3k_dlc05_ceo_factional_warrior_defeated_zhang_fei', [3] = '3k_dlc05_ceo_factional_warrior_defeated_liu_bei' },
     ['sun_ce_ambition_secure_the_middle_yangtze'] = { kr = "장강 중류 확보", location = "faction", en = "Secure the middle Yangtze", zh = "掌控長江中段", cn = "掌控長江中段", [1] = '3k_dlc05_ceo_sun_ce_ambition_secure_poyang_capital', [2] = '3k_dlc05_ceo_sun_ce_ambition_secure_poyang_iron_mine', [3] = '3k_dlc05_ceo_sun_ce_ambition_secure_poyang_copper_mine', [4] = '3k_dlc05_ceo_sun_ce_ambition_secure_poyang_weapon_craftsmen' },
                     ['lu_bu_traitors_of_changan'] = { kr = "장안의 역적들", location = "faction", en = "Traitors of Chang'an", zh = "長安叛徒", cn = "長安叛徒", [1] = '3k_dlc05_ceo_factional_warrior_defeated_li_jue', [2] = '3k_dlc05_ceo_factional_warrior_defeated_jia_xu', [3] = '3k_dlc05_ceo_factional_warrior_defeated_guo_si' },
                              ['lu_zhi_expertise'] = { kr = "전문성", location = "faction", en = "Expertise", zh = "專精", cn = "專精", [1] = '3k_dlc04_ceo_factional_great_library_expertise_refined', [2] = '3k_dlc04_ceo_factional_great_library_expertise_common', [3] = '3k_dlc04_ceo_factional_great_library_expertise_unique', [4] = '3k_dlc04_ceo_factional_great_library_expertise_exceptional' },
                         ['lu_bu_cousins_in_arms'] = { kr = "전우", location = "faction", en = "Cousins-in-Arms", zh = "軍中同袍", cn = "軍中同袍", [1] = '3k_dlc05_ceo_factional_warrior_defeated_xiahou_dun', [2] = '3k_dlc05_ceo_factional_warrior_defeated_xiahou_yuan' },
           ['sun_ce_ambition_the_southern_threat'] = { kr = "제위로 향하는 길", location = "faction", en = "The Road to Emperorship", zh = "登基之路", cn = "登基之路", [1] = '3k_dlc05_ceo_sun_ce_ambition_achieve_independence', [2] = '3k_dlc05_ceo_sun_ce_ambition_achieve_new_centrum', [3] = '3k_dlc05_ceo_sun_ce_ambition_achieve_artery_of_the_world', [4] = '3k_dlc05_ceo_sun_ce_ambition_achieve_wolf_cub_roars' },
['sun_ce_ambition_recruit_governors_and_scholars'] = { kr = "주목과 학자", location = "faction", en = "Governors & Scholars", zh = "太守學究", cn = "太守學究", [1] = '3k_dlc05_ceo_sun_ce_ambition_recruit_official_water', [2] = '3k_dlc05_ceo_sun_ce_ambition_recruit_official_earth' },
       ['sun_ce_ambition_fulfil_zhou_yu_ambition'] = { kr = "주유의 야망 달성", location = "faction", en = "Secure Zhou Yu's ambition", zh = "成就周瑜之志", cn = "成就周瑜之志", [1] = '3k_dlc05_ceo_sun_ce_ambition_secure_jiangling_livestock', [2] = '3k_dlc05_ceo_sun_ce_ambition_secure_xiangyang_capital', [3] = '3k_dlc05_ceo_sun_ce_ambition_secure_jiangling_capital', [4] = '3k_dlc05_ceo_sun_ce_ambition_secure_xiangyang_toolmaker' },
                                ['lu_zhi_cunning'] = { kr = "책략", location = "faction", en = "Cunning", zh = "智謀", cn = "智謀", [1] = '3k_dlc04_ceo_factional_great_library_cunning_exceptional', [2] = '3k_dlc04_ceo_factional_great_library_cunning_refined', [3] = '3k_dlc04_ceo_factional_great_library_cunning_common', [4] = '3k_dlc04_ceo_factional_great_library_cunning_unique' },
                                ['lu_bu_scholars'] = { kr = "학자", location = "faction", en = "Scholars", zh = "學究", cn = "學究", [1] = '3k_dlc05_ceo_factional_warrior_defeated_liu_biao', [2] = '3k_dlc05_ceo_factional_warrior_defeated_kong_rong' },
                          ['lu_bu_yellow_turbans'] = { kr = "황건", location = "faction", en = "Yellow Turbans", zh = "黃巾軍", cn = "黃巾軍", [1] = '3k_dlc05_ceo_factional_warrior_defeated_he_yi', [2] = '3k_dlc05_ceo_factional_warrior_defeated_gong_du', [3] = '3k_dlc05_ceo_factional_warrior_defeated_huang_shao' },
-- item sets 88
}

	------------------------------------------------------------------------------------
								 -- Read DB Item Set --
	------------------------------------------------------------------------------------

function sandbox:read_db_user_item_set( line )
	local log_head = "read_db_user_item_set"
	
	local set_name = line:match( mod_patterns( 'db.item.set' ) )
	local remains = line:gsub( mod_patterns( 'db.set_prefix' ), "" )
			
	logger:dev( log_head, logger:eq( 'set name', set_name ), logger:eq( 'remains', remains ) )
	local prev_indent = logger:inc_indent()		
	
	local items = {}

	for name in remains:gmatch( mod_patterns( 'db.remains' ) ) do 
		
		local ceo_key = name
		
		if self.db_item_aliases[ ceo_key ] then
			ceo_key = self.db_item_aliases[ ceo_key ]
		elseif self.db_item_users[ ceo_key ] then
			ceo_key = self.db_item_users[ ceo_key ]
		end
		
		if self.db_items[ ceo_key ] then
			logger:dev( "_i:1", log_head, set_name, _hi( name, ceo_key ) )
			table.insert( items, ceo_key )
		else
			logger:error( log_head, _hi( name, 'not found in db_items' ) )
		end
	end
	
	if #items > 0 then
		if self.db_item_user_sets[ set_name ] then
			logger:verbose( log_head, _hi( set_name, 'replace' ), items )
		end
		
		self.db_item_user_sets[ set_name ] = {}
		
		for _, ceo_key in pairs( items ) do
			table.insert( self.db_item_user_sets[ set_name ], ceo_key );
		end

		logger:verbose( 'item_set', set_name, #items, items )
	else
		logger:error( 'item_set', _hi( set_name, "has 0 items" ) )
	end
	
	logger:set_indent( prev_indent )
end

	------------------------------------------------------------------------------------
								 -- Read Item Line Functions --
	------------------------------------------------------------------------------------

function sandbox:read_user_action_all_item( line )

	local log_head = "read_user_action_all_item"
	local classes = line:match( "all_item,([^,^$]+)" )
	local dlc, tier, category = classes:match( "([%a]+).?([%a]*).?([%a]*)" );
	local faction, count = line:match( mod_patterns( "all_item" )  )
	
	if dlc == "main" then dlc = "tke" end
	if not faction then faction = "player" end
	
	if (not dlc or dlc == "count" or (dlc ~= "all" and not self.item_categories[ dlc ]))
		or (lib.not_empty(tier) and not lib.is_in( tier, { "legendary", "unique", "exceptional", "refined", "common" } ))
		or (lib.not_empty(category) and not lib.is_in( category, { "weapon", "armour", "mount", "follower", "accessory" } ))
	then
		logger:warn( log_head, "pattern mismatch", dlc, tier, category, "["..line.."]" );
		return nil;
	end

	count = lib.numberorone( count )

	logger:verbose( log_head, "all_item", dlc, tier, category, faction, count, "["..line.."]" )

	if lib.is_empty( dlc ) then dlc = nil end
	if lib.is_empty( tier ) then tier = nil end
	if lib.is_empty( category ) then category = nil end
	
	local action = self:create_action( "all_item" )

	action.turn = 1
	action.classes = classes
	action.dlc = dlc;
	action.tier = tier;
	action.category = category;
	action.count = count

	action.faction = self:input_to_faction_key( faction )
	
	if not action.faction then
		action.faction = self.local_faction_tk_key
	end

	logger:verbose( log_head, action.command, action)
	--logger:inspect( "action", action )
	return action
end

	------------------------------------------------------------------------------------
								 -- Read User Item Set Action --
	------------------------------------------------------------------------------------

function sandbox:read_user_action_give_set( line )

	local log_head = "read_user_action_give_set"
	local input, faction, turn = line:match( mod_patterns( "give_set" ) )

	if not input then
		logger:warn( log_head, "pattern mismatch", line )
		return nil
	end

	local input_faction = self:input_to_faction_key( input )

	if input_faction then
		input = faction
		faction = input_faction
	end
	
	if not self.db_item_user_sets[ input ] then
		logger:warn( log_head, "item_set key not found", "_[:"..input, line )
		return nil
	end
	
	local action = self:create_action( "give_set" )
	
	action.turn = lib.numberorone( turn )
	action.item_set = input
	action.faction = self:input_to_faction_key( faction )
	
	if not action.faction then
		logger:warn( log_head, "faction not found", line )
		
		return nil, loc:format( "faction_not_found", faction )
	end

	logger:verbose( log_head, action.command, action );
	--logger:inspect( "action", action )	
	return action;
end

	------------------------------------------------------------------------------------
								 -- Scripted Item Functions --
	------------------------------------------------------------------------------------

function sandbox:user_scripted_all_item( action )

	local log_head = "user_scripted_all_item"
	
	logger:trace( log_head, action )

	local modify_faction = self:modify_faction( action.faction );

	if is_interface( modify_faction ) then
		local dlcs = {}
		
		if action.dlc == "all" then
			for _, dlc in pairs(self.item_categories) do
				if type(dlc) == "table" then
					table.insert( dlcs, dlc )
				end
			end
		else
			table.insert( dlcs, self.item_categories[ action.dlc ] )
		end
		
		local count = 0
		
		action.count = lib.numberorone( action.count )
		
		for _, dlc in pairs( dlcs ) do
			for tier_key, tier in pairs( dlc ) do
				if type(tier) == "table" and (not action.tier or action.tier == tier_key) then
					for category_key, category in pairs( tier ) do
						if type(category) == "table" and (not action.category or action.category == category_key) then
							for idx, item_key in pairs( category ) do
								for i = 1, action.count do
									modify_faction:ceo_management():add_ceo( item_key )
									count = count + 1
								end
								--logger:verbose( "user_scripted_all_item", item_key, count )
							end
						end
					end
				end
			end
		end
		
		logger:trace( log_head, "all_item", count )
		
		return (count > 0), count
	else
		logger:error( log_head, action.faction, "modify_faction is null." )
	end
	
	return false, 0
end

function sandbox:user_scripted_give_set( action )

	local log_head = "user_scripted_give_set"
	
	local modify_faction = self:modify_faction( action.faction );

	if is_interface( modify_faction ) then
		
		if self.db_item_user_sets[ action.item_set ] then
			
			local item_set = self.db_item_user_sets[ action.item_set ];

			logger:trace( log_head, "item_set", item_set )
			
			for index, ceo_key in pairs( item_set ) do
				modify_faction:ceo_management():add_ceo( ceo_key )
			end
			
			return true, #item_set
		end
	else
		logger:error( log_head, "invalid modify_faction", action )
	end

	return false
end

	------------------------------------------------------------------------------------
								 -- Scripted Item Functions --
	------------------------------------------------------------------------------------

function sandbox:do_input_give_set( action )

	local log_head = "do_input_give_set"
	
	logger:verbose( log_head, action )
	
	local prev_indent = logger:inc_indent()
	
	--------------------------------------------------------
	local success = self:user_scripted_give_set( action )
	--------------------------------------------------------
	
	if success then
		mod_advice:push( "give_set_faction", self:faction_kr( action.faction ), action.item_set );
	else
		mod_advice:push( "give_set_faction_failed", action.item_set, self:faction_kr( action.faction ) );
	end
	
	logger:set_indent( prev_indent )
end

function sandbox:do_input_all_item( action )

	logger:verbose( "do_input_all_item", action )
	--------------------------------------------------------------
	local success, count = self:user_scripted_all_item( action )
	--------------------------------------------------------------	
	if success then
		mod_advice:push( "all_item_faction", self:faction_kr(action.faction), count );
	else
		logger:error( "do_input_all_item", "modify_faction is null", action );
		mod_advice:push( "all_item_faction_failed", self:faction_kr(action.faction) );
	end
end
			---------------------------------------------------------------------------------
			--	Miscellaneous item_set functions
			---------------------------------------------------------------------------------

function sandbox:out_user_item_sets_list()

	for set_key, item_set in pairs( self.db_item_user_sets ) do
		local set_text = "TheG.db.item.set."..set_key
		
		for _, ceo_key in pairs( item_set ) do
			set_text = set_text ..", ".. self.db_items[ ceo_key ][ loc:get_locale() ]
		end
		
		logger:out( set_text )
	end
end

function sandbox:out_item_set_list_( locale  )

	for set_key, item_set in pairs( self.db_item_sets ) do
		local set_text = "TheG.db.item.set."..item_set[ locale ]
		
		for i = 1, 3 do
			if item_set[ i ] and self.db_items[ item_set[ i ] ] then
				set_text = set_text ..", ".. self.db_items[ item_set[ i ] ][ locale ]
			elseif i < 3 then
				logger:error( "out_item_set_list__", item_set.kr, _eq( i, item_set[ i ] ) )
			end
		end
		
		logger:out( set_text )
	end
end

			---------------------------------------------------------------------------------
			---------------------------------------------------------------------------------
			--	Build DB items
			---------------------------------------------------------------------------------

function sandbox:build_item_categories( db_items, append )

	local log_head = "build_item_categories"
	
	if not append then
		for dlc_key, dlc in pairs( self.item_categories ) do
			if type(dlc) == "table" then
				for tier_key, tier in pairs( dlc ) do
					if type( tier ) == "table" then
						for category_key, category in pairs( tier ) do
							if type(category) == "table" then
								category = {}
							else
								category = 0
							end
						end
					else
						tier = 0
					end
				end
			else
				dlc = 0
			end
		end

		self.item_categories.count = 0
	end
	
	for item_key, item in pairs( db_items ) do
		
		if item.dlc == "cp01" then item.dlc = "tke" end
		
		if not self.item_categories[ item.dlc ]
			or not self.item_categories[ item.dlc ][ item.tier ]
			or not self.item_categories[ item.dlc ][ item.tier ][ item.category ]
		then
			logger:warn( "_i:1", log_head, item.dlc, item.tier, item.category )
		else
			table.insert( self.item_categories[ item.dlc ][ item.tier ][ item.category ], item_key )
			
			self.item_categories[ item.dlc ][ item.tier ].count = self.item_categories[ item.dlc ][ item.tier ].count + 1
			self.item_categories[ item.dlc ].count = self.item_categories[ item.dlc ].count + 1
			self.item_categories.count = self.item_categories.count + 1
		end
	end
	
	local log_text = log_head..", ".."all = "..self.item_categories.count
	
	for key, category in pairs( self.item_categories ) do
		if key ~= "count" then
			log_text = log_text..", "..key.." = "..self.item_categories[key].count
		end
	end
	
	logger:info( log_text )
end

local item_set_achivements = {
	"gennerals_who_supports_the_state",
	"dragon_warriors",
	"generals_who_subdue_the_world",
	"incorrupt_officials",
	"lords_of_the_elements",
	"infamous_bandits",
	"men_of_merit",
	"protectors_of_the_army",
}

function sandbox:build_item_sets( name, item_sets )

	local log_head = "build_item_sets:"..name
	
	local count, c_faction, c_error = 0, 0, 0
	
	for set_key, item_set in pairs( item_sets ) do
	
		if item_set.location == "character"
			and lib.not_in( set_key, item_set_achivements )
		then
			local row = {}

			local i = 1
			local failed = false
			while item_set[ i ] do
				if self.db_items[ item_set[ i ] ] then
					table.insert( row, item_set[ i ] )
				else
					logger:error( log_head, set_key, "item not found", "_[:"..item_set[i] )
					failed = true
				end

				i = i + 1
			end

				if not failed then
					count = count + 1
					self.db_item_user_sets[ item_set.en:gsub( "%s", "" ):lower() ] = row
					self.db_item_user_sets[ item_set.kr:gsub( "%s", "" ) ] = row
					self.db_item_user_sets[ item_set.zh ] = row
					self.db_item_user_sets[ item_set.cn ] = row
				else
					self.db_item_sets[ set_key ] = nil
					c_error = c_error + 1
				end
		end
	end

	logger:info( log_head, _eq( "item_sets", count ), _eq( "faction", c_faction ), _eq( "failed", c_error ) )
end

function sandbox:build_db_item_sets()
	
	self.db_item_user_sets = {}
	self.db_faction_sets = {}
	
	self:build_item_sets( "db", self.db_item_sets )
	
	if self:is_mod_on( "tup" ) then
		self.item_categories['tup'] = default_category_tup
		
		self:build_item_sets( "tup", self.db_tup_item_sets )
	end

	self:build_item_categories( self.db_items, false )
end
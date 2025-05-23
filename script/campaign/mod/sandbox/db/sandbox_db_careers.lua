local sandbox = TheGathering_sandbox:get_sandbox_mod()

		--==============================================================================--
									-- Common Header --
		--==============================================================================--

local lib		= sandbox:get_library()
local loc 	 	= sandbox:get_localisation()
local logger 	= sandbox:get_logger()


local _eq = function( ... ) return logger:eq( ... ) end
local _to = function( ... ) return logger:to( ... ) end
local _hi = function( ... ) return logger:hi( ... ) end

local mod_advice = sandbox:get_mod_advice()
local mod_patterns = sandbox:get_mod_patterns()

---------------------------------------------------------------------------------------------
sandbox.db_careers_kr = {}
sandbox.db_career_defaults = {}

sandbox.db_career_banned = {
	["3k_dlc05_ceo_node_career_historical_xu_shao_01"] = true,	-- 영악한 분석가
}

sandbox.db_careers =
{
            ['3k_main_ceo_node_career_historical_cai_mao_01'] = { en_key = 'cai_mao', dlc = "tke", en = "Competent Sailor", kr = "능숙한 뱃사람", zh = "善統水軍", cn = "舟师纵横", ceo_key = "3k_main_ceo_career_historical_cai_mao", threshold = 1, },
            ['3k_main_ceo_node_career_historical_cao_ang_01'] = { en_key = 'cao_ang', dlc = "tke", en = "Prince Min", kr = "풍민왕", zh = "豐愍王", cn = "丰愍王", ceo_key = "3k_main_ceo_career_historical_cao_ang", threshold = 1, },
            ['3k_main_ceo_node_career_historical_cao_cao_01'] = { en_key = 'cao_cao', dlc = "tke", en = "Strategic Mastermind", kr = "난세의 간웅", zh = "謀略梟雄", cn = "乱世奸雄", ceo_key = "3k_main_ceo_career_historical_cao_cao", threshold = 1, },
             ['3k_main_ceo_node_career_historical_cao_pi_01'] = { en_key = 'cao_pi', dlc = "tke", en = "Political Animal", kr = "정치적 동물", zh = "長袖善舞", cn = "庙堂龙犬", ceo_key = "3k_main_ceo_career_historical_cao_pi", threshold = 1, },
            ['3k_main_ceo_node_career_historical_cao_ren_01'] = { en_key = 'cao_ren', dlc = "tke", en = "Brave Hunter", kr = "용감한 사냥꾼", zh = "善騎善射", cn = "弓马弋猎", ceo_key = "3k_main_ceo_career_historical_cao_ren", threshold = 1, },
          ['3k_main_ceo_node_career_historical_chen_gong_01'] = { en_key = 'chen_gong', dlc = "tke", en = "Master Magistrate", kr = "현명하지만 늦어버린", zh = "非凡謀士", cn = "有智而迟", ceo_key = "3k_main_ceo_career_historical_chen_gong", threshold = 1, },
           ['3k_main_ceo_node_career_historical_cheng_pu_01'] = { en_key = 'cheng_pu', dlc = "tke", en = "Bandit Killer", kr = "탕구중랑장", zh = "盪寇將軍", cn = "荡寇将军", ceo_key = "3k_main_ceo_career_historical_cheng_pu", threshold = 1, },
           ['3k_main_ceo_node_career_historical_dian_wei_01'] = { en_key = 'dian_wei', dlc = "tke", en = "Brute of Unmatched Power", kr = "필적할 수 없는 짐승", zh = "勇猛過人", cn = "古之恶来", ceo_key = "3k_main_ceo_career_historical_dian_wei", threshold = 1, },
          ['3k_main_ceo_node_career_historical_dong_zhuo_01'] = { en_key = 'dong_zhuo', dlc = "tke", en = "Cruel Tyrant", kr = "잔혹한 폭군", zh = "殘虐暴君", cn = "狼戾贼忍", ceo_key = "3k_main_ceo_career_historical_dong_zhuo", threshold = 1, },
           ['3k_main_ceo_node_career_historical_fa_zheng_01'] = { en_key = 'fa_zheng', dlc = "tke", en = "Vindictive Strategist", kr = "복수의 모사", zh = "記仇軍師", cn = "睚眦必报", ceo_key = "3k_main_ceo_career_historical_fa_zheng", threshold = 1, },
           ['3k_main_ceo_node_career_historical_gan_ning_01'] = { en_key = 'gan_ning', dlc = "tke", en = "Pirate of the Bells", kr = "금선유협", zh = "鈴鐺水賊", cn = "锦帆游侠", ceo_key = "3k_main_ceo_career_historical_gan_ning", threshold = 1, },
               ['3k_main_ceo_node_career_historical_gao_dai'] = { en_key = 'gao_dai', dlc = "tke", en = "Master Historian", kr = "깨달은 사가", zh = "博通經史", cn = "精通史学", ceo_key = "3k_main_ceo_career_historical_gao_dai", threshold = 1, },
            ['3k_main_ceo_node_career_historical_gao_gan_01'] = { en_key = 'gao_gan', dlc = "tke", en = "Loyal Nephew", kr = "충성스런 조카", zh = "忠心外甥", cn = "才志弘邈", ceo_key = "3k_main_ceo_career_historical_gao_gan", threshold = 1, },
         ['3k_main_ceo_node_career_historical_gongsun_du_01'] = { en_key = 'gongsun_du', dlc = "tke", en = "the Warlike", kr = "호전광", zh = "好戰", cn = "残暴不节", ceo_key = "3k_main_ceo_career_historical_gongsun_du", threshold = 1, },
         ['3k_main_ceo_node_career_historical_gongsun_xu_01'] = { en_key = 'gongsun_xu', dlc = "tke", en = "Brave General", kr = "용맹한 장군", zh = "威武將軍", cn = "骁勇战将", ceo_key = "3k_main_ceo_career_historical_gongsun_xu", threshold = 1, },
        ['3k_main_ceo_node_career_historical_gongsun_zan_01'] = { en_key = 'gongsun_zan', dlc = "tke", en = "The Iron Fist General", kr = "백마의종", zh = "鐵腕將領", cn = "铁腕将军", ceo_key = "3k_main_ceo_career_historical_gongsun_zan", threshold = 1, },
          ['3k_main_ceo_node_career_historical_guan_jing_01'] = { en_key = 'guan_jing', dlc = "tke", en = "Cautious Strategist", kr = "신중한 모사", zh = "謹慎軍師", cn = "审时度势", ceo_key = "3k_main_ceo_career_historical_guan_jing", threshold = 1, },
            ['3k_main_ceo_node_career_historical_guan_yu_01'] = { en_key = 'guan_yu', dlc = "tke", en = "God of War", kr = "무신", zh = "武聖", cn = "武圣", ceo_key = "3k_main_ceo_career_historical_guan_yu", threshold = 1, },
            ['3k_main_ceo_node_career_historical_guo_jia_01'] = { en_key = 'guo_jia', dlc = "tke", en = "Astute Advisor", kr = "귀모", zh = "鬼謀", cn = "鬼谋", ceo_key = "3k_main_ceo_career_historical_guo_jia", threshold = 1, },
             ['3k_main_ceo_node_career_historical_han_fu_01'] = { en_key = 'han_fu', dlc = "tke", en = "Diligent Agriculturalist", kr = "근면한 농업가", zh = "勤奮農業家", cn = "劝课农桑", ceo_key = "3k_main_ceo_career_historical_han_fu", threshold = 1, },
            ['3k_main_ceo_node_career_historical_han_sui_01'] = { en_key = 'han_sui', dlc = "tke", en = "Tireless Insurgent", kr = "지칠 줄 모르는 반란자", zh = "叛心不息", cn = "反复无常", ceo_key = "3k_main_ceo_career_historical_han_sui", threshold = 1, },
          ['3k_main_ceo_node_career_historical_hua_xiong_01'] = { en_key = 'hua_xiong', dlc = "tke", en = "Fierce Beast", kr = "매서운 짐승", zh = "猛獸將才", cn = "熊罴之将", ceo_key = "3k_main_ceo_career_historical_hua_xiong", threshold = 1, },
          ['3k_main_ceo_node_career_historical_huang_gai_01'] = { en_key = 'huang_gai', dlc = "tke", en = "Unreadable Warrior", kr = "고육지계", zh = "莫測戰將", cn = "姿貌严毅", ceo_key = "3k_main_ceo_career_historical_huang_gai", threshold = 1, },
        ['3k_main_ceo_node_career_historical_huang_zhong_01'] = { en_key = 'huang_zhong', dlc = "tke", en = "of the Ageless Strength", kr = "노익장", zh = "老而彌堅", cn = "廉颇之志", ceo_key = "3k_main_ceo_career_historical_huang_zhong", threshold = 1, },
           ['3k_main_ceo_node_career_historical_huang_zu_01'] = { en_key = 'huang_zu', dlc = "tke", en = "Ranged Ambusher", kr = "매복한 돌과 화살", zh = "遠程伏擊", cn = "暗伏弓弩", ceo_key = "3k_main_ceo_career_historical_huang_zu", threshold = 1, },
       ['3k_main_ceo_node_career_historical_huangfu_song_01'] = { en_key = 'huangfu_song', dlc = "tke", en = "Aged General", kr = "노장", zh = "老將", cn = "汉室老将", ceo_key = "3k_main_ceo_career_historical_huangfu_song", threshold = 1, },
           ['3k_main_ceo_node_career_historical_jia_long_01'] = { en_key = 'jia_long', dlc = "tke", en = "Short-sighted Peacekeeper", kr = "근시안적 중재자", zh = "急於求定", cn = "短视守成", ceo_key = "3k_main_ceo_career_historical_jia_long", threshold = 1, },
             ['3k_main_ceo_node_career_historical_jia_xu_01'] = { en_key = 'jia_xu', dlc = "tke", en = "The Blade in the Dark", kr = "어둠 속의 칼날", zh = "暗箭傷人", cn = "文和乱武", ceo_key = "3k_main_ceo_career_historical_jia_xu", threshold = 1, },
          ['3k_main_ceo_node_career_historical_jiang_wei_01'] = { en_key = 'jiang_wei', dlc = "tke", en = "Budding Commander", kr = "신예 사령관", zh = "新銳將帥", cn = "麒麟儿", ceo_key = "3k_main_ceo_career_historical_jiang_wei", threshold = 1, },
          ['3k_main_ceo_node_career_historical_kong_rong_01'] = { en_key = 'kong_rong', dlc = "tke", en = "Master Scholar", kr = "대학자", zh = "博聞強記", cn = "五经传人", ceo_key = "3k_main_ceo_career_historical_kong_rong", threshold = 1, },
          ['3k_main_ceo_node_career_historical_kong_zhou_01'] = { en_key = 'kong_zhou', dlc = "tke", en = "Pure Conversationalist", kr = "화술의 달인", zh = "能言善道", cn = "坐而论道", ceo_key = "3k_main_ceo_career_historical_kong_zhou", threshold = 1, },
          ['3k_main_ceo_node_career_historical_lady_zhen_01'] = { en_key = 'lady_zhen', dlc = "tke", en = "Elegant Survivor", kr = "우아한 생존자", zh = "亂世佳人", cn = "飘摇佳人", ceo_key = "3k_main_ceo_career_historical_lady_zhen", threshold = 1, },
              ['3k_main_ceo_node_career_historical_li_ru_01'] = { en_key = 'li_ru', dlc = "tke", en = "Vicious Shadow", kr = "악의 어린 그림자", zh = "毒辣謀士", cn = "暗施毒计", ceo_key = "3k_main_ceo_career_historical_li_ru", threshold = 1, },
          ['3k_main_ceo_node_career_historical_ling_tong_01'] = { en_key = 'ling_tong', dlc = "tke", en = "Daring Errant", kr = "가상한 용기", zh = "豪俠之氣", cn = "果敢义士", ceo_key = "3k_main_ceo_career_historical_ling_tong", threshold = 1, },
            ['3k_main_ceo_node_career_historical_liu_bei_01'] = { en_key = 'liu_bei', dlc = "tke", en = "Virtuous Idealist", kr = "고결한 이상주의자", zh = "仁義之士", cn = "仁德之君", ceo_key = "3k_main_ceo_career_historical_liu_bei", threshold = 1, },
           ['3k_main_ceo_node_career_historical_liu_biao_01'] = { en_key = 'liu_biao', dlc = "tke", en = "Gentleman of the Han", kr = "대한명사", zh = "大漢名士", cn = "汉室守成", ceo_key = "3k_main_ceo_career_historical_liu_biao", threshold = 1, },
            ['3k_main_ceo_node_career_historical_liu_dai_01'] = { en_key = 'liu_dai', dlc = "tke", en = "Generous Attendant", kr = "관대한 사자", zh = "寬厚侍中", cn = "宽厚爱民", ceo_key = "3k_main_ceo_career_historical_liu_dai", threshold = 1, },
            ['3k_main_ceo_node_career_historical_liu_xie_01'] = { en_key = 'liu_xie', dlc = "tke", en = "Former Emperor", kr = "옛 천자", zh = "退位皇帝", cn = "孝献皇帝", ceo_key = "3k_main_ceo_career_historical_liu_xie", threshold = 1, },
           ['3k_dlc04_ceo_node_career_historical_liu_xie_02'] = { en_key = 'liu_xie', dlc = "tke", en = "Lord Dong", kr = "동군", zh = "董侯", cn = "董侯", ceo_key = "3k_main_ceo_career_historical_liu_xie", threshold = 2, },
            ['3k_main_ceo_node_career_historical_liu_yan_01'] = { en_key = 'liu_yan', dlc = "tke", en = "Opportunistic Ruler", kr = "기회주의적 통치자", zh = "趨利之主", cn = "待机而动", ceo_key = "3k_main_ceo_career_historical_liu_yan", threshold = 1, },
            ['3k_main_ceo_node_career_historical_liu_yao_01'] = { en_key = 'liu_yao', dlc = "tke", en = "Welcoming Magistrate", kr = "사람좋은 현령", zh = "禮賢下士", cn = "民心所向", ceo_key = "3k_main_ceo_career_historical_liu_yao", threshold = 1, },
             ['3k_main_ceo_node_career_historical_liu_yu_01'] = { en_key = 'liu_yu', dlc = "tke", en = "Prosperous Trader", kr = "대외 무역가", zh = "經商有道", cn = "和戎互市", ceo_key = "3k_main_ceo_career_historical_liu_yu", threshold = 1, },
          ['3k_main_ceo_node_career_historical_liu_zhang_01'] = { en_key = 'liu_zhang', dlc = "tke", en = "Proponent of Peace", kr = "평화 지지자", zh = "倡議和平", cn = "闭隘养力", ceo_key = "3k_main_ceo_career_historical_liu_zhang", threshold = 1, },
              ['3k_main_ceo_node_career_historical_lu_bu_01'] = { en_key = 'lu_bu', dlc = "tke", en = "Warrior Without Equal", kr = "인중여포", zh = "武藝無雙", cn = "无双飞将", ceo_key = "3k_main_ceo_career_historical_lu_bu", threshold = 1, },
             ['3k_main_ceo_node_career_historical_lu_fan_01'] = { en_key = 'lu_fan', dlc = "tke", en = "Go Master", kr = "바둑의 달인", zh = "圍棋大師", cn = "围棋名手", ceo_key = "3k_main_ceo_career_historical_lu_fan", threshold = 1, },
            ['3k_main_ceo_node_career_historical_lu_meng_01'] = { en_key = 'lu_meng', dlc = "tke", en = "Late Scholar", kr = "만학도", zh = "中年勤學", cn = "刮目相看", ceo_key = "3k_main_ceo_career_historical_lu_meng", threshold = 1, },
              ['3k_main_ceo_node_career_historical_lu_su_01'] = { en_key = 'lu_su', dlc = "tke", en = "Charitable Envoy", kr = "너그러운 사절", zh = "親善使節", cn = "性好施与", ceo_key = "3k_main_ceo_career_historical_lu_su", threshold = 1, },
             ['3k_main_ceo_node_career_historical_lu_xun_01'] = { en_key = 'lu_xun', dlc = "tke", en = "Scholar General", kr = "박식한 무관", zh = "出將入相", cn = "出将入相", ceo_key = "3k_main_ceo_career_historical_lu_xun", threshold = 1, },
            ['3k_main_ceo_node_career_historical_ma_chao_01'] = { en_key = 'ma_chao', dlc = "tke", en = "Most-brilliant Warrior", kr = "금마초", zh = "武勇出眾", cn = "锦马超", ceo_key = "3k_main_ceo_career_historical_ma_chao", threshold = 1, },
             ['3k_main_ceo_node_career_historical_ma_dai_01'] = { en_key = 'ma_dai', dlc = "tke", en = "Fraternal Warrior", kr = "우애 넘치는 전사", zh = "手足情深的戰士", cn = "阵中兄弟", ceo_key = "3k_main_ceo_career_historical_ma_dai", threshold = 1, },
            ['3k_main_ceo_node_career_historical_ma_teng_01'] = { en_key = 'ma_teng', dlc = "tke", en = "Protector of the West", kr = "서방의 수호자", zh = "西域戍守", cn = "镇守西陲", ceo_key = "3k_main_ceo_career_historical_ma_teng", threshold = 1, },
             ['3k_main_ceo_node_career_historical_mi_zhu_01'] = { en_key = 'mi_zhu', dlc = "tke", en = "Dependable Administrator", kr = "믿음직한 행정가", zh = "可靠臣子", cn = "可靠良吏", ceo_key = "3k_main_ceo_career_historical_mi_zhu", threshold = 1, },
            ['3k_main_ceo_node_career_historical_pang_de_01'] = { en_key = 'pang_de', dlc = "tke", en = "White Horse General", kr = "백마장군", zh = "白馬將軍", cn = "白马将军", ceo_key = "3k_main_ceo_career_historical_pang_de", threshold = 1, },
          ['3k_main_ceo_node_career_historical_pang_tong_01'] = { en_key = 'pang_tong', dlc = "tke", en = "Fledgling Phoenix", kr = "봉추", zh = "鳳雛", cn = "凤雏", ceo_key = "3k_main_ceo_career_historical_pang_tong", threshold = 1, },
             ['3k_main_ceo_node_career_historical_shi_huang'] = { en_key = 'shi_huang', dlc = "tke", en = "Southern Gentleman", kr = "남쪽의 군자", zh = "江南名士", cn = "江东雅士", ceo_key = "3k_main_ceo_career_historical_shi_huang", threshold = 1, },
                ['3k_main_ceo_node_career_historical_shi_wu'] = { en_key = 'shi_wu', dlc = "tke", en = "Warden of the Pearl River", kr = "주강의 감시자", zh = "珠江衛士", cn = "珠江之卫", ceo_key = "3k_main_ceo_career_historical_shi_wu", threshold = 1, },
            ['3k_main_ceo_node_career_historical_shi_xie_01'] = { en_key = 'shi_xie', dlc = "tke", en = "Governor Shi", kr = "사태수", zh = "士太守", cn = "士府君", ceo_key = "3k_main_ceo_career_historical_shi_xie", threshold = 1, },
                ['3k_main_ceo_node_career_historical_shi_yi'] = { en_key = 'shi_yi', dlc = "tke", en = "Complacent Administrator", kr = "안주하는 관리", zh = "亮節官員", cn = "偏安太守", ceo_key = "3k_main_ceo_career_historical_shi_yi", threshold = 1, },
            ['3k_main_ceo_node_career_historical_sima_yi_01'] = { en_key = 'sima_yi', dlc = "tke", en = "Silver Eminence", kr = "응시랑고", zh = "位高權重", cn = "鹰视狼顾", ceo_key = "3k_main_ceo_career_historical_sima_yi", threshold = 1, },
             ['3k_main_ceo_node_career_historical_sun_ce_01'] = { en_key = 'sun_ce', dlc = "tke", en = "The Little Conqueror", kr = "소패왕", zh = "小霸王", cn = "小霸王", ceo_key = "3k_main_ceo_career_historical_sun_ce", threshold = 1, },
           ['3k_main_ceo_node_career_historical_sun_jian_01'] = { en_key = 'sun_jian', dlc = "tke", en = "Tiger of Jiangdong", kr = "강동의 호랑이", zh = "江東猛虎", cn = "江东之虎", ceo_key = "3k_main_ceo_career_historical_sun_jian", threshold = 1, },
           ['3k_main_ceo_node_career_historical_sun_qian_01'] = { en_key = 'sun_qian', dlc = "tke", en = "Upstanding Loyalist", kr = "충직한 애국자", zh = "忠烈剛毅", cn = "无比忠心", ceo_key = "3k_main_ceo_career_historical_sun_qian", threshold = 1, },
           ['3k_main_ceo_node_career_historical_sun_quan_01'] = { en_key = 'sun_quan', dlc = "tke", en = "Emerald-eyed Administrator", kr = "벽안의 통치자", zh = "碧目之君", cn = "碧眼儿", ceo_key = "3k_main_ceo_career_historical_sun_quan", threshold = 1, },
           ['3k_main_ceo_node_career_historical_lady_sun_01'] = { en_key = 'sun_ren', dlc = "tke", en = "The Rising Sun", kr = "손가의 부흥", zh = "孫氏崛起", cn = "枭姬", ceo_key = "3k_main_ceo_career_historical_lady_sun", threshold = 1, },
          ['3k_main_ceo_node_career_historical_taishi_ci_01'] = { en_key = 'taishi_ci', dlc = "tke", en = "of Exceptional Dexterity", kr = "용건명궁", zh = "勇健名將", cn = "勇健名将", ceo_key = "3k_main_ceo_career_historical_taishi_ci", threshold = 1, },
           ['3k_main_ceo_node_career_historical_tao_qian_01'] = { en_key = 'tao_qian', dlc = "tke", en = "Benevolent Arbiter", kr = "자애로운 중재자", zh = "仁厚仲裁", cn = "仁厚长者", ceo_key = "3k_main_ceo_career_historical_tao_qian", threshold = 1, },
          ['3k_main_ceo_node_career_historical_wang_lang_01'] = { en_key = 'wang_lang', dlc = "tke", en = "Ardent Educator", kr = "열렬한 교육자", zh = "誨人不倦", cn = "高才博雅", ceo_key = "3k_main_ceo_career_historical_wang_lang", threshold = 1, },
           ['3k_main_ceo_node_career_historical_wang_xiu_01'] = { en_key = 'wang_xiu', dlc = "tke", en = "The Righteous Hero", kr = "정도지사", zh = "正道之士", cn = "烈义英雄", ceo_key = "3k_main_ceo_career_historical_wang_xiu", threshold = 1, },
            ['3k_main_ceo_node_career_historical_wei_yan_01'] = { en_key = 'wei_yan', dlc = "tke", en = "Disobedient Tiger", kr = "반골 호랑이", zh = "反骨之虎", cn = "反骨虎狼", ceo_key = "3k_main_ceo_career_historical_wei_yan", threshold = 1, },
           ['3k_main_ceo_node_career_historical_wen_chou_01'] = { en_key = 'wen_chou', dlc = "tke", en = "Fierce Firebrand", kr = "기염작천", zh = "急進勇猛", cn = "气焰灼天", ceo_key = "3k_main_ceo_career_historical_wen_chou", threshold = 1, },
               ['3k_main_ceo_node_career_historical_wu_huan'] = { en_key = 'wu_huan', dlc = "tke", en = "Southern Rebel", kr = "남방의 반란군", zh = "南境叛黨", cn = "江东乱党", ceo_key = "3k_main_ceo_career_historical_wu_huan", threshold = 1, },
         ['3k_main_ceo_node_career_historical_xiahou_dun_01'] = { en_key = 'xiahou_dun', dlc = "tke", en = "Hot-headed Officer", kr = "혈기넘치는 군관", zh = "剛烈將帥", cn = "急烈悍将", ceo_key = "3k_main_ceo_career_historical_xiahou_dun", threshold = 1, },
         ['3k_main_ceo_node_career_historical_xiahou_dun_02'] = { en_key = 'xiahou_dun_blinded', dlc = "tke", en = "The One-eyed Exile", kr = "애꾸눈의 외로운 늑대", zh = "獨眼浪客", cn = "独眼孤狼", ceo_key = "3k_main_ceo_career_historical_xiahou_dun_blinded", threshold = 1, },
        ['3k_main_ceo_node_career_historical_xiahou_yuan_01'] = { en_key = 'xiahou_yuan', dlc = "tke", en = "Maker of Ways", kr = "천리습격", zh = "奇襲先鋒", cn = "千里袭人", ceo_key = "3k_main_ceo_career_historical_xiahou_yuan", threshold = 1, },
             ['3k_main_ceo_node_career_historical_xu_chu_01'] = { en_key = 'xu_chu', dlc = "tke", en = "Tiger Fool", kr = "호치", zh = "虎痴", cn = "虎痴", ceo_key = "3k_main_ceo_career_historical_xu_chu", threshold = 1, },
               ['3k_main_ceo_node_career_historical_xu_gong'] = { en_key = 'xu_gong', dlc = "tke", en = "Resentful Underling", kr = "분개한 수하", zh = "懷恨鷹犬", cn = "激愤臣属", ceo_key = "3k_main_ceo_career_historical_xu_gong", threshold = 1, },
           ['3k_main_ceo_node_career_historical_xu_huang_01'] = { en_key = 'xu_huang', dlc = "tke", en = "Guardian of the Gates", kr = "성문의 수호자", zh = "城關神衛", cn = "铁壁将军", ceo_key = "3k_main_ceo_career_historical_xu_huang", threshold = 1, },
             ['3k_main_ceo_node_career_historical_xu_shu_01'] = { en_key = 'xu_shu', dlc = "tke", en = "Disguised Diplomat", kr = "옛 주인을 마음에 품고", zh = "心懷故主", cn = "缄口无言", ceo_key = "3k_main_ceo_career_historical_xu_shu", threshold = 1, },
               ['3k_main_ceo_node_career_historical_xu_zhao'] = { en_key = 'xu_zhao', dlc = "tke", en = "Gracious Protector", kr = "품위 있는 수호자", zh = "高尚衛士", cn = "高尚守护", ceo_key = "3k_main_ceo_career_historical_xu_zhao", threshold = 1, },
            ['3k_main_ceo_node_career_historical_xun_you_01'] = { en_key = 'xun_you', dlc = "tke", en = "Gentleman Attendant", kr = "품위 있는 사자", zh = "侍郎", cn = "贤辅君子", ceo_key = "3k_main_ceo_career_historical_xun_you", threshold = 1, },
             ['3k_main_ceo_node_career_historical_xun_yu_01'] = { en_key = 'xun_yu', dlc = "tke", en = "Hegemon's Aide", kr = "왕좌지재", zh = "王佐之才", cn = "王佐之才", ceo_key = "3k_main_ceo_career_historical_xun_yu", threshold = 1, },
             ['3k_main_ceo_node_career_historical_yan_baihu'] = { en_key = 'yan_baihu', dlc = "tke", en = "The White Tiger", kr = "백호", zh = "東吳德王", cn = "东吴德王", ceo_key = "3k_main_ceo_career_historical_yan_baihu", threshold = 1, },
          ['3k_main_ceo_node_career_historical_yan_liang_01'] = { en_key = 'yan_liang', dlc = "tke", en = "Valiant Vanguard", kr = "효용선봉", zh = "驍勇前鋒", cn = "奋勇当锋", ceo_key = "3k_main_ceo_career_historical_yan_liang", threshold = 1, },
                ['3k_main_ceo_node_career_historical_yan_yu'] = { en_key = 'yan_yu', dlc = "tke", en = "Tiger Cub", kr = "새끼 범", zh = "虎崽", cn = "幼虎", ceo_key = "3k_main_ceo_career_historical_yan_yu", threshold = 1, },
             ['3k_main_ceo_node_career_historical_yu_jin_01'] = { en_key = 'yu_jin', dlc = "tke", en = "Enforcer of the Law", kr = "법의 집행자", zh = "持軍嚴整", cn = "毅重严整", ceo_key = "3k_main_ceo_career_historical_yu_jin", threshold = 1, },
         ['3k_main_ceo_node_career_historical_yuan_shang_01'] = { en_key = 'yuan_shang', dlc = "tke", en = "Favoured Son", kr = "총애받는 자식", zh = "得寵子嗣", cn = "宠爱之子", ceo_key = "3k_main_ceo_career_historical_yuan_shang", threshold = 1, },
          ['3k_main_ceo_node_career_historical_yuan_shao_01'] = { en_key = 'yuan_shao', dlc = "tke", en = "Preeminent Commander", kr = "탁월한 사령관", zh = "出色將帥", cn = "超凡将帅", ceo_key = "3k_main_ceo_career_historical_yuan_shao", threshold = 1, },
           ['3k_main_ceo_node_career_historical_yuan_shu_01'] = { en_key = 'yuan_shu', dlc = "tke", en = "Ambitious Powermonger", kr = "야심찬 권력가", zh = "野心霸主", cn = "狼贪虎视", ceo_key = "3k_main_ceo_career_historical_yuan_shu", threshold = 1, },
            ['3k_main_ceo_node_career_historical_yue_jin_01'] = { en_key = 'yue_jin', dlc = "tke", en = "The Lion of Yangping", kr = "양평의 사자", zh = "陽平雄獅", cn = "阳平之狮", ceo_key = "3k_main_ceo_career_historical_yue_jin", threshold = 1, },
         ['3k_main_ceo_node_career_historical_zhang_chao_01'] = { en_key = 'zhang_chao', dlc = "tke", en = "Flowing Calligrapher", kr = "일필휘지의 서예가", zh = "書法名家", cn = "笔走龙蛇", ceo_key = "3k_main_ceo_career_historical_zhang_chao", threshold = 1, },
          ['3k_main_ceo_node_career_historical_zhang_fei_01'] = { en_key = 'zhang_fei', dlc = "tke", en = "Drunken Brawler", kr = "만인지적", zh = "醉酒鬥士", cn = "豪饮狂战", ceo_key = "3k_main_ceo_career_historical_zhang_fei", threshold = 1, },
           ['3k_main_ceo_node_career_historical_zhang_he_01'] = { en_key = 'zhang_he', dlc = "tke", en = "Courageous General", kr = "용감한 장군", zh = "勇將", cn = "巧变勇将", ceo_key = "3k_main_ceo_career_historical_zhang_he", threshold = 1, },
         ['3k_main_ceo_node_career_historical_zhang_liao_01'] = { en_key = 'zhang_liao', dlc = "tke", en = "The Heavenly Dragon General", kr = "천룡장", zh = "天選將才", cn = "止啼飞龙", ceo_key = "3k_main_ceo_career_historical_zhang_liao", threshold = 1, },
           ['3k_main_ceo_node_career_historical_zhang_lu_01'] = { en_key = 'zhang_lu', dlc = "tke", en = "Celestial Master", kr = "천기의 달인", zh = "天師", cn = "师君", ceo_key = "3k_main_ceo_career_historical_zhang_lu", threshold = 1, },
          ['3k_main_ceo_node_career_historical_zhang_yan_01'] = { en_key = 'zhang_yan', dlc = "tke", en = "King of Black Mountain", kr = "흑산의 왕", zh = "黑山首領", cn = "黑山大王", ceo_key = "3k_main_ceo_career_historical_zhang_yan", threshold = 1, },
         ['3k_main_ceo_node_career_historical_zhang_yang_01'] = { en_key = 'zhang_yang', dlc = "tke", en = "Ignored Warlord", kr = "잊혀진 군주", zh = "無名諸侯", cn = "等闲诸侯", ceo_key = "3k_main_ceo_career_historical_zhang_yang", threshold = 1, },
           ['3k_main_ceo_node_career_historical_zhao_yun_01'] = { en_key = 'zhao_yun', dlc = "tke", en = "Light in the Dark", kr = "난세 속의 빛", zh = "亂世之光", cn = "乱世腾龙", ceo_key = "3k_main_ceo_career_historical_zhao_yun", threshold = 1, },
        ['3k_main_ceo_node_career_historical_zheng_jiang_01'] = { en_key = 'zheng_jiang', dlc = "tke", en = "Bandit Queen", kr = "매력있는 도적", zh = "盜賊女王", cn = "魁首", ceo_key = "3k_main_ceo_career_historical_zheng_jiang", threshold = 1, },
           ['3k_main_ceo_node_career_historical_zhou_tai_01'] = { en_key = 'zhou_tai', dlc = "tke", en = "Reformed Brigand", kr = "교화된 도적", zh = "江賊自新", cn = "归正匪贼", ceo_key = "3k_main_ceo_career_historical_zhou_tai", threshold = 1, },
            ['3k_main_ceo_node_career_historical_zhou_yu_01'] = { en_key = 'zhou_yu', dlc = "tke", en = "Melodic Strategist", kr = "선율의 전략가", zh = "雅好音律", cn = "雅好音律", ceo_key = "3k_main_ceo_career_historical_zhou_yu", threshold = 1, },
                ['3k_main_ceo_node_career_historical_zhu_fu'] = { en_key = 'zhu_fu', dlc = "tke", en = "Inconstant Administrator", kr = "불충한 관리", zh = "朝令夕改", cn = "无常太守", ceo_key = "3k_main_ceo_career_historical_zhu_fu", threshold = 1, },
          ['3k_main_ceo_node_career_historical_zhuge_jin_01'] = { en_key = 'zhuge_jin', dlc = "tke", en = "Bookish Scholar", kr = "학문애호가", zh = "飽讀詩書", cn = "饱读之士", ceo_key = "3k_main_ceo_career_historical_zhuge_jin", threshold = 1, },
        ['3k_main_ceo_node_career_historical_zhuge_liang_01'] = { en_key = 'zhuge_liang', dlc = "tke", en = "Sleeping Dragon", kr = "와룡", zh = "臥龍", cn = "卧龙", ceo_key = "3k_main_ceo_career_historical_zhuge_liang", threshold = 1, },
-- tke 103
            ['3k_main_ceo_node_career_historical_gong_du_01'] = { en_key = 'gong_du', dlc = "ytr", en = "Master of the Land", kr = "지통지재", zh = "地道領袖", cn = "地统之才", ceo_key = "3k_ytr_ceo_career_historical_gong_du", threshold = 1, },
             ['3k_main_ceo_node_career_historical_he_man_01'] = { en_key = 'he_man', dlc = "ytr", en = "The Most Powerful", kr = "절천야차", zh = "勇力過人", cn = "截天夜叉", ceo_key = "3k_ytr_ceo_career_historical_he_man", threshold = 1, },
              ['3k_main_ceo_node_career_historical_he_yi_01'] = { en_key = 'he_yi', dlc = "ytr", en = "Leader of the People", kr = "인통지재", zh = "人道統帥", cn = "人统之才", ceo_key = "3k_ytr_ceo_career_historical_he_yi", threshold = 1, },
         ['3k_main_ceo_node_career_historical_huang_shao_01'] = { en_key = 'huang_shao', dlc = "ytr", en = "Wielder of the Heavenly Way", kr = "천통지재", zh = "天道執掌", cn = "天统之才", ceo_key = "3k_ytr_ceo_career_historical_huang_shao", threshold = 1, },
       ['3k_main_ceo_node_career_historical_pei_yuanshao_01'] = { en_key = 'pei_yuanshao', dlc = "ytr", en = "Virtuous Outrider", kr = "충성스런 선봉", zh = "忠義先驅", cn = "忠勇先驱", ceo_key = "3k_ytr_ceo_career_historical_pei_yuanshao", threshold = 1, },
          ['3k_main_ceo_node_career_historical_zhang_kai_01'] = { en_key = 'zhang_kai', dlc = "ytr", en = "Slayer of Tyrants", kr = "폭군 살해자", zh = "除暴豪傑", cn = "铲灭暴政", ceo_key = "3k_ytr_ceo_career_historical_zhang_kai", threshold = 1, },
-- ytr 6
           ['3k_dlc04_ceo_node_career_historical_bao_dan_01'] = { en_key = 'bao_dan', dlc = "moh", en = "Complete Confucian", kr = "공자의 현신", zh = "純儒之士", cn = "纯儒之士", ceo_key = "3k_dlc04_ceo_career_historical_bao_dan", threshold = 1, },
      ['3k_dlc04_ceo_node_career_historical_beigong_boyu_01'] = { en_key = 'beigong_boyu', dlc = "moh", en = "The Loyal Barbarian", kr = "충직한 오랑캐", zh = "義從胡", cn = "义从胡酋", ceo_key = "3k_dlc04_ceo_career_historical_beigong_boyu", threshold = 1, },
            ['3k_dlc04_ceo_node_career_historical_bi_lan_01'] = { en_key = 'bi_lan', dlc = "moh", en = "Architect of the Southern Palace", kr = "남궁의 건축가", zh = "南宮建築師", cn = "铸钟南宫", ceo_key = "3k_dlc04_ceo_career_historical_bi_lan", threshold = 1, },
        ['3k_dlc04_ceo_node_career_historical_bian_zhang_01'] = { en_key = 'bian_zhang', dlc = "moh", en = "Aspiring Official", kr = "야심 많은 관리", zh = "上進官吏", cn = "有志官吏", ceo_key = "3k_dlc04_ceo_career_historical_bian_zhang", threshold = 1, },
            ['3k_dlc04_ceo_node_career_historical_bo_cai_01'] = { en_key = 'bo_cai', dlc = "moh", en = "Marshal of Men", kr = "치안관", zh = "兵卒之帥", cn = "众人领袖", ceo_key = "3k_dlc04_ceo_career_historical_bo_cai", threshold = 1, },
['3k_dlc04_ceo_node_career_historical_lady_cai_yan_wenji_01'] = { en_key = 'cai_yan', dlc = "moh", en = "The Nightingale", kr = "칠현금의 제4현", zh = "宛轉鶯聲", cn = "莺娇婉娩", ceo_key = "3k_dlc04_ceo_career_historical_lady_cai_yan_wenji", threshold = 1, },
    ['3k_dlc04_ceo_node_career_historical_cai_yong_bojie_01'] = { en_key = 'cai_yong', dlc = "moh", en = "Ritual Master", kr = "의식의 거장", zh = "熟知禮俗", cn = "旷世逸才", ceo_key = "3k_dlc04_ceo_career_historical_cai_yong_bojie", threshold = 1, },
            ['3k_dlc04_ceo_node_career_historical_cao_de_01'] = { en_key = 'cao_de', dlc = "moh", en = "Loyal Son", kr = "충직한 자손", zh = "忠心兒臣", cn = "忠诚子嗣", ceo_key = "3k_dlc04_ceo_career_historical_cao_de", threshold = 1, },
    ['3k_dlc04_ceo_node_career_historical_cao_song_jugao_01'] = { en_key = 'cao_song', dlc = "moh", en = "Ambitious Tycoon", kr = "야심찬 거물", zh = "雄心富商", cn = "雄心巨贾", ceo_key = "3k_dlc04_ceo_career_historical_cao_song_jugao", threshold = 1, },
['3k_dlc04_ceo_node_career_historical_chen_deng_yuanlong_01'] = { en_key = 'chen_deng_yuanlong', dlc = "moh", en = "Man For All Seasons", kr = "사계의 사내", zh = "佐國良才", cn = "湖海之士", ceo_key = "3k_dlc04_ceo_career_historical_chen_deng_yuanlong", threshold = 1, },
    ['3k_dlc04_ceo_node_career_historical_chen_gui_hanyu_01'] = { en_key = 'chen_gui', dlc = "moh", en = "Abundant Talent", kr = "재능아", zh = "才華洋溢", cn = "才华洋溢", ceo_key = "3k_dlc04_ceo_career_historical_chen_gui_hanyu", threshold = 1, },
           ['3k_dlc04_ceo_node_career_historical_chen_su_01'] = { en_key = 'chen_su', dlc = "moh", en = "Living Legacy", kr = "살아있는 유산", zh = "因父得名", cn = "因父得名", ceo_key = "3k_dlc04_ceo_career_historical_chen_su", threshold = 1, },
         ['3k_dlc04_ceo_node_career_historical_cheng_qiu_01'] = { en_key = 'cheng_qiu', dlc = "moh", en = "Unscrupulous Advisor", kr = "악랄한 책사", zh = "狡猾謀士", cn = "无耻谋士", ceo_key = "3k_dlc04_ceo_career_historical_cheng_qiu", threshold = 1, },
      ['3k_dlc04_ceo_node_career_historical_lady_da_qiao_01'] = { en_key = 'da_qiao', dlc = "moh", en = "Daughter of the Southlands", kr = "강남의 빼어남", zh = "江南之女", cn = "江南闺秀", ceo_key = "3k_dlc04_ceo_career_historical_lady_da_qiao", threshold = 1, },
         ['3k_dlc04_ceo_node_career_historical_diao_chan_01'] = { en_key = 'diao_chan', dlc = "moh", en = "Deadly Beauty", kr = "경국지색", zh = "蛇蠍美人", cn = "红颜祸水", ceo_key = "3k_dlc04_ceo_career_historical_diao_chan", threshold = 1, },
['3k_dlc04_ceo_node_career_historical_ding_yuan_jianyang_01'] = { en_key = 'ding_yuan', dlc = "moh", en = "Rising Dragon", kr = "승룡", zh = "蛟龍飛天", cn = "登天之龙", ceo_key = "3k_dlc04_ceo_career_historical_ding_yuan_jianyang", threshold = 1, },
    ['3k_dlc04_ceo_node_career_historical_dong_he_youzai_01'] = { en_key = 'dong_he', dlc = "moh", en = "Honest & Fair", kr = "청렴결백", zh = "正直公平", cn = "坦率公正", ceo_key = "3k_dlc04_ceo_career_historical_dong_he_youzai", threshold = 1, },
       ['3k_dlc04_ceo_node_career_historical_du_ji_bohou_01'] = { en_key = 'du_ji', dlc = "moh", en = "Model Governor", kr = "모범적인 통치자", zh = "模範太守", cn = "官员表率", ceo_key = "3k_dlc04_ceo_career_historical_du_ji_bohou", threshold = 1, },
    ['3k_dlc04_ceo_node_career_historical_duan_gui_ziyin_01'] = { en_key = 'duan_gui_ziyin', dlc = "moh", en = "Enforcer", kr = "집행자", zh = "朝廷寵臣", cn = "铁腕执行", ceo_key = "3k_dlc04_ceo_career_historical_duan_gui_ziyin", threshold = 1, },
      ['3k_dlc04_ceo_node_career_historical_emperor_ling_01'] = { en_key = 'emperor_ling', dlc = "moh", en = "The Inconstant Emperor", kr = "우유부단한 황제", zh = "善變皇帝", cn = "善变天子", ceo_key = "3k_dlc04_ceo_career_historical_emperor_ling", threshold = 1, },
      ['3k_dlc04_ceo_node_career_historical_emperor_ling_02'] = { en_key = 'emperor_ling', dlc = "moh", en = "The Great Emperor of the Han", kr = "대한명군", zh = "大漢明君", cn = "大汉明君", ceo_key = "3k_dlc04_ceo_career_historical_emperor_ling", threshold = 2, },
      ['3k_dlc04_ceo_node_career_historical_emperor_shao_01'] = { en_key = 'emperor_shao', dlc = "moh", en = "Lord Shi", kr = "사후", zh = "史侯", cn = "史侯", ceo_key = "3k_dlc04_ceo_career_historical_emperor_shao", threshold = 1, },
        ['3k_dlc04_ceo_node_career_historical_empress_he_01'] = { en_key = 'empress_he', dlc = "moh", en = "Subtle Manipulator", kr = "흑막", zh = "暗中操弄", cn = "精妙操手", ceo_key = "3k_dlc04_ceo_career_historical_empress_he", threshold = 1, },
         ['3k_dlc04_ceo_node_career_historical_feng_fang_01'] = { en_key = 'feng_fang', dlc = "moh", en = "Bitter Adversary", kr = "일생의 숙적", zh = "含怨強敵", cn = "含怨强敌", ceo_key = "3k_dlc04_ceo_career_historical_feng_fang", threshold = 1, },
    ['3k_dlc04_ceo_node_career_historical_fu_xie_nanrong_01'] = { en_key = 'fu_xie_nanrong', dlc = "moh", en = "Destroyer of Rebels", kr = "반란군의 응징자", zh = "叛軍剋星", cn = "平叛义军", ceo_key = "3k_dlc04_ceo_career_historical_fu_xie_nanrong", threshold = 1, },
          ['3k_dlc04_ceo_node_career_historical_gao_wang_01'] = { en_key = 'gao_wang', dlc = "moh", en = "Officer for Medicines", kr = "어의", zh = "尚藥監", cn = "尚药监", ceo_key = "3k_dlc04_ceo_career_historical_gao_wang", threshold = 1, },
           ['3k_dlc04_ceo_node_career_historical_gao_you_01'] = { en_key = 'gao_you', dlc = "moh", en = "Budding Scholar", kr = "신진 학자", zh = "新銳學究", cn = "学界新秀", ceo_key = "3k_dlc04_ceo_career_historical_gao_you", threshold = 1, },
          ['3k_dlc04_ceo_node_career_historical_guan_hai_01'] = { en_key = 'guan_hai', dlc = "moh", en = "Determined Sapper", kr = "심지 굳은 공병", zh = "堅決工兵", cn = "坚定工兵", ceo_key = "3k_dlc04_ceo_career_historical_guan_hai", threshold = 1, },
         ['3k_dlc04_ceo_node_career_historical_guo_sheng_01'] = { en_key = 'guo_sheng', dlc = "moh", en = "Friend of the He", kr = "하가의 친구", zh = "何氏之友", cn = "何氏之友", ceo_key = "3k_dlc04_ceo_career_historical_guo_sheng", threshold = 1, },
          ['3k_dlc04_ceo_node_career_historical_han_xian_01'] = { en_key = 'han_xian', dlc = "moh", en = "White Wave Veteran", kr = "백파 노장", zh = "白波老兵", cn = "白波宿将", ceo_key = "3k_dlc04_ceo_career_historical_han_xian", threshold = 1, },
            ['3k_dlc04_ceo_node_career_historical_he_jin_01'] = { en_key = 'he_jin', dlc = "moh", en = "The Butcher of the He", kr = "하가의 백정", zh = "何氏屠夫", cn = "何氏屠夫", ceo_key = "3k_dlc04_ceo_career_historical_he_jin", threshold = 1, },
      ['3k_dlc04_ceo_node_career_historical_huangfu_song_01'] = { en_key = 'huangfu_song', dlc = "moh", en = "Modest & Stalwart", kr = "겸손하되 굳은 심지", zh = "溫厚忠實", cn = "谦逊坚定", ceo_key = "3k_dlc04_ceo_career_historical_huangfu_song", threshold = 1, },
   ['3k_dlc04_ceo_node_career_historical_jin_xuan_yuanji_01'] = { en_key = 'jin_xuan', dlc = "moh", en = "Scion of Gold", kr = "황금의 자손", zh = "金之驕子", cn = "望族子弟", ceo_key = "3k_dlc04_ceo_career_historical_jin_xuan_yuanji", threshold = 1, },
           ['3k_dlc04_ceo_node_career_historical_jiu_dan_01'] = { en_key = 'jiu_dan', dlc = "moh", en = "Arbiter of the Planets", kr = "천문감시관", zh = "星象仲裁", cn = "仲裁天下", ceo_key = "3k_dlc04_ceo_career_historical_jiu_dan", threshold = 1, },
         ['3k_dlc04_ceo_node_career_historical_li_wenhou_01'] = { en_key = 'li_wenhou', dlc = "moh", en = "Creeping Dread", kr = "잠식하는 공포", zh = "潛伏凶虐", cn = "潜伏凶虐", ceo_key = "3k_dlc04_ceo_career_historical_li_wenhou", threshold = 1, },
         ['3k_dlc04_ceo_node_career_historical_liu_chong_01'] = { en_key = 'liu_chong', dlc = "moh", en = "Prince of Chen", kr = "진왕", zh = "陳王", cn = "陈王", ceo_key = "3k_dlc04_ceo_career_historical_liu_chong", threshold = 1, },
 ['3k_dlc04_ceo_node_career_historical_liu_hong_yuanzhuo_01'] = { en_key = 'liu_hong', dlc = "moh", en = "Mathematical Sage", kr = "수학의 현자", zh = "算聖", cn = "算圣", ceo_key = "3k_dlc04_ceo_career_historical_liu_hong_yuanzhuo", threshold = 1, },
            ['3k_dlc04_ceo_node_career_historical_liu_pi_01'] = { en_key = 'liu_pi', dlc = "moh", en = "Wanderer", kr = "방랑자", zh = "浪客", cn = "久历四方", ceo_key = "3k_dlc04_ceo_career_historical_liu_pi", threshold = 1, },
     ['3k_dlc04_ceo_node_career_historical_liu_xun_zitai_01'] = { en_key = 'liu_xun', dlc = "moh", en = "Trusting Warlord", kr = "신뢰 깊은 군주", zh = "輕信不疑", cn = "心腹大将", ceo_key = "3k_dlc04_ceo_career_historical_liu_xun_zitai", threshold = 1, },
          ['3k_dlc04_ceo_node_career_historical_lu_boshe_01'] = { en_key = 'lu_boshe', dlc = "moh", en = "Gracious Host", kr = "따뜻한 손님맞이", zh = "好客東家", cn = "好客东家", ceo_key = "3k_dlc04_ceo_career_historical_lu_boshe", threshold = 1, },
      ['3k_dlc04_ceo_node_career_historical_lu_ji_gongji_01'] = { en_key = 'lu_ji', dlc = "moh", en = "Stargazer", kr = "별을 쏘아보는 눈", zh = "觀星人", cn = "观星者", ceo_key = "3k_dlc04_ceo_career_historical_lu_ji_gongji", threshold = 1, },
            ['3k_dlc04_ceo_node_career_historical_lu_jun_01'] = { en_key = 'lu_jun', dlc = "moh", en = "Gentleman Cadet", kr = "선비의 자태", zh = "才俊郎中", cn = "儒雅俊杰", ceo_key = "3k_dlc04_ceo_career_historical_lu_jun", threshold = 1, },
    ['3k_dlc04_ceo_node_career_historical_lu_kang_jining_01'] = { en_key = 'lu_kang', dlc = "moh", en = "Paragon of Governance", kr = "통치의 귀감", zh = "治理楷模", cn = "治理楷模", ceo_key = "3k_dlc04_ceo_career_historical_lu_kang_jining", threshold = 1, },
       ['3k_dlc04_ceo_node_career_historical_lu_yu_zijia_01'] = { en_key = 'lu_yu', dlc = "moh", en = "Judge of Talent", kr = "재능의 심판자", zh = "識才之人", cn = "任能辨才", ceo_key = "3k_dlc04_ceo_career_historical_lu_yu_zijia", threshold = 1, },
            ['3k_dlc04_ceo_node_career_historical_lu_zhi_01'] = { en_key = 'lu_zhi', dlc = "moh", en = "Respected Mentor", kr = "존경 받는 스승", zh = "海內大儒", cn = "德劭导师", ceo_key = "3k_dlc04_ceo_career_historical_lu_zhi", threshold = 1, },
  ['3k_dlc04_ceo_node_career_historical_luo_jun_xiaoyuan_01'] = { en_key = 'luo_jun_xiaoyuan', dlc = "moh", en = "Guardian of the People", kr = "백성들의 수호자", zh = "百姓護衛", cn = "百姓守护", ceo_key = "3k_dlc04_ceo_career_historical_luo_jun_xiaoyuan", threshold = 1, },
   ['3k_dlc04_ceo_node_career_historical_luo_tong_gongxu_01'] = { en_key = 'luo_tong', dlc = "moh", en = "Penniless Knight", kr = "청렴한 장수", zh = "赤貧武人", cn = "贫贱之骑", ceo_key = "3k_dlc04_ceo_career_historical_luo_tong_gongxu", threshold = 1, },
   ['3k_dlc04_ceo_node_career_historical_ma_midi_wengshu_01'] = { en_key = 'ma_midi', dlc = "moh", en = "Counsellor Remonstrant", kr = "충신 대부", zh = "諫議大夫", cn = "谏议大夫", ceo_key = "3k_dlc04_ceo_career_historical_ma_midi_wengshu", threshold = 1, },
         ['3k_dlc04_ceo_node_career_historical_ma_yuanyi_01'] = { en_key = 'ma_yuanyi', dlc = "moh", en = "Hippophobe", kr = "말에 대한 공포", zh = "恐馬症", cn = "厌马之人", ceo_key = "3k_dlc04_ceo_career_historical_ma_yuanyi", threshold = 1, },
  ['3k_dlc04_ceo_node_career_historical_qiao_mao_yuanwei_01'] = { en_key = 'qiao_mao', dlc = "moh", en = "Loyalist of the Han", kr = "한나라의 충신", zh = "忠於大漢", cn = "汉朝忠臣", ceo_key = "3k_dlc04_ceo_career_historical_qiao_mao_yuanwei", threshold = 1, },
  ['3k_dlc04_ceo_node_career_historical_qiao_xuan_gongzu_01'] = { en_key = 'qiao_xuan_gongzu', dlc = "moh", en = "Harbinger of Chaos", kr = "난세의 예견자", zh = "告災先覺", cn = "告灾先觉", ceo_key = "3k_dlc04_ceo_career_historical_qiao_xuan_gongzu", threshold = 1, },
         ['3k_dlc04_ceo_node_career_historical_song_dian_01'] = { en_key = 'song_dian', dlc = "moh", en = "Architect of the Jade Hall", kr = "옥궁 건축가", zh = "玉堂建築師", cn = "缮修玉堂", ceo_key = "3k_dlc04_ceo_career_historical_song_dian", threshold = 1, },
         ['3k_dlc04_ceo_node_career_historical_song_jian_01'] = { en_key = 'song_jian', dlc = "moh", en = "Lord of the Sources", kr = "평한왕", zh = "河首平漢王", cn = "僭号河陇", ceo_key = "3k_dlc04_ceo_career_historical_song_jian", threshold = 1, },
         ['3k_dlc04_ceo_node_career_historical_tang_zhou_01'] = { en_key = 'tang_zhou', dlc = "moh", en = "Eyes & Ears", kr = "나라의 눈과 귀", zh = "眼線耳目", cn = "国之耳目", ceo_key = "3k_dlc04_ceo_career_historical_tang_zhou", threshold = 1, },
          ['3k_dlc04_ceo_node_career_historical_wang_guo_01'] = { en_key = 'wang_guo', dlc = "moh", en = "Cruel Turncoat", kr = "잔혹한 변절자", zh = "殘虐叛賊", cn = "残酷叛贼", ceo_key = "3k_dlc04_ceo_career_historical_wang_guo", threshold = 1, },
    ['3k_dlc04_ceo_node_career_historical_lady_wang_song_01'] = { en_key = 'wang_song', dlc = "moh", en = "Ever-faithful", kr = "영원한 충성", zh = "忠貞不渝", cn = "忠诚不渝", ceo_key = "3k_dlc04_ceo_career_historical_lady_wang_song", threshold = 1, },
     ['3k_dlc04_ceo_node_career_historical_wu_qiong_deyu_01'] = { en_key = 'wu_qiong_deyu', dlc = "moh", en = "Seeker of Talent", kr = "인재를 찾는 자", zh = "尋才之人", cn = "贤才伯乐", ceo_key = "3k_dlc04_ceo_career_historical_wu_qiong_deyu", threshold = 1, },
           ['3k_dlc04_ceo_node_career_historical_xia_yun_01'] = { en_key = 'xia_yun', dlc = "moh", en = "Financial Genius", kr = "회계의 귀재", zh = "財政奇才", cn = "财政天才", ceo_key = "3k_dlc04_ceo_career_historical_xia_yun", threshold = 1, },
    ['3k_dlc04_ceo_node_career_historical_lady_xiao_qiao_01'] = { en_key = 'xiao_qiao', dlc = "moh", en = "Daughter of the Southlands", kr = "강남의 빼어남", zh = "江南之女", cn = "江南闺秀", ceo_key = "3k_dlc04_ceo_career_historical_lady_xiao_qiao", threshold = 1, },
          ['3k_dlc04_ceo_node_career_historical_xue_zhou_01'] = { en_key = 'xue_zhou', dlc = "moh", en = "Pirate of the Thousand Sails", kr = "일천 돛의 해적", zh = "千帆水賊", cn = "千帆海贼", ceo_key = "3k_dlc04_ceo_career_historical_xue_zhou", threshold = 1, },
 ['3k_dlc04_ceo_node_career_historical_xun_shuang_ciming_01'] = { en_key = 'xun_shuang_ciming', dlc = "moh", en = "Fighter Against Corruption", kr = "부패 척결자", zh = "肅貪鬥士", cn = "力克贪腐", ceo_key = "3k_dlc04_ceo_career_historical_xun_shuang_ciming", threshold = 1, },
   ['3k_dlc04_ceo_node_career_historical_ying_qu_xiulian_01'] = { en_key = 'ying_qu', dlc = "moh", en = "Bookish Scholar", kr = "학문애호가", zh = "飽讀詩書", cn = "饱读之士", ceo_key = "3k_dlc04_ceo_career_historical_ying_qu_xiulian", threshold = 1, },
['3k_dlc04_ceo_node_career_historical_ying_shao_zhongyuan_01'] = { en_key = 'ying_shao', dlc = "moh", en = "Master of Ceremonies", kr = "의전의 달인", zh = "熟知官儀", cn = "熟知仪礼", ceo_key = "3k_dlc04_ceo_career_historical_ying_shao_zhongyuan", threshold = 1, },
  ['3k_dlc04_ceo_node_career_historical_ying_yang_delian_01'] = { en_key = 'ying_yang', dlc = "moh", en = "Chess Grandmaster", kr = "장기의 달인", zh = "弈棋大師", cn = "棋坛圣手", ceo_key = "3k_dlc04_ceo_career_historical_ying_yang_delian", threshold = 1, },
      ['3k_dlc04_ceo_node_career_historical_yuan_yi_boye_01'] = { en_key = 'yuan_yi', dlc = "moh", en = "Loyal Yuan", kr = "원가의 충성", zh = "忠於袁氏", cn = "忠于袁氏", ceo_key = "3k_dlc04_ceo_career_historical_yuan_yi_boye", threshold = 1, },
         ['3k_dlc04_ceo_node_career_historical_zhang_bao_01'] = { en_key = 'zhang_bao', dlc = "moh", en = "General of the Land", kr = "지공장군", zh = "地公將軍", cn = "地公将军", ceo_key = "3k_dlc04_ceo_career_historical_zhang_bao", threshold = 1, },
         ['3k_dlc04_ceo_node_career_historical_zhang_jue_01'] = { en_key = 'zhang_jue', dlc = "moh", en = "General of Heaven", kr = "천공장군", zh = "天公將軍", cn = "天公将军", ceo_key = "3k_dlc04_ceo_career_historical_zhang_jue", threshold = 1, },
       ['3k_dlc04_ceo_node_career_historical_zhang_liang_01'] = { en_key = 'zhang_liang', dlc = "moh", en = "General of the People", kr = "인공장군", zh = "人公將軍", cn = "人公将军", ceo_key = "3k_dlc04_ceo_career_historical_zhang_liang", threshold = 1, },
    ['3k_dlc04_ceo_node_career_historical_zhang_mancheng_01'] = { en_key = 'zhang_mancheng', dlc = "moh", en = "Scourge of Nanyang", kr = "남양의 파멸", zh = "南陽之災", cn = "南阳灾祸", ceo_key = "3k_dlc04_ceo_career_historical_zhang_mancheng", threshold = 1, },
        ['3k_dlc04_ceo_node_career_historical_zhang_rang_01'] = { en_key = 'zhang_rang', dlc = "moh", en = "Imperial Father", kr = "황제의 아버지", zh = "皇帝假父", cn = "皇帝假父", ceo_key = "3k_dlc04_ceo_career_historical_zhang_rang", threshold = 1, },
  ['3k_dlc04_ceo_node_career_historical_zhang_wen_boshen_01'] = { en_key = 'zhang_wen', dlc = "moh", en = "Peerless Protégé", kr = "빼어난 후계자", zh = "無匹傑才", cn = "无双国士", ceo_key = "3k_dlc04_ceo_career_historical_zhang_wen_boshen", threshold = 1, },
         ['3k_dlc04_ceo_node_career_historical_zhao_hong_01'] = { en_key = 'zhao_hong', dlc = "moh", en = "The Turtle", kr = "검은 거북 갑옷", zh = "龜甲悍將", cn = "玄龟御敌", ceo_key = "3k_dlc04_ceo_career_historical_zhao_hong", threshold = 1, },
        ['3k_dlc04_ceo_node_career_historical_zhao_zhong_01'] = { en_key = 'zhao_zhong', dlc = "moh", en = "Imperial Mother", kr = "황제의 어머니", zh = "皇帝假母", cn = "皇帝假母", ceo_key = "3k_dlc04_ceo_career_historical_zhao_zhong", threshold = 1, },
 ['3k_dlc04_ceo_node_career_historical_zhou_bi_zhongyuan_01'] = { en_key = 'zhou_bi_zhongyuan', dlc = "moh", en = "Nominator of Worth", kr = "인재 발탁자", zh = "舉賢之人", cn = "举贤之人", ceo_key = "3k_dlc04_ceo_career_historical_zhou_bi_zhongyuan", threshold = 1, },
   ['3k_dlc04_ceo_node_career_historical_zhou_xin_daming_01'] = { en_key = 'zhou_xin', dlc = "moh", en = "Frontline General", kr = "일선 장군", zh = "身先士卒", cn = "前锋猛将", ceo_key = "3k_dlc04_ceo_career_historical_zhou_xin_daming", threshold = 1, },
         ['3k_dlc04_ceo_node_career_historical_zong_yuan_01'] = { en_key = 'zong_yuan', dlc = "moh", en = "Auxiliary Leader", kr = "떠받치는 지도자", zh = "領袖副手", cn = "辅佐将领", ceo_key = "3k_dlc04_ceo_career_historical_zong_yuan", threshold = 1, },
-- moh 76
          ['3k_dlc05_ceo_node_career_historical_cao_xing_01'] = { en_key = 'cao_xing', dlc = "wb", en = "Loyal Sharpshooter", kr = "충실한 명사수", zh = "忠心射手", cn = "忠直善射", ceo_key = "3k_dlc05_ceo_career_historical_cao_xing", threshold = 1, },
           ['3k_dlc05_ceo_node_career_historical_chen_ji_01'] = { en_key = 'chen_ji', dlc = "wb", en = "Magistrate", kr = "치안 판사", zh = "法官", cn = "决讼九江", ceo_key = "3k_dlc05_ceo_career_historical_chen_ji", threshold = 1, },
    ['3k_dlc05_ceo_node_career_historical_cheng_pu_elder_01'] = { en_key = 'cheng_pu', dlc = "wb", en = "Elder Cheng", kr = "정공", zh = "程公", cn = "程公", ceo_key = "3k_dlc05_ceo_career_historical_cheng_pu_elder", threshold = 1, },
          ['3k_dlc05_ceo_node_career_historical_cheng_yu_01'] = { en_key = 'cheng_yu', dlc = "wb", en = "Ruthless Pragmatist", kr = "무자비한 실용주의자", zh = "剛戾務實", cn = "刚戾务实", ceo_key = "3k_dlc05_ceo_career_historical_cheng_yu", threshold = 1, },
      ['3k_dlc05_ceo_node_career_historical_chunyu_qiong_01'] = { en_key = 'chunyu_qiong', dlc = "wb", en = "Drunken Incompetent", kr = "무능한 주정뱅이", zh = "貪杯誤事", cn = "嗜酒失职", ceo_key = "3k_dlc05_ceo_career_historical_chunyu_qiong", threshold = 1, },
          ['3k_dlc05_ceo_node_career_historical_diaochan_01'] = { en_key = 'diaochan', dlc = "wb", en = "Legendary Beauty", kr = "경국지색", zh = "絕代佳人", cn = "倾国倾城", ceo_key = "3k_dlc05_ceo_career_historical_diaochan", threshold = 1, },
          ['3k_dlc05_ceo_node_career_historical_gao_shun_01'] = { en_key = 'gao_shun', dlc = "wb", en = "Formation Breaker", kr = "함진영", zh = "衝鋒陷陣", cn = "陷阵先锋", ceo_key = "3k_dlc05_ceo_career_historical_gao_shun", threshold = 1, },
            ['3k_dlc05_ceo_node_career_historical_guo_si_01'] = { en_key = 'guo_si', dlc = "wb", en = "Paranoid Thug", kr = "집착자", zh = "多疑惡棍", cn = "多疑恶徒", ceo_key = "3k_dlc05_ceo_career_historical_guo_si", threshold = 1, },
            ['3k_dlc05_ceo_node_career_historical_guo_tu_01'] = { en_key = 'guo_tu', dlc = "wb", en = "Erratic Advisor", kr = "변덕스러운 책사", zh = "躁進謀士", cn = "智谋如鬼", ceo_key = "3k_dlc05_ceo_career_historical_guo_tu", threshold = 1, },
          ['3k_dlc05_ceo_node_career_historical_han_dang_01'] = { en_key = 'han_dang', dlc = "wb", en = "Loyal Mercenary", kr = "충성스러운 용병", zh = "忠心傭兵", cn = "忠勇之士", ceo_key = "3k_dlc05_ceo_career_historical_han_dang", threshold = 1, },
           ['3k_dlc05_ceo_node_career_historical_han_hao_01'] = { en_key = 'han_hao', dlc = "wb", en = "Feeder of Armies", kr = "보급관", zh = "產糧養軍", cn = "屯田护军", ceo_key = "3k_dlc05_ceo_career_historical_han_hao", threshold = 1, },
          ['3k_dlc05_ceo_node_career_historical_hao_meng_01'] = { en_key = 'hao_meng', dlc = "wb", en = "Treacherous Rogue", kr = "믿을 수 없는 불한당", zh = "狡詐反賊", cn = "两面三刀", ceo_key = "3k_dlc05_ceo_career_historical_hao_meng", threshold = 1, },
      ['3k_main_ceo_node_career_generated_governor_water_01'] = { en_key = 'hua_xin', dlc = "wb", en = "Academic", kr = "학사", zh = "學者", cn = "饱学多才", ceo_key = "3k_dlc05_ceo_career_historical_hua_xin", threshold = 1, },
           ['3k_dlc05_ceo_node_career_historical_ji_ling_01'] = { en_key = 'ji_ling', dlc = "wb", en = "Blunt Instrument", kr = "투박한 무구", zh = "以力服人", cn = "以力服人", ceo_key = "3k_dlc05_ceo_career_historical_ji_ling", threshold = 1, },
           ['3k_dlc05_ceo_node_career_historical_ju_shou_01'] = { en_key = 'ju_shou', dlc = "wb", en = "Voice of Reason", kr = "이성의 목소리", zh = "知陣識天", cn = "澄思寂虑", ceo_key = "3k_dlc05_ceo_career_historical_ju_shou", threshold = 1, },
         ['3k_dlc05_ceo_node_career_historical_lady_bian_01'] = { en_key = 'lady_bian', dlc = "wb", en = "Humble Matriarch", kr = "겸허한 여주인", zh = "溫厚主母", cn = "谦卑巾帼", ceo_key = "3k_dlc05_ceo_career_historical_lady_bian", threshold = 1, },
           ['3k_dlc05_ceo_node_career_historical_lady_mi_01'] = { en_key = 'lady_mi', dlc = "wb", en = "Steadfast Loyalist", kr = "확고부동한 충성파", zh = "堅忍忠貞", cn = "果决刚烈", ceo_key = "3k_dlc05_ceo_career_historical_lady_mi", threshold = 1, },
            ['3k_dlc05_ceo_node_career_historical_li_jue_01'] = { en_key = 'li_jue', dlc = "wb", en = "Vicious Strongman", kr = "포악한 호걸", zh = "毒辣權臣", cn = "邪佞狂徒", ceo_key = "3k_dlc05_ceo_career_historical_li_jue", threshold = 1, },
           ['3k_dlc05_ceo_node_career_historical_lou_gui_01'] = { en_key = 'lou_gui', dlc = "wb", en = "Mengmei Householder", kr = "몽매거사", zh = "夢梅居士", cn = "梦梅居士", ceo_key = "3k_dlc05_ceo_career_historical_lou_gui", threshold = 1, },
         ['3k_dlc05_ceo_node_career_historical_lu_lingqi_01'] = { en_key = 'lu_lingqi', dlc = "wb", en = "Daughter of the Dragon", kr = "용의 딸", zh = "龍女呂氏", cn = "飞将之女", ceo_key = "3k_dlc05_ceo_career_historical_lu_lingqi", threshold = 1, },
           ['3k_dlc05_ceo_node_career_historical_mao_jie_01'] = { en_key = 'mao_jie', dlc = "wb", en = "Enforcer of Morals", kr = "도덕의 집행자", zh = "公扇廉風", cn = "清公素履", ceo_key = "3k_dlc05_ceo_career_historical_mao_jie", threshold = 1, },
           ['3k_dlc05_ceo_node_career_historical_pang_ji_01'] = { en_key = 'pang_ji', dlc = "wb", en = "Vindictive Sneak", kr = "복수심에 찬 밀고자", zh = "記仇讒臣", cn = "恶毒鬼祟", ceo_key = "3k_dlc05_ceo_career_historical_pang_ji", threshold = 1, },
          ['3k_dlc05_ceo_node_career_historical_shen_pei_01'] = { en_key = 'shen_pei', dlc = "wb", en = "The Dependable", kr = "신뢰할 수 있는 자", zh = "忠誠可信", cn = "踏实可靠", ceo_key = "3k_dlc05_ceo_career_historical_shen_pei", threshold = 1, },
         ['3k_dlc05_ceo_node_career_historical_tian_feng_01'] = { en_key = 'tian_feng', dlc = "wb", en = "Forthright Advisor", kr = "직설적인 책사", zh = "直言謀臣", cn = "刚直智士", ceo_key = "3k_dlc05_ceo_career_historical_tian_feng", threshold = 1, },
       ['3k_main_ceo_node_career_generated_general_earth_01'] = { en_key = 'tian_kai', dlc = "wb", en = "Officer", kr = "군관", zh = "官員", cn = "决胜千里", ceo_key = "3k_dlc05_ceo_career_historical_tian_kai", threshold = 1, },
        ['3k_main_ceo_node_career_generated_general_fire_01'] = { en_key = 'wu_jing', dlc = "wb", en = "Warrior", kr = "전사", zh = "戰士", cn = "勇冠三军", ceo_key = "3k_dlc05_ceo_career_historical_wu_jing", threshold = 1, },
           ['3k_dlc05_ceo_node_career_historical_xu_shao_01'] = { en_key = 'xu_shao', dlc = "wb", en = "Astute Analyst", kr = "영악한 분석가", zh = "月旦之評", cn = "敏锐相士", ceo_key = "3k_dlc05_ceo_career_historical_xu_shao", threshold = 1, },
      ['3k_dlc05_ceo_node_career_historical_xu_shu_early_01'] = { en_key = 'xu_shu', dlc = "wb", en = "Reformed Vigilante", kr = "의협서생", zh = "自新俠士", cn = "义侠书生", ceo_key = "3k_dlc05_ceo_career_historical_xu_shu_early", threshold = 1, },
            ['3k_dlc05_ceo_node_career_historical_xu_you_01'] = { en_key = 'xu_you', dlc = "wb", en = "Inveterate Schemer", kr = "고지식한 책략가", zh = "算無遺策", cn = "谋术多端", ceo_key = "3k_dlc05_ceo_career_historical_xu_you", threshold = 1, },
      ['3k_main_ceo_node_career_generated_governor_metal_01'] = { en_key = 'xue_li', dlc = "wb", en = "Clerk", kr = "사무원", zh = "記室", cn = "主簿佐吏", ceo_key = "3k_dlc05_ceo_career_historical_xue_li", threshold = 1, },
         ['3k_dlc05_ceo_node_career_historical_yang_feng_01'] = { en_key = 'yang_feng', dlc = "wb", en = "White Wave Warlord", kr = "백파적 두목", zh = "白波元帥", cn = "白波将军", ceo_key = "3k_dlc05_ceo_career_historical_yang_feng", threshold = 1, },
         ['3k_dlc05_ceo_node_career_historical_yang_hong_01'] = { en_key = 'yang_hong', dlc = "wb", en = "Respected Advisor", kr = "존경 받는 책사", zh = "顯德謀士", cn = "雅望高士", ceo_key = "3k_dlc05_ceo_career_historical_yang_hong", threshold = 1, },
            ['3k_dlc05_ceo_node_career_historical_yu_fan_01'] = { en_key = 'yu_fan', dlc = "wb", en = "Abrasive Advisor", kr = "입담 걸걸한 책사", zh = "狂直謀士", cn = "狂直谋臣", ceo_key = "3k_dlc05_ceo_career_historical_yu_fan", threshold = 1, },
         ['3k_dlc05_ceo_node_career_historical_yuan_huan_01'] = { en_key = 'yuan_huan', dlc = "wb", en = "Agricultural Reformer", kr = "농업 개혁가", zh = "改革農業", cn = "农学大家", ceo_key = "3k_dlc05_ceo_career_historical_yuan_huan", threshold = 1, },
          ['3k_dlc05_ceo_node_career_historical_yuan_tan_01'] = { en_key = 'yuan_tan', dlc = "wb", en = "Unfavoured Son", kr = "내놓은 자식", zh = "失寵子嗣", cn = "失宠之子", ceo_key = "3k_dlc05_ceo_career_historical_yuan_tan", threshold = 1, },
           ['3k_dlc05_ceo_node_career_historical_zang_ba_01'] = { en_key = 'zang_ba', dlc = "wb", en = "Crafty Operator", kr = "교활한 수완가", zh = "精明圓滑", cn = "狡诈多端", ceo_key = "3k_dlc05_ceo_career_historical_zang_ba", threshold = 1, },
           ['3k_dlc05_ceo_node_career_historical_zao_zhi_01'] = { en_key = 'zao_zhi', dlc = "wb", en = "Father of the Tuntian", kr = "둔전의 아버지", zh = "首倡屯田", cn = "首倡屯田", ceo_key = "3k_dlc05_ceo_career_historical_zao_zhi", threshold = 1, },
           ['3k_dlc05_ceo_node_career_historical_ze_rong_01'] = { en_key = 'ze_rong', dlc = "wb", en = "Populist Rogue", kr = "의로운 불한당", zh = "聚眾放縱", cn = "卑鄙狡狯", ceo_key = "3k_dlc05_ceo_career_historical_ze_rong", threshold = 1, },
        ['3k_dlc05_ceo_node_career_historical_zhang_fang_01'] = { en_key = 'zhang_fang', dlc = "wb", en = "Prince of Black Mountain", kr = "흑산의 왕자", zh = "黑山少主", cn = "黑山少主", ceo_key = "3k_dlc05_ceo_career_historical_zhang_fang", threshold = 1, },
        ['3k_dlc05_ceo_node_career_historical_zhang_hong_01'] = { en_key = 'zhang_hong', dlc = "wb", en = "Adept Diplomat", kr = "탁월한 외교관", zh = "精通經略", cn = "文理意正", ceo_key = "3k_dlc05_ceo_career_historical_zhang_hong", threshold = 1, },
        ['3k_dlc05_ceo_node_career_historical_zhang_miao_01'] = { en_key = 'zhang_miao', dlc = "wb", en = "Friend to All", kr = "모두의 친구", zh = "多方結交", cn = "八面玲珑", ceo_key = "3k_dlc05_ceo_career_historical_zhang_miao", threshold = 1, },
         ['3k_dlc05_ceo_node_career_historical_zhang_xiu_01'] = { en_key = 'zhang_xiu', dlc = "wb", en = "Reed in the Wind", kr = "바람 앞의 갈대", zh = "見風轉舵", cn = "能屈能伸", ceo_key = "3k_dlc05_ceo_career_historical_zhang_xiu", threshold = 1, },
        ['3k_dlc05_ceo_node_career_historical_zhang_zhao_01'] = { en_key = 'zhang_zhao', dlc = "wb", en = "Stern Advisor", kr = "엄격한 책사", zh = "剛烈謀士", cn = "忠謇方直", ceo_key = "3k_dlc05_ceo_career_historical_zhang_zhao", threshold = 1, },
  ['3k_dlc05_ceo_node_career_historical_zhou_tai_scarred_01'] = { en_key = 'zhou_tai', dlc = "wb", en = "Man of Many Scars", kr = "온몸의 흉터마다 술 한잔", zh = "傷疤滿佈", cn = "肤如刻画", ceo_key = "3k_dlc05_ceo_career_historical_zhou_tai_scarred", threshold = 1, },
-- wb 44
         ['3k_dlc06_ceo_career_historical_nanman_ahuinan_01'] = { en_key = 'ahuinan', dlc = "fw", en = "Marshall of the Third Cave", kr = "제3동의 총수", zh = "第三洞元帥", cn = "第三洞统帅", ceo_key = "3k_dlc06_ceo_career_historical_nanman_ahuinan", threshold = 1, },
         ['3k_dlc06_ceo_career_historical_nanman_ahuinan_02'] = { en_key = 'ahuinan', dlc = "fw", en = "Lord of the Mountains", kr = "산왕", zh = "山王", cn = "群山之主", ceo_key = "3k_dlc06_ceo_career_historical_nanman_ahuinan", threshold = 4, },
         ['3k_dlc06_ceo_career_historical_nanman_ahuinan_03'] = { en_key = 'ahuinan', dlc = "fw", en = "Chief of the Three Ravines", kr = "삼동의 주인", zh = "三洞洞主", cn = "三洞之主", ceo_key = "3k_dlc06_ceo_career_historical_nanman_ahuinan", threshold = 7, },
   ['3k_dlc06_ceo_career_historical_nanman_dailaidongzhu_01'] = { en_key = 'dailai', dlc = "fw", en = "The Cunning Youth", kr = "교활한 청년", zh = "智謀青年", cn = "机谋少将", ceo_key = "3k_dlc06_ceo_career_historical_nanman_dailaidongzhu", threshold = 1, },
   ['3k_dlc06_ceo_career_historical_nanman_dailaidongzhu_02'] = { en_key = 'dailai', dlc = "fw", en = "The Brother of Flames", kr = "불꽃의 형제", zh = "火神之弟", cn = "火神血亲", ceo_key = "3k_dlc06_ceo_career_historical_nanman_dailaidongzhu", threshold = 4, },
   ['3k_dlc06_ceo_career_historical_nanman_dailaidongzhu_03'] = { en_key = 'dailai', dlc = "fw", en = "The Astute Tactician", kr = "영악한 전략가", zh = "精明軍師", cn = "诡谲多诈", ceo_key = "3k_dlc06_ceo_career_historical_nanman_dailaidongzhu", threshold = 7, },
        ['3k_dlc06_ceo_career_historical_nanman_dongtuna_01'] = { en_key = 'dongtuna', dlc = "fw", en = "Commander of the Left", kr = "좌군의 총수", zh = "左軍將帥", cn = "左军统帅", ceo_key = "3k_dlc06_ceo_career_historical_nanman_dongtuna", threshold = 1, },
        ['3k_dlc06_ceo_career_historical_nanman_dongtuna_02'] = { en_key = 'dongtuna', dlc = "fw", en = "The Distinguished Strength", kr = "특출난 용력", zh = "力大驚人", cn = "孔武有力", ceo_key = "3k_dlc06_ceo_career_historical_nanman_dongtuna", threshold = 4, },
        ['3k_dlc06_ceo_career_historical_nanman_dongtuna_03'] = { en_key = 'dongtuna', dlc = "fw", en = "The Enduring Mountain", kr = "인내하는 산", zh = "不動如山", cn = "不动如山", ceo_key = "3k_dlc06_ceo_career_historical_nanman_dongtuna", threshold = 7, },
      ['3k_dlc06_ceo_career_historical_nanman_king_duosi_01'] = { en_key = 'duosi', dlc = "fw", en = "The Superstitious Warrior", kr = "미신에 사로잡힌 전사", zh = "迷信武將", cn = "多疑武人", ceo_key = "3k_dlc06_ceo_career_historical_nanman_king_duosi", threshold = 1, },
      ['3k_dlc06_ceo_career_historical_nanman_king_duosi_02'] = { en_key = 'duosi', dlc = "fw", en = "The Solitary Mountain", kr = "굳센 산", zh = "孤傲如峰", cn = "孤傲如山", ceo_key = "3k_dlc06_ceo_career_historical_nanman_king_duosi", threshold = 4, },
      ['3k_dlc06_ceo_career_historical_nanman_king_duosi_03'] = { en_key = 'duosi', dlc = "fw", en = "The Wisest Chief", kr = "현명한 족장", zh = "睿智洞主", cn = "明智酋长", ceo_key = "3k_dlc06_ceo_career_historical_nanman_king_duosi", threshold = 7, },
   ['3k_dlc06_ceo_career_historical_nanman_jinhuansanjie_01'] = { en_key = 'jinhuansanjie', dlc = "fw", en = "Loyal Lieutenant", kr = "충직한 군관", zh = "忠心副將", cn = "忠心副将", ceo_key = "3k_dlc06_ceo_career_historical_nanman_jinhuansanjie", threshold = 1, },
   ['3k_dlc06_ceo_career_historical_nanman_jinhuansanjie_02'] = { en_key = 'jinhuansanjie', dlc = "fw", en = "Guarder of the Path", kr = "길의 수호자", zh = "守路鐵衛", cn = "古道卫士", ceo_key = "3k_dlc06_ceo_career_historical_nanman_jinhuansanjie", threshold = 4, },
   ['3k_dlc06_ceo_career_historical_nanman_jinhuansanjie_03'] = { en_key = 'jinhuansanjie', dlc = "fw", en = "The Would-be Martyr", kr = "순교자", zh = "捨生忘死", cn = "殒身不恤", ceo_key = "3k_dlc06_ceo_career_historical_nanman_jinhuansanjie", threshold = 7, },
     ['3k_dlc06_ceo_career_historical_nanman_mangyachang_01'] = { en_key = 'mangyachang', dlc = "fw", en = "The Ready Ruler", kr = "준비된 지배자", zh = "繼位之才", cn = "领袖之材", ceo_key = "3k_dlc06_ceo_career_historical_nanman_mangyachang", threshold = 1, },
     ['3k_dlc06_ceo_career_historical_nanman_mangyachang_02'] = { en_key = 'mangyachang', dlc = "fw", en = "Peerless Commander", kr = "최고의 지휘관", zh = "無雙將帥", cn = "超凡蛮将", ceo_key = "3k_dlc06_ceo_career_historical_nanman_mangyachang", threshold = 4, },
     ['3k_dlc06_ceo_career_historical_nanman_mangyachang_03'] = { en_key = 'mangyachang', dlc = "fw", en = "The Loyal Subordinate", kr = "충신", zh = "忠心副將", cn = "忠心下属", ceo_key = "3k_dlc06_ceo_career_historical_nanman_mangyachang", threshold = 7, },
   ['3k_dlc06_ceo_career_historical_nanman_king_meng_huo_01'] = { en_key = 'meng_huo', dlc = "fw", en = "The Stubborn Ox", kr = "황소고집", zh = "頑固如牛", cn = "发愤自雄", ceo_key = "3k_dlc06_ceo_career_historical_nanman_king_meng_huo", threshold = 1, },
   ['3k_dlc06_ceo_career_historical_nanman_king_meng_huo_02'] = { en_key = 'meng_huo', dlc = "fw", en = "The Ambitious Chieftain", kr = "야심찬 족장", zh = "野心首領", cn = "雄心酋首", ceo_key = "3k_dlc06_ceo_career_historical_nanman_king_meng_huo", threshold = 4, },
   ['3k_dlc06_ceo_career_historical_nanman_king_meng_huo_03'] = { en_key = 'meng_huo', dlc = "fw", en = "King of the Man", kr = "만왕", zh = "蠻王", cn = "南蛮霸王", ceo_key = "3k_dlc06_ceo_career_historical_nanman_king_meng_huo", threshold = 7, },
        ['3k_dlc06_ceo_career_historical_nanman_meng_jie_01'] = { en_key = 'meng_jie', dlc = "fw", en = "Believer in Peace", kr = "온건파", zh = "相信和平", cn = "非攻止战", ceo_key = "3k_dlc06_ceo_career_historical_nanman_meng_jie", threshold = 1, },
        ['3k_dlc06_ceo_career_historical_nanman_meng_jie_02'] = { en_key = 'meng_jie', dlc = "fw", en = "The Sophisticated Tribesmen  ", kr = "계몽된 부족민", zh = "開化族眾  ", cn = "开化族众", ceo_key = "3k_dlc06_ceo_career_historical_nanman_meng_jie", threshold = 4, },
        ['3k_dlc06_ceo_career_historical_nanman_meng_jie_03'] = { en_key = 'meng_jie', dlc = "fw", en = "The Learned One", kr = "깨달은 자", zh = "大賢之士", cn = "大贤之士", ceo_key = "3k_dlc06_ceo_career_historical_nanman_meng_jie", threshold = 7, },
        ['3k_dlc06_ceo_career_historical_nanman_meng_you_01'] = { en_key = 'meng_you', dlc = "fw", en = "Bull-headed Fighter", kr = "무소뿔 투사", zh = "固執鬥士", cn = "执拗斗士", ceo_key = "3k_dlc06_ceo_career_historical_nanman_meng_you", threshold = 1, },
        ['3k_dlc06_ceo_career_historical_nanman_meng_you_02'] = { en_key = 'meng_you', dlc = "fw", en = "The Little Warmaker", kr = "작은 전쟁광", zh = "好戰小將", cn = "好战小将", ceo_key = "3k_dlc06_ceo_career_historical_nanman_meng_you", threshold = 4, },
        ['3k_dlc06_ceo_career_historical_nanman_meng_you_03'] = { en_key = 'meng_you', dlc = "fw", en = "The Dependable Sibling", kr = "신뢰할 수 있는 형제", zh = "可靠手足", cn = "可靠手足", ceo_key = "3k_dlc06_ceo_career_historical_nanman_meng_you", threshold = 7, },
       ['3k_dlc06_ceo_career_historical_nanman_king_mulu_01'] = { en_key = 'mulu', dlc = "fw", en = "The Mystic Lord", kr = "신비의 군주", zh = "神秘統領", cn = "巫祝头领", ceo_key = "3k_dlc06_ceo_career_historical_nanman_king_mulu", threshold = 1, },
       ['3k_dlc06_ceo_career_historical_nanman_king_mulu_02'] = { en_key = 'mulu', dlc = "fw", en = "The Enigma of the Valleys", kr = "계곡의 수수께끼", zh = "五谿奇人", cn = "溪谷之秘", ceo_key = "3k_dlc06_ceo_career_historical_nanman_king_mulu", threshold = 4, },
       ['3k_dlc06_ceo_career_historical_nanman_king_mulu_03'] = { en_key = 'mulu', dlc = "fw", en = "Chief of Bana Ravine", kr = "팔납동주", zh = "八納洞主", cn = "八纳洞主", ceo_key = "3k_dlc06_ceo_career_historical_nanman_king_mulu", threshold = 7, },
    ['3k_dlc06_ceo_career_historical_nanman_king_shamoke_01'] = { en_key = 'shamoke', dlc = "fw", en = "Ruler of the Five Valleys", kr = "오계만의 통치자", zh = "五谿蠻王", cn = "五溪之主", ceo_key = "3k_dlc06_ceo_career_historical_nanman_king_shamoke", threshold = 1, },
    ['3k_dlc06_ceo_career_historical_nanman_king_shamoke_02'] = { en_key = 'shamoke', dlc = "fw", en = "The Blood-Shot Lord", kr = "적왕", zh = "血眼之王", cn = "血性之人", ceo_key = "3k_dlc06_ceo_career_historical_nanman_king_shamoke", threshold = 4, },
    ['3k_dlc06_ceo_career_historical_nanman_king_shamoke_03'] = { en_key = 'shamoke', dlc = "fw", en = "Sharp-minded", kr = "예리한 지성", zh = "思維敏銳", cn = "敏锐头领", ceo_key = "3k_dlc06_ceo_career_historical_nanman_king_shamoke", threshold = 7, },
           ['3k_dlc06_ceo_node_career_historical_shi_hui_01'] = { en_key = 'shi_hui', dlc = "fw", en = "Naively Ambitious", kr = "순진한 야망가", zh = "天真野心家", cn = "空有雄心", ceo_key = "3k_dlc06_ceo_career_historical_shi_hui", threshold = 1, },
         ['3k_dlc06_ceo_node_career_historical_shi_kuang_01'] = { en_key = 'shi_kuang', dlc = "fw", en = "Unbiased Advisor", kr = "고지식한 책사", zh = "剛直謀士", cn = "铮骨谋臣", ceo_key = "3k_dlc06_ceo_career_historical_shi_kuang", threshold = 1, },
           ['3k_dlc06_ceo_node_career_historical_shi_wei_01'] = { en_key = 'shi_wei', dlc = "fw", en = "Rash Judge", kr = "경솔한 판단자", zh = "魯莽判官", cn = "即鹿无虞", ceo_key = "3k_dlc06_ceo_career_historical_shi_wei", threshold = 1, },
           ['3k_dlc06_ceo_node_career_historical_shi_xin_01'] = { en_key = 'shi_xin', dlc = "fw", en = "Faithful of Shi", kr = "사가의 충신", zh = "士家忠良", cn = "士家忠良", ceo_key = "3k_dlc06_ceo_career_historical_shi_xin", threshold = 1, },
           ['3k_dlc06_ceo_node_career_historical_shi_zhi_01'] = { en_key = 'shi_zhi', dlc = "fw", en = "The Middle Child", kr = "중간자", zh = "排行居中", cn = "非长非幼", ceo_key = "3k_dlc06_ceo_career_historical_shi_zhi", threshold = 1, },
           ['3k_dlc06_ceo_career_historical_nanman_tu_an_01'] = { en_key = 'tu_an', dlc = "fw", en = "The Vicious Victor", kr = "잔학한 승리자", zh = "兇殘求勝", cn = "逐胜心切", ceo_key = "3k_dlc06_ceo_career_historical_nanman_tu_an", threshold = 1, },
           ['3k_dlc06_ceo_career_historical_nanman_tu_an_02'] = { en_key = 'tu_an', dlc = "fw", en = "Eager Tactician", kr = "열정적인 전술가", zh = "熱切軍師", cn = "战欲难填", ceo_key = "3k_dlc06_ceo_career_historical_nanman_tu_an", threshold = 4, },
           ['3k_dlc06_ceo_career_historical_nanman_tu_an_03'] = { en_key = 'tu_an', dlc = "fw", en = "War-Waiting General", kr = "전쟁을 기다리는 장군", zh = "候戰將軍", cn = "求战悍将", ceo_key = "3k_dlc06_ceo_career_historical_nanman_tu_an", threshold = 7, },
     ['3k_dlc06_ceo_career_historical_nanman_king_wutugu_01'] = { en_key = 'wutugu', dlc = "fw", en = "Wuguo Chieftain", kr = "오과족장", zh = "烏戈國主", cn = "乌戈国主", ceo_key = "3k_dlc06_ceo_career_historical_nanman_king_wutugu", threshold = 1, },
     ['3k_dlc06_ceo_career_historical_nanman_king_wutugu_02'] = { en_key = 'wutugu', dlc = "fw", en = "Nanman Chieftain", kr = "남만족장", zh = "南蠻首領", cn = "南蛮酋首", ceo_key = "3k_dlc06_ceo_career_historical_nanman_king_wutugu", threshold = 4, },
     ['3k_dlc06_ceo_career_historical_nanman_king_wutugu_03'] = { en_key = 'wutugu', dlc = "fw", en = "Grand Chieftain", kr = "대부족장", zh = "蠻王", cn = "诸蛮酋首", ceo_key = "3k_dlc06_ceo_career_historical_nanman_king_wutugu", threshold = 7, },
           ['3k_dlc06_ceo_career_historical_nanman_xi_ni_01'] = { en_key = 'xi_ni', dlc = "fw", en = "The Relentless", kr = "집요한 자", zh = "堅持不懈", cn = "进无反顾", ceo_key = "3k_dlc06_ceo_career_historical_nanman_xi_ni", threshold = 1, },
           ['3k_dlc06_ceo_career_historical_nanman_xi_ni_02'] = { en_key = 'xi_ni', dlc = "fw", en = "The Waiting Warrior", kr = "기다리는 전사", zh = "伺機戰士", cn = "枕戈待旦", ceo_key = "3k_dlc06_ceo_career_historical_nanman_xi_ni", threshold = 4, },
           ['3k_dlc06_ceo_career_historical_nanman_xi_ni_03'] = { en_key = 'xi_ni', dlc = "fw", en = "The Stalwart", kr = "충직한 전사", zh = "忠實可靠", cn = "不屈猛士", ceo_key = "3k_dlc06_ceo_career_historical_nanman_xi_ni", threshold = 7, },
       ['3k_dlc06_ceo_career_historical_nanman_yang_feng_01'] = { en_key = 'yang_feng', dlc = "fw", en = "Master of the Twenty-one Ravines", kr = "21개 협곡의 은야동주", zh = "二十一洞主", cn = "二十一洞主", ceo_key = "3k_dlc06_ceo_career_historical_nanman_yang_feng", threshold = 1, },
       ['3k_dlc06_ceo_career_historical_nanman_yang_feng_02'] = { en_key = 'yang_feng', dlc = "fw", en = "The Indulgent", kr = "관대한 족장", zh = "放縱耽溺", cn = "放纵无度", ceo_key = "3k_dlc06_ceo_career_historical_nanman_yang_feng", threshold = 4, },
       ['3k_dlc06_ceo_career_historical_nanman_yang_feng_03'] = { en_key = 'yang_feng', dlc = "fw", en = "The Ever-reaching", kr = "끝없는 야망", zh = "貪求無厭", cn = "贪求无已", ceo_key = "3k_dlc06_ceo_career_historical_nanman_yang_feng", threshold = 7, },
    ['3k_dlc06_ceo_career_historical_nanman_lady_zhurong_01'] = { en_key = 'zhurong', dlc = "fw", en = "Irrepressible Fire", kr = "꺼지지 않는 불길", zh = "怒火不滅", cn = "不灭之火", ceo_key = "3k_dlc06_ceo_career_historical_nanman_lady_zhurong", threshold = 1, },
    ['3k_dlc06_ceo_career_historical_nanman_lady_zhurong_02'] = { en_key = 'zhurong', dlc = "fw", en = "Received of the Cinder", kr = "불씨의 인도자", zh = "傳承火種", cn = "余烬传人", ceo_key = "3k_dlc06_ceo_career_historical_nanman_lady_zhurong", threshold = 4, },
    ['3k_dlc06_ceo_career_historical_nanman_lady_zhurong_03'] = { en_key = 'zhurong', dlc = "fw", en = "Descended of the Flames", kr = "화염의 후예", zh = "烈焰後裔", cn = "火神之后", ceo_key = "3k_dlc06_ceo_career_historical_nanman_lady_zhurong", threshold = 7, },
-- fw 53
            ['ep_ceo_node_career_historical_gongsun_hong_01'] = { en_key = 'gongsun_hong', dlc = "ep", en = "Observant Advisor", kr = "빈틈없는 책사", zh = "銳眼謀士", cn = "机警幕僚", ceo_key = "ep_ceo_career_historical_gongsun_hong", threshold = 1, },
                  ['ep_ceo_node_career_historical_he_lun_01'] = { en_key = 'he_lun', dlc = "ep", en = "Loyal Officer", kr = "충성스런 군관", zh = "忠心官員", cn = "尽忠校尉", ceo_key = "ep_ceo_career_historical_he_lun", threshold = 1, },
           ['ep_ceo_node_career_historical_huangfu_shang_01'] = { en_key = 'huangfu_shang', dlc = "ep", en = "Facilitator", kr = "조력자", zh = "主事能臣", cn = "引导大师", ceo_key = "ep_ceo_career_historical_huangfu_shang", threshold = 1, },
       ['3k_main_ceo_node_career_generated_general_metal_01'] = { en_key = 'jia_mo', dlc = "ep", en = "Guard", kr = "호위대", zh = "守衛", cn = "坚守不屈", ceo_key = "ep_ceo_career_historical_jia_mo", threshold = 1, },
             ['3k_main_ceo_node_career_historical_li_han_01'] = { en_key = 'li_han', dlc = "ep", en = "Keeper of Secrets", kr = "비밀의 수호자", zh = "守密謀臣", cn = "隐秘之主", ceo_key = "ep_ceo_career_historical_li_han", threshold = 1, },
                   ['ep_ceo_node_career_historical_lu_ji_01'] = { en_key = 'lu_ji_w', dlc = "ep", en = "Renowned Scholar", kr = "이름난 학자", zh = "知名文人", cn = "知名学者", ceo_key = "ep_ceo_career_historical_lu_ji", threshold = 1, },
                  ['ep_ceo_node_career_historical_lu_zhi_01'] = { en_key = 'lu_zhi', dlc = "ep", en = "Skilled Mediator", kr = "능숙한 중재인", zh = "高明說客", cn = "资深掮客", ceo_key = "ep_ceo_career_historical_lu_zhi", threshold = 1, },
      ['3k_main_ceo_node_career_generated_minister_earth_01'] = { en_key = 'pei_wei', dlc = "ep", en = "Magistrate", kr = "현령", zh = "法官", cn = "明镜高悬", ceo_key = "ep_ceo_career_historical_pei_wei", threshold = 1, },
            ['ep_ceo_node_career_historical_princess_pei_01'] = { en_key = 'princess_pei', dlc = "ep", en = "Insightful Survivalist", kr = "통찰력 있는 생존가", zh = "睿智烈女", cn = "未雨绸缪", ceo_key = "ep_ceo_career_historical_princess_pei", threshold = 1, },
                ['ep_ceo_node_career_historical_qi_sheng_01'] = { en_key = 'qi_sheng', dlc = "ep", en = "Cunning Clerk", kr = "교활한 관리", zh = "善謀文書", cn = "机谋主簿", ceo_key = "ep_ceo_career_historical_qi_sheng", threshold = 1, },
                ['ep_ceo_node_career_historical_shi_chao_01'] = { en_key = 'shi_chao', dlc = "ep", en = "Central Army Protector", kr = "중앙 수호군", zh = "中護軍", cn = "中护军", ceo_key = "ep_ceo_career_historical_shi_chao", threshold = 1, },
                 ['ep_ceo_node_career_historical_sima_ai_01'] = { en_key = 'sima_ai', dlc = "ep", en = "Principled Administrator", kr = "철학 있는 통치자", zh = "忠概藩王", cn = "清正廉明", ceo_key = "ep_ceo_career_historical_sima_ai", threshold = 1, },
                ['ep_ceo_node_career_historical_sima_cui_01'] = { en_key = 'sima_cui', dlc = "ep", en = "Jade Carver", kr = "옥 조각가", zh = "玉匠", cn = "玉雕工", ceo_key = "ep_ceo_career_historical_sima_cui", threshold = 1, },
              ['ep_ceo_node_career_historical_sima_jiong_01'] = { en_key = 'sima_jiong', dlc = "ep", en = "Imperious Regent", kr = "황실 섭정", zh = "專橫攝政", cn = "独掌大权", ceo_key = "ep_ceo_career_historical_sima_jiong", threshold = 1, },
                 ['ep_ceo_node_career_historical_sima_ju_01'] = { en_key = 'sima_ju_e', dlc = "ep", en = "Outsider Heir", kr = "외면 받는 후계자", zh = "繼嗣次子", cn = "局外储君", ceo_key = "ep_ceo_career_historical_sima_ju", threshold = 1, },
              ['ep_ceo_node_career_historical_sima_liang_01'] = { en_key = 'sima_liang', dlc = "ep", en = "Rightful Regent", kr = "정당한 섭정", zh = "奉旨攝政", cn = "众望所归", ceo_key = "ep_ceo_career_historical_sima_liang", threshold = 1, },
                ['ep_ceo_node_career_historical_sima_lun_01'] = { en_key = 'sima_lun', dlc = "ep", en = "Usurper Prince", kr = "찬탈자", zh = "僭位王侯", cn = "篡逆之王", ceo_key = "ep_ceo_career_historical_sima_lun", threshold = 1, },
                ['ep_ceo_node_career_historical_sima_wei_01'] = { en_key = 'sima_wei', dlc = "ep", en = "Tempestuous General", kr = "분노를 품은 장군", zh = "狠戾將領", cn = "狂烈悍将", ceo_key = "ep_ceo_career_historical_sima_wei", threshold = 1, },
               ['ep_ceo_node_career_historical_sima_ying_01'] = { en_key = 'sima_ying', dlc = "ep", en = "Beloved Governor", kr = "사랑받는 통치자", zh = "眾望輔政", cn = "万民景仰", ceo_key = "ep_ceo_career_historical_sima_ying", threshold = 1, },
               ['ep_ceo_node_career_historical_sima_yong_01'] = { en_key = 'sima_yong', dlc = "ep", en = "Shrewd Defender", kr = "기민한 방어자", zh = "精明衛士", cn = "精明卫士", ceo_key = "ep_ceo_career_historical_sima_yong", threshold = 1, },
                ['ep_ceo_node_career_historical_sima_yue_01'] = { en_key = 'sima_yue', dlc = "ep", en = "Imperial Overseer", kr = "황실 감독관", zh = "專擅威權", cn = "监察宇内", ceo_key = "ep_ceo_career_historical_sima_yue", threshold = 1, },
                 ['ep_ceo_node_career_historical_sun_xiu_01'] = { en_key = 'sun_xiu', dlc = "ep", en = "Partisan", kr = "유격대장", zh = "黨羽", cn = "通同结党", ceo_key = "ep_ceo_career_historical_sun_xiu", threshold = 1, },
                ['ep_ceo_node_career_historical_wang_bao_01'] = { en_key = 'wang_bao', dlc = "ep", en = "Steadfast Preacher", kr = "임전무퇴의 전도자", zh = "抗直諫臣", cn = "勇毅传道", ceo_key = "ep_ceo_career_historical_wang_bao", threshold = 1, },
                ['ep_ceo_node_career_historical_wei_guan_01'] = { en_key = 'wei_guan', dlc = "ep", en = "Mediator", kr = "설객", zh = "說客", cn = "说客", ceo_key = "ep_ceo_career_historical_wei_guan", threshold = 1, },
              ['ep_ceo_node_career_historical_zhang_fang_01'] = { en_key = 'zhang_fang', dlc = "ep", en = "Uncompromising Warrior", kr = "굽힘 없는 전사", zh = "不屈勇將", cn = "坚定猛将", ceo_key = "ep_ceo_career_historical_zhang_fang", threshold = 1, },
               ['ep_ceo_node_career_historical_zhang_hua_01'] = { en_key = 'zhang_hua', dlc = "ep", en = "Academic", kr = "학사", zh = "學者", cn = "饱学多才", ceo_key = "ep_ceo_career_historical_zhang_hua", threshold = 1, },
-- ep 26
-- total 308
}

					-- ====================================================== --
									-- Title DB functions --
					-- ====================================================== --


function sandbox:title_kr( query_character )

	local ceo_key, node_key = self:character_category_ceo_key( query_character, "3k_main_ceo_category_career" )

	return self:career_kr( nil, node_key )
end

function sandbox:career_kr( ceo_key, node_key )

	node_key = node_key or self:get_ceo_node_key( ceo_key )

if __game_mode >= 0 then
	return effect.get_localised_string( self:ceo_node_title_key( node_key ) )
else
	if self.db_careers[ node_key ][loc:get_locale()] then
		return self.db_careers[ node_key ][loc:get_locale()]
	else
		return "칭호"
	end
end
end

function sandbox:career_to_ceo_node_key( input_key )

	if self.db_careers_kr[ input_key ] then
		return self.db_careers_kr[ input_key ]
	end

	if self.db_careers[ input_key ] then
		return input_key
	end

	if self.db_heroes_kr[ input_key ] then
		local en_key = self.db_heroes[ self.db_heroes_kr[ input_key ] ].en_key

		if self.db_careers_kr[ en_key ] then
			return self.db_careers_kr[ en_key ]
		end
	end

end

function sandbox:action_career_to_ceo_node_key( action )

	local log_head = "action_career_to_ceo_node_key"
	logger:verbose( log_head, action )

	local node_key = self:career_to_ceo_node_key( action.input )

	if node_key then
		action.node_key = node_key
		action.ceo_key = self.db_careers[ node_key ].ceo_key

		logger:verbose( log_head, action )

		return action.node_key
	end
end

function sandbox:get_default_career( query_character )

	local row = self.db_heroes[ query_character:generation_template_key() ]

	if row then

		if self.db_career_defaults[ self:character_kr( query_character ) ] then
			return self.db_career_defaults[ self:character_kr( query_character ) ]
		end

		if self.db_career_defaults[ row.en_key ] then
			return self.db_career_defaults[ row.en_key ]
		end
		if self.db_career_defaults[ row.kr ] then
			return self.db_career_defaults[ row.kr ]
		end
		if self.db_career_defaults[ row.zh ] then
			return self.db_career_defaults[ row.zh ]
		end
		if self.db_career_defaults[ row.cn ] then
			return self.db_career_defaults[ row.cn ]
		end

		if row.en then
			local name_en = row.en:gsub( "%s", "" ):lower()

			if self.db_career_defaults[ name_en ] then
				return self.db_career_defaults[ name_en ]
			end
		end
	end
end

function sandbox:setup_hero_default_career( query_character )

	local career_key = self:get_default_career( query_character )

	if career_key and self.db_careers[ career_key ] then
		self:change_career_ceo_key( query_character, self.db_careers[ career_key ].ceo_key , self.db_careers[ career_key ].threshold )
	end
end

	------------------------------------------------------------------------------------
							-- Read Title Functions --
	------------------------------------------------------------------------------------

function sandbox:read_db_career_default( line )

	local log_head = "read_db_career_default"
	local hero, title = line:match( mod_patterns( "db.title.default" ) )

	if not hero or not title then
		logger:warn( log_head, "pattern mismatch", line );
		return false
	end

	logger:verbose( log_head, _eq( hero, title ) )

	if self.db_career_defaults[ hero ] then
		logger:warn( "_i:1", log_head, _hi( hero, "already exists" ) )
		return false
	end

	local career_key = self:career_to_ceo_node_key( title )

	if career_key then
		self.db_career_defaults[ hero ] = career_key
	else
		logger:warn( "_i:1", log_head, hero, _hi( title, "not found" ) )
		return false
	end

	--logger:dev( log_head, _to( hero, title, career_key ) )

	return true
end

function sandbox:read_db_career_setting( line )

	line = string.gsub( line, "title.", "" )

	if line:match( "^default." ) then
		return self:read_db_career_default( line )
	else
		logger:warn( "read_db_career_setting", "unknown db.title command", line )
	end
end

function sandbox:read_user_action_set_title( line )

	local log_head = "read_user_action_set_title"
	local hero, input, turn = string.match( line, mod_patterns( "set_title" ) )

	if lib.is_empty(hero) then
		logger:warn( log_head, "pattern mismatch", line );
		return nil
	end

	local action = self:create_action( "set_title" )

	self:set_action_hero( action, hero )
	action.input = input

	self:action_career_to_ceo_node_key( action )

	if not action.node_key then
		logger:warn( log_head, "career node_key not found", action )

		return nil
	end

	action.turn = lib.numberorone( turn )

	logger:dev( log_head, action.command, action )
	--logger:inspect( "action", action )
	return action
end

	------------------------------------------------------------------------------------
							-- Career CEO Functions --
	------------------------------------------------------------------------------------

function sandbox:remove_ancillary_title_from_character( query_character )

	local query_ceo_mgmt = query_character:ceo_management()
	local category = "3k_dlc05_ceo_category_ancillary_titles"

if __game_mode >= 0 then

	if not query_character:ceo_management():is_null_interface()
		and not query_ceo_mgmt:all_ceo_equipment_slots_for_category( category ):is_empty()
	then
		local slot = query_ceo_mgmt:all_ceo_equipment_slots_for_category( category ):item_at( 0 )

		self:modify_character(query_character):ceo_management():unequip_slot( slot )
	end
end

end

function sandbox:change_career_ceo_key( query_character, new_ceo_key, threshold )
	local log_head = "change_career_ceo_key"

	threshold = threshold or 1

	logger( log_head, self:character_kr(query_character), new_ceo_key, threshold )
	local prev_indent = logger:inc_indent()

	if self:is_character_ceo_managable( query_character ) then
		local modify_ceo_mgmt = self:modify_character( query_character ):ceo_management()

		if is_interface(modify_ceo_mgmt) then
			local old_ceo_key = self:character_category_ceo_key( query_character, "3k_main_ceo_category_career" )

			if old_ceo_key then	modify_ceo_mgmt:remove_ceos( old_ceo_key ) end

			-------------------------------------
			modify_ceo_mgmt:add_ceo( new_ceo_key )
			-------------------------------------

			if threshold ~= 1 then
				---------------------------------------------------------------------------------------------------------------
				self:character_change_points_of_ceos( query_character, "3k_main_ceo_category_career", new_ceo_key, threshold )
				---------------------------------------------------------------------------------------------------------------
			end

			local ceo_key, node_key, num_points = self:character_category_ceo_key( query_character, "3k_main_ceo_category_career", new_ceo_key )

			logger( log_head, _eq( "ceo_key", ceo_key ), _eq( "threshold", num_points ), node_key )
			logger:set_indent( prev_indent )

			return ceo_key, node_key, num_points
		else
			logger:error( log_head, self:character_kr(query_character), "invalid modify ceo management" )
		end
	else
		logger:error( log_head, self:character_kr(query_character), "ceo not managable" )
	end

	logger:set_indent( prev_indent )
end

	------------------------------------------------------------------------------------
							-- Scripted Title Functions --
	------------------------------------------------------------------------------------

function sandbox:user_scripted_set_title( action, query_character, quiet )

	local log_head = "user_scripted_set_title"

	if quiet then logger:set_quiet( true ) end

	logger( log_head, self:character_kr( query_character ), action )

	local prev_indent = logger:inc_indent()

	query_character = query_character or self:find_action_character( action )

	local result_ceo_key, result_node_key, result_points = nil, nil, 0

	if self:is_character_ceo_managable( query_character ) then

		if not action.ceo_key then self:action_career_to_ceo_node_key( action ) end

		if self.db_career_banned[ action.node_key ] then
			logger:warn( log_head, "unusable career title ["..self:career_kr( nil, action.node_key ).."]" )
			logger:set_indent( prev_indent )
			return
		end

		if action.ceo_key then

			local threshold = self.db_careers[ action.node_key ].threshold
			local old_ceo_key, old_node_key, old_num_points =
					self:character_category_ceo_key( query_character, "3k_main_ceo_category_career" )

			if old_node_key ~= action.node_key then
				------------------------------------------------------------------------------------------
				result_ceo_key, result_node_key, result_points = self:change_career_ceo_key( query_character, action.ceo_key, threshold )
				------------------------------------------------------------------------------------------
			end
		else
			logger:error( log_head, _to( action.input, "ceo_key", "not found") )
		end
	else
		logger:error( log_head, action.hero_kr, "not found or invalid management" )
	end

	if quiet then logger:set_quiet( false ) end

	logger:debug( log_head, _to( "result", result_ceo_key, result_points ) )
	logger:set_indent( prev_indent )
	return result_ceo_key, result_node_key, result_points
end

		------------------------------------------------------------------------------------
								-- Title Action Functions --
		------------------------------------------------------------------------------------

function sandbox:do_input_set_title( action )

	local log_head = "do_input_set_title"

	logger:trace( log_head, action )
	local prev_indent = logger:inc_indent()

	local query_character = self:find_action_character( action )

	if self:is_character_ceo_managable( query_character ) then
		local old_ceo_key = self:character_category_ceo_key( query_character, "3k_main_ceo_category_career" )
		local call_indent = logger:inc_indent()

		self:action_career_to_ceo_node_key( action )

		if not action.node_key then
			mod_advice:push( "set_title_not_found", action.input )
			return
		end

		if self.db_career_banned[ action.node_key ] then
			mod_advice:push_string( "unusable career title ["..self:career_kr( nil, action.node_key ).."]" )
			logger:set_indent( prev_indent )
			return
		end

		--------------------------------------------------------------------------------------------
		local new_ceo_key, new_node_key = self:user_scripted_set_title( action, query_character, false )
		--------------------------------------------------------------------------------------------

		logger:set_indent( call_indent )

		if lib.not_empty( new_ceo_key ) and new_node_key == action.node_key then

			local career_kr = self:career_kr( new_ceo_key, new_node_key )

			if not old_ceo_key then
				mod_advice:push( "set_title_added", self:character_kr( query_character ), career_kr )
			else
				mod_advice:push( "set_title_changed", self:character_kr( query_character ), career_kr )
			end
		elseif action.ceo_key then
			mod_advice:push( "set_title_failed", self:character_kr(query_character) )
		end
	else
		if not is_interface(query_character) then
			mod_advice:push( "hero_not_found_target", action.hero_kr )
		else
			mod_advice:push( "trait_hero_ceo_failed", action.hero_kr )
		end
	end

	logger:set_indent( prev_indent )
end

		------------------------------------------------------------------------------------
								-- Title DB Build Functions --
		------------------------------------------------------------------------------------

function sandbox:build_career_aliases()

--[[
	local ceo_key 		 		= "3k_main_ceo_career_historical_cao_cao"
	local ceo_node_key 		 	= "3k_main_ceo_node_career_historical_cao_cao_01"
	local ceo_node_title_key 	= "ceo_nodes_title_3k_main_ceo_node_career_historical_cao_cao_01"

	emperor_ling
	3k_main_ceo_career_historical_xiahou_dun
	3k_main_ceo_career_historical_xiahou_dun_blinded
]]--

	self.db_careers_kr = {}

	local log_head = "build_career_aliases"
	local count = 0
	for node_key, title in pairs( self.db_careers ) do
		---------------------------
		title.node_key = node_key
		---------------------------
		local alias_en = title.en:gsub( "%s", "" ):lower()
		local alias_kr = title.kr:gsub( "%s", "" )

		self.db_careers_kr[ alias_en ] = node_key
		self.db_careers_kr[ alias_kr ] = node_key

		self.db_careers_kr[ title.zh ] = node_key
		self.db_careers_kr[ title.cn ] = node_key

		local hero = self.db_heroes[ self.db_heroes_kr[title.en_key] ]

		if hero and title.threshold == 1 then
			if hero.en then self.db_careers_kr[ hero.en:gsub( "%s", "" ):lower() ] = node_key end
			if hero.kr then self.db_careers_kr[ hero.kr ] = node_key end
			if hero.zh then self.db_careers_kr[ hero.zh ] = node_key end
			if hero.cn then self.db_careers_kr[ hero.cn ] = node_key end
		end
		
		if not self.db_careers_kr[ title.en_key ]
			or self.db_careers[ self.db_careers_kr[title.en_key] ].threshold < self.db_careers[ node_key ].threshold
		then
			----------------------------------------------
			self.db_careers_kr[ title.en_key ] = node_key
			----------------------------------------------
		end
		count = count + 1
	end

	logger:info( log_head, count )
end
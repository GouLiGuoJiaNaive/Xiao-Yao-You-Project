local sandbox = TheGathering_sandbox:get_sandbox_mod()

		--==============================================================================--
									-- Common Header --
		--==============================================================================--

local lib		= sandbox:get_library()
local loc 	 	= sandbox:get_localisation()
local logger 	= sandbox:get_logger()

local _eq = function( ... ) return logger:eq( ... ) end
local _ee = function( ... ) return logger:ee( ... ) end
local _to = function( ... ) return logger:to( ... ) end

		--==============================================================================--
								  -- The Gathering Factions DB Locals --
		--==============================================================================--

		--=============================================================================--
									-- The Gathering Factions DB --
		--=============================================================================--

sandbox.db_factions_kr = {}
sandbox.db_factions_base_kr = {}

sandbox.db_factions = {
	    ['all'] = { cqi = 0, en_key = "all", 		en = "all",    kr = "전체", zh = "一切", cn = "一切" },
   ['player'] = { cqi = 0, en_key = "player", en = "player", kr = "아군", zh = "我軍", cn = "我军" },
   ['others'] = { cqi = 0, en_key = "others", en = "other",  kr = "다른", zh = "其他", cn = "其他" },
   ['rebels'] = { cqi = 1, en_key = "rebels", en = "rebels", kr = "반란군", zh = "叛軍", cn = "叛军" },
}

sandbox.db_factions_base = {
--逍遥游添加
['xyy'] = { kr = "覆舟虚怀", en_key = "xyy",      zh = "覆舟虚怀", cn = "覆舟虚怀", en = "覆舟虚怀",  },
['xyyhlyja'] = { kr = "天剑慕容府", en_key = "xyyhlyja",      zh = "天剑慕容府", cn = "天剑慕容府", en = "天剑慕容府",  },


               ['3k_main_faction_sun_quan'] = { kr = "손권", en_key = "sun_quan",     zh = "孫權", cn = "孙权", en = "Sun Quan",  },
              ['3k_main_faction_liu_zhang'] = { kr = "유장", en_key = "liu_zhang",     zh = "劉璋", cn = "刘璋", en = "Liu Zhang",  },

-- 
               ['3k_main_faction_jia_long'] = { kr = "가룡", en_key = "jia_long",     zh = "賈龍", cn = "贾龙", en = "Jia Long",  },
                ['3k_main_faction_gao_gan'] = { kr = "고간", en_key = "gao_gan",      zh = "高幹", cn = "高干", en = "Gao Gan",  },
   ['3k_main_faction_yellow_turban_anding'] = { kr = "공도", en_key = "yt_anding",    zh = "龔都", cn = "龚都", en = "Gong Du",  },
             ['3k_main_faction_gongsun_du'] = { kr = "공손도", en_key = "gongsun_du",   zh = "公孫度", cn = "公孙度", en = "Gongsun Du",  },
            ['3k_main_faction_gongsun_zan'] = { kr = "공손찬", en_key = "gongsun_zan",  zh = "公孫瓚", cn = "公孙瓒", en = "Gongsun Zan",  },
              ['3k_main_faction_kong_rong'] = { kr = "공융", en_key = "kong_rong",    zh = "孔融", cn = "孔融", en = "Kong Rong",  },
              ['3k_main_faction_kong_zhou'] = { kr = "공주", en_key = "kong_zhou",    zh = "孔伷", cn = "孔伷", en = "Kong Zhou",  },
                 ['3k_main_faction_lu_zhi'] = { kr = "노식", en_key = "lu_zhi",       zh = "盧植", cn = "卢植", en = "Lu Zhi",  },
               ['3k_main_faction_tao_qian'] = { kr = "도겸", en_key = "tao_qian",     zh = "陶謙", cn = "陶谦", en = "Tao Qian",  },
              ['3k_main_faction_dong_zhuo'] = { kr = "동탁", en_key = "dong_zhuo",    zh = "董卓", cn = "董卓", en = "Dong Zhuo",  },
                ['3k_main_faction_ma_teng'] = { kr = "마등", en_key = "ma_teng",      zh = "馬騰", cn = "马腾", en = "Ma Teng",  },
                 ['3k_main_faction_rebels'] = { kr = "반군", en_key = "rebels",       zh = "叛軍", cn = "叛军", en = "Rebels",  },
                ['3k_main_faction_shi_xie'] = { kr = "사섭", en_key = "shi_xie",      zh = "士燮", cn = "士燮", en = "Shi Xie",  },
               ['3k_main_faction_sun_jian'] = { kr = "손견", en_key = "sun_jian",     zh = "孫堅", cn = "孙坚", en = "Sun Jian",  },
                  ['3k_main_faction_lu_bu'] = { kr = "여포", en_key = "lu_bu",        zh = "呂布", cn = "吕布", en = "Lu Bu",  },
             ['3k_main_faction_wang_kuang'] = { kr = "왕광", en_key = "wang_kuang",   zh = "王匡", cn = "王匡", en = "Wang Kuang",  },
              ['3k_main_faction_wang_lang'] = { kr = "왕랑", en_key = "wang_lang",    zh = "王朗", cn = "王朗", en = "Wang Lang",  },
              ['3k_main_faction_yuan_shao'] = { kr = "원소", en_key = "yuan_shao",    zh = "袁紹", cn = "袁绍", en = "Yuan Shao",  },
               ['3k_main_faction_yuan_shu'] = { kr = "원술", en_key = "yuan_shu",     zh = "袁術", cn = "袁术", en = "Yuan Shu",  },
                ['3k_main_faction_liu_dai'] = { kr = "유대", en_key = "liu_dai",      zh = "劉岱", cn = "刘岱", en = "Liu Dai",  },
                ['3k_main_faction_liu_bei'] = { kr = "유비", en_key = "liu_bei",      zh = "劉備", cn = "刘备", en = "Liu Bei",  },
                ['3k_main_faction_liu_yan'] = { kr = "유언", en_key = "liu_yan",      zh = "劉焉", cn = "刘焉", en = "Liu Yan",  },
                ['3k_main_faction_liu_yao'] = { kr = "유요", en_key = "liu_yao",      zh = "劉繇", cn = "刘繇", en = "Liu Yao",  },
                 ['3k_main_faction_liu_yu'] = { kr = "유우", en_key = "liu_yu",       zh = "劉虞", cn = "刘虞", en = "Liu Yu",  },
               ['3k_main_faction_liu_biao'] = { kr = "유표", en_key = "liu_biao",     zh = "劉表", cn = "刘表", en = "Liu Biao",  },
               ['3k_main_faction_zhang_lu'] = { kr = "장로", en_key = "zhang_lu",     zh = "張魯", cn = "张鲁", en = "Zhang Lu",  },
             ['3k_main_faction_zhang_yang'] = { kr = "장양", en_key = "zhang_yang",   zh = "張楊", cn = "张杨", en = "Zhang Yang",  },
              ['3k_main_faction_zhang_yan'] = { kr = "장연", en_key = "zhang_yan",    zh = "張燕", cn = "张燕", en = "Zhang Yan",  },
             ['3k_main_faction_zhang_chao'] = { kr = "장초", en_key = "zhang_chao",   zh = "張超", cn = "张超", en = "Zhang Chao",  },
            ['3k_main_faction_zheng_jiang'] = { kr = "정강", en_key = "zheng_jiang",  zh = "鄭姜", cn = "郑姜", en = "Zheng Jiang",  },
                ['3k_main_faction_cao_cao'] = { kr = "조조", en_key = "cao_cao",      zh = "曹操", cn = "曹操", en = "Cao Cao",  },
              ['3k_main_faction_zhai_rong'] = { kr = "착융", en_key = "ze_rong",      zh = "笮融", cn = "笮融", en = "Zhai Rong",  },
                ['3k_main_faction_cai_mao'] = { kr = "채모", en_key = "cai_mao",      zh = "蔡瑁", cn = "蔡瑁", en = "Cai Mao",  },
   ['3k_main_faction_yellow_turban_rebels'] = { kr = "하의", en_key = "yt_rebels",    zh = "何儀", cn = "何仪", en = "He Yi",  },
             ['3k_main_faction_han_empire'] = { kr = "한나라", en_key = "han_empire",   zh = "大漢", cn = "汉帝国", en = "Han Empire",  },
                 ['3k_main_faction_han_fu'] = { kr = "한복", en_key = "han_fu",       zh = "韓馥", cn = "韩馥", en = "Han Fu",  },
                ['3k_main_faction_han_sui'] = { kr = "한수", en_key = "han_sui",      zh = "韓遂", cn = "韩遂", en = "Han Sui",  },
  ['3k_main_faction_yellow_turban_generic'] = { kr = "황건 반란군", en_key = "yt_generic",   zh = "黃巾軍", cn = "黄巾乱军", en = "Yellow Turban Rebels",  },
  ['3k_main_faction_yellow_turban_taishan'] = { kr = "황소", en_key = "yt_taishan",   zh = "黃邵", cn = "黄邵", en = "Huang Shao",  },
               ['3k_main_faction_huang_zu'] = { kr = "황조", en_key = "huang_zu",     zh = "黃祖", cn = "黄祖", en = "Huang Zu",  },
              ['3k_dlc04_faction_qiao_mao'] = { kr = "교모", en_key = "qiao_mao",     zh = "橋瑁", cn = "桥瑁", en = "Qiao Mao",  },
              ['3k_dlc04_faction_xin_xuan'] = { kr = "금선", en_key = "jin_xuan",     zh = "金旋", cn = "金旋", en = "Xin Xuan",  },
                ['3k_dlc04_faction_lu_zhi'] = { kr = "노식", en_key = "lu_zhi",       zh = "盧植", cn = "卢植", en = "Lu Zhi",  },
               ['3k_dlc04_faction_dong_he'] = { kr = "동화", en_key = "dong_he",      zh = "董和", cn = "董和", en = "Dong He",  },
            ['3k_dlc04_faction_bian_zhang'] = { kr = "변장", en_key = "bian_zhang",   zh = "邊章", cn = "边章", en = "Bian Zhang",  },
                ['3k_dlc04_faction_rebels'] = { kr = "약탈자", en_key = "looters",      zh = "劫匪", cn = "掳掠者", en = "Looters",  },
          ['3k_dlc04_faction_liang_rebels'] = { kr = "양주 반란군", en_key = "liang_rebels", zh = "涼州反抗軍", cn = "凉州叛军", en = "Liang Rebels",  },
              ['3k_dlc04_faction_wang_rui'] = { kr = "왕예", en_key = "wang_rui",     zh = "王睿", cn = "王睿", en = "Wang Rui",  },
               ['3k_dlc04_faction_yuan_yi'] = { kr = "원유", en_key = "yuan_yi",      zh = "袁遺", cn = "袁遗", en = "Yuan Yi",  },
              ['3k_dlc04_faction_liu_hong'] = { kr = "유굉", en_key = "liu_hong",     zh = "劉洪", cn = "刘宏", en = "Liu Hong",  },
      ['3k_dlc04_faction_prince_liu_chong'] = { kr = "유총", en_key = "liu_chong",    zh = "劉寵", cn = "刘宠", en = "Liu Chong",  },
               ['3k_dlc04_faction_liu_xun'] = { kr = "유훈", en_key = "liu_xun",      zh = "劉勳", cn = "刘勋", en = "Liu Xun",  },
               ['3k_dlc04_faction_lu_kang'] = { kr = "육강", en_key = "lu_kang",      zh = "陸康", cn = "陆康", en = "Lu Kang",  },
             ['3k_dlc04_faction_ying_shao'] = { kr = "응초", en_key = "ying_shao",    zh = "應劭", cn = "应劭", en = "Ying Shao",  },
             ['3k_dlc04_faction_zhang_jue'] = { kr = "장각", en_key = "zhang_jue",    zh = "張角", cn = "张角", en = "Zhang Jue",  },
           ['3k_dlc04_faction_zhang_liang'] = { kr = "장량", en_key = "zhang_liang",  zh = "張梁", cn = "张梁", en = "Zhang Liang",  },
             ['3k_dlc04_faction_zhang_bao'] = { kr = "장보", en_key = "zhang_bao",    zh = "張寶", cn = "张宝", en = "Zhang Bao",  },
              ['3k_dlc04_faction_chu_gong'] = { kr = "저공", en_key = "chu_gong",     zh = "褚貢", cn = "褚贡", en = "Chu Gong",  },
             ['3k_dlc04_faction_ding_yuan'] = { kr = "정원", en_key = "ding_yuan",    zh = "丁原", cn = "丁原", en = "Ding Yuan",  },
              ['3k_dlc04_faction_cao_song'] = { kr = "조숭", en_key = "cao_song",     zh = "曹嵩", cn = "曹嵩", en = "Cao Song",  },
              ['3k_dlc04_faction_zhou_xin'] = { kr = "주흔", en_key = "zhou_xin",     zh = "周昕", cn = "周昕", en = "Zhou Xin",  },
              ['3k_dlc04_faction_chen_gui'] = { kr = "진규", en_key = "chen_gui",     zh = "陳珪", cn = "陈珪", en = "Chen Gui",  },
            ['3k_dlc04_faction_empress_he'] = { kr = "황실", en_key = "empress_he",   zh = "漢朝", cn = "汉朝", en = "Han Dynasty",  },
                ['3k_dlc05_faction_shi_wu'] = { kr = "사무", en_key = "shi_wu",       zh = "士武", cn = "士武", en = "Shi Wu",  },
             ['3k_dlc05_faction_shi_huang'] = { kr = "사위", en_key = "shi_huang",    zh = "士䵋", cn = "士䵋", en = "Shi Wei",  },
                ['3k_dlc05_faction_shi_yi'] = { kr = "사일", en_key = "shi_yi",       zh = "士壹", cn = "士壹", en = "Shi Yi",  },
                ['3k_dlc05_faction_xue_li'] = { kr = "설례", en_key = "xue_li",       zh = "薛禮", cn = "薛礼", en = "Xue Li",  },
            ['3k_dlc05_faction_sheng_xian'] = { kr = "성헌", en_key = "sheng_xian",   zh = "盛憲", cn = "盛宪", en = "Sheng Xian",  },
                ['3k_dlc05_faction_sun_ce'] = { kr = "손책", en_key = "sun_ce",       zh = "孫策", cn = "孙策", en = "Sun Ce",  },
             ['3k_dlc05_faction_yang_feng'] = { kr = "양봉", en_key = "yang_feng",    zh = "楊奉", cn = "杨奉", en = "Yang Feng",  },
       ['3k_dlc05_faction_white_tiger_yan'] = { kr = "엄백호", en_key = "yan_baihu",    zh = "嚴白虎", cn = "严白虎", en = "White Tiger Yan",  },
               ['3k_dlc05_faction_wu_jing'] = { kr = "오경", en_key = "wu_jing",      zh = "吳景", cn = "吴景", en = "Wu Jing",  },
              ['3k_dlc05_faction_yuan_tan'] = { kr = "원담", en_key = "yuan_tan",     zh = "袁譚", cn = "袁谭", en = "Yuan Tan",  },
               ['3k_dlc05_faction_zang_ba'] = { kr = "장패", en_key = "zang_ba",      zh = "臧霸", cn = "臧霸", en = "Zang Ba",  },
              ['3k_dlc05_faction_tian_kai'] = { kr = "전해", en_key = "tian_kai",     zh = "田楷", cn = "田楷", en = "Tian Kai",  },
                ['3k_dlc05_faction_zhu_fu'] = { kr = "주부", en_key = "zhu_fu",       zh = "朱符", cn = "朱符", en = "Zhu Fu",  },
               ['3k_dlc05_faction_xu_gong'] = { kr = "허공", en_key = "xu_gong",      zh = "許貢", cn = "许贡", en = "Xu Gong",  },
               ['3k_dlc05_faction_xu_zhao'] = { kr = "허소", en_key = "xu_zhao",      zh = "許昭", cn = "许昭", en = "Xu Zhao",  },
               ['3k_dlc05_faction_hua_xin'] = { kr = "화흠", en_key = "hua_xin",      zh = "華歆", cn = "华歆", en = "Hua Xin",  },
               ['3k_dlc07_faction_shi_hui'] = { kr = "사휘", en_key = "shi_hui",      zh = "士徽", cn = "士徽", en = "Shi Hui",  },
        ['3k_dlc07_faction_shanyue_rebels'] = { kr = "산월 반군", en_key = "shanyue_rebels", zh = "山越反抗軍", cn = "山越叛军", en = "Shanyue Rebels",  },
               ['3k_dlc07_faction_yuan_xi'] = { kr = "원희", en_key = "yuan_xi",      zh = "袁熙", cn = "袁熙", en = "Yuan Xi",  },
                ['3k_dlc07_faction_li_shu'] = { kr = "이수", en_key = "li_shu",       zh = "李術", cn = "李术", en = "Li Shu",  },
              ['3k_dlc07_faction_zhang_lu'] = { kr = "장로", en_key = "zhang_lu",     zh = "張魯", cn = "张鲁", en = "Zhang Lu",  },
            ['3k_dlc07_faction_zhang_meng'] = { kr = "장맹", en_key = "zhang_meng",   zh = "張猛", cn = "张猛", en = "Zhang Meng",  },
             ['3k_dlc07_faction_zhang_xiu'] = { kr = "장수", en_key = "zhang_xiu",    zh = "張繡", cn = "张绣", en = "Zhang Xiu",  },
             ['3k_dlc07_faction_chen_deng'] = { kr = "진등", en_key = "chen_deng",    zh = "陳登", cn = "陈登", en = "Chen Deng",  },
         ['ep_faction_prince_of_jiangling'] = { kr = "강릉왕", en_key = "ep_jiangling", zh = "江陵王", cn = "江陵王", en = "Prince of Jiangling",  },
         ['ep_faction_prince_of_jiangyang'] = { kr = "강양왕", en_key = "ep_jiangyang", zh = "江陽王", cn = "江阳王", en = "Prince of Jiangyang",  },
          ['ep_faction_prince_of_jiangxia'] = { kr = "강하왕", en_key = "ep_jiangxia",  zh = "江夏王", cn = "江夏王", en = "Prince of Jiangxia",  },
            ['ep_faction_prince_of_jianan'] = { kr = "건안왕", en_key = "ep_jianan",    zh = "建安王", cn = "建安王", en = "Prince of Jian’an",  },
          ['ep_faction_prince_of_gaoliang'] = { kr = "고량왕", en_key = "ep_gaoliang",  zh = "高涼王", cn = "高凉王", en = "Prince of Gaoliang",  },
           ['ep_faction_prince_of_gaoyang'] = { kr = "고양왕", en_key = "ep_gaoyang",   zh = "高陽王", cn = "高阳王", en = "Prince of Gaoyang",  },
           ['ep_faction_prince_of_jiaozhi'] = { kr = "교지왕", en_key = "ep_jiaozhi",   zh = "交趾王", cn = "交趾王", en = "Prince of Jiaozhi",  },
              ['ep_factions_shadow_rebels'] = { kr = "귀족 반군", en_key = "ep_ep_rebels", zh = "官員叛軍", cn = "士族叛军", en = "Noble Rebels",  },
                      ['ep_faction_rebels'] = { kr = "귀족 반군", en_key = "ep_rebels",    zh = "官員叛軍", cn = "士族叛军", en = "Noble Rebels",  },
          ['ep_faction_prince_of_jincheng'] = { kr = "금성왕", en_key = "ep_jincheng",  zh = "金城王", cn = "金城王", en = "Prince of Jincheng",  },
              ['ep_faction_prince_of_lean'] = { kr = "낙안왕", en_key = "ep_lean",      zh = "樂安王", cn = "乐安王", en = "Prince of Lean",  },
             ['ep_faction_duke_of_lanling'] = { kr = "난릉왕", en_key = "ep_lanling",   zh = "蘭陵公", cn = "兰陵公国", en = "Duke of Lanling",  },
           ['ep_faction_prince_of_nanyang'] = { kr = "남양왕", en_key = "ep_nanyang",   zh = "南陽王", cn = "南阳王", en = "Prince of Nanyang",  },
            ['ep_faction_prince_of_nanhai'] = { kr = "남해왕", en_key = "ep_nanhai",    zh = "南海王", cn = "南海王", en = "Prince of Nanhai",  },
            ['ep_faction_prince_of_langye'] = { kr = "낭야왕", en_key = "ep_langye",    zh = "琅邪王", cn = "琅琊王", en = "Prince of Langye",  },
            ['ep_faction_prince_of_longxi'] = { kr = "농서왕", en_key = "ep_longxi",    zh = "隴西王", cn = "陇西王", en = "Prince of Longxi",  },
               ['ep_faction_prince_of_dai'] = { kr = "대왕", en_key = "ep_dai",       zh = "代王", cn = "代王", en = "Prince of Dai",  },
           ['ep_faction_prince_of_donglai'] = { kr = "동래왕", en_key = "ep_donglai",   zh = "東萊王", cn = "东莱王", en = "Prince of Donglai",  },
            ['ep_faction_prince_of_tongan'] = { kr = "동안왕", en_key = "ep_tongan",    zh = "同安王", cn = "同安王", en = "Prince of Tong’an",  },
            ['ep_faction_prince_of_dongan'] = { kr = "동안왕", en_key = "ep_dongan",    zh = "東安王", cn = "东安王", en = "Prince of Dongan",  },
          ['ep_faction_prince_of_dongping'] = { kr = "동평왕", en_key = "ep_dongping",  zh = "東平王", cn = "东平王", en = "Prince of Dongping",  },
           ['ep_faction_prince_of_donghai'] = { kr = "동해왕", en_key = "ep_donghai",   zh = "東海王", cn = "东海王", en = "Prince of Donghai",  },
              ['ep_faction_prince_of_wudu'] = { kr = "무도왕", en_key = "ep_wudu",      zh = "武都王", cn = "武都王", en = "Prince of Wudu",  },
            ['ep_faction_prince_of_wuling'] = { kr = "무릉왕", en_key = "ep_wuling",    zh = "武陵王", cn = "武陵王", en = "Prince of Wuling",  },
           ['ep_faction_prince_of_fanyang'] = { kr = "범양왕", en_key = "ep_fanyang",   zh = "范陽王", cn = "范阳王", en = "Prince of Fanyang",  },
            ['ep_faction_prince_of_fuling'] = { kr = "부릉왕", en_key = "ep_fuling",    zh = "涪陵王", cn = "涪陵王", en = "Prince of Fuling",  },
            ['ep_faction_prince_of_beihai'] = { kr = "북해왕", en_key = "ep_beihai",    zh = "北海王", cn = "北海王", en = "Prince of Beihai",  },
            ['ep_faction_prince_of_piling'] = { kr = "비릉왕", en_key = "ep_piling",    zh = "毗陵王", cn = "毗陵王", en = "Prince of Piling",  },
              ['ep_faction_prince_of_xihe'] = { kr = "서하왕", en_key = "ep_xihe",      zh = "西河王", cn = "西河王", en = "Prince of Xihe",  },
           ['ep_faction_prince_of_chengdu'] = { kr = "성도왕", en_key = "ep_chengdu",   zh = "成都王", cn = "成都王", en = "Prince of Chengdu",  },
          ['ep_faction_prince_of_shunyang'] = { kr = "순양왕", en_key = "ep_shunyang",  zh = "順陽王", cn = "顺阳王", en = "Prince of Shunyang",  },
             ['ep_faction_prince_of_xindu'] = { kr = "신도왕", en_key = "ep_xindu",     zh = "新都王", cn = "新都王", en = "Prince of Xindu",  },
             ['ep_faction_prince_of_xinye'] = { kr = "신야왕", en_key = "ep_xinye",     zh = "新野王", cn = "新野王", en = "Prince of Xinye",  },
            ['ep_faction_prince_of_yanmen'] = { kr = "안문왕", en_key = "ep_yanmen",    zh = "雁門王", cn = "雁门王", en = "Prince of Yanmen",  },
             ['ep_faction_prince_of_liang'] = { kr = "양왕", en_key = "ep_liang",     zh = "梁王", cn = "梁王", en = "Prince of Liang",  },
          ['ep_faction_prince_of_yangzhou'] = { kr = "양주왕", en_key = "ep_yangzhou",  zh = "揚州王", cn = "扬州王", en = "Prince of Yangzhou",  },
                ['ep_faction_prince_of_ye'] = { kr = "업왕", en_key = "ep_ye",        zh = "鄴王", cn = "邺王", en = "Prince of Ye",  },
           ['ep_faction_prince_of_lujiang'] = { kr = "여강왕", en_key = "ep_lujiang",   zh = "廬江王", cn = "庐江王", en = "Prince of Lujiang",  },
             ['ep_faction_prince_of_runan'] = { kr = "여남왕", en_key = "ep_runan",     zh = "汝南王", cn = "汝南王", en = "Prince of Ru'nan",  },
            ['ep_faction_prince_of_luling'] = { kr = "여릉왕", en_key = "ep_luling",    zh = "廬陵王", cn = "庐陵王", en = "Prince of Luling",  },
               ['ep_faction_prince_of_yan'] = { kr = "연왕", en_key = "ep_yan",       zh = "燕王", cn = "燕王", en = "Prince of Yan",  },
          ['ep_faction_prince_of_lingling'] = { kr = "영릉왕", en_key = "ep_lingling",  zh = "零陵王", cn = "零陵王", en = "Prince of Lingling",  },
           ['ep_faction_prince_of_yuzhang'] = { kr = "예장왕", en_key = "ep_yuzhang",   zh = "豫章王", cn = "豫章王", en = "Prince of Yuzhang",  },
                ['ep_faction_prince_of_wu'] = { kr = "오왕", en_key = "ep_wu",        zh = "吳王", cn = "吴王", en = "Prince of Wu",  },
            ['ep_faction_prince_of_liaoxi'] = { kr = "요서왕", en_key = "ep_liaoxi",    zh = "遼西王", cn = "辽西王", en = "Prince of Liaoxi",  },
            ['ep_faction_prince_of_yiyang'] = { kr = "의양왕", en_key = "ep_yiyang",    zh = "義陽王", cn = "益阳王", en = "Prince of Yiyang",  },
            ['ep_faction_prince_of_yizhou'] = { kr = "익주왕", en_key = "ep_yizhou",    zh = "益州王", cn = "益州王", en = "Prince of Yizhou",  },
          ['ep_faction_prince_of_rencheng'] = { kr = "임성왕", en_key = "ep_rencheng",  zh = "任城王", cn = "任城王", en = "Prince of Rencheng",  },
            ['ep_faction_prince_of_zangke'] = { kr = "장가왕", en_key = "ep_zangke",    zh = "牂牁王", cn = "牂牁王", en = "Prince of Zangke",  },
           ['ep_faction_prince_of_changle'] = { kr = "장락왕", en_key = "ep_changle",   zh = "長樂王", cn = "长乐王", en = "Prince of Changle",  },
          ['ep_faction_prince_of_changsha'] = { kr = "장사왕", en_key = "ep_changsha",  zh = "長沙王", cn = "长沙王", en = "Prince of Changsha",  },
           ['ep_faction_prince_of_changan'] = { kr = "장안왕", en_key = "ep_changan",   zh = "長安王", cn = "长安王", en = "Prince of Chang’an",  },
                ['ep_faction_prince_of_qi'] = { kr = "제왕", en_key = "ep_qi",        zh = "齊王", cn = "齐王", en = "Prince of Qi",  },
              ['ep_faction_prince_of_zhao'] = { kr = "조왕", en_key = "ep_zhao",      zh = "趙王", cn = "赵王", en = "Prince of Zhao",  },
         ['ep_faction_prince_of_zhongshan'] = { kr = "중산왕", en_key = "ep_zhongshan", zh = "中山王", cn = "中山王", en = "Prince of Zhongshan",  },
               ['ep_faction_empire_of_jin'] = { kr = "진나라", en_key = "ep_jin",       zh = "大晉", cn = "晋帝国", en = "Jin Empire",  },
           ['ep_faction_prince_of_chenliu'] = { kr = "진류왕", en_key = "ep_chenliu",   zh = "陳留王", cn = "陈留王", en = "Prince of Chenliu",  },
               ['ep_faction_prince_of_qin'] = { kr = "진왕", en_key = "ep_qin",       zh = "秦王", cn = "秦王", en = "Prince of Qin",  },
           ['ep_faction_prince_of_zhangwu'] = { kr = "창무왕", en_key = "ep_zhangwu",   zh = "章武王", cn = "章武王", en = "Prince of Zhangwu",  },
            ['ep_faction_prince_of_cangwu'] = { kr = "창오왕", en_key = "ep_cangwu",    zh = "蒼梧王", cn = "苍梧王", en = "Prince of Cangwu",  },
            ['ep_faction_prince_of_qinghe'] = { kr = "청하왕", en_key = "ep_qinghe",    zh = "清河王", cn = "清河王", en = "Prince of Qinghe",  },
               ['ep_faction_prince_of_chu'] = { kr = "초왕", en_key = "ep_chu",       zh = "楚王", cn = "楚王", en = "Prince of Chu",  },
              ['ep_faction_prince_of_qiao'] = { kr = "초왕", en_key = "ep_qiao",      zh = "譙王", cn = "谯王", en = "Prince of Qiao",  },
           ['ep_faction_prince_of_taiyuan'] = { kr = "태원왕", en_key = "ep_taiyuan",   zh = "太原王", cn = "太原王", en = "Prince of Taiyuan",  },
            ['ep_faction_prince_of_badong'] = { kr = "파동왕", en_key = "ep_badong",    zh = "巴東王", cn = "巴东王", en = "Prince of Badong",  },
            ['ep_faction_prince_of_poyang'] = { kr = "파양왕", en_key = "ep_poyang",    zh = "鄱陽王", cn = "鄱阳王", en = "Prince of Poyang",  },
                ['ep_faction_prince_of_ba'] = { kr = "파왕", en_key = "ep_ba",        zh = "巴王", cn = "巴王", en = "Prince of Ba",  },
          ['ep_faction_prince_of_pencheng'] = { kr = "팽성왕", en_key = "ep_pencheng",  zh = "彭城王", cn = "彭城王", en = "Prince of Pengcheng",  },
          ['ep_faction_prince_of_engcheng'] = { kr = "팽성왕", en_key = "ep_engcheng",  zh = "彭城王", cn = "彭城王", en = "Prince of Pengcheng",  },
          ['ep_faction_prince_of_pingyuan'] = { kr = "평원왕", en_key = "ep_pingyuan",  zh = "平原王", cn = "平原王", en = "Prince of Pingyuan",  },
            ['ep_faction_prince_of_hejian'] = { kr = "하간왕", en_key = "ep_hejian",    zh = "河間王", cn = "河间王", en = "Prince of Hejian",  },
             ['ep_faction_prince_of_henei'] = { kr = "하내왕", en_key = "ep_henei",     zh = "河內王", cn = "河内王", en = "Prince of Henei",  },
             ['ep_faction_prince_of_xiapi'] = { kr = "하비왕", en_key = "ep_xiapi",     zh = "下邳王", cn = "下邳王", en = "Prince of Xiapi",  },
               ['ep_faction_prince_of_han'] = { kr = "한왕", en_key = "ep_han",       zh = "漢王", cn = "汉王", en = "Prince of Han",  },
              ['ep_faction_prince_of_hepu'] = { kr = "합포왕", en_key = "ep_hepu",      zh = "合浦王", cn = "合浦王", en = "Prince of Hepu",  },
            ['ep_faction_prince_of_kuaiji'] = { kr = "회계왕", en_key = "ep_kuaiji",    zh = "會稽王", cn = "会稽王", en = "Prince of Kuaiji",  },
           ['ep_faction_prince_of_huainan'] = { kr = "회남왕", en_key = "ep_huainan",   zh = "淮南王", cn = "淮南王", en = "Prince of Huainan",  },
      ['3k_dlc06_faction_nanman_jiangyang'] = { kr = "강양", en_key = "jiangyang",    zh = "江陽部族", cn = "江阳部族", en = "Jiangyang Tribes",  },
       ['3k_dlc06_faction_nanman_jianning'] = { kr = "건녕", en_key = "jianning",     zh = "建寧部族", cn = "建宁部族", en = "Jianning Tribes",  },
        ['3k_dlc06_faction_nanman_jiaozhi'] = { kr = "교지", en_key = "jiaozhi",      zh = "交趾部族", cn = "交趾部族", en = "Jiaozhi Tribes",  },
  ['3k_dlc06_faction_nanman_jinhuansanjie'] = { kr = "금환삼결", en_key = "jinhuansanjie", zh = "金環三結", cn = "金环三结", en = "Jinhuansanjie",  },
         ['3k_dlc06_faction_nanman_rebels'] = { kr = "남만 반란군", en_key = "nanman_rebels", zh = "南蠻叛軍", cn = "南蛮叛军", en = "Nanman Rebels",  },
       ['3k_dlc06_faction_nanman_dongtuna'] = { kr = "동도나", en_key = "dongtuna",     zh = "董荼那", cn = "董荼那", en = "Dongtuna",  },
    ['3k_dlc06_faction_nanman_mangyachang'] = { kr = "망아장", en_key = "mangyachang",  zh = "忙牙長", cn = "忙牙长", en = "Mangyachang",  },
  ['3k_dlc06_faction_nanman_king_meng_huo'] = { kr = "맹획", en_key = "meng_huo",     zh = "孟獲", cn = "孟获", en = "Meng Huo",  },
      ['3k_dlc06_faction_nanman_king_mulu'] = { kr = "목록", en_key = "mulu",         zh = "木鹿大王", cn = "木鹿大王", en = "King Mulu",  },
   ['3k_dlc06_faction_nanman_king_shamoke'] = { kr = "사마가", en_key = "shamoke",      zh = "沙摩柯大王", cn = "沙摩柯大王", en = "King Shamoke",  },
        ['3k_dlc06_faction_nanman_ahuinan'] = { kr = "아회남", en_key = "ahuinan",      zh = "阿會喃", cn = "阿会喃", en = "Ahuinan",  },
      ['3k_dlc06_faction_nanman_yang_feng'] = { kr = "양봉", en_key = "nanman_yang_feng", zh = "楊鋒部族", cn = "杨锋部族", en = "Yang Feng",  },
      ['3k_dlc06_faction_nanman_yongchang'] = { kr = "영창", en_key = "yongchang",    zh = "永昌部族", cn = "永昌部族", en = "Yongchang Tribes",  },
    ['3k_dlc06_faction_nanman_king_wutugu'] = { kr = "올돌골", en_key = "wutugu",       zh = "兀突骨大王", cn = "兀突骨大王", en = "King Wutugu",  },
              ['3k_dlc06_faction_liaodong'] = { kr = "요동", en_key = "liaodong",     zh = "遼東", cn = "辽东", en = "Liaodong",  },
         ['3k_dlc06_faction_nanman_yunnan'] = { kr = "운남", en_key = "yunnan",       zh = "雲南部族", cn = "云南部族", en = "Yunnan Tribes",  },
         ['3k_dlc06_faction_nanman_zangke'] = { kr = "장가", en_key = "zangke",       zh = "牂牁部族", cn = "牂牁部族", en = "Zangke Tribes",  },
   ['3k_dlc06_faction_nanman_lady_zhurong'] = { kr = "축융", en_key = "zhurong",      zh = "祝融夫人", cn = "祝融夫人", en = "Lady Zhurong",  },
     ['3k_dlc06_faction_nanman_king_duosi'] = { kr = "타사", en_key = "duosi",        zh = "朵思大王", cn = "朵思大王", en = "King Duosi",  },
          ['3k_dlc06_faction_nanman_tu_an'] = { kr = "토안", en_key = "tu_an",        zh = "土安", cn = "土安", en = "Tu'An",  },
                 ['3k_dlc06_faction_xiapi'] = { kr = "하비", en_key = "xiapi",        zh = "下邳", cn = "下邳", en = "Xiapi",  },
          ['3k_dlc06_faction_nanman_xi_ni'] = { kr = "해니", en_key = "xi_ni",        zh = "奚泥", cn = "奚泥", en = "Xi'Ni",  },
-- 186
}

sandbox.db_starting_factions = {}
sandbox.db_starting_factions.tke = {
                                           ['xyy'] = true, -- 逍遥游
                                      ['xyyhlyja'] = true, -- 天剑慕容府
                       ['3k_main_faction_cao_cao'] = true, -- 조조
                       ['3k_main_faction_liu_bei'] = true, -- 유비
              ['3k_dlc05_faction_white_tiger_yan'] = true, -- 엄백호
                   ['3k_main_faction_gongsun_zan'] = true, -- 공손찬
                     ['3k_main_faction_yuan_shao'] = true, -- 원소
                      ['3k_main_faction_sun_jian'] = true, -- 손견
                   ['3k_main_faction_zheng_jiang'] = true, -- 정강
          ['3k_main_faction_yellow_turban_rebels'] = true, -- 하의
                     ['3k_main_faction_dong_zhuo'] = true, -- 동탁
                     ['3k_main_faction_kong_rong'] = true, -- 공융
                      ['3k_main_faction_liu_biao'] = true, -- 유표
                       ['3k_main_faction_liu_yan'] = true, -- 유언
                       ['3k_main_faction_ma_teng'] = true, -- 마등
                      ['3k_main_faction_tao_qian'] = true, -- 도겸
                      ['3k_main_faction_yuan_shu'] = true, -- 원술
                     ['3k_main_faction_zhang_yan'] = true, -- 장연
                       ['3k_main_faction_shi_xie'] = true, -- 사섭
          ['3k_main_faction_yellow_turban_anding'] = true, -- 공도
         ['3k_main_faction_yellow_turban_taishan'] = true, -- 황소
             ['3k_dlc04_faction_prince_liu_chong'] = true, -- 진왕 유총
         ['3k_dlc06_faction_nanman_king_meng_huo'] = true, -- 맹획
          ['3k_dlc06_faction_nanman_lady_zhurong'] = true, -- 축융부인
             ['3k_dlc06_faction_nanman_king_mulu'] = true, -- 목록대왕
          ['3k_dlc06_faction_nanman_king_shamoke'] = true, -- 사마가 대왕
                   ['3k_dlc05_faction_sheng_xian'] = true, -- 성헌
                       ['3k_dlc05_faction_zhu_fu'] = true, -- 주부
                       ['3k_main_faction_cai_mao'] = true, -- 채모
                       ['3k_main_faction_gao_gan'] = true, -- 고간
                    ['3k_main_faction_gongsun_du'] = true, -- 공손도
                        ['3k_main_faction_han_fu'] = true, -- 한복
                       ['3k_main_faction_han_sui'] = true, -- 한수
                    ['3k_main_faction_han_empire'] = true, -- 한나라
                      ['3k_main_faction_huang_zu'] = true, -- 황조
                      ['3k_main_faction_jia_long'] = true, -- 가룡
                     ['3k_main_faction_kong_zhou'] = true, -- 공주
                       ['3k_main_faction_liu_dai'] = true, -- 유대
                       ['3k_main_faction_liu_yao'] = true, -- 유요
                        ['3k_main_faction_liu_yu'] = true, -- 유우
                    ['3k_main_faction_wang_kuang'] = true, -- 왕광
                     ['3k_main_faction_wang_lang'] = true, -- 왕랑
                    ['3k_main_faction_zhang_chao'] = true, -- 장초
                    ['3k_main_faction_zhang_yang'] = true, -- 장양
                      ['3k_main_faction_zhang_lu'] = true, -- 장로
                     ['3k_main_faction_zhai_rong'] = true, -- 착융
                      ['3k_main_faction_gaoliang'] = true, -- 고량군
                        ['3k_main_faction_nanhai'] = true, -- 남해군
                      ['3k_dlc06_faction_jiuzhen'] = true, -- 구진군
                         ['3k_main_faction_yulin'] = true, -- 울림군
         ['3k_main_faction_yellow_turban_generic'] = true, -- 황건 반란군
           ['3k_dlc06_faction_nanman_king_wutugu'] = true, -- 올돌골 대왕
            ['3k_dlc06_faction_nanman_king_duosi'] = true, -- 타사대왕
               ['3k_dlc06_faction_nanman_ahuinan'] = true, -- 아회남
              ['3k_dlc06_faction_nanman_dongtuna'] = true, -- 동도나
             ['3k_dlc06_faction_nanman_jiangyang'] = true, -- 강양 부족
              ['3k_dlc06_faction_nanman_jianning'] = true, -- 건녕 부족
               ['3k_dlc06_faction_nanman_jiaozhi'] = true, -- 교지 부족
         ['3k_dlc06_faction_nanman_jinhuansanjie'] = true, -- 금환삼결
           ['3k_dlc06_faction_nanman_mangyachang'] = true, -- 망아장
                 ['3k_dlc06_faction_nanman_tu_an'] = true, -- 토안
                 ['3k_dlc06_faction_nanman_xi_ni'] = true, -- 해니
             ['3k_dlc06_faction_nanman_yang_feng'] = true, -- 양봉
             ['3k_dlc06_faction_nanman_yongchang'] = true, -- 영창 부족
                ['3k_dlc06_faction_nanman_yunnan'] = true, -- 운남 부족
                ['3k_dlc06_faction_nanman_zangke'] = true, -- 장가 부족
}

sandbox.db_starting_factions.moh = {
--
                                           ['xyy'] = true, -- 逍遥游
                                      ['xyyhlyja'] = true, -- 天剑慕容府
                       ['3k_main_faction_cao_cao'] = true, -- 조조
                   ['3k_dlc04_faction_empress_he'] = true, -- 한나라 황실
                       ['3k_dlc04_faction_lu_zhi'] = true, -- 노식
             ['3k_dlc04_faction_prince_liu_chong'] = true, -- 진왕 유총
                      ['3k_main_faction_tao_qian'] = true, -- 도겸
                    ['3k_dlc04_faction_zhang_bao'] = true, -- 장보
                    ['3k_dlc04_faction_zhang_jue'] = true, -- 장각
                  ['3k_dlc04_faction_zhang_liang'] = true, -- 장량
                     ['3k_main_faction_dong_zhuo'] = true, -- 동탁
                       ['3k_main_faction_liu_bei'] = true, -- 유비
                      ['3k_main_faction_liu_biao'] = true, -- 유표
                      ['3k_main_faction_sun_jian'] = true, -- 손견
                       ['3k_main_faction_ma_teng'] = true, -- 마등
                      ['3k_main_faction_yuan_shu'] = true, -- 원술
                   ['3k_dlc04_faction_bian_zhang'] = true, -- 변장
                     ['3k_dlc04_faction_cao_song'] = true, -- 조숭
                     ['3k_dlc04_faction_chen_gui'] = true, -- 진규
                     ['3k_dlc04_faction_chu_gong'] = true, -- 저공
                    ['3k_dlc04_faction_ding_yuan'] = true, -- 정원
                      ['3k_dlc04_faction_dong_he'] = true, -- 동화
                        ['3k_main_faction_han_fu'] = true, -- 한복
                       ['3k_main_faction_han_sui'] = true, -- 한수
                     ['3k_dlc04_faction_liu_hong'] = true, -- 유굉
                      ['3k_dlc04_faction_liu_xun'] = true, -- 유훈
                       ['3k_main_faction_liu_yan'] = true, -- 유언
                        ['3k_main_faction_liu_yu'] = true, -- 유우
                      ['3k_dlc04_faction_lu_kang'] = true, -- 육강
                     ['3k_dlc04_faction_qiao_mao'] = true, -- 교모
                     ['3k_dlc04_faction_wang_rui'] = true, -- 왕예
                     ['3k_dlc04_faction_xin_xuan'] = true, -- 금선
                    ['3k_dlc04_faction_ying_shao'] = true, -- 응초
                      ['3k_dlc04_faction_yuan_yi'] = true, -- 원유
                     ['3k_dlc04_faction_zhou_xin'] = true, -- 주흔
                    ['3k_main_faction_han_empire'] = true, -- 한나라
         ['3k_main_faction_yellow_turban_generic'] = true, -- 황건 반란군
                       ['3k_dlc04_faction_rebels'] = true, -- 약탈자
                ['3k_dlc06_faction_nanman_rebels'] = true, -- 남만 반란군
-- [moh] 37
}

sandbox.db_starting_factions.wb = {
--
                                           ['xyy'] = true, -- 逍遥游
                                      ['xyyhlyja'] = true, -- 天剑慕容府
                       ['3k_main_faction_cao_cao'] = true, -- 조조
              ['3k_dlc05_faction_white_tiger_yan'] = true, -- 엄백호
                       ['3k_dlc05_faction_sun_ce'] = true, -- 손책
                         ['3k_main_faction_lu_bu'] = true, -- 여포
                     ['3k_main_faction_yuan_shao'] = true, -- 원소
                      ['3k_main_faction_yuan_shu'] = true, -- 원술
                       ['3k_main_faction_ma_teng'] = true, -- 마등
                     ['3k_main_faction_dong_zhuo'] = true, -- 동탁
                      ['3k_main_faction_liu_biao'] = true, -- 유표
                     ['3k_main_faction_kong_rong'] = true, -- 공융
                   ['3k_main_faction_zheng_jiang'] = true, -- 정강
                   ['3k_main_faction_gongsun_zan'] = true, -- 공손찬
                       ['3k_main_faction_liu_bei'] = true, -- 유비
                       ['3k_main_faction_liu_yan'] = true, -- 유언
                     ['3k_main_faction_zhang_yan'] = true, -- 장연
                       ['3k_main_faction_shi_xie'] = true, -- 사섭
          ['3k_main_faction_yellow_turban_rebels'] = true, -- 하의
             ['3k_dlc04_faction_prince_liu_chong'] = true, -- 진왕 유총
         ['3k_dlc06_faction_nanman_king_meng_huo'] = true, -- 맹획
          ['3k_dlc06_faction_nanman_lady_zhurong'] = true, -- 축융부인
             ['3k_dlc06_faction_nanman_king_mulu'] = true, -- 목록대왕
          ['3k_dlc06_faction_nanman_king_shamoke'] = true, -- 사마가 대왕
                       ['3k_main_faction_han_sui'] = true, -- 한수
                    ['3k_main_faction_han_empire'] = true, -- 한나라
                      ['3k_main_faction_huang_zu'] = true, -- 황조
                      ['3k_dlc05_faction_hua_xin'] = true, -- 화흠
                    ['3k_main_faction_gongsun_du'] = true, -- 공손도
                       ['3k_dlc05_faction_zhu_fu'] = true, -- 주부
                       ['3k_dlc05_faction_xue_li'] = true, -- 설례
                    ['3k_dlc05_faction_shi_huang'] = true, -- 사위
                    ['3k_dlc05_faction_yang_feng'] = true, -- 양봉
                      ['3k_dlc05_faction_xu_zhao'] = true, -- 허소
                      ['3k_dlc05_faction_xu_gong'] = true, -- 허공
                     ['3k_dlc05_faction_yuan_tan'] = true, -- 원담
                     ['3k_dlc05_faction_tian_kai'] = true, -- 전해
                       ['3k_main_faction_gao_gan'] = true, -- 고간
                       ['3k_main_faction_liu_yao'] = true, -- 유요
                     ['3k_main_faction_wang_lang'] = true, -- 왕랑
                    ['3k_main_faction_zhang_yang'] = true, -- 장양
                      ['3k_main_faction_zhang_lu'] = true, -- 장로
                     ['3k_main_faction_zhai_rong'] = true, -- 착융
                       ['3k_main_faction_dongjun'] = true, -- 동군
                      ['3k_main_faction_gaoliang'] = true, -- 고량군
                        ['3k_main_faction_nanhai'] = true, -- 남해군
                            ['3k_main_faction_ba'] = true, -- 파군
                     ['3k_main_faction_shangyong'] = true, -- 상용군
                       ['3k_main_faction_youzhou'] = true, -- 광양군
         ['3k_main_faction_yellow_turban_generic'] = true, -- 황건 반란군
                      ['3k_dlc04_faction_lu_kang'] = true, -- 육강
           ['3k_dlc05_faction_zhu_fu_separatists'] = true, -- 주부군 이탈 세력
                      ['3k_dlc05_faction_wu_jing'] = true, -- 오경
                      ['3k_dlc05_faction_zang_ba'] = true, -- 장패
           ['3k_dlc06_faction_nanman_king_wutugu'] = true, -- 올돌골 대왕
            ['3k_dlc06_faction_nanman_king_duosi'] = true, -- 타사대왕
               ['3k_dlc06_faction_nanman_ahuinan'] = true, -- 아회남
              ['3k_dlc06_faction_nanman_dongtuna'] = true, -- 동도나
             ['3k_dlc06_faction_nanman_jiangyang'] = true, -- 강양 부족
         ['3k_dlc06_faction_nanman_jinhuansanjie'] = true, -- 금환삼결
           ['3k_dlc06_faction_nanman_mangyachang'] = true, -- 망아장
                 ['3k_dlc06_faction_nanman_tu_an'] = true, -- 토안
                 ['3k_dlc06_faction_nanman_xi_ni'] = true, -- 해니
             ['3k_dlc06_faction_nanman_yang_feng'] = true, -- 양봉
-- [wb] 62
}

sandbox.db_starting_factions.fd = {
--
                                           ['xyy'] = true, -- 逍遥游
                                      ['xyyhlyja'] = true, -- 天剑慕容府
                       ['3k_main_faction_cao_cao'] = true, -- 조조
                     ['3k_main_faction_yuan_shao'] = true, -- 원소
                       ['3k_main_faction_liu_bei'] = true, -- 유비
                       ['3k_dlc05_faction_sun_ce'] = true, -- 손책
                       ['3k_main_faction_ma_teng'] = true, -- 마등
                      ['3k_main_faction_liu_biao'] = true, -- 유표
                       ['3k_main_faction_liu_yan'] = true, -- 유언
                     ['3k_main_faction_zhang_yan'] = true, -- 장연
                   ['3k_main_faction_zheng_jiang'] = true, -- 정강
          ['3k_main_faction_yellow_turban_anding'] = true, -- 공도
                       ['3k_main_faction_shi_xie'] = true, -- 사섭
         ['3k_dlc06_faction_nanman_king_meng_huo'] = true, -- 맹획
             ['3k_dlc06_faction_nanman_king_mulu'] = true, -- 목록대왕
          ['3k_dlc06_faction_nanman_king_shamoke'] = true, -- 사마가 대왕
                     ['3k_dlc05_faction_yuan_tan'] = true, -- 원담
                      ['3k_dlc07_faction_yuan_xi'] = true, -- 원희
                      ['3k_main_faction_huang_zu'] = true, -- 황조
                       ['3k_main_faction_gao_gan'] = true, -- 고간
                       ['3k_main_faction_han_sui'] = true, -- 한수
                    ['3k_main_faction_gongsun_du'] = true, -- 공손도
                       ['3k_dlc05_faction_shi_yi'] = true, -- 사일
                       ['3k_dlc05_faction_shi_wu'] = true, -- 사무
                     ['3k_dlc07_faction_zhang_lu'] = true, -- 장로
                       ['3k_dlc07_faction_li_shu'] = true, -- 이수
                      ['3k_dlc05_faction_wu_jing'] = true, -- 오경
                    ['3k_dlc07_faction_chen_deng'] = true, -- 진등
                   ['3k_dlc07_faction_zhang_meng'] = true, -- 장맹
                    ['3k_dlc05_faction_shi_huang'] = true, -- 사위
                      ['3k_dlc05_faction_hua_xin'] = true, -- 화흠
                      ['3k_dlc05_faction_xu_zhao'] = true, -- 허소
                    ['3k_dlc07_faction_zhang_xiu'] = true, -- 장수
                      ['3k_dlc07_faction_shi_hui'] = true, -- 사휘
               ['3k_dlc07_faction_shanyue_rebels'] = true, -- 산월 반군
-- fd [33]
}

sandbox.db_starting_factions.ep = {
--
                                           ['xyy'] = true, -- 逍遥游
                                      ['xyyhlyja'] = true, -- 天剑慕容府
                   ['ep_faction_prince_of_hejian'] = true, -- 하간왕
                    ['ep_faction_prince_of_runan'] = true, -- 여남왕
                      ['ep_faction_prince_of_chu'] = true, -- 초왕
                     ['ep_faction_prince_of_zhao'] = true, -- 조왕
                       ['ep_faction_prince_of_qi'] = true, -- 제왕
                 ['ep_faction_prince_of_changsha'] = true, -- 장사왕
                  ['ep_faction_prince_of_chengdu'] = true, -- 성도왕
                  ['ep_faction_prince_of_donghai'] = true, -- 동해왕
                      ['ep_faction_empire_of_jin'] = true, -- 진나라
                  ['ep_faction_prince_of_nanyang'] = true, -- 남양왕
                  ['ep_faction_prince_of_taiyuan'] = true, -- 태원왕
                 ['ep_faction_prince_of_lingling'] = true, -- 영릉왕
                  ['ep_faction_prince_of_yuzhang'] = true, -- 예장왕
                  ['ep_faction_prince_of_zhangwu'] = true, -- 창무왕
                   ['ep_faction_prince_of_langye'] = true, -- 낭야왕
                ['ep_faction_prince_of_jiangling'] = true, -- 강릉왕
                      ['ep_faction_prince_of_yan'] = true, -- 연왕
                   ['ep_faction_prince_of_wuling'] = true, -- 무릉왕
                   ['ep_faction_prince_of_dongan'] = true, -- 동안왕
                   ['ep_faction_prince_of_badong'] = true, -- 파동왕
                 ['ep_faction_prince_of_pingyuan'] = true, -- 평원왕
                  ['ep_faction_prince_of_donglai'] = true, -- 동래왕
                 ['ep_faction_prince_of_jiangxia'] = true, -- 강하왕
                  ['ep_faction_prince_of_chenliu'] = true, -- 진류왕
                   ['ep_faction_prince_of_yiyang'] = true, -- 의양왕
                       ['ep_faction_prince_of_wu'] = true, -- 오왕
                  ['ep_faction_prince_of_jiaozhi'] = true, -- 교지왕
                ['ep_faction_prince_of_jiangyang'] = true, -- 강양왕
                 ['ep_faction_prince_of_pencheng'] = true, -- 팽성왕
                      ['ep_faction_prince_of_han'] = true, -- 한왕
                ['ep_faction_prince_of_zhongshan'] = true, -- 중산왕
                  ['ep_faction_prince_of_lujiang'] = true, -- 여강왕
                   ['ep_faction_prince_of_cangwu'] = true, -- 창오왕
                       ['ep_faction_prince_of_ba'] = true, -- 파왕
                  ['ep_faction_prince_of_changle'] = true, -- 장락왕
                   ['ep_faction_prince_of_longxi'] = true, -- 농서왕
                   ['ep_faction_prince_of_poyang'] = true, -- 파양왕
                     ['ep_faction_prince_of_wudu'] = true, -- 무도왕
                  ['ep_faction_prince_of_changan'] = true, -- 장안왕
                   ['ep_faction_prince_of_beihai'] = true, -- 북해왕
                      ['ep_faction_prince_of_qin'] = true, -- 진왕
                      ['ep_faction_prince_of_dai'] = true, -- 대왕
                 ['ep_faction_prince_of_shunyang'] = true, -- 순양왕
                   ['ep_faction_prince_of_fuling'] = true, -- 부릉왕
                     ['ep_faction_prince_of_hepu'] = true, -- 합포왕
                    ['ep_faction_duke_of_lanling'] = true, -- 난릉왕
-- [ep] 46
}

------------------------------------------------------------------------------------
								-- Add new faction --
------------------------------------------------------------------------------------

function sandbox:fix_faction_alias( faction_tk_key )

	local base = self.db_factions_base[ faction_tk_key ]
		
	if lib.is_in( faction_tk_key, {
			"3k_dlc06_faction_nanman_jiangyang",
			"3k_dlc06_faction_nanman_jianning",
			"3k_dlc06_faction_nanman_jiaozhi",
			"3k_dlc06_faction_nanman_yongchang",
			"3k_dlc06_faction_liaodong",
			"3k_dlc06_faction_nanman_yunnan",
			"3k_dlc06_faction_nanman_zangke",
		} )
	then
		self.db_factions_kr[ base.kr.."부족" ] = faction_tk_key
	end

	if lib.is_in( faction_tk_key, {
			"3k_dlc04_faction_prince_liu_chong",
			"3k_dlc04_faction_empress_he",
			"3k_dlc06_faction_nanman_lady_zhurong",
			"3k_dlc06_faction_nanman_king_mulu",
			"3k_dlc06_faction_nanman_king_wutugu",
			"3k_dlc06_faction_nanman_king_shamoke",
		} )
	then
		if faction_tk_key == "3k_dlc04_faction_prince_liu_chong" then
			self.db_factions_kr[ "유총" ] = faction_tk_key
			self.db_factions_kr[ "진왕유총" ] = faction_tk_key
			self.db_factions_kr[ "陳王劉寵" ] = faction_tk_key
			self.db_factions_kr[ "陈王刘宠" ] = faction_tk_key
		end

		if faction_tk_key == "3k_dlc04_faction_empress_he" then
			self.db_factions_kr[ "황실" ] = faction_tk_key
			self.db_factions_kr[ "한나라황실" ] = faction_tk_key
		end
		
		if faction_tk_key == "3k_dlc06_faction_nanman_lady_zhurong" then
			self.db_factions_kr[ "축융" ] = faction_tk_key
			self.db_factions_kr[ "축융부인" ] = faction_tk_key
		end

		if faction_tk_key == "3k_dlc06_faction_nanman_king_mulu" then
			self.db_factions_kr[ "목록" ] = faction_tk_key
			self.db_factions_kr[ "목록대왕" ] = faction_tk_key
		end

		if faction_tk_key == "3k_dlc06_faction_nanman_king_wutugu" then
			self.db_factions_kr[ "올돌골" ] = faction_tk_key
			self.db_factions_kr[ "올돌골대왕" ] = faction_tk_key
		end

		if faction_tk_key == "3k_dlc06_faction_nanman_king_shamoke" then
			self.db_factions_kr[ "사마가" ] = faction_tk_key
			self.db_factions_kr[ "사마가대왕" ] = faction_tk_key
		end
	end
end

function sandbox:add_faction_alias( row )

	local log_head = "sandbox:add_faction_alias"
	local faction_tk_key = row.faction_tk_key
	
	logger:verbose( log_head, row.kr, row )
	
	local prev_indent = logger:inc_indent()

	if lib.is_empty( row.en_key ) then
		logger:error( log_head, "en_key nilorempty", faction_tk_key, row )
		return
	end
	
	if not self.db_factions_kr[ row.en_key ] then
		self.db_factions_kr[ row.en_key ] = faction_tk_key
	else
		local dup_tk_key = self.db_factions_kr[ row.en_key ]
		
		logger:error( log_head, "en_key duplicate", 
				_to( row.en_key, dup_tk_key, faction_tk_key ),
				_to( "faction", self.db_factions[ dup_tk_key ][loc:get_locale()], row[loc:get_locale()] ),
				_to( "cqi", self.db_factions[ dup_tk_key ].cqi, row.cqi ) )
				
		if dup_tk_key:match( "_separatists$" ) then
			self.db_factions_kr[ row.en_key ] = faction_tk_key
		end
	end

	if row.kr and row.kr ~= row.en_key then
		if not self.db_factions_kr[ row.kr ] then
			self.db_factions_kr[ row.kr ] = faction_tk_key
		else
			logger:warn( log_head, "kr dup", _to( row.kr, self.db_factions_kr[ row.kr ], faction_tk_key ) )
		end
	end
	
	if row.cn and row.cn ~= row.kr then
		if not self.db_factions_kr[ row.cn ] then
			self.db_factions_kr[ row.cn ] = faction_tk_key
		else
			logger:warn( log_head, "cn dup", _to( row.cn, self.db_factions_kr[ row.cn ], faction_tk_key ) )
		end
	end

	if row.zh and row.zh ~= row.cn then
		if not self.db_factions_kr[ row.zh ] then
			self.db_factions_kr[ row.zh ] = faction_tk_key
		else
			logger:warn( log_head, "zh dup", _to( row.zh, self.db_factions_kr[ row.zh ], faction_tk_key ) )
		end
	end

	if row.en and row.en ~= row.en_key then
		local en_name = row.en:gsub( "%s", ""):lower()
		
		if not self.db_factions_kr[ en_name ] then
			self.db_factions_kr[ en_name ] = faction_tk_key
		end
	end

	logger:set_indent( prev_indent )
end

function sandbox:db_add_new_query_faction( query_faction, add_aliases )
	
	local log_head = "db_add_new_query_faction"
	
	local db_factions = self.db_factions
	local faction_tk_key = query_faction:name()
	local en_key = self:faction_en_key( faction_tk_key )
	local faction_kr = self:faction_loc_kr( query_faction ):gsub( "%s", "" ):lower()
	
	if not db_factions[ faction_tk_key ] then
		db_factions[ faction_tk_key ] = {}
		
		if faction_tk_key == "rebels" then
			logger:fatal( log_head, "rebels" )
		end
	elseif not en_key then
		logger:error( log_head, _eq( "faction_kr", self:faction_kr( query_faction )), "no en_key", faction_tk_key )
		return false
	else
		logger:error( log_head, _eq( "faction_kr", self:faction_kr( query_faction )), faction_tk_key, "duplicate faction_keys" )
		return false
	end

	db_factions[ faction_tk_key ].faction_tk_key = faction_tk_key
	db_factions[ faction_tk_key ].cqi = query_faction:command_queue_index()
	db_factions[ faction_tk_key ].is_dead = query_faction:is_dead()
	db_factions[ faction_tk_key ].en_key = en_key
				
	if self.db_factions_base[ faction_tk_key ] then
		local base = self.db_factions_base[ faction_tk_key ]

		db_factions[ faction_tk_key ].kr = base.kr:gsub("%s", "")
		db_factions[ faction_tk_key ].en = base.en:gsub("%s", ""):lower()
		db_factions[ faction_tk_key ].zh = base.zh
		db_factions[ faction_tk_key ].cn = base.cn

		db_factions[ faction_tk_key ].en_key = base.en_key
	elseif self.db_heroes_kr[ en_key ] then
		local template_key = self.db_heroes_kr[ en_key ]
		
		logger:info( "_i:1", log_head, "hero", _eq("faction_kr", faction_kr), _eq("en_key", en_key), faction_tk_key )
	
		db_factions[ faction_tk_key ].kr = self.db_heroes[ template_key ].kr:gsub( "%s", "" )
		db_factions[ faction_tk_key ].en = self.db_heroes[ template_key ].en:gsub( "%s", "" ):lower()
		db_factions[ faction_tk_key ].zh = self.db_heroes[ template_key ].zh
		db_factions[ faction_tk_key ].cn = self.db_heroes[ template_key ].cn
	else
		db_factions[ faction_tk_key ].kr = self:faction_kr( query_faction ):gsub("%s", "")
		db_factions[ faction_tk_key ].en = self:faction_kr( query_faction ):gsub("%s", ""):lower()
		db_factions[ faction_tk_key ].zh = self:faction_kr( query_faction )
		db_factions[ faction_tk_key ].cn = self:faction_kr( query_faction )
	end

	db_factions[ faction_tk_key ][loc:get_locale()] = faction_kr
	
	if add_aliases then
		logger:dev( "_i:1", log_head, faction_tk_key, _eq("faction_kr", faction_kr),
			_eq( "en_key", db_factions[ faction_tk_key ].en_key ), _eq( "cqi", db_factions[ faction_tk_key ].cqi ) )

		self:add_faction_alias( db_factions[ faction_tk_key ] )
		self:fix_faction_alias( faction_tk_key )
	end

	return db_factions[ faction_tk_key ].en_key, db_factions[ faction_tk_key ]
end

function sandbox:assign_faction_alias( db_kr, db_base, faction_tk_key )
	db_kr[ db_base.kr:gsub("%s", "") ] = faction_tk_key
	db_kr[ db_base.en:gsub("%s", "") ] = faction_tk_key
	db_kr[ db_base.cn ] = faction_tk_key
	db_kr[ db_base.zh ] = faction_tk_key
	db_kr[ db_base.en_key ] = faction_tk_key

	self:fix_faction_alias( faction_tk_key )
end

function sandbox:build_db_factions_base_kr()
	local log_head = "build_db_factions_base_kr"
	
	self.db_factions_base_kr = {}
	
	local c_factions = 0
	local faction_list = self.db_starting_factions[ self:current_dlc() ]
	
	for faction_tk_key, _ in pairs( faction_list ) do
		if self.db_factions_base[faction_tk_key] then
			self:assign_faction_alias( self.db_factions_base_kr, self.db_factions_base[faction_tk_key], faction_tk_key )
			c_factions = c_factions + 1
		else
			if __game_mode >= 0 then
				logger:info( log_head, faction_tk_key, "passed" )
			end
		end
	end
	
	for faction_tk_key, base in pairs( self.db_factions_base ) do
		local faction_kr = base.kr:gsub("%s", "")

		if not faction_list[ faction_tk_key ] then
			if not self.db_factions_base_kr[ faction_kr ] then
				self:assign_faction_alias( self.db_factions_base_kr, base, faction_tk_key )
				c_factions = c_factions + 1
			else
				if __game_mode >= 0 then
					logger:info( log_head, faction_tk_key, "skip" )
				end
			end
		end
 	end
	
	logger:info( log_head, _ee( "faction", c_factions ), _eq( "aliases", lib.table_rows(self.db_factions_base_kr) ) )
end
	------------------------------------------------------------------------------------
								 -- Build DB Factions --
	------------------------------------------------------------------------------------

function sandbox:build_db_factions()

	if self.mod_initialized then
		return
	end
	
	local log_head = "build_db_factions"
	local all_factions = sandbox:query_world():faction_list():filter(
		function( faction )
			return not faction:is_dead()
		end )

	local added_count = 0

	self.db_factions_kr = {}
	
	for i = 0, all_factions:num_items() - 1 do
		local query_faction = all_factions:item_at( i )
		local faction_tk_key = query_faction:name()

		--logger:out( self.db_factions_base[ faction_tk_key ].kr, faction_tk_key )
		
		if is_interface( query_faction ) then

			local en_key, row = self:db_add_new_query_faction( query_faction, true )

			--logger:out( log_head, "add", self:faction_kr(query_faction), en_key, faction_tk_key, _eq( "base", self.db_factions_base[ faction_tk_key ] ) )
			
			if en_key then
				added_count = added_count + 1
			else
				logger:error( log_head, "no en_key for faction", faction_tk_key )
			end
		end
	end

	self.db_factions['player'].faction_tk_key = self.local_faction_tk_key
	self.db_factions['player'].cqi = sandbox:query_faction(self.local_faction_tk_key):command_queue_index()

	--logger:inspect( "유비", sandbox.db_factions_kr[ "유비" ] )
	logger:info( log_head, string.format( "alias %d added %d", lib.table_rows(self.db_factions_kr), added_count ))
end
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

sandbox.db_traits_kr = {}
sandbox.db_trait_defaults = {}
sandbox.db_trait_sets = {}

sandbox.trait_disabilities =
{
	"3k_main_ceo_trait_physical_scarred",
	"3k_main_ceo_trait_physical_ill",
	"3k_main_ceo_trait_physical_poxxed",
	"3k_main_ceo_trait_physical_sickly",
	"3k_main_ceo_trait_physical_maimed_arm",
	"3k_main_ceo_trait_physical_one-eyed",
	"3k_main_ceo_trait_physical_maimed_leg",
	"3k_ytr_ceo_trait_physical_sprained_ankle",
}

sandbox.db_traits =
{ 
				['all'] = { en_key = "all", en = "all", kr = "모든", zh = "所有", cn = "所有", dlc = "tke", category = "personality" },
-- traits
             ['3k_main_ceo_trait_personality_aescetic'] = { en_key = "aescetic", en = "Ascetic", kr = "금욕적", zh = "有所節制", cn = "清心寡欲", dlc = "tke", category = "personality" },
            ['3k_main_ceo_trait_personality_ambitious'] = { en_key = "ambitious", en = "Ambitious", kr = "야심참", zh = "野心勃勃", cn = "雄心勃勃", dlc = "tke", category = "personality" },
             ['3k_main_ceo_trait_personality_arrogant'] = { en_key = "arrogant", en = "Arrogant", kr = "거만함", zh = "驕矜自大", cn = "骄横自大", dlc = "tke", category = "personality" },
               ['3k_main_ceo_trait_personality_artful'] = { en_key = "artful", en = "Artful", kr = "교묘함", zh = "精明老練", cn = "行事干练", dlc = "tke", category = "personality" },
                ['3k_main_ceo_trait_personality_brave'] = { en_key = "brave", en = "Brave", kr = "용감함", zh = "英勇無畏", cn = "英勇无畏", dlc = "tke", category = "personality" },
         ['3k_main_ceo_trait_personality_undiscovered'] = { en_key = "undiscovered", en = "Undiscovered Trait", kr = "발견되지 않은 특성", zh = "未發現的特性", cn = "未知特性", dlc = "main", category = "personality" },
            ['3k_main_ceo_trait_personality_brilliant'] = { en_key = "brilliant", en = "Brilliant", kr = "유능함", zh = "才華洋溢", cn = "天纵英才", dlc = "tke", category = "personality" },
             ['3k_main_ceo_trait_personality_careless'] = { en_key = "careless", en = "Careless", kr = "경솔함", zh = "粗枝大葉", cn = "粗心大意", dlc = "tke", category = "personality" },
             ['3k_main_ceo_trait_personality_cautious'] = { en_key = "cautious", en = "Cautious", kr = "조심스러움", zh = "謹慎小心", cn = "谨小慎微", dlc = "tke", category = "personality" },
          ['3k_main_ceo_trait_personality_charismatic'] = { en_key = "charismatic", en = "Charismatic", kr = "사람을 휘어잡는 매력", zh = "深得人心", cn = "富有魅力", dlc = "tke", category = "personality" },
           ['3k_main_ceo_trait_personality_charitable'] = { en_key = "charitable", en = "Charitable", kr = "너그러움", zh = "樂善好施", cn = "义结天下", dlc = "tke", category = "personality" },
               ['3k_main_ceo_trait_personality_clever'] = { en_key = "clever", en = "Clever", kr = "영리함", zh = "聰慧機敏", cn = "足智多谋", dlc = "tke", category = "personality" },
          ['3k_main_ceo_trait_personality_competative'] = { en_key = "competative", en = "Competitive", kr = "경쟁적임", zh = "逞勇好鬥", cn = "好勇斗狠", dlc = "tke", category = "personality" },
             ['3k_main_ceo_trait_personality_cowardly'] = { en_key = "cowardly", en = "Cowardly", kr = "겁쟁이", zh = "懦弱無膽", cn = "暗弱无断", dlc = "tke", category = "personality" },
                ['3k_main_ceo_trait_personality_cruel'] = { en_key = "cruel", en = "Cruel", kr = "잔혹함", zh = "殘酷不仁", cn = "残暴不仁", dlc = "tke", category = "personality" },
              ['3k_main_ceo_trait_personality_cunning'] = { en_key = "cunning", en = "Cunning", kr = "교활함", zh = "足智多謀", cn = "奇谋百出", dlc = "tke", category = "personality" },
            ['3k_main_ceo_trait_personality_deceitful'] = { en_key = "deceitful", en = "Deceitful", kr = "기만적", zh = "虛偽狡詐", cn = "奸佞狡猾", dlc = "tke", category = "personality" },
              ['3k_main_ceo_trait_personality_defiant'] = { en_key = "defiant", en = "Defiant", kr = "반항적", zh = "豪放不羈", cn = "桀骜不驯", dlc = "tke", category = "personality" },
           ['3k_main_ceo_trait_personality_determined'] = { en_key = "determined", en = "Determined", kr = "단호함", zh = "意志堅定", cn = "心若磐石", dlc = "tke", category = "personality" },
               ['3k_main_ceo_trait_personality_direct'] = { en_key = "direct", en = "Direct", kr = "직설적", zh = "直來直往", cn = "心直口快", dlc = "tke", category = "personality" },
          ['3k_main_ceo_trait_personality_disciplined'] = { en_key = "disciplined", en = "Disciplinarian", kr = "원칙주의자", zh = "嚴守紀律", cn = "令行禁止", dlc = "tke", category = "personality" },
             ['3k_main_ceo_trait_personality_disloyal'] = { en_key = "disloyal", en = "Disloyal", kr = "불충함", zh = "不忠不義", cn = "不臣之心", dlc = "tke", category = "personality" },
        ['3k_main_ceo_trait_personality_distinguished'] = { en_key = "distinguished", en = "Distinguished", kr = "특출남", zh = "聲名卓著", cn = "名满天下", dlc = "tke", category = "personality" },
              ['3k_main_ceo_trait_personality_dutiful'] = { en_key = "dutiful", en = "Dutiful", kr = "순종적", zh = "克盡職守", cn = "尽职尽责", dlc = "tke", category = "personality" },
              ['3k_main_ceo_trait_personality_elusive'] = { en_key = "elusive", en = "Elusive", kr = "종잡을 수 없음", zh = "閃閃躲躲", cn = "难以琢磨", dlc = "tke", category = "personality" },
            ['3k_main_ceo_trait_personality_energetic'] = { en_key = "energetic", en = "Energetic", kr = "활기참", zh = "精力充沛", cn = "斗志昂扬", dlc = "tke", category = "personality" },
            ['3k_main_ceo_trait_personality_enigmatic'] = { en_key = "enigmatic", en = "Enigmatic", kr = "불가사의함", zh = "莫測高深", cn = "高深莫测", dlc = "tke", category = "personality" },
                ['3k_main_ceo_trait_personality_fiery'] = { en_key = "fiery", en = "Fiery", kr = "맹렬함", zh = "暴躁易怒", cn = "性如烈火", dlc = "tke", category = "personality" },
            ['3k_main_ceo_trait_personality_fraternal'] = { en_key = "fraternal", en = "Fraternal", kr = "우애적", zh = "手足情深", cn = "手足之谊", dlc = "tke", category = "personality" },
               ['3k_main_ceo_trait_personality_greedy'] = { en_key = "greedy", en = "Greedy", kr = "탐욕스러움", zh = "貪婪無度", cn = "贪得无厌", dlc = "tke", category = "personality" },
           ['3k_main_ceo_trait_personality_honourable'] = { en_key = "honourable", en = "Honourable", kr = "명예로움", zh = "正直可敬", cn = "德昭之人", dlc = "tke", category = "personality" },
               ['3k_main_ceo_trait_personality_humble'] = { en_key = "humble", en = "Humble", kr = "겸손함", zh = "溫仁謙遜", cn = "谦恭有礼", dlc = "tke", category = "personality" },
          ['3k_main_ceo_trait_personality_incompetent'] = { en_key = "incompetent", en = "Incompetent", kr = "무능함", zh = "能力不足", cn = "力有不逮", dlc = "tke", category = "personality" },
           ['3k_main_ceo_trait_personality_indecisive'] = { en_key = "indecisive", en = "Indecisive", kr = "우유부단함", zh = "優柔寡斷", cn = "优柔寡断", dlc = "tke", category = "personality" },
         ['3k_main_ceo_trait_personality_intimidating'] = { en_key = "intimidating", en = "Intimidating", kr = "위협적", zh = "強勢威壓", cn = "咄咄逼人", dlc = "tke", category = "personality" },
                 ['3k_main_ceo_trait_personality_kind'] = { en_key = "kind", en = "Kind", kr = "친절함", zh = "慈悲為懷", cn = "与人为善", dlc = "tke", category = "personality" },
                ['3k_main_ceo_trait_personality_loyal'] = { en_key = "loyal", en = "Loyal", kr = "충직함", zh = "忠君報國", cn = "忠贞不二", dlc = "tke", category = "personality" },
               ['3k_main_ceo_trait_personality_modest'] = { en_key = "modest", en = "Modest", kr = "겸허함", zh = "溫文儒雅", cn = "温柔尔雅", dlc = "tke", category = "personality" },
             ['3k_main_ceo_trait_personality_pacifist'] = { en_key = "pacifist", en = "Pacifist", kr = "평화주의자", zh = "以和為貴", cn = "以和为贵", dlc = "tke", category = "personality" },
              ['3k_main_ceo_trait_personality_patient'] = { en_key = "patient", en = "Patient", kr = "인내심이 강함", zh = "富有耐心", cn = "不厌其烦", dlc = "tke", category = "personality" },
           ['3k_main_ceo_trait_personality_perceptive'] = { en_key = "perceptive", en = "Perceptive", kr = "통찰력 있음", zh = "洞燭機先", cn = "锐目如炬", dlc = "tke", category = "personality" },
                ['3k_main_ceo_trait_personality_quiet'] = { en_key = "quiet", en = "Quiet", kr = "조용함", zh = "靜如處子", cn = "气定神闲", dlc = "tke", category = "personality" },
             ['3k_main_ceo_trait_personality_reckless'] = { en_key = "reckless", en = "Reckless", kr = "무모함", zh = "魯莽躁進", cn = "鲁莽冒进", dlc = "tke", category = "personality" },
          ['3k_main_ceo_trait_personality_resourceful'] = { en_key = "resourceful", en = "Resourceful", kr = "재치있음", zh = "機智靈活", cn = "随机应变", dlc = "tke", category = "personality" },
            ['3k_main_ceo_trait_personality_scholarly'] = { en_key = "scholarly", en = "Scholarly", kr = "학구적", zh = "學富五車", cn = "笃信好学", dlc = "tke", category = "personality" },
              ['3k_main_ceo_trait_personality_sincere'] = { en_key = "sincere", en = "Sincere", kr = "진실됨", zh = "真摯誠懇", cn = "待人以诚", dlc = "tke", category = "personality" },
             ['3k_main_ceo_trait_personality_solitary'] = { en_key = "solitary", en = "Solitary", kr = "고립파", zh = "獨來獨往", cn = "形单影只", dlc = "tke", category = "personality" },
             ['3k_main_ceo_trait_personality_stubborn'] = { en_key = "stubborn", en = "Stubborn", kr = "고집스러움", zh = "頑固執拗", cn = "冥顽不灵", dlc = "tke", category = "personality" },
        ['3k_main_ceo_trait_personality_superstitious'] = { en_key = "superstitious", en = "Superstitious", kr = "미신을 믿음", zh = "迷信神鬼", cn = "笃信鬼神", dlc = "tke", category = "personality" },
           ['3k_main_ceo_trait_personality_suspicious'] = { en_key = "suspicious", en = "Suspicious", kr = "의심많은", zh = "疑神疑鬼", cn = "满腹狐疑", dlc = "tke", category = "personality" },
             ['3k_main_ceo_trait_personality_trusting'] = { en_key = "trusting", en = "Trusting", kr = "믿고보는", zh = "信任他人", cn = "言听计从", dlc = "tke", category = "personality" },
          ['3k_main_ceo_trait_personality_unobservant'] = { en_key = "unobservant", en = "Unobservant", kr = "부주의함", zh = "不善觀察", cn = "精神涣散", dlc = "tke", category = "personality" },
                 ['3k_main_ceo_trait_personality_vain'] = { en_key = "vain", en = "Vain", kr = "허영심", zh = "虛榮自負", cn = "骄矜自大", dlc = "tke", category = "personality" },
             ['3k_main_ceo_trait_personality_vengeful'] = { en_key = "vengeful", en = "Vengeful", kr = "복수심에 불탐", zh = "有仇必報", cn = "心胸狭隘", dlc = "tke", category = "personality" },
                   ['3k_main_ceo_trait_physical_agile'] = { en_key = "agile", en = "Agile", kr = "민첩함", zh = "矯健", cn = "身手敏捷", dlc = "tke", category = "personality" },
               ['3k_main_ceo_trait_physical_beautiful'] = { en_key = "beautiful", en = "Beautiful", kr = "아름다움", zh = "眉清目秀", cn = "俊逸清秀", dlc = "tke", category = "personality" },
                   ['3k_main_ceo_trait_physical_blind'] = { en_key = "blind", en = "Blind", kr = "맹인", zh = "失明", cn = "双目俱眇", dlc = "tke", category = "personality" },
                  ['3k_main_ceo_trait_physical_clumsy'] = { en_key = "clumsy", en = "Clumsy", kr = "어설픔", zh = "愚魯笨拙", cn = "愚钝笨拙", dlc = "tke", category = "personality" },
             ['3k_main_ceo_trait_physical_coordinated'] = { en_key = "coordinated", en = "Co-ordinated", kr = "조직적", zh = "協調性佳", cn = "身手协调", dlc = "tke", category = "personality" },
                ['3k_main_ceo_trait_physical_decrepit'] = { en_key = "decrepit", en = "Decrepit", kr = "노쇠함", zh = "年邁體衰", cn = "老骥伏枥", dlc = "tke", category = "personality" },
                   ['3k_main_ceo_trait_physical_drunk'] = { en_key = "drunk", en = "Drunk", kr = "주정꾼", zh = "貪杯", cn = "高卧醉乡", dlc = "tke", category = "personality" },
                  ['3k_main_ceo_trait_physical_eunuch'] = { en_key = "eunuch", en = "Eunuch", kr = "환관", zh = "閹人", cn = "已行阉割", dlc = "tke", category = "personality" },
                     ['3k_main_ceo_trait_physical_fat'] = { en_key = "fat", en = "Fat", kr = "뚱뚱함", zh = "豐腴", cn = "大腹便便", dlc = "tke", category = "personality" },
                 ['3k_main_ceo_trait_physical_fertile'] = { en_key = "fertile", en = "Fertile", kr = "정력가", zh = "兒孫滿堂", cn = "朝云暮雨", dlc = "tke", category = "personality" },
                ['3k_main_ceo_trait_physical_graceful'] = { en_key = "graceful", en = "Graceful", kr = "우아함", zh = "優雅體面", cn = "身形俊秀", dlc = "tke", category = "personality" },
                ['3k_main_ceo_trait_physical_handsome'] = { en_key = "handsome", en = "Handsome", kr = "잘생김", zh = "英俊瀟灑", cn = "姿容焕发", dlc = "tke", category = "personality" },
                 ['3k_main_ceo_trait_physical_healthy'] = { en_key = "healthy", en = "Healthy", kr = "건강함", zh = "身輕體健", cn = "生龙活虎", dlc = "tke", category = "personality" },
             ['3k_main_ceo_trait_physical_heartbroken'] = { en_key = "heartbroken", en = "Heartbroken", kr = "상심함", zh = "心碎", cn = "悲痛欲绝", dlc = "tke", category = "personality" },
                     ['3k_main_ceo_trait_physical_ill'] = { en_key = "ill", en = "Physically Ill", kr = "육체적으로 아픔", zh = "體弱", cn = "疴疾缠身", dlc = "tke", category = "personality" },
               ['3k_main_ceo_trait_physical_infertile'] = { en_key = "infertile", en = "Infertile", kr = "불임", zh = "無後", cn = "萎靡不举", dlc = "tke", category = "personality" },
              ['3k_main_ceo_trait_physical_lovestruck'] = { en_key = "lovestruck", en = "Lovestruck", kr = "상사병", zh = "情癡", cn = "热恋不已", dlc = "tke", category = "personality" },
               ['3k_main_ceo_trait_physical_lumbering'] = { en_key = "lumbering", en = "Lumbering", kr = "느림보", zh = "笨重", cn = "笨手笨脚", dlc = "tke", category = "personality" },
                     ['3k_main_ceo_trait_physical_mad'] = { en_key = "mad", en = "Mad", kr = "광기", zh = "瘋狂", cn = "疯疯癫癫", dlc = "tke", category = "personality" },
              ['3k_main_ceo_trait_physical_maimed_arm'] = { en_key = "maimed_arm", en = "Maimed", kr = "불구", zh = "傷殘", cn = "身体残疾", dlc = "tke", category = "physical" },
              ['3k_main_ceo_trait_physical_maimed_leg'] = { en_key = "maimed_leg", en = "Lame", kr = "절름발이", zh = "瘸腿", cn = "痛失一足", dlc = "tke", category = "physical" },
                ['3k_main_ceo_trait_physical_one-eyed'] = { en_key = "one-eyed", en = "One-eyed", kr = "애꾸눈", zh = "獨眼", cn = "一目已眇", dlc = "tke", category = "physical" },
                  ['3k_main_ceo_trait_physical_poxxed'] = { en_key = "poxxed", en = "Poxed", kr = "매독", zh = "膿泡纏身", cn = "身染风癞", dlc = "tke", category = "physical" },
                 ['3k_main_ceo_trait_physical_scarred'] = { en_key = "scarred", en = "Scarred", kr = "흉터를 가짐", zh = "傷疤", cn = "遍体鳞伤", dlc = "tke", category = "physical" },
       ['3k_main_ceo_trait_physical_shu_tiger_general'] = { en_key = "shu_tiger_general", en = "Tiger General", kr = "호위장군", zh = "五虎將", cn = "五虎上将", dlc = "tke", category = "personality" },
                  ['3k_main_ceo_trait_physical_sickly'] = { en_key = "sickly", en = "Sickly", kr = "병약함", zh = "多病", cn = "体弱多病", dlc = "tke", category = "personality" },
                  ['3k_main_ceo_trait_physical_strong'] = { en_key = "strong", en = "Strong", kr = "강한 힘", zh = "身強體壯", cn = "身强体壮", dlc = "tke", category = "personality" },
              ['3k_main_ceo_trait_physical_sui_knight'] = { en_key = "sui_knight", en = "Sui Knight", kr = "수하팔부", zh = "韓遂部將", cn = "韩遂虎骑", dlc = "tke", category = "personality" },
                   ['3k_main_ceo_trait_physical_tough'] = { en_key = "tough", en = "Tough", kr = "억셈", zh = "頑強", cn = "顽强不屈", dlc = "tke", category = "personality" },
                    ['3k_main_ceo_trait_physical_weak'] = { en_key = "weak", en = "Weak", kr = "약골", zh = "弱不禁風", cn = "弱不禁风", dlc = "tke", category = "personality" },
       ['3k_main_ceo_trait_physical_wei_elite_general'] = { en_key = "wei_elite_general", en = "Elite General", kr = "유능한 장군", zh = "五子良將", cn = "五子良将", dlc = "tke", category = "personality" },
            ['3k_ytr_ceo_trait_personality_benevolent'] = { en_key = "benevolent", en = "Gracious", kr = "자애로움", zh = "高尚情操", cn = "品行高尚", dlc = "ytr", category = "personality" },
        ['3k_ytr_ceo_trait_personality_gentle_hearted'] = { en_key = "gentle_hearted", en = "Kind-hearted", kr = "온화함", zh = "心地善良", cn = "仁者爱人", dlc = "ytr", category = "personality" },
         ['3k_ytr_ceo_trait_personality_heaven_bright'] = { en_key = "heaven_bright", en = "Bright", kr = "명료함", zh = "精明靈巧", cn = "识明智审", dlc = "ytr", category = "personality" },
       ['3k_ytr_ceo_trait_personality_heaven_creative'] = { en_key = "heaven_creative", en = "Creative", kr = "창의적임", zh = "富有創意", cn = "思维创新", dlc = "ytr", category = "personality" },
         ['3k_ytr_ceo_trait_personality_heaven_honest'] = { en_key = "heaven_honest", en = "Honest", kr = "정직함", zh = "誠實正直", cn = "坦诚相待", dlc = "ytr", category = "personality" },
       ['3k_ytr_ceo_trait_personality_heaven_selfless'] = { en_key = "heaven_selfless", en = "Selfless", kr = "이타적임", zh = "無私奉獻", cn = "不存私心", dlc = "ytr", category = "personality" },
       ['3k_ytr_ceo_trait_personality_heaven_tolerant'] = { en_key = "heaven_tolerant", en = "Tolerant", kr = "관대함", zh = "寬大忍讓", cn = "宽大为怀", dlc = "ytr", category = "personality" },
       ['3k_ytr_ceo_trait_personality_heaven_tranquil'] = { en_key = "heaven_tranquil", en = "Tranquil", kr = "차분함", zh = "明鏡止水", cn = "宁静致远", dlc = "ytr", category = "personality" },
           ['3k_ytr_ceo_trait_personality_heaven_wise'] = { en_key = "heaven_wise", en = "Wise", kr = "현명함", zh = "英明睿智", cn = "睿智人杰", dlc = "ytr", category = "personality" },
            ['3k_ytr_ceo_trait_personality_land_alert'] = { en_key = "land_alert", en = "Vigilant", kr = "방심하지 않음", zh = "戒心十足", cn = "抱持戒心", dlc = "ytr", category = "personality" },
         ['3k_ytr_ceo_trait_personality_land_aspiring'] = { en_key = "land_aspiring", en = "Committed", kr = "열성적", zh = "認真投入", cn = "尽心尽力", dlc = "ytr", category = "personality" },
         ['3k_ytr_ceo_trait_personality_land_composed'] = { en_key = "land_composed", en = "Composed", kr = "침착함", zh = "理性冷靜", cn = "沉着冷静", dlc = "ytr", category = "personality" },
       ['3k_ytr_ceo_trait_personality_land_courageous'] = { en_key = "land_courageous", en = "Intrepid", kr = "용맹함", zh = "勇敢無畏", cn = "勇字当先", dlc = "ytr", category = "personality" },
         ['3k_ytr_ceo_trait_personality_land_generous'] = { en_key = "land_generous", en = "Philanthropic", kr = "인자함", zh = "慷慨大方", cn = "乐善好施", dlc = "ytr", category = "personality" },
         ['3k_ytr_ceo_trait_personality_land_powerful'] = { en_key = "land_powerful", en = "Formidable", kr = "강인함", zh = "武藝懾人", cn = "令人敬畏", dlc = "ytr", category = "personality" },
            ['3k_ytr_ceo_trait_personality_land_proud'] = { en_key = "land_proud", en = "Fulfilled", kr = "자긍심 있음", zh = "知足常樂", cn = "知足常乐", dlc = "ytr", category = "personality" },
        ['3k_ytr_ceo_trait_personality_people_amiable'] = { en_key = "people_amiable", en = "Cordial", kr = "상냥함", zh = "和藹可親", cn = "慈眉善目", dlc = "ytr", category = "personality" },
       ['3k_ytr_ceo_trait_personality_people_cheerful'] = { en_key = "people_cheerful", en = "Cheerful", kr = "쾌활함", zh = "樂觀進取", cn = "爽朗活泼", dlc = "ytr", category = "personality" },
  ['3k_ytr_ceo_trait_personality_people_compassionate'] = { en_key = "people_compassionate", en = "Concerned", kr = "동정적임", zh = "關懷他人", cn = "关怀备至", dlc = "ytr", category = "personality" },
       ['3k_ytr_ceo_trait_personality_people_friendly'] = { en_key = "people_friendly", en = "Friendly", kr = "우호적", zh = "友善和氣", cn = "以善待人", dlc = "ytr", category = "personality" },
 ['3k_ytr_ceo_trait_personality_people_people_pleaser'] = { en_key = "people_people_pleaser", en = "Populist", kr = "대중적임", zh = "討好百姓", cn = "深得民心", dlc = "ytr", category = "personality" },
          ['3k_ytr_ceo_trait_personality_people_stern'] = { en_key = "people_stern", en = "Stern", kr = "엄격함", zh = "堅定固執", cn = "严厉专横", dlc = "ytr", category = "personality" },
  ['3k_ytr_ceo_trait_personality_people_understanding'] = { en_key = "people_understanding", en = "Understanding", kr = "이해심", zh = "將心比心", cn = "深谙人情", dlc = "ytr", category = "personality" },
            ['3k_ytr_ceo_trait_personality_relentless'] = { en_key = "relentless", en = "Relentless", kr = "집요함", zh = "堅持不懈", cn = "不屈不挠", dlc = "ytr", category = "personality" },
                ['3k_ytr_ceo_trait_personality_simple'] = { en_key = "simple", en = "Uncomplicated", kr = "단순함", zh = "頭腦簡單", cn = "智虑单纯", dlc = "ytr", category = "personality" },
              ['3k_ytr_ceo_trait_personality_stalwart'] = { en_key = "stalwart", en = "Stalwart", kr = "신념이 굳셈", zh = "忠實可靠", cn = "坚贞善友", dlc = "ytr", category = "personality" },
         ['3k_ytr_ceo_trait_personality_strong_willed'] = { en_key = "strong_willed", en = "Obstinate", kr = "완강함", zh = "頑固不屈", cn = "执拗固执", dlc = "ytr", category = "personality" },
         ['3k_ytr_ceo_trait_personality_temperamental'] = { en_key = "temperamental", en = "Temperamental", kr = "변덕스러움", zh = "陰晴不定", cn = "反复无常", dlc = "ytr", category = "personality" },
           ['3k_ytr_ceo_trait_personality_trustworthy'] = { en_key = "trustworthy", en = "Trustworthy", kr = "믿음직함", zh = "值得信任", cn = "守义堪信", dlc = "ytr", category = "personality" },
            ['3k_ytr_ceo_trait_personality_vindictive'] = { en_key = "vindictive", en = "Spiteful", kr = "앙심을 품음", zh = "睚眥必報", cn = "藏怒宿怨", dlc = "ytr", category = "personality" },
                   ['3k_ytr_ceo_trait_physical_feared'] = { en_key = "feared", en = "Feared", kr = "두려움", zh = "令人恐懼", cn = "布惧四方", dlc = "ytr", category = "personality" },
         ['3k_ytr_ceo_trait_physical_healer_of_people'] = { en_key = "healer_of_people", en = "Healer of People", kr = "백성의 치유사", zh = "療癒百姓", cn = "民之医士", dlc = "ytr", category = "personality" },
               ['3k_ytr_ceo_trait_physical_impeccable'] = { en_key = "impeccable", en = "Impeccable", kr = "무결성", zh = "追求完美", cn = "无可挑剔", dlc = "ytr", category = "personality" },
         ['3k_ytr_ceo_trait_physical_leader_of_people'] = { en_key = "leader_of_people", en = "Leader of People", kr = "백성의 군주", zh = "百姓領袖", cn = "民之统帅", dlc = "ytr", category = "personality" },
      ['3k_ytr_ceo_trait_physical_protector_of_people'] = { en_key = "protector_of_people", en = "Protector of People", kr = "백성의 수호자", zh = "保衛人民", cn = "民之护卫", dlc = "ytr", category = "physical" },
           ['3k_ytr_ceo_trait_physical_sprained_ankle'] = { en_key = "sprained_ankle", en = "Limp", kr = "절둑거림", zh = "跛腳", cn = "脚踝扭伤", dlc = "ytr", category = "physical" },
                    ['3k_ytr_ceo_trait_physical_wound'] = { en_key = "wound", en = "Healed", kr = "치유된 자", zh = "傷口痊癒", cn = "伤口痊愈", dlc = "ytr", category = "physical" },
          ['3k_ytr_ceo_trait_physical_wound_festering'] = { en_key = "wound_festering", en = "Festering Wound", kr = "곪은 상처", zh = "傷口潰爛", cn = "伤口溃烂", dlc = "ytr", category = "physical" },
              ['3k_ytr_ceo_trait_physical_wound_wound'] = { en_key = "wound_wound", en = "Battle Wound", kr = "전투의 상처", zh = "戰場負傷", cn = "历战之创", dlc = "ytr", category = "physical" },
       ['3k_dlc06_ceo_trait_personality_animal_friend'] = { en_key = "animal_friend", en = "Animal Friend", kr = "동물의 친구", zh = "與獸為友", cn = "动物之友", dlc = "fw", category = "personality" },
           ['3k_dlc07_ceo_trait_personality_frivolous'] = { en_key = "frivolous", en = "Frivolous", kr = "경박함", zh = "輕浮", cn = "谩不经意", dlc = "fd", category = "personality" },
           ['hlyjdingzhiatexing'] = { en_key = "mara", en = "Mara", kr = "마각", zh = "魔陰身", cn = "魔阴身", dlc = "xyy", category = "personality" },
-- traits 126
};

function sandbox:get_trait_set( alias )
	if self.db_trait_sets[ alias ] then
		return self.db_trait_sets[ alias ]
	end
end

function sandbox:set_trait_set( alias, trait_set )
	--if self:db_trait_sets[ alias ] then
	--end
	self.db_trait_sets[ alias ] = trait_set
	
	return self.db_trait_sets[ alias ]
end

function sandbox:get_default_trait_set( query_character )

	local template_key = query_character:generation_template_key()
	local row = self.db_heroes[ template_key ]
	
	if row then
		if self.db_trait_defaults[ template_key ] then
			return self.db_trait_sets[ self.db_trait_defaults[ template_key ] ]
		end

		if self.db_trait_sets[ row[loc:get_locale()] ] then
			return self.db_trait_sets[ row[loc:get_locale()] ]
		end
	end
end

function sandbox:out_trait_set_list( locale  )

	for trait_set, trait_set in pairs( self.db_trait_sets ) do
		local set_text = trait_set
		
		for _, ceo_alias in pairs( trait_set ) do
			if self.db_traits_kr[ ceo_alias ] then
				local ceo_key = self.db_traits_kr[ ceo_alias ]
				set_text = set_text ..", ".. self.db_traits[ ceo_key ][ locale ]
			else
				set_text = set_text ..", ["..ceo_alias.."]"
			end
		end
		
		logger( set_text )
	end
end

	------------------------------------------------------------------------------------
								-- Trait DB Handling --
	------------------------------------------------------------------------------------

function sandbox:build_traits_aliases()

	self.db_traits_kr = {};
	self.db_trait_sets = {}
	self.db_trait_defaults = {}
	
	local log_head = "build_traits_aliases"
	local count = 0
	for ceo_key, row in pairs( self.db_traits ) do

		if ceo_key ~= "all" then
			local trait_en = string.gsub( row.en, "%s", "" ):lower()

			if not self.db_traits_kr[ trait_en ] then
				self.db_traits_kr[ trait_en ] = ceo_key
			else
				logger:warn( log_head, "en", self.db_traits_kr[ trait_en ], "DUP", ceo_key, trait_en )
			end
		
			local trait_kr = string.gsub( row.kr, "%s", "" )
			
			if not self.db_traits_kr[ trait_kr ] then
				self.db_traits_kr[ trait_kr ] = ceo_key;
			else
				logger:warn( log_head, "kr", self.db_traits_kr[ trait_kr ], "DUP", ceo_key, trait_kr );
			end

			local trait_zh = string.gsub( row.zh, " ", "" );
			if not self.db_traits_kr[ trait_zh ] then
				self.db_traits_kr[ trait_zh ] = ceo_key;
			else
				logger:warn( log_head, "zh", self.db_traits_kr[ trait_zh ], "DUP", ceo_key, trait_zh );
			end

			local trait_cn = string.gsub( row.cn, " ", "" );
			if not self.db_traits_kr[ trait_cn ] then
				self.db_traits_kr[ trait_cn ] = ceo_key;
			else
				logger:warn( log_head, "cn", self.db_traits_kr[ trait_cn ], "DUP", ceo_key, trait_cn );
			end
			
			self.db_traits_kr[ row.en_key ] = ceo_key
			
			count = count + 1
		end
	end
	
	--[[
	scarred,       "흉터를 가짐",		3k_main_ceo_trait_physical_scarred
	ill,		   "육체적으로 아픔",	3k_main_ceo_trait_physical_ill,
	poxxxed,	   "매독",			3k_main_ceo_trait_physical_poxxed,
	sickly,        "병약함",			3k_main_ceo_trait_physical_sickly,
	maimed_arm,    "불구",			3k_main_ceo_trait_physical_maimed_arm,
	one-eyed,      "애꾸눈",			3k_main_ceo_trait_physical_one-eyed,
	maimed_leg,    "절름발이",			3k_main_ceo_trait_physical_maimed_leg,
	sprained_ankle,"절름발이",			3k_ytr_ceo_trait_physical_sprained_ankle,

	[겸허함]              modest	-	humble			겸손함
	[믿고보는]          trusting	-	trustworthy		믿음직함
	[경솔함]            careless	-	unobservant		부주의함
	[명료함]       heaven_bright	-	clever			영리함
	[자애로움]			benevolent	-	graceful		우아함
	[온화함]      gentle_hearted	-	kind            친절함
	[쾌활함]     people_cheerful	-	energetic       활기참
	[절둑거림]    sprained_ankle	-	maimed_leg      절름발이
	[Limp]      sprained_ankle	-	maimed_leg      Lame
	[脚踝扭伤]    sprained_ankle	-	maimed_leg      痛失一足
	[慷慨大方]	 land_generous	-	charitable		樂善好施
		
	self.db_traits_kr[ "겸허함" ] = self.db_traits_kr[ 'modest' ];
	self.db_traits_kr[ "믿고보는" ] = self.db_traits_kr[ 'trusting' ];
	self.db_traits_kr[ "경솔함" ] = self.db_traits_kr[ 'careless' ];
	self.db_traits_kr[ "명료함" ] = self.db_traits_kr[ 'heaven_bright' ];
	self.db_traits_kr[ "자애로움" ] = self.db_traits_kr[ 'benevolent' ];
	self.db_traits_kr[ "절둑거림" ] = self.db_traits_kr[ 'sprained_ankle' ];
	self.db_traits_kr[ "온화함" ] = self.db_traits_kr[ 'gentle_hearted' ];
	self.db_traits_kr[ "쾌활함" ] = self.db_traits_kr[ 'people_cheerful' ];
	self.db_traits_kr[ "慷慨大方" ] = self.db_traits_kr[ 'land_generous' ];
	]]--

	self.db_traits_kr['one_eyed'] = self.db_traits_kr['one-eyed']
	self.db_traits_kr['뛰어남'] = self.db_traits_kr['brilliant']
	self.db_traits_kr['수상함'] = self.db_traits_kr['suspicious']
	
	logger:info( log_head, count )
end

-----------------------------------------------------------------------------------------
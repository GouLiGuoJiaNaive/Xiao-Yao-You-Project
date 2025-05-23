local command_loc_descriptions = require( "console.console_help_loc_descriptions" )

local command_help_entries = {

	-- ################################################################# --

	['Sandbox Notice'] = {
		title = "Sandbox Notice",
		brief = {
			['kr'] = "샌드박스 공지 사항",
			['en'] = "Sandbox Notice.",
			['zh'] = "注意。",
			['cn'] = "注意。",
		},
		examples = {
			{
				usages = {
					['kr'] = "영웅들 나이 수정 안됩니다",
					['en'] = "The age of heroes cannot be changed",
					['zh'] = "英雄年齡是無法改變的",
					['cn'] = "英雄年龄是无法改变的",
				},
				descriptions = {},
			},
			{
				usages = {
					['kr'] = "남만 영웅들은 새롭게 '스폰' 안됩니다.",
					['en'] = "Nanman heroes cannot be 'spawned' anew.",
					['zh'] = "南蠻英雄不能重新“spawn”。。",
					['cn'] = "南蛮英雄不能重新“spawn”。",
				},
				descriptions = {
					['kr'] = "맵에 없는 남만 영웅을 스폰하면 그래픽이 깨집니다. 존재하는 남만 장수의 세력 이동은 가능합니다.",
					['en'] = "Spawning a Nanman hero that is not on the map will break the graphics. It is possible to transfer existing Nanman heroes to other faction.",
					['zh'] = "生成不在地圖上的南蠻英雄會破壞圖形。 可以將現有的南蠻英雄轉移到其他派係。",
					['cn'] = "生成不在地图上的南蛮英雄会破坏图形。 可以将现有的南蛮英雄转移到其他派係。",
				},
			},
			{
				usages = {
					['kr'] = "황건적 영웅은 황건적 세력 소속이어야 정상입니다.",
					['en'] = "When you summon a Yellow Turban hero to other sub-culture faction, that hero's skill tree disappears.",
					['zh'] = "黃巾武將必屬黃巾派係。",
					['cn'] = "黄巾武将必属黄巾派系。",
				},
				descriptions = {
					['kr'] = "황건적 영웅이 타 문화권(한문화,남만,도적 등) 소속이 되면 '스킬 트리'가 사라지거나 깨집니다.",
					['en'] = "When you summon a Yellow Turban hero to other sub-culture faction, that hero's skill tree disappears.",
					['zh'] = "召喚一個黃巾武將到其他派係時，該武將技能樹將消失不見。",
					['cn'] = "召唤一个黄巾武将到其他派系时，该武将技能树将消失不见。",
				},
			},
			{
				usages = {
					['kr'] = "미출생 미성년 영웅을 18세로 소환하려면 <샌드박스 나이 팩>을 사용하십시오.",
					['en'] = "Use the <Sandbox Spawn Age Pack> to summon an unborn underage hero to age 18.",
					['zh'] = "使用 <Sandbox Spawn Age Pack> 將未出生的未成年英雄召喚至 18 歲。",
					['cn'] = "使用 <Sandbox Spawn Age Pack> 将未出生的未成年英雄召唤至 18 岁。",
				},
				descriptions = {
					['kr'] = "스팀 샌드박스 모드 페이지의 '공지'를 보시면 나이 팩 다운로드 링크가 있습니다.",
					['en'] = "See 'Sandbox Steam page : Notice'. A link of the sandbox spawn age pack is there.",
					['zh'] = "請參閱“沙盒 Steam 頁面：通知”。",
					['cn'] = "请参阅“沙盒 Steam 页面：通知”。",
				},
			},
			{
				usages = {
					['kr'] = "샌드박스 UI에 문제가 발생하면 샌드박스 스팀 가이드의 최하단에 있는 '주의 사항'을 참고하십시오.",
					['en'] = "If you are having a sandbox UI problem, see the 'Precaution' section of the Sandbox Steam Guide.",
					['zh'] = "如果你遇到“沙盒”UI問題, 請參詳 Steam guide 'Precaution' 部分。",
					['cn'] = "如果你遇到“沙盒”UI问题, 请参详 Steam guide 'Precaution' 部分。",
				},
				descriptions = {
					['kr'] = "'옵션 - 인터페이스 - UI 크기 100%'가 기본입니다. UI 튕김과 랙을 줄여줍니다.",
					['en'] = "Set 'Options - Interface - UI size 100%' to avoid CTD and campaign lag.",
					['zh'] = "請設置“選項-界面-自定UI比例：100%”。",
					['cn'] = "请设置“选项-界面-自定UI比例：100%”。",
				},
			},
		},
		descriptions = command_loc_descriptions['sandbox_notice'],
	},
	['Update Notes'] = {
		title = "Update Notes",
		brief = {
			['kr'] = "최근 업데이트 노트",
			['en'] = "Recent update notes.",
			['zh'] = "最近更新說明。",
			['cn'] = "最近更新说明。",
		},
		examples = {
			{
				usages = {
					['kr'] = "2.3.5 - 로그 뷰어 기능",
					['en'] = "2.3.5 - Log Viewer feature",
					['zh'] = "2.3.5 - 日誌 查看",
					['cn'] = "2.3.5 - 日志 查看",
				},
				descriptions = {
					['kr'] = "명령 후에 '로그' 버튼을 크릭하십시오. 'inspect' 와 'heroes' 명령으로 자동으로 로그 뷰어가 작동하기도 합니다.",
					['en'] = "Click 'Log' button after a command. Some command opens Log View automatically.",
					['zh'] = "命令後單擊“日誌”按鈕。",
					['cn'] = "命令后单击“日志”按钮。",
				},
			},
			{
				usages = {
					['kr'] = "2.3.4 - 명령 도움말 : 103개의 명령 도움말 기능",
					['en'] = "2.3.4 - Help panel : helps for 103 commands",
					['zh'] = "2.3.4 - Help 面板：103 個命令的幫助。",
					['cn'] = "2.3.4 - Help 面板：103 个命令的帮助。",
				},
				descriptions = {
					['kr'] = "give_item, give_set 등의 옵션 순서가 바뀌었습니다.",
					['en'] = "The parameter's order has changed. 'give_item', 'give_set' and etc.",
					['zh'] = "參數的順序已更改。 'give_item', 'give_set' 等。參考遊戲內幫助。",
					['cn'] = "参数的顺序已更改。 'give_item', 'give_set' 等。参考游戏内帮助。",
				},
			},
			{
				usages = {
					['kr'] = "2.3.3 - 카메라 북마크 보기 11 단축키",
					['en'] = "2.3.4 - Uses 'View Camera bookmark 11' shortcut key",
					['zh'] = "2.3.4 - 使用“查看十一號”快捷方式切換到UI",
					['cn'] = "2.3.4 - 使用“查看十一號”快捷方式切換到UI",
				},
				descriptions = {
					['kr'] = "단축키로 샌드박스 입력창을 켜고/끄기 가능하고, '조정'이나 '외교' 패널에서도 사용 가능합니다.",
					['en'] = "Use 'View Camera bookmark 11' shortcut to switch to the sandbox console even in the 'family court' or 'diplomacy' panel.",
				},
			},
			{
				usages = {
					['kr'] = "2.3.2 - 명령 저장 파일 및 명령어 리스트 패널 추가",
					['en'] = "2.3.2 - Command histories and files panel",
					['zh'] = "2.3.2 - 命令歷史記錄和文件面板",
					['cn'] = "2.3.2 - 命令历史记录和文件面板",
				},
				descriptions = {
					['kr'] = "'save', 'load', 'top' 과 'bottom' 등의 명령어 삭제 및 기타 명령어 조정되었습니다. 샌드박스 UI를 스크립트가 아닌 수천라인의 XML로 변환했습니다.",
					['en'] = "Removed commands such as 'save', 'load', 'top' and 'bottom' and adjusted other commands. Transformed the sandbox UI into thousands of lines of XML rather than scripts.",
				},
			},
		},
		descriptions = command_loc_descriptions['update_notes'],
	},
	
	-- ################################################################# --

	['clones'] = {
		brief = {
			['kr'] = "클론은 엔진에 의해 자동생성된 장수들로서, 세력에 가담할 수 있는 가상의 영웅들과 정작지 방어군, 반란군 등이 있습니다.",
			['en'] = "Clones are generals auto-generated by the engine, and there are fictional heroes who can join factions, castellans, rebels.",
			['zh'] = "Clones 是由引擎自動生成的將軍，還有可以加入派系、駐軍、叛軍的虛構英雄。",
			['cn'] = "Clones 是由引擎自动生成的将军，还有可以加入派系、驻军、叛军的虚构英雄。",
		},
		examples = {
			{
				usages = {
					['en'] = "clones",
				},
				descriptions = {
					['kr'] = "현재 캠페인에 존재하는 영웅들과 클론들의 숫자를 알려줍니다.",
					['en'] = "Shows the number of heroes and clones in the current campaign.",
					['zh'] = "顯示當前戰役中英雄和克隆人的數量。",
					['cn'] = "显示当前战役中英雄和克隆人的数量。",
				}
			},
			{
				usages = {
					['kr'] = "clones, 세력",
					['en'] = "clones, faction",
					['zh'] = "clones, 派系",
					['cn'] = "clones, 派系",
				},
				descriptions = {
					['kr'] = "지정한 이름을 가진 세력의 클론 상태를 로그로 출력합니다",
					['en'] = "Shows the clone statistics of the specified faction.",
					['zh'] = "顯示指定派系的克隆統計數據。",
					['cn'] = "显示指定派系的克隆统计数据。",
				}
			},
			{
				usages = {
					['en'] = "clones, 1",
				},
				descriptions = {
					['kr'] = "지정한 번호의 세력의 클론 상태를 로그로 출력합니다. 반란군의 세력 번호는 1번입니다",
					['en'] = "Shows the clone statistics of the specified faction as a log. The rebel's faction CQI is 1.",
					['zh'] = "將指定派系的克隆統計信息顯示為日誌。 叛軍的派系 CQI 為 1。",
					['cn'] = "将指定派系的克隆统计信息显示为日志。 叛军的派系 CQI 为 1。",
				}
			},
		},
	},
	['emergent'] = {
		brief = {
			['kr'] = "세력 봉기란 하나 이상의 '정착지'에 특정 장수를 세력 지도자로 지정하고, 지정된 구성원들을 세력에 소환한 후, 1개의 군대를 맵에 등장시키는 명령입니다.",
			['en'] = "The 'emergent' is a command to designate a general as a faction leader in one or more 'settlement', summon the specified heroes to the faction, and then place one army on the map.",
			['zh'] = "“emergent”是在一個或多個“定居點”中指定一名將軍作為派系領袖，將指定的英雄召喚到派系，然後在地圖上放置一支軍隊的命令。",
			['cn'] = "“emergent”是在一个或多个“定居点”中指定一名将军作为派系领袖，将指定的英雄召唤到派系，然后在地图上放置一支军队的命令。",
		},
		examples = {
			{
				usages = {
					['en'] = "emergent, settlement(, ...), hero(, ...)",
					['kr'] = "emergent, 지역(, ...), 영웅(, ...)",
					['zh'] = "emergent, 城鎮(, ...), 英雄(, ...)",
					['cn'] = "emergent, 城镇(, ...), 英雄(, ...)",
				},
				descriptions = {
					['kr'] = "지정한 정착지들에 지정한 영웅들로 구성된 세력이 봉기합니다. 지역과 영웅은 복수로 지정될 수 있습니다.",
					['en'] = "An army made up of specified heroes rises up in given settlements. Settlements and heroes can be assigned plural.",
					['zh'] = "一支由指定英雄組成的軍隊在指定的定城鎮崛起。定城鎮和英雄可以指定為複數。",
					['cn'] = "一支由指定英雄组成的军队在指定的定城镇崛起。定城镇和英雄可以指定为复数。",
				}
			},
			{
				usages = {
					['en'] = "emergent, Xiapi, Lu Bu, Diaochan",
					['kr'] = "emergent, 하비, 여포, 초선",
					['zh'] = "emergent, 下邳, 呂布, 貂蟬",
					['cn'] = "emergent, 下邳, 吕布, 貂蝉",
				},
				descriptions = {
					['kr'] = "여포가 지도자인 세력이 하비를 수도로 삼고 봉기하며 여포, 초선으로 구성된 1개의 부대가 하비 근처에 출현합니다.",
					['en'] = "A faction led by 'Lu Bu' uprises with 'Xiapi' as its capital, and one army consisting of 'Lu Bu' and 'Diaochan' appears near 'Xiapi'.",
					['zh'] = "以“下邳”為都城，以“呂布”為首的一派起義，“下邳”附近出現了一支由“呂布”和“貂蟬”組成的軍隊。",
					['cn'] = "以“下邳”为都城，以“吕布”为首的一派起义，“下邳”附近出现了一支由“吕布”和“貂蝉”组成的军队。",
				}
			},
			{
				usages = {
					['en'] = "emergent, Xiapi, Xuexian, Lu Bu, Diaochan, Zhang Liao, Gao Shun, Lu Ji",
					['kr'] = "emergent, 하비, 설현, 여포, 초선, 장료, 고순, 여희",
				},
				descriptions = {
					['kr'] = "하비를 수도로하고 설현 정착지를 포함한 지역에 여포를 지도자로 하는 세력이 봉기합니다. 여포, 초선, 장료로 구성된 1개의 부대가 하비 근처에 출현합니다",
					['en'] = "A faction lead by 'Lu Bu' uprises with 'Xiapi' as its capital and occupied 'Xuequini', and one army consisting of 'Lu Bu', 'Zhang Liao' and 'Diaochan' appears near 'Xiapi'.",
					['zh'] = "以“下邳”為首都的“呂布”一派起義，佔領了“雪奎尼”，“下邳”附近出現了“呂布”、“張遼”、“貂蟬”三軍。",
					['cn'] = "以“下邳”为都城，以“吕布”为首的一派起义，占领了“雪奎尼”，“下邳”附近出现了“吕布”、“张辽”、“貂蝉”三军。",
				}
			},
		},
	},
	['teleport'] = {
		brief = {
			['kr'] = "군대를 이끌고 있는 사령관을 지정하여 대상 지역으로 순간 이동시킵니다.",
			['en'] = "Teleporting a commander leading an army to the target area.",
			['zh'] = "將帶領軍隊的指揮官傳送到目標區域。",
			['cn'] = "将带领军队的指挥官传送到目标区域。",
		},
		examples = {
			{
				usages = {
					['en'] = "teleport, Liu_Bei, Luoyang",
					['kr'] = "teleport, 유비, 낙양",
					['zh'] = "teleport, 劉備, 洛陽",
					['cn'] = "teleport, 刘备, 洛阳",
				},
				descriptions = {
					['kr'] = "유비 부대를 낙양 근처로 순간 이동 시킵니다.",
					['en'] = "Teleporting a amry of 'Liu Bei' to the 'Luoyang' region",
					['zh'] = "將“劉備”大軍傳送至‘洛陽’地區",
					['cn'] = "将“刘备”大军传送至‘洛阳’地区",
				}
			},
		},
	},
	['show'] = {
		brief = {
			['kr'] = "전체 맵을 밝히거나, 맵 상의 정착지 위치를 보여줍니다.",
			['en'] = "Shows entire campaign map or show region of the specified settlement.",
			['zh'] = "顯示整個戰役地圖或顯示指定定居點的區域。",
			['cn'] = "显示整个战役地图或显示指定定居点的区域。",
		},
		examples = {
			{
				usages = {
					['en'] = "show, world",
				},
				descriptions = {
					['kr'] = "전체 맵을 밝힙니다. 턴이 종료할 때에 맵은 원래 상태로 돌아갑니다.",
					['en'] = "Shows entire campaign map. When player's turn end, restores shroud.",
					['zh'] = "顯示整個戰役地圖。 當玩家的回合結束時，恢復裹黑霧。",
					['cn'] = "显示整个战役地图。 当玩家的回合结束时，恢复裹黑霧。",
				}
			},
			{
				usages = {
					['en'] = "show, shroud",
				},
				descriptions = {
					['kr'] = "'show' 명령 이전의 상태로 맵의 장막(안개)를 복원합니다",
					['en'] = "Restores shroud to the state it was in before the 'show' command.",
					['zh'] = "將黑霧恢復到“show”命令之前的狀態。",
					['cn'] = "将黑霧恢复到“show”命令之前的状态。",
				}
			},
			{
				usages = {
					['en'] = "show, Luoyang",
					['kr'] = "show, 낙양",
				},
				descriptions = {
					['kr'] = "낙양 정착지 주변을 보여줍니다.",
					['en'] = "Shows the region of 'Luoyang'.",
					['zh'] = "顯示“洛陽”區域。",
					['cn'] = "显示“洛阳”区域。",
				}
			},
		},
	},
	['where'] = {
		brief = {
			['kr'] = "캠페인 맵 상의 세력 또는 부대를 보여줍니다.",
			['en'] = "Shows the faction or an army on the campaign map.",
			['zh'] = "在地圖上顯示派系或軍隊。",
			['cn'] = "在地图上显示派系或军队。",
		},
		examples = {
			{
				usages = {
					['en'] = "where, Cao Cao",
					['kr'] = "where, 조조",
					['zh'] = "where, 曹操",
					['cn'] = "where, 曹操",
				},
				descriptions = {
					['kr'] = "'조조'가 포함된 부대 또는 '조조' 세력의 수도을 찾아서 카메라를 이동 시키고, 그 지역의 안개를 벗겨내 볼 수 있게 합니다.",
					['en'] = "Find the army that contains 'Cao Cao' or the capital of the 'Cao Cao' faction, move the camera, and remove the shroud in the area.",
					['zh'] = "找到包含“曹操”的軍隊或“曹操”派系的首都，移動相機，並移除該地區的黑霧。",
					['cn'] = "找到包含“曹操”的军队或“曹操”派系的首都，移动相机，并移除该地区的黑雾。",
				}
			},
		},
	},
	['raze'] = {
		brief = {
			['kr'] = "도시 또는 부속 정착지를 주인이 없는 공백 상태로 만듭니다.",
			['en'] = "Makes a city or settlement vacant without an owner.",
			['zh'] = "使一個城鎮空置。",
			['cn'] = "使一个城镇空置。",
		},
		examples = {
			{
				usages = {
					['en'] = "raze, Luoyang",
					['kr'] = "raze, 낙양",
					['zh'] = "raze, 洛陽",
					['cn'] = "raze, 洛阳",
				},
				descriptions = {
					['kr'] = "'낙양'을 주인없는 공백 상태로 만듭니다.",
					['en'] = "Make 'Luoyang' vacant.",
					['zh'] = "使“洛陽”空置",
					['cn'] = "使“洛阳”空置。",
				}
			},
		},
	},
	['occupy'] = {
		brief = {
			['kr'] = "지정한 세력이 지정한 정착지를 점령하게 합니다.",
			['en'] = "Let the specified faction occupy the specified settlement.",
			['zh'] = "讓指定的派系佔領指定的定居點。",
			['cn'] = "让指定的派系占领指定的定居点。",
		},
		examples = {
			{
				usages = {
					['en'] = "occupy, Cao Cao, Luoyang",
					['kr'] = "occupy, 조조, 낙양",
					['zh'] = "occupy, 曹操, 洛陽",
					['cn'] = "occupy, 曹操, 洛阳",
				},
				descriptions = {
					['kr'] = "'조조' 세력이 낙양을 점령합니다",
					['en'] = "Make 'Cao Cao' faction occupy 'Luoyang'.",
					['zh'] = "讓“曹操”派佔領“洛陽”。",
					['cn'] = "让“曹操”派占领“洛阳”。",
				}
			},
		},
	},
	['imperial'] = {
		brief = {
			['kr'] = "한나라 황실과 황제와 관련된 명령들",
			['en'] = "Commands related to the Han Empire and the Emperor.",
			['zh'] = "與漢帝國和皇帝有關的命令。",
			['cn'] = "与汉帝国和皇帝有关的命令。",
		},
		examples = {
			{
				usages = {
					['en'] = "imperial.token",
				},
				descriptions = {
					['kr'] = "현재 조정의 협력자/보정대신(輔政大臣)이 누구인지 알려줍니다.",
					['en'] = "Show current 'Imperial Protectorate'",
					['zh'] = "顯示當前的“輔政大臣”",
					['cn'] = "显示当前的“辅政大臣”",
				}
			},
			{
				usages = {
					['en'] = "imperial.token, Liu Bei",
					['kr'] = "imperial.token, 유비",
					['zh'] = "imperial.token, 劉備",
					['cn'] = "imperial.token, 刘备",
				},
				descriptions = {
					['kr'] = "유비가 조정의 협력자/보정대신(輔政大臣)이 됩니다.",
					['en'] = "Establishes 'Liu Bei' as 'Imperial Protectorate'",
					['zh'] = "立“劉備”為“輔政大臣”",
					['cn'] = "立“刘备”为“辅政大臣”",
				}
			},
			{
				usages = {
					['en'] = "imperial.favour, Liu Bei",
					['kr'] = "imperial.favour, 유비",
					['zh'] = "imperial.favour, 劉備",
					['cn'] = "imperial.favour, 刘备",
				},
				descriptions = {
					['kr'] = "유비 세력 황실 호의 수치를 알려줍니다.",
					['en'] = "Notifies the favour attributes of imperial for 'Liu Bei' faction.",
					['zh'] = "通知“劉備”派系的皇帝寵信屬性。",
					['cn'] = "通知“刘备”派系的天子宠信属性。",
				}
			},
			{
				usages = {
					['en'] = "imperial.favour, Liu Bei, 30",
					['kr'] = "imperial.favour, 유비, 30",
					['zh'] = "imperial.favour, 劉備, 30",
					['cn'] = "imperial.favour, 刘备, 30",
				},
				descriptions = {
					['kr'] = "유비 세력에 대한 황실 호의 수치를 30 증가 시킵니다.",
					['en'] = "Increases the favour attributes of imperial for 'Liu Bei' by 30.",
					['zh'] = "為“劉備”增加30皇帝寵信屬性。",
					['cn'] = "为“刘备”增加30天子宠信属性。",
				}
			},
			{
				usages = {
					['en'] = "imperial.favour, Liu Bei, -30",
					['kr'] = "imperial.favour, 유비, -30",
					['zh'] = "imperial.favour, 劉備, -30",
					['cn'] = "imperial.favour, 刘备, -30",
				},
				descriptions = {
					['kr'] = "유비 세력에 대한 황실 호의 수치를 30 감소 시킵니다.",
					['en'] = "Decreases the favour attributes of imperial for 'Liu Bei' by 30.",
					['zh'] = "對“劉備”的皇帝寵信屬性降低30點。",
					['cn'] = "对“刘备”的天子宠信属性降低30点。",
				}
			},
		},
	},
	['search'] = {
		brief = {
			['kr'] = "입력된 이름/CQI/키 값을 가진 장수들을 찾아서 알려주고 로그를 남깁니다.",
			['en'] = "Search heroes on the map by name/CQI/key. Notifies the found heroes and outputs logs.",
			['zh'] = "按名稱/CQI/鍵在地圖上搜索英雄。 通知找到的英雄並輸出日誌。",
			['cn'] = "按名称/CQI/键在地图上搜索英雄。 通知找到的英雄并输出日志。",
		},
		examples = {
			{
				usages = {
					['en'] = "search, Zhao Yun",
					['kr'] = "search, 조운",
					['zh'] = "search, 趙雲",
					['cn'] = "search, 赵云",
				},
				descriptions = {
					['kr'] = "'조운'에 해당하는 장수들을 찾아 알려줍니다",
					['en'] = "Search by name.",
					['zh'] = "按名稱搜索。",
					['cn'] = "按名称搜索。",
				}
			},
			{
				usages = {
					['en'] = "search, zhao_yun",
				},
				descriptions = {
					['kr'] = "영웅마다 고유한 영문 키로 search 할 수 있습니다.",
					['en'] = "Search by 'name key'(unique)",
					['zh'] = "按 'name key（唯一）' 搜索。",
					['cn'] = "按 'name key（唯一）' 搜索。",
				}
			},
			{
				usages = {
					['en'] = "search, 23",
				},
				descriptions = {
					['kr'] = "장수 번호로 search 할 수 있습니다.",
					['en'] = "Search by CQI.",
					['zh'] = "按 CQI 搜索。",
					['cn'] = "按 CQI 搜索。",
				}
			},
			{
				usages = {
					['en'] = "search, 3k_main_template_historical_zhao_yun_hero_metal",
				},
				descriptions = {
					['kr'] = "탬플릿 키로 search 할 수 있습니다.",
					['en'] = "Search by 'template key'.",
					['zh'] = "按 'template key' 搜索。",
					['cn'] = "按 'template key' 搜索。",
				}
			},
		},
	},
	['summon'] = {
		brief = {
			['kr'] = "소환 명령은 맵 상의 영웅을 다른 세력으로 옮기기도 하고, 맵 상에 존재하지 않는 영웅을 생성하기도 합니다. 소환되는 영웅의 세력을 아군, 또는 다른 AI 세력으로 지정할 수 있습니다.",
			['en'] = "The 'summon' command transfer a hero to destination faction, if exists. Or spawns a hero to the faction.",
			['zh'] = "“summon”命令將英雄轉移到目標派系（如果存在）。或者為派系產生一個英雄。",
			['cn'] = "“summon”命令将英雄转移到目标派系（如果存在）。或者为派系产生一个英雄。",
		},
		examples = {
			{
				usages = {
					['kr'] = "summon, 제갈량",
					['en'] = "summon, Zhuge Liang",
					['zh'] = "summon, 諸葛亮",
					['cn'] = "summon, 诸葛亮",
				},
				descriptions = {
					['kr'] = "'제갈량'에 해당하는 장수들을 찾거나 '스폰'해서 아군 세력으로 소환합니다.",
					['en'] = "Finds 'Zhuge Liang', transfer the hero if exists or spawn to player faction.",
					['zh'] = "找到“諸葛亮”，如果存在就轉移英雄或生成到玩家陣營。",
					['cn'] = "找到“诸葛亮”，如果存在就转移英雄或生成到玩家阵营。",
				}
			},
			{
				usages = {
					['en'] = "summon, Xu Chu, Cao Cao",
					['kr'] = "summon, 허저, 조조",
					['zh'] = "summon, 許褚, 曹操",
					['cn'] = "summon, 许褚, 曹操",
				},
				descriptions = {
					['kr'] = "'허저'에 해당하는 장수들을 찾거나 '스폰'해서 '조조' 세력으로 소환합니다.",
					['en'] = "Finds 'Xu Chu', transfer the hero if exists or spawn to 'Cao Cao' faction.",
					['zh'] = "找到“許褚”，如果存在就將英雄轉移或生成到“曹操”派系。",
					['cn'] = "找到“许褚”，如果存在就将英雄转移或生成到“曹操”派系。",
				}
			},
			{
				usages = {
					['en'] = "summon, zhao_yun, liu_bei, 4",
					['kr'] = "summon, 조운, 유비, 4",
					['zh'] = "summon, 趙雲, 劉備, 4",
					['cn'] = "summon, 赵云, 刘备, 4",
				},
				descriptions = {
					['kr'] = "'조운'에 해당하는 장수들을 찾거나 '스폰'해서 '유비' 세력으로 랭크 4 이상인 상태로 소환합니다.",
					['en'] = "Finds 'Zhao Yun', transfer the hero if exists or spawn to 'Liu Bei' faction as rank 4.",
					['zh'] = "找到“趙雲”，如果存在就轉移英雄，或者作為等級4產生到“劉備”派系。",
					['cn'] = "找到“赵云”，如果存在就转移英雄，或者作为等级4产生到“刘备”派系。",
				}
			},
		},
	},
	['spawn'] = {
		brief = {
			['kr'] = "스폰 명령은 맵 상에 없는 영웅을 18~50세의 성인으로 해당 세력에 생성합니다.",
			['en'] = "The 'spawn' command create a hero at destination faction as 18 to 50 years old when the hero is not-exist on map.",
			['zh'] = "當英雄不存在於地圖上時，'spawn' 命令會在目標派系中創建一個 18 到 50 歲的英雄。",
			['cn'] = "当英雄不存在于地图上时，'spawn' 命令会在目标派系中创建一个 18 到 50 岁的英雄。",
		},
		examples = {
			{
				usages = {
					['en'] = "spawn, Zhuge Liang",
					['kr'] = "spawn, 제갈량",
					['zh'] = "spawn, 諸葛亮",
					['cn'] = "spawn, 诸葛亮",
				},
				descriptions = {
					['kr'] = "'제갈량'을 아군 세력에 성인(18~50)으로 생성합니다.",
					['en'] = "Spawns 'Zhuge Liang' as adult(18~50) at player faction when 'Zhuge Liang' is not-exist.",
					['zh'] = "當“諸葛亮”不存在時，在玩家陣營生成“諸葛亮”成年（18~50）。",
					['cn'] = "当“诸葛亮”不存在时，在玩家阵营生成“诸葛亮”成年（18~50）。",
				}
			},
			{
				usages = {
					['en'] = "spawn, Xu Chu, Cao Cao",
					['kr'] = "spawn, 허저, 조조",
					['zh'] = "spawn, 許褚, 曹操",
					['cn'] = "spawn, 许褚, 曹操",
				},
				descriptions = {
					['kr'] = "'허저'에 해당하는 장수가 없을 때 조조 세력에 성인(18~50)으로 생성합니다.",
					['en'] = "Spawns 'Xu Chu' as adult(18~50) at 'Cao Cao' faction when 'Xu Chu' is not-exist.",
					['zh'] = "當“許褚”不存在時，在“曹操”派系中以成年（18~50）的身份生成“徐楚”。",
					['cn'] = "当“许褚”不存在时，在“曹操”派系中以成年（18~50）的身份生成“徐楚”。",
				}
			},
			{
				usages = {
					['en'] = "spawn, Guan Ping, Liu Bei, 4",
					['kr'] = "spawn, 관평, 유비, 4",
					['zh'] = "spawn, 關平, 劉備, 4",
					['cn'] = "spawn, 关平, 刘备, 4",
				},
				descriptions = {
					['kr'] = "'관평'에 해당하는 장수가 맵 상에 없을 때 성인(18~50)으로 유비 세력에 스킬 랭크 4 이상의 상태로 스폰합니다.",
					['en'] = "Spawns 'Guan Ping' as rank 4 and adult(18~50) at 'Liu Bei' faction when 'Guan Ping' is not-exist.",
					['zh'] = "當“關平”不存在時，在“劉備”派系生成等級 4 和成人（18~50）的“關平”。",
					['cn'] = "当“关平”不存在时，在“刘备”派系生成等级 4 和成人（18~50）的“关平”。",
				}
			},
		},
	},
	['kill'] = {
		brief = {
			['kr'] = "세력 지도자 및 부대 사령관이 아닌 영웅을 킬합니다.",
			['en'] = "Kills a hero who is not faction leador nor commander of an army.",
			['zh'] = "殺死一個不是派系領袖或軍隊指揮官的英雄。",
			['cn'] = "杀死一个不是派系领袖或军队指挥官的英雄。",
		},
		examples = {
			{
				usages = {
					['en'] = "kill, Hero",
					['kr'] = "kill, 영웅",
					['zh'] = "kill, 英雄",
					['cn'] = "kill, 英雄",
				},
				descriptions = {
					['kr'] = "'영웅' 이름에 해당하는 장수를 찾아서 '불행한 사건'에 의한 죽음을 만듭니다.",
					['en'] = "Makes a death by 'Unfortunate Events' of the found hero searched by name.",
					['zh'] = "通過名稱搜索找到的英雄的‘不幸事件’導致死亡。",
					['cn'] = "通过名称搜索找到的英雄的‘不幸事件’导致死亡。",
				}
			},
			{
				usages = {
					['en'] = "kill, 23",
				},
				descriptions = {
					['kr'] = "'장수 번호'에 해당하는 장수를 사망 시킵니다.",
					['en'] = "Kills a hero with CQI 23.",
					['zh'] = "使用 CQI 23 殺死一名英雄。",
					['cn'] = "使用 CQI 23 杀死一名英雄。",
				}
			},
			{
				usages = {
					['en'] = "kill, Dong Zhuo, 52",
					['kr'] = "kill, 동탁, 52",
					['zh'] = "kill, 董卓, 52",
					['cn'] = "kill, 董卓, 52",
				},
				descriptions = {
					['kr'] = "'동탁' 중에 장수 번호 '53'인 장수를 죽입니다",
					['en'] = "Kills a hero whose name is 'Dong Zhuo' and CQI is 52.",
					['zh'] = "殺死一個名叫“董卓”，CQI為52的英雄。",
					['cn'] = "杀死一个名叫“董卓”，CQI为52的英雄。",
				}
			},
		},
	},
	['force_kill'] = {
		brief = {
			['kr'] = "부대를 이끌고 있는 사령관, 세력 지도자도 죽일 수 있습니다.",
			['en'] = "Forcibly kills a hero searched by name/CQI including a faction leader and a commander of an army.",
			['zh'] = "強制殺死一個英雄搜查 名稱/CQI 包括派別領導人和軍隊的指揮官。",
			['cn'] = "强制杀死一个英雄搜查 名称/CQI 包括派别领导人和军队的指挥官。",
		},
		examples = {
			{
				usages = {
					['en'] = "force_kill, Hero",
					['kr'] = "force_kill, 영웅",
					['zh'] = "force_kill, 英雄",
					['cn'] = "force_kill, 英雄",
				},
				descriptions = {
					['kr'] = "'영웅 이름'에 해당하는 장수가 찾아서 '불행한 사건'에 의한 죽음을 만듭니다.",
					['en'] = "Makes a death by 'Unfortunate Events' of the found hero searched by name.",
					['zh'] = "殺死通過‘不幸事件’按名稱搜索的‘英雄’",
					['cn'] = "杀死通过‘不幸事件’按名称搜索的‘英雄’",
				}
			},
			{
				usages = {
					['en'] = "force_kill, 23",
				},
				descriptions = {
					['kr'] = "'장수 번호'에 해당하는 장수를 '불행한 사건'에 의한 죽음에 이르게 합니다",
					['en'] = "Forcibly kills a hero with CQI 23.",
					['zh'] = "用 CQI 23 強行殺死一名英雄。",
					['cn'] = "用 CQI 23 强行杀死一名英雄。",
				}
			},
			{
				usages = {
					['en'] = "force_kill, Dong Zhuo, 52",
					['kr'] = "force_kill, 동탁, 52",
					['zh'] = "force_kill, 董卓, 52",
					['cn'] = "force_kill, 董卓, 52",
				},
				descriptions = {
					['kr'] = "'동탁' 중에 장수 번호 '53'인 장수를 죽입니다",
					['en'] = "Forcibly kills a hero whose name is 'Dong Zhuo' and CQI is 52.",
					['zh'] = "強行殺死了一個名叫“董卓”，CQI為52的英雄。",
					['cn'] = "强行杀死了一个名叫“董卓”，CQI为52的英雄。",
				}
			},
		},
	},
	['trait'] = {
		brief = {
			['kr'] = "영웅에게 특성(트레잇)을 부여하거나 제거합니다.",
			['en'] = "Adds or removes traits to or from a hero.",
			['zh'] = "為英雄添加或移除特性。",
			['cn'] = "为英雄添加或移除特性。",
		},
		examples = {
			{
				usages = {
					['en'] = "trait, Cao Cao, add, Ambitious",
					['kr'] = "trait, 조조, add, 야심참",
					['zh'] = "trait, 曹操, add, 野心勃勃",
					['cn'] = "trait, 曹操, add, 雄心勃勃",
				},
				descriptions = {
					['kr'] = "'조조'에게 '야심참' 특성을 추가합니다.",
					['en'] = "Adds a 'Ambitious' trait to 'Cao Cao'.",
					['zh'] = "為“曹操”添加‘野心勃勃’特性。",
					['cn'] = "为“曹操”添加‘雄心勃勃’特性。",
				}
			},
			{
				usages = {
					['en'] = "trait, cao_cao, remove, Ambitious",
					['kr'] = "trait, 조조, remove, 야심참",
					['zh'] = "trait, 曹操, remove, 野心勃勃",
					['cn'] = "trait, 曹操, remove, 雄心勃勃",
				},
				descriptions = {
					['kr'] = "'조조'에게서 '야심참' 특성을 제거합니다.",
					['en'] = "Removes a 'Ambitious' trait to 'Cao Cao'.",
					['zh'] = "刪除“曹操”的‘雄心勃勃’特性。",
					['cn'] = "删除“曹操”的‘雄心勃勃’特性。",
				}
			},
			{
				usages = {
					['en'] = "trait, Cao Cao, remove, all",
					['kr'] = "trait, 조조, remove, all",
					['zh'] = "trait, 曹操, remove, all",
					['cn'] = "trait, 曹操, remove, all",
				},
				descriptions = {
					['kr'] = "'조조'에게서 모든 특성을 제거합니다. '알려지지 않은' 특성 3개가 남게 됩니다",
					['en'] = "Removes all traits from 'Cao Cao'.",
					['zh'] = "移除“曹操”的所有特性。",
					['cn'] = "移除“曹操”的所有特性。",
				}
			},
		},
	},
	['trait_set'] = {
		brief = {
			['kr'] = "영웅에게 미리 설정한 특성(트레잇) 세트를 설정합니다.",
			['en'] = "Removes all traits of a hero and adds traits of predefined set.",
			['zh'] = "移除英雄的所有特性並添加預定義集合的特性。",
			['cn'] = "移除英雄的所有特性并添加预定义集合的特性。",
		},
		examples = {
			{
				usages = {
					['en'] = "trait_set, 손인, Charming(defined in user-db text)",
					['kr'] = "trait_set, 손인, 매력 덩어리(사용자 db에서 설정)",
					['zh'] = "trait_set, 孫仁, 迷人（在用戶 db 文本中定義）",
					['cn'] = "trait_set, 孙仁, 迷人（在用户 db 文本中定义）",
				},
				descriptions = {
					['kr'] = "'손인'의 트레잇을 모두 삭제하고 미리 정해놓은 '매력 덩이리' 트레잇 세트를 부여합니다.",
					['en'] = "Removes all and adds traits of the trait set name 'Charming' to 'Sun Ren'.",
					['zh'] = "移除所有特性並將特性集名稱‘迷人’的特性添加到“孫仁”。",
					['cn'] = "移除所有特性并将特性集名称‘迷人’的特性添加到“孙仁”。",
				}
			},
		},
	},
	['rank_up'] = {
		brief = {
			['kr'] = "대상 장수의 경험치를 지정 스킬 랭크에 필요한 경험치와 비슷하게 올립니다.",
			['en'] = "Increases the target hero's experience to be similar to the experience required for the specified skill rank.",
			['zh'] = "將目標英雄的經驗增加到與指定技能等級所需的經驗相似。",
			['cn'] = "将目标英雄的经验增加到与指定技能等级所需的经验相似。",
		},
		examples = {
			{
				usages = {
					['en'] = "rank_up, Zhao Yun, 4",
					['kr'] = "rank_up, 조운, 4",
					['zh'] = "rank_up, 趙雲, 4",
					['cn'] = "rank_up, 赵云, 4",
				},
				descriptions = {
					['kr'] = "'조운'의 경험치를 스킬 랭크 4 필요한 경험치로 설정합니다",
					['en'] = "Increases experience of 'Zhao Yun' to make skill rank 4.",
					['zh'] = "增加“趙雲”的經驗，使技能等級4。",
					['cn'] = "增加“赵云”的经验，使技能等级4。",
				}
			},
		},
	},
	['give_exp'] = {
		brief = {
			['kr'] = "대상 장수에게 지정한 경험치를 추가합니다.",
			['en'] = "Gives experience to the hero",
			['zh'] = "給予英雄經驗",
			['cn'] = "给予英雄经验",
		},
		examples = {
			{
				usages = {
					['en'] = "give_exp, Zhao Yun, 4000",
					['kr'] = "give_exp, 조운, 4000",
					['zh'] = "give_exp, 趙雲, 4000",
					['cn'] = "give_exp, 赵云, 4000",
				},
				descriptions = {
					['kr'] = "'조운'에게 4,000의 경험치를 추가합니다.",
					['en'] = "Gives 4,000 experience to 'Zhao Yun'.",
					['zh'] = "給予“趙雲” 4,000 經驗值。",
					['cn'] = "给予“赵云” 4,000 经验值。",
				}
			},
		},
	},
	['set_title'] = {
		brief = {
			['kr'] = "장수에게 '고유 칭호(배경)'를 부여하거나, 다른 칭호로 교체합니다.",
			['en'] = "Gives a career title to a hero or exchanges it to new one.",
			['zh'] = "給英雄一個‘出身/稱號’或將其換成新的。",
			['cn'] = "给英雄一个‘背景/称号’或将其换成新的。",
		},
		examples = {
			{
				usages = {
					['en'] = "set_title, Liu Hong, The Great Emperor of the Han",
					['kr'] = "set_title, 유굉, 대한명군",
					['zh'] = "set_title, 劉洪, 大漢明君",
					['cn'] = "set_title, 刘宏, 大汉明君",
				},
				descriptions = {
					['kr'] = "'Liu Hong'에게 '대한명군' 칭호를 부여합니다.",
					['en'] = "Set the career title of 'Liu Hong' to 'The Great Emperor of the Han'.",
					['zh'] = "將“劉洪”的‘出身/稱號’定為“大漢明君”。",
					['cn'] = "将“刘洪”的‘背景/称号’定为“大汉明君”。",
				}
			},
			{
				usages = {
					['en'] = "set_title, Liu Hong, Zhao Yun",
					['kr'] = "set_title, 유굉, 조운",
					['zh'] = "set_title, 劉洪, 趙雲",
					['cn'] = "set_title, 刘宏, 赵云",
				},
				descriptions = {
					['kr'] = "'유굉'에게 장수 '조운'의 기본 칭호인 '난세 속의 빛' 칭호를 부여합니다",
					['en'] = "Set the career title of 'Liu Hong' to 'Light in the Dark' which is a career title of 'Zhao Yun'.",
					['zh'] = "將“劉洪”的‘出身/稱號’設置為“黑暗中的光明”，即“趙雲”的‘出身/稱號’。",
					['cn'] = "将“刘宏”的‘背景/称号’设置为“黑暗中的光明”，即“赵云”的‘背景/称号’。",
				}
			},
		},
	},
	['set_undercover'] = {
		brief = {
			['kr'] = "장수가 첩자로 파견 될 수 있는 능력을 부여하거나 제거 합니다.",
			['en'] = "Gives or removes the 'undercover' ability to or from a hero.",
			['zh'] = "給予或移除英雄的‘間諜’能力。",
			['cn'] = "给予或移除英雄的‘细作’能力。",
		},
		examples = {
			{
				usages = {
					['en'] = "set_undercover, Zhao Yun, true",
					['kr'] = "set_undercover, 조운, true",
					['zh'] = "set_undercover, 趙雲, true",
					['cn'] = "set_undercover, 赵云, true",
				},
				descriptions = {
					['kr'] = "'조운'에게 첩자 능력을 부여합니다.",
					['en'] = "Gives 'Zhao Yun' an undercover ability.",
					['zh'] = "賦予“趙雲”‘間諜’能力。",
					['cn'] = "赋予“赵云”‘细作’能力。",
				}
			},
			{
				usages = {
					['en'] = "set_undercover, Zhao Yun, false",
					['kr'] = "set_undercover, 조운, false",
					['zh'] = "set_undercover, 趙雲, false",
					['cn'] = "set_undercover, 赵云, false",
				},
				descriptions = {
					['kr'] = "'조운'에게서 첩자 능력을 제거 합니다.",
					['en'] = "Removes the undercover ability from 'Zhao Yun'.",
					['zh'] = "移除“趙雲”的‘間諜’能力。",
					['cn'] = "移除“赵云”的‘细作’能力。",
				}
			},
		},
	},
	['reset_skills'] = {
		brief = {
			['kr'] = "장수의 스킬 트리를 초기화 시킵니다.",
			['en'] = "Resets hero's skill tree.",
			['zh'] = "人物技能樹重置",
			['cn'] = "人物所习技能重置",
		},
		examples = {
			{
				usages = {
					['en'] = "reset_skills, Zhao Yun",
					['kr'] = "reset_skills, 조운",
					['zh'] = "reset_skills, 趙雲",
					['cn'] = "reset_skills, 赵云",
				},
				descriptions = {
					['kr'] = "'조운'의 스킬 트리를 초기화 합니다.",
					['en'] = "Resets the skill tree of 'Zhao Yun'.",
					['zh'] = "重置“趙雲”的技能樹。",
					['cn'] = "重置“赵云”的所习技能。",
				}
			},
		},
	},
	['marry'] = {
		brief = {
			['kr'] = "지정한 두 장수를 결혼 상태로 설정합니다.",
			['en'] = "",
			['zh'] = "",
			['cn'] = "将两位指定的人物安排联姻。",
		},
		examples = {
			{
				usages = {
					['cn'] = "marry, 吕布, 貂蝉",

				},
				descriptions = {
					['kr'] = "'손책'과 '대교'를 혼인 상태로 만듭니다.",
					['en'] = "",
					['zh'] = "",
					['cn'] = "吕布和貂蝉结婚。",
				}
			},
		},
	},
	['child_of'] = {
		brief = {
			['kr'] = "두 영웅 간에 부모 자식 관계를 설정합니다.",
			['en'] = "Set a parent-child relationship between two heroes.",
			['zh'] = "設置兩個英雄之間的父子關係。",
			['cn'] = "设置两个英雄之间的父子关系。",
		},
		examples = {
			{
				usages = {
					['en'] = "child_of, Guan Ping, Guan Yu",
					['kr'] = "child_of, 관평, 관우",
					['zh'] = "child_of, 關平, 關羽",
					['cn'] = "child_of, 关平, 关羽",
				},
				descriptions = {
					['kr'] = "'관평'을 '관우'의 아들로서 부모 자식 관계를 설정합니다.",
					['en'] = "Sets 'Guan Ping' as a child of 'Guan Yu'.",
					['zh'] = "將“關平”定為“關羽”的孩子。",
					['cn'] = "将“关平”定为“关羽”的孩子。",
				}
			},
		},
	},
	['post'] = {
		brief = {
			['kr'] = "장수의 세력 내에서의 지위를 설정합니다.",
			['en'] = "Sets a hero's position in the faction.",
			['zh'] = "設置英雄在派系中的位置。",
			['cn'] = "设置英雄在派系中的位置",
		},
		examples = {
			{
				usages = {
					['en'] = "post.leader, Liu Bei, Guan Yu",
					['kr'] = "post.leader, 유비, 관우",
					['zh'] = "post.leader, 劉備, 關羽",
					['cn'] = "post.leader, 刘备, 关羽",
				},
				descriptions = {
					['kr'] = "'관우'를 '유비' 세력의 지도자로 설정합니다.",
					['en'] = "Sets 'Guan Yu' as a faction leader of the 'Liu Bei' faction.",
					['zh'] = "將“關羽”設定為“劉備”派系首领。",
					['cn'] = "将“关羽”设定为“刘备”勢力領袖。",
				}
			},
			{
				usages = {
					['en'] = "post.heir, Liu Bei, Guan Ping",
					['kr'] = "post.heir, 유비, 관평",
					['zh'] = "post.heir, 劉備, 關平",
					['cn'] = "post.heir, 刘备, 关平",
				},
				descriptions = {
					['kr'] = "'관평'을 '유비' 세력의 후계자로 설정합니다.",
					['en'] = "Sets 'Guan Ping' as a faction heir of the 'Liu Bei' faction.",
					['zh'] = "將“關平”設置為“劉備”派系的派系繼承人。",
					['cn'] = "将“关平”设置为“刘备”派系的派系储君。",
				}
			},
		},
	},
	['rel'] = {
		brief = {
			['kr'] = "두 장수 간의 관계를 추가 합니다. 기존에 관계가 있다면, 기존 관계에 영향을 미칩니다.",
			['en'] = "Adds or sets a relationship between specified two heroes.",
			['zh'] = "添加或設置指定的兩個英雄之間的關係。",
			['cn'] = "添加或设置指定的两个英雄之间的关系。",
		},
		examples = {
			{
				usages = {
					['en'] = "rel.improve, Hero, Hero",
					['kr'] = "rel.improve, 영웅, 영웅",
					['zh'] = "rel.improve, 英雄, 英雄",
					['cn'] = "rel.improve, 英雄, 英雄",
				},
				descriptions = {
					['kr'] = "두 영웅간에 친밀도를 상당히 높이는 기억을 추가합니다. 친밀도가 높은 상태에서 좋은 기억을 추가하게 되면 두 영웅은 친구 관계가 될 수도 있습니다.",
					['en'] = "Adds memory that significantly increases intimacy between two heroes. If you add good memories while intimacy is high, the two heroes can become friends.",
					['zh'] = "增加記憶，顯著增加兩個英雄之間的親密度。 如果在親密度高的情況下添加美好的回憶，兩個英雄可以成為朋友。",
					['cn'] = "增加记忆，显着增加两个英雄之间的亲密度。 如果在亲密度高的情况下添加美好的回忆，两个英雄可以成为朋友。",
				}
			},
			{
				usages = {
					['en'] = "rel.friend, Xun Yu, Xun You",
					['kr'] = "rel.friend, 순욱, 순유",
					['zh'] = "rel.friend, 荀彧, 荀攸",
					['cn'] = "rel.friend, 荀彧, 荀攸",
				},
				descriptions = {
					['kr'] = "'순욱'를 '순유'의 친구 관계가 되도록 두 장수 간에 좋은 기억을 추가합니다.\n영구적인 '어릴적 친구' 관계를 설정하고, 친밀도를 매우 높은 과거의 사건을 기억에 추가합니다.",
					['en'] = "A good memory is added between the two heroes so that 'Xun Yu' becomes 'Xun You''s friend. Establish a permanent 'childhood friend' relationship, and add a very high affinity past event to the memory.",
					['zh'] = "兩個英雄之間增加了一段美好的回憶，讓“荀彧”成為了“荀攸”的朋友。 建立永久的“兒時好友”關係，為記憶添加親和力非常高的往事。",
					['cn'] = "两个英雄之间增加了一段美好的回忆，让“荀彧”成为了“荀攸”的朋友。 建立永久的“儿时好友”关系，为记忆添加亲和力非常高的往事。",
				}
			},
			{
				usages = {
					['en'] = "rel.family, Guan Yu, Guan Yinping",
					['kr'] = "rel.family, 관우, 관은병",
					['zh'] = "rel.family, 關羽, 關銀屏",
					['cn'] = "rel.family, 关羽, 关银屏",
				},
				descriptions = {
					['kr'] = "'관우'가 '관은병'을 가족처럼 여기도록 관계를 추가합니다. 이 관계는 영구적이지 않습니다.",
					['en'] = "Add a relationship so that 'Guan Yu' treats 'Guan Yinping' like family. This relationship is not permanent.",
					['zh'] = "添加關係，讓“關羽”像對待家人一樣對待“關銀屏”。 這種關係不是永久的。",
					['cn'] = "添加关系，让“关羽”像对待家人一样对待“关银屏”。 这种关系不是永久性的。",
				}
			},
			{
				usages = {
					['en'] = "rel.brother, Sun Ce, Zhou Yu",
					['kr'] = "rel.brother, 손책, 주유",
					['zh'] = "rel.brother, 孫策, 周瑜",
					['cn'] = "rel.brother, 孙策, 周瑜",
				},
				descriptions = {
					['kr'] = "'손책'과 '주유'가 서로 의형제로 여기도록 관계를 추가합니다. 이 관계는 영구적입니다.",
					['en'] = "Add a relationship so that 'Sun Ce' and 'Zhou Yu' consider each other oath-sworn brother. This relationship is permanent.",
					['zh'] = "加個關係，讓“孫策”和“周瑜”當成結義之友。 這種關係是永久性的。",
					['cn'] = "加个关系，让“孙策”和“周瑜”当成义亲。 这种关系是永久性的。",
				}
			},
			{
				usages = {
					['en'] = "rel.master, Liu Bei, Sun Qian",
					['kr'] = "rel.master, 유비, 손건",
					['zh'] = "rel.master, 劉備, 孫乾",
					['cn'] = "rel.master, 刘备, 孙乾",
				},
				descriptions = {
					['kr'] = "'손건'에게 '유비'가 과거 상관이였고 좋은 관계였다는 기억을 추가합니다.",
					['en'] = "Adds memory to 'Sun Qian' that 'Liu Bei' was a former boss and had a good relationship.",
					['zh'] = "給“孫乾”增加了記憶，“劉備”是前老闆，關係很好。",
					['cn'] = "给“孙乾”增加了记忆，“刘备”是前老板，关系很好。",
				}
			},
			{
				usages = {
					['en'] = "rel.rival, Guan Yu, Zhang Liao",
					['kr'] = "rel.rival, 관우, 장료",
					['zh'] = "rel.rival, 關羽, 張遼",
					['cn'] = "rel.rival, 关羽, 张辽",
				},
				descriptions = {
					['kr'] = "'관우'와 '장료'가 서로 맞수/적수로 여기도록 관계를 추가합니다. 전투와 업적에 영향을 미칩니다.",
					['en'] = "Add a relationship so that 'Guan Yu' and 'Zhang Liao' are considered rivals. Affects battles and achievements.",
					['zh'] = "添加關係，以便將“關羽”和“張遼”視為競爭對手。 影響戰鬥和成就。",
					['cn'] = "添加关系，使“关羽”和“张辽”被视为敌手。 影响战斗和成就。",
				}
			},
			{
				usages = {
					['en'] = "rel.nemesis, Yuan Shao, Gongsun Zan",
					['kr'] = "rel.nemesis, 원소, 공손찬",
					['zh'] = "rel.nemesis, 袁紹, 公孫瓚",
					['cn'] = "rel.nemesis, 袁绍, 公孙瓒",
				},
				descriptions = {
					['kr'] = "'원소'와 '공손찬'에 서로 숙적 관계를 추가합니다. 외교 관계에 큰 영향을 미치며 영구적입니다.",
					['en'] = "Add antagonism to each other for 'Yuan Shao' and 'Gongsun Zan'. It has a huge impact on diplomatic relations and is permanent.",
					['zh'] = "為“袁紹”和“公孫瓚”增添了對立。 它對外交關係有著巨大的影響，而且是永久性的。",
					['cn'] = "为“袁绍”和“公孙瓒”增添了对立。 它对外交关系有着巨大的影响，而且是永久性的。",
				}
			},
		},
	},
	['ef_presented'] = {
		brief = {
			['kr'] = "영웅에게 10턴 동안 지속되는 '선물 받은' 효과를 추가합니다.",
			['en'] = "Grants a 'presented gift' effect to the designated hero for 10 turns.",
			['zh'] = "賦予指定英雄“贈送禮物”效果，持續 10輪。",
			['cn'] = "赋予指定英雄“赠送礼物”效果，持续 10轮。",
		},
		examples = {
			{
				usages = {
					['en'] = "ef_presented, Guan Yu",
					['kr'] = "ef_presented, 관우",
					['zh'] = "ef_presented, 關羽",
					['cn'] = "ef_presented, 关羽",
				},
				descriptions = {
					['kr'] = "'관우'에게 10턴간 지속되는 '하사받은 선물' 효과를 추가합니다.",
					['en'] = "Adds the 'presented gift' effect to 'Guan Yu' that lasts for 10 turns.",
					['zh'] = "為“關羽”增加“贈送禮物”效果，持續10輪。",
					['cn'] = "为“关羽”增加“赠送礼物”效果，持续10轮。",
				}
			},
		},
	},
	['ef_resilience'] = {
		brief = {
			['en'] = "Grants or removes an additional 'Resilience' +1 effect to all heroes belonging to the specified faction(range).",
			['kr'] = "지정한 세력(범위) 소속 장수 모두에게 추가 '회복력' +1 효과를 부여합니다.",
			['zh'] = "為屬於指定派系（範圍）的所有英雄授予或移除額外的‘恢复’+1 效果。",
			['cn'] = "为属于指定派系（范围）的所有英雄授予或移除额外的‘恢复’+1 效果。",
		},
		examples = {
			{
				usages = {
					['en'] = "ef_resilience, faction/player/all/others, 0 / 1",
					['kr'] = "ef_resilience, 세력/player/all/others, 0 / 1",
					['zh'] = "ef_resilience, 派系/player/all/others, 0 / 1",
					['cn'] = "ef_resilience, 派系/player/all/others, 0 / 1",
				},
				descriptions = {
					['kr'] = "지정한 세력(범위) 소속 장수 모두에게 추가 '회복력' +1 효과를 부여합니다.",
					['en'] = "Grants or removes an additional 'Resilience' +1 effect to all heroes belonging to the specified faction(range).",
					['zh'] = "為屬於指定派系（範圍）的所有英雄授予或移除額外的‘恢复’+1 效果。",
					['cn'] = "为属于指定派系（范围）的所有英雄授予或移除额外的‘恢复’+1 效果。",
				}
			},
			{
				usages = {
					['en'] = "ef_resilience, player, 1",
				},
				descriptions = {
					['kr'] = "아군 세력의 모든 장수에게 '회복력' +1을 부여합니다.",
					['en'] = "Grants an additional 'Resilience' +1 effect to all heroes belonging to player faction.",
					['zh'] = "為屬於玩家派系的所有英雄提供額外的‘恢复’+1 效果。",
					['cn'] = "为属于玩家派系的所有英雄提供额外的‘恢复’+1 效果。",
				}
			},
			{
				usages = {
					['en'] = "ef_resilience, Liu Bei, 1",
					['kr'] = "ef_resilience, 유비, 1",
					['zh'] = "ef_resilience, 劉備, 1",
					['cn'] = "ef_resilience, 刘备, 1",
				},
				descriptions = {
					['kr'] = "'유비' 세력의 모든 장수에게 '회복력' +1을 부여합니다.",
					['en'] = "Grants an additional 'Resilience' +1 effect to all heroes belonging to 'Liu Bei' faction.",
					['zh'] = "為所有屬於“劉備”派系的英雄提供額外的‘恢复’+1效果。",
					['cn'] = "为所有属于“刘备”派系的英雄提供额外的‘恢复’+1效果。",
				}
			},
			{
				usages = {
					['en'] = "ef_resilience, others, 0",
				},
				descriptions = {
					['kr'] = "AI 세력에 부여한 '회복력' +1을 제거합니다. 세력 효과가 없는 세력에게는 영향이 없습니다.",
					['en'] = "Removes the additional 'Resilience' +1 effect from all AI factions.",
					['zh'] = "從所有 AI 派系中移除額外的‘恢复’+1 效果。",
					['cn'] = "从所有 AI 派系中移除额外的‘恢复’+1 效果。",
				}
			},
		},
	},
	['ef_exp_bonus'] = {
		brief = {
			['kr'] = "지정한 세력(범위) 소속 장수 모두에게 추가 경험치 추가 % 효과를 부여하거나 제거합니다.",
			['en'] = "Grants or removes an 'additional experience %' effect to all heroes belonging to the specified faction(range).",
			['zh'] = "為屬於指定派系（範圍）的所有英雄授予或移除‘額外經驗%’效果。",
			['cn'] = "为属于指定派系（范围）的所有英雄授予或移除‘额外经验%’效果。",
		},
		examples = {
			{
				usages = {
					['en'] = "ef_exp_bonus, faction/player/all/others, 0 / 25/50/100/200/300/500%",
					['kr'] = "ef_exp_bonus, 세력/player/all/others, 0 / 25/50/100/200/300/500%",
					['zh'] = "ef_exp_bonus, 派系/player/all/others, 0 / 25/50/100/200/300/500%",
					['cn'] = "ef_exp_bonus, 派系/player/all/others, 0 / 25/50/100/200/300/500%",
				},
				descriptions = {
					['kr'] = "지정한 세력(범위) 소속 장수 모두에게 추가 경험치 % 효과를 부여/제거 합니다.",
					['en'] = "Grants or removes an 'additional experience %' effect to all heroes belonging to the specified faction(range).",
					['zh'] = "為屬於指定派系（範圍）的所有英雄授予或移除‘額外經驗%’效果。",
					['cn'] = "为属于指定派系（范围）的所有英雄授予或移除‘额外经验%’效果。",
				}
			},
			{
				usages = {
					['en'] = "ef_exp_bonus, player, 50",
				},
				descriptions = {
					['kr'] = "아군 세력의 모든 장수에게 경험치 +50% 효과를 부여합니다.",
					['en'] = "Gives +50% experience effect to all heroes of player faction.",
					['zh'] = "給予玩家陣營所有英雄+50%經驗效果。",
					['cn'] = "给予玩家阵营所有英雄+50%经验效果。",
				}
			},
			{
				usages = {
					['en'] = "ef_exp_bonus, Cao Cao, 200",
					['kr'] = "ef_exp_bonus, 조조, 200",
					['zh'] = "ef_exp_bonus, 曹操, 200",
					['cn'] = "ef_exp_bonus, 曹操, 200",
				},
				descriptions = {
					['kr'] = "'조조' 세력의 모든 장수에게 경험치 +200% 효과를 부여합니다.",
					['en'] = "Gives +200% experience effect to all heroes of 'Cao Cao' faction.",
					['zh'] = "給“曹操”派系所有英雄+200%經驗效果。",
					['cn'] = "给“曹操”派系所有英雄+200%经验效果。",
				}
			},
			{
				usages = {
					['en'] = "ef_exp_bonus, all, 0",
				},
				descriptions = {
					['kr'] = "모든 세력에게서 부여된 경험치 + 효과를 제거합니다.",
					['en'] = "Removes the 'additional experience %' effect from all factions.",
					['zh'] = "移除所有派系的‘額外經驗%’效果。",
					['cn'] = "移除所有派系的‘额外经验%’效果。",
				}
			},
		},
	},
	['ef_research_rate'] = {
		brief = {
			['kr'] = "도적, 황건적, 남만 세력의 개혁 연구 속도에 추가 효과를 부여합니다.",
			['en'] = "Adds an additional effect to the 'reform research rate' of 'Bandits', 'Yellow Turban', and 'Nanman' factions.",
			['zh'] = "為“盜賊”、“黃巾”和“南蠻”派系的‘改革研究率’增加額外效果。",
			['cn'] = "为“盗贼”、“黄巾”和“南蛮”派系的‘改革研究率’增加额外效果。",
		},
		examples = {
			{
				usages = {
					['en'] = "ef_research_rate, faction/player/all/others, 0 / 25/50/100/200/300/500",
					['kr'] = "ef_research_rate, 세력/player/all/others,  0 / 25/50/100/200/300/400/500",
					['zh'] = "ef_research_rate, 派系/player/all/others,  0 / 25/50/100/200/300/400/500",
					['cn'] = "ef_research_rate, 派系/player/all/others,  0 / 25/50/100/200/300/400/500",
				},
				descriptions = {
					['kr'] = "지정한 세력(범위)에 해당하는 세력에게 개혁 연구 속도 추가 효과를 부여합니다.",
					['en'] = "Adds an additional effect to the 'reform research rate' of 'Bandits', 'Yellow Turban', and 'Nanman' factions.",
					['zh'] = "為“盜賊”、“黃巾”和“南蠻”派系的‘改革研究率’增加額外效果。",
					['cn'] = "为“盗贼”、“黄巾”和“南蛮”派系的‘改革研究率’增加额外效果。",
				}
			},
			{
				usages = {
					['en'] = "ef_research_rate, Yan Baihu, 50",
					['kr'] = "ef_research_rate, 엄백호, 50",
					['zh'] = "ef_research_rate, 嚴白虎, 50",
					['cn'] = "ef_research_rate, 严白虎, 50",
				},
				descriptions = {
					['kr'] = "'엄백호' 세력에게 개혁 연구 속도 +50% 효과를 부여합니다.",
					['en'] = "Adds a 'reform research rate +50%' to 'Yan Baihu' faction.",
					['zh'] = "為“嚴白虎”派系增加‘改革研究率+50%’。",
					['cn'] = "为“严白虎”派系增加‘改革研究率+50%’。",
				}
			},
			{
				usages = {
					['en'] = "ef_research_rate, all, 0",
				},
				descriptions = {
					['kr'] = "모든 세력에게서 부여된 개혁 연구 속도 + 효과를 제거합니다.",
					['en'] = "Removes the 'reform research rate +%' effect from all factions.",
					['zh'] = "移除所有派系的‘改革研究率+%’效果。",
					['cn'] = "移除所有派系的‘改革研究率+%’效果。",
				}
			},
		},
	},
	['ef_governors'] = {
		brief = {
			['kr'] = "임명할 수 있는 태수의 숫자 증가 효과를 부여합니다.",
			['en'] = "Increases the number of appointable governors slot of the specified faction(range).",
			['zh'] = "增加指定派系（範圍）的可任命太守槽數量。",
			['cn'] = "增加指定派系（范围）的可任命太守槽数量。",
		},
		examples = {
			{
				usages = {
					['en'] = "ef_governors, faction/player/all/others,  0 / 1 ~10",
					['kr'] = "ef_governors, 세력/player/all/others,  0 / 1 ~10",
					['zh'] = "ef_governors, 派系/player/all/others,  0 / 1 ~10",
					['cn'] = "ef_governors, 派系/player/all/others,  0 / 1 ~10",
				},
				descriptions = {
					['kr'] = "지정한 세력(범위)에 해당하는 세력에게 추가 태수 임명 효과를 부여합니다.",
					['en'] = "Increases the number of appointable governors slot of the specified faction(range).",
					['zh'] = "增加指定派系（範圍）的可任命太守槽數量。",
					['cn'] = "增加指定派系（范围）的可任命太守槽数量。",
				}
			},
			{
				usages = {
					['en'] = "ef_governors, Cao Cao, 5",
					['kr'] = "ef_governors, 조조, 5",
					['zh'] = "ef_governors, 曹操, 5",
					['cn'] = "ef_governors, 曹操, 5",
				},
				descriptions = {
					['kr'] = "'조조' 세력에게 추가 5명의 추가 태수 임명 효과를 부여합니다.",
					['en'] = "Adds 5 appointable governors slots to 'Cao Cao' faction.",
					['zh'] = "為“曹操”派系增加了 5 個可任命的太守職位。",
					['cn'] = "为“曹操”派系增加了 5 个可任命的太守职位。",
				}
			},
			{
				usages = {
					['en'] = "ef_governors, Cao Cao, 0",
					['kr'] = "ef_governors, 조조, 0",
					['zh'] = "ef_governors, 曹操, 0",
					['cn'] = "ef_governors, 曹操, 0",
				},
				descriptions = {
					['kr'] = "'조조' 세력에게 부여된 추가 태수 임명 효과를 제거합니다.",
					['en'] = "Removes the added appointable governors slots effect from 'Cao Cao' faction.",
					['zh'] = "移除“曹操”派系新增的可任命太守槽效果。",
					['cn'] = "移除“曹操”派系新增的可任命太守槽效果。",
				}
			},
		},
	},
	['ef_assignments'] = {
		brief = {
			['kr'] = "장수 파견의 숫자 증가 효과를 부여합니다.",
			['en'] = "Increases the number of job assignments of the specified faction(range).",
			['zh'] = "增加指定派系（範圍）的指派分配數量。",
			['cn'] = "增加指定派系（范围）的指派分配数量。",
		},
		examples = {
			{
				usages = {
					['en'] = "ef_assignments, faction/player/all/others,  0 / 1~10",
					['kr'] = "ef_assignments, 세력/player/all/others,  0 / 1~10",
					['zh'] = "ef_assignments, 派系/player/all/others,  0 / 1~10",
					['cn'] = "ef_assignments, 派系/player/all/others,  0 / 1~10",
				},
				descriptions = {
					['kr'] = "지정한 세력(범위)에 해당하는 세력에게 파견 추가 효과를 부여합니다.",
					['en'] = "Increases the number of job assignments of the specified faction(range).",
					['zh'] = "增加指定派系（範圍）的指派分配數量。",
					['cn'] = "增加指定派系（范围）的指派分配数量。",
				}
			},
			{
				usages = {
					['en'] = "ef_assignments, Cao Cao, 5",
					['kr'] = "ef_assignments, 조조, 5",
					['zh'] = "ef_assignments, 曹操, 5",
					['cn'] = "ef_assignments, 曹操, 5",
				},
				descriptions = {
					['kr'] = "'조조' 세력에게 추가 5명의 파견 추가 효과를 부여합니다.",
					['en'] = "Adds 5 job assignments to 'Cao Cao' faction.",
					['zh'] = "為“曹操”派系增加 5 個指派分配。",
					['cn'] = "为“曹操”派系增加 5 个指派分配。",
				}
			},
			{
				usages = {
					['en'] = "ef_assignments, Cao Cao, 0",
					['kr'] = "ef_assignments, 조조, 0",
					['zh'] = "ef_assignments, 曹操, 0",
					['cn'] = "ef_assignments, 曹操, 0",
				},
				descriptions = {
					['kr'] = "'조조' 세력에게 부여된 파견 추가 효과를 제거합니다.",
					['en'] = "Removes the added assignments effect from 'Cao Cao' faction.",
					['zh'] = "移除“曹操”派系新增的指派效果。",
					['cn'] = "移除“曹操”派系新增的指派效果。",
				}
			},
		},
	},
	['ef_force_movement'] = {
		brief = {
			['kr'] = "자기 세력과 동맹 세력의 영토 내에서 부대의 이동 거리를 증가시킵니다.",
			['en'] = "Increases the movement distance of armies within the territory of homeland and allied factions.",
			['zh'] = "增加玩家派系和同盟派系領土內軍隊的移動距離。",
			['cn'] = "增加玩家派系和同盟派系领土内军队的移动距离。",
		},
		examples = {
			{
				usages = {
					['en'] = "ef_force_movement, faction/player/all/others,  0 / 10/20/30/40/50",
					['kr'] = "ef_force_movement, 세력/player/all/others,  0 / 10/20/30/40/50",
					['zh'] = "ef_force_movement, 派系/player/all/others,  0 / 10/20/30/40/50",
					['cn'] = "ef_force_movement, 派系/player/all/others,  0 / 10/20/30/40/50",
				},
				descriptions = {
					['kr'] = "지정한 세력(범위)에 해당하는 세력에게 아군 부대의 이동 거리 증가 효과를 부여합니다.",
					['en'] = "Increases the movement distance of armies within the territory of homeland and allied factions.",
					['zh'] = "增加玩家派系和同盟派系領土內軍隊的移動距離。",
					['cn'] = "增加玩家派系和同盟派系领土内军队的移动距离。",
				}
			},
			{
				usages = {
					['en'] = "ef_force_movement, Cao Cao, 20",
					['kr'] = "ef_force_movement, 조조, 20",
					['zh'] = "ef_force_movement, 曹操, 20",
					['cn'] = "ef_force_movement, 曹操, 20",
				},
				descriptions = {
					['kr'] = "'조조' 세력에게 부대의 이동 거리 +20% 증가 효과를 부여합니다.",
					['en'] = "Grants the 'increase movement +20%' effect to armies of 'Cao Cao' faction.",
					['zh'] = "為“曹操”派系的部隊提供‘增加移動距離 +20%’效果。",
					['cn'] = "为“曹操”派系的部队提供‘增加移动距离 +20%’效果。",
				}
			},
			{
				usages = {
					['en'] = "ef_force_movement, Cao Cao, 0",
					['kr'] = "ef_force_movement, 조조, 0",
					['zh'] = "ef_force_movement, 曹操, 0",
					['cn'] = "ef_force_movement, 曹操, 0",
				},
				descriptions = {
					['kr'] = "'조조' 세력에게 부여된 아군 부대의 이동 거리 증가 효과를 제거합니다.",
					['en'] = "Removes the 'increase movement' effect from 'Cao Cao' faction.",
					['zh'] = "移除“曹操”派系的‘增加運動’效果。",
					['cn'] = "移除“曹操”派系的‘增加运动’效果。",
				}
			},
		},
	},
	['ef_recruit_rank'] = {
		brief = {
			['kr'] = "지정한 세력(범위)의 부대에 병과 모집 시 병과 기본 랭크를 올립니다.",
			['en'] = "Increases the base rank of recruitable units in the specified faction(range).",
			['zh'] = "增加指定派系（範圍）內可招募單位的基本等級。",
			['cn'] = "增加指定派系（范围）内可招募单位的基本等级。",
		},
		examples = {
			{
				usages = {
					['en'] = "ef_recruit_rank, faction/player/all/others,  0 / 1 ~ 5",
					['kr'] = "ef_recruit_rank, 세력/player/all/others,  0 / 1 ~ 5",
					['zh'] = "ef_recruit_rank, 派系/player/all/others,  0 / 1 ~ 5",
					['cn'] = "ef_recruit_rank, 派系/player/all/others,  0 / 1 ~ 5",
				},
				descriptions = {
					['kr'] = "지정한 세력(범위)에 해당하는 세력에게 모집 부대 유닛 기본 랭크를 높입니다.",
					['en'] = "Increases the base rank of recruitable units in the specified faction(range).",
					['zh'] = "增加指定派系（範圍）內可招募單位的基本等級。",
					['cn'] = "增加指定派系（范围）内可招募单位的基本等级。",
				}
			},
			{
				usages = {
					['en'] = "ef_recruit_rank, Cao Cao, 2",
					['kr'] = "ef_recruit_rank, 조조, 2",
					['zh'] = "ef_recruit_rank, 曹操, 2",
					['cn'] = "ef_recruit_rank, 曹操, 2",
				},
				descriptions = {
					['kr'] = "'조조' 세력의 부대 유닛 모집 시 모집되는 유닛의 기본 랭크를 2 올립니다.",
					['en'] = "Increases the base rank of recruitable units by 2 in 'Cao Cao' faction.",
					['zh'] = "將“曹操”派系中可招募單位的基礎等級提高2。",
					['cn'] = "将“曹操”派系中可招募单位的基础等级提高2。",
				}
			},
			{
				usages = {
					['en'] = "ef_recruit_rank, Cao Cao, 0",
					['kr'] = "ef_recruit_rank, 조조, 0",
					['zh'] = "ef_recruit_rank, 曹操, 0",
					['cn'] = "ef_recruit_rank, 曹操, 0",
				},
				descriptions = {
					['kr'] = "'조조' 세력에게 부여된 모집 유닛 랭크 효과를 제거합니다.",
					['en'] = "Removes 'increase base rank of recruitable units' effect from 'Cao Cao' faction.",
					['zh'] = "從“曹操”派系中移除“增加可招募單位的基礎等級”效果。",
					['cn'] = "从“曹操”派系中移除“增加可招募单位的基础等级”效果。",
				}
			},
		},
	},
	['ef_retinue_upkeep'] = {
		brief = {
			['kr'] = "지정한 세력(범위)의 부대 유지비를 감소시킵니다",
			['en'] = "Reduces the maintenance cost of armies in the specified faction(range).",
			['zh'] = "降低指定派系（範圍）軍隊的維護成本。",
			['cn'] = "降低指定派系（范围）军队的维护成本。",
		},
		examples = {
			{
				usages = {
					['en'] = "ef_retinue_upkeep, faction/player/all/others,  0 / 10/20/30/40/50",
					['kr'] = "ef_retinue_upkeep, 세력/player/all/others,  0 / 10/20/30/40/50",
					['zh'] = "ef_retinue_upkeep, 派系/player/all/others,  0 / 10/20/30/40/50",
					['cn'] = "ef_retinue_upkeep, 派系/player/all/others,  0 / 10/20/30/40/50",
				},
				descriptions = {
					['kr'] = "지정한 세력(범위)에 해당하는 세력의 부대 유지비를 감소시킵니다.",
					['en'] = "Reduces the maintenance cost of armies in the specified faction(range).",
					['zh'] = "降低指定派系（範圍）軍隊的維護成本。",
					['cn'] = "降低指定派系（范围）军队的维护成本。",
				}
			},
			{
				usages = {
					['en'] = "ef_retinue_upkeep, Cao Cao, 20",
					['kr'] = "ef_retinue_upkeep, 조조, 20",
					['zh'] = "ef_retinue_upkeep, 曹操, 20",
					['cn'] = "ef_retinue_upkeep, 曹操, 20",
				},
				descriptions = {
					['kr'] = "'조조' 세력의 부대 세력의 부대 유지비를 20% 감소시킵니다.",
					['en'] = "Reduces the maintenance cost of armies by 20% in 'Cao Cao' faction.",
					['zh'] = "將“曹操”派系的軍隊維護成本降低20%。",
					['cn'] = "将“曹操”派系的军队维护成本降低20%。",
				}
			},
			{
				usages = {
					['en'] = "ef_retinue_upkeep, Cao Cao, 0",
					['kr'] = "ef_retinue_upkeep, 조조, 0",
					['zh'] = "ef_retinue_upkeep, 曹操, 0",
					['cn'] = "ef_retinue_upkeep, 曹操, 0",
				},
				descriptions = {
					['kr'] = "'조조' 세력에게 부여된 부대 유지비를 감소 효과를 제거합니다.",
					['en'] = "Removes the reduce maintenance cost effect of 'Cao Cao' faction.",
					['zh'] = "移除“曹操”派系降低維護成本的效果",
					['cn'] = "移除“曹操”派系降低维护成本的效果",
				}
			},
		},
	},
	['ef_deploy_cost'] = {
		brief = {
			['kr'] = "지정한 세력(범위)의 부대 배치 비용을 감소시킵니다.",
			['en'] = "Reduces the deployment cost of armies in the specified faction(range).",
			['zh'] = "降低指定派系（範圍）軍隊的部署成本。",
			['cn'] = "降低指定派系（范围）军队的部署成本。",
		},
		examples = {
			{
				usages = {
					['en'] = "ef_deploy_cost, faction/player/all/others,  0 / 10/20/30/40/50",
					['kr'] = "ef_deploy_cost, 세력/player/all/others,  0 / 10/20/30/40/50",
					['zh'] = "ef_deploy_cost, 派系/player/all/others,  0 / 10/20/30/40/50",
					['cn'] = "ef_deploy_cost, 派系/player/all/others,  0 / 10/20/30/40/50",
				},
				descriptions = {
					['kr'] = "지정한 세력(범위)에 해당하는 세력의 부대 배치 비용을 감소시킵니다.",
					['en'] = "Reduces the deployment cost of armies in the specified faction(range).",
					['zh'] = "降低指定派系（範圍）軍隊的部署成本。",
					['cn'] = "降低指定派系（范围）军队的部署成本。",
				}
			},
			{
				usages = {
					['en'] = "ef_deploy_cost, Cao Cao, 20",
					['kr'] = "ef_deploy_cost, 조조, 20",
					['zh'] = "ef_deploy_cost, 曹操, 20",
					['cn'] = "ef_deploy_cost, 曹操, 20",
				},
				descriptions = {
					['kr'] = "'조조' 세력의 부대 세력의 부대 배치 비용을 20% 감소시킵니다.",
					['en'] = "Reduces the deployment cost of armies by 20% in 'Cao Cao' faction.",
					['zh'] = "“曹操”派系軍隊部署成本降低20%。",
					['cn'] = "“曹操”派系军队部署成本降低20%。",
				}
			},
			{
				usages = {
					['en'] = "ef_deploy_cost, Cao Cao, 0",
					['kr'] = "ef_deploy_cost, 조조, 0",
					['zh'] = "ef_deploy_cost, 曹操, 0",
					['cn'] = "ef_deploy_cost, 曹操, 0",
				},
				descriptions = {
					['kr'] = "'조조' 세력에게 부여된 부대 배치 비용 감소 효과를 제거합니다.",
					['en'] = "Removes the reduce deployment cost effect of 'Cao Cao' faction.",
					['zh'] = "移除“曹操”派系降低部署成本的效果。",
					['cn'] = "移除“曹操”派系降低部署成本的效果。",
				}
			},
		},
	},
	['ef_salary'] = {
		brief = {
			['kr'] = "지정한 세력(범위)의 봉록 비용을 감소시킵니다",
			['en'] = "Reduces the salaries of all heroes in the specified faction(range).",
			['zh'] = "降低指定派系（範圍）內所有英雄的薪餉。",
			['cn'] = "降低指定派系（范围）内所有英雄的薪餉。",
		},
		examples = {
			{
				usages = {
					['en'] = "ef_salary, faction/player/all/others,  0 / 10/20/30 ~ 100",
					['kr'] = "ef_salary, 세력/player/all/others,  0 / 10/20/30 ~ 100",
					['zh'] = "ef_salary, 派系/player/all/others,  0 / 10/20/30 ~ 100",
					['cn'] = "ef_salary, 派系/player/all/others,  0 / 10/20/30 ~ 100",
				},
				descriptions = {
					['kr'] = "지정한 세력(범위)에 해당하는 세력의 봉록 비용을 감소시킵니다.",
					['en'] = "Reduces the salaries of all heroes in the specified faction(range).",
					['zh'] = "降低指定派系（範圍）內所有英雄的薪餉。",
					['cn'] = "降低指定派系（范围）内所有英雄的薪餉。",
				}
			},
			{
				usages = {
					['en'] = "ef_salary, Cao Cao, 20",
					['kr'] = "ef_salary, 조조, 20",
					['zh'] = "ef_salary, 曹操, 20",
					['cn'] = "ef_salary, 曹操, 20",
				},
				descriptions = {
					['kr'] = "'조조' 세력의 부대 세력의 봉록 비용을 20% 감소시킵니다.",
					['en'] = "Reduces the salaries of all heroes by 20% in 'Cao Cao' faction.",
					['zh'] = "降低“曹操”派系所有英雄的薪餉20%。",
					['cn'] = "降低“曹操”派系所有英雄的薪餉20%。",
				}
			},
			{
				usages = {
					['en'] = "ef_salary, Cao Cao, 100",
					['kr'] = "ef_salary, 조조, 100",
					['zh'] = "ef_salary, 曹操, 100",
					['cn'] = "ef_salary, 曹操, 100",
				},
				descriptions = {
					['kr'] = "'조조' 세력의 부대 세력의 봉록 비용을 '0'으로 만듭니다.",
					['en'] = "Reduces the total salary cost of 'Cao Cao' faction to zero.",
					['zh'] = "將“曹操”派系的總薪餉成本降低到零。",
					['cn'] = "将“曹操”派系的总薪餉成本降低到零。",
				}
			},
			{
				usages = {
					['en'] = "ef_salary, Cao Cao, 0",
					['kr'] = "ef_salary, 조조, 0",
					['zh'] = "ef_salary, 曹操, 0",
					['cn'] = "ef_salary, 曹操, 0",
				},
				descriptions = {
					['kr'] = "'조조' 세력에게 부여된 봉록 비용 감소 효과를 제거합니다.",
					['en'] = "Removes the reduce salary cost effect of 'Cao Cao' faction.",
					['zh'] = "移除“曹操”派系的降低薪餉成本效果。",
					['cn'] = "移除“曹操”派系的降低薪餉成本效果",
				}
			},
		},
	},
	['ef_satisfaction'] = {
		brief = {
			['kr'] = "지정한 세력(범위)에 소속된 장수들의 만족도를 올려줍니다.",
			['en'] = "Increases the satisfaction rate of all heroes in the specified faction(range).",
			['zh'] = "提高指定陣營（範圍）內所有英雄的滿意度。",
			['cn'] = "提高指定阵营（范围）内所有英雄的满意度。",
		},
		examples = {
			{
				usages = {
					['en'] = "ef_satisfaction, faction/player/all/others,  0 / 10/20/30/40",
					['kr'] = "ef_satisfaction, 세력/player/all/others,  0 / 10/20/30/40",
					['zh'] = "ef_satisfaction, 派系/player/all/others,  0 / 10/20/30/40",
					['cn'] = "ef_satisfaction, 派系/player/all/others,  0 / 10/20/30/40",
				},
				descriptions = {
					['kr'] = "지정한 세력(범위)에 해당하는 세력에 소속된 장수들의 만족도를 올려줍니다.",
					['en'] = "Increases the satisfaction rate of all heroes in the specified faction(range).",
					['zh'] = "提高指定陣營（範圍）內所有英雄的滿意度。",
					['cn'] = "提高指定阵营（范围）内所有英雄的满意度。",
				}
			},
			{
				usages = {
					['en'] = "ef_satisfaction, Cao Cao, 20",
					['kr'] = "ef_satisfaction, 조조, 20",
					['zh'] = "ef_satisfaction, 曹操, 20",
					['cn'] = "ef_satisfaction, 曹操, 20",
				},
				descriptions = {
					['kr'] = "'조조' 세력에 소속된 장수들의 만족도를 20 올려줍니다.",
					['en'] = "Increases the satisfaction rate of all heroes by 20 in 'Cao Cao' faction.",
					['zh'] = "“曹操”派系所有英雄的滿意度提高20。",
					['cn'] = "“曹操”派系所有英雄的满意度提高20。",
				}
			},
			{
				usages = {
					['en'] = "ef_satisfaction, Cao Cao, 0",
					['kr'] = "ef_satisfaction, 조조, 0",
					['zh'] = "ef_satisfaction, 曹操, 0",
					['cn'] = "ef_satisfaction, 曹操, 0",
				},
				descriptions = {
					['kr'] = "'조조' 세력에게 부여된 만족도 증가 효과를 제거합니다.",
					['en'] = "Removes the increase satisfaction rate effect of 'Cao Cao' faction.",
					['zh'] = "移除“曹操”派系增加滿意度的效果。",
					['cn'] = "移除“曹操”派系增加满意度的效果。",
				}
			},
		},
	},
	['ef_job_satisfaction'] = {
		brief = {
			['kr'] = "지정한 세력(범위)에 소속된 장수들의 승진 욕구 감소 효과를 부여합니다.",
			['en'] = "Grants an reduce desire for promotion effect to the specified faction(range).",
			['zh'] = "授予指定派系（範圍）降低晉升慾望的效果。",
			['cn'] = "授予指定派系（范围）降低晋升欲望的效果。",
		},
		examples = {
			{
				usages = {
					['en'] = "ef_job_satisfaction, faction/player/all/others,  0 / 1 / 2",
					['kr'] = "ef_job_satisfaction, 세력/player/all/others,  0 / 1 / 2",
					['zh'] = "ef_job_satisfaction, 派系/player/all/others,  0 / 1 / 2",
					['cn'] = "ef_job_satisfaction, 派系/player/all/others,  0 / 1 / 2",
				},
				descriptions = {
					['kr'] = "지정한 세력(범위)에 해당하는 세력에 소속된 장수들의 승진 욕구를 제거/감소/무시 합니다",
					['en'] = "Grants a reduce desire for promotion effect to the specified faction(range).",
					['zh'] = "授予指定派系（範圍）降低晉升慾望的效果。",
					['cn'] = "授予指定派系（范围）降低晋升欲望的效果。",
				}
			},
			{
				usages = {
					['en'] = "ef_job_satisfaction, Cao Cao, 1",
					['kr'] = "ef_job_satisfaction, 조조, 1",
					['zh'] = "ef_job_satisfaction, 曹操, 1",
					['cn'] = "ef_job_satisfaction, 曹操, 1",
				},
				descriptions = {
					['kr'] = "'조조' 세력에 소속된 장수들의 승진 욕구를 절반으로 감소 시킵니다.",
					['en'] = "Reduces the desire for promotion of all heroes by half in 'Cao Cao' faction.",
					['zh'] = "將“曹操”派系中所有英雄的晉升願望降低一半。",
					['cn'] = "将“曹操”派系中所有英雄的晋升愿望降低一半。",
				}
			},
			{
				usages = {
					['en'] = "ef_job_satisfaction, Cao Cao, 2",
					['kr'] = "ef_job_satisfaction, 조조, 2",
					['zh'] = "ef_job_satisfaction, 曹操, 2",
					['cn'] = "ef_job_satisfaction, 曹操, 2",
				},
				descriptions = {
					['kr'] = "'조조' 세력에 소속된 장수들의 승진 욕구를 무시합니다.",
					['en'] = "Ignores the desire for promotion of all heroes in 'Cao Cao' faction.",
					['zh'] = "忽略“曹操”派系所有英雄的晉升願望。",
					['cn'] = "忽略“曹操”派系所有英雄的晋升愿望。",
				}
			},
			{
				usages = {
					['en'] = "ef_job_satisfaction, Cao Cao, 0",
					['kr'] = "ef_job_satisfaction, 조조, 0",
					['zh'] = "ef_job_satisfaction, 曹操, 0",
					['cn'] = "ef_job_satisfaction, 曹操, 0",
				},
				descriptions = {
					['kr'] = "'조조' 세력에게 부여된 승진 욕구 효과를 제거합니다.",
					['en'] = "Removes the reduce desire for promotion effect of 'Cao Cao' faction.",
					['zh'] = "移除“曹操”派係對晉升效果的降低慾望。",
					['cn'] = "移除“曹操”派系对晋升效果的降低欲望。",
				}
			},
		},
	},
	['alias'] = {
		brief = {
			['kr'] = "아이템의 키 값으로 아이템의 '별칭'을 등록합니다.",
			['en'] = "Register the item's 'alias' with the ceo-key of the item.",
			['zh'] = "使用項目的 ceo-key 註冊項目的‘別名’。",
			['cn'] = "使用项目的 ceo-key 注册项目的‘别名’。",
		},
		examples = {
			{
				usages = {
					['en'] = "alias, lunchpail, 3k_mtu_ancillary_empty_lunchpail",
					['kr'] = "alias, 빈찬합, 3k_mtu_ancillary_empty_lunchpail",
					['zh'] = "alias, 空飯盒, 3k_mtu_ancillary_empty_lunchpail",
					['cn'] = "alias, 空饭盒, 3k_mtu_ancillary_empty_lunchpail",
				},
				descriptions = {
					['kr'] = "MTU 모드의 '빈찬합' 아이템의 키 값을 등록합니다.",
					['en'] = "Register a 'lunchpail' with a MTU mod item's ceo-key.",
					['zh'] = "使用 MTU mod的 CEO-key 註冊‘空飯盒’。",
					['cn'] = "使用 MTU mod的 CEO-key 注册‘空饭盒’。",
				}
			},
		},
	},
	['find_item'] = {
		brief = {
			['kr'] = "아이템이 맵 상에 존재하는 지를 검색하고, 보유 영웅 또는 보유 세력을 알려줍니다.",
			['en'] = "Searches if an item exists on the map, and notify you which hero or faction have it.",
			['zh'] = "搜索地圖上是否存在物品，並通知您哪個英雄或派系擁有該物品。",
			['cn'] = "搜索地图上是否存在物品，并通知您哪个英雄或派系拥有该物品。",
		},
		examples = {
			{
				usages = {
					['en'] = "find_item, shadow runner",
					['kr'] = "find_item, 절영",
					['zh'] = "find_item, 絕影",
					['cn'] = "find_item, 绝影",
				},
				descriptions = {
					['kr'] = "'절영' 아이템이 생성 되어 맵에 존재하는 지를 검색합니다.",
					['en'] = "Search whether the 'Shadow Runner' item is created and exists on the map and notify the result.",
					['zh'] = "搜索‘絕影’項目是否已創建並存在於地圖上並通知結果。",
					['cn'] = "搜索‘绝影’项目是否已创建并存在于地图上并通知结果。",
				}
			},
			{
				usages = {
					['en'] = "find_item, 3k_mtu_ancillary_weapon_phoenix_beak_faction",
				},
				descriptions = {
					['kr'] = "MTU 모드의 '봉취도' 아이템의 키 값으로 맵 상에 존재하는 지 검색합니다.",
					['en'] = "Search item by ceo-key. ex) Phoenix Beak (MTU)",
					['zh'] = "按 ceo-key 搜索項目。 例如）鳳喙刀（MTU）",
					['cn'] = "按 ceo-key 搜索项目。 例如）凤喙刀（MTU）",
				}
			},
		},
	},
	['give_item'] = {
		brief = {
			['kr'] = "아이템을 세력에 생성합니다. 유니크 아이템의 경우 이미 존재하면 이 명령은 실패합니다.",
			['en'] = "Creates items in factions. For unique items, this command will fail if it already exist on map.",
			['zh'] = "在指定的派系中創建物品。對於獨特的物品，如果地圖上已經存在，則此命令將失敗。",
			['cn'] = "在指定的派系中创建物品。对于独特的物品，如果地图上已经存在，则此命令将失败。",
		},
		examples = {
			{
				usages = {
					['en'] = "give_item, Shadow Runner",
					['kr'] = "give_item, 절영",
					['zh'] = "give_item, 絕影",
					['cn'] = "give_item, 绝影",
				},
				descriptions = {
					['kr'] = "'절영' 아이템을 아군에 생성합니다.",
					['en'] = "Create a 'Shadow Runner' item at player faction.",
					['zh'] = "在玩家派系中創建一個‘絕影’項目。",
					['cn'] = "在玩家派系中创建一个‘绝影’项目。",
				}
			},
			{
				usages = {
					['en'] = "give_item, Cao Cao, shadow_runner",
					['kr'] = "give_item, 조조, 절영",
					['zh'] = "give_item, 曹操, 絕影",
					['cn'] = "give_item, 曹操, 绝影",
				},
				descriptions = {
					['kr'] = "'조조'세력에 '절영' 아이템을 생성합니다.",
					['en'] = "Create a 'Shadow Runner' item at 'Cao Cao' faction.",
					['zh'] = "在“曹操”派系中創建一個‘絕影’項目。",
					['cn'] = "在“曹操”派系中创建一个‘绝影’项目。",
				}
			},
			{
				usages = {
					['en'] = "give_item, shadow_runner, Cao Cao",
					['kr'] = "give_item, 절영, 조조",
					['zh'] = "give_item, 絕影, 曹操",
					['cn'] = "give_item, 绝影, 曹操",
				},
				descriptions = {
					['kr'] = "'조조'세력에 '절영' 아이템을 생성합니다.",
					['en'] = "Create a 'Shadow Runner' item at 'Cao Cao' faction.",
					['zh'] = "在“曹操”派系中創建一個‘絕影’項目。",
					['cn'] = "在“曹操”派系中创建一个‘绝影’项目。",
				}
			},
			{
				usages = {
					['en'] = "give_item, cao_cao, Book of Mountains & Seas, 3",
					['kr'] = "give_item, 조조, 산해경",
					['zh'] = "give_item, 曹操, 山海經",
					['cn'] = "give_item, 曹操, 山海经",
				},
				descriptions = {
					['kr'] = "'조조'세력에 '산해경' 아이템 3개를 수여합니다.",
					['en'] = "Gives 3 'Book of Mountains & Seas' items to the 'Cao Cao' faction.",
					['zh'] = "給“曹操”派系3個‘山海經’物品。",
					['cn'] = "给“曹操”派系3个‘山海经’物品。",
				}
			},
			{
				usages = {
					['en'] = "give_item, 3k_mtu_ancillary_weapon_phoenix_beak_faction",
				},
				descriptions = {
					['kr'] = "MTU 모드의 '봉취도' 아이템의 키 값으로 아이템을 아군에 생성합니다.",
					['en'] = "Creates an item by ceo-key. ex) Phoenix Beak (MTU)",
					['zh'] = "通過 ceo-key 創建項目。 例如）鳳喙刀（MTU）",
					['cn'] = "通过 ceo-key 创建项目。 例如）凤喙刀（MTU）",
				}
			},
		},
	},
	['give_set'] = {
		brief = {
			['kr'] = "아이템 세트를 세력에 수여합니다.",
			['en'] = "Offer a set of items to the designated faction.",
			['zh'] = "向指定派系提供一套物品。",
			['cn'] = "向指定派系提供一套物品。",
		},
		examples = {
			{
				usages = {
					['en'] = "give_set, Knowledge of Heaven",
					['kr'] = "give_set, 하늘의 지식",
					['zh'] = "give_set, 天文知識",
					['cn'] = "give_set, 天文知識",
				},
				descriptions = {
					['kr'] = "바닐라 DB에 정의된 '예언자'와 '천구' 아이템 세트를 아군에 생성 합니다.",
					['en'] = "Offers the 'Diviner' and 'Celestial Sphere' item sets defined in the vanilla DB to player faction.",
					['zh'] = "向玩家派系提供在原版DB中定義的‘卦師’和‘渾天儀’物品集。",
					['cn'] = "向玩家派系提供在原版DB中定义的‘卜者’和‘浑天仪’物品集。",
				}
			},
			{
				usages = {
					['en'] = "give_set, player, Knowledge of Heaven",
					['kr'] = "give_set, player, 하늘의 지식",
					['zh'] = "give_set, player, 天文知識",
					['cn'] = "give_set, player, 天文知識",
				},
				descriptions = {
					['kr'] = "바닐라 DB에 정의된 '예언자'와 '천구' 아이템 세트를 아군에 생성 합니다.",
					['en'] = "Offers the 'Diviner' and 'Celestial Sphere' item sets defined in the vanilla DB to player faction.",
					['zh'] = "向玩家派系提供在原版DB中定義的‘卦師’和‘渾天儀’物品集。",
					['cn'] = "向玩家派系提供在原版DB中定义的‘卜者’和‘浑天仪’物品集。",
				}
			},
			{
				usages = {
					['en'] = "give_set, Cao Cao, Knowledge of Heaven",
					['kr'] = "give_set, 조조, 하늘의 지식",
					['zh'] = "give_set, 曹操, 天文知識",
					['cn'] = "give_set, 曹操, 天文知識",
				},
				descriptions = {
					['kr'] = "바닐라 DB에 정의된 '예언자'와 '천구' 아이템 세트를 '조조'세력에 생성 합니다.",
					['en'] = "Offers the 'Diviner' and 'Celestial Sphere' item sets defined in the vanilla DB to 'Cao Cao' faction.",
					['zh'] = "向“曹操”派系提供在原版DB中定義的‘卦師’和‘渾天儀’物品集。",
					['cn'] = "向“曹操”派系提供在原版DB中定义的‘卜者’和‘浑天仪’物品集。",
				}
			},
		},
	},
	['remove_item'] = {
		brief = {
			['kr'] = "지정한 세력에게서 지정한 아이템을 주어진 수량만큼 제거합니다.",
			['en'] = "Removes the specified amount of the specified item from the designated faction.",
			['zh'] = "從指定派系中移除指定數量的指定項目。",
			['cn'] = "从指定派系中移除指定数量的指定项目。",
		},
		examples = {
			{
				usages = {
					['en'] = "remove_item, Celestial Sphere",
					['kr'] = "remove_item, 절영",
					['zh'] = "remove_item, 渾天儀",
					['cn'] = "remove_item, 浑天仪",
				},
				descriptions = {
					['kr'] = "아군 세력에서 아이템 '절영'을 제거합니다.(기본 아군)",
					['en'] = "Removes the item 'Celestial Sphere' from player faction.(default player)",
					['zh'] = "從玩家派系中刪除項目‘渾天儀’。",
					['cn'] = "从玩家派系中删除项目‘浑天仪’。",
				}
			},
			{
				usages = {
					['en'] = "remove_item, player, Celestial Sphere",
					['kr'] = "remove_item, player, 절영",
					['zh'] = "remove_item, player, 渾天儀",
					['cn'] = "remove_item, player, 浑天仪",
				},
				descriptions = {
					['kr'] = "아군 세력에서 아이템 '절영'을 제거합니다.",
					['en'] = "Removes the item 'Celestial Sphere' from player faction.",
					['zh'] = "從玩家派系中刪除項目‘渾天儀’。",
					['cn'] = "从玩家派系中删除项目‘浑天仪’。",
				}
			},
			{
				usages = {
					['en'] = "remove_item, Cao Cao, War Axe, 10",
					['kr'] = "remove_item, 조조, 전쟁 도끼, 10",
					['zh'] = "remove_item, 曹操, 戰斧, 10",
					['cn'] = "remove_item, 曹操, 战斧, 10",
				},
				descriptions = {
					['kr'] = "'조조' 세력에서 아이템 '전쟁 도끼'를 10개 제거합니다.",
					['en'] = "Removes 10 pieces of 'War Axe' item from the 'Cao Cao' faction.",
					['zh'] = "從“曹操”派系中移除 10 件‘戰斧’物品。",
					['cn'] = "从“曹操”派系中移除 10 件‘战斧’物品。",
				}
			},
		},
	},
	['all_item'] = {
		brief = {
			['kr'] = "지정한 세력에게 아이템 분류에 해당하는 모든 아이템을 수여합니다.",
			['en'] = "All items corresponding to the item category will be offered to the designated faction.",
			['zh'] = "與物品類別相對應的所有物品都將提供給指定的派系。",
			['cn'] = "与物品类别相对应的所有物品都将提供给指定的派系。",
		},
		examples = {
			{
				usages = {
					['en'] = "all_item, dlc.tier.class, faction/player, count",
					['kr'] = "all_item, dlc.등급.종류, 세력/player, 수량",
					['zh'] = "all_item, dlc.等級.類型, 派系/player, 計數",
					['cn'] = "all_item, dlc.等级.类型, 派系/player, 计数",
				},
				descriptions = {
					['kr'] = "지정한 세력에게 아이템 분류에 해당하는 모든 아이템을 수량만큼 수여합니다.",
					['en'] = "All items that under the item category are offered to the designated faction by the specified quantity.",
					['zh'] = "物品類別下的所有物品都以指定數量提供給指定派系。",
					['cn'] = "物品类别下的所有物品都以指定数量提供给指定派系。",
				},
			},
			{
				usages = {
					['en'] = "all_item, all",
				},
				descriptions = {
					['kr'] = "아군에게 모든 바닐라 아이템 1개씩 수여합니다.",
					['en'] = "Offers player faction all vanilla item by one.",
					['zh'] = "為玩家派系提供所有原版物品一件。",
					['cn'] = "为玩家派系提供一件所有原创物品。",
				}
			},
			{
				usages = {
					['en'] = "all_item, main",
				},
				descriptions = {
					['kr'] = "아군에게 'main' 캠페인 아이템 모두를 1개씩 수여합니다.",
					['en'] = "All 'Three Kingdoms Early' campaign items are offered to player faction by one piece each.",
					['zh'] = "所有“豪杰蜂起”DLC項目均以一件為單位提供給玩家派系。",
					['cn'] = "所有“豪杰蜂起”DLC项目均以一件为单位提供给玩家派系。",
				}

			},
			{
				usages = {
					['en'] = "all_item, moh.unique, Han Dynasty, 2",
					['kr'] = "all_item, moh.unique, 황실, 2",
					['zh'] = "all_item, moh.unique, 漢朝, 2",
					['cn'] = "all_item, moh.unique, 汉朝, 2",
				},
				descriptions = {
					['kr'] = "'황실' 세력에 '천명' 캠페인의 '고유' 아이템 2개씩 수여합니다.",
					['en'] = "All 'unique' tier items from the 'Mandate of Heaven' campaign are offered to the 'Han Dynasty' faction 2 pieces each.",
					['zh'] = "“天命”DLC中的所有“獨特”等級物品都提供給“漢朝”派系，每件2件。",
					['cn'] = "“天命”DLC中的所有“独特”等级物品都提供给“汉朝”派系，每件2件。",
				}
			},
			{
				usages = {
					['en'] = "all_item, all.exceptional.follower, Cao Cao",
					['kr'] = "all_item, all.exceptional.follower, 조조",
					['zh'] = "all_item, all.exceptional.follower, 曹操",
					['cn'] = "all_item, all.exceptional.follower, 曹操",
				},
				descriptions = {
					['kr'] = "'조조' 세력에 모든 '고급' 추종자 아이템을 1개씩 수여합니다.",
					['en'] = "Offers each one piece of the exceptional 'follower' item in all items to 'Cao Cao' faction.",
					['zh'] = "向“曹操”派系提供所有物品中的每件卓越“隨從”物品。",
					['cn'] = "向“曹操”派系提供所有物品中的每件优异“随从”物品。",
				}
			},
			{
				usages = {
					['en'] = "all_item, all.refined.weapon, player, 5",
				},
				descriptions = {
					['kr'] = "플레이어 세력에 모든 아이템 중 '제련(중급)' 등급의 무기 아이템을 5개씩 수여합니다.",
					['en'] = "5 pieces of each item of 'Weapon' class of 'Refined' tier among all items are offered to player faction.",
					['zh'] = "所有物品中“高級”等級的“武器”類每件物品 5 件提供給玩家派系。",
					['cn'] = "所有物品中“精制”等级的“武器”类每件物品 5 件提供给玩家派系。",
				}
			},
		},
	},
	['steal'] = {
		brief = {
			['kr'] = "지정한 아이템을 대상 세력 또는 영웅으로부터 탈취합니다.",
			['en'] = "Steals the specified item from the target faction or hero.",
			['zh'] = "從目標派系或英雄那裡竊取指定物品。",
			['cn'] = "从目标派系或英雄那里窃取指定物品。",
		},
		examples = {
			{
				usages = {
					['en'] = "steal, Cao Cao, Shadow Runner",
					['kr'] = "steal, 조조, 절영",
					['zh'] = "steal, 曹操, 絕影",
					['cn'] = "steal, 曹操, 絕影",
				},
				descriptions = {
					['kr'] = "아이템 '절영'을 '조조' 또는 '조조' 세력으로부터 탈취합니다.",
					['en'] = "Steal the item 'Shadow Runner' from the 'Cao Cao' or 'Cao Cao' faction.",
					['zh'] = "從“曹操”或“曹操”派系竊取物品“絕影”。",
					['cn'] = "从“曹操”或“曹操”派系窃取物品“绝影”。",
				}
			},
		},
	},
	['equip'] = {
		brief = {
			['kr'] = "대상 영웅에게 아이템을 장착 시킵니다.",
			['en'] = "Equip the target hero with an item.",
			['zh'] = "",
			['cn'] = "",
		},
		examples = {
			{
				usages = {
					['en'] = "equip, Cao Cao, Shadow Runner",
					['kr'] = "equip, 조조, 절영",
				},
				descriptions = {
					['kr'] = "아이템 '절영'을 '조조'에게 장착 시킵니다.",
					['en'] = "Equip 'Cao Cao' with an 'Shadow Runner'",
					['zh'] = "",
					['cn'] = "",
				}
			},
		},
	},
	['heroes'] = {
		brief = {
			['kr'] = "대상 세력의 영웅 리스트를 로그로 출력합니다.",
			['en'] = "Outputs the list of heroes of the target faction as a log.",
			['zh'] = "以日誌形式輸出目標陣營的英雄列表。",
			['cn'] = "以日志形式输出目标阵营的英雄列表。",
		},
		examples = {
			{
				usages = {
					['en'] = "heroes",
				},
				descriptions = {
					['kr'] = "아군 세력의 장수 리스크를 로그로 출력합니다.",
					['en'] = "Outputs the list of heroes of player faction as a log.",
					['zh'] = "輸出玩家陣營英雄列表作為日誌。",
					['cn'] = "输出玩家阵营英雄列表作为日志。",
				}
			},
			{
				usages = {
					['en'] = "heroes, Cao Cao",
					['kr'] = "heroes, 조조",
					['zh'] = "heroes, 曹操",
					['cn'] = "heroes, 曹操",
				},
				descriptions = {
					['kr'] = "'조조' 세력의 장수들 정보를 로그로 출력합니다.",
					['en'] = "Outputs the information of the generals of the 'Cao Cao' faction as a log.",
					['zh'] = "將“曹操”派係將領的信息作為日誌輸出。",
					['cn'] = "将“曹操”派系将领的信息作为日志输出。",
				}
			},
			{
				usages = {
					['en'] = "heroes, dead",
				},
				descriptions = {
					['kr'] = "사망한 역사 영웅들의 리스트를 로그로 출력합니다.",
					['en'] = "Outputs a list of dead historical heroes as a log.",
					['zh'] = "輸出已故歷史英雄列表作為日誌。",
					['cn'] = "输出已故历史英雄列表作为日志。",
				}
			},
			{
				usages = {
					['en'] = "heroes, pool",
				},
				descriptions = {
					['kr'] = "임관 대기 중인 역사 영웅들의 리스트를 로그로 출력합니다.",
					['en'] = "Outputs a list of historical heroes waiting for recruitment as a log.",
					['zh'] = "以日誌形式輸出等待招募的歷史英雄列表。",
					['cn'] = "以日志形式输出等待招募的历史英雄列表。",
				}
			},
		},
	},
	['can_federate'] = {
		brief = {
			['kr'] = "대상 세력들간에 합병이 가능한 지 조사합니다.",
			['en'] = "Investigates whether it is possible to confederate between the target factions.",
			['zh'] = "調查是否有可能在目標派系之間結盟。",
			['cn'] = "调查是否有可能在目标派系之间结盟。",
		},
		examples = {
			{
				usages = {
					['en'] = "can_federate, Liu Biao, Yuan Shu",
					['kr'] = "can_federate, 유표, 원술",
					['zh'] = "can_federate, 劉豹, 袁術",
					['cn'] = "can_federate, 刘豹, 袁术",
				},
				descriptions = {
					['kr'] = "'유표' 세력이 '원술' 세력을 합병할 수 있는 지 알아봅니다.",
					['en'] = "Checks if the 'Liu Biao' faction can merge the 'Yuan Shu' faction.",
					['zh'] = "檢查“劉表”派係是否可以合併“袁術”派系。",
					['cn'] = "检查“刘表”派系是否可以合并“袁术”派系。",
				}
			},
		},
	},
	['federate'] = {
		brief = {
			['kr'] = "대상 세력들을 합병 시킵니다.",
			['en'] = "Federates a faction with target faction.",
			['zh'] = "將一個派係與目標派系聯合。",
			['cn'] = "将一个派系与目标派系联合。",
		},
		examples = {
			{
				usages = {
					['en'] = "federate, Liu Biao, Yuan Shu",
					['kr'] = "federate, 유표, 원술",
					['zh'] = "federate, 劉豹, 袁術",
					['cn'] = "federate, 刘豹, 袁术",
				},
				descriptions = {
					['kr'] = "'유표' 세력이 '원술' 세력을 합병합니다.",
					['en'] = "The 'Liu Biao' faction federates the 'Yuan Shu' faction.",
					['zh'] = "“劉表”派系聯合“袁術”派系。",
					['cn'] = "“刘表”派系联合“袁术”派系。",
				}
			},
		},
	},
	['treasury'] = {
		brief = {
			['kr'] = "대상 세력에 자금을 지원 또는 삭감 합니다.",
			['en'] = "Increases or reduces the treasury of target faction.",
			['zh'] = "增加或減少目標派系的金庫。",
			['cn'] = "增加或减少目标派系的金库。",
		},
		examples = {
			{
				usages = {
					['en'] = "treasury, faction/all/others/player, -1,000,000 ~ 1,000,000",
					['kr'] = "treasury, 세력/all/others/player, -1,000,000 ~ 1,000,000",
					['zh'] = "treasury, 派系/all/others/player, -1,000,000 ~ 1,000,000",
					['cn'] = "treasury, 派系/all/others/player, -1,000,000 ~ 1,000,000",
				},
				descriptions = {
					['kr'] = "지정한 세력(범위)에 자금을 지원 또는 삭감합니다.",
					['en'] = "Increases or reduces the treasury of target faction(range) by specified amount.",
					['zh'] = "按指定數量增加或減少目標派系（範圍）的金庫。",
					['cn'] = "按指定数量增加或减少目标派系（范围）的金库。",
				}
			},
			{
				usages = {
					['en'] = "treasury, Han Empire",
					['kr'] = "treasury, 한나라",
					['zh'] = "treasury, 漢朝",
					['cn'] = "treasury, 汉朝",
				},
				descriptions = {
					['kr'] = "'한나라' 세력의 보유 자금을 알려줍니다.",
					['en'] = "Notifies the funds held by the 'Han Dynasty' faction.",
					['zh'] = "顯示“漢朝”派系持有的資金。",
					['cn'] = "显示“汉朝”派系持有的资金。",
				}
			},
			{
				usages = {
					['en'] = "treasury, others, 3000",
				},
				descriptions = {
					['kr'] = "다른 AI 세력들 각각에 3,000 냥씩 지원합니다.",
					['en'] = "Increases 3,000 gold for each of the other AI factions.",
					['zh'] = "為其他每個 AI 派系增加 3,000 金幣。",
					['cn'] = "为其他每个 AI 派系增加 3,000 金币。",
				}
			},
			{
				usages = {
					['en'] = "treasury, Cao Cao, -3000",
					['kr'] = "treasury, 조조, -3000",
					['zh'] = "treasury, 曹操, -3000",
					['cn'] = "treasury, 曹操, -3000",
				},
				descriptions = {
					['kr'] = "'조조' 세력의 자금을 3,000냥 감소 시킵니다.",
					['en'] = "Decreases the funds of the 'Cao Cao' faction by 3,000.",
					['zh'] = "將“曹操”派系的資金減少 3,000。",
					['cn'] = "将“曹操”派系的资金减少 3,000。",
				}
			},
		},
	},
	['capital'] = {
		brief = {
			['kr'] = "대상 세력의 수도를 이전 시킵니다.",
			['en'] = "Relocates the capital of the target faction.",
			['zh'] = "遷移目標陣營的首都。",
			['cn'] = "迁移目标阵营的首都。",
		},
		examples = {
			{
				usages = {
					['en'] = "capital, Liu Biao",
					['kr'] = "capital, 유표",
					['zh'] = "capital, 劉表",
					['cn'] = "capital, 刘表",
				},
				descriptions = {
					['kr'] = "현재 '유표' 세력의 수도를 알려줍니다.",
					['en'] = "Shows the current capital of the 'Liu Biao' faction.",
					['zh'] = "顯示“劉表”派系的當前首都。",
					['cn'] = "显示“刘表”派系的当前首都。",
				}
			},
			{
				usages = {
					['en'] = "capital, Liu Biao, Xiangyang",
					['kr'] = "capital, 유표, 양양",
					['zh'] = "capital, 劉表, 襄陽",
					['cn'] = "capital, 刘表, 襄阳",
				},
				descriptions = {
					['kr'] = "'유표' 세력의 수도를 '양양'으로 이전 시킵니다.",
					['en'] = "Relocates the capital of the 'Liu Biao' faction to 'Xiangyang'.",
					['zh'] = "將“劉表”派的首都遷至“襄陽”。",
					['cn'] = "将“刘表”派的首都迁至“襄阳”。",
				}
			},
		},
	},
	['reform'] = {
		brief = {
			['kr'] = "한문화권 세력(범위)의 개혁 주기를 변경합니다.",
			['en'] = "Changes the reform cycle of the Han sub-cultural faction(range).",
			['zh'] = "改變漢文化派系（範圍）的改革週期。",
			['cn'] = "改变了汉文化派系（范围）的改革周期。",
		},
		examples = {
			{
				usages = {
					['en'] = "reform, faction/all/others/player, 0 ~ 5",
					['kr'] = "reform, 세력/all/others/player, 0 ~ 5",
					['zh'] = "reform, 派系/all/others/player, 0 ~ 5",
					['cn'] = "reform, 派系/all/others/player, 0 ~ 5",
				},
				descriptions = {
					['kr'] = "대상 세력(범위)의 개혁 주기를 변경합니다.",
					['en'] = "Changes the reform cycle of the Han sub-cultural faction(range).",
					['zh'] = "改變漢文化派系（範圍）的改革週期。",
					['cn'] = "改变了汉文化派系（范围）的改革周期。",
				}
			},
			{
				usages = {
					['en'] = "reform, player, 0",
				},
				descriptions = {
					['kr'] = "아군 세력의 현재 진행 중인 개혁을 즉시 완성합니다.",
					['en'] = "Instantly completes player faction's current reform.",
					['zh'] = "立即完成玩家派系當前的改革。",
					['cn'] = "立即完成玩家派系当前的改革。",
				}
			},
			{
				usages = {
					['en'] = "reform, Liu Biao, 3",
					['kr'] = "reform, 유표, 3",
					['zh'] = "reform, 劉表, 3",
					['cn'] = "reform, 刘表, 3",
				},
				descriptions = {
					['kr'] = "'유표' 세력의 개혁 주기를 3턴으로 변경합니다.",
					['en'] = "Changes the reform cycle of the 'Liu Biao' faction to 3 turns.",
					['zh'] = "將“劉表”派系的改革週期改為3輪。",
					['cn'] = "将“刘表”派系的改革周期改为3轮。",
				}
			},
			{
				usages = {
					['en'] = "reform, all, 3",
				},
				descriptions = {
					['kr'] = "모든 한나라 문화권 세력의 개혁 주기를 3턴으로 설정합니다.",
					['en'] = "Set the reform cycle of all factions of Han sub-culture to a 3-turns.",
					['zh'] = "將漢文化各派系的改革週期設為3輪。",
					['cn'] = "将汉文化各派系的改革周期设为3轮。",
				}
			},
		},
	},
	['add_position'] = {
		brief = {
			['kr'] = "대상 세력에 '직위'를 해금 시킵니다.",
			['en'] = "Unlocks a 'Job Title' of the target faction.",
			['zh'] = "解鎖目標派系的“頭銜”。",
			['cn'] = "解锁目标派系的“头衔”。",
		},
		examples = {
			{
				usages = {
					['en'] = "add_position, player, Iron General",
					['kr'] = "add_position, player, 철혈 장군",
					['zh'] = "add_position, player, 鐵將軍",
					['cn'] = "add_position, player, 铁血城隍",
				},
				descriptions = {
					['kr'] = "플레이어 세력의 직위 '철혈장군'을 해금합니다.",
					['en'] = "Unlocks the 'Iron General' title of player faction.",
					['zh'] = "解鎖玩家派系的“鐵將軍”稱號。",
					['cn'] = "解锁玩家派系的“铁血城隍”称号。",
				}
			},
		},
	},
	['turn'] = {
		brief = {
			['kr'] = "현재 턴을 알려줍니다.",
			['en'] = "Shows the current turn.",
			['zh'] = "顯示當前輪",
			['cn'] = "显示当前轮。",
		},
		examples = {
			{
				usages = {
					['en'] = "turn",
				},
				descriptions = {
					['kr'] = "현재 턴을 알려줍니다.",
					['en'] = "Shows the current turn.",
					['zh'] = "顯示當前輪",
					['cn'] = "显示当前轮。",
				}
			},
		},
	},
	['notify'] = {
		brief = {
			['kr'] = "알림 설정을 변경합니다.",
			['en'] = "Change notification settings.",
			['zh'] = "更改通知設置。",
			['cn'] = "更改通知设置。",
		},
		examples = {
			{
				usages = {
					['en'] = "notify.duration, 5",
				},
				descriptions = {
					['kr'] = "알림 지속 시간을 5초로 변경합니다.",
					['en'] = "Change the notification duration to 5 seconds.",
					['zh'] = "將通知持續時間更改為 5 秒。",
					['cn'] = "将通知持续时间更改为 5 秒",
				}
			},
			{
				usages = {
					['en'] = "notify.show, 10",
				},
				descriptions = {
					['kr'] = "최근 알림 10개를 보여줍니다.",
					['en'] = "Shows the 10 most recent notifications.",
					['zh'] = "顯示 10 個最近的通知。",
					['cn'] = "显示 10 个最近的通知。",
				}
			},
			{
				usages = {
					['en'] = "notify.last, true/false",
				},
				descriptions = {
					['kr'] = "매 턴 시작 시 지나간 알림을 보여주기를 켜거나 끕니다.",
					['en'] = "Turn on/off to show past notifications at the start of each turn.",
					['zh'] = "打開/關閉以在每回合開始時顯示過去的通知。",
					['cn'] = "打开/关闭以在每回合开始时显示过去的通知。",
				}
			},
			{
				usages = {
					['en'] = "notify.join, true/false",
				},
				descriptions = {
					['kr'] = "아군 세력에 영웅 합류 알림을 끄거나 켭니다.",
					['en'] = "Turns off/on the notification of joining a hero to player faction.",
					['zh'] = "關閉/打開將英雄加入玩家派系的通知。",
					['cn'] = "关闭/开启将英雄加入玩家派系的通知。",
				}
			},
			{
				usages = {
					['en'] = "notify.died, true/false",
				},
				descriptions = {
					['kr'] = "유명 장수의 사망 알림을 끄거나 켭니다.",
					['en'] = "Turns off/on the notification of death of a famous hero.",
					['zh'] = "關閉/打開著名英雄死亡的通知。",
					['cn'] = "关闭/打开著名英雄死亡的通知。",
				}
			},
			{
				usages = {
					['en'] = "notify.goes_pool, true/false",
				},
				descriptions = {
					['kr'] = "유명 장수의 임관 대기 알림을 끄거나 켭니다.",
					['en'] = "Turns off/on the notification of being in the recruitment pool of a famous hero.",
					['zh'] = "關閉/開啟進入著名英雄招募等待的通知。",
					['cn'] = "关闭/开启进入著名英雄招募等待的通知。",
				}
			},
			--[[
			{
				usages = {
					['en'] = "notify.resign, true/false",
				},
				descriptions = {
					['kr'] = "유명 장수의 하야/추방/방출 알림을 끄거나 켭니다.",
					['en'] = "Turns off/on notifications of 'Banish/Release from service/Leave' of a famous hero.",
					['zh'] = "關閉/打開著名英雄的“撤職/放逐”的通知。",
					['cn'] = "关闭/打开著名英雄的“撤职/放逐”的通知。",
				}
			},
			]]
			{
				usages = {
					['en'] = "notify.comes_of_age, true/false",
				},
				descriptions = {
					['kr'] = "유명 장수의 성년 알림을 끄거나 켭니다.",
					['en'] = "Turns off/on notifications of 'Come of Age' of a famous hero.",
					['zh'] = "關閉/打開著名英雄的“成年”通知。",
					['cn'] = "关闭/打开著名英雄的“成年”通知。",
				}
			},
			{
				usages = {
					['en'] = "notify.occupied, true/false",
				},
				descriptions = {
					['kr'] = "타 세력의 정착지 점령 알림을 끄거나 켭니다.",
					['en'] = "Turns on/off notifications of other factions occupying settlements.",
					['zh'] = "打開/關閉其他派系佔領城鎮的通知。",
					['cn'] = "打开/关闭其他派系占领城镇的通知。",
				}
			},
			{
				usages = {
					['en'] = "notify.federated, true/false",
				},
				descriptions = {
					['kr'] = "타 세력의 합병 알림을 끄거나 켭니다.",
					['en'] = "Turn on/off notifications for federations of other factions.",
					['zh'] = "打開/關閉其他派系聯盟的通知。",
					['cn'] = "打开/关闭其他派系联盟的通知。",
				}
			},
		},
	},
	['out_text'] = {
		brief = {
			['kr'] = "기본 사용자 script 및 db 텍스트 파일을 $(game)/sandbox 디렉토리에 생성합니다.",
			['en'] = "Creates default user script and db text files in '$(game)/sandbox' directory.",
			['zh'] = "在“$(game)/sandbox”目錄中創建默認用戶 script 和 db 文本文件。",
			['cn'] = "在“$(game)/sandbox”目录中创建默认用户 script 和 db 文本文件。",
		},
		examples = {
			{
				usages = {
					['en'] = "out_text",
				},
				descriptions = {
					['kr'] = "기본 script 및 db 파일을 생성합니다.",
					['en'] = "Creates default script and db files.",
					['zh'] = "創建默認 script 和 db 文件。",
					['cn'] = "创建默认 script 和 db 文件。",
				}
			},
			{
				usages = {
					['en'] = "out_text, en",
				},
				descriptions = {
					['kr'] = "기본 'en' 로케일 용 script 및 db 파일을 생성합니다.",
					['en'] = "Creates default script and db files for 'en' locale.",
					['zh'] = "為‘en’語言環境創建默認 script 和 db 文件。",
					['cn'] = "为‘en’语言环境创建默认 script 和 db 文件。",
				}
			},
		},
	},
	['out_log'] = {
		brief = {
			['kr'] = "로그 출력 설정을 변경합니다.",
			['en'] = "Changes log output settings.",
			['zh'] = "更改日誌輸出設置。",
			['cn'] = "更改日志输出设置。",
		},
		examples = {
			{
				usages = {
					['en'] = "out_log",
				},
				descriptions = {
					['kr'] = "현재 로그 출력 상태를 알려줍니다.",
					['en'] = "Shows the current log output status.",
					['zh'] = "顯示當前日誌輸出狀態。",
					['cn'] = "显示当前日志输出状态。",
				}
			},
			{
				usages = {
					['en'] = "out_log, true/false",
				},
				descriptions = {
					['kr'] = "로그 출력을 끄거나 켭니다.",
					['en'] = "Turn log output off or on.",
					['zh'] = "關閉或打開日誌輸出。",
					['cn'] = "关闭或打开日志输出。",
				}
			},
		},
	},
	['log_level'] = {
		brief = {
			['kr'] = "로그 출력 수준을 조절합니다.",
			['en'] = "Changes the log output level.",
			['zh'] = "更改日誌輸出級別。",
			['cn'] = "更改日志输出级别",
		},
		examples = {
			{
				usages = {
					['en'] = "log_level",
				},
				descriptions = {
					['kr'] = "현재 로그 출력 수준을 알려줍니다.",
					['en'] = "Reports the current log output level.",
					['zh'] = "報告當前日誌輸出級別。",
					['cn'] = "报告当前日志输出级别。",
				}
			},
			{
				usages = {
					['en'] = "log_level, 3",
				},
				descriptions = {
					['kr'] = "로그 출력 수준을 3으로 설정합니다.",
					['en'] = "Set the log output level to 3.",
					['zh'] = "將日誌輸出級別設置為 3。",
					['cn'] = "将日志输出级别设置为 3。",
				}
			},
		},
	},
	['reindex'] = {
		brief = {
			['kr'] = "샌드박스 내부 장수 정보의 CQI 번호를 재설정합니다.",
			['en'] = "Reset the CQI number of the hero information inside the Sandbox.",
			['zh'] = "重置‘Sandbox’内英雄信息的CQI编号。",
			['cn'] = "重置‘Sandbox’內英雄信息的CQI編號。",
		},
		examples = {
			{
				usages = {
					['en'] = "reindex",
				},
				descriptions = {
					['kr'] = "현재 샌드박스가 저장하고 있는 장수들의 CQI 번호를 재설정합니다.",
					['en'] = "Reset the CQI number of the hero information inside the Sandbox.",
					['zh'] = "重置‘Sandbox’内英雄信息的CQI编号。",
					['cn'] = "重置‘Sandbox’內英雄信息的CQI編號。",
				}
			},
		},
	},
	['reload'] = {
		brief = {
			['kr'] = "사용자 설정 script 및 db 텍스트 파일을 다시 읽어드립니다.",
			['en'] = "Reloads the user script and db text file.",
			['zh'] = "重新加載用戶 script 和 db 文本文件。",
			['cn'] = "重新加载用户 script 和 db 文本文件。",
		},
		examples = {
			{
				usages = {
					['en'] = "reload",
				},
				descriptions = {
					['kr'] = "샌드박스를 초기화하고 사용자 설정 script 및 db 텍스트 파일을 다시 읽어드립니다.",
					['en'] = "Resets the Sandbox and reloads the user script and db text file.",
					['zh'] = "重置‘Sandbox’並重新加載用戶 script 和 db 文本文件。",
					['cn'] = "重置‘Sandbox’并重新加载用户 script 和 db 文本文件。",
				}
			},
		},
	},
	['batch'] = {
		brief = {
			['kr'] = "샌드박스 명령어가 있는 택스트 파일을 읽어 순차적으로 실행합니다.",
			['en'] = "Reads a text file containing the Sandbox commands and executes them sequentially.",
			['zh'] = "讀取包含‘Sandbox’命令的文本文件並按順序執行它們。",
			['cn'] = "读取包含‘Sandbox’命令的文本文件并按顺序执行它们。",
		},
		examples = {
			{
				usages = {
					['en'] = "batch, batch.txt",
				},
				descriptions = {
					['kr'] = "$(game)/sandbox/batch.txt 파일 속의 샌드박스 명령어들을 순차로 실행합니다.",
					['en'] = "Executes the Sandbox commands in the '$(game)/sandbox/batch.txt' file sequentially.",
					['zh'] = "依次執行 '$(game)/sandbox/batch.txt' 文件中的沙箱命令。",
					['cn'] = "依次执行 '$(game)/sandbox/batch.txt' 文件中的沙箱命令。",
				}
			},
		},
	},
	['locale'] = {
		brief = {
			['kr'] = "샌드박스의 UI 로케일을 변경합니다.",
			['en'] = "Change the UI locale of the Sandbox.",
			['zh'] = "更改沙箱的 UI 語言。",
			['cn'] = "更改沙箱的 UI 语言。",
		},
		examples = {
			{
				usages = {
					['en'] = "locale",
				},
				descriptions = {
					['kr'] = "현재 샌드박스의 UI 로케일을 알려줍니다.",
					['en'] = "Notifies the current UI locale of the Sandbox.",
					['zh'] = "通知當前沙箱的 UI 語言。",
					['cn'] = "通知当前沙箱的 UI 语言。",
				}
			},
			{
				usages = {
					['en'] = "locale, kr",
				},
				descriptions = {
					['kr'] = "샌드박스의 UI 로케일을 'kr'로 변경합니다.",
					['en'] = "Changes the UI locale of the Sandbox to 'kr'.",
					['zh'] = "將沙盒的 UI 語言更改為“kr”。",
					['cn'] = "将沙盒的 UI 语言更改为“kr”。",
				}
			},
		},
	},
	['destroy'] = {
		brief = {
			['kr'] = "샌드박스의 UI를 없애고 동작을 멈춥니다.",
			['en'] = "Destroys the Sandbox's UI and stops working.",
			['zh'] = "隱藏‘Sandbox’的用戶界面並停止工作。",
			['cn'] = "隐藏‘Sandbox’的用户界面并停止工作。",
		},
		examples = {
			{
				usages = {
					['en'] = "destroy",
				},
				descriptions = {
					['kr'] = "샌드박스 아이콘을 제거하고, 모든 샌드박스의 동작을 멈춥니다.",
					['en'] = "Destroys the Sandbox's UI and stops working.",
					['zh'] = "隱藏‘Sandbox’的用戶界面並停止工作。",
					['cn'] = "隐藏‘Sandbox’的用户界面并停止工作。",
				}
			},
		},
	},
	['run'] = {
		brief = {
			['kr'] = "외부 LUA 스크립트 파일을 실행합니다.",
			['en'] = "Run an external LUA script file.",
			['zh'] = "運行外部 LUA script 文件。",
			['cn'] = "运行外部 LUA script 文件。",
		},
		examples = {
			{
				usages = {
					['en'] = "run, console_run.lua",
				},
				descriptions = {
					['kr'] = "$(game)/console_run.lua 파일을 로드해서 실행합니다.",
					['en'] = "Loads the '$(game)/console_run.lua' file and executes it.",
					['zh'] = "加載 '$(game)/console_run.lua' 文件並執行它。",
					['cn'] = "加载 '$(game)/console_run.lua' 文件并执行它。",
				}
			},
			{
				usages = {
					['en'] = "run, sandbox/inspect.lua",
				},
				descriptions = {
					['kr'] = "$(game)/sandbox/inspect.lua 파일을 로드해서 실행합니다.",
					['en'] = "Loads the '$(game)/sandbox/inspect.lua' file and executes it.",
					['zh'] = "加載 '$(game)/sandbox/inspect.lua' 文件並執行它。",
					['cn'] = "加载 '$(game)/sandbox/inspect.lua' 文件并执行它。",
				}
			},
		},
	},
	['call'] = {
		brief = {
			['kr'] = "LUA 스크립트 문자열을 실행합니다.",
			['en'] = "Executes a LUA script string.",
			['zh'] = "執行 LUA script 字符串。",
			['cn'] = "执行 LUA script 字符串。",
		},
		examples = {
			{
				usages = {
					['en'] = "call, sandbox_call_func()",
				},
				descriptions = {
					['kr'] = "'sandbox_call_func()' 라는 문자열을 로드하여 실행합니다.",
					['en'] = "Loads and executes the string 'sandbox_call_func()' .",
					['zh'] = "加載並執行字符串 'sandbox_call_func()' 。",
					['cn'] = "加载并执行字符串 'sandbox_call_func()' 。",
				}
			},
			{
				usages = {
					['en'] = "call, logger( 'can_modify', cm:can_modify() )",
				},
				descriptions = {
					['kr'] = "'cm:can_modify()' 결과를 샌드박스 로그 파일로 출력한다.",
					['en'] = "Excutes 'call, logger( 'can_modify', cm:can_modify() )' string",
					['zh'] = "執行 'call, logger('can modify', cm:can modify() )' 字符串",
					['cn'] = "执行 'call, logger('can modify', cm:can modify() )' 字符串",
				}
			},
		},
	},
}


for entry_key, entry in pairs( command_help_entries ) do
	if not entry.title then entry.title = string.upper( entry_key ) end
	if not entry.descriptions then entry.descriptions = command_loc_descriptions[ entry_key ] end
end

return command_help_entries
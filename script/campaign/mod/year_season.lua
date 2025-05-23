local gst = xyy_gst:get_mod();

local era_name = effect.get_localised_string("mod_xyy_era_guanghe")
local era_number = "五"
local first_year = 178
local cant_use_era_name = false


function numberToChinese(num)
	local chineseNums = {"零", "一", "二", "三", "四", "五", "六", "七", "八", "九"}
	local chineseUnits = {"", "十", "百", "千", "万", "亿"}
	local result = {}
	local index = 1
 
	-- 处理负数
	if num < 0 then
		table.insert(result, "负")
		num = -num
	end
 
	-- 处理每一位数字
	while num > 0 do
		local digit = num % 10
		if digit ~= 0 then
			table.insert(result, 1, chineseNums[digit+1] .. chineseUnits[index])
		else
			table.insert(result, 1, chineseNums[1])  -- 添加零
		end
		num = math.floor(num / 10)
		index = index + 1
	end
 
	-- 拼接结果，去除末尾的零和多余的零
	local finalResult = table.concat(result)
	finalResult = finalResult:gsub("零+十", "零")  -- 处理十前的零
	finalResult = finalResult:gsub("^一十", "十")  -- 处理一十
	finalResult = finalResult:gsub("^零", "")	  -- 去除结果开头的零
	finalResult = finalResult:gsub("零$", "")	  -- 去除结果末尾的零
	finalResult = finalResult:gsub("零+万", "万")  -- 处理万前的零
	finalResult = finalResult:gsub("零+亿", "亿")  -- 处理亿前的零
	finalResult = finalResult:gsub("亿万", "亿")   -- 处理亿和万的顺序错误
    if gst.get_locale() == "zh" then
        finalResult = finalResult:gsub("万", "萬") 
	end
	return finalResult
end

local function get_era_number(year, first_year)
	local number = year - first_year
	if gst.get_locale() == "en" then
        if number == 0 then
            return "1st"
        elseif number == 1 then
            return "2nd"
        elseif number == 2 then
            return "3rd"
        else
            return (number + 1) .. "th"
        end
	else
        if number == 0 then
            return "元"
        else
            return numberToChinese(number + 1)
        end
	end
	return ""
end

function refresh_year()
	local root = core:get_ui_root()
	local year_label = find_uicomponent( root, "hud_campaign", "top_faction_header", "campaign_hud_faction_header", "topbar_list_parent", "topbar_list_parent", "label_year" )
	if not year_label or not is_uicomponent(year_label) then
		ModLog("not is_uicomponent(year_label)")
		return
	end
	local year
	local season
	local turn
	if not cm:get_saved_value("has_pending_battle") then
        year = cm:query_model():calendar_year()
        season = effect.get_localised_string("random_localisation_strings_string_" .. cm:query_model():season())
        turn = cm:query_model():turn_number()
	else
        year = cm:get_saved_value("has_pending_battle_year")
        season = effect.get_localised_string("random_localisation_strings_string_" .. cm:get_saved_value("has_pending_battle_season"))
        turn = cm:get_saved_value("has_pending_battle_turn")
        cm:set_saved_value("has_pending_battle_year", nil)
        cm:set_saved_value("has_pending_battle_season", nil)
        cm:set_saved_value("has_pending_battle_turn", nil)
	end
	year_label:SetState(cm:query_model():season()) 
	
	--ModLog(era_name .. era_number .. "年(" ..year .. ") " .. season)
	if not cm:get_saved_value("roguelike_mode") then
        if not cant_use_era_name then
            if gst.get_locale() == "cn" or gst.get_locale() == "zh" then 
                year_label:SetStateText(era_name .. era_number .. "年 " .. season)
            elseif gst.get_locale() == "en" then
                year_label:SetStateText(season .. " " .. era_name .. " " .. era_number)
            end
        else
            local label = effect.get_localised_string("random_localisation_strings_string_year_season_format")
            label = string.gsub(label, "{year}", year)
            label = string.gsub(label, "{season}",season)
            year_label:SetStateText(string.upper(label))
        end
	else
        local string = effect.get_localised_string("uied_component_texts_localised_string_label_duration_header_NewState_Text_210055")
        local key = effect.get_localised_string("mod_title_"..cm:get_saved_value("roguelike_enemy_effect_key"))
        local label = key .. string .. turn
        year_label:SetStateText(string.upper(label))
	end
end



core:add_listener(
	"year_label_enter",
	"FirstTickAfterWorldCreated",
	function(context)
		return true
	end,
	function(context)
		if not cant_use_era_name then
			if cm:get_saved_value("era_name") then
				era_name = cm:get_saved_value("era_name")
			end
			if cm:get_saved_value("era_number") then
				era_number = cm:get_saved_value("era_number")
			end
			if cm:get_saved_value("first_year") then
				first_year = cm:get_saved_value("first_year")
			end
			if cm:get_saved_value("cant_use_era_name") then
				cant_use_era_name = cm:get_saved_value("cant_use_era_name")
			end
		end
		refresh_year()
	end,
	false
);

core:add_listener(
	"year_label_first_date",
	"FirstTickAfterWorldCreated",
	function(context)
		return not cm:get_saved_value("era_name")
	end,
	function(context)
        if cm:query_model():turn_number() == 1 then 
            if cm:query_model():campaign_name() == "3k_dlc04_start_pos" then
                era_name = effect.get_localised_string("mod_xyy_era_guanghe");
                first_year = 178;
                era_number = get_era_number(cm:query_model():calendar_year(), first_year)
                cm:set_saved_value("era_name", era_name)
                cm:set_saved_value("era_number", era_number)
                cm:set_saved_value("first_year", first_year)
            end
            if cm:query_model():campaign_name() == "3k_main_campaign_map" then
                era_name = effect.get_localised_string("mod_xyy_era_chuping");
                first_year = 190;
                era_number = get_era_number(cm:query_model():calendar_year(), first_year)
                cm:set_saved_value("era_name", era_name)
                cm:set_saved_value("era_number", era_number)
                cm:set_saved_value("first_year", first_year)
            end
            if cm:query_model():campaign_name() == "3k_dlc05_start_pos" then
                era_name = effect.get_localised_string("mod_xyy_era_xingping");
                first_year = 194;
                era_number = get_era_number(cm:query_model():calendar_year(), first_year)
                cm:set_saved_value("era_name", era_name)
                cm:set_saved_value("era_number", era_number)
                cm:set_saved_value("first_year", first_year)
            end
            if cm:query_model():campaign_name() == "3k_dlc07_start_pos" then
                era_name = effect.get_localised_string("mod_xyy_era_jianan");
                first_year = 196;
                era_number = get_era_number(cm:query_model():calendar_year(), first_year)
                cm:set_saved_value("era_name", era_name)
                cm:set_saved_value("era_number", era_number)
                cm:set_saved_value("first_year", first_year)
            end
            if cm:query_model():campaign_name() == "8p_start_pos" then
                cm:set_saved_value("cant_use_era_name", true)
                cant_use_era_name = true;
            end
		end
		refresh_year();
	end,
	false
);

core:add_listener(
	"year_label_turn",
	"FactionTurnStart",
	function(context)
		return true
	end,
	function(context)
		if cm:get_saved_value("first_year") then
			first_year = cm:get_saved_value("first_year")
		end
		era_number = get_era_number(cm:query_model():calendar_year(), first_year)
		cm:set_saved_value("era_number", era_number)
		refresh_year()
	end,
	true
)

core:add_listener(
	"faction_becomes_world_leader",
	"FactionBecomesWorldLeader",
	function(context)
		return not cant_use_era_name
		and context:faction():name() ~= "3k_main_faction_yuan_shu"
		and context:faction():name() ~= "3k_dlc04_faction_empress_he";
	end,
	function(context)
		cant_use_era_name = true
		cm:set_saved_value("cant_use_era_name", cant_use_era_name)
		refresh_year()
	end,
	true
)

core:add_listener(
	"era_name_turn",
	"FactionTurnStart",
	function(context)
		return not cant_use_era_name and cm:query_model():turn_number() > 1
	end,
	function(context)
		if cm:query_model():calendar_year() >= 182 and cm:query_model():calendar_year() < 184 and era_name ~= effect.get_localised_string("mod_xyy_era_guanghe") then
			era_name = effect.get_localised_string("mod_xyy_era_guanghe");
			first_year = 178;
			era_number = get_era_number(cm:query_model():calendar_year(), first_year)
			cm:set_saved_value("era_name", era_name)
			cm:set_saved_value("era_number", era_number)
			cm:set_saved_value("first_year", first_year)
		end
		if cm:query_model():calendar_year() >= 184 and cm:query_model():calendar_year() < 189 and era_name ~= effect.get_localised_string("mod_xyy_era_zhongping") then
			era_name = effect.get_localised_string("mod_xyy_era_zhongping");
			first_year = 184;
			era_number = get_era_number(cm:query_model():calendar_year(), first_year)
			cm:set_saved_value("era_name", era_name)
			cm:set_saved_value("era_number", era_number)
			cm:set_saved_value("first_year", first_year)
		end
		if cm:query_model():calendar_year() == 189
		and not gst.character_is_dead("3k_dlc04_template_historical_emperor_ling_earth")
		and not cm:query_faction("3k_dlc04_faction_empress_he"):is_dead()
		and era_name ~= effect.get_localised_string("mod_xyy_era_guangxi")
		then
			era_name = effect.get_localised_string("mod_xyy_era_guangxi");
			first_year = cm:query_model():calendar_year();
			era_number = get_era_number(cm:query_model():calendar_year(), first_year)
			cm:set_saved_value("era_name", era_name)
			cm:set_saved_value("era_number", era_number)
			cm:set_saved_value("first_year", first_year)
		end
		if cm:query_model():calendar_year() == 189
		and gst.character_is_dead("3k_dlc04_template_historical_emperor_ling_earth")
		and cm:query_faction("3k_dlc04_faction_empress_he"):is_dead()
		and era_name ~= effect.get_localised_string("mod_xyy_era_yonghan")
		then
			era_name = effect.get_localised_string("mod_xyy_era_yonghan");
			first_year = cm:query_model():calendar_year();
			era_number = get_era_number(cm:query_model():calendar_year(), first_year)
			cm:set_saved_value("era_name", era_name)
			cm:set_saved_value("era_number", era_number)
			cm:set_saved_value("first_year", first_year)
		end
		if cm:query_model():calendar_year() >= 190 and cm:query_model():calendar_year() < 194 and era_name ~= effect.get_localised_string("mod_xyy_era_chuping") then
			era_name = effect.get_localised_string("mod_xyy_era_chuping");
			first_year = 190;
			era_number = get_era_number(cm:query_model():calendar_year(), first_year)
			cm:set_saved_value("era_name", era_name)
			cm:set_saved_value("era_number", era_number)
			cm:set_saved_value("first_year", first_year)
		end
		if cm:query_model():calendar_year() >= 194 and cm:query_model():calendar_year() < 196 and era_name ~= effect.get_localised_string("mod_xyy_era_xingping") then
			era_name = effect.get_localised_string("mod_xyy_era_xingping");
			first_year = 194;
			era_number = get_era_number(cm:query_model():calendar_year(), first_year)
			cm:set_saved_value("era_name", era_name)
			cm:set_saved_value("era_number", era_number)
			cm:set_saved_value("first_year", first_year)
		end
		if cm:query_model():calendar_year() >= 196 and era_name ~= effect.get_localised_string("mod_xyy_era_jianan") then
			era_name = effect.get_localised_string("mod_xyy_era_jianan");
			first_year = 196;
			era_number = get_era_number(cm:query_model():calendar_year(), first_year)
			cm:set_saved_value("era_name", era_name)
			cm:set_saved_value("era_number", era_number)
			cm:set_saved_value("first_year", first_year)
		end
	end,
	true
)

core:add_listener(
	"battle_complete",
	"BattleCompletedCameraMove",
	function(context)
		return true;
	end,
	function(context)
        refresh_year();
	end,
	true
)
local gst = xyy_gst:get_mod()

-- local modify_p1 = nil
-- local modify_p2 = nil
local ms_callback = nil


--获取一个记录对象的obj
local function getRecordObj(objInfo) 
    return  objInfo["obj"]
end

--获取一个记录对象的监听id
local function getRecordObjLisName(objInfo) 
    return  objInfo["btn_listener_name"]
end

local function table_reverse(tab)
    for i = 1, math.floor(#tab / 2) do
        tab[i], tab[#tab - i + 1] = tab[#tab - i + 1], tab[i]
    end
end

local function moveToTop(list, value)
    for i, v in ipairs(list) do
        if v == value then
            table.remove(list, i)
            table.insert(list, 1, value)
            break
        end
    end
end

local function moveToBottom(list, value)
    for i, v in ipairs(list) do
        if v == value then
            table.remove(list, i)
            table.insert(list, value)
            break
        end
    end
end
--lua的table随机
local function getRandomValue(min,max)
    if cm:is_multiplayer() and cm:can_modify(true) then
        return cm:random_int(min,max)
    end
    --比较大小
    if min > max then
        return math.random(max,min)
    elseif min < max then
        return math.random(min,max)
    else
        return min
    end
end


local function reset_randomseed()
    if cm:is_multiplayer() then
        return
    end
    math.randomseed(os.time() * 10000)
    for i = 0, math.random(0,50) do
        math.random()
    end
end

local function shuffle_table(t)
    reset_randomseed()
    if cm:is_multiplayer() and cm:can_modify(true) then
        return cm:random_sort(t)
    else
        local shuffled = {}
        for _, v in ipairs(t) do
            local pos
            if cm:is_multiplayer() then
                pos = cm:random_int(1, #shuffled + 1)
            else
                pos = math.random(1, #shuffled + 1)
            end
            table.insert(shuffled, pos, v)
        end
        -- for k, v in ipairs(shuffled) do
        --     ModLog(k..":"..v)
        -- end
        return shuffled
    end
end

local function value_in_list(list, value)
    if not list then
        return false
    end
    if list == {} or #list == 0 then
        return false
    end
    for k, v in pairs(list) do
        if v == value then
            return true;
        end
    end
    return false;
end

local function remove_value_from_list(list, key)
    for i, v in ipairs(list) do
        if v == key then
            table.remove(list, i);
            break
        end
    end
    return list;
end

local function remove_value_from_map(map, key)
    map[key] = nil;
    return map;
end

--暂停
local function pause_timer(s)
    timer.sleep(s);
end

local function try_load_table(filename)
    local appdata = os.getenv('APPDATA', "null");
    local lua_directory;
    if appdata == "null" then
        lua_directory = appdata .. '\\scripts'
    else
        lua_directory = appdata .. '\\The Creative Assembly\\ThreeKingdoms\\scripts'
    end
    local _, err_str = io.open( lua_directory, 'r' )
    if err_str:match( 'No such file or directory' ) then
        os.execute('mkdir "' .. lua_directory .. '"')
    end
    local filepath = lua_directory.."\\"..filename..".lua"
    local file = loadfile(filepath)
    if file then
        local ok, data = pcall(file)
        if ok then
            return data
        else
            ModLog("加载文件失败：" .. filepath)
            return false;
        end
    else
        ModLog("未找到文件：" .. filepath)
        return false;
    end
end

local function lua_table_to_string(tbl)
    local lua_str = "{\n"
    for k, v in pairs(tbl) do
        if type(k) == "string" then
            k = string.format("%q", k)
        end
        lua_str = lua_str .. "  [" .. k .. "] = "
        if type(v) == "table" then
            lua_str = lua_str .. lua_table_to_string(v) .. ",\n"
        elseif type(v) == "string" then
            v = string.format("%q", v)
            lua_str = lua_str .. v .. ",\n"
        else
            lua_str = lua_str .. tostring(v) .. ",\n"
        end
    end
    lua_str = lua_str .. "}"
    return lua_str
end

local function create_and_save_table(filename, save_table)
    local appdata = os.getenv('APPDATA', "null");
    local lua_directory;
    if appdata == "null" then
        lua_directory = appdata .. '\\scripts'
    else
        lua_directory = appdata .. '\\The Creative Assembly\\ThreeKingdoms\\scripts'
    end
    --os.execute('mkdir "' .. lua_directory .. '"')
    local filepath = lua_directory.."\\"..filename..".lua"
    local file = io.open(filepath, "w")
    if file then
        file:write("return ", lua_table_to_string(save_table))  -- 将table转换为字符串
        file:close()
        return save_table;
    else
        ModLog("创建文件失败: " .. filepath)
        return false;
    end
end

local function safeTableInsert(list, value) 
    if not value_in_list(list, value) then
        table.insert(list, value) 
    end
    return list
end

local function safeTableAdd(list, table) 
    for _,i in ipairs(table) do
        safeTableInsert(list, i) 
    end
    return list
end

local function wait_for_model_sp(callback) 
    if cm:query_model():is_multiplayer() then
        return;
    else
        cm:wait_for_model_sp(callback)
    end;
end

--记录对象
local function recordObj(obj, btn_listener_name, obj_table) 
    local objInfo = {}
    objInfo["obj"] = obj --对象
    objInfo["btn_listener_name"] = btn_listener_name --对象的监听id，如果没有则为nil
    safeTableInsert(obj_table, objInfo)
end

--检测作弊mod
local function check_cheat_mods() 
    for _,v in ipairs(gst.mod_blacklist) do
        for line in io.lines("used_mods.txt") do
            if string.find(line, '/779340/' .. v .. '"') then
                return true;
            end
        end
    end
    return false;
end

-- core:add_listener(
--     "campaign_manager_wait_for_model_sp_multiplayer",
--     "FactionCeoAdded",
--     function(context)
--         return context:ceo():ceo_data_key() == "hlyjdingzhiffujian";
--     end,
--     function(context)
--         modify_p1:ceo_management():remove_ceo("hlyjdingzhiffujian")
-- --         if ms_callback then
-- --             ms_callback()
-- --         end
--     end,
--     true
-- )

-- local function set_multiplayer() 
--     if cm:query_model():is_multiplayer() then
-- 		modify_p1 = cm:modify_faction(cm:get_saved_value("xyy_1p"))
-- 		modify_p2 = cm:modify_faction(cm:get_saved_value("xyy_2p"))
-- 	end;
-- end
-----------------------------------------------------------------
--  Register
-----------------------------------------------------------------
gst.lib_recordObj = recordObj
gst.lib_getRecordObj = getRecordObj
gst.lib_getRecordObjLisName = getRecordObjLisName
gst.lib_getRandomValue = getRandomValue
gst.lib_reset_randomseed = reset_randomseed
gst.lib_shuffle_table = shuffle_table
gst.lib_value_in_list = value_in_list
gst.lib_remove_value_from_list = remove_value_from_list
gst.lib_pause_timer = pause_timer
gst.lib_try_load_table = try_load_table
gst.lib_lua_table_to_string = lua_table_to_string
gst.lib_create_and_save_table = create_and_save_table
gst.lib_remove_value_from_map = remove_value_from_map
gst.lib_move_value_to_top = moveToTop
gst.lib_move_value_to_bottom = moveToBottom
gst.lib_table_reverse = table_reverse
gst.lib_table_insert = safeTableInsert
gst.lib_table_add = safeTableAdd
gst.wait_for_model_sp = wait_for_model_sp
gst.lib_check_cheat_mods = check_cheat_mods
return gst
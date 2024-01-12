gb = generated_battle:new(false, false, false, nil, false);

-- 获取玩家的军队
pa = gb:get_army(gb:get_player_alliance_num(), bm:local_army());

-- ai控制模式
ai_control_mode_enable = false

effect.advice(effect.get_localised_string("mod_xyy_combat_ai_tips"));

-- 获取敌人的军队
enemy_force = gb:get_enemy_force(gb:get_player_alliance_num(), bm:local_army());

ucount = pa.army:units():count();
scount = 0;
-- volume = 0;
-- spectator = 0;

-- ai控制单位类别
ai_control_unit_list = {};

-- 判断ai控制的军队是否包含某一类元素
function units_controlled_by_ai(key)
    for i, v in ipairs(ai_control_unit_list) do
        if v == key then
            return true;
        end
    end
    return false;
end

-- 让ai控制军队中某一类元素
function ai_control_enabled(key)
    if not units_controlled_by_ai(key) then
        table.insert(ai_control_unit_list, key);
    end
end

-- 让某一类元素由玩家控制
function ai_control_disabled(key)
    for i, v in ipairs(ai_control_unit_list) do
        if v == key then
            table.remove(ai_control_unit_list, i)
            return;
        end
    end
end

function copy_sunit_list(sunit_list)
    -- 深复制
    local sl = {};
    for i = 1, #sunit_list do
        sl[i] = sunit_list[i];
    end
    return sl;
end

-- 判断军队距离
-- TODO: 判断敌军类型，选择一个最适合的我方军队
local function closest_sunit_index(list, target)
    -- list: 我方军队   target: 敌军
    local index = 0;
    for i = 1, #list do
        local curr_sunit = list[i];
        -- 如果我方某个单位没有溃败或者死亡
        -- TODO：判断敌军是否需要追击
        if not is_routing_or_dead(curr_sunit.unit) then
            -- 计算敌我两方的距离
            local curr_sunit_dist = target.unit:position():distance(curr_sunit.unit:position());
            if curr_sunit_dist < 5000 then
                return index;
            end
        end
    end
    return index
end

-- 追击逃兵
local function chase_routing_enemies()
    if ai_control_mode_enable then
        local counter = 0;
        local playerforce = copy_sunit_list(pa.sunits.sunit_list);
        local enemyforce = enemy_force.sunit_list;
        local i = 1;
        while enemyforce[i] and counter < 10 and #enemyforce > 0 do
            if enemyforce[i].unit:number_of_men_alive() > 0 then
                local index = closest_sunit_index(playerforce, enemyforce[i]);
                if index ~= 0 then
                    Modlog('xyy_automation_battle_message: let ' .. playerforce[index].uc, " to attck", enemyforce[i].unit)
                    playerforce[index].uc:attack_unit(enemyforce[i].unit, true, true);
                    table.remove(playerforce, index);
                else
                    playerforce = {};
                end
            else
                table.remove(enemyforce, i);
            end

            if not enemyforce[i + 1] and #playerforce > 0 then
                i = 0;
                counter = counter + 1;
            end
            i = i + 1;
            if #playerforce == 0 then
                break
            end
        end
    end
end

function phase_handler(event)
    ModLog("phase_handler")
    if event:get_name() == "VictoryCountdown" then
        pa:release_control_of_all_sunits();
        -- bm:register_repeating_timer("chase_routing_enemies", 5000);
    end
end

bm:register_battle_phase_handler("phase_handler");

-- 如果有后加入的军队，按照设定决定是否使用ai控制
function summons_check()
    local uc = pa.army:units():count();
    if ucount > uc then
        ucount = uc;
    elseif ucount < uc then
        skip = false;
        diff = uc - ucount;
        ucount = uc;
        scount = scount + 1;
        for i = 0, diff - 1 do
            for j = 1, #pa.sunits.sunit_list do
                if pa.army:units():item(uc - i) == pa.sunits.sunit_list[j].unit then
                    skip = true;
                end
            end
            if not skip then
                local new_unit = script_unit:new(pa.army, uc - i);
                new_unit.name = new_unit.name .. "_" .. tostring(scount) .. "S";
                new_unit.summoned = true;
                pa.sunits:add_sunits(new_unit);
                if ai_control_mode_enable then
                    if units_controlled_by_ai(new_unit.unitclass) then
                        Modlog('xyy_automation_battle_message:', new_unit.name, "control by ai from function(summons_check)")
                        pa.script_ai_planner:add_sunits(new_unit);
                    end
                end
            end
        end
    end
end


-- 让ai控制援军
function reinforcement_check()
    for i = 1, #pa.sunits.sunit_list do
        local u = pa.sunits.sunit_list[i];
        if u.reinforcement then
            pa.script_ai_planner:remove_sunits(u);
            if units_controlled_by_ai(u.unitclass) then
                Modlog('xyy_automation_battle_message:', u.name, "control by ai from function(reinforcement_check)")
                pa.script_ai_planner:add_sunits(u);
            end
        end
    end
end

-- ai控制模式切换
function Trigger()
    -- 让ai取消控制所有单位 
    pa:release_control_of_all_sunits();
    -- 如果ai控制模式没有启用
    if ai_control_mode_enable == false then
        -- 把下列兵种加入ai控制列表
        ai_control_enabled("inf_mel")
        ai_control_enabled("inf_mis")
        ai_control_enabled("inf_pik")
        ai_control_enabled("inf_spr")
        ai_control_enabled("cav_mel")
        ai_control_enabled("cav_mis")
        ai_control_enabled("cav_shk")
        ai_control_enabled("elph")
        pa:set_up_script_planner();
        effect.advice(effect.get_localised_string("mod_xyy_combat_ai_control_on"));
        -- 枚举战场上的所有我方单位
        local allUnits = pa.sunits:get_sunit_table();
        if #allUnits > 0 then
            for i = 1, #allUnits do
                local current_sunit = allUnits[i];
                if current_sunit.unit then
                    -- 如果该类型单位的ai控制没有启用就让玩家控制军队
                    if not units_controlled_by_ai(current_sunit.unitclass) then
                        Modlog('xyy_automation_battle_message:', current_sunit, "control by player")
                        pa.script_ai_planner:remove_sunits(current_sunit);
                    else 
                        Modlog('xyy_automation_battle_message:', current_sunit, "control by ai")
                        pa.script_ai_planner:add_sunits(current_sunit);
                    end
                end
            end
        end
        ai_control_mode_enable = true;
    elseif ai_control_mode_enable == true then
        ai_control_unit_list = {};
        pa:set_up_script_planner();
        -- 让ai取消控制所有单位
        pa:release_control_of_all_sunits();
        effect.advice(effect.get_localised_string("mod_xyy_combat_ai_control_off"));
        ai_control_mode_enable = false;
        -- closePanel();
    end
end

function refresh()
    pa:release_control_of_all_sunits();
    if ai_control_mode_enable == true then
        pa:set_up_script_planner();
        local allUnits = pa.sunits:get_sunit_table();
        if #allUnits > 0 then
            for i = 1, #allUnits do
                local current_sunit = allUnits[i];
                if current_sunit.unit then
                    if not units_controlled_by_ai(current_sunit.unitclass) then
                        Modlog('xyy_automation_battle_message:', current_sunit, "control by player")
                        pa.script_ai_planner:remove_sunits(current_sunit);
                    end
                end
            end
        end
        ai_control_mode_enable = true;
    elseif ai_control_mode_enable == false then
        ai_control_unit_list = {};
        pa:set_up_script_planner();
        pa:release_control_of_all_sunits();
        ai_control_mode_enable = false;
    end
end

function toggleControl(class_key)
    if units_controlled_by_ai(class_key) then
        ai_control_disabled(class_key)
    else
        effect.advice(effect.get_localised_string("mod_xyy_combat_ai_control_on"));
        ai_control_enabled(class_key)
    end
    if ai_control_mode_enable then
        if #ai_control_unit_list == 0 then
            pa:release_control_of_all_sunits();
            ai_control_mode_enable = false;
        end
    else
        if #ai_control_unit_list > 0 then
            ai_control_mode_enable = true;
        end
    end
    refresh();
end

bm:register_repeating_timer("summons_check", 500);

bm:register_repeating_timer("reinforcement_check", 10000);

core:add_listener("AIGENERAL_ALLNoneGeneral", "ShortcutTriggered", function(context)
    -- ModLog(tostring(context.string));
    return context.string == "camera_bookmark_save0";
end, function()
    Trigger();
    toggleButton();
end, true);

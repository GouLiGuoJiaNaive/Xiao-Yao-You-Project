gb = generated_battle:new(false, false, false, nil, false);

-- 获取玩家的军队
pa = gb:get_army(gb:get_player_alliance_num(), bm:local_army());

-- 控制模式
local control_mode_enable = false

effect.advice(effect.get_localised_string("mod_xyy_combat_ai_tips"));

-- 获取敌人的军队
enemy_force = gb:get_enemy_force(gb:get_player_alliance_num(), bm:local_army());

ucount = pa.army:units():count();
scount = 0;
-- volume = 0;
-- spectator = 0;

control_table = {};

function control_table_have(key)
    -- 判断ai控制的军队是否包含某一类元素
    for i, v in ipairs(control_table) do
        if v == key then
            return true;
        end
    end
    return false;
end

function control_table_add(key)
    -- 让ai控制军队中某一类元素
    if not control_table_have(key) then
        table.insert(control_table, key);
    end
end

function control_table_remove(key)
    -- 让某一类元素由玩家控制
    for i, v in ipairs(control_table) do
        if v == key then
            table.remove(control_table, i)
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

function closest_sunit_index(list, target)
    -- list: 玩家军队   target: 敌军
    index = 0;
    for i = 1, #list do
        local curr_sunit = list[i];
        -- 如果我方某个单位没有溃败或者死亡
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
function chase_routing_enemies()
    if control_mode_enable then
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

function summons_check()
    uc = pa.army:units():count();
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
                newunit = script_unit:new(pa.army, uc - i);
                newunit.name = newunit.name .. "_" .. tostring(scount) .. "S";
                newunit.summoned = true;
                pa.sunits:add_sunits(newunit);
                if control_mode_enable then
                    if control_table_have(newunit.unitclass) then
                        Modlog('xyy_automation_battle_message:', newunit, "control by ai")
                        pa.script_ai_planner:add_sunits(newunit);
                    end
                end
            end
        end
    end
end

function reinforcement_check()
    if control_mode_enable then
        for i = 1, #pa.sunits.sunit_list do
            u = pa.sunits.sunit_list[i];
            if u.reinforcement then
                pa.script_ai_planner:remove_sunits(u);
                if control_table_have(u.unitclass) then
                    Modlog('xyy_automation_battle_message:', u, "control by ai")
                    pa.script_ai_planner:add_sunits(u);
                end
            end
        end
    end
end

function Trigger()
    pa:release_control_of_all_sunits();
    if control_mode_enable == false then
        control_table_add("inf_mel")
        control_table_add("inf_mis")
        control_table_add("inf_pik")
        control_table_add("inf_spr")
        control_table_add("cav_mel")
        control_table_add("cav_mis")
        control_table_add("cav_shk")
        control_table_add("elph")
        pa:set_up_script_planner();
        effect.advice(effect.get_localised_string("mod_xyy_combat_ai_control_on"));
        local allUnits = pa.sunits:get_sunit_table();
        if #allUnits > 0 then
            for i = 1, #allUnits do
                local current_sunit = allUnits[i];
                if current_sunit.unit then
                    if not control_table_have(current_sunit.unitclass) then
                        Modlog('xyy_automation_battle_message:', current_sunit, "control by player")
                        pa.script_ai_planner:remove_sunits(current_sunit);
                    end
                end
            end
        end
        control_mode_enable = true;
    elseif control_mode_enable == true then
        control_table = {};
        pa:set_up_script_planner();
        pa:release_control_of_all_sunits();
        effect.advice(effect.get_localised_string("mod_xyy_combat_ai_control_off"));
        control_mode_enable = false;
        -- closePanel();
    end
end

function refresh()
    pa:release_control_of_all_sunits();
    if control_mode_enable == true then
        pa:set_up_script_planner();
        local allUnits = pa.sunits:get_sunit_table();
        if #allUnits > 0 then
            for i = 1, #allUnits do
                local current_sunit = allUnits[i];
                if current_sunit.unit then
                    if not control_table_have(current_sunit.unitclass) then
                        Modlog('xyy_automation_battle_message:', current_sunit, "control by player")
                        pa.script_ai_planner:remove_sunits(current_sunit);
                    end
                end
            end
        end
        control_mode_enable = true;
    elseif control_mode_enable == false then
        control_table = {};
        pa:set_up_script_planner();
        pa:release_control_of_all_sunits();
        control_mode_enable = false;
    end
end

function toggleControl(class_key)
    if control_table_have(class_key) then
        control_table_remove(class_key)
    else
        effect.advice(effect.get_localised_string("mod_xyy_combat_ai_control_on"));
        control_table_add(class_key)
    end
    if control_mode_enable then
        if #control_table == 0 then
            pa:release_control_of_all_sunits();
            control_mode_enable = false;
        end
    else
        if #control_table > 0 then
            control_mode_enable = true;
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

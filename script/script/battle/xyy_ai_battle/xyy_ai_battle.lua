gb = generated_battle:new(
	false,
	false,
	false,                                      	
	nil, 	
	false                                      
);

pa = gb:get_army(gb:get_player_alliance_num(), bm:local_army());

local mode = false
local art_fix = false
--effect.advice(effect.get_localised_string("mod_xyy_combat_ai_tips"));

enemy_force = gb:get_enemy_force(gb:get_player_alliance_num(), bm:local_army());

ucount = pa.army:units():count();
scount = 0;
volume = 0;
spectator = 0;

control_table = {};

function control_table_have(key)
    for i, v in ipairs(control_table) do
        if v == key then
            return true;
        end
    end
    return false;
end

function control_table_add(key)
    
    if not control_table_have(key) then
        table.insert(control_table, key);
    end
end

function control_table_remove(key)
    for i, v in ipairs(control_table) do
        if v == key then
            table.remove(control_table, i)
            return;
        end
    end
end

function copy_sunit_list(sunit_list)
    local sl = {};
    for i = 1, #sunit_list do
            sl[i] = sunit_list[i];
    end;
    return sl;
end;

function is_control()
    return mode;
end;

function closest_sunit_index(list, target)
    index = 0;
    local closest_dist = 5000;
    for i = 1, #list do
        local curr_sunit = list[i];
        if not is_routing_or_dead(curr_sunit.unit)
        then
            local curr_sunit_dist = target.unit:position():distance(curr_sunit.unit:position());
            if curr_sunit_dist < closest_dist then
                index = i;
                closest_dist = curr_sunit_dist;
            end;
        end;
    end;
    return index;
end;

--追击逃兵
function chase_routing_enemies()
    if mode then
        local counter = 0;
        local playerforce = copy_sunit_list(pa.sunits.sunit_list);
        local enemyforce = enemy_force.sunit_list;
        local i = 1;
        while enemyforce[i] and counter < 10 and #enemyforce > 0 do
            if enemyforce[i].unit:number_of_men_alive() > 0 then
                local index = closest_sunit_index(playerforce, enemyforce[i]);     
                if index ~= 0 then         
                    playerforce[index].uc:attack_unit(enemyforce[i].unit,true,true);
                    table.remove(playerforce, index);           
                else 
                    playerforce = {};
                end;
            else
                table.remove(enemyforce,i);
            end;
            
            if not enemyforce[i+1] and #playerforce > 0 then
                    i = 0;
                    counter = counter + 1;
            end;
            i = i + 1;
            if #playerforce == 0 then break; end;
        end;
    end;
end;

function phase_handler(event)
    if event:get_name() == "VictoryCountdown" then	
        pa:release_control_of_all_sunits();         
        --bm:register_repeating_timer("chase_routing_enemies", 5000);
    end;
end;

bm:register_battle_phase_handler("phase_handler");

function summons_check()
    uc = pa.army:units():count();                    
    if ucount > uc then
        ucount = uc;
    elseif ucount < uc then
        skip = false;
        diff = uc-ucount;
        ucount = uc;
        scount = scount +1;
        for i = 0, diff-1 do
            for j = 1, #pa.sunits.sunit_list do
                if pa.army:units():item(uc-i) == pa.sunits.sunit_list[j].unit then skip = true;  end;
            end;
            if not skip then
                newunit = script_unit:new(pa.army,uc-i);
                newunit.name = newunit.name .. "_" .. tostring(scount) .. "S";      
                newunit.summoned = true;
                pa.sunits:add_sunits(newunit);
                if newunit.unitclass == "art_fix" then
                    ModLog("found art_fix")
                    art_fix = true
                    pa:release_control_of_all_sunits(); 
                    pa:set_up_script_planner();
                    local allUnits = pa.sunits:get_sunit_table();
                    if #allUnits > 0 then
                        for i = 1, #allUnits do
                            local current_sunit = allUnits[i];
                            if current_sunit.unit then
--                                 if current_sunit.unitclass == "art_fix"
--                                     art_fix = true;
--                                 end
                                if not control_table_have(current_sunit.unitclass) and current_sunit.unitclass ~= "art_fix" then
                                    pa.script_ai_planner:remove_sunits(current_sunit);
                                    --current_sunit:highlight_unit_card(false, 0, false);
                                else
                                    --current_sunit:highlight_unit_card(true, 5, true);
                                end
                            end
                        end
                    end
                    --newunit:highlight_unit_card(true, 5, true);
                end
                if mode then
                    if control_table_have(newunit.unitclass) then
                        pa.script_ai_planner:add_sunits(newunit);
                        --newunit:highlight_unit_card(true, 5, true);
                    end
                end;
            end;
        end;
    end;
end;

function reinforcement_check()
    if mode then
        for  i = 1, #pa.sunits.sunit_list do
            u = pa.sunits.sunit_list[i];
            if u.reinforcement then  
                pa.script_ai_planner:remove_sunits(u); 
                if control_table_have(u.unitclass) then
                    pa.script_ai_planner:add_sunits(u);    
                end 
            end;
        end;  
    end;
end

function art_fix_check()
    if art_fix then
        pa:release_control_of_all_sunits(); 
        pa:set_up_script_planner();
        local allUnits = pa.sunits:get_sunit_table();
        if #allUnits > 0 then
            for i = 1, #allUnits do
                local current_sunit = allUnits[i];
                if current_sunit.unit then
                    if not control_table_have(current_sunit.unitclass) and current_sunit.unitclass ~= "art_fix" then
                        pa.script_ai_planner:remove_sunits(current_sunit);
                        --current_sunit:highlight_unit_card(false, 0, false);
                    else
                        --current_sunit:highlight_unit_card(true, 5, true);
                    end
                end
            end
        end
--         if not art_fix and not mode then
--             pa:set_up_script_planner();
--             pa:release_control_of_all_sunits(); 
--         end
    end
end

function Trigger()
	pa:release_control_of_all_sunits(); 
	if mode == false then
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
					if not control_table_have(current_sunit.unitclass)  and current_sunit.unitclass ~= "art_fix" then
                        pa.script_ai_planner:remove_sunits(current_sunit);
                        --current_sunit:highlight_unit_card(false, 0, false);
                    else
                        --current_sunit:highlight_unit_card(true, 5, true);
					end
				end
			end
		end
		mode = true;
	elseif mode == true then
        control_table = {};
		pa:set_up_script_planner();
        pa:release_control_of_all_sunits(); 
        effect.advice(effect.get_localised_string("mod_xyy_combat_ai_control_off"));
		mode = false;
		local allUnits = pa.sunits:get_sunit_table();
		if #allUnits > 0 then
			for i = 1, #allUnits do
				local current_sunit = allUnits[i];
                --current_sunit:highlight_unit_card(false, 0, false);
			end
		end
		--closePanel();
	end  
end

function refresh()
	pa:release_control_of_all_sunits(); 
	if mode == true then
		pa:set_up_script_planner();
		local allUnits = pa.sunits:get_sunit_table();
		if #allUnits > 0 then
			for i = 1, #allUnits do
				local current_sunit = allUnits[i];
				if current_sunit.unit then
					if not control_table_have(current_sunit.unitclass)  and current_sunit.unitclass ~= "art_fix" then
                        pa.script_ai_planner:remove_sunits(current_sunit);
                        --current_sunit:highlight_unit_card(false, 0, false);
                    else
                        --current_sunit:highlight_unit_card(true, 5, true);
					end
				end
			end
		end
		mode = true;
	elseif mode == false then
        control_table = {};
		pa:set_up_script_planner();
        pa:release_control_of_all_sunits(); 
		mode = false;
	end  
end

function toggleControl(class_key)
    if control_table_have(class_key) then
        control_table_remove(class_key)
    else
        effect.advice(effect.get_localised_string("mod_xyy_combat_ai_control_on"));
        control_table_add(class_key)
    end
    if mode then
        if #control_table == 0 then
            pa:release_control_of_all_sunits(); 
            mode = false;
        end
    else
        if #control_table > 0 then
            mode = true;
        end 
    end;
    refresh();
end

bm:register_repeating_timer("summons_check", 500);

bm:register_repeating_timer("art_fix_check", 1000);

bm:register_repeating_timer("reinforcement_check", 10000);

core:add_listener(
    "AIGENERAL_ALLNoneGeneral",
    "ShortcutTriggered",
    function(context) 
        --ModLog(tostring(context.string));
        return context.string == "camera_bookmark_save0";
    end,
    function()
        Trigger();
        toggleButton();
    end,
    true
);	
if cm.name == "ep_eight_princes" then
	return;
end;


function z_if_fix()
	core:add_listener(
	"ZbugfixIF",
	"ScriptEventHumanFactionTurnStart",
    function(context)
        return not cm:get_world_power_token_owner("emperor"):is_null_interface()
    end,
    function(context)
        local q_xian = cm:query_model():character_for_template("3k_dlc04_template_historical_emperor_xian_earth")
        local emperor_faction = cm:get_world_power_token_owner("emperor")
            
    --将献帝移到控制皇帝的阵营中
        if not q_xian:is_null_interface() and q_xian:faction() ~= emperor_faction and not q_xian:is_dead() then
                local mqchar = cm:modify_character(q_xian)
                mqchar:move_to_faction_and_make_recruited(emperor_faction:name())
        end

    --当玩家控制天子后，每回合刷新圣旨系统		    
        if cm:get_world_power_token_owner("emperor"):is_human() and cm:query_model():calendar_year() >= 197 and not cm:get_saved_value("human_can_decree") then
            local emperor = cm:get_world_power_token_owner("emperor")
            output("Imperial Intrigue: Enabling Imperial Decrees for faction:" .. tostring(emperor:name()) .. "and han chinese subculture factions")
            cm:modify_model():enable_diplomacy("faction:"..emperor:name(), "subculture:3k_main_chinese", "treaty_components_issue_Imperial_decree", "hidden");
            cm:modify_model():enable_diplomacy("subculture:3k_main_chinese", "faction:".. tostring(emperor:name()), "treaty_components_recieve_imperial_decree", "hidden");
            cm:set_saved_value("human_can_decree", true);
        elseif (not cm:get_world_power_token_owner("emperor"):is_human() and cm:get_saved_value("human_can_decree")) or cm:query_model():calendar_year() < 197 then
                cm:modify_model():disable_diplomacy("all", "all", "treaty_components_issue_Imperial_decree,treaty_components_recieve_imperial_decree",  "hidden")
                cm:set_saved_value("human_can_decree", false);
        end
    end,
    true
    )
end;

cm:add_first_tick_callback(function() z_if_fix() end);
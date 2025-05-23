if cm.name == "ep_eight_princes" then
	return;
end;

local gst = xyy_gst:get_mod()

function z_if_fix()
	core:add_listener(
	"ZbugfixIF",
	"ScriptEventHumanFactionTurnStart",
    function(context)
        return not cm:get_world_power_token_owner("emperor"):is_null_interface()
    end,
    function(context)
        local q_xian = gst.character_query_for_template("3k_dlc04_template_historical_emperor_xian_earth")
        local emperor_faction = cm:get_world_power_token_owner("emperor")
            
    --将献帝移到控制皇帝的阵营中
        if q_xian
        and not q_xian:is_null_interface() 
        and not q_xian:is_dead() 
        and q_xian:is_character_is_faction_recruitment_pool()
        then
            local mqchar = cm:modify_character(q_xian)
            if q_xian:faction() ~= emperor_faction then
                mqchar:move_to_faction_and_make_recruited(emperor_faction:name())
            end
            mqchar:apply_effect_bundle("essentials_effect_bundle", -1);
        else
            q_xian = gst.character_add_to_faction("3k_dlc04_template_historical_emperor_xian_earth", emperor_faction:name(), "3k_general_earth")
            local mqchar = cm:modify_character(q_xian)
            mqchar:apply_effect_bundle("essentials_effect_bundle", -1);
        end

    --当玩家控制天子后，每回合刷新圣旨系统		    
        if not q_xian:is_dead() and q_xian:faction():is_human() and q_xian:has_come_of_age() and not cm:get_saved_value("human_can_decree") then
            local emperor = q_xian:faction()
            output("Imperial Intrigue: Enabling Imperial Decrees for faction:" .. tostring(emperor:name()) .. "and han chinese subculture factions")
            cm:modify_model():enable_diplomacy("faction:"..emperor:name(), "subculture:3k_main_chinese", "treaty_components_issue_Imperial_decree", "hidden");
            cm:modify_model():enable_diplomacy("subculture:3k_main_chinese", "faction:".. tostring(emperor:name()), "treaty_components_recieve_imperial_decree", "hidden");
            cm:set_saved_value("human_can_decree", true);
        elseif q_xian:is_null_interface() or q_xian:is_dead() or (not q_xian:faction():is_human() and cm:get_saved_value("human_can_decree")) or not q_xian:has_come_of_age() then
            cm:modify_model():disable_diplomacy("all", "all", "treaty_components_issue_Imperial_decree,treaty_components_recieve_imperial_decree",  "hidden")
            cm:set_saved_value("human_can_decree", false);
        end
    end,
    true
    )
end;

cm:add_first_tick_callback(function() z_if_fix() end);
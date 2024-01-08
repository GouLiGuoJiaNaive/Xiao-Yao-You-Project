local query_faction = nil;
local limit = 0;

core:add_listener(
    "AI_deployment_limit",
    "FactionTurnStart",
    function(context)
        if not context:faction():is_dead() 
        and not context:faction():is_human() 
        then
            return true
        end
    end,
    function(context)
        query_faction = context:faction():name()
    end,
    true
)

core:add_listener(
    "AI_deployment_limit_2",
    "FactionTurnEnd",
    function(context)
        if not context:faction():is_dead() 
        and context:faction():name() == query_faction
        then
            return true
        end
    end,
    function(context)
        limit = 0;
        if cm:get_saved_value(query_faction.."_treasury") and cm:get_saved_value(query_faction.."_treasury") > 0 then
            cm:modify_faction(query_faction):increase_treasury(cm:get_saved_value(query_faction.."_treasury"));
            cm:set_saved_value(query_faction.."_treasury",0);
        end
        query_faction = nil
    end,
    true
)

core:add_listener(
    "AI_deployment_force_created",
    "MilitaryForceCreated",
    function(context)
        return query_faction
        and context:military_force_created():faction():name() == query_faction;
    end,
    function(context)
        local money = cm:query_faction(query_faction):treasury()
        if cm:query_faction(query_faction):treasury() > 20000
        then
            money = money - 20000
            cm:modify_faction(query_faction):decrease_treasury(money)
            cm:set_saved_value(query_faction.."_treasury", money)
        end
        ModLog(query_faction .. " money ".. money + 20000 .. " => " .. 20000)
        local max_value = 5
        if query_faction == "xyyhlyjf" then
            max_value = 11
        end
        
        if query_faction == "xyyhlyjf" then
            max_value = 11
        end
        if limit < 5 then
            limit = limit + 1;
        else
            limit = 0;
            cm:modify_faction(query_faction):apply_effect_bundle("AI_deployment_limit", 1);
        end
        ModLog(query_faction .. " ".. limit .. "/" .. max_value)
    end,
    true
)
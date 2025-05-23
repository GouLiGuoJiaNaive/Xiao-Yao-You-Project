cm:add_first_tick_callback(function() IronRegionLessEffectFix:initialise() end);

IronRegionLessEffectFix = {
    


}


function IronRegionLessEffectFix:initialise()
    IronRegionLessEffectFix:add_listener()
end

function IronRegionLessEffectFix:add_listener()
    
    core:add_listener(
    "RegionLessStartFaction",
    "FactionTurnStart",
    function(context)
        return true
    end,
    function(context)
        local region_amount = context:faction():region_list():num_items()
            if region_amount == 0 then
                if not context:faction():has_effect_bundle("3k_dlc04_effect_bundle_free_force") then
                    cm:modify_faction(context:faction()):apply_effect_bundle("3k_dlc04_effect_bundle_free_force", -1)
                end
            else
                if context:faction():has_effect_bundle("3k_dlc04_effect_bundle_free_force") then
                    cm:modify_faction(context:faction()):remove_effect_bundle("3k_dlc04_effect_bundle_free_force")
                end
            end
        end,
    true
    );
    
    core:add_listener(
    "RegionLessEndFaction",
    "FactionTurnEnd",
    function(context)
        return true
    end,
    function(context)
        local region_amount = context:faction():region_list():num_items()
            if region_amount == 0 then
                if not context:faction():has_effect_bundle("3k_dlc04_effect_bundle_free_force") then
                    cm:modify_faction(context:faction()):apply_effect_bundle("3k_dlc04_effect_bundle_free_force", -1)
                end
            else
                if context:faction():has_effect_bundle("3k_dlc04_effect_bundle_free_force") then
                    cm:modify_faction(context:faction()):remove_effect_bundle("3k_dlc04_effect_bundle_free_force")
                end
            end
        end,
    true
    );
    
end
core:add_listener(
    "xyy_update_check",
    "FirstTickAfterWorldCreated", --世界创建完成后的第一时间
    function(context)
        return true
    end,

    function(context)
        local faction = cm:query_local_faction()
        cm:trigger_dilemma(faction:name(),"xyy_update", true);
        cm:modify_faction(faction:name()):remove_effect_bundle("xyy_update");
    end,
    true
)
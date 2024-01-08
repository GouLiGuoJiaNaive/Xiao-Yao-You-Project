core:add_listener(
    "open_voting_event",
    "FirstTickAfterWorldCreated", --世界创建完成后的第一时间
    function(context)
        ModLog(os.time())
        return os.time() < 1704931200 and 
        not cm:get_saved_value("open_voting_event");
    end,

    function(context)
        local faction = cm:query_local_faction()
        cm:trigger_dilemma(faction:name(),"voting_event", true);
    end,
    true
)

core:add_listener(
    "voting_event_choice",
    "DilemmaChoiceMadeEvent",
    function(context)
        return context:dilemma() ==  "voting_event" ;
    end,
    function(context)
        if context:choice() == 0 then
            os.execute("start https://steamcommunity.com/workshop/filedetails/discussion/3000868409/3880473373387277429/")
        end 
        cm:set_saved_value("open_voting_event", true)
    end,
    false
)
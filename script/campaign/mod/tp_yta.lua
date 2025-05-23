--Script by thesniperdevil
--Some achivements seem to fail to unlock in the conditions provided. Largely based on startdates. This script sets up listeners to check that 
--the conditions are met and the achivement is rewarded. Checks are made on faction start. The listenres will always kick off when the campaign is loaded, but will shut themselves down as soon as they are no longer needed.
out("TP_Achivement Fix: Script load");
function tp_yta()
    out("TP_Achivement Fix: Script initialises");
    
    if cm:query_model():campaign_name() == "3k_dlc04_start_pos" then
        --MoH startpos detected. Our achievements are all for the zhang brothers, so lets only fire listeners when they are being played.
        local faction_zhang_bao = cm:query_faction("3k_dlc04_faction_zhang_bao")
        local faction_zhang_liang = cm:query_faction("3k_dlc04_faction_zhang_liang")
        local faction_zhang_jue = cm:query_faction("3k_dlc04_faction_zhang_jue")

        if faction_zhang_bao:is_human() or faction_zhang_liang:is_human() or faction_zhang_jue:is_human() then
            listener_setup_dlc04();
        end;        
    end;
    
    core:add_listener(
    "FactionDied_achievements_fear_the_tiger",
    "FactionDied",
    function(context)
    if (cm:query_model():campaign_name() == "3k_dlc05_start_pos" and not cm:query_faction("3k_dlc05_faction_sun_ce"):is_null_interface()
        and not cm:query_faction("3k_dlc05_faction_white_tiger_yan"):is_null_interface()) then
        return (cm:query_faction( "3k_dlc05_faction_white_tiger_yan"):is_human()) and (context:faction():name()=="3k_dlc05_faction_sun_ce")
    end
    return false
    end,				
    function(context)
        self:award("TK_DLC05_ACHIEVEMENT_YAN_BAIHU_DESTROY_SUN_CE");
    end,
    true
);
    
end;


function listener_setup_dlc04()
    out("YTA: Listener function called, setting up listeners.");

-- For Achievement 'There Will be Fish Every Year'   
    core:add_listener(
        "ytr_port_check",
        "FactionTurnStart",
        function(context) return context:faction():is_human() end,
        function(context) 
            local region_list = context:faction():region_list();
            out("YTA: playern turn, checking for fishing port");

            for i = 0, region_list:num_items() -1 do
                local this_region = region_list:item_at(i);
                
                if this_region:building_exists("3k_district_market_harbour_fish_5") then
                    out("YTA: fishing port building identified, awarding achievement, closing listener, shutting down loop");
                    cm:modify_scripting():award_achievement("TK_YTR_ACHIEVEMENT_OWN_FISHING_PORT");
                    core:remove_listener("ytr_port_check");
                    break --we do not need to loop anymore
                end;
            end;
        end, 
        true
    );


 -- For Achievement 'Vase on a Table'   
    core:add_listener(
        "ytr_hq_check",
        "FactionTurnStart",
        function(context) return context:faction():is_human() end,
        function(context) 
            local region_list = context:faction():region_list();
            out("YTA: playern turn, checking for HQ");

            for i = 0, region_list:num_items() -1 do
                local this_region = region_list:item_at(i);
                
                if this_region:building_exists("3k_ytr_district_government_organisation_yellow_turban_5") then
                    out("YTA: HQ building identified, awarding achievement, closing listener, shutting down loop");
                    cm:modify_scripting():award_achievement("TK_YTR_ACHIEVEMENT_OWN_YTR_HEADQUARTERS");
                    core:remove_listener("ytr_hq_check");
                    break --we do not need to loop anymore
                end;
            end;
        end, 
        true
    );

-- For Achivement 'Store Some Ice'.
    core:add_listener(
        "concealed_fort_check",
        "FactionTurnStart",
        function(context) return (context:faction():is_human() and context:faction():name() == "3k_dlc04_faction_zhang_liang") end,
        function(context) 
            local region_list = context:faction():region_list();
            out("YTA: playern turn, checking for fort");

            for i = 0, region_list:num_items() -1 do
                local this_region = region_list:item_at(i);

                if this_region:building_exists("3k_ytr_district_military_yellow_turban_caches_5") then
                    out("YTA: Fort building identified, awarding achievement, closing listener, shutting down loop");
                    cm:modify_scripting():award_achievement("TK_YTR_ACHIEVEMENT_OWN_CONCEALED_FORT");
                    core:remove_listener("concealed_fort_check");
                    break --we do not need to loop anymore
                end;
            end;
        end, 
        true
    );

-- For Achievement 'Dù Zǐténg Will See You Now'   
    core:add_listener(
        "house_compassion_check",
        "FactionTurnStart",
        function(context) return (context:faction():is_human() and context:faction():name() == "3k_dlc04_faction_zhang_bao") end,
        function(context) 
            local region_list = context:faction():region_list();
            out("YTA: playern turn, checking for house of compassion");

            for i = 0, region_list:num_items() -1 do
                local this_region = region_list:item_at(i);

                if this_region:building_exists("3k_ytr_district_government_rural_healers_5") then
                    out("YTA: Compassion building identified, awarding achievement, closing listener, shutting down loop");
                    cm:modify_scripting():award_achievement("TK_YTR_ACHIEVEMENT_OWN_HOUSE_OF_COMPASSION");
                    core:remove_listener("house_compassion_check");
                    break --we do not need to loop anymore
                end;
            end;
        end, 
        true
    );

-- For Achievement 'River Crab Pond'  
    core:add_listener(
        "garden_peace_check",
        "FactionTurnStart",
        function(context) return (context:faction():is_human() and context:faction():name() == "3k_dlc04_faction_zhang_jue") end,
        function(context) 
            local region_list = context:faction():region_list();
            out("YTA: playern turn, checking for peace garden");

            for i = 0, region_list:num_items() -1 do
                local this_region = region_list:item_at(i);

                if this_region:building_exists("3k_ytr_district_government_yellow_turban_gardens_5") then
                    out("YTA: peace garden building identified, awarding achievement, closing listener, shutting down loop");
                    cm:modify_scripting():award_achievement("TK_YTR_ACHIEVEMENT_OWN_PEACE_GARDEN");
                    core:remove_listener("garden_peace_check");
                    break --we do not need to loop anymore
                end;
            end;
        end, 
        true
    );
 
-- For Achievement 'Don't Cheat At The Games'
    core:add_listener(
        "communal_square_check",
        "FactionTurnStart",
        function(context) return context:faction():is_human() end,
        function(context) 
            local region_list = context:faction():region_list();
            local communal_square_count = 0;
            out("YTA: playern turn, checking for communal squares");

            for i = 0, region_list:num_items() -1 do
                local this_region = region_list:item_at(i);

                if this_region:building_exists("3k_ytr_district_market_inn_yellow_turban_5") then
                    local temp = communal_square_count
                    communal_square_count = temp + 1;
                    out("YTA: increment square count by 1");
                end;

                if communal_square_count >=7 then
                    out("YTA: community square limit hit, awarding achievement, closing listener, shutting down loop");
                    cm:modify_scripting():award_achievement("TK_YTR_ACHIEVEMENT_OWN_X_COMMUNAL_SQUARES");
                    core:remove_listener("communal_square_check");
                    break
                end;

            end;        

        end,
        true
    );

-- For Achievement 'Double Happiness'
core:add_listener(
    "prosperous_farm_check",
    "FactionTurnStart",
    function(context) return context:faction():is_human() end,
    function(context) 
        local region_list = context:faction():region_list();
        local protected_farm_count = 0;

        for i = 0, region_list:num_items() -1 do
            local this_region = region_list:item_at(i);

            if this_region:building_exists("3k_ytr_district_residential_farming_yellow_turban_5") then
                local temp = protected_farm_count
                protected_farm_count = temp + 1;
                out("YTA: increment farm count by 1");
            end;

            if protected_farm_count >=8 then
                out("YTA: prosperous farm limit hit, awarding achievement, closing listener, shutting down loop");
                cm:modify_scripting():award_achievement("TK_TYR_ACHIEVEMENT_OWN_X_PROSPEROUS_FARMHOLDS"); --award achivement
                core:remove_listener("prosperous_farm_check"); -- shut listner down.
                break --stop looping.
            end;

        end;        

    end,
    true
);


end;

--194 Gao Gan dupulicate charaters
local function Gao_Gan_194_fix()
    if cm.name == "dlc05_new_year" then
    --gao_zhulan
        local query_character = cm:query_model():character_for_startpos_id( tostring("1090552894") );
        local query_character_sec = cm:query_model():character_for_startpos_id( tostring("59371312") );
        if (not query_character == nil or query_character:is_null_interface()) and (not query_character_sec == nil or query_character_sec:is_null_interface()) then
            cdir_events_manager:kill_startpos_character("59371312", false)
        end
    --deng_sheng
        local query_character = cm:query_model():character_for_startpos_id( tostring("1212494613") );
        local query_character_sec = cm:query_model():character_for_startpos_id( tostring("747672598") );
        if (not query_character == nil or query_character:is_null_interface()) and (not query_character_sec == nil or query_character_sec:is_null_interface()) then
            cdir_events_manager:kill_startpos_character("747672598", false)
        end
    --quan_rou
        local query_character = cm:query_model():character_for_startpos_id( tostring("1218945454") );
        local query_character_sec = cm:query_model():character_for_startpos_id( tostring("969376038") );
        if (not query_character == nil or query_character:is_null_interface()) and (not query_character_sec == nil or query_character_sec:is_null_interface()) then
            cdir_events_manager:kill_startpos_character("969376038", false)
        end
    --ying_shao
        local query_character = cm:query_model():character_for_startpos_id( tostring("1730302531") );
        local query_character_sec = cm:query_model():character_for_startpos_id( tostring("315853628") );
        if (not query_character == nil or query_character:is_null_interface()) and (not query_character_sec == nil or query_character_sec:is_null_interface()) then
            cdir_events_manager:kill_startpos_character("315853628", false)
        end
    end;
end

cm:add_first_tick_callback_new(function() Gao_Gan_194_fix() end)
local gst = xyy_gst:get_mod()

local function region_set_manager(region_key, faction_key)
    if cm:query_region(region_key)
    and not cm:query_region(region_key):is_null_interface()
    and not cm:query_region(region_key):owning_faction():is_human()
    and cm:query_region(region_key):owning_faction():name() ~= "xyyhlyjf"
    and cm:query_region(region_key):owning_faction():name() ~= faction_key
    then 
        if not cm:query_region(region_key):owning_faction()
        or cm:query_region(region_key):owning_faction():is_null_interface()
        or cm:query_region(region_key):owning_faction():faction_leader():is_null_interface()
        or cm:query_region(region_key):owning_faction():faction_leader():generation_template_key() ~= "hlyjcm" then
            cm:modify_region(region_key):settlement_gifted_as_if_by_payload(cm:modify_faction(faction_key));
        end
        ModLog("设置领地：" .. region_key .. "交给" .. faction_key);
    end
end

local function region_set_random_manager(region_key, faction_key)
    if not cm:query_region(region_key)
    or cm:query_region(region_key):is_null_interface()
    then
        return;
    end
    if cm:query_region(region_key):owning_faction():name() == faction_key
    then
        return;
    end
    local random = cm:random_int(1000,1)
    if not cm:query_region(region_key):owning_faction():is_human()
    and cm:query_region(region_key):owning_faction():name() ~= "xyyhlyjf"
    and cm:query_region(region_key):owning_faction():faction_leader():generation_template_key() ~= "hlyjcm"
    and random > 200
    then
        cm:modify_region(region_key):settlement_gifted_as_if_by_payload(cm:modify_faction(faction_key));
        ModLog("设置领地：" .. region_key .. "交给" .. faction_key);
    end
end;

local function region_force_set_manager(region_key, faction_key)
    if cm:query_region(region_key)
    and not cm:query_region(region_key):is_null_interface()
    then
        cm:modify_region(region_key):settlement_gifted_as_if_by_payload(cm:modify_faction(faction_key));
        ModLog("强制设置领地：" .. region_key .. "交给" .. faction_key);
    end
end;






-----------------------------------------------------------------
--  Register
-----------------------------------------------------------------

gst.region_set_manager = region_set_manager
gst.region_random_set_manager = region_set_random_manager
gst.region_force_set_manager = region_force_set_manager

return gst
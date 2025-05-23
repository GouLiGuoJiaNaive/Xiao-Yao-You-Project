xyy_gst = {
    _VERSION = "8.15.0",
    _CTREST_TIME = "2025.05.05"
}

xyy_gst.loader_env_0 = getfenv(0)
xyy_gst.loader_env_1 = getfenv(1)

local replace_thread_env = true

if replace_thread_env then
    setfenv(0, xyy_gst.loader_env_1)
end

local prev_package_path = package.path
if not package.path:match("script/campaign/mod/xyy") then
    package.path = package.path .. ";script/campaign/mod/xyy/?.lua"
end

local gst = {
    _VERSION = "8.11.0",
    _CTREST_TIME = "2024.12.07",
    _RELEASE = "development"
}


function gst.get_locale()
    local surname = effect.get_localised_string('names_name_2012172474')
    if surname == "刘" then
        locale = 'cn'
    elseif surname == "劉" then
        locale = 'zh'
    else
        locale = 'en'
    end
    return locale;
end

function gst.character_browser_disable()
    cm:set_saved_value("xyy_character_lottery_pool", {})
    cm:set_saved_value("character_browser_list", {})
    cm:set_saved_value("xyy_character_up_pool", {})
    cm:set_saved_value("selected_up_character", true)
    cm:set_saved_value("xyy_store_ready", true)
    cm:set_saved_value("character_store_disable", true)
end

function xyy_gst:get_mod()
    return gst
end

require("xyy.xyy_character_manager")
require("xyy.xyy_ui_manager")
require("xyy.xyy_region_manager")
require("xyy.xyy_faction_manager")
require("xyy.xyy_db")
require("xyy.xyy_lib")